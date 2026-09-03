Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4931C624DE
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 20:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D68C6B0092; Thu,  3 Sep 2026 16:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE496B0095; Thu,  3 Sep 2026 16:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E8A6B0096; Thu,  3 Sep 2026 16:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 305FF6B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:37:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C4521A0642
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:34 +0000 (UTC)
X-FDA: 85173611628.07.C71AD3E
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD4A4A0008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:37:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="I2p6Q/Kh";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788467852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TnjfNvCLnsTvxUWLkyT6RSPdRaY1HQsFa2V6exB/dnE=;
	b=1lzoPppc+ht0S/DjRuZtblmqzWYE4BNSIFMhAEJ1OGZngDWUoFBBtaalFrvyl/dNTh2Noy
	U337yB6KQZHKgl4Fbb8aibJwHr2fMs+84fCDyWetYod75YeW0YRdrr/zJot8IVYPc+PdJY
	VfLWhPXJ+SpKdJC0PPpMYVoNBZEEbcg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788467852;
	b=xHgi38ScNFOtnRKMbqoVplU0F+HacCR/xzVryUlD0v3FglaOE2MKM6NlNqoqB91kyzOCag
	OUC318BZpTf2rWmp/k0TuwM2flhArQtg6/9CV91zQjl9b5hHcOT9Dz80nMB+yHjSlQt9nb
	0j+EJdA8s5hGqsPZnUdeGsBuwP2wzgc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="I2p6Q/Kh";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48436251906so335925f8f.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 13:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788467851; x=1789072651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TnjfNvCLnsTvxUWLkyT6RSPdRaY1HQsFa2V6exB/dnE=;
        b=I2p6Q/KhxY51CHeE7TpBdyneyds0qbn7Ce8Q+Udx08Zm01eXodEPBwWlnvhaxIUquz
         6VOhiwVpQyxcp6H0QFZVnCEQQ1aAOKIucB5HqfwutGhWHvTF+rANS9v3o7e1oGdrMDzt
         e6oWefhSshJdXzb6l2UaGmwYFNKIBnzDmtpR2iiKEU+o7umdfJxa+qEyD2zUz9zt0QcI
         WNb5Pc0Jfc4c8vvb5TJ6fGKBgQl1aP6wAwjTzkcYT/QaqOZQA81bVjkUbarJ6PtgPhMI
         5Ue6zITedCPaaKXGRbENJ8mQidCOy4zWHRrg4LIGX4xBasyS6dgo5n6geFRwDEv5Ljlb
         zNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788467851; x=1789072651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TnjfNvCLnsTvxUWLkyT6RSPdRaY1HQsFa2V6exB/dnE=;
        b=dTFMWM+gzH0iiBqisurG6pF7xiAFlJYkUWrKign5pZVTwjEcBzaEVvPiDWtBolxF4U
         cByicZyiYk/3gy+uZgt4kzDFIAUicHKzaNCOlPXeJQZG+ILKpJ/t64GiUnXprz96+Wzv
         A/D2THwXhAyTAKHLHqBWr3APVQB82L/9MNbT4+8Jvj8aP6IT4L7E2Dyi+P5wkwLecT2n
         2jeqFqo0sBLPXEn5AJhzfvR+tcUX/OY1Ffnobm3SG8hfnBjPOByEPOZpBnISmeGVq3xM
         Q5ZgSw+V3v8IxHaP7YjUpe0eBh9HnJ03Qbv9SSHGoXYbhfTIrigip4NU+MxFuZ9AmwSg
         johQ==
X-Forwarded-Encrypted: i=1; AKwUvBwBGHyrTJ6oB8lDjUcu79L3oiv3p+VfRNd3iXoZUv0Yg7DPi/NPH48Bi3AGK8UJ/lLdc/KgV1mbOg==@kvack.org
X-Gm-Message-State: AFuF++kgbagoLwZIPorN+31OuPQ/gAHuaEqKf6EdbXAKVUhdzwjVX8Ql
	uyjCs6M8LqE3WRBQk601rgNNhyGldQffDvKYH8yOhubKmoUXYY8rhiGm
X-Gm-Gg: AYBFou3p7hy01A/zhO7dYtJz/HpZDp4qml9A6XA/UQ10xVlXy3GgoO/UEkoM7tpZFwB
	qK5OkmWCoFbcGyxO/jSeDbYaOtSPXVBswV0D06/p/x9TybMkmjjWfBbEc5GHhYOaXWAsdwLLqfR
	zFzxLQgATI/IQQYIuZMkOkULhyPDLgavWo2OF4cKRL28sPE2xLhZecQdknJToPTkB96NzD3wrpA
	8lv9wm7tzGlJCzA2oRDGAWn1vfTbKMX2wWS5GhQyvnFFzyXHnYHgu7r/a8lEs+l5vxndI2xCiuP
	AhqioFu2aH1V8WoEGamvf7EUvvhb0FxnuZk6Fpcfq4H+aOID1JqUEaFTGKiobxG+/mTTncylA5Z
	ZYLKtMogY7nvMOs6FXYYtTT9mi/MAxhHNWye25aQut0cfGOpXynxdgw1jgXVOtOt2k5XCNZ45MK
	GmtBypumkCkKmJP3ssazGCU3ostSHKGEu6CUbW2qeH5hoTjrlUpoaZP21KIDCurbWZlV8XZsJQ4
	nVWUfFV6m9ufGxmjM3Cq1qtoSQnjiDTlFPNd9y2/7fMadl7BISWDV0jwaTaFCMl6J9Zaw4gZEmE
	azM/VvqtzzrbQfTiuzCpgrxqEEbnjfvRaUfE8aZ4HO587yr+GjPDuoxrAPdXOz0CB8291gu5MFG
	yI7edTKCU7z+ZSU8a
X-Received: by 2002:a05:6000:4b11:b0:485:8313:9f47 with SMTP id ffacd0b85a97d-48587055d09mr3572292f8f.10.1788467851379;
        Thu, 03 Sep 2026 13:37:31 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a979-9501-3df6-d7fa-8a5a-06c5.310.pool.telefonica.de. [2a02:3100:a979:9501:3df6:d7fa:8a5a:6c5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm1005070f8f.8.2026.09.03.13.37.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 13:37:30 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v3 2/5] slab: check for ZERO_SIZE_PTR by exact match
Date: Thu,  3 Sep 2026 22:37:17 +0200
Message-Id: <20260903203720.63689-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260903203720.63689-1-kmehltretter@gmail.com>
References: <20260903203720.63689-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD4A4A0008
X-Stat-Signature: 6st9ur7xdeuesaog7kb9nqdnddjwpy1q
X-Rspam-User: 
X-HE-Tag: 1788467852-146512
X-HE-Meta: U2FsdGVkX18zqGynjRi61EPeqiLaiG33pjHJzABnIiQQXv/c+PD1sX3vkZFeViR8fXT3Dl6ZBSOACOaGLTJx//2iNjyizzEqjsmzkDIcV6soxkGWBO8YfXUfe28SwtvJo5lMv5LEIwwMPZKrWTBmJUo//8oW7NdnDrX6DGFTPC7EAHw9wys/Emrs4F5BrMg82XA33AKqjuCtAaesJnDn04XJ3F70WfWd+CdAe7YydvjtiLnfQe4SA/ry1g+1OixAp1MfmTsbIMtq8mOwlI/+HH3fO2lqJYtdoanaIrP3YLMTmtRgMXJpTEFyYZvHvYm2kRsxHsU/Z+4ckDeG4/HxyDOytv6yX0Nn4jVW+0TqYQ9M9cpqNEKa7/hW249Gqr45/8RfZ+x25y+HmJw1K5DYop7ktUbElnF16m53n2OA6fSRiTXqi1m85ss0XfcddnN6gjjJ7qWTvPI/oPjLzTfP9K4/3t8pWQyqwDdfo7YEfNAEeEdOJJmgZguG3aowCDHOboqMBs7Or9a9z2KnXxJI9JTFJk7OH4P8Fak8Y9TFVQ0Wop4OOIiRhmAOj/Zh3KlUztWqQ3CXAsze8/SqB4nCIm6OaI6prFHID02Upq8Y5NMlyoBeAg7UfLV7H4IN7nk5YAkdaApZL1vci9lPBiPTMwHbzI57UofTptMddUqaA2fqKDjI429gOgNpFYAlvZ1oKdh89UNzTQ/g3xPzu+zS5jCkUxvY3+qzrkGTahJZhQAWaP499eNRt9ptrYs7lv9/PY64is57sddCeUHMWNKnsWuA4Cht/iRg83VOAIyqDC/tweDaHe/2TbBjVVT7gno2hfNsYL+DUjiiufhIyn+Pbv7y+MS8gC+AwV+x3WfFBmxBNZVbLXHeBJuikx9ycCZMXUs2IoSlJcqCqPCal2kzmKwhjcnTbpOaTwyJGcGxyNXEoMbNc/ntOCx6MhWDeRzkpt6P8UhKgvVaGX638sL
 LVIdXLi5
 BwYb9oPGBAkOSAm1rNgBvkU63IRX0uehMEZSlw8HA2v3iNCaTu1B9ibT8JWJXMqgJey1YJjNI1LRnqcbwHhiek+5YTlnp7ixlHAu1B5F9sQipCPvaIP6lM8ACcnVjNlLLVql33yngWo9LvXd1BdFc+qJwY9mmF65G74LIbVJzomSr4Xljyc7+zD2yz+5/OS5L09NxgQrlooxlLB+5jUaBidRRtaC7yrIHti0fp0gkxZvWw76JnyDJRqAMvuvGhQ7RUaWObnb5VSt4ml8p3WKsN8OoPoZ+Uz3TqGmSMrS7FhfeRFAfjxUliw6Ft0/30V0UijDOVxTRlAJRLRF1t0oWG6EjwqEON4Rcryn/x6YQv6730o2+wkO0yCuJahcmMBAs2NB6K+tb9a6BnAE6DcNyvvaKWfYUkve2zZWylN53OWjeqfMcVipHe4SG66VhvckCrr/rCLfw7cTrXCn4Xtmdb8FU4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ZERO_OR_NULL_PTR() returns true for every value less than or equal to
ZERO_SIZE_PTR. With the sentinel raised to ARCH_KMALLOC_MINALIGN, up
to 128 on some architectures, the helper matches additional values
that are neither NULL nor the sentinel.

Compare explicitly against NULL and ZERO_SIZE_PTR. Store the argument
in an unsigned long temporary to support both pointer and integer
address arguments while evaluating it only once.

This also changes check_bogus_address() in hardened usercopy: nonzero
addresses below ZERO_SIZE_PTR no longer cause its null-address abort.
The rejected window was incidental to the sentinel value: address 17
already passed the old check, including in s390's mapped lowcore, and a
principled first-page bound would be a separate usercopy change.

Apart from hardened usercopy, direct in-tree users apply the helper
to allocation results or explicit sentinel values.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 include/linux/slab.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 563dadc16d82..458c4229b1d7 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -273,8 +273,12 @@ enum _slab_flag_bits {
 #define ZERO_SIZE_PTR ((void *)(ARCH_KMALLOC_MINALIGN > 16 ? \
 				ARCH_KMALLOC_MINALIGN : 16))
 
-#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
-				(unsigned long)ZERO_SIZE_PTR)
+#define ZERO_OR_NULL_PTR(x)						\
+({									\
+	unsigned long __zon_ptr = (unsigned long)(x);			\
+	__zon_ptr == 0 ||						\
+	__zon_ptr == (unsigned long)ZERO_SIZE_PTR;			\
+})
 
 #include <linux/kasan.h>
 
-- 
2.53.0


