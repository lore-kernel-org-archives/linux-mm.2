Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8612CF6BF2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 475BB6B009B; Wed,  7 Jan 2026 02:28:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44DBC6B009D; Wed,  7 Jan 2026 02:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A3C6B009E; Wed,  7 Jan 2026 02:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 280776B009B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:28:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CDEA81A7C9
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:35 +0000 (UTC)
X-FDA: 84304340190.05.A13D772
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2F59B1C0003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HLl7AR2U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3IAteaQgKCAEcjohkjbphpphmf.dpnmjovy-nnlwbdl.psh@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3IAteaQgKCAEcjohkjbphpphmf.dpnmjovy-nnlwbdl.psh@flex--bingjiao.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767770914; a=rsa-sha256;
	cv=none;
	b=B5igdmACD1Xu4HQ7nFQn7hBtrtJen5CnFEWfx5ghc9yw7k67XTG0/GBV8dTsttZ3xFaNak
	mSqExMB9akZTf1vTEwvC5uwDnQdNJqyW6/ndT26KVRmuCR9DKlh8YtGFfVBpiPmPDExi23
	pQ/G4hebdUcGHZ8Y0wOgdg/SjiWOLy8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HLl7AR2U;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3IAteaQgKCAEcjohkjbphpphmf.dpnmjovy-nnlwbdl.psh@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3IAteaQgKCAEcjohkjbphpphmf.dpnmjovy-nnlwbdl.psh@flex--bingjiao.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vdcc16eCk3W6QUfO+1xnmrdGTvoo0vZZZVL5vCZllR4=;
	b=BdV6asua+5vc+O8BcDnupSmUxQUaxqipEQSs7Y3C2oe1S2nPRPhgesJH5oSZDrlKPNC1gv
	3OEECKtKKfa0HY4Pnmi53NNfvKw3om85llBKK7dIlRadJdkjc3TK2zuyIxWl109sWxKpmy
	EINSzq4z8Y69lsF4sjneSfAUG2bejwk=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2b0751d8de7so1550252eec.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 23:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767770913; x=1768375713; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vdcc16eCk3W6QUfO+1xnmrdGTvoo0vZZZVL5vCZllR4=;
        b=HLl7AR2UPj+5rChbXOHk8DBG2BCGd+IrjnpAWmfNRCoxSf0K1dEji4tiiIZNOCNS4t
         XPuylbSldALNAR5NPXjoffedUTJvKefQTnAEKVtwtQdxs3C7Z2LTMMMLtDV+yZrKjk7z
         7pUgymKCSEzfFeE/XFdJQGHrKOR9as+ESNKdhO8As7g1UqG0exNB+x+J29cD7xgV1/io
         HGPSRm4GrDsH/N2IyHZBLy4357/U7q62bv9pzv2gP1s8ZMahtkv5nt3DXjFQrlZuMQmy
         ga3LaAIoEXoSXiyTy+wKx7YZZFWl49JTYcIraE7uASZBI+tIJIiyWBmmzMHQCpoWBL42
         4/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767770913; x=1768375713;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vdcc16eCk3W6QUfO+1xnmrdGTvoo0vZZZVL5vCZllR4=;
        b=vQqn+l9iFKoxm+jo+wQ8ATNSLhYvtH1TC9IQ2dIgEVerZmR+JUE+/URmeHMZtfnTBk
         XQuIMJkiPnLb0zd3b/GH9lUN7etGRcbl7FtBo8ok7CHk2s8jBcDMw12LaZB+NI3FklHI
         dEDFydU17SoqQNDOYiF9/fyfnspbzbJq+7ty0is9M2PO8FONXYrDhATErXbVrbIIbY2D
         E1s65vOMQbRIeb4VOufX6SSOQLUIHrJEAoUXjEior4zao7aVb8Tla9ZzQuVcMVRa+bIz
         hDMDQIFRRR4sePNfpyreWwn9BaIbBxU1wUO1WkGLRmF+OvtPmKhb8XgOxvZF7GXVELGb
         BODQ==
X-Gm-Message-State: AOJu0YwnyMEcpAOPbCC/wLjHMsI/QYQqrA5JTwgZQ2p6rDArD0sDgVp2
	R0dw1npg9mQZ4Uwcq8kV1mSCRtOVA8qJOWtLL9ncHRi1qzIHpQeXzIGzXHE6orG0wpIaO2QR7cK
	qGT+4sRTT/hdhSBysMHAZw2+zuL849R+8BlhRmCJ2oKm2Cdd7kEXgExo5nBC0TTIdfBtD5f5VMN
	pvpDhKsHms79ynnJ1XCnEon0MoQ/6q573/QGd11uLYtw==
X-Google-Smtp-Source: AGHT+IHR0C5tVYbOki5l0STjGxIf1O+37PMISMcWlWW8Ftb4oXB5Rwcc0Sx4CNNUs/wlltI47lRxtm92zhJq5g==
X-Received: from dlber3.prod.google.com ([2002:a05:7022:2643:b0:119:9f33:34a9])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:428f:b0:119:e56b:98b0 with SMTP id a92af1059eb24-121f8b7957cmr972577c88.23.1767770912626;
 Tue, 06 Jan 2026 23:28:32 -0800 (PST)
Date: Wed,  7 Jan 2026 07:28:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.358.g0dd7633a29-goog
Message-ID: <20260107072814.2324646-1-bingjiao@google.com>
Subject: [PATCH v1 0/2] mm/vmscan: optimize preferred target demotion node selection
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Bing Jiao <bingjiao@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2F59B1C0003
X-Stat-Signature: ya96pud3uqmyji8baimkf96jgn5o81b4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767770913-386641
X-HE-Meta: U2FsdGVkX18ab+sRYliNt0FT8gvHdxM1hZfh2hIujA4YGqnJ5JIXxcVFV8Rr1DIE9ETD+du9UO1ebpWH+zU2ObDW0YNTD5mdyh3ZUTl7wbbjXdv/kD/GptC5XhSXvaETUUqOn+31d4O0yVmtL8Q6+X7toSpB+771xr6roYEZfeq/gF9MyuFxejJfuwUWVgEJ0+sAtRBPVIrhoQW1/boUO9Ie/Vt/aRvRbysCHwVKxGBcZnc3ZDfLYjiD4yjqdmsTHMxqXrZ63TBe84o5E0FXiwvMmzH5Zo+eu0Qy3p2VonH2mltd5RNHhD6hAm5ICIWC5WszbAQUvC2T2iSZJgk3aOqwEW/2pMM7U0Mpioa4ON8Bgoov7CIsoVXJokDRaHB+2iRDgCInPYqzDTeTY3jg7orz917sTsVSt+ZAsIKFGewF1j1U2BpL+V4etLIuF3CKUfWaWFkwaSeWJew4UJJRarNQJTexlE9lS/2lDqizKn0GP3UbzXx1nzcyCCMZz63TXI6TFliZQhxchQ440W67ipi1CnG9nf9XubzR+XlBDtY1jMMj7T85baciQvbpmU3v14tXYT5eh4Vdd1CLYpShzaD0Ax1rwx5GAF/eCf4CKRVac1hreIJXRXXdPkV1+R+hjmbGmMH4iu6CyJpuc0TxXiBoHU9QfzONaQ/5QKtOuOMDoPjvrN1TFPRaDZHIx9RUQzWQEjCPnMW9X9bSPEUS0nb9wlKgSdrQcVlJGNBz/sIURBDXb5zkCqEchk/QMXEt3f/5hYbbtvTMGSGVHZf9F04Krwg/EqLmvYwD6/D+gCj8xp9Mv9ScS2dSOUw36vaVAK4xmbDp1w3spzkYQLH5tTJklWgIDAT1/eCVPQBBw1dSAWJmUgGccJ0wXcjPCnFBgb06XN5uFXTWTnLnCiJiEbNKYg5kqgLK6I6qDxb+7AWF6wm3ipSUEdD5KG9qm2fnxlCD7a482bT5Ur+qjne
 oFthovSX
 7+tA8UDPL0QlL6gRkei9cHEUNH8iI36IzmRRovUjBK1yEsRomNTq89zZUnOpP1hjryBWlE3xrpT1AzdDV2wBCfCVadpwoKGKhp/GWC+pBGRArTwGlzSs07oGVF90RzPsfE0+SH5WgGXlsYfarcCiXY4gz7sOJz58Uh3xgK72v+qbM7UohYFwTm4EOJf5ge8XCYZujddLPIauj2mZyaVn5TbstIp8/n2e0rf5SxN2h85VgtaOmhoLAOfN4Oi231qK6Ij+WccHmzf+idID9+ystFp6JsE0agvlTVw3sdoAADX3Qkhybl3OzPV7FuKITLQ4p95t3Z0sTxMyD8ZQFWgXGYAOowpmBzz+4I2EgKvGsKNiTiWiQndWEETu9+XSXvCOf7PcMjcnuCm0sDAesv1IFQTK/5FkYChmZisJ697jx7I2stXFT+WVqM6pHiWCQPriRyN/ndIQIfNYiBPcAyfMos8n1rVQ2kvf39kPigw/cwSs7b7VYoQXMqsak8GwP0WwzVPGRmrrqTjA62UazCDB2sIMlBasgCsczl58a1c5ojSt1tJWVzycarHeLWzNzwZnjWkr2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In tiered memory systems, the demotion aims to move cold folios to the
far-tier nodes. To maintain system performance, the demotion target
should ideally be the node with the shortest NUMA distance from the
source node.

However, the current implementation has two suboptimal behaviors:

1. Unbalanced Fallback: When the primary preferred demotion node is full,
   the allocator falls back to other nodes in a way that often skews
   toward zones that closer to the primary preferred node rather than
   distributing the load evenly across fallback nodes.

2. Suboptimal Target Selection: demote_folio_list() randomly select
   a preferred node from the allowed mask, potentially selecting
   a very distant node.

This series optimizes the selection logic while ensuring balanced
allocation across fallback nodes.

Patch 1/2 introduces a randomized fallback mechanism in
alloc_demote_folio() to prevent allocation hotspots when the preferred
node is under memory pressure.

Patch 2/2 updates demote_folio_list() to traverse the demotion targets
hierarchically, ensuring the perferred target is always the closest
available node.

Dependencies:

1. Patch 1/2 has no dependencies.

2. Patch 2/2 depends on commit d7138516fb5c ("mm/vmscan: fix demotion
   targets checks in reclaim/demotion").

Bing Jiao (2):
  mm/vmscan: balance demotion allocation in alloc_demote_folio()
  mm/vmscan: select the optimal perferred node in demote_folio_list()

 mm/vmscan.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--
2.52.0.358.g0dd7633a29-goog


