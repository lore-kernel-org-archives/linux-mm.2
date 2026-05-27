Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34400CD6E41
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41AA6B00C8; Wed, 27 May 2026 10:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16566B00CA; Wed, 27 May 2026 10:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD156B00CB; Wed, 27 May 2026 10:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2496B00C8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DF901C04BD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:14 +0000 (UTC)
X-FDA: 84813369228.16.B60C66B
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4E75618000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gf9og9V0;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JDtbAu0FdDQr0xPj+QYmQdEcSfPjgFyi+UN5Ynqy4tE=;
	b=42A/hpXwV0UrRINeTRtcAuB96XOPWfT1UOOgsQZvo2CbRCcwG8yaczWTATyCB5/1u1f8oj
	+Pr4SDb9ZgayxLVwYVlG/70pWmYXmxGUuPz4KoXNDWWh4GmKlf/7721GiECjs1Zg067S8n
	zSwWhEH5DzpvySu3Yc7+zWiC6X8+rX4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Gf9og9V0;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890652; a=rsa-sha256;
	cv=none;
	b=l0yqnkFcUie3LlJUveOMNI5JqV/HAcFAtVV4b5RPRVNDZsVDRTM2paOfSjWhk+3zq2m8ao
	MyGWro5RIqunI2xasPLn65rgr1lsmFYHHp8Uld9WS/wstmfcqjzPEg3wYt5rxIAPORSj9o
	L729bxF936wG5A29+mMBAPvnBo7nuR0=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49041fb8c23so43215755e9.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890651; x=1780495451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JDtbAu0FdDQr0xPj+QYmQdEcSfPjgFyi+UN5Ynqy4tE=;
        b=Gf9og9V06sWSa7JXzug8mFoN+BaUaKPDV8OGu7K3+ospW02b4NvXc3WjGj9YMl8AC1
         Gi3mXbrGt3KHlxoTPZHLb7WBk+AzwQv4zURd76HFBsLZsPIxtm921CwADuB3O+QFvmO9
         TLX5N3l80niz9slcFHVq53QEoEg91j67aVg7skVABVaiNvd7wNOWgGWfFff9CKtNwOSS
         SflW5r9jP+ex5KR01md0r8S6U5IBbnaXv9as9BzmjmiXl81ypSbeZ1avDCOJ+k8Vld4b
         /N/SpYlbbGbvRbnQBtWFizMA7sa6PsPYGw+HhMwbzIGiW9WT8Eg2gSg69DsulZSw+puf
         Nl9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890651; x=1780495451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JDtbAu0FdDQr0xPj+QYmQdEcSfPjgFyi+UN5Ynqy4tE=;
        b=JAMTyJjOS5X1/WXnLwHR52Tzc+9m7eWH26SNJ7dADZ/FoS4EJd10lRiRDImLfzNseR
         b1ePme6OqtOhf9e9iyYxMri8IPO+jCEF14V7jq2Y8+pXG4cfWFaPV9EB5dD0gs6fEULy
         hs4siOOSwdLzniysz3mqVKm5k36RHeKgMQaALkAhp9vEv9L/FNCGgecfjOzdsrFYcjpQ
         eJcu9r6M3+ForhrDJtg/g5ftu+kXLkOdjNWlciOzuneVZxCn/ukzCpjXFkV53Zt4SgyL
         1ixUGanaQPrEwjxmjETmQz/+JwvVbT6i4qs1ukhwf/OzW7KBPps/rLIZl6fJ06K3A9+0
         kYqg==
X-Forwarded-Encrypted: i=1; AFNElJ9AtNpUhAaMkRgHgUWMNYGt0E972mSgTrmGOT/w7HxHMMyMXVeo7QyGKcniwVsB16L1S4sLnHNGzA==@kvack.org
X-Gm-Message-State: AOJu0Ywar32xT4zwNl/ZwGuKQ/0AF3BX992SQREwXxUynfLj9gDQNzqC
	shabrAmfetO5mafreVs9bU/5LI7wTlmx7wwkf8/bkIg5dKU8qBNrJYKI
X-Gm-Gg: Acq92OEBtUBJzHsDmdwJRbBWuO0FmeXUtNiNUKJd/8AD6yf/U0zluCNO0I68DZqGL6n
	5uaUEG0ros4hEUVIOJv/iA3HpUA0ZphUvKiiu+xkFixkoG4MVnJLtzYJ0WDAhz0MiPh/UTgil4T
	jyvboriSqs844di3f22xa3HeS4JVh8AXT0ybCEmNooFcsXyTaR5W8uFAhbEjTBmZLhp/icLF8Kk
	VdsLoh538VX/Zz+MFTPS1/I2fPeP7lR22DUBFWtDAzkSPu6j9IGy5wCPLyKM84VwnVa/VDgzxSd
	sTiA/P1w2g9r44ve+v35gdkmCf6uXVKfq6lkIL3bwVt1M8Rf0cBoH5Qcy47FAr8pdLz+DbcuIZq
	saRZTqOcy9xOrFu1Q7qay0dN5QrQHDzCuRTIONcybD8OJ4eT9lB4MDZPI/O5D7mT1F2sE74/ZwI
	IeBO8PJkdH792lmaaRpLY4+RNSxzgyNra5cWCEPrOIScBswP8FldeRjUuYDIOpOoaJqHFtwb6Dj
	PDSW6n5PYgOYxoKMJi4B/TCG4LOZNzHlCQixKgcUJJL
X-Received: by 2002:a05:600c:6383:b0:490:4717:970f with SMTP id 5b1f17b1804b1-4904717984dmr382832315e9.14.1779890650342;
        Wed, 27 May 2026 07:04:10 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:10 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 1/9] x86/mm/pat: Use IS_ENABLED() instead of ifdef
Date: Wed, 27 May 2026 15:03:08 +0100
Message-ID: <20260527140316.294621-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k9prrp9ezgiudrpmb16pyburoapr87xp
X-Rspamd-Queue-Id: 4E75618000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779890652-628797
X-HE-Meta: U2FsdGVkX1+dkw/rQaxEh5BXP/ZcmHVe6BFf/zAVFCFf/4bFylgOvbdmLlTjrdG67j7AxDJF5hQvIiWQWgxukvb4KcULZjwIAA5clnYUCPyFwKEgQHplbVo2qe1jcxBezA6cq0MeyhPIZfy9eLBtzLcKJDw+1RIj1Wy0FRRVfsFamE412x3+FRh4GR4Stv2Jnp+bqEruBWGb7uDOn5BZAELD1a+mgLTPCXlgIiDos0PWlsT3iqXU2KKBsnCssJlAvB9f0flGggTiRIzM2RfDQvQpfgClZ4b6PWwTVJes6Flr//ZCXi4gfnUAd6K7Pds3DK4xh+uGphPycdJRfTB8c6IAbl/MZFk7eA6tkxDDiwA8Ipck6WC50MQPeIupN7TtrdJuGrzZgj/V4QriGSPHw1bN0kjg76+C5dizhJogUcRL7HZvyke6Ll+v1tSgzSvbYlgSQOLdGHAIQ84m8sh3kxcXIwwo+Dt9eaIUPTk/E8Bod7gcUe0F6ouGC4taAq7E+iQcfjpMwI5bB8IvWhy7odcD784zQZ5MYJdDK+PP2hbDnGMwC+HvjGhTxceFV7RT/SHDybu6hFRp5Zs8ERepOMMUrggWDavkYrxqzrls2/3Paa1uD5FoMxoIYrjN0eTGgS6Dt8fmCSNd3kNenoS5n6vr5beHWJJlNX2FgqzID4iBn5nUVjbJAnDBMXQcc/zMpVHzlrQm3bvd3WCbuVtqJpj72MP37UsyTE/xbIY75j0wOt7JDAi7bBLwREuoVqebDTbWosB2ak4oyOzHpqF907EICLhEFGBCqKm8dcSD1TV8EsBc5JmoTx3emwiPBqD5MmXvjssPOq6re7aScXFgkDyu/yoJBKH7HAezKeHEKI8N15HqfqQmzV4tp0fDLUJpKz+LHKmQA0vyQNstsLXqphZ7Z5LYtsV6vRNslAfLA6A6iV2H68MfCJdBtjnAqUzxzyEJS0xhcMe9UzlRcgY
 pjjDrUUm
 GknE7stf8X+VGq2KoGRtcHQrJSXBz5jakmlW2GhzyfHhfNE0BYJYxFPe5fHtXkUu1RVPdZ3sECmJRVCCO21IVtiZWBivLKUarORByxfhvQwYZPpeqwX+4rW+mJOFMr/Bu5PuFK/45WppGvg9jgZd+V9GIq4o1yEGEaN/xREt6kBofKZarzN28NhiHz6kscCo4clbEnD5Z/dvdPYtHxMzVneV7hoSwF6W8g618F6HAvyM8/cCgSxIYQPSKkqhcYWhp77euGCzYCi/PwZer796h/TCWV8t3J5l7c90AoFl2F8+p7j6v/GPOzLHjxLrbzK+xV4Uk3NAR7vmBpwMCbYUmt7KpjEIGJGZR2wCRwT8fQPyTbx71OamFAP0MgDdcpW/kIWuL/jz2C6whEtRADDgeD21xv4fuR2u5kFPa2CNdJy3fA3rRllclO7Z4liBbyRBRMFj4C+IZLQM84fgNeHsb+pWzZwuifhEJDqppRuN9W7VruTyh/COoVFGBmWufwjxHYV3YKodE7d0MoffWsNKJiYeGX3rcXadv8gjQv5UnQuN5evCNaNhO4Ik2Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IS_ENABLED() to check if we are on 32 bit. This standardizes this
check with the other 32 bit check in the file. No functional changes.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..3b9032a3f315 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -888,8 +888,8 @@ static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 {
 	/* change init_mm */
 	set_pte_atomic(kpte, pte);
-#ifdef CONFIG_X86_32
-	{
+
+	if (IS_ENABLED(CONFIG_X86_32)) {
 		struct page *page;
 
 		list_for_each_entry(page, &pgd_list, lru) {
@@ -905,7 +905,6 @@ static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 			set_pte_atomic((pte_t *)pmd, pte);
 		}
 	}
-#endif
 }
 
 static pgprot_t pgprot_clear_protnone_bits(pgprot_t prot)
-- 
2.54.0


