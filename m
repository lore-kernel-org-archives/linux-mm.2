Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A3BC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D03A6B008A; Thu, 24 Sep 2026 03:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981946B0092; Thu, 24 Sep 2026 03:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FF36B0093; Thu, 24 Sep 2026 03:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C42B6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:12:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E78AD1A0278
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:12:43 +0000 (UTC)
X-FDA: 85247788206.05.B34E318
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4064020003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:12:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N8Uy5/ZV";
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790233962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFMZJ8bfMe7hv8ow3sVzkwXX9jGxt6hLpAj9/6k7EV8=;
	b=WyWbSU613zuph/VUyY5geL+GtsSc0uJ0fdPQOL4/ecEphv4RYNDF0/qnQiEqpbVK+V03fM
	Gpivpa++szwx2iQWO0Hb1EveEv5KVyBjib7I7nxilhFI8t6yZWG+PWlL6dCiLJ8r7+2eGn
	gDjnWa4tAClagpSPOLUEMT+UHU7ISSs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N8Uy5/ZV";
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790233962;
	b=aU/OkcD8RkhCJxGIeJimH9jtmTmE5C+0O30IyzN9VVoPB+qaPL4+TxQWPBepVSocaqiKe5
	FyPg5pCq5dJiN/QKjiLe2BU/5kTwZEVxusEKiokI56mHdURpejewvHzUV5lFjfxWptRRWZ
	Yu/KRf/L2/stS4cgc9s9j0NKLPrfSY0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0ED096020C;
	Thu, 24 Sep 2026 07:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3CB1F000FF;
	Thu, 24 Sep 2026 07:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790233960;
	bh=NFMZJ8bfMe7hv8ow3sVzkwXX9jGxt6hLpAj9/6k7EV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N8Uy5/ZVcNg7GQc6ga/4f6riaFB2eScs0ehWn5RE0IjCUBhMRPovH4J9/kEHOsn+o
	 FC8wQz85M7asIudcCmh02IH3sM0yyaf+IVUrt97Nh20o+5CZpelqEFvZnY03ZX/LGc
	 YypFEGGg/HSTCedKzw1tj3+jsKOYM/GYVfMryS4UWKSsjxU0k1kFIfFJFs8tSlnvmb
	 Z/NTZ3HWrx5VllywgUjeJKHx043/MuxtXEngUhuQTAf02O2PeSPzdbUBO7hqCGfDpu
	 Louob+P8g+WmXew3qqychIFWyjZ97XrLnbWT8T5daucZ4TUfz6MV3ZxJNkcp8gy8Ow
	 H99WIGmnAw+FQ==
Message-ID: <1e4580ab-75dd-4092-8afd-69180d064942@kernel.org>
Date: Thu, 24 Sep 2026 09:12:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
To: Ayush Ranjan <ayushr@modal.com>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Gregory Price <gourry@gourry.net>, Pedro Falcato <pedro.falcato@gmail.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924061708.1645968-1-ayushr@modal.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924061708.1645968-1-ayushr@modal.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4064020003
X-Stat-Signature: abmdesyxejaazmwyox4zhz967skjc8rs
X-Rspam-User: 
X-HE-Tag: 1790233962-146813
X-HE-Meta: U2FsdGVkX196c1BIYG95Igv97SfJafNRWcHlIiq9iEpGkhG4b3B969MVJdvSY1LzMl1awLVmqqw14zOMv7btvHARcEfy3rJOBMVmSnP8OxM7Meau7WQcMgS5mKGJRW5ikxrumEyHxPbeyKDs/hjV/JxuhUN/o9bGwV5DmWiFo83HQDrc8PjFAJ/QrHRgHXkPPtUc7TW2rzLsW04fX9Cl3cZxG2lLwNFIisXbsPdtoTuLEhoxMqB3J9FCLpAwpL8VsuiXmZNPnKqb11FBvH6+EvyCO4GuTwAMYJqEiA/UAOgmNYQlHfX97ldAu/CXTylKQeYbiGH7ythz1UtqRhw5o2opVBKzqGQyP0i1I5U+VcNERiagv3tRY93ZEq4p/Kx0UR8GIgRmnMfj3JFJ0+c5rWRvM84uGaw161IdS9MS3SqocEOS8+5WwOUk0/e5j0hGQ04pnfkJoRUa90yrw1zJbIdfGVkKSHsRdhyQxDqrrege5OkoKuNPs8bJSPgu7e1ln8i7JIQ/WIV+S8ds0Hr+l5sk53B5BYKvk35XGiI4tDL47CjN4k6OxeZQm23wW046NRkqkmsmSrZmsGJo4SJ+69ujdxRIQiMQijGP6yq2TgdDIJpe6AtIA4IPf7ejP2YkrM64McSqkSEo0gdzGPWhQu6FlXCyGyVgQmewMs1IZscf330HBwpvhzM8I1DMFtxxGAmnWyUBcBjPJE8ECT0uYinebLndM6BZdrEmBKxZ+8aM5+UVoEDxM1eG45PQiBzFYI3S96kxfR4JCe5Ly+fbkrQHsCklh1xixaQVbwgYb77epgfGLayBmoBbkjVFxgT4rfBsx4pkCAFSXED/pzFbEnBOE37rYW95GzZOfAI5xviwnmMj/96G9Hm6KIOtY67sSoT0dsPQdsrCgSju4fZ8O+5I6nGKaU8x2Y/IBR4/RqMWYzlHOT/ExAg0L5LXLHhwfSH/57iDq1D9VwYbgfv
 6CMUH/Qw
 C/o8yZJjXNCekFc2Pl+WyLuadhaZYp0Yu1jQ/hEMgI1IaALZE1ChnUUzTO7HEzX5fC4aC0sCY0ALHUoL9PLAFyqlBskqocUcuTq1E9dFQqNUaAiWZsyYvHTFLdl5kWR8sQxLttelDbhSZEMAh2PeQ/v32QkboBhwUhhdl9wG2ASw12BHbtD8zI1BJqdg4Lp7c/WMk0pDifPt2KSI3RordBjW4uAyrmzxzGpXzVfIW4jM8slp3dFcN0/w5qFTzaGUdO4tWtWVpNamoDvwb/vnqf4QOmEpJfWU+GYp+w67oamH1rBc8El9gjw6MAtLi/iSbmDfBRqkc3ZiIZHXdpGyVBQWnCTddEyophNRwkSO/5+vW0q3ae18wFzGIw9KJUunSzi4/z/P4EpNT5rELNP4WDtHXAgs70NGZ9c3Q7o+ETej+xXnrLzVF6n9MiyioBulgVbEbufqtnzJh3rvcpJDgFKhRPU4htzOdkxH98/rHLtamPE5xF5cskovmCBly3rWo7cS0jh5ca7RU5zg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 08:16, Ayush Ranjan wrote:
> Hi,
> 
> We are seeing shmem/tmpfs page cache corruption on production hosts
> running a workload that punches holes in a memfd (hole-punch based
> memory reclaim) while other threads and forked children fault the
> same MAP_SHARED mapping. The kernel taints but does not oops:
> 
>   BUG: Bad page cache in process ...  pfn:...
>   page dumped because: still mapped when deleted
>   ...
>   dentry name(?): "memfd:..."
> 
> and, more frequently, a paired rss-counter imbalance when the mm is
> torn down, always exactly one PMD-order folio (512 pages):
> 
>   BUG: Bad rss-counter state mm:... type:MM_FILEPAGES  val:-512
>   BUG: Bad rss-counter state mm:... type:MM_SHMEMPAGES val:512
> 
> Seen on 6.12 and 6.18, x86_64, bare metal and VM, with
> /sys/kernel/mm/transparent_hugepage/shmem_enabled = always.
> 
> This looks like the same corruption Gregory reported in March, which
> as far as I can tell stalled without a fix; that report needed ~100
> ballooning VMs to reproduce:
> 
>   https://patchew.org/linux/20260326162611.693539-1-gourry@gourry.net/

Indeed, it looks like what was reported in

	https://lore.kernel.org/all/20260326162611.693539-1-gourry@gourry.net/

-- 
Cheers,

David

