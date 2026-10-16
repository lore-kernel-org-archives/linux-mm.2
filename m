Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C25FCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320A66B0088; Fri, 16 Oct 2026 09:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB186B008A; Fri, 16 Oct 2026 09:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171D56B008C; Fri, 16 Oct 2026 09:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6C486B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:13:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D75851403EC
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:13:53 +0000 (UTC)
X-FDA: 85328531946.15.E239E99
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65D71A0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:13:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fyd9t7Z7;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792156430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bq/LpBxXTW0ASsexzlAoQoBY+9bpCrcejtfW5Dqw6Do=;
	b=BPkZO0mLrYTzJCYwoiu+JsKntEM+21MdQr7Xku0TNUi+wInfjAyw7XKjEx5i4sf1kIeghD
	87fmJyEgTVG19ykxbQxithPCNJe7tYQcoI6NVGI/yvjsuo59IC5pwmrt/JBnwOq1gO0D+s
	sJIsm+A2XzfdDZ89qe1NdkrCCosi0Ro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792156430;
	b=WrcZaZAmdfehC2OHbdNqgJEH/sjPcuZb+hsxWJFvCcFw4N8dkJc1MHQK69U1ZhjjoKXdfa
	tureD/22q5MBnhQ+/hempVsHfQQXjJM8D4ai0ECJ8CmG6Wrn9COl5jAFmhI7Hfz0cc/XLv
	Bv94Iz1nsbfnKQKPlDhqGZFA/ke2JLc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fyd9t7Z7;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cd5c9e52398so2905685a12.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792156428; x=1792761228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bq/LpBxXTW0ASsexzlAoQoBY+9bpCrcejtfW5Dqw6Do=;
        b=Fyd9t7Z7Ec4+CcALAaygindEK4g4ZRY2JcvBdNUI87EGg+mziDOgS6OHmPGziVT+c9
         5NdV+L44ktqJZ+Xqlg2dadYSbR60grtgSBRfHjm1dd+kviI7Uae/D8fKIRDXyPhODo/A
         DORpQtYH8ek9MeOADmWBZMm/eyTiqL4A4++s9QC3NHWt+hSJHDunM3V6Iobd5q3DUB09
         zl27kUG7PbpxHIP/oeKfVCiwoURWt1+i+H4G6KxBPBSMeifbp+0TIgZq2jPXYyFmueAW
         3CgtMQPILqRx1Dy5wT0+cE+DNh2WKJiHEqb1go+houq/PusEBAz0kcA8g70XupyQjbK5
         pjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792156428; x=1792761228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bq/LpBxXTW0ASsexzlAoQoBY+9bpCrcejtfW5Dqw6Do=;
        b=kQc4R4Mdb2bjqBjkkud41SYuOdCC1/rc9lYjBQ88URVhRUQ4GgSpaMooFQ5RCto2SN
         t0dAiTolocKi+n9HxTfZ/RnOMiDabwacUc18+xA4ZnfO5nA/847g4B6hLZrghmR/8SDA
         s8F0h/PFIa4ys8vkKBrnGWamBFp30ok9bYxauI0c83adYgp7ZvdlCoDmc1lhjsctlrxs
         SKcqQBgPjZVY5J6+dWvsSyGkGTQgNXvrIkpZO2faLLLgTAiDafD1fgWNxAp/7XdLOlX8
         ZvZepwzijQG6juu8l3JnwezykoehIOhB0Q5+jlRXGlrFlhA6Ni7HBpV/dEjqidNZWx+T
         r2gQ==
X-Forwarded-Encrypted: i=1; AKwUvBxdxQVn7vx6s9X5rpV8D9JLg3f6eGxRNUAgeZIp+2GFTSQWXj2v2X3xIorkp5Vfp925bj/fxFULnw==@kvack.org
X-Gm-Message-State: AFq9FYLiFrKfO+WqAbXpkbByHRhDdgLk+aW15qclBO5OVAnVUwJPjuHk
	KzyQrQWZNrKhkC8SbSKb4h1oU9f6KWSukf8S7ISDzs57doomMYNiLHn8mVRyx78CjK0=
X-Gm-Gg: AYBFou1clLPpyof/m9AFlu59qerqcWXuhuXcliHLSEKdcggN4jna8vDp/IFDSi2Q8As
	fgDw4i8cPeiZXH8peKey0i+CJxd3sSEDXmzKGWmeKLqA+KvNWzwHGJGQ5irpSvCSIsk7qJODTHv
	V+OmR5nbGYfSEfc9aqc3ZqPYdbK50wgEOfS0UJJJK5sCkd1+J6SJnvaetg295NZbFXrauVky3rF
	gggL+46bfzvOW+CfyNBI8k+syaA2aAoIhYbLyfv7R9dmuJsVswDuTHakQDuSRb4xIrU9nL0dZtK
	VGn7Gv7+fkFoT5OAFs38XrF1YIxA4+GKGmTzpVf5rQB/DyuaUGCE1narPNw6LZZN/JXdGucTQ29
	cD4bzBrPd3lpHf9S65HC78LAYLV2PXFZ2LuR2U51BphaTWzLfcnxe63KzkVh8DdbzWGr6yilJaU
	NBjkNio+a1COhFyx3NuLUqeEXuADcPjb7sDud2b1ZzA04YjZBcia2Bntmv0j6SHRChJrkWCnIV6
	mAcoa9fhv/FEEcRVRc=
X-Received: by 2002:a17:90b:134e:b0:3ac:9259:122c with SMTP id 98e67ed59e1d1-3ac9259151cmr5507879a91.40.1792156427018;
        Fri, 16 Oct 2026 06:13:47 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc487cccdsm4240433a91.8.2026.10.16.06.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 06:13:46 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm: warn on unaligned compound zone device ranges
Date: Fri, 16 Oct 2026 21:13:34 +0800
Message-ID: <20261016131334.3419393-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 65D71A0004
X-Stat-Signature: yatmtbqhpctznbpuk5em3s75e4mq36y4
X-HE-Tag: 1792156429-897219
X-HE-Meta: U2FsdGVkX19VVgSoQDwpAYo/5OnCjPXiZKUqD0+vHIQfMPcar336LRsxgXKrbGm+WBinPGDjgKZ0c7uegF5YtIpd+qZXAGdM2a6cod00W/wbcNTCFofzgmNlOivbTr6k5w4meBG109AjC2jm873ZCQyKth/Id+Rrr4+HBv8I7dROjh2ANelZtpwDfgM6HOB47zOUdNXOZJBM04HcXXFtADmH+k2d25spxoMFnw1MnxrndO+nS2zYJiIs/3VM+0pVOl5AglcfE+O38MXWILuJcv97+gBf8KfV/tyyLsqmubU+hnAPrFyYx8f5Z94eq1LAo5lSd2Uw2wWcuCVQvXgE39zpBmetKIgMukxTI8abTr0EbraTHjolBBSOsmFV2qjjjl1QF9nPuW4To7aruwEcaV8GKfGtiDEiScTQOoHaJAd3e26NanNgZSL4jNCJG0+4c3syMtQRukX4WPJSvQ2kiC6NrgXQuUxXYYlHuHMFZX9xLC6/pfMpSPcCQZ5PepR3d/RnDzXyfPfnGEXBkDSWNaqvFyo5Fj3/qJzvQhQONSfIad/uRCIgg1qwm3MnVlKmOiTNspD9+layHvQqLaqEecHwEBsBuINvxzMpRBw88exXaFqUYkUgVoz0uIVUF08dFP4YzbdtD2/+YYCjfboMx0rrci1XeHV5uEIGBDnR9/wNj6mFmc/Jq4CKT3hh2imFqu4TNJCJAZ+eHZQquAvNayVdB/9ZGxIX6685eh3l23tITkDOM5uXWuU/t2Tt45mUUjsl9aElrGK061TPDoTa4WaERB505nB4hKpO5MXCSZBNRZclQyu+4PQ9BXrVnRaLkxG6QEYIusCULRbAhR8SVkES+3ky6g2l/UguZWYC/9yQpt3Qz/qBX3g01qLzRuRz9xsmPcCKOJXGffTXRI+6TvsXaz5lZfidGw2i8pWzb+aq/o48XIpC7DO8+70RDTW9vUuMra4jzu9lHDX95J1
 +rkTZFh0
 LNk/NYtpRZLQqxg1+C5W3JpJuuVjDA15bi5MV0vxQsPAJylXqLgV2kl+b+50wanoRHuJ4y3JX67YOPpaYqkqBpQ4tbmm747JZGoaFYSrvthiAEAlIPWtNwMPydsf+7BcgBYgU+Y1/uijD/u57l37qrzAoPo1Qmdn9dA7tSdTDGvW8r6mWFwTiv6vU34kbeij4MAjKWYUd+UbpETXhvuXiueORLUCwZyuzoMIApdwVeqY5ZGuu1Gtny7Cvg7BRjDzNq8OflSEgkCVMATeNdyGeHNNB7b2HDVKwMGYH1h8gEpY6d1CBzKY/5eEd0GooGceRBnnfQgi9J+sYvnZM7HzImGbbOGs8Isf6HBr0Xx5rGCk3K4h14X1rFldmHwz2OwN8llWkz5xZDRxCujkSfXLbqbI2fX9tmkk0Ssmb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A compound page of order N must start at a PFN aligned to 2^N pages.
Therefore, a range used to initialize compound pages must start on a
compound-page boundary and contain an integral number of compound pages.

Two recent Device DAX bugs were caused by ranges that violated this
invariant, but neither was detected by memmap_init_zone_device().

Warn if the adjusted zone-device range violates this invariant so future
violations are reported when the compound pages are initialized.

Link: https://lore.kernel.org/r/20261016053944.2579541-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/r/20261016054914.2601510-1-songmuchun@bytedance.com
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4c17a892924d..01ced0553ce9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	if (!nr_pages)
 		return;
 
+	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
+
 	/*
 	 * Seed the reusable head-page template from the first real struct
 	 * page. The normal page-init and refcount helpers must operate on

base-commit: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
-- 
2.54.0


