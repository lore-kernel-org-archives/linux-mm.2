Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A5D8C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 09:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761636B0095; Sat, 22 Aug 2026 05:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7123D6B009B; Sat, 22 Aug 2026 05:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601666B009D; Sat, 22 Aug 2026 05:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCE286B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 05:37:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4582E120310
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:37:11 +0000 (UTC)
X-FDA: 85128401862.19.9064CB3
Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 00E9440008
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:37:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=AW2TRut3;
	dmarc=pass (policy=reject) header.from=grrlz.net;
	spf=pass (imf07.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787391429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mO/P0+l2gNGVNNapyT1SVGjulwrUYq3eEwcsgYPE6uo=;
	b=fwBYAKEWUPTf9iooF3gi8VoqtMlseEh0895WQb0hUlPpGvnoIpA1LnUTGSCA8pyMQ1nKnJ
	2Xre1/R/xnCIhXr6oDxqm8ssbP9pxs9019U3PePYv6g5O1tfS+Ef18NyT80ln3njFqE+Ep
	t/ZVMMw0+uHW/7C8a2XByZN4KPSVoSw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=AW2TRut3;
	dmarc=pass (policy=reject) header.from=grrlz.net;
	spf=pass (imf07.hostedemail.com: domain of include@grrlz.net designates 198.167.222.108 as permitted sender) smtp.mailfrom=include@grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787391429;
	b=fYmburRFBzo5dKmj4/FgVS2DsqsrkdUi5mrC8k8ynI3ehdrFZzKvAuuLMXaUUC2tzrfut1
	0b2I0d0dHcqmFARQUHKnnnEICdaR0ZALln655a5/o812Ne5/e8qeHFUPuLlIP87wz44lhT
	Aacy3UJlwqra+zH38LgYYPEhmPWOcRo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1787391426;
	bh=mO/P0+l2gNGVNNapyT1SVGjulwrUYq3eEwcsgYPE6uo=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=AW2TRut3MjPGhP0H4hr+lRuB61Lkh13O3+s1p1mKfX+djYut/xe01703gdveSkG8L
	 +VH1EAf77xX14doMOjtAQUUMofJ4K81aKkmdiPUZzu/z8Pu3/urN+V2E/O7i/urqAb
	 fmf+wQWoRKmEtPT1aEsUuEZVDN517k9vct3xOtdc=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4hRsX20G1wz6vZ0;
	Sat, 22 Aug 2026 09:37:06 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4hRsX147xNz4y6W;
	Sat, 22 Aug 2026 09:37:05 +0000 (UTC)
Date: Sat, 22 Aug 2026 10:37:05 +0100
From: Bradley Morgan <include@grrlz.net>
To: =?ISO-8859-1?Q?J=E9r=E9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de
CC: bsegall@google.com, dietmar.eggemann@arm.com, kees@kernel.org,
 kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 rostedt@goodmis.org, vschneid@redhat.com, stable@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_fork=3A_initialize_functi?=
 =?US-ASCII?Q?on_graph_state_before_copy=5Fexec=5Fstate=28=29?=
In-Reply-To: <20260822084927.547141-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260822084927.547141-2-Jeremy.Jean@oss.cyber.gouv.fr>
Message-ID: <00C50F65-0241-49EE-AB30-6B61CC6B0799@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3nedny6469dfurgkjpt3f1en7hpyaoge
X-Rspamd-Queue-Id: 00E9440008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787391428-816748
X-HE-Meta: U2FsdGVkX19TqFZB/EEfyWXwlbkWX45IA134kYV5hX0Q4ObZUcgkPa6FbxZF/f+w2Q85/0EPukqG5gH1/LB/pPAoAZDuXqTxEFPTmUTiFoqz3iTK8SGyrKYc9HI875aFN+SYIlMexM3W8aBs9Py0cpeesd3sd7l61oY6vZQlA+3lhjvYXgLncxS56KMiqSSYXL+f5bJZAi4BAxPke83FeL1vPZ2xJwlg4o078RAV5BeSeGbu4qeypl5vROkYbqqaflpGcbN0W4bQ3knwa3/AiAqxdl39C0pM27RteKJe44CU0Gw8nPZoZ0TQW6JVcxU2XOvrHEKwOV1ksmr7get89hwypbOCUh/u0505SDtCezRDcsJuN71+RASSmDf6JXPPSaVL+1WB/U9UHefuLWTMb/vcmIPrGJ4BD2UI6+etdqtogzOHuVHo21BMt4A+Tau2SddzFHTGcBg1aqvP5S3a78ZYGXBH9LLLQl5MYYZETi/JwxmIxLqPEqh6VvRfDLvgBbTY35paO8XV1PJQ3lAe1zgPWQ1LHycbMnnZOEb9dl0erKyYs3LIAE3cYZ7qrab7kCG4rtiFCO+peTS4y6AdMihXXzeGV5BzyNAu9aCk0JEACFH8C3dWsvhzudqSAPsLNR1XK+4KI5jC3W7lhveDB97ELhlcK2i+fiykwlq6qEy1r5L78le2jeoYDOEPjOm/Ra6PmnAlWR+UjNQmh4qMrYH414yLtDM2MZy5OsDWv5/FGG7Dfz7SFjwXfzfMVKyBJ5oRcogbdEGmgofU+wUH5ji9hWwJcHCPeFVZhwI0tSwEW0b1QOfjDXj1W31K3QVWPIJLFWIaKyAldfLov0O0CdyxvePaZ45aGRTGuAiYNKBwePtAaCJOlQWzKT0wH0xzHxow9t9IakHjIIWrrq7p+hgdWgpHDj/n3G8/OhlfLUka1FyOhMFs2cWJ7D8s4GMu1cIOdTidTcE1ptPFWbh
 ZeccUXKm
 I4vF0eQuNUoE1nWT6tPd24LCDVyVWJyv4gZKd+Es1cx2Vd2HGHN/E4dGOtJ7/pVfbVOleZtkifluDmnMmPhPegecuNIO/vxKJYMcQM8J+z/RIGmj6yn2ZrFIPGKsMEuxzDGmA6Dm06LiF1WNEUWS2fA0KfRA/mjVavTmu2RDQ0P3ImBhFRo+tv1TCiKtnQkk8mXbmkauyAJnXEN0vFgxud5vWqLrW5MiwHL/lDlFUcDqJxqegDuS6/RPHGgyhLT7OMj/uhwIhjdPx+MMEWAja1UiCnblb2dycma8U0lRhtXZCWRB3lAxGNYzFCz+Sl3Z2FbhqMoQy681DvE/qEl8KDAZmW12rAPNK4HhO+WDHVv2RdcbIzduJddX4bO7PltAWZIJy2uM0n0xROitbTWxUqJxLM/pJ95v+Du0DoRpoqzY/QtIhy3MCRQR9mxkCDzRfvTkmwVLvYlTymPHJepoIs4IhiW8xf9nBrqAG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 August 2026 08:49:27 BST, Jérémy Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>
>KASAN reports:
>
>[   22.195899] BUG: KASAN: slab-use-after-free in
>function_graph_enter_regs+0xa76/0xb90
>[   22.200747] Write of size 8 at addr ff110000054dc0a8 by task repro/1

Perfect!

>[   22.278296]  __kasan_slab_free+0x43/0x70
>[   22.280157]  kmem_cache_free+0xbf/0x3b0
>[   22.282963]  ? ftrace_stub_direct_tramp+0x10/0x10
>[   22.284001]  free_task+0xa2/0x160
>[   22.285699]  ? ftrace_stub_direct_tramp+0x10/0x10
>[   22.286752]  copy_process+0x2aae/0x7bc0

And the free stack is exactly the mechanism from the changelog,
free_task() under copy_process()'s error path dropping the stack, then
the parent writes into it afterwards. Stable folks will love this.

>diff --git a/kernel/fork.c b/kernel/fork.c
>+ /*
>+  * Must run before the first fallible op, so error paths never
>+  * free the parent's ret_stack.
>+  */
>+ ftrace_graph_init_task(p);

And the comment landed too. Nice!

Reviewed-by: Bradley Morgan <include@grrlz.net>

Thanks!

