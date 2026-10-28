Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C7D606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zcmrdaow
Received: by kanga.kvack.org (Postfix)
	id 36B706B05B5; Wed, 28 Oct 2026 12:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3438B6B05B6; Wed, 28 Oct 2026 12:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232696B05B7; Wed, 28 Oct 2026 12:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0368C6B05B5
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:35:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 640C0160183
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:35:14 +0000 (UTC)
X-FDA: 85372584948.21.93DCD65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B386B40008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:35:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zcmrdaow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793205312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsxY8Y0pmbaFpLJ9PntFjRMT7awe6GsgDxXoVZC163Q=;
	b=y4v6l7arcI392RAJ7Lj7TYuDjHa+KjqrynMkfv3XCHmZY5MKJ8SpBmwcQVv7XNLMp+KUeK
	/uQ1wRZpudHSUPyc64pwlZ9HQ7DoJKCfkQmKPtgb+5TsxBkYeHPsGPjA7X4jTg3N+ENVuF
	xCI4c09WwVG2zGnyZpfUpqJ2DDw1mnU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zcmrdaow;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793205312;
	b=V71PkwoAvoN0LoDPkzX5HMuisc+B8uJbwO+uEZ4iSpTW4KNV7dRzQvgcNVY7RF24Q08JWL
	kF0sYude+mP3Xr80k+wuIhVUipBU5og4UuWAWS5rLh/l9hea4zEci7muClNRWM9e+651uK
	iYamOUaobaCA34zNSPbA1ElT3qYfb4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03A7A43B04;
	Wed, 28 Oct 2026 16:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71901F031E0;
	Wed, 28 Oct 2026 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793205311;
	bh=LsxY8Y0pmbaFpLJ9PntFjRMT7awe6GsgDxXoVZC163Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZcmrdaowSfrUee9ovwE8wL1mbXPhKkGcHAJ/sNA6Q+l9Okfg0Pk4rSfrPV/KS+OM4
	 iq3fJYxFmFMEPtlhwZ8oKXdO6JWDOGj1tWgs/5vksMcQsxjBSri2Ko6jZ1c8AZ1pbw
	 hYaofSf9KnPRREbyW99xWOa8oXMPog7YkskU6bN4m5tUvmQWw2z1DlzaE0JGLAL1vH
	 83EM3VlCZUgKFA8cLPfGghSF1XrUzF2KqKFisW2stpfX3DU2XGB1HzqK1Vd1MWzzYu
	 +H4cAztvEk5BFBrJOMDsUQ24cBprZ/AXvBupnESAhaDK1IpTKUNfYwQrn1Qrbaf2WS
	 75wO0EJ2FVteg==
Message-ID: <sashiko-outbox-188168@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 2/2] x86/kcov: allow instrumenting noisy objects for
 early boot coverage
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yunseong Kim" <yunseong.kim@est.tech>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "James Morris" <jmorris@namei.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Alexander
 Potapenko" <glider@google.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>, "Will
 Deacon" <will@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Waiman Long" <longman@redhat.com>, "Luis
 Chamberlain" <mcgrof@kernel.org>, "Petr Pavlu" <petr.pavlu@suse.com>, "Daniel
 Gomez" <da.gomez@kernel.org>, "Sami Tolvanen" <samitolvanen@google.com>, "Aaron
 Tomlin" <atomlin@atomlin.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Frederic
 Weisbecker" <frederic@kernel.org>, "Neeraj Upadhyay" <neeraj.upadhyay@kernel.org>, "Joel
 Fernandes" <joelagnelf@nvidia.com>, "Josh Triplett" <josh@joshtriplett.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, "Lai Jiangshan" <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Nathan
 Chancellor" <nathan@kernel.org>, "Nicolas Schier" <nsc@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H.
 Peter Anvin" <hpa@zytor.com>
Cc: kasan-dev@googlegroups.com, linux-modules@vger.kernel.org, linux-mm@kvack.org, linux-kbuild@vger.kernel.org
In-Reply-To: <20261027-early-kcov-v1-2-6f2f053255ad@est.tech>
References: <20261027-early-kcov-v1-0-6f2f053255ad@est.tech>
 <20261027-early-kcov-v1-2-6f2f053255ad@est.tech>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 16:35:09 +0000
X-Rspamd-Queue-Id: B386B40008
X-Stat-Signature: 5nu63yxnow4zcxadais8ok88n5jyozpt
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793205312-993894
X-HE-Meta: U2FsdGVkX1/eNd29RkqcTusgqqOyZvEB5VI8T4RbqMGuK/smkBEoTHLBMxY+H+SmDgImtvVoi2juOP3UkmcYIrEZa16ubN0hS9QKzceH5qgMQkaq3ioCTjvgu2IkuZLhWj1U2IB5za1Jj3vssZu1NwLU09XeumQeEg9xQo+CjtqBiFzotjYzE9rDknsAVXKzhD64lyIcJn9NWp1XFgTDiJ+1Wr28zhiEsWp3nXc/2vJ09iMotj7919pRVxxShabL+6yF6I2isU7avU5HRuXK37DqkfD5AEjcnYEJ/C8nYDRZMSLsfu1tlhxXqtxGbW5SwWGJ/yqZiLUo+x2wYMg75sdgLbKWC7eczr4bpkaxjNQNISgztMzL9qNDGpBOjh57clvj/OM15I3ldwUBMbJTcwqQZlq1XK8labTjKtb+bq2jU5b8HAHlbrgW1O+4kXlnBY5Cii6naG75N/Al3ZpbDOinoZriJoPqI0anp38hsBG8wuVGXSqvPjc19776LDns8iXcVWLZPkFCZJNX52r1TpfBWg+nXuiwHei1pz+zUgFTNKpHbrU7rYMhObDQkCqqY51+67CUxvFdvNX6J8wtWkBOC2H08gC+ytJddUu/5bpRw9g9h+tKOjGEgNKjZH43GjV1YnONoBF+cniverGl9iJ2ywfZRk6L+rx62zPhAP9I4bdaxLK2yow3D/1v8VO/+hOWkR1PT46E7MFPzyjXfBK6XiCUQ+y4z5yz9tahW2LJVf3ygi7oYaztOCiwH/DmC3a5TJg7ZqO9FWW7UCRakisb9nqGsrzGsHGZtTTtBUpPUj5GKgsz8Ow1x+Mbx1oQjfsX3Si6CW/mNGwvQlnH1L/ZFDPoz9GVjBPN1QNqsKcZMg9fFTqvAganwfAX7wkjYYVTuPutkghhayyfOVBmJU3+liYLhmeG69s6iniUgHJPd+IC/ftwbGXS7FeTdYUen6DLNH5o2Bqi8FZgBTp
 uQn9eaq8
 wJ1qC1kF3tLrsFxok6FnItRFHH0tXyj39SR2J17TyIp/XuKBLjUOOda/zywWKjp3tkUTPHB7iU4lDHQDc7bBpm1tQISd/QPeTNT5+6EpXZBphC89crHrZN05hirecBkjeG6CoOPg1lz5EiLuEKXWWG2cGoKbjv257n30eabTKwuboRzE8a6r41kvw+2VjtV8kxVKM3uKlzP2zuClPZ1ng32An8iM1ZYZXOdfUssP/Y8dASXjsa3u7nl/jbN6kDIvxKWfr3l419HZjOUPW6cdonu0mBm3HG/diwh89wHuINy7D2AhQYzvHqZX+HYH79QgLJqZZ2Dd4zEPLlOhgOk5yqxsdj2ijoGo0UbyazLB4fN/qiEQ2ubOAuVVzKig/HEMmnnNYh1AjF6XgZnxHMiadF9b4yeqai6Q5DLHGsCIxw1aCOaS8l3vB2HpXipQZEKgiD59qr/lRFO8sxMcFMd3oymyA9haW1QL2sqg5kCFF3p8BwCImIhWWsEGSZVwYi0VH7njq0g9BBDgE6yOt+C860w65K8IceOPJ/On6z7d6iZI5BSE29k/9PVAWP5ehOIMWTNpp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] x86/kcov: instrumenting apic/ crashes selftest() on FRED timer ent=
ry
--

commit c1145245b36a2aa7f3b165ab0f5b126b2c810470
Author: Yunseong Kim <yunseong.kim@est.tech>

x86/kcov: allow instrumenting noisy objects for early boot coverage

This commit switches several x86 Makefile exclusions from hardcoded n to
$(kcov-noisy) so that CONFIG_KCOV_INSTRUMENT_NOISY=3Dy can collect early bo=
ot
coverage from arch/x86/kernel/, arch/x86/kernel/apic/, and arch/x86/lib/.

> diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
> index 581db89477f92..146cbd766c924 100644
> --- a/arch/x86/kernel/apic/Makefile
> +++ b/arch/x86/kernel/apic/Makefile
> @@ -5,7 +5,7 @@
> =20
>  # Leads to non-deterministic coverage that is not a function of syscall =
inputs.
>  # In particular, smp_apic_timer_interrupt() is called in random places.
> -KCOV_INSTRUMENT		:=3D n
> +KCOV_INSTRUMENT		:=3D $(kcov-noisy)

[Severity: High]
Does instrumenting arch/x86/kernel/apic/apic.o cause a NULL pointer
dereference during boot when CONFIG_KCOV_INSTRUMENT_NOISY=3Dy and
CONFIG_KCOV_SELFTEST=3Dy on FRED-enabled x86_64 systems?

In arch/x86/kernel/apic/apic.c, DEFINE_IDTENTRY_SYSVEC(sysvec_apic_timer_in=
terrupt)
expands via arch/x86/include/asm/idtentry.h:

    void fred_##func(struct pt_regs *regs)
    {
        instr_##func (regs);
    }

Unlike the IDT entry wrapper sysvec_apic_timer_interrupt(),
fred_sysvec_apic_timer_interrupt() is not marked noinstr or
__no_sanitize_coverage. When apic.o is instrumented with KCOV,
fred_sysvec_apic_timer_interrupt() and the inlined
instr_sysvec_apic_timer_interrupt() -> run_sysvec_on_irqstack_cond() ->
call_on_irqstack_cond() call into __sanitizer_cov_trace_pc() before
irq_enter_rcu() adds HARDIRQ_OFFSET to preempt_count (and again after
irq_exit_rcu() removes HARDIRQ_OFFSET).

During boot, after rest_init() -> early_kcov_stop() clears
init_task.kcov_area to NULL, device_initcall(kcov_init) invokes selftest()
in kernel/kcov.c:

    start =3D jiffies;
    WRITE_ONCE(current->kcov_mode, KCOV_MODE_TRACE_PC);
    while ((jiffies - start) * MSEC_PER_SEC / HZ < 300)
        ;
    WRITE_ONCE(current->kcov_mode, 0);

While selftest() spins waiting for timer interrupts to advance jiffies with
current->kcov_area =3D=3D NULL, the first LAPIC timer interrupt under FRED
enters fred_sysvec_apic_timer_interrupt() while in_task() in
check_kcov_mode() is still true, reaching __sanitizer_cov_trace_pc() in
kernel/kcov.c:

    area =3D t->kcov_area;
    /* The first 64-bit word is the number of subsequent PCs. */
    pos =3D READ_ONCE(area[0]) + 1;

and dereferencing NULL.

In addition, during normal task KCOV tracing on FRED systems, if a LAPIC
timer interrupt preempts a traced task inside __sanitizer_cov_trace_pc() or
write_comp_data() between reading area[0] and writing back the updated
count, can the nested KCOV calls in fred_sysvec_apic_timer_interrupt() have
their area[0] updates overwritten when the interrupted context resumes and
stores its stale index?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-early-kcov=
-v1-0-6f2f053255ad@est.tech?part=3D2

