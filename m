Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0219C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D236B00A3; Fri, 18 Sep 2026 05:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55FA6B00A4; Fri, 18 Sep 2026 05:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1CFC6B00A5; Fri, 18 Sep 2026 05:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9574A6B00A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:11:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E4CE1C2CC7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:35 +0000 (UTC)
X-FDA: 85226314950.17.9EFFCCB
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D677140003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jpc2GY7k;
	spf=pass (imf23.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
	b=0k+z1HqgGcqR1YdnR49aJV9PvneMsihkIBaOf6zI4xXth4G3jmE8LR3V7oZMBZ9R5FqsSv
	E6hxoK4enKGb239jSspNgj4zsXe9ynPb1hALyQex/aJaGCVbj4dFYrLMCBmb/0Zuc06bVT
	fPztaOg4lxC1dB9bWasX1GUTOvLzMCE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jpc2GY7k;
	spf=pass (imf23.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722693;
	b=DROznADXpqm8mOvPSRWOuPay6wv4R5GIKKo9gHbSXoTdtzL9qo8Hf0M8oTeQ+3hmToX5wf
	IfeF1uyk96rGFfjLUGA9S+dBqx+s8n6AR6JztxMQwWZVj8wnlvW1SkbwkWldVJsI87hvpM
	KdK9DBwukyyZftNBNtr6vm0iyGrYiNU=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd38e0e5dso7012235e9.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789722692; x=1790327492; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
        b=jpc2GY7k/TfkNxyONIQ7z2jk+EFGXYN7MN1gfBvSJ73QN0UYmwi/Fv9aeNxl71Ronm
         /xe7IB6K1pvflmz8IZ1ue3JWyBsNtnMDI0os3p8ylQKvVonowz7zeipQ4ym4OgPLnrHz
         oX/FYtOo7RKEzMWsgw5XAnPw30itGcRYnQJiQ+O2eXfOvcBx2LYGATddsHnqCWwO3W8f
         HE1c6vUWuL0MvYCcorJFchEvok6FpwCbOjQaJKvZWIwGcZBOieu/rYhBUCfNEEdcC5cP
         9AoeyhIyt3dXF5d+6gekamN4Dmz1uSovJvHjUbgEaOIE6KZuidpXI3aIxQIe22Rzctoy
         RfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789722692; x=1790327492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
        b=EWjuU/yaBQPOfaVdKzKwJF+SdvtsTxWctpOXcIzHB6XtuLcVAFso69UiB/8rGgB2j2
         /1wAFNoEp+QWHTNRXcrzjzTtf6jvDSswpzHA03KopqKGFGEvNzPGuY3cCWApWdlNSCB/
         nIA1flVkmR/lXFcvO4Rx2kz1/u6ghynhuhwQKL/XdcDKlsI36r11gJV4/RZXqebUKaFq
         MO30xuS+JbaAru4EoxHgcHIzuD5Dwx2UouM9I67LRpzqBX+D2jIJtFn8GccsEc6xUsLH
         BX6lYb63RBYZ1+0Pf9fxYCtlDyLk3J0PCqzbpm5CrTG+mqu5jjdsqNmMWUQaW9kBq2YN
         C1EA==
X-Forwarded-Encrypted: i=1; AKwUvBzBvpbCCAm7/weYLni97e9YABczyiy4D3edFjCuLwm4LxT6sERVdqc8YD0YtrNkKdCVZ4OYig7SyQ==@kvack.org
X-Gm-Message-State: AFuF++lgsi/P3adyIuOtiQjvcsrdk6RElKf9c1yVdgwIEY7qZLCis1/E
	6oXVGNqSeb/5qv7kol+nr7ZoSTdvt331oZhKZ9Oe668Y1TxNbsYzIswO
X-Gm-Gg: AYBFou1k/krS6LuMiKnZG37abF08FHFYNrr6fZiPTHZgreDEHVjBdIMG+YxXNfkbrNz
	18+A78pvEPfK5uag8UqnhONTixWfeSb/08fnlJslXO2VZShf+sm1L6uXwaBW+nGL97J08+lOEsB
	MHArEtd3tqgcjgYQD1k8rah44d3KGAjynjQoCSP3ZnIcCPz/B77Q5tH+t2YwKY3v29Lfte4FgK2
	rCQxzDQwo7aBYVQAZKHOV/uGY0Z6kuBmxT8DzrpGoaQQ07gTE2IQw7I0/zaiSTF973quRNDKy6C
	FRJ2bj+Xqk/jH+0ymNqrPVTzOoymKkpC31NIu5M3aXEAzUDrCGzfGDrOU0CNvgkKF1AlZ92Umrz
	sZ6XLZFaB7mMxkVtlV/FZBAGxCbx8g9/4qzLiv1GxxDmt7OjIdXUC4IR0cd3yzOURczKe6HrIKL
	SqV9uceQ0/Vk3oVqxfJuVq8zWIL7sCO2unXw9yDhrECFNupiBXcQtgV0qSkC8DDUX+crYLqeGGC
	YtHF7CeJ48hreVK
X-Received: by 2002:a05:600c:3b0a:b0:49f:bd3c:bc20 with SMTP id 5b1f17b1804b1-49fc573b7a2mr19145175e9.27.1789722691708;
        Fri, 18 Sep 2026 02:11:31 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1d0978sm138774275e9.2.2026.09.18.02.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:11:31 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 4/5] bpf: Mark linux_binprm->mm as trusted-or-null
Date: Fri, 18 Sep 2026 12:10:57 +0300
Message-ID: <20260918091058.297740-5-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
References: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 75938tufnxspfbsas7uop8zdxmwsa3qo
X-Rspamd-Queue-Id: 3D677140003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789722693-555651
X-HE-Meta: U2FsdGVkX19H3B5VfyA5RBPBNr2N1f5y5PIoMWUmYo0DyuLYNgJevV1f4F8CGDg0lO9OATHGHBhnQ96inZtJpUp9CjejhHBGMkKCODeyqxGSqYsB5JFOkRQRl5+EBgXIcaDs4sODeoGUPvjqVgLmyiIIsdIt7j3sVlV587VY+Vmqc0uZq+SqGA2pqi/gtvKWM1NqPlEO3EAlpoZrkWj8fgdSwAYR+PubAfupTh+b6fJ0d6z8guLW+JU59u7ZErDIzs0R9cempX7igJXchJr6GAU0yQ7qE7yr2GRd5BRKmJ0VqeYloQpYaS0/9nmCCodhacXYP24rxVhF/DkT6xf90nO2yF9lyecUt5eZtfE/ZcsT4mtGqF+62PTZrzOXmXfgIoOON9gx6fK09d+lYocmv56CYJKy9pZ4Nl3ZxT8AOUSuTwX7n7GDEtK47/mFV/v2fwyQEOrpCWXntE3RyWSIC9yI5Hk7EdqccsoehmgBxjED1ASqWwkSQnBaXviwmBNhAgcgeuqJtz/9g1E7g9e/z1gCCRBtba8efkt+dmOFFDe97nGV42VHA1/dr1kGTjKrF9k5j+63QOBxrF8/fbqG18nzvU7ILGB/QflBDksIfz+hmMAPTVoFWG94EwuRvCkWPe1SxwszFLeYbyqSqR4wDKyysTl6AKwL9JSXpGrZsyCBsUcNhgMwrIyChC8YulUF+DqTaSExAINxSm/rtE++6+Z6Js2BKLKXRLb8qEuC2HakNAfiu0uqNFCfd7rCRZ3pelWUy2pEuwYsYrr1G5GiOkTkFvSuJq5KPJ3yC7OiXZCSaSXraVE01EfFLJ9LcFeynZ+Kh0eYQFtVx5Ook6gMB6Bp8NAd7GlUqQXEyfUC/ixGL3LImsAlc6429b7qzUsHqjvilgDVa/Pmd9pHNdO2mpXiqzLu/XpYfb31jouOeUWW4GmA28VVUnD49VgyASWmbIKKGCqgeYK5i6prXM+
 99yj1P2V
 nd/GLvqrHmKMsoc9XvDMC8WihOjFkY+m6bVrQkENEvhf6xGNewARMU7GhszpgPmiHB43GtGy9zeYlorAJLabU3dTgdGhqMaHL5JNdqfuPL+VSDnFEQOuHopV7V6I6F72+GGE66vj/SotNgh15ypL1UB0v2JB+AEA6OvdpYFmuIIihdevesNSgV2rb48B9H6iZQUulm359YBMUOrN7njjg3xw+7jH5hfOix82UwYOyXvxaVO363hzhzBW97P+TpU3oBA0yhFQ6XC/Kl1b+0g5SZm2Ru4XZBzCuiemF/9IQ2WfYUFfeE/9oZVvz+s2Dza7fKyyqwHa2OMWTq/IY8FbIJlB6WslK4RD76FuLkA4MdBlH1E2tLv2+Uaf0+wPPn2yLUy3wlHCKu+Qinq+uxN2Zsid3UpoiI6hihdKWkuYRH3wweL6UcOZfoBlJJIscPJc2kERf2E46B3h4VJrIjubOkE2ew3ME+n1jalnJOj7W6/zEKmDiDSxLRoWaklJJyzwyN1VwOk1F+10+l9Buy794spDgPD/ohpKPWv29IUjYGYj07tko8G29BfMRDepd1JhPzdGkXUYHDfzVvwElGp+qjAbh4ULEXzaK8hHHzpDHafO2pX1S08NYj0ZZQA==
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
Reviewed-by: Matt Bobrowski <matt@bobrowski.net>
---
 kernel/bpf/verifier.c                   | 5 +++++
 tools/testing/selftests/bpf/progs/lsm.c | 5 ++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6c6b8d8520cd..3539a768b921 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5997,6 +5997,10 @@ BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct dentry) {
 	struct inode *d_inode;
 };
 
+BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct linux_binprm) {
+	struct mm_struct *mm;
+};
+
 BTF_TYPE_SAFE_TRUSTED_OR_NULL(struct socket) {
 	struct sock *sk;
 };
@@ -6051,6 +6055,7 @@ static bool type_is_trusted_or_null(struct bpf_verifier_env *env,
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


