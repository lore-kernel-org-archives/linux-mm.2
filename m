Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5733CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231E56B0096; Tue, 12 May 2026 05:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E30A6B0098; Tue, 12 May 2026 05:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2566B009B; Tue, 12 May 2026 05:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0C086B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:55:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99EAA1A03FA
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:55:55 +0000 (UTC)
X-FDA: 84758311470.21.F5D534B
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8D3B940007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:55:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ckzhuV4z;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778579753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZz2gwZyFbKND0yBkZDP9VGhlp4RSoQid3s+abYi6/4=;
	b=pG5dYuuiONl81RRaf9HLF8R6Ql52la6ZRc5Mta7p3Gyq/23Jc5c5mxAnHFiArE3AJjOmP+
	Accud2YLfHN77zsady5zEOZk+eshbJGdsSBpyCx+OBZnaGZKWiUPJcaXbRqdWaoSli5Vsa
	zgumZnPIicxiJcPSq8bN0Oz3YgBJuM8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ckzhuV4z;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778579753; a=rsa-sha256;
	cv=pass;
	b=noYRmUj/fObFAIcFkhAwKwlCfw6DtwXiOe8vXSjhxewo4Pm4OarY9gp4W2EPoSjKVeR4w9
	UJJvYdCiUMQWX04eqaZAxe+3S/+IO3sQDzS8/f21q7EIp34cC9Dv86a0+mudRZ1tq5j+kH
	XVwtWjXqfqrgDgrklMcpmGlKnzZz+Ps=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-67179ed133dso6378032a12.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 02:55:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778579752; cv=none;
        d=google.com; s=arc-20240605;
        b=BllrKuYrVzyFi7UxBZvxVQc83snpYSgFCvH83h+S44LgMqoF8t4BZHFaSBKrYs6fgv
         aq7OAvoakavnoxnsLYMuZ84hAHydpUjBCNxuhyKH36W0TI9zqW3cwzCqP+ySXaCVqUti
         mLyd/EJ5rnKaOKs0yr9OHYCRgSHodD3CeVERQMfVCVLQ4din2He2sztbD8ejlOpQ+wtC
         ZCR3J3Ud8Bitm8SBhlfF5g+hG+OMbQDACyULb3v/NVetb1aDveUHTYInPPHtRzW419N/
         Y0ida9nfganTz7NDfH/XQlSL9HFb1kQae9Vpf8KpZ8UaZOBwIYjUUmaY3iFln+z+640Y
         WKQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cZz2gwZyFbKND0yBkZDP9VGhlp4RSoQid3s+abYi6/4=;
        fh=HNtA0Z4WJ6w/bmtP+IVqMAvGrDLojCqFhHQiXYFmXTM=;
        b=QsiXNMRQnRHeYSvyBgYnsBzTuqosZYqLWIBeaoPoHaUMlP0b7+a+LPlZtnD5aN+I1u
         5zPGVKVXTtfOv6/f0Jxq876Njub/3tYT/Z3sgEZ32VenKGk0nbS4dmLmztLDZqtosbaY
         ZFw4c0xOq0UtmZD6FJfiFhzSCY/ZPyVIt21Kqf3T6yUChqh/3GJLR6G8uhovlISlv+66
         jUVlp8oZX9EXc0lPyyiye4QlIMB6SmTbh2yVuryNXr/my/gHW8s+7CEsVG2L5Q+tFd7Q
         WAicbwkjSgkQZcU0L0yrjnGjyuAKDSjvmHmGxyR+hPWcr2MjVc++5TgJL40LtTyiuqie
         XUYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778579752; x=1779184552; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZz2gwZyFbKND0yBkZDP9VGhlp4RSoQid3s+abYi6/4=;
        b=ckzhuV4z/qqj2deGY59YnH+FOoe56Xm/sGm6ZTkIgiXnp815p2MmLG35bXlNQAx2uS
         Hop6smRSWVnNCvMcxFXXhw3l7N8tHtxl06bMxhS1pMaBSCv19R6+e9UyjNEDaCPkuR9u
         8xsvJ7BobBme2Mhxn0cCv2tVObF51NfOou8UwBg1ihLXrp9FoUt1Fnp29+EP6ey290UG
         JqzeizrVRRZEFyyc6dALLWH3b7r7a10CE8HprXrrKq5OBv7CavvOuFLGp3NVuV7/cwU1
         H5klZDZd1mW2PW4FYFa/yGgCDU8lrpW2XxyQSCyblFPuHr/UY8sty3XM8OCelvR1JIy1
         jwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778579752; x=1779184552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cZz2gwZyFbKND0yBkZDP9VGhlp4RSoQid3s+abYi6/4=;
        b=gs+y8CwLqgd31b70NfLkmEMHBTgMMSsLsJlcdHfUPbFaRaP3rqpKKsz5f3r9S1w2yF
         haFeGv+MfP7yZhdVIiV4+CbmTo1oLUBqcuYtri9OBt511q7K7lUBjdO9e/RirpYyTLch
         uUAixWnvujMzThT0kzLhgerEL2k/S2e6uMYYISEUsABCUS2mVzzQzqfXxoa2RpPMDghJ
         sLXXm3kj3IDkNLH1A5xhyPscVR15w/RYSRNZbJougk4qo3svTJGElDC6+ioJUeG28uys
         x1n+FkyRGDWxddcB2zkhjzZ54X/mRRJJ0xlBMy9O8PZtftpMqtjzeYzFZqpeRJ/NYjJz
         UYVA==
X-Gm-Message-State: AOJu0YwOtiAIFAhoewLvWscZ2DZeNe0212wFeXj83FLZovHrCAh25rdD
	yvGK43G5Pxfg+nHQKioqLuPPAAUCbMKc6dbOpgdWTPmZIw9ZlvBHXm/cvsQk+sfmCiKTV2fKO4N
	tYBls10SqfZwzRXXHgvkNwa4wWHodz1o=
X-Gm-Gg: Acq92OFpZnfYgEpLAAHqcwOGwx7GFZ+W0Gm1AfN+Cwn7Hd0gf0/V1hoir6gwdnlA+nc
	Ewre5j97GHEmVaqZ5Sbj8OeeqRmxebDnHC+j6naaSMKG4jaxHOkzEruh3xaTi3UzJl19hErGu8C
	0dXPeISoHdFCFyjjU91GvmGHQK0QaK1WDE5F19i8mM1iVkoK9MSptcG31YKwcLql2EdQ4rajzgP
	YAq6zcDjMiysa0MO9Ark/HAmmFAiKUFVdOzazezBN57OC10o1N8u30CuJqXDCxZsMZUAPFlVv/N
	XWPTZdOWS5tlg8tVx0xgDe3PRmy/ieHoKTAMhmlF
X-Received: by 2002:a05:6402:c45:b0:677:1ce0:c08d with SMTP id
 4fb4d7f45d1cf-680cf83d375mr1265634a12.18.1778579751409; Tue, 12 May 2026
 02:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-4-2f23759a76bc@tencent.com> <19f31906-d8fb-489b-8e2a-c4414c99f338@linux.alibaba.com>
In-Reply-To: <19f31906-d8fb-489b-8e2a-c4414c99f338@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 12 May 2026 17:55:14 +0800
X-Gm-Features: AVHnY4Kx5IWu0o7HIeraLeLyWHYiLcIgyJrwH0dsgu48foM5j58dRwqAWziHzSc
Message-ID: <CAMgjq7CFwVkxST=Ya-B7tHEsbtYnRzf_tMXN3ctm3NALvW1LoA@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] mm, swap: add support for stable large
 allocation in swap cache directly
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>, 
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
X-Rspamd-Queue-Id: 8D3B940007
X-Rspamd-Server: rspam06
X-Stat-Signature: kaeihw5p8epxasohqh5s3hy4t4ywx34o
X-HE-Tag: 1778579753-184387
X-HE-Meta: U2FsdGVkX18/vjJUOWb9/glNrF8KA+Ohp8muSdkj7WF+XVOvoM72ufyKRw17yN823fEMlX339LvtgPjH70iclh3vXfQJmJYtnAx8oAwWD7p9qDibN78cFiX8RH9saUSduGA9gbYp9nBgT61fMzYxo2hAwZLeEfbdpcJAHEN4JVycZDLIpzk62ASPkoIhxmMpEyAIV37wz90kK7LEFVRQCy+wtyi82L/8QhxgQSit8YXZSrg2dD8Zgl80JMJ6mXmLT+bk6xSWbIp8ujIJ66Mm42kqamQRNgCpUpRCePjtl18Ma3C2faJWbw7ApxWS8N+8OYDcK4rV+ztMMEJ0wiU3gODIiZjU1mR9LivgndFCnuA8XgIhu9nVJ2O2aZY/m0bj/24xqEMpIoj5GqLOE6cMIAH6gPHgUeNyQfdBTeSJbAmaqj52QWT/k/HGpgEZUvvuF2QpqXrJKZEtdl/H8TRCdTAKhQxdsp8W69yXkViTaLZgraNF7an1Br13WUSOzJrw2EAcw5qrBkq7xLbiryfRX9mVu/h+D9GyCgip35hLl9enh7M3R50muimBO0MJCohRwdJdV/umMrGpB0gEvvfmvNdtaVTPJ/FKz7WPQfKec8v3lxthSgOrJ8uEDsKLWd/qR+B2vqMLwLXqaksHjXpfMRed0CdjK0BYPoA2wBjGUBl3usfLtHQQMh6AnlSXs/4M1LwIJnCncz/zTTwo2Qa778lqlLi7mwg3KnrVnGtPXY84k3NNrd1wzdrqTFk4KzzuLL2sCHPnUFPQrRrBFCKZZZ/0HKEwMLJtMDoFEpanMXmvn2rpyB9qPxA4sPpPlOS9NLSLIH/x5GKG0sxm31u+9EuysPXwa9qRXjSAgFAnYS6VUx9GS8kDbbAEOdN4qoOFMzX2jF7DiIAfqpVp7a2cp+HTmhkY+TU/oaxVPYoy/qNx8PCUcZJoRSM2GdLilcTt4tI2W0BC2hu3qLVOslV
 VB4Q0cg5
 0EwPuZscb+GNnx3H1MI8p99tNd3jtpSx02L+Wr7tZbXa36vhR81o4Sk1WrSFLVsXskQBxxx5KOSbsp6ArgZgX8qCibdrpR7gC4uqPKjhQ5Ur9pLDzZq1FZlm4gnNHRb1erp4zEcFEFCMhM3VEHZb6SJYH7Lr8VY9HRKksFp1X60L6neJUROWnzw7Vj/siPlAK3HTh98ybsSPlz2BTEY+HiqvR2wcHj82C2XBmEWt+SV6L/+tX7xerDGMcDdRf/gJND+1dG9ARThz4x4GXOy3xcBl/tmtqLdQOzWQMkyhBpwqAF0GyO4aaeKf3/ss8xrdGzps6PoI/gb92CtJi7zuEBHqEJnObXTjvarsWQBb0HACt00Xm5E9oQRu6Jf1us+eXTo7ugGtV3vEKAqfhMTkkicg0PfsSjBeNcfobJbE6rDAd1UP6TrMWB//9kVSm5kW4RkvJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 5:49=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 4/21/26 2:16 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > +/**
> > + * swap_cache_alloc_folio - Allocate folio for swapped out slot in swa=
p cache.
> > + * @targ_entry: swap entry indicating the target slot
> > + * @gfp: memory allocation flags
> > + * @orders: allocation orders
> > + * @vmf: fault information
> > + * @mpol: NUMA memory allocation policy to be applied
> > + * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> > + *
> > + * Allocate a folio in the swap cache for one swap slot, typically bef=
ore
> > + * doing IO (e.g. swap in or zswap writeback). The swap slot indicated=
 by
> > + * @targ_entry must have a non-zero swap count (swapped out).
> > + *
> > + * Context: Caller must protect the swap device with reference count o=
r locks.
> > + * Return: Returns the folio if allocation succeeded and folio is adde=
d to
> > + * swap cache. Returns error code if allocation failed due to race.
> > + */
> > +struct folio *swap_cache_alloc_folio(swp_entry_t targ_entry, gfp_t gfp=
,
> > +                                  unsigned long orders, struct vm_faul=
t *vmf,
> > +                                  struct mempolicy *mpol, pgoff_t ilx)
> > +{
> > +     int order, err;
> > +     struct folio *ret;
> > +     struct swap_cluster_info *ci;
> > +
> > +     /* Always allow order 0 so swap won't fail under pressure. */
> > +     order =3D orders ? highest_order(orders |=3D BIT(0)) : 0;
>
> This seems a bit odd here. In THP/mTHP operations, it's usually the
> callers' responsibility to determine the allowable orders. So I think we
> should not implicitly set order 0 here. Instead, we should let callers
> explicitly set it. What do you think?

Totally agree. I hesitated between these two designs.

And Usama also needed this because some callers (PMD swapin) don't
want the fallback.

I'll let the caller explicitly pass in the allowable order in v4.

Thanks for the review!

