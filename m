Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC953C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A486B0099; Fri, 18 Sep 2026 09:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3CF6B009B; Fri, 18 Sep 2026 09:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1096B009D; Fri, 18 Sep 2026 09:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585436B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:18:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A34F1406B8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:33 +0000 (UTC)
X-FDA: 85226937306.03.B6CFAED
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf30.hostedemail.com (Postfix) with ESMTP id D279780005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hBBEge6+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
	b=RnTr2VLBKRI84y9eCwq1VQP2vuvARfk7fiVJA7icz6gsdD8s4EGcoIbSST8QaezeoPB0zP
	z71L5LdNLmowLofHdP6zZEX3aJOi6us5mfplM5Aomo6zr3UzqRd94AlU93zdOIOBwoZFsF
	SrzaVbRZLE0OJ2iHdL+EDqZygMXYHaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737511;
	b=LwYgnORp5HI14FYJ+5A8I38msGdjJQql40lnXqC6ptVXpaMv8w/eQHapgq4GWHN8o3GUU+
	BtJj3Hfi8l3ef2Y2npzF6W9Vvzjj+Ul1reipct5hVmUIxT7eWNkQRyHB3xVmFiTpbqNwl7
	SHhW5dTstiUTqsvadBKE4t7szrdvxS8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hBBEge6+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f88so466833f8f.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789737510; x=1790342310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
        b=hBBEge6+dtKJq+LpxE7KVb/Wz5jzQGuASy1NDiEC0RocWSlaYz+gfBiEywwJEEzAzU
         rjJNnst3khClKGxDP8/ebTZQYADAcnFapQyZPabY2q6W/lriJJ/491bmYD7lGwGikh/S
         Bc1xD7ZWFPoXa7wnkbp9QmX0FZ3U+8kjDkLorlF6CZNHKvtZHnQqLAaqicmeNoBrGXK4
         V2vtBLewfmazZH/P9CqThoAfaApJy7r8Y01kE65/6YLYMB9yVbNeTw6PQkTxW3Irazwf
         U1iceqSiUC6iI44ZyOLqodsVWlGWBzZv4WzfUORLGVS/80s19Ghn6KxceuuvfaXg7S0i
         8qyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789737510; x=1790342310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
        b=12biAOOngNzRyW8/Osuz0kPrWWxZzo2nwaW/CsPPEsWqQJlO7+VNj1PffEVhBSIBth
         KSl5qFW2eU6ovcx5BHfNm98cDDyVYvm5OP5DMbQ+r8RdKHwd95wmcgPhusLMyL+mZI0W
         MzWwFJt5cfX/xgyH+btACAGybGKkts0ob1Rt8l0xGzfEaBy1bRGd8jUJZLSQXl+W/ot5
         LHM3cDkhf4MxiPYh8LEeDwBrFbxGRQLskEgaEQ4b0veyABoZY0su7cLAk3bNzAzad5OP
         jrrfYcHv/vOBjPO/vC1f1QQ0W/tNAUlUR8Cspd9sG/WQ/K+FoYwl93tjLhnNWNJVLS8y
         w8Cw==
X-Forwarded-Encrypted: i=1; AKwUvBwphwvpKOLbTn/SlUcEfVhpWc1oZcb9Ues7B30JgBBYCT5nrrL7H+vsx6aeU1bOgNrCqb7RyO9PEw==@kvack.org
X-Gm-Message-State: AFuF++n0BOa9i5PC3/tLusjiB17gsErHOz8zNNa0Zq0era2W+8CnyfJD
	0t5imzHQL3mxJlu+2cW0GHCZxkdFgas/89Kvpnnod+nwkWeqKwUMe/1+
X-Gm-Gg: AYBFou2q9XnGpwB+qtKw0X+izVcLUTO3405p/0Eci64bzPGlrwytoa7L9320Rf9U6ii
	XC/9ifeXGhL0X6GBcGx8hUL+mMiNHo6NsldhCqPBM4IcHlXTOiWhTtN1C2rC/dYnrtt5W0n+QG/
	gfNfX6UdJfj8skq7trwjoQ6ffWKY1tDcTowMZY2gE0sWIaizChmeDw2/Si1nOkhEGeq5Je1yz/5
	omsDZnxmH6rUIdTwC99Bd/KXYx7bC5buzKC37kfjNcPiAzeyYu399abE1JDFGioKV+DpXV6ew3Y
	FV54Km8GlyDVRoY6RKR38/SK+6HamFgqhm78DXHtjWQNBV3I6CscJkdYRZRpjOQyO0/gcq/8nrp
	g1JCR2oXfhLaMWLuO+LYmCi5aQE+Tgr88llH5id+R9XqL1o+jN/BrWHIhnEDqX57+o/LWyIzWPS
	MUh61pc9QyI0qbaILgMrtQYJFPTRoojkuobGEMWQrHz2pToRzlKMHY9lG6HDzGdA7/RajZp7m4M
	N05j241o535G94LDHFVh3Y7aQ==
X-Received: by 2002:a05:6000:491e:b0:487:84:96d7 with SMTP id ffacd0b85a97d-4871e373189mr3667759f8f.53.1789737510446;
        Fri, 18 Sep 2026 06:18:30 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4871feb5de3sm4424549f8f.1.2026.09.18.06.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:18:29 -0700 (PDT)
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
Subject: [PATCH bpf-next v9 4/5] bpf: Mark linux_binprm->mm as trusted-or-null
Date: Fri, 18 Sep 2026 16:17:56 +0300
Message-ID: <20260918131757.42802-5-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
References: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D279780005
X-Stat-Signature: rt4c8w88wqtehfh14fs5zoub9hgkk3j3
X-HE-Tag: 1789737511-489038
X-HE-Meta: U2FsdGVkX1/oN8aM/zpa+hDy03lMDqMwziC4tCRF7pLw9vsznGZ38G2ZVqpliNmEB2TGt6SKFZGxnUuJCSAfuTKC1kp8zqgqjBYqz7kvUh5f/wbvkpAA+g7kUpsJuCFhmmx2lGumWOrsDFqGg0ybUm8/zUTeO8L3Ez30snXCD7az4b/T9jXwQDDT5qum0ABEZwsr6sE7M2nwR7fjvxMVFw0wXP7/nOIMjWxfs5v/TsQiO+bVE9TIPqL5IyPyX3geMahDB5F+j7uY/4aWwbdw/hf+4VEAvE6BN29KELEHLwuH3EZu4u3OMhKQa4cQu5nQChzbaPfJPIO6yq6O+BQ6kadA+mKjmPyhzHEx7+eXmH0hU8dhfjr8vdX6ZHQ0swyAm+u2ZzBXR1QjKuJiY33vp+7q4kVGzkzvymRQ7qp4odpokMffmTOJlrlO9tfmk+n7UlHUg3tbTLE6yEuQzmh2cs1LO+mjNxUDxukOYEobRKeRhcs2fRrm0HW/z67MowcccgH7NOFL69CX1PboDImjbGRqrQa3FJH3kRLLA46WN7EUzxa9nH6U9zto4bax9dAICulnR+mylzsa+ue3LXw/PFTMN0BUxe9wiNOFdHXNU6rk7zulvtKxGdzteYOYeLn7wJn9wjsWxZBHG3+Ta7FNawXXKrY0JLEGn9MJaJxX/djf6Zkr8XEXdAA5BAqf9cR5jxC3sF60fUlGdPtv2qmBkJUOYKxZr5l8xYZUUxYCh8XmdluoOUmDor9GGIYm9QNFu5dXE6OsDT639V3p1YmHiAu/MDwpVwSmCOngWjLGZE/+O34uWp4yg3nktqGbwCz7BApHEai0+HmVA+N+4BFF6CnqA0aB2VIii/MXqWkdd//YRSYZE2ZcjWqhpLGVI6k1w00+zB2sLwLZON6D+AxmaY9STK6l1HdFY9hC3kNL/8XXPs2Tyy+ekupRzNuNB0jphLv5ySOvmc5ZTby2yux
 PAOmTjnP
 GrPVZv3q6GxERv6dC0MRp+/rnIiNeLA3p2MbqTAycXlP+/g7/DEAtGhrw3AZjFADsqkyxCQ4VK5mgA5dtUCFZV8jRVVaHNu0Wv8yFm9g4GdLGM01b7cZGlkmWulmS8cygnSsvA0Jv6s6LevziLk2RjB/wxOEH36h9CnHjpum1OMcInr/vVtWw5KirFLQgB0uymD9O5KOpvDH9Gwoy6bJSkiNYguNJ7nHELTvhW68ghgkBcSAIcp0xg2ei1fR9b5CkoQtVjy1+CjfzsA3DrjLfbaZIv33Eaz27jY9isdEF/h5o1/sQVpuLF3YhajRkzDOVzL+2fYtowFkFLcL3S6GKMrPHNeKOCX12X1zmHBSTfLT8SFUH+lWPa+WbsIo+jgYZHbWPfD7K9wekHY95Xb2h4twLjU/rr6oG2OLiODS9zf51kx18FPUwGvKLzbAS3enf3Bmr1ijPN919ry6bLsaSi+Jtscz+457iz+ebeF4tAqheEb+ZwGW0ludDXyRpD7MHC15F5ZypOcoPXjx48Am3kicWGmQW0B3J1v1pJi9MIRWPkV3mtHI5xSurM/ctfwr/D/t51d9zu6L9uymiXPaMbrrxR5eg+PnDVDgxcISCMQcAadDi9UWy3u29jQ==
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


