Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3FFE606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qBocoT1H
Received: by kanga.kvack.org (Postfix)
	id BF5596B05B1; Thu, 26 Nov 2026 21:55:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5A16B05B2; Thu, 26 Nov 2026 21:55:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A941D6B05B3; Thu, 26 Nov 2026 21:55:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0846B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:55:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 555691A0157
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:55:12 +0000 (UTC)
X-FDA: 85479382464.18.712DB73
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A197A0012
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:55:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qBocoT1H;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795748110;
	b=KWLNVDgWmMT0m6oh5YYqaEr0HoJRWJ8/HKGOEdmgNkjqlGqx0N5EacN8jhEydoUZ0RttJ7
	NDdmBzbJf+3uXQAtDLfidy265NEHHPwS11EPMPgbU7wUczz1446yXApv635mgmuNQdvSJ2
	uMwCwDAlkbLLqGwpQfY2UAmedoeMzG4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795748110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3hflK/w9trNoSZS5EWvDWp/lpUVGxr8L2pSGjpSId0=;
	b=vclPzcBzFSCb+5d/V11JTbi08mNVutwi97pTWr+SKQgjfXH/bzbnLWeq+pLxPvufZwsUZy
	n8beKRejaYSQL5egBE9NUmvaSZ3aE5GSvKSoz/ZWoMlku0gZHbHQtSKw/rqFUBLqW+0kQm
	dVqA15msKQdS5TrqCEOFGNkp/lfM3pY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qBocoT1H;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b894d9a075so8438069a12.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:55:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795748109; cv=none;
        d=google.com; s=arc-20260327;
        b=igRFE8Bx5ef0aP5H5Eo5WTZWE75jyBTLSFRcR5shaBpjkMdVqBkeuSUR76N9I6aDb0
         lruVS0l0XJ/cMZF1gBCyAh79mOf4UzWO+KCxyQ70VaPQuE3fIuypycSkKZY+YjYZjatb
         hebtBdLlFTxt8Ky4gilhjFk1Ek0pBqVvYthvcfEVn+/AlHEDZrnkDjIHrbJ4vOCQJ0hm
         f/BT/yHHJPyHtL8UFPdj+l71b3OJKhZzKXA8vgnADORPAbg4DMBmBx6hB//Ph0lF6Odb
         7fGrXeoEMk13FROZaZNeTpwC8R1OLyqpr6MdxFFjG3+bPNhOxR2GfxotQmy1tyFP3kaU
         g2dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v3hflK/w9trNoSZS5EWvDWp/lpUVGxr8L2pSGjpSId0=;
        fh=ETxyNyDINm/EDeFo2XGqKnv0UQpgErHeOAmzB7YA2ow=;
        b=ckrIjrHSRviTB4+WMGfWgtBUyLagFKyaL1D7FBqhBibwX9CwvPKB5xglHn18J74dJ6
         ixiF4tysVjXvSMmvKTo0X3DIbZkEwRuLt1YcxfhMwq7xiTIzsNx8b9zI672VtPLWym76
         5bwzG2+d8aIADVOUl8jNR/OSdjMCFANXAnRvd3vGRK/s0GpMlYwlQJNhTGUC7y8RdJ3v
         DwMY2E6UZe8gOce7+w1rFbT7M+VvoLZpbj3xc6m9cUn459aPRstr15xGhUIyYx+qjgB0
         VMS2jKQXkTr3I/kusgOCPeU1Lh5mQwt8MpG0OsS4Ehw0IHBJeyo27Eqz1aLipgzd9IDP
         nfqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795748109; x=1796352909; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v3hflK/w9trNoSZS5EWvDWp/lpUVGxr8L2pSGjpSId0=;
        b=qBocoT1HomIVWTO0pBzYDtKG9dMgjdHU7gAf2LDeISUNCvYrL0xxGDsWJZ58QfZQ0G
         ya450wUi6f/EMk3tIc1dqVBFiGnSpGksYAE7Txg865u+vrvsLTA6LoZ9J1nxvDBIC3XP
         7IZcThgQoLHbxlzix2S4dzTA+EBBUYtRM0/GORLtuTnk+C+4Z4aASyrzkszYWHFcdRAv
         k6sKTC03Ua5AWGm++Y/wGr9r7ImemrcvCjuEGe+qCJ1ItuYtdE2Tn/M81PnaCUZFK2uT
         enMr1TYToti2/93cfb/c0n1UCm3gtZ3baiUzV7Gr9Y1Y2tYbvRaCUst6yrLNIDQDkg6i
         RjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795748109; x=1796352909;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v3hflK/w9trNoSZS5EWvDWp/lpUVGxr8L2pSGjpSId0=;
        b=VbOKOzg0v/wlGYuPC/QfTVXmVMSWIiNhZztiQRwIcOB/l5r37Lcl5t5vnlLkxyIlZs
         ge8b7XuxNl5Mvez3RdmA046ZqjOO73SAZuftKQo5mCJkOfpdYrEA2kRAsxBcECzjeqPC
         M/c4BYX+7QHOqQwffECc5TgkcDq/ubFQgIBxtPQkKiwot5kSzLKkegSZmb/vk6bPz0NP
         HfiRoisiasQ/B36Tq6n5ukx42phiHmQB9x2jg6gdS1YkBxyg0N5AcpDQP3+E6Sd/azwx
         hcan+lhj38Y5/26Jfdz8H69lUJVD1+dqdF5LwKANLKVeNNDQ3FacGANWg5p1PwuNIiBD
         Edlg==
X-Gm-Message-State: APuU4Z++yXgn+kKKpLQQ21eLTb10ay1zLN92Ygl/8PaTnvAgSypjh5DK
	FzAe2miVP8tk0GPXwd3lY090IEgXhlvQr5iPSdR2gBvnXETNkHYsmoz/OWMvNglE3vjY8p+xq2e
	3YG48/r2De5te6zp4KNmLVUSSVJpyU8Y=
X-Gm-Gg: AZFdTZe4groLi71hvHp68rf3JGJ17pLvDFweO9FAnQncTdmJlpDVXlMdvOkEmyEXCi3
	NAMl9CfNU3jfcpOTP4HvpD0cp0agQ8TBdhmPlXc6EIftS8q4iW3QDrRFtTtOchhX2LHnBulY6CW
	aVnr2EFMviB0Qi8xX3pMtu7FUk7cCP+7+4253MMzJYWfvSFqShsNdmK9PaL/muNgLc5RL9yEC/r
	h7YjaYON0MYP7yKqs0QzKX0acfop2b83euQ59soThvIYO2vKWgn6ISKcaXy//neTjdyLUBcKOhK
	cJtr6IU6quxUfJHa4/dO69eclCpZxUeFGtftL5QQSTQWPFfrGBTmRVXP9A063K9u6fFU+zeOWdo
	1Bf9nl7LGplcOA/z5Z9zz8pq+LRFdP9IoM+7jd2ZIMrx81Ad8lF1Id84l+WBKtJ9JEZQTIw==
X-Received: by 2002:aa7:d287:0:b0:6b8:818d:520c with SMTP id
 4fb4d7f45d1cf-6ba37c7ba50mr12205368a12.5.1795748108667; Thu, 26 Nov 2026
 18:55:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261101160427.85701-1-maxmuzaf@gmail.com> <179502478384.194898.8139869410612997037.streamfolio@tychen.cc>
 <av3vMMhFbiaop7zA@KASONG-MC4> <20261119082441.196139-1-hi@tychen.cc> <20261121205953.30737-1-maxmuzaf@gmail.com>
In-Reply-To: <20261121205953.30737-1-maxmuzaf@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 27 Nov 2026 10:54:31 +0800
X-Gm-Features: Aa3M54oZAY7wIG0YhxI5gfZ4onlcVlgmd6HzWuctq8VM5P9-R9yNP-MHxvDvKrM
Message-ID: <CAMgjq7DDUHrHEXiGDnPn6+keL6VxWWMabAr-BRrNM_bwsKPZnQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/mglru: MADV_RANDOM page cache never ages and
 thrashes the oldest generation
To: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: linux-mm@kvack.org, Tianyi Chen <hi@tychen.cc>, 
	Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Yu Zhao <yuzhao@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6A197A0012
X-Stat-Signature: 7zngn19nk163aft8zxs8j116168bn85r
X-Rspam-User:
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795748110-546058
X-HE-Meta: U2FsdGVkX1/S+hIVJtrr7fk/LCJjP9oph+RDsnSDvUHccbw7CdxfwRie2sy2OSsFazsObF1CVPCrMLaUd9MUbJNhW8wBF1jcStLAHeF/Wq4NimO2YTeszoyJzazZmtrXmjEV88lG1kVIZlTA/oHHi5Xfn/wbeiiXejjSQubF9jcWoZIZEuEiUB+Ur6rR/Re8Hm/rOPMixtW/BB1GT0KQRXjBMnZaOmr5ERjrwwPqjcbpsStDjCh6/2sHnpthhaP8g2H8iamlfFzz3JV1vujG581WkWv36SOCpY7hIm9G+kO0uTyiCSPWNUMF442qvXFJiwCTFvH4Joet30m9/NY/zK5EAauQRKwTS08JJ0QephQrNQwtKg5QN0l/UZu2KQq0iy+17QHi6qdRl8Ibet29kt0BaaxrxLDVthVN2xWPXKW2aXVU8wn2JXDD3MoDmO4jitGfJg6u6yefNYOlycPAxVOpq809TkfhARNsgixgMUFKYwcuUeE44ym7fCnsdLUADp5AHntIbsJAAeJY2n0HFWmgav8Qb1+7mpq7WFgHq+6XwUNpIPI/JVxZv1qfCPUaQdisCZO+iIqt0xI485zDvgT870ys8p+c/Q/83m9cnP+YNWMR7k9y10KBYsqK/71XzHwtWkOvIutxPqAgYm2zcAyLUtSdL2wV9uRiX0Ee8uh5ZVr195vhGE3fTdrvv+ghtddGKc/IS3Z+HpLZCOqBOp91rqd5vcB3HZeQQGF+OSu9IVnfq13e1IR1o4p5CcqLArE0f+pxZV2N3So6OjyB7Rs8bKhKaG0v8YjMv9/j8pXzvOY3/0wpQ7jlR4wy8tPGLsZhXFQSqIggP1V22fX9PXhBuJ4+58c0PI751+npSfG780URvPd5NlN60Ec4b/cYYnh77qDHG300Qezqn4u8OkJsTOC5BVVFXKNJdJlG1yROpLUUofgYBBxgP8gi+vfnpG8YUYcdPOqyxrRD0nO
 BfNT536+
 Vu/UGmIjpGq1WZY8Adh0quaQ5yS2tDjEaCl/q1Cwyo6hRxEqKM5uv8dzOZGtDaM3myPoZHiML1vwGNXqyf0WR2fGnaNGaoWxnBp7itEQvsg3oT4oWCcxELBqoIIqjnBtxZBq6JW/yQ36ViQOKwn25MiJDZ/i1nHhf7HbYXH4gJlVLH9SDkXUtxPx9uxXQGpL7dMQg6vFKDw2Ml9vDhoZycurKtscfmQ+uL1awLrVezrOlKPZdZDa5Ve8rAUWOuqShW1pRP5YT3WLUJ58o6lkSlg5z0dTfW8CJx7PNizM7eA4MBR/fNsqVX2c7w4SsK0pCjSA8xb6zSbeOKAszabadfB3vXaQyVRObSjyLNsq+p4CNlf0zg8uJZAj2k7H9dWn06NOAr7f4hvFz25mXZJe6ez7OaBBgjgdxcbgzjHp+oCDL+AKXXLYRkdNGnbOCBYeV1GobwPRRwBSW80K985+GK0RrzeNe+BgMRUPrnnoNSpDnXTgbVUH0jCzU5j2MkBEwobPbtBx8PceOy6Tp3JHkBecdzVBTaM8GdAv6CS/C5CQhIjoOWeng2D8GE3Fk9MuvNj7hwrdhJXA9AgY33uTgNEHRvdwQ5pvpnCJISgR9GeNYXOA0y7x5b1Cm54JQGR5s/euohH1nvVg/QszSRlhnl5vgS+srgwHhixNiw6I/WAvfSpXdlF28ZXFQLMWL5iB2Zh3j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 5:00=E2=80=AFAM Maxim Muzafarov <maxmuzaf@gmail.com=
> wrote:
>
> Hi Tianyi, Kairui,
>
> Sorry for the late reply. There was a lot of new information for me
> to digest.
>
> I've checked the reproducer you provided. It tests a slightly
> different scenario from the one I mentioned in my first email.
> However, I managed to adapt it [1] to my case and tested everything
> with the same setup (x86-64 VM), and I also reproduced your results.
>
> The key difference [1] is that I added two new knobs:
> - SCAN_PASSES (default 1, your value), how many times each scan page
>   is touched
> - SCAN_MB (default 96, your value), the cold scan size in MiB
>
> This is important because 300 MiB scan forces reclaim to reach the
> pages during the first pass, which clears their accessed bits and
> evicts some of them. The second pass then gives the scan pages a
> second visible access. The reproducer from my first email also reads
> the cold data twice (--loops=3D2).
>
> So the idea is to get the cold data promoted to newer generations
> and watch whether the workload recovers while the oldest generation
> is thrashing.
>
> With a 300 MiB scan and 2 passes, neither MGLRU nor MGLRU-FG5 can
> recover. FG5 handles the 96 MiB scans and the 300 MiB single pass
> scan.
>
> The Patch
> ---------
>
> Kairui,

Hi Maxim, thanks for looking into this.

I reproduced your cases on latest FG (7.4.0-rc3, 1 GiB
memcg, x86-64). Base FG fails 4/5 seeds: early p50 280-344 ms,
late p50 364-375 ms, .vec 9-19 MiB, scan 288 MiB resident.

Refautl ditance below seems fix the problem just fine as we
expected.

>
> On Mon, Nov 02, 2026 at 02:02:33AM +0800, Kairui Song wrote:
> > This code snip:
> > + /* Set refault as active. */
> > + if (distance < total / 2) {
> > + folio_set_active(folio);
> [...]
> > That way, even a random folio will be put to the head directly instead
> > of keep thrasing on tail. And placing on head or newer gen will
> > trigger aging.
>
> As I understand it, the refault distance series will break this loop
> on tail. However, will the loop survive when the hot random set
> is much bigger than half of memory? E.g. when its refault
> distances exceed total / 2 and refaults land in the oldest
> generation again? Should we in this case use the aging logic from
> this patch as a fallback?

Yes, that's expected when the hot random set is much larger than memory:
`distance >=3D tail` keeps part of it in the oldest generation, and that is
intentional (MRU-like). It's not part of your case, but it is a real future
case.

> Anyway I'd be happy to test the refault distance implementation as
> part of this work when it's ready.
>
> I also rebased the patch onto mm-new (25fee5b1762b) [2] and on top
> of the MGLRU-FG5 branch [3]. The patch applies unchanged to both.
>
> Please, let me know if I need to send v2 of the patch to this thread.

Let's wait a bit: the per-generation counter could trigger unnecessary agin=
g.
If the active working set is well protected in the newer generations,
constant eviction of rarely used folios should not trigger aging; otherwise
it may push the working set out of memory and cause a regression.

> The full results are in the gist [5].

Thanks! I also tested the refault distance design below, and it looks good:

    distance =3D lru_distance(lruvec, token, LRU_GEN_EVICT_BITS,
                lru_gen_bucket_order[type]);
    tail =3D lru_gen_tail_size(lruvec, type);    /* oldest MIN_NR_GENS */

    if (distance < tail) {
        /* It would still be resident if it had been kept. */
        folio_set_active(folio);
        __folio_set_lru_refs(folio, min(refs, LRU_REFS_PROTECTED));
    }

I also swept the promotion threshold: tail, total/2, and total/4 all fix
this case; gating on refs does not (refs are 0 for MADV_RANDOM).

Results (300 MiB / 2 passes, 1 GiB memcg; base/RD 5 seeds, aging patch 2):

                          early p50    late p50    .vec late
Base FG                   280-344 ms   364-375 ms  9-19 MiB
FG + RD                   5.1-5.4 ms   2.7-2.9 ms  117.2 MiB
Your patch                7-51 ms      2.9-4.3 ms  117.2 MiB

And your tests covered the other parts too, so I think FG + RD is the right
approach. I'll keep this case covered and Cc you on update.

