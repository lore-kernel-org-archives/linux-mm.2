Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A530C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B4CB6B00A6; Mon,  6 Jul 2026 12:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68D3C6B00AA; Mon,  6 Jul 2026 12:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4EF6B00AC; Mon,  6 Jul 2026 12:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 360306B00A6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:39:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B70E71C6E34
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:39:19 +0000 (UTC)
X-FDA: 84958912038.13.5A8F318
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 081F1A000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:39:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mjr3zhQP;
	spf=pass (imf15.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783355958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ln2AHNDCstBaUrT3DCw2JhDQU5MIDiC1ybsTRxhjJ6s=;
	b=ODpX/1a2a5WFyrLRS5vPr0p4/Io9qg+j+XOwBzkeFm4v5+reSMgigpWGxR9pzp/YJAC1nL
	cxkvCOI8emijf7yUroK/JakBjR9bIcTKFzXLkmIzLGx1vShXnaPB+Az4huHgbRH9lKZ1/L
	4VawJZ08BOrOcv35QQ9kzRHvfB4uZwA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mjr3zhQP;
	spf=pass (imf15.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783355958;
	b=QVw4FIDjOp0PXBEE9g1hjczP0q2sgqH6XRb1isQq/HsOqOjzShUoP5GieRV2wTqzjWOkJq
	Iefhc/x9mpTt2WLVd0t8LoiHwHh1A6R2w7OZeHPlFKblpr53dKK3jix3bM2l4rsc8CnnD7
	jXinAp9qOBsrqBEZkcsRhSZ6Kx6fKjw=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c7cfa17fedso36554935ad.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 09:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783355957; x=1783960757; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ln2AHNDCstBaUrT3DCw2JhDQU5MIDiC1ybsTRxhjJ6s=;
        b=Mjr3zhQPaIpJgIwcqP8ulzvgHM560ILAve7cihnOhcDxdFPmwQtxP8FUAJoeYWTxrx
         qjDAUSKPjaLD1xXeXuFpMeZfoKZvOqZSdkzT8nXOaRfgGdH4WZRNxmC64xUZmsdwEz3U
         zyl5biQJIINh8MUUA76GGvnx8mUVi2hK1covsK9JYMiQhg5rmjuoPjxYXsf3Y1wS/B0U
         W4y71he1iVjKbZMqTPEbyRRGWv2E1Yobn+K80EcfjQwWSmUtnDO7mBvG3WyV2Bp7Lgb9
         CBmddbL92eaHAgU7ucyGLFerX3r7K0451+GyKg1n9h11sn2U/q0frrmZp3MEHHCEepR9
         EOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355957; x=1783960757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ln2AHNDCstBaUrT3DCw2JhDQU5MIDiC1ybsTRxhjJ6s=;
        b=JzTnchWaB/dnVWnMgIXTCMlPB9GUJLMbNU7o29pzN9OL2A9rG7O3n7ZhLUUfCeQtFE
         WQe4bxZyDyn25yLbBoFmvVL0Rc/Uj4D0+fX5P3d5+YngmhV5RqNIPe9RoITMz+ZvU0/y
         D276io+ognleWLnZsqrJnY9Fli0kWECgPtIUhMTv82W6N2CMCHTKFfrDhJtbbQDL5Rhv
         JRgf5/5LmZNcCkzi/+lnklGivOUTA4ZnHcPFrKDWsf9uvoKCjOECTN/SUzpt2FDgMOpv
         SkqNWkvNhHs1oh+wjRpmSgrr6S2HLVZkDOPq80RMiaaesfzLqB0wiN2Bt2uxU69ugu/q
         cQrQ==
X-Gm-Message-State: AOJu0YyvJ1+/KhZH18P4P+UZqfvynaeOgTNeZ8HY4xaOXYdPei2f3Nia
	roYoA/BH1KFQX3yQIaGEI6xtK4kY7QIMEXYG4cnvADYfId1lz8c2YueP
X-Gm-Gg: AfdE7cnJam6mjjbmwvD2gkpkO0aR4K/MArBDHelIqIC9UuNlwwnadhaii2u9QGDpNqp
	fxbAMsmZI2ONz6XGj5gCROqDzfxE7S2T8GiaUbnucQW1x4Xi5aDNPEChYywZ/4LB6NlkgsbzO21
	geYssKA07PUnD7lvepkYUDidG4wHecvkkrXXMlt3u1/W0SCbO1BcejoY4N3sIjiHU+r/PO3HDPH
	b1y5WYYU0DuH3b+jTiOBVrB33ZRjSxdCPYE5+f69hzipWDKVFo3C/cylbJAXOegbDze7L/mknyU
	sz65iQPoo/Ty6ntSC8NYGZwPUoAjrCc2XmGn/fEtANZqHxJtJu7Bn5r2jqdygpTad7eANPsBDen
	CFodOwyHcnlzSOcQzJJnDRwECzOsuswC/dZofauFFymwVYNQl5pc1y2BebK5qd4K5dGRUKs6qS2
	lWmCols8I=
X-Received: by 2002:a17:902:ec88:b0:2ca:c84b:c4a4 with SMTP id d9443c01a7336-2ccbee245d5mr14321395ad.28.1783355956959;
        Mon, 06 Jul 2026 09:39:16 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7893a8dsm53103305ad.73.2026.07.06.09.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:39:16 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Borislav Petkov <bp@alien8.de>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v2 5/5] Revert "tpm: do not ignore memblock_reserve return value"
Date: Tue,  7 Jul 2026 01:37:53 +0900
Message-ID: <20260706163753.193875-6-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706163753.193875-1-ekffu200098@gmail.com>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oq9juxp6884rcf6uzd6oi1wcxtgcssoa
X-Rspamd-Queue-Id: 081F1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783355957-181914
X-HE-Meta: U2FsdGVkX1/LiD+IW+CNJdlFBf9/78WHMwwZppura/gM8P6IzzFqz4SXNE6sEFnVJAqJkkx1tI4nhEbMvWMCdhiuK9dP30H+g58pgJ0gbzlsywIQQkTOf6xAswP+QJFqdzMBJtIjc8FU4CPJAGaW3uVWEt5Bc+nL4eO3zo3XnPOkLkE7vRLlRnHKXmHEwx2OEgZJ16g+/E2bA5v9/JN8xm7VjhrrWL3z3xSU9Mzr9AGZ+shrDMryEkI8nMwEzPsCp76ROIiczxCuadEbNbf5+EOrbps1FCJGkvnH1khOqleRrsAin1bdLzCUbSZcVx35jM9q/L1ymdcQSbPOHM7dFUk51iZfudpX4RxdqdMFSWtKw9+AuN8/i6EQ+aXmE3MWnztYk/WcCUsF517Y59vNCIjCDNHjRFJuDEyGZ3ds2oentQ7pqGGNPYrAHMOiPvG+ypnEF9cIHwceWR9t2bZr7FPgH9BrR4SF3ljtzvmKmbLp8wrEk9a0zNzoSDy32L504LzcOKsWNTXkbNv0258WkgJ5//OgnbQwU++y1Cbwe/LmjWA8kYija2DerqeEC9sAPGkS8x8G99xt5yflBGzdJ2WwsX/QnpzCvLNMz+MFQMFDuXk8ll8lpXlvqq+r7lfvJ9FJ9+hT/ORh5ScwUCBS2GHutsRv4/2BdDP9EX3dgFvV0SlkOiyBE+aM2n5oqCWMKYGEID6Ycy/Zcurs3z+p80tIulpakvd7mQf/wzf3CpOTuk2hybseNdiPclMuad2Fmm7YrPNNmNfk7Pv2thXSLTfUsNT5Z1VTWHmfINiLy9YpKRSASRX4a51BKVY6qvwIEellxNFyEA2Yqf9nDYxk9qP5NMWCBVjcpF9v5aqh+3VbyfEydKbE37HJ0UJ9SseuVw+iYAVlBj7ymSyT3iajoiBHI5K2OhiCqldsXMvjxc+yOYedOw0Q1PE95thaQS5U3mYjiz069iFOvfWFsSb
 VzgVId+g
 UjscTVYo5ba5QtJYHMIX8tuUND2gmZoQEqLCjri1FN2PHLlBCD7CyZ75KGj6WZDWd8+pa+q8HF+iKBZtTiyhbReJbTrweivlPT1VsI5GSxDTpKZC5CNBTg8Jqxqs2Se1hRx1XIyF6D0hlFkdDTeXGuFyDNPFHTLJ2ajtk7yaWtD5wutEBeAEqenH+xWbk2QmZy5Ui8cDKce8BJ+4zlrCHMmrmEDcy+M3bjHb5/DVA4rozAgWxPtHncRjFdVCbkjwahQtr6eiYMzQMJDcmb5cjUsm0lMVNGFSh9WJD1m2AjLQ/Or/svbqP+jlv3B86+PHbSBNIYvRK2WO5p6+wbv1fxZJWaAmIc3N+7W2RXg5bQZCi851H1XQVy4mVhqMDCYJaMC7ITH681ryVzohp5uHT0rz0+POfW6GHUmGrgUjG64kwyr6utIfglfTUOby5UXFYDRp/WZJeUQxduLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit c33c28f9f6e017702374e1ab907dfa5a63db5301.

efi_tpm_eventlog_init() runs from efi_config_parse_tables() during early
EFI initialization, before memblock_allow_resize(). At that point
memblock_reserve() either succeeds or panics, never returning an error.

Therefore the return value check is unreachable, so restore the original
unconditional memblock_reserve().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/firmware/efi/tpm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index cdd431027065..288bcf7a5b99 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -61,12 +61,7 @@ int __init efi_tpm_eventlog_init(void)
 	}
 
 	tbl_size = sizeof(*log_tbl) + log_tbl->size;
-	if (memblock_reserve(efi.tpm_log, tbl_size)) {
-		pr_err("TPM Event Log memblock reserve fails (0x%lx, 0x%x)\n",
-		       efi.tpm_log, tbl_size);
-		ret = -ENOMEM;
-		goto out;
-	}
+	memblock_reserve(efi.tpm_log, tbl_size);
 
 	if (efi.tpm_final_log == EFI_INVALID_TABLE_ADDR) {
 		pr_info("TPM Final Events table not present\n");
-- 
2.43.0


