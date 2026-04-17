Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BE4F8E4A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 05:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0626B0005; Fri, 17 Apr 2026 01:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7520C6B0089; Fri, 17 Apr 2026 01:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6405B6B008A; Fri, 17 Apr 2026 01:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55B8F6B0005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:37:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B84FE140ADA
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:37:56 +0000 (UTC)
X-FDA: 84666941352.04.838ABE4
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id B82781A0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:37:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0ZhOcub;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776404274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1nLhiDGr288dsLMSkKVm+dOqBnN5Kc62Jjcy5ZhGdg=;
	b=kkjLWuyucKJ5kYxUG4p4815QjKgb32Tlr7QPG9C0nkkgugSgj1euG7R2V3j8Deu4aVrLtp
	atXt3V5gUX8+nxc10q1BqSLMoBX+Z6jYNLTiKj6RLtO8vyg2NSLbatUqwDBoQaBeGPXeky
	8iqz79crvZClSHONvGb6ct0RNGrWUlk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776404274; a=rsa-sha256;
	cv=pass;
	b=PxDO2b7Sn42yvMQ1ukHAQsGjhsErWd+FJAGbHHaB0lby3EUmtdCyogM32HPvuLZbUiOmX2
	bpUgoQgul+nf7J55Oo9pMVn4GqH0EATjjv4JmwnB4UNUEfgiEMPNRuib0TFDTKxWtHgwPP
	A8X8IwgE6L9Nq2MnJBT1LMr8hoUhnQw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b0ZhOcub;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43d03db7f87so134396f8f.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:37:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776404273; cv=none;
        d=google.com; s=arc-20240605;
        b=cGWS7wsrqoYfdjTB6qfX+/tm7JOWb2er/FMlbxjWovu2K4z/E5cUCYATGCNfOdEMvg
         eCPuoAlsjwHH2uJAKUfB6VkV0MHYhCl57kQ9BU91VsucQNjYK7e4coRk7UtD/UBTd+22
         tILFuEGuEuC4cyaleGbdz+9qi42eqW0YkD23kZeZ1ve/fW7APajPalRPxPAUQokO6TT4
         FI2KMUCqB0Jlojpmc1dwjxrORRn82SLXLLiWbSNQLirEnYPDTNkBOgIHpcUQwjrdKsVf
         3IAoBRog1TLy7+7tO7KXo+0sVAWJTEeN/F6Wx3XdCrNLhxEaonVB8qk7NtESYGc4d5OC
         w6VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f1nLhiDGr288dsLMSkKVm+dOqBnN5Kc62Jjcy5ZhGdg=;
        fh=OfP79IYh8IDx1u+r7w4C+6RzDD96PHj2Iwlj4+FiFqI=;
        b=BgonYggONqt6xeJ40/B5jet0WCZoVDEWW82vtrqpQ+TzmigaTZRzAaddQr+2fqRV1I
         Alo7526NnmIEIe7ZbGmPa8+YTIucWxIbwr3FvDiWZy1qm6+/ap/5mAJrF88OrVdzIw5f
         2CSt3HIqzyaKrTWShnHFErFABLeD4K4+kqkea0FLCyr2NylVnYO2u7kWrNb7aIOdb9j5
         NC4DdDWcRTHfI7luaK7Fe+wOl5izdqfFUXx+e2f4VY+g2jqHX9nZy0SL7xBebQSbBNBp
         ntg+wifNTM5MVAz2h+HS4Y/CFsQ+a/Ea18UxDCHL5zsfvYFD87ltuyLTynID3A066q53
         lyEw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776404273; x=1777009073; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1nLhiDGr288dsLMSkKVm+dOqBnN5Kc62Jjcy5ZhGdg=;
        b=b0ZhOcub5e6qcUrlh1Esy9Kmja0pevPTCK2gQB0VDvhoShejW8BjFKjC6TjENyI+sO
         pe49Ll0ZVRanSfg6cvhHPavIR1LBZb4aHhi8CEPMI2VlQXNK5O0jsEwXarVg0LRkGs+Y
         vnBmMgdmIrvR7Cu4LMv0C5QaYhO0LLEH6r1PyXbd8E92TAuZGh9emkmMeEFXwyB/UfiI
         a5gNmMEHp2xK69T1G6bNF28cYv784Vjw5ImDS4betKSY5QpPrKNU+47gydY+4EfDGjvd
         dZoG2C60/hgJKx3k1j/tEKw6fufknzx7dS+LDiEff+CUUODfo76C1yVBerhxd1QwDiAl
         1VwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776404273; x=1777009073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f1nLhiDGr288dsLMSkKVm+dOqBnN5Kc62Jjcy5ZhGdg=;
        b=ObL3rDqYWmRPmEVew0CNgc3f+tN1U0uTrWfQCpWGCh01UFGnWaRpEWJyAgu0U4z3FF
         uVgLmgp+TkVbmNuACI1yjSl7ygRP4Bks3pQTd5/mhHlIYXZ8E5/Rk8QdjkMmkeHzBtmF
         /moiSFpjXmEyfKOwSNtJrhI8IKS64MUHW5V5Y8o67CiFtbYC16OiEIN9LvXsZ/9uNObq
         jSZz0ZN0ZUWLZ4ox1xzO7LWScRQ/Umbdxli8pXTO6Q1EmTyC6+RjIg/zwKTmdc0a5Xfp
         oGf95gXA8/cbJw0+5aqYWlqWG1RmqigQLHMvQ0LyRXGJNLvTLbqRqlyYTxkpG1NP3ZTq
         35wg==
X-Forwarded-Encrypted: i=1; AFNElJ90tCnW6S9SCUARhe5gSd20nQahDwmuhPoYse5LpWraCjD4MGPAkbhxvYZugQVlEetr5dCkzXjvEQ==@kvack.org
X-Gm-Message-State: AOJu0YyKgVE6m1wkh/aJYQ83+0rVxMDIHaoMZJVUy9/gIe1ltyJbK8rV
	QAevnyA7ef+5BIs+Sgy55ZqOGXDI6ga9oiixmDDlEb4EstXgu38Kh9i1mNFClM3JggSipDK+P5B
	Ftwxm0u2pHvGkoXPDBV3mkGapdm19DRQ=
X-Gm-Gg: AeBDievbK+uv9pN9/zatIaKlqdiT25f9QiXnBtYrMXYnPQWwGkRKS1bQCR/wK1wzb6T
	ad0QR3RLGyzH2Nu8vK3BHidzJi6BQ8Z7LylZ1aQ08JnZVQHHmASrPExmTk0FNL2bPvwoM1+c97A
	p85fSmGPHgcnvaEi0lFhoqw8hBlrNacK/sP+R1yhjyctwl0QOuOBLL9Sc7q80v8gN6C3GoFIwwP
	bxtH+qjTNpLiWmyoxZ6+4UJdUApR3pF1JZMVF8HkXSGlWgiecvMuFo9D06Tb/zv5JD/COtSNNBy
	oaez/l/Uf6kQ1+o/9ho+NECHb5sii8qZeTo2TKbwFufKvjffVF8HllEJ7PuZ9V/K44jKQCj7JXB
	kXAGC/pDLxUOd0h+6FDyo7JcrccBXnVu7tfUZ
X-Received: by 2002:a05:6000:2c0c:b0:43e:b0f7:9ce9 with SMTP id
 ffacd0b85a97d-43fe3dc49c6mr1888774f8f.14.1776404272723; Thu, 16 Apr 2026
 22:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz> <aZAWGwZP_Z75YHKt@casper.infradead.org>
 <ad_cqe51pvr1WaDg@hyeyoo> <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
 <DHUNDMZS4YQ0.24SZXD72JIMCE@gmail.com> <aeDzovGHlFmPFpNt@hyeyoo>
 <CAADnVQLc_6SfF0h+-W+-sa-Qfvn8a02b6sbELJwpQcG7CFNqAA@mail.gmail.com>
 <aeGcHXmbCuZ8cNis@hyeyoo> <CAADnVQKLNDitD+WfNCr-nB955GVO7YZeHMjkuOs-=sqnvYyTxw@mail.gmail.com>
 <aeGwM6FPL-yJEs1q@hyeyoo>
In-Reply-To: <aeGwM6FPL-yJEs1q@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 16 Apr 2026 22:37:41 -0700
X-Gm-Features: AQROBzAQvF39hzojzzSuwgce4QBcnRomSH3-3FqEI6I-uBX2RL-EggL7IeUZt2E
Message-ID: <CAADnVQLtZTExAbYFh5GXjvgJoDt+D7_pq_rRVdAQ4anUdhkOZA@mail.gmail.com>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Will Deacon <will@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Waiman Long <longman@redhat.com>, 
	Mel Gorman <mgorman@techsingularity.net>, Steven Rostedt <rostedt@goodmis.org>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: phk77cmdhynr5zu35b1gtzb38qtbd37e
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B82781A0004
X-Rspam-User: 
X-HE-Tag: 1776404274-547825
X-HE-Meta: U2FsdGVkX1+y52CyLoIdFh7xeKS6ApJkZ/yDWDlIh0mEJBgvMiuwiG6CyFaElZ17Zdf+pxUefDv/XcH6AlVWMe5hU/qj5hXYbp9bKn6dg2qSy860iQAhX8yWRPRQXnNV0iRA+lKjRCkjConvyjhMaMhhSnHZLIEltVcd+KbPOdqqiun4IbcOQQ8QQIbtvjkgj3dRbuXruFkRkg1Tq1gmQ7/HdSWaVmW+TXchoW2GAPjQ7K3WBwuHpYtbU1EPi/s1QMIhjqwIZj0Knon5CZz+1gZqhxOi5xgUd/KCJ7ikwtuMWlprDiKXBpJBoIP/JGhcTwO4D8XSJRlgz1IVjB5en8VrWi6wKj1Z/uD1tziI4BobLqsIkPzfHKse7jYJ17x+9/JFwEEo31f1lh2tE6ApJOR96QrIj/LMW3b5D0L98MBpq//4WW/LPj3NAj6ADFS5gnLh6SGP6TFWnN83AsZBOJJZXrT0PiAX5VmkLgoYCTb+SZOaUPSuBt3vlmDxrjNDEc1IDNLLHn72us82GW5jHYmjRf4Y70yFR9zb/hiF+2uSNGIaeGJb2ElodvsmidWDW0cuZOJ++QqbhtjmtuVNWxWXy1ZncMwWYRJ3rPrSvqOetvO57/xi3TisnrChCi8csMfIKjXlg7mPLEHON79zI90jSztTh1N94oIpXo8P2h0KteTYzPUJHdxxilxcLIC4TiNNNbqZ2skc+AcWexvu93luPJrx+05CjQpnRwGPpo3tPNnHHyfFQsexffVAQGFtyr99DHImvYCJ2Zfy1mCutLEs5px0cDnH6966K5fhfkJXe4OupT7ckYg8o19KNNgOshdy9inKiDf5IwiHR7M/3DpOnGAK8jSCs2uZ3ACMr/5Tl+8bSJ2RUbjwqVNor8adcLo9buuM1ElBvyFDgLKhTu7HmKaINy9ya/0LLFIxyMkDXWiRfbgpTcxwgT8qw2UCpX9UpgTVrM7ki5lZW3O
 mH9daqCC
 akXu7TdJihfhO8M2klrhkD4C1ALcVJ+c3YdCm4+rBNBlXmSwGRSdU41hzzXCGrOfjX1AMPazkCUYUNpfgo74YnuIBJGx78LMcQUAAAV5WwmRKRZeaXtpw7A1l07ZvFLyhgN6UMMHB6FH/Ofez5rc3o3M4Qn/nFmLBh2fRy5D47JqD0F7dlQMyHvrHiyRfY4YLNBl3xecP+AOF9vGQmdYMlsm/grMa5PUcLNeR1zqsgvCgviRaQlNiykH+TlVe1VYseGW8IRqpJmoXCR5uCVsBJi1lvFZeV4UeKT4AxlIw8uiW38+H3q+vu8H2czjle7II4fes5hcSPUBBen6IUATN1alGQBVkt49jnqvJH4bkmvuHr2GG2qXMgyX11iAARXuQPwS9C4lJrlm4IT2836IvMS7df7YNUjdKy3jfuoowPqe97w0vEpJrm91YF+2R0vO45KOYw7fKCOWk28Iab8su9J7quyBO0WF9N/G7mVHnIyP6TN1VC3Vl5wjroC7PcJ3MdEfIlw36iezglNp4K6fUMUhBLnpT7yfeoOZ69arHFTABB5Jbj+X3ZYHKpK7aExQt1DDzpXNi1jwt2LY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 8:59=E2=80=AFPM Harry Yoo (Oracle) <harry@kernel.or=
g> wrote:
>
> On Thu, Apr 16, 2026 at 07:41:02PM -0700, Alexei Starovoitov wrote:
> > On Thu, Apr 16, 2026 at 7:34=E2=80=AFPM Harry Yoo (Oracle) <harry@kerne=
l.org> wrote:
> > >
> > > On Thu, Apr 16, 2026 at 07:37:49AM -0700, Alexei Starovoitov wrote:
> > > > On Thu, Apr 16, 2026 at 7:35=E2=80=AFAM Harry Yoo (Oracle) <harry@k=
ernel.org> wrote:
> > > > >
> > > > > On Thu, Apr 16, 2026 at 07:26:36AM -0700, Alexei Starovoitov wrot=
e:
> > > > > > On Thu Apr 16, 2026 at 3:05 AM PDT, Vlastimil Babka (SUSE) wrot=
e:
> > > > > > >> I think we need a special spinlock type that wraps something=
 like this
> > > > > > >> and use them when spinlocks can be trylock'd in an unknown c=
ontext:
> > > > > > >> pcp lock, zone lock, per-node partial slab list lock,
> > > > > > >> per-node barn lock, etc.
> > > > > > >
> > > > > > > Soudns like a lot of hassle for a niche config (SMP=3Dn) wher=
e nobody would
> > > > > > > use e.g. bpf tracing anyway. We already have this in kmalloc_=
nolock():
> > > > > > >
> > > > > > >         /*
> > > > > > >          * See the comment for the same check in
> > > > > > >          * alloc_frozen_pages_nolock_noprof()
> > > > > > >          */
> > > > > > >         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_=
hardirq()))
> > > > > > >                 return NULL;
> > > > > > >
> > > > > > > It would be trivial to extend this to !SMP. However it wouldn=
't cover the
> > > > > > > kprobe context. Any idea Alexei?
> > > > >
> > > > > I think Vlastimil meant it'd be trivial to do:
> > > > >
> > > > > if ((IS_ENABLED(CONFIG_PREEMPT_RT) || !IS_ENABLED(CONFIG_SMP))
> > > > >                 && (in_nmi() || in_hardirq()))
> > > > >         return NULL;
>
> Just realized that it's unnecessarily restrictive to disallow
> hardirq context on UP.
>
> Tried below and it resolves the issue.

Ack. Even better :)

