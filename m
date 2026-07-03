Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 127E2C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 21:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015A76B00B7; Fri,  3 Jul 2026 17:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08E36B00B8; Fri,  3 Jul 2026 17:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF71D6B00B9; Fri,  3 Jul 2026 17:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B45CB6B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:02:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43E1D1C1CB8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:02:34 +0000 (UTC)
X-FDA: 84948689028.20.2C0E6B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE8C04000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 21:02:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxG157Of;
	spf=pass (imf01.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783112552;
	b=36KaYcoWNOX1qLjgpA85sOflI1kGiU916k2RWkGUfG/hMK3faW5njN67FbYiVVc39JLJus
	ywWZu/NMPCHphxLQH8eYmLASdn1iP2Nm7LMDGfx1rwDuN7p55hKolRIyqKd65ZoeIxfMFu
	xjUWTY0PiwbcSOyJKFzT3WzTx5qsmk0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783112552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kxy/nHrA/YPl3oQA1s1YUJFp/UiroxEca2CIOkGyN+4=;
	b=1DBGJ67Oe7p69xCH/5WTDuQv5LePX26KhEfa5PoAZLXiSTRbgQwk87iJ3l2hZY0DAUA6o6
	UlC58sB6sc/gCRHww+aHNdknVmRHSmwOtN2L38jpTdH8DeKYgIOPa0GKiEcuVEMR/JmmPJ
	S3C0J3xDxR5AvWxKLynL48hklQ8lKGI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxG157Of;
	spf=pass (imf01.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FED1418BC;
	Fri,  3 Jul 2026 21:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E9A1F000E9;
	Fri,  3 Jul 2026 21:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783112551;
	bh=Kxy/nHrA/YPl3oQA1s1YUJFp/UiroxEca2CIOkGyN+4=;
	h=From:To:Subject:In-Reply-To:References:Date;
	b=QxG157Of+hFM+LFQ7BvmTo4/2xtWWbjNv088utFW0+XMcajzFhzht7bVw+dS/5+ve
	 z13t+B9J2d3OEuDdefTJaMFUi/E8wR9R4/Gm8FumDxvtidM05Sl+GmAf2UF3yFReVv
	 mqr0Uto/z7L5q4vJJuYvvkeRGjFR+vVDM1RsyJd1bHmq1AjopoNWuiUQKDN+DOiMd5
	 UKtcLljh6CArSl8nMs/YrmJNWbVz3y0ScJwJjIVzXckAgbDblGcbOkJB3HG6JTvDY7
	 ze5vM6LRITBpSbB+6er3+uBCHXU5LgTycppqNNQ6CQSegRpkLv+Lmifi7rpWsij9EC
	 tLM3kGlume1GQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
 eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, jolsa@kernel.org, bjorn@kernel.org,
 pulehui@huawei.com, puranjay@kernel.org, thuth@redhat.com,
 ajones@ventanamicro.com, ben.dooks@codethink.co.uk,
 rkrcmar@ventanamicro.com, cuiyunhui@bytedance.com,
 samuel.holland@sifive.com, zong.li@sifive.com, conor.dooley@microchip.com,
 debug@rivosinc.com, seanwascoding@gmail.com, andybnac@gmail.com,
 menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
 wangruikang@iscas.ac.cn, atishp@rivosinc.com, apatel@ventanamicro.com,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org,
 nick.desaulniers+lkml@gmail.com, morbo@google.com, justinstitt@google.com,
 qingfang.deng@siflower.com.cn, linux-arch@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH v8 3/3] riscv: store percpu offset into thread_info
In-Reply-To: <20260703122832.15984-4-cuiyunhui@bytedance.com>
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
 <20260703122832.15984-4-cuiyunhui@bytedance.com>
Date: Fri, 03 Jul 2026 23:02:28 +0200
Message-ID: <87bjcnlrbv.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE8C04000B
X-Stat-Signature: jbd7zmtbyush194yuqb87cyq448mtrfy
X-Rspam-User: 
X-HE-Tag: 1783112552-625903
X-HE-Meta: U2FsdGVkX18WCpDEqwUSsEQDA+NzF2gx2wj73BR0MWOkIQi+yrsUG9wVTrT53DNc5urCa5ZRku2cCrLiCVxuS2D6x2BrXw3tyKU1B0Qb7bx/JCJWqXxF+jEP0ncldhFsGTE+ffN6myipx00X5n3LA+sHdRW70bmnChxSyZIFsGxQFy+4KthMDKQutOQGbCPFl6UZMLYXyXHxww90oUspnYLg/WcTpNxmmx76hXaRpVQDXVyyEeWOuD/8ue91ZvRm4xh0qYegug3sHPymY8ht2fJIadQtgKK7zknETnyKTH7lIGu1uPkRVsvTfzcHM+4Q35/dIrGcU5V3nhRPrRMsKJZTN084Xto0mBt7LHQT4spJXqiF7BPZujnDz8j6y6Z7pHKIl/8D8yODw+Jw3L/Zo+MnUPhIoWSbOQRrvtRF/SOIoE8IgoRL7HdOMkVKo107Qhw8IsdDNyMmJcxGjUrQ5u/A+cw5KLEja38YG3s721nCnSYqvryewVIGcXD2fw+ofxSHmZYXMcZSPZ9YWbxypLlsqbQdRF1YIuHHk97YVC7fx9YhnP7x7lq+1j7b8DErNDCHK6e1IRFI9M58S4BAtcd+wIAoPA0q/jSCY9m8HhcLw4UhScEA1A8xVmh1X4QBF+0Ogz0BeRuAuo2URSrDNRNR4sxg2D2KrUVaYDBGbwjlyHdrL/+B+H5YXUhmDCLThgX1Ys7tXET686npad9zxzxGfjuj0CpshNgIHfPKkAkgFvv1HCgURuJlmWXTynBK9bPmuAXFzAgVUPer6sceL+2/+StSFk4dDzwbwRVFPKESRCXG96ZJy9TeOYl02K0qlotSoLpY0AO5zo2l2+J2iGBqncDZAzJA4oJw04ghoGuFF45iWxgsS05EHFnMim+B+XYonGzTU7/VMeQ8bZs7CybYjVJUMR72C8SCw4XtNMmJuc3eUWJxJUNlJlcvN6WUcTKGYAqEob+gWOS9RxO
 MOYV4QpB
 h4/HGKprsg0XYu1uQhuQYq/ZBouklhCs+J1ls494Hfac3gFBczitTNhAMepRbUopPVE9jKNr0fIP3KfC0DIec7WCCt7Dgsc74J/+o22UWWMFOOPzrcHz1StgiwjZPC/PZU20DhW0t3u5UIHglX+12GkJKCPXaEJl5ouwoXqrv4tSL4p9dB6VbVbEY3f6eob8xMWfwTZpOB6ljJ8RSxhLrBmpQ0tMMYNmV20z7unFqGmIRiPBDE2oiBj6PMVRM2yWgWrsFEV51x9Wf5jQMCYmQ+GhyGC0yYue8J3RmZT4p56v/sVkpLhulq70gYWXNEA4Ne3CMbRtEzQ+ETBOWWwMG+td5f/zEK2FyQAOHFeyfm3LmXvLIhfm8Bnpd564SOgiyOFbD/22KLXbiNmvtL7Hj5R2Wsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03 2026 at 20:28, Yunhui Cui wrote:
> +
>  extern struct task_struct *__switch_to(struct task_struct *,
>  				       struct task_struct *);
>  
> @@ -122,6 +129,7 @@ do {							\
>  	if (switch_to_should_flush_icache(__next))	\
>  		local_flush_icache_all();		\
>  	__switch_to_envcfg(__next);			\
> +	__switch_to_pcpu_offset(__next);		\

Why do you want to go through the indirection of current:

> +static inline void __switch_to_pcpu_offset(struct task_struct *next)
> +{
> +#ifdef CONFIG_SMP
> +	next->thread_info.pcpu_offset = __my_cpu_offset;
> +#endif
> +}

instead of using __prev->.....offset, which is right there available?


