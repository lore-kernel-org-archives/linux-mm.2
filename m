Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF5FF99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA7E6B02AC; Sat, 18 Apr 2026 07:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AED86B02AE; Sat, 18 Apr 2026 07:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5CF6B02AF; Sat, 18 Apr 2026 07:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 381706B02AC
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:40:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4E2DE47DE
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:37 +0000 (UTC)
X-FDA: 84671484114.07.E33AB43
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id EFCAB140006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:40:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ipPzZq3w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776512436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gl517aJcU4PMdX8eaRxtC/lN2VtLqj0fIdLDkOXnkLI=;
	b=WXmpUhhol19VgFVk8ZsL96Gmf2JXIoVs07UKQBJTEe73Oy/UG9QKtf3H+djJlFUYHtMwFo
	r2faJnKsEcU3dH+X/H+rFSA0RebSc3aQo8jaq1QWIEVMHwGQFmeDpidv4YsxfglEds5cc0
	sePjkUF31piVQEHXA1/KkOxzBEc86N8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ipPzZq3w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776512436; a=rsa-sha256;
	cv=pass;
	b=4eSuFGZjtME9ZV34+6Ffxf5G5I8zRRn9Tk5SarnQMyyOx50byGCu+mj1O7CifQJD0Iod6l
	Q2QS9F3ccPiD+9Ysf0DBTMvAIdcnZtXxqRmTOCyQVhDmDFGf7mMR2Qt5NdRIZU0Z8Ch3Ud
	Mda+eHnsHrvn4pj5dcgkYUkKv5fu7Bw=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-78fc4425b6bso12802647b3.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:40:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776512435; cv=none;
        d=google.com; s=arc-20240605;
        b=BiXNFL+4WiroxcPTlh5FhuX0PySZedk/gmygaHoTGdMKhpJje4kxUvwsUPYLrJFjgW
         lURVOi6uLKIXVNEAxOighkHbgkLKu8jJzo/9fFCILhxO+ijLkFOgUQEjZsduFbdx37aj
         UG9OJnBT8jJCypBNLd6uZjJJHQX4q55IVv0/SIZRAiivDI+fSBW7BOZdJN0WXUzwbrBd
         w5ejPy3y7g3/07Lp4HKEzYxuatYkLwoVNiUi4cSAuERqdbREZDnaECWdjYSpEJJ7mbwD
         Mqt60iS+Jn868ZLFu0ucVCT8xU8HBdxJCPm6EI/wuOZd71vdU5wMKdlarUAOm7XWUN1N
         2djQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gl517aJcU4PMdX8eaRxtC/lN2VtLqj0fIdLDkOXnkLI=;
        fh=JcIlsZzQfuBfq/1XkDcyGZF0emTWhkpUafT+wzvZjoc=;
        b=exeOyeEIXJwCRqzfxt8z0V/KuM6Qq8RzknHjOv0nnIMnXCrH96OJfYgL9wH89hnJqL
         1Nv01e/vUZI6wShqrya/4C7u7hTrc3o93zeV3DqkjhTaiXo8AF6NV9LmyjnLPeUfVBZT
         eLzoywcP74xZwTb6mIV9IbRfYSekjVmaNAq860QWBopRcptKKsfUBw8RGppPIIAgiDaN
         5TZfOAV28UiWgKbmewbGlPQBkuhVv5DE1umZ+girqBh2LZ9w5BCIWZNEU0BRRT7jyGSG
         GJnlBYpMCU4a4nZ42rlMrRv278BHzPIuyOy8vQWIMWqoFNeHeSZXrvPj7/831fEJxRom
         gykQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776512435; x=1777117235; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gl517aJcU4PMdX8eaRxtC/lN2VtLqj0fIdLDkOXnkLI=;
        b=ipPzZq3wU9ijmjyHTl/2tztxx4KgTQxdNPU9aH0/9ZgA4xwU//eigQdkXx9/PVCUFR
         hbQ0Uazo8MjM2SbbgYDztxQTXsR/6/Ww2NjeinSYXCivABRyQbuQ6bcSudTritLVQwIk
         kN67upcwhKIS/4DsPS0FvW2iIFNVWztng1DShwIHFu3PoK/l5/+bd6RD5+PG2dWVoUZZ
         fqtG8fVPt0gmaUvo/T9aYcK3fce+4/DrUp0iuZRmMxD0jWzMxoz6+xpUv5Ez4ps0NoEF
         yZmEXSN7lNvpYXoT6owEPtTWzJn4mnKu2Y7r8Qr2z1iCiut6It3rhcO/KrWXBgTeRCl6
         ZraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776512435; x=1777117235;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gl517aJcU4PMdX8eaRxtC/lN2VtLqj0fIdLDkOXnkLI=;
        b=tRaje5dBErOePrt6ZAfxRROIN09KYfaIunmrAAnTxJPVceCOYGu9d0lh7py1FP7GdT
         2UPZ317VtKz4VGxMuYu29D5DrF/M/cy9AK34lolx/gUdDfFWHer0LJnqWEmc84cSUz2e
         tsf9VYozp7bfaimpLcj6EK1ZlLB9hx1ogEV70dDWhy4RR5dtmGYqQf4uPzIBhDDCXciU
         ZeXhvFoPX/Ggfq0nTtMeWLsHsEAw8UYVPB3ZK7KneBDFKdiBWW9odFfd6ZCN6CFtzDd1
         PgeFPkd1r15CAOyro+tb3KmflEgpvvrB88fG48kCO8w0HWZJx026o0MVTF+cFIk/Wo8F
         RAxA==
X-Forwarded-Encrypted: i=1; AFNElJ/ESn6bU3Hus8UrciPBVXvduoAFyRi2ZG21DLuQRvAObQ5rGs2knTj0zefkJdXiwGBrEp+91Vsp3A==@kvack.org
X-Gm-Message-State: AOJu0YxIelkiVPvJzZMzWWWj6i3GLv7cq8UsD/KFgTtu+lQ12IWeD0X/
	YhoVNCS5WCb8K2QsuzmPo5F+uxIu4IiLfBXhOYoyTcL7VUWs6dSKaqXGCIh/VAWpkpKf6NRQuUr
	8MNePmu1k7i+Lu67vb+OjgqdG+nlanv4=
X-Gm-Gg: AeBDietdxNHwnpEpxrQ1iNPtQtaqollKbZmyl2WAvpun8KQR+vO3tw8zyDEdlGEV1S6
	SWSUMnpwT74n98t51ZMwBDU7janJN+kOyFUxv9f0BnZ9B1Fm9ZiWJqnSh4fLFkWeWFgNWXEWhoa
	pJEt9U2C/ZARWOpYt5Nkc+c9NN+AKOHrV1J8aSMNGjBsfwToOlu+R5QY+8VinJNUHRbBK0O3n4i
	dAULRBqzIAinlja+U9VnCekfFuhzoP8RyAzurXUZ1BESr3HafKBA3ipDSBiUNycPsBmtV9QbAY0
	tGiai/Uo206mNUYV7RCDzmdWmg6hgQvUOeGQeq1gj8EOgM+8OGok
X-Received: by 2002:a05:690e:1349:b0:651:c128:54a5 with SMTP id
 956f58d0204a3-653107ca180mr6315370d50.4.1776512434971; Sat, 18 Apr 2026
 04:40:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260417220831.1934945-1-luca.boccassi@gmail.com>
 <20260417220831.1934945-4-luca.boccassi@gmail.com> <qwztxisl7vf3ukjqrv62msq6iaavnru2kyays6ye7rspg2uej2@62cwrsshdxfu>
In-Reply-To: <qwztxisl7vf3ukjqrv62msq6iaavnru2kyays6ye7rspg2uej2@62cwrsshdxfu>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Sat, 18 Apr 2026 12:40:23 +0100
X-Gm-Features: AQROBzBTqS41n0peew3A6sLX8jfBm27PBzQwb6HocYnw3czGZM1VNVC-vDu5Icc
Message-ID: <CAMw=ZnRXYjjuqVBbNOn5aQM9MTmXsizz1ZgfebnunMadPTc4tw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org, brauner@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EFCAB140006
X-Stat-Signature: qzi5o6u5m986dm3c57xbp6fz94h57yop
X-Rspam-User: 
X-HE-Tag: 1776512435-332291
X-HE-Meta: U2FsdGVkX1/c+WdY1P52gVvLS1C8qYQdNCquWryQMRxtpuhxQ2+pSR5DbToy/XaludJU91Cjxg6sp3hPnDAyJapsUHNbowhuhmMpuNqR+pC8auJWk18AooEYrzph2JWjT0/+DPaA7nIgZVx27159hfzkwGHAl3IAkyObWt9DB4BROCK41gRKNaifwVH+M9mrtz4PCjYu8OVo81pThGh6xwae4e1uB60QNRVvN66YZFT4Ud7Iirq4yuf9Y4ks2y46eckEBZEHDdYmoGjecGHvTtsUQTBBG1sBxM2+LKo6WRSjU0zJ4BGlL+0yfya3/ToYUO7jVQGciKLXd5Bf6xLnEurtJNYpwHwnAFQdwKRGIh0t0dxrf3GikT4iI/57w9IX48uHQs7BTFkwyNTRheSDJICXdJQ9a8PrQ8S+nQRCMpQzlFH0IgGLUIpV4bFENdY39qt1GPFBKYf0B+5Tt75zgiXEBkKGZIdh7R4pfM32CmxmtjbfgALbbIYczjn0alfeb0vMsZedcYhs11ClycSYZTNEfpGlz0018cPRHw2Txq8oDytmbGds7ET8BqZr/oDSzrhra9yqA1wkAUdnQMdtjUxXg6LofTOFUjM7yjE1joszRThLv7/pzG8wLtprYaiNeb6Orim4iMs8ZzzYQRFKZ50aFhPI3xHn2UI4R9Z0yary3BhkeT1ktw2cQd3LGEnSpsWrpzxi57cY6/iTM5TK7BJ3ULYCl1zvhGNnp71vFiUn5m03STHjXoeCYEEx3gHsEXR+XdyfiuKv5zGaUYOOJKPGtlTaExZ5mWMdm45Y8hMNlk1rcQjX/z90VEPDSUJQDp+4XED8T/OVYuinfeXgLlUsg3+rVUV0FCJEZv/xcsGJMCgWjYWDwB8p+HexBtY8YFxUAY+YRbXuVESYY2dPcGQfIVAY87FH3qN5nF59Tj5+2kZYyfgBotP+MwDjLhLoPQ+l41+vDKWIH2p+uzF
 sV+c5qKc
 q3W1zqF7sI98cyRxZvkIse/I6gCf2f44qtuyBltcq/mreSzDryD2skGcP5t/FN3ykJk1NKkf6W7y0aeDsQ+6PhXqbXOKpn68+0t8d+VVye4hF3M820l13651PoUbEvvUC3yP1RlgO1gBEf670C+KBB4/mu4OcXwDXYEsD7GZ8J+PNFdzZJvKB5KtKOmHfMlIXlfReHWoh5jtC7t3zyzvuWQ5UFv7XFId0vQ9XdTIcbyz2T5gkXBOnCYIpHxhv978Dbl1LwQJqgIrDELMrtWN948JorNdqxxN2m30AUjqcbcP7WYLI98p6hZWdIEcnf1awpE92K+XhvkioKbCHJCtnwj12SAJoHZWx70lDJo2kFhykdGIviSNJkxYCItdHTgVuuLv5TweBvUMqYnD3W1QTFoBk1J9iAApyxJq9XbulZSyu8M0hMfLycbYlOqE9GcrskcrJwbY8QZ6IFX30lBekFW2qNmZseC5m39Vrd77AwArVDIIbNc8sTg8u/ER3h+0m+UAGbSUfM7UH1CeepjdpDRV8kTfH65BlXE9xOKKlffsO58eq1EeoG+yZXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 18 Apr 2026 at 05:17, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>
> On 04-17 23:05, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@gmail.com>
>
> The commit log is too empty. Please explain what this patch does.
>
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > ---
> > v5: merge with LUO_SESSION_MAGIC series as they both change the same
> >     unit test file, to avoid merge conflicts
> >     split into separate patch
> >
> >  .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
> >  1 file changed, 71 insertions(+)
> >
> > diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> > index d132b4685f767..f81201b363cc1 100644
> > --- a/tools/testing/selftests/liveupdate/liveupdate.c
> > +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> > @@ -105,6 +105,22 @@ static int create_session(int lu_fd, const char *name)
> >       return args.fd;
> >  }
> >
> > +/* Helper function to get a session name via ioctl. */
> > +static int get_session_name(int session_fd, char *name, size_t name_len)
> > +{
> > +     struct liveupdate_session_get_name args = {};
> > +
> > +     args.size = sizeof(args);
> > +
> > +     if (ioctl(session_fd, LIVEUPDATE_SESSION_GET_NAME, &args))
> > +             return -errno;
> > +
> > +     strncpy(name, (char *)args.name, name_len - 1);
> > +     name[name_len - 1] = '\0';
> > +
> > +     return 0;
> > +}
> > +
> >  /*
> >   * Test Case: Create Duplicate Session
> >   *
> > @@ -385,4 +401,59 @@ TEST_F(liveupdate_device, session_fstat)
> >       ASSERT_EQ(close(session_fd2), 0);
> >  }
> >
> > +/*
> > + * Test Case: Get Session Name
> > + *
> > + * Verifies that the full session name can be retrieved from a session file
> > + * descriptor via ioctl.
> > + */
> > +TEST_F(liveupdate_device, get_session_name)
> > +{
> > +     char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
> > +     const char *session_name = "get-name-test-session";
> > +     int session_fd;
> > +
> > +     self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> > +     if (self->fd1 < 0 && errno == ENOENT)
> > +             SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> > +     ASSERT_GE(self->fd1, 0);
> > +
> > +     session_fd = create_session(self->fd1, session_name);
> > +     ASSERT_GE(session_fd, 0);
> > +
> > +     ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
> > +     ASSERT_STREQ(name_buf, session_name);
> > +
> > +     ASSERT_EQ(close(session_fd), 0);
> > +}
> > +
> > +/*
> > + * Test Case: Get Session Name at Maximum Length
> > + *
> > + * Verifies that a session name using the full LIVEUPDATE_SESSION_NAME_LENGTH
> > + * (minus the null terminator) can be correctly retrieved.
> > + */
> > +TEST_F(liveupdate_device, get_session_name_max_length)
> > +{
> > +     char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
> > +     char long_name[LIVEUPDATE_SESSION_NAME_LENGTH];
> > +     int session_fd;
> > +
> > +     memset(long_name, 'A', sizeof(long_name) - 1);
> > +     long_name[sizeof(long_name) - 1] = '\0';
> > +
> > +     self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> > +     if (self->fd1 < 0 && errno == ENOENT)
> > +             SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> > +     ASSERT_GE(self->fd1, 0);
> > +
> > +     session_fd = create_session(self->fd1, long_name);
> > +     ASSERT_GE(session_fd, 0);
> > +
> > +     ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
> > +     ASSERT_STREQ(name_buf, long_name);
> > +
> > +     ASSERT_EQ(close(session_fd), 0);
>
> May be add a few more edge cases: i.e. no '\0' termination name, or empty
> string session name?

All fixed in v6, thanks

