Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2678C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 21:31:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B927C6B008C; Mon, 24 Aug 2026 17:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42526B0092; Mon, 24 Aug 2026 17:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31CA6B0096; Mon, 24 Aug 2026 17:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8264B6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:31:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C7B3C027B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:31:33 +0000 (UTC)
X-FDA: 85137459666.13.DC6F4B3
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C88E1C0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:31:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=egIxpmta;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787607091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwuBEBnZB8YTVmGcPOdxFw7ZwLMAxP26w8gq8guPh/o=;
	b=Dl1ZiZtAjrhtct21dq4pBs6NTGp/MzJSqIuhAeqm4TTOsXjrd9YdzuyUz2fcHFbt5vIcia
	3IYkGq+SMZ4hnCn2FE+sqcbLuxIXXci8dEjDTf/bZgXUgF/1eyGItnq8XX7ZgpCnCfAUMK
	+YiKEtL2PEq5r26giOEvPKSkg5RGLd8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=egIxpmta;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787607091;
	b=QYwujJAAs2l67zI5GOOD+rHYvQZ3IDeIYAT7gXix0hGVHYq/R/rBGzbxnajS0J2JwwQE7J
	1GTUql3WHS6P2hcndBbGdbmEz9X1XCvlsPhgIKW2KQi6SmvNdT3GNNTxwhpUIdHd+I/lyM
	BrhFkV4hLVrqQgUBSP8kueSTgfrYX4A=
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4a483a552efso2118727b6e.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787607090; x=1788211890; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FwuBEBnZB8YTVmGcPOdxFw7ZwLMAxP26w8gq8guPh/o=;
        b=egIxpmta9JZJBKcqRS0I1TKIvtO/i4JhdWeKTEdAnd70gmU5QjZJgitKu0md5dPRr5
         gpleAJ6nCtqAgcx4XU+akNqzp8G6smvnPbVtCpzjcL0Dq+7PBvEQ0PN1UXn0HqOV6HmE
         FV48mDSTGH63NfQXALJXCIIuG86MWhaBJB8RTytiRzZVsUllmOG47Bxvo+7bkO2UKBCu
         TJd2BCibCYholyfz7zQurpfarH4+n+QMrS3EtFQeoh3MwrkE5XD+An+0zu5DU/xDGCVt
         vk0zWGjQZyb2U3IhkGvZtQMBBkPrVM8gbN7o3V4bpbRUqv4yIeCBQX1MPjMlLrK5F6+a
         Zx+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787607090; x=1788211890;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FwuBEBnZB8YTVmGcPOdxFw7ZwLMAxP26w8gq8guPh/o=;
        b=YEjNoNQ/iDu1n+19LBlSr1tLqrQOL+abH1kiO4GiwonBfpMpzd6EiRozjx+fEj2yDz
         DaBGt/WOWcYhAd2Vq0iw8Il/zQmB+pfvaG1sjSDu3xjPaEIjlTC7vVzWjKkh3pcWuuIs
         D0hPpkgxNmzhxFmbRVmD1koKJh942F02r3Rrz/hpvGxCKbMYL5g2VR+Rnw2I0P7bz/t3
         3T1dYumMgsxOaDwzvi/gXEbVm5A6hGrhp1i2+eHfXL1Wb1QdSAaOxcu4ISaFVn6CJ+96
         5DLFd7GcPo0qq03zuK0EsCmjYG6cT59z3sHSHFtn12PWA8g0gqA0+cMiNeTvYPY8hNrA
         jrDw==
X-Forwarded-Encrypted: i=1; AHgh+RoEI41uhbgjw6WNKm632s7u41hguQj3Xsb67atzLEZSbcyfTSViQx5sXhzNlrElAZ1H/vsOER8C6A==@kvack.org
X-Gm-Message-State: AFuF++lTcWHAmU9BiKF5hHWAfn4jDe+1wrdKYtatXYiGgD4cLVledt1h
	0YMsS4zMUOeJ2sP6ctAkmVZHk4V0HXd+U20Hgg1IxHeAireUhWEcK5b5
X-Gm-Gg: AR+sD10bIJMeY3DlOTH03lcJi55SprTYsmzz3AGSks9pOGmNZToLm6pSyutj3lt3pmx
	AjhEnNwVPTcex69FlDtsqSme0OfPLrzMcvuJdGgKrnloCJu1G3Aha6sq90Z81y8BnUlZfHWpW+4
	uID2piuqqJizGAsaVg+oQ1olTqqJYDRQi2Bx6ksF6NLoyf3+PN6i7s/FQal0jhqaDGIzukVNBYc
	/A75NVfZGaQiivylKweX5VyMdVwr+qVs20dcoDYIE9a0/nwHCct7URDNba3pDUPcLGd3hhmKRIL
	5toMhSdNovlogPDPrgW4cb7iMjXWDV+NgARm4vBTWUYc3fZa2eqvs3h31DHYkRdGozpGpdE5Jcm
	ey6kLc+kLAHmZX/nTReUXJZhPgJ9kYFFk1tvfovSh65h/r8aCX31azT0TOVxHgKmRviTh2YtbxM
	EQYu/BIgqpVVi0D35hzXCww+UEZoLHCIcVwFfIWPGjgwFgR1fbaGtot4+sQbY+7tnYyRDjRVdyV
	l+wymCkNQn2hu3SPSA=
X-Received: by 2002:a05:6808:1b0c:b0:4a4:744:a4ff with SMTP id 5614622812f47-4b30998976bmr18801430b6e.4.1787607089949;
        Mon, 24 Aug 2026 14:31:29 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:23::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c64a07bsm3949888b6e.4.2026.08.24.14.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 14:31:29 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>,
	Song Hu <husong@kylinos.cn>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	yunzhao@cloudflare.com
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
Date: Mon, 24 Aug 2026 14:31:25 -0700
Message-ID: <20260824213127.2783019-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAJnrk1bFq7J7K0=X67voeZVkAb0dmiLkqomuQ+VcXBLyP5hMVg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C88E1C0003
X-Stat-Signature: magnwu775yowg7541jmewqk1add7x4de
X-Rspam-User: 
X-HE-Tag: 1787607091-467965
X-HE-Meta: U2FsdGVkX19SeMq8FXglk3Tut7OQG6fFlYVEEWRVKVQ/4kJmboFYq3D3RrgZiXVSXfCoxsSudFuclBt9Rle/FOnd5D5nXACZNNLqaIGzZHWMyeCA8m3UfwOe+80tJ0s60XQqZQeRVXGgSXdvhUXTq3wyW6RBKWgdc0OxrZ3qYN8bEm+zfoptg17qsjSAbXFP/U7eHjolzFvgRswrQSPKMQgx+WH9Vp/46lF2lPu9Yn87FMW2PKWzUBIqjSvBlF14Qt7xAJNK263ZdW5XBQc8NJMdd0SN39afMUIFKkjCx7+oe2RipwaTQHspCeUgMtYL6+W0w1nEG0Gc7njPHB9ZOjWaRBDm1vwNznvwnhpdL3k7tB+DurrmDdbC0XNnEPwytQkK/Ff7+YT9uDs3CY3lutpCIii7ZHmNha65wquCbZsCkHMYyF5qlU8NPRp0NDWD1dBRjYq5hyTWt9/DVhBk12TD6BcI8WtEaK4WXhi7BvQa/Q6M6vEWi2cJZXPw5aTokbgqahPjvExFJf2bGH8Sy43Ju7ZtBmCDBSxP8vLgyZM1mgOxeOW7tCFdg87u4YmbT63Gm3Mq8GPbKL6lMRtonM/KBiOZZQdo/BiOZ/DJfqmw53jK0kgPyWkeYTNiQ5fmvQ7CV6AAdVf6Mb/+FysiiLU5wmvXoYJLLN1TVUTsCOPpAaEfVW9S7ho9JeA3GIH1S33wn2NZIhMZ+Xx00JQMR42tcDCj9j8UMEGCT/n1FW5JePovINa7UI/5QoLONRFWptVHvmjfkjlJ1xVJUCk6AT9kG1rvoeSh/KVm55oia17j9I3EYkDWCRvkHv9QmPi9QcX/tWL+Uw9zQeSDQXHd5psV7y4yNPgEeOzvKDb367x8ONREOmnHFcpnlxa67pEyFrASktjYYLLXEXseaNIrT5NFzmPfAxXO3shqjCMQkixAnSI/HwJPciuo6SwBoZCTwH7OU6noRFROe3ISGqQ
 8RlAThaz
 /sBM9evhCXlNrgUZmye/lYu413+lHSACceG57yasz/HtPP0is5n/wampD+3lTWdJDN8pvAK0VHmrj48DABLK5jravL9nT1pSS/uFjsxZDzGM4QL5jhGK4ZzSvj5Ya/ZZqHLHs01Gm7Ud+8KAXGSJpjVhgxb1uWTGZQ4I3MgbvlrajT1QzDki1856p/yuElp7KszHG/o9x/STrLzwSgsU5k78ckomh9MLsyyiHcYNNNCrBnwKS64GRGTVwABuwyBJ1sg0G35PPuecajRAmUJsSa5iBXY4/PoWgoJ8XO1YYWBBpkr9+jNnDHU++yXJs58IO/Q4+3tpR+t1iyMLjAifMcAricbZl5BvF0o3LDDZJ0G9zSFWtUH6bvsT17K1xt0MXpIDJUC547AySJiK9inOZcgiP2t6dJsVLjiwMq6QkUjiC2TMAvQ+6UWL6Q1PlwWovVPPEJ5W2ricM7tatAa9vNRxMhz6dqQbt4BMqssnblJt2xK4SU4vnoi21hgXz1Rrko/Rx8FYKdScnrGTqG8GHSLLZBl4/bYekZ8kbwA57FBiFyLIwJqNNnp9EJxMhzzy3/taaRb44aXrEACCFXgLdbSGcQYyOob3sVc0dEVdtVr/rTqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Aug 2026 15:18:39 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> On Tue, Aug 18, 2026 at 11:35 AM Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > On Mon, Aug 17, 2026 at 6:53 PM Song Hu <husong@kylinos.cn> wrote:
> > >
> > >
> > >
> > > 在 2026/8/18 00:04, Shakeel Butt 写道:
> > > > On Mon, Aug 17, 2026 at 09:18:43PM +0800, Song Hu wrote:
> > > >> obj_cgroup_may_zswap() runs on every folio swapped out through
> > > >> zswap.  For each ancestor with a non-max zswap.max, it flushes the
> > > >> cgroup rstat hierarchy synchronously with force=true, which skips
> > > >> the ratelimit inside __mem_cgroup_flush_stats().  In a swap storm
> > > >> with zswap.max configured, a container takes the global rstat lock
> > > >> on every swapped-out folio.
> > > >
> > > > Any reason you are limiting zswap through zswap.max?
> > > >
> > >
> > > Mostly fairness on a shared pool: zswap.max_pool_percent is global
> > > only, so on a multi-tenant host one cgroup's cold anonymous memory
> > > can soak the pool and crowd out the others.  zswap.max is the only
> > > per-cgroup control over that share; memory.max bounds the total
> > > footprint, not the share of the pool.
> > >
> > > >>
> > > >> zswap_shrinker_count() had the same pattern and switched to
> > > >> mem_cgroup_flush_stats_ratelimited() in commit ea80da363a1f
> > > >> ("mm/zswap: use ratelimited stats flush in zswap_shrinker_count()"),
> > > >> where the same flush on the shrinker side showed up at 2.88% of
> > > >> kernel cycles under osq_lock on a 96-core machine.
> > > >>
> > > >> Measured on a KVM guest with a swap storm under a cgroup with
> > > >> zswap.max set: obj_cgroup_may_zswap() was entered 198,977 times
> > > >> before the patch and 198,968 times after, while
> > > >> __mem_cgroup_flush_stats() was entered 281,017 times before and
> > > >> 80,445 times after.  The removed 200,572 flushes match the store
> > > >> attempt count almost exactly; the remainder comes from other stats
> > > >> readers in the swap path.
> > > >
> > > > This is a known issue. Using ratelimited interface also comes with a drawback
> > > > that the kernel may react on stale information and the consequences might be
> > > > unneeded oom-kills.
> > > >
> > > > There was orthogonal discussion on moving zswap limit enforcement away from
> > > > rstat. Yosry, any updates on that?
> >
> > I am not actively looking into that, but Joanne was looking into
> > AFAICT. I will respond to the thread there and CC Song as well.
> >
> 
> For this zswap stat, I ran some benchmarks comparing 4 approaches
> (switchable behind a runtime knob [1]):
> a) rstat + forced flush       (baseline aka what the tree does today)
> b) rstat + ratelimited         (Song's proposal)
> c) hierarchical per-CPU   (Yosry's idea from [2])
> d) page counters              (following what all the other memcg limits do)

Hi Joanne,

I hope you are doing well! Thank you for running all these experiments.
I'm not biased in any direction but I was curious what you did for the
page counter implementation. The reason I am asking is because I am
working on making page counters more scalable / performant by pushing
the memcg stock down to the page counter level [3]. I wonder if the
caching that stock provides can give (d) an upper hand over (c).

This is just an idea though, and I think this would depend on how your
(d) implementation looks like.

Sorry that I joined in this conversation late : -(

Thanks again, Joanne!
Joshua

[3] https://lore.kernel.org/all/20260623180124.868655-1-joshua.hahnjy@gmail.com/
(It's been a while since v4, I got a little sidetracked working on the
tiered memcg series. I have a v5 ready to go, just waiting on some
running some tests before sending it out.)

