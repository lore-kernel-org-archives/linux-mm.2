Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6A3606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G4c9ftAQ
Received: by kanga.kvack.org (Postfix)
	id BF8B56B05B8; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA91A6B05B6; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC286B05B7; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8553D6B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7857A0354
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:36 +0000 (UTC)
X-FDA: 85409655072.29.6DECF2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 57CD140002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G4c9ftAQ;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794087935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FY7qwVWBZaVu0fZDA6G5pfiPoOpiQaFFaAvwMZq9K8Y=;
	b=sFPsy10RuQRWNzLByxwIW7y8HhKoE8aNQv7DCM5PCWTG7JOukIuZWDAjh4YgSQhPqOCfQN
	HMaDJT8bNYY7Do9QPvGIfYG4/6zgYivHGqYn+iUdZoP7BEAOSqHhDKEwu94CbfAFLuIAJC
	JRs2/k7Ub3nLAaFnWMUeYw+l/sS1On4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G4c9ftAQ;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794087935;
	b=R3XgLZlNI27Jgesckvvtj4FrLBmuzXIoH8Eu2meRtQZt2cMoxK9MY9oZM+rHRdfHUeGjUR
	wQUQY72d8UN8Do0YLQqG0ymCJiuXcVI2RsggUaU9p+z/3TYh1AmWPHqhu+gwEcfs8AjGUh
	w7OsstE9y6GmGNHAd23QoTys8Jz/5a8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50D6C43269;
	Sat,  7 Nov 2026 21:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5FC1F0089F;
	Sat,  7 Nov 2026 21:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087934;
	bh=FY7qwVWBZaVu0fZDA6G5pfiPoOpiQaFFaAvwMZq9K8Y=;
	h=From:To:Cc:Subject:Date;
	b=G4c9ftAQlcZVnIcqMjz+xNKtNkGQzTDKz0PKeR/caHowjELL6QFJ8bjRvDrpXllPN
	 ngix5yUxQ9UvJiLOq+vXuFQ+52RBJGrgoAoWq44ZdEv2AtWdl3wjbuPsFG5xX/TXh3
	 GPouKTSkyjhrAc3ZnGu5dji8yydj3Lb7PbSgGb0ars+wlhQL8POcPngAXEPova7I6C
	 GTRhmtii2jl2h0ua+LnUuHtNuyw9XuYBTExJZjxStUmJN3yDLKZMtwSVeUShY/yM8R
	 uQw3w18qEOOeYV6S4Xz2+6LBYGVEbMkpip5WhEDWTrFNwM60AIOAzIOqO3/4T14wui
	 RDomJEREViHDw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.12.y 0/5] mm/damon: porting fixes that cherry-pick failed on 2026-11-07
Date: Sat,  7 Nov 2026 13:45:19 -0800
Message-ID: <20261107214525.304638-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z6139qnb1p3q7er8ici9953fhhwnf9kw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 57CD140002
X-HE-Tag: 1794087935-755604
X-HE-Meta: U2FsdGVkX1/CZouviff6lwupyns4CeERMCDygATWZE2o00lqpggerXV+9qgvN+AT7IKV6GQpl0qH1A0HlnXeS6bQDwqOtm6FhmGhcIWhUxkCc3V+7QrL7Os3bOLjJ9+BInkdilnm1t1w3Vz3WM+02nXlvjWqI/jWSg/eq1WBnbNYpGpm3/WAKO/T9DLPdfqVASFy3ywCFDKGLa19f/9vP33IGTowhunD5yfmqcI+IJP+Iszz6YZq3Cjas385azd7b/OFm9zebSRgoXBJbgpYBdnyNs6D0r9PJCRN6IqMTLRrAHc9djkrAOhEbLgcsr7UNs7X68kK3dUj69tM4n6vlBB65vGRMR3XBzMC/Elnodw+wmfIvpXHnh3OAiXfFIqrVf3c8OGCk8rGLNUJKywYFM44i1BGP34S7tbEp2+Jpgi5PQWab7NiW8CAyVzHhPeYgKDlRfC8ojMRzAKOydX17egwC/NgVTk++UTx/K1ncPxMQnn50/0yRBMEFCkH414TO6AT/0pnwG+wQWNAg9EXyfBUVFYzhqS89e5+Kt3R8zEM2hECRpscUeLkjIE2JSRWcGroIxDQNNFtxcLc7+82m24gqcqmx3YM79u+q/EBilXj8L9omtiUQrK5G3DdP3AdEtK1/+FmfE5Fq58GjhsBt6NLcUL9cW0ZOdb/eZn65hppsM6KE3+PUD9Kw/5w6KNniWnZeUOPgegET/44IvoXBywpD6kER3uhJXQhV3UUugZI9zzVRWwyIP5K+NosmKh4qY2cgo/P+B/nU/nRVu3s4sXVmWUDDZYeoPzZrTfIHO0+s4U3Ni3NJIcJrE7mrgTZ6UitgHlZkkzVOaT87WSeCdrQkmjGkvdPHeVwoEJoYXsL9wW/PO4lOMgF2InavBQ0+rUkNNeJqIJ1CDLcR53bkIwKaGcGuhhVW1D3sJ7ta7d0lga0hoZo95bdRh+P/mW8AOsIRwcqNdVEDb5ce6p
 u480HUWs
 AQc1QxF24XAi0w/Qnx5nhh7RHmD7xIF8rgM2zKSRvoAxABuh6AZWcdFdjuesaOUtxpBKuwS+Aok4rByUQRRbK+LYWcCE53J4EAmbVUv45Bu4GSkgLFStktKTZ3YlMkq5yGoLtjI5somzGkpzp+0HPXYBabbBLbsS9dBBurB3ll7aSWCr0fFtyHIp5ABfsSFLzvFwt7LQwMBStIyJ3ai4+wr4LhRtCWYLctRq5W+K46EZUIrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Manually port five DAMON fixes that cherry-pick failed [1-5] and turned
out to really need to be picked.  Note that seven patches [6-12] that
also failed in the same day were having wrong Cc:stable@ tags, so
ignored.

Patches that this series is porting.

[1] https://lore.kernel.org/20261107051942-failed-6.12-90c2fa6adfed@kernel.org
[2] https://lore.kernel.org/20261107051944-failed-6.12-1613ac9edf38@kernel.org
[3] https://lore.kernel.org/20261107051946-failed-6.12-29c6084658af@kernel.org
[4] https://lore.kernel.org/20261107052624-failed-6.12-bbeec2d8324d@kernel.org
[5] https://lore.kernel.org/20261107052626-failed-6.12-5695abc4e742@kernel.org

Patches that also cherry-pick failed but deliverately ignored.

[6] https://lore.kernel.org/20261107051949-failed-6.12-df7d9a0f8d91@kernel.org
[7] https://lore.kernel.org/20261107052123-failed-6.12-6f276422aded@kernel.org
[8] https://lore.kernel.org/20261107052125-failed-6.12-a1c7fdaf1657@kernel.org
[9] https://lore.kernel.org/20261107052128-failed-6.12-1bfb9384ae0e@kernel.org
[10] https://lore.kernel.org/20261107052130-failed-6.12-cec08aad3def@kernel.org
[11] https://lore.kernel.org/20261107052132-failed-6.12-409d2ab6d982@kernel.org
[12] https://lore.kernel.org/20261107052135-failed-6.12-1d2397b2c414@kernel.org

SJ Park (5):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/paddr: respect folio end for DAMOS actions except STAT
  mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total
  mm/damon/core: filter out damos address filter-split failed region
  mm/damon/core: remove unreachable damos charge_{target,addr}_from

 mm/damon/core.c             | 59 ++++++++++++++++++++++++++++++-------
 mm/damon/paddr.c            |  6 ++--
 mm/damon/tests/core-kunit.h | 11 +++----
 3 files changed, 58 insertions(+), 18 deletions(-)


base-commit: 76e5c9c4cde792b3376e382e973c8ce7b978496a
-- 
2.47.3

