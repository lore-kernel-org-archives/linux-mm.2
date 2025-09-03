Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6325CA1011
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 17:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F438E0007; Wed,  3 Sep 2025 13:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3DFE8E0002; Wed,  3 Sep 2025 13:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54A58E0007; Wed,  3 Sep 2025 13:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A21F98E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:08:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7BE4C1A079D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:08:01 +0000 (UTC)
X-FDA: 83848571562.18.EF8C8BF
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 54E721C0013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:07:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XdFaW8Pv;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756919279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOy3uiI86tJvI7FGJoVOj1YT+P7Fnq5qQXCbIcfLxzs=;
	b=G5PqhycyyURdLpGRwWYnw6ym+KbLMIgM6vcVcDdb9806gj1d2GMeAxeg06Cubi4ikLiO6y
	YHlDLnmtq+g9/a/IY8T/6cNMjybqlDIeOlDxgddwReUbDk3gCZNzAdnbg8EhM3rsQ1p1rh
	szEVzwI1BjFl8JEl/ov1UItJtgdocqk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XdFaW8Pv;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756919279; a=rsa-sha256;
	cv=none;
	b=zehiML9ORsNhGiFXE8j8XxC329yWb9qb8Lxexx52qMCSl9BSiI+sUUIVCTUvEGeMU7CRJ0
	plRND9mNsG1amgKaIdZTOMc/TEqfUOE5h0yJlOsRN5XTsfBiPe5Y2Io9NDTcDrU7hkepi6
	tnScUPpBX25zlMrdzZEmY5hB+wDW4IQ=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-61cfbb21fd1so506a12.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 10:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756919278; x=1757524078; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IOy3uiI86tJvI7FGJoVOj1YT+P7Fnq5qQXCbIcfLxzs=;
        b=XdFaW8PvYPFDOxeSAHVTUvhN1qR1nHtuz+ROasS3HAF33fU7HaD2ScOt9AY96XuzQq
         cSRH3SO6qt/QWGJ6xf7pJNywzAghba0MODG80943Q8o0RQRMX7S18CdwPt8rp3pRxRGJ
         nn1qppOONJ3zzXe8M51O+FWhvV8NnHS0R5NxCL7R08kJL7lClRuKQjDVeek67uhnptow
         H7Kv9RA6BUJ/k7+Hz32+M2HJtaGmUQdgsDCcABjVsmlJ8GzfSPvLnXKrhI9KmLvIaE10
         RXDpj7i96WURd6Rlv9t87lwyRP6fLpkCsEF2bxmltPzPvQvfGe526TpQ61YOjwrVEcoX
         78dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756919278; x=1757524078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IOy3uiI86tJvI7FGJoVOj1YT+P7Fnq5qQXCbIcfLxzs=;
        b=iFy2XvD48s0coefoRqLjRT+su1xtLBNfG9PjkHejVaUaOlyVcY32wx1mL5Mth/Wgzk
         x5D9Yr6xCUaWMa3Jl7IcVQnq7+q1BkEsLb4uYw4h9hwvM5crfprGrf0u3KzKZs94jWC0
         Uxvg3NAZzucLlQZZSnKXv4B7Qq02Vnq59hIKDpdAnLd8gE2Iqz8kVup/dwZ4eV3OSZrN
         hFzMfEgIawnDQ+1DpU1K5X6XexNgMgp66/ZhE1oEBXbkfkJB56B0cEGwY5jCiOTBBvXI
         Tx2XnnFSsZqeiJ5Ncl+UmCK+P94T+HQksFEtRk13RS35puS18FoanDYY5Ks8nkrJHg3v
         0Z+w==
X-Forwarded-Encrypted: i=1; AJvYcCX3PsA7Fa80bnX2SXMR/Qu1Vz5CWdbmWHS0nbfZ81Got0JxmiPdIAE54+GxgVoIalX7bsqAnzW4jw==@kvack.org
X-Gm-Message-State: AOJu0YzWUcs5VoSbrLFkyvzWLJUx8oosPGYP0jrSlpdkol3yh0tRRc8y
	M7zhg+DSLvu0yzqwZzg2/2I/W5WdzvxABz/cRKz+rfQYJxHgIHAbjge0mmy7kXCYvLj5yWo8oF1
	MkpivMfenX1ra9cu1QB6YmkH5wJ+LZGT9fgCSM2GR
X-Gm-Gg: ASbGncth4iZEgcI4E+4C7yP0frBN8Y4AO5rUC6vgi0b0Z4aHJCT48W96eqMriHaYtIX
	TPd80XDJ/rmfadA/mQP6w4A9NiooD34+K4Z65BTdc64qgXlw6vYYLus8NPypPNqWTgjyYKI3PAd
	fOYl2iC1/gjFH9Qw3QlOgsuHp62CM6U9kvTt8ccJgccpuHPjnO9GK0V9em8RZlVXXGyoC88+xNm
	YonAmPuX4vm9sJs3ynz4jNKOlUrpr9upSsnSUrWUJBImUvl
X-Google-Smtp-Source: AGHT+IHychBkvK6ZWrYTnSznm3+l2PaQ1tnBnvAVllfrH2aL6Xr0iYBPC6W/1RSUT01Mb98+V7ZrDP+jMEOCDbAhs34=
X-Received: by 2002:aa7:cb0d:0:b0:61e:ce79:1da7 with SMTP id
 4fb4d7f45d1cf-61ece7935c9mr207979a12.6.1756919277446; Wed, 03 Sep 2025
 10:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756897825.git.pyyjason@gmail.com> <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
 <33E58899-F5E1-4E24-B830-A3E914331083@nvidia.com>
In-Reply-To: <33E58899-F5E1-4E24-B830-A3E914331083@nvidia.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Sep 2025 10:07:42 -0700
X-Gm-Features: Ac12FXw1t6dt4dOnQ8qWCWbnXCPmPMyQQkv__RxYXd2_GKtSxElsS5L9wHXlLu0
Message-ID: <CAJuCfpF1kKqjk44a0gZs0RLDnPEQS8LH_TgM7xu5BXwdjP8XFg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling before printing
To: Zi Yan <ziy@nvidia.com>
Cc: Yueyang Pan <pyyjason@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vishal Moola <vishal.moola@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xmh8455ez86fgq87ijci1hxpdxmjrko6
X-Rspam-User: 
X-Rspamd-Queue-Id: 54E721C0013
X-Rspamd-Server: rspam05
X-HE-Tag: 1756919279-41788
X-HE-Meta: U2FsdGVkX19YDusBHcyV4wAfDNmknO/7UlVID4IX1XWb1NfK5cjnNYL34ckZ5tjTdK2Zz2PQZQYprcXam1D0H6vMbyUJTpNC8Vv81YTwUnp7JIGBfKwFZnxdF5ZXRtVstM0Z55c+UZ2+9DiWcDNt1X+mONUwGsdJQYIcR++uUbN7tZAZ/xcpWBicJdDd8nMaQn/mUmhV5Fvc5LvFlpiUQaM+VJKDqDLc6VkRKBtBri6qByAJ+irnyVStgN8YZq5uHUDWt3h/7JXzZ0KFMONBQ1NotjVDMNyzg1oCh69w0B4PWez8dtIEhaK8hFv4FRMLSEwKidN7JgXJOYlXHfaGMxK8MGeuwXd2fhqTyZvLRnYtlZe7hUFB7yf1ot+x+uwsqJMYV9Qk6VIYhkiBNKjxic4LWtOBppSn9DtTQsLAHiBLny962F7iKGz/6AbPhA3Ejo9NJVa5QNa2VzNR5G+FAB8GPVm459x4eJnaN3vLDBr1rqZ6ZtsNvQNnoH20E+OJjYMvtarPIMtH4jjQHhFwSSGcSY5n/gAbRR3teNCa3Wg/ZfyOVnTq7V+JMJLFknJNjfFhQ8eaxCFcua4lDcRgXbVRvKlKa2X8oFqkXX1wT69r9SBbbcYouTTuSQ6fqWvikimgJzoJUmeINSlO87E/2UkXGntW4N6+jm1Hv8o0GgGw5ll/sVOe75pao7/fG1rzTvqUNVwA8xfg+x4Ouib/2/j4Lp6H4iSDQJYjf6sPKK0yuOyd9LXrYiOep7Y3WiE7ezKyRIpfl6yauhZa+p6sxrExHbEC1bhSFMFriasjz2S4L+nvly44nwiQzsCafcdDjNQ4WdPlubJV8uN6NlzG0jUwVL7e+ZnFfBdLvoq2fPUS7f1U/oS/KKE/50y0M2nkr4zFt3NhGdMG3WdB1n8ZrtS13KN8VXtsZC6Z6eMZZFOu3ytBO6egQUxlqovcuoioGcrNs1WRTs92zS3oGED
 VyhbCr1Z
 AxVZZ18HB3Zjjgsnijfm8okBDXawJ7eV99C/YAEc2UW1epyvuh3YPTnWCiO4b0Pj9gO3qxYK2VQfjyxD2ixJJmH15/b5BUqMT1bQtWbOCpCJAc+QreCZq+Xoog274xSgL+pB2rkSikOmODXP+7qHdc8qaxVi2Dv1iHfiLbxG/QgCf4HxMOsPS1chhURQRhKAjQ5620ptNMre06QKOsy86Jdj6zQU3CoRwLbzwDVaiiLojp8GgTzXihpxWaD8OJAuEkvdy00KU1Z8W3CttxrYa414sgNkN94gqjl7aidMQlvoTvJdwgMPOgf150KEdxQbhUH+QiRSC9GABrlTGUdXhtdsmxocFbbsYTWoybGfjokErkEWR/V5ExeCDBFMASUuF35Ld
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 9:29=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 3 Sep 2025, at 7:16, Yueyang Pan wrote:
>
> > This patch prints the status of the memory allocation profiling
> > before __show_mem actually prints the detailed allocation info.
> > This way will let us know the `0B` we saw in allocation info is
> > because the profiling is disabled or the allocation is actually
> > 0B.
> >
> > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> > ---
> >  mm/show_mem.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> Acked-by: Zi Yan <ziy@nvidia.com>

Acked-by: Suren Baghdasaryan <surenb@google.com>

>
> Best Regards,
> Yan, Zi

