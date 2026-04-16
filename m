Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 381EEF8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745CD6B0005; Thu, 16 Apr 2026 05:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71D4C6B0089; Thu, 16 Apr 2026 05:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633706B008A; Thu, 16 Apr 2026 05:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 527746B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:04:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED10C8C41C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:04:02 +0000 (UTC)
X-FDA: 84663831924.16.053AFDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0C4A980010
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:04:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S61q3Dom;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJ1bXvUCaR6FNT2bXJB89I5iul0FtzrqOg6QCrgwCa0=;
	b=4uS2tjee1RubcfD+om+5Vlxc5knXrBSO/A0JJ+hiscJ0ClN/LcfQwyxkCP+b0S6VOesUo0
	6GtdKaZRiq4KnoGf2eLjCMhhIzcaPI6C21eFuIjlcuX8azkNVlluq48baWzFt2jZcLCtSN
	BbZpRaj1coQkr7dxTS5GahgxeowjqXQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S61q3Dom;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330241; a=rsa-sha256;
	cv=none;
	b=E1QndfRZ+WtFxDrI44I4Cc14MfRlPW/MaM2Dh2IqhNIOA5Qut6vAe2R9cI0mtwLpIPSAC8
	Rfu9GjbKvGgPzCY6KZNkWGVhTOX9atYLqP+ljYIOwVWdxr2lJr6lZBd1oikSEqkzhCEdYP
	NG3k3ebjpBinRHbgarfEJ8crgdc1os8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05F4C4327B;
	Thu, 16 Apr 2026 09:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFF2C2BCAF;
	Thu, 16 Apr 2026 09:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330239;
	bh=+NW/hoYJakiYKrdIWB886RGoTFd6AjYRobF/ZlT3V+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S61q3DomMTBSegKBAfkWX841vogBSQ2csr9NBAWLZlxrxS27oHm4+s7vtALk/YtQJ
	 x0sNbDQy/NrV2UP1f6uMMRy6hCxohcyLDU1ZNG4Tzhs/jyr78OU8fWNs3O0B1m9179
	 aioU/65pLld1Ivx0Lrpfp/UhvmT7VwxKjFFwhKgQTfv6fOVbEEFOkIB5wFVhXI7XpJ
	 UDRD2XEtEDlHPTb00EI1ivDqjRgLF4gGBAG8j3MIDORLcavi1gZ+sXhgb5nWJcZrBa
	 QSw3dvK3vdIdvkPFiLevFozGZuhLd5b2pcWiX/AUhrMb+AWO90euPit4+LBB3mjghI
	 Kdk+HoL7o1WGA==
Message-ID: <aa7c5a29-c8f7-48aa-b0a0-ed147d29fde4@kernel.org>
Date: Thu, 16 Apr 2026 11:03:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] kasan: skip HW tagging for all kernel thread
 stacks
To: Catalin Marinas <catalin.marinas@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
 Marco Elver <elver@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Peter Collingbourne <pcc@google.com>,
 Will Deacon <will@kernel.org>, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-3-usama.anjum@arm.com> <adlCN9sUcQdWbf_i@arm.com>
 <adlDSiuBeSduK0mj@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <adlDSiuBeSduK0mj@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ntmym97jcd8kze7cuyxs8m4oqrqw91xp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C4A980010
X-HE-Tag: 1776330240-496545
X-HE-Meta: U2FsdGVkX1+ZxHlmcRbv65KmCGUEpW3tonQigar0wjzTjQLwrSMAyZ6BiwTqyNJd7zyzkwj7n/BX6OdUXs/2kqiwmL6dJQUxhuqes/97tcdhxm7jDC0XBiwEgiRVJleSLztqcqo6nJ57DI0bI8C9wfRph7ka7lYn8XyKFX4eTN1mWl/8ooT5ilAXABbNSjGEVV5LG3pIc/3eEOs9M7flKvaVstO0oJ059IlhklszSASHvCYvnXIpxxrskIaTZe6FZU3w1OSBnIjwr3PYvT5P+WyCNGpw0dsA3ykyljXLQON27/hEra/R3izcXkOvEYREhd5MNEjLlhkE49c+fNJHDjq2L1f0E1l56FRVEWf4eT0KQeSVsRaQNtn1tmk7h/OojwelLFGrXl7WORUPKBTsGcwNGwyrgBb12vT8fEfo6gLN7QAE/bzGZse0taw+wKrKtQ17Z2MLcAfS0EoQ2BYr7/ga8vtGO/LW0c3v1MHRbimqDEViXnvs1d7T1XQfM5zpKzrIXdty9bw+u7AaPISYUSLvY5dIa04Rtr5B5geK68r2a7AgT2zerEnmuuj8p5+Cs9mP/znDLKDh/I9kCCluGXh/LKbtJ64XvNNLDKxM0LxsCq8pRSN3rKRIvI2W9L1DtmHvqzfGkofTQL2cXWZeBPIbVoPGOHwwgJ88pY4/iNeV20oaXpRZvBHU/xr6pPgfXqj4lLwSRBnd+YqeDQt4vTvtFMPhtzvQckN3yw/Ib9e8GrZ3sZfzS8y5KIQIpTtO7n0o4gkiK9oSR6g3NnhuNaOQNvmBc2FOmb31q1JPkiASAXiQzv15t1tz6NRRV1cWVSUB/8ydoMf2cKY6udQWKpMkT6trhnVt6UHB1dH1aoT0qX39YrnozvRyjIrGj2H7ShHgwePw4tzlDHYuWxtrTSMnCMxp9JkPNG3/lTRHxkAYtkAWOBnUggUhTSyu8FNc37Fg+0o9mFqMu+JRdEQ
 5G+hviD9
 A7jIaFfdPyz0R6B7RzCw4w8ps3ZprIxbEDG9e1au54ttWWLY6h7jqwzpojGE/DIyPXqKYw3M8sG/9i3ldD83tjpihb+R6JuHYtA9YGSSV1oQfMq14Z03bVPVD+RQJQjPeFFU4yoaa8T0JnTrLLnbo/2YDcmI14Vy5Kwga6+PRKrqQZYUpqUAYlNpYuTrNxGS3KMROmYMfq/wuIsIz6wbE4NDidsq/9f6EaVNEhChZV5Eo4dk7FLYoOs0Rq4N2anlfMenp4wFTHVgquRQFEEAgxbvSG77J7ytxC2l7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 20:36, Catalin Marinas wrote:
> On Fri, Apr 10, 2026 at 07:32:23PM +0100, Catalin Marinas wrote:
>> What the original approach might help with is use-after-realloc in case
>> we had a tagged pointer in a past life of a page and it still works now.
>> Oh well, that's I guess for other types of hardening to address like
>> delayed reallocation.
> 
> Another thought (for a separate series) - we could try to map the stack
> as Untagged (unless stack tagging is enabled; needs compiler
> instrumentation) and enable canonical tag checking (newer addition to
> MTE). This way, any stray tagged pointer won't work on the stack since
> it needs a 0xf tag (canonical).

Do you mean mapping it as Untagged in the vmap for CONFIG_VMAP_STACK or
also as Untagged in the directmap?

The latter brings in the set of problems with direct map fragmentation.
-- 
Cheers,

David

