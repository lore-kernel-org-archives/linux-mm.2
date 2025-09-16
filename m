Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C3E8CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 20:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33CF8E0003; Tue, 16 Sep 2025 16:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B098E0001; Tue, 16 Sep 2025 16:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20E28E0003; Tue, 16 Sep 2025 16:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E5B38E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:27:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66328B79D4
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:27:10 +0000 (UTC)
X-FDA: 83896247820.23.98A6398
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9DE6FC000C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:27:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KrNuGrb1;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758054428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ix97aob12h2GgYL8EbRr5XWxpV8URBbytsJHtryCfw=;
	b=nC/yuZAO0Pg4tA9d6N180eB88QB/CYZnWzwNkNqbFfzmYtev1DJWN5o1mOflYLBlU6AsVo
	ORQOfyWyh3+Gxi5U+3MdOGYncmOEBRKgBHp7EdzUcnQHM6B9PK/Pgv7SaPWblcORezZ671
	eBxVLzF1Lou2iBeWwV1QgHMg2Ki3tas=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KrNuGrb1;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758054428; a=rsa-sha256;
	cv=none;
	b=FTHcMIKFCCUFvyB6DrzHlw7ZjpiF/6TVGlfEUrmE1d+PGD2Aayd947auOH1ZHhWeoT94Iu
	Q+uAIjODdpYrh7j/XMPR9rqaqB+sRN5SqX1N+97gwcd0fz4HpdjWnMYdfjdKAVPcooLR3J
	dQS0XtGSKNSuzHzzqFhQTDIqw/gyutw=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ea7af25f42so1986479f8f.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758054427; x=1758659227; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ix97aob12h2GgYL8EbRr5XWxpV8URBbytsJHtryCfw=;
        b=KrNuGrb1uRnJWOtm5eeZkVXGZHy1aeskhLNHa7b5SW68KEhOSJZ8B6xAkK7rurFdGj
         bMoTt8vBoH5ygCTkYVkmGyW5PVx0KlX2nqpky9clDSyF/jCiVis04hrV6kn0gjL6QcLC
         RX1gYwUwz8goxlEg6fYv4CBU3IuUdlYGIpE0wHg7b6MB7L8CitFBgXwVwQ5D9MTD2w+E
         mIZbpJYOIhG9JywufelDGZYniI6xnNtTtW2rXB2Ww185LA8gONxWhDzJZwUn60Tx3vYP
         GTIfYPm5EIZhzaKR3vBwe26FzcacuEdim3+ibR0s7Uhtcl3lsuEnLiBbbrSBQprAy9Gx
         wfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758054427; x=1758659227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Ix97aob12h2GgYL8EbRr5XWxpV8URBbytsJHtryCfw=;
        b=tsPWpRZ/5lgmwU63khpIzPrVNOYJjekRlKqxQO5k0xDDLjIdVJdG5ejpdc1wnL+8nN
         L89MgP3Ih9No5YRhTgJzqu/wvjh0LEVHCVdmvf6jMJ2H10HBdX34wlZZltbsc2cZsQkc
         z4EAcOcGonWzJ40eVWrZUr57pK83GDxioN/DgUeo2jSX4H79cANaDyrJV+BZrX/weBTk
         jLNUiF8t11l2Y8sJvRrgImrJSAUNboqZhXV+/qpE5RnzSser9wFh4VhuJ8hEE0JGvqOr
         mB2jypFWgHJU94oLqidTySeI+4mZKr2hU5cAaQ61MPqgQUhU8c33IJRvzDTABBUujulZ
         It0w==
X-Forwarded-Encrypted: i=1; AJvYcCXthWXOVha1KRkqaPFGofw+2VHTliO0ZjeWybWV3KlM33KuvjLtmeu9ZtqkIk/wRZI2QIiWDIVY7g==@kvack.org
X-Gm-Message-State: AOJu0YxDit56+jsCL3l6wVv00+5TMSyUbOd2VpsEF/p3yma9THCjLkQo
	3G0DFuOnxjW60hJlEtO1o1UkdhG2UOHaSE9yP+PdhpTq+8gQ7GNzXbSZnHRRdVaCdfOFTsTYcyQ
	AT0LPmm/qDqAZJ0KXLZQDYP6oRIkmvtE=
X-Gm-Gg: ASbGncu4CyC/rKalinMhMdEYpChgzkhwsJ1IrB5ucYzCeQaCJ30TAZbHa8oanic0w+g
	EIRPIXZ3IZiJaDUeUF/jMPtyUtaPAuHYhrxHRN3gWIYd3O28X3BHDLeimB/tTrTi5pL5Cdi6BYC
	60DEnbYpyub3Stxcd6GopqxFIHeiTCJI1LTn0g9UfORMiMQqkwLXumRc/NSNb41ajz46C5Sh+jp
	EJv5c1tfYUIJX+teSweTQ==
X-Google-Smtp-Source: AGHT+IGCFRax43r4+6U0AJyqG0me1YwkPNuoWeIBuUHrDGoeTl10iCWD7/ZxIHdhBvkM8deem3EiJqgW173CYYc3/jE=
X-Received: by 2002:a05:6000:26c5:b0:3e7:6197:9947 with SMTP id
 ffacd0b85a97d-3e765a2675fmr15823778f8f.53.1758054426758; Tue, 16 Sep 2025
 13:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250916022140.60269-1-alexei.starovoitov@gmail.com>
 <47aca3ca-a65b-4c0b-aaff-3a7bb6e484fe@suse.cz> <aMlZ8Au2MBikJgta@hyeyoo>
 <e7d1c20c-7164-4319-ac7e-9df0072a12ad@suse.cz> <CAADnVQLNm+0ZwX2MN_JK3ookGxpOGxEdwaaroQk+rGB401E8Jg@mail.gmail.com>
 <0beac436-1905-4542-aebe-92074aaea54f@suse.cz> <CAADnVQJbj3OqS9x6MOmnmHa=69ACVEKa=QX-KVAncyocjCn1AQ@mail.gmail.com>
 <c370486e-cb8f-4201-b70e-2bdddab9e642@suse.cz>
In-Reply-To: <c370486e-cb8f-4201-b70e-2bdddab9e642@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 16 Sep 2025 13:26:53 -0700
X-Gm-Features: AS18NWB_6pHA1ySVG2GJLMXhfR1N9Z5Ppefr9YB0skR0SQES1Z1apMlYGB5i-gA
Message-ID: <CAADnVQL6xGz8=NTDs=3wPfaEqxUjfQE98h5Q2ex-iyRs4yemiw@mail.gmail.com>
Subject: Re: [PATCH slab] slab: Disallow kprobes in ___slab_alloc()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@suse.com>, Sebastian Sewior <bigeasy@linutronix.de>, 
	Andrii Nakryiko <andrii@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9DE6FC000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: muts8uzwypeygshkwd1ysuy8m4skpb3o
X-HE-Tag: 1758054428-399327
X-HE-Meta: U2FsdGVkX1+bIZw06Mh5MQ+MaXV7fEO1jK1o4N/+XvP3Ey0Jd+dDyCZxDf/Cq/OU8V1CXuVmuaS759WBA/pdPtTh8fc/LVzEIKME4GQ5yr3hHddxNwi8PNtV3hrHM2HVINi/X9mWmOUdjDM7FtKpyZqPMuF7tEwOaPhGHTMD9bS/iwfNjmvTMjrvMxTEiFanHWlWweMptNSCUJi15cSudT/+0n9ZXLfrbHiGaUc8HHEcd4GJsrN8v4IcxRQrlTsRSCqP2/A9QVrzbyxTboijpBVjn6Wb0C9lSACWq18W0HCVmtiU9Z+fzyVAprLIwoHTuLXHQ5aQN+etM0GizhYKeS7xAYEdLfZ7YpLBkhrJIVvxq2hnKEEzP2+XjhzSNZmh7A87wPbGSHQ+xtJJVL+YzZ33MyQ1mbKRvP/IQGkcK0iVBg4AaZgHMwCUwHi8DZW/uCjB+y/+9eBH1pEZ+aGtV5r9030LLcDAd3pFeOte5QPq3Ju/7uM2QCmynqauRpSbVo7F9mIOM8VA46QG4XrlQ28JDKgCv39gMcbPp54Fmuqp22U9SUkZ06ncE3gviwVI3hk/1bRd/F6WrMaSBEg/oeXH4i4iqAE/2DoDUlSkHoRb8VEJGS/N1Bk7HKUfqnryNuJP7O89exd4Gyfh1MLAxraut9FMSpEbRM7MSf/VphAvp2v68WXZSm2NHJRs0SFUGCGPrgkRpA74MGuOm0NfcG+frEIUwBQNKB7nMBnCwZMYZY6DKSXYZrh+VHulzb6yiUgfRsT5wwemPk/ran5RYF+cPb7VEg13RjBH1PTayOvtsk9g9q75MuUV7Y8ieq2m2uSwYMEbhjunMLm2bdExrIzQ3K6fIK5TyiLyNd+xc1qHOawb7CxFv96/yAVmXz24rgYuko4/RXODI8dzxiZq4fr1R0OgdB1yKQOaKj0VNMTqjqNo0TkQ1LwOCqjWdck3N2Q/KivvypS7gcbu9gB
 q/kDHCsV
 K0UlAxlfKS7WFUzVOTnCsgeWIL3d3fgAh3F444O4MpbSqTZluOSobT+VUHRA0igiFGUgH7c81wkdHEMB5mqy/euCNrKsb9/23zEl5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 12:06=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> >>
> >> Hm I see. I wrongly reasoned as if NOKPROBE_SYMBOL(___slab_alloc) cove=
rs the
> >> whole scope of ___slab_alloc() but that's not the case. Thanks for cle=
arin
> >> that up.
> >
> > hmm. NOKPROBE_SYMBOL(___slab_alloc) covers the whole function.
> > It disallows kprobes anywhere within the body,
> > but it doesn't make it 'notrace', so tracing the first nop5
> > is still ok.
>
> Yeah by "scope" I meant also whatever that function calls, i.e. the spinl=
ock
> operations you mentioned (local_lock_irqsave()). That's not part of the
> ___slab_alloc() body so you're right we have not eliminated it.

Ahh. Yes. All functions that ___slab_alloc() calls
are not affected and it's ok.
There are no calls in the middle freelist update.

> >>
> >> But with nmi that's variant of #1 of that comment.
> >>
> >> Like for ___slab_alloc() we need to prevent #2 with no nmi?
> >> example on !RT:
> >>
> >> kmalloc() -> ___slab_alloc() -> irqsave -> tracepoint/kprobe -> bpf ->
> >> kfree_nolock() -> do_slab_free()
> >>
> >> in_nmi() || !USE_LOCKLESS_FAST_PATH()
> >> false || false, we proceed, no checking of local_lock_is_locked()
> >>
> >> if (USE_LOCKLESS_FAST_PATH()) { - true (!RT)
> >> -> __update_cpu_freelist_fast()
> >>
> >> Am I missing something?
> >
> > It's ok to call __update_cpu_freelist_fast(). It won't break anything.
> > Because only nmi can make this cpu to be in the middle of freelist upda=
te.
>
> You're right, freeing uses the "slowpath" (local_lock protected instead o=
f
> cmpxchg16b) c->freelist manipulation only on RT. So we can't preempt it w=
ith
> a kprobe on !RT because it doesn't exist there at all. The only one is in
> ___slab_alloc() and that's covered.

yep.

> I do really hope we'll get to the point where sheaves will be able to
> replace the other percpu slab caching completely... it should be much sim=
pler.

+1.
Since we're talking about long term plans...
would be really cool to have per-numa allocators.
Like per-cpu alloc, but per-numa. And corresponding this_numa_add()
that will use atomic_add underneath.
Regular atomic across all nodes are becoming quite slow
in modern cpus, while per-cpu counters are too expensive from memory pov.
per-numa could be such middle ground with fast enough operations
and good memory usage.

