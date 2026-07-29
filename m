Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E821FC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8BA6B00B5; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 572556B00B6; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451B56B00B7; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 210F16B00B5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A1F591C0DEE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:22 +0000 (UTC)
X-FDA: 85039945284.14.70DD7DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B309B4000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pH+rKuCR;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285320;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRAWjVfLIKP/wHqoisi1xy/n9UyCn/7gJJimRCW1bP0=;
	b=Br8ieq2O2q9Ty+x8fw2V6YDVgwzpHiyuIgQWpF6tNMtkqAOP7BALidUlwkcPm3hTzifW8C
	wueFJya4Mm8iDlaJ6R43qV/io/01OXeGNNWUUOgbO0Zm4AZTZLeBSdbTY5YA16f6O7PoTL
	om8lPICbWjLf/IsTl0eEAB0qBRdzrOw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285320;
	b=yly/VKbNeOC6TBCcrRJnP8w3958g4iYM2ruIyUFYQpYcQRdpN3/zkegP3uMQCOlC85TAHZ
	ijMFxvX/jgR8N+vK1Dzwis3c/qbX7ktNbJKJ15smMY3AzAu6bsSU8auNxzP056tzzci0Or
	ulpskIEYtGJks1R3zlStgUSR32qMcFU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pH+rKuCR;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C834452BE;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2172EC4DE0F;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=61Nqn/0fm0A2PdvhL6P0eLkXxFIoGLEVoGq+DJS6OWw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pH+rKuCRc5vJJvfmI4U0GHjYiEgBP5lS9FxFLr6KwI2avNbQt7Q+meITqxBxKZUia
	 Dnk+EmVGiB6YozTVXwpIaqEZ6/45RQ879tgvdQEcaGNY+BrtnEDmVcwDjUzWVnykR8
	 KPV1Tet748TA/fZ74+tNN4zGSpJOs2cBTyy0z0N2i2tCOjvCvH6FlGkCj9Crl19tsw
	 X8g0fwThELAXuUnbdMw5NZ52wAORNeRTyydeoamtwWjPSDLH0siGNpEpA43yyBif0p
	 39Rnk+3vSbT0fVPPmhS0LvYLOodqwZvmS5iWoF2uNnltOjYDKL1l5ZDABjyy/9v30A
	 CrYhnBI3LW+DQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B5CC54F5E;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:27 -0700
Subject: [PATCH v9 28/41] KVM: selftests: Test conversion flow when
 INIT_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-28-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=1739;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=KmwX1wioW/hBmwm2hIuChiwSg8fHxmYGlVwlMl3l2NE=;
 b=14tOLTXvYoqpO7nhDO0a2goBT/pp5ziCwAr8w/G/Xg+tOLNKmzYk67cXDNTk0fe6bHfHrVRxn
 CUoRBxPW896BKBAzXWyDkbgSui7Xi2nQDDlYXJnDmMjFivgKoN2Ku01
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B309B4000A
X-Stat-Signature: tqpzgydpzh5k4iffgumuja5d3h1mja5m
X-HE-Tag: 1785285320-284497
X-HE-Meta: U2FsdGVkX1/XoPl6iZ/y33WRK5kwrQ7Yyh9EUz6iLyJLRjDOsbxwLPFiPVV3B9ZErY2DeuKM3gDZTtbA5p76qQO8hk5Q7UraUaqcnC3biKHlc9fi2o2JGfKcXa70HVTbV+Yjey40+LG/SMKVETwpv3mjBYN2612dfABh+xPfuxFe8Vy7/dGG3mAUlJ19lfiR59C6zXR4++TToDMQWqllD7xwZGFZLvLXGSkGc76WqMQ3BGcBTvp9Mlsh1wlX/m0+uXe2sqNAZ1iCONOFeyFuyxWvruCPt25xUCfjRTbarhjveMREd3e+KFpZlTKpFIjs2c6wvJUxd06yD97dUFq+1tWVGoPE327NU+xARgT2Ayc4iNPDz8BnC7R9e7wBC11xn/8zKVqJ+6MuF4ZBKSlc8AriaE3sST491QOhj2ahFgOwaebkgfVjI2utcx+/UbVa17u9VBCiQfChYP4BGGh7SGJX4wZN50o5bjAxOQ3DJWF12Eaw5gefJTcrD6aPDLlkrafdyu/xm7aFzESY9hEulRwQIxoXWWDP81cOQDUH/p167ntogT6Ap63tczz7N+j5GgBKVXaBr174oSa4uHu99zgcVtn4jIWwLLf+mNSVw2rJVwwR1tKw2dvG1M7NJvsfweJwDl4Vymu/lXBulH98gkcv+6bptxxr6p6f7iWYQGkZ5CQ4Wec+mpDhwJ01RH9Zd4M1MAdjKd1AYnxmpvFdRO/vklrLYc5WcAImK8hLG6GtZ8ERou39jtNCL60Yk7rr86amA/zQIuvBizjBK57Hdcb1R+LzutYspHLGf4HUJ8A9hshfPROvcYYVICs5hxCtVjpYoXTF1dKHWQ6fEk8Zg1gVqCWK9gRwT6FvNXOKioC361yjjxU5ow3p5BZds6/whxqayJvFkncFiDPQGQ1Gtz17MVPreH/zsKmV/UN6Ze5CcfH572nI2Z6dt4WoInhcjsnrnT9SBEpzjDNKpcc
 FZKPvTlk
 BkViv9USS7iCZS6vn70d89yaUK+3z5jbTU9ZgALghq8d1PmGwD6FsBLbUpxjCV4AAn1EUqh+faMCIzmTuPvt0ua+5Rw5CMOinTn1hL7+T+T4VTqL0H5+dGb9FUWsuGIBFycPLFb0ktxVT4weTsiXHMb9k14K8PI99Pb49/9IB5WKsWysMogiNwgXGkkpp/1eoqhTA58FN2UR2/2NTAhGPc03JSnqEbd43FSeGYHeQgmXXJJO9CTc09N8uN2Dfg6yawV68Am7WMVXwwJ1VcCxsB6fegWlOlqkJjm1CtkgMJzuu3IUu0pCz4GdBUD+Zj+5UQ+3H4WDfI2rJ7rsNEsEAJsymL3gayIqscp9vmtpxy05zSVE3tIH3n+qUSWMAsUXcCSYjM7hEOsgG0Iset7SH4IcC8wZjGVXJNMW4nn7ho1NAS5/GbbRWRan8dHx6cht2k2cYbDlk/HY2vunME6zpyaGpfaT42Fk3A/P72VWVYyE20DiXuS1YSYb5/p5rTHrCj4cyra01dIOxfTX5oGkR13lntzQsRZPzJnVOyrG3jsz7LxvYlZ7pTQBppg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a test case to verify that conversions between private and shared
memory work correctly when the memory is initially created as shared.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/x86/guest_memfd_conversions_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 8e09e241723e5..5b070d3374eae 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -95,6 +95,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
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
@@ -186,6 +192,12 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
 	test_convert_to_private(t, 0, 'C', 'E');
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
+{
+	test_shared(t, 0, 0, 'A', 'B');
+	test_convert_to_private(t, 0, 'B', 'C');
+	test_convert_to_shared(t, 0, 'C', 'D', 'E');
+}
 
 int main(int argc, char *argv[])
 {

-- 
2.55.0.508.g3f0d502094-goog



