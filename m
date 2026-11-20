Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C1F606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zMJ7PbSz
Received: by kanga.kvack.org (Postfix)
	id C443A6B05B3; Fri, 20 Nov 2026 01:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B6C6B05B4; Fri, 20 Nov 2026 01:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30F46B05B5; Fri, 20 Nov 2026 01:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0666B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:49:41 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E996C0D3B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:49:41 +0000 (UTC)
X-FDA: 85454571762.16.A88E4C5
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 12F2320002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:49:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zMJ7PbSz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795157379;
	b=x/bh2QqEJDlKNEk9KGqWAUlinW6LehSsf3XNTr66RuS9YTrTTTJSqaQOmpjA010cQ3YZFh
	R+PszAXscAg8o6KaFofJTgMgLJU3vbU3IgQFEfWkhVbWkIiBgHiKf6AInsCz9PIxzcJsJ1
	XacsPtMrTLs5VIN3ph+Kc3ZkqtD8ZPM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795157379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82jQgJ5EVrQ2a7459gmbGwx0yatt6MbCteDy+T0Kbcc=;
	b=Si4QAROJDVAYTu8jSXzlDeDO/WCjJ/TkuA7X53xUcPGhSskMFhgrCTEXmyyzFlZ6sPF6nv
	akaR8NQYy5hRMj+G33C1xIh27dZTIJblJ9emLw7MVIsUtfJzJ1a5VLE25LzGNB3khwFZFL
	/xN+GxTeDpAvz2kjIlkrZKIldLqJQ/U=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zMJ7PbSz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so4668895e9.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:49:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157378; cv=none;
        d=google.com; s=arc-20260327;
        b=ic4XA9hvtlMtZPpkwQDR8WsQqWIPd1pN/cCbnJmzk/03vJLNQoR3IFuKQ6lbTYKRAX
         LgkVgguPtRGPo93y6/Kh4O1yUdCrjIAqx3ENGXE89v6Mkd4LwTQGAmEHTctzVD3HQ6f3
         3MMROT4CQevaQuYiWWtt5Xp9yhMEmafz+Sdr6shfHP29rJiQXUM6YPmz/Cau9akhoSUX
         VXv/bnudHajnUobJFMDT1aJeJ6X3gRWbPMSUPuq9Bkq0dQCIHGJ4GpZwNBEjgyUCcADr
         LFa2AwDvi4YrjtBqxLj9hGYT8Szwl4ERP4QLKy2scSGxZLVApZDUF5YYwAfJkPLskTYf
         yL7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=82jQgJ5EVrQ2a7459gmbGwx0yatt6MbCteDy+T0Kbcc=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=o2liJexzZwiXhjpy5brmQHU4yxUz6aQfeN4TnBdsJpejLO333PAUlhqffzgYEWvqUQ
         XLTaqL7Wfh6Kt1Vd/yxw99OCN0SD2C1sMm9qH65Ad8Ick9hlkNubLL0ckGSiY1jTAyuT
         XotGP0SeFGu3p7QRbS8r5893szxl5QrSiZpv4E39whMNaixZoeGvJ0b8NZPhYSifLNeX
         41VRpj/vGxh1V45A/zEuPBTTM9+5Fy8Yqr27lCHvo3hVSnvGcyDfthOgIFR0mQvII92k
         WMCPQBbD+ocV/nN7y6K6+XQ0Tq5+N6ehziIlsJoYmqjINRwG209w1C3KUQjkd+p8GSH1
         ldFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157378; x=1795762178; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=82jQgJ5EVrQ2a7459gmbGwx0yatt6MbCteDy+T0Kbcc=;
        b=zMJ7PbSzHBTTLwKWEmGnvW3UTVggDO+qWV3Xnt990tVDybEal8wMyc5dzsZhNcNdLn
         rHbwvHbCyJVrcads7yYwEQlIPZKVJ582x/AeCwfolLGwDW+iHBqJ2JV8pH1sUrNCQc26
         DtVI+bs/0PnDxwufFj08ovAaIT06MCpkfFH+dcIP/VZzwIWczZPub7M5iV47Z4H2Cc1o
         DUdTwQ8a1IYYqqWksgjrhBAWFC+4MlwBCMSMa6W1UZwtMBEJKCg2KmGCmRUHbhvjT4R6
         TVPV9lN2M6SBhJuddTrVcpOatnqNEisfxyfKKd06rDqkKvccHG77IENaPhDu1KyN0Y9i
         qTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157378; x=1795762178;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=82jQgJ5EVrQ2a7459gmbGwx0yatt6MbCteDy+T0Kbcc=;
        b=d8G0aw2xq7nakzWbOtf9p1ROk9VTEDot9PUYWUyMsU5XVC1j/FuXLE0DFInimhaI6z
         6ZS53ofm9fhQhW+mH+MYMnaKaHmIC5duFukIKIYrO862m1bI+EXQ2H5S91svsk7ZPxXP
         yKhzzKbMgq9G6CJHMKHDMM6oFTEVh7FSSuYxC2ZY7uyuVYOxnzR9R1N8SZStgSDhlHI8
         BYJkijca+nBDOkHGofahxzgN1y99+gH3MXxAcEfyShUuumQ5RloYeS9grLvBVwft3URN
         P0ASA6yjrlkxc99HJkqGGOxoKNEjnfksvnntCnrzW8v/3D9PfCiEaTZJ89qTdNu9HxSu
         d5zw==
X-Gm-Message-State: APuU4Z9fw4OeLXONdfpGHVzY/nnaEADn8xiftEmg1iWgqxzqEzep1mtC
	F+Fe1lRqzuZ9ZHPHopPPcd/rfofnB/RXtiuNpv3nLN8KKPAEE/eCtZ+yQFCZ+ymjwv+rB7LPXge
	2UWe81eT5cfv7QdDxeEMW6xsf4uX1P9A=
X-Gm-Gg: AYBFou12rd7WUbqRo+RPvPwohnEZMeDi0a6bNVzHEvVcobMQA6JUBEetl2otkIbWtMJ
	LZlGhDAtmbvpgc/GQ/kNCmC6UGDs4vG3xfSQ1Sm4Rgwwba/rKiVsKUOsSV0bVDKpGiC1L62eE9E
	0LnKfw1lUbjy4Mq+cr5A+X1QlKh1n73c9rT/k8c6G/foWbOGiSUGnWKQoSI5cE27tCj9fsUV7aQ
	yQCI1zsRFI8ouehMmPq6f0khg/n3kgNREi8kufswO96TFZ/zamjQKGMHmbFK9gC2qJ4tE1VsnQg
	7cZFD5d7HKGPhV1PhJTBi8V4vpPztEEuB9L3P02g4PVGwq26no87Lgxr/HlS/QxbEcRjgrqpJVN
	ZRXjZ7Sjl3Z9VxAC9i1bdeObpFprsUozg05LNVkcNOXdn/sxmgAEwjbvAraxmFvR67A==
X-Received: by 2002:a05:600c:37c6:b0:4bb:7033:c938 with SMTP id
 5b1f17b1804b1-4bb888147b7mr42207885e9.14.1795157377099; Thu, 19 Nov 2026
 22:49:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:49:23 +0800
X-Gm-Features: Aa3M54qOc1yY5SxJT7UDbDpxwpV9EzYxtLGhUe-eTcqoOXQmzD9xaaxO1UoM8Dw
Message-ID: <CAN_Opa_4DSrhb=nOKFEP2eV-WVaFpehpS1-o_PTO1cibJ8doUQ@mail.gmail.com>
Subject: Re: [PATCH v5 03/17] mm/mglru: make generation page counters atomic
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12F2320002
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dsnyiwz9gd1biuq744rg1utauro8yo94
X-Rspam-User:
X-HE-Tag: 1795157378-150709
X-HE-Meta: U2FsdGVkX1+MKXZMVs9rP2MW78t2WoGbsY6wUpnNKFaNS57rHX2TKiFgiG5yZsIRG2KmyiA2d/BaHvFaNJwzdJzOOLV4xWRWM8ANb0FOPuaaaBga0pvibWtuaIZDV7Lo2tywQYcS13dKTwCjCoh9Zxh/8LlfkMtBIok/pkdoK0kObL5paBSdhYQ4sCUZogv+73MlaZ1nSF55ddJpOW3nQK+x/DIuCopj45RI4l5ztipBK3A7N7fW5k6Tdh8TMSTYW1aWQ7nTnZEeGPJRtIR+Nf8oWul/R2JIeuFk4l7dQ2xIx/bJKCbr9VzrCnSSY0uKtMCxVFqF5DdfkeBT6wHB/qUOvYR/alkw+S7KDpL0gb4om6NEgdcwVIt7EEpnQZpbhDraqcxEDBsSjSzF/WEM0kad6tLdH2/LSYztLa+oKAlsSWVDysiaVIN/LTtrHa5/gWmPfrOcSN8J2xG4b9/7/1Hh1RRFRqiyUst9iw4vIMLcJ0FPu9N8UACKbjrOF9nCX0WJzbCcKJyfEGUowrYhgt1aS7XzAp3jRUafox1Afx4PQO2uVH8f61dH0T0TIWCCINhzc6y2pcIqJMGjb1hg663I7OeviGRr8Ebjt1OT/K7ou0E1DO7oCjYXmtqIS4Vs+syjDfkFVTeIlmK/vz7L6WyxXHH4i8dMSRYzw+ktqBLpPHDY+WJvE3upyHE69sUABWBrJ6BwOUbqsEyGWvIEblr2GFyEIxIy072+QuyuDnW4fdRP8yATIGDvcMxg5By3gl2GAgRa/fmoL8bUB/0kup4wDxn+8krITB1pb482MMuJsO7UbdJq0KSVv6QxjTZvurYoAfLvOMwxDtPmSzjFBzmlAyyyfL/0y5dTsBfLV8CHCJcASbOaJueYdjCXjvesdjsZrv80ENkyiiwp3V+5VG853/4o130TmZiPN1Dl/skQvQV76VztRzPiih3F5cFqq1aHHHCBA1WMR91fiwH
 e4/JoUYu
 QAQeWygTpYBzGmLHgxY0AZSsyr8CD0Ne/DjgFC8pdFBbLFTyT0QZP7J5Hx51E/WLjEoCDbe4XsttzDep2Rv3Ruu/TUUiQ5U8mP7m9Qa7p97WDsMjBSGx0uacAV/AsZgo+UGVr8xiKUGTUYJpxLPyTeOez81vX7i7sLIiTEYzcqOZukW7AB05R5u5+HK3Fz3fY2mcuPyBZRkPG9LZ87TIdK+ZaO/zwCyk/44DtK6olobh8F5TamQrH9R2zeoSCgie/f1TI2DglBpe8tc25rTUamWcbH2ulblhuJsOUli8oBaexPhmvxsBkqnjPx7gMbtPsDnXQyBBeS924+4CFSGefOIDwpYXh18BsKsKkD+cSwjfi+UD+AlcALVZPTVcS02Jv0KiVdOBX5LxSvN6Z5RMZ3LyItPvJOxfTY3Q08ub+LBSYiaLcJMinXgxKLaGh0AcnKPMIqXRR4vZ/YUpUmQlBc2xsBxaOWL0/3hrk1gm3sMW+uSRthJsDnakVtxFJBCdjjREoIQyF0mnl1FXmmUQEg+eADFFlXJmbQsfZTx67Rk4F9YlRbHl33KZvOmuAw/6fgl3ia6QXtN3kvNVmozUkUEjle4+VH1T1dfkhVFGc9rpzMQrqAoJhkBAKG1IqwnFwBhYjZLeN3iEBFJF+4iYVVflbmOK8ExB06vcboBsCtEdqg8L9FRsXiViE2zEv0WOQjcK43ZDtHRvIf6g/swb28xd6WQoApvhtF5UenYU4emqYU2Eiq+EsrZfKhpfJaAw6KsIBhPgElo9vKt4V9+0PZD+FOZGE5o7B033su4Q80eQh8cveQ+N3CdZ7w++DK2GYjd+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  6 ++----
>  include/linux/mmzone.h    |  2 +-
>  mm/vmscan.c               | 26 +++++++++++++-------------
>  mm/vmscan.h               |  2 +-
>  4 files changed, 17 insertions(+), 19 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2edb9beef6d3..46beded51c7d 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -265,11 +265,9 @@ static inline void lru_gen_update_size(struct lruvec=
 *lruvec, struct folio *foli
>         VM_WARN_ON_ONCE(old_gen =3D=3D -1 && new_gen =3D=3D -1);
>
>         if (old_gen >=3D 0)
> -               WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -                          lrugen->nr_pages[old_gen][type][zone] - delta)=
;
> +               atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][z=
one]);
>         if (new_gen >=3D 0)
> -               WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
> -                          lrugen->nr_pages[new_gen][type][zone] + delta)=
;
> +               atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][z=
one]);
>
>         /* addition */
>         if (old_gen < 0) {
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c161d563ce8f..4c4aad95b0b6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -554,7 +554,7 @@ struct lru_gen_folio {
>         /* the multi-gen LRU lists, lazily sorted on eviction */
>         struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES]=
;
>         /* the multi-gen LRU sizes, eventually consistent */
> -       long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
> +       atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
>         /* the exponential moving average of refaulted */
>         unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
>         /* the exponential moving average of evicted+protected */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fe1fe1439c7c..8d14831cdf83 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3350,8 +3350,7 @@ static void reset_batch_size(struct lru_gen_mm_walk=
 *walk)
>                         continue;
>
>                 walk->nr_pages[gen][type][zone] =3D 0;
> -               WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
> -                          lrugen->nr_pages[gen][type][zone] + delta);
> +               atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]=
);
>
>                 if (lru_gen_is_active(lruvec, gen))
>                         lru +=3D LRU_ACTIVE;
> @@ -3971,11 +3970,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int=
 type, int swappiness)
>                                 break;
>                 }
>                 flush_lru_batch(head, &batch_end, target_list);
> -
> -               WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -                          lrugen->nr_pages[old_gen][type][zone] - delta)=
;
> -               WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> -                          lrugen->nr_pages[target_gen][type][zone] + del=
ta);
> +               atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][z=
one]);
> +               atomic_long_add(delta, &lrugen->nr_pages[target_gen][type=
][zone]);
>                 if (!remaining)
>                         return false;
>         }
> @@ -4093,8 +4089,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsi=
gned long seq, int swappiness
>         for (type =3D 0; type < ANON_AND_FILE; type++) {
>                 for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
>                         enum lru_list lru =3D type * LRU_INACTIVE_FILE;
> -                       long delta =3D lrugen->nr_pages[prev][type][zone]=
 -
> -                                    lrugen->nr_pages[next][type][zone];
> +                       long delta =3D atomic_long_read(&lrugen->nr_pages=
[prev][type][zone]) -
> +                                    atomic_long_read(&lrugen->nr_pages[n=
ext][type][zone]);
>
>                         if (!delta)
>                                 continue;
> @@ -4625,8 +4621,13 @@ static void __lru_gen_reparent_memcg(struct lruvec=
 *child_lruvec, struct lruvec
>         child_lrugen =3D &child_lruvec->lrugen;
>         parent_lrugen =3D &parent_lruvec->lrugen;
>
> +       /*
> +        * The child is offline and the lockless updaters, which hold
> +        * rcu_read_lock() over the update, avoid racing with reparenting=
,
> +        * so the read/set/add operations below are safe.
> +        */
>         for (gen =3D 0; gen < MAX_NR_GENS; gen++) {
> -               long nr_pages =3D child_lrugen->nr_pages[gen][type][zone]=
;
> +               long nr_pages =3D atomic_long_read(&child_lrugen->nr_page=
s[gen][type][zone]);
>                 int child_lru_active =3D lru_gen_is_active(child_lruvec, =
gen) ? LRU_ACTIVE : 0;
>                 int parent_lru_active =3D lru_gen_is_active(parent_lruvec=
, gen) ? LRU_ACTIVE : 0;
>
> @@ -4634,9 +4635,8 @@ static void __lru_gen_reparent_memcg(struct lruvec =
*child_lruvec, struct lruvec
>                 list_splice_tail_init(&child_lrugen->folios[gen][type][zo=
ne],
>                                       &parent_lrugen->folios[gen][type][z=
one]);
>
> -               WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> -               WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> -                          parent_lrugen->nr_pages[gen][type][zone] + nr_=
pages);
> +               atomic_long_set(&child_lrugen->nr_pages[gen][type][zone],=
 0);
> +               atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][t=
ype][zone]);
>
>                 if (lru_gen_is_active(child_lruvec, gen) !=3D lru_gen_is_=
active(parent_lruvec, gen)) {
>                         __update_lru_size(child_lruvec, lru + child_lru_a=
ctive, zone, -nr_pages);
> diff --git a/mm/vmscan.h b/mm/vmscan.h
> index c2cea36289f3..6551f0a6691a 100644
> --- a/mm/vmscan.h
> +++ b/mm/vmscan.h
> @@ -126,7 +126,7 @@ static inline unsigned long lruvec_gen_size(struct lr=
u_gen_folio *lrugen,
>         unsigned long size =3D 0;
>
>         for (int zone =3D 0; zone < max_zone; zone++)
> -               size +=3D max(READ_ONCE(lrugen->nr_pages[gen][type][zone]=
), 0L);
> +               size +=3D max(atomic_long_read(&lrugen->nr_pages[gen][typ=
e][zone]), 0L);
>
>         return size;
>  }
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

