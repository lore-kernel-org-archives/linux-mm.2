Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D115C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4577B6B0098; Thu, 30 Jul 2026 07:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 406C06B009F; Thu, 30 Jul 2026 07:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F59A6B00A0; Thu, 30 Jul 2026 07:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9B96B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:53:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95F3CA0049
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:53:25 +0000 (UTC)
X-FDA: 85045282770.23.48E96B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id ECA6F1C000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:53:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tcq/3Rns";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785412404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RI2GUexLmVv8gB7H4ZANPJBiidvoccuLoXhfaCBsWjs=;
	b=A+r+fPf5fGEflXvu680Lb8rVyNrFPLIvGjG81PUXVdakfA48hnznilyIIgPC2vW+6xyF9y
	Wr86rqUdrWP3Rcwx5pTvXS21+SBOCJHI8mX343n2L3aw1nnADjnwi+3TPM5cJJwBjkRsx/
	9OtTxxjXJjYe2ncT4LE0mp9siQLWbRM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Tcq/3Rns";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785412404;
	b=VVpGAlEQSqyXqj/bNJSjMdXO/cdO6Dsx9vvnqwO7KxRu4pO77Dk9sDdvmAB8aYalw2xKO9
	Ff5zh1iDNMZqDak8A3M1niwAuyqadIYnSqFbTLJRUF9nOOTWwuBx4/ANomXPErBOgYG2PK
	R5Yk4mVoHYE+wSrz04zoeWpxoNj+6qc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 187E640D9C;
	Thu, 30 Jul 2026 11:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A601F000E9;
	Thu, 30 Jul 2026 11:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785412403;
	bh=RI2GUexLmVv8gB7H4ZANPJBiidvoccuLoXhfaCBsWjs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Tcq/3Rns1MAd8B1/L7Wt94PX9kJJUcT4EbttzTvK6Xl4qi9iy5hsl+eRMHNOV3hyi
	 /Mk3gix0qtRSRs/M1JUAkS7jHYamRkTtD5ZpR+TcB414J/21Bwz71T3It8uHKHCFkH
	 QW0ZDT3X+9Qk+L70kqoIbLrxuzWrcnNyHtLchES3uGmkDtv4eGB5kmHhcwTUkrohoq
	 Rj0z5pYeVOfsbvzeOsEFaFU/StIg8eEmEJgRLNxUObJaaDwsS88WYePIxYM8/2+weG
	 ylkVcgYkRtbkOoWdIy2v20zBKgRNt04rKm57oUuBTg0pIgXPagEFhf2TLzV6LeKE1R
	 dT2OrncI5cJSA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 17/22] mm/mm_init: don't rely on memblock to get KHO
 scratch migratetype
In-Reply-To: <amr8ADvAiJE3ZYKF@kernel.org> (Mike Rapoport's message of "Thu,
	30 Jul 2026 10:23:44 +0300")
References: <20260729145610.2827231-1-pratyush@kernel.org>
	<20260729145610.2827231-18-pratyush@kernel.org>
	<amr8ADvAiJE3ZYKF@kernel.org>
Date: Thu, 30 Jul 2026 13:53:19 +0200
Message-ID: <2vxzik5w7ky8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ECA6F1C000F
X-Rspam-User: 
X-Stat-Signature: 9djc6fysy8cfipj1iqzwetsdmbgao6ry
X-HE-Tag: 1785412403-193105
X-HE-Meta: U2FsdGVkX187291WYG8hdBF4hxJ6u2KzEbUPSQ2nzvxLY80VCj3QdAmXs2GhKz5paHJyQfwvYmUb6tBU8hV7NJ/f0HuSM2qEpT1fFaWcx4iOJETszegLUevybOXAx6QLY2/oG39g1Dx7BSJ0SA0dLfVn/wgDUQi+7nAmLemG29khaspdGsD8Rwl+u24ADHRMWKLgr2Cd/nwLPvhFnbZpaIKPp62U5yppaTvWKLp6RYf/qcel2UzOKOcB7R593XIeEvib47FudIM55Vl9dO/JSXPsWQIzwAaKvFjYbqw57PiIE/sKnIUYdeulHSJBFOQjkz43yVLnBvv8gCgskDF+E4waO6Pya7OuumNQYAU9GvwXvgEwhSvaQUOVlhFVdvheySZcPFz/QiCujUWVXQ6uIl1PLhZBwU0BaU/373nT+jnlerMuquEpekDCIF03eOhL2/Gn5YeGQ/qy5MVvYgptuB+WGPVfRu35PeGZn/DADs0SMXA3LTzW+Nj/hiYgUsPHILvCdZEksznkNfevXKLffl13abRSxw7lRVLORDHOxbfqH1V8yd3/7xu9nwnSPvQrbqbjnuv8KBnNQWjrecZFSgt9ZC7PPXQHgt/udvdzCyFwRXvgBgF4WOGDMlqkz55auG/1jK1h5uOr+h1hr3b98TZ8+T7yjhqO2dfYz3D/iCHvxGbb8DxaVfJ1jCLAMYD0f92rFUm5+vJvgvanhB5W/kr14bQQn09UskME+K6rYhWM0anxl3CHGQ2Minlmzj/DJM3KoHWqcr0TYUplmo5M/3rj14vbdTDPGXFJdmJSXou4CYqbvjWsj+v9wmGwD8q+banqATSjeV/Ecd61AEzchRB8fjZiIKlaO2VrzcO2pKsKVGRqsD3FT3mTdKx0p7IQ0NksPE1fTGHFKSOIjn17H9Etp0zPUWnKZ+IQZI7L/gbdgMHHhcr333UZATpz+kMuRms6UR2C9HM9PUlI0Ui
 7VFOGmHP
 lK5wItOcrTTPzNRE4Bak2uJRl4GbnUyilixlmYhqx8hlTpBTJ2ytTXPgx0VCY/lf5MlC1S+Ueqw/LxUXB9kf0EAyGHh10lnhsnXRGVA+7JdbIthsq4rt2hsE8BxLbuM9FRSiXs2XumoyNmv8OLxdFeXWwR/j7z5NS8QOZpVrXW3RPo3FGqHMDgPed6zPMjILw0luvMI17t+244JdRgXBjqPnGAYroGX6hC2vsD8GYLU/pW6xS/srLZ5RL593GSPOKYiDZuxFY4j2ew9MY4RD2pmE7nR6lEI76Ylv+isreijoAEPiwRNAkk/rxNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30 2026, Mike Rapoport wrote:

> On Wed, Jul 29, 2026 at 04:56:02PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Currently struct page init via memmap_init() or deferred_init_memmap()
>> only queries the migrate type from KHO for each discrete memory range.
>> That works currently since KHO scratch memory has a different memory
>> type so it is always it its own region.
>> 
>> An upcoming patch will add support for discovering blocks of memory with
>> no preservations and it will mark it as MEMBLOCK_KHO_SCRATCH to allow
>> allocations from them. This can lead to the bootmem KHO scratch areas to
>> be merged into larger free ranges. This merging breaks the selection of
>> migrate type.
>> 
>> Get rid of memblock_is_kho_scratch_memory(). Instead, use
>> kho_scratch_overlap() to decide the migrate type of the PFN. Since
>> kho_scratch_migratetype() only uses KHO functions, move it to
>> kexec_handover.h.
>> 
>> Instead of calling kho_scratch_migratetype() once for each free range,
>> call it once for each pageblock. Update
>> pageblock_migratetype_init_range() and memmap_init_range() to do so.
>> 
>> Since the migrate type is now evaluated for each pageblock and not each
>> free range, drop the migratetype arguments to deferred_free_pages() and
>> memmap_init_zone_range() and use MIGRATE_MOVABLE directly.
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  include/linux/kexec_handover.h | 15 +++++++++++++++
>>  include/linux/memblock.h       | 19 -------------------
>>  mm/memblock.c                  | 10 ----------
>>  mm/mm_init.c                   | 27 +++++++++++++--------------
>>  4 files changed, 28 insertions(+), 43 deletions(-)
>> 
>> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
>> index 18ba417f1ada..c83ec4a15fe7 100644
>> --- a/include/linux/kexec_handover.h
>> +++ b/include/linux/kexec_handover.h
>> @@ -5,6 +5,7 @@
>>  #include <linux/err.h>
>>  #include <linux/errno.h>
>>  #include <linux/types.h>
>> +#include <linux/mmzone.h>
>
> Should have been mm.h, kbuild bot is unhappy otherwise :)
>
> https://lore.kernel.org/all/202607301001.ARjK0D4v-lkp@intel.com
>
> I can fix it while applying.

I pulled this in for definition of enum migratetype. But I forgot about
pageblock_order. I plan to do a v6 with the lockdep and documentation
fixes anyway, so will fix that in v6.

-- 
Regards,
Pratyush Yadav

