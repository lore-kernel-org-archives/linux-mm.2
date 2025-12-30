Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0EA7EE4983
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 16:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9966B0088; Tue, 30 Dec 2025 11:08:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258B56B0089; Tue, 30 Dec 2025 11:08:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193466B008A; Tue, 30 Dec 2025 11:08:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 041D66B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 11:08:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBCE9578B5
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:08:21 +0000 (UTC)
X-FDA: 84276619602.14.ACD425C
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id C7A562000A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:08:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LQB1hx9t;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767110899; a=rsa-sha256;
	cv=none;
	b=rdA/+vUDBjYe+wRLTe/7FL6ErZDFR2SibvWkLDDH6kVBPo1ZViVM96VMH0EFG+cAE1BDGG
	WQoLx4SF7CXjtjGHPJoShbUv/BRGXWQjX7cxTYa9XvmogkpC0+GuLbVHrx3exwTuCpaV4F
	DBtiR0tduAa8IFUXkhbF/Tg0tSZKawY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LQB1hx9t;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767110899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MgexQWXzYy/q8NUxWFpF4gA97o0gTS75VLANGn6UKXQ=;
	b=unm0ogdejXGkq+B7ARXbY7rp2d3wXdOsNNChFqQiypLRw54mlyOXBf8mjZbrMnHoO6Yjjv
	4ASWR6/IGnBPOGpZXCpCsuoyj1RmLO9VBYQ9AVR7xZ6cAIS8ndDJoCSXPzFZ0EhrtXKDpb
	XAa74+5udA42j4zv/bgGnVjaQ4ODZXs=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64b9d01e473so14197431a12.2
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767110898; x=1767715698; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgexQWXzYy/q8NUxWFpF4gA97o0gTS75VLANGn6UKXQ=;
        b=LQB1hx9taF+EXTHOE+hsSHWwyD6imMn5VpHynlXmQoUROdZGWoLRuPZT+Q8UYoM7ll
         Tk7ZGnFNtmXTsFxO8xF6ZHy0D7gGMK5lEb8uOj3OZaaRHFbHgXoIzMpLpxtEvw4CZ0r5
         RRsmlxHG5Wn7vQ065mxy7yyQQRo4+T79v9I0rQVVgZihVZt2wv71TiWstKCQH1xQVzEi
         33uoXzQ3HSxFj1/8az3zitIxzxOrlUvNIqVh7hlGitfEz1Ns7J5LIUj8JLBAq7tIbuET
         STEd3fouMuTeNJNHjJbBO+VjMvGTSsje2oOCJIly/l3D9Ces6cvMCwQC7M0r2OPZmwy5
         5zug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767110898; x=1767715698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MgexQWXzYy/q8NUxWFpF4gA97o0gTS75VLANGn6UKXQ=;
        b=EcIAXCSyMkjduhR/jVJFFeWZNK0jGN63Yzw02zwlGw02TiWjwjiOlAcvqgmjlywXeE
         ZaziHv4uXfz2L0sYjh68rNWhzbDwX0hphU+Lm/kZ+cCn9MPwFvlP9VM5Pdbxpo1W1syB
         Yg3WD1Qjsyjmr4yj35q0Eur0/WgHrRjwzKu9jTmWS8g8fNmz26lppZkFelcT8LDBjjGq
         J46PZFLcgC96q+6fjQRucYQtMR21HZ5ejSusn3TA2Sn+9bwT0xKssJIYksQVclpbr8fr
         W4SSz145LTTSytFAN2Fy0HXnKDjtltGsZCC+vFPUy5IA04SbJxMBNKmtQ/AJ5kwDEwtt
         LbqA==
X-Forwarded-Encrypted: i=1; AJvYcCVLJH7+mfaoNVb9Pz72B3bw4ZTvdZ7d7766KTS6taJEfvzv9yzQoK5rIJj/UvaNbf2pk9IMIRMl3A==@kvack.org
X-Gm-Message-State: AOJu0Yy/VkDDpbtZYmNdzckE160KZwZvhkIDPxoVAUOOvqLs9kOQa67Y
	Gb1o3Uwg8FZJkhM+ccNCMAeXo2WKBDH38cze+NlSKFUSUDLNEznvmNTVecBkzh6htCkx7gJxt/9
	8An8+mf+4VVPN0DnqdhLPRoiLx7/ZLdHV+Ziw8Aa3Kw==
X-Gm-Gg: AY/fxX7TU4pJvTsClpAI+TGeWzKr0n6G9okZcgi7CNIMWY/KZNXpamBVe0cPkviSmdi
	ZmnJYd4oqPcVNAAd0DpRwWEf3chcEzboEdXkxKlxIL9Cwkw+ry5vJhw6HjvSljWqA5jgnIN2vxG
	PJ7bt7lZV0FYggvDUMqxfsSh3+umztxqf8aYgVJiGp5Pb3cLa/xCQDby4funzIxUy2I1BlaxxSd
	RwjszD1kHiBmShUexWWPHgRPizCFV8k+JUVV5aNYDRfa+J+sAA1GERmdNf76unljNspzuqFRMIo
	to1dz8lGfukPXml5Df6v1c9B/Q==
X-Google-Smtp-Source: AGHT+IGH8tzcQMQAXqKEaFFOZyLtvKw6Uyex9gXbMJAc6alcdCSjFh7LplB5DxZrvhLv5oQKg+KsitWx6VKYZ1DwKFM=
X-Received: by 2002:a17:907:803:b0:b83:2c51:aebd with SMTP id
 a640c23a62f3a-b832c51d8b4mr1549186866b.19.1767110898203; Tue, 30 Dec 2025
 08:08:18 -0800 (PST)
MIME-Version: 1.0
References: <20251230145321.1512630-1-pasha.tatashin@soleen.com> <aVPwDdUpNTZ7gUT7@kernel.org>
In-Reply-To: <aVPwDdUpNTZ7gUT7@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 30 Dec 2025 11:07:41 -0500
X-Gm-Features: AQt7F2oD93nNDN3kLOZ5MUY6uCmx3RPfYz_XXSq3rst8F_oyqwo6uFtt1rCm5ZQ
Message-ID: <CA+CK2bB_7vdtWt9cccV2icV2gdyM5UaD=BnAOhWnKx9WFKWSUQ@mail.gmail.com>
Subject: Re: [PATCH v2] liveupdate: separate memfd support into LIVEUPDATE_MEMFD
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C7A562000A
X-Stat-Signature: h87au1bbwfzj3fr5piku5pzkf9bxzfbz
X-Rspam-User: 
X-HE-Tag: 1767110899-569763
X-HE-Meta: U2FsdGVkX19ZAlZuiAN48+nsBC+ih047WhNDhvHcB4+p1JASTCIHnNBsOulceS5PcunmLFmIskgNqxAP7wjvnvgJ9am0p0auBWFI2cwJK9c6D+vBk5wmfHKxqrorlfFtWh9Zel+BJI6EN+1b1ppUt6kktTZDQF+iIeCwUDLco7l7YAzXuqiTfpMiqVNfxtXnz1ocwq/JSA3PLm+oc6KmGDh6AGdCGkcphMRmwr+D4Kql6GQGql2skiSJfmDhkbHEKRR5ojn6bzxu8HTQmdKFOfzAwOyOmOTMJ6xz8pFDssTEMgEnMswD2F0zfaapOX1JkdOc7LOUS8UR3TP/SbrDFJJz9jgmhfaedCWs/Urem9mJDahMDuygAced8SpGX2LAZrcCgshqlORITMs8SvFUEjTUTQnwtkDRw9NcnwGA0rmWVERuyZW2dBr5zinrvppd//ZDwHvMe05vjarZVolHn13iqmikFUy0g9QElwb7sJZGeO+pD7Vk19VS8GKtPQdJa6sTnommfLE7W977rAWhuy4EMhIEEOAuhlm6pqIeEXoUwTB3vuQGG7vJaFyMkLSbgBug8F/8324xLx7XIHavR+4BGqu9Q10DZKIawE8Hl4YBhuWolkjBcaQXrmk3HQvhrd5RNq6FpXz87yM3jSbbeXznqWphfIKYUjZD8V+fF5ssTNiPiqb5tHhYxcFX/9k5Jzz5vEswa8jhE4nAaLSd/Zt6Il8jwPKfeOMExfRcgGXmLHjxKwBaihs5QO2erTT56kG/vsBHbfQs7pAJnUdceKXD7h/TKyrv1VmKPwuAtg65CMjun0QchyBYogEDyMM3nq3gfYuCV+w9hSOgVr49qLKInLkLftVcGwOjjdBXwGEG3KrhQlkGgF+Xm/P2QL8wdIOtwj9tNWdDe224KQeUyEtQmUy2hQVUHWM0O4HcLYKBOQKhaTZn6yMBdIrSQKD2xwTA3+OpA9a+7tlBriJ
 SIVS06Oj
 VsZND7Ejx5DshdQf/ANh2FIwX5SEJ2hsKploWnVy5Z+nCSaK4HtuaCPZXFafizDF62OkQGay2LAzVw8PsO+OBBnc4euNJ5s542+7+SQ1/j/sQU8h1iZoWlmohYVaAhvHvUhk3RYNGgg8aCeVxfGI1vH0Nv8CpzPQLaqVvMWfUMDE9Ht35+hboV4gOdmxBODEeXWXMwsq/QjM1tQGsljNbK93YfYpV95lBeflnLpfSYQYDAGBJ1eIjDhYyX53KdgNytlieGigiev9+hoWmb68lKhPwLYrKXefulyzBKqxp/UxO+4jUPYQgu9GV2FzhraADoeO1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 10:30=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Tue, Dec 30, 2025 at 09:53:21AM -0500, Pasha Tatashin wrote:
> > Decouple memfd preservation support from the core Live Update
> > Orchestrator configuration.
> >
> > Previously, enabling CONFIG_LIVEUPDATE forced a dependency on
> > CONFIG_SHMEM and unconditionally compiled memfd_luo.o. However, Live
> > Update may be used for purposes that do not require memfd-backed memory
> > preservation.
> >
> > Introduce CONFIG_LIVEUPDATE_MEMFD to gate memfd_luo.o. This moves the
> > SHMEM and MEMFD_CREATE dependencies to the specific feature that needs
> > them, allowing the base LIVEUPDATE option to be selected independently
> > of shared memory support.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> > ---
> > Changes v2:
> > - Updated testing config
> > - Added review-by
> >
> >  kernel/liveupdate/Kconfig                 | 16 +++++++++++++++-
> >  mm/Makefile                               |  2 +-
> >  tools/testing/selftests/liveupdate/config |  1 +
> >  3 files changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > index d2aeaf13c3ac..9a1a8cdcf16c 100644
> > --- a/kernel/liveupdate/Kconfig
> > +++ b/kernel/liveupdate/Kconfig
> > @@ -54,7 +54,6 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
> >  config LIVEUPDATE
> >       bool "Live Update Orchestrator"
> >       depends on KEXEC_HANDOVER
> > -     depends on SHMEM
> >       help
> >         Enable the Live Update Orchestrator. Live Update is a mechanism=
,
> >         typically based on kexec, that allows the kernel to be updated
> > @@ -73,4 +72,19 @@ config LIVEUPDATE
> >
> >         If unsure, say N.
> >
> > +config LIVEUPDATE_MEMFD
> > +     bool "Live update support for memfd"
> > +     depends on LIVEUPDATE
> > +     depends on MEMFD_CREATE
> > +     depends on SHMEM
>
> Maybe also
>
>         default LIVEUPDATE

Yeah, I like this idea, let me make the change, and send v3.

Pasha

