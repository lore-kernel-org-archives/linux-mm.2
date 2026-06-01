Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A39CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD9D6B0325; Mon,  1 Jun 2026 07:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F356B0327; Mon,  1 Jun 2026 07:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E096B0328; Mon,  1 Jun 2026 07:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43D936B0325
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:08:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 141494062C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:08:01 +0000 (UTC)
X-FDA: 84831069162.11.63CB2C7
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 18599140005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:07:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sIfC5YAh;
	spf=pass (imf09.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780312079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tMRr0555UkSJVpwevwwfR/bu9FaT1rWJqjveLdcveY=;
	b=gfMh4GKa2Q/TE0kaG46K+sPlXjWXObr5PY1fMaq7SWK84hCI+n2QoFolOBhoM/8gnqvs1g
	qPtjbff24sucKu4JZymenfzsZobJA4A1OB1/XHamd5qB32+kEKAXoojPJTks2KeTM5Fizv
	KvGXQhszRLEzYFeFTrftjS1fWkV0AxM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sIfC5YAh;
	spf=pass (imf09.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780312079; a=rsa-sha256;
	cv=none;
	b=k81Xf4jzV8+/PQYKb2dDoCI2NPCRfnYdwpNnaTJ3/TfxEwoUIbnTn2/JtQyF+f0LWB+o04
	rcw120o1vakHNX2Mv+g+YYF/KJ8p9E5KyhQNCryej01LaxP7DxBcbhD7YMmgPVNWdPDGo6
	289yXDSvnbI2AAYp2UbQNQX7e9VTbDs=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8421f0e9c5bso828805b3a.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 04:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780312078; x=1780916878; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4tMRr0555UkSJVpwevwwfR/bu9FaT1rWJqjveLdcveY=;
        b=sIfC5YAhTeA6T68hMGdR5H3aK88EZxanayQeLdGJRe0KOIX0wCoV0eWnydPuXMrRhQ
         eEEyOEftpUvHyQc4rohkayBGNk7R8XZyqYgIHcbLXddK6uIWyFzmtN0q0Flrp8Lct4me
         IG5LaBBT9xjyYXzHZwqm3WEatVYEWhTnqIPCYkSS6p1/ZjnVljysrLdAoZNe6Q857J5r
         4NTvd7bduFp/EY43n8rCn49JJUq7H36l0rcBgLVV0JO4nrQMJOCfbh+h38W4NbECc1qb
         pFKVBNaOrzZ5vW1WjNAGoM8hQVW7A3A/jxZ1thC9Aeqb98Cy0vHqdIbdkQgObX3RJCNE
         dh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780312078; x=1780916878;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4tMRr0555UkSJVpwevwwfR/bu9FaT1rWJqjveLdcveY=;
        b=P9wc6Ts9is2uf1DTcTmPyZYBXuinJ+Kyt18wPF+XrJvCYFyDQryJ2oh34G4H1AQ4vO
         T2asiImxVHFftiEsfZ8p7DW3hn2q6VCAM7fsns8T9p8oUq3tQKUXybNZMxRgJFrNeIp2
         qYdxjs9svz3LchSPsgE4iVhrqr9bejb5lRSsjvw9ZajUMudIBqO1xUegiRmun9uWdpQV
         2SvhoNuKjIXxotjREXO8MMJ5OUMSxbKE4QDXRDdn8wnzsB3KLI5YOcqSIkEhUt4DhQxS
         2d02LFULqkxWWP2mAotjrAhBmWzT+1AX58VvHBSGpvlRD7Me7o9sBovsLOYLzCGTUpeC
         B1Kw==
X-Forwarded-Encrypted: i=1; AFNElJ9+p7glA7QquMh9THBC90K51eJzbmcarUb3zhQs4bbY4ztBZAQzox4sT3OqW91/bxHzOKNeVaqMQQ==@kvack.org
X-Gm-Message-State: AOJu0YwiBS/NoNGqnMpwnXNUjOMYrwB3c4yg2y2FjaZDGxxBp2VyggwR
	QwrMmWaGTazIZk3AoiC718mLU1wWyX3gQj6iT5oDNhsXoLUUxnpCYqbF
X-Gm-Gg: Acq92OFXkOHI38fk7iCKY2V075N+NrHa3sLHqkDdPvl/D27YpOhK5cB0ZVkZqHrrBdz
	booWUUVb4OiOtG7+BTOt8dIdzlrYVkaGIF49c1WCtFFXSxZqIxpKUIMjw+heSWgaq8kgrUs/KOq
	sE/2TSez1NshrSllQxrJ80GNWnxqGG/70h/ccFzsHzx7fsybOONyKTiGd3GfAKMKUZdJHGmu4z9
	t1qdqONRYvzSEDpT2zc9Bow5EFGD052224fAssw+7bmjywdo4ZB1kAzXQKFHyXS6huaSIJ5eQlt
	Sb2Tb0hD4w59huhcQKZI7G2Z3eAcYMzbqm2xBPCScOWrlt6g7Be3fMiCYGdrejkq/bSqXm7MoXq
	QPr0gbj5oo4K75Aba32IsgGXxssaHwoak9MPh9iQC27c/0lTICWZcQmals4jPvGHDWfutl9n3S+
	arc/g4IqsaibHiCElyA8X5JS9vstxx7OD5yeMrki/at4Njz/v+tn8bXrZz2UCPe14M
X-Received: by 2002:a05:6a00:190f:b0:842:4612:55f4 with SMTP id d2e1a72fcca58-84246127062mr5297173b3a.31.1780312077721;
        Mon, 01 Jun 2026 04:07:57 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214ce9cebsm9839131b3a.52.2026.06.01.04.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 04:07:56 -0700 (PDT)
Message-ID: <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
Date: Mon, 1 Jun 2026 19:07:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <aho7nepN5jZtKmef@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: scegk7mz6k6yughpq4t1fnoayo97rowc
X-Rspamd-Queue-Id: 18599140005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780312078-659152
X-HE-Meta: U2FsdGVkX18dC648eatR92bZHhdKFEPrypAsXBwYIE5IfSeea3c8B0KZE5doTeXdJe7TqVFyUAaUUAf8ZA0mpP25eToLoa1fG0XLiZgRxjHrmjA5XOORnZiZa0rtemeO1oyVzmw2uuepIdMRx6NSdss9LlR+wsTnPDe1pksPF5g7iMW3RJs+JVClGiGqLvldbnocy9jEngzQctEGm9ab6k1Ut7RpHrxKcSZhm8PKwWJitC481kpqMZtBOL3HzsUW0/xucVIdC3m5lArND0R5AkF/IOiPomxLsvU6sFEgeGQua2jcNn6cUH/WLIm88IkmKzhg//OVccNvgw7sp2pbTFyDa6tUzWdMqaNK+Rczn5aifIk9sXORb7F3WrBrD+u3PZcICC0PdEutgf62Ufsjs8Ov5n5p6xuDv2R9A05T9P7h3Eu7dMGhZooIBZW5k6Nyv1y6pRG9G8NYt/HGwAai/F+tgViAXCKrLDrN6IbwRnb72jpQhoSQP9u1aDovBokyC0K9mh/xto632YOeH3BCo8bKuwn+L6fFlM4CwK4RkDKfyxtiJ+PnqVwQLXCGYHNIBTWa7R1w7bfA15/YgAdB+Ow4yhxjLlAT8PXKJTfoekK/b0OJC+5jLlIpSPCtL9c384H0fh4OI9GHRmOpdms4XD1ux3V7nb7kkF7a3XyDsq1UPPYWjfjR4T0tgG7UwVja3zdBfVLtc9GTOE4GxN62P3wR0XrXSk43JSF1Hr4KpsNgt0tlfIY2XYi7OgicoiD1RQc9a7A0HEjnBC8r8oSfy4VWa546b256Bi0iFG/J8bFgzfhakmFMmTTNpnzPSB5MhwXWSM1h8zHEm+Kf8SewgSWSDJtD+jg3iRL2SA19SNJ532MmjbWRCZMoyQlH1MnlpkdyOHGr/yIlT2Jg2g8s+1hgCtKg6GFHD8nN1W4a6QjwRdtwdjZ5ebybveKghOxmKSoXOnhz6v6BjtuDv/Y
 SelRufZg
 MArXvSBYiUi5FwSn+X9VTKSoGPkhug3JyAHCIDr4WYijAAUXAlYC88t0JE1u1d0ezAMREBtsgl+h9hu1mNa+CX5J6nLyEncad+kr/c8dqcYrfxlyrFU9rUXCLQescpDvDGVGrx6M0GjicfZAvwNbt3L2Ub8vLsu4XExKJJUlbvKNzbe796OBX8tJez/CqfnZLeX5ABt5eAS3us8CDJFhLxyhwQrNheXt3uavUON50fFXI8LbPTomdOCDdIqyXMgnHZgjj6kX5RmvVZ2Zj4eLJIJXZ+R5DlA+niuWlsanQ5LRBs7Bdxk+FNMskZL2bxOeJH3lV4hLpcouFBmuPt84Yiqf8tqkQiu1xoy9y6jl7cos65ShApwueJYSzRzXsjx3RBx6Mw5ngIZrd1a01rhVFwPIL6rzYL+8+NGsWKL4WYvVej6UKtUszLMy8Ri3Rv04cKYCoA6NHfqozRoHua518rgcJPZ6r4/Nkga55DpgveheKpiQirdK4cl64RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/30 09:24, Yosry Ahmed wrote:
> On Tue, May 26, 2026 at 07:45:58PM +0800, Hao Jia wrote:
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> The zswap background writeback worker shrink_worker() uses a global
>> cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-robin
>> across the online memcgs under root_mem_cgroup.
>>
>> Proactive writeback also wants a similar per-memcg cursor that is
>> scoped to the specified memcg, so that repeated invocations against
>> the same memcg make forward progress across its descendant memcgs
>> instead of restarting from the first child memcg each time.
> 
> Is this a problem in practice?
> 
> Is the concern the overhead of scanning memcgs repeatedly, or lack of
> fairness? I wonder if we should just do writeback in batches from all
> memcgs, similar to how reclaim does it, then evaluate at the end if we
> need to start over?
>

Not using a per-cgroup cursor will cause issues for "repeated 
small-budget calls" cases. For example, repeatedly triggering a 2MB 
writeback might result in only writing back pages from the first few 
child memcgs every time. In the worst-case scenario (where the writeback 
amount is less than WB_BATCH), it might only ever write back from the 
first child memcg.

Similar to how memory reclaim uses mem_cgroup_iter() (via struct 
mem_cgroup_reclaim_iter) and the old shrink_worker() used 
zswap_next_shrink, we need a shared cursor here.


>>
>> Naturally, group the cursor and its protecting spinlock into a
>> zswap_wb_iter struct, and make it a member of struct mem_cgroup to
>> realize per-memcg cursor management. Accordingly, shrink_worker() now
>> uses the lock and cursor in root_mem_cgroup->zswap_wb_iter.
> 
> If we really need to have per-memcg cursors (I am not a big fan), I
> think we can minimize the overhead by making the cursor updates use
> atomic cmpxchg instead of having a per-memcg lock.
> 

Because mem_cgroup_iter() always calls css_put(&prev->css), we cannot 
simply update zswap_wb_iter.pos via cmpxchg() after calling it. Doing so 
could lead to a double css_put() issue on prev->css.

Therefore, if we switch to the cmpxchg() approach, we wouldn't be able 
to reuse the existing mem_cgroup_iter() logic. We would have to write a 
new function similar to cgroup_iter(), and its implementation might end 
up looking a bit obscure/complex.

Currently, this lock is only used in shrink_memcg(), proactive 
writeback, and mem_cgroup_css_offline(). Note that shrink_memcg() only 
acquires the lock of the root cgroup, and mem_cgroup_css_offline() is 
unlikely to be a hot path.

So, should we keep the spin_lock or go with the cmpxchg() approach?
Yosry and Nhat, what are your thoughts on this?



>>
>> Because the cursor is now per-memcg, the offline cleanup must visit
>> every ancestor that could be holding a reference to the dying memcg.
>> Factor out __zswap_memcg_offline_cleanup() and walk from dead_memcg up
>> to the root.
> 
> Another reason why I don't like per-memcg cursors. There is too much
> complexity and I wonder if it's warranted. If we stick with per-memcg
> cursors please do the refactoring in separate patches to make the
> patches easier to review.


Sorry about that. I will try to keep each patch as simple as possible in 
the next version.


Thanks,
Hao



