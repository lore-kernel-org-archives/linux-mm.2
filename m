Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2ABDCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BD76B00A0; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803526B00A2; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718CC6B00A1; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46BF46B009F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:31:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8AE886CDF
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:52 +0000 (UTC)
X-FDA: 84894784464.21.87FF76D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D0052180003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aG9d7Fl0;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LfPZExdtroPDXgzY1NzbLdeFo8PUJyZbnaUwzWr9jfE=;
	b=uTKPp6G6B+RJ4sZGaAywI+KgphmYdcUTu8cSkCgnTOf/d/1lHOom/31WSmlNGgxA0B4fia
	qXlIqbZ+GkUDKX2hmPLSJBSspVl9nVHYf8CQTaIZCOJbRDyLAxmxSttiaDgcRseKh9ULtM
	ja4bj/skTm14kSTnlj0K5RNl9u2FqD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829110;
	b=ortfcOKqbw6dYoLFBrvqvcxGd/vEJsThC9/RlLKykxdzaS2b7YkkfLECTqFmBwzXdDVfZb
	d4MJSQHrZVHI9Z0Vvc8HUjk7Ih8lAWTj8DwwjcPQD1IH9qymGiVKIrXfDtgxTDLDhh12FD
	L+9D0FAu96ui+1vZa1ZGtNmYiXvlK8A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aG9d7Fl0;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72145601F8;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3244CC2BCF6;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829110;
	bh=HE+TQYZHd9XTVAtjnJVDfLH6Etopk7UUgJYej/HCWgA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aG9d7Fl0JtfzlfiRnfwaA3wg5qf3IVM0L/5xKiI+tmSKLyOeoV1U8AZ4S6L9bxHFD
	 +1YLCEr+TZWV5dmvQncEkYispCZ5MmMQEtBubty773Lm5PHXq0Dm9Y7S9mWYAR3A/1
	 iTSF7gIk0s1RJdcdV7YcZGRyh6bPYt0qKd2cWy9R5mP1tBO/Ciwvz3QJRXtPaATHZb
	 ++yWsWf4bOkjp/iuVrE5sQskomKEvfkgcmPEO1sWAPffMzsrSv219kJDZxoMvjlP4g
	 oIjfEQxg3897l5HgqOSbpAALXcFUbSuPF+ii+IfujpPodpip6stOYjKarnuu+TcxLU
	 aFX4lk6InW+eg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277DFCDB463;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:09 -0700
Subject: [PATCH v8 32/46] KVM: selftests: Test conversion flow when
 INIT_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-32-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1655;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nwD26W66EWIOfw7qtPPc9ghGS40tBCr3JvsqDtSwEKA=;
 b=cARN8rM05Y65oP+QtR9r09tlloyo5hGdURUXhEchBTsE52YuBuN9n4BzIzKLgIDdDkt8/NPtG
 rzCe5tZ/EWRDTRlPW2S24232jLjEU0uFX+wxjWY+gMp8OzOVOAXx5SH
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0052180003
X-Stat-Signature: em3fyhzb3ci5mokzp74rj7eho7tpxpfz
X-HE-Tag: 1781829110-796491
X-HE-Meta: U2FsdGVkX1+wDbhgxF/R7xb+aD5bmTGQyayFEMKPTK1JChznphYEHoBMX6OdMDHQX3/XXvLuDaVZOzuVnEkIIekMoKXW5bJfEI+Ao22t/vwjh7n/Y2z9gFmz0+gSOahgz5aB4pnZ2/CxwnuyrwDBZqHfgVzz9his/jtUt4a+C3zWeFroA2yoO881ucJ9sgvjk1TnZCTxwLXaVrKDCs6Nht6OLUC+922G33kd8/ADsBCeKcLDS8LBoRcWy81AVCdClkJFo5zDoVgHZp3tVKddRyCoQY6oTWqz8o449OmcS0O5F5IM2AoJ9JSRrM267JWqjHetHTCa64GCvyNoe1RqB8MnNTtVMHercac3/5kW0LXSSQpWy7mfM5PgXCBexCO9kkJtzcIbTXC0Blaa3HZcnAAizhItfqtgqPuGgIJjIwu2M7f9Z2yoeQ1ac00cuMPQw+IbmoDctYi3pL4/slA2R+6VYe0BKJK1/wpg5JUWMHRExZ2AnLCna51Y/anLIY0GGDbYJPjwCDNVEjp57ivD3xoGXIWpI8gqbCdXGdEPBlO8AO+ZYyTi0sGNwhY45iacAvBGxn3lxhqsndZCQpWppKKtO/WSE0FcDA0flWSdkcb+RwFOnvhrxVOETXlDM2F5USVseF+PMUlSViiN9S2QE0XawRM+mIzR6DfVnTUoNSTx6HQm3ktXvqJhSqRuUQmTckrAMv/xhIJelFXDLkjo1fQdkRZ8cIYjQ9VPURtAUWQqHLxLsypzjGap6STH5brZ7WdyRwfgmXfaK58oBCV6qiLSmlPAPTWVmWbf7HaU9qbh2V2XRIoAljoVeFHf1OkxzZZWslVtTX+BbrQwGl0WO0Bh0X3uBehaUscr7enbeON4zn2zULzdNEPVUbT5ZjPifOWR3GCW146Y3gk1DxUti5PpqFGnXlmSK/G0lAXiqHAK9jaXA9kOnpuOyg4CAktBuwEVWfsRSicdF7hgKHL
 RC5ezG2v
 ZKscV1W9dSAI9ujseiIQh2hTwNnf37cX7u15e4LoyHV/ZSQvqrDvdCyindx1F7eVUiYq5cloqO/03UdG5rFWR262txvVs9hyuwK19FdoHESa4O0PcFdX2KH05wvCz5TIaBU6nYu8je6qUFwQRPuYJqNKzR3h/eSrvh9gPL9y2dPM/1Lq0ElbW26ZvjVnBXplfTWDpeIGvMCyQKwweS5n8s/mH/8iiD2T35TYti9WeuSVeGf30ZecuHvaq8CNWenBuZdoP7Ki8M2Sn1qdUU3rmj4gVPc2rq+n6e27mJ8A++swVKPaCHFw6yjfZFv+ohqYNDY7tzIYS5eo5kLiVYFJbc9Z3r3pXfQtbpHgBhXSKfntpbbkO4sHC0gB+A2Ux9VGstGwLqH8XjbMse0IbItz+OB8MJv8xuxuEQjgkhhzEFo/uSY++vWCt4WXs+w9EVfNQNjopwmm4SKVxXs48up1zS/HzkqfH5CYNlv3LujiBKNXMbXj0FvoCL5sSlRVBfQO3HPIchzsKnch3wPfiI90a2HWt5w==
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



