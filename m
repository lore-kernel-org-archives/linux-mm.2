Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CDECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 16:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004C76B0011; Wed, 27 Aug 2025 12:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E8B6B0012; Wed, 27 Aug 2025 12:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B8B6B0024; Wed, 27 Aug 2025 12:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D4BDB6B0011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:54:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AB44BB54E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:54:22 +0000 (UTC)
X-FDA: 83823135564.20.8483E20
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 327EC1A000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:54:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RYKDHcv5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756313660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFx44C3vvYAz2/lccGCqIrxYWdr0NAByaOrZje54PSU=;
	b=4QlPjba+XYvLb/q8Nh/uZEviPJtqsYAVck+h+W5mVqBxSck1mPEGWkUZdIJGbedGez8AS3
	7ThC0CWFyImSoeI028vQ30m0R8pe0LFOIazOQv2o6inLBKqfOYUTHY/3lkLICx2G4hYsBv
	dq+NUjG6BSk+h75UOKesQSFunOi59Cw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RYKDHcv5;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.222.53 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756313660; a=rsa-sha256;
	cv=none;
	b=d/OlknRg00wekhlhQsYHQU6h6yuLVAHHVv60T4uOexaZnmgcSyZaJkoDMefFgS+sCKfTYJ
	L1CozOchZtk+Pnxtj13InHi4SPmZb6tAncMYdzBKf87rz1x0b7BFJPV5KD8NB0POLOXBwR
	ZA6/LiUssG+xxUlOTBt388iWAR+Akb8=
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-890190d9f89so3691604241.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756313659; x=1756918459; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qFx44C3vvYAz2/lccGCqIrxYWdr0NAByaOrZje54PSU=;
        b=RYKDHcv5GC7k9Nv7tXf/32roHQIqcNpn+FCEhSNJ/2+e/E+MSdnjeppiS2V8udGzY0
         g4VKLTMXsAMjuFJXX1Xrg1ZiyWJYIZzErY6EfYhCOkDk4xeI3NuCXCMDIr3BnzT/kLgr
         La8RHvco18yYPyOkoM7W9ev1P7uFD/eBrXNd1EarxjRyzRCq8P/yJDpFg9reVtR/ERlB
         hb88AxNAM/ZBghnyjl479+OSYDJXTmMI1eX2yi2wkyFmEVbqX+X/Q1nqCNJxZztqVMJl
         a01VDZeqmspCCWtZc+ERLl9s9SCNGkkgHBlLXs2IB51H/yRqqKAwTx2FHKlC0QCt/ioA
         5Jjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756313659; x=1756918459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFx44C3vvYAz2/lccGCqIrxYWdr0NAByaOrZje54PSU=;
        b=NSe/vrjhQhw2KcHjKUOsoJSG6/VsPo6fK57z/SchKN/Sk/FFKi5iOD4qeMqx38XXbo
         +C1gzrhgpSFwBG40wfuTlUmNNyt7sTPq5FnDuxuBaRotC8aNdW3UexN9FxdkcW6TnwOj
         +a+wIFKh5tHJDbfcvVDk42f8UXId04wcWC/PWTY8E4LdJ+UqqfbTNBSkBTRCvDBT/oBi
         IR2mUNb/d4Woor/uTfMtliHgQRXbj/xzdNXs3Q2WEtqcaAey4+klNrHXWT4YasxeJMCs
         YisBPcAb3Xyh1KUgwi3U8rIlvOa5o4EFOAOnic80AV3Bn1nPDwBSFg/ISoKGJkXVBR3T
         tJiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVb4nzX3VOHICtKOvB1ujooQQJR+zxi8iRXYwfcMqGedADHodkGaUwhw35O6v8Z5O7eYf1IK/RGlQ==@kvack.org
X-Gm-Message-State: AOJu0YyM70FX2ujWyO6IRd6i9TuD6cG/x64FsGofWSNFQBHwB7JTjrrm
	aF/V4XkHmCwC0L++TSJrNucdTQjb9z5nlw0fGpoO7XTR7k9XwRQCAMKY/B9Dhy5UGt/YCgO3DxN
	1KhjgMe7z2f4zOSWrZpywIi3nH04xVIRpoY4D22MpxzcSTDr9TCg8vAEA92hCEmo=
X-Gm-Gg: ASbGnculI0dsGWBnWZPJKZs4L7q/QESOi4NSCixo1ECDZ7BUyEwjXShZ+ZbBBiTfzXR
	M10h8kqVoJ649OnmlM8OJ3gGHEaZzS5GDS8+ydzD4jSCA4LYVYvHy9a9jo3w9Jn4/yogKJPbp+L
	YDaQ9eN1NEkAggckl3Ef62g+7qPtjSQGV1TvAB2pyMYryt6qRZmehVJe9aba9XDLIzmulGQyVKq
	wfDFgCX6MDYlMo=
X-Google-Smtp-Source: AGHT+IGIDLPPvvGPZSkU0yF1OlwVp8wo5TpW96HY5AFkJVH60zz8xFo64ZIU2PS+GFi0if9nTHq0FFg5B2nbtrfvmnY=
X-Received: by 2002:a05:690c:60c6:b0:721:3157:fe98 with SMTP id
 00721157ae682-72131580029mr85929007b3.23.1756313240178; Wed, 27 Aug 2025
 09:47:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250826121618.3594169-1-sunjunchao@bytedance.com> <aK8xilDSEaRB3mjj@slm.duckdns.org>
In-Reply-To: <aK8xilDSEaRB3mjj@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Thu, 28 Aug 2025 00:47:09 +0800
X-Gm-Features: Ac12FXyPuppi4FaYe2QZD17lqpKjInxiPaB0BJGOE1U29q5b-AHy7UZmtW1lgyQ
Message-ID: <CAHSKhte2u+Af-_p4ezdGBk_R4f9EtHE7nzpys685kE2oOwY=Aw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, jack@suse.cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 327EC1A000C
X-Stat-Signature: crj3exfbmnk16iezxsgkt4qrfikp4wd6
X-Rspam-User: 
X-HE-Tag: 1756313659-808343
X-HE-Meta: U2FsdGVkX194a4BZdqO07oyvXzvuoWjkG8qjqPH4RdEe4uDtx+gEjw5hTk0Yl9C3wLmzHBxmoruCGtzbWymvmImukY7YVx63ccLRrb+aRZnZvNsYLyJO/Gc8kjq/Kaj7yeApe5LZafdHBQhQLKFG5c45So9Bwo02MOBQvoih18E2XVUFyLmQrpdRcPY3cf5NKpSAEjsdR143GRVuc+PnbIezpZMRABqOUg87NrdLxy/5shaNLHvnfQOWtPWAlIUyhzELWG0nR0SHFe21U+zKVMjLSmG1BjLuPfuWiB7ssIAXGf3Ob7d9+gvZg4q3+z1Hui0lwIKJNVslErIBEbb9EhVqkd7AFHlf6OJI6WE0s7j8PRDqyi6SCz/aXG/VuMA3hcwNqeEt3obvZRAWXWYU+B5XfUCdQr4emw9xfcQL+mzW1R4tUeEV4U37az3MbIDIQLHXJFs1m1eaHROYWYSXzOoEPAdhS2LI+xEpJn95iqdezHV6v/OZUGVEuCRQ9x2qDRHxJPnU+8ICSrttLllxIajyLTL7Y16r+Z9LxOtzSuoo7nWybFXz61MacXnHlhI2RhZYlWC01aIwcGUqXq+DG6HHO9ZKl+LiOpeiLLonVaVdQVA2PxJCtGoyAdCuDQkNYNghicbx9Y1VliDNKMLHiT9GeR/KS4TMrgzusx7qUokI1lJ/s2ji8FYyghcCGHkeLgEdxwvQ0ExNeAFA8NFxVWl8As/XsqTSkZFo4ckshrkqSjpijGAnReXVgL20iwE9QUFbyLKVGdvMZxaJg6vw5PURSOHrR1a35LSOJF52WDQ71wEYGDKlg8CUjbrdxTnb+ZsdN3QziIdYLpnu+K2zYE8lLo1cADbZVOfB7C4gHXYA+VX+BarV2a7vGWPxl8pxY/2N2MEwSju+GP6hWfarJ9BpvSEaK57ilqcv0H9vI8BpgxBuFax4lC82GbmpXYzGvQjixdlGL8AbYlvyLsi
 COwODOdP
 bOrMC0epsYpS3Oiu4ZZRJyA/ONBiibC3hG/kt4nrUjroBwuCIHw84dx8pQ0XwLvepSaklKXtpl+SqFvZiYV+9KONDSj12klbsJ3vcsYp6NBiGTFpaTc/9xv12jzgFpxll2qrs4o+3Ka9GvysDPDCgyjxoG2flMTa7sIqF2qYb7IQreqPxhDezob5b2OOf5GJeLX1qelyZaTKNjF3z68IVRqZ2YA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Aug 28, 2025 at 12:25=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, Aug 26, 2025 at 08:16:18PM +0800, Julian Sun wrote:
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 785173aa0739..f6dd771df369 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -157,11 +157,17 @@ struct mem_cgroup_thresholds {
> >   */
> >  #define MEMCG_CGWB_FRN_CNT   4
> >
> > +struct cgwb_frn_wq_entry {
> > +     struct wb_completion *done;
> > +     struct wait_queue_entry wq_entry;
> > +};
>
> Why not embed wb_completion in the sturct? Also, can you name it
> cgwb_frn_wait instead?

Sure, will update it in next version.
>
> >  struct memcg_cgwb_frn {
> >       u64 bdi_id;                     /* bdi->id of the foreign inode *=
/
> >       int memcg_id;                   /* memcg->css.id of foreign inode=
 */
> >       u64 at;                         /* jiffies_64 at the time of dirt=
ying */
> > -     struct wb_completion done;      /* tracks in-flight foreign write=
backs */
> > +     struct wb_completion *done;     /* tracks in-flight foreign write=
backs */
> > +     struct cgwb_frn_wq_entry *frn_wq; /* used to free resources when =
release memcg */
>
> And the field just "wait". I know wq is used as an abbreviation for waitq
> but it conflicts with workqueue and waitq / wait names seem clearer.

Reasonable. Will update it in next version.
>
> > +static int memcg_cgwb_waitq_callback_fn(struct wait_queue_entry *wq_en=
try, unsigned int mode,
> > +                                     int flags, void *key)
> > +{
> > +     struct cgwb_frn_wq_entry *frn_wq_entry =3D container_of(wq_entry,
> > +                                                     struct cgwb_frn_w=
q_entry, wq_entry);
> > +
> > +     list_del_init_careful(&wq_entry->entry);
>
> Why list_del_init_careful() instead of just list_del()?
>
> > +     kfree(frn_wq_entry->done);
> > +     kfree(frn_wq_entry);
>
> If done is embedded, this will become one free, right?

Yes, this makes it look clearer. Thank you for your review.
>
> Thanks.
>
> --
> tejun


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

