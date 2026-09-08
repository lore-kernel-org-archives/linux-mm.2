Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12C7C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8368E6B00A6; Tue,  8 Sep 2026 09:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7286B00A7; Tue,  8 Sep 2026 09:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FBF86B00A9; Tue,  8 Sep 2026 09:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 350E46B00A6
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D051AA5079
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:48 +0000 (UTC)
X-FDA: 85190738136.24.445E1F2
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1051B160006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CCr/Ykt2";
	spf=pass (imf08.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkB8DRl1+/pAks8Eb/LLAKOiFOjTpgaq+26U4zD1T/Y=;
	b=CemumsFKb8ErLMoYiNTx02ZkQWDooY+ZzMiwzDNZKTFjCmwI0TwtLkY4UzTlWObBMi+Ako
	aVMhfan2xM+KzjYzEb8o5KwKbFICUtmkbY1ojqGv6TPBiRLEqA+qNSigyAwP2IS/ujlVvN
	BgHAYEHQwipYwVR3zwe8RT2Y7GuMo88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875627;
	b=5YrTXAjlkwhTT0ADB3lQQUegygGcp8MU0hz2WdhpyddJdyfYYI0WKJ2Hmspi9KcpaI/yT/
	5wTVhSv2BM4DUMXRQOi6cyeqvIt5TEKDEOMXYLegzvqW8Kpiv7qT6yE5rUYqltTjAR+9Ny
	ujnd19XNpJF3Eteq9GClMJRg2Lj7WBY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CCr/Ykt2";
	spf=pass (imf08.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49b0d78a801so46905705e9.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788875626; x=1789480426; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EkB8DRl1+/pAks8Eb/LLAKOiFOjTpgaq+26U4zD1T/Y=;
        b=CCr/Ykt2zgcd1Dmr6XeSfbxwq8j33C3/252IMbBBblRwfzfQEOlXNe206lR26x7JIi
         CqrWPMbkWC1KSK2JvLk43Vk+6RfUy3xwopZHcQK5ywXxdNQRcLCYZfAiCyWXHY31udjb
         eeIp2TdHccwrc4rLy7pbSsKMpTNI1LkTZ1LhFMSzIHw+Upiz4tglHzoXcAxc6OGB6VCb
         i64cfSP54Z5jkrQ6fuzB35kGpUDQmzL90agWtyDbG5F5JchYdTDw9W/FNEGAOQYwgccc
         em5h/bEF3Tj/LjR4tngAz/GCToBVQVM8FFTMbjpOJRBkzLcG4LQMsax2S/Z23obaNSy5
         JBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875626; x=1789480426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EkB8DRl1+/pAks8Eb/LLAKOiFOjTpgaq+26U4zD1T/Y=;
        b=LVyMHtIO/5uJKU+CnxYgq/+l5Wx/OLtYxr4ZzJ2Tr0UdEiek6eQiexlntnDsM8MZU+
         Ck4ndWiWd4N8pmpl8ryZt9oyiwzQJxRDGZeD64Vg4zjMU2wupPwyZQeCVrid9JsVBO08
         PpO16LVs4qoDkLYJ7/DNRZCdAWv1Xc1iBSV+P3dEr0Pp4jkBPfzx13T+1Une/uUH1kMT
         KEy3sViA8Ep998e383SKC6oLqERk1amm+O5l9dT1BspqF/+MKFvm6xVTloUEIYuNtBgO
         9kHR/LN2i8RO9W9yELEXL91amOgilzzHBb+GXfcMhjlL+Jn5IXTjFOfKpvC5V/W9f6ws
         z3rA==
X-Forwarded-Encrypted: i=1; AKwUvBw5JOPzAr67n/6bYcOkc9QYOE0+n1lW8ViUbKXHPW7h4j8hLgDAOAQ494A5TlG1Ydvd+wEXkzByyQ==@kvack.org
X-Gm-Message-State: AFuF++lFkiQJv9cZjHYClVs083UNkFbwIOhYDRrhN5ECOAflabNDQ4F4
	hiofVzsIKBRJj0p1bAXkpjmM46Q2z0IWdhB/L46+dENSw4lyD8xudzeB
X-Gm-Gg: AYBFou0htsmfOl3jv8bY8QA3K9pHDNhLQobZgbZ8m3agxWsblgtVqR+h5EFdDaZOYqu
	fqmHtxYDQR2VtjJ2rJ+59IjwjdWNncSBw10mFQPnkjXeWJNSYDNjIVvldD8ss3k3ApjNAe9DJSf
	mmSA2o5SDyjdjdKsj+4lTB8fX9XP4JtA5HjucGoMJT3mag2sGAlGd6aqWxqbonbhWrr7nswwFnx
	GpIuJrrecGb/m2wjpB7WMbfC4SBz961ogUMWTg14afTRZgcD4rKobpI8kWJq4czsflkmCaCuaLY
	7dXG0ZdrqBceV4qjc/kQEa1uUEe+iaYfW/LB/hiYHZYk/wSbFGwWDnVlGeCHQAC4PUnx3Pfbahs
	WrjWQArIRXCzGEeJ397keYjNBUIUMqgr5JO9rleOk9FFqf7HpOfNX4eeCve7cDl7tTsxj1wUnk9
	uUIAa5hut26hr9joenNiHl83LuuMwzK3CeL9PqcD3q3K2cVFFLTjjQ3tjoR2KOx3G3ITeDwqpH+
	XtRvaxtlFlY
X-Received: by 2002:a05:600c:34ca:b0:49c:ee36:10fc with SMTP id 5b1f17b1804b1-49cf820e13bmr281314635e9.8.1788875625455;
        Tue, 08 Sep 2026 06:53:45 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5533ffbsm377235005e9.3.2026.09.08.06.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:45 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v6 4/5] bpf: Mark linux_binprm->mm as trusted-or-null
Date: Tue,  8 Sep 2026 16:53:01 +0300
Message-ID: <20260908135302.74963-5-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
References: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ihdx4c1138uzz7fojkqeqwdgk7nz6gmq
X-Rspamd-Queue-Id: 1051B160006
X-HE-Tag: 1788875626-716878
X-HE-Meta: U2FsdGVkX1+LVfGH6CdLJtLzuyjS4tjIofsG0wgyjqIficNoerAarvc9iu3VjxbRg+kbl4upJALrZjedeRjikdksY0hjaFkiAZi8TSjBdewvYwPmuV5bC5MiEBLEWi6Zf2lucL10DUin/q0JGkvJExx4aNEe4Uf7qEjNa+JDhWqkFmFSBqqo0L9FWptwsSWD8WQqBUTJjRQMNHxKos6ks9NBXI0b4d9NqYq5HMNk+JhBqv8+7SY0NfaiG/m8XoSRL99VuQAquTfQeSmqDfcN51Uc/n8C2qGTzaV48gHJXMzmV0JxuppNDBj3HwOd5ivcIGUWobhVXNpwZpJkMEkgKmziLwMM2ZGmDF5Ez/NoYkO2jRzUqcW211Yn1/N1eqrBKWcQ8Os5JNx+zR/hExuLdR6Sa/WFCMhlIHtrNs+UYGd0FDJ0C9qQSHTHHwtV8grQHFO+hVmdPGdjzuVuYV5QEdXULRtwgC6gvY8qIoOLtFeHzHTXArPNIV2LW9zFUo3NQrORvZKlVCHiye+I3kWf4kfhsy7d3wPZ8+9nx3lKEniM7I9v2dLvgxcadF2y1zH1V1/DJM/SOEZQt9Gj3U3/kw2SNuGBgkH3B9xy7056COqBVSJ7GB2sDwwIywlVJwKrWH2mvQuVIxRTZ8RTU5gu0u7m8mCnqoGGC0E2V0g/9wAq6m1YgJn6/iV+4swzN+Tcs0dlOhEUBadf88cEiEET3wDiYo1l8otgo65QjHaKIiU90MGKvJiJWaf/rEboKSPI2gwVtvq54IhZkRLHLPXN1+YkGVndoKZkoeAAol8ZMPgNkz4XTHq7W9zmLvuGTUY2a2LW/qvJEVzjF7+MT8O5AX59q7WOm4dJBk08wxylFt0LZGZIFzil33+6Y/Zbl6I2A2I6UibJh6/1Vdp3qFGirAXH2I6dKGZL4AyFnphc0temi9C0d3dqBkyPFq69oU+umLRniObivkKEXoqTudf
 RCrhEvdI
 YprMZDpogh5LxDCAyIPCoBdy846K4mwSMx9eCIeicbaBKV89K0psGTiwsS0BzXX09768Nr2mPIwr/7j8YfFIdWq8t4vtWnSeASDJLOF6pI9Xwl6/VQLS4x8xTIkZJHic9LAM6HyEanG1sfuANP5wrtW45SiWjpRl6OYBX3UcABOSRl4goFioxIKbSclpEB5ZoZ+OtN9ywUB+iCFacxtquXfvcUqE/zitVXK9zExoxnh4NMMol9ZsS/mH3vWkvFkFuoYPF5RDBkrP8cPGuHBfmnAQ5DZVaVNHeB2FlBaL3NJjKvIf4B3B+7YDLy+ubSevg1Oa5ytkUpxIC8PdWIjhuycP1/fHIKvUT1ocH/hPDo7ZW8q6n89KezxnO1u4sBvrbeo6+4WeG3KCBidIs9wxErBBh0km2dLc36xIRI58eUaeN9Oq0/iKPHnm/dH+okUFNDjvutdB2MsmqGfMlPNX0JA/n/vzfutrwcft5EUV3FqCgH+QvRmfNR5aU246mggPYQHEZuQjp1FiihsHSdvpck66iQ0x2Kf6FOeekEdQB4ZOTElEjbwfvNmAnA9Tyftvo2L9bNXSCnNtUPilwmI+vH5KvCB3dL057W93L53sFcFgD1cPJU8cqPLrFaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark linux_binprm->mm as a trusted-or-null nested pointer so BPF programs
can pass it to kfuncs after a NULL check.

The field is either NULL or points to a live mm_struct whenever BPF can
access a linux_binprm. On successful exec, exec_mmap() installs the new
address space before begin_new_exec() clears bprm->mm. The bprm_mm_init()
error path clears the field before mmdrop(), and free_bprm() clears it
before mmput(), as ensured by an earlier patch in this series.

Update the existing LSM selftest to check bprm->mm for NULL before
dereferencing it, as required for trusted-or-null pointers.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>
Reviewed-By: Matt Bobrowski <matt@bobrowski.net>
---
 kernel/bpf/verifier.c                   | 5 +++++
 tools/testing/selftests/bpf/progs/lsm.c | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9e79750e2480..791b3d25caa5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6004,6 +6004,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
+	struct mm_struct *mm;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
@@ -6058,6 +6062,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
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


