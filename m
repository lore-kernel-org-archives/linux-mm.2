Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48772106B526
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1349E6B0096; Wed, 25 Mar 2026 09:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE1E6B0098; Wed, 25 Mar 2026 09:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7D56B0099; Wed, 25 Mar 2026 09:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D73DD6B0096
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:15:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DC12160950
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:15:28 +0000 (UTC)
X-FDA: 84584631936.01.D492366
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F56B40012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:15:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kGjY0dPY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774444526; a=rsa-sha256;
	cv=pass;
	b=HyjJ7ehAlinCA6Lv46weoAbCcPNO6OAmftmu9h0BLK5RPalKK/hEDyrRNz8Jdv+2tPPxAa
	vCPqvV23kHJ/TcK0hOTqkfn0JaT5CSAp5CR54zM3q9Vh0s329Cf68wBEsYDiFEFDq+gOjf
	sgbQCT4D40KcIvnYddMSN6rGj/O/Ahs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774444526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDbAo8IUmxWgPOvsvbn8yIlSkMojhtz3e7wvODdaKPk=;
	b=kcoi2b9ks/UzZLvFI7WWZXbyctDnpwWGtoN9rS/e9q2UDnlWVn1Tj6xSCOX6TiRv8IWdJG
	QNw1t1YWzSgFkNQ83V0h1B32Y5/g+h1zuoAfjV2b+Sd829V4PZzKodFvLQNx714YCnFeMk
	c9RZxaSqJ7maX2WSnymB5ZNhuiLNIn8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kGjY0dPY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a27daa652fso6679021e87.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:15:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774444524; cv=none;
        d=google.com; s=arc-20240605;
        b=kFESck3iILaKcsYTFIqI66FDfhsU9LJF9lDZIilSkxKoWhIYTn0owYZetkogX/zM0R
         PHwp4XkkpNu3BIXos4NegyxHzQ7g891icRUtmDkvPZ78wUSfuuOgR9AOQxH/QH7b2YNT
         9YoONz7W/iuQVv3GPIz+ShSrRLUJqdJnnkITkQ0K+Iw2pYet6LlXjJC4Ohyz/w3cUyAL
         QnsR7YqrAcAPJyOO6Cu1I3sTl7h9eM3n0iziE9uZuMAp3HhdagS7Zs2rxcRhsGCWsvLv
         i8P9XnBm4mm5h7i38gjEW3fPbjrBVrJf/41n/xruDxyakTew5yhqDsM4Jsj2xH2wKcl9
         0Yxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bDbAo8IUmxWgPOvsvbn8yIlSkMojhtz3e7wvODdaKPk=;
        fh=1JFFDREPVFGYPacMPqlulR+fE90zFvVgAeFfv02dLMk=;
        b=Wh1qiD62UmnikqYtJVgGB761NDK4FAHiGvCL+8qqo38SsPfE9Fw8wTBAB+yReAI5Zu
         rD6te9IsDNCI62FliDYvNOk5Pc5y4eI+7uRDZxuxTuojDpnuyXNMT2yQAYYX8RIjQWKh
         yUwzOB//PBXiJ2JdlM5OVauoeNMJopkfcdEXHfPvDb2Gw3YXaRsNj1d0aBvapKb2yQMd
         HZ407nHiT58onrkrOxLiRLUcoHevv/v3nbVtALHJbMR7ksiy/j9wDBWcJgpFgjaSScJz
         Z7pIbBAajs4D6+THi7+KVdKJLWjhQg4HSP0+v0WEt3JOnzy/rJEZCqPUoHVxYyuhiMnV
         xx3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774444524; x=1775049324; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bDbAo8IUmxWgPOvsvbn8yIlSkMojhtz3e7wvODdaKPk=;
        b=kGjY0dPYSJV70Oy9d/l9/TErhdiWZjVBLEe9xXLejGBsjLyUD3sWj0aTxaYNP29FQo
         MxgNbFawWr7wwIU75vXFeddBSjnzQxrbdXjVtekBwK2GfSJtwUshRZVkOfuhCgkk9Msc
         MUhaGmbad8AxoHXZJJOcubOGsAhUiZuBeikjEv2otBVi7fLiU3z1ML4AVewWecTc59s7
         GIlK6IwjR1LHlVaCnyje7h4MHxXgdVIJ7hB93Sn/pbRVGrlTbTHzA1AiqiGSpWK73Oes
         GXUNWK/sfAiuREl9YLThjbo2E0vT1SOfi7hla5/2Gw/mafcyxNDhCnweErRoO5MI6hj3
         DvbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444524; x=1775049324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bDbAo8IUmxWgPOvsvbn8yIlSkMojhtz3e7wvODdaKPk=;
        b=qKzlhyxOrNqhFXQcs+r2QTZ6MtuGEmrADIVe/D1SLpQroYaySdnnZCdxAwT3hGSaG9
         zsR6zF9JbUmKDH9OWm4CVqJ+6BzI0opBiOWxbXjI8wLUUXDNN+lJlKz067gfyv5zpPV0
         uSJd8zPY+4NGfkGRz37UcWs4dyd2TpHBukbbL7i8GiaffB7YCww80vnHkdZ4DcUJxl8j
         FLLgwrTaE1R7VHuu82RNK+RvQsysjRyKrohyz811x7zeLAVyLWrUo0lBVi6vvg+AsO/B
         LEp47v15ZKIQYnfB8sQhOhKyaCtKzJ67/DGvGZ9pDdMX1t/aJve9Mqs7EqbgjoCXxeYQ
         NaHw==
X-Forwarded-Encrypted: i=1; AJvYcCVE2X+EBSPKYsN0df9Q2z5WGVx2BntLkedmc7WvTefBcrBkDG381qvApHNFHOf7RuYKxk4HOjHBgA==@kvack.org
X-Gm-Message-State: AOJu0Yw2d046m2wYQCAYlK0DVsqLB415m5vD6dkoTdDR4v/vPOw4LJtt
	XrCCXCmEe4XMvi2ZUJbI8Qo/EIDhtMnDtcpprI33ooVb0LPj8I29ThvkxlYAj7sY/QrTn/5jB/i
	t0g2ZMKHJxptC9yy43R8kUiXYmFUcwkZ/tnnQP57M
X-Gm-Gg: ATEYQzwcKhAULMIPScH2fea1pnIUcZCLkjbX8/B+WXER8TJB4ZWJghD5RLongaIG9FN
	bxDRE9iPgs8CUDULIMe0Hu4hucVBXr7wYHSqMgrd4y4WhA0of6F0gUv4KJFzW2zeLCwxibHGXIQ
	kyAmI7ujNSjWNa+K9A4WXuS6Yvi7aJHsti/fa1QCxj5Um6rj4aGVOfbBSQTwj/pw+630O1hhYQ8
	Y1mjUvc/w7vpO5/wE2MS2ohk426EyYPkEV/JQleAdYVrEeAEUKlkmt4ZNHZAx+KgQldaBCCOjjg
	iPrBTD+d
X-Received: by 2002:a05:6512:15a5:b0:5a2:8530:9f9c with SMTP id
 2adb3069b0e04-5a29b97cc15mr1467061e87.16.1774444523884; Wed, 25 Mar 2026
 06:15:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
 <20260318141637.1870220-13-pasha.tatashin@soleen.com> <CALzav=fhwP1Wv9YjFTXoinX7R3rX-P0igvLbftBh+sZrL3dySg@mail.gmail.com>
 <CA+CK2bCU=4XQQJ_-3HrhbENBNWoDf=ZzHpp66nZaPxGUAU=U9g@mail.gmail.com>
In-Reply-To: <CA+CK2bCU=4XQQJ_-3HrhbENBNWoDf=ZzHpp66nZaPxGUAU=U9g@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 25 Mar 2026 06:14:55 -0700
X-Gm-Features: AaiRm52xBEnsxl9GOccbKITc8Iyj6vaHWBblh3FjQzcsEvAqRAz4n6CDKHbm6A0
Message-ID: <CALzav=eGYJAFH+yhoMH76rM3U8L-_H12=UsvaN1v8hgn8BPhiQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] liveupdate: Remove file handler module refcounting
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratyush@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7F56B40012
X-Stat-Signature: 63hdgpgur36agby53fcx8d9w4e35aku5
X-HE-Tag: 1774444526-185384
X-HE-Meta: U2FsdGVkX19ofPJtZqbejpI87fVS2WAshnYYjymsoKv3pZvPj7YKQyl8bpQtcltvElDRThyPF4jzpRaI5GNQX0kJyTNx2bOaKPhgCLCMQCJwP4iuwsFWRXgbSV2Sf8aWMC8zXztkEpiWYA2zuL8C+ZpBaueUD1Vb4sCuHr9OaVZrkIapEcNZghE5c/G+i/t2arxMb20NiVG7n78CJfK+4/+1liTYv4piNf4sIkHGTxr10HeeHCgbkmggDtHEbmw3nYamh7WNqKTItBozwfbFWiZ1ypEocFat41+nkKm3IvFXWgY0QMxy7M02CAaGzLoYKEs7r/oSRPpcTIxEDnhkyco6uLOwzKjxqTNDRqH1jjl7QkUZMgSaf/oYea+gX0gAiQSKLFtwmxWyyj+vOWvGndBekKvZgfRx6XhyHAFAE0gxXaFs9+BEYVdFAI2prNaHv8RJ8YpiDzcPknE9qM18cX85d6fO5WumvH8OQXSJm3n0MdSi3w0kUDIOvAyTWcHnKZHywI8PGSAioTt+bDz7YWY3ocl1h5YkoPlC4+VV4wT2DEjFKtwX9uOXj0R9YmdKbWrwB0XOM+0u+A/PZEHrxMeAC0OXWNe9A2vX1At6kXAve2E0nG6fnJISpjpt9AFiPTryxEpPfCRKffLYTirlujFSMQ/vQ+JnlBvEXzanPwPqX0WkSVpstUQ5hXDAN3PuT/b+Znqbn8wlDKa95eaIRb5CW22y8zpKR7P/BLz0AVm7qb3TSNF9hxX/Ii5xBQfhoHadPt0CQISA6xDG9Bg214tT6z6hhHuOPtdCMeHqZzzgZQnkQmGskG+6ajN612v3+VY8AhqLgoD7tSif2X1vPoNvxEl4Y22Q9Kafdnj/gXnbBo2+scVYQxRhIvic7r93kzlRfwUnxIk8jEYdJVGkq4P5CzqM+CAEm6on4ShAQHa0nnnvfYYvS7vHbo9VSVToUpNnumnuXaR1QqtBQto
 1Mb7xVZj
 KDhmi2W6hNmzDdRg4D9KBE7Lu4tQF02UlRHEQ3TZC+x+3pG1Zh7AMx0pUjW0o5rCw6qAaNIc03C+VmJJ9c3MYMIhgbcckrfVZEzz2OJquRmGL8lxc5yCfcrVU7IHaakGLkbG9dNrBbKI7Z3qoVmJw7AfRkWBYT0tvqroBSJ7029E43JtK/97gxKQ8Q91Vyuc2GBGSskfmGaTwDC35/UCN9MUYJyfb9WHnktR6o/kVGjcomRnDFXPrWO8Mxc2bZm/qNHYeuzH20WwFWLo/DscVR5KBuJbJDT726ujB/vLFcXO14Etd0D5UFcaYh39pqTXmvJBgnz2VmvrDVg49gv9oLMEUQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 7:49=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Tue, Mar 24, 2026 at 5:24=E2=80=AFPM David Matlack <dmatlack@google.co=
m> wrote:
> >
> > On Wed, Mar 18, 2026 at 7:17=E2=80=AFAM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > >
> > > File handlers do not need to pin modules indefinitely or during activ=
e
> > > live update sessions. The VFS 'struct file' pins the file handler's m=
odule
> > > via f_op->owner during active sessions, making dynamic reference coun=
ting
> > > unnecessary for handlers.
> > >
> > > When a file is preserved, the live update core obtains a 'struct file=
'
> > > via fdget(). As long as the file is kept open within the live update
> > > session, the module is pinned by the VFS and cannot be unloaded.
> >
> > After invoking the file handler's retrieve(), LUO should probably
> > check that the created file's owner matches the file handler's owner,
> > since this scheme relies on that being true.
> >
> > If there is a mismatch, LUO can put the file that was just created,
> > log a warning, and return an error up to the user.
>
> Is there a reason why taking a file handler module reference is
> problematic for vfio or iommu? Could we take it while files are
> present in incoming or outgoing sessions? Overall, it is because it
> cover corener cases such as if the file struct owner is the same as
> LUO file handler and also this approach covers the deserialziation
> side nicely.

I see no problem with LUO taking a reference to the file handle module
owner while a file associated with it is preserved in an incoming or
outgoing session.

And I realized that VFIO can have different owners for the file (vfio
module) and file handler (vfio-pci module), as it is currently
implemented. It should still be safe to rely on the file reference,
but explicitly taking a reference to the file handler would be simpler
to reason about. So I am ok with going back to what you had in v1 [1].

[1] https://lore.kernel.org/lkml/20260317025049.494931-4-pasha.tatashin@sol=
een.com/

