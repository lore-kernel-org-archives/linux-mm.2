Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C73960A261E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X7naLAEK
Received: by kanga.kvack.org (Postfix)
	id 6FD2D6B00EF; Sun, 15 Nov 2026 17:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADE06B05B0; Sun, 15 Nov 2026 17:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59CBE6B05B1; Sun, 15 Nov 2026 17:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 274D46B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:34:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB2BE1C4142
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:47 +0000 (UTC)
X-FDA: 85438809414.09.E5FF0E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8A924140007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X7naLAEK;
	spf=pass (imf09.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794782085;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKFwJFQVkE1SOt4l66iLRKSuv0tZWR+rY8jCMRsdO8w=;
	b=Xz/Jk0ZXZcAkVN9rdFcN6uZKyZThR/UBZjX821dSTfnSXYmK5tuP2qidlznEPNcAQV/ST7
	jiyaLjfq9s9steOgKlXgzWUGN58Sekw+byxnqnAo7R2nSy6uWhC66FGGY/Z7wt74vmp4GH
	SNWiIcu3g3ATKH1V1MI7ptuN4iUbeoc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X7naLAEK;
	spf=pass (imf09.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794782085;
	b=hKYeJts2r4GySTcnG2MiEzT2NqT/4R2/G+aYTaUOknwE7OpEF281gJwJUvxui1L6TKgpC7
	GZ/bJwDY75JWNzPIV6JkKyRoIGxVOX0/8Lqd6f6U7HhSwEEpyBh1eMvijZwXhuiKn93PXU
	LlhCw9/qKFyHFy3G2Pq5TYQ0vW+kuzg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 697D241436;
	Sun, 15 Nov 2026 22:34:44 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794782084;
	b=FenyRT3yhU6b1N2AfqKt5Vr6MpoL0rHA5R1RVo1Xu3ggW+QVtiCjdHjkAvaFPt3WdgNZ
	 n78mgfIRbH7vjg7oBeyN8QmSJGxA0tCGpNgTwvGcFDVpqG2eqCMtn0Pzj4tKZ/u+9+weS
	 1tKuhc9L2JED/eCG7m5O+iSMI8b7KzmXZ4hu1k7XnA6oas/7U467/Rbh49tza08DDwEb8
	 r4/n2wAQNGwVVanuQ/6ynmJRSLFmRv+p30pRvP+BR750vmx0eOyPPoTwRzP6WzXeI15Do
	 XX48JbRlSEdUMnKOCNS0HQotNtDu/LTqX0dwWEq+yrVSySAWLU0B3yMijhBYve1Z10Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794782084;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=vKFwJFQVkE1SOt4l66iLRKSuv0tZWR+rY8jCMRsdO8w=;
	b=l3pw+h0Uyi+bZVAPv8toyZcnHUeRKgmFVcL8xrI65/IHWEpp1eqTUaXnHcCdQWGFPtMs
	 tnU8fB9l3XuPE7BJ+x2G/ZP9+0fZzc1CogN4Y36XdaZi5ggcbJuD7f+Bi1R1wehOdMkKM
	 wP2ptfXcMhBqGBzQhyOuv//XVdAycX5R1cbkeYeuwZucCG/CfN5G9MnHm6nAIUsZYUDAn
	 O9Nd9ZkopxscM2mwm2cfoaHjehvFVW79g268o+mGU72v6VcvjjAtOEBgpThOTuGNPLhPS
	 43T6wdgnGj7z5KxkQ9w3gIvwLPdoChrDP0PnsJ3WyaGLOhOBk4CQaP/7Fl1kD6XOgFA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BAEAF1F000C5;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794782084;
	bh=vKFwJFQVkE1SOt4l66iLRKSuv0tZWR+rY8jCMRsdO8w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=X7naLAEK6oirit7XszsuEpnhnwzUL+HlZXDoZ69WpabPeKtC+ge0LzI/oLPhciV7d
	 sjrCgAip+/R3jOWmfA8Tvp7WL35tswKNMSF82yH8FU2pRZQFGHzcl0ISwZ91bLzs45
	 a9KUFhpP2iIkyVY0HBKVEEppPmbXl+XytgE43KtboGz39SCw+nlprFAuL2N2Vu+LI5
	 ckb/mAB/T4w+XFzqbsM2cCJ5DlHJg1S+LFPVoUWqTCKoyBLJ19hK5/ebPBLzuQlLs2
	 U7NsE5x/Y10qD7OfY/hcGzZlRx2dALTroiE8S/Ik8R8rkJ6T03nX+EY/jiaB8XnXsd
	 9xZCpMUX1ZAOA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4B4D54A244;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Sun, 15 Nov 2026 22:34:41 +0000
Subject: [PATCH RFC nf-next 1/9] memcg: saturate deferred memory.high page
 debt
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261115-b4-nfqueue-memory-accounting-v1-1-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
To: netfilter-devel@vger.kernel.org, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
 Chris Down <chris@chrisdown.name>, 
 Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>, 
 cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794782082; l=2138;
 i=alireza@asgari.net; s=alireza-kernel; h=from:subject:message-id;
 bh=MFLqtuTtN7u8/DPQa2KEvRoRy7eP6Qdkj4IqlD51WpM=;
 b=m98I55EK5DDGlH5OD7HSN8CrjP52A8a7eITltlcAQqwelzQ/Ji/0VnlVZwsHX3oQHyR75mAWM
 RPrXccDRgy0DuW481S+kjEPQp4IqBc8At79t2aeJgNQhfDBRfENeSrn
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=wuQ0/M69FqoVnrCMUJ13EQCwrCwVjCrtz75k15vW8tw=
X-Endpoint-Received: by B4 Relay for alireza@asgari.net/alireza-kernel with
 auth_id=1055
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k5zjijc3qd1ce5hyfesh7xy3yxjarybh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8A924140007
X-HE-Tag: 1794782085-516738
X-HE-Meta: U2FsdGVkX1+tzAEJBsTjty1Bh+rrnbsZrUqZPgPo0l93NoW+ggQtk+Lw6Z4+qAp72ucG53Y8L7meezov0DBTDLKVI3bHX9KEc2td8cWLYx2fY3ZZm4EN676mGnkuG23FZJ3iYU24Um1GyQWb9wLM96NwEyCOGeL/64mK0WAl/E8oAPRXCLV8wUk1aQKLUvv+vNqlWo5wJ9Bae7U6ushANYRvxShJZaU/rhz/73FFqma0qATyqU5PScZUJZj+cVTu45jfOTmUwXsa3AdX8vbgO/sDCNc8dyEMQ+CQg0Ut8NIwJQPPzeYkvYqQTr7wrzfyjhE75YE5nt7Ci9ZTSPfUv8HbTEjfwgb5T0ijhKAUBTA8Lsna2fwqXPV/ylqImC5XvJvSF7u50GV7XgwFsB1JKwi/RdNeI6s6wtbuTAZwJu5icqNivk9DEM4QSxgpvRPQWgsT52VOwxbAln0AyG0rYeZ/xT5QiyX3/bIXN0pUPoMt9cmjN5Up4Azs3EgFnwbNZ0bRAqFaNqTXnH03jOG1T00rNM+JjOKoEsw9HFOtCcoYpqg/AzkVXI3AAHOClA9e9d9hKswuHOM0erWt/rb2DsaWiXfIqCxjYAMg7NRkc/6zMqscLWhc0bMs0GIGw+7ytfTc9dKXMAhfOZ9o66Ja2J0GdNTBJllur1ttLKdz+ZTvKv2ISvDQNRqlxGne5jJADuH54isn/xMM/bdzfYMXbuXqFhXl8NXXPPc1SN8y6cOG5AkT0y4zhUM2JSzGoQ3KdnMk7mV88nZFJEGFQJ2TZERXzy2NHjhdy3lgt0bV2ZTS/Aovu4cL3vnvYkQ219nqELmZO38uWJtCEQy5C3uVT7pWXh/EYSVWx7L0G4pPj1NB7yCqXkk6kGMGsyaWlqN7/KrViqoKoorR8pSZUpCfjz0UubF6qdcLviZUZkxUpi/zoE7S0NdDhx+TzQiXUV0wifNawDpQ1hGocaiYcqK
 nY00naCo
 mwG3u8hVR4nKbn+F9KLt452+TxQsbVta/ijF6uWGG7k/aEyKHy7iXTJ36igPUe+Zpw+bXappPBA/KMVY9npVCjDpa7Y5XHm+QlRKLESIgUw2z6Q7aQshb3oAoDNn9Ap87uoY4rs8+CGVnuU0fe6EdcIQUWURf3fg6D+PM+w13CbQ6VMEZ0YH+/dNypERTlUqp1ORWc5HRUSxr4yh0fr0Vb7Yc7DQqfx4o8sYR2tG7VTtaP70ZxF4e0gcDvUWx17GGfFu3G+u98OuM9oYoH3O5C/nDptrIQTBMn2WyZK5BIhsPJoYaqyEbbpDzLhzM6zQ9S0qBqyx2keHBvjLnszkyY97G312uniZv6A2N0lDdWww9QyD71G6DydtWF/W1Gu4wQh423wFzuJVOnq2lcz14GNNyy7DCr2bzH3kEeppKHTszEqYzjEr4QpvMk4Vx73gq1C8wVnYsBnDOWBqKmzP0XQOFCQC1eDJrTZY5LXJzD+GLg6URrgYDt6RiY9ipTfppEHKyoIdZ2FfDqQr2/+H07exERGWxI/nw9KGPFvMjgx6CD1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alireza Asgari <alireza@asgari.net>

Repeated nonblocking charges can accumulate deferred memory.high work
before the charging task returns to userspace. The unsigned-int page
counter can wrap, including to zero, and erase that pending work. Large
virtual capacity reservations can reach this range without allocating
corresponding physical memory, including on 64-bit kernels.

Saturate the addition at UINT_MAX. Ordinary additions retain their value;
very large debt retains the pressure signal instead of wrapping. This does
not change memory.max checks or promise exact debt beyond the saturation
point.

Found during AI-assisted source review of virtual capacity accounting.
The accompanying KUnit patch calls the real GFP_NOWAIT charging path with
an isolated counter fixture and a 65-page charge. It seeds debt near
UINT_MAX to cover exact-boundary, crossing, and already-saturated cases;
it does not allocate the corresponding large amount of physical memory.

The debt case passed on both 64-bit and 32-bit x86 KUnit kernels built
from this series. The test exercises the production charging and debt
update path; it does not reproduce end-to-end throttling.

Fixes: b23afb93d317 ("memcg: punt high overage reclaim to return-to-userland path")
Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 mm/memcontrol.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..1980fb7431a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2894,8 +2894,12 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			 * Target some best-effort fairness between the tasks,
 			 * and distribute reclaim work and delay penalties
 			 * based on how much each task is actually allocating.
+			 * Saturate so repeated nonblocking charges cannot erase
+			 * pending work by wrapping the counter back to zero.
 			 */
-			current->memcg_nr_pages_over_high += batch;
+			current->memcg_nr_pages_over_high += min(
+				batch,
+				UINT_MAX - current->memcg_nr_pages_over_high);
 			set_notify_resume(current);
 			break;
 		}

-- 
2.34.1



