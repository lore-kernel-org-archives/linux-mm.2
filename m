Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F67ACD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3D76B00BE; Fri, 26 Jun 2026 05:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAFF6B00C0; Fri, 26 Jun 2026 05:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0C36B00C1; Fri, 26 Jun 2026 05:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD2986B00BE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:01:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5E4DF1A03A4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:01:25 +0000 (UTC)
X-FDA: 84921470130.10.C84DC84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8119020004
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:01:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KhrDWg3I;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782464483;
	b=KOmnDjojgPAzCspfx2uCR0Bi58wqSfuqchXQNejAOGrl2BEyi9BrL+RMNxOB6FQ4oMb+iB
	aWcoBzs5dgiog7XwuY2IZg30dsCOf+ezJxzwzi158GZvwLqkrXeAu2lDq4CZgER2Vxai7O
	wp1NjOKlN16CqUWVcO5QE/b6VHBvkf8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782464483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oljwZFEHyQbS4dJbZnrrRQZYBmFAfUoVQ0TPQ0VSX5c=;
	b=P/3FJCw9NaSy0QB7l6ToJ4fzcH5uyoZn294NaahEQ5qA6oKB+k2i+RhzQ/m6Iay1rSCov9
	7inrWwH2CAVrMo7QJN74hJU5S7NQ1uYO5hXLFnRTuOMLQHUx8bzHNB4QOJEQ+oKy2JzWIn
	/zH9SDMlK678aOll0qqX0Gxhbs8qQdU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KhrDWg3I;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA6A64071B;
	Fri, 26 Jun 2026 09:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98501F000E9;
	Fri, 26 Jun 2026 09:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782464482;
	bh=oljwZFEHyQbS4dJbZnrrRQZYBmFAfUoVQ0TPQ0VSX5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KhrDWg3IRbYGeQXE8WE2dG1VgG5rq13frn5oMFczMwZ8bAB0zZ/OLITmYPJkLGyrq
	 9Kat7cxtdTdaL2fT4yGxBSN3RxTcxQlLXsZM2EwYnPvqRTvXmXX+37TpXQmZ5K5b11
	 p9kT/J+vtWRvGfsha0agfpDCLf6Np9k4Z4uEGf4kv/qN0sCOeGAJNXQIAwGukefLfn
	 lCzajdw/0rMK/wmhNKgNoC7RwieOB3da+MMJ5gxO0lpTr6K+GfUe9y5ainEOzkpIn9
	 JLdO4jiQPzi1u2TzznmE5i7CiH4jxlvisl9pMr3r/pfaFpSU3hY93Oak4b58j3XzwO
	 nIenQfDkYvt+g==
Message-ID: <47711372-fe2e-4072-8b23-cf3fa09eb201@kernel.org>
Date: Fri, 26 Jun 2026 18:01:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] mm/page_alloc: rename ALLOC_TRYLOCK ->
 ALLOC_NOLOCK
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-1-31f31367d420@google.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260622-alloc-trylock-v2-1-31f31367d420@google.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------1TM52njjKfSDr01RWPlc5SOq"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8119020004
X-Stat-Signature: kjio17gpi81ms6fw7mi5jctghrhpz6ag
X-HE-Tag: 1782464483-310532
X-HE-Meta: U2FsdGVkX19uBdOzQ0JqICY/EbjGswgNgEsjymvROMv/3iFpRFEaCUvbZATIm/FRdnIGXo5pQ7yP+G9bcuSfeuJtxs9or2K+uOwOnzPJs7IT7iayh+0SwL+xLmz3rwV5z0lSV0j7AdIhvGFQIFUjrkXf5NDWwWNXzqe3Tx0zKlOIFW5aco1FsBnRSq69sT5ZmUQOAsIzTRyD/6ZqR54/5MJ7QJbIpSbLaTtXKeQQwg4BAZVXqV9EEKrAy+2X15ua1zGkHa7USIh9od8YO7sJJ80/w1zwohrG504NFgbW9Ijiy9n+GX+u1r/ER+2JhgzK4d551qMPwtptU1gwSiJyVAbqiScml/NF+WDAYvC0K1WGOT9Jv6a+sWSqjxZKH+zmhYKT+gDeF6uqahIEUq0GULV7bYRcfveZjAXe3Mwy79d8wxfADowGCy+fnA+ByX4ZAckimykXW+eCVCxVsYuUahTNSSqSUz2H5+8P5CVyJmjpO8p32Tdp0k/MS+sp8QKEXbDq7JkGgDtpcfu9bQI92BqdPVHWyHLRQEF3UicvDK3SIk1S5l7Zk93obRZ8U89l5j94W6h2gOWhAXDE47lbj6Mc4halkB3LUz6nB4RTDcDapJQw++nbbFl+k0lDJnTV0aJx5xqnBsXoE0sU0QgjqZWmsvy9RfZwb721rWAxYSAmZbHIRJC4Qx1HmxWEBu4itvX8SYUtz0iKIeCGqzKMJIiCAI4/GNA9C9Z8EGoYBklupofkyFjd3oZqbtW1Y1TI5sDHyYwkrjZYFgnStrpUK4G7OGEygoT3STVxgDbT3WSCQjjsQ+B/CDbXeI/bEPTRGkZaTdVZvvjplAuWp3ggf0r7jBTBhlsjJUJVMEjkz29JjAGqwqQ1hJ6nVXOXg5CxF+NYvKuGvUUtRFyLFjUhoLXuVFkXdZqAzfBVE4BvaI6KCaCI9oeKsYOI4+BFAqgEcQGmgCKDYtRH7g4yx0W
 XdEMd3p7
 FEzdaLeB5biWA8v0OM4HmERm8xTtKF9aSEbyNPV+hmS1erFd2pjAyCn7XU4dOLhT9nwqk9ythjYUHTjvgYmBhOLiUz3nVfz3wZ3Jvb6ploKUQg6rVvtQ2Kl63WjenEE27sOcZDEhbTYkivBrGGxv8Lrq1ddLBuSd9B9NkMlHBPHv5hvgxRtEPETwiLsWTFKsF35rCCJZ5xEFxFJKzxwfARW0lPDkB9sn5I7cCxyfWnA/0n2wKehe1hXNJX5LVjxoxXZiWTxM2BPgLWH+DhcF7gVWcfSoWQ6sIkBbY8kTjY1SVqnuJp0rlEI25nhb9HC/YKsW2P4jGSXD4iP+pwZM1FU75cj5gdfXohetfryThSk6wGEfPBgooWo1WoPCsbfasQ2DAQuEyq727dwyhX7v0qidsmH9WUhDigaBtcTOxSmTVy9+pSrs1PkNrPUyzGruNsI+HJxr0Hf+E5zFpMSS+ywmVospYaeSt5/38wfJWicYkdVc4tk7ZIgocORqmuaSOt2c24cGH8WckMehCfXJwREWnCFyYatP2RlpDOxrUrQY8WeDcthkmMehNo4hMcTYOra6YtkaiUynRAzFCaSsrZZ+n2bz45fHo7s5MnNAL70xZ0EV6LDOBg9FH6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------1TM52njjKfSDr01RWPlc5SOq
Content-Type: multipart/mixed; boundary="------------XDSSJxToBp7oeVvqN0zGo8UF";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Message-ID: <47711372-fe2e-4072-8b23-cf3fa09eb201@kernel.org>
Subject: Re: [PATCH v2 01/13] mm/page_alloc: rename ALLOC_TRYLOCK ->
 ALLOC_NOLOCK
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-1-31f31367d420@google.com>
In-Reply-To: <20260622-alloc-trylock-v2-1-31f31367d420@google.com>

--------------XDSSJxToBp7oeVvqN0zGo8UF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/22/26 7:01 PM, Brendan Jackman wrote:
> It's confusing that the function is called "nolock" but the flag is
> called "trylock", align them.
>=20
> The function's terminology is more visible and has more mindshare so us=
e that.
>=20
> Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Link: https://lore.kernel.org/linux-mm/2399b3ad-4eac-4a14-94c3-27e9f079=
72a1@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------XDSSJxToBp7oeVvqN0zGo8UF--

--------------1TM52njjKfSDr01RWPlc5SOq
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaj4/0gAKCRCGXBN6rc5S
1gyOAP96IylFQ68CSoQPVkjZreEapB0lAuT4SaO71TRUd9IrEgEApOqW/shMrU18
8ZWxkyQmKqte3Fat2T/ICqmmF6okdQY=
=Etyv
-----END PGP SIGNATURE-----

--------------1TM52njjKfSDr01RWPlc5SOq--

