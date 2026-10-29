Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD04606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=hmChqv33
Received: by kanga.kvack.org (Postfix)
	id 4FF836B05B1; Wed, 28 Oct 2026 22:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7846B05B3; Wed, 28 Oct 2026 22:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414116B05B6; Wed, 28 Oct 2026 22:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 213D26B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:49:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A439AA0245
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:49:45 +0000 (UTC)
X-FDA: 85374133530.12.ACF5591
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf04.hostedemail.com (Postfix) with ESMTP id CE01740003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:49:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hmChqv33;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTvlG/Tq8WG71QR3KEeqZ4U9dHyqctWa0aSN+5Yu23w=;
	b=wyWXw1dwVaEmomJNrKwY9BCS2mJ4B/9ib16v2JPFze6Gbw7T93qQBbcJLwoD0q8GYxITcn
	kbfmJ3FjJfO0jeQ71MTBGT/f4nM3+vvKsxXW9HdvlFN64W5CyPtMMD3oy6K51odPw6adrV
	foq6PBwNat51ExQlbjdTKxMRsbxVIAM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hmChqv33;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793242184;
	b=yvHidXxkiH5yA5MoGhSN5byzNHQEnun3T0iJ2gtFZS5seiAw8Q140PPoJJgtySfuttfIqT
	w7QTfpKwUex1UTbSUoOdXGhU+k6j7WpBAf/Njm+960NWxeCYCqnYsOEReaiWcBmFnWWt3x
	ez3D1XjZWTk0UZfa0IvQ/k+fzBmQTCM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793242172; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=hTvlG/Tq8WG71QR3KEeqZ4U9dHyqctWa0aSN+5Yu23w=;
 b=hmChqv33gfVO7DDXLBCCvz024yX96oP6jT6I2APcVenpq6En0KK2EPMiu48+40o0B3lZGv
 4d74ls+K2rGOJsS/aOIBvfqvgKgfQLxVLEqsmFtIzNhSxVv5g61UmE3LvnkFIhQja5GY+k
 h7ikl1twG7zZrQpES57sOFAyGRXYGmhFvhpxxJsTzPJ8lHUfhaDXEG2U9g1I6F4k5LLc8W
 AoVCqi+nadH/RpGzeuDcG7+zV23DP16JIwtIC0rRY0eY9s323S8oVUvjeaiuFtlQ0D637R
 EycI6Yf20UFlPP98jncdt805gVOCQweTsIMpa1O/hoqNjbWHNf64FXFpZaowXA==
Subject: Re: [PATCH v2 0/3] sched/numa: refine memory tiering promotion heuristics
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028092004.GG2668804@noisy.programming.kicks-ass.net>
X-Lms-Return-Path: <lba+26ae2b439+9687d8+kvack.org+lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>, 
	<dietmar.eggemann@arm.com>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <riel@redhat.com>, <rostedt@goodmis.org>, 
	<vincent.guittot@linaro.org>, <vschneid@redhat.com>, <ziy@nvidia.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Thu, 29 Oct 2026 10:49:03 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20261028092004.GG2668804@noisy.programming.kicks-ass.net>
To: "Peter Zijlstra" <peterz@infradead.org>, <bharata@amd.com>
Message-Id: <b32b2bec-4fa1-4899-9014-52a6568cbd73@bytedance.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
X-Rspamd-Queue-Id: CE01740003
X-Stat-Signature: rp33y96dmso5gjjjpycmd7itdk6mr8eb
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793242181-982926
X-HE-Meta: U2FsdGVkX1812dcQOV6BL39YlYnvbL1j6P/LnlYKTr1eI6B5DPLmL+YTzLdtv6KStnsE4unQOp2pOWp4FGUFxI9NKcuGXh2dJVDb4UWecKpQIYvYMK8Oz0pkTd51aFjgNqwhojabkAJIVrXyH4kHVIhQUadaZ/8dbdwklpIpXTxWhqyZeQcxoB04Caff5eYaOqTrGW4lKAiPV5SjMP1bqBGLSl1zjjq3l7DNW3LyKVp/sPnEKsGhrouKOygD62+DM2a8IUC9pHDuH146RzNDBXuLH9TYGpxppTFUMXnC6RnGQkYU+CS28C1qcDdHc0ewsVrHM6jDp7EY2HJJQy5AcgZP0ZUgnHZrkwp1hqFJzUP31gVt1R9auJguX2hRxFhAiyl9x/obhf35xBLgWig/EhNQRVcHcKoxOueji52UXuNgXXky4M86tXQ+FS6h1snMD4Lw4BeQ7LVwJ8sAGZV+M4lp80UU95y4XX3Ub8JBVlAEHLneYuQxLsXcVqey9l/fJJnMxdfPl0MZJXzBmHh1rdoSb7u6zyq8NRkMjVd7FSmpKoIHh8b1HDlZwJFFIOMu7L6gsTSbxXBr6FRfWx2RhlSvOMKvgwwSn+qOeYwwf4Z79ET71w81fcaResbUiSaPngAx2gQfcIhpXi2fkIIwPGZiKUoKgRPZnuczva5rP+EVAHYamnVfhWgN/ZEEpXCVld1CEOq3rJCJ8xQAXtV5Z7maIjo8Qdzjuf8CtcyU38jR+uwfxPuiNAdGpYPzNSwUJ4CEQmku9wNaWZpAvIYdudkolyiHvwI8YGR1BbVXP7Q3IIHWDC071FSrexD6RCpyWhuXcQar+BKS4gFNMQrMwi3yUqTf0gRxyIGbPR3SYPfEhrzLzzUmAIavQiubnIDeWDXB+N3PsGkGrouCs6IfsCFQr8TrBlZQWwjxdw87W7L7g5gAVB0llM9AIGSjddJe+eUggK1RZs2XsPenftx
 S+wpzobH
 xp7C/yrzBahbUyC5KXhtAmcLD+oZT3/cYLGgVDPcGywojBR632qvhvwyQ3WOe9zI/0h2UY9OHr08mM22fu1LFf0oSX26Z8hg5qgpl/1cZEdyVdkKqat1ikCEvud6QFRnoieGodUbd04jYV3aT4s5DwZRfjkLWvb7syRX+XSWj98yRJo7ezg6ZtQzBF/8oem7JVT7vv1NIjgJkLWiDMs+Lx5gHpkgRd6m2mS10SDjIbsZCCEk5MGyC+u4mMCewT2ByCSxrlPlUO6xA0fFBOjLxmGl9df5+GkUEhnPt9IamqPwYQmY+yLAlugFDI95i6ABzR58ebt0Ig/Q85vXJYUu70AT6qkpZ1SZbbP3K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 5:20 PM, Peter Zijlstra wrote:
> On Wed, Oct 28, 2026 at 12:12:50PM +0800, Li Zhe wrote:
>> This version narrows the series to memory tiering.  The generic normal
>> NUMA balancing cleanups and heuristic changes from v1 are not included.
> Should we not look at Bharata's pghot stuff first and untangle this numa
> balancing vs tiering nonsense, before making an even bigger mess of
> things?
I agree that pghot is relevant to the longer-term direction.=C2=A0 My
understanding is that the two ideas are not conflicting with each other:
this series tries to refine the current NUMA-balancing-based tiering
implementation, while pghot would be a larger rework of the promotion
infrastructure.

Let's also copy Bharata here so he is aware of this discussion.

Based on Joshua's comment, I can also split patch 2 out as a standalone
fix with a proper Fixes tag, and keep patches 1 and 3 for the broader
tiering heuristic discussion.

Thanks,
Zhe

