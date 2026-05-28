Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C771CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B378C6B0005; Thu, 28 May 2026 03:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1AC6B0088; Thu, 28 May 2026 03:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989696B008A; Thu, 28 May 2026 03:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 851496B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:57:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EB7214071E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:57:49 +0000 (UTC)
X-FDA: 84816074658.02.7772638
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf20.hostedemail.com (Postfix) with ESMTP id B7FD01C0003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:57:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779955067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q91cpL+t5mN4xLdLsyeOw4a9kRHo4YYKKrYt3uKuKLY=;
	b=zovOPVfrBRzusyt8/fERqKTd3wE4aFOeadiD6xGodG4n2DZ9Z9kvJEGLvNZgh19YJAiLCV
	jWLwxs6k5qfBnt2VQ7b/f+Cg7e0rYrQNBLhLMcn2BaBgTgxuWhN8vLOt2Hfys2zDAUoYGs
	yxC/dRQk0cWj7MbCudOo/olTceGT2vQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779955067; a=rsa-sha256;
	cv=none;
	b=8NZP1ObX/mgtEXIgw9BpSrKzb5noRAdgdErmHLWygQHxezaTFyPz3niHN3LYMKxXlNjW4B
	M5DsgIbwPk7RKmkot3HRyMLkdZFS5psX0WGnNXU8gzr/iOPgg8X9y7atkxUyIyMy+HUw+Z
	cq82vgq3gP2QJobxHFIMhCXJo18OF7I=
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gQzM86sgQzYmnW2;
	Thu, 28 May 2026 15:56:04 +0800 (CST)
Received: from TA001.hihonor.com (10.77.210.32) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 28 May
 2026 15:57:41 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA001.hihonor.com
 (10.77.210.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 28 May
 2026 15:57:45 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 28 May 2026 15:57:31 +0800
From: wangtao <tao.wangtao@honor.com>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>,
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz"
	<jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "harry@kernel.org"
	<harry@kernel.org>, "jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com"
	<rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "ryncsn@gmail.com" <ryncsn@gmail.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "jparsana@google.com"
	<jparsana@google.com>, "dvander@google.com" <dvander@google.com>, zhangji
	<zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: RE: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Topic: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYhaeaAgAGnM1A=
Date: Thu, 28 May 2026 07:57:31 +0000
Message-ID: <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer>
In-Reply-To: <ahcANgFDFwfC0v1q@lucifer>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: jkhmpfsid7zqzp41tp4twyz8j7yn1m9s
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7FD01C0003
X-Rspam-User: 
X-HE-Tag: 1779955066-560643
X-HE-Meta: U2FsdGVkX18Sq8t8oOfXLICK9TUHugeqSr44FS/Eg0VHldfCayA9I0QXd9HBWiBC6ZxLx0GmMUb90ZWCj8itwuNPe3HKbevi2Iz4IkILpJAM0PDk1qH8sSYae/so1d7xZvWfLJxQMxR4dyeeEwAxR9aswje0fC8HrjrAke7ufjSRtcqpDUvg0WT2Jo9iet6SzghvDbb4kLZqpBuenr7RbDqc4t4JlqTMtl0bwtmUiRti8ZomGnSaibXo+63/mUIvOQPsNaVVR8gSwGZxXSAluMV4S5P3nCMdYZQtuDODYKOR+Mc7BO4Fry0pjFn09NhmbmkIeita5pKjIwjACFw9aefXC6yYJ31MSlm+aZ/jlY6X7ZaPMWRiD3rqMBL6Zf9kbFRVIkfsGxHFHg7Xz8VdlNX6HBBMLg91p5aw8KBNOxVDqk+/F2Rtn5AoVBMggeTsOlsibFu0Z8M97w/R14Mlm+ZpjFTSeNFpiD4P0TwirjTwkziuILwcCaAe05lj7zDFCReqU/qoZqesqHUaC3W/i/RVyDtwREgCfIEKujG4UVJwwEO1JvQ5qhRUrgYwnW5dfjnwAuIjiVgfL8AwhRoTr5/tZxs3inZNff7Z1cxWjOeVQN+VV+HwvJ3ao3wm0uq5V8JgxeKm8HbP9Kd1NViFW28HXc1b4ZwR/Ut5+s14KAo/h+LKBunnwpOgZMbdCGZFXuSHTtCWLOmJmaG7VG5VlI6FNBE07vNMZ+xfbO0Mkjp8z18l1Jrd97JbcvkDuagTap9v4+xF4HXVnM1UtCbdRRj932sZmQPGmYtg/oJIQVHznvCrhPXSYsAwlPsy3ghZJBWHSWdxgN1wmVxzRXhu2k6U3l++EAAVkcaygwYk2Cg3UsAzpCJidfMrdK/n+gL7PIXkPvKB4sgHIjC2F94BlPv6gVy4uT+XM5GFxHZRawt620NlRTKs9Ii/iXEurhf5JEhyv86dY8L7YE3MORM
 ipH5md7g
 JopAmnsRRCcspjJ2EHb9N14iOkNt1QAK+2tmXqX2aOYe9mOcnjSrgV0lCYTLFqXOq3h5z35SMErb/W3R7503d0yfUSj2NZaWOazVu7kxNZ7ZMih20vhVgb3kwDeihyLB5SsQNssTETlSCeyf9GBO9tqQeXrwMEeiIciEx/jPcDuN2OOmIrvHgGugEyZNuTCXaPsVoozYtlHPKwGM/1an+PeznnYomGiUGtdgs0HcUi9lL9JkTQ2r47I3A7oZbqI+WmyCN6VhejAZ18yvbv7vnUPnz4VP0BQKBFXGxToNH0El132rCg1Vphd8aqVyKW5Xo3RX8gw/hTpNPGyiQEoh7Tzj858OOXKKkBI97T5yF6MoCVTJuicouFVEWUnqxSNKOeiuT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred
> anon_vma creation
>=20
> OK I've had a look through more thoroughly now and:
>=20
> NAK and NAK any approach like this.
>=20
>=20
> Not only is this structurally all wrong, it does some insane stuff (pinni=
ng
> VMAs - no), the RCU usage is highly dubious and I suspect you've complete=
ly
> broken the anon rmap for things like migration, or have at least added ve=
ry
> dubious edge cases.
>=20
> You've added insane complexity, and also have failed to add even
> perfunctory tests, which is also totally unacceptable.
>=20
> The implementation is wrong, and the approach is wrong - we do not want t=
o
> extend or build on anon_vma. So this is unmergeable, or any approach like=
 it.
>=20
> I also, unfortunately, strongly suspect AI here. The turn of phrase, and =
poor
> commit messages, you doing this out of nowhere with absolutely no rmap
> experience before, your total lack of communication before.
>=20
> Claude puts the probability of heavy AI usage at 85-90%, and I'm pretty
> convinced. Either way it's utterly unmergeable but that you (likely) used=
 AI to
> generate this much work for us makes me actually pretty annoyed.
>=20
> As a result, I would strongly suggest you no longer submit patches for th=
e
> reverse mapping part of mm, as there is now a real lack of trust.
>=20
> If you wish to rebuild that, I suggest you _discuss_ concepts and ideas, =
e.g.
> send stuff on-list with a [DISCUSSION] tag, and engage with the community=
,
> and go from there.
>=20
> It's also important to synchronise - I'm working on an anon rmap replacem=
ent
> that I'm more than happy to discuss with you or anybody else which should
> achieve the same numbers in an architecturally sound way.
>=20
> You going off and, in a vacuum, generating a bunch of code with an
> unacceptable approach is not a civil way of engaging nor is it a good use=
 of
> your time, or maintainer time looking at it.
>=20
> Thanks, Lorenzo

Your email is very unfriendly. I hope you can point out the specific
problems so we can discuss how to solve them.

I am not good at English and need to use AI to translate commit
messages and comments. This reply email is also translated with AI.
However, the code is written by me. I do not know which AI you are
referring to, but the AI tools I use currently cannot effectively
write kernel code.


