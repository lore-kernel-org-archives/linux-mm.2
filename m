Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9ABC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BD86B0096; Thu, 17 Sep 2026 19:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D229A6B0098; Thu, 17 Sep 2026 19:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39296B0099; Thu, 17 Sep 2026 19:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9505B6B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:49:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FFADC04CF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:51 +0000 (UTC)
X-FDA: 85224899382.20.C2378D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B925180004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AO2NOfFW;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789688990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfjdNtrGgXRunj6vrF+8T5hsFHx3zNyHhGMGqUitE6I=;
	b=dcitp7gocdU5xufQ2lf6Q02vTIyY0l2BUZ3rLI+bTxo2wfN2HTWEFy2+R/PPoimFqeFdcl
	JGU6YVwgTIj4SJLVUITSVp0X8WoysjykVmZZEGFQ67rA0c6xcd2mJ83QsjuDoMHa6//vH3
	7vcFfQqDe1YeW1C5ZqBKISd3s8CbRcc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789688990;
	b=FoRiSKbE20+fPN85DWYLAtYwBKAZAUAcWIwRkhKOu+vEkRkyEQL/FK6MruIPQInk+cT61k
	qtx0g0BbXx0QYl1nfFzMy2iW1hnB7S34E6t7XNOZSfgfa7+mfYFiOesAMD8vw7VkmeZ/D1
	Tk0X9w6g1JaUUacAddYH4+mGC/ZgkQw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AO2NOfFW;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD8186020A;
	Thu, 17 Sep 2026 23:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF881F000FF;
	Thu, 17 Sep 2026 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789688988;
	bh=BfjdNtrGgXRunj6vrF+8T5hsFHx3zNyHhGMGqUitE6I=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=AO2NOfFWhVppQdHuyB/73E37hae9lvfQWVqppGolyZuEYLo+ya4Mu6xTwenAQ1JCl
	 Kq5b+Pazf/l/w/nMorJPF+7Y+AlHWTSuQHw/sBKGkc0iHJOPYoXFV4+wRVqRYO5rqK
	 DBB3+b0WLW3O7hTP475ydoJQ+7rYDqeo0W4ftMuYs0DbqQR4EAvMmyRlDcoplTYUk+
	 o8XKYCXZHyfmT/aAyQLmEE8OGoF8801uATu4t3/HQyZ/865OSg5scthJ/45KTOD+GG
	 +1jIR78bPjsSN+L76n2Q5Jf3D6MGy7i4NzRBlS1jy9ZzuVEoATrYWS0BpSK/ZNFoyX
	 w3zwxYqnsQthA==
Content-Type: multipart/mixed; boundary="===============8728234185582942083=="
MIME-Version: 1.0
Message-Id: <218a829788764892856c729b4b4b456b8216275caff7ad88c1010e392ea1217d@mail.kernel.org>
In-Reply-To: <20260916195203.1099646-2-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-2-ihor.solodrai@linux.dev>
Subject: Re: [PATCH v3 1/5] x86/cpu: Factor init_cpu_info() out of identify_cpu()
From: bot+bpf-ci@kernel.org
To: ihor.solodrai@linux.dev,bp@alien8.de,dave.hansen@linux.intel.com,mingo@redhat.com,tglx@kernel.org
Cc: ast@kernel.org,andrii@kernel.org,ryabinin.a.a@gmail.com,akpm@linux-foundation.org,hpa@zytor.com,andreyknvl@gmail.com,linux-kernel@vger.kernel.org,x86@kernel.org,bpf@vger.kernel.org,kasan-dev@googlegroups.com,linux-mm@kvack.org,kernel-team@meta.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 17 Sep 2026 23:49:47 +0000 (UTC)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B925180004
X-Stat-Signature: gqsfopmqsu4u887838bffbae8mg6izrg
X-Rspam-User: 
X-HE-Tag: 1789688989-182214
X-HE-Meta: U2FsdGVkX1+G2IISc4vyL+YJgu2A8bZE/7GsyDE8x9s8sLXpI8yTsw7pB26f/U+SGleC1dKHrIQRZGdaC3fUJ+HESbhJUEfP7fnZEvEWB9iB6kV2jRLMOvUhZpnLBz3mjmaIW4RiW5JWytllwzCXNTtprTBt0tidwk1tlB/30rbUS9mFX/Q5M8m6n65gUmDzNY0dHJgfXAXgj8uO2rMxctB77CAcd8uNuzNuGD4VVGpHtzvPN72VVPTul6DLZcWhw11/CIRh5Tx154eUE5w3gztBU8CmwonStmrVu74Et9T9HNX7K552U4Tir8D2a4kqnz6Rd20M/oqvEQiti+gHO4wHbjtte4AhD18LH1r0N7tNBTjJNYoFAKNyJ+BrzJbctMXsqXqlxJzrakba+myEjmHk1COkSu8lDjwu9GgUWeF6DN0kLIj9xePMJnPV/JANzK9f6w8XwrSKW/qSkN2DS+FLDTI5CWPYWcYIoDJ+f9Kd3Xybcga72Fmo7bZgQUA7XZmn7pgvB0M45LRjFGyltzYWlR6DzY39PONKvLm8Cc44I0yjPJMRZstoPodmBuBbs4Go99/mhVrYfQHVFbo01yZdxieBM9KEvH6RpF7vedOfWMyGWp3kmADwnUvHaI1Mk5aJdRSZkEJDo+fQ7pE2UF1qqX7IECxejsYhve8RUC31kss2Z1mvg28Pkkzl55rRI+xTl0kI+dpEhoOAuLNI1M6gtvBKIzLG2gg3GJC6jjYYLqZvZj71SkygdbrAp8jbTVAFPizU1HfM6OQu+1GNT8qXb1wQaZ9X3xnDH2fbQJVbLxSNcRxrO3YjV0E1qIRyX22sR7w/4GcYL4+XdLVA4G51kYlJKYCnsubKZOFuQCN5lQ2EiqxGTEzza6d+ZoAVbyst8iejUMXqZUOhVW6LUKeV8lEme8NYdrlHcF68QdEhAvWTljHFXgflYxdOZTRxw9N44PufJ5EotasgkAx
 OAJeB7fh
 TLzOB/ZbBrTBdDbNeI/YuOh7vRW6Uc5L9mFj/cloQCOSlUuIJAQFrYqzruaJMSwFuDP5DaI2MzkfnjLs2CjLoWvjAOJEAEotstm4BkJr1bLnEiL8/OGbp0kZK7tU5DH8RJCB7aCCsYr9LHqGfsnvGlpZBmKX4nF3lJHqrLd/xPYWF9mmyQIWd4ARl1J9SO0fHkqVFJI6n/ZwgytjQtlImNYj2x+LRpBzfsEN/wih9Qst5IvaTm5D4FrZJXdcL6+yS5V35aLVwatjQ1G+Ic2uZjBt2Vt3++YsuAcCsteLyjxab/cJzV4+5VTpvibxmDfSvds6zf3PsyWC0dryccO7TX3TJoF8/bRmZmq+1+Au9RGxNqS7mXbatGi9BfNoqA/a2MlFtXpcQTujh7DenSKMwi72Cepiqh1ohYtJgtbbR+fW0qOQ8b6he4Aqx0p5M1kZrziz907uxhGxwpXk/xj2RrTBapxl4lal8UJa+OQWqkWyEQrX11cBmLwXxCdLDqaalvAOO1RV1BwItSF5cWbCSwp7kuq67Qixjy77U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8728234185582942083==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> x86/cpu: Factor init_cpu_info() out of identify_cpu()
>
> identify_cpu() unconditionally resets the struct cpuinfo_x86 fields to
> their default values and clears the capability arrays with memset()
> before rescanning the CPU to fill it in again.
>
> However the boot CPU capabilities have already been scanned by
> early_identify_cpu(), with interrupts disabled.
>
> Introduce init_cpu_info() helper in preparation for letting the
> callers decide whether the reset is needed.
>
> No functional changes.

This isn't a bug, but would it be worth adding a line noting that
c->extended_cpuid_level = 0 also moves here from generic_identify(),
which identify_cpu() is the only caller of? That is the one part of the
move that isn't local to identify_cpu(), so it would make the "No
functional changes" claim easier to confirm.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35285131592
--===============8728234185582942083==--

