Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40165C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505536B026D; Tue, 18 Aug 2026 06:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD216B0803; Tue, 18 Aug 2026 06:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3116B0828; Tue, 18 Aug 2026 06:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 226EF6B026D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:34:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4F14A14C6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:34:51 +0000 (UTC)
X-FDA: 85114031982.19.2980E0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1BF0210000E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:34:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lr8/Pdix";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787049290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RabI4J/BrtvdoCZ9vo+KK3MSA7ivPJAPsrCnENerses=;
	b=CPKlo9MShV2sISDQPDrBqxfz0K006GSyahaVi5kx78EIxi7JAtvnomO0b7+Ct/iVb3lPBL
	1gb8E/KomGKyjNFoxeWFBQjGGGzQsc6DhdKzjhcVzkQ/YcSI3pMdrzEI8B9ufB201DjJch
	zF932knIZjlLfd2Dd1sn4jXtMZm39ME=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lr8/Pdix";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787049290;
	b=spsCLvFuqOffH3N3IazFGK2RROX4M2EE/GC/zmOXnr860j3xwyA7DRlnS+V75MZWURqeKA
	jR0/U1z2wD84/+y+06g0fAHUB3HdWZxT0eRpssHXE8uos7/pmUIoAbOEL4OxrMD1nFrFFh
	omQ1QNQmmWGJjqfcUwuLWwT0CAY5dQs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F52160A7C;
	Tue, 18 Aug 2026 10:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1DE1F000E9;
	Tue, 18 Aug 2026 10:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787049289;
	bh=RabI4J/BrtvdoCZ9vo+KK3MSA7ivPJAPsrCnENerses=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lr8/PdixHC0b0cHQYGs/rrFYXrnRpgGR09yIMWK3/sFkEnbxp9wEKabBlzX1lDuEY
	 QbHSdVMeGPHP24nwk3gEpkJ65/V7QPVzglAuTvteq17oUcWZKIyJvQI3H9u0Um3EJv
	 7Bp35cQCgv44NRiAD55dqm+F0QC3ia+2vzitjR/jVPMSXDsZe1y1uRPm45CPTcoRR7
	 Sglqkyaw4yMcPKoXdKslL9kAOEqF75H2E0uv1TA55/nFqDztxUV6ThmrWaM/nxCoqs
	 +BMV0sTBqAUqaETN+y56Xc+MLRm2iqnpBU5ZB3gZKdlPHtTM9tnlw6NLg+ocFYOXrz
	 JX+SkkhyCpejw==
Date: Tue, 18 Aug 2026 11:34:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 10/19] selftests/mm: add khugepaged completion barrier
 helper
Message-ID: <aoQ0VzEcH-SydZXs@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-11-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-11-kirill@shutemov.name>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BF0210000E
X-Stat-Signature: ighwf9ni7dcaqngnurtnhzeg6d3xcqas
X-Rspam-User: 
X-HE-Tag: 1787049289-327248
X-HE-Meta: U2FsdGVkX18iLi3/s0ptaVAyvDYUjDYtjmChw+aB1Sh2rUU1q4RqF7Ylh84yD6KT4yeswyCTtVjI3vvJPdF89Ms13zf2ysIvlgTsaSi0omkv4JGmCUXIuzQ5HVtcPDUsM7n9F/HPSc7DdZhtZcPT1ac3kkp9mcM9EDa04KIeKTIRJ/v5VWPNjU4fX04D741sAKqvDNslInzw+T+9aOnwa0eQ1Z1jUqlfWcZB215hV/fqo78Cer1RSJSipfL8TuYV9JRpaveq6wXxiS+oAnPcZLC/VOAqyo5rMoQFC5yD4p/wgvA76ejPuvih6JDoaHv/b7YCALVaUblam+PxGF+jpfNqCKzh6sYUlYrQTz47t82kMlGnzaw60Ujt41PUUqxH7T3nhVOiG08buk1erfqlzXZPdaIqQopC+gmmMDhP/ft2s2LAFJm0Xz/m+buKWX7aiCaM7DVALalmvAdjUT23Fcqrc8QZ6R6OfVFaX7qXdon5k7I1UP684I66JfZZrHXF+A9ctjfv7GPfeeeHKMUyAM1cT2u91M7KE0Q+zTjd4Ajn9Qf8f83QXg94j9/H65UeerZ95oqu46//VM7lViX+UOvu1TnMrkH34PlMh9RcgSNvhAXIHeiq3UtnOmua3wCTz1VpbmPxpbzxdBFhI1f7The0eOluYviooJWnJfzdJ3eIP3Ar87kOWUGCZlkERWg4n2KocuwI2TfBwWwKi7OKwMvkIEJsj6GOJylvrGEMEwilcOiFXRJ/3vY06nK4w9RMrB/s+eBZH9+9lPfVniiYs/ansoBGR6b5klTPrmMbldnF9IWII2IXnA/Jk7ur6aWZO3U4q7xGtQnuA7GrJN2TdD04hhza9OX5bzJ9i434Bep8nGapY/WUAaQ7mk9We4IL+utAaXoOPPuHz700XUFBdiQnSy2zyl9iskTNmr4fVDeZ/qzOqpmgjB9MIO/NaQ8E4sJVr7HMSAupdV6tEnj
 kHfl1DKo
 9sGIKmqrQzJiS3fdgO+vMMkxo3CkmdRDIW7EHOSOqJGUuOjdJ2ezxQnrcwAOC7S4xqKpKcvJXrSRNHDfwsdLDbAi0GKWD1LQN6nbcVpJ3ij9w9ZoaK80OWVnoi0TpQUg6ysPryL1OqAhKHC5yGppz4hSeokTJtXoj0L/fL26Bvcu5OEY8ycjNRGvTSzsbIuzJTJfTLVh+0yGXLb3SuCjCKeMQJA+wTHzBRU2aAQk+GM54tk9T5W5L6sfd88dh53PjMITbXVYfvmAT+hX1rqIo8bNm/rYuRWptv63aUmvviwSQaW+fpUAToRT7NprN7bc2mphe/GkrtZ1U/vekGlHDxnqLSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:52AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Race and functional tests need to drive khugepaged in step: set up a
> layout, let one full scan pass over it, check the result.  The khugepaged
> selftest already waits for full_scans to advance by two, but only makes
> progress if scan_sleep_millisecs happens to be short.
>
> Lift it into khugepaged_full_pass() and drive it through sysfs: any store
> to scan_sleep_millisecs wakes the daemon, so the barrier completes whatever
> the scan cadence.  A store can be lost when the daemon is between scans, so
> it keeps storing until the pass lands; a store to an awake daemon costs
> nothing and queues no extra pass.
>
> One wake completes one pass only if the whole mm list fits in a scan batch,
> so callers need a large pages_to_scan.
>
> Settings pushes must not start passes either.  A store to either sleep knob
> wakes the daemon, so thp_write_settings() now writes a khugepaged knob only
> when its value changes.  The other knobs do not wake, but writing them
> uniformly costs nothing.  thp_update_num() is exported for tests that want
> the same restraint.
>
> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  .../testing/selftests/mm/hugepage_settings.c  | 74 ++++++++++++++++---
>  .../testing/selftests/mm/hugepage_settings.h  |  3 +
>  2 files changed, 68 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index d7917dce3aba..992efee17b71 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -183,6 +183,19 @@ void thp_read_settings(struct thp_settings *settings)
>  	}
>  }
>
> +/*
> + * Write only on change: a store to either sleep knob wakes khugepaged --
> + * __sleep_millisecs_store() clears khugepaged_sleep_expire and wakes the
> + * queue -- and settings pushes/pops must not start scan passes nobody
> + * asked for; khugepaged_full_pass() is the only sanctioned wake.  The
> + * other knobs do not wake, but writing them the same way costs nothing.
> + */

This seems quite schloppy and way too much information in a single dense
comment.

You/claude don't need to give your life story in every comment :)

Smaller, clearer, human-written please.

	/*

> +void thp_update_num(const char *name, unsigned long num)
> +{
> +	if (thp_read_num(name) != num)
> +		thp_write_num(name, num);
> +}
> +
>  void thp_write_settings(struct thp_settings *settings)
>  {
>  	struct khugepaged_settings *khugepaged = &settings->khugepaged;
> @@ -198,15 +211,15 @@ void thp_write_settings(struct thp_settings *settings)
>  			shmem_enabled_strings[settings->shmem_enabled]);
>  	thp_write_num("use_zero_page", settings->use_zero_page);
>
> -	thp_write_num("khugepaged/defrag", khugepaged->defrag);
> -	thp_write_num("khugepaged/alloc_sleep_millisecs",
> -			khugepaged->alloc_sleep_millisecs);
> -	thp_write_num("khugepaged/scan_sleep_millisecs",
> -			khugepaged->scan_sleep_millisecs);
> -	thp_write_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
> -	thp_write_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
> -	thp_write_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
> -	thp_write_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
> +	thp_update_num("khugepaged/defrag", khugepaged->defrag);
> +	thp_update_num("khugepaged/alloc_sleep_millisecs",
> +		       khugepaged->alloc_sleep_millisecs);
> +	thp_update_num("khugepaged/scan_sleep_millisecs",
> +		       khugepaged->scan_sleep_millisecs);
> +	thp_update_num("khugepaged/max_ptes_none", khugepaged->max_ptes_none);
> +	thp_update_num("khugepaged/max_ptes_swap", khugepaged->max_ptes_swap);
> +	thp_update_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
> +	thp_update_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
>
>  	if (dev_queue_read_ahead_path[0])
>  		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
> @@ -230,6 +243,49 @@ void thp_write_settings(struct thp_settings *settings)
>  	}
>  }
>
> +/*
> + * Completion barrier for khugepaged: wait until a full scan pass that
> + * started after this call has finished. full_scans must advance by two;
> + * a +1 step may complete a pass that examined this mm before the
> + * caller's setup was in place.
> + *
> + * Any store to scan_sleep_millisecs wakes the daemon, so the barrier works
> + * whatever the configured scan cadence -- but a store can be lost.
> + * __sleep_millisecs_store() clears khugepaged_sleep_expire and wakes the
> + * queue; if the daemon is between scans rather than sleeping, it sets
> + * khugepaged_sleep_expire itself on the way into khugepaged_wait_work() and
> + * then sleeps for the full interval, having never seen the store.  So keep
> + * storing until the pass lands; a store while the daemon is awake costs
> + * nothing and does not queue an extra pass.
> + *
> + * One wake completes one full pass only if the whole mm list fits in
> + * one scan batch, so callers must pair this with a large
> + * pages_to_scan.
> + */

Same comment about the comment. This is dense and schloppy. Clarity and
terseness please.

> +bool khugepaged_full_pass(unsigned int timeout_s)
> +{
> +	unsigned long deadline_ms = timeout_s * 1000UL;
> +	unsigned long sleep_ms =
> +		thp_read_num("khugepaged/scan_sleep_millisecs");
> +	unsigned long elapsed_ms = 0;
> +	int pass;
> +
> +	for (pass = 0; pass < 2; pass++) {
> +		unsigned long target =
> +			thp_read_num("khugepaged/full_scans") + 1;
> +
> +		while (thp_read_num("khugepaged/full_scans") < target) {
> +			if (elapsed_ms >= deadline_ms)
> +				return false;
> +			thp_write_num("khugepaged/scan_sleep_millisecs",
> +				      sleep_ms);
> +			usleep(10 * 1000);
> +			elapsed_ms += 10;
> +		}
> +	}
> +	return true;
> +}
> +
>  struct thp_settings *thp_current_settings(void)
>  {
>  	if (!settings_index) {
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index 726c73c43c05..ba7d38370d43 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.h
> +++ b/tools/testing/selftests/mm/hugepage_settings.h
> @@ -70,6 +70,7 @@ int thp_read_string(const char *name, const char * const strings[]);
>  void thp_write_string(const char *name, const char *val);
>  unsigned long thp_read_num(const char *name);
>  void thp_write_num(const char *name, unsigned long num);
> +void thp_update_num(const char *name, unsigned long num);
>
>  void thp_write_settings(struct thp_settings *settings);
>  void thp_read_settings(struct thp_settings *settings);
> @@ -83,6 +84,8 @@ static inline void thp_save_settings(void)
>  	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
>  }
>
> +bool khugepaged_full_pass(unsigned int timeout_s);
> +
>  void thp_set_read_ahead_path(char *path);
>  unsigned long thp_supported_orders(void);
>  unsigned long thp_shmem_supported_orders(void);
> --
> 2.54.0
>

--
Cheers, Lorenzo

