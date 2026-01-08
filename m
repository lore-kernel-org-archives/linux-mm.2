Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37BCD1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 18:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C466B0088; Thu,  8 Jan 2026 13:03:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163B16B00AC; Thu,  8 Jan 2026 13:03:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090896B00AE; Thu,  8 Jan 2026 13:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA8BE6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:03:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CD3D1AEE1
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:03:19 +0000 (UTC)
X-FDA: 84309568518.30.354E2F1
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9BF7C180005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:03:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767895397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9fTSUEElSptFXw5hcWOsyzyjnkoVvF+cCjmuU+D4lPc=;
	b=0RsIp3+HTwaf9l3LudrnBy5ks9s7tBc4XrlPDGTsY0hImeUdyMK1bcXcraHBdr5g3E96pn
	GRHjE+gTnleGV/KJSQPRZrOJDMrwAtPD48Xk2QXwYDjOte2MxmoE/vsjBNMLWv/sgY6uEy
	cuqP47nkwgUthH9R/Gtyf5lWWwPrDNA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767895397; a=rsa-sha256;
	cv=none;
	b=uccT/0jlkNNHP7QOFUav8f5OkK1zMOXb1gp5gXzBsT5U6PJ1Gy/zlDxqTvDg1A5iSvitsW
	zWU6AWRIkZ/htxwJuZjXCNabnam2slUQS/vbkkKHnXH9zo86I8hZGzgLDRFQYFMkZBfhHG
	m/fMkEI1DfooItVG7x7uAf9+2px0DHM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-3e3dac349easo3063706fac.2
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 10:03:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767895396; x=1768500196;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9fTSUEElSptFXw5hcWOsyzyjnkoVvF+cCjmuU+D4lPc=;
        b=rlpt3ltb6BA4PuEXLh+c01vccIxXhTsKEZjgLhXOdBhMf+EO6z14YXX80wte7BIRnS
         IBHmBsQgnRGGwyxSYdYjtsVbASC+VvdKwpiascXFUYgXuh3s97vpxNYN2z4ve4aVGtm8
         DCXZgpsEG/cDEC1Lfnc4vMw0enXKGsSjEJUvOieynQ6e6z4NpEJvBhjosDS6eL76CadF
         nURulmwIb9MfYiZph7kkKnJcPhWti7SklKP6VqtlA4i09e4SEDgHhO7CJY8hmuT1Px3J
         uYkFNDHeEknvP4GpYpaX8LIZKziAAZJUCxEkaKOSvJ7cDe4KPeXfAeLGDIVcBfH07145
         zyQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzBnAgYzou9z2rk4/q6OKFnvoVLeX7Wr8pRIO7nQAC16qqhFmVh7OqG+FaXspPu5zRs7ndDS+iPQ==@kvack.org
X-Gm-Message-State: AOJu0YwY1lOFDqR9s5PFVjTaePt2Twn9DpgCwHs9rseYP2k3imkzfZwq
	XrozgSeZMEl5BG1o43O+AWh8RWr4ks+ERNYeU4VG/uAXbJXbpdWMfL1n
X-Gm-Gg: AY/fxX4Z0PBg4ibpyvmZcjTwjC4n2R8LIdJ79GIWZ5QnAuXWPoxjFgKxDwJfZyq2013
	XBRJJM8FBq8jNYyzb76CxzEg3jOBCWzwxkvRJz8VSnSeENd4yJabtlt7PFtMBRZyAR7roRk+Yon
	JKlNfIUrGi3ngK1/mRWvlbkqYCBSSKQG3F3/fQX6bGS222jhCMhuis4ceT4tCsDjUwHyXGK6y6U
	vzoLxdQE3AXJfrnXqOWMzKOEuodvDbh1aHkbg30iWNuY1v4OK2CJpXu8UrL5orPnAuSNQDgJE2J
	Ak/p/DzLmoWQblpBqrDQcWntZF9P6ILSt4kCjmJmotq9xw2DaCtGDOXv0gSL++qp0ayX1Y9B2QQ
	UwajLKL5W6sJssSLfdRdjJJp24gOP09Po5zdKTxALgcU0QPNuuGFhgvRw+t0BftZXCvLZfWe6Hn
	y/
X-Google-Smtp-Source: AGHT+IGB4UrTflumz8SI6ZENz32BgmOH5OCs08clFgtHXisIQW4hW+a27ip0KXG3pCc9DsjGk0gsGw==
X-Received: by 2002:a05:6870:7085:b0:3f5:4172:16 with SMTP id 586e51a60fabf-3ffc0c77c57mr3522771fac.59.1767895396170;
        Thu, 08 Jan 2026 10:03:16 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:3::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4e38b60sm5224549fac.6.2026.01.08.10.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 10:03:15 -0800 (PST)
Date: Thu, 8 Jan 2026 10:03:14 -0800
From: Breno Leitao <leitao@debian.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, graf@amazon.com, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	pratyush@kernel.org, ricardo.neri-calderon@linux.intel.com, kernel-team@meta.com
Subject: Re: [PATCH v4] kho: validate preserved memory map during population
Message-ID: <jixxiqeajngwox3nh2u3pwf2rivhmqxxmpyttqxu32pixshyde@4jdn5jvg5hvk>
References: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9BF7C180005
X-Stat-Signature: 5mkudhgmjanzc6x35caz6as5qczz3s8w
X-HE-Tag: 1767895397-348864
X-HE-Meta: U2FsdGVkX19JwKmr//hPdfV+i3Gh5JvUfcxk+feU5vvHDxrIGxgmH0vIVOtd/wBg6fxxWfStLATgKbpzOSUmhcQF0BAkoccFOh4+w2EuJRkdQWHtFaI5t622nvsfvrcqRerjSIuxicpppMKG6ALbBo1fgc6qnADnVOlhwuMETnRZ8rfOLqnoPxH0/xZrPlpAfSRePu4K91hOmAvC7oGDBa0P7LIvTVyzRYm2Rvd1Ql5BtDfEENVtwYghzJb2SNIEpk9iUDei19AxDgxhJpbrxisoz4k0C81Tg34reGsYbTeWuD/2T5Jaki73OCLtnuk5rTb9tVRCGKT1XhpRsPX0XczZyFxpVmM7e0X6TTscdFPjYmvxJTleFbJ1OdqUpQtt5SFLg6+8ifY4wpuyWMpq/1L0HLuEKbnhSBEikUAheZvMSk0s+r8EnS0YtZNGNLfBitfItA0uuwxu9A0eEyLEoaWaSzCN18VlEaBDxlMIu6CYnFUJ8kf7poTvhFpJYA/z/fNveHcjrew4ZXZFL8EtEcL+MVvCPl2J7YxaTmJpnTwC7zwgveOba6993FGBSLCeu3f+WFwlyajZVeefPgjw4G5xfWtjRDbWjf1aLWg07kf+ZdPYU1kdVloGB4hVG/z8RXhdxSmaiiMYqqE020gCeaU4f/aECdN8Gp+k11Trf9M0eCmtXdDBXAxzAM3el671lsR/lm3bGOaLIORlW57C/Pwkpt+XR+J17PpT/eM5f7cW0sUF4gr2olpY4BFGYYUAEnsRIyNo91kVjh8TfS2qJa+jqPshS6egSBvoRIcHcjAhlacRq+xf9/1HRVCT0fYioBm5FieQQZqLx9zTywk6OjI/geavo/TkR//rA+tI6JSDtyEmD7GswCdZKBmPuiRCvyvKnn+A35LbKqRJdJJ85i9FGMXWFuPU9Fh4dCk6EXJpUntZD/0Mrr2gEZp/yGxDvp1nzTYc1HnhPU5xh1Q
 U8pOpWwZ
 BDBfkAAxhVviRSDyBPO5GmOFeMPRGJHydGRTUsQwuwVHp74cPX6dGO+cReU73Bcmh0ql174WJO+0zs85rItmkDd0BVPnoMgfNoWQxfQFZtCaTB1MecX4okBbPhMA1wqggqJqAzJm5BROv/UkEvbl6dpQc7PAvzKTud91t6cc2c/u0FvGR2CbZqOkv+JQG5au3gp7vjTHpKYGCBhFTlWXVOa2E60hfRQODtUMLVcJOxfeg9bI6Zsx2ewsuEEC3vtakmNGUKjuTpkETvTt8rrKDJ81ot1jIpXCRfOc2n0zTIrEWg+gX388j8/uMJFvJ+1qKzI9NHnOnAzze/kn753Hr/jYEcZygIO7ISCdxnewiDCbc5UYLK635YTveNgLFG2BXaJN94mAgUYhjSG+IUS7z6MLazSp8wTjeboMJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pasha,

On Tue, Dec 23, 2025 at 09:01:40AM -0500, Pasha Tatashin wrote:
> If the previous kernel enabled KHO but did not call kho_finalize()
> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
> the 'preserved-memory-map' property in the FDT remains empty/zero.
> 
> Previously, kho_populate() would succeed regardless of the memory map's
> state, reserving the incoming scratch regions in memblock. However,
> kho_memory_init() would later fail to deserialize the empty map. By that
> time, the scratch regions were already registered, leading to partial
> initialization and subsequent list corruption (freeing scratch area
> twice) during kho_init().

While trying my new patchset [0] on top of this patch, I got the
following issue:

	[    0.000000] KHO: disabling KHO revival: -2

Trying to solve it, I come up with a change in kho_get_mem_map_phys() to
distinguish no memory and error, see the patch attached later.

This is what I used to test [0] on top of linux-next. Is this useful?

Link: https://lore.kernel.org/all/20260108-kho-v3-1-b1d6b7a89342@debian.org/ [0]

thanks
--breno

commit 5d7855fede8110d74942e1b67056ba589a1cb54a
Author: Breno Leitao <leitao@debian.org>
Date:   Thu Jan 8 07:44:08 2026 -0800

    kho: allow KHO to work when no memory is preserved
    
    Fix KHO initialization failing when no memory pages were preserved by
    the previous kernel.
    
    Commit eda79a683a0a ("kho: validate preserved memory map during
    population") introduced kho_get_mem_map_phys() which returns the physical
    address of the preserved memory map directly as its return value. The
    caller then validates it with:
    
        mem_map_phys = kho_get_mem_map_phys(fdt);
        if (!mem_map_phys) {
            err = -ENOENT;
            goto out;
        }
    
    This creates an ambiguity: physical address 0 is used both as an error
    indicator (property missing/malformed) and as a valid value (property
    exists with value 0, meaning no memory was preserved).
    
    "No memory preserved" is a legitimate state. KHO provides features beyond
    memory page preservation, such as previous kernel version tracking and
    kexec count tracking. When the previous kernel enables KHO but doesn't
    preserve any memory pages, it sets 'preserved-memory-map' to 0. This is
    semantically different from "KHO not initialized" - it means "KHO is
    active, there's just nothing in the memory map."
    
    Before eda79a683a0a, the code handled this gracefully in
    kho_mem_deserialize():
    
        chunk = mem ? phys_to_virt(mem) : NULL;
        if (!chunk)
            return false;  // No pages, but KHO could still work
    
    After eda79a683a0a, the early validation conflated "no property" with
    "property value is 0", causing KHO to be completely disabled in both
    cases.
    
    Fix this by changing kho_get_mem_map_phys() to return an error code and
    pass the physical address via pointer. This allows distinguishing between:
     - Property missing/malformed: return -ENOENT (KHO fails)
     - Property exists with value 0: return 0 (KHO succeeds, no memory to
       restore)
    
    Fixes: eda79a683a0a ("kho: validate preserved memory map during population")
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 271d90198a08..3cf2dc6840c9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -471,8 +471,8 @@ static void __init deserialize_bitmap(unsigned int order,
 	}
 }
 
-/* Returns physical address of the preserved memory map from FDT */
-static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
+/* Returns 0 on success and stores physical address in *phys_out */
+static int __init kho_get_mem_map_phys(const void *fdt, phys_addr_t *phys_out)
 {
 	const void *mem_ptr;
 	int len;
@@ -480,10 +480,11 @@ static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
 	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return 0;
+		return -ENOENT;
 	}
 
-	return get_unaligned((const u64 *)mem_ptr);
+	*phys_out = get_unaligned((const u64 *)mem_ptr);
+	return 0;
 }
 
 static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
@@ -1439,7 +1440,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
 	struct kho_scratch *scratch = NULL;
-	phys_addr_t mem_map_phys;
+	phys_addr_t mem_map_phys = 0;
 	void *fdt = NULL;
 	int err = 0;
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
@@ -1466,11 +1467,9 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto out;
 	}
 
-	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys) {
-		err = -ENOENT;
+	err = kho_get_mem_map_phys(fdt, &mem_map_phys);
+	if (err)
 		goto out;
-	}
 
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {






