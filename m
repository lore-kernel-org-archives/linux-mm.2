Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 830F9CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524D86B008C; Wed, 14 Oct 2026 16:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF246B0092; Wed, 14 Oct 2026 16:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376BE6B0095; Wed, 14 Oct 2026 16:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 120416B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:48:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 920EF1A07C2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:48:40 +0000 (UTC)
X-FDA: 85322420400.17.3A21C16
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 859A3120003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:48:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pvqcXUXO;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792010918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0ZQhgDb/5TZ/dqV2g9qMU0lMyYEMoDn6IfcrysY8YQ=;
	b=7cGYgRRF/crN7InIrM0aqiMamjBI1b4xLBxnYKrmE6RMm0vDl7nArvd52ReY7BHKt6l4Od
	GA4b+QKS8HF6bCy4mXxISgEnUWkn11yneabT/o6voJ1INQjSjFR5V07LljmIpGl/BR46uo
	VqE5f8engUFHT66zplJa2ZDMfjaYUKM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792010918;
	b=sUEnNR66ldIQL14d7Nhay+2+feiR2QS7/3UnI+/vYNZ21ntnMM0296h+r3ffsrj2rNhuSi
	8oFtPlYXa+Tf5mGiyTejzrGz5taULS8ENvdUoBXX53RWB1vFIPC6yUqztOpPGbrXaViGD8
	C1c0NTd7+sNxvWYwKb55CTSt9nwa5u4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=pvqcXUXO;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93ead211f14so133745785a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792010917; x=1792615717; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G0ZQhgDb/5TZ/dqV2g9qMU0lMyYEMoDn6IfcrysY8YQ=;
        b=pvqcXUXOypI77QFy1nbtWoBc0skHLALTY3bYrpeD0xqICgORV66iyeFTcX8W6kFsuQ
         7CSI8sCaeU/2a66OkMB354Qmxjp9G84/g6mjh73WQ53k5ZdFqy3jE9uaAqRrVhDSf5Rv
         WMRKxHWduhFZ/HKhcKZkyH/HZcq9gfnxLpdD9boiuaSdJhUFvInKexXmO/xpD6to9Vg9
         XgsOrsV7OqGOjJbW0IyvCh7IrF7ruSde7Qo4+g84SvnMPo0VehbLXuH8E2r/zzYfEK1u
         qWMqpvzPhkgI2vaualD0EzCYKmQSxr9mPa1nzVwHqK7XlC59tOA/pgne1vCCj6gQuDND
         NjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792010917; x=1792615717;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G0ZQhgDb/5TZ/dqV2g9qMU0lMyYEMoDn6IfcrysY8YQ=;
        b=PEO931/ua5X9NrRiKKBc1sGBv/LE93xxdgRdXyigEzbrXjbpC4QMXrMaES4FuINjI7
         rfPLfwDrGdK8m2iXP15F4ZxTbYbYSmqxC/mRGeMdNaywL19RMW/lptfOTRml9YVWpn9D
         OgqHU5cRXhSr5cZks64lMa1nd8xVTL/+lIHxBWd0yZ5WRUeqCBKIDbFtx7Z3jb4swS22
         aA0th6iIfI4TuGL0IvPvtXZ2hVofVfkKqhJVCh5esPNCVY0nKuGbO2aT6LDLjgHITxFS
         zbp8mng1CPPm74UdLW/FuBFTORKbuY86VZ5ucfN4I1pAbYeYulbGlDhCHN6Da10THRXn
         jWvw==
X-Forwarded-Encrypted: i=1; AKwUvBzbsHVS7lKT2JB1cfR2+o854+td6K2veXu1BirygLr5W/I65Zkm307PJJZq159PCZj6GDbG2UrQuA==@kvack.org
X-Gm-Message-State: AFq9FYKWMEdFIU1iGK5oXFKGZtsjheFQ1arK13iCncXwJ7sDBBD9NsoK
	5JCelv8His9/k9RGlN4aartrHnD/2idL/t5BmFjafvOm+gABwsl3yUvtUX9DejdJFUo=
X-Gm-Gg: AYBFou1SxIoO6Kl/LNfITq+RRnpOLc8isU9VfBQ7+mQfyr8+jZQYoKSrYGcPfXTbpf+
	lYAplbKtw4/kdg7DG70PdZzXhLaHxLtBnRCoC+NXp2bVCzyyVVE9UvOy3lJom0X8IGeC55CYm4p
	YbF82/a3N207c2PLQHEoJGAo43jbG4uTOIeJGXUbxPeuKzSzcHfIO76tKnlcGPcJSibrMPb6H6o
	oITSdrZ8bOGV534VPte8cCHunXYxQS7ksgH91SAX/UckZPC8ZxEg7ALpyAK6gWOt/eiBqRhY+s3
	N2u1i1au1GG+ovTpV10ECMdNCEicFYHj9yTt9QM3OviqsERPBLPqTxux/YwEGCPIG9FyrTgWpAS
	lSjNSTWrAyw3+JPDiu2SUtJN9eSAxVAymXH4SkMjuXlNezQKVe55A+IDEGDqRz+xHDHI3JWb+/U
	yRhgT6g8zK3Y8MXjeea4O6+TItu9GqYMR61M15449ITdney53PQEjMik9MWQO5qD4CKnkJLvnzy
	PsaFDA=
X-Received: by 2002:a05:620a:1a23:b0:93e:5ff9:a8f4 with SMTP id af79cd13be357-93ec121d237mr2487124085a.0.1792010917481;
        Wed, 14 Oct 2026 13:48:37 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5086fe3sm581516285a.37.2026.10.14.13.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:48:36 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:48:36 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/5] mm/page_alloc: convert any movable pageblock on
 a non-movable allocation
Message-ID: <20261014204836.GI371161@cmpxchg.org>
References: <20261007021250.1665929-1-riel@surriel.com>
 <20261007021250.1665929-4-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007021250.1665929-4-riel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 859A3120003
X-Stat-Signature: t37m4o84sugse98naj774qt4g5kp891u
X-HE-Tag: 1792010918-417323
X-HE-Meta: U2FsdGVkX1+vKEzYLB8u2zWwGJM9AnR4DvwqSsJqOjq9ZuGyy7rVWh91wLbigwfwy8ZJYwBe3jmc4ClGnlMZFX1BAXHSOsw/5nLKjmL3W/ArJR67Ro3qqn1P/gw7ht3biyMHKOKLmOof3uC4amgQt+a+P7J7fVpf9K1DI0yK67BFnq9353R5Xa7gPl6aosuShlBObKj+TKKzEPYSUCd7L5mS7yRRvlqyDOqx9Kf9WeAKIoSGv+2LMEQO/bbo8z4psEUhJcuuRVVJzZ3jbVOLfClcIfiR6n+6Q5hURbq9Kc1qTiuvrjwvpdoDFxbcuFmzhilXEi/ZxGgBEDscu18T3frnuQb+/N3KAhwSGKg9lHvCm6fPs2tw8vFA7JvMR24a6fZGLLvuZAn71Eu0/XNnd/c3ppSxtT9KVmXw7NLbz8S34PRbaHM54D6saD60qFUQIWWD0KTAg4ukQSPM1DewbU53enL+R7pCqO2wlg8+me38VnefGiBT/dQILmW4E095Z+bNF2YloshgR7aiqA1+v1xBf/Yx53wD7sMmqJW2WX+9p/gUD4FMaCUNfKaCi4NhubPvSSFeVHn6ZkLHy+bBvcSgmN2Jc/85vApbyX62rIUyw8DMCwf6EeyNsOynJ71o6eoc9AVpIh1Fe7Bi/LfYuU6a7c55rX5LXVvERmrF8crHr2vZEpqrr3RsOnNVR6ZZH2xbsWoCthvCkhTDFw9f/vbk9b2VKSwU7od0uHEVbFuGzUIdbYPNXQCGjKpuef6GHvzcRxKbtGE83Xtsa5mpS8F84shWztRRJlU1wdOhGDAwEAr13MCm29F2DIvWJK9RED3X3YlyqziCSSKPc3xMwllFiqGFagk5tIBqmhFjEOdnitGSvmkmMfr9j/a6CONZFu2pwVuLrE0IMoP3bJI0xXFA1b2UypXwLpxhvz6j2OuBgzifmKRLgmZAjN5BKOtrFWESX19nnHuN9u2eWLg
 37YFaP0e
 NbZFoZu+TLzJYcqlngpKdPBWm+8CLHIq9pTVgkd40CN696THQnNSrn2GnzY1vPGUhzlJUl90WIIcHmeIxzcC9Rzv8F6yO2dplfHfLopagyD/WtKYCfo/xWMQNgQvZSdzIiPMiK1YIybCavXTI6efx654BYVIWYfVnK35eiwd2LHKDQHZbyL7uNX2YGUiJr4ks3tuWLSa/vKqKvC9blPMhq0zvO7OaiNpdRAvAYVDdDKyFYiezjieods35T2lzTulM0hQWxitt2sQUyBZOsASVKtiuorfCvIG0A1Y3WIlHjO1T32OI5VaJbl2XbXZu1A0P6lfYvahJZ3lolPjoZ1DprQbFm9IVke5egg+lQ7tiDgylIT5y/fxJSxfUq15hQ8zA6QTXnV5Ki1QPjPvXhtwDiuglZ7rPGJnyrA6JAUNvwKokbkA6SM82TMeFb2tZr08MXhDmP+CS7bmMnZppP96xX44tsaK2qPdc0a8T28r23acbnieTpCx4gO0jQJwY0NFgzMKHxOksJgJRO/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 10:12:48PM -0400, Rik van Riel wrote:
> try_to_claim_block() converts a movable pageblock for a non-movable
> allocation only when half its pages are free or compatible.
> Otherwise the steal path takes pages without converting, and
> non-movable content sits in a block still typed movable.
> 
> Convert a movable block on any non-movable claim, however few of
> its pages are free, so the block's type matches the allocation it
> serves.
> 
> When other pages in the block are freed later, they end up on the
> non-movable free lists, directing more non-movable allocations to
> the already non-movable page blocks.
> 
> Converting a non-movable pageblock to movable is made stricter:
> a movable claim takes a non-movable block only when every page
> is free or movable.
> 
> Blocks straddling a zone edge are never claimed;
> zone_spans_pageblock() tests for a block wholly inside its zone.
> 
> Assisted-by: LLM
> Signed-off-by: Rik van Riel <riel@surriel.com>

I like this in theory, but wonder how this behaves in practice.

The block is claimed, but the movable constituents aren't proactively
kicked out. The next unmovable request might well claim another mostly
movable block, and so forth. With a flurry of short-lived unmovable
allocations, this might explode the unmovable blocks, which will be
hard to recover especially when you raise the bar on *that* direction.

