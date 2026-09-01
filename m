Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25976C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5086B00C2; Tue,  1 Sep 2026 09:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184DE6B00C5; Tue,  1 Sep 2026 09:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075CB6B00C7; Tue,  1 Sep 2026 09:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5EA26B00C2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 583071C1D8A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
X-FDA: 85165235274.24.5896CE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D51B8C000D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMO3erO1;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bvNMg4+ohXrFj0RX6YNja673VETP6Qf2VRqwotq06F4=;
	b=WmVOpz080rkHgQTumKC2OdXLg0c/DmbHxh1PiAH0KnTWpDWiKKOVGFgiFtK5acGvHvd8V/
	NMJIYzT2F2rsc+8IEf64aYxsnIDDFpwGwkP/Nqlq0DAiBFxK0JiDEetA92Qc4h64NoQ9DI
	68mev5Y0JQwTq2+V6hiJgCAEZOGXdJ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268415;
	b=2OP+JbF+BhisWEU1XfEmX466blSff5ocHm5NC6id7nQ7dTRgYJH81YLFaVHyBxual07Aou
	9wxfXOWuKU1DDfk0Umw2EFceUeaUQ7quVeAyMCC8XWjyCg+LFdIeRfJ86Ec7gdwkbJoJcy
	K5yNoVWFrBA1cKbuibObuPoqc0DnePc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMO3erO1;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AE0C6020C;
	Tue,  1 Sep 2026 13:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DD61F000E9;
	Tue,  1 Sep 2026 13:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268415;
	bh=bvNMg4+ohXrFj0RX6YNja673VETP6Qf2VRqwotq06F4=;
	h=From:To:Cc:Subject:Date;
	b=YMO3erO1hgqSNyjhZpaWKn6S/jtbTPvOqsAd1zgh2s/4gKJthLl4cJJmmS3oQUTPA
	 kS1WDuVwssqIByTypa31c8WlRKjzRfgMsTCu5r7KQIiJJvFk2xsq0n3No49nr1DRsK
	 rEWtEvCxwPOzm6Z2UI+81nrd7gv7SmAHYOiqS1+eO63I6d9E5Tcl3GPxU8pyLnIRIr
	 04hqNgBf28sx2e/OblVrdm+EWccJvG1c7hVpW6BER1uXUZ97zjiOU6RfN0snC2hcq4
	 UIo0ag50bu9/nE/BWDi5pecqeH5GwA9jaZ8yTvJNuQaszUkZrCqjge+uwNralc0fhS
	 UfQTKswq3bv7g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/7] damos_apply_scheme() splits a region and apply the action to the
Date: Tue,  1 Sep 2026 06:13:17 -0700
Message-ID: <20260901131326.97615-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D51B8C000D
X-Stat-Signature: m5cww51yxrfwagn8hryz7xjft337t8y5
X-HE-Tag: 1788268415-74046
X-HE-Meta: U2FsdGVkX1+OixksW75mJwfBXQrYA70pINrSpgutBZ1i+PCIlY9i6J7XoBwTykMg7KazafMVw7WFHEB6JdblOTYw1Cy6EF7ycX0U8lvMicyOQ7hMCNDTT64+WLOlK2iwSbtlgeZVlxxB5eEq82d7ritli5Y7mjBX3hUIjoYvozmkTkSm/GCGdtfVEauBMdBy8Czd73yfqe4qS2d3FYdsB2DsNejwCIlcp7OHPSvot9p/Kc4BL9UWC4+KJQJm0VSRxFnrj9bqOs2XtJ/ITZuAn4A+4nFwYxnkJ4M6l6e0wxu9NlH/2B07qjvsVT6hDYAoQCbhVKckQjGgW3XuM7TpDXRiPFSlhAA9HjR1MYnXFZx+hKnPbp05aD0Skhgs+OPa2JqDXH4dvhOsrTBD/Muur/OC9BpCMhhJpkkIVeGL/1Ml4kYYFYG9WOwD7q3BAvDihd4oeBiWBOHar3jJzUhMHJym+xMdLAlXUCBnkc+jYRLIsIIvvV4nqpgUDg7mA/FL1GFPzYw1BFEl0a3MM18m4C6EJJt1afi0D7ppG/svokAxw45ONOvr1hEgeC5ITthBX5eCTvJhjPKZFWnfn1yuJaoBr3VGKUtjNXKs5hTx+QTKfZILTdwimqmjXPbx2yNy9S9yqTgTV4GXjViHDP/2h7aukF1tAwhPIMCf+A7zIrmiPvpO740I4HTvo19oV2WvN9/0Zs6xumKg/TM3OSm8Eg0AW8SEygF9BVWFMY38nqQ07tHknUmZOSm46FoD5O/sE3Qkt7VSRJhOOS7z8kIhgbf579erEX1j7i/vUQKlwq+28BfsH8LOqT2bV5mKyVYfuMYAi1yFUNxTJk3sofVD+z7QlAZM/GylygagmrQeiutinEqht5lV9Lbr8h6gjjZZotZECoDyGilmuuZloovlNrUCfAPR4cbHWyvwLSBCbPNm1IIc8f2bfOB7wqR6j/69E1xxDcybMptZrGuYRjv
 cZ3XvBIK
 HYpB4obm8tqja4zCyK8XU63m93lVlcohUpvb7enHNW1bfqzg7ydaO0+jK/YJqQ7xz4rkABDssSs81xubKJeDe9b9oBXHvIzUZ79fn8dtiPKvseBw+ogHxpf42BfWhvz9sqQS7R89joXis9KS2MDFeImAK1UeIjtbPdcZF/1zSpnvNzjPqvcnaq7GRt8m22VGA7F+hieFWgqrkwBT17dVG8bPy86/9I/+89/rMUkM7IgRbjSAFVHehCCxNPoOHkqzdLQriE1UDt7eFAR9nGZnfoVxfe6bTYpDR+ozlv04NVI1YKgi7uNfGEk+lJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set
min_nr_regions to set the maximum size of each region.  If it is
reasonably set, the transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org

SJ Park (7):
  mm/damon/paddr: respect folio end for DAMOS_STAT
  mm/damon/paddr: respect folio end for DAMOS actions except STAT
  mm/damon/vaddr: respect folio end for DAMOS_STAT
  mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
  mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
  mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
  mm/damon/core: handle extreme memory state in get_in_active_mem_bp()

 mm/damon/core.c  | 15 ++++++++++++++-
 mm/damon/paddr.c |  8 ++++----
 mm/damon/vaddr.c | 10 ++++++++--
 3 files changed, 26 insertions(+), 7 deletions(-)


base-commit: d93d8b0181065f8375af61e3a18bbc7c066a8159
-- 
2.47.3

