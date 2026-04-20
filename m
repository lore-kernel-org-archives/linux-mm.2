Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B15F588C2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB486B00A0; Mon, 20 Apr 2026 08:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA346B00A1; Mon, 20 Apr 2026 08:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12106B00A2; Mon, 20 Apr 2026 08:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 99C256B00A0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:51:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A07BC30E8
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:51:02 +0000 (UTC)
X-FDA: 84678919164.11.7EF6B1E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 19F4D8000B
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:50:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SwpX4YwD;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776689460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gARj7YpNrf8B3cZamzB8laaN+/4Ge9ZNHV4aaUa3toY=;
	b=2DAcQbL7Zp9naClyOdyriz4iCFFNqCmMcgsw3anqgYFf6GZpkzEzUp4FEYG5TffWCjqCrG
	Tg4+dsZCBo5Q1MNqppMZT63LSRmQXFCy9BDOUFW2T2pHSN9rHM4P6sR1gPT7qoJ08wErY9
	/jHpa7FfDNcHszkMfBq4EQqYqOpY9mA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776689460; a=rsa-sha256;
	cv=none;
	b=nFvC23GToNk8DgMv7N5yQfV+4EL8lV06nvVYVMZPTdjSRszq3VLG3IpFxY/WgojAsZNalB
	EosADvNUWASyxoJwpUm1TI3+nwy4FGFd9LHUxhDE4f6NfGkVBDxBtja46+dzQ4Iuz+dw7T
	2peCKzkBxf+Ls0Mm+t5ke0P/BBUebds=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SwpX4YwD;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776689459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gARj7YpNrf8B3cZamzB8laaN+/4Ge9ZNHV4aaUa3toY=;
	b=SwpX4YwDbeYZLnzI9vIwis0TzBiB8ohoczvUrZa1ZBKfvEinxLM59DR5rAZV9lrBQq3GTG
	jVhg31sGNAMM/1kgwJzYsSrw+Mdx5L4zoWKgAWyyhQwTUmD/ewIniZ1RfofU/JL0+CQpV6
	64XPZKqduqXtOkY+KIh1UYorQqYHNRA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-8Hh9Jz0pPle3xTIzFlwv8w-1; Mon, 20 Apr 2026 08:50:57 -0400
X-MC-Unique: 8Hh9Jz0pPle3xTIzFlwv8w-1
X-Mimecast-MFC-AGG-ID: 8Hh9Jz0pPle3xTIzFlwv8w_1776689456
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488c82b4701so17090245e9.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 05:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776689456; x=1777294256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gARj7YpNrf8B3cZamzB8laaN+/4Ge9ZNHV4aaUa3toY=;
        b=ew/APekGJOD1A+qCJKxGIBDFcT3zK06lD97GqUHqzhl1LrisqeMjbqgQD5XIqxaK3g
         eBCwXIKtH+JSNq6oF/xFbERFpWvYNG6i4KZ07dGqsaMwB7xietU5ZizQhc43vu9jeLHf
         Bb1VH2wZkGSjlo1Mtn4Ly606a5usccgo2PdaQZGPykPrYfEjaMWehFm7irdBm6RhkHox
         4U0RN/6ydOrdjkv/JQOBMcKGPdBdSraGUpxHjmptCM/IRuELaUvtQ60y2KRvF/hLwyNI
         +BYx1+CV87EcmK3VZebK599JU7HfAyPQiZaknYKXPPhek7RSwYUFIuzmzFuMbXC/1jQJ
         Zv8w==
X-Forwarded-Encrypted: i=1; AFNElJ86MGRn759O+t+VVIyhLYwsmaft7MGH3kQA1mjAw/OrIymwGXNrJXPilVV/dV9x7+L6bgPspRD3FQ==@kvack.org
X-Gm-Message-State: AOJu0YznV8EeDB8TypGeNQPMibZrTXMPsiSx2lmJtzT/59p13OKxbOhB
	tHPJcL9pbPX4dbmjg6+SdhxNnkhdfYf+Y+fGsWEdvv273VdCGi6ddlg+qJVI05b3jpHLP2+MGEj
	w/ws9Hca0G2OzJjfMPnjECTx/PlsfzGldRZASSA/IUCJIIOjLju9M
X-Gm-Gg: AeBDietIz6nTEsKQgE05+ighUF3QiG1w/a0+BGEVHFrT6BfiA3mgsKRwo4hsFZvTOqc
	OsDyf/9kNdiTohnOZJLAgklxjwTPdkgGT08f3lRjB1i5fVGaHiTOP7AQxruMOk04/N4Q0DdMD8F
	aCGqSq2hU6c8E0vvQVOJ6yavL2VNs20BumguLDyvX+rwukNqcTOcLwcTYcyKPkls2REl/2AQM2g
	yuxrwDm2XdLpKp3PWs/1u3ZnoISpOvHSnSpNSnkvRfGZXmOJwzRQ1ayIidODIfXuSmhY6FjxLqK
	z6eRQ8wSSbwqrTiIM2RA8+mvqP6FxyUdojAcZw7YxJKpMQ1g+87BJRgQ+uJ7o5A6O/5oEeH50jn
	OobcQYkCfUqcL1rhrn+bOYzo/3QcVF0CTCeRO1/qUIn9UcaTOkVfb1Q==
X-Received: by 2002:a05:600c:3ba0:b0:486:faa8:9e4 with SMTP id 5b1f17b1804b1-488fb8b91a7mr175260395e9.12.1776689455577;
        Mon, 20 Apr 2026 05:50:55 -0700 (PDT)
X-Received: by 2002:a05:600c:3ba0:b0:486:faa8:9e4 with SMTP id 5b1f17b1804b1-488fb8b91a7mr175259925e9.12.1776689455049;
        Mon, 20 Apr 2026 05:50:55 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891c320084sm125739585e9.2.2026.04.20.05.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 05:50:54 -0700 (PDT)
Date: Mon, 20 Apr 2026 08:50:52 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH RFC v2 12/18] mm: skip zeroing in alloc_anon_folio for
 pre-zeroed pages
Message-ID: <97780c54dc083b9e3e0bfb4bb9ed7d8b1a576f91.1776689093.git.mst@redhat.com>
References: <cover.1776689093.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776689093.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Oc-_ANM4KP-DPUtNJlJuL8gN76Q2TGzVABLRn6OhrP8_1776689456
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: dsp9emuwtdgmb1ootbgzx41xhmiyzybq
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 19F4D8000B
X-Rspam-User: 
X-HE-Tag: 1776689459-25894
X-HE-Meta: U2FsdGVkX18Y279oijXz1dZyKxvYwPgEgmq7Zj+FbzUZARlOWLl8FhEoA+pAFYDB4udWZjbKsfaUOjRbzjbgHAzree9TdUpMnKPrkhwYeWC57lwjOAKDLOl73rL67zSegfIS7+BLtmA3u0ze8uHpHA4jGH+spCpK0jhkg55H3yuppF9142VWEQS54IUezs9gIIznLB5QCvZWD3DHDrFufWLcOSjOC8BxIe+r9oOH+j3gy8eIgLhIbegt+i16FkdwkjRgz+het0zhBSiJVqxp8KrapsiyT8FFLYvHp3IDep4O0PAI7ih9aSyb2hyEjJKyJo7HcDFx2OYUI/XTRB5gf8wIvabhg3rhYUGmy+OohPU7qN8dMN0aTrbO4fqbxIaZvfAUEcbHkNR3PPaoL/vNBnHI63VrEpsPQEMMuYop9ci+FKJGEuzEXvL4oXRa2/bGWj5vja7j0TC7mOOrHq7jAppwaQCbhWwEmeiHIz2zU+qRDCWE0kBvvIBIpaNBsebokmENPzKYRqU2CYX55xTHfebHtJt0c/y+ojy1wd+gT2Nq0Y42tPk71/9o+K4YkQzl4F7i/6i0dknT5ozv2tgywrT29qRGOmzH/50eQGIrpxqYRT9C/Jvd2V/3O6ZBEyw6ePWxFsVr19GfqWIjBV+EIVel0nvEXPPiTvuv+zd4kob8sQ6JbgvGmjKv6qk/7xplNZg+0xb/iWkJx2JJhcYiPdOm2iEYFwqJ6j9Z03Lk/pBajwIgcv0YTkJimryl/xzww9yqmC+9XJFalB/Si66ZqJIV82ijXa/j8jSDDNcmYq1ZUZlGgd+RUfhoM71ybvVVzPoaBJJqDdCUbB3eBTkFcCmGhUYwdDLOZxRp47IxmbrQ2Tj/cThZ0+6hbFyffu5TUgKdIso0+VbbISdd5yC6lTAscI5plEHPcO0hBKlSIYCUxpW34EAo1HRgyDuiFo9URQC86LM8C6h67mZ7YZR
 ebZZn6re
 2aothw1iGUMjatnYztlvFlm6xNBUQOf3KkFhbdbTlgyX8wXcVIauOOSYOeHv69jytE/U9paDlJt+mLqCmzDGlC2bKsXhV3wAFgRfzaE/2MusVLREx27/eSwj+NOmQ27olgkHk+7Jlj8C3Cs0ZygrUcKS/VPEI4GbgI/ZT7B2WhKBZoWPzXUyrsXKj32NU1etnw7znKkTM/q1NuQ/x/Zb+nuEG4BafVccEH03iKxguGqZC6I+id8iR/tSE9BkJeLWDL3nsP7MykIIsvsTeax6R3d6EVr5qd/cht+i4YAF8dQV23bRS8uV5/ojb3Nx0Y1RgsMJ7lqw5acfyFhlk0PJwj4MfJ8TBbgwLSPnuNK2FhH4x81GcQ+ZAwqlaeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use vma_alloc_folio_hints() and check PGHINT_ZEROED to skip
folio_zero_user() in the mTHP anonymous page allocation path
when the page is already zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/memory.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index c65e82c86fed..066e2c9781dc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5179,8 +5179,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
+		pghint_t hints;
+
 		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
-		folio = vma_alloc_folio(gfp, order, vma, addr);
+		folio = vma_alloc_folio_hints(gfp, order, vma, addr, &hints);
 		if (folio) {
 			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
@@ -5188,14 +5190,8 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 				goto next;
 			}
 			folio_throttle_swaprate(folio, gfp);
-			/*
-			 * When a folio is not zeroed during allocation
-			 * (__GFP_ZERO not used) or user folios require special
-			 * handling, folio_zero_user() is used to make sure
-			 * that the page corresponding to the faulting address
-			 * will be hot in the cache after zeroing.
-			 */
-			if (user_alloc_needs_zeroing())
+			if (user_alloc_needs_zeroing() &&
+			    !(hints & PGHINT_ZEROED))
 				folio_zero_user(folio, vmf->address);
 			return folio;
 		}
-- 
MST


