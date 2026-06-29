Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE5EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23F86B00EB; Mon, 29 Jun 2026 14:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5936B00ED; Mon, 29 Jun 2026 14:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBFA6B00F0; Mon, 29 Jun 2026 14:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 543616B00EB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:59:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D17C51A023F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:03 +0000 (UTC)
X-FDA: 84933862566.02.231A0D0
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A75F16000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IYbg9Ibj;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759542;
	b=YwHOSRx13UvrlXO2MtdfI76tvo+DiV6r0SFjO1C34pu14lyPRS0SDK1+wGt2llttTitQt+
	XGLR75XRDjO9j9BhLS35H2INXl51VwoXON6MMatxeuYI167i4/MP1ZWTVoj49uaCaVyCeX
	djU/94c29+suFp9vqLvcrauro6zPMb0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33MwGvLoP/1miTKHGEtP2qQNmfdum0WOqxZBRNP9hxM=;
	b=jaic+Xy5ObRW4J2enkVI+UN7WMAkmL+Eh140zJEwd2a19fAILPY/7iUx8WzQUyR+5UnZpH
	SMFBmHPn+LtcJgveOmnRiXMrndv2dgOl5l/6hoNFN4KqZTr7Vgv5JjXSIE7DvOVxTM5dqf
	BkfSrDjobBwSBnV77TPrnF5jEeiiQys=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IYbg9Ibj;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-845eb7b96feso943043b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759541; x=1783364341; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33MwGvLoP/1miTKHGEtP2qQNmfdum0WOqxZBRNP9hxM=;
        b=IYbg9IbjrZVWJOcs65D9p5gxfqFTXUMjjrg9nYXeyalo9PBGEypk2+4VAilLaSI2K3
         jFbibAtrTVueG/6AkUlvZBWcBezSQmeK0gUbDl0Xv88lM7ccJiir9ta5C/zaQYtHDZRz
         yi8driu64QZ9i2o30mcIamXTDZSBQEjkdqSB5kt2kuLNfMisoCV63dlqHEe6Tln11Hnl
         9RRSBhRrwZlJh5nNA/mLB8S9W2ZOUeJC4Tlkz67F6+k4QQBzFEX7F7odfIyu4wtvhyrp
         VNtlyVYR8DCYGeF7xw4rwRCeXdC0yQs7F1hcm7pLyLE+Bt3ufiRN1KR64WxndzuoihRU
         9/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759541; x=1783364341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=33MwGvLoP/1miTKHGEtP2qQNmfdum0WOqxZBRNP9hxM=;
        b=NrjQ/How6dpM+4TeeiFDTByqVZhVxNMUN6p07QorCAbBWdYcQtVpzDBTujijLn13rk
         ojqVUta8zrXw5i4tSbwBb2bRuyrhHxceC0b3WqcFAvIpm9KgdvOwNYIXsDsCZkGjMMin
         DEduTs544hDj+eYQb5g/F2uPpFydFEtogjTKOOQtoOLgwwmWHbf+5Cfz58shhajuXu16
         w6e7nkHbfkRjaksEbBHwUeeLnhAb/o3T6G0UEojWSAKw4ESWXHULgzH46ZUhGE8FHS6U
         NaowTCdJz6ynbAE4+PZgqLgj0FX1Gz0jm1KlJhkCMSvZvJn4kUg2iAhGwesipKXPg1Lj
         C1kw==
X-Forwarded-Encrypted: i=1; AFNElJ9rbfT0o1CK/c/nqZDi1haDoNLVWhlbHv7FlWHLEoKpr6Bnn2Cwlp6918SZ3wPFMXUfziAG1bkaaw==@kvack.org
X-Gm-Message-State: AOJu0Yx8PKjUVOHU3CeB4aNIo95wfI2wfCsV1OHg304bcpIReT9hf9+j
	AAlTtoAfBT385nRecIVKgHyxGllmcNgdOGlrlIkqR0mwAAYbpvMI3twh
X-Gm-Gg: AfdE7cnQvyHsZNKIDtFSb/ul0/r3+vyfAkTpLVZlTe/9eyblFhZOwSiF05yME8IEqv/
	XMI/Ow6ejSdl1xKaKIcDezhudN4csGKHHS01vR4PL5RRl3l8rR0+W8A5U2978qtHWkW1m5uyBX+
	0U9zJUgQoH/265pVSycRwul2YP15IFL58K0a5YXhyX4W+Djbvl0twyDBqNFzoUIK0Wnh15WM6kw
	KabB2yDjO+g5cnNYi3XCicevdz8GlCw5LDoeM5/CiJ6NtLZ6q+yH+Sw4872B5hUe38gJlTgbtsr
	fwbt+rSlQslTLSicsmHsupUDEtvY2PdgV2NyRx+/AAYuuPSH8QK2//oZFzSzOzGitvR+KF2NjXh
	rOD0aoV/KffWROD+iBW5i1AVT8B8LpWXLwPhIZSsUqqO1gBMvBtfYfEFQeqFCybE/hX45rWWBCD
	yYuEXhx/SLPb4kwi1van6M4x+hdC8drTGugPgACGkxc68MFp4KYDWJsQeQECZuIYy3v+MnqXE=
X-Received: by 2002:a05:6a00:3d55:b0:846:4d4c:23f8 with SMTP id d2e1a72fcca58-8479eed8099mr524689b3a.1.1782759541059;
        Mon, 29 Jun 2026 11:59:01 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:59:00 -0700 (PDT)
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
	Vishal Moola <vishal.moola@gmail.com>,
	William Kucharski <william.kucharski@linux.dev>
Subject: [PATCH v2 4/9] x86/mm: Convert arch_sync_kernel_mappings() to ptdescs
Date: Mon, 29 Jun 2026 11:57:37 -0700
Message-ID: <20260629185742.126987-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A75F16000F
X-Stat-Signature: h6oadant4ytf9x3ny9chehe69qem1b4f
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782759541-322283
X-HE-Meta: U2FsdGVkX18vFXd9C++uoT4S1ImyL/S2Ot50nBw/8j8j7m9H6IcetXr6kURecu/mGxpJaSO5rELeCVsrvlkrM0eNLHETbIF4XtSNt3EwgCCpMX0+5i8lAaGzSH3sLzX3znfflDeaV7yHqlBznP9CBRYuijdPd6+/3NNI3UPDrY9q69mxkFSwe5znUpcQzNQHD90wF0lA0b46G0SxaRQuP/WPl4jnNMHpSUYaZP1ujYdux5H1IeR+rJMCAxonq9g9DmoYlu5Du1LwYOGzzXMLsqN8fnOYeemhIDjNtag+I3xtJvHkG6WYGZHJg1xTME4oli9qOgoUp7SEblEVVg/H2TdvIGaAoTcDtXe5n0mRPSJtwGCxGmcuiqCGf2t96ZoTdbDU6UOyj0BruD8PBymyAKQnn/68EGY8Wo12qijD43lXSf1H2+N8RAXiwcTXwqSKOrEZ8F24Wo9KHf2fsv0wf8o0ygzK3Kzl3dPaQblRZ/unpAQ58asfECgPr0DZ9FMIkp7s0KaBGKPojhpmztfnQftwX9o9gGNGoMlYJKgDkTE1+xQ+JtG1dq1U5J8LxgJnB9SDfvkzQnhzaiwy2JElxajhb3Zf6LasEFJf6HPZWX1sYj1itsi+Ia9t1w33j4DVPpxjzA12GhkPw5/d4Y3n/NiJvRMyVIVD1VE8SxnIPK03OpgG0g/4cvfEYbD5pAwd9mCBHSfy6uoqHAQ1dJpMX62EWF17cIB0vG6yhKE8ZOsj6jIb3oKKQN8bwZhxD2QKl3VD28IQ6ECje2k3PHKhjrYArfSchyg/MbfL9y4TWUk62bJP9yVA20Cf2bPrTXrMdIXH7dKQywokp4vTfJlPPmwNTsSUddaB9GeSjuZNUmw6KycCps1aTw7r7UNYVHdCG6Z/WfyhzDKiNet4J3LyWvy4SiwJzuzYG99dK9vuoDzRCD5QZ8rsvfxZoyaKwmNP08ZcB7dobZZZYXGU/Ou
 QUiy4mCS
 q5KI6DfYKsRn5BYmid4xgj7Y21VXjnTPvikDkMDl6wUQN5vgZyOfXDeVsWJ/uED4J0cR90iNim258JmWaxBNbOia04NDPjVadZBTUE/oIWm591dd3OHRout7SmjSo44EVlIMc+Hrdn7ig+tx1ol8O9lOdWQaijKBa6Q2pIdR3QadF0c5VY43jC/3ZqrSgi0thfHN8D+sp53a1MkwzXT6xtUzlCfpH4MaoSnKgflik8ykPIWZfKoymmJc4AqhssqnSlexdSLgp5OpZQHZfj1qQzIwoXPEEA+XHO9ivc2KR63AGDYBEAh4AzYuBCr+zy7eLZjoU07nxZvRr6Rb4/wOZIBx7prozdl4KwN8IkfWhZ497gy3/hmcyG+LcNzrLhM3lAr3hJxgwydcqC5O5c+KOet7EjIwpoDnfg0APQkxNHrhdTXLa9OWZFTHDm7rcA1wyrhw5o20DitIaSAXz/PTEFULB1+n0J6/fqjYiwTKldkpl75/J5ZzI01eSwTGR1nOUSAEwB2Z08jmKcwWS/VtXv4gizH4VxzDcAOU+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert arch_sync_kernel_mappings() to ptdescs in preparation for
the eventual splitting of ptdescs from struct page.

Following this patch, we can successfully boot a 32-bit x86 kernel with
separately allocated ptdescs.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/fault.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 45b99c3b1442..c31ffeac0714 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -275,17 +275,17 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
 	for (addr = start & PMD_MASK;
 	     addr >= TASK_SIZE_MAX && addr < VMALLOC_END;
 	     addr += PMD_SIZE) {
-		struct page *page;
+		struct ptdesc *ptdesc;
 
 		spin_lock(&pgd_lock);
-		list_for_each_entry(page, &pgd_list, lru) {
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
 			spinlock_t *pgt_lock;
 
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
 
 			spin_lock(pgt_lock);
-			vmalloc_sync_one(page_address(page), addr);
+			vmalloc_sync_one(ptdesc_address(ptdesc), addr);
 			spin_unlock(pgt_lock);
 		}
 		spin_unlock(&pgd_lock);
-- 
2.54.0


