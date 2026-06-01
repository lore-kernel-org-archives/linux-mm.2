Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C50CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 00:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A286B019E; Sun, 31 May 2026 20:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B496B019F; Sun, 31 May 2026 20:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FAC26B01A0; Sun, 31 May 2026 20:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA7C6B019E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:59:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4037A054E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:59:32 +0000 (UTC)
X-FDA: 84829535784.09.9A545A1
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id E3FBB40008
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:59:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=asQuIviA;
	spf=pass (imf11.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780275571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyqeB19kxUlpKMWF1rvolEO9Vi+DzTQ1zW8ewnICTgM=;
	b=BXUj/3KpFkoGIJt0OK6A0821M6BxabQLcUtrYZkVARYVwaaDnYdr+RfyyNzW9BvfZaEL3c
	GHawRY29kleNWcBok9eXsKUxGZR2bYYJ+Gvv2NPQMPNKRB1w0buB8mjm4dzceTsiq0QQ9H
	hNiaPGTFeFHieKAtR7mMY2eP8WiK55M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780275571; a=rsa-sha256;
	cv=pass;
	b=1LE5OMteH9XOaYXZk288pabWIIfp4R010erIqeZvTIVX89kpwSMyAS/edv/cc6HFD5gO+k
	jNjzikszOAZj7zPVDokE/GRJsHygc2ExmebX63KujRhBjGRtOl2ke3oL39XPgBxg9ZjWX7
	UPcZdFkq3ycGuywgaQIXT46S+vpSLQQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=asQuIviA;
	spf=pass (imf11.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aa61e3d3f3so1372625e87.0
        for <linux-mm@kvack.org>; Sun, 31 May 2026 17:59:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780275569; cv=none;
        d=google.com; s=arc-20240605;
        b=eOmlDGEfAcDNCnxAAGm0hwylsL+dXURoWaFfvVLBs3/ssa7VmexdvhyBHllDohVGuE
         sGLTuO1s+cpJvQy6NxFsbpWkMI4iJwK4eWrfxcd4SSlpUzJAG5EaMfaNaiqcxVupn4QF
         Ux4BcHZy9fLd4s1y0T5I+wqofbRywvYTequT3BUy+ZvuveUCL3Q6FeQh3rH6ZAEouOkd
         aIXFNhU9k76Te7y4HHJOqQ+hoqar4H2bRuEjdBPMa8BV1EDU4qjQedDOkRGdj+HvXWlk
         SsWLzAD1rOcmGFQBDuEHFrLSee6BVeDyTttxR/+Nxf4YqQiVl2ukbF3LxnbaZmIEUQo0
         ykUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vyqeB19kxUlpKMWF1rvolEO9Vi+DzTQ1zW8ewnICTgM=;
        fh=/8QbyxLbVby3P92vES+qpM0uiNrIUnrlvToR2HRzFj4=;
        b=hm7roc0vliKhihFinlCtv3ezOTrlz5fWID64gVxSgQLbQwj4pu98jgZ69EnnExijF0
         BT15j3cHHUG4vEUh030TO5KxWWPqalszFzdsm9iFxE+rFPfJ3wnKPsMNbLNZvD6jWVlz
         XntijN7g8tpjUiftBe1WyhOHUxrMvBoFni/0DwlbSopR9nacGvHHzG2w7EKZs5A+FF6x
         boDnci/QKNhMCCMQ00LiR4mNtjwRr2AbPvJ03gVu1S5u/bE9nFHx+06OJQTU09Xoryz8
         fhha6MZudp5lTvQkWog0X9MJC2Ot8bGP0dcnhcSBIA2f+YmBCSu5HK2Qkf59Cpi1G4TJ
         0sZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780275569; x=1780880369; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vyqeB19kxUlpKMWF1rvolEO9Vi+DzTQ1zW8ewnICTgM=;
        b=asQuIviAFmu4DxEQk9n1leosl5Woegi3OQR62H/22wS4Ahv3VfyI9wEN/N5BkyrVxb
         27rb1sRs8Gd6K64jzjNjitbYs9iKDElkB5lTqlS9acu8O7rlgIVy+5ergyU3dTEs1ol9
         x6uElWIYMZWlME0cOFrCTqG3rKzD0DzfDwuqEutT89yKY5SfqgtrPxExo7xUOvugT1Pe
         sCfm/+v+XOtdVfBf4GK4QLxjc1RXDX3Ge8tiwrZCymHlo0RCdHHz9uzoXwpV3QrEbISY
         wKSFlF7YlogoUm8Lqxvwy0+eLEPHb3EToMMBNyYB3rnAmfyXoJ7zeH356fLycn9zqWPx
         DOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780275569; x=1780880369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vyqeB19kxUlpKMWF1rvolEO9Vi+DzTQ1zW8ewnICTgM=;
        b=i6rvLFCaLAoLg+8ykncfEPCdVwlJ7s2/G0/+rdPnqjqlPI3Dc/Kv6BYVazIq9vOk6j
         aWnejDBoh3PGCoZAKtCOx9cbbSpDrxrk0ezb6zmxV/U/Gl2ShxSNKxX+7KzhO6aIPAis
         dazaCw3+M5WvxT2dBP2VpCf7vwQxkRlYKETxII99UZTVBjxoXJpHAor46ZzAp63CEgy0
         xckaPl6t+W+WTExwhGbRi9oXCv5PlTyCg6JBGZpAIdPwqjL+KrQ7QaEqwMiiMgRi7ory
         UNGkII25n4BV6gqysu+9PiPKaMvtKpYLRyZgYo8e6fo0QkfhVZvLVekISSyY5iX3vYDt
         uLjw==
X-Forwarded-Encrypted: i=1; AFNElJ8niXtwBFCbC/1TAvMpbXMZ4ThKcZ3yccXMB5o3DqF+/kP2I7UQtloQrZ99iowWWl+KnPsRCYB6jg==@kvack.org
X-Gm-Message-State: AOJu0Yy404/2DgxBw4FhEf9CaGTYSYc5TeCmgnALhJhpqQXhzHq9rCmN
	6/9OxWuXhnuu86j8VJH7XDQveGc2XdykNrXwDZBDDuwgHcVhEpPLX0YUrzIMmDPiCMhrGJQcQu8
	JOzx5W8FBtW2wZpr/5V4rymfw+wGzRsE=
X-Gm-Gg: Acq92OHHks9Z6gooPhy8hzIyrroCnBmChIaxJKSsBIy4o2V0xD8O2f/FnmyjF44Y6oV
	RdHlWWdy9k3DY9EBo7JvxEEFTyHLj+zhs97HdHWnUBPrixIPe7tf58YraarP8ME9m9a0C2XwG9L
	RA8GAuBidkYquVWrsHodF8G860E/yAkWWnLh0Cn3E/rlLLVzlyWvI5AtTiOB0a2Rokk3wVeh+zw
	cRAFRHNurZhRkN8zVndKs+Ja+YrQRd/ox8cjlCm4c4+nZn/GnoGBOI5fld24qkhX/DQTVWQ5HNR
	1+jgQxYftSYzrRFH3vcT9JFXlsbtFr0gQMiEXI1M2Evefgaub2/87P2WLw==
X-Received: by 2002:a05:6512:4017:b0:5aa:6df7:4ea9 with SMTP id
 2adb3069b0e04-5aa6df74edamr161498e87.35.1780275569095; Sun, 31 May 2026
 17:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
 <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-1-1b9a4ac255b4@gmail.com> <CAGsJ_4y8UWWwCSZ86rQnW9wgPMRg2Eo2e+6jw3kWPVZf7zgx7w@mail.gmail.com>
In-Reply-To: <CAGsJ_4y8UWWwCSZ86rQnW9wgPMRg2Eo2e+6jw3kWPVZf7zgx7w@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Mon, 1 Jun 2026 08:59:15 +0800
X-Gm-Features: AVHnY4IxMIgpMK3MIqZFSMUuxShQ1VJB3FByy8aXZtXSF0_gb7kFxn62yFJsTkE
Message-ID: <CAJxJ_jiOXighxyE7yKw+WF1hZzp8v2zEVjUtz6mgrvT5BaenzA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/swap: colocate page-cluster sysctl with swap readahead
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E3FBB40008
X-Stat-Signature: hjd35jytkck6dk6d1933awy1636y4z7i
X-Rspamd-Server: rspam06
X-HE-Tag: 1780275570-680941
X-HE-Meta: U2FsdGVkX1/RjhXK0cJHmTLHh2QeylEbC0fYzIzQnXcHLpuw50kdYX0ztMh2v7JvtKflq7kKhgmT3dLa1nF6DrlImmdsWXPMenxv7vkOJr35jn4tFQ3tXz/+cA1h3gtX/hPwFZNngmld6xJXROtjN8Gq4HUEGNvrboizQKXTxwTnDAU1j0I/i2yVdRG5KYu550BDCevxMXO4UVgzAr5VzIReWyy6IH+vfRNinhCEKcwslGda4GeUOtScsT75dfy079y1P4TbTh+YTIjzKlq+GM/kyrmIcbYiGFVum8xO9kpJYIbxEp0sj7zswCcGkJME3T2/4Su68V1k2OlYBnzCkGRnYISGXNfjKDuGZ1sSRKwOHljdxYcgclsYim+xZ8P1hI1zZ4U542TbehvciiqOncf4IqybXCK53ASikvgPhSR4T0V4636HtPxqW9lMY7HO1l2i2r1/qvoVIhI3KNqjEtxUqENrWAAaEgMmP4uCXNa0poIF7rSnylqbG6gw8UjUjdKcpZojvbmuDDidKRtzZaH/8uhtD3KrsbVA7cjrxsHfCCursfjqCL7tr0tiC4Hkq4ovGfA4hF6q1mhXGJp3hyMkABFMMJux4E6ZhRMucDoMfbQDyrbg/9GEHi5FgyCfAAIGP7cvFBaVAYs+Wv0Jt1b1Zejx6tHpPn+JpFGhKJ06CmKtvuV9stin3Ji1foIDgdlZ3SzB7W/SlqY0YjBc+lg3oqQXPny+IE/27sB24SRTUAzFUOfXHHhx2VmT2oFrmGUYsrkeRwL+13MRprAUvxWXkT0MfSgW9Lvu2AKKOls4eWLS2elgk1uE5ZCpVPB7HpkRLOCyXD3jJG2ZLOQB6w3o7qPOjNEkO9T2WsIrQQ+DNRQYC1/wo7IHblJKC4CifcwhJuR1DWAvqDwRcInSW34FgZc1kU7+p0y7RD3d0onbYV6tqgTQBhRY7sHZGW1T6VpbO3VWFLtDR5FOjuS
 b5uIUFwr
 dXOaU6PpSbpDvMZ2/CbDEf4l5BQ0PrWcE71H4WKqvcHBJtI2ffa9ldf+andLx+JbqyHX+e73SJSNhtzkHw8asLimS7zv3fAeB2VEQ8c0/Dcptg8e+MvLDUnpmAI4jKnFMTAkDoz7Ltpc+WfNVvwJIwiVzJe4sf2y4yU0LgHS8tJ01CVbEdbRVSyRsawkKsgSvqoAE9b4glgNHmR3lErErEcCVs8Ogu0+g2poPVsfpZEEBwAvlK3O25h86hrTqqkEKhF50p81YyN8DiZFDZjvDkD1da67P01Nh1YUewUfo310jo1/91M7HkOrEfTgtJCSDbpMRStO7QWLH53Kk1mSvrmvHbiXhDjFHo9I0ikOJGzE7NZhtu0fs2xEDLGI2GMJLHa646KmO34KEt+hiNB5jDbupEv+KargipxM9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/2026 6:06 AM, Barry Song wrote:
> On Sun, May 31, 2026 at 5:50=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.co=
m> wrote:
>>
>> page_cluster and the vm.page-cluster sysctl are only used by swap-in
>> readahead in swap_state.c. Move them out of swap.c together with
>> swap_readahead_setup(), and make page_cluster static to that file.
>>
>> Rename swap_setup() while moving it as well. The helper is internal to
>> MM and now only sets up swap readahead defaults and its sysctl hook, so
>> the more specific name matches its reduced scope.
>>
>> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
>> ---
>>   include/linux/swap.h |  2 +-
>>   mm/swap.c            | 36 ------------------------------------
>>   mm/swap.h            |  2 --
>>   mm/swap_state.c      | 37 +++++++++++++++++++++++++++++++++++++
>>   mm/vmscan.c          |  2 +-
>>   5 files changed, 39 insertions(+), 40 deletions(-)
>>
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 636d94108166..c36f72877e8b 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -345,7 +345,7 @@ extern void lru_add_drain_cpu_zone(struct zone *zone=
);
>>   extern void lru_add_drain_all(void);
>>   void folio_deactivate(struct folio *folio);
>>   void folio_mark_lazyfree(struct folio *folio);
>> -extern void swap_setup(void);
>> +extern void swap_readahead_setup(void);
>
> Can we move this to mm/swap.h?

Yes, that makes sense.  swap_readahead_setup() is only used inside
mm/, and mm/vmscan.c already includes mm/swap.h, so it does not need to
stay in include/linux/swap.h.

I will move the prototype to mm/swap.h in v3.  While doing that, I will
also add a CONFIG_SWAP=3Dn stub, because swap_state.o is only built when
CONFIG_SWAP is enabled, while kswapd_init() is built unconditionally.

Thanks,
Best regards,
Jianyue

