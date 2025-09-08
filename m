Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16065CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57AF98E0005; Mon,  8 Sep 2025 16:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C168E0001; Mon,  8 Sep 2025 16:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469458E0005; Mon,  8 Sep 2025 16:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3245B8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:15:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8B6BB637C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:15:24 +0000 (UTC)
X-FDA: 83867187768.07.D3C92E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 614AD40004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:15:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QSLrMLEQ;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757362523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6r5u9+D5ZY+WvjiiiGXPcQ7HNSmkLNd1rc++D0yjH0E=;
	b=vgGMlAIKMTPBI1HBonNOBPNWA33l7AxTdbVCeGrkl037+MTENFnbWybp8eYMOvSOzmLVIk
	OvT0RYYhN3d1Z8h6mo5bSz2U/pWk1+HNFpTpVv63gR6zITrkx03vVYhzx5v2Oi+sjmkiRN
	ETP6v0EsJcsTDGnmfkLgsmTwT6ntUZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757362523; a=rsa-sha256;
	cv=none;
	b=b4+TzdCmhZcYsNiyObvAc5C/VhrKaQ0QmzSxUoXMZQkCDI4iHa7K3B/TPGulOvoEC/3Mnc
	2H5fbRfokLXzNDlzBqAkY+APVx67ff2fcYN1o2BTmGVR4fHIxaOCSxlUGpm0Ro5tLawPRg
	HVsAuzR3XOm2zULL0xSAm7OIoeVGH50=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QSLrMLEQ;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A69FC60051;
	Mon,  8 Sep 2025 20:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37191C4CEF1;
	Mon,  8 Sep 2025 20:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757362522;
	bh=PsGl1+WwcckdRHMNuQl2e0MNEvzJOQisrq1GlKGfaCU=;
	h=From:To:Cc:Subject:Date:From;
	b=QSLrMLEQ+Sff9ZhkGd2/EQvdi4s6SFcpSXumSej2vOAWR4wGofHWXVfKjPWm0DWkj
	 Y47b/kaJFKDsF2ckhjPrk7E7wSB0cEji1HsZnochJqgUgC2umdAPfq4rEOmQ/OZ1dL
	 RswLUl+4sUjnEpGVcKW4OSdGQgOwe2F170vR1t4LXzXXW99NnLhY+3hzL2mDP+AIWJ
	 gk4pi+38Cz0IUNoxVlwqGJZvm+0g+/xA28+Otx9BB1TdqIs/iMC9yf/iUsciInh803
	 jqfFeTn46g1xAs+1MQruh7x37TZqu3N903t2XoT8IxSCRK43A2Yrdf5S5GQ47C8iTm
	 EDCJ8POwRf/lQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/sysfs: fix refresh_ms control overwriting on multi-kdamonds usages
Date: Mon,  8 Sep 2025 13:15:11 -0700
Message-Id: <20250908201513.60802-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 614AD40004
X-Stat-Signature: cwkzmqmrpyi68zndeixbtdysjcwgcjm9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757362523-204128
X-HE-Meta: U2FsdGVkX19h7yKuAcaDJjVb2qg++ChJpnDdQxmKzYZXUtDwpoX7Cn6sM0TqUhtLZ6kEgZFLMkK5ycoNKTzCCw/jAu+3mUOa0YE/n4epEJfdJc22ajuqPDP1O2t1bLCrr3OcWyuLDDpYhuVPA1/mGOoDtARCTCsaGoRkbfBvuuICQOySlQFqJ7br2+5uF/DE4a910Gh2YYuBiY+HT9mTUVY/k+My31409yntHZZQvA8adwWci9POsGFSmHhJ/Q6lHhZVjyVYA/GVGNrn4grArXhHz5izP/UPfAkynTXJbzOg28G1dTWgqVzNlpoZfrBBua8Z+k1GGhj70eWZihWhr92Ja4q4VMGBZzCpaIANP8LyO6HSnxJzpLBEunN3n5/hK72qBkZWUSb2lgxuXNlqzQMfxmjFb3rUxFCrvh+W6V4ocnh/JLrhuYb5JWeWt9fKurjZn5hm+/i/CeXjvkSa8mVQheVdbkFt10PlUL1TkEibQg0r2DivuTP9Q8S8+dKbAGGPfo6092sW9kfFamdhd/sFf3Bnh8eV08guiSgKlhWYfxjPscPnMUiSUpmuz3W5pyR2m0rqWjdnvuoQvvlRfzM5tUkA66OXqATQPperUGxGW00mwfGOxSJXsJ1Fj76Zn8WBFau9Viy9hFCzCZ9OcoSu0mxHm71PRUOkYJ1KguIVQVfHxBky8f4FIZz4rJ6HOao8sVvBeME6YdTdnunHA+LXI4JQAoawIpj5U2j6Ew9sjv2Kb31HKviY5q5XauhmQqfGuNOZyvL9IilXX2H9BZo+J0oZLvICxLWP0RnrNojWqirUF/SSx/LktXGl5upcOadfHhtQ9GwCbKLmh9jCgYwDsvdfGqgmOunkZO8PuaL7b2zJ/zN+2hL60dXDfp8H7MY20SbxadkfFABpE6aCG0Bk0MTM6EEbEGncJ0MLcvW74yaXdNu5feTA5vbEzMcg5uFslKIbvdvrrAHqQyc
 bYghcLgx
 c2pzqLBTZlbvrvPBin6/s72ydhdvyjHM+CrDXq11siGmybb+irK7e7ynVPhZSn8qNKeWzEphnGOjTwKYknymNhdi8CG07WRN4glD5kH5wtzfCo/MFfrmpqoN2szBSQPN9yh80o9RsA7Mf6bmkW/XU+gCN7YRLxfFEH0b+Parny0oJIZfPPI22nfUSxppfKoq1itUx7Y4LaMPMTurYdtPVT41AgvzCCGtp4AOvXTUVgfVQKffWW3s8/h4ESKCXbY/f4OhRo7rK619czvs02GAPJmpnSMNsZCI/IyK+kT/VPq8XTcs3oi8RyKV359Zr42OFW+EVrCP6kJfXW2E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Automatic esssential DAMON/DAMOS status update feature of DAMON sysfs
interface (refresh_ms) is broken [1] for multiple DAMON contexts
(kdamonds) use case, since it uses a global single damon_call_control
object for all created DAMON contexts.  The fields of the object,
particularly the list field is over-written for the contexts and it
makes unexpected results including user-space hangup and kernel crashes
[2].  Fix it by extending damon_call_control for the use case and
updating the usage on DAMON sysfs interface to use per-context
dynamically allocated damon_call_control object.

[1] https://lore.kernel.org/20250904011738.930-1-yunjeong.mun@sk.com
[2] https://lore.kernel.org/20250905035411.39501-1-sj@kernel.org

SeongJae Park (2):
  mm/damon/core: introduce damon_call_control->dealloc_on_cancel
  mm/damon/sysfs: use dynamically allocated repeat mode
    damon_call_control

 include/linux/damon.h |  2 ++
 mm/damon/core.c       |  8 ++++++--
 mm/damon/sysfs.c      | 23 +++++++++++++++--------
 3 files changed, 23 insertions(+), 10 deletions(-)


base-commit: c6680f5947fa5ff95bc881f2c4e36443478c8829
-- 
2.39.5

