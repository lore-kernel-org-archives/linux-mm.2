Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3DAC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CAC8E0005; Thu, 31 Jul 2025 20:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916D48E0001; Thu, 31 Jul 2025 20:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804C48E0005; Thu, 31 Jul 2025 20:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAF98E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:27:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D1B7114E44
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:54 +0000 (UTC)
X-FDA: 83726300868.12.D9DE648
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 64F3B8000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:27:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iDValKOK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754008072; a=rsa-sha256;
	cv=none;
	b=f+7vtqkxYRG5HJxhsLb1o9TQKGdpkx9aOb9SGvUHjYdamltjncJ5nUUy/SCHBqXizn8yJj
	SFlmMtO4i1TQJIo6E6WwMBO0Iup2KWqezCXjn1ackHXYlfUcPiWi0vq6pxeai+8P60kDmm
	mF6dooeYj2tvU2TsXsvCVk9eaVIaP+4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iDValKOK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754008072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7z5+HbZuc9YunuPIlspdA93dn5EvXoJwr6yRZmAwcU=;
	b=qNK0yOpUuX8lrYfLcUM7yjzwlfprg8dpWA9TttrcnppooXvx64Bty8uoFzmUDkr4c3bXyD
	U2cf5W2eVWSklE6D8kBiJq976uy85Yr7fxl5on8EF1boHLMBrYRC5Hvn321LLK+zv2139/
	FsSBZzTuUnOvJjSKNC+twgYtug+M3EE=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2400f746440so8756185ad.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754008071; x=1754612871; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7z5+HbZuc9YunuPIlspdA93dn5EvXoJwr6yRZmAwcU=;
        b=iDValKOKvgK1UowVVdjsfjC9Fe11e7tyrtmOvgXcoFtWSU+krUyixXeSoijCNj40N/
         iw19bo7eGdI3YMsyWM1MgqulOEXreva0f7yPda0yusof1w3EL9rpTTgGmkkhRLyhuym5
         l8lsybyoWbAu4Osy1BDKzfJBKur6bMGqc7Qd1KX20vsNA7vNSS5AmBRE+fnKXCBbWT/t
         meCIPwUsak03uMGgItC4hauXJ6bdUroYn33rMNzQr0GW3wKzZ3/fICUKlGOZTaqGR2Kh
         G5r3emiyA1DPpI26tBbedPnrznKq3fII5x4747ADigjrdbxT6C6ZYNfgtVsK8ViZGjF8
         48tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754008071; x=1754612871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7z5+HbZuc9YunuPIlspdA93dn5EvXoJwr6yRZmAwcU=;
        b=Kf+eA7pIspgkt73x2rw1i5RAM3e1JHtqk9FWVtos2VoDp0nRugBWDFtuVOs/sP/6ZG
         nkqbhOusRX6bMtQ1y5WDOJp+/RALi8Bqm0IcZDgHTYJVM0CqE0ams/sNVJgWdGbk7SUe
         5Gm3x7qwaihD8U1536O71w3FbvHGfdzEfAuS5focx5AMuTIATkC/Y8Er6cRGzLxArruj
         M7y2uaFXXddwUr7fpCk9FbwxdrfNGinTR3EzXZi6FIP4wMQigoB+Z46NZAFcU+HgQAn9
         NBLjSEi83bguvaYyu4kmipcHDWZKoAhjyD1/adT2xhLeTH8UE/RNMG9AYYRax105y4Ki
         w51w==
X-Gm-Message-State: AOJu0Yw3Iqg7RO8dEkYYvManQvFEuivCua7zpMV+CyPyQRYnHQixo04L
	/6f6dh7FTSD02Y5gEJGmobWMnjXvdUWEFITUFvHCOAaJJR5LBQ3vxaYp5MrB2g==
X-Gm-Gg: ASbGncu4Ib+SrF5xYLLXboA5m6UuC9XlB9mI3maEVJy54q/GTndLyeJXJN1V8I1F2lX
	oOssEAMIGHiKAouNTRTnzEdRKH4KOWVgWNE85qamwtrJPCZ6w1/ax0Cc1I+L7ZIpTbuLSTQr0Mz
	mIaC30iEjkP3NcLkXBtknZBP/F7qVZBsryeBthDE/2UxS4jFMZpL5nRO+S99v1qb0zzSzSuBi4s
	QEcg03d1haeA5q8VNYAY7NdYCJ092jm6sK5hZWf36viwdSe5TELP2bSB/wfRfLQ/EY9qW7h5JY8
	VwmaevjgI+i+smtM9tJwtwKVv5+sXyAdzw/7xKEuPYetKcHH+tD8oitxCGKUBTI/R8vq6AdrZ9Z
	Jwwpa6/SHvLa9GoSZow==
X-Google-Smtp-Source: AGHT+IFYmTAjVpt+7oBGfT3RIHk8CfJXE6Zr0DBlD9CkoTtvscoJm5dVQ4NSb12WkhTU0A/RSTNmRw==
X-Received: by 2002:a17:902:ce92:b0:234:df51:d16c with SMTP id d9443c01a7336-2422a6bc4f8mr9251225ad.45.1754008071081;
        Thu, 31 Jul 2025 17:27:51 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6bcfsm28587855ad.5.2025.07.31.17.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 17:27:50 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH v1 07/10] mm: add no_stats_accounting bitfield to wbc
Date: Thu, 31 Jul 2025 17:21:28 -0700
Message-ID: <20250801002131.255068-8-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250801002131.255068-1-joannelkoong@gmail.com>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64F3B8000A
X-Stat-Signature: xuw5oqs6f7qy94u56ogm8a8zip7689rp
X-HE-Tag: 1754008072-892744
X-HE-Meta: U2FsdGVkX1+ZkER7GXvswyfZ89VoPOk6m3GFPxlqI+WChmr70aPcHyjmfaJcU8MbyhaHNdO5VJIBj9vAIi43EZGL4EKAhDuwn8TsORM81srskjqDaOCkOTpUwGs/fc18QPOJpHoRpNk7H5oMA/+w9VCwcMTWIIVfVq7oE9ix6C0Jc0owijUfQnTQxMrboDRagzeVXUuWAwIt5U9LjnKRpe9yQw/y25ABYRPvGEqESjqgnExfkr6PoDYxd53wIZGu0nVv3Zi5MhS6r/lorXb73F0oZecdoufrcsPzMIFa2O417Mge/PJZHPHuaLoY66smNflzSbjeEE2De80wtK9gLNHenTq1Xi5XHLvDUMf4dGbA2PM8gwFLOsCgcJjcZpK0NtCgPzw2daeRWJ6ari+BoFMSCttjNMnH1ceZ7QXAWF8OmM7sP45LtPrx0b8kM4cpZLOITrbVLK8eVfrrhGXIozj4yTeieQp7ZILycI2oip4X3OuSFs91J9Ww/XhXcGcdYVat08/m0dnxqQVUbTM5OAsicPdtzAaOnw9MMXi1e6MTxhT4TGEP/NHR1+nq9Qsoq7dJRtu2RdNAazqFA6VvfXIKCBhprxEO7EK6o7O6IW7mpOhk1Rghf52jpTVuBSL07hMAOVL7pGy/CJjlyHN1aXiLRjGl/6Q5f4yRIQqcF+VvcLAOLC73iXe4x3jC/uBztGKEsgf9aeUYNyMqnQvpu4tfQ+LN2+2oRK87K7CVGHppOAQn/hX/JZit0bcHVVQYYFJFjoziQ/wTi81XX7gWqwkaEPjr63wfN8gCAahhdxWUU088L1x06S6tA1AoUe6RslaDk3TIZZTqePKASDVfIJS6vHZY/mwmTcfblcgRAH4R5b0anNcmJVJQtJWDUXOPbbNA4bo7J9Z2vnYi2J2N31FSOLZ/cp96NooL3U841sycYCx4lRFNu8bpss9mpsEjEGeLjNYJpUNYxbmtfpj
 hxoBLUqt
 K0xVPEL18rRn3Y7On1RJnBYHK8QC3ck44UmoEAgaWhjLP9E6pv6TcpoPxzbdh3/1jnBYcqkxeZgmGj7gphPRr1vbbnGvw3llr1GvijURZHxeIsxwYqww1Qb2GlCVvEDf/ZsVV7L8scIbt95Jlu7voeSjEXF4rLhKZmLTXB+VLTw1DKiXx5A6ctMOuR+DA6Dz7HTSZev3asCJ3GpdG3Ogsi/HEblorNh1mkdbwQOD+C+hlxOaVaYKxaeHAiSx2FJqQ7mbw7YK6Qj6vdyFZlFb5Inqm9TA/t/054H+tU1Qog2+9nl/EltjMfUUi17VDGHtxFozxVTL3sS2TSjWK13h8nfd+/AEULW6jOH2C4eiGQifqS8Zkd7fuE5VnnOyRDSSuCMeKYMt8JRK+1EiY9eOeq5G7/0QyQiX72uZMEEup4y0XccDcWYTgVXSG+BBIq05Zf/w6Fk0QM+xLG9rfY4MmBCWXc/UfN1XOTKF0V7qIoUnyI62y4oVerOVVXPEwLHUVD63q3y8pdVzwRASD6rq44CqbIjM4pKE4FSJ+YyH6ZEGQcFmhvoIMJA18aWC+Vyv1UMZO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a no_stats_accounting bitfield to wbc that callers can set. Hook
this up to __folio_clear_dirty_for_io() when preparing writeback.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/writeback.h | 3 +++
 mm/page-writeback.c       | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 34afa6912a1c..000795a47cb3 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -72,6 +72,9 @@ struct writeback_control {
 	 */
 	unsigned no_cgroup_owner:1;
 
+	/* Do not do any stats accounting. The caller will do this themselves */
+	unsigned no_stats_accounting:1;
+
 	/* To enable batching of swap writes to non-block-device backends,
 	 * "plug" can be set point to a 'struct swap_iocb *'.  When all swap
 	 * writes have been submitted, if with swap_iocb is not NULL,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 77a46bf8052f..c1fec76ee869 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2404,6 +2404,7 @@ void tag_pages_for_writeback(struct address_space *mapping,
 }
 EXPORT_SYMBOL(tag_pages_for_writeback);
 
+static bool __folio_clear_dirty_for_io(struct folio *folio, bool update_stats);
 static bool folio_prepare_writeback(struct address_space *mapping,
 		struct writeback_control *wbc, struct folio *folio)
 {
@@ -2430,7 +2431,7 @@ static bool folio_prepare_writeback(struct address_space *mapping,
 	}
 	BUG_ON(folio_test_writeback(folio));
 
-	if (!folio_clear_dirty_for_io(folio))
+	if (!__folio_clear_dirty_for_io(folio, !wbc->no_stats_accounting))
 		return false;
 
 	return true;
-- 
2.47.3


