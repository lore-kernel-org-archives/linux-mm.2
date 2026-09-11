Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E84EC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23466B0095; Fri, 11 Sep 2026 13:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB46D6B0096; Fri, 11 Sep 2026 13:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75366B0098; Fri, 11 Sep 2026 13:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB8D6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:10:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 239F4402C8
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:04 +0000 (UTC)
X-FDA: 85202119128.20.3B9DED5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 63D741A0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:10:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o3L2NdFM;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789146602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtZVEwngtJNDR7Dil3pjiAKeqFlagckAJ2vKOo34aps=;
	b=cDK+/5vreVxZeipUQ5svFKdPI90xxH+/2/wuNXO8sfK/jR04SC/jM5c1JKypB2fONG5qXU
	bw30gM9gi2s2VBwoUWYH3KNvusoc19WE2hdXkQiYh2fum5SaAu8kwDQBQ99Zv8RkeCEofm
	NiKgUJqQgAm/LpNBLlWaM10SZvwjlgg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o3L2NdFM;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789146602;
	b=cKfJ3ZSod5cfqPXbPtu/PzYjil9QOVDmruAdzogiTq4lNA7e32bnhG5Duxe59KEPhRcYad
	5r8psafUUTxIFJVKIveQkCcgofzR5XNLs/3Z+jx74I6V+2eAGm8kMXgHL+wt1cu/2Ir6qj
	yWpuKPf2S+Ai7VJXVRigay/0OUSjkGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48B9160008;
	Fri, 11 Sep 2026 17:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A101F000FF;
	Fri, 11 Sep 2026 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789146600;
	bh=wtZVEwngtJNDR7Dil3pjiAKeqFlagckAJ2vKOo34aps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=o3L2NdFMRQT+LpNVPaEJvUSryJiMtoEVuBlhvOpTUX3u5oD1j+1IZzuRmDPssCOD4
	 3TfJgTwz9pU1ve9tosOWOXJWeO5W5V83R7OCQQ9yL2AVj6egbjS8vXSL82EbvGhM3T
	 X1XDCLrsl04F+9gry2WDolIIzJu6dcCWuJB5K5pbIbQMAi2KKSjOs3tL2GGoqQq/Wi
	 xq+SIi39yxW4XtIwV3PkGvVjCoZTgE4SSw6GvxZx1Nypqi8hRWSbbhUoNXXZ0lhxcQ
	 kqmPeMm2P5VW+rdouLiwMZzBs9F3xluAom1Yg/u88m56rjWUU4zcY2OLNDN0AVIlpJ
	 G63yfKeDG5URw==
Message-ID: <85ea78b6-f3c7-4a9b-b25d-1fe2ecbf3b40@kernel.org>
Date: Fri, 11 Sep 2026 19:01:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] mm: rename pointers to software PTE values as
 ptentp
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260903103002.1091859-1-usama.anjum@arm.com>
 <20260903103002.1091859-3-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903103002.1091859-3-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63D741A0003
X-Stat-Signature: 59cxuhbk8m4ajrui3r5qsigq78tfxp5u
X-Rspam-User: 
X-HE-Tag: 1789146602-93860
X-HE-Meta: U2FsdGVkX19nEX/ucFxQ59aA10s6zO5TZH5gP6Vc9FotOTPN7NfFZIbDHKTd2unZMQnOEL2OZi1FVU96PL7mQsMgbIDu1B+WQlNqB2LtSSyYYF08SF5P1nFNBzVYbToPYmQDxWsuJlm8F2vZFg3aD8lacPp8pcy2mhc67fXZsinhzmSV/ZnxSj9xKYENkAMNaeX01LNVVDct7AsfMqCcsaJhQkdFlBluUW/l20x/bAWJCbkVLu6JAuKwr2MyqoHrIwr4w/vNVdVanI62LDSmCnUanUYTyifwThDV+LMFxQ3hg4H31yDXAHSuCdsChVyKJxvDJ/2mYvSFdRdRlpfwoWZDQGiPZoeYU6brp3oGLyzVbZdRAlvz+y2VhrZjcJJsiojm/ykezlbkBIHDkvBuvNHOwSmvLwVqTJ6eQL7c3smGpTrJddS4omXlBtHRRG1f7E++fyhxuOHI5gn0YGNU2eRF39qW+ugDzV3Na7j6bzrrj2P4nbudDvVZv1wpuzxNh7z+DUtYP3+jvAjfqCZuOUBE9VPdBT4sMnImJhjHW+QMAbnc1h8iwf4CURHzdO3LO/pTCvjldOHGuuDTDA5NoKZ3LFlADxWxmD1vIpjpX9NHP8SE+ezPnD22Kj9+dRnFuzG7v5IuOKnrKVpWd3Nes2yj4hIOpipzXHmut1SZIAK4TVKgC2WKsKY0YSZxSBQtT3rP1TbarpBELarW45BEzUjlXprx86MbXHXbCqbf5+AwXU568VOFuyI6FS2T7Z6rxzbJHQb1V91I1xJg9d/sUuHreafxWLGCobGJK5Gq92ki4GX3kauvUEO/wEsiAQe8P3TQhJvM18dEvu7G4u+uVhAajAMXuypSm5oIPsviaEfH0ZhWRF+B1BI+Z4nVjYL0XLcifFZwHtdSGGfoEfcUK1CJGq9T/T/dEIP/KqBVr8Kz00CJgqzDOUC5+GEQ8W9g+TBXLEWKEBTort5xWDa
 O1+LmFBD
 cTKdlpNd+nBOnkgYS5vy3btAJuBYEh7coweiKuCeidUSCXM59IWbJmgB8oYIQszeF2jstqgnlpIKF6RRHAAnVl3v2gSG0SHEHMhcJ/Qq2f1bhzbRZHrekrP35rFcAbjZ47Pxm6SdFETxvg3gr6kmfBQbJ/nNzNUdpbXT1OIt3GPn0iE5yJKYwicM+ezYQv5fsmWLaq+yGs6ch6zRdAPcDOGCKa/zlnq+BqbxCws8TkRqB97swBxE04Ky7H/F+KKnyNOlWS6gT757OpD9nIAWvCt1ocfmr1dAT9xghmrRt9PLuyb2oNpHpED7LhWVEuEQFnl6HiCmNASr9bCZV9tejEBcU5ivMbjqOsJmcfTuaHwJzs9NVKmyQJeqkn0ExQNkmU6aD38EqoiwfXiwwBp7umwvV7Bo2DPvTmh1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 12:29, Muhammad Usama Anjum wrote:
> Some interfaces use pte_t * for a software PTE value rather than for an
> entry stored in a PTE table. These pointers must remain pte_t * when
> pointers to PTE table storage are converted to hw_pte_t *.
> 
> Rename these parameters in the install_pte callback,
> write_protect_page(), and guard_install_set_pte() to ptentp. The later
> Coccinelle conversion skips pointers named ptentp, allowing it to convert
> the remaining PTE table pointers without changing these interfaces.
> 
> Some functions already use ptentp for such pointers, including:
> - madvise_folio_pte_batch()
> - folio_pte_batch_flags()
> No need to rename them.
> 
> This patch only renames parameters and makes no functional change.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

