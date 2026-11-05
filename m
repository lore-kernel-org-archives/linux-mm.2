Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E19D606A33C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uk9WSJhe
Received: by kanga.kvack.org (Postfix)
	id 35BF66B05B2; Thu,  5 Nov 2026 10:08:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333286B05B4; Thu,  5 Nov 2026 10:08:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249C26B05B6; Thu,  5 Nov 2026 10:08:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E484A6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:08:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F98780A77
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:08:41 +0000 (UTC)
X-FDA: 85401397242.24.1013447
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 76D364000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:08:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uk9WSJhe;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793891319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UV/eD3mOSLOhUnYm+40VgpE/6LQSC239IiMgTRBykc=;
	b=0i6AKeLkatlvLbL61MpdyBNZ/YG5oXrlhFbqIvBGBcdoe/dZwXectZiX30VyRp0tKNByro
	zMnmJE8Hyh/xISNHuN9ndnXEFBHmzvYJcmV0+DKsdl+XCHIYli7fOMBzZObFCIpdRo0yF6
	doRYryaX2iPIdlFEmvw8iLQhEYhi/RQ=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uk9WSJhe;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793891319;
	b=jrd1mWt0bMbjGpOZf9tZP+SbWA5az9MN5sVmeLwef+QGeP5Xee7B0in9NsxRJ4zQ7mayAu
	gl6QznSnW50mBIPA+lK5gHXiNBtByVLRVPfdDzvUo1jsFjnPiq/2Bj++rXZ7EY8VeSp21H
	7UWJ3HrJpwS+Mu4IUsXzlLdFq6sHTtM=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48bbb06e746so1255080f8f.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 07:08:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793891318; cv=none;
        d=google.com; s=arc-20260327;
        b=ZFCIQsUsuDrcgu3e0mlDW3BKY6B5K+mEOiOOaEAEL7YbWWrWiGR9CMq7RJ/BTZ7oX9
         ShN/Heqam0/4x3WGtAtbDzanZO6n1AWfgOAn8EtNmd24A9ZsfZQcwixS96Uc8aogamaE
         5HCPMcCdTI6sYfm28XyH/N7x5F0ss0xUNBPpAuvwT9k3r3111poPZnLjJZj+vungLeCZ
         lv0uEKlKtdMn+t6KqohfES+kZap3K7wXdEmnPBzO1bbbmrfxZ9pnZBZ6KKqhs54FGtre
         dTZuM/l5tBNBTNMD+7LUYFXtw0rpFtJgeH8KhltMQt7hWOIONvjz/KtKfhVGaJRTDPiT
         jgvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5UV/eD3mOSLOhUnYm+40VgpE/6LQSC239IiMgTRBykc=;
        fh=DEk53acCFup6GQUWboFexJRAmpfLsIxydgBX/AKMleg=;
        b=cAuGoisqs4zuVdo3o9en0knIaBheNyMOb+rUMUYy9A8kzQ+ajzbZzzdhFYks1wyGhQ
         QnwRdoV28u+4glYUDo1vbZuQ/DlwK78flZ9c9iqsBq145gQTFJ1pNlGpCJ7zml7Bh9zh
         Yc0J3alVHMhazHkwgshZ75FpmhbawB/zvMl2ag6S/Zi0SPwXRMZQvPQrepMtOTBiv3Iw
         6txLtwYIkSt4uQpV5cEn0azYfZKnWH6XRGpTOPwJLnXGWXu8HjLQe6Rw1K0M1Fu0807d
         xsgWzdSA7MtyhH/qowqnosORdu2Z1lkaIVnizrOHOa/bgWAXkprQEhL4P2zYD6x12xZ5
         /gZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793891318; x=1794496118; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5UV/eD3mOSLOhUnYm+40VgpE/6LQSC239IiMgTRBykc=;
        b=uk9WSJhejMtObDCe11EcBH1+t2gFmxrF4rsi4UIDN51Zmd3rcY/KOepMiM1GBG0v0F
         gacU/FgqencuO6h/Msq5Uhp/MUCycDuj0Mhkb74HwYPYYrFXcm/hZ1Z2rYTcRNJ/qOSb
         dpdx8CHvuEl3mKaDYMj1F7PCNFLw9r9QRZm3sNU2Kmj7RWu5h1V2Sr8ZWZ3k+rFrxgcq
         vwCn5WGnTrkRuIjAzuODTh2tLQEw5jb7XHRyWUgSXL7mjhmCj4HJp6FmE48sTZXQmm0R
         2Ms8+4aZa3buWhKQWQueV3b6k2+sTM4llWzNRFjBoMfNvqtzJsQyI0H6TtdSeV+T8XY9
         maIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793891318; x=1794496118;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5UV/eD3mOSLOhUnYm+40VgpE/6LQSC239IiMgTRBykc=;
        b=nFuie/re6DKCEvqAR2OylKv0yV2tLYyvwPTT37gb+Bulfs8bER2m4OamsYmCqHwX6O
         XKIruc5KuTvNL1xRM811b0uBl26MMXfRQFeBYaYeNxLWuzVEsot8G2JfvFzH6pxhM8oR
         3Y/e8ah/csLmMWQLEXQOPkBp+IeWzLuZaf+/K9KnU/ZVfFkZKrI/LGNPueLWdsQnp2uO
         i6CCFtj+ow/l+KOw3sRrl5idFZBggr7XDeOHX0TwiOgDyGtnYXA23CpzdRoYtcCkOLqQ
         je6MYiHtJPRTUFYYbWxLHYg1nhp0O8GXsslOrgrJAIe9qIoaUWq+3Df73StCWijKi2XI
         +hDw==
X-Forwarded-Encrypted: i=1; AKwUvBz17OoznFbA3pDjFcFO5TSBUUoDgQB4W1z+9QiRnh/99hw4+a3/fMysDFfGP5FYtIOys3wTZozG2g==@kvack.org
X-Gm-Message-State: APuU4Z8e+m6aLyyM+BrQ6CgQ86aocc5/YO5We0X5L/rvVXYLDZYim8Nl
	P5km8yUjYLUJzpjmv/wPQf27rlHmxL+/v8u/nB+rEFgOSO5nqKsXXI2bq9sFY1UjdAJOKtIGxgS
	zmR9YcQvkKn6uBkHg0jjetFxfTFJtLK4=
X-Gm-Gg: AYBFou1JaCYKYcpLtBRB8+s7FFvS/yuSIPg4y1EvuRp+OJKTVNHPUypfKw7YiLhDvj4
	LS8PgyjBTUEoaH3uDCHVilpIzdL75EEX3gdwQds+FJ62Iptvfiq8yECabXtUdg/fP/yVLDIeqwY
	2ge2kGkYJF5Ky8Kpj+zjaT5/dCXeJuYDX22ao6EfuGIYCqyFC0Kgm/80ijf88x+MrEnNPrK2+Pf
	9gIqC2q9rqD8/odCpG8hAkA5P4pv3V8rj7PU6Dd6mm39wVF5K58JQWY/lhS9GGM6Qd97tSi3TEz
	3TOY9Z6/uNH3++wqSf9r9zLWCcUARVDPsv1XiIRnEYjNQ0EPXnzPKd8/PtPSWrfSO27aCjT4PL/
	biTyVFyT7JZzPh7YbYhjYl2d4AAn2m6/EMRgTWogBRsxSVRZvrQnNRs5rJwzkjF7Jz0TDGx/eWf
	XEcrr0qTT0bc8MT213+ioHkwCQhAgQDYWjSqQvrDDL8ZpBcFsd02A9oXC1Tzo2ARCmbINMRZY9y
	Q==
X-Received: by 2002:a05:6000:2088:b0:48d:f6d2:9c88 with SMTP id
 ffacd0b85a97d-48e6e4f8daamr42883065f8f.47.1793891317789; Thu, 05 Nov 2026
 07:08:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
In-Reply-To: <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 5 Nov 2026 08:08:26 -0700
X-Gm-Features: AclHuK9DGsKaK7xiTGD0CxvOvT620BRSQMIPoyAV2tzbxWnS5VA1TMg1GxpmWIY
Message-ID: <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Chris Wiseman <chriswiseman@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jii9soy6aysexxkadyhmey1jwyn9nh81
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 76D364000A
X-HE-Tag: 1793891319-4155
X-HE-Meta: U2FsdGVkX19jNJyWuR3tR9NB2saPXu0Nqas//1fEAYhyQnHOQOkGcJc3rCKlNNDpX9B9aam4jOCRvxcMXC+xQ9Iutl/R08EpWGTEgERD8y3l3wsZhgUWThZxSFjLxvIsi+RtVKV0kgYqpIKkrHKLOx/QeN6L46DB66ip4Z51qOi3oK8XW37e7K9tdI6BHRXzT22voCiXGzAnF/YZWDwipOMQ8KePkt4h5NmBKYPbuEW6wu5nesChRlNXzep9XLFu22D7aiXnTAuLdk+XdNafweWR7ztuwlhifMRV+HXbRQbcpKPLtn/Mc5kjl2AXrXdGbDE4Z0SpE1AdWgnK14IqAVxmqiOotx0P6CTxJNQx+kecXzAhWUFVVpOWyHa9gT5IlBJIdYl4LoA0RFTealQjVf5L4f9konH6gAVWz2n5MuEkcrIFQH+XEVRH2/OEMn5j1ZbO7tQluFtPInKJsLcTzeihmy3gEmTShdqZ0N2VQax08TuLVt5r66ph0L5PaiprEoNQkxsgDtmOS99WZTU/SHPeCm6DXXB065Khmm1o4kfNE8rN/E49Zi/qnlhQS8vlX6EQrJTlWVQ/5/sdNvc+IO48pc+cLNhIifylRrTGrVRb7z68z8NwR0l8TcFFn1qH4wrbSCDeu8N3K/YY4ggE996koP3rgFpr2tAhvNm/Gv/rpwS2ygOebpnLIexx7rN0m8+dqhh63ZOZlhgLYqduiohK4rfs/R26q89+ldkqdSAcqqkreO4WUauDPvwADBdzaOnQRyg/Lgk+mB9eLG+D+j4VGViPysaBv230yQxqJ1EANiweCxP2Pl0A98nAdrxcx1rOgrebqUQvxUUOMfCCTwCwpBNcTtP6sDXbO9ucyDG1SWbOmD/4NhTqEwU0TLTQiz7lFWMpAV6FA8XQCOkODrIFE6fistqBEUWTqq4dWg8VrSpYwhQ5JVIxZNi60TC7jI/gOlVdBfUR2FuOCgP
 Piv/BYO5
 RB0cBWNEWUhxiFrBb8nRH4iR2lmLz7C3WcXFxSYSZ/STuLZpbCi6BHeiXU4/HaOP3XZGIwqhTnE7ziUOMfCiY1nhkx4rFvwu+VSO1FSSQO75wHAYSdW6X2fOnVGow4XUzLuQ/ius3Yqv3Umi/tAyELEk8uSwKeyXpH+HuaGYa7ZY7DyvyU+l9DDW1EuwLsy9KGquRV58F3Qy1igsm3tSaPB4S9h6O6SpPbPMgbVMYiDHOW890xCTUcjabhNLYDnMLWX4YHSC3X/lDTx+3uRqf9LkoDvyROnCCQpT0PBqB4E/tDfNCLQffPksrBnNhCqNNNmY6HzWC31jZ83PSucAFYTtM20D9T+zDjyYwz8ubHl00/WtLisg9kEtF8moW0AIyeCGrKJYRHEsR1HzfxTyCR9ovnu+tA8BsI1nsoDg16PvdtBNHTy+bzMWz3pf27TBqrbRW1tD8QbdUGuQIfmLSJJnyM3rs2z9WFuTkwOJ72t34xCsb0PvtfscQxTxOz0T88/00daYa6XEQzTYc/Ae8gikOtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 6:36=E2=80=AFAM Chris Wiseman <chriswiseman@google.c=
om> wrote:
>
> On Wed, Nov 4, 2026 at 9:05 PM Sergey Senozhatsky <senozhatsky@chromium.o=
rg> wrote:
> >
> > On (26/11/05 09:10), Xueyuan Chen wrote:
> > [..]
> > > > SGTM, but I'll let Sergey chime in!
> > >
> > > Thanks, Nhat and Chris, for the discussion.
> > >
> > > If Sergey has no objections, I'd be happy to send a follow-up series
> > > to make the shrinker configurable and add the unlocked pre-check as
> > > Nhat suggested.
> >
> > Thanks.  Sounds like you and Chris will to have "Rock-Paper-Scissors"
> > to determine who sends a oatch ;)  Just joking, let's first figure
> > out how exactly we want that zsmalloc-shrinker thing to behave wrt
> > zswap expectations.
>
> Haha, Xueyuan is welcome to send the patches!
>
> Dumb question on the zswap side - aren't the zswap shrinker and the
> zsmalloc shrinker independent?  Even if zswap's shrinker is turned off
> at runtime, normal swap-ins still free slots and leave fragmentation
> behind, and unlike zram, zswap doesn't have a manual sysfs compact knob.
> Would it be simpler to just keep CONFIG_ZSMALLOC_SHRINKER as its own
> standalone config rather than tying it to zswap's runtime knob?

Yeah those 2 shrinkers are independent! I think we should just let
ZSMALLOC_SHRINKER default to the value of ZSWAP_DEFAULT_ON.
zswap_load() (i.e zswap-in) by itself is enough to create
fragmentation. The zswap shrinker is just another trigger (and it's
also irrelevant if zswap is disabled anyway).

How do you feel about this, folks?

