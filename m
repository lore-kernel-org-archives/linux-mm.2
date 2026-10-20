Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EEB606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdB4N2SO
Received: by kanga.kvack.org (Postfix)
	id 319986B0112; Mon, 19 Oct 2026 21:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3936B0113; Mon, 19 Oct 2026 21:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2A06B0114; Mon, 19 Oct 2026 21:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D80806B0112
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:15:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5567BC085B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:15:50 +0000 (UTC)
X-FDA: 85341237660.05.F5DAC97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A787C80006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:15:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kdB4N2SO;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792458948;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbfVyiLzAYz1jww3q4dZuBThU7PqcGq6KA0OFEb1pwU=;
	b=iis2fEeqgV3bDOVt8j1MWjAeXgUI4fy9/co5I5AIDeAHJPxF9FxFpgIx/Vu3+8hAWl/V+S
	p4ISSCeb5eRlpDTPGUj/jPWgOu/qRqnJJMjVpW3Fsk0d19zIXExGI0BWsDTB5+QayXBgP+
	qoEXGwbSkPvQ9d/k/Qe5BqK08mvyOMg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792458948;
	b=ZQTEqTDir+AlB7yC7vjvZye3wj89Q3Xdr8f0YJrAZ3+SEJWyqzr9wtKO280jyWOq2Z1ZRo
	+EXLHZUWlIPRMsHZcF2+oLgoBJTTyS9Nq3xnu9ld+nwWWmeyHcd6Dgb14bRTMfPL57tU+i
	r6oJEp1PJrelaqj1pGW00J7WIGViHY4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kdB4N2SO;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27DA543D14;
	Tue, 20 Oct 2026 01:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21B31F000C4;
	Tue, 20 Oct 2026 01:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792458947;
	bh=BbfVyiLzAYz1jww3q4dZuBThU7PqcGq6KA0OFEb1pwU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kdB4N2SOIqUWpm0JJ3MUocWUhSoZePEBg6SIgOxt+p+I11HqdgsBKzHL3Vlq/Eqwo
	 ZePzu913xUp+oUIweXZEp1wKjPW37qkJBdR/c13yVt/8vnbfRopwfuOxwM7Q/+ENNw
	 ZDSFyDSy6u0kIoIZOKbWFlfKDTB7nqs1tufl2SaDe5WOXsGBlBAKkRbYSYKCaNct76
	 7pvDRhLY6OF4/3x+QRzmTb5I71VE//C3fnWNKqo/RmRCYMw7I5aVnXFZsiF3Bulk66
	 IhyAUYDeD4PRxdHL+RU4s97Ne9PQTXiP1p446uxB7/O1hph48TJVELyx6T1nIrDXop
	 69qxbguaUyltw==
Message-ID: <sashiko-outbox-178403@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/8] x86/smp: Remove unnecessary WBINVD from
 mwait_play_dead()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, kees@kernel.org, rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com, tglx@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com, vincent.guittot@linaro.org, bp@alien8.de, jpoimboe@kernel.org, tony.luck@intel.com, david@kernel.org, mingo@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org, seanjc@google.com, ljs@kernel.org, zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com, mhocko@suse.com, vinicius.gomes@intel.com, vbabka@kernel.org, peterz@infradead.org, surenb@google.com, hpa@zytor.com, x86@kernel.org, dmatlack@google.com, tim.c.chen@linux.intel.com, kexec@lists.infradead.org, pratyush@kernel.org, dave.hansen@linux.intel.com, rostedt@goodmis.org, gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de, graf@amazon.com, liam@infradead.org, ridong.chen@linux.dev, blum@kernel.org, longman@redhat.com, bsegall@google.com
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com
In-Reply-To: <20261019011446.834487-3-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
 <20261019011446.834487-3-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 01:15:44 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A787C80006
X-Stat-Signature: 7mqof5fpizeu7yqh6mu4r4xos1dfhqno
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792458948-877608
X-HE-Meta: U2FsdGVkX1+eywn1+Jj37ueG4M4zpN+Yv8Px75Z5UDfO3OP37oUmjWvuGsVif6ITEJVuMF5QuuY8JL+oiWIF3krV76E3F1h84sTOtG1gRlggs/D5wsesLDxyp4UWyv5VCAfcroqJ8u8xc3pTetd1+j0l2n+WM08C7JK7l5BsZHvxV7wU+3Hsqi8rcWWQ7TjIlMEt5+Qu9rf+QmVldLvHI51amCAJ7C2TJjjUWj9MhdqWgoV8KmS/4q7gcvAO3KKB4tKNunm5/WzijO904uGCMIpsXsUWiLWPff/X0Twk7g3y5dmvr2l5ovdu+gnQcVcG+J5K/jYNgPWMLNllTsLA4zqktr+hGhdK3r/kpsVajGX9gjCZC/5vVYw8zd/TaR107INLz6+Y6Bq8oMRH7m98us7y6MGeLj+E4mY3YrIP2wJlR+7qgzzKzOX7GHX/fDfB83fgTCs/Vce9StxfUvz+5T+s3ejIkqkaaRMc1ri9U6Np+Pn5e5i+sUDMaMLy1qeVk6EMlDGAn+cNYFhM3VFtEk/ryAkvqlG3yoXa3GjwvMcwmkvWt3MBt3Of3K/0oBKK7DAzwytCc/3t8PMsLPPP7qWDGDGNznQ9v9Z6nWKthWt5EIhfx04Yu/i2dLgIhwoT/9Sma2OtHmL9LMOO5Uiu26JyaDJaOuvTqookrrHyEuUttpjaWBmvr4fPSvAfwbKJHQiJHH2IUJJ8RaWxcbgRvUN2pUeCb6+I5IcfiSkv6cNgizPr8OZEnFIGA3nCTpTfkKxDYZUKHTB3pSuj6hlUIqefW6YYQ7bo/SQ0+dGJVJvzQf6HsZ5vlFBCcsNUUSyVbg6hnWo+ouhc69KKGbRXNHBUujQKOFZ7hJZr2eWbxMyLatV0OJkfq/gpVgLirFlYZVcE1+NnQ2E+CvEZUPFdMnlCGWGdbHkjWb5nNIldoSye6b6+qyVIptGUFhdE5OJzjcCFBtwRToMNUEL4uWD
 bXuN11G/
 ZMvUnSPaRZXmF0eyI0BbmXh1NCP8vLYWrihNi+5h8NSyVlq1RbrAmFHCqx9u29bbBLxzTp+HBzQ9TVTlFehaGjlx0LnvVJQpqFHn1xOrfmNsVUq8lJUopGj0FyctQ6N36hMADfCek0qHepCDokLzqMatC9fyiTGJdTLoRjV71KzHnFnGcSObkAHhFzfIbGby6sEeXx0f/TJDtIcjbxAE0eI8aD78VuxwHQ0PtmVsUJglbxZKqwmFfXckAGexND24birmRDv/jgeFQ+hVV9gP37sb/ZobiECcRNPyEtAqDoZ2fX3QmVRcfmtAxcvid0HiaV8vafwZyKfG8IPn9LJ3wcSndc5xkb1+QErgQy35Rt+mjqJiRTnp/eRS6Vdkf10dO9Iy7XGZ0fYFuNCy36cFzGP3V7kioACLIAwds3LHXZYVL/QuVmSxQZ8Ovq+frXFIpVwzlCpemUafLq1D7X96qJXTFUQjpe2hdzsYdQ6TtNc1e/Mk7JUa4qbeMc8kzkOrXf6++sNn9RY0PeUT1iHEgKUEiEHVNspbp4BG2s0EtNcf7Y4sIn4ZiiDiGt+FWBLKmPW4YO0IjFaG8qGI0qgn/PKJ+42hudR+Fah1SL20TVj1400zzkErxiCWxTv/fIt1OffPcIGU5uQPtlGlebMzJ83RGwFc64FSfbcKrnFw59fjcB5Q=
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
- [High] x86/smp: skipping wbinvd() in mwait_play_dead() breaks KVM wbinvd_=
dirty_mask
--

commit 52dafb51edf021a7aaa6017af5d2ddd2b493e51b
Author: Pasha Tatashin <pasha.tatashin@soleen.com>

x86/smp: Remove unnecessary WBINVD from mwait_play_dead()

This commit skips the wbinvd() call in mwait_play_dead() when entering an
MWAIT C-state deeper than C1/C1E while another CPU sharing the same
package and LLC remains online.

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index ba01a9e919b78..0dccd2f927bb6 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1414,10 +1414,28 @@ void play_dead_common(void)
>  	local_irq_disable();
>  }
> =20
> -/*
> - * We need to flush the caches before going to sleep, lest we have
> - * dirty data in our caches when we come back up.
> - */
> +static bool mwait_play_dead_needs_wbinvd(unsigned int eax_hint)
> +{
> +	unsigned int cpu =3D smp_processor_id();
> +	u32 pkg_id =3D topology_physical_package_id(cpu);
> +	u32 llc_id =3D per_cpu_llc_id(cpu);
> +	unsigned int i;
> +
> +	if (cpuhp_tasks_frozen || MWAIT_HINT2CSTATE(eax_hint) < 2 ||
> +	    llc_id =3D=3D BAD_APICID || this_cpu_read(cache_state_incoherent)) {
> +		return true;
> +	}
> +
> +	for_each_online_cpu(i) {
> +		if (topology_physical_package_id(i) =3D=3D pkg_id &&
> +		    per_cpu_llc_id(i) =3D=3D llc_id) {
> +			return false;
> +		}
> +	}

[Severity: High]
Can skipping wbinvd() in mwait_play_dead_needs_wbinvd() when another CPU in
the same LLC is online leave a KVM guest's dirty cache lines unflushed in
the shared LLC when emulating guest WBINVD?

For KVM vCPUs with non-coherent DMA enabled (need_emulate_wbinvd(vcpu)),
KVM does not use wbinvd_on_all_cpus(). Instead, kvm_arch_vcpu_load() tracks
only the specific physical CPU where the vCPU ran in
vcpu->arch.wbinvd_dirty_mask (or flushes vcpu->cpu via wbinvd_on_cpu()):

arch/x86/kvm/x86.c:kvm_arch_vcpu_load() {
    ...
	if (need_emulate_wbinvd(vcpu)) {
		if (kvm_x86_call(has_wbinvd_exit)())
			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
		else if (vcpu->cpu !=3D -1 && vcpu->cpu !=3D cpu)
			wbinvd_on_cpu(vcpu->cpu);
	}
    ...
}

When the guest later executes WBINVD, kvm_emulate_wbinvd_noskip() flushes
only the CPUs recorded in vcpu->arch.wbinvd_dirty_mask and clears the mask:

arch/x86/kvm/x86.c:kvm_emulate_wbinvd_noskip() {
    ...
	if (kvm_x86_call(has_wbinvd_exit)()) {
		int cpu =3D get_cpu();

		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
		wbinvd_on_cpus_mask(vcpu->arch.wbinvd_dirty_mask);
		put_cpu();
		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
	} else
		wbinvd();
    ...
}

wbinvd_on_cpus_mask() calls on_each_cpu_mask() ->
smp_call_function_many_cond(), which filters the target mask against
cpu_online_mask:

kernel/smp.c:smp_call_function_many_cond() {
    ...
	if (cpumask_any_and_but(mask, cpu_online_mask, this_cpu) < nr_cpu_ids) {
		cpumask_and(cpumask, mask, cpu_online_mask);
    ...
}

If a vCPU runs on physical CPU A (in LLC 0), migrates to CPU B (in LLC 1),
and CPU A goes offline via mwait_play_dead() while sibling CPU C in LLC 0
remains online, CPU A will now skip wbinvd() and only flush its core
caches into LLC 0 (or leave lines in shared L1/L2 if CPU C is an SMT
sibling).

If the vCPU never ran on CPU C, CPU C is not in
vcpu->arch.wbinvd_dirty_mask. When the guest subsequently executes WBINVD,
wbinvd_on_cpus_mask() ignores the offline CPU A and never sends an IPI to
CPU C, leaving the guest's dirty lines in LLC 0 unflushed to DRAM before
clearing vcpu->arch.wbinvd_dirty_mask.

> +
> +	return true;
> +}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019011446.8344=
87-1-pasha.tatashin@soleen.com?part=3D2

