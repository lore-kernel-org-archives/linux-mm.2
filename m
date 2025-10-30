Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 100E9CCF9F6
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 06:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011B68E012E; Thu, 30 Oct 2025 02:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2B1A8E0112; Thu, 30 Oct 2025 02:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67FD8E012E; Thu, 30 Oct 2025 02:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D57A48E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:34:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CE4F1A0A6B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:34:08 +0000 (UTC)
X-FDA: 84053815776.30.B46324E
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9593380007
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:34:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YkT//i3N";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761806046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zflyYk3NYy4RcPJITCP+PJ6c8wHVT/sLZfTTgaXKfCk=;
	b=0avdoKz5BYpa6u3YA1oQnnEcvX3jH6ahv59Gw1XLMPWTcKx/ObkEjmZimdmQXVo29mh6gb
	KTqUJmoE0mENOcHCm+3A2Z6cU2XkZAKiAulaNLWOpLhUAvFwxEEkOIrwgq+8dskrU/xTD5
	zFWA/jb2oPdXbdiZ8K+qunQtCGMw3fI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761806046; a=rsa-sha256;
	cv=none;
	b=iV8YQL5eTVBIkIJ2fBPhyZRx7e150cOxssWGA9hH8V3ZrOvePCJBo3cU0JNMzAAZ51Unf+
	n2M9F5LPLEh9EjM7p3HEqPCcfEU/5UmEbe5HMKIIQNIhR3R/u4DbNPjuZEJL59lvQjaO8+
	2ERd2NCm56pGCKL/NGHj1v5bV7sxGrg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="YkT//i3N";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-785f96ae837so7763247b3.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761806046; x=1762410846; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zflyYk3NYy4RcPJITCP+PJ6c8wHVT/sLZfTTgaXKfCk=;
        b=YkT//i3Nyec9WLgO90Y3gIeAJYYmKq0+ZhoOqk5Gp6LJGw/kY280d1mi65eFh2mq1S
         AjskOSkhNJ9Mzfb64kShAn46jSU5J0BiT4+/SowOtR/9loL74P+SbImaCRNGPe1a8Vow
         XHwo0I+pURb+0Vv1BQfh5ZVUnhx3sQ+kIfzo0WDfADwpTLBeAFVFDAfA6G7Z9wApAXkJ
         6cz+bSXphpYcFLGYH+LT8WPhZLJ6zIVCE/IXN3qLgRM1+V/pU9GHGqNzHDn0ZdlI/Vis
         RnOPBNgVokOocXz2R3GWn9nFjo8FGHisGAhFetl20ltzYCl8xO1FWTuss/loGv9DAPW2
         oX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761806046; x=1762410846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zflyYk3NYy4RcPJITCP+PJ6c8wHVT/sLZfTTgaXKfCk=;
        b=GTW+Y/TUzp23IPTChZMWPFBZgaP1s2gquMSddST14c9/aw3qIqCqeRtNP2SWY/5FkP
         ExBN1TrcFonuM19ccWdcUYi2JQUQ/9WfkbNmL6X35Bs2ugFZK44iyilQ6JpIRQfMt9kG
         vGHMH9NhPwzfTTXBrQOKNeWWLgLqpc33mPuMLes7c8FLOxKZMp9sEdJzWkyZsLBOvTqy
         D9AHnzORotVRwsISJgeX7EsjKVAkyF9pwYEVEtjrf9Hjv5bUyUCc9q85QUEnD5o+Wm1S
         t/9KYOi+kuJny5a9d5ZtKLHN0WEaxfe4z76y5o8M5L6+LsSKiCQHBNWSh5NfEm3iR+Az
         eZ2w==
X-Forwarded-Encrypted: i=1; AJvYcCUZIpQ17vSMQl22Ao1mu0D/oi44PPskb9TuGkaxXe1j3YFGAPIqxE2s5bs/Hr/CmP1O7X8ERBj+sw==@kvack.org
X-Gm-Message-State: AOJu0Yy1GAJJs70M9KvUWYlu4oKrwrgPi2YyLKPaXAe5kPa1II9W5w0f
	mIA0xzhaXzzBhY8WdjaV3BdE6wm0LrQswdQGhnl7fepMYG3QmhjnAR782iMh6ni3fFFeGj2Kex/
	U4sGtD8Af1Zq3njjwrwoGJHgWjtJu03w=
X-Gm-Gg: ASbGncv+e0Ex7TCf+L70PAhqgRfIjLXDSyfG5OhtkuEtfn9CPm56IviDvCQAmK9Phx2
	rdyO/jKzOnR5Sv0hsUHSG4vF+t1Cgzp3xzRktMtz/i/a/l/UriPxLlevnxGQjMnyGmt8uvplqXt
	rn0E+QOgohX5+XjOViybSPGy0U7V/HDcZVUHRrUrg2IF7wbh2yKJm7FQ82BdCp0X1rZdVW/jYaB
	v5LoXRG4+SKjH7OSo/qvdvBdkbQwzClYcYvKsegQ3EvNF/FhIvZ5S+v0BWJxX7z3AMljihv
X-Google-Smtp-Source: AGHT+IHAkzPCtNQ20ppd+4ZhB3lJD10RCDw7ZQWKRcjkJ/MU+ifVpTXFAcgPBxAL5BiXPDLqVFNv4y1b/arwSry/zk8=
X-Received: by 2002:a05:690c:b95:b0:781:159:33ae with SMTP id
 00721157ae682-78628e82453mr55969657b3.4.1761806045641; Wed, 29 Oct 2025
 23:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev> <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev> <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <871pmle5ng.fsf@linux.dev> <CAADnVQJ+4a97bp26BOpD5A9LOzfJ+XxyNt4bdG8n7jaO6+nV3Q@mail.gmail.com>
 <aQKa5L345s-vBJR1@slm.duckdns.org> <CAADnVQJp9FkPDA7oo-+yZ0SKFbE6w7FzARosLgzLmH74Vv+dow@mail.gmail.com>
 <aQKrZ2bQan8PnAQA@slm.duckdns.org> <CAADnVQJPcqq+w0qDjMV+fx-gYfp6kjuc7m8VD-7saCZ7-bvaBw@mail.gmail.com>
In-Reply-To: <CAADnVQJPcqq+w0qDjMV+fx-gYfp6kjuc7m8VD-7saCZ7-bvaBw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 30 Oct 2025 14:33:29 +0800
X-Gm-Features: AWmQ_bmDSiMH7BHRJ2t-PSFn5y1B5iA1PUPKgXH8mX3AM57qm-0dXLGAddjgEhY
Message-ID: <CALOAHbBW0jM=WZG7BM3Lh=xHBV7M585j85xMzpWAtWdrkRa+nQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops to cgroups
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Song Liu <song@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9593380007
X-Rspamd-Server: rspam02
X-Stat-Signature: j73kns6rddwc3pw18swuwbxpcchco8zt
X-HE-Tag: 1761806046-954401
X-HE-Meta: U2FsdGVkX1+DUGfC0xfRFxtrHMfUTTLbGzTwwKXH9AikzHh1HTBpRfu89K/kb8wcenkAmVxBxv7a0oepfdz8YBpAXd56vWjKZ7OX3cGSLEcTJlNOVpfMfFZQ/QEDPiCIwfsigENVjmOelPAxXFWn7sEiR0XF0mSlb0xhuiReuQipqdGEwfEqsrFGgzyRx6pkaMNT4a6JzP/5ut+KzdAPkr1SlNxgFjv7LhIt4bUR90bbF3wnPaD7KPNYzwSeEbmjv3FRLlwwrr0AjBfTwMImnrDVqBJmiQ4SDeCSlDG2ZV96OtfZiRKJx9JBJny2Oxo7CKgM2kTmuP0CCxQ28zMeOwx2MS4C5qJQENaMm602uN6Kzr+/lF+m3xNG8UgibXFYPtzFQ9LuuG7pkc+zd12HY/YmxOVYAx/iHFBfJqUzpJf32KkEdSAFjE89zFqkGLQ+XSVqFbkvIKXVfY8uzrKV7Oy/me/1e9Zyteh7/RbPs0iYCTf/eyUucainH9gPS1CYUcH8DAfc+83ydecPVDG0pWfmpIe+7qHHCORBmQQgqNDWz40JWIrnGGbrYFQf3Mx+rC/Yxn6XSTKsKisfLiJ77vcOD0NGWp1V35tQ30xLXDLvHrRkfBMj+EYtlaVbd76+aK6BTASS9RumARdoLXvd+rbu9EjL4X+CL3bIN95ih7wYO1pNGZhn1sK0rrTx/wz08pUxb00y02Y4f7Uvn9Z4+LoPfCCHCPlTfpTtObfDEoQeZQCr/QXPBvcFVv4oxAlpEemMo1jNxisIneJzga5yxE4P9/kq6Mk4NFZf0bnY780uXOs/HAC3+fdEi67fYvlkpFW8GicIaJn80lLchahw8i83c250ZRtUymbEmrE4jpL5Ixv2oh/dBiC7n5GBf5uI5tVVV6MVoqt0TeUW//A7oxuef4pWDuxogI1rN8BZfVBiodG//qgdp1KoW5UHq+BmokPWoumhCNjPURh3hV0
 6E49uvCJ
 Wbcl5jPYC2PfKHUEzT8LNdMFGoaMpJm4tBlRt+EqdraqhC1DdZ1wbfMVHb2/mmYh5Yel96xNZGt66O3RbBuoD4uxSAsnHSBvg9I9pRO5L2H/zdUTNdW2s/gNdUs7xPKITwa9fyb1cSdrcWpJvBKiAO2w/gGYPPzTF4m+WSQDghtF8dPrO/wtfLlzk/ZPBQXyHREOzuInmtiKT2InSKNJCu+irfTY1DX1ai++yGD8XviJs687sW/r5XQKD9q9Y1GFAJ6pzeAv0EPbvuOwmh3nAoNBdEPzdADAj3QdFE+14rjr+W07VA1Hh6xxkQ+SWVwLMIRa6kHUwtbg7KfP/Jh+kaIemiVSItPAZEJ5kV++ohWMqmOB12pInxjdttPCoZKLuMAdKG0SePzC4y1MulO5w23Gy9fZNvw84urVgB0h29elMGAAjg5xCSckkLOOfGU7HDpNsZ7Ra5i5h7YYmDD6FV3N70gAWipg7CgFqALc5bWpUwRC7D3ouFmREw11lWk9Wn1Me
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 8:16=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 29, 2025 at 5:03=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
> >
> > Oh, if there are other mechanisms to enforce boundaries, it's not a pro=
blem,
> > but I can almost guarantee as the framework grows, there will be needs =
for
> > kfuncs to identify and verify the callers and handlers communicating wi=
th
> > each other along the hierarchy requiring recursive calls.
>
> tbh I think it's a combination of sched_ext_ops and bpf infra problem.
> All of the scx ops are missing "this" pointer which would have
> been there if it was a C++ class.
> And "this" should be pointing to an instance of class.
> If sched-ext progs are attached to different cgroups, then
> every attachment would have been a different instance and
> different "this".
> Then all kfuncs would effectively be declared as helper
> methods within a class. In this case within "struct sched_ext_ops"
> as functions that ops callback can call but they will
> also have implicit "this" that points back to a particular instance.
>
> Special aux__prog and prog_assoc are not exactly pretty
> workarounds for lack of "this".
>

I also share the concern that supporting the attachment of a single
struct-ops to multiple cgroups appears over-engineered for the current
needs. Given that we do not anticipate a large number of cgroup
attachments in real-world use, implementing such a generalized
mechanism now seems premature. We can always introduce this
functionality later in a backward-compatible manner if concrete use
cases emerge.

That said, if we still decide to move forward with this approach, I
would suggest merging this patch as a standalone change. Doing so
would allow my BPF-THP series to build upon the same mechanism.

--=20
Regards
Yafang

