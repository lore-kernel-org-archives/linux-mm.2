Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7FABECD9B8
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8CDC6B008A; Thu,  5 Feb 2026 21:04:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FE46B0092; Thu,  5 Feb 2026 21:04:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0EBA6B0093; Thu,  5 Feb 2026 21:04:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 904E26B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:04:30 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29B1F1B2BB3
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:04:30 +0000 (UTC)
X-FDA: 84412387500.12.607A539
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8A0B1140003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:04:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNFkOUfS;
	spf=pass (imf23.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770343468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQFK9n1X/6XJOHaia/NkQdjYqZ2VqcclwuM3/PMBkl8=;
	b=dpa6Ef8iVSINdamYC+WCX7F/dsXie2szsk+SLBjqZfjNSjoVtJMzCf93DCqK/gueJh0PdK
	2dCYm7zjm+zxb95V0+MQRAeUqRAZ/EkVZMzt+e1zWHqk1faB4+rDXzqyJsqcqn+GYaEAm/
	ohK+PWeeHBd1+EGbQbdJU7+R/66YYUY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NNFkOUfS;
	spf=pass (imf23.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770343468; a=rsa-sha256;
	cv=none;
	b=wzlxApetd48talhf4hflRnKK5aWhieCeQyTQAYXb8Vnet7xojNGGTCet//rOsjcnjptYD4
	L95E50NUySRAnz3bMYoxcFPhYZEofbec+rvhrMt8Rql/XAGTW6px5szu5d37KVny3++DvK
	MSS2m9xhEZpWY2aXRvz/+YVzuOJhh5M=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770343462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tQFK9n1X/6XJOHaia/NkQdjYqZ2VqcclwuM3/PMBkl8=;
	b=NNFkOUfS6OjPT6fWDsTe8LgVnn2qNou7cPBmDkWDv7x//qYHO6stl5mJ5r0B4GeKs70HAL
	wzY5Yjx85rWtUN60++ZAzx29NyH3RDJ/3/4Hv3I5GefX+rOYOYVTGk2S7FvteQ5OvypsTi
	kQ+ozs/7Y8wzKp1gzgw9uVuMZ/0S7BE=
Date: Fri, 06 Feb 2026 02:04:16 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <bc96ed3734ef03d4defc9c3940893eba8beaf0d9@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible
 pages
To: "Nhat Pham" <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, "Jiayuan Chen" <jiayuan.chen@shopee.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Yosry
 Ahmed" <yosry.ahmed@linux.dev>, "Chengming Zhou"
 <chengming.zhou@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Nick Terrell" <terrelln@fb.com>, "David Sterba" <dsterba@suse.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Chris Li"
 <chrisl@kernel.org>
In-Reply-To: <CAKEwX=PBsuO27n_Vw112Ss2ZCTFqGem8f134cGKbHUQVL0aQ9g@mail.gmail.com>
References: <20260205053013.25134-1-jiayuan.chen@linux.dev>
 <CAKEwX=PMQ1aYWr36XKG7oup3diBXb5vjV=fGZeTmYcx+ebmMtQ@mail.gmail.com>
 <CAKEwX=PBsuO27n_Vw112Ss2ZCTFqGem8f134cGKbHUQVL0aQ9g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 33hjweq3hx6cxrrjqy548r51ew8pwo5n
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A0B1140003
X-HE-Tag: 1770343466-192918
X-HE-Meta: U2FsdGVkX1/XAloIXagX1KNEIoVOZpe2RVzfypalidRj7nes9Fbvvgjq1go3U1sUvPpzLZl/WPoXuNfnyylgOLcx7LMHhD25ZVtVvdPL/FCLjS/kcugVfvehPHRQR82DDU0pmJPfH9ThSoFcfrvSu/5gZ2ouUVhOcnKI1zcGN9iEvV1i6srYRrZbGAFa1lALwqKUg6aGUlsqd33nipxhWRwDJ1KWq0/wswrcZ5MSkA6ts0ZldczPXx5Dcz215kUh7NpkGdxC3wZhTMfiuNKxTqL0gwybN/H0+wmrZfV9UBjOTFQiPwPVP5C81yLV0HjKEAKn+BH0tTLvfQOf3ICYkebvm0ojK0Joch3hJQP84UcM6Xtfn+a2m8539ZZTZH78XjBBq+e5qz5oSX8drVqOXJny4upRrSPSZP2n2JqjepUGmdCzxySjIvoirXOvzJcasYY2WEjny77WNW4B1p7ZZf6l5aZhHcTxZrEfpKUQVUWhSC3hhAZ4l/GEW7zNqfeXbuBEoTb4D320pofTm7BAow11h+E4I5OvSHic2F1/27uypuzgc2BZzwFEIiJb1tEWFzW5AO5DE0VovB80fjTTx6Ch1Mko2u1sDZM51yq+G9+/FvLrGWcOxEwB4utUBcdv5hyDAx5e2cMnWqPN2XgAFHi8L6EJ31gASlsEBzMONo5B+uSTAWyRb9ZNKXsOslCFraQ7BrcqSM1DTUhTndG8qYhnwASaDYk/58ZiYuLoGIwgDJCGEDPYAPYHa3mFNOkOwm4msnLe8/LDHbjnWRAzQcqoLpGIpFibbtxeCdezmK8K9mm3vIJpjgyxhw9Y4zf2XIGIgNLBqk4uqk9S74rfeeO7UXFikNDrlmwynZTZkgorhL7J5keFqIfjkZMJnwg6f+rXnG6ikyzRiW/Nwt+K0+QrB/kzxsJYCE815YXbfX5vfyqTUggtgrmkRsZa9sH/53Y9CBGddCxLSuv6lTu
 eRyrPuM7
 1ktLk8eqaO8KgX87S0jlFK3xdCA7vuYBucg1g6oISOirj5t2cRwd5Mfc1V0g37QFvQfiwnDHLzOHgkCokzJYE2YyxG1ZtofYbSFxIh30jqnFTmgTf3jcesle34D0n9pkl9UhRKoNN1M+Nr091vEqqXE+GGpLJMEsITmANbIqz5ZQ5LlT+WtAFIjv+V82n+wmFQfAKREnLPdHdIth0LxYAMp6tnhBqziWc20t7oW51c+b1LOlCaoLRAA7HpCCSvReDJEODKHDeKwIKVzlFkFWuNqIxYXRul8r2mQurw3j0w1UDlUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

February 6, 2026 at 01:45, "Nhat Pham" <nphamcs@gmail.com mailto:nphamcs@=
gmail.com?to=3D%22Nhat%20Pham%22%20%3Cnphamcs%40gmail.com%3E > wrote:


>=20
>=20On Thu, Feb 5, 2026 at 9:31 AM Nhat Pham <nphamcs@gmail.com> wrote:
>=20
>=20>=20
>=20> On Wed, Feb 4, 2026 at 9:31 PM Jiayuan Chen <jiayuan.chen@linux.dev=
> wrote:
> >=20
>=20>  From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >=20
>=20>  The global zswap_stored_incompressible_pages counter was added in =
commit
> >  dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as=
-is")
> >  to track how many pages are stored in raw (uncompressed) form in zsw=
ap.
> >  However, in containerized environments, knowing which cgroup is
> >  contributing incompressible pages is essential for effective resourc=
e
> >  management.
> >=20
>=20>  Add a new memcg stat 'zswpraw' to track incompressible pages per c=
group.
> >  This helps administrators and orchestrators to:
> >=20
>=20>  1. Identify workloads that produce incompressible data (e.g., encr=
ypted
> >  data, already-compressed media, random data) and may not benefit fro=
m
> >  zswap.
> >=20
>=20>  2. Make informed decisions about workload placement - moving
> >  incompressible workloads to nodes with larger swap backing devices
> >  rather than relying on zswap.
> >=20
>=20>  3. Debug zswap efficiency issues at the cgroup level without needi=
ng to
> >  correlate global stats with individual cgroups.
> >=20
>=20>  While the compression ratio can be estimated from existing stats
> >  (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> >  "uniformly poor compression" and "a few completely incompressible pa=
ges
> >  mixed with highly compressible ones". The zswpraw stat provides dire=
ct
> >  visibility into the latter case.
> >=20
>=20Actually I forgot - can you also update the Documentation:
>=20
>=20Documentation/admin-guide/cgroup-v2.rst
>=20
>=20to include a short description of the new counter? Thanks!
>

Thanks Nhat for the review and Acked-by!

I'll update the documentation and add Chris Li's link to
changelog in v2. Will consider the selftest as a follow-up.

