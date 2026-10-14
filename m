Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B28CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E3E6B009E; Wed, 14 Oct 2026 14:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF5A6B009F; Wed, 14 Oct 2026 14:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30BF36B00A0; Wed, 14 Oct 2026 14:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0928E6B009E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F2A8140749
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:36 +0000 (UTC)
X-FDA: 85322072472.24.C36B3A3
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8FB6E140003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TINF+nKx;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002634;
	b=M2qAR4Np+lUtCRpPmqnFqk7XeAYpmoIaXec3ATctCCxDB0Vq2Lakq04bjejWq2zu6rjsCg
	A29ZAM/M7cWwkfDW8K5Q8ELytVZXRMu4rWcHtxIIaRNUqtyy6Rm4mRQ8pPav7sXUDd6emF
	VUIzK8vzPvaILJmruZJNlslTQfpFTKA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TINF+nKx;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnT5ptqor5qmMMV7Ow2caqqAnK7B10eCBBMNhfxBzB8=;
	b=y3UCTtKyxnQwI1BsIzPBnRXXR8szRqnVorGH75+K3at1uJtWG5QWr9nRNm9kJsWMAD70Yk
	zk4kHYivyfo3y4Kwjdu/wTbZZ4OHNlgHSdxCBLJIqKtdk8HWhd6ETrvgMLzuE2bQqaNG+l
	7kAvylDPNmeSgsBfC03vtMA02nYodtA=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f079a63b8so65343085a.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002634; x=1792607434; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vnT5ptqor5qmMMV7Ow2caqqAnK7B10eCBBMNhfxBzB8=;
        b=TINF+nKxTFZ7hLqcUza4a6Nl3jEdFzskXlG76Ubcsat3ZQ200qP0QmhHda35jyWrvR
         dmftYs+a8Jqrw1Xf9vxV7rVAtHYpubPZNvRBI/PnwcWUHZHq4yqYFzw/Z1Vidj5RMo3y
         Cf04fiAslTxVUaIojSBm0u2Q300oz8Z13QC3IvKBgNmkkHWLmPlfFnyvS+9JBnG/2EKW
         pNPkqe2swg47aKco5K4QqYFEk1pSQXayITjCHZJKmW3uMJyFd5DohynIzTX/Fhi2FYut
         XYAyIX9UeRO4eF1kRce7ITLIZaLZwXvNAp0ckDXllGaCQKhHdAHwzpjT7XwzLB3f0tTq
         SsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002634; x=1792607434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vnT5ptqor5qmMMV7Ow2caqqAnK7B10eCBBMNhfxBzB8=;
        b=ihLKEOeiIA+SAqu5G0nu0l0hVYgb8g4MEePsafzDpPHkA4JYWY0DJAw3jL8N+YixQO
         LAoY40DnFuHTAmDLYTVdvWt0uwJMqWUFZYlB2Y4Qt+n34kUGj2KX5xJCLuwb1zB4XwD1
         qtCOVOa7CK9yemazSCoXYw7aJfPrp6X6/Ezbmtbg6DKFpc98y7daz9L4WX/3mJ8XUnLb
         0OlUqBnfgCLr48glkXpJBBbttnEjXsG1fQHZfmf/hgzBzJxLvKrXlATduTD/jnxjIxNB
         HgBjxRXzhyKhK9FUSSgKNfxko9W98mo2XrHoa8Wa0ttHbi8379QsGe7yZj3bvpo5wIV8
         13mA==
X-Gm-Message-State: AFq9FYIUHhUSWDaGDMZ/e0xoRLOLHellJBeEwyLA34swmxWVT9haznA9
	Z16mO6jN7BSkb/HgEHelCicQ8V+VZ2t98OgUB1IAoiWmJFBmRZy9VpUcjmK7mba/6L/IP6Obw6b
	xswSkcM0=
X-Gm-Gg: AYBFou3CpBOepE2nNQRH0aprLaUbpVyw8Aw4ZxofaxEZsvB+7WMv3kTlE92v4hi5j5r
	9Xy6APpuF2HyyDG1bcL9tGfdzLslUqP7IVARIpooJB1g4wUrnkACyL9dTqrCG4sUbgZ2L/a09hC
	g3agIL+M2XpiBzGU5nPXWrUM5SaHhclZzF+mDtR8n/MqMFG52ftrNTRzCTQubfHC5Qcg/KFIaxf
	qZVTi5CZMZBxeqyzB/aGJldsfqQPbldseBEauvh8T4gkIaHduKGJRVOSHATfv0cSsCxEYJshWq/
	jHmIVJAXFCFKkS0A9TP1HLGpaIfBe8RKaUFcH75qYORtZ0SsrEWKGEwQm3lAVwsdplJ2F/gV5YN
	QuVgBSod0HFEfNWCjkb6nxlaNmsW31+qoEqUUg4gBaftaaDm8EKlKzq3+yOJLULB4ZHSyXUPo2t
	rmEJC0x4AUf3Rbu2KJcbynfaXrHNWeX8zro9hgYgEtacjpZOGOTslM+vwRkeqjHF86bFAkLoeRB
	Fl4cgikEQ19Y/sC7zgDC3jo2NgsUSRAU37+FeLfTyelMx7y0bmKZIygq5iy
X-Received: by 2002:a05:620a:1720:b0:93b:d7a3:45cf with SMTP id af79cd13be357-93ebd29005cmr2604633085a.56.1792002633778;
        Wed, 14 Oct 2026 11:30:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:33 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 03/10] mm/madvise: use the PMD softleaf validity helper
Date: Wed, 14 Oct 2026 14:30:17 -0400
Message-ID: <20261014183024.2075709-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3x7r9h78no1eanudwp4h8r5hjoupgjfb
X-Rspamd-Queue-Id: 8FB6E140003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792002634-427247
X-HE-Meta: U2FsdGVkX18L85MAhlipQl1XmzB++Y3NHfz7fgpSCOgo2FoYwghSQp1ZzFCWmrMLn+poWEDwcbfysBOrT+lj73OOeW+QQXboyKesU21lBpjuEnJ9txwX0J8jdaPS4eRK7zaPp4IMdyUYVjbx3Ys/p0zp8ZmVfXVS+OLorRzLBImgYiABEceruSG0AYKH58gYeBRzsfZNd/2GVT9g7wy3VpKKf+b0KgULrCn/jDQLUMV/LVk5IKmy6rCO99el0YV8G8Zjy0SM5LtHRZbtM/VlyTKgI1CDWHepDqVsk8BLF+zeZpvKHY29Ben8ue+Qlk+YAK0adwEnaLcdOQCRwxg7qW0P3wehhUua2XaEZV2KZfr933naTXPC2rsMn7sWd94gqRfZzOYLVJzbyMC75m1kg+UHRW4jbGRur9k15iOHdddypcQ+5GpUhTakOTWwSu5M/PkQQ9WZUPjWOrsUx8Mw/v4aJ3TVPJlYSqXOtwRwCNeusXAfGJlzIhE0qrO7++HR66BNuOFVSK1TD8KBRuZtP787ebBavsBYnvHUMgiu8BbbShaFX+FAemLmyMRPz6WhblukxrCuZs6aKoM4YLmef2etVX4dcmh9yl1+ABsiW4FjBFc+mMpyBCAyq9Ov8sUD5lEabe0WQpMABBhygoPo26BlHMXRdKBzhbn3Wt2SMisNOZ1Ybi0CfmOw066NWekzLQxw/ANrCmn+jRZFyctIC2Vrd/BdT/N9Aguf8cMGN3EblitAhU0nfXmT9N/Tuv5tMkwYPQI6Mj6WYIysGicDYx8r6NoT1qN9NWxn48pLVevXKbwPBQjvjymLV2+Gnkk7A7b33IaliTV/oPc19odast4H9FpGZDTdC/ndWCyCKgk9ILWTArz8RMSzx3xKXdxAceXt9dVA0LIxHo6b7nq3VIuthFbLdzQdqWoGCJadBX03H+gYD/OUzSWruBmZgLoIPfmiJUAJqsxHMSF13zJ
 C5DnJXSG
 l2rFLS6C0NZYKbbT138jqzZ288lgX2o3NqaTUIdxsbVipQVWynqDoBPS/Q+Fhq4JaOaRwHpjfH+Xiu1tIEBUhv/I9OMCXhq+1WaDrJmaP6f0jy0vmu7WGBkby3bsGdVquROdDxr4fHMbS3W4dkCKdQPn+naaonPgmMy7XxpTFtGKl0C1onnZi3ttLgzJIfRG/q8DOLHu83TVw/uaS9KmwsKUIupie5WXOeVa/dvLR+Qedi0ZN55RU7VYwlWm/5sjZatcFyp8kij2VmQup3VFetTquYXg5pY19N0uyPjxO5OhPi3EqB3s7dq1VeDpTdG0tUEPB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A non-present huge PMD must contain a software leaf type supported at
PMD level. The open-coded check names the currently supported migration
and device-private entries instead of expressing that invariant.

Use pmd_is_valid_softleaf() so the validation follows the central
definition of valid PMD softleaf entries.

No functional change intended.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index b0ce4ececba0..d3edc056ef57 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -430,8 +430,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 
 		orig_pmd = *pmd;
 		if (unlikely(!pmd_present(orig_pmd))) {
-			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
-					!pmd_is_device_private_entry(orig_pmd));
+			VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(orig_pmd));
 			goto huge_unlock;
 		}
 
-- 
2.56.0


