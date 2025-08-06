Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2B0C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 22:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874386B007B; Wed,  6 Aug 2025 18:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BD16B0092; Wed,  6 Aug 2025 18:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788DE6B0093; Wed,  6 Aug 2025 18:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE876B007B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:12:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28EB01DD140
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:12:07 +0000 (UTC)
X-FDA: 83747731494.07.137A95E
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4621E180005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 22:12:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P2MvDmRX;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754518325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FiWvRl7qqXkQNDBUdlT6ON4d+ifpSBHPrNy6qGGUHk=;
	b=KBC/etc7/Tb0oJyRCVORL0k3bc3W/8cdx4qtWpX8SrhJSMoWCd+X8ClvxaVaC8/SD1iPyJ
	fFIwzmgZTmtP5HD2qLdDMFH7VS+Q3jmHQ33iVWBgDPuCW9I+P75+8T4V6Drndji+YSym+o
	r6iT5gugIchmx7TFx6ZBhCQAPvtQKp0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754518325; a=rsa-sha256;
	cv=none;
	b=xhgJbxLssw/uylwbC9lDjHMFhNLPOKKdPj2/MukM9gGLHlsYSvpdX8vJYcYYdEIE9z3Mvd
	Q3UmOi2gLDE3+K7UfWrfKunQ3mDxLALh2FoSnnHuCO5jOIUPY3Vx/8Bs+RRAA/50uV144C
	tf2VC3qQ78JBCXrCtalSJGj1Tdh3KFA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P2MvDmRX;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso45811cf.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 15:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754518324; x=1755123124; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4FiWvRl7qqXkQNDBUdlT6ON4d+ifpSBHPrNy6qGGUHk=;
        b=P2MvDmRXRNDg9A5p0d3J1bWYdvxVQxZ6Na0BtC6Yx3kMsq9DJfeGDUaMkWlq5tY7Iu
         RXsF3gSqvLlfkfxAKJJYeGSYH9wqgsjDwwWMYb8pdxJNGL0p1pSGfGs3Rty3tDzzozGa
         pDOzrIUjK+pUsaK5D++9fCg48uVLg38VLtIAW1yrcPvz+zkR05xrQoDg5yLpQKkzoSb7
         YuK4REBjwRmM13kszoh9sz9rKk/wXk7g7Nejl5rACGT2oVX/dtKwuf68yd94arkW+p/D
         Fe08pOodV8Qcw8mDkVOgqtYkEva3oCTKxUqJ6eyLeiaO441WBQf+6zeH38ELq1nRrPKD
         298A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754518324; x=1755123124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4FiWvRl7qqXkQNDBUdlT6ON4d+ifpSBHPrNy6qGGUHk=;
        b=wclUp7CwDV0kQHzSJCx8FM0n1cfBd1HtTQz25pQBbqin6EEmBRc310/LK84kFAuzQF
         8XHSkcHy0zWJFTzy1QSVu1TxyrEJR0sqYMQZVCZtpYvEiMsnWC9RTJyh8XeyTXcZnh+O
         q8Kp8pDhvuP7NKo2gA71OcUdAbtONcYi+BxfaU1wAc/HzoSsaeFXxaGuZ8BSvE+8vOiq
         7PorqOAmxLPLpIc7KOz0l7aKi1tAn0+aBVGmBWlD/MgMWkkbGOU/W4/NKQEg/RDqmMgj
         s0lx6xF7wa8/POoWtxsB0owks/9FZ8fs6lYZ1zTt4bTrgun+tnRN24fqh22VNEKnuer/
         S7DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWk87cRcvV6ymTXy1VYXjMEdtyBpPx+WOEAAnEqbSqj1py97BxJZ0Eo4TS/mO9KV3FhcQQ0tUHcA==@kvack.org
X-Gm-Message-State: AOJu0YwWNiRDkES/Js3NqUgFw2XEWDalSy47wNruypGj5sSu0dzx4AXU
	0C3npswl2wMmv0JS97tvxl/g08gQd5yBAeRKLJhNa9q907TDEM2Vb0fMZCRkwDSzOsSZnqi+7QC
	5745IhtBj04xjNk83WtUyX5x1FEy0vbPpkYc9W0Di
X-Gm-Gg: ASbGncvvC0KBxOQOmu6WSTlWS69o5VWUD2V+ZvQN2QIBWvwok9QN3Kn/zGM97qizoRC
	b8cw5i729FjuExSYCliJPFCOqiwD+JInYEvZHvB/OAIrs6wjZ0m+IEhLaBXl2GtvGjvA2MQx8yY
	uE3UdSV4PQqdnlxVK76qkgHEc4j0LgQuFGEYJWklK7/HBRbsf/G4c1CJd+w5jZhy8lEK5cGyNRO
	efaRci5azS73DDs
X-Google-Smtp-Source: AGHT+IE58c8RrLqWVAWSA89xnMLA58Wcvs22tjEvVXSzyBbScgVGdTpLFJhTGLaInSIHVWyChoGSfE8AA7WkFHFQ4CE=
X-Received: by 2002:ac8:5a42:0:b0:4a6:f525:e35a with SMTP id
 d75a77b69052e-4b0a372b51dmr520041cf.9.1754518323701; Wed, 06 Aug 2025
 15:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250806154015.769024-1-surenb@google.com> <aJOJI-YZ0TTxEzV9@x1.local>
 <CAJuCfpGGGJfnvzzdhOEwsXRWPm1nJoPcm2FcrYnkcJtc9W96gA@mail.gmail.com>
 <aJOaXPhFry_LTlfI@x1.local> <CAJuCfpF0RJ9w0STKFaFA7vLEA5_kEsebuowYWSVnK-=5J2wsPQ@mail.gmail.com>
In-Reply-To: <CAJuCfpF0RJ9w0STKFaFA7vLEA5_kEsebuowYWSVnK-=5J2wsPQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Aug 2025 15:11:52 -0700
X-Gm-Features: Ac12FXwLQmNTg-sw4wFVsfQATsP_wqhDZus6Cjpz3UpRH3cR-tLTiKJsZP0WDZ0
Message-ID: <CAJuCfpFhcfK4E_Q8QMqG51GOMrJPehddeU4pt3uo1qNfVU5__w@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] userfaultfd: fix a crash in UFFDIO_MOVE with some
 non-present PMDs
To: Peter Xu <peterx@redhat.com>
Cc: akpm@linux-foundation.org, david@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4621E180005
X-Stat-Signature: d4wqf3stpsrhsd4zw9b9bugdy5ek4zin
X-Rspam-User: 
X-HE-Tag: 1754518325-260060
X-HE-Meta: U2FsdGVkX1/SsLcvU388ZY2x5lyD2SAPMC2dIpyNP6N0wNXIz2oY1NokS0jYR7eRhV4+/SV9uk2qVTC+4PEsBqe5NAK6ufaJmy/DpaCT8A5TSH5ZeyAq0H3VjOqE3gXwLCLWudyWz4Vu9dHKzFclecw07iQMk3gucpwA3h6WAU+r9g0lq3qYUbgd1aojRBwXBlvr30kHALzqu3IFR+rfnpdUdP17wDfSeVXzm8N9vNHxRLT50APLwY1InAb5YGDIMSGAPXuK12UfXeTEn5LlhlVIvHebC9hQZCwgFDhhIhumQ+80dIqIHb3BmSxMCU8OhP4XBG9SBQZ12xky/F3zyXb7mTVCtoFUaGSnaPsGQys+1buEhQ9GhL7ASU8iXinU10bUO8sCdYM7c3YHqXDYAjiDZIat/wGT/aA8TRSCb+UeOVjI9fAxb7kG8CQOJYL/sqTjiSrlAKttpvIAZuLU806Q1Zprz+y4aL8cEDV6Hhjwh/DoLD67hFa20xw+Uel8zYSaSvbY5hwo0xFW48Ph9NzXdTg3JGpRCdDLhviej/nDHHLBOSWVfr50+kw/gARcIf9Kya9nHmO0aZFhXVZOHsWsM8gBeBasRaty9s3h1fl8bUWcRFhuVtJB5AUFASCE4w+CGeTUp2gSbTH/Yn44CqUDz+hFgcKp4nkaZnuTXWbtkl2vV0i7BGyJGRS/eKteFwbBGryPPF/JvfSPGw0ibf1Mm5Z0miqTS+oOfGnTek4PiBxifq6TNxObJjZ34kUoVr1L/k0mPeGmNED+DyLZIgPMFI2mKDRRXGOxGBaxyciWV9JwBu7eRkStARzZyMDhSKye2OJGk+gC+In/1k5P7RPdWTgkrOTHw5PYcllPllnDtAp6ztmcigdnorI6ZF0gjnWrsN2yBGF11OpKByoLtiLAbisVMafCYahnXZToWv70QBlOiD0PMG2vYSIrSQxMLRjujPfMtbBWQFq4FMS
 DLGxwsDm
 MS+1gnk+2GMZ5kxAen9iam6ExYh+n3JaMSnVvH/ZpGgvPhRvh11/Ol8SCs/4zDLMITyfgE7AcDhrkbvAV5hQEpIfF6mqMQTthPOqvYCaFw1+SpHZcNtXhuEpylujQvxtjQKzJTYpnHTgGXaV3Ki+oiHVa9iUn0i4joXZ/Gdfoh9J25DHuBBWva7LyJJJksEu7ARnvQ0SsVM9IHa8RT2pz+6p1f9ModCVm6GBZg9D59gUWWkkQ47Yn0qsNMHcQMmxGfXc4YSh0a0iJ4sInG/P0nvxIuPCqzZ7kEOUX5hsMqj7nfHFwTy2EyCZVrqP/Z1whgq84F2+5yU/LYdNEljq5uOjnddOwdM1dWcdR6GXOjsOpig7Mk1U9lGIUFUiIkXIjsKCUmPThP2yPz1OKffTlviZ18EvamQ0OfPg2yzTr2bXL9MAvXw/jGBnygw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 11:21=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Aug 6, 2025 at 11:09=E2=80=AFAM Peter Xu <peterx@redhat.com> wrot=
e:
> >
> > On Wed, Aug 06, 2025 at 10:09:30AM -0700, Suren Baghdasaryan wrote:
> > > On Wed, Aug 6, 2025 at 9:56=E2=80=AFAM Peter Xu <peterx@redhat.com> w=
rote:
> > > >
> > > > On Wed, Aug 06, 2025 at 08:40:15AM -0700, Suren Baghdasaryan wrote:
> > > > > When UFFDIO_MOVE is used with UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES an=
d it
> > > >
> > > > The migration entry can appear with/without ALLOW_SRC_HOLES, right?=
  Maybe
> > > > drop this line?
> > >
> > > Yes, you are right. I'll update.
> > >
> > > >
> > > > If we need another repost, the subject can further be tailored to m=
ention
> > > > migration entry too rather than non-present.  IMHO that's clearer o=
n
> > > > explaining the issue this patch is fixing (e.g. a valid transhuge T=
HP can
> > > > also have present bit cleared).
> > > >
> > > > > encounters a non-present PMD (migration entry), it proceeds with =
folio
> > > > > access even though the folio is not present. Add the missing chec=
k and
> > > >
> > > > IMHO "... even though folio is not present" is pretty vague.  Maybe
> > > > "... even though it's a swap entry"?  Fundamentally it's because of=
 the
> > > > different layouts of normal THP v.s. a swap entry, hence pmd_folio(=
) should
> > > > not be used on top of swap entries.
> > >
> > > Well, technically a migration entry is a non_swap_entry(), so calling
> > > migration entries "swap entries" is confusing to me. Any better
> > > wording we can use or do you think that's ok?
> >
> > The more general definition of "swap entry" should follow what swp_entr=
y_t
> > is defined, where, for example, is_migration_entry() itself takes
> > swp_entry_t as input.  So it should be fine, but I agree it's indeed
> > confusing.
> >
> > If we want to make it clearer, IMHO we could rename non_swap_entry()
> > instead to is_swapfile_entry() / is_real_swap_entry() / ... but that ca=
n be
> > discussed separately.  Here, if we want to make it super accurate, we c=
ould
> > also use "swp_entry_t" instead of "swap entry", that'll be 100% accurat=
e.
>
> Ok, that I think is our best option. I'll post an update shortly.

Posted at https://lore.kernel.org/all/20250806220022.926763-1-surenb@google=
.com/
Thanks!


> Thanks!
>
> >
> > Thanks,
> >
> > --
> > Peter Xu
> >

