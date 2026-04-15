Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE6BF9D0FD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102D86B009D; Tue, 14 Apr 2026 21:21:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E5D6B009E; Tue, 14 Apr 2026 21:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF9DE6B009F; Tue, 14 Apr 2026 21:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C71D66B009E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72B7813A364
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:02 +0000 (UTC)
X-FDA: 84659036364.24.D500CB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CF5B0A0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ojB68Fzi;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776216060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Vq/I2zyRgT7cXYPOJUbUoi+kTDJ76oSHr6p7iv9q2M=;
	b=taQDyYYucVHE8K7sa83LBjnutO34iZJeWN0NiL9kFIMOMHG8+nh7vOR9tp4ZY1KJqXM945
	K+Pwb1DsRa8WvAUje4rjAwyRkfMm+oG8T2j3bHyANtwif/Yy+VekYDF2C2UVO1VsQim1M9
	EWFUivwef3wjcENV0Jo0RubC2QBiVZ4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ojB68Fzi;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776216060; a=rsa-sha256;
	cv=none;
	b=5JgHI/DkbXSAO1Mi1t9GszsSWpF0hwuPIrD4JnEXtU5m+M0l7WDULWrwwyY5yT/WPCf1yB
	6zeb0cnBZOqzrWTcN+ipbmsoqbXOOz4yEsWJ9AEev59CIamfFFZ+T6v5WuYELLqFkjaBAU
	OAnyY7Lysc0R8g7KuQ7OYTXjWpqhwU0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12CC74446B;
	Wed, 15 Apr 2026 01:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E061C19425;
	Wed, 15 Apr 2026 01:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776216058;
	bh=Da5/SEejhoG/cyXVJpn39CgULzBmR9p+dGF7QD34w0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojB68FziWg70XqRdPmUGGSPM9jWyeQ4u7trrbqB1Hu3t6tG1YQXVtcaenU4cBf6ra
	 zUzQW8zSjRdN0UxfF0dE4bXQD5A/pAhUKi1iX32c9xDlHQpfyYw5OIbdJOKTCHMTqS
	 Z7bAmSg0KDpdRi0lzWxYKehwY3a20/hfE9GAPuUwwpdvGOaX3/tF484sPWQYVAbfkC
	 1vx/1AYP16HMLhc9UnI7mK9m/DLOM3toZXrBHus3FPoNp/jjGZ1kkV3vSVE48t8gFU
	 qDx2S0zXE+oRHQ0+UPG0XZwmnWdPHLO4w3h9E45MQKJkt9MbnPpMnA49bHqcmrprBC
	 fXrHGfeALiHqw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/7] Docs/admin-guide/mm/damon/reclaim: update for entire memory monitoring
Date: Tue, 14 Apr 2026 18:20:34 -0700
Message-ID: <20260415012048.76508-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415012048.76508-1-sj@kernel.org>
References: <20260415012048.76508-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CF5B0A0008
X-Stat-Signature: g9tedex4u81kjud559m1pwbtb9z5ecb4
X-Rspamd-Server: rspam06
X-HE-Tag: 1776216060-262053
X-HE-Meta: U2FsdGVkX1/NBkFXeefbauc88ZB/hEGFqRwfNd2nU0E6RcltuEVhNDUvjzjcHxcQ11nI2mYKmrds+xMKdYwSpo3HsNuDllioH/FFLaJFYL6MxdOEol1hprP+fdrR+kwErEH540eBscS3X0vpFvFfZra62fDrdaWAiSlysMjx+IcBXqlwde/ZWb+ny3v6LHueEFXADmymrhFWTIQVV2R7UgXGadMQ7p3e6NNF4D3uJtuk9Y5z6ezCWQVyPLn7mfwh8D+EfXNDGmftP5eH6MlwlTXCh6/lMkmshikwp25lW3N33na6Us+A/28vUxM9OnwPszOhyTI48mptBvqqh6EqHnC/dJPcXQAH2Ph+ww2dUmPiPE9jcIjy2DOUYIlQn5a9FqVixbZbVvdwX29/7iLzf+jQbvFa2C7IpRqAJJBKHvhjx6CZaQoxfNBMVjyPUDDLcdcy45ZF2+cCoKN31bE5wAtM1SJzv6e57FFkpTWkOQKal9T48FWYgYEVnPPA9OOR92p9j0d0KLnhPynZImjcKfdN7wN9rn0WrmPMUdqJ/xagPxUzdUFqcSHh1yi+2Er8EZr6gWY/9w/2tfEFDr6Gj8Fi3BHPX96ljWzbXgUd57nLprK/l2mXNEvZaOI4LBISNyXpCMSfg97hwHWY9l6sZJ88szdPSWPuQjvBdr1B0MNQEq1wc6JvYxEnStVLovd5fNcS0FIxmQFKdmv0CXBPlA52WEfCuro1pk8J5B5kbHemCLPLRv7n5YKdJmwCWrE2dv1SoEqvKzIpvNDWbHQ5ymIO/isKidzEMp3tPDlQ2AJk0DHtX35ECX3virrR1JlEqv3PUuwUv4cJvylbfAibrF3VhbLavFGyzdVmGVEuL+EYlwojM0N01NvoR3/rFaEwdMlVx+iVeyrVu3CTqgoE7jYKk6U/NR5e8NZRimR84r/oZy1snpF1/wiTOB9rTOXqWfYySmq0T96yURzZO9z
 2vuDVDPq
 BkbbX6asKwFrSGE2sasg3aI2cvMDUb/jhCeJ4AOQD33BYpoaPhilVvN7GM+6VTkjq5P+jMe8vxyCfQW6fd+rdFlk7zEXNKooDkSnrFxMaNipyet4+TKlY7n7kwrCp5JsF+2e7UmmZE+Q0rsZzidwdP6ncAdUitPOPxs7F3wlUj+m4z5r0JHQ/gok7TuKunD5v5QjKtleS0Nk7eDKQCuuHDEF7v2zO835U5gv90SvNHGrmHZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_RECLAIM usage document for the changed default monitoring
target region selection.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index b14a065586271..ec7e3e32b4ac6 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -240,7 +240,8 @@ Start of target memory region in physical address.
 
 The start physical address of memory region that DAMON_RECLAIM will do work
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
-and reclaims.  By default, biggest System RAM is used as the region.
+and reclaims.  By default, the system's entire physical memory is used as the
+region.
 
 monitor_region_end
 ------------------
@@ -249,7 +250,8 @@ End of target memory region in physical address.
 
 The end physical address of memory region that DAMON_RECLAIM will do work
 against.  That is, DAMON_RECLAIM will find cold memory regions in this region
-and reclaims.  By default, biggest System RAM is used as the region.
+and reclaims.  By default, the system's entire physical memory is used as the
+region.
 
 addr_unit
 ---------
-- 
2.47.3

