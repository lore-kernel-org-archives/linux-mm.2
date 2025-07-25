Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85080C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28ACB6B008C; Fri, 25 Jul 2025 13:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B476B0093; Fri, 25 Jul 2025 13:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A876B0095; Fri, 25 Jul 2025 13:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F04636B008C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:13:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BB0880879
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:13:38 +0000 (UTC)
X-FDA: 83703433716.23.FBE4EDA
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id B98F5C0012
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:13:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MEXFY5Vs;
	spf=pass (imf10.hostedemail.com: domain of 3P7uDaAYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3P7uDaAYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753463616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+f8ECMzvMCzX3pnQxw0jQaX7GgUHjg6TEwrbmrTx8k=;
	b=0RqsIHtPDGYvxqNZou1eKmgnR0tqyYtNadctJ24DrB2jJnIofA3Jz0HrD4rInIJDiKn4Ur
	5FJ05l6zl1dHuHWD5RuNYKn2AWmZh1NA8L40HW1z8jLnl+gGXjP5QwFTzu+zUGzTvmjM49
	SUc8+xyDfg1pYDxQzPCkXbBQIESTAn4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753463616; a=rsa-sha256;
	cv=none;
	b=TwZBlc/pS0zJu1kec7E4knjdGASGLxHWSMsA8DgwRshta3eBc7SbI0PZoNBDN+oLW+g71X
	FXMPsVNkWRAh9mleXRsLNY10DmtABd4PSHP8QJDFLzY0BWuc8IUTUWew0qq2gg+0kRUAVE
	OMexupfaGHFJo+EZVIjrBnUT/Y8fwUg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MEXFY5Vs;
	spf=pass (imf10.hostedemail.com: domain of 3P7uDaAYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3P7uDaAYKCBA8uq3zsw44w1u.s421y3AD-220Bqs0.47w@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c36d3f884so1830241a12.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753463615; x=1754068415; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E+f8ECMzvMCzX3pnQxw0jQaX7GgUHjg6TEwrbmrTx8k=;
        b=MEXFY5VsCTvmwKKergsXhn/uKhr6pCb5K09HZGm+/HxMypzlyHH7bnt6eDRihq1m6d
         zhU8gIZAAtb9+MoAFZtUnGFRAJxEkw6PB1esjlNb2RiPsd8JgnplUPHC5vvhfxwEmy6K
         QMbpeGC5DGVKlhPLp+DQTnx4jqnzZgSlh9C3yAvH+qnxGA8T2XwqHkWd5uMxBB0ArXqo
         dbDj5LMBTIUyahKM7fIk7oo0F4Xe64ZMhiawNsTkTgQliRugO/rYtVmjCF7LCBtobmW3
         66i+OpIhBFLffoVLec/JYyxkAM9LxeucHzWs/uJqLgTd90gjTWokmFuK/t+8FQ6Deysz
         TZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753463615; x=1754068415;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E+f8ECMzvMCzX3pnQxw0jQaX7GgUHjg6TEwrbmrTx8k=;
        b=EqvFcbGBsemZEKqXCwNrWvS37XMCrU20/BmIMfuk0o9HNO3nzKiBuyFAL9jDbVL7BD
         0DjdEIeQ5nKoeakSFMD5IyequPzEB95N09/H1WIO9oitwVAzmDvU+1+zk/ggAKSgjO4N
         HB2fKrgHJbijQilyFTrL8BE9ceGIeQ6NboIJ8dYyqoKyLtIsjN4YYUTvqlWh0BNf0G05
         WfckU2hr5tLvgYFu4yamkArWuDMdmM5VXiGFDIiO8D1MwH1mak+2WYD87IsHtsmtEQRJ
         6T03e2Ru0k42CzCCVf+/MocvDOALUSgNwynURSCFSmW6TV72bEEUlO8FWDiLZlTQyNHW
         K7sA==
X-Forwarded-Encrypted: i=1; AJvYcCUPwEXVFen/4ff4FJuLPu+PwaQeFrvx+2i74Y7sxMHMn7o8a3YUPYz9IpO5YlSmvwrAbdg3i+5D5g==@kvack.org
X-Gm-Message-State: AOJu0Yx2eOS+t2pfeM11ij2AMzWbnlcAq7wHGrw7dv42Cn7GOiz5fX1Q
	bgA8Xyzwbg6jR852AGjhLWtV29ME3ndF9BVCEkB9nOOh5nBb+e3Ec3TaA0Z6m+2LiUEDJ54AoFg
	tMO5lYA==
X-Google-Smtp-Source: AGHT+IEe50hQ5xJZE2cI6F06MC+m3pDOUnz2melqMbGj2/g8RniMBVJGng2MMVfHIVNM11FIsL6B6vGVcrc=
X-Received: from pgbfq25.prod.google.com ([2002:a05:6a02:2999:b0:b31:dbad:8412])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:42a3:b0:234:c6a0:8a0f
 with SMTP id adf61e73a8af0-23d701cd8b5mr4246329637.41.1753463615402; Fri, 25
 Jul 2025 10:13:35 -0700 (PDT)
Date: Fri, 25 Jul 2025 10:13:33 -0700
In-Reply-To: <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIO7PRBzpFqk8D13@google.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B98F5C0012
X-Stat-Signature: 9f5hupxshoh1dpfopjruttq7jpqinxso
X-Rspam-User: 
X-HE-Tag: 1753463616-772739
X-HE-Meta: U2FsdGVkX1+BTTblJamXcLwYdB6mQCYwd7M9Q3bnX+mp9kUWDP2FMhtPMRncZc3yJ5ToExX20lr12OB9LINIRbn7NcBJnio02/yx0Oc+cmExwP57YhaFjR0Na9GpcS/o1eEQpeBk55OZp33Bq/puo21+KJJ3Qd437yI+/LneYdHS/rfUFYLnD0JZbcXvf2ig7o6PNWdvXYNyiJxNHqbXu1zCjeb48EHJGs60F/MGChoqJOPWIgAL2lwvMWJZotqskTVlUFgiKLe8Oto4BDS9yjvnW2amGAk4Nu5UDJE9ix91PqhfcW1fu731tnNvTD21ZZlEpDzpXpnMGb5UnXrnj4HjG2Goiyl/s4xCyGGFoN/0dfQUsLX1bT4GqQCZpBsw+WQbFvTFfO6JLXuxht8XqUoYQHnjYD9pGoGbA5rNQViO5wL1xeUQcM7u4HVYDaMfUlsb4xzPWswRL8K3LxeNYyzZUvW7Qp4RaJLoWjj/EvJX6MXr24Lj7v4AJOm28fI+a9C5bDruw3cUqUVHw5SZjle9DcFu+wfPilJ0qVXp3cDsSTqOjcPdfcbllDeqNF3b5noG4KN+G4VFeV+tGQUXM5XhogDoUO5x82F3awsonV25EHucJJUYfMzdbYY9CsAvIVO07t8P2w/KRrcO1i5XkKH+54ufm3aw89JuN6XrZgepbyvhIWroWACD+l+naakE0gXeNIeyB3y+IqvSpiBBq1Zk3+VLxFHMgpOVhHlLQV71XMYSOq0zRgvH5ACNiQUJVFdvrWNrDJv2c5v8hPtKC3QKv9i4GhPdRA59LN5UZ3MJrujDXt0SUvNpVeoPAp0o75lsKoZb/i4fYVngUknQnOzah/HMMabgvpWkdQjkkw7+Z/0qzRufFYgFCswE99FL1dFWfcSfayVwVCjHOgmwPt3ujKEF/Zi8kVr2+ricBD0f2jVekpdashcQaX/oZx+ziRuj8nkeZgJX07k4tTg
 5+5n7PtO
 fuLPKzKXF1EJcSxzu53nyl1a4A5BWBkXu7rKgnO5O/umihfprRzR/BMAol5/ld2UAmhPoat6lP+W/uFGV5zKzluG1qhc8as5CLgd4V3xsfbGpRIKi/n21dwFK+WizE8tchzhVprHY4K8VpkCgzY3/42NDtHjlu26/M6PIQtIuUQ1lFX98dE2zRapXLIk002/i5+lsUZvEMpv1ZIY7RZvldX+2VRC+NlSmqfHw6fhnV8omwGcTWwJhNGUb700nbqcWptBgnJu7/GrZviCGUXAsi8TFafomXpWAPQI0mIlT8O9tSm+I3nQNNcaxXyOLCIrBwbQfogyWT5CTqdKYecs/x0HlrimNmhfaJjurpjvvk54SW6JUj5DBNzWo5PdIdhWe74EiBHxJaQu1sn19YpCsT7NVlXnEmK3OW8AUtozURNsEseeiHNjxEIV+EJEqX7QFVPpBgbYmFGKAmD0iIzmpWUH5tkbd0YArYEmCuql5+SmvfX3w3v36qJJWOTsnudLJkhcWvhhTmVHR/S19F7tTW7KS/atYoHp/Im79A17P40w071wUBupnJ0nAuOYYUlz384P/UFHe+b6oURQeUoHUKMxY0GAbGfXbrVGj9d3gKsZLuhDjA206hJfGLlnpYGb8CH6I+u6Ylhn/mHJt7w+Jnh+psfqrS5LTL5kCe/S5tjHKIrnp9AWvIcNSqwWGny7uPEbU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > On Thu, Jul 24, 2025, Ackerley Tng wrote:
> >> Fuad Tabba <tabba@google.com> writes:
> >> >  int kvm_mmu_max_mapping_level(struct kvm *kvm, struct kvm_page_faul=
t *fault,
> >> > @@ -3362,8 +3371,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,=
 struct kvm_page_fault *fault,
> >> >  	if (max_level =3D=3D PG_LEVEL_4K)
> >> >  		return PG_LEVEL_4K;
> >> > =20
> >> > -	if (is_private)
> >> > -		host_level =3D kvm_max_private_mapping_level(kvm, fault, slot, gf=
n);
> >> > +	if (is_private || kvm_memslot_is_gmem_only(slot))
> >> > +		host_level =3D kvm_gmem_max_mapping_level(kvm, fault, slot, gfn,
> >> > +							is_private);
> >> >  	else
> >> >  		host_level =3D host_pfn_mapping_level(kvm, gfn, slot);
> >>=20
> >> No change required now, would like to point out that in this change
> >> there's a bit of an assumption if kvm_memslot_is_gmem_only(), even for
> >> shared pages, guest_memfd will be the only source of truth.
> >
> > It's not an assumption, it's a hard requirement.
> >
> >> This holds now because shared pages are always split to 4K, but if
> >> shared pages become larger, might mapping in the host actually turn ou=
t
> >> to be smaller?
> >
> > Yes, the host userspace mappens could be smaller, and supporting that s=
cenario is
> > very explicitly one of the design goals of guest_memfd.  From commit a7=
800aa80ea4
> > ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing me=
mory"):
> >
> >  : A guest-first memory subsystem allows for optimizations and enhancem=
ents
> >  : that are kludgy or outright infeasible to implement/support in a gen=
eric
> >  : memory subsystem.  With guest_memfd, guest protections and mapping s=
izes
> >  : are fully decoupled from host userspace mappings.   E.g. KVM current=
ly
> >  : doesn't support mapping memory as writable in the guest without it a=
lso
> >  : being writable in host userspace, as KVM's ABI uses VMA protections =
to
> >  : define the allow guest protection.  Userspace can fudge this by
> >  : establishing two mappings, a writable mapping for the guest and read=
able
> >  : one for itself, but that=E2=80=99s suboptimal on multiple fronts.
> >  :=20
> >  : Similarly, KVM currently requires the guest mapping size to be a str=
ict
> >  : subset of the host userspace mapping size, e.g. KVM doesn=E2=80=99t =
support
> >  : creating a 1GiB guest mapping unless userspace also has a 1GiB guest
> >  : mapping.  Decoupling the mappings sizes would allow userspace to pre=
cisely
> >  : map only what is needed without impacting guest performance, e.g. to
> >  : harden against unintentional accesses to guest memory.
>=20
> Let me try to understand this better. If/when guest_memfd supports
> larger folios for shared pages, and guest_memfd returns a 2M folio from
> kvm_gmem_fault_shared(), can the mapping in host userspace turn out
> to be 4K?

It can be 2M, 4K, or none.

> If that happens, should kvm_gmem_max_mapping_level() return 4K for a
> memslot with kvm_memslot_is_gmem_only() =3D=3D true?

No.

> The above code would skip host_pfn_mapping_level() and return just what
> guest_memfd reports, which is 2M.

Yes.

> Or do you mean that guest_memfd will be the source of truth in that it
> must also know/control, in the above scenario, that the host mapping is
> also 2M?

No.  The userspace mapping, _if_ there is one, is completely irrelevant.  T=
he
entire point of guest_memfd is eliminate the requirement that memory be map=
ped
into host userspace in order for that memory to be mapped into the guest.

Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wro=
ng, as
KVM will not verify slot->userspace_addr actually points at the (same) gues=
t_memfd
instance.

To demonstrate, this must pass (and does once "KVM: x86/mmu: Handle guest p=
age
faults for guest_memfd with shared memory" is added back).

---
 .../testing/selftests/kvm/guest_memfd_test.c  | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c
index 088053d5f0f5..b86bf89a71e0 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -13,6 +13,7 @@
=20
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <linux/sizes.h>
 #include <setjmp.h>
 #include <signal.h>
 #include <sys/mman.h>
@@ -21,6 +22,7 @@
=20
 #include "kvm_util.h"
 #include "test_util.h"
+#include "ucall_common.h"
=20
 static void test_file_read_write(int fd)
 {
@@ -298,6 +300,66 @@ static void test_guest_memfd(unsigned long vm_type)
 	kvm_vm_free(vm);
 }
=20
+static void guest_code(uint8_t *mem, uint64_t size)
+{
+	size_t i;
+
+	for (i =3D 0; i < size; i++)
+		__GUEST_ASSERT(mem[i] =3D=3D 0xaa,
+			       "Guest expected 0xaa at offset %lu, got 0x%x", i, mem[i]);
+
+	memset(mem, 0xff, size);
+	GUEST_DONE();
+}
+
+static void test_guest_memfd_guest(void)
+{
+	/*
+	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
+	 * the guest's code, stack, and page tables, and low memory contains
+	 * the PCI hole and other MMIO regions that need to be avoided.
+	 */
+	const uint64_t gpa =3D SZ_4G;
+	const int slot =3D 1;
+
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint8_t *mem;
+	size_t size;
+	int fd, i;
+
+	if (!kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+		return;
+
+	vm =3D __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_=
code);
+
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP),
+		    "Default VM type should always support guest_memfd mmap()");
+
+	size =3D vm->page_size;
+	fd =3D vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL=
, fd, 0);
+
+	mem =3D mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() on guest_memfd failed");
+	memset(mem, 0xaa, size);
+	munmap(mem, size);
+
+	virt_pg_map(vm, gpa, gpa);
+	vcpu_args_set(vcpu, 2, gpa, size);
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	mem =3D mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem !=3D MAP_FAILED, "mmap() on guest_memfd failed");
+	for (i =3D 0; i < size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xff);
+
+	close(fd);
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long vm_types, vm_type;
@@ -314,4 +376,6 @@ int main(int argc, char *argv[])
=20
 	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
 		test_guest_memfd(vm_type);
+
+	test_guest_memfd_guest();
 }

base-commit: 9a82b11560044839b10b1fb83ff230d9a88785b8
--=20

