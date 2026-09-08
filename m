Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA5DC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246E96B0093; Tue,  8 Sep 2026 12:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DDB6B0095; Tue,  8 Sep 2026 12:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110206B0098; Tue,  8 Sep 2026 12:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1BE16B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:21:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C2461606B8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:21:55 +0000 (UTC)
X-FDA: 85191111390.05.FB13A1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id ADFDDA000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:21:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiZa1FAG;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788884513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TqmDJUy5o6mpDI4ISF8yh2oVfrhqIccw/xxHz+n0OU=;
	b=PZJecgy+mv0Biujb+1+OHNTckpDSqrcuRwjqv/rftg7eEg87P4/yWClczCtA2NYXLkDl4c
	qEragIpzv449Bt0yZhdHRk4AK17vCyvdxe+NWjVHlassMmsj2ZztFX6wtcpLZOhznTEqcc
	qBdmX6cnsgrshOeWDKSCMK+BHxHpzNA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JiZa1FAG;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788884513;
	b=K2rrgMFJCMaoK2u+X5pzazwQ0vWatLuFjdnpBMNkZVgvos2PXIPNLLjk2ke+vXZ3KZUkMc
	ui0jRX/AZNZ+fkFWcDxQ9CiePpodgIqXP8++Xic3QW5fklC2YMWxTMqtdd7U1vxFE0yAqe
	AVHSk4oblMZe48CRlHLK/pZSs0O9b/Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03BD1601DB;
	Tue,  8 Sep 2026 16:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123031F00A3A;
	Tue,  8 Sep 2026 16:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788884512;
	bh=7TqmDJUy5o6mpDI4ISF8yh2oVfrhqIccw/xxHz+n0OU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JiZa1FAGRjiBxr4eCE7etd8xF5Ox2fvunf4Jh+pFg1WAlP4CubwSmpW8U6vTnZbqI
	 YPq9gfVGk9OeA9lPeUUItoILDjtrvzuNLB1QRZzdMNroVNsqitDi63hRXYHDWz8faX
	 ryQ4NCpeoWxNaIWCwerL0PlpSURsC79JZceJ11MmTMhmAQPP9fUSqHbOMpekl2pkdx
	 jgPUXw+/QOFPPU4n9pXbY5TmblnOwnS2K0Y1UVizacnB1rHu1w//n5XlgfEoru/2O7
	 pCEWvLm7W9BGee4uNRUQoDTIiJNIonPu9E1BUPZULWOxY3pMWs2zt/FjbDlFGfVudH
	 /BwFmrRFqP37A==
Message-ID: <25144cf6-a5ae-4e1f-b77b-768e2636825f@kernel.org>
Date: Tue, 8 Sep 2026 18:21:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/25] mm/fbatch: allow folios_put_refs() to skip
 xa_is_value() entries
Content-Language: en-US
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Binbin Wu <binbin.wu@linux.intel.com>, Christian Brauner
 <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>,
 JP Kobryn <jp.kobryn@linux.dev>, Jan Kara <jack@suse.cz>,
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Yang Shi <yang@os.amperecomputing.com>,
 Yu Zhao <yuzhao@google.com>, Zach O'Keefe <zokeefe@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <44c7773e-5806-d24a-83c9-f39b3a134138@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <44c7773e-5806-d24a-83c9-f39b3a134138@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: miri7nmqwqzxbnenq93cx4hig39ds3xx
X-Rspamd-Queue-Id: ADFDDA000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1788884513-667264
X-HE-Meta: U2FsdGVkX1+QHPX2A8OHywiuWmvFkF8kl+CIp223JiG1c78K1b1XuYb9jjCK0O9IuHQAWy7jp9RlZsojp5ZDRHTX3cUrelWbrLuRxAXY/3E9cxBCJzITYXANCBKfUhahH1uScynllZhP1vFI4lB0jKDovMalOFToIpbswougbQRrW14MKiKiIS/zhPhwRRUH1AxFlk7yVtDJjRCPeV1zETw4UxIuqLIkN523ijMIdxp4Jg4kSKW4cfZszqILCih2pM8/d3JlVc1bxDii0vJ47BcHoC7f6HxPQyhB0/lsHYG/o+Id4sTa6uzUw15eY4vDOQlE8YSImJFa85Ai+hPWv++U+54PWei1Q8izB9A/oz5rpw0Xb0Ha113JiCEdCTkWCptif9RAak7Fc9x60bxlWD0LzzevbXKWSCdufNOvCUpyhdF2BDLm2VcLI/demudspssuXpfdyPwfMbs8kUpy4zJ0vgSijdHBEe8MM8EERGSmElfZZXX2aFV/O2aORwmrynJhOVUhmUe5lypmaq5vfOqmVyDQL6odtJKzKWhWpw3a439QyCRbV8zQ4PeVE1u74xb0rMUzivYKvG7SVo0D3Iz64LY+vGSHJ9AQIOYxMGv8CKtgFLKy4fh5xtNgce0xgU6HmZrCRSiGzGmkgF2/T5y7MCZAepjAioK+B6rWAbsVNcRUi//i3VFOifGV8GJGrLzD0V3Nmo7vvrsqWftU3u1WUto5oJqok7kN1JL6D9Ul9LdkUwLPuTK+DigRcFT3U7heMVNkGWRDaPX70ceYmiHOMhb3hlOTUCdWQBJ4AppfeyRBM1hH+/brSKzLYY8h7Isz6ITLRerY+OoLPPDgnWyVnBydj6cpHZS3Pdfa3/Y6cxAs3Kgo5PYXXRRaN9DQCqj8fjZ+vWpISYqkonpwqH54TP1lsgk4pElnTB12izSem2z0cPPClOZ0A3IngOg6sZh5vOeSZwi0MpkL909
 7pAZl1ZZ
 /+qwua7oE2kct1tp97u/v0nfza3q+KyOsUTqYeuXPkJ2L5cniVNjD27h7IvylQK38oe98UWsDoS8uYoVsD/J+ujeV6VMUsy9ofkS/grxsMw5xkAAGKdRtgCbtm9sRIkN70PT31+nkBW/PcteyCDzvC1eknjIJ0qIcIcctR1Ce7YItm9NbA4iU8huHWpbV9ltMb8jHaChvz225PokhO3klKupQHN69HebEYuz3U040z1HxHXKWLmYmriox2Tvi04MnyHjwx6UOp9dzyatnfBlwmCcZtg48Pbp/blhDNjkwynpXItLBaKDx6xUUM7iOo36EdLtYyjol/2b9x1GrjehkwATjxQRfiwbGuBX+LiYobgLfrfgqy8K/2by7N3Uqw280MiTIEtKJF1jLq5JFr5QI+kK4U4fSRSYPdre8dMpNe0g3p6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 15:55, Hugh Dickins wrote:
> Let folios_put_refs() (hence folio_batch_release()) skip xa_is_value()
> entries, and therefore remove unneeded folio_batch_remove_exceptionals().
> 
> It made some sense when introduced in 3.1 for shmem swap entries only,
> but workingset shadows popularized exceptional entries in 3.15, and it's
> silly for so many sites to be squashing exceptionals out of the fbatch,
> merely to suit an inadequacy in folios_put_refs().
> 
> But remove exceptionals on leaving truncate_folio_batch_exceptionals(),
> one of whose callers then passes the fbatch on to others less tolerant.
> 
> No longer essential to this series, since 7.2 commit 9669b87065a6
> ("mm/lruvec: preemptively free dead folios during lru_add drain")
> allowed folios_put_refs() to skip NULLs; but still an improvement.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Like David, I don't understand what exactly
truncate_folio_batch_exceptionals() does. But this patch seems correct to
me, so:

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


