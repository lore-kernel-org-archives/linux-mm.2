Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CB7606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HgJx9ICm
Received: by kanga.kvack.org (Postfix)
	id 92CEC6B05B2; Thu,  5 Nov 2026 13:39:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DDCE6B05B3; Thu,  5 Nov 2026 13:39:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3706B05B4; Thu,  5 Nov 2026 13:39:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2166B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:39:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5AA7A0BFE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:35 +0000 (UTC)
X-FDA: 85401928710.01.3DF5307
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34526A0003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:39:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgJx9ICm;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793903974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZp0d94T9bPfx4eAPUckZTFJ9UR5AeCdX7IgpGQtpq4=;
	b=mA3kAijZ+OyRi3zPd//zHsMYvPtePWVI91WjoPXcVQuOvFLQasPpWAakgSGh2jr2bVc9W8
	pGCtAyXvUhbhk4tvYCiAaXoEKo6N0MEMkbR7liv2/Ov5z6HiPfhYEHIAWwiZMTwkaHyD4v
	OqjO2ECEa3FheG37HvQULceoD4+QOX8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgJx9ICm;
	spf=pass (imf15.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793903974;
	b=NacV9oDyM7LGlJAG+Ur+iA95gH1whnKNbwopL4kxDR6h6pQ1ncbRfoBF9Z1u0QZtJAGNKt
	aYBT0cuzIOwfedJ7vGZgi37/2iIsAbWJpTOob0j7OJoqNs1MaoClYfDMXUlu1+0VJJWrCR
	LSk8/1VBQPl+eH9ha2wMrNiosT2nt2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23F8E41612;
	Thu,  5 Nov 2026 18:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0241F00919;
	Thu,  5 Nov 2026 18:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793903973;
	bh=yZp0d94T9bPfx4eAPUckZTFJ9UR5AeCdX7IgpGQtpq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HgJx9ICmappF/L2PYdIE+uSw6YhVEGNvmYYx6GuWvPPprAxt5X9tn2oE5WsLeNIrx
	 vBBkt7b16OSGlxFlO7k89i123kGYOnVAua2mdYGLuojPXbhqyaRhNOe2XTHQ5Fq9fK
	 jUkhQ7gX7tuAlTJ1piURzBFzJesC8Iy722W8HjoKmb81zT8wFAmOkdE41uM95u+xZ+
	 G4oyRHDSuv21yxy7zgOIKnUwuLgf2IJVB8/EuMpi/xMGbZL0L0U7hlzs21Xwi0QjAu
	 p89v5OF9BMeCNiRHiJI61Zc0u7kgLApGdHcEdbDGlCTTOdTEK8CQSnCkh1lDSFiy7q
	 jtmJ4udw9uSjg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	david@kernel.org,
	yangge <yangge1116@126.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Bundschuh <mkbund@amazon.com>
Subject: Re: [PATCH 5.10] mm: replace free hugepage folios after migration
Date: Thu,  5 Nov 2026 13:39:15 -0500
Message-ID: <2026-11-05-1-daily-reply-0010-mm-hugepage-folios@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105070150.3093908-1-mkbund@amazon.com>
References: None<20261105070150.3093908-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6q14b5bc6wpmfwz1sri6xwsnc3qas5zp
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 34526A0003
X-HE-Tag: 1793903974-306536
X-HE-Meta: U2FsdGVkX19JbLABlGotG+qKCeD4zVIbWFEapKwVm7bMHhjLsVdwx7mDpG/BmPRT2jeoYBdZRuUYzF0pLFAR4bdNdpquDa3hi/WgByCB1GzP7kf5/rNAp48006v5qYPGKz57pn3z8OkytNhJtmpEwpbQ8VJQHvqQBWx+xPBOD/pXgozPH4ip0ILRP37AOr37+t6gVV53Uf+4oQg2Gld30FpSq7gsg3RcvUd07yloUbHm+tT2AiapdIt4wUrmjGNmQ0FJBEggBnmU7+Q4481cBeLNeehxUS3GLtmlpfF1TBI2eMFbTdsDT9AA1AJzm1Mf+eufJi4E33pvRYvNU45g8ldtCBZhyTOBbDY50T7GsarDDrevPTunzT4eRXwfpWIYTgQfmHA+m95s9NCIRScguiOwxBGscSI0UMIXoW/G4BVaCikEP+7J0KOvKGkbKWeosqSQF0MFdkpHz/2JsQL5p/lmlKtzHnjUiXujp9aq8yQYm2Y24shgvijyCb8Pf2+zVwZ87dnJPHFv5b99Kr6bFwrFH1a0vpvGVRM9VCrU+flSm44V06q7zzKfTQGn8Y2l9+RHCDudCAOVZuu/4zFds156f+YHna45+LOM7z8J+jqVk8d1uhbZ4/Mq8i8J8JrTjw8X/75OvDmGsQrZLTI9ylX/OmOh+csTP0N1NU6uTwAcpeGiwoMSJ3helIZrJmfh4pbQmlqIp8/EjF2Ub2sI03w+n/5CrMKB2EZlXpV/PiFhgnx5ZBKQH9I2JOwyiwh61kyP3OTSMKSNSgcPMaNvBlnGbs9WCNwcTTb/oCgR+EDK6aA9ey2Qe24zGXmfeKSqRF1522U3b1omQxM45KSmBS39vqlU2lG4qyIBfZkEkwypwCp/7hIzktoJ3wkSuGmBpVg0Sd6p8aou8U94Ns+W9QDniwUIlttLpZuptE4ynZiyTBVdrOoPOTMxxa06HSNZupwS7wxc8oyjfRWqaiM
 VUjEY8Qp
 Fp05N1d7FIfKL0Ii2Rg7/HsSicvEO0Tpr/ZdnIRcHZ5xnJmaAlCfFuTbq8D9ZKVBBiJUvu0Bo6zo8bYXc4V60NduZW/uOc4Qb2BQUWRt8D9suPbi33txMH0EtZ3tO+rUwwYD4D8OF9E8T5KfOftf64xAgoqCJgHLsIL87eiaWFP4gL7KY/yrHsO/yJ819a4o+MrGuTRELq4ZBqX+4YvdZx1BWyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [ Upstream commit 04f13d241b8b146b23038bffd907cb8278391d07 ]

These carry only the is_migrate_isolate_page() hunk of 04f13d241b8b ("mm:
replace free hugepage folios after migration"), which has no Cc: stable or
Fixes: tag upstream.

I need an ack from an mm maintainer (David or Andrew) on the reduced backport
before queueing it for 5.10, 5.15, 6.1, 6.6 and 6.12.

-- 
Thanks,
Sasha

