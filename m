Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34FD1606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 03:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=giD39Nh8
Received: by kanga.kvack.org (Postfix)
	id 45E6F6B05B3; Fri, 13 Nov 2026 22:19:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435146B05B4; Fri, 13 Nov 2026 22:19:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D5A6B05B5; Fri, 13 Nov 2026 22:19:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6FC6B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:19:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 839EF140359
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:19:53 +0000 (UTC)
X-FDA: 85432270266.18.6104B4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F25DFA0003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 03:19:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giD39Nh8;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794626392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHM/e5uf2eSVlQ7kyM2fyd4SNEwi6bNaKWU2kNh7FPA=;
	b=lRxqsLscSK2ycluBGAaQw5UD9Rvh2HiHrZyjXqneSo2E+wezhkdO1eNiGy95PY+g39uZbA
	qp5P8CHa2DmdhV29SWhUR6k9Bjy17e144GzUhDSAt7uWaZ9xtbQX5c+YGPWdEepNA0A1Ez
	FZjzfbdtj2mnf+B1XJ8BhfRJsJpijB4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794626392;
	b=fdHC5fxtRQTh51DjirJVuSYRCfTrgmyMeSCLsQAyV2tDvr1RY+C9YkYu7LXvTKNamlyvsQ
	8XwEQKuum3627Pr8Vuxtm682494fy96+AIBWwjwrukgOXU9WmI3N1cs9TMChNEJCkT1G+o
	4EahIrHCqFXZ6E8RfR6WYGCMhSaE69w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=giD39Nh8;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35EDC431D5;
	Sat, 14 Nov 2026 03:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EBE1F000C5;
	Sat, 14 Nov 2026 03:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626391;
	bh=FHM/e5uf2eSVlQ7kyM2fyd4SNEwi6bNaKWU2kNh7FPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giD39Nh8WLWpBEfojs5C/SZCwFUs6PAMJqvIYhgfX7PMOL/oLbA/NKNtF+1A2K6O5
	 zgRZViH6ye5VxOLTrMhI3+PaS8zZTrDVENTGLgmaFtVs4YjZXI4C9oWbolXgtCZZqW
	 Kway5HHWhsVZCGXLhF1QeSkKdrfJaoZVnzC6S9mMGc+8sL1/9nn4jwPciqRflu6krw
	 HJoNWlZoAxM3HZ9yhzL6C85eVDsc8LKL7RIKGWpq5hY40VlyQSqiLuNG/7gBPFq8NL
	 WJcgXwMmwZoeCzqYX8vDwfFPU14jL5pIHlQq6vDxo4yC8jmw4HSolH0EX8B2vun5nq
	 GFLTEW8qPOzsw==
From: SJ Park <sj@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	gregkh@linuxfoundation.org,
	4ncienth@gmail.com,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	corbet@lwn.net,
	david@kernel.org,
	jannh@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rdunlap@infradead.org,
	rppt@kernel.org,
	sashal@kernel.org,
	shakeel.butt@linux.dev,
	stable@vger.kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 7.3 463/507] mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
Date: Fri, 13 Nov 2026 19:19:42 -0800
Message-ID: <20261114031943.192867-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114003912.82206-1-ojeda@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: totrdbc4u38mwgx6b37k5asi1o5sfwas
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F25DFA0003
X-Rspam-User: 
X-HE-Tag: 1794626391-66437
X-HE-Meta: U2FsdGVkX19eQLC5mZiKcOb21IAeSLvC0GrBF1atMfHyKd/n8FGerLWQGsUT+ndQLwMEeYwoCYf1ujEwhhFObxgyOZpdWyOA32JjNxACOAS64ia2MB9vGPzEULsffsZtV784ZUKQsT3nqfLu9uzcIDiKj9LfQ4OD/5JocepOaWUw6yKkOijnxbzVFuEtPyuW2I95oDOuWzb5CyHnjQKxHyjNesbJmQrAMOkK+I7Ayp5YWK4x4sNceNxdwWx8OEffz7G6ekv1+KYIHkIHejJB/Dq/oodd84j5nWLMz94AEH4bU1M+LqWhxTfwbdOom7xRxxc4bLiT0hxA2I6aTcT1agKLLfO/tm+gRSZ2YzZbjXtIgSKdpIh4G35tIx9IvrfqaYkz9TzMSIYG0IVIhLrCxXQcsUo25GnELJalt2EDLvh3UK3f1PxwCLvQDFsMHMi2jwApPP89ZkzJm1jzhzTQaiLSHfZ+WW4mWb1hecaGb9ACBTh3/WTBW1fPPRCkdFG2x58ELYTYHiRnLGnKLbyistjo6Laz0xNmqucgobsfsq+thWI+N4uKIbt6GdZa+btOqGJ8Jv3rtH1PxQUd56vX/tTZD4ylKizAYvyJChqGKg95JUfVB9J4ql8YgFswHKDFbPZ8NAh54+7QzhzMNTRe/XZJp5dPRjbIbwZuCJpCMU8WeueGAd5lX2zGa3XCOTeKt7+vmCiJABxcDPXXhsoLHfvdPqeKVCCzog7DX2/xg2JAAKskmduQyp4UQesfaou54W5sZXEoEnEpBAoKIN9VQqMjc0gkmSYLr3Z677o3+mJl+CV/aPQEltw2lf+fjX1XWL7SK95neKxiW3xF1Tzv9bmhOwSkr+M2+O73dovWYl6kLADsr3ePbuF8JLOvWyn2T6RTiO3urDSaoSvwmTxct4qW8s0yTXPdhiIG+q/aLXpzOSOp090NkaprsaDTKIHR9jn2gjbhJ+18jqx85Rw
 Bq7TFNVn
 wYWwb279FgTp4ArXFuWy82mgTB/iwWiNUdx9MUvaVnHDBIgjqKObEVYVbT210rIizlfoilOfSH6oJXJKHqAEi/unJTzKQ73awzhZnYHCnCTm87ZG/WSK94OPTTmfExO0H8KyrpYYCFv8DAWK121YzKNSO49mbyqk2ZO0ZuHKjJmJ/JkR1qvKHTQ1ZwpvCXX9I80EDwCjJ6CowkF8Um8ukdwF+ODDJS2qAbKA4dtxvLwmaO4x/mZVSdfLJzG+Y/VuksHeqk9t2Tf+4JyPydqwbEyeZzcYPladcXhXWrx+OwTtTfxxoNB6RUCLYEGX9kuZnoLv2CLDjMyK84u2TYAg2XQEx3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 14 Nov 2026 01:39:12 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:

> On Fri, 13 Nov 2026 10:52:47 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > @@ -589,6 +593,16 @@ static inline void vma_end_write_all(struct mm_struct *mm)
> >  {
> >  	mmap_assert_write_locked(mm);
> >  	mm_lock_seqcount_end(mm);
> > +
> > +	/*
> > +	 * VMA seqcounts are not updated on unlock, so once the mm seqcount has
> > +	 * wrapped, any VMA still carrying a sequence number from before the
> > +	 * wrap would satisfy __is_vma_write_locked() when that number comes
> > +	 * round again, and readers would not be excluded. Reset every VMA's
> > +	 * seqcount so that no stale value survives the wrap.
> > +	 */
> > +	if (unlikely(!mm->mm_lock_seq.sequence))
> > +		__mm_reset_vma_seqcounts(mm);
> >  }
> 
> In a UM ~defconfig build with LLVM:
> 
>     In file included from arch/um/kernel/asm-offsets.c:8:
>     In file included from ./include/linux/audit.h:13:
>     In file included from ./include/linux/ptrace.h:10:
>     In file included from ./include/linux/pid_namespace.h:7:
>     In file included from ./include/linux/mm.h:18:
>     ./include/linux/mmap_lock.h:604:20: error: no member named 'mm_lock_seq' in 'struct mm_struct'
>       604 |         if (unlikely(!mm->mm_lock_seq.sequence))
>           |                       ~~  ^
>     ./include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
>        77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>           |
> 
> That exists only under `CONFIG_PER_VMA_LOCK` (commit 47e725702b0b ("mm:
> make per-VMA locks available universally") from Dave's series was not
> backported).

I found same thing while running kunit.  I also confirmed both applying commit
47e725702b0b from Dave and reverting this patch fix the problem on my setup.


Thanks,
SJ

[...]

