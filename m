Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 853C9CFA448
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 04:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98AA26B0030; Thu, 20 Nov 2025 23:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962056B0031; Thu, 20 Nov 2025 23:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4B86B0032; Thu, 20 Nov 2025 23:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 691686B0030
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:01:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 325CC58F00
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:01:09 +0000 (UTC)
X-FDA: 84133263858.30.5353EF9
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50F4BC0009
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:01:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763697667; a=rsa-sha256;
	cv=none;
	b=2pIvTMu5LWHFcodHmeD/MSkpaQ78y1itC7ejUZlvaTGj9MmriSVH0yEPNA5hxdiXAKnZfT
	Wjp+bTWXti/xN81Ct2JM8DXxR36/eoBtyGaDhg5m/PC3Zut3+y3d6db4/T8MdAwiNICz8K
	tKWAJIpBzkj+nJtxAfnbkfVHoWVRmt4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763697667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=KioVTqpk6hY6rwZucMMN/n2O7e0ULMLWPAHcDxDs+c4=;
	b=dcQQ5am331Q88HOcLickKHFN0ohhbG56Ug/g6Mc0RUjnlAExOGH+RTx4DOPkHmI5eNVwV0
	wUMJkNM10FK4K1CNEVrmti7bTeR6qYHaD8Xqwj/wK+WmlB9VedfBRAo1eTTEqyR8eHzvXH
	9QY8CrCEB/zUAVwXGHpVRc3KRHKB7Ug=
X-AuditID: a67dfc5b-c2dff70000001609-7f-691fe3fa945c
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
Subject: [PATCH net-next 3/3] netmem: remove the pp fields from net_iov
Date: Fri, 21 Nov 2025 13:00:47 +0900
Message-Id: <20251121040047.71921-3-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20251121040047.71921-1-byungchul@sk.com>
References: <20251121040047.71921-1-byungchul@sk.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsXC9ZZnoe6vx/KZBgumilus/lFhsfzBDlaL
	n2ueM1nMWbWN0WL13X42iznnW1gsvq7/xWyxblcrk8XOXc8ZLV7NWMtm8fTYI3aL+8uesVjs
	ad/ObPGo/wSbxbvWcywWF7b1sVqcO7ySzWJ7wwN2i8u75rBZ3Fvzn9Xi5KyVLBYdd/ayWBxb
	IGbx7fQbRourM3cxWSy8E29x6fAjFovZjX2MFr9/ANXPPnqP3UHOY8vKm0we12ZMZPG4se8U
	k8fOWXfZPRZsKvXYvELL4/LZUo9NqzrZPDZ9msTusXPHZyaP3uZ3bB4fn95i8Xi/7yqbx5kF
	R9g9Pm+SC+CP4rJJSc3JLEst0rdL4Mpo3zCDtWC+YMWcH3kNjF95uxg5OSQETCRWXT7ODmO/
	/76eCcRmE1CXuHHjJzOILSIgJfFxx3agGi4OZoE1rBLLZ2xl7GLk4BAWcJdo3O4HUsMioCox
	b/4cRhCbV8BUYvu3RYwQM+UlVm84ADaHU8BMYt+jmWBxIaCaNZ0PmEBmSgg8Ypf4++oVG0SD
	pMTBFTdYJjDyLmBkWMUolJlXlpuYmWOil1GZl1mhl5yfu4kRGIvLav9E72D8dCH4EKMAB6MS
	D+8JTvlMIdbEsuLK3EOMEhzMSiK8qo4ymUK8KYmVValF+fFFpTmpxYcYpTlYlMR5jb6VpwgJ
	pCeWpGanphakFsFkmTg4pRoY1/nc706e/3nipjNPImzEZxWny4Xqbz380KqyjPsXk+j23Y0B
	p4r28EaceHbQYqvdQsH7nnXhodMNuud+z9ncfi/SxrGnwOnQm9UhG37/Nagv2FuzeNGVCudo
	jv/+R0NvLnj39/eTS3M19bbuu+j5ILFkU7D/XIuJLY4zaps0Vtg4y140lWlgV2Ipzkg01GIu
	Kk4EAL4K3ZPBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRa0hTYQCG+87Ozs6Gq+OUPK1oMpBAyDQ0vi5YEeEhyIKiG5SuPOjBOW1z
	y0vBxEQdpClFR525Fd5nrpXuUqlomualcBhL1GRiShfN21KLzBn9e3jfh/fPi3NE91ExzihS
	aaVCJpdiAlQQfTB79+qEhAlljTxYv5wGq8dtXLhimkKgvq4ZwPrRQgzq391G4VLjKgc+ceQg
	0O6YAvAL24DByS43D36q+ozCl7lWDnQXdmNwJmcAhR3lPVz4vrmACwc6ajFo1Y7zoNOhx+CY
	aY0Le0prUZg38gqFXYat0NP7DcChEgcCjSMxcLDDjcKyrAIAfy2v+2WdY7wjEup57UeE+sAW
	oZSr5S1C2UtHeZTBoqae1QRTzn41ZanLxyjLfDGPstsWEOpO9gxGzU0Oo9RsyxBGPZ7+gVB9
	htc8asGy8zRxSXAojpYzGlq5JzJWkJBrZrkpFb5p+mWFFiwJdYCPk0Q4OfuzEfEyRuwiXa4V
	jpf9CTE5Z7PydECAcwgTl6xmm4AO4LgfEUVmWaO9DkoEkQ8r9MDLQiKCtHoegX+bErLe3Lax
	wyf2kS3uko1ctO6Y8seRu0BgAJvqgD+j0CTJGHlEiCoxIV3BpIVcS06ygPWzqm79LrKBRWdU
	OyBwIPURdvMljIgr06jSk9oBiXOk/sKgozsYkTBOlp5BK5NjlGo5rWoH23FUGiA8cZ6OFRHx
	slQ6kaZTaOX/FsH5Yi2I9432yYmZOHX8wp8HPg1nLjJbdJ0BhpqsVO1SZviarthjTLzOVrqs
	TaETlb2V5Zm97GJ1xYHWw8nHXjjjptnN3zWKwKuWRWNko54zM2yP2rut7c2NMEN/q7Ds6+Q5
	5VnPTXReHf+0/3Kf+QqZESgezHP67T9ZOD/CulPMZ8T3pKgqQRYWzFGqZH8BoGkrzagCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 50F4BC0009
X-Rspamd-Server: rspam07
X-Stat-Signature: 9kwfkzne3ep1sizghzohdrschdoyycsu
X-Rspam-User: 
X-HE-Tag: 1763697667-58717
X-HE-Meta: U2FsdGVkX185s/uDbtRnPclRRKmfAsfGwFF1uupvkIRHkX0+1tqcYsI16T7kGnAUvUE/m8jdyBDN9st24pJnBWC/Zm2SfNuBL8aGa20Mnmac+rToSNBGDhib6VjQzyyF2VTlDXsPii8hPDN2BQnNdqkhr8OqOwkwASuf3gAEQyU9JY0eb0B9yAYkeYZZk318F20fkBVZVBSTW1BLRBzXf6zIvH6xmOW+KIF1lHw8/MWKkfGPQCyMinWHGaF1x0kjr98oX1o94Ds5yt6cVsCzrEfz8qpQlkXsuWGi2Cg7YPRznnR6radx7A+MbY8b93aW7+Zw3i9WYcBWxDs9GOXMNe6ytVZXmbzNIYubItEdZihqQT1a/Ot+vfgeZ+32/xGOxCCnpV0aAU5em9WHEUDa2QbuaU+5yL6O1q+X18CoVHGqdGQqJXVLreFACwyI1fy1ONw3kfE4LhV66OqTjgOYjNaz9xoykmg3S3r/a3+JMIRw7tLe5PSXM5rt+tBTfoQmFFMGnPpblBwUx1ujIWQKtTHeoWlS8dFtqLoJAgQBJCwURBzrXXhWxx8TjJhuNv/revSHS5tr0b55GQJTdiI/9jOPjjcDoerm9txMJJHYWN6cnrl3CgTmlluDvdE4mwK9dxA1pNsPINc/tmDLjLNC5czPr+p1MHAbJofO71ls/ut7KRoSAxdqqDyn2Lg0Fher+hS0+8DBsB4P689A6TqQq6OnmvVcMdub3ZE8wKuFvr9SsAMYbX1VmLabXge00IJ1hx1J+mSTVhyjfPGpCk41iGr13vcXsjol7I+lu9uIWO6mDfDMwgzrXsEhsZEEiZJLbKkbR9vSsFdJ047atoOugt+OiggXELjdJq7wBl64TsQqidoYsl52GWHLc1u0jZz4uFRmRc2ndfjI5W0ldY6OerOwG5+DFWHqu661LCHoreAeTFqJTkdWn9oU2UxrGvmgRO1xj+WuX0REVP4gp1B
 4NeWU/Yb
 8tew/chDj0AiD5kLnIKGVo2lcT0apxCFOC9GfPWIctfoDGrn+0MatC5Vbde7wUR8WQ+US4XayQkeZExV7qzVdb/iTmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the pp fields in net_iov have no users, remove them from
net_iov and clean up.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
 include/net/netmem.h | 38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 9e10f4ac50c3..46def457dc65 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -93,23 +93,7 @@ enum net_iov_type {
  *		supported.
  */
 struct net_iov {
-	union {
-		struct netmem_desc desc;
-
-		/* XXX: The following part should be removed once all
-		 * the references to them are converted so as to be
-		 * accessed via netmem_desc e.g. niov->desc.pp instead
-		 * of niov->pp.
-		 */
-		struct {
-			unsigned long _flags;
-			unsigned long pp_magic;
-			struct page_pool *pp;
-			unsigned long _pp_mapping_pad;
-			unsigned long dma_addr;
-			atomic_long_t pp_ref_count;
-		};
-	};
+	struct netmem_desc desc;
 	struct net_iov_area *owner;
 	enum net_iov_type type;
 };
@@ -123,26 +107,6 @@ struct net_iov_area {
 	unsigned long base_virtual;
 };
 
-/* net_iov is union'ed with struct netmem_desc mirroring struct page, so
- * the page_pool can access these fields without worrying whether the
- * underlying fields are accessed via netmem_desc or directly via
- * net_iov, until all the references to them are converted so as to be
- * accessed via netmem_desc e.g. niov->desc.pp instead of niov->pp.
- *
- * The non-net stack fields of struct page are private to the mm stack
- * and must never be mirrored to net_iov.
- */
-#define NET_IOV_ASSERT_OFFSET(desc, iov)                    \
-	static_assert(offsetof(struct netmem_desc, desc) == \
-		      offsetof(struct net_iov, iov))
-NET_IOV_ASSERT_OFFSET(_flags, _flags);
-NET_IOV_ASSERT_OFFSET(pp_magic, pp_magic);
-NET_IOV_ASSERT_OFFSET(pp, pp);
-NET_IOV_ASSERT_OFFSET(_pp_mapping_pad, _pp_mapping_pad);
-NET_IOV_ASSERT_OFFSET(dma_addr, dma_addr);
-NET_IOV_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
-#undef NET_IOV_ASSERT_OFFSET
-
 static inline struct net_iov_area *net_iov_owner(const struct net_iov *niov)
 {
 	return niov->owner;
-- 
2.17.1


