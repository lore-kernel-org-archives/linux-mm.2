Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D99C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6396B0096; Tue, 28 Jul 2026 16:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67A26B0098; Tue, 28 Jul 2026 16:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F8F6B0099; Tue, 28 Jul 2026 16:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE0E6B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:31:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AF35404E3
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:31:26 +0000 (UTC)
X-FDA: 85039330572.14.F69A499
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 93C874000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:31:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="HY/sGOcc";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of pratmal@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785270684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+gdrCD6x4jI++tlW4BafXvn0zPc1UaBDwNSYo1OXHEU=;
	b=6s7k39rttr8NP5LP4i8BW0PS+uepfLmNQ9GND9dp+o1pIGfKD58mw/gjMFP+EIUfL9UiEc
	qp4jo4VDnz+bb+/b9HXgdNUk6l5qY8UgWSWCGrxz9VbAxHHeq2tEziroWCU1PazhrN1mt5
	6iaIPsid3iOsW7h/5NbZWyTrw47Iw84=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="HY/sGOcc";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of pratmal@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785270684;
	b=L9/CihuCwDxduj0mq71Q1SRNsKk/XKSWr8yFfWTvnmhAIixwJJyWfwLso77x5uoNvqM6NY
	T1yDeLSGVX6Ap2JIfnQCu/7CnWaxRrXOjC0kBwV7k8dPdJTUQPEI1E+X3KL0PLSqmmfW+D
	ytuUfPrfc1RnGJmpQL0v8aJ06aWrqF4=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c15a5b265so86741cf.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:31:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785270683; cv=none;
        d=google.com; s=arc-20260327;
        b=lGQrjp+mDLbleM40nTrRM+55ABxUQL/zj7xPl5xc1jwpwjfPRI8B8wYrcX1NewHTMm
         nZtB/oXWRrAb4z+HAwjdizJeJtPqsqFMTMzJANeGqzlj1m0gLJWyLDyWsOzrU8jU3lSl
         6NjQZfayBNQz/LwwR7NVwSGJzPEPnQuka5jz0Xjul7zlFEiO8nHi6K/GcKGZebTFXvtx
         Lz8xjEjPgZ0O1cAfvsTt39+L/lHDwPPIVmjIIufnAsOZjX/KTG+WAc+oZblQfka/xISb
         ii6YrJEhE/fVTx5hx1jjBLKSKelbkdCZzF0xSMyKk1KsgvsIJ06i0oWqwdRY5xP79sPk
         vnYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+gdrCD6x4jI++tlW4BafXvn0zPc1UaBDwNSYo1OXHEU=;
        fh=Wwq/JZJpqd+uM55H68gBJT6gBocgtWdGTuZBEkOz9Dk=;
        b=o9O1XvKPTbq4ly6S6DlLSgnn60EOajIXppQxTGrOTwvkZyqA8z6VeSgyNjIRDNx9et
         5xiEBPeSbncEDNKsGsPwSKdoIaPHfpyz+PnEF9Mg+uomzOEZeTtrRya++DvgTWrnBgey
         nxGHLx5pfhaO9KFTbhv7KZMusjt7JN/PHRt/mHq6BjD/nzICeHmTRYJyt050a0abBLqs
         ZR45jNQTRKZBihuEZTGWyQaycWGB1dWMBz9Nz+LQok2R8Nqq1Q9CZQusFSoQWpHnwaiY
         kZYSJTkh5EtGT6obMkedn8dOCw8VY3vEYPE7ndlqS/8goScoa3UsME0bvxbrV9hKTJbU
         iKGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785270683; x=1785875483; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+gdrCD6x4jI++tlW4BafXvn0zPc1UaBDwNSYo1OXHEU=;
        b=HY/sGOccuyMC28vBvP4bOuNhqh8jnDtFtZUsYNFflgm7692pP0X7ezTWd3b8DOSdnV
         IBs/+GpBb42ipYWSFKEEOzSelSvK7ufoj0VEB5FA1FkkeBKr1Z0I+Xj42BxhAhO2Fvn4
         rnbygKDNopqqcJ6V0Adjv/aRDIlMICpcJWlKa5ezYA38EuLDcei3W0B1eiOsVFVPSUUu
         7ahGsncTFFrcImZ4eljFj9+dwFb3UdajWSSEIupuHttssvDA7yNj5wUOJEytT5X5ZTDv
         kvV7cDej3+cKSwOOJDrWewQpOBydp/cU6Op8tyZt7UGmSwFIUkIkBt1NIkfs7F/lvi12
         keqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785270683; x=1785875483;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+gdrCD6x4jI++tlW4BafXvn0zPc1UaBDwNSYo1OXHEU=;
        b=YXile/JiVdQUssurp8sFj/z2SvzUJRpoAntDoT+BpKQqz6vpBfgTn7uyw8tfQ36EhM
         IL0zvdAXfo44OshvFbex2AnUv1YGnaMZ7oktiI6z9kjv2WrdBRfgDjgaTwboZOHbok8x
         IJKl/yzj1nMTeKcV3rNSy+UA1lpGr/2fHTg7yLK9VNaYeJuICB1TLf9vJyn5q7sPrkST
         3fz3rXmfL0a6e2JcgcTXJfm5dJzjS4VSjMpfzL8YiTNiKGn/plNUqw8RcnN8uxaGQbQQ
         HoYFLW5iuf6OZCo59GG3jjs0Oa40v2Abju/NkwCXGZVWL8pA7BDqFdR+LNMXB3yji03t
         EY9A==
X-Forwarded-Encrypted: i=1; AHgh+RoW0Q2pWzQNIcseAebQ5OrowlTGy5L8sbC7McbrwBHDKS17opbJOtI2wcEhKDQ8JQmQ2sYZVraT9w==@kvack.org
X-Gm-Message-State: AOJu0YxyCEadypmORPDpx+FLqJMgXq+e7D4GdHAmJ33E2x5cj/DuGq+O
	sGLytuAk8rjN3/C6R7dbNKN2/1IVCLyvObilGm39muu3nTfz4xzh8eQTCP4LiqsSmMsqu5wjgV8
	beg7ImUfg1fJF6tJIT1rNV66+AAxvliJxgHFC79EO
X-Gm-Gg: AR+sD12ikWDnVBkUWvWGEhqaJGyMnPIcV+Hr3AIzkvWU+bUd9rezvX3Z1z9GSQgkcfa
	cA3zNQroIXRjLQcp0MZNBJf4IAIGJqufi9lzCWeXgbyJwznH5ZLOZ3DJpUNh47Aqr6kIrk9PjnW
	bAtwuBlQT9xqGJUmqkMf3C7VDR3dLPQYhx0dWIFUyql1epVYCaOgspLLyhjV8Qc7LFQ+VogTQUK
	PKEtZ2SU3nnZWL1SgJBL0T3isKuz65ao3Gl62GkC22DxJtpl7eGHOCb5fcVMUF3YwfqlKBD9BF/
	CSDyqMa4Ndrfbebpxku54NBUs4mQah0H1K09Wh+zxVoZLNVDox6NgwBd1GzSJBohmQB+TISp/FK
	6sU0qfx0xlg==
X-Received: by 2002:a05:622a:e198:20b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-529a5c1acfamr62875321cf.0.1785270682059; Tue, 28 Jul 2026
 13:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260727230545.262579-1-pratmal@google.com> <amiN82J8p5z9l_Rm@lucifer>
 <91b61f02-c533-41b9-b680-7de52a5c6918@kernel.org>
In-Reply-To: <91b61f02-c533-41b9-b680-7de52a5c6918@kernel.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Tue, 28 Jul 2026 13:31:10 -0700
X-Gm-Features: AUfX_mxgIRJBXBwbH7AVrBFi5kQIUVjGvMfmV7Gjhyfe0uQX7ygDuNF5Wvy5kVA
Message-ID: <CALHaPKeOs25YNRg60+NxfS3E5RYLt5hJqFNX02ZCEBrjcDua0Q@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module parameter
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, sj@kernel.org, 
	corbet@lwn.net, skhan@linuxfoundation.org, anshuman.khandual@arm.com, 
	gthelen@google.com, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, liam@infradead.org, rppt@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93C874000A
X-Stat-Signature: kx5i5w9b4rado8cx7t5demiu113bty9r
X-HE-Tag: 1785270684-52450
X-HE-Meta: U2FsdGVkX19KDimvA98ye7MTCIHiKpfK08Qvcd5d/45tcH4bINV2d7w5FA4NqJXHpTco+EVxLG22iMF6aZAvJ8XsH2HSD48ayGO6QINKcVrLa+OwPdwRQyp9paTeuzlAAdRRJUhxIBHL2iDwodwrfeHHz/3o7TJgkwCJPz4RI4GvOvTlmUNXpnT1px0FbMbVzWYxhcuzpRxljfrwUuG/Ymp7WF9Pm/8DjNdYIm8l23cRLrBOZWJRuRHsZAyq8Lik6ESX6Loq8a/PTTB83xSEBhh/hTSBSYWW1RJg3ydokjtMLMAugstQ5MGYBuU4abPBDRKSOcCGwcSpILJGxpPaUplUlaiaxo48RmrWI4c1CgD/R1qeNY/15zoBlNcST0jUn3t3FzkxJRbUYmEFb8NHS197JBlMCeYNuogqr8f7mMwc3WZLAlKDzjLT5FUpunQbztSiKqAJmY3WmcAzHy9tZYQ/2m11O3nzaaOCzQdjmWFUU77HEhVKBFJOdSzf9z3Y6czv4omjbkWkrHKQ1hBNVbXVla+SvDTWcWJviZ04NOoaSWKck2HSKvnCEoHLud+jT8cBZQjAh3CyY9cM3ZPyQ0S7jeEERs4uZLqFE4bVuBx3TIiG3G8AFLA+jp32rK56p4qmfLg3ZuKvEyFAHLO9dqGX1y1mNHsd7+QjBm5AIKqXksx7LVn3jO6ZWdhWsEGMbHnTOONb1A140xui9i5YXXvstirTFzuJJwCtb6+4BvnW6gWGYXXTIqidhWZk70OGOk47dfQbQf+swLTYM+USuH1lr/LtAceM99lCCNGHEV6Q/j/BssKqOelBIX9zNfyGajfziGPxjG2DyZyJafThf3w2Nqb9Iw7sDinoiu6FUuvDqouTmGvq9HL4HlU9Thv0K7jOm1F27CsyQ4lMlOo6TqHtAPtXqeyGBbVUvNkdasrmoZN5QWL35U1cQ5Z4XNQ5FTSqB37g09P/QhpcUuk
 UZOz1M1o
 jMfwPBs95pc5xgA/2br6pF0texwVkxCsa3JyHIoKHTqg8TUEkq/ipnEL9c4izu0nSv1dhzBxyfgq+jlprSksrRSNThrDRC664k0TiFt9dqdm/v66qFv+egut3jHwF50g9W5cq5SJlTZelAXFz7A5Sz5PLZQL4zTgD0oYe8AQtjq3AcwUaSFHwy0hadoOjDFTFsBfD9x5eBJ8ckFQqmaiI2dVrRz/eqvObf5X+/gwcS92mC6eIcPxW1jlkKxMToIWpjK7GLGiDpJWjUEw543NiZsPPs016AEFILMaXDv8Ux3QpVJhBVi7DbUeDM8MRfhvG4cpOwE2LhNCZMUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 11:55=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/28/26 13:13, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Jul 27, 2026 at 11:05:45PM +0000, pratmal@google.com wrote:
> >> From: Pratyush Mallick <pratmal@google.com>
> >>
> >> Currently, the free page reporting uses a hardcoded delay of
> >> (2 HZ) between reporting intervals. While this is a reasonable
> >> default, it lacks the flexibility to adapt to varying guest workloads.
> >>
> >> A low delay allows aggressive memory reclamation, returning unused
> >> pages to the host as quickly as possible. However, during spiky
> >> allocation/free churn, this immediate reporting can lead to a severe
> >> performance penalty (nested page faults) as the guest re-allocates mem=
ory
> >> that the host has just unmapped. In these scenarios, there is benefit
> >> from increasing the delay to batch free pages over a longer window,
> >> absorbing the churn without hypercall and re-fault overhead.
> >
> > Since you're talking about increasing it, maybe set the floor at the cu=
rrent
> > value of 2s?

We benefit equally by setting the value to zero as well. This would immedia=
tely
report the pages being freed back to the host without any delay. This helps=
 when
the host is under pressure, as any immediate memory release would help it.

> >>
> >> This patch exposes the delay as a module parameter:
> >> /sys/module/page_reporting/parameters/page_reporting_delay_ms, measure=
d
> >> in milliseconds and defaults to 2000ms.
> >
> > I'm not sure this is great as it means we now have a parameter we have =
to
> > support forever and autotuning becomes harder to implement, also if lat=
er the
> > implementation is changed, this might prevent a reimplementation.
>
> While I'd prefer to keep the implementation as simple as possible unless =
really
> required, I guess auto-tune could be enabled by setting the parameter to =
e.g.,
> -1 in the future.

The case we're trying to solve involves tuning free page reporting based on=
 host
memory pressure. I think the host is the primary beneficiary of free page
reporting, so if we wanted to dynamically autotune this delay, we would nee=
d
some mechanism from the host to enlighten the guest about its current memor=
y
pressure and the autotuner would build its heuristics around it.
As far as I understand, no such mechanism currently exists. While
we do have ballooning, it requires the guest to actively allocate memory un=
der
pressure, which makes it a comparatively slower mechanism and wouldn't help
much for simply adjusting the reporting rate of already free pages.

> >>      /*
> >> -     * Delay the start of work to allow a sizable queue to build. For
> >> -     * now we are limiting this to running no more than once every
> >> -     * couple of seconds.
> >> +     * Delay the start of work to allow a sizable queue to build.
> >> +     * We limit this based on page_reporting_delay_ms.
> >>       */
> >> -    schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY);
> >> +    schedule_delayed_work(&prdev->work,
> >> +                          msecs_to_jiffies(page_reporting_delay_ms));
> >
> > Err, do we not want to limit this to something sensible? What if the us=
er
> > specifies 0 does it just hammer the system at that stage?
>
> IIUC, 0 just means "as soon there is a suitable free page block to report=
, start
> reporting immediately".
>
> With 2s, we wait 2s before we start reporting immediately by kicking the
> workqueue immediately.
>
> So "0" does not mean "report all the time", rather "start reporting immed=
iately
> as we are notified about a pageblock to report".

Right. Setting the delay to 0 does not hammer the system. The execution
is constrained by two checks:
1. The worker is only scheduled when high-order pages (default is >=3D 2MB)=
 are
freed. This makes scheduling relatively infrequent compared to normal 4K
page allocations.
2. Even when the worker wakes up, the actual expensive operations, such
as page isolation, acquiring locks, and hypercalls to report pages, are
guarded by the watermark check in page_reporting_process_zone(). We only
proceed with reporting if the zone has enough free pages to fill the
capacity batches (32 slots by default). If the watermark is not met,
the worker simply
exits and returns to the IDLE state without issuing any hypercalls.

> >>       state =3D atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_ID=
LE);
> >>       if (state =3D=3D PAGE_REPORTING_REQUESTED)
> >> -             schedule_delayed_work(&prdev->work, PAGE_REPORTING_DELAY=
);
> >> +             schedule_delayed_work(&prdev->work,
> >> +                                   msecs_to_jiffies(page_reporting_de=
lay_ms));
> >
> > This code is duplicated, while you've making this change maybe pull thi=
s into
> > its own function?
> >

Thanks. I can create a new function for this and send a V4.

Regards,
Pratyush

