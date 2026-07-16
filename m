Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62ACFC44501
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 00:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CAF6B008A; Wed, 15 Jul 2026 20:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08FC6B008C; Wed, 15 Jul 2026 20:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3C96B0092; Wed, 15 Jul 2026 20:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4696B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 20:12:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34AB9A03E4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 00:12:55 +0000 (UTC)
X-FDA: 84992714310.03.BE04FD1
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53793100002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 00:12:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ml9f4ViJ;
	spf=pass (imf14.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784160773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yqp9M8SmLPe+XpZ6WaehY4883xFTw01pffMOJV97erU=;
	b=5Fhk3xcvuOVNehPRZWEDc1K53O+oT7+xC8ZHj1uE8vZyav268Wb4VUA90pEAzA9KHXflYx
	df8mRbru8UlGwWyuYMbfMCWl6/Pi0j5e0oZUZmHsUsOu3QMekeU4+oLjCHx7bjKWO1IUoi
	/AirGQrsoVmI/rIU+/BR54lLsgnyLiM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ml9f4ViJ;
	spf=pass (imf14.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784160773;
	b=birBodDFLsZO5OOptp7xt916j5/9yf3zzPCYJ+ZTU5R4M+KLKRDcFPE1RphdZWZ7z6b81G
	5m5EpAjtQpOX23oqSvEgtzWajXsFXCnmCeBdGonh9kehu3lQd250Dc5PockkaOXZ5dTz8v
	G26okCJTyn3ax0YKaf7CAQv0i2btQ9Q=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ca965de53baso1567364a12.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784160772; x=1784765572; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Yqp9M8SmLPe+XpZ6WaehY4883xFTw01pffMOJV97erU=;
        b=ml9f4ViJODs/9pO8OeXGJXS6MxNHHU6fhkaYtUaRSOtSPkEyAUEQQdpv7121eT7l9Z
         xVK5azH8r2ht5EVRDhzVajRZw/IZSzicnjmCqTBUKswGPQt8qDd643G+L/LeEIILhsfQ
         0JUp9pLKe5biCjW70d/bIxU0rRZr62pzEjO4QHcEYNVtFnNXzI+SyXqcUDADfk3yoPQU
         AjqJjoIh55bcU2257ZPztOo9sFyWBYGhlxgEbgGQfvgG6wlGG0jNcq0a8az0THgWeCKm
         6LtesqRztW6iKHrGylDRbf5iZcsf05oMVNQPzd6SKc8cND4657TKDQ9K17JNOzBqWj0a
         p6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784160772; x=1784765572;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yqp9M8SmLPe+XpZ6WaehY4883xFTw01pffMOJV97erU=;
        b=mpfQ67do27nErAe04I6aRKpvktoEEkCaSDPyTfRGq6xVh4QNn8G7Mo0D+LkxXEe2ST
         CxbQEt6tUKI8HMg6IYgiWZ/w++R577Qey74ZuQiJXMZDrLtl1QzpLcVaFDNHbjXsph7e
         6GWm/c2MAw5zH4KiVrsMObXJwxrmLxvfzGuGyT8hFWzb0JOuvoIAsa+Ohiyv8ulYimEs
         9HaxufKM4sDJJrGi3qxRwppKI8juYIsSQogpftkf8rsST4lXqYEXsd1Jsx/SbPKWBcs/
         wOpg/llA26m0cE36YIKlY4Z+iVTeHZmQHF6zte+RFFl2wJnQIkUtzEYi2lX1c72qqHRM
         pNFQ==
X-Forwarded-Encrypted: i=1; AHgh+RrArj14PNPvZScue7YFy2yB184axRFO8e+uOYdwS9ITiSF+Ynn0tVqslbj+na1kRqpGsqdCgaQYHw==@kvack.org
X-Gm-Message-State: AOJu0YwfDpE5bUbD134kmtsAZ0zjdp6NOdGsV0iVaF3YDkuC1ZUj9K4j
	hipsugEAZVnlNz5iQi77l7XWMVziRh6eJ/ClND8kASU+gSpjamgRNe8M
X-Gm-Gg: AfdE7cloouDoJHHLNKHsplqMNS1tjG4rAgY3+NXqzT1u4Q8Vamv7rnNcA7a9nfHL5+g
	5+L4NH1oH2cGardNwGC+/qS+oVGZU6gYY8SFcZmPOY0+VwLoLMjOkP/+gXSeGat3CEhOpuXyOkZ
	TjVqDASnnDGW6R+Qly0WKldXgLbSd+yYjywblUD8PQTNjZuz78vkCMhUuzeI7q7qM2ZtgOw2HRZ
	KhKGLpFyNaI7rmw+mC30Dhjl3XKaZzyldpwtWN/D6Pbgm62F6gyzRCt14meFNPelTcJFXcRSHQh
	IH49exwU2Ck5mAJMQAdY0nLsH4BUiYQNN5B5h5/rix399IMZXbbjfcL9SyrksJR9QJWf91bm7RX
	hcXpBCpIq/92cGRClAd+cw3XWFFpOEHVWHaerVlwIb1q6JcGA7iOVb226cVBzUU2Yyy1dPsrfQ+
	lIukAgsn9bTAYyCQ==
X-Received: by 2002:a05:6a21:1309:b0:3b4:b24e:27b4 with SMTP id adf61e73a8af0-3c11077668bmr21904263637.1.1784160771979;
        Wed, 15 Jul 2026 17:12:51 -0700 (PDT)
Received: from localhost ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd4359166sm4828005c88.14.2026.07.15.17.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 17:12:51 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Jul 2026 17:12:49 -0700
Message-Id: <DJZK7IJ53B5J.141W232JLWL44@gmail.com>
Cc: "Daniel Borkmann" <daniel@iogearbox.net>, "Alexei Starovoitov"
 <ast@kernel.org>, "Kees Cook" <kees@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet"
 <corbet@lwn.net>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <bpf@vger.kernel.org>, <jannh@google.com>, <mail@johnericson.me>
Subject: Re: [PATCH v2 0/9] binfmt_misc: bpf-backed binary type handlers
From: "Farid Zakaria" <farid.m.zakaria@gmail.com>
To: "Farid Zakaria" <farid.m.zakaria@gmail.com>, "Christian Brauner"
 <brauner@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
 <178407531866.2243172.12944140194021045628.b4-review@b4>
 <20260715-reorganisation-umtausch-radiergummi-8b38ca81ebb0@brauner>
 <DJZK5TY3IXQC.2XKA1X9IEGJDO@gmail.com>
In-Reply-To: <DJZK5TY3IXQC.2XKA1X9IEGJDO@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53793100002
X-Stat-Signature: k1qbpip6z3edz3p459wuky9377tuhnxt
X-HE-Tag: 1784160773-57545
X-HE-Meta: U2FsdGVkX1/xwPZR/2rlbmbEmMOYCVkSXobGT2rOieRfbHuSLhkq+whcPryqBtVUcxME+AWJr2KMSxFShrjUPoYaTKslbrYFSwhN6dRLB8yuwcUSlZYLVzfwrCXPUdMw4LRPidm125lqNduJ+6SiqS/M1hnaEcb7hYSkc9xUaK7tnHrl3Zjt8Dxc4cd3Wr+3zxHsbo+L6oYEy1o7MpLvOLQJQ4CcAR61xn7EPZdrLwtbPNeklPV5eHBjDLLd8kPF+BAXeTfuPOGhHQbUOKL6OVC/t1uED65gnoi+5OgDv/OVFaUOnM4aX71H06xE2ypEswYiwNjsGZ2qIkXdF4gP+jNVffrkJmM4zYYmTk7FKA5cKHf/8Tje1OiMdM/yaXmSxqhu+nbCh8z1cbCPvHbMl3StR5cAJ/EVHNiC1cI2AgZgk/1CPOEVfJr5EK6drR9Iu8wHb4MwBYe2iA6zEvo74MvofvnYJ5qpqbQkLO91RkSfSDHv1l8VF0zDrjY+TXiilrt5/GPCrUmJesC74mwezmHwLzW33/nOrq87dQ7vWhIHhjowMy3kOrIxSgvH6R2mOqKHYEMaEGtzHidxqFueb60NWRGR1PH3oPnvX3nk7wPVHE9IWKbRIyiOWMTztUKN3S7P36wByvpphXJk2ihcMLQOZGR5pQvwvsSIFZqCRFm5k13NRfFJxr3U07z5UTpvPzQBpEHX8WSdpRXKTk1R+Snl1Az+Oe6YvBLv3M5uMEDRzZVFs2BAkPtcfwVuuXmr4ZEq/8RjmPnYSq9/YJnp+9Wxhp9VyadqMF/oWtREqyZlWSRUfe3rIWbj3mcyTGM4GHA1FF+VOtT5wWmAExKVhbYzHDa3a4nZvrcQuSnQKZcD83aCv3z6r0e/h3E16oxbhqE0ReOxSLkcKeYlGfYN13+ioRx8PGilxuxfpu4cOSVOI+N3otzxeF/cHGIgu4zgHt8CqdEXOZO016fgOb4
 u/8fdOQ2
 yst8J46MdJiSinFva/SMJmXdxcLUPI5gJWm9WZaJZCsWKHWA6jDSoi4zHBug7ZSoDm0Kfd+Lzv66SmpSGckslBz9Sr24pIv7+nwIqlgdxPOwSd/GWDcXtuSbedCQt+b2cnTEwcL7DJ1MWu7Olw4cVG/jIcqcWmUsZbhVy9SS1Ms6TRxEfO3viKVLBh840qrMx8rWva2FSEeBLxDBnQ7xWxTwxD9mwZMZx1xwUV6HEy2r86tvO7KRnRWS3tZeQtmdd41IOrmoB2dymZkpM69Als1URKfuYqgNRO0XMAIzPVzA3Wu45yU4drPgRLZrMirayEfodco9olnpWdsUHxqfbS6XwVdT/SrRMznF0modS6PImrrIUdP07tW0zNgutDLfF35tQUqJc4oxczFTP7LhILy/GjCOyekkQIL+ytpqq1z9VHNICqerTkAKvI6C6dw8VwijL6gbTrsRcrOk+51k0DwmGwYRs68cvSzddJkbmnPFmfMAkOy66DODuz0rKHyFjZr0rVZU11jmv+fNqo1CYqWAMu5Or03Up1CwMFg5N/gQUyBQ2ZiUq1UpJwWneoRqyIX4JDRHxXXEabIaLefNLwsSH1Op/2GX7lOBbXz7TJWmDBZuDeDrodjMbug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 15, 2026 at 5:10 PM PDT, Farid Zakaria wrote:
> On Wed Jul 15, 2026 at 1:40 AM PDT, Christian Brauner wrote:
>> On 2026-07-14 17:28 -0700, Farid Zakaria wrote:
>>> On Tue, 14 Jul 2026 21:58:05 +0200, Christian Brauner <brauner@kernel.o=
rg> wrote:
>>> > [...]
>>> > 		.load =3D (void *)nix_load,
>>> > 		.name =3D "nix",
>>> > 	};
>>> >=20
>>> > Farid, this should slot underneath your qemu demo from [4] with the
>>> > program ported to struct_ops. Feel free to take it from here.
>>>=20
>>> Thanks for the recent update.
>>> Is it still "take it from here" or was this left-over from the previous
>>> series.
>>
>> Leftover from the previous series. :) Sorry.
>>
>
> No problem -- just checking.
>
>>> I think you've done the majority of the work here with the validation o=
f
>>> the few selftests and mentioning the gap for shebangs.
>>
>> It was a nice joint effort imo. I think this is in general an
>> interesting idea. I'm also working on some glibc loader patches. One
>> of the patches in this series allows for "transparent binary execution"
>> if the loader supports it.
>>
>> In this mode you can pass AT_EXECFD to an interpreter and don't change
>> the command line. An exec like this is indistinguishable from a "native"
>> exec.
>>
>
> This sounds super interesting (orthogonal to binfmt_misc and BPF work rig=
ht?)
> but a neat feature nonetheless. I wonder if this makes it easier for
> tools like perf to attribute the correct binary or they have already
> handled interpreters in the cmdline well enough.
>
>>> Please let me know what you would like me to do next. I just tested
>>> reviewing the series with b4 + AI -- pretty cool. Was a little clunky t=
o
>>> get it to work but overall a good experience. (I need to tinker with it
>>> a little for NixOS vim setup etc..)
>>>=20
>>> I shared this patch series at my workplace as well.=20
>>> I think there is some interest in the work.
>>> (If you are curious as to why, I can elaborate on that as well).
>>
>> Sure, happy to hear other use-cases. I have a plan to make it possible
>> to pre-open a set of interpreters (pin them essentially) when
>> registering the handler in binfmt_misc and then bpf would be able to
>> select from a set of pre-opened interpreters but that's for the future.
>>
>
> This is assuming that in prior calls to the BPF it returned the path
> string to be pinned?
>
> As for the use case, we use buck2 --
> a build system similar to Google's Bazel and does many things in spirit
> to Nix by leveraging RUN_PATH to create links to the shared-libraries.
>
> We have customized our interpreter however the lack of $ORIGIN means
> that we've had to maintain a single glibc versioning across our machines =
as
> a platform since glibc has tight coupling between the loader and the
> libc.
>
> This has been a pain point for upgrading. I think the ability for the
> loader to now be relative to $ORIGIN meanst hat each binary could
> diverge glibc/ld.so and not affect the rest of the machines.
>
> tl;dr; ld.so from $ORIGIN itself is not only useful but since it's
> intimately tied to glibc, it allows for more flexibililty across our
> builds (very similar to NixOS in spirit).
>
>>> I hope you are enjoying your vacation.
>>
>> Thanks!

Ah one more thing!

What's next for this patch? Do we wait for BPF maintainers to comment?
Should I continue to add Reviewed-By trailers to the other patches?
(I have limited knowledge on some of the mutex stuff but the agent
review in b4 was helpful in understanding it enough to give a review.)

Sorry if it's obvious. I've never contributed to a patch this far
along or substantial to the point of having to understand the
merging/acceptance process in Linux.

