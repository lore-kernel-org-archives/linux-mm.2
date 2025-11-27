Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B097DD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 195CA6B00A1; Thu, 27 Nov 2025 09:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DBA6B00A3; Thu, 27 Nov 2025 09:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0839A6B00A4; Thu, 27 Nov 2025 09:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBBC16B00A1
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:12:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF8B41A01AC
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:45 +0000 (UTC)
X-FDA: 84156577890.08.E4103F2
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5771160003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:12:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jl0QBl2l;
	spf=pass (imf08.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764252763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7glhrA2/bhcJ3C4rVIYMtSTbP/A3a+HxT2eJKeURbio=;
	b=ux4r+aoUKZFXityYVF6hriTWnnEeKnOpjqSGsCTwzuMUAHS/uaLxaYnLSTX+E+oPaxkkhc
	4c4w3idvAFoexdW1RvGalJVFChkEqUOvETi1wJ8MKS0svL0/VNgOB+rUJ/cbYYkQ8Q+3ie
	ORnhSvaCDz8Okyk7bAFZZCGpj6KWHP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764252763; a=rsa-sha256;
	cv=none;
	b=1hybyG4Ua83fJTh46FQUPTuNb25GLFyT33GVdx5q6P/p6rgQJjIvW4qoFaW0sKTVaxYHL1
	knJGsEP/swfk0s1A0T+/xTDH7tcSIuJ5xEUmrH4cq7dAvrw0Z062OeVis4Uou23jhk6qzg
	QWa6iFbImrRW7mJJzfLBA49G7UfEj+0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jl0QBl2l;
	spf=pass (imf08.hostedemail.com: domain of luxu.kernel@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=luxu.kernel@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-340bb1cb9ddso722602a91.2
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1764252763; x=1764857563; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7glhrA2/bhcJ3C4rVIYMtSTbP/A3a+HxT2eJKeURbio=;
        b=jl0QBl2lHfASe1q/ycrwtOuZ5ZlYZaagt4NFxUk4hrjZNBWU9lrNjeyQCzooaGPs5V
         /RFpd4W9kzSonD10kUduXOUn5GQK/MI0t4TehWr96ZoCq8IBY7gaC0NgF8vse9yRWTyj
         T85Y2bsFrdEpYHVTougig6T8HE4/MWplSfX/W9kxB2LOLfj/wYIrMZy/C0f9PfxdPYyV
         fsNqNFUcvRtpJBVtZFWgYt3YFsSpxoFebwK5p2GFc/eMlevjtojJ7IVdmbBa5ZKvOFBA
         24RfoJW6aVkOnLtB6xXTdMkkrAUoyr126keabUKQUYkbHYMKeooRsosC/PNrKFfDHU6y
         zUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764252763; x=1764857563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7glhrA2/bhcJ3C4rVIYMtSTbP/A3a+HxT2eJKeURbio=;
        b=n38rAxv2NCxOYzVsxeAlCZ4tmI6Jdargkx3dJtGGUYH+/eyiEf1qBTttm9Gj+blsxa
         Kg790qCodQIxPYljeDZk04NqCQHlFu/FH7tETZysRmAYJ1a5sjJcqzyJFHHmE4y5SA3L
         /1OlShslF+HRNknGY9+I/XGqkCZW4oZS1Oh94tDmvRve8NEjlQcvabCHBwo8HaftHkzI
         DnNvRrJiSo2pIm/JJkni2HYejrMj5ieI6WawpRyfdHI6+PNs1v1ayLLaFtM87iYzUlpP
         SvTuaMLtvrnE4hqvIxrU6M7yqy59VArUf+L8j+SxUL+xrLsg00PRlicEcIn0RtQbBTUs
         7Raw==
X-Forwarded-Encrypted: i=1; AJvYcCWqpT3+ZXYA/Tuj/mNAgOeZ1jKJTmxjx+pCOZuN0zx6NrvIdrXQ0c770MGYSGccDB6ZUNXD4+kNjg==@kvack.org
X-Gm-Message-State: AOJu0YzY8E33sG1uOaA50yp0ecsbb8F4bfksk1FCp36H5wvvoleABvKr
	sZTpq1pd8HTDpIexWjINfpjMU4fZR6Jw478jbx1yskuu6nBc+az5vnqRoa4iAQUtm8n8F0yBp5v
	uAmEKACEtzQ==
X-Gm-Gg: ASbGnctN+d2a1ewDIPPa5cRfcj0DufviTbz2SgRQu1ef8oD9s6oDCEf/jVFVKNKrFxo
	i7YII3BuokFHm+I9fz79f7gF72zSzV6urtbU5vmjkfmV3oFFN3XufOJZmaKOxWU98CM5Azh1rwU
	DYu4z2tRhsJ8grn+2DQx07q+ZasHnF6/YJRIikImpgn/+MN0lhBKuptVYVl04Yh+SCyuXipJj7t
	Aq5N6/XCi56+uU2EfvEC9WwlQJq4/8MaJkAby4U22TEjlDtnvI03n0iSCy9aB95KUYUNFCjfnOP
	iMdtXtKkAHph3F9V3H2878XPlDU73qLNrt84txfhlNnbojCdKrax+AygSkR767QLzFOz2NoEKjO
	hEkDYMqMgnXLZTlsddiCL9OsE0GWIQAH+1vUbzVCNK7Cy9uigopTsGe644CpsyY4+kB2CP305XJ
	5M6MWN6WwkrcnEPQzEDqh/LiQyZ9/2x7vF34fQHpvLFEd5+5ivIcTy7QXlx9EpZD6LltNJlE8Xq
	Q==
X-Google-Smtp-Source: AGHT+IGJodAk35vvTSCefFgpwaOAVIMesvU7l7N866cJmylZ3F8YVFLaZ662o0Sa9lutX8QW3ovQ6w==
X-Received: by 2002:a17:90b:3502:b0:32e:a5ae:d00 with SMTP id 98e67ed59e1d1-34733e72350mr22757635a91.13.1764252762612;
        Thu, 27 Nov 2025 06:12:42 -0800 (PST)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3477b7341d2sm2030249a91.11.2025.11.27.06.12.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 27 Nov 2025 06:12:42 -0800 (PST)
From: Xu Lu <luxu.kernel@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	apatel@ventanamicro.com,
	guoren@kernel.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [RFC PATCH v2 7/9] riscv: mm: Defer the TLB Flush to switch_mm
Date: Thu, 27 Nov 2025 22:11:15 +0800
Message-ID: <20251127141117.87420-8-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251127141117.87420-1-luxu.kernel@bytedance.com>
References: <20251127141117.87420-1-luxu.kernel@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D5771160003
X-Stat-Signature: egg8ffhcchcjcdzh1so5a4md6rihj6f6
X-Rspam-User: 
X-HE-Tag: 1764252763-839099
X-HE-Meta: U2FsdGVkX18cBQlkhtLwWWOeXHyZq73wVvCrRkQGIym+qQ39HcaeYvibg+eTlbh2kIEAXtsIrLQL7WvEeLinuRquPQdCRMxjPuQXIBflz0Qv+c4I/E1GRn2zXOdiO+B/OSt/F6y7utDdezHkcC1/HCqLqZUoGB6nRX56neZ9CfVHWrdrUGnxp+wEex4zVHrqmnPfxa/aAKC9CbTG+RTUWiLj2H/+z8T81fLu+DvRI7Ay9GY5HqK+DuP+RBnW39sq69RTawSwpqL30lJOjjPHaHrtrVb7INEsoEojHWwr2TNJdolK3FwJMjnVTjnDk5bwvBDGZEeiJeAb1x6biFumNleWohuzAG9e4ylcy8ycQXiQLPlDbjgMOVWpJmeoWfn+dcw9F7u7t6cUo9fID1xyRjkyrw+cJSH+wTV0XcOCWAs09Ngk7k2hHfPU1HvKJUYI4xgFFp2Ne73FsVOZm/oiJqKiyNEFKRjjH2tWUnOavKeNQ4LRGXAoSJD2+eX0F/fP1o4gG3O4c5y4o6gUTKr9VeqtsGEShhCYp4s3oHLf9Ef+vK9tmXhvtSVjB71923PtADL6yqRoS3RylCckV9f561L4eAdxsz3e8YhPyz/abI4TieBaZBS9uI45hGHTYb3R1NFrOAa/PLVU+rP0uQTMmGmEMNteFZnP+aXTegALxwqZ9izdmdMFYkYgpPyAdjVdWcUSmqf/11rVvZSMAqLW9Wnh0nqbpppWNtmD/e3gvJnC4P/K5stkUazmY4XZBccNrPzTkaWbneg0yaCJykY5vs15+FmXgo3iJ42rCJEPBLx0LEYEoiNhxpfLVhGm+FTEsD2DlqCG4blKnxWVZX0/3TkvF0ka+wtvrORP34cNj45MWIkrNQrcqQwh2xLl5fS8/AAxeyNsOD0+D7w+Ak+AbgdeZbxrn3IhbjTCg7dWLPGFXi3aSUc52dbqEZEfzrzn7uI6+7+2an76gaFCpRm
 OXCk4uso
 /7GTx6ArDIxPpj1DbHQyo8QLNvJcjOnX1ylA0aLXgYez10R8qpMW8onb9KFqWKd/DOArsc1UZAaulVGSjN+zcKO6OB+MAaNVBX0BfkxGZKI5qe9dZYYVsA4lV0t1wwVBE33uM7nbw9tP7Gbi+qoFhvTsXmEHu2aqciueEHbs/lyVHp20tXGqRdWedLuhDIim3CO+xfrw4KQtDIWczLX6NCpSejdL7raUcaUnhUl/zRg+rwZX09mHRZLbCgDQwi112oQhTG5SPtc77jsXDZjmxOCL10oLTlvIGzivo8a5uKq8RaCpWOz/YPi7QaoycoWt+KAh3ufWOBBltjLHGKlsJfalBTqiyEoA2WGnAOjsEWezBXC2YuylBHPjO4mufu3I17H0MDIr4kuXDQ9Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the TLB Flush IPI is avoided when the modified mm is not running
on the target CPU, next time when target CPU switches to the modified
mm, it has to check percpu TLB Flush queue and perform TLB FLush for the
midified mm.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/mm/tlbflush.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index b5a2d9874d62b..0083fac87c2bc 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -365,8 +365,10 @@ void local_load_tlb_mm(struct mm_struct *mm)
 {
 	struct tlb_info *info = this_cpu_ptr(&tlbinfo);
 	struct tlb_context *contexts = info->contexts;
+	struct tlb_flush_queue *queue = NULL;
 	struct mm_struct *victim = NULL;
-	unsigned int i, pos = 0, min = UINT_MAX;
+	unsigned int i, len, pos = 0, min = UINT_MAX;
+	unsigned long asid, start, size, stride;
 
 	for (i = 0; i < MAX_LOADED_MM; i++) {
 		if (contexts[i].mm == mm) {
@@ -387,11 +389,36 @@ void local_load_tlb_mm(struct mm_struct *mm)
 		mmgrab_lazy_mm(mm);
 		victim = contexts[pos].mm;
 		contexts[pos].mm = mm;
+		contexts[pos].need_flush = false;
+
+		queue = &info->flush_queues[pos];
+		atomic_set(&queue->len, 0);
+		queue->flag = 0;
 	}
 	contexts[pos].gen = new_tlb_gen(info);
 
 	write_unlock(&info->rwlock);
 
+	if (contexts[pos].need_flush) {
+		queue = &info->flush_queues[pos];
+		asid = get_mm_asid(mm);
+		if (queue->flag & FLUSH_TLB_ALL_ASID) {
+			local_flush_tlb_all_asid(asid);
+		} else {
+			len = atomic_read(&queue->len);
+			for (i = 0; i < len; i++) {
+				start = queue->tasks[i].start;
+				size = queue->tasks[i].size;
+				stride = queue->tasks[i].stride;
+				local_flush_tlb_range_asid(start, size,
+							   stride, asid);
+			}
+		}
+		contexts[pos].need_flush = false;
+		atomic_set(&queue->len, 0);
+		queue->flag = 0;
+	}
+
 	if (victim) {
 		cpumask_clear_cpu(raw_smp_processor_id(), mm_cpumask(victim));
 		local_flush_tlb_all_asid(get_mm_asid(victim));
-- 
2.20.1


