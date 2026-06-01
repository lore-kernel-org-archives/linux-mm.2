Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB5ACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 01:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73DDB6B01A4; Sun, 31 May 2026 21:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7736B01A5; Sun, 31 May 2026 21:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58EC26B01A6; Sun, 31 May 2026 21:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43DC46B01A4
	for <linux-mm@kvack.org>; Sun, 31 May 2026 21:46:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6BC81A04B1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:46:21 +0000 (UTC)
X-FDA: 84829653762.05.12E14DC
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf15.hostedemail.com (Postfix) with ESMTP id 46562A0011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 01:46:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780278380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FkJk4eI44HDzOGZFIGth9gQlOvPgscM82zTqXXI4GkI=;
	b=Z8RPTPFSxa2r6iAnT8McJUJTq2eAwP3gqlVw3UjI3A5UQ2y0WDDDhDYf9fYJ3i6utgvCky
	5eXgmYRoBVSxwWJErkEJABraQ8fxYfGDHcrhRauM0XsqcB+dHZu5PkadDVl8hdttsUy9wH
	Q/9XK2sYqWCx1dDury9cHNcLl+tlrKM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780278380; a=rsa-sha256;
	cv=none;
	b=8X4tpCqCuz90oCaguwu9ii7QEiXEald0mz1yDuDYID8PMjSaANQd/bdZ9NbV0o3XSFGaT8
	aiZGEdcONFEzDk8ZOoBQV77i0SsYO7x1JiQlwzG+NdwnsrTG6IyoM2RxpdhtNWJ2IFmq9R
	hd9NAwn99tD9czbiUENIdtdFe2CCZK4=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gTGwg2flLzYvXcX;
	Mon,  1 Jun 2026 09:44:35 +0800 (CST)
Received: from TA006-1.hihonor.com (10.77.232.151) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Mon, 1 Jun
 2026 09:46:14 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA006-1.hihonor.com
 (10.77.232.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Jun
 2026 09:45:33 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Mon, 1 Jun 2026 09:46:14 +0800
From: wangtao <tao.wangtao@honor.com>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: Barry Song <baohua@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org"
	<david@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
	"luizcap@redhat.com" <luizcap@redhat.com>, "zhangjiao2@cmss.chinamobile.com"
	<zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>,
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn"
	<xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
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
	"jparsana@google.com" <jparsana@google.com>, "dvander@google.com"
	<dvander@google.com>, zhangji <zhangji1@honor.com>, wangzicheng
	<wangzicheng@honor.com>
Subject: RE: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Topic: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYhaeaAgAGnM1D//4FNAIABAA8AgAEgmrD//7GxAIAEjCKQ
Date: Mon, 1 Jun 2026 01:46:14 +0000
Message-ID: <a90bcb0fa3a044588350e92a78258a09@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer> <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com> <ahlzj--3Gm5pD9ge@lucifer>
In-Reply-To: <ahlzj--3Gm5pD9ge@lucifer>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: czijj6rwfqmx4riz58x6uemj1wtygjhi
X-Rspamd-Queue-Id: 46562A0011
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780278379-979394
X-HE-Meta: U2FsdGVkX1/vxFEJwrXwAtEFY3utCaOFiiyFvmvZ36tmG3tFxSnFaBNbbpn9S2zFhBZShZqGdlZRScbEl+Z6z8jXMnUuIX9B1kplvXANlFGWYEIZI1mJ4uyPWgh6F7fnTaAJqJ3K0InCyhqet3wFjoZ9L2GLU0UmHZUKW8lhtyfcAOfrFd86H/18nOXmvpYSOh0u8ffvTqFCCmhUay7xbKr+pYTNG1gGNBHI/gHCs+1gWZ9qXQFx9njBTefx+CAJJDy/I0wVbR0r6TWMlNPbX+W0xoxkIIT4FWcMBHtNLQZo0ZVZl8eIbaz9x3dNLod4LTMTmIio/C2ew+ocHqZ/nU8T2bhj3X4N3kJo8gXEmdx4Y0/JOQPXNos9+6Wpe7beQzvtK0bnu0KaW213RATBTIo6Fqy8r+bhFkLGaaOp+v6yIlNM8Aa9MCDxKhRQRNPAEM9numr5V0NaW2OLkyezFEZMIn8Rb7YNXKW02/p2bnDEizxEWUx3DKu7bB92+v//Oy6nzwEAMw6ijZc9wnfNHBwcGqB8u5DIesN80/O7qLhvKJE0KmQDvQyXiBTP4LkOkUqprMBaiHXXyXRjGi97oDxfonMx8zTnA5lIKCHrQqPup4re9IWX40AY8t6rTsK2qBcztejM68wBhhzqnATIloRAIXMd/tyY7JOd6nWr7mfRfc4ki0bSKKtOs5Xch4+HzZQdZMp30HPDyHY/ymHQngTg49eHoo11d4im+TO4Q3GNNAh7RgJFtN1Sx7GCUaala8s3ytFhX17gcRag4YrCR4t8Z9kidpCMzO2RyhQRW5zDYIboLDyQu4ClpLTU3TtrqMnnvSOOlMBAbsagCrAnl8DyIA5J8TDDe+ptaK8Mnn4GcEbtYAgsxC5CRbirRwETn9F6hjuIK4Sm4w55TCgAxtRnwg/L+SAf+3zvRmeQBG7rRDsw4cjc+Qi/tHgeA4WxoXsaFrN7IeMpE4jeDXx
 zrfYTy4J
 zS1DPProWWf7w1UTMTb7sMKFuOzKknJD+gbuvGAfe+NUUP3zY8NwKy4viq+Bja5gU+jxTp2+xRCP3Jb2owSt+vnHPvw4bHN9Gst44OwxqYaf5A0RissOtQ/HGTW/GlPX8WZ6vvJOhbEzi7jkHadkzD9qdxPVjRSjdnRye3ehnEfKQw2beOWDMh3t9HUUXj2AmlkS043YVUtNLie6ZgQZ7N/4BHl8ObqwhIG3+bdwfzQ1hPresVvsekHNmJP96MBj45yAtj7g6mgqCgfftZfMK5knClLMuMfXZkgjPuvFJLCIhTka33zeoXY/JokWXXuKUWy+3qHWS30qcCm4tYtMgwxVsk/Ngcerkf3OBiOEOySZJybkjtqgrP1Vq5EHtCNJH8brc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Previously, I also considered converting anon_vma's rb_tree to a
> > mapletree. If one entry records a single VMA, the average overhead
> > could be less than two longs per VMA.
> >
> > However, unlike rb_tree, mapletree does not support storing multiple
> > elements under a single key. The key would need to look like
> > (vma_id/mm_id + pgoff). On 32-bit platforms, since 64-bit mapletree
> > keys are not supported yet, the remaining
> > 12 bits are not enough for vma_id/mm_id.
> >
> > Because of this limitation, I later started thinking about ways to
> > reduce anon_vma allocations instead.
> >
> > I will try to find some time next week to analyze the cow-context
> > design and code more thoroughly, and then write up a summary.
>=20
> Tao,
>=20
> This response is so full of misunderstandings it's not really worth me
> responding to any of it. You've even hallucinated an imaginary field whic=
h is
> REALLY suspicious.
>=20
> You've no mm expertise or history and came up with this in a few hours. I
> asked Claude to analyse it and it puts it at 75-80% chance of being solel=
y LLM-
> generated from cow_context.c.
>=20
> I simply don't have the time to deal with this, so unfortunately I'm goin=
g to
> have to withdraw the suggestion of further discussion with you on this to=
pic.
>=20
> I am working on the scalable CoW project and will solicit opinions of tho=
se
> with relevant expertise.
>=20
> We are not interested in your approach or analysis.
>=20
> Thanks, Lorenzo

You said discussion was welcome, yet when someone offered even a =20
small comment, you refused to continue the discussion.

If I had known you would be this inconsistent, I would not have =20
replied to you in the first place.

This will be my last reply to you. I will not respond again.

Consider the following test case:
Process P creates 1000 VMAs with mmap, named vma_1, vma_2, ..., =20
vma_1000.

Then it forks child processes C_1, C_2, ..., C_1000. Each child =20
process C_k keeps only vma_k and munmaps all other vma_i.

With the current anon_vma, reclaim walking each page only needs =20
to handle two VMAs (vma_k in process P and vma_k in process C_k).

But under the CoW approach, reclaiming each page needs to walk =20
1000 processes, then spend O(log(#remap_entries)) time to check =20
whether a remap_entry exists, and then O(log(#vmas)) time to =20
locate the VMA.

Both the code complexity and the time complexity of the reverse =20
walk are much higher than the current anon_vma approach.
=20

