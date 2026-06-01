Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6DACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2321B6B045B; Mon,  1 Jun 2026 12:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEA76B045D; Mon,  1 Jun 2026 12:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6636B045E; Mon,  1 Jun 2026 12:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8A9A6B045B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:22:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43472A0700
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:22:26 +0000 (UTC)
X-FDA: 84831861492.09.37BA757
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id A36571C000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:22:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tFv2Dums;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIJLBXqk7z3zxdRemjxiJJ4oIzR7i1a+F8x00il1qyw=;
	b=crvoigAp0QYCEI9ruU/SR+qEKshrDxzn9hsHPwJInh9PuaeQNWtGC686IofK/vTR/gU/he
	G9YVCv8tm32PQ0dpEh7GfDswSOU4BASgBnfN9HTT4W4m3XYcmHVlvCbKZXUjSbFjf2p1ya
	kr4xKlwFHPRVp5G2FbQ31EeESzx8j4k=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tFv2Dums;
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780330943;
	b=f1vuX+3AUXxtlNOUbVS8IBLRqeyjYZn6U65bSE0HRd4DlBuo4CBac0OiHoGn34oymoydo3
	qozrM1w+bnolB0ZCEMqDTsfhDmpmc3I3A0gt5X57kr7Se0Vbph8ftPdWVNWSCflaqhPeKj
	25n73suCZrnFy91VVKkPRtq5QuMazBM=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45eea68dd6fso2229813f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:22:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780330942; cv=none;
        d=google.com; s=arc-20240605;
        b=ROKFnSVir82CKKi5bW0ijArJsSE+yCA/fxXYtNQW9E2KIFPmAVz8+oTJTeaYi10xAA
         ++6Mh49vyyO4JJhO3R/SLXHXC9NmhR3IuOinfd2JYZ1wS0SRMMiAnW1q2LNn2uXphtTr
         be+AeoBoeQ9T2R2tgElJLMTXJmGnP4tDzPvVi/doBqlAQnAeeGg4ADOPmMYQ+iFVhe+n
         VJvkNV1uCVbGZYqVlfa7eajHvr9Z7Xo2BuxxnmwBbbPQKVNKihPm8I6xYLrqd1S0xLWU
         RbBU0zzyVPS+5X9GOrUPo3WANp3o1aBfRAa8VjeeI5CxPhy3GQSsprhzUKzmjVHk3jNn
         Q5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NIJLBXqk7z3zxdRemjxiJJ4oIzR7i1a+F8x00il1qyw=;
        fh=REfTAF9Izv8QNaJ4TGikc/FW01WhX9uxZyK5TQCNz2Q=;
        b=lrrEN2paRjjU+gbxyDInNkfsToKjTDnsTIeTOYBPJMc15WcvGVDUAVVGL8qOCTwsZR
         Cp+yWZ2vddWXYDx3PAAChl2mksFwLlR8z64XDMNbkkmekor/Tp3TBu/nVClFvoB4lrjt
         H9j8f2Lx2lJvuvSECEzkUVcO79ioNQJPzu2lSHkUA2abzkLBiNbVvhJrrxKRjKXrwURw
         gVGv/Sv8cYPyRWwlYW7JFhvrmLiwxjuaNvwQ/9J3LKQcxIZj8BLDzjwDfB75W7H6N+Ni
         pdbjNkuajquEZn9dyt1ovYb9BLntXdvZVBQ1J4vY0YgilFu2dSHYa+z4QQrKHH2bn+5G
         CNZw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780330942; x=1780935742; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIJLBXqk7z3zxdRemjxiJJ4oIzR7i1a+F8x00il1qyw=;
        b=tFv2DumsBm2qE7jfMCe5YoQ6D6/OgH6Gm7QEtNmMc4IKz2CLdAq52qgSPTrSWzACen
         oKPPdlN5WLFSLPT+C5QbyO1gjZ3wb+/WCKPD/uyq7ShXFSXHk6a2XMuhX5L+A7RI0VSj
         g1722Z5sznb2n9A4Jpd4zC619ni9cMWhTzjH0jo32mMw3XZzP1cvPJ88+B2BvWtea/Kv
         UySYloe1Ri6v2vP/MP4MpOYZkMUH46IlGWSPRC7MTKXIjHfzgY+OEeQ7VqpYZAxVTlOA
         ITJJB01IE5r1IIWv68MLnqB6o69eknPVN0uRSmvLKAqFoXnMQ18EqZr3T+qWX0hGpRnZ
         vEgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780330942; x=1780935742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NIJLBXqk7z3zxdRemjxiJJ4oIzR7i1a+F8x00il1qyw=;
        b=GjrF+A8XpoOF46pn9ocuh1ProsQgLpTyGnyJjMTBtZ+kluB97qQ7enlcskHcEcuFGK
         IkceRVdCDqPnZ5vG4KG0O0geZ30OY3mkD2Lw+CP1BNZ5QWbdaPx6/WEZPiYh6E4yHuZk
         6aRDnT15N+qrJTkfi5DK8M2ViCJy87mG2l71mLY94SvkMNxc7x4hxKB4ZBU0ZHBG7HoX
         rblhvmaCuqBkuYAY9eu/c6uTZ8yndu6311dbdHT23H3SaONU4RinZ9erYDTsj8RZN4+q
         Qg+RFkfLeeCjBBKNc8DrWVWH7cJ9CQXPfKKYeB4oAsufcpViTxnddNqwBDcuBuJBNwIb
         tIVA==
X-Forwarded-Encrypted: i=1; AFNElJ/wNpXcQ/jNYqwJ82vW0fNSE3ePnZqLD2Q4kXv451rspx/hfw+Xvb5f2OZBy4RIxo5kh5YZjLRXpw==@kvack.org
X-Gm-Message-State: AOJu0YydDjEsfeHmZlbrAQJOwpznCutviWcra/ZyExmd5nONeiXtOKTN
	usONrt29Y6biGbug8OZ43Zcepjzbd+Pg2mOIw1IUHbXkGirWdTe7w9/wVLZbtaB5qWUJxSyPLqN
	6HtOzCcAOI2XyKfLLqwKxN5I1t+JBS1g=
X-Gm-Gg: Acq92OH5b+amNOnA+TopWA5bB4fRogvdlKYi/Gv/azl0sm7AGfj5+0dxiTNH5iNkTLY
	WYtmT8OqcZ0CaDPJ3JJx/VOMI9Z+bp1mI3STf8vE9JvH2FJfI6CWhx0q1WaqpxN5F+8x1BOTPka
	4xccF0wmnzkR6d9V/eGPSXw2bJ4mMOSOPnv2aYAwVW/PIvTjYCtCQJsSQfEyKMTunST0Iu+ftvI
	4ki8gYxzVj1elFxMiKxGV8YxIcqnJ92Jj4jLsepQcBb/i7IESL8QuTxEY1ZPW0JvP8K7Xlojt2Y
	tUyxeUyXmumAJmZkmyUeTncCEhlgEHAhRxjTmSbN+rZG+nNadw==
X-Received: by 2002:a05:6000:4606:b0:45e:da57:be33 with SMTP id
 ffacd0b85a97d-45ef6b7fc88mr21958786f8f.23.1780330941755; Mon, 01 Jun 2026
 09:22:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
 <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
In-Reply-To: <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 1 Jun 2026 09:22:09 -0700
X-Gm-Features: AVHnY4JTa-fR_5tUyRZOpBI2CAX77bPy73iuDZGeYtyu2utS9mSBpebHo1xGb-U
Message-ID: <CAKEwX=NNNf0KCZC0ph7VRW0gjnbXd4W5NKEaHM4XzPdN03Ek3A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A36571C000C
X-Stat-Signature: bor6fp5pxbpw36ahzkkuq6dxsgxqrma6
X-Rspam-User: 
X-HE-Tag: 1780330943-353624
X-HE-Meta: U2FsdGVkX1+u1axazX/ktLvffqElbvLM7oZxvJLuViWEiIgSVG+pTixDcmc5J9TrV+QIT5L3dlTGIVepxdRY6OGu8FQB7W7HeC0HVfQvoaqeOUNeBWWc5F/LjKslu3cA/7CfBwWRro6rvL/5V+912jM4AlekYwhR4Kjb+NxzEzOO/Sj+vTFXM4Jo+ok0w1qSK0t5jWuj2oeAUakKH+nF0AB1tJGZAupZGeBl/8Hzv3z2yfrf1n8a+E07vRXzzQWFWv4DoHngUlZm8Pmj3FW9smxY83XIDOuz5utMlPzlz3rdz/RsPHgCwMDjv/zJaBf5Y3l6gCpIx6MSIoGlhoAL083D4tab6y+SzOOrnXmFnfulsBr0z+uUrZiQIQjiCIk+WnijuJMSynpR3Pf4iviPA9N3xT2ldxT/Z1wK1S2dqG4QXOhZ19+yq0OfUDW5gr9EE+IZv3pzor2MaRmog0SXH41O+m5bqnM0QOpP9B20FzRhucuEPQ81Oc3R9xAQtacNMVpFaP2Xy825stclcf+gmRykhsiPTjvOB0lZ0QB5lc3s7oSYmfkWUkkFLkhTt4n8Q3lOxwy+K9Rh9LD2Mh3OhLNXtg6Ccv7LWqmgAz4DdYSdi4DRFrFzL3E1mFwI1lJIe6ps3cJwI5aHnj/32LBUp/MwdVV2Y9yG6FkJPxGCrntkbZ6PoBLDRSh8Ehv0+vy+Eh3pDUIZDYWThnFRC80EIsvMYTsS4ssSDX0YR9IkyhENblbsEqbzi+Jp9cyRZz0jQWQ3O1ttYIHPVCKk0ux40WRBkpZfNfupcmMevAhskmlAbr/6tGPHT9pfkm+PQySBJOeL535Uam6UAKXc5k3HtjWyELqkWzzSd3/L5t03I2D5ORGUkwYIYnRALbTm3dxOMBBImiP5Tz2lT4wizuCz4MkllGj7PPwNyAl4VQjWdyUtGe8WIpODVEksnw4Os+y6xpveD2PocV12SuDY/KH
 rAYF0CZX
 lRd12VnJH2IkScaAZNMzFSWb8XRNqHHZGSrhLZ6PKc6g9g+Akj47QCbi4bm3azoc0JpozLH09adrLG/XrcsEh2UShi5sKoY70o7/th4qqqEcGD73+KBhXaD+TMLuGzZ4pg1v48D3EmCZ4LsI9kkouPDu/VvgB3gtY9KRPn6OprGuZ1wELnPT+MX0JqVwfw793PA/Qo/kHM8j6dATeDHWb8ZW1NP8B1PAsheNElJlzSMOXrCr4Q9AU48GjkeVWSBp2P+j8pq4CkfWQO19BzhpcIthBGKPjqNq9Bqby/G4cAoeUY1+jd5v9MJUJZJm/MuLhyM0ex68YzktDnpPCMr9XKO/kntScAsyDuWxKhzS6yldnmWurgHP3nGYoB9CKSbuiyJw8Fbwn3Nqzpu0HZD8P4m/I4oGefJNjOn9TnlVlijoUOtAi5rQrMnNSJE0L+PhvWykGHKUBGJIe1emzPPNcjqSpjd55w6akab37epCCB8n7+x1sDP73vCwM0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Mon, Jun 1, 2026 at 12:34=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Thu, May 28, 2026 at 02:29:24PM +0800, Nhat Pham wrote:
> > > Based on: mm-unstable @ 444fc9435e57 + swap-table phase IV v5 [2].
> > >
> > > I manually adapted Kairui's ghost device implementation (from [4])
> > > for my vswap device. I've credited him as Co-developed-by on Patch I
> > > since a substantial portion of the dynamic-cluster infrastructure is
> > > his (I did propose the idea of using xarray/radix tree for dynamic
> > > swap clusters allocation and management though :P).
> > >
> > > >From here on out, for simplicity, I will refer to swap table phase I=
V
> > > as "P4", and the older v6 virtual swap space implementation as "v6".
> > >
> >
> > ...
> >
> > >
> > > This series reimplements the virtual swap space concept (see [1])
> > > on top of Kairui Song's swap table infrastructure, on top of [2]
> > > and in accordance with his proposal in [3]. The proposal's idea
> > > is interesting, so I decided to give it a shot myself. I'm still not
> > > 100% sure that this is bug-proof, but hey, it compiles, and has
> > > not crashed in my simple stress testing :)
> > >
> > > The prototype here is feature-complete relative to the swap-table P4
> > > baseline =E2=80=94 swapout, swapin, freeing, swapoff, zswap writeback=
, zswap
> > > shrinker, memcg charging, and THP swapin all work for
> > > both vswap and direct-physical entries =E2=80=94 and satisfies all th=
ree
> > > requirements above: no backend coupling (zswap/zero entries hold no
> > > physical slot), dynamic swap space (clusters allocated on demand via
> > > xarray, no static provisioning), and efficient backend transfer
> > > (in-place vtable updates, no PTE/rmap walking).
> > >
> > > II. Design
> > >
> > > With vswap, pages are assigned virtual swap entries on a ghost device
> > > with no backing storage. These entries are backed by zswap, zero page=
s,
> > > or (lazily) physical swap slots. Physical backing is allocated only
> > > when needed =E2=80=94 on zswap writeback or reclaim writeout, after t=
he rmap
> > > step.
> > >
> > > Compared to the standalone v6 implementation [1], which introduces a
> > > 24-byte per-entry swap descriptor and its own cluster allocator, this
> > > edition uses swap_table infrastructure, and share a lot of the alloca=
tor
> > > logic. Per-slot metadata is stored in a tag-encoded virtual_table
> > > (atomic_long_t, 8 bytes per slot), and physical clusters store
> > > Pointer-tagged rmap entries in the swap_table for reverse lookup back=
 to
> > > the virtual cluster.
> > >
> > > Here are some data layout diagrams:
> > >
> > >   Case 1: vswap entry (virtualized)
> > >
> > >   PTE                  swap_cluster_info_dynamic
> > >   vswap_entry          +-------------------------+
> > >   (swp_entry_t) ------>| swap_cluster_info (ci)  |
> > >                        | +--------------------+  |
> > >                        | | swap_table         |  |
> > >                        | |   PFN / Shadow     |  |
> > >                        | | memcg_table        |  |
> > >                        | | count,flags,order  |  |
> > >                        | | lock, list         |  |
> > >                        | +--------------------+  |
> > >                        |                         |
> > >                        | virtual_table           |
> > >                        | +--------------------+  |
> > >                        | | NONE               |  |
> > >                        | | PHYS               |  |
> > >                        | | ZERO               |  |
> > >                        | | ZSWAP(entry*)      |  |
> > >                        | | FOLIO(folio*)      |  |
> > >                        | +--------------------+  |
> > >                        +-------------------------+
> > >                               |
> > >                               | PHYS resolves to
> > >                               v
> > >                        PHYSICAL CLUSTER (swap_cluster_info)
> > >                        +--------------------------+
> > >                        | swap_table per-slot:     |
> > >                        |   NULL   - free          |
> > >                        |   PFN    - cached folio  |
> > >                        |   Shadow - swapped out   |
> > >                        |   Pointer- vswap rmap    |
> > >                        |   Bad    - unusable      |
> > >                        |                          |
> > >                        | Vswap-backing slot:      |
> > >                        |   Pointer(C|swp_entry_t) |
> > >                        |     rmap back to vswap   |
> > >                        +--------------------------+
> > >
> > >   Case 2: direct-mapped physical entry (no vswap)
> > >
> > >   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
> > >   phys_entry           +--------------------------+
> > >   (swp_entry_t) ------>| swap_table per-slot:     |
> > >                        |   NULL   - free          |
> > >                        |   PFN    - cached folio  |
> > >                        |   Shadow - swapped out   |
> > >                        |   Bad    - unusable      |
> > >                        +--------------------------+
> > >
> > > struct swap_cluster_info_dynamic {
> > >     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
> > >     unsigned int index;                /* position in xarray */
> > >     struct rcu_head rcu;               /* kfree_rcu deferred free */
> > >     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> > > };
> > >
> > > Each vswap cluster (swap_cluster_info_dynamic) extends the classic
> > > swap_cluster_info struct with a virtual_table array that stores the
> > > backend information for each virtual swap entry in the cluster. Each
> > > entry is tag-encoded in the low 3 bits to indicate backend types:
> > >
> > >   NONE:   |----- 0000 ------|000|  free / unbacked
> > >   PHYS:   |-- (type:5,off:N)|001|  on a physical swapfile (shifted)
> > >   ZERO:   |----- 0000 ------|010|  zero-filled page
> > >   ZSWAP:  |--- zswap_entry* |011|  compressed in zswap
> > >   FOLIO:  |--- folio* ------|100|  in-memory folio
> >
> > Thanks for trying this approach!
>
> Thanks for the suggestions. I hope going forward we have sth concrete
> to tinker with, rather than abstractions :P
>
> >
> > For the format part, PHYS don't need that much bits I think,
> > so by slightly adjust the format vswap device could be share
> > mostly the same format with ordinary device.
> >
> > For example typical modern system don't have a address space larger
> > than 52 bit. (Even with full 64 bits used for addressing, shift it
> > by 12 we get 52). Plus 5 for type, you get 57, so you can have a
> > marker that should work as long as it shorter than 1000000 for PHYS,
> > and shared for all table format since it's not in conflict with
> > anything. You have also use a few extra bits so a single swap space
> > can be 8 times larger than RAM space, and since we can help
> > multiple swap type I think that should be far than enough?
> >
> > Then you have Shadow back at 001, and zero bit in shadow. The only
> > special one is Zswap, which will be 100 now, and that's exactly the
> > reserved pointer format in current swap table format, on seeing
> > si->flags & VSWAP && is_pointer(swp_tb) you know that's zswap :)
>
> Are you suggesting we merge the virtual table with main swap table?
>
> Man, I'd love to do this. There is a problem though - we have a case
> where we occupy both backing physical swap AND swap cache. Do you
> think we can fit both the physical swap slot handle and the swap cache
> PFN into the same slot in virtual table? Maybe with some expanding...?
>
> Another option is we can be a bit smart about it - if a virtual swap
> entry is in swap cache AND occupies physical swap slot, then put the
> folio at the physical swap's table, use folio->swap as the rmap.
>
> (I think you recommend this approach somewhere but for the life of me
> I can't find the reference - apologies if I'm putting words into your
> mouth :))
>
> But this is a bit more complicated - extra care is needed for rmap
> handling at the physical swap layer, and swap cache handling at the
> virtual swap layer. Maybe a follow-up? :)
>
> >
> > Folio / PFN can still be 010 as in the current swap table format.
> >
> > Then everything seems clean and aligned, no more special handling
> > for vswap needed, there are detailed to sort out, but it should work.
> >
> > > - Pointer-tagged swap_table on physical clusters for rmap (physical
> > >   -> virtual) lookup.
> >
> > Or reuse the PHYS format (rename it maybe) since point back to vswap
> > is also pointing to a si.
>
> Noted. I'm just doing the simplest thing right now - working
> prototype. I mean, we have enough bits :)
>
> >
> > > III. Follow-ups:
> > >
> > > In no particular order (and most of which can be done as follow-up
> > > patch series rather than shoving everything in the initial landing):
> > >
> > > - More thorough stress testing is very much needed.
> > >
> > > - Performance benchmarks to make sure I don't accidentally regress
> > >   the vswap-less case, and that the vswap's case performance is
> > >   good. I suspect I will have to port a lot of the
> > >   optimizations I implemented in v6 over here - some of the
> > >   inefficiencies are inherent in any swap virtualization, and
> > >   would require the same fix (for e.g the MRU cluster caching
> > >   for faster cluster lookup - see [8] and [9]).
> >
> > This could be imporved by per-si percpu cluster. Both YoungJun's
> > tiering and Baoquan's previous swap ops mentioned this is needed,
> > and now vswap also need that. If the vswap is also a si, then it will
> > make use of this too.

Oh and the MRU cluster caching I mentioned here is not the allocation
caching. It's the lookup caching, basically to avoid doing the
xa_load() to look up clusters for consecutive swap operations on the
same vswap cluster (which is the common case with vswap). For v6, it
massively reduces this indirection lookup overhead. Performance-wise
it's an absolute winner, just more complexity (because I need to
handle reference counting carefully).

I also just realized we'll induce the indirection overhead on
allocation here too, even if the cached cluster still have slots for
allocation, because we look up the cluster (which is basically free
for static swap device, but not free for vswap devices). Might need to
take care of that to maintain vswap performance (but it will then
diverge from your existing code...).

