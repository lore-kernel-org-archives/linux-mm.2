Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAB03C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4CA16B0096; Tue, 15 Sep 2026 04:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7F76B0098; Tue, 15 Sep 2026 04:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDF06B0099; Tue, 15 Sep 2026 04:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9F76B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:03:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 187171A034D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:41 +0000 (UTC)
X-FDA: 85215257442.09.64BE62A
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6321D120006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m+Rxzqkt;
	spf=pass (imf29.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789459419;
	b=2RpwJ6JMF/2ZOKqmu+8sviI0ABWuMx//aBSb1cBO5hGINrLKXu+J1KEEftV3ed3NOM7pXx
	9Ci3WELXJv6radP5aFY0cz98RdwCRv6O2eB3a+BjjysyKnHpU/GkiPbYoPdXTfjv0JKELO
	lpW5o7Pg0rFKwpFLBp0pm5Vjd5/HMJ8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m+Rxzqkt;
	spf=pass (imf29.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789459419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
	b=reGan6+R5VfaE1gQYKRXebU32K7DZ2ZOpGWlaIreZpe7TfSVqNvTmXcUOTTRhGwFL44ksR
	ZsuvflqTrJFJ26METp9BhQR83U+rXJEz01pCs3D8Hk3fpaiyYXUQVlwSuFFPQ/roimXFwm
	Cc6gB8cyo778xD/TziXhc79vAkmkFQE=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48442ea8f59so306794f8f.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789459418; x=1790064218; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
        b=m+Rxzqktb1yY0d4NH8DAy5V4vYKLZagcQ9ffFUTu6IrFKUaYsgNtnj0Ufp9qtsX/4+
         ShtBH+Tm8By2QC/EdpnkOdCOUBbi714ktbhkgzx2n5YrJ7O7KQ6E+SZSSQBjpL9YbWHV
         Wp1I+/UoArzkhrJ1xBJb4vNbLWsZCj9YUZtVPVluxixg3yGNG9zeo+FhuI10FByyWKhY
         uWu63amKe8jnPy+kRiQ+XUkisNzUqLoDx4+KWMFVzBCpLsZTxk1oPWgUGf0M8hzwakBH
         W53LPVxHZ1tsbZOvTYAMvcaFrlUldaG2W5X0mgQz0d71BagR8VmKf7ARh6896137Qxxe
         Woyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789459418; x=1790064218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lk08SIy6DJ+jXcktdOiUfMwYrHwPBwEtrnZT5485SRQ=;
        b=b/upxlGDKhJU+jT325GGJkvqycxR3H8St6QXORF5mWjibfCUqlSOg2XfP7MO8QmDoT
         7gcRiX8JvaresYYQ1wdCmDK/Paszz6G6H1o791Or6IOP0xIzTBPq53qwS4QXOIk2iBUg
         b7aIkLc0t/EPmxFd71yarZW5gJL19t71yly7eP865+Bgm8pvKtQD3cgeiSZ0uo/9Ji0d
         twWsmEfm3hQ+BCiVcw+uR4h6+j1ThYBat9+TY7UJyD8M7199mFJCt8bipNswAxClgotx
         srC7FH1qEzI5EVS+vKFU63j+ywUUcbRzpDge76dZ5OhubmtPmlCL9+3WZpWwOZaOa5Nh
         eLdg==
X-Forwarded-Encrypted: i=1; AKwUvByoM85OgC2Gyy1FLFdYnaEYYF7O78o0+J4e34DSu6au1xwgNiv+d8ClBYRKzKH3Ds9OaN/ZOJt2Eg==@kvack.org
X-Gm-Message-State: AFuF++lvtHaVU3W+493C3+014/xOX7w2s/brk9dJM7PlW+bMsmcdH4rt
	BvwesDzj62azy/kHInpYhRncrKqn8b5WiLPQqiffdjHsNZZDLyUKLL7C
X-Gm-Gg: AYBFou3VMCb6rrlgNhrBod2d65c4b6Re7Pzlx5vOb5TKtxqaEYJSnMNULJWieaX2WNO
	pIzB+4TRSW8lJ0uq6DuFe5MVFSExseFCAN7Nl4GpiEn0Xi8df09x8S46nY7yAYWEVsrcwfZa4c/
	KXlgYyR4PWhO2Imk8T7HBlP9FBnmilrA0dq2WtWDqfz9ZXnFrRq46OV0E6NU3w/CDV0gcu2D4Fj
	VmOeJAImuzPIG7lUWCGTqOpCImMNeASkYX2aLU00BqvxOF5fa194JrWjLaVrw3XyDnpviTwPP1g
	zZd9tgKr+OR7xEcIX+5O4CE9RnoKUuwIX+wp3608uHwAOecRVWsP+qt1aLlHpFifnK3OlvLdAAM
	+y6Pg3SE0K3cSZiulDPcOXeBBdJO0K2YwTcTkxIeGNt3dh3L0Az38X5yCF2yT1y24kczc7iyUOy
	Qw+2FIqVB51s1OhvzOZijB+oKI71f343+jyuxwL3ueotUhFeCbs/GSZgDWlKYY5XSUPxrdbnaSp
	dr8l7Ddg4Roh+gC/GYRtlCQ/Q==
X-Received: by 2002:a05:6000:2890:b0:486:fcf2:fdf7 with SMTP id ffacd0b85a97d-48705b90f4fmr4013554f8f.14.1789459417409;
        Tue, 15 Sep 2026 01:03:37 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35c071sm33764675f8f.33.2026.09.15.01.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:03:36 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 4/5] bpf: Mark linux_binprm->mm as trusted-or-null
Date: Tue, 15 Sep 2026 11:02:54 +0300
Message-ID: <20260915080255.48929-5-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6321D120006
X-Stat-Signature: rgab7wrtr3izjrmn3d5jgqrq6wg76jtd
X-HE-Tag: 1789459419-26244
X-HE-Meta: U2FsdGVkX19Ah/tKGNZyEdWOkROaHgLdzPds/+GNlFkmaP2jz5QNym3vVUtQIPyaxb31x0pkopZoNoH2/V1Gf8NV0OffUcELEhwVDBkK/glingmHIwftEDg50o/G43azhFkB/FpQdgJIaXH3W7nWvBiUppl+TwKLuz3JZUbcINbX41qOnVXe5trUjoaIyJoUvs2d97svK3MqHcDRCd7m63NREZJAFzuPMo0DAyMzK++EsFWjV7y6YSb0OmYL+A+szsB/cKL+2urZZRKIsZr2YqKeExCDNwgJ+lfLKlNqWcqKR4ETL5Fkpct6qM7hC11HlvABGUZjBk4Osu3cAfkFVYPTLyteRrbdrrKy+hRuT2c8iUmlaGkgr6xzdgzJ/q9Ew/mfNUZ0TTirhZNh0fvx1+0/l/qu2+LbZ5CNm+Kvc2xQjz8Nsw5/Xa3KBa0XMtXkMNPGvqNOtQqNGeTBtdg0Z3wkCphu8ca16ycJS5+fsyelR4xzQG7gtHnPtEG4MYD2ekAnHY++WvOEwVSp/WvcKWIpMMZ/IoqGVwoPOidnILOoKAbJLwZZ3v0sftNtj6wFp1TfNg/eZj7pNHtjxUGDY1l3dhah/zrNbZHsOS3pBZWdiHbT4su2HWIOiPLNStcRqlYDlXGkujAwi2X7v+c2oj8G8NxdD8W76gQQMo+kq8CJIFkSTLA7tvfmVQQaTpb5lclL+KvXAaLeOxjfbxQAl3hOhzscscI8tRMQIRXGKT/LxOFrE50oeQH7HCKT1A96/SQKQ4UlKQ0ZdzwJruLlhqtQktGHWR/MhVKmEfdK7dODOwBgMth3DluST79nyAiAZqNGX/HuLPDfSYmF6t5gsLdOiGxi+A+/ma/mDCLXtd17tdC+u49XqA1CDkJ52cmPvGkf3+a5KQhVutsZDH+fthO9Tgx8TC8ysaQg8lg5RG/xFNTZvMrC7QaeAj3OR5eyynpks85cmBtSN/mthIp
 ZTMOLOmV
 rRwEsB/tqZez8f8s2XaUQuVUDmWh06FfSSRQv/HrqgmEey5kI1OMIOe83dtBewiAKhCyf7su2Lep0hNnspofB36IghDFhqyQAYffSjeLk2niNCKP5KiId0Cy/a6s/Z4vYGpAa4RbWVRj9Mo6i0JxiRgqCr9Ln0WFiuGw8bL0gxpUnR02xmYwqESA0QWAZ79ip57tT6BkHQN4iYvL00eF9EHjdJ6p94zn2o3RJOqkxHvIcsWqImNBA0uhFtaOVHmgWtJLfc/XobMnJfSRFU9Gp/Ynu5ukPQ2wriOkRLEgODOaEyr1DyOsfbMj0vOPEA474ePmPiD3pSiEnYJzGMTxcgo1M9pwusfQtrahFW08TIxLcYJR3NMvSrxE0mT0McdSz0uehkRBqgBc3bg+80JsRd8EAbApjVSShUX80b9++RGEXrQG2R5bfuWX/INsajGDz4e5vMZjB2uFpiIoQTH1jyUpVoqaUgkC6zEOMOHjcIrwXd9uec+yTb29fhNQ7JljRF367/N7Lfhm17uOHk1gYd4GAA2M2EDkpMui1dl+T/TrGU+4lWad0uGOv8UAyS4XpYf+Wol2n+E8ZewHpKJkWzSE4GpOP2Xvxf6mGF0e5NGvuptr3k5fpNCrbRw==
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


