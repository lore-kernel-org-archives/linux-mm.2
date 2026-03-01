Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61620FD0053
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 04:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 920D36B0005; Sat, 28 Feb 2026 23:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A49A6B0089; Sat, 28 Feb 2026 23:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785A96B008A; Sat, 28 Feb 2026 23:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6545C6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 23:16:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE51A14051A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 04:16:35 +0000 (UTC)
X-FDA: 84496182750.04.61DF689
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 383C71A0002
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 04:16:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VkZuRdq8;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772338594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G05EDu2vHCoC9uNmb2SFsC+eQsN2QMWQ2BWmn0OMJqk=;
	b=JcOckqZ/wz+bxB1vy4y7visR1oyYTTD+c4otxbwIN31ZdvmV02gcOjoSzRYC4ARbPPQdPs
	5RWW1AUfNnB3QNbXsvA/VHlclmC4Pyo2EJRyVW4yftd/OPuZlKNm4GVIeqq2ytfEUtyY0j
	/BglmfmHdK8g+6mU31zCNECri8q4ajk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VkZuRdq8;
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772338594; a=rsa-sha256;
	cv=pass;
	b=Zq+MDvrEN+xCKYpNsAdUHLR4RSQG6LHc1dpZR7KrUW0pmtr46ykytkhYCKf+vaIKpcOzsh
	eR6OEU4+erelhUBMuS/X9NzPqM6z2IhH/jvMnCMXuLVfljuv/dwrxm9gKEw4/1wUlopqU/
	qHF1kavmUSdjTwrOw0n8vfXk/Lt8ZG4=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-899ab9d13d0so27162476d6.0
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:16:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772338593; cv=none;
        d=google.com; s=arc-20240605;
        b=O/KKmz1NmlcoeVWaJjB8FRFM/2rAarGJCt6yEZhW3SaxGBZqAwSaQdVTHj4PIBI+VM
         meyxCUX7/HuCSMOEWlB03ki6VV772ZQ5LpzZzHurut40D3slNZc6lQZzGe9CbEXU0EpR
         cLQQDXfeohrTVwB71jARhxgrmhr63r+nenh4fptmMNCQErOHEzhn11hrg5rdavmXzkcg
         G3NVe+hkdRJpLLRJvT08UngSsnj0T0i2Kz88f49yhcvhwDsmeUZMeC61iH7sGJFwyjnr
         K95ojImcuG4zHtNgKjmyB64FuaP3Ta4LAFfwQiuvivCTK6o6/4637i9MjTfXxFem5560
         faVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G05EDu2vHCoC9uNmb2SFsC+eQsN2QMWQ2BWmn0OMJqk=;
        fh=ZYuTuUMja8nHSGn+WGPIcgBM1u1t4ESOa6UMFsXaNrU=;
        b=T2o4tnUlbc9U+CmlbGXCZV0mdZnjWpBebtZBu/bZbZMqK/gCQWeIF+erhOuaBc5fVS
         abH3JUQeIN/+cC0OaK+sK8lREwTRl7tgwMUZu1W4xsV2MEwhLEwqADuJ8GJ28owrZcgP
         ewdxkP/7CDfIB3FRZurHp9NQV0OP7KMTS27YtTXcirOePcQNMzY/0Kj+H29+LQuiQjI8
         9jW9dSq1LgTnUjvBAaz+3bmk4Y5ygMrCanxYqA4JUcpKDVjNsUPWRwL3Zi0elW4g+vg4
         nXp5XVSYB0y64mU0cpP1rYujKItwlOfLfgwGcwN7d10fqPfAcfFw13L9zIaMp7aVDrYH
         vVMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772338593; x=1772943393; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G05EDu2vHCoC9uNmb2SFsC+eQsN2QMWQ2BWmn0OMJqk=;
        b=VkZuRdq8DC8wPNmlut9eLwrDwQCemmtm9MX59rqeKqjyueXRDo4u9vVhVKlNFswDzP
         DIbAvYajy5ispZ7SZpruSqPhHQjg6w66qOJ7T+dzGK8CjzMEBhOujbVLBkXg76I5Jge4
         yk2jVLPrBcU4yUxF1CM80fYi87bmJNpRyzfmT5wzCDvi095/LvjRILLVB5QI7krmhRva
         3ilcf937C2/ofHg65zEVUXdAGBrgI6pZBhR+ojSEjK6sYvY5iO+oJyYymPxlXv20tL1E
         k6lZJiKs4P19vJpOPv5Ez97Uk65AHU0lAy5njm7273kLpUjH3wRhEe2JItURhhqhDYUo
         OEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772338593; x=1772943393;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G05EDu2vHCoC9uNmb2SFsC+eQsN2QMWQ2BWmn0OMJqk=;
        b=I5J+uzGPjpedKEz78IZakW16yX84AN06m/SjaNeaUhOW3nfiJHeQEG1aigtg0p6jNE
         kRjXyeJuc88IeenK84xl3/SXp9s8pbr8j1e+dQOtlUua3yQ3KD4D23NOpnwDzyv/VYm3
         HPbMiL4XhgSnScfekpfJL7B5DCeA9Qa6lM3sEoyvG/CxuUotGi93p0apiSma305Iinua
         jquYp2+KmNBiDXGzjnvZuPMKw6AVPbnipc27GJy6JzzVga0VDlnwIJ0RU5NMjg63joir
         ia2mRJneJ8mi7Lw4ZyT4+BYWJy0ZS9gMDl9uv+48xvNKSY9fAhS5lqmlOD9BKLLgcCH1
         Hq/g==
X-Forwarded-Encrypted: i=1; AJvYcCWuc91XT0mjdzv7/zqPdy2zlA/ErUD6SH35wpb5hib5SLohyui7AKbYyITdbkT2yYwx5K37n8B40Q==@kvack.org
X-Gm-Message-State: AOJu0YyyZlfyB/dduUntwre2M/nU+wI4ErrjhpGIOUu3S7/ApuK6/vhR
	2pvUia5iUxiTMi1J6o6hxQrquT42+fhyanjZF6ISFLc4vPCLnqskGAqJ0bRL5xkkr6f8D+a8+VL
	/QABzx/s0yZXvHsYIkLtz4+k1DeHe8s8=
X-Gm-Gg: ATEYQzwk1HNHbjtujSc0yYWCTSl7dOlhcBG3u4GrETJ7bZQ5asaqhwCg+6eHEJe//0c
	24AgT5drEpmc4bpc8+1Axw0CzuETs144kuF+yKCkpXypUTLpmKJVzyOS5LevPY70/5Zp62X7aAQ
	73G0u7wU+DPRm/x1bNqG1kjazLtvnbloipimL5gdRKNWwYHMb+HjPdNB1Ir1ofssyITJ4Yomn0q
	54rrAhqfgG6RHfdnXhuOzhHrjjVPDPjzyDa2D1rRJ2AfP2T0xhh1GuL+eskEY++s7zloSrLaDXc
	yHzD+A==
X-Received: by 2002:ad4:4ee1:0:b0:894:3d7d:b488 with SMTP id
 6a1803df08f44-899d1e8f514mr114430876d6.66.1772338592946; Sat, 28 Feb 2026
 20:16:32 -0800 (PST)
MIME-Version: 1.0
References: <20260225223712.3685-1-21cnbao@gmail.com> <2558f7d82b9a482387960f45409e1b76@honor.com>
 <CAGsJ_4wV=OpV-ntZQGKQawrO0kemwdT8byySBCCZiOOgugcQtw@mail.gmail.com> <adfc0959cf294aa4ab71c60ee1e35720@honor.com>
In-Reply-To: <adfc0959cf294aa4ab71c60ee1e35720@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 1 Mar 2026 12:16:21 +0800
X-Gm-Features: AaiRm52HFpwyHb-X-YItA0yeS6EGekp30FDO_EnHs5XeL0STRhlevgBNWywuDvU
Message-ID: <CAGsJ_4xUA9MfzYbTdpGsLsWoRb5ORV=_Vi6-jDh6VC=guOdcbQ@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
To: wangzicheng <wangzicheng@honor.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
	Tangquan Zheng <zhengtangquan@oppo.com>, wangtao <tao.wangtao@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 383C71A0002
X-Rspamd-Server: rspam08
X-Stat-Signature: pbrzktbzawy8figthofpasqrthi9r7id
X-HE-Tag: 1772338594-446024
X-HE-Meta: U2FsdGVkX1+APaLZtvC22oWrAgI+BXKMtR0IquKdZe/gcdQBuYyNsw4Z91Yt0D0FX4nAofFJlaQbBFNg8IB3w1mrzFxDw38iA2CXaWSP/HESaf4GeAjoWJ+jArw5+LOnFJha7ZSxAH1soISjn7cdZXYyqOi+SigffY/CoOiVcJdnhlJpPbyHoOLlMAeebX9Lxp1msPqTycWwFekD/FbfKqV0qgcJbPnGwRP34E85byS5HD0NCDCV3jpkmN/QK0bBjA+15CIucBIlyxZ/FxNrhs507nephHiUFpViFfrOOMVQJrV9dRdoH1fXybc0wHTAASErxiO5nDWogSqQYOjDX/SxO/ffZWU7xFCwnIx6a/pu2U2lW535TqTWGA+IDFgSW5lcc0eCGbApW+K12FdAxbrkcWIWeLAEisDF79hNFQ+S/8L1QhKNS3ThRGPm76d9AHzOsPcZYlb42VZZ1CE3zzmVQ0aMELd6+Se1TqINSCYnQgIziTjK8lcDz7fAopy5Sd+aBk3Jd3bEEoNv8cwQeKN7wAsP371wfg7cAJpKgbenwnSvwWcWBWOt9/id2fGmkUPY5TeEhAp8+xgpIBEsjRV/a1nYS/h+e1Gu5np12+kFmcuIN3V8q40gvrvKASacAb57J/obiArcjiqmlsCmJYRusc9F0Mtkj2QXOWdpJ/rTDhwRJMeqYHmPX9yB147N/NC/8S0CX5Q/cJcz0M/1SqIY+LFrO93zDA6oZ3Y0QJdvoMX8pExl3I4EhHA6L7v2xsV9BcEH7uyaCfQwurbobpNps/1Qm6+g94OEw9fIcizkEl5ajfeY6xNPyjYhiNqQnyNqE2E45NUnKfOzbKJEaa0H4r5NOxW5fXesf92Yb7Qg4GNCpr3IGuJVVwne974YyCbL1CGbWthkoIWfGATDp/Y8Iv4spIkzWEHgqp4sBaCaHDeSX+T7G0Ka8QAXZbaQ67u4BVALBU99Rc/NooT
 X2xE0Mkw
 50MWVYEoolbDCQODaoKorfaxVvTy3SBzKTAf2c/jwlMcvG75xoIwhM2lD5GItTQiVouK1qT3/rXRrY1SiOeNsrsA7KYNwfz1Evt0M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 28, 2026 at 6:28=E2=80=AFPM wangzicheng <wangzicheng@honor.com>=
 wrote:
>
> Hi Barry,
> >
> > I find your concern a bit surprising. If I understand correctly,
> > you=E2=80=99re observing that file folios are currently being over-recl=
aimed.
> > In that case, placing hot pages at the tail might make them harder
> > to reclaim after PTE scanning (since they may still be young), but
> > this seems to violate the fundamental principle of LRU. Moreover,
> > when scanning encounters young file folios, reclaim will simply
> > continue scanning more folios to find reclaimable ones, so scanning
> > hot folios only wastes CPU time.
> > Since read-ahead cold folios are placed at the head, relatively hotter
> > folios may be reclaimed instead, causing refaults and further triggerin=
g
> > reclaim, which can worsen the situation.
> >
> Thank you for the detailed explanation.
> > >
> > > We'll test this when available and report back. We hope to have a
> > > chance to discuss this topic at LSF/MM/BPF.
> > >
> >
> > Sure, thanks!
> >
> > Barry
>
> For evaluation I=E2=80=99m using a workload that repeatedly cold-starts a=
nd
> drives same user actions in 20+ apps on Android.
> I=E2=80=99m comparing baseline(v6.6) vs. the patched kernel and watching
> `/proc/vmstat -> workingset_refault_file`, expecting it to go down.
>
> I ran 3 runs per kernel, but `workingset_refault_file` is quite noisy,
> the Coefficient of Variation is around 40%, so the result doesn=E2=80=99t=
 look
> statistically solid.
>
> Do you have any suggestions on how to measure the benefit more
> robustly? For example:
> - different or longer-running workloads,
> - better normalization for refaults (per time, per faults, etc.),
> - or other vmstat metrics that you found more stable in practice?

I've cc'ed Tangquan, and he may be able to share how he was testing.
Basically, you may want to disable Wi-Fi, as it can introduce a lot of
variability between runs. Aside from refault metrics, you should also
see reduced I/O load and fewer swap-out/in events if you run the same
sequence of apps consistently.

>
> I=E2=80=99m also considering increasing the number of runs and using a t-=
test,
> or comparing the CDF between baseline and patched kernels.
> If you have a preferred methodology, I=E2=80=99d like to align with that.
>

Thanks
Barry

