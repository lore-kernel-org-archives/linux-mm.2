Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0851C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B0F6B00ED; Mon, 29 Jun 2026 14:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481B16B00F2; Mon, 29 Jun 2026 14:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 258446B00ED; Mon, 29 Jun 2026 14:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8DD46B00ED
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:59:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BC9E1A0252
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:05 +0000 (UTC)
X-FDA: 84933862650.11.D2DB2CA
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id ACD5E120004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xbn33+P1;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759543;
	b=ylGyfBK6cDABHwdkIHqD5sj51PBYiKgIV6et9FwlG3oTZ75bKmiMBYEh4gQC7FD+ET5BxQ
	GW8qawYRAbKNhZM4lTXJ7agNDH2leqTyE5a1Jg0CP8zILveth7mwVLSTM1PwBp8nXP1XAc
	5VLtfFPQo69E1DpAV4DWb2ZpbK62aJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2T/pMX6h7HjGEpjcwH/mP3eLvrxdsYJ5WpoUpvOL0D0=;
	b=JCTFsM17WZsmVjcWb+Fho9WqCg5bUIY+fB7QsEKeh2U5jp5r3FjbikuJedJlb0Ok+GcU68
	B0OmWtesn5QNTLsRI7Cd8+IwztpRqofFySfDGe/KmdJGqwbChErfJ59++z9nNT7LiN5Tve
	w8BwwShUgiNG0m80kgd6r7/EHleZ9fI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xbn33+P1;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8478fe07f0fso890601b3a.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759543; x=1783364343; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2T/pMX6h7HjGEpjcwH/mP3eLvrxdsYJ5WpoUpvOL0D0=;
        b=Xbn33+P1ESRhmNrwkqDM+TFBOdtNE+h3nrukDj6hoqLv7k5mKVsAFMPDpRIU2gr0x2
         GTtO+41rW/G3e8KyxU1wCpK9MsQiQHCp3qWOQbQogbOaoJOTd+KaQYT/IpCoIRA83XCN
         pFYo5KXH4OL4dmZmNBlNUsPWcmhcGvo2pTkQs4zZngd3wGtcdjmz80dYs6CZdAVpw3QW
         Z0/kifDpzOPpGPVB5GwcLtHVrr+K3bvpP59sR0Tc130kumvEWeBqFo0tuzPW+ObzI/vL
         kAK4cVhe8J8t3DgjGsy+VEfb9EBBnOMA38a7hDunZ4FvXVsmf4fe71uMwr1SNTy4bbCb
         ZG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759543; x=1783364343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2T/pMX6h7HjGEpjcwH/mP3eLvrxdsYJ5WpoUpvOL0D0=;
        b=oqHaerTYW6znJDALfGjibVF7jsco3ytdnRFs/lUkH63MuRmwnNfx/uupNtrp10zFXP
         YEzcEpnAjD+Bd9eO66Okf3dsaBRbowComLjCuXL0zPhyBoaDWaUGBpflJxjCNV50v4gb
         Dq3OK/1cy4cX4jbNlmpxxSDTIpEaQmkT/9Dh1Fbr+fJsStFiSCTWIVbOOZ6HsjOiet/O
         PgvoaWrWtn/h46WUviyWo+K04kektp49Gl0JOTMvcLrvlFH0dg2ZNR5VO4yS4U0fwlYJ
         xgx1Jt4gt6gxWG+/+WGEY/z1t+dWhsElBYtAh80nqpFySDsko/2opabP9i5XFezVF9nH
         tF6w==
X-Forwarded-Encrypted: i=1; AFNElJ8TZn7GxrZu2GkbkLDSl3ULJKF9jIxncm0TRwLqqZenWdzUv3xHTY9mBMNiBPJL/XDDQXjQLq3VLA==@kvack.org
X-Gm-Message-State: AOJu0YwaP/73HPiK2W9oR2xykIEdcPAWouS+b8lFT0edHqbnc+1F2aTF
	wdj/nGe+DySKqUurZ45W+eAPl0Pg/xI09Eka9tEMrrM7lQB0kd8xXCc6
X-Gm-Gg: AfdE7ckShkBTDUXpNHh1l586RXYduB9lNGIcvj7H+Lth1NvIgJZsdM6agD3m1gvC4DF
	b517NsCsUVU176jJODyMeLjaK+p1wXnWoxPLJJyGV/Uf5knIkVES0v3Kons7H5xzpunmA/AQ7nW
	SVnC/qNUxoI9/oGCAX+sX5iklGCWrW+WwLv+UHZspjt5qPdJfNSQqzl24qGv/+lbQ4Wq0m0aiG8
	X/odvLloXcVv0PxQdgDVPXh3OHJG2tQy74q35IMnbVI1LRnhCf5nls+Iq9bCBEwPlHwwzr0wgu8
	PVSYcEJsPPkzoiDz+ip9i1KzrgqUYSehfyxhJQuW58zAYNKaYLWyiRtwDulynCiG3odeiMyis4Y
	qQKhRujxu1h7RgR1+O5fTIW/br7n9dqLl+nQvfwR4quH1kfbvDCXMpSsW1kBCpffEt5pnKK0XfK
	YVK3SDL0lS5lWUz694yVK6YR7LvTC42HYu7ruQGn/IvpTlVatMB34/mFmhn/uGvI4B7LzxG4A=
X-Received: by 2002:a05:6a00:23c4:b0:845:3fea:96c with SMTP id d2e1a72fcca58-8479f145d69mr553340b3a.21.1782759542633;
        Mon, 29 Jun 2026 11:59:02 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:59:02 -0700 (PDT)
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
Subject: [PATCH v2 5/9] x86/mm: Convert sync_global_pgds_l5() to ptdescs
Date: Mon, 29 Jun 2026 11:57:38 -0700
Message-ID: <20260629185742.126987-6-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5iquk4dbgjnwtes63go8oe9xoz94bhsf
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ACD5E120004
X-HE-Tag: 1782759543-55919
X-HE-Meta: U2FsdGVkX1/aWq+xUBaZR19Ws2rZlwKIC5hPB7CsO/1O/dr5Lf5GDQcPir8uFxwR/7jsUZZ95c14rVDDHq7narvBTEIDTiEUPV7uEgOtEbZyQlZayX45BoQCgyvHIU7onRjcWr1vnPXQsqXSutL/x/s88o00U31ze1kfdiD8auiEAKo8eAvg5SbMKGTUe78a5KKNDCbHGmRpwSZX+Ql9Qd/KrBbQddCRafCdF/PDaM05uW4br0/Vnb5jDxYBk8ulZPdmH40NVNj4JSdS5LGjTrB8oWCF1ASsx4tRQcjUHq2XSqmsu43hFJz7sAUGaX1SCFR7TPxS21gpB92BsTpvGa/i+n0W/EBmyfKPuAlw0Z0e7GsWlFWpJTbcpOHHBF/R2Ra07HpqcRaU0M9Gyy5g+GfSYeeclXSfeQOzWIlLjd9M2ibZsSyHkjCtV0cgvJqd+qmjDg1Ych7q/5sWq0lEO+MWVLyhioW7nMfJ+Mc8Lzhd52wxyhjG2lnS5mx34vc/NcJ3eNKen50zylLt9YT8H26qjIPjtiGgnhxXsNMpywEP6BBzI1uVenmuvr9ovzAkLApE35BRZq2/Fds0v/+pZRWC9tHSXYmBLdgqeDof+efi6WNu18yXYSuSHANJUzfVqUI2KceeDybyoT9yyvzOC11r3q6rKVnEaCTzSRO+d5Uj51k4ANeHpuvJS6o9V5tg+jWeP3HVDDOQfVQkSTHk+3TKq/TWvarA6wpSw5Z6TYJjq5jrsuLVamqAehbqjVWjmJIGG91VA8HRv+xWXtHo4B1XTtwf9UOtIuphKtcgvPX5r8aTP3Tg8v7lbw348PPaHpfOjtJm0W+uYyU1n5DP6lZFwop5NqlvhhstjVtI6/txczeJQF16G2c2IWamDKhAVhqI3r8ibCIiH05kpyLy6Yd3pGkQXLTyrUYBex8baZ5VaFEnW2ZS8r73+HpLzDMtrgtXKrwRR3ym+Nu/iIg
 CN23Lqzd
 IfxzSGPM6vNc/QhyJe+rT+U69cbzsweDhaNhsUwaODy9xgXSC7b6bQisv6W6FDlyZxdmE4txkm7PBTpA/u2R25cjmAZbwXKaAYs5MobItiwy9gMhE9bgE+RafMXkzYUwwP4kilwUuJIi1bmTt0K9rgOEEz325hZmzBHAmMLmltOCKdPioRQedw/H4lN3QvhLxE0BCUdUhSYmNHPGp4joB7fXH9E8JxfHNDAPAv8gyynsYOkWPqrEBUdgWIri6hz9YwZ1kPTQMUGN8zopshSDLLXG++NQAsHj5+H1ijA6wWdaPyV3QiqiVjAufFNN1+fBfz/vONsxg6nGc+nk0fUgGBOxBO/eABpMUufrpIG46/v8a+aO1NXeCcOT/VhY9YrHupvGIhOulIJ9iXX1lzLeC/2caldBwWWloej6YE/o+umJCtkm2XMWOqjI6RibWoHz8uc592VVorpdQTlG58UGBS0QD8FkifjEcqoYy5oToR5InzpBsCUvVWjxBFQU4ClTxgJa7WFxfoMCPX8kZpANFicRwa/f+iqjYNvWm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert sync_global_pgds_l5() to ptdescs in preparation for the
eventual splitting of ptdescs from struct page.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/init_64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df27379d4bb4..e89b51aea2cf 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -136,7 +136,7 @@ static void sync_global_pgds_l5(unsigned long start, unsigned long end)
 
 	for (addr = start; addr <= end; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
 		const pgd_t *pgd_ref = pgd_offset_k(addr);
-		struct page *page;
+		struct ptdesc *ptdesc;
 
 		/* Check for overflow */
 		if (addr < start)
@@ -146,13 +146,13 @@ static void sync_global_pgds_l5(unsigned long start, unsigned long end)
 			continue;
 
 		spin_lock(&pgd_lock);
-		list_for_each_entry(page, &pgd_list, lru) {
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
 			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
-			pgd = (pgd_t *)page_address(page) + pgd_index(addr);
+			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(addr);
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
 			spin_lock(pgt_lock);
 
 			if (!pgd_none(*pgd_ref) && !pgd_none(*pgd))
-- 
2.54.0


