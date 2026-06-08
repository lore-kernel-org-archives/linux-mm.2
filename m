Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD2AFCD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 04:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2926B0088; Mon,  8 Jun 2026 00:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63626B008A; Mon,  8 Jun 2026 00:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51E46B008C; Mon,  8 Jun 2026 00:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 945986B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 00:54:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE57EA0981
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:54:34 +0000 (UTC)
X-FDA: 84855529668.29.AAD7C71
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id CDC3D1C000A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:54:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBmW8jOL;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780894473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJZD1v0uKmRwmTPQY9fhrdbUR6X2mcRzW3srSSIJVBc=;
	b=ZbJDrJLPF/hwvFMdg+IMc9brZESgLMklak+oEYtGEMg6aj+tZSc3FQH5TvOEUWb0Q2PTGJ
	zEm4jrKxiM4zgN/GV38zWvP3Tua/i+CbNNainLmChEEPwkooWWLdwQ4hissG/w3UPGesMi
	cmXwYy0ALUDYBEywlfa6eoTYmUwgToM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780894473;
	b=MiKAOxv9370WJZnJBm5GkcRYjYmGzEddrsniKd95gtrgPzICW99cSeWUHvkW5mG/01iaaj
	ZMXdBI0+qy3o52FZVLMnjV9h4MTg4C69WweZ1auk3WHPiglXPB4oEP/zaCDgmMNrF6aUhO
	dUPNtw0Z3O7dW6LYOq3nnPq5y/VAWtM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBmW8jOL;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780894470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJZD1v0uKmRwmTPQY9fhrdbUR6X2mcRzW3srSSIJVBc=;
	b=BBmW8jOL6IGP4OdE9Tk2dDZ6XAZ07VWn9whCfkMIctmLJAFFQ8LHl3pqu76fyNCyFSDjaq
	tqprhwUKy/lu381KF5DjqtOYK7/1NHPLjz2i56t5p5q7L9rYSQF2gDaL7zqSaVdhlFOy1m
	42nqER2YRyBfnjvZfD8in49rQbw+DNw=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v19 06/14] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Mon,  8 Jun 2026 12:54:13 +0800
Message-Id: <20260608045413.70658-1-lance.yang@linux.dev>
In-Reply-To: <20260605161422.213817-7-npache@redhat.com>
References: <20260605161422.213817-7-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDC3D1C000A
X-Stat-Signature: 6y7tmxtmzj5y94nocdc7r6hyi3rqfo9p
X-HE-Tag: 1780894472-234503
X-HE-Meta: U2FsdGVkX19NSaurPlYgeqvTzaqS6bKNJeYBex/ZrG3LivqtEbXfGXlBWvhsAkBGjWvXA8EVmLTyq8G8hXuG6L13ibTxbVjFnWFcu+5DlEHMjB4lm/AofoQbzukCqyxIDBCQYsMFHH0q9nEcIwUB+6snPmpzhR/JR1wJCYffIUQCLBTmkbtIS2tVjkKteumz3weh9ciecN46dhcbRHpx5fgw26iGdbDJkREiX8aBVo8e77KEpZ1mzntRPf8zLTefNTcR1PH6gu7Kv5pEf6Sap+thjahaqUnXXS/jJT700naLe+/pBoh8OdHiPH4LwROAQJEEDHGJ4LwJmC7z3hdS9SvcUC3jZD06Ts+pEUmbWTvtFwbJe3MR148FV8rRMqtuHGTUtlzCNSruVAISXinRppJ53DNlGDr4KFnDiWIeoNTPelcph5dL5pC463QsLO5rqYMMn9c8o5LoqmB9s1WYQ/qh0uSfrDIlNQroz+ZnFaTYSIzvg6TbqJ+KI6gWnqg770VzDmIcLMwW0G92mVEuhV9n0pmbwaADnlm0E1K/A7MLNIJAwuiDIgRnwSx88q8jf6AdGfuZfBVDIN9WsBort9mSiPEBDRh4wpLp/kpAASCvkFMZgi5hP0BEhMgs/JmerbIAIlRU4Xvxr5LnBjv3jbZPZWV8ZEb0O8CJVrRAi4IPgl5evKxVwESIhbhf6Xt4L/Q7yF61xhbWP/IlXcDGF/IYCfTWemdYeeeMHSp/2NzGz9o2Vp4FLkf1dGnXba/dOejrNmGNcIzRfJS7ThP0OnqgvX1xS/GWOXdqAec+07mKQTjPAWu1Ei4Wx415F84LsMhDQS6Ecueav49xOQ6JLHZhO6CmMbUfK1+Oflw6HTHs4Ios0Gd/bbaKakegIeH9/2gcFwjtn6/zQ7luKAokiWxaReZknDiAHvsIvikLKX+62t9UEHUKNCm+HQtK1zgX+9O2v8cPZHBmmrT0yGd
 NnlplHQb
 DqxE3sO1GeyDTbg6CMwml3vnvQa6B4rpAOrt6bN4w8iYlZ7vJRAzaE9qwNb66pPvNPTO0+NfmFs3fHWmJgtY8F3ySIlF/P1J1rGzYkdBr4U+3SeBFHYBzpVR0fWB+c2kk6E0FWEPxvYEHs5wx7I9H1N4rrbxaAqNAHjarbM9DSVZYooSls/OZOvN/hmGyS6nx+wLOBVZ9R5WO+iXTsgVIe3fBq5Ow0PqNqa7SS/rfYVzdEQeeTuH/udG9khirBtKC4QgECWCL4tTVoEBQfaYiow+Upd0sMhemW0zKMgEMmvFZgM7CQtPD2eQOYt5A8qYf2mblQaVdpGN7Up9J8tf3FEkEytMfoeONIwSN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 10:14:13AM -0600, Nico Pache wrote:
>Pass an order to collapse_huge_page to support collapsing anon memory to
>arbitrary orders within a PMD. order indicates what mTHP size we are
>attempting to collapse to.
>
>For non-PMD collapse we must leave the anon VMA write locked until after
>we collapse the mTHP-- in the PMD case all the pages are isolated, but in
>the mTHP case this is not true, and we must keep the lock to prevent
>access/changes to the page tables. This can happen if the rmap walkers hit
>a pmd_none while the PMD entry is currently unavailable due to being
>temporarily removed during the collapse phase.
>
>To properly establish the page table hierarchy without violating any
>expectations from certain architectures (e.g. MIPS), we must make sure to
>have the PMD reinstalled before the PTEs, and hold both PTE/PMD locks
>before calling update_mmu_cache_range() (if they are distinct locks).
>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---

Nothing else jumped out at me. Anything left can be sorted out later, as
David and Lorenzo said :)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

