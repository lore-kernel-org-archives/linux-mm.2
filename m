Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08CEEFB806
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 06:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0366B0093; Tue, 24 Feb 2026 01:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E8B6B0095; Tue, 24 Feb 2026 01:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FFE6B0096; Tue, 24 Feb 2026 01:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E70A16B0093
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:14:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E989113AC54
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:14:43 +0000 (UTC)
X-FDA: 84478336446.16.623B24B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04434140006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:14:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771913682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=r0ssUiufOUpzfHBsyZ/OiCJ5AcSTC2gWVzTVbQMxs5g=;
	b=SpJ2VtRBdG9vXW7fXmyfsWt98IkXYU7ok02hiNRuupXsh2zg9N3feXNEsx4iwWCILsk/ag
	IGtL3Uv/ezBAkeaWxpbyvWK3LH03Tu0h9l1cpizRh7s4fewkkUosCrFgUWpW3S2uk2Yi47
	DZMchfeVrP4cA5Sg/uvwHmEJ7REQlJ8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771913682; a=rsa-sha256;
	cv=none;
	b=AC7mp7uYNUQ6z0k5Fq8bO2KZMni/U3yC6qukLJV3uZb0YvPbL3e6ckaPleDcA8K/jqTOr8
	HZ54zu43KIpS3W6ZWkLFGVQaGtIT+AbP1sE/XufUit7zCDD6o/S1cvTtRWS1kpj4Cf81TN
	NLl08kjrQVlAdeK716uMegeVGS7C16Y=
X-AuditID: a67dfc5b-c2dff70000001609-f2-699d41ca80b2
From: Byungchul Park <byungchul@sk.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	hawk@kernel.org,
	andrew+netdev@lunn.ch,
	david@kernel.org,
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
Subject: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
Date: Tue, 24 Feb 2026 15:14:24 +0900
Message-Id: <20260224061424.11219-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRX0hTYRyG/bazc47T5WlqO1kYLMIUUotZHxGhN3WoiKAu+oPpaKd2aE7d
	nGkZWCbmIjUvZG1LZg3TTSVW6Vw6l6akLTPF0Jz/mYIsl5qmTiiXdPfwPu/7u/nhbH4FEoEz
	8ixaIRfLhCgX4f4Ifn6gJ+kZE+9wJkDzag58OWHlwLW6WRbUmxoBNI+WolD/5QECZ9+uA9hg
	K2TBZtssgHOaehS6u6YwOF49g8CWoiY2nCr9iML5wl4E9jWWcGBvRy0Km/InMDhg06NwrO4P
	B3ZraxH40NWKwC7DDrjyyQPg4FMbC1a5UmB/xxQCdfdKAPStbvZ1nWNYYiT1pnaYRX3TPEGo
	IXsPi2rWjmKUwaKiXtfEUAOfVZTFVIxSlsVyjGq2LrGoxwXzKLXg/o5QXvsgSjkNHzBqyRJ5
	LuQy95iEljHZtCLueCpXqmmtxjIs4TlzHiYfmLarQSBOEiLS2efiqAH+j4e1e/0xSkSRQ0Nr
	bD+HERHkgrUJUwMuzibqOKS904v4RShxipwbeYH6GSH2kU57JfAzj0gga0Z+srfu7yHNrxxs
	/5gkujDSpJlBtsRO8n3NEFIGggwgwAT4jDw7TczIRLHSXDmTE3stPc0CNr9VfXfjihUs9p1v
	BwQOhMG81GQ9w+eIs5W5ae2AxNnCMJ7Pp2X4PIk49zatSE9RqGS0sh3swhGhgHdo5ZaET9wQ
	Z9E3aTqDVvy3LDwwIh+Yy41nk5N1ifHhLe5J6f6Rk6K4LOPheMEjvFera7QPo+7Kd1UpX83T
	sUpMVN8NJZmOvP6N07+jnetXJ7ddXFYNCipOBJk9y6Oa6CP3XWUBDQXLYyHjxrJf0z3qpKJC
	752jemPx9Usy4xk0Tl7kaRNcCPWl2vK807uj+tscmUJEKRUfjGErlOK/BedXSqkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAwGQAm/9CAMS/QMaCGludGVybmFsIgYKBApOO4MtykGdaTCQtyc4q/h4OKfg
	uAU4+aznAjicqrYBOKvdjwY4nM+EBDjntfoBOK66hQI4ubrnATjqmK0GOOXG4gc436bmBDi8
	h7cDOOKPyAY47oXOBDjDnckFONC2jgU4zsOpBji3gOAHONO6nAY43qz/BTjJmqkEOIjcvQQ4
	xqAWOPbL7AE41Zm6Ajih3F840sPiBDibgY4BOPv4nAY4m8XeB0AfSLSp2QJI1piRBEjYvsoC
	SLma3QdIoLJ1SLOoKkjTzXVIsqqJBkiy8pIHSLm48wJIjYPuBkjx5doESO++1QZIo+jwAkjM
	oMQHSPOyHlAQWgo8ZGVsaXZlci8+YApomL2mB3CyFXjq7GmAAaoRigEICBgQNBjZmiOKAQkI
	BhAnGNjY+QOKAQkIFBAaGPG4tweKAQoIAxCsBRi+xe8EigEJCBMQShjq26MGigEJCAQQJRjM
	vp4BigEJCA0QNRio2/ADigEJCBgQHxirsMADkAEIoAEAqgEUaW52bWFpbDUuc2toeW5peC5j
	b22yAQYKBKZ9/JG4AfTTR8IBEAgBIgwNYF2caRIFYXZzeW3CARgIAyIUDfv7mmkSDWRheXpl
	cm9fcnVsZXPCARsIBCIXDUpXZWASEGdhdGVrZWVwZXJfcnVsZXPCAQIICRqAAbwOFT//J0vr
	vprO+hwacpsB34bHxpDz38gSQjamvYcNuYWeT5BXN+0pZFKqQ7AYoLQ9DCr57x/IpXo52Sho
	raOYhVFqaSxUxx2n89T/g5q0kLL6YyObh8Jn084Fwp9MRGI/ufxuUiBZoZe5ZfU7nMXk3sUV
	WO5z8Sb+kJsWN6GZIgRzaGExKgNyc2E2fR+3kAIAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 04434140006
X-Stat-Signature: fma7xyh4zs4di4q5rbsj9893uyryq8tb
X-HE-Tag: 1771913679-240031
X-HE-Meta: U2FsdGVkX1/bBvKH0sM60F0EIUO455gEb5XwrX7NiGnG4DPq8rF9HvC3furqkWqZ9kr5qBQQnaGXh0UEiyflNPTaAgfifhlPP6UQzNkWfeUft6dP3DaCNmQ6MG4YzrYsD2sWzMkKvxVb5Phoezwfv5AA1kbg2aZp8VHcDeisRk+1R6o5eRHti14ZUbYL3KdrU+nEiPX6DJ05ActD2iXRDhVMAMyx+3/qw3YHTKGrFnqPXbOhn6hvNbRYv4SH/8mkf0hBp4s+Ybym5qT15picpm1r+h5iCTSU7pmlDNPwI+2zau6MgHxFr0UQdsIuJV4exrwVzHpuYmZRCx9K3FJhrVcPJ3sbnCrGEj3cBnCKLpHUTBE8JRhf27SpLhT7rqxoQkk61w7QlNHCUAWFjwoZDEcpSlpiYok5Ro3ZZBEVPaAC/AP/KCIR8sd6xE87zZtns/Sn0xlnYxolafPq4TuN+J0Ok4TO4Q9HLNrRhd860w4ingFBHinM2BHNqfTaX1WjIKT04Fq9adU5VXrB8yYwMADps6iIpaSby671YFKzZg7xnWFX/3bEjR616w34aI2c9+IQfdBqEmbm4iSHnUQgNyOgsqUJBQhpiGl8SVn5cIkOgKKukBseqgMzZ5PDDM96uQh2EqzHZlHMc8Z7heXsnIsndDnXjOj1duYgpAAwKbr1koZm+rOXpRSwlGuIgA93dT5IUB1znxWwV30SbCq8QIxToiiRzrYXp+KD2QSB0wdmmUJl/AR2yUGLSavWZVMfXGcze7FVif3+MmcHuJea0j+AB3ykcQ0a0Un7Ngks44pF0bUYBec8oa3wmU3laYNgpeudfFxLvP7VDVGzzovbkkEKcvXrqOTWlPn+oKmhTlVu7QF89eeKHnx7cc9IVR4KMAbAJENULVH9ZptpUq3zHujdJESpY0NIrsnpMCL3W+6TX2gNwEuwI9X+F8+IphKgHu+UvuglvSXOY0pfdxF
 i1OXM/VN
 AXfHtdj+N/xiE+s1R0qT/hRSGDUBjMXt6YYv6W4it52/ZeXMqXqr9uoDpeWkI3PsxfO8y6zuXBlBdMt9dwqlSjE2+xqDOrAYrHInb/Z5IVxSU8F9k6AxSXmRWGg==
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
The original post was:

  https://lore.kernel.org/all/20251121040047.71921-1-byungchul@sk.com/

1/3 was covered by Pavel's patch:

  commit f0243d2b86b97 ("io_uring/zcrx: convert to use netmem_desc").

2/3 was taken by Jakub and merged:

  commit df59bb5b9af3f ("netmem, devmem, tcp: access pp fields through
  @desc in net_iov")

Now that io-uring and net core changes converge in one tree, I'm
resending the 3/3, which is what Jakub asked:

  https://lore.kernel.org/all/20251124184729.7e365941@kernel.org/
---
 include/net/netmem.h | 38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index a96b3e5e5574..a6d65ced5231 100644
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


