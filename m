Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE769CCF9FE
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F218E00CB; Fri, 31 Oct 2025 20:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E70A8E0068; Fri, 31 Oct 2025 20:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224CE8E00CB; Fri, 31 Oct 2025 20:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8E18E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:02:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B1C988BD5
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:02:36 +0000 (UTC)
X-FDA: 84060086712.17.14BB3C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC0C2C0006
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:02:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vz86d8x6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761955354; a=rsa-sha256;
	cv=none;
	b=BIiVe9muW0mcHdJnvdEF+NPFsTDOGB4A1SnKIUOvBzMbMYuV7lC/0Nr3gWIfhLfP3L3OAz
	o+ijbej+fbVvK3wC9p6riafoLw27Q1wGK51ZOUJ2CPch04hNqXxGMGvo4/mUT7xwchbX7Q
	8SiKbA1hQTwSX0KuE+d6L64KisyVIGk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vz86d8x6;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761955354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlDUT4bys232sXchszUZSgh9Vu6w/oDBsexl0EZ+GS0=;
	b=YBIcogWMhrBYuCFdzrV4pxVC91uLCaV6a1JjzIUXmJ3fu0NYk0umjzdQFh495z+/fcYjwc
	FlbXXecva0ntHldYaD+srTEpwflzD2Yq0OclhHoTTqwQY/CsmFFQaPjYgOOiVQaiS1tgec
	Lsy8QGnJPeR8TLtzEsqC+YEO00sn/Bw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761955354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LlDUT4bys232sXchszUZSgh9Vu6w/oDBsexl0EZ+GS0=;
	b=Vz86d8x6AjfaRXq/bEzsep4OunJ6OVebtDMn4pBrVe6rJR6bWJR06VECWOi1TyJ6TN8brn
	NpYzq522Wy09BT+D3e3jEpx7EObWaXYFKxtBymHxPX2FqMpPSl92NPvvUYnVa+rnb64YgL
	PJMPK2mM08tSxUZukz1t0RWFKWmTUa0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-Mf9qvnDhMLqTIyKdwDXL3w-1; Fri,
 31 Oct 2025 20:02:30 -0400
X-MC-Unique: Mf9qvnDhMLqTIyKdwDXL3w-1
X-Mimecast-MFC-AGG-ID: Mf9qvnDhMLqTIyKdwDXL3w_1761955349
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8E313195608A;
	Sat,  1 Nov 2025 00:02:28 +0000 (UTC)
Received: from localhost (unknown [10.72.112.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 031401955BE3;
	Sat,  1 Nov 2025 00:02:26 +0000 (UTC)
Date: Sat, 1 Nov 2025 08:02:22 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH v2 2/5] mm, swap: Use SWP_SOLIDSTATE to determine if swap
 is rotational
Message-ID: <aQVODtKa/aVQtXik@MiWiFi-R3L-srv>
References: <20251031065011.40863-1-youngjun.park@lge.com>
 <20251031065011.40863-3-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251031065011.40863-3-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zuKiKXvEvnW3wcbAfGPYMtgd8s8rO9bYARptLSeA15Q_1761955349
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ac73cfh1zc88xr9amcqsen9q4cn8fp7c
X-Rspamd-Queue-Id: AC0C2C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761955354-508518
X-HE-Meta: U2FsdGVkX180Hx6oXU8pY14waATZTeZAE2VySXFsWFYio6/6jKh/cDqI13UtW2Hx7sHLi/iqT83hrs6b6LpbofLlRGW6zOwKZ8c3HMR1xvBOfytip4OF0Xwpxe/SAWFDnbNhkjb/4er2ZxBtdIq11FKnaEr6vd08+NnWIC6w5tqko6/4WyN2Js+BsezP+G4yoOhsCqs+xXKnaOhh51aDGEJwejVn9R5MjR3cpfOxyyBKhrXpz8GrlWelhNVs+gkTASveQZMxpMi5EljozT1EFHb9ePDPcUPdr662OI1cDA4lT03F97GZZFskGT9Gh/m8PWWfK1gXrg7mx9vWsVHjqk1vGsZiMcW56DD5DJ1j3cugk2nRpwPeSwD9+bA81MmeOsWMkT+z/zZc99eRpMuSKXvIPri5IWdWHjAenji3nVmb6g5+OEavSoegWnU8XAprP2TAjfzIXudmRybsEQsPZqjiWuP4j51XqKmVyBIarpBkZXerkiz1v73yOwPUfEPCGorEU2S+TB6AGm565OduM9LaC6gq5iIUfFtEmgYxjw2s3n9gZQqIV9IfLw7Mob5Sd/A2WeMtXQXDcok0vDmYs/ntrDp3FQ8kY/I/j5UCIhlmpjiOYwlm8jU695CX3n2xCMnLu7DshsLyZXL4ldeEsZ/3xdhYx9cF4Tzet3DIyvsXpsae+Fon8xKcYIylwssS7scbeswp+n8sO5EHzBpNrkfxSVQH4E+J70xUvGbn4apOEfEOAO54nfbTAQ+bQZIfaPacH2uGXlIf+J2mtflmq65AUU5Wo0zojP69qtG2E5bczqmf0DyUi8uP1PoCnmxNSM08nXtTyS/cNFoSLmkNKjtg8KBedt1dXSKdhsT2kKUo8nh6c8L1QpIKPORLad0TgCXvmUPswOM9UU9xaMhrhb3js7zIeh/or7kz9EU8xSRYis2oSmeLVsEtAZjVItoRKatY8K4+byQPmZB+U6J
 XxtmDF+f
 Te5Pvo9sfCooqr6rypJ6+DuMHGkE2CBbGvvsw9hL4qAfWOLlbVlyFBYuVT32y3QndjgIH6beXVf6Z6NwwqAzIyHfib7UahLfagugXJ29CHSOMqNhTMXpyFFvll8wykalvWx2CZj+aFjBMi/DOR3++5aH34Fwk5pzRUXXuXTi9LU0H45rRV52n/77YW4VdBjLHcrRMxrBRWs4KEN7+hds4uQJENzNXq341UUXL/0Hu/nwoD3UXJUb/yvmInWiKLh+WxK7YE8ROruil8wHIBb8Ue4z6K2CzvTIA6dunUMG1yR1lgF54JCDGuri7HIOMVuKJ9qC+OnySBSwRFtKHJkZlpHLlgS9ziqFzPqLudj+7ptTNKqhxOIz5mwmXR1CExG9qOVmSlZQHwcnSyAX3HJEQLxjhoCE2VxWcttgMp13M+8Z3ZmGWGyKdtnQzf4EVjCRZNX6A/3bsd7s1JO6bdtlGpg6ziOE+gn5pc/1v/MM2DL1PjfHjFxVGN9UNWzflfAw2T29l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 at 03:50pm, Youngjun Park wrote:
> The current non rotational check is unreliable
> as the device's rotational status can be changed by a user via sysfs.
> 
> Use the more reliable SWP_SOLIDSTATE flag which is set at swapon time,
> to ensure the nr_rotate_swap count remains consistent.
> Plus, it is easy to read and simple.
> 
> Fixes: 81a0298bdfab ("mm, swap: don't use VMA based swap readahead if HDD is used as swap")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index ed2c8e4edb71..b7cde8ef6742 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2913,7 +2913,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  	if (p->flags & SWP_CONTINUED)
>  		free_swap_count_continuations(p);
>  
> -	if (!p->bdev || !bdev_nonrot(p->bdev))
> +	if (!(p->flags & SWP_SOLIDSTATE))
>  		atomic_dec(&nr_rotate_swap);

Reviewed-by: Baoquan He <bhe@redhat.com>

>  
>  	mutex_lock(&swapon_mutex);
> -- 
> 2.34.1
> 


