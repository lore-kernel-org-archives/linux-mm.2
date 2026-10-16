Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABABCCF2C2
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 18:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A177F6B008A; Fri, 16 Oct 2026 14:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9526B0092; Fri, 16 Oct 2026 14:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF4C6B0095; Fri, 16 Oct 2026 14:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59A136B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:24:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA92AA81F5
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:24:03 +0000 (UTC)
X-FDA: 85329313566.14.3EF6585
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 046F81A0010
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:24:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=befaHj76;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792175042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w75Itn64ZChdQT8oH7KrgM0cKGKRcQXZsqbEawl0SYY=;
	b=5Sr0RqD7gilsiBi732wdvDR8xcDSai2QkQCUyVy7Mukg9UyU8PRDnB6nZxLNWs9bxzxG1T
	LkCLW9MY/I09SxbA3p39wpa8EW1Lrau//emMsmW5CIfc6o6saWkxnbrFmf6XjgaJjRWpW0
	eBcDFEwyC0Kkhfz533A0P4sDAJtumq8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792175042;
	b=AFR7IFYvGN3MJBtQGsF+7tqOkPfNUPG1ZuLjdnsLhF9xqfXFYVQgxk6Nrx4AGZF3oXnjtB
	vdZ+Fpb6MCcIeiRUTw7ipZM0R7Nlu8VEQGMWDKMwHcpEvYig/JMk61EV8gQ4JoqzzSS9Z8
	fNCdwNnjeGhsRPhRTTM8NFfyPUj3jGI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=befaHj76;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c350db5a761so32867166b.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:24:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792175040; cv=none;
        d=google.com; s=arc-20260327;
        b=sLwIoyYpwxupQzqnzhUGo9oxiGyOKbcKouRXJldxex5X1Bk6a3mFe9B4DcEbyNY90b
         cGumuQlOj6fFdH2fhyo6sQmlAw86ShI4bSzYl7cWbWhzlV3mxyJAchcZy1jTpK7x45Yk
         fsb4eRJGbyOIu0NNYLjjX9HTWG6rQ4eKxNz0kxC5tyNcIEA+zmw5ldXMX07vQUGKGB3o
         uWjE+sn7Rxnag+Yb53+H65jS6upC6bTTU3DDGLMx1Asv+Yse3l3s2L/BiOAm+DdDdMMd
         4SUZh7ByMgqn7r2GaMHR11Zm7ER9I3aP+uknfEesDs5uwy75nek/FKHKz7m/VP6SZ3M1
         nZMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w75Itn64ZChdQT8oH7KrgM0cKGKRcQXZsqbEawl0SYY=;
        fh=pYWVRDA79s4loiPF82nyEGOto5jww/yicL5o4JtV36s=;
        b=J9dySa9E568czURCd2wt2EWVSNkB1Kpsh86oegM7vXr7i1ZrANqKkE/TBN5yAurCF0
         eQ1h54yG3Dv3IH7+Iq61Ov/MJeFi1OhPm2jC/hMDRpEFg7QXDYJrnPwZhZzZgOyqT26s
         K2r0JRNbzpgyg6fqWbtmZMM23RhEGg/H8a1Bhm6jru0/aa91TRXXELZnKpjIsNbrXzrk
         SN586z/nvqlNsvRaNILOlIeKXFN2pi/2YDkHbqSJYhizSmUiAc/9hnY0hEuX+WPBGXtX
         WauuZebsBjgcqBZ3/hnezw+SlySbSL2HjhaX8JHchikbW1uWKO17C46+99GLhjMqqjX7
         6eZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792175040; x=1792779840; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w75Itn64ZChdQT8oH7KrgM0cKGKRcQXZsqbEawl0SYY=;
        b=befaHj767/3Ne9DNWMWQT6ss+SmvMgZNO9SNZwkQkBT71t1oZ22FB3mAAHfaoCiVZZ
         Dl8oL05anKnlZE7pssHqZfHuSgxcNXKj/yNUJySaPuglR81PCj6PZVq4ObDqZBQzpMzx
         i2N85Nf+imlOhvNbBsrDJJEDn0iLAWWib9NZ5N3JWUctd3PQ+yppWUZMGtl/mRtcZAg3
         wremKWGErG7PYmh7q3/DQ+YDUwIDHGPNKOHcFCp7Yo+1FRo6Zjx+Z/SjlCWOoN8LsnAh
         wQu8skFxgY5IqE28JRnz82E6duQ8kCwgqecFZcZXsh7tomcWGf3RrHlEsn6Sh1nqIY1P
         Fdug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792175040; x=1792779840;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w75Itn64ZChdQT8oH7KrgM0cKGKRcQXZsqbEawl0SYY=;
        b=Iqh32Va8TdOM7C+dtdGgDPv1RTY16PkbnGvYRYfc7y5CYUyRpHvIj9RHKmj/WGFXbQ
         v9TMflnYPIvErPDhJd+TsMMGdQQSPgrWDlkXFP12DBKd0Gi6j7CyKzzbvD2cfr4HAMHd
         uJmpF31YSIfUP/p5J+prJ89DTN9epg8PQRwlRTbz46CjIgBwtDqxRgOaMWeHYpmp0MeR
         fX9pMxp6pYRsvYsd99mWwzqdjKNtPlHHh6G5T7m/nxkeXOl9wPWUoFh+XteUqXViAtYd
         vvKiw/XCT+LyxfsdszUU1v6zk4uLBMg0KiudoHuzsHMTfbE03ChFeGwHrRIONpSYAHVj
         rNoA==
X-Gm-Message-State: AFq9FYK6MV4SxQJ8iiC7v+hkeujxicgLpAIbSIOFOH9ShbWenZJyckQ3
	CRkFElQFBbrcs4nyf7zDMPG7HDCub/RQU+HlEbruObslsbaHJU7CnLi+8BIAWd3/HY5VXUCM9H9
	85Umts37NFCg5YRKIC/mP2JabwNdeAg0=
X-Gm-Gg: AYBFou0CSyuzVjVljHOAVwbD6SNRnvZUaGl2QJM1Q1j15HsXTMrSHmlWPooTgtPoUTq
	RWfB6QAU33X+ynb+RdYRM6xYQV2+/iKGUQJ0bQ6gNnR1d2KEffcfFl2xJ1Vak4YuB2K9KxkmG+g
	VQmGrw+OEg/bYaPuZeszGmIciUlo2mo59LyjKk/CN/FCrkUrm+rQ97eNWF5FxCRGSMrWyTthL3w
	yrBFNIWcCWcFmISI7ALogdA6TRJAL/rd2GBUZGm5rySSQ80pc0rcQKbOWkGwBbM2dRM3Iu5Fq8J
	XOjKe/M22XHiywtc+n37zKDphUvx8GcXpf7BA3AvhopXG3cUQu6L4cJ3QAeWiS2Mwvw5i+W9AbU
	9OYc6KnkLA5Kb
X-Received: by 2002:a17:907:d093:b0:c3e:f39b:2296 with SMTP id
 a640c23a62f3a-c419ef28605mr49454866b.31.1792175040404; Fri, 16 Oct 2026
 11:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <CAMgjq7D50X47JFsTnF2-jYGv7i-Nd3WhQLK-TJGy4XkhMQU4OQ@mail.gmail.com> <62d17959-d695-4fec-a87b-8eadaaf995a8@linux.dev>
In-Reply-To: <62d17959-d695-4fec-a87b-8eadaaf995a8@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 17 Oct 2026 02:23:23 +0800
X-Gm-Features: AclHuK-zxjRkwCzmw2XhMz0WZw6yQmarZum4XoIWybkkjlf9dokqBMg1hg7DPBI
Message-ID: <CAMgjq7CJ+bwKgwUmCzO9Hr7TrL68bDjgAsLx-4AGuXo6zowh9g@mail.gmail.com>
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: irq3f99usmk9uytnsotg9s85mqi3mfn9
X-Rspam-User: 
X-Rspamd-Queue-Id: 046F81A0010
X-Rspamd-Server: rspam10
X-HE-Tag: 1792175041-84744
X-HE-Meta: U2FsdGVkX1+e3L9LVP44nfSRWbr65TepTFukqnQaXzqfLpVI9RV4aKVXT4SEiAahOQvkbIJJN5TlCTBKdTPuEBxIuIWhYD4oFdcdpAZnj9ZN4MQf91s14hu6J9L0mR1kpsEIReLwAm+j8lkgRfO8me8Omsry1exO8r8qQPgdLxv7L/iTxHt14Llf3nCkpgvE2gQsj9Jb0W13oo+7yLL3OyTQYwZb8yqJ2S4ZEmJB/0Q8LM8tARjiQghMZpZuRdxnz85IZsdyKzDZb4iLzXu4tXkaZLNKHnXADMH/wl8z3rTkVeq5+/00iabYxXbqKjtAtiMdtUS99XaW/Agk8KtEwy1XdNgRi5fPlhblg07ENIboR8wQC9cIHkCLoEWRVqls3GFwBy8VEP2+QwYz/aG4BO9M/AK2NI6AKWe3iClgkctM8KmUOlzhPD5+apIkziHhevF+opegIjxOxcgNTvbzJn7I9uMJu7a313zrQKvQ6jh5+ft6HV+lTIDfqqAmbjsp1njcWppv8nEnV2netivcAeXIc3cCgZ8P+gLnemWVmhoy3vvYo2S6QsNbjePhVUndZjFYg2m5C1Z0Fw+mIajYBm0k6uMijXQtkzFpMWDkTHYqLYoRKkqSEv5IWJdrT4kbXA4TELl+srFi2lqbkcUVkkMr8dCMD1xVI5HhUKheYcpSSxDyTlLkDVsHTMYnOcI2smovY1jpyfoI7mWRSmhKG45l+bO7TTM0fQGPzoPynW3Al1VubL4ffa5Q13uXkKIknmvw0uwabGdtGFChCYMH5jjEt+QAR7t0bnhYZsoJN0ikvmhhww+e2ntUFCGQtYBCoPYyYtN6kp/c+NxouNgu09gD3rndZK+dj6h4wTpgor+WrUFOd7WtE7wc6zNO7DHsnIYDADBAc+jCzy9SNg7Mcze5HGX58zKcQ9zcO0srk9iA1ugBlTI/cI4ouxBG1MXEsHdK/9yfJIlFqUGISrw
 Gx6MaEap
 wmGIs/x5TqNuyZmaR9XCM9TkXPE+GzhN0RgWBIXTysIW2behjysG8nikGn0RxzrSs+RdVg2d0ytBcWpCj5mbZCzs3utY0EPWNOPvDNjKTDjr04CC1G9py189U16JO7FYXGxiM8kgLEcNM4C+OJhFf7a2IHgIvWPWO/epgscbYv9kIUWR+QZfC8tbKEUIJjjrXlonPkcq6kYxhe93h7JahN29kzqvFXc1i4XWYTN3lmjEOAA8OLyi+Kr9sgIZj1EKfZPBkV+acYbYdAZvmMEKCVE9OXq8ERWmWrgvpEQuIsUvbtXcSEbUBgMTRCO4QibyBTxb5hWRJGGwgNQGC/8l/rtZ9J/3NWU/WDP/G1Cd0S4p3dYpgCY2oAdHzmOzPSfQuvgB4Hogah7Zh/saEa5ZyKyBppDtVuCIDsDUg8c/bGT5DjLZKYlbLCxcOEHZp+zQLkD1KlR0njVFYYVvKG0zkTQa2wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 4:42=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
>
> On 10/16/26 11:05 AM, Kairui Song wrote:
> > On Wed, Oct 14, 2026 at 5:10=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linu=
x.dev> wrote:
> >> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> >>
> >> On our production hosts we saw swap cache only pages keep growing for =
days:
> >> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
> >> swap slots were held by folios that no process mapped any more, charge=
d
> >> to cgroups whose workloads had long exited. The only way to get them
> >> back was swapoff, and with other services actively swapping on the
> >> same host that is not an option.
> > Hi, thanks for the report.
> >
> >> Such a slot has swap count 0 and an unmapped folio pinned in the swap
> >> cache, left there after a process exited or did MADV_DONTNEED. No page
> >> table holds its swap entry any more, so nothing comes back for the
> >> slot; LRU reclaim drops it eventually, and the allocator only reclaims
> >> such slots once swap is half full. The growth stopped exactly there:
> >> at 50% of the device, where vm_swap_full() becomes true.
> > Hmm, I think this indicates a much cleaner fix is available.
> > vm_swap_full is inherited from the old allocator, we can instead just
> > let the allocator reclaim the slot if the slot have a count of 0 and
> > ignore vm_swap_full at that point.
> >
> > Will this work? (Just a minimal implementation for reference, will be
> > even better if we can avoid the overhead).
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index c3288910b3e3..94670fe82f31 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -212,6 +212,9 @@ static int __try_to_reclaim_swap(struct
> > swap_info_struct *si,
> >          nr_pages =3D folio_nr_pages(folio);
> >          ret =3D -nr_pages;
> >
> > +       if (folio_mapped(folio) && !vm_swap_full())
> > +               goto out;
> > +
> >          /*
> >           * We hold a folio lock here. We have to use trylock for
> >           * avoiding deadlock. This is a special case and you should
> > @@ -903,8 +906,6 @@ static bool cluster_scan_range(struct swap_info_str=
uct *si,
> >                  if (swp_tb_is_null(swp_tb))
> >                          continue;
> >                  if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp=
_tb)) {
> > -                       if (!vm_swap_full())
> > -                               return false;
> >                          *need_reclaim =3D true;
> >                          continue;
> >                  }
> >
> Hi Kairui,
>
> I tried it on our box (224 CPUs, 931 GiB swap partition). It doesn't
> help there: after 100 rounds of the reproducer the leftover is 291 GB
> with it and 309 GB without, and both stop growing at the same place,
> 488 GB, half of the device:
>
> # cat /proc/swaps
> Filename                Type        Size        Used Priority
> /dev/nvme1n1p1                          partition    976561148
> 489006260    -1
>
> # cat /proc/meminfo | grep Swap
> SwapCached:     489006260 kB
> SwapTotal:      976561148 kB
> SwapFree:       487554888 kB
>
> cluster_alloc_swap_entry() picks clusters from nonfull_clusters first,
> then free_clusters; it looks at frag_clusters only when both are empty,
> and at full_clusters only when vm_swap_full(). A cluster gets onto
> nonfull_clusters in partial_free_cluster(), that is when
> __swap_cluster_free_entries() frees a slot in it; after
> alloc_swap_scan_cluster() has used it, relocate_cluster() moves it to
> frag or full.
>
> A leftover slot has count 0 and a folio, so __swap_cluster_free_entries()
> never runs for it. Once the live slots of a cluster are gone, nothing
> calls partial_free_cluster() on it again, it stays on frag or full, and
> cluster_alloc_swap_entry() doesn't pick it until the device is half
> full. That is what the swap table looked like after the run:
>
> list      clusters   leftover slots
> FULL        106415       54484480   (all 512 slots leftover)
> FRAG         44822       18471614
> NONFULL          1              0
>
> Making cluster_alloc_swap_entry() revisit those clusters means changing
> the list policy.
>
>
>
> > Or, from the LRU's side, put swap readahead folios at the tail. I'm
> > actually trying to do that and it's not very easily doable at the
> > moment but will soon be easy to do.
>
>
> That helps the RAM side under pressure but doesn't give the slots
> back.
>
>
> >> Options considered:
> >>
> >> 1. Fix it on the readahead side: after the read, check the swap count
> >>     and free the slot. Covers the lock, not writeback, and the
> >>     asynchronous read path unlocks in the bio completion where the slo=
t
> >>     cannot be freed. Two places to patch, neither clean.
> > In fact, readahead checks the count before starts the read. It should
> > prevent some of the problems but seems not enough.
>
>
> Right, the count is still 1 at that point. The zap drops it to 0 while
> the read is in flight, after the folio is already in the swap cache.
>
>
> > And another idea, what if we just add dropbehind flag or rotate the
> > folio, if folio_try_lock failed in __try_to_reclaim_swap?
>
>
> dropbehind would work for readahead and writeback if the read
> completion honoured it too; today only folio_end_writeback() does, for
> zswap writeback folios, and swap_writeback_dropbehind_folio() expects
> the folio off the LRU. It still misses other lock holders (migration,
> split, ...). Rotating only helps under memory pressure.

Right.. But I think it will be much better to avoid such folios from
hunging in the swap cache in the first place instead of having a
worker to reclaim them. I'm not strongly against adding a reclaimer if
other approaches are too difficult at this point though.

