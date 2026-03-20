Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F5F51093192
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E1396B009B; Fri, 20 Mar 2026 05:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991E06B009D; Fri, 20 Mar 2026 05:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F9B6B009F; Fri, 20 Mar 2026 05:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B67C6B009B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:30:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DC73B30DF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:30:44 +0000 (UTC)
X-FDA: 84565921608.03.AA79528
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 20D2F140009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:30:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fBnyZjOM;
	spf=pass (imf26.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773999042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bucVI1kbkal27n+swcxnsTUDAJLlsUl8ppV+SYXvR/8=;
	b=M9cxpQqfpbRgRhm5kaEadieB11coyWWJhyyC+uO+Syd2u/2EwHEmarFfwVorr8suEvzlVI
	bD71o+gY6zfGS918hIjLBf88Nw29agd6xmVbSX1o0wrbMFzBU51UGVdS5V5QlLPU8nd0YU
	6kP/5sO6fAZLXFMxe3ljWxqXVXY+jWk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fBnyZjOM;
	spf=pass (imf26.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773999042; a=rsa-sha256;
	cv=pass;
	b=C7ndA7Vb0ca9v1pOcZcKzzCy77cGmRYdMiHA785hiFvxlUIu0el+EumC7mXu8NgqbR2TCO
	JN7JeX3F+nLcQxpfVEhWdvQPCXeEDMMCas7k+LNJfdo2EMVrQ8OAbUaxrGj7VjZBPmGB9l
	mk1C1pKkdL1ohCUCUZbN+G2fm1WUpmQ=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5a284984dc0so77303e87.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:30:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773999040; cv=none;
        d=google.com; s=arc-20240605;
        b=irazarxjb5Wzn7/34h/iXh5Q5AJZJdMFB95FRAL5KpcmVV51nKxv88VAl09UCXd3sQ
         jDEvit8ZqV+GYI/Mz4VQ0XHnIxyriUTDzfdMBSfoY8aX6KsYBxd2+3CdWoJkVA368YVW
         i1WJ740pENcdmrKJjsKSpVPVHTLQxO6+9mRTI8yGVB1Fsj8j6oYzs53taFSgLtI87XkY
         60OarsXdbiy4v2BmVtRmY2ZT++RlkJmwPuNVsXB5+eZEUX7u5g/kOtIcObgrkVzFDzpy
         rae5nIW8xO31BCispUw8qYB6/sLKUG096NekexWqqNOcNQVUieu7CwLREeXOB7m0pdmb
         tXyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bucVI1kbkal27n+swcxnsTUDAJLlsUl8ppV+SYXvR/8=;
        fh=rQRyTOo7EfG7nbaql6o30bZAO0uQ3n5QHlponzUHy1U=;
        b=M22rnBRo11ta+8hcxfnSxDD5JfZCx/WDTfeNyq94BtNZyBSrfnce1HLrKRy8A3grSc
         tNyLWLgwcv230Pc4LwzmeGGgIixSX2eePb+8PWz9AsLhlE42nG+RDDyXLwPap+sFNzNF
         IeMoPIT1IsLY84DEVsFvns40chDfACdHOwcYB50jtmJeOV4eYkgnZZH3m53LZz2wEwmI
         U4qZXiWdPtU5zCbYH1h99SAKM/NnZgPA1lWSfUBwQ6/iSsQxkln7ht180BJ4Un4hAhv7
         Vxs5ZYVKODCrHxAbLe7DA7qlfF5Ji6Ok77rr10UYXxBDGN40/BSrV817J6eV8nPupcSz
         LIjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773999040; x=1774603840; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bucVI1kbkal27n+swcxnsTUDAJLlsUl8ppV+SYXvR/8=;
        b=fBnyZjOM+ATgFeZG+QDmYS9N2Ic6ZrGxQ9ZhMoPcapTNfzPWyDizsyzQW/I8n++Yff
         zR2o5aH9a7/1tx+l15YXZWNYtLRvYoHQFWjaoV/q5rvERfo9ceoqQ4zH5WBO3kz961Of
         qh1dsDDsgW7Rj/tAdYwLiCyd0xWru9kI/I8yDA0GpWmn3YlqIqukZGIe+ZOPdTSFkwOr
         ZnV8WH0mC2zPcYDN53+PCCNEnWGwpcQFKwfKWnUe0BuyXACyoUaRE+pI48pharXORctu
         OiV3fTrFgdBor9xPTrY5zFp8cwkgha0z+ROZDNh3uRIlWCcx0+K8k7G8gEVGs4dTOWZp
         zzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773999040; x=1774603840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bucVI1kbkal27n+swcxnsTUDAJLlsUl8ppV+SYXvR/8=;
        b=f0covH2Rzzb3AcZhee3dswq4ZisFCSxxvF4Xv/yBa3/o0Nl8VECS4x4mFOxwFb/TvR
         uwVcfEuI3HC7/Gzc2t1cCvkD5FEWri3GspZHSn38HxMt06N4RFYR9e423u9ldF0fnGVc
         D0FklZbnN65sWWzDnlFW3axHdzijVthuE7BLmay4iu72uraMeXOnHd3RibFoIArrmfTN
         RNzipj2HLuJc22ZpA1aISL3o/yVuk1wzj4TvbSSSf/0/v9fr6RPDT2vOFfmB4rMZnqnm
         X3BmTXhuO7sIgAoDC2zwh5NWtO7LjeKXa5y2iJzjE8basiOL8gmQGna3uvi+sgjztQeC
         t4Rg==
X-Forwarded-Encrypted: i=1; AJvYcCW6XWn76kQin8vRuMjhn+xbGswdS30sxzIMbVbgN+pvsr41j7RbavMKFTcbmkgjMiu1ZkK6ObVaEA==@kvack.org
X-Gm-Message-State: AOJu0YyCX2sx4Yha6HQMfM6eqUXqo5o08S8rR8v2lmSqn6UxIhdKcrf2
	0rqt1p9JWT+ITppavxdTKm6zDVsZBDFw2hGEFTgix/BcN/yWEf6CAuc1zr7YXJ+c/uQPViKLmIK
	8IXc6F/k29KkTipUC+tQv7CN9ZhbtAW4=
X-Gm-Gg: ATEYQzys3pYATJf+f2nENN9mbfrlfc/ZBpR4DKCetxg+yhOqdPdLJ0baZJptKkt7pjE
	yNsbxeS3dGmP3FiNfosMV2KtuZHfxwAWxls4Wtyc+1jimKhI/86FHzeeZzRi0iyyUHp6EbvN2Fc
	O3ylR6CvHCJPbQZXGwnpZYXCNCVZnxQJXAfvgdHWAVoIHZiEcK48LpKGIIm3N4wjKM2LH51kAw3
	NmgXZa8WRLt28L5QW51MS5QFvs62Id557xrN4rlCOFl6tVeOkCfHWMSCjMv8xwwTLwFy5Nty1Ca
	T8/XF5a1yAAkcb3iEvs=
X-Received: by 2002:a05:651c:2124:b0:37e:566d:7fb9 with SMTP id
 38308e7fff4ca-38bf96211b7mr4361871fa.1.1773999039533; Fri, 20 Mar 2026
 02:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260320083339.1813195-1-zhaoyang.huang@unisoc.com> <CAMgjq7Bhi_2cgWUWpW+nh4dK2B9N_AbtUf+EJCwBF-d5rvFySw@mail.gmail.com>
In-Reply-To: <CAMgjq7Bhi_2cgWUWpW+nh4dK2B9N_AbtUf+EJCwBF-d5rvFySw@mail.gmail.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Fri, 20 Mar 2026 17:30:26 +0800
X-Gm-Features: AaiRm533QbVEQiQx2NCymhv3NrQ5Nf9EKont02oS-jDhPMg0v9iU9ViZ8ZVOpyI
Message-ID: <CAGWkznHph7dp2qSiQRne=nOiiB5QJKaRNCd01LkMfHt=81NvBw@mail.gmail.com>
Subject: Re: [PATCH] mm: skip dirty file folios during isolation of legacy LRU
To: Kairui Song <ryncsn@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Matthew Wilcox <willy@infradead.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20D2F140009
X-Stat-Signature: 6qju7ozidsuf5kxtfumkpefccrw5msuy
X-Rspam-User: 
X-HE-Tag: 1773999041-74866
X-HE-Meta: U2FsdGVkX19Op/atEQDuj4pk869ABCljxEup3toSlkl3vVCV20dODwCQ2JAgdIzYh6+fghLUpMH87R52fxq58RzTPUL0XRSZKTVR6Lr1SGfA+jEfg/N8YHN7pIqPMgoHoanvTy1sfWND7Ep+q64GHbxx+2zJVpQbUywLuPKSlywgXvvlaTY2uErEi0TtPztNYij2TwpQbI241ukfsyZuzlbJLnJWZysplKO6dGKvQPlNBYIld0gQuXNk2NtWuimygORqMf83AGb6UtHOeYcAUiHU9FsDQ5SqaNTwO5Jfpilb7yMjLcWWHXM/DlGVXRRF5cTvJ+McjxpGGO2O3KGKaq75wMfguqt3RQ9RC+YO01/icC6Ph9Zho8vyMdNpNgutPYsSq03cUJNHgC5aXQmcGYf2CYsRnI+JqhQD3NaiPau2hcDSUTVfafzrkGDzn/xxdBFgoLxs28xmqJ3C30ryB0801yx+OdUOjFKr31ecL2LvlyDGSc1DxooVPlmyAzLAht2TIUHTIF4p1EJQyp1BgSEZGR2Lz2MarJ++62vAElDzmFTwrSkfWxyQ/yT1UDcYIuj/Y/OBUCKtA4KCfJfoY+6G0LufzVyoNi1WYW69xw7tgvbmJtS855xy92qiDt1N73OTjpOGLc/72F4DsTg7WX4ZJlL//kwB1+PnHf1PFqgZGy/wqj3gwohYnX6oSXhG0nqm57Z4x9TCTXu/wUhVf9EdsGTuNW8yaJiw3HP97gNam38EzSsI4ArGOI3Fp1Pgk82YoRI7tF2oniduF09Z99zymYmVSRhrwTX/Syx7i9Kf4+PXlad2JyLGBmOsgPsWg6rZXLKFgQvOHFGHvapcWNsGU0n4lce8yJfWS0GR5vyTk8GyPqylCmoaX5NGs0JyEOq4G+XdUBBTyKmSOlS9mUjEWBtoA4+9wcFsDzP3cG+3yhwHw03A3/FlU344c2id5kpWD9oKP1Mu2bnjMM1
 CuYbJ0I7
 cjidIaFjqv2T4q1ERa/OH2cnVL6TC+fTyNYR8CzXN552v3w2KHpOz0oED2vnc42Z3N5H3Qg3+dmYS6Cg5JGgNNjsZ1uZtfmqKRoKpIfRsCrMydTTcLYJqEhjRK/IvKamzRgaei6+/n0KynSTkPNP+kiFs/7Z+o9yXJFoWRaWkGmbJQO9v1oEr8O1U0jMMZyvJZlmJYaInAAPK+ppTjhMf7MyvC6th4S9cMqjQFhBH2hXdrsrKwlR3ceWIki7PwilraG6dUuH1E3le46rLJlrFFxyVeB0VU58CmIhBbrz1OWIMzYd34zzsnsVRi05w8WS9wT7y/0hbIdbH5o2rVASAKc23DqM4xeLWk7eWH3299NyRl0m2D0tU8jixLfP1wU3rhGmB42eIsgOFpVD2/EOnBPM97P7bQTmgik1uygQkjGfKMkyPgJhT0Eb57O+k03c+gxgto+gDK4M/8PBqg7Q7UFa/oLGoISlwBR3xP8jMHQtLg5AMzrjSFf1lLmJFoYWtcqIQ+z1e2SN6W4ce1kA0lMHW8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 5:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Mar 20, 2026 at 4:34=E2=80=AFPM zhaoyang.huang
> <zhaoyang.huang@unisoc.com> wrote:
> >
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> Hi Zhaoyang,
>
> > Since dirty file folios are no longer writeout in reclaiming after
> > 'commit 84798514db50 ("mm: Remove swap_writepage() and
> > shmem_writepage()")', there is no need to isolate them which could help
> > to improve the scan efficiency and decrease the unnecessary TLB flush.
>
> But you are still isolating them with this patch, you just adjusted
> where the statistical update happens.
>
> And this is kind of opposite thing to what I'm trying to do here:
> https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508=
@tencent.com/
>
> > This commit would like to bring the dirty file folios detection forward
> > to isolation phase as well as the statistics which could affect wakeup
> > the flusher thread under legacy LRU. In terms of MGLRU, the dirty file
> > folios have been brought to younger gen when sort_folios.
>
> If you really just skip isolating them, it could cause a regression:
> skipping the isolate and put it back will cause some ping pong effect
> on writeback / dirty folios as they will be stuck at inactive list. It
> will instead decrease scan efficiency.
>
> Currently shrink_folio_list will reactivate them and set the
> PG_reclaim flag. They will be deactivated by writeback callback.
> Simply changing that and the flusher wakeup logic could be a bad idea.
> You can check the link above and see the benchmark result.
>
> And for under writeback folios, there is no IPI flush or unmap as it
> was returned early. For dirty file folios they are unmapped indeed,
> but following flush should reclaim them anyway.
>
> It might be a good idea to skip the unmmap part for dirty file folio?
> Maybe, some benchmark is needed.
>
> >         while (scan < nr_to_scan && !list_empty(src)) {
> >                 struct list_head *move_to =3D src;
> > +               bool dirty, writeback;
> >                 struct folio *folio;
> >
> >                 folio =3D lru_to_folio(src);
> > @@ -1749,6 +1731,30 @@ static unsigned long isolate_lru_folios(unsigned=
 long nr_to_scan,
> >                  */
> >                 scan +=3D nr_pages;
> >
> > +               if (!folio_trylock(folio))
> > +                       goto move;
> > +               /*
> > +                * The number of dirty pages determines if a node is ma=
rked
> > +                * reclaim_congested. kswapd will stall and start writi=
ng
> > +                * folios if the tail of the LRU is all dirty unqueued =
folios.
> > +                */
> > +               folio_check_dirty_writeback(folio, &dirty, &writeback);
> > +               folio_unlock(folio);
>
> For LRU contention, to force active you always have to take it off the
> LRU first, folio_activate will take them off and touch LRU lock
> anyway. And now here, there is more work under lruvec lock and it is
> also trying to lock the folio under the lruvec lock. The LRU
> contention might get worse.
Thanks for the information and agree with you, it seems that the
simple and right thing is to have dirty folios skip try_to_unmap to
save TLB flush
>
> And the wakeup below seems very wrong, you just can't throttle or wait
> or sleep under LRU lock.
oh, sorry for the stupid change, I don't confirm the context for lock issue

