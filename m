Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448BCCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84706B00CF; Mon, 18 Aug 2025 01:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0DC96B00D0; Mon, 18 Aug 2025 01:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAEF06B00D1; Mon, 18 Aug 2025 01:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A46FF6B00CF
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:55:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3115116077E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:41 +0000 (UTC)
X-FDA: 83788816482.24.C2F52B5
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D345120011
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A8+s1bO0;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755496539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZRfWuGPUUgvuKMVWn0BSSyH7DP7rUdcRjJaD+jFoi0=;
	b=KZ98T+ujCMtjYLIMush0jycKUw1paJd0ff4p7MhA5alK8a3rHoZ6+NxNCa5jFki3D0/+I7
	5QvgpcqL05HVfsqFIDJW2ZXnWlq83CMb9ObvbUv6uLIdZRObI+V7HvINpfK71fxXPHIapl
	26+lwKP/JD39Wh8I6I337HT7mFZznCo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A8+s1bO0;
	spf=pass (imf29.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755496539; a=rsa-sha256;
	cv=none;
	b=A0uIiz8YKCTK2SiNThfaI8po0m816DO4axdl6i/7QJN4jSttvGjzro+1pA4NSpbCDGnXBW
	fLuhp8Mbcjd4NAETwcy0XS1mA6c8Qb+70mzioCsOcRIONelO86ZLizF90cD4BhkVtglqy+
	lwtlHG7KqAb5+eZxxLVxCcbh9ro/+6Q=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-323267bcee7so4505392a91.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755496538; x=1756101338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZRfWuGPUUgvuKMVWn0BSSyH7DP7rUdcRjJaD+jFoi0=;
        b=A8+s1bO0S8uREAQcqjd0zP/Yi+IlLEe8DVPdXWxe2UmkXwc6Ht/c65zOvC4qn07eHo
         q5354TspasdKECxgm25Rm4oByoKXHy14ZuUJZ15RMe8J7PBOGAG6eWzygVaCH0ggfY+3
         he5cXMzq8lfUgK+Pkq1NQgdczrP1vE46Y8k3ap81Mif9eZSjUUau9Prv/w52wLPjW2r5
         Hs3j547XtwQ2ysuEMjydvTOvLuKdWhe36d2Xy2C5JlTCNL6Pddn/U1LWwwENqGrkgfd4
         IsGtvuZbReDm1jXracyKA74XtN6mZ+FtatJOETTLu3kx2Y8OLZlUGRCdBdOttPWoTXEj
         6luQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755496538; x=1756101338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZRfWuGPUUgvuKMVWn0BSSyH7DP7rUdcRjJaD+jFoi0=;
        b=luYI9p96dbYM+eTsHegX9yzTXAfcdNMDJshg3n+CaZd+4X2pCJlwprTZPc6USwHR6a
         tzjUaaXJ0mxLt2jUYJcBMNHsrkXfEvu2U4P03d3e3LZ8ztz770sG3+IqHUdvQVEo4SNn
         zsEWfJ5X9/0GjFAVBsRm5ZBfyz/i2ScSwhfbo6QAT7gm7D+86OSuQfGd3lMqnsVRdzAj
         UEaPYpZ2wpE9+Wpm5CzG5yk7zp4J4rLGazrVR6xXaJ6NuiXYll4zTW2AHASajnqUQRoY
         uBJQRIwS3J8F7hb5sDSCl5BMZtpMuf54VA5MhdM0xRjL7xH0AWFuFLgak/yPyNWivJ18
         TWXw==
X-Forwarded-Encrypted: i=1; AJvYcCVjrxuu4TEJF2+vT6TlZhTLUhOPiZ2CrB0tsFrUfB0Nd0tRwzga9IKLrRdGRQuAWvdQrNoo/ZkSew==@kvack.org
X-Gm-Message-State: AOJu0Yyf4EQpCLPZfwhGxpcyUFKUZJrs4q6ocrnMVOm92MVRFKF5N0vv
	LyoiGIl9RdJP5jhAbJe2f/DacEUESl4wAI7GDkEQGjJ8fFRFI4dmhOwj
X-Gm-Gg: ASbGncv+yhFdemQm+TEconf4osnRrJ8FJTAmFmUuIXEfZRv5/z7xS/bKwSsuWqTFDaU
	Qobxz5A2bYCSqkK+Jf551JyqggPdQI2RA2tgoQQU01yf8ebHjkIQmSA+cfqaVFZeZhXhY5yW4AL
	gHCVw7N2qCHJDiQpGdudpSgClTQRZF1Ms44irsfQ+A4WiAoSQ/fWyXokxlKuDCnmmz8rLyj2S+l
	tfiNHlM/Y4s/bTdNFzVFLSeX8fwPRR/paM8DDQ/n5ZZ7PbjRQLtTez2OlMFJLOoiEs1NKiFJKgH
	20GKZVgrH3oWXO1K8i2Y0otmIPNkYKWzgnnJzYCQIFwBfnc0OX2iNK2G99CPehIa529K/3FSBQA
	XOGioAxDsS3vwc1uHCqlk0NsOITlLafzS4wg7fwqMzwRsgWwPQ+SnM/6P
X-Google-Smtp-Source: AGHT+IHVWq7D5y1VVOmmSlNtcDgm+Q2Kh/UvXw4Jpd+npQ3H3QnyVEyU34H9tXSxX7a0UEwTtKhL/Q==
X-Received: by 2002:a17:90b:51c6:b0:321:29c4:e7c5 with SMTP id 98e67ed59e1d1-32341e9e9c4mr14037235a91.7.1755496538055;
        Sun, 17 Aug 2025 22:55:38 -0700 (PDT)
Received: from localhost.localdomain ([39.144.105.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-323439961c9sm7003413a91.13.2025.08.17.22.55.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 17 Aug 2025 22:55:37 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v5 mm-new 2/5] mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
Date: Mon, 18 Aug 2025 13:55:07 +0800
Message-Id: <20250818055510.968-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250818055510.968-1-laoar.shao@gmail.com>
References: <20250818055510.968-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D345120011
X-Rspam-User: 
X-Stat-Signature: q6ebfs47jyusk9b7n7jp15799kujzped
X-Rspamd-Server: rspam09
X-HE-Tag: 1755496539-927983
X-HE-Meta: U2FsdGVkX1/HC/AYpN/A21LvkasqP1Ny8EuMbwbo03dsKgmS/ObYYcviRqfmGpbWsly8k/615fekzbEUXrnmLEmWf+ezNdWis5LfH0bFCC7FJFnmZrdCMP3SfSDnR+zENcxk2Ynx/acvsLbl5ACx3vZUINsivLCC1f6oqfJdrpy9S96I1zyQVFXbLZmZGQZVZQWcbcgvKOm+d+YwwDVwIJ0AoQ/WwRnG6UEibWWzEDVVDED5S5CSJu2IsJuGwKjFIHzM3ii9qgTp6Me8GBrk0DmBP/VG+VppInhkaiIQ7Fg0m6J7dEoqR5Z7wETqYOlg5Bg0Cfg9Fr4PDh7L2SW9oW23SYpf/U/OLGc93LC4dXVtfRBDq73FpSRIEbd3xOym0VjC09bRw9AorOGm9J5eIFbQ+jVSX2kcigJtocnyKve9lgAbbgB/SgaLupN+UBUDxVeCotDFugtN1uGU08GT1HzJ/9mHiTniU7Ol4e4sFQyDUnxQE7sn4mC2YABbUgPaOZ1f5x8rcDHJBa7sG32TjYRVlGalUL19UcqX0eOmQHkY6AJMzdF8QvK88CgrOrKPdOocaGEZuAuuktMWMpOFyHOPacTVhSvskcuvBfFXA20rfOKZ+hInMnEgot+eJYTZBxc147NhnZPxxX2DXyWZwT919KRQGQXzjZz1/okcmMk3U7tVLVy270FCB+Tqj2SamLbPSFG7JVArfvjVp7S8pDyqMOmap8iJ3Sx2L9lJz2mfGzILF102n/2h/PBkQyCro3A4TsG2JHyMwdJPRW4l744m7Id6UGhnztfxlCW9QhXG+JEhFJpboM3I9nxHM1Tyr//TrvGo5sTDBkvKRLvehUBk2RWMnYuo1uM29+AwNAwcV0kEBLzrGfZlsvxL/7ZOSE398Sqrf/gr5IwmK4eNaRrGlLhhETmyeY+rdhIRdft8bjctrCmA59NA81YhcK7GKt/l7c5z5WRpgHEn0y9
 JlXPInTP
 Uf+3vqb4pvXoI7klXt+aqsQODroO3nddghqQu5PAWfERFqPw2p7IFMCZb82Oq5oXPC1/iCC+18yu28dWLdlWBLmLhn7pBz3mYbhwgO2TOv62gPHbC7nVq4iWcOEgrQ4/X6UD/Rc9m3ZqPW2o5ncGShH3NIJD3Fp7HPQs83Ofzzy8ktiuNJBCXUOALHiruTEM355qKEX1clsiyvcewORaHR3envKWfg1U4ZTJuCphUUqi5l4566eV1R1Xbbvy0Jk4GCmtzZMGoeD3F/8YY3STmWg3S08F3Rz5TyiH2UvrlJwf1CIr7hxWLmuEhYcsbmXPZ3neXKd8rDsy+XjKnXibCyfad52S56K0abx5UFy6Px4SfWjFX0Fnqqxmb5A1XEAgMu0Vt0eYZApAxxgUJo3dD4Vv/SqxzTW/0QqMV9gDoBGTUFNQfZabKAd7XKePM/qfKZpbSC7aKBVYew65FUyMXqQrnTKz/XG8Uf9Aem3YU96YNye/xwhyTXyoCQX75krxIkFiWTJ6nMFWI0hNHssdzOPWwzGk+TVvvC9ja81ZLcrZ9rQJHtfbvi1D4K+XPNIqw6QTiNUXe+hdqC991N8WrfIfogw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will utilize this new kfunc bpf_mm_get_mem_cgroup() to retrieve the
associated mem_cgroup from the given @mm. The obtained mem_cgroup must
be released by calling bpf_put_mem_cgroup() as a paired operation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 mm/bpf_thp.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
index 2b03539452d1..bdcf6f6af99b 100644
--- a/mm/bpf_thp.c
+++ b/mm/bpf_thp.c
@@ -175,10 +175,59 @@ static struct bpf_struct_ops bpf_bpf_thp_ops = {
 	.name = "bpf_thp_ops",
 };
 
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_mm_get_mem_cgroup - Get the memory cgroup associated with a mm_struct.
+ * @mm: The mm_struct to query
+ *
+ * The obtained mem_cgroup must be released by calling bpf_put_mem_cgroup().
+ *
+ * Return: The associated mem_cgroup on success, or NULL on failure. Note that
+ * this function depends on CONFIG_MEMCG being enabled - it will always return
+ * NULL if CONFIG_MEMCG is not configured.
+ */
+__bpf_kfunc struct mem_cgroup *bpf_mm_get_mem_cgroup(struct mm_struct *mm)
+{
+	return get_mem_cgroup_from_mm(mm);
+}
+
+/**
+ * bpf_put_mem_cgroup - Release a memory cgroup obtained from bpf_mm_get_mem_cgroup()
+ * @memcg: The memory cgroup to release
+ */
+__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG
+	if (!memcg)
+		return;
+	css_put(&memcg->css);
+#endif
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bpf_thp_ids)
+BTF_ID_FLAGS(func, bpf_mm_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
+BTF_KFUNCS_END(bpf_thp_ids)
+
+static const struct btf_kfunc_id_set bpf_thp_set = {
+	.owner = THIS_MODULE,
+	.set = &bpf_thp_ids,
+};
+
 static int __init bpf_thp_ops_init(void)
 {
-	int err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
+	int err;
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &bpf_thp_set);
+	if (err) {
+		pr_err("bpf_thp: Failed to register kfunc sets (%d)\n", err);
+		return err;
+	}
 
+	err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
 	if (err)
 		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
 	return err;
-- 
2.47.3


