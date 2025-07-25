Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983B3C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3602E6B007B; Fri, 25 Jul 2025 14:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3117C6B008C; Fri, 25 Jul 2025 14:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E206B0092; Fri, 25 Jul 2025 14:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 150CC6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:27:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB5B3C08F3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:27:04 +0000 (UTC)
X-FDA: 83703618768.20.67982FD
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id CDE38A000B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:27:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=k7eY3PU6;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.54 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753468022; a=rsa-sha256;
	cv=none;
	b=iaUmO9qGyeRxHBo4OYJKiuV2elyHO/C8kXgS/siKfCjqqWJDFt9o4RMQkHlqikA8GpxfRA
	ObH6riYQ0KEY0oU0FVxE8QxyjP1Z74xTnBHabgulr8RaUNHnSZn7GuJnqXRaOZzfWimgAX
	dAYmsxc2q/hBCH17oUs22rcBUCPXo4c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=k7eY3PU6;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf25.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.54 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753468022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alGDq6Ry3t/6owOKcyElG/+ugV+qZlm3QpS2noyYRwo=;
	b=u9QKuP14gQrc8EBF3r5c4Jp08B9W6+QBfQD1NHq93yuFtfYZVFc94Yae7dEhR4+MFwHYa8
	nkyb9QUFFYDplzn976xy2O9s2F+n3hHGrDy7umBBCbxCVfQHTwPZXYrCPx+6CVzDEOeXWC
	MSLN1zF4lQplQKOElfWZr4YYTTIzwvs=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-302db17fa08so217296fac.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753468022; x=1754072822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alGDq6Ry3t/6owOKcyElG/+ugV+qZlm3QpS2noyYRwo=;
        b=k7eY3PU6UwNAz0aH6yY4sG9THReEb5fB9LVgUZ/RkTrz7JE/33dAUMlAypR3ELAYY/
         00nOJOapAOxKlt/YuMN3ropO3tKfdNJXT+37/iR0qixsEXCwnsnpLD/dwKGOd1XgXjtD
         mSucJCt3oc/9iFR8yqSnmkxvRov82tCQ484J0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753468022; x=1754072822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alGDq6Ry3t/6owOKcyElG/+ugV+qZlm3QpS2noyYRwo=;
        b=WTrMNP/AzFBHSQJHJOTzpdxwBExWGMrN599/Pw1zUZEH3H6SELwXprB5CaQ7lzDHpU
         2cro+d2dF40Og5nO2xxA975lQxeYq66N1acFnUxXh8dDYQCHqXf+gZL2ZUaoscenfPux
         kH9o8z+rvNLgiH76r7QOtXBA+AfJYkXy1XW6ITQLBeixMxR4Cw7DciS1vjJKbYZ65hej
         nhFXZUgQ6G8QNx6mk4358ncW2vaUsQextZneX37DT0RFPUGxHCFybKm4jHmTPmw8Mbit
         5txh/qtUOt0Xsw3S83VBFXmSZLfVNgIZhySFtX9cxlBbWQ7dDSWSyfsHoZOGzVbByFAx
         oPsw==
X-Forwarded-Encrypted: i=1; AJvYcCXKTQMil2f7weLNm3dHzbq6XH+cml3r93DXod8KOqx1BSfPWIySi69TweT9q6d1RAHX/qk218ZsZA==@kvack.org
X-Gm-Message-State: AOJu0YyGlyNY+OjvR0/YUiUKROWybu6VjqCakyCIQvsrTbKprpxQnEb3
	T0g8wH+qay10S3h+M1B7kObXOveYii9V1XWaY6UhSXE12t0uuocqAE5oIXrcg4oS9irjEK1Qrb1
	QcQV/y6hQ/lm6FvG6BublJq3nUPwykydAb4MMM5Wb
X-Gm-Gg: ASbGncvbBYHui55RPNsEhocc/ho+c4TSjB+NcEkZJb0Dd9TWyc9/L1zfKrD8FBK9rlC
	Er/I0tWzKLCBZM+qVC6+YDh7d4q/Ayi5Jkz9LuLhAFwVEnrr6p9h6RshYhp4E/paaYn3laOAiXq
	zKOA6MsgCD8ubsa9W3HJoRE/JqXrHN5bInUmVCK1I/4zb+3LMzifAR2XcwGOj0ZC1tCOW42o+lM
	ywbdUsHvBr67hdOuOR26cduQYQ1dXO/t9XAIw==
X-Google-Smtp-Source: AGHT+IFngRzgfoejt3mlP9tvAddRS2UA8uH+ymeb855nbW+1wntTvnE+e8poGwzJ/rhE3BnJFtfzCrluyDBgcx0E7IE=
X-Received: by 2002:a05:6871:758a:b0:297:276e:7095 with SMTP id
 586e51a60fabf-30701db3c7emr663346fac.11.1753468021761; Fri, 25 Jul 2025
 11:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
 <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
 <CABi2SkVeHWt+SKWWodXUNhXZi1Wv9YazEOGWEUJLvgPbopqBrA@mail.gmail.com>
 <ca6af6bc-1c5b-47fc-a00b-11d46867b5e7@lucifer.local> <f860d082-384d-4230-bb1c-09206c7daf72@redhat.com>
In-Reply-To: <f860d082-384d-4230-bb1c-09206c7daf72@redhat.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 25 Jul 2025 11:26:50 -0700
X-Gm-Features: Ac12FXxhETnYd5YWTH5JWBSDO_QT8rIt6KG98Nmkcj1shWxdgrRx71TTjPQMff8
Message-ID: <CABi2SkVJ6O4GbEB9OAHwf2FjWJNj+1dJA7nUynRQYLZF9=LGKA@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7sj5xgnyi73je9woqxh4j9jc3yyd5ksa
X-Rspam-User: 
X-Rspamd-Queue-Id: CDE38A000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1753468022-274274
X-HE-Meta: U2FsdGVkX1/62xXwLXVdH5SmjRti/gqEVc/idDBNA42Qw1Q+e/ITO4/TN8loTefmjJNeTvsn6YA9CdrpLNIjk0HACPBvNkOCouHPXxE5b0HZQn5Kac5bBkrQbwrxDr1JockcPauH3QbL1PMx6GpCEhz+K2LroNEz/E0JTZMO7uIX7Bz5Ekio/xs3yHG+uSjqJ39EK2e9QllcV0NdoH1peAyS6km/GhBx/yAI7Z7jG/3s6e33CNQ64nvTn9Blzqq3bu3mC/3a5qhLrcw8AedJ81UCMLND+4O08VkfLgyM7Sji1niqDABrCuGwBj4TouFR1KxWFnS2+vfj46FMYRD2tTi7eRL1m+02igawvCsU/FcmAsdusEJmrmk1o1yQwtKv8h+mJAyJJ9T/mziVVuDHTSB1wxrd0wPa580Xi/T8pP8zRzDsd3s/dkFeu+J4Jr4b+11OyXylfNovY8y6wFMd1eFV/aMzMegPrHhrSOXe1md/L7cM14YLGOR7NL3bz7KwMhE9tSF/tw33I7jMyy7Y4bZgFjyBesTru/7vQFcoNaaf3HVXn0bF5nUMCzxwwZmdqgHOZJvDZdjiY4uu1IqLtz73UUiwhCpJI4qpLLKCHBXX/1haFQtWRSnqyIsKqHqOjwKfAW1FkG3wKTL4mWiQ4c2R7Bs7qssqHSvrCN5BzAmRh2sv9XPLdRsBmvRY/a5P28NTY1Slv7zUUnBOQi8byPf+7sREE7T2SFPrb6l6mCWNmnEd6YRkWSp6wW0SturcFX37O0kfQ7ZSrsGXVFojnluB9lxy3QlyeUOaAp+q/nXrHEApkhFDn/pS1oZUMiYeVUTK5cQ3OGI7h/Cx8yLCP3ws2KkN0DM8dcK1Pk80EgiCtsh+3sJwOvQh7/aeUdCPMMGECctHoQbFXzoQpZHu/WlRNFuozuLCrbpjMI1C7gdPIl/te7cDEgCnDR02exkURqHWBtSy1vOAtND493x
 QD/lVrIr
 Wthx//zpVk6uXtBI1HeQHolkRo0rhn6dNkHyGRbvRBuboiZdWJWOTriCgm5i228CE6IWkSGgidpDTVW6ZGOzAX54pHRTnpXGs+arFcV4Zh+gKV/KKJIVOFnmq5XOlu4Du+B1rfUqbmRJe1/iv9ANivJ9IqCaV2YKuhTMIt5X/SUGcOzzmMsW5497v/evv19sd3py7CTdCVuBsQ2Tkz4wE7nkQId9qR+i5iWRl3KmPSBSw3i8n2AVra+HDdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 11:10=E2=80=AFAM David Hildenbrand <david@redhat.co=
m> wrote:
>
> On 25.07.25 19:43, Lorenzo Stoakes wrote:
> > On Fri, Jul 25, 2025 at 10:30:08AM -0700, Jeff Xu wrote:
> >> Hi Lorenzo,
> >>
> >> On Fri, Jul 25, 2025 at 1:30=E2=80=AFAM Lorenzo Stoakes
> >> <lorenzo.stoakes@oracle.com> wrote:
> >>>
> >>> The check_mm_seal() function is doing something general - checking wh=
ether
> >>> a range contains only VMAs (or rather that it does NOT contain any
> >>> unmapped regions).
> >>>
> >>> So rename this function to range_contains_unmapped().
> >>>
> >> Thanks for keeping the comments.
> >
> > You're welcome.
> >
> >>
> >> In the prior version of this patch, I requested that we keep the
> >> check_mm_seal()  and its comments. And this version keeps the comments
> >> but removes the check_mm_seal() name.
> >
> > I didn't catch that being your request.
> >
> >>
> >> As I said, check_mm_seal() with its comments is a contract for
> >> entry-check for mseal().  My understanding is that you are going to
> >> move range_contains_unmapped() to vma.c. When that happens, mseal()
> >> will lose this entry-check contract.
> >
> > This is just bizarre.
> >
> > Code doesn't stop working if you put it in another function.
> >
> > And you're now reviewing me for stuff I haven't done? :P
> >
> >>
> >> Contact is a great way to hide implementation details. Could you
> >> please keep check_mm_seal() in mseal.c and create
> >> range_contains_unmapped() in vma.c. Then you can refactor as needed.
> >
> > Wait what?
>
> do_mseal() calls range_contains_unmapped(), so I don't see the problem.
>
> We could add a comment above the range_contains_unmapped(), call stating
> *why* we do that, which is much more relevant than some check_XXX functio=
n.
>
> /*
>   * mseal() is documented to reject ranges that contain unmapped ranges
>   * (VMA holes): we can only seal VMAs, so nothing would stop mmap() etc.
>   * from succeeding on these unmapped ranged later, and we would not
>   * actually be sealing the requested range.
>   */
>
Adding a reason explaining the reason is way more helpful than just
stating what it's doing. Thanks!

a nit: I would use:

> /*
>   * mseal() is documented to reject ranges that contain unmapped ranges
>   * (VMA holes in the middle or both ends): we can only seal VMAs, so not=
hing
>   * would stop mmap() etc. from succeeding on these unmapped ranged later=
, and
>   * we would not actually be sealing the requested range.
>   */

To make it clear to the reader, because VMA holes might lead people to
think they're only in the middle.

Thanks and regards,
-Jeff





> Something like that.
>
> --
> Cheers,
>
> David / dhildenb
>

