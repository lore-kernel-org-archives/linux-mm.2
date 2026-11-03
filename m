Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06EB1606BA14
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YIbN6ewn
Received: by kanga.kvack.org (Postfix)
	id 2F2F66B05C1; Tue,  3 Nov 2026 10:03:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9ED6B05C3; Tue,  3 Nov 2026 10:03:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0F86B05C4; Tue,  3 Nov 2026 10:03:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00AF96B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:03:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ECA0C048F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:03:36 +0000 (UTC)
X-FDA: 85394126832.07.53B0435
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf06.hostedemail.com (Postfix) with ESMTP id B25FC180010
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:03:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YIbN6ewn;
	spf=pass (imf06.hostedemail.com: domain of 3xffpagYKCLoxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3xffpagYKCLoxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793718214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1cgiMD/xdrAAoWIqAxeQiqT29OTjecADPn89igAbnA=;
	b=cHPg7NfntRO5RVQw1XWtQlvoDW4YnfwyICkVJLEA0ANGeyPwzW9wcC9pmhI/s1Yle8o7+0
	YevleBPgHahHGLOf4531xzpIWbrPBi1HPjsf9SBB5hAIBokQb+d8wsz8z6ltMcUVnG+uGa
	IDszK72qtRmdsbR39R0r6ENUNf8YKsc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793718214;
	b=6YXD782kGOcUbLQiqNRDY9r82gTKwb1oetcA4r8FJzQGn4vnLKDqCG81R0iu4KnTfuKzLb
	iXClYDX+BlrztwG/+BIrkA58VX4GTRO/pTupAWwlM+C8wVVjJCHUdqMMBLELz1tgsJYldt
	I/pE/sQM4NelwA5GOsHYC3z3dWbK1CY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=YIbN6ewn;
	spf=pass (imf06.hostedemail.com: domain of 3xffpagYKCLoxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3xffpagYKCLoxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae6fda7a00so3831824a91.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793718213; x=1794323013; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=U1cgiMD/xdrAAoWIqAxeQiqT29OTjecADPn89igAbnA=;
        b=YIbN6ewnZ9Dj4xQt9CnwX7Suw6x9a351q2rm2y8dRvpyYUi7QPRaNIaJD2cvxEqW3V
         FZLvjrTOeTa3O7ukqixdKBANvDihILBU8N0qmqDiFmNklj+vCGQPbz+8DY/t1oVCQB7y
         R3Bp6h+vlt7WNbpLV7Yh31INTfeyOW4j8XOL59MwMeOiaHFIHTtYl7pFuuqVCuN13pDj
         6cEdlr1oE9qMINx68lPFarWBVuC7IAGeEVneVK3qUpAO5vZjpROavAzZklxwu47rPrrp
         kfvniR9rSDuM7YLN7/2mFMBlx+POLdR0Q58Rl6ab5OhhaEKrHXANkTCBUDXWrXIqmlBx
         s+AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718213; x=1794323013;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U1cgiMD/xdrAAoWIqAxeQiqT29OTjecADPn89igAbnA=;
        b=NIzXZ3A2MMK1z023AsJbEWnvfOARzEGAqsYVlQLNRhPxa9u8CjycAfixSOEMh/Yssk
         SqpCG1v6GaYu+PONhOy+kAxQHpSaHVvKiCWJ7LIZGoVHlnXw0fMXFMa5dBDLHraoW/q3
         0ca0s/W5J4XPUWctgOoeX4PIgybrFZEH6fvmobnS1onw5ijmXknxDrSY88NoIT57PnUe
         kpzBsY1WjOndq7Fe/j7LLKhe9Ao2JmTr/dsYDNEMLkbq/Tx5Xe2uXCdj9AT54coFdGzv
         8HWRgl6Cz78he13JLUMRWSj/MifyB3z6ow8YO8sc+Ulpw/L/2TZIx+dtHo69vtPkjYrc
         6JAw==
X-Forwarded-Encrypted: i=1; AKwUvBwCXxamvPChj0SuTU8sxPirjK24G9Rb6Z55wv9uXDO2DFOaNOFXNkMO7FHRXSbdr/pvJfklm1p3Cw==@kvack.org
X-Gm-Message-State: APuU4Z/TDY2nOo6aCi4NVixDa9zRndpnqW0zuPVZAmZ4pU1e9z76m9n1
	CHiuPWUK3MckdalYz037X52xdTqAHRCLE/b3uBohBtpJBdrcJWuUtHL8rYtXaaAZlzoqfhOr5qo
	0hj8OMw==
X-Received: from pjdn32.prod.google.com ([2002:a17:90a:2ca3:b0:3a8:837d:95c7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52c5:b0:3ac:a11a:7c79
 with SMTP id 98e67ed59e1d1-3ae89776aebmr10680806a91.16.1793718213083; Tue, 03
 Nov 2026 07:03:33 -0800 (PST)
Date: Tue, 3 Nov 2026 07:03:31 -0800
In-Reply-To: <b9ed9dd4-a1d0-466b-a6cd-89a4e70abed0@suse.de>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261029143336.390231-3-clopez@suse.de> <20261029175203.5bdd51d7@p-imbrenda>
 <df9dc526-4275-4784-8a0c-2e4fa8e96402@suse.de> <20261030133939.630e29af@p-imbrenda>
 <auis0SaMkRB6odsK@google.com> <b9ed9dd4-a1d0-466b-a6cd-89a4e70abed0@suse.de>
Message-ID: <aun3w8gxwlmRy-GW@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: don't zap secondary MMU on
 permission upgrade
From: Sean Christopherson <seanjc@google.com>
To: "Carlos =?utf-8?B?TMOzcGV6?=" <clopez@suse.de>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B25FC180010
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: u5drqzujgwmz1ce777egwfbibput9p6p
X-Rspam-User: 
X-HE-Tag: 1793718214-423299
X-HE-Meta: U2FsdGVkX18VCrQPSNwpFA+w+XbYz4H/lIiLV6tuPaf2anE99bkzsYhBlrPVkgLP7qz9+ZcAujgzPzHuQoOC7oudeHPRwFlP1ex+a4Tu+mz8q/CwuD8wpqoT+N3BECUK4GpHuXMIMs0qFGInx7lXFYter7ObZAJpLvtFapAwKafKsYoxVfY+v64ag8uUCDZozt7240TvzpOv56U8/5ImjUqG9xf9AoNkHOnf0t83HL12UVJS6JWUqzODF6qDnAJmHsBs7DLB6xE+Sk/lbm1VhWP4TvHoDP+ZeYxQOQGJC+Mba6tNeAxy7XrJaOhDSNg9jhyWyV5CoiCuUxYFXjQ5kYDyeBSJfprwpqrRE+C49/mM+MdkRwyFPj6QvEITMdlPDA+WWi16CspdrASyHQ2HLOFz7XJKwvhbRgOGEzkdiqbCUYnayg6sRynyyjZ+ZK3+KegLMgf2/6rQjBuIk9vfRCkKRQc7SJFw+xcxCYDGcZPndSdN+JcZZteC/ZabzzsTAirFn/QmSqpewuLnS4BlBptSSvuGbwbvZOCTfe1X+uwTfupUG5tfCGNtjdxRwPuxKuglusuWOxAQC9HF7NvAIuMcrSyojm80yGL9oktN0tZ0DCjYI1gu1X8Kn17nRD40CeR+0C5jFhVY2pM3fWT1FeYmTfdxlrevjb4k4VWdrGfuvDh5LXcA7oCpQvLC2NisNm33NcBd+VxiS94n97KMuW2qXGlA0O9Op09PaSRQ4kRBg123MY3qhOgcBDKAKKVnrfEzV4DMMoR/x0aADKUWZ8jXOZtsH8s97vTKWDiu5+M7KROQyvIn3iYnpYgVwcu4K+/wKsf7oCRLUcUi7GdjhcAy6VuEnVvNGwsF+3EGjzkj8oNbCm0HO3f5ZZf0a5ZjJOd8YWPJdm7JoYsvpJGElvumfJwgLH1q62lnZ7HZWk1Io1K9omXf1wL4m2e7ZFwFzO5WQn7XJ9rBtno0Coy
 dMVl7e1d
 TCqY8wEYhYOmK6R5ySJyQ3Odad3xUmGDQfEwX2xQJQIfncWdUjHoL1hDL1jmQgSfmp2uRvt635g+Tqfa9Ho2tqjM8bCe+e2JnuhRrFeBhp4SjcfYhvVjvnhKEEe60FStd8J0x4uQV609ZPg8okdKNn8FDF+7i1RsyWSSU283RX1oqZzTw9aG9KOA0cY8K1I2xEtuqwYzQnU+72X5nNN39brOJdn3K9BQO5XEnXe+3HJzzEoy1A0unO3ug68HoxAU0M3//B3wYYaS2wn+Ff8Omp9zTcD0pB6Oz8QAGhZHLFYIMYlWpwoY6JcstsylaMcguP/LcOc6e6VwX8s/jkG1cSLygbFgLRgoQRL3b/tjRlXkE+NqKiamgSTdtfABX5nUnWFSjfCfzVDClMcBA66Gubrnmb33ksOGAarKTz3WjFgFJ6Yxje+foaiW4Eow/gAshL6H8KudFl9LHaT4bb6iUPVlwRUZ3b1072YX5kJl9Y9k+9oTOKuFtpHIL/frxe9WnFSZqS+r9rsnogTPuvwtb+CKD4eRWbBnc2tyNjIYzpIKwDjR9SyT5IXescEfEDBKMHTO4PErpn3cEPpPU65m9D1rYTfgDbKvcVettYbf1r/IjZMTj0GrW4M4HKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026, Carlos L=C3=B3pez wrote:
> On 11/2/26 4:31 PM, Sean Christopherson wrote:
> > On Fri, Oct 30, 2026, Claudio Imbrenda wrote:
> >> On Fri, 30 Oct 2026 12:11:07 +0100
> >> Carlos L=C3=B3pez <clopez@suse.de> wrote:
> >>
> >> [...]
> >>
> >>>> regarding this series:
> >>>>
> >>>> on x86 you don't care what the new permissions are, because you're
> >>>> updating when re-faulting (if I understood correctly). =20
> >>>
> >>> Correct.
> >>>
> >>>> for s390 it might be beneficial to know what the new permissions are=
;
> >>>> of course we could look up the vma and find out, but since you are
> >>>> already checking the permissions, maybe you can find a way to also
> >>>> convey the new permission bits?
> >>>>
> >>>> that would make our life on s390 easier :) =20
> >>>
> >>> Right, getting the new bits from vma->flags should be trivially done
> >>> from the MMU_NOTIFY_PROTECTION_VMA callsites. There'd be no users in
> >>> this series though.  The rest of architectures still need the notifie=
r to
> >>> tell them if the change is an upgrade, since they don't have an easy =
way
> >>> to grab the old RWX bits. Passing the old RWX bits from the MMU notif=
ier
> >>> does not seem trivial to me either.
> >=20
> > But why is core MM even doing mmu_notifier_invalidate_range_{start,end}=
() in the
> > first place?  I.e. why add MMU_NOTIFIER_RANGE_PERM_UPGRADE?  Just skip =
the
> > "invalidation".
>=20
> I briefly mention this in the cover letter, but in short, denying other
> users the notification seems like an overly intrusive change for KVM's
> benefit.=20

There are all of two other users:

  $ git grep -w "\.invalidate_range_start"
  drivers/gpu/drm/nouveau/nouveau_svm.c:  .invalidate_range_start =3D nouve=
au_svmm_invalidate_range_start,
  drivers/infiniband/hw/hfi1/mmu_rb.c:    .invalidate_range_start =3D mmu_n=
otifier_range_start,
  virt/kvm/kvm_main.c:    .invalidate_range_start =3D kvm_mmu_notifier_inva=
lidate_range_start,

and AFAICT neither of them wants an invalidation even for protection upgrad=
es
either.

> A flag allows users to opt in instead.
>=20
> It is also not clear to me that secondary MMUs are not relying on the
> notification in some subtle way. In fact, Sashiko points out in reply to
> patch 4 that the notification lets KVM retry the APIC access page reload
> in case userspace shoots itself in the foot by calling
> mprotect(PROT_READ) on it. This would require a really weird VMM,

s/weird/misbehaving

> as it would need to go looking for the page's address, but breaking this
> would be a "regression" nonetheless. I will address this in v2.

Nah, there's zero chance any real VMM is doing mprotect() on the APIC acces=
s page.

More importantly, doing nothing if updating the mapping fails and APICv is =
enabled
is wrong.  KVM needs to ensure vmcs.APIC_ACCESS_ADDR is fresh when running =
a vCPU
with APICv enabled, even if that means putting the vCPU into an infinite lo=
op.
VMX doesn't support "inhibiting" the APIC access page, i.e. the memslot can=
't
disappear while the VM is alive, and if userspace mucks with the VMA, then =
KVM
needs to prevent running the vCPU until the mapping is restored, irrespecti=
ve of
mmu_notifiers.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 464d6ed862d5..11b24a42e482 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6928,8 +6928,10 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *=
vcpu)
 	 * APICv is enabled, but paranoia won't hurt in this case.
 	 */
 	slot =3D id_to_memslot(slots, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT);
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+	if (WARN_ON_ONCE(!slot || slot->flags & KVM_MEMSLOT_INVALID)) {
+		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 		return;
+	}
=20
 	/*
 	 * Ensure that the mmu_notifier sequence count is read before KVM
@@ -6946,8 +6948,10 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *=
vcpu)
 	 * if APICv is permanently inhibited, i.e. the memslot won't reappear.
 	 */
 	pfn =3D __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &refcounted_p=
age);
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 		return;
+	}
=20
 	read_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))

