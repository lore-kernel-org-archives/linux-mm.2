Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A5FED7B96
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003D66B0088; Tue, 14 Apr 2026 06:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DE66B008A; Tue, 14 Apr 2026 06:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33B56B0092; Tue, 14 Apr 2026 06:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D48C96B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:22:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80B5F8BC3B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:22:12 +0000 (UTC)
X-FDA: 84656771304.02.527E9A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E50D140004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:22:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TTc9XV9u;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776162130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BckpnXSCVQvxxavP5rvqgYmN6kasGEX6+ue3Zi6tRyM=;
	b=xQj6KNhCv35EnWucJDdtklCYG22TJbaCEaN3FfS6lr96oKV+aQPPhd+DTLpqodTl2Vdc3P
	+2cxkHLiXbNqPkO/6ujo+XA0GPpVmg8N3WTPqZUUPVhMsRffwCoQUeXow4qR+OOo5MXg+2
	BXe9r92zdYmcI/QsQu96RhzCS3PzJlQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776162130; a=rsa-sha256;
	cv=none;
	b=N/waQP3lkflDFzLBzgug8I0qPclfkdpOnaRyxbkwxaMCkorR5mobsLAUfm1MG/TBxO8Le6
	mD0JPWMVYTWPLXm6MIaghniKDNLGOFTu/6VLBlRusHVOdULUvUQf7ch35lQ3UGvhUnuINw
	Fkeh1TVrARZ5bY45SADndmGiDwC/Lo8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TTc9XV9u;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776162129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BckpnXSCVQvxxavP5rvqgYmN6kasGEX6+ue3Zi6tRyM=;
	b=TTc9XV9u/mjd7Ckij7YmmggErysPO4ECfQ5iMlUrAgfcN4qJjyp8w/Aft3fC7zM4UxzELH
	fvkLh/BUb8tWsUeaaP40oPMY0t3qDTdGzUtO68Qy4Vx28xe1IdMzCbxamvnVAqq1h+hX5y
	V33RgYH7sWFZKGYYrTrwFEQnefd9aUk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-0uoQXl-5Mc2IUjl2lF4ncA-1; Tue, 14 Apr 2026 06:22:08 -0400
X-MC-Unique: 0uoQXl-5Mc2IUjl2lF4ncA-1
X-Mimecast-MFC-AGG-ID: 0uoQXl-5Mc2IUjl2lF4ncA_1776162127
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-43d7d0947aeso736534f8f.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:22:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776162127; x=1776766927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BckpnXSCVQvxxavP5rvqgYmN6kasGEX6+ue3Zi6tRyM=;
        b=PvKgyyLaW3ukjPH5rlC4yS+wnwnQJagSlKbdlzJrWlvJaI9W97KXcCT+6X7znT24x5
         fM10s5uFzsbtWz83ONT88U4inrytKnNLESEfbIKJkKk4CXRrlaNB9ZIZgtlNPKoVQb8J
         aJWEpSuMRaA2EBfWNKdXOrpjaBBR/kj1JGZEi0mILeGCvngXtcRZqFao20v8WU4BLpKn
         Zf8VPFUOIyNG1R1MZODi8LtMCoUege2PRC1jnwKz1udyd2qnliIN6uUbHsVREzmwlCLC
         UEpN1/N7IuX28ArbEGFcDM/+RcGhyC2cbv9iHZ4eRVYkgJDmpxkjLDPrDCdQqjTm8p3C
         ZbyQ==
X-Forwarded-Encrypted: i=1; AFNElJ+C14JE9UQAkEbGUSwJi6bpCT0ksduilPtLhm8Y/bcCyEHK/wD8NyaaJTVLaau0nFdjtVus10Ft5A==@kvack.org
X-Gm-Message-State: AOJu0Yx3ni53mbjXMgsIJW0KqUUOBY+JWqJ2MY9iB9yQIg0PchtjoGUq
	peHO2mKBcGDQ3wi1oP85imVQ/cXAh3kQGReXF426cMmHIihTyl63uFIdX8XT17ncAueRQkPmD5x
	VQ87f/LEECxiVDjZEzFMAbZ7/C6aes3vpQeGdmM8GmR1zEBsd1mGS
X-Gm-Gg: AeBDieuge6koWTKemL/NnMP3gYiSCnfHMZrmsYUQuxOJn1f84fpF63arrBfETZsf7O/
	cWCeW8fQCBUzT3xJpWBVh6WpFZQy40uPSiQI7Fwu3LzGenojyUVRXBPp0Ew9VOZltlLcaqVXcXV
	Jk5ETms9KkSn7/z/V4D0LryROhgbS3396YodjKHDrNn7kKDKMP7iIT7TU7TZLwKgVrpC4hh4PBf
	kJgG+J4SREakghzphDi8Dj7dkznURdrCjPLPW8AMAe86wAo427AHV3bMzY8PR85hL3PrEBoYCMa
	tP7pjdQgXCMMfpUQjNATpIFrEtThHUHr1uDWoOEmzpv4nts5uoNEY6o0RGyXthVaP1dKOyoEahY
	+4MZdI06Xd8stBLNrtgYc6I9504qKP9dsZMHOY3Jy3cE=
X-Received: by 2002:a05:600c:c094:b0:488:cc72:5497 with SMTP id 5b1f17b1804b1-488d6ad5ed3mr156716785e9.31.1776162126937;
        Tue, 14 Apr 2026 03:22:06 -0700 (PDT)
X-Received: by 2002:a05:600c:c094:b0:488:cc72:5497 with SMTP id 5b1f17b1804b1-488d6ad5ed3mr156716545e9.31.1776162126454;
        Tue, 14 Apr 2026 03:22:06 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d67b128dsm194935355e9.2.2026.04.14.03.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 03:22:05 -0700 (PDT)
Date: Tue, 14 Apr 2026 06:22:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 2/9] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <20260414062015-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
 <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
 <20260413163233-mutt-send-email-mst@kernel.org>
 <244c9779-b4a5-4d0f-9eb9-ef0ec873e0f6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <244c9779-b4a5-4d0f-9eb9-ef0ec873e0f6@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LQLaaiOj5rQxhptx4_5sORckz5aKkyA4fpBQFzWzizc_1776162127
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 1E50D140004
X-Stat-Signature: jhqy58wb4ijeokbegejb3ofjagy6e4so
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776162129-202671
X-HE-Meta: U2FsdGVkX19IxlNKwo0HgC2auXW4Yfp3jGsD1FM1Psol5ttB/Ou9lqhIkuvzqL9XIk9cgArlSosgzrXfzw0+hxXhNkmsPRYY1fqQzNpltvaIcNR+tUVzx4s9IGrJdymbNkTHqcb+yGajVzrKUxcEzeygNUYZSpWWeCOX+yi21Dxft4BHPIsgkpHq/p6VCGTAEV1zsz+j9ey+41/l+NtxUnT9w4H16HuoEf5ybV3mC6pIdywdI0f8SMa0waWu/1SIiLkrCWUY1HD8TsRelBibX3Yf7AyqWpt0yfc7SiYNuGdDTeZ2McCyI5sAYWS7I1e4x295vY1M/0pCp2YXHBtrjvo9hzhfE9UJXsGQ9KjTyazhktnaACDAC9MxNWNYa/MxX8axjU5Zm2dboKnmIk6g29Jt8EKGWNoLXSCtGIc7Bl8VRxdRKrql1k70bgD6M+uvNX13eQeplyBa4KfC5a4Kob/PPnRmm0eTjAc40hf+QYnSc3O5TQ2POPHtU9EHzrxlsK/mvMwibT8rINx+J+zn7b/apStAbtes62yzvCQxKqBEpR7uayNrz9JdtspCWhSQGVjtlnJytfw1RbqrHyhAaiZvmAhosfjzfaLK7DpfsCJ1UOuTUxf0SrnpvhI1a1FYKXeDLQnq36VBTuZGKobSTPt2c1JWO16bDuLftVL5nV/ISuTYTvHdq2y99Fwrj9GccOFVAmAEO4kjsmXCikuccQrYse6u8wxVPK9rZ38GPU8qyl7Br9+hgzvTQh5ZvncoGDNAmAaspSX7neewAWCcSMfD45Osv3xClvmRS0ED9jJHewGvOxwntqB3DPbxmDU7yd/ag+3ThS5jIpYfScyTCLjqe94UgjufjgoBIGw1Yhl3fpqJbYumqbiDGdkAG4p70BRjHVYVK7AklLYimzjT4mqeBFkhZm23dZ+xbZQfex9F4AIjxgvXDwziIQrdNsK6MDn3VCztcudVfgGH5Lp
 FTEpWbCE
 ZFbU1ZHmvNtp3R7nvdvvoRyswGnNDxOa0KOT6+yPc9AJBJL13qqKgxJdE3hxvHR9nzJ+2qkTCeKqCiq2K8god54F8ITg5DOoemkWebjClW7zc4qWRMbA3JBEtpQJYKp0R9HG8BzI3jt0eAjSZuZt8o0J1yauZRi7O9me9xUjnAK00QKinOZfEwGM8rbZsHQ0QQxJzROsIkg4NTEl7M5SzgBpiqa6jUlLSaSGNG9rHBP/ykLxa9AmhS3zd6j0ZEv4+RN9l8kqkXslo3ZRlizzt7g9Lef8C/FmDZRUuKPBwnCkdUBpA52+u79WfM6BQQZ+axPLzg/OfjMs9mXNIy+T5lQdAzJi4j6xWRdirLK3BWxt3XGsncWj16XBBtUE/vyX8x8ZQi0981rbAWiIut2J2xUPZQJjofHFt8M1ejPrM0g5Umig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 11:18:02AM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 22:35, Michael S. Tsirkin wrote:
> > On Mon, Apr 13, 2026 at 10:00:58AM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/13/26 00:50, Michael S. Tsirkin wrote:
> >>> When a guest reports free pages to the hypervisor via the page reporting
> >>> framework (used by virtio-balloon and hv_balloon), the host typically
> >>> zeros those pages when reclaiming their backing memory.  However, when
> >>> those pages are later allocated in the guest, post_alloc_hook()
> >>> unconditionally zeros them again if __GFP_ZERO is set.  This
> >>> double-zeroing is wasteful, especially for large pages.
> >>>
> >>> Avoid redundant zeroing by propagating the "host already zeroed this"
> >>> information through the allocation path:
> >>>
> >>> 1. Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
> >>>    drivers to declare that their host zeros reported pages on reclaim.
> >>>    A static key (page_reporting_host_zeroes) gates the fast path.
> >>>
> >>> 2. In page_del_and_expand(), when the page was reported and the
> >>>    static key is enabled, stash a sentinel value (MAGIC_PAGE_ZEROED)
> >>>    in page->private.
> >>>
> >>> 3. In post_alloc_hook(), check page->private for the sentinel.  If
> >>>    present and zeroing was requested (but not tag zeroing), skip
> >>>    kernel_init_pages().
> >>>
> >>> In particular, __GFP_ZERO is used by the x86 arch override of
> >>> vma_alloc_zeroed_movable_folio.
> >>>
> >>> No driver sets host_zeroes_pages yet; a follow-up patch to
> >>> virtio_balloon is needed to opt in.
> >>>
> >>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >>> Assisted-by: Claude:claude-opus-4-6
> >>> ---
> >>>  include/linux/mm.h             |  6 ++++++
> >>>  include/linux/page_reporting.h |  3 +++
> >>>  mm/page_alloc.c                | 21 +++++++++++++++++++++
> >>>  mm/page_reporting.c            |  9 +++++++++
> >>>  mm/page_reporting.h            |  2 ++
> >>>  5 files changed, 41 insertions(+)
> >>>
> >>> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >>> index 5be3d8a8f806..59fc77c4c90e 100644
> >>> --- a/include/linux/mm.h
> >>> +++ b/include/linux/mm.h
> >>> @@ -4814,6 +4814,12 @@ static inline bool user_alloc_needs_zeroing(void)
> >>>  				   &init_on_alloc);
> >>>  }
> >>>  
> >>> +/*
> >>> + * Sentinel stored in page->private to indicate the page was pre-zeroed
> >>> + * by the hypervisor (via free page reporting).
> >>> + */
> >>> +#define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
> >>
> >> Why are we not using another page flag that is yet unused for buddy pages?
> >>
> >> Using page->private for that, and exposing it to buddy users with the
> >> __GFP_PREZEROED flag (I hope we can avoid that) does not sound
> >> particularly elegant.
> > 
> > 
> > So here's an only alternative I see: a page flag for when page is in
> > buddy and a new "prezero" bool that we have to propagate everywhere
> > else. This is a patch on top. More elegant? Please tell me if you prefer that.
> > If yes I will squash it into the appropriate patches.
> 
> I'd be interesting to know how this would look without the GFP flag,
> when we don't have to leak any of this out of the buddy.
> 
> -- 
> Cheers,
> 
> David

But the zeroing takes place outside of the buddy now, it's more
"reporting" than "leaking".

You mean, moving the zeroing into buddy?

See

https://lore.kernel.org/all/20260413184022-mutt-send-email-mst@kernel.org/


-- 
MST


