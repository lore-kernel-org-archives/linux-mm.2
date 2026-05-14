Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA58CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 06:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562366B0088; Thu, 14 May 2026 02:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512D76B008A; Thu, 14 May 2026 02:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401406B008C; Thu, 14 May 2026 02:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 315616B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:11:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B06801204F6
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:11:53 +0000 (UTC)
X-FDA: 84765004506.09.9148839
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9174340006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:11:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QrCHKvNO;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778739111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5REFkVRQP1PgZhQ8Dd1IAxYTmrHpN93ck9+DTARhFc=;
	b=EwJyfn/+NIytzXICbyzGNXMqxgA/0KYVcCOzfeFK8c/d60rseSN8NJ5Wn9sIKX/8+PMkZu
	CgqDh2TwYyTddq6YqEmZSlRq7Jf+IBypL/YRpwOPNhcXUXfbkuxWArZBMKne5EIKCwsFVq
	2HenmRbZnRjCaswSb8ojOWznktJX46g=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QrCHKvNO;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778739111; a=rsa-sha256;
	cv=pass;
	b=gDON5Ex5jTWRFDZJ3f5+98bHOdJfTzOVngLDgeF6wggu+EpAW+J+nl6agxYPYMnGrDvHrK
	BnMJrKYbBedVdC3SWNOi31oqJnfkOoMbgS3sBmQ0alIazZTJUCcCpHIAG5qjhz/+ZG0xiC
	9onJpOdoFT9yAU8C8tKq+ZF5nbzpa3I=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6802f9c5debso6247112a12.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 23:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778739110; cv=none;
        d=google.com; s=arc-20240605;
        b=jgxGMvnGobTBDcaN7LN+DZItmAvIddnSv1eIAoJUufljUMpf9FCjo0GimMwltYERw6
         XzfONVJ0XNxBeHqfh9hfhWCRAfNZfaEOfS3w/5wRqoQwAoTOlkGhkNRdJdPlRBppLrxk
         mM91NF9MHLpPsB26BbzcGId2aR8bGoGBPgsVVVVerupoBAX7dGg20FJKSEbredhTmv1o
         zEiOAg0GH/jvHhXtLX3/hfKYa2xsRqc6Po7ee7dOMzzdEOhfiZFNKrlOX5MYQSr90Omq
         ZsIzFEQ7+zCnvvYZkQnl/ECtznPnLEIcD14Bg0LJKh1ie0drLsiRZjsf2Hg+pfr/ldMR
         RcMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G5REFkVRQP1PgZhQ8Dd1IAxYTmrHpN93ck9+DTARhFc=;
        fh=GSI4Hxk9X45wY8tM7WKXO/M9KHetpu+Lq4IE7FEOTzc=;
        b=S5IVpTfm9cP/8UlwDlLPP8R9XjZ4k6ayitXbtV4lwqQFRtUPo8Wtn9g0MX8P0f0h0j
         PBHzVvjav2kCrf++kFn7F/9//5Lb4lHnH4eO5mpfI+25U0ECzRVim/XT/63NiQ1JSq4v
         T5pStiVVoaiDX5gwe7n5H4qKFV7hR4Htlu2YvBy2jJIuE2ekzQxoGYdBy0f377Xtbrlk
         uu1CcPPofOt+SrajhqKOUbtB0kcvxoEppb4j69Icnj1WajAwX49qZUfCWHGryVUxRoUc
         hX8OCV3VpfPbrtbPzjdxCnluMxcQzD/p8r5rUQLXJ+6rY1nAHUvi6mxgN07I4B8Rnrp+
         rM5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778739110; x=1779343910; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G5REFkVRQP1PgZhQ8Dd1IAxYTmrHpN93ck9+DTARhFc=;
        b=QrCHKvNOsuJ5aLimbhykdVUAmWbCXBkcLw1oai6yTjKPZ4VNcgpHQmoanWaQgBfFxK
         hVUHr/vBnHnqceSiLe90/psHrvp+CEaNvmQQ9e1V4sTv4EmqetUV/vXbz+jV4q47p899
         ehyGtLRmXwE+NeWCNJJ2GTAz6AB1tK1LYAP08wT6zQyYYQJ0y5dTvQnNf6QwBWKPtOE6
         SejHygyN83163aaW8EFpXMf188/fGcMALXwsnYXD8ADa1shjOnlIigeS/upiUeCJINHl
         Zc59dU3f4wEneP5MTl0DiV1zAL0TKFyyLsLj241xj8ck24Sa26ZLPA/Lkbc+ISgj8Suo
         2bfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778739110; x=1779343910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G5REFkVRQP1PgZhQ8Dd1IAxYTmrHpN93ck9+DTARhFc=;
        b=e9soXAtfECwmWsqLvJUy1JH90NOMBFhZpT3NzFyLy2vP+VNHmrFI2HhqCiaHIl8ZN2
         4UNZCSMH6AIf3Y4VMdYOekz8AoYMwKRHOM9qoAX3wKLqCLVJo/YRUI+KIaX0x8D8D+MK
         EF0kSEb4eBUyLO6DQlcjpWYkb3XYdC6Na6accCPG6V2FZuq2VtxOOD0zpXAx0KWMmSBR
         0ly+RD6HMiOQwoZl4KQ9VOsA0VvtjO1wTNZgTnt295RefEdVgG2JWKZ/LeR5ENmna05F
         qP5wIu9i3vYLWCA+nOZaUVYW5I2I8q6kXeO/DpQC0P3Sa8OLc1o+ahMYXVkHB1vUixKj
         bjyA==
X-Gm-Message-State: AOJu0Yx+HI6FFQfAcxFpP71H3rRB1kqyaG/J7FRqDrZ9K38l5uWx8A6k
	z0jonTnU7QFGfcYTtRjB1eiz49N8MMnuN5O8rnRPkoCG61KaXizAvDUSaA2BhTf1qAuxx8lbX80
	GmAp3Y4yfuY+LmvzIq5LmmvPXHrFIrzE=
X-Gm-Gg: Acq92OEax5JqqrmZg7B3DrPs+5wyBzSEzQfzooQamfi+9clbzMseVCU/YxqytXFPIsV
	i29uuTGEtIbI3A/CB2ooJIuIuNqPXCrw40MujYd+FfPWkyQ3FO9xGZxH25MAw5VmEdUqT0dUiAW
	rHOhkCazVoLvue5SESw5xieojMDVFath5x+o9xH+HtzJvKYfNhVWzPrtbeCQDIb9x5knRr+xiBP
	G012k9mXKewJ7J7DsA680yqT35azbIzFjeIXJFumk8fXVbF7/bonZfO7xnMcrvJSBmkKYKCGs5Y
	CURoXL+S7N0GZpHLsfQARYjPuilZabhoLN4qqMUx
X-Received: by 2002:a05:6402:a54a:10b0:67e:2498:dc77 with SMTP id
 4fb4d7f45d1cf-682559fe2e7mr2979488a12.6.1778739109728; Wed, 13 May 2026
 23:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-4-2f23759a76bc@tencent.com> <agS0RbXpVMcYMI3g@yjaykim-PowerEdge-T330>
In-Reply-To: <agS0RbXpVMcYMI3g@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 14 May 2026 14:11:13 +0800
X-Gm-Features: AVHnY4LqVf9KEtjDJXQ19-lzC1qpbt_GnAEMVZu0CXtWRcKkvRvWTO9NkXEF4dc
Message-ID: <CAMgjq7D8m6Fon0TWRwF1c5QqKso13wv41YNu5aJsR2Ggf8Y07w@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] mm, swap: add support for stable large
 allocation in swap cache directly
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: t88jk375x8z9fpyo8bdrpp8izzbtcey9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9174340006
X-Rspam-User: 
X-HE-Tag: 1778739111-608620
X-HE-Meta: U2FsdGVkX1/SJ3myl6b9zp7C4Rw0M/7QmqrSAV7H3bH5RLB4D3iPxO73JzxEWhDcyDGB0RNJh/q0LNnW/lE9niz/PR89MpCOflkXd0kp/cbcXYurPuTxNLl4fOW/Smpn8Zlvb1aDfR0KhoELoxKm5fvuaTD1JNdMOEQZt7uGBEh1IrVjkLGhN5KnWJ5UO6O5+PyDuLcn9WPYUSkNm9zN5AYI+SMZOf4Kaxc5LHuvw6Qc1Hebp91aESTXmAEZxK3DiUv7f+tctoSen1MMhQC9xM44xOJ0zyGqn6o0TfUGro9PhwVjF3g85TEfAGwmM8AvRn8y8MjYAWNkKUCnP0rnw/c+svDWCI4XrynP3p9kTCbtgxoyIXPnhDlvl6wcS/ozH23Odni83IV9HbrqtS77ETM0bpAwf2PK7V0kClThriURd70zSgvtzkeEKk6Ll2PgTeK226fJDZdJAR0ablS/0jY5YMFM/0dUh51f3Ll4D2jdb/qOZjNm8T2Ay8SlR1iyCFpsMEN4sXfutcj9E3XCNFo3n8RND3ijpGmZ8kXPO21AH+3GRtSanXvGFTY1d2KbTpoqd8134FOZKfjMHaiaGxhxMdrYR5+sVTOvryshYnYxKU5f9fAdGGvlGibuinHJJ2aiehZwMv9HGwqxaDV11jYdxUSBiAtuJ8pNCyIE2HpH/WC1NM8zd7uD8f+Yqm4KSChfLZ4w26VtA8oj78eCq5N8+9ngj5v5FJwKvUIMUtbHnpFe47c/Qak1dWKYZIzPuZde+tJWfOnsLohUWo9b/C85ioQnV/Zv2ca6wsnuCa2PvrWX9aUj9F7YdGO4/zbi/DEYf/NHXdoNrCo2Cyn1j1xLjHaRNoDbLroketojpHVL65EH0NfRz4Jhkp99V2bu3hwIDczTEkKPnR047cKKOMh9bnmzDjKSzpbAJWhv3Yzn+w2bz+c6yOTLLx68QwrKJWumWMHpVaD7lg6GKZR
 wNgp2nyK
 8CwXMJ0/RRjPne2OftHwXpWVHpviq8/0Cc2+wiAbka33Gvsp1IgI3k2AplxGWdb/U45RFkKfOimvP+nIh2jP/rh7qzq2lQyhQfqZEqjfoFzSHk9cfz43ndAAJTBCobbUG0hBOb7F6uFw+5MXINYoqEUdpCuME2h8s6z7xuGqrbyy2NOs26oc/9jRfGwaYnB4rhDSjHAd61biSRwmK1MVcKI0MSNoIs8Hesja09O58tA0PzkHtlKTg2+s92xtL8NSqrjGkIaP0gAIy8Sw4TRHN0vH3oi8Co4OkpMu8ApxXJ2ku1/jcwLuu38To2+ZZUJB6s64YalyZQC9aoF0lyvmIhWJVGRHiWlNR15ZeEfsb6jSkqmjsrNjm8vnzDdWx2vesP6mjMuaiU4UyA7PkccZiESWMO1lVSEQ9/rFXZwG9at5MSuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 1:53=E2=80=AFAM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Tue, Apr 21, 2026 at 02:16:48PM +0800, Kairui Song via B4 Relay wrote:
> ...
> >  static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gf=
p,
> >                                          struct mempolicy *mpol, pgoff_=
t ilx,
> >                                          struct swap_iocb **plug, bool =
readahead)
> >  {
> > -     struct swap_info_struct *si =3D __swap_entry_to_info(entry);
> >       struct folio *folio;
> >
> >       /* Check the swap cache again for readahead path. */
> > @@ -594,16 +700,12 @@ static struct folio *swap_cache_read_folio(swp_en=
try_t entry, gfp_t gfp,
> >       if (folio)
> >               return folio;
> > -     /* Skip allocation for unused and bad swap slot for readahead. */
> > -     if (!swap_entry_swapped(si, entry))
> > -             return NULL;
> > -
>
> Hello Kairui
>
> With the swap_entry_swapped() check gone, the swap_cache_get_folio()
> above the do-while is now just a duplicate of the loop's first
> iteration. Might as well drop it (and the now-stale "again for readahead
> path" comment) here.

Ah, very nice observation! Thanks, will drop it.

