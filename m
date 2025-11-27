Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A16BD10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E136B002D; Thu, 27 Nov 2025 00:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DDFE6B002E; Thu, 27 Nov 2025 00:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDE46B002F; Thu, 27 Nov 2025 00:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 695136B002D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:12:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18503C0993
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:12:09 +0000 (UTC)
X-FDA: 84155215578.07.6FE25F8
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2BCC580002
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:12:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hxzbkiTp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764220327; a=rsa-sha256;
	cv=none;
	b=hF50WzSKtXKAd1nJVZrLNrVoL1Nf+4WhxEcIxEkXL/pESRdXg5kA9IZvGP/LlVpe2cV0wO
	q29bqwLmTfGqZUwjUQK3ffkuD3IkPtG0RpP3MWB43M29peXkwdG/DEAC/QdyFuB+Cuxt37
	AQaSHAq7//+gQEg69CuAY4tUbDPh2cM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hxzbkiTp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764220327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dBWalwjFnHVamtYHVsgWwLGX4A7VLiPSX3ivCHmFtM=;
	b=fammrlqN+pYUJsgBQKg8e//nJhJo6zmbwbA6jRd9L3or5eiwZaD9COSHeYAKBfVbVnIPFv
	VHqSnCw4cRN0GP3p6f5dUz8uC51Xky98cQav8HDUMCnx72695RVYg6x8HMe7BuYYMG6pEo
	ZHDc+oKLTS/Bt82HHUkIRtgUrCMY+Jc=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29845b06dd2so6622735ad.2
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764220326; x=1764825126; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4dBWalwjFnHVamtYHVsgWwLGX4A7VLiPSX3ivCHmFtM=;
        b=hxzbkiTppecp1iGs4JWBvCVz4L16EoGzM/mztaWqMDXYz5dKhBfH7dvi7i0VikFa1s
         6PRGwgHb2/KDSfNRfQDnDFCyiiLnbaRSsNS2X50yd5nknewExZs5II2Sk8L260wi8wYy
         6Dtb2tpSpFjIqZDda40Gv5e0WlTzjqEgToFQ1UrdwRloRkp+geKAfHotH++2+dN3Hh40
         9/TcgsvPn1y1OYxzMk++415+PFdC7NATRU2ihpiMqkxRtG2fa7DczP9iY74S50gOgsrq
         17C6YhEDkUlrF9326u4OQF/NOMJUyHj2BbfpOoF9l2fCFaZHZK9EeROySaAQaAkxrrPs
         IJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764220326; x=1764825126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4dBWalwjFnHVamtYHVsgWwLGX4A7VLiPSX3ivCHmFtM=;
        b=d05oicySW8Qn0rCz7Fd+TUm9fN4jE0KZwc7j7Fl39wSjt3fFDWkqpj5y8kdaoaXUtx
         rBI8oDH1L8B3D+AZ6/DAFCUTx2i9hIIdgI+BC63U1RrNS+WNw3pror78jLPcsMFWdJvH
         3x3v2W0I9KsSz6Z9mgbXuM56G+aFBvuSdq2qyxN5ZdMev42hRxIwZ/W2WdZ0r210d3e0
         /0fORXG3zrLXZoIGUwQVRefIGk7N4bUQJVcfECwfN4eyfKtM4MNIFC2ZtYZtMsEqMz1Z
         DWCfDv4Zko4PkbQbYzGyi0ZVnRWN4W16EovnZVCdvgxalgFZEgPSYe8/pFjz/efttZkm
         SjSg==
X-Forwarded-Encrypted: i=1; AJvYcCVkcIyLKerJChhmQL7Fhl5vaZ5ynCYP6Un1qcY0jug4Zwq0iM9hX1RB8SrBr675A/Vs/qjZLOqeNQ==@kvack.org
X-Gm-Message-State: AOJu0Yxl9U5DL+NQVdp6Hq+bgEl8/fK4DZ3hfavgdhg8yinl0uwU2Uoa
	xrtNIp8X95IbLQRuF5560tbPopVkehre2ZK+HnhRWepe+ooJEyBkH3ct
X-Gm-Gg: ASbGncuaOcDe3a3Q9d8hIrqqwsUH4tLxpN6WkzuwvR5Sg6wp2g9+XYigRvl9UcZVcJQ
	zmprX+JoeqwbQFcv23f7YT7sN8T9/5AEdR9DOH/KHoStdE8DV8WWaB4bpE3k7BT02GDQgY8j754
	eGeDJ1Pvjr911cFLr+uRXpIl0KcsmVlFUqHDCOBOwD0nP5YEkejWD/X3+ab9pyLeQX7SiT8/wKl
	5Nn+XdmHTppG9pAonl/FqjD7EBZXU0xm0SoGpjAiTXJVCVaoEf6xx/evHc9GmjROn6+hyWEzNc+
	An3i1NBwzmDo8DgkDBqxwP9x33OR4KlYL6xDhSa9KR/Q0VeLpPNOVDOaOK9Ag74Y/tTlwiQnM8V
	iWsMCwPKt/c6c1fYSSjAGb9HACOd+zffZRZLKj5KbcrunEdj5mKERIa7XOnDp4d6DYmSnCYX74Z
	QxmyGM99Mry45Ch2zosEJ/g7dqEQ==
X-Google-Smtp-Source: AGHT+IGpQXwuWyvgDB9Zathj8M9tc7BuirjqdoY1OoTWwi2hq/0yoRma2KZWQ5SQ1e5q//SQA+zovQ==
X-Received: by 2002:a17:902:d588:b0:298:529b:8956 with SMTP id d9443c01a7336-29b6c6c3732mr252944735ad.56.1764220326016;
        Wed, 26 Nov 2025 21:12:06 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce442744sm3590715ad.23.2025.11.26.21.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 21:12:05 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v3 3/3] mm/zswap: use %pe to print error pointers
Date: Thu, 27 Nov 2025 10:41:30 +0530
Message-ID: <57b7205813aa87c8f5c8bf765e5a8d88daeba68f.1764177933.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1764177933.git.chandna.sahil@gmail.com>
References: <cover.1764177933.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2BCC580002
X-Stat-Signature: qua1wcfpxxphozkdwc6fiie99hu7348u
X-Rspam-User: 
X-HE-Tag: 1764220326-248782
X-HE-Meta: U2FsdGVkX18oaDhNR5o8xfDUVjIwU0RJqQDXr5eb94hweZEeLdplTLSTmzvFgcuVga79Um/ZV/MMEoc5KuZTPpWCbphUDdhXelGIuM8OZjJac6mYZTgKs4wDdsSEjoimQwjwRQ8T0byXTeMByBf0VbCsVvrI/zedrfnQcMAFoaUwHCHsizAVdUPCNDb2Pv8TSnWCKuU6XynjEAap7Rya4G4EUpfX9RWeMNoOlutoiK3oVyE8JvxgQ4fz1Vp3WkYaiiPA/KenyF+JQsE4LpLEMIMB0voseSz2zaS85aTXafkhACazGbFFVSwEYrGUKqwC30t6Y9TTeRyLmayANgIQEEPqr4OYpR4VcokrLFg8JAbNA5CmaupX/xHM9xOJKSFHeHIa6FFlMyFW3jc5MQ9a9EDCctI7raAwflgJyRgpJFcUdA2rZ3EmGxn/bKj1jcbE+MiKiJfy8ZRictPxRt9+Moj1dbDJ5f7aW2mtcS7Fv9uZwBMe4ahzAxMgj0w1bC5vvht1U3p8QJaXjFOStvsfE59Pw7Ans++PIUpQkj1ev55Hbys0OPyGWzhKzAKXMVwo+Vt92XlzKy8DYfv1tPEQUhiSkHuDa7fb3249zbRA5LN9nG0vclQN6k2PN298/o6qZMzTRGnNpNLRaxmS+cqvw/KoaKXNfuwr3JzLGNDAPV1yVdvLUCkuoahUwOP1JuvvJmKiuDrPXKgut26CugcqTw//ZQOlelqIf5l4uKAqgrO5703jN9F60V5njaJqxW8WEEnnWa72B3WqkgO/LtW6Exm5CK2x+uHMPVZuPE7dEnPzeubvDcFE3yIOUffXMt1RfUe+05zhEsMIwutQKDtZh98znB2a4sMYmqHgk2vQRdhOTUTOd1jsCX5asMOlTyyxJAiQvmPlCQefoREAl/3sSHG1QmjQfCipl5YIoXWDFEuJ3HUNH3Ajbi/YP1ecz67WMC31pD6K8tC9BAG8IPx
 tR/dxKC7
 pmad/bfVqwm2ytEMM2PYuj7eTrBKJS0uLl8+iG5R4H98JFjIYoKPK9upfIp1bRcmXVuaE+Cj3IoNpPEiCuz+d9PcxqyGndqs/75eilKdrsZhRLUe0mjuk+EwgP3VzsayEnjIeYVXJoBNttdc9VfsL6ZoG6YIl943DSZi+wyvWB4MR05qkjBfszb7ZmG9zU/iKzhoGXLhxzRZDSiEeFWGJwWvkq54SYkmyAAo3xkRcBxLzo9Q6LUaFnxJFAMx+oMJkylAnm7J8tbpPM/vRmFeNbTyGosHATiZxlArgIUEnw7fWlpK3TP5v2IWK2MtYatoR/mkfhY85uVWxo26iUC9QlqOps7TMHg7WJXcICCcYCk9ITDb7NUXoGJCUmWG4DhTJWjc+Sygrq1cxe3fZBpZOnbnHdiZB2VSorzwdSBQVIJlvNkk48inhAholETRYmwUJYpH3JZpANkBr+IUoPN/pJytTSvhXg6jmwp4/RuGOKTWgC4RvVCEPfFza5HV5xh6u4pF5RjCVTfkuq0ZLujNdncSYKBUbeIH2+5KU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
Changes since v2:
- Add Acked-by tag.
link to v2: https://lore.kernel.org/all/0c00ceedce6e0d9aed35cee5faf15fd9126a1f70.1763796152.git.chandna.sahil@gmail.com/
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..c35604db32ad 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
-- 
2.50.1


