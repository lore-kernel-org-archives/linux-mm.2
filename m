Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C8FFCAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 04:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36FFC8E0005; Sun, 28 Sep 2025 00:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347BE8E0001; Sun, 28 Sep 2025 00:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D728E0005; Sun, 28 Sep 2025 00:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12FBC8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 00:52:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A31D7160934
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:52:18 +0000 (UTC)
X-FDA: 83937437556.26.9CFBCB4
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0543D40005
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 04:52:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759035137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=MDeTOOsx+C00FUGoSTYTsfkYGe7/IDMgbdTfsuLqCIw=;
	b=TGcbQYr7iiTLZc+5GQR0JX/QC6shOP5kCnxT1Li9eixuKxCUfvGgesnjtva1KZWZnBIjVH
	FBgU4QXLBJC4azdGXUz64eCwdC/tkOVx28Wm5PkDdwkKxlBJb8rOlqsA1aNd0GlcMOFkXd
	eGTo80wfVDL+M5A619s4Xf2OwoiBqj0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759035137; a=rsa-sha256;
	cv=none;
	b=sFdAVrEazoXe4VGGJT1j8IFDbhkO9dUVdCUEKczaPp0EAxP/ye4jzuaBfUoYCXbWs9pZC3
	lZp4VVFnr3viEM9NOBEczp1JM1aZQegFe7yeTlkZ4EZ+/HyXjo8tKYhu+f2u1K4sl1b3on
	HzsWblUcThMGXQyMy51kh6CdxEiS0vs=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so2669229f8f.3
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 21:52:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759035135; x=1759639935;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MDeTOOsx+C00FUGoSTYTsfkYGe7/IDMgbdTfsuLqCIw=;
        b=DDn+PX+HW+weefBCun4DK/UHBHlkjeNoWl0yuYE5ZEY8vguaQzuqV4YtJpiMAmk4/o
         MKWjzJj+2mSPL+P4ssT1vVlxvknaIPmnduLXCPmz8OsuFobHhgWS4MqlzC/2b/xIHpA8
         RzUaHTSQijs29Qs5PUKQgPGk4diFLoDeHiqbIl2mtNbWBS4UU9B07NgL7UqnwfsuftIM
         LuShfO7O8j5gsXNFE5Z7bGk3fslyP1A9JwD/PmWbB4UzLOm0vt8sUXGrRb2Rz7doMuBF
         zAcdYF4y09NpJxdaWVYwPeQsWGJPLngvBAvWEqXAQjVldiib3Y0Xt7P0w1luBz5k0Dm9
         l7KQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHfeTcLYQCKi2+NZxGR0JiXF8gBb5IgR03hhZbGRvaE4P7VUe/tfJljhITqLt9KlzkBbELR4/LIg==@kvack.org
X-Gm-Message-State: AOJu0YxPF20fG/2EJxIxEoPwzLebxa+LXYdyc2lhVWMTNdD/oyINFMf5
	8Nn/UwpZR5XibrsUtjbCZNLBF9UwNih616DDqisAYuS9Qvp8rxGMiV8r
X-Gm-Gg: ASbGncvOiJqbJlkOjBRMR0A+pb55/DZtzHR7lNS5J24ubIlOLHIrEs0ZATPw2DxrDj0
	P40eg/Ak5Q97AFMGR3YsiuqfMkamTfRE45e7bZD0VjCW5phJI8mSvtSwE2zGK99DfV0oi4KeJjq
	2004i/oTsdB542Icy9o4qzCyL/qRGM7C3Mj9yZOLl9Vr8XgmWNQuVEsxIdEJV8iM2WzGCHK4WeF
	2E1Uadp8i5NpKl/yp3r+LfhehqGL6E1BBt5KY4Wu+5kZkCWB6lL+1sGmmgAIqPoG993MDzksO71
	4FKTggbfz9Dmgf8pVmj6UPh6ZEIKMHo0bP6uq1t0qKe+YUbohNtcL4Sy93ZThP0d+SfPT6HbpfE
	4qIYsf+a1GYgi
X-Google-Smtp-Source: AGHT+IHVzH6CutqdZ2xPOWXvoxdwHZpW8hcV6MdTmJ329VCEuu3lj8BtnISnCCqCDPg2So93Cnj9wg==
X-Received: by 2002:a05:6000:22c2:b0:3ea:3b7b:80bb with SMTP id ffacd0b85a97d-40e4ce4c5f2mr10247690f8f.58.1759035135383;
        Sat, 27 Sep 2025 21:52:15 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::302c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602efdsm13539465f8f.34.2025.09.27.21.52.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 27 Sep 2025 21:52:15 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com
Cc: xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	ran.xiaokai@zte.com.cn,
	yang.yang29@zte.com.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm/ksm: fix spurious soft-dirty bit on zero-filled page merging
Date: Sun, 28 Sep 2025 12:52:07 +0800
Message-ID: <20250928045207.78546-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0543D40005
X-Stat-Signature: aetjmottigfo5ay6jfow4sbt8qawjqwb
X-HE-Tag: 1759035136-384493
X-HE-Meta: U2FsdGVkX18nloFaEpuUoj5EgXzkWvl/NIMPx4XbX6OLe5m1r+Z802TwujTnFcQzMiFCcmAcANZddXT/dNlWmLkSJAARp9qeRwSqlNfvjdfk8ug2BC42bsX4l5AoUvQcWiKoZhj6iCXpjPdx84PPhUg5kNDeFK+xo49HSW9gy5p8VBc8lRG+u3vrTS5Ao2BtP1XdBVvnliFaiMLL+/6MLQCyT5BZ8qbaNwso/FSHGmV4IyhsOuNRG8HFu+VJga/Xx12u4nrFmXJ/40cMnOY+LdiM2JuWO4FatoNSJXYO6p8/oPgeTy+5dZ3PWObQZe5AOJ643zuNE/+p31Dg8zey76b19PpV4O3bmeK2S5bxmWQKR0JYBsW8IEifeHMLrkliUIra7JsqJdnqG7ghW+ey6WGsKz9dw+FNC0h3Xz3oNhFHDA7qhh7uOovR1MJisiRe2RXoRBfEcg/vtczu8g2diWMntHgfVXe4ISW1xVn5UCwUlIreaGAGYe0eR1H3bEkHXZGwzygYww+UjFGcckAqYV8jSy/oIJSDhhBF26BfiEOtqRwWMCrUTA7Nze2lkcszcotYiLpPHnC6qEV/yTFUvw6u+DIdjZQ3GGTWdvwdQJJW/13qX438iC+hSMnES3enZyUqk0G6/zCw8iFwNM4s8QPdJRl75ycSMb5nJBLMahhspDlACoW0j312Mfe4a5avJWuNEc4z08F39olJekeZFM+RL0zMM6G9y0SDEKF5n0cZPMmG3P6kYDVeZ7DXGGVBXqZMtsjyimjC/JozgowH1p5eKCpdTLjZmOzibJ1D7Iw6wNb1IYJc9tOruHb0o9zTmhquUhIKlaGJBvYq4rgg4fUKSx0nXgu9CZJQe+C3OYmErbzdFBmEEyvS0h6ad1YLEdmjPKeFnu6H/27/fwzFJReVpAsZFcCEJiiG3kSFSOR6gJMhmZh2/nUmBjeifcLN863RjMFI5E9NmOwWrBW
 9J7yBi9N
 JI+y+kxYhE8UGnv2Rfw55zcyAsI1NSqGstF3XPiAGEmYLqqDi3VxZy2WndGtvmXRLJusH4Wf4hWX59xBYQsudptQfThXCTrGkp3eH/10Mpco/COXoYhDnRHd0bQjiwRyQ5XZiixvP/GURXpO3cOYxuWaKqc0v9V4ffEIYcHwD+UdQRFOye2UeaxX5iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When KSM merges a zero-filled page with the shared zeropage, it uses
pte_mkdirty() to mark the new PTE for internal accounting. However,
pte_mkdirty() unconditionally sets both the hardware dirty bit and the
soft-dirty bit.

This behavior causes false positives in userspace tools like CRIU that
rely on the soft-dirty mechanism for tracking memory changes.

So, preserve the correct state by reading the old PTE under the page
table lock and explicitly clearing the soft-dirty bit from the new PTE
if the original was not soft-dirty.

Fixes: 79271476b336 ("ksm: support unsharing KSM-placed zero pages")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/ksm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 04019a15b25d..e34516b8fbe4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1403,6 +1403,9 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		 * the dirty bit in zero page's PTE is set.
 		 */
 		newpte = pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_page_prot)));
+		if (!pte_soft_dirty(ptep_get(ptep)))
+			newpte = pte_clear_soft_dirty(newpte);
+
 		ksm_map_zero_page(mm);
 		/*
 		 * We're replacing an anonymous page with a zero page, which is
-- 
2.49.0


