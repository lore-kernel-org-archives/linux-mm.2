Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC6AE606D816
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TJ6Ch8a2
Received: by kanga.kvack.org (Postfix)
	id EE94E6B05BB; Sat,  7 Nov 2026 19:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E736D6B05BC; Sat,  7 Nov 2026 19:44:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA06F6B05BD; Sat,  7 Nov 2026 19:44:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 920FC6B05BB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2707D1403E0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:07 +0000 (UTC)
X-FDA: 85410104934.25.E2B7C19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7DFE920002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJ6Ch8a2;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098645;
	b=m0XoBdAv4WnPkOb/3X64McZvNW0Q5Yi1X2vQhhes5VPLySzCaDkwIg4KI6adyJ1NTW85YH
	tlleF+FS4+ExVWIPilhspBpqq0HgSY2oSw+Ta4o56LasqAygtzEV4U60PSz/i6oYXcYstK
	53nM3/Fj558r2mTls6NEw12SpLh1+/E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TJ6Ch8a2;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098645;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPYv4Lm2lHfwZGyOll642ASLShdeptYnNbr9dmQu7GQ=;
	b=ioui+K5/poCEVmFDPrPW6afL2/1cnyDP2DHcpDCxljtdsCXuCsQ4zQ4/DN1g31QKZsdygZ
	jHfEp0RhFGvXF5TVqrRtFvIxQLJ6vTZCkM6Skrzld7SEFVGIsMeETAupIUzP3+h/Vchl6W
	J9htIEiPlpmJoGTmrvbWgIi9fJ6dnRo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEC6741131;
	Sun,  8 Nov 2026 00:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0F51F008A1;
	Sun,  8 Nov 2026 00:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098644;
	bh=fPYv4Lm2lHfwZGyOll642ASLShdeptYnNbr9dmQu7GQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TJ6Ch8a2TWqNB4cnUPhWbetuR/LO3WVXdHo2yWxHEVsaSwD6MBOwBaDFtOX3MNQz4
	 P5/okLw+luz/Y2IP7wb7eh3BVqk1oQHr8p3+SCea6YLlkq4X82iAacZV8hhTS8sf49
	 vzWAhl7lsS5g0AcOq+tkXK+zzD6qfy18ziZy7ts2EWcp/doWKYumQA0BZgJJi9io7U
	 S3Lt53h32K7xvL8KH+hsaLIYbPheJb6Grg6bRie7VM4K0G39ys7C0laLurPOT/ON7D
	 bOxA6UnGpKR5NbHDZ5ZAOi9A3qsaOZB8R1FWMPuqgJ/h1lEzfyCCtla2uY2qKMaomc
	 LPE+Rn6WSWOGg==
Message-ID: <sashiko-outbox-203439@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 28/88] KVM: guest_memfd: Support reporting PFN
 attributes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-28-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-28-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:03 +0000
X-Stat-Signature: u8hwxrhkbs14tthabfb4aqmep91emqpr
X-Rspamd-Queue-Id: 7DFE920002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794098645-486409
X-HE-Meta: U2FsdGVkX18ZTw5JpQvL9YJR68M8InNMRACF5bAfARG8FDxHYOQB7zvL0g03YDJuE5ObuoF6WJbZmKyriKrJrjQSKFdtkJ87XupM5Z1qjxTsz8AcmBwM4aYmowv6eIZvevVu4UYGcb2spVDCEONSAz5Nkqjd9MThYZogPx9iuVLeDkxcfGLLJt63VR99vCsia81sfiDaLoDe5SZh/36cjvbSfYPvHtQKxbIVJYpV7J5yS5B1kL6S1bXaQKzk6DntdFirbHGBvQwhnr3E49cz7dIUaAbqM57cbYIPewKOsvxJWEEuTzAm4UveCcym63fdcDq6WSV4iLOgLcQZYXtsR6zChW+SKWPrdimYdSNV2482/IsignCfLVR/26IXtMdXIK1fIpy6C1kadjZ2T8kt7UTObZlL0gf9Tr4z4s5U0DKzxxxaKdiv38LiabUd8TAE4zqGSJ99pRIiZ+Q9vOTeuK7tHNbzXqPAqmE0fsvrSMcGCsbkSkWgD38jKKwDzmZSmdrdbr03nZrTEF5/t+GtaKPxhjGvmFYGUBAmlg1BHPtslTlkbUYEWsnMHWH4HgVfAQ7vUXE3o6PqHeRLFubU0dnOJebxLDPoFvsace9hx3GiqrnkOl3e0wOGtq4qEsjYqA6JE5153EK67n/dGNFf+Xkv3miXowqstRV2FDBs31fmfe+lHI9vA/VwB1/NjYxkmW/YLWJWT7i6DNNntSoQaKHExnvzGGMm2RmLe4qlFgITCUpsD4asiDarGIonhn/3BPxjsE8ZVvWEg8NCA4g+BrKkfC7w7Z/x7vBcqjFEoP02n5WtHT3ZIaFfsWstNLzk3kcdzCS5qMSmHMpQt1SOgD6URFyED+9goP4gzLJ4N+oDkoENa6YCnoJmujiODrczJLk0FIUh3LWppSmokXAqOf0/8sWRugg8IZgbdVx5Guqqv1Ojjs05uO3/JUMiCkEtSM/CPXN8xspM7E7F/gU
 dKOKKUPE
 MjUI4aKa2KBXzXYtqzNA9PWogOxAvNV1c5jHSZ2gX7HcwgxFQMKoJjnbpuIshPGLO8IoKSD4+3MYFD8dcSwLJ58EnTZKS9QyvxAV2TRpEKwSkRRqqjO7GIRMyI+hTkIxvKyE3QdZFQ3tNiL4ojCx/oIKt8fCa7FXtiHNxfookvmIfJ4MCbun+Er72ga8xX9N9CvEolWfbWPVaG00OpkjYWF6NPQanTNfntqFv6po9Xb54t7hA/Q9vrnGFIGBmdMuOFw9X0W1upBmzbJ4OMQzT8SqXQYmM0v45Sl7euHkwIF4bFcYjEaZfX6aKnb3SEeSf3GYn3Qtn77CZOCGMerhISkMisySjU7mtLRDY1iMjkn9uE21ojdJPQet8smo9ga9sdGdeMekdaZEpeJXMzEUS8f5WcgIP2xZ/vFL9bPntwBSirhTwDL124ynYlj10ZePpeGpGEooEInSWF3uAuJm4RB19jEu4g8QgEtlrD6f8BNHERBlNmLRB+blUxpwiqgclTrmdJi5hzslhgeiPW2bHzV1UscFuQ9L+xs4gI5Y8bdJ3+eWM6SNstrnGaPWkwHAtobXJNYxjBV25VT5ZD8rtE1UgnKbx44xslRR1ZYBte4kuW7xzasrYmYRPTud8LRrXNoofuo0gbY6YDPltTW/Qz465t0rdN7WV+GQ1d7jlWTqxVXBFIeLd1+yD/x3uTyaApV1Iguu+Q2p3DV2swCOnDolG0a+2WaWhPao+shLz2BXTTG1ld1uyTeT6xiqBJeY7Il56y3Ti4HoIRYatdK+xcy0B/cr+Ybr0yw45c8At3GQJ+p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] KVM: arm64: gmem_abort() exits on L2 write when L1 S2 is
  read-only
- [Low] KVM: arm64: nv: unresolved TODO comment in kvm_translate_vncr()
- [Low] KVM: SVM: shadowed read-only PFN check in sev_handle_rmp_fault()
- [Low] KVM: arm64: nv: unaligned GPA passed with PAGE_SIZE in
  kvm_translate_vncr()
--

commit 0c51d556213ce4b6cb7adb6d1befd0cf237a2240
Author: Fred Griffoul <fgriffo@amazon.co.uk>

KVM: guest_memfd: Support reporting PFN attributes

This commit adds a pfn_attrs output parameter to kvm_gmem_get_pfn() and
__kvm_gmem_get_pfn(), defines GUEST_MEMFD_PFN_ATTRS_READONLY, and
handles read-only guest_memfd frames across x86 and arm64 fault paths.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 705f6d84770e9..8f0217185973c 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -1773,18 +1775,21 @@ static int gmem_abort(const struct kvm_s2_fault_d=
esc *s2fd,
>  	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
>  	smp_rmb();
> =20
> -	ret =3D kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, =
NULL);
> -	if (ret) {
> +	ret =3D kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, =
NULL,
> +			       &pfn_attrs);
> +	writable =3D !(s2fd->memslot->flags & KVM_MEM_READONLY) &&
> +		   !(pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY);
> +	if (ret || (write_fault && !writable)) {
>  		/* If result is non-NULL this is a synthetic fault. */
>  		if (!result)
>  			kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(canonical_gfn),
>  						      s2vi.vma_pagesize, write_fault, exec_fault,
>  						      false);
>  		kfree(mapping);
> -		return ret;
> +		return ret ?: -EFAULT;
>  	}

[Severity: Medium]
When L2 writes to an unmapped shadow Stage-2 IPA that L1 mapped
read-only in its own Stage-2 page tables, kvm_s2_handle_perm_fault()
returns 0 on the initial translation fault so that gmem_abort() installs
a read-only shadow Stage-2 PTE and the retried write traps as a
permission fault to be forwarded to L1:

arch/arm64/kvm/nested.c:kvm_s2_handle_perm_fault() {
	if (!kvm_vcpu_trap_is_permission_fault(vcpu))
		return 0;
    ...
}

Does checking (write_fault && !writable) without checking whether
s2fd->nested permits writes cause gmem_abort() to exit to L0 userspace
with KVM_EXIT_MEMORY_FAULT instead of installing the read-only shadow
Stage-2 mapping when the backing PFN has GUEST_MEMFD_PFN_ATTRS_READONLY
set?  Checking (!s2fd->nested || kvm_s2_trans_writable(s2fd->nested))
here would let the read-only shadow mapping be installed so the Stage-2
permission fault is delivered to L1.

[ ... ]

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 4d83281a7a28b..4519e92d89d66 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1615,14 +1615,24 @@ static int kvm_translate_vncr(struct kvm_vcpu *vc=
pu, bool *is_gmem)
>  			return -EFAULT;
>  		}
>  	} else {
> -		ret =3D kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL);
> +		u64 pfn_attrs;
> +
> +		ret =3D kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL,
> +				       &pfn_attrs);
>  		if (ret) {
>  			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
>  					      write_fault, false, false);
>  			return ret;
>  		}
> =20
> -		writable =3D !(memslot->flags & KVM_MEM_READONLY);
> +		writable =3D !(memslot->flags & KVM_MEM_READONLY) &&
> +			   !(pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY);
> +		/* TODO: Explain why vt->wr.pw needs to be checked. */

[Severity: Low]
This isn't a bug, but this placeholder TODO comment was left in place
instead of explaining that !vt->wr.pw must return 0 so
kvm_handle_vncr_abort() injects a stage-1 permission fault into the
guest via handle_vncr_perm() rather than exiting to host userspace.

> +		if (write_fault && vt->wr.pw && !writable) {
> +			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
> +						      true, false, false);
> +			return -EFAULT;
> +		}
>  	}

[Severity: Low]
VNCR_EL2 and vt->wr.pa are 4KB-aligned regardless of the host page size.
On a 16KB or 64KB page size host, does passing vt->wr.pa with PAGE_SIZE
to kvm_prepare_memory_fault_exit() report an unaligned GPA range
[vt->wr.pa, vt->wr.pa + PAGE_SIZE) that straddles into gfn + 1 instead
of gfn_to_gpa(gfn)?

[ ... ]

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6427db390b1cd..5e37ea4bc7937 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
[ ... ]
> @@ -5092,13 +5097,19 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, =
gpa_t gpa, u64 error_code)
>  	mmu_seq =3D kvm->mmu_invalidate_seq;
>  	smp_rmb();
> =20
> -	ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
> +	ret =3D kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order, &pfn_attrs);
>  	if (ret) {
>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for pr=
ivate GPA 0x%llx\n",
>  				    gpa);
>  		return;
>  	}
> =20
> +	if (pfn_attrs & GUEST_MEMFD_PFN_ATTRS_READONLY) {
> +		pr_warn_ratelimited("SEV: Unexpected RMP fault, read-only backing page=
 for GPA 0x%llx\n",
> +				    gpa);
> +		return;
> +	}

[Severity: Low]
Can this GUEST_MEMFD_PFN_ATTRS_READONLY check be reached for a private
GPA?  In kvm_gmem_get_pfn(), a private page with
GUEST_MEMFD_PFN_ATTRS_READONLY set already fails with -EFAULT, so the
if (ret) branch above catches it first and logs "no backing page for
private GPA" instead of "read-only backing page".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D28

