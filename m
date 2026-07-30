Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 400E2C55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 21:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0CB6B007B; Thu, 30 Jul 2026 17:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A88E6B008C; Thu, 30 Jul 2026 17:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BE296B0092; Thu, 30 Jul 2026 17:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 049D56B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:10:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93FC412010D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:10:28 +0000 (UTC)
X-FDA: 85046686536.18.D34BEA8
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CF36A0016
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:10:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iUiuQ0ab;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785445826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z69Xl4pEtj0devMUFJ7RV47hUtoqsW/xx+DStiLJvDI=;
	b=FoEKSKwjxD94aEt/5MN2GJ2cgu3RHXqzVULsIcCyM2AF4vTksGIjHGu4c0MOGgIQxhcvvS
	uYmuwSsi1+a6aZE6Tbi3nGoMjR+6lAwoO9P6PZoFUvZjfwq+kyok8gi0PuznXSKZgzWLCi
	Vtfo856qLq3jtKEJ5UH/+jj8rJapjFY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785445826;
	b=G8mEig6mHbX5tWMMPx+rVhDe2K978yPtcTOfVMkeq7+F5Ar01ucDr2m4MQwU2qpBVyUHbs
	bMCHQuiFOfYnYgnLIC4y0nFloB4PHam4rsECz2j42i7WK//DE4LGBqruifOSV187+/UTke
	ly3U22I2jFyRaB1hFDgTUTcenWolUy0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iUiuQ0ab;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c10ed63c0so32661cf.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:10:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785445826; cv=none;
        d=google.com; s=arc-20260327;
        b=ULCr60S6QaVE9SEZerQVJ6rJ7HiFEifSlua9ndGBfE3Ooqcvj76haMH1p9qVc9ofRf
         excv8nLbvw1/py3XJdre7smoOVB52yeu48grUQwVlNJKbWdetsFgRKqi+5o/8K4LBKV7
         OB0nra6CwR3isObBMEsJDh8xN5Gxt39c35SDtigeE8ijowi85vwQT1TGKrzErHdU07ES
         b0i3w4OgGeOykH52lfTCn7UNEL5X5DitLmtuqXt5NE9yfyw+IZvDmpU+xJCTYt/ro8Y/
         WqrUeRmu/vqAwb5Gs076IpRPn4aozID2TBQ84ZuuqiIJUXA1aVQbUZeIuhq749/gbbg9
         ygyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z69Xl4pEtj0devMUFJ7RV47hUtoqsW/xx+DStiLJvDI=;
        fh=JywUHTo3ox4glYmI6QAhiZ++4OK+ZXM7O0s8jswTj9s=;
        b=Dnfl3UFGv80//LlDzc/bLVZBykDvb8VV9NZGJZbdfghl0zalsJ+9dySH3zvg5BK1Ya
         zSm+vkLSXO12x54y9rE11ofUtq7Nqdjv+KhXz3yZaikZ9l7atmZlJk97Uj0SkHU9Ok2l
         2oZ5+Vl1SWc9XIxjxyrWlRMyowml5lwQ6ojPcDYLOxYR00LJtJRE6Le+uUIRPb67OtER
         Q01hQwWT3wkmM0925iqOko/7jxzE00kMYTNUeXWbM66st7VGKxithpiWTZXjOqUjbpPz
         UB0dnMQJ7vgHynnWl3PIWdoDPCmafXvww7kRdtmAR1Vo9/SocOnyO3D7E/czyTpAWLR8
         QojQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785445826; x=1786050626; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z69Xl4pEtj0devMUFJ7RV47hUtoqsW/xx+DStiLJvDI=;
        b=iUiuQ0abnHHsQ5EY0ZG1xtQNzpoAAYxL5+TPGSo2bBvdrs/y++dRDTJtdYBxuGT41D
         rk4HVCN1FtxUJiE+n07OCYHfiQt4Fun7B2BuzYgotUee4XkX90EDBcvrU4+UpDIJPjV2
         /19NyHfs9Sci2ujOVI5ywm6PxwH+HnzJOzzN0zlmxOhzRl9dci/AKdGJk/w+ug94MOVB
         gDMufr1YieC1sUQEQC6hOkgoMXv+VQeVigY66yypuNVkRZ80FbevIpINVPbyAn5V6Bdr
         kPWK9ZeHlFNvkRxSw3yxoX70K/fjmTVXwXEpq0rx/2Sjj2eo+RXl75VPKTwcQj1Get2M
         cDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785445826; x=1786050626;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z69Xl4pEtj0devMUFJ7RV47hUtoqsW/xx+DStiLJvDI=;
        b=nZHMAc5jOGz+yI1PTPQeiQ4MKa9lccUVSzG385gzvbDkXfcizl0H0ocrvyt5feelfj
         i7ZCA/rmBWp53j7FpSP1gsqSp/rlHyYt7nNQZukQNlUSwnaC0+Rv3oqxisxXIqabO00S
         qnj626DrDpeVnpPKy+WyW3J60TA21IZnJ8lZb79MIbcfY4IHgKy+dTUorFzDkAQeDs1l
         HizMFSpjEDBIP3reybICaEP/F64E1/Ak0XKFw4gcFEMvoWGbxPaDQAN1xyHqt0esm4Ms
         n92kX07fVtdKBxJyxIgpXh8Ta713yx15cWRHrtjao2VLbproSBqBh8htloM42kBXLD6z
         ejYw==
X-Forwarded-Encrypted: i=1; AHgh+RpeXvnYpraN5OCpRRUTGW2PqLGpXDKy4cbOu15soALY5t1raYLginCZHVCAQXHXVDNB9zJ2c7ePTQ==@kvack.org
X-Gm-Message-State: AOJu0Yylip9Fs/RJIeZine+x4AdjP/MNWwRQxDdpHnr1GEJ2b4QJwu/3
	K6qu3vnjh84UfgOTrY+FYaE0KQAGPXaU2ZZlW6udyj/McvdReRsf5GYyeYyCgv1BC2F3ZD/f5tv
	mv5CWyk6Z4+lcwtNt6jGk8vPFKHg+/obLs4a1kqKw
X-Gm-Gg: AR+sD13XDcB47RytuGVonIQg9waVjvltNwKgseQKVO1MwcO6PRz+LG8AjzAoyrFGZlB
	zKRitWRUglWtSVIAuXwYyLtTo3BGF9vOHv0VmyqvEuN1tqSlTOxADTeC+RrMTRaQek7Jh+H3Myx
	ks8Zxy2t2nX4eOcr17l9TYos80Q8RhMDXl0LYwwXsCKXWmFpZiyjvFbZR/VDz+tY8yWE5rNVNxO
	U6y26THfTNV2pvBx4vh4OtzT8o/kVnGK1I2Po4RZkCOyo5AzidJWcQDZEyDXAozq7Tr+HlrAPcJ
	22Rl5/BnZsTEwZDqwWWwxuNd2XZuXfiMhjeN058F/gK6CxAsx3wBrs292LMQsnynE3Us7wGJKw=
	=
X-Received: by 2002:ac8:7f44:0:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-52b4557bd6fmr4996381cf.12.1785445824974; Thu, 30 Jul 2026
 14:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <2614a3a2f5cb11b63e3cacdcc8ab20a0fe7ae972.1785365110.git.abhishekbapat@google.com>
 <729c578c-e5a3-4351-b07b-469f79c26b0d@linux.dev> <CAL41Mv7_CjWTahWO9sfDZkVKZKEU56j9Sk+xMWN7zbJfRH5MSA@mail.gmail.com>
 <CAJuCfpH3W-gOa6r=2jyw6Ckh_HjAAtdF+0LA2Hu8FkwNe1TM+Q@mail.gmail.com> <CAL41Mv5iYn1Y7X+yb7dcUVTgMac044Ym-RHv93eun-9WXhye5A@mail.gmail.com>
In-Reply-To: <CAL41Mv5iYn1Y7X+yb7dcUVTgMac044Ym-RHv93eun-9WXhye5A@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 30 Jul 2026 14:10:14 -0700
X-Gm-Features: AUfX_mw2w5BpLR6QQXibElofcKzhG_6xqgBytCJlBkb4fLkGavYaLCkPsjS4hyo
Message-ID: <CAJuCfpFzcas7jtOH13Y+qfjbeBbr+J0P2SwBWs_HY72orWfoLA@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9CF36A0016
X-Stat-Signature: fmracniksrg68kozodesnu1hpdyqe8w6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785445826-534812
X-HE-Meta: U2FsdGVkX1+WqoYQNyMYmWidULHJ7JSislp5n6BAKmlStFJdmDECC1PGawx9NgsTBcCYaNYE5ufpdgTQ6SSebR9OEdayOfoqHlKJvHQ7WPWKUGbo7DoCcxumT7cTQDNINuQdySPq5W0kcdyV71HfSQKrueaqTL9nEPIlQXOaklGAjM/YnfwojDg+AgIVzKaf7yLODAEEpADkD8Xvl3zTJ0n2+a6S3ykizZvBnYv2XLc8VTcxV3BUpsYtEqkxFuF10nJJMdoDX0phbhVC7vu/O0RLVUbJzGK1pcjE6q+cp50riHTBwA70GS1NRZIatXP69EWJv2ODbw/nrEqUk8xvxnDHZHk9udkQpl0YKSSrOmAmsRcp98FtZcAeIwCRDdJoeHlh55CxT07O2kPrxwxo8bIQlU229ipBHeNOaZuTBiciARc4tS1rcbo/aHEOUPME3VBAZLRTuJBZ/xmCCDf8PtREMmrwn/sGy1Xm2H1zzLntFlckfGrPmJWQ4uQFgQ/P3jJl6fvjQVJB7bN8EkwmKmU+8WuLXYpwyWO6cfNznseJdtZ6rhFVMSf18xjg+h6wsChnV+rL55GISmZeXlLM8mau3uDOH/wEV4IO5SQcr4cN0/C5E/7t5imUVX3w3zuApoJ6a1S8Qq7Z+yGpCFe5yfmvLgXIkuQdvqschJNefK5WJ1KKkTgeaiqT/lM9UbvpqcguG7yR4Troa1HjkCl+jWRByWXn0TzdorZjjEcU10Hq8UlR9Zc/DrorhccKZqe7IL6yZlmrrOW2xvzgeIkPGWLO34ap1jLJzLlBhESgk5ed3cPe+fhyDdSGI1gdKyCWC+K3vQ/5TzXjHxluD0NYdpmhC0Y7ZqvaB0Rq6pm6uEaz9eDxIPhe5/sCyw3SsLV7e9slKTK8EZOpJARPmzaBTs3Pq57JOrmw2t0W1FrPWQLmGl2Kliv4FIUy6x//Hl5QBVYCRXorereq6YyBbU2
 +3YivYXB
 /qZyQd1rq7czCMphKhoq3C4QONMs2ioptmQT+tVqmTqj9fE/DU6c8ZbPIqYGjD9BNlhDyo8XhTPY3otEeo6HfRiu+P+2jrpQjp1yrp6rvAtxpivm1j034QWY0TsTgLr4cs3T5rwQ7bmT5yWjFc8TvssWPdZb4j4VGXwBMwen+BW5BUKPOjA5br6OocgPcO7S7+MBaaWApoe4bx5I7EQ9tvMo/Oq7RiO55nI7+iRM3FwQeNpvZ+5ffe1CMSKloEPEVKu1szqfsTVOUkRfymRTEJwNfZlOm2D3/IhsvU90OOuZ/Lb/QCg6Zr5ZdLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 2:04=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Thu, Jul 30, 2026 at 12:49=E2=80=AFPM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> >
> > On Thu, Jul 30, 2026 at 10:57=E2=80=AFAM Abhishek Bapat
> > <abhishekbapat@google.com> wrote:
> > >
> > > Hi Hao,
> > >
> > > Thanks for your review, however, I'd like to disagree with your
> > > points. Replies in line:
> > >
> > > On Wed, Jul 29, 2026 at 7:23=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wro=
te:
> > > >
> > > > Hi Abhishek
> > > >
> > > >
> > > > Thanks for your patch.
> > > >
> > > >
> > > > On 2026/7/30 06:49, Abhishek Bapat wrote:
> > > > > Currently, userspace has limited visibility into the exact active
> > > > > runtime state of memory allocation profiling and its page extensi=
on
> > > > > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]'=
).
> > > > >
> > > > > While reading the sysctl provides basic on/off status, it is curr=
ently
> > > > > impossible for userspace to natively determine whether page-tag
> > > > > compression was successfully enabled without scraping dmesg boot =
logs.
> > > > > Furthermore, since /proc/allocinfo remains in the procfs filesyst=
em even
> > > > > after profiling is dynamically disabled at runtime, simply checki=
ng for
> > > > > the file's presence does not reliably indicate if the allocation
> > > > > tracking hooks are actively running.
> > > > >
> > > > > Resolve this ambiguity by appending the active state directly int=
o the
> > > > > header of /proc/allocinfo.
> > > >
> > > >
> > > > It's not obvious to me why userspace would need this state.
> > > >
> > > >
> > > > Suppose userspace reads mem_alloc_profiling_enabled as disabled, th=
en
> > > > the profiling
> > > >
> > > > gets enabled later. All allocations generated during that intermedi=
ate
> > > > window are lost.
> > > >
> > > > When users later cat /proc/allocinfo and see the enabled state, wil=
l
> > > > they mistakenly take
> > > >
> > > > the output as a complete, accurate record?
> > > >
> > >
> > > Currently, userspace has no mechanism to determine the actual interna=
l
> > > state of mem_alloc_profiling, meaning users are forced to make
> > > assumptions regardless.
> > >
> > > By exposing the explicit state, this patch allows userspace to query
> > > and validate the state concretely rather than guessing. If the state
> > > changes, userspace can immediately detect this and react accordingly
> > > (for instance by invalidating and / or refreshing its view). Rather
> > > than introducing unsafe assumptions, this brings a clear, testable an=
d
> > > net-positive improvement over the current opaque behaviour.
> > >
> > > >
> > > > I'm also unclear what userspace would do with the compression state=
;
> > > >
> > > > this is just an internal implementation detail of memory profiling.
> > > >
> > > > Put another way, personally I'd prefer /proc/allocinfo to stay lean=
 and
> > > >
> > > > avoid exposing too many internal implementation details to userspac=
e.
> > > >
> > > > Unless users intend to dig deep into how memory profiling works, th=
ese
> > > > extra details
> > > >
> > > > will likely only confuse them =E2=80=94 most don't care about inter=
nals at all.
> > > >
> > > > It's similar to how we use APIs: we only care about what an API ach=
ieves,
> > > >
> > > > not its underlying implementation.
> > > >
> > > >
> > > > Could you share the concrete use cases for exposing these states to
> > > > userspace?
> > > >
> > > In large scale production environments (such as our deployments at
> > > Google), we can only afford to run memory allocation profiling when
> > > compression is enabled, as the overhead of running with compression
> > > disabled is too high for production workloads.
> > >
> > > Currently, there is no way to write an automated regression test to
> > > validate that compression is active. Exposing this configuration stat=
e
> > > in /proc/allocinfo provides a clean, concrete interface to write
> > > regression tests that verify and enforce this constraint in
> > > production.
> > >
> > > Hope this helps clarify the intent behind these changes.
> >
> > Hi Folks,
> > Thinking about these states, I tend to agree with Hao that compression
> > state is somewhat internal information that most users should not care
> > about. So, adding that state into /proc/allocinfo, which contains the
> > data user cares about does not seem ideal. Maybe we can expose that
> > via some other interface, like /proc/sys/vm/ or debugfs?
> > I also just realized that profiling enabled state can be read from
> > /proc/sys/vm/mem_profiling, so we don't really need anything extra for
> > it. Would you agree?
> > Thanks,
> > Suren.
> >
> >
> Hi Suren,
>
> Sure, if there's consensus that /proc/allocinfo is not the right
> place, I could share a v2 patch that instead exposes a read-only file
> called something like /proc/sys/vm/mem_profiling_compressed to expose
> the value of the compressed boolean. Does that work?

I think so. Unless someone can think of a better UAPI for it.


>
> Thanks,
> Abhishek.
>
> >
> >
> > >
> > > Thanks,
> > > Abhishek.
> > >
> > > >
> > > > Thanks
> > > >
> > > > Best Regards
> > > >
> > > > Hao
> > > >
> > > >
> > > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > > ---
> > > > >   mm/alloc_tag.c | 6 +++++-
> > > > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > > > index 52aece27b00e..89ec2c6ce57a 100644
> > > > > --- a/mm/alloc_tag.c
> > > > > +++ b/mm/alloc_tag.c
> > > > > @@ -108,7 +108,11 @@ static void allocinfo_stop(struct seq_file *=
m, void *arg)
> > > > >   static void print_allocinfo_header(struct seq_buf *buf)
> > > > >   {
> > > > >       /* Output format version, so we can change it. */
> > > > > -     seq_buf_printf(buf, "allocinfo - version: 2.0\n");
> > > > > +     seq_buf_printf(buf, "allocinfo - version: 2.1\n");
> > > > > +     seq_buf_printf(buf, "# Profiling: %s\n",
> > > > > +                    mem_alloc_profiling_enabled() ? "Enabled" : =
"Disabled");
> > > > > +     seq_buf_printf(buf, "# Compression: %s\n",
> > > > > +                    static_key_enabled(&mem_profiling_compressed=
) ? "Enabled" : "Disabled");
> > > > >       seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
> > > > >   }
> > > > >
> > > > >
> > > > > base-commit: c73b725a57f276a3702ca213bde78fca029bc619

