Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A215810AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C408D6B00D5; Thu, 26 Mar 2026 18:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18476B00D7; Thu, 26 Mar 2026 18:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90E16B00D8; Thu, 26 Mar 2026 18:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95C096B00D5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 611F51405B2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:37 +0000 (UTC)
X-FDA: 84589647114.15.F360CAD
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 830CE1A0002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GWxjK267;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3XbLFaQsKCC4KMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3XbLFaQsKCC4KMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563935; a=rsa-sha256;
	cv=none;
	b=Q40qVmCpBqCgs0zb30aTFT3RWqi7Uo/XLfePfxZxj983jHddRrhd1xvqmpO5+Hd0xIo+qy
	c3oEZ3kSwp3Tu+BXf5ywV51s7fIH++A1oILN2eiMZvkrXixtp2eq55nI2SKKm8u0m46ZVC
	48i0zqVAstIvOq8ip3jZ+bNcIAZuGYw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GWxjK267;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3XbLFaQsKCC4KMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3XbLFaQsKCC4KMUObVOidXQQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQv/c3jRIYhBhzt6KigDfrqgdsyHsqIxf08hCghwjGs=;
	b=w9hOx+ASyEZv7j7yloIRSpcaxdcdF/dlLBm1s+2pgQyKTDHKwCeKNZL5W4SHqdwaXI/S6Z
	3HRNQtimE5MvSuU71sbKzHEquYkEd3uC5UM98HnLCFRYw+7mjT1kIJBlMe/1k5pFGT8sR8
	q0RzsmIf/bcVT7pWJboJkBovSSNNhRI=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82a6c70f1f8so1278588b3a.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563934; x=1775168734; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qQv/c3jRIYhBhzt6KigDfrqgdsyHsqIxf08hCghwjGs=;
        b=GWxjK267hwE7gnqtKxODUxwLQDP6B4+b62f5u6IL2kTSZMxh82FGGphiU9RWSe8E7M
         /eDQD1ljGh0g7Hp2pfkqOj7IgRBjUGD3giBocwSnenIEcf7WGgCK3NaV5FmffT8jySTY
         J6i9tOhjB5c+VuhgEx3VRreElLxQSgh6qAQQtWyBrJrGo9CwDmoqLqst2LKh3rpLCRIP
         ZXZQP+J3zPj1bE16aQa/lSgJyLnnm5DXjOCKgIM3aj9a0QizIxYmwh8L18OR18gE/MXF
         2GD21bItG9ZNSj4ocD4kteGx80HsjaeZ5ESt5dkwaHHPI3UyBCssRw9KVb+QAfE3kQQ3
         ztRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563934; x=1775168734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qQv/c3jRIYhBhzt6KigDfrqgdsyHsqIxf08hCghwjGs=;
        b=kaSJ0O0AuyQlIs/9uzFE7y/AcSuzbY8XwV/5zvTfEoV9bmqrckDKVqieFWOLGi2usq
         fO0Xm3DCcjl+Y3HQ4dFQkl53wKwqQbCuZJBnJ+H9vwtmFzqPWUGOkD6fUqM/5W7lDBz0
         uRdUVqoS3vjawKYmH1xC4L/hNKcbhxv97FiO4BTB2H2Z3ubXkBMg1btxij3QUDpWPOAi
         vDHl2BShUnZRZM/65mQjeGsuhT8bhM3/teCo8ojnfrHXKdcyD9J066MKZUCC1I6Pb07U
         iwR90gxNc59PhunS5lKRzvyx8u6soOsiuutiVWSigTY8Bj3k7xJ1IJ2H3uExPhpL4ad1
         wwUQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2/ZLjW1Hgb+MAUK0/2O23G3sv7kVr70tTmmMLYAejGn/iyQ0aNaPJK8hRR6A67IpsM3AJDd+8LA==@kvack.org
X-Gm-Message-State: AOJu0YyqQ8OOhvOqHFhK7OrG0cZPZo9oxoqYERYj6PHOOukOtAxsFXdT
	JYL1BCzapCfo73rqIXMV5PM0VHEQBbxETGtlfpNj4zCOFrn1bR0f1QtAjh+0cwq2D+rNCy80mqS
	Q3OSa/2vodmxKbuxqkBeflwzoMQ==
X-Received: from pfbfb41.prod.google.com ([2002:a05:6a00:2da9:b0:829:7d34:ff99])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:13a9:b0:824:36f8:346f with SMTP id d2e1a72fcca58-82c95e7986bmr157171b3a.25.1774563933827;
 Thu, 26 Mar 2026 15:25:33 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:43 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2836;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mbmnyh+Paq6B3nFHJjVqfDuPSLNxTEBywi3jrm5yLoM=; b=ayjE20AS++xWp9N9WMziD80Oj2fnaF8+fEzlR1NValnRS6nVfyJUGa/eCX/UeeAKeN4u7/8Jy
 xLD/R+OSUjsBKl4tO0uelwfjOm2q3N6Bn3lz/wkKJsC7TbYULR2LjZv
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-34-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 34/44] KVM: selftests: Support checking that data not
 equal expected
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: tjdygfnu5cah6oaommra49jkfg9arnap
X-Rspamd-Queue-Id: 830CE1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774563935-272721
X-HE-Meta: U2FsdGVkX19O281KsqBpuocruCJgYewOfOmblcr5PrAb6+o3RjbW1/PZJqRFRLmIh91MlA+7ux+4+ILF7r21tZ2l8FdTUmb2WkMmiSzi3Y6K1riNnNKvVx4oiqT2KiyALMzwwR0/r1P9CAPInNivvtaK5YS/KIotPbyT6dRfknGISLbkNAXBDLEon+Kk6c3GFd3fP9kxad4qANm9p1/qtaHVNfsP2o9HRnQSCXuK1VVuLr3oZu/r+2XVVVlfL7A7BaUDflueahyo4QoORHy60VCPkIukN7g0j8Vb5ST3URoQMG7WOF2ZxF9BT9dPEeauMnQKM3cEoOS4q+YrrTFaohjpKzz1qdGh2AqKbnNpgrst7X2pIE4e+p3cITQrbRjbP8HFAGDGzd/Nlubgk1olMJrKsXV5Ky2QEjs8owHAEQ8JLdNIF0onrIy6F6mSktcNTTXgx+xqtxetnfg7uWXuXuFp6S+6QoSJcxdYLgxjTteDyNAQvmoKyfXfswKf+GXMiXnNJLXN5X50/dGMf2RQuYhofFRAX8qGGwMr8uXnbet3G+pDcaHNczyGSqANeghy0qM6v6JpXas1tv/YPKDepO/jI/UoeDHDrlYbI+ZhiuSOwTV+I4q7k8QrjzWvi6nJRQpFr1+PINZZ/TLn/WW9/upHSTSlZMeIragfEfmUExLf3OzldxbRPulvsYyS46L2vZrO79fOudr64lKoSjTAFAAjIJoYeGv/MIXykRgvUQ8IDc70379zngIzhJB0vsuHp0Rf5V+tz7i3t6OWbfNtTNNEj2bvXzVuZsHzLnOTcq+qxgx8l4ehb/8BP3WBzZFx5J+Sj3nMi54D9KxuASCIAzu5FpvWOofSI6ELMpNOSGF0ZBY1G6AI06wTgUBr+y/hlplEe0XlXVfintQ//HOEYA97z4uzc+8LbMn6fRVvmFdwHA5XrAWlHWDDtFhsaFb8tY8CTzEVUF6sBHKYYHr
 JiKPLDgV
 5qyxy1KN62WOY+hRV32qM3f5YNbK9R/DJnRVAnikHd3ua1+reSEQS7X2cjABpG4xVPRbqBNkXi3seXBZxV94sESplVDGmGC6VMfS4cdnXCakzDEolHOIWG2FcUeEELRv8KQMOsOvvPL/ZO0dQ4ilpxzcThzyIxQ/9TcoxCQkoQFfreQrNhHigzOCy/U7OVJ3wmbYiIvoX5Vby9KsJlj3Iv/biMnm+1FUFKCdZq4rDaiNlMyawp6Lpo1HoFZ6fjnqe+LBD1WaylSRqFibuSm1bf+SQfSZCuIgoywk7hgws6icfxNzSCr9rvVrHNvRTU1PJKAL9m5VCOFCr6K8179jSxoFCg3UvqU2f1tpCrSux/T7vnwYfl420Y0VjQvwupBRf6nUXMNmNfIkiNJZCI2LDxztpreE3rXdmULsYmYygDWRLqbtTi9lLiMOUr9GvH6SRimtFuSlsiRpa12WTRjwyAjmUJ2mIlkUE+82w27xSdDL/ho7cpk1an8N0to1B2Fmdpn2Q7n/nivaJ7MN2ikWIOgCFWlT8NI2ZsPI8Oq+Zi0Z2TC5DIyGUW8/Zm+BpseActqe/tgLMOKDhIJlBZ0mzRF8aM0cOZc94UvnUuE09M0MKf9b10ELUviKPMqwU4oNeQa1jF+bfCbfg26Nm1aJfzY2rtqD87LqsIBhkUMseOd304JI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expand run_guest_do_rmw() to support checking that data at given pgoff is
not equal to expected_val. This will be used in a later patch that tests
that memory contents are scrambled.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c        | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index c0abc69f15332..277b122ec294c 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -137,6 +137,7 @@ static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
 struct guest_check_data {
 	void *mem;
 	char expected_val;
+	bool assert_not_equal;
 	char write_val;
 };
 static struct guest_check_data guest_data;
@@ -146,7 +147,13 @@ static void guest_do_rmw(void)
 	for (;;) {
 		char *mem = READ_ONCE(guest_data.mem);
 
-		GUEST_ASSERT_EQ(READ_ONCE(*mem), READ_ONCE(guest_data.expected_val));
+		if (READ_ONCE(guest_data.assert_not_equal)) {
+			GUEST_ASSERT_NE(READ_ONCE(*mem),
+					READ_ONCE(guest_data.expected_val));
+		} else {
+			GUEST_ASSERT_EQ(READ_ONCE(*mem),
+					READ_ONCE(guest_data.expected_val));
+		}
 		WRITE_ONCE(*mem, READ_ONCE(guest_data.write_val));
 
 		GUEST_SYNC(0);
@@ -154,13 +161,15 @@ static void guest_do_rmw(void)
 }
 
 static void run_guest_do_rmw(struct kvm_vcpu *vcpu, loff_t pgoff,
-			     char expected_val, char write_val)
+			     char expected_val, char write_val,
+			     bool assert_not_equal)
 {
 	struct ucall uc;
 	int r;
 
 	guest_data.mem = (void *)GUEST_MEMFD_SHARING_TEST_GVA + pgoff * page_size;
 	guest_data.expected_val = expected_val;
+	guest_data.assert_not_equal = assert_not_equal;
 	guest_data.write_val = write_val;
 	sync_global_to_guest(vcpu->vm, guest_data);
 
@@ -191,7 +200,7 @@ static void test_private(test_data_t *t, loff_t pgoff, char starting_val,
 			 char write_val)
 {
 	TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[pgoff * page_size], write_val));
-	run_guest_do_rmw(t->vcpu, pgoff, starting_val, write_val);
+	run_guest_do_rmw(t->vcpu, pgoff, starting_val, write_val, false);
 	TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[pgoff * page_size]));
 }
 
@@ -207,7 +216,7 @@ static void test_shared(test_data_t *t, loff_t pgoff, char starting_val,
 			char host_write_val, char write_val)
 {
 	host_do_rmw(t->mem, pgoff, starting_val, host_write_val);
-	run_guest_do_rmw(t->vcpu, pgoff, host_write_val, write_val);
+	run_guest_do_rmw(t->vcpu, pgoff, host_write_val, write_val, false);
 	TEST_ASSERT_EQ(READ_ONCE(t->mem[pgoff * page_size]), write_val);
 }
 

-- 
2.53.0.1018.g2bb0e51243-goog


