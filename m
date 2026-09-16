Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F609C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 07:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5FE6B008C; Wed, 16 Sep 2026 03:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD276B0092; Wed, 16 Sep 2026 03:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2C86B0093; Wed, 16 Sep 2026 03:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDD36B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:22:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45A4B405E4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:22:49 +0000 (UTC)
X-FDA: 85218783258.24.B32E826
Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	by imf20.hostedemail.com (Postfix) with ESMTP id 511441C0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:22:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MTusb2LW;
	spf=pass (imf20.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.228.40 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789543367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+Pnc7qVstxJgUb+1pauRHnxHo4hAE5BG/iGKWeGubc=;
	b=uJV/KxN+QHG7CyRbuD3gaJ290jHgS7P7xdMRq2qI1iUlS45KLhojwfP/DfLTMyFrykHyDE
	BHzAx/D0jgafUQcp4dPEFDinu0FzUphPMxMKfLFy6MlFq09AtLE2zaAFtKtl3CeuCEkLLL
	OWkg8ubUcY3wO3rTm+K5H+xh20uvt1c=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789543367;
	b=VOxht690PW1FgODitwObHhZIuvpO1ZpXz8HcRpRsXRRYhDnj7Toq32p22R4rbIO9lxS8cA
	dkVFFbYzlb6wPryJJAn7qkIQCkwaGxhJLUDv+GNHTJG6Cf/sjm2B5G4gS+lj9z+5lKMjIB
	mrunjbu1Wz2rxpSggoGrxKBwp6uQqEI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MTusb2LW;
	spf=pass (imf20.hostedemail.com: domain of dmytrokoziuk68@gmail.com designates 74.125.228.40 as permitted sender) smtp.mailfrom=dmytrokoziuk68@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc5121bcf1aso108332a12.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:22:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789543366; cv=none;
        d=google.com; s=arc-20260327;
        b=Gk3zpWXxT17rAhDz3JeuD3kcXul8Eq6BMGHSDEikKdfpCwAVTzal4JvzLMrreJh8mU
         wGWakHEWJAYZQ6zm201XhfbXdnUWx7u73XYg9MkLkXQIdwdlGYs8RhRDt9TyYH+xlG5S
         PVakKrSLn6ynAbLIgc+DZrxBDRVZgJh+3Tlo40I/Vf+is97l5QHMcqG/BOfM1/4ze9zk
         eYkPomkTxDniAjWegefAgpXtiWL9w2DkjO44VqIu3sWX3rnqrUkfptY0sxAvzzTM5dWs
         uE5fnj/P3gmlqorgcJY4P+nWCNY6Sgwpq6HpqHID0vYN5js+d+e+dADGQ2q0BX7GsSso
         EwtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s+Pnc7qVstxJgUb+1pauRHnxHo4hAE5BG/iGKWeGubc=;
        fh=h1kNvxdgr4UFEF11U9MnJ6Pep3EX7beDrLQJNHq25TI=;
        b=cSNk6ZYsndT8Pk71FydyEZcpA4/zf4tbUctF3d4o4QQFWYOwo6JKqeiPmbF7CqFRSi
         sJhoCiJ0nxumDxIrcucbvVa7ZYYJBE8CCqQK4TjJTVqXHLksfKV28LEB7E55jOnattBx
         pDBRvCMWh7jO2CYWm8UMXOxj6lV9pCb/lVOYHYEb29iXQx1MLGV9ZL8e+d0Z3Xdc4Am7
         PU6XE4tiuQDQHkN5wtUsUe2VXbf6Zj6mmlOXLvYjxVkiP5fdhLzagD4iZiYaaX5byITG
         CYEGTSDQ+9WO34idxDgLakAVBBcpaxWMWKIuQkbq+PCur8qJIWbxQ8DzteN57CUuaQF5
         WiiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789543366; x=1790148166; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s+Pnc7qVstxJgUb+1pauRHnxHo4hAE5BG/iGKWeGubc=;
        b=MTusb2LWC0ZPuM7p7hZqtdacI0xi3Ib3OZhhm7JorcU/wmEuvOPczFEOA4/f4xNjXp
         +iSbKxSUvHeXM4gUfOPZ7y33VcZ1NyhJSZCCGKnAG1rhDSSfJ9oGcs6UAwg7wS3n9CNd
         pGbotKbyz/OlaQogFlFqjXIzTTUghOHUhY+YbwTUXTBqTkdcxXFmdxw94en85hBF516P
         fDnSyEybEYCewSyTSaT1jaP0Rc0RDtyOAATv+BwHJVMgwHVn9Hu/h7fxDygloMvsCu20
         IeUxb4EvZDIjSJFRbtIDKqkYBvfCJ1uTWHKzERcBpJe7ev4zuG7aXiLGHjPrGwe5jBae
         YrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789543366; x=1790148166;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s+Pnc7qVstxJgUb+1pauRHnxHo4hAE5BG/iGKWeGubc=;
        b=qGYCVKx8Wy9qlJvsLTxKk7GKjAuYtrIFoUkbMB1MsmxHMeYRDSkDej2Ph5fgzGkPua
         7DuBMYYnUR3kgcpp8MBTWlkspPcztph58Jku2zsH1os8WNxxlwU7dXi+jMzy8Oe26efv
         NaCtDDaw32jMnlnv1afRlDs7lcZlkhbs6hRPjyImUjNuBWru1X7OcDE0uDRVsFF2VP7b
         fjpiUrawWHr67Cw8Nv1ikOdPDzhlKmv9WT+/eVKBBuPfheWR0DFerOaxAnGjseRM7jAs
         nDy+Pg3xPlbcJHH8G/3gHaLEYopr7OIqkIrXBrbl31CTuiHVWP84lvh5tKA7iaWj+HKN
         M8SQ==
X-Forwarded-Encrypted: i=1; AKwUvBwlaNvoh1VVTHhlOViD+0GB17yvQCOLFwO6AUJjlFZS9Ho9qNQGtTmqC3kI4jxwU6sln5N96QF+RQ==@kvack.org
X-Gm-Message-State: AFuF++nV+XDv8mrUsskH3g34rKAcOQynpxvI38WufwfuaLBPu5W+mTRO
	ORK7Z0bxBEBBVHwu+l/+BeMpbDZbyvo8Sq5+ITua9DuTvPj+mHAAe6UfSFD5BXvlc0me9mg2L6d
	LwHYaWrVMl6up+3TA0dAcoR4lRitl8j4=
X-Gm-Gg: AYBFou1r1QkKmo4+juBuLDswxUNmQ/YFK+6+xP4AqZvpLRYVRRCtet+Ucy1+9cIGqJM
	0iWEU0afz2Ow3eSWbYcHXGgKAaZi9+HA3hra/s12dVkCMNJipVw3wgT1I0R1iK/3tFIkUZ5+zxQ
	i8DcaSKfRDHWT1kdqGg5h+fTwJealqZFntO1YEZ8sunhupS9GXoMEaIx30ERliLKB9zRVnz20pe
	Jy2yylEgSAgp51o/qIXPgAE4ckafTHBtdQTk/ye7NuLAdDXqdFD0U45Wt4y3Du9tuRFFdx1ZJCc
	UDQ6V/uPgxRr4nHsSrOxZvI5qNhJh2ft79USSzm2gyt2sfE2Qz/ikW/TEoh1ow8k64oaNjEwFnd
	eopOp34WLpa68Au4Dh5RMyW6iaik8kDEqE/xnUgchlEqKRzevt4aSjAxUrw==
X-Received: by 2002:a17:90b:39af:b0:39d:f247:bb3 with SMTP id
 98e67ed59e1d1-39e1e4b0168mr3646797a91.21.1789543365922; Wed, 16 Sep 2026
 00:22:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260915160207.2952-1-dmytrokoziuk68@gmail.com> <20260915153542.3b9afbd00f7e6cea87a3350b@linux-foundation.org>
In-Reply-To: <20260915153542.3b9afbd00f7e6cea87a3350b@linux-foundation.org>
From: Dmytro Koziuk <dmytrokoziuk68@gmail.com>
Date: Wed, 16 Sep 2026 10:22:33 +0300
X-Gm-Features: AcwNN1W1l09nB0LfeekZ-yb_tFsOsztqosXb-8SnA5PHNdJWCVOsJr_2fBYC5WE
Message-ID: <CAO63FDVJaRzwE_z4-Yd6Z8fZNEGQyx=YbeFatBN30d9X8SYLtw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: kmsan: fix iounmap metadata teardown
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 13mwuyh9g9qss8i6rkc7fd86zsh6ago8
X-Rspam-User: 
X-Rspamd-Queue-Id: 511441C0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789543367-775930
X-HE-Meta: U2FsdGVkX18XFb8+ILblalDrhY8VWxhQPrTccjD1rzZemlX9TqT2c7YoZy+LvI3zzRZp7VbX7VYMt/RqMKnigJM4PgJoaB68yzUWmi99lzwP3vakUid1D199gS7YUqQTmf5a5VfGh+zZVUqdBg9vz3FC5fz1jhCyuv8Eex/IY5iwR6JGkzlKSOnNcpOKx8GFewGhCOPfG2O7mrphcKzaSQqWqX4ViDEvu3QboHxeGmrchrXSSMIEaKOQn5tug8JBnmKr17HRW5/PHWR3HhZ6SXlj6p8FBkN7+w8g4dJQr0SKMtSsbh/ipiUJ8Gd7MRKokqdSjyo5vNhEW648aiJ/OWQrUnEDpD6ISKKYH7y1l6yPkcL0AbVzB7yXLm28Z5fCv4VEUhq/OxB6fEeT5BgJxB+Vuzk0OWxD8Hoys+DnK8jv/2Xxe0CKfXoeUdMDO1EprJkcK+vw418GZzOy9xlJLOaLVrqD54S5YkxyR86qoHhyd1meQKX1QT+aCI1F4PHNy0uOn3yeFz9Mw1/py6lX5FW9pVKj4/jDPjHMgoKWKpVyK+dOFLgWBe4FAoYNJnAJokRe7GGNhFw0HwxOmvCvoVgDAZ5VurBXAYFUPLpHSHL5aL499Idoff9E7hyOM9JLCmqFOEta/4/HuhmvetO8qrx0VDPVnfeBqhy4Yiagchs/g4h+bb8ga4Oxwrbn9J4TtYEF2Vu3e5F+Z7nm8YN849llzFaw8SqVRTwycdSp/1QSUrxV3+dWCjspiRzNDML/UQHa8FDi8hOVVhVCPR/EGoWePQgtFbsmCpvRIX3Oy7Uz98ziCDeVV4xMhbBGt9EqLSgnyA8Ut3OsTjOrLQ6MOzv1yC3eDI49leka9yyW5K6ZySkG0qSLeBbUGhWcYZAhpSvTJqqzlFFraqhDsgp+rDW384cNnUBgr34j2F3Mu+IM9AcjrCCVEJ+nlg3Xpmsvhdb9M8QR/eClCvGawYi
 eK3c26q+
 VymDrqby6mptS3oEDJBjIYAdQljU9dHuxCk5vFTibyWJQB7Mjt8uyhCjfc7y8UX0CQjLm8b9JomWrmPdcl9oIsu8MsgFe1Cbz80or40Yid6iwrrKJwF8hfp7urI6pReYIpngbfbE4OwnOiLXyo+DbMQPKzAxpIbyJmJcmSS5VUyngEitGe29Sr3lGE4It7E4lHjEcyPUtgPUN0JWwuB8xDI+pHXmXLA07rxBvIzHIYqEb3MCx5zrVa7FEjBc2IL/dl/8xswsPoPwQ5MN/tHCXoDEKNB1r9X7s9vrMdb0/We9m5AACDe98DEMbuElCohSi9ijsY7M1XaXpWzGhKz37rtnPWy55HVoleID5tdD6l5zu5wuA8yoFZ5hiQPCGPdhtRKKkIsPwBkNokFtIz2ZFpiaib7ojxoLu5vJMLpZP0a60RX9z8BFiTYg/5qaJwxTtshFtu0khVgDDYVQ7YpYL4ZeVQtxtzME7rbLu/4OfhA6kIhJo8XsoZAb+YJjL0pdQtAtznevfHl0+WqEPhOxXtFdRoA318WfOqd6o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  AI review might have a found a couple of issues - please check?

I don't think the patch needs to be changed for these issues. For
normal iounmap(), the
caller must ensure that the mapping is no longer in use. Also,
the x86 implementation keeps the virtual range reserved until after
kmsan_iounmap_page_range() returns and its TLB flush completes.

For the kmsan_ioremap_page_range() error path, the mapping has not yet
been returned to the caller. Cleanup and the TLB flush complete before
the reserved virtual range is released.


=D1=81=D1=80, 16 =D1=81=D0=B5=D0=BD=D1=82. 2026=E2=80=AF=D0=B3. =D0=B2 01:3=
5, Andrew Morton <akpm@linux-foundation.org>:
>
> On Tue, 15 Sep 2026 19:02:06 +0300 Dima Koziuk <dmytrokoziuk68@gmail.com>=
 wrote:
>
> > While studying the code, I noticed that kmsan_iounmap_page_range() call=
s
> > __vunmap_range_noflush(v_shadow, vmalloc_shadow(end)) inside its per-pa=
ge
> > loop, and does the same for origin. The first iteration therefore unmap=
s
> > the entire metadata range, removing the PTEs for later pages before the
> > loop can recover their backing pages.
>
> Thanks.
>
> AI review might have a found a couple of issues - please check?
>
> https://sashiko.dev/#/patchset/20260915160207.2952-1-dmytrokoziuk68@gmail=
.com

