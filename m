Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21463CF3943
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4714D6B0029; Wed, 19 Nov 2025 10:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A416B00C4; Wed, 19 Nov 2025 10:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9A76B00C5; Wed, 19 Nov 2025 10:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D65C6B0029
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5970BA070
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:51 +0000 (UTC)
X-FDA: 84127782102.23.1012B3A
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id DDFBA80004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=dsSKnwsd;
	spf=pass (imf30.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.54 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/EyDboeiBDU/UfklOwVUegNW3M8PrbX9Ov8/f+MrlA=;
	b=xKOZxSnyQX6GQG9teyV5FtMTZ4kEBokqoYPFkidj7z/C4zwy1G0/Q4DndmQR423D27hF53
	kfpa4idqK40u78PC5TANzMIKkkqjFUINTS2htQxEji0e4uKE2POYeYxdWE8Am5dDvx0MfK
	BYXVtAZ+6R5Kzmi44iss5ZDLAtj6+qA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567150; a=rsa-sha256;
	cv=none;
	b=qL5sf7byjXDsHjWJS268OeimrdVes3cJbh8GHLNDVUF0Mnwo52kR5+dwj8kCNXgyDlmqcN
	YC3CaDyC+zdO23gq4+bMWDodQNUrhGLH7R8CJDSVf75c3YvHJwpz+zlx5D2qzi3sdRtZLy
	Nposl/X2E45l9ByR4AN6hLMY3lhHRhU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=dsSKnwsd;
	spf=pass (imf30.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.54 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42b3c5defb2so4677190f8f.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567148; x=1764171948; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/EyDboeiBDU/UfklOwVUegNW3M8PrbX9Ov8/f+MrlA=;
        b=dsSKnwsdt6ognwWV1URe9myGY47R5Dx4iXviVLyPwH3CmV8rrPgzv9BMEbSUTt9oT7
         CuW7t23y9srYQXrh/2ciAUTi+ZAaiPTMDq8l1tKX8uxTKddNi7mLKwSkv33Ll26S3iE+
         NRKQNj7bl6FV6hDMTa4Y3L0jhzlv7/1uYCseYGT6C6Lyt2U+Jx+GkXc2bI9L1oKXShtt
         q7ZY33C6rn3g0BkmkHedEQ2QsGTEVqpDaa22ZlhmZCcYfxRXX+i2Ff9wSB3XeQ9m2moB
         KZ4IvniF7Lsyg5WkUvlaxu1UYp2LjWO7zS/b5b/py9Q3SIJoVWUz0zhWTxPHui4lPAqs
         LO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567148; x=1764171948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l/EyDboeiBDU/UfklOwVUegNW3M8PrbX9Ov8/f+MrlA=;
        b=uaPPUsK2KYxHh6lrRfGzoeivZwDOGVyWBpaL1Du6ZStAYaYRkZjCQWB8SMEmcAF3ir
         vep0uh43eaCnAkUr23WHE/GJ5yeviRWxNNrMd7wxkGcyAuYwD8TNqrtaUnYYyyz6xYoc
         j3bNXEelwpBJiolYQR1s58h4C5JFHGoo+U+ZDjqSdM32HTu0EkMcdOQmbQDaRabdJeMd
         ThwYCfHmQMxoJ0aE0RwioooD6JvpdwTBYOBTF4xbwtYblm2GUqL8Xn57rTSJFhWT1rc0
         pabMGLB2J/y3tBXVwk2cp9lyP7ul9I1QJQkLd8QYS5pfc6djDB8b9ebwj0KK2GigMRY+
         ANtw==
X-Forwarded-Encrypted: i=1; AJvYcCVa6BBpDs59sIUNTKAlH8k88jeJB76IFvC0qwVJ97A0v9sNRe+LquzQlpkDTWW/n8lg8uVZzjARHQ==@kvack.org
X-Gm-Message-State: AOJu0YyObyGQVwXSCdhVfc6d6wvz+pDmgW5lBL61E1NjS4i63npvN9KC
	4UZGeXQtwfvRxNJLtdZ7Ro1hGRE6wae/M1YJ8nxeECELDZAkgE9mjqb/Mo4KV9xp6a8=
X-Gm-Gg: ASbGncum7Mdcu0l8MzVAq0OEFM52wSi8adG2DKxQGkmYti/+I1D1jWZqkzBk3oGOdUp
	fir2Legkk4jx0IAzUw3ovg0mCpe6cJQpYXl/RgHtdFfQ6YJYjNpIBfHSkZMAC9sDJdnSlxZhllm
	VpNkMSssM5Pq+o+SJdJsLaqnCN9YWV/5ttrqy1vabO3JkUKL5XS35mwl9GF+aSrP/xPVDHVtESo
	dtf8VSMhyZr3ic8U68KVMCXtC3Uk9j6g1xxX/zgywz/29TnN/UXPR7YnnUQh2QIkfB8eeEsVkCy
	8nBdIZULmTirxIcwCYo1O5mbV6E+O+Z2eLZeaOMk5XSfPRWnwDIMR8DlkbGRtruqVpX/mocOutD
	sXMhbpQXe5eUqswAJ0zsENrF3X4amSJ92A8UL9GNotm1R0j4f1UHtW3RqkqeyWtcgShERmvvhES
	U0oYYso+hOVXDvVTI4CS4=
X-Google-Smtp-Source: AGHT+IG3jCLeDmXIRQk0s6Z/im1uj+pkHlGcqCZtyflKDhFiJA87zd6Y92IL7f4uFHeiMPUMai5jbg==
X-Received: by 2002:a05:6000:64a:b0:42b:396e:2817 with SMTP id ffacd0b85a97d-42b59378468mr19534486f8f.40.1763567148170;
        Wed, 19 Nov 2025 07:45:48 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:47 -0800 (PST)
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
Subject: [PATCH 18/26] mm/memblock: Add MEMBLOCK_INSPECT flag
Date: Wed, 19 Nov 2025 17:44:19 +0200
Message-ID: <20251119154427.1033475-19-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDFBA80004
X-Stat-Signature: fe8gzw6o5wxnapkh8rpibg69kju4ygro
X-Rspam-User: 
X-HE-Tag: 1763567149-698348
X-HE-Meta: U2FsdGVkX19zNhNxqUpyYoHqjk+OEXI73XB+juNSERjRG7E/hP5/NCm+15Q6LQET+TvUTbCgZQxZdwabw31X99OmzC6T8aI5RZ8t6G2kgO15j1zBPSjJeYzmNQxcwigWA0ZfFFvTCsKcrIc9IUXH31AIFuhlFOT6PVbGiIXHRwwGJAJXFWhFhJGC/B6bDTfyiC8H9btJtbxXyhdm0Z2p+883PbYmNmrOHO/NOAqRFge0F+KLXydRs7Fq0UHFgAnVYlFF7mfYqC7kSwrddzGCVR6UcMJiWD/IWZBNfXx4a/Tl3lC7dKMNlEKmz2uRwWlnA2XTnzhKIz5UlAxEYlQ1Db3ZW5ndQ5RgKyAMbqUGLZEW1LlB6kdlIox+aMEl4wtYDciMyg5qfFymvVAtgcAPO7MdQJqsyVVWB2YxW34HVqt0ws6r/kVeUHrE/aWEGgmz2sjtpPAgy6x+0k7zmVOHURVPBWSsvdIUnIfJFEOIty4ALvqPrHd5QSty1YU0x0WltkGBmOSREiusQVU3omQImfKpARYu3ObmHMpkXRbdCbhumU6SyoESjPIufDKzWpgd/wIbUwSNPdqaDvlWalpbpAMJtImgfmiL2QNPyE0u9nCPqSqa02RMyGzfanEebodVvnxu3iZhzs+2YgTv9QwybBdU3M1PV4e3If/lDJLQWvOj7ltmKRM1nKYmtCKQmNTuq8GIQ7PbUWXJD6IqOnQXWff4ZidawQrlstDOFagLor6A+LfpsPtQWLRXeyGFfZBPErvraqGFNk8FaT9ZfTCci57tqwdpFtngHXSDvoDFTwCZSwtwHliw5HojS50jB0i2SoT+5WhvFsTGURIRx+Q1DC4HQ9X7bNTVLUUyYiJ8eFF6/3wMeSkYX1UtLP+IegCc8+guxayfz8aqE8K46xuJEM/bImHx/2srzcQMnLfOx6+pDRlvu65cX+6Le2hLJNSBaYeQ+1desEPMA+/DWeZ
 BvKznHFI
 DUwszHXdpfobbdcXw+3SKG2O45o8SfdVP7nHqw/j3axOU/zClJTEQnLUDKuaDTB/qjC83zh11x8oA1JiAv42Xif1ihMDB9Hl2Vs/adKQM98yb+KOTiYPglvD3SFEwwynE+uer3mDrtl0itbLtqwRnz4JmcIiLnrW8mSWGibmmB/HzCWiRsonyBlsojx0X1kaZIwWBwxEXEYFNKn+i1FOd7IBdkuM8DrztvJrOsMVAa8wrAZSdgPyPd6K5bnjg6/GY+/AgyOxZSEF9edjhQiAHoVUIasjldW0xkYGrz96TscUU9VTLmTRn1vuCbnDupUwHeEQ2Sx+sHFkJQJ6RBjOSBXI3vLePQ1aM5x/ciSVrxI3jMQNOonYROAvepmDFemBkOm8CG5a8AO05QE0elToyveaWMsthdlP8w4IW8qMWcrTUmzcx7L6dmMwnbSmV/Oe77EXzSEinyaheHFL2gv0PEDTVJcNa8Lrmsd+XoW/mNMGBJGEDfC1M/W3Uf5uQ5AZGMrmtDcCK/m6S9LAo79XHaqnkL5omXOPtgc5t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This memblock flag indicates that a specific block is registered
into an inspection table.
The block can be marked for inspection using memblock_mark_inspect()
and cleared with memblock_clear_inspect()

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 include/linux/memblock.h |  7 +++++++
 mm/memblock.c            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 221118b5a16e..c3e55a4475cf 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -51,6 +51,10 @@ extern unsigned long long max_possible_pfn;
  * memory reservations yet, so we get scratch memory from the previous
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
+ * @MEMBLOCK_INSPECT: memory region is annotated in kernel memory inspection
+ * table. This means a dedicated entry will be created for this region which
+ * will contain the memory's address and size. This allows kernel inspectors
+ * to retrieve the memory.
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -61,6 +65,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
+	MEMBLOCK_INSPECT	= 0x80,	/* memory selected for kernel inspection */
 };
 
 /**
@@ -149,6 +154,8 @@ unsigned long memblock_addrs_overlap(phys_addr_t base1, phys_addr_t size1,
 bool memblock_overlaps_region(struct memblock_type *type,
 			      phys_addr_t base, phys_addr_t size);
 bool memblock_validate_numa_coverage(unsigned long threshold_bytes);
+int memblock_mark_inspect(phys_addr_t base, phys_addr_t size);
+int memblock_clear_inspect(phys_addr_t base, phys_addr_t size);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b..a5df5ab286e5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -17,6 +17,7 @@
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/mutex.h>
+#include <linux/meminspect.h>
 
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
@@ -1016,6 +1017,40 @@ static int __init_memblock memblock_setclr_flag(struct memblock_type *type,
 	return 0;
 }
 
+/**
+ * memblock_mark_inspect - Mark inspectable memory with flag MEMBLOCK_INSPECT.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_inspect(phys_addr_t base, phys_addr_t size)
+{
+	int ret;
+
+	ret = memblock_setclr_flag(&memblock.memory, base, size, 1, MEMBLOCK_INSPECT);
+	if (ret)
+		return ret;
+
+	meminspect_lock_register_pa(base, size);
+
+	return 0;
+}
+
+/**
+ * memblock_clear_inspect - Clear flag MEMBLOCK_INSPECT for a specified region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_clear_inspect(phys_addr_t base, phys_addr_t size)
+{
+	meminspect_lock_unregister_pa(base, size);
+
+	return memblock_setclr_flag(&memblock.memory, base, size, 0, MEMBLOCK_INSPECT);
+}
+
 /**
  * memblock_mark_hotplug - Mark hotpluggable memory with flag MEMBLOCK_HOTPLUG.
  * @base: the base phys addr of the region
@@ -2704,6 +2739,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_INSPECT)] = "INSPECT",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


