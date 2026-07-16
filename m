Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA530C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 17:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB2E6B0109; Thu, 16 Jul 2026 13:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91FB6B010B; Thu, 16 Jul 2026 13:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D02F6B010E; Thu, 16 Jul 2026 13:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76CA36B0109
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:21:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D155C026D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:21:35 +0000 (UTC)
X-FDA: 84995306550.16.C564D6A
Received: from latitanza.investici.org (latitanza.investici.org [185.218.207.228])
	by imf13.hostedemail.com (Postfix) with ESMTP id EDA4E20005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 17:21:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b="DIe/BNk9";
	spf=pass (imf13.hostedemail.com: domain of include@grrlz.net designates 185.218.207.228 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784222493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ApDe3kfU1jAQMqDNaJGKXEBL8IhnJAtrM+hYn5C+hVY=;
	b=v5T2NVDnrTTw8Nfry4irHEZPzMMkwrtpGlVYRLscLjZnA2DpO50lWbloCRfHp1GX/LP0+B
	bbirvhroxc8Q539gjN8hbAPQhOtv5ipvU1ymUpWNilr0gJkCY7MYqHfFZTnsVL9MgW9L0O
	4eW9qQ6uVPWHIPXplxzpbi2CbkXp4k8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b="DIe/BNk9";
	spf=pass (imf13.hostedemail.com: domain of include@grrlz.net designates 185.218.207.228 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784222493;
	b=6SG2dN2POaH4Z6SnPgrAJNR7aBo4KTEENh/E3nZWeuFEBhFLO9pECQ85MdNvDL4bLXt00R
	YpEhq1Ca3mEkFP7FbzoXYMcftvb6ICEwZgPyRN0oSpjGUpP5FJxYvtNEaxX3XZEKmijrcb
	3e4Wu516tAOC3j+MA3/LyQn9VGPePA4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1784222490;
	bh=ApDe3kfU1jAQMqDNaJGKXEBL8IhnJAtrM+hYn5C+hVY=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=DIe/BNk99fYaSF06zppIGPO1lpg9YTVb3vRUd3MWMtg46xEYSTpijwUm4+Efs+LWx
	 yFPU6LgasmMFobdnEvTsdPLftiYa+FgI0C1c+GqiqqrFL/scBOPKn31z3J+7GXe+ux
	 7+BDquAqqA/gMoJFbqW9jYvaisPeqaPQtrJgrGhk=
Received: from mx3.investici.org (unknown [127.0.0.1])
	by latitanza.investici.org (Postfix) with ESMTP id 4h1KZy4hrrzGpPF;
	Thu, 16 Jul 2026 17:21:30 +0000 (UTC)
Received: by mx3.investici.org (Postfix) id 4h1KZy22FLzGpNk;
	Thu, 16 Jul 2026 17:21:30 +0000 (UTC)
Date: Thu, 16 Jul 2026 18:21:30 +0100
From: Bradley Morgan <include@grrlz.net>
To: kmehltretter@gmail.com
CC: akpm@linux-foundation.org, kees@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mingo@redhat.com, peterz@infradead.org,
 vbabka@kernel.org
Subject: Re: [PATCH] fork: Honor task_struct's declared alignment
In-Reply-To: <20260710123957.31774-1-kmehltretter@gmail.com>
Message-ID: <5AA3EBDE-29ED-4E04-8D8E-43DEC9FD5988@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDA4E20005
X-Stat-Signature: 9oo5yzgrmw6fmudz81r8u5poi96qc6h4
X-HE-Tag: 1784222492-730353
X-HE-Meta: U2FsdGVkX1+ASrAf9whVqhP7wjDy9Fw4LHsR6tWXHwMpXAV8P1cnLUY5e45lB18U/yyG/eHkV/E8FODL+D0EXm9eU9OERD0adl7UScBOlnVo1M6JiNwvnVqeR+wnHrnCjItYWY1rj6N1boInYKwN3UT1SPxzQwbS9aibVRP1mq5/nG50QpX9YVdZNYffxziyjTjsESTUI0N41iumO8ywNJxiX2ql+h6JGuNobrfZbiIpQ9ToY1F6XJxjSXTaM/VDcyff4O/EBU8D5SbW4zjXMHz+Nvx1DsEFK5UbaFghJbLbBPmC8eKF2h48rc/wrmCtAXTo/ENOGLdknFA0oCquOcawoKntVyoVdicYerMzF2oybomFG5TYQeFFaQJV5uzrw2D+dONig+mkI/zULKNjQup4PmlUJuCAT9slGMwYxM8wIqAV5ivUU8zt7hyypngeKwM5S94DP48yeSkVxNo5qvmBi4rRr4EHm5hsKkZe8/BEVAuMJ9JhvOTtgQi5pQAU2nVvhxwYD0M8KWMfAH5jLSlWeDFUE0If4T3T5d8xhTdusXNanNeqDfodffDcl+sHRHUgM8IU6u0yMVSoN+M8U+9p7PhUvkAnphPmtA1uU8HvOmhfZ+Z21X7Ekp82yji3N+D5JC95Yb3TkOj9NeShXQp6j1ZpnXTng7gIwypT/5LWYUypkSo8l5yyurKgXm0fvLwtaKO+AncwynW5S2kjx0BTirq0LLz5QRHNzz1Dk86LNrPQad/h0LyI6vLXV5PHP7QJZVQ9onJc+K4qhTqspxW7nxPmp9I6j+ada23PnHX1OhSleigyS2EW057WV+6DhxO2+jeg2EvuXBEBonk2v1VgzFVx33LDHdgzRt5PTIbKhjboPuOdhYdLapaRnzoea1ijiKWY4mGVsXRbYZV/aJY/2btX/JXUAInXb8sy692l1y7dFQwcqR0nOgWhiueWiy9rNVAFBvOphK6bdgC
 Ls8IffNS
 U/rdlXTaCUSIsMJxagnAp+cWVrVJ8a872JvbMjectWlsYtiz1yIdR+A0d/xKpdqfVMOw8+dS/qz7uUmMFCkSde3zBH9ISDABt2seu5zbrQWHU71pRSccmxCj2a++CbJGmgWHoIN22O7NFmkHW8fi9mI8sXQZVuLZB1xSjp9TKpg67Yx+XEVnnFtwjxszE5fluf6HNGzUxaLF4oK/6AmdzihTBESfMtu7ZVeK6BpEAWP+lBJOGonz3xxxY3Ce8A8hj9d+9iTMoTfTE1Mbt91netR61RdlOpJhXCFJB74P/N7vmck3b0ujqse1uHe54Nu2qtKIjFK7450KTK20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Since commit cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant
> size"), struct task_struct is declared __attribute__((aligned(64))) on
> all architectures.
>
> But fork_init() still sets the task_struct slab cache's alignment to
>
> 	align = max(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN)
>
> which is smaller than 64 on architectures whose cache lines are below
> 64 bytes: e.g. 32 on ARMv5.
>
> In practice plain SLUB happens to hand out 64-byte-aligned objects
> anyway. With CONFIG_SLUB_DEBUG_ON the red-zone padding shifts objects
> to the requested alignment.
>
> With CONFIG_UBSAN_ALIGNMENT=y a boot on QEMU versatilepb (ARM926EJ-S,
> v7.2-rc2, gcc 13.3) floods the console with reports like:
>
>   UBSAN: misaligned-access in include/linux/sched.h:2087:9
>   member access within misaligned address c295d7e0 for type 'struct task_struct'
>   which requires 64 byte alignment
>   CPU: 0 UID: 0 PID: 15 Comm: pr/ttyAMA-1 Not tainted 7.2.0-rc2 #1 VOLUNTARY
>
> Set the slab alignment to at least the type's declared alignment.
>
> Fixes: cb7ca40a3882 ("x86/fpu: Make task_struct::thread constant size")

Nice!

Please add 

Reviewed-by: Bradley Morgan <include@grrlz.net>

> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  kernel/fork.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f0e2e131a9a5..b85cf1343329 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -857,7 +857,8 @@ void __init fork_init(void)
>  #ifndef ARCH_MIN_TASKALIGN
>  #define ARCH_MIN_TASKALIGN	0
>  #endif
> -	int align = max_t(int, L1_CACHE_BYTES, ARCH_MIN_TASKALIGN);
> +	int align = max3(L1_CACHE_BYTES, ARCH_MIN_TASKALIGN,
> +			 __alignof__(struct task_struct));
>  	unsigned long useroffset, usersize;
>  
>  	/* create a slab on which task_structs can be allocated */
> -- 
> 2.39.5 (Apple Git-154)

Thanks!

