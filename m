Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81954FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88146B008C; Mon, 27 Apr 2026 12:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5FB06B0092; Mon, 27 Apr 2026 12:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976766B0093; Mon, 27 Apr 2026 12:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87B8C6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:28:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82B89A1729
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:15:16 +0000 (UTC)
X-FDA: 84704835432.16.317AD8C
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5259B1C0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:15:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BBglNgnf;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777306514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FC6WaYfu1DAc73+NQ7e2JKxP2obY8GrSWpPpAtjERwY=;
	b=BKaBaoau/a5kkl36fyKlhZ56DhCqsASOrTRNk3xVXJGzN0qpheD3aiEr6QfPOnaDekNdzj
	4Je/5uzcAYmb/mU6h9sm3HXnhYen3Yke7O4Qs7PyKl6xabySWqqWXiunt7XZ6yg5aw3ycP
	0FHTN9t1fopK7JvgePTOHLblpi6MAuU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777306514; a=rsa-sha256;
	cv=pass;
	b=LffxQxI8AYHum7H+3Rs3RHc3VfG4Mj7CmktQtSveIvutBwWhQ9gorPNxAdhEVVjDZD9Y9i
	eaHHN1hyINgs+yo1oyAxmA4UGks03vMqdnJlTFhrcpfb+kfzyXEq76sOF7P9XdCQsFrfEA
	ceQsuImhBhBDFpMe5ci8bK41jrDiMNI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BBglNgnf;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso88847a12.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:15:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777306513; cv=none;
        d=google.com; s=arc-20240605;
        b=ARGevwWBoBRH0nlwxLrdC97mXkioB5K2B+PCJ6OzNaAiN5tY/PXJB9M3Qnf8XJWRuH
         bumQlFQ6IoiiZsdfri5kmLwtnPu6uGkEg9ci6ZuKuurHMRqMrpa2NhdqUAKSNDIhQjek
         Qy7XxHKbX1NVOA45WFfcSss1dOYdznRD+L5ILH3ND1CCzuHOp1e/rW2bgZwEVribZNi1
         V/7NZk0Ai40zMHpyFe4Rxhj+UTlcG1cq6cHcsPAL74hXP9CvExyXEsOXei4f4cg/LJSc
         C2oeUsRsJv9LEmYqDUZ39B6d8EekBQTn90S8jeO9ibVBJ4gXmd9lx4eFrTKxKyB43/ex
         xkVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FC6WaYfu1DAc73+NQ7e2JKxP2obY8GrSWpPpAtjERwY=;
        fh=/ndX37FbounDPw9CPWWBXjVndUciWZnp9YrepdFVHbo=;
        b=Iw9hnsWJz16p4ylvnQTayHMPV3F4PRg0jBXrGO9EADWtACI8Is1IUnxiAbwBiLneW0
         e6kJB0gJwSsaDv9uvztERF3vgMobdaXNg2KJPAL43kwQhw6JWg+tYN5FCSoJoMWbgsaQ
         RmIoj+WECkiPFWdp1TLhswRADm+4P9nAhkvoukuhZrcU2uDSV/LUMGGm7MQEMKaulgSq
         lAJzKNgNo1oOZJpjtln31fv/57NJaF8M8LfhGuXuayCHUOhT7x1y/YoCwgqlBAhApWZO
         ImFbi8I6t76I1toQD5o1bm6vmQaNLIQZaDVhst4bccv/O+N4ry0DaF8zW/t09J6rMM7N
         Oo0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777306513; x=1777911313; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FC6WaYfu1DAc73+NQ7e2JKxP2obY8GrSWpPpAtjERwY=;
        b=BBglNgnfphd5n1y1EvYvlOtoTf0p3ljRRZTfADWtnSadfrsrP+timPHsyqfQv7u0Gs
         rfl8bTlILzPQHBD664/D7tio94hDWPXGOy+qsYpxOBpsBslREs0iX1wmnxK8pOAykvLt
         kFCJEOa9K9+t3/O8MxxsLFEohn3zGLDaZaKlsS+0ExFHlhu4FqkExE1nmHyT+VlMKt9Q
         ztH3FKQuaE9TIDHZTdCpCI4sJvwXZtdI9OcXTbLyQIq9+0YQ91ib1/EP/vtQFYP6UJhj
         DC2/M8PVVjB9Nc/CArdNA3Gu+0oXqAWsJqZF04hDviYIVbpLvRT8zlNdZ72rgkbFWjLP
         mz0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777306513; x=1777911313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FC6WaYfu1DAc73+NQ7e2JKxP2obY8GrSWpPpAtjERwY=;
        b=YAMKYym2qEXKxbTkcJqioTe+a96ryYAU9BD8j87avK4xpNLnsAOUPYyuSVmHHth3+J
         cP+qcEkakX/Fn1ywqDX5tTGitDUgmJYM1sx9BHSKEae/u/5DVyRcyin/4iSSJBKTzcBf
         nAOixYi2C9+eUglkGtSvUgczhizNSjzOe6ncs8VG6fpsfm0CGoF8fBjSgmQeRmEct2v8
         7eYOAsCV6XMGqw2fFLeM75x8vg//NKul4TpodoJyhFvpU32IaVXJ2kFHUhohusweac8s
         aAeGi+uPL+MkpTZHFKmhx+lo9avpOhTOi1Y8yx1QSwAUZ9QiplO2Y+DJ86Fxfq4L+w0d
         1Egw==
X-Forwarded-Encrypted: i=1; AFNElJ91bjBzUcM6ediAbpxkdAh6xmL+d22dqpyWX9Xw8xhqxM1Lh/PuEHmW7ymoeq5a4aTQsKZOhO0urg==@kvack.org
X-Gm-Message-State: AOJu0Yy7ml8H1kJKS2wLtDy31qUqxp0xWocsCCgHZFaVxW+iHyKxEXhx
	iaAjoYUQiRB/lyax3rfQqfL2iqhFcNhD68CdPO+BqtvAU1YgghCEdTDWue6EtBua6nai3SL1sGA
	bw7ZiDWQQAWPKxiO7t4gGyXMLVQBJWp0rngHrPKyY
X-Gm-Gg: AeBDieuz/j7gdC12QZbX9l6/Ed73GYPhnMaG/ZLVS5K8SL1FG9TzkXxF+8nNMg4DTQ5
	nF5amh9luW26C7bmMu3WJ5itg/wD+i3kqgeYxo2vgT3ehU5WPn/UvBo7oDU7XcIlDlktBGSwL78
	9GiEcH8lUf+X2QkAN4JujDGdrH1/RMEHlnlJbTq6ukPzgKgUK64crbFRCC7WKZ4u+qdVhWwfYGy
	Z0P6kBd/P3I6/FkJ396iRRisaea+ErbkLMY9KTj53t4VGg7yAKznFytmcTEXP0Ys4fW6gnF+Ytv
	nJJnnthFPj77eRdfBjXckp2taUA=
X-Received: by 2002:aa7:c7cb:0:b0:668:c2b6:9fa2 with SMTP id
 4fb4d7f45d1cf-679b626daf3mr211a12.7.1777306511908; Mon, 27 Apr 2026 09:15:11
 -0700 (PDT)
MIME-Version: 1.0
References: <20260413223948.556351-1-minchan@kernel.org> <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com> <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com> <aeCHvYOKP1exBBns@tiehlicka>
 <aeHRLv834FCAQlQ8@google.com> <aeHdGf7XDjvOES1V@tiehlicka>
 <aeagUxlju40rvkYQ@google.com> <aenPV9ewKAzRF2Vg@tiehlicka>
 <28c3ae9f-c974-454c-b8ed-ba0ba0a5706d@kernel.org> <CAJuCfpEGCvuaQ43W4_bPjpoiYgmEspxV78-U4dkA2bcjfxCyFA@mail.gmail.com>
 <dfb0e367-894e-4230-98f2-8e5bc554d293@kernel.org>
In-Reply-To: <dfb0e367-894e-4230-98f2-8e5bc554d293@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Apr 2026 09:14:58 -0700
X-Gm-Features: AVHnY4JJxxmzA7sgWEjze6mLmBwQ76JQRoThS_bkstQvwBhzT7IsmyirvQcqKK0
Message-ID: <CAJuCfpExF0V-f5WT-N-77S+P6TwQfgaJGY+TeYpQy_j_tT0_mw@mail.gmail.com>
Subject: Re: [RFC 0/3] mm: process_mrelease: expedited reclaim and auto-kill support
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org, 
	brauner@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	timmurray@google.com, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5259B1C0005
X-Stat-Signature: pzh4jxbjfbe5x1tepoc8n5ahngrpz7tk
X-Rspam-User: 
X-HE-Tag: 1777306514-645157
X-HE-Meta: U2FsdGVkX1+TXCYyCHoA8ZfD7mR/rg486kYJJ5za/tuA/0PSjsc4YbryEOddIFgFs6By7YBH/55U2ffe4eV7MAiP81YBNQVGjiWTaJeGqf6y4RCHJrtXSfJlHBCIQCJQRaPiRVFjmUecyeV61DUxdHPBrgoLy7+5vNKVR1/EjJcGhryN4qAUUWDpBuGvDH3AjIFMrdqY0ERZwmc6Jkg1+l/T08zu6m/z7q5glH+/OJYtlXpnt/ejWYrlNJgpwuHhdmtxZPaOJ4SjyaTRuydSP/LxQQBHo23Csr2GvlOOBl7amMpQRSJoo+QkJzpaDxpwonayqiOjIhB+xYiNzFO16fxgJGNQD+xr1u7WiDLbkqFCX/IpkLCD4dQUU/1htMQezjCf7+1GEEEcSs1mW+duivu6Z4EPyLWZcuj3AJezk6TGpK4hqnBBe+6Rux0D8ubPW3r2R2r7LmdV54gOl2YD5dHTCbRyZW8DHwH49qj69BMwcNBenxof8G7naukGLoYSD5Nf8/jENsE+yrtdq8XkkWHRDGs+zXa74uwOZ+0Tmru/oXUil+kUiq4VHigwNYA3XtUJbL+K26+mYg3FVrg1R9RdKdZpg2I3hkrJAZ+UgP4t/w0Ny4sU3iIyqM+RD44hUIUPXLvI7ZQ/S3FhqqZux5H+g1aDfTKlwYRJvO4uKkspt5P+LqP30Yirkn2cgnddjlP6azoII3t9bfn2ECbglXSCbd7I8pKE6JvCt7ALh2zo1PTdgw5Bk1JCMoGLu6Qu0S5mLYcS2SJ20Cri/mrmdbM95qOTz4QMiAfcGed3dxeO3fdRYPaDFvN0unHMdXR8a94l67wUjxtbQ/v4QEoMLHX5dYcNOGh2GHmPfOedDrAQDsnFAneC94PNbRuwYIEJtdD7nKVIuw9RbtJ1gdjKQT4Kosvbfn03UNcedAbIAbeUiu2Krn7o6OrIKYMVsw/XPU7KHh44HVi1VLd150F
 ekb7iAUL
 5LkpEwa//zhzFSR2fInkUBUUUkImdYjdbSXDXBV3oz6qOsrreuvt7cISHlOBdQ0GGdfTjv7MmA1kWnVypaJa2gIcKDGI2SjSCTkUR6pFp2K1F2ITUMKCvb8FXEbQn9jhgsPZxyxDTlA2QXBn/aWoPL0E0cgIUs+yYkjYJracUzcJ02iX4SzICOh/XZpEA2FZaAPPCR/UWmj4uDOgKuCFd9IRY3m9lo4AG5T+Xu9LVornHZLEq6+vGTCz3B8PKtbxzoqxWIMMPQm6IGyaYj+N+svP9ZAlt5MW+v/qAIRaXnEdJlwzwZk9wmLA00g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 12:41=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/24/26 00:36, Suren Baghdasaryan wrote:
> > On Thu, Apr 23, 2026 at 2:50=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 4/23/26 09:50, Michal Hocko wrote:
> >>> [...]
> >>>
> >>> This is a very creative/disruptive way to do a memory reclaim. From a
> >>> user POV I would much rather see clean page cache reclaimed before my
> >>> apps start to disappear. But this is obviously your call and your use=
rs
> >>> that will care.
> >>>
> >>> Anyway, I still maintain my position. I do not think it is a good
> >>> idea to drop clean page cache as you do not know whether there are ot=
her
> >>> users.
> >
> > I'm very much familiar with these issues in Android and really want to
> > find a good solution for them. IIUC, this RFC tries to address 2
> > things at once:
> > 1. handling clean private page cache when reaping memory of a kill vict=
im;
> > 2. addressing a race between kill() and process_release() when
> > process_release() can't happen before the kill() but if it happens too
> > late after the victim passed its exit_mm() then process_release()
> > fails to find the mm to reap. This defeats the purpose of
> > process_release() call because the actual memory (released by
> > exit_mmap()) might not yet be free and a successful process_release()
> > would be very beneficial.
> >
> > I see these two as separate issues and I'm not sure combining them
> > into a single discussion is a good idea.
> >
> >>
> >> IIRC, Johannes raised in the past the we cannot predict the future.
> >>
> >> For example, if an app gets OOM-killed, wouldn't we usually try restar=
ting it,
> >> re-consuming the clean pagecache pages we would be evicting here?
> >
> > Sure, we can't predict which app the user will use next, so when
> > killing we usually kill the least recently used one. That's a
> > reasonable strategy in most cases.
>
> That makes sense. As long as other apps you open next won't need the same
> libraries etc that you just evicted.

True. However shared libraries have a high chance of being used by
more that one process when we kill a background apps. So, while it's
possible that we might evict a page from a library that will be used
shortly after, it's more likely that pages from such libraries would
not be private to the victim. Again, all this is probabilistic and no
ideal strategy exists without knowing the future. All we can do is
optimize for the most likely scenario.

>
> --
> Cheers,
>
> David

