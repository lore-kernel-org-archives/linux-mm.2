Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC368CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 11:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533A58E000A; Thu, 25 Sep 2025 07:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4E18E0001; Thu, 25 Sep 2025 07:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421308E000A; Thu, 25 Sep 2025 07:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32EB78E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:22:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFD0CB9B60
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:22:52 +0000 (UTC)
X-FDA: 83927535384.12.A81C4C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5A14FA0016
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:22:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OGgHpGxJ;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758799371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ynT/KcSEPgcvXp8oJe87fiXQ3vmBqLD0XZv0bdPzvc=;
	b=uA117CsYchPa8strj9oE/mOq+rSH/x+kfYlTq07u/PJqa8BLce1bukuFzOyIfDcJbKVGLb
	JHZdter7ZDaka5qiHJj4q6U5e67po3DOYdtB9a/tA4XHHXM5pRv0szP2t3pgkhZiOo/828
	gV+rzvQPrqJNA/6MMILIMP0BWE8EHR0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OGgHpGxJ;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758799371; a=rsa-sha256;
	cv=none;
	b=YwZatEUmCnF6GYgEDFTwnFJfeHe8GU4wwmUDLMRFa4vCb1inZueo38UpjEr+Apc5dzBBPJ
	cBbP1KilQA/Bw4844JGRMlWhUcwLYi8MOTV246C4aWMjfid3ggDoiqcfO3ToHLRM++nYWD
	2qQItqkd4IHtSYacSADH63hCYJJIaVI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89553604FE;
	Thu, 25 Sep 2025 11:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A71C4CEF0;
	Thu, 25 Sep 2025 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758799370;
	bh=7TY6Mv3GwQKn2+eNHs40STB/z7xZBiylOf9OH7ebP48=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=OGgHpGxJfEAD//pye7XhrdBdEIhkzl82PuN1xG6OAN75cjulysEjTDqJBVQsKMi5k
	 5vactApsBqJ3kNJoOtqetfcrquQnTyhznPvCFgl93rBrgU3qYHIKF009R0+iJ5oxS0
	 MUIY+CV/PcVMYs66C2FZUJHD2BDRM0PrTVAFyRwkKNMpNZY2zAI9NkWimrMXNIr4oF
	 9ufivXjaY4WvfybMmXR8BPiTzbW6IUXtM4yLrCSh4tvAKjzYfYbypNmRfRRznE+UsI
	 T9K3JWhWHTJUDUQJ/2nrPko8f5v/MWhexD2+ZS4NADYSZdcrZppbQfkfEuSdOAxZEA
	 b8pBHwFAHMS1w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Jason Gunthorpe <jgg@nvidia.com>,
  Mike Rapoport <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Baoquan He <bhe@redhat.com>,  Changyuan Lyu <changyuanl@google.com>,
  Chris Li <chrisl@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc allocations
In-Reply-To: <20250924140010.81305926b42d0223dcf3b818@linux-foundation.org>
	(Andrew Morton's message of "Wed, 24 Sep 2025 14:00:10 -0700")
References: <20250921054458.4043761-1-rppt@kernel.org>
	<20250921054458.4043761-4-rppt@kernel.org>
	<20250922131948.GX1391379@nvidia.com>
	<20250922143407.93e171f8b7c09eb21159a33e@linux-foundation.org>
	<mafs0ikh7dg54.fsf@kernel.org>
	<20250924140010.81305926b42d0223dcf3b818@linux-foundation.org>
Date: Thu, 25 Sep 2025 13:22:47 +0200
Message-ID: <mafs0a52idbeg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A14FA0016
X-Stat-Signature: ocq4h4knp69tc4s3ir69eaxxu85qfeuo
X-HE-Tag: 1758799371-807720
X-HE-Meta: U2FsdGVkX19p9IAELrBKwmsNEcrDeurBWkLL1zv55niJztJM0OWYyfDxwrbDToNYn+Fqi2PxiJ6ljhFqzjRFoUqrNXQzpUKspUXAgJgmbwm5On7aFhqa6DG6kkQ22M/AVEdC1cOxckcth41LuYuDcFBIa28DCIfPn6EVIphJkAbCMAglizFjOLjpMbgqK0oMuJzUDuSlE89ZdLOUUbfFbbyX4Ol2JA6HDmM/lVs7L6px99vMj8DpvbtG0zAYBKFeSuJARkarmI8YGeOeQMzCD1P50P6sxv5Ls1XQRIENw1VA0lN6BLqZlWCnFHD/l9nJNoyBkTpHiVGM2Hs9+zLugnvc/z9aaIEF9no/u6ww4tKWqwlBQAhxilz8BZzv3a85dHYNGpjEOrFOLhEYvGjtzjagaV4Fx5ux5u/L04AawE8YPCD7NrnBsNkVzkU9eE/8z+LEDK5RaVGXPQwZy6F8+bfXQZk2MVt6aOaOR6YLF0WHj7k0UKDkNkOq8Gv4+3E8cxEdWMzwJ+8AcXRHzIioKoX86WpQ6Wlxgm8sG7v4dDhPqui9FOqcR3bEiba6zwZypFrnj5KwsfBRlIYOVoVRC38GFUP130mI22PjRFmZuwl8SFNwAE+t1+eFWC683CAn0xpnl2T6V8+P8+mhxWbTmGR7tYxq2xTwHv26IPDgcum7bwpFJBa3gBTaad42bX6KNdD+QrMr020RCGbJbjNzCUOl0qOZ7jQqkKfui1y15aE3mPVtJPEfOo1usZGvkrT0iCaSRi9BJlujDSiM/s2BzU9sKbZO2oTQDXIw8ZIuEy/aWMGzhByJN+Qr9D8rQq6R9vT+E4M/vcq2saokdrKgrIfMICRGNGTsN62CZ6AJieXSA6+4VF3G950okiGe3s/W4TGjAesHs5j5aqXM2U5/oFzqnwxC1zdT5tjZYSNxm6rLBY/ayIW9QcrGmTm4/dyn+AhuMuFnA0QABu8PVZS
 nvGL04LG
 yrJwXEwEEbCDft/hAx2e9+aUY2S6f/YjIUSSrViFsd8i9R2WD+wpR50AP9HnprDgq6fcCVrrAPiGjzgGGdmkGyAZPuVjqXp8n69GcZBPYlfXtb6XW/k1H5Se5X2Wlt+1MuEjOM4h5G2/r5ttbc/idvJmaxcBV/u1etxPS0uB5aaRHPvttZtgrUyyZazyS4dQrWfne
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24 2025, Andrew Morton wrote:

> On Wed, 24 Sep 2025 17:28:07 +0200 Pratyush Yadav <pratyush@kernel.org> wrote:
>
>> >
>> > Not sure why this code works - I'll suspend the series from linux-next
>> > for now.
>> 
>> It only gets called in the error path and that didn't get hit during
>> testing I suppose. Until v3 the chunk was being allocated using
>> kzalloc() so I guess this got missed in the move to get_zeroed_page().
>> 
>> I think Mike is out of office this week. Do you think this series is
>> stable enough to land in the upcoming merge window? If so, I can send a
>> v6 with the fix today.
>
> A one-liner fiup would be preferred, if no other changes are required,
> thanks.

--- 8< ---
From f746718a99da3c670089a42f7c59660b455f265d Mon Sep 17 00:00:00 2001
From: Pratyush Yadav <pratyush@kernel.org>
Date: Thu, 25 Sep 2025 13:05:08 +0200
Subject: [PATCH] fixup! kho: add support for preserving vmalloc allocations

Chunks are allocated using get_zeroed_page() so they should be freed
using free_page() not kfree().

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index e6380d8dce574..d06ca232683cd 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -885,7 +885,7 @@ static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
 		kho_vmalloc_unpreserve_chunk(chunk);
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kfree(tmp);
+		free_page((unsigned long)tmp);
 	}
 }
 
-- 
2.47.3

