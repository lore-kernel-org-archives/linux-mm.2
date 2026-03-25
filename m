Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B9E7109E52F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 23:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F2C6B0089; Wed, 25 Mar 2026 19:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56226B008C; Wed, 25 Mar 2026 19:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93036B0092; Wed, 25 Mar 2026 19:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4A26B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:57:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6805EE0E09
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:57:20 +0000 (UTC)
X-FDA: 84586249440.01.309973C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A61514000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:57:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J7dVm3oH;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774483038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2q8s6xZcDdvosR0n40JTwr5B4ZKU1GOKhCNbIGTyIA=;
	b=dugr5I23pOZlbxv6kEux1T5f5wwHHTkBIyVD8+3aMluGSTcgthW5FDJopeSDt0N73lhhtY
	GIE0pJA98cl2wmBTy02oSrbV/HdhSWAJYUw0Nik0MQ8hHe/vT9Ik3wnhtrvgrh3roPVpp7
	U+KLO5n+zFN3Qs3dah63wykVZyyv/9c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J7dVm3oH;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774483038; a=rsa-sha256;
	cv=none;
	b=f81VlsAIM18i1qtJJ663HWH3R9Nk3tRIdTE5pYyy/0C/Qonq5dmFYju0wkQe51Z1qMjev7
	gupvHRAvYlUrIcQnamDp8iGyUxpjElQg/Q/Lek0QVZuqpwyIMhLBfo/ZjWX41e5wwjfG5l
	vz7+l5yW07zSWabYGUNKLEPw1QXUFa8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8103C42D76;
	Wed, 25 Mar 2026 23:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DB0C4CEF7;
	Wed, 25 Mar 2026 23:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774483037;
	bh=b3rC6hR82s7Sj9fmU9Bmvjfv+VSj3BR0pCSd0SQMDTg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J7dVm3oHxaqbESIAhtHy/bRJtU3jMAYnjBfyqsVKCpUV/oYma6wQBIy43T1apTF5d
	 +oYJcB1kApd10QnaJnvJ70khNnecrLLls2qcuD1K85jNf6ub9QlRv6dxjx4crlmv5V
	 w0oyR8ZjbbnX9dQ/51UFQKfcqL8FQHZEYc3h6LHM=
Date: Wed, 25 Mar 2026 16:57:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
Message-Id: <20260325165716.5d63522ba825f25a63e74e3e@linux-foundation.org>
In-Reply-To: <cover.1774447069.git.zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A61514000A
X-Stat-Signature: r1niie5tpaw18khfzj6uwk3mqag4i8af
X-Rspamd-Server: rspam06
X-HE-Tag: 1774483038-669400
X-HE-Meta: U2FsdGVkX19RexlfuD3304Zy3kF9IwZWFKe1ajntXii9IGMVmoRyCkwTc1aDkxERmNHrIODTCXQjSQZ5J+4WpFehdWLqK1jJpOI/5NyLXhuI3RUw5qs/qvG4BQBS3f6f3LU23NDQKNpwD1uIDhRKAU/gt7oWM6CZUOjOWtEH0zKomF5unQOooiEBWiCEH8tOjeR6vxAXANBGWTkNtwJ3A4rw4TsFaVm0o8eAqGzqFbLqc7LTFmU9Yqe2wVeMIQjh6xlTDAGGAvUrNLZm78NNna5rTGYNp+9ZANq/nX99jny72fQnPzEUi1+DhtJJ4e5SMqsDLLJpTyi9GAfg3qokkccWmTf8wW8Vf/NACoIYlzcip63O+GymVe4If3Yfpp7Bc6Vm5B6NC+zbwiaAqs53WgwcTJnMMTm9ky+TchRU5AD6OhPYXYMVPxlDipz6r4ZGftnwCmE6GCaFwaQ34PUnNpghrpSkmsBKo6u+piaJriBo6wjARChX2woPY+ZpqapCcv8bLLHkqLYsV6yzefFPPVABO1ScqTINrv9YTLBg8jgFA9NrjgiV+mSWHEyFynURN6+2ScDvTnt+Y80VXIaqTEMxN7D05771rbh+vaEkcShO+O8Xz8XF/HykYoUjsPN8fLvPWPa7UybIn4EO/eM5PSRpmcEdnK0weTM/9T8nuqccYqZvluOc4J9RfJzb0SM38W18oYQUpVqXFEfuR8uhobxgFkCyz9VowcDNl+typ/e6m8u55AWflEHUXLcsrgUSR0L6DEVZKui1Og8NT+swxngRgPOPvkOf8o+/2dUgVQOD5gvM2xuwbpX0pxmye+IAe62VbL7UiUIET+Al7vP/MGkynxaD5ijPI4VOInisFrsckCr4MSo8qmVnzg48oRb4Wqi3CgJLmXMPf53Q7VVEb4vD1EXlntJdU6pO5LxkviuTXR0yniUzp4cleo1s4bjgwxj+ZvHjiL0R3BN9Py1
 GfkDqhdg
 sh+R4Hc/8In9Xcr8IxHOsABRfKXVf4rADyAEUYDexaxtUyLNe2HnCqv2INiPpdIbs0IzEwtVh0cBdWylXZjAJpexc1oAGLrZm2oRg72+g0xkYohJH/fcgG2zOeW5s10m5SWmHNsMd/J9uHaFHrR+YAmfWNHJmC2MkS9GIx/hUngaHmSrqCzpJYxJog1WCWAE0v7TkiWuiR4+2Absm4hOG4HE+mrJrdx9S+qDcOvZPtZtDqgfUgG8lbSgR86Sw3WSNQ4h5Z2SwtDQdy7r6MGRDCCrIOuhkMABlKXC0f8sVJaSztCObEmyOk7A0ZmVUPb/CuXPHxRiMaY1huHR5EadPZ48JnYnKkcezhSOW3RNkeWuD2PI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 22:13:21 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> As Harry Yoo pointed out [1], in scenarios where massive state updates occur
> (e.g., during the reparenting of LRU folios), the values passed to memcg stat
> update functions can accumulate and exceed the upper limit of a 32-bit integer.
> 
> If the parameter types are not large enough (like 'int') or are handled
> incorrectly, it can lead to severe truncation, potential overflow issues,
> and unexpected type conversion bugs.
> 
> This series aims to address these issues by correcting the parameter types
> in the relevant functions, and fixing an implicit conversion bug in
> memcg_state_val_in_pages().

Thanks. I'll add this to mm.git's mm-new branch.

AI review
(https://sashiko.dev/#/patchset/cover.1774447069.git.zhengqi.arch%40bytedance.com)
still points at the problem in [2/4], now describing it as a bisection
hole.

In
https://lkml.kernel.org/r/5fed0611-434c-4fd4-956c-39f23e0459a1@linux.dev
you said you were going to address this by using abs(), and I see that
being done in [4/4] so yup, runtime bisection hole.

I'm inclined to mark this "don't care".  But if we decide to backport
[2/4] ("to prevent potential overflow issues") then we might have a
problem.

Also, if some downstream person decides to backport [2/4] into their
kernel without [4/4] then they'll have a bad day.

So perhaps this issue should be addressed within [2/4]?

