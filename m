Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7EFC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96A06B017A; Wed, 12 Aug 2026 07:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48156B017B; Wed, 12 Aug 2026 07:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5DD66B017C; Wed, 12 Aug 2026 07:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 956106B017A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:55:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3307CA2600
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:55:48 +0000 (UTC)
X-FDA: 85092463176.09.CA9F85F
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCAECA0008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:55:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="UZXCLq/y";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786535745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J626iIP5lcL6sCZMWGegd3N1J6hQIGmxJ3j/621GkzE=;
	b=ydYFYPklicCVjSe0ZZHdSh6H3JZP76CKaV+OihAgjs+plBuQWKNumsFnf1fCQjIgM8fQG4
	grT9AkKXshb7tt6IgquKSo1xGioHYtYQ55swNKymQblXGIGrAtXBzPa8+EX13mHHgOmX/f
	fFY0q1KuA7/ERgXQDA6F/381CsL9ZwU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="UZXCLq/y";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786535745;
	b=zhRT01aeDwmJWkmYEMWCFz1SdH8gJMjWS1gIvqKPt+h6NOTQ/OM9Tm2GeQjrej6vW9yYj2
	zsb9uqiSl3d0M34/4HQQ3gg/CsYNzHpiHJwWpAiUfdEDSWQxsSggd/AZGQeMJ0PGNejT2u
	KHQo9IrWvD0e28a+FvphZXfSA1ht2dw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J626iIP5lcL6sCZMWGegd3N1J6hQIGmxJ3j/621GkzE=;
	b=UZXCLq/yqgj8b8A5fBWdkBJ09vRjF5+HotRt21OhKVcUt3XxsIcU7hCbvdMAQaFWeWU38p6oE
	39fDELgQdLSedykIoUEG6zqdap9Dc45eF0BSCgUwIj1vaZUYiE6TPARQ16844RnHKxecNRcDqxH
	T+vgoQS9CxJRpTaFf1Vwcq8=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hKmr95MgQz1prQc;
	Wed, 12 Aug 2026 19:44:57 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id E0C1540561;
	Wed, 12 Aug 2026 19:55:36 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 12 Aug 2026 19:55:35 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <ljs@kernel.org>, <david@kernel.org>, <rppt@kernel.org>
CC: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <bp@alien8.de>,
	<byungchul@sk.com>, <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
	<liam@infradead.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linmiaohe@huawei.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<matthew.brost@intel.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<rakie.kim@sk.com>, <surenb@google.com>, <tony.luck@intel.com>,
	<vbabka@kernel.org>, <xieyuanbin1@huawei.com>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if MEMORY_FAILURE is enabled
Date: Wed, 12 Aug 2026 19:55:29 +0800
Message-ID: <20260812115529.247548-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <anxOOiuSIL6tjufA@lucifer>
References: <anxOOiuSIL6tjufA@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Queue-Id: CCAECA0008
X-Rspamd-Server: rspam07
X-Stat-Signature: e66871kyj587u9bat76hft4ppqum417y
X-HE-Tag: 1786535743-470839
X-HE-Meta: U2FsdGVkX1+vDYx3XglzshWaL7eDfYqkSzvfQeA73TjFP425KWr/I83ge1MPsOZQi0XG+mliCyibpTgl36okUKyTVrJPjIVcem/+eRzwvMbHYmivYyE/tJqNYR/+0RCdtl66R+XDcF5E6OixT38iv+x8Q+aMZ42LTpoDEYTyzd+aLccFhkoTSVsy/HNYiaZuSXbuu7hnXnFm/NJZtFKovlmlpzhgckbuMdPnkU0ReWHEmKlkIvpDi24iLEGRv+rd2SdUHvkh16pZ6ovPWQiwWIHly3whOzlqT+pjYFViH8/uhBeHYsIOU3m0J/Xb8JuFguRXfD5AvWKlnVnzdcx+XN36D2tolsHp4gEYEcBciR5X4sNZpYz5UIUx36fBXDB7pTCd/1/YlhIaDm3hqbGkmPFCycyrNzUXpj6EceI7chwM+CAA5SfQaikQtTLBHD5KWmxt+bx6cP8sgaIWfyPRo1CEi0Y59GERsmOTFHmu+90LIoZ8lYVQCpGPhyGSfx2woq+u2QEqhG7j1LP8UnoqHcC1N5TfBDe93ghd01ygIE5ik0AolIs3R98Q7O3PCAkeXfnXHAMzdU/2/k1SPYBQ9g06IOYd3egpHrMUeuSbdoTQp0p26K91aoXJnkQSKwzUYyUvq+JWypATs7KkDoa2R34o0js6z8JGIQv+Urdd2V/5y5FYKxTFtjXh7ldlD45SAySJs2dfCJapHjo8vRnS5i32fnHxEg+9N4YB0dFIa8GghBFdvEAzgrLYqWkNjNecYQ+6bdPT8FuEiCDEIp1Ije0NZtiYkMvQEFhlyQ/hKgWz5ENkqyGMSznEq+sUSa1Dvo3VWu/vfbx88+8YR+T8FWU2aJIRBafXYA50ffrBj29f7UY7MEH3sBtjIKZXiLjKy7S5WH1daIyY3qdxVLOUD5xWibZdqGmGqnIWOnAatSLozBUBSDONP+oy540AJJG/sVgHTMsDr0+BE1KZ7b9
 Czck/ooS
 UqB9uLk0OgsHGMgoNabC0xNXTo9duaj0oOyk9uvkEirJTt7h+5F0iNzW8iOjverkObCUTTlndoqpQRFtLRL2lVY+AJFnyrqMu1uhiNU0bbQ79IeRgD2dGdezd/DziUp/mVCasvBheew05s+NFIERQlfaa4je4fTULH+HjMEJSOSVSJed3jR08RQTAJ1yu2gGys2+YPv3X9pwIzKtuTbMcKK9MOQkJASoFl9T6UqWyM0g1gWKDQk6UFC9mccqNjOcL+n5O+rNDvTZHjgxWvNcTl59Em/g0GiVOFEBBxhisPXuhZNHaUxxPzB40Nmq9Jwm3qxDRgICmKdtmrtTUyeMShDjLwisIJJv9Yj1ZiQ5b9aJoTiheiIeRY77Noaj3BwoQNtrTJUVEIZnedA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 11:53:29 +0100, Lorenzo Stoakes (ARM) wrote:
> But you seem to be implying the two options cannot both be enabled, that's
> untrue:
>
> $ grep CONFIG_MIGRATION .config
> CONFIG_MIGRATION=y
> $ grep CONFIG_MEMORY_FAILURE .config
> CONFIG_MEMORY_FAILURE=y
>
> Have you disabled compaction somehow?
>
> It sounds like your .config is broken and... you need to fix it yourself not
> edit mm/Kconfig?
>
> If not you need to spell out exactly what config it is you have where you must
> not have one of the things that select migration, but do want it anyway.
>
> I'm not sure we'd even support that?
>
> Right now:
>
>	CONFIG_COMPACTION (!)
>	CONFIG_MEMORY_HOTREMOVE
>	CONFIG_NUMA_MIGRATION
>	CONFIG_CMA
>
> All select CONFIG_MIGRATION. Why is it that you cannot select one of these?

As you say, currently, MEMORY_FAILURE and MIGRATION can be both
enabled, however, you must enable one of the following configs
at the same time:
	CONFIG_COMPACTION
	CONFIG_MEMORY_HOTREMOVE
	CONFIG_NUMA_MIGRATION
	CONFIG_CMA

However, for embedded devices, these configs are not always enabled, and
they can indeed be manually disable. This is the actual situation I am
currently encountering.

> What
> weird config needs CONFIG_COMPACTION disabled but does want migration just for
> soft offline debugging?

It is not for debugging, but a real configuration in the production environment:
	CONFIG_COMPACTION=n
	CONFIG_MEMORY_HOTREMOVE=n
	CONFIG_NUMA=n
	CONFIG_CMA=n
	CONFIG_MEMORY_FAILURE=y

> Users shouldn't select this at all. And this is an absolutely horrible way of
> resolving whatever your real configuration issue is.
>
> I hate hate hate this. This is just completely the wrong resolution.

What abort making MEMORY_FAILURE select MIGRATION, just like what Mike
Rapoport said? If it's not appropriate no matter what, then let's stop
discussing this patch as if it was never submitted. I'm sorry about that.

Thanks very much.

