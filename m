Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A882CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B0C8E001D; Tue, 30 Sep 2025 01:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA228E0002; Tue, 30 Sep 2025 01:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9238E001D; Tue, 30 Sep 2025 01:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A673E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:59:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F052BA630
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:39 +0000 (UTC)
X-FDA: 83944864878.25.4E39989
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 88CB14000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZavWj2G4;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tfnp2VgNI7X5NDB06OaZAZrurrAWQnxjDDxodnKF9g=;
	b=68pTjeqTzJJ+r5LjZEyiJmhF893hayJVfmy0Kqv0MuZblXpFZxyZTpizVq1ZS2zops5EzO
	OFhLPebUAE7ouZ1oqmqWr/Q0/rmP1p+COmG+qvSgCwChwtkCe7p4er6TPUdjNg3JH7VPJG
	baH0Y0cfRBPteoLFOWl0K3ZS4Hg4lsM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZavWj2G4;
	spf=pass (imf07.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211977; a=rsa-sha256;
	cv=none;
	b=7QVFIPnxzWQ9V6XZ9P/m9GBaWXLVWZ67YTNnxEn4L3344y0AdfYiMe+VljDK1zFM+P2ruy
	vscpLvdDCHRNYSNcMAs1GiTBkPZ+O/p8m8xxSnYjCIlDeb9Hl5Op4h4sAK8J7da4mwp/Ns
	PhBqhF4p2mwM/QUwUmwGlvdiU+UT7WA=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-27edcbbe7bfso59075095ad.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759211976; x=1759816776; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tfnp2VgNI7X5NDB06OaZAZrurrAWQnxjDDxodnKF9g=;
        b=ZavWj2G4L81SZEy4yZfIVgJF69DMHqyxQhftgx36DfTV9WhItiF/8gPZQVwhCivdsa
         S9NJqE3BtCBgO2MOw+LU+GbXSdY5T6CxDVUhJBfXMMpI7Fu0ji4wt30brTg2pPXlE2do
         73CgBhUpdSKloaIGEPfYSz4157NGIy5Rjc3eK51QqH19dMMY4gMXVjZqz5/AMoZMAXlL
         6gVwUKDTyZFoHT374vw0ucZGkrgYPEr7eoaYFa+p6uW12fSS5nlw5/pAURK3HMKHU4xO
         9X5qSda9zNLDGkLRaXcUCw3iFrSibwJ8cExYaXABkeypL2luzLKCE0NlPH5te8snzauH
         r3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759211976; x=1759816776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tfnp2VgNI7X5NDB06OaZAZrurrAWQnxjDDxodnKF9g=;
        b=MH/VfODcs/Ckkfc4qih/RABxvnQpU0zPxs4162ZlrKp9N5BWPyIM/geExF0c0OrR3e
         B2edu6+pwt0YykiCgyot4/OVsafybZByivBaB7v3sGvh244XfqNsPOfyEkoazereXSeh
         fNpWqTfvYzxgxsO06DPiw2wLy2OdVhbdMFR9bt+QDNkqh0RBH6k4C5nYWBTShWSXS+dz
         qgYSp4s4+cWo+ton8rbqoJSFZLDtLYkH2Eu5Qma56Y1TvikV0j7o47w51xQU9aAk5EyH
         e3BKt/ZczqdEgFstw+/6FzcXavDprBIi7B4T3Nr+S85WIWvH02UzRXBVVtYzfMdtMcAS
         FZ/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNPYoeGIYw/7SRwu1U5BgO2MrAAlxf1HWw9gO5Di5ufn4EY0+A2d2YiCbNpOvX+oRWo7wNAzKPpQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5faVsYxg+IYxKLvz68GqOY9Hgxkqd7Q8NIujC9pH75azczDWU
	0SlzNHe92z3+rHhBtZLBzrK0UpNhfPBb4ikZmKVYifQt2cyTgrf+nM8h
X-Gm-Gg: ASbGncsSp/MI5VaqMBNPG3Bl2wYi8RfUb9nyMu1mPyQlzaBHMnF7xmSSoLiRiCnwd86
	SaVQU6J7g4MH0a9jKWEqfcjOZZTiaTOZNl6elpbx6vj/Ok/2QYDRikO/E59RuRioSjThl+VkMTr
	nkgnZpGG921UBQmOzutgoR4znm/0K+fkiyo0jN6Ad9+RnOAlU7t6LJMpmT7HNVhA+6wbp/h31hQ
	nFXOX1beRbU5E0VSOTphsON6mxrPOWgbZhoqaRZeVDPIPZTUE7Gj6Tn9/wCGusKZpib+gm44mWC
	ZdnEGX2FGYuOrermsBB4LkLpXtF+Y8fqY+dTL9afknxbv29W0lz36/R0VYwzypiZAlAMgK7ONv7
	8sySOuI0rk8rbsWgZUD81oahdcBDRiplVhEZ2cJDng7sHun9t5yA1fHbiBWvUysMgv+2nySNS2v
	+aWtx2HtXoOv7F2u6lygOgvpvoIZZOGSR5rSLqJQ==
X-Google-Smtp-Source: AGHT+IHzK9X+Xf+bVu8Rrmbp78/kS7yuMf0wwgc2gHprT/HrnmCmly3PRVr5PnyZFdbWTIQHPwUiwA==
X-Received: by 2002:a17:903:3d0e:b0:250:bd52:4cdb with SMTP id d9443c01a7336-27ed4a3d9f5mr206668205ad.32.1759211976345;
        Mon, 29 Sep 2025 22:59:36 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.59.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 22:59:35 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v9 mm-new 05/11] mm: thp: enable THP allocation exclusively through khugepaged
Date: Tue, 30 Sep 2025 13:58:20 +0800
Message-Id: <20250930055826.9810-6-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7py531o6odw7814titjf1mnfuk9ns1a1
X-Rspam-User: 
X-Rspamd-Queue-Id: 88CB14000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1759211977-942673
X-HE-Meta: U2FsdGVkX19b0maWLzqZGyohgy1p+t9bQmuHiXRHAEsTTvbNMZ38e02yqZEep/A+L3mWSncvioj4h43o2WSPlC4RYDLR7hpqmTSnrZL9KjK8lzc6w7BdyTs6rpoFlNWCJg7ca/l/zogDdW5r2vhmPKQzAoo9LzKYeY7yt3X6Bjvpe+yKLZD+nosGl6vJbbu8Ihe6Ld5YkQ7ZkN2gdfG+IkpOwD8Gdcf3mL5e73xQ52R/1qpqLWHNCBQSrHPY7nbvXPlNIRTnfcb4otc5BulzsVapjhwgYr6+Th9Dh0TRznklJq7EMnTmX2mSmSrJLX5uq9Jtjbi3bznP24DZ0h9VOVsK69MZGsa7cgqaSG66uZBbPBTSUGvxOeEEtoDn89cEx0HICHoK7YgVBNsiXxDXdOEwU0hq1aZu4ALatFtjCwFntKZqSFWq2DerRISU7OPM/SviqfHVhzaBU3IjjsDSg5Wj1ae5O5nu48d/TDVyO5b+a5znapiHlAWKrPOmdNlvdljRXXc0s+5Z+TfT+tpQSGx/ZmFU7dsRrwtuTbky+ktlEieEkoasFqaWFyEAnJNnsfaeVW8aeDSZ+MtYLYFGlZwc4zp1ZaMl8djx5XISu5Kyvp+8YsDWMGxx0ZEYY9nkbkfxoaI2QhfU6XJnReeex+wh6JtMtjtcSyaZ3prMAorWTPcOYRfhErxn39RZj60ZIpHL+HHLyFKDWbSDLVmH0xRsAQbZJAblaqz0PblShv32q1Ayel7S0FyEROSxfiiEmDD1ZEB3remJuFLMTF0AZiuQeqVFBLV4LRVDcxwFluOCcBh5Sx7jl3nMWtssYVVtIMZMaOGNEdRGducEbZUuHTnQ54iq+tYpvf92CBcSFZeegAlWn3weZnrQk9Dw69wZJlK7II0kbdRs+wUjqcwl7D6bpE9Od27pPOJoaQ5IA/albb0spc0b3812ZdTgfjnW1K2tE20VzXezSwHfj7P
 kAyFI2JR
 3ziH1OO3c6A0TnV1Bn7HAlpjA9OIRjqcSa7Nz6SeGIaHUPsY9JgUy8Jws7LoSiIFTXRi5nJ/IMdobV2IKFz7JcvNDZ/5ty+DBp+BNTUMHF9TGXrNktFf4EPf+cf8oi3gb/gMyPaFxbS8LkKbVPwlPOqzEMxHtuSluW0e9mRIoVaQZ9bfGDQxS1ayxfJdyZwP3fk83iBWZvXMaMP8dL40rIIXQudY3maL5i0tu2wNDUi+VeLfYblqmZw1BvCyUd1/je4J4JqM/oM8U9SzSQN+5werZe3bH0n4U6E13s9moJlh5j/VYtoL2SzGJy/i1wkLAktpD5i/Iy/BMtLpTpIZe4dqx+bGoaT2puJz2neWtHoQ5y7Qai1zwu13Crx+CeCb6/GlYRbzBTdwVcfrcle+Jn/J/hU8jNzVXFuOCpBIEV0xdHbHQ8rgke3kQ2Icx0kS9zFbkddLoK7lil8Rf/CVZNOft00hp/PM5LKe+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged_enter_vma() ultimately invokes any attached BPF function with
the TVA_KHUGEPAGED flag set when determining whether or not to enable
khugepaged THP for a freshly faulted in VMA.

Currently, on fault, we invoke this in do_huge_pmd_anonymous_page(), as
invoked by create_huge_pmd() and only when we have already checked to
see if an allowable TVA_PAGEFAULT order is specified.

Since we might want to disallow THP on fault-in but allow it via
khugepaged, we move things around so we always attempt to enter
khugepaged upon fault.

This change is safe because:
- khugepaged operates at the MM level rather than per-VMA. The THP
  allocation might fail during page faults due to transient conditions
  (e.g., memory pressure), it is safe to add this MM to khugepaged for
  subsequent defragmentation.
- If __thp_vma_allowable_orders(TVA_PAGEFAULT) returns 0, then
  __thp_vma_allowable_orders(TVA_KHUGEPAGED) will also return 0.

While we could also extend prctl() to utilize this new policy, such a
change would require a uAPI modification to PR_SET_THP_DISABLE.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
---
 mm/huge_memory.c |  1 -
 mm/memory.c      | 13 ++++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 08372dfcb41a..2b155a734c78 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1346,7 +1346,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
diff --git a/mm/memory.c b/mm/memory.c
index 58ea0f93f79e..64f91191ffff 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6327,11 +6327,14 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if (pmd_none(*vmf.pmd) &&
-	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
-		ret = create_huge_pmd(&vmf);
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (pmd_none(*vmf.pmd)) {
+		if (vma_is_anonymous(vma))
+			khugepaged_enter_vma(vma);
+		if (thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
+			ret = create_huge_pmd(&vmf);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	} else {
 		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
 
-- 
2.47.3


