Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60122C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 16:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24AE6B00B5; Fri,  3 Jul 2026 12:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD926B00B6; Fri,  3 Jul 2026 12:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13076B00B7; Fri,  3 Jul 2026 12:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF7E6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:37:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A3041201FD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:37:55 +0000 (UTC)
X-FDA: 84948022110.14.CFD1AFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 40AB7C0007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:37:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FALyA88g;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783096673;
	b=5jkIh0nAVBjrU/zUEQVHN2vkHeZw6TPEa3sgJZU7Yy2N4Oahj9hdIcp03M8XxeLXZ73euf
	dC2qdDrAw0gxA+4AKf9BEyI5oF9Ri1U8kWJfFlPMzX+coGNK47dqAnjH+Ul1fi4yxdawYp
	Ow7CjrBu37u07yUM5WVJ1s6Lhc86HtE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783096673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfgOhtUqXakhO/LJCSQi+Xtir7lK29w0aDyR77catJ8=;
	b=7CnklHJoCHLkNiBWw8rfOypQOyWUMmutaFNN7c2LRv6ECXrBDVw69F2ScU2niNHuhn1pSX
	rwPz3XX07ZKblQQ2ezreTjUrFqKt6dlfwzFHAMkXphR/dDteRzfc2zwdCbX2PZSmXFUo4j
	/iQ90kH4JN6geCOC2JQdcadOKntdIqE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FALyA88g;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6A254064C;
	Fri,  3 Jul 2026 16:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8721F000E9;
	Fri,  3 Jul 2026 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096671;
	bh=sfgOhtUqXakhO/LJCSQi+Xtir7lK29w0aDyR77catJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FALyA88glPg893RXkoN9RTJO/MOwhlJg9JAvwHpslsw8oc/saSVG40yzlCTjD4DYW
	 pt2IRfk2i6zJBeIR0AOCP+1jWUbxQBrkTCz05/JpyoMmFMv6wjaD5nYDf6KPOBtSgm
	 nWs/kLSZwQ10zcUApI0QmTcyMVwg0KkwN/pga2/AvWdb+udqLdoYSPp7bHsBLnFTzI
	 +97XvOfKuIwa9aFsrLmJ5Sk9vJ0i8LKy0YU8jF08PMgvLXmsHxf7mYXVoDbSiWnaDJ
	 4NPQseUUiIW89u9P5QrZHDh85nHAlBZiao71tU+rK/Z1fiB2hxsBC9pFhkjUtniCWq
	 lmozENbGnPi4g==
From: SJ Park <sj@kernel.org>
To: wang lian <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 0/5] mm/damon: add mTHP collapse and split actions
Date: Fri,  3 Jul 2026 09:37:35 -0700
Message-ID: <20260703163737.84760-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <F1C05416-5D04-4568-B8CD-D4376B0F3848@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 40AB7C0007
X-Stat-Signature: 5cjtbkw75ymq8orcu49sicqhf9tw9yri
X-HE-Tag: 1783096673-800385
X-HE-Meta: U2FsdGVkX1/Re1A0MgTyQgLEj9UG7+alT0XoSxLppvBLPH0rb8zMz64xIl9oXu95IiZWa0IJoV2P3Pc4rLcPx4fc0fvHfsgXj3IcGE9oZ8UgPK2af8d2uGoMyHNXZ1QNOz4zQrhqoBIZz3UhWLnaUHHa63lFy8ArP13I69ERgX3+USFdAEPt0IiI65qyEPxSwK1rNyEnyT8U2GLHOsETdV2Hx6OP3kxMyUeu/5HC+heHj8sXv2CQX5H5sgpFRtnVtVkj6JtNXcyqDvcu3qBu00kP98AJ6ZKxNYJqvPPhHFjVFNTwCFNp5tBc8exHbsntTYO+DByLiAhVtEevJzgq7GOejdUz3LsFeNbhbf5QGlCiDqqpMP5HANV+2CajSeT9E9dKVyiXk+yDaJN/D0hcNXxqxcmNQOFdQoADq/UEcB8kla2bV+JDHTpSy7zckf8sdS2EFyfCvQ7+kt978pofjusSxKBsEvsJLvg/HJwwjAQkQXAVk7bYzEAjWwtMbdE8vTRiA8AXMULK+ccjrrHqGx6LwIUNSLOTnYxJmEJY1owxkKEw0Ejt3Ac9vqmXd/x8Ot/frzb2D9T9U2R1lfaCewIAlhI9MRZiYeSCtgfT289+4V28NFjdB3+aJO5Fj/wBFX1P5GI7UjMMdkXebDMI9YuoPRin9kRZLDurRGsX3Lo608Hui8o5AZDh/YmHa64+fhs+hwet1lTa9+ZuoxsAOo5jeNpoVbpGqy4Pv8r9P6nAjYT84hUgaPTh5wr9ZNYk16CfVGGP5cL/oJRlAWtDPH/qdZwl0vJJ4+PZeG0fU2tuH25VMgN2mF94vShwOTHEpAt94K2vHo4TTWc3riykJnl6bqNEfgqHFcROVRbEBun8m/M05+d8XtNzQAXJ/cGK2EqIiPS++1WXJZ10AoUQ/kMai8h8xgvXUbnQk+dQICDJrUlTmNAMl6If4L+pw6OVznnYlOcVCbDLzG8BWtx
 brJmDIXm
 djPuHm76ieyNvC17crtQIfDg09wXt/l+2oT/4Cc1VJ2vOm+7a959KDqBvnAsyzmws63P6Hr78LbZtdchPVm10hV6yO/zfMyBn+1uZ9tRMH5hrSjZybXx5I3gf+jnxd7fX2SfssjEAKVPe7yW7HIvpByk72TMYyzmAoyKHb7EsTmLna8j5R8J+ko2M75AyZ2EFxMZ3hQVKJ7o3j2hVPo2rQpdeUPP7W1TWWxwQzbBveyRDypruaxG4gF7tt2OKDNA53XIK9GS4uGEyCruRQ31YySvd7qXOfmSWsdYx3ivej9wX2nlJCYnuCWOLK2qG/tpSnUYQVUiWY/x/eWNNwX+DPGtzejFEQVBD11nFpC5tLzCzkN6exff5s6sekXzYibQ93X0diqqK4/uZ0CYdBXaQlvR8LI+sH5GGSBuEludiQrPt1z+I9AQJ7hOQ7sFPlLB6zIDk2fWPm18qjVfHvGR53BztwSvyGrl/TpV8j1NI8wbG8Q5IfsEa5G2IxHK6zRAybAMVEWahQeK+CoaWkvzjDPmT95YH5+eZzlf+RszIkyHTgQf2iib8l4lDjMAL2jwGovgwDQcxgxbXF5nYexUn5eogNH9DLsXq1aXDFpowCyqizss49pXZuQbBCL2G/C1brqNOVcsbaER6suzkTmnwyWCAWlf/ZFodpDGhIuip3kvAsUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Jul 2026 09:10:51 +0800 wang lian <lianux.mm@gmail.com> wrote:

> Hi,Lorenzo
> 
> > On Jul 2, 2026, at 18:23, Lorenzo Stoakes <ljs@kernel.org> wrote:
> > 
> > +cc all those you missed.
> > 
> > I really need to write a bot to do this, because I'm getting a little tired of
> > pointing this out :))
> > 
> > On Thu, Jul 02, 2026 at 05:46:28PM +0800, Lian Wang wrote:
> >> include/linux/damon.h      |  10 +++
> >> include/linux/khugepaged.h |   9 +++
> >> mm/damon/core.c            |   2 +
> >> mm/damon/sysfs-schemes.c   |  77 ++++++++++++++++++++++
> >> mm/damon/vaddr.c           | 128 +++++++++++++++++++++++++++++++++++++
> >> mm/khugepaged.c            |  46 +++++++++++++
> >> 6 files changed, 272 insertions(+)
> > 
> > You are doing damon changes, and that belongs to SJ, sure.
> > 
> > But you're also changing core THP code? Please ensure you cc- THP people because
> > without our approval this cannot be merged:
> > 
> > $ scripts/get_maintainer.pl 20260702094633.75658-1-lianux.mm@gmail.com.mbx <mailto:20260702094633.75658-1-lianux.mm@gmail.com.mbx>
> > SJ Park <sj@kernel.org <mailto:sj@kernel.org>> (maintainer:DAMON)
> > Andrew Morton <akpm@linux-foundation.org <mailto:akpm@linux-foundation.org>> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > David Hildenbrand <david@kernel.org <mailto:david@kernel.org>> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > Lorenzo Stoakes <ljs@kernel.org <mailto:ljs@kernel.org>> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > Zi Yan <ziy@nvidia.com <mailto:ziy@nvidia.com>> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > Baolin Wang <baolin.wang@linux.alibaba.com <mailto:baolin.wang@linux.alibaba.com>> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > "Liam R. Howlett" <liam@infradead.org <mailto:liam@infradead.org>> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > Nico Pache <npache@redhat.com <mailto:npache@redhat.com>> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > Ryan Roberts <ryan.roberts@arm.com <mailto:ryan.roberts@arm.com>> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > Dev Jain <dev.jain@arm.com <mailto:dev.jain@arm.com>> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > Barry Song <baohua@kernel.org <mailto:baohua@kernel.org>> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > Lance Yang <lance.yang@linux.dev <mailto:lance.yang@linux.dev>> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
> > damon@lists.linux.dev <mailto:damon@lists.linux.dev> (open list:DAMON)
> > linux-mm@kvack.org <mailto:linux-mm@kvack.org> (open list:DAMON)
> > linux-kernel@vger.kernel.org <mailto:linux-kernel@vger.kernel.org> (open list)
> > 
> >> 
> >> --
> >> 2.50.1 (Apple Git-155)
> >> 
> > 
> 
> Thank you for pointing this out again, and I deeply appreciate all the tedious 
> work you do as a maintainer to keep the mailing lists aligned. 
> 
> As a newcomer trying to transition into complex feature development, I must 
> admit my initial design is far from perfect. I leveraged AI tools to assist 
> with certain implementation paths, and although I extensively self-reviewed, 
> tested, and reasoned through every single line of code, your and SJ's 
> feedback clearly shows there are still major architectural flaws. Just like my 
> very first kernel patch—which was strictly reviewed and guided by you and David H. 
> —I know that your sharp feedback is exactly what will help me grow as a kernel engineer.
> 
> I will completely step back and radically rethink the design of this series, 
> especially regarding the cross-subsystem encapsulation and locking hazards. 

No worries, take your time :)

> 
> As for that bot you mentioned getting tired of running manually—let me write 
> it for you. An imperfect newcomer who just made these exact mistakes knows 
> precisely where the traps are. I can craft a pre-flight patch check script or 
> a CI bot that automatically validates the `get_maintainer.pl` output against 
> the patch file diffstat before any email is dispatched, throwing a loud warning 
> if core MM files are touched but their respective maintainers are missing from 
> the CC line. 
> 
> What do you think? I would love to build this tool to save your and other 
> maintainers' valuable time in the future.

Sounds great!  hkml already has all building blocks for doing the check, so I'm
planning to develop such checks in hkml, but only for manual runs.  I ain't
develop and run a bot, since I don't have that much compute resource.  Maybe
you could save your time by reusing the hkml feature on your bot.


Thanks,
SJ

[...]

