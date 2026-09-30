Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79BF2CA5FAD
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 01:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3699C6B0088; Tue, 29 Sep 2026 21:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A986B008A; Tue, 29 Sep 2026 21:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230936B008C; Tue, 29 Sep 2026 21:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01E586B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:26:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8625780658
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 01:26:32 +0000 (UTC)
X-FDA: 85268688624.19.EEE79E5
Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46D5FA0004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 01:26:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDOIv36O;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790731590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCIueztMn6qtMBchJfx2etXVyYzxHf3iBKEIk5t2QtY=;
	b=I1/Q5Zmhp3odGXLZgdm2GeP2FvGo5pVSll9vX/eLjR1TWsNB4+jX5JysB8+4EDm2vimRl+
	2YluJBB4Ch1i27EE8NrXHdL0CHveb4FL3bqAv8DDQpScKokAYpwW3Fuc74XK7MSHg+oMtX
	HyZ9bi0EK3dp8j9cOyQ+bssootKFsTY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790731590;
	b=XRJnBbQk37w0aEnnA6pA5e5VdUrzDqbqzxMQwNzqsUL3d6iREtm5kcqTTDv370oOZiAc68
	BI4nrK47O3Cc69USnE1dvWq1xzz66JEHS+T04aaO3rF5dwz3wnSd+DMeE6neslEfxriWOL
	LF6KzClwC4j78T85iKN9U4tpkwQRBus=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDOIv36O;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IQRBqTSVWWALaW1mPWAac9TGAVH6p8Unuj/FQbT1y4Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790731588; v=1; x=1791336388;
 b=WDOIv36OO9lrltIsdKn1p/Dl5TCsZQOqtzhZ8Dh1WEGBKT/HjfCUvVmpfOfIXp1XoKlaFc5q
 Z3PVdE5TDYrfp7jP531Qv+J/ZtxbQfGTyP0S81oSGM/0+/SL5QyDC3zfxAlgMxdGtO07+QVXXD2
 I9GSrh5b69ZqKxDrURbeoZXg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id c8969253a912e5f2;
	Wed, 30 Sep 2026 01:26:28 +0000
X-Mizu-Trace-ID: c8969253a912e5f2
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3 0/6] mm: Unify device DAX and HugeTLB vmemmap
 population paths
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260929143214.9061bcf284369163192968d1@linux-foundation.org>
Date: Wed, 30 Sep 2026 09:26:09 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D1333E60-93C8-4459-9CC0-48D6F10D3EC0@linux.dev>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929143214.9061bcf284369163192968d1@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Stat-Signature: 8rix9jm4w54u36de6eaj9fbqa1pb57uu
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 46D5FA0004
X-HE-Tag: 1790731590-667642
X-HE-Meta: U2FsdGVkX19NId6Jak3gjw/K8n6PnR+FS+l175dKKffnOEmWwk+VTnLbRKqdsaF1lj3gJFpQCpuFBB6DUqIM+XiK0EMiwJq5kt1RT52WZOA0g8i0QGUcT3kiaOtYyBnV6+KfYw7ANQV9Gj8y3z8D1zB+DNI/iBi8EH4nEq8LBoHppTG9W6Sqf7VCM96dMbqxEglOOzfYXCVV9DvQ81O+5auM8OvbRCVJ2iUd6AB+8OtCMnUuoQd32VVGMvr8FSgy2WKic7QdQ/01OCfsRCKGkvkU8kufroledyeEkefEYoGzZKY4CrwKbNHXNWmuEykjzM3FYK+cWAVl4+vH41TqoFPdSx39ivvUVlNWqtrTbF5HeEb9Amsa84K59HLbz4fiF+IWJOYp6fi4EVCGG7yzIBcCT7VNJaLGRehd8W4p2D7231NIUdSxbIWQGFhhvmWJwk1B7Cn/NMyEl8jol3oKp60b5fRRGmL2AdX6y6lUy/9x7uXotHOF2EvCYwQaCjcsdPEWHZlCmLYwCPbwvvNHKFlwBQWg3YleIxoi4fQQr00u5ZDKrA4/JyAtnTVaQk3DnqqXTmYSDZ40brj41049FaG/Ytl/JHdgfIbUX2lP5ZrIqQWxoEb2nVPQJ3IPal7nFMbGueIKCdbpN7vdRUGSSxQIblBSFvMPzW33W0SbKzJXrkAcigfDlKwqSvP2sdAzovQ2+OG7S9qdZ/pzMAimUdhJyACezQNWz1gfkpK1y6zN+1F7tOYyEaGsSpv34oFidppKmBNknnIw8iYmCgKtvGCtW3Uzd0TojeHOzkh+FVinglFAOq0r+YaTomr5rzMeIIPslZKGGHHYXHOd/m9U3LFIgWb2g0COugOEnNcZRg+JuhsRmm1xeNlXcsb2RYHcwgFtpLYRaCaXJNlCG32c1DDeDsKm0asSURgzz5wEhZvfbChy64TxZc1hhHt+KcNWYSXhYU6dvAcD1sWNCMW
 K6aKxl5U
 S8Xb6HkRzcfEvdDaUO5vyOCvhTSDzec9pQ1tWs8vuq7vLA+7q53+FIb5vqUAZbmj1d3pcXRs3zZ0WS1Lc/i8/b9bqy2aU/l7oDUAL4em9PgUDc5cn/EJtGBH2BHt3QfmmRmbdWHlf6AewvzGtljuV/Wr0U6Gtzhi9rp4PskwwvAdo1kxr740PJLwpUBvSxAD6eUIoYkixZN0QRxvsSkU5NAEg8mCkw37TOXlIgptQnEBY9TskjcXsqk7+Xa0KisMa5WsnU0/peT5r2Yf44PZuJwgI1rWxkgUEE+6VBiJ8TVyq156D6IxpBwEAXnQwxHegE1Ay+xckj1FOZt3U/fS+7R6wN2TfKJknCqm82uE/EYwmEQtk9nsjKvS4Ym0dbTEL6bntDlcKjvNuIYVzC1+TetOb7G7ovf4jUJIXZ6x05iR/rVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 30, 2026, at 05:32, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Tue, 29 Sep 2026 13:32:25 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
>> This v3 is based on mm-new commit 2ddb90ee544a, which contains v5 of
>> "mm: Switch device DAX to section-based vmemmap optimization" [1].
>>=20
>> This series is split out from the earlier, larger series "mm: =
Generalize
>> HVO for HugeTLB and device DAX" [2]. While the parent series =
generalizes
>> vmemmap optimization across HugeTLB and device DAX, this subset =
addresses
>> a single, self-contained step: unifying their vmemmap population =
paths.
>>=20
>> After the preceding Device DAX conversion, both HugeTLB and Device =
DAX
>> describe optimized vmemmap mappings through memory-section metadata =
and
>> use per-zone shared tail vmemmap pages. The generic code, however, =
still
>> carries a Device DAX-specific population flag and compound-page =
population
>> path, along with arguments and helpers needed only by that path.
>>=20
>> This series first removes VMEMMAP_POPULATE_DAX and moves selection =
and
>> reference handling for the shared tail page into the common vmemmap
>> population path. It then removes the generic Device DAX-specific
>> compound-page population path and routes section vmemmap population
>> through vmemmap_populate(). The powerpc radix path continues to use =
its
>> architecture-specific compound-page population implementation for
>> optimizable sections.
>>=20
>> The remaining patches remove the unused ptpfn argument, open-code
>> vmemmap_populate_address() now that no caller needs its returned PTE, =
and
>> add a warning for inconsistent zone initialization of shared tail =
vmemmap
>> pages.
>>=20
>> This is the fourth smaller step toward the broader HVO =
generalization.
>> After this series, HugeTLB and Device DAX use the same population =
model
>> instead of parallel generic paths, while powerpc keeps its
>> architecture-specific implementation.
>=20
> afaict the whole series is "no functional changes intended".  Apart
> from [6/6]'s new WARN_ON.

Yes.

>=20
> And [3/6] is the one which could cause unintended fuctional changes!

Understood. However, the resulting vmemmap layout is intended to remain
unchanged.

>=20
> Thanks.  I'll queue it.  Reluctantly.  We're up to 688 MM patches this
> cycle and it's time to stop.

Thanks for taking it despite the load.

Muchun,
Thanks.


