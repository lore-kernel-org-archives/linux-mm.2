Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF965FC9EE7
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 10:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC0A6B0005; Sat,  7 Mar 2026 05:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6590A6B0089; Sat,  7 Mar 2026 05:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AD06B008A; Sat,  7 Mar 2026 05:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31ED16B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 05:32:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF475B7C91
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 10:32:05 +0000 (UTC)
X-FDA: 84518901810.30.D768A79
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3305A000B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 10:32:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g3IUi5Sa;
	spf=pass (imf25.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772879524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjqgvKaMmJsqn9feQu/dj9HySbnsU14nAaT+VhW9A6M=;
	b=a7MW9kXbdmtLFGODnOAIibInp3voI9XSHhn8CtlNnFeqch6kgZB+z54yg8MBIqvN147VMX
	RW4u7NgVlzkWOw8uYJnBQwv1LyNKkQQk+a5KBYkrqi2LLd6qkfoGvt+qAdkWS0DkKG3YZU
	A618x1A2UWYNVet+QSCjF3h2FGoSztY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772879524; a=rsa-sha256;
	cv=pass;
	b=ZARqiTMsF9cy4sB3Yq1v3YpNobK6VuV5G3UMxolo0yju1C70LzAuhI4jyjlCL/P60zqugb
	3SGR+2p49HmnoeOnzN0yWwVYJyWMmvC+9QftHbdGyk58cZlli/8mSiFr+ypnZHAiqVF6ZL
	IAGT7hd2boifh1s5V+pBPR7kBU03YpA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g3IUi5Sa;
	spf=pass (imf25.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-660ea6ceb5aso5445128a12.0
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 02:32:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772879522; cv=none;
        d=google.com; s=arc-20240605;
        b=QJ/6gJb8iJAieO4zYCgLYuRBe2l2CJPdLXMcAV8yC2nhvoTXo0E9leaimMUzOrcE/b
         LJienKyyVzwPIrYI9HRWe5isaLGMVkTihqxsroCEVPnzZ52oRzjHF4yAkG7E8RnLsO7n
         tFTRNaGD11mwsw1FGGx9Fr+Z4cIfajMPpVyQVm+lNq+w6yBcwA+owq9Octh8dDElTP2G
         ClVeG3YuvWUJa3PjktgvfgIkQ+vp7+iJXtfOcom6B26nIYh6cXo/nSCWSSeGLgyn38q/
         ycxA8/16Mz63eBC316KzzhALiHDlsGUhlajy8SdTd2W9LaR3vpJFWl2DCJHsm4vPstZy
         gs6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sjqgvKaMmJsqn9feQu/dj9HySbnsU14nAaT+VhW9A6M=;
        fh=OgGWxNWOEa7mQXpThaebPaGwu/g6h9jJ6eMmFmTV8Uc=;
        b=RGJusJOriuZu+XzZZ84/Qf2sg8cMsgvOJq/S8AFcY7zRbbz4pMrokW7EFfgQijTcm1
         K8OeUq5yO5DLHnACFEfdaB7DUy0ATTvqLoqt0G7jYKYC6+ylwhIYrvN9KZKiQesz1278
         GKAtRXR0gMWEZLoXwIkZQetVRqg1oPW00N8xJCXm0W2BjdHo6/PhxAkWbZOrfAR6nLJJ
         OYZOuTCNSU2TzLbCUeoHgloAv6BTAK2lLYu6f3GwMe/fOuAp+91y7caB8gTX+NWOON/r
         mizxto+gxTYu1AeR4wf/ojZPCvvSPZIrfJf/738NEtDYKtl67LKyNEsLqurvW1f8q7BA
         F+hQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772879522; x=1773484322; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjqgvKaMmJsqn9feQu/dj9HySbnsU14nAaT+VhW9A6M=;
        b=g3IUi5SaaCW+ZGKt1VjMUjdy1/0gZ9uuP12Aq9N6g2pO0LdoWMyPoAOBdDsZDflUVQ
         cOskT3ZmbQ0N21YTc1TY5451wgjk/BwsciV2WjTiT+S1h0oUZlLzTduFj4YsS7qdd3d8
         2FJub+X97yCPmLPiLnHZ947LrOF8kepvuHpr5eUsJJUIAEtMQcv6s/de+/sT9ZT3FPs1
         o7xPSmoxWeAr4rjHr/wrJ3bLOW97t2uTxtY0FXCmwNZ2u6fMVuH+trhWoYJKCyRawEyn
         sC0hCEjri6U/waKQa2Lw5uROVZ+5bQ7fMUoCX1UqS+9MhYARsYJAdULLLgQJWyUr1dJv
         GiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772879522; x=1773484322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sjqgvKaMmJsqn9feQu/dj9HySbnsU14nAaT+VhW9A6M=;
        b=twUMiaR0n5f4NlymOs2BBnagWBrI8yyzwvQo3Kgov/QwCcFyYVWE6WodLlFBn6T3Bu
         BBGHmTsJRclNzZuMzpqtFwmgD4nS76GFKoU/JOFHytOkjpi6Iu68rvdDx1lWT+p8Fbjk
         ksz/ZeD16JMJAlEVe/Ik9s5LIFFUUQUhszYuOAORYcwgXl93B1sL2Kxkxjmbb99xbB3F
         dFOREwUJxGn6LyM9uOy52dhwiDclqs/tPS+kkd3zQbWlDRnvyo7fm+0b9qTodoBvQTan
         tFkuJn1C1pM+KXK2/2YPRfJY4k0BVjmzcXWQqwmOBswkw65ytZ6uBAVg2r7jH+GANuF7
         x5Bg==
X-Forwarded-Encrypted: i=1; AJvYcCV9BmUxwubfCiP3Jy8aJNz0l+9NxOc0TuwxquwAAn2l64Jm9cuV5nH8HTj95XKYOXPmpkmJrg9h2g==@kvack.org
X-Gm-Message-State: AOJu0YzIdp2tSq8KtI2tZ3T3ZkaEw+qjwLJnTAFPJk8YyCthZpWLFXqD
	9ZkKO7oxXoUdyA5ABZzz5Q7MF9VHAx63dviE8kEZbabQsb6ogWXXEShTpQJsJa3OTVKtnVuHBqL
	tQnyLkjZMV2nvEHGRekWNaNp+TphmqGc=
X-Gm-Gg: ATEYQzzkM0s2YoNjX7BPhppPkQsW9zyFKHN5cEQ9kLJkV9BceJetVi+VPm6sZQmynF6
	gGwjlrddwTiJGJL1zAz1aAFOKrULS6U+LeTRlqAbmTtqjs/Sp8sN07FbqSE5bXqtv1gP5RlUkTa
	zExGy9a90Znpg3zZFMgC9sb3wTWQf0bskDS5x7xkakpGSYUUNeY2FxVHihNobufKTTaU0molbxm
	zuoXFpBNSnpJNcyPNuXLkBnx/GzFdFfsdDrE8ozJCs1hLglR+waRW3SOItJ9mERtjTEkJdafY38
	09YQmoTh0PPYpoiFCVxt9wakO89BD/kF25iy9uo=
X-Received: by 2002:a17:906:eec9:b0:b87:6bb4:9eaa with SMTP id
 a640c23a62f3a-b94088e1c51mr561531866b.8.1772879521757; Sat, 07 Mar 2026
 02:32:01 -0800 (PST)
MIME-Version: 1.0
References: <20260306190100.1900572-1-mjguzik@gmail.com> <aavuocRuM2Kmwj98@redhat.com>
In-Reply-To: <aavuocRuM2Kmwj98@redhat.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sat, 7 Mar 2026 11:31:49 +0100
X-Gm-Features: AaiRm515AG-hYYaF-RJx3LCuQ9F1cxBCdyw3S11LLqXMtljPtnXtovNDiaWEt_Y
Message-ID: <CAGudoHHgTA4-50qLFvptDmg1r9FB8G0TxdX7OrWoRoHgtZW_HQ@mail.gmail.com>
Subject: Re: [PATCH] pid: cosmetic changes to alloc_pid()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3305A000B
X-Stat-Signature: rc1q9r85diq1181tdygxmmcfwo4acq8q
X-HE-Tag: 1772879523-953697
X-HE-Meta: U2FsdGVkX19t2i7Ggi1Sky2Qvg8aB7ZjHhFlZQcfJJm8Q7BvP0xkdbpP2e7Poiz6yA/qrY/dZw6sfv9KejB+bSr+fHm3zcxWFRk3/BEpMMON3if02/SQPZuBXwVsyUbdjps3juReEXp7p619/XxrDqO6zRosJpufOeNCFPEGLMDWhlXSWfSG9NQ2PqIsJeE8LGu8ahUuc3onMk53hOjQVuz8lsNOWYnuJpa7NAdKO6f8yvjNcCOVVh5ZAd+91HkEOX97kPl5MSiPNc7Higt1JcgC095S+C+jwdZrhPiFxZqpOGq8NFh8ufLWGdZqg5IvhEzWW23g22DalWy099joSkJQCmtTTcn6nu5jDr3zAJX3gkA5L0HRZzhevZTtqOBikr+kZf+v0HTl+btih3ycGkVB5y2Onhm4IhbdM4gKLRfBY4BqMgzdrluh65/7pVqQ7R9PJnZ7n4wMEHwAlvU+uPn7RqBBaiC7oFeSFe3XYux0t9rVp6N8A10aX14vav8GR+W/RS7sQCzD8zbpkEtjI7U+jMeIYtmyn9AeAPOd/pC5l9pi1XBtZxKwYBnj36WJYuUlaaN8sd4j0zyCZ1e+aaJuq2Oi5v80X9hdhRYhmjOACC6Cnk1TZw+Ek5FpD2+NQGpSocY0wa+WOE0/95KNLqcECn8ThLmzi3p/RMqpoLqhNOFF0gQEaoSqsir9dbvGrb8vnjVbDQ5nUp7w8ZwrFTma1e1vevPhO6rzFDU56byp7eolAaJ7VfNqHpQhJUPHabT4yjZpuyVghSa6BQA7mkHOQJ8g1WngmeD2mv/uAmjuOq6tt+vqSZnwg+UtkdN+PL9GVSBW0uuY3PPZLoPvuIrHsl9xtejoFkzDuouFvw3MxYqKmwudXorBUo8DRyDU+/CMOkuBZHQYTmUxF0NRvTc+zOewdR8+W8l8AJYki5s82Yo4w1FKU2T0eNts8ZBp5pcXYD/iGxiUBPN7l0O
 NXgkuR9X
 oIuiFPWtM4rPRUWKqplWh4Lx7RCRyju8P4F28EMnJzsjrj7XbOAY8Axjf4MXwUudjfb+D5vVwDq4dOXPu2wFMGTakjKeGXagBDzAgDT2IK69XTvt64p19mJPLlAlZxGWIvHcIrUoruk1ZDAWWR61rTPz3e0s5Tda5B4Za/H82Lk/LwUre5kWXOY2W+/GY02AJ2DkxKZxlZPOu7qhotxrib7TdtF29HLlF6mXKPc+B8gWDSXK45lvGfKe5uEmuOyM/OzmIK+RJsoaKXB/4ua+u0bvwEtpAf8fPE9bzN6VL35wUPGKrdECMudMRe19WpwMdwH7JUyH3ninz/dpRR3mukKP9w9+YExnk3MeiZ832FrMv/QPFvyj1aIUFNXzuMOa7/OY8DPQIniL2+s+MOpxQnV2Xiu78RQhWGQ3qqTkA9BDqOi0/7iWlpy9qD3rEDSMfjRbMBVsqzvCxO6R9/g+5gAzU7HDjpoDXHJT9AUS0QOC6nrf9TKzrNWtulqKGHtrdg2arJNMJ3LoBmmuIHth/M7bfUzWRrW3qiu6NLzi+62Rx1mJMa9lMTq0+dpUDQf+gGjot
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 7, 2026 at 10:23=E2=80=AFAM Oleg Nesterov <oleg@redhat.com> wro=
te:
>
> On 03/06, Mateusz Guzik wrote:
> >
> > Commit 6d864a1b182532e7 ("pid: only take pidmap_lock once on alloc")
> > landed v2 of the patch instead of v3. This patch remedies the problem.
> >
> > No functional changes.
> >
> > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
>
> The patch looks obviously good, but it conflicts with Pavel's
>
>         [PATCH v4 0/4] pid_namespace: make init creation more flexible
>         https://lore.kernel.org/all/20260225133229.550302-1-ptikhomirov@v=
irtuozzo.com/#t
>
> In particular, this change:
>
>  -     for (tmp =3D ns, i =3D ns->level; i >=3D 0; i--) {
>  +     for (tmp =3D ns, i =3D ns->level; i >=3D 0;) {
>
> With 2/4 from Pavel we need to decrement "i" before the ->child_reaper
> check.
>

That patch will be fine as it modifies the other loop which already
had i-- towards the end.

So I don't think there is any need to rebase.

