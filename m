Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE78CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835848E00AD; Tue, 26 Aug 2025 03:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6648E00A8; Tue, 26 Aug 2025 03:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D53C8E00AD; Tue, 26 Aug 2025 03:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 583B98E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:20:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24A03140633
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:32 +0000 (UTC)
X-FDA: 83818060704.05.19A76D0
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4AC7320006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I3P5HYjG;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZyjms1M5tN1pPNdDlz1+TFH0zZdP2UKJkjfIDOKjTc=;
	b=itzaEEsGGiP0ANLWjHPPpWMSiEpZWsSLLlySIrNMtODe904gtr3mmqg1qraeoevFw3jtCd
	JJV/rmmleqQGfgA0nOpDkiLZ2f3T2v++HKg8q6aWOf/M1DUcv3wnvkuv88P+ciq/wA6Kgt
	2uPyGyFFxBEepjZPFL7N6QE0bXP3zPI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I3P5HYjG;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192830; a=rsa-sha256;
	cv=none;
	b=I8q5rzqNj9dVKiBDbg/z+WdvQraJfTYBwhyUn9fB2IFk8wOldRcwxA9NXPNTWMAkKrTICC
	1+o1/C9FzK6jYkeYiGwIPaP4wLbUQ5vCco7t4ew9/WNuYKrkg3xmiT+cx3eFNLDkRLyNdY
	TyQc1nOmpBzfVCysec3hOIzFM+z9bsU=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7704799d798so1913196b3a.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192829; x=1756797629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZyjms1M5tN1pPNdDlz1+TFH0zZdP2UKJkjfIDOKjTc=;
        b=I3P5HYjGfefJFbZaeZ4sN/44zzrkTT85muTfG7YpRfpcPdtJHCJY/sW9MDgJHSlfEK
         nrVJCf596su2HL9NEjvEUkfJ3PN5ZrJ0XY0bnlZ/ENh6H+nBpGgKbvWWb3PlDrIDal1+
         JHmoX8fVrkvtRb34TVWd1nLG6kp4Q7YYwLTvTlsZ35EZ61DMy+wyvTUjQaFiMZrClfJw
         VRg/Eoomq9sbPIC3NwtzfU9G1eGdUwRDdxhop8LSyWA1NVrKSDCxdXhiuHXKBddzuvem
         6yqDV67XlwrVY/vzNTaIAKiWdoiaS4Fnm2bsiC0O6SvvKEVEpY7T32eZkbFq1KcUDD9x
         pzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192829; x=1756797629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZyjms1M5tN1pPNdDlz1+TFH0zZdP2UKJkjfIDOKjTc=;
        b=aFa76Dxnztv0/UImBFRK1Dq93YSwidGiiVg28cyL6M0VxH5nFap1e1bR5aNYXxcsQS
         aTjQMWXFTwrtquZT5hZ7FOJtTT2RvKgE+eo5YSs8gYdpCb5cwTv9ykWOeC/JyIHQGNGO
         8aPCOs92X3V4X640bojjlY0BH5Zp0BJ+v7GMdhAgWPI7ivkbJ3bwZwAdwsP/bn9/BCgZ
         PGVeU3F+tcwmUa5uzgA6U2BQK7MIdWPJtmSDW/Pl6glyneknr+e6JDiO6c0NZ3dOtS63
         dcZ1V3l7wJp8Z96gH38LQ9jyKT8K0h8K+BRyxJCAaTli5Y+hqq99IPTWWStaPYNKMB0M
         NK6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxKPPgBnKdW3tDCfjN2eyg2EJhe7erdIO8P+IGEo8MJVA0nKPj7IZde8+n9TVKOfmvMstP7vg4cA==@kvack.org
X-Gm-Message-State: AOJu0YzHqYCjLaV6JBXXclJRd0+Gtjoh/ghQ7MeQ/tpeBAS6KwGsG4a4
	JsxIOsEaQPhJaW/qu8mV21TfDbESMIioVWxVnNYfULpyzRI4AOrWRggd
X-Gm-Gg: ASbGncvuZvlx1YVsgqGYTOy00cek07ijNEbbdoeMs/UEVfeI/jFqrNiKtS1wHzmV2cS
	2ds/Aa/AWy/VeKLVpwdpVr4bcECmqXHr1K5UX546c3KtNNq6M1nKk7UhgexS8pNF5xIPJ84XIvy
	QK5XHACCzLvko0rWhaecTApk0kutD1M8QTo2g6g9UmrYomh+gTzUGQuv2YrMNo1ojqJX54bSAdR
	z/JKW5sQoik26vt4lc1Dz1XC93QQjGckX4lEcHH6+Rzv1Ooh1pY6HUeCMuR64fQrfBXU5fkyLdu
	NuT0b48wV5m7PrRlYc9tFd9iU8wqhYP3butJPXvXa6D17vkqnKySZXfJXkKZHJdCs9K2qwcIoA7
	ims+ApYFoGBJN4qo/sICrWzPVrWp3exz1hLTRsN05T2NKqf2VI/fzezDEyB2kLntPRMkM6L2isM
	vZbO93tc2mkLXJCQ==
X-Google-Smtp-Source: AGHT+IELeMvTBuFc+TaBjK2AkNjBALICozxBATcJD0661qeFTUzyU9eZrPl2Q2DPfPKQw+cNM5rcmQ==
X-Received: by 2002:a05:6a20:4a27:b0:243:7379:539a with SMTP id adf61e73a8af0-24373798730mr6415010637.12.1756192829094;
        Tue, 26 Aug 2025 00:20:29 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.20.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:20:28 -0700 (PDT)
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
	rientjes@google.com,
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 02/10] mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
Date: Tue, 26 Aug 2025 15:19:40 +0800
Message-Id: <20250826071948.2618-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4AC7320006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dmyzw15ztudo1mnkm3tyb5ugc9c5xjic
X-HE-Tag: 1756192830-361754
X-HE-Meta: U2FsdGVkX1/I6vqU5FTGJ59hlKBSWfoODSfEhP650rg+GLsp0gfUDnxoH0JycUKV9LSK9OjqFPuRkAV7TFBCKF9+U3FedJpMgH163ZjlWJcCjuiWsIsP07timGT3K87nMPUdwyDZ7kBJUCeg687M5B5Rr7fA/+4bpKKn0GW4Uh1An1F+GCODFMnf4qY5XGm7gEledqhpbnCj4C03etNPuDZUwgNsAKlfEE8/8KF6/tEeqP1P5SiDynXw151CqUtAeAOmn3SI91gn7+Z7hTxJsabuGwI1KUcxfyfGtdjKnEH72uOQwfz8nHylZ/GnG2uxWzoUwhnHUhXnNhfTu5cOMZFv/AJN96jl2qb0vjA9sSYzHVWNazT2MuNHrOo3q7oewLKWgcr3XNa4fkTyaaj39mse6+w3ipNCCMORfmAiL7Z8muybir9yrZHQ0+24gTf9d0zwHOsMVD5qKu3Te0xry4VPNa5avVxEaC+dSrIFTYB2mBqxtubAzi2uLGpMNKXxiK23Nn/Y2njwRkWTWmD0gtz6E4s7pateVSLzOdy5e0ulNfxIa4VH17pz8f6Ky4eTyU6uyilEBenICpo5Tii+O2PTcGOaP5yQXbYwYB/d/iJb2knzwFl32UScYTh0Q4XBis6OtYkMn3SZNx4V1NsO3+EL2VcmgYe/STDZtbYEcxdju+buFBtPG8izNbaPJI2Cd+Pepdwn5HNqnOOnSKZ52qSPujOj53n/Lp49a2gg/r5Z5UIqUbJZ8GnBsQ+uZW4T9mLkxCLoNuNLJq40DaNm0To/eMAcipYK3J5mRKhbISz4Q6vkwDcJ3BjHG8QyAfbmNQuBFW5OsIPk7qIDD1UWJDxJVyPyaqq+UssdKyt4ClZEpzE4f1IvIUec9HtFID8jkHVCa9yCw2F8nCbgFT6B5NFs8YD3161+8qwxPMdt9oWg6Bl+l5zQQqxVZJe0algJtywTH4lSQ8Uo7UGrBSy
 PsN73oKR
 VnLF9Mfru2PX2S7Ddt9KwSIQfuT/KMIew2SgdgD2j7KRH+SwDKF6kv89Kgl8H/+TsB1G6onJ2tg/lNco36NZuuDiAdN+SF8wBlJBB+fXL1/CgbqXCNJ2PgBOIaoGI+I6HP6yeuhAozK+7jFdpwHq1ypaBV9kxMjBhJsWCS8x2BtTdORkGB9hIuxXb6PC9I343GUVwOnTTHLlgGfgukxpZSKiD/qnj9lresXcKWmiBtco1M2+OI+hkavTJxvOBWUL56NYQmB3IKJhICCpl6Chj3EhHrDbhHpu7024d+aG9l6jnPUguTYqImxQHE/QQyUAU8H5Du8fvs1Qkp4FYWPFvC+ZUF+Atu66+tzJKxS+hLKUycA0HxvKtp9R4p3UAu/M3SIxp+147TkF07FGM1CNQcD+6TO9WKMpP0FireArmJXFelMi+ZoQ+h1IkhAIEtUpwiN2wUMdmKwRBJvkrAVdCBG1XSIQoYTTFXjKM5ROo2wKwHYfcVJ4Sfexd9dea1cUlUurIEKKrQFU4xejzGLVeMRSH3Rctc7tp0S3hYRUkRip3GALvnTpZ90KfHap+yYAfR2U0jp9D35+zLuvrOeOGVu2KJw==
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
index fbff3b1bb988..b757e8f425fd 100644
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


