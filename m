Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C79C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8646B00C2; Wed,  2 Sep 2026 17:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679566B00C3; Wed,  2 Sep 2026 17:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543966B00C4; Wed,  2 Sep 2026 17:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1221B6B00C2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88000401EC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:43:38 +0000 (UTC)
X-FDA: 85170149316.12.3C0FC65
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 919D2C0004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:43:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hA17Ybiq;
	spf=pass (imf28.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788385416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AewweDjB9+QXh8QGv7gMEp2wY/6gq9YTT95QofeEYtM=;
	b=eG0Wa4wYIYsjUdGuqE/Lhnvulg4cBLoFfxHCn2EFNtYFblCJJbLJeRxpPSBI9BnvO5XKUX
	/zsGl0o6hU0e9m8CY0Y3lvV8t0imulkzchnS7P/KU6Htcs+cn/wwQNebk96nFiPghMLVJr
	1puPpb6PzIVopV39OIBCuAC8hTg+NbQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788385416;
	b=teOiY86Mweb5SiL8O+mr4WEIgn/kz5d06iBxvoWYvUTHRAUQHZrw6qtG0zwxyYr87Gke8b
	QzifGwsGvIYYUMCwUfI8bn4NgAyHTxLdC3iFqvsXdGXryE6EYP/7Ih5RgdCDFMFCh6PYyB
	ic2rvW9A30al6ge5LJ6fVKcvpzWPpNw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hA17Ybiq;
	spf=pass (imf28.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49557167508so16057625e9.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 14:43:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788385415; cv=none;
        d=google.com; s=arc-20260327;
        b=kSIrrUoXEVbcFHdDlGkoYWeJOwKNpHaQd4Hvw+SQ+58c/MuWnc3O1dolq0bTs2z25y
         ycEjUkVMQOGcgTkoV0n9b/1FUE6lC+DUL7RjJAvxgllVdEQeztN/f3hKhsqtb1XJN6H5
         m2WKV5ObUfeo7Csjyqr4JxZNE+RGmPrAGxn47IW5p6BU3A2rvi4RrDYBIRrS/Cqo20on
         IzF1p97MdmGfKj19TXUAmqKd5SL/dec0Kdl7KmUxE/fwfrq9Z4huwPzHbudikejJ9ncM
         KXrWl9WioQxIjH9/8CmBszxGgAkE2GcSXmhbYRIa7lyDmCc5We1aJGyTFgDggKcBjl9Q
         CtNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AewweDjB9+QXh8QGv7gMEp2wY/6gq9YTT95QofeEYtM=;
        fh=qkicGlnaLc4lRCbChl1mpGFsSjePncsaz+xzVpjEfOE=;
        b=Jn4+XZ4DXpYm6ss8tcOVf22GY0MyUoC/qm+ZpP8tTXhsIziA9ixBcmIAPCa8AmvjxH
         OHCvGsZIJXdZj5XSa2qw6TRisgaWs7ayy4+RNT1xFx08vWTSjpcNn+yElpfr7Aqq8kNJ
         n57RW9XQh0HZM4P27vRg/9Bl0gXpW0tyUeAynO2MkgFPTzTovuBxSbKkYqnlg07/rSGo
         jnTW7jvRymkmHPlSpdNuvcXOqVImsAD4k4+xE11w5rccxK0+T6apkngUwk7H8oe8/AjG
         m9kIEW/mZR17G+mIDGo3b2NcXUkv0HwNe8BIqDRhUUWLVxLsOgy73GiI/vHE1azg2/Qw
         UNmQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788385415; x=1788990215; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AewweDjB9+QXh8QGv7gMEp2wY/6gq9YTT95QofeEYtM=;
        b=hA17Ybiqq3qBjQerDE+peaoiHf1zdTvgXt2eUqIG8jXiuDltA42iosU9QsTQBok5uu
         uFYTEjoEVwAlS+QiZAbnMq+wIzmCSeLFXTlLiJkgGebpITvsPNcgiOWIFiFH2JBnc5aN
         82Xp9RkYCNsebaJQ0oO/MqBLwwylDxUCKE3gWcw6nrtbO/zFSwgTIpXDQo4lRLODQChn
         S+GtURDeOLZsVxKKvOqfJgNRKTuGZqGKfSI6wQrTzSARCAfQ0LJd9MbngCVlErurkFKB
         kz+BqQqiLnHE3CbSag7wBhweS6utQnQf7s51zd8P6S6uUURmf6d8pmgcg5KdRdeFsdvn
         ObgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788385415; x=1788990215;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AewweDjB9+QXh8QGv7gMEp2wY/6gq9YTT95QofeEYtM=;
        b=XbL1QOoXRdLKbj9O47AdPnMwISbnJ+uivJ0rO7VgriNZy3Q/qkBgdA++8f9fmFtSSU
         ounw+L5Y5zgPWZVPZHADZ8NSte1KSwmad7oz/Cen7X7kf8bOIkwjVFPm+rwLUBCbgt+T
         PPgXsDUwqHo8x9F2odkhK5p7jpl2rmitKffdTX4Hzz0NLaS9zJHaW8COgR5h+ti1mkgk
         +vAF+sU9EIXlSgxdNJXo5Q2jDorqKtQqnz361WqMjNyKVl96Dcl7KaaPHxP3nWgT/JJ5
         uChKUC8J8nhR+Gl/AcMDLu1B3DLaj0TH0xTRzRpglOblWcoQfn8jtm9i0MpjdonX+/5u
         a2kA==
X-Forwarded-Encrypted: i=1; AKwUvByuKsdB4hngsGMbltu7yHcd+XVm02J1BRgVBElxdo4sseSzEubJUvSzE1lfidW8gfrydrPaQ6OuJg==@kvack.org
X-Gm-Message-State: AFuF++liTq2Ar1JuivSrfiLjwoNrGSawPjwSpDCwXbaAvkf05ivxHlEW
	8s8uhed8B32iMPjumbUjs9B8I02JcjBPyX/gO6ZkanN5lwq3p0nIKUnus2xbdNXhxvZfHtYP4vq
	4Q7ecoTMAnNeLEHtHOGTuP7l5tEOpXpQ=
X-Gm-Gg: AYBFou3YxRVJRK4LKlH1oRcEAuGkUXbrwZa7qmYEFFdYnaiUAq3oUB87VtwVUdKfe2s
	OTzZo85D8EHZ8p8W553MmAw/qgJoJYIS9hQR0KTbkc/lTvqxljTXeNeKRmal7AY1MyRatSNkmYJ
	DKPDZXRKXSiuTbxddq4Nr5+/uNDS5HtXSX9AFNO4rubpxRRBHHW5NxYRxXzUBc9yt/DODp58Rq1
	FVtb5dt1tKCWWA1gz0cAJzuL09k3KnTqYIC4qSOY88eG1f8qizjjuCNb9ibEtsH4YYFx8sNqQJH
	n2zEC/ZoIpXeeVrBwoDGuTOxtiD7kCKcBJZtCi3KzY70bia/GKYM8g2PMDOXxDJlVw9CnNRyU1F
	ZtTTH6bLWWoALmgBMkpV5Ak5rTmo=
X-Received: by 2002:a05:600c:1909:b0:499:ae94:be05 with SMTP id
 5b1f17b1804b1-49ce55cb36amr117683635e9.0.1788385414830; Wed, 02 Sep 2026
 14:43:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260902205406.624782-1-joannelkoong@gmail.com> <CAO9r8zPqXkWBPbObB1ngCjUWjXJJ8sD4a7ZtfGOLQe+-NfD=zw@mail.gmail.com>
In-Reply-To: <CAO9r8zPqXkWBPbObB1ngCjUWjXJJ8sD4a7ZtfGOLQe+-NfD=zw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 2 Sep 2026 14:43:22 -0700
X-Gm-Features: AcwNN1VBdMWGtAIe6_hbwXmJgOUWR-EKlScm0Z8jBWXtnllsqPiwms1lhhZnyv8
Message-ID: <CAJnrk1bMcr=+yigJAS1yf_GzYiPN_BMSOwbtLuU50jj+pinH0w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memcontrol: skip non-hierarchical memcg-wide stats
 on the default hierarchy
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 919D2C0004
X-Stat-Signature: jttoquc8thg7iuhsrwfhu7hua5qxgoh7
X-HE-Tag: 1788385416-512135
X-HE-Meta: U2FsdGVkX1+49Lw3JUxEqt3ZHn0QtBC3BJpPGsFNMcsa4RvOHvmGv0TKto4ajzSNCcYfL4nh5iGe4ocWtBmVJbaSC953M6KTuChQsnpIYbNlJB3ms5l/6hQyYEkpxvPWZZ3lwQktYScgFdUgVYjHAML44181Z1QyW/yICb+Hf/sxnFhuFZRY/n+vRW+lI8QCJlgpBtyUZthzxz161MeiCladYbnxuDF9WmQEZ+Y7+wtL/agrHUssoKIStlq+9l0ozTQOi3+epwgMqJXhF5nyvcGUTfb7fKU+FUDNMVyVfOiPq8aaA/VcHLSg9Z/yGnetAUIcg/mnfDM5NXjGHWKbsy80b8EdV3TNx2sGFiF35i0Fii4i0uJF1C3ZW13GY57urJyUdcGbAR6Hnih/b9mRYyvYDJiw1M+hYrdF6iQ0VG1Gr3R2SJyV5a3oYzTdmnioI9a8PSa2lbIBMLLoWYNaHkFK3nbxSEwHgcXUwojuhOiiGDbdbArix6FTx7GCirCtj8zyzVipP95gCmONuVI1M7YklZA3x6BNlozrBwkq/ZiVjCcGHkArE2cvYmPOLzCG8/5AaHX9xSHL9LNbJcnXI2zwmCp9i1vb6SugkA0/MY2p/58x52yIKEVKlaWRFbL46QbYYt+JK9BDMtx2LIljBmjl4K8Jp5Z8weyXNWa+cBt8uOk5bNnqO+jly+coAx5v37bpDAAJ0hCt3LR3PTwlQxBMdO8A2r8ydPKbsFBOZ/o8tiSd1OaJO4PJToc6KYVz5M/mIE11whhqAErJatNTpGw3u/j5EUqtMOy9kZC0C7SvIc/9WSLVhFrvPgBWkhZjAj2kINLa5Au+mZQzFcl25dBoWnq3EAEoGIK9BMhgRuGFdOHHEhvd2Z7g0EzVV7H9Ez4XuP2f/Cm1IDxBiNJnOFcBCbd+/VdDHJ45nCJOjW8afbov93VHzoR3tA/yt+lCCCSTIhvBWeQ5P8SMPUk
 GhCGVa/v
 r/HtVJMuvPn1eB2eVo6Ha5xiYfOdN1zYAaZi+eulz8TX9hroNvDCxI2s9jrgIYsjuBXvbFLfaP67INcE9OiPG0btyAT5fJkHLPYei/9zWW9dYVWC1Xh4AYtrihEI5FLU6VBzTwUmfK6VOXoxuYlgq8AoiFbIpIWPjYbld6b1DKjSxRdiUlD794zl9PXDpXkvejmBAaxWkceM+KyGfKoyQoTJofA5T9brPeU985W3ZJiN7l14DtmtESDC7MOVY5iukXPNDRqIwv95QoOQJ5irGhDLN9DziT+lt3GeVOvwnlDMsSjr/2qcryZwiXQBFAayK7GmaeK63uJEQraKMKsA29J9NF8Jcx0oWrEKi+XlRS/I4zgiBgr6nWcR5R7y2c06GLplabHq0YDjg/gs/TO/oVKiRiwHRUtDKyRgaxjyBAUOPW9aTrW2Gw+cHC0cJBW72eVmxGLK1p6UgPbxGzcP9BUgK+m0QRTNxiuXDg9msWAFh6jYrhdaMeMOzRGZNqs+mE3Jk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 2:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Wed, Sep 2, 2026 at 1:56=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > +#ifdef CONFIG_MEMCG_V1
> > +/*
> > + * Called after the controller has moved between hierarchies, with the=
 on_dfl
> > + * key already in its new state.
> > + *
> > + * If the controller is moving from the default hierarchy to the legac=
y
> > + * hierarchy, vmstats's state_local and events_local arrays need to be=
 populated
> > + * since they get read by the legacy hierarchy. Those values can just =
be taken
> > + * from the vmstats's state and events arrays since rebind_subsystems(=
) only
> > + * allows the move when the root is the only memcg.
> > + */
> > +static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
> > +{
> > +       struct mem_cgroup *memcg =3D mem_cgroup_from_css(root_css);
> > +       int i;
> > +
> > +       if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +               return;
> > +
> > +       /*
> > +        * The flush is necessary because there might be descendants th=
at got
> > +        * destroyed right before the rebind that may have left counts =
in the
> > +        * pending arrays that haven't yet been folded into the state a=
nd events
> > +        * arrays
> > +        */
> > +       __mem_cgroup_flush_stats(memcg, true);
> > +
> > +       /*
> > +        * Not serialized against a concurrent flush. The periodic flus=
her runs
> > +        * on root_mem_cgroup without cgroup_mutex and a flush incremen=
ts state
> > +        * and state_local together. If the flush happens in between wh=
en we
> > +        * read state and write to state_local, its state_local increme=
nt is
> > +        * overwritten and the counter stays short, but the difference =
would be
> > +        * a single CPU's accumulated charges since the last flush and =
the
> > +        * counters are approximate values.
> > +        */
> > +       for (i =3D 0; i < MEMCG_VMSTAT_SIZE; i++)
> > +               memcg->vmstats->state_local[i] =3D memcg->vmstats->stat=
e[i];
> > +
> > +       for (i =3D 0; i < NR_MEMCG_EVENTS; i++)
> > +               memcg->vmstats->events_local[i] =3D memcg->vmstats->eve=
nts[i];
> > +}
>
> I wonder if the complexity is warranted for this optimization to work
> when switching from v2 -> v1, or if we should just query the boot
> parameter.
>

I think you're right that we should just query the boot parameter.
Sashiko pointed out a race [1] in the opposite direction between the
flush and the bind where the flush can overwrite the local[i] value
stored by the bind, which is much worse than the above case where the
bind overwrites the local[i] value stored by the flush.

I'll drop the default hierarchy stuff for v3.

Thanks,
Joanne

[1] https://sashiko.dev/#/patchset/20260902205406.624782-1-joannelkoong%40g=
mail.com

