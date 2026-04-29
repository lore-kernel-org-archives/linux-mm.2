Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070EDFF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFF96B009D; Wed, 29 Apr 2026 17:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0B96B009E; Wed, 29 Apr 2026 17:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6466B009F; Wed, 29 Apr 2026 17:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BAF36B009D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:23:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC1861401D7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:23:20 +0000 (UTC)
X-FDA: 84712869360.20.08E4CC1
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBCD6180004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:23:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MO1xwi1c;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iD+JgyZ1kFui708npPl3N3ndnfNMh1rEfRmYOE4MJj4=;
	b=Ajoy7aw6suEbU3YDWsf60tFWugbDpRdF+tZfYVq/W/4pn0N+lGdctLKULMnsCTxOBURJT2
	JCHl8JCuGJtpmdJ2spaOQpUFl9jQtwwPm7ddKRpccwL1c32Fe9wCRn3Ps0HKVlHhjAeLr3
	LCdAUwbwjjzuJBTWamzbMAwPLsyw0X4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MO1xwi1c;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777497799; a=rsa-sha256;
	cv=pass;
	b=xGJE99PofjE4cA0R2bBLWeORhrgtJbI4TobSl/IbZCyVvT7kbqnumlyAqXgBWbrkLGx6D4
	xlQCE2ahoAW2xBmeBfpmMc1/VGjo8mPZlg7Db1x2P2BSKoI0+wgP7sQ7EMSK1WOpQT9x5u
	HLj7h0iB0vKzAszyhJ3BF/gWxExRRBI=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-651c366f7efso248430d50.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:23:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777497798; cv=none;
        d=google.com; s=arc-20240605;
        b=KGsAWUzVdm1f+i1LMN+iP2tHhv3ApIV6qwlxMF0pXAzV2GO7WZYEtEUdz/yWFvIaG4
         f9X/nIH2AB3l0rJclRHX4NwyigPmB3DygrED4ozlLmCUMZ8pGYlWnmo4h4Tj4Qhc8ttW
         SLysPF1f4LK/ZSEQYAOIsRwR+rbUb9WmggvSAV/KfUlSCA1UMzXaFP1ibP/ytFAIzUf4
         vt7NVMdJKz9tiy/7J88FGr3+nbv/y5wY5htDrrHEF0XOpZs+O5KNpssuQGmzQ1C6GDzs
         kUCEUTNiryHR74gDvuACKrjzHv4JvzmwKOI0c5X3SnxLRGINeWFragI9oP5yg0TV0YFm
         I+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iD+JgyZ1kFui708npPl3N3ndnfNMh1rEfRmYOE4MJj4=;
        fh=/BCk806OV0HfW/1QYI5NKaB5+e81Ue7z2IP3CxajZk0=;
        b=SN+J8xMpcRqJQ2Vmti9vqD92wZcGOw1SgI6jy9obUztL8Jpe+b0oOp7QGZm1SRwO6x
         dRSBiaN0P0dDo9+XTbxffVZD1217Z07dVSLKINiBxij/i1sD0cqfigQYYJoTApez+CeR
         WBJUisApRFm3mwPMSyjZp+HRl5WrmPMrQDeyxkR3uweOnTU3csGXkXBYNqEhBNe5BEJe
         grZqlnLWZlqesGfr+6rtfmPGO0E7j5mnYEdlDYywA4mqVAze+Y9T8fb2ub2dM7ErEpx/
         cYKmBXEYpQO1hbA0W+LHzy+lcLpAe3rAlQmLnhiGcLy9R1rY9wQkhq2Zy7rPKhH9J3aT
         LiSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777497798; x=1778102598; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iD+JgyZ1kFui708npPl3N3ndnfNMh1rEfRmYOE4MJj4=;
        b=MO1xwi1cDDDyKZb9AA9I7o87b1rPwLkdhw1ldCXISQ6WnDqDWWeeB/nbxUvzXT9TYj
         LYQZb4RSwB2tgCwC4RHmEQMUctgoiXU/dzGSRfhFGXQBzP/uOIdxZmTTKMzJoJxrGHet
         4BDGsT/8AbBBlFMHMLKsX1VQ5Ml3Ud0ZASqy+9rYrPal+OzZLFJGyfA/KBTIqOZaUei9
         5ZtR8MwGZdfpjSTRHDlvHpgLT0lD0+ITN1wDR50nVu5mtGUTCubVtiHzqf0qbPNDJIN7
         RDNBUljNT8ENLLGOenUMWeGUH1lUHIWRjtAEaaN8+YtFvuQzNYIGuY4Nv4M9vrYD+dzv
         uWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777497798; x=1778102598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iD+JgyZ1kFui708npPl3N3ndnfNMh1rEfRmYOE4MJj4=;
        b=EpJ7ydsDNP83eTxvF2y7RarslO7dShYrfFCtmTlWtaTcGS98RyRJ4z59fgqCaON3iE
         m3s6MGNV6PmjSpQQhfL3jGzlIGb5fDU1lvBpr0f8R60QdUvAS85OYaE1qeuiXPnaXmDI
         KnO+1aBK7843z5DpDApVlXXNrryuQNW92v5fHhoBRE5JVZkOiBIAwe7hj3jQflXszZjs
         0zrYBHa74c3nNhhBqR82iZo7vK5BI7Y8WCGCCATrNY5+RnhxE4jtAv49E/ReEf25PEXA
         PRvpjc0ajtfw2O9Um6/c6mEPcZISW2i65ugj0b1ydRweSOsFudJZJXQn5vG9UV2wZjxT
         Fblg==
X-Forwarded-Encrypted: i=1; AFNElJ838YWpuqlK1SbAJUmZAMy8AxpFTlAwdfP6jgpMHXUwQJdClMLMzQGvZizFS/T2nHGOzkpt9ua0+w==@kvack.org
X-Gm-Message-State: AOJu0YzUQbM/Egp0untLgpL8+hD/u0DPsP2j3xz4PuY+0HS7aG36FoOm
	qzZ2SpHJ9F4IjdV+P2TtihlECz4L5OaQjwBmpOQcw5JYlSH3aYo1x3/56Dmy9QBNTzmDC0uotXQ
	egWMKJxvR6sp1XrX4A+J7XGgKwqZJQr0=
X-Gm-Gg: AeBDieu9YN55ApR0lJktWS1RPbPqN9eDUgYZiK9gEIVOBBRVgZobIWVhOCDITh747rn
	MSaGNFjgy889OiSXxjWm0z1Iis7ylOb4I1nWxewHWdbR80Ye5dTFotgUrlvESWfkHrAvt9Z8ZF3
	7oGGgX8r1R0g4gQzH5hI0b6yG5Zn4cGACVD36UlqnVgmSA2XwPGUvv1AnHF93pUHRJuoSYnRR+L
	eLiTIdYBhj6u9AyyoQkXrSGPb9sxQh42CSTuxq3LTD3g52i6J6miz3qePd/mO2I74gdUf/53ZO6
	FNcWf7naPmG6AWILjVftVh+d9BtIyd39VuoJr+tBkh/uvWLkA44dkU+ukUqXdKo=
X-Received: by 2002:a53:d059:0:20b0:657:e42c:ed01 with SMTP id
 956f58d0204a3-65c18f47ddfmr17777d50.50.1777497797960; Wed, 29 Apr 2026
 14:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
 <20260423234753.3873095-4-luca.boccassi@gmail.com> <2vxz1pfx4yxk.fsf@kernel.org>
In-Reply-To: <2vxz1pfx4yxk.fsf@kernel.org>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Wed, 29 Apr 2026 22:23:07 +0100
X-Gm-Features: AVHnY4Ivtpx7aa0gXmToc851I5UQ09wVjAcX9BsvF4cWKvg3LGIFCeYqlWO3iFc
Message-ID: <CAMw=ZnTbAZh0t3djk7F49z8fDRZLMtPbBVchh_rJAq9aQ41H7Q@mail.gmail.com>
Subject: Re: [PATCH v10 3/4] liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
To: Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, rppt@kernel.org, 
	pasha.tatashin@soleen.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EBCD6180004
X-Stat-Signature: jh87znqw1upeba5x95mxxq46mqosxzx4
X-HE-Tag: 1777497798-308579
X-HE-Meta: U2FsdGVkX185TFEM6HejiiZdmWeijACbO7rVxoGu8cP/2cTlKK+HS4GKOUaAb+8DkICQlJQu5waXkIg5087uXS7Yj6Z2nHNSWagM5/3jCHZLQY7UaIm4NxLLGEXZWwHhOkVvcFXwgf4uuiWAGXPygHzWjGOb6jHMFZAsOZvGlzFjS/aWIvrxq+g/GMQnUci4js6PhGkD/Ld/Uyv15CH/rTkpAGHW9TIPXX+2C5SEHT4q5/U+B3qHH/e+e93NPLG4JmM1czs1Ne/s+hjqw6eBvCfIyuAHDeEJwNYMc/HGOnGtywrTzoOmY4P0XjUPaN5l1k40aoicWb6myGQwvKWXozMZS0R6PbusZZgzhnt0zEP9plaFROOZol61LVm+w3ht50lQPdmP9GavnxSxJSoOHZgJa7zX+b+LtMIKX4ihku60UsSa141ohuCtcqrVcJwdHrH5r14EYp19VsfqtJV4e7g3/uSNZ6yVQ/lGVNgm2CRdCt70gy5mZtTkBFW+yBJukPxwsKviNoWYA/GAiBFc4wxhXNBUwWzSe+TmrE+gibLJ5LGHFkEjAV0RE53H9MkkCtaSGx3rruD1OiarzuGANXNTLTqqUtIaZTvSle6alAdQtfUfFQlYsVsPOQtRoaEIfgSPGyc/frHoKXrstnF5ArD76geg+HYjYUIipP5mS7AkMCzieuqKECejWsHOl6TlCZZIlMahhr7xhEzeBm3DWBasRupXHg6Wmhozx4PGJ3xXv2Jfgh0nOEn1SpFWqh8GThCG6CROp7NqIcXhsUAhYDWaU4w91DzpY6nTK+lcctwlQkvYI1JO8IseiTvzYJOsz3VyF8+d7prPp7VkaVnuXgFi+TRELq6AvK8/nSOIJbNYirapxvPHMElX8SvsZtWemQRIQNqkOZKTu3t8EhmRFN5IvcYQ8pti57Ra5B/J8mMpICr+eso7VQ8tpZiUzLtYxvHsrbeHtylVbyo/XW7
 jveoNoPG
 0L86dJiSN6dqy0tsWyGokxiOI0OOnw1OUdCnLekbs40pR80xtaiL0jlYOBLvbzxKusJgQ0CQptepk/a082YnejrIlJfiyk4UHZlAzw2v8gw/lygpsELi8cB1xAvTMxuKEtnWV8RZSHGkObRoqAiZCH+urKQUL6DM9GZvpTb+OOky1q77PgFkNMWWV7VQbBH3iCsikxMHDhp8F8hAupDhlFNG1x1rruXtAvrGCCMPEVPpar3N5xlCq05YunImmlnh27a7hOI24Zz3AEhvvYV1JrkFCFCZDWSVQ85jCvGlyRLz8+Wg/f/Cpqoc8gScAHK8Wh9utQ0t3gn/zLWnGMwc68SxxXFH8to+kHVVgtk9QXFBDEc9c9bCd2rBnH+omHoDJLTJhOXrGE3CWO4LYFgC8/GeuGKDg/f3piLcYuJRASfKuKJ/E/xFPDDj0yE0HaSO5sKKypU+JAqK6rrMrQTssW1T3uGU/hh9y4qbUR4ipCjjz4qQnW9mv4gkcI4wnuXYXYyUSa6kwUDgh06NKRQ8WC7YsqCQau2af1SmHcdh3Jv1+Vx8XXGKc6tVFR2mdJqi0GzHQXM5Lo/Yqmgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 at 15:35, Pratyush Yadav <pratyush@kernel.org> wrote:
>
> On Fri, Apr 24 2026, luca.boccassi@gmail.com wrote:
>
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > Userspace when requesting a session via the ioctl specifies a name and
> > gets a FD, but then there is no ioctl to go back the other way and get
> > the name given a LUO session FD. This is problematic especially when
> > there is a userspace orchestrator that wants to check what FDs it is
> > handling for clients without having to do manual string scraping of
> > procfs, or without procfs at all.
> >
> > Add a ioctl to simply get the name from an FD.
> >
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  include/uapi/linux/liveupdate.h | 21 +++++++++++++++++++++
> >  kernel/liveupdate/luo_session.c | 13 +++++++++++++
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> > index 30bc66ee9436..3a9ff53b02e0 100644
> > --- a/include/uapi/linux/liveupdate.h
> > +++ b/include/uapi/linux/liveupdate.h
> > @@ -59,6 +59,7 @@ enum {
> >       LIVEUPDATE_CMD_SESSION_PRESERVE_FD = LIVEUPDATE_CMD_SESSION_BASE,
> >       LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
> >       LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
> > +     LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
> >  };
> >
> >  /**
> > @@ -213,4 +214,24 @@ struct liveupdate_session_finish {
> >  #define LIVEUPDATE_SESSION_FINISH                                    \
> >       _IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FINISH)
> >
> > +/**
> > + * struct liveupdate_session_get_name - ioctl(LIVEUPDATE_SESSION_GET_NAME)
> > + * @size:  Input; sizeof(struct liveupdate_session_get_name)
> > + * @reserved: Input; Must be zero. Reserved for future use.
>
> You need to enforce this in luo_session_get_name(). Otherwise some
> userspace might try to get clever and stash some data here. Then if we
> ever put something else here it will break that userspace.
>
> With this fixed,
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Sure, fixed in v11

