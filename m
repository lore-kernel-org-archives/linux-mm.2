Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A67BCA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE396B008A; Mon, 28 Sep 2026 13:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DE76B0093; Mon, 28 Sep 2026 13:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480706B0096; Mon, 28 Sep 2026 13:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5226B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:38:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F2641C21D1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:38:31 +0000 (UTC)
X-FDA: 85263880422.24.B2BE0F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 056A48000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:38:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gq48WQDi;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQwrxz5DxAOSOS9tl6JASwUQOclPkIJdyJDy+q6eIS8=;
	b=Ss5m1RiPHU2B/y6dJoyUMF2G2aROLxoUDgw1TUkmUOu3w1JdM/9aVuR3T7BKMdmQI1cXza
	HOQ5g/rrt+PnvHbM/9mJ9qJzUKTCorGQsHAoZPq9G4iVjmstZQKHUVLYJ+ofQ70SlCgtuw
	twTH+TVrwNuHLX7nQ4T8Z3X3v6VqUdo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617110;
	b=sawVr8fKjXnHUuV3USlTUj4yIhSBON/Buxjr+OIzWeDlVZmWYxxj6WbffQCcF76m6SfVm6
	wWrSOgu1eYBnrDgkpQ/04hv9QTP2vxUJ/uIZGGLEUgtfh/+9glXiIQtueTkonMeVbnWAGt
	7yGt+UUaCbfedY2dtuilcq53B5PnEng=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gq48WQDi;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F2B7601EF;
	Mon, 28 Sep 2026 17:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D2B1F000FF;
	Mon, 28 Sep 2026 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617109;
	bh=XQwrxz5DxAOSOS9tl6JASwUQOclPkIJdyJDy+q6eIS8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gq48WQDii6Y2wXwqk2Dl5BFMHy7xKx8TTGraKfDWphG9muDmzzP3BKh9CjmfaLF3b
	 OGISBa4ZzYAkBhG9XfSWCUruhzX8uzuilGXlekZydznqvNfrHD6aMMPjaFLjnJiqvv
	 RS0BJPSDgMDpCXRjmHgUqyuIVax/AU7gXUFbYIKly2dx7CBfFuJMxfvmYz+ffoS2uo
	 iQcT5DQH44SZc0420Lhot1F8XmVL3de4jo5/eFDKxyEydTB6dleUSgAgMjplshTKNs
	 z7HPMxwt4Jj4/m6ojc0dHEtXTm0zh80Jt2ohM7T5bFSATpMbyO4Q9pIhcs2aP1aCif
	 ZFYMCktn4VFEw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/12] mm: Wire up the crash memaction registry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jann Horn" <jannh@google.com>, "Nico Pache" <nico.pache@linux.dev>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Lance Yang" <lance.yang@linux.dev>, "Baoquan
 He" <baoquan.he@linux.dev>, "Harry Yoo" <harry@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Gregory Price" <gourry@gourry.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Serge
 E. Hallyn" <serge@hallyn.com>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Pedro Falcato" <pfalcato@suse.de>, "Barry
 Song" <baohua@kernel.org>, "Peter Xu" <peterx@redhat.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Liam
 R. Howlett" <liam@infradead.org>, "Matthew Brost" <matthew.brost@intel.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Alasdair Kergon" <agk@redhat.com>, "Rob
 Herring" <robh@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Oscar
 Salvador" <osalvador@suse.de>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Jarkko Sakkinen" <jarkko@kernel.org>, "Rik
 van Riel" <riel@surriel.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Dave Young" <ruirui.yang@linux.dev>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Byungchul Park" <byungchul@sk.com>, "David
 S. Miller" <davem@davemloft.net>, "Saravana Kannan" <saravanak@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Mike Snitzer" <snitzer@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Mimi Zohar" <zohar@linux.ibm.com>, "Paul Moore" <paul@paul-moore.com>, "James
 Morris" <jmorris@namei.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Will
 Deacon" <will@kernel.org>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Jonathan
 Corbet" <corbet@lwn.net>
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-fsdevel@vger.kernel.org, devicetree@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, linux-arch@vger.kernel.org, kexec@lists.infradead.org, robh@kernel.org, dm-devel@lists.linux.dev, conor+dt@kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-3-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-3-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:38:25 +0000
Message-Id: <20260928173825.79D2B1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 056A48000B
X-Stat-Signature: 89qw9jsc8y9wgnqq5z68pawufed8t9d9
X-HE-Tag: 1790617109-760556
X-HE-Meta: U2FsdGVkX1/XvDrR2fF16AlQuq/MpGFwYH0zanruI0NZ80dv+30teDN4eDWINZxXxg68y7PUzuTfBz8WdHfKl8/bDDSDVdsynn0uh+ua0qxlW1MclaaicBN3qp9RqGGNxKFkeq2QqVKktzR515SludkDguoQmP3FIeq62lLhuDWNKODNmR391JyGKyP6mRKo2DUYjZLuUSX18DiXiAB6BzIXGTKjlMEX5fGyru4MsEJPEKx1WjGTzAkP0MgPEJT8fi+Z4McbrfmuJV52T+7gGyWCw1CjuQ5e27E6NOG7gwQ0V4oYkJry3Tpaye0KqjKBGJMBvjzMcypX4wOyi5JVceCsuoxUamWusETlZDOgMq4d5qUb9idOj6A4JgwSjIYkE/OINWzEkteVuF58kCCwV8Gkv2qAyK8o6fgikeE2DcYDR2A8S2Ix6R6JG/ygzOPJuNZ2ETBFcI/cga4XVUWdLiH+94hL4kttmL/qms6o6soybUnwKLPBj/WwJxMAfOfZNzRYIN7yKXHToiupqOy3+hsXx41iThMPQFqKTI104VOtuUsqJDrhlnYHW9RjNdETBfMFknOmSxn9JUfn4vBcJUnvvANJOffUATRg1ocFnxuftQEYYhtx0GoRvHjLtMYunCmf0O4t1DjGDqoRGM1JEgTuHuyKqtooDFqWZCMKp0nKpmj9b+KahwnXFssx+9z/Efeu/wWc4aTejHq5D+edThoNAuTy2Ocz5fwPKJgykB68lK40VVsu9uJC+tnejJNfJ9GPnL8XMYAPvOxUh1oH8esTrJENducKsJ1ZO/TDERdgadz1lnuUbw3g8Dgj5Jhr+MjPlBZ+DYSmE7aJ2QeOi7a2GfqLMROP5pAQqrp5wwKjmf12h84YdbCrv6zKI8CUxwkNjkx+HHOHA9AxKgV+Beit8c3dIZtm38iTPxVZ9DLM41RKP0SPpUhkqOZ7gcU/5qmaZ1xNUjjdqbAksK1
 xZN2VXV8
 ZNQS4d1eQ1WWCGlOt3saspXKif3p3Pvn/Eb0xgIPJClimGjlbSjVqPPEcKbGJN0Wra8z+sYQLcwnFBK7aqDO8ATzX4ysihS+ZB64jEK2GunUdMzbDngmCGYHhFGBp1/Zb9WEwYknOw6XmMq6MZ1MfWE2bA5ZGwC3OXaPi3Iz4y+apx/faY2XomycMNaU7Mzl+HipCPV2EvrgYo9RuN1ffitJP1IgEpGD7/h6eOD4eFl3x+akFZPKE7yiHJRPkjLzEDGtXF8m2CiJJKjctQwW2iJXN6uB7y+vPv5s8tXuaNM2lDmfzSt7tqQoMuQAFiOXxIfC4H/85NfCX7BC4pI0vkUxi7niDTPgIroZT8IWfIYeB37jdK1j6vDcVRqgvH8U8vPGzLbC63ZJHTtyo+omWZRvHVUdavKhC4zRM4U3e+IgjbtPdNddP2MkvO9YZIvV2yOVRGsnCPqCSierNAw+f5vzGahWvVH8ddq/6+++BJfvgCHIsXYdl4MUOBJJJyzkUd045zfm5GQ/BmuxPSok9VWCHy44PyCqh7/T+boO4RKg0sZD06dJtZQ1WXtycRCyFnGENY/j4tFEGeBgXcMdxOl8HcL2xYoZPkKtj023n2+K0OmPdUanNAhtptP4PZ7Fu7z+NdFVShDGqR3/3HISf2oKHmw9W76Th/w6dbbJTZMaMg/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: Stale secret data exposed due to premature unmarking of hugetl=
b folios
--

commit 62d401cf60aea442c3fea654492895fe956cadd9
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

mm: Wire up the crash memaction registry

This commit allocates the crash memaction registry bitmap during boot and
syncs marked pages to it. It introduces hooks to unmark pages when they are
handed out, placing the unmark after zeroing for page allocator folios, and
in dequeue_hugetlb_folio_node_exact for hugetlb folios.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index da980377d3533..36f0c0d8f5f14 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c

[ ... ]

> @@ -1281,6 +1282,9 @@ static struct folio *dequeue_hugetlb_folio_node_exa=
ct(struct hstate *h,
>  		folio_clear_hugetlb_freed(folio);
>  		h->free_huge_pages--;
>  		h->free_huge_pages_node[nid]--;
> +
> +		crash_memaction_unmark_pfns(folio_pfn(folio),
> +					    folio_nr_pages(folio));

[Severity: High]
Can this expose stale secret data to a crash dump if a crash occurs before
the folio is zeroed?

When a hugetlb folio containing secret data is freed to the hugetlb pool, it
retains its crash_memaction mark. When dequeued here in
dequeue_hugetlb_folio_node_exact(), it is unconditionally unmarked before
being returned.

Because the caller is responsible for zeroing the folio later via
folio_zero_user(), a window exists where the kdump kernel could observe an
unmarked folio and include its unzeroed secret data in the dump.

(Note: A similar window appears to exist for THP allocations when
init_on_alloc=3D0 because THP is allocated without __GFP_ZERO, causing
post_alloc_hook() to unmark it before the fault handler zeroes it.)

Could this unmarking be delayed until after the folio is zeroed?

>  		return folio;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D3

