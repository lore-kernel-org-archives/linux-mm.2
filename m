Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4991ACD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7006B04BF; Mon,  1 Jun 2026 23:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877B56B04C9; Mon,  1 Jun 2026 23:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766A16B04CD; Mon,  1 Jun 2026 23:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 654B96B04BF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:25:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A7E991B1E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:25:14 +0000 (UTC)
X-FDA: 84833531748.15.9FA6503
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 030DD40007
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:25:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VGBvhhDL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fam29w7BM7SQN1712sc63hB2u0C0AKH1MvJ73Y+Wc24=;
	b=Wl4ToWxW5+dlDc/uC8bxzRnEGNT5AmR5pNluQCp1IQBhIpMinh4j5QNdePcdUIbYoSi146
	7QMRuiwp4AZbhZVkRlT7vpycx2mUjV6zvzpJ6DZuoIRuB9uiJD3g2q+ysghFfpFArvVlx0
	N0yV9mIB/LaJYcrq2lFLa9t0y7cgZX8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VGBvhhDL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780370712;
	b=jIiyhKhhoSBH7LEPI+3URPCPVqgeqS1dqyP9bJLFMdnJ1apiK4gZmLgaaSb9vyntBTQ069
	taKYwgUTeawM2ZWViC1xQi1U9AM2fX2qh5Dqw1P/GgBcVTCimPu3y+VRkO0D7orxDvryAc
	rcMjL9aCN/PcLdplHnstTMIe/bSJj5w=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bed4f2f0898so222773166b.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:25:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780370710; cv=none;
        d=google.com; s=arc-20240605;
        b=C8mjRMOj9k+pKmAbWeHkbuBak8Ia34i7wTS0kX2KyaFPrwZw7lZlEf8i5zKeEWkQ/N
         1marQpE8UCkMjLwNXhioO5/cIZ/aB9EfJCBwxrtZcqkvRaY2j+4iwtn+GjcllwS7NVkt
         6fOIgc2y+W8mvWLL2Tfv4mespGAIgSnhNQAndkKBI0mLik8ZKmrZOeJjD9L4quxGISsC
         frZmvbRs1D5NAk1O6WvH1tAJEOcaShA0+v2NdqJMQGjHrCbmoyYSuC+vcvVSQ3hm49eN
         4S4S+4TBtCDTSrh3y0rgPFD17UTwJZf3y/Sy9SudCQBuydubJ/oyEu4vbQwjDhBF94Hn
         69ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fam29w7BM7SQN1712sc63hB2u0C0AKH1MvJ73Y+Wc24=;
        fh=aOL4fUmzZYMIno5CN13DT7vArNgqixdwCzC/8cdkpMY=;
        b=ccNIxHQstXLuXry/sAUPG/ADjSvxPD1ke55yev5AdrIEKwz8+8E24hm8JlhtfgcWgz
         lw1NaBUTk8GMYnBGJJqPpfNPfABr11cS69ewWent5XoJ1ElcXH7xhDMfvInKO2QCvV1t
         E0c+3uMveHzHiNWR1XXN5pSQOdDl8mMZexlDNrSyYjDlKaOqHj+yGlbGkSaG6qt95Owr
         yKrtqhyZP65/LRG3g1xyRaCm3B+xPPugXIDCqz1TFQukkRFRmSLzQKMyY4smnrkXOl3q
         aCrTdj5jMIK3jKWWNfCgUE3LjZn1oeqQBWMBrBDr26U6c3824rydDJEjFkPbxmVzJebU
         e7oQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780370710; x=1780975510; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fam29w7BM7SQN1712sc63hB2u0C0AKH1MvJ73Y+Wc24=;
        b=VGBvhhDLWBJIPDL2xHZtrbrdcBIBy3zSIsVQRtXoUkJE6TvmQdAqXa5E4cLsumX7dW
         EAexSogP/3TfYm71sSlIMVC3QUM51wsEYfOT+EQlqPTcZ3j7pHPPeJP3kQdB6ni9DXZK
         6dYm6qCdXdioXTJ29NayxyqRywApRJUQYJAlVcv01Aj/mt7Yk3Bwr6ekxZ/x+dcoCusf
         KSBxw4uNRHYvV0jclk5TfbxZoJT2ZqdR4eCBn50Quho7+U6YZc3MaJxw0XDqsxYQaTWo
         M5x3lUBaGTopLCcyaW3beXwtVdMe/t8zvTNF8koMBC7lYLFOwFhMLejQvHD1822CUXys
         jJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370710; x=1780975510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fam29w7BM7SQN1712sc63hB2u0C0AKH1MvJ73Y+Wc24=;
        b=AYOGDkkmiSfkAsoV9kG5gayL9zS36ghZ7owZUs6Nlk/o9FPM8QQ4D4CkU0XBfgYulZ
         fsbx+UeGqhKUv85kb8Or4Z2PdbfKSXLC7yh9gWvbGzDvKx4vMJ8rLaRQOZtpIiyo9C7b
         FMltu1WpzsB8SBZhLbLhXqfSqYhCkZO4zQq2C7gkUJyWWTZZxBUudo73Lnw4upqcc9PA
         BFjDggGaVE2y1/s96AZKWZi3Mdvzrj3c8zBfzhMibeQ02dXkahawZM0W+GidThI+R7mm
         SFDsV0DQBBaxV6n/jf/nn2mmMQ6GrtODiMaMt//cxmGYWUMZFCul98+puMtZtDkhZ8wg
         jJIA==
X-Forwarded-Encrypted: i=1; AFNElJ/yMpWzfDKdwOsVCUdBr3AvLhYGDaJN+pVp04jZQvD0ZeBzXhtyVdcaXqy0Z1BOTpOK5+xXwKR8KQ==@kvack.org
X-Gm-Message-State: AOJu0YwvxHBl+svaNvEExzqFZoXg+k9tATOwwBZPBRd4i1k7rROeLvaR
	Q5uupQ5ixQO0ETPJC9sYUn3I6tacHV+lY7OZnK5nntQ3llOz8LpItriMrYyPmzDgaDSmVpzCYKZ
	oiKnkXM6jcK77eh1nr6dUlUlmemXQTVM=
X-Gm-Gg: Acq92OG4Cdc+v0gdOc68IFm0/2lW7VHhRRizxQT/J5WOLnJSJVy63UmFbI69gBvGNDP
	Z3tdUZmuEWo8zhQOnI6KDSDcxb/Y77kTMozRPFoiEAnkS/MksB+2zbD4lbjXQGqGj+iXtr/Bg3f
	phsa7RVk7hJPqGmuVwG5d0t7l3seyFJvJZXx5E2qoDwD/osW3EjByLcEc4dA2LEGwY3KgaqiM5l
	L/HOWdLIqVQwSnP8THjmRCKz+SvV2aYz2ri/jAVDYtXOnWgpN4xT8+FCPrxgdaBBo5KVuF2X/Mj
	lCnZE5CNFwhwLxhmZ2vnjp3TDKin58uF3PaQspm7eoXQi9Zx+Q==
X-Received: by 2002:a17:907:b582:b0:bec:b4e3:e930 with SMTP id
 a640c23a62f3a-becb4e3ea0amr390918166b.12.1780370710180; Mon, 01 Jun 2026
 20:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
 <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
 <CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com> <CAKEwX=PmwzaJhfjBrho3+kQ8HXFUC0WiegQrsguBc-_pmn5bSA@mail.gmail.com>
In-Reply-To: <CAKEwX=PmwzaJhfjBrho3+kQ8HXFUC0WiegQrsguBc-_pmn5bSA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Jun 2026 11:24:32 +0800
X-Gm-Features: AVHnY4LgB4_R0tkXYgUuuSpKzumTcKeWUZY8_XjCCaRJMf8h2HTxkfNiEQ137jc
Message-ID: <CAMgjq7D4XsAD4NGDL7FC2kaYAQAP8PDJdn4bpzGZwXYtjEpJ6w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 030DD40007
X-Stat-Signature: ibsc8xgkynypebhbhoabmtxj7386h71j
X-HE-Tag: 1780370711-997831
X-HE-Meta: U2FsdGVkX1/NWb8u6Qh3cMsC1qsK9v1EgDrS7HlojmYBuZUBUvEg4g3f5nKxBTVY9xTk7b9gig+G1guG/LKg3j80syYbmxyiZW2TUV+t9WvKg2peg51eD/1LOOTIAYsMlAsajGw2RbENxUe0Sdsms6qnc/USwQdTtEHNvTue6P91FvAADQUoKsGkio8vD7OQbO0v0HNYMj33+6wNSbfD7faHS2GhFxVhqEyPZ36NHdC/ClcxyxMo3WAByu29IhYStmygA9BnFkLXaVdzUlvAxwObXqiBerU7gJAWBV0L+baYBO1qoZHoQCorFKSIYF+xM9aeFl+ziqpSiekeAGbNBWtq7ohTQ+BvIu3OTPG4CM/yILsF3xn/9xmkImfYI42onotPYE8VRdDDLLlqMS8ym4M+4P2qHLkrIw4RbXreOqUDD07x8n2uB0EwcGi4utVwziKMocAJqPACX5bOCcJRGFbjiKekJbztzI2oTnqJHbFPqyTCKmRgNGKHaJEkkEty9KPr9csusNs//RAyv1SvSGx7v/P9TGIZDOrLmZlDlwezXWkuGvdUvbZijofaxXlTOVk7NmiIP4WRSppbwawb7FvUHfTNUT1K1I40VWriP248fHvbsYt3YQI5CQz1Ai/dN2XlY/NIZAXD9mBXd/6s3W74+wLwbGmEghs70uec9j6vBHerVsn2ciWKwT9/g3b5w3WgCPPplndplOaQm2jw+SgsVApQIyvGlDsod1Ce+e5W9Sg8efmc1gqf3C/kAtbHh6WHBTVi8IEy5+BnU7Th5nxOc0eo5xLS7/a/YjfWT5cxfoR36ysz6qAnuOl2ThQ/aD4hp1l0Jin6AHmlhSGsb8Rs+zvUJ11AzTh5+1fRQ9iScT5W2igCbXPG1nIuRCzcHi+wuwiBdhTBnfqlJqSikozVSumYFC3bNp6TYdiT8LF/7oTOoVMKeoXcIJw6G89lTdJoL+jhXHhJDaCav0q
 jzy1oLLg
 TOu/YZMPEejRTr9vQ78I1JDiuVu+3x/t52ZcaLRdvRrmUxnhuWtk/ZtR+5Uyifbzn8egr0kyJnH9eZqWZWBIxXBesXoKpETT+73ljMZFvzeprFGjuBTh+qgi+M3rJ/u4b6UDs2C8lm0Reoj0PPX2gBX5p5wSt/KgCZZv39WPBZH+gc17ZgbPiAmRpK0B92t8QaOai9z7fa8jveuH1Pl2qnaRf5+s0YE+3xPDniQNQ7nVBYgGd3POsXw18y4m3+JxsO061Y+21vXHK8WNPiJt9wowAshovgRfupAbI6pc96QiD+njfeiRuPjrIDovAAR1OPkc5tXuTFrljgBsthj5maFfQWvbV4D5zfNBb1P8S3duYfpvQhjKVr654qs2n0YZpSmAtsWGGpAZokcExXenmeccfeJhheoKZYpXjkH3m29UT0D18lJFZhPrIUygFqzMbSfloJsHSLfYnZnxT/1WL/RhNJJcgHxp0oy1lHQmT8UDZFFPlHYhMaDQRuGzArAdx/OTnY0R6Bv6Fa8eSV0+CdNeJSiSE2rc5BENO1poWZOoyz7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 2:06=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Mon, Jun 1, 2026 at 10:45=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Mon, Jun 1, 2026 at 11:57=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > Are you suggesting we merge the virtual table with main swap table?
> > >
> > > Man, I'd love to do this. There is a problem though - we have a case
> > > where we occupy both backing physical swap AND swap cache. Do you
> > > think we can fit both the physical swap slot handle and the swap cach=
e
> > > PFN into the same slot in virtual table? Maybe with some expanding...=
?
> >
> > I don't really get why we would need to do that? If you put the PFN
> > info in the virtual / upper layer, then the count info, locking, and
> > all swap IO synchronization (via folio lock), dup (current protected
> > by ci lock / folio lock), and allocation (folio_alloc_swap), are all
> > handled in this layer.
> >
> > The physical / lower layer will just hold a reverse entry on
> > folio_realloc_swap, or no entry at all (no physical layer used, zswap,
> > or after swap allocation but before IO) right?
> >
> > Looking up the actual folio from the physical layer will be a bit
> > slower since it needs to resolve the reverse entry, but the only place
> > we need to do that is things like migrate, compaction (none of them
> > exist yet) which seems totally fine?
>
> All of this is correct, but consider swaping in a vswap entry backed
> by pswap. There are cases where you still want to maintain the pswap
> slots around backing vswap entry, while having the swap cache folio as
> well.
>
> For e.g, at swap in time, we add the folio into the swap cache. First
> of all, we need to hold on to the physical swap slot for IO step. But
> even after IO succeeds, there are cases where you would still like to
> keep physical swap slots around (for e.g, to avoid swapping out again
> if the folio is only speculatively fetched).

A reverse entry is enough to hold the physical swap, just like how the
current hibernation works with a fake shadow, you don't need a PFN
just for holding that.

>
> So you have to make sure we have space for both the physical swap
> slot, and the swap cache folio's PFN at the same time for each vswap
> entry. So we still need the vtable extension (well maybe the other
> approach I mentioned could work, but I'm not 100% sure).

Right, vtable extension is fine, there is no redundant data. I just
mean you don't need to set the PFN twice (for vswap & pswap). So
simply reusing the PFN format in the vswap layer and solving
everything there should be enough.

> > Thanks. Not too complicated, actually our internal kernel
> > implementation still using si->percpu cluster, and use a counter for
> > the rotation and each order have a counter :P, it's a bit ugly but
> > works fine. It still serves pretty well just like the global percpu
> > cluster, YoungJun's previous per ci percpu cluster also still provides
> > the fast path, many ways to do that.
>
> Sounds like something that should be upstreamed? ;)

I'd love to :), there is a lot of work going on as you can see and
people seem to have many different proposals about this so I didn't
prioritize it. I'll try as things settle down.

> > > >
> > > > For patch 2, a few routines like vswap_can_swapin_thp seems not
> > > > needed or should be moved to __swap_cache_alloc? VSWAP_FOLIO is
> > > > same as swap cache folio check, which is already covered. Same for
> > > > zero checking, and VSWAP_NONE which is same as swap count check
> > > > I think. That way we not only save a lot of code, we also no
> > > > longer need to treat vswap specially.
> > >
> > > Unfortunately, I think a lot of this complexity is still needed. Vswa=
p
> > > adds a new layer, which means new complications :)
> > >
> > > For instance, I think you still need vswap_can_swapin_thp. It
> > > basically enforces that the backend must be something
> > > swap_read_folio() can handle. That means:
> > >
> > > 1. No zswap.
> > >
> > > 2. No mixed backend.
> >
> > If mixed backend means phys vs zero vs zswap, then we already have
> > part of that covered with the current swap cache except for the phys
> > part (zswap part seems very doable with fujunjie's work).
> > swap_cache_alloc_folio will ensure there is no mixed zerobit, it can
> > be easily extended to ensure there is no mixed zswap as well
> > (according to what I've learned from fujunjie's code). Similar logic
> > for phys detection I think.
>
> Yeah it's basically generalizing that check, and handle the case where
> we can have indirection.
>
> I mean I can open-code it, but it has to be there :) And I figure it
> might be useful to check this opportunistically (at swap_pte_batch,
> even if it's not guaranteed to be correct down the line) before we
> even attempt to allocate a large folio etc. to avoid large folio
> allocation.

Right, but swap_cache_alloc_folio with orders=3D<large order> won't
attempt a large allocation if the batch check fails, so that's fine.

> > > Basically:
> > >
> > > 1. For vswap entry, not backed by phys swap: record swap memcg, hold
> > > reference to pin the memcg, but not charging towards swap.current.
> >
> > Maybe you don't need to record memcg here since folio->memcg already
> > have that info?
> >
> > I previously had a patch:
> > https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-7-104795d198=
15@tencent.com/
> >
> > The defers the recording of memcg, the behavior is almost identical to
> > before, but charging & recording should be cleaner and you don't need
> > to record memcg at allocation time hence maybe reduce the possibility
> > of pinning a memcg. I didn't include that in P4 just to reduce LOC,
> > maybe can be resent or included.
>
> That works-ish when the folio is sitll in swap cache, but say if it's
> vswap backed by zswap (and the swap cache folio has been reclaimed),
> you need a place to store the memcg, no?

"Backed by zswap" means the actual swapout already happened, which is
the case where we always have to record the memcg info because the
folio is gone, seems still fit in the model.

> Just seems cleaner to centralize this info at vswap layer when it is
> presented, for now anyway, rather than juggling this on a per-backend
> basis.

Zswap charge could be merged with vswap I think but pswap we just
discussed that we might want to charge it differently? And actually
vswap charge is still quite different from zswap charge if you want to
make vswap infinitely large? I think we can figure out this part as we
progress; it's not a major problem at this point.

