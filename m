Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F9C4C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B136B008C; Fri, 31 Jul 2026 13:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC516B009D; Fri, 31 Jul 2026 13:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB486B00A3; Fri, 31 Jul 2026 13:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EFA66B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:53:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCBF91A0325
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:53:12 +0000 (UTC)
X-FDA: 85049818224.04.F475FD7
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id EAB0D1C0010
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:53:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KCuzcNwP;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of jyescas@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785520390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjdsh4EKYCo1fXM41Bf3CUpBcyUkB/tKp+gxCM2+8XE=;
	b=juBg6FKSPxkLZsz6+HLiJADfbbW15CF3vaO2Qvn+3X1b2GHHYcDVcpvhvdb398zYKDFhTR
	17h3U5jdf9pJ3fboGhcrS75KsB0ADyMMFmoZi52WwsOKvYXDoXlurzz/yvQL29Hf876SJH
	AAyNRQMLO09LuT/gV/WQFgaYXtlm+Cc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KCuzcNwP;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of jyescas@google.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785520390;
	b=oWOI6tCc47PTcJUw9vO0G5XePOtqqjDorsFki+gGBGGbrCwob4murinbP6o/DzsSPAnKIq
	MuGFbQMM/DOPH2e0amKLWl0yyJ7dvJR/TQI+Fk+tB1KMl8pS3GcbieiNxXOXV8JLYyVxNE
	oLS3WgUuEVwZyFItw5id6B6Wbe4GlTk=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b0129cf6ffso763e87.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:53:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785520389; cv=none;
        d=google.com; s=arc-20260327;
        b=QkVFxk677rrjkrE3/NBgWRGSEc4TXrfLQi1SSWSCawP2JW/zFPVRVEyYiFO83Km7gC
         gAQs4w7yWiIG3TaK7TXcVrwpmlf2R/+p3ETtWLwgO/SSAuF+SD9SvfL8ydm73JdWTCaW
         2isOCzRqmznWfux6gsgFJmZuPzKh0jyuZaABOnKlkiTlitGOHPN1/SbmNQ80fIURsyuB
         m3n5FMmo2de0Hc/fTCyGc9EBGXY7nB8Muukxk4bYCYgWBDGo/blALDDhpNK2vsNA1sBW
         bfo/2RGsKeMQ2FG0Pt+Ne8+STB7NSfHL9/rrKoG0eEkUPyAlnVakupg0vWyiZ0O4dV9s
         alfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xjdsh4EKYCo1fXM41Bf3CUpBcyUkB/tKp+gxCM2+8XE=;
        fh=A2TGchj1Q7WFM2TY5OrXqfdMb0NrmHl5TNV3cHA8+ZU=;
        b=FL3KzJbyQISoLrwADCIoEtDFsdd/9iD+v8BG6w9cWE/zH1bD6M46Qbz0/Hfojrztu8
         QofvVF24iXhN/o3lAmwPHLnNatdeU3ttGuLiVuGNjfF4r8BJm0qbc9ws2aTtuvzKL6sT
         vKzEtzaPS2fezkkyIl3dtCy64xnnm1zYh9HgEo7mXWeCRA4PsYX3vt57t4P0vGAOfAJ1
         cTT9E8ImgP5DeNOJAPJYqBlmKSRZpaSUSlSZB9SjFg7YufyyV0czMJO/x6JKV05bI85N
         /OV300H3bx1M8IahMv/RbC0m/bdiJwPWOQijGUx67lHecDTSRgklZg5HJd2iI2lj7b1x
         Fn9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785520389; x=1786125189; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xjdsh4EKYCo1fXM41Bf3CUpBcyUkB/tKp+gxCM2+8XE=;
        b=KCuzcNwPPjMWchqcIstIdPNlNROCqqJUTJKlOccbzC3dxg09hTYpb6hRAtFM28ww3F
         M5JopIFFlWafFVQYz5krYOfGmPuOv6CNqv5OJhwE4cBL9+gAk211p/IFlnurf9KGWnkc
         4ww16wytKiZ17tkorAFLFOTXacmh7vRj2gDXf1Bk+YY67kkstg0NyqYkED3FjIMlabjC
         dQq15zNArSKCX92AzyEaQfDl8YKTA+t1FX621HJbjGkmXtVk3e4ajymMCd60Jq3VUMA0
         osTevuOJ/pX/NDtnwRx2W7j1hb65u26rFHy06Vd3ezYlufbZPMsqm+vt2cqSnDVXf3rB
         v+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785520389; x=1786125189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xjdsh4EKYCo1fXM41Bf3CUpBcyUkB/tKp+gxCM2+8XE=;
        b=OA5qRQmssC4aq9mvgrBOyXAOXsGvEZCVAOIkYJGBR+3+x4KtVh8y72TCK0L0yJqJ0b
         e/Me/wMMzgFEM2VkUBiKA3KqI+tdToaLcyj3fZP6qtCC1nEam8jQlC0ub5rlSD9r/YiQ
         C6cyRinBWBOsu0Zg/kyTktcYtjJDZ2RpwV5vMHtz8AjRkiR9g9OrcbDHnCkrHAgMTmRa
         wh9tWo/UDhPUra+HYGOOKSkiPHkPDJN89Hx9Jei2cCwtOqPulwZQ1TDTY5ZafTYux5AJ
         UziWFO76dbI2cdNjD/IrRvkKevkgl3g9avmsNUc7BljJQsUvp4S2reqLsyDPV+RYfTsf
         JMQw==
X-Forwarded-Encrypted: i=1; AHgh+RovIpDMRXj0tfkQhGCXoTFFW2Ekw07+SfCtEKUyfaswS/iOQZcuQn6VghYOdl9A6nJRTjPby1xRjQ==@kvack.org
X-Gm-Message-State: AOJu0Ywby6BT0GJyn88lIu2DniVI2Y6wVdCLoGAtYkSGdvymUyAPg6Q2
	6jsWXo+UvUtBxPx6uho89LMO7AnlnYMkYmLGcda6XqjSMeWxWDBSZ4/5XnAcOYl6qi9yEJSk9oW
	jo73cNBUY3IgiA15CoceOxAzEeMB+BClfM7y4T7tR
X-Gm-Gg: AR+sD10BJvi0Yy2elSQ0YvYCUsHJA+ziWRGVz3mnJbtJibNnX2k+ERLRsMHiqluQGNx
	9fGr91jjReCn2a95vc6pvAqn4SQ0Ck3zpFOBTFlkNWKPUw395hVZXG5v3PESUTOQ0mFjgNMkz4S
	Yl8TeqHiwCpLZi2lEUQsUbThN3HIQLa3saY1QhnejoSais1HfDOd5cj2Q9302XyeGet+HvCGi3U
	GsXAxccp2sBHTmWiGiTwe9olzTh8VdBXcZst6GliKTN91T56dIeaaLaGrfdNuRfvlq2I8P+hmgF
	O8/Sfgt/tXY0zsiKkoumnm5E3cf4Q7uRAHML62WoJcvCUBzHwBVmQCQRxwixV6EKmM+cUyOrAhY
	JsaC+X0/ZHtrftQ==
X-Received: by 2002:a05:6512:3042:b0:5ae:b918:79d5 with SMTP id
 2adb3069b0e04-5b2e56a4e59mr15250e87.2.1785520388661; Fri, 31 Jul 2026
 10:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com> <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
 <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com>
 <amsCEe5qDn7CPWvF@lucifer> <CAJDx_rih=0qWpfsnOQYbEwgG1OgPEK23MacTUsJndjiNLV+CGg@mail.gmail.com>
 <amzAPXR_rBqj7qr9@lucifer>
In-Reply-To: <amzAPXR_rBqj7qr9@lucifer>
From: Juan Yescas <jyescas@google.com>
Date: Fri, 31 Jul 2026 10:52:56 -0700
X-Gm-Features: AUfX_mzqHnOMZr_uaX3_pF_KxslL3cBL7QM32XdrBs5VJwfxwQ_OJVcPwDFBEMA
Message-ID: <CAJDx_rgBH0vtdMeJFXJd4wLVtPPakW6c9RQjmbwnWuA41ySWpw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] Page Alloc Hogger
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAB0D1C0010
X-Rspam-User: 
X-Stat-Signature: npa8gd4c61azohwfo5cdddmx9t9765mu
X-HE-Tag: 1785520390-606935
X-HE-Meta: U2FsdGVkX1/ZbPLZrDKh+u+T2s4PlWiZ1w1iYkSQ1j7oIC0Thx0Gi6deC/BtCS4Gv6hunZfeVCxhF9sQ3Vl25nNSOhiciqoKR4xw9HY0XVaoCjbUtQE/p3BkvUaHMg8dAbw/ut2llFOdHw9AQFv6O33MOIWneynB3yhqJeOR8PQ9VEfurs4F/ktfzfvHyuDpal0gj63InRsLgLHmtrVNmmob6pUY0gJTxJO0LDkdFCDqxYCaFR5ifH0maUwiuBFErr9tY1XCY9aufuiHEQdunGaMMQuTd3aYpTA9CMjNYMiTBPti3td1trou6GKEoOUFYBRBr6cbL3T5DG9xlj/C7rakHvNXKL4xYLn1NJA8q1NPbHe3EUgUZgAwRpUivRllAMtGjcuVeJR21m2nC4QG6GhFgsJvJVgT0hQ8GiOr0Me9LW/HrQ/XqTye/uqE/gWUbMEOnWyrNujdSxyXtSEtL8AV1+G0ZBlOjABGyD/b1fOYjNnyn16ghxeZAoe50c77NWbRueQIR4yqQo/fFJjeWxVvn7s+VCHtVZFzL4IM9Fdm5yxX+LAVz+JL1zhs31Cv1+06shn9R5sWUBCC2FCOZIVwR0QyjR4rsAz/E3MBRmJTT6QMr+cQud+18w/jhbzgFocD4FuZUZA+bUV1ze3wxNeT+GQI531aKLDPMhP/2KQapwUaROmvqxJt++4oQiopI5DNBUYXgurJgvs3jF6ZjovrkBfio5dJZZgjUm/eE4bnYQApZT/5ASSqld2e/7jd6gM0xYR1DIiTUdbL+JnpKn45NjPqygZrSCDsEDxKUZikrXCRjBKy9WyifvRKcavrQ/vmjGeeRO4Am+c6JkNQMbxgKNAwvIo5T2um7ds/0S+Eq0AylRHMeNuRL8yFb9IO/AB4zTEyYENjS/UBMB9/XKy8TrrLRWDJjvaeXHNEk6YTtWky+ovtSoMwFuqJ1ZwBQPTn243Zo+jwwoSDy1z
 1QlqRjPV
 tGgp1R3G21PvM3nE8he69cmf3ZVSINshXkJBwcPZu5r2WSkx309FBCpfTa6IecjYro8J1POcI9C7v7ypGB9IpmhpnjAhB6UXVYmXpH5QPP1uY2EBgWcn2vQMCf9cKOgOXeaIWBUE0Q484n1C9DGA+hOSx2xrlwxgcrKk1M0esv2D/ol0FdvbSh7MwwNtwO/wDLxjiuWf2ho/1/L3pVXLRsTHDjcD2tK5Tx0ly4R2T1X9f0emf46BALx90ABgXJdEKDX/tSNIMinFMGql2osBk4ND3bWb2EIAYXficU8HnBlxla8suFfE7UQCiMLb/eceFgHaHTfRUltPdMj9y/a3ifghchg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 8:55=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Fri, Jul 31, 2026 at 08:32:35AM -0700, Juan Yescas wrote:
> > On Thu, Jul 30, 2026 at 12:51=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@ker=
nel.org> wrote:
> > >
> > > On Tue, Jul 28, 2026 at 05:36:03PM -0700, Juan Yescas wrote:
> > > > On Tue, Jul 28, 2026 at 12:29=E2=80=AFPM David Hildenbrand (Arm)
> > > > <david@kernel.org> wrote:
> > > > >
> > > > > On 7/23/26 09:47, Juan Yescas wrote:
> > > > > > This patch series introduces the Page Alloc Hogger. The Page Al=
loc Hogger
> > > > > > allows you to allocate memory pages from specific nodes, zones,=
 migration
> > > > > > types, and orders directly via debugfs. This provides key benef=
its for
> > > > > > testing and debugging:
> > > > >
> > > > > Would it be feasible to carry this as an OOT debugging module? Wo=
uld a lot of
> > > > > symbols be missing to achieve that?
> > > > >
> > > >
> > > > Thanks David for the comment.
> > > >
> > > > The only symbol that would be needed to have this module as OOT is
> > > > "migratetype_names".
> > >
> > > I mean you could hardcode these and be pretty safe :) I don't we're g=
oing
> > > to add any time soon and if we did you'd probably need to change the =
module
> > > code anyway?
> >
> > Thanks Lorenzo, I agree, the names can be hardcoded.
>
> Yeah :) I think not such an issue.
>
> >
> > > I feel this debug module should be a noop in core.
> >
> > What would be the main concern here?
> >
> > The reason I wrote this module is because my team and system teams who
> > work in memory,
> > have programs to alloc/free memory to debug memory issues. These
> > programs are not shared and
> > depending on the memory issue, developers customize their programs. If =
we want
> > to allocate memory that is not MOVABLE, we need to write custom kernel
> > drivers for that. This code
> > is reinvented constantly by developers.
>
> Exposing internal implementation details via debugfs is problematic as a =
core
> feature.
>

I see your concern.  However, the information this module makes
available is already
visible in /proc/pagetypeinfo.

> It's not impossible for this to be upstream however as a separate driver =
on the
> basis of people re-inventing?

You are right, I should have mentioned the most important reasons for
upstreaming this module.

We are planning to use this module to:

- test kswap/direct reclaim/OOM/etc are triggered under certain
conditions (add test cases)
- debug CMA allocations
- benchmark apps  (4kb vs 16kb page size) under the same memory pressure an=
d
measure # reclaims/kswap triggers/OOM conditions, etc.
- there are issues reported by partners that only happened when memory
is fragmented and
memory allocations fall back to different migrate types, etc. Being
able to reproduce these memory conditions
with the current tools is hard; however, this module makes that easy.

Thanks
Juan

>
> >
> > With this self contained module, we can allocate any valid memory from
> > any node/zone/order/migrate type
> > without needing custom programs or drivers.
> >
> > Greetings
> > Juan
> >
> > > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

