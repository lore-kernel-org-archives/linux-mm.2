Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19BF5C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A518F6B00A2; Mon, 14 Sep 2026 10:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04826B00A3; Mon, 14 Sep 2026 10:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A2D16B00A4; Mon, 14 Sep 2026 10:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE3A6B00A2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:20:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9299BA014C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:06 +0000 (UTC)
X-FDA: 85212577212.07.73018A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F108A140012
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j05Pspcw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395605;
	b=lbdzeXi4HDa1GVOxmxq2Eq2SEjLklDMBfo42LDP9kohx+j4jKRy9Gai16cBflzWN5nGeuP
	Ce8Dv/3SyXhRnpmqH9frGeQh8u5AH5z40ZkzjTqaeIbE8THvYuoeaUvi02FJ/uuvRt5ymD
	XRiPCtks2givB5hZsa3fmcVRzGSbRfE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j05Pspcw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPk8Tagd5GI3QkdQHiiyppe9/WTPuBoNQc9NjPN9Oyc=;
	b=1p7N7G+5izgNb9vPPOJ1+4SyREt31OEppRWtOEfKuwJNK/peQRYn6UTNKEEnT8X6wGBYT4
	OT2Z4p+vWWf/wZPbGfNVys/khFN3wYXkkn811ijyScOL/ZiKjUuC1fZ2SFp7t3qX+F3K9I
	8pSW59YRzyUZ3IeP/xshBuLjfDHOveU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EC1743DAA;
	Mon, 14 Sep 2026 14:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0891F0089D;
	Mon, 14 Sep 2026 14:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395604;
	bh=CPk8Tagd5GI3QkdQHiiyppe9/WTPuBoNQc9NjPN9Oyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j05PspcwD1dJGHyH/LYdc9O3hnSqtNkv2srUWvg+1Ke742GffM1skFmC9H3+a3ee9
	 b3fCr4TLPknIhl/o9FRyBYY+GDPpKomdzzROhn0xparyhpMRR3I8/Vs8AksRmrFxZV
	 X/u8bVnDC6UtTFFit8QqPZ9t8+fWwOo/PUyH3ErHCMJw+gGEtTfaQ8/1gjUCzNlfu8
	 cg0KsMyqJX94mbtU5GVIaTkUzPbWBDNVvYKGuPBnaIisCQ/H9j05pxUCDyUUBhO6EZ
	 l72feSfY7rOlHro2WMR01XgBStY8l+QwpVgFtmcd2z5bc66UU8Do8YGQ5wubhdUByu
	 WEyEkLQNdOd8w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/6] Docs/mm/damon/design: fix typos in temporal auto-tuning algorithm section
Date: Mon, 14 Sep 2026 07:19:51 -0700
Message-ID: <20260914141952.91465-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914141952.91465-1-sj@kernel.org>
References: <20260914141952.91465-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F108A140012
X-Stat-Signature: 3jx7hou31qedasyntiecsyd1wdw8g7jt
X-HE-Tag: 1789395604-963687
X-HE-Meta: U2FsdGVkX19Ojt479Ta6sM+Yhy6Wue8waQQyrrBhVLsJmXt3/xads/qxVNDLtMxKJr70Fx+d2pvNacGZXGM81ack9hJlbe4ZbJEMAqtHiBRMSlH4gaRGFMjOtZSZKY5I3nw/kyhON6hOn1N/XX9YzNVhGfyO9us3HCdnc2oqD60EgK8mNoM6WCqkhWytqAB6S++o71UP3BVZ50anCfKbI/lA/8uoiD+Dk4J/v3ZmsY/E9vXuS9Cekdx/dhYjE+SwId5OrgfEoL53kBWf1+vLrV7HCvBxidoKQ+ICnrAvj/+YwcHozaW5YmY25x0pGAbVTRCZBW8LlXTJN/YL7E8NcgHzyrnOcraXYnL9o2cbL4B34illsxgtt+/b6ZxPcRDQtjhYN6ajXYceT2iqYn7NovaLhnQKmJAHsWs5GJPxCvq7MMPvxYX4lXCw/VoZwBeEFwEys7YJMzgfavgNlpwyevHYZn9l/Aup7AFGtoWz2kKoYGPQ78r9xK9mgrBOamPUevyFFP2B+8yv/hpIAASGCGhdNDdtOJEZXWHYSNi4Wly2VvHBubMdAu7MZ2u1giS6u/cLQ1L1+Pk9djR05G3jp3uIAdoyu/LlBBGCgIEn8jEb0udE9IuF0P6BZuhW/vgGzO90qWcy/zahvp/Rdh7RGF9ir0njqRNyv9FPv7R2A2LtzLPzyDmE3a9sF8CPwlhTtWfTqmV/vNjVzXvBiGx0mYSI6mhBCZe2ovFvZP/Jdp/mcPa2E3dpx27CTZZ5L50cNWjoH/BLn5sloerwsROgA8Xv2nMtEBZ/gPKgH/No+atb9Xe0FIpo87/7k8FpIZTr6dxCkXJ3Xvrz1vggDDuAYm/Pfvp44b2X8op+5lVRRnSBQCP1ib5SVAgVEoFzzbP/vs9CU7wjgw5pZCWHdwoTXM32H8xUkJZrCNKSpa6XKl2oi+PzZXRbo4cHoiLVp4aI9zjEeKsdH50qV/aZCA5
 X6eHDiGJ
 oY6UjrvV417WQhN5eboWmdoeOKF+yLghw2CaANQbF/3mpmncB8+KTymV19T32JhpQH60ClStAXZ1NUvJw7stYH7qrJhvu6xQU2kGrRc0Is/8HdQMbyk3JX04b/RAeAd9q9A7aFMk3OoleT04mqNORw2G3eAjiIUbIYukWVbNXtS2jErfqu13ZhoZnMj3+tkSh1oHCBqX+toMVdnOWlrqR50Mk9E04KfwL0l+zFFd5CTz0zGJUfZx3rVl3kS4XaXJPDFlc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Correct incorrect references of "quota" to "goal" in the temporal
auto-tuning algorithm description and fix the square bracket formatting.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260911093314.156875-1-aethernet65535@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index ad09416dfb21a..707170bcd1b33 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -694,8 +694,8 @@ There are two such tuning algorithms that users can select as they need.
   This is the default selection.  If unsure, use this.
 - ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
   fast as possible, using maximum allowed quota, but only for a temporal short
-  time.  When the quota is under-achieved, this algorithm keeps tuning quota to
-  a maximum allowed one.  Once the quota is [over]-achieved, this sets the
+  time.  When the goal is under-achieved, this algorithm keeps tuning quota to
+  a maximum allowed one.  Once the goal is [over-]achieved, this sets the
   quota zero.  Useful for deterministic control required environments.  Note
   that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
   <damon_design_damos_stat>` will keep increasing in this case.
-- 
2.47.3

