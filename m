Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C910C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791496B0088; Tue, 11 Aug 2026 12:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742D16B00A0; Tue, 11 Aug 2026 12:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658236B00A1; Tue, 11 Aug 2026 12:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 36F636B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:20:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0268C04BF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:38 +0000 (UTC)
X-FDA: 85089501756.14.3D59C78
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id CC492180003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iYUXNLfV;
	spf=pass (imf24.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JhsBT4JbHu8Y1LpjWeHwh/rrcED1LfRchkAqH5o+sQ=;
	b=2G+9E52o8/+Si46o+0gLFewB2H/li/kW2vOtjFP3O3BCSxKVzeyLDJOPZ0pW3LBWnWnEWa
	dTrvRsfQ0BIseI1R/JoGpZwu6P4YKAMsWkTfLxahbvzQdL6H+bRjj5z+5t5RnDfVT7BHhp
	cSITgI2NjoQsqHjHbNsr1iJmcyw6vcY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iYUXNLfV;
	spf=pass (imf24.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465236;
	b=H7ipMMSUkFplVCIJo4ZHtIcDVGv2GY3XblhMPoOPPmOPUVY/m+bV3kTFt1e+5yaWmVieym
	eVIMK7CQCWCrZLXBf/G2+xgppDQ0zQ12pZciFRkqsPseGAnpj6hxB2N5a9APzsYYRBllNn
	iC3ApGsqvN/Ay92roDvhyJGlgCf4NfE=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cace91f112so1722535ad.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786465236; x=1787070036; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9JhsBT4JbHu8Y1LpjWeHwh/rrcED1LfRchkAqH5o+sQ=;
        b=iYUXNLfVRXFrgJXeq+4I4ZEvnFkc1VCoPqpXRCl4W43xGG3k6E8Z3n5oTrsWQSz1Nf
         C2qs8h8Cav8O/5xRC9kc2SuFyle0Qu/4aqCNZwMoFD4KXzsWj9F1UdfiqLklUvnTgClI
         mBLBNirSQXpwaMYaE0cRF+hutr7FWa0UcKaDtn/oMIJTv+N4za9nqdiSXRwltJnK+rL7
         EYcPWy3CbXHzunj3MEOk9omIZMcjs6Gj/V2qA1xnl3gE6bqBRvEsMvrBjrOdB+u7jqHD
         rfc0tYYz/5HCy6/DVB7FmWZUn43xPM31knS/BFFyejj/Jw+mQyd2DlBfrVNYNmLnfD33
         ESoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786465236; x=1787070036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9JhsBT4JbHu8Y1LpjWeHwh/rrcED1LfRchkAqH5o+sQ=;
        b=Qr5kno62Zm4XmIJz2BV5Aen+P0h41RCKUnf18aw7j3vvt++4wuDOH3DCnbSBTfA0sh
         jid6eXCuxVDNn5cIozE+yP+vkAcE7Mlp5qnVEF8t5jl1QUxkXxfJD38szP153LahjkAc
         +yH1THX/FymT4s8Ahf/eOtH/mCzAn3/gnkVdUn/hb2pPQDOXZY/lDN8IbyFJS6vlViUe
         CFjqjjmX1i6bfvRqFl60HGYjqwJvDr4iIySPt5/PmrxIwxLCwTlr0jmsGA/zAqN2e4xm
         12WVthi3q/HD8Cz6QwFri1mKeo9AA1oiBQfeVFZZ/ZV2l4eTdlphU0AL1u8kbp354Ipg
         tgVg==
X-Gm-Message-State: AOJu0YwRd2m6DS/nQu8D/tzEJysQBMFHPqhoJFEn5P4/kkM7CSB67oAf
	uyq3RbvInlUiP+g7fo0VuHsWJyZPZffP9uk1oZZ1qWuVObIMhPHRXJmU
X-Gm-Gg: AR+sD13jtd0+scaqAlmxMQrFYVfr/h+nzCdYHlo1TKfcaIeVQbb6KcTMFOmeAwekXiR
	ecAWKNAfilgxY/RvOWp54oLU761W3bbb3yzUN48Rf9It4sa5oFvAkD/7Ue5EgZ+MNO3O7Ntvcs5
	6eMDopgQoOp78pph0iZPcsD3XbZ8HohsokicWmaKpIFPZEokrLuMsgxinWIzY3fjiHXIioc3DWy
	igrTVO4ijLg2ngTkL+d+72E1PKvftUd8LebF+GAK4j+vgsBio71W5tmoodEY2GSZdXbySztstvI
	Xy+b7/otiiTTDum5JDaUkJVp4XNEAKdYbPe8oEce43dFunUFefST9+0asxAfctgbPOiVCi6IWl3
	KpC2Qi7nk7l1kyR8TF43m1UW6GN8GVlgM+LCcpuYeNrvQXIQWRPiHxBSbRR7Aq0avuJkGr/VtbZ
	kZDyue6gCl5OMbmeFtmF1RxIs0LskRJWcJN/VT20pW9Ru606LnTHQaP3qWxAWHSav5vXXT8hsoQ
	Q0uc3+NtQ0=
X-Received: by 2002:a17:903:1ac3:b0:2c9:b8b7:5d27 with SMTP id d9443c01a7336-2d317776218mr62738265ad.1.1786465235483;
        Tue, 11 Aug 2026 09:20:35 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315f30027sm10547465ad.25.2026.08.11.09.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 09:20:35 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	imv4bel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/pagewalk: fix stale walk->action escaping walk_pmd_range()
Date: Wed, 12 Aug 2026 01:18:57 +0900
Message-ID: <20260811161949.3879321-2-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811161949.3879321-1-imv4bel@gmail.com>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gsx7i7pdt94bqqycqgs3rtiptd3itdse
X-Rspamd-Queue-Id: CC492180003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786465236-230022
X-HE-Meta: U2FsdGVkX18/AxvrH2dzFcR/oOxP0UAU3uB7j0uZc95aUeHBXflvEDB4rnjbqFWeta3DBqWbh/tJDpvBRC3FrP4bzw61YsGO5HHdFAIbkC1gxfCUEZN4sfsytbzciFyFo1if2UewUh2TmAIITVgLnQU93kxhHFBnkFbtymSdtCiDTIxPwsemaApF8tWNPlS4A/m2CUWYREt+vKVg2YLuPfW9UAIj91JFCtrs++APV3SZaV5hvhWJch2klkWAmow0+z+ZzQAz6MjfW9j33bXOkDMHxjQgeBokP9fojJKhRfyYsnusQubnDHBvbnVmW/m9/9mzMSfEw39ipVf2ZWODoEbrA9oHJTHc8hmgeoTSA5JAuxfgfEVb20O2Rgb28hg9hSBZUGLHt6Pid5Rh+5krkhbRWpYIsCb4OyPqmZd0PulzNwFCFJb4IIuTIV3KRomB7GZAarL+Cb/GH1aTVsoSp+NO04FWo90EyY9cy163S8VNCq0iwRwlGKHcs5LWChJpSUeguCAnFLJjUGdp7f/TFZ7ujRKO/sqoQ9Gu4rzK4xrYz7W7vlPTKHYPvIzulw+9itlgH0fT1mI8MwPlM+yiSrhNG2NthFDbgF0HzBY3IW/UBHZhAV385rn3msJ3RjM/YynuSvb276QELJY+2z8CNXqetO/V8ORC0JcCwr1YmIZ3+OVe9PqJiPIG+Jqj+gyBwY/4qHHvY+Zc6fp5ovu5Jybh1wyFqKnFZaF34gNY3ipvVzb0VTvOuZEh2jLQC16e13lYx5B113XWkS541vyPMbd/P+cXEw1pc8IjpYc8YjjWN8Cmdv46sgemvVxM8OgTwj3sUz7wE2Gh1wa6CNbEub57ayA1LdApzPOBDz3/OOu5HenNTcT9VCSOTxny9+DrE+pV0M5760WP4uqn4malHYLCmU2lQkZwNr9o6Udob6dzJQ2+wanY73z5LBOdCsBQiE+N4Bltvr5ja97Z9BJ
 zrALPeDQ
 QvgWW5ec6Y4xH2vs3PgUZT7uoZFns6IDfrOAxy0VfcpmkBy3HVQGCqQEriDozLztTDD82yNuN1Mxvuw63us498AlVRRDquRxx1x+hLJP3WQl32jYWctjdDoSI5BftoEFtG+mEHV9XeK2uiPeOA8umzJiTp7eJ2HmUNzpoYNuqn5s5toJDWXfr13DXNa9iKmMoEGArKUzC0j6J12Bw/fYtLb6YTtcze9OvAg+NgiVeXhgvaRkz1mkDyA0bZiY9e4Qk9b+6SsB8171UUJvrKkP0DRYOPsu95zdD0w0Sg3HpKpR8N94HQcOOJDkaMK6MG4tpSo2XnWyV/MUdL1/468LwRcrBSIJgwJp5pBqwDUYG3Ia3wWEsvDKoeXKJHqtZxYN0Fq/jWabchRODU5slGb0y1qBL8+WV0l32lkPsrT4O7YGW6SGhLUywC2k9o4kTetxEwMG69RgsEU1tXGaPiG150Y0X6Ow0yHG051pcavkp6cTKG8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If ->pmd_entry() sets walk->action = ACTION_AGAIN, the pmd_none()
check is retried. The PMD entry may be cleared at the point of retry.

In this case, if walk->ops->install_pte is not specified, the code
continues to the next PMD entry in the range without resetting
walk->action to ACTION_SUBTREE.

This leaves walk->action erroneously set to ACTION_AGAIN, which is
incorrect.

This was incorrect but not problematic up until commit 3b89863c3fa4
("mm/pagewalk: fix race between concurrent split and refault")
which updated walk_pud_range() to check for walk->action ==
ACTION_AGAIN upon walk_pmd_range()'s return, causing the PUD walk
to be retried.

In this case this results in duplicate walk callbacks being
invoked, which is erroneous and will break any caller that is not
idempotent with respect to this (and waste time for those which
are).

A specific example of this breaking things is mincore which walks
an internal cursor data structure a byte at a time on assumption
that page table entry callbacks are called only once for each
entry.

Fix the problem by resetting walk->action to ACTION_SUBTREE prior
to the none check.

The pattern also exists in walk_pud_range() so fix it there too.

This issue was found through AI-based fuzzing.

Fixes: 3b89863c3fa4 ("mm/pagewalk: fix race between concurrent split and refault")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 mm/pagewalk.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 5d87c632a25507..d3bfece3193366 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -126,6 +126,7 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	pmd = pmd_offset(pud, addr);
 	do {
 again:
+		walk->action = ACTION_SUBTREE;
 		next = pmd_addr_end(addr, end);
 		if (pmd_none(*pmd)) {
 			if (has_install)
@@ -138,8 +139,6 @@ static int walk_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		walk->action = ACTION_SUBTREE;
-
 		/*
 		 * This implies that each ->pmd_entry() handler
 		 * needs to know about pmd_trans_huge() pmds
@@ -196,6 +195,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 	pud = pud_offset(p4d, addr);
 	do {
  again:
+		walk->action = ACTION_SUBTREE;
 		next = pud_addr_end(addr, end);
 		if (pud_none(*pud)) {
 			if (has_install)
@@ -208,8 +208,6 @@ static int walk_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 				continue;
 		}
 
-		walk->action = ACTION_SUBTREE;
-
 		if (ops->pud_entry)
 			err = ops->pud_entry(pud, addr, next, walk);
 		if (err)
-- 
2.43.0


