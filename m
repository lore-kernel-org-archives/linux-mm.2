Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0E9606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VfnYXBQ0
Received: by kanga.kvack.org (Postfix)
	id 6E7C56B05B1; Sun,  1 Nov 2026 21:49:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BF4A6B05B2; Sun,  1 Nov 2026 21:49:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FC7F6B05B3; Sun,  1 Nov 2026 21:49:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4267F6B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:49:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8F3980B53
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:49:47 +0000 (UTC)
X-FDA: 85388648814.27.F8BE7A0
Received: from mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	by imf17.hostedemail.com (Postfix) with ESMTP id B9CA34000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:49:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VfnYXBQ0;
	spf=pass (imf17.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793587786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYPCOH7nyOgzPYBliYS/2JtpB4PHhc5GiSJqiBbOPVw=;
	b=TVH2iF8/koQuojejgHknnUz4cc6R/M/QwBk1dSDB8MKtS/UIlQuFzpo+QToatRMXOyIdyq
	0iwuLTKzSJK2xnlvZpfpTm0Lg3DYjKPcfrOkeWZgOEEGNmmWUYD8n8pGgU7yNaJBGow8Bu
	xjg0CzGfj+Wzz32OTOPBLaw6rlPgV7U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VfnYXBQ0;
	spf=pass (imf17.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.38 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793587786;
	b=jEaHLl4398O/jjEeJK9NT+gehrihvmULQ7regcUWVZ/K70igTXZLC3I7Re0VoFSDeNm5Oh
	1pkCIJmbOZTuHVQLij9z7bt2CkXfpYXVCMUaBJmaYMERJ2IdkNv/1v7Y0ksxOAgNMbjaF0
	lA2tUUuVqp44EIc6cI/P1ygbO7t/Z2A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Hqb5dpR6SO9lse5taSFwdMkdZpYAQoi2qmmKSFxQn94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793587782; v=1; x=1794192582;
 b=VfnYXBQ01a7sVa5ydFtRlIT6q84NfQa+KhReIULOUdKEiLrSUyvWmlp74enHW7qFBqOqwGaJ
 yTma99ZcqhiRfCKJzznyBF6L5LDKR2ynY9tN5wju7SdJnBeTgbn8Tl8cVG5646Vtl/T/lEX91jF
 gzNhkk0Edft2a3OqqqvlWVrM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8fe3ad59e5aaa9ab;
	Mon, 02 Nov 2026 02:49:42 +0000
X-Mizu-Trace-ID: 8fe3ad59e5aaa9ab
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 1/3] mm/hugetlb_cma: fix incorrect hugetlb_cma_size assignment on malformed input
Date: Mon,  2 Nov 2026 10:49:08 +0800
Message-ID: <20261102024910.31486-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102024910.31486-1-kaitao.cheng@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9CA34000A
X-Stat-Signature: 6hegigm6euxi7mihnuqmpr9a73sb165h
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793587785-964016
X-HE-Meta: U2FsdGVkX1/KcVuKgTCYyEeFMrnu1CmyexUDR/8Ro8bAOvgTONKUumpUZ6pcrlPWzLS6uzimn8yynAedSot0oIz3nxzpdPDQkLcBJYVFMG+ywu5DibyYoPOmH6BQFh5iyoU03BDWnk1/AqYmUlsAz6E/uyVI2I8MFdtV+9vpuYa/9gxWJzkz/A1E1syCk/yf41s2DH13E5TMNn2M8WoiPr0ZB1v0HgniIE+toRRB2+AZHl5HIDSADBNVyXxQxUsKt3GmbhU3B3j6/XJXbtd6NqPTzJRjwq40/hBAvOxAnbVZXD5YwJBobqUPWABtaB3rTvB9/DxX60NXus2hvlIUk9H1m4FoTUcWxfiB9CaWW0J9vFBdbskIUP4kYZsPAhkyQexTlrDw4r8hZQbhpBwfUNnGl3St0W1LtA1PC7VNNPW/bxSlFwK7Ahq984X3EPRTkKJs3uvI7FLaBATjM6AvIMcOUKegYTbGxMYhwqRcRlsx9hEapl4ejZu8+oV85idiMRGEw5C68wpS3IGlSB78c40rBc0eumZZQNfhxD7z/UGobQlpapibBfl4CKpYeJQN04SfFyxWK+e9lKQUN9FveBj59nLOtFG2mn4VzFzeUS65gNhKFqlVUOw2XwPMtEek2xt5c4O+Zx1GnB7JXfWmbK8WKPKb0t1kWybMvXMoMMoVOttNxQ9GJtfxOOa21SPP36ljByBmHtWaFr4I12X0iUmHETEu0lESGoN4OURIBN/go5mBvVklfGFlFQZiCiDinv1BXfVo8xBFEQdBvIsfZI4ThcjGxxhzLEFW24GauxyR72CaXTLeCCza6VT77WKeY6Pc/9kghwUgl7LVi9TNjuxmzyQHwKK5xSCNr3/4jTwp8+mnye0ZyvHD9sgpG6z6o5yj0x2wylZ5FFnFUMYlXSk8sTfzQNVUvfZSdR+HQoE1LNS5ubzCjbBijQ1wNEr3H2/looHi/E+rVwySLKK
 dlAtlli0
 PWk3TEmrnIiA2pMVuL4K/FDsOv+tRF5BPFbpfl7ViauJ4F3blPDNkVF9L9wNk902RaGTqTcG0HHH5mxDh3q42W3Cve5QkL1dY7ylKI0O0OYvyTPNxDglOrsKLB07sCmbhORTQwq83j6Oq7iQOLUbWjIajMMuZidlEShBfT7nnpXze1PjhfjZTqPjn964GGMO2WiEqmg6+ao+0orW8U5YWPKocwS5EhIi1QTbj/+Lo3sap9yT/k5eLtCMn+tI5AT4qVFycD0U53JOJJRqoTPe577/Daxw6HTGqBHRp7R2l/014q20Z493LU/+P7BQqdXOAWLMfmWvYak4q0tEcBCixTdn1R7TSzwjjVLoyws1xUfyK6cUDzT1GBtoBR9DhQKTm+ZM9o/Jgt+IZbSJcdzvnQNHrBXbysoliYlGF
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
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
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
2.54.0 (Apple Git-157)


