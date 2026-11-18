Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B84606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oRxZdjUI
Received: by kanga.kvack.org (Postfix)
	id A87D16B05B6; Tue, 17 Nov 2026 22:13:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3AE56B05B7; Tue, 17 Nov 2026 22:13:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD276B05B8; Tue, 17 Nov 2026 22:13:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 591856B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:13:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38333A829B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:13:16 +0000 (UTC)
X-FDA: 85446768792.21.E8E7E4E
Received: from mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id CB3A4100002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:13:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oRxZdjUI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794971594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Nxi0/sOY8+VKqMZ2GbfZhgX5prfn39dCsvQzRiF+fg=;
	b=JkVMrC2HOGuLAOqW6BF2lozDuoRaePzUaatgBa9oNyM3ODvSFdIf6TqxDF28t2j0Xr+cxI
	vl6rcvjgYgvvK7ZxgEApnAtl5FybsKqzKvGZ+JSJtgssQ5TvYz32j38bMxfMni+3w7M6bl
	Bj5ObhjnjWSAjKoR6JKAAEJfadzCBwc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oRxZdjUI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.54 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794971594;
	b=UnPBXYHHXFa8IfDEybvB59SJWPAbY2ozraxsbzf76u1z34a6FHLUi5Lygbyd+Gk/nAiWu2
	TCQcb+26PomWlhDDpubQeevmb4Co2hdVfIH3sz5f+XUNksalCoHD4BQaANDfuMceerRnmh
	IElxr9ovG7+3IsGoebqc9w2a059Q3Hs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3Nxi0/sOY8+VKqMZ2GbfZhgX5prfn39dCsvQzRiF+fg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794971592; v=1; x=1795576392;
 b=oRxZdjUIVTFtNpuCG4tHhyT9WhEi06Z6YYJFMbB3a2pWb6wQj8oJ0BZz2H3OTnlIPwVy88J0
 DtOfhdLKwUjq1hRnRRPR29e4uNGeeAfy37B+hFrmO0+JaxMzLo9XCV2o6xiizEFF9MQnWQprhgK
 rTzswE73DOWS/gKR/pO/gd6c=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8fe63967abd7ab38;
	Wed, 18 Nov 2026 03:13:12 +0000
X-Mizu-Trace-ID: 8fe63967abd7ab38
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 0/7] KMSAN: Move per-page metadata out of struct page
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <avzsE5wGnXji5u6-@chrisdown.name>
Date: Wed, 18 Nov 2026 11:12:46 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>,
 Joerg Roedel <joerg.roedel@amd.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Pranjal Shrivastava <praan@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Mostafa Saleh <smostafa@google.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Sashiko <sashiko-bot@kernel.org>,
 kasan-dev@googlegroups.com,
 workflows@vger.kernel.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DF4B7F9B-3B1E-4165-BAE4-2E05E86FB034@linux.dev>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <avzsE5wGnXji5u6-@chrisdown.name>
To: Chris Down <chris@chrisdown.name>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: CB3A4100002
X-Stat-Signature: k57sjqcxpiiuyxcbbdnrjdqzmoq7157o
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794971593-638796
X-HE-Meta: U2FsdGVkX1/M8AqR+L2f4SkyX69CoOUcTmLPc0pjhRxtcDFgmAwN48oVVtIoZ9sbZlqHJMsewBXm6jV3RL9yFOcC5nR9hcaPpFpHBNmQb1MobsCr1Cj6BzxAu+11PKNOtXa/s4k0vXlyoq/St+c4w2zk0skWrux+xt2U/f4Fj6QVe/4u97PcChzt0Us2twG7FUqghrR6yeqYyWbl6toGkTvbpWQeCQAQt1HN23NGMY33Ii+LP8p79ZaeI0L/T0Zbwvn+zxF2LGHoWd38m4PZuTUNShEqrSajED0woa09AQkNPJWvHNjMbSxLEHVfYpn0o9ZGd7Lkpta5bgjnhQKjyYDPhFFLxgsZhG/T+Z8NAdspuBFRK2FBUZgVv4oHjGsj5wnwldVnUIo/4+7j4ZcoQEROfyy5L9YWQNXIvJjOFIDKcnt2XDX75PvWtXSQKuLng+OzQONn2LRelH7Fn1xnjxp5zdXo+UwQWsI8UImzmPhicG2JIu6r9Ohy5rEkipA6lLGJY6AmJTOs2vkYf/y56l4cO8zRKY0WMQwqlv0ud+dItGKQIa/DlIngVm0LYcxYknqWOWSXLd0Jrb95y7cwOp5jzHAnymQYnMk4ZybA6LBMjsqdwTMc8vPE+xjydc9gxtQmPcDDMP63ypVXXO6K0hatMlOJ7xuEuqSYZbg61cUKefFEV23N0dxMEDRQoqTGf9G3OCFPChZPTdNU6+qXhJBiOaRikuISTDUAj60Cq4nsEpss1Kxhy8wPUhfXyu2Hk3m8mOK3uXgt8C0IAw4SlvN2cyxLHN7ejrcFhHH6vDHab5zzpsMrEIDawrjrSWYYjOl9JhrIDKncosi6KU+IKoUcIeVAfUxV9+mYLsdMEbw4Hs/DqO4Aw6geqcFS1WYJ+HHYsy37hyNVizykpCTIIB9iqgEJAzqAnxLZhSfFVSJgSqQpnRSTdUs/TerktJan+XgX5VMMmtyHiesLSjR
 7pNpnm9H
 O8l9ax3VheIn9sqkGKF0m5iCxRdBAfezdkFpDqUtEJVYQUgNKaaOvPlE0JH46rQkUM9cVbR4Wx+D+agp6Cwb8138NAr0BQoj0o6QkUooN8iKTgavpAKYjibYG7FQVoyQJT4dQ05ydXgjFp+e4cEsm3nLHMPJYZOim6h7a+Yg7s/HfSMRuOnEWViVmvKtL5zr7mX4ncQ+YC3WmUXgNuxKQaddp7peTTxsPlFxIIudLPnzvIXE4EkVoFvOiPFTeNjNG8xY4PGbInf2eHN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 18, 2026, at 08:06, Chris Down <chris@chrisdown.name> wrote:
>=20
> Hi Muchun,
>=20
> Thanks! The changes look great, thanks for working on this.
>=20
> I think patch 5 still has some issues and have replied there, but for =
patches
> 1-4, 6, and 7, feel free to add:
>=20
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>

Really thanks for your review and test.

Thanks,
Muchun

>=20
> Thanks!
>=20
> Chris


