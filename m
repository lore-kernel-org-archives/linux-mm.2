Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21BAACD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4227F6B0088; Tue,  2 Jun 2026 22:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3176B008A; Tue,  2 Jun 2026 22:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E94C6B008C; Tue,  2 Jun 2026 22:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7D16B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:40:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8EC9401F7
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:40:13 +0000 (UTC)
X-FDA: 84837047106.21.5C07427
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE4D740009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:40:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a6OO/AGV";
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780454412;
	b=Gx5cvn42YDJe2YPjQ0v9FbgVuq6E9TAUKLen0BEMdWANe/6Gu85XXpV+NcLkcx1OKk0LT5
	DEib/P1S2V9r4UpdF0+GdiGp4bKxAMHV1SawAuVOkVtJZ97Nxgj4Y/fBkHRNBigxM/TpRI
	Uc5eMf0PFPT4+BGDum96TImFzWwwQzE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="a6OO/AGV";
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780454412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enhp+3s0SIGEOwjQc/7W6s5wIzCQbFdyWa31w7PMhyM=;
	b=UNVMSbpz0v4OEyZ+C/Q3vWpWtIGRPmLlUnahIgLaslv4Rtl4XhrlwD7l8fU/WcUGhhDDva
	NceS3Rit7jtQlt5Dfr6z2brW6J2g7Sk3rZ3WjrStsFSyDi61gSUuIGj0L9xnZ2WdbccKzR
	iVV+KAnJCBOdZ3jerFRXYCeAWE5t1zQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780454408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enhp+3s0SIGEOwjQc/7W6s5wIzCQbFdyWa31w7PMhyM=;
	b=a6OO/AGVjZPTkYLmFE58mUZkc+Ig9OvucaVesgXboaIsfd35hyTrwEOUiKCMdq62BTHjWY
	3iDA8+TOhj7GAKI9lEBKJK0ZAnOuZOAJh+A43sHVWZsP4eRe4lyDV6hA2e/VlitznVZPoQ
	w1ZVN5buyzqpE2WMljQJpn7BDAJVmsc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3 19/19] mm/mm_init: Fold __init_page_from_nid() into
 __init_deferred_page()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <178041489408.457517.2991925440539441241.b4-review@b4>
Date: Wed, 3 Jun 2026 10:39:20 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <10D5F5E9-889C-4B4D-B104-A1579A771F45@linux.dev>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-20-songmuchun@bytedance.com>
 <178041489408.457517.2991925440539441241.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DE4D740009
X-Stat-Signature: 3qxtdeeigh6zqgpadzu5yemd9xg5e83i
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780454411-26147
X-HE-Meta: U2FsdGVkX19s5N/2kJSL3lX5MqW6B6vdh8K0OLIaYsIZ/giNv7Vv8LD44epQQ/0J9/f+U2LbfQtElkKzR9H/nki9f3bt1SZYH71KRIEtr9uk+EcVTCl/qMZWKt21yJXXi2BxlRYHTTuXkZU2XzOx6k7Y5G0gR+feXidTF9ZzQ4C0dAAiBH8pdl1HJyccaa/Kf1gimCa5cWipMSNdyUtl+bwuF1JOuqeaS1fdSPtIm0vHjOQc292yb78cb0ts8gH3ckpvEmLdw2birSdWtrem3D4tzdUQSUhn4CposDzZu6tWhU0LRHH2v076XdYQgp9n+CCXFhxN8ltPa9hA+MxjDoKOUVOT9LEHVA1EyCehzc/a+tNoeCIz6iuYE3G2pAuWGBFribEKLRYPjaKZP946tE2OItBSCeQwkly5vo7oRvBhUQZkgKJkBopyMOhoR/oHRi3uI4ZPMvfR7Q8HDshyhnCSoH/52LDL2P6A6vEoAZ/vdHRUrZQSO/d8u5CS+YC26mVms0JMUjrzq540XDaQfTEpYFSTRF7hCaRjdbLeNqkxC6t7D/qisjY7WVz5xROaslCZuhCj/aFNn+E3T/gJrahUMw7DOMfKkc7D1EjKHLk44qggcj5M7+e7UvevQyD9x1I3KJrVg1fiVGqEHbSYZ41JzOsVaG5TBOe4x4hDRdkIHH/dqxjbGMjJVTq0ef+JV3naZMY+eQjKOp7cY/a4qDXDZfT6btDxmlV0kkT2BS2ZZHI2id/p/Ey7IDXrbZMTc5NQKOg9ec3RJ28CypHIrPJdJYMqIgolhxuRZs9EDXUyfhkPXn4yg43f6nv39/TpRR/aFCR3FYFVbWC6tr3xRJMPkE6vTu7oUjqjmiv8kP6a1SKNJIpNhBLrfgIB6bujSa0xB0ZYQSK/ZamJ2T7OAGO1fqBiuR2DwAjPFTc3w9sHBojHdxaY5VO5sVh6aOyEp+y0uyg2pf0BhrrdK6p
 V+6q9RS4
 hfikIudjCpN+kw0PPaSOSIP/7LFstCiuI4Hn2rkSzupEyfyktD4cx3ObOdpdVtdMiPSLHvpvg6WXPBJmIjLZKaAZ415VEPsY3bCqFlFwdkA+BARJ6JOVD2lTBoXHkLgs2j+TwsX+cigqSKu0o+ppL6IUg9Q/YTbWrBr1JXPxft4pluagxgHM4AHtIgifHurAL+21Z2eGyZfqgnc95gBIkpUVi0IJSlViHChzemb8heN2bN8oIm9cQcNPs0SEyrwKqnh8hyya7Id643hQeHUEXcTqJXXlXjAH1HRArCg9NXFLjczuWFgQwQlM0SffLpoVo70QHmL7YYc84n2D2xJMc2G0F8SjcMqRTOYZTIDjgXDFYBwE46qakOr1cortsAT+6qyjnYIpG+1miBl/ZEDRykk7DaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 2, 2026, at 23:41, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Tue, 02 Jun 2026 18:10:39 +0800, Muchun Song =
<songmuchun@bytedance.com> wrote:
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 41b83dd18c01..f1bbf3b9a321 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -771,10 +746,27 @@ defer_init(int nid, unsigned long pfn, unsigned =
long end_pfn)
>>=20
>> static void __meminit __init_deferred_page(unsigned long pfn, int =
nid)
>> {
>> + 	pg_data_t *pgdat;
>> + 	int zid;
>> +
>> 	if (early_page_initialised(pfn, nid))
>> 		return;
>>=20
>> - 	__init_page_from_nid(pfn, nid);
>> + 	pgdat =3D NODE_DATA(nid);
>=20
> Nit: we can initialize pgdat at declaration line, other than that

Yes, will do next version.

>=20
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

>=20
> --=20
> Sincerely yours,
> Mike.
>=20


