Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F85EC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36DE66B008C; Thu,  9 Jul 2026 04:16:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345766B0092; Thu,  9 Jul 2026 04:16:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25D086B0093; Thu,  9 Jul 2026 04:16:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02E3E6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:16:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 796E412043B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:10 +0000 (UTC)
X-FDA: 84968530500.04.B2E9047
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D252C10000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZxGkUub;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qvewSS7b63tSrzUZdUsephDfi/zdfW5EWtFI5ENXz3U=;
	b=imhSplFLWcIZc+sxesAqpmSeZ6KX8bpbveYREcZJVAUgLGNMOVE5f8CeaRWCevddn0WaIK
	/t3zriavIU8KsQI24nPHGG1+b1Hjf+5lzsvD5EUdPzj5VqhV0BBwrTQxlBTrIZs5q2RwKv
	reuzQSiKQNxDlq0LzYkEYJzKwhx4fSw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZxGkUub;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584968;
	b=52X17ynOmHGE/B5ZEmPXdwRf67CWr2sTlfJ6RNLkHqLtkf2l5Ha+tcmB8Gt6nkhbMc3/qr
	pcIGAU4UP6bTzpRzzMJhYq6qHQab4xSct+cpwBFW+6YYQn2i55Hfje72OQVi7Unub663tp
	Sf9/4xpLupBow/BaqAw1Bku6k3waXTw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC61A41444;
	Thu,  9 Jul 2026 08:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006BE1F000E9;
	Thu,  9 Jul 2026 08:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783584967;
	bh=qvewSS7b63tSrzUZdUsephDfi/zdfW5EWtFI5ENXz3U=;
	h=From:To:Cc:Subject:Date;
	b=mZxGkUubOzTc4ZRXqiynXnJRvHbMLMm00iMlQnbtyPRgIvagwwWd1teCNo9UvKo9c
	 ZAH197LiEqWupan3jWekkweb5xKafoLvri6gmGJx5fMy+sjqJQhvEdABgIHpGMN/Vz
	 rrGdCrNwbpFhmd93sAchGuz0I07Mkt1T/zAqL5Gq2mCWiypozMjiSyrH7G9KkECwtd
	 Gf5ffnK3qIFWTuz/4ev90FmOZ5Lnu4AUEiYWjM8YpemG4fXLNNfIuwvmVFP23riYRS
	 Y2p8t6NKAQWzVA3w9frqb0r3C+caRMgA3jHHiPg0zxLDMIhiS0OZipPXsF7bPPq/sb
	 VAp3uo711JKnQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v2 0/2] mm: enable lru cache for smaller large folios
Date: Thu,  9 Jul 2026 16:15:34 +0800
Message-Id: <20260709081536.82768-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D252C10000A
X-Stat-Signature: t9bjp4i7sihg8uiwgiwqbsbf833a73ew
X-HE-Tag: 1783584968-312341
X-HE-Meta: U2FsdGVkX18y67DC+Exo28KK8ZKzstRDKn7ybrQoH7LsD7G0lt0zTGkmFkTuVG++mn33fumCy731InFdUvjdwNnZja47l0cIv0bDMty1r74FeQWA3EB+mSAo05fyXTR370YNUe4CvZtS5XMX6oFBYmK8+1dXtxeJVJMo7fE1WVq0I2lMAH4zJsWgO5itfMVjIM3KQsMNk6gf91tEbS0HnSH+Jn8o91jYBsk3scG9c7Mxoek7NKNXgEsu3IUX8tVujflKXNXlvNE1jgncJfnJ8GiGPhwQivwg85BP2M9KMovdmVD7XvyQ+5AVmOpsgrb535IjkmKpovV1udCI+eWYt2hbcjlBh1N59vRnNzHqkssox+UF43GEV1xVNCPAxHDbYDYUVtnxv0alot6uKEFlpNHUriULM7PWPvLsnt3X7UaB8KdQD2ZDVMCzPc0biD6AerE65LBo+WdypCnp5hiN2khg2OpmLNhBasPaGjzyRCu/QYYGPOYhgotFkOkBNlGzMQBqTs7xwW6rmc+cQ8s6kaixZcFTCOfJrrpciKa/kxpldnfcLSe/fj/FzJvO0xMAENZB52Q6pLjOYfV2VijeBeC1nsH+hBQe0xL577cQ6OvIQ/sD0jW4g3v2p0gnoUnuGMsQ2cQEvaB+d6O4/wtNT7eXavVxFWSsDL5CMKgpJCTgXiQdH20kbyhx14qMpdhhOb3Z/rCdAlgqOPf/M5BNQzuo+uiqWgwTJiv0UjkWMBgaPrevtbxXxP8QkBYF9wFbfz2lE1mHFio7OStFiZuTN1PYbmPwSQz8UuV8kEdXxbx2jK1LdbltVEcqKQzUYUU441EocwlxJE7jwUx/3oRfYmd9FYmD3ov39nFu0q32Sz4vAWxehEYUCKHwTj3l6+9R+lNRZMJn35zvv3mJh5uPA3gxE/WjMuZXL3iDYHJ0tp+/IjOYxE1Ylcn5QFGyrP+UIj1nqVK1Syc2K+pp7Ea
 /wBLfSIL
 uVXSpEG3lzjmAMzWxdwC1ME5mfdrCXGnSEe/WQ4X4Fif4oM4OXGpR4o980YgYZrSEGDtsgdc8dNt250z16LJU3Gh/ehtr8vgrBa1cBIs5Bg80dERBz25QcH4oQ3VJxWZyfS8VDafEXI2OusNIDH7LsfDuzvzS2FXtGMqpsO24AKn99+zLdVdjlzqFpcqGA0SD9KyQJ2gbLXEJ4ybzELjQyXDo4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset enables the per-CPU LRU cache for large folios smaller
than `COSTLY_ORDER`. It is particularly beneficial on systems that use
relatively small large folios. For larger folios, the benefit is likely
to be smaller because far fewer folios are expected to contend for the
LRU cache.

Patch 1/2 enables the per-CPU LRU cache for eligible large folios.
Patch 2/2 updates `__wp_can_reuse_large_anon_folio()` to account for
the fact that large folios may now also reside in the per-CPU LRU cache
before they are reused.

-RFC v2:
 * Make __wp_can_reuse_large_anon_folio() aware of LRU-cached large
   folios. As David pointed out, it currently does not account for
   large folios residing in the per-CPU LRU cache.

Barry Song (Xiaomi) (2):
  mm: allow smaller large folios to use lru_cache
  mm: improve large folio reuse for LRU-cached folios

 include/linux/swap.h |  4 ++--
 mm/memory.c          | 13 +++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

-- 
2.39.3 (Apple Git-146)


