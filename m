Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E2D3C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1E66B00A5; Sun, 28 Jun 2026 18:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A776B00A8; Sun, 28 Jun 2026 18:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26216B00A9; Sun, 28 Jun 2026 18:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B44266B00A5
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FB988E3B4
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:30 +0000 (UTC)
X-FDA: 84930693540.26.FED85C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8625C000A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nLw7S9YL;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684088;
	b=RxK+iTRS1KjMk54mxZ9080wMFQXmP8uLAfWULrIjRrpaUeVs3A3GjWK4kBkoG3Fi+IQhQn
	mnZeoqJInQ1PaPByryhjQnPb8eGs3Jy2IGEYxgi2OpnMmjVG6zJ63WoOAHi1O4GPaFfbO9
	1k4S29PZYcqNhRY28tdbi1S3Z6j8YRo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKghVa2ofXRswbu+yKIaGI5IAC3ZZZ0ZVkr8KecMvtU=;
	b=hwyLKFXBy2dDSyojgswAi/TNo+Qkcy8N3d+t8RtBXswxspqRlAThMspyTRYVDSy3W++/jy
	cbZwG88j6x6d5y9kZ+2HGV4kPOnJucwx8sFpp/2SmSu9gw/oEiqfLQnqYUh0XXc88SOF/P
	0i/pqzMgpcFlD+gRyon0hxqZp8uePxE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nLw7S9YL;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4117D600E2;
	Sun, 28 Jun 2026 22:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1151F00A3A;
	Sun, 28 Jun 2026 22:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684088;
	bh=tKghVa2ofXRswbu+yKIaGI5IAC3ZZZ0ZVkr8KecMvtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nLw7S9YLdVPzCHa/o6oMlgOG/nKsWrF0bRwlfayUlHOz9q2XfcoCN9+rxTNg0/Mjd
	 B69Sur9C/lpiJE3UNdB26sgCsi7W5t3RtwN+iSrm5PEe9Xz9wdS5X3Ybb8ByIPZ/AC
	 Vn80skOrO+z5R0zz+TiowPcgtFMGOPvq/Z/bs5gRVIjXVnHUG0PyOVlAPZ2jFh7mdA
	 Uoz3RPFWPAi32LmB13bZtXbcixyG66Icwi2oHY42KSJwxa1RafxgdeB0hUqLrPRU3o
	 HfgvK0itTgjl8eUAO26BdIAfdN3r1COini0zrdAyjfLmN2OEHs/7Dn3Ila4jGypEfR
	 z0lOCVfxoLB+w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 8 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/11] mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
Date: Sun, 28 Jun 2026 15:01:15 -0700
Message-ID: <20260628220121.97360-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A8625C000A
X-Stat-Signature: rt88ixsanmrr77krx4byc4rtdmnz6wnx
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782684088-303978
X-HE-Meta: U2FsdGVkX1/h6H9d5ZjtX/DmpIcjOkZLhx5+jNlTXoNSIFkdfFyetjTZ6mn2qi3cELJHY4nM8tdEsxgPTsN4pG1bt6Hc0ojGtO4NuyIjU7IgHi+JkPTj04BCtCSRbk45PjEUgDPHnsiPU0pgDIBRbPT+BjBrGqJ/ejYyUBGY61bxdWwYQJ1/q2fOieR9gnaz5WvNOROMODCnkPJIz0ondMS1DNQgiG7FzEpo+KrmQ5s/nG/MXHt3XU1r6IxJMhwrLBn0b5GxpX9NmS9H6QBsmNiWQN2pYM1FE9fBFPBuB5kzGn5eAtTDf9P/8rT4gFduxXpYWNGGwVs+4DAvD2s9CUDUQBbw1cA6N+UEFZipiPEbGQupyHFvn9/Iz9tVc/h7GDqRZwguQqqI+kF0/RGA8UNyAFpWOUt7r33bka61CNH0RYtu7tH036R1++KQKnibOSRkZm8nhhlqDiVzRVb8FL1HgnUg2IVfM+zoGYDDKlhVrasCoxEy6Ok1gCNFqEA1e4jhnEZzqFUH8ZydVrctzv1ymC/CNfOjuy86yK789C1v9nCBkwv2h8Sp78wXnhQt4c6IFK7KxP72NsJeJ7T7Cq/j4MEisy5tpmq8ltj3GYw+QVesSeYwPVKd0k6wAFYXNcFYgtB/ccNkJz172V65VksLj+v9WeEtpFVhFcNibKthcPl3K89W4Vt63svzJVfhQrWuoBWpePWjKheY8P08n7phmeOxRkfwIbpj3i9PiwTuowjyFgtHTLW3PpNOG2ziTkn47qioXyCibITBDQMGlqM2gFB6Btk+Y5TOZ7s0IhS/PDkbBV7LRi1nR0BvQ5iRYFUDDKnaNa2k/LX4syM6rQ12NTOqIbQ/l7Fao0jM+VC1lx2gccZUVIKzzhR4cfWBpUVdM1Zx6wa1Q11+Wzr1J8Srjdj/4DNR1i03fJapc+x68V+42VoQIZFFjNnKDt6/tbcGMIpMa1lc6GXnkeR
 cnuFeGM5
 wszkYdQ80NsBr6c7ZJ5irl4vCkQGv/T3kby0XmOSWQfdK4/BW9aJKRYexzbPpbdwMVIxpa2PyG02BVivNLnIbkcyqfEIIWyN8om4S3UQ6rlRGyYL0013AxEsGoSsfH9dic1De7uNrCsp5y4Jp90kp1PEZ2DdWYN4ZfxxrAjmFl+ABIEh/ebcHCFq3DT5kihbBmekIN0HQfZ+rd0IK+HEkWUEL7j4FXZvSNF9ySKvGC9B9TWDN4C3hbLAKzfFcUwMjo5anzDkFEqeeDpsNcePLwcEr+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme quota goal directories by adding kobject_del()
calls.

Fixes: 7f262da0a30d ("mm/damon/sysfs-schemes: implement files for scheme quota goals setup")
Cc: <stable@vger.kernel.org> # 6.8.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index e955fb916a7e2..58051185713cf 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1463,8 +1463,10 @@ static void damos_sysfs_quota_goals_rm_dirs(
 	struct damos_sysfs_quota_goal **goals_arr = goals->goals_arr;
 	int i;
 
-	for (i = 0; i < goals->nr; i++)
+	for (i = 0; i < goals->nr; i++) {
+		kobject_del(&goals_arr[i]->kobj);
 		kobject_put(&goals_arr[i]->kobj);
+	}
 	goals->nr = 0;
 	kfree(goals_arr);
 	goals->goals_arr = NULL;
-- 
2.47.3

