Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09DB2C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8846B008A; Tue,  8 Sep 2026 04:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF366B0092; Tue,  8 Sep 2026 04:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4626B0093; Tue,  8 Sep 2026 04:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3A0D6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:34:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D52D40495
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:34:45 +0000 (UTC)
X-FDA: 85189934130.02.3907414
Received: from mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2369E20009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:34:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WaIV5EqJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.45 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788856483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aN2ORbphLllnmDHaHvQtAfLkAW1wgx0CLNBFoa9NNVg=;
	b=eU19GG8ZgGlIMy8YPQRUwfnW/SE/Y9+FCVLnxhPzd5yTEEzlq8RD4Ub+lx/oFYu/r+cLLU
	x9O+UBz0Rhj/09YTGv6E+TXV8hmIu5rNpOWwzu8TMXHArJCrInmKEN3HhHAtbPlX3t1/mG
	6Be7wpLGQzm0zPlfD0u9zxCXBcF465I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WaIV5EqJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.45 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788856483;
	b=gxt+wTAbPjDDNTY2IF2dQpznjSxZX5osFPt7rxYMMxCO4HxhvFB2Cc1lMhC+hFiitBJV/k
	EKHylXEwANqXOdWqNMQ0dMDHMo6fqWuUGMYGojUCvZpY0NQwAYRWeFtYDZlKKnuDMA+fJb
	0ohf/bDqx9Z1ANIhEEVr7ewf2Ufh6G0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=muqKO/Q4TVxj/cNMo0pajKXnu4hE0n3bdHEU8buxoq8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788856481; v=1; x=1789461281;
 b=WaIV5EqJnRx2MXsspd/aeq6ewHOKtevy6YI5y0RSqGgiEYxQtOOd7G8se5A+i2OffWaAQ+rI
 GPVzzsSbfcj9r6GPdaXu4ObJvoNwpPEgDIvo3ACaDEL9/teG+XF0OklW4Ev2w+DKReeHPFo1dHY
 dFEUXkxx7dUZJdWGEp4ctFbI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ef271c2c22e4d45d;
	Tue, 08 Sep 2026 08:34:31 +0000
X-Mizu-Trace-ID: ef271c2c22e4d45d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2 06/11] mm/sparse-vmemmap: switch device DAX to shared
 tail vmemmap pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <1fc41803-a0b3-48ca-84a6-caf965fb11f9@linux.dev>
Date: Tue, 8 Sep 2026 16:34:09 +0800
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
Message-Id: <B05E15FC-62A2-4F8D-8624-F3DD16056DF6@linux.dev>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-7-songmuchun@bytedance.com>
 <1fc41803-a0b3-48ca-84a6-caf965fb11f9@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: aojnioh3bpzzkjb6yfgggzasikyqm74i
X-Rspamd-Queue-Id: 2369E20009
X-HE-Tag: 1788856482-133202
X-HE-Meta: U2FsdGVkX1+Vi8G7ih+LI1gFSLEkBDGnWbyGolCjo7q+5qTDmrIazDwK/jkwNVRyllNxwH7ogGCtv1Gru7XDQGXbyxv/TJ9XT2X6xnvyDQuhqkmxEZK+S27TBflEcpPRMrqi2RPHwTYXuxsJ7GWwHPhQQ79Alzjo9PfPicfLcIZqyo0SUQSIb/LxZmH5zwZtPejQ7s9oBY47BX9VcZ81sMB0IOAS+JJlOG4k93oG9uZ2+/hM9vl68VQLQ1OSw+wRsXi/QN9aMHgRhVUowYqGjI63KnQtAazQu7ksQ8KNQmH65dWP5zqEEoi0tnJdf++iFx9RV9MUESOGAcGDpUT4AP/Qo+DQUObrTN3TF1FSakATyszV/pvtNBRcO816MnhHeY9+fs0BDGR7d1xja2WXGf6Gf2gRraKvgGaiMnR4JuOGB10CSokljuJ02fSLk+ofJ5cvEXZPps70nc6pl5K4U0phcZuMoAiPbyJxo++A/+WR8EEcDm6v0PLh0wkiEkotjcU9nA9v7hRhIkZZHFsDBe9zNUlchwHqxUzpWI61kBcMr28atNcT51vAuJIJpBmusTDknxB84RQF6WTvRW89hs2ybZ514jW9vVYLuTKddjtRakALyibmTTbHqxhxszGjJsD+0eU2mrxCmxStSgFT5spwZ73QVl7PxsKlzDyA7whM2NE8D0oHIOw3Iv+ncWJKlZHXLEgSB0m+LvGfn2xjhoGx/a3XeRbqv6BzljMsAfnHYsLU+ZgyizYJ1/55fqyczJxiFZ6N0qwHf1ErUNx20MI2zOiO9I6dcRtHQZlFOAeKEM0LTTZIXwj18SX3jgMVYo6vJv+9sYevGIgAhDx7fpNhzwxUlWBYvw4jOuE+77kZKFscVT/nR7OXl3VjRYwwGdjyjFt3Qcr0H+L2Y52x7eeFniUrX5+HcDq+qrXDV8pExXxtNJRnkQ+l8MaYKH3hCq8rCgZYLxpu+vFPWry
 Q6fMm6ot
 W3hwLNxiw+5BiO8bVkKc4q14+PCVKtd9B8Y+cqqiKwA+fMbXNnDjtP/YCJcu4w5V7s38OncvNf4ONSP/PEgNkA90GdUYayr7FbIWkn/F0sMJmMq9mQY5oylFDjYGvDSzkI+W4DkBYYh8cuyYmx7Y1ZqOxwm3UF2dgBONZcqMWNJAs9A0pjE+yyIlGCcQ/QikP/uzGwjihjnvvAwBkYiN3dPJzTkvqQg4EiG/in29iQczNb7YEx5RsPqz16idxutkr42D8Ozp6Wx/5fcZp5FSUVTpkA6DvaiGmV8O1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 8, 2026, at 15:46, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 9/8/26 11:03 AM, Muchun Song wrote:
>> HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap =
pages.
>> Device DAX has not been switched to that mechanism yet.
>> Switch device DAX to vmemmap_shared_tail_page() as well. This aligns =
DAX
>> with HugeTLB by using the common per-zone shared tail vmemmap page.
>> The optimization is enabled only for DEV-DAX through =
pgmap->vmemmap_shift,
>> which is assigned when a DEV-DAX device is initialized. Unlike =
FS-DAX,
>> DEV-DAX does not modify tail struct pages, so sharing them is safe.
>=20
> Got it =E2=80=94 adding this description makes things significantly =
clearer.

Aha, also makes Sashiko happy. This time, it is no longer confused
with FS-DAX.

>=20
>> Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
>> initialize its entries with PG_reserved for device zones. Also skip
>> poisoning vmemmap-optimizable sections while their struct pages may =
be
>> shared.
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v2:
>> - Explain why sharing tail vmemmap pages is safe for DEV-DAX
>>   (suggested by Qi Zheng)
>> ---
>>  include/linux/mmzone.h | 10 +++++++++
>>  mm/memory_hotplug.c    |  5 +++--
>>  mm/sparse-vmemmap.c    | 47 =
++++++++++++++----------------------------
>>  3 files changed, 28 insertions(+), 34 deletions(-)
>=20
> Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks.

>=20
> Thanks,
> Qi



