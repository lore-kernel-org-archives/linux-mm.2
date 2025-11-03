Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D1B8CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5F08E0015; Mon,  3 Nov 2025 02:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD838E002A; Mon,  3 Nov 2025 02:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A7A8E0015; Mon,  3 Nov 2025 02:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B80958E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:51:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49EC6160A73
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:51:28 +0000 (UTC)
X-FDA: 84068525856.13.ACFA8DD
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5FA40180006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:51:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=cODt/7c2sru8679vPb3m33Kl9xqg95Lcwm4NKElHQBg=;
	b=BjzAQ7wdDacKjSHtMGa/LDbUnhTfcXF4ke/EBG25EZom9MK2phmF2ewri0N5Li3jKyywi8
	g1hSxm6AJ41tPC+uyJD+XUALrh9kRqkk7yJ5Ws1rAKPRhmngPkIrpij5gK3joD3BLl2KJZ
	9Zu+vRLYaA89LrEyWvJBGDBJMwPpU8s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156286; a=rsa-sha256;
	cv=none;
	b=GSIdOH4mHIrHMugubYx5K0YwHdrSgel12Qkh3Tv/AeovOHf1xzXVm4DA1osGXa0kI0ZQ6y
	ShlyxHUAwk7uAEbGulQqq362qFY6XW7FcXoapVhDiLDiK9kj0PffblSVaL7y1aM4yMtqxy
	yzeoPFVPO9kl/7dgKCqhsAZ/hg0UByE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c45ff70000001609-ff-69085ef70e8f
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	pabeni@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	horms@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ilias.apalodimas@linaro.org,
	willy@infradead.org,
	brauner@kernel.org,
	kas@kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com,
	almasrymina@google.com,
	toke@redhat.com,
	asml.silence@gmail.com,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as page pool for net_iov not page-backed
Date: Mon,  3 Nov 2025 16:51:07 +0900
Message-Id: <20251103075108.26437-2-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251103075108.26437-1-byungchul@sk.com>
References: <20251103075108.26437-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXSb0gTcRwG8H53t7tzOTqW5qWRMIrASE2tvkGJIMSvIgh6VUE53JFXumTL
	pYG0apJlmlmW6QTtj82pWLN0LldrM80yCkudVP4vo8zMfzk1bBq9+8DzfJ9XX5aUZ0gCWVF9
	QtColYkKWkpJf/iWbvh9iBXDPxX4g7G6koaK6VS412uVgKdyiACjuRbBhOcDA/P2JgTjjc00
	fHeNIbhdOkWC8Y2BgsnqGRLqbUMIvhVU0fC5qZ+BCsse6Cn7QkHD+ToS+i+/oCHbMEuC3TPC
	wFmryTtco2fgbW2OBK7N3CWhTt/LwDubkYbuynkJfHFmU9BSWE7BaH4jCT05MdBUsgKmXg0j
	aKyuI2DqUjEN7TdtBDyytzNwta2EhgFDD4I2Vz8F+XOZNBSdyUEwO+2dHMmdkEDR824mJhSf
	cbtp7Br+SeKH5V0E7ii4QmH3k5cEri/8xOASSwquMYXgi+42ElvMF2hsGctj8MeOBhq/KJil
	cH3fVlxvHSdw9rkReq//Aek2lZAo6gRNWHScNGHSOk0lvw9Kbfp1h9KjwRUXkQ/Lc1H8ecco
	89+u/kx6wTS3jne7PeSC/bhw3pQ/4bWUJbkslv/w5MFisJxT8+Nd9kVT3Fr+a187tWAZt4kv
	zXLS/0aD+Yr7jsWOD7eZt7eWEQuWezvmh4bFUZ5zsHzDn9fEv4OV/DOTm8pFshK0xIzkolqX
	pBQTo0IT0tRiamj88SQL8j5HWfrcQSsae7vPiTgWKXxlvfGMKJcoddq0JCfiWVLhJ+syUKJc
	plKmnRI0xw9rUhIFrRMFsZQiQBYxdVIl544oTwjHBCFZ0PxPCdYnUI8yVq/KIxMC4pfoHN92
	GiPiM6W7zcpy/10hP/qiTjuyRm/tCFb1SIa3momc2uT9nZE3tumwQttS7HkfeW9+YF2k+LT5
	+tItsdHLgh5v0LoqhvIybMGDN7pjYp8ubz+5ptOuXa/YblN/3dWrzy+Kk6iC3h0++tmvqkbb
	WpoVEd6RHqagtAnKjSGkRqv8C9711w0YAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTYRwG8N6ds/ccZ5PDMjtoEY3EEtKkrH9m0ZfoIBjdi6B01CFP6qxN
	TaNCc5BmLrVWZkpqZd5Cm7WLOKnN7KKQeMmZ5a20m1le84Y1jb794Hl4vjw0Iesn3WlBGc2r
	lIoIOZaQkp2bk9b8PkoLa40nIae8DEPpRBw86DaJYbLsswhySgwIRic7KPhjqUMwUvsCw3fb
	MIK7+eME5LzRkDBWPkWAueozgm9ZDzH01fVSUKoPhq7CfhKqLxkJ6L36EkOaZpoAy+QgBRdN
	RY7hygQKbLmvxNBo0Irh+tR9AowJ3RQ0V+Vg6Cz7I4Z+axoJr7KLSfilqyWgS7sN6vLcYLx+
	AEFtuVEE41dyMbTeqhLBE0srBdea8jB81HQhaLL1kqCbScZwO1GLYHrCMTmYPiqG2887qW2+
	XKLdjjnbwE+Ce1zcLuLeZmWQnL3mtYgzZ3+guDx9DFdZ5M1dtjcRnL4kBXP64UyKe/+2GnMv
	s6ZJztyziTObRkRcWtIg3uV2WBJ4nI8QYnmV79ZQSdiYaYI81eIRVzd0j0xAn9wuIyeaZdaz
	tt5kPGfMeLF2+yQxZ1dmLVukG3VYQhNMKs121DyaDxYxSnak3TJvkvFkv/S0knOWMv5sfqoV
	/xtdzpZWPJ3vODEbWEtDoWjOMken5LGGSEeSPLSgBLkKythIhRDh76MOD4tXCnE+x6Ii9cjx
	fuH5mQwTGm3eYUUMjeQLpd3HKEEmVsSq4yOtiKUJuau0XUMKMulxRfxZXhUVooqJ4NVW5EGT
	8iXSoIN8qIw5oYjmw3n+FK/6n4poJ/cE5KI7NBV0kvBKCjQcaeGl7+SNPhVts8taVukMG73c
	tWJ1wOr7yb/PZq+Oly/NFG4WnCvff+DJ3oGxNkr4keiyx7zYvq9ruu+0R+DKNhd2e2a+5Wt6
	2ooLdz1t2pAr6y5h3wZnv6gthcGzBS6Rht1nhooDntWv2G/sTFHdCM24lX7HWU6qwxR+3oRK
	rfgLYMXzOvkCAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FA40180006
X-Rspamd-Server: rspam02
X-Stat-Signature: ty3g86pwm513oawno3mgwbf5p5fqinzg
X-HE-Tag: 1762156286-969735
X-HE-Meta: U2FsdGVkX19wRD4yDoBJIRfcNZrMvvjzPSjFwaJyT38a6NlQ56SgNfNR5cQy97TxOl2e1N2odHSIx6mAF7qKKMpR3AmhREH0f3hODA0DiYxRnazODrumEL7Uw8FiV7khomWGOtbTDu4PNw0uciICfqqgoCrcu8+gt5xbTTiD2lNv3sLpCxMjw2ww8N3Gj2cIrwVssFi0qzFTnudBBqIqOOXB2PrfnjZxMTwHj/Lzy74WHVyXVlQJbdBLB1X6yvjXFvU/JQ+ftSR+Vye7DoxIAsLmFKhgNCLdw5hswkAEulfh2YIMYJAoHtj2Yz/aKzDsmCvPa0pjKh/mzaAogj57Mtl0fIJt+Z25PnSVPbrKe5eE/VyVr95mG6Oi6Op5RCA26r80GogYVwjBjDjaowvGjeWDeF93UZz4gJDidbWuVhssA3D/RjEct3W+QquwepI89tw/u+hggwAX5K6JScaqRndWrq/nUXmz2aeW8U/9e6MlnnihaiQEVVUM9CParV4Xw9uGBGrmsvbXKBxPFC0bowX71uQdZyyXtf0uF/T7sUYp93PA449AB4ruDGOJrJqtRjLEeJeRj4nqegtWnoHmIBql367K7nZXMBtnMKO+ilyR56Op42TnKtlcAfPGSBdDmH2UHa9BUZx/PoY17W+zb20l5ii7KhSzLCbFPYze9Cav4A+7mkUllSwyfwMAqRPNAatBiWajDU7NHAnSYLTJzn1MUVg5vTB4Zfae+QfFBbRDLD9gOHPajXFWJPBbAcu6fRHgQfsOILhOxy1h0B9oOhmultmEFqmwM1oZaAHoT3f7xuk0UKvieGLoemezDolSzyGyRN7VxrgRVtMbyRG4sEYlAdo+pmX/Y2gmfM/HV4y4zQkqCJNcnfcBIQjRi0dK8/xUOMb8Q1D654BaLi97slHRAfpCSPRHixsEIZ6bQncEbZtWkr0xVKTUi2fTQ5Zo2L6QOcScdNvbKTGNJir
 nT3NO96J
 m51L9p+SNSS4aykch8eCQURuwPFNFlgDlAgYoy3nNOu8s23S7RqAWefy1Pre+UO7s7jmH5XXG8N0E6FCinATVGB490n26Xflr2jCqcyQxBtG0quIvNyItCFpC1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
determine if a page belongs to a page pool.  However, with the planned
removal of ->pp_magic, we will instead leverage the page_type in struct
page, such as PGTY_netpp, for this purpose.

That works for page-backed network memory.  However, for net_iov not
page-backed, the identification cannot be based on the page_type.
Instead, nmdesc->pp can be used to see if it belongs to a page pool, by
making sure nmdesc->pp is NULL otherwise.

For net_iov not page-backed, initialize it using nmdesc->pp = NULL in
net_devmem_bind_dmabuf() and using kvmalloc_array(__GFP_ZERO) in
io_zcrx_create_area() so that netmem_is_pp() can check if nmdesc->pp is
!NULL to confirm its usage as page pool.

Signed-off-by: Byungchul Park <byungchul@sk.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
---
 net/core/devmem.c      |  1 +
 net/core/netmem_priv.h |  8 ++++++++
 net/core/page_pool.c   | 16 ++++++++++++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index d9de31a6cc7f..f81b700f1fd1 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -291,6 +291,7 @@ net_devmem_bind_dmabuf(struct net_device *dev,
 			niov = &owner->area.niovs[i];
 			niov->type = NET_IOV_DMABUF;
 			niov->owner = &owner->area;
+			niov->desc.pp = NULL;
 			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
 						      net_devmem_get_dma_addr(niov));
 			if (direction == DMA_TO_DEVICE)
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 23175cb2bd86..5561fd556bc5 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -22,6 +22,14 @@ static inline void netmem_clear_pp_magic(netmem_ref netmem)
 
 static inline bool netmem_is_pp(netmem_ref netmem)
 {
+	/* net_iov may be part of a page pool.  For net_iov, ->pp in
+	 * net_iov.desc can be used to determine if the pages belong to
+	 * a page pool.  Ensure that the ->pp either points to its page
+	 * pool or is set to NULL if it does not.
+	 */
+	if (netmem_is_net_iov(netmem))
+		return !!netmem_to_nmdesc(netmem)->pp;
+
 	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
 }
 
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 1a5edec485f1..2756b78754b0 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -699,7 +699,13 @@ s32 page_pool_inflight(const struct page_pool *pool, bool strict)
 void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
 	netmem_set_pp(netmem, pool);
-	netmem_or_pp_magic(netmem, PP_SIGNATURE);
+
+	/* For page-backed, pp_magic is used to identify if it's pp.
+	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
+	 * and nmdesc->pp is NULL if it's not.
+	 */
+	if (!netmem_is_net_iov(netmem))
+		netmem_or_pp_magic(netmem, PP_SIGNATURE);
 
 	/* Ensuring all pages have been split into one fragment initially:
 	 * page_pool_set_pp_info() is only called once for every page when it
@@ -714,7 +720,13 @@ void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 
 void page_pool_clear_pp_info(netmem_ref netmem)
 {
-	netmem_clear_pp_magic(netmem);
+	/* For page-backed, pp_magic is used to identify if it's pp.
+	 * For net_iov, it's ensured nmdesc->pp is non-NULL if it's pp
+	 * and nmdesc->pp is NULL if it's not.
+	 */
+	if (!netmem_is_net_iov(netmem))
+		netmem_clear_pp_magic(netmem);
+
 	netmem_set_pp(netmem, NULL);
 }
 
-- 
2.17.1


