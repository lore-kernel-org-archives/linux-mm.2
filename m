Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8ADC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 034076B0095; Mon, 24 Aug 2026 11:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BD76B0096; Mon, 24 Aug 2026 11:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D7C6B00A2; Mon, 24 Aug 2026 11:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B03736B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:23:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21B3BA2AF6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:23:19 +0000 (UTC)
X-FDA: 85136531718.07.CE43AD6
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16D86140010
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:23:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mI5Vkg/d";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jH77beqs+5zKV6amTfBDwxpeesgjCtaEPDf8Q4m2/ZM=;
	b=ULLbIcJMToVuqCtN0XqgRL1MQhrie9vzl6kRDuLrEqEu9NTuM8H7z5EgxYgbPwgHAL/xdq
	SdN5a3WlEaR52WJ/IqMi2/rVlXAR57bNPGzXnPUBzRVPjSVNE7tib6Sqq0uTuXDIgYw3CC
	37KbG4yjlI0RQReYMKYANuoTuUrOOAQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mI5Vkg/d";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787584997;
	b=zhZFw4bdCs2rf3735zNB6BRlZuOY2pqtqmEFfDNHPEpnrPq/Wwyl86kSYXjKCpjDbrKdW7
	fu9qiIAL8CQ/14uuTYkICPm1L7+D4E+OMBIwG3OW/2MduE06NUd5+ZDWqmnbavelbiXpoS
	9Kg4nDEkSc+tSQNSP8vGyzbS5vPN9Sk=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so6593128a12.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787584995; cv=none;
        d=google.com; s=arc-20260327;
        b=qkmTGrTTkQkTMEiTPNTYkzPH0SszbqWJWikzUVoV5rSvqSUESQmPeagC3mF8X5l1ln
         XnuWn+B9E2hLS+062vTPualu2aO4v2nEDRl/GizddVVVfRw2BcmbGdpgHVV6TkF3TFKJ
         YpfQPEBGvRNjbfd/t9Und10UxPOrY6qRX/jzn6m45CLxKvDSps6OiMFC0c6K6LDiROLE
         AChblP+vzIk4lxRn6P+ENt+qLVVzC7lh/3n++x91BXqSrn9pXbptHgtpeiY9b05+5wJe
         OW3P8NGrmvEN/PE8+BeM1DpYrmzS6tpASxr/C2vaIxkjRNEi1cO5Yk8DDex6Zmsd86ek
         y3PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jH77beqs+5zKV6amTfBDwxpeesgjCtaEPDf8Q4m2/ZM=;
        fh=o21v/VfyC2TwPwU/IcJZEETR4XH0+t7B5F7wfu7Mbkk=;
        b=G0RSYbKee2l00VCRXn0nZqsXpMPs2+GR8fhg/Rc9UvamPEdonysrhR6z5aualJ8J6D
         G0yKEA0q3tieq0qOOBXhzGst2htQFKCPDreT6INFbgd2Cs6ptwahhMBHlwqw8CiApVQ8
         zIMkA3lry/uTmEnyE/3InRbHo0J/IIt9yu/N9GDcVxK08ZreXRzrPIb+274fXiMz0V59
         Ht2ZMi0HRIcFzKm4LcDRs/jpFOfT3lzguyvYQk6XquP+KmwGn9n1pIw3eXxHTujVcPWJ
         Ckhg+Q7NxGCTimEOUWvVji37ppAb2l76iTcc2L9CDPlbJvtfwk/9qSFdDXNIZHQUPxo6
         dYDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787584995; x=1788189795; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jH77beqs+5zKV6amTfBDwxpeesgjCtaEPDf8Q4m2/ZM=;
        b=mI5Vkg/ddEAFXN675oBlBb0T5/77ZGdEdoP9eYS2PhbkDTH7pXWDQe7WA77FCAkL+D
         O8r66T+v3Lxh6XzPDz1TWL/6aV/Jjrt/sywQ4kfgmY86bqP78OyxGz/V8BgbEPyfOUMh
         1jCLUnpEGSVcYW3lQAQkIsICgup2j846Q+ScB0BM+8WSV/bDaJj69yCTHAPmBY9gHA76
         fEIS/iweiJkB/d4x74weuYSASwxjOy6VorPNRwkcluUz4885t9RS5iEvo10S9lESXGJu
         6YpAFBHpChaptlWU3+TDJIC27ngiyFNSyN4+yR0R8djfobrfRFemyiKeTzVLesNhAd1t
         dqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787584995; x=1788189795;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jH77beqs+5zKV6amTfBDwxpeesgjCtaEPDf8Q4m2/ZM=;
        b=eU3A88gJFPIOt5zDuJSevrHqYWvhoN/Ujb/bK2SR8xpAE/eYe3iL0JdAfgDZg5anfL
         894WDxx2y8V+5iqXLn/RPKBt9aYxp5fSBrjGYbnk8iTIN3JLdUnNC3YV7gcfy1lFG7Sr
         ujElKBpJbfsOHUNpVVze3cmCbUx7JN0f5HlFOr4xlDoWDKsvylstZRJoThD/JkfmvRjL
         NEIJoBi4QVksSMWFg1ocZNRpWprx2Xm/zk+/DysRwXxYDideSwabdzlBG60XoSapobar
         BFNuzOBykI8LMDnkB6BR9mUKnqe1ZY/Hxr9ZdnbV+T+OUAq0zDdbUwuIaRXkpxO3/7F5
         481g==
X-Forwarded-Encrypted: i=1; AHgh+RpC+4gDzCn259dI61olmx720RhmQ9he8flJeaB24ITc0UwXm8Ejp782m9Gt05lTZFPWmsWlTMlZnQ==@kvack.org
X-Gm-Message-State: AFuF++k+Y4Mu8PAy0etGlNTZZLJP5F1oKXjEw519yH1oWHGi+cO71l9O
	wdR3S5noS3GNRJUTargglPl9lv/06IRHu093IkYWo03mVlFFo4wpstNb7gKx6C7ktR4R1UaQC9s
	5bcZTDwnmUS5kqWI2Du2F4wI4tsGX6cg=
X-Gm-Gg: AR+sD10NWStaxXD54El1R8nmuUMPMJrZvJJuXjD2CjvQMS5tOQCKSqI/kRAfkTXTHSW
	TIcu4rtXnGC45RLvLWYBgOvc1cqme2YxTO/3pw2hhQM/WJxrCcYAOFeKqxJfBh9JkbowfF6y62M
	f3OucMZoSNUMoAIVQ/0d1+oO5omMfgEERhGpQvfKiZHdMjnODYvmTxT3vAoolNgJ8wVKe5a/T+4
	y7zQZaGZ09lLGLptSkECoWhIHfBCjH1ThIFEUOSKIEkaaDU0eu24iZh1ADZi3DITDX2BmlLTcT+
	46f5Yyf0qmrq2HD+vv5BTXefKus4ywZXWsIVyC5OGwczfw==
X-Received: by 2002:a05:6402:3705:b0:698:8847:e2f8 with SMTP id
 4fb4d7f45d1cf-6a582ba7883mr23687259a12.15.1787584995174; Mon, 24 Aug 2026
 08:23:15 -0700 (PDT)
MIME-Version: 1.0
References: <CALa+Y15zNhpubyH5GQgu_BHesrwRdH0B8k5cqT3o_U0h5A2e-w@mail.gmail.com>
 <20260822003237.88274-1-sj@kernel.org>
In-Reply-To: <20260822003237.88274-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 24 Aug 2026 23:23:03 +0800
X-Gm-Features: AcwNN1UfGZhL6wlAt_EY1z_vCXyRGndLOrHHNLYnegIDLisoABbScauoZxjolc8
Message-ID: <CAN_Opa9dQsz0hA_-+SS7hyHHtrYu2esK2Cp5X=G-YNFr5vgVZA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: SJ Park <sj@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>, Kunwu Chan <kunwu.chan@linux.dev>, 
	akinobu.mita@gmail.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	akpm@linux-foundation.org, corbet@lwn.net, bijan311@gmail.com, 
	ajayjoshi@micron.com, honggyu.kim@sk.com, yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 16D86140010
X-Rspamd-Server: rspam07
X-Stat-Signature: qsgj6df1rnb7ica3iayuuf9349gp91xt
X-HE-Tag: 1787584996-522245
X-HE-Meta: U2FsdGVkX19G2CpMzVoKoJhjSZCeqGau6c8XLNNsYslUoUbjOChrgvbU6JCxu4g755ycKk9QIhiovcz5aYJMAzXxyf2rwDiR8PyxJ2Md/C0rWe29te4DxZEi+29esrh0h+mSpjWDpjkuIG34tAiWk3eVA8HwBKY+a1MDTfDWq2fs7otd44GrQhtf0BTtCGzxo7VW//I+MbkcCafdXvPN3unhyrxMyrg4Wn2U7ug3CfmjeU6gInu9c4H0zAy9hwqUKc1S6e81pPnqd9U27NTKXqyXlK6b4lifijUr2bIaym8fuyGva0IsFo6xtc3l/CA9JLaF54s00aKi9zy3A6+K71dbLm+bh4N/hgKftJS/25JssiQIxSBrB4Zv2SQMTmMP4iygJZ0eozzAFRtcojlTrsw1LvIUGBgWBiKREQlUvpnVagIWM8ETKu3+W5Edh/2cR3peJ2LHiBJzHVbZNI71cnGsZWXrv6542PaCoux2da4ExWjpvoe4wXID++nCxwapC+WknZMllQ+0I7UWEmohLsTmnlZlDtcy9TFa9fxbqLAMJZ4LdlRJIcqlaL5FvY6/gqdG1MpPQxMyPfj5gFzNAPfKpmU/AIDcLp9jmVgUhVeqOj4Mcuv23XeUEMUq1Spyw8aTCmrsYaRR+cLA7Obq8MYU1E1T8qca2gpqDjKwziZjKV7D3TOvvUHJgoJCYlSq+h90yZjFzIxBsqdWhWp6LyqZfaicTZ9bQurnbGsMxNHj4x+Sdo8lHtZXT7r/VptPLm8468VXWq7hHBXK/bXE6wsZwGLz5ZI0ktkk+WmNU5ebTY25tlynJaVh2zxscucGYMLcPYlN29iUqozZfMSsT+17i9UH+U+w6HBDfq/oVDrVggrG/wVWTMmATtcA3kSSL83R6lKwOXLToy8ZEMjDM/0g+49WFUHcGvLq5MmMN8YDMZJLR9WkdY0bFxz687JAHbPMDPPN4GBi4+PWz6r
 dH0pXj90
 HYpAXBMDWffrq6pOOWg1PRsaC5G7QGeb/1yNgOwMLeWujnJf56wzLG2kSXb3N1ZrkCNNmWTtJE8/x/J6UAmHWmmPyvs8b3zyVRx9ED/Z9VNVuFlruKJclh9BQ4mnUUFpBC/EpAzkNqp6BXbc6qtqXa9+Ru4vEDbZhebuHt6iCg3pjKdkKJP4wcZU9A3qgd7De1yJBAu4cWELghVNC4PkJMF5JJ5yJTmI6ybpB+ybUw7Kvn+VeWvSCsPdAVWXAwDAdXKL9wOO0U6+kYtClo9fQuJI2mSOlxospryrvpugH5IJWCMW0IRPKuv1Q3vDKNYK1hk+6mTv7Rcw6cwa2UxBSly86Fm6b1a9vUkvYKh+Z4KGWXswmreFgvIP25pKYpgX+G4assG0vKWDiub6KAyY455IgvDE4OkEYFKYd6mZib3gfiBuqjV5SGF57pCx0cWo9nZwV+u43F1JG1PF3vzHsuvd0QDIrx/GK7aHz9il3gsu4+Z6/lWvO2/BCQeEUIZieaNl0SgmWDlwlGYy5VX5WHiraCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 22, 2026 at 8:32=E2=80=AFAM SJ Park <sj@kernel.org> wrote:
>
> On Fri, 21 Aug 2026 09:32:02 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > On Fri, Aug 21, 2026 at 2:55=E2=80=AFAM KunWu Chan <kunwu.chan@gmail.co=
m> wrote:
> > >
> > > Hi Ravi,
> > >
> > > Thanks for the detailed reply.  The fan-in diagnosis makes perfect se=
nse.
> > >
> > > > Your series is based on the v1 substrate, and the way an event is
> > > > configured is the part that moves most.
> > > >
> > > > [...]
> > >
> > > Glad to hear v2 is on the way.  The probe-based model is actually
> > > something I encountered while building the AUX backend. When multiple
> > > sources can feed the same region (e.g. PTE scanning + SPE/IBS), the
> > > question of how to combine their reports becomes interesting.
> > >
> > > For example, CXL tiering may care about physical-address locality, wh=
ile
> > > per-process monitoring may need virtual-address attribution.  How do =
you
> > > see probe weights being determined =E2=80=94 is that expected to be
> > > scenario-specific, or is there a more general principle behind the
> > > weighting?
> >
> > Hello KunWu,
> >
> > SJ can answer that authoritatively -- the probe and weight interface
> > is his. Here is my understanding which SJ can confirm later:
> >
> > Weights are relative, and only among probes. A context can hold up to f=
our;
> > each report carries its probe index and credits that probe's own hit co=
unt,
> > so two PMU-based probes in one context are scored in proportion to thei=
r
> > weights, and that is where a scenario-specific choice belongs.
> >
> > What does not mix is a weighted probe with the other two sources. Any
> > nonzero weight switches the whole context to probe-weighted scoring, wh=
ich
> > turns page-table access checking off -- so SPE cannot be blended with P=
TE
> > scanning, it replaces it. Page-fault reports carry no probe index; they
> > credit the region's access rate but have no hit count, so under weighte=
d
> > scoring they are not part of the score either. Both coexist with a prob=
e
> > only at weight zero, where everything feeds the same access rate and is
> > indistinguishable afterwards.
> >
> > So for your case I would read it as: PA locality and VA attribution are
> > different targets and different address kinds, which points at separate
> > contexts rather than one context with tuned weights.
>

Thanks, SJ and Ravi, for the detailed clarification.

> Thank you for detailed response, Ravi.  Ravi is correct.  Physical addres=
s and
> virtual addresses wouldn't be able to be monitored with a single DAMON co=
ntext.
> The user may need to have a DAMON context for physical address space, and
> another DAMON context for virtual address spaces.
>

This also corrects an assumption I had about how the DAMON access reporting
model currently combines different sources.

I had previously understood the new push model as something that could
be combined with the existing pull model within the same context. I now
understand that, in the current design, probe-weighted scoring switches
the context away from the existing PTE-based access checking rather than
blending the two.

My previous understanding was therefore off. Thanks for the clarification.

I'll update this point in the blog I'm currently working on, which I've
been writing on and off for almost a month. I'm using it to document the
evolution of the DAMON architecture and the transition from the
traditional pull-based access monitoring toward the new push/probe-based
reporting model.

Thanks,
KunWu

>
> Thanks,
> SJ
>
> [...]

