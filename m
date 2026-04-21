Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D84F8FA7B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2CD6B0088; Tue, 21 Apr 2026 09:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296926B008A; Tue, 21 Apr 2026 09:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182E76B0099; Tue, 21 Apr 2026 09:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 082C16B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:44:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A42D140E86
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:44:25 +0000 (UTC)
X-FDA: 84682682490.27.4D6FAC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4BD4C16000F
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:44:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C6fiMTgC;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776779063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7eTbL6D9GOrwEMsjXolvuGX1Lg2q3QX/lZ1+KzGMn9M=;
	b=wqaQXHAUW/5JFsymtz5HrjOIKsSsGp7jTsYknVBDcifPPUKgfKXUAz8EInFdYq4FPvgQwd
	vVPU0yDLvSE/zL1146SDyPPIE73IiZ0DfRxewtGCyV7AnG3v8URYti6ECO5a9Jnse1dOA9
	qCjOk5cJ/+rA6UQfV/ph4aYSkeR0/nk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776779063; a=rsa-sha256;
	cv=none;
	b=a5xJ2i2Ruuq+qQHzo+OMbbCv4IgnvnWCLrpjpzOqpaVJ4l8oqxSLYR/EKwDVIT8T+H/KDK
	QW7aTmsfJE8jwjLojjpFg13drFiIcwPC1VRIVAd8f9pW0DTpwTtSWOL8GX5h/ukb9eo0jp
	uRzohjnnOkxc4vN/VmgYSOrAXJcVYjs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C6fiMTgC;
	spf=pass (imf08.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776779062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7eTbL6D9GOrwEMsjXolvuGX1Lg2q3QX/lZ1+KzGMn9M=;
	b=C6fiMTgCJiUijww/vkwRgYNwGHxEMwyqUNC/gLIaLCFchtQb6NuELe1WHLRs9e5OJlRPtu
	2eLnQkiglt7AweJmwq8tElIl4usRgHtHzXj8kj/BVBynUGlwiLzmFH7PoAw2X5IAKNtnIv
	/b0k9OkQqTKPovBx9iQKjDpo4376D+g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-L78e5EBZNlOlzyGBb_Fitw-1; Tue, 21 Apr 2026 09:44:21 -0400
X-MC-Unique: L78e5EBZNlOlzyGBb_Fitw-1
X-Mimecast-MFC-AGG-ID: L78e5EBZNlOlzyGBb_Fitw_1776779059
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso27757605e9.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779059; x=1777383859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7eTbL6D9GOrwEMsjXolvuGX1Lg2q3QX/lZ1+KzGMn9M=;
        b=nCljvqaO/MKbUHKLlfHZyvm8XtZEFZ4KpyPmJ+sYh62vdEahhXwKaK5w2v2bgDMqeU
         ZJ0XGCIlrUbUyh9sUUFi+2j2gwlmeJa4d3IHXPgDm8Jixg2AYtbKMOTNEbY7C717vtz/
         9PXI/3m16szEZioSBAa4r49+6V1lGqvZn7Z7XZjocF473brl5VVKux5t1unttvRaAOIV
         lhRFDBkIbVjkbZj839aOlkwWT9OVbfZcBWyuMfaiZ0VkZ7+siUkZfTZ5bIRMDTA1UvNo
         1FRs5PcfLRwaXlXFHR3ovBzTovIVZggkoGT6HJ2OsCC1kCz3FD8EHJXxa/OyibYmBkuv
         SM5A==
X-Forwarded-Encrypted: i=1; AFNElJ+po2FwusvlEtt2WX8oycHAMVpfixDfHFk1FRS23PsQUuYH+lFBj1AgpL9J78zhmLK6csUCyrWUMg==@kvack.org
X-Gm-Message-State: AOJu0YzXj8UylITz7fYuaAd26FrSdCSk2vxDmzj9C+VncJCrIxRqOBhp
	jmP3tD+MG68jJCXhGLgJMS+cKA3wnQ+tZR5wiwtnLPi8HzQZZs9WuzLZbNiYWnAoREiKLj7/SSp
	jz8tLKfTYziQ5zbUpdgsqB39G6bRbJlkE1X1wYIjol6jTSqLoYQtm
X-Gm-Gg: AeBDieufAWrdLvLviLEa378dgoLV04nwZ69wuBB/jOYycgVypzzrMgkbx+UV5P4DpuH
	drMMkzlCeXfFbbufwnSWVNrrSzbGU5XGWaytfexFh1v0vwBsVTVDvE934eeA+wjS/17u6DTTo5t
	oqvQhBbGLLvy8Vf0EXRMI4Gi5e2S+r84uk179wkHpD0QquB8HbYcAVon/2C3xdH/X0VWDJFxcPC
	kGTqZTryvWWCapVvlkLcI8pkVjCBbHh7dDbmDm3Gi+YMgPckENFzimGXphm80aKJZd5DxkVEEHg
	VLm4ITDm8BC86ljN416BvxCfgu2qz9SxQ9fGSGNvLiNmskkQMF4s4JBiTKQ221wds6UcIbT1NUx
	2MZELge1s2MBBYAhWSCc822TmXAel14Qq2g9cPRmzy+53E87SwMJcaQ==
X-Received: by 2002:a05:600c:468c:b0:48a:56d5:16f2 with SMTP id 5b1f17b1804b1-48a56d5179amr32738325e9.7.1776779058371;
        Tue, 21 Apr 2026 06:44:18 -0700 (PDT)
X-Received: by 2002:a05:600c:468c:b0:48a:56d5:16f2 with SMTP id 5b1f17b1804b1-48a56d5179amr32737835e9.7.1776779057878;
        Tue, 21 Apr 2026 06:44:17 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7b2716sm117377525e9.30.2026.04.21.06.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:44:17 -0700 (PDT)
Date: Tue, 21 Apr 2026 09:44:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and
 put_page_hint APIs
Message-ID: <20260421094049-mutt-send-email-mst@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com>
 <5f76af6e-9818-42ea-a305-c0fc1d920dca@kernel.org>
 <20260421091546-mutt-send-email-mst@kernel.org>
 <2a41dd0c-7ad8-4d34-8bab-a713e16c3b29@kernel.org>
MIME-Version: 1.0
In-Reply-To: <2a41dd0c-7ad8-4d34-8bab-a713e16c3b29@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -2Fdu8rVvv6ydIQJYp--hlbzlE3haceHe_BkEraU-Gw_1776779059
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 9t5a97idnz99hbpj85e7iahmu1d8zxy6
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BD4C16000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1776779063-462080
X-HE-Meta: U2FsdGVkX18XECxP0QNMrL6rPJQMzYY9GBCAzaCIN3WoG97vbbws5lhclOoPIzcTHYheiepERJ0r33xAsTkfWgluguKTwcnibMAGdywkPymeTrcFGNeVNC0qiaj9PF8j65ZJosK81g3kSYZlSAnT2GhSpejNVoJgz7u4LVHFh4qZQkwM+VIxvVg/z0KBuxyfoZhI6vpWqg1ijaTRfxbAcz3CL97txyho5WMRUBccSpEtx7nQvhzXWN+EkwDakN6kb0bgdSRKgzxc7Vu74FBP5YjhJJru0k10rfSsy9F2w0k5vSxOlAJhaPM9JA8VswIsQAYSrtSYW5Q4KTEB96itsd1LjpE7W8n4NlgNe+QwN1BezGLFIj+t/B+8Xjt+7+oxvePpdRbj/WYsgrUPjdYU2W92PoQkgjMWPxWX8jU41ehCReVscJx1Gt3QK5qgpGyu3fjwEQqs9wSxSViiRatfJfhs5HLLVml3lof/CTt/df+F1Fy93adUW4IttXf1EHAPO0FBg7xL11llTM9L26LgMa2zlywCrNe0jafRkpUdk2+frC38rNpldyOHvux4z6Gn1ond6Z2zeeqyyszp2STZBB2yPeh/DAJQYRB6v8pxNiCuKd0QIoEpGMWIeMyFfRu3GKqYVO8Ugi4qj4KbleoVeLC+2/eOa3+BSEmNMb52k1jTFEyGUOpfWZhxHOYjW9VkvqcbK8PM9Ysx5QGy7aYwmF5SH++h3827BB/CiZ6QzA4DTFsm++m7KqFjSHP5jZ0+5IXyIyMJwvSz1z1+3lqnV4z/y1F/Zi3H3u6KXvC7e4JLIXEpVx7vl15wYmnOmAmr7LA92QZcH5zZcegrsv7afFX3demo73ZJw+2vnfYHyeDm/jJIxYodR24rWx6+b9E74hViu2uTIz140cGkJJCaJVL5dHDptevzK3Lj07g4rPIjVSg3C3CEsj1PLER5CgY4dNIvUcW6z8cdbTpDXON
 PQmzNUmq
 l32mLGWRifeM/+4WmxkiGk6mN+pqyFAUko+/a7PfjugWV6c+REFuK5uwz483iaLdQYoq6jFBxdrCOV9wK0Lk9s7N5F0uLkpN6PIOSMEoDa8NAEP+0ntF2DOlcSRJFPVzsMjC/097VKivnMX00i53WgcG2ebqbQwI+eT58ploz+LUkjDamgufrKglSPvCoOZdlwH8aKhKp/yryGa84JcGRVIdCcV7AWjDvS3LbCIfSChw3asqc2EKEwR5FQrCaV7t6CCmlJlQ/JgIRvUDRJuJ/UzDdbmxHHWcoKXRWhPSnrAOBpVngKg017a2EFGA88NFavxbHdCQ/hiYTqx330urulIqiG+WsMotWWA3zk6SZo4DNZpB2OgHOcm9max8R2AKleIbb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 03:30:53PM +0200, David Hildenbrand (Arm) wrote:
> On 4/21/26 15:16, Michael S. Tsirkin wrote:
> > On Tue, Apr 21, 2026 at 12:56:00PM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/20/26 14:51, Michael S. Tsirkin wrote:
> >>> Add free_frozen_pages_hint(page, order, hints) to free a page
> >>> while marking it as pre-zeroed when PGHINT_ZEROED is set.
> >>> The PG_zeroed flag is set after __free_pages_prepare so it
> >>> survives on the free list.
> >>>
> >>> Add __folio_put_hint(), folio_put_hint(), and put_page_hint()
> >>> wrappers for the put_page path.
> >>
> >> Can we defer that change?
> > 
> > We can - it's a dependency of the balloon deflate, which you asked
> > me to implement. I'm more interested in reporting, myself.
> 
> Just to be clear, I said:
> 
> "I'd assume ordinary inflating+deflating of the balloon would also end
> up with pre-zeroed pages. We'd just need a (mm/balloon.c -specific)
> interface to tell the buddy that the pages are zeroed."
>
> So while I think there will be value in that in the futur once we
> figure out a clean interface, I don't recall asking you to implement that?


Right. you also said:

	Not blocking, but I don't want something that is too coupled to
	free-page reporting optimizations in the buddy. The comment above
	MAGIC_PAGE_ZEROED triggered my reaction.

so I interpreted this as meaning "it's nice to have (not blocking), but
you either need to implement this to demonstrate that indeed, it is not
too coupled, or prove in some other way that it is not too coupled".


> 
> -- 
> Cheers,
> 
> David


