Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23863CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 04:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D048E0003; Sun, 28 Sep 2025 00:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DA88E0001; Sun, 28 Sep 2025 00:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BFA8E0003; Sun, 28 Sep 2025 00:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B95768E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 00:49:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52324BC372
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:49:24 +0000 (UTC)
X-FDA: 83937430248.07.5396F5D
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 877B3100009
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:49:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759034962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=DyUaaqdWAgLg9ININm7xedY+UnymRaRfwlVA8p6wolQ=;
	b=TcdYkdc4hz150EKXsAxxy2dpBHJ/DBhOZqsTLTPXxOTcGxyWDum+nkDdZ9W40TVn+v1BZX
	ZSveannaB4lz3Jy54IhWuVTl6TrlfPrJqs9YDnuxoJm/R9oliyahxdDsqwfkDg0mRVX9n4
	z0SftgWpSVVM8SGIF3wwPspHRteRdR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759034962; a=rsa-sha256;
	cv=none;
	b=F0QI4hVDqW40HVbotTCTSgqyWFcMrTx2fJwAwUZbj46DZrGMvuUQLdOnad52ZmEYGUqoN/
	3cQr9tIgX7BZ1Wk5ACk/UEPggkOQrEdx7xXlZNxunhz6mi0zfDvRr/cSsZQEy5NhyrKfKP
	RnGAzlTq1AFvTAPbKGYxdkki7UNNwmQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3c68ac7e18aso2299978f8f.2
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 21:49:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759034961; x=1759639761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DyUaaqdWAgLg9ININm7xedY+UnymRaRfwlVA8p6wolQ=;
        b=maEwpcDj3aXrBLjefLfHVPrLPNEh1/uK4yTl31irM2f819A6TclBzdAIi3+o3Uvrdf
         o1q7/QmxJ5M4tgcc8wl7NtcXrzjGV3T5XtmBLwCPuo6lrt0RfnGp5AVyeiql8Q0lnPc1
         RUgfVY7U6kLnU28kWWD1MaQhNHZqfVcXk7lKSv+JtbqvctOJrMLkfBpEVE4hjm//pclT
         dNBelfjz6nhcHiPAHVkRmJ+39UP+9iCRhAi2m7uzNoY7xf4KTooyjQsuYtoxHBxGnBWL
         BxRNosAGy/dQ/0Sy1g+UcoHJtda9KIoY53dj7fW55DXDkLHeLXIId9PnBo71k8hooLQx
         2wAw==
X-Forwarded-Encrypted: i=1; AJvYcCXmLUba6nJ3uP+1kLDNW3qOVyT/t51ZIilStUnbXFXzo8nOeO6cETkU2Z2ZsdJ+gGAea2Dr8Ji10A==@kvack.org
X-Gm-Message-State: AOJu0Yzh6OB1hsRT2puRd1d2X/2Mped5olIyytBslmr4r9JBCHufQrYy
	MXZfhP3OoMVe3ISNzxn6/a/fR/SoyT2Q7vBvwPzXjlfv1e3O851+/4Ad
X-Gm-Gg: ASbGncs8Ie8wdowk57mO16DNo593LHVDpBNiWAJ3R8OsZOKge6vgcwzsCwlET8Ftl89
	dzgkMykPIkVPUP7uhFCiHd/9aXZNxvv4n+vaQ96oJuTkDXRa8+OsTtZpws8ubvg/1vLn+wbzlTm
	GBlC5Q5jCAUBTjfeyJzgLJAkkx56piNzUBZ8Qieti9iEwnGw1EyWBglAtglk2bZgrJEZUuRHy0u
	V+tHh/I6+mYix4GB/UCzUCpJd774xbJRoxawqz7xqmidFj5uYpM703RbmC/VBW5NVnMJBkSMMEP
	TUWad3cCJY2TirIFmIUEy0qTWY34U66OLLaolJaxt/0KAK//Zs6buFEMfR7Nssnt7Mt63EPpkWF
	YJOFaknnkWS2dd14pKvmTqVT9FRkex83MQA==
X-Google-Smtp-Source: AGHT+IFtXLQOdcvQ7Xjrg3v0c2+UOl4vx5bR+h7AWQ6ssWZLLcWyTpq2xRAkUoQVnuyBrbH3ylk2aQ==
X-Received: by 2002:a05:6000:2dc9:b0:3ec:ce37:3a6a with SMTP id ffacd0b85a97d-40e4458ce65mr11243196f8f.22.1759034960758;
        Sat, 27 Sep 2025 21:49:20 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::302c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb8811946sm13119628f8f.18.2025.09.27.21.49.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 27 Sep 2025 21:49:20 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	npache@redhat.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	usamaarif642@gmail.com,
	yuzhao@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ioworker0@gmail.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm/rmap: fix soft-dirty bit loss when remapping zero-filled mTHP subpage to shared zeropage
Date: Sun, 28 Sep 2025 12:48:55 +0800
Message-ID: <20250928044855.76359-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 877B3100009
X-Stat-Signature: ikidbi7sy191xjdqxq4ginh749d89qse
X-Rspam-User: 
X-HE-Tag: 1759034962-697206
X-HE-Meta: U2FsdGVkX1/hQY1X9hKmY5TRd4Y9h+dtNpOKjSIerw34dzq2auvGGDnQgh/UcYHGq7lCLWIZ2HHNCKREC71DixXhN8Bb7E1LQ8LdMvAUfRSB7CaWHZNpDNs9+QQvgyrjg0oxpGoSWo52dIOgV/Hwjl48DFec43pnOxK5p/s0eAFPrArEa2M8ZSBWDRJkyrMw/b0kwmLoZ0nkwDg5VEYFw30fzWiqtj3Al8gq5B+LVJCyzkrD/UtW7TcfAFxHkj6hvWGPzP1OcjVmdU8ykSp+BZuQMBehQ3w/lO98E+XIoFh8eg/Jgbfw6zFGapnLHu/uQYGYJmUAsEoym6nmJtqDqmfMk7s1TpoKidAbdRZ9eKHy2GWUcx7kdmbHkj2xoDA5aN/b5caYS+9M+WG5PnVUx7lbQm2GU2bUZZSuPOzhoFIWqfvHNpsrLWeS3QV74erQp3+S+e6zQzjhVcNjuRX0CnnPtuuwqc44tcl75utfab9Asn8wTCfQOITXUHeRZ5BhHH4oGhdxtPAp6CwMjyxpI38atwoaMB3/Vt02rUbonlUQG/XvWecNhfLNB53bq4pwMSeT3FDVYN54ld9lplerjz3VCnHLPdyFPOejKht5F8PxsrZXNkbKMEhWJKnwfTpgmoP1+hQVQyPo5NLLb4/oxbcvHTYJJxYsh9+Nzoojoek7XzlFqx6ol44EgZ7Oxho8mdFB5VRN7E99QUo7HA3C/p6p2ixuaDwrQxWm+i1UuAP5puPua4QbDaSNKnbgXYISE7L2dX75EGaSyjpxprWG0Jfbt8j7F5JizxkjVgsPSoZ0agwMNMX/nPjaaHqE3v/V4regJ5YKxcAFND03Ghlelbt7fTRD7Hq2f6wIfvqCH22tXHEjR8lQSaICc9qLGGVPwRjVU5yeHqazYqUl1a2qfzkI8S3qqU9EIB2I3QjE84L8wF2Wq/+5sqOZgE7a1Dw2qPH38yfBIV9ikgSNseZ
 gGPWM+7H
 oYeJCyTLc/yD4qkMzvmqG1gBMwvidUXk8nWwyILZYet3D6vrHP6SaZrDxEkSKKi82bkcPxARES/lLSzrbTEn6qMmBGy2RPU0UfvxE7e0Nw3K5PZQFbUpbLhDJdL9dHazWrImeEdWyiDnGjx8xWga60PaJp5JCzMsgffKo1X9lGrm5xRncDfRl5LpZl4+HKU/yNw5OS/nPX++XOsfgOML+kFuK2V6ukdJOzkv5J9Vy9vr9LP5tImhKC5lh27iGOcjUDD5TRZSGWVahvMOhsXA17q2hk1BGEVVoG3v/Q2bLUfccs82InZyLxGzUzNU4vzfyoqqy3rypjgYXIvRWkD8dEH1R+79H9fyNRKsDaYnmoTN+8LkZjeHY9tquiFDUlk+s2Qk80w6dvABN9SX19PhCUNDi174xgQxO1CFIt9FfKIM575uFsLy72Pyh5I2XD3NqkeN8JKO4sire71XpbN60TCkwbOHME6veHSQmVxfV61CFpbMv1ZK/QKNQRVtlDycrMpOW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When splitting an mTHP and replacing a zero-filled subpage with the shared
zeropage, try_to_map_unused_to_zeropage() currently drops the soft-dirty
bit.

For userspace tools like CRIU, which rely on the soft-dirty mechanism for
incremental snapshots, losing this bit means modified pages are missed,
leading to inconsistent memory state after restore.

Preserve the soft-dirty bit from the old PTE when creating the zeropage
mapping to ensure modified pages are correctly tracked.

Cc: <stable@vger.kernel.org>
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/migrate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index ce83c2c3c287..bf364ba07a3f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -322,6 +322,10 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
 					pvmw->vma->vm_page_prot));
+
+	if (pte_swp_soft_dirty(ptep_get(pvmw->pte)))
+		newpte = pte_mksoft_dirty(newpte);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
-- 
2.49.0


