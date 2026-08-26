Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A4BC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CA66B00CE; Wed, 26 Aug 2026 05:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7060B6B00CF; Wed, 26 Aug 2026 05:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F716B00D0; Wed, 26 Aug 2026 05:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2683C6B00CE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC2E0A33E1
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:27 +0000 (UTC)
X-FDA: 85142872374.10.830AA1E
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC9AC140004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uLPrcGaM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3nK-OagsKCJEvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3nK-OagsKCJEvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbRUvfXufo/53FByarAgnrpLej2qb+vPYL1z/tXSG2A=;
	b=kaUvzLb8bunjE5pVmh5BILF6pE+V6XSXc41BiQZlAJ/R+A1Zw/BtwDpVoos5DQ4JoDc3f/
	+c91cALjVkRHq/bxukXm34E0URjCg3re85hkCePPF+GYDdkhEjr1HSqlxFm/k0FwouXt1Y
	DHyM1YY8QYJuAvbrk33SNfTupvpHBRk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uLPrcGaM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3nK-OagsKCJEvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3nK-OagsKCJEvx5zC6zJE8119916z.x97638FI-775Gvx5.9C1@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735965;
	b=gYM/AqKvyG5VevcUlPVTXGbDnJvtZPUWz251jpSRSXEClGw5jHz/86Ace7qC1k9ukETW4E
	rWH0iOpBlfoX2JXIFdq9YC9lKnRVCL2r40i0DjArmgU1Ke0F/e803WbJ+8qZlbFrw9aAvw
	QIxGAo2EWBS3cK3niMW20Vvm8fEqi+M=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6fb956002so11304085ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735965; x=1788340765; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LbRUvfXufo/53FByarAgnrpLej2qb+vPYL1z/tXSG2A=;
        b=uLPrcGaMEhSgp/lZzOC148I+zwF6XmMkdJ1dPnfkImiWN22CZlj3I+hzpdgRVWPx/c
         gYiEb62J+8a+a4r2NRx6syt/wdWp1bg7HXHDNYLF70peGEYftJQjEBhNanS1Xjj3V0wy
         ywzYdBfW/ZGfpaykNIBLomkF8nkelsQmbDpTDuOrdkx6RSFhGTcydcbMmubQgUgOC7kF
         z2ZxOzVTcOahdW1/kNq1gNE3m4ZIYNZN8I70g2NQGbrxGN4BqJNhbZVv5Bi6+SW0Ee/a
         oj3qRloUfB44dDZQteyma5mwH+xYsJNejwc+N+N9DOBeVtfvoXhMx0Y8Zm6Cphx8RS2F
         eDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735965; x=1788340765;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LbRUvfXufo/53FByarAgnrpLej2qb+vPYL1z/tXSG2A=;
        b=EAilGI1H6EZcYmraA3/qaYpe9yQvGP2rFmUoiLwqqm+XI1Q78tDY/ntlrTtGGX55Lh
         AO/h0ZXkgTWYFJBRDDWvky9tRA6V92ed9Rk+vul4JbS2TPNqsFh+rkOytbSHpUYUZ1vV
         k3v0cflqk2Ii6Mp3VNw+CxrvKStpGjjz+P1b9ddJBjHeLfLUFG/YTmmTkOskP08kPgRK
         2odlLiNUw2/D6uf7l54ohjfT6GHPTYvhKQfHBNMayt7/Df6F5MoQ0+iXhVkA/Z8XjBNg
         NkDOlLJxtaC7zL1ciQYR9irPof6ODWjafJjttjcV8R5DzqPhhpLBnDdhh5cItwnrv3TF
         fvXQ==
X-Forwarded-Encrypted: i=1; AHgh+RpA2kpSYLUMjLkYu5nYZDMwsy2bJhDN+50QbBXfMtRePtlIIAYtLHOM/4KsfKaDEDQW0DrqVSnrqw==@kvack.org
X-Gm-Message-State: AFuF++kWSrgIwWsF+BjJSxVDCPQ9sycTNwp2CnFEC1uHHBicnBjFa5QI
	j+sZ4nDki4aZCvWupCBjlDlcy4fHBKSnGRsfMi87iDeiw0xgCs1qjHT6StxOq4GrEsp6dtn7jfm
	6py/2SKqJSoMuQelahPoGH6mAFA==
X-Received: from plbmo15.prod.google.com ([2002:a17:903:a8f:b0:2cf:bf3e:41f0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e54f:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2d707a2f08bmr89613835ad.2.1787735964425;
 Wed, 26 Aug 2026 02:19:24 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:43 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=5438;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xH/AetAOiAVfkVCScjPegESZvTMnvecRQ5W1mdHVya8=; b=rBjdK8/qbBIySb4GV8EG74eZYYgnmFDHuYJd/UqCRYD0UNnjEq1/oCm1vlkEqhjZzxSbXcN7L
 +83jZ96iK2MDTs6i5y0XZawZfieoRqtZqJPahiBUo5v1PNUnNYnk+8w
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-45-0a15d8a799aa@google.com>
Subject: [PATCH v11 45/46] KVM: selftests: Test in-place conversions in private_mem_conversions_test
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ot1ap6dwoget36137yu4ran478nwtmos
X-Rspamd-Queue-Id: EC9AC140004
X-HE-Tag: 1787735965-855093
X-HE-Meta: U2FsdGVkX1/vdWwOjDcTRgM+nbP/32mmpcRceme3OkHeffp12qke1/vvKri4mJGDC9OEvJZ3lnmB1g5xaiJRZw2fFdzhMMA+nQEWh+yjnDsjLpQQFJKGIsdfKF5dSDdoh225MoSnRB2G+cDClt+qsCPEE8mnGBmkY+Qfl1V6MHgn8x5DPAoFwt2DLMTtz976jDCFmr1FLXqTvNRWrQ5RIo0iP7tfn8Wd7xhD3E8dpyrx58RAuvGtMVkEvg7lVifkwcmolOu6LDNO2EhN2bny5i1nyds/7pFcDNwiEXYS3whENyMtQry7xA7fqa6keJH0Ci9i+/PdXuuPOlnxc7XTEq/DDuDHKkuajpLJusNNJ55lGcyHN7YYQEppCFEs+4EpC41wsHkBKOvGtHWCdKW7aNVmh23jE67akFbu6zkF4Lu0qeO4C/6qtYfwo3wvpVDTtFdJAT0Y6T9u4lbVyvD4lch9ovF97SnbpiWi4PV7MHGqYB/WK/v7pXQ7f1i/AIOsUyO5GTghS7u6ZIIsAsPycBYYEwtHLv+x4EmY3SjcPCUwIpEBwg7nffuQGh1mVebImQ4N59ktv3fLLdSVV6GEFlsDfGyF6Lf6GmO5qXwxAqewQdPeF/O7MSFGBBNlRrBJfQ0os+WCviJKBMB4PnL8fOEPHuxZPyql1sKXhYjLPBxshUhKXhwqqKK26BiCHa3HsVOYAMNhS3R3Vsq67OpvOh4RlSKI0JSD0ZWcDiOwUt5sQxAkzl0UGl6ZWGCTFf0kokowOL59X74R7aCf77SfNJnwBbMPx8egVbLlxEllqee7buTbV2p0SyWGtqu+oUDGEFetaJLxa37T1ohdmlbUYeiyGR9r8Vwn2Ds9b09exV4lECHRJIsbKCOF0PMQvZ/5Sg4aLm1Q3LQXateBqlHgL9X+TICLNIXLogPOoO0gF8E57RiZ7GXTtILa6gi/FPSxvHq82+fPi05434njYf5
 ilIBbVgD
 Iec8qQ+px8AFC8czweLveMNn9bxPXgMsfrf1JMDxEcZCisYVrW1zozeUgyqKhdUsY1d1JTI2fSsaEnNA6HnDP905OgEUp6IOfQjDpu0X7oUntUlUFHyK8FGdAq7nmgYmBUcq/mnZd+n3rBAqHmHc4YmLRVFL/9rTULb9z/xCPXD36xIvG/lnHWviQ+efkC7GD84AcbUiinEFXoZ1X7FL0OL0EwJXw4fCWbsqSPDS5M8bs3+3ejZFOTrvHiu0/TeJ4Uf3U4X535yO3ZD/766BtehIwFcb7VwxTVAEmlkOXp16mDO8NDZBR82tIl1lY2q5HNq1KIky3CLE0tTF3g30PIxaln2dpEtzwShXsmpwA12YmCjUChKJU66WB5YEGSchvwlLWDEvWJzAPbNW8ssmwEHVR0BpYQJGewazU7iu/evhnu/JvuQYs+c4aPejIKta/inLZ9E0p0orueW7xDWDRJWNdgJ78pb/8itT2udzrFOfKvdgeYoPpohNlEH4uGmUB2+SpE0zAsIdT/ioJcBHQqSEnc/mesCMtgA29ojP/CS/x65L+RaeaUC5kfJZB+15Jq8X0915Cfqj6FPFN/bmWdVUdQyTQuZyOhQXjVypt1n4TF5EadJiNSFonNwo+h86wk8dbX/58W1S2kdlUn3nScZMHFTTvV8M8eleBybcnhWyJkUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test in-place conversions by setting up the guest with a single backing,
using the same guest_memfd for both private and shared memory.

Make testing single backing the default when per-guest_memfd memory
attributes are supported (kvm_has_gmem_attributes). Continue to support
testing of double-backing by accepting a -2 flag.

When testing single-backing, don't use src_type to determine alignment for
rounding up per-cpu test memory size, since guest_memfd's backing page size
is always the system PAGE_SIZE.

To test in-place conversions, set up guest_memfd with
GUEST_MEMFD_FLAG_MMAP and GUEST_MEMFD_FLAG_INIT_SHARED so that both host
and guest access the same backing physical memory.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/private_mem_conversions_test.c         | 55 +++++++++++++++++-----
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 0c94e36575a5e..8f03eea9e2fb6 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -26,6 +26,8 @@
 #define BASE_DATA_GPA		((u64)(1ull << 32))
 #define PER_CPU_DATA_SIZE	((u64)(SZ_2M + PAGE_SIZE))
 
+static bool use_double_backing;
+
 /* Horrific macro so that the line info is captured accurately :-( */
 #define memcmp_g(gpa, pattern,  size)								\
 do {												\
@@ -355,8 +357,15 @@ static void *__test_mem_conversions(void *__vcpu)
 				size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
 				u8 *hva = addr_gpa2hva(vm, gpa + i);
 
-				/* In all cases, the host should observe the shared data. */
-				memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				/*
+				 * When using double backing, the host should
+				 * always observe shared data, since the shared
+				 * memory is a separate page.
+				 */
+				if (use_double_backing)
+					memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				else if (uc.args[0] == SYNC_PRIVATE)
+					TEST_EXPECT_SIGBUS(READ_ONCE(*hva));
 
 				/* For shared, write the new pattern to guest memory. */
 				if (uc.args[0] == SYNC_SHARED)
@@ -372,15 +381,23 @@ static void *__test_mem_conversions(void *__vcpu)
 	}
 }
 
+/* Align each vCPU's chunk of memory naturally to the size of the backing store. */
+static size_t compute_per_cpu_size(enum vm_mem_backing_src_type src_type)
+{
+	size_t alignment;
+
+	if (use_double_backing)
+		alignment = get_backing_src_pagesz(src_type);
+	else
+		alignment = getpagesize();
+
+	return align_up(PER_CPU_DATA_SIZE, max_t(size_t, SZ_2M, alignment));
+}
+
 static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_vcpus,
 				 u32 nr_memslots)
 {
-	/*
-	 * Allocate enough memory so that each vCPU's chunk of memory can be
-	 * naturally aligned with respect to the size of the backing store.
-	 */
-	const size_t alignment = max_t(size_t, SZ_2M, get_backing_src_pagesz(src_type));
-	const size_t per_cpu_size = align_up(PER_CPU_DATA_SIZE, alignment);
+	const size_t per_cpu_size = compute_per_cpu_size(src_type);
 	const size_t memfd_size = per_cpu_size * nr_vcpus;
 	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
@@ -404,6 +421,8 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 	gmem_flags = 0;
 	if (kvm_has_gmem_attributes)
 		gmem_flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+	if (!use_double_backing)
+		gmem_flags |= GUEST_MEMFD_FLAG_MMAP;
 
 	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
@@ -448,7 +467,9 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 static void usage(const char *cmd)
 {
 	puts("");
-	printf("usage: %s [-h] [-m nr_memslots] [-s mem_type] [-n nr_vcpus]\n", cmd);
+	printf("usage: %s [-2] [-h] [-m nr_memslots] [-s mem_type] [-n nr_vcpus]\n", cmd);
+	puts("");
+	puts(" -2: use double backing (guest_memfd for private, src_type for shared)");
 	puts("");
 	backing_src_help("-s");
 	puts("");
@@ -461,16 +482,22 @@ static void usage(const char *cmd)
 int main(int argc, char *argv[])
 {
 	enum vm_mem_backing_src_type src_type = DEFAULT_VM_MEM_SRC;
+	const char *backing_src_str = NULL;
 	u32 nr_memslots = 1;
 	u32 nr_vcpus = 1;
 	int opt;
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
 
-	while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
+	use_double_backing = !kvm_has_gmem_attributes;
+
+	while ((opt = getopt(argc, argv, "2hm:s:n:")) != -1) {
 		switch (opt) {
+		case '2':
+			use_double_backing = true;
+			break;
 		case 's':
-			src_type = parse_backing_src_type(optarg);
+			backing_src_str = optarg;
 			break;
 		case 'n':
 			nr_vcpus = atoi_positive("nr_vcpus", optarg);
@@ -485,6 +512,12 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (backing_src_str) {
+		TEST_ASSERT(use_double_backing,
+			    "src_type is only configurable when testing using double backing.");
+		src_type = parse_backing_src_type(backing_src_str);
+	}
+
 	test_mem_conversions(src_type, nr_vcpus, nr_memslots);
 
 	return 0;

-- 
2.55.0.887.g758fc8c411-goog


