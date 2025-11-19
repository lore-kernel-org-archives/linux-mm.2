Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385AECF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC686B00CB; Wed, 19 Nov 2025 10:45:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3852E6B00CD; Wed, 19 Nov 2025 10:45:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D9E6B00CF; Wed, 19 Nov 2025 10:45:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F00A6B00CB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1E631A0513
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:56 +0000 (UTC)
X-FDA: 84127782312.30.47D55BB
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id E51548000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=lsZBsV+A;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7Ucs3kp0oXjJAHNPlew8LSoAGCaHnYy/9pb2BVOQfw=;
	b=o4nJGoMTEeH2l58s/tmgdeF/8cihCgQZIUBlQJhkgU+DNGEbXKDlOQaKYLWLzb9JlOTcbQ
	fmDsK/mM5hm8gufGcmLM3dJAKgptxKXnIgMi1g1k4X7dt5yiMDtrzm5w4mHlDO+zXDPhJQ
	0FYTyHaRMzVrJqIX8vlzWFnGpfPdj4s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=lsZBsV+A;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.51 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567155; a=rsa-sha256;
	cv=none;
	b=gY6b+A+STV4fFsWLVb5+Ni4RBT8ji/3rtymjCDB/SEBeGDn3wi1l9HE5cjRMopTnPgj7nK
	7FICWXfFDfJkyCCKtX+rmo29jbkTptyCpQgkCQwUFXfpH7GALU7m2bThPNO6p4cUUXmp89
	v3GS8YlmXR5bDugduKf1hJ7QIvEDNoA=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42b32a5494dso4139083f8f.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567153; x=1764171953; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7Ucs3kp0oXjJAHNPlew8LSoAGCaHnYy/9pb2BVOQfw=;
        b=lsZBsV+AsevRqEb+he5XPsOuDoFN+VYFaNlUEm15fvJP+a3CWUujfY36JHiUZijQQl
         /Nv5aHDpdv4y3HJlPgmo7EQGIZOJzBRrj3uofbzM7kNmQjPJsw1kIFM5lMQh/WkRCPOQ
         kH/VrO/Ddzsz+oZxXEZW83IcDcDhaOmwiK2Q0WbBjB4oQUmLPi81Bno62GsApwTMGVv4
         Ey6b53ImPpSrvDWDO/wcpaWnfeZ2/Q65Sad9dI1HYcM/sNqS/UabV2FTC/mx4pjMKY6p
         bkcN+Yp0sGVNF1VZJ5XPPYw3M+zfb1J3OXmLeAZgmO3dUuoMnAze4a9gQvgRWN/1ZprM
         2D0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567153; x=1764171953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y7Ucs3kp0oXjJAHNPlew8LSoAGCaHnYy/9pb2BVOQfw=;
        b=VfeWRPKHl6ERikh5b95TUO60kQsZlq9Z99hXJCSquIGhnfdjtMdrzpkhadBWbroP37
         37h5zQ+b8U8Qu+Ncfjusa5Ln8c4LnOTHSiDH/vSBfJktR8JOM4qD6HCtIsgNTcusePHg
         ghrXJCG+aI9UzxsY+z2n9/a0R1HMnSOHBsZhdUgkcA1JrJcelrn26KILWYKSGqKrb/Y2
         naK85A/VPgYoRVW+YD9ufQzivwGDcet/SQZllXcqGCR93v2/MMR1slsCRfLMW+iJjoWJ
         6ndJay6V8nq/5cAZJIW+r5QHVXhYTgShxZDfsRp58VTZaQbEoYVam0uVJ0UG2+k4UubP
         +Jgw==
X-Forwarded-Encrypted: i=1; AJvYcCUrhy2j1j30RiSibsK3l6v3dt+hkOa4B52Nx9UNHKjfUiBXWZDUO857EBDV5MN+ofT/y/FSpxPhuA==@kvack.org
X-Gm-Message-State: AOJu0YzAoEJjwKTm4dcnBaoqXp7BVpCGi48zUPq7hrpg+RRrQs/PemR3
	HmXTVdXUelcu5gJVgYiaV2mxcm8GbUUQ7RFwYU+F9fbKwiBA47aISu7fBLlmMh0PqUjF34CrRd7
	/gIVJya456A==
X-Gm-Gg: ASbGnctP19F4KH68XJjX4GzmW8i6vFOUNTQ4BR0Bpys9Nf2aOnmyfZ6TbblXV2hRlqe
	2PioZJ5q8mIsOET/xp+B3sqA2/7R2bnXMMlaKlfuA2MIQ2SLEWuuW8UWpnNkmav1EH3SRJWrXWV
	0/8zKKsnZhV63wh3CXGJJ8ApZNduvsv7ZS/Oyk/vYO8rybDNgAlMvAIVubtJlecD/B7dv24PkQv
	7T9dg/S3k4a4OhCnLklp+xVJrdmzeN1FTKogahEU1Y8o2rXMOyprqei1TfRAIj6LAMClJmiSQVz
	7+g7r1nvzRBNwaq5845Ou3sLtrC+kzFjZy84cO0ypYfRw+vIN+86Tf89beVx2jg0nzAlJ4I5unP
	oplPBrB9uu9bKgnNA8kMAz3bUMQ/R+QWwCu4LCvAuG1uWRT4rLzv3JxISWv2IYKgUIFDt0KURVK
	0ssuWlxsWkBg9bMac+HcuVvkmMG2rgCw==
X-Google-Smtp-Source: AGHT+IFMxVwxw3DtlUhFwveVzixkh9p9iHWd+faYE31GhqiINsGSMiGzAK7z2FWSCj0eS8F6/aaKoQ==
X-Received: by 2002:a05:6000:2510:b0:42b:3e20:f1b4 with SMTP id ffacd0b85a97d-42cb1f1de66mr3206403f8f.5.1763567153508;
        Wed, 19 Nov 2025 07:45:53 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:53 -0800 (PST)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 21/26] printk: Register information into meminspect
Date: Wed, 19 Nov 2025 17:44:22 +0200
Message-ID: <20251119154427.1033475-22-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E51548000B
X-Stat-Signature: fe6age8pdea3iwxihra5a9gfznzdheyw
X-Rspam-User: 
X-HE-Tag: 1763567154-372029
X-HE-Meta: U2FsdGVkX1/3WCJShddHVP440gMfeZ5+INnTWljdCpw/zWdTbrw7gefyoMxx4Dm7055RyPpoyx7kbYpzky5BrGzmjIXmQKhYinAH5OeqLFgwcIPVX4EEInzAnBqot1ArHL9/jxTakG8cv8rbtPHHOhjHDiywq5zUVaDo+0pG9driwWZ8XSFaDfxv/J8VL9NfNvFcFKnmoZDZB/51yaJmXlQRwI4Mzx3qp4knK1ddbfrwYWODNREIU3vVSWVm73qu6ki3xMHadW/1S4F9wCz1vB6ZEUrx0NO+PUgaZwqDuA1BIinYvaS7dtLyau8aGKQnZFIJhLX7/y8dtsQJZlu5FwSYWGZQ2vFNHOM87MU4BcTW1IGypBs0xCQpjMY3vC9/8sSe6FNADo2VC2R7ZHt7sL2Z4LR0RlSjHUn+41GjjaXd0vtHawkexwXGOfcR1k7R1R2CUtFBr3Ljvff1mx2wV10tp4iDzu+H6a6RwKNQJ+KldcuHCdp1OY3oO6B7DEfmKSQmXdG2xQyYfadlLY16vnjTtSWvIBNDw/xjTkhcEaS2m42E3PunAL8b4EENeK7iShg3LaOrwLt9wr6NgfNhnWCmqM68lTIeQVZ20HWecYSkowGTDizMddgEkPYQ2cNPh7F//8B+HEv2zrU9OxuL8dntZJBQtTSdw1wFNMe3GVWPQng7RYbtYFLllI+OHbWJr59XO5MSxepTT6NtoxaTUWkdPA8YPUvta4tICMYIxhHY22g5gPn2ouma59J3LEgX9dWhiJ3dUaQzEVm3bkGfxWcSD9R2i3bQpm/st40jZNNtd61XYQSCeYVsZ5l+vNBh3BFQ8kyJiitpx+4hj6Y9RisxZwEVcfaJVkacpYTqhLDbWrflrW9joPyfw34Dd4ngMz0mhwx8oq5ottCK8/6Tn9zAaAHdSiCz9dyBbmEMJxoqX+VDWBvIOm2B6OWaV0tpbKwrigzh3nG201vCLI8
 8Zqr3a1H
 2bN6WgBhet2W1o5mtJGcahvjd0y8d020z0uz7+aCQMFfjGV4KDWHXubTz2zUBqyEtphPGap5wNp7fnYIgN47QR0fIW1N51Vj+Db9VTMKniGdSSEfP09CZRAjtSPKt/zzZ/4cOqePkvmIKl8FpXPGJFB8/b3pmXlo7urNRgc34SgwiHJaIka1aFk/V0uIrbVv5zY1WeTfloM8/RKAxRt0fwx1cSOqOwhhvMCiUGLWfa2xsp3lRcoX7zQkoWY4aFylHFhqm8z9NbicNzmSX0b0MGslqTly0sDrgDONeddu2qHaBk5kuDG542g5rgyjOOocq4xAC3QhkJAoQSIMmjXBE5YhLWuFpjmc9z1U/8t+Tt4dYYbGyQNtmyM2h6NIV/ufu235Tw7KEDaP5McZD/zel8V84SBu+IbKnyoeewKViYwFpqUiv/KepegzMKxmsD6sSa74sHa4xQTViaqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into meminspect:
 - prb_descs
 - prb_infos
 - prb
 - prb_data
 - printk_rb_static
 - printk_rb_dynamic

Information on these variables is stored into inspection table.

Register dynamic information into meminspect:
 - new_descs
 - new_infos
 - new_log_buf
This information is being allocated as a memblock, so call
memblock_mark_inspect to mark the block accordingly.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/printk/printk.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5aee9ffb16b9..8b5aba2527ac 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -49,6 +49,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/panic.h>
+#include <linux/meminspect.h>
 
 #include <linux/uaccess.h>
 #include <asm/sections.h>
@@ -513,10 +514,16 @@ static u32 log_buf_len = __LOG_BUF_LEN;
 #endif
 _DEFINE_PRINTKRB(printk_rb_static, CONFIG_LOG_BUF_SHIFT - PRB_AVGBITS,
 		 PRB_AVGBITS, &__log_buf[0]);
+MEMINSPECT_NAMED_ENTRY(prb_descs, _printk_rb_static_descs);
+MEMINSPECT_NAMED_ENTRY(prb_infos, _printk_rb_static_infos);
+MEMINSPECT_NAMED_ENTRY(prb_data, __log_buf);
+MEMINSPECT_SIMPLE_ENTRY(printk_rb_static);
 
 static struct printk_ringbuffer printk_rb_dynamic;
+MEMINSPECT_SIMPLE_ENTRY(printk_rb_dynamic);
 
 struct printk_ringbuffer *prb = &printk_rb_static;
+MEMINSPECT_SIMPLE_ENTRY(prb);
 
 /*
  * We cannot access per-CPU data (e.g. per-CPU flush irq_work) before
@@ -1190,6 +1197,7 @@ void __init setup_log_buf(int early)
 		       new_log_buf_len);
 		goto out;
 	}
+	memblock_mark_inspect(virt_to_phys(new_log_buf), new_log_buf_len);
 
 	new_descs_size = new_descs_count * sizeof(struct prb_desc);
 	new_descs = memblock_alloc(new_descs_size, LOG_ALIGN);
@@ -1198,6 +1206,7 @@ void __init setup_log_buf(int early)
 		       new_descs_size);
 		goto err_free_log_buf;
 	}
+	memblock_mark_inspect(virt_to_phys(new_descs), new_descs_size);
 
 	new_infos_size = new_descs_count * sizeof(struct printk_info);
 	new_infos = memblock_alloc(new_infos_size, LOG_ALIGN);
@@ -1206,6 +1215,7 @@ void __init setup_log_buf(int early)
 		       new_infos_size);
 		goto err_free_descs;
 	}
+	memblock_mark_inspect(virt_to_phys(new_infos), new_infos_size);
 
 	prb_rec_init_rd(&r, &info, &setup_text_buf[0], sizeof(setup_text_buf));
 
@@ -1258,8 +1268,10 @@ void __init setup_log_buf(int early)
 
 err_free_descs:
 	memblock_free(new_descs, new_descs_size);
+	memblock_clear_inspect(virt_to_phys(new_descs), new_descs_size);
 err_free_log_buf:
 	memblock_free(new_log_buf, new_log_buf_len);
+	memblock_clear_inspect(virt_to_phys(new_log_buf), new_log_buf_len);
 out:
 	print_log_buf_usage_stats();
 }
-- 
2.43.0


