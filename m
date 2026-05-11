Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31504CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A0F6B009F; Mon, 11 May 2026 10:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970FA6B00A1; Mon, 11 May 2026 10:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887576B00A2; Mon, 11 May 2026 10:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 781F96B009F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:38:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3007EC037B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:38:09 +0000 (UTC)
X-FDA: 84755393898.20.AD6EC2E
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38664C0019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:38:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="J0xtCaQ/";
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778510287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZiESKaSmHrhzXZAuFxzd9+gmYiqDerEKwxgDPEPT7E=;
	b=zDKJElOl0+B6inpI9PCucrLDwtsj7rtwZChjFHd56XJFLnRd9baOcgzOuQoTQxsbaxo1lY
	E5EZ0JF4EfVR7lDQSM+WMBUEgn68spY4Ii9MKzDLUVcwoYMOKZv338lhXgXv0G1yu56mUD
	U28Qc/iZIJDWtYT/fXQjxB1NUBxHN3o=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="J0xtCaQ/";
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778510287; a=rsa-sha256;
	cv=pass;
	b=U5X6SIA626rvhb6WlJkni0mqlHRV3l6435BRND+6ceMrue88t5fjFEykQKSC5fILEZxJNX
	CbXLoMuhKf0zS1UxoRPAzEhzMTpLOcZMebmF/XMdV4xajOGeLeoX6YI9VLrI0YkI0R34+a
	ovJ9IqilZc6vS2D6dVYLLnPUJa7K46o=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67bce1840f1so6904987a12.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 07:38:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778510286; cv=none;
        d=google.com; s=arc-20240605;
        b=Cs/hIVHlruNPFbVaGu6FFLJHOqzVTNqWNrgo2FFzmX7OAnJJml7H+AjKzDfbBYKTTL
         JiAX6P5MmqS5G7AT+S8cph79uO2sjSdOytFiPgzGhC1ibyN6jKG81tVGsOHlAmp4aMG+
         XnOzg0ynTGuDVeyjzmDOe9rh9Vt6F/Jq9w2Plbza6uLBWFYHWdsXUme+CJKBNSpU0D9u
         oxe8ZQyu7S76yXMUJ3myb2seeXbvzA1pNf3vnq+1nq9raK3ZL2UEcKYTXY7/7kzS5kfG
         S98O+qgYSyF93k0Xtkxz4+DJ5yVcEDRtQr+xbj6KmOeExs+jPJQL7AuCo/xcldXfH3jo
         FHkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9ZiESKaSmHrhzXZAuFxzd9+gmYiqDerEKwxgDPEPT7E=;
        fh=QYd1fgnD3n+EWkfd4ej8ahJ9COWwcwzAJr++rBQctEY=;
        b=e+72+CGIWb9acAUkoAy2DA7a6dw9MlDWlzax43miJELbc5biL39d7IbOoMrje7p5Ck
         CxDODEOPu5UUUZp0ZO5CLjdxMRlf3z3itHpOh7uy5xlhZB5+YZUUI5GHQyAPhmqQc/Yw
         R/a2pt5Q9HdsLaO/x3QodWnHdsgoBv/FbMqWU9Qxvsx5anZbLb1hrmYoBE9EYbjjzNUX
         s7/IdpHuwFPnZ167zQ3K+CfnQPlgnTuC1QFhCM5/EVtc8g31tYzl5/z2v9kEup3OGFmo
         BtDm6WSsp0h06prRtGOSWkmL3Ex1+TOeQNWayCpYyA/m0xtF3tg2DBVYWpcPrMqGLm3m
         lO8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778510286; x=1779115086; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ZiESKaSmHrhzXZAuFxzd9+gmYiqDerEKwxgDPEPT7E=;
        b=J0xtCaQ/45LZ6Zpmp8PIoLxtzQMYnbA8SSM6W3GYc9IuNquD33+Afrz+qtBjSJjiyE
         7Ycf8Y+24blgT8L43ZZiHQx4E964cFkVj1JcQJe4As6DsLfipXRX8aPAFKci8zlih9zB
         5+Xhbg3lNhJui3w2WN1MCtY+DTKCuJbsf+i9xS4+Pw39GCms7iV/7sqZ54dpFd9/R1Qy
         GcYUyYJncpy4IkcZmLov824nS+o4NLOmDjPiGvJ9HW6w3oV5V84Gr4/7KeFFXslO1T5W
         yAfBIFJol5gPOsYzGfwClL6pHT6aKLOHMmMU3YHBcPFwayjDhRx7kY5rkiPbBLrFRIJN
         xNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778510286; x=1779115086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ZiESKaSmHrhzXZAuFxzd9+gmYiqDerEKwxgDPEPT7E=;
        b=MjhwbsPOeSkfZlFUhSTWMUy80N9mJgWx3g7azhEL5+c5BvuT55oHuf84BW9HVDynSC
         tE6BFYvIyuflAn7q2n5sOSKajfdQtnH4Ig37Fb66Nubs3QQu4RxDrexz6hKSJ5qwmoBd
         br3/EqtND9iFXABBS8C40+Why17bciBEjPv/Av4PWxadyA9JLK4lJZ8rYqLX7o2vkJa3
         lcwsUMkTufrQI5mVWLpWC8ezPHby1uCwdmvSTHjbSW3VMp3qPm2HnWUvrdOZLjJUD9Di
         a7yUkHgNPUT9hi4YN0mHvZCyWuHgcwI4Qjk30J0sd0UH4T22dNB4ihMwAjjo28AoVECd
         58OA==
X-Gm-Message-State: AOJu0YxIgtD2xY7GMPKpwer0wZKqtoKL2Rr7Bw2a2bAcWdsZ7vnF1ZYz
	/Gr/YhNdRzOlJhbzwWMqPGjx8Vd5r6m+jbuq/xS8Owgkj9/5AywS5/J77EEL5hFHftxAg1gK1/g
	mxW65silkeEwXyvqLb579oHoRBxsXYMI=
X-Gm-Gg: Acq92OG9PNUjkyO8KrOuAgllO1Vc5RvH6/8DYkUDurgAgfJjGwS185i4U4c/n/7wXZP
	P7e92Xo9TiccrujvYa/XCUGmtew4KacL8SwfO2aeri0drChW1GiPZN23bVHp5OIzbrhXHFINAY9
	uFxF+q/jG/FGlhOflvrJKE2g2ObjmGZc9t9QpvNTHBJ/zrNM+iQB+PgMOX7BcyAs+VC2gIU6Wy9
	E+Dq8pwgKJ+fLQBF/pVXKj971l6IdpJQxK0GRoeQanJKnhbeb2loJFtO+GBZBx9BjwPtboIZoXm
	HosnFUl3FDltjlJUnklCR9ndi3STjJxR2q8n1Mtp
X-Received: by 2002:a05:6402:3488:b0:67e:2498:dcd3 with SMTP id
 4fb4d7f45d1cf-67e2498e469mr9847674a12.10.1778510285464; Mon, 11 May 2026
 07:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-5-2f23759a76bc@tencent.com> <675e9027-9fb5-47b5-9a2d-c9a416a27d0d@kernel.org>
In-Reply-To: <675e9027-9fb5-47b5-9a2d-c9a416a27d0d@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 11 May 2026 22:37:29 +0800
X-Gm-Features: AVHnY4J-RB-ZDfdS6FAfBEaq19cvRhvZlma3LO8yAi80-MrE3Vte83LIs6YuJlc
Message-ID: <CAMgjq7DegMz2ZEHOhHkAqDEWDuCSZ7Ktsxw1ibDY8axFzRRGnQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] mm, swap: unify large folio allocation
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38664C0019
X-Stat-Signature: ir8xh5jw6f6585oyng95ez16s9wxoy4r
X-HE-Tag: 1778510286-982175
X-HE-Meta: U2FsdGVkX18lnABG3CsmGLD24pZ2b0dvkWkegxrZ3isucXfVwLJlYd5wgOp0E3dOoJFcvZ2g8a6mImIrgIsKyymuo2eD7D3RLFExXUsYgePnqXHO6ZnIz+YE6Su95kcQChVvUq1Z+l6h6na04WK84gISGQhsAmPnAk1ddsi5yAXLH/XjVWs76dG5PzpyfYbkcCQ+zR9WWe4I4k4hPukaU96Ui9LWReLBkFbW5BH8/O11HFdZSVX+4fHXa7hzh6A4+RhrFH1omOk+zricT3/xkpVHI3g/eH5FCfXsIMUfdoqmEGfAjFLhokIu68Bn0fQpVP6HnOWcPbFX/uXiYp9b/PsZR2o1nOHC2NIGgKXcD6TwbcT6O/fcpqOs43t+pZkAm8O0AlxkkJiycnQ0eVcDQwA1h6lUYj5Gshur/zLRVWgo3EyP/QPUG5II3ZpQn3qrJ3Feim21a0AR/8hMk9wrJbcEVOdc1AWverp3yV45jyZ+YFbx3h2ZLVme9wt41ELdQ0uwuCa4i0oZ6ZXXhTrCZrsZVhPaCG/s3Xyq7l/HCvZfnqsLZq6FqhA84dBvB4z9RDE5ZIGa9A4RIi8fb6wFnJ+KDJeWqc+42vZFiwAldpPbLKz30c2G/khPtQTo2i4fmzCp7FcNZmA9xRaIRd2tn71Ov39b/rKkDaGloAEwRrw5EJbsBlXCS8+4ZzVpF6jnwWffzOTD2hafSwQwi9gT9zBN/tChtpEGOAQ/o5uiJRTeY1nJ8jORsefFO4XBqJOn79f0zpH6ylN1MGomXOLiy5OxH3Pdrs/SrYCzb46pCvF3vCQptQgS+/yjWfmDU5ar39fycUUYr6wUujAU1UPV3BdX2eI78ah6FrHtnDXM2R5icGaZAmcAZBwL86cCUAF7hAQx9V7dtnOqmE8yEK9+J2nKOlFKIS08gEwtrcP9cOEkaaH0WRxh1gzdDjE2MgzEI+Cf0RrWdK/xsFSVJv3
 b+ZQj2tM
 Q/TNEGsyZktkCmJvIfHQqUlm9TyrJ3gNLfyo1fSqzJNPAvfCxb5F8UoPyfHC/6JUzDa8HC8HTxmjKem9lYQpIg277P2r1hBXY1ViwBO0k74Pni3GGCK4WBW2oOPOr4Eq5E9Pr55p8+Ana7Gpbys/QpOLSeDaRXuzCUiEGX8beXYUrXz6zDmyuMQ/ybiGE46jZMEMdBTG4OEUSO+047VM+p8DDwuJnsdW13edOzejaQf0JfSIGMo4jVmCpugzvHyeWnYMho9pbp8iNeD9Ynsq5oqLTEp2ZFzAc1DuXfjprUP3isVXsrlUHylThvC1qjn7gGVIfKrCXcEnKCsPATQYFeF0GUoQw3PMYC9aii7Q0nQdvQnoDs3AsJicutkbf0Tehf77ycQMPcrLe3EddQV7nBZNEcDVAD3M7c1M8SPDnLaTVOfUqhmEQ0nTMzBN5/HO+bUmmDFYLOOuytJN+hnooIf18JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 8:58=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/21/26 08:16, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Now that direct large order allocation is supported in the swap cache,
> > both anon and shmem can use it instead of implementing their own method=
s.
> > This unifies the fallback and swap cache check, which also reduces the
> > TOCTOU race window of swap cache state: previously, high order swapin
> > required checking swap cache states first, then allocating and falling
> > back separately. Now all these steps happen in the same compact loop.
> >
> > Order fallback and statistics are also unified, callers just need to
> > check and pass the acceptable order bitmask.
> >
> > There is basically no behavior change. This only makes things more
> > unified and prepares for later commits. Cgroup and zero map checks can
> > also be moved into the compact loop, further reducing race windows and
> > redundancy
> >
>
> You should spell out the rename from swapin_folio() to swapin_entry() [an=
d why
> it is done].
>
> swapin_readahead() vs. swapin_entry() looks a bit odd, fiven that both co=
nsume
> an entry.

Yes, the current status is a bit odd, about two years ago I also
wanted to name it `swapin_direct()`.
https://lore.kernel.org/linux-mm/20240326185032.72159-3-ryncsn@gmail.com/

But actually ZRAM or shmem would also benefit from supporting unified
readahead like this:
https://lore.kernel.org/linux-mm/20240102175338.62012-6-ryncsn@gmail.com/

So calling it `swapin_entry` seems more future-proof. At some point in
the future we might remove `swapin_readahead`. All swapin operations
could have a unified or at least a per-device readahead policy like
the one in the link above, instead of the current policy where the
caller must decide whether to perform readahead.

But any suggestion on naming is welcome :)

> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >  /*
> >   * Check if the PTEs within a range are contiguous swap entries
> > @@ -4642,8 +4622,6 @@ static bool can_swapin_thp(struct vm_fault *vmf, =
pte_t *ptep, int nr_pages)
> >        */
> >       if (unlikely(swap_zeromap_batch(entry, nr_pages, NULL) !=3D nr_pa=
ges))
> >               return false;
> > -     if (unlikely(non_swapcache_batch(entry, nr_pages) !=3D nr_pages))
> > -             return false;
> >
>
> This should also be pointed out in the patch description. (and why it is =
ok)

Right, the check is now resolved by the swap cache layer, so the
caller no longer needs to check it. I'll describe that in the commit
message.

Thanks!

