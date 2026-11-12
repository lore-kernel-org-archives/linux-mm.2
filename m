Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C5F606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YMp28IOO
Received: by kanga.kvack.org (Postfix)
	id B5F4C6B00EF; Wed, 11 Nov 2026 22:15:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B107A6B05B0; Wed, 11 Nov 2026 22:15:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26696B05B1; Wed, 11 Nov 2026 22:15:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5536B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:15:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC6D51404AA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:15:12 +0000 (UTC)
X-FDA: 85425000864.29.205B4AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 121FB40006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:15:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMp28IOO;
	spf=pass (imf04.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794453311;
	b=pTBHmyg9peSZfUstAe9ehN3WbyCL9xxZ3xYp1UCINV0PR+VoOZ8mmFzp0DefJMZlcWEebv
	OmxCKB+qgOxa5Gc7GDMsryWfjPPY5yAscbKCBjGw0T7CuzB2IxD/3uPwyRqc+T2UlFSQbN
	OwTGlYAiQbI8vq8rY6wBtJMLboyFAE0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMp28IOO;
	spf=pass (imf04.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794453311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KukHHa4IpQLPx0nLghzyKli6Eignxu46dayWT5IB5Os=;
	b=2d/C2q2wJGwanOvpMN0K1KWPfHi/Qcnw2EQC3ZOdMksiM6nd9+KQ0CzcFamLQ4gu719M7o
	SZ3Bv8GL2rLJ+hQxVy9YJUmf6p2bo/qg+wg2bKY/lpvn08qpG/wGdwWhwDAjzUil3/fugL
	3DkB0ZZ7FXJZP31x2s5uVpycDQ4duBE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FB57633C0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2A41F00A05
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794453309;
	bh=KukHHa4IpQLPx0nLghzyKli6Eignxu46dayWT5IB5Os=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YMp28IOOkOpmgpjEGggQsJTj/xunkcm3xcqHrjlryVSThkdTDXotcTu4FfFa0ax2p
	 F7troXbepBoldAXvDiVsdENhcjwbvVLP1lFJG5X3PwIdszLGdViBjHc7rJrIDDi2Iy
	 90RJbnF+BfNiQSov7MpdqrAIjdtLCOy+89DAY5wx008BcDFOlCqJE1GtekWIf6th7U
	 DdRMijID71R8bUcFNNrKPfeoyeUKL4WrQ5q6MzpZCL8xTxsONCvCMTGfVB/k+ExP8T
	 sGKNeOHOVuzVAhTbh5wg+ppMUWE2fOo06qwUZTv5OnM6uMcemXdoSp1xnNP1DVRcXK
	 Hwcb75x42hVuQ==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso561178366b.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:15:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHI+PfMiuTLoX2iud6gZAizvTNKgKmXKh6Hy4NqONDdJ5G8KX0DQ4lEANKsepiMrRd7dd3byB7Zfg==@kvack.org
X-Gm-Message-State: APuU4Z/AsPfzUO0ZZXJPWhEXe9yYSbx13ZqdJa/gKXqVxnB/5bre3q+3
	N2PCVNRZY5tgpocQ+avjs+OSySNF/l0zTuoILm4HUhiC8LFjOVzqZ32/UDK8DBSfmZ2VTd+qnPD
	cyuTxRBeJkf+BrgdX2hDC+lOZBMu9Ckw=
X-Received: by 2002:a17:907:2d8f:b0:c50:5e10:71ae with SMTP id
 a640c23a62f3a-c5066afce46mr377456166b.17.1794453308567; Wed, 11 Nov 2026
 19:15:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111092421.3771992-1-chenhuacai@loongson.cn> <20261111170600.GS1779021@noisy.programming.kicks-ass.net>
In-Reply-To: <20261111170600.GS1779021@noisy.programming.kicks-ass.net>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 12 Nov 2026 11:14:57 +0800
X-Gmail-Original-Message-ID: <CAAhV-H6SYOjOw+owmStK7sr-HOiADC1zZ4Cii5hv1q+qYAUETg@mail.gmail.com>
X-Gm-Features: AclHuK_e17qcvjrZPS0KZhv5Xdz0uZ2nPZtp3g7am9FbsyZNwEyKWIbkfxX2baU
Message-ID: <CAAhV-H6SYOjOw+owmStK7sr-HOiADC1zZ4Cii5hv1q+qYAUETg@mail.gmail.com>
Subject: Re: [PATCH] lib/smp_processor_id: Don't warn if there is only one CPU
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Andrew Morton <akpm@linux-foundation.org>, 
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Tiezhu Yang <yangtiezhu@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yo8k1sta6uzxxofp8e43fwh86f4f8mp7
X-Rspamd-Queue-Id: 121FB40006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794453310-430142
X-HE-Meta: U2FsdGVkX19s2UZI2IvptHa5/XYKiVWGc7PxvLF4I3MZwq0YLHJV7PwHNUkKAK/VXxPXVkpBVj8+Z62FoNQbbo+whsTI+cD2t9wg3lrsLCo17A/9BHApPGX3gU0CdOxA7Anldytnbs1Vnqm+XwKUx0Tvd8ycyljdoqTrtfZd3TWhWTlWXBne+Pytz3LfzqYkljodn5IRPLc0PbuoCPiiChi9SX3tydovtZlK1UICgcCgrJWXmuXDWRfiSAh4xPJ3no265PSFUtloYyyAutxoUgoZxIZRlTG7WCFz83L58zQ7Vc5BzUfQs030BcaVE5y13N1pKNjAtsKSGKddss5V5O8enVfEF/gYy47yK3XN+rQfsXIty+ZaeD2W+QeXKlWW9nZ7Sq5BsDzDN1VRbdRGHY6KnWggaQKe4yYTLFXidhil/BtaiXwivqIm4+pXRdMXL798qDKkNEPhwI2QOwIIH9+l5e3XZ8pcsfS0EN93K3cMlYANvo9UTHFsWUl4K+s/iZu7H+KgqKYlfNhTACZ2NpAH+wNX81XS1+1naNsXpGUGFo1ZX4XKlREsxKgUupIgqb5th+WXzyMsQSzz2W0aj9Yv3Sfa1ZoHh9xNFWBvLrgwkH4dutZMx3A4KUUT/ZN4xjoN9bWGl2uj3XXYsXiU1aVaUr3zE9HFPhnKxhLOMxwtjNceB59Nk1VrQUB0u145c64tW4GbEMFFKkWR7OSQWAeu3Cm+DwJCOOLMgw1fTEoR1UEaQZqZaPclfYQAC/da7My+0+vnC4fKE/KX0h+Y/6UxrAi2ro+iOH3QSgq7FB2bWTWbEBgEBGTVB7yEeY1K+ZsocfTsrckjmnn65DZ6jvRfIc8CiovNjYnPOCYhadjpI2WvGWi04TEIOug6i455gi8b2F+nhWfgdoWHOA6d/fcFXyiUbljHqaMi50AxZAU/3Ef58WzwGTzPxZXK+NKt6GjQCUZJf5FpatbideZ
 IBoPlGi4
 lDG8D7B3C89Chqc9BCOM2InCAXNQE/UFhC2KTYbpQ8KjBE8H6NGb0SIe738y5OElThAZtCd00CaluA52uEXAkHFzksExcPlCvvqHblKzF2WAHOeuhdO8q/2rLRfoZg879yRzhfcbpQlYuff0nEwaoEnjy/fnLLIKJe3I//dFon2NheO3EUztJBIpKem0hKU3C3Qvtp+LCD1t9fjMJX3EGqC/PhBSMzV8AUomCDsztjQDUu+wXDyjYhy+0/N1PJbAfIGJd7N/rSMPohKvqGSs+lnTqlALMTaQSeQA4mIxrwYcmJS9yGD+qCyABBeUKdcgJE1NuFLkwgtBQbAxjy1UjiQdvU6q24MH+ZEXo3aq7eWdhEL691Oh3afNJ3Q2yaJ1qZDDm/AIenmTo1y4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, Peter,

On Thu, Nov 12, 2026 at 1:06=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Wed, Nov 11, 2026 at 05:24:21PM +0800, Huacai Chen wrote:
> > When CONFIG_DEBUG_PREEMPT is enabled on a Non-SMP (single-core) kernel,
> > calls to smp_processor_id() in preemptible contexts trigger some false
> > positive "BUG: using smp_processor_id() in preemptible" warnings, which
> > are harmless noise because the process always executes on CPU 0 and CPU
> > migration is impossible.
>
> The check is still valid, you don't want to have any code that uses
> smp_processor_id() outside of preempt_disable(). Such code would be
> invalid on SMP, even when ran on UP.
Thank you for your reply.

At first I also think that smp_processor_id() should always be called
in preempt disabled context, but after investigation, I found:

There are 5 existing skip conditions.

1. if (likely(preempt_count()))
2. if (irqs_disabled())
3. if (is_percpu_thread())
4. if (current->migration_disabled)
5. if (system_state < SYSTEM_SCHEDULING)

Condition 1 and 2 is to make sure smp_processor_id() is called in
preempt disabled context, but Condition 3, 4 and 5 is not.

Condition 5 can make sure no context switching since the scheduler
hasn't begun to work, but Condition 3 and 4 can not.

In other words, Condition 3 and 4 can only make sure the current
execution will not be migrated to another CPU, and I think my new
condition is exactly the same.

>
> All code must be SMP ready.
This is why I use "if (nr_cpu_ids =3D=3D 1)" rather than "if
(!IS_ENABLED(CONFIG_SMP))".

>
> Aside from that, nr_cpu_ids is the wrong number to check.
Correct me if I'm wrong, do you mean checking num_online_cpus()?


Huacai

