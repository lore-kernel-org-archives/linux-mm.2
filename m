Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13210CCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FB58E017B; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5638E0179; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01E48E017B; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACFA18E0179
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75255140436
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:27 +0000 (UTC)
X-FDA: 84041085534.28.BD5B9FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C8CF92000B
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JrXQl9tf;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oD6wgeJqRvtzVh1+Gt9B9TfGQ80ZOSSRWlzeiQsvHX0=;
	b=b3rTUvdp7vNUuhxafp6rZLvyp1O8K458Sv5aEJp5vLzjfuMQMNgusLdJQOwKOhNFm7JrYN
	ws3aJcACKnk5GV9UudgtQTSnXOePSFeC00UQSkVntjpJKcs5D97foohYMfq1wcqxUdVIC+
	QzTIfaMmb3DLjcVRw6svGP/S+nVzQPg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JrXQl9tf;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502945; a=rsa-sha256;
	cv=none;
	b=02Do5sg2VbdQkq+JNeO/xtpJW8g+/Sn73Ww1o1G4nhKGYayGGMpXglFcDZkJZwZhpj9Ff9
	W11dBlmG2m7BHXoUQkvhPBmV5TtUpDzbDPKq1hXVQDAVIaFZ+Ci2KZ1+Wf334FczW84HCC
	1ByKShCvl3g4kp0GxekGoBHf7uA0UDk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05DED45165;
	Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69EEC4CEFB;
	Sun, 26 Oct 2025 18:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502944;
	bh=8D5yaBNoORZTjw6kCzlvjtMnwf2Nw6k/T84eceynYyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrXQl9tfSD27c7Z8V6xmI1K+BHriwIBFaEIky7BUctjW6S9ZqGYYE1bOhPPniqZVB
	 L3riMN8A5k0Z8xn5kQXXJXW3oRdTsvdNe5oK3eUp7jlH1bVO3kG/WIIiu1LkkceVGi
	 +i0dzpS3yDFNwvb0jLOxPZxn+jVBgteRM6dMdWjqGrrBZbLDMfGIQ2TL9q1L5ECWYa
	 +NOu0R10XMorUUU7W6UZeYKagpAPUFcMJ8/s+oGJuhwMcjJ2+6lU55Cg7nRdzbxwB3
	 Vx+vd6DQ8204ArCRkZANQXgLdU6kTb2BqzoJM1hY2L+XYWOMwIOzVvC6gGdVIhzSKk
	 Iw1IoQL2gaWgA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] Docs/admin-guide/mm/damon/reclaim: document addr_unit parameter
Date: Sun, 26 Oct 2025 11:22:10 -0700
Message-ID: <20251026182216.118200-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026182216.118200-1-sj@kernel.org>
References: <20251026182216.118200-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8CF92000B
X-Stat-Signature: yifbom8kw6cwk83eg4tcf5js5xo8iqzd
X-Rspam-User: 
X-HE-Tag: 1761502945-45195
X-HE-Meta: U2FsdGVkX19Ougk0EQM7/zpsPp5qhzvMhjI0PSHC8osZ9ccBrxE4RUr0Fm/7oOaQvdpPg4bn7KCFaEvwkWG2uF5YwQvf5PIklpq+RBx2YImfWUM+Enyh6mconmyMAyxMF/HL8wVrVlcK9pdIS2FggSNeRDBuXyMCaL7TC2SKLJX78Y37iwmBksfIXfZfEBqKN8JTxB+0xjL288jeiGxGpSw5vZy4zGgyWts6cF9o8eqKV7zyxxvdRXqn84aHqIXE2x8SXwPcsvh47HUizPxpTu27h8gGYQzuY7Ea78DNP+mHOx0dd2lJCa8YskdjLV0TAoM5+czKzgCw2PNRTJ/go7BC7d9nwTFaxWvmFJeqUqx+ORRI1q5/Q1zCkuymUdaeCJcwdo4yGTdXyTyklUgbOnuZxOytctzXHI0KkrQ+/1fkfQTsWMuUFTQFss6Q+zYGViQSWIbRKI/xvaEHqeigE6rrfh3X4C/QEqFxsVGIl+wnjeG96ti2xMIYh/FqCeOcxy2IuSl+zBHe5S3b65LiOMoSYTeCmcc2sX+hyGAivR47GHN2Q9fdu/ExGqNy6NiXRzeo8YMhQWgfzC48fYxSmMicNcUuJyRqaBeFyg2wmoiaqzZ6asMYsuL4oDcSbcyaWoxeUAWntwZ/Lkt9w7Qx2VZkxiBeojqy1QHZi9Wxa+Bxy6MmunAa0M1bgz4jg7FOyK78wDeXlo/o7kaoNAUe920rUjBzdFanUjF7DOLdB3AV1k6ylERhNvHPV1VRvxCvcb13NUpgjS8/uMZ+5/GWKaIJ+WudNxqD1gUts96hXEPQipzruFuk8N0+3/Uv29s0rghEyLYtkvfQTnXlRayj5p5d3rxRhb0693nMg7/e8wIAbTZUPNZ2wVHrJXIplDm1WqfEd7QL2Xb3yF/4sCpi3cJNZHQWNUk+lCfvlQjPz4qvt6rI9vQaqHroG8N2o0TNhkkc4rjyU0/eNBhFTTJ
 36g65gqo
 D4y4W7Oi+RKUpzI33rGc4vLMEFiKZQoP9zAMnygDGqQ25EUYRRVJrp9uLLYaPZGQWAUb0THIB0N1MrN7r89wZql5Kqsmpen3VY0s/EtIjMKKmjr/VUXfTockd4YHGLMDpTV4uRlETVlFBtoMOOmTe5wmTupUA2/nSH7RCoklWKg36iS2ZQaGpZg2kSqZiLvY07wc/FwhvIt3HSgvFBv0BB6kbhPN3ytPx3jmm3Ril0kk6CnKYYcDBz3eny3zcp/S+m2cVKAcEx8/eXdl0yCZTeWQvqO0OfRJawEDt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for
DAMON_RECLAIM") introduced the 'addr_unit' parameter for DAMON_RECLAIM.
But the usage document is not updated for that.  Update the document.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../admin-guide/mm/damon/reclaim.rst          | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 92bb7cf1b558..552a7786b082 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -232,6 +232,28 @@ The end physical address of memory region that DAMON_RECLAIM will do work
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
 and reclaims.  By default, biggest System RAM is used as the region.
 
+addr_unit
+---------
+
+A scale factor for memory addresses and bytes.
+
+This parameter is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_RECLAIM.
+
+``monitor_region_start`` and ``monitor_region_end`` should be provided in this
+unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
+``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+Then DAMON_RECLAIM will work for 10 KiB length of physical address range that
+starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
+
+``bytes_reclaim_tried_regions`` and ``bytes_reclaimed_regions`` are also in
+this unit.  For example, let's suppose values of ``addr_unit``,
+``bytes_reclaim_tried_regions`` and ``bytes_reclaimed_regions`` are ``1024``,
+``42``, and ``32``, respectively.  Then it means DAMON_RECLAIM tried to reclaim
+42 KiB memory and successfully reclaimed 32 KiB memory in total.
+
+If unsure, use only the default value (``1``) and forget about this.
+
 skip_anon
 ---------
 
-- 
2.47.3

