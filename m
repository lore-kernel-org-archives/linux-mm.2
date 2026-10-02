Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0847FCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6976B0088; Fri,  2 Oct 2026 05:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8496B008A; Fri,  2 Oct 2026 05:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 996546B008C; Fri,  2 Oct 2026 05:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 659076B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:50:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBEB8A69EE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:50:13 +0000 (UTC)
X-FDA: 85277215506.01.4453863
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C4DB40002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:50:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gAPrQEDt;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcxHbGrbBBd+ZbiEKqPPTOGbAdZ4oweyY74cWRXJ4A4=;
	b=nsOQwm4WWT9JIz+lBzgcpxNhmLHuJxWvHemkMVexq4GhytqC7qTcFtlqgkw+r99tJhWDFe
	wdya3mZ/uImesoyY5mTTdtaYCKKWuTEJmp6odn/yKjrgx5MruXTZiFlXs5eejXs/crlDP3
	84tcXyFlTIWoGMJ3+GmjK8lmI/5XNcQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934612;
	b=u1ms8WUrb2brBtWyBREPpSiWTLTyoSE7cXBrea3YJ9G+5pttzdUwOOfvwspL3ED4eK6hx5
	4lFZ6IPrpsohOOmUIOuhWexoq/uPyNchKmRO30SPjICNQrZlat/BDWAzt7/9wDO/exRMR1
	Eo9u7OUJNZDG2EQN/Qm4sTpgsaG4Gyk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gAPrQEDt;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3267260A8A;
	Fri,  2 Oct 2026 09:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517EC1F000FF;
	Fri,  2 Oct 2026 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790934609;
	bh=OcxHbGrbBBd+ZbiEKqPPTOGbAdZ4oweyY74cWRXJ4A4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gAPrQEDtvcj0uF96iQbKfHCV09YjefRDPX+v8laiclSad4nDTQin6kgMq0VTsLjBD
	 2HUvHYLzMhK8v1H3UW8pAi+lvcv4mqA0n5mwTpzFjPSZt73mGDuXUuNZT6nLap02eR
	 Msx+bwDK/B9pZ+OfP5m/FjHnEdEI6vkmNgz5YQXWDQSRPVuXHmhub3VUdxH62k4nWF
	 eyMsk/8N3iH8rCtg7QVjfjA8fdMFkR3DGXEYjk+fWhmQiL8z7daSLXoEqq7wsuIDTS
	 WcCxqPBH1kQCBd2VBXkAd+wqZBEzWqKpSt/an4Ij7+kRzVfRFh/bkOgaYu7GrOP4BS
	 tc0KssSeIVYdg==
Date: Fri, 2 Oct 2026 10:50:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com, pbonzini@redhat.com, 
	Borislav Petkov <bp@alien8.de>, Tal Zussman <tz2294@columbia.edu>, 
	Rik van Riel <riel@surriel.com>, Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <ar9yRqq6cBxHDWKA@gremlin>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <arZHp8hjYFXE8Rkt@gremlin>
 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
 <areOeRwZOez0eHm7@gremlin>
 <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gcvq56525zjfayut"
Content-Disposition: inline
In-Reply-To: <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
X-Rspam-User: 
X-Stat-Signature: q65y3b61k39yjiujd47kun6oepq5ueqo
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2C4DB40002
X-HE-Tag: 1790934612-804009
X-HE-Meta: U2FsdGVkX1/cqqExPhFokiTddpa+VuA4AZgcMNMHtlChO67F8G1Q1xHdAYgW2QiE4bR3j0e/VDu0m0sf44P6/kWY+zGuFOJI3xsXcEYi0UHfcf2s2+ndwUlzyMt7lxUVgJtUVJxXmfJ8Wx/tKEhAB2Kpdnw/2kSM1VDYcvLGNr8m20boeEqkey/k7Sb2skxv1LcyN0iqTcDkdBQZknvqTbhJB+ejHKw3dKD73sBkhf1xVXYtUnkRQEG/W0amT5SuBENEyaJEkEFdcjkkeK7kWUG7laqnTMsVsIryGq4MIxTuwqoUijSENpM74oC9hU9pDOgkozVOBCF0ZhlZx0zakryeAuyYrCDkIylLQo/lKFaVtLPAdqVIvqy992B68tUF5owl9hx2Jfl7LP37a7jfIOLTtQWaaLdgOEzpNvplsFMW+de7CHTpQ5msEnpnn6/1LrdoV6GP+8WDduLr9OIVWBqBXv5HVNr1Ja/KfVWr67dK/jjjK0uTUIjXuPpXqduYk4bYnY7PWuCaHaiZgw3tuZ7HbpCV6HjZvzwRKWPCnSm+8fmGYruzKPcZlfVQluLXmr2yOS1OW6VfnubPULUnCM+Rdm0MOPdaCj3gNZ6xdmGzCNk9nVDn2eZ+qp9z3wTIzkZfJTIqbHcuP2wpTc/MlYFrSK+/fmukfylpCMvXU8uLAfpYwDGmCCqfxDjy0ChoELPQT8g2W0Zh65b9Imi/hVC6vS1MlSjQ+K96DPM0XlC9D5uy40TRRURPrT/XnCq0H2p558BPwLZ5FIJO4jqHBw1/kGdoEZ2lbxvd3lJobEArwy6FlXNG8nqhRuClwrbTXbDv5UtnRlU2JhhB2IVml9TXIPvaqIxeF4trLOG06lIyIBweFeID6VEJSdzS/WHx9ZKHsODyf3KNJZlfF0mBEZRQP9PQzJMfienFZPmSLw9MQ1NPkJ5inLqxeQHtCs+iDo24PnJP2NLFMdWlTWN
 JWFGzHv+
 zPNeIuLD+17sz/wqFQ/d6v+E5+QxVD20C1pc8MHRw1CQGCbw4EkI0XWnlk/HEOIUjZnk9dHgRTc2TGZi7zVLF3EpmBFUMUPjX/0VTIkSIWmpirN5RaUo5E1i6jWu59SyukfOHfW3o4WYrIujEwEcxaI36Io05yiMUqZip6XKxFLdlpGzyag6rM4QxvQGbVRfemiljaIneFg3Z5Xw7E4RIYuunHG0rU+nogRkoNh/IVuBOV0t4hvHqV0cy0ywEO03ifRue4g2JHc774DzOM69of+LWgPUv8mVC1IkDdPcr9FHX3yK/uV71b2oknNP0yzCtch3qQrTGO8nybFb65TZUfwjWYxFgX5iPFvJ5ECTSZumTF9fgBdckMrDpH17t6qhNb+8nvvO3M+3U8sixBZ3KK6Dm+LOWCE2ur8ykGuN2tZRlPt56WkzkYjOQ7Jj4ZmpIsFyRAxFmZnFyPcrjRrfVnmPVJkNpmQJYTsfaCOl9a7e6mypAkmUsV4UNEJVLLJBWGA5Hu6WI87xJE52xYeIK5IihSG1ZEdFkDwdEbSebjrgOhcOBepycdp52Oe/jnx4IewiKqppuXiXF6gRCO2TCWfsQ9L7U6aOPP1Uv+PkBKTbc3hDNZGvokKt+QCSZ/K/+cNtY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--gcvq56525zjfayut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

+cc Boris, Tal, Rik, Matt FYI - seems another instance of the INVLPGB bug.

On Thu, Oct 01, 2026 at 09:40:58PM +0200, Nikola Ciprich wrote:
> Hello again,
>
> the good (?) news is, in the meantime we got another crash on different machine
> and I have a kdump including complete vmcore. This one was 6.18.53
>
> here are some details:
>
> Hardware: Supermicro AS-2024US-TRT / H12DSU-iN, BIOS 3.5 (2025-09-22). Dual-socket AMD EPYC 7343 16-Core, 32 CPUs, 1024 GB RAM.
>
> analyzed with crash + matching vmlinux debuginfo:

Thanks that's useful.

We can rule out CPA at this point.

>
> Oops:
> general protection fault, probably for non-canonical address 0xfffffff0c930038
> RIP: __d_lookup+0x4a/0xc0
> Comm: systemd PID: 1274600 CPU: 23
> Call trace:
> __d_lookup
> lookup_fast
> walk_component
> link_path_walk
> path_openat
> do_filp_open
> do_sys_openat2
> __x64_sys_openat
> do_syscall_64
>
> Exception frame registers:
> RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 000000000000000b
> RDX: ffff985ffd223600 RSI: ffffb18962823d70 RDI: ffff989ddf09b5c0
> RBP: 000000005560450b R8: 000000007fffffff R9: fefefefefefefeff
> R10: 0000000000000000 R11: 93c3d2eb02a31dda R12: ffff989ddf09b5c0
> R13: ffff989ddf09b5c0 R14: ffffb18962823d70 R15: 0000000000000000
>
> Faulting instruction (cmp %ebp,0x18(%rbx)) dereferences RBX+0x18. RBX held
> the non-canonical value 0x0fffffff0c930020, giving fault address
> 0x0fffffff0c930038. __d_lookup was walking the d_hash (hlist_bl) bucket;
> RBX was the node pointer being dereferenced.
>
> Observations from the vmcore:
>
> The faulting value 0x0fffffff0c930020 is non-canonical and is not a mapped
> kernel address:
> crash> kmem 0x0fffffff0c930020
> kmem: cannot determine page for fffffff0c930020
> fffffff0c930020: physical address not found in mem map
>
> The dentry being looked up (RDI/R12/R13 = 0xffff989ddf09b5c0) is intact and
> well-formed:
>  name "app.slice", len 9, d_name.hash 0xCE973022 (consistent)
>  d_op = kernfs_dops; valid d_parent, d_inode, d_sb
>  d_hash.next = 0x0 (this node is the end of its bucket chain)
>
>  The target dentry and its hash chain in the dump show no corruption; the
>  chain terminates cleanly.
>
> No page migration, compaction, or THP activity was in progress on any CPU
> at panic. "bt -a" filtered for migrate*/compact*/khugepaged/kcompactd/
> kswapd/split_huge*/folio*/d_move/rename returned nothing.
>
> Automatic NUMA balancing was disabled at crash time (read from kernel memory):
>  crash> p sysctl_numa_balancing_mode
>  $ = 0
>
> Top-level (PMD) transparent hugepage policy was "never" at crash time:
> crash> p/x transparent_hugepage_flags
> $ = 0x1c0
> Bits set: 6 (DEFRAG_REQ_MADV), 7 (DEFRAG_KHUGEPAGED), 8 (USE_ZERO_PAGE).
> Bits 0 (TRANSPARENT_HUGEPAGE_FLAG) and 1 (REQ_MADV_FLAG) are clear, i.e.
> sysfs enabled = never. Per-order mTHP controls (huge_anon_orders_*) were not
> inspected for this dump, so mTHP state is not asserted here.
>
> No MCE/EDAC/hardware-error records are present in the kernel log for this host.
>
> I can provide the full vmcore and the matching vmlinux/debuginfo on request, and
> run further crash queries against it.
>
> not sure if this is of any help?

Very useful.

It looks like AMD TLB invalidation issues are the leading likely cause here
then - one on the host side with INVLPGB, and a separate one in KVM with
INVLPGA.

And it looks like a hardware bug, unfortunately.

Support for this was merged in 6.15 which matches your kernel versions too.

It's actually not solved yet, but there are two workarounds that can be
applied here.

## Issue 1: INVLPGB

See [0] for a report of the same kind of thing (segfaults like yours),
and [1] for the proposed temporary workaround.

TL;DR: The mitigation for this is to update your kernel command line parameters
thusly:

  6.18.45 and later (6.18.53, 6.18.54):   tlbi=ipi
  <6.18.45:                               clearcpuid=419

If this resolves it then it confirms that this is the issue.

There is also, usefully, a reproducer which should show corruption
in minutes rather than weeks, see:

https://gist.github.com/mfleming/ca26ad3f8d65a12d23d62fb176480fc1
https://lore.kernel.org/all/akzuETUv5XEFSRL6@matt-Precision-5490/

The fact you've seen this on a Milan machine (EPYC 7343) is new information
so that could be useful for the report, so if you can reproduce _without
the fix_ first that'd be very useful to know!

Also then try the fix and see if it reproduces afterwards.

If the reproducer doesn't work then I guess worth waiting to see if hosts
reproduce over a longer time period with the tlbi=ipi issue.

Also, which CPU is in the first crash host (the ASUS SP5 box)? That'd be
useful to know thanks!

## Issue 2: INVLPGA

This is a separate issue, as mentioned before - Red Hat have seen windows
guest memory corruption on AMD with hv-tlbflush which tlbi=ipi won't
touch.

I had the AI generate a patch for you that applies to 6.18.53 and even
6.18.44 to make your life easier :)

The patch is attached.

For a kernel tree with git:

git am 0001-KVM-SVM-flush_tlb_gva-full-asid-flush-6.18.y.patch

Or just plain raw code:

patch -p1 < 0001-KVM-SVM-flush_tlb_gva-full-asid-flush-6.18.y.patch

So please test issue 1 separately with the cmdline change, but if you're
still seeing issues especially with windows guests, then this KVM patch
should then ALSO be applied.

This is [2] which is merged upstream as commit 26505e1b5b54 ("KVM: SVM:
make svm_flush_tlb_gva do a full asid flush if NPT enabled").

## Crash + vmcore

Obviously do the above and especially try the reproducer in the lab! :)

But also with the vmcore, can you run these 4 commands and reply with the
output please?

     crash> p dentry_hashtable
     crash> rd -64 0xffff986002783000 512
     crash> search -p 0x0fffffff0c930020
     crash> vtop 0xffff986002783a50
     crash> search -p -m 0xfff0000000000fff <the PHYSICAL value vtop prints>

## Mitigations for production

I suggest you apply both of the above for your production as it's _likely_
it will resolve the issue there.

The cmdline changes are perfectly safe but you should check the generated
patch, however!

I suspect it'll be fine but I can't guarantee it obviously LLMs
etc. (albeit it is a frontier model so at least as good as it can be ;)

## Attachments

I attach the backported fix as discussed above and also the AI's full debug
report FYI.

--
Cheers, Lorenzo

[0]:https://lore.kernel.org/all/CAAuFnRTyva1_3tsF3vrMBL+TLS1YL4EgUPT2c3O9k7A9hWUMnA@mail.gmail.com/
[1]:https://lore.kernel.org/all/20260914045823.GFaqd-7yDf6aK4JUQr@fat_crate.local/
[2]:https://lore.kernel.org/all/20260723094419.630204-1-pbonzini@redhat.com/

--gcvq56525zjfayut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-SVM-flush_tlb_gva-full-asid-flush-6.18.y.patch"

From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18.y] KVM: SVM: make svm_flush_tlb_gva do a full asid flush if NPT enabled

commit 26505e1b5b546e2fa9a0296b951ca158460c72d8 upstream.

Red Hat is seeing multiple reports of Windows memory corruptions
(and consequent BSODs) with hv-tlbflush=on, on AMD processors only
(Turin and Milan; none on Intel; none on Turin with a full ASID flush).

When NPT is enabled, replace the per-address INVLPGA in
svm_flush_tlb_gva() with a full flush of the current ASID.  This covers
both callers of the flush_tlb_gva op: kvm_hv_vcpu_flush_tlb() (Hyper-V
PV TLB flush, i.e. hv-tlbflush) and kvm_mmu_invalidate_addr() (L1
INVLPGA for nested SVM, emulated #PF, emulated INVLPG).  Shadow paging
keeps using INVLPGA.

[ Backport note for 6.18.y: reduced to the svm.c functional change.
  Upstream also changes the kvm_x86_ops.flush_tlb_gva signature to
  return a "full" flag so that kvm_hv_vcpu_flush_tlb() stops iterating
  once a full flush has been requested, and touches vmx/main.c,
  vmx/vmx.c, vmx/x86_ops.h, hyperv.c and mmu.c for that.  That part is
  a performance optimisation only and is omitted here: without it the
  Hyper-V flush loop keeps calling svm_flush_tlb_asid() for each
  remaining page, which only re-sets TLB_CONTROL_FLUSH_ASID and is
  cheaper than the INVLPGA it replaces.  Upstream's svm_flush_tlb_guest()
  additionally marks VCPU_REG_ERAPS dirty; ERAPS virtualisation does not
  exist in 6.18.y, whose .flush_tlb_guest is svm_flush_tlb_asid(), so
  calling svm_flush_tlb_asid() directly is the exact equivalent. ]

Analyzed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Analyzed-by: Alexander Lougovski <alougovs@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a24a6871b693..5bfb72e550e2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4071,7 +4071,18 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	invlpga(gva, svm->vmcb->control.asid);
+	/*
+	 * INVLPGA has had errata on Genoa and Turin, and even on older
+	 * generations there were reports of Windows BSODs if INVLPGA
+	 * was used for Hyper-V tlbflush.  Use it only for shadow paging
+	 * where it seems to be okay.
+	 */
+	if (!npt_enabled) {
+		invlpga(gva, svm->vmcb->control.asid);
+		return;
+	}
+
+	svm_flush_tlb_asid(vcpu);
 }
 
 static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)

--gcvq56525zjfayut
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="debug-report.txt"

Summary
=======

The 6.18.53 crash rules out the CPA collapse race I pointed at earlier.

6.18.53 carries the complete CPA series (a1c7570cedd0, d5d8b8662e6e,
1587d3394e25, 9e4a3ec3411b and the rest). The new oops is the same as
the 6.18.44 one: same RIP, __d_lookup+0x4a, and the same corrupt bucket
word, 0x0fffffff0c930020. It happened on a different host (Milan
instead of the SP5 box), with a different build and a different KASLR
layout. On top of that, 6.18.54 corrupted libglib in page cache and a
6.18.15 node crashed. The CPA bugs are real, but they are not this bug,
and my earlier diagnosis was wrong.

The leading candidate is now the AMD INVLPGB/TLBSYNC stale-TLB issue.
It was reported publicly in June and no kernel has a fix for it yet:

  "PROBLEM: Probabilistic segfault on AMD hardware with INVLPGB"
  Henrik Boving, 2026-06-19
  Message-ID: <CAAuFnRTyva1_3tsF3vrMBL+TLS1YL4EgUPT2c3O9k7A9hWUMnA@mail.gmail.com>
  https://lore.kernel.org/all/CAAuFnRTyva1_3tsF3vrMBL+TLS1YL4EgUPT2c3O9k7A9hWUMnA@mail.gmail.com/

- Henrik saw heap corruption on an EPYC 9455 (Turin) from 6.15 onwards.
  He bisected it to CONFIG_BROADCAST_TLB_FLUSH.

- Matt Fleming posted a userspace reproducer on 2026-07-07. It reuses
  VAs with munmap() + mmap(MAP_FIXED) under a rwlock. Reader threads
  still see data from the previous mapping after the INVLPGB + TLBSYNC
  flush has returned:
  https://lore.kernel.org/all/akzuETUv5XEFSRL6@matt-Precision-5490/

- Rik reproduced it and posted a double-TLBSYNC diff, which is not
  merged. He also noted that Meta saw elevated segfault rates on Turin
  that the AMD-SB-3029 firmware fixed. Henrik's microcode (0x0B002162)
  is newer than that fix, so firmware does not explain his case.

- Tal Zussman confirmed it on an EPYC 9965 (Turin Dense) on 2026-09-13.
  It corrupts in the first round, and with clearcpuid=419 it passes 20
  rounds:
  https://lore.kernel.org/all/20260914022055.1639690-1-tz2294@columbia.edu/

- Borislav answered on the same day: "There will be an official thing
  Soon(tm). In the meantime, tlbi=ipi":
  https://lore.kernel.org/all/20260914045823.GFaqd-7yDf6aK4JUQr@fat_crate.local/

Every public confirmation so far is Zen5 (Turin and Turin Dense). Rik
asked whether Milan or Bergamo reproduce it, and nobody has answered.
Your second crash host is Milan (EPYC 7343, Zen3). A result from your
hosts, positive or negative, is therefore new information for the x86
maintainers.

It fits what you have seen:

- AMD only.
- 5.15 is fine and 6.18 is not. The broadcast flush code went in in
  v6.15.
- QEMU does heavy mmap/munmap churn around migration.
- It is timing sensitive: you could not reproduce it with KASAN or
  SLUB debugging enabled.
- Host .so files are corrupted in page cache while the files on disk
  are intact.

I can't tie the dentry hash table damage to it directly. Further down
there is a hypothesis for that, clearly labelled, together with the
vmcore checks that would confirm or refute it.


What to do now
==============

Disable broadcast TLB flushing on every AMD host. No patch is needed.

  6.18.45 and later (6.18.53, 6.18.54):   tlbi=ipi
  6.18.15 and 6.18.44:                    clearcpuid=419

tlbi= only exists from 6.18.45 onwards (upstream abe7c8b09bd7,
backported as 846b92e26c8a), so 6.18.15 and 6.18.44 have to use
clearcpuid=419. 419 is 13*32+3, i.e. X86_FEATURE_INVLPGB.
clearcpuid=419 works on 6.18.45+ as well, but tlbi=ipi does not taint
the kernel. These are the parameters Borislav and Tal used in the
thread above.

Details that matter:

- The parameter has to be exactly "tlbi=ipi". The handler only matches
  "ipi" and returns 1 for anything else. "tlbi=off" is therefore
  accepted silently and does nothing:

    arch/x86/kernel/cpu/common.c (6.18.53):

    static int __init tlbi_setup(char *str)
    {
    	if (!strcmp(str, "ipi"))
    		setup_clear_cpu_cap(X86_FEATURE_INVLPGB);

    	return 1;
    }
    __setup("tlbi=", tlbi_setup);

- "clearcpuid=invlpgb" does not work on 6.18. X86_FEATURE_INVLPGB has no
  name string in cpufeatures.h, so the boot log says "clearcpuid:
  unknown CPU flag: invlpgb" and INVLPGB stays enabled. Use the number.

- With clearcpuid=419 the kernel prints "clearcpuid: force-disabling
  CPU feature flag: 13:3", then the "setcpuid=/clearcpuid= in use ...
  Tainting kernel" warning, and sets taint S. That is expected.

- Do not use "nopcid" as a workaround on 6.18.15. 44126343d58c
  ("x86/mm: Disable broadcast TLB flush when PCID is disabled") only
  arrived in 6.18.35. Without it, nopcid leaves INVLPGB enabled, and
  the first broadcast flush with a non-zero PCID takes a #GP in
  broadcast_tlb_flush().

How to check that it is in effect:

- /proc/cpuinfo can't tell you. The flag has no name in 6.18, so
  "invlpgb" never appears there, whether it is enabled or not.

- CONFIG_BROADCAST_TLB_FLUSH is "def_bool y" with "depends on
  CPU_SUP_AMD && 64BIT" and no prompt. Every 6.18 x86-64 build with AMD
  support has it:

    grep BROADCAST_TLB_FLUSH /boot/config-$(uname -r)

- The definitive check is the capability word. You can read it with
  crash or drgn and debuginfo, either on a live system or in a vmcore:

    crash> p/x boot_cpu_data.x86_capability[13]

  If bit 3 (0x8) is set, the kernel is using INVLPGB. If it is clear,
  it is not.

- For tlbi=ipi, check /proc/cmdline. For clearcpuid=419, look for the
  dmesg line above and for taint bit 2 (value & 4 in
  /proc/sys/kernel/tainted).

- As a sanity check, the "TLB shootdowns" row in /proc/interrupts
  should rise noticeably faster under the same load, because QEMU's
  flushes go back to IPIs.

Testing whether your CPUs are affected, with Matt's reproducer:

    https://gist.github.com/mfleming/ca26ad3f8d65a12d23d62fb176480fc1
    https://lore.kernel.org/all/akzuETUv5XEFSRL6@matt-Precision-5490/

    build:  gcc -O2 -std=c11 -pthread -static -o repro-invlpgb <source>.c
    run:    ./repro-invlpgb --batch --rounds 20 --jobs 32 -d 5 -w 8 -m 2 -s 512 -q

Run it on a drained Milan host and a drained Genoa host, once with the
default boot and once with tlbi=ipi. If it fails on Zen3 or Zen4 with
the default boot and passes with tlbi=ipi, that is new information and
should go to the INVLPGB thread above. A pass with the default boot is
weaker evidence, because the reproducer was tuned on Zen5.

Even if the reproducer passes, running production with tlbi=ipi is
the real test. Given how intermittent this is, a clean run has to last
several times longer than your previous time to failure before it
means much.


Kernel versions and machines
============================

  Crash 1: 6.18.44 (6.18.44lb9.01). ASUSTeK RS720A-E12-RS12 /
           K14PP-D24, BIOS 2305 11/21/2025, AMD EPYC on SP5. Windows
           guests only, no host swap, about 22 days of uptime.
           pacemaker-controld in mkdir().

  Crash 2: 6.18.53. Supermicro AS-2024US-TRT / H12DSU-iN, BIOS 3.5
           (2025-09-22), 2x EPYC 7343 (Milan, Zen3), 1 TB RAM.
           THP "never", NUMA balancing 0, no MCE/EDAC records. systemd
           in openat(). The full vmcore is available.

  6.18.54 production node (nrbphav4a): a libglib segfault storm within
           minutes of receiving migrated VMs (see below).

  6.18.15 node: crashed while VMs were being migrated to it. No
           details were posted.

  5.15.x: clean.

The CPU model of the first host is not in the report. I have been
assuming Genoa, but the board is SP5, which takes both Genoa (9004,
Zen4) and Turin (9005, Zen5). If that box is actually Turin, it falls
straight into the publicly confirmed set. Please send the "model name"
and "microcode" lines from /proc/cpuinfo for every affected host,
including nrbphav4a.


Stack traces
============

Crash 1 (6.18.44):

  Oops: general protection fault, probably for non-canonical address
  0xfffffff0c930038: 0000 [#1] SMP NOPTI
  CPU: 23 UID: 189 PID: 7538 Comm: pacemaker-contr 6.18.44lb9.01 #1
  RIP: 0010:__d_lookup+0x4a/0xc0
  RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 0000000000000000
  RDX: ff2e6dbe0d9b6000 RSI: ff7532a13699fe60 RDI: ff2e6d1e4e630d80
  RBP: 000000000b654440
  Call Trace:
   <TASK>
   d_lookup+0x27/0x50
   lookup_dcache+0x1f/0x80
   lookup_one_qstr_excl+0x1e/0xe0
   filename_create+0xc4/0x160
   do_mkdirat+0x5a/0x190
   __x64_sys_mkdir+0x42/0x60
   do_syscall_64+0x64/0xbf0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

Crash 2 (6.18.53, from crash(8) on the vmcore):

  general protection fault, probably for non-canonical address
  0xfffffff0c930038
  RIP: __d_lookup+0x4a/0xc0
  Comm: systemd PID: 1274600 CPU: 23
  RAX: 0fffffff0c930020 RBX: 0fffffff0c930020 RCX: 000000000000000b
  RDX: ffff985ffd223600 RSI: ffffb18962823d70 RDI: ffff989ddf09b5c0
  RBP: 000000005560450b
  Call trace:
   __d_lookup
   lookup_fast
   walk_component
   link_path_walk
   path_openat
   do_filp_open
   do_sys_openat2
   __x64_sys_openat
   do_syscall_64

In crash 2 the parent dentry (RDI, "app.slice", kernfs) is intact and
its own hash chain terminates cleanly.


Other relevant messages
=======================

On 6.18.54, nrbphav4a, right after receiving migrated VMs, every glib
user faulted at the same file offset:

  qemu-system-x86[19014]: segfault at 0 ip 00007f9a3ee7e61e sp 00007ffd96294380 error 6 in libglib-2.0.so.0.6800.4[a461e,7f9a3edf7000+91000]
  pacemaker-execd[17696]: segfault at 0 ip 00007f3c6ed6a61e sp 00007fffa95873d0 error 6 in libglib-2.0.so.0.6800.4[a461e,7f3c6ece3000+91000]
  Code: 29 9c 24 80 00 00 00 0f 29 a4 24 90 00 00 00 0f 29 ac 24 a0 00 00 00 0f 29 b4 ff ff 00 00 00 0f 29 bc ff ff 00 00 00 64 00 00 <00> 00 28 00 00 00 48

The bytes around the fault are a run of movaps stores to the stack
followed by the stack-protector load. That pattern tells us what the
original bytes were:

  file offset   expected      found
  0xa460e       24 b0         ff ff         movaps %xmm6,0xb0(%rsp)
  0xa4616       24 c0         ff ff         movaps %xmm7,0xc0(%rsp)
  0xa461c       48 8b 04 25   00 00 00 00   mov %fs:0x28,%rax

The file on disk will confirm the expected column.

Every process maps the same page-cache page, so they all fault at the
same file offset. The damage consists of two 16-bit stores of 0xffff and one
32-bit store of 0, at +6, +6 and +4 of three consecutive 8-byte slots
(page offsets 0x608, 0x610 and 0x618).

These are ordinary CPU stores to small struct fields. They are not DMA
(NIC descriptor write-backs are 16 or 32 bytes) and they are not
page-walker A/D bit updates. This is what a CPU writing through a
translation that no longer belongs to the writer looks like. The
earlier ld.so relocation assertion and the libcrypto.so.3 corruption
are the same class of damage.


Register decode (short)
=======================

This is already on the list, so I'll keep it brief.

In both oopses RAX == RBX == 0x0fffffff0c930020. RAX is only written by
the initial load of the bucket head, so the fault is on the first
iteration of the loop:

    fs/dcache.c:__d_lookup() {
    	struct hlist_bl_head *b = d_hash(hash);
    	...
    	hlist_bl_for_each_entry_rcu(dentry, node, b, d_hash) {

    		if (dentry->d_name.hash != hash)   <-- faults on 0x18(%rbx)
    			continue;

The corrupt word is therefore the dentry_hashtable bucket head itself,
not a dentry. d_hash_shift is patched to 7, i.e. 2^25 buckets and a
256 MiB table:

  crash 1: 0xff2e6dbe0d9b6000 + (0x0b654440 >> 7) * 8 = 0xff2e6dbe0e51b440
           (page offset 0x440)
  crash 2: 0xffff985ffd223600 + (0x5560450b >> 7) * 8 = 0xffff986002783a50
           (page offset 0xa50)

The crash 2 line assumes that RDX holds the table base, as it does in
crash 1 (same code, same RIP). "p dentry_hashtable" in the vmcore will
confirm it.

The table comes from alloc_large_system_hash() with HASH_EARLY. That is
memblock memory, allocated at boot and never freed, and nothing
legitimately writes a non-pointer into it. So whatever wrote the word
used a wrong translation or a wrong physical address.

The same 64-bit value on two hosts, with different CPUs, builds and
KASLR layouts, means the data written is deterministic. As David said,
that can't be a coincidence.

What the word decodes to:

- As an x86-64 Linux swap PTE it fits exactly (type 1, offset
  0x79b67f), with bit 5 set. But the first host has no swap and no
  Linux guests, so a Linux swap PTE is an unlikely origin.

- It is not a KVM SPTE. SVM MMIO SPTEs have bit 0 set, and non-present
  and frozen SPTEs have bit 63 set. It is also not an AVIC physical or
  logical ID table entry, and not any VMCB field.

- As a Windows x64 software PTE (MMPTE_SOFTWARE) it reads Valid=0,
  Protection=1 (MM_READONLY), Prototype=0, Transition=0,
  PageFileLow=0 and PageFileHigh=0x0fffffff. That PageFileHigh is the
  "lookup needed" marker 0xffffffff with bits 60-63 clear. However, the
  UsedPageTableEntries (0x93), ShadowStack and Unused fields are also
  non-zero. This fit is weak. It rests on public Windows internals
  documentation, not on anything I can check in kernel sources.


The suspect code
================

    commit 767ae437a32d644786c0779d0d54492ff9cbe574
    Author: Rik van Riel <riel@surriel.com>

    x86/mm: Add INVLPGB feature and Kconfig entry

    Link: https://lore.kernel.org/r/20250226030129.530345-3-riel@surriel.com

This commit starts the v6.15 broadcast TLB flush series, and the tlbi=
switch (abe7c8b09bd7) names it as its Fixes: target. I am not claiming
a bug in this code. As far as I can tell, the hardware does not
provide the completion guarantee that the code relies on. The series
explains why 5.15 is good, 6.18 is bad and only AMD is affected.

    > diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
    > --- a/arch/x86/Kconfig.cpu
    > +++ b/arch/x86/Kconfig.cpu
    > @@ -334,6 +334,10 @@ menuconfig PROCESSOR_SELECT

    [ ... ]

    > +config BROADCAST_TLB_FLUSH
    > +	def_bool y
    > +	depends on CPU_SUP_AMD && 64BIT

There is no prompt, so a build can't opt out. The only switches are at
boot time.

    > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
    > --- a/arch/x86/include/asm/cpufeatures.h
    > +++ b/arch/x86/include/asm/cpufeatures.h
    > @@ -338,6 +338,7 @@

    [ ... ]

    >  #define X86_FEATURE_XSAVEERPTR		(13*32+ 2) /* "xsaveerptr" Always save/restore FP error pointers */
    > +#define X86_FEATURE_INVLPGB		(13*32+ 3) /* INVLPGB and TLBSYNC instructions supported */

The comment has no quoted name. That is why the flag is invisible in
/proc/cpuinfo and why clearcpuid= only accepts it by number.

    [ ... ]

    commit 4afeb0ed1753ebcad93ee3b45427ce85e9c8ec40
    Author: Rik van Riel <riel@surriel.com>

    x86/mm: Enable broadcast TLB invalidation for multi-threaded processes

    Link: https://lore.kernel.org/r/20250226030129.530345-11-riel@surriel.com

This commit moves ordinary user TLB flushes for large multi-threaded
processes onto INVLPGB. On a KVM host, that means QEMU.

    > diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
    > --- a/arch/x86/mm/tlb.c
    > +++ b/arch/x86/mm/tlb.c
    > @@ -430,6 +430,105 @@ static bool mm_needs_global_asid(struct mm_struct *mm, u16 asid)

    [ ... ]

    > +static void consider_global_asid(struct mm_struct *mm)
    > +{
    > +	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
    > +		return;
    > +
    > +	/* Check every once in a while. */
    > +	if ((current->pid & 0x1f) != (jiffies & 0x1f))
    > +		return;
    > +
    > +	/*
    > +	 * Assign a global ASID if the process is active on
    > +	 * 4 or more CPUs simultaneously.
    > +	 */
    > +	if (mm_active_cpus_exceeds(mm, 3))
    > +		use_global_asid(mm);
    > +}

A CPU running a vCPU thread in guest mode still has QEMU's mm loaded.
Any VM with four or more busy vCPUs therefore gets a global ASID
quickly.

    [ ... ]

    > +static void broadcast_tlb_flush(struct flush_tlb_info *info)
    > +{
    [ ... ]
    > +	} else do {
    [ ... ]
    > +		invlpgb_flush_user_nr_nosync(kern_pcid(asid), addr, nr, pmd);
    [ ... ]
    > +	} while (addr < info->end);
    > +
    > +	finish_asid_transition(info);
    > +
    > +	/* Wait for the INVLPGBs kicked off above to finish. */
    > +	__tlbsync();
    > +}

The kernel's correctness argument rests on this TLBSYNC. Once it
returns, no CPU may still hold the old translation, and only after that
are the pages and page tables freed:

    mm/mmu_gather.c:tlb_flush_mmu() {
    	tlb_flush_mmu_tlbonly(tlb);  <-- flush_tlb_mm_range(): INVLPGB + TLBSYNC
    	tlb_flush_mmu_free(tlb);     <-- pages and page tables freed
    }

Matt's reproducer shows that on Zen5 another CPU can keep using the old
translation after TLBSYNC has returned.

    > @@ -1260,9 +1359,12 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,

    [ ... ]

    > -	if (cpumask_any_but(mm_cpumask(mm), cpu) < nr_cpu_ids) {
    > +	if (mm_global_asid(mm)) {
    > +		broadcast_tlb_flush(info);
    > +	} else if (cpumask_any_but(mm_cpumask(mm), cpu) < nr_cpu_ids) {
    >  		info->trim_cpumask = should_trim_cpumask(mm);
    >  		flush_tlb_multi(mm_cpumask(mm), info);
    > +		consider_global_asid(mm);

Once QEMU has a global ASID, every flush of its address space uses
INVLPGB + TLBSYNC and no IPI. That covers munmap(), MADV_DONTNEED
(balloon, free page reporting), mprotect() and page migration.

Global ASIDs aren't the only route. In 6.18 the batched unmap flush
used by reclaim and migration (arch_tlbbatch_flush()) issues an INVLPGB
for all non-global entries, for every process. Kernel range flushes use
INVLPGB as well.

Software audit. I went through the INVLPGB paths in 6.18.53 looking
for a kernel-side hole:

- munmap/zap with freed page tables
- the dynamic-to-global ASID transition
- global ASID reuse
- lazy CPUs and CPUs in the middle of a switch
- reclaim batching
- kernel range flushes

I did not find one:

- TLBSYNC runs on the issuing CPU, with preemption disabled, before
  any page or page table is freed.
- INVLPGB reaches lazy CPUs.
- finish_asid_transition() sends IPIs to stragglers still on a dynamic
  ASID.
- A global ASID is only reused after an INVLPGB of all non-global
  entries plus a TLBSYNC.

The code is identical in 6.18.15, 6.18.44 and 6.18.53, and every
post-6.15 fix to it is in 6.18.53. KVM never issues INVLPGB and never
exposes it to guests.


How this could reach the dentry hash table (hypothesis)
=======================================================

Everything in this section is inference. None of it has been
demonstrated.

A stale leaf translation can only reach the page that was freed. That
covers the libglib and ld.so damage, where the freed page came back as
page cache, and guest RAM corruption. It cannot reach dentry_hashtable,
which the page allocator never owned.

A stale paging-structure entry can. Suppose the entry that survives on
another CPU is the cached PDE pointing at a PTE table that
free_pgtables() has just released. That CPU then walks whatever the
freed page now holds as if it were a PTE table. Its stores to any VA in
that 2 MiB region go to whatever PFNs the entries in the reused page
happen to name, and that includes boot-time memory.

The identical word follows if the data being stored is guest RAM. A
Windows page-table page commonly holds long runs of one identical
software PTE. Suppose QEMU copies such a guest page through the broken
walk, for example on migration receive or in a virtio/vhost copy into
guest memory. It then writes 512 copies of the same 8-byte value over
one host physical page.

If that page belongs to dentry_hashtable, every bucket in it reads
0x0fffffff0c930020. Any lookup that hashes into one of those 512
buckets then faults the way both oopses did, at whatever page offset it
lands on (0x440 in one crash, 0xa50 in the other). Two hosts running
Windows guests would end up with the same word.

    CPU A (QEMU thread)                 CPU B (QEMU vCPU/IO/vhost
                                        thread, same mm, global ASID)
    -----                               -----
    munmap() of a region
    zap, free_pgtables()
    tlb_finish_mmu()
      flush_tlb_mm_range(freed_tables)
        INVLPGB (PCID, VA range)
        TLBSYNC returns
    PTE table page P freed
                                        still caches the PDE -> P
                                        (the hardware issue)
    P reallocated, e.g. as guest
    RAM, now holding guest data
                                        store to a VA in the same 2 MiB
                                        region (VA reused by a new mmap)
                                        walks P as a PTE table and
                                        writes to the PFN it finds
                                        a 4K copy of a Windows page
                                        table page, 512 copies of
                                        0x0fffffff0c930020, lands on
                                        a dentry_hashtable page
    days later:
    __d_lookup() hashes into that
    page and faults

There are weak points, and I want to be upfront about them:

- The public reproducer demonstrates stale leaf data only. This chain
  needs a stale paging-structure entry.
- The Windows reading of the word is weak (see above).
- The guest mix on the Milan host isn't stated. If it runs no Windows
  guests, the Windows part of this falls apart.
- The target PFN comes from whatever the reused page holds, so other
  pages would be hit too. The dentry table is just large, read
  constantly and never freed, which makes it a likely place to notice
  the damage.


What the 6.18.53 vmcore can settle
==================================

B below is the crash 2 bucket address from above.

1. Bucket and physical page:

    p dentry_hashtable
    p d_hash_shift
    eval 0xffff985ffd223600 + (0x5560450b >> 7) * 8     -> B
    vtop B                                              -> PHYS_B
    kmem B
    eval B & ~0xfff                                     -> PAGE_B

2. The whole 4K page. This is the most important check:

    rd -64 PAGE_B 512

   Then do the same for the pages at PAGE_B - 0x1000 and PAGE_B +
   0x1000 (compute them with eval first).


   If the hypothesis holds, most of the 512 words in PAGE_B are
   0x0fffffff0c930020, and the run starts and ends on the 4K boundary.
   A few buckets may hold valid dentry pointers inserted after the
   damage, and their chains should end in the same word.

   If only the one word is bad and the rest are 0 or dentry pointers,
   the hypothesis is refuted. In that case this was a single 8-byte
   store, and the 4K copy story is wrong. The neighbouring pages show
   whether there was more than one event.

3. Where else the word lives:

    search -p 0x0fffffff0c930020
    search -p -w 0x0c930020

   Physical searches over 1 TB take a while. For each hit, use kmem -p
   on the physical address to classify it: qemu anonymous memory (guest
   RAM), page cache, slab, page table or reserved. If a hit is in guest
   RAM, rd -64 the page and count the repeats.

   The hypothesis predicts pages in Windows guests' RAM where the word
   repeats in long runs (guest page tables), plus the damaged
   hash-table page or pages. If the word exists only in the dentry
   table, the guest-data origin loses its support.

4. Who points at the bucket's page:

    search -p -m 0xfff0000000000fff PAGE_PHYS

   PAGE_PHYS here is PHYS_B & ~0xfff. This matches any 8-byte value
   whose bits 12-51 equal the page's physical address, i.e. any
   PTE-shaped entry pointing at it. The direct map normally covers the
   hash table with 2M or 1G leaves, so no 4K entry naming that page
   should exist.

   A PTE-shaped hit inside guest RAM that is laid out like a page table
   would directly support the "guest data walked as a host page table"
   route. Expect noise. Only hits with P and RW set and sensible low
   bits are interesting. The page that served as the stale table may
   have been reused again since, so finding no hit does not refute the
   hypothesis.

5. Whether INVLPGB was in use at crash time:

    p/x boot_cpu_data.x86_capability[13]   # bit 3 (0x8) set: INVLPGB used
    p global_asid_available                # 2039 at boot (PTI built in),
                                           # 4087 without; lower means
                                           # global ASIDs were handed out
    p last_global_asid
    ps | grep -E 'qemu|vhost'
    task -R mm <qemu pid>
    p ((struct mm_struct *)<mm>)->context.global_asid   # non-zero: broadcast
    p cpu_tlbstate:a                       # loaded_mm_asid >= 6 is global

6. KVM and platform state:

    mod -s kvm_amd
    p npt_enabled
    p nested
    p avic
    p x2avic_enabled
    sys config | grep -E 'BROADCAST_TLB_FLUSH|DEBUG_VM|INIT_ON_(ALLOC|FREE)|PAGE_POISON'
    log | grep -iE 'AVIC|AMD-Vi|microcode'

From a live host on the same build, please also send:

    cat /sys/module/kvm_amd/parameters/{npt,nested,avic}
    grep -E 'model name|microcode' /proc/cpuinfo | sort -u
    virsh dumpxml <windows-vm> | grep -E 'hyperv|feature|<cpu'

Please also tell us whether the Windows guests run with VBS/HVCI
(msinfo32, "Virtualization-based security"), and which guest OSes run
on the Milan host.


KVM SVM INVLPGA (26505e1b5b54)
==============================

Posting: https://lore.kernel.org/all/20260723094419.630204-1-pbonzini@redhat.com/

This is a guest-memory fix. It is not the host corruption fix.

In 6.18.53, svm_flush_tlb_gva() (INVLPGA) only drops guest-virtual
translations. It is never the thing that protects a host page about to
be freed. Every path that takes a page away from a guest flushes
through kvm_flush_remote_tlbs() -> svm_flush_tlb_all() ->
TLB_CONTROL_FLUSH_ASID before the host page can be reused. That covers
mmu_notifier zaps (munmap, MADV_DONTNEED from balloon or free page
reporting), KSM, compaction and migration, memslot delete, dirty
logging, TDP page-table free and VM destroy.

GPA invalidations don't reach INVLPGA at all:

    arch/x86/kvm/mmu/mmu.c:kvm_mmu_invalidate_addr() {
    	...
    	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
    	if (mmu != &vcpu->arch.guest_mmu) {
    		...
    		kvm_x86_call(flush_tlb_gva)(vcpu, addr);
    	}

A missed INVLPGA therefore leaves at worst a stale GVA->HPA entry
whose HPA still backs one of the guest's own GPAs. The result is
guest-internal corruption, i.e. Windows BSODs, which is what Red Hat
saw. It can't touch host page cache or the dentry table.

On 6.18.53 with NPT, INVLPGA is reached from:

- the Hyper-V PV TLB flush (hv-tlbflush). You said this never ran on
  the crashed nodes.
- L1 INVLPGA under nested SVM (VBS/HVCI guests). This is redundant,
  because every nested VMRUN and #VMEXIT already does a full ASID
  flush.
- the rare emulated #PF and emulated INVLPG paths.

Applying it to 6.18.y: you don't need the ~134 svm.c commits. The
minimal backport changes only svm_flush_tlb_gva(), and
svm_flush_tlb_asid() is already defined above it in 6.18.
"git apply --check" passes on 6.18.53 and on 6.18.44. I have not
checked 6.18.54.

The rest of the upstream patch is a signature change that lets
kvm_hv_vcpu_flush_tlb() stop iterating early, which is a performance
optimisation only, and an ERAPS register mark that has no counterpart
in 6.18. The patch is attached as
0001-KVM-SVM-flush_tlb_gva-full-asid-flush-6.18.y.patch. The
functional change is:

    @@ -4071,7 +4071,18 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
     {
     	struct vcpu_svm *svm = to_svm(vcpu);
     
    -	invlpga(gva, svm->vmcb->control.asid);
    +	/*
    +	 * INVLPGA has had errata on Genoa and Turin, and even on older
    +	 * generations there were reports of Windows BSODs if INVLPGA
    +	 * was used for Hyper-V tlbflush.  Use it only for shadow paging
    +	 * where it seems to be okay.
    +	 */
    +	if (!npt_enabled) {
    +		invlpga(gva, svm->vmcb->control.asid);
    +		return;
    +	}
    +
    +	svm_flush_tlb_asid(vcpu);
     }

It's worth carrying for the Windows guests, especially any with
hv-tlbflush or VBS. It won't stop the dentry or libglib corruption. The
host mitigation is tlbi=ipi (or clearcpuid=419), and that needs no
patch.


AVIC, the GA log and guest-side reports
=======================================

AVIC: ca2967de5a5b (v6.18-rc1) makes avic=auto turn AVIC and x2AVIC
on by default for Zen4+ with X2AVIC. 5.15 had avic=0.

    arch/x86/kvm/svm/avic.c (6.18.53):

    	if (avic == AVIC_AUTO_MODE)
    		avic = boot_cpu_has(X86_FEATURE_X2AVIC) &&
    		       (boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4));

On a Zen4 or Zen5 host with X2AVIC, AVIC and IPI virtualisation (and,
with the AMD IOMMU in GA mode, device-posted interrupts) are therefore
on in 6.18 where they were off in 5.15. On the Milan 7343 host AVIC is
off unless avic=1 is set explicitly. That host crashed identically, so
AVIC is not needed for the dentry crash unless it was forced on there.
The /sys/module/kvm_amd/parameters/avic values from both hosts settle
this.

GA log UAF: 78684b65fcc0 ("KVM: SVM: Remove VM from the GA Log notifier
list before VM destruction", v7.3-rc1, not in 6.18.y) fixes a
use-after-free in avic_ga_log_notifier() at VM teardown. Sean's own
assessment in the commit is that it is "all but impossible to trigger".
I'd treat it as low priority and mention it only for completeness.

Guest crashes on the Milan host: Joris de Vries reported on kvm@
(2026-09-03, in the 26505e1b5b54 thread, Message-ID
<E6439A7D-77EA-475D-BEBC-6BB6EDA10A0C@gmail.com>) that on Zen3 (Ryzen
5900X, also on v7.3-rc1) guests take reserved-bit page faults from a
stale guest page-walk-cache entry. It happens after a 2 MiB-aligned
guest mapping is torn down and its table reused. No KVM-side
invalidation fixed it, but npt=0 did. That is guest-internal and
independent of host INVLPGB, so it can't explain host corruption. It
could be relevant to the guest crashes during migration on Milan. I
have not looked into it beyond reading the report.


Verified versus inferred
========================

Verified, from the code in the stable trees, the two oopses and the
cited threads:

- Both oopses read the same word as a dentry_hashtable bucket head on
  the first loop iteration.
- dentry_hashtable is boot-time memblock memory that is never freed.
- 6.18.53 contains the complete CPA fix series, and it crashed.
- The INVLPGB code is identical in 6.18.15, 6.18.44 and 6.18.53. I
  found no kernel-side ordering hole. TLBSYNC precedes every free.
- tlbi= exists from 6.18.45 and only "ipi" does anything.
  clearcpuid=419 works on 6.18.15, 6.18.44 and 6.18.53, and
  clearcpuid=invlpgb works on none of them. INVLPGB never shows in
  /proc/cpuinfo on 6.18.
- 44126343d58c is missing from 6.18.15, so nopcid is unsafe there.
- KVM never issues INVLPGB. The INVLPGA path can only reach guest
  memory.
- AVIC defaults to on for Zen4+ since v6.18-rc1.
- The INVLPGB stale-TLB issue is publicly reproduced and acknowledged
  on Zen5, with no kernel fix yet. This is as reported in the lore
  thread, not something I reproduced.

Inferred, not demonstrated:

- That the Zen5 issue exists on Zen3 and Zen4.
- That it is the cause here.
- The paging-structure route to the dentry table.
- That the word comes from Windows guest page tables.
- That the first host is Genoa. The board is SP5, so it could be Turin.
- The crash 2 bucket address. It assumes RDX is the table base, as in
  crash 1.


Ruled out
=========

- CPA collapse race (41d88484c71c and its fixes): crash 2 is on
  6.18.53, which has every fix.

- KVM SVM INVLPGA (26505e1b5b54): it only reaches guest memory. It is
  still worth backporting for Windows guests (above).

- Host mm writing a swap or migration PTE through a stale pointer: the
  first host has no swap, and an audit of every non-present PTE store
  site found nothing.

- KVM NPT level or pfn errors, and TDP MMU huge page recovery: KVM can
  only map PFNs that the host page tables hold, and the memblock table
  is not one of them.

- THP and NUMA balancing: both were off on the Milan host (THP
  "never", numa_balancing 0), and it still crashed.

- 55ddbc2ca6d5 (upstream f7491d7c81db, pmd_modify() dropping
  _PAGE_DIRTY): this causes data loss, not a stray write. It is fixed
  in 6.18.53.

- d053eb7e09e1 (upstream 1e75a8255f11, AMD IOMMU completion wait):
  this has been in the tree since 6.18.42, and 6.18.15 crashed too.

- EFER.TCE (enabled since 6.15) versus pud_free_pmd_page() flushing
  only one page: this is a structural hole, independent of INVLPGB.
  However, it is only reachable through a >= 1 GiB ioremap, which is
  unlikely on these hosts. clearcpuid=tce would rule it out if needed.


What would help most
====================

1. Boot production with tlbi=ipi (6.18.45+) or clearcpuid=419 (6.18.15
   and 6.18.44). Check that it took with x86_capability[13], not with
   /proc/cpuinfo.

2. Run Matt's reproducer on a drained Milan host and a drained Genoa
   host, with and without tlbi=ipi, and post the result to the INVLPGB
   thread.

3. Send the CPU model and microcode for every affected host, including
   the first crash host and nrbphav4a.

4. From the 6.18.53 vmcore: the whole-page dump around the bucket, the
   two searches for the word, the masked referrer search and the
   global ASID state (above).

5. Send the kvm_amd parameters for both crash hosts, tell us which
   guest OSes run on the Milan host, and whether the Windows guests use
   VBS.

--gcvq56525zjfayut--

