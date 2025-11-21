Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77F4CFA46E
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 04:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2101E6B002E; Thu, 20 Nov 2025 23:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8216B0030; Thu, 20 Nov 2025 23:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE6F6B0031; Thu, 20 Nov 2025 23:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 006DF6B002E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:01:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C258B13B006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:01:06 +0000 (UTC)
X-FDA: 84133263732.14.04F184A
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id E44C3C000B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:01:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763697665; a=rsa-sha256;
	cv=none;
	b=uqSbxdaDBuT36GIYYCTxON0HxqrsK9OYVHgAWc9tGCpc2pSEwE2BMZrf0DYSXiPxV92ZKD
	Q/tvTEEkbR5xRPAeShLTzXxrSNDdIA2AUWjZkUmNVh8xe4bTzxMOijN7+P8qVZE20Qz4E7
	0AfrnBF3Fn+g3MwHG8i1R4pPP0Gw7iI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763697665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=HcK2DdBm4Zrq+7VoY/J5fRqhKAsS9JbhFClpFyicbzE=;
	b=dHxo4jflsljI6az4Bgmbn+vrh2+irmeaKWcD/1+uIJaki8iStyYLXmIVos48KgHIu+yope
	rftH9tLoRJpFZXp7B2jdFFTWtBQFZfCmijxEaitO6z4bVJs4ZJt9bwMtVWAMJJP3MGetB1
	3JbBM/1O9c0Ie8p92RzycMimNlxHMGQ=
X-AuditID: a67dfc5b-c2dff70000001609-76-691fe3fa2e4d
From: Byungchul Park <byungchul@sk.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	hawk@kernel.org,
	andrew+netdev@lunn.ch,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	willy@infradead.org,
	toke@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	asml.silence@gmail.com,
	axboe@kernel.dk,
	ncardwell@google.com,
	kuniyu@google.com,
	dsahern@kernel.org,
	almasrymina@google.com,
	sdf@fomichev.me,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com,
	shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next 2/3] netmem, devmem, tcp: access pp fields through @desc in net_iov
Date: Fri, 21 Nov 2025 13:00:46 +0900
Message-Id: <20251121040047.71921-2-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251121040047.71921-1-byungchul@sk.com>
References: <20251121040047.71921-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRW0hTcRzH+29nZ2djw8NJ6rhMYWSBmGVp/QkRFcrTW1AvXUBHO7nRNtfm
	ZWbRpMQLpNZLzu1h68E5nU7mZRdK8pJpXlqZOs2ZztQoL6glXgrblN6+/L7f74cffDEm0YgI
	MKkim1YpRDIhykW4SzzTye3ZSOnpv3oC1m9qoHnayYJb1gUGNNS1AVjvq0Ch4cMTBP62bTNh
	o7uIAV3uBQB/VDWgcK7Hz4Zfa+YR+KrYwYT+il4ULhcNIdDTVs6CQ10WFDq002w47DagcMq6
	y4J91RYElky+RmCP8RDc6F8EcETnZkDTZDr81OVHoL6wHMCdzUBe/3aKnRxBtVjGGdRo1TOE
	8ra/Z1Cuah+bMtpzqObaaGp4MIey15WilH3tOZtyOdcZ1NPHyyi1OjeBUCvtIyg1YOxmU+v2
	iCshN7iJYlomzaVVp5IyuJJ3gR+U2hDN56IxVAtMvDLAwUg8nhxp3UHLALantb/Q4BnFT5Be
	7xYzqENxAbnqdLDLABdj4lYWaa5qBUHjIH6LHN+dQYIawaPIWe0ACHL4eAJZ+VGzj48k65ve
	7HE4+Dmy3a/bqxKBiLV0mhFkkrifTZqbtcz9QhjZUetFKgHfCA7UAUKqyJWLpLL4WEm+QqqJ
	vZ0lt4PAijUP/9x0gjXP1U6AY0DI4/dyIqUES5Srzpd3AhJjCkP5USnhUoIvFuXfp1VZ6aoc
	Ga3uBEcwRHiYf2YjT0zgmaJs+i5NK2nVf5eBcQRaoLvsUX5hKQ0CbP38Hd6o7VteU1zj1AOB
	pz8z1TFqI0pM+PHw4hnXC5+q0JbBuZRyzx9mXhoci+/zXVxJBup5CxrDn0/sFl+T7GY/GpaH
	t7oMPy8kvNTVfs+cSLMSachOqnmyQHRMspKUOBaz1aK3HHWcvc5pW2yI7RgfKhAiaokoLpqp
	Uov+AbuWMSnBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsXC5WfdrPvrsXymwe4HzBarf1RYLH+wg9Xi
	55rnTBZzVm1jtFh9t5/NYs75FhaLr+t/MVus29XKZLFz13NGi1cz1rJZPD32iN3i/rJnLBZ7
	2rczWzzqP8Fm8a71HIvF4bknWS0ubOtjtTh3eCWbxfaGB+wWl3fNYbO4t+Y/q8XJWStZLDru
	7GWxOLZAzOLb6TeMFldn7mKyWHgn3uLS4UcsFrMb+xgtfv8Aqp999B67g7zHlpU3mTyuzZjI
	4nFj3ykmj52z7rJ7LNhU6rF5hZbH5bOlHptWdbJ5bPo0id1j547PTB69ze/YPD4+vcXi8X7f
	VTaPxS8+MHmcWXCE3ePzJrkAgSgum5TUnMyy1CJ9uwSujONAhxQ08Fdcab3O1sC4kKeLkYND
	QsBEouELWxcjJwebgLrEjRs/mUFsEQEpiY87trN3MXJxMAusYZVYPmMrI0hCWCBG4ub/hywg
	NouAqsTjhjOMIHN4BUwlJlysAAlLCMhLrN5wAGwOp4CZxL5HM8FahYBK1nQ+YJrAyLWAkWEV
	o0hmXlluYmaOqV5xdkZlXmaFXnJ+7iZGYGQtq/0zcQfjl8vuhxgFOBiVeHhPcMpnCrEmlhVX
	5h5ilOBgVhLhVXWUyRTiTUmsrEotyo8vKs1JLT7EKM3BoiTO6xWemiAkkJ5YkpqdmlqQWgST
	ZeLglGpg1Pz+cZWWZO0ppof14eWv5oTK61TP2N6cYiKUWrx7Z/avBRz7PNQKmVaqZBZXa1x+
	f2KZ2+1V9zIO/5PpPcCosNPIZxJT7ny3OJVP3y4fa2LV6vtYfSlL1mZ573b3p6x9h71n7Xhi
	vmrKC+tASz2xy0c6r4m2WSdraZhF94jZBt2NcDN/mhSsxFKckWioxVxUnAgAthD0vqgCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: E44C3C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: a1gr7p4z5g3wkt6d4d7ft8r1u5ttcgzw
X-Rspam-User: 
X-HE-Tag: 1763697664-282290
X-HE-Meta: U2FsdGVkX18cZ1f870DUgCeB/QdgDZxA1Url2R9akV+YOoesMBQp7YfWBP/+HG+nw8MNufBHE/qiCxht5gmGY9ZS42xyY/a+mxtsbTIBjy4vqYZoD8jTfgoCh0yoQdFG/pqoeQL3Ao0Qwpfb3moOpDu4oZNC6Mml9qo6hY+bPnU9FxSB4mB/MYm9eMJeYocpy/UsuqPaR8H6kHKqmFliFtrQX6Y9gZlM4g/XDiA12bt3VteJ8CdwRTJLkpUmUkZwJy6LJ6nwyo7XjaxTL5JoNyMYcvH7nFtHssfCOHWAezD5twKPa1Pw+AYYeLb5FbxjHVhM/LTXoBzkoklIxF+0Kl9wsKSkp4ziP2NhrcMUi4QX/xM5HwRIybiTjbUzI63CsM5sYqDjJ44LZKML0RKNca0SX1CUGZyBSW4Ns4dafS7smL56HgiUXloms0dOzQBD+AY+NXhspjt31B6DJGRHqm9/goN8M4YCUa5OaTrnbM1GkExykHigcq/9xrU7U+yrmY38G8EragRq4okbM4qH2v1aPprIYqakVcXtfMBglO44O5UapaR+JMqKWXkF+4+Qg2EEPQS/dMT5ddh3/mOb8ME/s3NBvnzHHS5+iBmCofpLkQ+8zQesRcd1HsZMZt2yFBvMcu4ctteQU7Ck5ZfZSe8ruUPStPJJCt4sarq7q6KKk04nmTAzClORmfpayNMtqaiA7MuR7krU5LxR4jhFPtgUQQUYhWomB//yo/X+Q/AQCJ2C5I1U/r0X7CTXjFZ908cbnil3K0CD9jQH5s926Fk0Jyup4P5FqM0sFFA3tfryJ1ky3HefvO1I7BM5AecP1vcPFOD3faa7txLXGGExVBk4tYh7nQZbNBnniyoZM7p2yIOptGwnu0xKia2d2Q+Eo/hCfgs7bzn+7F1GQoTJ0sixpOY7isrU9BOgd0w48tFSnZUCVdkcMNcDJPz/vhbWnmTdQVCHBGYF9dBJ5mc
 GmugzT52
 slqY+PseZXuJfuF6mCEfgzWm015Y9hTgvNjCiEGYAjcgEBGYW1qWYMX/yr2idNtmwhuoZrjWgV+NOaEmOIxAY7Z2qhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert all the legacy code directly accessing the pp fields in net_iov
to access them through @desc in net_iov.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/linux/skbuff.h | 4 ++--
 net/core/devmem.c      | 6 +++---
 net/ipv4/tcp.c         | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ff90281ddf90..86737076101d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3778,8 +3778,8 @@ static inline dma_addr_t __skb_frag_dma_map(struct device *dev,
 					    enum dma_data_direction dir)
 {
 	if (skb_frag_is_net_iov(frag)) {
-		return netmem_to_net_iov(frag->netmem)->dma_addr + offset +
-		       frag->offset;
+		return netmem_to_net_iov(frag->netmem)->desc.dma_addr +
+		       offset + frag->offset;
 	}
 	return dma_map_page(dev, skb_frag_page(frag),
 			    skb_frag_off(frag) + offset, size, dir);
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 1d04754bc756..ec4217d6c0b4 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -97,9 +97,9 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 	index = offset / PAGE_SIZE;
 	niov = &owner->area.niovs[index];
 
-	niov->pp_magic = 0;
-	niov->pp = NULL;
-	atomic_long_set(&niov->pp_ref_count, 0);
+	niov->desc.pp_magic = 0;
+	niov->desc.pp = NULL;
+	atomic_long_set(&niov->desc.pp_ref_count, 0);
 
 	return niov;
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index dee578aad690..f035440c475a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2587,7 +2587,7 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 				if (err)
 					goto out;
 
-				atomic_long_inc(&niov->pp_ref_count);
+				atomic_long_inc(&niov->desc.pp_ref_count);
 				tcp_xa_pool.netmems[tcp_xa_pool.idx++] = skb_frag_netmem(frag);
 
 				sent += copy;
-- 
2.17.1


