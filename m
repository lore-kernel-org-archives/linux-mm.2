Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05387CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FD78E000B; Thu, 28 Aug 2025 08:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357C98E0001; Thu, 28 Aug 2025 08:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294198E000B; Thu, 28 Aug 2025 08:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 194138E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:16:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95911117139
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:16:57 +0000 (UTC)
X-FDA: 83826065274.19.461626D
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5F60918000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:16:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Hr8SpoaL;
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756383415; a=rsa-sha256;
	cv=none;
	b=OLFx0mF6Rxcp18BEyQq1FWDv5xhuSxhoQER0R4feJPuX1tKHKt8Y2A0yrfecm5iKxxRrtd
	rfz8aCf8cy6+PNd4de90Ojqf0OAkz606tjExDZlto3PLSafrGsOs50zy3bSR2Zu4Srxz4v
	eE1ZGozAdzLKQ8DKsLlvwWyNnImgvKA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Hr8SpoaL;
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756383415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWyFqw/gsVVjjcdygtnF3DRHaolgd2jXueCTZS28y+s=;
	b=YyUTq5C5OPigKgekay2A2L8UrBRkDbJcaU73kaInXlI1TWb+j8qTmIBw2Y23fs89FWKmQe
	Qq16trJj1O+RmIqOxAUtDgrnwjxvOaeII2QWhxPFvFLLiH1rcKC30mreLEx4xGm4ZtHNxQ
	eq8GFTp1rk3+cckwW0r0ogOwQCm3XIU=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so118075566b.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756383414; x=1756988214; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWyFqw/gsVVjjcdygtnF3DRHaolgd2jXueCTZS28y+s=;
        b=Hr8SpoaLZ7Lz0qDcqou5dkoes4ErRRJ+K8lNvRtORbKGlkCsqVbbdZ1fk1FbyUw+R+
         Jj4VLj4nD/XG28qFZR4JRBI97vZ43kQzKgJjKl0lLWe0IkaP5OfkkbpL0GdY4OnfzJXs
         9yP8fdm2oRVrAGtpFCvDxW7AtgWI95LjZJ0pxXHgTkfyhaPuGdlWEHnwvBf4WHsEcaRJ
         ByHyh+Aj8XCbhupINYRpgXlEadTlkw38Iye78zcaCBjiDL+OTBPpN/VogKWQj53PNkII
         uG6OGubQ7Ejxr9FTAkhcBnAOsaEpd0xYZpNxbE4r0J8UBI88Y0No4V1CevFIqVeQugoD
         UXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756383414; x=1756988214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWyFqw/gsVVjjcdygtnF3DRHaolgd2jXueCTZS28y+s=;
        b=JJcFogZcO6HVUQ7ryN9RBi9+hfZ29zwI24zFKEWkDAvWs4HTxJrxeDjwTIV9hPcSAr
         7EczYLfxA7QwZ7DS8RPu9WoMKs4ArdOwq7b6l1yBxNWPWXp8B/xQPfHn6n2eVLQzIs+F
         whJX1lZPh77ChFog93bKu5LYEXJoqOs7YEVOKSG2VSesYWFv2OvEQhlm3Zh1CDV8l/GJ
         zCsX3cRDKqsPzFVLLME3BGzstTLjDM9v8HlmQ85xDfxg+Bw8D54Hdcm9RxZdkBGVZWDF
         9XEmEITsg/vd5RbMivOI/qhBTu51NHyu5q6z39NmQFp3t7kKiGt2A3Y9MMcFnLycHv7k
         DBDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/XmQPq+GLBdAGcmrvZIQBRjxV2YuX07koExOYzZGOH4a1y61tf29IDhePyXeLOb8a4GwKw/pYzQ==@kvack.org
X-Gm-Message-State: AOJu0YyJEBPw4VUvQ7IYR9Gug+jO828XtePK/esjgejq2J0gugHEFCtA
	efkOYlwtZKlwlSU9cKSKvTKuoKsK3ZtXsBCpFFB8yB5ZbRzc8eOUAowUUXv98hnWK/z+K+qNIDQ
	tghQ6bSQ89/HlS5bWCNS7EZdimFvv8CJsYbVGkSz7Bw==
X-Gm-Gg: ASbGncuA2VdzAneYNZTBezDaINKR42d1be3ycdveNeyXEw6fxcnvy6nR84msCUmqH8t
	aCMQ5DbWR6REj6+JPUlIC9jdv/4DiNmV6DPzr3z4XXkvM94GjUicN33YSHG+df/54qeHp+ck2WM
	cNx+93OMix3q0MTH6YwD8eq36Nx2qZl/IBTPwKMyuNL5UyZXMtuDllKhveyc52cUWoWo90g1Dlo
	56sH5xePRT7F4yEt1ykuIQeI9gRqH5Qw2Qxni3/0PegCw==
X-Google-Smtp-Source: AGHT+IG92wUWtZcOcyFCdpUJMrHneJ+aWHV8w80d9QUI9w9Y5DHiVSqiFDqmiY/01zWL3y4uFsiqXcDXjqiD4EO7IU0=
X-Received: by 2002:a17:907:c1f:b0:afe:e0f2:759 with SMTP id
 a640c23a62f3a-afee0f208f8mr241486566b.38.1756383413730; Thu, 28 Aug 2025
 05:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <20250827144832.87d2f1692fe61325628710f4@linux-foundation.org> <74a33635-3348-4e70-8cdb-16307f839b79@lucifer.local>
In-Reply-To: <74a33635-3348-4e70-8cdb-16307f839b79@lucifer.local>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Aug 2025 14:16:42 +0200
X-Gm-Features: Ac12FXw9QgQbdlF5-e3G7cxb-QUjEWwDSNPWlxAiuy_mjRV_rxmRxLRg7xFYSjo
Message-ID: <CAKPOu+-0zuz-t22RmENiAT7SXTMyRVeHgkCrnLK-Xt-DDxHykQ@mail.gmail.com>
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F60918000F
X-Stat-Signature: ehbu5pf1ds3xhj5eik5z3swb44wqejse
X-Rspam-User: 
X-HE-Tag: 1756383415-23548
X-HE-Meta: U2FsdGVkX19zDyhcMiR/yfyAIBV7QZ3wab5saDOn3nP38YfdBUiK7eExX8HEN/rH0VlxkiL4d6+/5HkzNgIP8YBemxzKVwkre6JKdbpt5+qNsbVqs0MrfGt1IMtkiZbpkq6qd6xWBzroxShXhyN4vs/sFwoJ+reYk9Jbr6F/VE88wIvgmxKZHd4HVvG9vttoN5eGmtaiP0QHs1St+CU/DgRFs0Kl1aZs6IKmocuuzuZFrzlLS15/fulQ0v7i5QB2bfZ3fQyR65618hcUg0bJ5xLnE96Df/3H7ibgaJ4gGD55vpuSdEknmS+kFHR9UAVvNaX/00DeCnYgy8LXql2A7wXU0zplOSSEQ/R9LS7fcfgqHOyT4mnm0oxBYFf2UuaxqVGo072Wq8V7b3h4LAIPghqAzHq3G/No/iFt2/3/ebU8kvPxfR94p5R7I4aNlEDOYaafsYLlwCcOMfyo3q7h37OuznpCXfzLGvP691oX1xlLI6FxuCxlLxhXo8Iv4tmIM1zgnxujmQyTyjWRtnM3/4wKoD0c97PhFenSra4VXKdyNyxFIHA11mTJcrEau9f+h++NDFskgHiGAyAWhR7i1KbT8nuuaiytA0CPR+xq818zzPsnUB+1bmHW9kixcWcaR3JCPm6XhGc0JXmQoKqf77/b7w1InILBa45+9uwE/Q6RLOk/r5MuSLve0sY+65R8RvrMPkn5o9R6CFmfTsprfzUIePbZeTEjN8jBgi8ZnystwCSr5chbjHPGPBHsOVg0WjSMjpGSxdgl1W7IIKPO/pX9vUq3qKjniPn3DNYFHRP1mE8M7yoWjlmu1/4G/lxwBP4n0sV6bhgxSzjp08erD4KTVpyheEDQYMDQVVBRoqj4BIRvrAvB3rbw1ONUM8hTwv3IAa2FlVAkULbK5NjB1jmgrOKeY32mm5OwqGuITH0KOco/4GathVarncZs8YegxxhK8XEwaqE9JOzbbPo
 7pSNpFYT
 cCHVwWamICgFCPmaBx5RuZAiK5SV6H4JMZ/QcNKo/vEB054y1vI7LKfSPDYm0dhmvigEs/rldytnHjLlVVhLEvh46GIVBvhJr5DnsFMEPgsHJSkH4cuHkLnYXQC7y52Lts1nHVS6+lkpvTSOvVF7N99lSxAWtkKAG6v+bSR52nvQcIT89Ic66m6YzEuNIDgjtC2lmgB5BUiU/u08MdEoDCKorlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 2:09=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:

> > I'd actually be in favor of making all incoming args const (C should
> > have made this the default).
> >
> > Because modifying an incoming arg is just obnoxious.  That value should
> > be viewed as part of the calling environment and should not be altered.
> >
> > Try modifying a lengthy function and wanting to get at an incoming arg
> > only to find that something in the preceding 100 lines has gone and
> > messed with it.  Or forget to check fr this and get a nasty surprise wh=
en
> > testing.
> >
> > Not that I'm suggesting that someone go in and make this change.
> >
> > On the other hand, it would be neat if gcc had an option to warn when
> > someone does this.  I bet it would be simple to add.
>
> This would break half the world, I've tried making parameters const, then
> finding basically every helper function doesn't function correctly with i=
t
> + having to give up without needing to change half the code base.

Are you guys talking about making parameter values const (i.e. pointer
addresses if the parameter is a pointer) or making pointed-to values
const?
It seemed Andrew meant the former, but my patch was about the latter.

Yes, making parameters (not pointed-to values) const by default would
be a good default, but we're 50 years late for that, and
unfortunately, C's syntax for pointers with constant address is
awkwardly confusing. But adding "const" to parameter (values, not
pointed-to) should not break anything (unless the function really
changes parameter values - there may be good or bad reasons to do
that).

Making more pointed-to values const will break a lot, yes, because
this needs const-correctness in the whole callee space. This patch
here tries to do this for a low-level part of the kernel, to enable it
in higher-level parts. Long way to go.

Max

