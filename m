Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70558C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460FF6B00A5; Thu, 20 Aug 2026 04:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411486B00A6; Thu, 20 Aug 2026 04:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327A86B00A7; Thu, 20 Aug 2026 04:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 162346B00A5
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:41:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80FB6140289
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:38 +0000 (UTC)
X-FDA: 85121004276.28.C9635C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7E6C140009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e62gpA2O;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215296;
	b=3lKlHoTa6SHftzLgIWDrFE5/nrvwhpEsyqIY9RdSafkSxIl/txAJSeptU8qLx7S5lCqdo0
	1iLjjZ1VGwCgLAINbT4/d4Q9ICXPDIZm67EMJDSGg6+lEI9b+inmpnt1b4lFAipLmzK52k
	GK84GVc3cpu2jEBJvCEtC/diJABOfcY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e62gpA2O;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpHGyhSdEUHfDs3jDgskTY0Wx14p0J7I6zejU2vbJrA=;
	b=8hTf97DjNbedW23A04acQxfE7oJ3DTcVN7JyJdXjxQ+Ri9QkfUtMNp5Azhob8QZF+BOFXB
	8wTPFU3lg5HlS6/xJ5AQs1TIaXl6oGHEg/gs2Mc2k601MEnLfcnTAgGXjp3YAauTlKYhQW
	Uv3bLfBveYMurgb6iuBz4AbedtSrmwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B067618AE;
	Thu, 20 Aug 2026 08:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA31D1F000E9;
	Thu, 20 Aug 2026 08:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215296;
	bh=RpHGyhSdEUHfDs3jDgskTY0Wx14p0J7I6zejU2vbJrA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=e62gpA2O8kMvQeXoqVdvxaZdOyffNIsPv1uZALLeLcWAuQe+7l6m4yw8BtAeRGik5
	 ULhE9N1POvhw2RxVdbHPN4kocGJMK6cq56Dkigo6dHweOolLjsBoXMRGGn4i5CjCY1
	 1xTwEjrawcwZZoXC+TibyhTd4Al24clADx20m0vZ1/r1R+th7WFvOVBAon6Dnbp03Y
	 J6A2fQbmjpDAeETEhTXLsqfLyZ351FTknrUC954MNdTbgVpwkgX4mf70x7esljb0qC
	 TJ8LQQvgZ3i9kJKj3HUwt0uLgYy/PYE33d/ln1SC+gw4cqysavvSqXdQL799F+zzQz
	 J1VLp4m8l4yYg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 13/19] selftests/mm: cover a shared-source collapse
 write race
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-14-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-14-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523517.2799959.13840101059380911989.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: D7E6C140009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gktad35hkw1zj97b1c4b14pwcr9m9mje
X-HE-Tag: 1787215296-409801
X-HE-Meta: U2FsdGVkX1+WGp3YkeX3eidvNFXsRppuCxHTGjPplv1DPcAICYmnou6KhyYGCOjE+Hmb6+VS+wqm36/7o4jvxL+NyA3PB6zM3uX3VcEvIzNqnch/GQJZBpJ4Hma4v/71n71R2AO99eSW+68bxZt76gLznjch+YxS/6kCRwxv5+D+fANmI8x12MREEN0+jARs7tPFthxsQ8nWJnMPzYpGyALKj5vef23RjOKSdi2+fA+KkvtXKpxiih5UuZpABE9wdNk1MnFI0elml1QwTF9WE4awVq6P7IRmwIyw/qqHK3P7R9cb44tLnNg18RsWMig9Rufw2TNnLo983r5LHNjlZTVjAnQ6idoiDkb8EN57brffvn13r9/Kl+vxafxl0r5Qi3w/Hsii7F0WqmcSlzOHiOM2d1k3F7FaJiEqec7NhqV89CFqEcifS84K9zP2wbmrSphd2IRiCj5YLhFa6wjB8jcd3Dt1TGuqUT1Tbb+nUs9wK7cXGo902l+2/QAe4+nMRd31SAByhEf0+JvnM7M4sXL1AJXtoFtKEKGU+7/fzYcQNq2NYnsuR/7GbmiSY3+LwcjIF2/JJW2ERoeGkrr1mOncXwT/8jXqaKiPS5t1EChArx8OyK/hrTQqq30NZra+8ihmCncAE9mdJgkM7YBfTiAyYqp1R0L0DI+haYi/ZzLjjTutTtzp2aDysNlH/yHbUB0ltQSCTyX2tgPyA7HvfuyL/8Iha/MKulgwow1BcjgofvZNkTjzjnkGs6wlDzeavRpreVdYb5pbSNsdLlGj3bJIBidgihQLFgOTs/Vjt9v998tFLjv65v4j2ztAhIkF1ZH5pVOpoyFU+3fa2t6DR66B4mtZb6PcCN6Ysvo8ASuKPXfX3GzLdrmXEbfW9pT8hAjKokjQ2Y3FHaZkxy4fl5wUeFDfSkm13TRPXpzjFo7Ik5cTGl+BFlIIw/0VDo2imn0Rlz/LDS7xjoLBbwZ
 hG/jnMkB
 PxcTs3HZMq+8UtXT91wsZpkix06xiDe9IvbmxScfrU/cmo4X3tOdaFHc9YLMIzuKJxbtjpFaoJ+fDXzNHFUVaz4etZRNAeMktaURt91Pvd31XjGf3Ixu5beZ5RtiiCRJNjgOsHln3mwyb6uGQC95tsOj8fnfgd4fak3Rb54UiovefiShGqcTloP6FDBBTBoqIXqGhfnqI0c9X7eX9HtYDhLamPrm892b9VbT/6rGABos8adzbDit4Wp7eOYtwc5H9f/8ddD9Ie7Z59cXcpSSrmNiHUgl6pX1FQpMc9UM2hm+6Cnk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> collapse_fork() checks that a fork-shared range collapses in the process
> that asks for it while the co-sharer keeps its own page, but the co-sharer
> sits still while that happens.

co-sharer sounds awkward, can we use parent and child?

> Add a case where the co-sharer writes to the shared range throughout the
> collapse.  CoW has to keep the two sides apart under those writes: the
> collapsing child must see the content from before the fork, and the
> writing parent must see only its own writes.
> 
> The co-sharer unshares one page every 10ms, and only once the collapsing
> side says it is about to start.  Writing the range in a burst breaks CoW
> on all of it before the collapse begins, leaving the child to collapse
> pages that are already exclusive to it.
> 
> Nothing here is new behaviour: the case passes on mainline, and locks in
> isolation that collapse already provides.

And that's imporant because?

> Assisted-by: Claude-Code:claude-opus-5
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 392fd65fcc97..1d357143258a 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1218,6 +1218,97 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  	ksft_test_result_report(exit_status, "%s\n", __func__);
>  }
>  
> +/*
> + * Content stays isolated while a co-sharer writes concurrently. A shared
> + * source is copied live (not frozen), relying on it being CoW - immutable
> + * for the duration of the copy; a co-sharer's write goes to a CoW copy. The
> + * collapsing child must see the pre-fork content, the writing parent only
> + * its own writes.
> + */
> +static void collapse_fork_cow_race(struct collapse_context *c, struct mem_ops *ops)
> +{
> +	const unsigned long shared = 64 * page_size;
> +	const int stride = page_size / sizeof(int);
> +	int wstatus, child_status, i, n = shared / page_size;
> +	/* volatile: the loop below must really store, on every iteration */
> +	volatile int *ip;
> +	pid_t child;
> +	int sync[2];
> +	char go = 1;
> +	void *p;
> +
> +	p = ops->setup_area(1);
> +	ip = p;
> +	ops->fault(p, 0, shared);		/* shared prefix, pre-fork pattern */
> +	if (pipe(sync))
> +		ksft_exit_fail_perror("pipe()");
> +
> +	ksft_print_msg("Fork, collapse in the child while the parent rewrites...");
> +	child = fork();
> +	if (!child) {
> +		int collapse_status;
> +
> +		close(sync[0]);
> +		ops->fault(p, shared, hpage_pmd_size);	/* private remainder */
> +		/* Start the parent unsharing, and give it a head start. */
> +		if (write(sync[1], &go, 1) != 1)
> +			_exit(KSFT_FAIL);
> +		usleep(5000);
> +		c->collapse("Collapse a range shared with a writing co-sharer",
> +			    p, 1, ops, true);
> +		collapse_status = exit_status;
> +		for (i = 0; i < n; i++)
> +			if (ip[i * stride] != i + 0xdead0000)
> +				break;
> +		if (i == n)
> +			success("OK");
> +		else
> +			fail("Fail: child content");
> +		/* The content check must not bury a failed collapse. */
> +		if (exit_status != KSFT_FAIL)
> +			exit_status = collapse_status;
> +		ops->cleanup_area(p, hpage_pmd_size);
> +		_exit(exit_status);
> +	}
> +
> +	close(sync[1]);
> +	if (read(sync[0], &go, 1) != 1)
> +		ksft_exit_fail_msg("child never reached the collapse\n");
> +
> +	/*
> +	 * Unshare one page at a time.  A burst would break CoW on all of them
> +	 * in microseconds -- wait_for_scan() does not even poll for TICK --
> +	 * and the child would collapse pages already exclusive to it.
> +	 */
> +	i = 0;
> +	do {
> +		if (i < n)
> +			ip[i * stride] = i + 0xbeef0000;
> +		i++;
> +		usleep(10 * 1000);
> +	} while (waitpid(child, &wstatus, WNOHANG) == 0);

Can we please not put waitpid() inside while condition?

-- 
Sincerely yours,
Mike.


