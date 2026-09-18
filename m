Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2881C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73ED36B009D; Fri, 18 Sep 2026 12:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF256B009E; Fri, 18 Sep 2026 12:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDEE6B009F; Fri, 18 Sep 2026 12:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC7D6B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:35:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4E71A0726
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:35:03 +0000 (UTC)
X-FDA: 85227432486.01.D419686
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 163B4C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:35:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHA52z+S;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749302;
	b=UkCwtz36RDSbVZZuVYwsfIQLHK3n8ybEcIanmRIz5HPXCtOh/u7WnL8ijqZ29F1ZFvg92b
	D8O5iJwnjs2yJ6EUJvCnTWO7SkuIh5dzkEKon89t8k1clHacLbsGU5CXE/TJXbAIIG2Pq6
	m/UmFSCJLu+S0t1uNghEYJ19uELIACI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHA52z+S;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m09ebYKn1lSLhUp2MxWN15CMX1SNCzhrYM9zCXuJyOQ=;
	b=tRLpW6xfI2BI85rU95uzICiDdYBoHO7wQVCjzcCPkCUDKZ6SoU4XhR6Ox2D1yWBNqQ5+BI
	uIHFiIdAcGFFGElMFvLcobgtYOXFQlrPTMP+cr/GBOc8P63cve1RM7rxJdqVxxG67n+s7N
	CEdzxw4xRUWkfUV7L4iruflpTbQECdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9D17602C5;
	Fri, 18 Sep 2026 16:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14891F00898;
	Fri, 18 Sep 2026 16:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789749301;
	bh=m09ebYKn1lSLhUp2MxWN15CMX1SNCzhrYM9zCXuJyOQ=;
	h=From:Date:Subject:References:In-Reply-To:To;
	b=aHA52z+Si2AXUZr8Qi6/m8zhny9+Jiuro9jIf7og39Wb7b+Q2YCPDu7s82D+opw2w
	 ACHOIVWCmQu6WnXWtxxGwYQ7kDFvUnH6JKq46ABFrJLCRDqGL4gIGzGfWSzBGABRkv
	 ZIHUWXzSx1jTh1iMqCLIgQ2G8uj/irxwdHb2u6f/+bEk3gWhYwont1y5xnmwLwFbxU
	 R84LFGqVGRwhaL1/4Idb11/+187MMsan/fIdj5Rh+tIagE2pG7+D3tk5bPPWsm6pH8
	 wjtLsgU0WZ09RonMdL0aeWDQEbt+6XYzo7JICgCx5OiagnUTBgCcffplqxedivpv87
	 FWVwtHq6SqyQw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 18 Sep 2026 18:34:26 +0200
Subject: [PATCH 3/3] MAINTAINERS: make Gregory a co-maintainer of MEMORY
 MANAGEMENT - NUMA PLACEMENT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
In-Reply-To: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 Rakie Kim <rakie.kim@sk.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=870; i=david@kernel.org;
 h=from:subject:message-id; bh=v/DCBt0xJd8L6NUDQAFMY5940qJd6efWTNe1uMs+j9k=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLWZqg4x9wVVpkzN+rAtemtRWlesi/1Xs+68HNnV0FtJ
 6OutnpaRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABP5OI+R4VRInLjHpsNrdV9w
 c9uc3LRn9fJulXfPD2c017Z12D5nusnIMGNRb76ayhRbLYu6dQl++VxRU2ddum4nnD39eovo5K2
 buAE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 163B4C0003
X-Stat-Signature: ohfx79x74nwxryqxwakdyemu4wc4unxa
X-Rspam-User: 
X-HE-Tag: 1789749301-902054
X-HE-Meta: U2FsdGVkX19jBmeZtOhvcXt28UX8/ZYHLbJsuo4k0oqyLSsBPxEVPTth+Jfe45boErdWNr4PzTY71zHBI/kxNYsgkSDOo/P1kjQU0CQ2r1O0J1wKw3de0VlJUY7JNK2J8BEoUQn3uHUW7WEAixo+gnTVNKjCd/U6Xsp0Fnra79xe2B0fc4E8yvge3zaw9TQC6ZxVD7W25wTQK5uNI0L7pQDUFSuEetIC787APjKY7L1sy1ewyO5Vfis3V9fVCro2y58Ge7F28GANRk9fn0Wn4znxQP69mWB/iwOKod/7ASk6xbvLsaK2uPqXT0acDzYkYwj0Fz28JB3vTZOITMjn4sBd9iwSipzbt3noAe16I8izQ1m7ELqXJZam8hIUCugx5P83+4k5gA3Sxde1ZErZFl25BKhe7fO3WPgyvNK8NvnrNzz1sWZJ2aSrdVDYekllNSVm8622Gl3zdR1iM8JImhRzfMJY7j/ZHH1GcjTrD2InvaEpN1LKLJFafLdZgFEXyI0o4Zi+RmUYtBfPh4DFqty0aVuvo4KJjzul6NH66l+IKzB65uZGFXB2Y8pE3Q5hujb+Taxs7uwhEMowR8Xj3eNjuBYrf95tOuoQe2SydpeOMvF44/MSrStkxZrYuZmGG/8aR9z/ZEfCN3bQc/YgKkIxAmTWvoIBRLbEuto0OXjXzTdm7Vo8xAIQpF8pMwX19hh5+K7XXJxe2p9ydG26yzKNKWvVXgHlCDNOmY3grdJYgc+p5DgrGalm/yU0ZWl6Oyx45OkLLBMn/bM2pTywwT27RhYJCTT79NKChP7ZpvHGQm3jBNS9It6GazIub+q/SL0wPcBCvJuZ9fJHLQ4rdZG0ciXOHj2o3IzOZidK/LPN1/ubn0LmCSTYumN70QzF5w9kLqbgp/UYEz+YB1xNw7faTU9/jFMekcYVxpvyhQIEWtRngO8bdbEM7u9p37AeWxVP7qGPKO/ujYUf/L5
 cKlXK2fL
 AOsDo6q7rthuo5loHzhGBJr0VN/wlQtVgHOBpbq2EciZIMV73b0k5RzHiY/A77y33G7O3Lk8gN1chBlS9eSmpkOKWput4BPJiZkEGgl9eFfuOFHPLA6Yood2n5CEPMYqhwVnpD9rnTix7E7y8VXdYDsY65YMhNr5wsfYmcPGhwGFM945vsTH1q2RBVopB/DqahJoIWLEwN3/8MoITc6g/JIr0PBb+vKvbt1+aPy/zZUcqKB6pfWzLhz0rgLX/b/GHk+N+OoxshAIf9bAqmnQeQzX0vyWLtGHMkxx4NY4NNJYRh9XjYKOVnO2arED4F5ksM9HecZkFwIjWgeVlGVKR3xlm6OZGtU/uy2HL+Lu0705N5GDDDMTr/8WRtgP9z5p180+jfJLM+Gg33v6EJF8COoTM81pYIC7NXIMWjD4aki5oHJwYq3XvoKVM8/rOIRBRpIBhBclWW+rIUGjOejCMx7dx2bJYz1L6IYe05BrKZrqBWsBduK4RrpM0WOQVFdO8En9Ok0cVGFo5UZ2kE2LU7GOY9x6w59+ajkCAgh0L9GWhpaVpqIc8GnmJ2q1WhJTzMsiodKkclIFMtO1Su2M7FLSmfnRnxLfHkG+4Zo9uXnFCof5QFijfWLVWnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory is extremely familiar with NUMA placement handling and volunteer
to help co-maintain the numa placement bits. So add him as a
co-maintainer.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 344875eefd175..2b99a593436d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17298,10 +17298,10 @@ F:	mm/numa_memblks.c
 MEMORY MANAGEMENT - NUMA PLACEMENT
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
+M:	Gregory Price <gourry@gourry.net>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Joshua Hahn <joshua.hahnjy@gmail.com>
 R:	Rakie Kim <rakie.kim@sk.com>
-R:	Gregory Price <gourry@gourry.net>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained

-- 
2.43.0


