Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBBFC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337636B008C; Wed,  9 Sep 2026 08:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8036B0093; Wed,  9 Sep 2026 08:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE2C6B0095; Wed,  9 Sep 2026 08:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 054A16B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:58:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAC8516016F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:58:32 +0000 (UTC)
X-FDA: 85194227664.10.4E15056
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by imf20.hostedemail.com (Postfix) with ESMTP id 147D51C0002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:58:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kpiWHW+P;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788958710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+53+2vjJaQFoCiKj+C56qien0jFLMDUHHh3iJ/cgrBw=;
	b=Wi3Uztw/yJN8OjaMQC1mNM7AH5aLNiV2Ikszs/wvtBYbudY9H4D43KXaWHBx/hLc36MZDN
	fbfvwR7X4Dsmky0uG1j2yMsrIX4+PZbeq+6FCY31TjbEjUHcklpqGhZhuV+FzjcuWOLG8C
	Sw6mt5VnLk0h7lEaE1/yL0VFtLY7nY0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kpiWHW+P;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788958710;
	b=lC4FvsHHfKR+rz1aHWR9wyYCmcLNgAL4Y+Ef+b60LwmsQZIrHzudKJjWnaLPzgQQo07DAb
	KxL4H92M9a8DidH8Xk+LNVUX9KXhsZYNJSzv9B/BRAavoon/4PBEj/WZYir3slnrILawhQ
	dYLWm2dD+sroz/+m5IPK9c6gj+IVLWg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+53+2vjJaQFoCiKj+C56qien0jFLMDUHHh3iJ/cgrBw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788958704; v=1; x=1789563504;
 b=kpiWHW+PKUzOQnFxZqUeS2tTgUacZxuC1o/xnmCU2+iPhwEmnX52wK3+exNOJTiawZt/TYuw
 yAFtm9meUKfqcUSKDdZnCjPlq9zcCpWBzAVj/UKEAPV6htl/8ZZl7DAkaaKSuCaaYU6eMbBX01V
 oVhfdrOc+jOwrxRGNZPvmnao=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 256877c780270637;
	Wed, 09 Sep 2026 12:58:24 +0000
X-Mizu-Trace-ID: 256877c780270637
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v5 09/17] mm/sparse: initialize memory sections earlier
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <e6335c78-a20a-4024-8980-097a922eb257@kernel.org>
Date: Wed, 9 Sep 2026 20:58:08 +0800
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
Message-Id: <7A0F5F1F-F724-478A-A34A-E9F9771E2EB7@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-10-songmuchun@bytedance.com>
 <a2016390-28ce-4199-a063-d2e9101dacab@kernel.org>
 <E54037CE-6CE6-41AB-A525-8BDCE55996AC@linux.dev>
 <e6335c78-a20a-4024-8980-097a922eb257@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 147D51C0002
X-Stat-Signature: 4qyrz9biextajc3yhi4oy57o67mqsqdb
X-Rspam-User: 
X-HE-Tag: 1788958708-922614
X-HE-Meta: U2FsdGVkX19Htvepp8OWx1rYpw1DO0+nqowzJqqFlQU09HLqplN0pbLN3LsG0wavpP+qKs7vI880VvQAK1X2jlPBUvXoepqRRlLxdRRWBmcJIBjhuS+kQ0vO5lA4j1TnB7F2SbqMDBwXkuxYZkv9hykTIPLf1lCA0jkcDUsPDCYayxIqnYH4YZopRLGjjtbOvoR7XbGC/hazVpj8z7dfMPbBM8CVnjC5kLg13EqCcREZQudis42u9XKC+21Rnujz0dTwkJ4hjZOvSCPGcf+IyvKbLLpKTG5EhPhvUfmKHv9ZLwlB+QFqPI0PREAwK93s/W55ecXcHOxx/2paQtOc+yMD+jgvxtClzS/uZ6GSb2avzAN8p47ag1AubYhM2e71wkVLo7boK8gxA7Oj3haZWO9AWrZhJKelnZ2RA2/RVXEDYhTsHXVQo8EjNOvPGislsbRYR+ZNuJtto8ZAO3WhxpQgDq1BPKKjINd5evZHGRn9PugHn/A2ThucghZu/pdmYJK3KkKsaXhSGqmFifQ7UxCLkpDl+o8uSELn8ManM4KTtFiED8rHNHiZxdFlEWsFRq269HfCFdAHRj7j9nYwm8J34FMplTKG6mwD+ZRYJ4t1yseJhMebxTwOEZV1g37hVywUo1JU/q1pj+y1h035kMuomegySVPgiVZiyPHKrDzo2cHFtaOznxE9qMcjkyfaluspkTJnR6wZ368MSzO2GwchSNu6x9mjzts9f/HvYvsEIR6O3FcWAQCpSYxC75Y/fZ35ygDILs337Q5t0DMJd9wzIJDyscRrOpqsPfjWgpK1S4K/fbTCfgky7N+0opGNOdsbTZaN4vRf+pqHzZqE6qW2rJSLyFquvZ7vLX26H/T4Q0UhGCzbFjV53x7T/KiKyno3TROsDHGhkLvOIUXibgR2JTJ5mtYE7KJrQVCsG7VLX/n+VixI+aHgLUnEKGb+QCSyW9fojdBk7pZYKuZ
 q1s8g/RB
 eZF8B2CRbh+EROR2Bal4KZWOczU0kphs3jZm8TiPrT42gHva7t+MN5C4paQOQWGTC7HXPdGV2Cj7anhbUzcibs+SBCUt22odL/IX4+bPshYRwptW8RT4jR0b76nVN/yo7QGZ0ZaRDnuPRQotJNVKI0gIFsXu++K4zox2WeiLLtNnrIeCFq3b3069T2TDJ/1xJtzWhluJJpT34RqKBkDn92dhXf3Uw2NbomWqhGmGiHenPXKBiRdpDrb45WICtWe3Eg1O2qVwq7ASPsCzkal/GDC8B+xOZhEL/4ByCClM0qYGdEAal/Fhh0VEZPC3UqMRa8PMHC4xdJerKqbwhEXKYleqF6SSiq3xHNH1afdwOztSbRuo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2026, at 20:48, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
>=20
>>=20
>>>=20
>>> I have patches to get rid of __section_mark_present() and just set =
them all to
>>> SECTION_IS_EARLY|SECTION_IS_ONLINE such that we can just iterate =
early sections
>>> and get rid of that PRESENT monstrosity.
>>>=20
>>> Apart from that LGTM, even though I don't particularly enjoy =
splitting us now
>>> having two init entry points
>>>=20
>>> sparse_init
>>=20
>> Maybe this one should be sparse_memmap_init? If yes, it could be =
another separate
>> cleanup patch.
>=20
> It does way more than that. In my patches I factor some of sparse_init =
out and
> call it sparse_metadata_init() -- memmap and usemap.

OK, I'll leave this part untouched since you've already done the perfect
renaming.

Thanks.

>=20
> --=20
> Cheers,
>=20
> David


