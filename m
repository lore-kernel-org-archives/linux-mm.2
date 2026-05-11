Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F552CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A814F6B00C9; Mon, 11 May 2026 04:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32016B00CA; Mon, 11 May 2026 04:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9214D6B00CB; Mon, 11 May 2026 04:58:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC986B00C9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:58:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22C8D8D830
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:58:10 +0000 (UTC)
X-FDA: 84754537140.03.8CD838E
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 363D0140003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:58:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kSVU91xk;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BM9h6f+Ityq4StWVleIqZYwKmfy1XjZkerlVyBBDiA4=;
	b=wKtdwm3JyjxEn3s8j2/Za3cdfkRvq2Bkwfg9IeWm7PH/1lc+1uMV/48KZKnCBCxfemDNj3
	XNlDX23VdBZ+eurLMFjIqW1n4cKyonCDecnyMYfe8Zob4mpuxNm3nE8Etwzeul9DRnlTqZ
	03c6ICLofz/sfRZuQoDUnYwSqZSUBkY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kSVU91xk;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778489888; a=rsa-sha256;
	cv=pass;
	b=TxltvKS5dVAng46vopraz2TIWW7Kw1noEPtmQtuJKp4nBdk+lZooS/ogqJKLgk2fO2rlpO
	9RNqCVSo+/BjpT7MV0mKxqgupP8YJfNIbBgQ8Zs2zJYkmZ8ebjGTJmwPqZuLbSxkBHo1Rd
	LHrZBbsmfz08TaqEThKvz8SrB1VSTe4=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67c9616b4feso5975513a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:58:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778489887; cv=none;
        d=google.com; s=arc-20240605;
        b=RCSzqt5bUpXzJ2aPzjjz2bBLvylqUquCfCdthRbAVyWQCMmKLk6iZabmkVSAcrAhSf
         yYR87GDoTGgnK3vuqKZPTd2qXoZf+k4P43I5Yt6elNdf77/ZStOSIMGOamGwT5gLZRFr
         AIRiWZ9JAucnpNk6V9KY8IUwX/UNlDQV4nowXwS6opCFLgVNyjAQ0kTLJMkUyIKhhv/H
         1j0wqYdWLEVVFfx3XPrXKyqRmxSOgVGHyGwRryWivyEu5Q8y/fUfkRZQLpHbRRcjaNfh
         fy0wOj0QZpX8t99Ni5CURmk1xo7rzTazHp7AMUayvgZBcb/J0nUP5KyZHHhP+2V9A3yc
         7TrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BM9h6f+Ityq4StWVleIqZYwKmfy1XjZkerlVyBBDiA4=;
        fh=HgvzTsTje9lnNmOaG67L9WazGxXHdaNiyuLClgLUnnw=;
        b=KdO9xp1aDgD7NelcFvJosvUgnjNZQ3QL5xP2E0W4QbiTercg/vo54dgwktpFoNRUMV
         1lYhs0MEYs/1FMnCw4Kug+BqZ8etVZMM9U5cwTsl61xkVzrBIF9QPcRrk8ZD/vN0sMSn
         E5ki9Ftrf/nJWjkaHShQE0iVyxLPgWbWk98qvcWDYyRBYFFBqDRlnDd/ufNfYEvKcRmY
         xNjO69+iGgRiJo7+VGKtVjHa0EkVr39jI8Gwzio3CfUM8JlsrnBv5LeixJpDkM56EStC
         pROd1JZ6VbdBwAzj1y0dZ142BvujvLqGeRGORsHD04WptlSKDLyEN+hQQYD0v/rndtMr
         qNUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778489887; x=1779094687; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BM9h6f+Ityq4StWVleIqZYwKmfy1XjZkerlVyBBDiA4=;
        b=kSVU91xkrMdA8vKVgCmdIE5eG7ePmlLEim9lqHp4kZdglR9QVMU6blwE8Ekk+lYRFD
         eIK0wEcDguOSxDqw8Dkefxo1d5lzONGQoh2S4v7QM3Vy7ggEYQROIEsfjDJbZ0vQIIks
         Nzo61SbLM3CdKWraTrKSDDcFRz99PUUYswBd3AQUOYGsviel8C4xifE0iwGAYd4tfAfS
         NGS6Q0VeOgK7ZF+XIc3nEAI5q7JM+/L4sm7O5VRZlSa57lQ0OTFEwJt3gCzwQDTlqVNg
         eprgZdJlVuQ7RiuV+CQcokx0nPVCt/j9qjz3EytX+nGdQKyp6Pz531fCTaE/PDWd+Pki
         fo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489887; x=1779094687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BM9h6f+Ityq4StWVleIqZYwKmfy1XjZkerlVyBBDiA4=;
        b=LyKiPnBDP/IM+D1ckZp7Q15AEo3jEuUwsroYA8VJi5Vdq1H+jyGGO4rXubxzqFGZeW
         5gAYUxDKcB3p64v8SAE4soSqjeyBD3s7ASz/w7gi2oaYQ4wPIYDVd4v1NePoGOkYtT40
         3w3fOY8tPIp6qz1EACjnhQlzqaac7nhaNuNmPq/NOXUrwf73L9jmpmsp7yLVEASqVqOj
         qqKKRtwXAFZXfGTT42SOBhGu3l/E7I0F6dbOUyd7b6bCVtYeiE6vgmQUM+yiTCV8HaAx
         Cqz/baQ8qp2nfpG4Ya2TLy93kCrIdMkeeMXeZQJy62h2FnWvgPQaNpUWXOF4xhiHBJPR
         h3Gw==
X-Gm-Message-State: AOJu0YyH96WnogN1hUDMeWetw65lcwTo5AqSQbieZrBMiv7iVFu0ud/O
	fN0tI8PAV8di0Im4wWaQSLEhjMExiiv6I5petZgovuqpCTr0kjbXc2WXG7dGgRPeif94oeN0nFa
	MUGlcl7/BLSjPmYVlJoJlGYIC41ri3X8=
X-Gm-Gg: Acq92OEeqgX1jej7lc9SPvFUzcRGtfFWNslEsW1QjrlNxnUbMuYO/pUuDeADLiR68vu
	VG2s2N+Ceuy8h7RLk0rIwSV5eAyRDrpTYMJt7OZdBN2EDbSR0lCtqFJUCZnUB7b+JZnfC5/4XoJ
	0GWhtpICLzy6t+8SdiHKRP7oErIlmewJoyN1TEvkz5ilaVeUcX541JqBq0Ej9Z6KPjFdVcXcyXn
	PThk4wkSznpEkyK/dRyTNuPVQIestx5OUGopEfM9xuV/LrcZj2wuZLAxHG6WMz4RuFV+z0BDG1l
	a7/kWIc65rSUgTahWVRkA4Z6Ps5YSj4yV5+F5rNN
X-Received: by 2002:a05:6402:21c1:b0:67d:a61:52c2 with SMTP id
 4fb4d7f45d1cf-67f713ce119mr3186213a12.23.1778489886407; Mon, 11 May 2026
 01:58:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-1-2f23759a76bc@tencent.com> <CACePvbVNwaU=609oJmAwqxse4WTApj30rU9hB_ym=FLjKMk2PA@mail.gmail.com>
In-Reply-To: <CACePvbVNwaU=609oJmAwqxse4WTApj30rU9hB_ym=FLjKMk2PA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 11 May 2026 16:57:29 +0800
X-Gm-Features: AVHnY4I31doUQo5aj04iakMn-BxF1hUQL6KJfcIRhBpM0p1ftOZPtkKUBT1lgeY
Message-ID: <CAMgjq7CRRxXdjjMCuzWRRgEOgh9rSz9j3o4aR5xfLRRq_7ELDg@mail.gmail.com>
Subject: Re: [PATCH v3 01/12] mm, swap: simplify swap cache allocation helper
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 363D0140003
X-Stat-Signature: ny5u4q6ewirgbbgqy9ftd7mu4rijnwb3
X-HE-Tag: 1778489887-212226
X-HE-Meta: U2FsdGVkX1+sBwyD46PNZTNZkSCYvzcfDTd0w6/fUsGVnSKbwro1OztKkKPQ0FDn1q6QB2WAFCbvVus4mey5rJihRYH+/Zg522WB8++Vb89nM3k+hQqSVrfvYx6Q/vStdANe4wDzeP6WAKB3LRiF3OoucJpUF3hxMDwZ0+JTtDT8DBglP7HskLAfhhnJA70Fl7UWVEaPIQs3kIEyk0SCAlbw/NoVsIkcp2usaMu1FBhQ4o8qc/fojQPnOiOpvOXfgUDNC3xTWmTgRbhN7FdD+qwMs6erhi2k1wX4aLFGwM/r/fQL1R6Yj9hojEHhbMd4AuLT/RU4OBkMrufTNpj5RWLXLAbjQf9ZbyDxEE/17di65jqBtl/4NFvwBQiROStLHtqmCfL48ISxfDCWoVmand5s+EG6cZ/RmKt6ubZ9WFhqJ/VPFZFEHFbSlgMzxBL/3yolkBIXJoCSqGGhfC+VgYbMRipUDGIyP0ZqxbLYSQmGJJOP9le9fq6FxrNHm8FTlUhXVrM6xFWqqkY549FM2LbRKKUStFmlFWVdu4yCTmprahPQsPOON2zUAN9/EXOjt5qRTLXAuS5KIxl++r1k2wsaDxyX14bDRsZv8lqGZyMu+kQGLBmk0d1ic9ekshSfLNYtYPDBpbV08WVNjEkkWAlCXcZUwWXrabEKGFhm1DarQ/mFTu0aVPdZbPd7sMj0RltKshG3J0c6hHN8Zw6MA5KjUYOIBPxsoNWYUp1vRUdFGGGFxLMEhzMKwwyN4XQm8avlV41AXyGwt7JDiBh2z1/+WBARRVoCFlNy6EMBSdlJPaEpL6BYfMVuAx4r28Lrha0D6cD2BokYBzMece0w/PECHHDBJlBNmow6rlXlMoC5VNJK55nOBKSCquIq3PrCCGG0dgxjCfk9+ZbnuCMZIEBwLUrtPc0QVi43VoI/CpTPAJqMcXd6hMhgxeS09fqZtiA05rrut8McTVmyZBU
 QeCLeNYi
 ztNmwE+Ha+mJ/NcHn25q1JThRaumYfVItUeypAe61RAz54N0Nrrvr4sRbzjYxfWYBE/r8bPql/4cL0j5wKeSalQNXxRE5KzerDXzPdhBkTt00WEWz1dkI4PzI+lyn4iv3GWnLWvta5d428cqH0Bbob4Uknc4Ydq825z9zmfbfmF8bZcG0X61JHgeHIXuJMa2O1cwoAxRG+c9Y29rfpUVIfG9oU5JnZ2qz2J6m4ffd7E7Kuvy2csgU8EKxrd0Sc4F/ILJ0ZSZy+pagXVhE/4jWux/B3pdcoJpdik4psIxcPzaR/qosrCGjA9vM9DWxvW5/nBYcXzH/NJo2NDGiKynGfbQuY/XukoENy+3bH0tNQFm4rObHyCjWJ8X70wrBWch3g2to59HR8nwfu9wO8RSsnY0D1nUCf4n4KIYsJOZ3G5oitht/a8h/Lm3RX51LCOBuoI8OD8WaMQZAPUHR7yOgKc+dgOvIT0FWSV9jzqPpBxKsDOf/JgCSUv17GUXEViuqHsfV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 6, 2026 at 9:51=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Instead of trying to return the existing folio if the entry is already
> > cached, simply return an error code if the allocation fails and drop th=
e
>
> Nitpick: Spell out which function changes the return type here. It is
> __swap_cache_prepare_and_add()

Good idea.

>
> > output argument. And introduce proper wrappers that handle the
>
> Nitpick: Spell out the helper function. It is swap_cache_read_folio().
> > allocation failure in different ways.
>
> >
> > For async swapin and readahead, the caller only wants to ensure that a
> > swap-in read is issued when the allocation succeeded. And for zswap swa=
p
> > out, the caller will abort if the allocation failed because the entry i=
s
> > gone or cached already.
>
> Should you add no functional change expected?

Yes indeed, there is no functional change.

>
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Very nice clean ups. I like it. Here are some nitpicks; feel free to
> ignore them.
>
> Acked-by: Chris Li <chrisl@kerel.org>

Thanks.

>
> Nitpick: IS_ERR() only checks that the pointer is in the error code
> range. If the pointer is -EEXIST, it will always be in the error code
> range. I think the "IS_ERR(folio)" test can be dropped.

Agreed. Actually, I didn't add IS_ERR in V1 then Sashiko complained
that it should be added. I just checked the API documentation again
and existing patterns, there is indeed no rule to prohibit the direct
check. Let me drop it, I also like it better that way, and maybe just
ignore Sashiko next time.

