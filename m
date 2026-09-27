Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48D7C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 10:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357836B0088; Sun, 27 Sep 2026 06:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307386B008A; Sun, 27 Sep 2026 06:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7666B008C; Sun, 27 Sep 2026 06:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA9DB6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 06:51:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59180A0A28
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:51:39 +0000 (UTC)
X-FDA: 85259226318.07.6C00221
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2FB7180002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:51:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i5d601uz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790506297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vTYwK/wvoIR3O8GrBIjGhV9ooIB1stkGBEkt4hT5EY=;
	b=4f4zgA/vteGL0KFr3MpUaHxa1AsA3NPyxE+He9ccZle0pTlENKK3RW/hmsEul38jV6E4TY
	U8vqpDU/WKksv5q/nW8nxjTPWUHYJG7c4fuDDPft0sSWVIkIZdQoO22xPpZbHbrjgCBMdk
	l33KPT9b4O00eUf9WuK1s9QnwjmaSnc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i5d601uz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790506297;
	b=wkJjUvcFFTshWYEhUmUe71F+nINWs7POyvNWy+NQmitcVhS3941lswPaL0cjQbiPGmzxS+
	/ifzjoWu+rakrOf856heuaXkyHvspcqhHQIDsnHYR12pAfED/q8y5Bm6bQT7l8mJZR9q9A
	il+DUiJf3b03pGmSzPx8PmgUQSJeeM0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1vTYwK/wvoIR3O8GrBIjGhV9ooIB1stkGBEkt4hT5EY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790506295; v=1; x=1791111095;
 b=i5d601uzeXfntEWeu5aEZKekL2SJaQ+BqNrPwfWm7tERCOIu/rBhChI/QbkHtvdYlkFIrfrW
 esa1G2NaW1Mxh0RtDEviIR0poJXlo+jyAix//Tf/xX4QVTSambMDqvTV5RBjxSljyAedn5RXPYe
 DkGy3aYx+H/ntzgLbcEE73yQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5500dc4e2682cac7;
	Sun, 27 Sep 2026 10:51:35 +0000
X-Mizu-Trace-ID: 5500dc4e2682cac7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 00/12] mm: Switch device DAX to section-based vmemmap
 optimization
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260926225105.a56f29d76b2f496c8dc2dac0@linux-foundation.org>
Date: Sun, 27 Sep 2026 18:51:15 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FB00943F-8DB1-4BEE-BF37-701785DE2DDE@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260926225105.a56f29d76b2f496c8dc2dac0@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspamd-Queue-Id: 2FB7180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4zk4wpmw1ug4sbeikd37tonx9g16ciso
X-HE-Tag: 1790506296-566497
X-HE-Meta: U2FsdGVkX187n3bxqO3ee//bj9lv6j9Th2KD2X1E42OKLvbTQa9NNL8PFp2QFzpo/T3bR1WP9GpGHhxJoFwT8jjH/+q6yqFHWq4o64s/98nIwm9IlcvBdE0phBUPkpmNStiTAWpsyJYxOmqmVc3Sc0zpLipn1orQfSZJsE1qJtewfcSjNNmVwQOAnEINwAC3L+CFJi2zvQAA1tZIke6loVYvzXLDgZAw6tkyRKRHz/ggF3WhpIiO2nwQTn8c8OgpkVaDYgNMZN1DcRT1g0gY8CT2/kTgaHmxfhSq0xTLvKmmL65o2QTOL+xYKHjV47uDshPIZFL+CvfGZA4m9qMvOwTNSqRMpCuKTRH5wonngmvUSy2NVv2oTyb7DCYQ3COc6wsBCnwol7tK9u7eGRblt3ZgETFkzV/+oxEDr82cyzZcuSPVVfO3emgr9MvyBc8GO7SltvTvkq2nqWg7clxrCOWNI9GWc0Nom7Fg+fWeiWnsEksJxggwDOdvymEZGGt7inTlRWmJ0+cjuJsq4+ZivAneSxEL+99wbVK8Wvm+kimppT8c2pfsyQPwqi42pGnTyrllAw7qLspZ1N0I2L4oVTVqpvyuCWT06wghXd5sAnk0Pv8LuyvsDGcCdDE/dmce03V5ZTF04yAQFjuNjub7oaE/lHRWwfwj5lNM1zJ3Cb3d8oYMKk9N5AZlPJcq0gGu0yg9YEl9j+WfHBSt18o2/DtMu2Nmn+HYMkUpLZYLHp90zFMoGGONfY4x7xYYbN2ksABhATccSqXjdZevoT5tMuIWAw9m6hR5TRwddnz1T9zSitOAAE13pKlmV/LMBFMNZf4NG1uplUVJsYAIobT4TM5/gx2AqD3T3Nq337SLmDvhx8Y/sHn2mzf1T3olEy5LmB9vV8+YS+HvNuPL9SL9mJrFnmfFUX4NG/YQtHsGxuwgvKu8SuEELMm3SnB1kXAR7Rooy9aq0JDmyxJwGy/
 G1YDKOoB
 BB1kqCS4WcwNVad5LERxtehAuYR883dloTD/q+7gu8eB2nFUMO343TuaN3PRjX+nhNuZH1XpQqf1CJ9XS5RAUeE5Z8qk2GmZ1mjtMd9l1X6P3kOwpuxiXfz56gHSufxYqIOpKMyaMnmSlXhF1vYfglMb+7xKqfi+ABAbydUMsvxiMToa96JX80J4Sg/tBQ3LkhvxOm1jZIvF5HqmB3SgDOQ7q+iij3q3oa1tPgw7XHhNwuCCn45I7WO3t9Inhh5dBXmzHh+9fCg3SD3nHsnb2mAahAh+7TfhdXtu3dHFmlQPKQTqT4uyv3zNHbXzfVS+FxPu/HYcib2SDOGJIAKv7ozoTjP5CUWuE1qntPhkIV+sZiyuMSrbRdY0RhSbUDBkq2WExHUDw0sA06DY0Ig5Vi3EtUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 27, 2026, at 13:51, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Sun, 27 Sep 2026 10:54:29 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> After the HugeTLB conversion, optimized vmemmap state is described by
>> the memory section and the sparse-vmemmap population path can =
allocate or
>> reuse shared tail vmemmap pages based on that metadata. Device DAX =
still
>> uses the older DAX-specific population model, including a separate =
tail
>> vmemmap page reservation and architecture-specific logic to locate or
>> populate reusable tail pages.
>>=20
>> This series makes device DAX use the same section-based model. Device =
DAX
>> records the compound page order from pgmap->vmemmap_shift in section
>> metadata before vmemmap population, uses the common per-zone shared =
tail
>> vmemmap page, and drops the extra reserved tail page. The powerpc =
radix
>> path is updated to use the same shared tail-page helper, so the =
generic
>> and powerpc DAX paths follow the same reservation model.
>=20
> Thanks, I've updated mm-unstable to this version.

Thanks.

>=20
> Sashiko asked a thing:
> =
https://sashiko.dev/#/patchset/20260927025441.741633-1-songmuchun@bytedanc=
e.com

Sashiko said page->refcount can overflow by incrementing it over 2.14 =
billion
times when mapping more than **524 TB** of DEV-DAX memory on a single =
NUMA
node, where the pages share the same node, order, and zone.

I am not aware of any practical hardware configuration approaching this
topology today.

Handling that theoretical limit would add non-trivial lifetime or
architecture-specific teardown complexity. Without a concrete hardware
requirement, I prefer not to over-engineer the current series. We can =
revisit
it when such a system or use case becomes realistic.

Thanks.


