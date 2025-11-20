Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AC64CF64A6
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 02:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6A2E6B0030; Wed, 19 Nov 2025 21:47:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41E36B0031; Wed, 19 Nov 2025 21:47:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F146B0032; Wed, 19 Nov 2025 21:47:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C41896B0030
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:47:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E39812FC87
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:47:37 +0000 (UTC)
X-FDA: 84129449754.15.FEC3111
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 56C47140002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:47:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PGZ2gcXV;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763606855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6gl7I9Br4udYOjU41TcF7XC+Ahy/S62ybAb9DrdYcs=;
	b=TZxgTG76WD2S9zfvLgQj5em7m9XIdL11dBmEQDut3drn+XMhrSXwaYpVITMhXGPAJw4g0/
	78NyvqpXtm57nESKFBDTgglgDRNpzkMlWAlj19O2zNOy+2QEfrpw38CgTuQvdQSdQf+5N/
	0yA43RxrRBJgexIpGYsapPt0xLwAdgk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763606855; a=rsa-sha256;
	cv=none;
	b=xJWK5N5w58yJmrJZb0y63RmKiP38OOBu6aijJKryInf69v66LetWfTV3QPrJSFXs9cQlL/
	/SbApqhh3KCxOZkgy84sOPOfQSTHWR2bHuRCcimL0As9RaNmx6bAs0xoGuVVlNvfiRv4N3
	gQMmS1me/3hCFaOQzf1ElUjiG9HvOFo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PGZ2gcXV;
	spf=pass (imf23.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763606854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l6gl7I9Br4udYOjU41TcF7XC+Ahy/S62ybAb9DrdYcs=;
	b=PGZ2gcXVnn3Q+nW5esr22qNa86PZgGwZ8x8q2O2UaYVFhJpuvdfrGvh2Lovkag6hch3uzc
	Loa+gkaNyGN3BHn8Ni4y6HMA4dchLh65yShet3jzAvxdzGKjhowAbYYVn3FWPxgmfVS+Kf
	YgXf2PFezwd4VI8BoxjK/14CBKyHqd8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-lwKgXsjIPkWRDS69Y0jpeg-1; Wed,
 19 Nov 2025 21:47:29 -0500
X-MC-Unique: lwKgXsjIPkWRDS69Y0jpeg-1
X-Mimecast-MFC-AGG-ID: lwKgXsjIPkWRDS69Y0jpeg_1763606847
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CC6B195609D;
	Thu, 20 Nov 2025 02:47:27 +0000 (UTC)
Received: from localhost (unknown [10.72.112.60])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D93819560B0;
	Thu, 20 Nov 2025 02:47:25 +0000 (UTC)
Date: Thu, 20 Nov 2025 10:47:20 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
Message-ID: <aR6BOK+DbGyMNrTd@MiWiFi-R3L-srv>
References: <20251119114136.594108-1-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251119114136.594108-1-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dZgtOnFGhwhd2lhS0kIopXbc2WEkIn80_P53m2zKkKk_1763606847
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 56C47140002
X-Stat-Signature: 6atx13w7tz7sx7e7axkjm9y9esh68xxa
X-Rspam-User: 
X-HE-Tag: 1763606855-544038
X-HE-Meta: U2FsdGVkX18M746pnlSUQWVDFcBWQGwx317IQqKoPxTZBLnW7xmZ9QJIztGeqIH19n847PoVpkywKgWZyHg60rP99dxTzoaz6nNLTazyE8rE1vMAPwHB+7M8d3GNBuyfIg+PE9kI21RM8b6Mi4em4xJ2zdLgBih2IfyUnAt3zVIwP8dcBaeJzIT4otVyxk/LziIaabDjUcChRGYrLntr2R8PktOajm7jPLQHX/es7+sQ+CDDSQK3E0N9/hrWEZ6RKvz+bFwMM2KfaASuYGs3Y+OJ3qJTuuZtnz2JxN4ij1YD8FpLYbvJEkoxGhafdlWaEwIshG1tWQ3F8mrSW7VeRDlu5uC9yXtHMQGFflxj7Tu8lN08S6hB5O34LGXy7oYu/5ESifnm/ZIwUv/zqSSbzAcmhNIaHFyEo8o6OOs0rfKlYfngilXX8gciNZCt02IbqKROfTmbMeNN7z7nyX9B3rE5yvdqjo9CwrKbd2iOZmw9vwjhXm0FzfRsoDGlyelRnRO57vLeJvGxPXl1RpXMKE0LbzThZw6rSUOM8eN0iinv2Da2i0RsDPfdrcczH2LjN/xzL1bedqZUzZ/K6n8H86EGVps7A0Og5WhjLiA2sxeZvRot7/+mZHn3oujIpXouyMDZ+pWmJPtf6IprTnILwGCQCDcZD9Zs0QKjON47AvGM9Hqn2jX7QdlqRzSWdR+Khdnt2i+Qb+KZnbTtmhH07RdnPmWnkKcqpzYaIY96+njcbf5F5aRqwlOuHYirwFrVPDthR50bR+daVB8RLy1ocUS6toyRZy3Xih7hxQifaMUM4eNdAJHkvp8EKKeaQHanQNXYNfE3bnlCftfbAwXdp+XEHwqalYaKdSvmL/u7BWXA7lJswz9tTFc1ATBE9kL1o9KdBKhlqkyaUYV9wpTIfNEmfEbAS3vrtBQzTftZNABy6TeJyaGGd2G3tXGToDl524FhSSPdAX1Q+LCLDl3
 IaSDyai4
 xzNVRH5w1claQtlyu4Qep0j0vBNbcIsDJLdth8ZCsF2FiIA8aNM6c7YJSRZLr4McsbqDh0zJzh0YPUY0S8e4reqDBkcqMzOZlZpUJGq5GLN58XtJNJweuZ+tzSf8QBsgWTdAeL4zKd83luqEeHUcZyWNS4CuC8puhuA3heNyta6aiykIP7e5XUqWxVw9H0WSwN6Cgb7TCGThK3+6UPbOXMOf1nFYwipipuNjmgNdOUWiuyuIwW68EdxWL/EKH6HtSnKeZvDE6+HcTgsvvyU6NWSQPnX5pcPKVX6Ss2s8yP1/bH0JecvNODEADifkd/UW8xzJ3pJiT7VfO+g8dohxOysU3W6KjlxjmKP8vi6KLPt8ZN/vzdU2BLe6/dah6W8EUTboNCbQ42KSaNPIkM1NJb8uoAqdq+sgO3P0fcbCR+qQCClNObJam/cpSzJHyct0CVFqUxa7p2CFJkw4MYKXqQE24tUWK9hCH09aklKTfyiKzY6qg44caJbnPOb/pUq9mJxJ2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/19/25 at 08:41pm, Youngjun Park wrote:
> swap_alloc_slow() was checking `si->avail_list` instead of `next->avail_list`
> when verifying if the next swap device is still in the list, which could cause
> unnecessary restarts during allocation.
> 
> Fixes: 8e689f8ea45ff ("mm/swap: do not choose swap device according to numa node")
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for the fix.

Reviewed-by: Baoquan He <bhe@redhat.com>

> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94e0f0c54168..cf780fefaf7d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1374,7 +1374,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>  		 * still in the swap_avail_head list then try it, otherwise
>  		 * start over if we have not gotten any slots.
>  		 */
> -		if (plist_node_empty(&si->avail_list))
> +		if (plist_node_empty(&next->avail_list))
>  			goto start_over;
>  	}
>  	spin_unlock(&swap_avail_lock);
> -- 
> 2.34.1
> 


