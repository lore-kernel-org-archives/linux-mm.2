Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D51606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Feb8Y+6Y
Received: by kanga.kvack.org (Postfix)
	id A217D6B05B2; Thu, 29 Oct 2026 05:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F90A6B05B3; Thu, 29 Oct 2026 05:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936E26B05B4; Thu, 29 Oct 2026 05:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F65F6B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:19:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10F6C4031B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:19:25 +0000 (UTC)
X-FDA: 85375115490.18.5C5E829
Received: from mta0.migadu.com (out-20.mta0.migadu.com [91.218.175.20])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9A806180004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:19:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Feb8Y+6Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.20 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793265563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wc1cCegTsF419DOZKQ+etFEgEn2COXujDpdlOtNxm70=;
	b=iQsUZ7ZAgAUO1caB3l33wSVRm0aIKNc0z4ik66Lqrdj96iet2so2kwt47Q9a9qfZ9cGNhF
	4YUroM1mBiUvuCdcZKOUjnVAXdivCTmKt+MTWxNVob2phZ6A+Ape5rbTUhAdZM7lnEUUx3
	jV8pVq9761co/vu5NhaSbzybQ+kn2KU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Feb8Y+6Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.20 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793265563;
	b=l4W/51EDqP1Nk7EI3sT6HZ+SILuTeZWBEvs4DxB7+0xdEM5vRQ1PV3V+vcSg/b62frh0cB
	76P1US+hRfrUiLVBA1LjIwrmKYmFF9qtiUJuOnyRhGM1MrrZgra5veJWuLwXAYsfxJva69
	J9+8URaTdW6Egw/qV7SPIZrkPkCGmlo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Afj/DxHItcSs+lti4Qv2oWzmWeorYwqYqELX8olihxw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793265560; v=1; x=1793870360;
 b=Feb8Y+6YWSTPiNXbfR9zgxSHIK2u9HO9kpPPqQ9klyeAYytpYUOSUcuJBW6vMvI3qncwvmCp
 olZchMsQwEAG1taCYCV5pjQgvg/WOp1JApmuduEEG3fVjd4Zgr3Vns/C+77FHIgZiOt2LzPkN0l
 gPKmnynPAXSWWQLM8eYiq+JI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ee0a28769bc6ca81;
	Thu, 29 Oct 2026 09:19:20 +0000
X-Mizu-Trace-ID: ee0a28769bc6ca81
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH v2 0/2] mm/vmalloc: harden remap_vmalloc_range_partial
 against NULL pages
Date: Thu, 29 Oct 2026 17:19:06 +0800
Message-Id: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIoP42oC/3WNQQqDMBREryJ/3ZQkSI1d9R4iJcZv/UWNJBos4
 t2b2HUXs3gw82YHj47Qwz3bwWEgT3aKIC8ZmF5PL2TURgbJ5U3EsDDqYbDm6XDUM+NCmi4Xyki
 tIG5mhx1tp6+qf+zX5o1mSZLU6Mkv1n3OwyBS7587CMZZU+iSF0rkWPLHQNO6XVsMUB/H8QXiG
 qFavAAAAA==
X-Change-ID: 20261026-vmalloc_remap-012cf418c2a8
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Queue-Id: 9A806180004
X-Stat-Signature: h5asd83q4r6th61oux184dnwkjax3agg
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793265562-64064
X-HE-Meta: U2FsdGVkX1/ZNX/HlqFVhwwmkK3E2FIEwibHYiFSGfSXDHOcIITPD//MBopkdmN76hU5iR2tmKlPEnwKP4qjJ7ebqoDjGeG73FzQTaCbR4sE9x3xStJ2sTVRs+EeoiXZZGF7227DMpjOhvfJ6Qt+aNarI7B5wGcK087RzTyDfdDq3hb+T5xvUkUsai9uVe5ZQPXKiGlBzxF1hXg5vq/k5gvLwkFFCwrpe9bwICh3KMGo+kn+EkXg/x48SHowCm7dAr1kqV+62UkgPctBkzzAC+HjOxQYN825j7reUY41EoCM/ENT7yTvC4BcR2nPWrFOXjOm5h62C8v5RGbJy6Bkuo8Rz2+l7GivswhIbaRd0lrCrflPGdh/N7MmKHt0/tWqJJRpiHBeUufBVJzwyosEtbmoNZNpUx7oN+oNe4sTWm+DvNuuzNQVerqUP6OpljfHYvXRBDSOtzVD7NsE+FgzMnJgmHH8Zo7PqfhdrZmiCawRRKJ9rWXWRcKW3W6g3QXFfaqLb1Fpdm1PKYS/6U+p20XqKLqt7eO/wwg5p65q94l2+Ha7BaG2kVHaKqRFqIscTlO7UcVsRpfbyE2TH94HAdBbzYugZWbdhhy8DPwMwQIGNqDJ/ccjJMvqQGl6gIvvDu1EZ870EXutkVANP73RYbw+KqKfNE+VlHG+lBcnI1VmLBLHvyiC2FLAMyd0kAFSEi/r/HBz9xhjvycJPKziZTCjPPNyZRQCCbtgjNK/HOY710xk14sSlx3lXr9lVKNo1dczGVDwLi35wXmRWEt5blYVDdr80jRqq5FJBHkiA9cBLJ/f+MCcgqPiV8A1vSmuv/7lPPZr1/nKxeOISaB8UCogLbC++sxFhwQiA6NaU/GWkkdNQBlad20sSoZQPhAJ5KmCP8NOOkn41Y8Q4CxoXJ5LEs47ldA9RWUazSFMuH/eCcTYjNxIGw3O/2q4PCj0+fpMHpqmjhOFdmv83oi
 kIzoUPPf
 UsxJtJO7NOSZHB70EDCuh96QU4Q4dmYm2SbTxZsjy+g0HpLOL1OWFg5LTEzUHzwexlhKfJa/jDW73JomcJGGeHH13WlmP49wwA86achELHMmZMxdxSHj3IpI24TsyHik+SgHNft6cP59nswBBjPQoJNBqpBQogfS2TXI1im21S1tXyW7/E2Uop9ZToSIG3ivW67SAyev068ZRlGZJZ/NpIPbRD6EqCX/kGb5M8t8Er/5XC5BWxERXMVNREEVUZy5eRAmGBD8egpPqmP2EzlUWsQK7vz1v48YJC2LqdQS+ur/Zv0G7RgAY/BIWzMSEezN4sz23G0zvnncTIWu86RAyqq85LL1RdaJ457fJFGH32LH4Vvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

remap_vmalloc_range_partial() passes vmalloc_to_page()'s result to
vm_insert_page() unchecked, oopsing via page_folio() if the page is
NULL. The NULL case never happens today because VM_USERMAP areas keep
every page mapped, but that assumption is nowhere checked.

Patch 1 drops VM_DMA_COHERENT from the allow-list -- a dead entry (no
caller maps a DMA-coherent area through this path).

Patch 2 fails the mapping with -EINVAL instead of oopsing if
vmalloc_to_page() ever returns NULL, with a WARN to mark the broken
invariant.

Patch 1 is a behavior change (no in-tree caller affected)
Patch 2 only changes a failure path that cannot be reached today. 
The two are independent.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes in v2:
- patch 1: drop the vrealloc-shrink justification. 
- patch 2: fail with -EINVAL rather than oopsing.
- Link to v1: https://patch.msgid.link/20261026-vmalloc_remap-v1-0-b7a907814e90@linux.dev

---
Ye Liu (2):
      mm/vmalloc: drop VM_DMA_COHERENT from remap_vmalloc_range_partial
      mm/vmalloc: reject NULL pages in remap_vmalloc_range_partial

 mm/vmalloc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)
---
base-commit: 2efb7a11f1aa4d2dc285fe2680cca22cb9f72f64
change-id: 20261026-vmalloc_remap-012cf418c2a8

Best regards,
--  
Ye Liu <ye.liu@linux.dev>


