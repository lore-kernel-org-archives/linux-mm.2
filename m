Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EDFDFAD3E2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 23:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1576B0005; Wed, 22 Apr 2026 19:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462086B008A; Wed, 22 Apr 2026 19:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378706B008C; Wed, 22 Apr 2026 19:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27DFB6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:57:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF182140376
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 23:57:16 +0000 (UTC)
X-FDA: 84687855672.08.43D12AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 091521C000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 23:57:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mNFB+xdW;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776902235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJBRG6KDMW+yq2D5qxmZxyG7uq7dTMoiUt0GCZhykPk=;
	b=6yW3EsdMma7TSa7Z+IN3r/uC4WGJID7k/3I2NeRTLWcBFNicYNG+8UrurKqAW4dQgRTwSw
	QNMU6fBLYMR75t5BMiRzbm777h3UHmkruHPgu1txIPNHxfd7YaHpj/qNjWvVZKseecbPrw
	pVsZLl+SgYFyFSLqGuLpati4EgUdTu8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mNFB+xdW;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776902235; a=rsa-sha256;
	cv=none;
	b=ufRiNAuiwGTW4IkPJPHWOFue1CGaJvcSwgwS7RXGSn6TJA3rjIUstbDFVYivSdN3iT32sp
	620IlUSLK4Poeu7d0tUcDkpW5rt55MGmbypiuKz03U4GncUe+/CeET+MV5wXsvGUMB/b/+
	3EqkyxN8AnIZKl/ELcdyR3mr4AqY7v4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BED7744492;
	Wed, 22 Apr 2026 23:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDB8C19425;
	Wed, 22 Apr 2026 23:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776902233;
	bh=h6ggrtCedybWSPNMwswG0DZDcNwcm7cnvs/LOyD/wNQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=mNFB+xdWLZKpCxXZm4/ECJ7c866xDmRQuYKee2ZmooLdAboj4IF919Yq3Iw0bINsX
	 RA4s2JA6QITi2C8+PeIS8/KussEZgcuvkC/xnNNHlYcTPzfY/A3b0ztWYGAPRFwI7q
	 dFrML80TrDtSrx81rSV0kIXhdCtQo7zA0q26ALnYgDR5M/YJ++seIkDSgNLESZuZoO
	 x0ElHg5+r32UBFskPnb1kuB1/kBSU2lIvB4V/c0IfQCt5g8Tm+EL2o7hCU8m71CPuJ
	 558uJ+lGCcjFbOFFld46ZXtKgYDBP2LW5O7Tcc5SS8XOXouVemuXDANtK9uPhHYsdE
	 QBLGa3JPbkmZQ==
Date: Wed, 22 Apr 2026 16:57:11 -0700
From: Kees Cook <kees@kernel.org>
To: Marco Elver <elver@google.com>
CC: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 Andrey Konovalov <andreyknvl@gmail.com>, Florent Revest <revest@google.com>,
 Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>,
 Matteo Rizzo <matteorizzo@google.com>, GONG Ruiqi <gongruiqi1@huawei.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2=5D_slab=3A_support_for_compiler-?=
 =?US-ASCII?Q?assisted_type-based_slab_cache_partitioning?=
User-Agent: K-9 Mail for Android
In-Reply-To: <aejopk23CsntyFOB@elver.google.com>
References: <20260415143735.2974230-1-elver@google.com> <202604210954.84C57E5E0@keescook> <CANpmjNO8CcR56LXAQf4GQhGcbU4MQkRCa7gVvwuAfvVrzEUhQg@mail.gmail.com> <aejopk23CsntyFOB@elver.google.com>
Message-ID: <D3E316B3-9909-408E-85BF-647383810CFF@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 091521C000C
X-Stat-Signature: ndd1a91ahqrrtr835m9nc7wh4ayhsy1h
X-Rspam-User: 
X-HE-Tag: 1776902234-977654
X-HE-Meta: U2FsdGVkX1+S6Yr+LG0y9JlGMNZUfTDvGWpyzSyLn1x5vcSikWCpNjG3o/U5D/p87+HnSqvV8UPra9u7PmBoI2uM9olyK8RC+5Z9YdTedcyJKCf7EeexAYaJmkasNc6V403D2+lI8F3+GnpSj6kAF6+vRDP6Bq9F6/2I+ae150s2cujM2JcQuN+CoYXJeiQkVda4et/th/7UmPMXUubVon5Ulc+l/CYOkW4zHvc+tCF9hPSlWjYgU/m9J2Jn1A9IiXzdZHl5K7bkyqPukJoK9DJFKSo0HTi8gm2VJ5XEmgaop+Sfkvq6ILn/5JIHc4Mk35OQbLuFdrdruRWbmjT+fvCJzz0KdtTWZadR/cMwDz6fcxfdzKGm2wqQIkMrRsaB1fTucpRdTjTjLfQhuVUoW8VUYDr3x0tI7BXjynPVvZY50yyN3e5dx27Pyr+OZGH4DsV3OvzQr1rlUUqFsUaMGiO3MIT+GnqhXeKh4yMm15xpwZ7RQdbqu58PAuzkNJaY+Dgp62zvXRSM1s3PbbwpriUsZTDvWw8ezqm0zR1WPYdGLJQHEyrtKeoxhXspj6/MmSoCvKtsjaBdxTSsJ6W8Q/Fc036evwVNHtH1fy0feDEMIGU1oBfTQbv5Q3Qvj85+Hyha5CitB7grPHE8zUrFLa4jNyEKrH1UBZi9C8ZKC18FzOw+CHbUtnz8Rt/rg+S+wVT7V1ZNGZeymdW0rDHNJEUe6hWFS90F0urGkBMK3kJ/+pCXotEiAWZiS+tHuJQn8hB7P3YTm9lPQtC245yR2k/A4UToZLF0FkIEAHAUxK+fbtSYCG+hrScDjxkWBnsDL2n6igFLjC3W1fouYD9/U3w9nNzzVz35bA3n59aeeeXHYZP7v2LSjOgR3lzSXC539HMa+Y2/xemW6GFysEIX/KG4m5Um50wCS+Zw5fD8a6W5FglSX5TugMmqKMXDnbhhtuls+T5F68+t5HIbXe/
 2C97OsWb
 ckXBcLsdUKA80X7jbMPPOjAf6KOBmocrxC91D5JxESgr6s4qwcn4j+oQb0mlYPhdE2L/iJQzwiQ/L626IJ1847a3kMD6lk2SIzmJDj8leMupU9sFWFsJZ1rWA+hHjKLTRDMfl9XiS7v5E9uaKIYh6GyED4L1TpTEDxI0vXPd26IN9RHbJieMDZdr9l34G+fNmYAHhGRAqCilHgqcH9Sm/ymDTcWU0htap890C48KXhAD6AdmG3tRuxfPjhUb70h5eROGQG0YvkUD1bXYEzXS3K47wownVtssjGg2e140S/yvCpAMO00/BzhDUdsfDSFhMQ/2uIaMyCNp/Azno0SFkTNTFUqAGjHLY+I4Phd+oBkzcNJcs4C195/iWqkai2W2b0wvw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On April 22, 2026 8:26:30 AM PDT, Marco Elver <elver@google=2Ecom> wrote:
>On Tue, Apr 21, 2026 at 09:13PM +0200, Marco Elver wrote:
>[=2E=2E=2E]
>> > And actually, perhaps a global rename of the options so the selection
>> > naming is at the end of the CONFIG phrase, and bundle the on/off into
>> > the choice:
>> >
>> >
>> > choice
>> >         prompt "Partitioned slab cache mode"
>> >         depends on PARTITION_KMALLOC_CACHES
>> >         default KMALLOC_PARTITION_TYPED if !SLUB_TINY && CC_HAS_ALLOC=
_TOKEN
>> >         default KMALLOC_PARTITION_RANDOM if !SLUB_TINY
>> >         default KMALLOC_PARTITION_NONE
>> >
>> > config KMALLOC_PARTITION_NONE
>> > =2E=2E=2E
>> > config KMALLOC_PARTITION_RANDOM
>> >         depends on !SLUB_TINY
>> > =2E=2E=2E
>> > config KMALLOC_PARTITION_TYPED
>> >         depends on !SLUB_TINY && CC_HAS_ALLOC_TOKEN
>>=20
>> There was a comment somewhere else that even introducing
>> PARTITION_KMALLOC_CACHES might confuse users of RANDOM_KMALLOC_CACHES=
=2E
>> I think completely getting rid of and renaming RANDOM_KMALLOC_CACHES
>> has marginal benefit, and will cause friction for existing users (even
>> moreso than already)=2E I see little benefit here, and would prefer not
>> to break user configs more than needed: configs that already set
>> RANDOM_KMALLOC_CACHES, upon rebuild will be prompted to enable
>> PARTITION_KMALLOC_CACHES; if user says Y, then their previous
>> selection (RANDOM) would already be picked and they don't have to
>> rediscover that it exists under a new name=2E
>>=20
>> I can make this change, but only if you're sure the benefit outweighs
>> the downsides here=2E
>
>Upon further reflection, since the transition isn't smooth anyway, I'm
>probably going to rename, but have them all use the PARTITION_KMALLOC_*
>prefix so it's easy to just search for "CONFIG_PARTITION_KMALLOC_"=2E I
>don't see the need for a "NONE" variant - I've seen this pattern
>elsewhere, and then you end up with users reading the =2Econfig and
>concluding "CONFIG_PARTITION_KMALLOC_CACHES is enabled =2E=2E=2E but oh n=
ever
>mind actually it isn't" which I find confusing=2E This could be useful if
>we had a dynamic on/off toggle and the default is NONE, but that's not
>the case here=2E

There is now the "transitional" Kconfig keyword too, which should make it =
easy to move to the new name=2E

For the naming, I tend to prefer the noun-verb (e=2Eg=2E timer_start()) an=
d noun-feature-option ordering (e=2Eg=2E CONFIG_SLAB_FREELIST_RANDOM)=2E Th=
is feature isn't about partition tables, so I don't think the first word sh=
ould be "partition"=2E :)

As far as doing the full isolation later, yeah, that's fine, and I think w=
ith this Kconfig change it's easy to add a new mode=2E

-Kees

--=20
Kees Cook

