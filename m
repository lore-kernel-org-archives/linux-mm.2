Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29AFC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0AB6B009B; Wed,  9 Sep 2026 08:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96D56B009D; Wed,  9 Sep 2026 08:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DADF86B009E; Wed,  9 Sep 2026 08:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCC6C6B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:49:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E79DA3E6E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:49:24 +0000 (UTC)
X-FDA: 85194204648.19.D9F12E8
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1D8821C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:49:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aOkZ9Z/z";
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788958162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gwmrN2mYyNJNdILxjJwJqhCmxOdcDqPQvJ3lpVAOlP8=;
	b=w92CDk2nw1JO2XxsRZx5PEMJITJivqZwAIQ+HSw76GOaKs4LHEpGwwZyymOBdJ8PLnAkDY
	4xSoqpWX5amrBTmoLqrrqRyTwRbb5TIMd6HQlNGmNgN465+PJR76c1hrWimj2ZXWjhODNZ
	MVTxXL8ywM6BbY6xagCl+ORHYFmxejk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788958162;
	b=uVPOEPzlXpOP6vL9v84BQv5Iafa1BwXWrNM+jl48asg7fRTuttNr+M8XlTaikBeP7R99uY
	76C7azLFnwa5En5V6Z/dvOTo9cgSpKwR60xRY5chPoWWez92lWfsKhIPPs+NDB569nCVlZ
	OAHhYE34nVjLF6/nIF7G2Ogru7hKhhY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aOkZ9Z/z";
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dGY2NR/veKXrwGFTi9kg06zDcIsbympO6hwDTaiEiaE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788958160; v=1; x=1789562960;
 b=aOkZ9Z/zGmBqs7CdSYi5drnM+J5UqK0Ra3AufNX/c8+yJZoMoPmiWDQNfQjJrn/MruH9lnMe
 pRnvQadvv89PNRdnKDErmd/bUCQomm/Wd3Se4xf44lUzqMNcxX9fpvHSzDN9beS2L58mlOKmwex
 yDSBYP9IWkx+ZqHB+SDN7uMI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d526acdc7f8e315a;
	Wed, 09 Sep 2026 12:49:19 +0000
X-Mizu-Trace-ID: d526acdc7f8e315a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v5 04/17] mm/sparse-vmemmap: initialize shared tail
 vmemmap pages on allocation
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <f57dd255-9468-4280-8a7d-c262147e4645@kernel.org>
Date: Wed, 9 Sep 2026 20:49:02 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C544ED19-39C8-46BC-B716-259D0C732AB4@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-5-songmuchun@bytedance.com>
 <f57dd255-9468-4280-8a7d-c262147e4645@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Stat-Signature: ai3i1bexmecz8owbama493fzszqhzoxs
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D8821C0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1788958161-713823
X-HE-Meta: U2FsdGVkX1/dlrQiHCMbwKdtz7Mp3VnxmdKo2kavbDgktMseWI0c6pN5P/HsCsx1wRePQ793HAITex6AdfTM7eeGgK2R0C6+K3bmtaTLAU1jAYUfnqfe2koQC+72Jqy9YS+VVOjcOOcROiBf/u7WXYa/7+ZD0yHi6aUXcfKOYr/VfeV3PRpGLvSfIKeyg95gl+Y0KLSYPXT41M4OZSaTEBY2eliRsZVB4v3DC+nHKPETEvhE1z7DQ+R55jLjbCHVr0tpaLsOvmZDknw8us0fzYaAyhuxdVg/5S5fxLkCqDlYIJ5pXiJGerwK6+1h0flqZtxHU1ft6JpUVOb66JHGLpXvMUhJXS0VgYbr6LHNA880vABnQ86lVHYe5BuNJRA1H0iOm9avJJmEvczaaFBePdODKv9SDfnx1XElFzzHSVxOLUBDmlqAGu3Q+qRO/jxyoOC0fUnAVu1GTbJEGNBXX1eP/ss53LarffqPqRucEIXzxpMro1K2b/Itw/wi+Qhx4eq6DftorkoPd56JJ0qdr6v5tkqAiyyb7+uQFtcA9oF7xHEufQehZOq5XhSl1P9Ll7ENtLaxHZiBbkMQaLgfQZokNO0t7CuRzwwOcMRYUGH8nxaj2YpSTRBqucftfitEwAw2Bxy543dEa/pphDpeGLj4H7m++qrq37mlBh80HAUO0q5Zr+RrmjGAR5HT+MwCNFbbUTAeN1ID4K9j1NlK18xoVeX/zM+J+JFcOPOCBHBeRb/ak6R5LQg1w0m2gZehKopuALAWplXZ4CUn8sv70AygbcSgt6yudhgWBmE7/9/5cmCMR1t/19aUdWJn7q8cAVgRgvWJGSLokThvnmaWZDEye5j/DszLgm0IC2jWNBwGfr6V5+TsGlJ4v0Isg7SlEQKomahUql0l+t83UslPrH/AJhCU0TMBjpBTUcflyAR1SmMLwsGZJYuGFbBwQbsIB4/FF6cGM8b0gZuyrqp
 fgQ/Uqb5
 ZxBnl57Jk5rxp4rNOVC7qHj8f930XUvagdrs8Zg0TplOvEzm0h+QMeB45PhtjhyiR0LQLe4xnSx/3zvmg8ru04eHTtMVVy0IJaDo5+uCI+iXt7v554Lg9GZ+HMDB5U/fN3MdpYzdcpeREGrhnhil/6hunQvSTX09i8FURbhLh/goQ22GVGYja87EpYiL57BqnHQBO54XiCKyAW0dOdorHMeP2d5tuxjT4tWbOItQfvD68rySEnYOx+wqRb1sLsFu6S0GOib7mHThKmhWC/qt04uPdEmRVi512EgYQ5c7Jw9qcLFsaAc2shHut0ol8gZ0aPZNRe8Aq2deCf0qG6GMFZutC77TwFcmFF5OnLuW6PbBjNrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2026, at 17:39, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 8/25/26 10:45, Muchun Song wrote:
>> The shared tail vmemmap page allocated in vmemmap_get_tail() used to =
be
>> left uninitialized, because memmap_init_range() would later overwrite
>> it.  That forced users such as HugeTLB to defer the initialization to
>> their own setup paths.
>>=20
>> Now that memmap_init_range() skips shared tail vmemmap pages, =
initialize
>> them immediately in vmemmap_get_tail() with init_compound_tail()
>> instead.
>>=20
>> This moves the initialization to the point where the shared tail page =
is
>=20
> You are not really moving the initialization? I see a new =
initialization being
> added but none getting removed.
>=20
> Wouldn't hugetlb_bootmem_struct_page_init() have to be updated as well =
(as the
> comment you are changing indicates) or what am I missing?

Strictly speaking, this patch adds initialization rather than removing =
it.

I used "moves" from a logical perspective: the initialization =
responsibility
now shifts to the allocation point (vmemmap_get_tail()), making the =
HugeTLB
side redundant. But since this is a preparatory patch (the section order =
field
isn't set yet, so the skip logic introduced in patch 3 doesn't take =
effect =E2=80=94
meaning the tail page would still be overwritten in =
memmap_init_range()), the
old code cannot be removed yet. It is cleaned up in the follow-up once =
the
switch is complete.

Thanks,
Muchun

>=20
> --
> Cheers,
>=20
> David


