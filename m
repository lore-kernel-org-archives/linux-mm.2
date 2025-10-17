Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AE3CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB198E006C; Fri, 17 Oct 2025 16:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D7F8E0006; Fri, 17 Oct 2025 16:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B79F8E006C; Fri, 17 Oct 2025 16:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E44888E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B671C1197B0
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:06 +0000 (UTC)
X-FDA: 84008705172.25.77D7F9C
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id EE08FC0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sinYa4I3;
	spf=pass (imf28.hostedemail.com: domain of 3T6PyaAsKCK4OQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3T6PyaAsKCK4OQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lnebmp8Qf5EWIBCxuV2pnQrOdRPzx0FMFYBdpouvbtI=;
	b=cnDlfjmnuR/gBA0cwNPZ9YKHdbLJ8tWrGZY9sZZHwbxnpak1gIP50x9fUH7PhyFUYeAV4W
	ybGvsrp2p5pWesZJ+irLneba3Lme36GimzxBZDrQDtzYqD5cUxk9nbiV8xhPOj82iE6PU9
	L2GOrE3jPy6VgFHCQuVJcnVdmZU7pf4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sinYa4I3;
	spf=pass (imf28.hostedemail.com: domain of 3T6PyaAsKCK4OQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3T6PyaAsKCK4OQYSfZSmhbUUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731985; a=rsa-sha256;
	cv=none;
	b=NUmjYfPzO38Nvh9UFpZgRcPGB4r/YcCMRkTmvAcgIs1X6Rmj0+B7O2p6nwUvF7PMBeFceh
	z5fBYLQFy46SFijuYjJSR2fTogggO7QFErMpkH0PYPw/kSiZbcj7+x0nxyaW8o+9zNXKOk
	D/LZuHMRRwKy/MVe4TfW4nh4YOk1EtE=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b60968d52a1so3882992a12.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731984; x=1761336784; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lnebmp8Qf5EWIBCxuV2pnQrOdRPzx0FMFYBdpouvbtI=;
        b=sinYa4I3Fk0BfaDLYHvkkHDm6pFNyjij6Qo4vL0jeI5g5MLkoKwvt6+WDz3OopT0j8
         oBBxbuG+vi7UI7KZdZxfhK95Y24PlaILXr0i5HTAT7MhKpAo5GpdOJQgS9IwGwsNllNs
         43r7CmnBwwBRpgh3RDDPchL/jKviUQorN7qGV8px8o7n494JHnXoNUbMfvxtx2IeLoPW
         Zsy9aGDog0uBH2CMhAnsMWZeQf9D/IsOeoLcPT1IGGVsMRszVAepYxtZQ1L1JNXCHH4d
         X0Hum19IY8SGKwegY3r/UdnIDxGMHtz9Luo7pSV0ANw+HsCvZZ+73CkIe9ThOR75cx2/
         /uLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731984; x=1761336784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lnebmp8Qf5EWIBCxuV2pnQrOdRPzx0FMFYBdpouvbtI=;
        b=r3o3o5fj5fQ7Gkwbertfw5H4bMmM2538d4TZlzODOHYz6kSMj1gMwQCd4alCAoy5Qn
         VMhE6hRa+wXoAPrrKFXL1VlaFd/0PNtQjye95bdwfqZZAeTSuzA3NurQWNZbqW/yUo87
         mo2gfzOyGQVkAzENFaxbGooHbVVhbJHVfPDH1e5VE0Su4hgsDZ3BCtX8hz21wadvr7FP
         7jEFcP3PZYKYT+emq+KDxsH6wzw9NC0eLvDD3/fEPDN/5FheiXvaCPgB+wrXQgUFqJqx
         brvaaAYiPLMQHeGR/23zcRsjieea4M1WCJ/yv5gLFKjRgh8lEMlGxxRaNS+l5d3MCs0E
         4JMw==
X-Forwarded-Encrypted: i=1; AJvYcCUbnBHoPM8lOli2E/wSiSadbSnMkGCt2UIi7PhgN+Iu9PkHci4RugwwOracXD7sO65SYBXqjpuqEA==@kvack.org
X-Gm-Message-State: AOJu0YyY4DvOlLM6A2ODOLWOL3b2tDLjXrvJnUb5xagvMkyQBGSDXslb
	rWjtv1BHj2zCPzW7/pNba7QNyAXkUA9MVMBpLRTWUuYOlcjz9Znmj3NCIpvU6J0sBPbvgfdjMQl
	fZhLK6dAGmVZu0vVA7C+w3QJjCg==
X-Google-Smtp-Source: AGHT+IEB52F61621aMByRkpbPgTkpDpb2zZJPIEfSZTfaBbai+oIczGx5aQpE8WOhm5/i6XAmSimYUjcxZtR+kNbuQ==
X-Received: from pjtk2.prod.google.com ([2002:a17:90a:c502:b0:327:7035:d848])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:244b:b0:253:1e04:4e8 with SMTP id adf61e73a8af0-334a85fdb31mr6337050637.56.1760731983589;
 Fri, 17 Oct 2025 13:13:03 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:02 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <612a3bcc787fb76379b081e802b9c67ccbeb8a87.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 21/37] KVM: selftests: guest_memfd: Test indexing in guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fajy9ncnmi9jrzfgceb835dpsg3oxfzr
X-Rspamd-Queue-Id: EE08FC0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760731984-29789
X-HE-Meta: U2FsdGVkX19unHWYsoDTcmtk/eprTueCkMx8tdTGib807QOPIXYNbQWTgTRcRD1BBkmKbsz+3tn0r2P9yEzddGHG0hj/ZLnt2N7tMMdHmXm0QleoVvd2s9qM0/ix8r38Bvf9fEjMvKfxjVcAw8YHVoEfRRL3QIC7Wu4/6y6rHou4OxTLKSOiL6ksMF4ihDJJl1f6su81wNCJMO5WlZRRua5YJlgdqu2w1Iq7eWkXP26IkENQyl6ooHGY5mdhmsJjSelfRdIMKHSOYJCnL3FIZlvxRITzKqM+SH+/U/5vxaG92Ep/AmwN9vEbna+FAF93jHTFbHEgFLhttjT960WjpiyH9ar/bVTMORi+G7w7028tLfLXIPG8X8cPx9JI0sekJ+4pjeNlXKJbSPkh+nLbiZikXdi4hrQTOr31ukCDwwMJHRlT+Lyku1PE3n1CFJCaZpRZuKhXishqnbmE1oK9Iik5ag6uhB44eC3ZetntMR6bZoSxhEr8oNSp7puc86kBeTvj6UUZajaqaqKZkG5+oydaSA84kcope0NIgnuOKPvSIDVoJgOBZyVHwnO4m7q3gLI47W77TRw7TfyrfcMPimi3nzNgJH1dpRs1mkCBvmilrSJr9GMFbZFi8/hjaf2pqINgZ4CxMPgdPmyk5DylC8ob3F6b1HfHIv7G1bGqQIHs/BxaqasOGV+wPMtseX/ba2JwR9NSYFyPHrkGtWPuMLgjuXhWMH7Gca6ZRZ6ejP4JLZ0+W9Q/Ys9Oo7Xu/LvfWSjrMHAdSgMH94DZgaoieObOpO5eVDucPzdVhd4wDGnAtMJEW9IaJU5dz9m0nTcve8Vw+qXqg2CJydKs4KWG3bYyg4SuofXSEvni3N2n0zizEqBuvEQRtYcxuCpdPk2DUUBDnrVMxcdnfKpVFg/4hEM2/Q65cK25V+qEi3oaPg1ZFMHuv9LLDcVUiFlj3lAYYeDr79EJLHjmiKPex6P
 2LQBVY6R
 O7oJ5fFUFQr/f3FzpKECXPrKp2E5eXTO7UW1nrYB9paf7zSMsM6mQNlifhyQuWzx0l7Kjk9NQtD9kgpI3XK1+RFTtybpHw8Lv/+H+fOLbMB165eOl0tW1SERberZFY5qGMpugt4PtzxOKYARnCSsX/uPREUO+LI34d9tmbJi4YYUSPDlwJVIDtFw73eoKYxevsW9kxii3rDwFyeXJHnmlkCz2V6GFj/Re2zPA23Jb25YTTtZ7A1asYvV8R8kLNxiaA/LRxwsfEEvcoCsaclryRrqJ1jEuu8O86Qi1xakahbiKmGRwUA/HQCBEnTjs+AYXw9lQTlJbsArxDdWchzRogy8R+lpSYw8quNujMydiGaH+a2ti5COYLK9kiDGMFjaiEFIPK/dWv+AzR32lqGRJ1WxiK6Lcx7IVgZU2Rxhb1OHG1yNo49JFR4bKw4up58Hzz+UrXt2szTfPeFO9o1wPnmqjaZ67wfXyyqPme+6eHSpURpjTho75Oi76w9SWCtUDbN5sDYjLqN0MtIm8ZkryedcV3Pqh/lpIG5mzMC6kQQWf9joHqZH/S+Uhbv50Li9dqcLv0iyQhVbzS4zRRcXDNXwXww48HguySNjYlOH4m4rs9ftfCmA3C8nYtR4MfTaAnqMTEcbLfJviitMZdULSIx5UrKgPK2R3u3ZpXEgfWg2baZ7GVt4GAjgcpAhyoiRqCmNPbqvnYHwfmLw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing guest_memfd conversion tests only use single-page memory
regions. This provides no coverage for multi-page guest_memfd objects,
specifically whether KVM correctly handles the page index for conversion
operations. An incorrect implementation could, for example, always operate
on the first page regardless of the index provided.

Add a new test case to verify that conversions between private and shared
memory correctly target the specified page within a multi-page guest_memfd.

To support this test, add a new GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED
macro that handles setting up and tearing down the VM for each page
iteration. The teardown logic is adjusted to prevent a double-free in this
new scenario.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/guest_memfd_conversions_test.c        | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index d57e66ee11310..54e7deec992d4 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -63,6 +63,9 @@ static void gmem_conversions_do_teardown(test_data_t *t)
 {
 	/* No need to close gmem_fd, it's owned by the VM structure. */
 	kvm_vm_free(t->vcpu->vm);
+
+	/* NULL this out to avoid second free on full teardown in multipage tests. */
+	t->vcpu->vm = NULL;
 }
 
 FIXTURE_TEARDOWN(gmem_conversions)
@@ -101,6 +104,29 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
 	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
 
+/*
+ * Repeats test over nr_pages in a guest_memfd of size nr_pages, providing each
+ * test iteration with test_page, the index of the page under test in
+ * guest_memfd. test_page takes values 0..(nr_pages - 1) inclusive.
+ */
+#define GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(test, __nr_pages)		\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page);		\
+										\
+TEST_F(gmem_conversions, test)							\
+{										\
+	const uint64_t flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED; \
+	int i;									\
+										\
+	for (i = 0; i < __nr_pages; ++i) {					\
+		gmem_conversions_do_setup(self, __nr_pages, flags);		\
+		__gmem_conversions_multipage_##test(self, __nr_pages, i);	\
+		gmem_conversions_do_teardown(self);				\
+	}									\
+}										\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -207,6 +233,36 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
 	test_convert_to_shared(t, 0, 'C', 'D', 'E');
 }
 
+/*
+ * Test indexing of pages within guest_memfd, using test data that is a multiple
+ * of page index.
+ */
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
+{
+	int i;
+
+	/*
+	 * Start with the highest index, to catch any errors when, perhaps, the
+	 * first page is returned even for the last index.
+	 */
+	for (i = nr_pages - 1; i >= 0; --i)
+		test_shared(t, i, 0, i, i * 2);
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_convert_to_private(t, i, i * 2, i * 4);
+		else
+			test_shared(t, i, i * 2, i * 3, i * 4);
+	}
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_convert_to_shared(t, i, i * 4, i * 5, i * 6);
+		else
+			test_shared(t, i, i * 4, i * 5, i * 6);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
-- 
2.51.0.858.gf9c4a03a3a-goog


