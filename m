Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B37EC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66156B00D7; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8956B00D8; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6736B00DA; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3886B00D8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0CDA1C0169
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:01 +0000 (UTC)
X-FDA: 85075824162.21.EA9EF44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id F034240007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEvezCsY;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139580;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXpxwuC5E68cxw3JNmnduvC9zqf5Ae4mm2cIVBzH/UQ=;
	b=Md3KnoOulEGV5JsSTq+3ZgTMqq2A0hOrALsFBVq9gH2vrO07pC+Zn+R5On6cCqGCf/LTzv
	i3FTy7xO15HPQKD1KNb5o4qyAnmFjeo+l85R+jEM3tBbJ5qaWBMw62ggRiHszPOvaZhDU5
	m6275QKrVK44TfZDHRsR4x90vNELOTs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139580;
	b=Ct2pR2Sf1PeZli4N8Zz2f9AQ6X25KSYy/DEk4GGOpbkiXQ7e+j7zYBilWx4uvk5zrseqjR
	Ir9TzFL3FtKi+0+VuW8ZV09LZeiTCEaRdYqLPdZyjEZYZOnuGzgx/HZFD3Q+yPOV3FHHrm
	GNlL3gh9Xru9KIf+jyGaORcjm2fnJBU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEvezCsY;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60E3743FE3;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3D2F4C2BCC7;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=C5CVQyQCx6nCpVtedkg6HikJiLO1rkwgWitCM8srGsY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fEvezCsYmyZOutO3WXtcxrr8CONdjwM67HmL91GoXn1HO85SvszGj1L9gQ8EF+wEZ
	 d/Oi6N2VEb7Q3Po/iX2KeJQzIyqRJrTT3+2EPBXwNunKpTdUlrlzLQ0grDvMin3gy2
	 dMhSbclcQQj4qw6w2n31UIksGY4GRHpgUCksm7xApUEXEj8wRVBJpO9DCc5vEfKhf8
	 GnviTfbQcn7VFWH2/aEu4FMcy++InvFn1V26TgPf8FI2oekk2/Ky9IJRRcciarrpSY
	 4k/za8wiYXghgUrUmZdfRpGxAzfIfHFd/9qNQTghskNGdwZcjCqTPaE0W+9RHjKNgw
	 o87z2WXavyYkg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A3ECC5ACD4;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:04 -0700
Subject: [PATCH v10 25/41] KVM: selftests: Add selftests global for guest
 memory attributes capability
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-25-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2380;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=3GsT3Q+uzPs3OFHloNtQiW2tkzSuSXtysLhAUwWt/P8=;
 b=I33/mpDT6f2dWZmUfYdILExsu+k524V3mzokxxFBxqlwcLsoItV2gj57r9VTM33XoZcVk7IL+
 xFmO2by1pElB2bRcy5kRmrGwveZe/kWi/2LSvaPOnLbueytk2lcwrLi
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F034240007
X-Rspam-User: 
X-Stat-Signature: dri8jib51pffu3cx3i4fwjgd9zmu7wyp
X-HE-Tag: 1786139579-159492
X-HE-Meta: U2FsdGVkX1+b8BKuLyneE732Iwn04CgcT40eiPTIn+L6xG48xmVQMwdgBV3BscK9Wc/iwH5il97V27gB6bd91/sx86SAKHzgNOI00q24ehyrZu65BYQOC08WTYWbRr87jzg5o4Wjlt5Uno/VrvGTGEVmRKPWBN6zCSeQfgAc0OjqHzE8E7y5PM2NAH6wGKymVl1j5pLzid23yRKIA03g4MCE9fCodDIHb4pJDE2ggZNYhayUJMtV9sBOeJ9o3MdEraNtOZFuQaFRTGTwVFkCSBwuKs/IViKEIT6dkiHI7gSPz/+TRym1r89KAFh0oShUoyIKxxNVjzN+1ccoSVjZkX+njgFfgkoWLAmIkvyu0RyI+nQhJvZYoZRvldGNzpW541SrxPpWLFCfkRGt3KPuHN2pQ+W9nO4qVeVmWfN1Sd1PkPpgTUGc/hEmQrVBPvQC6+o9Lq4ZdpBZiAcJvtVqTsMH+zk3ViByZpfcuXKfrEj/n7ppI8PoztgetYw1rcEKWhg/HavA098Wahqpk2pP4kIl2hssIMpGCnCZZ5SE0mBBcEpDeBsPhO2K4f04cBVtKftd25/C9ShzPwCKj/0mJtxWDYAbNCMH+/KsBWDPKvz73UTo/9jR8sSlIYEj6Pkpsf2sMqFAFR81NsLPkxke1nBhHcS3eYRFhRrUYdrzmD4zuYyWoR1ncebVYudi9YUf/0+XlVXk9QCplOuhZD8YTSviJjT7QpGKp0+0JmPeZA921jIHvUnFjVG6U9XMnXiqGT49FrCf56mrTWCvTIWBw7Q+9g+pjah9p44n4oLxrN1hnId70NrSXz60DxnQebgFbneNkfDFdgPppSCSCMSuG9vzBxew4FcBBmQPgyA4XUmZepoMhdtHepgfENwgnu7xzb1Iel+NECl80HSmpRK9r3orrL4/KVgIKf6JCc3CXfF759n0H3xidnBeyeaFIkSzFkvxPEVbsrfSwbsfCiH
 7nqflL6F
 toOCYjyQoOvKmQDXIKvCEr8Q1nbOeDmEhwhI2PD+0gk79Ta7LdvuPnM/3AOGAMxIXCc7+ISwVrj4H7ch1HW/E/zEag6LtDi5ysIU37Bg64oPuEiq0O8PZ3kENGNKGWvgywpIDB8i2oJPUAL6Od2nX40oGmgE0NONfxDdb0V4YnkXuM1/gOW+sM1e+5FOAvDAfWfhPaF/8MaE+8S+m05tgIvU2IexGguK1nhnJn5Fo8jZSpB/Y/sWgbsPoBrAtQVCR7i6ow9FpyiJFnfOszhAh4biWVFXKwJCF0u3aA5+ApRRjetlmU1rtrrVmS3WRliijRgTH+Z4favHbHhdbG7xC3R5ibcOfTl23lBkqJ2AlgdtNrTGg8qKJOWYLwq0BzKmejl/xodPuJxLiUpB/iFcFGuPtRi45cP+EOQBPtWo+c9er2P4zC6OhDBD4LkAQQUDw6st6A8mqvuoBlZqF9Kd87/tuob+skB1iLTAjCVN9wU8U+4zytilqLgBWfJGOzFYau0BrAumCJmHhY58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a global variable, kvm_has_gmem_attributes, to make the result of
checking for KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES available to all tests.

kvm_has_gmem_attributes is true if guest_memfd tracks memory attributes, as
opposed to VM-level tracking.

This global variable is synced to the guest for testing convenience, to
avoid introducing subtle bugs when host/guest state is desynced.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a6a3e16578959..d5825211f2727 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -116,6 +116,8 @@ struct kvm_random_state {
 extern u32 kvm_random_seed;
 extern struct kvm_random_state kvm_rng;
 
+extern bool kvm_has_gmem_attributes;
+
 struct kvm_random_state new_kvm_random_state(u32 seed);
 u32 kvm_random_u32(struct kvm_random_state *state);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 08d0bbcd421ea..cd468b2bb8343 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -32,6 +32,8 @@ static void kvm_seed_rng(u32 seed)
 	kvm_rng = new_kvm_random_state(kvm_random_seed);
 }
 
+bool kvm_has_gmem_attributes;
+
 static size_t vcpu_mmap_sz(void);
 
 int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
@@ -527,6 +529,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 		kvm_seed_rng(kvm_random_seed);
 
 	sync_global_to_guest(vm, kvm_rng);
+	sync_global_to_guest(vm, kvm_has_gmem_attributes);
 
 	kvm_arch_vm_post_create(vm, nr_runnable_vcpus);
 
@@ -2311,6 +2314,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	srandom(time(0));
 	kvm_seed_rng(random());
 
+	kvm_has_gmem_attributes = kvm_has_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES);
+
 	kvm_selftest_arch_init();
 }
 

-- 
2.55.0.654.g21b8a5bc05-goog



