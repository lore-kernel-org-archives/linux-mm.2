Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E1410A62F9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 14:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980DB6B0005; Thu, 26 Mar 2026 10:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932586B0089; Thu, 26 Mar 2026 10:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847716B008A; Thu, 26 Mar 2026 10:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 764AB6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:37:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C3141608C5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:37:43 +0000 (UTC)
X-FDA: 84588468006.26.A83DFD5
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 239B820011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:37:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TrtP/KI5";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774535861; a=rsa-sha256;
	cv=none;
	b=qOscCHTR/D6TyGhwd0cpGI3hCAmhALKWI10zVKBISBoaH7TzG89VFdwnD0VsUBZPKsovH/
	3dwJRMRmIk7eZzbrcQUR0Ucr9N2g44Be8q6tE1sU4E8y+dmBXx8Lsjc5kRSqN8tm7LrZyp
	kIMsrEcv4sKXkJ8WffMwq8dHpJoDAiU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="TrtP/KI5";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774535861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LExnV0j7gKvFxp2DijKwHbwyH1cYLP8Al1bnrSceMkk=;
	b=1IviOWQGT98oJLXnFYyaXiOkjnZhL9mCasFHGcgjCivz4Lxnek5xZR7LHcBMEuo6ac5Qo3
	yjPvUFzLAyaLO5jKiE1KFekKENypU8yF/LUh0Nu/IfNRiHRPZOTDliPfURlKOfc81IE2OS
	pfBEPiIL0kl7PtXnRI0LuLhli5htmL0=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48374014a77so12790975e9.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774535859; x=1775140659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LExnV0j7gKvFxp2DijKwHbwyH1cYLP8Al1bnrSceMkk=;
        b=TrtP/KI5m2ZF5rUzw7Z40QgFEkMPEJrBAeNC8cKhuKfA0UmaCmxurpiZ0TwddPaezS
         ssG+O7AHdXYvdLF9MGcg3AWLZR0nYBnNu3gbSpeofbOvnN73cSjzOx7e+/vsCjCEkTMq
         xFF6g8eE72txlPRHoRu82KBqtrENmSf6dRLDpdvWu30vCLeJs3FWdsXdIfG69RBKfOjj
         +rqbmUitT6k9KTVFvLcbGtqrGfQh4vM+sIpGkiNuEhXH446U3dBGn2Wl0xSZf41js/0O
         n0luBaKVpDsF79zmTAjbpK0lzhkHUvFEeHuiputS8V7zE4ANLzG/qiMA6EJPYEmnFdXn
         pXuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774535859; x=1775140659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LExnV0j7gKvFxp2DijKwHbwyH1cYLP8Al1bnrSceMkk=;
        b=Q25eUkgVUZn4ZSBsxoGlLGPyHsswrM6Lxxa4/WooidK2eRhZhBCcEr0tkK84xqpG0x
         W532HYFYloHofGgO3B4bcG0lfMKVCHEXnZ6zYUSTXbw9LdMQ9ekZM3AgRoD8z+JtKmiX
         OUShFDsDYvr44i7LSBNn2nHYmv555uwFe1fkQ+mrCtgH/qTcgAvCwOO/9bzaNe14g638
         BDsJcw8+s4imHXV77BXnyIv7TYZiO44VBL+EtR6VxfECEG/yhYbDsVJ5vDoBPxyvTsQP
         zSd7i3Dul938mquk1cJfwY7avJUi7Iyn+Kv87fyh6P9IzZcQ6ufZAmmEWKDQuhOj34xX
         bT3g==
X-Forwarded-Encrypted: i=1; AJvYcCWC7zGaOWzjSWWSDaajzQyi7dVtVYVngwGCeubfTbQOwyyrfAtfMvAxJB3zOdxU7CA/+5DQD9qJTA==@kvack.org
X-Gm-Message-State: AOJu0Ywy3SoP8dYlculBZT54nQDyJuq/WJCDsAHYhVzG6mAawId3RQbN
	qECKFnuoUVDlniVtP8Y0q++FqNgZ2FwvhQExV9S6ASYd2G1QBeltxFKf
X-Gm-Gg: ATEYQzwQlhbeXlasRJrEEsTqzuwZHE1Wc8Y8WAJr7NlCGtvehtNy/Wzn20Dfut63iIC
	kRwf8EsmOU4SPrO3h1iRUU/rTNOg9KFuQLVy2WjdTz8sAH8agF+pbljQAN2sOTUb081DPFjsFCi
	XqbOjJGlEUVT/6hizBordy5m9xiiW053+Lzy6vahol70tpslNPZ6U59l1ZgmwvfFgLFD1sj5DpV
	msxQPj1QV7ptiIWP6c8Zs78Cu2cSGxcKdYgqOA9NrsHJaV5zoJpa4oylsGZVoCzKK4YLd7GjkkR
	FuusoqQ4efie73gIIQODSvVn1g2uNLzwjO3yma+Q6GmUQjKUUQoDIYOEV4KlyErIjylCXqKelY0
	WLzExpOSKizm4uxwjeh56SieV10tydzH16Tz0QlmjImF1NMoHDPZSI97I3K/FCGwyAJHUehjkKX
	02SCqpcFgCLUlMIn9ZMMJbl1EW8/sh2eapmrSEFbKwYh9zgD3YAjq1XM7wVKhodCoU
X-Received: by 2002:a05:600c:4685:b0:485:2ce2:4c87 with SMTP id 5b1f17b1804b1-48715fc3562mr126363235e9.4.1774535858924;
        Thu, 26 Mar 2026 07:37:38 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4871fbbf65asm24277075e9.2.2026.03.26.07.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 07:37:38 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:37:36 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
 usamaarif642@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 2/4] mm: memcontrol: change val type to long in
 __mod_memcg_{lruvec_}state()
Message-ID: <20260326143736.12d22e38@pumpkin>
In-Reply-To: <ac9c3d78-6244-424f-82b0-d5501145484c@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
	<5c42058df0e52a4698da005e502deb2fae7bf819.1774447069.git.zhengqi.arch@bytedance.com>
	<ac9c3d78-6244-424f-82b0-d5501145484c@lucifer.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 239B820011
X-Stat-Signature: sdq5agsib83cqd4z1bm17djroufya6fw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774535860-960037
X-HE-Meta: U2FsdGVkX18RwYo17tElDZ55aepz+VBbmpY01YYoqF+qkRyTXjXUM2Jt8CCsxW96/XboFmpccJ/kJ/J+87ogGveHqQE0l6w9KS9DvnT78pO5Vqul+H4cwcxktnBaPr3FaQD6EEHw9lJEyStHrEUY8k+T8S2OE/ctihrQ6ntJBmzfU+VX8AwnLibIKFVGAobSS6Mf6Lxhf7mvOXMVwFu3iriCGdXb/3Iu+q3+GDGUSb8hPM6RMp496tuaGvu1fhX86GxVvU/LDDuZxXvjWFCocoxftT0RdUz81LpYxH5IoJ7fPVym0KEiB05VK5XqSJaN+dB9STbihXzSDIYMvWsEdqXsEYZLgXPdetbr/1SeQzOQVrqXU4xo/b4Eli4SaFXr4xv0CZpMjL2edhOQYNUo2epjF5E9oAN7yuBvVxWjseS+vXaHrIIo2sdweTOqYxrR9rRyo8dFtr1fsun1ulRbInbDO8mYNFGBarBkMSrCcLkejRoDZrrkJ7g9ppQ39Z+kYxg5LceK9QsLtJICmRRW9A/t8EpEcb+yMn5w8pZ4d/AyofbBwwXnokSNZzl1c8kJVebEKBexO+VDlBX8Gwl1NUa2q5892QC2biGt9EbxiB9RBnItMSKdPVUGezNH4iXRh0pXVFJAYr7oe4AFnLPVaiShul7z75rKyqi5U039ogYTRFctOMB0f3Ywl8byvG5tVMPC/UJaaVKyXMjZeET6MYwNBjOgDlqPKhhjijfjEdBzIoUrosWGIcD4g3BzjpzqFqOcdemokGi4Nymqspx0eFv5ZiO328BDRAXS0M8vNoD84009e4roaJHWk3o7Ni2WCq/91O0K1EaY8O6B+cp2dTk1wbVu5zeWEADb/Mr1hXLAu9PcusaLnSyqqluNbe+v1PJlSRs1jwN2y+Oxlnz5gB4Xptc7WH45bwVUfGFCNQoedmkbjz8ErXfasQVtLLlzPOP774AWqqRdEV7c9Mq
 JNnIKURD
 UUpSZTAjtLBFV9YYRGzHO27e8pVve1TTvVC8ubqe9snZ7BXIB+6MuRLoLtFqoHeEQxTQaweMZjP3HimwvDKGYMIC4XY3qWzLUGpuHjPpodTRXmWMI8amFuZhGv/Fz0NWQ+UUEwDECzgo4+SaiurZmqcsO0RI4mXMOXYPb6B5XhZpq3G0wkQIx/yMN+Mfx3IqmTQKrOVh78NZ8J3tSRxS99LwEI/DtC8BwESp5DkNbYBIU9pn++H4fclYGUF9jVJymVp3nkyN0cPIOqWdWWnqKZv8huHbckVURnOA7mgRFLB2bZIgJEaTRrwxrkrmMF8bgOSKLDu0BmP1k71kVjaZjQ/8TwYy3YP56bij/DRTEbTawKDaRR0eGA6OHJiOxyKUEWLi3EPdWvcg9fuKzYWoyeMTStgG/t2sooEey9BwIGP+DzhQLJgunBNybtvluELXdd+jt0mtceM9r9Y5f/0ZbNUF6uxMfALxvkkUVUgSDc4nZSZ0AqUNnjUa2UHIapvanEUJiqmX45xEa5wOWmzl1azs/qVvekaj6Nv6cT6yd2flUDlVku+avwSYXcLmuIhM5WTTI9UtLhJfR39nEDW6Ugx5EciFKi2N/jMfy0sLgg19Ev4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 09:19:29 +0000
"Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Wed, Mar 25, 2026 at 10:13:23PM +0800, Qi Zheng wrote:
> > From: Qi Zheng <zhengqi.arch@bytedance.com>
> >
> > The __mod_memcg_state() and __mod_memcg_lruvec_state() functions are also
> > used to reparent non-hierarchical stats. In this scenario, the values
> > passed to them are accumulated statistics that might be extremely large
> > and exceed the upper limit of a 32-bit integer.
> >
> > Change the val parameter type from int to long in these functions and
> > their corresponding tracepoints (memcg_rstat_stats) to prevent potential
> > overflow issues.

Won't that are be true on 32bit systems?
Which means the underlying values need to be u64 not long.

	David

> >
> > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>  
> 
> LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
> > ---
> >  include/trace/events/memcg.h | 10 +++++-----
> >  mm/memcontrol.c              |  8 ++++----
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/trace/events/memcg.h b/include/trace/events/memcg.h
> > index dfe2f51019b4c..51b62c5931fc2 100644
> > --- a/include/trace/events/memcg.h
> > +++ b/include/trace/events/memcg.h
> > @@ -11,14 +11,14 @@
> >
> >  DECLARE_EVENT_CLASS(memcg_rstat_stats,
> >
> > -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> > +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
> >
> >  	TP_ARGS(memcg, item, val),
> >
> >  	TP_STRUCT__entry(
> >  		__field(u64, id)
> >  		__field(int, item)
> > -		__field(int, val)
> > +		__field(long, val)
> >  	),
> >
> >  	TP_fast_assign(
> > @@ -27,20 +27,20 @@ DECLARE_EVENT_CLASS(memcg_rstat_stats,
> >  		__entry->val = val;
> >  	),
> >
> > -	TP_printk("memcg_id=%llu item=%d val=%d",
> > +	TP_printk("memcg_id=%llu item=%d val=%ld",
> >  		  __entry->id, __entry->item, __entry->val)
> >  );
> >
> >  DEFINE_EVENT(memcg_rstat_stats, mod_memcg_state,
> >
> > -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> > +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
> >
> >  	TP_ARGS(memcg, item, val)
> >  );
> >
> >  DEFINE_EVENT(memcg_rstat_stats, mod_memcg_lruvec_state,
> >
> > -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
> > +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
> >
> >  	TP_ARGS(memcg, item, val)
> >  );
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 7fb9cbc10dfbb..4a78550f6174e 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> >
> >  #ifdef CONFIG_MEMCG_V1
> >  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> > -				     enum node_stat_item idx, int val);
> > +				     enum node_stat_item idx, long val);
> >
> >  void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> >  				       struct mem_cgroup *parent, int idx)
> > @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
> >   * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
> >   * up non-zero sub-page updates to 1 page as zero page updates are ignored.
> >   */
> > -static int memcg_state_val_in_pages(int idx, int val)
> > +static long memcg_state_val_in_pages(int idx, long val)
> >  {
> >  	int unit = memcg_page_state_unit(idx);
> >
> > @@ -831,7 +831,7 @@ static inline void get_non_dying_memcg_end(void)
> >  #endif
> >
> >  static void __mod_memcg_state(struct mem_cgroup *memcg,
> > -			      enum memcg_stat_item idx, int val)
> > +			      enum memcg_stat_item idx, long val)
> >  {
> >  	int i = memcg_stats_index(idx);
> >  	int cpu;
> > @@ -896,7 +896,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
> >  #endif
> >
> >  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> > -				     enum node_stat_item idx, int val)
> > +				     enum node_stat_item idx, long val)
> >  {
> >  	struct mem_cgroup *memcg = pn->memcg;
> >  	int i = memcg_stats_index(idx);
> > --
> > 2.20.1
> >  
> 


