Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3146AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038DF6B00EA; Mon, 29 Jun 2026 14:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010386B00EB; Mon, 29 Jun 2026 14:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1AE46B00EC; Mon, 29 Jun 2026 14:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1FE26B00EA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:59:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EAF48B6CA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:02 +0000 (UTC)
X-FDA: 84933862524.12.5AAB44B
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 556F6A000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:59:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qlLAnspI;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782759540;
	b=ik4Fu+kIEAtaSTQdaisJWq8OLaAXa4nEy6RAVhtl+l9e/Sy9ZoiuJ4agxD0SYnUAwxvxui
	8eyv1akRJJsY2h51J+5V9i3+z2al/B92BXSYsyu2l3fmV32Jj7kRZRG9heu48VGSVgbJvB
	Ci0RH27SXlAF1QbO39KVKXut3fRH0JY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782759540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=001LhG9jRDHFHgxoUSCKNV/Xn5fJVvktzNuLDas4KQc=;
	b=3JVL+ASzVpvbARSMn6sGYF5++u0vrGHNVVLXhJ0GmxqrabdLfmtTsfugQADsb+WJUwGzUw
	rVbWeaAT1mXV5uZg/2P7xELFF426FGMSZwjkFDrpRuQZetzBOqaXzT5PGPqMRyisVxaXVV
	6a8be9c8ay2MAbStOgHdfgY3n+sc73E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qlLAnspI;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8475eca3a66so1467566b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759539; x=1783364339; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=001LhG9jRDHFHgxoUSCKNV/Xn5fJVvktzNuLDas4KQc=;
        b=qlLAnspImMictaHXp+C6KIqVuIsoucSng24Jc2TlROW7IbVDQF3kQ6Lt/6lJ3pZvyZ
         i+edIJyjaQr/gw2SXm+uMXvrXBvBe4cqCFgnO1VY8QFM2NuimJ7YAJ2DBsH5eaqDMKAe
         GIz9Rw1T6DDIYVj1ralW3oprNwSNSACxSIdUGwYQl/bm3hSD9LgayEDH+3bYjU8AfQvG
         I53VOWWFCeNbKUH9+sLrKosNvAaXtx98HSETJv3q5FVNztQ/1yf938FXPrEdQrQ2U6PP
         j4Y54G6MuzEbPfvrV0quey18uZcY8c4c4y/GCkY2raLy85DIDywjFR9ArwsundHgfqMD
         9q9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759539; x=1783364339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=001LhG9jRDHFHgxoUSCKNV/Xn5fJVvktzNuLDas4KQc=;
        b=E9v9L/MC8fmPszqqmI1Oh/3xDi9azQ521IpyX5z1khjhtGKWg35IK2BRYeXuTfbZTQ
         WgLzz3KISQmIkXTEBm0X1HRpRoCJc6E9IDqjKN2C/A06D4pKMsqQVYEIsJ8ckGqkUmjn
         e8c8B25RUulXrahZQSQM6mAEdhcp49CxbgBQWuVZzVW9jhTa3kgwxmIckAOYd+rzOBtB
         E/L8PmaPKbcL5C93E/3glXph/EXTY4jXTSLvwnpy7PUtB8cmOTpV5QCYFITjJ/oatrPP
         nBptMSH+2llTKsehxMALc8Uz1rwfufHRolcwD7qPaFWtMR+8PqXCXzEp55+eBLkeDSfe
         k+cw==
X-Forwarded-Encrypted: i=1; AFNElJ8m4LMz+74Mdq5/hHy22aEHM99aXFZ51nzQ3kMJ/SANyeGN5uauPgItZxNTLvZWq9Fuf6l0B1Vcrg==@kvack.org
X-Gm-Message-State: AOJu0YwxMxBKM0YM6Oo1FzP5aTDOFz087p7tHyWYBvbdXpQHtTqbIunR
	AWeo+NZAW48PMlhMp59Zge7I7HHUndI9dS9FrFzAwTmkAHve3N781kzT
X-Gm-Gg: AfdE7cn0cz89yu2WQjhhgJLEJeWY8T6zjOTIj6EC0d/VoXFEhu9ce89th6ouSjMB1Am
	FRyuUg6dlNKkBIu1zPMRoLQe6pPTCxkGCtz8qBearnjelZV5taxN05d+L9Y/3fc8/R5AponXPNq
	57aIk/8BS+6U7+3MVc46HqUY795oESn8vUsKQp4Hq0vjuescLYee4JebW/UcVW3b3DFtVOMdspO
	BYQhCoMLVLgiLsOPhrsrtp2i5LGO4GQiVF1zYjiLMiPd72Vk86blWN9HjFZR9VRTbZG1Iry/9xC
	4EX921M9WQIy9fvngDxOc9qt/VKHHuXOGfgD6vY33dqMie6r++E0A0hkVRYo1tkW9bMbmI8m0E9
	tFxgC47T1wAG0jKvelE7JelNwYzfZsAvd8vxtITzk2CVZ85Ig2tLcxXQF9Fkyt3GTWNZ8WtEbEb
	vs+YwfNQ/61LCI5nSgArArOFbVur/VbfGEwie3JpcEzrxphzIWfL//VLgyQpkj3IdZeKwOt1Y=
X-Received: by 2002:a05:6a00:885:b0:847:8b11:5966 with SMTP id d2e1a72fcca58-8479eeb687dmr466155b3a.1.1782759539361;
        Mon, 29 Jun 2026 11:58:59 -0700 (PDT)
Received: from fedora.hsd1.ca.comcast.net ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-8479ff8f959sm223955b3a.3.2026.06.29.11.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 11:58:58 -0700 (PDT)
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
Subject: [PATCH v2 3/9] x86/mm/pat: Convert collapse_pmd_page() to ptdescs
Date: Mon, 29 Jun 2026 11:57:36 -0700
Message-ID: <20260629185742.126987-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629185742.126987-1-vishal.moola@gmail.com>
References: <20260629185742.126987-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s67ihcd1muqwgn8pnpff871bnunnfmkj
X-Rspam-User: 
X-Rspamd-Queue-Id: 556F6A000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1782759540-33383
X-HE-Meta: U2FsdGVkX1+FNP/hzJ19+sdOqWmng03ERcgv6NrLhyWZ0KbBhd0N5PlBX7UJgG/nEXP+crJKkuywIS4Qkjai9aKMUGFiZRHIuLg2yLzWtjsNHxlwMsDw+HxCsRhxI8Jr8Ie83WQ4N0jxGWrRxttRjhBQOwNr6xvC85h4ujK+NV9nb74Vssx7Rv5YAGe10D+ajZmtLYIqhlME8R+v7InEJOI4n7Aj765T8HhZ6lhD4sDzV1wodRHzLRuso6TYHsQTz3506eZWXTygLF4BsTKchfUpfKQcirf/eMQkPiElZgGfU7tsba33Uc8SSQMgJwanzTeZ/kJ+hXQVezBIMh+y55fyJIr7Kn1NwpZSNsTBtcSkYaZcWkPavKVxV5xIsIfRrvl3dqyErSzJlJBdebCD/C4bJSZmPgUrgmgmNhKI/3RR5+4pvgu3lagCKNwkEQPuRMEj68RLWDbqzLlRKHpppF8sWbnNkk8AjES9xMIBN1DafQg/QCxb49SIKilqTA7FGMrsWpKqzaVVyg9mKpsm3kDq3FXvBenQ+rmRi4uIqmXh/7yDw4shZMU8SUO9MTumVulxObEUwtl7V704Ilj51JzcRWQ38WA0JeNqrNUQ+A+jdebeBw04kLbi+dvICeoahEFgOf7DK/9kqyweaJ5B/ZpOa3B/ogZhKzeAvx0qG+Nuku+PQoqxPn9oxBdIwYjRyr+Ek0eEdOWRKgYODiXAKSrsaVUdLqGRV1Hu8ltsbh3PCGaRB09x87HvIqhsTpUpoBUWWndCowIpcY08DVtXDT6tIJ8Aj90jpz3lk4PflPN+00GUI8U4z67H4M3qgbaJ2afcUF1RwIY4mLWfzNYIAHH/cdCkmTbLs/rhCihMvuSeBdzwMy47uKEEjsWN2WdHwdjxSN1JGmX+U/YiM1uo8TRRHjUeaHxcFWdUiS/hxVmFdyNH9m5LFphOpnw4SPuo/Zy9lSxYuI3hwSrjqDf
 npgyG0FR
 F6ABuarXSM0QksK5WdB7SlJmow+Wl+MueYwFiwpERLDZ/6YeFZKZ87ixbA2qnGt1wiwJhKcknD3hMiLHTagyIUmtBZATWpFF64FV71D7bCJK3U+dkSx/xnfm8UoR/gWPmo0nUjwkHDjnF1c/t1ZbKjQs1gQfMDC+JSTxRKqe5pti6rIfOKpoFDdtOCjm25cvT8RfNuWBWFN9zzJLmtldHZV4r9vpaUK2G1ySfujceTvXGTcjagMsgSRZIB84AgXVzih1RGhiX3OGFVJE0cXP/kP+RLV4TBD/O+1NCdceBEHI2z/qD2IzcyYYktsdpVyw52ze/eCpEhD9jJNebEpNB/+7aS1apMCbuwcd7XzEFeLuZaqNSC0gxSFDGuE4Ie9S4gqpV1oJ5mwKAGGfAbzJu9kRJZ7S8vlwtFEoKjbvuvd3YLWO7AyubjfhCxeQXuDqtZufJvFMNDCm6FFHtD3j1arImmNdhbdPXRrcVKXlBRul7p4S7TUJ+djeiWtW0JimSQEPnPtkRZdWeKmWd//Y5coSCQHyEDqaQlt38
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert collapse_pmd_page() to ptdescs in preparation for the
eventual splitting of ptdescs from struct page.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: William Kucharski <william.kucharski@linux.dev>
Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 93cb71451ce2..45623d4c24c9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1297,11 +1297,11 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 	list_add(&page_ptdesc(pmd_page(old_pmd))->pt_list, pgtables);
 
 	if (IS_ENABLED(CONFIG_X86_32)) {
-		struct page *page;
+		struct ptdesc *ptdesc;
 
 		/* Update all PGD tables to use the same large page */
-		list_for_each_entry(page, &pgd_list, lru) {
-			pgd_t *pgd = (pgd_t *)page_address(page) + pgd_index(addr);
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
+			pgd_t *pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(addr);
 			p4d_t *p4d = p4d_offset(pgd, addr);
 			pud_t *pud = pud_offset(p4d, addr);
 			pmd_t *pmd = pmd_offset(pud, addr);
-- 
2.54.0


