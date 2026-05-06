Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48785CD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:13:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419446B0005; Wed,  6 May 2026 05:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0BE6B0088; Wed,  6 May 2026 05:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32E2C6B008A; Wed,  6 May 2026 05:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D49EB6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:13:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EF76160737
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:13:08 +0000 (UTC)
X-FDA: 84736430856.12.0D7B56B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6B159C0013
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:13:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqRCn2u0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778058786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FL8WPj2TtodXtNY9K1fg/6QVC4EPe4oFEXcMSB53Hbg=;
	b=XT1qxUATjhPQoEA5MUuRTUjM12mJpzGJwzO+AGeghCiuYS2en9R85DcVuGqEnoiYOiTB5c
	lSPmFs+qgWAkoF0O8Asle49LKnkwmEhTWVZ0yktGBdLObrmZGuuHYYwRwwek3v7MN9DSE+
	R2I7sMlQuuR39XFI1SxprDDGZHGPyyo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778058786; a=rsa-sha256;
	cv=none;
	b=LbSaJY8wBE+97zFpgpV2qIUY9esTckXcgNLVbg9dcL1y9SqotyHyYBy5Uv+Bpdt6x+1KDI
	5laNYPa8awn1PstNPl1jchjtskY5l1AUqDiQ6EVkK58pxmrlkmnZjfl3NSK0C0B6Mls5NA
	NTYLJRyRLkn7Vfl8xGBZEKhWgqlMG2A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZqRCn2u0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7F3C6024D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC25C2BCB8
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778058785;
	bh=DD7or3divdndAh3c85f4IFCn6kEcdEhWSkAt7r1emxw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZqRCn2u0FMIFzrZsC9DttIFF2lxMt1gpe/XviJ3M8+n5c7g+TWNebi9yINMK6dymX
	 QzcRihM960mGhaMMRNq4QP07DNMpvPe2dNZ85jncfb5K7fdx0aXx5bdQmXdwBKLoA1
	 6k9LYnC8t08VSLBkwxg6rd5ICjBD+FN1LdNfaoADYmlQw0s07gfdlpHemxBHYnHsyA
	 kCwUIuj9F1deObiX2AcAvZuZ6c8EMfmH5DvehDzyzHsLZWAsInShI8VxzFHhZ/zkAb
	 xxbWxwNfTpY7egGQ0OC7RU9hGQcIhz2fT3zHDqejVr1dTTZUjY6i5o62cG0W3Ome9j
	 31T6q37csz6ZQ==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-65c52bb5dd7so3182205d50.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 02:13:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ82oNM+MH7UpnemCNbda7/Uxzzyp4Y+vA+zB61F6oYFdveeAxGIobsTbspDvkVd8TNb44Ia81yDjg==@kvack.org
X-Gm-Message-State: AOJu0Ywa4IPntYREsomZmtsjvgmqflvD6S862KACWoYbLyKdzfcVr8LX
	aoLfuGnH+ilsVPdEtrOwbmii1D39clOYX5txuyvhCYPGo8Q05vye1SKSBxwVmy09d1o38oE8SjB
	nS0tefyeY21AaMNVSAWOrVqInGDMh8Hk/5YVJ0OSVog==
X-Received: by 2002:a05:690e:120b:b0:651:c483:1d3c with SMTP id
 956f58d0204a3-65c799b63d8mr2786219d50.44.1778058784826; Wed, 06 May 2026
 02:13:04 -0700 (PDT)
MIME-Version: 1.0
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330> <20260506084741.14228-1-hans.holmberg@wdc.com>
In-Reply-To: <20260506084741.14228-1-hans.holmberg@wdc.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 May 2026 11:12:52 +0200
X-Gmail-Original-Message-ID: <CACePvbXJGWVd6bFmnprEYbzNhiWg5Dogj47M-3xKduF0ed1F=A@mail.gmail.com>
X-Gm-Features: AVHnY4KUb1jRo9PImVwBxG2F2w3SXkdn4Lpsy9SRA_zael1BqzMyAea3EWqF6Ao
Message-ID: <CACePvbXJGWVd6bFmnprEYbzNhiWg5Dogj47M-3xKduF0ed1F=A@mail.gmail.com>
Subject: Re: follow up after discussion at LSF
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: youngjun.park@lge.com, linux-mm@kvack.org, hans@owltronix.com, 
	lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6B159C0013
X-Stat-Signature: z1u1wsm868qkceq7ftshxhyg5636gynh
X-Rspam-User: 
X-HE-Tag: 1778058786-51723
X-HE-Meta: U2FsdGVkX1+b2LiJKck7qxJmkwA6sncKf/Z2Cw49FsiKm6WFf7IC2rXFIn4vHY8LFi2TWEA/I21wRh3MdBz/7R6i1AJE3QPXn9GG5BY6YLVZPK6fulQd8hq9GFzB/P3y+I3Fp8MZfflIaBHh0srPrWVRyD9ud0LaGmGu60eB8XTQ2VsKqcDDlDxIEV6O8DcnOgzOwF3nY84VjkwFw7FdzUahEuVGfVaiYGquRP/3EFZNiLwJAQC1c/TbwS2TO5h3MdY28CVpWEjH/+qnxmHi5W1QOxo41y3RmvjB+qD/GqK1ZCdOMWgjqp9xb6nXf5m5Fam1k7M2417HAwKYxbTc3L3gUMib35M1y/whR4Iuna/fstL3ovgXeztbFuXkE4sNC4fvd2vpQlD0fj3XQ6iBACX5dfUR3c+kXOR0PYgEWyQzvPSyFHacKOEr2iTOi3G+i/1JkRN1qn5L0T4aciMqlni1AwATy7iO0w3qAGJFhfVcgIctE7ObXyuiaGAUa9FJN7FmYONJzCk28FuFrcb54j8aHGola+84K4/Bkw8STu4Nd/EDHIDQdcwFOOkz6cFcTqbbcG6ISMjnaxlNsuocYzA40TXNzG0c+AgNUvk1n1/D3tnNwjw158xxZF24BY/hlCkiVgA4j+6PcKPVRGYXIlRHQIpDGkAlSmD+AcE2Djj+TyQC5+IE5YObzkfr9plawtTV2oPRyPkOk1EiY3uA9LOkf5VqWc4rpRWyWry3JlfGeIAfuZmMjCZKheJbhm8W3Aq2q5Ufx34jTVAY9+RKdVOmPUrAOoPt6PmgEDIbO5eFW4Ws38DKsCrU1UIuAEarcBY0RGDyrWGev25KN24fwdyhvNvhQA/Dq7Tq+OwlQqBHUeX/McM/FKD7FXjA8TDjFjSxrpeS5Ed1xWaEfm/G6aPjvUM13OhUPHBQ+59L8Xm3WU1l1L2BVM4g8Z0Gscf2+ZLWS7hZGvOsBx8myAt
 Vt5wXSMc
 ZpGe/udR3j3zPgvds6tfjqwwIkdP2aAXzn6Pn2wChmsUq2rLMhuvjfIYVwn3eSzb8Qh//OK7i8Lm+LMSHfmMEeFZVhzCVul+rxe3Dr1Pun9WusaUAp3C5YmV3oEIKeGVwJ6JtWbmuQqEUN1ei/W5SGqdqEyaSUNMHxAbWlG7wy2etnt9SJmjj/JlGL1ggoavyAqFQ0UQEwpXUnSjAKhTehp6uIqzeojOTYCPNnrHVAazPFlMXTvL4wGIwgBkpJ9Tg/P3JsbDctiuVVSgS+/EO03UcWaOMbT74l9MX4QkacJBq+5HbCNwF3ZZ66ux95nikvId1nGWqISZ2HFvd6fYDFMU2gq9i97qblc9O5xoEpc+JnThuFR3YJVVCQCZrki4YODWo9dMwkwf9J4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hans,

Thank you very much for the link of ZNSwap. There is even a video.
I will check it  out and find out what we can learn to make the swap
system easier to do things like this.

Chris

On Wed, May 6, 2026 at 10:48=E2=80=AFAM Hans Holmberg <hans.holmberg@wdc.co=
m> wrote:
>
> I'd just like to point out a paper by Shai Bergman:
>
> "ZNSwap: un-Block your Swap"
> https://www.usenix.org/conference/atc22/presentation/bergman
>
> It targets ZNS SSDs but it has a lot of relevant good stuff.
>
>

