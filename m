Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A17606A337
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AXUh9H/W
Received: by kanga.kvack.org (Postfix)
	id 0F66D6B05B1; Fri, 20 Nov 2026 01:49:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE786B05B2; Fri, 20 Nov 2026 01:49:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25BB6B05B3; Fri, 20 Nov 2026 01:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3EFD6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:49:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1595F80DB9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:49:05 +0000 (UTC)
X-FDA: 85454570250.19.1CA5B96
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 249BA1C0002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:49:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="AXUh9H/W";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795157343;
	b=sBs6VYDI/2Z29TanFBrmb5L0XxoEov1Bj4m+9uLLViZe9SuBf/uJU3uQqCqM6Hib0iEEow
	//XFuDGSLKRlc6uCrJcj2eXJqJuQzpCqSf8otPY/2pXmTQ6ASIFGHihh2NfJP6EshxotUN
	g6jIxNQtbMIZX3M7h0o6LWJY1Al1r9U=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795157343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+lyQHOp4KoneVTmx0lXKvEiHfZq/Kgi2CNuQIZ6Z14=;
	b=czNja9ljCOLvOwe2Tkus132ndN15qYTbzFFdzP6jDyim14MbdRnH1FqzbbTc2nHJeh2dF/
	NsyDqpAVsFqEHi1/nndmd3u+zk6F0CW2Zh/9TGb3RB9gAcewFVqN58X18UD8ihIWVnvlpC
	sMuyVIEvACczALxrWrxQuTicvivumlU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="AXUh9H/W";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so4697435e9.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:49:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795157342; cv=none;
        d=google.com; s=arc-20260327;
        b=hv6Cj8NKifuwWzAK8EXYzxhD4nND7ophg4l3FSxOSLVwgq6+lkcke8afncvcMS+mO4
         hEUIfzRE8lrBPhzFweVjv93+p+7EvE7gcQuTZazJce9ufwLuzVSow9pvWsWkrzM+PpcX
         wlq8u3pEe1gMLHGXEeurXMXVHr6EW3MIHBbGOeO6oFynSdT0ByZlpCyVD7kHwZxO0Rlg
         lvKv+KZXDaANJ42o5ZtmCJ0MQdiPIW1FJANVk4W6bM71eQ2UXAyvWqHqH5yloAZ3hsyw
         UmkuVKg+Ef5eY2OGX3+uu4X6BBUUQ8ypLepbROAwILbyK4HcvSzI36wdxhOk08ptKoeQ
         38Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n+lyQHOp4KoneVTmx0lXKvEiHfZq/Kgi2CNuQIZ6Z14=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=bmnoq8WZty/ETjFZV1xvn75mlhFjfYfS0RqRmHn3X5HVLxCMWylZwuipU6cG3JDjgs
         icYtnnVqrCrCg5joKXWOHs1Tj0g0qv4Kn2iXPDKd8YFCxImCVTeIZ0rE36RtEO54406O
         HkWo/vY4JPEuw0614ckI5yJSzK9UAc4Oi5HPOiHhGBhHWkdtHqZLoHr2mjMwAcBHCIPO
         CbibSB9vpfdC8wUlUjxDinp8e9Prr+CTQLu6iEoxAFgJWKD2gz2+tQ8HbV3KIe42LLJi
         4/WFwh63/99l8OxLpClF1lAbxg023GFfjK/VaY9oMZJwrdpQ0kID9mWHIxBtfexH9U+E
         K+uw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795157342; x=1795762142; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n+lyQHOp4KoneVTmx0lXKvEiHfZq/Kgi2CNuQIZ6Z14=;
        b=AXUh9H/WhRwOmlCDmoHtJM0Z/3ciJRa2RoTfeoXFkyNCfCq/2zkZ82hfuSJPb0NUYt
         BpA4vBWBrXqrsuw7OIiD9wn4XeUhnr4f6sTt4a5kMHvYldPXixz2OBJyJ/jKQPGq4T7s
         eyco3Q5MDzhZxvut0O2XKffXpXuUMkqf17+mtPbppSvfb/RVFqKr2wmTs4+e5QqwT1ca
         9h2VHdE67xxyno6Ws+JnFZXgn6Zy4mDDErR3wGRRMEDW0/HLp4USF6KnX7h2ie/dejWp
         5LxLgfItsV2pVn+qVmP4bu+KisFxiM7sYFv/o3JE6b+qxS1E4RghdosS+ZD1lxiFUKGv
         klKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795157342; x=1795762142;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n+lyQHOp4KoneVTmx0lXKvEiHfZq/Kgi2CNuQIZ6Z14=;
        b=icCPEFDsYdHOzPg2xlknpMBIEzeZvskwfLGQpIjJTs4a3oxZZVVtRt5wsOFdm3RKPJ
         3LCs/ci6ro6JYqSy7kIYTKbH2ryBnmYSpFQ74f62MUL2vjxX99F1nTAX6uTcOPwlGhFD
         jjvf3ESHo02jzsNupVqsq9QxPQ07LJ+dpHiaJJzArT9jb6UWANWH6JR1EqlRFCkoMT8W
         g6zPHGUNRD53P5YXmhIBwX75I1lS8n5Q5HI5nJGOLGdwxgP9CmEfjTbHsGsoFffnVrU1
         bY3rocyPvin1sJiNsAzfxVQ5XYxgRAFwW6cJudKbsltTJCd9TjWuTo7QQHcu64UxqEE2
         01Fg==
X-Gm-Message-State: APuU4Z9pRO6UepP/bG1FVzw558iZMvrNpg0Ez51QsR0oq3ijgxeAAcup
	LUqyz53UV0ym/q9Uhxw57gtgE+4BpVtXLPaOFet/Vk5gXKd2VEOnkWdarELiH+3u2ehASKP4+KO
	DyGypLsxaTZ2TWg4pKGtv6oIIpZH9Sdw=
X-Gm-Gg: AYBFou3kFhk1EYrBoU1nAfzLYRGNtNz+WxXskGu9qRxjpMmnZ6EywBix47sF2EbN+07
	Txgpv3QfjvVroOIKc/FEsvCudJhlwil82YQtMt3FoyolmFtrFOE5ph/m8Dqp8XG4OiD7MJ/7QWF
	JmG2R/cPdj1UF8h+BSEa0ru5WnqWrVM0IV0eNRvS0lQeA73JknpsZCJio2oSJv8Vcp8GonhLnxq
	wb6DgkdiSy24qqfIPj349d1knbwH9yDnokPNDEWYnFgperNi4OPGWJY1KErokwog5SLwa0EiMva
	0/DVeAX5C4Z3uMup0ElPDXvXiR1iX/lwtegvy/tm7bEPDvitbXRbeempZRrWxqBkOjH/mmtogxL
	kOLa9gDGC0Zy+3OUbMZYVCR9SiKtwPRKp4rmsicVJClmLxwC4QB5nQ86UD1LW7ZS2/w==
X-Received: by 2002:a05:600c:3d05:b0:4b8:d17e:da27 with SMTP id
 5b1f17b1804b1-4bb88930872mr41310625e9.27.1795157341259; Thu, 19 Nov 2026
 22:49:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-2-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 14:48:47 +0800
X-Gm-Features: AclHuK_tpistnJ8n9EgGJGhoSv7JK71sLxGmAZ5e78h-Lbf9KixLF9WGl76rLxw
Message-ID: <CAN_Opa-7j854ph6e7Ckmq6UgmmQerxF8V-ikSr9JNyTAHZCxdw@mail.gmail.com>
Subject: Re: [PATCH v5 02/17] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 249BA1C0002
X-Rspam-User:
X-Stat-Signature: 7rhgsbfuk57nzwmzk5asa3pnpqep4h7m
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795157342-298196
X-HE-Meta: U2FsdGVkX1/9Hy2dIqLQL9W1rGCBJGSDP3ECDjgc6okYQ5wZ6LjNa1HkzxaUd8L5vE2plRxO8jX9n7rpY70H9pq0MsoCNIzi1+z16TNl+j0NfRftRrEjGfFovUb08Qs28z6b0esVk+/BorPRUZorDpL7mhBYJEtf4suhKXo5dJIg4WAiXs8I0mTuP9/6wRF6jJvZtrzjEtB6sCfqpXaBtGoHpEhpmSYnJS/zh54/4oK4LpJ/Q8kKnVXuqldEfPJ6ioIYy4E5no5ZsiU9IspE6aDO9VW73vygWGOANuhqpiJ98SSZKFxddVmoUFrecLoSz+DYTdChxeZ9yVK1CpiDfYSVzGgPT3uLWOJ+evS4U+F6Ly21vyYnHJmMx1x+VO4L5142a39Go3atLjL/t7ZJAORvzwYWa+EXqWosZTt5phi6ESDLs7Qc0vw+NUgq74KGYBdGfw4MgdNLsDLT3L+Wr9nnGT8wVz/g+pJo0bckYDwpSW3xz8nJUuMQQNrC2cQ3IjVeEm4g+9q2irWW4T7d8/dIAiBvQVJSFaiJstnR9OKd7LFgDo0UV/re+M2ybrP3oz18UYFeX0vRTcG8YucxHx83RHwEo5EsSYrHyp14n+mF5YO2u4/xEsg7UXRpMufYi+Tj79Q/dawfjr5Fk6SiQ1hrlGJG31zJQv1UsWka2IKZieuojBN6g/SUniA6UUZev2sCNbFHOYX9znlYMtP9mnNJ0ykj90H1lC2NVio8woBE2GmMiKpLdFnVgkYN0i3BS88VGPgkhIiJiJ9vB+A4fK9mRHtxaaoVfWqRprbNK0XIC+BJ7pckIDIRTXs4RQzsaZSViWRLC08OsAOK6Cu0hl9nHeafOQ8as3m7lJRCxb33LgetztwtlnucDxD8OWBvPlVZBiC+UOTBMFtgi7bd6k5Sk6rxtG9fQHCbNLVYO/VnUD0rvcCn86eOLwYByeeMex4q1/x3wcm71UFN5re
 lfyYcSyJ
 EkSGeGB2sZCtj18Y3O3hdgvjRArQE5+KQgSW5/YF/Ijx7YRsi9+ayNzOu/xX7tS63jTVI/4E9wItLju1xZDgTg2JAkb0JDmw9yss4ZvX70laiSqvu1b3UrFeerK56sgIzPL/Kk6+u/4jBFKeIe/9OQa3lsokkmGdJGEc6a3VYfP1YqpRZy5bAVl77zzh1VJrwZ0yq2KJ4ZK28mSBVWAsWYMg6EtTaeeGaFD4quxxlLukmqTXnB0eFvGmWyILwiudjCL2Q37491Gg47azcQDpYApGPY42uCjhsLKxG8lAWe3NBk0JJmA1+IAYdIx4g4zqvVSsHUW2QwDWDj71Ndwbj515ajXJ2gkA/ppK3IZCh3aI5WrIV2iTTeQs55Wo8rQhrOTOhoJq3NVyNhMjMjzE89xHovvTV1HbJfYzk8uBiUwgn0XENg1tTDe65+A7HNM8vw7H/hCefxI+n9AbPqr+OesSY2Q2AZlbtZ1VWCOJSc/nOCE++Jek7oWHHv0YfozWlZM/C6pFLMkVMuqu+CCtI0lf9hOPNfnMnSuWX4BlNEF8GoWxp+TTQgocBaW7nTG3S7h9xLilk20s+x9CKAOC39H1PlVWw2ChjDqGoQmoT5daQ+hUch2jnBI68f2gTCXrJbBEuXPiTsJfnEuY221XVfZsdB7yVt62lRTPSQjcB1BGsJ+6OzmCm4+FOYbFMJcay9vcNFIGNXx/xYb81hDs0D6pC/hhlLOIRS93u3YyFHcwgh6wHWsyKaRnqc1Sg9MBLIrRng6adkJFgUE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2395ca8ee305..2edb9beef6d3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct =
lruvec *lruvec,
>  {
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
>
> -       lockdep_assert_held(&lruvec->lru_lock);
>         WARN_ON_ONCE(nr_pages !=3D (int)nr_pages);
>
>         mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> -       __mod_zone_page_state(&pgdat->node_zones[zid],
> -                               NR_ZONE_LRU_BASE + lru, nr_pages);
> +       mod_zone_page_state(&pgdat->node_zones[zid],
> +                           NR_ZONE_LRU_BASE + lru, nr_pages);
>  }
>
>  static __always_inline void update_lru_size(struct lruvec *lruvec,
>
> --
> 2.56.1
>
>

