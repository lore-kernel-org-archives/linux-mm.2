Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18E3FC54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FC86B0098; Tue, 28 Jul 2026 15:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81C76B0099; Tue, 28 Jul 2026 15:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5AA6B009B; Tue, 28 Jul 2026 15:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 969956B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:47:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D946E404D4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:26 +0000 (UTC)
X-FDA: 85039219692.11.6E166DD
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 12B2BC000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:47:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rFCge6fr;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785268045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqmZmonnGKuyrTzlO9IdYf4JadmrLNGgv2eh0Lztbm8=;
	b=c09J+9yKNxPmLRRRTE/WiePkykD2w9yskmaRXzue3d8xY8P9tnDOyIs2aBVQPFfmmy6q8q
	0D/srqnXk4x8Rhv/b6L/2A636/Tf95/IPTVLPepGgWHYMLLJP5SncmJSVIBVCvxqgtpX7x
	14mh21GM5oD+1mkpLTF1NL20Thnr+pY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rFCge6fr;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785268045;
	b=uOp1EQV5yb+41xQevtM4CGefMGMhSVgZXvgR7/r4MB6Intif+TTwZOBXpM2b3BwEdqdYc8
	eNlRHvmsquWLyauO15scHKbXZdVYuQxRL7Hv+pkd4lGH6/SqwkDRMmQsvo5hLSx3zDH3O+
	1pbs1XOCyZPBPSBbMVQfMJV2CMV8+kU=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51a868b6962so2194191cf.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785268044; x=1785872844; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pqmZmonnGKuyrTzlO9IdYf4JadmrLNGgv2eh0Lztbm8=;
        b=rFCge6frd9DXys8QWeHxGf4VCO4gH9FyNbL5nGGFucy0WVzUsz+ORtHoB7UTqlhlVK
         MNoyLcxSj8DeSWaj5b3Sde5ZaNyOTDJwZRs8JOG/8u6uZa95NvGp2Ec2f5F5llqpdlkJ
         rNepfcF835fgf03IwgW2UhosyHm1L3DbWeblqCB3DEuXDlxEcqLg4SYQMMhqCLDW7nJp
         JsL9vZekTTwJmoZ9Kv6CYPDMc5UnFs6Q2b/d3yl+3aVE1ZIst46DYmvVdpGtWirHjyrb
         1zu3BY/om/seaTmPLEdT4TZ+96QIb94diib2Jn76BiFBm3/C5RR2LOL1M9VCKx8e5gin
         kAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785268044; x=1785872844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pqmZmonnGKuyrTzlO9IdYf4JadmrLNGgv2eh0Lztbm8=;
        b=BvxtkfzbB7rzy6XuTjqvLSp+pSAohFoimMeNS3IOOBo0mwlyif3HOsZIwETniEUIUd
         nlvKLiT9kjpg9XAubqH5daO4+zV+epUHeFxF0lQhSW32iTlfu2ZiODFcNB+fqNzrYYg8
         nXoyvAFSeZSHe2pjcLAZNpH3ZDJNsQTsZgC7X0vHye3aNToRdU7wsXN8C+QJUHDGm1ar
         M7o09mLjrA9XuT2uENVZNfQ85cfKU6IQqaWXxbXJB0oZq8OlM6MsrHHERMpy2jPDs/sQ
         EUykMg1bZvg/ROROqhY5picpD269ipuBca6I7QTYgukLi995HahYqZu33UzKnhDd+tJR
         iP0A==
X-Gm-Message-State: AOJu0YwBHuekFA0gk1YlattQW0FIG/RmuasAVl1Tr2mKtrLIyicMG9aw
	MgeYnGY3tXEtyN5fEM1zEYMfgiOU8UxtTVH1LM5sBtSnEHfx0Voz2UFhlRqUv6lQp55WqYU+5aQ
	9i3Cs
X-Gm-Gg: AR+sD112b8qX1jvmPUiSnofwufXDkiMyeupbG35MbGRmZDO9+Jy3HSeZI2fzqpXEy2+
	qLCxh8Pp9X3b5KaNIXPvLl8VSw1Qr3reVtDoLMoFBxKiBvnh2Sj3AhXIObX7S2lDxxGoSbzdLme
	DxKvEUiu2FxwCuLMRkzsKIW9cDf03a95n7cDwUQeIxQqwoTWr91CGFE4bfARZaOhNoWMJJ2/aJw
	iP7nl7tAILnpYXSjdt/roLUwsfGKW5wZUEcJUgR+f7aigmEmUywg3oAu3tQ3jfrv5lsp4h290Z+
	HLlIytRmC1AAi09ppqozVPtWPoastIdBWRTrtGqwz+yr6Vu8ootXAikSVG4rf4n4ACXwSS1gLof
	HxJHa2vuN4gHX8kYf+IQDiDWYrGcQmfxcd3QFS3JlgU7ly3p0OMCsWWT9Z5gKeUmnd19E5WXc2o
	IcT8qTkl2H9NhdU2cenfOJmlvX0AZ0EdSN5g3c1MpRvcJhy3jawPn4lhTa+zqNepOY/4TmoqezS
	A==
X-Received: by 2002:a05:622a:2c6:b0:528:3b83:3483 with SMTP id d75a77b69052e-529d70fc0aemr38942701cf.23.1785268044243;
        Tue, 28 Jul 2026 12:47:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dd6b539sm6700176d6.41.2026.07.28.12.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 12:47:23 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	stable@vger.kernel.org
Subject: [PATCH 2/4] mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
Date: Tue, 28 Jul 2026 15:47:12 -0400
Message-ID: <20260728194714.3713735-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728194714.3713735-1-gourry@gourry.net>
References: <20260728194714.3713735-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 12B2BC000B
X-Stat-Signature: jh95i33freosd63gqoykia8t9urxf697
X-HE-Tag: 1785268044-384338
X-HE-Meta: U2FsdGVkX1/3GOAXXjceROG78Bgtb4oMDwPl9l2XKZuov1Etj3vMeQA5/1Z5/kuBO4qVSKxr35YIgxHVc7jELBIczYPxXHe804Pgmri+ms/c59JMyibbZWQ5t7Oy3/UMN8Gyc8AXgFuhUFqfki9mVGTk2/rlRCSKwVj7wa3VSHnzBH4nPLFoa1vyqzF+ENWfekXiGX8QrAZ2dErANjKKdVCpyqAHyJG9Di1ciCGA4uOEeU8d96bDbUqfADjBM5CaRdqyPT0HsnKCA4A6FHmuKAKOKklNLRDPEEBLATKn6BxheyhCUwEn+wFxUeByQ5YFM5f6nGhn6RlF6UQ1Xa5KogGsbKh8EV4DyI0I2i4847lUwilP0o0qHo3Rn+vDICoNd+OL4l03Ig0WtlP9muzetOZS/rXzW8F+bIXFYq60y8yJhJdX6HVmd5nbXc2CCe9I0WCynpSc3Tf4eOgaJXjnuAOvAATaKrbtDzgjnEtxMSbVHdbAk656mOB+yBNiN2joc1qgzU6glBTabLeEND0LuKU1exY4f2E8RSAp4fx1sHQSTsMzfJi1kjOtEwDUachDvnqdVQ37M9j/UDD1c2B5xXF4hX0bZI7Uog/2wM0qA3TbGd6itJMub+ITcXcocC/1QNxqJuW7An06MB2aI6DLvwpgVpiO0EbieUHq1xtt1uJOmkQDU6fDTnVvnxTu2O9qPala2vE7Sm9FNAYuamLrSiI2be2yu6BeT+YIXzKBVInGsUajZjTti5VlzQRCEMVRlkzT/KlDn16it1EcAETEVQHXUjESxyIcdnNyc468vflDZAmFy/cSiJ8gSiP4BJTI4OIsGoAFkgzEmyJe6ALlcIi4LBATBvJtGomH2xrCCTCUvml+hSjUuqMU98lZkRttyea+EqqDwQ2tuvbx7sDct1iAoAJVTzuYCKrXfp8KsFJp6VoilYv2volqJo0NCm5hGnHnwbfQVJZ7pXaCEak
 IdGvNuME
 /97h8sCejR1PJIUyd+Buhyx/ySOxU9ahA06P/lLwukdY2NHW9jAJfB3ku8xgz07fYGo4ZuArTlaexLKV7t0SJsy80ObxOXhy7a2+hVfPU8UX2jDhGa8ra4I6dL3QLXL/ioAYzmw7N7qBVRqXn4BqGDoRM5wUfw3jeDwUZD5xM0t2BQMN/sEAb9alnkyOJVq/Jmy/fuoDk7lQCl+J3R2TgAW0QV8dmruKm6CK6jnPOiQO8Hfa65T/QDISodnZxtzo0zvm/A3LG3aGbCq6p42MvYE3AIHcTSK8JBo6OOt5PlixGQ2eKv5XZvtcrO6fECryp29oUHGlXVwWfmR0z56D6MTzfi9Ko4s/JVtJG2pSESqmStdZZtPYzeyLObDyxPx8R0nQiF5hDZjbUvO6hShQTpl7w2U/FBBcAFzXypQLZfMtvUnhWijcICJXdMa84XQUvhLEL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_free_huge_pmd() resolves the folio backing a PMD via pmd_folio()
and marks it lazyfree without checking for zone device memory.

The surrounding guards do not cover every zone device case:
 - MADV_FREE only operates on anonymous VMAs (DAX mappings are excluded)

 - !pmd_present() branch rejects device-private and migration entries

 - present zone device PMD (device coherent THP) is not filtered.
   Unlike vm_normal_page_pmd(), it performs no special/pfnmap check,
   and would be marked lazyfree here.

Bail out when the folio is a zone device folio.

Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5bd8d4f59a7b..e0ffdeeb3077 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2338,6 +2338,10 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	}
 
 	folio = pmd_folio(orig_pmd);
+
+	if (folio_is_zone_device(folio))
+		goto out;
+
 	/*
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
-- 
2.55.0


