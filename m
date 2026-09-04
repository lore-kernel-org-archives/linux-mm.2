Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC82C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4FA6B009F; Fri,  4 Sep 2026 10:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865D16B00A0; Fri,  4 Sep 2026 10:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707536B00A1; Fri,  4 Sep 2026 10:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23EA06B009F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:54:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D94A401E5
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:30 +0000 (UTC)
X-FDA: 85176375900.01.E0F413A
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id BE20B1C0008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BeI4yBDd;
	spf=pass (imf21.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWn588bvPgkOg4s+MpXI1REAHLgHCTvpnRnhLr6d9ks=;
	b=OMpRM8JIlkhmFzlgn5oiPDajorlrLVufTuEN4+8a4A35dIr5RFHj5NMdMzScgPc8sSUwo7
	tgoT4e/DYh0tMm282ZdUiaPlAHiFBXTeo02KdZiWlZgdulagE6qi/rI5g3Hu6ufD0oKv1r
	86E5KHVPHwMzKQpy1EUdwCeJnTFp1FA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533668;
	b=kgGJv2kTbu2mSHNePrgpf+t3zlw40ZQjy6rcvOK83L6gtIMWsFZhSbYVgjzbB4HkUVpL76
	etmOZKX3Za0Y7aicikxV+k3/9gMGSHyzY4EGSGhBwCGwOwvIOuR3aVxEiP3lPEni26v/c8
	pfAp8U2u8GoY24slyIskGPj8HaRqwuo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BeI4yBDd;
	spf=pass (imf21.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-484374f54d0so680879f8f.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533667; x=1789138467; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TWn588bvPgkOg4s+MpXI1REAHLgHCTvpnRnhLr6d9ks=;
        b=BeI4yBDdO0neiOzi44uEd2jli85jzMetnrA7oWYfaQDauZhweE/lXXpiASW8TkofdO
         5TEW+gKpEWfxoXhJVH7inCMj9ULdGR7qgZiG6Tm8E907N2sjTOyaW/k/zj/OLvvSz+IW
         PspXuLOCc3n/RqV4aiqD+rY8yfhhXCJkkf7y1UidOBfhNOwVfpobRtlI9NtazplJtiVa
         nnnAGw84LPCAk277GzFM9VJI/JwjafVd1vXTmRra3FZ7ZPsN1dWVRpIuvuL2tVo2W87C
         razfn2xS6R1ROeIGeFtzEOa4mZCgrrSaSVGyz+Ax8ZMSv5glGgZDsDMWvwtkttI8n7q+
         mY1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533667; x=1789138467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TWn588bvPgkOg4s+MpXI1REAHLgHCTvpnRnhLr6d9ks=;
        b=AUN6MNR3XIPOYK3TKk7QluoVxaL/nbq9CzJZmblk3VIzT1UW8E1OQoFsmUOmU/49Vm
         Naw1Nb3DqrmNh7ECyuI8Q2zL+yqMn8L/x0EuYSRkwS9gy3cfmdk0zl1HuswJX5fA2wnw
         3M/smxELp+YPJhAvvgZJ5Aq06e5JIbL078Q+/Bzg0ziVbp9yhFDOzVaw87P5TnC7SL+a
         KP6RfnV76qolpPiE9GIhmapv02UObHsJpkCVz9aYzTMaD+5rMN4tF7IuHRS656w9Y1dZ
         kNBVCl9+1c0ZUwO59DUYZiSmj0HheiCsaSQgatICwdDevkoYx7c0pJHWmxL5NfMP4nzo
         yjHg==
X-Forwarded-Encrypted: i=1; AKwUvBxZnXMcXlsPn70izTXPzdkeQ+NCSBF9kuQxWkdM3/HxZkn0kzviUyf00FpzqXW2qQNZwIn6/UiZlg==@kvack.org
X-Gm-Message-State: AFuF++lARTyrTkeMuohX+G/PyCKpxu6kv/nOjK+Ioiegq82U3scNvUcr
	PUvvQnnuPUZERIO/J75mALQY4+QUsHVFeAfSRT04mBhRFPBGpTzqdVhO
X-Gm-Gg: AYBFou06Sdztn3lgxQT6x8MLmSTebuLgFcUdrQ2uQNA4KkjPlIC/Es+ZvK9b698uTgN
	dD05lr7dWVgMga1R7EfXqvLfdb+QOEiDG1Fr/aYGkrg4/vYczjnevbWFL1kgJnnwPqxxn0mfXC6
	QHd9/BueKeeTZ6IH3KaVqYYmlq9Lgslt7LFkORAG/xn00Qa17jSw2TBiR94EdstXp1HXMlnvxjr
	/QWPZ1fHCdtC1Tl6sJ4BIAeupEYPHzSKshAYO/4JvyWam1oPXj/Fk3JAbcsqgqHui08Ao1gdqZ4
	77UxtncgdNu7/dENipYJsA1k0epFi7WwPNAKjN584o/vHZ1Ujc4DoElQDTfz+82QI0iwNrPHbQ6
	vdCxSbSN5TlEbb1SvHtgjXrI5Mw6b5a++JjsFKWVwGd6rzEaVjygnX8+jrgXd5vx1/yuPZPVFtJ
	L+AbybfubnoZiQISR9pJAawx2MTacFELwneTG+nicOWlo3bHqR/y06qMywwgxU4pAfKJHFt6i90
	Q==
X-Received: by 2002:a05:6000:470a:b0:485:8101:dc40 with SMTP id ffacd0b85a97d-48587057037mr5818648f8f.9.1788533667239;
        Fri, 04 Sep 2026 07:54:27 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885cb03asm6802799f8f.37.2026.09.04.07.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:54:26 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
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
	utilityemal77@gmail.com,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v4 4/7] bpf: Allow reads through trusted-or-null BTF pointers
Date: Fri,  4 Sep 2026 17:53:37 +0300
Message-ID: <20260904145340.40212-5-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BE20B1C0008
X-Stat-Signature: yyzwbtf6r79iz9jua4i578gbm6yc3zbn
X-HE-Tag: 1788533668-414220
X-HE-Meta: U2FsdGVkX19Lon7Po9hjrptmuLrkNmJ/76B1x3Wyvg6p82vq52X1xZFI/DQB37CZHBlLtngsNNgYX6ExUdfaVcvr3yWXG71iI/DlwzXNt2j5lmfpAIwdC6OBkVyz6moPnas2R5Bb3JEp/imXCTTgG6IyXwCVVcAwHivTNA5BJGYzt8FSvo+mlPYErjCKlZScrFusIdBi7y+pOXkS+tVXGJMyGJKypapAQcTXNe+5k+1A752AtLaUwAZEBU2L9GIxtVZ2SLhnA/GQZ3qqjSuQI08oCAxPXcDGT59bMM/paEte5sCrOztBlARJ9ky+DSzD3pyJUG4KCeuyzRw7ArHSTrPDhWdZUUqK+x8ylGMza1WTkHVpLcnomqurUnhdrrr5Jja2+VvNejrwJqtuPwg2QQ0auRPvEAT5reTUyTQeXbWtXh3J0JSLxjX/lhXkT1zXls6pz9a5oMkN+DIkrKSz8SxBtY/nkzsaxJa+EBFUGKSQPKbyXoGYUaKRzXK/fY2b1qKEJGPRj91OktMh+RrL4HWIWHUDv33JHuSxsXcBW5V800EkUCaa42te+wxwsHhEv0bTv3ObVCGTcXPJB8Z2/dTwyADe6kkNSf1WqDVcb1W0UoUQ/O90rqqxZzYFEHyZDFfg+WjqWFn/c+ZlmwFEE9BEdas9DIRzYE/3H9RC6O5FvA+FYU5lxOjvkwA1G0V9rIzjDBWINzBihf3xrog3NcXuNIujk84pJQzlfcTRCRXGzhlVxQuZG59f7/SZFswSPEuX1VIwUmaPjZwZ+53gGZbcbYrraZZOgG2DlJuS9VF1vmZxQNScRUQeSdUqJ15lYLhMzvlMxVdzFU8n9Plw+H6szgdFe4yL7Ql7w6zC4N/8PWSgz8w2Denl/rCht+ftVCsG545c+phnbLXwMbwq8r14u5WNJ+tqWVCvDVuflArfCP3v+Oco3YOpadMnkzAajph42lT8Ft8y7/wF51g
 BB4dgfXB
 gn5denm/qd6f01hg0T1a3PfUo+JVx08SFWY4yzey5KdUEjO+V0symwVa6nTl37Ohhtrtdp2CCOYqFZDjFCxej9aw827yXuPV9E8sE+5yQpaQuq2rwQFfgM/q8PCo+4PKW9I1RTLRmvBpUrPm0IOdDMrvL+y/MIGQqnHqeDJr0HT6ulsK6HqOi5klA/aBetrf2v1nNob5ABGhLXMq0PK9HMkJsQhK1nyVLlehXyuSMZhDGPCPZafXGBljD2J3oKYXCKu3dZt74G16K9JI1yZjA6VDFZnpSnC0cRJM2/fIXrDRF3WN89xM/aHbfxDQpGrDIKIOCvDGZ2eOacafA380TmfejDoKKU4mCHTrcNeaKDjxIT5luO/gmPQCKfoulmVVUqD7m7QeaAaS8duiokpRjEtAFsn2HT9q8UbulvwgtBds7up2a884ozsDBsPuROmTwjGgICHrqWrT53BwOlkegrAHB44fvxnFWm2Yv4b7hDVKk8Sy6cIvXR+3M5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, a trusted-or-null pointer
(i.e. PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL) has to be checked
for NULL before it can be dereferenced. Marking a field from
PTR_TO_BTF_ID typing to trusted-or-null can reject programs that
previously dereferenced the pointer directly. This is useful as we
need to mark new fields as trusted in order to pass those as arguments
to kfuncs.

Allow reads through pointers marked as
PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL without an explicit NULL
check. Treat these pointers as potentially faulting so the reads happen
through BPF_PROBE_MEM. If a read produces another BTF pointer, clear its
trusted flags and mark it as PTR_UNTRUSTED.

This applies only to reads. Other cases still require an explicit NULL
check. After such a check, the pointer retains PTR_TRUSTED and can be
used normally.

The unchecked read path has two consequences:

1. It uses BPF_PROBE_MEM, which is slower than a normal load. An
   explicit NULL check refines the pointer to PTR_TRUSTED and allows a
   normal load.

2. A faulting read returns zero, which is indistinguishable from a
   legitimately zero-valued field. Programs that need to distinguish
   those cases must check the pointer before reading the field.

The next patch updates current tests and also introduces more checks to
ensure this change does not break anything.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 include/linux/bpf_verifier.h |  9 ++++++++-
 kernel/bpf/verifier.c        | 12 +++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index ae9f606539f4..d3d7254cc1f6 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -1326,6 +1326,11 @@ static inline bool bpf_is_ptr_to_mem_or_btf_id(enum bpf_reg_type type)
 	}
 }
 
+static inline bool bpf_is_trusted_or_null_btf_ptr(enum bpf_reg_type type)
+{
+	return type == (PTR_TO_BTF_ID | PTR_TRUSTED | PTR_MAYBE_NULL);
+}
+
 static inline bool bpf_may_fault_on_deref(enum bpf_reg_type type)
 {
 	/*
@@ -1333,7 +1338,9 @@ static inline bool bpf_may_fault_on_deref(enum bpf_reg_type type)
 	 * protection, that is, the ones bpf_convert_ctx_accesses() has to
 	 * turn a BPF_LDX into a BPF_PROBE_MEM one for.
 	 */
-	return type == PTR_TO_BTF_ID || (type_flag(type) & PTR_UNTRUSTED);
+	return type == PTR_TO_BTF_ID ||
+	       (type_flag(type) & PTR_UNTRUSTED) ||
+	       bpf_is_trusted_or_null_btf_ptr(type);
 }
 
 static inline bool bpf_prog_has_arena_ctx_arg(const struct bpf_prog *prog)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8f585ceb2cd5..386401fe051d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6116,6 +6116,15 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	if (ret != PTR_TO_BTF_ID) {
 		/* just mark; */
 
+	} else if (bpf_is_trusted_or_null_btf_ptr(reg->type)) {
+		/*
+		 * An unchecked load through a trusted-or-NULL pointer is
+		 * fault-protected. Any pointer derived from that load must be
+		 * untrusted, as a fault produces a NULL value.
+		 */
+		clear_trusted_flags(&flag);
+		flag |= PTR_UNTRUSTED;
+
 	} else if (type_flag(reg->type) & PTR_UNTRUSTED) {
 		/* If this is an untrusted pointer, all pointers formed by walking it
 		 * also inherit the untrusted flag.
@@ -6591,7 +6600,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, struct b
 		if (!err && t == BPF_READ && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (base_type(reg->type) == PTR_TO_BTF_ID &&
-		   !type_may_be_null(reg->type)) {
+		   (!type_may_be_null(reg->type) ||
+		    (t == BPF_READ && bpf_is_trusted_or_null_btf_ptr(reg->type)))) {
 		err = check_ptr_to_btf_access(env, regs, reg, argno, off, size, t,
 					      value_regno);
 	} else if (reg->type == CONST_PTR_TO_MAP) {
-- 
2.55.0


