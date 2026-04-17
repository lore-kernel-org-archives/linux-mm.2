Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B146EF8E497
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE3D6B008A; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4486B0093; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941E26B008C; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 853CA6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40363C3245
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:34 +0000 (UTC)
X-FDA: 84666270108.25.ACD9380
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 64594C000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=auTQRiek;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of alvin.sun@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776388292; a=rsa-sha256;
	cv=none;
	b=fEOpCLYIA0ejh+W+Uwm5UO2ubeRiUwOBjOkVIrarHVL5exZQCq7uCgJdePTiHsInmdv3wZ
	qXPWx0E1I8Qw0ygw3LDt39066fhXsoaosNxpNsUTG5Qs0w0LFJJgH+ZoyObgmYSAs4K4cq
	Oy8L9BctaMbm44OrMQSynq+JX1qRcyo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=auTQRiek;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of alvin.sun@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776388292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8LP3AWG5RHffa4IdxklVZ+g0GiOlSaUEKKAPwulu8o=;
	b=Kcu/q5r4MroztNN6W8dNKUYSsrLD/5xK19yz/ooyJVUtvbmZn0W1iwoNBiNVMw59NCqJdk
	9gJsqiiKnfVJhvyRqMLw+hmlQwACBTIfzKB5qlI9YkenHn6tX1s5xLcRCXFFjI1BoACIzk
	9y/FHYBRWrAJvAZcb5OqqRDlQjE21Rw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25FAB44589;
	Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF902C2BCB8;
	Fri, 17 Apr 2026 01:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux.dev; s=korg;
	t=1776388291; bh=CEPawZ6sXIb2An8dSVvX8IrZi7UWboan6QZmQB4W5f4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=auTQRiekRCbbnhehqgsarbiyZ9+MIl9n4mrx4RAyZfmikqaGndZyfXvBi/zIlG10q
	 eZtHFv8M0FEM0DNguds1lj8Q/j51ee61fZpOGnUg7mJjCLfq+Bl+HRl2DOA1f2i+63
	 H74dP9IhAzSdnRb9rb9ubnxnrNhJPUxAbijsb8qA=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E131FF8E49C;
	Fri, 17 Apr 2026 01:11:30 +0000 (UTC)
From: Alvin Sun <alvin.sun@linux.dev>
Date: Fri, 17 Apr 2026 09:05:52 +0800
Subject: [PATCH 2/4] rust: mm: Add task_size() method to Mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-tyr-ioctls-deps-v1-2-41c6e9bb061c@linux.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
In-Reply-To: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Tamir Duberstein <tamird@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776388289; l=925;
 i=alvin.sun@linux.dev; s=20260317; h=from:subject:message-id;
 bh=CEPawZ6sXIb2An8dSVvX8IrZi7UWboan6QZmQB4W5f4=;
 b=VhjBHoX9OG7AUX3/fgimlEwaBbhq84mQoNYpuucixnpKEzSkynw1I1YDpONyPwQb2ZxJnYiAx
 xdMwdIPQVOAAqa+DYmSyPAqlc34aXR+M1gMH67k4J5g01IGqgvkMwfx
X-Developer-Key: i=alvin.sun@linux.dev; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for alvin.sun@linux.dev/20260317 with
 auth_id=684
X-Rspamd-Server: rspam10
X-Stat-Signature: 7sbrhohwy9g1fxi8anh9oh6scxr4cdce
X-Rspam-User: 
X-Rspamd-Queue-Id: 64594C000A
X-HE-Tag: 1776388292-998170
X-HE-Meta: U2FsdGVkX18LFLXhMSK9SdY1yqhOPBfmGhAWo1FUVsnWHjb3yHWIcJDonLLd6jWjI2WcpgutU3FFxLgSRD2fNuz6wsBCY3xzqcVmXKvFlxyRXW9ArWOvCteApxc63dLmTJoJzbQNK2oWQ4X6As1IlGqWtDnPKpoww8/9hd+khjWBLeZZi2/Ck7PCGPv75ex4+Y1K6+0QgtSZZA1NF6e0Z+TQyrECVgQyuD+47/SK8sesNGc0TwxZwDLe9DIClypxuk3OiABAZZM/TrM6DTxJTxivxfrOT1d0Zb/xG/F/thaEwCT1m554h0/CTjsZsB22HWY8ytkqjALALIYbVojh/rrVSQRqB1pGHqecxdtmCJL1jS/mqGvQjQCISoalXF+MD3ZsIi2KdieQETAdt6JOcAMU/Ct0LtHhPKUfnK6fq+NyaQXvSsREjer0CkdZeZBfbehdawL2SWhZDQxUuxfoYSNdlCGMM2vjAm25SV937UjrcSu7RQ84lXOn6U0/22lkAUSI67VbQLgr9/yZoeqEJyulb8DgBUMeKGXn2brxyKUT690GqNROzrw1JVPh69yrI9rWzad9XMIO+zjMGELvt+gbdW35QAhhD2zVT1piFxSU+7TmgpM8eeL9ukvcgFw3RTG/W3rb6X0u4ZvCTiWt4epD7F2THttmX1oc5ysgplzpr4++V5kTJLs8aoEUwO+cmZ6LX0A+FHLMF10Hs7FsRMn5QA1aeLbhD2mUUiZ1uVqLIv8HRdvqh4f620kC2ixLFfTXWAS4U7DzbqmGZIwsDvlB+WRyjncGj9rOxGLPPsOfieDP7PlhvGs0xy/CiyAg7pOI3vHZ0DL9xGdAWgmlFqi7PsBZil/IiUwfLJdj2XiMKn4ESr9udjNN8PYWZ26EQJfQaiuNMkigzfK7YOs9Zao9xZugKjDyv+20mrlEcFe1uR/vvVK70A2NNRwB6AWaA2V52P87SPylgPNbW5e
 If3mW2gF
 wlWtfnrgUCdlwKx765W9G/56kiUUQSZbS9xXSh8eoUjbGsJ3oCddv2vxyxyAPJ9NPwFJpiYwR/JuaeYgUnM1Qg2u8TmtRYOJ+92pNjpNxnhKO0T3T9r3DpdRwG3HjMf3PYCuB+y2Sq9nT0gFQMQQuxAudLz1HTFCMSjL9dvuh6S4QOp1yP3JRGGJ0a7ujpDsiIetdc/xh59ZG1Fd4P05RjAf8zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a task_size() method to the Mm struct to expose the process
virtual address space size. This is used by the Tyr driver's VmLayout
to determine the user VA range when VmUserSize::Auto is specified.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 rust/kernel/mm.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 4764d7b68f2a7..c6ba4da52688b 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -149,6 +149,13 @@ pub fn mmget_not_zero(&self) -> Option<ARef<MmWithUser>> {
             None
         }
     }
+
+    /// Returns task size for this mm_struct.
+    #[inline]
+    pub fn task_size(&self) -> u64 {
+        // SAFETY: self.as_raw() is a valid pointer to an mm_struct.
+        unsafe { (*self.as_raw()).__bindgen_anon_1.task_size as u64 }
+    }
 }
 
 // These methods require `mm_users` to be non-zero.

-- 
2.43.0



