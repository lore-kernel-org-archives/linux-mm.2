Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB06CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 03:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CB38E003F; Sun, 16 Nov 2025 22:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0141B8E0002; Sun, 16 Nov 2025 22:21:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6CE78E003F; Sun, 16 Nov 2025 22:21:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D2C2E8E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:21:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FF90C0B57
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:21:55 +0000 (UTC)
X-FDA: 84118649790.17.21834CA
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1115C000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:21:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m+W9okYz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763349713; a=rsa-sha256;
	cv=none;
	b=Pp97Xagy/exL8aj466tsKVwomg7Lt3XlLSLAX+tUvZS/k5YCAC98EUhdz+dsWhoxIAznuE
	TqQOAaJV9xKqMWk3mWtnwrOqX9kr9hAywgKTeRaXfBTYqocRaXSmFVISoAFjloGwDaO4pZ
	RRWGSDt1yWXILyl13UTCm+H3BQV4PFs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m+W9okYz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763349713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW2D1UP7+c5RpKONb8rHIAp0ydhdfvE1YMByTnQbk+U=;
	b=09Ax9JFiuH176TKscXQ5VHldqns6vo9HxCW7zYXrabCDDPWl7CCRrVdIqxvC4iU3F1Y80g
	EiV4PrgtRaL+LOPCK9vl8KXrWdfJz9OMLu7OXJZgBc5MrGmNDt4IqUlf9Byrha2Bec8oQv
	hs25VbrluTAku4FQe1bY1ZyjmqmJtA0=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso5918156a12.1
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 19:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763349712; x=1763954512; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tW2D1UP7+c5RpKONb8rHIAp0ydhdfvE1YMByTnQbk+U=;
        b=m+W9okYzVx0PxvhTBYxR1XPzUAwBym33D3zGeHR0fEx85nejzw733kGcn1Fwhz8DlK
         a9D8OBao4PIIgMM4Rj+1xPvvYad7xc0VYi6ZjTjoyYEkK7uPwK+Wp8+aYQwrGscis/9S
         SbDWKTije2+1xt84k2xJbPcBceW7vFL6X715P4dUi5oZSIme/MmOdMPEseSEa9QXr3uH
         ONBBHhTxvau/Yr1mFDs85JV5YWR+P/4dvXeyZm0EEZMpurQ+lLAN0QV/VRAYA25RK+6S
         69iyr5gV9+Kr5IP/mV9i7wlctLAuztdgOP3JntGXvrwj+WJN/Ows8g8wFsLc9k5BI6sp
         DDzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763349712; x=1763954512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tW2D1UP7+c5RpKONb8rHIAp0ydhdfvE1YMByTnQbk+U=;
        b=YsQrpyAxxPs+HCxfEgRFmJJ1R2M5N3OEFp+HLlabD2n7/g+JQH68bmxvCEFcQNQkqP
         BKbEyw3acR/982qEWFCFUjoTh8fPRMLrWQxW567jnBUTBlpR3z/clFnJ/ztOEhzbkTt4
         hgnLq/Qh/Et99IXy9PLuhrO/zf37zkG59wjLmNisRJQk4l3JW+Ab/cQW1+uCWd5Ke1pL
         rv5DZzgtDWBNAfB8Voiy2dY13w5oLcw0BTMGTe1ELyW2r1nnHNf/G2MUnxYeoS+piCxE
         l/aLSkS7mKAO/fajBNAzc5dUCnwgB0oKTIt5zWkTH/1ZmJ4YXKQ1M8tbzhS6VS74Tpna
         IkOg==
X-Gm-Message-State: AOJu0YxNVj270i3vEzlOgTFckaFarYnlJeNCIKgkZkFjX3jdSNCtBjrM
	YtrPSgHvxqATV28+ObHdLTQQsWPWplIStKCEiZBZm+m9eQ5hEky18FwvdgzMGswMx/D74bR6dQn
	fkpfI9rvmuzoTViJAuQyLQ4nKKyu+LtY+1bgH7GE=
X-Gm-Gg: ASbGnctSuAV/g1ykjwCSLWleQHk9utXV7SsOgO6xGHA4xmBEYfr+yFKZzW6rOO1I6Wy
	VXkc14tDeIK/05xedDdlSuAXwr4C+xMFz4GOvd9wt9WixvIgh29wOMPdnYi4E6RM/os/+1AIZQ6
	EjBVx5cMFM3KS5w15/IXAzFtxCr9TELOsnYPmoPD2r4dUmNma9RrwdLlnOgG1UeOmLti8Wk/4y6
	eT+NKPEHmm8PtaUvy82n33q/XI/aR4L246pClGeZ2XKrHYUpymJ5VKw+1oeTdufGaDJgbc7yiPU
	Jandl2yMn702b3Hi4o/ExYTylMJTIbs=
X-Google-Smtp-Source: AGHT+IFcLnz7VyYvz1onP4vl4tmQetqNnD2LyWw+HxwJ3tPPh39rxVV5mNCkqAxtdmtsdktRYHWW2nKIQKVGaNktCsE=
X-Received: by 2002:a05:6402:2813:b0:640:9eb3:3686 with SMTP id
 4fb4d7f45d1cf-64350e8e398mr10145480a12.19.1763349711541; Sun, 16 Nov 2025
 19:21:51 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 11:21:15 +0800
X-Gm-Features: AWmQ_bk4H82lU56bITxxjVzaEgFhx4wVx8EnJhimMrnzH6ZncHDY_1jUvuToKhs
Message-ID: <CAMgjq7BNxt7FSkN4CmFz_USr-a36RARFDzuPLOJMjhqOriFQiA@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm, swap: swap table phase II: unify swapin use
 swap cache and cleanup flags
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1115C000B
X-Stat-Signature: rcch7umgzuh51ik37sy5mpndyq1t1yj1
X-HE-Tag: 1763349713-157144
X-HE-Meta: U2FsdGVkX19oEGtwONQkrNMHrANzFaTrAkyDLgFBPuyIjnDM4HvtyuCV46lfLHegtPEyyDCyvQYQx4KD58ust7iCyNM9BPntUGF5F0R6/9Dys6xw3mbsKm26cgb8MWkIrsOyFbJ2e4D3LBowA7aWZLAlW67eoeSw8BeWxsvek3EusQNubZBzaAANcspZKBGTQFuLwVlWqQPc9aVyufMfcfdWtdgXGhl9w9dUGowzfx2aLFHdgp+2djSJWQtYAbd/OBpGeup6T5a3oQ0H0Atq/NSVzGGed2CYeX7JXWQT7n4nsmhtn8Jwk4H1btqS7FgCK/ARbem1OfINLjHgzV9shdny6yzcbNxCtZdbZyufg4/Io9Ess44pHQ0qwnRZpML2zr6zlQrG+wlqQrGUPSPn5dlcyibe51wmF1OdqpYLJcO93rMKjzHv4iqcTWfnNWcL85LByokue2ERbiPj7uz3yEOhWYJLeK6dITbDsUeccT48uUH+e9RukG7NaEtzHuL7JLcftV5exFlwkEOBqJKDrs5buSmIVKXyneA1V/EhmP/goSSX0P6jjUi0jindAt/DkuavRCE3CDWRvTMelqD/al9tMOaE4cDKqz8JSOnCyuTClxxdg49xbRggPI9RagOjQ1jLwLEFNjEVl7yLRLPg/jYRImZaYN17IUxqV/XXA5FQO8mnEUdQZduAspmfvFerug75FHJG8MqpX38HCUgDf/CZiY57/ntRQ9qWV4Wbl3xhBjP+0agGNP+j1gkPw/q6LWX+sICkLHOYYJcCsoyEx2OT8AA1HwkFAdb3Hx2oi5Mz9hRyTB0AqfngCbV+R2uhOOeM9kT9bOe2xHCtqR+Fdx7T4SDrq5QAKLHoFnp5EuIpr07Ecc2h5MI3k4Z0bG1ySYPAoy9wNlq6q+QF1ceG3NUnnkqS+1C1+IdqyauS1U1D5W8Pc6OdyxOIS/zao9yUkEJVa0kIGsEtYrXnBsi
 W+URuZh0
 f2jO5Gfc+kIj/lanDqiE82/WJ46B2jq0/voe1uINaP5vv1du3tPSKXi+rHETJHGEk+/BdMQV95CARRB0PtZ8JbbX/c+yMSh6ykGCBZENLylhAKFQaTvdEjg2es7qZnQx2cLMN5Tk9wyvsaPRRwEzJPWs8+ZgS2m8j5rGO8WivFtCj837xqEN82L3RV1LhYac8v9uyY/NlgBWFimCVcFBRD1RD4RBE8B0bonklqJjPJLmxOwt//bL2ILfews8pXUHZIg9MePx6BXxMowLo7I7ix4d9PFTyB81hL3svxgbDTnRHt+isipkrn3p8AvCOvCR+zyM1z+5+tGF3MZ1PwkOkMAoeFmIdl0wuAidoYJ/tJkVvYaF+mMXEnh7rnFRm8yNui1uo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 2:11=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> This series removes the SWP_SYNCHRONOUS_IO swap cache bypass swapin code =
and
> special swap flag bits including SWAP_HAS_CACHE, along with many historic=
al
> issues. The performance is about ~20% better for some workloads, like
> Redis with persistence. This also cleans up the code to prepare for
> later phases, some patches are from a previously posted series.
>
> Swap cache bypassing and swap synchronization in general had many
> issues. Some are solved as workarounds, and some are still there [1]. To
> resolve them in a clean way, one good solution is to always use swap
> cache as the synchronization layer [2]. So we have to remove the swap
> cache bypass swap-in path first. It wasn't very doable due to
> performance issues, but now combined with the swap table, removing
> the swap cache bypass path will instead improve the performance,
> there is no reason to keep it.
>
> Now we can rework the swap entry and cache synchronization following
> the new design. Swap cache synchronization was heavily relying on
> SWAP_HAS_CACHE, which is the cause of many issues. By dropping the usage
> of special swap map bits and related workarounds, we get a cleaner code
> base and prepare for merging the swap count into the swap table in the
> next step.

A few things I forgot to mention about the following series, in phase
2 we removed the swap cache bypassing, unified the synchronization,
and removed special swap_map bits. Now swap_map is only used for swap
count, so in the next phase swap_map can be merged into the swap
table, which will clean up more things, and reduce memory usage (1
byte per slot).

Removal of swap_cgroup_ctrl is also doable, but need to be done after
we also simplify the allocation of swapin folios: always use the new
swap_cache_alloc_folio helper introduced in this series for folio
allocation so the folio accounting will also be managed by swap layer,
hence merging of the swap_cgroup_ctrl into swap table will be doable
by then.

