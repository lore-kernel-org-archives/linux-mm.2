Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E95C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980D36B00A3; Tue, 30 Jun 2026 03:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958726B00A4; Tue, 30 Jun 2026 03:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8702F6B00A5; Tue, 30 Jun 2026 03:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7A26B00A3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:22:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C73A21403AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:22:21 +0000 (UTC)
X-FDA: 84935735682.02.C5F2390
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E9251C000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:22:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cce8FDBX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804140;
	b=DE2i0MysdNhPvARpRKxpwLsbkLq776eV5SH141Od8mVYjLGFENeJ+FaC99DVKCh86kSIK6
	y204WpoCxhINPoNC7cRVJ5ZeumR1fhx7Yq0zAKXbsvcEGI5AWdCqvlRxi4KV4sIk19jBg6
	Ac0oPAv+eOJi94MN2J90g3U23WM2Ykk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9AOmCcxEPq4W+TaAmY6U28nuZoCb0YCtTlU91i3LIHs=;
	b=M9eGfe1RIVcb3MlYr7CcpPw8H8yTsogAdZD27vpiuqMxP3GO8jWC6NI7wWOxNf65HNPSjy
	0UAtVnP2xRF0piFEh6CQjOmBnq+S9ChV0aFpG/+2BI70vAYK7zgtCDDlrko8A9ggzl1eE2
	jaZn0g+1R7WUPfhQplAi0p1Zt8y4vrM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cce8FDBX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 328F1439FF;
	Tue, 30 Jun 2026 07:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34A51F000E9;
	Tue, 30 Jun 2026 07:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782804139;
	bh=9AOmCcxEPq4W+TaAmY6U28nuZoCb0YCtTlU91i3LIHs=;
	h=From:To:Cc:Subject:Date;
	b=cce8FDBXbqgDflei6/4+Fiw5Z/p3Zw/gZOC8n/SOHM6rUSzSqbjOlePD7rnfkQiAq
	 ezo6QyUbA5t+vaynuc+kC3e1rlc5z7HYmGmg6L6+TauGjQBdhGubhygkvqBxtS/H49
	 FY6U/p5TFaOyrporioULcYpP8G2ZU2nqHuVP9W+d6h5ayIbpSRQJ0pkclkooGxU8pp
	 Y4FwjLYUyKkxWTMF119gardiLrTmgOOHUtnI0NHCy2c57OuK/UskuKW3OMWpf2gRpg
	 iRiSLcNejB4mXdrxU1hOJ+xW0Y4mFsv8JUPtimBrMpV8DtNrnrl/bzprgaHZuxm/4O
	 aOmu0IPCHyCow==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/mm_init: don't overlap zones with kernelcore=mirror
Date: Tue, 30 Jun 2026 10:22:10 +0300
Message-ID: <20260630072212.624305-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E9251C000B
X-Rspam-User: 
X-Stat-Signature: 7rgrbieuyh66azw1joxcszrm5w71r55o
X-HE-Tag: 1782804140-985653
X-HE-Meta: U2FsdGVkX19tT7U+c+cxM5hNnbZFybv7hYEGvmB50f+1dR1vrugy/ZW6tKMw9/U4x7H5QW1VQC/Yabtng7sYYpaipxinBomSoYvwLPvY9yDDRMkzkt1lgIzYbZ07iwR9erFT2jOk99GZ+wYrcdQZ9oej8L3VxTY/n7OmHtu2LqIjL4+lsKwg8eQfW8RHZmENCBYxWEZAEX9K15FKRWhVvVPstjYl/YkOmXviBTStg9KFD9vUnyfWBqPqFFDRKWMegPdw2EvJSSYQcu4lT4RfNOiCVPSj/7e9IieUicjJPTi60876/3tZ6xzdkx4quevHsDNQVPbxwCVmLY1XQzp4M3MM+VMxKLIhGInKBPSDHWSOR5Ecy2tDaW5ONJJIVMxthDSc4k7Tv8h2nbEmK+M2f/Gbd77K9qwXPCffJkUom1cVHvyHeIsjkolRRfwmdmrUAWAiS+q5IWDmHaFo5vXXZ/1lGbXM6aHaoaDbybT+xLhkt0UrqqeWtdW4cQITzgFLa9KZFwCfNGBhupcoLx8h162ewsZX1c8S44QdreR2hdbpIfwJ99n2RqJGY2n4fjrtQES4vXtoAG9NF2tTg7031Tb5NTxqWCk9eQzFImZ/UXmdyFXPYYMA5p+AKRjyEwuy/QeNYuiS4+cyFr8ktnyDwnN54uTHfb4RTVJNycSCO3vRDMzj6jxsM+7fUSNRQFOfBuq0xLXqjnAys2f4fH+U+/Wt60LbyKcr4BeBVyoo0Gec7P/k74MXsrWlnIHf8xwinxHR5y78MXfWG2NwB10OcCHq9oFSAjpEr6xlD5xd7X9WJal1ZU1+hz3j6wjWZ1zlV/YlTeMffBeDrBTz7RBCDEOMqTKp5CxUlwLVUlSg8l8Pa7avvn3QCwpvPlhohtjyC1n69ZM0aT0JIIy8IzutNtetUmPxQb1+M0gvcZUZnnAQipQfmlmBqxoW2jO0m+bcF1dDaTt+9/1TrB24DXx
 hvMaCzXg
 eRJCm3sYxvoxAJj9DmKYIjCbQBl56iedyCVpbEzSGJENoyVmiv1iUejwHTFPk2knr7kqwWovFlnboBiRSBgF6hfr2322nnicK9IxunxjafbkwffruURqIGI1Vi/Zbsm8iYeD6gSPVPcmRD/Aryvc+dkVBoDn8V0AkAHOBNZVP5sr9Y2OLKwpe/LLKyZvat8hcuWhrBXj8y95i5FfocBqXIXX6QcUyPwuL3vw20ls+Dljnjsr4BScI8K8LvTiekLBxFqsDPgMPJw0tVY971mlDkljun8grlGTY4zskVXvjcbRrnxj7EKGsDSaXBVLJxq8ZMAR9S5bTl3J2bo8OKnEGpXR/tKBFg+u6S+Bs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches make the behaviour of kernelcore= parameter uniform and
treat mirror just as another way to size the zones and cleanup a weird
part of the memory map initialization.

For example, for the memory layout below with the first two memory
ranges being mirrored (flags=0x2)

  memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x2
  memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x2
  memory[0x2]     [0x0000000100000000-0x000000013fffffff], 0x0000000040000000 bytes on node 0 flags: 0x2
  memory[0x3]     [0x0000000140000000-0x00000001bfffffff], 0x0000000080000000 bytes on node 0 flags: 0x0

with kernelcore=mirror set zone ranges would be

  Normal  [100000, 1c0000]
  Movable [140000, 1c0000]

and range [140000, 1c0000] is spanned by both NORMAL and MOVABLE zones.

This range will be passed twice to memmap_init_range() - once for each
zone that spans it.
The memory map for this range will be initialized as ZONE_NORMAL during the
first pass and skipped because of overlap_memmap_init() during the second
pass (ZONE_MOVABLE initialization), although the pages in this range
actually belong to ZONE_MOVABLE.

Aligning kernelcore=mirror behaviour with other variants of
kernelcore=/movablecore= resolves this issue and makes the code less
obfuscated.

I intend to carry this via memblock tree.

Mike Rapoport (Microsoft) (2):
  mm/mm_init: don't overlap NORMAL and MOVABLE zones with kernelcore=mirror
  mm/mm_init: drop overlap_memmap_init()

 mm/mm_init.c | 60 +++-------------------------------------------------
 1 file changed, 3 insertions(+), 57 deletions(-)


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.53.0


