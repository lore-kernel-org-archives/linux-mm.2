Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1129E9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 209886B0088; Wed, 18 Feb 2026 06:01:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1436B0089; Wed, 18 Feb 2026 06:01:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EA26B008A; Wed, 18 Feb 2026 06:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 008216B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:01:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A745DB99A6
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:39 +0000 (UTC)
X-FDA: 84457286718.03.3D71AE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 04596A0009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OvKF2VaK;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771412498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmW4XyYndEljuqzjZ1jSfTpv/ycmKrKo47UTrdfn9Kw=;
	b=w75N5m04x5AWLhd2H98DUtjf9A2O6P0MiK7OsVq6e2XPQ+ObD7dR13nz8Hyljbq3KySr+g
	aFG0rfZ8iRodD99EFrEawXk6mfT8Z6Vme46e3L3ZAEp8ggccuRM258EeqsvMhlS5Art9HT
	kDGYIlRwy/AW0wCjrglyfTCqxg2nzng=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OvKF2VaK;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771412498; a=rsa-sha256;
	cv=none;
	b=RoYqm27WJbKWEfbXFRDMMgvIQJ+m9HgCNqX8CdT/7FJtIRxa1wAvRK2mnkEc+ffUJHkJJW
	VSdU14LQmWdiMyazOYTRxtGQBsjKqg4jJQKtjtoBwcujBqk0evwlipG4pl93QeePCfkyZN
	V/Z0cRCCqeM/G5HlngddXORHxlmWDnA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 641776185E;
	Wed, 18 Feb 2026 11:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA50AC19421;
	Wed, 18 Feb 2026 11:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771412497;
	bh=BGuuST+/Iv1ZSFBKnarbpFXQl7OBzI0rO9uKaH1X0i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OvKF2VaKO2Dz6w3eX8jyUU1+okXBCC6EXvOSh0IgzZfIwS4ZUBC9lBQhKdlFnmACH
	 vK2XShx0XzVjD7yxKoVkqcZ2NTIwHR/kWoV6LOyBIXSPe8smKmCKB0DER6+j2QqGp2
	 P8QQ3l31Kb3n/f/tXlVms/6eZjdkg7ImJaclnETudLInb2ulgW7i7xUhsmFtciax/H
	 t9OHvMLLA3+NQhLJo3aYTaph2GrWcTQizaUk8QFE8VXSL1qaBVBC49So0+/sUQe9FZ
	 9D8GFqFQIIbo7SSjFSIw1X19E85CE9KcVVBl5r59aY/CfpbkO9ySiQah0Md1ebVS79
	 N9f6z95oCpZkQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 5.15.y 0/6] mm/hugetlb: fixes for PMD table sharing (incl. using mmu_gather)
Date: Wed, 18 Feb 2026 12:01:23 +0100
Message-ID: <20260218110129.41578-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026012608-tulip-moisten-c6f6@gregkh>
References: <2026012608-tulip-moisten-c6f6@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 04596A0009
X-Rspamd-Server: rspam02
X-Stat-Signature: q7m9mzzudo7xb7r1faaikkt3tpfg6sjz
X-HE-Tag: 1771412497-872482
X-HE-Meta: U2FsdGVkX1+obUAaZo5SCjc5+YP3k2JRRO1uKBrDnNVzHgFoPtaXBijkBtiXmzhxfDeNmkGVIhwDFCOA+Pq8EUQebFQ8454AIi2zrbyVbp9hePekPDmN5G3lKG3iyfKLje13jFBHlBl5L/KIiRP3ESLMtnsqI4KrkvnmAxcjOisXDMLF3brZU53Z7l9WSS/vveLPjdBL5/BCK/X9ExwPtnEE2+9K9B9bpijL/BPBHkdafWmo8OaSih8cKuuTtgmnD3jXk8Xovlcwdsb2Av7b8EhZ5k4K3eqaJlUiYTQ+ZGpkKdT6Z5uHtW3KIi2Gm5lH6W0/oKcEymSA4sv/hoAQHCPfx0UeFp4ijSdWI0wSTBiWBc7NVW6UIiKIEjtPpCJOcruCkY0mSjoQFDttMWZFMR5euzsLgu7YRQvNBQjtfvOyASdutslOV8ZJuehZEWGrGoI/ZhbBJt67+3/i8n1fKtBsvt+XwUx98G/Fo2UM++/W30HYJJDDwICOEgQY1d0C01p8P0xf9UVTOq5pfUBaAB4XdRRDezXGtpm0RWk30BxyM8midTT/GKD+0iNbgmMt4pORUd2G1grkrLmUdfzfGtPo4lwI7hcXEERHM8q09mBYa/sxD2aGpEdIBPEs4tOmRZMLB7V4pQB4oa/xC1R5fev+E5gGOHIlFs/jaa4UYbiSm69gkiZm01Gj3uEGfyo5Nw0bKZel8DrX0Lv4U3UrMo4myS7cxOKTVGzqSP9XN7ciLsgeruGFzCtW12IvkYpGmaGpBEFNrcfx2lOfvoEJO3oE8zuK7UVBK8EjpFKhTgFwap3hj013LcorXzkM7HdGSO2bTESETjs9eeRItV9paxwK+WDiHAMymUqXYFiMPvv872zKqxvrcO3jON2P5BRw5YgplZTWAG/KzHSxR5TS6AA6KFe3Dg8lE3LHheitEJSpR13AQ/fJhVz3GmxMMWCNBg0iNOMEO8h6O0QhPz3
 c2CcVpuW
 /wQLIjivBPzjpdoamB/Tn+mcp1r+4zLgp0JUgjKfWvL19sWWaStTYyaKDGH8uqejbx/VUBLcO+gnSOH25YprnoYxtHMR7g4zUbfspTq/5U/oQ5+bw6yspNVooZQBGQOP9w+ihC4paNal6HDN33k4ARoe6hNl033hX+n4gCJ3MFgtv18+bkVTBvI5f9zy6YDjViFWhoPoQMQIckrRDHJqVJVjXlY3oK/7I9DIaYkvH6tA6a06pxgUQw91K6BlnScH+4GgCJ4HawpHMP/D32B4cjsv1WY+hK/WUZ35u1Q0muTBWxOv6LxuxA7aogJkqr8bAQwcpDB3hflg4RXO33zbBDRZyuM5vxZnGJnnykAYx8RaOFFRUgkErSxV/XP7NMPbZNHn2y4tfyUb9FpQXtShyhdT51fkFlPPhBiG5q6hoF5+r/D+oGag25nWw817qry1JGZscLL7eHR55aIlCfl39EfUgFfx46j4IZM4jOzFPpctuAp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Backport of [1] for 5.15. Backport notes are in the individual patches.

I'm also including a cleanup/fix from Miaohe that makes backporting at
least a bit easier, followed by the fix from Jane.

Tested on x86-64 with the original reproducer.

[1] https://lore.kernel.org/linux-mm/20251223214037.580860-1-david@kernel.org/

Cc: Jane Chu <jane.chu@oracle.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>

David Hildenbrand (Red Hat) (4):
  mm/hugetlb: fix hugetlb_pmd_shared()
  mm/hugetlb: fix two comments related to huge_pmd_unshare()
  mm/rmap: fix two comments related to huge_pmd_unshare()
  mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
    using mmu_gather

Jane Chu (1):
  mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count

Miaohe Lin (1):
  mm/hugetlb: make detecting shared pte more reliable

 include/asm-generic/tlb.h |  77 ++++++++++++++++++++-
 include/linux/hugetlb.h   |  17 +++--
 include/linux/mm_types.h  |   1 +
 mm/hugetlb.c              | 141 +++++++++++++++++++-------------------
 mm/mmu_gather.c           |  33 +++++++++
 mm/rmap.c                 |  38 +++++-----
 6 files changed, 210 insertions(+), 97 deletions(-)

-- 
2.43.0


