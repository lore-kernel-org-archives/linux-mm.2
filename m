Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2E3CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F156B0088; Mon, 18 May 2026 04:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8AA6B0095; Mon, 18 May 2026 04:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DE446B0096; Mon, 18 May 2026 04:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD366B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:57:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5D718DEE8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:57:34 +0000 (UTC)
X-FDA: 84779937228.23.3180844
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf11.hostedemail.com (Postfix) with ESMTP id 42C8940009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:57:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Pt5rS03G;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779094653; a=rsa-sha256;
	cv=none;
	b=4xSYgd2GxLDJzngdRw0skJI9btkJdk2utLzEqjIvev/Ct9EAKrzbV1mY+7oEBQjqlColLD
	ej/XVMc9LyF4wei8NLLv/gceRKgyFerdm/9UyidGG6DtPLm1aaj4DaAsqsFp9ZXob0yKI4
	MO6MfulD1UCur9oWtD1qKEGoemejqPU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Pt5rS03G;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779094653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jP3zYR2Gd1m9hwwG4m0TQaKDhI1orzMcn5CiNLD3r8=;
	b=x9jAmkkIKHT+uJxdQk0NnS+pQy9OMoCu4D/h9jyD7vjcS/rQBbz27//oG/5y+KPVUmEgXP
	2VyM4fD9bD5mBOZyPaOriS7em/2QAjYfBgYZ4sDIJmCKBzY4+Iwsm2qaLcBtsH7dma6hvS
	Z4wjTzUL8pee7C4FzSteXuow7TgAMI8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779094646; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=+jP3zYR2Gd1m9hwwG4m0TQaKDhI1orzMcn5CiNLD3r8=;
 b=Pt5rS03G03WcUrKHLaQ8U8ZYMuhtCuuLcDz4MnyVqRhBV5yP6Tohl5xIZ2mnkIGHPzXTVw
 U5EgGa1I3CCQajz/YEnNcouYfOCh45Mh1BuQ1Zm1GOTcN5jg/J0I3D1jQsGYGo6uct8AJT
 QQpICpu5SIV4swgI0/aAflSIej6ahE0b3kJ42qBfmr5FSYQ2R/ayB9IKyKrbeDvycLxCR5
 C4BXl5hs+w9zJelDXL/PSBLVVQ7GmSj7B2f+ExK2Eqws/ulbuIoEad64mhU5ljartdTgqW
 D7sMRJGKivRdYJVPt71Jw9wEKos81I4SWAsgXAzFWqJXYcRrTkp8qZd7DbEvGQ==
Subject: Re: [PATCH 0/4] mm: speed up ZONE_DEVICE memmap initialization
Message-Id: <20260518085700.69849-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <agqwZaEtwXg4-O9z@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
References: <agqwZaEtwXg4-O9z@kernel.org>
X-Lms-Return-Path: <lba+26a0ad474+65fb76+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <rppt@kernel.org>
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
Date: Mon, 18 May 2026 16:57:00 +0800
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iby9riteqpekfqp8hjmhoiaqzqrjdmwh
X-Rspam-User: 
X-Rspamd-Queue-Id: 42C8940009
X-Rspamd-Server: rspam07
X-HE-Tag: 1779094651-905663
X-HE-Meta: U2FsdGVkX18bHVkmlycZFh9XyiCja3oyyTIGq0MpvFFg90jwWL1S6I/Tprm0Er8F3Wqezd2ve54vXIAoDZalaTAJvgJWUHe8jiw5UQBULZ4S2GwHKeCfetMYxQMkM6Kcg2GmU1pBhkuGK6j3b2xqfWIQz7rKEeauQfv3VQT9RumuNxd0bobJuQs0yebgZ90/sUzDdKlafCIHw+EqDzhBj/akpeQuyMlwzE96gU/weBKiDRJCkoctrUdgZ0+pMamb8pqS+wZ+DuPqMqCOWEX1IKBHDT0mFT710sRZVtu7h86pVsQwiC50vAH7p4OJfanDs21iA8prN0EKbPoq3LH5KlNIAILxvx8eTw8hQcoSWsV6F8GmcO7wdXRW22mOhgKTEpxv6pF20qKxzzCuFxVzrmnNG7fm8JL3XzKynMl4+nINwkD/Q7yeOpTuIEl/kn68sbqfbo5m7rXylHZoLd1NZBjYrHNjZvQxUAHvtspMwwa8zGC2ZaImOJKgbRL6PPYdCRyZ29/tL8CaNbiROURIHYbrBvlzn+bqtiT55SbLFdT3MpMuzPp51POf5LhpALlrDgJtMVSXlAuqOvZL0TNvgT1lB818VUaV3ozCpTo3fOgHyZeUUlsF18JWVraLzvGaFpDE/e0H4yeltAlqplQtzLLRPFx0xFEApXn66EY0qQ8ccvq/GyTJGtZ+dFnMw7W5isitCfnnGtNZERfVbNCWJ6wrrpWvHcghK9c93wLdYVXXuToJ64qKzVoYWRkiXTlEpX1V20rw45wMSTUV0K0vNSc6DOgMOAxQls5pSVldgKyd2CQknhiapBpwsk+iWXTGqzEj/d7Oo75QI10ulO4Hbk4/CHA2sW9q21LBZnVXF8vfrETWqCWiMZ6lFs/9XRta6JPZwhuUyzpgHofh+nt0dhsM13SbPc9od1dN4DvkWS7iNeOURZTZFTxLUsJbOGlwS02KUrZBK1XXUY+TsNc
 6Agzrf17
 57Taiwc9qDDDjf7n6MtT6OhM9TowXDMXLFYpWG88VSGzPqkbrKwGq6rqqXPxgJ6E1w4HAQiwKCX0LtoVvIVxEviXTjWPOPU5EVfG6E36oR6UL7p29r0dRZ4gVRclaco7ZGZE09cPGlij5XKqtVpxLtdgdGpzlHAE5oROjweW8CikkCaEqH/56iVe4+1A2GFgeBtc6Nrp/Pj0mG0RVsmRg2uKB9fGx7WZhBKlMqQ8x9h8d+yG31wQiFPKuoJZga+BX3oFhGAr4LBMFwqEdVndyuyM18RK6XBSdp2aho8ORtSDyS/5KxIim4doQiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 09:23:33 +0300, rppt@kernel.org wrote:

> Hi,
> 
> On Fri, May 15, 2026 at 04:20:41PM +0800, Li Zhe wrote:
> > memmap_init_zone_device() can spend a substantial amount of time
> > initializing large ZONE_DEVICE ranges because it repeats nearly
> > identical struct page setup for every PFN.
> > 
> > This series reduces that overhead in four steps.
> >
> > Testing
> > =======
> > 
> > Tests were run in a VM on an Intel Ice Lake server.
> > 
> > Two PMEM configurations were used:
> >   - a 100 GB fsdax namespace configured with map=dev, which exercises
> >     the nd_pmem rebind path (pfns_per_compound == 1)
> >   - a 100 GB devdax namespace configured with align=2097152, which
> >     exercises the dax_pmem rebind path (pfns_per_compound > 1)
> > 
> > For each configuration, the corresponding driver was unbound and
> > rebound 30 times. Memmap initialization latency was collected from the
> > pr_debug() output of memmap_init_zone_device().
> > 
> > The first bind is reported separately, and the average of subsequent
> > rebinds is used as the steady-state result.
> > 
> > Performance
> > ===========
> > nd_pmem rebind, 100 GB fsdax namespace, map=dev
> >   Base(v7.1-rc3):
> >     First binding: 1486 ms
> >     Average of subsequent rebinds: 273.52 ms
> >   Full series:
> >     First binding: 1272 ms
> >     Average of subsequent rebinds: 104.59 ms
> > 
> > dax_pmem rebind, 100 GB devdax namespace, align=2097152
> >   Base(v7.1-rc3):
> >     First binding: 1515 ms
> >     Average of subsequent rebinds: 313.45 ms
> >   Full series:
> >     First binding: 1286 ms
> >     Average of subsequent rebinds: 116.93 ms
> 
> This is really good improvement!
> 
> It would be also interesting to see how the template approach would improve
> "normal" memory map initialization.

I also experimented with this approach earlier. Unfortunately, in the
normal memory map initialization path, functions such as
deferred_free_pages() are invoked shortly after struct page
initialization, and this function performs both read and write accesses
to members of the struct page.

Non-temporal stores via MOVNTI are primarily beneficial for streaming
write operations, where the cache lines written are not expected to be
reused by the CPU in the near future. In this case, however, data
written using MOVNTI is immediately accessed again through regular load
and store instructions. This results in an access pattern that resembles
a write-then-reuse workload rather than a pure streaming store.

Consequently, non-temporal stores do not deliver the expected reduction
in cache pollution, and using MOVNTI provides no measurable performance
benefit for this particular workload.

That said, a template-based approach can still accelerate initialization.
Based on measurements from this patchset, it should improve performance
on the generic path by roughly 10%. I would appreciate feedback on
whether such an optimization is still considered useful.

Thanks,
Zhe

