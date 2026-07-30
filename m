Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A34C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 16:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD2FC6B0088; Thu, 30 Jul 2026 12:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84116B008A; Thu, 30 Jul 2026 12:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A993B6B008C; Thu, 30 Jul 2026 12:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 820F46B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:27:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E62C0801D0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:27:58 +0000 (UTC)
X-FDA: 85045974636.02.4E6B7D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2B09C40010
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:27:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j6tIEUUl;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785428877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rK+BoueAu5/AxZSmCB7m3UnuQz/v/hyJVuvyvwdfzbI=;
	b=Gy8z7flHwrFrhHsBbMBQKlTK9FXZg86pq6gLaDZBNf9v5F7G14RxPvwtVMvHCX7vAIOaP1
	md6Wp+2ZeLern5GV527Y0UEcvZZMw4qeCE1bHpLE19sqHGYmKceEHe9nVc2JJ1KqtF6CfC
	SbXNpqv2L54l6AnH9F+93fTnIp4Py0Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785428877;
	b=uLqVmyTiKDI82ofXzQ/saqUq6nFdN5Xegk+Bzo8I+7ZAmEJ1mz2pb4MRoKunTxeSeLJzgK
	Bc/r9m7OJ2lSAsExkC4ViwLBFbKdctA1TQsw3ixxQbMjJfCrfM38rS7kKENr9v+vZjDTdQ
	xoxGGa6ljF+a2A48ilhJ0b8SWepQhzA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j6tIEUUl;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26CE841448;
	Thu, 30 Jul 2026 16:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0039A1F000E9;
	Thu, 30 Jul 2026 16:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785428876;
	bh=rK+BoueAu5/AxZSmCB7m3UnuQz/v/hyJVuvyvwdfzbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j6tIEUUl1k2gnutXZkMGxBNd7fNFdFSvgUrQ8DMy4QKawOTN7aY89OmbT4lxNCmd3
	 1esRWbvsURW6XwxQUayLzLSUYh4NwrEi/akNm/+fI5bK9hs5svCoqnZYCDA5zXBh6C
	 fBdz3uiEKzmW6FJn+g5N/pUMp2cbJdK7qV1FdKtKffDOnnP5yzw4Igrcyrvx0HOfxq
	 jurBquJ1T842oQC2dq0m2qBMh1QAmoe7GGoL0aK5f0gZ6fMuaeH6XLXbgSZgr11zmT
	 zEn6d8iQb9INepnOZe8cYbHbQSKgf+aGQINAH7S1FMo/nTeKRELOR2ZC1hQYiC+hve
	 Ymv8eOKjn0YiA==
Date: Thu, 30 Jul 2026 17:27:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Weiss <thnkslprpt@gmail.com>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Soheil Hassas Yeganeh <soheil@google.com>, 
	Arjun Roy <arjunroy@google.com>, Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: return -ENOMEM for page-table allocation failure in
 insert_pages()
Message-ID: <amt7SRq5K8wwhovx@lucifer>
References: <20260730071323.964321-1-thnkslprpt@gmail.com>
 <amr9zoSncZguF_uu@lucifer>
 <20260730091558.12e3d9029002c87c1f00b4aa@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730091558.12e3d9029002c87c1f00b4aa@linux-foundation.org>
X-Rspamd-Queue-Id: 2B09C40010
X-Stat-Signature: w6s581ugqfdb7mbjtyksuoqmuh8spfdu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785428877-959710
X-HE-Meta: U2FsdGVkX1/tNH/7rL+si/KaWkuNoe1JMuhvE77WtraWPaskFKGbwG1ELgiD8qAohImwtgXsWjaNKYdmmFymHwiBBoBnrJSlAPdU2bsaidzgTMmmPWi4h7TkM9d6KzIxt+AJmH6L1028/6uJ2xrQhGEos+XMNjggyNNcREIH/Fgcztdh7nsrRYJR/ZnTnsEn1d+wZ3GRDU1RFNx59pCUy+0qF3e/QM5mFRSFINA8q7AbXO3FLEgW2vc5fXIPqR6OCWOyZEle0w9NYjBH3GAjIOSViUyMxvn3rEDcMS3xfht6NudLa3phYU0t0Su6yrCRFTtVhwIryN4u4OHTAzCJ2kcv1wgkiwqB7f7P01F3a7ruoQ5rEQegM145CAipxmYQlf+hUOB/yihv1JzjVR96jXr4ICxqhfrSgHIaWQHwxjATkdjU7Lbx7+HsVi4eAKy0oqGZj3ckQYY3SL7mmiCh7FyRT1E0vXJ6V+ZgNeo72AGNC3GgepSkLSh3PCbORWo6yt9FhLWvNGwKX4qRAu2WDNtiDm6hplG+njws+Add2lCcEKQ9LZhCXzrPSJQmzl+UV4O71DfU+T3fkQ/JVsc0fKBOrJsIEusKBbEgxqfdQkJWi+vHgOgVt9o2j5quysedi9I8iDIQFckaayCCMk6zwtKnuYD9eNAfv9S6TqHssp280+vSIdU3dJ/wGBNShs/VCQH0GWu60y1UwjVJgw8CIaTRBPMC5TdeP+R8Vn6JLrCskOxrdx7a5lfSxxsBg9JCLIxZYq1KVzRSg82/xIjqaGJJ8MfHOvxqS5Qm67+sv7HKQegEufUYzvBElGJqTYcIiiUCXers4ASjO+ytrDsnC2DwU7kgNtJkvjkEawvh4VFUonaqSZc4HNppwvNl6i2sDFt7Xrk1+TVTi/dOJka/DKwrd/idjzf/YcSW5NIXfO0xcXc7T3A49IiMbRVDCdzGwfF+PG94dqVY3peghIR
 YOv1+M6C
 oIsy0sZr1k1VOqrIT3pRNzmMtfcUYkydOtO/cqL1jSKRk0vj/sngbNXG2hiP7j9mpu74gkj49AR2TxPMgnm45Y8tvg3U2zQ2uBPHu5wCL9Ab4SXOQie4GsG0Ud1AqFZxSZBMJisAKMK6dlaYFJMTOH3CShkUlVZ110x5iPD12BIlePkt147fumQE3lCdazEy82O/uKBb7EI/YISwtXJQesABdKT6xyrvO44gF4gr9ATnMhw6Ob5pDbFaa7feN+MlTsmsfhp44DohLoHgXhz+37dl2NGrtrJUQU+mvzljfzQD546mdMEbUtV3aDQbeF2W1iLTP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 09:15:58AM -0700, Andrew Morton wrote:
> On Thu, 30 Jul 2026 08:42:49 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > 	pages_to_write_in_pmd = min_t(unsigned long,
> > 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
> >
> > 	/* Allocate the PTE if necessary; takes PMD lock once only. */
> > 	ret = -ENOMEM; <------------------------------ set it again?
> > 	if (pte_alloc(mm, pmd))
> > 		goto out;
> >
> > The way this function is written is horrible in general, I hate 'preset default
> > return value' as a pattern.
>
> It used to be the preferred way because
>
> 	ret = -ENOMEM;
> 	if (expr)
> 		goto out;
>
> generated slightly better code than
>
> 	if (expr) {
> 		ret = -ENOMEM;
> 		goto out;
> 	}
>
> Whether that is the case with current compilers I don't know.

Thanks for the background on that!

I'd put money on there being no difference now :) but in any case that kind of
micro-optimisation isn't really a concern here even if it was the case.

--
Cheers, Lorenzo

