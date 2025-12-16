Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4CED5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E27E6B00A1; Tue, 16 Dec 2025 03:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997F46B00A3; Tue, 16 Dec 2025 03:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFEA6B00A4; Tue, 16 Dec 2025 03:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7608C6B00A1
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AE308952B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:56 +0000 (UTC)
X-FDA: 84224590632.19.7EF78F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 96FDEA0009
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WpL35w/Q";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872114; a=rsa-sha256;
	cv=none;
	b=KYPjXBZ7MShYaqkEmLqi8Sl+0NDTp1oiZGl6rXw8hj8oZe1zAwaz0KjwwnPwnLQK02BO0w
	p/CPDzd8fhII1GiOnYHaR3kXa9dh1AHKmiA+Y4c98h7Ijw9EQTYQIIhdwaGyJscrtQhY+i
	aAU9N6Y4Gv0Igh2JqfgzOXasZWH0Vp8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WpL35w/Q";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/pBh15MVvJ53SnhY35kazX8Y4DxLhwZP9KOa9nKXIo=;
	b=W3KkuLfsUwO4bbuadj7/pMp8ujURZSyju4EgJvfiBry2VCWGtpExjRsOYY05RpRZ3pzaUB
	Jg1mAeAJbTLIiR9ksTgH3GXaj0yasiIiN60Gn3J1fnpJ4f9ST0OVRfsg73cYolJGdpBQ4S
	Om1J7tHslCj27T3zE4XAKPUsj9HBVwg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BECCB43F80;
	Tue, 16 Dec 2025 08:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ECCC19423;
	Tue, 16 Dec 2025 08:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872113;
	bh=dyfJoVaMw2se3otvFoArpX9pnB7yY+god8b9Qd1MKC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpL35w/Q+dEm4/26EIsm2RWsTVlntA3hjNzSTCFpkAhWTkLvdizet+5IJnAPoEBg1
	 wKx2iw0YDROKUTEfRk8YYMthRAMrADKxAgyG1d/0DgmApnbj7bf02yjQRkGf0FsGg6
	 qO6hG4aZ0xyiLekKrM5TzL2tDywpgMo/V/QLvxzOqhM2Gf2E6xgTSmquMVUByCN6iZ
	 suyhysPUCq8RaXKTICW4qAt8LKshVhDseeXzwFGbVdB8BJ3yGtq2J3deVZTKzllZ1C
	 9Qf0HigxOK430zaYZuqV33SYk/L5P9xJgR5te+DBzhoZ70mvGOFwjQ9Su1Y0chNY7W
	 vyWxdn7z5Y5eQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/12] mm/damon: update damos kerneldoc for stat field
Date: Tue, 16 Dec 2025 00:01:19 -0800
Message-ID: <20251216080128.42991-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 96FDEA0009
X-Rspamd-Server: rspam04
X-Stat-Signature: r4p1g1djro8am1yhonpwe1chf5sxzabg
X-HE-Tag: 1765872114-903290
X-HE-Meta: U2FsdGVkX184fGxypkFLsNfkz41E2HoEt08jCRmj0dsOK6RcbM45165Y4ElzfOkYDjrHrOQG5WHTgN45aZDIZTiArDUeMo9a2lFfga64X4S8d7geFMQCcrS+DfCVeEpc3EJMsX1gKy4L2lEILXK7Aq88SrDcOv4DqGVxoaRM9bQyZ764jTW9WDM8/H0+eIstuh3+VtQmcYbY8hjv5GfdV1c6N5GAMWHZkf+y3Tpdh1fc3jmi9DxLH9j/Vam9fEalQGw8LVharfS19RqDm9atAV8OaVIalUzKF/F6Krmad4h/re+px5Xkie00K5xYkOBsbn0pL0i5eIQBvKfKPsJIKLwB64G7Q6FwxfKOxBxC4LfDrAY40iFyE/xEiaLQtvUfuFshmcn9hu1NKUXiPR++K1aNlmLsKwzjvzONnovSfhi5Sgil5YuawBrO4h82dappShem8e5OhfXHkkEPX97xsRyR889VhHTHBVgar7YG6r3wuzXw94KjEuehpRhhgc9gZyaWaJ3SV0tubt5dAhXNfMJr9ESoC6mc1w4K9etmR7VFFeOifPIfouk30TId3lbaMYbz2n91oT8+n4qakdFs04f0XwsimBgfjygOEKjm1ceNFpIhOY9UDjTWIbgdnIwwJBfQeYV1m3q6Oz+GvzMqvQP+uEubm6xwhoQQA8C/Y3YkOS5AAg5me38FE5KYnOPXmdW7ln4ovlUBLK0S+mp6W2815bFnT+3+x9N5ntZXmO47rKir443J2qL7Gnd6uvCI3P3zJV+eDEa6cXAROeMv66kTyPeRbcBO5wlx3QQ4xAQ7NZMDkFYt4SSqED5xQFyWE7xmLOONz3jMrdfACyOBsfMDMQ9Fy8Uzrt+XxvG21iVadKfUF2ik4zC166jKW+KGar2HIoEZ2SpGomUEtcDnlGa61IIaPGvuSBc6uVEQviRYz8/l9jOkbFORMpnEkdjhSBd95bH0b9YiAcpHDT6
 AT40qXnk
 fh7z2SwqT5QMFE1ZjWBRfr+uJW1EvmLKwgbvT0bxoGT9M2JPzpnnoGz6lCrekh/rSEMNiDDV7bxMW21ghmxPeTP+EUGm9BwbgaZipNj9TL4lgK4ElB1qetXezVuM8omun6aa86vh0+3wH4Ndo0jmXQFGkCw3q657U/G1p+tbGWSsgdmBisUkXe0itwGqrx0x2nGXM9/Sgq8Xwv89kbHMXylTd3kUDpx4L7s8LI0fjkkoKPQk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0e92c2ee9f45 ("mm/damon/schemes: account scheme actions that
successfully applied") has replaced ->stat_count and ->stat_sz of
'struct damos' with ->stat.  The commit mistakenly did not update the
related kernel doc comment, though.  Update the comment.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1d8a1515e75a..43dfbfe2292f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -532,9 +532,7 @@ struct damos_migrate_dests {
  * unsets @last_applied when each regions walking for applying the scheme is
  * finished.
  *
- * After applying the &action to each region, &stat_count and &stat_sz is
- * updated to reflect the number of regions and total size of regions that the
- * &action is applied.
+ * After applying the &action to each region, &stat is updated.
  */
 struct damos {
 	struct damos_access_pattern pattern;
-- 
2.47.3

