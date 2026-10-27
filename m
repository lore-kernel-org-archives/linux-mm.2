Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4073606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=1EphzHDe
Received: by kanga.kvack.org (Postfix)
	id 7B26F6B0671; Tue, 27 Oct 2026 05:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C226B0672; Tue, 27 Oct 2026 05:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604C96B0673; Tue, 27 Oct 2026 05:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C15A6B0671
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:46:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CEFE1A0930
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:46:19 +0000 (UTC)
X-FDA: 85367925678.28.7A9655F
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8401140005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:46:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1EphzHDe;
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rFiTxZOwo2VZms6MC4in4aJ0OzlRUdtTuBeNfB6VJY=;
	b=JuQO4KUtXxYJdzCThkz6oVwWOn9Ckm0Gdq86V0hD66HKiqzicFRUxY6iZApAGj3A5c8WCe
	az5ESA7SCZBVPraRuqfI9Mor+rHXi2CdxjJuJmoa0ZJIT85aHmft7RFNvtT+8aL8/AMsxk
	Bx29/tsRGDSFc9tHsdeEgCDM+ay6ORA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1EphzHDe;
	spf=pass (imf11.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094377;
	b=vC0FJH4DGWGiGwZY/CtsdyA+6EgHsPo+I1vfr/i0jEYA/0g8XP36wmYEpmZfZj/vLl1S1X
	csPeCDdZj0D6s/Hde1vDe/3bRpwb6+Hl0UwAUdjCqBIHQvWknx/7dnsOmB2DfXk9Ys3TT9
	wuMJZRj3As9sq2DYEftinKXhmGujHX0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8rFiTxZOwo2VZms6MC4in4aJ0OzlRUdtTuBeNfB6VJY=;
	b=1EphzHDeF8ps+FmTf91CAJlnqWNZeQB2cVJXv7phC/3EJX0PW9FKl2gAJj7pIQPi7hHXCOAyV
	uTKXDXw4ESSfViCv2NMmRVxFxxd4vcsvB6d629RjnQPxW9hiuWjib28DkDH+gruklD5rXLtOcgI
	inLVTEZl4FGJLWN+9hV+PYA=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jDQbx2w9gz1prky;
	Tue, 27 Oct 2026 17:46:05 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id E9E2E4058F;
	Tue, 27 Oct 2026 17:46:12 +0800 (CST)
Received: from [10.67.110.68] (10.67.110.68) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 27 Oct
 2026 17:46:12 +0800
Message-ID: <6e381f14-f00b-4c0d-8499-f5a5f37b2572@huawei.com>
Date: Tue, 27 Oct 2026 17:46:11 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/damon/reclaim: allow disabling watermarks to force
 reclaim of cold pages
To: SJ Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20261020135822.85334-1-sj@kernel.org>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20261020135822.85334-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8401140005
X-Stat-Signature: enmdoxpycede89ew6thyw8qcwcbbes8x
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793094376-780941
X-HE-Meta: U2FsdGVkX18xRyCbD75tXul3PFjPXgFc0lkkq+w8OoGrJkMI0jpLFfKlecxToMxLiQjD6HnxvcotNN6zdAEUG/9qFnsin95vQmS32rRRufRQtbKjrOeP4kg+08XFy3v0gTbRkM1E6KPgA2k4n4hDVWJ3fzvUevZBI2FnJZ5/xQOSrR0XVXlOkdfGFiUTLWKJq46ne5nDafimTRXE2RSlHAwNxb0Q24wpDtQID2lVFiQ0JE33rU1esCzlLYizlCuF1w1L0EUnkcDBlCG/yOE7CXBAG8uxRAis+3/qMVqbUrsIImVaOIz7zBzbJ1kfMMvcojtYmAU8eB/YsxEppuaUhWzV6BGR63Bp5u9y/bCtppq4o29sWHzslYsvPfQ2rE9Iud+fR0JUZV+hgaCYUOFtJnjcTQ6Yey4cEVgFw8nRluwPBWzJihpL0k/3SAkGdg9qzt5q7UP1FTZyO+qUurpiPmpnqEqrtRwXUQFO2pAkHSwM3asGZfJDa0PlZbCUAVJ4pNBd0EnZNDUdeDOVvRQwJLvOn83nfveoqNO4//8g9DrSZ3UGBp9/7UAGQ6j5CNeXmodid0O/bg8UM6csExA0NPLBxIh+lMVhxw2ANh8hT7AzHVHlicaHiB4hV16jjHPuJpcM0Y5wiVLYfDAZ4Nj94LikgyECesaTvmC1Zlattls+dxOneE2sx41pU5qmQHJ+O8NaKgA12+CheMXBK8C4rz7djmrAXBl7qytF9j67HdKGHAJXZjd0FVqH8PR8p8DqQOz0TqPg9M5ivq4U8I7S0xjUnSiSdFV1OHDRSEOuOXJBGKnSUha3PFztaimyFTt+gfvCJQ33fdhKu5c29agU6dz+Gty4h7QoN+RIXd/gzG32tLvMqPPv6BWSEqCTW9+Jd26FglVH7eF9FhhlZRgw39Shp6MCNThGK11JCfSSyB40QzXW4TdQwAJuQ8yElFGGt5cR6I2cfB9lK6nayps
 2BuFKd0I
 DUuZV/k1w50psfDYikMvCRyeH6ZGoA1lMWUNBAxcQc5NYzhhP+ptuI3ABAqbpb8t01XY/zsNnapTvcyERCIIJfRO4b5lXC6G9O3TndjjbM+YvmoAlR3ztPutofSee7s3J18ze0ZffLE8Ez7JsD20Y8vOFC4HyTDZJ3cPJS8P7E432jutc8Hv2f3i6BMQQkg6UvIt+lIq9/Kt46HvfWwbo0zPpjS8zjpXUqHYHl/ji6/4qf1O/jwy+fKqbyrTxVLP9tgo0g+Hg59kVXiPo8ZUpeedlAthGWKKfAS5WuIARHXI5HAqFdfYj/qRryiXzQ4RRfJc92OQ1WvwrFuBBvh37WDuZtPHdLeOcAMmaBW2/Ey0Hjd48fHyjBTjwUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/20 21:58, SJ Park 写道:
> Hello Jinjie,
> 
> On Tue, 20 Oct 2026 21:32:33 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> 
>> DAMON_RECLAIM runs its scheme only while the free memory rate is in
>> [wmarks_low, wmarks_mid].  Reclaiming cold pages raises the rate, so the
>> scheme self-stops as soon as memory looks plentiful again, which is wrong
>> for a VMM parking an idle sandbox that wants cold anonymous pages
>> reclaimed immediately.
>>
>> So add an ignore_wmarks module parameter. When set, the scheme uses
>> DAMOS_WMARK_NONE, so damos_wmark_wait_us() always returns zero and the
>> scheme stays active, bounded only by min_age and the quota.
> 
> I agree there could be use cases that doesn't want the watermarks at all.  I'd
> like to avoid adding new DAMON_RECLAIM parameters if possible, though.  That's
> becasuse DAMON_RECLAIM is introduced to let people use it without complicated
> setups.  We will of course add new parameters if really needed, but I want to
> see if there is a good alternative.
> 
> Have you considered some other alternatives?  For example, could respectively
> setting wmarks_high, wmarks_mid and wmarks_low to 100%, 100% and 0% effectively
> disable watermarks?  Have you tried that?  If that works, how about updating

Hi SJ,

Yes, it does for my use case.

> document to clearly explain the usage?  Also, have you considered using DAMON

Thank you! I will send a patch to update the doc later.

> sysfs interface instead of DAMON_RECLAIM?

DAMON sysfs can also do this with "none" watermarks. But I want the
simple DAMON_RECLAIM for only proactive reclam.

> 
> 
> Thanks,
> SJ
> 
> [...]

-- 
Best regards,
Jinjie


