Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB88CA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 13:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6076B0088; Sun,  4 Oct 2026 09:39:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67746B008C; Sun,  4 Oct 2026 09:39:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C7E6B0092; Sun,  4 Oct 2026 09:39:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 961776B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 09:39:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15C2E160987
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:39:32 +0000 (UTC)
X-FDA: 85285050984.16.F1215F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 68EF2C0005
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:39:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcOs3bFT;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791121170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsrDocJZdlQZzp7Ptz2pku4WR7O9fSJpN8UbwntIi3A=;
	b=GO8LP/q6xxs4ZmiT1PcAFUpnyFMHas18PcmNCf+jONY506yG5bxmpp+qzVJyCtNxpfVRQ/
	0QiTC2H8Hr7iHfJ1o8WtfDayqqxoIjcA/s38ibtsiV2lEe2FFumJnO9lWLIXeC08QKnWCp
	XyKeVmK3bkhtkJyPY6onbRvAAWwhmmI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791121170;
	b=0xaJoeb9xmO5fVn6UXa1I3gKKWOPnsWKPylKdLimruHLRBKTGM70F8CmGvOMFP4kdOvx3h
	77Z8zDwjaQdCVNKl51JeKDiwB2YsPHYsa0ZggH674dR2UCIPP2SGxF6HWHT1Fj/mCEPP3H
	jrWVcQrHWzGXxYmnW/8KJZF85qwqC00=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcOs3bFT;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 715BA409C6;
	Sun,  4 Oct 2026 13:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5187D1F000FF;
	Sun,  4 Oct 2026 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791121169;
	bh=GsrDocJZdlQZzp7Ptz2pku4WR7O9fSJpN8UbwntIi3A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZcOs3bFTNsWZukdiTl3x+IP7PA8A2DliLliY5QfGjDg27+Z2MCB18ILo6snmzo0/W
	 xo7htjt3Fp6s2EEBNA4CZgWLFFiRbq0z8Np7J7OeRAtXN2ddBRb/g5UHnWRAiyd805
	 Qc+IDCsNXXpmRjHj/+DV/Bccru5g270fmeKKDXoo1IHTf4efZ4MQeDrqM7sKEyhii3
	 53CjYfZTtvNNSMnt0k7ksGc3imoaU9C3dKqwB7fLCYpqzi5GE9gWTeB9zhvKQNp9me
	 7tEtoSweYdktzE7hX/E7FHLU55YjOMVMelRl9n/74VzKyJAr8fnxGRYaL696gVLa5a
	 BuW+FJdbiyOIA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chris Bainbridge <chris.bainbridge@canonical.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Miu <jasonmiu@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,  regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
	linux-mm@kvack.org, =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?=
 <mclapinski@google.com>
Subject: Re: [BUG] KHO handover hangs when memmap reserves PMEM
In-Reply-To: <asE0R_f2r2TL-3Sy@px13> (Chris Bainbridge's message of "Sat, 3
	Oct 2026 18:02:27 +0100")
References: <asE0R_f2r2TL-3Sy@px13>
Date: Sun, 04 Oct 2026 15:39:25 +0200
Message-ID: <2vxzcxtplh4i.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 68EF2C0005
X-Stat-Signature: hoq1hys4a3dke1ps9inowks4a7apqhpf
X-HE-Tag: 1791121170-523065
X-HE-Meta: U2FsdGVkX18hL7licXGLVa33vcvmi34alaFRKmfpUs6hYEhC7IKeVcGSQnE1wotn77GJlwl1aC2QyMwP57sIDE9bP2RIoce8u48aT1rtIAgzHn5RJOJb5KFXLzEqYzMGoevvTeHR07Fqjp73UloFXYTo3FAX2PM0//2rjc9SxMl9C2dxvGwvd9wycx4Y05dv3W57QbDnwLReRXlza3gUYnZPVUKA0wfUJ6JRLJzDqM7LZXSg/ySD0lU4i3lnDlYzmcwV7MxH8BaNjOvpEwfAbtaFaQ4VXZNr1lYNqxvU9j8rL1H3F8BN81I8pp91Wfr9RUPQyYSV8UUg5AfPg8WpD03wkFFhexh7Z8k4JV6tdZZ8BHZ25m4dBwGGgGIl/VTrJUFvI+/7ITpacHQJQdBlpvYMpwWGlfg6C8OEq8NclUJU6dPxDJv3C2ygj2PbPq9fNBqhcSXLHXbAXHRV9P36hkEh029/qDoZdczTNhSPMXD+6jmRsNaZl6XZUFc3EQRLU6XiMz65uJaBxgTYMS6NXImqfk2LgBdagm04lqShymwhh+rmLdubTwf2XoAIWMVf4j1rKi/bQbJ6kHj1pRp9N9+jnbpyibdz4YCEtjVH1Q7DPe6pZ6D8ZlSfYsbTTrymQzDosah2yBkXGvLb5zJhn+Euv9iFpI6ZhDvE0UpsIvV78hgr2hgEAPtGwgnI1LGNCvxC0aMiZ3HeMmAVqyOI+QpF/qFtq8/vN8jgcNV20alu+UEO75gJrhhcpn7ARKPXjHS2hqFC6yhY2kh4cGywj8y5/KSq5F/I9FIBnlmevdLhC8Rv98R2z7QthlT/hFHrWXcvA0Cruni8MJEVoi6IE6nZbp37sI96kVOpRmFMoY8Yz7DM2/GDmU2cY+Yq5QT+sEKp0WUnJjNEYNDuXLNhugRQxE+aTd7+6Hy8EsrBoW/CZxyXAFEkrBWU4CXTq9PAiOhZ9AeiYAcofLrP64I
 0qiNO+ad
 kWmo1CAuvELqUkeR9+9psvhOxrWwTZP+jVQNL0+bNmygu4GB24HbXLJ/E2W4fkdD7iYhQ7yXVeQR5M6aVBR8hz7Nt2Sop1en+oiKy3lAT3fplGP8ly5B5Hj+XZgjXd3DTSDBmgK0fXCkLVkgdpUnfFX6djgNmZ0qZYwIOp7VbaN1Slurd0/PzSC7x49RQKgffUcXzqUamDacLNm9bPn1jnLCN+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Oct 03 2026, Chris Bainbridge wrote:

> Hello,
>
> I am reporting a regression in KHO handover.
>
> In the most recent Ubuntu 26.10 beta mini-ISO releases (2026-09-18 onwards),
> the first kernel reserves RAM for the downloaded ISO with a memmap directive
> such as memmap=<size>!4G, then kexecs a second kernel. On affected kernels, the
> first kernel reaches "kexec_core: Starting new kernel", but the second kernel
> produces no further output and QEMU spins at 100% CPU. On unaffected kernels,
> the second kernel starts and finds /dev/pmem0 with the expected "Persistent
> Memory (legacy)" range in /proc/iomem.

Just to confirm, the first kernel boots without memmap= right?

If so, I have seen this before. Michal (+Cc) found this originally in
our downstream test suite.

I think the main problem is that the radix tree pages can be anywhere in
memory. So on the first kernel, they can land in an area that the second
kernel's memmap= reserves. So kho_memory_init() might end up using
memory that memmap= reserved. I'm not sure why exactly the next kernel
doesn't produce any output, but IIRC memmap= memory is not mapped to the
direct map, so accessing those pages likely causes a page fault.

It is not easy to fix. We would need to make memmap= aware of KHO and
skip the radix tree pages, but that is pretty complicated to do for
early boot code. And honestly, I don't think it is worth it either.

So I'd suggest you turn KHO off for the kexec that adds memmap= if you
can.

>
> A source bisect identified 3f2ad90060f6 ("kho: adopt radix tree for preserved
> memory tracking") as the first bad commit; reverting it at the bisected
> revision restored the handover. The regression appears related to KHO metadata
> being accessed after the receiving kernel's memmap directive changes how the
> metadata's physical range is mapped.
>
> #regzbot introduced: 3f2ad90060f6
>
> I have an AI-generated candidate fix that changes 22 files. I have not attached
> or published it: although the AI did extensive verification on both x64 and
> arm64, I cannot review or explain the complete change, so I am not submitting
> it as a fix. If one of you thinks an unreviewed candidate would be useful for
> further analysis, please let me know.

-- 
Regards,
Pratyush Yadav

