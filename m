Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A7E9C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A085B6B0891; Sun, 16 Aug 2026 18:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1236B0893; Sun, 16 Aug 2026 18:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8807D6B0894; Sun, 16 Aug 2026 18:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC4626B0891
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C38D1605FA
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:26 +0000 (UTC)
X-FDA: 85108620492.09.D6EF770
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf06.hostedemail.com (Postfix) with ESMTP id 762DB180009
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u OcNWDu";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FkAIi0+F;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0cmyfIpPsi4r5/pE09ldrrp9VWmAB+T0yJDqsA9a2c=;
	b=6Im5QDFwmwtWTZQnAAO7fNRZBTKbo7gg+3bcyBvkJ/1Jfgq84QvGwYOuEn43X6YiyK6lFN
	KA1pgW1lY54n9EckdB3nk+Jk/QKo9GHRAOJdg7M1SC95BOEGdhYIgxwWdxbkQkctKan+Hb
	YEkFhFrIFxhQXTAD2fiXSEitlnG5fJQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u OcNWDu";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=FkAIi0+F;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920444;
	b=1++c71ks6v5NC7haNelvuXDQ5lvkJsGgKAc6zZoomMEQKfTEKC6u1DNP75cmeweVrKJfy6
	ZVb6JMmNuCoB82nKxkwCF7Fxn6qdJFNR6YrwcY+nb57SFB6FgVgeIfqdKW8/4OcZplNQbD
	bQZFgROsln5ScRmRJitlpjTFW94nG4k=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 12CC214000FA;
	Sun, 16 Aug 2026 18:47:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sun, 16 Aug 2026 18:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920444; x=
	1787006844; bh=Z0cmyfIpPsi4r5/pE09ldrrp9VWmAB+T0yJDqsA9a2c=; b=u
	OcNWDuk6hsisB4OeqPabVopGNy13grQuzvgJq85TLmqA51ucU0aQ37WXnBEH/YNK
	xRzxr4yYNs1plWx6cVFdGkC/4CHlDzLZwJ5FNrMNvsXwqFRJ12YOdjCsuxnKK5Zm
	sbm0/BuPHV6sPp9Q/tPr719JszqofCKZtq28lD3HL+MK2V/IsOEMvDOjsyIVvhn7
	zbzNCExPuDv65XMmc8G6OlANQB3ADYjpseHsACi/Kpr0QbqAYA29bEEsq5fIOSsL
	BXsi1bAVxHAiyb5y/sgr6pSFp+BZnpVsRjEOaFLrQxaytlrB2/duubCkOtkx5ZDC
	B+5g7f0IbuoTH5CGKbZ6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920444; x=1787006844; bh=Z
	0cmyfIpPsi4r5/pE09ldrrp9VWmAB+T0yJDqsA9a2c=; b=FkAIi0+FqJANMN1HX
	dvGYnwXMnZGnQxbrvxE9qJ+ujJP6jYfAta0Qydl/FKwcz8IC3PP1emysQBvt4ION
	Nz3AcHasVBCmHRxqVSVm5Fyyw84T2J1ss2FDyCNyVmiz7frF1A1rvqywEV0KqPhF
	H+DfeDI6zOxv8XotiiRhwedQxShlJM5nOYrusFnQ6T+g5cwR6eHP5Qh/liqtUYYp
	Izjdb3fZgtXiMW+ymZnv/ksh/nGUuXHsbREtOt+2LPnYmnFUqLRZjiLKICrU41gV
	D+OzmbIrwl5ugKHYdpIa8Z/DkRO3kHJDy3Xhw/ts+xIBTKOGwNgQ00aadEUFRzjC
	JAlVA==
X-ME-Sender: <xms:-z2Cam2LLSLri5sKKbFa3qCz3Wensyeb5Smi7bGPfMefmZWsuM-NhQ>
    <xme:-z2CauaAl1EB95jC_dBm9cLDzHnq3bXgnyhfnswSdxEXbEoFphTDPMvVv2DqYfWPN
    smHvPHT37wJnV9PzBM-et-ZBc8mBrRr1XcU4XOiZQiZImPlzg8FQko>
X-ME-Received: <xmr:-z2Caq99JoBGqtFdVZuO2dEzWliJyKNNuIs8Ohf4kr7hazhHbHXh7TtqQLk>
X-ME-Proxy-Cause: dmFkZTFlVyZDQeKVm/cv0R7Uo2AcdsoROSs+PNN+RMPWNFgEb+eGte/fI2JmPedO/gUmIe
    OeoZho3fHA3jq9U7FHaKLb7Pve0ST4uqo5iHPPAgdpzTDnnLaz+AJ6xkiozNrpK1meLIn4
    2sefU5BkNXUp9QcsQtONjZ0nUOLKoeupvv0JrZV8hAC+7fEjHSt2kKuDAbX3om+BmKbYq3
    FepF2Gq8LX713eWlXPmLkfGboRIv9L2g+Y4/FUEyMpnFgJsl0SpF+3p/+THHwbO3LtcR+N
    5KYVcWsQpsjE5I4FVrmdf0VHbzDD4H+sgFlZmgmVgtgliSro7zGS30VizlBSv+ooeZSJRL
    EqJyIKEeMiqcYtpukkHWvUxjLMWEpzHN7YOdlRnSW1LWMwkyRw9mHhg8vb7sytLMPBmOYq
    gShL0XyER5ei2tmZGVRjzvcxwS73NM45HQRDl8UV+z8O0eThEaY5NVORggJz+kwv5S0Rpt
    ufdX2pA/xxTUHhdIF1Wdck2LhiU4Kb2rberi3q4k2/E2MOq1pjRebomwn6ZV87is1ziRLa
    Y5f+B7wVSRzeuFHZnsaKZMrOyZTv3v13m+LvJzRjJZvoYi/mfKk1+4WHcVf6RYvqLO3GgY
    Sq1f1Yxu3n9naNwyx9jc1/U8r6cROKfXaEKiJDWRNYI8Cax25Ayrhnm8WK0w
X-ME-Proxy: <xmx:-z2CakagL6K8AyPnhRZhAsFaWjaoerflEDDmBv7NMFLciuREnersFg>
    <xmx:_D2CavViL0yOgjHY6fVHXHVOSx_tvdeYriPQaTFDrxWO4VC3ALsZpg>
    <xmx:_D2Caqhe8sLGW0yNBAMFwH3CJa4zAJqblfvCVIqNyPxl-YAYoY98oQ>
    <xmx:_D2CajmS5RGBRGj0dDdw8pkjZrtm_toxaHlYgpDD6KamxWLN6bMbrw>
    <xmx:_D2CagJo6gmqteZ2Gl0Z-Fz-EujJf6CbIpyRhLi_W30Z_DeHGHhR3_Ng>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:23 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 35/57] mm/madvise: drop MADV_COLLAPSE's redundant mm reference
Date: Sun, 16 Aug 2026 23:45:47 +0100
Message-ID: <20260816224609.308019-36-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 762DB180009
X-Stat-Signature: hzo36hm5y84u5wibj36h9aacn1ah7n97
X-Rspam-User: 
X-HE-Tag: 1786920444-215172
X-HE-Meta: U2FsdGVkX1+fh/CqoupdlOslD4PCEHjyJtk94g1HvcX5K0uKfd2XaPmN0QKX0xUKMZZhlGqr6+bI9E06AwF/fDtXRf/JKB2cImkdfF0RG+7CRhaSdyZcqBXRxmAlh+fCZ+7fQz3tb/MRURRU/yYNRnENZlERdLV+ZbsU6B21ibTjhitJVknhIdrPmSDbj50/91MXhQ3/rMkqxtZQPboNaGrh+73MExMHTilemMzmoT1gnE48cPs9En65GKqN9wGxsBgawdn/JDBNDcSE1gEZ8MPWJherCqfmbea1RPRfmYhKzaLq3wzmPzRJr1/Y5zQuJwh61S+HqvF+TKTMgqqTQFEZQcX9t4IHMZILlhXlh4EjAs+Su1Elm/hzP8GZVLFeifDZFeON/dLCW5xO54TWhXZK9dq65DUT9VkyjnaheTkqqwnEQhq9cGre9WAbL3JY/WFTksO2Yuaie78r8EpNREs3HS7wDWgTiqNSZYsVFj22P0ZeBt2LUBCYXmGnbczRWUftD2i8AbYSShyDb63jv/Zr2GwXsgzsyvGpwTeu92/G536mUrX1qmz8wBfCD/dS4iOvwHfdoVKeF8Mz9WVl4VEHQcIGFJLckP/h8tSyMlby3tEgeQNK3viw/yea2v2QWJQpR4Ok7Hom42CKf5Z1Z3yE92GoWRKO6OUB7cabJ0VtJGMsSkClB01oWiUkC1VojXNit0CkVCa2wrIRkLXJ3ArF3nSSIJDBlCUqEXcwOoANT4B9qvPVo3H2+lwlULkLzXALfQubquG1mcnxamntAx8npYlIgd2Z5tm16oHF4KpfoMWI+Qysq3EUgPiz0S6l1NZI5zUV9Wp0GI/lrPIiUrRbPlzQGkXAUji5F/KNGBWuB8rQoMq20xPFA+9Jo8LGX6BHn2THtMwUjdmX8yZi1u+qC8eJbacpAsscU7PfHeXIQgcWrvs2aB5gy/jBrDSLERJ7QMT1SLvBlkvfsvr
 CRu3J1Yk
 /e8zOd6GlE48D2A1Yh+UKliLQThuGkE608YOAl/5LoC7/Kghm8XF7k9GcjsJgm32tTs2OU8iazVjn6AcimbhNbVDl+1EDb/4EtUagiVcq3+9hjt7u/QAI6T/uPd+bhUG/A2/9USopQlg3QJU7+mIl2eAkiY06cJfAemzD8fVaBc7qln6YJhvLDIM2eYPq/2dI8wqLKMxqq8fUoQlJqBv/x4QxyH0U7yl0+lya8xuACGFvRRAK9u3Ism3zyEvWS2tUP6HEROcVdXkKe3rD//atz/VqyvwTBrbSmUNRJVKNOwWJZoiJV69R2HVC2kNgMV2W0ikkwgFmMSnIRN/IA5x3sls1Ii7M+xTXzJp72VHTulRxjTibwG/x9EZuaKnYT7NgXSJZ95uD3vxa1C9TeSt3cocsl0enrYFVV8lYyoCfliab66zAL25aNFhofh4KMNNHV9jtOCY11Kf/guwhRaUrDMiD4XXoasCgn2u0GDzn0ljtohWny0+SyzePfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

madvise_collapse() holds an mmgrab() reference across its work, which
nothing needs.  mmgrab() pins the mm_struct alone; every caller already
holds mm_users, which keeps the address space itself alive and so implies
it:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.  It has been there since
commit 7d8faaf15545 ("mm/madvise: introduce MADV_COLLAPSE sync hugepage collapse").

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/madvise.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 76ddf61f043f..c1bb425be3f4 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -979,8 +979,6 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 		return err;
 	}
 
-	mmgrab(mm);
-
 	/*
 	 * Nothing below wants the lock the VMA walk left held, and
 	 * lru_add_drain_all() waits on every CPU, so give it up first.  The
@@ -1071,7 +1069,6 @@ static int madvise_collapse(struct madvise_behavior *madv_behavior)
 	/* The VMA walk this returns to expects the lock it was holding */
 	if (!vma)
 		mmap_read_lock(mm);
-	mmdrop(mm);
 	collapse_control_release(cc);
 	kfree(cc);
 
-- 
2.54.0


