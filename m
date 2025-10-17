Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA650CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B92D8E008D; Fri, 17 Oct 2025 16:13:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041DA8E0078; Fri, 17 Oct 2025 16:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD76E8E008D; Fri, 17 Oct 2025 16:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C52538E0078
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94022C0284
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:16 +0000 (UTC)
X-FDA: 84008705592.07.A8715C6
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id C35E2120009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2I44DwIr;
	spf=pass (imf29.hostedemail.com: domain of 3WaPyaAsKCLgYaicpjcwrleemmejc.amkjglsv-kkitYai.mpe@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3WaPyaAsKCLgYaicpjcwrleemmejc.amkjglsv-kkitYai.mpe@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/dkg7bO1Q/m68vFvjbiJ5siG3cxkpNKvttryWm72LM=;
	b=Mh+gAuZUoAczHRtkmwCPX5yUTQHMVA2FmDL1jkMJwMbHHS6a+kvXUBzR0aZefmwF/eZXfa
	zSLl/t8vrVsmqE4rRa5IFGjl9jfdW2KZfjIpkNzoWqvogDxPle0iVa1PibIWuhEdK1NLJK
	899hJKd+Zan1CqySJdx9wH8pCafHTN4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731994; a=rsa-sha256;
	cv=none;
	b=mXyFCoAht4jSqW/r3x9zgMY6EQl1urKFr+etjHjBf6LtahATnZ9DscpmeHFaHYgsJf354L
	WcvNZOYmyiP6XWUzeqC9kTXINjFqju5sroUysq1fiwU3AIz1v5OkCThtBTkc4D60JqhP1A
	pAZ28kYMDWIJcYr3xlM/gwzrJRU25Ss=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2I44DwIr;
	spf=pass (imf29.hostedemail.com: domain of 3WaPyaAsKCLgYaicpjcwrleemmejc.amkjglsv-kkitYai.mpe@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3WaPyaAsKCLgYaicpjcwrleemmejc.amkjglsv-kkitYai.mpe@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc49so3732782a91.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731993; x=1761336793; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9/dkg7bO1Q/m68vFvjbiJ5siG3cxkpNKvttryWm72LM=;
        b=2I44DwIreQRXWMM5V9sNggFxM5TYLaZH4zwVTChFse/WY+/PPI8pHnh/MzCvvNOKA8
         wSkeqng2To3vOJ4WiTV3ShtLoBix9KWAofrLhZbsFeZLYdyT7QPQDQnewexNRjqNw11C
         q3wijhmaNJzACWVvPTgrpL3ryV5ndtdtKLU4cpsK33+YgMNjG/0d76MULqVTpuL30SB3
         ef85g8HgwxevEwCdhl4lqp3PkNcc9FrK8phKgF5GbQuroqOOyEqTdu02zGUh4cA2Znz+
         wh8ts81xGiVJHP4GDFAmZAUypR8dNnh4KFp+Kh+KIE8uFnlzHPlAWXMw4atNU6VEiOe9
         FQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731993; x=1761336793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9/dkg7bO1Q/m68vFvjbiJ5siG3cxkpNKvttryWm72LM=;
        b=e2dXTa/zusXnJP1qJ9gaoVhXWVbyjNLuHPjTxIjH2tOZEuETtEIt5xI/NBdsiUejSn
         3sfifWL8WtTa303pUXZsJbXgtm/egtyNUNrh2P83tpzUqvP+RZiBAbjjB9WB4vJjp0Ru
         7APgLNUAQuGjxa53nDiQjHChX3zSchbJsT+grAF0a0j4D5ehOYST3zpnmn8E/NRPMIA6
         8MTZbEHqWzGIU3l4hYPqFww3bBX4hbVNV86Zp0Qmk1+aPiBAjNgmXobLablLhJLp60gh
         WaNjx+2H3qlCWB9unPAop9Gx6oApaPKAtLkGi/SgdbA9jhBlp2wVJkjbTEPoeZakAxDV
         ppLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQ+Duo7m7XbqV52f5S0Ys9v4IO/EGwXYY7kr2jJBsnGPccuuYj+TTAvf6lrglMk7RvCtkBypTxFA==@kvack.org
X-Gm-Message-State: AOJu0YzTpb1KXrjZgHeZJXyx/QkFGRPKn62T9t6SMvgmR/3STvSZeFIq
	zHTAJkReJ1vCSIRIqBCKO5Ee2+B06C6eioKAK1oWnG3WAuHmY2hk7m/X0LSWgIHRXID10A5fuIJ
	+5LP/kFDsGqwQHF0iysEX126HOQ==
X-Google-Smtp-Source: AGHT+IHVYfbeJHjmJQIxf3lnI6xML61YGFIRkStopZSXJJvTgLI8jTgXjo0mAYsj6xfs9PsRIMTiStrABfsfvN8xtQ==
X-Received: from pjbqx13.prod.google.com ([2002:a17:90b:3e4d:b0:32d:e4c6:7410])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c5:b0:33b:c5c7:511a with SMTP id 98e67ed59e1d1-33bc5c75327mr6623268a91.15.1760731993183;
 Fri, 17 Oct 2025 13:13:13 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:08 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <de6d461b585351e38e2f0ad23d06bdd1d05025bc.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 27/37] KVM: selftests: guest_memfd: Test conversion
 with elevated page refcount
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
X-Rspamd-Server: rspam05
X-Stat-Signature: ycsmsa78o6fot1og6xxqzfzefkfiempp
X-Rspam-User: 
X-Rspamd-Queue-Id: C35E2120009
X-HE-Tag: 1760731994-670198
X-HE-Meta: U2FsdGVkX19ddeQ4l8owF0NN7HR2CtAWV+d2uBWEaY4ZI9WxjocU4+GV+sqhgD49ad1sdnoESSGE0aaWL5msqRTHU/pEHi+5HfkqVii0OSG9SIRMu57s7z6K5bcmU+M6KjmNBmFM2vL2TFNupKpPjwzYCYkRWzcR1a0WmZQd4hat1p/3BpspNLa6CHzlBew8c+zjcUP33AqQhzzo7oZkcW6rWW9kiQsE6tg5mUhVqzumDtxQYPHvpdGysom/IUyPgntqQeRC98Xfaxr+zcU+eCLFpOBZHUJEn7NBSJhB59bPM07fKaDp6R7p1BcJMdWV/u+QFW09e03jXIBfb3VAAHsBlBMdHBMvGdWuL48oZaKpItX7JSYoiUy5KCfQF0xaDLz/pCK41vCrB/4IHd0f0+gJ+ysVc8bTMqkpzgGFzzO2arTN6C5FmZurk82gLa70w5Di/7MYDTsQQyWB8UHm4FZmVJZQf1eVqFK9vL3z2XadnqjMiyLGZkWG+xC49SD+vIT4DKRpAVe8ZPhcKURjALyNZM4teIYwelOn8lacUzIxlQmP70i9Ag3CWyfu/5J3GPu8Z49eWUTP1iXsqt8Jhw8/Wk1ARtHYRnhYwBLrFwfG5rbtMNh2CIAakYZA4crDMcMUX281+z1DlChgTOUw0WvD8hF8vcu0y+5yVzSVupNOildN64x0sTuQz53Pt9PnVCxgjtdXJ+1mgJDBKCjPMGPgofLVfn6rwbSKDEg/PLeE8uAT7+xKGl4JW0Bv4k6Y8gPDOJDGf0wBQ1sABi3LZhnJMAWSgJ7+3Oe4lfwxG4TZz5XsCu+XfM1tAWJbLn1JUmD/lKi7/mA9wgYtvLhdPUwyO0ZwVV6d8Uhd6OAFjUFQY9d/pznMUnYgREi4C1GqWJ6w+NK4PEdRN1NhOBjx60toWRRP+300Hsdsu5AU6bAzkhBoLEpC88x0A5/bVbAYRtq9CzXkFzNnttvewJ6
 IX6kj6Hg
 dLmIUeXpjFLnt+Jy4Dkc6mZ72x+Z6e12omCq/2TVtELMfejq/Mh0eDRkfVou2loht9WLuXCuIBrN9TUFM6S0Yf1jTRnh/AgFm9yENnx/WQkMZN3NrGfVoZr18Nwx4aEFMLw98nwWssfm74nslkryjhdOmvN7z83yTyZLD1vAvUYjJCPdOStZWSop66Fg2vseJrkdb0xk476qTjMoEpc8jTjwRA0mf/rfWFRfrpE/YEmb3C+ilpJ34iYw21jHI0GRsR7hPHt6xleBDCXdvlqWzrbgDsCUQx+pxGPoqHZlJbgrdv0QW6jiEINGCyBKXzcEtg/tUsXo3n10+QHAEeMr08y01ja9W5MmPM+dtFwmMNI+LLjVa08L39aV9tMavzevVZeJShCT9xzufq6NpvXUDelwQjCDtGCqgePdREP3QU2z/JnUSyjv5ewLduPhsggLlCuaNijSKEIr9e5aovE9vrr7gaW4ePIJiUPp0z/rFo+WH7ip01Kt9j0cyueRrvw9mAIXV3bTYeyPV8E1lUEc46iRGu4a6yjDoSbWOyxoxAc+cvw9q9ooJ6DQnczLDkcfH5f//IOVkKtnBjPAJYV4mjgfldsMPJqB9pmpz9zyX5N3sNMV+QvLBUcqPh1ZxPUZhNQLu0Z33SbFIiwIt/vxEKEQ+O4fslto4NQzDif7U4YO8lM6R02evk0OoJ99FuknRigHw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest to verify that converting a shared guest_memfd page to a
private page fails if the page has an elevated reference count.

When KVM converts a shared page to a private one, it expects the page to
have a reference count equal to the reference counts taken by the
filemap. If another kernel subsystem holds a reference to the page, for
example via pin_user_pages(), the conversion must be aborted.

This test uses the gup_test debugfs interface (which requires
CONFIG_GUP_TEST) to call pin_user_pages() on a specific page, artificially
increasing its reference count. It then attempts to convert a range of
pages, including the pinned page, from shared to private.

The test asserts that both bulk and single-page conversion attempts
correctly fail with EAGAIN for the pinned page. After the page is unpinned,
the test verifies that subsequent conversions succeed.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/guest_memfd_conversions_test.c        | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index e6abf2d30c62d..856166f1b1dfc 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -14,6 +14,7 @@
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
+#include "../../../../mm/gup_test.h"
 
 FIXTURE(gmem_conversions) {
 	struct kvm_vcpu *vcpu;
@@ -404,6 +405,87 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
 	kvm_munmap(test_state, sizeof(*test_state));
 }
 
+static int gup_test_fd;
+
+static void pin_pages(void *vaddr, uint64_t size)
+{
+	const struct pin_longterm_test args = {
+		.addr = (uint64_t)vaddr,
+		.size = size,
+		.flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE,
+	};
+
+	gup_test_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	TEST_REQUIRE(gup_test_fd >= 0);
+
+	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
+}
+
+static void unpin_pages(void)
+{
+	if (gup_test_fd > 0)
+		TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_STOP), 0);
+}
+
+static void test_convert_to_private_fails(test_data_t *t, loff_t pgoff,
+					  size_t nr_pages,
+					  loff_t expected_error_offset)
+{
+	loff_t offset = pgoff * page_size;
+	loff_t error_offset = -1ul;
+	int ret;
+
+	do {
+		ret = __gmem_set_private(t->gmem_fd, offset,
+					 nr_pages * page_size, &error_offset);
+	} while (ret == -1 && errno == EINTR);
+	TEST_ASSERT(ret == -1 && errno == EAGAIN,
+		    "Wanted EAGAIN on page %lu, got %d (ret = %d)", pgoff,
+		    errno, ret);
+	TEST_ASSERT_EQ(error_offset, expected_error_offset);
+}
+
+/*
+ * This test depends on CONFIG_GUP_TEST to provide a kernel module that exposes
+ * pin_user_pages() to userspace.
+ */
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(elevated_refcount, 4)
+{
+	int i;
+
+	pin_pages(t->mem + test_page * page_size, page_size);
+
+	for (i = 0; i < nr_pages; i++)
+		test_shared(t, i, 0, 'A', 'B');
+
+	/*
+	 * Converting in bulk should fail as long any page in the range has
+	 * unexpected refcounts.
+	 */
+	test_convert_to_private_fails(t, 0, nr_pages, test_page * page_size);
+
+	for (i = 0; i < nr_pages; i++) {
+		/*
+		 * Converting page-wise should also fail as long any page in the
+		 * range has unexpected refcounts.
+		 */
+		if (i == test_page)
+			test_convert_to_private_fails(t, i, 1, test_page * page_size);
+		else
+			test_convert_to_private(t, i, 'B', 'C');
+	}
+
+	unpin_pages();
+
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
+
+	for (i = 0; i < nr_pages; i++) {
+		char expected = i == test_page ? 'B' : 'C';
+
+		test_private(t, i, expected, 'D');
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
-- 
2.51.0.858.gf9c4a03a3a-goog


