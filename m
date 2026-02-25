Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D2F4FD377B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355E16B0088; Wed, 25 Feb 2026 13:28:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303196B0089; Wed, 25 Feb 2026 13:28:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20F496B008A; Wed, 25 Feb 2026 13:28:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D3166B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:28:45 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B292754E8A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:28:44 +0000 (UTC)
X-FDA: 84483814968.22.13E91EC
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	by imf08.hostedemail.com (Postfix) with ESMTP id BAB4D160005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:28:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gfDlO8J7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772044122; a=rsa-sha256;
	cv=pass;
	b=JsQqQhCFY6t5EQ8IYbdR9Jj8+NBNefQGfMbA4tu4DhJpdX6YPpteIUApENgb/osz2VLpip
	6D0G0/JhRJKamXW71djDIqjrzU6tPbBiBx48olMWR0GD8cwnN6i5xb3FunIukeF9L51ODu
	EkBCcJUHTc3HXGceZb/SQg+nyOX8nn0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gfDlO8J7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.66 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772044122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+vs7qWH/PosxazHRVXXbHEySPzv3IencMxP7YmTfGQ=;
	b=02jjHNHDs3F8wiLLBWKNRttVKuNRrcGE/cqBDCaIdBhQFC68qzFaYHxjaWccGwDZxbiq4b
	lmVcBr0QvbS/CZHhrcC14DeQGAA6pSZ0xBjw27/29Ft9sr7N8UlY5DS/TQOa4Bw0ysYZAe
	OV0lFBKvmxxdkenHLYluPEqKOsIdP60=
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-1275910b930so861639c88.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:28:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772044121; cv=none;
        d=google.com; s=arc-20240605;
        b=fl9B0HUWLcFAzt9SL3LndlducpcO80WY2G47dsbimgpRKqRAWqhY/tOEzHP2mYObAT
         AWI2CMNKriPyB7qxkcwRTlBHdhI5EV7HWIqtB3wXRcm+/piKijmq/Oi3dazJ5FMjLWVu
         Qt9uu2BszST8FGRZRlB9ZH4JBo/XkKbNbfdrJQ4x1YQroNE0ctzSL6PfH2kqNPCsiDgT
         HApxV1SNZqcbS9zxGKIiCei2CLFlzmu9P5K30ZNM2IazlMT+MDqPxxx4ZP+eJtVG3I93
         zyZ3QnWIInphdzgPK4SlrsWRNAFyzoO8EfkZSXOcYC2g+22nk+oI8uWhX5S16HLKWBVq
         tj4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b+vs7qWH/PosxazHRVXXbHEySPzv3IencMxP7YmTfGQ=;
        fh=TdI4LBPsKQ+J27oVrB6LxJDPEUTJmqjAw6ujkaBrN+Y=;
        b=PjXjS9HeXdsdKOB5iUjCn5j3XaCFm4J8DfWPRpYroG9N2UwZsxVyuSdhFoGL5jIISK
         SsFr4eFCSVH9VrH0YxBLlbr8Ke1yaxIzwfHM6FFHQ0fII9xAI2wtqwzG1aaSOqjrNksQ
         tTCPPyeC1Y8X6m/8jl+UD/fT7ejfgYOtwNc6kt+4UyvOn7bIJO3RhuAXWv3bcrizzNdy
         I8t7DSAqtwamHv4a317Qx/OYuujTgUrAV1FcyC64CZ5B9VN9CetfoMlkNOvk+jYVTFIP
         XWSlaxUTo8iNDrCQrAgZyh8OVPvjL+8wSuRRaxuTyLm/3y8/9o4zL3E+nAv6lKv0Xl4P
         lgTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772044121; x=1772648921; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+vs7qWH/PosxazHRVXXbHEySPzv3IencMxP7YmTfGQ=;
        b=gfDlO8J76WH2B6IgGwFgEHRaD2O9zZHiiEVl7ajOVWh9eVXhOW94Hd2zIQB+xM+cns
         EMr6YVZUCXjvAKxjHuP8eK2h3f7ALeYpGHYUiMjwnxEKxgobUyeP4mY2yLqCh/X2HEdI
         lM63EN3jrqGrxRjbDVVtV5Q6pN++fcTX9BF2jlIpaDj8MFDvQYzXjlNKq+absUb0a0o/
         9UGiQkp8E63QZA1F0g70AHY9ujpW/zetB9OooNDrC1mIO7YLiXTTvhiszyUQ9obMmzkh
         sdN2SSk8vMBFCUK5RIl3i3MfpC2YypyLEyam/1yiEJHlWsv06ZkCrP9JmRW50xIMlcoC
         VuVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772044121; x=1772648921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b+vs7qWH/PosxazHRVXXbHEySPzv3IencMxP7YmTfGQ=;
        b=UX7wGE0FKnPbVcfL0wHvL/pwPnNX1F0EOfaa0UJBr5g3grPeD/fnaIADho6j98KEw+
         fSzBRLBgpNeDE0VWfkpMQVMFB5/1LYwog10yqToTTqH14xH56AUhbRUtmgxfEk9KWtj8
         OgEVvKbAd4/sgVW01hh2xsMB6CXJQybSrO86f4Rdo/cO5BC2b8TOoj7UaL/UWQMkIqFs
         udTbQL43w1OuKyAQzsfmVUNcHVIAHPyhP5wlJRNa9ajwZvqbEIDxmiqyiHn0Br5YMNs/
         KwaEgFw/3VyQEnETKWSD1+nOpJuaXO3MHGi0VPOt4azNLBMn42D5ix5gJOSBS8U0V1Ov
         ORag==
X-Forwarded-Encrypted: i=1; AJvYcCUyAjgcd69hGChP20nuTOHblLM5Fw4U+ITTMCkERr3Q64p3hrnB478/ZlCieVYGfNoqX96QvFaV4Q==@kvack.org
X-Gm-Message-State: AOJu0YzPFOZWegie1Cfm9uuFQzCL0YvggwQO+NqncWrPQR2zcamgzHND
	mpRRZuozpqiqs6TwzthXiekYVEfNt0qVisxeUHExueo++tf6uVwlLPzsKOsOPjLWrnE9B8Z7Ho0
	rpahr94Uh4zOHjqhl0eJ7d2AjCFMmlw==
X-Gm-Gg: ATEYQzx3y4f98uFSpSfHnN5q9oSrLohRnFcGAc3Y7HfVnmUYdqc1ACa28Eik7IlUVXG
	WeMmdUQHuZBUkddQMsrK2j1Ze9kxPBXgGk25paqcwnffDX4VrAzs/7k87BX9TfmBbADjLDkgcDa
	79P6pNbxDP5SPoyrywS9gccKEmUrVoJPZvIRu07I86dW7ygi1SSaaOIXgeiCnRLj2UhvE5rj4gO
	XmJ1x8pWeTyawD+lZ4R93AuEBZmELDYsBFl0jpeSv/HjQsktd20oazYQTb2YuLFTQ/f7X+cUq/y
	pi05Ujc=
X-Received: by 2002:a05:7022:322:b0:11b:a8e3:847b with SMTP id
 a92af1059eb24-12789062f85mr18156c88.5.1772044121482; Wed, 25 Feb 2026
 10:28:41 -0800 (PST)
MIME-Version: 1.0
References: <20260223123232.12851-3-ravis.opensrc@gmail.com> <20260224015453.56879-1-sj@kernel.org>
In-Reply-To: <20260224015453.56879-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 25 Feb 2026 10:28:30 -0800
X-Gm-Features: AaiRm53PZ7CQTO2nNmE87UPyau54sbWlAb_SIOGk1iCbJaNIOH0-q30nKNVvXfw
Message-ID: <CALa+Y15BbvgKttRRxrNrr38y3Pt4A+MP8tfQZZ7LVyoUS+_0fQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/4] mm/damon: fix esz=0 quota bypass allowing
 unlimited migration
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BAB4D160005
X-Stat-Signature: cep1y8r6nghxsiun1w4hqie1jyebaq5s
X-HE-Tag: 1772044122-912055
X-HE-Meta: U2FsdGVkX18gnANysd3gPGXYw7MkZgqcyfzb3q4P32Ki9PolbyWcUZufB4t9kWD0vyrfLOcg2Ls99YM3or0OsriD/yZ3Pb3gq8OiLxgFRGaEGAs9wPJrjsyBrJnHLH+mcNzwW/VlxvZQfN9D/80Gc8qiokqG97t7d48OvayA16Y05z2CAlnKwfFWvlz9LyZNKyx71SiaG286VtPlxJj3f8ZQODsJDhwAyiayhvFHOtiS5O3cu57h8o3tnoJlpFpKJydIEOnqXw9sMFWtyMCNfS8TuDMHVy5Q66wCIbbtnle33XKwjQ0MVBnuK7xeXfR+y3PSzbXVZ9/2vUOl63vuRxUfPqRZ67V/MBLGiZmqTrsvpzMCaXBa4VZyzsbs98DBIG9nnEWTTgZvbYnyW4ikdLd72QnlaAGY/RkKN4so7RVa+vIv9YN2BhrpBbFRfQHBq301mcJfIYRJSXryUUL3QNvDX9N8+8ELKiP63fx4v3citzO2XLuf1hIbXAJD2RmhAEAzb69MT+jP2Yi0RUueXh9QFegj6M87NjXYYFinLrslrZWkxecwW7O2BpU9aLtkAmIJ428GZlrF+kj8Bp3kqMYr+YzJSlnSjvoHtMeiJALYH6vr2gZy/zLn6o09ofIY9snFb48oO6PPUXOrvYtTkrNj31tY/NIBp7eylvDUaYiPmUlr1dT/lmU4ZyZ3IhllFL9N/px9o2JBmzoteu+XfPrDCElSMs08RwcsOFRO5H28C/ugUXCY07BSktC5spJT9BEBYnXU1ixzS09xgNMTSRUwN58W3if+FgT9JINS9t+k5YGq+PyinW+5xyiKnajiIAwzUYiwbqsV5kTddZ6vDOOGgm43hco+7r5rK2VVGPCIWJ9Xngo8DAnbRhkS8Kxd9PstGOcEB+xyG3/44egY54I3KNxsDPqjQFK0cE26OQhjw6OVnaBiWHI7EM+RM7EssVm/fPgHl357txeasJh
 DUMKj2FK
 wFJ+HOfwasppRmQvo2qac+3hFAUMRRkDQa+AMpSros4c6jDl2ZZ4KfttKslUt+VqamaKg/ff8V37vBaWRCR6I6wKXidTU6N0+VBVOYlOExKavUI/h0mwhSIhbKWzirCSVUPDNJe3EsDKOhkTDY5DYxkFqV4XriPHm15dt9JylKMZdkxu41QNAQWSZiIpOJdu0FPVONrs5LFwqeYsTXCDsFJ0qyR7zgZPm7YHQ+BywrsNlF2wxvoxJcIJWgwevp4t9ZHTkO9rAC4p29l1ce7u/Sy7bQCpTAXljmLklwlKpA8ITv1KMpRhf+78WNPzdz5f30K2wA9b/W9C2HA4tpW9K+PdDe2EuRNes/whbXhwyhBdszblS56g3Mhkhql+IF8mwgBLy85mS8s5/siZGcXZJVFlQvEcInE3VzvybUrjHJ4u1R4KvCPRzEfCUBymd/LUCAB8QGYBzEa3HSb1VW1SETeAl7H/9GhzmQePmBxjf5eW00LwClTdjOxmBEmGMQtnAF8zDCLrpUxScyr1dTpg7trbN/7jaIdwUW+rkVR7ocD1LSD5Dravd/nLTZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 5:54=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Mon, 23 Feb 2026 12:32:30 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > When the TEMPORAL goal tuner sets esz_bp=3D0 to signal that a goal has
> > been achieved, the quota check was not actually stopping migration.
> >
> > The condition:
> >     if (quota->esz && quota->charged_sz >=3D quota->esz)
> >
> > When esz=3D0, this evaluates to (false && ...) =3D false, so the contin=
ue
> > is never executed and migration proceeds without limit.
>
> Nice finding, thank you for sharing this!

Thanks!

>
> >
> > Change the logic to:
> >     if (!quota->esz || quota->charged_sz >=3D quota->esz)
> >
> > Now when esz=3D0, (!0 =3D true) causes the continue to execute, properl=
y
> > stopping migration when the goal is achieved.
>
> But this code is written in the way because the current code assumes zero=
 'esz'
> means it is not being used and therefore be ignored.  This change should =
be ok
> for your use case, but could introduce an unexpected behavioral change fo=
r
> other users.
>
> One easy workaround would be setting esz_bp with a value smaller than 409=
60000
> instead of 0.  That is, esz_bp is the bytes in bp, so setting it smaller =
than
> 40960000 will result in making it effectively zero, e.g., like below.
>
> '''
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2623,7 +2623,7 @@ static void damos_goal_tune_esz_bp_temporal(struct =
damos_quota *quota)
>         unsigned long score =3D damos_quota_score(quota);
>
>         if (score >=3D 10000)
> -               quota->esz_bp =3D 0;
> +               quota->esz_bp =3D 10000;
>         else if (quota->sz)
>                 quota->esz_bp =3D quota->sz * 10000;
>         else
> '''
>
> But maybe there is a better way to cleanly fix this.  Let me take a time =
to
> think more...
>

I understand. Please take your time. I'm happy to test whatever approach
you come up with.

>
> Thanks,
> SJ
>
> [...]

