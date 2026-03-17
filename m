Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8EFFFEDA14
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4727F6B00A2; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A7336B00A7; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8E96B00A8; Tue, 17 Mar 2026 15:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6FAD6B00A3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:11:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83855A5427
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:50 +0000 (UTC)
X-FDA: 84556499580.12.B7D92B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89DB31C0008
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:11:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBfbUwkn;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774708;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yjU9G0QYab+LCB7YNQRf2XoZPiy9g1iTZ4wdAz2/bw=;
	b=nWvRFiIYmV0GFJQPNAH+aPUTLlGZM6IpnSBPwPUcDv5LFB+C0Y6q4LiRxHmitLuW438ocj
	b3m9GuHcunLaBxcoUQazlotND2hwmVCIwUl2pddm9lgUVdJBJZmFjLKVawYCiAkHZBIS0v
	EDJBO3+i6Vn4mOi64aIikUcGMRubWMg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBfbUwkn;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774708; a=rsa-sha256;
	cv=none;
	b=Kh38r2eigw28VzN0M3/KF0AMs4Z0eE1KiJ0x3+vPX17ypqwvq8GJdofwdVWhYI1VD3XF3p
	1jG2D6RMtQDwnU5m+CEGYZNk0FJZkLGWjnqVNZvvHaUkeMsAguqAn/A19EK5aRi6HT++pT
	eOakUacey0+oKDAkNqfl0MYci6fPB0Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34821443FD;
	Tue, 17 Mar 2026 19:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA01FC2BCB8;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773774706;
	bh=6I1+6vrVieFNvUiP+TJuhWEsMy3QD5/7Cm7KDDyN1YY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dBfbUwknzmkckPZFviQuzYRJZOq8JaznvJ5EufhMR8+v2jfiNq1RreBYulAgDJMG6
	 2WGlcvfe5lK95OONzAm/odo45LjDHAv+PL2uiyJsBp+TXRvR76SV8btr+pn6KxpYP/
	 PUIfs9dPEuvcALysf0bbAPwpWYrjyBuN2wN5AgH0OHuAR4OFM9XoyxBDRAyDQ2s31c
	 JYbM+55c9P92rNWMCQAAug3Pc+oDJ/wvIODYi3hbMdp+tKv7px3c5xENJNxIF1ysmV
	 usZZqoTJdqrqFBIWa3ArxHjqAez4eCqyJFRBa1szBc5zI7E5CetUbNWkSXC4U6cWKO
	 yl8Yr+y/Qz8wA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B01C0FEDA16;
	Tue, 17 Mar 2026 19:11:46 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 18 Mar 2026 03:09:01 +0800
Subject: [PATCH 5/8] mm/mglru: use a smaller batch for reclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260318-mglru-reclaim-v1-5-2c46f9eb0508@tencent.com>
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
In-Reply-To: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773774704; l=825;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=WP4y9XHEWiYUb4a2CJWiS80eKSpma8CkjsOc7bozYm0=;
 b=g31dIkTIDAoe+MBcN4ZK5LGx2nUUlTr1S9ZIEF3qT1RdprPhYqv5TpzL2bTnSn2S22d/15tG8
 vcDdYbsDHYuD00RXl3abh+rRm7IHz5euwoqKW53MVDa4YC3BLrm/HqQ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 89DB31C0008
X-Stat-Signature: 6ys65eyt6e7q5i38zjjmjz8zgerw7pdo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773774708-247180
X-HE-Meta: U2FsdGVkX18/3nwL1nKeCwaVr+Tfe19m0vxIWcDKvR4LmmGIhrC9n2+k30+89LVZChUsE7ObNBg1ycMkUFRikAHPuPGzmwkjVxLT9B3GFMyNLPpBOZAMb4Y7UtOc3WRiS4J1MnZlcIi0DmOrg5E+jhgkIEKjifLkPY2sKGm99dH9rEyyaea+u3ZVLKq0jQHX1B9kA95zdt2Q+zvQKXXkvoNdDf3Da/pg3S5s1gJ6DjGFlATrLw54VOs+HUPrXfCvC041imTuS7SCRCI/of1W1MH636wtWywtKuHkCSZ44bmpU7k2stnrqjb08uRv6CFURS0fq6P+p7Ec8I/joZ76tHwhx3/RlooW4Hm++HM1A2vjmY7TVYHO4lxWg1uO1blCFNHdQsew3N0G+TSxnDJdIMfnMJAhvb6YwdOFhUT8zmJWQmvkLVBqOAzXdxHkwfRZDC3kmqHvhnsQN9bTXmitcIadpOdrR2JrRjm6IXHlhZPaCoduQP/g5jMLIiwdG5xoyIR3euROrO1QexRlq+l8zkha3YT3+VdpkpoO1YyluexEMSd8uIOgDPRWYQl++6Ayg2gUCO21DxcmlTjNuKc+DyDGmmt/TD0/uy8aONQcbBI40x8D85SwjP44BdQvK1uK8qUE77bnQE9+Wpx2U1xvskmxR3fTbCWJYxk0tFx4jcPyR8+kt5UtEF+XYDJgs6UIf+iaganbt6JQ78i25T55gwkJFRxd8CGk7SvGgtPvX738w0e+8vpcaTOgg3cqKvTsQClJ2yW4kMw5OoEVx5QTotIWX3CDSja+yfVpw+5q8qUK4BdBtBtGE8GjzaNKhzkg0jHstFAuwt4VXw+bju61YWmTwkX6OsU7r+M/Cgf4mK94bbr7X8H0Q0g70lpauFC5K1WMvKylZwZqY9fTrOW/czZMMDABJEkTuyQBDMZlrmF9ItZ8OCo30ZzUIBZ0lur5qoU0zmgJ+j9BtYABBhm
 6m9X3opT
 aYbSAfjGzgPiWk+U9yErzg3h1bkvC9YPPBA2h7TTLHDnWpz52uSibSQbcjfAVXK8aVyee2fzx8b9hbWXzSGYd+0D1BGfpIVPPAyhPUZO5poeoHrsy6FXvHFibxt2crfhm97swGE8oym3CkFcFM96aL/oKsEGhr0NkstEbjG3RSNsFwmnGQiv/+uQbadGm4zBN9isc/Nc7BH614gq44M2SUEyvz35bpSZIwEQLZO0QQ+9eEIKdAKXZ7GkHehkV6s8PQUOU0d++1Sa1UGQxCCFYIQZUVIP2uWJJQ3yleShaGm4K44qkTcVrsLhHxOa50w7+an3CmKtVxYFCrqoPRVP71zhll2bAMbMgVtRdeVNPg9fP4WKz6jPKtUigGthINVLhD0oJ79ql9cZsGAtiiQvKQ4Z7YbTPAmgMblVmZUf4pAM0DfatMMRLnnq/Yl8Ywhx7igL35LxA+fygquFUGD+c96y8i0mVbcbyMuup1iq4a9R8Vomha++w6Ajhwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

With a fixed number to reclaim calculated at the beginning, making each
following step smaller should reduce the lock contention and avoid
over-aggressive reclaim of folios, as it will abort earlier when the
number of folios to be reclaimed is reached.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4f4548ff3a17..2ff1609ff4de 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5007,7 +5007,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;

-- 
2.53.0



