Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EEF2C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4606B009D; Tue, 11 Aug 2026 07:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7B3F6B009E; Tue, 11 Aug 2026 07:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91A56B009F; Tue, 11 Aug 2026 07:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE1F6B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:22:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 038C3C03B3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:49 +0000 (UTC)
X-FDA: 85088751300.03.C3D8160
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2E2BC4000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:22:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PwH5hzlX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdXY11jYOJOgDrqsfvB+3m9H12a0vELp6Tr1U8V4Fak=;
	b=qzCEJsnjcESqZKWoeo5eZzVlVjrxSwMIWcDu7hUtmuzCytLC3RibSMXXxYeVTdWzPIewiD
	U7ttCVz5GHWANW/9cfFyzggJ7XD79NI0LXEY6TuFPAOO0pVBRJ4BFr+Pp7oFcBsX4Uq7Wu
	HxBs5PYOIEKSDj0m2AwZmVMEnTH6YUc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PwH5hzlX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447368;
	b=G/W8bznfRLVMlkRE/rYwlYnrZZAwVhWw8wbbTVgCnRwUNpy5IDmVKoYMu9HOeK97Mtkwi/
	btW8iYen6X6RNwMlXYhaN9wrkRU2WsYrI6TUbrHYNNeQfexJVPrBmwcUlbIk1MpuQy+wg/
	cL0Qv3LCMcGucGnrJftft/mfztGz9sQ=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4996f1ee4a4so16430265e9.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447367; x=1787052167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vdXY11jYOJOgDrqsfvB+3m9H12a0vELp6Tr1U8V4Fak=;
        b=PwH5hzlXsOKxZdnq+kuhnmnoGzfJs0sLlcpRgkPKeVEdIUtcVyfh/ew/UBNah68dcC
         cAaD+/WBMrO/UsHv77Lk3B65ipwV622UG3MYBH51x3AAbFZTEQl6Zh+caZq7eQ3PKH4G
         /v8lVwlir8xmpyN8JXfyLeHEcYSxnBJwYle8siY4lPn+LHQKcYzCtah9a+6XamFgsti8
         IiEPLJjZVnC9gFeB/GPIbWtmGLhO6ls9sx06FyaMlY5JGk0R8B4xGxWXlwrpfh1DDqRO
         p+X/0fcy+7hykuN7U8jf1PTXTixZxcBf8Qys8X1fE4Zp+dJ2/oFKRKBqw1aiehx8qhj0
         bjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447367; x=1787052167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vdXY11jYOJOgDrqsfvB+3m9H12a0vELp6Tr1U8V4Fak=;
        b=OfmRdLhIauwTzUzX6MVnxxwK46WsOEb6uW5eOZo7S66fShXpGlQ2AWBGRzQXbut6Ja
         Gw55B5rwv2a/y3+QFpQc8Cvo3+/kOv3suTqK8Z44QWsOj7+m/ZdWAZhwzckiCWqHCHOj
         P3lAc5byniOJVswQv10CXfjxIkG7ZRkPztLkbsOCsCpXx983A48v3DZ0YM2r02pYSfBE
         R4/8l2bXChfiTm8bV7uSi+xo3yNKM9vO1KQhNiD2A4oplDIZozck6AISogfk0OAML4b3
         dQyEsEzUbwfrmUflgbrcLLDCLnnD2ZZLpeh2waBSYwq1S6UpcmGhqgXJJiascgMnsbhX
         frUg==
X-Forwarded-Encrypted: i=1; AHgh+RprlRqhH9OA48zNkSs+LodM21ruLSlFLCNc5j/JpOF5Bevh1xpQpbmYfousAO/cD5/YPLHlwuPYXg==@kvack.org
X-Gm-Message-State: AOJu0YzWDiZTgLm2NrBFG6pt6Zhg6FxK/A5YqBDCbs8UY83iJdEhsu0g
	nnBI9FNhV6FsBUacdc2At6HRzQWzV6FO9zotkJD9yyqqAIhUVcMBlvGX
X-Gm-Gg: AR+sD10oxjKSwHWE2Ppeza8jDrupRQ4I7VB5o+Y0tgqhPw2SaTcFPkH6o9sx/7EEEeO
	Qj7CkxbMlVlNzTCbKJrxkm5hHB3ySsMi3kXJZ0sXviW1r3yrphG+wMqmSyQevuwZP+FJpMzM2gt
	kJOud2aPZJHm8OcAGVu/Ad7r6s9gIZ2DnfYzXKH92ayvMfUQgodXXQrC4HfDYhW3Qq8snGAqBk2
	tZ3I94bQ6a0oecxWwriyaEn/f37b3S/Z7Cr5Znx/1TjgIuRjhGY24oftOjQ2EIPYyqk/FmZvC9c
	Ioc58HXTEGxxL3c8KzkzySB5etnC3O4S7ip5i/1VC1OL2STKI/fiE+ksqu7BQULoUoRKZEutbs9
	hRqXU+HW3z/z6I12WttTOdiOYT5T1VqNeaGJTlv5/yJGABxVNjhOeVT7uhvhVHtHHQSJhFf52Kd
	8JExfcPCuczUY6EPx7YTUqtJEESSuHatunf/Yd54kJfjzmK8UmDP1thNZ2atdwUoTahcZCK4Eve
	lmX
X-Received: by 2002:a05:600c:1550:b0:498:952:e276 with SMTP id 5b1f17b1804b1-499784358eamr31222895e9.8.1786447366875;
        Tue, 11 Aug 2026 04:22:46 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997889c2bcsm47547665e9.3.2026.08.11.04.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:22:46 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 3/5] bpf: Mark linux_binprm->mm as trusted-or-null
Date: Tue, 11 Aug 2026 14:21:52 +0300
Message-ID: <20260811112154.94053-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
References: <20260811112154.94053-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 6u4ctntngeokc74y98qji475d6neqpkb
X-Rspamd-Queue-Id: 2E2BC4000A
X-HE-Tag: 1786447368-531556
X-HE-Meta: U2FsdGVkX19m0ZJCv/01Nyhi1/7kSM58FQhG7jRm7yiKiKgVQ5ld79N07H+QRJJxRIITAULz+Vg3crzVgbgkaho1Hno/X5CqbRoJgBAaDsqf3YMdOB173XpDROCMD29qY2oZjZfk+OP2Yc9R8+dXupeNO0v+kMw/9OKZXleKEO6kvIfsdJFVUq6DVFHz2UOWFAD5OtXzAC/1X5P6tF+Ei9quAI+FG6d1Jyn66q22QfV6nxiJXrhwHyqP8aOpx6nwH4IHaO3Ka+W7cTX5FIVAJKUwfFcqBEIBW7JzOzU5CO9YqVHATgtuT/LhgJw/Fv1Esj/6zk72oFWuMu0oadnMyFj8LUEgz0TFDIH9p1s/++0LkBTxNK73m9uVsoY5gxyurY7A1Ab9z6CyeZz8ExsmW4qFWs+528FHuQ0gl0h4CWUe5cd4lR67+Nxb/3wgR8SeRYTXviBsAj6jnpQnK9Mu/MAd2D4D0Fl7BgvnSpPFr1gSjq/cFfo+OyMEv+xKzfGsMpBe8aCicY5+HgJvr6jCcqm8uZ8ktNih+oZVCzQ7niYbF1u3p1X16mr4L05bG/m6CGEHsPXiNvvUPmsuIW+Yh9Gd9kf8yebQcSHe8MJJlJ0DnQaqFe+ZimYm4nkw6cw/NdID1G+JaDgj/u23FUDzT5Qg2BIHEKM3tans5FLpyq2FuLeDci4+vDhgtKYlNnJJsa/7JyNYmtgB+K/YWLxAtEU9Aum1xWoe/tBnhYzHFSMbnb5YtinHHSk6kCyRwD8gtSI7VSb5vw1LQmKKZd/Fz2loMa5qp+ugIC8irsgmJtee4BXNTjCu4hRyO/LIkFHXvx+8V8IyoKpLuYzxU2STbUsgiFXfUyvoblsoJldoARvV/o7QBqauhkvmqO5aCPmZ5QP4RnrT/ZcvNpdv4fI6noh3ncEhVfuVsGHR/NY1XkJbWqKvu6htx6jO3HeO1PAQjwjDNEAPpt4PYL0KwTJ
 H3ZHRh+Z
 +uDHHCsKzTkYeXN4VVqyYJlAGNLmTj1FxQjK91wDzouOJcsglhd5jhxlV5Fa0HZQCYGe8a/Xc8U0bKa+mgjQ8q25Nf91lWs3/FignDwdmkLs/H+NFLjxm071gJxDWPn9QvjU/VbI+vPNqn7ZGSQpVitNutjibzTL6LZv7qxV6DLHvrcL25wpCuw5G3Q0tquIRr6Dn8KldUAaqme5KEbP2Sy+WJHO6VX8PteHa4OEuDGzlhpqyngU7BVUnFP1v8nH9dOco6Jtbue2Xv1ruxMl+1/Qln2aN/PdJhy9VNY08R1kMJEPDqWoNxYs143rk1qt9gImkwivbOG3zH8m9Kf1iEtgnpRPWKQf74cQlVWc3ExENl8wGZpM1Kt8spNvRRdHmGeYZ9jGcENdP0T0UWlkIhhVuQLYzxnhzSjB4NjQN+sJJW9WioflfolOYr1bdyQn8YCAPhOGO9eR3iwAj6W64w2miypBJY9PzDIwOHR05X1Bntwt769ytfOGWkLodLrQOvAdnHbquUBbcSEzC3cSuuOdvUCUXmrYWLucC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark linux_binprm->mm as a trusted-or-null nested pointer so BPF programs
can pass it to kfuncs after a NULL check. The linux_binprm owns this mm
throughout the bprm_check_security hook and clears the pointer only after
exec_mmap() installs the new address space.

This patch also updates the existing LSM selftest to NULL-check bprm->mm
before dereferencing it.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 kernel/bpf/verifier.c                   | 5 +++++
 tools/testing/selftests/bpf/progs/lsm.c | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index add3affc5703..8bdcb65618d0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5682,6 +5682,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
+	struct mm_struct *mm;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
@@ -5732,6 +5736,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct vm_area_struct));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id,
diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index 7de173daf27b..7441d66c080c 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -113,6 +113,7 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
 	struct inner_map *inner_map;
+	struct mm_struct *mm;
 	char args[64];
 	__u32 key = 0;
 	__u64 *value;
@@ -121,7 +122,9 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 		bprm_count++;
 
 	bpf_copy_from_user(args, sizeof(args), (void *)bprm->vma->vm_mm->arg_start);
-	bpf_copy_from_user(args, sizeof(args), (void *)bprm->mm->arg_start);
+	mm = bprm->mm;
+	if (mm)
+		bpf_copy_from_user(args, sizeof(args), (void *)mm->arg_start);
 
 	value = bpf_map_lookup_elem(&array, &key);
 	if (value)
-- 
2.55.0


