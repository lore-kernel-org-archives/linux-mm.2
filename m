Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72CF7C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F786B00D8; Tue,  1 Sep 2026 10:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004E76B00D0; Tue,  1 Sep 2026 10:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62066B00D0; Tue,  1 Sep 2026 10:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1ABA6B00D0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:45:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 451C28026C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:45:03 +0000 (UTC)
X-FDA: 85165465686.23.15682F8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2B7D01C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:45:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JwJXK0dz;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273901;
	b=FoEhF7+i8WTG7TBrZC2lwxWnwwnb9lY/gtb9f/wQsxmKRQy+idXKC6mK/yRR96j+QyLI6R
	TRHzcYaUYDwWkKF/hvUKX3+Aoyi4MS0aEURm24czMxS+Nr/f8OEBUVDoSS5dz2+a8fVLQK
	VikCrCHV1EF6K5KKrkNc+9z3c6U8Ey8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zi1O63veibWmbpQLKyNgIo0W3ylRtY8+gyDmMJt2ycI=;
	b=Snmy0UnNS03bHlRzwl2CVdgn3ouawMDjSyC7oIy6QGJYardMFMvepCz1kzWaf4mhscf1IE
	o9SWDID8+fq+d/svtOeAUleZ7PcdwwTyH6lOEcpxf6HCCqRJP3ooje+BlDwunXyaceO6y5
	xTposLUHM6tgb3t/kJ6nWc0viu7eYBQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JwJXK0dz;
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zi1O63veibWmbpQLKyNgIo0W3ylRtY8+gyDmMJt2ycI=; b=JwJXK0dzcOpJ1IqGXLqFdbDbzU
	FRVvk7bxSI7Ah2AIvWIVHI0FQeDIxyvhBFuif1zx+VQHuFp16/DlXHo2RHfVYN/M33r1OaY28HQYH
	YEmCVsImkX6RXOkITQl8fKcn0KVKj2NbXGRVlElbHUk6yVzylPBm9E4ZnivF2JtkpQj+J452Cv+jj
	6TNPEDVjlRWVQp6qSifGX/eET4yxUOcrR2+LAnCpNUK9aqU+8CN7EmIK4ycWr0EgYRADIT2gT/y0n
	OUA/iRTiOTpYAV3M60vrTx48lxLP/Ewaqud6W0SZSM8J+MvPd0XpYr+s0Mu6bCY4WCOtXed0sCYQr
	ALxy9PNw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1PjG-00000005Gto-2EOO;
	Tue, 01 Sep 2026 14:44:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 728C430031E; Tue, 01 Sep 2026 16:44:49 +0200 (CEST)
Date: Tue, 1 Sep 2026 16:44:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jianyong Wu <wujianyong@hygon.cn>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Phil Auld <pauld@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn,
	huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn,
	justin.he@arm.com
Subject: Re: [RFC PATCH v2 20/23] sched/cache: Estimate utilization of the
 whole thread group
Message-ID: <20260901144449.GJ776954@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260828021156.785662-1-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828021156.785662-1-wujianyong@hygon.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2B7D01C0007
X-Stat-Signature: abxpcpc19ffh5yjw1isbgp7ons9nojsd
X-HE-Tag: 1788273901-131175
X-HE-Meta: U2FsdGVkX18cXjXEmLipMCo7iWVkOsSefpV9i0eY/Uk/un23UrjU0P/58GNfyNpE/lXeHkbBopQvOOMoGO1z/VWLVxdK4Z6jWF7lEYZziTDDeIyJz+7XX8H/mkiJXkpp1PfjheZmuL5VVuA9h48yCe3GDqsmtvgYpyE299ynYR26m6h6eWRpPwfKH2QkuySctfBLEhw1Tb3zsRKAvRiTpLTXg4/qKrD6Dnyoonj4j7wqWxv0INdAO3Y6RIVK1+lHeJW8K8+e7XuyKm8hVpjFsADFCXNJW+XXQ5bM00jiFV1JQSndIKdlc8aXjL0daWPp2wh1SzuzR/JtNdoGUsXgdL1DE0nZ/UQwDXVchtT8kVUCqBLw5hzvm0kBTXHjo+qQRrQ6nt2s+rHxTsfEhy/sFb8DQ2MTi13DC8oxMuSF6KlfE1WYCVOvRQ/CTOOYW66LUNmsmFjw95hapQZ7zyaaJ0lapNKtAdLYmV2eRNcBRCKwpBdd5nIqA0xNtoj9CAhW4Lk78xOa1mKUOdrqtMvxkZBgY8jZb41AhMJ8/y7YqOHwGesrPrLvHiqG9ejIf/fhLL+lg94namNms7bD062KGW1hm25Y+nEuBTQcqdn5WQlAhyTtpq5zKEf7ScrHMDSBKlHiDcaadM/GQVNpa0qZXUH4C7j4OLqgsk6SDPLpynSZd7zZk1c5/0bB3fkycOx2ZtVNp1hEwxSgbsvpyUFhbhBZ7jhCrAXSFADO2c6SXWDCdh3yI0zVUZB6ha3SJy1ysvdV8u6/QRh/dP3QqtUV2v3EfvrqxDkMJ7MT5vfKKMa8PlPczMCyN/FBMLHo33Vgi26FOkm1EezdOgOymWHHDXCj7w48EzQ5TpRVcxtKEy3wsdyXxcvtapCbsuNPb3CZHnY+vD3tPkw5VPcNGsES6MkwsUmG5yhoK1qJuIiswH8MqW4xqVEaaI9Z2KnkYofoXRhd9wQPRJGAxZzPH5L
 0YKH/bY5
 0kLzNzS+pmfg4kVHinfLP0zKGmFg1SdRi3toDCf0RjDXdB3mw7d26a7oFOD0+kx+aFc079n/+DF7voDfuVZdb4b8/vn6BWJ4L6so0VoC/NKfvG8buRdXlZ8DNiF5BY2m5NBMEtbsKgJpcP3P2fw0dfn7tGXb/FhXaLQUYH94F1L1SizSomGVtz3Xaf5r+p/aHw1OvymG1HmBmjxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 10:11:56AM +0800, Jianyong Wu wrote:

> +					mm_util = mul_u64_u32_div(cpu_util,
> +							min_t(unsigned long, occ, NICE_0_LOAD),
> +							NICE_0_LOAD);

mul_u64_u32_shr(..., NICE_0_LOAD_SHIFT);

will probably generate better code -- I *think* the mul_u64_u32_div()
ends up being inline asm and as such cannot optimize the divide
properly.

