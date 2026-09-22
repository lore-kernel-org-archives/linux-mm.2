Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3DC8C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A40496B00A4; Tue, 22 Sep 2026 02:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17F36B00A5; Tue, 22 Sep 2026 02:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954E36B00AF; Tue, 22 Sep 2026 02:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 771A16B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:31:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFD58403CD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:31:37 +0000 (UTC)
X-FDA: 85240427034.29.E67405D
Received: from mta1.migadu.com (out-153.mta1.migadu.com [95.215.58.153])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4BACF40002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:31:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oAYNnPDU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790058696;
	b=slGni+ZbgFVwrIvd1M+uBRXEHvDNwxZaFxYPVWCIM+ybDiI0XYYLJSrIReLjChWLqjKNCa
	rXxkVGZ7VAcDp5UBaxG1dcOnFKcuxirhFiUBchYAhnlkKVfgoRRlT1LbJsgBdY6LHtnwJL
	ojLZFYVV4jsM4Yyos0c87ePg6igJgi8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oAYNnPDU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.153 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790058696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WT7L+yjgB0IaOTyJkUQuzdzCWldIgXpJyxmwqVKairA=;
	b=ZlIO7TiUZUwszZCQ8zkuwf3qEQxRAEfY4R9NhEvt9BDjqHVGLq+t7Qitvl8CN89b9d85AI
	E8Y2TjRQprXB3KMStLKOezD4cZiY2SdX6EzcTAkjU35Y123cglf6Nl+xa/aN5lwPbuKUGS
	QJK5R5F7zlhIzpEJa7X+2oHG/uUsJwY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WT7L+yjgB0IaOTyJkUQuzdzCWldIgXpJyxmwqVKairA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790058691; v=1; x=1790663491;
 b=oAYNnPDU7g0bbd9sOTRK7kokZ2fvrpFZqzEdH3h5e7FRO/fpmVq5lUutgC0S8Yp40F13w1Pa
 x6WaMn7qZFo3YIXySL9Tvw4umgM7wc7qYeOGHhUwQ7vb32qbdVCmu/335unQTcQ63D34f28E8no
 eMHM7CG+OFz4076/tOpFUv+o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3d5eaa6d3b009fbe;
	Tue, 22 Sep 2026 06:31:31 +0000
X-Mizu-Trace-ID: 3d5eaa6d3b009fbe
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] mm/memcg: migrate per-node hugetlb lruvec stat
 together with hugetlb folio
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <arIEfJXYpspgX4-G@localhost.localdomain>
Date: Tue, 22 Sep 2026 14:31:14 +0800
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Hongfu Li <hongfu.li@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 Chris Down <chris@chrisdown.name>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D086B92E-13A8-48A7-97B6-CD671EE22033@linux.dev>
References: <arIAyyjYcCKHFmyD@localhost.localdomain>
 <20260922042054.3264663-1-joshua.hahnjy@gmail.com>
 <arIEfJXYpspgX4-G@localhost.localdomain>
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4BACF40002
X-Stat-Signature: zruwy9scsh9f3qpko9u3tf5yrjf3o5ag
X-HE-Tag: 1790058694-159905
X-HE-Meta: U2FsdGVkX1/z7pDIglYNqv+AEpCQ6RtDq4k/UIW06O9hGwQYY/V3HPiOmyIlVtg38lZ30woV4BDi8LcpstGnI0ImhEZPSTn0xgvMhe4W3hFh6p+zFqG1IBn7RhbvPn3SRXsVUDXSI2Xvy0XFPjN4xYPlJOAT9N2A2+HT+efz316tIl6xpW8pFlMOhLz1n0vVDHtynIuoCcFQ/iexZPGV6T7jPh5JBJ6i724UlTd11jgOQGVEngQDcOlOxLLhTXtmTHd3csOblNKSGsaGHJ7dadW9dwI0ONrnFhUaDcupXst0T0Wg3ZwkQFY+WQ5oxbOQWMBLfLGZgZ1T89ixkVn1pYhclFuPpi2V4LkvChqmCLw+E9y1gpNB2X3YXE4hNRhQNxrh/rfEbTTFJJJ2CfSt4ioUpTQZvgevToWo8FcSusSjJXOxoHNbmiHqYhqpzcty5PLygn7BLXdfAxFYT5xRqN4yT0eP/Zj6C55XUYDvjgWUPGZpx9O6gnLAJC7cz94UOzbW2NS56fs2t9VomM2cDHeli9+/23k38s+gQOZHTC0XXyNM9ZqJtvYqnA0wAFIdQpvhM/5QbmPIX4zOptcymFVI+qg1IHwY89b9RRY4pAfXrkrKtm6vaGr/OvFxC6IGl8CJg0UYPfkOjSIWnPjOFHG3JfHvDjZfuiwE76VIHMGu8+1Hqcu8adolp8GHJbxU2hilIApnxYovbIjq5HC7/SsbzTSqURGwj9HssqDumsACsZuTrZm0zeC86vsRdHVdyDTBhkOUvdZqRvT22heS2+rE+LKtAfdeIFVMIbab4pMpymhQsZ0hAhiYRcjwpzM74Jw732IMzf2bTNjKewgNb63PjZAMpIBSJAnxrxmJViTsCA4gwzM9Sa0iL6zHysEsU7Lh6+1szrZ5XRouB0D0i7APNCiF/OaycieETNhxZMKVNvphl//KoHR5LjdbqNPZpsFDhhxO7M/E0k5KK9P
 BAA5OIu9
 QzyYeRa/TRI6x/Vjo6Cm1JeUiRMltEjqBy5wFc83wnV6W5L5QXYsdHMVpQ/rB8og/GuJq3mc4duitjwTMb5HOrZf1sz+kq46pWoCGZO57uN3tNFJaTbqUgHJMC+sVpuP5T1K/SjOhr9un0OchfueGKAxqCOXYI99bcE6k+wZV1twgrvyFBZ8eUYNG6f+xvB8UmAfP1FCUfdiVSw8erlK/BkE4hqCr2DlqgnxmS+Jl+f7NKw2IoCrhI3Fg2zq/C7Xt5L8+V2U8pUPXlj8mUGqE0Ds4N6G5/BdXU9xgXVcFMd0GMsQtskjuSrEnUqyYoxmFy5kTHoEAAMd1UlIRpiqDxngD9ilu92udde8h0/xAifDGkow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 22, 2026, at 12:30, Oscar Salvador (SUSE) =
<osalvador@kernel.org> wrote:
>=20
> On Mon, Sep 21, 2026 at 09:20:53PM -0700, Joshua Hahn wrote:
>> On Tue, 22 Sep 2026 06:15:07 +0200 "Oscar Salvador (SUSE)" =
<osalvador@kernel.org> wrote:
>=20
>>> Why do we need the whole thing to be embraced by rcu?
>>=20
>> Hi Oscar,
>=20
> Hi Joshua,
>=20
>>=20
>> I believe it's because now getting the memcg from the objcg requires
>> an RCU lock to make sure it doesn't get removed while we work on the
>> memcg. I think this is since Qi Zheng's "Eliminate Dying Memory
>> Cgroup" series.
>=20
> Yes, I understood that obj_cgroup_memcg might need the rcu-dance, but =
I was
> unsure about the mod_memcg_lruvec_state() calls.

The caller needs to make sure the liveness of lruvec, in which case,
lruvec is from memcg, so rcu lock is needed here.

Thanks,
Muchun

>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs


