Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E904A606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Prn6xmv6
Received: by kanga.kvack.org (Postfix)
	id 6C2736B05B8; Fri, 13 Nov 2026 16:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698FA6B05BD; Fri, 13 Nov 2026 16:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF566B05BE; Fri, 13 Nov 2026 16:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5A06B05B8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:10:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA12B14018B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:10:58 +0000 (UTC)
X-FDA: 85431340596.20.FC6F06D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 08A901C0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:10:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Prn6xmv6;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794604256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNX9PRs12wEvtOpFuHeZVZADVMT79l+m7/X1dUvnqbE=;
	b=nGR28Jz2nxfa1GN/tKprge+uExdVA4TtqC7Ns3fd96hPqRklCrAiTkIlVGYazx1C1Miv5h
	hhbqfuYuluGGqA6S43a3oHcsSXp7EvPo4H9YE2/rjfdGNVUBlzsHw7j9RYDV6lT3AiPcXF
	mIxEZkeQS8WF/EEZrwahpmWG55wJsJg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Prn6xmv6;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794604256;
	b=STarnKQPtR2JUm7nceuVxad0U1QUKj36TfzRRL9enJKSyJir8g9wFYicwxXsOlcwNSPJ2K
	AoEj1ZT8/DrPzDHrY9HVfcqS//xC/Mcptv348d+q5UIAs+r/RCv5cLBU87vSkthgpKgrWV
	ddy+Vlu/7fh6vsAemMNaRD8DFe1V4Uo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 350B543CA9;
	Fri, 13 Nov 2026 21:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111751F000C4;
	Fri, 13 Nov 2026 21:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794604255;
	bh=eNX9PRs12wEvtOpFuHeZVZADVMT79l+m7/X1dUvnqbE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Prn6xmv6HHRpPSZb/fj0yneI6YgxjAwhILamg/+ltT2OJwC8UbiGZaRh9nKjTLGQJ
	 QtHQhX6ESp8/rdGqEEy3T3FHZVSLoybbdg1ippq3W3HgHkeT1JEYPd6ZFcV67SGJdn
	 nw7Q1yunbvMaWmWg0jANOqY6KHd9NV0juzHX5SvOvmVOwaCdC7EuqhpXP61aYQ2bOA
	 ySgLa93b9SFql0F7Chzpu6O+Kq0583qoCcNQteGyeRp/4zGDnFV899PE9aSI5IZpsZ
	 Z/rqEaOnn3sTr6p61mH7QHtQrHU7mUBTEiyZrcm42BIHJykEtxxzTk8wCxvUGFRw/I
	 /d89nvFfiJJpg==
Message-ID: <f8b0f20d-90dd-496d-97e9-9a232124e3e0@kernel.org>
Date: Fri, 13 Nov 2026 22:10:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>,
 stable@vger.kernel.org
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ie1cope7o4ccw1pbx4roi9dtxce4tz68
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 08A901C0005
X-HE-Tag: 1794604255-889497
X-HE-Meta: U2FsdGVkX18jfpMEW3ZSqQvER9u28B79CvnoFHhmVe11Mg1P/4SnXFON/MTd88IWSg/0k2EkwnDCjQIT7cLcEmFluveyDMclKefOQTv4liNOLCTtH+8XRf5PCWn+MOSojJVLdIHugOCcwdhcrPPA3rq0eirP07EW86Omtyl2kdbQWfR3cH4bZ85drqCIfJa0Ev2Zy2qG5lXaNsSQem1dORdbvcdcLPJtqoEO3OJB/MTjfm6m+hnxN8PsEk50JLZoqehkx6rPlMPt2/jujWmt9nZdB162kbZtbt5I9DH3Y59EAucRRN6oQeMK7+81e9GvPe6hISPYr96RES15AeOjPjB1+z8mJekWIX3L4aZma7l8CAScxDFrrQsGY51BNQ9lB63LyxUdu3jKo0h0RdnD59zrGRiTrqTzf0d1vorVd2Y0Yf8FpW+W12PxhOQylqcPgadgZepW7GIpNMgV6rHp3nulYbr3sW0abkI77mTo3H0A8maWa9vMMdDK2xP+fJHNb1j6EiFOa2pIYY1FHZuzrlBEj7VRF6dvjTQ2kaGyGIBM2bM9YIX7RccBfkofdMAAe/pVRZoHdf6I9cuWGle61cOGhvmSAhGFxNB531Aj/D88kSRpSEDIFlsxiCtoQBK9oh6F1cnKOHCnWwTOsLcQvk5eIeFWpy2qI3cGjPWeomFCtzjlOrNXNQMwdL2KSxPLvN6WFgdiI0ubZu6xIDi+Tn6U32nNkDXewcdhZ6BL9Lfo1WiX1uQsDEbqfCe5ZwWdbzjWBnK8qYzIJrS3IYPlkHH2koxmcXEwMqY1Td5GkqXnytYtcAqGuI81WDoiCh8ewxMZHmKgD+Umu9PRrJfAKTV9WjPGv+8QY26plPzOjF/NPdNzc+aZm/Fjmflnvk4MuTvG5BjaCZyEbjD9JKjfxcMd5W2qVI8AJ9DwpqO5lKjJlMdYF8Zf7A/0JN2CXWm52QnqmMDP19qZLZi6qfZ
 1ro1UWNN
 5eHpwDQjeqHm5fVMLnIKYqbLDO6fjb3OYp82xbHrc+NhQXt7pWrdLZoYMH2MDt2OXYRXlKGVznQ7ePqTHPwHFuSFXW/jVva0r92pNYF5DMKyktAQDGul0cDkEMmkoNKk4wXsf07h2jR0pkaqKY7BuxecI54c8YVpG+rieelx4dBcduyrjovSYiRQsMCphN4uNLgcMvU9hwNSfjJLqKc4NDkeS5JaeBIdfiENPxifWLYb9V7gO/U7kKkvOs/gH9X0NiblKR25ffpVNjXk/pwKHJNXFzyzqORcDqRZA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:04, Lorenzo Stoakes (ARM) wrote:
> In order to establish guard regions, guard markers are installed in the
> page tables of a mapped VMA.
> 
> However, problems arise when one tries to combine this with registering a
> VMA for userfaultfd, as such operations may themselves need to install page
> table markers such as uffd-wp.
> 
> When the installation is attempted the guard marker prevents these markers
> being applied, which can lead to unexpected results (especially if the
> guard regions are later removed.)
> 
> This is especially problematic because guard region installation causes the
> regions to be zapped first, meaning that the removal of userfaultfd-tracked
> ranges will not be logged in this case.
> 
> Additionally, the uffd-wp page table marker will be propagated regardless
> for file-backed mappings as the zap being performed does not clear these
> markers.
> 
> This is problematic, as it can cause repeated failure to install guard
> markers resulting in an infinite loop.
> 
> Therefore, update guard region installation to invoke the zap with the
> ZAP_FLAG_DROP_MARKER flag applied.
> 
> Both before and after this change, uffd remove events will not trigger on
> guard region installation, nor will write protect state be propagated after
> guard region removal.
> 
> This makes sense as conceptually, guard regions mark a part of a VMA as
> effectively unmapped at the page table level, and removing the markers is
> like mapping the VMA again, over which operation uffd markers would in any
> case be lost.
> 
> A survey of open source users indicates nobody is relying on installing
> guard regions in uffd-armed VMAs. Software including glibc, android,
> tcmalloc and CRIU were checked.
> 
> This change means that any already established guard regions are removed on
> zap. These will be overwritten with the newly installed guard markers on
> success.
> 
> However, if this fails for some reason (fatal signal likely the only
> reasonable cause), guard regions may remain removed, and concurrent faults
> may succeed in the interim in the range.
> 
> Since the installation failing guarantees nothing about the range being
> installed into, and since success overwrites with guard markers, this isn't
> an issue.
> 
> Since MADV_DONTNEED does something similar, abstract the zapping to
> zap_range() and call it from both places.
> 
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> Reported-by: Tal Zussman <tz2294@columbia.edu>
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu/
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu/
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu/
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> v2:
> * Updated to just zap everything as per David + Tal.
> 
> v1:
> https://lore.kernel.org/r/20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org
> ---
>  mm/madvise.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014..4f7728583207 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -850,6 +850,19 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
>  	return 0;
>  }
>  
> +static void zap_range(struct madvise_behavior *madv_behavior,
> +		      zap_flags_t flags)

Two ... ;) But maybe it's consistent like that in the file, didn't check.

> +{
> +	const struct madvise_behavior_range *range = &madv_behavior->range;
> +	struct zap_details details = {
> +		.reclaim_pt = true,
> +		.zap_flags = flags,
> +	};
> +
> +	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> +			      range->start, range->end - range->start, &details);
> +}
> +
>  /*
>   * Application no longer needs these pages.  If the pages are dirty,
>   * it's OK to just throw them away.  The app will be more careful about
> @@ -872,13 +885,7 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
>  static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
>  
>  {
> -	struct madvise_behavior_range *range = &madv_behavior->range;
> -	struct zap_details details = {
> -		.reclaim_pt = true,
> -	};
> -
> -	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> -			      range->start, range->end - range->start, &details);
> +	zap_range(madv_behavior, 0);
>  	return 0;
>  }
>  
> @@ -1217,9 +1224,11 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>  
>  		/*
>  		 * OK some of the range have non-guard pages mapped, zap
> -		 * them. This leaves existing guard pages in place.
> +		 * them. This also drops any PTE markers in the range,
> +		 * including existing guard markers, which we reinstall on
> +		 * the next attempt.
>  		 */
> -		zap_vma_range(vma, range->start, range->end - range->start);
> +		zap_range(madv_behavior, ZAP_FLAG_DROP_MARKER);
>  	}
>  
>  	/*
> @@ -1845,6 +1854,7 @@ static bool madvise_batch_tlb_flush(int behavior)
>  	case MADV_DONTNEED:
>  	case MADV_DONTNEED_LOCKED:
>  	case MADV_FREE:
> +	case MADV_GUARD_INSTALL:

Huh why that change? Not spelled out above.

Apart from that LGTM.

-- 
Cheers,

David

