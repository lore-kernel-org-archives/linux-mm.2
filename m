Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BBDDC5DF9D
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB106B00A1; Mon, 24 Aug 2026 12:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934CE6B00A2; Mon, 24 Aug 2026 12:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBEB6B00A3; Mon, 24 Aug 2026 12:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51CB96B00A1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:06:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D272F1C0A46
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:10 +0000 (UTC)
X-FDA: 85136639700.15.D8A13E5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 37B0C40014
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Jc91idwU;
	spf=pass (imf12.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruNSXO6+hub5hhAXwMAn+u90C58s72NfnpcMVIePf5c=;
	b=S8JwqQvnhLGaJXakOnqQvKLtAQoFQ1NUF7MLYZ58NgNbxGtrEwlLUd005iWZKvlDn4pNf9
	GzKh616YuplCeYHJo2f6W/8bhD/GdWMpTskQ9ehePrQ+pkQ/erKw967NlWvSzQBrOx6Bqy
	JF398Im77ZWCVhX28IUHOuNlgXbaZc0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Jc91idwU;
	spf=pass (imf12.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587569;
	b=ZZ9FnZMWmJIuk98uYjUjRH+ITj3+hea32etyvFbWGxTQ9aaX4ZH0RLwtuP3Nh5w3NKQ2Zq
	eMjveQPMgzoLTIyFThCmoGuE5KCcQpBLVKVCXFpVTcYaNbrSdjGk+B7Iu3BMur9J78eN0U
	tO3vcOosZS+OFh+yrD+NTO5t8yRyP7M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 684411756;
	Mon, 24 Aug 2026 09:06:04 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0C5DE3F85F;
	Mon, 24 Aug 2026 09:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587568; bh=RrebhXATXwELFIUm3sfpDdh92ACD3QNlTwQzpg9AkNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jc91idwUPeyzoMBCcMqqcJfBY/NipSip+nx0Vu2SSHMLt0GB1cy1vcJ0XIHfHuDVt
	 ZfysIhqHXV5A+RsGPMQs5ObrYLtPAo5PLdYurj6y9VDAQ+21gPimS5kpua6pOqy5p/
	 cu3IO/eY89jF1Cl+5pzRLPOStBWlPPk/3hQnsiX0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 5/7] maccess: Batch TCO handling in kernel nofault loops
Date: Mon, 24 Aug 2026 17:04:51 +0100
Message-ID: <20260824160523.3907021-7-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37B0C40014
X-Stat-Signature: 3kaydwk6d5zifcb9x41497sf7eftp9kz
X-Rspam-User: 
X-HE-Tag: 1787587569-893374
X-HE-Meta: U2FsdGVkX1/xnzYmBU5BjIuv106sES+kCf+IBVMF3Npc6wjknl6L6k5wn3SIvfcB08KPmCOktUCum0Y0TLD9GDNMBu4px641krXgvd6E2c/AggSCWMOJRscabJGRsmCAUAUejnFeu+86pIX8ERqyJ+3V8M44s5BS+M4hVUiuTNnJLQ+UPAa7daXBsuDYP/Kumn/AzUDukPI1rhaRBw9UNSXIPhH0qoNTxA0KAfrAPGL5RJnTdzVHwRpRzurT7wqzxbIrsisYhssErfZa4gPSol4Is2oeys36GKd0uLdcJIoGOBrn4aGM3z9RoQLu1Il2SFcWuChrA4xT30kJtCqdI59WMf4RZQlTeyyNvEZQHx2d18ag6PWbXTz9SblXuQDgRcT/wrO8XsHZy94pTtjCA+IQ8W76nlOKqVhvFeVtL293jnRCQB670bpy6IMIixQx2PEBLe2fJVae6LAjQAGnm7sEphy3Blnx8xywT0GZb1s1Gu0qo68klKSSrw0PEoEGTzghZFX2HAIq2sN1UgfVZzO6BkHG56RYCSnP6UgKChjO4qgrqLiFNwCm92rULgtd/0Fx3HBclpYcD7VNhBrz2j63wdNDURAJlOdPbLvCygXkKsrFj6z0RGc+ZgtS5HfsmZue/XHajEqvbSvoQMnHASTT4U+8iWaTN9kF0vjyaKYK7RqFHHC5pc/+tXabCbEBgNl6gZApOSscBotuYAuuw71uGdwwbKw5nRqmFJRFVcwBMPa5yWjKJmCrJAH7qxjUTOwWFHwZrZT6RedPsyjZJMIskRB7lsVcT6NpXqjXF5AAhS9rGKdgCe8LN78PdEKE0Oulxk/2p5E3D1cMMw2bT+y4dejQ27c9st1Cc/CpTy0NfEKn6Y0AyJEUmT2hCowLIf/dZeabZc7QGqoIj0WzBvlcXAAv89VV7xONqtDHAoOW6psyO/vlOuQThRIswjQ2eORqadh30oNDdszEmlT
 eK9l2OF1
 8IAi9Sx411Df2Fvzt0IKaNMPGktnscaBFTB2fvgbD0LahZueGJiKrg13soqB5jKFG7A8h/MZaDjPsqSoH17xxqmSjzEXjML/oS5yKmXmZZrOqslwVKkS/iXqy8ulaj7z1n9nBgIHb/mTwoue/6+HIiFLv38co1lU6z1jNvCEUD5Spaid+W0VexofiazPka09/MrsRv5sHu6xNTMR1KotFfZ6A0MZxk9mMD6KNvkANtt9tZGVCuynqIZnFqRls+G3QRBmTKilwAacWbxeDgPiVb38PWPNNa8xEcCUBx3Vm65hMd7zwtdvSo0ULZfUnLwfqgBdTefGWxyJnlB28U+3bd2DiNsjIZDxkmYW7Q4Tnd+O4sN2Pl+5PLdYZai4rfScIjsp6Pig7zUDeBWPUyAurii3/xaFBal8jOvrn+MzrG59JqGRGka+Q7I8tEbznjBcFzf7Ym4qDTD0oRGUwJELIDqEhkM6zK6697P9vMfQnxj/6vK6ROkLKXUzXC70dWiPFgwtGwjEbR/muuu1vCXWVGcASeiW4x5o78+Mn0AmvdbIZR/UmrJ0gtlr++ahQ3veCd1kC6kwSITb7k8ofCS2dHdOvT16JT+4ZEaCnCxS7njLiQykP7hcJHEWH4/ICVacPKGT5ZIk2YeNlMvRy/Gdw+AHBloFE6BPAgfyr3meaMSWlgHetk8EoWTowcZd+cFS+OCDeqe7kc8gqEQOnATROHPXivO666OcPsA8SfKIFzkCJU5HMlFQPZRtxtWVoES7OsxD2dN5XHe9XJAAVXhquwgBmtVBjwPpPwG2n22Ti9LKzPUtnz/yW3WDisB+TNVbRPcvL9gvp2FQZRLLziuDcM/LjG7KeEXVINvqu1vQpgwYXavSc7gsn4ZLQhmuAgjL6uY0ftn64nR1Z32QxlSNLZL5//f3DoNbL3XNOyJ/69KB/QRC49rTmSncoHmKKQPTW0tnQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With Hardware Tag-Based KASAN in asynchronous or asymmetric mode, every
arm64 kernel nofault access sets and clears PSTATE.TCO. Copy and string
loops repeat that pair even though tag checking can stay disabled for the
whole operation.

Cover each non-empty operation with one bare nofault region and use bare
accessors in the loop. Leaving the region restores TCO before page faults
are enabled again, including after an access fault. Existing empty-work
checks ensure that every new region performs at least one access.

The number of dynamic MSR TCO executions therefore changes as follows:

    Work                         Before    After
    N nofault accesses          2N        2
    4 KiB nofault copy          1,024     2
    N-byte strncpy              2N        2

The 4 KiB case assumes 512 64-bit accesses. These figures come from the
control flow rather than a runtime measurement, so the time saved depends
on the CPU and workload. Generic fallbacks leave other architectures
unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 mm/maccess.c | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index f695ceefe6fcc..87486bf98d15a 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -19,7 +19,7 @@ bool __weak copy_from_kernel_nofault_allowed(const void *unsafe_src,
  */
 #define copy_from_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__get_kernel_nofault(dst, src, type, err_label);	\
+		__get_kernel_nofault_bare(dst, src, type, err_label);	\
 		kmsan_check_memory(src, sizeof(type));			\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
@@ -39,13 +39,15 @@ long copy_from_kernel_nofault(void *dst, const void *src, size_t size)
 		return 0;
 
 	scoped_guard(pagefault) {
-		if (!(align & 7))
-			copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
-		if (!(align & 3))
-			copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
-		if (!(align & 1))
-			copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
-		copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
+		scoped_guard(__kernel_nofault_bare) {
+			if (!(align & 7))
+				copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
+			if (!(align & 3))
+				copy_from_kernel_nofault_loop(dst, src, size, u32, Efault);
+			if (!(align & 1))
+				copy_from_kernel_nofault_loop(dst, src, size, u16, Efault);
+			copy_from_kernel_nofault_loop(dst, src, size, u8, Efault);
+		}
 	}
 	return 0;
 Efault:
@@ -55,7 +57,7 @@ EXPORT_SYMBOL_GPL(copy_from_kernel_nofault);
 
 #define copy_to_kernel_nofault_loop(dst, src, len, type, err_label)	\
 	while (len >= sizeof(type)) {					\
-		__put_kernel_nofault(dst, src, type, err_label);	\
+		__put_kernel_nofault_bare(dst, src, type, err_label);	\
 		instrument_write(dst, sizeof(type));			\
 		dst += sizeof(type);					\
 		src += sizeof(type);					\
@@ -73,13 +75,15 @@ long copy_to_kernel_nofault(void *dst, const void *src, size_t size)
 		align = (unsigned long)dst | (unsigned long)src;
 
 	scoped_guard(pagefault) {
-		if (!(align & 7))
-			copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
-		if (!(align & 3))
-			copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
-		if (!(align & 1))
-			copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
-		copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
+		scoped_guard(__kernel_nofault_bare) {
+			if (!(align & 7))
+				copy_to_kernel_nofault_loop(dst, src, size, u64, Efault);
+			if (!(align & 3))
+				copy_to_kernel_nofault_loop(dst, src, size, u32, Efault);
+			if (!(align & 1))
+				copy_to_kernel_nofault_loop(dst, src, size, u16, Efault);
+			copy_to_kernel_nofault_loop(dst, src, size, u8, Efault);
+		}
 	}
 	return 0;
 Efault:
@@ -96,11 +100,13 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 		return -ERANGE;
 
 	scoped_guard(pagefault) {
-		do {
-			__get_kernel_nofault(dst, src, u8, Efault);
-			dst++;
-			src++;
-		} while (dst[-1] && src - unsafe_addr < count);
+		scoped_guard(__kernel_nofault_bare) {
+			do {
+				__get_kernel_nofault_bare(dst, src, u8, Efault);
+				dst++;
+				src++;
+			} while (dst[-1] && src - unsafe_addr < count);
+		}
 	}
 
 	dst[-1] = '\0';
-- 
2.47.3


