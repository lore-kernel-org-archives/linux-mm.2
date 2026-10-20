Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0F4606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 01:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onJfwJKb
Received: by kanga.kvack.org (Postfix)
	id 02C376B0113; Mon, 19 Oct 2026 21:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFE4A6B0114; Mon, 19 Oct 2026 21:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72536B0116; Mon, 19 Oct 2026 21:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABA536B0113
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:15:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 386591C425F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:15:53 +0000 (UTC)
X-FDA: 85341237786.27.9D04C79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A2343A0005
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:15:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=onJfwJKb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792458951;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0zbPbIVrw8g+L4HtojTXOfkJRf2Y4cPRt8OPTYZy2o=;
	b=zJGAG4YkrBTdEOO2lv2XvoLLAfoHKcxKlNJoJ/LIxgmkB5Z5Lh0hGN4Npvi3olCpFf/mja
	DwHK9qofvt7Vol2R01/4+Ze/uFYRJDi+Lz89KM/ZLeMmdyqL3/RD2/I7nSJ4FqMFYEiF7s
	Qabyy3CMeXg/7EwYW8hBSQdeXEUFahw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=onJfwJKb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792458951;
	b=uaNbHKIBOekqTFqIzXAwGY+QLR6DeecCGVGnhuts4+SP+G/mBHwCA79Vfoj5VSgK9I5uiZ
	v0qWGdb0dbBDrTaHj2TXL9XgITfmIO0f823LZNYBrnDhgsoRxAG8FUb3ntur7TLpG0CogL
	W2d6UKzCpwsOhBn1hiH6dbMPekJSqDY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C742600AA;
	Tue, 20 Oct 2026 01:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F751F000C4;
	Tue, 20 Oct 2026 01:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792458950;
	bh=b0zbPbIVrw8g+L4HtojTXOfkJRf2Y4cPRt8OPTYZy2o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=onJfwJKbHbGdhCCzWjPhUi41SXBY/P3WASN9/ZXkShX3yQcO0ThFM5am6VhHMAKIb
	 ZDoHRkORVfUVoSls68OkttynCoYL3/HqPYDCv4IhQ+dUrgZdCyUYK9vPBZEcccR9jX
	 nwWe4q3ewkgXkAZrtaodf+bIwo1d4LBQ+ZnuJs0rerMC90Yj3wuZYim+Y93mJfP4rp
	 HfQLxLagcrSwRcnn4J79wIW8LdT6Ef3XbNsB//iFuUExuYCTVt8cAgFS1X7SSJp6cM
	 eh22Dv5lIYItT6CyIwvBcR5YoE7jBQru+evLNn+apE3NuNqsLjBrd153OlU8iBRZCe
	 4Z6/GTqUGf07g==
Message-ID: <sashiko-outbox-178404@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/8] x86/mce/intel: Bound cmci_rediscover() to a
 single topology peer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, kees@kernel.org, rppt@kernel.org, juri.lelli@redhat.com, nik.borisov@suse.com, tglx@kernel.org, vschneid@redhat.com, kprateek.nayak@amd.com, vincent.guittot@linaro.org, bp@alien8.de, jpoimboe@kernel.org, tony.luck@intel.com, david@kernel.org, mingo@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org, seanjc@google.com, ljs@kernel.org, zhangguopeng@kylinos.cn, dietmar.eggemann@arm.com, mhocko@suse.com, vinicius.gomes@intel.com, vbabka@kernel.org, peterz@infradead.org, surenb@google.com, hpa@zytor.com, x86@kernel.org, dmatlack@google.com, tim.c.chen@linux.intel.com, kexec@lists.infradead.org, pratyush@kernel.org, dave.hansen@linux.intel.com, rostedt@goodmis.org, gmonaco@redhat.com, jgross@suse.com, mgorman@suse.de, graf@amazon.com, liam@infradead.org, ridong.chen@linux.dev, blum@kernel.org, longman@redhat.com, bsegall@google.com
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com
In-Reply-To: <20261019011446.834487-4-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
 <20261019011446.834487-4-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 01:15:47 +0000
X-Rspamd-Queue-Id: A2343A0005
X-Stat-Signature: smipbaxo4the1a5eppdk78yg3kxbx8m6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792458951-718905
X-HE-Meta: U2FsdGVkX1/MS1s0dtjtE3xtKDnh5haBrNoZcvZLC7a5/I777VMl+HYz//KC8RbVhbKZ7q1dLV0PBqknklZ1fAlhO4/KMAiyOczcZw7pJOHZz9bXImv0sh9MC2jJxUDwwwYEdz/IY0gxCFwD4YKm2YYA/eU0s30VybB829xHA4jwoGZ+Wjjlw+NfA3xA0ExlJ4tPpb9zqzxKMuLYCgvgNgi3tr1Nf+PdDHf89/35L0JrNPHPeRxG4rhlESJB2iRecvD5E0SbbOiScf3bkmJH61mInAVNfR64KyIHoBJRe8HNRX5mr/mvlW6dsrxch6Rop/3hDKntvOlGi5jFIS4v0FoRTE78YldBT0WWOHWSuWlrNFqGXC+edXlqvAraC8ELaamUWgI7/W+EQv22/OVPRobjBb7l6eQRijlFI2pLxCxtps96Ixv3CyD45S5JRurMcrQkXoKPrV8yL2VItGVJ9nXlALcyAoiR4CpdMRNkcbwTDI6DdA5r8Dw93wRcpWrn337wAQrZNkx69E1bklr7trlGHH363js5XxmwXHRgLCSOHf3OS3k1Z2NA8exWlrhpx5ELXyq42VcRLFHWhMjpBJGslTv34SOpzgKZBSGQJpi80gmCfPk0LfF+1+0QHN8gN8hEjdX5VoJTxDvJKvEGy8XU72+6R2SVkxLHNFyJMAWXiwf8QjuItZUWfSGluhlANCz6oxhVAH+tyWs8whcnnk4Gu/WYbMqzKNph+vOt8gNeznfdCBKg33weNblqieouPz7cePlJS/cPq2Sh6LIkPkub6wy2kiQekxyCAXynZXs33jutgCgV3z1T0Yq8YIKg+IYgwz/YckJAAL4TBvYYMLfzr3eXaBV219C2oTfcZpADsWNp7I3xsw0n2FaRPNZES+H/wV0FZN1relnYTe2XbcOoA5FMO16K6San5I+k6a/T1ZulnSNN9egdZQaT9NPD5AmTl+fu8RZx8ZNmM/P
 KtZdOFgr
 di9KeoJ1Ok+8eJWageS6n2BrjJTNNrHfD5/Fcc8ji8orO6bQlfRSSjro4Fd9bw7sQykUHNYgyIWC2XdYFnbXqTTP2U4suWXrUXHTa4qTriqx1aXtLqhoPPIfPtM5I7ALrT7kX9yvvofkhrUkVoUHE8mB2mv1MzUv0sXHb5ib5XIWHL9BB2zOXi/FZq/iFNF1EEAmS/gsYUIqBVVPk23FjlyyaTknx+WZukobyalD5uNOXsXDR5C1OtdnmYq4DlUXSsEDMWpAyjO2Ilne5tgc/kKEB2RMVqgu2WiAJ/e3YXfZvI8HcC/l1Kmb1SRzFCMsbbW4ou3YHXa6R80AqIqHTr80bxa9KyLkERcQF2Sk5F0mcUbat+tRxxXjcJ1SHQ3dCLAX7+qtx5JLI+nvRRt6aVzb3eYqIeDBs5j/UNR5FhP8UYDFHtx/KvFPqPBAN4aaESXYGhHnyvwy5iIkmIVeOnkp8GmzhGkcspcM7+quHXKNB+DAk7wa6bMjtWa1D8B1cnxUQVOsikGs+JOgS4czOZqdHfPNEfucxvv3SDWaJ53YIfQ075qrL7PwI8G8Ip20AAeE+cgZdYc1c57HSTQWN4weAdBma6n/7FRWrPj2e9enYIiaJqS08PUWzCDonlZ8bICwrAXW1PKB5TzkHqw+vdIcmq9StcXlgA+AY8mvUooTJnJY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] x86/mce/intel: missing LLC topology level in cmci_clear() peer sel=
ection
- [Medium] x86/mce/intel: cmci_rediscover() leaves shared banks unclaimed o=
n hybrid CPUs
--

commit cb9d97fffee1a97a8d921b6c7ed854215ee3231b
Author: Pasha Tatashin <pasha.tatashin@soleen.com>

x86/mce/intel: Bound cmci_rediscover() to a single topology peer

This commit optimizes CPU offline CMCI bank rediscovery by recording
orphaned banks in cmci_clear(), selecting a single online topology peer,
and probing only that target peer via smp_call_function_single() in
cmci_rediscover() instead of broadcasting to all online CPUs with
on_each_cpu().

> diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/in=
tel.c
> index 4655223ba5606..f57718b097d9b 100644
> --- a/arch/x86/kernel/cpu/mce/intel.c
> +++ b/arch/x86/kernel/cpu/mce/intel.c
[ ... ]
> @@ -346,8 +353,31 @@ void cmci_clear(void)
>  	if (!cmci_supported(&banks))
>  		return;
>  	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
> +	bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
> +	/*
> +	 * A bank is shared by the CPUs of one SMT core, L2 cluster, die or
> +	 * package, and these scopes nest. The first online peer found from
> +	 * the innermost scope outwards is therefore part of every sharing
> +	 * scope that still has an online CPU, so it alone can claim every
> +	 * orphaned bank that is still claimable. If it already owns an index,
> +	 * the instance released here is not shared with it, hence not with
> +	 * any online CPU, and that index can be dropped from the rediscovery.
> +	 */
> +	target =3D cpumask_any_but(topology_sibling_cpumask(cpu), cpu);
> +	if (target >=3D nr_cpu_ids)
> +		target =3D cpumask_any_but(topology_cluster_cpumask(cpu), cpu);
> +	if (target >=3D nr_cpu_ids)
> +		target =3D cpumask_any_but(topology_die_cpumask(cpu), cpu);
> +	if (target >=3D nr_cpu_ids)
> +		target =3D cpumask_any_but(topology_core_cpumask(cpu), cpu);
> +	cmci_orphaned_target =3D target;
>  	for (i =3D 0; i < banks; i++)
>  		__cmci_disable_bank(i);
> +	if (target < nr_cpu_ids)
> +		bitmap_andnot(cmci_orphaned_banks, cmci_orphaned_banks,
> +			      per_cpu(mce_banks_owned, target), MAX_NR_BANKS);

[Severity: High]
Should the outward peer search in cmci_clear() also check
cpu_coregroup_mask(cpu) (or cpu_llc_shared_mask(cpu)) between
topology_cluster_cpumask(cpu) and topology_die_cpumask(cpu)?

In arch/x86/kernel/smpboot.c:set_cpu_sibling_map(), x86 populates
cpu_llc_shared_mask as a distinct topology level between
cpu_l2c_shared_mask (topology_cluster_cpumask) and topology_die_cpumask:

    if ((i =3D=3D cpu) || (has_smt && match_smt(c, o)))
        link_mask(topology_sibling_cpumask, cpu, i);

    if ((i =3D=3D cpu) || (has_mp && match_llc(c, o)))
        link_mask(cpu_llc_shared_mask, cpu, i);

    if ((i =3D=3D cpu) || (has_mp && match_l2c(c, o)))
        link_mask(cpu_l2c_shared_mask, cpu, i);

    if ((i =3D=3D cpu) || (has_mp && match_die(c, o)))
        link_mask(topology_die_cpumask, cpu, i);

On processors where cpu_coregroup_mask(cpu) is narrower than
topology_die_cpumask(cpu) (for example, processors that enumerate tiles via
CPUID leaf 0x1f tile domain or leaf 0x4 L3 cache sharing rather than die
domain, such as Meteor Lake and Arrow Lake where compute tile cores and SoC
tile LP E-cores have distinct llc_id values while sharing die_id, or Xeon
systems in SNC mode), offlining the last online CPU of an L2 cluster while
other CPUs in the same LLC/tile remain online will skip directly to
topology_die_cpumask(cpu).

If cpumask_any_but(topology_die_cpumask(cpu), cpu) picks a target on a
different LLC/tile, could an MCA bank scoped to the offlined CPU's LLC/tile
either be masked out of cmci_orphaned_banks by bitmap_andnot() (because the
remote-tile target owns its own tile's instance of that bank index) or fail
to be claimed by the remote target in cmci_rediscover(), leaving the bank
with CMCI disabled and unpolled while online peers in cpu_coregroup_mask(cp=
u)
are never probed?

> +	else
> +		bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
>  	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
>  }
> =20
> @@ -360,15 +390,38 @@ static void cmci_rediscover_work_func(void *arg)
>  		cmci_discover(banks);
>  }
> =20
> -/* After a CPU went down cycle through all the others and rediscover */
> +/*
> + * After a CPU went down, rediscover orphaned shared banks on a single
> + * topology peer (SMT sibling, L2 cluster peer, die peer, or package pee=
r)
> + * selected in cmci_clear(). Core-private banks whose core is now comple=
tely
> + * offline cannot be claimed by any other core, so probing more than one
> + * peer is redundant.
> + */
>  void cmci_rediscover(void)
>  {
> +	unsigned int target;
> +	unsigned long flags;
> +	bool orphaned;
>  	int banks;
> =20
>  	if (!cmci_supported(&banks))
>  		return;
> =20
> -	on_each_cpu(cmci_rediscover_work_func, NULL, 1);
> +	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
> +	orphaned =3D !bitmap_empty(cmci_orphaned_banks, MAX_NR_BANKS);
> +	target =3D cmci_orphaned_target;
> +	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
> +
> +	if (!orphaned)
> +		return;
> +
> +	if (target < nr_cpu_ids && cpu_online(target))
> +		smp_call_function_single(target, cmci_rediscover_work_func,
> +					 NULL, 1);
> +
> +	raw_spin_lock_irqsave(&cmci_discover_lock, flags);
> +	bitmap_zero(cmci_orphaned_banks, MAX_NR_BANKS);
> +	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
>  }

[Severity: Medium]
Can probing only a single target CPU in cmci_rediscover() leave shared MCA
banks unclaimed on hybrid processors where CPUs on the same die or package
have different MCA bank counts or per-bank CMCI capabilities?

In cmci_rediscover_work_func(), cmci_supported(&banks) re-reads
MSR_IA32_MCG_CAP on the target CPU because CPUs do not necessarily all have
the same bank count:

    /* Recheck banks in case CPUs don't all have the same */
    if (cmci_supported(&banks))
        cmci_discover(banks);

On hybrid systems (such as Alder Lake, Raptor Lake, Meteor Lake, or Arrow
Lake), P-cores and E-cores share topology_die_cpumask(cpu) and
topology_core_cpumask(cpu) while exposing different bank counts or bank
layouts. When the last thread of a P-core goes offline through
mce_cpu_pre_down() -> mce_disable_cpu() -> cmci_clear() and
mce_cpu_dead() -> cmci_rediscover(), cpumask_any_but() on the die or package
mask can select an E-core with a smaller bank count as cmci_orphaned_target
even when another P-core is still online.

When that happens, cmci_discover(banks) on target only iterates up to targe=
t's
bank count, and cmci_rediscover() then unconditionally clears
cmci_orphaned_banks with bitmap_zero() without falling back to other online
CPUs if unclaimed bits remain. Since other CPUs sharing those higher-number=
ed
banks already cleared them from their per-CPU mce_poll_banks bitmaps in
cmci_skip_bank() during initial discovery, wouldn't those shared banks rema=
in
both unowned for CMCI and unpolled?

=D1=82=D0=B8=D1=82=D1=8C=D1=81=D1=8F

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019011446.8344=
87-1-pasha.tatashin@soleen.com?part=3D3

