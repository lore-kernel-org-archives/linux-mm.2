Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95B1CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 10:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19CB06B0005; Mon, 25 May 2026 06:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D946B008C; Mon, 25 May 2026 06:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063396B0093; Mon, 25 May 2026 06:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E83BC6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:34:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92336140215
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:34:24 +0000 (UTC)
X-FDA: 84805582848.19.38C4489
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id A307740012
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:34:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UMdhuQrK;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779705262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANTTltvHrc5c1FeMjZzkkc8QWIGg79MSqFOZN/bt4nE=;
	b=WYTnb3Y78SKf+cD9ERcQF8fFOYToIDxRWTrt+8yd1rZMeCCsAGAO6FZ05QcIkBVr/3g73D
	Tj++Wd2KoJr96EQ9WoeT9Dr811rMx4yAawABOr1slNP1cU9wAoHzjC0c7sJI45Sj0EDTFL
	8jdZsQlcL4cArRSc7da6tgDFJT/nnMw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UMdhuQrK;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779705262; a=rsa-sha256;
	cv=none;
	b=phkt2PUNoOD8qMB52cWRJUq9XI+bslOqa22PwOBxJ3MRjiJYDHluBwpWw1+fZQktMnHUCX
	xAsQt0RB3Qgxl/gY8l3wBf4S5ivRwjV/a33jRYJ+fb/xjU8bW8oNUJK+PzyOzKQE+zPGyP
	NZugTZTs7Eas0NqH66tCxyFEbx8UaXA=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4906238c62eso8826795e9.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 03:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779705261; x=1780310061; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANTTltvHrc5c1FeMjZzkkc8QWIGg79MSqFOZN/bt4nE=;
        b=UMdhuQrKmjrA218cy3bH4tcbGkOhjtmaIu/nElcPvLTkTy5SGoTJhMgquM41hriZhA
         M5KDIoScDNRCjszcXrZqoSNJFgcxI3e3UDVaGG6inWHNCT/my8r9mUwKoQStbc924jS0
         Y1XIx+3vVvJcq25tCZUM8DVw/bYIMtTRSAUeaBLHHbB/qp+WaE02Nz1AWuPloieYP+PQ
         hMU/vXud1xeB5HDxJsmWoI9xwiPT7NYDZVdUyWpUQyuut8ggXhY+X6DqZWGlbG/QTckv
         jeeI3IMblPUgMXp8ttaBIm5foC60od5lQDfS39CcC553aCc3jQmsSHLXDabSe1KlgQXM
         ktUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779705261; x=1780310061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ANTTltvHrc5c1FeMjZzkkc8QWIGg79MSqFOZN/bt4nE=;
        b=TQb9L4HkFNMDLFTlkeLF/Th0p0StSiPCss9O7VDp5T35gR2Ht0MzfK89i0YtoDYsPn
         GVO08DVUkw/guLgiBXOYj5a4A1M6iSVbVACN0o1osgP2ifxoTwcT8VkHbDJaLoBab00G
         htgaHKafppR6CjsIwQfPyrTDcWyWRllb/NOcJ+gAtw05+yVQbiqkj5toy1SOS8WJZ7Sv
         rcQUGHPM/3N/uZtBdmjwIgHU7iE+qD5Da6NyIU7M9MZ7DRYbJfLQhUYgjIvYjxzUv+lh
         BdaAe3oo7+gGQLB3rzpW29Eh4D9hQtNZDHf6cxx8NwnTai4mx0SEspzObpUZKg7qGuwu
         aN6Q==
X-Forwarded-Encrypted: i=1; AFNElJ8oRDUhsgkK1/LXaO/bFnaceajdE2TT9z06xLA7rbQ1/kNluNET9YfvXoAmB7CxAmHoUEod8Djgdg==@kvack.org
X-Gm-Message-State: AOJu0YxLhuDNP8/9Js6j+3IQefidRpQbgVRNgQntSmJ/NKNNgvVLEuwb
	xwjKM1n6KyJ6wrm6mJg2sjWHL/+Dv6jojOxNSeHBeLs7F1HWln0m9rhS
X-Gm-Gg: Acq92OGz/6gQdOPPmg4Pd62en/xLxaTaMtSCU9+56Y587kAb6T8QRdGZ5azuUs/5m+Y
	nUEPta+05MqOQapvVAJWuQZ41FAycqOkBwdayQ3cRwMoAgPfP3cIABERmNagfq/s6ck8Db3wWym
	kNQAObhUu3lstWpWgjO4Cry8JWheuRvG/P7xwSKd2j8YmAOq8hRgc1FohWxcvq6WfrQUEVaZPDM
	k77n9GpNKgJ+PDB+JedWS5p6xrB2/VPWcGrpZx/A21XRWCX/1/ueBodXyiQDoV0aP4MrSxiJakv
	MqwkU+A5ufNHRiBzhFSPwcqv9LPWKG9wUWHAky6jrC295S05lS8K+EABgOcpuiOaRxEBZHlNV3p
	syygVWV2vbiiot7Lay5qsmCTRWp+kJ+zzdcmn1q+pbFZjI4Srvro523/7LXSqQ6qokotVW8u2XZ
	cnqtecaMR3K7fdjsMcB1D1fy4DeFuwqKyTFenvIZVlJo3PyxOijUWS4//wqq+u6zhY
X-Received: by 2002:a05:600c:c4a1:b0:48f:e230:2a1e with SMTP id 5b1f17b1804b1-49042ae7881mr243970285e9.33.1779705260735;
        Mon, 25 May 2026 03:34:20 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm25157564f8f.30.2026.05.25.03.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 03:34:20 -0700 (PDT)
Date: Mon, 25 May 2026 11:34:18 +0100
From: David Laight <david.laight.linux@gmail.com>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah Khan
 <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>
Subject: Re: [PATCH v2 2/6] treewide: Get rid of get_task_comm()
Message-ID: <20260525113418.032bd1d0@pumpkin>
In-Reply-To: <20260524-tonyk-long_name-v2-2-332f6bd041c4@igalia.com>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
	<20260524-tonyk-long_name-v2-2-332f6bd041c4@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: duczm686epi6uobfjy8ar1izzrosjyok
X-Rspamd-Queue-Id: A307740012
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779705262-137681
X-HE-Meta: U2FsdGVkX18xqxY5IMOFV6FvLFPoF8wTSGYDus14kfnmVWq9moKadgKKWLyLfwuRhe5mwxH0384WNxbfYkF5wufntChMKggUDTqCIX6VLF0Tpr8ZWP/2bSdFkUjfP55tolDmRNijqP1D1pmtuWbiFZWrnJLf3YQAHOL5+f3RnpW9cwU95e64hp0atZ9Pa8DGBUs869mkeLu0ZvZ8nX4FtyNSCd0RA133xtEj8p3dnjUj4HOKcvEXsmYdeb8PFfIeSRcbu6hg/MeEz9aU0a20V1QC/f5EkKKwwfgPeD2JphFp8jXlblr5Mn3uDVTiePEDdkzJ45J2kan3BjU8pmc0b3NrgLP3IgZpbCzzkbvVEcHgwC/sQq/XEvPqGLWISrUDzC1tcOId1QdRulD5Pmgx3aqtCz8RHWZybtKsk1YEXtoeJDI9r6aI7KvJY4hmdQWiYgepqI/qWdgVlbDgvOkIOv+5SdkY1L0hfna9q0aSVul+mdknTrDzI4AphwJfO0KklP6dOOnRiK9zjm/HFnhoJ29qABS5eG42+RhNv3wRNRab6BCHnmkRLSoIzWlBXZ9FLcxncjwoitqm1DfmhVeglPs/eul6BzWtwyaxr84HSoApJxoABoBLQTWJkl9bRfqTlHtUrbkDsIzA1o8fqiO5pbYUF1MRhNLKR+pIDdslfcHCZoD7FOIf/ShXyCcvXYH6xU5rM7+oJ6KjupT1yjInZ6NSZc15RQS+RiY5Y/sicQuuaysXecQFpLOjQtDB0rXI4gnVloO82NGdyWUP6g5qneCYGMkAYwqwVZEdfwhEbFIBHuj9SNpd7AfGbBT4q8JkzyC5oZ8xuY1Z2BUIaqX3ptt0B8x3ELGTvcja5AYpwAIZdAt7sgQI04G6yVb70v/jsQludTdFLS//GWKNdbLaSigi+QLixSvH3nzDxWYudH4OOTEtm6XWqPCPX2SiveffVEYfIcL5ATPmVFkTjeb
 ZkOsARNh
 YrDqzoNjHld2KjQrlYSC+Ct1V2gVIfjTtJNx4Yxe/5bfyxRyPXxz1WzC88Dh/p3O4JmC2OarQNhHvKw6EDtpxWMnONigWcjgkqJCP/863745OgTsjrmwiydqnUzqG0E5kjQYrBxXwb4d0tlICONk5tFDqXY4520bFBp85V9r7STBWseUD8+fUZPDO7oAaz7x8tAyyGixBfVnGRCmNGi8tfSOlw0ZtLC7ubBGCfhOY7JIhK/RGUKeXc3q2lHupBgrhcSEfYF+a/azP/8ybPx6EiF7JwnLNRxKrfHzwlElIyWhfnIcfbGfngSNgo97LtbKku7egNEDaGgKKNgrDOg3VZ2xWFY1c908ynW/M1O9p3SFNmb/KpOaeTGPqhYtQ8MuhCOhbGWVD2BaAB1FA5dAVyQLEK012JbXgc+Z8cPaFrCL9DCOKpiMSC20nAxHq69o5STq9GmrhFjpvFqiJo6eBX4r6i0mu8Apu0gEesl0FBOGApiBzJa57mf6Ke8MAWRV5ITGs9R2S+D3kb57iJyAClprc4KIpqeU1jDVc5k8BokxPchhpfZ6sHQA8swuMcpAyJ+FgmmIyMKmYpvrHVis+G01UYVfC5y1nJM4DlzNxBJjnRzOaWFhAT2tC8puuCnq9QHZNwQhUXxRYByrLUnqR48K7hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 24 May 2026 19:38:52 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> Since commit 4cc0473d7754 ("get rid of __get_task_comm()"),
> get_task_comm() does just a redundant check for the buffer size and call
> strscpy_pad(). Replace get_task_comm() calls with strscpy_pad(), that will
> do the right thing if the buffers sizes doesn't match: zero-pad if it's
> bigger, and truncate if it's smaller.
>=20
> Link: https://lore.kernel.org/lkml/CAHk-=3Dwi5c=3D_-FBGo_88CowJd_F-Gi6Ud9=
d=3DTALm65ReN7YjrMw@mail.gmail.com/
> Co-developed-by: Bhupesh <bhupesh@igalia.com>
> Signed-off-by: Bhupesh <bhupesh@igalia.com>
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> ---
...=20
> -/*
> - * - Why not use task_lock()?
> - *   User space can randomly change their names anyway, so locking for r=
eaders
> - *   doesn't make sense. For writers, locking is probably necessary, as =
a race
> - *   condition could lead to long-term mixed results.
> - *   The logic inside __set_task_comm() ensures that the task comm is
> - *   always NUL-terminated and zero-padded. Therefore the race condition=
 between
> - *   reader and writer is not an issue.
> - *
> - * - BUILD_BUG_ON() can help prevent the buf from being truncated.
> - *   Since the callers don't perform any return value checks, this safeg=
uard is
> - *   necessary.
> - */
> -#define get_task_comm(buf, tsk) ({			\
> -	BUILD_BUG_ON(sizeof(buf) < TASK_COMM_LEN);	\
> -	strscpy_pad(buf, (tsk)->comm);			\
> -	buf;						\
> -})
> -

I don't think it is worth the churn of removing this wrapper.
The calls can be optimised based on the knowledge that tsk->com
is always '\0' terminated and can be assumed to be padded.
(A read mid-update might give an unpadded result, but that doesn't
matter because it can only 'leak' part of an old name.

-- David

