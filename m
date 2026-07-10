Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52419C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D736B00AB; Fri, 10 Jul 2026 09:47:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA77E6B00A7; Fri, 10 Jul 2026 09:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFAB06B00AB; Fri, 10 Jul 2026 09:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98A3E6B00A7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 316BE120470
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:09 +0000 (UTC)
X-FDA: 84972993378.26.B8E25DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A3ADF14000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgV4ydHt;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	b=0yTUK/r0w34giXl0hGiwZ9RTv4kFfXQGd+PCoURbuqx9zAEfa8w2+cxP/k9ThjrlanJ7IT
	GZeQTI14X7RdBhXac/6eiYR6x2xwoU8PV59aQzPZbU9OmaQPFiqdoiMhWKsc703D6r5DqH
	VsuyrPkxDlczu+zS25RIe1XjRz2X6sM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgV4ydHt;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691227;
	b=qP53sFjZCrZGZGCTSoZ79upYmBsIt9bKbnAuT7e6I0iLh1orZdmKMtLgiA1NweNLBVcuNc
	30wHGkAmBfOEpyXl/AknMlZSKw0dLtbZXXQgldQjzCNEcrYInAAj+tyepC2Mmg10NX/Kuw
	b+gmcS7V4fI3jKFKFzhVloZJye6lECw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E09E43DEE;
	Fri, 10 Jul 2026 13:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B5B1F000E9;
	Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691227;
	bh=KtGhb2uuQghnzvwRekFMe5vHCrkMdKOrMY5ghfXYhj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgV4ydHtaLl713bFf0XEoTAhOBbrOFDt3zX71GIXZAjf4O7Vrc2IFz7HmMQBTbg8R
	 iO6mgiRfKyjgJixUjoOc7l1+hozdmwdXZlaENLpShYpHfnm03PHjkEXDyLjWewiphP
	 y/G3GhsoTp0lhmpf2yLutE22UUbLbDvSG23AyUl6ksr8v5Nn37sViJL8gRyGkLKK7o
	 Phv7O99XxfPsHujP1gZ2zTVACxi9oefJk5NvvYMCTUv+W0JnSXE5tVRd99HyQwb2zx
	 gD0mx2wK0idjc10rycP3IWkAUOdnPTfcSSFWAsS/9sDLF1LN+O699PGVTQjlZDdREW
	 F2E38iwPf9VFg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 19/19] Docs/ABI/damon: document probe weight file
Date: Fri, 10 Jul 2026 06:46:48 -0700
Message-ID: <20260710134651.18084-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6qx1ess6y4b7yq7kaqzyjcs8jzempsi6
X-Rspamd-Queue-Id: A3ADF14000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783691227-82376
X-HE-Meta: U2FsdGVkX1+se2KX671XZgl5NaqNz1JTTZTeqhr2w0hzMO+eC3jn73s8x+ZpR306+Jk0tJo4nF2z8kbMSa3eCzNwDzZSQ3qTNPgHrdi5JPQTWRRJUxS9xrWTsIxhUXSnNQPjCJrCNrml5uqUzD51hzT3qzEmByQgSjZgXp4Xmhqr1tyr699N22kzbeN21KRKqO+gq3qAKqb40Hof7A4zYVGm4iMmP3Xf9t6MjzPmdu3mu5pEf1QzJpkgHEWhdlqRPtT+WKctNCoupkkTJbtmiRBHpg3gz8SWe8hOQ7iGNo+JKzffKodbcpAI0jBzZyYBruqibGu8h8vdV/yAobukwad1k2+P+gvGeu4G+AaYDydTm5m4sEkrsL0gUPeCrSZ/Vpg3ikWFe8+klUlgQr/0mi4ihCXB0KBAE5uNUUnNI+np31flXWmUBTWQDWaRPnA9CIC/aRy5zCcmgzCe8pYtg6S+qj3OzJ8l528mE6vLUIVsFwk7iSC620LjtKK3ou86Ro+FOKhW/3VkRlqWqN2pjrxoFrVIKJJb3shEXc7sQ2NiAVShtxvOJ6FStELh6u0oF6IlXc4m+eVqU+aUkZQhM3ew9zcjf2YzjcykoE3kuDTKrIWUAMtVU8I3ET/bS8PG3/BYEalXg6AoQ2dGHCwYCHDnvNIZdxNYYn7RCgyhVP65bvr3B2cHg9O5q7dc6PN1HPy55okPYhSEVJo/TpDzvnLrbZtyVRQ28A3cRlAF6Eq/Tc/XNXvDFsWKOtZT+PmwVAXFe13OjbiViIvacCc+gO3uVXnQUixosWF7eXc4TNjeKiS46acXiLhHS2ZZNZj/nIRdsQ6zJvCc0iV/IlNh64GUPSPW+ILWeMjEIVvid32bx0JIDl4OUUlIMkmAdfhzN/GFwafbvZAADEd14PvYrJebSNOIZ6wuuAep5vNnYMmQbJHrWRfxEw1rI8rMZ59va4peEwH/jjmwl+Q/qDq
 JgBsx+Le
 Dbc1EsxFLeMiLqxRoX62UD8e3ZUmuwRz65XwpDxMB+h0++JeADoHmhlAeDcCAvRmtij4H8887+g+oBVWZ8xxY/WXO0Nw5LbmGPrmH3h/acZhEIdfVwtoonFZpmuqwR9HlguiwNvW1r9avfq2XSE0XUtVSy5mTjUcLxDsN0n43hzggImaKoFusYZgy+UVFkFMDwZxZRGrWU0Kku2eXUJACmUsLsldWDdqVru21W0aQ6++euuuTX+9QKaNfKZgCA06bgjXrODa0vwKW9wPMdGCPI8lEijFPxFDiPE9kg5yIBiSxnBcu19zgrqdPLq6R0NtkVlEN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added probe weight sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index dd6b5bd76e119..907a504fb64c5 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -164,6 +164,12 @@ Description:	Writing a number 'N' to this file creates the number of
 		directories for each DAMON probe named '0' to 'N-1' under the
 		probes/ directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/weight
+Date:		Jul 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		per-probe attribute weight.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

