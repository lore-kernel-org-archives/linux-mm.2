Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 164E4CFA448
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 04:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3756B002C; Thu, 20 Nov 2025 23:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA736B002E; Thu, 20 Nov 2025 23:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7F56B0030; Thu, 20 Nov 2025 23:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD926B002C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:01:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB5261A0199
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:01:02 +0000 (UTC)
X-FDA: 84133263564.04.C3007ED
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC367C0009
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:01:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763697661; a=rsa-sha256;
	cv=none;
	b=J70GZQWq27Kz5QqeJoKpAKOolgc6sEIgKJbdhAVRzNbvjgmka8pzTr9G69SMH48e1UrKao
	AB97YiT61CiDwafTw6KP6zy4nyNsSkrr9gjd48j8bPdp1zeYAY447+mfGluZUxVdyvGhFf
	eP7kk8HxeYZLlec2gShj43pyG/pSFXE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763697661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=ipa5ZAfxugTULlo8iHx1WjCSpMuoDe1nh2tnqvJpiNM=;
	b=Z2YroKa0JJr4hdBMujaeb0lzOhcqGhCeuwCv+2ntIjXAvK5M8Y/RaK8hgMqOzPMe4wPL8X
	nQw8U2z9VU5K8zP5MR+DwLiWJWiNdXTskL8slIpUBQOvB8LCGqPKzGytJUhJ83QO0OUlv0
	5s0LYuZJGPNlcRpe+MekvFShjfgB6ns=
X-AuditID: a67dfc5b-c2dff70000001609-6d-691fe3faf41f
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
Subject: [PATCH net-next 1/3] netmem, io_uring/zcrx: access pp fields through @desc in net_iov
Date: Fri, 21 Nov 2025 13:00:45 +0900
Message-Id: <20251121040047.71921-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsXC9ZZnke6vx/KZBku28lus/lFhsfzBDlaL
	n2ueM1nMWbWN0WL13X42iznnW1gsvq7/xWyxblcrk8XOXc8ZLV7NWMtm8fTYI3aL+8uesVjs
	ad/ObPGo/wSbxbvWcywWF7b1sVqcO7ySzWJ7wwN2i8u75rBZ3Fvzn9Xi5KyVLBYdd/ayWBxb
	IGbx7fQbRourM3cxWSy8E29x6fAjFovZjX2MFr9/ANXPPnqP3UHOY8vKm0we12ZMZPG4se8U
	k8fOWXfZPRZsKvXYvELL4/LZUo9NqzrZPDZ9msTusXPHZyaP3uZ3bB4fn95i8Xi/7yqbx5kF
	R9g9Pm+SC+CP4rJJSc3JLEst0rdL4MpoXvKDreALT0XP7ZNMDYynuboYOTkkBEwkVi5/wAhj
	f2tsZAex2QTUJW7c+MkMYosISEl83LEdKM7FwSywhlVi+YytYA3CAnESD38sAGtgEVCVWL92
	MRuIzStgKtGxZznUUHmJ1RsOMIM0SwgcY5d4+vMPG0RCUuLgihssExi5FzAyrGIUyswry03M
	zDHRy6jMy6zQS87P3cQIjK9ltX+idzB+uhB8iFGAg1GJh/cEp3ymEGtiWXFl7iFGCQ5mJRFe
	VUeZTCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8Rt/KU4QE0hNLUrNTUwtSi2CyTBycUg2MVpsu
	mxzp2FScyusT47rj7h/Jt9XWX17XSL5c+7j15fLtK1IiLjDMl6gXf+/YtTnnwISotbOcnslx
	bjywIe38p6+714bZn92puMN8S+K+Az17XwufMLLdpxGvspnPqaYrceVTBc3uzQGXeLt/qKTp
	XjSX13BcLrd/yxb2ks7y5eVdH8R/aq+3U2Ipzkg01GIuKk4EAKkE5lqrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAAwGRAm79CAMS/gMaCGludGVybmFsIgYKBApOO4Mt+uMfaTCOOjir+Hg4p+C4
	BTj5rOcCOJyqtgE4q92PBjicz4QEOPWv+gM4rrqFAji5uucBOOqYrQY45cbiBzjfpuYEOLyH
	twM44o/IBjjuhc4EOMOdyQU40LaOBTjOw6kGOLeA4Ac407qcBjjerP8FOMmaqQQ4iNy9BDjG
	oBY49svsATjVmboCOKHcXzjSw+IEOJuBjgE4+/icBjibxd4HQB9ItKnZAkjWmJEESNi+ygJI
	uZrdB0igsnVIs6gqSNPNdUiyqokGSLLykgdIubjzAkiNg+4GSPHl2gRI777VBkij6PACSMyg
	xAdI87IeUBBaCjxkZWxpdmVyLz5gCmiDpPgGcPQMeIzbyQKAAcsKigEJCBgQNBj2gYEHigEJ
	CAYQJxjY2PkDigEJCBQQGhjxuLcHigEKCAMQrAUYp5i1AYoBCQgTEF4Y4figB4oBCQgEECUY
	r62jBooBCQgNEDUYiLynAYoBCQgYEB8Yq7DAA5ABCKABAKoBFGludm1haWw1LnNraHluaXgu
	Y29tsgEGCgSmffyRuAH000fCARAIASIMDcgJH2kSBWF2c3ltwgEYCAMiFA0lQRxpEg1kYXl6
	ZXJvX3J1bGVzwgEbCAQiFw1KV2VgEhBnYXRla2VlcGVyX3J1bGVzwgECCAkagAEAuSxiYklG
	aIusnnStzTc8+QxM5e5ncem5ZVHeb2HzY8QvfOiwsiQCnYkGWFDtu8S2Ar5WHICr0h8eVG2M
	n0ylQba81grQiQi1FX7kvPun43q8VverMW7mqYosZAjnp9DMwqkK7//qyr366Oew1XhNs8kw
	HOSkVpsXN2KzXzeuHyIEc2hhMSoDcnNhp4l8S5ECAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: BC367C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: 76k66rpzzkjtkcrmcy5styhpt7rggxnc
X-Rspam-User: 
X-HE-Tag: 1763697660-850056
X-HE-Meta: U2FsdGVkX1/VMuhU4TPSRa+R0dROZ1d/ljrmxTXFQk4b8IeBEWshKXYxtDP+v2XG3GBEeI+cRMkfZr505FdVeE8I0Ecij3wGXY1x5mP53al3FkeDeoa5jqiGsDx4gThkiIfRGmvzEMbfGkEdAE6GmJ/sfUY9Vkm34nqB0cSvLsXVqhkGjmno4LGft43PRIK1S484G6/ub76GVBY6ORGhYUGlm9VHvJBZpBzAiQXn/zZ5rW5MpzLVbqvZR8lr8fGiOqG5IQX/F476fDciDyz6py1fFzEpdLXKJkLKKQAvi2+YC2NOLhhTwv9Z/PkbC1PhrIlzMVlOODccRUsIi6qBvFkxuJJLRqZaIcY8DYVdhUlieVADoMIrP06aTcfbSaXqx66SiVkkLNXGyhHtGQs2tcXTjBxYUlAvShldMw5G80GzlZoAzAoKdasP/DLg205H+rRZM8zv7VWBBV/VCCKgLFrYF4e+gbWEmNDq+IbTUJDkcT8vMs+Qseg/2LKLkDzat8l4jqykQF4sgCu/5RkGqvRcp2YjXRwz/GtlCJ3VeKM70RjUzgz3z/7RgaQ8N1OlqFgX0iwfIRA/X3vvVIQqutsoc7LZZ/XSNk7h6NTEHGw2AowSKyLwgt/damPn+ZNR1TkMe7MAvFbBl+ky0MVTnWlLOC9toYMOP6qDUHMbC5KyPe79qNwd6EfP/F85aLzXyIUwl43p+pyYqGmPiSEZj4jg4az5OU1MiQSCl+zMyfiYqdg8+H0wylMwyw8qNVL1msu39QmfH0rlsM56yDO3cYQwZ5mT9U6CbgVOvsR40MTtSqz9++1evb1kZ10VaQHaSw7Kum+AMPxfP/6xPPabLOwzP7ISTyyCqqi/x3rAkteZ+tfkneH8JtOQZhoJIObJiaTd30qkvi9JCm5ciXynJ5zcIiFvt7IJH6C5poy1XWV33aCY9+AwqmW9inklO16mjL3aYSHNWC31RXDD+k0
 db9QF3HQ
 NbTy+u8y9LeJ+5traDwM8j/Au4TADhMdxOzfdx3RTG6vz7FZTWyHtpJ/sqo62yxezUILuNtcTegDTX8WlUVXXf+AB6g==
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
 io_uring/zcrx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b1b723222cdb..f3ba04ce97ab 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -693,12 +693,12 @@ static void io_zcrx_return_niov(struct net_iov *niov)
 {
 	netmem_ref netmem = net_iov_to_netmem(niov);
 
-	if (!niov->pp) {
+	if (!niov->desc.pp) {
 		/* copy fallback allocated niovs */
 		io_zcrx_return_niov_freelist(niov);
 		return;
 	}
-	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
+	page_pool_put_unrefed_netmem(niov->desc.pp, netmem, -1, false);
 }
 
 static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
@@ -800,7 +800,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 		if (!page_pool_unref_and_test(netmem))
 			continue;
 
-		if (unlikely(niov->pp != pp)) {
+		if (unlikely(niov->desc.pp != pp)) {
 			io_zcrx_return_niov(niov);
 			continue;
 		}
@@ -1074,8 +1074,8 @@ static int io_zcrx_recv_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return io_zcrx_copy_frag(req, ifq, frag, off, len);
 
 	niov = netmem_to_net_iov(frag->netmem);
-	if (!niov->pp || niov->pp->mp_ops != &io_uring_pp_zc_ops ||
-	    io_pp_to_ifq(niov->pp) != ifq)
+	if (!niov->desc.pp || niov->desc.pp->mp_ops != &io_uring_pp_zc_ops ||
+	    io_pp_to_ifq(niov->desc.pp) != ifq)
 		return -EFAULT;
 
 	if (!io_zcrx_queue_cqe(req, niov, ifq, off + skb_frag_off(frag), len))
-- 
2.17.1


