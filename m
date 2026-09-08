Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA56AC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABE66B0096; Mon,  7 Sep 2026 21:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82C26B0099; Mon,  7 Sep 2026 21:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99526B009B; Mon,  7 Sep 2026 21:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 953BE6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:35:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07A3440361
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:35:44 +0000 (UTC)
X-FDA: 85188878208.02.1FC6EAE
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 34CBF40006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:35:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TBKxi8la;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788831342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+ILT61+yX00t8m/Wo8aU1Ak3a6FiC5+l5Al1tpUFdU=;
	b=O9z+IZ4Ev8raPYBjiJdx58tcggR9h3R1vesNOy96m6TzLssZSf6v7dEZdVwEksHZWhiDpg
	EMuIehodtpO4TE05ZJOhUpgyxhcr6PaYUG42sUXaVAfQoBuCKiKBHb7WZMDkbGMLSp/eJz
	WBfp9p/9VnpXbaoSvXtv3ugdmaebLSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788831342;
	b=Vl/yw7rxM5ZOqNbj/dTIITSCpmI9nFhQ/gRYPV85UVQ6+6BbLdW+PojiwliO+MWwLMUNp6
	c3oqDSkjsYF5EfGC7y2Z24C0JPtOMWANLxNLbx0c2JakcFgoA0WLepzmVXKkwDjzEw4q29
	El6UcXcFAR/k8lNXCxQcuTy1PNmlfeY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TBKxi8la;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-398a5aad413so3056911a91.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 18:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788831341; x=1789436141; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r+ILT61+yX00t8m/Wo8aU1Ak3a6FiC5+l5Al1tpUFdU=;
        b=TBKxi8lab0xifGS+hTdG6ua2ARZTDfTsqK/Et3l0sbMMhfQ+9DQxiqOjgqsm+0tjX8
         M8h7lkMRbcF7zJMJ2RyYB/g7ZTcXlmPD+9aJxoyHOdMj1pxiFZ447UkB2XVA2prTZndl
         k5n3JP10X55RYRcJle1afuUBl5L1hP4OGwNiiRsD1ZcEM7DRL6iVY6Uc60BFY/pheZF5
         D5/q3mDiHmLUGhqpK53HTcOhkwYIiy6mglPmlkPJh5bZ83ZIkDjJwicq2Q94vtvCaH8H
         hne2fw/a+Y06F4dPuAQ7IMCwo5gABph+9Dy3h7mLpaegiKtguWYKyMV53J0D8SY8lWNW
         Mx1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788831341; x=1789436141;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r+ILT61+yX00t8m/Wo8aU1Ak3a6FiC5+l5Al1tpUFdU=;
        b=N14fv6QTJ2aBqyI8JTv1sKUUb82oKZ7vfY/y+DUQiB69xcLS5qUUdysp2Ww00G5oF7
         a+J0JIgQba55qzZl7hwZaJzXzR2QvTIQDWRXnd2XBjCcAZIfP6UNK9CEkR+Lqd2PMK6x
         ovAi3AB751kZGdUD/3r9S2ufVXqeoLgwMmwCthhqq2crf6qe9OJeI6beGeaGHLbtzXfb
         xqySX/DvBsa1EtW7Myw9wGUaR1xE4j3Qqh2oGnYmMitQIhsievPqdmKgkRGVuOgOBjB+
         IKlf8BX/asTZX80RXk3E+fJn2JzSMaTZTwvFPkMW7B2W1MJi6O0xXMDrAPkVj5TqdNZF
         M4VQ==
X-Forwarded-Encrypted: i=1; AKwUvBxjj4vEJAgWSMC6fysVBA00qrIIG3NGLPWuQr0wW0ph4E6mTxQ6YhQQYQOFZfo6fT/QtxDyHQvMXg==@kvack.org
X-Gm-Message-State: AFuF++kmzTJsV0SGWIF0H2H9V92uoeRpyleh8V7mCO3ivvmRhw/jVCZu
	qsStZu/CUhl9BgIu+TV8QTKlSggPToWfUpeJTneKLkX7AdkkJKnPdAWV
X-Gm-Gg: AYBFou3fGdujbppmJtfOWvrlHQpkCExxy6sjmWICrK5ZN9UaG3u1LDqZtn9GkSyrQ/v
	IWrqXP+v2cKcaA9p/qBzS6/r+ywqXIUpTno3ZEbA0cqDQOl5Uuc1ImpKkSTBJqxTuVEm2MI5aPe
	JOgowhvuramyg0zZcEVW4riJqxgCTAHUA7dwcHhnuikiGBRHAgG3+kqDDrnvWeeiudC4gLKnJ4L
	YYLXi6omY17qcBGNo9OOyYpUWov3+6U2UBiVsQ0/qp6DQ+FM8aPBcx91JqS4jVDL0BOnqZVcfcp
	z1Eu/B+ghnfyVx6x4F1M8KdDgv8RRM/7Lt9PfYvTFoVmefcDgsdesG2EqnMtabcy96e0eWnQWBN
	COEUUQ4Fhgd+0kKMLt+tJeCux9c0mmz7aVhJ9sISNPIX1XYokzsoMoBTeeaCG0Oe89PgGKCAUQK
	S3pOp6NnzXwCLSGBn/inmh0hb9TyP2UPiPCplGvjzcmpOP0fyuMTb71mhmh2k15Zs4/R+KicWUH
	K0=
X-Received: by 2002:a17:90b:33c1:b0:398:9bd1:3214 with SMTP id 98e67ed59e1d1-39b262dfa81mr36200845a91.21.1788831340752;
        Mon, 07 Sep 2026 18:35:40 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b2615039asm23586291a91.15.2026.09.07.18.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:35:40 -0700 (PDT)
Date: Tue, 8 Sep 2026 09:35:33 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v4 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <047c287f-bb00-4672-9ab8-3323cbae8f2e@gmail.com>
References: <20260828055926.346744-1-vernon2gm@gmail.com>
 <20260828055926.346744-2-vernon2gm@gmail.com>
 <53f3afde-b5a7-4c2e-b6b5-8c844d1b6c8e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f3afde-b5a7-4c2e-b6b5-8c844d1b6c8e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 34CBF40006
X-Stat-Signature: omacgq6fxd8nr1q5ke4t7k47h8djouo6
X-HE-Tag: 1788831342-764460
X-HE-Meta: U2FsdGVkX1/0RSRwMdKVcPT2DmLi3fg2EL6L3x0zZUUNmHiEwAwQp8yXcpOs7qjiup3LV0SIhjwMCuFd3sUVNEYfJib6IrrSO1LQTMByUAXpb68l48UYM+HPJ4Kged0B/pYnRtWJrWFA6sTCo2xyJSGAmBiOr5dTV1tXX73r2JYcJxJAuol1C9n+MOGXz4bZRg0jzdhdYIyqiMkEFwwWdybcLNzPS60ZLIc6lY1aKIAc0iETqGEWdXHCaMfnkjbrGBJYOKhzcq7MX216HKs+p3S6YVtFNuIanRGwnHSdfvmSMzuR8JwSV1mkJp9tbY2xoiiiBCT0T556qKYjYVOp7Z4OGWY4ZxkER48HyBA0S9u3NNaXdNRA0KbKk84v/W0m2LeCj+jpibTvWpbfdKaTp6Ky+2yehqwGhC9zL1fF+pa4ldVNfIuc1KARyeKkAy0xAy+dSPcjiuXK1wnzfEhW1D4OZ4BTuDuQYwgySCPz9Kl1qG6oZlqxPpoqt2tn1/zsSUSYQtOU58DI3fVyJd65vAxMrK17F+gM9if0tK7QydX48IwX1H1O9cv0UB817vJfGBw+3XA+iUyuZkUJ5A3XzsIIQY1bKjaoGVpXblxKh9JNkbRXR5xfFD/pHH38tVr6XnPeQy2i+Ox08KK5rfy6YsnMUcjhnaXjid5mfP2vQVMWrr3/DIDLSGAO2lkgg4Ku9pmJ7G0LVfA5pv21gv7oollIK/hR50WgkKSa88GMN/1uOWi8NDwtbOMZXFGJutLukj8AIDBWEkY5UM8AYVwHjD/1vfmyNSMN7oAFTyaM2qwFBpnZcwqdtnTp8xYfeP7YZORv1GNPyaZ3QXx0/2QFpJP/acVqygGuF/TujB52hcHGd5JM195RCzL22jo/AbXHJT8Y4XcoUkdH+h/QhOu8jZDwlqs0bG0E9wib28mle53BbwGk57CUx2JJnlfYJuROgIPuO4d3V9K9Cf4L/D9
 rDBeSkG8
 UNuplxQo1PTX4q+zYtFRXICI+jcRiEyKnceIJzY8NJRfYNl7H5l+pIw+zh3SmOOqQ1gV9sHH3V9+6rPuDyLo7bqH1WrdxlL2CL+Njf/w2uuFP6EnJV4e0n853Dv79z5XrZodnKeEi23t//HBOR9hiLD8wMBfpoJw8HliQvNDMKGYnnYqiQpLtPWQRBPvtthvt0Epr/YRsT9zTETJqCVy2Uw47/ZqUrf9vjbVO8frGiha/JpX6Fj9crjjtIwRYSR6M9uly10DQRKOWdqkSgi7jJitYbpbGFAuRm9jrwPFZ0KUuuX8XxigmfQo4snV+PiDWJ9+HDwCNeiGu3ZMAAVEov4VRuuFREdPJmdTAOjCJvya2NhB4UrGQERVuVXrzYTlFAB08f408jcR3TMN75T+tj5naC5tRlVWoAP+yaGfEMS0bx3Kgu7eez+Muiqmo54nyDQTqDqWsn4+iaoTDHsLS0haKeZclj0lzAl/YJ+Mv0xjegu0VOxUUodMjUBbsBW1C0EdW18pi4wMuWlk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 02:25:57PM +0200, David Hildenbrand (Arm) wrote:
> On 8/28/26 07:59, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > When the swap entries found exceed max_ptes_swap, the loop is left via
> > break with folio still holding the xarray value that encodes the swap
> > entry, not valid folio pointer.
> >
> > That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> > to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> > plain pointer arithmetic, so the trace event merely prints bogus
> > scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> > dereferencing the tiny encoded integer and oopsing khugepaged whenever
> > the trace event is enabled.
> >
> > So when folio is the swap entry value, simply set pfn to -1, just like
> > exhausted scan naturally.
> >
> > And the folio_put() has maybe dropped the last reference of folio. The
> > trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.
> > so using the folio_pfn() before dropping the reference, closing
> > use-after-free window.
> >
> > About calling the respective trace_xxx() functions separately on success
> > and failure, refer to [1].
> >
> > [1] https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/
> >
> > Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/trace/events/huge_memory.h |  6 +++---
> >  mm/khugepaged.c                    | 11 ++++++++++-
> >  2 files changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index 5a48c5406cce..7b526528f85b 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
> >
> >  TRACE_EVENT(mm_khugepaged_scan_file,
> >
> > -	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
> > +	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
> >  		 int present, int swap, int result),
> >
> > -	TP_ARGS(mm, folio, file, present, swap, result),
> > +	TP_ARGS(mm, pfn, file, present, swap, result),
> >
> >  	TP_STRUCT__entry(
> >  		__field(struct mm_struct *, mm)
> > @@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
> >
> >  	TP_fast_assign(
> >  		__entry->mm = mm;
> > -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> > +		__entry->pfn = pfn;
> >  		__assign_str(filename);
> >  		__entry->present = present;
> >  		__entry->swap = swap;
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 75639298efc2..b597a3e68606 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  	int present, swap;
> >  	int node = NUMA_NO_NODE;
> >  	enum scan_result result = SCAN_SUCCEED;
> > +	unsigned long failed_pfn = -1;
> >
> >  	present = 0;
> >  	swap = 0;
> > @@ -2715,6 +2716,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >
> >  		if (is_pmd_order(folio_order(folio))) {
> >  			result = SCAN_PTE_MAPPED_HUGEPAGE;
> > +			failed_pfn = folio_pfn(folio);
> >  			/*
> >  			 * PMD-sized THP implies that we can only try
> >  			 * retracting the PTE table.
> > @@ -2726,6 +2728,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  		node = folio_nid(folio);
> >  		if (collapse_scan_abort(node, cc)) {
> >  			result = SCAN_SCAN_ABORT;
> > +			failed_pfn = folio_pfn(folio);
> >  			folio_put(folio);
> >  			break;
> >  		}
> > @@ -2733,12 +2736,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >
> >  		if (!folio_test_lru(folio)) {
> >  			result = SCAN_PAGE_LRU;
> > +			failed_pfn = folio_pfn(folio);
> >  			folio_put(folio);
> >  			break;
> >  		}
> >
> >  		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
> >  			result = SCAN_PAGE_COUNT;
> > +			failed_pfn = folio_pfn(folio);
> >  			folio_put(folio);
> >  			break;
> >  		}
> > @@ -2771,9 +2776,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  		} else {
> >  			result = collapse_file(mm, addr, file, start, cc);
> >  		}
> > +		trace_mm_khugepaged_scan_file(mm, -1, file, present, swap,
> > +					      SCAN_SUCCEED);
> > +	} else {
> > +		trace_mm_khugepaged_scan_file(mm, failed_pfn, file, present,
> > +					      swap, result);
> >  	}
>
> Just curious (maybe Lorenzo suggested that?), why separate out the SCAN_SUCCEED
> stuff?

Yes, this is the approach Lorenzo[1] suggested in the previous version.

[1] https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/

> When result == SCAN_SUCCEED, failed_pfn == -1 no?

Your understanding is completely correct, and I explained at the time
that this was redundant.

> We set failed_pfn now only when setting result ...

If you prefer one trace_xxx(), please let me know, and I'd be happy to
send V5.

--
Cheers,
Vernon

