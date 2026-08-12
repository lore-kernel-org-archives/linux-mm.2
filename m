Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61A40C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 14:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258366B00F0; Wed, 12 Aug 2026 10:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22FD26B0104; Wed, 12 Aug 2026 10:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CC66B0105; Wed, 12 Aug 2026 10:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB64D6B00F0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:04:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB65BA03C7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:03:23 +0000 (UTC)
X-FDA: 85092784686.21.BA9EBF9
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 020BF180006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:03:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mOgKLRQj;
	spf=pass (imf16.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786543402;
	b=U+zWqtc1AAN/COMiDpSRdhR5+adElkMFUikvybwXPwz004QHXQdMQV/FasPX44SA8QV8BS
	wayXZiIPpcML9PqUixYhUHrMZxFSID1r6JXSlezpVfFasNPfi0xW7DlDnuiFeZn4BQEMxM
	O427PWEMWZBdqQCbYi8q455x39i3XHU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mOgKLRQj;
	spf=pass (imf16.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786543402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FijbjGvORINBRhLeBoIFty9YdQZ9hefeTZ+Nf9pC9YQ=;
	b=jyjbKwzfLKXc1qebFajDshBXw+gfaXflYE7/+PdKYWcPME461sV2oSUk09a/v4aWjT3hqF
	VijfdB3z5Jr+URtfHtXDocNwogPuYlcQfcP453IulWroMtF+cEwHvyd3UcZjmamC34GuJ8
	32wEv3boaAz11yaHDqJ26EP9Ajl7Urw=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ceaf8a1265so12365745ad.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786543401; x=1787148201; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FijbjGvORINBRhLeBoIFty9YdQZ9hefeTZ+Nf9pC9YQ=;
        b=mOgKLRQjlly69AO4fERQ9VFo552AyO4hJDrt21eR9T5klT6hJ+GdAZ/KUcjucV83Pw
         EJLmT6LWBUEy1un4jRcCxKLnWp9Y+BtQsjm54vNeY4BdpH4wTUfrl4Eq0Eme0yi51EnT
         xPv0AF6EvCJLgVQYWKtjj4rcB0TtdGaFCEtQzQwAV0GI8ElkftKEN9r093iY9SWL9N65
         0ifaMUWpeSVDj9oBTwZaIJYkCNLUYn+BwXrUNNjjwcLerUmIzoWurjiYZJxAqYBRO4qs
         x4gJVs+VCkfWZTTDo6zkgbRKMA6BJSCY8yYyg0uHoCJ+XANeA7QEAJVoD0fe4dSkZ6BJ
         Nl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786543401; x=1787148201;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FijbjGvORINBRhLeBoIFty9YdQZ9hefeTZ+Nf9pC9YQ=;
        b=KO5+GYyjYhwQr+llEhyqQ+E53SXJ2hjW/j6Y5Y+MJD+mfHkH+3+lsd2VKl6v8qiDIl
         YR/piQC1FtWnf7RXen6jkedNBtPiUEYkDg6CUUxkFi/4En82skm2HTc6ImZOjJAKluTm
         csYNXGGbvuvv15T+ofWilM9UG+J7jrvpBRkBzgLZd2urmJGeeTvdepkwA1Xbvq/9bAfX
         J6gm4FZ0VyQWPsgXriXvxg7yKVKNr/4aZbG9qqx4sCzN4LkpglegpAxf+L9TJrhrVWAU
         PYBlRD43/zCOLdyhBJ4wPPqrYH+gRerP/vqPd82m+XyfGrJz4U5LAwdLJ1G1AzufegD3
         ChfQ==
X-Forwarded-Encrypted: i=1; AHgh+RqX6oJ8h0hIWxGao/Yh0UjvneiJbe7mJhdKO1YDVh/U1CgkvTbYbbZr9ZiwTNNGYIE1Zz+ApihPDw==@kvack.org
X-Gm-Message-State: AOJu0Ywn9N6g4oG8+4SNRhNOTGFH+foSWIB+zJ2J8priNEvUed7bw+4/
	mAKlxoJpr6sAmuBK6qeJ+wTdX71V41qxMJ7ugENACKeNkv9ICpY79zxp
X-Gm-Gg: AR+sD104XNtVJqvJklvD2nLCYwKvmEvmkbMWYzDkdwSNzUs2sci1aAI0s3h07FoOsiV
	CRxpqkU5CnPpbbQLHVpQJ7I1Gyy9I5eETpUtl2U+3QJW3EiaQq2Egayn+HIA9mENKk8RBg7ioS9
	xn0IrcpkgKweASQACc6vsGg2mpFZv6PQO3W83xM1czDPRJ7NEFd0Lz7OtV0bnJQusgHyCFR05Bt
	sDWIu/VGfPJPHas+741Jb0dSSfKPSbO8S26H4bkhRC25ixaffW0cH0XUV1baLRD6CmjOwPhmTEK
	9ETItKlv9xvh7cV7GgJ0CJ+eFN44C3Vzt8E55lEQYmStBMJAcvYkA2KbFmR5uwLX95DKOzdBy0i
	oa/1WhpyJ+TtuUJBGt6CA1vk02nP3JcMhxJWAQDNnGN1d0UJ/q/ZS8xKeSKBbU+1GIipemzMnK1
	gufvHN+dZ4v12hrFSIvzQXSVo4snYTDImKRQTUfKZpsDm23MYH0UH4Ga8vtNYtMrHSSeV8nHYf
X-Received: by 2002:a17:903:2cb:b0:2ca:d658:d874 with SMTP id d9443c01a7336-2d345713af3mr66438065ad.23.1786543400647;
        Wed, 12 Aug 2026 07:03:20 -0700 (PDT)
Received: from localhost.localdomain ([49.79.111.198])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d351147e35sm7165115ad.24.2026.08.12.07.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:03:19 -0700 (PDT)
Date: Wed, 12 Aug 2026 22:03:09 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: don't pass swap entry value to
 trace_mm_khugepaged_scan_file()
Message-ID: <473fe48f-ecd0-47fa-9aa2-d907b685138b@gmail.com>
References: <20260811133655.267739-1-vernon2gm@gmail.com>
 <57248ac2-2d5e-4995-9ecd-b71b233fe5d4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57248ac2-2d5e-4995-9ecd-b71b233fe5d4@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 020BF180006
X-Stat-Signature: dd8qeynfcywekdw7qihxwxganofpdsfb
X-HE-Tag: 1786543401-578851
X-HE-Meta: U2FsdGVkX1/5l64UUOVLSD3aAaVP4yy9wd+qr+AialTInQ8N3+FPr66NKMb+E+BW7Dev9ilqgSeW7Lsnv8Gv4J8d7AI6i6SPZtIrFuW//RPtOVXpVeCro6frKKOAKi38rQaeGZu4IBUX1prUEywzyw2oJZTQpuyrdJ87pypgXfG0vw8xSUnGM2GWwWZVAZb0QVbPHpuZ9+NXAyb7ChKfwKxBdEHlNBUsGVMAxCGNlld9fH99x3LPxwsh2hds1qgw/2KNq/VTvMrKrn+S9jAkMGYIocuScREa/Crddmt1i1Wc89lxFKC6zw2thB94jhsWTrNW/gMksZ0VCHL8TCDbEkkJn7l3Xi+kjmx3EAe+EfIXV3eIukN9gKlcaA5IR0y3JSDEdbKHBUb5ydnFPkHqohse920lcWZQ1O5hV6SG+M73m489/NnfZ08kB3WmY9lHdgENcwKeVopdM0pIWOdp5i8eA1mDHGwaSaQ8FPhJ5V+XHogevAY5u3iaLCuP9vQ0DwoawoyIrdiyQ2BrlFsW6IhRUi2yX2VGEOu1zzOulyygQ/BlGI1oyw7z0FI31/YGp+S+7NX5osDfcXy0kvbzOfCHefQEapQBsZCYL8gdR/KAG6QaFIZFNvxxOL7mRqhnfafRGmrkGyimEmTqQiCj2fg620ycXYfAIZYW4uRdCS7EBvAiWCUyLorS4IOhTU2lsadAmmWR0QlZPyyXUm19XhiZeMG0xrPJHoH9F+3USzQUGcrhL66dOPJOzhxKcWH+JF6n38fm/XsfparvhLqwIdjNz/5UvHemmANEviIR0apIJ7pE8yQTKG6pEoRW3UwNL7CDAWqcgqM+7Rdk4YqMvPJCN8kkpABfttPhd3lFd1LcDUIiLOmAzvjJFkdv+dbMIbQLPVpGYHzk1ZHg8UtSi0SWlN3PD4rRqJj5NdWpctz4gRs6P1rr5kgvPVtpXsIZJPx6kbLHYQReX9Ibeu2
 GJBQeT5L
 pBMT2gtbdqzocl2gjQNWwz1PzPomwIkGeCbutrOjkRezFhS3nwWJGHl2117uWZ7TL0XMsKho2C9fLtk8Ilz/7Ozh9c8B0FpcQjqWY/9iF+lrnvRQz49ei9V36YHzLywMWA6DdO1f9gE9UJGoEA3ZwzMmFgO1pQ/f8eq546SF87AfYBzpOFUjJr7E+xpvV0SHHfBwKdMXxbIdcfuxbWsz21KHqKJQv1YrUBJGeWdJFR25k1gU/9nt42t1nuHUYB3Rts8kymAhuGFA/xNUYqphJvbKiTPdplxVR0aCvQyK5w8mgY0idJ9HJt+IidvN0N2TN4xB92p6/RY2W2siSc63T64pw/l2EXRCasJ10cl3YXF28EiiundhjBIjW85CfwVSqTQX9sbw8Ly5JyyeLZiowjLIUCnsnCV6zGIveUx0maLhLlVP3rJjPOQ+VtqV+Q0B5i2VWQIn0k7FATtGJ0Srd9n10pwZijizgef0HebMvaaImTDGjF1a5qKQtaQEVQfagpc71
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 05:19:38PM +0200, David Hildenbrand (Arm) wrote:
> On 8/11/26 15:36, Vernon Yang wrote:
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
> > So set folio to NULL before breaking out, the tracepoint maps NULL to
> > scan_pfn of -1, just like exhausted scan naturally.
> >
> > Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  mm/khugepaged.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 617bca76db49..bc0d04c9162d 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2696,6 +2696,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
> >  		if (xa_is_value(folio)) {
> >  			swap += 1 << xas_get_order(&xas);
> >  			if (swap > max_ptes_swap) {
> > +				folio = NULL;
> >  				result = SCAN_EXCEED_SWAP_PTE;
> >  				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> >  				break;
>
> Yes, we'll do a folio_pfn(), and used to do a page_to_pfn().
>
> Using the folio after dropping the reference is rather nasty.
>
> Instead of passing the folio, should we just pass the pfn directly?

Yes, LGTM.

Would similar modifications like the following match the effect you want?
If so, I'll make these changes in the next version.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49..e7830761d3a2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned long pfn;

 	present = 0;
 	swap = 0;
@@ -2720,27 +2721,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			 * PMD-sized THP implies that we can only try
 			 * retracting the PTE table.
 			 */
-			folio_put(folio);
 			break;
 		}

 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
-			folio_put(folio);
 			break;
 		}
 		cc->node_load[node]++;

 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
-			folio_put(folio);
 			break;
 		}

 		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
-			folio_put(folio);
 			break;
 		}

@@ -2759,7 +2756,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			cond_resched_rcu();
 		}
 	}
+	if (!folio || xa_is_value(folio)) {
+		pfn = -1;
+	} else {
+		pfn = folio_pfn(folio);
+		folio_put(folio);
+	}
 	rcu_read_unlock();
+
 	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
 		cc->progress++;
 	else
@@ -2774,7 +2778,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		}
 	}

-	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);
 	return result;
 }

--
Cheers,
Vernon

