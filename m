Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 687EBC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306288E000E; Thu, 28 Aug 2025 05:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AEB8E0001; Thu, 28 Aug 2025 05:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB9D8E000E; Thu, 28 Aug 2025 05:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E31968E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A689713A305
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:40 +0000 (UTC)
X-FDA: 83825668920.28.7BD8A22
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf10.hostedemail.com (Postfix) with ESMTP id 356B5C0005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=q9SigCIo;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf10.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373978; a=rsa-sha256;
	cv=none;
	b=Zvoiyzpo2iYGUHK7va4NsaIIZXFlv3mgX6w+a8CW+2LJ7yENUMKZqzNyCw5Cqmlp5wsgRd
	1LspxidxKYw2XlPUOq6FL4J12Tx5D5cYNdNuAmPiFl0r20N5nBOCLUiz5isqnuIl/f7o5f
	bNiBqZg1riwBPBBN9H7X7BXNGZr6Oh0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=q9SigCIo;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf10.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41cdObRV2/ULxTOTq6Jo3VA2F7BSJFHzuhvS9zYggVk=;
	b=tVjeQCDgOCnTMIaAS7ZdxrV1lxRGokANKXDy8eFUZJVZ0OTMlks5MKs1kfrMkIXKgnorrT
	Ho2ErqD0tRRcq8rqZhvGN0YSsskqu3YJ5aoMtalJqYr9IT7oyqLvcQAmNzWCbmm2F5DCMg
	kXam8hwPsdJaDktsuVP7BHwE0uUhTxw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373978; x=1787909978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=41cdObRV2/ULxTOTq6Jo3VA2F7BSJFHzuhvS9zYggVk=;
  b=q9SigCIoiBDJKuZr9Ga2Dm4UaClIAlisv3yplSnJBKyFbw3IjV+8ob4G
   1i6lBak5grYYiE9QwtBvPEh0f9puZ/GlG26Mv4Dt/MuI2fyjO1266pgqf
   mHNGHlnob79gnol7hhdq8CBwtphvmIfv1t+jjcarmkPIfUHDxjd5CBJBi
   Asx5crLnpQOgwAC2oJ9ftVzjEuED6BRU5GtL8r46LJQcFfMew/RlUtLng
   hRvLzInTMpKsJ06pTPKLG9veLOnDCujbuS25ryKaYUsEQDreTuLQkEVel
   O19LasO3p1f/SZvtZZzLyoP5qRzE6CqOV8u4VDMDpuhwA515hWMVU0/bt
   A==;
X-CSE-ConnectionGUID: 7NHgI4b7QDW8PKjfOwUOUw==
X-CSE-MsgGUID: 07tME+q3T0KAl4VYV4WBQw==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1301820"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:31 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:11142]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.7.27:2525] with esmtp (Farcaster)
 id d179c768-560e-475d-8e59-3cb241b207a9; Thu, 28 Aug 2025 09:39:30 +0000 (UTC)
X-Farcaster-Flow-ID: d179c768-560e-475d-8e59-3cb241b207a9
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:26 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:26 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:26 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 08/12] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Topic: [PATCH v5 08/12] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Index: AQHcF/+kC3wc6YsPZk2H57V39QScZw==
Date: Thu, 28 Aug 2025 09:39:26 +0000
Message-ID: <20250828093902.2719-9-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 356B5C0005
X-Stat-Signature: hgj4biy3iwh1jxd5ohyy9doa6k6it95b
X-HE-Tag: 1756373977-425724
X-HE-Meta: U2FsdGVkX1+MklYVExlQkUuuqe/6jZYtmL+IpSGKfZykKzW+HZN3ifrl0xcEeiIJcC/wtOUdppc1jo4C/GCnqbcgjuNP/+DvLcnSHrrwnDljUsV2G2+kFMasfzlcTBO31EvPCInhhMQKoLmAG+Ty12RbNUwKOGQ7xv/6MQ2nLQBF9DgwzpSdR5rkG+2wStgj2YM72LB1RNBzBUzo31yY/2aOODOvTF0gB6sqK9q66nrlbAI+SOu/wT9nCzNTcDHJu8ikaIHMib2lTlgCblfSl2kTyygZX3OZRdTT7e80Z1jApss57BINRrP5gUiasi0qxurFW3f7MCWpnFSzchsabb3Qe2gIm6Mo5X46FHJXC99s7XcA9aKe6qNWyU2ealh3B9Vc40iJwfw25Kmc3ynQhY7Ba8HBq780JPWvk3TWcWhUJJxavi6Vr+VcmiaUC+7jcvUs+7JiD8qcS+czneFtTxHYi5WV40tqD9cixw3O5nwMnHOLkdy30dwVUauWw4yv0FVdj5DCqfjfngvPkkc9LyEHwoNviZAs0VebZm/z6Eofyur9VBISp5nOMs4SSkNCpEDGjtJg08eKsKiMFlTqaAvEdhwPgXSDnwSx6gt40zNpn8vOaLrbPo70CKZOjbHiBF3WRMshKhbnPB4Jzw9hV1nCdn1VS1hUPAwYYCvZjTQhhkYMSyGkj204QxZZ/DA9gT9QL3Pr9eFm/sPA+xA+AtvRkeh0KJsf2FiMMxvbZ0PDAJbp6cttEo0+TIWtsAxOOZgOl/7afJvpAhbxHXE/nwWMCG/kL7CT7uKINim3lGaTPrYWWVIMf6hXJn1vIrymn+ee68/iu08c2xfhTU1VQG1MiuwNzq5iXh+cHgHr7DYPBsfXpbIpRMQVjGLyGzsWCloLkQMPipf7a96rNCLTwNbqv5z2SwVJ0cNx2f7mTdbw0BdxGbsr9Lee7VtQQysogicyGTqgzu+PAZsfTeB
 MVfOP670
 i5JQfVzWXScz9hZtGVvQEHedWv9B8VMU9dFeUw2H0plAIb+0pf5PMjEOs66ktlbsT5SC+SnRBPX+ihW2gFc61G8tBBGO8MOAynq/+HfxWwjaHbF8LC4H02hHVnge/gzshyqECsrZv2v7LaLIZBqU21dXn7MqVppBrhKNIZREPmoV8UGJhbikQdLXnQceEd6F+VxROvK1pmFxLXvrucCck8UdNjz3JVZm00hE+H9uQQNTRwP9LB8JGzesx6+GzvJA2vpavm4uWVnb+6DDRmUmad2ZM1HQ+dWiEZBDnCSyr0bMyxzfVtF+OetQy2QrBKUVPTl5HYtJ/dq6MKtYvB/ssBVJbsbMj1NKHyWlZ8+0aSx9nw6Mjfh3zvR9P8yfrHO9UsUsyEEXdEBQdTSmtEidmZ3A5MI4L1CzEkZDTLbJK2JOq+lDI8AkScIdKVYhSJdt3frhqbCoNtdLC9rIcfYqgnWcQBSGfN8hf4bU5c5ZED5JsEj1hwLbpN4VcE49But9b8moCrf2e1hTTIakuH82a+8SHwFrtDWrY299PyRGbl9WbGlxd6Wtf6C0Wtf14hbuAj9ajVXH5xXAvNREtAvvt3xTppqEaqiA8N++qLJ665whU25ifWKtfbzjMnpoo61jLIKrkzcx9hYgXF3h5MRdRatY/EHGZ0LyUTnWjCAhFlReNO/0z1CsPDdwGrygQNXcofdTeny8EZ4XkaG2+zazEBGWL7Sqsd1MifyGUeKPAkvDFr/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow selftests to configure their memslots such that userspace_addr is=0A=
set to a MAP_SHARED mapping of the guest_memfd that's associated with=0A=
the memslot. This setup is the configuration for non-CoCo VMs, where all=0A=
guest memory is backed by a guest_memfd whose folios are all marked=0A=
shared, but KVM is still able to access guest memory to provide=0A=
functionality such as MMIO emulation on x86.=0A=
=0A=
Add backing types for normal guest_memfd, as well as direct map removed=0A=
guest_memfd.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 18 ++++++=0A=
 .../testing/selftests/kvm/include/test_util.h |  7 +++=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    | 63 ++++++++++---------=0A=
 tools/testing/selftests/kvm/lib/test_util.c   |  8 +++=0A=
 4 files changed, 66 insertions(+), 30 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h=0A=
index 23a506d7eca3..5204a0a18a7f 100644=0A=
--- a/tools/testing/selftests/kvm/include/kvm_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/kvm_util.h=0A=
@@ -635,6 +635,24 @@ static inline bool is_smt_on(void)=0A=
 =0A=
 void vm_create_irqchip(struct kvm_vm *vm);=0A=
 =0A=
+static inline uint32_t backing_src_guest_memfd_flags(enum vm_mem_backing_s=
rc_type t)=0A=
+{=0A=
+	uint32_t flags =3D 0;=0A=
+=0A=
+	switch (t) {=0A=
+	case VM_MEM_SRC_GUEST_MEMFD:=0A=
+		flags |=3D GUEST_MEMFD_FLAG_MMAP;=0A=
+		fallthrough;=0A=
+	case VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP:=0A=
+		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
+		break;=0A=
+	default:=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	return flags;=0A=
+}=0A=
+=0A=
 static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size=
,=0A=
 					uint64_t flags)=0A=
 {=0A=
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testin=
g/selftests/kvm/include/test_util.h=0A=
index 0409b7b96c94..a56e53fc7b39 100644=0A=
--- a/tools/testing/selftests/kvm/include/test_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/test_util.h=0A=
@@ -133,6 +133,8 @@ enum vm_mem_backing_src_type {=0A=
 	VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB,=0A=
 	VM_MEM_SRC_SHMEM,=0A=
 	VM_MEM_SRC_SHARED_HUGETLB,=0A=
+	VM_MEM_SRC_GUEST_MEMFD,=0A=
+	VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,=0A=
 	NUM_SRC_TYPES,=0A=
 };=0A=
 =0A=
@@ -165,6 +167,11 @@ static inline bool backing_src_is_shared(enum vm_mem_b=
acking_src_type t)=0A=
 	return vm_mem_backing_src_alias(t)->flag & MAP_SHARED;=0A=
 }=0A=
 =0A=
+static inline bool backing_src_is_guest_memfd(enum vm_mem_backing_src_type=
 t)=0A=
+{=0A=
+	return t =3D=3D VM_MEM_SRC_GUEST_MEMFD || t =3D=3D VM_MEM_SRC_GUEST_MEMFD=
_NO_DIRECT_MAP;=0A=
+}=0A=
+=0A=
 static inline bool backing_src_can_be_huge(enum vm_mem_backing_src_type t)=
=0A=
 {=0A=
 	return t !=3D VM_MEM_SRC_ANONYMOUS && t !=3D VM_MEM_SRC_SHMEM;=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index cc67dfecbf65..a81089f7c83f 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1060,6 +1060,34 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backi=
ng_src_type src_type,=0A=
 	alignment =3D 1;=0A=
 #endif=0A=
 =0A=
+	if (guest_memfd < 0) {=0A=
+		if ((flags & KVM_MEM_GUEST_MEMFD) || backing_src_is_guest_memfd(src_type=
)) {=0A=
+			uint32_t guest_memfd_flags =3D backing_src_guest_memfd_flags(src_type);=
=0A=
+=0A=
+			TEST_ASSERT(!guest_memfd_offset,=0A=
+				    "Offset must be zero when creating new guest_memfd");=0A=
+			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
+		}=0A=
+	} else {=0A=
+		/*=0A=
+		 * Install a unique fd for each memslot so that the fd=0A=
+		 * can be closed when the region is deleted without=0A=
+		 * needing to track if the fd is owned by the framework=0A=
+		 * or by the caller.=0A=
+		 */=0A=
+		guest_memfd =3D dup(guest_memfd);=0A=
+		TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd=
));=0A=
+	}=0A=
+=0A=
+	if (guest_memfd > 0) {=0A=
+		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
+=0A=
+		region->region.guest_memfd =3D guest_memfd;=0A=
+		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
+	} else {=0A=
+		region->region.guest_memfd =3D -1;=0A=
+	}=0A=
+=0A=
 	/*=0A=
 	 * When using THP mmap is not guaranteed to returned a hugepage aligned=
=0A=
 	 * address so we have to pad the mmap. Padding is not needed for HugeTLB=
=0A=
@@ -1075,10 +1103,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
ing_src_type src_type,=0A=
 	if (alignment > 1)=0A=
 		region->mmap_size +=3D alignment;=0A=
 =0A=
-	region->fd =3D -1;=0A=
-	if (backing_src_is_shared(src_type))=0A=
+	if (backing_src_is_guest_memfd(src_type))=0A=
+		region->fd =3D guest_memfd;=0A=
+	else if (backing_src_is_shared(src_type))=0A=
 		region->fd =3D kvm_memfd_alloc(region->mmap_size,=0A=
 					     src_type =3D=3D VM_MEM_SRC_SHARED_HUGETLB);=0A=
+	else=0A=
+		region->fd =3D -1;=0A=
 =0A=
 	region->mmap_start =3D mmap(NULL, region->mmap_size,=0A=
 				  PROT_READ | PROT_WRITE,=0A=
@@ -1106,34 +1137,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backi=
ng_src_type src_type,=0A=
 	}=0A=
 =0A=
 	region->backing_src_type =3D src_type;=0A=
-=0A=
-	if (guest_memfd < 0) {=0A=
-		if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
-			uint32_t guest_memfd_flags =3D 0;=0A=
-			TEST_ASSERT(!guest_memfd_offset,=0A=
-				    "Offset must be zero when creating new guest_memfd");=0A=
-			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
-		}=0A=
-	} else {=0A=
-		/*=0A=
-		 * Install a unique fd for each memslot so that the fd=0A=
-		 * can be closed when the region is deleted without=0A=
-		 * needing to track if the fd is owned by the framework=0A=
-		 * or by the caller.=0A=
-		 */=0A=
-		guest_memfd =3D dup(guest_memfd);=0A=
-		TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd=
));=0A=
-	}=0A=
-=0A=
-	if (guest_memfd > 0) {=0A=
-		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
-=0A=
-		region->region.guest_memfd =3D guest_memfd;=0A=
-		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-	} else {=0A=
-		region->region.guest_memfd =3D -1;=0A=
-	}=0A=
-=0A=
 	region->unused_phy_pages =3D sparsebit_alloc();=0A=
 	if (vm_arch_has_protected_memory(vm))=0A=
 		region->protected_phy_pages =3D sparsebit_alloc();=0A=
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/se=
lftests/kvm/lib/test_util.c=0A=
index 03eb99af9b8d..b2baee680083 100644=0A=
--- a/tools/testing/selftests/kvm/lib/test_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/test_util.c=0A=
@@ -299,6 +299,14 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_=
src_alias(uint32_t i)=0A=
 			 */=0A=
 			.flag =3D MAP_SHARED,=0A=
 		},=0A=
+		[VM_MEM_SRC_GUEST_MEMFD] =3D {=0A=
+			.name =3D "guest_memfd",=0A=
+			.flag =3D MAP_SHARED,=0A=
+		},=0A=
+		[VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP] =3D {=0A=
+			.name =3D "guest_memfd_no_direct_map",=0A=
+			.flag =3D MAP_SHARED,=0A=
+		}=0A=
 	};=0A=
 	_Static_assert(ARRAY_SIZE(aliases) =3D=3D NUM_SRC_TYPES,=0A=
 		       "Missing new backing src types?");=0A=
-- =0A=
2.50.1=0A=
=0A=

