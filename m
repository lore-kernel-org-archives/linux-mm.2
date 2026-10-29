Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F26606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bE4E4zbX
Received: by kanga.kvack.org (Postfix)
	id 3CBA46B05B2; Thu, 29 Oct 2026 06:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2636B05B3; Thu, 29 Oct 2026 06:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0236B05B4; Thu, 29 Oct 2026 06:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA0656B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:09:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FB7FC02DC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:09:58 +0000 (UTC)
X-FDA: 85375242876.30.366A40C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9D4768000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:09:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bE4E4zbX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793268596;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BU7pHR/kDuxQISup5gyDHrCYYIiSnqHnQJ9cc+eRVuY=;
	b=6SC8mVLDAsCa5UpL+Ldr7BPRHakIPbMQZCRYngeYfKvA2POT51ckvpPluTwG69TDVrL/fr
	b2CPGJXcbqz432/Zj0HRbiC9WmoJpQ+NRFpgDnmoMsrJuePLHvZ7KmBAmaFn9btXnN+Fjm
	8ycQvTEwrCM7tmnKpG0FlMPPPRsvBkY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bE4E4zbX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793268596;
	b=R7HtwKrhJcyiVqPP9Kjd5ZBEsftQQXy7ib7Fqv+W3t++WdLibQ6XJNrDbNvWm01nivtgTw
	O9lxT0cT0W1p2UBKWinFNygSrvoI498VvivpLZCDzmF3rkHXQwpvPmvSfc7Ga2pESibiBx
	tpB0ff/4WpQfY3Jt1zSSBMrXKVlU/wo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 385FA42204;
	Thu, 29 Oct 2026 10:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DC21F01825;
	Thu, 29 Oct 2026 10:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793268595;
	bh=BU7pHR/kDuxQISup5gyDHrCYYIiSnqHnQJ9cc+eRVuY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bE4E4zbXlGg+jZ10XS35/UCjnILg9jh57udeWj7kQsWUxzyBy+L/j/KMmrn2AT4Ba
	 x8lMBkVxNU/yyAHEu4B+tv3UGjjQ628qd8ffgcExaCXDdLJpMHRwpWv+rzn+SWEMEi
	 Q5ZLKbyKJe/WjYglcN0MAhzGCseYE7WdZSf05p4wvnXA8KgngBJFAD6bKn4sThP2XK
	 HCql8cc7iCeHs0Sz6sn7HJ6+9kOJdA1PrHWRxyR6NusM3Dup9/P9aFRN/qYodjf9qc
	 8aZjhczTgK/mCZrp4t3uyKGJiCf1mxVaMQhP0yjbm6tasdiy3uh/JTC0sdo5/cO3sX
	 3+fuUpg0uKPnA==
Message-ID: <sashiko-outbox-189098@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC] x86: Remove CALL_FUNCTION_VECTOR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peter Zijlstra" <peterz@infradead.org>, "Bharata B Rao" <bharata@amd.com>
Cc: linux-mm@kvack.org, Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net, mgorman@techsingularity.net, mingo@redhat.com, raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com, sj@kernel.org, weixugc@google.com, willy@infradead.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com, kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com, donettom@linux.ibm.com, xin@zytor.com, hpa@zytor.com, luto@kernel.org, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, jgross@suse.com, boris.ostrovsky@oracle.com
In-Reply-To: <20261028100930.GP2668564@noisy.programming.kicks-ass.net>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-8-bharata@amd.com>
 <20261028100930.GP2668564@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 10:09:52 +0000
X-Rspamd-Queue-Id: 9D4768000A
X-Stat-Signature: 7ro9kjbu1f9hijs6ia8h799rhwq4aqbz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793268596-68418
X-HE-Meta: U2FsdGVkX19VFD39qZpfK34ScyqxbvUzpebo9hgnMNOdo1YOFQeXAP5ZFyB/BDq+B1mC990jirltoqX9qbt1RNLr/DoGi1SUtKV0WKbZ9DSm9wSUpg93uLpnjavDKi1jX7I2DzZcQkn7JOkeednMhzO8+GbpVBsDdrulB8p8gagG/kUXsdgUTUwFMdFiRWVy711aY1fV0dw9i6d94SmEVzI55NQUhazCQJ51ccmv5X1/kFsa3y5AeENh+bmTXC75g2RQumHcXXT0Su5TyXbQr1RfNDLtX58c7kweu0NADlpU5fOgwAM+CA5KKX7CEDHDUdDCxDqP9MaVSbw+x1JaJ3eFU8Myu4votQVuT3GKUGfqP4ZtVUWAfdQ9si2VDprQigdRVE1HOaZJNw6JGCg6xMQsqWC6ckXuF8dCRkg5ff6oRMDtjlhHLkFK4JMUVkIA06/ohjTZWXchWjwSh7TaehawXqdsiZD5cw38L5i7X+uTeiDag+HtvawNYZwZV7MEFDJD5Rpt+ACC7whsIyAjnb4VaeuWmAdjcUQkticAcC5L7WDIx76lV1zXlvpHBPuklaKGaFAzwj0faxcOZid68rRTHRLJY3VD04c34WwZYqWvcuND2TpvtfFyX9FWCYuflIiI0gv+VwqhGsZOBfwRCu1r7uGi34kvKqVlDEluNww+i3TyXmuMEhBTbLRMaGaPqHwT8PUVhQ2ATYSbvLHzBLn4zINNwSNV0KU7p97v4u2Bed9ECaZFH7bOnqr4xJMBbwHqOc3GnDMWD0rcSh4yxqFGbdD2v8OF/e2jQOY5G/yYgiXWeNGRtjShOWKJtRRMKAa1eViE7jhwpOsww88zUMmCB6wJMI11l8bj9Td9YLEvzVi3BSCYUcSHMbllt9+KBvCqGD/kkFx971YaMgQRIKoS9nOO5ntR5DMsrOeti5hkez+dwD5XjDVxh6KspVSxvaqAVjA7e3yLKF4UsBJ
 m1Tqq3P3
 BDgQP6mH8zFTVq9U6EgvoltXvhORkyYTUgQRoOaU1sILX10ZePiQfP4Pna8Jk9cY1L3lQ8QzmWpCW/R6YudGPxruLKSwBREbm0cKo5yQrUXhfxI5POkrpLn2TcHnVx/2VOt/XpmAOsSbspnfIvhBHPll1dJWieWwsfsxo8R0Y+0R36PfD6F6KNHK2mWwuppRuT2WWGMtjJ94HAzR66YuQcHOHSzcXPn+rpUQHxh9lYWvKQsIY9kVS0A/U0qU7Sl2TRFGPkAvsJMeCOOcVRIc8jeQx5JUS0WXwKei/1FMNW6KjLY91pQgTMlNayBWV8r/5iSA7FM8PD9JMtsxDPBIYC73FTRtLwahZqkaHPAEGpGWhDkxC5suyih5WHAOpDCFLi4XW9XhLchYWeXkNt+mLe02FHRQfxGvDBFR8MwHY+uuVgx2pWk68areyif18+enl7aFF+xkC5sX8pNYcIBDIQhnS0pMbma48kdTdZWcfseCLzZ5uhbQPiPrPYBVz26uiRtt+r4MPKatbvgPXZBtxjXFdT7dFz/nXmAIEJgfXzaaw7CKY02rXC/jYYKv/42PpojRc25GCcoSPLnNl4uTleJhg612o5RgWQjHI/9j28cNjSXtpYoBmNtrffTz2Au84rxjqcmJbCf+pTm3wS4V4mzlzwypAzmAfBKnNsQTD72ES6k8CvF3R6tR4rg9+RBfSrko1kyBPF+k+XHuApnCqAG+XUl0pFSxeybIkKTPv4+b1Km+H+1ScrWeIVxhwrbMMv16pmOmRKog1dVMHcDXCroTKDjYGXxFE7wHKoWAXvJ35VcR3AEqEh84UjybYvk5dUcwbcwXs0yY3mww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] x86/xen: memory leak of callfunc_name in xen_smp_intr_init()
- [Low] x86/xen: unused xen_call_function_interrupt() causes build failure
- [Low] x86: dead call_function tracepoints and fred_sysvec_call_function m=
acro
--

commit a87f5828c6202eb98c865ff7619fe6fc331a81ac
Author: Peter Zijlstra <peterz@infradead.org>

x86: Remove CALL_FUNCTION_VECTOR

This commit removes CALL_FUNCTION_VECTOR and routes multi-CPU function call
IPIs through CALL_FUNCTION_SINGLE_VECTOR across native x86 APIC, FRED, IDT,
and Xen SMP paths.

> diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idten=
try.h
> index f400cfac69a6b..d429a2720e8e7 100644
> --- a/arch/x86/include/asm/idtentry.h
> +++ b/arch/x86/include/asm/idtentry.h
> @@ -679,7 +679,6 @@ DECLARE_IDTENTRY_SYSVEC(X86_PLATFORM_IPI_VECTOR,	sysv=
ec_x86_platform_ipi);
>  DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
>  DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
>  DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_functio=
n_single);
> -DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,		sysvec_call_function);
>  #else
>  # define fred_sysvec_reschedule_ipi			NULL
>  # define fred_sysvec_reboot				NULL

[ ... ]

> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 985103cab16c4..c7397816b311a 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -255,15 +255,6 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_reschedule_ipi)
>  	trace_reschedule_exit(RESCHEDULE_VECTOR);
>  }
> =20
> -DEFINE_IDTENTRY_SYSVEC(sysvec_call_function)
> -{
> -	apic_eoi();
> -	trace_call_function_entry(CALL_FUNCTION_VECTOR);
> -	inc_irq_stat(CALL_FUNCTION);
> -	generic_smp_call_function_interrupt();
> -	trace_call_function_exit(CALL_FUNCTION_VECTOR);
> -}
> -
>  DEFINE_IDTENTRY_SYSVEC(sysvec_call_function_single)
>  {
>  	apic_eoi();

[Severity: Low]
Removing sysvec_call_function() in arch/x86/kernel/smp.c drops the only call
sites of trace_call_function_entry() and trace_call_function_exit(), while
DEFINE_IRQ_VECTOR_EVENT(call_function) remains in
arch/x86/include/asm/trace/irq_vectors.h:

    DEFINE_IRQ_VECTOR_EVENT(call_function);

Those dead tracepoints are also still registered in
arch/x86/kernel/trace.c:osnoise_arch_register() and osnoise_arch_unregister=
():

    ret =3D register_trace_call_function_entry(trace_intel_irq_entry, NULL);
    if (ret)
            goto out_call_function_single_exit;

    ret =3D register_trace_call_function_exit(trace_intel_irq_exit, "call_f=
unction");

as well as in kernel/trace/rv/monitors/nrp/nrp.c:attach_vector_irq() and
kernel/trace/rv/monitors/sts/sts.c:attach_vector_irq() (and their
corresponding detach_vector_irq() functions):

    rv_attach_trace_probe("nrp", call_function_entry, handle_vector_irq_ent=
ry);
    rv_attach_trace_probe("sts", call_function_entry, handle_vector_irq_ent=
ry);

In addition, in arch/x86/include/asm/idtentry.h, the !CONFIG_SMP branch sti=
ll
defines:

    # define fred_sysvec_call_function			NULL

Should the call_function tracepoint definitions, their osnoise and RV monit=
or
registrations, and fred_sysvec_call_function also be removed so the unused
tracepoints do not remain exported and trigger warnings when building with
UT=3D1?

> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 05ee0d3b0874e..d5544026ede5a 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c

[ ... ]

> @@ -80,16 +73,6 @@ int xen_smp_intr_init(unsigned int cpu)
>  	callfunc_name =3D kasprintf(GFP_KERNEL, "callfunc%d", cpu);
>  	if (!callfunc_name)
>  		goto fail_mem;
> -	per_cpu(xen_callfunc_irq, cpu).name =3D callfunc_name;
> -	rc =3D bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
> -				    cpu,
> -				    xen_call_function_interrupt,
> -				    IRQF_PERCPU|IRQF_NOBALANCING,
> -				    callfunc_name,
> -				    NULL);
> -	if (rc < 0)
> -		goto fail;
> -	per_cpu(xen_callfunc_irq, cpu).irq =3D rc;

[Severity: Medium]
Does xen_smp_intr_init() in arch/x86/xen/smp.c leak callfunc_name on every =
CPU
initialization under Xen?

The kasprintf() allocation for "callfunc%d" is left in place:

    callfunc_name =3D kasprintf(GFP_KERNEL, "callfunc%d", cpu);
    if (!callfunc_name)
            goto fail_mem;

Because per_cpu(xen_callfunc_irq, cpu).name =3D callfunc_name was removed, =
that
buffer is never saved, so it is leaked if the subsequent VIRQ_DEBUG setup
jumps to fail_mem or fail, and is unconditionally overwritten shortly after=
 by
the "callfuncsingle%d" allocation:

    callfunc_name =3D kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
    if (!callfunc_name)
            goto fail_mem;

    per_cpu(xen_callfuncsingle_irq, cpu).name =3D callfunc_name;

[Severity: Low]
Also in arch/x86/xen/smp.c, removing bind_ipi_to_irqhandler() for
XEN_CALL_FUNCTION_VECTOR in xen_smp_intr_init() leaves
xen_call_function_interrupt() without any callers:

    static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
    ...
    static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
    {
            generic_smp_call_function_interrupt();
            inc_irq_stat(CALL_FUNCTION);

            return IRQ_HANDLED;
    }

Won't leaving this static function defined in arch/x86/xen/smp.c trigger an
unused-function warning and break the build when CONFIG_XEN=3Dy, CONFIG_SMP=
=3Dy,
and CONFIG_WERROR=3Dy?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028100930.GP26=
68564@noisy.programming.kicks-ass.net?part=3D1

