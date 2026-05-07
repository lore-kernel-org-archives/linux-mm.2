Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D9ACD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD216B00B1; Thu,  7 May 2026 16:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665356B00B6; Thu,  7 May 2026 16:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9F76B00B5; Thu,  7 May 2026 16:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2446E6B00B3
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8F4F120477
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:04 +0000 (UTC)
X-FDA: 84741747888.04.13D80BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C35B24000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7Xs54zP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185383;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0tNCDTQx6ZmU7qx6SzvDVfMOxnSmSrjpFGjMd7cMpM=;
	b=kx4WEerwonZlQkAPA535LOfpYnRVmpJaw+KHDirNiiE+45JBKeRZyI/7Nmcqzo7OIBkCmj
	QZ4BMSCjWnTr28y0XQ/HyD+NgbU0qWFu4oiefKsGgwUR2jFjzE3OBGkSwptvh1HvQTbugX
	oF0QKHKZGUKcc7Pzwz/icxwNh/AK9UE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185383; a=rsa-sha256;
	cv=none;
	b=FjRm1Gvxr3cY11lOUqonUCz/xoV9MedmduJiTpet+al653M6qKZiigQOAPDDdol4MM0kje
	R40Wv9AkegF5GDtpHLhdalQf4pnug6YHxvYYRIOtdjTVCaA93Sj7Rg6JNmdCuuGSA0DTlJ
	B2+iXoQ9z3S5iI58E4EQzLCHTw8yEQA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A7Xs54zP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44FE64482C;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12405C2BCF7;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=MMPGlYreY2sU1hgM7fKLHEenW50BQ3s1uRGHdDrCvNg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=A7Xs54zPKJg8gt4AKMtGWgkbrFe695yZUeKmbg/93U14urs7QojUCMEvKblF+P9Xm
	 d8MOskrO7x0HmQUstofXyZ5qUBHvA1n7JJbB8q9W27LIMlKfcOyyuwnKq24jGfMqoP
	 E5K3vlW+rWqjlH4uVB9bUq5uD5xByWn7nu+k/jPjYx6Az7jUrg26xPZ/5xtAl4ZkkO
	 aKFvIKPsprK3Flv6+P9K1SNGvaEDidkSwPhVmqkN7jQna6Vma22XJPXrbTDR7CPPSs
	 RIJij2MOOSHPO+0BLWB7D021v9EVFRT44uHbzybtZNzX4AopSOHuT64nzsLXtWb37R
	 RbgTQBNCk891A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29A3CD3447;
	Thu,  7 May 2026 20:22:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:48 -0700
Subject: [PATCH v6 29/43] KVM: selftests: Test conversion flow when
 INIT_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-29-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1651;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=3dJJVaO5CbDHEYuvBiKmCbp4LG4+cPBQBjzjK51vgD0=;
 b=T5ZAw36194pa8yvUKbqkX33Zn9CjHoCoe44GxfiKWIMI7PjSfJAIO2z5gP54gfKAkP1Hkhz08
 azus6bSU4JCDbwX+JzTdUFqAq5UYd4uKvoIfc0f1Xj8DDiJOgreK6Fv
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: C35B24000A
X-Rspamd-Server: rspam04
X-Stat-Signature: xohi6cwnk8t6fdk85owccp8j9tr9ofkw
X-HE-Tag: 1778185382-890655
X-HE-Meta: U2FsdGVkX1+gGT8NMm6o9IEJeb02nmWsYkCRhcFtEhz10JkGoxG1gslC7LuNhMh1CQwft8/6+EwLbfA6EVz5qGCa+Nw9py3xwUqnkrJuJ6iKiQoRp506ap8Vd2KXQIcGoGL3JclK8Dc6tqEZXEKCurInwJ4Nphy2AQgeGw/HI3vaOHsgbYD8wNwd8sAXewA3e4RNGsGBnkw4icghxuc9KrjSp5uzJzzkbg9PLVjLsDKt3kap7sZQpf84FuSWJA0V3NKlm4Eqw+gCU7m1+iGskBIhsiBCNo2J740IBHChZtK4pZTy1w2Ey6BWcB8CjtPVLTsZpS/d9JmnWzhmvMNUi/W+3ZiWn0bIwHBp00khwwJ3nrfM6chfqAF4s8rVUf0at9VyqcxwG7z/RymWF5RBOYe5SCCyceWKtyNw5Ij/Dy2sIRDcdN1uPLJVRVVSQQsG7JIBjWyNjUCURWIiXgtOj9xokj5sg5uDLZztEUGFE+ObwRXVcphy3ayZjXm3/XdKe0MKwChVvjjeCd9Jm3qS8zZFY/6d6elwAHyBSPBJPPU0WhK59fae6ss/vd1MCtgacQleJauRH/m/zCpMlzNEuUWHMVwiNwdG4S9R0Rx4NBSWThZnKrba4FvSbyQbAKOqfkFnhlUPMhpXEY5B4yI9uouNvVWY+/DNohpzOvbv3C1cQHY6lbphdpCRKiWB8SraEVx143pCeX5+rA2cj/qYuWxqkcgHHTk3mLH9uXHx9eWj8hqC+ZBGPPOGpkrtft1o7QPiLBz+Ez3MMjgf2pY0pQi0pkwuQeHp+zNPkbQkiMZQp07MYujXUMP91iywgk+8XcumLbdiJ0bNuWWXE9xcoNRmH/kZ2bapz5LW9yYQygSUMAsGCE3N+jgB6nHCWcOiK5PAPXHxsdICcajgC2rWwi+FQ/sXgO6sbjasgZdyFPYyz0XIT42J71X0NsZhRj2OsS4Id0RkPgucwBjol0v
 788+yPqT
 p92pEqkE8EN4Fu3xgfrkTEdt6L1ROOGlCnB+/N6LQPErVoGkqVKOzTxuMKfXz2YrBw5LI5duE7uld/uRcyRpaNRFMMltXCD77tYgujpDxqJRsqQRekrt+d4R1/FG6avMUfHbUorYOfntMyO9Q5ECSDn9l1rSwKzN7uwbonKxy5SBglZMviN6sKPzXTPOK6zZJoUB96qHlxashvKemdVoH3/jgDncZxnGaQzDH9uIYHHRbvru3vIhp9UCS8jUrv7hu9CF2lPlzfhYul9tBQB+R/ZkDMkrE/Snyg1U/KqJN+VXMC+OuCmQmDtxmcT29Gj4hbdxBDxahI/XXdiuAmvz3FlpI/WNXMolMzLbrA9md9oiFCXm0Dcdj5JaJUnPrlVrSeLmsTVg5l5vOwppq5aPerpVP9kN1j/XU3CX3AlZLtumtzBCJNBVyoKbdFrD9+Jsn7wNzc4Ha/8EP8guJjS9v0qLIEoS9W2S5YlKr1B3cjlRNT2uwOW9TMwgvlw==
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
index 81cf13e399c83..c524457148706 100644
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
2.54.0.563.g4f69b47b94-goog



