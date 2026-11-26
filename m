Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F34E2606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 17:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EKPP0Bkf
Received: by kanga.kvack.org (Postfix)
	id D18986B05B4; Thu, 26 Nov 2026 12:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFC26B05B5; Thu, 26 Nov 2026 12:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7716B05B6; Thu, 26 Nov 2026 12:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA1A6B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:30:41 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 455C3120491
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:30:39 +0000 (UTC)
X-FDA: 85477959798.14.7A5E91B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0E9E280012
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:30:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EKPP0Bkf;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795714237;
	b=iIXKsYVa9MWFHgdS348PMxDoX28sl4byHgKZWLM00LVLRmru+P8VCARVYtuqDx338VUjvA
	NQQ/sOjGIawQnIbBjgv6Xe6OwURUF9BCxK7jy+9N/aA4NeDtNR5KT1Fe7/V0CGtLP63+BE
	AFQDQ8Kkm+az2CNaDd6l0dcamWVTdG0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795714237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gddPbAWbVCreSTfaILEUDv9Rsv+EhM6Ujvvqb1L6T4U=;
	b=RMdoxRDgEdGZAgw8pn7i5sRnhi8UaRdkQckx6dwdUti39fIkCK6MfjhrY6x+Hc3WNvWRxT
	X4lMIta8e1u6tUMS2bOMykNA+EXdZtVpMkiXjscyxjXwlIslaBi7w+8A1Cc9F/g8Ypo7KA
	f9Z0KOXbZaOCsMTY3/0ZinS/Q3urJ6k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EKPP0Bkf;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-490c3ae81d3so4558587f8f.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:30:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795714235; cv=none;
        d=google.com; s=arc-20260327;
        b=k9wYQEquLfysGbj4NWrmOxwrklg57e3htIHyVLyof2jTewYSI8mpu3rnn4YrQ6ZY6Q
         v9DmAj0TZJSfyJ21YCnvohRBYNqXJlL9nr5DUMt/XyszUOjm5TisRRGOrBNTbC5V22kX
         ZnAiztJrM1CERSkHr7a8HhPvpAvuc4VG9GVwwSGIyQr2nZK5jrr71QisMLtTEaQ+BxxD
         uu4mvBJDS2w7E/RWHoX/QxpVwKJOPtaRqEUg9Dimi2xkUMzQIayKGCZnquudwKuj9cWz
         2cz9bmGwdi+VYNmjFFOnK9mIJA6oybO7mtEx+p9yRYLdpy7Cd40KsrJE0kCW0MNBBKsC
         eOWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gddPbAWbVCreSTfaILEUDv9Rsv+EhM6Ujvvqb1L6T4U=;
        fh=f4jbz+dJwygjOkQa9g4Sg44cHRJYlblvz1goICeczzM=;
        b=f+EXswMwlxY7jaftQD8tkOt//x8siMA7+SN2/BxHxdAIxwYJUwlykmtrl3bJ9wYDd/
         aEh1bac3aqW9QHQkoOMq1A03MrTa1zpY+QooTAkQyLwyPy2r86KG0wfMHmXM6DOnGo5c
         bO5ZzbDng782bCvrg9xtVptNBr/YvtY4Prl540uwc/rTvrWmH+nQe38yqDc3lr6sI/Yg
         /aQ4KFq2+uwk596BXlSrW2B06diHMM8+tWaY3M+0XBUoRYH5U9W2cioSSGP7aki2iVRF
         c9jXaQIHgcCawbjl3daK4R+Sp46x7e7wo+AT/9aWD188T3gAHMMwpxF3JyiusH4i+CY3
         qjCQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795714235; x=1796319035; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gddPbAWbVCreSTfaILEUDv9Rsv+EhM6Ujvvqb1L6T4U=;
        b=EKPP0BkfHy+mXSmJnQ6jIOs+ZlhKOsGH8UEIcxjikFtXMd4TkVr7A39VObVuiWHZUd
         z1fMkAJauAb8zKOqS+O6fTKvGxmcKcz6F6cucgvypIUsvjcb1PL9mHSf0AhplCo/RQ5i
         nfgKpIeDPKvCHltzU6L5x9PFbr0JHe6U9xABaC/uO1zMqPEQ3eo3xdW/JQWRyaeTYUyR
         gWbrLIFI1V6LbgIdm+6gOUwHz1YYllnKL3wugh0lsUZHuEz+qCWC5bKOljeQ5eppgNx6
         sCdREGRFy8oBD/2cNLOnbByLmpvKZKU+2pGWWG52KJi8cJHFTd2VbYlFpowYk05vsXE+
         3gAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795714235; x=1796319035;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gddPbAWbVCreSTfaILEUDv9Rsv+EhM6Ujvvqb1L6T4U=;
        b=ogTtJ9Zonn1blW8dmTyQb74bbz9AYXQnKkHIh46YPqknAunZypNBUWRLPKBnIoxpvA
         2R6rtNHCElvYd46zPgOW0FVd4nYeAkblvsVbSFOcqRrArZPSXVpou6SELEDCfEyRDcuM
         DJ8g1Lta2NZLuEWPGSXWJuWggphoLfhkA88EDxbXBCKXbblHK9+xEEMiiWTjqHO2kw2S
         cc9uimwfrE4JP4G1Y6HQUnw3pdOOsEymBwBHA32WGI96LEwFOGeMlcXb411SLt4N6Qqe
         VQoC7MAtF7T7l41mNkNFn7aqf42hlKnYz+tOX3kaEY+l+JDuP/pOjIlhQzfwf880SbAZ
         5eKw==
X-Forwarded-Encrypted: i=1; AL+hErFaOcW/hBQB1bgYyESQK4KcCl3ocX/zfmyY61/8iUT5kmb2qgrQBX0MEaIPJERZOsQ23Qo6cGvbdg==@kvack.org
X-Gm-Message-State: APuU4Z+vDBp4RYwddozGiCdh6UFZs+RLraajia7mvXZ9OqCbDzd9hL2/
	Ihz41QfzPuUpgOM7fyfqhvDQ/uhWaoPj7uV0NxZtO9Di33r4xoE2/21IdXvVvsXXBI8KgfFil6P
	TzzwNziwP6WjCVRBzoWeYazxl3koT/R8=
X-Gm-Gg: AZFdTZcLmszdrj/uwoZ06LjOnmdAQTppKvdUXaKUynHNcbtC4ck5eWVDaImzfxvwHD7
	H/2AaeU3Xda23G4a5pzrDSEGm/ky1TmnPR+tinkqLXc8Xb+SXxvPojQZhYlCL4krd9guxjxluc1
	ocqE/ZV+qHgSkpnGG0ovIj30qL/fkO5WntFYJDrnrglkUXDLulo05xpV+KSXjavc3/KpsFVBJAq
	K6vTa/Ry5KG02tZBjkGdTEhYYNLu5nS7DuP1RO6v725Viu2druXAQaaWZZLIVnCP8cUj20B4aL4
	lzdpuQJ1p/LeXMqzS0n6zhF4YrP3SbsZHiwdzPGKTi4jKuCCHZFiqzkhWHEFFc4u/ejUmujiHyC
	dQ1nJrew9O6BdS5450ElGO+k4bJlkVyiyms9w40vfKsqSZZ+vwkFsMAJ0pmg5Ddmfo7BNjz1R4F
	3k4+54BhCBfPzXsTMKg4Kt59wFZXNpEcQydMJN3BXWk7atRLC5jDvp
X-Received: by 2002:a05:6000:29ce:b0:4a7:1fca:e52d with SMTP id
 ffacd0b85a97d-4abb0e46a88mr29683986f8f.9.1795714235150; Thu, 26 Nov 2026
 09:30:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
 <CAKEwX=O2McF-gyqJT2a8R5q79+QABCPjULrcjC2CC0v8TnXxJw@mail.gmail.com> <awfLp4H_pyefSM5v@fedora>
In-Reply-To: <awfLp4H_pyefSM5v@fedora>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 26 Nov 2026 10:30:23 -0700
X-Gm-Features: Aa3M54rJTgwPSeOjApk5LSNeUtBIt7uA3RemLayFHLNNoWbgFBictWmfnBliNKE
Message-ID: <CAKEwX=O2d4KKzvmReuv3x4TPX+NGSN4WUmuWY-OtANse+=sNVg@mail.gmail.com>
Subject: Re: Virtual Swap Sync
To: Baoquan He <baoquan.he@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E9E280012
X-Stat-Signature: pbmmn6f3fu8ffrrez3b6bn9xd3teme89
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795714236-375557
X-HE-Meta: U2FsdGVkX19CxVdLESrp9d3xBYD+3vGR/ReI5xJknoIhhhBg+PnAoQyne6QOF51g48HLFLirdK0PIGLJ78f++QSnAbO683f3X6hZYg8vVSzrLy4bc+k9Afn3QhxLAZ3xQLR5Yr45MTNAQOPwmjY1Ijz/FKjEA4wzghq4iveEYJMIZeuJVqw93KWRITmGb3IBmf9hCZ9UTHNkPepyzzKjo2FPBhuRMOX9v8mLesRqDj7Fk9jFG9TPDV1DCtLzHU0L9Ydz3juHluhb275S16bEUi4yCKso0cQXOvaE4rHGdfNgd8W5VxH8rjzrOWvcMnvMyRm6WlHkIbriBxt0jk+9h2l31e2DB4WvbLF9FBI0/6i0AO8Yvlf8MBRQoXqmml8HeI2K+Za3ZcSBnkuWeIDSIW5xIqxQEBh9QKj2rjlCyEyIWJyThwEsAEJQnhI+o1I0ZWQ7aheiANVNwTLe8ubrW5IGlBYE/8/Bn0VqDbCb9auKJyVAoDYWgDh6kb3ByALqGyRfwSsdtDy2n0h+PdaXMIjmzttk3rnEZKE//puAwDlXplCee9rPBX9ZR/f3RPCgpk2Abm/E/jAD46TUeHfRAXn2KGM3Ah64Rcfez3l2srBevHgFQygKgn2tmZQggIQ9Ron2SzdwLPvYNkmTYjrL0qVCJJSjZcu+oJtaCPMmTzLAovvjxU+tKaWe0y9tUs27O18XUAirFaVoo3FWNioKU4apITTUcpmAHPgWdh/V/QEpIUmYBRGzva0ZJVnQcvDWABiO8wzlGnemzS45PkGw5AGW4E/pnN5tnVWkU6Z2UjBJJxco+mB7GlQU+go/Nj6lP9Tg1el978EAhCbiWwrlE36wcpDIdzpdWx+PhlaVxryo5yDb+ISmoZJzLgvMU+oO51D84SN07+CnH3AuGi2lpclrQrJhnLCAiWyoL7oxYR6QMIhKgVl3CE6+muFroN5lCoLg3fjakNAxEt5pOcz
 8v3AGZIc
 0cVHE9+vnTNMlVuAr3BF+qcqrFauE1wkJ/bDFjCTa4WOnA0K3ipn7Ojx9gA4s1vzREG9eyQA3L/+tHAzAYvAroZ++3zXJt9ResbUcGAfiQJuW4rpL/Cb9DXDSM5MzwDkIHH4xY3qhvYKTQDt954FagzmU2v0c3PsrKgvXaYXcYTZVyPSUz0S4HsXtxJEWLFVPMXP6hKr01T7cTgYZILVsbg7vxqUdyVi4PTBp4U+0gx8tAQHG7h9YxSevCYqdfNFMqeaPRgTTHfYEmhdIr/KSBwZT9dWBrnJZKRPtN4sq5jOLhF4K9iW6qIldFw3qlpyHD+6TN5JCHnQrnD6IBt99ZFhFZ3Z8jRqhsYczidHrh9pJAO0F/IC9epmJ9+lnU2iHSQEM2k0vi30+Ayttm3+UWJ7n3C/tAAyIT3S0/25mqelOpFfRXDKxe09zQZBn+mRh08ZpvcAjBjJ6gNRKU4iTr60b7PfonLTrcD9rsKbNfWac98mJdMC5V54rmtI/ZKLULA4Yd1u02x3PNbUiO6n5Dtx+Kwxe3rKOCw2x7X7HmwWhvCQUmhQFBdkjdmdR78H/6grBCQtKSbmkZQq/vlo+rR04eKL/y2N8d7X5VlXXQzSr7ArVv0FR/t+q5q0aAxwnf8NCfl1/aljxzS6v/ypqBRIJmQHowWTGERzS+a1YlERjm8f2BsQ8PkjUvOu/Xc2Y6DhUO7is+EjiLB9LRk0ap0UYrDIW/DBNJtAK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 11:03=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 11/22/26 at 08:31am, Nhat Pham wrote:
> > On Thu, Nov 5, 2026 at 2:06=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > >
> > > Hi folks,
> > >
> >
> > Hi folks - thanks everyone for attending. :)
> >
> > I summarized the points we discussed below - please let me know if I
> > missed anything or misunderstood a point.
> >
> > * Control interface: Google is interested in a knob to cease zswapping
> > (which already exists and will still work in vswap world). Kairui has
> > a use case for remapping all swapped-out pages.
> >
> > Vswap currently bypassed when zswap is off; per-cgroup selection could
> > be added as concrete use case arises (for e.g migration/compaction).
> >
> > David objected that a virtual swap abstraction should not carry a
> > swapoff interface per se. Folks also asked whether making vswap a
> > mandatory layer would make the implementation cleaner (Nhat will
> > explore this direction and follow up on this).
> >
> > * Virtual space sizing: We discussed using vm.overcommit_ratio and
> > vm.overcommit_memory to limit the host's logical memory footprint. The
> > exact sizing formula is still unclear - Nhat will follow up with
> > Kairui on whether it is acceptable.
> >
> > (Kairui, if possible, can you respond here for your exact use case? Do
> > you want to limit physical memory usage, or virtual? My understanding
> > is you want to gate physical + swap, which would be closer to the
> > latter).
> >
> > * Priority and multiple swapfiles: should not be added for now.
> >   No good use case for swap priority was identified.
> >   Multiple swapfiles were used in the past to work around swapfile
> > lock contention, but it is unclear whether they are still needed with
> > Kairui's new cluster-based allocator. If contention remains a problem,
> > we should fix it in the kernel before putting that burden on
> > userspace.
> >
> > * Proposed phase split and charging (from Nhat):
> >
> >   - Phase 1 - initial foundation:
> >     - Decoupled zswap: Let zswap operate without reserving disk swap
> > for every virtual entry.
> >     - Physical backing and writeback: Keep disk swap available as a
> > backend, including when zswap cannot store a page or an entry needs
> > writeback.
> >     - Charging: Retain memsw charging for virtual entries; keep
> > virtual-slot usage out of memory.swap.max. Actual physical swap usage
> > keeps its resource charging.
> >     - Usage counter: Expose vswap usage so users can monitor
> > virtual-space consumption separately from physical swap usage.
> > Essentially this gives you a method to estimate the logical footprint
> > (memory.current - swapcached + vswap).
> >
> >   - Subsequent phase(s) - further support and controls:
> >     - VM_SPARSE: Add VM_SPARSE as an optimization after the
> > first-phase foundation.
> >     - Runtime controls (added as use cases arise):
> >       - Host-wide runtime disablement knob (and remapping of swapped ou=
t data).
> >       - Per-cgroup vswap control (for e.g, if some cgroups want
> > migrations/physical swapfile compaction).
> >
> >   - Orthogonal use cases and concerns:
> >     - Cgroup-level logical memory limits in cgroupv2 (memsw?) - swap
> > developers will follow up with memcg maintainers.
> >     - Static sizing: Define the host-sizing formula and decide whether
> > another interface is needed.
> >     - Swap tiering for cgroups: Explore backend selection when a
> > concrete workload needs it.
>
> Youngjun's swap tier comes from concrete use case of his company, it's
> been v11, he presented this in LSF and LPC.
>
> [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with per-cgroup se=
lection
> https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.co=
m/T/#u
>
> This is xswap road map I shared with you when we discussed about working
> together. I also mentioned swap tier in road map because Swap tier is a
> very important feature we swap developers plan to add.
>
> https://lore.kernel.org/all/al8ohWshSSZ64AtT@MiWiFi-R3L-srv/
>
> I thought you had read them.

I put this as "orthogonal" because I don't think swap tiering should
block virtual swap development. It's probably the other way around -
swap tiering makes a lot less sense without a virtual swap layer.

If you want my opinions on swap tiering, you could search on lore :)

https://lore.kernel.org/linux-mm/CAKEwX=3DO-_OZ8x0UC96a_k+0eZfAE+mWMWDdn68u=
y1LHRq=3DJC0w@mail.gmail.com/
https://lore.kernel.org/linux-mm/CAKEwX=3DN2XcMHN1jatppOk6wnmz-Shab5XMtTtzg=
YOzRvU_6YFw@mail.gmail.com/
https://lore.kernel.org/all/CAKEwX=3DNfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnn=
r6J6PQ@mail.gmail.com/
https://lore.kernel.org/all/CAKEwX=3DNfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnn=
r6J6PQ@mail.gmail.com/

I did review Youngjun's code, pointing out some deficiencies we needed
to fix eventually, but I did not nack anything.

The problem with that series is that the memcg maintainers are not
satisfied with the proposed interface, and the lack of writeback
support (i.e data transfer between tier).

I also raised a similar concern in one of those comments. And it's not
just a nice-to-have either. We can get into LRU inversion scenario
because of it.

FWIW, virtual swap IS a step to resolve that problem. It provides an
indirection layer that allow you to change the backend without having
to do PT walk to update the backend, or repeating the logic at every
backend level. The "V" in VFS, so to speak.

Similar with the other items on the list - memsw for e.g. I made a
best effort attempt at least to make vswap work with memsw, but memsw
in cgroupv2 is its own conversation.

>
> I don't know why I couldn't join meeting last time, I tried at 8:05am at
> my side, kept waiting for people to approve me until 8:30am I was
> added. Not sure if you guys also talked about this.

Hmm maybe I missed that notifications? Apologies if that's the case -
I do remember letting you in but I wasn't sure at which time. But you
were eventually in right? I remember you commenting on some
overcommiting stuff.

Feel free to comment on this summary if you disagree with any points
:) And how do you feel about the proposal?

