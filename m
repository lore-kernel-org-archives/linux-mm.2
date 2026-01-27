Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D43B6D19511
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 00:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DED6B008A; Mon, 26 Jan 2026 19:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809026B008C; Mon, 26 Jan 2026 19:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701916B0092; Mon, 26 Jan 2026 19:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54E156B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:51:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 031F0C2E11
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:57 +0000 (UTC)
X-FDA: 84375916716.16.82A6DCC
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2945980012
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:51:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RoBcAN5z;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769475116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dIALzjMANHxaf1mWstxpf4ZGCuW9se4Hc0gswmnGDw=;
	b=RF469Fd3hhfzxbo/DHuB606A27HTyugVD1Hh0ot7Fwt63rWWPqh8hUWTjBImUKk5oKUn8s
	VlyZQH6Epy4SUQIu0VAMh/WE0Wu8SC38KFKf1hRmaqu1zlJ3YvwQAuND284jVc+NsC14gT
	dO8qtyeWWapa13R+VStEe05vcz4re9w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RoBcAN5z;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769475116; a=rsa-sha256;
	cv=none;
	b=gplwZ2oKIRksx+IRC4aejv3QNleX6IsH5cYLUNgFOrF8eA84IRfyz/QKbwIkaZ+NBma990
	D3Pn+uoPYT3o2fMZtLegcH48vrHcXe1+kRzmW2TyUNksdLaasThejmZ4oqBFWtbBWimF1h
	LqOSuQq6VKqYfAvB6UkNrQfU+lMgEbQ=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12460a7caa2so7295635c88.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769475115; x=1770079915; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dIALzjMANHxaf1mWstxpf4ZGCuW9se4Hc0gswmnGDw=;
        b=RoBcAN5zCCUmsHxUMmATwr1mnZf5tADYPNBHfOkbZ+YZZMCiJAg1OrGSN7PqpzAst5
         xadtlYQwQ2yUaTQO4Bm5u7Cfzx/6Q7vLAq30DKa+e5JjbANcGS+qsa7BNL5gicNorPoi
         p7C8BAXi5O+ad2DCFwI68GT29zbE7RHkWVNlUM3VlGWuYZZiIm7j5qoBezVax41D19Lc
         aLpXBH4OYbVtkiUTGuPP6q3TK3LEIvPjjhdWsJ7B+QvUcy98qs7UK2lKmpgDcohervR1
         SuOqSH3l8EYjDKhHe1xXYb0GsxQZp8KZTJiNaAmOluQrSq6WLUqP1voXSJqrgkxtkzGs
         qUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769475115; x=1770079915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3dIALzjMANHxaf1mWstxpf4ZGCuW9se4Hc0gswmnGDw=;
        b=QfybhjWFZICbitlFcIJFXwxkFbeK9pH1QZ5J49FjjIAS5mdCg3uyk82MuQAH7o9X3C
         fPReMnXwisVAubJIhQbomlf5XAC7ashOB0S8eWzeb0L3Fz026YRlrYn+18OtOFRWTmlZ
         9V1X+z4mL4FbXZbF6xkkUwxIOsRKdj/tFRlecN/FqUFMbGucETWkEjd5ZCPFBQQYWdZ8
         BLod0vZJ/ERIXOhzI16RSaA5YOyW9x3H97jl/eq10MiXct8Pp1MuIzjlwF1PLKDGVXHb
         9eQjLL14MtPIUe6/L2WIdmD0VNx3ltfaUZ1Na0bkb5YVlwKLNzAVb7bg9cz5V//OpBgy
         tX5g==
X-Forwarded-Encrypted: i=1; AJvYcCVab0FjQEEVF4RCyzP22Sr8iLLTmQlhsa2FJccSrxzhH/IzH/wVhjqT9oeZdqCeOTIiKunWyz8jJw==@kvack.org
X-Gm-Message-State: AOJu0Yy0zWbX8j5OfqaEqq2ru1aaSsd6xW287+LrxxM2FW1sQIEPN7JJ
	5bkije/iIl66zuNOTEtAZU3MwBCwAUZ4Ogo/2EWCAXglEN8NQGP12tvG
X-Gm-Gg: AZuq6aKBV6B6b8cSOe/5oQie6obIUyHQVA1G7ORc3tpMwbAu/2mU4pfd3HK7imZERu0
	OVZ+vmjAyu0q4Q6kXuxQ7haaZVPBGXL4ooBttDsCBcKOGJyy/DeDAAk03u0pmyKe4pYsOVXSOqR
	BwRYYkoDDEDVorCtR0ODHIiKD1ELHYHT42wtMYVsINRw30jAE9zG61YulQ4VGmkX9iBua75dSmU
	ZEmL40mKcuuFlvvvVzSTMq9xCovyMQu3/Ri1Sw3hqI1OnrcZ8KV2k5JuOY2mwOhCP3m5OH8Z+qa
	DwVbAmKcPfvDsPXASofK6ptmexBrJzFK91lZMnJcXcXlblUrEkHeMW8rX6MH54k7iwxbkfb0g76
	/MrRLO62TsAMsqR6EIt39/fb8KP1tKMAP7blfti+y5nDEVcvcCFVOkBwHhZgT0fw4aPTdgFNtyv
	N5cGqgf8lKsXaaxMK5CAUPNc+6SyJUDortTsfTQSyt4O0=
X-Received: by 2002:a05:7022:f102:b0:123:3103:b248 with SMTP id a92af1059eb24-124a005f5afmr4527c88.5.1769475114897;
        Mon, 26 Jan 2026 16:51:54 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-1247d91b9e1sm22185065c88.5.2026.01.26.16.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 16:51:54 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 2/3] x86/mm/pat: Convert pmd code to use ptdescs
Date: Mon, 26 Jan 2026 16:51:39 -0800
Message-ID: <20260127005140.197847-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260127005140.197847-1-vishal.moola@gmail.com>
References: <20260127005140.197847-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2945980012
X-Stat-Signature: cxigfwau9qm9xgrfzmr1nrfenp79zh81
X-Rspam-User: 
X-HE-Tag: 1769475115-810285
X-HE-Meta: U2FsdGVkX1/QsYTuXdHv9xVHn0HjYEYeyAPwkil+k6CQemPim/Eknk70i169Hf8NK4TJXmehBnPONlRC3EYx678pcMbDH5D6hw6kkeLVvwqHhYllzaKVrvlw/Uguew4rfPbz7lp8s4R1SeKVQjhch6XRLtZA2kYAx8K4dtbFN4+O0/KuPFz2twYtXgXAnvgmMJZ7dw0wiHs44IsiZDRIfdYliI8MpDBm/uLibPc0SldGAWq3rytlv6XYhZUUNi63o/RU7uZ8sKZxu15D/svc2zgAM3AK6ThP9F+nHcUUHgSOFZru55gaqJsQ6ct8IFkFnxIMRaaPLZp44efSRWenQImP6MsVusuKP0Tvda3pjRWmZvhSEbz9Bj/5rSYt0F9Zrg6zZrMoDjyWWIaOX4AMP2xHKkz+54bBarWAbGT/TWW+UortsQIcTFsL6JfymOkQk4BT+DA3aY6dE6Ey01Sa96tx1gs2d01PIUM/GeV/ISb+A8VV1lp0sP/ffDTVFj8wyFbWhZi3V77WXLw2/zEocfpldGN7StMgv0/KaeuBJ+5/qTqumxBCJLEjTvLU/r1PG1ed1qX8Z8VamctixPnSCwJDDhFc9Jap9tdZ2Leozu+Jdqcu/Q05dWFyxgANXGGSSfXR4d3BHlFd0ffur992mM5gGmrxFOysxre1/TV3++UCIGiyPoxTHijdeFEAZB/6DtJVX1YmW4+Jyrf+8lCcycNXvHf3enToBJYJ0hyGml5deCA/75Qdmiqmk2cfWLWXwrI4ifiNdC7JieuklYR2eNNxhlECv52fEbrdaGDU0f8p6X68pORFkr3jS/9dm0e4UWPnbbes5K1t8tdklBN9tguTo0tVq/LdSpUEWRgJ5jYg9r70oi4O5WC/Aqzgt3E3fnmb3XbQeng+nPMrJpxb7P2/uOMkVIJWDFmR7yhVOEE1SAkzs3w2f1b++V7VuTWGGkehyDw9oGVlvVoo5sv
 23Iuu89P
 T5d+dJK6il9wxOkYOcjcZ7Y66ZyoK/B2Qy5lrR8vLEDKAm0GKZAzxxE48SaP6Bc3KUSSSjUznzCnNzYJWcoigGOwaPzUcI6N2+tiZtwW6fG0si9iB0Jh2H9ar717UY1KrzdH+Hql8NRXjq6yajVCvt+7leiDp2coUzGkthlQfzqrALgTx1zXa8scEqRcONqIJv1oJdL6emED25pNYeEW28uMHTLx3uCRSxTY2E/a6YBgEiDLxybXg2t3h/Q7ZUSdrN6jbsghLUBfSMaq28VFY3UcrV52uwZK2kQKcSxAHRQrh0cXOUvQ3LpfzbXiVbQJ83jX9eDWbnEccMvgLJNwVmZasbr64xEIUsVKjFREWHWB99U+9m+yXU58yZvK0fhYVT4t7tQPpt2ytsqNowty1MlGOgArxLy5z/vZ+sfYAMm7hHSrXBvr9cUza3MnFGwjhUnDZ6rpDUWn0UbM0yz0HJUQPvCBeBD3VQVcGI3ANMOi2Sbf0cZJz9zrQVWVYo3nFri68
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to separately allocate ptdescs from pages, we need all allocation
and free sites to use the appropriate functions. Convert these pmd
allocation/free sites to use ptdescs.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 2dcb565d8f9b..ded1ba11c68f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1420,7 +1420,7 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 		if (!pmd_none(pmd[i]))
 			return false;
 
-	free_page((unsigned long)pmd);
+	pagetable_free(virt_to_ptdesc((void *)pmd));
 	return true;
 }
 
@@ -1548,9 +1548,10 @@ static int alloc_pte_ptdesc(pmd_t *pmd)
 	return 0;
 }
 
-static int alloc_pmd_page(pud_t *pud)
+static int alloc_pmd_ptdesc(pud_t *pud)
 {
-	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	pmd_t *pmd = (pmd_t *) ptdesc_address(
+			pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0));
 	if (!pmd)
 		return -1;
 
@@ -1623,7 +1624,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 * We cannot use a 1G page so allocate a PMD page if needed.
 		 */
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		pmd = pmd_offset(pud, start);
@@ -1679,7 +1680,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 		 * Need a PMD page?
 		 */
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		cur_pages = populate_pmd(cpa, start, pre_end, cur_pages,
@@ -1716,7 +1717,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 
 		pud = pud_offset(p4d, start);
 		if (pud_none(*pud))
-			if (alloc_pmd_page(pud))
+			if (alloc_pmd_ptdesc(pud))
 				return -1;
 
 		tmp = populate_pmd(cpa, start, end, cpa->numpages - cur_pages,
-- 
2.52.0


