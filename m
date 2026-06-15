Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD620CD98DE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 08:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06DF76B0005; Mon, 15 Jun 2026 04:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F556B008A; Mon, 15 Jun 2026 04:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4FFD6B008C; Mon, 15 Jun 2026 04:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D4EA16B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:52:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90516A0953
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:52:57 +0000 (UTC)
X-FDA: 84881531994.18.8C5DF74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B9A30180008
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:52:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewQFWwyg;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781513575;
	b=N3oXRKn+wScAAky2PlfeRZPbP5ZeiZFQsKr8+mPweUjJJBYbU+KgDSr2RA5bNP2FmWgZkP
	l/46tYMuhW07Wu5O4U4ISdzOfGedxcs8LJYh5YoteND5PYw7MvyS4A6M5iYU5MxVUld0dI
	IN75DFoT6T/bXxNATK6zbu88ve+Bdns=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ewQFWwyg;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781513575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0nmh4n8OK2kmhJCZ0gvPcKvVFFqmHfVbiE1li979bk=;
	b=bDPgYmjq+I4XKZHQdvCYsdICRlNjVWGn2P6G1NxH6yvL0Ld9cDg3Mkk574gS6gyHjz0joS
	xOtZkC5ft3u3JVAM3X/7rWj7HHpjswrJpqRmp017qcCTqOtOP8IeNJkOUsHqGIvyv/sJn2
	7Jz01u+6GuS+rASSGnoKTHe/ysqXoHs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBD6344255;
	Mon, 15 Jun 2026 08:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47ED61F000E9;
	Mon, 15 Jun 2026 08:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781513574;
	bh=r0nmh4n8OK2kmhJCZ0gvPcKvVFFqmHfVbiE1li979bk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ewQFWwygD+69bmRiisV0lUdrbdqTMDJF5t9OWjDl1tRpbBeUrUmkHa60LypyOvYF2
	 hzvirLnXweCCqO5jHf2welYVGNntxwNNJRuJ+GrufjNY06LsXQ9+DKRgbPPXq+y0zL
	 WUKiqTtCEVwZafLR4jmWA4TNcQCMqIyhsWLTopNEZOb7pzpIh0Lxcgdf8whvcu6GLA
	 qy+Gid7McKKg4ztXJgO7sw6l5wahjcCiRbFloEhHDglDhPUdHOL4jimfmDEuC+KEIt
	 A9lhM7FHSG7CexjXtIppyPaMw7IWGVhSAh3xV2SIDyqIRO2WVlIe3U0qM3rTislIBE
	 eOwjFpmKgzPfQ==
Message-ID: <e4496401-6529-4f64-ab5c-84f737cb6798@kernel.org>
Date: Mon, 15 Jun 2026 10:52:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/16] mm/slab: do not init any kfence objects on
 allocation
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>
 <b6530e92-d648-4028-9e77-0df8c3ab166d@kernel.org>
 <159d1e20-5b21-4329-ac9a-f7a5cb0fd56a@kernel.org>
 <e71bfc13-c233-4f85-a6ec-76327d3c6510@kernel.org>
 <74adf668-78c2-4989-a6c6-c6ec7bd68855@kernel.org>
 <4cf98483-ae35-4ad0-8f77-5a46194eb65f@kernel.org>
 <CAJuCfpH8g9mNGV_ke-mhVZ=J9J05PZg-ozPTA=5WQrm_eViVpA@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <CAJuCfpH8g9mNGV_ke-mhVZ=J9J05PZg-ozPTA=5WQrm_eViVpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9A30180008
X-Stat-Signature: se4wxrzjg38u6a3skisrhkrh43p79eow
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781513575-52223
X-HE-Meta: U2FsdGVkX19XaJQTVEtD+ciwqkFxprVmdSOYmay0rR8ctHZqBumIlicxEZoJYGN1DNqWqajs/esbZOwJQciZgLyOkkb3gRS03x0xHWZS0IPTYQVRSNyVWgEmHY58cEtGMRwHVANaqcO1KPecIWT3yAUtESREm0sbglDDp0uNod7pJT/ObX+K6AYIyMuSJ0CMXsOlZ4lwVeEwjgu919Mkeh0BUpLsWkptWosrFlVRBgAqVC8zCpDHXt/kIcRR55BPFZkZPwWC/mcqH60xJYEjDroeTRK5gKeRUNMisUfH1X5aFDJGITWYWtWrO6Jafir1KSavkQxtsCmKZ/ioKenP18dXpa25ZkC5qX2RHqQMKt5gZJLYPa4Rrm995ZupjPa/+bPjj02FDuKp42EqytApVzKzq/VgpjbhT5vXU0ZFJk8t6+00cdtp+kxN7vUIPuBC/2qIoKLWhGGGfrHc8yxREizlXdoRz+PoBivPHzkBUSc2Svm7LU+CJA8grshIpeQWTOa8xGEFFNtng8qmC7LKUDV0W3Dudd+vZV1LxGOgkLut/qQpF58SlVqn8ZSCZgLn/Fg6QFd+hCPZ1O1/OQIm2P6iMGVffll3a07MUBcyyJBDo0n/uQyxVTnQRh/4S4lqhZQNfq1e+bW5l6Nc0RwHNRRER7sQbXpqkJ5+2lAS/8yCS2ep71+kmiHQNlFG1SWPKSadZSxFzUUCwfYALifNhgZ3PQmQhCjteBZvexlSZ/FIwNgeFZ2y0FYew3vPsWJGb1/GxPQucLyULWAo+IEUgs+xeqiQ60T8GPgNBGIGqD6acN5tVGP8fkCe4XCTapt+KAyd8M18F6sWeBVo/zkRqfzUJ1GrHo1GDmQ6mNvQ01WAZzC6iYnVFipVaQOLRXs0UjhGZZCR7xX3GzICFkPFVzQINcWcqt/6HYL/jGKfoawqI86A5PKzFOIfvYDC8U8C/BXarcBcntu4Z6td14G
 Rsu9sPQt
 ncstSU7XqKYmy7GN3lPTEhaJy0+ECuKgAmd4DFPsfNxuCxGjiI2yf5gwaTXvOGjgJCZhGcNTbUrSKLSTRUtXImz5H/FTZoThr8nQLbcbzu7JcaemI5TczQ/rDNgGSYBrNM3qcXE/TeFCZJhODgv21p15xJbitWT0VFwnM2OZAqRfqd8VptC4nqggqPv7OwSh6GSyI55gckBipbCEP+NGKG9LJl/s1yN6OerMTMf4OVQ4qiclU5NfdIMDXkHfQKl8eJ4b5qj84s8GaoNo6XJU6kBXZ5sV/+u4QSXEghQYllxz1PLKGpY/E/O8czJVwoMzGQILucKDLpf1fl4IOMNJv8t65zklqSrlByAZzjlpvaQiqCjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 03:28, Suren Baghdasaryan wrote:
> On Thu, Jun 11, 2026 at 9:37 AM Vlastimil Babka (SUSE)
> <vbabka@kernel.org> wrote:
>>
>> On 6/11/26 17:11, Harry Yoo wrote:
>> >
>> >> From 3a1c4398ce9f361a4e6f4d9946eab6237eea89c2 Mon Sep 17 00:00:00 2001
>> >> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
>> >> Date: Wed, 10 Jun 2026 17:40:04 +0200
>> >> Subject: [PATCH] mm/slab: do not init any kfence objects on allocation
>> >>
>> >> When init (zeroing) on allocation is requested, for kmalloc() we
>> >> generally have to zero the full object size even if a smaller size is
>> >> requested, in order to provide krealloc()'s __GFP_ZERO guarantees.
>> >>
>> >> When we end up allocating a kfence object, kfence perfoms the zeroing on
>> >
>> > nit: perfoms -> performs
>>
>> Fixed.
>>
>> >> its own because has its own redzone beyond the requested size. Thus
> 
> nit: s/because has/because it has

Fixed.

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

