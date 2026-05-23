Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42357CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937D26B00A2; Fri, 22 May 2026 20:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859196B00A5; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566066B00A6; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3665A6B00A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED17C4077F
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
X-FDA: 84796772256.15.B4B7783
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 187C780002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZVbsOek;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495487;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxpe08ywt01R21pKwXt7yBWOvojG9sShIvLm9Lgw/UQ=;
	b=8p3vVYDccWg0nDOsSpPH8LwzOF1mDL3obSxmE2ECOSppUBwj5JX4ze0pkxGswFNg95KTj7
	TKAft4Hi19LWzrpppgZs7rhJ2YIYsQV30BkunFTuU+OuYw52sPNUGSLsb4Ujwpv/j4AQE1
	dmcvj76Ug2j8FqpAQEnoG3w5zH55g2w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gZVbsOek;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495487; a=rsa-sha256;
	cv=none;
	b=3+lE1ytbgNMjyT0IdlaRsuz6MSrgwhww0o9CuF7nJRnVvxJOp10soJRyZPh2FUXz0mLH9j
	0M+zo+csVSKfuTgatqXrQYQmy4rQe1gt7xwMclbd2Q0KEky8ZtfuTjCeAJHUNQePHXEhZR
	yqT6q6qN4XRfkDVofGl3E8WA70g69YI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D7A7602CA;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3672C4FE80;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495485;
	bh=SN/owuCx2SpIHZ1eqDB1g81GuHncXI7tgmYvgfDB4Wk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gZVbsOekZyfMa8OmkAxBF+ZTL1XFyMPxMXqluxnQpMD7RNIfH2KtSkH92+Ph5rGBg
	 Y4n7tZTc158Joaxdu0AHqHF7j/xMa4yGtIZC15qas4GQI7i8rcrHgwlv/7f6OrDK4c
	 ef3hSMCqpfpbOaXjEQEWNMyXiKaMBjvMt4ppswshrHyS5Kw1HnuDygSjxBZ0KvX/GI
	 2zyrEAPnxAEu++iYYZJqLyLegbhpf3P+0CRdcMXs2tWVKGDx9xP2cKjVySaNmbLIow
	 wH4ClWVvA6Apxy51x1KlmNMgHKhY2pRgVhLFOl3yVXCsGXHboE6CtHvLY3iyn6+z/L
	 oqf9wbzBndThA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B78DCD5BC1;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:10 -0700
Subject: [PATCH v7 28/42] KVM: selftests: Test conversion flow when
 INIT_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-28-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=1651;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9ruFgoANfL3UyeWYyEpmuLipaL+9k+u/mPIJES3rlKI=;
 b=VjHyhwPjfmbvt7ot/b9xzkNoo39fC/zuX0i+7GvyUi1iOYYr248JJQEUWE8m59qfYODTNxoX8
 BVtkO/xk3/zB+ySsHgjKNBo7jkj/gv4N46piHBEW2JYmu9z7pUOHWzw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 187C780002
X-Stat-Signature: p8xtx1rswt467ut9e83sxr4zc5w9g9tp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779495486-803897
X-HE-Meta: U2FsdGVkX1+/R3+5rdY2tmAQP4MeWvepupPFCu3+YIyZmwrRzdoALIFMMrCXtSE9Dgrc3QDKK6m4sZD68Rlkzkyonrysxhe2pMHCP3w25Q6Fu1CZH8RBOI8jflaOxaueAay9AKjC7/ZWpVQzAw9bMEwQvZllzjEuI3F9+xo5hmR3RfO+9UmewNbST+cNqnuoj35DMX+nlAQYyF9qBaaVganzcx5j5Ab9BeVh3ydXSQo0GyANeBUjMJNxV4ljLK97KVg7enPFeqGPTaFsF/zjdQtMOAc39WuEjEY9lzSyXl4/kkTVBrywdNkUb+3Lgn/XobB1XtlGQGsdfAkx+LZoOxg/t6prb0BiIdX65rbE0xSb3cKtLhGDK5IFuZ9+hkM84YcM1TiMkkp5CqA6v82PVCbl2oxrmvrMLj//HwUOSuj1yJOEsoB2i840d8jW+6txmy+QH8vmpv/J2QYhjpWvPa4tUFfkKD2uoq2ebNLeC3WAqfNLL0oT/vqtYnQKoDC+ppTauKurw0RaOUqfVQigpim5sbjF01euY5BTy8JK5J/Swi42yrwj1x36QAa/H0YImPS8xMA2aT3NGQt2sK4yEN9a5dmeB0hIxMaLcfbox6xhnFqX+nCtF5sPr0k2IpSEncs7WEUh5WeylBT4rurzhuc40OoR+vqhn5V9+EaR+UV4Sk/fqRJziwjY6L5CzBYZXATztnfIHeU1jL0RL5TV2ITizr9dhoJfjaTHAmwQ3s5Fcst1Q8jEMz72HA/1z/dJOpVeUy+ZbhzLNw5NWqsRXjf6hH4AfRgLuUCSsGO3bt2UazPLml7Oi1/5QriyuO1lX+lzeIe3qbVpdSYOaMNGpU/hy4QLiCbAnVtmCkmpfxamjvVc+O3Vpn1QWXVzjk+4Klzmr5zRWGy1Nu2xIA5TGS31OwKSHSbd7feOPbxn5SSvHI/c1Zo96zkvONnh1eTI0kdybMn2P7c3VJUrWrQ
 BLAf4IUk
 2PdLw09eW0Zmbgx0BXv4KjpvAnbKYFnVfNFBKaL1SWMb0o9doT+P5o+1272C15Gm2UUI+fwS0ip+Ld9Qxp0tBK/xiYo+rYZSWG/yb6NdyWLhGQtclEMw5OvSdEoZPplqtVYetiH69AwaCWakzhfJsKGZa0CxvfgXWRoaUo+wWrQGa3+YSA/624qjYbtJZphEo6oHtl7si5M/hFrV+SxU4hQFDLLU/mk0dc9qJSUjDhekDyzP7xAg41Esf6HrgV/J8YsoIAZlHXDveP+CoFO/9WAhBn8T6P0qjHII+iS8by05SqENdp50vDhv6m6rO5+UGGkjbbSexNpbIfq/C5UGInh5Lo/J7BCc8aBbMA8Dof8YOpwYFlz2c18w8xAfjIlFwvN+iuqQ0JqDgxfe8L2lCSmT+UHsdGJnXSxVAYytu/tSMyc29zOIrE3iEChYpFCIeJT1l/S2OUXTMjxnkfc/WpCnPc6h8KYPJE0lBl5RxDEc/DL8IIIavW3ZPMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a test case to verify that conversions between private and shared
memory work correctly when the memory is initially created as shared.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.54.0.794.g4f17f83d09-goog



