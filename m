Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BB7E94625
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 02:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6CF26B00A1; Mon,  9 Feb 2026 21:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44846B00A2; Mon,  9 Feb 2026 21:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50D16B00A3; Mon,  9 Feb 2026 21:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 906C36B00A1
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 21:36:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D867D16033E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:36:27 +0000 (UTC)
X-FDA: 84426983214.12.46B1D4C
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58A71140004
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:36:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=octVkrAy;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770690986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjDQ6ZMUprUoxKPSBAzYwFLvE0UYKCpqmBg/Zxxlb4c=;
	b=ZHMUnSKNrZpAslTzP+VZcmjjnqVsgoPX/le9leenmUqGZItW7AJLe7lq2QQmfZibPmZ9VJ
	0UhhI6WLsNWaRFK98ZHMIVWOnvpKqWQdPsTJUoHOT0j8WyXEXDlgjuvrkH5PRS+Ft/uxXB
	uaMUopglTNJKgSgrZ/48/8qiYwjEOg8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=octVkrAy;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770690986; a=rsa-sha256;
	cv=none;
	b=0hif8rt8s0LeuvCTBUzpWM9/lQL8KryoytJh7QIlnu7Kv2Bsvk5Y//7BWxnQuOMmcxWqen
	vyKiH2nzqWryXNRG6V2wQruIr9Lvh6GzalK8E8S/1nt/YsqGix5zz7zGiu1adyqORPyKS5
	WyRklARvgysHeMI5ZIHcD/yPl8H6pP0=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8ca3807494eso28308685a.2
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 18:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1770690984; x=1771295784; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zjDQ6ZMUprUoxKPSBAzYwFLvE0UYKCpqmBg/Zxxlb4c=;
        b=octVkrAyUMG27wnaIiks6eAuoAwRc+BGa0i51Qq91VtjOg7Wl+5CL6HLI3aIglIvq3
         +LyYO7eTfR/hnpIZQkN4XenwDjfyT0fMJhI1VoLf9IPOHy3FyR4tKNqDq0ATeA40K1Qf
         V9WL7xfOAfHTapMGIDNOVedRnrEiomm5X5ZElJr3QDY8Kc/NeHx59ncQsYTc7YuPM4TF
         Su1hBJci1TNw4/cElGi4d3IK/PsApQzrCaUAfZCE/PgdAhWMmqg7adu6VD4V8V8xpDxH
         WVkIjaY0VEjoA7XMqRSDLuTv3YD2vls37maUIKUTpDiK6vlh6QTbtAxXBxaaygcjvbW6
         XXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770690984; x=1771295784;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zjDQ6ZMUprUoxKPSBAzYwFLvE0UYKCpqmBg/Zxxlb4c=;
        b=JexQrxvhRwgwcu9qW8Mtjk6axQEO9gIVkiqRmRO7PQvqeiWdmVmeXHIPRmbtQ4NDjr
         QQ7UItrKrulVIfOVfUDKgl5/ETbln3FWJya72a0afN7DlrjHOjltG3FxJ9tg3RxTYsIH
         z/biabDjwkuK3HHGhkYi0LAY1+jQjsKQInI8owRDpsQf7hxEW7mJ30kZ10WFnlonhGAb
         NhgUlVoYBh93SFsaxPWGdz86rYGE3aTmukhmiMY03M5dS11WCxrpp5BU3j4A6OmvY/Oi
         zigbwI3M1/tYxIKohvOC23Tax6TCV5VYEKswFa5DVt+UjbaNwHMNNcRt8YRlD2y/T540
         tpmw==
X-Forwarded-Encrypted: i=1; AJvYcCUbHT4zIP2GkscAvt+C82AxdRwNoqtYSl98I9+BxQP04ljpYWonU58pm5W4t9jJrZtPYs0ItSJMaA==@kvack.org
X-Gm-Message-State: AOJu0YwHwScLgACQgSCKokwiEh6ljIx965peLwn9A7KYv01OaV94buZH
	pEgy3NEQwDGnLfzGFeibhrNkmB1h+tNemCr4z64l6h879Mu1gCVbuTFJQ8QdpFtRMdo=
X-Gm-Gg: AZuq6aJ/j7oEhEdP/1NA2gUSqvoToWtM/Z/Q0osxQpWwr8qq72B0Dhm6JEmH0EmdySi
	ls8BqqNs8CcbrweFJzDXmS9yqM0zEHfrIuFSVUOdg0qqUv0ITOhEoz4N0K/LURn4FbNEz6AjjRj
	KZE74/M+KT/zsNh274fV9LkWMLWkewTI9Xtcmz2mPwYB3R/AoGUWJtVsFTmcaIE/u2pZZmiZAkn
	sEKYv++dgu3Yv3Bsvjb+jsU+iaIOl4hUoISAiaCS6SvZppsxi8cfzIg1uOZ0VB0Qkm39tcWf+ow
	XNuLLhpOGmfGqBjcZ3Btyg0yq8hfpbxD76juzukBxN6Jxg2xQ9vRB5nwLw93LiVx1aWmK0FI8Gi
	6i1leKJAEK09jTQJ3eUDW1YoX10tduCWO9D1jNVjBTsutVTQRGHXu99rmrM7gWebjWvr3AgJftg
	yVdJydJg5lSFkZ9MBjf7mKw0kogFY3MAA=
X-Received: by 2002:a05:620a:448c:b0:8c6:af59:5e1b with SMTP id af79cd13be357-8caf16ec082mr1704468885a.77.1770690984280;
        Mon, 09 Feb 2026 18:36:24 -0800 (PST)
Received: from localhost ([2603:7000:c00:100:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8953c03fca0sm89843846d6.28.2026.02.09.18.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 18:36:23 -0800 (PST)
Date: Mon, 9 Feb 2026 21:36:22 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org,
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, kasong@tencent.com,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	christophe.leroy@csgroup.eu, pavel@kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-pm@vger.kernel.org,
	peterx@redhat.com, riel@surriel.com, joshua.hahnjy@gmail.com,
	npache@redhat.com, gourry@gourry.net, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, rafael@kernel.org,
	jannh@google.com, pfalcato@suse.de, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
Message-ID: <aYqZppn4yDbTP2_q@cmpxchg.org>
References: <20260208215839.87595-2-nphamcs@gmail.com>
 <20260208223143.366416-1-nphamcs@gmail.com>
 <CACePvbXsngZmn0OrJZjvMhhHnL5FazxYX7ShEpbU9RwHSJaUuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXsngZmn0OrJZjvMhhHnL5FazxYX7ShEpbU9RwHSJaUuA@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58A71140004
X-Stat-Signature: ic3yj1kfsm9n6u9x89dqgw7mrr34ckjj
X-Rspam-User: 
X-HE-Tag: 1770690985-637368
X-HE-Meta: U2FsdGVkX19FKtBTkVMvSqx0IHSJYXE0PsgGTxk8d+OfejvmsjK13bBlRlC9o4jbpD5TUf/0X8BCV7bc3xd+djW3uG9nneMH1KpVQx6cQ5JvJxQISrSEarI4K2Ho8ZGn7Osf+d/TjNrZT3U/z29/AAiE8+RjbpyFMT/xKMR29xSYsTLL6EVlhQXuhdBTWk4k/ruUBoyPD52Ok3b/aZItkm6MPxh5N1pIv+ZXoANgf0/gjmFquEt301xIdHz/eCcwDS0eSgP1jKdtlEzJgvZUum7agJ27ZN92ISIHvekl6Zm4RqoYF6n0XB1kxwjPZLjgcTB1dFv+Itc0EPVoC88MePg1fv42PhEk/XT2oYwA4bpVjucYxCbpvetKUGNTY5fBmysBSqO7cYU4Lwrwv2qGo5PFuCY0oFZSxI6dc7aEgowwyjpViM7zI7lBtR+ACuebe99Gr+CJ4QNahc1eVcY3NfwkM1BXNMex79S8yD4b3Wjwik+wTYYGRRflsmT6yTWnGIKUOKcWHQdVVstkPC7d7hEaheftSE5rRUyXQTLrMasHtrbncJIR9Z3i2LHv6sEAL/8fsB/7WhdeTfkiJEKhhcAhPe7fDBcZMBVm/xw41V+o/9Ib4hhVmZkc6BNRJA7Sot6aKJtVo1tGq44rT357iH1ZrMNcjZkciJDd83e9QOjsU8gzSETtG9Z7dxbA65s3vxhV7c0Lm3AHuniVH23th8PebWwazt9VfMK5HWFNzQqKDvvEYW2jVC5mJY9fYGKo27alseP3ongjXqHIbfKahZYeLk/euOEjUoPIpLl3XHRrncGGEuTugckUdhcOvSw1QYTJAJ6D6HyBpmjNxt6rAc7eSa3dNphzMd2toWjrUIYP319WK0cgWaFwf9YvTlekXAlPWBRF57mOnUYt9m1AiBcmV3N4++Bbt8JiDPTf8YRPNJ+lkvzW7NcJeURhmRnoOcQIaf0aHcJkvPOcxtk
 PCOjkhph
 myML5c45+mTsd4fUERPoYdPU1WXqugJGge8fdfNJWZREii4X9/xR1tf1YU8FkFbop1umYKSeZHKnJpXecmgumo7CPLhKql//YFY6krva37OesuAb4qyc2KRuYzqbv5dBPge1Nnc0zuRdX3fhNgdGux7OmnoxuJaBpCFXzNdal7PIrxG4b30nnUfVWrBemNDYM8phRoUjuJDckfTvoM83814RMyCs2UB8JSsZyr/i9QPsLIw9zjMsdu1gKPXuWGMFjVXYRHEMvGECsE7NsU+jAf0qPICkeM5tVa550MKYJsfrS+36U92POpa+KY5/seXq+GwQYPUdqXzVWHUveLPAoZibPj5YiI8kVLefod1pHkxQIyplF8Ol9Z3cohHB4QjSBypTPEBuhG2lw+mq3t2Ec/edMhY47aAjmYBO8n0V/Wn053i24wsHggUJZwimHFkPbIer19klEaAUxPMzREuskzEhpensorRfE6nrQ1+BvgSpojVY3e2YyWmFc+kL2Y4SobMgxZmjS+6mHRfpczjr/aAIDfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chris,

On Mon, Feb 09, 2026 at 04:20:21AM -0800, Chris Li wrote:
> On Sun, Feb 8, 2026 at 4:15 PM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > My sincerest apologies - it seems like the cover letter (and just the
> > cover letter) fails to be sent out, for some reason. I'm trying to figure
> > out what happened - it works when I send the entire patch series to
> > myself...
> >
> > Anyway, resending this (in-reply-to patch 1 of the series):
> 
> For the record I did receive your original V3 cover letter from the
> linux-mm mailing list.
> 
> > Changelog:
> > * RFC v2 -> v3:
> >     * Implement a cluster-based allocation algorithm for virtual swap
> >       slots, inspired by Kairui Song and Chris Li's implementation, as
> >       well as Johannes Weiner's suggestions. This eliminates the lock
> >           contention issues on the virtual swap layer.
> >     * Re-use swap table for the reverse mapping.
> >     * Remove CONFIG_VIRTUAL_SWAP.
> >     * Reducing the size of the swap descriptor from 48 bytes to 24
> 
> Is the per swap slot entry overhead 24 bytes in your implementation?
> The current swap overhead is 3 static +8 dynamic, your 24 dynamic is a
> big jump. You can argue that 8->24 is not a big jump . But it is an
> unnecessary price compared to the alternatives, which is 8 dynamic +
> 4(optional redirect).

No, this is not the net overhead.

The descriptor consolidates and eliminates several other data
structures.

Here is the more detailed breakdown:

> > The size of the virtual swap descriptor is 24 bytes. Note that this is
> > not all "new" overhead, as the swap descriptor will replace:
> > * the swap_cgroup arrays (one per swap type) in the old design, which
> >   is a massive source of static memory overhead. With the new design,
> >   it is only allocated for used clusters.
> > * the swap tables, which holds the swap cache and workingset shadows.
> > * the zeromap bitmap, which is a bitmap of physical swap slots to
> >   indicate whether the swapped out page is zero-filled or not.
> > * huge chunk of the swap_map. The swap_map is now replaced by 2 bitmaps,
> >   one for allocated slots, and one for bad slots, representing 3 possible
> >   states of a slot on the swapfile: allocated, free, and bad.
> > * the zswap tree.
> >
> > So, in terms of additional memory overhead:
> > * For zswap entries, the added memory overhead is rather minimal. The
> >   new indirection pointer neatly replaces the existing zswap tree.
> >   We really only incur less than one word of overhead for swap count
> >   blow up (since we no longer use swap continuation) and the swap type.
> > * For physical swap entries, the new design will impose fewer than 3 words
> >   memory overhead. However, as noted above this overhead is only for
> >   actively used swap entries, whereas in the current design the overhead is
> >   static (including the swap cgroup array for example).
> >
> >   The primary victim of this overhead will be zram users. However, as
> >   zswap now no longer takes up disk space, zram users can consider
> >   switching to zswap (which, as a bonus, has a lot of useful features
> >   out of the box, such as cgroup tracking, dynamic zswap pool sizing,
> >   LRU-ordering writeback, etc.).
> >
> > For a more concrete example, suppose we have a 32 GB swapfile (i.e.
> > 8,388,608 swap entries), and we use zswap.
> >
> > 0% usage, or 0 entries: 0.00 MB
> > * Old design total overhead: 25.00 MB
> > * Vswap total overhead: 0.00 MB
> >
> > 25% usage, or 2,097,152 entries:
> > * Old design total overhead: 57.00 MB
> > * Vswap total overhead: 48.25 MB
> >
> > 50% usage, or 4,194,304 entries:
> > * Old design total overhead: 89.00 MB
> > * Vswap total overhead: 96.50 MB
> >
> > 75% usage, or 6,291,456 entries:
> > * Old design total overhead: 121.00 MB
> > * Vswap total overhead: 144.75 MB
> >
> > 100% usage, or 8,388,608 entries:
> > * Old design total overhead: 153.00 MB
> > * Vswap total overhead: 193.00 MB
> >
> > So even in the worst case scenario for virtual swap, i.e when we
> > somehow have an oracle to correctly size the swapfile for zswap
> > pool to 32 GB, the added overhead is only 40 MB, which is a mere
> > 0.12% of the total swapfile :)
> >
> > In practice, the overhead will be closer to the 50-75% usage case, as
> > systems tend to leave swap headroom for pathological events or sudden
> > spikes in memory requirements. The added overhead in these cases are
> > practically neglible. And in deployments where swapfiles for zswap
> > are previously sparsely used, switching over to virtual swap will
> > actually reduce memory overhead.
> >
> > Doing the same math for the disk swap, which is the worst case for
> > virtual swap in terms of swap backends:
> >
> > 0% usage, or 0 entries: 0.00 MB
> > * Old design total overhead: 25.00 MB
> > * Vswap total overhead: 2.00 MB
> >
> > 25% usage, or 2,097,152 entries:
> > * Old design total overhead: 41.00 MB
> > * Vswap total overhead: 66.25 MB
> >
> > 50% usage, or 4,194,304 entries:
> > * Old design total overhead: 57.00 MB
> > * Vswap total overhead: 130.50 MB
> >
> > 75% usage, or 6,291,456 entries:
> > * Old design total overhead: 73.00 MB
> > * Vswap total overhead: 194.75 MB
> >
> > 100% usage, or 8,388,608 entries:
> > * Old design total overhead: 89.00 MB
> > * Vswap total overhead: 259.00 MB
> >
> > The added overhead is 170MB, which is 0.5% of the total swapfile size,
> > again in the worst case when we have a sizing oracle.

