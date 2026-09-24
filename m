Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB597C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F0C6B00AC; Thu, 24 Sep 2026 03:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E462A6B00AE; Thu, 24 Sep 2026 03:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C236B00AF; Thu, 24 Sep 2026 03:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3F496B00AC
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:58:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40E2EC026B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:37 +0000 (UTC)
X-FDA: 85247903874.05.5B2D02A
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36390140003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:58:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="DnVn7C/2";
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790236715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8r910VhEWgy1eIdXLPcYAHanh/sXYvzfGYAge0OSfUc=;
	b=omdDd2u9ksvb+pDihHVYudrq5xaURpBewQoHdnSqcEeLm8aZeI0VbYrl1bhkISQ6WnaHnh
	cCsANd2DNKkawKcyq7aev6VLSOpEn+fzBR6OPDKXLXeE6szJa67gSn9kto6uab5cww2aSN
	/VKFJ+hb9qOl8TkXSFE4oftyKtFJUEk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="DnVn7C/2";
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790236715;
	b=pVyBc+LsshOBotnParKX7bXtdvlw9pZDijneZv055tC+eKMrBAGfSFrXDbN7szbaWPizdD
	/hyTOAO2mJK7h0ScOlaPwb7VtgfqqCfvbIxh8wF2VA4FSXPugU/VXw42KtfsYrHb+mBizq
	Ya+sp01IiupI5kPJ5LcWfQDFeOjWdQc=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1cea34ef4so1355311a12.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790236714; x=1790841514; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8r910VhEWgy1eIdXLPcYAHanh/sXYvzfGYAge0OSfUc=;
        b=DnVn7C/2FsuS7RnyePWLieP9qf530DfTg+y3RDVlhxiD4RdY/9PQQUSBP1rf6j5lYx
         QTIlZPhtj4b4wnOIpXhc0T/lNHXayAcBNa+SjVd5ssVkFFRxdHCeyUa6gnuROZ51c++/
         Y3KT4tLyqlTj1VsGpHle/a6aR/m6njWrRjEpWoqCZg0vMMgC5RtbH6czvkkJDev0UejG
         +km2WDhkIHB+p8vDfyKXQoMk/9wD4YY9OKHdveh3ZbRENUEgALw2H63GImemptgeuUN/
         R5TfyOiZ9OI2lRixMw6afZrx9g6vY8vJA4U7WIyYO/v5HSdeKTCqUFuuxI29632Tw5Ed
         nBxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790236714; x=1790841514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8r910VhEWgy1eIdXLPcYAHanh/sXYvzfGYAge0OSfUc=;
        b=xFGI3qHbgRjG8KvtRng3P9gohVI/yKoMfONxjakd2m16hywJf3OWq2Pypr0X27EKMa
         eHD57BCk+1BbAksSaDoTPGX04T2lohJsZPMXLweXBEYjpwoTR7Eu8Mi5iirF8ikpOJBI
         gTt3JX75nqRGXKndz1E2O+jtZMGwsVBHYZl8mJOE2/a8ApEQDD9M6pYbiudWSvLz/Vb3
         3uUjea9HrbIOZku1dOCjYlYPXxjVI2Ptg/0QLpN+tvkN6jY7egSWx5FykE5i3wR3J2s5
         ZEcJgkSBofr7mwNkvFDdgcO3LnS5CB5BcXVR8GjmMwyfZJOGCsOw9GbQlyo2ku+ksePU
         IUfQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSPpj3fMaXnZSFir4yn4Dg1/EH9VddB3ykwTFtpCII93uL0TYJaindaZW4UFtVCM9lquk+NiFgrA==@kvack.org
X-Gm-Message-State: AFuF++lsfzzOEEjP+mORBjSWcKfMAMj06tMZSzQDCxOO6M6EEBB/5n60
	II2655yHYmlHnKPRhlpkkovZIrWYkBwEeNYzCKjl5oAlObQ22r11/GSxvJ4MF22FPJ0=
X-Gm-Gg: AYBFou2DuWB7m3+QkPZgyiPO9V6J527acX0gA5Doa76uTiygblSKmUcTnayQA1EneTV
	swXYR7RCdFhOhhYATTawsxBvssQivMO7dWKJd3W2CkjFl2YqKcdXVwLPHtAFepsRdvkcZ0r57Y1
	vCAZiSP2ee6Zt0zzzKqeKvVnpABxA+XASiMQGwz/Sak5l9ufXokxmiaQzwaozEX+1Csb+o1w2/u
	QW/z0vZeftFSDI0Y6rASL4P4rEaYOzCRb6VZt9NTVXwbS3R5aOwTcnq3mOCvTav35XgGY80iHIf
	RICdFtWSWFqArrXtnESO14ry4efHi01kPn55/kj1IzTipQCI0wWu0UCcRKdZHVDoeLoSVd7DhC1
	azO+wqyCDqrIaO2OI8MKdA56FxCn0DsSCbf/PGEfDTr4S0YOkkRVYE3jxEdMj4fAJPjUw2gusT9
	18HXcFXNsTgwvquSRZP8z1tKgLoejKUxnA1bH24TrFpc+enzE0r4w0uOO4l/or6c+2g2hhsCoEl
	ImMQETlOYEk/VK2Obg=
X-Received: by 2002:a17:90b:4fca:b0:3a0:910e:84aa with SMTP id 98e67ed59e1d1-3a098d45437mr1424739a91.12.1790236713758;
        Thu, 24 Sep 2026 00:58:33 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972eec92sm3575622a91.7.2026.09.24.00.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:58:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2 6/6] mm/mm_init: add zone mismatch warning during page init
Date: Thu, 24 Sep 2026 15:52:59 +0800
Message-ID: <20260924075259.2013039-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260924075259.2013039-1-songmuchun@bytedance.com>
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 36390140003
X-Stat-Signature: ouejxjg3z9akwf4znscftikgpimm36kj
X-HE-Tag: 1790236715-272441
X-HE-Meta: U2FsdGVkX1/cTNpjhtvg4r2MH4M0oeu8QN/ivdpmTFqJwsu1A/F7bJ5TraK4urLdHRN0lPiVj8Ljdu0aC+l6xUPWXi5CrpGdDTkV3MAIWFEEIG6Th1EXgqxDgqZLWHuSEMxS7+z8ZBT5QuNGJ/zULMNB68YU5PrpPZtS441kHTZuX6hFaWzJXGwEFXppaWFpLezm/6XTx9GOiluvCaPwWQW7GqXrBqvA/Jw6skq28C/fvzLYMQRVF0PCeoFwq8EZGpDfczwQiQFZ4lWcFeCjx2YXjKxnbyT/C/xsfY27hO8RCoqy/wEGc3PIWTurFspyeQsCIxHBGflKeuD/+QxCtLhtg2LxW4K3IXzPRPSMxzCA5fZohlHy/DFmY3JHrgH7ndk6SaRbwDsglByPEthJlnzAGzDCFD3njPVX7+2Sgf9uu4f+J+yPdjKEpnBtTnshvdIlYSH3dJw+284X1OVjvp8JxTwAMzfXJe/kqcNj5/8h7YbHJef5jPxr1/5f0OrdNooY2DbS6hkM8CP5++uMtlnf+3L3lvJlNyI1IBw6HXBfxJZl1Y9ObrUOHCP90BOrnD72LJ1J+E8D203vilGAX+nYwB+LjntL/chDyl2vq4qJM971X5U+eghDaNGCwAoW+WtnsJ89evZ8ZqJvNW0xjSjEOeiUIwRjNehvsH7aH8R9No8nmGtXQKa9lQ0TSs4q2/JydA1ekQXDoa8M7ucbssOhuCSZEnhUhwEBYy6/LOxqhhuOLY/+mSauscZUZsP30ISMcmru3mBVz3EXR4tYQF4AtpMIAIcnX1Bq7l5o0IA/WqrIKxeprQFs+ZTt4lhAk8jMF99ezEiekymOvLT+W2cPl8w7UG2+oNRv9CD+ByBnukjW0e6iPhItt3xVvkTHPv/qfsV6X5RY2g48SpL9QvXXLuoHVLXcxwB/Ttr3tVzK5abe/z8GUC+eQeoC9d6fbaPca9ulTVkmvFkbBPv
 QcPqCEBX
 Lo+UN2v6d3oXbOR/I6DnhOLoyMtoEoR7hmec7jSVENuKX5an1HXiSt3ZFeDNZ4YdujBOPdASnPzMYDIgbFEaU/scEWucrMV4YMuSrRIf8+oG6SoTmkvh45Yc1qBNJgeLAhYnoUCyorWCQnwddFYb4NGJQfqXwlVBMeB6BtsLqzj6E80rf9D6C0dE71OlEG9ahE+Gmt6H7mWRFy/NDhwoPr5RgPHRFHzOpL3e3ybp9DGFy6nN0R5l2zuWjtVUqgvd3HEB53Al32MBrgsYItFzWzKKr0E1KuTX9p9tmYl7AR32e2BpVcRJVDpuPS9sYfpswM08g8aM1AhxzSXz/yQp8tkjuMRYcSk3kn16yW/s801C8QlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For vmemmap-optimized sections, tail struct pages may be backed by
shared vmemmap pages. Those shared pages must carry the same page zone
ID as the struct pages initialized for the section.

Warn in __init_single_page() if the shared tail page has a different
page_zone_id(), which would indicate inconsistent initialization.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- New patch.
---
 mm/mm_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1650d6bc1211..bd02e8d06965 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 	if (!is_highmem_idx(zone))
 		set_page_address(page, __va(pfn << PAGE_SHIFT));
 #endif
+	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
+			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
+			page_zone_id(page));
 }
 
 #ifdef CONFIG_NUMA
-- 
2.54.0


