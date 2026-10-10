Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B6BCA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 09:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6346B0088; Sat, 10 Oct 2026 05:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E596B0092; Sat, 10 Oct 2026 05:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2471E6B0095; Sat, 10 Oct 2026 05:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 047AC6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:33:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C02D160811
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:33:20 +0000 (UTC)
X-FDA: 85306203360.02.D42FC57
Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	by imf29.hostedemail.com (Postfix) with ESMTP id 919A4120003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:33:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OyPnlKQX;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.99 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791624798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJo4tkODSAwLEOEkEK57eCbPFUflApjAg2dMJ+9QYw8=;
	b=OudCpkppHgL8Nb1Q/hg67HL7eTjin+KvbMTOVxGpyU0uP0ataPH6hIpOMweaqx3IG1kCSD
	68+w8ZdmW+SWf4P1DrXujvhZ7QXij0V8cnurGPzdqPpNhWIVwGu1VvBF7xA4QGbNqSoTMF
	djxRFKIpIXA4tuYAqeavngNakXGHWKs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791624798;
	b=A4E0LIT7TxyBZyJNKez/UPzPJ4ew7bin45kkm2TaFWHac2CrW9YES92qbir5typTG9zHMv
	cSzoZl9N3afcmFkFIIhtVG5en3Ui1ObizxVBscy9Sioe+bNb064ZKocIIiP2Cc9ViyThQY
	daqOo7PWd1cb56KKpoq+do/sn6tkDFM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OyPnlKQX;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.99 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PJo4tkODSAwLEOEkEK57eCbPFUflApjAg2dMJ+9QYw8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791624797; v=1; x=1792229597;
 b=OyPnlKQXDU0GjsJLx16l/N7aNyV8TV32uB9UZukrSCGkeF5RGj1NCuGGupG39RNppVPtQ5oN
 koTlLvsrJdtPj2rdeTmh+Tkf1ycbtOZ/cj0LLQ3sQemFmRfdKOU0jgiJ613ClP4P1Y1fShzIAWH
 IWs1Ig2eykQZ8GcgtKNfDXvc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ae1b224da00926d1;
	Sat, 10 Oct 2026 09:33:16 +0000
X-Mizu-Trace-ID: ae1b224da00926d1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v4 6/6] mm/mm_init: add zone mismatch warning during page
 init
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261010075755.83339-7-songmuchun@bytedance.com>
Date: Sat, 10 Oct 2026 17:32:59 +0800
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 Lance Yang <lance.yang@linux.dev>,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <434B0573-BF18-4413-9BDF-C5873CC13206@linux.dev>
References: <20261010075755.83339-1-songmuchun@bytedance.com>
 <20261010075755.83339-7-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 919A4120003
X-Stat-Signature: rhxbrd5677u6zsnyijr3uizbtzxbaqe6
X-HE-Tag: 1791624798-592339
X-HE-Meta: U2FsdGVkX1+iSWnciH4Z3aHpL/cl/4b/cUpqY0AFMLkqlkzPakI8/hyfWN62GmTx0DbkBYdo4l6i8i3E+EzPj6iYIYSObkKtkXEEN0cNjZbg+3EvpjV4i69+mTFpoFVx4GSp2HtIDFQVfurYbUhgl15KjXPX/4FwVDUNFWXNsdntkCrgn0sbJnXZALdIzszJNsTlID9SLiCbRYbzI38S1l/CCortLbuoD0v8kkgRPAylhCuzrABYc1/CrB7AvhqlvvWzmjnGxGcbR0DRWoGUjoB7mKoaJw+zDN7JD7sNgiPuWJoGLm8bxrDMPutRfkNV2O8P8ickiGkEnkzAsjnwz+KRDJMgE/+eGXSsO0BeRm0ko2duE4FpO+kZ8MqVi8jTalUtPOOg8k8mWlm9AdS3lvy9W+1YFIXgloxNOOXCj/AlhzaVOhqqcwyZ9M+MYNik9+FJS4Csh38+RvfU390+JSVnRmT4zWb7jBqotV9GMuTGQaqO7Ti0aqhljdvOrtOYbIj4RrUCDNL7U7dbRjW07frW3ue7PoPl4ozB32fbF0bexcDpE4Wc5ReMyFqZTOPiC44eKg8CnxY7Td9iXzQfDUFNBMwF9So3Owo5mn0xeECu6lO2AXPKWEwixinQZn1fbYWQTnVezStKsYTJ62Eb+z3W7wxypLTowcRpqMankNnXDoufw7nRf/vWNct7hb65snB1bp/N2lbF8YD0LyGLnFgFPdspQR84Ko1m0hsAdqpqKQrxc9d66Po3TMw5XOGbXtIZcEM8tyRUTFGDku77ZXWVooaLjxkm9g8trPdnjW0Nn/WK2xdxx59fYSzi+oR2le9j5LR0TaIaLsxUhYSm3uGL2XIw1wOHLH/O9gpQZ15YQrXa/br1Z8p0xedVmAFRQCSjTOObi8Ht72sSq7K1N0JR77b4dAEMFnwy/XxJFJ06wQfIv+lUDOA043kf6wm4z2K5ghkGFF1ARF5UlJW
 MmNYfd60
 Va647D80k7XijU6sBqmS/YKTxgX5KmazabEY5ujbM0NxnYa0RxCgd+3/hrg3YNudUnbkD744O9qi8V29UK+ikGuPT4inaxNmZALdm5CsF4PiKXLqBPJNB/YH+AmyFX1eViqeUu8SsyAm1g/u2PwFcAArcX4HweSZGFCr76nHY1/4F8M2Z+5v5qy+0QAKQgXDB6VD/8s1nGO5lv3jPeD8najYwDUdoW7pQ546JJ5D/DbKuBhX4p1kliZ0yW2WWOeyRQng7jw6Fb/ARqFL1NyGfz8Ns7qWmlos3ceC158/3WbUlArxD5ugUm2SUrjWJYZPABAl7BwFAjQtIGAUI8EU96KBboZvoDtqWWv/YLcY3dE9tOWvLKmYrQIdlQXNpHmbV/b8I5jenjOvzzI5RjZTz3ilOxQcTO+HBGf3tjpiIy7sCcktssqHi4hEChxGIuL2s4bBLZGOM+2X4ofwn2w+Yp/nTUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 15:57, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> For vmemmap-optimized sections, tail struct pages may be backed by
> shared vmemmap pages. Those shared pages must carry the same page zone
> ID as the struct pages initialized for the section.
>=20
> Warn in __init_single_page() if the shared tail page has a different
> page_zone_id(), which would indicate inconsistent initialization.

Please ignore Sashiko's report [1], both are false positive. It didn't
realize that shared vmemmap pages are initialized early before =
__init_single_page().

[1] =
https://sashiko.dev/#/patchset/20261010075755.83339-1-songmuchun%40bytedan=
ce.com?part=3D6

Thanks.=

