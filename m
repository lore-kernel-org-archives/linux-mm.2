Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED6B5CD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 12:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514EA6B03B1; Tue,  2 Jun 2026 08:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C78B6B03B3; Tue,  2 Jun 2026 08:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5C96B03B4; Tue,  2 Jun 2026 08:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27D8C6B03B1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:52:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E23FC920EE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:52:07 +0000 (UTC)
X-FDA: 84834960294.02.1F5DA38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 48D3B40008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:52:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IiXf1nVA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780404726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoEDHLDPjah5bpcTq5+xdPnUnkR+I3T5o+EEfuYH6c0=;
	b=6TrkUytBbBnxz4MHFKuycZMSHdBeU0NVWsLQ/f4sY3D6RKJJKLWDSXVUqcDSS+i0oEQbj0
	8eT7FKU/SUuEVCVyWl91NDNjOF6EbkFKSC1tMfMRTaRK11MAlfTZmeWIKqrdXyqtqO6Yqf
	aBDq2jvJUFdMYCpbk85RtFR6uSU0umM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IiXf1nVA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780404726;
	b=kF5tR62H25cekBuqAZsy4pZTuChQPBTmCEzUM+A52hJjdyGQ2Y9cr2zQruU+3HbJ52vN0z
	xyEDu/J/OJNgE7IMDSTtHo/RLQtOTBzuOJvTjA9z2Z1Di/t0z1Jxs8vgr2KWv5i89EDA6P
	AlrwQzMQbtWp/5pCtHaW6ciGmfNITo0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BA1043E7A;
	Tue,  2 Jun 2026 12:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8561F00893;
	Tue,  2 Jun 2026 12:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780404725;
	bh=QoEDHLDPjah5bpcTq5+xdPnUnkR+I3T5o+EEfuYH6c0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IiXf1nVAnO6t8NjlmzVhB2FDUs+qCYUsODkAWZ8sJTmk6a3lKVlf7tG67+VzbgBNQ
	 J7k5dqFFIF6+G5gn8Eq+IwMN4aNjsd2ONhT4EHoruasOEleK7cSmsQB4YdlAAqGEz5
	 4FFIzpTYiIeOCxlkgCfydz5dzQERCV/6b4kvoHr8KvCEruq64LWvoxFZdT6q5i006q
	 iwkVYLG0Ss7xNCtzrvg/VjiGJkSmKi+s2M36PLANDh6Y4h0ZjEEtyAlvpn63SbHQ0l
	 Jjk5kCalZ1XzlknpjzXB5XVn3uybFmWbzn4yCt1wGKZNiOh2bkPsibCvLd99WXllys
	 7B1hR1+e6qUMQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
In-Reply-To: <ahyDHVSH5eLsnp3C@kernel.org> (Mike Rapoport's message of "Sun,
	31 May 2026 21:51:09 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-10-pratyush@kernel.org>
	<agHGOxSnP_VraH1M@kernel.org> <2vxzecjhc2s8.fsf@kernel.org>
	<ag-a4ru9bMkDMthO@plex> <2vxzse7j7ai9.fsf@kernel.org>
	<ahyDHVSH5eLsnp3C@kernel.org>
Date: Tue, 02 Jun 2026 14:52:02 +0200
Message-ID: <2vxztsrlds0d.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 48D3B40008
X-Stat-Signature: nptgiwm8g6e87w8pymcdg76w58r6h7x3
X-Rspam-User: 
X-HE-Tag: 1780404726-442390
X-HE-Meta: U2FsdGVkX1/mu9qUR+NJOImhYTA3mY1tZC5dnVNS39idFNpgbLHUaznCjrf+Zud6lqU2NbI3MduAul8roqzRptnMbDOFjGxYi5ccN8/u1cuw3eSdQoLSA0C5+Rhj/IZAa7vZYOpg6zlo68U/FXqGwe+HNdcDLdG1WknxoXM5OR91abQDGDfKtynFsC8it7LGRyVuIkgufcIGG4D9mc9ahc+swMibRZNTaOlbaoqSKlppWHL4c3jlRZBmhXZ4Ln3pJqdy5oPGxtPpUTSWjHNgiuoMkXqTNVRyWgMjPUGZrkBPmuMq/yV/jmCN2S5loH9onQZQTvUaTLsW7WBKL7GYv1hVnsdpVFbZxWC2oDTeImCcioFfkOhDkOoLGmcIuR1JKu2CWTnKewnSkHpwpg1NfYggNUzqZhXx83B0Pxg0GEiXZ/5rMvuj48wpJ7XgwJGzc+naf+ylhbnrJZEgn6/hlznGRTT3h+ZQeUYv+19/Imp4ZNbezHFBaPrUJNZspP+bqhigLlkt9o/QcphZXtMej8Wehahb0zj1j412XFKD2FqsxwYGW2HZc6DCSkLBGXFEJDU573QEzLjeFW3l8108gMazTMWHVSeuaBwwgwGjf108FWWgz6YYktFcmhOG9ZcMxaqZOd5XujTyYVvbP8ztgpmbGArjcaRXbPKus9jZImmeutwmK4546D/Np7VUjTuJPuPEJrOPhTM044McMjZfcWNJ+nd1YgXTqRqffVYO0vUqj2CmZXJURI1OsWQD7GIb4DvVodalfARcsyYxRLLaLBZp8/BReTJDuhohQFI2p7qwG8Ne6B7njjOOmEUTC7AuzqFX9P+cZEmwkGw27H39NoSOX4lB/sdFDd2xoyMDTTmOqIL+OYVsdy04Zfdl9WsVdasxHQXZOF9ItZ4cRmIduwzF1m7eGdZ6oF/Jt9sN707Cy3Qt7xz+BiniWAfPPVP277XVRsMLuBHc9ETyVCE
 8mSU/9ji
 Xv3hMbn16B1vxcGoDD9x5WzLaj/jx8sB2Dw7yXAqWRecu8KSHouNi9SDdp7a7UIFHOQBEXsjxrkpkdIGaolqgMt3Ad1544OenFOjrK8ROobFkBMrdxXWeLCKj5ZtrjfwfCBv6X1BgeMpkHP4FDhLQg8l6RRM75Ea3aIi9IvLVGDArjKomMfhzhZ8rsXA3u7N1n4RmC+ELWlQJeuz9k6NP5jiIyAWLWxLAbwipRyOqqxPXc2xWsTLAfOnMNdlzWC3OR6vtkVcd6Jze6cYBl0oZo9+heElGi6oHSHPC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31 2026, Mike Rapoport wrote:

> On Fri, May 22, 2026 at 05:02:38PM +0200, Pratyush Yadav wrote:
>> On Fri, May 22 2026, Pasha Tatashin wrote:
>> 
>> > On 05-11 18:46, Pratyush Yadav wrote:
>> >> On Mon, May 11 2026, Mike Rapoport wrote:
>> >> 
>> >> > On Wed, Apr 29, 2026 at 03:39:11PM +0200, Pratyush Yadav wrote:
>> >> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> >> >> 
>> >> >> In the upcoming commits, the KHO will learn how to discover free blocks
>> >> >> of memory by walking the KHO radix tree. It will then mark those regions
>> >> >> as scratch to allow memory allocation in case scratch runs low.
>> >> >> 
>> >> >> To differentiate the extended scratch areas from the main scratch areas,
>> >> >> introduce MEMBLOCK_KHO_SCRATCH_EXT. Use it when choosing memblock flags
>> >> >> for allocations during scratch-only. Teach should_skip_region() to check
>> >> >> for both flags before deciding if the region should be skipped.
>> >> >
>> >> > Why there's a need to differentiate SCRATCH and SCRATCH_EXT?
>> >> > SCRATCH (I still hate the name) means "memory memblock can safely use for
>> >
>> >  +1000
>> >
>> > I also strongly dislike this name and mentioned it in another thread
>> > earlier today.
>> >
>> > If we ever decide to s/scratch/something-else/ globally, that should be a
>> > separate cleanup effort. However, since we are introducing a brand new flag
>> > here, we can discuss a better name for the _ext portion to avoid overloading
>> > the "scratch" concept.
>> >
>> >> > the allocations". Initially this memory comes from the reservations in the
>> >> > first kernel, but if the second kernel can find more memory to extend it,
>> >> > why that additional memory should be treated differently? 
>> >> 
>> >> Two reasons:
>> >> 
>> >> 1. We mark SCRATCH as MIGRATE_CMA. We don't want to do that for
>> >>    SCRATCH_EXT since this memory can be used for non-movable
>> >>    allocations.
>> >> 
>> >> 2. Gigantic (1G) huge pages can not be allocated from scratch. They can
>> >>    be preserved memory and thus should not be allocated from SCRATCH.
>> >>    See patch 12 that does allocations for gigantic huge pages only from
>> >>    SCRATCH_EXT.
>> >> 
>> >> I will add this in the commit message for the next version.
>> >> 
>> >> Naming is hard, so if you have any better names I'm all ears :-)
>> >
>> > IMO, this scratch_ext is not "scratch" in the traditional KHO sense at all.
>> > The traditional KHO scratch is what is passed from kernel to kernel and is
>> > guaranteed to contain zero preserved memory. This new memory is not passed
>> > from kernel to kernel and can contain preserved memory at runtime. It's
>> > essentially just memory that we identify as currently unpreserved and release
>> > early to the system.
>> >
>> > If we want to keep the naming aligned with the existing codebase for now:
>> > MEMBLOCK_KHO_SCRATCH      -> original scratch
>> > MEMBLOCK_KHO_UNPRESERVED  -> for the new memory (instead of SCRATCH_EXT)
>> 
>> UNPRESERVED sounds good to me. I will use that for the next revision
>> unless Mike objects.
>  
> Can we make it shorter? ;-)
>
> UNPRESERVED makes sense, although I'd love to completely remove KHO_ notion
> and make the name reflect how it's used by memblock. I was toying with
> PREFERRED instead of SCRATCH, but it didn't feel right enough.
> With two of them that surely won't work :)

I don't think you really can remove KHO_ notion. These memory regions
only make sense on a KHO boot, and won't exist otherwise. And PREFERRED
sounds like a suggestion/priority hint, not a hard limit. "With KHO
boot, you can _only_ use PREFERRED memory", doesn't sound right...

I think MEMBLOCK_KHO_BOOTMEM for scratch and MEMBLOCK_KHO_NOPRESERVE
(which I think is a tiny bit better than UNPRESERVED) for scratch_ext
are my top picks. To make it shorter, perhaps MEMBLOCK_KHO_NOPRSRV, in
similar fashion to RSRV_KERN?

>
>> > Alternatively, if we do want to tackle the global rename of "scratch" later:
>> > MEMBLOCK_KHO_BOOTSTRAP    -> for the original scratch
>> > MEMBLOCK_KHO_UNPRESERVED  -> for this new dynamic memory
>> 
>> Or perhaps BOOTMEM? I suppose either of the two are somewhat better than
>> scratch.
>
> Well, if we have BOOTMEM_HVO, we can have BOOTMEM_KHO as well :)
>
>> Anyway, can we please do the SCRATCH rename as a separate series? I
>
> Sure. We can continue bikeshedding in parallel.
>
>> would like this series to not get muddled in the naming discussion. I
>> will use UNPRESERVED for the new concept in v2 though.
>
> That might warrant v3 even if everything else is perfect :)

I can live with that. As long as we can agree on the easy part (the
code), I don't mind doing another version for the hard part (the naming)
;-)

-- 
Regards,
Pratyush Yadav

