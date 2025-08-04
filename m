Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C738C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0F626B009D; Mon,  4 Aug 2025 08:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0A56B00BB; Mon,  4 Aug 2025 08:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDBB76B009D; Mon,  4 Aug 2025 08:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0F676B009D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:56:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F0BA114878
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:56:15 +0000 (UTC)
X-FDA: 83739073110.15.E523BF9
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id B738B40013
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:56:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XUGM5qyh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754312173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzefFzSR2vp1aHaFbeKCmFtRjiIwPiVdlyeV3EqbOx0=;
	b=OUPnOzMsOE4fi7AX83ZNmzXWtUtdknmbU/kS+RXKvpsGCwn2RMbQOYQ0wAOlGTwqTOG0KF
	I1Rx4dDqhxR/CqqGFK7RTB/cXdbbaj4DSdkZzlArnK0NFvP/MvIlwITKBtiiORiYlfvinF
	J5lToDxkEVCVIoTXWrDhVZgYXmgSRjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754312173; a=rsa-sha256;
	cv=none;
	b=sTVP+K20S26SasY0y3DEaZCo/wWvy1J4oE9L/9Hhfahtwq+TEcSZ+AmownwZwWAmoBr7xn
	ryftFWrWm8taXiBHOaUFAkI+HBn8OARvbJ4UCybJZgfebPYRDU1mkhzu3HwND1qrdGXo96
	ozKN2f+5SNe5k4U1S1s/ih6AsQNbOTQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XUGM5qyh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2ffa8e58654so2835945fac.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754312173; x=1754916973; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzefFzSR2vp1aHaFbeKCmFtRjiIwPiVdlyeV3EqbOx0=;
        b=XUGM5qyh23P7nUl/Bax11EWJmZYIRrJd9UStedl6+1RSkQrqQG794vOugxhVSyMeBq
         LAQiWSoctvwvm6w4TtAbyp5jH5q3hXxAt1uimE8kJbQ+hab4z0fK1iZyYlia6GvYCQR0
         l0ZtB2K0intS8rnAFYHKAY0E9TKNRXodTZ7cdJy7fUFTE/T+aoML//35zquksZyVsJiN
         kiCEeq66m2MKvgHSdF8fMkX2oaH/oF9vlBmKIVDAr1o6p7/U1EL5iejLp953AU0/ULK+
         Z0qbJhgS8gynk2TyZLv0Tuh9UsGW3FSS144i823Yq3W7TNlW7MCo1QU4w1PS4LPOrjMc
         qyrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754312173; x=1754916973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzefFzSR2vp1aHaFbeKCmFtRjiIwPiVdlyeV3EqbOx0=;
        b=ED5yQWr4U/xXWJaucotbGF1VrI5qWkbr8ktUW11nh9vwA/PH/XEiniEftpeltgDjkH
         lAw3SaqbrPMyh2fjzQ9eGn39b1HUzATfXmzOpR1XlxVtAZbjuMIE1xO8WiqINhjvHhiM
         ZG4nqGxVz0Mwz48DkUtQGv86+6Xg06oFTTs0RmkaQmO73jYhOlZXYWUXnn7c1odqyNsi
         JTH67gsR6xbR0gZSBDRxnUUpWQbbCyNkkgD/ICb6R/hbuFxjbSxzmB3Y+ryYNv9XxQNR
         VRU0pMQEWuP1RjmbEt8X5A/fxu7oKoXogSERyiRh2IGxDV9dwGh6+0s1ROVtXt4X+M2K
         qXSg==
X-Forwarded-Encrypted: i=1; AJvYcCXqwRrD4oAAD01GO7iQgmuvu/1LsNkxag6JBgHOXekHfzGEx/bnu9iDC1x6KaJAMq7p8FMbj20LXw==@kvack.org
X-Gm-Message-State: AOJu0YwOKI4/ffYISRzx3hcQynFL60JNtif8phuO1KhL2L+sUB3TgVkJ
	T+LIUc8uzuRQ/QTZxHRfgiom1PhhZpjop3Kc8Lo3SxzbPkUTjsxUbCFtbk8ht1L9etnnFszoZ5P
	Wc0OPL0OS/d8Djjo9ARnXkBaSDHVmhWU=
X-Gm-Gg: ASbGnct7OObnuszWa8LQhPGBNne7oUYhXh0a4oW34FzXR1kZPUyzp3yBnPXZjs9WRtz
	P+PWUx9KEq7PWkH0joEsO9EuSAXUNweROAwon8LN+Yjz3lM7hLsTOHHwhIkovIUO0fAckgL++BY
	GjaTa8J/MsyVVbzpfV4zvxONHwhanfeZ+t1AgWxNqwHZXH+CpgcDpGKJA6Gz/WAhAY2k9RZeFPz
	PAhFrToxaMdxBM=
X-Google-Smtp-Source: AGHT+IE4MAXVRhZWR5/ebeb8eIMaIzWPZ9dWzpVYsFUc7uLvARKpfKCbXZj4DM6hUdPgWY/tqsU0xiN3pfgH3/Y8hqg=
X-Received: by 2002:a05:6871:4b15:b0:29e:559b:d694 with SMTP id
 586e51a60fabf-30b67a24c4amr5580485fac.32.1754312172618; Mon, 04 Aug 2025
 05:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxME81-oWdDzc6EzCEgHnXDTe_fQT0s8c2YuqMA1EDbDZZw@mail.gmail.com>
 <20250803174235.55846-1-sj@kernel.org>
In-Reply-To: <20250803174235.55846-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Mon, 4 Aug 2025 21:56:00 +0900
X-Gm-Features: Ac12FXwJQkFS4AO-uIft_lx2f5NinOqaKDiIHA_oUIm8Ok9S52t7PU5_Hc2A1hw
Message-ID: <CABFDxMH+pM1QD69FG+4873Q0WLN3sJB4_NDa6vqLjnjAu8n6+A@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
To: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>, kernel_team@skhynix.com, damon@lists.linux.dev, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: om7axin3u71znkofe859sbiazndokhx6
X-Rspamd-Queue-Id: B738B40013
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754312173-49195
X-HE-Meta: U2FsdGVkX1+9eQ5Rj86QGHU+E0x10D8nY/rqmygbBjoD95W/UNIfcK2aZ1E9IYPbXzf0b8vN6LPJmvjN6uxzqm8G4yfJFv7j4+zk8T+Q8EL6qKc3wx9jpBWHNkmqg5anhCsua80nlxyGGGEHtOm4HxSZSBP7WkvGpeYluC3JuqT/Q8FCHWLzap4PVUAvaJNoSbU6akVtZnfYmaFroHQQNGb7cQ1F1l0m2r+E1NvekNZMSzdE2pHuCuwsIbazaHUPzAqPVRmT3zZArzljZJnQeAsDegapWzSL8KS0ke0IlcQID3XseBQaCihx8TlOb/WSpvOYGdza57pJ0e81PKdTY9BFUOOtkZDVpMHXwVR9vMmkOSdBC+7IipSFK64Tcy9TN67epq3vadOEDcZBIOiD2iEJ9UJS5LxaSeeOe7c5TNLP4peR/LPc14a9gLvOAwV6qiU9bOhcycfbsvzCZ8l+DZgS5IkfV4G8tscWejy6LAB8egY3fGW53gQhBd2woddFTTGyFHuYo0Vy3dpPWDTaevPxtdk3lwtTcjJHYyCZ5gfRdOHBWIvflqm7updiqHPahTqB5JSH7BatzIHl/UWRp9XULvPSdFKQGJFHfm5wTUTqKKlBbZYjqdVn8ePL4D69FKwpWrxD0JguysVDSpAQXuUP/r5t9Y26CoJRd6a8walPODcR4XNAgrYhfcZ4A4gDgLATI06k1DpFQs/YAhFEbv2MyKKPhutb81G7HIcgfxooG4gTb3Z+ObLBgjsvYinfHTQY/TDb34aQvS3lVMU3L+bKep3qJ/8t3M7EuUaiNoq2CNWAFtLI3KZAgo/y9cZr7HXlF0JDqid+dBDka/PI53GApDXH4jfUETla9VyoQ5DOsMocURb6T1fxmYrmOcJNJycSBJ5i+LfJoQDaxSl4IjKAG2HzZs0CGTDK/GN8KA+GtBBSjNK1K575NWdLYxORvDR8ERWGofwELIoc4am
 9xJAzS2W
 xwSX+Lr435KcF8SCAQN3CrKB6uDVPfnBvukYbOQb8/YUWp1jgVBfysV05Kgu2WYEe+WfkQlaWfDEyP8DKCCkeBrS/5r7mK/OcBcFpULsixH31eJaY3jmJKXE9FnCc6ok0qPZA/5lEtZ3uUEoB4HvmmAyS0+ZSnza6xNHlB+7ucwY/oK+kW2Y2RFVxXNYaSrpP39xGud2mylRCmi3JhdexViF8JMLGLHbp6uPuCYPfGN9ci6fs7LGroPwKxv4Mf2HsCrsLmslhWIOXr+i3D1pP9ICAFe6CrcCW+Vj0KAxRPjISWcaovl9k95qQNTilCm7gYhcEGQXN2cpoVmmpUI7+eVM23mU4pGBSK92VytQR5xpDqd/LViJHUuCimMLRPCHcJ7smEIIacpRsGuHENZ1S6SD5wdh0MbQdKz9IMq6S+Gua15Q5AANPeUSMP2zXvxys0rHoX12ub6GBYF7SWSyQEKqxndcbPmkCRyVv5jqDQIORQjmXbzlitFy2eqXyUT2RuvQj5j3JfYo3JZ6N4vaAGM0OMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 2:42=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:
>
> On Sun, 3 Aug 2025 22:22:05 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> =
wrote:
>
> > Hi, SeongJae and Honggyu,
> >
> > On Sun, Aug 3, 2025 at 2:41=E2=80=AFPM Honggyu Kim <honggyu.kim@sk.com>=
 wrote:
> > >
> > >
> > >
> > > On 8/3/2025 2:30 PM, SeongJae Park wrote:
> > > > On Sun, 3 Aug 2025 13:43:03 +0900 Honggyu Kim <honggyu.kim@sk.com> =
wrote:
> > > >
> > > >> Hi SeongJae,
> > > >>
> > > >> On 8/3/2025 1:22 PM, SeongJae Park wrote:
> > > >>> On Sun, 3 Aug 2025 11:03:12 +0900 Honggyu Kim <honggyu.kim@sk.com=
> wrote:
> > > >>>
> > > >>>> Hi SeongJae and Sang-Heon,
> > > >>>>
> > > >>>> On 8/2/2025 1:50 AM, SeongJae Park wrote:
> > > >>>>> On Sat, 2 Aug 2025 01:11:09 +0900 Sang-Heon Jeon <ekffu200098@g=
mail.com> wrote:
> > > >>>>>
> > > >>>>>> Hi, Honggyu
> > > >>>>>>
> > > >>>>>> On Fri, Aug 1, 2025 at 8:35=E2=80=AFPM Honggyu Kim <honggyu.ki=
m@sk.com> wrote:
> > > >>>>>>>
> > > >>>>>>> Hi Sang-Heon and SeongJae,
> > > >>>>>>>
> > > >>>>>>> On 8/1/2025 2:58 AM, SeongJae Park wrote:
> > > >>>>>>>> Hello Sang-Heon,
> > > >>>>>>>>
> > > >>>>>>>> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu2000=
98@gmail.com> wrote:
> > > >>>>>>>>
> > > >>>>>>>>> Nowadays, damos operation actions support more various oper=
ation set.
> > > >>>>>>>>> But comments(also, generated documentation) doesn't updated=
.
> > > >>>>>>>>> So, fix the comments with current support status.
> > > >>>>> [...]
> > > >>>>>>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
> > > >>>>> [...]
> > > >>>>>>>>>       * @DAMOS_WILLNEED:  Call ``madvise()`` for the region=
 with MADV_WILLNEED.
> > > >>>>>>>>>       * @DAMOS_COLD:              Call ``madvise()`` for th=
e region with MADV_COLD.
> > > >>>>>>>>> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region wit=
h MADV_PAGEOUT.
> > > >>>>>>>>> + * @DAMOS_PAGEOUT:   Reclaim the region.
> > > >>>>>>>>
> > > >>>>>>>> Nice!
> > > >>>>>>>
> > > >>>>>>> But doesn't it make confusion about whether this pages out to=
 disk or does
> > > >>>>>>> demotion to the lower tier memory?  It's because PAGEOUT acti=
on doesn't do
> > > >>>>>>> demotion, but it looks "reclaim" includes pageout and demotio=
n together in my
> > > >>>>>>> understanding since /sys/kernel/mm/numa/demotion_enabled was =
introduced.
> > > >>>>>
> > > >>>>> To my understanding, DAMOS_PAGEOUT can also do demotion when de=
motion_enabled
> > > >>>>> is set.  Am I missing something?
> > > >>>>
> > > >>>> Actually no, please see below.
> > > >>>
> > > >>> I'm unsure to what point you are saying "no".  Are you saying DAM=
OS_PAGEOUT can
> > > >>> also do demotion when demotion_enabled is set?  Or not?  Could yo=
u please
> > > >>> clarify, and add more explanations about why you think so?
> > > >>
> > > >> I checked it again and found I pointed out in the wrong place. Ple=
ase see below.
> > > >>
> > > >>>
> > > >>>>
> > > >>>> do_demote_pass in shrink_folio_list()
> > > >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1122
> > > >>>>
> > > >>>> The do_demote_pass is used here.
> > > >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L1293-L=
1302
> > > >>>>
> > > >>>> can_demote() implementation returns false when demotion_enabled =
is on.
> > > >>>> https://github.com/torvalds/linux/blob/v6.16/mm/vmscan.c#L350-L3=
51
> > > >>>
> > > >>> I'm again get confused.  Isn't it opposite?
> > > >>
> > > >> The thing is that DAMOS_PAGEOUT call sequence is as follows.
> > > >>
> > > >>     DAMOS_PAGEOUT
> > > >>     -> damon_pa_pageout
> > > >>     -> reclaim_pages
> > > >>     -> reclaim_folio_list
> > > >>
> > > >> In reclaim_folio_list(), it sets "no_demotion =3D 1" in scan_contr=
ol, then invokes
> > > >> shrink_folio_list().
> > > >
> > > > Thank you, this clarifies.  DAMOS_PAGEOUT doesn't demote pages even=
 if
> > > > demotion_enabled is set.  Thank you for enlightening me.
> > >
> > > Thank you too. Glad to hear that.
> > >
> > > >
> > > > So, "reclaim" means "reclaim".  shrink_folio_list() can do demotion=
s when
> > > > demotion_enabled is set.  I hence still don't think this patch is s=
aying
> > > > something very wrong, and how it could be improved.  Do you have mo=
re specific
> > > > change suggestions for this patch for an improvment?
> > >
> > > I would just like to make the term "reclaim" clearer and we may be ab=
le to
> > > define what "reclaim" is.  I think we can choose between the followin=
g two
> > > different definitions.
> > >
> > > Definition 1. "reclaim" includes "pageout" and "demotion".
> > > In this case, we better clarify all the other documents that mentions=
 about
> > > those terms.
> > >
> > > Definition 2. "reclaim" only includes "pageout", but "demotion" is ou=
t of scope.
> > > In this case, shrink_folio_list just do pageout, but "demotion" is on=
ly
> > > exceptional case so we can say the "demotion" escapes from "reclaim" =
logic.
>
> I was thinking in the first way, and apparently I was simply wrong.  Now =
I
> think the second one is more correct, at least for {DAMOS,MADV}_PAGEOUT.
>
> Yet another way to do the reclaim would be memory.reclaim cgroup file.  S=
eems
> in the case, demotion can happen since user_proactive_reclaim() doesn't s=
et
> scan_control->no_demotion.
>
> I didn't read the code, but apparently memory pressure-based reactive
> traditional reclaim logic would also do demotion?
>
> So, apparently "reclaim" can mean at least the two definitions.
>
> > >
> > > We might have to clarify the term "reclaim" for those cases whether i=
t includes
> > > "demotion" or not.  We might have to discuss with other mm developers=
 together.
>
> I think that could be a nice discussion.  Looking forward to.  As I previ=
ously
> mentioned, I don't think we need to have only 1:1 mapping terminologies, =
though
> I have no strong opinion here.
>
> Regardless of terms, I agree there are many rooms to improve on our
> documentation.  At least DAMOS_PAGEOUT documentation may better to clarif=
y what
> you pointed out.
>
> > > Thanks,
> > > Honggyu
> >
> > Because of the above thread, I got to know the details more clearly.
> > Thank you guys!
> > When the discussion of "reclaim" finishes, I'll make v2 patch as soon
> > as possible.
>
> I don't think we need to block v2 of this patch for the discussion.  What=
 about
> adding a note about the demotion behavior on the details comment second, =
e.g.,

I see. That sounds reasonable because we can revisit after the
discussion finishes.

> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -150,6 +150,8 @@ struct damon_access_report {
>   * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PAD=
DR
>   * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
>   * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
> + *
> + * Note that DAMOS_PAGEOUT doesn't trigger demotions.
>   */
>  enum damos_action {
>         DAMOS_WILLNEED,
>
> >
> > However, I want to talk about a slightly different topic. How about
> > adding support demotion to DAMOS operation action?
> > Maybe we can add another action type or change implementation of DAMOS_=
PAGEOUT.
>
> We actually tried to implement DAMOS_DEMOTE, but eventually decided[1] to=
 have
> a more general action called DAMOS_MIGRATE_COLD.
>
> Do you think there are use cases where DAMOS_MIGRATE_COLD cannot cover?

Thanks for your comments. Above suggestion was based on my lack of
knowledge of DAMON.
I tracked linked RFC threads; now I understand that DAMOS_MIGRATE_COLD
supports both demotion or lateral migration, depending on the
environment.

Maybe there could be a new use case, but I think now it's not at the moment=
.
It's just my bad :( let's just skip that suggestion.

> >
> > IMHO, I think we should first check whether it's possible to set
> > no_demotion in the `madvise` -> `foilo` flow we're using.
> > Since I'm still quite new to these things, I'd like to check whether
> > my idea and direction are correct.
> >
> > I can't thank you all enough for your kindness :)
>
> The pleasure is mine :)
>
> >
> > Best Regards.
> > Sang-Heon Jeon
> >
>
> [1] https://lore.kernel.org/all/20240614030010.751-1-honggyu.kim@sk.com/
>
>
> Thanks,
> SJ

Best Regards.
Sang-Heon Jeon

