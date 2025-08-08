Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D79FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 20:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944A16B009A; Fri,  8 Aug 2025 16:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6B96B009B; Fri,  8 Aug 2025 16:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F3C6B009C; Fri,  8 Aug 2025 16:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 581926B009A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:18:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19DDF1A04A0
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:14 +0000 (UTC)
X-FDA: 83754702108.22.3169B43
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 57C6340003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hZvnlGui;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754684292; a=rsa-sha256;
	cv=none;
	b=lNRo34vqtOR/vk+KPhi9d36quzJ/3alOQE1yMX0cZgETdvbSdpJtkOC77HsGf06moP7ScR
	z3TbDwW6vnPtM5F0jc/UjgAqzHvs/37MxjjSz/ITonrPbXSXFtrSEWK2xxQw8X/zVc0Dcf
	/XgSwfxHe5sLm6nVm9/f00JSehZEwy8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hZvnlGui;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754684292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yc1Ft/b3qye0Nn2AQUyZWguJ2koiO3eAJtJCginIFUo=;
	b=hQ3PO8Rp/TqyvzJPtmjMSrBA9ZPWMIJ6b6b/vJgY8l0QaFLgdJ51JAwD81sMHewhtoESoQ
	NlpVBAJS12VfATBZzq0nJpNYXxDC9xTBIaLlHWOSiw8CNgQQ7v5R7lC37W6EabSQQUnipA
	jPWBR3RFbAVcEpcsr5UgRFQgQetgmMA=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b062b6d51aso29203871cf.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 13:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754684291; x=1755289091; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yc1Ft/b3qye0Nn2AQUyZWguJ2koiO3eAJtJCginIFUo=;
        b=hZvnlGuiGTOKsyTdGp3QuW+J3mHAP5xknq3mdQMbbHVPA+VeZW2HT8/2IGz2PNZH1O
         xEB0rk1OV8FGgiZGhAiYWSdImbhPVQhcCw0ahmhrlp/sxge2S4uz/C8AqOQRkEFnKI7i
         oJFj4Jhh+P3kv0MTdQSKNwkosMIFufYtoUtJY0b20ySYCulEaI066KTPuC8cCANPQw6V
         llZKWzx0iPPMmVmAI6cs6eNM04HCWkb00K5s4x5Vc2vQ4HHM0u7oQcEvnGRTawv1izEP
         nsWyk1D/LmzAIxoJpwbaV3ivreKA6tCS2mWD2R1556KU0svLtb3+NCed/ToRAj9BTEn1
         ML6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754684291; x=1755289091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yc1Ft/b3qye0Nn2AQUyZWguJ2koiO3eAJtJCginIFUo=;
        b=MB/0jFedORLWgEMUga6/fNZ4e2H/D3rFmDIuQIVDgLTl+a65jT/EOOXslXwViGXJzU
         3f1ksgP6etrONjwc6gL9f2OlMPJN08c71fJrBqIcb+iKL6TWgcYRmelz2w3oFCDj5FsS
         ytrveTm4Z11+FTve8aanmMEQT7f/ObvNLdAVywX2DTiDMkrvDbB/3r3XvYvlNOZ+Ukyp
         5YXBrAqddZoXw8we+u2FUorew4OdI20XKXRoQBN2FBVnavyRf9/VGD8hrfs8cURPinIO
         Mp+nJjYfO4Vc1ibkdSncFfllRuO1s9C44U/KRKQ8hxy9q0bvPC1j+fnRp8+fnX/68AhU
         pkEA==
X-Forwarded-Encrypted: i=1; AJvYcCV59SWBzhqb8Dob80t+J2pyjqHfhPXADcavmdtrvFFFYf2g5r6r1xTRO2lWRg77x0NtMOrzxFdX3Q==@kvack.org
X-Gm-Message-State: AOJu0YypI8cQ5KeyUOvLmD8hrC9Ka0N5MfvQRG70qlEF63Y6voSZtr8b
	q43QjqfmO4yPL8HKr8Mksz47Xp4QICDXb5jd/EnmsulpflZuG5vpll3q++2kqjw7GlM=
X-Gm-Gg: ASbGncsSDVb5QpY2D7u7uFbnUTlr4PvAyPQqa8+mfs34WSWxn+j1MsD03c1GlsFZV9d
	I84kS+KjrtmFigtRpsNfKxMHW4DGASDEZ1zVZoP4EOEjfbgT/qp3mfZKypzwBgoil9W1krcyP6M
	zErOlAd+dO0QnAp0V9/s18uqjyoGdVe4FgZ3yF2XOMCA428Dte8knH+snI9lUcPFMOIejNWiiJT
	bBjen1pRGYwG9qL83YggQca2Z00Xqq7LMncuJ+HN6ATMMdo/6eKbW0oaQWw5avTna4/ZGts5Tyv
	/VJeUoxtQdtUEVpCMOf07PU67JVDbVYvDXIqSJ7ume0tUNw1ccgrNNMkD/1tWwyRItNe5nHq3XS
	gNPBtsKvF3y3hbODXeU0I5unPXCrOt8y0tLyF/5bdThH1kFKIODfXLUgzDioVxa+lKke+z+MDB2
	6tEP1+d1saTjPiurQHhqUK9Do=
X-Google-Smtp-Source: AGHT+IEe17+1VnFzVVxjjjvnJD4w9EO7qMdCyqSXThf7XuoxHsa6VF4qQAx4towsxC8CogahdlN4Jw==
X-Received: by 2002:ac8:58c5:0:b0:4b0:8773:9b0f with SMTP id d75a77b69052e-4b0aed0f079mr63563811cf.10.1754684291399;
        Fri, 08 Aug 2025 13:18:11 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b07c80ddbbsm59490131cf.57.2025.08.08.13.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 13:18:10 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] kho: warn if KHO is disabled due to an error
Date: Fri,  8 Aug 2025 20:18:04 +0000
Message-ID: <20250808201804.772010-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
In-Reply-To: <20250808201804.772010-1-pasha.tatashin@soleen.com>
References: <20250808201804.772010-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gr1khozdtm1np9odmhcmkhbxcmgho8j5
X-Rspam-User: 
X-Rspamd-Queue-Id: 57C6340003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754684292-752040
X-HE-Meta: U2FsdGVkX1+q96QwQs3/oeSZ01b4vBS+4XldnlO6mFSKehvTeMqecPUdIBTAKRUcMpcpgdRLVBi8pBO+dqsqLrqoRNVHmLuoX0ufWjqGhO8zTdQ5CX3e1ul0KuMK+PfJrU/7sz5+ThWRx9ggi2Rb/HrkEagu9re7IKIk2fbUajCXG86pMO69uzPp3MI+7O0srwVLD6HBr5TcMGE7TER6Ir4gWijCm9DcF1vY54KWMXHi7C9ucJqQjg3rvpz6qSvVw/cOQPFruArRch9H5gtbRjzlrS3ZrQBUcynIV6XLxQuY31CkF53YSAN3LARd1ioTq0NGWT8pWmQJ0SZ4BUzf7eJ+aULllMMe7ldLA+uqvSrQJL5DWuD3+Un4yi8tX7H4NbwquSZdAUM6tMuO6KsLKREVYch1imyomHt+Q+vos7mbTz35cCdYLu7LvwP5c/Ec87kMwOIz97Eye5p1KqjT0/E3hIo2s31ABQ0NtfcF1xdlImLRMV2V7nqGMxkAw13/1eUuiz6WXBTN3hRUjtPUC/2IRbr52i1FqWN/zJFZL/ZQR+IqSnZnIikvBtNuOfqrDw0fLWdKJU6vikdJa/xklV5dMSmMAfDaUg8bqS3atwy0+rNviGvAgT6TVSx/l/pUo04WXAlb5ckZPtp5GvVVAFtMzlGWVmva4q5CaomECyIHyUOgmRJealIzLI/l6ZbLAse2ZLyDO1ZBXcLN9mPEwKxa6ZIo5XRU9TSihF+UtGyGboYSnJ5gYA3qyaB0UKdu+gJdGrWLjllQ4V4hxz1Ft53QeCSKMPt4Xrlbs9PGmXXJEAI3dSdzvlsgmpdSbCJbKY5+hDYw21tHtF1XUWx/129SFrbLS7Inv3yK627LeHGcMc90z4xbVPiB8yDsxpfRMRhyQ1cdOtb+2T0BHzFvhDmaRZURFuyYKPMZaOFpZBeG4LImMRCWyLsXAArTdK2MIzVd5hS2R/KznEjhVJb
 9h7YnwVX
 NJykxXkbkq+FBpXWuOwPnBCKYBz21i2T5pdXKrYY+4mGwrz/Wf8Cwhn39ngAzSTy251Qx4807pQq6APb8R40vgC8pmLwHvxDeupiNcBlTiL8Q3wZTG4+7G/2Qr61tYTN5AEYvBmvponNTxjTybEqgliLC7x833ikP3q6SRdr8AhPDyHWh15255rGD5Aw9ua92fjbo2LlkeohZUlCATk5DkkkD95Jfth7ijnY30b1YoRMlRtUu1rjy1m9g1GmWVdbBtjQ7spxiWFtGyaakKQnUOERw2MFofNo5CtH9pqQTBjVqjIPz3KeTaF0xdvTCckPQU6DNP/RFluxYDqT88iwvieBaWyxiT1r/Zmp/a5pGxFc7KX8m5v3eEYKK7rJNjS2rBp8G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During boot scratch area is allocated based on command line
parameters or auto calculated. However, scratch area may fail
to allocate, and in that case KHO is disabled. Currently,
no warning is printed that KHO is disabled, which makes it
confusing for the end user to figure out why KHO is not
available. Add the missing warning message.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/kexec_handover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 65145972d6d6..ecd1ac210dbd 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -564,6 +564,7 @@ static void __init kho_reserve_scratch(void)
 err_free_scratch_desc:
 	memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch));
 err_disable_kho:
+	pr_warn("Failed to reserve scratch area, disabling kexec handover\n");
 	kho_enable = false;
 }
 
-- 
2.50.1.703.g449372360f-goog


