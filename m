Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2CF5CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 06:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C03026B0005; Thu, 28 May 2026 02:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3DD6B0088; Thu, 28 May 2026 02:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6096B008A; Thu, 28 May 2026 02:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A17B46B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:45:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29EE61A0792
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:45:17 +0000 (UTC)
X-FDA: 84815891874.29.9DF9214
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4B63EA0017
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:45:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf25.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779950715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ot6OpxNNyOBX4pLscljD46ptWQMXAD5xf9iVqPL3Rhs=;
	b=jEyr6lOe3W+/vZIJpWMHU/yuTZJJG4CuVMcA0HgV1I8TO4ltycsR1M3H0cD7dOdXn6Pgiu
	RVc+ojF84O/mYbMy7Sogrnq2Od9A0+OIkbScN7Se98+ijNCRlQi+VR9xjxOpevSgAF1zq+
	65zLb9PvbzvwSU2A58rKE7IT68Tkk/4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf25.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779950715; a=rsa-sha256;
	cv=none;
	b=aev7Y6lyYHqL7h9f1RRDVFQbBWCMqxugiq6CWd5emxn13rNdM4DI9P0Jbsen/Dyb4V0izD
	X7MB8LXLGbFsGysWmXy966QzUYx5FbZx8S4KCvGnDZGQgkVvOkyvOJHZOTS0zxvxSdBPaa
	uzuQNdjVz3zMcRemEJZjmr99cu5Fp2M=
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQxld3QdDzYnVHF;
	Thu, 28 May 2026 14:43:41 +0800 (CST)
Received: from TA005-1.hihonor.com (10.77.216.68) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 28 May
 2026 14:45:04 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA005-1.hihonor.com
 (10.77.216.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 28 May
 2026 14:45:05 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 28 May 2026 14:45:07 +0800
From: wangtao <tao.wangtao@honor.com>
To: Pedro Falcato <pfalcato@suse.de>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>,
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
	"kas@kernel.org" <kas@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>,
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
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com"
	<rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
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
Thread-Index: AQHc7cjw5r5ki6LAJ0S2mW/rJEfblbYhNMwAgAHH2gA=
Date: Thu, 28 May 2026 06:45:07 +0000
Message-ID: <800d894e9a54440fa1d7f7b76e50a45b@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahbSwczOpsBKby7o@pedro-suse>
In-Reply-To: <ahbSwczOpsBKby7o@pedro-suse>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B63EA0017
X-Stat-Signature: 9ztohbu4pgh3edyi79s7qu8jf96gewho
X-HE-Tag: 1779950714-707857
X-HE-Meta: U2FsdGVkX18onNmoUQQlfRHdg7WrfpvZY2X6UnNEWT+bEqxmks9dqHyLQE3eJpSxw3HVtd+Zg8Bh9LOPKEHQ0pCgnwn6ku3SFiuuF1bQu1ETxf1suni8T6Ye4ssRphHGed3tFfL7j02KquBibdGioSCoKK1VvIeg1FvlH6i8eZF+EPcSdI6fU+iFmhf1ZFYD8arfCkoTU4lV7aLHU94zumWVtJfeLlMgldEp2ibV+EKRu5GXB3pDoMSQW2jhws33XNS8bZkMYaTnKQXKxl08/tm1dJvuYt1jfSRICRaYOb5fH5g7gIKfZwKYjLirdq7buuAPXFsBbzOHyVezoA5ZNZPzFaCr5+DjrkoP3EBF0MJ2MTUo69d3cqIKsDD3MB0MZCTxT4P4y8AbV90//PlGoMDc4Y3U+QYTSsek2JPoN2/MuOrUy8qGwDwZmQrtxyf7qBF/7Ifds6w+oizcwyRPrSxyTq1vlDPL72s7FqqNJ72vTuQN34A4+FNJYbkc5O68s6KAcvHlow9hqA0Efrv/9Jm+RV0GXkbmMcj1yqhsTJyTnK3zBjDb+OlEUIYc1s3xSjbLEkxtxkK3vwC++QkzBE2uO9v1YxuhyjbNwliGz/UH83zIp10FS6pTuZX6qAKUHnqNR+OFwkjCPE1GJCZOa/p1jWNQuUpNJgc0ydJv7eWZRziEeeHXjorAbjZoUBRIDzMvDiFNXqwVJTy00W6JWVLbnTo2Atoor+X6m9Nkm2K5RNWdaAf2oIwj/Ae5Gi0vfGnkvP3pSzmIe2WF8XgMEghq5+nGkJFHHZoI4S4qvyfhFvfT/x8D0e51nuzJn9p4hvB8JWCkuHKEyPGQiu/9nJ3eJrmJasF0eNWJOQ0DEpfEY+B5uac0EITzhp+M8YnHp1arugUxRAj+K8ulQG4FjiY3s/mKCbfrIZ3B3dpcB9fFkC90kTUfS2uxrXRqRHpWcFD29mTa1fcSzLY94X+
 OBOoFW/Q
 ONRpFBdlltIR9/O2l/9qzj21OukViED8l4W+ZoiCe+AgrnXyK6d6H9F4qeWozfHZl7f0fU2nzqe5jFMa287JRs/N+HfA9tNesxTha7mwcVC6uvDU/pI1QABp57i3k4uMnoecrfrhUxUQQNr3EosVJB3RksLzwYn74BMB22ULwqng8P1njYClf6h3kg1Xb/Ol86OfhCqurVN//qQ2OtkoXT3tfULbZ2DQowWV9x08RBie/iFjgNAYqialJ1WHmjVAaeWrrk2K7OWC9AVjXGIwRYpnFQvPa6/lZFUoxGddVV/ZW1HvQuLykcgss+AKeDj3KrYC/y8t9fpmpWG6Bj9rvwkBakewqSNobue8Ynt+dH0vyvvtv0trdWUTCkEg98ECWMMUW7avAVrAuSFpQA/mCvpNc2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > Feedback and suggestions are welcome.
>=20
> I'm afraid, per previous discussions[1], that no one is really willing to=
 maintain
> extra complexity for the current state of anon rmap and anon vmas.
> Sorry :/
>=20
> Also, please don't send series this large without previous discussion and=
 _at
> least_ an RFC tag.
>=20
> [1] https://lore.kernel.org/all/aec533b2-37a7-4f44-a279-
> c4aa604206ac@lucifer.local/
>=20
> --
> Pedro

Thank you very much for your reply.

As I am not very good at english, I haven't participated much in community =
discussions before and I'm still not very familiar with the usual process.
I realize now that I should probably have started with a discussion thread =
first, and that this patch series would have been more appropriate with an =
RFC tag.=20
I apologize for that.

I will read the discussion in [1] more carefully. I also noticed the relate=
d code here:
https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=3Dproj=
ect/cow-context

Many years ago I had already noticed that data structures such as vma, page=
_table, and anon_vma consume a significant amount of memory.
However, since the mm subsystem is quite complex, I didn't look into it in =
depth at the time.
Recently, with memory costs increasing, I revisited these structures and an=
alyzed their memory usage again.=20
Since anon_vma seems to have a relatively smaller impact compared to vma an=
d page tables, I started by exploring possible optimizations for anon_vma f=
irst.

Although anon_vma is relatively simple, there are still quite a few uncerta=
inties.
So I waited until the basic functionality was implemented before sending th=
e patches for discussion.

Thanks again for taking the time to reply.

--
Tao


