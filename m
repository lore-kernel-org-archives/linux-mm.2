Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5C960A8C3E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=QuxLbK/Z
Received: by kanga.kvack.org (Postfix)
	id A32BC6B00EF; Mon,  2 Nov 2026 11:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E04B6B05B4; Mon,  2 Nov 2026 11:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8446B05B5; Mon,  2 Nov 2026 11:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA6A6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:58:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD4B0C0191
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:58:31 +0000 (UTC)
X-FDA: 85390787622.13.C3DDCAB
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA8BF140008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:58:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="QuxLbK/Z";
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793638710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCxj1N9WBg3v8QOr/cS7tYQ7iVjrM26lFVbbv3e0EmA=;
	b=KXWytbakn7DR0Q+8mjz/cw9tmWmUkN7K4NsDOtsb+2UH/VawEr3XO5cOguFeI1dHhQeuhP
	0ynoXYJ0ZHNdgdEiM3p8yVuf9tyHIqsRGtTDP3+NrZOewZ6Rg21Fh+NDVvLSbN5ur8xI1p
	qs5Rm/Q9yd/DT8ksZoNqgh0DSVe/5+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793638710;
	b=Fk0DcCH5J/0P3gqI1dd0KZNBywIQhRS5BeX/9iTOAzd2WoleNm6ak9DIpDLPB98Mb7kjlU
	TK0ecaeE/jFoa0dmNiqdo9adPVTClxxZKMSyiKkOdQih51Sg1L20bTDlZZGTIXfN/kGMEB
	mf6hGZjgDHOMhPoQk4z3Tj/kyQoLs7I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="QuxLbK/Z";
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8ac4806e210so26719127b3.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 08:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793638709; x=1794243509; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cCxj1N9WBg3v8QOr/cS7tYQ7iVjrM26lFVbbv3e0EmA=;
        b=QuxLbK/ZN44w+RSiJ+jHp8YuAQedDT9EthLMrbNJztguPpkrr5fjE31pYp8iJell5r
         jrvhM+bxxOy+rqUvnx4rFZ+WgHDBUOwKdVYnkd2flTVdeTjUDqYZ5GWy6LTAB8Qm2C0A
         88eCvwJdXLKls019fDP5WtwKWoI9C+7XKyA9s2sBq8fkxIHpFYAx+e1IQRcT3CDIHfR0
         Llxt0Yr+icuzRGulTEQnLJw0oFcY3Tg9yK/uCGoMySozWPKaoOTtusX2Mbvv9tJkaq2N
         85XGiU2xhaqJPAb3pgs0heZGd02wLLB0PPTyNHrVhlkH7ktU6FcNFEkCHVUbJFwgJGCW
         BYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793638709; x=1794243509;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cCxj1N9WBg3v8QOr/cS7tYQ7iVjrM26lFVbbv3e0EmA=;
        b=DNauE9VdGoOS89nplpxTL4d7lYReHWHyDlPsZsDG5ZHOIJqM0cLkrTzFvvOV/PrFKs
         JHFTnjVHd2WIG7CrMNiK3UlWDFlMIjl8JH3ziSAgM/RVR0fJOhxEiuRPfbQLuwqkl9VS
         eAL2ly9apf+2rRib8MEZpmEpP2NRSV5YfOHQLZtRgPVeyuFR45cDrzgkilFv0txYVbI7
         nZlm0JYtL6sFK0haCUIhcaHu97jfuynvpyJNK9lLkdi+i2Iwp50z1ndvtyyvSSh/HrOc
         8Eed+E3X75p7PUfhi1BRprEE9IJ7W3sA1yUdWhjWEdqviHfVhc0f7VSKc3w75A7F2VHE
         eVpQ==
X-Forwarded-Encrypted: i=1; AKwUvBx9+DdOch3t0lqo4rqc5RqZDNKr7jxyfIL471R016SKFZIBV06KuI2GzAtB9+5/WcoG2HQ0czuVxg==@kvack.org
X-Gm-Message-State: APuU4Z/I8XKaNyrh6dEGVk15wX6BN9+K+bfX3gZsk0Bcqan2xKQGKZr+
	5YKCG0smnfAG4E93Lqo8kf0K/9NZVNx8dvPPhZ3zIul8DeESZDpjEhQEA82zt7lV9UA=
X-Gm-Gg: AYBFou2ygv0iIyk7G3UXVo09p9I7AWEzrm4p8CbFvrXUl8ipPC6CGgmr1W1kNV3Rrx9
	/OQ3Yzk36NLySndC3xc2x9jc5jzB63RKPY+Cl0GG5GOqM22WfwpgqloVXeumskhLLBaCmEk0t6H
	axNfxGBgDMHehCcqmvDfRetee0e1OVB6YGkTGTVLRg1KRXWqxRsLUt5jYIjWZhhJtw4VSnzcdXu
	XDC7gfmRjU0ZVT4YnHE/npnMGhj0OJTRpwgkfwmXqYfSkbN6NulVeLNtZYkXpJSThE/SMVCVO5y
	J5oDvDrmtCzhmI//2FMkgQr7+sWhukShpreKKzPOVcCE+eiiYIjsXczkjVQ4ZAYuglrPZ+fCHNk
	X+0tHRSnCoxjPDR1GY2nJuh4z/zD+gq27a/PDy2p1G2ZjDiNGPU4+80v1oFHa65PttvQyDOHeWX
	ywb+FC/dTVOzX2r6bo66NS6I1G2uM8HuABF6+YuN6pCJNu7IWgo/WgyY2kzmEWagyTdlUWEWNk0
	9h8iBrZTeQfb5XzM+kJj30xRm70kHJ/6AqLV+USFgsBk4vWtSmtbWgCZehYkXf7/AVOEGMT8cgF
	Zgy4LO/1jykY9g8pQmRIyxpSAXys
X-Received: by 2002:a05:690c:6d81:b0:8b2:e0c3:1f4d with SMTP id 00721157ae682-8b2e0c31f7fmr27946947b3.37.1793638708798;
        Mon, 02 Nov 2026 08:58:28 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b7194217sm56780477b3.35.2026.11.02.08.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 08:58:27 -0800 (PST)
Date: Mon, 2 Nov 2026 11:58:26 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on
 writeback
Message-ID: <aujBMrk-nFaVtPsB@cmpxchg.org>
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
 <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
 <auJkvb-Lq0M5Enkz@cmpxchg.org>
 <2bd4f0df-80c7-4d32-ab50-1225681ff6be@linux.dev>
 <CAO9r8zPuDtn1S0g8rDnXNfSdZ6uuH1geXALDN5-X_SZpM_W+wg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zPuDtn1S0g8rDnXNfSdZ6uuH1geXALDN5-X_SZpM_W+wg@mail.gmail.com>
X-Stat-Signature: mrgxra7r81zwzz79rp9yw93w1njg1jas
X-Rspamd-Queue-Id: CA8BF140008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793638709-737032
X-HE-Meta: U2FsdGVkX1+4M/rycIJQB9tRRthWyR6IA1rxTZdQwFc7wHQQUm3cyqa0ViP7//N57q4choaN/cd+Cy6dFuZV4TQRpG3jxNEc/gtJvMgs/utLYRvW6xuOiyx4Uu3qNX10QGus5DOwn8nDMjJ7soThBarn/6uISCmuCZrNp0Modtf1izKpLzRiTUb8rlKqNYS/hqy49NmRwK3VBQ6uBdJS8v8luZwUFo7gDthA2bModUOmOUJekKcyNIFQZEtWAmwLG34/hSF/LxqcKsmJcP5WMY7TP7FFr0BATXcsyidopTXshAW8vxSGqCR6K2MW1l1FgTdbrtLq/gZeNjPrqxCPNJ+Gp0ES4O1TMJbVt7ZN+5Yn/A6zMppB43OrE5w5WMygn84qXcM+z+tVDi+U1T6FSQhBVH49HOszhT9JIXkXhA0UOwQai9VuC3AGuaBn9Y3R4gcuEXbAuMUUSyARQ7f5QKW67cI2MmP3OIDOTNbQKToPbpTaPkbFiYKKIFH0RpziiGvwBd2rLgT2ym4uptpqXOzdvSkJalgkJB2qreYjdMNqNfLn/1fU1vp1MULwQvZWthivpdt4RWJPjF2MJEoq5OHjLSEl+p+jqYmRxpcpCDhGn1Iao06yX9OIPkPSZbwEwxWjxfiQwcxz/YIJtnbhBbeavnECCkLmVuub265alPrL9lxguCUq0nKw7b4NMHAG8rU/afy/EqZ4JCjlldSWBrmvJucB2Lq9pLsH1ZjojFx7q2aYSbSNTF4T4gR5ozqCgpoLEFSoMAp3GLvcj74+4YXofHxMKBl//SKHMqjVlT7B+qjJxn/mBs3ql4juIq7Llb1YpwePa01WUa9xgVqq8ksgpJ9brXdia8yznWXORJWvZYrMxT3u/W1zDJWTUeqs4NrM7WraR89zoy5qFbYbVQSZ4kTpe+4t61Up/am2L11PyUnzUhDOwA1CqVZ27FLjFqqEp4twSR0D1tOSdzT
 4giRN+w8
 UB2uzeV3O0yZR/S6ZV5pG1HBu89vhEdH9C4q/1N2rgUmexaKEoTLKopWby+kDsXquswYa5rn9BaDTV2fwRKLetqfC/YCt7FhUCpAsL/5H5PLmlpEPwwGX0Z8Da58A8vKc7PG+9RPhR4CB8feOcWlU8BUKenwWRmPkI2DRIAc8S9tulIfkof4E07rpljFP2NjfwFx7JsUi2QinLtKHUXDuoMO/gQPqydoXPQzU5X0/odSNiTgTEB/ol6LAnbAdmcuckE0Z9OawpPm4dS9+be8N7pbYP6YH+otzLl4Dne67bcaYEt3iFtPjTDAmNnHtTqv6VQLqd/iRvO9yUZKTz4hJNG9En92jG2jl9N/Ju+5Yh2Iq1R0CLcuG8KgxVo+LXioR/nypeFwXg71977FmmlonuyFulFala1aSWBLkgTCFwovBkqGmR2gkhIAvCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 08:10:54AM -0700, Yosry Ahmed wrote:
> On Wed, Oct 28, 2026 at 9:23 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> >
> >
> >
> > 在 2026/10/29 05:10, Johannes Weiner 写道:
> > > On Wed, Oct 28, 2026 at 12:22:43PM -0700, Yosry Ahmed wrote:
> > >> On Wed, Oct 28, 2026 at 4:36 AM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> > >>>
> > >>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> > >>>
> > >>> Successful writeback calls zswap_entry_free(), which removes the entry
> > >>> from the LRU and decrements both the sublist and node item counts.
> > >>> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
> > >>> to decrement the node count again.
> > >>
> > >> I wonder if we have a valid use case for adding LRU_REMOVED_COUNTED or
> > >> LRU_DELETED instead to simply avoid the decrement.
> > >
> > > It bugs me that it's the walker, not the callback, that adjusts the
> > > count. That composes poorly with the normal list manipulation API.
> > >
> > > How about pushing the accounting into the isolation callback, which
> > > can then simply use __list_lru_del()?
> > >
> > > The tradeoff is that more things need to be passed into the isolation
> > > callback, but that seems reasonable. It does make the change noisy,
> > > however, and we might want something like Kaitao's change as a
> > > backportable fix first regardless.
> >
> > I tried three approaches.
> >
> > The first was "pushing the accounting into the isolation callback", as
> > Johannes Weiner suggested. However, as Johannes's example below also shows,
> > this would require extensive changes across multiple subsystems. I doubted
> > that such a broad change would be accepted, so I dropped this approach.
> >
> > The second was to add a new flag to enum lru_status, as Yosry Ahmed suggested,
> > to handle cases like zswap where the callback has already decremented the
> > count. However, the incorrect lru->node[nid].nr_items value in zswap is only
> > an accounting issue: I could not find any code that reads this counter for
> > zswap. Changing a generic interface to fix an accounting error with no
> > apparent functional impact did not seem worthwhile.
> >
> > The third approach is the one implemented in this patch. It keeps the changes
> > within zswap and fixes the accounting issue, so I think it is appropriate.
> 
> I honestly think it's a problem with the list_lru API, as Johannes
> said, walkers compose poorly with the API. So I prefer we either take
> Johannes's suggestion or add LRU_DELETED, unless there's strong
> objection to both ideas.
> 
> FWIW, we don't need a minimal fix for backports, I don't think this
> needs to be backported at all. As Kaitao said, I don't think the wrong
> list_lru count is being used anywhere for zswap.

Good point.

Ok I will send a proper patch and we can discuss it from there.

