Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA6E2C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793AA6B008A; Fri, 28 Aug 2026 01:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D6F6B008C; Fri, 28 Aug 2026 01:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5426B0092; Fri, 28 Aug 2026 01:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3192D6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:59:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8956E160242
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:59:50 +0000 (UTC)
X-FDA: 85149626940.21.270C395
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id DAA6DC0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:59:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hUtqSCOj;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787896788;
	b=It6ByB116AtHYcMVw5HVVfTx/RNA6xhLTu+CYkGTa2a2nTEuaQ1df2EJTSR18smkSonaf1
	CTYB5rMl4RSxvY4/lNe3+hAkK9OnQwr8Ygz7jrjYCt/8EnU7PRIULAqgSdlq9irwNFzpR4
	qhpdltsrqZVuGfhoYXft5M7813ctVAU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787896788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GDl7OP4PCiA7ts1ANifq35vbIMUl1z7lISgn6jZCS6A=;
	b=ab3Q4HCBnUk0KkSsrOIx79UHyMd08oFgL5dKznjybYSB9ConMuSqnRu5cWVLFK8SPAzBIA
	ZNxBZtQbegPBTKEs964AyaGsp1VYP/5ykD60G9wwVotaRxQqIKD2XLc1N9b1ybKb/wUmw6
	H8oOmDeDEAux+PkMJK0TTPRWnimaF8k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hUtqSCOj;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso1091780a91.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787896788; x=1788501588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GDl7OP4PCiA7ts1ANifq35vbIMUl1z7lISgn6jZCS6A=;
        b=hUtqSCOju1kLw9GYTKpSGPHqDllF3im97k3dPPgq41twt14HzTBcEtHnvnZ2y4rraZ
         LDyTvjocwDibP4w7LZhcX8rKs+XHn90msCC0hBJKo9WSefqBQ5fgHsxPmxw66NrYB8XK
         NGOM4C+qOA4dfYqIEC0o5u4kQgizb06E6BBj5JaMTPOmCM2TD8JYD6MOagM8XZlQmLkH
         Dyz5A9R7blcV/yktL4inSdCKQ/rXYnsdF9wCWoOuDjg/taXV4P3dlHR1Qyx3/CtAFMVv
         JiezW2s8CVuF7VJJKNFoPG2Ghes1DCOu742rDA8lLBOA9foIRV8jHcfbMea44khv5gP+
         lGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787896788; x=1788501588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GDl7OP4PCiA7ts1ANifq35vbIMUl1z7lISgn6jZCS6A=;
        b=KNdAyclY3L8a/hiT41xD3I+lSCZDWQKupYQfcdt40BRi4et0CAsNzk6yo2yQq94fJG
         LZh41QonouaINQ14NjV7gEA3dPoJSACaqSZy+9hfH2DqorvKDiN50bOQ9l5nEquYc5Ay
         m2447uTGkpYH+Kw+oFeMaSgw7JGwOLBWZSL1CwlsGWQCjzQ7IUH3mmLSfpNi4zcpXCoR
         hzzIwI41sCZ6RVP/bbWT1BMACF1O63P+WGTTi8WZjYfGPKTghV473C5kClpM706Nc2US
         S7CZdgEd2xGl8VuehxvFT5cYi9zMnqwudn3BVORSUHsMraYUUx6QFZ+IfH4um0n8XjMp
         Kq5A==
X-Forwarded-Encrypted: i=1; AHgh+Rp2gP0FDeh0PF1iYAed8+BNJ2yfNBjYmLOrHqQwRFBXqKirsh0U3/aJ6pnjN6ixDs6ohF8MtkLh3A==@kvack.org
X-Gm-Message-State: AFuF++krRMLu03+O35oGZNiRDVbavGBhIN8ZsKKbpik1ELUQdVgh2wp2
	lMfdlSN9UtENxsVvslw9iNtxKBSxCzZxmSWQrNNmKmRtF54QsZXz0tU6
X-Gm-Gg: AR+sD11AxVCArPKfMiU6uyYSqiosadeIiZWtVEQmMRikdZfoNX4mLzXVGkPiD/1yMq9
	QXbTHVmZ717hIKPbV0rgz7nPGGG4Q731V7iT388Z76FRLO4g3yngKYJdyZ9m1vQ90noZC35+XFV
	qT7SCtTd0GrSVGwzn2YLiUNz3IbRsWBNaXVUOUmBWRvK9F3gQTdRualhgHFc2+5WchCKd5uWXP3
	7u1nyrrLFax4B4+e4I7uj7kSEQ+iBhpG70J7q+eM7numhM8v5ecAfistT01O8Yf0eOoRaB4p/tw
	nDq5VKpyfBNq9N4gsvzAITNGAPvN+CaXnZ1hoKF0E7PPHInNEIXg9Ew3bkrxro7BaOJDLRKmZPa
	vpsYw1CIxrZBOu64zj1uec3w4/6yZmcKsusrlForjlVGSXjeMtiWUaxigCGmiRMtHmkjmAJkqEs
	36eZ9BgBMWHzZY3pGsTMFPxU8DUVf0dp4JRQNZUwfM6Q6SuKTsc4Oeau+nlMHhIhYcFSLkyKJee
	5U=
X-Received: by 2002:a17:90a:d884:b0:381:e74f:8a6a with SMTP id 98e67ed59e1d1-396d10248camr9814071a91.16.1787896787656;
        Thu, 27 Aug 2026 22:59:47 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0ea808csm5826241a91.2.2026.08.27.22.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:59:46 -0700 (PDT)
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
Subject: [PATCH v4 0/3] mm: khugepaged: fix tracepoint UAF
Date: Fri, 28 Aug 2026 13:59:23 +0800
Message-ID: <20260828055926.346744-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DAA6DC0007
X-Stat-Signature: t67mjq7yzxt5yeh5wkcw3ig8a1fxi91c
X-HE-Tag: 1787896788-428654
X-HE-Meta: U2FsdGVkX18UHTfm6mow4r0chM0O4eAZVfRdHylDU7eFi9UNkpf1igYJRIjcxLeCbssOxt1SvbyQEgEGowcQkLiOkBNIXEKn5w/zUya/l7bS9GNF6GpiRWz/8yniFyxFCmPAzzQhTiI7JYvXNdM9cJ3m39xnHSDquXqEI+mMGL+6SV6NXpHNicZ+epXXzjLxCoUsarcq3k2k29bRepFT/lac6oEqltjZqD5DtK1YGKrvfBQ0ByijZSkT1UTlJVrRDKGMpiRCSVs+RpNksyFGU1pPDUe6EkBVUfzeoQkisY+/HWNK5nzvik3foASFb2C6TRsEmGdkEgasblNKdVYVkl9dRjfknAFBOpbdlwIFbmflfljgGBTyX2xgRhWxv5op8g+F50ACrjCvHuawhvhu9YJMiniodlGBQNzXndjiE9fBe+h9+lOFaW67fuBkKfTBJF89xJ+5JE1x9TxfSYKa9TepviGJ/8XCyWQyQNyvPZssrI/x25COSIv49q5VKBdn36DuJFYIzZFeoJ1050c0z9MamV8Hms3068FClcxl47NTjcR8vtDI1mSMjVGfZywpl+UlTrmxqRBsLj2H8MQZpr4gfE5e1GEDkkCDUqZS4A1yrfoWojoeGlwsX8jtkQu5zIAqXV7iSYPkLleMNBG3XAInWANUoPEPCBfAArq14DPdLJS+n9kiIYBFyYMBdiv9oFNSDUdNhczPxrK9EKMyKYYl5iy7ynMPOYnr9zmmEclQnb0jibEKaTu2y/oqtWHSIlfWpdiD6/11vNG3TxCjsi5oGUCNj0805b625yHiLzIGGXVFE+cZkN9S5Lp7aMURm4Z1ZYyaWahUlEzuzYVfYZK57T0aPV/qSTp8ddnrZVgkWFhtc/fnUEMQs9lhvGC6lzdakvSHssVcDLi+v3DR7CW+Xvgq85WBJINPA0pAq199VDVyN4N3D/qcpaCE37I8K35V3BtidtFw+hZuNei
 EjE1Fc1S
 JUMhPxR4R38HkLSVZ3npsxZ2pJcb113ujHF8LVwdBlXQFesjVTw8TqXqKx8sws7jpVExEsFyW7WoS9ulxaQencc+Qj5svqr7pyCSYjdk8MVdpENHQyD9HtPz0UvZqUvayYMw50Yi/9t29MKvYJxFkKESHlDEajkZD878pyIMpanS/Ti1vWLlKhWU2U5KstRp6N9WN+eIY9XpvEC2ukqEDdxAU1N7gj8rdLYOijyuFd8NiQldgIIxlBVWeEjC1W3eyfwDYDWElA6T2WRKUSsmftbsKgvUd5URMuSgJglIQFMG2DUVJFjk3KoN8n7in1sy7jYBbd6MdDMGQxcpdWMT1KxpOCAwY7St/1/rXwJ6qD8wn5uyH1Uql0kWLOXoFhf0cJfPIzkiCkrPq4NNpdg2mWt+MTA==
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

V3 -> V4:
- Only trace the PFN if it really was problematic.
- Calling the respective trace_xxx() functions separately on success and
  failure.
- Set new_pfn once after successful alloc_charge_folio().

V2 -> V3:
- Place folio_pfn() inside the xas_for_each() loop in PATCH#1.
- Already defaulted the pfn value to -1, to simple it in PATCH#2.

V1 -> V2:
- Instead of passing the folio, just pass the pfn directly.
- Using the folio_pfn() before dropping the reference or the page table
  lock.

V3 : https://lore.kernel.org/linux-mm/20260824092935.73892-1-vernon2gm@gmail.com/
V2 : https://lore.kernel.org/linux-mm/20260815051924.194810-1-vernon2gm@gmail.com/
V1 : https://lore.kernel.org/linux-mm/20260811133655.267739-1-vernon2gm@gmail.com/

Vernon Yang (3):
  mm: khugepaged: fix swap entry value to folio_pfn()
  mm: khugepaged: fix folio is used after pte_unmap_unlock()
  mm: khugepaged: fix folio is used after folio_put/unlock()

 include/trace/events/huge_memory.h | 18 ++++++++---------
 mm/khugepaged.c                    | 32 +++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 14 deletions(-)


base-commit: 1a46b1e97bde62afa7d925bb0dcd9f9748a1d7c3
--
2.53.0


