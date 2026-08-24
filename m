Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85370C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:30:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601486B0092; Mon, 24 Aug 2026 05:30:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7386B0095; Mon, 24 Aug 2026 05:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0746B0096; Mon, 24 Aug 2026 05:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23F166B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:30:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A49F21A04A7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:05 +0000 (UTC)
X-FDA: 85135641570.28.01FA1FE
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id E408A140008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:30:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=feRmBWua;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DGZ9Z1DPfEdVHcTUddQdNEyq05aFRAjwLdFGsMJBr5c=;
	b=1L14Z0Ln5oiepkq6W+khl7PtkTsyoEOWWRKQ388uTDwM/IZKkiVhWoL7rqvwICYX2CEgu7
	zPfrOnLz5cpwm8nt1BWCNkdGKO6UYMm4bDOA35iIWzQsAmOXoViPj+2iDtOOgIZWbZ2qXY
	W2Vf1bMQqqj/v3zDv+T+kJD4KzXMLgo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=feRmBWua;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787563803;
	b=J3uaYaclYkEuLO4DOy9FazeM9Nupbjhzgl9RDpm+UurGuMjT2MTIcsqpR5GLYlZt7oC74O
	fTTL2YgC0Qx3dVGgXSju9A7oYPSQE0CRDMrzKZ2qZSPpXi+tN9EjC8CE88eiCN6PIWXDsa
	pLr/3ry42iD0F4yMBkgyRpCjhN4FYqI=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc11a30a259so3322456a12.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787563803; x=1788168603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DGZ9Z1DPfEdVHcTUddQdNEyq05aFRAjwLdFGsMJBr5c=;
        b=feRmBWuaWIXZD8zb5ZZpEkj/d3DBaTivxAuhYbBP3oAm8/W8+fAOP4so74+9BkTHfJ
         MLBkwUTEeUXK5PCsvdnpNnpIWUq0ngkca+vmTeA10KxffN2rGi/NkkD+QH+ReDatZiAb
         fq/KyT67fsxN61EKuK7nOHwcj3ipPd6vJM8AYRIgh19nFoBqg+3DS+zGQvlibSJfnQCY
         qSV+u+lekXhFI2aSMBEKgLeAEMHA5xIK8VM30XbCCfempgNKSCTidin5wPsDdKHiQMU+
         4RNVQFb49joUaWRgZSdPP2DUc4nBqq7BTlQZk8iK8k/vfs6HMEiJ2Azec8nv9ovpjUYG
         owFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787563803; x=1788168603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DGZ9Z1DPfEdVHcTUddQdNEyq05aFRAjwLdFGsMJBr5c=;
        b=QyrTQ+m1aK5X8UEmIJ1PQouUZEpZTI8QwdZp1JIt6AxyJk80A83dgq5ujvIwmmiMR/
         LuXb97XZoD2SEam+5eiYXG23lNbZayuO6onc6XgcLRg/Qa3fkEl3qxifQgXOE8wFeRBH
         mY7iITx16RQAdc4/bpMzOXiKpNo5Gb1MkNgXABxXYkizvXH9M1AL/jOToAG3Ldxn5BK6
         bgeuYLOOmZlBzYuaYKL9k/nRoi4+IJut48LDlrPLGpIHQHx/mth9zcHhxQY3VoDG70Zt
         VJF/U/RfZco6r9MNRVFNcN4oUrznFOe7t9gzW5WI//P6nbevERWbpnVVN4DnzGOcL+bW
         3Bzg==
X-Forwarded-Encrypted: i=1; AHgh+RrF04EBssI91SH8WMVyHK8OHjYWQHDL2krlRUXxJT49JKuiGolb19wgGS5GGLnE1SubMgJkt8saHg==@kvack.org
X-Gm-Message-State: AFuF++nHgXtIK9PtnY6aZXz05NzWxxGPORnVycnQnN0zoah0oWt+aCW+
	oMnoqwWGWZTPvJOlGqOyk2N2vlBBURH4aQCkqXqpowEnAGBhWy3l7r6f
X-Gm-Gg: AR+sD12jzbY9YLR88lYscV+lLBXG+GkpbCoHl8MX9mf+dXHD1DhI2z5eVsplf/QhqQP
	9BCA6OVePqmJW5cvpqy8cYLqzXYB8Y8dZrq4I7B9JkBOfPjF5Ue1Kn9FMSNZhItsmZxA6VGs3Fi
	N3LY6Bbve6DVn3osJXD02mGizR1ueiovbUz3rVbXV/MTNEfGfJ0odnhbLPi00Er/zy9bDvLZnvA
	txAVKvYA1flj2pCWR+fuGJHprxwiQnK5IvTUZab84lFtVctT9savG1ZGk1bXeDvkjwkZE/5ZN9S
	VmpCNa0WdAJCtyRncHuBlZRXTe4cxcbVQBj0Av8Jp5OrIVnjDzHKNjLfKEdFepRUk7gpx7zEFL2
	o2ng7NvYOeThKvePk3q7CwJRm8tLQ9SpzX2xZ9ATje0jIwfjeUfchQr9AvnKN7qBR9/3DzxptCj
	P1SOC2CYQ+Wpm1HNGPvfuFBrIePM4KdAGuuUnlPbMxs2yk866RAydui9iY6EVohZUTomPFk9YEG
	is=
X-Received: by 2002:a05:6a21:d89:b0:3cc:f008:8125 with SMTP id adf61e73a8af0-3cd4b9a9fabmr34624401637.1.1787563802568;
        Mon, 24 Aug 2026 02:30:02 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc199e60035sm845226a12.22.2026.08.24.02.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 02:30:02 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v3 0/3] mm: khugepaged: fix tracepoint UAF
Date: Mon, 24 Aug 2026 17:29:32 +0800
Message-ID: <20260824092935.73892-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E408A140008
X-Rspamd-Server: rspam07
X-Stat-Signature: bm9e58xtiqqycsst13weg6gdx9fwmzdz
X-HE-Tag: 1787563803-850820
X-HE-Meta: U2FsdGVkX1+uPK/HWNOS6uvDrIT5K889XzZ11No12evgKC5LgGgqhlbqIRrjUzOKBgxbYpWy0adkAdlRN1XSnPO2aPgnb+pcvHwODRvZ56XcjgRxad5WboWbbAR95HojxEaM5oW+ZTsCN5eHJ6NVHKKqeCSH8fXUTDoeI7XizPTj0NpYV8OFLFPqiUFbkSZKoEOFaMK32mJWRUtYQHnHGCFic2xQ84fmNVd11NDMH4EbVg2H8e1GR7HtjqzdZ5WEVhmzAZxKIBrmbPWNERN1gECPPyP8q/vEM5/lIXoM2uz5kM7lQfHFcICO3dQJNycyiBb2kASE+zbQ+VCXgd0Y0pkOBMWnTGx3DYwV4hBTVu2DALHOmLBzgFVBQ1BcC8NJEAl/Cw68/zeQxzujFmNF8Wl4uu8k8wKJ/WG/OG98+WzHv2o3SNIlzrIxyPdVwoB79jvOwbNLTAs1XHVFLctO95nDjtXm2qfDs9nTUG0v1+2Woo74BEUut9R4ah2g0OQA47JzyW0639Z8LbJuorWU027TpRWDJiZ8IpPSkYi/3bCoqwgcspjHfAK3onRcmT1FZA/05QeKE67ineYr8vSlgurvzuv+zhynjFNhvroMk6er93UGz7MR9R+Jh7lsiD3F1OL1ew9climi5OTcjeMMlWDYUo1Ojv2xs2M217y8+AbKzAIqVcul8Czg5IpKg4zFxKq5DcFu2eh11rPNg+BgSD1DHYVoEyCp+RkgObpNRUhV4viSc52N4vERw2WnCcGx/BTIx3Ha2WFXi28qt9zo5MOwkpDFZcLdxhKlHnUU36hWRAgtvXosKGfpfMeV7o3MSDrXRjbRCVh9Lp+jGtxmKBsol7/GR9b0XXOdzZ++tIDlKPrlaqbYjt4AxIYNw7wx58LECUrOg9t1oX69MauvqQFLfVBBQe3eqXbIY9cidgx22QXhPEtqHovMTuidvmAw4SPb4bd2TXaRZnNnnbt
 YynxOgf7
 GGWEY2nv9lFAcofKkuMXUBAryPdgDq4/NAwJ5Jt1y2vOL6xZcjIt4sVTmqmpPScC41J8QI4LA8cPjMdNo9y/tPCHWh5TgAAMIpkDG+UAhh8HhCLIrrEDDvN7eQVcMTYuyGlKWg1TkOsVTbpaBnGLKeLFdPH3KbR2wVNbAAM4BKrRvr43eT9EMq9o+UmIBLFQ4kfH/FnyFdBkuN1CE7XJK8D+tOCTGmcURagmWpa81iFje4QAKdMdAkAoQznFJkk/wzZe+TQc5F8VTkqkD1rMSKEERFkHlUFCFLb7U2E3p5xaWF0H9JXkIg3NQ3bvGCH0aS8z/oBQlr5kK8LXwedH+RmT36vEcwXWr0mx9hR6CoKLkAqDxFvYz2M8RUy6XyL+ZesDspzZ0cnw2FIYpf3MQKPXTXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

The khugepaged tracepoints take a folio pointer and call folio_pfn(),
but by then the folio may no longer be valid: freed after folio_put(),
folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
xarray-encoded swap entry. On classic SPARSEMEM, dereferencing it oopses
khugepaged as soon as the trace event is enabled; on other memory models
it merely prints a bogus pfn.

Pass the pfn to the tracepoints directly, captured while the folio is
still pinned, closing the use-after-free windows in
mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
mm_khugepaged_collapse_file().

This series is based on mm-new.

V2 -> V3:
- Place folio_pfn() inside the xas_for_each() loop in PATCH#1.
- Already defaulted the pfn value to -1, to simple it in PATCH#2.

V1 -> V2:
- Instead of passing the folio, just pass the pfn directly.
- Using the folio_pfn() before dropping the reference or the page table
  lock.

V2 : https://lore.kernel.org/linux-mm/20260815051924.194810-1-vernon2gm@gmail.com/
V1 : https://lore.kernel.org/linux-mm/20260811133655.267739-1-vernon2gm@gmail.com/

Vernon Yang (3):
  mm: khugepaged: fix swap entry value to folio_pfn()
  mm: khugepaged: fix folio is used after pte_unmap_unlock()
  mm: khugepaged: fix folio is used after folio_put/unlock()

 include/trace/events/huge_memory.h | 18 +++++++++---------
 mm/khugepaged.c                    | 15 ++++++++++++---
 2 files changed, 21 insertions(+), 12 deletions(-)


base-commit: a032d41a86cb82a747bc14d9c82b3e153a9a9ab7
--
2.53.0


