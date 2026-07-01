Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0914AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE626B00A6; Wed,  1 Jul 2026 08:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95C66B00A8; Wed,  1 Jul 2026 08:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD766B00A9; Wed,  1 Jul 2026 08:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B11D16B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:51:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2075F120380
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:51:58 +0000 (UTC)
X-FDA: 84940195116.16.DCBB7B8
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5F794160003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:51:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="e4HdR/0P";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of voytikd@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=voytikd@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782910316;
	b=pKDmedp+fnGArhbecjD9IuG3zMfBmDFFo2wfNCikhkX6xn5SGFEpGJZ21eDe+PXCCmCrkd
	IvNQWeZtbefy3/nC7BJX2yAQu0CR3hMhHCazN12hMNpfPk3WuNSiZ0vJNobc7MJB843NFw
	PnT/C0Hh9SJ2tfCYecU+uWxdCfejbmo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782910316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OmWDh+E3Ix3zFJalnxUFFjV5BfDox2wF4vd/HMlyNyM=;
	b=JCtZwl2Vp7iwgns69BX0jT/acAdGShsP2vJij6S/QUajDawWVsfyFi4KEi5GN+9nMXJBRT
	lrzQ1E61AF1n7Ay80U1IEIMqSId5qySy27fnyhk6/lRaemhAYcCc5cOLKvoWSEaVeZ3ORy
	0nRojJ3SgM6R9yzK3Y7bqZ1VmsflkE8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="e4HdR/0P";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of voytikd@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=voytikd@gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-472055b0efaso396052f8f.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 05:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782910315; x=1783515115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OmWDh+E3Ix3zFJalnxUFFjV5BfDox2wF4vd/HMlyNyM=;
        b=e4HdR/0PX9Ht5etqpe0am5vUr4bdTUslb9lbq+cS7aesf0EumIL1tz1p7MDOPA/kgg
         c54v9yr5caew2SkVxqkSGBXEgIDs4HLQmpjHIB5WjV9wioJ6ohwevCPLlmVydO6S1UVQ
         tEwMpxDIU5OSBATEJ+GCu3TVkhhQ2xL3sZ8QfpWuUmcWebnoMj1ZtPbUa4L4fmH8frki
         wnTnkuJ5Ew9lsLdTkuQa19W+GPHHxjH4O8p2t01MH8TGIk6AGlpEBRdNajwUOc7dkrJX
         sr5BU9UBgL2t29r4o/PeaL2ADFa1ZQqBbKjnle5+7qn3dmeTvOToKm+exgSsTs4y27sX
         tbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782910315; x=1783515115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmWDh+E3Ix3zFJalnxUFFjV5BfDox2wF4vd/HMlyNyM=;
        b=mUCXSFhzHomJiPRGid5JDMEdCfOmPtjjlxTgj9SY5dJaPifExLiZ/EA8/tvCmBoAMC
         8pzpcNZtZp+KQO8gYdipKErH37MFI3Jw3W9rwJoTUAz26TgzlvZ3Q3MzU/JtrVCb1jGY
         84vV5IpqS63DEYm9VMhZremVJPdRo2If2Z4xd11fQQ+SmAba6V5VzQ8p+fddHLhsb0zL
         9Qtf554A3nJON80Ethtx2GomOwqF0KhZOaMRgm1wVNILvDfKOkSQtzIeB44Bo3OpxRPw
         XABMqyjDOk/LfG1wY5SrlG71uzNGyGjvt6hw3e8fyryqd2cKiMlLVA44iruybz9gr6hk
         +zKQ==
X-Forwarded-Encrypted: i=1; AHgh+RpY4sjdlaMZQsHlXO9bqTAjyFOWz2bqy7gzxcKf3FfEEZAkLfI/KVgS7BiU5B63R6OEi3RTp7zlPQ==@kvack.org
X-Gm-Message-State: AOJu0Yze307+IR55jcHLplvxn3DeEzFfPcQP+vB5cPnhPpy4rLcsKIbM
	sesgvhEqTpqTVKVq6VlHnvE4MQ/fcTlWxL1nGaDHFK5xnc481AaLHSQX
X-Gm-Gg: AfdE7cnj4JqjrvUZayH1arWsow+qYQaWvNiM7TJduM0oReX6Zz+Cri1NkInBgsf9i+2
	zfZHASON28rrcB3TQ73ZEcuCOr08Zv47xTL8Pz0HW3fzf7GVCVpL6MltinPWOvz5sGAF2cmcXRq
	TKUuWHx7hSrTABA56FrE0Fyw/kKycHhnyWBtk3DQP1YDCPvChxq62ZIY4Xq+h75LSa0qPn2jgu6
	ks1thDfG/QL9BKTCxIpJS81olQWlb3O167KUiWE2aZhsHGfk1qGpTItGv4ppKYVkyykg8NPjcxm
	3ICPcvBjwDz80Y61Jgpx7O+gjYvHOcKh7H9mGtO3frXb2sB1eZnFbwCJzLoGJxvKq3F2H9Zar9n
	kj1r+mN0a8GWibCRNro1zRYfMHWq1UPYwxIOqXHi7WtZ6BV2p9nCvkzoRHKhB0Dz9aHCraxnUTK
	9gSmZzaIUTwmpXbwUrGWKbuEKW1g1X5/pq7p1G6OVGS9yvAoZ1I5f0yOzslkX68GmyEHo+p/yN/
	4FWO0Jyxnr8anG1lsSu1IPEsgc=
X-Received: by 2002:a05:6000:2406:b0:46e:5c5d:b2cc with SMTP id ffacd0b85a97d-47757c6e277mr2873893f8f.23.1782910314659;
        Wed, 01 Jul 2026 05:51:54 -0700 (PDT)
Received: from voyt-laptop-dell.fritz.box ([2001:9e8:bd55:a800:14a4:886c:f7de:bb03])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-475671d0403sm17665051f8f.29.2026.07.01.05.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 05:51:54 -0700 (PDT)
From: Dmitry Voytik <voytikd@gmail.com>
To: Alexander Potapenko <glider@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Marco Elver <elver@google.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Dmitry Voytik <voytikd@gmail.com>
Subject: [PATCH] x86/mm: fix objtool failure with KMSAN enabled
Date: Wed,  1 Jul 2026 14:51:51 +0200
Message-ID: <20260701125151.352632-1-voytikd@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F794160003
X-Rspam-User: 
X-Stat-Signature: daiq6rsiwu8339ih9fgee4ycb1gtzkis
X-HE-Tag: 1782910316-967223
X-HE-Meta: U2FsdGVkX19I7p0+l3H7oyN1MUXQF1zgd9QhLt+ibVpA408dmBU8CPBvQ9HOKSqjjiMa+R9y1j3uZ3tHr1MRg1uaa6ue+/t0Mw+DZjnx1MwUD5RltBIQtzQShJdshGQSt8/PQS6DSfnkKdWApcUffHsA2Q9UI9kVoId6zwVv117c99yGI00QwJVgfrRLDA7N8blMLv+K4SniIUrKXs70H+CxQ4T6IR+5oNt5ZZJsZYt11wu7rTq4f/bwDITUEKSmOj4EHPO0QfmimoczLKyYnDcRhATLMHmH97sgw2Bxgs/hKzCECvqOKGC796cQ758P0LnZdWCgTgc1k9+0Tltj5OQCmdRNcYamOCcleAHGYze5jtUVKnc17PTrhFFwR/Yc+r73z84C1/mywmo9KWUy2SmdgMUeqy+ckkzmAhwihGgWaiOUClrhqKsoKV+rGgsDlUim9znNA4ArqWqdxkMYDqLO0BisSB6HYkSvifDqOJwanWY4tAQ+k1+D6MEDQo9O5W4yWngEghINmnVzDCzbE1Y1sh/zXho6R+emjtiQNtmOjUA4wiZNVilPc3SFb8L3NZZCX6xtZbBzaGX775aJpZSxoo8S3kbgGDB7wrmOaqMn6jd0qQ59H1R9npa0yCxvNfQgQul7z+tGEn7Td/MeYS8FQS+GNpvmZMvHCtPHp4Rl5Fm7TzRn+JEU/cK3kTdcYyMLGJgC+B1elmVWOoxF80SrOaH0kTheFS2qX65BnXrOJvT4hNwx7Q46U5YAhFVVxlVLn575e5B1/z9pHzLf+mX6dfiy5fTE3kR4zRLEIAXLgojfXqCYuFkpmBnnoVwDGEyA41H/ghzIRIcIda0mw87gfzEHyZsksntcyhqP2HBPfEsF3wj0l8SaQpxU+GCkjAoT4OUti/0mrS5o2l568N3r0XQtkmQnxB+sgQ2mp4atusyLaFiCi1Iu5obcJhEwTYMx1eTN60SN+MRhBXl
 L5Mwu+1S
 BiuF1o8ar/SRT+RS4Mmui5BpN7eg1BCJlqFSKNlKfXJ0X9aPoG92d3/L52cY+BCKEkxU77xZJpbRqdtmjPbzkWdeLeJ1saQrUjsFcH4u/UwcRWVv+pDzxH0B9RvGcGs7xS2F/DB98emBu+4Gco9FqDwfC2FmAa4hvfaSF5+XfA/GgEmQuDkdRkqUuhaJlRxSFHDUkjYKo2tCZGMib9825rHRzzeQl6hn8A25f0bu3vPwYPXymExxCDIoVAzRj0a/zM4PgILycDN+GwwMyhPNFaRWyat0wqce1fy72+xz351jY6Ddpcr9ZkKD56iXi583DhGRApLvFi0gca+dnuNb3o0zfxkWpkSrriGgFAs9Y8D/1oXlmjv17wN1iP0FLOkWrsRCn9MqLp62Xz9C4PBRwDawAvXGVTDKi3LnX6qGr2PCOG272GGz8r8VrtsUvxXyv5DouRQrNCwnR4cBpgvSGrgQiMig+EZNbTKxxvo+kwr9PUVA8jQIH7BGR3qyPcv3oNP2DlWDRn5w+t9XXzV4c6EoQMw62eZIsI8y3OoB9zxKNTHVQb06Z9PLRlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch fixes broken builds with defconfig + CONFIG_KMSAN +
CONFIG_DEBUG_INFO_*.

To reproduce the issue before the fix:
  make mrproper
  make LLVM=1 defconfig
  ./scripts/config -e CONFIG_KMSAN \
    -e CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
  make LLVM=1 olddefconfig
  make LLVM=1 -j(nproc) vmlinux
  ...
    LD      vmlinux.o
  vmlinux.o: warning: objtool: folio_zero_user+0x801: undefined stack state
  vmlinux.o: error: objtool: folio_zero_user+0x801: unknown CFA base reg -1
  make[2]: *** [scripts/Makefile.vmlinux_o:76: vmlinux.o] Error 255

objtool in verbose mode shows how the frame pointer is omitted:
  make LLVM=1 OBJTOOL_VERBOSE=1 -j(nproc) vmlinux
  ...
  b15a2c:  folio_zero_user+0x7fc      xor    %eax,%eax
  b15a2e:  folio_zero_user+0x7fe      mov    %rcx,%rsp
  b15a31:  folio_zero_user+0x801      mov    %r14,%rdi
  b15a34:  folio_zero_user+0x804      mov    %rbx,%rcx
  b15a37:  folio_zero_user+0x807      call   0xb15a3c <__clear_pages_unrol

After the fix, the frame pointer is back:
  b15a37: 31 c0                       xor    %eax,%eax
  b15a39: 48 89 ec                    mov    %rbp,%rsp
  b15a3c: 4c 89 f7                    mov    %r14,%rdi
  b15a3f: 48 89 d9                    mov    %rbx,%rcx
  b15a42: e8 00 00 00 00              call   b15a47 <folio_zero_user+0x817>

It seems the issue was introduced by
commit 54a6b89a3db2 ("x86/mm: simplify clear_page_*")

The actual fix is to revert the change how ASM_CALL_CONSTRAINT is
positioned.
Additionally, reintroduce asm_inline to prevent potential compiler
rejection of inlining.

Link: https://lore.kernel.org/CAAX90H2_RPnZL_dFYN7cQF6yt-wAweKKSx2=6e2aZ0kv+Pm+NQ@mail.gmail.com
Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
---
 arch/x86/include/asm/page_64.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 1895c207f629..de8604f0a3a1 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -100,12 +100,13 @@ static inline void clear_pages(void *addr, unsigned int npages)
 	 * __clear_pages_unrolled() are part of the inline asm register
 	 * specification.
 	 */
-	asm volatile(ALTERNATIVE_2("call __clear_pages_unrolled",
-				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
-				   "rep stosb", X86_FEATURE_ERMS)
-			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
-			: "a" (0)
-			: "cc", "memory");
+	asm_inline volatile(
+		ALTERNATIVE_2("call __clear_pages_unrolled",
+			      "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
+			      "rep stosb", X86_FEATURE_ERMS)
+		: ASM_CALL_CONSTRAINT, "+c"(len), "+D"(addr)
+		: "a"(0)
+		: "cc", "memory");
 }
 #define clear_pages clear_pages
 
-- 
2.54.0


