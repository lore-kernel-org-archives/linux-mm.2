Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D31C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8873F6B00EB; Mon, 17 Aug 2026 12:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837606B00EF; Mon, 17 Aug 2026 12:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7287B6B00F1; Mon, 17 Aug 2026 12:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB8A6B00EB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:10:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DABF0A06AC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:10:55 +0000 (UTC)
X-FDA: 85111250070.28.B0FB7A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2ECD280003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:10:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCBaa+j+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983054;
	b=dlhDSKVOEih5cA5wVXECTpcHtBPnJ3Mj+mXdFfn24obNxJnSvefzz5CFLyJQUcVkMsgD1/
	HbBM0z7KvA8+2ySU6LBFWU/vMnHzIeQhTBUJRyfGsQru92AZtnyvvIKGx5XjFjWPmoDzDf
	ggnDHBMdh3RdKZzXnvyWs+RMlF58Gwk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SCBaa+j+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehil3JC0l4LDLYFfypizoKcVHzJxLCL/jYPuy7ixqt4=;
	b=BdMUwWvd9JuNoeB5eg5fe7Iyz0AiDNv6ydFF/sGrynQWpNZgKBygBYNrmIV0TJIOgmjE12
	F+G1jeJ5Eq+N6OD9zfg/RgaTpLWQC1jFm8Sm0FX+gkpjY3LHXFah0sMfJPK6/HGzioHC8P
	7LAz0tz3bdkhlZDkYHm7uq8g1lqo0oE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EAC9640DA1;
	Mon, 17 Aug 2026 16:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC7F1F000E9;
	Mon, 17 Aug 2026 16:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786983052;
	bh=ehil3JC0l4LDLYFfypizoKcVHzJxLCL/jYPuy7ixqt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SCBaa+j+AIpRYkJmJX3uDNdJm1MMZGwWIXmfqLt+TQDIgCGBTZ8Nd11gzvihP3AKi
	 buYunOdFO42MxMRjMdmB3HRkliFilbGMxVY1te3hdhc4BhkjjGUOdzF7RORsDgHB9s
	 hctOlspJASD07HP5J428S2a8JmThNHrBWT9q1uquWERcm4viZ4CWxSiPN9FGcHe0WB
	 jh2pkADjj1FqTELBdmntQikje+F+KnQT6iFuEHhK2SsoghF6V0YbF5qdqrQCy+xUq/
	 ViAnuu5SahbcAIqktb0rESgQwnWOlcwJD86ksHAYqxc90wlNVIefzRHdfO+5YdaYJi
	 5PfIAINR53hdQ==
Date: Mon, 17 Aug 2026 17:10:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <aoMs79VDCnYvA9S7@lucifer>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
 <20260815051924.194810-2-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815051924.194810-2-vernon2gm@gmail.com>
X-Rspamd-Queue-Id: 2ECD280003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ouaz4bmimtbyuwzzie84hoi38rmtdn7c
X-HE-Tag: 1786983053-374671
X-HE-Meta: U2FsdGVkX1+0S872ZXXjyYZbJgp9zZfMLpmII7+jP/s5Krjn8puvrFA740G2kTVkCgBqzu6Er5MrYo0F4kqSD+lnDoi85gDafRLDURWA/DX/YNNUsNrvAN0o97xdtPYnBJfN6BSM2qVsHv6chshjPexB+PGgXAeinMADE7Y+6SPeRDQ9tXYQbZNOxajsRYjZrpDhODa9w+JqRmQ0+CB5fbIqXTL6+ZJupjemfsu607upVb2XoqxBvGkKnAOsTYt+gQlibT+RUyA9ZL5yZzHpocqvhmQ+rGvk19/3deRUn3Ddxe2RTDQMD5nzgmkTdRpi5P9+4+L3uACnA/10nWuwhxNwl1rImZX4oM+mZbQkVzsMA6bOB6a3A+ueD24nNvNt9oXELSNPr+F0KwQhIAob9kDDYG9GJUJihFlxz7wbSrq7AzWSwMudSZSBrQgtKca07cc+vMvuqufAkTmEPKY2h/yfytWjVUqZu9HM8XMwaxMy/KJaB66QeW4hQv3YivThyA1qGFbLclorqRNMoQldBlsHTwQ5P1ijYAQXBTgtTAYKDL5ZRdaeeu/qwXiHFMIafkkXQ9YhiUxi69Xy63UDyRRmjQXpgaVDFXFo6lnobBRwZhPTSRFDRwGziaphlLosj3zPMcV+bnQa/MBHh/XrCjaN5R3nhmZQMP6MsJuLLsJnUsnMr9hi8QbRyGvliwMgSiH3t5Ad54i4LtAr2jpqX0yTu49+vQBPtDnv6jKPAyn2PXQ+FWXwLW67n0he6HLYKDUQyhDnR+qZ5swZtSMeGPTQ5K2+LZX1M9zHZlnONJY0Yx8FBzLTXzP94Wc9CfLBS+w0FcBz9AGfjlfUy84Gv0K9EnVeOKcjHJcAxQFnQEgaM2miC3W7gHAd7A7Ukr+pDpAX1ItX4jInLh0gV21ud4Djo7zZr21V/9P+3bGrGD57wokd53duSJYmzbhBTVxhcE8OKXBBnDbC01fwfb3
 29PJadC9
 PRmzHmQNUroTvtdSrAgg02ZlbXNGWf0MbzH/mUytlv3r2BgjeZeJ1mjYUS1t81po/eA0yuE/MdB2w4hsGrGrzOvWJ7M7vdQ55zbNDP8TVgW1nrDiL+Hs48chMB1lnw8J3OukHSxqKUCOSZn8pOH2xqzUdErPobYuvk7tgqVsicrHj2S2GjtDveRKXsZwlj/axooWvI1x34kVJs7vhmHMWS6KbArSX7u9WdmZ4vaEHD0pgy6odB2HPDQgeyGe2+vKpdcA5SzJyvL1G1veqvei8iwIIcqkD7ykTz3qR/Pkk/uABsN7jQNf5Kz6ipBLYy6f4lUBjhNWdGX8z5Cg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 01:19:22PM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> When the swap entries found exceed max_ptes_swap, the loop is left via
> break with folio still holding the xarray value that encodes the swap
> entry, not valid folio pointer.
>
> That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
> to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
> plain pointer arithmetic, so the trace event merely prints bogus
> scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
> dereferencing the tiny encoded integer and oopsing khugepaged whenever
> the trace event is enabled.

Hmm I seem to recall that we were no longer spporting !VMEMMAP SPARSEMEM, but
maybe I was imagining that :)

But this needs fixing in general anyway.

>
> So when folio is the swap entry value, simply set pfn to -1, just like
> exhausted scan naturally.
>
> And the folio_put() has maybe dropped the last reference of folio. The
> trace_mm_khugepaged_scan_file() is left with a dangling folio pointer.
> so using the folio_pfn() before dropping the reference, closing
> use-after-free window.
>
> Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  include/trace/events/huge_memory.h |  6 +++---
>  mm/khugepaged.c                    | 14 +++++++++-----
>  2 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 291fae364c62..d3572d4ef453 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -178,10 +178,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin,
>
>  TRACE_EVENT(mm_khugepaged_scan_file,
>
> -	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
> +	TP_PROTO(struct mm_struct *mm, unsigned long pfn, struct file *file,
>  		 int present, int swap, int result),
>
> -	TP_ARGS(mm, folio, file, present, swap, result),
> +	TP_ARGS(mm, pfn, file, present, swap, result),
>
>  	TP_STRUCT__entry(
>  		__field(struct mm_struct *, mm)
> @@ -194,7 +194,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
>
>  	TP_fast_assign(
>  		__entry->mm = mm;
> -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> +		__entry->pfn = pfn;

I wonder how easy it is for people to interpret that this is a PFN of something
only in the case of an early exit.

It's a bit of a mess that we're exposing internal implementation details like
this, quite honestly.

I hope there is no expectation of this being there indefinitely.

>  		__assign_str(filename);
>  		__entry->present = present;
>  		__entry->swap = swap;
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 617bca76db49..e7830761d3a2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2683,6 +2683,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  	int present, swap;
>  	int node = NUMA_NO_NODE;
>  	enum scan_result result = SCAN_SUCCEED;
> +	unsigned long pfn;

See below I think we should drop it.

>
>  	present = 0;
>  	swap = 0;
> @@ -2720,27 +2721,23 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  			 * PMD-sized THP implies that we can only try
>  			 * retracting the PTE table.
>  			 */
> -			folio_put(folio);
>  			break;
>  		}
>
>  		node = folio_nid(folio);
>  		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
> -			folio_put(folio);
>  			break;
>  		}
>  		cc->node_load[node]++;
>
>  		if (!folio_test_lru(folio)) {
>  			result = SCAN_PAGE_LRU;
> -			folio_put(folio);
>  			break;
>  		}
>
>  		if (folio_expected_ref_count(folio) + 1 != folio_ref_count(folio)) {
>  			result = SCAN_PAGE_COUNT;
> -			folio_put(folio);
>  			break;
>  		}
>
> @@ -2759,7 +2756,14 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  			cond_resched_rcu();
>  		}
>  	}
> +	if (!folio || xa_is_value(folio)) {
> +		pfn = -1;
> +	} else {
> +		pfn = folio_pfn(folio);
> +		folio_put(folio);
> +	}

Hmm kinda hate this you're now mixing clean up logic with some trace logic.

You have to go check out xas_for_each() and see that xas_next_entry() sets folio
to NULL at the end for the normal case to know this is OK and then figure out
that this is just for the break cases.

That's not intuitive in already not intuitive code.

And this is a patch you're wanting to backport to fix a bug too... :)

I think you should keep the folio_put()'s where they are for now and limit this
fix to the trace code please.

I think you should drop the pfn var altogether and do this far more simply, see
below.

>  	rcu_read_unlock();
> +

Stray newline added, let's not do that for a backported fix please :)

>  	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
>  		cc->progress++;
>  	else
> @@ -2774,7 +2778,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  		}
>  	}
>
> -	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
> +	trace_mm_khugepaged_scan_file(mm, pfn, file, present, swap, result);

I mean maybe better to just reduce this to something like:

	/* folio is NULL unless exited early. */
	trace_mm_khugepaged_scan_file(mm,
			(!folio || xa_is_value(folio)) ? -1 : folio_pfn(folio),
			file, present, swap, result);

As the least invasive way of fixing the trace + limiting the contageon?

>  	return result;
>  }
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

