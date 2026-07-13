Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ADB9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602F46B011B; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B42B6B011D; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453C46B011B; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 238066B00EC
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:26:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A38961C0038
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:57 +0000 (UTC)
X-FDA: 84984433674.01.64FB76B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B2C2D1C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u3e1SH0h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963615;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9glXzm8ERIX6U5Yg/nVagz5A3GtccxvFxTu1uttHaI=;
	b=rzezGqoKR2f+zUXIffdf0ArqRcpEPvASgqoK1Oi06xzMHTD1kb4HjYwUTJ3d/hNeBVrFfW
	fsUzJonC80jsz78yzk3o8XIGCSojEPrxNG6lYgiSyjx6f6jRliiZDyMxikB9uU6AkL//ab
	kio9hJUFLbwjKiQrqnCtpIWMCswb7X4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u3e1SH0h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963615;
	b=KA4L8paOco2Y2pqtnw7UN5DJSgMAZoPtDiyrtf7FytdoaHz8nVLgYdIV/WZEAL2iUhpTlW
	IQOWkDpWEggdmkK5lBds0DsQNK11UDdOnLlmAiPsHH5x48EX8dxjXTtCiYu93AqmWNiuVN
	igmz5NCTs4A4GxK2dDXW7CvOWTbsO0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B0CA60103;
	Mon, 13 Jul 2026 17:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6C77C2BCC7;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783963614;
	bh=YexIlLH/xRiAaDy9nQacZ186o1VJKSRYwoHVeIPJ4Ns=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=u3e1SH0hqe/5kl0XulTnJH9WZ3RvKGZNn0WpqzWpAhJrM8RDHshEdhvV7R1JKhnIx
	 BpxN4H51r7QjcuutergmLfB/mLmz3Kvp1dDfNridAs2kv8WZ5EOKGzIXymhgqlOhAR
	 rB2SN3u3D3zjv8mJ/WK9aG7UnKa3jMvoEvEShstJupBCXV3dwxdC7aRY2ZLKArIh59
	 oMApZ5mYkaYwpNGwj8AVwDkC66CDIqO5o3iPbPhFAuC1V9Wbv9U/HaPepKAz4UMzkq
	 DyAXBBUga1ijHz1arEFZfDPE+MTFupfEsg46R1aJLcjU8pBWFTuE43iLVXhNjyXTB6
	 GGEmNhI7TEhdw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96743C44507;
	Mon, 13 Jul 2026 17:26:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 14 Jul 2026 01:25:39 +0800
Subject: [PATCH RFC 01/13] mm/swap: remove unused parameter for reading
 swap header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-swap-pcp-priq-v1-1-de9b164ed419@tencent.com>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
In-Reply-To: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783963612; l=1063;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=XGt445t9iTFErCSJfFQu9ZkczDPJlNnc2UbKTqyWoyw=;
 b=I6cvsoytYxfN/+g7A51gAi/oEuel7bBFBZKk7mBWokMWtK3MDyq3dZwzoZvdNMdR2CszDgzzx
 O7p41Lhx6OWDhpDASgLP489tK1HfPfBsf46BX1pG56SPdIa2UOxHwl/
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: B2C2D1C0002
X-Stat-Signature: tqttuy8iqoudz4m83xwk76yq94rmiatp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783963615-921684
X-HE-Meta: U2FsdGVkX1+YO+8IJ5j1+qdKAlsuFGgnaji6gkoHLfTX1PNzueSL6bc51KVc4EfLYQAQg+4bpBZz6X7XJE3GRBroovwBXHZfHxdS0bw2t+W9oM51PbLNyqMtdAYLuYILR/yffuXR2SWwAYqGVv/Jjv0/y7f9kLSDyCRIyUnbOlpxizD7m/wVMRb8dYMzxtoYP81s8dEoh8/LS4jjV/Zqn9Fd80Ef1E7McjV5Rl9Vff/VyMzQet8EYuujlk8zr8ojNTC3q8V4FtuhYOlrEYIkumT4ySNTWBsbRaPezcZmRc3uusWy7/lfW7/AJXxvRiVHh+6EscfRwpEeOL4xI8XqGe2K+BA3mJT9SmUUhv8AdSlmdNH5pAenEhYsV2PhsHNYUW5cWht9q05sePzy/1BF9b3tu2YwizeCKqBgh0LdMUPg1SL1HmxNEDI/Gv6q4GkelGEWE5FHP1zRkOIJcmD/i+qYkRjBEYNu82Z7jAtM3wAIFrnVloK0pfMn5gW5A0Ti1opLcBqvheWAn+a7t8/c9zKy9bFRrFt7oolF9r9D13DJvunJNWXaY/LRd+24GRzMzXb7AsStuAd3YUU7jt9b3qO/pZ653BHQzO7VTcoxTkF2Nuaq/8jrMki9PboAQgeZEQDj+AezTsSVHpnJyPIfmgYTu21Oyf6F0G4NArTIe5AOuOGbmUsKxeCFlVe9yVLfAa11AWaHZcoAdZe1Dydfj4ye+XhMtTM/HpIFennNnamrSDMUKp36ZqG+dE8MUClW9C7fXSZz3oa7VLW8t36mJwgSE/B0s1UpOVqWDzguHbUN+PNh5Hqt88jY5Nr7tXimhGi/fboQfe/ECw3QKU0ulb2j/yYTWGkccg+ljgyEO7w3deSjAtRhxCkcBEzpkgFs3h8S3RTNJuUnpEdrAx3WWf2nHSHZvE/Bnbu1PCld/5VNg9R8uYpHNssWl0HZN9cmzj7YZjuyyFH/9GMNt4A
 uKkehef4
 3z0cqDWBTLhn6G8k3x1bTOkbggD/FGWj2G7KMg5zgEhWW1Y6py5wb7WLuXUm75dFwQ54r/SH4FdajKxcmnn7ia9H0U4hchgSP1VmxhEeYck2o/HsMsa2n7XxGh4jTwdOyoXzOLKacBKvxqrY+DSUe54I0EiYgOvBEt4QA6FwsJOqtsrA4cdaWUyBmMU+hjor58mNWSydKgYWxCaR9xZvL0iSZt82vzGwt/k/UELnFwUDXl5c973czhpUt28SJ2Prm4d/bhU1MwsOrdi4gInorSNtnI1uVFL9F3o29HueZUvSE/hrFcCh4HvdPwhmtNnQ8I6153Cffp3SKfRqtbPO/dbtZXJySNFctnBDqbO347U06EsHrC5L16fSI4hn5FPJlAySYci1ddWPYDh4KQNo2rgKnRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, just a minor cleanup.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 775c385490a5..27b4d11125d6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3453,9 +3453,8 @@ __weak unsigned long arch_max_swapfile_size(void)
 	return generic_max_swapfile_size();
 }
 
-static unsigned long read_swap_header(struct swap_info_struct *si,
-					union swap_header *swap_header,
-					struct inode *inode)
+static unsigned long read_swap_header(union swap_header *swap_header,
+				      struct inode *inode)
 {
 	int i;
 	unsigned long maxpages;
@@ -3679,7 +3678,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	}
 	swap_header = kmap_local_folio(folio, 0);
 
-	maxpages = read_swap_header(si, swap_header, inode);
+	maxpages = read_swap_header(swap_header, inode);
 	if (unlikely(!maxpages)) {
 		error = -EINVAL;
 		goto bad_swap_unlock_inode;

-- 
2.55.0



