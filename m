Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876F2C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 06:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DCA6B0089; Tue, 29 Jul 2025 02:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D64F6B008A; Tue, 29 Jul 2025 02:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EC276B008C; Tue, 29 Jul 2025 02:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3DBD6B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:46:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3C50B9B49
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:46:46 +0000 (UTC)
X-FDA: 83716369212.16.9031520
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1BBFF180006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:46:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DM4LSl+3;
	spf=pass (imf24.hostedemail.com: domain of hare@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=hare@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753771605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiWi5cqYUJYL6hdLRY90oEdIig8/O50aCA0RYeWFqYA=;
	b=w/3LwQrm/r28Y6wXzSckFh32dHZRcmzPwWURIFo1zE9q+rjKy2OqgFBPGH5dhjMdFp5FXC
	Np2wgf7xeHwmyNyGeNY+9r9CVeOOTnZxO1sP21IEoanhWtLOqo5bW7ADzobVNf57rD+g74
	muFEOM/oKaWjIj2jNc5GfJ3vjeKmjzc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753771605; a=rsa-sha256;
	cv=none;
	b=kSkaF6y+G0m3esiVOSkgvkA3OuCJIvXLWXBEhADA7/+ozWvhAM3fbWoClEuXxLEAK6na6Z
	H12m4+qZTUkagFsnMbWXTeCf9BOCQ6eIdUWVr/7zkZkSfS0CvOzux9JSTru3Pn8PpUxnbC
	/cu+BP80g8ocuXIPh9XUyBkIsycvOh4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DM4LSl+3;
	spf=pass (imf24.hostedemail.com: domain of hare@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=hare@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 187775C5CFE;
	Tue, 29 Jul 2025 06:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44637C4CEF5;
	Tue, 29 Jul 2025 06:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753771603;
	bh=lm/WwJ8vlY1XSlskrCOSQ9xiG5dGVZNjw1038Xlj7Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DM4LSl+3rn8TX6zh62EpQxhhgyrNnTUMyZP/vY1Ko4FW0rOFIhkiS/xXqR0TNZaj8
	 5lklHyGYabJ9gKb5zMmwf69S+hIzNUjvmlDpx1/wgl6wjWhePY+cqS2zHyD9amL2CR
	 /2iJVykbSX0UB+AdElbd23VuyPwl6NdArqVOgK+hUHdwFVR9iLEnEndk2FN6gkb0cU
	 GzYxkuSFl+Cus0kDY8AqPCHyaWpunq/9Yew5shWFscPv7pXMUmm4eODA+u/H5xRJmS
	 IT/fqLIRoV61OSGqFLGQ4useVN1pWe9Nr7zN6lbjP7LlKrQe6rvOV6dnHZ/8KJTMEU
	 28I1Kj9R9cZSw==
From: Hannes Reinecke <hare@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	Hannes Reinecke <hare@kernel.org>,
	Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH 1/3] drivers/base/memory: add node id parameter to add_memory_block()
Date: Tue, 29 Jul 2025 08:46:34 +0200
Message-ID: <20250729064637.51662-2-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250729064637.51662-1-hare@kernel.org>
References: <20250729064637.51662-1-hare@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1BBFF180006
X-Stat-Signature: ud97gkqbywuwjp475y7xbyrn8bogrjit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753771604-519826
X-HE-Meta: U2FsdGVkX1+dd6fyCBo6lmnbhBV1jO8S7eUs1vPI9MkeS0A+n1N+oo8EIKBZznp29qn8m0CpoDJjObevCGZifSuEl3wWnuv+eUfo57K/QNFu/J3ZITHDF62Ncde2K9z20b1+zijGikr1A93Dby6OAZYM0MJ8uLTzpk06hIeuxYvfenj2cG6+VZN9WCF9SnidzF/F3bl5Y6g1LNqZ2kCvUD9m3zKNbf+cyDeqHK0GwT306hibMInEM6xo/pA9nkLY1XCS1vuvqcyfdugPx6VlEYyVbYkcZrPKxUA+SNwhXuKyenriETpkOtxBrVeO77333HktjaTta6xX1uiaSyQ+2Fcexynnph9M92OiQ6aau8uFFLCiDGzTDDzA3MDNgB7H+NTllI2mRnlikNizh1ROdwSkdkjicvXZyvu2MVZFESkzYQmfms7tR7ugaPAJh5LQ3I16FZfl0BxE2kTHXq/YmHuEQDN4wqo09zDn+vXuRPo1T4U6ms+x6UYhdYz8e13dqa2INcYDVlI3yTE7gxxlNXzXZjtBN0m9/174KeIl+GRZ79s6BfTrs8kwjD/nHeDKS79am80GK2EuvmYUeiaJvloTPLK3FeSSOVXJkwFg/tRFf0QFzvfIOIv1pYcdCp6x+M17h6vfT9UmIYYX5bOiuIivOBJneN64pv7DBIZtq4UUAzHTIRlHFZBEeEwJwIuE87DB5ihxOa7ooqzQI8kc18WopkTYGo8g1yPfrkG+saFZa9SyLWkbj5aJsQBXBxETYxyzFQjrLZVPBrUXf4Um3jUmK1nxPqVeyVMWR5/hZ2mNUYWx2WJn8i9t4K3OVIsIsCM0YAVgh3fXef+bZmC55LIgoEtCGcd4WT0URQjwoMOlnjcU/QiUvRX3erxGeT856Fdu6H1LB7EKUCVGRHck46lwSn5ytAS8vBl8eJXYSYjC69UgVIwDr88p5s49SNRyipC+xJ1OwL0daOnInnn
 Ob47O953
 BHEUdJFcBCrQ4k+NFm2LbzNo42mZXqnp5KhvPFaN3bAnAuqES1BQu+eSEHsodngCt54XRAHu4SskaUxtgLz4GmCKjV5bsAO2VdjiIfkXMzLUoUk7VDUSlPd5E39+h9fyuMSMkCmzCpPLSj8Vd1FtGAbYIFP30ODvJxSY6LnMOqkAvi6wr67nRS3m0/G6y3te4P/gjPN1qa6koG5xg57UjH//+WJE3iWynnLd4JNoo0yAjEsaCnh7XMyJIX+S7dDUBNyuzJneWWYdrcmRaLGw+qj3xEz1khQDDItWiAEeynjHYE9S9tOUwXcOMFR+VchPxiZZiXfCy8RCErocpKDztvFgc/1NpbvXR7FGP6OHbUJfiUwM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a 'nid' parameter to add_memory_block() to initialize the memory
block with the correct node id.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
---
 drivers/base/memory.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5c6c1d6bb59f..894d3891292b 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -809,7 +809,7 @@ void memory_block_add_nid(struct memory_block *mem, int nid,
 }
 #endif
 
-static int add_memory_block(unsigned long block_id, unsigned long state,
+static int add_memory_block(unsigned long block_id, int nid, unsigned long state,
 			    struct vmem_altmap *altmap,
 			    struct memory_group *group)
 {
@@ -827,7 +827,7 @@ static int add_memory_block(unsigned long block_id, unsigned long state,
 
 	mem->start_section_nr = block_id * sections_per_block;
 	mem->state = state;
-	mem->nid = NUMA_NO_NODE;
+	mem->nid = nid;
 	mem->altmap = altmap;
 	INIT_LIST_HEAD(&mem->group_next);
 
@@ -854,13 +854,6 @@ static int add_memory_block(unsigned long block_id, unsigned long state,
 	return 0;
 }
 
-static int add_hotplug_memory_block(unsigned long block_id,
-				    struct vmem_altmap *altmap,
-				    struct memory_group *group)
-{
-	return add_memory_block(block_id, MEM_OFFLINE, altmap, group);
-}
-
 static void remove_memory_block(struct memory_block *memory)
 {
 	if (WARN_ON_ONCE(memory->dev.bus != &memory_subsys))
@@ -900,7 +893,7 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = add_hotplug_memory_block(block_id, altmap, group);
+		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_OFFLINE, altmap, group);
 		if (ret)
 			break;
 	}
@@ -1005,7 +998,7 @@ void __init memory_dev_init(void)
 			continue;
 
 		block_id = memory_block_id(nr);
-		ret = add_memory_block(block_id, MEM_ONLINE, NULL, NULL);
+		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_ONLINE, NULL, NULL);
 		if (ret) {
 			panic("%s() failed to add memory block: %d\n",
 			      __func__, ret);
-- 
2.43.0


