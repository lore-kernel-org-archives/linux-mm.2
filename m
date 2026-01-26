Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4205C88E42
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 06:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC556B0088; Mon, 26 Jan 2026 01:10:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A876B0089; Mon, 26 Jan 2026 01:10:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83B06B008A; Mon, 26 Jan 2026 01:10:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6F926B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:10:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73CD41406EE
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:10:05 +0000 (UTC)
X-FDA: 84373089570.14.DB5E5CF
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 82164180002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:10:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sU8qzDpu;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769407803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2H30noRGjs6dlYj5U6mmK/jvHGeZbAyKXQsiVYLmKCc=;
	b=J2AGjyCcC1ozLINkvvBeICDpscNIQIZGTgyR4LSNJSPwRljI4M3zwr3hJvuRYwZpGh7Kui
	BzAkqYqcKcHtkGrj1O3EZkIot/hHdXkGRdUOmNTGGmsE+VmTNIHaffEyWkedlP7o9wlQRu
	YQW6ewSQiOj/vY8uNYVHrL+BAxduO0o=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sU8qzDpu;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769407803; a=rsa-sha256;
	cv=pass;
	b=QhzP2jcfM1uoGjNDIodZe3S48NI6XccznWM+GuXDJCznUY9gtWhKQ2tykawXMdH+CUxtSk
	1jvgRZ9JUID1UbRHw9bEV3h51YgrkIWSejJeppc5VpHaJ63NbDosa3hRGNj7d6lE1MEtg3
	LoeTIHu4hrnVibhJkk7rLLjSXKAXWjY=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5014b5d8551so803741cf.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:10:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769407802; cv=none;
        d=google.com; s=arc-20240605;
        b=ELdDO67B8muW6IOFhq68/t/9inbQp67ApQd4u7KeNZED68JCQQNXZenBjC7qXuC152
         YQkRF1Htsr6UDTwpy3LVWgdzrloD25oVwgN9mzA3fkCxo7v/Kd6nxeuWBi/SFUKF5yDC
         skjfn7++hIF3X1i+TihdRhrs32QDKwREuNw6+5hn/+nbJN4ebIKlcqsUhmiIy1Ut4Us7
         0VpWrbJNiwBdbk44FigIebFU4N1EhP07/ZVV4keCUzc6zbaSuoQCqOeJf1d2gFicaFhv
         mBBT/cc0ZwOtWEWKKQteZTDB4qS13hYCqpxC3xO9+Chz8RdWMwUk39KIrz5Vmpec4KV7
         Le9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2H30noRGjs6dlYj5U6mmK/jvHGeZbAyKXQsiVYLmKCc=;
        fh=fWJVotUGVfSYHX+I72tOkgFikBp+GzMexmGPfdLrA0A=;
        b=kA/qSlwKjCLt4bA7Ns280SDo80+IJGmg92ziM9ekwqcIb4Cw+JsntCToSwur342daX
         Rxelal9R9wx4SiKKMixRC//sVBeKuviX7ofIQxDSaFSzRMTRA5e0zTkz815vj7afR8Rr
         sk8/0mIYEyKX308ZQdUFICr0Jp1OIZ2Ozbv32YIX3CT+ORSATergiGuE4BGZMv8NBM9+
         GW2775NZBUUgq9ezHSu0WYWiKLaf8jAYz9b70hzreWerNrPqQz0JFf1YRZ4fpK1HcTMK
         yTk2LOJ0VkgVfh8VY3Ou5FxQapUNwCIXTUppq4+zgdCAZWvgd+BMwXKSrv4bCZmfJjLe
         v8QA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769407802; x=1770012602; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2H30noRGjs6dlYj5U6mmK/jvHGeZbAyKXQsiVYLmKCc=;
        b=sU8qzDpu843ppCPlvGeTG8sjJ70BZnUYkrI5u4c5ZKvPKCOJSy4LuTkUW8EGxZBj6c
         +LmL8DlV9ZqZZy/ZHa7zxHjlbl0u+32gVuQurjdd7Q9NULqfklQ6WzjIzF1CL16F8HoE
         VQY0oZ889cpQxJSEiGZE2DbPiGcGQJu96pTKmWFgTQigf+qhss8q6L1lNURTv01d8dbt
         FafnC1/IMXyVJuWtk6DbXnW7qGK7wQ0GkI5tprpxn7P7mb6RX8NhRbRyfY6KptzGNrw6
         rR6b6WxFd3ZtzKLqW3oVc7GdBPtd4rdmHGwcvC9PJyMADEJ4hcCz4yO51zYxIWDvInuR
         8wHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769407802; x=1770012602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2H30noRGjs6dlYj5U6mmK/jvHGeZbAyKXQsiVYLmKCc=;
        b=F45gsaq7TjJOmuHTsUiSKVjPTiQkbf9KnMMMt8vrFK2FFH4iRtTk099rmMThBWD+J0
         ewZ0WA34ZoqZvZVrkPH2ZbIwoThqvqqWvHoNWfYlr5PBP/NtHymr6n+6i3Fy8DaxoLm4
         RxKI2OziGFK43u1hG89wXHm6w0Gy36aPWis2pmnGgO1BEQHIDymOjPCZy/aZbJxz5S6g
         SAqArIPaQgk5sCcazU1p866nVdxwUJsm73sIvD8Ov/MMkIoIdUQureFDSaUKRxQ22uXI
         IBOP++4OQk2QJrKXbEsS+0egWdZ5ID91vlnjTxfhEHp1zXeMqhB/9mG9kCEGOWbIRil6
         uUEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDyW204fhQWMerDAX+FXvblAH5jyl3Agw4q3wrqXVxXvvpCbPJWSR/OEditNQjSW9AvN3xK23h4w==@kvack.org
X-Gm-Message-State: AOJu0YyMx0Zm/lLEl7VC1QbM/JFoUiVaYhgMgkzTZcOrnXCPZtMAhZTP
	r4mJu1SHKVslxZGehinIUaDF/9t/yoT6U+4k0q8ItUmP9Ovejwkj6I6A6pJ1kW2bMynauWusyfd
	yQY5jFkdjko+3rygBtqzUELfeyLTLqAeI26dgxfZ0
X-Gm-Gg: AZuq6aIeMl8jX6INHLbtaqyNhFZJFboHw9rhARGKHiG4VI7Bvs4yg7lrAZWVK62qtRz
	oLheJdvivbn5ZiU1hkep1mPUAzq7eDUuXFJCBMrcDAmKeZSYkqHi9AhopOx+/cNfzbddyvvXx5Z
	JSxr3XvO2Hd+gM08xdQMpPHJ84sV8rHh4RonmXQwQzzxHRqfOVoS0VJigViM2EH6hDELKIII0J3
	b8rSOdNVDauNFwearnAmQv62gfy6o5+3/A5nnGxut0Oz5ARTBw0IM4MPpJPx2mN0AGwLg==
X-Received: by 2002:ac8:58d2:0:b0:501:5180:3c90 with SMTP id
 d75a77b69052e-50314378ea1mr7863181cf.15.1769407801346; Sun, 25 Jan 2026
 22:10:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEULwMTxAzxUdzfpHe2=+umXL6HFMvydkqW=tP8mB2ewg@mail.gmail.com>
 <c7c8158d-e360-4a29-9e48-f2b45b9ca147@lucifer.local> <CAJuCfpFbsAHr76ZfUEaRLzdxQMDjPEP+bsLNC35X9t53G_uqAg@mail.gmail.com>
 <c4d64bde-831d-4f3e-9b92-68c1beb70599@lucifer.local> <CAJuCfpE3D8XyR5wy+Zzq7TX5am=q3SrevarJaf6Z7-k-9CkmkA@mail.gmail.com>
 <023e56e5-1c2e-4482-91f6-32765cca4bda@lucifer.local>
In-Reply-To: <023e56e5-1c2e-4482-91f6-32765cca4bda@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 25 Jan 2026 22:09:50 -0800
X-Gm-Features: AZwV_QgcAEK7MQNe5kQXzo6PF6GXSdKbtlaBVT_oqajfvBnts94OqV1Gzyhylp0
Message-ID: <CAJuCfpEbmc_hhom3A6_V2wJB1rxNHMfW1ebg2TnnMRfE8asahg@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 82164180002
X-Rspamd-Server: rspam07
X-Stat-Signature: u389c1xn74qiday4a9cz5sujkdwefwey
X-HE-Tag: 1769407803-361038
X-HE-Meta: U2FsdGVkX18sr0/OM5vFJRlBILkLLyt8xquivRlLniv7B8P4VhAqcxce1VrMCOp3qWO23TCozSVI44u+6UMDsoOpp0wqJD+Sw/w1JUNe88rryAbxdBPFX230BZe/632oQimlo188twy7z2kkPsFrBg3pT18EySA/0guxhqowMr1zARZP2gPfysu5DRaAAlLxUUXUo+dNTtchanQzsamSoF2RXmcvAUQg2WlIc19V9n7NFWpcgrjAKmxVPYiUq5lyKRmGhvKKDX9qgGq08eUYpEutvx3o+UUwVoOX5+WSjKeVNDqjBh9eU0cuo1WsvQT1NWHhMw3Rw8NHp8XztJIuYpw9AxJEBuFfVy39KiMoPgqXl4texcpvsHyBpLg4ZuvcxP2txH0x7RegNWZ1ArgGknx7ooQhM4b3+2iBs+4qoYjN3DmmwDfOKQ3j5thQCwGj3v3S7/um16GsQIOT4pV4fzndPdR8RAtiMqDFYche3bRggpfZRvLID0OZR0K46/sZ5M2WbVLZpyree0SYJMlYNPPMYihedgCfMC7YZ/Xmy9MXHSiud0n03XizjfzcggO3ynvxtRRsWY7Wfh9wE3KfSgvh935+AAnWX/4XuUZMfTJXjkFRfpkUKExAwmPZShvV795GIx3miqU1ykaPH308YS7m/sAeB4H8ydcQ8eouAGA6Q7GnnFsfnOhtR6Bq5TIZ56qyuLKWAgD9I0dqq4KkEdUlFoo8rJHRoa/62tasZwxAf0kTKLmpu8cZzLKKINEivfSDZzyBVYZQ9w93Pr9aVXW5ODulqDoIpL5sSjFzOx2abtFsWiKNV3ShBMsEd+jujaVdlZuYyOsHguZBDmDoKRPgvpWdjhziK1v33FHZi7UhMYcGYk33VwOGhvDBLhV8+JSA/+4cFBE6bupfnFkvEuQoPdNo/a6NKBn5CGmNINifaHRYBxcLzpXkxXJElQUpIkYtr22FNPcObH9yHRm
 RtcCmRYc
 br/0l1RfwdY+wMNZLrMywUaJgqYzKWi8C+pFKoJWgbLVR0WtnbvJYA6ea1AumXxx5fAd5FXg93w/RqcuRyi2IL5MdUN/5kot8PZuRg38m9+Ldih6XkvO7Wu7D/YqTUl/uUkhGzPJkshvQd8I/cZUCFib1/XnrozwhKFfpbKkYlqU80q8y1Iks56RCEdTVopSzZPbhOUYkj+v//WsuwSlMU94A4Aak0DhUnJ5+Wv4hSS6TFCgrjKPwjBLUOTuRH9JU7WZCrbLIfUY3ZfKg8JU4RoPLypMzQlY4yjll9AJ/cKrCce1ZPrsLC6JYnP7F3jTVqlaXKfAd20sB9Fw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 12:54=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Jan 23, 2026 at 02:07:43PM -0800, Suren Baghdasaryan wrote:
> >
> > Sorry, I didn't realize I was causing that much trouble and I
> > understand your frustration.
> > From your reply, it sounds like you made enough changes to the patch
> > that my concern might already be obsolete. I'll review the new
> > submission on Sunday and will provide my feedback.
> > Thanks,
> > Suren.
>
> Apologies for being grumpy, long day :)

No worries. I get it.

> to be clear I value your and
> Vlastimil's feedback very much, and thanks to you both for having taken t=
he
> time to review the rework.

The cleanup you did may not be the most exciting work you do but it
really aids understanding the code and its intent. Thanks for doing
that!

>
> Hopefully that's reflected in just how much I've updated the series in
> response to both your absolutely valid pointing out of mistakes as well a=
s
> suggestions for improvements, I think the series is way better with your
> input! (As always with code review - it is just a net positive).

That's my goal.

>
> Please do review the new revision with scrutiny and comment on anything y=
ou
> find that you feel I should update, including this issue, perhaps I simpl=
y
> misunderstood you, but hopefully you can also see my point of view as to
> why I felt it was useful to factor that out.

I started reviewing new patches but need to check the important ones
with fresh eyes. Will finish them tomorrow morning.

>
> In general I'm hoping to move away from cleanups and towards meatier seri=
es
> but as co-maintainer of the VMA locks I felt it really important to make
> the VMA locks logic a lot clearer - to not just complain but do something
> :)
>
> In general the issue has been around abstraction at the 'intermediate'
> level as Vlasta describes it, the public API is fine, so just rearranging
> things such that developers coming to the code can build a good mental
> model of what's going on.
>
> So hopefully this series helps get us a least a decent way along that roa=
d!

It definitely does. Thanks again for doing this!
Cheers,
Suren.

>
> Cheers, Lorenzo

