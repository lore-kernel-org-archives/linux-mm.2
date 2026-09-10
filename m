Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D05C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537A76B0099; Thu, 10 Sep 2026 03:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6BB6B009B; Thu, 10 Sep 2026 03:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6466B009D; Thu, 10 Sep 2026 03:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD4E6B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:40:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4EA9FC0446
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:40:51 +0000 (UTC)
X-FDA: 85197055902.05.24B14D9
Received: from cu-gy11p00im-quki08141502.gy.silu.net (cu-gy11p00im-quki08141502.gy.silu.net [157.255.1.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C88314000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:40:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=ptKdMN9c;
	spf=pass (imf23.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.69 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+S2+q0H2kZtivapYxr37lzPiIeUPNhD/UThB0AKCqQ=;
	b=kSWaU5Yi6MEWQBlnns2tein9+ZBfO8Oxi8q+gwDID6i4iu8qNHK3Ur2oLDiCnre+G5djml
	w6JL962SkSC1cliv8iby1vxiN8l/+MiwnHxLYzT4ecfP7OaPj3lGr61KtKeQjVL0DHEaEl
	bmJdmVl7lPRsPPzMslXzJOjrnDYW80Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026049;
	b=QTtHkm80RnvNsmjUimVPN6sKMaXKiqGW2hpZpYuMtLpHKhJOU7IHyzJlZtzGcONei7t2NP
	os8gxJxINsPO+oy5e0QbijSyrx0L7AQEfePxQTnaKh+jUWixg5p0nsCEVUUJ9l7CyUFI7y
	uGrZ+OTGtEaLHpOoJB2C8Of1T/RXbbE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=ptKdMN9c;
	spf=pass (imf23.hostedemail.com: domain of bfguo@icloud.com designates 157.255.1.69 as permitted sender) smtp.mailfrom=bfguo@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from smtpclient.apple (gy11p00im-asmtpcmvip.gy.silu.net [112.19.199.76])
	by gy11p00im-quki08141502.gy.silu.net (Postfix) with ESMTPSA id C14033520061;
	Thu, 10 Sep 2026 07:40:35 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1789026045; x=1791618045; bh=i+S2+q0H2kZtivapYxr37lzPiIeUPNhD/UThB0AKCqQ=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=ptKdMN9clkgvLx5aqxhmlY85Af7XXZwJzegQ596jjP4/KRnDmc/rjUOcQPaZVcoo+ja05+UTGarIohIsLO7fY2jSa2dWzh1hZCSyMtSZe/G6DpCgELbYQzluNz6QlZDzo6Zb3Zo5gW6j7kdQgz3FFlIT8zlCak0NamK7Nk4YzDPxqDrxeX5R5H2hcDPLVIoD/hXCJ7tYx9LgDfpJuwJpkR+bEv/mV2vk7uX7al/2QaGgdc0MI43/zKAuRercX2kNYSB59dPpwMGClvhpg6Byk1NsPTu2PjY4MjGtudY7MZGx2OlYgHj7AARfFLqAj5p0LAQrK9i9riCfMyovj4yeSQ==
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v5] mm/memcg: clear folio memcg after changing per memcg
 stats
From: Bingfang Guo <bfguo@icloud.com>
In-Reply-To: <20260909225904.6d60c722ba21f26e18c98767@linux-foundation.org>
Date: Thu, 10 Sep 2026 15:40:23 +0800
Cc: bingfangguo@tencent.com,
 Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>,
 Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ACA7AFD8-432A-4F77-BEE1-64230F67B06A@icloud.com>
References: <20260910-memcg-swapcache-stats-fix-v5-1-033f510ba748@tencent.com>
 <20260909225904.6d60c722ba21f26e18c98767@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDA2NSBTYWx0ZWRfX3fnIBa6Z8kjj
 ZvTupFlHCm8I6c68kIn9HHOnmjMqGSdEoIJOci/j3Y26dfjB926gfwcrhgd/HO8PhwI7JHr6ToW
 qpasdvT1OAksSkYb83RA11WfMfapmwvn8Rlfg89MO6VBDOMpZ4L6Oo6gDl9IfFdmcoa51BonDWz
 yd8/NFOGUqKzFuyyPDGypM/DhO3XwZj9iBhgHu2d/2/RmR1Nonv6WyHNHNyyisDBnco1OahiVxQ
 rUu9YIjmeS2qV2nJ+U2NGc51l4fboro5inPoYa1IQg3Corp/uCXHUUXd6beM3Tp3XyYAL5OQEkv
 glxldHk9sqoehEKD9t9IEXFlBh+9H/MEnRN6C+ZcQ==
X-Proofpoint-ORIG-GUID: i5W5EbpEo-xfd81TvEJcl7e-9BUU7JuA
X-Proofpoint-GUID: i5W5EbpEo-xfd81TvEJcl7e-9BUU7JuA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 clxscore=-2147483648 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2609100065
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: up35kbxub7jbxtswhs7qks1jobbse4zy
X-Rspamd-Queue-Id: 2C88314000A
X-HE-Tag: 1789026049-699378
X-HE-Meta: U2FsdGVkX18flcP6H0woEHL3re/SDW/QDyh93dzwtnLLH2qAuhvUJKLHeGsFwV6YNMUB9kj45kw40UyMyMPflphxZ9BB6GUKE193LNT8N+ubK6XfW1nMtJ3JB70Kxm9sItd2c9qCRV9GJkz1RPN70V+i+4M2+yRYX0bOeGztqnMzr+A4F9W2T0bi+t2zORbb/IRjua3Z67dEPielUFNlR8NUzzEMVRO45YXPaytpA/KbOkTSf4cbKfgQhmNT8QB6UFEaLoDOGJWulkpEO6gna4KEwbpj4rEoZxFI45u88I2Y2pNcunHrpuMfvEltX7TUUF/wf8/763Z/7ZtNYzAeSt9VKGssBallW3m37NPTmmUXgVNc4+XqjOnTPvyqRjHLP4wyTuq7+Eq5NnuHvurxmvEuodW5pvlM08BU5w6P4M0lHO13P5EkjxHwkOpaTp2MMKGpG22dAKwUyTEsGmD2h9tVEL810Ln79giQIRKUPQqycRax9INNbKLRgOt/XhCVtBUafs3eParyYb2AHJlNTBd5s9SWX3iYq7rOX2n++0J0yzL4/xcaNszGf0gP0eJZ1cb+ZQt6OPSAa3Q6l3FOh3+oD0yonh5jmz3CeoGGYLW6CyBpUcOViefqLi04v2zf+yY6+wA1zvYJ+Lzo5awcWi/syvnC+tXVh9DgDu5dri0J5mm/xPrfP43iMeiYQXb92CP3UzrcJ/6MnxN/y8EvVBoNxCcHXLUX9PT52qm2VWA1rPy3Sw1ulkOMUMGPyNBOnM/UQoFOxaAF6AztNxSRA0/phDfOKU5YB5WKj5eIckzk7ALiKMLwWNjn0xmMRdB2UTiPKYkXGC9BCn7+xLbJ8FmTNqvLdsriZ29KG6RDGLjo5AGT5ENKvHZhFqTSJJ9galKQD8FPeYMSp58VwCB0a1jLrVGJPNNkNQClgPL0ygyVB8tJJpdh2b5wkI+fZ2KS7B+BuWLWE8xLK0DgG9B
 Z2FwvHmh
 Ecz3nAmvCCbEMcOsLTEiymtlaTRBSdgyGfTo+IWpL2eUL0cTA7/V/Fzu+BbU4mZO9kzpw8r0UD0rmZ5CXDRtOKQAysqxseobZWdrW+PgwNpj5wP01/tUtbgr5NwhHtZ+g5nTCkiKoFORiPCfZBExdV3QsNTbEgTvCvJF7GDDUp9zWvh2DMEFqvwrzZv0rQbrrYQmYiWP5TP4i5BY73bxg4t5Tn3PNZh3FuoHERAt7wNQePFBGHUwRaSthpyNF+7tLEbzVMCWxUP+SC3Nogkw/jNxxhscaoPdgy89LdJbri0+yDF4Jddmro/1YB4rSBO6PsjckccLhSFZ44IUWT0i2d9u5QAxHoq9x92/mrpRjvvt4CuUJpWRlt/U/+YJLxrzusOywcopXPRAsWphPuZ+aeQl9yXcT9b8Mz/Ye
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 10:59:04PM -0700, Andrew Morton wrote:
> On Thu, 10 Sep 2026 11:46:58 +0800 Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
>> I notice extremely high swapcached count in the per memcg level
>> memory.stat when running tests with cgroupv1 setup by swapping pages =
in
>> and out.  It seems that the counter never gets decreased so the value =
is
>> rather useless and confusing to users reading it. So I think fixing =
it
>> so that the value can reflect the actual swapcache usage correctly =
could
>> be helpful.
>>=20
>> __memcg1_swapout() transfers the memsw charge of a folio to its swap
>> entry and clears folio->memcg_data as part of that.  In the vmscan
>> swapout path it runs before __swap_cache_del_folio(), which then
>> decrements the swapcache stats through lruvec_stat_mod_folio().  =
Since
>> folio->memcg_data has already been cleared, folio_memcg() returns =
NULL
>> and the NR_SWAPCACHE decrement only updates the node-level counter
>> instead of the memcg's lruvec, leaking the per-memcg swapcache count.
>>=20
>> Move the __memcg1_swapout() call into __swap_cache_del_folio(), after
>> the NR_FILE_PAGES and NR_SWAPCACHE updates but before
>> __swap_cache_do_del_folio() removes the folio from the swap cache.  =
This
>> keeps the stats attributed to the folio's memcg while still recording
>> the swap cgroup with a valid folio->swap.  Add a swapout parameter so
>> the plain swap_cache_del_folio() path is left unchanged.
>=20
> Thanks.
>=20
>> Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in =
synchronize layer")
>=20
> January this year.
>=20
> How does this affect users?  Should we backport the fix into earlier
> kernels?  If so, why?
>=20

Thanks.

Users using swaps will read totally meaningless swapcache value
from per memcg memory.stat, like 200GB of swapcache on a 64GB
setup, which is quite confusing and may trigger monitoring
alerts, if any.

So I think we should backport this patch.  Although I don't
really know user space programs relying on this value to work, I
think it's always good to make sure that values provided by the
kernel are helpful and mean something.

Regards,
Bingfang


