Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC46CFCD0BA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 06:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F4E6B00EE; Wed, 18 Mar 2026 02:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0FE46B00EF; Wed, 18 Mar 2026 02:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE6D6B00F0; Wed, 18 Mar 2026 02:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF1456B00EE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:16:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D17E613B2D0
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:16:41 +0000 (UTC)
X-FDA: 84558175002.20.2797487
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id C169720008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:16:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aeEVUzd9;
	spf=pass (imf03.hostedemail.com: domain of linmag7@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773814599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNXx5fLw5itcSqfItrsW3d6my1DlKfO6NqzxE5+AiMo=;
	b=mYSrZRFK5RC/sTTzvlWsNgbpA37N0VAyaaLVk/lWiz2j+zdvUcJFGzE9+iUXsiHgqULBcR
	EfVLH4nWOaF5P2Gcet5m70PhFhPiszlb3b4tAW/js2h8EZCtiLONFOlBKeWNfPRaACMUPK
	ArEPvt4eXhyfH5Vai+wIGQI100CB+tQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aeEVUzd9;
	spf=pass (imf03.hostedemail.com: domain of linmag7@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773814599; a=rsa-sha256;
	cv=pass;
	b=3ep2nyGa7nwyqPBVKctw4LOhacsvL0onNP2Vh2sdFtNXNxpFg2t8Hl8Zpe7k/cgcor/St5
	Igh0cDEGz4TqGztHH2zwlJUpffTNJ3V1ZLiuju2ERerYcTOu20lcDatFTmD6LntQKE3EKV
	LaEhmZTcaaJvQNCtVTzAze79GGQxqBU=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b979d16dd0cso613516666b.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:16:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773814598; cv=none;
        d=google.com; s=arc-20240605;
        b=TQvSo0yLys/+0hhHbAdP3hYZ54WUKLbnSNkqT2fw19QmrmjqXJ1lqYcCqmU852AqYh
         cM1cK2MaoVnCvQn6Ms1F9NYd+4LIchh2CGWpMHZSdS4xaiwyStOwOgfYKf0H/moVnryH
         9JOZMSh0WmmQi4oRn0a4hsV/qunOg/Uy3NbphiKqhzc9OoYn9O/0re6yW1FFnu2/hsaR
         1VYG9ukSOFKIgDqX7xH48pzwSBbOuIHTm0lbb64hNvizf20IQv/lSrf70HrLNQrXiGGS
         fYJYfCw4ymsi+ke0lmFn6xfyjhCc8KnM/cTCrSQ+8A/iYvFO9eGfMQXFLevhyKWWFCBx
         u2ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hNXx5fLw5itcSqfItrsW3d6my1DlKfO6NqzxE5+AiMo=;
        fh=HEv7ZXOrtIPtS0LYUOYF7ZeDaHxxEdJCF7Opcv0A5mA=;
        b=PHc/UwN0K2JeS3jRDq2RFCptAKKtiNEitHrA+rVf3WyY65DXFiww1Z0RK9Ud6EQyKD
         f/kq04TsCGHJYhadbHTDN8WZUuVBUL6/oKv4pR4FqBaSCRmDiSxEMZUkLyDTuDwXN98F
         /uHkFKi0I6bCgwUF2pTY0OTMA6vXA/7MZpxZNYdx4pEOrbiQuQ6+njOj7XIUSlQkWcPW
         Xo89Mlp2GEwnxYk5+LddKMHzdbWlIpBqCFnbSN4rKmrJuFYYyEwAcF3nNKNOe8YjrS8Y
         CLS5cuJdthJzhznyvybkeg7bZ/vBStTuRP/NG2lu4smTlU8sMZgjv3tlGLXg/ABDnZPv
         zLyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773814598; x=1774419398; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNXx5fLw5itcSqfItrsW3d6my1DlKfO6NqzxE5+AiMo=;
        b=aeEVUzd9ooZTo/PfiK8vebYg4yV+BE1BzbqDS9BpvYbnZ4ncw+/e8zK/+lpMg8Vgjs
         s7RsTLtqJdebjuXQ3QZ6+YVzOAPL+HlVYZWU61RSkdu402MHovTIlJyS6UTwCPM74RE4
         RqCRUBsqN64xmnCpJGsAU6LF07wr5sYk8c+9+vgbtj3lkH2cK3oAdLpqdSGqBMFX+3I3
         JBJ2YAyFzJ2prwnvMiuwvuCxmSgwfNRQRlVX6zejLV3xpP/9ocV4/f1zJj8Tnc0ATINt
         5oAu5+wdFOHwnZp1UnF+CNnStWl7b57VV9GwMB7FQGhe0/uTKCOME/rcY5EhCLfgh+T7
         JFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773814598; x=1774419398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hNXx5fLw5itcSqfItrsW3d6my1DlKfO6NqzxE5+AiMo=;
        b=K47t2WHdx5PQ+HZiBfsS7ftDqT2se9+m2i8f7RoWEuG/Gz7e8qk3L/HYZOj4eCXF4P
         PRE+vkuy73O//meCtfLoEc4YUSbRy3esGncs0bPCGYf3Wlkf0piza/76domrysRgGFRO
         RVg3oLtZzJEPWqk+i/Bf45amVKzqYH1ipMJgQwRlaGNrpiDvDNSzDHfNRFgP2oV+P3fX
         jghafK9XV62Y7G/mmAHsy9cvl5YPsJLMNZYFSI2pZa2F7fnVN3qpTgNAZ3sRRzf2rgnG
         bgimLn0M23FeGrIJks+CRbM8fafEOwt3FxhXUxkJVOWZk85v+L6JCLKRTdZtfdbDl84J
         yk+A==
X-Forwarded-Encrypted: i=1; AJvYcCXnaH/OYS+BfLK+/cNAfJzmsreDBVbxKeMfKgM3vhV2vacE7QK6K654XSAm1up9y1qFVznE0eKOgw==@kvack.org
X-Gm-Message-State: AOJu0YycSZlBZiX+oQkv86PtAx0TBb+BftT9nKfX0SnKBPE1z6PCWKg9
	X10E7H49QZ3mZA0zKs1GzBQPhk0v51xDziJEaC+E8nbdl4NZm97tW1PrCEtE+B79WcakD3a9Fg4
	CC68RqX5OkGFphVZUt+8LHJS7zWdybFM=
X-Gm-Gg: ATEYQzzjoRRXdahhOWXo9g7ymNcx3mggZzx7HQQpiFeTHaMFZ1Z7xA3YLjN6fCnWKru
	b/9dcI28ctz9/N8Ax9dSRYCSKOOL2liGMpuI1PFhT+or3P1Ondy45PfIX6GsLpQkeQiTSWY6nxY
	IwEwmwOwWneNAFMIrU9TTkNJ1P6JRpKLgOaQeSyh9COADRjAEAAgeC4HECJCdm45ObLgy9tW+ZG
	uC3s3OZZCyIxmlxqmtSxdrcKuXZd0Qs6O1iR8JOCmvGoqglzcdJecwoQNFrPG20GuLi98kzI/ZO
	gmUShYFY21huaaF+KySkyEd6ZlJB0fnJTqpje5bZmzrkGbDzJNo=
X-Received: by 2002:a17:907:7b93:b0:b97:cc05:61b9 with SMTP id
 a640c23a62f3a-b97f4801ab5mr133040366b.15.1773814597747; Tue, 17 Mar 2026
 23:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de> <20260302-at-vector-size-arch-v1-14-a11f03ba2ca8@linutronix.de>
In-Reply-To: <20260302-at-vector-size-arch-v1-14-a11f03ba2ca8@linutronix.de>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Wed, 18 Mar 2026 07:16:26 +0100
X-Gm-Features: AaiRm51Xx89jeaivgNYAhMk2LxpIu3kD6j5N4SuQDZ84WCnP1EAzJIW2dMNKGiE
Message-ID: <CA+=Fv5RLtUPp9BhXfFEUk3roE3Gah0iUamDEZ-MXCNM_xKm3PA@mail.gmail.com>
Subject: Re: [PATCH 14/15] alpha: remove AT_VECTOR_SIZE_ARCH from UAPI
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org, 
	loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-alpha@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C169720008
X-Stat-Signature: hrg7qcppjhwx1eddbwk3m4b14gc4j8ia
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773814599-82152
X-HE-Meta: U2FsdGVkX18HYdHTq7SBIagyfQAR9b+AUS3tB4gc+63rgjkjQRL34mE3KnWZGsB9qQCqbEBO/q8b/eGRCLTLdZEVLAuNeg43dlreu2pzXIoIheMudfNptQiufTwPYa5XIwNwPuC9EBRhs5mvvtt+7YAB3KYrujZQdHL2lnR+MJchdGZtcp6ZAH1ez/O9fgz4v8eihNoUfvlVd8sMyngwvAPajmmx/x2Z8EOfa4VApeUtDcJs4DFPlrr87Y21DWH8WeEHTLD1pj0eRdEb16FGfdTom6hUEAgB+fFsHZUsUShOpEyrGl/EITjDkisZ5WxnsgnnpN01/L52E84auTXmKA52pcoIxq2jTOjyX0aYxwZYZ4J3X81N/pNJMS/0fbTU7grIy2JHDet1mujBtmOjXLBE2ayHDIs/3MW3PWfjE4Swidpwjsio2h/Zl7flAjyFD/kGagLG3W1Ij53s/CKScpAGVbr0RH8cwN/wwojhfGP5TvOuzMMgwG3D6Y3CW+JW6w45FeCO8XGkNM4ztSR3zNEadCcjR5KjCuuH2N/bS6Pn/iFgAvdmaMoP2SXmJxVGDvNd8DZsMCIniz6Ec8FBR4SrwfPY+z1kfY/b2AOebJa9J1l0KtLd3lF5vDOjXqGmqAO7+gSKf5rKsJvXvWIn0bAnRyF71PtAsX++Pu7moS6+JVVWJiMrLvd8OS3dBGsixlFRNT5R+6rmbm5CyjlkFlZRSdaIzEHkyawMZwQzsuXHE4UnWMLfuUjh/u+hQ7EWMaj7Xr50j0mpeHXFb/UYVH75G7jPOZ0RMof7slSFD2jvvwZGRfauWqQvnuPWa67nV37hNZgRYOe3tAkr3/cVjbxB3xAi8q1KLhUK5T3wCoQzb0cfyko4CCV6iFKy3e1woL9nBAB/2ySscpp9AYwgideUs5qU8DiZSyvVKUyQT7ZKEs5FVlS1jYtMAMquY9jO3f8aiXukfoCqXfPt5Kg
 wSvovuxU
 GN7J1/NJNzF6yURVg+sBTvBxAmUoIUWkGRBAERPPdStTzYgKMf/zl9yvPb8A15YbNoBm0y8ivmCLNrzw073Y0f1kRdCSClkH5/kV8Itcklf659rGBAWoN8lat5EXG7Iq/BXX3h37X0zNH8f25r0PqqNfccwi78lWIdvfHBe8Lc62qswO2uawQguXPLcfK9fSkjVCRFZrVGKl64VDHK8FOmCNuwsLsGtQGJQw60BLXLw2sXrKOqHO+tSGzWbMBKQthipIwK0r1DtH19h1HSogYjhnKTTgNS6VU4ozDCIF2q0GM6ae0SDJaawjT8k7G+nWRQ0hkB7vAG5DRIxTDZBIKUW7LY4aGCq8a/17pO1n8bdng4mj0zc57PopGqxPIOVnufnSQUbnHJbiZ2OtJlvHajDTV4fIVHk7DsPgOiC07Bzu4maxBilM032sQqBH9WfKXH3jioE+fGHhg6SaV7L9Bn3I8uHRk82eVxBnyJWA9S1cKuseKb+tJklgE5LZzOQ8SJcjqyIcxZrEH0jlgFExkjlF5YLcnoRy2kVSOI2NJY6MxsVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 1:32=E2=80=AFPM Thomas Wei=C3=9Fschuh
<thomas.weissschuh@linutronix.de> wrote:
>
> There is nothing userspace can do with this value. In the kernel is
> always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
> userspace and also changes from time to time.
>
> Move the symbol to a kernel-internal header.
>
> Signed-off-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
> ---
>  arch/alpha/include/asm/auxvec.h      | 7 +++++++
>  arch/alpha/include/uapi/asm/auxvec.h | 8 +++-----
>  2 files changed, 10 insertions(+), 5 deletions(-)
>

Build-tested on alpha, no issues here.

Acked-by: Magnus Lindholm <linmag7@gmail.com>

