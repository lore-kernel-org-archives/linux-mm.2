Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC7DCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 08:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E82C8E0010; Thu, 16 Oct 2025 04:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF838E0002; Thu, 16 Oct 2025 04:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC348E0010; Thu, 16 Oct 2025 04:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 301EF8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:18:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C39BBC020D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:18:47 +0000 (UTC)
X-FDA: 84003276294.26.A268986
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA50C40004
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:18:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FT1VsG99;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760602726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgHYOgNqUKqEBxe2gRboRiYdQxE4NjF5ePcPPbuQMg4=;
	b=vGd6Rcfm74KzLX1XYUiObiO0LxZx8C2zx41gf64c/9HVrFHydBtFpdvtW7v4DgU8hksSBB
	V7TzUGGRBx9E3UjSbujNHmyX+JPrqb4BHCKNlNY16/53i9GiGNv6A/0X54z6Pi0Q4wLJcz
	GzKwoOaIN3JMZuni5KIxbvgMdfYc13E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FT1VsG99;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760602726; a=rsa-sha256;
	cv=none;
	b=f6cYHDz1oW1efGoClC1IL9Whwgg/Tx7frdMBvAZqKZs78p1IMqNha2KcGUi1U0tDTyLtBY
	41OdciWw7ROOwBDU+0LqDVC8Rvzzf2vNiGze+xhVfR2zaeZlLtQ06n/+7S3WwR9sucBqDq
	Ji0nmxc+NjVA7+pP658JRCbzkbwX9lo=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-77fac63ba26so4778927b3.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760602725; x=1761207525; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zgHYOgNqUKqEBxe2gRboRiYdQxE4NjF5ePcPPbuQMg4=;
        b=FT1VsG99HZ8rzeR1YhTgYD/VFhMqIqTCYtLkzQ9Wg5H9xdzfxjT7Eg4dx2Q7mv/3U6
         2cvoXwWaUeMBpp1qJMJPTqkHBrXI7jwCe3MIgAKXJe1Fr7buOr3exY9Ghh47CPR+9Mb6
         Qq04G7Aiu+iUSLJmXTOoIoJQizY0nADr1xEvR4eCwLgBsUVRQONvmI+/gYLXYLc0ZQpf
         DHeC601pJbRPFgXqgBcul+Bo/zGIdJ7kkELWqfKz9Gf+dt6XxtOd4Po3hjuIgvuKVFD0
         fGD2PNI83KVllqaPR+crp4T7wRlToORUcb1Fq9F0zqNWmWrnSnGfCKeDUQnUdASBT+wD
         ecRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760602725; x=1761207525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zgHYOgNqUKqEBxe2gRboRiYdQxE4NjF5ePcPPbuQMg4=;
        b=TCsZcmWO6WEBko0vIIVRHzCkCiBNdOm305C4+OzYLEOEBEZsRurvHTURTDmSvbZHS4
         kqB3Q7hmQOmPlFIhS2f7R6WM4bPU186+PfCn9Hf1m1MKUH9p3Q1cmc53SRgU/Wm4NZPz
         cEHGjLP+IJNZxrld43VTnrToTIJK245+Z3938xXakAnE1E4WHNXPRaqHyMzOdt/kLozI
         OK6JQR6MfjmWYEPZe+N+//9amqU4b4KpTid8W++wRvolHBSY534LvLV3nO5pE6Et7t0S
         A5dPA73Pqb+dFcpGayreLy9SFydoMR7TeRsK0Rq1MjK9woIwkkARtNWtA5QUiawmFju8
         eTwg==
X-Forwarded-Encrypted: i=1; AJvYcCVorlitUaQu1rIEdubAUZeR33c73893X+aNADcFRC3cfROG/MsuqIyQ+iPv7EgylUQeBUEDgufxkw==@kvack.org
X-Gm-Message-State: AOJu0YxuJEV/2OaMcSedPH+/tuU4va+utS1uQC8T+zLKTKMA28dpLA9p
	LtZbhkxwFy3fvE6Nw86UW04KVo/luF09VIGoS8uWgBAfhCpma6t/3wp4+mQu1qK5IiH+SMsQieA
	LelnvZ6ZcxsmAAWNc7w7bbN1LZeutq0o=
X-Gm-Gg: ASbGnctFZCT0Ub7yASqEp1c/dkFenh0TtRZqBQhOmGUHIdJxt41hyLVZOLiXdTwrRWo
	xEVNkZjzJ1e8zf++Dnr32djbNEPqI8GNRSwJidLM36AmxckJ2cl6Mz3LBfX73C4VEq2oNRlmsoi
	oKb1UCYKhm/A0GwYMlHf1LAkzzo65aDmd9W8q61fiRM1jcsthuOx85kpfYh13e6aJiS0M+tdxKf
	vQWtDdoRW+5rDmUQpVQKd1jfEEKYVl9UjajhBw6LNrQAfKrXP/kDCGVSILGZnhZw1W1FqBR
X-Google-Smtp-Source: AGHT+IHVqXd5quXoFkL7TseeikvmflCG1zrHiGi4zY5UsuuarF4PtLzgSuWNSHW7MIFsJygYWpoqCYW0WFpL9IgIR0g=
X-Received: by 2002:a05:690e:4007:b0:63e:dbf:ab89 with SMTP id
 956f58d0204a3-63e0dbfaf6dmr985502d50.21.1760602724828; Thu, 16 Oct 2025
 01:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20251015141716.887-1-laoar.shao@gmail.com> <20251015141716.887-7-laoar.shao@gmail.com>
 <CAEf4BzZYk+LyR0WTQ+TinEqC0Av8MuO-tKxqhEFbOw=Gu+D_gQ@mail.gmail.com>
 <CALOAHbBFcn9fDr_OuT=_JU6ojMz-Rac0CPMYpPfUpF87EWy0kg@mail.gmail.com> <ebf60722-34e1-4607-b6a7-595fc2091998@lucifer.local>
In-Reply-To: <ebf60722-34e1-4607-b6a7-595fc2091998@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 16 Oct 2025 16:18:08 +0800
X-Gm-Features: AS18NWD2AXGKlmvFo5UH1F2cQyeA_L5yHcpBAgeZL4_sZgqmARGxyWqYqUTXbrc
Message-ID: <CALOAHbDnJyou=MUwPBCEwWeeK+9w2MiOXjpkkcCALExfnsj=_A@mail.gmail.com>
Subject: Re: [RFC PATCH v10 mm-new 6/9] bpf: mark mm->owner as __safe_rcu_or_null
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>, akpm@linux-foundation.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev, 
	rdunlap@infradead.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EA50C40004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dk6wt96q1hcqgifpmgwuqfjhmr3dh1zf
X-HE-Tag: 1760602725-513729
X-HE-Meta: U2FsdGVkX1+cFWB8bccL3uwbBA4S+B58GORsMWTvti+UwDRx/HDq/QBqGKdT5vTC/17tuds2J0bZp0uA0urGErJ3UqhAZ4HmtOuLFfud7X0w0Lm2xfRJNgYUKyFCAJYPIJgvZkCWDagsIF4Y9MEI4Z99k0e/WwZPutu6VgXsO8oaLngXUUcWFJZT86XXCT0IR4/jFgp/bWPB9R/ByuyXll9arUmkPbq8L9MypyCHfv0dT0lg0pLENEYVLAr+OnyJfRPcUXmarYBTksJEFEp6j5I3oouEklK7gEsPnbw7vtci2ffOs+0t3Jdh7cGMN1b6AhFVwSME3P+9nXHnYkL/sKsTy58XozEYGOjdIs7fuDd9EoDjedlykVEykNZGNZ+dMX4otAB/QuhDNUmJ9SfhvdGAfOI9mKbadQhPvCVC9edWH0scnp6BW7jlgcDE/FQtRHNakdstde6Luc6cU2tCD8mvLZNGjr0R6o/hSOlJ/iQvlcKwucPgLfNQvGCLdcGBmXJUqgzpug8Fn5evjqVahXujh9VUZIhvot/bVqbmCuzC3dlL3vRlSJOm1XkBm/A/nLISAseuFw7SpWQAdbXRjEj/emrHkl5COsr9rUAJQIRRtWy59lOw5Cz5vlWRPaVTrmP5jmXQoYRnOomQmTAZU2S2g07RdJ8ug3zzNN/uu+xtww5cCRNGdXxRCcVmpfprhLugGCEtSf/BNrYkvfYz6kJMSaGIjA3pvgM/po3vC5NgeizR530jmmmecCdW0y9cO3UjPtQyc4VongGqVjPJtwlVguff/tO6iccfN9qNjAWotaLI0Y9fI6og8/DHCrJY4Hf6Jtskhjb3lMI7v4JE8hJvvs0RRM+4FXDlQquxwjMtHvcflSKhocaMm1+k/5Iu3flO2rkSN9iftnpyMTkMkzTBDTP/v2zE40NkyfYzEIdWO5UTSJGwwHVT+d/CKlM9vumrZQhGWEJVFgXUtcW
 KWIzoaeT
 yMYzlNdmH/LYe5NXIqUIotY+cHTxl2oWVwrOCyvT69syTnPPN23m1K8IzsM2bLg8VQwgB7/vcuj1svdhljLFEI+zCMEdje9CfFlR7HnKeo0yld1COw0FX5wo279gvDVGdbyjtmMXQcw7zNPdiFSUfxotlKHJxqoXV70sZ/zvCX5HRi9r2z4o3ex7+fh12W+ENnbPW+K8afAE+pa0UhfbU17hld3QQhoA6fMi8d5qk+thLmSQ1J9NIbeyNe36DbJbSefoBiI5TEpyRC55WjClwknyNTRGtOVJGf9T24wssOf7MbNtLA4ZRiErKbeVIyhLETFXRVtIAd/ldJtFmAX6DR1kVT8utmIKzqDDRkLxbHcm9IqhkAFwsJuNki7vOuanygtJG9AYOqoIi5KctozpwgqoOFJSlfj0ftS8d0J78BvJJhKXzzx9Ah+P881kY8aXjALeJXi5miWI/QeczPl0dcyBGatQmgFVi7myup3noVOVRHiRWssyJhd4tHbyg44mJPh5HGQwwJVm1wvZUrB4deJ1A9dzU1MINnWzfhbSV00KOKjYqK8bcrUOEM0HJTEG9TzLeSf18d+iS65A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 3:21=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Oct 16, 2025 at 02:42:43PM +0800, Yafang Shao wrote:
> > On Thu, Oct 16, 2025 at 12:36=E2=80=AFAM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Wed, Oct 15, 2025 at 7:18=E2=80=AFAM Yafang Shao <laoar.shao@gmail=
.com> wrote:
> > > >
> > > > When CONFIG_MEMCG is enabled, we can access mm->owner under RCU. Th=
e
> > > > owner can be NULL. With this change, BPF helpers can safely access
> > > > mm->owner to retrieve the associated task from the mm. We can then =
make
> > > > policy decision based on the task attribute.
> > > >
> > > > The typical use case is as follows,
> > > >
> > > >   bpf_rcu_read_lock(); // rcu lock must be held for rcu trusted fie=
ld
> > > >   @owner =3D @mm->owner; // mm_struct::owner is rcu trusted or null
> > > >   if (!@owner)
> > > >       goto out;
> > > >
> > > >   /* Do something based on the task attribute */
> > > >
> > > > out:
> > > >   bpf_rcu_read_unlock();
> > > >
> > > > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > ---
> > > >  kernel/bpf/verifier.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > >
> > > I thought you were going to send this and next patches outside of you=
r
> > > thp patch set to land them sooner, as they don't have dependency on
> > > the rest of the patches and are useful on their own?
> >
> > Thanks for your reminder.
> > They have been sent separately:
> >
> >   https://lore.kernel.org/bpf/20251016063929.13830-1-laoar.shao@gmail.c=
om/
>
> Could we respin this as a v2 without them then please so we can sensibly =
keep
> the two separate?

Sure, I will send a v2.

>
> Thanks!
>
> >
> > --
> > Regards
> > Yafang
>
> I do intend to have a look through the various conversations on this, jus=
t
> catching up after 2 weeks vacation :) in the kernel this is an eternity, =
even
> during the merge window it seems :P

Huh, we've been refactoring a bit too fast and furious since your last
review ;-)

--=20
Regards
Yafang

