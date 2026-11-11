Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54AA7606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aJYB8BKL
Received: by kanga.kvack.org (Postfix)
	id 621296B00EF; Wed, 11 Nov 2026 12:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D29A6B05B0; Wed, 11 Nov 2026 12:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C06B6B05B1; Wed, 11 Nov 2026 12:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1922C6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:39:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99728A0398
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:39:47 +0000 (UTC)
X-FDA: 85423550814.02.291CCF8
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94A1B180009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:39:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aJYB8BKL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794418785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8WdTJwjtLS64rhFGeIkjIRb/IsmmVNj81Iwt/U0SP0=;
	b=bMmGwD7F9XJN0gN5Vixq3fW10vIeA9Bld0kSBxZ+nQ28qOd8YlOicp8eWo62VUdKbqctha
	4TWvJyg5HBW1+R8LzdsJead+hPmWmZUTay0pSOP2s3S48mNN6lojiPsPjQCI5w4DhowuRe
	3eUGbK/1Qg5UQbPtyFbyj6DGU6Qz2mE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aJYB8BKL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794418785;
	b=sgI3wl8jF2DxQaLLsoe8kM+1MyxX+FS9Gz0wfKMrZjnK64rgFgOG5Y5f0z0lC5Bsx1qfbZ
	wsWhcZCwPyvmjTjxyM2a6P215OczHKV8FygUnBviBeHllNXk09ir78a/ZKjrk09VZLhrDs
	kX6Oi9J/Wny3jIg+OY2u6RjOdYgnPLk=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so31805465e9.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794418784; x=1795023584; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k8WdTJwjtLS64rhFGeIkjIRb/IsmmVNj81Iwt/U0SP0=;
        b=aJYB8BKLuIzuF/Uv+HjgjimvNuHkS/0d3NxfK8L4c7R2v0mo9J3r3sj8jpNPOTDt2u
         y348PAc1VW5/t0zh77bH4pcfuJ3wGmd5A4ktSNeeRrHvzw47vZU+HxsRU4XL0065ZSlP
         PZvBUJWNNrkEOny3+4KFlasKdYtTfYiyajrfHax96xtTdiX+HkxTuL+fPM18BuO8ouFE
         680LcENn2ks6ue8SrMhCF4G8Ik121PKlLF9EWBpXWqBOJpwDeu8+JUBzub/SnypwA661
         A+N0tHMSgZiwdIBN6UhoH40YqB083Xesg+PJUZHW3eNeQc355iH5DN+KvpE7tLnjH1Bo
         R4TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794418784; x=1795023584;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k8WdTJwjtLS64rhFGeIkjIRb/IsmmVNj81Iwt/U0SP0=;
        b=wx9lHWqdfYFiScfGyPa91vj/dF+b79q9b6jyxk4c+4G2DBfRjtM4l8ILuaUsMnsob7
         RkDPUR4HKdeRmbRkrOoptrWR6M+h0npN4nw27LzFRTkZwmFX7pTS7ndnphnyeDf8EEnI
         CdAsDHJ45DFVTQSZe9EJYk3vJYIxHt6by+FfSARTgEQHBOxaYAR+Kr0IR/8zXt9pJaiW
         NUmdW/mdDZBxdG/d8+slN5RkCzqUD6WSUL2Q6YzuE/mo+b1QNXUuSUR89zww7Z0fjDfF
         7q463ICQT7ZDWovQ/jQABK44XPVFux19Ry7u+CnO/gbt/D/R3lWavYKCwjVYw9nvlJaC
         4XcQ==
X-Forwarded-Encrypted: i=1; AL+hErHjIbQP9+06gJINvphrN8wKArbuDg94rnQytJeXQ8tPsUjJa76noZKNw8612gppRLTvw5/R5knEfg==@kvack.org
X-Gm-Message-State: APuU4Z/AKAhrflNByyATWHpegrkKZZw2h3IZuYzMGU6eOeSThyqNLXPF
	IdkH8qJna0F80o3UZFr/3coKNRR5EbI76IyBsDmSWxE8mRvL0Ydtw6gu
X-Gm-Gg: AYBFou2PI5b9xdsQ7TR3oZUHs2i4+QxWtVwLnj9vefPkumV+c2F+ssuRvbQJJAiwHJJ
	b/eI4VoGQ0LHTCJGT7xdvI8wdBv5erYff21LHoDl2w7eiCQEBNF7DS/H5TABnpAYlgfv/ywy2k7
	mcXxTEHK/30brmBCelKzI0GMui4MdfyuMY/mZTJPHsrnXgl3okk6+qdGStoKnMwPIxtc5Mfkb24
	1GjvUM0pcEkZ1wllNsQN1ThrEVprRkaVBfpZYVNigO5EFUeaIuLQ3uYEYQGHnDH4zMbmqSdH3Uk
	r3YTwwWJx3M9beghpoSNi0xWEuQE48zdw4STMNEr+tOAlAMoRcZq5B0Qv7gp5JZWpfQ1O0X0f8e
	GEmMr27GlH4GrW2AYNsPxhq0UnGC4ILDG+LHUXBK5ebEB4p5ZejXJTwBrg6+lNuLz414GRuFpqk
	ATDgf19WtHplTzHAbLSsy+csymHHkbMN4U94ejQ9w2azQn0+/MhwbxtTCuI7jtHgJhrozOOOXtQ
	10Vl8LITDAfV6dtYg4tpQkO0ivxdMHwV/ejGJnNmaWXWdDHH9Ew3ZUPpWsVbw7d1lJqrko9fA7w
	7H1KsoZIImXx0FkxJS7OBKAslBLRUtV6QmVQbhkWLSCle6G+6p6QmG1GdBiABkh3pU85
X-Received: by 2002:a05:600d:82c6:b0:4a3:59c9:a758 with SMTP id 5b1f17b1804b1-4ba0937fee9mr61515195e9.32.1794418783899;
        Wed, 11 Nov 2026 09:39:43 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4984e26f8e3sm11087731f8f.1.2026.11.11.09.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 09:39:43 -0800 (PST)
Message-ID: <0dc5be55-48e2-4973-8379-a23a94cea0b5@gmail.com>
Date: Wed, 11 Nov 2026 18:39:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Gregory Price <gourry@gourry.net>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94A1B180009
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 568qk9jjb7q7djt9kn37hdn3ebcu87hi
X-HE-Tag: 1794418785-559976
X-HE-Meta: U2FsdGVkX18CWd15lmorlN3M7uLPSt8pRf2a+sv+UhLR9rCmGE/Xx6ZVhYDUaKt4feQOeuiBanIl3XsIT7RS97ltsfwUJLRH61VjOBeT9KoAJgj+uYmPmNdn6AxB8eqNYQjB+hTK6spVIemWyIhCEanDK5XBhHIPWNEVGdlqYc6GpVmJHsGdsi3FBvcR8ZkMdWv3Sd57qFT2EVugd4fMzg8qfu0wKaKy20XWIHpeLQy8RwK5fOd7o0IDJG/O1o2mzk8g/bCVRSbWck3TATjWYg8gdNC8ucqnjT/FpNyJFbluc0ovzsmMQJjt4vKvK72v/OB+sFxHVCDJNUHW59HSa3jGwg2Mk0HTQpnmyJewZcvTlLLDXmKLRbMHu8h3PRa2Od3wOYcktZ1ejxWyvIrL6PI0vG5CfH+W7mVmz2G3WEJki4mwPtITQ6fG3EgEkeba1h6l5TgJDSHI2JXE8665Uj54ATYnSFIBU2IITHUtVxm4iod8emF8cWoJBje6CHZzujIcaFGNRP4AwwiBxATqCNclZse+zBPrZJwawCS3BRZlC9gKXCn9MXOeuDr6aSJBoaqn5vJYey3A7ZiZl+kJEP/Kg4PBOSwQUqvqZdC7j1PibA5hBI2eXQDHPcQ6rLBcf0sEQLkha4JLQrQmoeElueFtEu4njTfCYNWoLNUw3hP73KEYE78MmkrorlDfv0JN2xjm63p28NcSbZD6OVCqSx2SDe912SatHXOhWtPJNIcioX8h0WMlBaDEFzGGbT0pGGZsliJpx3jQ32ocx54SJG+46v/yipS86daSNxu1Z3/IWJBkSfRsL8J0xvoXf6NBrluiHusxROsn0GM1BM4wyRIIHSUDYk1VajX4EEl/C5oCzUNJQ7f+6d+G0g+MYJvT+YQ5dnKmwB9V4ts2XZFdN1rZKdPpXATH558X1QpWd8aJkaxnJo11lL8SRuoAIKSeqgw6zPjuZDrs6b2iI7B
 zy7ZLsRn
 62drNK9jLK9yF9KuQfsWAmRs0n1IAGYTlFRakyZS4o+Nh8BF/t8TRQhzazFAwvD6Q+WB32NsZNsY96sQXGYIK5iYbKt+ZmErynT5lOi5oLVqcHmKlt0qm7/jI2H9eRQKQg4cl32LwomV8HUhNGzdmJVjLS5xPAiowqMmlcX4EnTypsZKOMC1cMpNDxILOjByUgxLO43cG5e9NAoxbqNRmCxm8F4FiAJie4NMn+z9KACwB+iaW/imT4KTgZ3j/ddQ8pRIgrc8ZJOStLKlMhghVjf3kRcFPlnrvCXLv46RFWwUnic22uFW1dwBejpPi9S0k9h2G1NgjWDYaDO/spZDeoaahxa8nmEHwj2dGRYxBVI9lC/wZzjY/8fPtPVHbIuNwn2//rEwzzcJakju8olsIkYUnvcCB5DpR+eHM6ctIKNjXzDrkRt+KhfO0EcDnu6Wy9n+ICNu0wQZcMahjhsngA56UzpAB0a3BONFxB+0usTx6CUamiqMBPExgussj7e24+wfgv5LrnetUQU68pCxRowK0rFbStTnTAbk+2dXLA252QWSYMeKGLIZUEmDqKbxSmgpQkdN5EGiZ1QLl7QS0VltsTGjmflVcnGMpzDJmj/672R551mcYkmj0wdVqSYoDEoHJPYz/ucokfnJcoeemUu+tQTe6TswbscuxN2eiVZ0brBa+PwTOpWIxv/JaCp2jFcG6ro73yIaquOSWJALeHW27oMWR6SDGkFuv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 11:44 PM, Joshua Hahn wrote:
> Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> NUMA restrictions") makes get_page_from_freelist() skip any node with an
> active kswapd on the first pass through the zonelist, so unrestricted
> allocations don't immediately consume the memory kswapd is freeing.
> 
> But kswapd is also woken for high-order requests. With THP defrag set to
> defer, each THP fault that fails on a fragmented node wakes kswapd at
> PMD order. kswapd reclaims a batch, wakes kcompactd, and sleeps until
> the next failed fault, so it stays awake much of the time even on a node
> with plenty of free order-0 memory. This means those order-0 allocations
> get directed elsewhere.
> 
> This was observed on some Meta production workloads running on 2-NUMA
> systems, where processes with a preference for node0 allocations
> continuously allocated order-0 pages on node1, despite node0 having
> hundreds of GB of free memory.
> 
> Only skip a zone with an active kswapd if it is also below kswapd's
> target watermark.
> 
> On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
> and defrag=defer, I ran a process that prefers allocating on node0.
> With a fragmented node0:
> - Before the patch, 68% of pages were served from node0
> - After the patch, 100% of pages were served from node0
> 
> One remaining gap is that since this uses kswapd's own threshold,
> unrestricted allocations can take what kswapd frees above the target
> watermark. The current code already lets such allocations drain from the
> high to the low watermark while kswapd sleeps.
> 
> One potential solution, as hinted by Johannes in the discussion from the
> original fix [1] is to add some kind of fudge factor (for instance,
> wmark_pages + high_wmark_pages - low_wmark_pages).
> 
> But in tests that I ran in a VM where the allocation demand outpaces
> kswapd, about 4% more pages landed on the busy node and kswapd reclaimed
> about 15% more, but kswapd still finished and slept. So let's hold off
> on the fudge factor until it becomes an observable issue in workloads.
> 
> [1] https://lore.kernel.org/linux-mm/20251001164131.GB1597553@cmpxchg.org/
> 
> Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions")
> Suggested-by: Daniel Hodges <hodgesd@meta.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

