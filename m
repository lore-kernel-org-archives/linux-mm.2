Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D91606B9C3
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TQ4MwyG0
Received: by kanga.kvack.org (Postfix)
	id 6A5C36B05B1; Thu,  5 Nov 2026 14:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655F66B05B3; Thu,  5 Nov 2026 14:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545016B05B4; Thu,  5 Nov 2026 14:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21E806B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:54:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A527160BEB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:54:01 +0000 (UTC)
X-FDA: 85402116282.16.7FAC0F7
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 791C440009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:53:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TQ4MwyG0;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793908439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FW6tKeq353YHIRkk0OUzFf/CvCzaixbIzv+YKmAJaT4=;
	b=fLM/qlbjReiVAP3sfjPiNyg6av5HOu89Yd0dK8WTB3ZihD2r86JIiYPAeQc00645RwcLyU
	en3IpUAKHXfTFx+GW2xKfc+OYhUGMkDAJj/EfIpWCDY11J9aWr/cRoFl8JEU0yy8oaFhQz
	MmWgZsN/G2N4GhxWh3Xp23OBHEB3Bhg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793908439;
	b=m/76V1Uj+PVgGSnsz180Dxseo25L4iCYv3imwHZ8nR8v8eDREgL++5UIJG2jqsNtEkiIEI
	787vqWWMtrqcMtVyjC9u9DS7NIMry1k4Z7DPyjD7vVATz2NaDgkHAD+Mr3M/UVLyl6WSyx
	JY1Xzcp6fHat2OVWZv7fpukMzHh9suY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TQ4MwyG0;
	spf=pass (imf01.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a4dc547987so13364955e9.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 11:53:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793908438; cv=none;
        d=google.com; s=arc-20260327;
        b=ERxu5ENJKRyze/jD76egUgclX4XZgxM9DTZmYl532007JzAzcro+Wxja5GIj0Bb2hv
         tRiNzou+MAjJA/nNaOVaEwsX3YrfeVrFYGbZjQOLEGpOVRck2lMDVVlDEFmeJuCF3C7r
         gGDMS8DhXOIuypXyiBXvtcmHhsQJIEG+mZ4Kv1LSdUm/0Xn7CDWseDkw5g+s4/lHAdcA
         lMUvnI/UrgmzrZtY/N6ivWOsVt4EHvRtxjj/EGA7oMuO50AY0kpRNN4m8qDj8/FBH95l
         cP66oyOfoP1Ht4rRMZ7XH7UcukOSLXqjwhCkqjuAOj9GT+BJK3k0CrIgmjZh9w0TqQJk
         ZpMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FW6tKeq353YHIRkk0OUzFf/CvCzaixbIzv+YKmAJaT4=;
        fh=F9ezsOu2gTUQQF09bzyDD7ywg62bjC2Pbuc/vzPswws=;
        b=fWdQS8RxDV8JTrlLU5I0fyLxr6aoVYdA4fVL/tQHL1NvwZMsDWKVI/agzuZO5IkfZj
         2sIKTq7IpXb+/bOR5aUD5QW2K1FxDsXZOq8eCKr0trzu3Qljt12ij5jBMbC/YoTaq423
         NNcnB6LsEjrt997bNFwfOBHReN5B94C0sI4SZtekPWXcRkBB9yI1YE43xCUlydqGY/M6
         JFh9q05iqNpuUzaL+gakJKodRkF7bPjMTqZ/KtASv6T6TX0Z/53NhI6CuXi8SW6Jnu6s
         y48CIFURotBC2SJfeHkGbUJ+/FFJYOtvcaGACzK6HXz4alviXgVhrHJzMJdwvZFbbt22
         IEhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793908438; x=1794513238; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FW6tKeq353YHIRkk0OUzFf/CvCzaixbIzv+YKmAJaT4=;
        b=TQ4MwyG0PJHf0gT2B5S+httaVAo+gb4T7lqTAZ3TlOA5AYJdjLXvMln2q/QK8oYxpW
         9J7uDGxeKaRh0u1HtGiMi/wpE1fWVIXzZQRA5q7QCCON4CY8xY/zw2Pqu0LzUyU6F/Rx
         OdljyPRKjp9cdWfXVpdlXvCwQ/CmT7oBFs+FoxDYEudSpclNo5EZVZYcad+Vwg2l8mGK
         GpO8tcDnzwcmnZaag4Ztia8+RISzrCc7iWz+mI4d5aO3RjxtetKQ6NPzqRmqOCBq58dK
         6zL+0izyf/czmT56GBxmGXbO0ilnmCWDrbijRF0YJPzwDNDzMO6KqTEN/uQHOVZiCufA
         Lrug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793908438; x=1794513238;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FW6tKeq353YHIRkk0OUzFf/CvCzaixbIzv+YKmAJaT4=;
        b=wKKyYpA5w9QLct6ZTRqnZWDYK5qqYA6f5gS1CYCsJVigKNnoGb6W12X5HWfqOqVXg8
         ZWVVhPffHd184TdqMfg06PpbjD8h6hNjyavqT5w3r14mwUFhnmX/9f1KOU38T1hG9QnT
         4dsF8Lv3xxYiCuWycxLwkVbtBy0+DDjDGDG2cpYnO39CK/6RFrv40yG4o39fQ07xHVUg
         7P36uTHb9KZokkK1avKeznU6qMjHYjdSQ9FFpCPms5hmVCw1b4vKRepciConxG/tgy4C
         rBbj7EJ3uAPLPkfKAnvytUT+HHLX4uhS1+p6Dkeqyn9Y4zpNl7qHzP5F+1bn0t0Ov/vg
         Eb1A==
X-Forwarded-Encrypted: i=1; AKwUvBxzpMAYZ6ThILYSVHUNGiTkhMDni0WNbvbLtiVlg0wFGt1cjVybxwZCnRmWM/uidv3oHCqdxJCseA==@kvack.org
X-Gm-Message-State: APuU4Z9m/ioDXQfiLnBx+VZPVdjxFYXz4W3yS1/qogYUTA/KyZaki3Bd
	dN0Z9mK/WcYImIYXqmv1LFLOvyr2DvX8B3oeBA7Q2FgcJ5uZwnRp274kCG1RrEDlOhwQHrKVT7L
	9Q3A5tx/h+0Y2iuyEvkg4bb+13erikYs=
X-Gm-Gg: AYBFou2FcelEvsZLu8w6VkK7aBiwl4ZzSbhCpF3ZzWpWFDc1qjZAlLT6McfhpSZgpLE
	y2Qp7nadgWHlnHsf3dkIvAmLhxs1EinDu+0Yp8vTFmSxcO7lQWchANF85Au0X5hDDn4xPVnM2gB
	B9ftLJI+qRhTFHb+uJnoz5LqCE0SfM91JLEfW/aLG6Zte95STQAWPUXyW7IjXWVcckjlWKwmtPN
	ypjdwZ6VHCEaKigFjQGS/5wU/etpePRLQQFkVQ3cunVGgewYkHZCSt5g3vgQUIZ4dYOcVsrK3Ht
	Ake8Mw3vBOlV3nsXIS3hyuDJvQ+ev25ZBDhZWF/5tArGtg/yBOrpQ4WkjRdSBzSbC+ZajiCgRFO
	HhYKv195gGC6qa8AzZA2KoaoRpinYMht4CCNXYlcG5OWk16T36DqlJASUIfNS7RHSwDLhBFsD3r
	oW2ANM8yBY+76RZWyeAg==
X-Received: by 2002:a05:600c:818e:b0:4b3:9540:47a6 with SMTP id
 5b1f17b1804b1-4b6dff86e38mr2801065e9.28.1793908437547; Thu, 05 Nov 2026
 11:53:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029204157.117879-1-joannelkoong@gmail.com>
 <auPhT70GU-Zqe9Qy@linux.dev> <6849a9c7-0e11-42f2-bd99-d7ae3d5b944a@kernel.org>
In-Reply-To: <6849a9c7-0e11-42f2-bd99-d7ae3d5b944a@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Nov 2026 11:53:45 -0800
X-Gm-Features: AclHuK83KbcAE74RZl_XlV2f3k85A7P5GaBmid_sbfdijpMH3WJv_bA5h7VKPGQ
Message-ID: <CAJnrk1ZF7FminyCYORxysXW0zA=fuUtBe5YXkabsSTOmXt_vdA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, yosry@kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: p4qcifhhwyip99dn6fbi9w3y8rdsby5g
X-Rspamd-Queue-Id: 791C440009
X-Rspam-User: 
X-HE-Tag: 1793908439-68012
X-HE-Meta: U2FsdGVkX19nqgQ7SEF33xofH60BNcSk3BJkIg8xmjxXbSEXMY1vAA8+zZwUlAF2Ln/KoyuA8fHak0m4UZkK3wflf/BMtF0QCWr341JVPlFjmpRrrWPdSCNoRjibxaHIPTVTPIdvfgIWYYwz6wDUR/V/YS6MtLu5RUiqErB3zs+ScYsYVDqQiezp4cXi3Wi26jwXqUwFD9SgOuVvEexjMyfT1jbPMN7tP1oVkEG8mREI728N6UidvjT+LjgflOtBl20UIzdZW9ivU6HVYOFZE93fJY9WmvqlReeqAAOECyq04m8Ij64Zy9MFt8g9Z5WOEVsS3cgj8Ny2IAjJpANHbyZwNduGs4MKv7nUfFk0OpKoorERaZVwogHReXWJMieHGl1+LWBFs4GEEXLLefd134Hl+WVbPjuPQehfhxW5C/e/4BHf3PXMvxefA2Gdrcy4Tnd19Jp8qiCptz2RZCNPP3VV9CsBaA9ITBCANhZ4GeKDgxvPIe7FydTzLOMUL6LD9qxL2V4lJ/M76pP9L0odzjrocpLHSKYdicnfDdgVYYLXhrBjuLDG6lDGGeWras0A2JK0js3IvAe7mIBB2Qx2+AVnuDhwbMwXJ01ZKQLsD6zKjElnscEMiZD+0qrWvAA9zQfSgUBooCEM1zls9wqIBwX9hCzK/tdZNjnxp4RGtnv0NQr5/UYaJqVJFVNO85VOCJCbP93D9C6K5K9Zfh7LCz45P9gjAxki7AULTK/k+pDvcNLHrimIriurZSIrYiTlam2oEB7yzWThSTUR3NN+aHNwGdYBKFrs5aFOnB09hLIhr/UVXETc33R2t8ZX+7IL0G0bpSm27cQeNxx2YSmb3o6toKSGvKIz9eqr/K6HCjqi+XMCPnshRfjjavYBdqT5h2t1rFVRT/U4dMCTapA+eOmZMwFYRjLLreZbHInt2BYZWG7xfl9HVN/LrxUezSBmE3RjqNDqSeUx6EdQv4m
 UH7GdJEX
 texHcJzP6IKUg8obp3g/Eed9pNIA7IaiNsUBIC/2m9QA3M+aMYJ7u1i8N060cgyziz82W13vlJU/VyYltk2ebomZRJS+e81XG/H372EeLvmcNGR22alMcAhGAYP3y7UEEqdtFrCrnqMZ724n2kmAa+rKMdAWYaZaN4vQo0VOhryaFGHaVjRk17u6O9loNblmdL/kzJTkgEcrNkXYk8BBjVIRmwspSUBbMr8OUD2+igI32n2/KYpRXqLwkGIYWxH+srwsq+A/W2bSr2bkjjWv6mmH/6lntRioDsermD9O/BNJSR/fkFH+q9IGVPuJqbjax6Zllku7n7kvPVHIWi1oZAu6SWF0DWyfCw6zn0pt+bKSHi/vOJmoTmyLcF1lippV6C6uNExAVAiHwD7aZJgN1rtZQp/TC4tkHoEQUozidIhj+JcP/DWIO60hJOjgO13DW79CrfDtyKsaXDl6gvFVN9WzrPIGh+IVkcGKxj1F5GW84GC2RSpeNrkfOZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 11:37=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/30/26 01:19, Shakeel Butt wrote:
> > On Thu, Oct 29, 2026 at 01:41:57PM -0700, Joanne Koong wrote:
> >> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_loc=
k
> >> once per batch, but they update the node and memcg lruvec stats for
> >> every folio in the batch while holding the lock. Only the LRU lists an=
d
> >> the memcg lru_zone_size need lru_lock. Updating the stats while holdin=
g
> >> the lru_lock is unnecessary, and they make up a large part of the
> >> critical section, as seen in [1] where a change that added just a few
> >> instructions to the memcg stat update path cost about 2% throughput
> >> because the LRU stat updates run under lru_lock, and the overhead went
> >> away once they were moved outside of the lock.
> >>
> >> With many threads faulting and freeing memory in a single memcg, about
> >> half of all cycles are spent waiting for lru_lock, and the hold time o=
f
> >> the lru_lock directly limits throughput. A perf profile with 80 thread=
s
> >> faulting in and freeing shmem in a single memcg shows 52.8% of all
> >> cycles spent spinning on lru_lock, split evenly between
> >> folio_batch_move_lru() and folios_put_refs(). About 25% of the time
> >> spent holding lru_lock in those two paths goes to the LRU stat updates=
,
> >> mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and the
> >> per-cpu counters. The stat updates are only 0.7% of all cycles, but th=
ey
> >> lengthen the critical section that the other threads are waiting on.
> >>
> >> Accumulate the stat changes per LRU list while holding the lock instea=
d,
> >> and only apply them after dropping the lock (while still inside
> >> the RCU read section that keeps the lruvec's memcg alive). This moves
> >> the stat updates out of the lru_lock critical section and turns the
> >> per-folio updates into at most one update per LRU list per batch.
> >
> > This updating of stats after dropping the lru lock does introduce one b=
ehavior
> > change i.e. race between reparenting on offlining and stats update. I t=
hink it
> > is safe and correct though. Better to document it.
> >
> >>
> >> The batch is attached to the lruvec while lru_lock is held so that the
> >> LRU add/del helpers don't need to pass it down. To keep struct lruvec
> >> from growing, cost_lock is moved into the hole after lru_lock, which
> >> leaves room for the batch pointer in the same cacheline as lru_lock.
> >>
> >> The stats can now lag behind the LRU lists by one batch, which is well
> >> within the per-cpu batching they already have.
> >>
> >> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
> >> CPUs repeatedly faulting in and freeing memory in a single memcg,
> >> average pages per second over 7 freshly created memcgs per run, 2 boot=
s
> >> each:
> >>
> >>                      before    after
> >>   shmem, 20 threads  4.74M     5.47M   (+15%)
> >>   shmem, 80 threads  7.94M    10.33M   (+30%)
> >>   anon,  20 threads  3.04M     3.35M   (+10%)
> >>   anon,  80 threads  3.23M     3.41M   (+5%)
> >>
> >> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a7=
6izMS=3DqGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> >> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >
>
> Thanks, I'm planning on queue this.
>

I'll send out a v3 today that adds the documentation Shakeel suggested
about the race between reparenting on offlining and stats update.

Thanks,
Joanne

