Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4E7CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 04:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15438E0003; Mon,  8 Sep 2025 00:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4768E0001; Mon,  8 Sep 2025 00:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4008E0003; Mon,  8 Sep 2025 00:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 727218E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:07:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3CA111B0EB
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:07:34 +0000 (UTC)
X-FDA: 83864748828.17.83CEE1C
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3741C1C0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 04:07:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757304453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=409De3dycyXy94pFQxmNYxL/WmjZWt0b3HPL18vEbd8=;
	b=5YT1gt9LfJqgKMsmk/SNopnJN1jmUi5DHtRhLbzyp85rKf7ssDuV2iOl/mXozHbWjgh+sU
	zUlrL3Tq7ycKDVgMcgoK1Qko45+PIxZZSEkN/w0tj/Hun5Ns15fCJyMItRZBNP1iKHHSPg
	6lWbWlmJeYWYSvDw8IEV+PzNvIJyVAU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757304453; a=rsa-sha256;
	cv=none;
	b=5YY3TSyyjv/XbMO97cmJ/em+UmUAK/h30LYXC5g6EN9MdnCzKXTPDmd7FGIRoJX+/UjtPa
	NBKuseUMrvFbngJqyold5suhKgDuNc+ZSR8JtL+zF1KUoeRfJ/o3D8cdIJgfn0mGT+edAQ
	tWWMx2QE/1P91FffWnrqzLlOb/GakIg=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45ddc7d5731so11711445e9.1
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 21:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757304452; x=1757909252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=409De3dycyXy94pFQxmNYxL/WmjZWt0b3HPL18vEbd8=;
        b=ZXGutzbU09Cbhph87pnQMLZaOM2KSX2lNOQggGhsdgvua2Blk1MreHuN9vwnlvKDM6
         ynXYrYE6CFBzKYulFM2H4b3quxgHNrq4FsDseYpo+gM9qGIK73lDW/PRh05KGgcuXy6C
         MEzTHkuJg/4juCL0Z+tIl4+nEK0Erk4pAm41a3T0tQToiHaOnApkn+V0rIeMp99BMmUN
         HYYenV+B3NtTywTQ5qDggy+kg32MfNifxR+MLpGh4LTy0zeS2g7Ypp/tjL/h0Rj1kko8
         OL6zwZFOYn6rhHxFiDS1Z2GRL53tbGpzq8bsDQSdqC4mjFoU4tBnagfBplQMRPjbFwkU
         2B2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEqUskru68Zdo20WPUJH9nzXiPXkcn5w4K9HoOpP2UurtooV01yHeChSi6TJdrLuFWlsTTzrGTeQ==@kvack.org
X-Gm-Message-State: AOJu0YzjpaeUxbKYBtTkWjrpI5mKXpdOvj4199xlXYggXO40JYkFDv5s
	8ZqMnpxNWDhXaYOOov8DcKwBceD0GwIQ5nwYekXNqQrjlP+fVNvQDXzD
X-Gm-Gg: ASbGncuVu3H4YVo7uUdMNuLsACDi/+aA9qvTb32Tos8cSM8fbjL7aZPOM/htIqmLtq3
	0rNBfhm0I7N8PRPsNFxiH05jr7cWJYt7KOc+YbUegONA+mCJGW4IuWAIrQYk+/bSB5POsElLP1k
	MRGi88/pXfayVaZUlj1PIpwsxY0scmmc/laDP0Ef7pmG39gnL1cvzmnIn9f9MHPCaHoWisHSVNL
	pFQMueXT+ONcQexLskx+0Tv066tuL6NV2QvDBvE7VjJTz6Tw3mvlLgfh3i8QsdnH0q59TXRlOHo
	kmMSnd5p5HOmtCs654EmwyX4Qx1TR9MCdgbFRJk6PWj7lfuvRQ3zWrqZRwXDBHzyV+0S8rjZdKh
	xa6LNxOcPim96VupNGSv1dpRLubM=
X-Google-Smtp-Source: AGHT+IHHc0KQu4fVuvjX8fgbXi8r9B9WeHJTzec9xAQPc3wb88MrF8wCXiddTK5zZ0XCMEdTfP3iDQ==
X-Received: by 2002:a05:600c:c8f:b0:45c:b55f:466a with SMTP id 5b1f17b1804b1-45ddde9295dmr54866415e9.15.1757304451344;
        Sun, 07 Sep 2025 21:07:31 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a04:6f00:1::ee:b:1086])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45cb5693921sm228428405e9.0.2025.09.07.21.07.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 Sep 2025 21:07:31 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	Liam.Howlett@oracle.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	usamaarif642@gmail.com,
	ziy@nvidia.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm: avoid processing mlocked THPs in deferred split shrinker
Date: Mon,  8 Sep 2025 12:07:13 +0800
Message-ID: <20250908040713.42960-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3741C1C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cmef5ewxshb914j4b7t4tbuqwzktp4q4
X-HE-Tag: 1757304453-433237
X-HE-Meta: U2FsdGVkX1+x5qBtPekLcmmwko334aSpGGL0fGaIOVCf2uEiUw4sBmCiC4LsVfPASWDyFCjz4OwZ0WmI3gvK+vupUl9d9g/U5kYEwsyglshA97Ty57f52TAxYhu32t2YTkjc4eiOkR31kK4yd4sWva7pncyTiAtLX+t5mROVRr6NcjwrRGCpHzhJQkmzfnk6SsCNhdbDCGtebxtwwFrvD357FQ58GLWidRNcrGdHWxRJsYrN2hY8+hPjjgeuva4yplGqW/G7d44WyGeGBRN7kMVr2VjSY1wS3IE16PcEc5yLZ4engStGXEJauIn5iwWn3LzgJ4NfSQdy1zBjw8Mhcfl8dWk1fNsTJ33Q875aNQic8zCTT3qHltlD3826CjmRafeSzS8dHmjE2BEbUHkQFEsz7T2eEKouq5LLuJRHXen/+FLWdfTUFiBwYCEL82TjX74TQFBusHyMlm9/qlDnbjqf1eF8Hav3TufnFqu6xUS5wkXkk/lKO34JLM3fcF9cooOMOeXUzYEBahVNfhAK+Y4frP2iNJvHgfSP4F4lSBECZPzwVxpFjuHUagBQecl+SaUXBWHMZMT/GMjU970Ot1YErMqNeOLMzJ9PnFga69GboEEjek1VOYW8qiRFidPFaX9p5bymbGSkI4anBHVbFG9A58Q23FJom03tnOHJoTxc3w4m9ih3NL/+aLKKzdi9brmlR2QO2Y9dQP7c2OMKHQYnkK/TQiDJzVrPtV8nh73z5KjKdic4tClr5pZgKg+9KsxL7dTTxtwXismx7RpCyyhnEUawWdsi0WwNCy+/imFgLXZMP/5SzEPBlz8+uXzTWymuR8nVSzdJZLTR/o7WpCYA4eGzxFRm7VBrKUrLw8aweYVNKLP/Iq6vMNf7aVomHIMhTWI8yPAZxhzP62k0uVDVj/eIHrsNtYnVYIBqcVWplMgRNF8aEqR3bXYH4B5pUlyGMBnDxnzfo5kSg16
 +wjgSf1f
 gaNTl1i8lZQbxT7d9E1p7GByQLtwP0dDnK8ik1qB9vkMYWuDZORcdeORWVerQdmcMG2ufNnF2/VUL/dUUwsPZGYisqxwMGV31tgDUzzGH+/grtnZuwnzCBOU6Y7gdnLb5PiDgJqAYHlOh3IIfJ30Mf/5eLDh9BvLhnRE7x9yLG0nJRU6v+puKiDq9gup1KuRGHU9gUFuuOxaJheLE3jfeOJokLLBy+uCapBkjdHyAEihjpnCcfjuzD00yY3FEB8Wcxr2TyjQK0DdOAN3xG/W7CALc4frB2eQYmzg9ZG6qVW7P8yTTeKyQsII+375esO951uoJ59YpiBLACW9ga3dnZOlMZdHim+cZv7ilvsy4JkKMAhEjO3bxyJBJMN9YXheLCNFwW9igUwLDekuRQ5w2M12MFntbRKaGoABTZg9wycVX14vRdzBhwLLvntoNq576Wtkl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When a new THP is faulted in or collapsed, it is unconditionally added to
the deferred split queue. If this THP is subsequently mlocked, it remains
on the queue but is removed from the LRU and marked unevictable.

During memory reclaim, deferred_split_scan() will still pick up this large
folio. Because it's not partially mapped, it will proceed to call
thp_underused() and then attempt to split_folio() to free all zero-filled
subpages.

This is a pointless waste of CPU cycles. The folio is mlocked and
unevictable, so any attempt to reclaim memory from it via splitting is
doomed to fail.

So, let's add an early folio_test_mlocked() check to skip this case.

Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/huge_memory.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 77f0c3417973..d2e84015d6b4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4183,6 +4183,9 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		bool underused = false;
 
 		if (!folio_test_partially_mapped(folio)) {
+			/* An mlocked folio is not a candidate for the shrinker. */
+			if (folio_test_mlocked(folio))
+				goto next;
 			underused = thp_underused(folio);
 			if (!underused)
 				goto next;
-- 
2.49.0


