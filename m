Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB3FC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 12:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294656B0088; Sat,  5 Sep 2026 08:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E236B008A; Sat,  5 Sep 2026 08:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E95B6B008C; Sat,  5 Sep 2026 08:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB8386B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 08:18:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 597E0140307
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:18:40 +0000 (UTC)
X-FDA: 85179612000.25.C1DD7F3
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27EEE180002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:18:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQkaeJ+R;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788610718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1YHEtlFxeW1JAj93QPioNAWZLnUiFynMKdhLIIArRs=;
	b=uDcjryJLM7W6KFnsxkgWHoaOiLGHx+YaORyw/Ngo9ctueideRTr1HuZttZoLmOzOwDqj/z
	6aKHa7BK1L2agZJSVe/EOX4DBlvxjKNyWZlFKsq3c+7v5IYrL3y2vMA87Cjqc6jmQsFix8
	WqdOzUnjb4WiucyAy29VmeHBIbxgY4Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mQkaeJ+R;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788610718;
	b=JZ1u6ez+g8ZmhRhCtR1bTJForS7UMydv/kGy0PLMKZu9nFvCqAB4GJlrvXP7lE96e/T2c3
	MKJoqmaPyG9KCWK8MFpGk7+bz7TpxvXrD8IZGD/cJvn8vLpH4YvkcgR2H99aer07cwYLDa
	Ysz8cxZbNan0U1rQu6RbnkzQN/xl8H0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ySkuT1pGEsfWYtaDY+C44/DFGOfxtIvjurzCYJAaaQE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788610716; v=1; x=1789215516;
 b=mQkaeJ+Ru1jBnLEKNvofl9iKMEqOqeWxneOId2uofPFFUrfOziGHTNyciHTMHWWBg8A5sUfK
 0Rn0I/MZJY82eJK3JfUJPFCbecRlT3WegZdFndHolumtLnfUkxX3kCUGuwvt+EZBHVFfWt/9eb3
 bUrzcsFHHYqy/YeJRNC/wV3c=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b1c979f2108c0cd3;
	Sat, 05 Sep 2026 12:18:26 +0000
X-Mizu-Trace-ID: b1c979f2108c0cd3
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH RFC v2 6/6] mm/memcg: filter out reparented memcgs got
 from memcgid
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
Date: Sat, 5 Sep 2026 20:18:03 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Bingfang Guo <bfguo@icloud.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3F681C23-8462-4BA3-B3C6-B7A45A9341DE@linux.dev>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: jo1e4howfhh8n8usj3g4o3ie6qe55nig
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 27EEE180002
X-Rspam-User: 
X-HE-Tag: 1788610717-391233
X-HE-Meta: U2FsdGVkX19VHKBiosZa3c6b+JgG8Aq06iD/UrmgYgI+jMBqE0TmZ+2uaEk+ocBCB3ufZG+Y+u+/SFDjpomBch2fDtEWPhDqlU8dB8uNnG0twUCDIRKkJgq4ZEmkwyj7rpaWIjhKahQINvgMJ44303jFZmWhbEn3Koqfi1mbFyyi5aGTHd7QulmmsEgmmNV0p6VHjCoBDqGZ2vv+E0WaxEarSQ7gDoG8Q0c6Ua8c0Gp1jXlULS1OndPP3ktu4x9D9dKofjQusC++m29pfgwXKHGN8ooRPwrroJHWY9IpYAddvFugBsd2Z5OYV1qmw5yZ/Cl75FnW9rqOHNC7X+TVpcpHgpzhVcE2KP0LsdmzyrAdWwmg/vJ3S2F9AZlzCgSiPlOj+s3ki/JBSQNvAz4bhvbVf8V4/qjH3tprUPIXecW5bw2+uO9z+J+uvhJ2C0BSSbM9g2zoDWPjrcAcD3kDZ9Y+8GLrmwSyG/O1IOZNcEo17Il2watpFQpxwjOnc4PkLMRnr25At+6CCORnPCnVcuaRdZVLZnlL8YJ6fgwlmmYOfD/xJdicMRsOuvwjDdnL7wwZr50eudyTpLyYmvxLB92Ww/XPJKmJ4EGHshWRioozy6+2tnM5uBBAh86yKnOPQfajl+MzLKZlvt7g4fRaHDW/fYxQd5VZquLKAj7P7Odnv1s4qwtETt+xVSGv3okuwTFWQZsKPsPFtgYeInDZ7uqJkc1xyPhURxbrOWgPt6J2nL3j+H4T3pNdLOgX4DBzNJjcAOyST3deMptPCv1zEM54TdoHO3ThME3ihOcFOXuArOkcozF6ZdkkdfNPoWineGfea+ttC402NAz3TPmE7l+SC5YpXOWo18ZlztM2IW+EFC7JpJ+TaKOQparZA7knIgp2efpbx9Tn0946qGzqy64IyfK9JQ6PkuTewWgy++dnw3LP9mG7uXLNY6eDFHKqed0E0bOlRKmu6O5anRI
 dQhXKyxg
 6aITKGtiFrO8WKrtQTd/6aEngfJhlKLOUrH5z3jMoxhvrZDPDd3efuVPPi9pn0oi3AtkkrsbRrM4o0achfiz7MYdYmcSDr2A4uflD10yREWP+PwDwK+xMjF23ub7QleSs+S6ak1JFKlxdymi7Uo65xzWCUUdtN0vB2cSZrLokREHlIlbjeE9boyHIDYTJAhh53vJ+6dFbqp1s6v4n4/19lWuh9lcbmv0Sxp4e0L+P5pdhZZ6ob/NkPqKIuVyksFB3fWbW9KH9bhon105ZALLFGDLN/qy91NHcW9rR++flsgmhBjo2vcOTIP0AauoFePCNkvnJw10L6DAjA3QZBelDhEIR/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 1, 2026, at 16:58, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> mem_cgroup_from_private_id() looks up the objcg that owns the id and
> returns the objcg's current memcg.  After reparenting, that memcg can
> differ from the one the id originally belonged to.
>=20
> Callers such as the list lru and workingset refault code expect to get
> back exactly the memcg referred to by the memcgid, so check that the
> returned memcg still owns the id and return NULL otherwise. In this
> case, make list_lru just skip and workingset tests use the root (as =
the
> comments said in workingset.c:460).
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

We should move this patch earlier to avoid introducing the problem first
and then fixing it later.

Muchun,
Thanks.


