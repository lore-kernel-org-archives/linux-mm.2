Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FE6C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15266B009B; Tue, 11 Aug 2026 13:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DECF16B009E; Tue, 11 Aug 2026 13:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB626B00A0; Tue, 11 Aug 2026 13:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9965B6B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:18:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2778D160141
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:18:08 +0000 (UTC)
X-FDA: 85089646656.20.A65BFB2
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3818540007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:18:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZaYHztXl;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786468686;
	b=kpaGb+1MnfE+i3QPEQPoW5Heg+aLL2mnt7LqSH809UEvYDcP5sy9rtKd8qYFGE9cGV6hFD
	N6cUUByfZsbeE+beBGgCLad9Xr7Zp7UkRiuAyfSxRBzBl5TrMSmjPjD5VGdBf2LibI/cTI
	RexIRDDdxOKgEngytRLiGh7YZTMvRLo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZaYHztXl;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786468686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1lMjqfyM2pcqzkOWtKU+Em6fjGGxptW037mrJGCaz8=;
	b=lJRJ+8dTquZ2TOBjGJITDT8BEQjOXDyAztMUNy9/3TbMNXLXNVJ1uO+LzkvNndxBG8PLJX
	lqok3fgwUbR9N/+RN24Dx3V7Jy80mvFVyCDgqL7J/JHiAAaJdlbWes1qcq0mdZFPCmLZky
	vYIk+jj1WSQKUzRYdZyAqnwKAQsqQcA=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so232465e9.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:18:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786468685; cv=none;
        d=google.com; s=arc-20260327;
        b=J8DgNTGR5Zf6TkPydEqpZgpnMrNeYyTNO/N1h4dc+sxA2/XW3eUelCBPIzs8MGLjWK
         etnwLrYPCRS0cpaqBYZLRFPdpN8eC9oygSLTaYMo4YxMhlYnS9Tt8r9Zts9HH025fLAv
         +WWdvliWXIuQRFSNob/hbUROLvgTmUQE0mKUwzxXze49fwW69K1iZv9XSC4W9BLjxtdA
         fu26gTuL+W8dhVJ4cFJH1gA+AzATvHe78XN6IymzPGBj20J72UNXm18NjUwkf+eFnwQO
         CjXcyXjUIwb7qEE3R/Pnd5D5iEgcORkA9AEOyIgBs/wnK8W22epiVlZ/M0OHZpny3D90
         k5yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g1lMjqfyM2pcqzkOWtKU+Em6fjGGxptW037mrJGCaz8=;
        fh=kUOpBfKuAs0AEU6/8pzIw0SrdoT854B3NoP0fcFcfLI=;
        b=K7LDfYnBmXkROQlJKJaJHXEOXD/7sluqsYXO8NgPyRct96Ma/PahFdwtBpIBx/nhQl
         /+lc0PWIEM+0ye0F6019imbsX7zOCM5MK0VvzUs5QO/h9DyTnlVZP0ZfOItZ71fo/sUu
         iD55g6aCsEjFOpzMtffBLKHOzEkW3aI3DG0TNHaOINjuZ/iuFG4t/tT/u8h/PomD/F9s
         g3Nud90ZMA5WiX9/BasXXl5HEOs5DNuD6izTUzGV8Eg/BAtN9iaxf63Z5/MmMDCybk/K
         iPjGrHY7C2QNLRmoX5H5FRCKzuxBrw9zbHUiZ+h2bQG5T2aye3xH7a6/7gyJ85A1QIzt
         ANCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786468685; x=1787073485; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g1lMjqfyM2pcqzkOWtKU+Em6fjGGxptW037mrJGCaz8=;
        b=ZaYHztXlpHujsK32vdFl+HYCXNB2RThcVTCOOfGZEG2VhgqHlELFKnwHZ8apoduJoM
         8V+9HvQjQFfFsSB/lw74HcLBMsugTZNOkJwi+TumAHODBIZPE5DOBH8kV61SwXri4v/9
         6eEYQaPopgNJTaID8LhMxw0znkLUAysRAcjpG+Of6FXbH8M2geemCKYhBFZpXuW8cwbZ
         CHGwXrCF+HPBFCuPvf4+wYt3/M1iGbXhskMIEzNMFuS4KKFoiswxyKqbGOWNhGXBx/wp
         pOA36Zv6/RuNtkRpol5zcCkTCJNOjc+1nlFaxbiRnmG+uWxX1uXVf1wnB7VuViBnpDeT
         a0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786468685; x=1787073485;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g1lMjqfyM2pcqzkOWtKU+Em6fjGGxptW037mrJGCaz8=;
        b=GCtbLatS/WXHZ6rIOlxitRwPySH95jIVMe5NWxlqSEPYS9JBr66obd/Cc2xeRA1Qt4
         9rYgRUYbX4h12S97ZfWF4MqvWBu7fShbO24C3TMsAbqT6joRkwnvAm0v/hxVLk/PDOoz
         FpEF/dvdaw3CTO5WyEpT1N3qHy1j/7BaVDYy5lroiPCjLoMy5AynG20/XgNhXsGfapbN
         g1Rt9tHEHaCGURtqhE9DYcNO43sYgHo/k2K1nShPIUeN+m+5cW1UctLs7RpVL+GU3rtf
         Cwwof4mWo5RmQoIp6zo16c61FcwAnjJjcLbjwAhDFkj4BZxp0rWiM6T2Kv5avYWrKYw8
         sVkQ==
X-Forwarded-Encrypted: i=1; AHgh+RohedZMkn7Tvg5h97HlghV0Vc868lU+paI2B+3H/PQagGfijikUa7Ubn2HNH2WOQWi82WhbOdW2Gw==@kvack.org
X-Gm-Message-State: AOJu0YwR4ZONrCPDRGsfzP/Vsj3R5Xl5/u1A4geQ+By3DgIVeqZkBFr+
	pZGsvzB8nnQQzjgRFNpCkCWVos5+u/jX1aVeLIO00BqhmDiJGSTNT2JB/lynRp9PxDr0Ivbp9Wr
	Dz2GwX2OC6lDlsd0pjvfp0FO2JaXmEF8=
X-Gm-Gg: AR+sD13xwsR4SJh3BbGunStXAyIwoKqBHGeKK7PrATPCjOQ68gOOcWxu7S9hERAMZp6
	gl7Cjf9MyL46XE4AZvDJsK9DKgOo+2wp5qp3Z+MOCO7Vt8tALTwBvA0MvMg2uMDGsxkOSo4gAla
	OlvSsDzt1wJbR196Rz7bP47tH4ur7eq6W8JY5jsyj2H2Y3T5aJVHC0QMSKYeHKW3OYRZmPO/W+s
	7vetc15Pms8YMKaK2ca0+i6qSEHka+/8sj6bKyCOPAqASxuUlPg9t52HLDTu/NWh77uAGdsSznh
	RZn3Xx5UuLfMYFQFHnw/4qo0ZKvysW3S7/uyMDMa8ByAznAaFBF1jUziCd08Dsk/A5tobmyVJpO
	A
X-Received: by 2002:a05:600c:4593:b0:495:5858:8101 with SMTP id
 5b1f17b1804b1-4997846ac04mr68274895e9.15.1786468684401; Tue, 11 Aug 2026
 10:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <20260806184254.3790858-11-nphamcs@gmail.com>
 <20260806191958.44F881F000E9@smtp.kernel.org>
In-Reply-To: <20260806191958.44F881F000E9@smtp.kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 11 Aug 2026 10:17:51 -0700
X-Gm-Features: AUfX_myfSmM-We7RZK14vgJtCA25PP9imNWJ2f-4bhH6ulFBjzqzSD-QM8ww2hc
Message-ID: <CAKEwX=NB9LiX6t=MrkB7TgB31XK3FpLxFEb2_mSsY2mD-+NpFA@mail.gmail.com>
Subject: Re: [PATCH v3 10/11] mm, swap: defer memcg_table allocation for
 physical swap clusters
To: sashiko-reviews@lists.linux.dev
Cc: mkoutny@suse.com, hannes@cmpxchg.org, tj@kernel.org, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Meta kernel team <kernel-team@meta.com>, Nhat Pham <nphamcs@gmail.com>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3818540007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dhtoiza3j63r4uqoyekajngqoj9a718n
X-HE-Tag: 1786468686-965917
X-HE-Meta: U2FsdGVkX1/fUTaS/LIa79i8LxKh34W5XU9tnmCrx5Rs4y6d7q8hTspvrJlmXWDqWs7aBa9FVWvAW4pprX2P5/P/qkEY35Sx1rRKpk27XuzKbkLGhrf7Kd/sDndC1hq0Hv9xoBwwB08MH57DNaIPvDq/lvjwUZeuLdmFVmTfY1srkQ2Ldh1UuKbutuGei50Z98r9WthzHPxmjzGOA/DrBm5MVUfEUmwiOzEcHFIrVTOL1boiGYPWc5yaWrDHr+1EPhlCa/YMv2WELUI/1WDxFBGoAQKKf+NdBVgpDxMarg+z0hc3hpG9On8uvtaHbFzsntoWgW9vwpfjmyTNvXGr0wX/2UcosJT5OjlLQUiZ15pimcz6tm/P38Qq6BkzzvqsZubrtP15xJ3tnGmx5wrdyBt87E47dqDkorTf+SgJ2OqWkv0G5HKgy8Q+YLPah1PF3ckSJLfzDYD0sxrcAYenPXfpEBXMzqHW/eRurgsywt5gfEc19iU79BZRcXcY2CgwZQoFrmiFU9C3RdUzNesM1RXEEPoMjhbyc9BJA8nQQxpsk5Fs/QYBCh0EH0wzZLi/WZGsKCsPR8Opc+sovPEnPfNih7U77zvEdZoWAdwOhi6e+JrfMiVmdgIczi4y54UCsaghryxae5WNGSP3ruo9i2q1nEKnWl5hmoQgCiWM2eFGPgaSRjdSD6wFNU9L4UryoYntFG0RC9bJwBPljO49gCamOba/omcLUaZbuWd9jn0ykT5b8dQiVjwplRMOx2nfUyMV/PNY3iddu2nvUrQP1jxOpszdpq2Z8RrMJGedB5dbgWev7vDWckAKooCrSLYKD8ZkKyVrh0QQN3oC7bPfYXsSWkcDrBb/sTn57bbqDEbDZ/nkeMPE89LHt07xsX/mPAK1VcsvcqBHho13rQT+hjbEldnWICD+XNGTYVLXg4Be/GCB9AyDIg4Mk0GUBoOvKvvYryOoOwkwcgdDT19
 Gdbf2vKk
 fxpjGhFZmJoOK0tggzaddzLT86mhW9/3dQRA9ASzv4+wO2u8Wd57UTSZBlH4WX1wFXbsm5tuIu8rbyWsW0E6bRsrYjswjuKhLo3Qw1p+tg/BVVy6h7699CZT3NgWFjuTNA+u3INQ+nmpL2EQFBOj9Vaq95eBsLAGn2mwBd4OUBFtPG/Ax9QjTaXzQ/IQqFWwcBW/FB7GSHbLejyAHoPXtetdCtG+YcPrVNm9LJ9K94waDPEZ5cK01rY2non0NkBz2DVCSLfEUwZlpBfYDyU6judWJD8DPzZLQrMXGye6XH1kVjsC31s+h90VyaiXA69wkNo++lLjn+0/GYsCpT7aOiKBtjJbrSMgQt4Zwa4vyyrvucThlakbDHxLu0w8M2xHtmTKEIH19zZPytTuVWiEnSMz97YRxez+RdniMedobq/fhKbtoieq/FVRn4Yim1bt7XrmnnTFgoz+MH8dPpNKLiZp2vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 12:19=E2=80=AFPM <sashiko-bot@kernel.org> wrote:

Hmm seems like this is not sent to the list. I'll just cc the response
to my original sent list...

>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Critical] Deferring `memcg_table` allocation to `alloc_swap_scan_clust=
er` under `local_lock` using `GFP_ATOMIC` causes an infinite loop under mem=
ory pressure and violates allocation constraints.
> --
>
> > +#ifdef CONFIG_MEMCG
> > +             /*
> > +              * Lazy-allocate memcg_table on the first direct-use slot=
 of a
> > +              * physical cluster.
> > +              */
> > +             if (IS_ENABLED(CONFIG_VSWAP) && folio &&
> > +                 !folio_test_swapcache(folio) && !mem_cgroup_disabled(=
) &&
> > +                 !ci->memcg_table) {
> > +                     ci->memcg_table =3D kzalloc_obj(*ci->memcg_table,
> > +                                                   GFP_ATOMIC | __GFP_=
NOWARN);
> > +                     if (!ci->memcg_table)
> > +                             goto out;
> > +             }
> > +#endif
>
> [Severity: Critical]
> Does this error path create an infinite loop under memory pressure?
>
> If the GFP_ATOMIC allocation fails, we jump to the out label, which calls
> relocate_cluster() and puts the unmodified cluster back on the list,
> returning 0.
>
> When called via this path:
>
> cluster_alloc_swap_entry()
>   alloc_swap_scan_list(..., scan_all =3D true)
>     do {
>         ci =3D isolate_lock_cluster(si, list);
>         found =3D alloc_swap_scan_cluster(si, ci, ...);
>         if (found)
>             break;
>     } while (scan_all);
>
> Won't alloc_swap_scan_list() continuously dequeue the exact same cluster
> and fail the allocation indefinitely, since the cluster is never consumed
> or discarded?

Oh nice catch! It's a a bit of a rare construction. You need:

1. Vswap enabled.

2. The physical swap clusters start out backing vswap entries.

3. Then we use these same cluster to directly map to PTEs, bypassing
vswap. This usually means vswap allocation fails (rare), or is disabled
during runtime (rare).

4. The deferred memcg_table (1KB per cluster IIRC) allocation must fail.

Technically possible, but does not seem very likely, so I'll just do
the minimum to not infinite-loop here: i.e if memcg_table allocation
fails, just propagate that information up the call stack and
short-circuit the list scan.

We can add complexity (dropping the lock and retry allocation)
if the rate of allocation failure is high enough in this case (which I
doubt).

>
> Additionally, alloc_swap_scan_cluster() runs with preemption disabled und=
er
> a local_lock. Does using GFP_ATOMIC here risk lock recursion? GFP_ATOMIC
> includes __GFP_KSWAPD_RECLAIM, which wakes kswapd and can take scheduler
> locks while preemption is disabled.

I don't think this is correct.

