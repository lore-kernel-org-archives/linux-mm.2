Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F19C5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4E36B009D; Sat, 22 Aug 2026 09:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683266B009F; Sat, 22 Aug 2026 09:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572416B00A0; Sat, 22 Aug 2026 09:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 224926B009D
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95C1016015D
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:08 +0000 (UTC)
X-FDA: 85129049376.21.162B372
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf25.hostedemail.com (Postfix) with ESMTP id CB75BA0004
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="NjZWgdT/";
	spf=pass (imf25.hostedemail.com: domain of 3_amJaggKCNIyF1z+46H4CC492.0CA96BIL-AA8Jy08.CF4@flex--ardb.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3_amJaggKCNIyF1z+46H4CC492.0CA96BIL-AA8Jy08.CF4@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkCM63s99i91p1PpHDumOCyyQdfuhx7OwD6Jd3t1Lq4=;
	b=nQpzsChNt2zhpdB9ExTHvB8UMFGfIiPgyOc6XYAVtIMnPMzW5vSpYhVav3LFpcV3xFrHPh
	qnQwpl+mwNu3BXt14Z08yVkv5e0YNVmGnpQgtaXkmTRhfJ4nGbccsEwvzLToiYdG+HyoyZ
	HfMSdi27I/k7CTwTtEEBVfngjLDlW6g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="NjZWgdT/";
	spf=pass (imf25.hostedemail.com: domain of 3_amJaggKCNIyF1z+46H4CC492.0CA96BIL-AA8Jy08.CF4@flex--ardb.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3_amJaggKCNIyF1z+46H4CC492.0CA96BIL-AA8Jy08.CF4@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406846;
	b=yBuWcu8PHXbKibtOyIbZmUlOPr3Vsp56a3PjfXofzCpRfIjAicp+81VxarSpT4SeiUiI7M
	OkMz+8GxCTfiROsqXFepr0z8m6RdUzm0v7SklDt80qB8G6QX0R7Qr0vt3N/AAUOiT9D8bM
	ElhRfvuqef3Ln/xGfFOIDmxoldMtEJ4=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-499900c9d99so14427975e9.0
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406845; x=1788011645; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hkCM63s99i91p1PpHDumOCyyQdfuhx7OwD6Jd3t1Lq4=;
        b=NjZWgdT/pW0ZV+KbUjyjZ6d9drqXTAkQr5IcAOcwU2oqVr4N6ejt6kT58TZctabSwG
         LCdsXbmOSLCi+Iyr2aQFGli1kl7lVi6SpLrD00Ky09QSq5AunuexiAelpg/HP2D6K+gV
         OX/o8V5CnL34tMoehAm8SjVsJ174sRhfrE4T2NxZVILvTqjnRwa2YfDV694wuPs+Ynds
         M1BkCiR0jzxUE5Fr4ZAigYa9Ks3ZtBI63vZPfyJswadUkzRFMxX0rOSVNeHpU02b0hl1
         BTSlPFn3tFYm+TIZ98DvZ9jbWcQE6f+7elVZRgB6FKwaVa1SilERV1T/dtPi/NarVBIy
         Cjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406845; x=1788011645;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hkCM63s99i91p1PpHDumOCyyQdfuhx7OwD6Jd3t1Lq4=;
        b=OwvK3jhLrZ5cK8HrpmXRlSjEcsi1DQz0U2Zwl5lRlN7R2IA75/pq39CMvj1RkpIKQO
         H53HXx6PjErChdAynR+z7xeXBHpoTxCN5y2F2ByN3ktecU9fjcM7ZlsqCo8ZCA0vxiaa
         aX6pCYzhuMQV0UhMIfdbYcuOPpPGPaTp8e+CrQBcVcvyDhd7YA+Y1bMDFSSbU6pZyevT
         ZXfySATFGRB1nj9dQIxZeAh2d8tNvSnyCwhOvqm/LtWLqQsv8uS0dr3DPa21LzG8ez5O
         pLM4Z5HdbfuYyMK7os/Y3+A2WetMjGCxJNsnAUQzjvFLnFjVLw1b3Ut3itgE1LENbTbJ
         WcCQ==
X-Forwarded-Encrypted: i=1; AHgh+RrsIp2tb+23sFo8vi3xfEdedLVkOuez9lp+NbDeVLFUvwUxJhk3lrESKuMAOOXIhl88XmJP090cwQ==@kvack.org
X-Gm-Message-State: AFuF++kEARRuVSJqV5kJ+ecOMaOslr4I8dSSrO08B3aofZzk2FaPq6pG
	ymkVnBrktF9LE8WR3JVDdIKDOhBUzHLQa69b/4r4BggTBhwC0ybZ9MKweES+k0PG34izYcccXg=
	=
X-Received: from wmsk20-n1.prod.google.com ([2002:a05:600d:8494:10b0:495:5b3d:ed8e])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f87:b0:499:5a50:b022
 with SMTP id 5b1f17b1804b1-499b830d220mr157713495e9.3.1787406845321; Sat, 22
 Aug 2026 06:54:05 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:24 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1777; i=ardb@kernel.org;
 h=from:subject; bh=P7ZGJgEcYK0LKyyPgb8fkUAxKeezm6n7kbgZPbKu2yU=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIatz5TWxr2KyTbZTbOpLO1+U67/Xi9h1eWvb4iPcl4w+S
 bRJZ7V0lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIms3cbwv5ahahdT+LH2cO82
 t1yDecoKnrvaJgjtU5h+/th0FT1bD4Z/Wub5/n96de+wmHSaPL+t1b4gf0nC0eXNz1JN5Yqla1c yAgA=
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-13-ardb+git@google.com>
Subject: [RFC PATCH 2/9] mm: execmem: Allow huge vmappings to be avoided for
 execmem caches
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB75BA0004
X-Stat-Signature: kgcup3nf1m5cogun3yb3ahmfxwx6gc8i
X-Rspam-User: 
X-HE-Tag: 1787406846-989672
X-HE-Meta: U2FsdGVkX18thwlsaMa3HYRWksXb5Z8y9j3oC+FfGKkjDxirHodhZgIpwM7cbGcdjaIqWWGn4/4tRZ8t1DWoj4M1+BKl8lJiNYwwba2xTl+agjvk5DO+Cz9H6bDW2FP/NZeZTVtDzw5Ba26kTaB/HhTA4YcNpUqVEtz/jli7SipxARCHtPlbnmr/vv+0MMs/IMGzF72Dhzlz53XlPBlpwNxsdkmVWMEEE/V5a223fyBT3wfGLpcxT/5wj2UZET2NEz20a08lCJxsazeHAiC2FOK0tlmoRV+SPLEX5H/RsO/LyhhtMwSic+zFKBOQqmav2nemwyvupAcKCig/ZJVCT2ixmM8F02pKVM1j9fPtfSlHWzu5X6BKTrjuxLzlHRIyRaPRaExDnWPP7GimAvVLLw7Y/ZswHo8Od/YF5ZO2BnS++L3hegWWl/DIaG7nYa0WHOcqSSYwfiS9TfJ9DAPVu74AyXzcp4fD+9oWcqIGf146FkWNTRuV54b8GcdQ6sBV81XFMNl6TWobmS0/k8BjXo6BCC0PE2EJc6QrkQNqXI7msKiO1OYytJlUWYUta/UpF6kDSFT2YVYuHogspF2gfrCw2W+4f4rW60Wsr0OnLW3hJrhZJgk8pk9G8fsZjX8isOPPR8yHYtOlyOz2E5WLyLkCKhffpLNbN1B4qWkKLPByay1WfL2E4PEt3jjq6HezcuGrbs1KMpVi8VyKRyGrdtLrOymNr/Y0yPqL/CPi31oYtCWGhMgvLFU57R6sSYA4Bwoijlh8nMjxfpweS15jcaDsrLzB0e9TP7jzvsIYAAour8qlubFcpoj2SgM4khjOt4hv2Io1LqMXZNQUdOvWap0mzkYMNz/ifrQs2SS0M06QqqnhvIoCwYnon+/LTBgK4yEmFWGIWVJBO4WjuV4plY6s3YAl4QwreysZ5YgLZh6+ALqF1sHikag6YJmhBZtt2JijPc//G2hy0un5q2S
 HHT7NtW6
 SMkPVyQIhr7SGvnoupAIXMyjvHfRjcfpx86MC4zejiocdpFN3ZWBJvVRJ4Ub/wyWFSUgRnzG1AYsVDtvv8ZTb105eDi9FPHR7YfqJoxFyaIHJG1blZEhHN8VEWnyvzDTIkVKq3U+t/dXzYWdWUoQwqSsTmlmdxkLfDBdJbEqBueFBii5OUbVJLw8uLfhdGBMZ5hcnWotjP6D5es/GIb2AI3QmOBXTCZyzpPbOQZWKsk6OiEQ813yxctsFA2xU03190eXCEWIEGkqe+KLzgzg1J3W1c1XVVc992Mf9pGrZfYHoXGnq7zcoGKCDVSe5f6632xS9vO8ae7u3VUY/lsS1GxqQzwmGeuRv4O2bAAIryyAT6GiTkVY+gP7Etkx+XFgotZf6CnH5ez0p2ZkpEVMlQ8wY7OYskILBCoK6G14HcfVFK7+Civ25yK5W/vORUxFh//3hd6neeh3GIigM5yDq0E8D6jx2sAt4Kt0Y8rG5WAUJJZXd2CdQsF3EUNvWaGJAht+4koxvlUQX2VxKgzPGqzy/JRool6naNfmvLgtDJRBtVbw2V945scb+6Fl+dgwq2AnroJQZm0uDcWhu13JHDjvRxQ0/NL3gnVPj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Only recent arm64 systems are guaranteed to be able to manipulate the
permissions on live kernel mappings that may use huge mappings. Older
ones can only do so on live mappings that are mapped down to pages.

In order to make execmem caches work on arm64 despite this distinction,
allow huge vmappings to be omitted when allocating the caches.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/execmem.h | 2 ++
 mm/execmem.c            | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/execmem.h b/include/linux/execmem.h
index 59bd862cb061..b04926f3fff2 100644
--- a/include/linux/execmem.h
+++ b/include/linux/execmem.h
@@ -48,10 +48,12 @@ enum execmem_type {
  * enum execmem_range_flags - options for executable memory allocations
  * @EXECMEM_KASAN_SHADOW:	allocate kasan shadow
  * @EXECMEM_ROX_CACHE:		allocations should use ROX cache of huge pages
+ * @EXECMEM_NO_HUGE_VMAP:	cache allocations must avoid huge vmappings
  */
 enum execmem_range_flags {
 	EXECMEM_KASAN_SHADOW	= (1 << 0),
 	EXECMEM_ROX_CACHE	= (1 << 1),
+	EXECMEM_NO_HUGE_VMAP	= (1 << 2),
 };
 
 #ifdef CONFIG_ARCH_HAS_EXECMEM_ROX
diff --git a/mm/execmem.c b/mm/execmem.c
index 6db0c1d82a9d..5790d4a8532a 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -276,7 +276,8 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 
 static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
 {
-	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
+	unsigned long vm_flags = (range->flags & EXECMEM_NO_HUGE_VMAP)
+						? 0 : VM_ALLOW_HUGE_VMAP;
 	struct mutex *mutex = &execmem_cache.mutex;
 	struct vm_struct *vm;
 	size_t alloc_size;
-- 
2.55.0.860.g4b6b3295ed-goog


