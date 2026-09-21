Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F34C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97706B00C1; Mon, 21 Sep 2026 15:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E480C6B00C3; Mon, 21 Sep 2026 15:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0FCC6B00C7; Mon, 21 Sep 2026 15:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0D816B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:00:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B33380279
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:00:26 +0000 (UTC)
X-FDA: 85238685252.10.9A7EF19
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3B27540012
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:00:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZYcVUG61;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790017224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeFO3AREa1i0Oy9rChHlku4bTopkweu2G7chupZtHVk=;
	b=a5s80jRfYchuA2YEVYDaMl+6E8CkxdAakjMbK27F/zkyI/1S9twXx/au+IJi6oi5gbmnXW
	5UxCYaRlKY2duEluoJFq/c9FpOg7Hlvqn+aSGjrlBb8bXvQ5FVBZ8du4KLnBbdaf+uQuh2
	5JdDANA0im7UHNNbErPfVQ8xkh/dgaQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790017224;
	b=wO46OUqpTCxjLbiWu6HzlSdSBzjxT7LXhtNl44BBQyO6tCZk3oK1A+tbtm3XBrIadiy6H2
	N0g4BG7uPEJ2xvQ5CLZGXKECH6AaegBmMat+ALo498SH3GyCWidVhebE+07SrJaELxoT86
	F1Lw+oQ/FVS8UgEMgSvwnFSIs8qzAhk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZYcVUG61;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1ca5b0d6so24993225e9.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:00:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790017223; cv=none;
        d=google.com; s=arc-20260327;
        b=Ct0Bin1Z53TuQoFsb6pJgArtSgn0Svu2oCkKwCHCmzLkC4weSq3DtT1flyQZKvCQD8
         9wtK9w8SbRHvgonuPoatqdXExNsoIPXfz1mSqDyZqXzV+OP6McVfsmdtPhX2zV8W3kFY
         OLQvxwgf/ZEU0ik2VhlpiNNps+I8OxyrPGQ4L0fCjCLqSTCyx4qJMEs2EAd32YMKvAs1
         4+rnLx8mx6PjSVQVQQkRbG7zqMNG2dl1DdwfnrF2oQRpyZhdCbTO2URm+bQpkLFB1dwr
         WWTsSZgGO3DBJD2Eo0okiwtC65arhlrPETsBhr30ihKA/rQ+/CokdTP+LuNb/MXpVPEk
         DhRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FeFO3AREa1i0Oy9rChHlku4bTopkweu2G7chupZtHVk=;
        fh=Kn+ImVdELdML71DJsQLMl7+e8LM6vcgt+Clse9OKD+c=;
        b=H5unUeg1R152sgB3YD8c7irgKzOOwjaOjr9VfRmjx8ngqJ5HC9ObwHT1UEqut/EoqN
         Q5n7NCAyfwPSuEqAN96zAZ9yYZZRvPHEPrkAiLqpV9s2cKVBb4CQ7IK1qOONG0Mh+qAv
         Yj4bK935sfYHf91dFkiD+smX+S7+LHOL9rltfmwmZf8W8IwsRo6acOuePgTEaGJbdvvE
         +hmkshCZ7YPP2DJd5AutFSXycvDQLVWWLyxq9+7aOnP7rGzmKkjQq0cjk82Bynuiws8V
         8DB1nw3Hzn/Zd+bYFjNLq6CTrNp/Tcw8KT0ApECjyX7F4L1VafrRM2hSdTCwe2/HlOpD
         2cMA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790017223; x=1790622023; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FeFO3AREa1i0Oy9rChHlku4bTopkweu2G7chupZtHVk=;
        b=ZYcVUG617mRzUI986XICdUOBhef1MgEgsxSNd8rqRhz3tmTHBxp+E2BzdGZ/hazIeL
         3+anjzJCu+UtZ137JjdGFU8fzxey3RV2rAlLptioVrZm0md9nBKGlozXkoQ4iyQq0mMK
         y3kVISzfe5D9zF4q2An7TDJQMJL9EsCUyBVRpo/NjmD4NafmC1YvJGMyZPT0p6lMe0HU
         0KapxbamWJhN8pS+12ycPdrqjaOIl37wm5ydfk2B/Sb0tF0Hh84v/IWn9NQSceJcg/uy
         TguFR3mQ1jByS+P4Q+MC0XlxG737ZoOWs3hSs/Ck85o1vvHfJ3J7ZAsc/iFs1S6chMoi
         zGQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790017223; x=1790622023;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FeFO3AREa1i0Oy9rChHlku4bTopkweu2G7chupZtHVk=;
        b=rfcYXyhJUMJXARNuaGZ5cJ0/s0IE4J5v1sTI5hBjxhbhO0cW0pRExcUU7RgvtdiuTu
         favh8tQEwBicOir2PmnMZjmeXKrxv/Spk9E2EWza5xwZHvUdmBTEg4ZdJrsh1mnlgTHq
         IwoiOL1vb/OmDtiVy5cMZl2HqKq5mR41sOss2/tqwOHAx+WgG6aFcrt5iuZRc3S536Jf
         an4tnSda8U9tVoyze8lWVWr8hudXalYWsczAwuC+6iqdd6KuKX6zK6EymxnWLU/bHxZJ
         n451h/cK5n1fCyzIO6i+18nhSa8er9fQpALe9PfQhWkquDbatVD4snAtDoBfxyiaOwim
         5YSg==
X-Forwarded-Encrypted: i=1; AKwUvByKVGgbhyRHbr6E65O7rAj7E4CtEAU3ZMKpkrTZxSuhiygvxkNo6U4aV7mMmp+R/oHzoB0QEWcC+Q==@kvack.org
X-Gm-Message-State: AFuF++mhZO+i8En06O/XfokjnLe24xP9kDqyEp+HeVwy8OlbY/KRuKU7
	ZejO40VlVkZ0ShKCt7O5t76ibMDzuQTtqeWbGEMF3k/5XO2gXlOdJ7oDsqqoFtptC/s/evD3Dlq
	GvGT+01ModtoW37TF3dj1zTNJBSiM0kM=
X-Gm-Gg: AYBFou1uL9NQUObgX3hARVi79+pL9yXtXzU0YAUt3c7sh/keddS1Y05Wpefp/gF2os6
	dYd0KYU1quAe4YtQ3byg1eSYYzLkkFE0/BBWG+sKLigOTNWwpM9o9J52KlF4fUEh/xQXSKwXE1B
	MmK7NyMLrfSY4xVrM0pIY9CX7bN5B/2fdKsvSVztymus7GcLgLpq6BuBeAlaKUQMegQUmrCdbif
	sPOYk19hymF9F6hpWMAx/P9O2Umn8cCUhOp5J/nQwX9GP0kfNs+JuRLh8Z5ccDLVkwcAx7+Zyhl
	qi0EPkWHWSdnGSGLSo94ulczyLnU1a/87prZV2JylrsXOtfNnhGCdiko41PVlphBUlw2RpOPIxU
	yTKjwjVPgqsE=
X-Received: by 2002:a05:600c:c8a:b0:49d:433:c3b6 with SMTP id
 5b1f17b1804b1-49fc5743da1mr174500025e9.27.1790017222438; Mon, 21 Sep 2026
 12:00:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <6ab13438.71f81b7d.15fa6d.002c.GAE@google.com>
In-Reply-To: <6ab13438.71f81b7d.15fa6d.002c.GAE@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 21 Sep 2026 12:00:08 -0700
X-Gm-Features: AcwNN1VSiww_CbRe6xoCT3Rgd63gTKNcURFr8FJ8W6bVgDoo9VnivNDHr1UO828
Message-ID: <CAKEwX=NczHcGVrGsArjV34Viv95kKbV3jo+c57BdG9pHc087GQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
To: syzbot ci <syzbot+cid08c37b8dadb4c43@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	gourry@gourry.net, hannes@cmpxchg.org, haowenchao22@gmail.com, 
	hughd@google.com, kasong@tencent.com, kernel-team@meta.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	skhan@linuxfoundation.org, surenb@google.com, tj@kernel.org, 
	vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d8g3qdc67scrnf76jbjswthfyh6rqa5m
X-Rspamd-Queue-Id: 3B27540012
X-HE-Tag: 1790017224-647060
X-HE-Meta: U2FsdGVkX18zq0B87i4x46KRL/iZCoA8chBr6Aj/QX0+Qk5V/U+pKxO/JQ9YCxzYftCblcrlXxOkHGPHt5fSFJRkD/2MZ68F0HtWcW8MudMSGQQsqDxY2MVA/UPStbuqLL01e45j992TVwsAVRjeYW550U9PgiNWcH72JH3BGR1JICbjGMir6ZLtrh8Ewys/lil1vI4CVy5XXCWPwCdTU9Nxb163LPNFxVgnHYWgvawil+k6wsK6vAxCFx1CRD8Al+M7U3wntxABCUpWJ8/FmbPdRuGLlYJU1Y9nlzF5U8QwBQI9AaFNujtFctXBK+EA9jWxoeU/S5hZC4WOpfxUK7BeXpDrYmwMn+ZmEtCvc2oz+uPRPa+WtZq9yRJmDV04QXrWzOozkkAmv1fk+nk3yAl21OCGqO6cYONrWBTAf78n+anlRxZnMesbjGw2DsYTRRYl+mDHbIl2tPu1AbDsuOYiVYTbwjaK5cGthbqUjA+mrRivT1dka25AFQscW/xqk1VhuqjegrB3HKLAEKwMMOVwDSSEh3TqHfS7lWe//uYS/84EpyvHctffMYZ2yErRg0Do5TM+eqrZj4NEUwU1gwJTkbumDB5jusP+axVTD+XEht878Se2QJR8qHrWshd+X2DZTEnlpWjTwo/BdxyPJTaRW/WGq0uOm77lNHQMKvSaF5yk1wbdDUoCK4ypZP0HMt88EhjE3HCO0Of7kBkSOQk6oFihhZ/GPnFCKMylzbDse+z4MThLOMkhCwHcSLno3UAIdzOT/UmpUNg6n92IJmWEpxvQ4kaN67LOKyn65hNP83DAyKHETi2OEhqpQl+B3gWMf3GaO/zbRtxGo6Ml94yno57KHF02vex22bsV/jjYjf3Id5F5JZQShgc8RLhbDm4mSuWQtIsvI3HAf0lu9TSvz2B2P2E5zleZW1TE2BF5JmNhesbbIWLm8SXgpcq06MPpGNvMOdesOwJmIbt
 M8ABQEFD
 KOetwadJoBZghYrR32TqfIeb0or5W0tIN+C+MFSo4y3dgN/ne2W9dME6qjePpRomlF51YE7/1QfFGNI1x0FrHMFb9577dkn/tfchm++4j4ab8zWz86Nttk+2s//CpegrLlLfzDnMaYa//OarUw3X9ZQxIzDfgdBQ4kfbh+OyBPzNwzZqpeJaKBZt+2tXYJhWmpAoTPJFQ71dDysFFHji9sX42pZjcgp/NikbqueSEJaJRvEoiLZTPowhDEZ7lcPkeAy91RnfRZ5AZbfEAXmDYaCAbJDJMnVB8SFPA79OVAxRkkBuy4cbZ9ThpQ1imTQZZdLX+ZjOyI7H1GxJ8Qll0Au2Br0iKITpPHPt9Db/P/kmvKRKO91M+hEemy/95Gu8JYJeN6ud360Tmzl9qvcz0sB0CZexwp2mhK5S8WXtXTnbIZyegMapF7PfeNUCNN1WvedyvIP62gN6/73M9LGEnAA13CGFkmR0FiCtZLryqo8xKouiodkl8utJ94BK3cKWChHX90oJwU2XHsmIQ9d39cIur4ZwDiRooBXjH0uq3zsxQv0KJVoPC3Voz6dhdL/Njf18EErh8Co8gtQY9zBp3mSkLQXxwsNiGzHsBVWSHmXAVw7gYQWAHccXzl8MwOiDoD8/52iKKAn9cnhWW+N5zaYPahw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 6:42=E2=80=AFAM syzbot ci
<syzbot+cid08c37b8dadb4c43@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] Virtual Swap Space (Swap Table Edition)
> https://lore.kernel.org/all/20260918180241.3424851-1-nphamcs@gmail.com
> * [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
> * [PATCH v5 02/11] mm, swap: support zswap and zero-filled swap pages as =
vswap backends
> * [PATCH v5 03/11] mm, swap: prepare the swap IO path for vswap
> * [PATCH v5 04/11] mm, swap: support physical swap as a vswap backend
> * [PATCH v5 05/11] mm, swap: enable THP swapin for vswap entries
> * [PATCH v5 06/11] mm, swap: write back vswap zswap entries to physical s=
wap
> * [PATCH v5 07/11] mm, swap: reclaim physical slots backing cache-only vs=
wap entries
> * [PATCH v5 08/11] mm, swap: only charge physical swap entries
> * [PATCH v5 09/11] mm, swap: add debugfs counters for vswap
> * [PATCH v5 10/11] mm, swap: defer memcg_table allocation for physical sw=
ap clusters
> * [RFC PATCH v5 11/11] mm, swap: back vswap clusters with a VM_SPARSE arr=
ay
>
> and found the following issue:
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> Full report is available here:
> https://ci.syzbot.org/series/713f2473-328a-4c16-8bce-63005d15a338
>
> ***
>
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

Ah I think the bug is in the RFC patch (the one that does the
conversion). I was too overzealous in deleting checks :)

The skeleton (cluster struct) itself is no longer freed (I just put it
back on the free list). But I do free the vtable when there is no slot
used in that cluster. It's one invariant replaced with another -
"cluster freeable, but if cluster exists then vtable exists" becomes
"cluster is never freed but the vtable inside it might be freed", so I
should change the check rather than just deleting the check.

Should be easily fixable.

