Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1A5CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4991E6B0005; Fri, 12 Jun 2026 14:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A616B0088; Fri, 12 Jun 2026 14:53:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3390B6B008C; Fri, 12 Jun 2026 14:53:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 238FE6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:53:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEC61A01DD
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:53:35 +0000 (UTC)
X-FDA: 84872159190.08.FE131CB
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id BDAAE180002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:53:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Dk/t3Nrr";
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781290413;
	b=YMv4Si14t7XZMOI6DvKdwAe1lK4CGLXoSCZMZb7JvZeS1xsqEt/UX4pUpvPHTMHbK902YQ
	YIOpoTOTytk6RofmoxT6mFhet8/pIy5mri0uXwMhbBaNuK61uixrLGawP2u4ROh72bVrwX
	4XSyRCn3BhTonkjSn6TQq86h3a+Podk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Dk/t3Nrr";
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781290413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CB3wwilAFNqCSPIrYprWyBx0bbSlAUAXEXzKdqsS5I8=;
	b=b7oLR8G4pDeEfDVK5hzXhQPIpfTdXKZlTkBCdpXiyH+Z3kkuMMmQsvWAoiQf9vVDLc8mBI
	Hf4HFdPxmAR0Zoh8iSR7nQiqM6zPuJlLeX6/IhPzlrro9mD/fMrnW2VFOZxa+MmBIoTiDe
	6Ax3DxKKuVH1XWtjCLjkdcjrMtQhAqU=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b211ee6aso9508805e9.3
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781290412; x=1781895212; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CB3wwilAFNqCSPIrYprWyBx0bbSlAUAXEXzKdqsS5I8=;
        b=Dk/t3NrruSkHvmodEfX0YBV5STq0JQZeEGyz9ZVbUyAu9rfQwGb3/2UJHh0H9nSfje
         M63DnTlPc9Mo4Agn8jbEuv+X228WRe/tIZBCyMsDJzchlAUT8w1WtG61u0a1N+k3bxqN
         M/PYhggqBoRnVUENL9qPf9mDwadAILmPob/kLwiMwf0II1YNNz7bz4AK4g2aK/WOdW8S
         cafF8J6tr1IOA4S6edKbsUQgHSNio2u11RBREbSG7vXqUwusCVhjxm5GLziatApgMKUz
         YMjLfSCbyMZrTBb9xEsQtZr6tuq9PXN9c/KNsEsQ+aGgSQLjkic2wUsc30ma9aUnLJUq
         3QIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781290412; x=1781895212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CB3wwilAFNqCSPIrYprWyBx0bbSlAUAXEXzKdqsS5I8=;
        b=RrIlJzFZj4BwHwsrusPJkHtN+iCFP27y0pkqhdaSg30UtwURc9bl6YZUunWeWbcJUI
         m8jf0YAIjY2D4tIZSikay8ImKUYPD0Ivl8TvF2KNHNdwZIwlTd6OOnV1KnKTcGYCRTb1
         x5TuZsHuTqcBG4ezhJkI4FmRDL9ZJacf8oYZykKPxrNhq9WLBl01pyjEry4Gn5Gy4V/Y
         LDJA9xgISiO58YIbNJOZawTIGFII1cMcFz9VMj08FO68Ono0WmB1E2npNm96MS1xJJi6
         i9f2yIogE+roNi+n5iWAQiG24gBcDwMpw8RI2EubKH5nblxjW2dV6SMp9pBgok0s6yP0
         e3kA==
X-Forwarded-Encrypted: i=1; AFNElJ8i+q/W/iS/SCHXi+8PrIHdqHhvMCsN4+AN9I5GgUCWkptmycu1cyB7f4D7eWcE9DYMEdgAfxE2aA==@kvack.org
X-Gm-Message-State: AOJu0YwtR7//ohxZJkKioWtujrYprnNQmie1V+f4ZCEcdsbglR+OMYoL
	1IJ7JaowrQOwoGLkfZGXHV+Mdce8F4i71H39/ZHCqz9AaMRj1oEe6KHb
X-Gm-Gg: Acq92OGXbbBCYMV9iIdIvbYpSj4QQHNZWNOmGlJohqDiO4jshpps9HfJh8hQl0x2oka
	f0MF4ee2nh64l1xPR1knkxYs3XtgaCpdD4kwxbf2L7Z6bo8TkeQsbxzXabH9mYqc5Vemzv3izjo
	tEnfZbfsBlgr4j9MTfbZcAV7BbPeiGnVZiBy22rkDNOGv0wUtOU4T8F0pjJzpP9aCQEXZwvbv6Z
	KombubmGZffbKsySSAAU6PkWOIZLW3vt2BLmUWyf1bkuuTDPG3zyd9YpdFzAzDEklIf1VClMU6J
	u0ahL8dAMG5yxqDubsErtob8btp9xXLL6T6/mpWvx1iUFGjziy0iu+yZfy458S/Daem76ZpCLU6
	yDBrLlxDKnvdOvvzgqHC2ydM7zgbBg8mrTRzj55OW+0WjQJNJNhT4o3PP7RqS2xUI30PiSIDcWN
	RE2h877tcZi7Ei8hWPH5KDGd9jMIcMm57OFlJhmRZ11qIoYKusHmy2xbABl30j
X-Received: by 2002:a05:6000:4312:b0:460:70ae:f1a2 with SMTP id ffacd0b85a97d-46070aef2b6mr5433215f8f.17.1781290411899;
        Fri, 12 Jun 2026 11:53:31 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f20e77asm8584369f8f.0.2026.06.12.11.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 11:53:31 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:53:30 +0100
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
 linux-api@vger.kernel.org
Subject: Re: [PATCH v3 3/7] treewide: Replace memcpy(..., current->comm)
 with copy_task_comm()
Message-ID: <20260612195330.1653d041@pumpkin>
In-Reply-To: <20260612-tonyk-long_name-v3-3-7989b66e8a99@igalia.com>
References: <20260612-tonyk-long_name-v3-0-7989b66e8a99@igalia.com>
	<20260612-tonyk-long_name-v3-3-7989b66e8a99@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDAAE180002
X-Rspam-User: 
X-Stat-Signature: zhcrntb5m46fs49f7h3dm4yp5wqtdghk
X-HE-Tag: 1781290413-246532
X-HE-Meta: U2FsdGVkX181loZEbpofZc60dhaEMki5QKYeTGu2dHD9n+wafajyoRDNN4BnbY56bAoMXj2uC+I+82/YodaACmQ52YowIERxQOH70ByJ4B/J8P9cj6MC0aDLPI5duJELuU4nD3e9tA/lqWwvpSoUgu2vJufqrev8W7ksWTY9ofsTHnOeDKEOQQtBIXo2KaeAScg/+uqR0BXJpMLN1k9DfuU0bgYqISgD1WqnqBle9Hd/vlsV8/1H7CJT/cu3LhS1xylTVYx7EdPIWh8FBVWnNYu1IZk99fwLnPZxQwfvLL3lxNlqQnmCe4AqA8qijCpqjzY6Ah3ySb/b3vCv+YUncKqF+ThAo9vAJX1J4F2cJVh3WCR1qTdWeh79iOhGDSLaIVHZxksJrvDimMI47P5oRU8pr/QpdbGTaR3LMIoo/bZUszGR4WVQTPhXhTs7WAMLcT/bEVOHNnudjix8BS5C/A2NWKPsNuP0EAUFQroRDMsn2lFKw9jWd/JJmrcLY9Ko/o1yhu5xh4u/yyGcs6bbbXrR0V3srHar8LHV+mgZcC/ki/H+tOXpqouDJJ99OvftLx2MlOzrb4zIJUia2Nj5dQyvolhBp4MQQuuSI7tVOvOmIUFkL/I45T7yoVA81IXfj8OGhyH2DyipZrTOmzmeXpRF7o7bPcOhTtADy9NTYqBv6+Q3jBSHqOQGNZrJMIsqarcMgKBTMkeFSE2UTVIWE5mHnXMn3V4z+4y7TRHlqaqzHE1Wn17/p94qdl8eOiVLkD+kD88IVl+820UPDnUDQsbMeBIIEnaRvBT+1om0hKjJ4l30LlUNwuvLKc4J5eiNSiprcvMCoJg/jQF+zBQoVKRM41RjBkHu6KKfN6dT4P/s46vgI6kv3CA58gA+Ci5ak8u+4zx9PodLpD8j5gQlw32I63s+8f7z5e4IGKnsfCbra8a/yfwDx0ERyDmBzxKUDUIlLqhePo+SWY/sIV8
 bZgMATC8
 seQYhBTRUvXzJVHViHj10cXuXI9S4oy7tS/WRJ2WFgoXsOZ34ojvyiZN7nqIrlXc0xYkk3PBPjzJRYqKO3/HCXK2MiQpESeag/4noDb++0dXv+KUeSzyUmR4T2loVbDvEoFeyUGpbJZRo6pati0nNIwtGNdQ/xuNzKF35CXhEUR40WngL0dDiHWJtgmuhMhUSDnQfCI4OOJFJKEqwvaeuOIdIayGm79AG0n1kfYoDKKXVQhyRK1OV9ptmj539IwnPGHkKadvaR5OcTlWcc/yQ54fctMfGQqR6ag+GgKyNnGLQhQXIiR81IwYryKEQU7luJXuYQ4pIUPlg5aHpV7Y67GIn0EuDcD91gpxY2AwhL0XJ4/6rcsjWnsmBOTdpfmhUqDCE2nxIybExnZgWUeU44thD5oFB6MuMnQenM4kFZZhxnp/I4///Me5Ht3bIbUCr/4+En8a7uc+vCnv7CFY0mid/iCKNG4uimVPBGVRYhGIRiTLCTtgCZGCPGxDMwHh4T31g9V8fg4Xlxa9jGmImYDXReQW+69Ph+5409f4lw7v/nxHj8COic7gRVo6iv81d2G7X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 13:20:16 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> In order to increase the size of current->comm[] and to avoid breaking any
> existing code, replace memcpy() with copy_task_comm(). This new function
> makes sure that the copy is NUL terminated. This is crucial given that the
> source buffer might be larger than the destination buffer and could
> truncate the NUL character out of it.

Aren't you re-inventing get_task_comm() that the previous patch removed?

...
> +/*
> + * Copy task name to a buffer. Final result is always a NUL-terminated s=
tring.
> + */
> +#define copy_task_comm(dst, tsk, len)						\
> +{										\
> +	const char *_src =3D (tsk)->comm;						\
> +	size_t _dst_len =3D len + __must_be_array(dst),

If you are using __must_be_array() then why not use sizeof to get the _dst_=
len?

> +                     _src_len =3D sizeof(_src);	\

Isn't sizeof(_src) just the size of a pointer?
You need to use sizeof (tsk)->comm

> +	char *_dst =3D dst;							\
> +										\
> +	if (_dst_len <=3D _src_len) {						\
> +		memcpy(_dst, _src, _dst_len);					\
> +		dst[_dst_len - 1] =3D '\0';					\

If the lengths are equal you don't need to write the '\0'.
(and they should really both be compile time constants.)

> +	} else {								\
> +		strscpy_pad(_dst, _src, _dst_len);				\
> +	}									\

If you do the memcpy() the bytes after the first '\0' aren't guaranteed to
be '\0' - then can be random (usually part of an old version of the task na=
me).

So I'm not sure the strscpy_pad() path is needed.
The most you might want to do is memset() the extra bytes.
But are there ever any????

There will be code that copies the task->comm to a short buffer, but are
there any places where it actually gets copied to a longer one - if so why?

	David

