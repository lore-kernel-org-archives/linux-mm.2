Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9062C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1F76B009F; Mon, 31 Aug 2026 05:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6936A6B00A0; Mon, 31 Aug 2026 05:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5829D6B00A1; Mon, 31 Aug 2026 05:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE7B6B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:23:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DD2A160421
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:53 +0000 (UTC)
X-FDA: 85161027546.12.F10D251
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3172A0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=axqEam2y;
	spf=pass (imf25.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agssTkVjz/VQ+HpJevjjY5hRGfaiF2JHVaDNy5Qphm8=;
	b=aenh1MtR69c/Y9xYW/V5YPluq3xj+q1MyTrOiwgKh6DAcFZ5f7pKwCOt502I+uNjWYJgq6
	Xsgx5sCZZWPK56mLTZ/BA2mCaign2fyF1NDkNh4VAEPzu+GjV4BOTUKeJz9R012XTLTkLU
	JEajN31vvrEe8rbc20rE7dg06mTN5+g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=axqEam2y;
	spf=pass (imf25.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168231;
	b=P05yuvkoXvGZyVIM2WHsqvu8GpUpuo0P1n7q+Hhmc03TqTaALpWbzkZ7bKeY3XDjKl0KF/
	3EYyct7AJ6KCrYpwixCT54EH/Vk6HJM93Qp3ZazhAyBCPYVU61TyvYcEueGoBLk0R9v+s7
	o53SewFPFoDc78EgmudXVMIWqyHIj7E=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso29647565e9.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168230; x=1788773030; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=agssTkVjz/VQ+HpJevjjY5hRGfaiF2JHVaDNy5Qphm8=;
        b=axqEam2yLyIw9rhRDl/zwBlloHxyP6IUoCdKPFqil53ztyPh4laXD4pZL+8sGwf3Z3
         jWJjJnwIbV3XnJxhZ8DjVWy7WEjUfHmWDCIJAhKvjHYakqPaSF5NkSWoFwNBlI/dkxj1
         fEO/3S7DJZPlO8VVA9kPe9Zk9vLM8LBSIovCz+lSAkPtblu7kN0NcPP1ouiyFLeO51KA
         ceTu4Af0vw+DH1uiE4jX7lLuRwOk0/urWPN6j7gmlGyNqkYrTHTREnY8WZb/2sxRSnM0
         dJ2rZXBivU2k4BhfFmNsSmgwj8O/zzX05gWNEeg7GkY6gc2dNyQkSiBAGMU7UlbajeHf
         VjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168230; x=1788773030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=agssTkVjz/VQ+HpJevjjY5hRGfaiF2JHVaDNy5Qphm8=;
        b=UdzIpA8aQ0wCOKBqM3ruacBLnJbWfBbKpA4bRiBkqyWWOZBmUaO9WaOMx5XKFGeNH1
         GFBVA74Z1VeAdAIqcvEtJdBocGGI/LdXlPxklVYIXrNJMImbT+Pz3ag1nYQG9EMMJtwQ
         x0fs6uFF5DjcxPuGBRrRmJE4C6lrcOOnwyUHj3OkdJWszuXGkL1GywzT0ZWUoKxQkxi1
         Wn4WTHXZ8Ph08/cLOysy/Zt2PyotdWvmdxF6RZe6O8SlSCR/d8ze0x/bB5FGIxL9OY2n
         w8kzpEB5ZZgz96IgoDOBjGhavexbrsVj+GfHYoOoYUqLzPGJRrND0L4VgnT6CdUVyzxK
         AHZg==
X-Forwarded-Encrypted: i=1; AHgh+RrwbDVkU9DxN2T+AJlwMMjH//LsRnomghynYNWGiXqh98aL3BXNXt8H2VLbIce5ld5giz0Exomo0A==@kvack.org
X-Gm-Message-State: AFuF++kKCswSBP1aeAS5eA/ghuCWu4HsYAQmXigmFOIpjjn5n5AIN7VT
	5cTTCF4YfVYX+brTnOOKsV2H2UzFCUSvWRYMCGuo/2Cb3ZqLuytS5NpY
X-Gm-Gg: AR+sD11myqiFdYRZ+YIoC2ag/Cc4s2hT3mpoDqrFRTzYIVMjEKNFYafLWU30OPdsxHx
	Y0N7eSyKgsniyZD6a8SVxUo2I76sDH49RmyydCNFFMFfow8k46IJQ7/tvbI7f4tS5rpQgjYi4vC
	9hgD4DVoWg2i/USyBPZpx3FivKJgupYVUxTFvR3Xhv2R+hI6EBeroOsnNkQytLhpal+69Bo3i7F
	hXLgEYZuS/KfvnPf/x6/aNMH2ytvXscAaagWrVh+gFKx77IVPPEKyZ1C7gpBmUzbLaPlr7+K2m9
	43tUSePad9SVqjl+dUENk/GB/TpwRrQ2NIeh59vTDtOZHC1hmzGIJe2KKxpk2JEK76Fidnx3+vy
	84AnR82eo/0sqG4uwOmWBbcNYG+xrWUkLAkVZ17vxiQs+Xqpkg8VHnCiYB4Wp0xZae5/5p+PMBa
	8JWaeX7S42kOGh6kG8cjhSSoKPA4iCvYHsrBFTm0WAQSEOtqgIb/wRQmgDdYuHitvdCYM4/tFbR
	w==
X-Received: by 2002:a05:600c:4585:b0:499:b402:6c0 with SMTP id 5b1f17b1804b1-49b91c265d7mr347797155e9.3.1788168230352;
        Mon, 31 Aug 2026 02:23:50 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm318248155e9.9.2026.08.31.02.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:23:49 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v3 4/7] bpf: Allow reads through trusted-or-null BTF pointers
Date: Mon, 31 Aug 2026 12:23:02 +0300
Message-ID: <20260831092305.42062-5-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zg4my5sjddrwakq7j9qkznr8i7gnnpgc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D3172A0006
X-Rspam-User: 
X-HE-Tag: 1788168231-984500
X-HE-Meta: U2FsdGVkX18i11EghyjugEnmI/F/xbmkMhP7nyVcO5Oqd6bx8ILfs6Un+o4Fh1QT02If+19DqoAmTDQQJkrZsKB+MPGLa8kiD3U6HHLvJXXfLsqwKjf4T6yUprdZ/nuU+L8yQYoKlqHf0b0JmqxE60YooxnGluERBw80W6//XzQrMsXjjCQ8LDqb+IWvN5AsRmgyPHoZFQIGC4oBFyZOrDayXhxtEI+pT/+QhKUpsB84SnR07PB0LBkyL6UDr2RkcumMTEPLLd2VDwBTA7OiL3HuPkRU1Og8i/0LVl9QXouCDQGMwTFnk6XSwL86EDiYiWS/HSTiVppeljJt+iR/T7pHirvMbWesiN+S4b+VhXH0Y6hJzkyI3Rr1pHg26UVCAolVxE76Ww569l1fdH6YCZB21f3DGSYK2J29xQAbuoID8HoFgviXcla2irkHCaMcs6DBadNNfgY/f9/a5ox/x3T83JaQLTvwRrTFQaHopXHrqZqjGWxhnczd+0WSTYv3Y0C1iSfGEoKZ0W83SJ8ozO28KcettAd0q0p/vlnQVWHnlITBLOjGavsmTLVzmfQLLs9l+Oimw8A2vAV8vQ8p7TeYzIHd8JnIthg0jMHN+280V5uvl5aILQzKwCccbH5etE1q7oubI0cMFaFvWiiuEktVgWP3/GjNd8hYJilFhodhIUWYV2rBHl4LNZSySgljwYOPnY2cnhgvoV+qoii2hkJ2uQRaqD/9j9R9FihQVNfyvqDxCVL5rc8FQ6cWlrKfV76MvDPq9rIF48uayubL1Hq2Hrkqbm2zMgz7S6LZiVC6YuLkwXvQairtgFBuE6OU3pr9EBUa4HPDUfKSj6L3UPuljX9etPP7YLGV9HvAbzDBGgwikNg85YnBzPip1ZImPXblJH2P4/l8Vdsol4WgEYPOyzuC+5UU0IeoYA1jCTlsfxn/QVa397ygs7ViFQAQIGzUw+MdorBEZ+9Qbpw
 ach7KGe8
 3bQPc4k9n13N4sqaNpb/Sj2ZOkMrUUbZlhgfyrgPy05QSumgWKRGWxDZ9Xb9unan+eEWOs5PTOgpEb4uQVTLUR6Ax30R9J+p+B66qOfNcF2rbjzSCi4JZCsJQD/RYs5fZ9FF7g88JVqDi5qY+SNqUB3VeZq+47qwWq6unU3gqtLGgZZIez/EutHO6eyZ+A3Q3ltIRJ1YBEm0wfHSyyiIAvF5iIrNfBIDYcYOztMd+YdIrWSIjyIa8uMKoZiSB0rVBRxzt6E9n3I0zrtk7C5mJu3jKN2KIjv0kY9Y/GLRjKbcf63637Asqxod/v+SptTwxYKjz8mbUelEN/DljYWcb9oOJMC6J0qgc/dI84qnCjAMPradj6zv0vKJsG0mFWWaK+AlDn7V3EnweGHTObzUuaC5VG7QztRGH8JuN2+OaYBmomfitNMv7KTl+nvmBBx/EXI/fVTCvdWkjFrtmY4r3ZG/PUKHimUaLKPgxi/8fws/3vz28keQ2w3QRDg==
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

This patch adds support to dereference pointers marked as
PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL without the need for a NULL
check. We define that those pointers can fault on dereference, so
reads need to happen through BPF_PROBE_MEM. If the dereferenced pointer
is another BTF pointer, we clear trusted flags and mark the result as
PTR_UNTRUSTED.

This applies only to reads. Other cases still require an explicit NULL
check. After such a check, the pointer retains PTR_TRUSTED and can be
used normally.

To summarise, before that patch, reads to PTR_TO_BTF_ID|PTR_UNTRUSTED
are allowed through BPF_PROBE_MEM and reads to
PTR_TO_BTF_ID|PTR_TRUSTED are normal loads. This patch allows
PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL to happen through
BPF_PROBE_MEM.

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


