Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C95CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 02:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401AA6B0005; Sun, 14 Jun 2026 22:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B8E6B008A; Sun, 14 Jun 2026 22:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2532A6B008C; Sun, 14 Jun 2026 22:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 111526B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:36:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B46714088B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:36:44 +0000 (UTC)
X-FDA: 84880583928.15.F04F3FF
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 81876180003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:36:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wFD77Of1;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781491002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJpiISLfF5OllrNNsWNRiDqnUU6n6kaAJcyx4pm15u8=;
	b=mRU3qDGnI5DaYigEsibxIUFGlvxuiI0i5XQpZZSCs2ZtoEXKcqCt2VA3r4d6uE0AFP6Ia0
	Pf1qkO6Q9yvKCKYrwMdS7DBG9ilh4YGyoFYeOGrvT4gxpnWnQGu6GFANKXOHsjhMS0bd/6
	ixwVHpyngJvvSk5nl3yhthVcHIgzQOU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781491002;
	b=id+kkFnkfjiUghts6cR6ir+zeRZrcykDDZYXcStmGPLLel+y4UfA6M6kz2Q+kowmIl/RzK
	UPjYh9uW44oWcm66Vlzmy3qQbLbeElNc8Gh0yMb84jQuwFgdff0LopETJER8pO8awpo7wi
	20McbBiqJf/om2szVgrOCxY0QYREru0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wFD77Of1;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51765531803so818811cf.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:36:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781491001; cv=none;
        d=google.com; s=arc-20240605;
        b=Y+GTlfhvBLtlfjlMvIEigoKPc3arYKCbAanEmFNheZRRJrgQokIFjN19EebaZVsiZV
         jVw8IV4A2JEeEhlc1oWfCIBHwRBW1YIte0rF3o9KWLD/i5bsNrmG8Lq0LgXr2xI+8OUu
         uVrdd2/PcP1ryPvLUeloacIdKAVkMYhJKurSMO5ZqSQ3/fuQOc0rq2xCF2BbxlzDVD3i
         knWmVJ/gEZd/Ro0mnOLkjPl8HtF98MmUwNWmpLuvZYeDo5UlhfJE54gWK7yibdry+RWx
         s6O77H6004RynYAmeZl7iuvqjQpUV61Ju1bkXmNzv+lBnnsU+02aAyCD0r6fNTJ40RYz
         EnzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zJpiISLfF5OllrNNsWNRiDqnUU6n6kaAJcyx4pm15u8=;
        fh=40u2XRdftyihW4/sRW1dUJyq+01LiIMwgO7gHlnuVE8=;
        b=TjuWbYLwB5knarIwcHtKCWjLiHE0otGf0yL0LK+LRwe1LQzbOdFsKZVh6VZbWJiMxR
         WOdT0JuKKq88dflNXo9Eu4tGAhcU2zwZLLLnsAYHRcJQ8OGeR6cyHMTcJg+pOIBC/Xu9
         MAoRTBYGhLQL0a55glV9FpLTL7FMJSxIx4diS9ps7RFkSYdp9s49eKEitpntARFIRQaK
         zcIa932jFottrdJrix2OivkYlEwM3K3kBASbRph0PRn5g1C9XZnmLQmVDX0Y4KI4pfTA
         64gNy4A/1jKLs5cL+oce/ekcC8oYoEzbwAv1Bw0nlBSmoaB2cA25ochjACFoX0eLuyLK
         TvtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781491001; x=1782095801; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJpiISLfF5OllrNNsWNRiDqnUU6n6kaAJcyx4pm15u8=;
        b=wFD77Of1Awdai5m1LJAoh6sFRvXcfHfrdKs7yhwZzz/e9VO/fO0GT0AbLKwW4rG/HX
         K7PY9HHQuiGq8t1hjY94cCXJIcSjTWmyLx7Z8AyeGLdUNLrk5D4EeyXvmZFWD0n/QXlt
         iurncW0BNxui31WC1tOM92cKvs+76YNC/Zl005t0C8d7vBeat0Kq02MOHkGLrpsHiv3C
         pB4BDQSdNzFOF5EGfSDq/daXq6lx2EU28/aq2a988KhV3RKOHM8EsnbMJJaq9txiCOUc
         T8pfW7cWA3eZz+xxC8FUlZBBvb0uzruI0nmjjJn3rzgRmbK/g1RsnrXhAfdyGoSNcYtW
         7xpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781491001; x=1782095801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zJpiISLfF5OllrNNsWNRiDqnUU6n6kaAJcyx4pm15u8=;
        b=UZlesLjLih4HgZ14j3sOH2QQkkSGe/7D1Ojp3XNOVwVR6NQs2X182LJLKBU+HCQVi5
         1y2oRQ77CyH8BSZ7hNICK7MNadCkTEL8IPkZz0Si2bmSVSgQmgTtQxWCVsF8v3GDDZJF
         XCE3C0AzwojEmcsyVZDctwBHegPsR89ZTWZuHO6Zlx6iL7TyoqZLOU5G3GIoEL9XVPnq
         VB+9wee83YLjnVeP/+Dn4bdLVAImrvb0Em+eT/s0KJZABIDgBOMu2n8lRsRlyXMdEMmd
         ZqeHqmcgM2wXprDKMQajtffK8bSX2di0voZqmkqErt4bec8mUm338b2XUiLxOn7aXr8m
         wrHA==
X-Forwarded-Encrypted: i=1; AFNElJ8Yzm4CflQIIKhfAOZee7kipbwkTJ4etEB5+fEx22G+oGuVYM5WRZ3jxXGM4b6WSOKWV02zkV/iPA==@kvack.org
X-Gm-Message-State: AOJu0YwCKSdI2zemvgMIdQqO7MVRuKp41f9ry+JRIHHL4Q0axb1uD6qy
	dAW6ZsE6pPfAFmJg9gZDc8RhQBv2KNpmScJcIQdEQzvuuc/RrOpoc4bd4KqQybriT0N+tyVlRi2
	08Kou1xvfJT+yPvC34AMhThvhZRia8lJBZzeAr16A
X-Gm-Gg: Acq92OEycyaNaTallUaMNxRUnA8AgMyN93MkYU3KIDWpxANk2rOX61BNoM2v1solrBL
	MLI5axCkb4oYiQ67djY8chsoAi7uSKW85Ysl4ljeJeF4xdzhJ0RVsPWcL3U9VxPlzD8ugPwz2w0
	ARZrNce/uhol+4QEDyEN22om+b+FJafKaei0HDJolzt0PX93+U/9/WAqbtNJVubphX2NdJQU4Wv
	wnOOjm5rNRBlQUKu5rWOG8lDzSmcLTFJBDNXydY8P2SALHtRfzlPko1wKOaVsxTlpvWI6KCTfDG
	xxyZiQ==
X-Received: by 2002:a05:622a:5514:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-519549b131emr13606831cf.4.1781491000974; Sun, 14 Jun 2026
 19:36:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org> <f9b7935c-f5f0-496c-b55e-1f3feee5c87a@kernel.org>
In-Reply-To: <f9b7935c-f5f0-496c-b55e-1f3feee5c87a@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 19:36:30 -0700
X-Gm-Features: AVVi8CdV4PtT2_MsVUv9NaJhoTf5K03I_WYn_c2jFY2--uC0YvXIO7SM0baYEVk
Message-ID: <CAJuCfpE3XfxLmV-DzM5nLqYqGsFJThr-1i4bmEEqMpGZ28RLFQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/16] mm/slab: replace struct partial_context with slab_alloc_context
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 81876180003
X-Rspam-User: 
X-Stat-Signature: b3uz63htfdtqs6j8dha37aikrdoicxui
X-Rspamd-Server: rspam08
X-HE-Tag: 1781491002-18849
X-HE-Meta: U2FsdGVkX180BHXNNTSUcQOK2Xim+WSQLwwgX6X12TPnzjwhg9zDSBGQQEN8OZePc+aV1iyYowiAWe6F2ZHHM+J6FPvhUBoQEX0vMt6zSiADi221UUDFRGSIkZs6DUdHk1gcrw9WeC/ONKsAGZ8f7ZbPJqpZP3Owaeorch/kwCfqa3AjXAeWpnkuhoNEHMSQJxLEmGmMqP8Rbv6W1eQeR8eF4+0ug7ffdk+epZfAxhp3+2wBQp651yvyjb5aFgL1yg5ukkhE/L3YSG0dhJOw6+dJjvpeRsHqGUvZhSkomGm0N2rfdoDDyEPSuLIHr2uklmkW8fOOLkzWLXRzxYG2pLmP7XnLALwTbX+oIU8liId8Sod02X22Q7FGoT8H/1ADeN80ElHdXPVF45lc3UO+olGfSY0zPS0puYJNV5GM94CkKobvNzVvyJY6qWp+NvsFzgGR0+9qKrlLJZIvrazFiF8AT6E2FBfJOS9jwZCx2wN7OwwIBFSgII+YpPSZigx2QrHo6oOvDo6vPeiqXSXnt+XizTs6GqUpuBvbOhBOcgjRWPyba4xaEyO4OHNX2cEvyrxDEMMiE0I+C96okh8vA6JL9iVVoLkXM0tZtvtGmhZRsmYw9AKcIDThM6Y/qzFg8XbzalL7oN6qlAwpZJVE6bdRLsPXAyGBjaTfsQ1hteTI9KUKcTInbcS2+oWgh37hmljnWkh7JsCV1vauYdYmoaC3YKBUQfdEn9eEHXYpKF0EcVnZ+M2F37lf60KcLFXU6DzL8UxqyR1uhqGUHQgtZefz/XoGuJsrxu3FKcUt696wsx5kqnrUEib60C10MxS/sdGMMODdC1SUE+uMdU+o79fmFkJHDcKtITZIz1EwmAKO7itbxaNXOK7/EU74PECsFwZ50drlsrFT2aRgocEQ8hSVzBjTs5Kz2CMR1x4KOXzxcCBVbLxd+j38wzUJrorTzRtMkdCCZ5ObaDCrkz6
 os4Ftzn9
 AciAtSA0inWWiHs8S1J+ZM5SJKbrdwBmYNtWSLFJfgBZ6zzLGT/mHVg7p+NxAwWIGEXGT1U7BIG3ubRIA2wglDe9J18431lwDKb09uTwp7LEq6U80MODXI4jYrWq1M1WsOAa9/JkoMSKZQe0mHh0HLWREIPSYkYM5OUa9ozU+ivqt5au6fmFPkb2CuoYGY+azZBRWV5El3T0oicunCc8qucPKI8C/fP7viz1wm1Q4w6MqQdPT1jHfD1aoFAnUI5B0Iha2omvqJwN/5Ajo9/MJR4IEI5tyfiCgCyG8c+HVARPvuyAPpApG2YyTpeXvzApHhika7XbyWmjQ8g4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 11:05=E2=80=AFPM Harry Yoo <harry@kernel.org> wrote=
:
>
>
>
> On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> > Refactor get_from_partial_node(), get_from_any_partial(),
> > get_from_partial() and ___slab_alloc().
> >
> > Remove struct partial_context, which used to be more substantial but
> > shrank as part of the sheaves conversion. Instead pass gfp_flags and
> > pointer to the new slab_alloc_context, which together is a superset of
> > partial_context.
> >
> > This means alloc_flags are now available and we can use them to
> > determine if spinning is allowed, further reducing false positive "not
> > allowed" in the slow path due to gfp flags lacking __GFP_RECLAIM.
> >
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Ah, nice! The conversion I was anticipating in the previous patch...
I would do this removal of partial_context as patch 6 and then convert
___slab_alloc() and get_from_any_partial*() altogether in patch 7. I
think that would keep the behavior of the ___slab_alloc() more robust
throughout the patchset. But I would say it's nice to have, not a
must-have.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Cheers,
> Harry / Hyeonggon

