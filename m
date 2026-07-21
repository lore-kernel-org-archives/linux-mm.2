Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD39C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347076B008C; Tue, 21 Jul 2026 14:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E796B0092; Tue, 21 Jul 2026 14:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7B06B0093; Tue, 21 Jul 2026 14:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D20006B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:28:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65DBCA0271
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:28:12 +0000 (UTC)
X-FDA: 85013618424.10.E404F44
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73D95140010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:28:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbnjvQ1M;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784658490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCOgBuJBdugLyqdqIa/3Y0VnqVqc4uDFkyLYhFb/R/8=;
	b=P0yh9vgP/wJPruOyg9DaPtn9DrGMze08re5gSFVwxTkKJD+Rnc5y0rYI5XvsOhSPYvov1P
	dIrdbbll6wY9CoCcC/wxOJYHgTbIsIBkfrPnHBI3NcCEE2vEVzEMvMXYrbEepi/rpxug5h
	PkMpI5qTqAYn1thPcjlTnsIfb7VaojQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbnjvQ1M;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784658490;
	b=l51Ru6nWQxTDXTHPIv0+xUD8H2z7KEUdCWYppkHpEFladSxDRC07NkrJP+Hhd2Nf0gPT9k
	az9w8dpjJvhIeXKBs2FQqYXMdsFMa57dgKzSelfhVn/SO/zTEaGVyCmplNiKo1SPJucwJH
	vJer6Fw8eGBHkDVNjoZ/AQewTCqgdVg=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49553515a8bso38075765e9.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:28:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784658489; cv=none;
        d=google.com; s=arc-20260327;
        b=rjonmM9L8Xoo8sxWeOd61QhcFu5l6RTlYz/wA4QuceZtP+BoHWZRYqeKbEfV2Vc/Ci
         UxoDSnA7VMO1+4W8JgiTzJ/dN2fr+4LiRYINpyDX9i9b4ldtG3eaYATD+mMOHfxX6jzQ
         mZgKZ1HXhmUTphBJDcn+UajbwjCZFhGD87m/dWue5vAtkZaMKdshaUQHdpZh4UvUtdBe
         nFIIKw3LAzoGuJXf3Xy/xEctTQLUmPJcGQkpWc6lEMkHCw2S4RHhPglvViXz0A9fiZos
         Nc8CpY4ACtILYGzzKT1GFI7J23HgY1A174MGGa1HDvdAycDZZRiATZUr4Ccd659qaKj7
         lbzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zCOgBuJBdugLyqdqIa/3Y0VnqVqc4uDFkyLYhFb/R/8=;
        fh=lr9H3SeGkShLJ9a/dvOarujqer4bEo9yU8jQ1dVpz9A=;
        b=fg7Ebv2fD3kpL2s8tqoOh/d94kDvSP/GwRFTPRRL9VrSpkRv+yZJh+tVEOaMnwN5ry
         o5eNib9/RGAlKBV+z/rsPdDGVbZMdwlEIkS+cj/ZoNexvuJi25FbLsmEugVA/I8BqDES
         +kWxevOGvCPBH5eTbi4K0P2tAil8OBkmUX1C6z2b2fyh+s8tQeOBRNDnza+0EQWQ7O6A
         x1AV18PwqXIF7hHWaD1B6nQhSpCNCF+65AotWqF25Gph/eihaVxJBkVw2S/47GvTaGP5
         eTMpqCXYXDfjGu+0jP0byZ+0ipRzb66lJ0pJCOwebwu6FrrbvzjZCq7FN4hpGqDf7J6o
         kvQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784658489; x=1785263289; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zCOgBuJBdugLyqdqIa/3Y0VnqVqc4uDFkyLYhFb/R/8=;
        b=nbnjvQ1MPVTbMQUls1lqK8diP3EHAOw9s81EvB+ANo5Mn8KORafwN4EHP0YokFYDLO
         Nh6PhV7Nq7wkvhE89y5RLVTiT4k0dMbXnIodtjFGlxk439krGwGkLCVF/KEZuFI0kXVd
         eGe7p8/1QEG5yai2TL2aeyWJCBmCk+EapPdyMH1PmpyQHfh71Tvi/DdoHx11kjqTecU3
         S/oh2h3Tqgs9Doe1dG7MQCLwSJ2PGzq7tP1cmLr4nZAIIdBwG4dftbaHwQjI6Iuwf7iw
         3XGr0t8Mad6kR6LbId8GBGw0rackbQyS1IqD+icozzSBjcB6vT5nPnItBwag690wCFDm
         Sl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784658489; x=1785263289;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zCOgBuJBdugLyqdqIa/3Y0VnqVqc4uDFkyLYhFb/R/8=;
        b=CrQzHYLyA0ZAdDAD+OtFvq1nb1TghLXx+FTnr9sDt9hmFycU1Lk71D3Wo3guSaQfIE
         AggBwOGmvGIHirIz1nczJEIJSPeMIfo/03wxYaZ1+L1i0KwbFhUqfc3kikW4vGnKSS3B
         iBPf+WgwpJc3B8go3oipECVuyQ3CBhai8V90QiCcRmw9kD8mwQyiQyVUbONlxdz8Bnxr
         DhE39QirHVbbCV80mHS7A5Vo2ql8tiQVU4CAoetwInYhRF2pJLbvKFbWVs+vEAgP3w3+
         b8LNWTiD1ckzVGIQWscTmt1sDoAzv8yEkPTWkJ3lGGbLEx1mPhqZysAmsVagR+A+34vS
         l0Zg==
X-Forwarded-Encrypted: i=1; AHgh+RrswIAphO7hTMmzCilXslSGmFavFGk8F/OZusYVTT/Dk2vCCTuxV4h6rVnZ1wzsOjz1sSUq/Ge07A==@kvack.org
X-Gm-Message-State: AOJu0Yz5eWjnAZW3T9KHXBCx8yLhTUc6n4LQIzMi3XYwkH1ZuM6IHff6
	gOS5829iRZ+oZS5W7/k2akVm2wQHJn7S7Jhubv9ZNAQ0eJ3OOJrjhhhZevQ7XCz1/MPDKq9NLXt
	owoKkXeZsU1sP/SkoP1oZTYy8CqZHSME=
X-Gm-Gg: AfdE7clV2zlAcrp8g5AjqaILoudcnh4wOzNXAnP95m+HW7VnR34q2lMRljQFab8O6YI
	cGID5C8q7PI76igl8L4erzKXguLNtc/QB6djQdWJqkp7tlVXYmzz3jyGlD2267VFQKOx7Pnb9Dk
	Aau1ZYGPTD8ebuOD67rfXiB9HbN+K2GqPXWX5A3GFyFdMG8zDlKk7JyREUE3q9PI0VmitbKXlRT
	oNd/eKb8DyunqZcoDd8YJCEJ4YhH/sqtNbLvAGKcBSI05L7XVITYMUGRfcueau4S0JcB5dzsGkQ
	P7ZteX+z8LbrLt2a1g==
X-Received: by 2002:a05:600c:3b91:b0:490:c6c2:52 with SMTP id
 5b1f17b1804b1-4954a3d0065mr268942165e9.3.1784658488814; Tue, 21 Jul 2026
 11:28:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
 <alo7tuEKLjA0IZQe@MiWiFi-R3L-srv> <CAKEwX=Pm2=fdPYE6e0o8bO2sazACwGhKCpstii-P-8P2AxWGDQ@mail.gmail.com>
 <al8ohWshSSZ64AtT@MiWiFi-R3L-srv> <CACePvbUBfut0rjfK_4MTGrp09KHSXxtU7neS7O_eLNW8co-DaQ@mail.gmail.com>
In-Reply-To: <CACePvbUBfut0rjfK_4MTGrp09KHSXxtU7neS7O_eLNW8co-DaQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 21 Jul 2026 11:27:57 -0700
X-Gm-Features: AUfX_mz4-feQWKUNvcgmyFVrV6T8D2pHHkQrhgianZo4drxPi6x5RYZAMGgdrbc
Message-ID: <CAKEwX=Mv2gMsZ5FkfmyaNofz5CwhSCipOtWfax1oVTtom+OoQA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 73D95140010
X-Rspam-User: 
X-Stat-Signature: g778yu6w1kgb6y1f31gp1xjfxap6edbe
X-Rspamd-Server: rspam04
X-HE-Tag: 1784658490-61884
X-HE-Meta: U2FsdGVkX1/q4w3TslkrM02MT6gIYxZGxvZY6rjXtGwZdmh3c+A/87JulM3d0mjV9d/bP1INfQcpHkH+Mn/yR/bXG/ZIYGyoQ234sdbKZGDxNmdOi6roDchMynooZJOLrU8d+l4+Jme/G0F3yPyMdkVhvy/9sNqaFqb5Q5Bqg5HdpDA7caEfz9P/UQEai5A0ZuDuki/I6jmhrmcT4lrUdJdzlJcpVB7bbN7uX3/3yCcnFH0KT4/uu3/Sy6HH40+xg3wfIyhQy8JQhq28ok8LCSzJJH6dAl5Yp4+3s1nQzQLKsTeMe/p/HuaTD5h8M/mEgfx43CCg2Y8np+qFNqDNPoUCfZZzPpnbZB5yr90uCFIJjxvNaCODtf0xQ/GHD34GdNdqUXp/xSZ0wDZbQ3SEeAiTDimP3S8wO9uhWx9CpWhi5J0ih3g2w88imn6d7logcCq9RMerb37o5dIfvU6wdv2bfbjhXj1sF0gyoVpwTLxDvYdgaL0i/M+8gLUh4nzQEMCcQqTbgYqshAXkglVtrwKC8lBmh9XITquixTgFfP/pyj0uDehUCLoJygudyJkbHF4+eW8QwtK4sewbq6D8LoD4nIwUAbJD+J6gVcU09zs8+3ymxA3L1QkPrbAtvFRw1QtopKCZAftRtu0RX+U33/Ueb41XeNRdnMf/UMEIEwwLgY69wcQzBBKaCTc0O6l4abCpAUrFGlzj8wqF/3r2LR4s/cTPQ7DAlvAgEEvBzemXUFwUMNC4ZL/G6hC22SWEc94us9PHX2vU8iNf55TRGK+FUPRqkzQXDHDKHYJRUrislgwZyXR3nPN/Z9dRkI1sUVOHCckHdLrfZ6PaGnSVw8FdJiu3CbSPZXqJ5+Jo2FE7Ago+UMvbWQT6q9sdu3zUorrjG7baalFCRulPX7HmIORxATh8+Hgi3T65mHoyuUL6TW7jrm8tIsNDgXU9YrLZcpQnn1WCtdWz0zllllQ
 jEhk/Tv7
 fMhi/E3Ed/28xlpom/YxIlx+3yLrR2zILpDFyYwXNfaD2Cb9xjf7fA1S1yVohUkE7jv1Q5g29zmXq7x7idZCK9OrQ+co3/TxdxBG6bWIU63oZqU58AYwlZNHuQFCuMVyMpEed86I403Rf+mc9FoxwFhLqjRv1jXB7Dxuntwv2rzuCgiU+oTYnOATbPgF0OmNZ2ZdaUfp/FZXb3ZEDf+Pr7ZSPQ6W6B7MOOz+X1e222d5Xn+wt51jE89ebcXWZV0IuI6rJyB+2Rrl+ETY3pzWWE3qnpbvk++PY0pfDzNxpqCS7wEjHoD2D+xtqisjm/W9yVAaKH3xuFGUl0ouw3L02gR1AKFKG5MPQN5kR+92rHaDIwi2ci1z8V3XSHPAmSkAroCURtEF1Lz+qJ1VzXkXQSNBJEWHlfRDmVjqRckIsz7vCiqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 11:03=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:

I'm writing a full response to Baoquan, but there are a couple points
I'd like to point out first, to save everyone's from the confusion
going forward :)

>
> On Tue, Jul 21, 2026 at 1:06=E2=80=AFAM Baoquan He <baoquan.he@linux.dev>=
 wrote:
> >
> > On 07/17/26 at 09:02am, Nhat Pham wrote:
> > > On Fri, Jul 17, 2026 at 7:27=E2=80=AFAM Baoquan He <baoquan.he@linux.=
dev> wrote:
> > > >
> > > > On 07/16/26 at 09:49am, Nhat Pham wrote:
> > > >
> > > > Thanks for the thoughtful reply and the very constructive proposal.
> > > > Your suggestion about moving forward in small, incremental steps in
> > > > last mail is really appealing =E2=80=94 I think that's the right wa=
y to make
> > > > progress on this. I need a little time to think it through more
> > > > carefully before giving you a proper response. Will get back to you
> > > > soon.
> > >
> > > Yeah let me know what you think. I'm planning to send out v3 with som=
e
> > > more cleanups and fixes, but I'm happy to hear what you and Chris
> > > wants to make it as useful as possible for everyone.
> >> I agree with that. The current VS patch is a great improvement over
> the previous version of VS. However it places the cluster info and
> swap table in different locations when accessing swap table-related
> information. The code path requires different locks as well, the
> xarray needs to take the xa lock.  This kind of dual-personality issue
> will make reasoning harder. Keeping the swap table in the same place
> is simpler in my mind.
>
> The other issue I want to add is that, using xarray as a swap
> allocator is unverified. It has no size limit which is one of its
> claimed advantages, but also one of its drawbacks. Because it does not
> have swap_full() concept. It will never do the normal if swap_full()
> fail to allocate, let's do swap cache related. That code path cannot
> trigger because the xarray has no size limit.

1. If the page is reclaimable, reclaim path will take care of swap cache to=
o.

2. For non-physical swap users, we actually eagerly attempt to get rid
of the swap space (and swap cache) once the final reference is
dropped. Zswap load invalidates the compressed copy, so there's not a
lot of value in caching. I'm not sure if you missed this or not.


> There are other considerations as well. It works fine if VS only wants
> to allocate 4K swap entries. If VS later wants to go into the mthp
> swap entry allocation. I don't think xarray has similar considerations
> as the current swap allocator regarding fragment lists, etc. The
> xarray isn't designed to be used that way, at least not in the common
> usage situation.  You are likely running into your xarray allocation
> specific issue.

I don't understand what you're asking here. mTHP swap allocation
already works with my RFC.

The xarray maps to 512 entry cluster, not individual swap slots. Once
you get a cluster (either from a partial cluster or a new cluster from
the xarray), allocation of mTHP works exactly the same as physical
swap allocator.

>
> The xarray allocator also has a fragmentation issue where not all
> memory released from the xarray returns to the system as free pages.
> Using kvmalloc grow it will wait some unused cluster info. But let's
> put it into perspective: cluster info is shared by 512 swap entries.
> Each swap entry is 4K. So the memory used by swap cluster is pretty
> small. Much smaller than 1 byte per swap entry. We can also modify the
> cluster info array, making it an array of pointers. Then the waste
> will be even smaller (if unused). At the cost of one more pointer per
> swap_cluster_info. We can consider all this later, not at this current
> stage.

The xarray also maps each index to a cluster too.

>
> > 4. Writeback and rmap as follow-up
>
> I agree that adding cluster info growth as the first step. I recall
> Kairui has an RFC patch series to implement virtual entry lookup
> (still using the xarray). I think the combination of growth and
> indirection lookup should provide most of what VS depends on from the
> core swap point of view.

That is *exactly* what my RFC is using. Did you see the first patch? I
put Co-developed-by Kairui for a reason.

