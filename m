Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1E1C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD106B00AA; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092726B00AB; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10AE6B00AD; Sun, 28 Jun 2026 18:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C37296B00AB
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49E481A04DB
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:31 +0000 (UTC)
X-FDA: 84930693582.10.744C7A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id ADB72100015
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xtd7ye5t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684089;
	b=KSPdZuVhz+E4WKS/VBd765xwz3uqwVgfQ98s0gG3tuDo3pAb37kv0ERSbyKkYaT8q5lpgs
	RJ/jveaSJL6yGRhWGx0Z9HC8Frj7JExzWWxn1DezxH0N2Fcj7/5soR++wcln06J/lBbpd1
	t/AR7ATKVnRDV9ym+sepu7fGCM6Gxk8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzlkmUHMQwNBfI6ZKWoROTeHoWiHWufYiXMy5/ROBog=;
	b=69Y+jH8lopGYx0WS74dzYxtiwEYQ0RCyccbuOiduia2SB7WoOZd4rlX3YK/6+6Z0S/efEN
	u3UryWOWaDjt66qXxcQxM166XIyxhJVhzXmQBBzKDzDLZqhPFQkKps0kiKhoMFsTgDnhU5
	S/XEafGYup5/5lIrIt8+3cQ6w7aO0X8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xtd7ye5t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F064600C8;
	Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38951F00A3D;
	Sun, 28 Jun 2026 22:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684089;
	bh=BzlkmUHMQwNBfI6ZKWoROTeHoWiHWufYiXMy5/ROBog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xtd7ye5t+0FJuF8nAHV0jfglnIAAZe51NQssklYhDhr4+34TWV2UFAJZiK6snzcAH
	 cS9ahdNG10h+9ei/uWYwhu5zBR8o7QKK/IQ8OtN+se4sCTv7xWZzoFl5/DzON9uUJ5
	 rWShMykibSbHJjS4gmcyoXsYbz1lzYEWKakZxgiL2Sj3xcbWU8isJymzL9PLntGaCZ
	 /UqAPS0RsY1zy0JmOv7h+1bjp0fyv2dpTue8h8xPuhzm+GeClMcHhmeaJWM+tdUNUq
	 0iwT/xCT5SOR8XLCWm/l5gMRLihS/23UYLKaB5FGScl5Ar4dfXd6MwGu1/3hoJdWpD
	 1Y8aYdsyBF6pw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/11] mm/damon/sysfs: kobject_del() probe dirs
Date: Sun, 28 Jun 2026 15:01:17 -0700
Message-ID: <20260628220121.97360-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ADB72100015
X-Rspam-User: 
X-Stat-Signature: y8iez9wf3kg551ogpn9tsoyqjkorbywa
X-HE-Tag: 1782684089-506562
X-HE-Meta: U2FsdGVkX193U8bYjJm2wcBzQTubwSk8lTMKDLhDi5SyJZ7V4Obut6zkSjTTT6dmVbcoBVZdKKcnLR7kMu2iqtwMa6ZOtrHaeaU5A0lIPffgf4Ex8++Bi/lShKQJxxFc9Se6/Rzq/2QD1f8p+9yEnhj6hcOcvb/2KvjEHu32yIlPrQ695VjHajRJOYV/9XJgQyaESrErSaD62sxCO2/p0rMGZuu/WeFbAJm9bKVedZgQZfmXWWeoayENrjtVPeOsAUErBmTkoIdEFsKlkPuFcqksBjwrIRqVXNSYKnKfuAij66lLJylyewMjTM/o1M+JsCrQi7S0yVaek1VeXbuR71EDcbwrXZ51h0aLWQcy3Ef0aOiDKzX5ZXIsrnJ3Qrl09feqa6TVxv2J7aQ4Yk73s9E3kH3GDNTjY6ZVAVvQdXCMpaHKRAIkRL5PMKtTLKOeMjvbDQib5NeMjLilyx584r3bIwfxGGeLYGnZvldrMBpPoVsNr3BUPklSnmS+TWaNdB2EIaQEbO9jcleGgb7FH8+yQryBWAnGL19YL6SIndKlHjiepUJpdr8o97bdg9Ou9DauDEPlK3x2cCv3x06nPKQA8KUrMeSL5p4jRODz2Gew6XE0vGfj624tH3+O4DQKJIIDJDdXinHx7o1rZFKFXbJB3t/OLzh8HptKGGSPOjGyijSCbcGPfx/cExdtXKGIOr7AIgWyElWYWeIlh9sAGPPrWvt8T8o3LI5lP8z+ovTddVy7PQVgrMUryXcGb2i8DZnP87Dsg7Mui74WImcsofGqM6iNXs4sgoTm+WRYAxgMiSDWksTepYbiKR3FmGs/NHSIP3j61MoMu2k1TWIj0tOVZMnwmtJcj/a/V5Qaup0Kj9Ki9+zQfe2UcPPaVNRq9s9RjgKm65cYMOoJHUKTOy6HxYMw7O9jlhy5jQRWZw4f0IIPabmLJGzRy4f8QZFvXzGaKYPXlTL2rmzqne0
 959xaKW9
 kAOQE1Y59rxkEk9da56dELiJwtl+7PXj3sc2iAsaTtjcX/yan+1p7KG1d3NdDtN5FvL4IwWmhQ9SvRDKEXsGqUi7BQqQeV5vxzDXT8JRlbUycYjaB7rJTilEsMzbv8dM8Me90RykMoFKbTP/SI1ge8jVXDoDyK2egAnCzKgGpvu52vHjK1NaNRmz9lPTgJmPQutXL+j/la0BoOtPbvHnsyniW7ovlDQrmqJHe0n4y4JIIrjnTgHdOSP+JsBkzKDIwMxXtD6prpETe2pA8bsQ0hOioRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for data attribute probe directories by adding
kobject_del() calls.

Fixes: bf3ea3d30880 ("mm/damon/sysfs: implement probe dir")
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 204aed6a3e5da..9f92ebdb28574 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1137,6 +1137,7 @@ static void damon_sysfs_probes_rm_dirs(
 
 	for (i = 0; i < probes->nr; i++) {
 		damon_sysfs_probe_rm_dirs(probes_arr[i]);
+		kobject_del(&probes_arr[i]->kobj);
 		kobject_put(&probes_arr[i]->kobj);
 	}
 	probes->nr = 0;
-- 
2.47.3

