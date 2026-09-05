Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F427C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 09:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C9B6B0088; Sat,  5 Sep 2026 05:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D506B008A; Sat,  5 Sep 2026 05:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E656A6B008C; Sat,  5 Sep 2026 05:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5CCC6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 05:00:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 511231A02BA
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:00:35 +0000 (UTC)
X-FDA: 85179112830.20.DB986EA
Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FFED20002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:00:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=owdKV6E9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788598833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lp8UCRU7U/gPdKVedCNM8hsF2owEixvJ2Zh3lB3p6qw=;
	b=6OV3EjBq+Ysznr5E13XrkiKuLMxyDNUi93AbgferbkJa1RaVSjon+YWM+YlfCZdZWPWpo1
	TENNjmDfXSibCE0OLYJSu7yP3seORKWK5NykvXqjeJaQeDg9hPPmwVUkgsHfgUc3X8JKiI
	4upJIjyulfKIUxYKIHXaTVFpLxoHiYY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=owdKV6E9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788598833;
	b=Vxmaz76dKeM96ezwQ+6+0zEHLh5MLwtf9sdBQOy4+Dyz6uPlNYcPyxUcgvyJHRbNFRldoD
	LngoPgGw6wgE2Y1tEzhRF8u6gy0zPiEMlINtuGIxSzvTuBmgwfh3MTKMnA9fgNVstr8qWW
	qAgYm6ktnnQR14zU5qmot9Pb4syIT9k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OiKgIsORJwdwK7mxOyBT4OEx/ZyTZXJf9s4fMrv5tMg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788598831; v=1; x=1789203631;
 b=owdKV6E9W8k+nU4a9DuVH7PFSrn/wRF+sLKKZuSIBF1pnHelPaq59ATTvN5kXMWE0/o/JXSD
 p1zWY4aeLbDaAUjOcN+izmLpMk/RyXFoiKywusWUcn6lYbAWX7CGx9rFJSmr7uYM8ZHACwZ54+O
 RyAkmoOzQBtc5qWKWAQGrJxI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 27e0770342031b0e;
	Sat, 05 Sep 2026 09:00:27 +0000
X-Mizu-Trace-ID: 27e0770342031b0e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 05/11] mm/sparse-vmemmap: set section order for device DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <1143901c-5036-4b79-8135-21ce57075136@linux.dev>
Date: Sat, 5 Sep 2026 17:00:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6AEC3FC2-2365-4EB5-A022-8AB0EC111073@linux.dev>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
 <20260831075342.57563-6-songmuchun@bytedance.com>
 <1143901c-5036-4b79-8135-21ce57075136@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FFED20002
X-Stat-Signature: nw96rs5hsythy1ykm94cpeb4xq7bw47o
X-Rspam-User: 
X-HE-Tag: 1788598832-606396
X-HE-Meta: U2FsdGVkX1/eLy0Bz17MmcozTFmPmMxYf8NsWdMu0UchCgR11f++PApVulb0pgqbf9QlGh2VS1dIn2r4g9eU/48QLWnW7crNHuynX1wnx4z3+OjXd4uBY7TRUAvehptAtT5wtpe7xuLrVWYKlmOTRAPfvzpd7q92YFVmM6fVh6tXspXgztkJaTzdlLI/OyPYXbrnbYh9nxIMh8fYmElMKNzJhjG6I4faMMG/SoCdCkieriqt9180dRBVkdbFnYQ6tn6KvUqZhgWz34KGORCDdmLvfBik8ky0qn72Vnk7LIcFT8dnaNccoJxEMnyhFXPzm47aR9g0Eovq5u9yp/n8TnKlLz/9ltoc332/X51F9aMiNJ4ckkEU/BH6kU5WzhSFrVbOggGE/UOgWk6gnHp2FyjI0+262B8WS6mpDh/rbjDDL99rTFZwDoJZo3QwrtH5jy5vi+Izha8lvB9tDhS4Lh1VZuvO5CeuTiIwS5kPmjoO0YQHSTNJLIWf9GXXci2V9y3Yynkh2leSYMiu12vINCqZ5vd9f011bEGJXUpxqJP3ZW6GfluB9gwxQu+ktc5Tchw3xAAF8z9WazvfJHrBJiZpzxovtYnpBwbE7nsBi+yN2+gatdTFm99uhhRtc2bcq7gaO4ZgRFi/NQbf7SpcYTT/2ECjl00I44TSlpmOV9hk3whD+SXG/Q1+dqVOupR1LC5+6mpyS2ZZVvGz/0TGDhhaYTg7bMWAYayvkB/AC0vQFFhoTTftSoebg6bWoR05OMIiVh4+TDVY4X4M5JwtDgpgrBUSXWbxVu6uiEr5gT1H11xIuPzKqvQ+8SS64b9dTKzOtsHo8v0jMgEIFUGFOtnsQBeFl6wgT1/VAxr2Xj7UNyUnCf3sIneAYiJW2TOZpN71oGd4aWH3sBF0dfv9AqLAiL70XT9IQszTi7+kqZG8EmWNtcOSNT2JEMff/6Llbtq0VBlLy06ln2KEqfM
 1jj3ZN9E
 2dds7sIwgerMgl6wAeXjnyFYXllTj1JGIB0RZdCPi0K2XbLUj4X4MCtoyg2pD+ItPSDxzzFF/EW9NlOPbCQ7MgbCFrOZVfvpcSm9i4gmEI+ox9Ifev7HPXeuyM8SJzEoUPKwjn1VfqnW/OHWeDk7oz4PRIMb7xJk/D1+apP884r8HW/MlLb1AbLiPhKUdqqgoFXtbQlp+INg/CnwkoAgU/dh9qSGgmLRI8t6Hdx7LQ5fKt2A4ai/OJjOrrR6+LjF7OiL2kvpgFyuhKP1J/31X4ExK2DkS43tYZS+r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 5, 2026, at 16:20, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> Hi Muchun,

Hi,

>=20
> On 8/31/26 3:53 PM, Muchun Song wrote:
>> Device DAX can use vmemmap optimization only when a full section is
>> populated with a compound-page geometry. Record that geometry in the
>> section order before populating the section, so later vmemmap =
accounting
>> and population decisions can use the section state directly.
>> Clear the section order when the section becomes empty again. Also =
reject
>> partial additions to a section that already has optimized vmemmap =
mappings,
>> because a section cannot safely mix optimized and ordinary vmemmap =
layouts.
>=20
> Perhaps we should explain why they cannot be safely mixed.

Yes, because compound_nr_pages() determines the number of struct pages =
to
initialize with section as the smallest granularity, they cannot be =
mixed.

>=20
>> Partial additions continue to use ordinary vmemmap population, so =
they do
>> not save vmemmap memory. Such additions are uncommon, and the lost =
saving
>> is negligible.
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  mm/mm_init.c        | 13 ++++---------
>>  mm/sparse-vmemmap.c | 16 ++++++++++++----
>>  2 files changed, 16 insertions(+), 13 deletions(-)
>=20
> Also, the issue sashiko reported looks like it was pre-existing, not
> introduced by this patch. So:
>=20
> Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks.

>=20
> Thanks,
> Qi
>=20


