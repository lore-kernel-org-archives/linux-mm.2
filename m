Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0D8EF9008
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A73F6B0005; Wed,  4 Mar 2026 11:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254B26B0088; Wed,  4 Mar 2026 11:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130376B008C; Wed,  4 Mar 2026 11:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 009C16B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:50:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A10B51A0232
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:50:12 +0000 (UTC)
X-FDA: 84508968264.23.AD71876
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id A18E1120005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:50:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K4NmWOIa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772643010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1zD8QHceRSWIPCX+II2vnEJtglFCb1KDWPWlkJAE68=;
	b=agCaQnfLXXLXI4am3WaC/otafh8SqAp8mKTdfbRa+5qWgu1KH/ak6tg55k1fv3iZ8EEbhv
	CbStGX/Zk5ilQDZ+b1HCaRmlHq4RabpzypDClBcX/+LLYZYJXld2UAscinO2jy+kOmHA0Y
	UJsFKnZh2oIL5VpSJNU6qyBqi0f82ug=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772643010; a=rsa-sha256;
	cv=pass;
	b=LuqH7051m5aMhkb+IIIrsu6Al/JekW3Bi9DKRhh98wM2PPMZMPmUO/LIi/DneEwo3jwjD/
	c19LdONWGl17FbJ0rT0TQUQKVtFCcR+p38WbzL+6N61tHDDIvkEyoFgyL52S1UJwGBjiWS
	/8ZxNitYukEWROtuemPPBKYsSDNDRjo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K4NmWOIa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-439af7d77f0so3645037f8f.0
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 08:50:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772643009; cv=none;
        d=google.com; s=arc-20240605;
        b=EHi2Zi2Lyl6LIet58Yel5WW5OP9yr/3PJCmKy4ZSDmNeSrTXXaqV2sNMR5nrHy8VBf
         609p0UvWDaXvcxj3k0cuxVX8TxErRvxO2Io2wY83zuyHWoki1OZBwKJ4cnnfpVxigQgV
         jdjsVYUnVrF+VGezfHnLyyQCe0FbITVjfDJHXNKOuqByPi1VSf6k6WKOePJBjzfPOsXe
         pfUe+Y4I3cE3BMWRyX3cXIf95cQcTciVmlCtxA20bWW4XjbEbtJzQGNeOMIhKYaUw1rx
         zAMyYG/HPICVOdqYi8J+Nvp7hNvBJEdBKOhzcce6y7R8qDhzZDBFgFam/zZvWAUTAlsB
         TWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z1zD8QHceRSWIPCX+II2vnEJtglFCb1KDWPWlkJAE68=;
        fh=hUn/lemiiHr2Erdcxb9NXhE+a/J1yuHS5HJtTy1yH84=;
        b=huVBIf/nK6+1/9gn37SmlrT0rEN9bVpHpnO7RRmjkAXsaUe3maePxGQawa3PnF1CR4
         D7FYRm0PprE/a9T5gObOIPWx+K0IboDXqdjunPI+/A+HxqbqV2l2npRBTFnpFcCm7jLx
         zhzF42HgiH1s0HhzGWJ3pRWZPq/BwNaMZqQ8F/jEF9V5Q0+PQr5/TKfmPO4YHtB9HxWu
         hghJZBFZDiH0YvVR62cK2szhPlP3BeZjlYaqtZW32ICs7gFDdRpsXE5q921T+a4vmo+R
         aVXqsu39Lc70C0quVJ7Eikn2SaE/PYtlP//SzhpX7ZHNAQeMMUefOhGgrfNZhePlmsqO
         G2cw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772643009; x=1773247809; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1zD8QHceRSWIPCX+II2vnEJtglFCb1KDWPWlkJAE68=;
        b=K4NmWOIaOJpPcp/jRNRLQjsW7joXtpIFwR1bgbP+hGLs0Z9oizXl9l/sdrhl0/CXxR
         G8H/mmHuNY/CmEhLrktpI84dfnLfBfw3N3BqXlrxFJHw60yui1AyFmIUSVlxP32x5Do6
         lQ/O+PKJof3x+3Zb0bZjIjiAX/CfdLj4YBAdgM7HA6R7BU8/UeToyAPIe5zUkEaMnzF8
         vvAdlIB0mVkDP/4/JfTUJYuRtGBMJqQ4Ta61ZBW8g93d+jqpsfijg1TXHrom76kUzNqm
         xakRNVs1Qp7ktMyfMKHey1AawfeFZzrNRfELK5miIaUkECINQ9eUTFmOEXQRayTU2fS+
         Cw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772643009; x=1773247809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z1zD8QHceRSWIPCX+II2vnEJtglFCb1KDWPWlkJAE68=;
        b=JnFpKeW1zzL0D42TOgxuPbzoA3nSpAH6H9XtZqJbH96RdCbN24slRQBbwP6Md3/0IY
         DPe5CL78qK0FH8DKVIs94WzutlI47P3rCHn0r4oAVrQG2Kzv0G/guoVF0d+0XreoboIK
         bbcJ9RHB4OLj69TMOw9/Vvu1ke61dz6NAAFt2HIQOe9EDQS0J01ALuEez64Raw0yD5yy
         IP1id5/6aqe0n+06J46cGyzg0mbA7UAc0hrFMeAuNY6lVQk0K5tYP0xb19xqhQep/twn
         kv5umtGumaFBEr8mYafT3LLt3ymkS54h3UOd0Ed5QaOeQQhDjzeCZDIMsDmCA/gDP/Tb
         mb2g==
X-Forwarded-Encrypted: i=1; AJvYcCVDlikxId1C+si2zD4ukO4ydN7GDyfIEv1sLnMiJCDMZU7iL4pVlfjlomQRhZgy72c5kuMOatDOyg==@kvack.org
X-Gm-Message-State: AOJu0YxA1AlR+XHwxmkES3WBnXtPjZnPBslkCywldkyHHj62s1+6ZXc+
	PB1Xb6EW67RznogCY8A39DcSoGsEr8t0u8ENwwaZc+yt90YJuNZilBL+iDlavkEJ1dLPKSegsiz
	P27raEBpRR4xZHKAA6sLJwcxdEe0WIYA=
X-Gm-Gg: ATEYQzxl6UeaUCFcmj4J3TsXkanULaBThwC6eO0ENbZRamQBhdloq/4GyrJGi+8gAtp
	UCOuHpAeDxP6Ft5gP70qKQzJ+gBDAAJ9HMr0LljCA/HtqNnLQQ1HhCEyEyoXDr7N6sLMW3SMSzf
	xdLl1Gms5c0eLe0Q7/tHi13OqLWuNpBu59+8Jy6jcYxvfXqsmkwVMBg9Br29xzLgELnwsd/PbQu
	uXWH2+a7D/4HDlNQQtt0CV8vw4F47RJlpr5EVdjvvQco7a4YPNJ2W2CpTlthYHD1VvIqXVTqsvF
	lTgQFwbJvYMWPovgUQdPCxQGs3laYvvIlMgowLM=
X-Received: by 2002:a05:6000:144f:b0:439:b564:7a6c with SMTP id
 ffacd0b85a97d-439c7f6a2c9mr4935603f8f.4.1772643008765; Wed, 04 Mar 2026
 08:50:08 -0800 (PST)
MIME-Version: 1.0
References: <CAO9r8zOFS7zU-eGkErcjud=DW0t00_WqNqCzq_QDf061dOsYSQ@mail.gmail.com>
 <20260304151120.3512645-1-joshua.hahnjy@gmail.com> <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
 <CAKEwX=ObFWm6cKbi4hL8JLDKui3MsRu-JpEFohBdkqHFY9tVfA@mail.gmail.com> <CAO9r8zMbU8ikA4jAUyOvvorsm3L4UD2X-KVcGyQaKwTZ0nV1Qw@mail.gmail.com>
In-Reply-To: <CAO9r8zMbU8ikA4jAUyOvvorsm3L4UD2X-KVcGyQaKwTZ0nV1Qw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Mar 2026 08:49:57 -0800
X-Gm-Features: AaiRm51ko9kVS8IjAoCAT_NvsIsy1-qAXevpqNGzCEvGG_N_B6mgqJbBAi3r5s8
Message-ID: <CAKEwX=OqW07O0nQqauTaJEwThVQxZJjbiLEpOuQtSp9+Dv6y1A@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and
 lifetime in zsmalloc
To: Yosry Ahmed <yosry@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <hoangnhat.pham@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A18E1120005
X-Stat-Signature: cqi3izoo3a7npk3xr9a5rx7muk8qep1d
X-Rspam-User: 
X-HE-Tag: 1772643010-213202
X-HE-Meta: U2FsdGVkX18fWevGuKDTCK/1uJ7IohuOMpcmqHZlmpUNzI7Qt1OadFBxfk5hS0UadDY8V+HcPsJJ3BvWznvL3FpNGuDtqkmfEFhn+uHTWnBpDDXdnCh62KdO1X67mDxpB4qMk8deeKONV+oNhu6x47v0up49oKBWHBxr6oX1HKALhyl43rVvClLhxJHWrcmUwWtNVwwxkPEtYQNQaunq9m/R9YZEQaC1YNtoVFYC9fOBZaunKGvij3TvQxzEaWIPabRmYvwQqUdoXcJ9wUBA9eYltI5f2kjbWDPMkRWQ6m8WhTZPF+IgLqGqJCSeICrLCxMMxLFYXEs8pHMOmuy5EHRl3JFrCCZch47uKPtTbi/7WwiOeo8kMd5SmEwp9tlJV5FmuT9OCcPzD95+CUuTykCOg6K8YmaFPvYlLS+/FVih/ncAbvJ3CqjSGVBEAiv2swmey9xcmm6TSoqPUl/6Zg/ONNtMq4Wt2t6Yza5YZAPdrDQyolahX2R5iGHSn5RtJtiUf+XWLskoi4PEBVCjfo65Vblz8jpxFWKQZMXBmoKtsdi1HdnzxfYKTxhqu53L6zYdGogPSl4Z38Q3UbzGRpKEIOPIdk9rHt+Ctj+UPaB3xFpx2+o1/rrN+buy8b2b1WU6u05ZpLa/1sRS3+Z4r24Nsmk7TLBqNGcwrx2AcjVjLARY43PlbgSWvVwm7LiRhn0IodkED2CJhzESEN32cUrrRH/2FPV2JnfD5MVLC/dJitfwKqnX11YVw+DiWbkfCfS7jG/Pl0Lx6IuCRfdnDkM0zzlTANRHNBbk8TWqpGg0HPSarU+0H+EAnGSU8+kO+NDSSCfkt48rQ2PxsThS5PJ830Sa943f/9/Pqf5e+KBKKhdB4RNSR5Na1+YDDJ86aqVzJlrfRFfbuhd/3/u2/ZROGUMyu44nUG2bZmMP7okaVb6eNXeFmAP/iSDcwOZT81A/yxwPsQfWUjkA8ho
 Jnx+gLoI
 0WOxXPwl32TE2p7e64CA6bPjMSsP54MaCgK9hp1m7lCUrgN9H6z/J30DpSbAuk7S/M23XEVnJ9WsngGJDe4T4kndYVi94lpavDyogJEWNGaekzZANcV8v6pAnRb4DUNwnZZxE6At8fqjiDE25LTIfCJNNmA41zWnRPVaSap1rsoKH/y51G/jnmM8NeR3WDUxdb2yTzl3RGlqcbT5Q7dIW1sn65tfr4UjIYEre3RUv9I6LoBKwe+mT2FHt5XyLaYFGM3Jazj5H432YhbZZzuzJcqTQBTQjxPDMG747YR/uokAjtZc00Y9cDHDZVlmjjYJuQahEF/zcNYxe4tqF4clMNqo0UCZBKkaFijHxIiCWDbRootW/6n5NvnQlrWc+8lrCf1Ld5fobieKqRiiCWjo1Rd/0Y/ssQWV65DeF3V8Mnum2RfJ30JCCa4OTKdkEPiE4/2cKSf9afP4DRGVclO8rB24Pk9Kbg0IJFg4kWYGM5IE12rU9pgT4NGal4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 4, 2026 at 8:46=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> > > AFAICT the only zswap-specific part is the actual stat indexes, what
> > > if these are parameterized at the zsmalloc pool level? AFAICT zswap
> > > and zram will never share a pool.
> >
> > TBH, if we were to start from scratch, these should be zsmalloc
> > counters not zswap counters. Only zsmalloc knows about the memory
> > placement and real memory consumption (i.e taking into account
> > intra-slot wasted space) - this information is abstracted away from
> > all of the callers.
>
> I agree, but we cannot change the zswap stats now that we added them.
> Keep in mind that when they were added zsmalloc was not the only
> backend.
>
> > And if/when zram supports cgroup tracking, memory
> > used by zswap and memory used by zram is indistinguishable, no?
>
> It is distinguishable as long as they use different zsmalloc pools, I
> don't see why we'd need to share a pool.
>
> > Anyway, Joshua, do you think this is doable? Seems promising to me,
> > but idk if it will be clean to implement or not.
>
> Not sure what you mean here? Changing the stats to be zsmalloc-based?
> IIUC we can't do this without breaking userspace.

No I meant your proposal haha. Sorry for being confusing - probably
need more caffeine :)

