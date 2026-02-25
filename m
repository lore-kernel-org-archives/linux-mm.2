Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E18FD377B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9259F6B0088; Wed, 25 Feb 2026 13:23:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3CB6B0089; Wed, 25 Feb 2026 13:23:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4F36B008A; Wed, 25 Feb 2026 13:23:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 631DD6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:23:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0351D1406DD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:23:24 +0000 (UTC)
X-FDA: 84483801570.27.6484E18
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0ECA1160004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:23:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/XktPmH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772043803; a=rsa-sha256;
	cv=pass;
	b=AKt7FVRyt9kCQjDpUE6DEbIfuECZrB+crwvQ1phYq2kkAE4Wfp661hXEKe95qljTW5Ol83
	G7Ht5BtepYNEs9a1bGzzPUlRcnX3xmvjjFZyTkDtaWdun1+HBbQVLvW3Cx0VV2I5daD9TO
	rj5nH6VBuyNwc/7i0unTwmc0zGDd620=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M/XktPmH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772043803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xa2NxgBV56+zcp+pDI4D3jQAyDOvWbrM47gZNUvrNM=;
	b=SLqXlkRnABGgX1WFlbPNugKTG4T23rWsfjzwLbbaiGSpXJ1Aqnck0uFdorStkQUnmWAFkv
	KvwU3VWKj5tiQoIjsKcwJOkpld21k+w445/v4u8UINqnYl9v0qg84fdqxFS+7XMDDwkOiC
	Eq4elosmqdfKTJq/O5qp2HVL34Tl5sQ=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-124afd03fd1so10101146c88.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:23:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772043802; cv=none;
        d=google.com; s=arc-20240605;
        b=dQ7giopx7ZmB6saOgzQrkQI/mkwk06OqW2jqIwNhoXZ3amqV2ufvY9WiuiRxXprJLb
         VXybE0+9rbBhJ56XKInxBvmuDtIZOp7mFtOEHkcEyYl4OcEEL355lPeO1WEqrKngMgKl
         P+0trzBfSQLe3iE/zHegfwuhoB0ZZFvYeD5wPQQTi70OiIJKQHe/pDNp1ECtBk3srtYa
         4IQdXP6XwXYF8lP85MrzOxaoz2Lc5Xnb3h9ZEPtLeOugrzDPNkS5zc0aAgxr/8MC76x9
         ffSBVqe+uUJGNQQS3TjH4FWCYbufYbqhEyBbk57ZOo75SZUewCkhlbV6aE77bNc7WEK/
         tCzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/xa2NxgBV56+zcp+pDI4D3jQAyDOvWbrM47gZNUvrNM=;
        fh=tXauhgmfXNPb34OHJHjI3F5Mal40bIeumTzPdcDM9Jg=;
        b=WjysD9n+buFNdU7KqER7M49YAhuPr3Q8e5n0tjBEh0FJEicPTfX45p3cIZoIT+Ty5w
         q8/SyonNKlEQ25MHQLrqlkODAo6fl35d7nnjre6+HfjU86HWrXWc7xuM0wALhDHlEBQL
         WWS9utIoJp2YDT+L8oCYVfN/3jFEtqhtukuO3u3ZWr/eQX1uqC7BdCdh4UheGLQ4eOMl
         JTHr6Xrn6FWtYu+UtiBIFa0FGmLSU3PwhkT9inzPc8M+2/25hC9fkeDq9sd2VpH4mr+H
         rLnX5eoh0efSz1wYOQ0wDxSddyFQL8e8rQ/Wi/yXxEqNoTFjzrGr0pTPoI0cB8CVSwRr
         BWqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772043802; x=1772648602; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xa2NxgBV56+zcp+pDI4D3jQAyDOvWbrM47gZNUvrNM=;
        b=M/XktPmHJrnxTAFJkEKQihihVKAFXMooF+YoEawq6QNwdcj+P8cuyYCo09aw4zNbWz
         WdylWJFZA0LgW03QoUlyJqy+O3Bj1Ep74QKM1q4rM+yLsUJByIrEa7TGk0pogsFNvS0/
         Cit84Hnc44DYnAnVvJKjyum2gnQvZLsUatdL1ufpmScZZ56AQ0j4O+ZuYBoCQOPQAVZo
         B0p6SHczCh7fF8PU5Jae8ADh0UJnSzFginy8ZRid9wYHf2/VQyqfBiKUwx8SsJ/fcJ5J
         g2Ldr1tHd2EnLL/hP7Ykb/UK5KZx0ofaVC9hUnjnAi9Th2wEJ/qkFvoylsyYEqfgegGK
         WK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772043802; x=1772648602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/xa2NxgBV56+zcp+pDI4D3jQAyDOvWbrM47gZNUvrNM=;
        b=eRlGGXswGaXzlTrH9fxtd7OSzdXbwUDrmAaUkzi/4cquGKtzMPVVu5C6FREN6nlAe1
         0saO9iD8CizDNL8hRuF01qOVrZUyOueR43tb2Uj/nbdzja+np6a7lCgTsPJx1JnhsJi0
         lY1BaVBqQROd3C0edHTizfLImIkfAeVhkC2EfkTsc5Aj4E3KhjBuvx5ukblkqX5Wk2gy
         4cbjUvUPT3I5jFmU+F8nq/B2Jiy7FynKeJQ1BGBw3ix0rDsnoyydhN1TAF/eRD1cVkQY
         UAl2Wc67XWRDM9tGJHu9jFSn5UkM08ZSUfO08H/0f/M9vHrAFoD6Tp8rXW6vIPUdVtud
         XKFA==
X-Forwarded-Encrypted: i=1; AJvYcCUs5h0kOLoC/7LtnOGog/d8vVW42E2lEnxpcmIu5gDTygJS9Fshyz5oLCPl9thoxJm9ipm8gnEDmQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9n9PmjIDgVmydQ5Te6aVKsVy+KCJxmB9BIXvYeNmsSZ9l6MgA
	87qccCcIMatBa9tY64qgFWqsOJ1U9SyE53jehtwxKAzsc8Ogf/qVTcQw7HDKOMXjnDRPqsEMTOO
	ZQeGgGhWsnGh8VrX5bkDsu+7bEr9w4Q==
X-Gm-Gg: ATEYQzwJ1T28QU4AK//NkUbeIP3lQCtwT1GoE5+eHs24TmN0GI2bIwvuq8VJdhh7G32
	sOvEPszyw/E4c+IBs/zTzWrqESKsYUsKSNQCue+b8XcIrUzPVu/LJLbDe88X6VuqDUxknLifLco
	1fbXcNvexZQzD+KuzTQVmwB4Tkxc40aL4pb3GpUfSBA/ZAmVEGdHwZlzTS8MefYcrEpt1ZXjp6+
	UxRmx8SVgmPFQIhc3mkpZUH+DwcqPLaAFU/ln6KoMYiiz3iSu0rTuHzTURom3Gv92VJQPwACmYx
	Fgf2TLs=
X-Received: by 2002:a05:7022:1605:b0:127:3214:c862 with SMTP id
 a92af1059eb24-127869c8215mr555717c88.40.1772043801261; Wed, 25 Feb 2026
 10:23:21 -0800 (PST)
MIME-Version: 1.0
References: <20260223123232.12851-2-ravis.opensrc@gmail.com> <20260224014011.56624-1-sj@kernel.org>
In-Reply-To: <20260224014011.56624-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 25 Feb 2026 10:23:09 -0800
X-Gm-Features: AaiRm52SmZr4YLw7ydgp3VDu-h8ez3jJibjPYgTRa_tIkzg4tH3npe4ZI2HnusQ
Message-ID: <CALa+Y15MQecahb-FfeQEJK2uwFdC7VxUH7GHCfSvy3uQ_jNC_A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/4] mm/damon/sysfs: set goal_tuner after scheme creation
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0ECA1160004
X-Stat-Signature: hb6mk8oa6f7zoruejy6m6h5xg7atqaxt
X-HE-Tag: 1772043802-437703
X-HE-Meta: U2FsdGVkX1+KLFptF6m4lGy45NVw8GQqq5ThLhR8u9TfELBv/NS104h3i4+GairchL2fjx3K6qDAqHVcY+vmHEetqv58gimqznrD70I+NiZdOeZ42I8c9HwFwiA5A164IiuSVG0K89jcKe16Q9Vi9+MgGcMpQWl+skmEouDvuzMEGKaTg/xc2WJmNMtcoa2oJQS2k+fKvj1nPeSpk4j7arOYGFqxoz0il/TELlkKw6sg4bJZji+/TrraoiPYc7bVOytZigZbCH2FGwsV0uejwOi+iYp/pjXMqJRYgoAdLjA51uNDPFeHY8/zmhAI34yJmBR0AGJtl9ZA8IPiLLl/2jN0WT7Lwn6pwbo4fB5I+ic2PiYiHTm3VmE/AUwOfSpE+oHHUn3MrPR5OnXW19ewfADVC08HKqrvp095NdbN0UTmf8PrpukKOUrVtjCbj/hjuX2j2sr/ogZqe++7XFwgT+iLne13Ga/n17R9EWO/Bpt5qraFTF2WRgqnrv5irnbDwIAW3x3uP7wKd2MkEY7fwx6OhavP6vdMUznPus1S9CKrMnz8OnQu+UAgyRc2mHksNeoC0Wr4UKKue8aOfnj+LxnEfD5B3bcmLDUYilgViZ9+4J7SVW5a/L8ztBcXSQo6cFt4nH62FrBkADZH/auiN+29aDwS1dsMckRwjP3eDE8Oh1D6JdN9Xhyxn3LPRtiPEdvgJsXAV97c9kn/xZBLW7XIRXhWQZhbrMVf0xVaAs0Y3B8QMtY5si5AOgA5lX9q2EWHQulWJl0h3aGaXWWEpZzYwfAa3sD7QnWPswr7sj5wwCSoYSlQUCKcSEecl/qF+VhFGSNZ+Wyy2/tNZ0pbN9r9SoKrpO8+2g5ud81h/+kcnv3CYstscBnMJL4oGs7tFoblD7JXsXZ6ifZuCti2cU0QrDmvuvtpTlezNocdzXLg0Sxa7QVG2grZJhnuBsRLLNhw5M7/QdLH6DK6sjI
 tL0RNqE6
 nJkHGjfAskTQdkELEP1lSVA/HDivVD3CgVTdeqL5YHZC3K3lZW6c2gtpzD3a3qmHUmjjBgWDZDO2Ec7RNaCA7pX40H74U/2oKTYHyyFE0xiP6frZrAhztIwq8B+EBFIbHrP+UEgmVNIzotFwOitoSbOR3kElETd0rzbXZVZWktRgGvPTQAlECj8X7RWvbggWWPlXyrYSy6bKzhPVN1FSM4asEShB6iyKb9UyMlVSfeNWR7IaHbkrNk/fHa+DFXj9CNKqpMiCOhPKXvIU8SsPX87cF3WtPM6gghuSQsu8ZE1biOLOlD35ahG5loNo9d0gN4AJDgd2kJ4nVjTpizzgz1mnJTCz4TDA0GFzqSWVX130ptbYTznKypLuA4P3yHjWoPRHKZdxlZBb2TLDTxtlQwp/s1qtLjz7IGZHUnUfl37t4EbF8qMgST1Fx2TZvA1O1SP5ZqfMPFsPicTkBX2xo8tQH9EUCpRj5c6t/S+ofqkvgGfjk6zohhDCIP78L3JW5e7yihXJhNSbtq/P4iTOrldIM2twixavWPENJ2oxiMkLrK75j53QjEYIcwHmcaTrj3eFq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 5:40=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Mon, 23 Feb 2026 12:32:29 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > damon_new_scheme() always sets quota.goal_tuner to CONSIST (the default=
)
> > regardless of what was passed in the quota struct. This caused the sysf=
s
> > goal_tuner setting to be ignored.
> >
> > The comment in damon_new_scheme() says "quota.goals and .goal_tuner
> > should be separately set by caller", but the sysfs code wasn't doing
> > this. Add explicit assignment of goal_tuner after damon_new_scheme()
> > returns to properly apply the user's setting.
> >
> > Without this fix, setting goal_tuner to "temporal" via sysfs has no
> > effect - the scheme always uses the CONSIST (feed loop) tuner, causing
> > overshoot when the goal is reached instead of immediate stop.
>
> Thank you for catching this, Ravi!  So, this is a fix for the RFC patch s=
eries
> [1] that not yet merged, right?  I think this fix is better to be carried=
 with
> the series, and squashed into the broken commit to not introduce unnecess=
ary
> regression.
>
> So, if you don't mind, I will squash this into the sysfs-schemes part cha=
nge on
> my tree, with your Co-developed-by: tag.

Yes. Please go ahead and squash it into your series.

>
> [1] https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org
> [2] https://lore.kernel.org/20260212062314.69961-4-sj@kernel.org
>
> >
> > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
> > ---
> >  mm/damon/sysfs-schemes.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index bbea908074bb..fe2e3b2db9e1 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> > @@ -2809,6 +2809,9 @@ static struct damos *damon_sysfs_mk_scheme(
> >       if (!scheme)
> >               return NULL;
> >
> > +     /* Set goal_tuner after damon_new_scheme() as it defaults to CONS=
IST */
> > +     scheme->quota.goal_tuner =3D sysfs_quotas->goal_tuner;
> > +
> >       err =3D damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme-=
>quota);
> >       if (err) {
> >               damon_destroy_scheme(scheme);
>
> To follow the order on the comment ("quota.goals and .goal_tuner should b=
e
> separately set by caller"), I'd prefer setting the goal_tuner after
> damos_sysfs_add_quota_Score() call here, if you don't mind.  Let me know =
if you
> prefer keeping the current order.  If not, I will just make the change wh=
en I
> apply this to damon/next.
>

Agreed. Please make that change when you apply it.

>
> Thanks,
> SJ
>
> [...]

