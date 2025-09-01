Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B34DCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3758E0030; Mon,  1 Sep 2025 06:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573D38E0015; Mon,  1 Sep 2025 06:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463FD8E0030; Mon,  1 Sep 2025 06:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 306268E0015
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:16:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD81113B043
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:16:58 +0000 (UTC)
X-FDA: 83840278116.02.A093AD3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id ECB3240009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:16:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IbU3qXOj;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756721817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+1DlquKVk41/r6dL0vQTw41mvBrVwTTFhUlbS0w+mE=;
	b=PeceGbj+3kyyyKzn7u1EgfCP5c0hJWBPs8H8BMS44UXaecq3hvww70p0QY5TLCEOjp/ij1
	WVLOo/0Gup9xWjT72wtzCOWeKkxUnVJHSSSv9lY1LxUlcA3vdbExciz4zFuohaSwkUxXIX
	prdAo+2BrKAuoBzPHzHkEvppO5zNuQg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IbU3qXOj;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756721817; a=rsa-sha256;
	cv=none;
	b=L4qIPE9CYLmHVy+Aaj8DsfnWUUvNzI3QwB4hj04ZPRv+KHPUN0JzA+NGjWl40Z/v34I+uS
	IkpRmcAJE1nLgcHfLqy60d0qKrBlGZjIQcLF009OZDt8cgLbdhaK67DNWlja7uJREJ5z5T
	6UV626NGHbZJwhaBZrKCOTG65woaupY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756721816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B+1DlquKVk41/r6dL0vQTw41mvBrVwTTFhUlbS0w+mE=;
	b=IbU3qXOjMNuQXg098SDhGf/d1Y1Di1LrrA+LKcJ85KobDKjLhTY9dMg+HT8keSmz3DR+y4
	SyFaiMoB5hFa/TgG+9+lrJS7tJZ/QMVvknrLNFFMW+tYtLJJ9jRTWsCn/7aHOepZssq179
	ZatZHWC0hh+Ft7g6R858539+xu1rMzQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-vz1nJLrVNeWLtfTda_JN2g-1; Mon,
 01 Sep 2025 06:16:53 -0400
X-MC-Unique: vz1nJLrVNeWLtfTda_JN2g-1
X-Mimecast-MFC-AGG-ID: vz1nJLrVNeWLtfTda_JN2g_1756721812
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96AA0180028D;
	Mon,  1 Sep 2025 10:16:51 +0000 (UTC)
Received: from localhost (unknown [10.72.112.127])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61B0530001A2;
	Mon,  1 Sep 2025 10:16:50 +0000 (UTC)
Date: Mon, 1 Sep 2025 18:16:41 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in
 kasan_populate_vmalloc()
Message-ID: <aLVyia16eyoYftAw@MiWiFi-R3L-srv>
References: <20250831121058.92971-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250831121058.92971-1-urezki@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: q7qiwgos6nkyyojhgisgxcgui71y539q
X-Rspam-User: 
X-Rspamd-Queue-Id: ECB3240009
X-Rspamd-Server: rspam05
X-HE-Tag: 1756721816-702562
X-HE-Meta: U2FsdGVkX19dL0O15ltdKZnQqrv2C/YO0pttXjJD7OVGOes8ziTwxTtxlyhlqrOZPii+FCNgPmHts8n8vzdL8mMBD/4CwMmFyV7n6iLvgbL2l9a5G0Pt1uRpvxIS3C15JgsmXdIOr0aJWYvDw9c7VQ0AtY1L5YVmiyNI2DZfX/Yp9orQQ0GG8KdqG/0LVYmue78uIvE6ZxqrM6cyChp/N4PwAkO/MLc0204Fw/Xl9JCRlg0Ig8QB4lLHBseAhAILeLkU80HuRfSSIfmm8/SLuyYayqmZ5kzBFXYtug/lnS3A+ab3/2R7+yn3gOq4A747Z3V1ipBAbTYArqNqIvtMFYq7cGUyrHeuk3OVELe9aW8t55dc868Y853a+JeP1GOPZnkjV/+/jULKQuUvVmRvNXmgMJA9GXGkWQcK7xWnW7cbAcOBCLRMP+5KNJuCnTdkEFva0/YZWlpsKAlGJeBmDiii1QaT/tSHmclwR3B+0zme75tiUnUSVn3cmqEQJIeusXoZyifMoiX10qReQYfqnvbd54NZIMlknA2hJVftjlHwLfRbD8N1NFSDwqv/h6pDM+w3ggnG+/J3E8j8GO0Wz1fZugwTa4TTHSH+B5Xt6Vtw6E9+7H2riwrx4bZhfUIaaoDXgVoCzUs9B0ecQIiFrKHAZLNmRXVivTrKnvIB5/At2EE8hqQJ2Zo3HKurHfS6GqAqvf9pt1MGHgOk4BzKAzu5X16aWbEClmcMp7mim8Vq8cQksrxBLaB37By7I7X4P7PgQ3MBvzclThJsD904tHGkxNU3JVsVmkIi2BQje1WG3aqRUtWfz6PwHJQyJYGxnztR7yY0F/2Xo+PCePSVnu3gQtgyx+F/dw1h/ygnjcjRRhYIR10Dw81CFNVGlksuLCcqehH467EkgaOXhwO3Y/A7U0flfD5q7E88KbNFzbiJHszKPB1hzpGx/Y6u7kgUZED1GEvo3LI/IwS+dDU
 iQ2BZ4Yq
 UjjmHJqh37+I5M5UOip2emtRnUlZjyLB0I4KWLZgDTjRRKFLyMQkVeWuZ12e78Ci+ipO8DEQ3pdtqVkPA51UF0V/tFPW6oB0/6N1C36gOgLGrbRpJ0f9kbUha6xOHe+7L4U430rSFH0dxpiIj5iT6dcMEHM/rx1bznZF9KMcxVed8O1rgIHwezKyFfiw8d4LcnN53zVrCXDYWjzgpYROt/OEy0aOxtpYjTjxuDh0n+go92lD5zYZpEVcRJbu35lQ06BqiztJmfLJI9vC++EE1Bxn0AwnMfoJeck2TfkBQQnqZO9R8/6nhKE0n9pCQcKVP68c8RflLvVQ3uiQ2xuSGxa9rzrPMDJL8CYaDLpSCVII4quC4LkOTekCga/f08uP6jeqQCUQHBCET1SoNttEn+cSEcBElvrs0HChh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Uladzislau,

On 08/31/25 at 02:10pm, Uladzislau Rezki (Sony) wrote:
> kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
> and always allocate memory using the hardcoded GFP_KERNEL flag. This
> makes them inconsistent with vmalloc(), which was recently extended to
> support GFP_NOFS and GFP_NOIO allocations.

Is this patch on top of your patchset "[PATCH 0/8] __vmalloc() and no-block
support"? Or it is a replacement of "[PATCH 5/8] mm/kasan, mm/vmalloc: Respect
GFP flags in kasan_populate_vmalloc()" in the patchset?

I may not get their relationship clearly.

Thanks
Baoquan


