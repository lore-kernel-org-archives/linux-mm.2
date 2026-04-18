Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C81F8F99C88
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 16:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28FC36B02D6; Sat, 18 Apr 2026 12:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2661D6B02D8; Sat, 18 Apr 2026 12:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155AD6B02D9; Sat, 18 Apr 2026 12:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 003646B02D6
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:34:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6AD61B8100
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:45 +0000 (UTC)
X-FDA: 84672225330.26.198177C
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id C10A018000F
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:34:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="f/Ho2v8Q";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776530083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oY/tcRSmcBh5sFFcI4oYCHuxEtlx4elQ3E5wFdMf14=;
	b=WVN58+y3Y8EMXi/VnjcQKpItDagwCruszJguiXzVP9wFnBTl6PG+ZjSxu3tMbYrAD6WGWd
	NRH71SdjJMcUJi9vqFmTO3eYXpAnoAGGbq6lRMa6TM2fpC/U96Nuuac3wXHBhrMSN7pgr/
	4dOUvDSv6WICsSzGysQAFkNPKAJUSgU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776530083; a=rsa-sha256;
	cv=pass;
	b=DbJzzZTen2+w9qMVlfthJnydXm4nGTHvZTXTxkpOZjR949s0zkk36h+5Kfry5GwczO+LYS
	qYFVraP9ZGIuIxGOp4mdoEStoFERkCQAQ0l2yr83/iHQsK5Nc9IedFgr7y1Rvmv0GchqUW
	daakHDe4KSPZz5zTOVrLeuIPlQ2SNik=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="f/Ho2v8Q";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-652f220595fso1730205d50.0
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:34:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776530083; cv=none;
        d=google.com; s=arc-20240605;
        b=fppRPVB+nnVmLAx6ect7F3wMF7Vo1sQw+X5/MER3RHSOWH7/hLf4hAMGohNi0czTWA
         ADVSgNWA7Bs91wdaXgLuX1aezYWdOO1FmmZvI1oyexbHP1clBtvUnwASFpKOwhBp+RFH
         /VUU5LKLTNBHwhaDuvupnTESepb5TntAOTDe006l3a/a7LLo6bK4p5giSggfxRlN9I38
         umtWi8RbeYL54eU19ZjD4ZXtTjzcxcYF681faXv4l1Zvipgz+bMVmHV7cRDZOUon4lQU
         PZydqaymERsKlcTiSkk15kF/b+mGApDUzWIHy3KeAbkZaEN0dacgxX4Z17PNP7a9gGBV
         KKBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2oY/tcRSmcBh5sFFcI4oYCHuxEtlx4elQ3E5wFdMf14=;
        fh=4KUYc7lTuRu9kyxl0pRAEYTRFgKwV40YP500OVXBmXc=;
        b=jZNP/FhtUaWeuYLmVzrbdAbNUZOKWvf36aaPFxzcImLRMo8P4BG2x8RvkF6+J/HzSo
         /cPCEBNkMfw4Wr+oAnIxOZQtA0voPqsRkGpoSDuuiXntQcaWP0xn/DVvxctK0aAGX2+p
         /fDVnqjVT3awHQZD2V7pQMi5c4AvHBkAZKq7vEGz9U2HdBuMwA+wDBSPliC23a7dH816
         2qgiDqaZKaSJ8vzWMI59UYzA4EEGDWjIiEZRGSpevb7+3hMg9iD0y/E4Nz7zPanQFcJ1
         a16HsHV7n8VliuckXcnJb3kPPJWD9ygcwmALAjlmlEBS1vjyXXQYgx/TvxFv/Bz8xbq5
         OaFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776530083; x=1777134883; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2oY/tcRSmcBh5sFFcI4oYCHuxEtlx4elQ3E5wFdMf14=;
        b=f/Ho2v8Q/vyTpzl6xA+R0UBTdHMvXWSmVWSOvdwOZ1g/nosllKmCN/ZhaKhvK+hT/7
         H5VcQNQp+TDGmUZOUoHkBXzoK6J4EGXEkLOZ/cKSnPnAmNgpy924oWvOqtO8irnvpDKj
         nW4ATo5XbzrillQ8Ttg6r3ziNFfJwlF+wbTFGLEeG8712gcw/EuMWF7Fclf3CyqDwiUy
         BPgb97govwEc2A05W/pMW4xwKnYhSqBRbVae/m9SosyTjDFhmrqp3zLzP4gCso6J3Piw
         PomR4A4jvWnzmdIs1i1HUvfsF5XVK+f+05Lc0UR8mexeMqB7LBruBUGP6fIjVFc8eepj
         JMLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776530083; x=1777134883;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2oY/tcRSmcBh5sFFcI4oYCHuxEtlx4elQ3E5wFdMf14=;
        b=tPL3VvD2MDyXNYiuiv33I53ESu4BAqWaQVEZPAcFWGbRYS/1kIxc26sAHwF/QBzDj5
         sVefjrn0vaCXjr5kGIpxt2Att0pvV5C/TH47vBySDNmkcDV4ltN/ta+t++oE3aaTSkwt
         kDuT2tzCX+EYBYZOk/++j8pBkHyd9AzuZxZ4G+bzR3hoWuTXLAU3Du+v6u1gbZUfO0us
         zdhuy6cC5oWowJ/FudgWvvCvnKRQAGNFtS1N7kvv5A1ThDvAApE43pFcImanJQLciMle
         drsRy2weZzu+wqJ+dyat4F0v0toK1sGsyvknE7hfm8kuv2pTfi9VDdpgTWZb6jZTtR0c
         xkNg==
X-Forwarded-Encrypted: i=1; AFNElJ/Ewjy3c1xpbQaiJ9fgURGPS7IuTZlGzD28GBr3g/ktoLhvXE0286ta1BmGDVz5ILHTDL3OoZuTmA==@kvack.org
X-Gm-Message-State: AOJu0YxJqO4w3mcfbgjViRQELHxyp1sOKX1qjK5gMDtEHlHDa83VzEL3
	d5M0chl1TSS5ZXeTHq868jCaBdGLpwSxRE7EjoRPH2ubR8nSSPtaWHl2OpzSO2iNBsccUNKbEL7
	qMjenoUbRi8jqhKKtTdNcvac8nbDTvPQ=
X-Gm-Gg: AeBDievreV4Qn9KI608Tbl6yQB2WwDAEx2KcTT/9AzqGo49WiPrwN4ZYqYCLmncwfiw
	iLPRurSgUTQM8IL3sP5DDGCkvpCcQTQ81D7JQBaZM2jOvSOviVgQrBjOsgdJuPk1+FLYDVczQFW
	hhwzFH2zWttyXxU5qs6QrZSl1+wULcew+/fOlHbxH1J9J9dhHtY2Pdp42+tCt22XfQQ5vurH6Pp
	gRW5vZakZwF8g25lCd8gTzXtCDOf/+EAJBKLvu3jPLIi4uGidPnrH7NZipJr+x79trslhqgL7mD
	W803LZcvIM+tgJfRLanYUPnQDKy4NEBjbGU92SEa2KHuckcSaInBj9+kEOEB0Ow=
X-Received: by 2002:a53:b446:0:b0:651:d0a5:ce2 with SMTP id
 956f58d0204a3-65310a8a93fmr4803705d50.60.1776530082712; Sat, 18 Apr 2026
 09:34:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260418141123.2193917-1-luca.boccassi@gmail.com>
 <20260418141123.2193917-4-luca.boccassi@gmail.com> <a4jd64pkvamnwuwzu5k762rgn6sgzp6ldcoknkwhuddsrwcbyv@vxwdpp66x7bl>
In-Reply-To: <a4jd64pkvamnwuwzu5k762rgn6sgzp6ldcoknkwhuddsrwcbyv@vxwdpp66x7bl>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Sat, 18 Apr 2026 17:34:30 +0100
X-Gm-Features: AQROBzAFi32dl83y4vi-iHBtoXR9NASEP_4UGJj7Oe0Bi3My32Y9WO4b3xObtKU
Message-ID: <CAMw=ZnS4+TjxYN2KB4sejwwU5n95O4TBVRESq0PxbbdiSP3iKg@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org, brauner@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: w1d5ga6naei17at4kn4x136gsoktugkf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C10A018000F
X-Rspam-User: 
X-HE-Tag: 1776530083-378423
X-HE-Meta: U2FsdGVkX1/GdDuSudNpAv7ugHWJ1UpC3O3+YE51fhdT/UduFe8Du+4831iv9cJVN28up+zV5+8yubrY3OgMuqQkCe9+cCZsnG5qoobuVCEoLUk+JZFKfjwVOE1whyEsTTUhsFsOoZRLeRXoSd8xdmY2/Wuw5KPEeSRB436Gx21q4mtarZxQHyK+x0PSwkNuk3C9YrQ8WjZvnwmV/T4kHxvV3aV9zv22YUZvc5eRTLPjkQgEiySvyJIhzbDRwSEnINXeWIcNGBv6drXHuTZ7IeeKNOga0eWhBrYU6PbcBen8ro5PyDug5Qs/PJgL6/3nKgnBzPF0Zp+qazHrj0OIte8nzYCMQxDh961id4BXclqtlTOb4RSZczzcShemQeMVGDrEh9ksHT2Z0yydsuMBbOp2EDo/WkWINwABpLuSdaPcGvxM0OtU71ijno3oGP4fIE1OWOLPPTDajaHuw0t7rZDIznkuRVw+IWRKbVl5hHSt4uiatP0JahNlRbW2BRQpigKSxOIX8yiIt/zY60xH26lX8v2yrJkzlnYFOfK9gtrs9jWaYCi+Q9uWiyN07BYquHlQtJ3CCboZGKZ/jxZEow6pKEGP/hUmurvKy29Tbu2W+CGpw1mzFvkiSK3PwSSmMbFlVuWOEJep/0gObOk3mmHZbgC3jAlFm3iqklagXkwlSTLA21+ii2B5Fcb/bn7hW5XzGy+VDBensP64kr96gwggjji/eWb8CqZvZ7MIxA29v0Qd90mPKZnolQ57bx/7BtTyc/le8g450t7NnZE6wzO9wITDQ6Qvh7lqTNCYn8b5LlVf+CBMHMZYiZTywAuepqi1dPDDWuqGXsp0jbiFJ9q56NZs6SYtsMBCNjkiLbE85EIO8g3EJBxHaPuyiSylmz+57wdjun8pmeaiSbp7yjBggDs4do84GPolOiMah+QJ0+buLJUi0LOr4RQRp/ZiR8MUe1Y7mW5HT9TWdiF
 Nzbof4Z8
 HW2DxDj9pZsfQJhhTOvb3Z8+/MOcUrKG+YxxdE+CsOvxtaaTwjAO0j2q6WmQuhcgz6wO/GKnm0AmaMQrk0ZXL3Eq4sPbPXYJZKr5H62Xr8laDp9Z6P817oPfuP5nyOxL0wxID6edZVvcqCKhsqpREWrxL/2GLs9M2QR60q4ZiMakTxZuwdoMHPvXloKB3cJUhPlH8ZxUcr0ytjeA/aN66Tn4gVe+g0lishWYN2clvMDG90DZaDHaPmb4oKxtrLG5JPi6iSpNZoTe/10l0gz0YOohpFSwfZzWjXF0orwhBOVYkyWGjOg0QanE0tLMr0tm/ZF5b475a3IBQubrQHkfUruXttxUfBxVXXnpHRDfZQSlK2Nvz3MAcpB4aNNRMvHd3e4CbWz/raLU9wXU6utn4+B3cdPgfkcwE7IFJ7MA6GGZoaHyx6kbrj0p0P2DNFIONrBL1pjmG0D+VkceUMrdDH9ItPNjjyX61h43CIKH886Bw/5f7DVRMaeewWWVGvv65dHgVgr8et+no3zmYV2My8Y+E7GAWlHiRLpZ1GBO8eytUShkl/DWh9IOMoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 18 Apr 2026 at 16:50, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
>
> On 04-18 15:09, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > Verify that the new LIVEUPDATE_SESSION_GET_NAME ioctl works
> > as expected via new test cases in the existing liveupdate selftest.
> >
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > ---
> > v5: merge with LUO_SESSION_MAGIC series as they both change the same
> >     unit test file, to avoid merge conflicts
> >     split into separate patch
> > v6: add more test cases as suggested
> >     more verbose commit message
> >
> >  .../testing/selftests/liveupdate/liveupdate.c | 138 ++++++++++++++++++
> >  1 file changed, 138 insertions(+)
> >
> > diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> > index d132b4685f76..ffbcbd465c9b 100644
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
> > @@ -385,4 +401,126 @@ TEST_F(liveupdate_device, session_fstat)
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
> > +}
> > +
> > +/*
> > + * Test Case: Create Session with No Null Termination
> > + *
> > + * Verifies that filling the entire 64-byte name field with non-null characters
> > + * (no '\0' terminator) is handled safely by the kernel. The kernel's strscpy
> > + * truncates to 63 characters, which we verify via get_session_name.
>
> [...]
>
> > + */
> > +TEST_F(liveupdate_device, create_session_no_null_termination)
> > +{
> > +     struct liveupdate_ioctl_create_session args = {};
> > +     char expected_name[LIVEUPDATE_SESSION_NAME_LENGTH];
> > +     char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
> > +     int session_fd;
> > +
> > +     self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> > +     if (self->fd1 < 0 && errno == ENOENT)
> > +             SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> > +     ASSERT_GE(self->fd1, 0);
> > +
> > +     /* Fill entire name field with 'X', no null terminator */
> > +     args.size = sizeof(args);
> > +     memset(args.name, 'X', sizeof(args.name));
> > +
> > +     ASSERT_EQ(ioctl(self->fd1, LIVEUPDATE_IOCTL_CREATE_SESSION, &args), 0);
> > +     session_fd = args.fd;
> > +     ASSERT_GE(session_fd, 0);
> > +
> > +     /* Kernel should have truncated to 63 chars + '\0' */
> > +     memset(expected_name, 'X', sizeof(expected_name) - 1);
> > +     expected_name[sizeof(expected_name) - 1] = '\0';
> > +
> > +     ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
> > +     ASSERT_STREQ(name_buf, expected_name);
> > +
> > +     ASSERT_EQ(close(session_fd), 0);
> > +}
> > +
> > +/*
> > + * Test Case: Create Session with Empty Name
> > + *
> > + * Verifies that creating a session with an empty string name succeeds,
> > + * and that creating a second session with the same empty name fails
> > + * with EEXIST.
> > + */
>
> For the two cases mentioned above, we should implement a fix in the
> kernel:
>
> In luo_session_create(), we should verify that the name is at least 1
> character long and at most LIVEUPDATE_SESSION_NAME_LENGTH - 1.
>
> size_t len = strnlen(name, LIVEUPDATE_SESSION_NAME_LENGTH);
>
> if (!len || len > LIVEUPDATE_SESSION_NAME_LENGTH - 1)
>    return -EINVAL;
>
> This change should be submitted as a separate patch in your series.
>
> Additionally, please include a cover letter in the next version
> explaining the overall series. Once the cover letter is included, you
> can remove the individual patch versions from the stat areas.
>
> Pasha

Ok, all done in v8, thanks

