Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC199C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 21:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9F56B0095; Sat, 22 Aug 2026 17:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81BF6B009B; Sat, 22 Aug 2026 17:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97D46B009D; Sat, 22 Aug 2026 17:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A838F6B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:45:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3707840216
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:45:17 +0000 (UTC)
X-FDA: 85130236674.18.B79C8CF
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf26.hostedemail.com (Postfix) with ESMTP id B6BB1140004
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:45:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=bR4OGgq0;
	spf=pass (imf26.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787435115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6yB+qzAG/fefKb5xEioOXx7BujJfnt8y4wf/YqoL6s=;
	b=GHMb3MKKfpVMpl1rzm88zPIKBtq63+es7ZkiKZs2opceGtDTs0/UGSN/6QXr50fny859oc
	SFfvjuOt/OifB4O2kNhKPczz1wfDOYU3p9yPELizYbbiAdIi8PS8YXAM+HDurwFwoCd5gN
	Wvb/4U8Xp0g0gFujBrT+mlrszYgUOR0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787435115;
	b=JA53HrH/CkbAXC/Hn0SSvfn/r+IhMUN4QLZilZTcINw28qpG4UxFOlvr3h23c7DOzNIB2C
	ssXnfjyN8BI4YCIDOTdiiFh9woF7fhZsAkk0cPZ4rbdJV6S+K1YQGXSaAW+10bNAU5DNgm
	/wuFa1WBMZ2WhsyDwlY46e2K3j6lnN4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=bR4OGgq0;
	spf=pass (imf26.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=a6yB+qzAG/fefKb5xEioOXx7BujJfnt8y4wf/YqoL6s=; b=bR4OGgq0nlQCiOglFm1QMCpvir
	Q91FI5EgnseTCk4WtNMXB61n8sgDRkGhrQ6EXNI+Mnl4/RMI7IxmkT98VJ8FdCeOsdzu7x1nKFMss
	a8Wj5uG/ayJke4ULp0C4/gi0kdka24/TSeE7sePHbRZu82EjpTPGtB4jhNGyNTVOdWv+FFrnHJJ7s
	7SvWXRVKzomOfSsNQEYjVCPbHc/D1Vtr4MS/P8xegwk6r8O1pkXllTVDwYIjOWvC3NIQonIROq2Qb
	VVz8qYuf3u4PVbgBEL5G2vdSetNXN3LMhH6UiNrIXLjwh5qzzUT5hJv+K+2kXv0YenGbShyGNhDY/
	PkykvK1A==;
Received: from [::1] (port=35504 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.99.5)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1wxtWc-00000002qTp-0EFF;
	Sat, 22 Aug 2026 23:45:12 +0200
MIME-Version: 1.0
Date: Sat, 22 Aug 2026 23:45:12 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Bradley Morgan <include@grrlz.net>, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 mgorman@suse.de, bsegall@google.com, dietmar.eggemann@arm.com,
 kees@kernel.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, vschneid@redhat.com, linux-trace-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v3] fork: initialize function graph state before
 copy_exec_state()
In-Reply-To: <20260822174053.26aa2f56@fedora>
References: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net>
 <20260822170928.1acba2cc@fedora>
 <603183e5d6abcae2229c61b8e266e60c@oss.cyber.gouv.fr>
 <20260822174053.26aa2f56@fedora>
User-Agent: Roundcube Webmail/1.6.18
Message-ID: <795312df1b22220991e828497b56cf3f@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspam-User: 
X-Stat-Signature: cfk9k4jnc7yo9cdqyk4fyc37omfez1np
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B6BB1140004
X-HE-Tag: 1787435114-817813
X-HE-Meta: U2FsdGVkX18pyogFJIvuit8hRYPQ0gkMXwfI6odJm3lV28l1VDO3bqeak6VfJNqpFvwUX+Gr5Rk1P16Ss4y42FyK8aQL0TWZIWiDP1GShjPl+Jz47LKEqoxIAG2UvFPWI9rk2vGavwbE7EnyFOnQX8SynQPs0B6NNqdhExJnna9fjIa9zlUHq1ZEuGfXsNQL7DIQECcHk/nHriRUzrdwSqdcmp8xVsNl8VankoKnxuAIGLjqgVNKw7OOSaWzVeOPTQ6v84BGt4etcP0752d3gebnmCLGxwjPwbnR15RNNlgYiAEiR8ZU+Xt8438MV11Vduog8sVK6BgLh8SQmDeQtPQ8X5pq6+uDCmHSCkmssOCVRrE+sJpLb+11hZYFK9/T8VaLraBH3JC1QRpGPi7MJFNNRBREqaqkOeBGBhapdVQ5QjFp/Ella0cAhjkPGEycyhAiCttqVvvl7sEbSLv1nrDa2QFjdnQPHV7O5lacG1Z+W1THQrgWkJMR7O6+OmGKb3y/jrHtWoDK760x/jQkdPsfAdOalzu3FFPc3mfsQojmxgKSGGX4njH9BQ+zzJClU/eO3R3KGfNeGox+L42W6TFoXcylRf/68yHIkhDOivUn/ZcymaD0rfBiuXO97rkK9SHHAPZft+zYPmLf2xu8O6MwSxoFt4okRBRZyy+Ou0oUjf28NAa/odGkfRVyTVNp2a09ZsyBHOS8ZiVAr1CxFUmAK0+t3bhzBbD4x+jAk52Zm1rsV+LKth/eSTucXZPptaK2Ir6uLmZJAI4zZMrLT3R9OfDrM/ppn+12ykyc04ytEWC2pbQ+xxPiwITgShxtE0OcRdH8TMKidFWkkFVZx6oeIuy1BCW1KPnqmuexl7Ptol4Vd7KcWFaDG9LLG+YcgsvXwCmx+CpVvrjhHdY5tu5gwnVHdEHgj3EuGOkoIF3hG1YdSWlVOJVBaw79QAC75KAypp30hWs1ZZcmUXU
 Un/5kjjh
 jODagZbPZ2UgalGlXAK6OsCMxJ73boyx4yypHAovLJggbd5pwMN6mnr9IF+NrLUxdJ/DXQDIbGGDA+Y5BDDO4DWhTF+KRJsYWzw0GxD6SI5R+s6sDSZuEfmbl7PqnwHB/EoSd8rG3NyeOCyerQjBGV/KbRWyZulf97AjaGKn1DhW7B5VL1DNSwqcV3XUxBN9FKE695RF0HzL3TwgdPE8TPCyorqeCjMCZwyP2k0Cs5yExmUGSgTFpk1GepkuCGFGoodLgKGDuPrrbN+Z7SJUJCtvZNuHgwX6wkBZ9MfV4D5A1zRID62we74O3+BRsORpC7/y5OTCxx/eP8a8CR4wNTiHFvWa4ZLgD0uldc0q9CIxehJ4cQykxCfgWFM8gHZ3KedChSYQkStG9sRMke3W803hBJ65DfWgeweSoBAxJfr5i3KStXGsC6Qn/G/zTVeLMJ76LgExXURaEIFLy1BhtTFJkCCm4wERBNEkT5kLF284ujQEgupny8aW+SiDTvfqONpgHj/Gs58IurUt3oiUrDEBuhvRZkq6Uqjil3rv3tYzZEc3GANjP3Hhfmt/6gb9T0+yrfgzmQlbPulKBhz0p0DGuX71wEUDbyHv+sGfRC5P0It8SY+xdXRu7H1pmUwm6c7z7ZIFU2hszGpNhNoolAxn5NBwaE9vKFjUn/M7TYMFkBmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-22 23:40, Steven Rostedt wrote:
> On Sat, 22 Aug 2026 23:12:35 +0200
> Jérémy Jean <jeremy.jean@oss.cyber.gouv.fr> wrote:
> 
>> Oops, I did not know that, sorry.
>> Do you want me to resend once more, or that's okay?
> 
> No need. It's in patchwork and I'll manually add Bradley's R-B tag and
> start testing it.

Noted, thanks Steve.

Regards,
Jérémy

