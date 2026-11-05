Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97ED606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qDOE9W2E
Received: by kanga.kvack.org (Postfix)
	id E0EDC6B05B6; Thu,  5 Nov 2026 16:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6BE6B05B7; Thu,  5 Nov 2026 16:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE0C6B05B8; Thu,  5 Nov 2026 16:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 929006B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:32:01 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 116921C468D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:32:01 +0000 (UTC)
X-FDA: 85402363242.01.94C0D8F
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54AFEC0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:31:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qDOE9W2E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v4J18lKuKOIC+R1cR1tFexi0oiMBhzyNL127DHXVUEY=;
	b=ll443atFoCXwEgIrCpqJwoXC5EKe5uqZWK7Gl8YEKS0UiVz39ZtBP4LeKBFTwSuLliOmEE
	J5gTgmy3GMKdm9zbWvqvS19YvtKACjs/P/UsJcyFaBzUh/4GljmkgbFZKzwHErjMQIJF/K
	fVBif4L5DIVCL48zFiFtBulWDtOQOWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914319;
	b=wuFiKb6dXKvD/fbiNGBIxfJHrDi+GA8YRIAaRACCG62LGVVVeh4hX3V/R/VBViGhWsj38H
	YfhDMO9UmxwecGxqgzpzVul0i6x6T3HfenoZZYShQCYT1BwUDFD42M9j+XKib92uDf9wQd
	UwEJSe9FLUZZ3L80y+OPOUV1g0A5UHY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qDOE9W2E;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so54365e9.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793914318; x=1794519118; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v4J18lKuKOIC+R1cR1tFexi0oiMBhzyNL127DHXVUEY=;
        b=qDOE9W2EpuANiaav9B6xnlBY5NBxuJhu6ufJnFo34iet1hIZ8gKy24Ag/BdHi8Gm3/
         GF46ot0215PpnCwnDJtzazKp1rf6gpba3uzrDW35RFYZ8S8NNW8p01ReVndTkXdMeTTL
         RDgI1eLpNhn8BUXerRV/z1OqmjDg5CHLVm2J8QbzRIB1owkC6Ei9xctoG4PxdXJosa9x
         nRIZsR3L7vDb7KOx+AvuOJq/m4X2QFguhSnb+lcElYid6GhnipsIrcmzwzf03d1dhkCn
         0IRB6XakX3AR9XmmlbBtBaJEFZhVdwjPgrGsaHRneruRi0790a11/3UL9zAlctY4ZZlc
         o+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793914318; x=1794519118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v4J18lKuKOIC+R1cR1tFexi0oiMBhzyNL127DHXVUEY=;
        b=2fSS08LreV8DeJezDtk7CXUAwAC9lby7kOgMfnH6INC0hCtniI65vrHz/nWdln5zga
         d2pkQ+XCGdqI3CsazmcapqiTh3sYZ052us2+fv0OvTD7e5agpgVsaum4WpXpdIFunncw
         NtM1y+SZt+rMPiaB7qXiaE9CQffLS2wih4fpyLL+MpvBRs1pJV33nwsGs5gBqHYkzxMr
         SDcoM2tIy+CKBbRdDaS0slBwrOxBs+8rSZAvR1NXLBPxKvXze8ns+NuEsgoVArvkK2nX
         DvxEwJSARy/k6jYdJgtmv2bNmfh5Mz3BIH6F1ijOX/l3UszvvUHXfGzg2+B66lhF19Ch
         OmYg==
X-Forwarded-Encrypted: i=1; AKwUvBxn75cixbDFn5V4TTEjELGfJPf3Ix2UmttPRgTsDJie5HofZwxIkRQnjedcZtNqLpBMgfR7AT3aaQ==@kvack.org
X-Gm-Message-State: APuU4Z+2pKBoaEdCQdZX14FB0mq4F7bMPmXDEmoAcqn6jhJj5eaN3Ds5
	hkNkJ6DsG1RaCv8+8WtufNRE4qG6BvqLzsjEKbvU403RcW1IXJX1ieAF
X-Gm-Gg: AYBFou3vEotMsuyod1TkMf90si7C6ocAtLh3zkZ7By+Yi+/1T2r+fwjJmdFz7D+Pym9
	xedgtV9x+Shkl++QIB4Vgsm5jJqI6Wo0bjQMRNA/YkJWl4iubq3mnvNUAy01eHac8R4E1JYaxoS
	zXCRxEDstuzrrZ/JW52H4EDrbWHIS9ie0TIfMUqzhE82KEKGl25vk4Dj2sweknB+iZ0Bo472ZOr
	A5FDjrjeU9EfeusnNUBXlDqgloVRRykOdEatuH0NKcdzbf+FfcqE153SkS1ZQSAeJO2nIQAeyNy
	augc53dK6VZhB5kvU0TZB6Rw98RF4s+rRzETQ2fH4Khv4IXKQc3LbE7zDfMzNrhMPNSmkYscn85
	C2x1ty35SYZyNZrQSBg+xC1p4ejVSxkGyg4LPuYp0srLFX9idKmH8DSQD6hGADWwV6QMX2KJDUe
	DwfJA4fbv52ISXrzl22dJ3fDAAmdygjQ73I0iPhnLJa9osm5/wJbGJZ46bMK9NveuKYV2kxW8mK
	lcE3n7RvSWx7OXqP5tLOeMH+xzbtJjJqJNW89Uw62H/AyYMSPPtLxMJpkJXVZun577x02AS5mnK
	c4sRDVKnFggrpQ==
X-Received: by 2002:a05:600c:46d1:b0:4a1:df52:3e36 with SMTP id 5b1f17b1804b1-4b6dfe8f4dfmr6379295e9.27.1793914317723;
        Thu, 05 Nov 2026 13:31:57 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b6e28cce1fsm7654035e9.15.2026.11.05.13.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 13:31:57 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <kees@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Alexander Graf <graf@amazon.com>
Cc: Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH v3] memblock: don't allocate new reserve_mem regions on a KHO boot
Date: Thu,  5 Nov 2026 22:31:49 +0100
Message-ID: <20261105213153.9572-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d9djhhjdtczrkfmi6j4o48trhbb9fgn9
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54AFEC0005
X-HE-Tag: 1793914319-12773
X-HE-Meta: U2FsdGVkX1/fsVb+V5xkQPfrSPNDxGuJ3aSSE33K8qP3es2CpuX7X+06OWkiHhQkKCVsPaS2C84ZHw6RUFjCwEPBuWCZ4qPAJQr0ZRaTGdNUWvrnrMjzK+BI82lKYN1qzlKzBbCXhbwLgXAttbIwBtPNB5qyjLZ0nX7HJeJXjDru/GSiI9yqkgcrlCNgLmSROuOzapa5SW2qXOcUzJ603ak9yeI2p+gBTvrY60CJJTzSe0wVxlYWHNflsuATP/FfIO1i+pk24AemLLGWYRr/2uCMrSxgm85/lUDmtx7gMYrAmHIN7DkvaOMLr/78FhBl/ZqjjBy8K4PRIXvQbw1K/BY7XAVZ8WjDOioOPti2/p7i4Km6vTaJP1TWnG1//qaWdn02iJs2xhujxsIova3ZQH9yFeQbV2GmyYlGKWW3KZ8fGdbB6VMqT4zcFsFKICIs+pKTAyyuu/ziNkRV04itetWbu+RXvTkCZ08btv2+jdZ0ojy0YzX2iuIn/emHRcMjFl+udsbkLV/ba0cp5PALMAFSEYuseWGat5XxaWmzRCio9+T8wQDpn1R4Kbz5fF9BU1MQ+P5V9Stfsq7D61DVSIf75E8nj1tL6LfnniYNKrfqkACZa2e/dsWe2T3iru/o2SKcX8MqYi1C5ABUZ37rPNYdczxJJqEc7qd4WpQbAfLHnOZ6NBQ9a09HjOhlYOGUq8qzdKbjfibL5TGWg2h3XNNCIJ3nOMBW922cxoUWZGvNIX3N4xXev6MtyxmKEeBHK0yVkW29Dx5Sa4OF7SkycadhM/9VMOs6fY1QR3qliWT7GphpxNxqeaP7i5uzJP9Fc3Uw8uvLMuXHxFlpEjPyAbY853WG4T4BU2X+kt83UtZ2QcYezOYBk/upCLPTQXlMwz48w1yzOTfQA6l4YL5OeFKjmHw7cSzzZJ4lxnZ/Dh+/waFDYR9wln2yegox1uUDdl0mpf6wGTJfwas0zWP
 Gh+LL1L1
 hz8xoDJf8fTwaoSGZPXFbfATgkMvlxJP7S24MZ+yDL5/7IX0aXBbYluPg0ecsTFikU/O4apVIatU8QET+j9CMeeLOK7x2KTT71El03N6rYoqfL0bJhBHRHf/Zrd19iDBGeBj9g32sMt0Sw4H1BEbC75+wMxWeWzpV0GEPGlmJQ2wirg6R4qNzVQkX0FvlmpH9QdG5n+AmO2U+MlFCDkQdJHx9JhFywdctmZv9Irc5f+ThkKuC79OmEzukX2tVEypXIHiDIJungPZj0Sk1LXYXZ737VtDlhiq4FskPRuHnI7x1EZPT7qN4ujiaHVzzSbpV/X6EUX8K1HjrnJzhsOaudu6cJMKgOjfcnEJ1THyHPter6Uyp4PVN8LSTM9KSCfnhUQvd5nwAJjuqvE1rG2kakJIaQeNVZrOYaCZ1qW+RN/sMb1NIlgqu6h7vpNAdgipFqxD5sYV6oHzsOmBlRt6g3vM3f/Wirz18YfsTXcxkEfLTFwOEwMph2czJfWITJmsgAZtWfZrVYyk7J2QB31U9ZwiO3eiQbsD5HB56
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a KHO boot, a reserve_mem region that can't be revived is allocated
from KHO_NOPRSRV memory, which includes the bootmem the next kernel
boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
then fails:

  WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
  failed to prepare memblock FDT for KHO: -22

Without it, the next kernel puts its memmap on top of the region and
the ramoops records in it are lost.

There is no use case for adding regions across a live update, so fail
instead of allocating, and drop the TODO.

Add an is_kho_boot() stub so the memblock tests still build.

Fixes: f99230780211 ("memblock: add KHO support for reserve_mem")
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v3:
- add an is_kho_boot() stub to the memblock tests (Mike).
- add Pasha's Reviewed-by.

Changes in v2:
- fail on a KHO boot instead of allocating outside bootmem, as agreed
  with Pratyush [1]. this drops v1's patch 1.
- not an RFC anymore.
- based on v7.4-rc1.

v2: https://lore.kernel.org/all/20261104204235.9066-1-azpijr@gmail.com/
v1: https://lore.kernel.org/all/20261021211058.83483-3-azpijr@gmail.com/

[1] https://lore.kernel.org/all/2vxzfqxglrg6.fsf@kernel.org/

 mm/memblock.c                     | 11 ++++++++++-
 tools/testing/memblock/internal.h |  5 +++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index a450092a80fb..e325e0542c9a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2827,7 +2827,16 @@ static int __init reserve_mem(char *p)
 	if (reserve_mem_kho_revive(name, size, align))
 		return 1;
 
-	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
+	/*
+	 * On a KHO boot memblock only allocates from KHO_NOPRSRV memory here,
+	 * which includes the bootmem the next kernel boots out of. Only regions
+	 * handed over by the previous kernel are supported.
+	 */
+	if (is_kho_boot()) {
+		pr_err("reserve_mem: can't allocate \"%s\" on a KHO boot\n", name);
+		return -EOPNOTSUPP;
+	}
+
 	start = memblock_phys_alloc(size, align);
 	if (!start) {
 		pr_err("reserve_mem: memblock allocation failed\n");
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index ba4d1c02fde5..84f22a964510 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -51,4 +51,9 @@ static inline bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 	return false;
 }
 
+static inline bool is_kho_boot(void)
+{
+	return false;
+}
+
 #endif

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0


