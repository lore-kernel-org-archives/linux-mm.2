Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9615606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QgDHCjFr
Received: by kanga.kvack.org (Postfix)
	id C0ED26B05B3; Wed, 28 Oct 2026 07:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6986B05B7; Wed, 28 Oct 2026 07:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5B16B05B8; Wed, 28 Oct 2026 07:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 803DC6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:33:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDCFD1C42E3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:39 +0000 (UTC)
X-FDA: 85371824958.28.024AD2D
Received: from mta1.migadu.com (out-202.mta1.migadu.com [95.215.58.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id AB54F140008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QgDHCjFr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYyWO7IFZ8NnMGxqJk1c136n4piizJJ+e+oNjZmZUYM=;
	b=I9+UrnCU1biu5ArG826xWqotXKwFNyM3byCi0m/XVyoStvXEV9eJDpAmJ+RK3+5qjltdXW
	KihESfLwJcyO4DUFjGLLyKmhijMD3O0JYD4XR8YcjbT8FXrRHK/oz8FLvyNtnSk248b01t
	rR2gRL9R3dPhQMWWEuJvRz0/zUARG70=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QgDHCjFr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.202 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187218;
	b=yEtRbUnpdI3I9++OgVZ7YFWtf0o3/4pdeipdKhEL5Gfo7ugDkCrjphWHBiAdXz+zvpSEfL
	lCC6EhyedLhu0JktVRIONzAfkcC5oPOKxfQeFMeAXrvj8L6ATyy5y+yz6KgSf40JvhZMu3
	EYohsZ4MxKN7MqIy6xOyKAX7zoDLMO4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MsFjm2rc5UIeYKXjIXqxPFWcyN0aWeNxJ6c8Yz/3Cjg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793187215; v=1; x=1793792015;
 b=QgDHCjFrIxFsL9bpcPCU43RgNEfGTTyMJrC4qYryNHZsTsg3j/VBMyczw9H3xNCT12Kbi8ym
 7UWLI0/wSshcrWD4Dx+EK8wR8AxhR0ICil8EpBDaO5hJ4RLbyl0Jg3ekPkdfa4rDZJESOv02jrB
 F5O0VLEPFUjdmYGA86IJ/Fm0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1b8b82fa4a673740;
	Wed, 28 Oct 2026 11:33:35 +0000
X-Mizu-Trace-ID: 1b8b82fa4a673740
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Frank van der Linden <fvdl@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 1/3] mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Wed, 28 Oct 2026 19:33:17 +0800
Message-ID: <20261028113319.38544-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261028113319.38544-1-kaitao.cheng@linux.dev>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB54F140008
X-Stat-Signature: rrzzrgjb8entuapykyqqobh849fgbfxd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793187217-898517
X-HE-Meta: U2FsdGVkX1+Qza4WwA6PXDwIvvjiaZhb/W+FksYkG3qHUizgt3J0JXcmCaJMzKs6FSFZWQ0ZDqI5SOvIOLiolYBJp5KntdYSM2W2BgrQ58y/6HEexbsPXg07psi5W6j30e7lKOnuPS8Oy/n+f3mplu/s2RM3aRBu6p9HXNRc7MAqvNOIZbdzEwXhV582eaSQjueWVoRH+WvKZJq9dpsXLOZscEfBux4q8mvYd5XEtrHu87zy1WapxYQiVL7q9f6y9H+AzdKZPjg47bfxElcOBt76x5f9BFPH51EkcmfaVrnbMxdcXv45y/Hb1Ywn96eHQkqhCOuSWg+oNUEkGHX/nTlCk3RQ5DF4X1K4bnGSkuIcilef39YAbTPWC0D6OhMbr8ddbAuuLIJN5f6WGB30u9STK21bQlDr/tJ0/FmVv2rjornciPK6BS7u1lprBqRFHi5P/tb88GiO5D78DPCm+D7lSlxbcf0tL5XrpAz9byJbUfWRrzzOyPhWUtQHKSq4qCcFhb+k9pIUGIKaQsMDkb0se9QLVH7yPNaHMuwfkC+58Ti9MKo3WR8oqEhluGW4XEfWDbqqcFCIkVOgLIGMS9472ez/DschQR0NiFb54hFsiqzS2bUvXAZDt+YjOy83ktpNitb0z/6GItNaepjpvu+7jrnKP1Im0IdCtgyqvciPOYFOi1h4n5qUvzvexoQCVdW+QlMo5iEEpkjtOlyZgf25cckm7PWYlmSnKO7iVDneo3ygRRrwyNcfkduGR/aDwDH1dhtUji5a/kABX52q8bgE5UJt/8KXH4yLPCwqvP7BPNwUegU4iyuuBpYW+O9ikKl9bv6EpKXrsWY6zsqj7jIcGLM28J3LiwBlKKOF9MtIJd7rGP6UzQeRQ0g4QwPIafQUD55SLAJL3ru/4UlBerFCfVx60MTM6qXsH2HK4lTJgG1Gn/douoLgefXdh9iSJ3G0cZhzC11xQy2aOEH
 Glzshctl
 t2wWgCjKhongLlKhBOSFvPY92Tz/yzpJdzZBh2bIAmRcW3iIATwgKyNGvOybqylkqPpSGH/cYm4zZG4MIJsVvguaAU8OcHqwEJqe1ed5yvQXsF2vPYLxOqecqu/0c/W5dJbNVGs7Rk505IYWTg6R+RTVEHRzJHZFL82N+R10/ictc6x3WCp3Ald2nGd7cL2q+vysp64/PolxlvQdPm1kZrjO+QA4J1FMT8Ir6Xoot7udaozBtcpAJacMn9H6e9z8j7t7N7scTX0IUPXItNr//j/p3juk9Xhlih89VY8Asf0b7j0hWNOhB7z30L0WC3mbIEPWM46tDWeKA4hXPMvLwsu4QRfFWUYhanXlgpSPrtpvP+WJQS+QPjBD+wjfLkRquHAw2KXvQc+XHt4GNNHtHlE3jJ2IoFM7jZ5za
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

When hugetlb_cma contains a global size after node-specific entries,
cmdline_parse_hugetlb_cma() enters the global branch and reparses the
original parameter string. For hugetlb_cma=1:2G,4G, this interprets the
initial node ID as a one-byte global size and clears the 2 GiB reservation
recorded for node 1.

Global and node-specific formats cannot be mixed. Return -EINVAL when a
global entry follows a node-specific entry, before updating any settings.
This preserves the valid prefix, so the example retains node 1's 2 GiB
reservation and reports the malformed option.

Fixes: 38e719ab2673 ("hugetlb: support node specified when using cma for gigantic hugepages")
Closes: https://sashiko.dev/#/bug/linux-10f40d3e-3feb-4622-9da8-1fedecb2d0e2
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb_cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 95fd2d190f0d..8e6b20341fc4 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -167,6 +167,9 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 		} else {
 			char *next;
 
+			if (s != p)
+				return -EINVAL;
+
 			tmp = memparse(p, &next);
 			if (*next == '%') {
 				if (tmp > 100) {
-- 
2.53.0


