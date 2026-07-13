Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A63BBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8872B6B008A; Mon, 13 Jul 2026 07:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837526B008C; Mon, 13 Jul 2026 07:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727B06B0092; Mon, 13 Jul 2026 07:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD6C6B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:20:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90087165AD3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:20:11 +0000 (UTC)
X-FDA: 84983509422.07.7A70737
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 68AE71C0004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:20:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rhV8dP6u;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783941609;
	b=p8Jn4RVpBViPbGngtZIbRvjQJZWTQWU0LTE9hmwewJBpPUXuZBUklQc14zO8zDQw4uFtvg
	Pt+hqaK1jb2MIhp/xLhklVFxFaUaBCqj25GBiYSQedqldwFWga+Uh6+R7mFe+PrGsNT0sc
	OPpxQVbhQmF6GolMXClrerPNLD87yo4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rhV8dP6u;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783941609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvoD80vsybxHSm652w/hIfqV9kviycKG1qubWHSi0IA=;
	b=RKwXoEnuN2WCq5sfbi6qN0Vo0iZ64TrdFPTdtjn/uexc/bKdnsmtGXjF3vnQuTOrfFrF0s
	KvNc7BfbhNsTpBRfsrck87u2ieGmwMOSlOWZW8YY+aHuPZq5PQfKw07+kpW+XTwqm9Go8r
	DXsIP7IJaLKjKoNsK062yAEdK/2hd0k=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493b7612475so23874355e9.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783941608; x=1784546408; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YvoD80vsybxHSm652w/hIfqV9kviycKG1qubWHSi0IA=;
        b=rhV8dP6uMIBgsmRn5m50yPHXL0HupNTSxCk06xuEMhNmmn7Fv49HdrV+H1gjsfDkCF
         tB9v1rEGUGzY38GO0ozjn8dW38tRU8tFdTRYPrjYV46oTU/eHRwxRhc6zqZaHoueUz+1
         dCOUR7+VFe2fFPV35ETBylAUgVhUwBFSsucceNvs4pf53fbPTGUrj65a/Ww5Pb3zMMsY
         XcWA65a1JtYfEw+JlgeWlIafHxXov47h9EU+CqOtJvsltnYoj3Y9XwoPPoFQOsJtox6i
         1gL3u9e/4sEePsCa8IzUDO1+Y1+WeMXXuwIqyOTqCU7pPPYKIYLKPiS05xbsIQMWzrKG
         j45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783941608; x=1784546408;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YvoD80vsybxHSm652w/hIfqV9kviycKG1qubWHSi0IA=;
        b=SadFIheSOBAg3sq1svnRYudBZLhpRG55bYJj8rn4wjN6mPvYqJxwnMBLBh6AS3AldR
         H59FoD6tUdhk48knb4gWEyaVmysDxIKsy5bYPGDRxA5x52LQP+7u9uR+b47mqqIdTyjh
         CjZF+c2ZonivvsmVSCcysG8b1rEyTh+xYX/TZCvZEpHmws88gRRr4kC5ZQiu5UlsKDdR
         BZo64UVNYnguu8d9Aq84FpnFILiFSCPpKn+hIMFBWGQcazQXyQ7zTdgofrdu1Ih/aWUj
         JhMEjdAQpSoZ7vN2AOPEw+fpXhI99eszqTmMzEKhqgYAUFMfE6yQuS7VFExh3a7K/9/7
         diqQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr51Ixn3lbm0cv9mlJ5DoxUFjgoVkn3w/R0kW19tC7ve6ncQNOvgRYQlAID+zr5USxBEnTGsxqT9A==@kvack.org
X-Gm-Message-State: AOJu0YwWIUgXKSF4WvB4h5uvu+lrHblwAA0X/tOUXXLYLGVEKHWRo2+0
	LFnTHdUYT26cNFwTckKi/0iamLqyBiLoEHA2lM+PaSTAB/WSRV1i1q8zp72NyYEBPI4=
X-Gm-Gg: AfdE7ckcNMMuvYg0yxbokMOFn+4j59meU9DCbtgaxhirnHQGgyXqMx+MulUK8R3YIIZ
	+Weh/06F96P3uby970c3MwNiKzKAgIZ7N50Bcukl8Nj9onUSJuGLHfznVqpeM3dHY1YSldfLAIn
	YoniCZEOj1+YnbDlFlN1z4QP8bYyYhgsPO1qSuW1/3tka5HGTtOcHVgPc39VoN+Rr1heZ+LH2ZP
	fo73DroqiutaqDYIwGPhd7f1Kh6PIrHakdrrxs1udccqBP4GRJrizG5E+tNuLvALIsXrvwkGBbM
	ha1Wfv5Omq9eOuI39N+pjHl0h0cf5wCULrr5FwHEKn28nrkuOIug1LLva85+pAH75fwmfiCAelp
	R+u1fsFjizeUDKn1qJCPdymTrDNFNDr7AKc11dyp4uwTdAlmakvw3t7GlhF8eygh5wysg8fCMEo
	hrErPXJOGV4JSnMLAQ8xkV
X-Received: by 2002:a05:600c:628b:b0:493:cbdc:7cd6 with SMTP id 5b1f17b1804b1-49400dc175fmr46864315e9.7.1783941606886;
        Mon, 13 Jul 2026 04:20:06 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6ff6casm425641675e9.5.2026.07.13.04.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:20:06 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:20:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Altan Hacigumus <ahacigu.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: clear hopeless kswapd when global direct
 reclaim makes progress
Message-ID: <20260713112001.GE276793@cmpxchg.org>
References: <20260711043946.68421-1-ahacigu.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711043946.68421-1-ahacigu.linux@gmail.com>
X-Rspamd-Queue-Id: 68AE71C0004
X-Rspam-User: 
X-Stat-Signature: zjejjjsri4ox37dfgwe87pgxtakag97w
X-Rspamd-Server: rspam03
X-HE-Tag: 1783941609-595185
X-HE-Meta: U2FsdGVkX18E7fLb18JZ8KvmQcoMc7eY9EBk9CDDawmXSzLL8fdESlLoLPWe6eJl0pMrg42eZ/uca/Gv61ujb/7jS17jLinCI7Hb1+RB1LKcWY+XIrNIJu5+OJVk7RhIB1uBsj7eB2VINvE8MXVjxV1VHzSs6AyzgT2SBvu0sf/t7ZG1QOSo/JCCrXTt4lN3IvL3ZkzDZkgghgo59exg7yK+JBcy4P9kqg0LR0L5Q671ktlqST4luNJC46Oj44WicVruZ9aiavYjrgZOenIvKPcxiQyCJIqGm+51/V+cX6Q1juK8DFqnEwYJAn8sDhUi+fDP7d6C7k2SXilPOh7mgXPJOfqQcuMqKkFPySHP+rj0WwRorKK/pjIb+3fGfnn2vQGy4OwVQzsZiq01qJcziwYPAQKNBfzpNCu65pUuOXIDsTVGpe0wC7QYtkY9VCc25FmDxJSCU5lbfFIfo36/tfW6px9hwf2J1XIFVBYeR1ORAbYdiEOdDXMoKxPBiodKMXC+kT6H/UgmsnoyRYW1eQAgy+pXep3gPeXxa4AATlkNeW4XBEZZusIywZzMizhu0LRkfhpHEq87+atnNmgpFkZvqm+VOxx5ueLeesxbcuOSfSEfKpgQ09jZ9ywDtZI5QbNUiIJd1apr8BvVdopfnZejDwJarRIBVJ1xRqAzvgUGQ+HCY5UrYInUJKuXWn2fFTC5iTsAGJpP+715yRYMwQeteankIHBPppW40V8aZo+CXRq36l5Boh9sWX50n2evgdHl2QvHk9VkV5vjS7E5gnZJr3usbqEtVdVbVcRC35YwNkZxZQndlgsn0hsP57J3uIlOvFNpjhRBBMc4S4pJpYRRZfsl6S8LSkRsRMCizMwwKhfen3P0DceBThDnQgTirDlIGCv+vESFwOSDguIRSCRARb2MzlbZqic6pquPPbfKyOgqkS2FwmZGcjMFyWSRidUW4j0QkIWNpNjwIc5
 4GJXh5Gr
 B2QSAP1lElhnpItPBVor3BlYP5j6Db1K55Bo+MqzSepjTUc9OK6M+lJah0T04snBKKhEDWkE4avwUbPjhWkNV7APfw+7J2XVK0wlD55bGUtYgsw2V6lnE6tdMuPtJqUPOF7iZmuJN07QyVgUJMPZaguASPPOBqsMkDxt3TwtWbDXdaorZBI+jVnJzIsFjBgZWNmHQVD/j+71vSwXhsWtPVmq/l2akdeV6S5U/k+2Eg3Lhgc2yNN3FQ6IgRh5vofN4klbPg1PxhsRunVWmOXhbAuNXAB3nQYSQtfIaNsq2w1wWXFQeSBvSB2B0Oruy2hUh2hABacV6QXxx7FYc1n1kh0Rbs920pqYkypx/cVMdc/dFfOHHz39VdgFVtL7cfiqbn4/UKnYdQZ7MzRkdqkPlRDqqFWOYHRTTU1Ye4Kfu8Zo2t+emEqc2mib4bzHH3CQPhXUFKa18FQhIzk88JXuRRBRoPIr2CpgnOCPA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:39:46PM -0700, Altan Hacigumus wrote:
> Direct reclaim clears the hopeless kswapd state only once the node
> becomes balanced - added by commit dc9fe9b7056a ("mm/vmscan: mitigate
> spurious kswapd_failures reset from direct reclaim") so that cgroup
> memory.high reclaim cannot repeatedly revive a kswapd that is unable to
> balance the node. Before it, any reclaim progress revived kswapd.
> 
> However, this restriction also prevents global direct reclaim from
> reviving kswapd. Under sustained memory pressure, global direct reclaim
> may continue making progress without the node ever reaching the high
> watermark, leaving reclaim to allocating tasks.
> 
> The effect is visible on systems where a database workload mlocks most
> of memory and the remainder is under continuous pressure: allocations
> stall long enough that ordinary tasks (e.g. ssh) become slow or
> unresponsive, while kswapd sits idle.
> 
> Unlike memcg reclaim, global direct reclaim follows the same node-wide
> reclaim path as kswapd. Clear the hopeless state when global direct
> reclaim makes progress, while continuing to require a balanced node for
> memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
> scan_control is private to vmscan.c.
> 
> On a workload with most memory mlocked and the remainder under sustained
> churn, with swap enabled, comparing the same 60s window:
>                               base       patched
>   allocstall (all zones)    413441          6532
>   pgsteal_direct          15889552        255619
>   pgsteal_kswapd                 0      26079382
>   PSI memory full avg60     13.10%         9.37%
> 
> Direct reclaim was already reclaiming many pages in the baseline;
> this change lets kswapd resume doing that work asynchronously.

But does kswapd actually stop?

I don't see how you avoid re-introducing the issue described in
dc9fe9b7056a. Direct reclaim picking up a few pages is no guarantee
that kswapd is able to restore the watermarks and stop running.

The distinction between global reclaim and memcg reclaim seems
handwavy to me. Either can free a couple of pages on the node. Who is
doing it has little bearing on the question whether kswapd can balance
the node and go to sleep?

