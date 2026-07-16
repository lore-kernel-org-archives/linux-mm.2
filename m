Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B175AC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F776B0142; Thu, 16 Jul 2026 11:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608BF6B0146; Thu, 16 Jul 2026 11:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E6F26B0144; Thu, 16 Jul 2026 11:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E833E6B0142
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:12:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A762AA0156
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:58 +0000 (UTC)
X-FDA: 84994606956.16.A8E0975
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id BFDCC4000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ADfOhONr;
	spf=pass (imf17.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wO7rgHUMjvOOREbomqim3hRFXtwbnBvZKsCnDiin3lw=;
	b=gZZAe3jYIdCel2Hj882myUmh8q1mb/vwfcaMo6i9ZIv+vHPeNVu3OE2g25mDrTMDCRpAiD
	Q4SCRX/YT53WCop1ekPVDN2JSHRl92prbnAhtMuWb46AQwepLeF45jlRb5vkZ7zaVmKcbs
	LdVgwd9TBoVJO//zDt1uMT9hKp6vhuk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205836;
	b=LzF8jwgbGyOvO8/d7y3gE/nrR7LNMQZ5wzUW9C0r8Janls8gPA49S97R+kRPpn6US/QJmn
	2Dnk2nKsLUOWeeZqnDqRbkWXJfEcQiyQG4Wcr7PZ8WQLxBgCVt3MS4FoVk25cbQFTxtc1Y
	bI9RHWKDePjEED2MD65vAfXTJEGStJE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ADfOhONr;
	spf=pass (imf17.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cabc0a1ab6so75751285ad.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205835; x=1784810635; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wO7rgHUMjvOOREbomqim3hRFXtwbnBvZKsCnDiin3lw=;
        b=ADfOhONrFVLsgHXQCrcJOTXx+g+NN6vm4NLzhLmo2R3jH4VddNjzpyjU8bPC2YtahZ
         xgFXa60C+zA+9d+/Eha2RAVwo0PHjjHvcDBs3OYRj+TJe309PCwHp+6Bp3lAzh3lSpQU
         j+z02HEd35LM1ewo9RkcoRVV2Fhu4sHj+4SZnykVqJotyZ+HLPVZ8AGHNj/0YyZikY30
         QlcHi2IGk65YyK+XVrdWo4Mj42D7WwgytLZ03aHKnWNR+9YE/u4FAeuet0qDDfu2qAD+
         MSX3wwdI7WzWNweXneXQ4PSGL1qC4/4CVfZ2ra8ejtC3Vx2dXzCVE7SY3vYhzUl6a5l0
         GCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205835; x=1784810635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wO7rgHUMjvOOREbomqim3hRFXtwbnBvZKsCnDiin3lw=;
        b=FpqLfcfwuLb8YVL1D4UxHHYZOjVYyFgter5ZSDOIGgUR7jm8hpwAH9ozjs76BjzPgu
         DUd8Ghzpg3KqdQ3aQK7uJWpnl7pj0DiP9TKM5bNJRuiiRj1NsUoMqEJNs8oLbrfmTjG5
         scDe0Zxdgadh82d4RGfehwDQz7iNLP6/zg/dpX0GXFj1O2V3hSesG9aPguNF6ukouQmv
         vrlbjSCznvpAjS7J2cuXxV4cGqwowLa/P1OBv7kfDW9UXKcal8EYpwrw6zFO5hTGOVyc
         yEyUyCNOrLf70tcRwhpV9x7Z+rfyNxA1aKroSkUX/4wgqzh7CdrNC19i8QIy3Yq4pKTo
         MRag==
X-Forwarded-Encrypted: i=1; AHgh+RoJ8Ld1s1oAEiEJwICNykJ72UDh5S8NdWBuc6hJ15JLo/gmstJEJjHzPT0yXkLSN4pF5BtQRZgaIw==@kvack.org
X-Gm-Message-State: AOJu0YxyA1et0v4wTEcKccl2Bo8b5+qmqubX+yJhqIOstRkX3hMy5pUI
	huWrMXPjt2WMsY7Elxe6mr1n70XQ51/Wc8y77aa/d8ubAWXJwlPHGSXapZaFGtu5qH4=
X-Gm-Gg: AfdE7ckR92MbDhBXFENud2ceXHMGzpofUh8pV+Gum86CuXkAlsxk0XoyiLPecZQFhOp
	eKLYvAWbLRBWWiX4Hyxn5QgXS9mHblHmv348eZuYFwL8bTT964A33BJUd5UH98u4iblRNyIDpo7
	JfdZhDwcZAMZD2wirThOP/cYREL3Bor5EE66zRMIvRZ961WhbLVsJVF8BJrYS41DklXDsNT4U6l
	iqgkcvNgxi4jFnUoIG/15CDmRQWHF0PS0+gOoJYkc9X8eLz55b30U9kLhEL8xp33Hdv+hBRBQ6a
	Yu/QuBMMKFvlngDOA3lDTb5V3YVnuP4lbFDYkXweyHeYhnvypKC3PC1lkLBbDqnvi6b12Q6aI+6
	neEEhRolneJm5Nd3s9AiKEMdxc4+37jNQCafuHZWukmn1m8HmxLMND6yGFvKEcUKOXN8T7RWafp
	19UNQxt5NekpqHxFgluawKOjUHt/fr+Pwq4Q==
X-Received: by 2002:a05:6a20:20c3:b0:3c3:859b:c20c with SMTP id adf61e73a8af0-3c3859be277mr3653741637.15.1784205835267;
        Thu, 16 Jul 2026 05:43:55 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.43.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:43:54 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 08/15] riscv/mm: avoid redundant Svnapot A/D aggregation
Date: Thu, 16 Jul 2026 20:41:43 +0800
Message-Id: <66e43057442a0f37e0c7348016ccef382387898d.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFDCC4000B
X-Stat-Signature: hsropquegam7jyo3wk4srn9bfnfy49bs
X-HE-Tag: 1784205836-737776
X-HE-Meta: U2FsdGVkX19/dTiwtNfhnuzrLjdm2sBufdBplDZbGuEF6meisD7/NrWhFMV5wbLaYcIFPV7iBzUAUMAQRgkOa2cDZc/GBT2mn2NJtcK8YGR1s7/BoFQdY/2bbfuqvdn7CKEKTILpsMLiofUIi2HkbvsEs58jtX2eGjZNhzf9ax9vxBk8+gdWiwBOzg/Bfw9Y1voXMsHcWojKNdinfm392AAVNTZu0J9SBQZ9Y8YDptO9+JTvto6VMM5eD44N1zWhFRH4Vm4+rC+gnS6yij0HhN7LSWa1W4eLzur0AgeBjDzH06jcs7hCFmZJieDH4eTMDMriniL+7/WaEASU6PxE7TzrHNi675OaVxx2f52BQni2/FRVEBoqABIt7zC8TE610KrQSXQA/ZbEJEDnIqx8SxueOIf6BN9y3DLow38yZS+BtIdLTrnLeAVZ8P2i6/Lheu6eRhHhv7ORyB94nmAC0TiQhy9NTTgwiQselOX6JEVwarn3MeQ2rWmDPcPiLT7SIcURcunzYmu2eM/KJOGsH+do91bOHIikADjXLlybBB5EShffMDCwJzCamMUgSNuDEDp3kvNf0o9zN7pEBgTs7v6ExOvnV3Brm5CnjDpgHq5gkolHOVG9nK6GdxUP5NgvDzp9u/+QZOiJXOOE8hNdlyZXlbLofw3gVnhIuUd5wKJGQIJHwuZpw8UEW37URovXmj6VmPqh9GrsUeIlz6U5Bl9jutBr/H1VEnpZG4PIqQaMA1+S8SaDkwF0nM/ZPiRC4bv/2BrD/g3F2NJklGZjtOOGtfGPNHvYjhAjt9P+0JIi+IW0WnzSWeEVdDlvXyFQcCszOBtmiEQ0CtPlAmOf8cdcUGqVzJb0JLxCp1AP5L0eZPA0Hrows/2OGTKEtzxqQLpD6XFyUWDI+JFBjiToQ2J/qg935W7f7LkccVhXc2G10tDFAIxfoyfyfYK6HAMn5s05t8kyHE8a2SFQBxW
 iDLrrSLi
 KFig94D3pbCMhQL1A7Bkvxt2lZG33Kj3YQufbLP7+V4QvCX/HNsBt7wUJ314sxHgM//COgKOpoS4K2layoajmvKwB30Ez1DpVOhqfhO9q4JChOebiofbAkgmffqZVwdesD1n3/wr15JEiDBRW/t9V5EAE1OQsdXGPZpMIhq2amA70awDT5j0GyvhR7V9OOJ2BKlTCru5slA/evTEs77p3WUcdemihqD5UCUERjga0Fw91grdRgMUrPmp4RpZdKvLx5R+5CeJ+hN5a6D/KagAA3WF1/9TLOegADtX3YmJDztehi2V59wDPiMXpcdo3UQ812v4U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Svnapot mappings encode a 64KB range as a NAPOT PTE block, while the
public getter returns a logical base-page PTE. To preserve that PTE view,
the getter folds accessed and dirty information from the whole NAPOT block
into the returned PTE.

This aggregation is an OR-style operation. Once the returned PTE has both
accessed and dirty state set, later entries in the block cannot change the
result. Avoid reading the rest of the block in that case.

The lockless getter still validates each entry before consuming its A/D
state, so it preserves the self-consistent range requirement while also
avoiding reads that cannot affect the returned PTE.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/mm/contpte.c | 60 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index 9ffdffdc2b0c0..70f9a0668b50c 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -309,10 +309,34 @@ pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
 		cur = READ_ONCE(start[i]);
 		if (!napotpte_is_consistent(cur, orig_pte))
 			return napotpte_subpte(ptep, orig_pte);
-		if (pte_dirty(cur))
+		if (pte_dirty(cur)) {
 			pte = riscv_pte_mkhwdirty(pte);
-		if (pte_young(cur))
+			for (; i < nr; i++) {
+				cur = READ_ONCE(start[i]);
+				if (!napotpte_is_consistent(cur, orig_pte))
+					return napotpte_subpte(ptep, orig_pte);
+				if (pte_young(cur)) {
+					pte = pte_mkyoung(pte);
+					break;
+				}
+			}
+			break;
+		}
+
+		if (pte_young(cur)) {
 			pte = pte_mkyoung(pte);
+			i++;
+			for (; i < nr; i++) {
+				cur = READ_ONCE(start[i]);
+				if (!napotpte_is_consistent(cur, orig_pte))
+					return napotpte_subpte(ptep, orig_pte);
+				if (pte_dirty(cur)) {
+					pte = riscv_pte_mkhwdirty(pte);
+					break;
+				}
+			}
+			break;
+		}
 	}
 
 	return napotpte_subpte(ptep, pte);
@@ -343,11 +367,39 @@ pte_t napotpte_ptep_get_lockless(pte_t *orig_ptep)
 		if (!napotpte_is_consistent(pte, orig_pte))
 			goto retry;
 
-		if (pte_dirty(pte))
+		if (pte_dirty(pte)) {
 			orig_pte = riscv_pte_mkhwdirty(orig_pte);
+			for (; i < nr; i++, ptep++) {
+				pte = READ_ONCE(*ptep);
+
+				if (!napotpte_is_consistent(pte, orig_pte))
+					goto retry;
 
-		if (pte_young(pte))
+				if (pte_young(pte)) {
+					orig_pte = pte_mkyoung(orig_pte);
+					break;
+				}
+			}
+			break;
+		}
+
+		if (pte_young(pte)) {
 			orig_pte = pte_mkyoung(orig_pte);
+			i++;
+			ptep++;
+			for (; i < nr; i++, ptep++) {
+				pte = READ_ONCE(*ptep);
+
+				if (!napotpte_is_consistent(pte, orig_pte))
+					goto retry;
+
+				if (pte_dirty(pte)) {
+					orig_pte = riscv_pte_mkhwdirty(orig_pte);
+					break;
+				}
+			}
+			break;
+		}
 	}
 
 	return napotpte_subpte(orig_ptep, orig_pte);
-- 
2.39.5


