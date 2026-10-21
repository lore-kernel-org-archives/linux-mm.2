Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DF8A606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lj0ij21h
Received: by kanga.kvack.org (Postfix)
	id 518686B0673; Wed, 21 Oct 2026 04:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C79F6B0674; Wed, 21 Oct 2026 04:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F836B0675; Wed, 21 Oct 2026 04:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1325D6B0673
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:32:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0335A140491
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:58 +0000 (UTC)
X-FDA: 85345965558.12.4DD7DF3
Received: from mail-pz2-f7.google.com (mail-pz2-f7.google.com [74.125.228.7])
	by imf14.hostedemail.com (Postfix) with ESMTP id 213DE100003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lj0ij21h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.7 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
	b=d7LzC/0IOdVe5c63Yhe9LM49cl6AHwnFoBYoRN3HTDSAINquoAXYiMxwID/Nf59PXVUzv2
	3Z8W64JbJMKsDSQxm5ZqJqIatfATJshNyVcaCewsrYyz9YoLM5bkfMbPcm/UfKFJBG4shs
	5yNa7LuHL+mhku6f5ctMwBMmiGmpd3U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lj0ij21h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.7 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571517;
	b=gmj+JJBlRL1ViOh8rmnYwSTLuj+vekMSyCEVsk3QD5ibmJ4uo+ZCo9nlTFN7W3HvGsSt6r
	Ydr47ab/xTL9p1rKNlsoK6a5CwYEa1Jio9YeYN4yGd5FBPsYFpK/Dv7cH5hUTmI31E+RKm
	vxUC9X9OmWuRTSxrlmQJ8H/JKzfj39U=
Received: by mail-pz2-f7.google.com with SMTP id 41be03b00d2f7-cc53988d9f3so139690a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571516; x=1793176316; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
        b=Lj0ij21hlI7v/xT5KKmoATuS1REgOozH7l2djs0inSWJUGJZ6K9cjvw6YsKGu0/0OI
         Uv0rhFo+HQLNImvZEa4Wq1fJEQffKkpS3yjRzDmcYcyLaL5s5BjexZI7GysdCJDq3hQW
         Xd72AA6jpYjgOKkPbEI2QeBWhRfZiXc2KQhOGxSbami7pJO9bbZ1EA3hSeqBXvFNb5Mx
         n+lK72dtRvUZbrtnkwxrKBY0S8G6yijYhM+1FlZsX8IREUdlrfxtCTSq85+51U2Q2+cx
         2TGA7V72whrbTHlR1v60MJooP6oTmHCfDxjXJ6YhCwMFj3kntoID3a5yuIsT4xr82F7d
         CUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571516; x=1793176316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EXuyqgfiF9x7HO7+fbFxeGIrd5nFUV6QECR0sZa4nrg=;
        b=MLtq3rxYEJdYugp7Hbf8zScBzgZvmfG1ojbXgUZE2UE2GcaQJiVrDbAI52GCE9xOFk
         BVme1c8hclJFNv2kEPy/187cDkdfVtsqAI403s1qbjlKrFzjR25y+tzLhkD+H57u/76O
         fia0AqqyEAGayJLUDXXZXkai4K6qviFw605W62Qy2htYAWGhrtneGM3GyvrYsMWvrhqk
         2mbGwmIvAZdrpoqR5b6cq+8Ffx8CodHULg5AFp1wmR2Hogj3XzqsCeM1GseUlVtcJlKP
         AvJ5MaaoCNtxTsC0nYjnn1gQO+8sWQH73Oig1KatWmOnqNf3shG/wqC/Vr5fUfLQjUUO
         h/9A==
X-Forwarded-Encrypted: i=1; AKwUvBwkFxdXIp26pMcmmSix4uRDCUpbF4NihwF9qt/YyshymGPUuKnIL5A5Z4cTefZsn7+IR1Wmnr/71g==@kvack.org
X-Gm-Message-State: AFq9FYJAf5smE3OFRjTxrKhV2V5vQaIHVRqkoeEAr9paaE9lziu6GKi1
	BnHEt5hc4JDazwnyQtxHwg4wXI++Qo1URC2mazlBnYaGlQJrvL1VFoFp
X-Gm-Gg: AYBFou3csKfoth/rOejCAG0o7hoMftpYoIifU8lD5tK/aTmEyMn6YY3d1usKf/XyIZQ
	v8FAAuE9XJw6/kmxgZrEUxDC2AiqsPl7uyhmlohaSpM1vpG1O7GkeixDZYXBaQKnhjHpkXCnUcX
	hWniUh5NIKT3AFkxNJabw0oDtl6qFlrPmsgJ1YvbO8hMhYm0FZCtnPmBJpA3ciFmKy+gUHrPZok
	hv/requRGr595TH8l2ysVxxd2LExq4TZ0BnsrsOCWs33ZOEo7LdMqqDs38Plp5MHyp0iVVSX25g
	6NmlykCWK/mXs4j2oqE0SX+7f/1OzxaiYt5+LhuPR1hmsX1pqi3FzJxeHIDjl7NFqLil82eJ5nA
	yKzVyN372xGE1KRkcQDGIYVftuX9NxJdNJn76GxnfSOck5dO2h6XRDwsicByj4bj1iF+sLZsa4c
	iC1Pu1cg2mnFzoNdfsz0wR32/BGB44LnBSExbT2wwlVBdsTulATvCkwPuxL+uOU5MSkl5rMMeuw
	3ZVcByxpMBs+b6XwrxhViw1uJY8X+1yffhMZRYWGtVpoMEgRmcEIRXJi52wyeMnlAShPw==
X-Received: by 2002:a05:6a00:21d5:b0:876:194e:b8fe with SMTP id d2e1a72fcca58-8a089de73admr1183835b3a.26.1792571515803;
        Wed, 21 Oct 2026 01:31:55 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:31:54 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v9 6/8] of: reserved_mem: add dumpable flag to opt-in vmcore
Date: Wed, 21 Oct 2026 16:30:09 +0800
Message-ID: <20261021083011.2170525-7-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 213DE100003
X-Stat-Signature: qx7866ynjdwqx8fam4c7tz7g1sa84c8b
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792571516-21961
X-HE-Meta: U2FsdGVkX1+ulo280jTQYXl9U+pGjfTAFh7YEgrrnJY8Rjnifo65xqAa91y5LpTAgwbwUb32BlChJ1ZGz8i7x5irqWphMi0sMxkCISxlLvmW9mTCYsbwYXCKMkX5g6DEnFGiwziMpodRets/9mNfpFRnbVCvv7Us23BcHpqes7kbZ5TX9Xy/YVLMi1FUaxJkSu9E40XFuvldindxmAxaJe/Dn9eKhyedJUIl6ek2jkqsTHKdwoDIxmdheOIiavXKPzeOfdH/YaDFDGhJbsZKRQWr0H/Pfkd+qAjrC9cBKniBvxlxjBpe7fydJvi+4k0sn928PfjSQotbuv4unvbUbU7BUPmN42iPVsbebIphCnVj7KETA4BEHZ3/Q6M0HgOfBFYRxmdV+gni8bTbdT8Ioixc1OfiR2l1sLNQOD3Y6VSpy4Xyw6M58rRlDpVqGeZy8CYrnrvaxegvuAdjDCALk0xJrFmixd4df4d5JoFzYF3pNIT/Usn7vh7Lv1t7YHXIBkWdZNdLGiOguU75fFpwlXDQZjrAjivNbL7O/btnuHAlipbQn1VngE2mUwhMhsh2rM5RRqCjuRo4H2NbOZrvbiY5utpN/sxOXD9ZkpVkhzItlJ8qEQt/OFdbNSChX+zlfIrgL6VhMew5BmvUtCARARKXhyhuyBjlmWuN2PNZmt38Rmc1reObKJ9CN6HCenl3tLot2GVTXtYAtj6bU9eZ8XRP4IKrWSmMGOMUOqRndmvKRJbWKJ2s9keYA5zr8Eru9xaEhS8hRQqm6bA73lVN2T55Qj1t4/Ihbvot6EsWPYdKb/gCbjnmrL5KDTE0j/6puQxwLrmvgSkC1eP5gfpfFWQvKyB09bvHhp/UFv2eIEws1Rld5QVMjVbj6g7OYyHEzT08iF+yggXRRTsPDioBxxFFGg7QHlgw3G1j5L0WnPJGu1NTbhy9x32aFXZ4cWXS3x5nSK0kTFyUhFAfJhk
 /cph7f8g
 uiTQFT88iQnmD0v088MJswBtYVLXnoO6VhviEiOtAS3x3MyQon8l1rwllk1rLKlj2McqJ23sNvXvO6WOm5wjcxXKuhEX9esO5SrexptvESUtsQr1I+46JFNox2tMhJQpC4iO6D0fGrdgz5QBBrqL4CT6pHPdk5gbZn6l+CoatxzPRki5baytDcZzqw19parVtdl4hCmZNROS60tjHQUfx4iWTfig0kCRWcU4XIRPaXt0vf79xNLfUbCuuorFvH/26oMY3hexP1AxWIOoJ9QQbbdSXjz6DzFjHGODMarf57rQvn1VIab7/N7zuhj7dNt8uZVKtZt+ru/FblMe10RihqOsCbzoOrJ/R4Um5UpjWDYC+T/8kz+iRKY8NX2eUv5c6X+nBBRfpsZKt+jT8FPt3pVnvUrOo3FSwVUMQo61FNJypa7gi0H8JQK5ES+ovLPitykF39wnR7rgu+mfeUcuNDvw7O4f1DKGAdpjjt9uBw/A87xOg9raQ94AQwguwJNN1DCIOa3OkYnm1Z73Y6tuhUQYoQ8luRaVryYiRn+EWNHSI5ZRtikttLDLJLCfO7WuSA7zhmovmUP/SLxH/VzX9GpPs1/LvlUx+KOrYOPE9c5p5TfY2hyvcBZq3eMez4+1uODMKmRrYZPff63WpwnKZcS0lsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Add a 'dumpable' flag to struct reserved_mem to decide whether a
reserved area should be included in the kdump vmcore. Non-dumpable
regions are later marked MEMBLOCK_NODUMP; the filtering itself happens
in memblock, keeping the arch kdump code independent of the DT API.

Most reserved regions are owned by devices and do not contain data
useful for kernel crash analysis, so dumpable default to false.
Reusable CMA regions are different: their pages are handed back to the
buddy allocator and may contain key data for crash analysis, so set
dumpable to true in rmem_cma_setup().

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 include/linux/of_reserved_mem.h | 1 +
 kernel/dma/contiguous.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 49da515859f2..99c0f3ccc297 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -15,6 +15,7 @@ struct reserved_mem {
 	phys_addr_t			base;
 	phys_addr_t			size;
 	void				*priv;
+	bool				dumpable;
 };
 
 struct reserved_mem_ops {
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627..d7bfc38ac762 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -567,6 +567,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 		dma_contiguous_default_area = cma;
 
 	rmem->priv = cma;
+	rmem->dumpable = true;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
-- 
2.43.0


