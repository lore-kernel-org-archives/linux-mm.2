Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEFFFC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59046B008C; Fri, 18 Sep 2026 08:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09F86B009B; Fri, 18 Sep 2026 08:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947216B009D; Fri, 18 Sep 2026 08:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C40B6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:08:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19DC7120641
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:08:25 +0000 (UTC)
X-FDA: 85226760570.02.EF002D0
Received: from mta0.migadu.com (out-159.mta0.migadu.com [91.218.175.159])
	by imf01.hostedemail.com (Postfix) with ESMTP id DEF0440004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:08:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W+p2LRty;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6Sc8d6TCv1Hiij+M19oHz2OIgibmXC/82dg97Yi2uY=;
	b=gQ+vLcsrGy+0O0JRUMb2INZcfv8gnflLTOIQVfBoq9FHTPI7mELs2m4FFlotkTCbg16IfX
	F7iZ6dbtHu6ksSPJB7w7l/MmovV1dRJZJaRZhUor/VWmNcvdNJEGF6V1lOgJpd8vsf6XGu
	4KvbjVo2sC5fpdDGxRSRw5Ji6C8guxg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733303;
	b=j5KmlFHX+WvjwhO0r7Gp5rtPU7OYX1LjcrrlexMly/RjOIVTr4Nlb6shzi6auel+Gkai2D
	RVJP/QmgqaNN/m0w/EHEitTS18+I5HGIx/g/TvGlzy+dXRqnU8gnSAmU8VvRyAOTsfsaBq
	ma+22jUjHHxX3VsTCt1fGP4GUDh/5D8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W+p2LRty;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.159 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e6Sc8d6TCv1Hiij+M19oHz2OIgibmXC/82dg97Yi2uY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789733301; v=1; x=1790338101;
 b=W+p2LRtyH0cD8luUar7ncxicH5z3+LEiL2RytsSSbPlZaL1AnSkNyXVEjUzCMVOMWrPV1IIo
 LNbNuMwZ/qDI5ZYoztb1ecqpYe/9mg/4YXOIrgJrkqTiPyp6Q8B7A+njv0eQ3KDHcMt2I/rzITp
 03etA0c0yf68ljwq0WJZ4SlU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id ac9122ca51626832;
	Fri, 18 Sep 2026 12:08:21 +0000
X-Mizu-Trace-ID: ac9122ca51626832
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/4] memcg: keep swap charging under RCU protection
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
Date: Fri, 18 Sep 2026 20:07:59 +0800
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
Message-Id: <CEA43253-5A6F-46EF-A7CF-645D5EC95E05@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: k5nzyq4b1ma4bb6rfo73t4p7brp9oeb6
X-Rspamd-Queue-Id: DEF0440004
X-HE-Tag: 1789733302-283635
X-HE-Meta: U2FsdGVkX1/pqDhiM2yueehH9cTGw6Ch480FHIxu07EeG+iYZoVmkyxLB/2SLWGgShCY9pbU11X9PDWw+HScHHfM37y4SfPdoOXfFBtibxMCZbkY6rKSfVWo9WhUOsS4CUW1svU2s1ECWNRrUYUxTd3t5gd/1jho6wA4qPzX4VcaJfuB2ubK2TWdZ44/tUuM/Ew5bGc+g2411Bl+WwKuG7nAQcm1clQPJ4YTRR5EDpqkfgkQRTKw6Ij6WRG71joLp/7VhEtbTMmD0F/rwOhU3oLCa6e779l+Pd+tDNzJ/ksxPZd92BEMvj8zWDQlGht7Rvyk8OvbLYYkTPqEZv6VgzoII8LqVBF2TmISl41334Y5i3CfNjot4dJkxeSKUmAsMWjqSn65j38qpJjc2g3wMli/oT9vbiCANTgcyuRAvBa+Xz6s7PzxUVjvi0T15GMi8BdCoWzLh/vg6WOu7HkmEwkiix9ei9/ZmWkSNUFmQcBr0pV5k3Z1vu7mMWCIE+z7oGXP4e6UPpdbJnXeGjr4UlwEgw0GWH4XGmtKsOOo+T/k6AtiRLA3o6Zz8/mw+zKTPxZUJ7zQ73mi6UFyrUunyXZi0ct6vUYRsgAQ89utgEukvCP+G7/pF0TtGHIpDkQMJ+hJGwL8E2av0ja+8KFzI3XhfHxDuSZNVHptQ566di9sF/SXzDL1EHjkhpwWMGjaEDHKhLqV+ME7R6i0jjN7habUseOkevPyVtdXq3g7w/NTmOqEiHp8JchqRdr43mrYIBAesmrcmX7q5ipCGbotaXVfXAgvNvbAC2drq590PhiMv9uSnBv0sTDoPoGh7y7ZNRwTO20989zMJ+m43gxNn5tQEYKsFD/d5zS5Bd+IoR7Ae6FOXPFH1wk1sKCmBWeHeX7J3N3iiKHmiCu/YdE9lAofluxwNVocdWavg6Qvbuuuinym37J7eNggqSIHDz6D22ings3upnibGYsX4fn
 +AgRLVUS
 wqZHacE616Ll3/uXIEs4wphtkmQ/xIUwmBifZKjnf90tgG3FDBQez7kPllMNga2n8IloYOQNtOsNdDZ5wJm/iHgSKH9+HesSsqHJb9mnYOJeIEq8xjJtztWdp0L3wNKMSHbKsshZVLLWeDLnw+BqiSBoOYp/IFKqIAcx6i671xcVl127y9/eJvn184qGIBpanMWmyn/+5ZdNNGlKejV14/qVP12BrKN07eGQjRARCIC0pdudAm/KDGcbiyfYTNzPEtRmV3J9S75HuLEjCOZyO4KauTgyheSKakSYIh8tsb/vITruLuAyCmjIZcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 18, 2026, at 17:18, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> This is a preparatory work for unbinding memcgid from memcg. No
> functional change.
>=20
> The swap charging path currently drops its RCU read lock after =
acquiring
> a private ID reference. This is safe because the ID reference pins the
> memcg's CSS.
>=20
> Moving private ID references to objcgs will remove that lifetime
> guarantee. Keep the RCU read lock held while accessing the memcg for
> counter charging, statistics and failure handling. (This matches what
> __memcg1_swapout() already does.).
>=20
> Save the private ID before dropping the RCU read lock, and use the =
saved
> value when recording the swap entry. The swap cluster locking remains
> outside the RCU read-side critical section.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


