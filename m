Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE67E98FA4
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 03:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26366B0005; Wed,  8 Apr 2026 23:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD72D6B0088; Wed,  8 Apr 2026 23:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3C46B008A; Wed,  8 Apr 2026 23:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91C0D6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:13:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47410C1903
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:13:04 +0000 (UTC)
X-FDA: 84637545888.07.583E766
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id 66E3080002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:13:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LigXKnCR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775704382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tnm4ASEvxuAGS9O/mCz6vfaKJ9pgbfb88R+jjoNir8s=;
	b=lanfUF7+xZLn3ohWIHKq/6SLvyypiypp7cPv5t8dV9zaZ0djcl3xKnuIOAlSp4FeaorBxx
	BR5naAdzfJyuC8BcL2DoR/CnO1WlZNkU0YYivSQ5OXkqeSCTMs4HqJGqmYI0721li0+z9p
	fzK9+EnMyxTgBquSxqUcbuUOI9MzZTU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775704382; a=rsa-sha256;
	cv=none;
	b=X3Ktg1b+5nk/48BoXGp0F0FGGkILx3uXWwu17ztmZ82Q88dM8p12IOTbDVhuSYrnO9utjE
	G9g/IoXJiXy1IP3z7ne5dtMQM2M9BnrZu4yYN5ld28GlHByTV5PJKgWaEpRzvkuKGnZlZ7
	u8Ql1JLOdFNBnMwhaSMsLAes3OW5Rew=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LigXKnCR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775704379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tnm4ASEvxuAGS9O/mCz6vfaKJ9pgbfb88R+jjoNir8s=;
	b=LigXKnCRgarM21TOf/cb4B7tMyUYY2/wCuDYyxmsOjzw+ZgMZoWLg9MCgetZmYYJr1l+qZ
	BUIcIu3nKoEJBJ3CcMl78JKgUf1/++8fmWPaqRRePfhe6HCOCgbVS5SqWTq3W0UZT6bOhk
	V6u6K5kfDJFK3QJgELP3BWg/DQjbO/E=
From: Lance Yang <lance.yang@linux.dev>
To: ye.liu@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liuye@kylinos.cn,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
Date: Thu,  9 Apr 2026 11:12:42 +0800
Message-Id: <20260409031242.91778-1-lance.yang@linux.dev>
In-Reply-To: <20260409014323.2385982-1-ye.liu@linux.dev>
References: <20260409014323.2385982-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 66E3080002
X-Stat-Signature: isqwnd3yw5yqsqnsx9kzwmdwpfgso6az
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775704382-608219
X-HE-Meta: U2FsdGVkX18cq9CDdizGFLappdSy2/KqInLmp/SuZnuvvnWhfU83MJeGoCC03PUbbaW8am8amrX9cKIV7M4cY6VVVIxIFpL+8UqmNg/EXXHf2bP3HDkQiBwyfMOw3XST9qwBVRv1lHo7vmge4RrzB650+nBsDPx0MN4zhqeTdzJ+kX4tYHTxTcXwqd8ZyC70Umm1DE/lEDimmY7G3M4mgkN3qc8Ge16Yj1K8tkZHOWgpm2kkUYbpxXcQtQilkU0HIPcaL9IjIKHKVnUY5AWI6TUnHRh657hZ73fpTDlTFOb7YIAqC73wBZTM1fePOtR8Q4ZNW425UjZWLdrQA8UdJLMNBgSW0K27jgYxuupX9PVyS3RzD4BLYFm9mJQlsqyNemAljwUO4Nt21zQxLI4M0LvgPPqhjOPI/M5TYZbromj6y6m90NHVOIfLSYytejrHQVCJlM4JAHbG52/4v5BtIUE9Vmy08h2PryRXY+vvRI4r4fpQXwsKsaPzm1+HhA3oWofojqGuu7kXQmjG+5rusLXch52s5SGhZySJLpYgv36QUli8meZGA47TCJJ/tj4lC9wW5T73n57vw12kZjiH4PHbLHtfl936tzfig3Zw9rceyZSvXnNpEB6mU68A8BRqupXnn8uqTylLe7WPpSkDbtSbxNL9vOzmd6Xga8J6Kk+uFNi6Qsu0ul8uLR4InSqq7CRR+n8BQUBE0rbaK/0Vnti1LtTF8fb3XZoCyNcAKprAiP3Yc94sC6hGsTN+0J3NLg5QKd4d2U82GfqYSlxGFrvZRKL25seAISbGFls5+sKyaBlLjqBOQvLU7GcO9cCJaS02tnwHP5eZNbIvedNW1B+6fX1mmOOnmrzBH5ZMmG77Q8mqi791KAi5eMP2rlU5PpdPcDJrPWQ2f0pO/I/4JAkkZ5qIpRnHiSZxYw3NmEsZbBaIVAozDtLdZpNC/oPOT5wzrRDDv45nZZdXSMh
 7LbVz0Ok
 J+kBmLcDaLiJPv9nGEs+hFfX/12bt6BJrEMba/FmbEyDnfU9KppbTIY2zbmUZSN3WJDwSxON5cRg17b007aTiuXKKIJF62A4FuuLni+bOUNxCrF3sfsqe/r6oYWZ6dSBLPX3DO2Utee6kP63LR0kBaiSnsSpZMH6sVMvlHae0jp7ex1682FsSBp5oh4Ijsp8MAQqPYgSTFuWaAvQpdRtm+1voxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Apr 09, 2026 at 09:43:22AM +0800, Ye Liu wrote:
>From: Ye Liu <liuye@kylinos.cn>
>
>PMD alignment in khugepaged is currently implemented using a mix of
>rounding helpers and open-coded bitmask operations.
>
>Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
>alignment, matching the preferred style for address and size handling.

One more spot in madvise_collapse():

hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);

Maybe switch that one to ALIGN_DOWN() as well.

And there is also in try_collapse_pte_mapped_thp():

unsigned long haddr = addr & HPAGE_PMD_MASK;

Just a thought :)
Lance

