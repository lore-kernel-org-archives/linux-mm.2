Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39576C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9CE6B009D; Mon, 14 Sep 2026 22:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57DB46B009E; Mon, 14 Sep 2026 22:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4917D6B00A0; Mon, 14 Sep 2026 22:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 196296B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 496271402F4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:44 +0000 (UTC)
X-FDA: 85214365488.26.A46FD34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9F3EF160004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bOzKjjAg;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pe5PEKflMlDglfugpw4os1GpkWtazCvp49h5WT4n+gE=;
	b=Gzrk4rvv2VzSvW+izRkEW810RxLzaq9mv7E7a/TXJQ9rcIGZazqNswFasV38o+DVSZ6SQ2
	ipjUHos7zAPoTNEYfgJc+BYB/RnsafG7vOATAUR04AqPWYCoM970rfr7BKVO7YChLuuddh
	MEyEsqAtHnQBE4QaaM+BPOXWmTmeOAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438182;
	b=mKOjgsK6+vD70jWtm3DUtIzk5o17wzqpi0GXk4VrFIy4DWQQO2A5ejTPHEsQ7qPtaI1Gc2
	CurRAiLtDqAG2SlRORKci0zZ3kFAnkcQsUsuLwrUcjs/IkgmGsrDn5yD8Tqre1c+vR0kVe
	Nz1Udz77RiXs0Axu0r/8NLw9LhIRH10=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bOzKjjAg;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDA9F43D4C;
	Tue, 15 Sep 2026 02:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F8C1F00898;
	Tue, 15 Sep 2026 02:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438181;
	bh=Pe5PEKflMlDglfugpw4os1GpkWtazCvp49h5WT4n+gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOzKjjAgjcSgqu76iU01qHfLTFRUV+6aW84VMrBPDKzyiR3TB4VohSgzjUxFcnP/s
	 1pcsfQTOjSs4hOWWoSoiiuUaexRmsoYCLuBPCzB6xBr6NIUiRCWKlAKTcMp8NgqlXb
	 95RM2jItxUu+uuqldZH3qsSfGt3X/tBR5ZGOFQF3GWz/tCBN8WXWE4adyxEV3ysa2B
	 pcpERic9oCyYrDaqoQmxpSJOKKDziBXjFknOYYd/CpPM5Q6nvjGerITGT9LRhQpjeS
	 MtePmEXuSbk2fVVu7IQ1U3KxyJRRZXAntxo5i23UTW+Md8cY+dqST0SOTd7Skb3YjI
	 491kVF/K0zg8Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 8/8] Docs/ABI/damon: update for hugepage_size probe filter
Date: Mon, 14 Sep 2026 19:09:27 -0700
Message-ID: <20260915020929.102953-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915020929.102953-1-sj@kernel.org>
References: <20260915020929.102953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: td6hsnwygzdxrk9nqcf849bgdqi97xgp
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F3EF160004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789438182-271955
X-HE-Meta: U2FsdGVkX18NXIxkGbxx3dAWIznqO773F4zm1W2cIeJ4/M1GPpqmnH+h2JvVAl0JO8lVKkNa5QvrRlTZzAbiQ+cws69jhgpKCgaFNFK2+M41GhsG/l/oM6aOalQDRmGM/PeWmY6og5uVWVJ1X3GCy1VpZ9Zi5DhcI8OzFuMJ3gcrpxqm6Vi0P7W4bfXdqR2XnOxL1IJBO3boepSnKWe2g3jcxJmjwGqYwz6nThSOmzVtEs6vrkPgQGz/NjF+PZ0jWntjurpt4dJ8LaAYadRJ6Tv+Uoj62kX9ugVbQPwH1jEx/HRsmLwJ5WXnJJQkRIZg9UNO23m4RIxVIm3rarh3bTHs/mGfb+x35fEmD4y0FMO2LqMELhM/sCgu0FMPDXvpG1tNzFxd2YONf2vmHfnunLTA/KvnYjxP6I+KvDDm9Zp5K8N+eOzMPM64bSfz6z17ddAR5VdYoyjU8PTDUiaTs+XbQYpsyncfUigOYDcWm5hNLcxIt9aJDQpYSnRxFWtsGn2EtqNGEmrPvoYALTPf+vi0ghZZqKMs1BU8R5wtGPe/60VvbvpN/0oHJGY7bc+Rn1YulbyjNI+CYxlzxhKlzGBpN9NaTr09nWZtvqnS0aZLwvQPPI5jwpknPouZ0Du8GDe8ln92wm4crVQGjDaNpdbTbqWutEt28kk7tJolvlGmGYDexaLCbG61MdlIRoNFGN4tetWOvxP0B04/NcNXuRNaxf3kkNFm7BlrL2dTiEl2FTI5SQpk3c1dv5AehDCr7lWHkqsv20Wjs7qZZTPU8K2ERDZkcpyq6rXsqRiRrD1kc+cQr7VkPRlumfGfJePdiZ4eHJHZ+dPZE4tb68YtFe1xbzP3/8ZrvgSTnHzz6WRzauLl6GW/sm8k5hpdGNJUR/7DPtY7xs4BMgvyvgyrvb9TZr04CqbbAv9Way24bIy6YHn73qiS/7G8GVfgSm9HvK28hBQ2glVl8yOT/xL
 8xDHa5Bh
 Ri1kdqZRwgDnyNEuTP7sBD7NkCvKbuqBatS+lS40ky8FKXTqv4AUd2RacsBcQy1XentQykwnNDH6mbMZAQdBuXSjQqfpJxuhUCpTb+BTvya6OJqcRu87b4jkfh71WsGz3xeaOLxiJjDu09CAwz/wrjLWZHDBw1gE0qE1o1m21QcRru7EbP1aZri9Z1OIOg8+XEw1CPwf5nm8qgjsHaRaszPxPDC1YBRKtwYsSQNtS7utfUxSJ6u1pLldGnmshmpJWtuAmLBUHrUOPVYvWQ2gC7mkcDPZjuF7bFxFODRswmEf5aqKQjcexDIo+8vZIHB9aNmtX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the newly added hugepage_size data attribute probe filter, two new
sysfs files are added for the size range.  Update DAMON ABI document for
the new files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index ad21f58f3c912..55df688ea596f 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -206,6 +206,20 @@ Description:	If 'memcg' is written to the 'type' file, writing to and
 		reading from this file sets and gets the path to the memory
 		cgroup of the interest.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/min
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the minimum size of the
+		huge page of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/max
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'hugepage_size' is written to the 'type' file, writing to and
+		reading from this file sets and gets the maximum size of the
+		huge page of the interest.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

