Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E33C982F1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70EBE6B008C; Mon, 21 Sep 2026 03:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698286B00AD; Mon, 21 Sep 2026 03:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586D06B00BC; Mon, 21 Sep 2026 03:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 342006B008C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:00:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77EA61C2E7F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:00:36 +0000 (UTC)
X-FDA: 85236871272.19.71EFBC0
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 393301A0008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:00:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OTzlQF8x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789974034;
	b=riO3TMzr7LXWfvSQ057qPWaUWjZTSRpMBQm+DAkOefcXKr/7zVGu3qRuQLPccVNgVIKQfN
	aQz46p/rRq6k5t2Wvl3tL4G/LIDu3n0yzEI03XoDhTEedq1Ok92Au3eoj6zB4pXVvMYCKN
	HvI/kklnlDvYS2CD16MgY7eGIqQRWqc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OTzlQF8x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789974034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPQQeI11hH4PckQZB/pYVcI6ujYsUxyeXs7ziPpimwI=;
	b=Vwdy464SZG86eQsshXk3JfbSG/8jyMG9H+9kIyfEqUoYR65DEbBrevbVSjZ4yRm66G5ssV
	EyiGQFIc7KHr4hHoTeT8GkL72Qvj2exz/M72+OnQ7NGyv0R5DeIjRNhUZXCOaDYNWnkF08
	KR/dA0m/S2hQI6SJZD9LMwqQD83tW9U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Vbt4/5LAV2w0dL6pb/t0et3MVMocHRdRtbThpOXu98I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974032; v=1; x=1790578832;
 b=OTzlQF8x8c7RFKdIVcny1Yxlog8DnBk5TbMGtkcqgY2gJaRa5rRJdoj6aQi25QdyCHVt6DJv
 jq29wmrPJfp9t8oB2gIMD/34/SwjxTo40bMWkc6oTaQwAMI6xleqmA4OFA8GWomU+uwKq29V8py
 6F/1xK9046/Tgs52AeyiLFrE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id acb919ec4e2ec370;
	Mon, 21 Sep 2026 07:00:24 +0000
X-Mizu-Trace-ID: acb919ec4e2ec370
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2 4/4] memcg: move memcg private ID refcount to objcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260921-bingfangguo-memcgid-rework-v2-4-6c0637dc0edb@tencent.com>
Date: Mon, 21 Sep 2026 14:59:58 +0800
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
Message-Id: <59BF36D0-0328-4CFF-8DD6-DF73AF209118@linux.dev>
References: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
 <20260921-bingfangguo-memcgid-rework-v2-4-6c0637dc0edb@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 393301A0008
X-Stat-Signature: 5dfr6ghjd1cmmtg6346ewuxgwztpyr3r
X-HE-Tag: 1789974033-864780
X-HE-Meta: U2FsdGVkX18OsahPgKfSSE45SPi8cXEcfRUZj5nRbbLdL88H8wkvygLrmEBPi3joelcT35XFSA08K+txvWUBNiiHvlPRJsYutmIIz19VNBRUyIG94EvDlBgCCM/cqtTrA/G7FXcSGqq0xS4vIm3hRp1MUEDLXu6muzbxQGB4xz2ApLYXj5llRPhq/E20Gq7tgfQtVhDvjeHSkiUQdxspqS2zUF8ukNdj//C1cl3hwJtzxYMnIl74olqRCoj0w2IxX7w9YKvooUAy/dDQYrLjUoDGE9jlzGUC1JoDsdxHqvm1/GY2uDa7fvzcfEMlpPK+/d5qZDlRfLTJ9zfhfVWo5IEKivgnoBYLU0S0I+mKunAezSi0Kr738IVwGmf3SFCEfC8pNuoSxRgGN71doMXxFqO1TZwpVrIzekll61gVgzlnGorHkKP0HX97S892iEkp6FtrsHAOUmKrpBA+UJ44/N6pFE8niBJxe0lHc1cMbm/PQ6Q7yUJThS9KvpkOwdduY9velnKoChi6gK6HgapXMIniiv73Ihc+gyQQph9eKzYpJg7VKDdv3Lq9RAmQjloc/D+/K8vScPmGprG5G1H5gUu/2D1bv+FA0a9YQHToucDJefrqnDcHRMv1OrVF7uYjHe7vTURyPCddEbxNkIT5DDKPF9UxFwwtNm+xjqAdQfh6kYzEdPxfjzYYIr3mZ/XvdafqC87HMcfPp7TTBDRLONJ3zOtrJK94WlDEutG6SatKZfz/m2hgdrm5H80+UY4T8r1PgZZq9EAtmXwZQkkeMsw9VNNFxIKwo5lNkm0WhW8ex9jv+4kjhFB82w5Zh+YxQE3iR4lG+ScJHk426GapbofsR2dCdWwyo/vXgIjUh3AlVRenINPcTJrj3r426SyvWNXomRsF1X+su6upvcclrgjxRgcqUNgCHmPfilODJ+eyR2YM0hFlsszcyxAP9oZXF/SHiE0aAPhKiWHV24V
 NNm+QpMW
 RJ7HPKn8hqun+colpwAdZg4botoQtBb+N2kvTnojt3h3ut95Tb79Y6TblewaMQXq5Mf/8+w16ZfnzQ2VswnM4JJRbKMDl2kEBrPNXWlL+KvpZPE/PMp+GTcR5P/Kxaq1nxudJUNgAWIMDr+UQONdjJ52aiSElYwtowwVDBWuy2zKoy2572646kpmTfY2Rt35U3GCbdLqb/S2VmZwbQChMZ31wqs3aMKr2GcCwlvYlohuLLErk52q7/T+Bby35wiBiNIOk3Uah99i9QgdUSxzgqaHNCk/rY9PoOjJtv7WqZO2CZXgQHuD3RDnNwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 21, 2026, at 14:16, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> The memcg private ID is used by objects that can't afford storing a
> whole pointer and can outlive memcgs to track the memcg (notably swap
> entries). The current design holds a refcount to the css, preventing =
the
> memcg from being freed.
>=20
> This patch unbinds the lifetime of memcgid from the memcg so it can be
> freed.  The idea is to move the refcount of memcgid to one of the
> memcg's objcg. The objcg is stored in the global memcgid xarray =
instead
> and used for retrieving the online memcg from it.  So swapped out =
pages
> no longer pin the dying memcg.
>=20
> After the change, a memcgid can refer to a non present memcg. To =
handle
> this situation, when trying to get the original memcg from the id,
> compare the memcgid passed in with that of the memcg, and return NULL =
to
> indicate its death if they differ. NULL checks are added for
> list_lru_walk_node(), workingset_test_recent() to skip dead memcgs. =
For
> MGLRU recency test, mem_cgroup_lruvec() will substitute NULL with
> root_mem_cgroup.
>=20
> In the earlier patch, an extra xarray lookup was introduced in swap
> uncharging path.  Now that we have the objcg pointer in the function,
> the extra overhead can be removed by using it for putting directly.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


