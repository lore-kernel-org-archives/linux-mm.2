Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D3DFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D5F6B008A; Thu, 30 Apr 2026 04:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D557A6B008C; Thu, 30 Apr 2026 04:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6B476B0092; Thu, 30 Apr 2026 04:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB8DE6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:00:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74547120578
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:00:42 +0000 (UTC)
X-FDA: 84714475524.13.3A423C7
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 69FAD40018
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:00:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TPOjDrso;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777536040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=395fctHYQWwzFa8cn8+ZgdKCuiD4fH+LQX11O5QnDXA=;
	b=JSRH8CGrRddw641GHvR4DNUZEv0kY1o54BFaflvA4KCloHOYoklrx12m2ZLfn5SEyLx4BW
	o8v1Xf9yrA5rCAOjsyfFl4hlrZlQ2hDLo/GgJ+jyIGFObXUuruK+Up0bw89lSHRdCMZYTZ
	GwW2Wakq6O26QJrf7oyCBQH2vDTHMxE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TPOjDrso;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777536040; a=rsa-sha256;
	cv=pass;
	b=42Izy1enZCU2ReYzt8mrirKVcaUk+JRzJaNcLfIcV2U8YPWzORjiHhSHYsfm53HS/n8F+y
	v3KU1wAHvUpbBoDT5mwDqjIgQ79kdmsLOWNBkEsrl/HHPYKfipwNiEWXQTOQOWgUHfyPWt
	kzlSMUnvYfNAdL1/ARUTqroC+Sgxrqs=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-67b6da5a618so218335a12.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:00:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777536039; cv=none;
        d=google.com; s=arc-20240605;
        b=GCjKngOUS+sle0zKd9iZqdsBEArU2jz4S7m60YleptynJ7jhQV12MXO1Q4XK2hIHXD
         vRJVNnfZx6AqgLsunUhXtpUILtneMFVqvGY5T/ehuOVLD6Y18MocgTVCmasaf0Hm4ij7
         V59C0i+tA+OWUKlot+m0wtbeOtSjnLxjxwn6sNPcY5JOtOVNbeIuIAzleQNwkkCY3zAx
         CFfJo6yK4g7qX8mFdIASsaQdxgHf3nMG2iycJ4DA07zWAWYpcaMl1zBurEVyFEmQxAVx
         9ABCCbjZ4Guch4iEXOtr1RuCHmwBnu0NikikHssst7wqkH3eda2dql9n51PWBmuaQvbV
         mhew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=395fctHYQWwzFa8cn8+ZgdKCuiD4fH+LQX11O5QnDXA=;
        fh=fuefeysMSvWDIJa/Wgmmy9mFB917D4ol4BVjIG8d6X8=;
        b=iH/L/Z58h8GxSoeVN5mXohl01KkVsmNO6gquh9I8iNJSvwGIqYJfpiKS6O8mJvs5MX
         SxnMsMB/SrEQxabbe7tF7HuRPQF7SRbqjchiSedeRvR363vQ2opwBHqFFOjarTPfHGBY
         Tx/8RPE/UVEkNaHCFLO4pCbRmJR3qN7Xb3sin8XEu5ft5mGxrRhbdJRxfapcTmVZ+RPi
         bamU3EORUBke/XP/t3cigwrGg3Tcqug3nbVSCfgwUBGybtOHFYJp4a1ucRqQIpYuV4no
         xEHuh33rh/TZB9Toi53kwbUMqCa50bYgH+WBphWIUPN4exVOpy6pi2tzReLVwhllQ3Qp
         Ll+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777536039; x=1778140839; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=395fctHYQWwzFa8cn8+ZgdKCuiD4fH+LQX11O5QnDXA=;
        b=TPOjDrsoLV7FOIsnJCW84VO+7wmoSkJPjaADe5MWsq1OMP84AOLkFa53y8f1XPmxxa
         Feua7rCD+/OaRmDad6ln/CWx5/wdKKAz7fT2wklxsfMcPi/tzNR20aOMxEXh9qGr1auo
         qyv6m1lnXTUf2pb4Uk+8v4o74xxJX/1xYGNuNaqORpNw89jr0lVnNScwHKL6SVhNr917
         8ATYL0TiBHSX2h6M8s1AoQnhuScAe5IQF6foZGdFm2l157xJZ3CyhAdlpN2DLY+eDPBL
         bXlRI5kCRQ758jcYHrBURi/5IqUGd7a7YjZ0RJMf8oEl8qN+ha1uV5R+etBBDk3uWoUc
         5ocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777536039; x=1778140839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=395fctHYQWwzFa8cn8+ZgdKCuiD4fH+LQX11O5QnDXA=;
        b=qlp5LU/lwHjNWMLVd/xFPgDh+dli8jXSGmF9MHVUIpeHUZ8SUN9q6+7dYqoWnQTiWM
         sYWcylUl1/tYgi2Z7NRo9e7vvVCC+D36fnTlHl8+9On5Fogfjof6WeayKCoa4f2ghSUs
         VsxJWlB1jcd1NTeauUQ6GaV14P5VhNdrLlT3LyuZdCV4DQ6dJIUnad6ZARMtqtEqos1/
         m/slIzap0YRl83DoU4g1CYh/Wtp0IrHoOzA13r1S11oOP33DIWXLg9volVScXa/uvXuC
         fiou0ucLpZZBGFgzv8c1ybYN36KqFCBXC6gKqm/X8nnvMoF+Sjb7ZNthdOkJynfshX/5
         76Pg==
X-Forwarded-Encrypted: i=1; AFNElJ9Wty1M76qA+ABNOS+Jvw6I5M2BaLvIFdR0aWF3O5+t51D4bR8QEAB8W2NCARoPvLZLv6a1iyfAlA==@kvack.org
X-Gm-Message-State: AOJu0Ywnw3BCOfF+B+3TGw/oG8FUtIgmhQGZvWJZ+gtE/8b1umCMDcQr
	BP0psJ4+jMV1iIUDwXEs8INXbP0cQGJ71rBR8coATqpPZQEsAHU30JVSza2N7xiPHVpIcI++F5Y
	FA4Ud+RtI+zQ05oxX2CdPsMtbFgBaRLE=
X-Gm-Gg: AeBDievuvIGh5hllqS0vb0Jzfi6kD0roAEGLo8MBGalw31lDDWy6igrbgD45QNPSVfU
	Ua+o3FDLbsPY1yZbXlplyLZ17NnFShMw97SN9nGprxfURddm8ZB21Zk2sA/aEzA/Vm0ERGIJnvL
	pGTwucmmv1OcTMGUb1YGt3HwwGRVFTLkNF9jc5Q/O/B9+7sufV996+QbYD9t4qT/2F8/oyaMwKf
	28LZEC1DSXh8e1JcS2/Yb0OP8Vqil6ojVqWLnGnPJ8gEDHfBXvakk+yYoy6uSjqevzVhIkNsH9G
	P7NrXpAk2resMtVQbkvOgcJRFlh8AiaK7ajPc18cp0cIkyJMhY8=
X-Received: by 2002:a05:6402:43c9:b0:672:c1d6:6855 with SMTP id
 4fb4d7f45d1cf-67b5d7f0ffcmr904050a12.3.1777536038269; Thu, 30 Apr 2026
 01:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
 <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
 <CAO9r8zPV=c9v4Ar7t+xPxyptSUPrs-shrumsz=hCaNa3anGgAA@mail.gmail.com> <CAOptpSMLLz0yzg99nkAp7rxO5RphTDU3Cdqd8020mysijN_Bvg@mail.gmail.com>
In-Reply-To: <CAOptpSMLLz0yzg99nkAp7rxO5RphTDU3Cdqd8020mysijN_Bvg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 30 Apr 2026 16:00:00 +0800
X-Gm-Features: AVHnY4JUDXxYwGV4I-0DZLfShsE2CFdXite8U8qZjnWjSdYjgnJDy3B4Cqq7FUY
Message-ID: <CAMgjq7BTM1HKWwSTxkm7br+L2MDy7=OxEvF+yDRJfFfr24TiVA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69FAD40018
X-Stat-Signature: tnhxsn7f58asz93rpb31oep1nkywi6wi
X-HE-Tag: 1777536040-651132
X-HE-Meta: U2FsdGVkX1/+2X4nK3gsBtW1oym9vHD1xEUT1JwpB5CjIiVr/eO1MAfszNV7Bh/Xs5vW3QKZo4I+CL3FNhPngJ5gIi6mUJZnEiuJkjxYFf+3n4UaN5Vim/VYFmEBHfw6/tC3wvHwugz00ThOEbaGfUAaiEm2phsay31vKy8JUs15WkVwgXZFvdZopev3uSYQdzme0Fst9BmrbTbrYxpC2jD29s6TkHGoQ0ogb10Gt8vFHWmVTSVLAa4tn6J+NZk6aKsLizIzy6xKkDh4Cw8fSIf4WvHbEyTNZtcm0X3S+zG5ua84PWWheKpjsUgP793tafv9XJx5J73d7EOAN4eox/5OqeZ7iUqVXmQXmZl1oGgvOdyh0Fpt74Sw/Eue+fk0DwMM+YOWXCSaKYrJHEfFS3nBtTYJVLbOaom8u2lJJYQ7me5ihDYt/Osq8WvRrm2DrJ7yLUPpBk9hZ+A/hbfueo8n0vJFfumXLGv1iLv7gUiS+3INDcofNlAbOtC8ze915m1SaFnSUjMvhna8ae3mnMMsohzhSggvFUSAahvi5Dy1nBY+cRghTCh5IiMNFdJ9jxieu8SPVa8mESJ7SFzCM1TDbvaIiswyGbr7JGgvMG3BJZa92qqD+oNtg7uYwrXY4ZzQhaFqGHfCk2H9zA8nabpUzlIhvTjoQebQr9xBIfcB9K5S1NoIlLf6Br0LR9/W7NK3l2YkCYTfdHGx+GEFdm2dxT1O+DEe+cRrt+b1gGCNcrf5W4e6ozo1IaHgF0hdOb7bi08wljylbwsJW6GA9XqneBNV68T6zk+zhvxp8Eg+/c21K8usl2qbiG70MmzpU5HcmWpes5GmcBBSG/3HXVYNs//ODWzXH4fPfytCQXHNaHyce6JCoIBGhKKWdjmA9TtfvgeFS1A82UB8xnwTAhVDTipDj6IzBN/4vMz6+8y0mBihCHVfSblElISXyZg0sj6L8KE0aMYcPwZfmTy
 3Osm2WjY
 9BFvgHRVBj2f2USal1Im8RtBKjLYgxWDO22AZKoLSBlXmz27ZMkXDDkeGNyN8SzZHjXirBudOXZGcCuHf/AqpQYQ59Ti6XMPY/JFaX/++9WKOJRDOvkM8SD+l6gNShPA9QVzB9YtAUJSPmJBI4GLu5J1Ty5QP3P50ZIz/0jKKJuoVqllReQkaNUIGYxqAie9e2igUDpw1aurK5sBRH0nhEQVfSaYDtxr8ikkLxaNmgUMz6iZWUK49+f36YxZXPTNqbEzouwjdz0bIHeHGcBpHvboldW7pw+oI059kvNrVTGQ+D1BmpOG/DthC5rCsFTHo6AI9v/CZWdKxtjrtA1dp/9cRZwBd+0ixmrUAOD2BJINjsL+jBN5RzkrXheZSAAAVcOQRTENUxpknr03Df9nlvJRvarANgiL+0C7SUv48ppuuVBsyO83EfKpSWS/f7yFEyBFuMNwGcD19DWsuFhSHYxmTEtsRMsJkCMlpLj6zMh9j6ZTs7C8p/35bajV6J2xA7Ff0Y8VDk87edG3W5hRAi4q3rchZErUFPz9w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 3:43=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
> The data I shared earlier was class_idx-in-obj only =E2=80=94 no
> deferred freeing at all.
>
> > I couldn't immediately tell by looking at this vs. the cover letter.  I=
 wonder
> > what portion of the improvement comes from the deferred freeing?
>
> On top of that, we added deferred freeing in the zsmalloc
> layer (per-cpu page-pool based buffer swap + WQ_UNBOUND
> drain worker). With both class_idx + deferred:
>
> Test 1: concurrent munmap (256MB/process, RPi 4B):
>
>   mode      Base       Deferred    Speedup
>   single    56.2ms     17.2ms      3.27x
>   multi 3p  153.2ms    51.5ms      2.97x
>
> Test 2: single process munmap (various sizes):
>
>   size      Base       Deferred    Speedup
>   64MB      15.0ms     4.3ms       3.47x
>   128MB     28.7ms     8.5ms       3.37x
>   192MB     43.2ms     13.0ms      3.32x
>   256MB     57.0ms     17.3ms      3.30x
>   512MB     114.4ms    38.5ms      2.97x

Hi Wenchao,

One concern here is that the total amount of work is unchanged. I mean
you observe speed up because you offloaded the work to an async
worker. But when under pressure these workers could be a larger
burden. Is it possible for you to measure that part too?

