Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE816D58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603176B0005; Mon,  2 Mar 2026 03:15:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD466B0089; Mon,  2 Mar 2026 03:15:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF336B008A; Mon,  2 Mar 2026 03:15:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 38D8A6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:15:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C18EBC480
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:15:40 +0000 (UTC)
X-FDA: 84500414040.26.D63394E
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3A01920011
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:15:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZqVZ62A/";
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772439338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlPy6TCG0fyz9oYgOS+bZqXSUGQTPNilmq+1ckiGH+g=;
	b=k5UjlUqEfc9MUpELmePMfCvSEOz5AvWngTuKG2NTF8i1TqPpxsfp/rA5/7YPccP9x2u3mS
	2Dri5ppkyBpl9vCK3oLlW4z1ObtT9geqcGmDHvF9d7HnzJrq4Bn+ZIBZNGboWxETt64YdB
	toIKVz0DSrUkpF1b71YcxqUvwLaxU5w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772439338; a=rsa-sha256;
	cv=pass;
	b=O4hQxKVbpJDbrYheqkb0qjmqI30wMU+wV2V4BebmIlJ6X3oS4yYG4b5UeKzoHs+a4i/u0L
	P4g0y349ZKPBS1T0j+S6EKFCcfO097jDNb8M6LwIjTSY+TBbCVeZftKuuZgxDbPyuSfefS
	MaQaBaQe+gYV0JFwgR7Yvrq93nAvh0g=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ZqVZ62A/";
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cb38e86cf2so439043585a.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:15:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772439337; cv=none;
        d=google.com; s=arc-20240605;
        b=SkUfsKE9rrvn9MxH1uZzK/P57d2+4ndanIvl4ig5I76JQxSNaXzVa7S3fSHFWb+p0d
         tMMgKE/1JhpciBk2NfmQxhM1+WoyI2Kqp/U04XSLoDVhYZmd2E08IGex793nLBkOH9XW
         c/CQ/PlcL3BIHyBid/T6POJapgPgpOXpKapqtAscvb4D4vG2MlnA80jO21Jx+1AITNJ2
         xt/lMQLgtwIuFfMoomKT9Xct+gKHjBCma9CySmNQsNl9wn7yOHr0qfVuJZBRXABHl3GS
         530kLzXUVZHtR0k6zOvvKoa/a4DorP46iQFkADC5sQQyun6/9Hr20t4H0m+2MbBdLwAH
         4Vcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rlPy6TCG0fyz9oYgOS+bZqXSUGQTPNilmq+1ckiGH+g=;
        fh=fj/+Bce1ThelWVlV6rsQ7liVHMEEm5WVssfE4AnLc+g=;
        b=QRKaYgReYgr0naDn121bPIVTL5BYqAWqLTNiLjWVrLREiPAafpJoy7sRbrxOZzIz5c
         g1qxU16rhMU2xyhj+qPv31q5Otn2rrR8De9DEEglBOdgbNEVRcbAWniFqdMiCXjnBrkh
         xUqKJ5TzGrUQp5lRqTixOUwyiS5Tk6aztmNv4G5P7r2UtGRTFKY9krYqz0CXA1Vc9DzE
         k6xhkUr9JZgZjXvTXLrABp1KqIjv6ZdatjLZWGC+SfoxbvlOJoCKEeFRaP8ePXtYeWdt
         558Rg/HwwZILb3O3R7f+YlEYEt+WlmFyqu4jYdPbpNh3H3zfuiXAgC+Xh6TshSQ+8Ryz
         HFfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772439337; x=1773044137; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlPy6TCG0fyz9oYgOS+bZqXSUGQTPNilmq+1ckiGH+g=;
        b=ZqVZ62A/doFbRL/TbVMPWAgbqptIfIN+gvEznqu0UpcrLHnLjYVkZq7tMnqsUeSV+p
         Ca/cjw+JK3Ws6EndYSbaGP2X/Lv2ijdQ21y50GYj09mEqsavOf6Op6h24s/bCeBwl9C8
         j/ewAVx2lj53ET4wwtQzXD3O0Xx8jiFOn/6gkICDE9bq/dFhMxol2bi+puqL9GVS1QwY
         Ad5ALFTEPkzz/3d1aWYwvUPZYsMI2pBggEYuXurNbVwipiHmnf5/wXIJKcchlE6w3lBB
         T6k9J02za6p3bIwOmbgIFRH6HQVNDPrDMvYkpZaiXl3C+hxkAyG5F9khERrzKuQ41LOb
         CLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772439337; x=1773044137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rlPy6TCG0fyz9oYgOS+bZqXSUGQTPNilmq+1ckiGH+g=;
        b=FAVxvwV5a0zrsE7tisP4JAOSunykk7m6QHUsI17m0mJhhAvMWaRx9SrVKzLUuZ7tpG
         UCimfvi77Bcrrm0Tk40w0NNwiXD4lrBkBlq7HVMsGXN3RO0LN6Z33pDc0H/lLoPuwKFG
         Bn9PyhBndv/hPZzh9owCFP6SDl1GfMWaaDrZ410j5se5jvwjwm5opFfnP84UoNT/mq+B
         pjyTKNBoYKetnLCtnB9dN+EkSK7aJFTqV1t0ZRkrmXC9HKZ8ktybxB15pD+RYGDbnqPY
         giQCwksdwQYD9p5Hzf+wQe3zwSEMMe9qKsdlK3OXS5Wsse9oO0dDI0qYbq/yc40DQZ4i
         rQZw==
X-Forwarded-Encrypted: i=1; AJvYcCWef2KcrBIWkpBBqovVs2xxGubj5ntrlgLJhGGY2HvaJs7DYfsBfC5SYv9EQa0s61yp+rVXIyg3ew==@kvack.org
X-Gm-Message-State: AOJu0YygfoeLtMrr8pY7qjnJv8AbFRpvUxy5haU6Ysde7bdOv/pKgKzo
	Iz0U6A9gFk87897tuvUVBn2a3EV0c5ZymheVtWTlZsIgvvQE95lKenkF07yYBOM7+d//SxktPu0
	YqNkA9MHDDMZ4wdbzohNK7AzPKPpSfU4=
X-Gm-Gg: ATEYQzwLU11Jlszq2NA1KO5Wa5eF7+V3I0isqrazMf6DggTlZxk/WA6XeqqoQZbbRWd
	VGsTjNz8LmZ4yiAd9XI/RHlmnqqip7Pd1oIMzfuxx2DJEtfaQMCLTcPyXybM7n58AzwEz3WfCV6
	xt+iPV7LrpX+G9+fvhZx1cxkkm8a8b0rhtr0U6tf+6V0UGII6P2+oYdfup6xZTyhmX1FaNhy99c
	AM5G7LoH+aTssM35ky27KJz+EgJnL8d6MdH3ysUXRk1t3DBjdsNF/HWwvZmo1MFR0hEx4ItdMYm
	4moc5A==
X-Received: by 2002:a05:620a:2981:b0:8c7:f62:21c7 with SMTP id
 af79cd13be357-8cbc8da8a91mr1469764385a.20.1772439336903; Mon, 02 Mar 2026
 00:15:36 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com> <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
In-Reply-To: <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 16:15:25 +0800
X-Gm-Features: AaiRm532VjPwyE9BX_5lUymFogsxzHtD_Avi7D_69MEdnBOJ-GjvxJ2fUchjICo
Message-ID: <CAGsJ_4xXup2O=u24kYmEPT_vW--5Jsr233zCXObnCQ+KQ0WHZg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Kairui Song <ryncsn@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, lenohou@gmail.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	weixugc@google.com, wjl.linux@gmail.com, yuanchu@google.com, 
	yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A01920011
X-Stat-Signature: u317xuubu47198a6jyn7huhh3zggc13s
X-HE-Tag: 1772439337-295277
X-HE-Meta: U2FsdGVkX1+MeDTN2xgZAdq/kG+smSKgcniVYUW1a6Pa08p21CVFZFYlKH0moJFYd5f2WV3WBtTKjoHcW5UUEzGnPZIpg4VCXbscYsaWg5cAIPH4JmWOVxDX/0GCVYdbu3GNlyg94WPT5+cRqkLsHpbJrLLMqh0loGGnakbd6Qm3Ay1DNS7nFzveuhWf/lwSB37pYSNxFR0jP5bs9oXceYboDujjTLoaBWmPeyQtzTLV71x8Sr1rU4NrZ62LJ3l1hdHeA3QkMSpk2R84VELW7Hhq7XMOXMkNn5GYdEoqh0PTFiXrJQpVzkNpUOHKZpQtx840SXim0p2qEq9zd8K/Ylqpru1j3+9su1p/HDOhvghNYNF/lIHw0UbGrLSBcF8s3w6yXq3UIdW282OfY/aM3Rno1bOIrSd8ejCCEO+OrAeh1bfKdPb4tIZwz+GkoQNBqia9K6r0GICgY+T13rUmEn9svvl6OawAKwKEW1G2ViNwQQDDdrc+crq08ngAGua+w/S2tV0Y3Nw8qvqWv/eltIJPNtkqCwsrRNnQsV6+r054tdS04qYfCKyFI4VBj4YOCRKE+eyg6uLUsxnm3EzAOuF49uayjOl4eZSgSNCPDpyiB3TeQq0udc1kcA6cJ0S2DCQRzVQjUuOvTJ72NbHUFA7dSDq6NFSaw2db1K1xaf8FFc0BEzZ06O/DDU3Lw6dogT4G8MjBa0SQ/A5+1bmB7EqGxUk5lVGzi4wx5LOCdqObxN0eGWVJQBYI/7ZXY4Q4EvS4WTWPt23QDnf8uyLYb/pmrH5uZb5nXp1GyT4/syI+gL4czCkvSEQadDT2xD6JO9A4atI35lSCyH9dDSm2RRlG7aeAPZBzrqdHQd7ciEm7MUdsDDDd06vwNqlWyNe8lFdsdk5TKukmb3UzjE7welEq1rmIK3be+DOrcZF/phJX6DkVwfbVy4gsN6hbUW0Q2GnV8KMiiSehXNx28N6
 AruEUDRW
 9O4B5pE6HgtOF7Rj/Ms9B4IS8D9nG1LUyUyOtiFhzJEg4/KU5l2b5C/LvL2Frc1hq5Dzp9hORqb4sEoWkZSpQ4Z9ohEclM2q/3m4DvFu/5RlSns92Xdx3Olt4RUwWsJdTKIuy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 4:00=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Mon, Mar 2, 2026 at 3:43=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Mon, Mar 2, 2026 at 2:58=E2=80=AFPM Barry Song <21cnbao@gmail.com> w=
rote:
> > >
> > > I assume latency is not a concern for a very rare
> > > MGLRU on/off case. Do you require the switch to happen
> > > with zero latency?
> > > My main concern is the correctness of the code.
> > >
> > > Now the proposed patch is:
> > >
> > > +       bool lrugen_enabled =3D smp_load_acquire(&lruvec->lrugen.enab=
led);
> > > +       bool lru_draining =3D smp_load_acquire(&lruvec->lrugen.draini=
ng);
> > >
> > > Then choose MGLRU or active/inactive LRU based on
> > > those values.
> > >
> > > However, nothing prevents those values from changing
> > > after they are read. Even within the shrink path,
> > > they can still change.
>
> Hi all,
>
> > If these values are changed during reclaim, the currently running
> > reclaimer will continue to operate with the old settings, while any
> > new reclaimer processes will adopt the new values. This approach
> > should prevent any immediate issues, but the primary risk of this
> > lockless method is the potential for a user to rapidly toggle the
> > MGLRU feature, particularly during an intermediate state.
> >
> > >
> > > So I think we need an rwsem or something similar here =E2=80=94
> > > a read lock for shrink and a write lock for on/off. The
> > > write lock should happen very rarely.
> >
> > We can introduce a lock-based mechanism in v2.
>
> I hope we don't need a lock here. Currently there is only a static
> key, this patch is already adding more branches, a lock will make
> things more complex and the shrinking path is quite performance
> sensitive.

I agree that the shrinking path is performance-sensitive. However, the
bottleneck occurs when we move folios out of the LRU, performing
reference checks by scanning PTEs with rmap, unmapping, and compressing
memory. I believe that either the branch or the readlock is too small
to noticeably affect shrink performance.

Thanks
Barry

