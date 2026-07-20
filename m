Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A03AC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676256B008A; Mon, 20 Jul 2026 07:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6271C6B008C; Mon, 20 Jul 2026 07:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CD56B0092; Mon, 20 Jul 2026 07:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F32B6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:10:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B512B140131
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:10:58 +0000 (UTC)
X-FDA: 85008887796.29.2EA6846
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8157280006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:10:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lgnctbmE;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CY3D2G8Mcf8naJ39Kb2qNt3PpH1v79jSaiicxK5PMgk=;
	b=yW+bpK6WJJYcNWeQmrKjKAc8s35D6TTg2cfG+8VM93YCZLRxlCUnrUUFcnoGon2NCtFDSV
	19gPOhasbRzMu8wzo2ckwXMF0pNd2Svj6/PRBgbKB5WtfCSO97iFxN66/qMaRCl5pnhnNG
	kDILIRQjyzo8/6gdCKqruJyOo0riiGM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lgnctbmE;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545855;
	b=K8AWQac2vhb8N+/QsIfroXjqDJAwpRFBrcKvh0CiMzCjNO8sNgAMrcrHRq7eUO1evSmvNW
	DZ5UYUwRBaBAD3/ToVqqtA9LWSy3pB9v0X1gJp+4aRYC+PxnqloX7IKj80/6zqBsh2GF8k
	POqSgqlQGLkfVGaTICJLyCb33hUPMtc=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784545853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CY3D2G8Mcf8naJ39Kb2qNt3PpH1v79jSaiicxK5PMgk=;
	b=lgnctbmEgU7E4T16WW5A1XlyEAVa/GZA6Cp+b53JNdazm4iMZJZUiRMZNvAUGTH/ONEVGA
	Xt4rE6RLGfpO/JbaU+UoaMO45oe8wJc+vq4Ys5KPcCbHN0LkMAbdfwNSy10onMJFFp3GfH
	O9kTSia+Lxwbn90azwujpxqyDHYNvY4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 08/17] mm/sparse-vmemmap: support section-based vmemmap
 optimization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260720093127.540540-9-songmuchun@bytedance.com>
Date: Mon, 20 Jul 2026 19:10:23 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B94645F5-E122-4B48-83DE-B977A64274DA@linux.dev>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-9-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8157280006
X-Stat-Signature: k39n3ue8ioj5e76igiappcoocc4pn6yd
X-HE-Tag: 1784545855-40094
X-HE-Meta: U2FsdGVkX18ntGHYXQxd8YY54dAZHCwMudc0CTFmNyNiKjXqiBz/Jjh/fTovM4OjcZwXdU219+Z0b9+i0iv6wFB+pxuB9iPzpLfrlqVIUJVhO+BXx7hOyn/6WeiQUH0wVkLu3znFSlOoro0+EDcxkADvOZ/MWnhBtYLapCGdH6zpCLXSfbLUtz3f3zPzo/PZpzxLbO1PTVxo8ON3jkhOKMp35NMoNBkdsK1IQMllB4enCq2To5nmBTovHfLsxWaEQrmZMxPkD3gARNOguOlmXXoj81fbo4e52devPeFw4hBXcL7WGsJrPk2Tnb/tO3LHZhnH/9MkYHEZao415RkUs5EkoJ5ZbBaRc6NErl607glRJUEmDSEa2P1tBO1AdXTr2V1nmR+V4e3deXWPsRzI54zts5nm21+Je86ix8hRtTUFt/gpmh+UKLyIDXpoZ2pOzt6bfMedYb+jrtCVCI/pvZW/wZ2MigbzHLO5Y73II/xTUHS11mOyWJfkp6agk6mBxmSbr63v6Wn+N9239xoAf6UCEQTdANGd3CW2uLZDBOHrqMevd4KOLk4f1znUixKn7BFKVX+uTZ9YiQ5LYRdRm7PTve2qYnz3B6zkxjreR7PEjQYh2jU2sAnGHNzfDO4mYvevQxUhVHo/Vh3CumGED1Q05O91zfh5qiXwNcwqIc+0kNBE5PuZx1CRlJJgojlP696qW9HYKMh9iGDaUowymg0shl/3t/HqpdFmbqm4BvS8Kki10GKN22pDzNg+/w/WsTVbhzaSQOmw7ObTkD5Mrco2X6Y5F+XtXfdQ2R1QA0kEEOnD8nychYZNdV9E0f1voxQdON00aYvUZBIl7fuiBTojmXJ3i9PugdP2NGEEg+zSaIlbCiUTr5ly3GTHOn7/CQUZImjOpFWmkVl/R1LO3KYYvC/KXP1Gah02l7y4mDySo+LBUVPIOhqAxKx7XbBKpidGe9jgMDIunzr+156
 N2NiMeh1
 MBFQupBi7iCMHnsBuur34hXKWwiTD9ttNn27Mwf8R6ozkb+kpsvO2g8VQhX4uhn2UNbgIfGelekHS4gGZQVZvgyB8kU3vFjVtsOKVuQ5GjNboumR0zS1ebNWQVUb4+pUHZHA3Q+LWSOUyh0tjeNrH/HQlOsWhCnnU8Q/dzjUqp58AuZ3ZQFRCMeyAm05QlAG/ssc1FrelCgNqeZWguQm8IO4dmxYgq+j6d4KY+3LxyMfLuzv0IUF2sJij4yeIX29onZhZr9WcVR3dudAqSAKi2YuRHMq540ofccBXjSZPtRKCUUtuyH/B5bSOtrFm20LOI6Ys6aZddNFRodPgh4j9TJqNBCrifd/bhgQwG72zx8rFAkiAMuHYyWI8lRYGkh71rQG8AyzZuAnY/kE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 20, 2026, at 17:31, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> Teach sparse-vmemmap population code to use the compound page order
> when deciding whether a vmemmap page can be optimized.
>=20
> With this information, the common sparse-vmemmap population path can
> allocate or reuse shared tail vmemmap pages directly instead of =
relying
> on HugeTLB-specific handling.
>=20
> This centralizes vmemmap optimization logic in the sparse-vmemmap =
code,
> based on section metadata, and prepares for sharing the same mechanism
> across different users of vmemmap optimization, including HugeTLB and
> DAX.
>=20
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Sashiko reported four issues [1] regarding memory hotplug, but the =
entire
series doesn't actually support applying HVO via memory hotplug. =
Therefore,
all four of these issues are false positives.

[1] =
https://sashiko.dev/#/patchset/20260720093127.540540-1-songmuchun%40byteda=
nce.com?part=3D8=

