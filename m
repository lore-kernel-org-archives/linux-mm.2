Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6D2C5516E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 19:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413C26B008A; Thu, 30 Jul 2026 15:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3F16B008C; Thu, 30 Jul 2026 15:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA506B0092; Thu, 30 Jul 2026 15:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 061F46B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:00:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 936FBA1291
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:00:02 +0000 (UTC)
X-FDA: 85046357844.01.E35CF79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B442816000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:00:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ucLWT3Yx;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785438001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tayj0EGBxc9QIq60kNKxuIuBQ/P429IFHvuIK0fivRw=;
	b=NSIemb/4JN96AFNMcA/O4JjV7NAZPBF08Z2A1fzZMqQzgL9w8mfCqjPbAZUnxsF4/gBhPn
	kDdAsEXYgq+k0wtqrRaA1Ha4/0IE+UrUMMD/9pfr3Q7JJ9/+wdDIUE5D9ar4NQGDz5wpIW
	lqgwGOg7ZMM8naU4NH7f6yXUPdPjgnQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ucLWT3Yx;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785438001;
	b=qRhRGBpQ4bDMW4Gh3B0891X+9SGXOGzC/JmeW/ywsKNTyEPfchN7aoUJegJ4DRFyfrGGmr
	b5idysMeURgZopOU6z45MUZKaUE4Q7kXPXjtJjeRR0n9I9cqzsDvO3mDcgefRucjGq+0Vu
	5MTYFfq06qAx9OcmfGM2nMzZUDxmzXc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E32E43600;
	Thu, 30 Jul 2026 18:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CD71F000E9;
	Thu, 30 Jul 2026 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785437999;
	bh=Tayj0EGBxc9QIq60kNKxuIuBQ/P429IFHvuIK0fivRw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ucLWT3YxhocSPSq7t+C8gdpLzheHCIIkdTuk0ZW8BH2O6O+kPRu28yszrGgR6XLmC
	 roV+yxv+/Zu4CGryFVUiypI5QTHuhPiZDR0AvxH7EeLM5SC6Ftd0nuEkLUQstG7+Sc
	 /pUEuwoM/UN4JhxCs+t7Wd1as2DQOkQymlP6ZhTY=
Date: Thu, 30 Jul 2026 11:59:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <liam@infradead.org>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, Hannes
 Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi
 <shy828301@gmail.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hengbin Zhang
 <uqbarz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v2 0/2] mm/huge_memory: fix huge_zero_pfn
 race
Message-Id: <20260730115958.ed8ec3db759f06cdd10feac8@linux-foundation.org>
In-Reply-To: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
References: <20260730-fix-refcounted-huge-zero-v2-0-c5d8a41b317f@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B442816000B
X-Rspamd-Server: rspam01
X-Stat-Signature: oqp7so8gytu83i1bydc9ef97jg8mrusi
X-HE-Tag: 1785438000-243091
X-HE-Meta: U2FsdGVkX1+oS7hATqmRNyl3i0rRHRTZsKAC6mZNkXdv51CIILE30shuGbJnU7w9TcT1/ynszV47kcjLx6e9e6aDStvEI6/UmBZwIe1UR602V8wlys21qZTsj5/pf5eyed5HMpBVvnFqh2UWc6KlFSNGTutEoL/GGints+G5laD8J2m2uNazdcchpljoOezi3LnJ22sfUoBlvGLRM91zWfpNeWdBGVLQEANStk+jDxRlo/QtAdhPOHjCkidV5SozQ0wYRNe/Q/xhswKwmEpJgZ60hFtH5RLr/af8xrJVq881+YXSHwa2ieHo4W+ikzgOcsH6FAk6WzMiFcaQaaU+Fzc5msaGaGifo4kblRLs2J4v5pl/cxYeKWaqt0NA96yuLk399AnxgXUrSKK/KO4zrlxMap6ntyKIAWN8kGXDwoDsP8psD1vQkU/6ttymG2kikh88UaG7bisFnWWESzVYR1CdR3z003hleYunJbXBgHzH7SKVU6gDFP5YUt8bLmSW+F47ESGwC4JXHpnXovYh0Q6xCOg7+0LD1St0KTstxCt2HjziTApw05Lb/zA9h99FocKtQ3qVU/G5YQgDJDxYe25sgvLIG7louB1kCCJ8nYBqruwhuilH1kUeNA/ga0NVnRVyYYGF04s7+nnSPT5f5+vW71M90y/8+nPxVR9Bb+deXZYqCPrbQWelw9NRMXOnPNXqvAHAlPre6yEt0T3S6e9ctS4KPqG41M5NvAHoFX1EYhEj+v2+CTbPFAd3g5B6pPDIt8v04HF/SB4iQvhvRivrc9AGTZNVO9IVR1aZNcoThlhNV2LWknCRrhQO4PTjLA+sBWao4iv3eKk1AljXI/9B4Lc9UY5iGlP5TLijQuAVvWUCB5hh85vu8XnTx9hJS6wCfKsslRVf/Kq58lXsJCXc66uvDbGZ1zwxJ14PRjmQWp8i6eYwY0YXPBWkDlrrp8h1ja77hEKT1PmF6mS
 9r5oqKWk
 NRLnRPMfGHiNlg4HzgkHgKsq1AWnORpw/WrxmixjE29JvLLOXAxgQiLs5LCbyxqZDb8rBrXmhZ+7iW8Sshvh6UTXwuwGOisZqQQpXSn1ozX7MGPTs0I9vkBFE+GGWvyBr5toIYT3waHzQ8JLcQLc/S1EiZ2rfQb9OBU/MRbK6ychom9UccPRSNVkGdf4tHUdNlR7S0cQeJzxezhMJa84z/fuVt6ys1fCO0I/uIKtjbWTdQ24CIxxiNBt95TIi31UIJCMubVRUEtO3j8E/CyBTPj2ps624JmkmB7Eck+Raswg5i8T1861YHjALE5lJ8c80G8yoATYtnDvZXDGQkWG9mParIHJHmOFOz5/XMNr6dtZhr/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 11:55:46 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> There is a subtle race in the reference-counted huge_zero_folio
> implementation.
> 
> The fast path atomic logic fails to account for the fact that the
> shrinker (which drops the final huge_zero_refcount pin) can overwrite
> huge_zero_pfn with the ~0UL sentinel value in shrink_huge_zero_folio_scan()
> after a racing get_huge_zero_folio() installed a valid value there.
> 
> This results in huge_zero_folio being correctly set but huge_zero_pfn being
> set incorrectly and thus is_huge_zero_pfn() and consequently
> is_huge_zero_pmd() will misidentify the huge zero folio as being an
> ordinary THP folio.
> 
> This can result in the huge zero folio being split and otherwise treated
> incorrectly.
> 
> The solution to this is very subtle as there is an atomic fast path, and
> thus ordering in weakly ordered architectures has to be treated very
> carefully.
> 
> The first commit fixes the issue by introducing a spinlock around
> huge_zero_[pfn, folio, refcount] write, with careful consideration paid to
> load/store ordering in the fast path. It is placed first and kept as small
> as possible so that it can be backported on its own.
> 
> The second commit is a pure cleanup which reworks the
> CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic to better separate the persistent
> logic from the dynamically allocated one.

Thanks, updated.

And moved to mm-hotfixes.  But is it appropriate to fast-track a
tricky-looking fix to a four year old bug?

> Andrew - I know you don't like a mix of fix/cleanup, but thought it'd be
> easier to keep the 2 together as there's a dependency.

Sure.

If we were to upstream just the fix then really we should defer merging
the cleanup into any tree until a later time.  Because the cleanup
might accidentally fix a flaw in the fix.  Sending just half the series
upstream results in an untested code combination.  Unlikely, but it's
happened a small number of times and it's a risk.  Keeping both patches
together eliminates that risk.

> ---
> v2:
> - Reordered the series so the fix now comes first with the
>   CONFIG_PERSISTENT_HUGE_ZERO_FOLIO separation following it as a pure
>   cleanup as per David.
> - Fixed up wording as per David.
> - Cleaned up Cc's since dependency of fix on cleanup no longer exists.

Here's how v2 altered mm.git.  One changed line, unchangelogged!

--- a/mm/huge_memory.c~b
+++ a/mm/huge_memory.c
@@ -328,7 +328,7 @@ static unsigned long shrink_huge_zero_fo
 			return 0;
 
 		zero_folio = huge_zero_folio;
-		VM_WARN_ON_ONCE(!huge_zero_folio);
+		VM_WARN_ON_ONCE(!zero_folio);
 		WRITE_ONCE(huge_zero_folio, NULL);
 		WRITE_ONCE(huge_zero_pfn, HUGE_ZERO_UNSET_PFN);
 	}
_


Sashiko said some waffle because it still doesn't understand that
__init-time allocations are considered immortal.

A cleanup opportunity is to get into this code and formalize that
convention.  And the convention that debugfs return errors are to be
ignored.

