Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599F910F92E6
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6773C6B008C; Tue, 31 Mar 2026 14:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627FF6B0095; Tue, 31 Mar 2026 14:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF4D6B0096; Tue, 31 Mar 2026 14:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 383186B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:21:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B6235841E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:21:53 +0000 (UTC)
X-FDA: 84607176906.04.6636EAE
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 34F364000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:21:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ToHGBE9Z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774981311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Z1ZTwUnghvA4wZBFW7neJ+hQNBTpYfH4OG7mwECm/M=;
	b=p5J3VKGtLsO+WnTljQlNPZkJb3GlmZGZYQxoB/RYi54qQjXtLIAYh9G0GChgjig07u1Xta
	QDRoTfUlaPjvdcJzPbb+JgrUy8EDAfu4uLwRoe7pAXhd0OLaICDXJd6qGVrcHZySs/vHr9
	/BPJlPwo4FaEiUktrVZd7UP5k2R1peo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774981311; a=rsa-sha256;
	cv=pass;
	b=w8x2oyB5XanBBkUZaQHG2GNhJFIhyXf0Au05GBlxz5T8msef5ETbt4OSnTavzzwbyznB1W
	Y4lwkRCCWWZT6bnEP3gLA4V2deUdJFK1YQL8mON/q7cxwFBxcMyITkMFvMEQH8QPOf+BUN
	4mqjBXfq1fSXaE3i1BRH4LKPNQgcknA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ToHGBE9Z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso8247109a12.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:21:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774981309; cv=none;
        d=google.com; s=arc-20240605;
        b=GmgN3zriaxQsfPVLJrmQt/uq0zSnNk5apr6RiHHlRQU6H+lCn/+dIW8ruV1ljmwTVN
         qCqV2zCLHZa3jrDQ5CNTRS/BXDukq2XrCCGbzANYdxJwfyIznjDsIKpouXF19znRBPhx
         saqwuNld4Ym8Jktb5IXKBwzatZUs+HkY1g2Nb6mYgRKPqusrcONMmn1Qu2NG0GRy6Nkk
         kK8s3t0QViMR/HVEPAm1coeJfWnPHd8hFO3R4sbQyduVikF1y/xE31Mnw+tLc2f1uoCf
         opAsdcnOgQCwLUekHdOAv92kc1Df5fP21hVIyyAjd1JVfQBfTGJvj1IO8m9222ksyOBr
         AhFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Z1ZTwUnghvA4wZBFW7neJ+hQNBTpYfH4OG7mwECm/M=;
        fh=wyjdxY54co3Vn7HYmniS27YohyVLbAC3jk8nqpEvQVQ=;
        b=BS/pAaLFPB0WIlgWCASoUtmFpTdFRDEDI4/RkI6HINviXLsHLzCsMKrldrYOHEMG3V
         OjYR5+kLjRu1e9u5JtXNlFz6MSlwHK9TN7qMH3HPGsXkhFqyHUf+0w23hcmSjgvGSGY/
         yeho7+v7AqXWNavzUJE86dNWyaz/8fPWN1PGQHYNVrAxU2P592Jo+yiEKQLhDWbz/RXb
         lpkSukBqMU0uPVq2KPJPhX6xov6P0jYMlTAxlgiu4XiIcKC7c7F7Ftw+doPI4f7KD8dB
         OHe3tRsotqYU41inX6qHKGQtNOaVnPDbwZReIRpbR5Muza4OiEWfqvF3eR1fimCezU/k
         StRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774981309; x=1775586109; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Z1ZTwUnghvA4wZBFW7neJ+hQNBTpYfH4OG7mwECm/M=;
        b=ToHGBE9ZAxY/Bx0A9qp6GLHtzuROhew+y3nE7y6fC7RLcA/82v1zNYXGxVbRe+cHsn
         oimJ/5V1NWLFyozLuS71IajKC9/5tpsO7J2nx6wGBU6MPmpuA/+qzJ8rByRvVo/nbfwt
         0DMXutwiJZVpkglMzckgRKsNl5xfhdhLeey8tcdDrkllmGlslFpWsgAF10cr7cqNsReh
         XAXywknSmKz7ck6crbnTKLe6LaEIUzPaNCVbGZvYkJwRli9rGx9N9YUB5vyGldWmw9vd
         HOhzaSwN6GnBh61Ji6ha7oxnqAChoGHfAH5Y6oAYA5g/vzHOVjNdt0EEnC4Rs8wySwvS
         0mNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774981309; x=1775586109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Z1ZTwUnghvA4wZBFW7neJ+hQNBTpYfH4OG7mwECm/M=;
        b=H1dsQSKvK86jjLmTUoYNGosfl7Ejg44W/Rmcj/nOSf5SD//f+Fz22kHVcP03P6A2mT
         v5TiQXdt9GHk6fCMO4kSwVVXgI3rI1fpisYjERr/T+CPjdldGUT7F5O5Fpv5+M7aOZq6
         8gS9fPaBP75vKU/yZ7Pdh4cpqgZm4kGQZIKlvu6Rg8lBJiey6A/8CXQNEjqlKpcPLThh
         XVb2wgLiJoyoW+poBiWYRDuo3pI6lfMdR+usNGDNCS7F2MnOsZ/RypTrFHq4UgBYhwPM
         7bo3d8AVkEgp6RsqZM22F2uY5XTSiXTb6JriZ1Y8V2CTx5yATiS3pxAw2v8BPax8QhB/
         OOFA==
X-Forwarded-Encrypted: i=1; AJvYcCXIxy0eNg4dt7RYMZ2Ly/RZZiRSRJhkkek7ntum3EX3KHsuz2gDOj0zRVBE/kYJexnS6QDLTGo4aw==@kvack.org
X-Gm-Message-State: AOJu0YzmodxtB42dRD/Fuwmy6UFAkVZgdf59HL/f5AmhYIybdGH8/X/2
	aZK56Inpyvt43eu+JzJIpLDaaUn0+I2Cioad51O2hsn2Jz8A33netFGPES4PLktT7QnVjRbOluG
	9z7LYNjIEX1mTw6Y1tOqpVqGH8nl9KZm2CPcXeGRcNNRMW1rIg52IFo4=
X-Gm-Gg: ATEYQzy4w14FOCNhRj19mPEHuxu/ieQI54kmduIuVDsUEsFtR1UcUE2Go1jqMWg4VPL
	WYoLyPa9C2FyKiBCSJMQ2TKX88z9pIwKG1/+Q4G6VkEW+NRYoxQSvK4Deb7CC02XU9kIw0d56WM
	iQzqr9n56m76muuVIBiO/E8StMRz0bICVX4cDoGyc0GlpmVLrl2epH4m/w7G7LE2WYgFqLyhHon
	BdfOj4Y/vlvUHdvXkDKv71WcLbbgMkGCyhTuZemHM6zjlV0rRcLS08nzJocsiqhLeiywL5TIfDv
	pTG1nY8gYYirSLcr1N9alddx1mNJQ3s8lJSDqw==
X-Received: by 2002:a05:6402:4306:b0:665:a417:3ed8 with SMTP id
 4fb4d7f45d1cf-66db09e189emr327584a12.16.1774981309415; Tue, 31 Mar 2026
 11:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260331175456.4065874-1-luca.boccassi@gmail.com>
In-Reply-To: <20260331175456.4065874-1-luca.boccassi@gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 14:21:12 -0400
X-Gm-Features: AQROBzCTHvb05M0vcsTVPES6Ynk7b97-HrtYc5Ey0Occ_WM5chA1DLPefIFWYrc
Message-ID: <CA+CK2bB0bMxW721Q+SzFJENe4X0_GwcOh83R-mm1V5dig3oP3A@mail.gmail.com>
Subject: Re: [PATCH] liveupdate: truncate getfile name to NAME_MAX
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 34F364000D
X-Stat-Signature: 6xt7uqobzjogyfhid4mwmxccaij8eifz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774981310-968523
X-HE-Meta: U2FsdGVkX18F5zA3IPzYDXivPNs5aPXmK/Lu8psdhvMgj2YlazPSFxu4Mw4YT0BmtNG1EqsFenzBM+WcQS+0+y3zb3KnY1/9HB3KGFzrDmdCC2AhbbPNSYjZTnz0+O6t0vsKW/09Gl49CaMVcFlomE0H2jnftHdR93ZctifE1YF2HiyrPzifWTTJKwRWZkTsKfA5W+6CU3oSveyx+LBaLFFvYDaWoMNZNlydmNoSjZzsODDdKNdx3kUUBknP5hhbNtnxXuSsNL0d2tu0Umh2iFJ/BNxWZRnCi796A+VplXTv3X39ij0pC51JDPGUDLZMtD5rV1op1GnjL2tX/hl/lzOQbfntZgCLj7lOaZaFx12phW2TjeCdR+hW5ioLICj82pZYki29dKQLYA9NU/ZzC9L2AqSmjAckee72D96wXxN0JQUR7ODO8f1NrLAISNEZR4SoOj9PSNcQP4qPsCuiZxtYyxJmKXLp8twRNdoiYhRbpqsj2/G8m9Xucw4EeBmn4jPKePqX4U0eF9DTBl1ftSRGmoXrjvpZONl5uH80kPrEqVvH1rAE27YqoaKfPuoDlArAhr+VR46fKH/Ci3bfOHhnfrLkFl08afq+/b3H4KE3/8Xtril55IJO1DXObpCNdksD5n62s+8BLnAidcto2Jw76/e5rlG0wYkpoBObPApRQK1lKrI1/hRd+eq7vI9nNatBkvmin3odm8nDXxeYSz3rnm4BnrAyWkX4+lmKZvrNnsS0+WMhOgPPskHKvsHZqpO/Ac+bORdyJp6KaUP9UyroQJNCzsnyMfZ+OXW9cB/4tY3A2iA5T5uT3TyZvqhjNSVLhnpbVIDCu3DEgoI9jYdyAY4L9MiNS7TR7bCjthDJwac1pJLbGLN2XBDGOsSvR+ehZimCDBFZSkHebNTIpEmRMi2bJrfHpoqFLG3haqdIHDq+PpwQaS/B+QW1XXE6r9ovO/OjX+7B2s6ivbH
 yWE8OGCG
 9wwRmBZuEGPr/jbUvmzM62WGMYX0xaWQNp4kq2wP/E/Cfs4vHp/ZwRwSpptZ4ceb8GM5Xd634+MSYI6uaEP26mhDzw6dlTaaqEgjdT1jS6HQyiEL2AatZ8RpNy6LgpZ4SkhDvzHtaq62DqvidniEmdQF02m4F44m2tWXJ6Pp1IxqY4GdstNCwb2JT9JSq7ffKIU72U4jOPEvAQ36UKD9m/z7I1YIKeYlJY+qoym81Qu0026UPSmCKu8HGzUopzEGuVFCd2e278ySHUNhE688s+cDjge8CPhrF+J5XF6dc/+46Rm/i2pnDnR/BH71UbEwbFY2W1QYW0y+AM/EksZ4YsOei06xl8Qy5VSDKz5XnzQ7syr7AWLYwROE1lzVtcy63pPyWjouKK57Y+gvWp9SHWgDGLHfYa70Y2nom65T5LKQZBCqfK7DHjOhrdPaezWr4KJyL1u7HoksFkfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 1:55=E2=80=AFPM <luca.boccassi@gmail.com> wrote:
>
> From: Luca Boccassi <luca.boccassi@gmail.com>
>
> dynamic_dname() harcodes its limit to NAME_MAX bytes, which includes a
> NUL terminator and a 'anon_inode:' prefix. If the name passed on goes
> above the limit it results in userspace getting a ENAMETOOLONG error.
>
> Truncate the name to NAME_MAX - 12 - 1 characters to ensure this never
> fails (accounting for prefix and NUL).
>
> Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
>
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> ---
> Builds on top of this just sent by Aleksa:
>
> https://lore.kernel.org/linux-fsdevel/20260401-dynamic-dname-name_max-v1-=
1-8ca20ab2642e@amutable.com/
>
>  kernel/liveupdate/luo_session.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_sess=
ion.c
> index 7836772956406..4a40c7fdfb44f 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -366,11 +366,14 @@ static const struct file_operations luo_session_fop=
s =3D {
>  /* Create a "struct file" for session */
>  static int luo_session_getfile(struct luo_session *session, struct file =
**filep)
>  {
> -       char name_buf[128];
> +       char name_buf[NAME_MAX];
>         struct file *file;
>
>         lockdep_assert_held(&session->mutex);
> -       snprintf(name_buf, sizeof(name_buf), "[luo_session] %s", session-=
>name);
> +       /* dynamic_dname() rejects names above NAME_MAX bytes, including =
NUL terminator
> +        * and a 'anon_inode:' prefix. Truncate to NAME_MAX - 12 - 1 to a=
void
> +        * ENAMETOOLONG. */
> +       snprintf(name_buf, NAME_MAX - 12 - 1, "[luo_session] %s", session=
->name);

I am confused by this change, the maximum session name length is: 64,
as defined in:
include/uapi/linux/liveupdate.h
/* The maximum length of session name including null termination */
#define LIVEUPDATE_SESSION_NAME_LENGTH 64

So, 128 should be enough to include:
"[luo_session] %s", session->name

Or am I missing something?

Pasha

