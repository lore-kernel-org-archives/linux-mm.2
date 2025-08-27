Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8807CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F908E0136; Wed, 27 Aug 2025 07:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40B68E0105; Wed, 27 Aug 2025 07:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A566B8E0136; Wed, 27 Aug 2025 07:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 91C5D8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:04:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6888784B30
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:48 +0000 (UTC)
X-FDA: 83822254656.09.DFAE3EC
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id AED061C0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:04:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hW9vECZU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3TOauaAgKCCEG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3TOauaAgKCCEG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756292686; a=rsa-sha256;
	cv=none;
	b=wgZTsFM/T+lbG7FDF6agwL8FydUJvOLvDF+I/k542avKzwNN4Rus/k3F2mRHmwrTGCRlLi
	7uo2eT9fIH6lqIZDDMxEX3VzrLZ6A+ebLlhBANs0Lw+8OVbgvLvw7IKby7XYyT2/C7xb4a
	DBXoY1eT4KvGjOXcqggLlwKE/4bdha4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hW9vECZU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3TOauaAgKCCEG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3TOauaAgKCCEG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756292686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nB1CmJyIyqxVpV0Pl3/V76Kj4yMDeN/qorkLS0QOWhU=;
	b=oiT+JbN0RJhlh5K6yt5mDHCyN6MtiAgA/bJuvtzUDrBG8BGT7OiESF7fNfmGD5EKvhVyXW
	cB+IIIzrLR0Ulf3q9egCEncgMoOEdnsxgcie+qhMorStGS3GwNytwBPvOFwp7SENu/RHuk
	XwKl6X8tXnQvhPjMg6hXik3xGhk6fXM=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3c68ee43c76so3522498f8f.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756292685; x=1756897485; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nB1CmJyIyqxVpV0Pl3/V76Kj4yMDeN/qorkLS0QOWhU=;
        b=hW9vECZUZE2OWFFo3uKtiwQJhwVlDkuewFcA/PfjHuHocfsvZopVpSqCUKNYRwOXL2
         jGQSp6OO4kn5kS3LMhiiOW+PwEEUqWQHP3zpjAOadNJNZizYwsJ4GNv+YFsHufsH7JyB
         w9Era11FdcbaASuJzRNvqPaOTDCnsnT+4DWHo3zDYZVGQLOnSamjXzmRX74s1LDuo7fz
         W3dMhGOtJYFoa7rmsXgrx5rVAf8FnWZv/Ra7SbiD1e17AzIYsPvAY1Gqv8HIjX0zR50B
         52INWGX3BWGMmkPzTNkOZ5s1PUlIQGPITjcVwt7wiZIUoxk5UPM81QPNZKkyjDcNYO76
         5RCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756292685; x=1756897485;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nB1CmJyIyqxVpV0Pl3/V76Kj4yMDeN/qorkLS0QOWhU=;
        b=wE9fRs1sBzGzsx2+2veXH0NkTHHbATCrLhX+GCQMGuE0HwAiBnrmId6wxeY+gSMIoG
         VXrLz0CVcf+BHyARPunGoHI71nTHhqEl8E4P9I/98+OFyqlDDZqUN7SVIeSt7rRQswOy
         2cEDIb0YrRa/Ygqow7SaLb7L+yJmLQna/ZltjnigqHMtDDyiOBWtczZdNQ6Ase6MywZF
         JnhmdktGt/xVDuWBOKdX+Amq2DOAx/vs4tFSiGGh0wmishPM13iRNEg+qx2DWcATS6dT
         pKJSNTOWiCZ2Pa2KIW7r+saQy1RTEI8n0SOtGA4YIRZOGyv4HoC1WCOZeFYMa05rvEat
         Ai6g==
X-Forwarded-Encrypted: i=1; AJvYcCUFHOS+dMVAHVP2kolRL4kRI3SIOFb6GeWbq3XF7Y8/pgpK1NvH27FZAXwf8FAOEw/2l7uBN5rG2A==@kvack.org
X-Gm-Message-State: AOJu0YxmVsKSo02GkihggKy5ichsJgUm4x14t3sYvizXARfNrFdSTjCR
	49MhlaEn9f9GDf6KU/74Nn9BgDEn0mGcNBfpFArUNuuXOsU+LbJFES37qM96Uiv5R79e83ZUBBc
	4nmMEPPlj/02n5g==
X-Google-Smtp-Source: AGHT+IEd9aTPTeG1vOmcHudzjwY0uo766zrOkD71aEEMOUty/fhnuFFnG6BwWe3wjgjw7hkKGY7L+IqxtUb1Mw==
X-Received: from wrbgw10.prod.google.com ([2002:a05:6000:40ca:b0:3cb:e27d:1247])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a8d:b0:3ca:2bc7:e821 with SMTP id ffacd0b85a97d-3ca2bc7ef61mr7837430f8f.53.1756292684905;
 Wed, 27 Aug 2025 04:04:44 -0700 (PDT)
Date: Wed, 27 Aug 2025 11:04:40 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEjmrmgC/x3MTQqAIBBA4avIrBswMfq5SrRQG2sWamhEEN09a
 fkt3nugUGYqMIkHMl1cOMWKthHgdhM3Ql6rQUnVyUH1aDVewWBMaM4U2OGO0g9knfKk/Qg1PDJ 5vv/pvLzvB4/5rLFkAAAA
X-Change-Id: 20250827-b4-vma-no-atomic-h-0f8ebc2fe4f9
X-Mailer: b4 0.14.2
Message-ID: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
Subject: [PATCH 0/3] tools: testing: Use existing atomic.h for vma/radix-tree tests
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: AED061C0007
X-Stat-Signature: 6i7kdfyyy3pboh7hbnfh599j3433w8bs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756292686-698750
X-HE-Meta: U2FsdGVkX1/UKEzNJTvwAMPiBktSeQaU4JiZS7s0h1peoUL6CpEwx5Ma2AQkb0TgxB9N7vwNtHk9hLqxagblddY3Nx5UVWOrCCU99+EPaUO6oMFZXFcjQBCwIXhvdL8sIHZ/RA1xBy0lQ5rvceASl3T9VDEdwWsr5EZmj+LNe83Ju71VVw6zCwLrsCRY9tXzi+VW0GeuGsrNo945N+V5As/xNbylsKJQyo+9rV2ZHcPWu1RUkfxwUT4aE2Y6YDyybzxZZE5BQuc6JkEH7P9bt8R4PBcJBbW7Wt6RdDRQgGrMzDnb3Ad9xfUmcDebKuftY5j3a01ULOMoggVETm/q9rYKSSkhj0qNOqjAJsrMKsebv+uvIO/6kJmQ/Ch4vFa4B7NA4sLrGhFzsAwoDDLzM4ev/KJAMNfdKUyry7j1LbQyRvDukcVX/WMwH0UUBkaJXTkwasc/U1l/7whBXhotamO19juNs5x9qBP50nX8yEtTB3SDU+n6Th+KJdZFmwWuJ4BollowVUBxUbH/R9MQk8PHc/X3j92IJtkgALnK+xOoGEjfS0Avx8dZxOlNYLNVQ/fRZOyce2e973vh9ALL+rYHB1pfMgtR+lEtO7bfbDkN5PI3votNTjKhdd6AgcMQHWxTPOMZOTpH4RPGl32750+6QyxOclvzWS/3lxYbsEbu0GWbCbW9uiCp4fBeb0669gMu3/RPI2eFiKJnSRa6jIw4YKjpbmArKC3/XXNpscruqipbs2g5AJ6jcYbAjOz1cagjYzfqNh3Ig9onUUXr3RrYsFw94iZMWygm8xUie31CDOsdMFSXNK6Y9NRv6P4bF4VgSHKqQMsMfPFBzu5nhV6RFwYmmcr2tFbsEHHKs9PedZTluQ6x/ly6QDQkgZt+gPMUSeaNpRuC141P5QD45hzM+9qhPupcSQt+GFknDeNuVIekeNditpyrDkzQ34Xi0eNfn92vav1NbW4yHhp
 OL2qkQIB
 imh0GlCJeofVKZVg5GMvoHjqyLygfKZbp0Oye4czbdX2oh7BxtE2PgSGIqiZSJF4KPtRCeMvMnGzGeDSFzVzKVcidQf/9UYzidiAPQ6htvEqBXkCQc2fNkRdVfzHT2tXRqd03UyZfkKJnLUglXhO1J/59jlRsNfWKUqsaUfJNNBroQ0RE5Rjqtyhv8xj8szOJ/+pprgxArUAyQpLS01PNEyPfPAOJR7lO8LGL1CCwPEgQlAhb5/xWDrV5czTKk/itfmvt3eY9U0j8Qj0jC4J9TizPow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

De-duplicating this lets us delete a bit of code. 

Ulterior motive: I'm working on a new set of the userspace-based unit
tests, which will need the atomics API too. That would involve even more
duplication, so while the win in this patchset alone is very minimal, it
looks a lot more significant with my other WIP patchset.

I've tested these commands:

make -C tools/testing/vma -j 
tools/testing/vma/vma

make -C tools/testing/radix-tree -j
tools/testing/radix-tree/main

Note the EXTRA_CFLAGS patch is actually orthogonal, let me know if you'd
prefer I send it separately.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Brendan Jackman (3):
      tools: testing: Allow importing arch headers in shared.mk
      tools: testing: Use existing atomic.h for vma/radix-tree tests
      tools: testing: Support EXTRA_CFLAGS in shared.mk

 tools/testing/shared/linux/maple_tree.h |  6 ++----
 tools/testing/shared/shared.mk          |  6 +++++-
 tools/testing/vma/linux/atomic.h        | 17 -----------------
 tools/testing/vma/vma_internal.h        |  3 ++-
 4 files changed, 9 insertions(+), 23 deletions(-)
---
base-commit: fab1beda7597fac1cecc01707d55eadb6bbe773c
change-id: 20250827-b4-vma-no-atomic-h-0f8ebc2fe4f9

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


