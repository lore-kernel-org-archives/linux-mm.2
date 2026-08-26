Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9DC9C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE786B00BD; Wed, 26 Aug 2026 05:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0236B00BE; Wed, 26 Aug 2026 05:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C486B00BF; Wed, 26 Aug 2026 05:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 893D66B00BD
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2A944031A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:03 +0000 (UTC)
X-FDA: 85142871366.12.DD182A2
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf09.hostedemail.com (Postfix) with ESMTP id E89F0140006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kn1w539u;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3hK-OagsKCHkXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3hK-OagsKCHkXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mryHVYsFMw5QfnvdlFWfWH3DHg2cIJI/N7Q9jVqtsNo=;
	b=1aiuB5Q0tbmhCe0jHSlCgXJE9VtIZ77zZPEgyyYvKC73hA5LMDh1dQn4J5UM4zcpKu2tgu
	F5azjqBNLHGIcuVydZVBAHbhMtxw1TmZlWtObamoFI9Qp4Hat3ZC3RqsSq6oxN+BzbltHW
	PCLtqe7BmxFies3mTJhUJzFiw/N4N1E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kn1w539u;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3hK-OagsKCHkXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3hK-OagsKCHkXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735941;
	b=D6zrnf/QXaSkQ738oN1iHXrD/uEgZ9wOBOTd+qrH+HCXD6ThEbvg28xlBDRSRVU6HGil4G
	tKSzCOvwfBFa2cLFvjtNR/YIW9UZxpacJHBgmkaDRtRvyJLWjBNZhmZLLPxa8V1iJdxO0O
	eIy8UTbQW26WJ80kixDbQaLsS0kd5tQ=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6f75c1219so17208725ad.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735941; x=1788340741; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mryHVYsFMw5QfnvdlFWfWH3DHg2cIJI/N7Q9jVqtsNo=;
        b=Kn1w539u2qmDyyIrE4UX50tb7D8wt6aRRkFtIE/jgNpGCxGWWcVuMc4MNesAEzwQ5P
         n06GlyfyXZhdQLTjih5iFN2Y91yO/aUwjipOZhjGc+fPYUNBIfNBcYxjwJljxdaC9J7v
         63YREkL8q8q20/9PDa9pSDTdvnQTme/GpB9q3R4h7W/umE/LSFq8tVHHXZOgOQn/uBfw
         mQN8m5PjuuE3bLp8JZIn3/StymyNXwqwE28jz88EoTQf8Hy16dS7Er2NpPR86A2+KOXS
         4JtBSc9WYYe+1RxHd4Wa5hmkoehGMrOn8pOa7LtGwdVVbZmG5cfp9lwKYsU+gZ4kY5GX
         5kJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735941; x=1788340741;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mryHVYsFMw5QfnvdlFWfWH3DHg2cIJI/N7Q9jVqtsNo=;
        b=Kk0vjsJ2JvlIenKk9ig6D2MVmfMABRZ/Duza4HD1stbuMH1W/o4elpXe9b2uBCEjMt
         ripOFUhNozMwb2iI67pKTb17fZDWYf5V20OiuvqCboqJc3Kgwx13E0UUnVi47itVSsDm
         b1RQQtzKi95B3nKb8MQtbKS3SxAAJJSTooqQeAi0O7E+rz9DxE98GhwioTM8f18zKLAN
         Q0R11o2TQemWlZMUV4ljjbYwdbSi94h1rI+mxYPE9QOZ6xvIVJkow6q36GFLRAqmICxA
         zW322jDTLpX+4E5xWYkmpJ5xiafJY6UyH3yk1jkOTp5dBxBald3woECCzJoRs9KwId4e
         wOxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqr6hpldcJESj3TIVgYqwXpurDKp47uiNl5XoxPH5AUku2w/J+TX+WrwvORJsPyxvWZMIs9YuWmDA==@kvack.org
X-Gm-Message-State: AFuF++m/XQowO431RFZ+zYKj6bufRsugz2+7vB+NdK0hVwXHXBwnT75h
	4WDouxUZgkwL4bWXEz3Y/BuysdLmaNszFjJ5NmGoh5tWSyHt3Zp/Y0iosag2r4Tp9aG+YOLgihi
	bvneb95SU1VokWiqBo9yMKABbCQ==
X-Received: from plblf11.prod.google.com ([2002:a17:902:fb4b:b0:2d6:eae9:3470])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d548:b0:2d0:cc92:f7ae with SMTP id d9443c01a7336-2d707953a04mr97889795ad.3.1787735940315;
 Wed, 26 Aug 2026 02:19:00 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:29 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=1820;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=m1EnsponEK3ffE+S4viVcHUMFCcCRT7Oe+a5rZdir9o=; b=qZJHVh35jrourMTzyQzc+m35d5hPzDRKD19154Bae8Nxq+4fEcdWMhoaHFA76qJd8wJSveiTc
 yd1CymUqKYyDI830woVD48JV9E21apI2rkTcg9PPgAYBmpucJvjTMcK
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-31-0a15d8a799aa@google.com>
Subject: [PATCH v11 31/46] KVM: selftests: Test conversion flow when INIT_SHARED
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
X-Stat-Signature: p15gztwqrjm4rm5pxywfwatxrqsgce6d
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E89F0140006
X-Rspam-User: 
X-HE-Tag: 1787735941-619361
X-HE-Meta: U2FsdGVkX1/AJyIH4m/xdKWR08E3SlkTjmsbF5v7YSWPG4L2v0j9+UwUGd5SZsgG1KEhTqHtZIWt4148SqzHzoqFu98ItTOuQ6vrxYpt3QFFLjt3YgmsXsm3jVzOBUBYmUUIUBlgiudUDHreK75J7bW8x/MECU7d3oHEZ7ZbX4QfBk5hvK2R5O77SqrPXou2obraimXxHoLn23ZoyZLvUxHdBpL66gbfbsWKa3Tl5NI7CwMhyJ9mkybX1R5MxnVZ8cgNcMnCPT3E3YYf4YdqFeZxyK8NUwSOhRb1redxW7sWd1dK8A2GWyDfbo/MbgK4VsAy0qjgIrofJz/WtVt8vZ98OilhpXYPLNXMBCBcpiMxzgI8n6TWzcCnkWe/TWy93fyVTrq9ZI1JP4vBxuwUmcgh9Fh7yRRS7bS/z4lYAEWB1y6CU86dNmbgtfArWcZcaXWWJqi0bX13xBUDS8bijOkcuqOt1AQFzNZ5qKUxabxjLkOguXJaEI7x+/5aqCtl8wGY7K0DYhFJMD7uvoUBc+RdVYuNLhgqe6J1eijBDYgXPP9uFxSveLooQpvLknwKFekgFGzx5YylrG8IRj50HsoNbFoEd/f/DKTiYzztzhqxSpxaPB092nrSin1z/Ou/RUIFbGgIku45iZ6AMbotYNUvTDs+Pb4B69rm2PRiOHLaQ/Y5AO/HS+B7u0xvEfTmfmftxqyFHLrp75yT82j7DF0CR4oMHYrHRP/TcYOtsl1OpUhELX5RzVP5nVcdocWrz5+r1s9DH0aw65gZB10qwHMy0XRqrc0mE101LPdi3GduIty2MBfNHBxsE3+Fgag2OEyzg0zdaORQ0TsLa9SGBd6kmFMuDJrAIp/J0zHOmT8+l/4wouv15SGCCPW2z9nEFw+7bJWTFDf/flKlDNUSFbvXaUVzRxryoFOjxDIS0aLYmDrIEwltRTaMCIz1f4hJ9BC/UkKKcpynuw49mUn
 dmPJ8mU1
 waG0msV88y839YHqKAGFQMWkOwkhGSUIH0czo9+/H8na4qOrc7tmg6ZEfhV3k5YIs2zJ5qw2hJ/qjzKDhHVkLdCJ3Tz7SzYsxZsb0H9hxYJmJqjQfGlCpZSKkBwaAcO22xvBC/CK1g3cOiErEwiAhJ78rLPL3j6Z1gnArs0LsT3VbCwL/T2M6dM1+BEc/5f+DEso87jFnZGm+DgjIVPdZiGwkGrITjE76/XHcyJpIsB7lFyQcJjFULxF6ivhGxE0Pj6cZ4gi0kCFOyAx6MUIdgTuMxgTJ2G+6YFLjfgGvBS3FdiDLIEqFN0U9GCBL3DWAo66wyudcaKu7QmIdwX8vdk9TNtVJiFQKBNfEJ5IqEEtuV8Byi7dbCnRJDS6Nq5QUC+IYyaEG7ntQa52sBgHC7GCm7ZJtjCZ4DUyUJThUFjOS3rwmDvh6VLGNP4aPoBH3MpPWcPhL+xc5mqarUQ2LjeAGUBLX7axdZ6Z4Zgl0snWyE44kYXVbZxDABE03fSbRpdKS32WYStNmUVDp+PLI+Yvf2yBOAGxQ6rEmsdZ2PiNbjkFPsuQvWlkd/tusTGJrKiGomIVAlIESUNhCUD5E8bBDDakkdqmnpDSYI6qbOFvJIAMS6l0QUsh9LgOgkuqSwuHEkUgX26sEOgK5AdP+zpbIKyk+R5iRsLQp8D8vt3lUaTs3MNB0xSNzI0g8m9kg4kGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test case to verify that conversions between private and shared
memory work correctly when the memory is initially created as shared.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c        | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 77f95d49349ce..4c20d3d8e9349 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -97,6 +97,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
 	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
 
+#define __GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, GUEST_MEMFD_FLAG_INIT_SHARED)
+
+#define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
+	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -188,6 +194,13 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
 	test_convert_to_private(t, 0, 'C', 'E');
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
+{
+	test_shared(t, 0, 0, 'A', 'B');
+	test_convert_to_private(t, 0, 'B', 'C');
+	test_convert_to_shared(t, 0, 'C', 'D', 'E');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.887.g758fc8c411-goog


