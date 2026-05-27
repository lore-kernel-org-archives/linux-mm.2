Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0347ECD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D1A6B0005; Wed, 27 May 2026 05:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E186B008A; Wed, 27 May 2026 05:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31CC06B008C; Wed, 27 May 2026 05:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 215F86B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:18:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDB371C0431
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:18:47 +0000 (UTC)
X-FDA: 84812649894.12.EBC9707
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id C91A92000F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:18:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X8tHL+IM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779873525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqlhFFjMJuWuM6S6vZ8SCY5V5cKRhZoHzm25OC+blk0=;
	b=SiRBe7Wn8o2kyKStz71zLUNFyXAMiWaIu/Yu40pjnX5jwOJW8bhHveCuwJhUK7Us9Y6f2V
	1BbN+Bu5xsEgWW3KFNg78CElmeEbiyGxz5yL+YwDHlVtJrnSR0Vr3t3d9jpra8Qv+8x3Oc
	AFtl+Tt27NsK15QrV56rpQnLYs1L7TM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X8tHL+IM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779873525; a=rsa-sha256;
	cv=none;
	b=OL7auFqfYp+RQIUprlP6Au/evpcJvR0+JXfnNAjP+zX0X7uHWSINTCn+PGpdCd/tLlHYtd
	0EGMjXTix2Y9jzUI8IATbbYowNGLPO8sgT3Hzqro6j7OsO7sFhCr2eTNJX2UWsrOc/uCGj
	54LEUZMlitydep/wUNGRTzSD8t1B2uA=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49056b9f04aso51323375e9.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 02:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779873524; x=1780478324; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hqlhFFjMJuWuM6S6vZ8SCY5V5cKRhZoHzm25OC+blk0=;
        b=X8tHL+IMW3p45OxAfm2JrLu/SAqUv7YpqqkHAtD43viWKW5Aws4IvigYu6d+1Sc2YW
         iD8BMHjLTWETxXHQeqpLKfoPrO8XNrnFN5/dZnxnvwzZJNihAcdVs4+WJbyMcrQgN4uG
         EmRgzv9yhvRf0dyU0WhZRRGujYExg3x9ckdZl8H41gnMHXhTKoLgc/V7cJozE5wBYpbx
         twk0gc2ck+/h9dXGaQs7v5VqDklolVSkDKXM3Y8J1u7C5Ii3xPo9typcrgb7MMUgOBr3
         mO2I/L45pUVi3y0KHksYrYbVloJeLz0VfSFpjZQBd0HFKF+cPwprL0m6oioJSNTIHUyJ
         3/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779873524; x=1780478324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hqlhFFjMJuWuM6S6vZ8SCY5V5cKRhZoHzm25OC+blk0=;
        b=e2No/BcMWpU3QAPeU1/QAVNv6v+nTOeo+4dma9Ealwc/80axZHD4YxXS9GyTBvZVUU
         nFHlFxEw/waas2ZlgWd5HBYBD9F8e2v4KyNv9RygNlEj2Q5CaK0pis6lg6aKcSNaQccY
         fgzAiyL+hHjAzWc1HKz+P4CXOU4vb+c/m0+z3Ng7oWKT+R9wqOX942aiFATYcwFuE/qP
         +qzo+GdK1p6FFiMi4rTLUfPFTTU92nplLl9v0LthtU5EjbRDT5oOQNk+W0o51Wvh/ara
         79BoXBDpTQDIgYb7N8mRIRRRxEgu6bNfoksDUYuqlkvzcRzexmhtdJG8GradzeVn6Ms8
         GKQA==
X-Forwarded-Encrypted: i=1; AFNElJ8/lvhZ1R7C8wcBbdgcnKpD92YSG66EQjAqESWm1KcScm/NuIxEJCaHFsg8SOGhcYRQNO5dv+PXVQ==@kvack.org
X-Gm-Message-State: AOJu0YzbWA6e8/rcBD9Lu1l0/mTKawbdzlYIxNkPQ+YtnNhSf2IvEcmU
	PBaUHTbtRfJdDh/MbYyz2CJjeR+ErYStncjDNZVTOkgvAbDUuFRciId/
X-Gm-Gg: Acq92OEWys9RZCdPPKzMZtkSip673pwkbqd0bbolNOODWMGrwSPpyTFhvKvSFixHX+k
	wRpCQJGv2rAX6HDpwiAI/FpjaDy3xyxCgSThmedD6DmmNw7WaqzhEIwYBKMJ1CGPeJ5dBQzWs0y
	QhBR8uqO1pCFKlOc7DlEamPZtuqvoCILyRvkJuby2yMZdk/ib9WXwEQBCif5guAmEvBRh/a2rS6
	5z+Pe1fNp8FT+BDtm5nlUE2qAtHa4HBovnaRq2l53HtG+bv56uVb7rf5XpsdKuXceB7cVMeB6Po
	OkG33ounklfhR6u9/9Gx51nXj389R1wdHC8M1A/GsRqlX30GQ01QV08aIarZHXhG7TbDkiSF17U
	1jLYRDmenTw/EHmxyWhK5/pxUJu83xXOGYVhWINMSnasIT51s+DGwY2T7cNP5AimNuM3jtK3QzW
	Cfwe7lQed3/Mj2kTCGOQ/rfarz/LWAOkzUwe0uC2dqZfHxJFIaOPrx8vzI3zL6us4vJfHcKl1Jh
	pQ=
X-Received: by 2002:a05:600c:4f8f:b0:490:7136:ad02 with SMTP id 5b1f17b1804b1-4907136ae51mr128868725e9.7.1779873523995;
        Wed, 27 May 2026 02:18:43 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4907eae9898sm18844735e9.4.2026.05.27.02.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 02:18:43 -0700 (PDT)
Date: Wed, 27 May 2026 10:18:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Christian Brauner <brauner@kernel.org>, Kees
 Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, Linus Torvalds
 <torvalds@linux-foundation.org>, akpm@linux-foundation.org, Yafang Shao
 <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
 Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 3/6] treewide: Replace memcpy(..., current->comm)
 with strscpy()
Message-ID: <20260527101842.376d567f@pumpkin>
In-Reply-To: <20260526190625.3f4aca0a@gandalf.local.home>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
	<20260524-tonyk-long_name-v2-3-332f6bd041c4@igalia.com>
	<20260526190625.3f4aca0a@gandalf.local.home>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ojz7gzyuc6tib6jmsf5txcumojjgrr5d
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C91A92000F
X-Rspam-User: 
X-HE-Tag: 1779873525-743867
X-HE-Meta: U2FsdGVkX19V+CxrOcLLfK8r4aZEsBrH1mJM1lRNcr8kbA27MuU8LCHIEQkkf806ieQdzMlZiN3auiwAnPiNiOr6Xol5E63jVBbl6zZOkb5sVLUY/eZwmVbswhQwdwCOfx4lmdXcoTvXh402Z1IimeNWXQ05kRr9/iLmZGBOUyn8YOTG3HbAXWHAz/rwlwN+YxaHZkfZNQdJHqiqgoQVJie4Dg8Ay3aTjGSHYlzAPNfNpGSkusEFjaxpnPNux29sz1Ki8TlXvloEk/837j7CWqs/7KLC6dzQ44aU6Ds23ijLj9G42+8uzxsbJET2OZKPePUafozMj6mHczXXuLgKzL9QculWwOK+kBvwm/GrrSub3K5QWxbHPA+b8ivh1JDGJSvB2i6FjZBv7MBZQ0rQuoNb6raa5GVzpElWQeWb+yrUQAn6yc53mGdxHKzjJ8HXXgrwQgAcZ5di3Qmv+ijuybTUeIV3LVdyHh5GoGdn7KdESPaMdv1XgeP15qaUjtnENA3vvuIaP5KpZwyT4MsUAlCS5TnL0N2V4Q5gfqcsDxVOSJQf9F5CrzQn+UrJdBJXE59zUUBa161gw4ONPDWovr7o331wtPbagVEG/qtT+DBOhjPTCNqRn34j4IWDUcgb+2eKFa3M/Iuk0SQYEtlpsXrKpxyIkXlyKSXZYiuSlkqHx4akKkLdwoYvB5Dng9PmirGhAh4ha8J14Hz/d1uQAuo9fzxe3KAbB6PzXGlbI7qJE52DMa91+/4xVqCaJ9tENieRXl/OIkwhlF+BITk5+T/LEItE3zVsr7vmQ8uMwOUtQmVMrgO9kkrV4asIfKYJsY2FqAHdX39g7UbaGpu9NoWbWmOW+y5Awhnwx73PwPtsjiSThytGSl6yqyICsoyYeWOrfRdfWhbdtp6wkCv3+7IVB4TD0mTNGWYz+hhlk6GlCeIwIEwlHIczfggucSSFJUW9bT7YINGWCmNtk1Y
 j+jCYBuz
 thLaLZWZIg1pV5xM3jPvBJEB8UkLWo51tTrs5wCDFBRls6OH33FvFf7WdamTr0OvqyxiU3DfWPNYxzYW+j6rCjI1riTr5XXhF+LRp9jNX4Yr5//5Tac3sAd02GkNqy5b+BnVtCkuoaKu41FLkFMDOsbk5/NsYnoJYV+ia73QZRleag3IgbYkmDfDok41HO2aMeu7T38bkqPjQb5y74H6DcNipy1MlwKE2XkYQIBjonCHZLRDAP93nZz9JouLBjmgNLPvAJIPiENSBRukcpr+sQhsDSQQzJNseO3myFZFty/gYKwGVWfE7owbgW2TzFUP0+2+6cqr1nUgGFQGULnmfoUFlsQVJmJ3A3I0J0FcxrVz/edZd3HKflYSitV/3wuk3IfiFlrdaBHKyLRcE2Vq15mwKdGNM/IPTZ9/ebVp5dL7pnHDCjVdpqbUnp8VNOh/ZPV07x9Dd9x8Cdye7xRc3SV9ndgnwKzrk8AkuM7DmTzoGMhAC5WniIlw+9B/1ewJuRji62fBSDF8evzVmfSy/bmH9mXcE8tfVnv8VxIbQ2+l41iF46mNpzaO+8N24ego3g2tbkaCpgFiknK3HRmWMBKWONvXhbtjZduLWTfbbqKZmJhSDSYEfAkMX9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 May 2026 19:06:25 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 24 May 2026 19:38:53 -0300
> Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:
>=20
> > In order to increase the size of current->comm[] and to avoid breaking =
any
> > existing code, replace memcpy() with strscpy(). The later function makes
> > sure that the copy is NUL terminated. This is crucial given that the
> > source buffer might be larger than the destination buffer and could
> > truncate the NUL character out of it.
...
> As tracing now slows it down by 3.9% which is a significant increase from=
 2.7%
>=20
> I really rather keep memcpy() here.

I suspect the copies could/should be replaced by a copy_task_comm()
function that can perform optimisations that strscpy[_pad]() can't
do because it can (for example) assume that the source is terminated.

When the src and dst are the same size it can also degenerate to
memcpy() - which should get inlined.
The cost of copying 64 bytes might still be rather more than copying
just 16.
A compromise of 32 may be better.

-- David

>=20
> -- Steve


