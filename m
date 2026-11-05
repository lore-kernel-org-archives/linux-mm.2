Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4377E606D838
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rWBVbwDB
Received: by kanga.kvack.org (Postfix)
	id 35ED66B05B1; Thu,  5 Nov 2026 10:32:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F6C6B05B2; Thu,  5 Nov 2026 10:32:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FFB76B05B3; Thu,  5 Nov 2026 10:32:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED17C6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:32:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72D6F80A8D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:32:48 +0000 (UTC)
X-FDA: 85401458016.08.C99EA83
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9277712000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:32:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rWBVbwDB;
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793892766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7umyZ/YrHoEtmXj0FGuivr1Hxju6M5MLAM0VoOLTr7k=;
	b=mrVSK9+hEEsiaw9UUcLcyHVPC4LxZXDRgetw89mqAk8Pr2HKTf8BkRdtHFgcBvuXNyfSla
	ZpE3abIWnIksvzg+Zl+baVNiCA+uDwJ5p1msUkFFf3eyNU0Q8LAKSL+qULqW00UC1NmqLY
	jJdYnKR4BOYjGJ6zAE6CaB2zeC0XQfs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rWBVbwDB;
	spf=pass (imf29.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793892766;
	b=8cMdVgXCWt5W2HSvAbVb4PFdvQy14fc/HLYU0H4QQW7eVHJbAk1H9EaVyLg1QOw1inUyPu
	b/lld4dPwwMnZi3eOF3H5kotjO8RiWjjPw1FOcIQFE5/9iIJN2yU2r8Yv8Ck5UQ1ulmQDC
	KVmk2DWDNoboKln0P+5Gx1PMq8go+Ns=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35159e0092aso205587eec.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 07:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793892765; x=1794497565; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7umyZ/YrHoEtmXj0FGuivr1Hxju6M5MLAM0VoOLTr7k=;
        b=rWBVbwDBTTVd6GbRqgd5kKcHncZfYYh/vHoGpN9XgXu2NIaHouG9Cx54RAx+eXUMeM
         MakDU2iGDi6LVSWkpXA+uUL+s8GDsKvQowZtHYmjtxgcaBi530F3lUbmZpRpzpEBfm/h
         cGqsq4GLZHtx4kjUAbFogEu8O4XhoHhTrZiiut36Ds59n4+8apy3Hg/XYXIzT8R6uYEV
         QkqwwkxxyEgykvE+PAhHuLVb35ONKdXN+PuBrwS+Voeqj0rx03PbZMFKc5HIpMMbZVou
         pKx79daJk6Qvww9BD9HUa5gQSetSQiy377KRCXicQOJ+KV0gIZHUwKI8Y8N9O0apz7W/
         sYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793892765; x=1794497565;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7umyZ/YrHoEtmXj0FGuivr1Hxju6M5MLAM0VoOLTr7k=;
        b=qrnXghSY6FfuRmT5/TBsfBvWr1PmijARE0Nvbdm4Sd0jpjyR/tn8uh0bWAx/OdSGC7
         GgonmvDfas/xr3MHxTkhHxmwinW9atYghNsT+DSYdBmVHmCQwkQs6dZxo+zpEFWjgyVM
         s637go5QGJQXsQfLTVV5uoaW5jh+f1uKoylG4Z6ZS8O1Pv1GUugYrbl2hxdCJL9UG7Ht
         +wA9vfHnsh1lXijMOGBGpDRawOboMtnfypNhbel/mBBpxK58dReA9lQkpQjZy6TjXyXM
         ezo26MCqRY0rxZqpvpWKJrWqBvOl2IKjhFvz8vrvtlO38AqPD5yeqWMeJhL/V1ey0NaW
         6mow==
X-Forwarded-Encrypted: i=1; AKwUvBx6DTehimo2E0NbRwxIWKG/m706wl+6Hmu8eJdA9XbAxSAwD02IRcArx3l8UhEK8sb1NrjsS7BAUw==@kvack.org
X-Gm-Message-State: APuU4Z/OqNkIzUPy/CK07mITaaGAhmH37lViHwEmbJgOQ8OVsNvS+DQM
	NIKtJYcCt1rimK9j6O9qoccG4lcrU2weNO7ugI41kl+lsrOFM2Id8pkQ
X-Gm-Gg: AYBFou0wH7YjxEhxq/P/qiwBONLOJnsTlJvMR1f3+JNz9uRif8waG+rmnSkZXAgqAfD
	1ScObmkLWu+QjGGZFycjUZrZBYir6r8Cf+hoPA1eoePzBhpWk+t9yr5Itinv+KFJl8mCoiMkm3t
	0SLCH9xs8L8egqAxrj7IiPEfZACiKNdXfqinmbZV0ew7HdCrsERVG74opVI1gydWcsAupm3k01u
	WkkyVE9bb6BiX+xEo8//9mWhgQ5BNYfQdcSM925w5A5yvNpe4QRa8R/XbqB4AtQTB8ojvuw4pNS
	x/tLIZdgpAWQapEPQI5m2EXc8y/4wp/YdbkSMTbui/rYmX1xDOx8d8qbKqGyGIEFPn7NOmeCt7B
	v7VD08oPH6vyaLibDYIW/KhZIREphNcULtqSCm7fYZC4OTjf8KrUg+llshuT5t0ZaOVYP3lhVjZ
	022FxaiQwnqhEWu+wLXFf8xzOCWooBLMH+Wp2CRePaMipSouYyd1BkUjWqF5h/4elc1uE4HKQOs
	Iao0+3ePAH3vMbw95ZkIdUX0i+3qWjwqOGSADuWaTZ/Hf1FZ/tbeIVllYHcKyHbUu6WCBSHg35v
	UZoK6az4x/H7pjocE/rCwnaOf8gG7ENYi6uEa5TGQuTENDJWHlivJzRzqvlzMriJqLU=
X-Received: by 2002:a05:693c:87c2:10b0:36c:a1bc:6114 with SMTP id 5a478bee46e88-36ca1bc69bamr13207496eec.0.1793892764837;
        Thu, 05 Nov 2026 07:32:44 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca394c2a3sm17793828eec.20.2026.11.05.07.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 07:32:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Wiseman <chriswiseman@google.com>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
 Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4>
 <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
Date: Thu, 05 Nov 2026 23:32:38 +0800
Message-Id: <179389275823.111354.9600793327477116515.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Stat-Signature: h765mciw3rmbbeb8rj4xnd3w4zwmbmrx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9277712000C
X-HE-Tag: 1793892766-874025
X-HE-Meta: U2FsdGVkX18ViAZM45q3X1xFo1TxxL/PIGJv32M7EjNJKAqimHchsHTSB1EHpHVhSJ+GYFxPmOWeiHi1MJYs0tE9wJt0JKb8rVjV5rlZUfuOFh/m/4MHJT6QV4ugl2hI3lmDyOdZIh3jv+INxjFTpjRxONU3Za8k65993UY6KhrZ91gokurwB6IaYgjDp2hnLup95bGRE8DP2KPM0SBOdVOXR7OfmYwZOX03PTRJiLZb+t+oHioevUVOGk8i8quFOjPcrxWnNUhUE+neIrIVFrZ8rZYNTLdDY0syIKwAY5THTvXUMTckXNtBJ2hrhfUEa/azWsmAVR2/DFFhXwIzlIL/5LwrjY42Jo3+8164+zZShTYlTC8beWJ2wwKw58cwAWntDhyX5B1fBpOFF+oxzngt60yfjc2OU/uJ5PFG6F7Rgc7Ao108fn93j4xab5+1YF9DcuUKP12aA32BCdOOZh6bRr7i5nrGVafv2w2ljPDUDnWFWG7xvleONzHmylL9ih+ItWi8g+kHGNUP6ZF2rJg1qSx3yKiraUNF/KLMHxjexwILoa9L9nRok/myFAd7YUMo0CmYNn1q/uf1Yem4MKLyiuEpnUrdKcVRd6+ZoNniZmMEngM5PmVRa3ZnYEIQxIxir39DmhEfWyj0fgVd388x3KltqfvZ2+nxB8F+0A3GQp6CHFnI9/636Ejof85tghcMxEYfZQLxU/7594JjuXOnXawB1eLyAvwQijIjb6kUfX47wG/TbXqBG6SA5n8x7c6V/J2lBTB/lPMD7caJHS9hwL0Jgzmp/WvQmX2UC0nreuihNDuHqgd69u4DXdnI2pZWl7TFLVvRC3aE1VHBD/z+uyxpXNnKyI8IzBYrl97bpbZogSMcLtW/coDLXwM9Ss59mhSZLAbvmOG7rOcAi2QU4S1AB1YzZQrRo5ceqDU3Qw3nAph/3lOLPOzhaQPn4vIt3sLhXA2kksidXyO
 XGT7FaB/
 lZQ6NiGJNHzC4MbiLdPmpv/Lswkz8Q00C8u+P2ZkzmqifCnNyGih3WVYW4ja5GxcDTnp1lmIRcwrbe9djF6oXS7PnVhQYxwaBH0CZPe0TuLRuMYKxT8CEmGvHAwEjlZrnIw3y0E5++I1eE2aVVDS6gGrsooqfAqKC2IAe3Pxb2EJo4UulzvLDDNX2Kqb3cnLUQThzbNBGb3x9uSEvxxe+CnamxUfi5soTnCIcESQiQ2p4vUWO4vgsgufK7nR3T3HZb5Vcp/wjopu2zwCqmF7s/Mq+fNsVuiF4OoPT05Os6fJMpDYDujR7xijzX+eriy0WIXYrgcyYfteIj0839wvHYz1BUV/XWja9K24LL0kzicPHIn3702WwvMILAVbz2y14EZdmKttVePUDxZ04OSRvldUkfi8vCQDREsYkPEdg3dgUF5GQE6HC/3hn0ykvVwR+lzxY7jjG8lAXK9M7A3dXszanDv3PChXQMd+JXUNhHqrSTbR6e/sWrlDMtBsPFLVJhbdLpOFIqeShHyMEbiu/zKoLaANQW9a8hvhAuk9fzoPzR2PLSn3Uar6OJczVp/AHeUW1oFbweOHwSl+FztsEwrUjlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-05 08:08 -0700, Nhat Pham wrote:
> On Thu, Nov 5, 2026 at 6:36 AM Chris Wiseman <chriswiseman@google.com> wrote:
> >
> > On Wed, Nov 4, 2026 at 9:05 PM Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> > >
> > > On (26/11/05 09:10), Xueyuan Chen wrote:
> > > [..]
> > > > > SGTM, but I'll let Sergey chime in!
> > > >
> > > > Thanks, Nhat and Chris, for the discussion.
> > > >
> > > > If Sergey has no objections, I'd be happy to send a follow-up series
> > > > to make the shrinker configurable and add the unlocked pre-check as
> > > > Nhat suggested.
> > >
> > > Thanks.  Sounds like you and Chris will to have "Rock-Paper-Scissors"
> > > to determine who sends a oatch ;)  Just joking, let's first figure
> > > out how exactly we want that zsmalloc-shrinker thing to behave wrt
> > > zswap expectations.
> >
> > Haha, Xueyuan is welcome to send the patches!
> >
> > Dumb question on the zswap side - aren't the zswap shrinker and the
> > zsmalloc shrinker independent?  Even if zswap's shrinker is turned off
> > at runtime, normal swap-ins still free slots and leave fragmentation
> > behind, and unlike zram, zswap doesn't have a manual sysfs compact knob.
> > Would it be simpler to just keep CONFIG_ZSMALLOC_SHRINKER as its own
> > standalone config rather than tying it to zswap's runtime knob?
> 
> Yeah those 2 shrinkers are independent! I think we should just let
> ZSMALLOC_SHRINKER default to the value of ZSWAP_DEFAULT_ON.
> zswap_load() (i.e zswap-in) by itself is enough to create
> fragmentation. The zswap shrinker is just another trigger (and it's
> also irrelevant if zswap is disabled anyway).

Do we have any numbers for the zsmalloc shrinker with zswap? If it
doesn't help much there either, do we need to keep it behind a config
option?

> 
> How do you feel about this, folks?
> 
> 



