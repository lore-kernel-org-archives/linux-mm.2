Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E6DCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441886B0005; Tue, 19 May 2026 11:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F19B6B0088; Tue, 19 May 2026 11:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0556B0092; Tue, 19 May 2026 11:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAA66B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:22:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E36B11A05B2
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:22:28 +0000 (UTC)
X-FDA: 84784535976.22.7CA71C6
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id CAE1540003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:22:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GEP5uJ6N;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779204146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iDWAhlCPV3/tme9mQXsHwz4tEUoB63+uViXPcbHvCU=;
	b=f2DcVqRepVJcMfi0OUPbhbF31O+hdiSjzUbtRWGJpoUsjetP6tvL1pwGgSZMzl4M6kFg1x
	fL6KF9q1jrSNyD2XjsAyVV8CqXO5/wQVnzycsy9rEZlqg1F7qLGhGSt7ZRGPC9GQfg3zGA
	Syo+JBkLA7wU+/Ropz8pFTJMKh6Lr8w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779204146; a=rsa-sha256;
	cv=pass;
	b=0+YaIOCuLNY3BiIJMuiOiw385NihdMj3sOkuw5j3hAO0dipH8FDNEej0CdzeaFURzoZuK/
	4QayQgGb/z8m/naShitNi3/rBEPIFHXkcDap5FOdFATD7GrvADGk0ZuCZ0ESzkmGvXbqC+
	nbeBl6OK8PSD8sPcCeKIZocqMxRsIm8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GEP5uJ6N;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso36629085e9.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:22:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779204145; cv=none;
        d=google.com; s=arc-20240605;
        b=U41K9e3FTeilUS2iVqWubHZpsglmU/5F/oei+GGD/VY92schdp6LYm2K8MbxXsEH3w
         Tk2rfvt4G2ZuwZGhnuM2w6Siuy+Hwxn4rH2Tj8npOdssn2vjuZ5onV4Yz8eqjF8gXok5
         EGlFm84GIenwyKkgQCyJa9rJvGtFrfs9uJKu0m0gU5w67tdiD71T4M/2NErp40yDK5VJ
         K4yDNoBBxZPxSBz89VtiUIRPt+8j0/ldy41cEPGoDjfij4epqu2UTl4FKgTmMTZ/IOXb
         S980XTsu/LRZYGOfw5VDVX4aWyVJDQp3/u9kHQcVh9mU1AMLSrbV4gRvMQW6vTJ9XCK7
         6b/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/iDWAhlCPV3/tme9mQXsHwz4tEUoB63+uViXPcbHvCU=;
        fh=i0VLqR4PhsaAnw8YcgvjSnVFFrH3vJXo/tk2vidQyB4=;
        b=bWg0LsMx2JFCwikT3rrrbj+A/K83xMm3b2DLogoqxQQas4hi13GYQE+7sFCM/m+jiz
         GEESKv0vPzgDh2Ujdyi0eYBa8KL5fYxzECPG5qTZD1jKgPm4varqsu0esm3u7mXvllAP
         oZHh/9knW1N9I3qBqe2px/X2mleHt4lgvzLkRD8PeUmt4cQ9/kI8oCDh67hRWNHh5EdC
         akzxhna+AG7ZCRMnbTlZXhV4YU4LQge8gVI2BW6mdF8D4oF7w7hHRTjIR1mc8NffWlHd
         Q+vL+dkhrCmhy1w/Dg3Z3QGED7cZN+D/gqx38FW6l5iGJBf6OP3rwv9rQURK7QSJQw/i
         TpnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779204145; x=1779808945; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iDWAhlCPV3/tme9mQXsHwz4tEUoB63+uViXPcbHvCU=;
        b=GEP5uJ6NGr/PwFPPUG0oQC1gLJdMwhyItZn1PPehJojhBtrFHvnPhJinlzW4FPEHKc
         x1rVMy+ztFi8Wc0L6Wy66BoPWT2LMdupm5JZsxf14YrwXQhgJ3cyX2v8x+flYVpdUwpn
         x7rLz3gAuasQy4MWutAPSDf6yVZ9YKIVr0OsjVNFWSD3Yr61/Timz8F+Am2aqnaX+ZGW
         dfS1NpxzBlewO/ui4qb7vW7FcR2x9RhxshSxekhcVlwoPCoWJHlav8f82TjO7WqnCI6Q
         eE/278Lf274BfdIlXHq/Q8TGx7TV95lgliHzVJz2SxMo0i7gKy9QSrYIgOCvPdf48WkT
         CifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779204145; x=1779808945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/iDWAhlCPV3/tme9mQXsHwz4tEUoB63+uViXPcbHvCU=;
        b=mlQI2Ch+7Hy8Hzxo1axcQaL7LtqpFmJpUK2vuOs41o848F2rEiVLS9MuYAJe+VRgF5
         OOb6/jkakzeLzWOCpXnwtb6s2i5l62ETE8aaPvVk5CzN/g3rzXRWrXbvAkxx/0rIAXrC
         cA/eXfZNIoStd3um+IE5L6n4n+HuwnJMrTlJFOd/bTZRHVqwpXry9TD3ERK3PdXZfPKG
         DYB5BlvZjWhA+yNasPtK5i92WghfR0c/OkLHvp4XY3Yb9aalbdH392oYpOL524KBWAqd
         cU0xJ09sVmM98XHDw5zqq1/6BIF36pZQhibQczvLMc/MfPbj2JujRkXWBF8Qcp8y4cJa
         wKGg==
X-Forwarded-Encrypted: i=1; AFNElJ/hMnBa2pxkIKDKkBI3KmSAyKIoXnCCseYlpSEU56ZVPfIwVTQUgUbqmamx2HFQY9jEjKBNzlVvDA==@kvack.org
X-Gm-Message-State: AOJu0Yxaao0ykxekSicyAsAr5BXkk6xQRyy57IDseLFOjP13jYDx1gjc
	+1skMpkCYTgWu7yk3QotVBpKl5oNU1w9LBsLphPjLlRVZHcv4iHSzT155ziU3QAAEyUU7IKY+eV
	15aHe0IMHpQvmwUZlvqoeRiG1AfiFA8Y=
X-Gm-Gg: Acq92OHYCH84ylt0T/SH5qsbf2eAPzScSOFMozQZx64PfrXep4JruaJzvlbCo43R52f
	ZwOgF1eBpH2i8j7PeWmXw+cwOGhQgNYOneErqq8w9ylA0kbJ7VeFJWWTtB3D3weZi/L+UXed+7N
	x9/QfS5vycoe4ECWS61Roh5Qjpb9W63cUCPAFN8BWQbC+8F2TcnWNPwjxbDQtM/o6li4PLFRY2E
	Lv+5fg+OekQ8jAw9OsbZkWe5N9f6qwL/JLjJskWoZYL1RO0RCMgfdl1MJZreXIY6JuoN0vXVsB8
	6ofx/cag7NuEWyHiDbSXo+6ouq10syYtERSWfHo=
X-Received: by 2002:a05:600c:198d:b0:487:5c0:671f with SMTP id
 5b1f17b1804b1-48fe60e552cmr353658225e9.9.1779204145152; Tue, 19 May 2026
 08:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
 <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
 <CAKEwX=PrfrNys4ao7-d11J7r4pv5VmE8gTU_7iUHaHAKNaFuBQ@mail.gmail.com>
 <CAOptpSOnRCHo35KK5x3S0f5y9+7+dxfznpjNRH072jZvhYHwww@mail.gmail.com>
 <CAKEwX=PgsM4Z0URJcF5VSXX_jdy-cAs2JxDCCR1a8CGwV4tCAg@mail.gmail.com> <CAOptpSMdFwQUxT7bP7s1GWyXvzUQrg3ROtGp3w_zYy2rSkDYRQ@mail.gmail.com>
In-Reply-To: <CAOptpSMdFwQUxT7bP7s1GWyXvzUQrg3ROtGp3w_zYy2rSkDYRQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 19 May 2026 08:22:13 -0700
X-Gm-Features: AVHnY4K_3KhfCUyoOD17UMb7drMZ1A7kQu16M1lcn73pn_ab-u5O9yx4JSFvN1g
Message-ID: <CAKEwX=MPRguTkTgqsD+k=QFB26Drz67CE+DdJ+ZUc_FasOakCw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CAE1540003
X-Stat-Signature: bpkyndqjcbf33ryyx5i1ft1ik1h5j6gg
X-Rspam-User: 
X-HE-Tag: 1779204146-633612
X-HE-Meta: U2FsdGVkX1/T1KDvt/FLL2LSs1gFBTwcPsGe1yt2y7PJqWx0p8bzt5dTo1dGZ0NXAYu7ve9r5VgLaN5muKNO+fAf8imbxfH3xCgBSKdbvTnVXymPbIEmafSqEh12mwmVrP4PzXdo+dL7XmfB7CByCqhUjwHmSJ11lLwHP5+EjvXECY9X1zondwbsQdbwJiOE+fJZrTud2oVLVEv+EWUE1fU2tDhzybCi1HSzaw/TOAeJoeqZPnkt5A3dtyBgp0vrTUIsArK9ejE9pktVVGnr1iljzS4cnXWAIU28MU9r0hYpKLTLV3kf/WXzb77ZK0LmjcxvykaTMLsyRRSJYKkRLBHjCQyclPpTNG4FOXjRDNzkz63w0WT9MDCjlF8hPudMxp+8R7GzL6yPIYZzJDB8eJISjGHxC6gFbcQwlj1jEqzasnyGPfdjfNFJAZPt8sIzfjMiwiqDf6y2MuWVmPiBcIkrSmf+0amiO3t5pHovUEsQ/pB06EL16ZKI+T8JzdwqBuftTs8xjR44K/wpjkX7As1BHZaZ/PW6eb4bf9Yjl6hmLr2U9GJoH1/mr/cUArXz1yYlBBgYx0odFVVbEkD7cUI3081Q5NmMRDNz4RaR707/LYoLgf4u8FZMRoOFdHVl2YIoqpihoOv47fmx5+NPECD4czL6VZLeoWZz6a+5eMc8kfKvoA1RjHrJL4d99D3EOWjy75HfOfQO3xZjF2bLBFXuJnhTTRt1rksrTw84gxdOt/nSY35+ms15fib/XyqXb7CfOXHFmfBAHX9obsAsD78lHOdm4mqoiNA7Yx6bfa8uSm/CqJE3MjaTPIdq7Oy2rnuKCh+POoQuuqZlJq2U8B2coDVHTYR29Uptzx7+UMXRT9Yt2/+YYjd9De0bRhsRgurn44lUD0KAm/qTEgJ4yZNi/goZxy1hqta4uNZgu6QRozUqNihL9GNAc89zYID1IIQL7MHjeJdRSBDKqlB
 dwbNzAFf
 +p60d3l4p4uqVKkFKWQ+YF/UOYPueN3hooJtbSgiNV1oDUgP4ARwE6rymDRJqshgZYRuWDx7++1wLPJkDlc48ha+ck0U6CVidpnlKuwzt8dCzY9NqBMqFMeT0WbHLDIvbDW4MAzud03vrJmzqc7GOuZRuavo2ec24gBA6v2zd130fpCRDiriuQgLa6AnL3ZW1G45cFVLcXHuHzhg8aDrZBGId9ZkOFAuUelQ3VvDn7aResSrTfx1H5dGZiy4sP0pADcOhZrpdgid5Sgc4ODAbE47uE43I6sBISb2XHR5I1aeUmUapuSQ6NFrdBs/+5TDfcuLpq5L1o79ryyoGFeDMPlDUXoCAp6854LRoGQWkWhyL3YQ5AIApDpbYGiQVdmGsVaSFu/vSfcC/lu/U/JpOa98NDnMsd4gP3wW+U0jCVNnm9y7XT9StRr6bX/AC9SLY1r3mtPD0imli905N9QWHjT8QDR3kaVWZNVS5lDxNu29wwZEP9jfNkEUL8qn0OSP3v4p20mqstj+QP/DFyZa8H4uYidper8sCBDrIBZB1ZN2TH7kA3PgZQAGVX4Z7v+MqbHbAEjGFvAWHFkAP6qVAUlbZ2KwhIxQ9/trKYfzz5yDE8uhCD8gECMo3H/b6aH/Y+OgiPm8U/3+sTi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 9, 2026 at 2:08=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com>=
 wrote:
>
> On Sat, May 9, 2026 at 7:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > On Wed, May 6, 2026 at 6:55=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.=
com> wrote:
> > >
> > > On Sat, May 2, 2026 at 3:21=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> =
wrote:
> > > >
> > > >
> > > > Oh man, you are eliminating pool lock here right? This would help m=
y
> > > > other patch series a lot too :)
> > > >
> > > > https://lore.kernel.org/all/CAKEwX=3DM5YpR0cQrryX_y4pm_BuxyUWZ_8Mbh=
Wodwbf1Fe=3Dgzew@mail.gmail.com/
> > > > https://lore.kernel.org/all/CAKEwX=3DPkFiP+u+ThrzjTKBi+usQf2uuhTZcf=
B2BNNA8RboOFDQ@mail.gmail.com/
> > > >
> > >
> > > Yes, exactly. With class_idx encoded in the obj value,
> > > zs_free() can determine the correct size_class without
> > > any pool-level lock. The lockless read gives a valid
> > > class_idx because it's invariant across migration (only
> > > PFN changes), and we re-read obj under class->lock to
> > > get a stable PFN.
> > >
> > > >
> > > > /*
> > > > * The pool->lock protects the race with zpage's migration
> > > > * so it's safe to get the page from handle.
> > > > */
> > > > read_lock(&pool->lock);
> > > > obj =3D handle_to_obj(handle);
> > > > obj_to_zpdesc(obj, &f_zpdesc);
> > > > zspage =3D get_zspage(f_zpdesc);
> > > > class =3D zspage_class(pool, zspage);
> > > > spin_lock(&class->lock);
> > > > read_unlock(&pool->lock);
> > > >
> > > > It's basically just this blob right?
> > > >
> > >
> > > Yes, that's the blob being replaced. On the
> > > ZS_OBJ_CLASS_IDX path (64-bit systems), it becomes:
> > >
> > >     obj =3D handle_to_obj(handle);
> > >     class =3D pool->size_class[obj_to_class_idx(obj)];
> > >     spin_lock(&class->lock);
> > >     obj =3D handle_to_obj(handle); /* re-read for stable PFN */
> > >
> > > No pool->lock at all. We've also added compile-time
> > > gating (#if BITS_PER_LONG >=3D 64) since 32-bit systems
> > > lack the spare bits in OBJ_INDEX to fit class_idx. On
> > > 32-bit, it falls back to the original pool->lock path.
> > >
> >
> > BTW, I've tested your idea with a hacky prototype, when I was playing
> > with my vswap series. It absolutely improves free time in the usemem
> > benchmark :) Idea is very promising - I won't scoop your work of
> > course, just letting you know that at least in my use case, it works
> > :) Look forward to seeing it submitted soon!!!
>
> Thanks, Nhat, that's great to hear.
>
> I've split this part out and posted it as its own series:
>
>   https://lore.kernel.org/linux-mm/20260508061910.3882831-1-haowenchao@xi=
aomi.com
>
> Review there would be very welcome.

Huh I think I might have been unsubscribed from linux-mm again -.-
Weird - I wonder if this is because of Gmail shenanigans.

Can you cc me the thread next time just in case?

>
> Also, could you share the details of your usemem setup? I'd like
> to reproduce it locally on the same baseline.

Sure! I left some notes here:

https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/

But for your convenience, this is the benchmark I ran:

2. Usemem single-threaded: anonymous memory allocation (56GB) on a host
   with 32GB RAM, 16 rounds.

I don't put a limit on the cgroup, relying on global pressure (per
Kairui's instructions).

I'm not on my work server right now so I don't have the exact command,
but hopefully that should be enough to show the wins with your patch
series! I wanted to run it for your patch series myself but I do not
have the cycles right now, unfortunately :(

>
> Thanks,
> Wenchao

