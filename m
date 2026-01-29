Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C91C3D73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC706B00A0; Thu, 29 Jan 2026 17:51:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383AB6B00A3; Thu, 29 Jan 2026 17:51:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B08C6B00A4; Thu, 29 Jan 2026 17:51:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19ECA6B00A0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:51:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E08C6D4076
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:51:48 +0000 (UTC)
X-FDA: 84386500296.04.CCA4C1A
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id E43701C0004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:51:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zgIW1KQ6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769727106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJvd+vGWuwhCxcK/MWhPFTZF+6vHFFgGrzqA34BGLTE=;
	b=ia8v93agEOHrZlusiAAf8LFBoj0QXsmYUImLwDclCl7jMuWy5iYq9FmekSj4FpPq4NhQL8
	crIcSL364E1pbIaHc3siCsfNr37cwicgfeyyOYsY3K/CNNTWIKJSzjvh/e4/UuqyUcqWCi
	r/3f+fJfaPLDLeqJehV7MB7Dbx5ATiw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769727106; a=rsa-sha256;
	cv=pass;
	b=xR27vllIP5lPrZhiGubWJJDE3wsksc2bHGote2VfG/4gJiL6PDtt4B2MWqg1JseFfO1zAN
	BOZ8xMBKdAPagPHPPPfYliSmHRK+2yamGgezCr/ozGfDnMXXvglJX5HzdSoMU8JUihcAz2
	H9uFzxYvnDXPPzbT+Nc6ZrsIfcXieuU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zgIW1KQ6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-566390e7db3so1145636e0c.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:51:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769727106; cv=none;
        d=google.com; s=arc-20240605;
        b=h6qERFAxaqx+9ci2JMQgBmKthGg2tW/lYvXhu0nrlMjzn4G2dd9ObWIYFuEcDxDQIu
         cDPicTjvCpjGHv7uvv8A1+Vc11PShyKiJIvfsohfToCgrHMzRyyXvfbF/y8FCotxvJKQ
         QvVL65KhFTHYL5xLax6qWLDIYHwo69Q7ycyER8z+U/A7AApM45TwMzpK1fRN52k/J0qW
         wTO7S+pAyAfoJzBg5qzqUMgO5GHMqYNXP1lKzVeP/A6sNgbYZ8m3pV/PrOLCu6PUctVq
         IT+Cq+hVqZFchHInwyZ9YKxZSAZ5jQ/mHAfJhrLufaGK7FUMJsORVBykUF4kO+CcZYMN
         aiaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lJvd+vGWuwhCxcK/MWhPFTZF+6vHFFgGrzqA34BGLTE=;
        fh=ZHuG9pruc0CGDxtG/4S56J2IibR0dybg1iZHaqLlxKY=;
        b=k8pqiDH8VD7+0dSgoaAd4RwVdUu42vPUrNNgvBriCnt429Kvyoj+PXzWiRoLiFChgx
         6JCIJRZ7V46xSmuWDRweQYSiMb875DKVpRkum3z8wj9hYeP9CF7LirNdQEaJs1MI/buV
         /xnKMWOJQOIEueh9iTsLMmS0KW1WLuHughB8ioRWY+RCV0v72esMR4V1S2KS2g3+WlIe
         rM/SFxyKqKHwBPZFEERhXh00TdR/3fKKMkaftbbjAejWXcNfUOWUSiimW9ItIVVy96DI
         2j8uhl8Om7iLTFsxXZ24KzJfnEX16i24DhBhkO/FIVM+n4GYGBhMIpfXOz+g5cczDcXv
         p7bw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769727106; x=1770331906; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lJvd+vGWuwhCxcK/MWhPFTZF+6vHFFgGrzqA34BGLTE=;
        b=zgIW1KQ69LoBnkzVsEYmCuhwG4WSWVNw1PWZRBmoVT4lU98vBWprwVp1f/RYWoBDCS
         xa8uV7ZMfH7c5UP49+FvFjf/yNmxS9EEO7xD7D4s4W4lJRy87tI32zNFgVZP+T8mFtfw
         5a0IP1NBlske1tUL9wPSyerxbHMPxYzxLjFpEuoBT05vXqhGymorAbgodSto6s4pG06C
         K9gpRcMwSVnafz4gW5UDoOYX7FKYCTQzk6tHuPq8othzC36AjZ2q0lakwLrYaLdF+k/x
         /HNYxdRHJw03HeZTaunEvadWP4hYq9e1IMhE8dJSawGam4rbX0pcjM1zEtfz4ubSL6FE
         5svA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769727106; x=1770331906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lJvd+vGWuwhCxcK/MWhPFTZF+6vHFFgGrzqA34BGLTE=;
        b=B9E6FxGhkBiNiVi3fK2Yb+Sw+p+9P2EazS8+/GSMS4PzF8w/vO9DnpYwFrbDG4/gmd
         VIA7CC3WJAywS7OA8rKqyEguLMTtxFW7DOv7nbhlOtuhmCBKx+Am4zjd7UV93ulVYHZc
         /hz4wuA9iPOAtGe8ljwvz7QEyPun8VLgeAzWtG9aCte++DN7JCBzf71vrWYr1KYCzPJ2
         DQHtiDo9vb9FC41WOgFghQjUhTOK72jDMAgKT01MDRGRV0zyb8PFTICdF+iR6vN8QIBf
         TbWkIEh7lHh0AEQ2ne2HUylnnQiFlH4oBxJuATvTdH7U0ccBUmrN6x1qg6POBc5FpqQA
         GDHw==
X-Forwarded-Encrypted: i=1; AJvYcCWmyClmm4dfcaAcN7sn6HdqL+Xh2CmOzmDlC7tq9pGkwWQAbuaG0VlsBxt10bF0vdqjsRFKOQyMEg==@kvack.org
X-Gm-Message-State: AOJu0YzHsQ4bizJu275/V56UB1rqGp5HwzfKwaXWyzA73wgDvfIYhlae
	cotCx8G610IB5FoMpYWTm2PX+Wduu3sXxnipoFtDHT2C8Dp6+w7XWuqxiWUF7UABSQ60hh+9a8Z
	AhuVDbwkpN9mC2S5gEFTzLe6G8LwI52aduGaXRWUH
X-Gm-Gg: AZuq6aLdEcjLs1rmqbh+OnHBoHa3MmKnf0nCXZCcGEb+2FWDOfo0jkJDsVxUaSIO3LL
	qOSh18OVotgYvGkZiiPSzB4Lh6jX9KqMkTDb6CDTulUsFwNtelpfRdJ0FfkA9aJNhtCtq14JETb
	QwJEEhvb5X/0N25ELEjkwU6wujqriGUQx9i9KZw43YVKGAO7zCnak3UsMwR84sJULCvcxMX6vat
	dPcH5cYgVpoZPQNPb8Mr7wN6KhcQ4jwFtaam7zmg5aKPYEX/rtOZI/xk3aTZWLz2PaAwQ==
X-Received: by 2002:a05:6122:d9d:b0:563:618f:b7e1 with SMTP id
 71dfb90a1353d-5669ffee717mr403168e0c.4.1769727105743; Thu, 29 Jan 2026
 14:51:45 -0800 (PST)
MIME-Version: 1.0
References: <20260122214427.3568647-1-jordanrichards@google.com> <aXj28ZAsPhp7s5sm@kernel.org>
In-Reply-To: <aXj28ZAsPhp7s5sm@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Thu, 29 Jan 2026 14:51:17 -0800
X-Gm-Features: AZwV_Qih4YdJjcwykk3W2XKzoofUT-6bqXeXJt_PMZh-8Z6t0rpgREgUbxIftt0
Message-ID: <CALzav=dKzsuZe=ZLfVg+ENVS0RbfN2jBcHEn+N5Jic=ykHLmWA@mail.gmail.com>
Subject: Re: [PATCH] selftests/liveupdate: add end to end test infrastructure
 and scripts
To: Mike Rapoport <rppt@kernel.org>
Cc: Jordan Richards <jordanrichards@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>, Jason Miu <jasonmiu@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E43701C0004
X-Stat-Signature: tjtrkmr3bibprgwwt37ttnn5atfb68w3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769727106-910627
X-HE-Meta: U2FsdGVkX19arFyUm9QdrOs099j6KfjgeUGX6WJI5XqMgpI3RTDjWnMv13WArZf6ayXNjXnVggrt40nj6xulCpnlDZ1YqGlrWurblC3iWAi91KDbE+H1qgVTHlPhHsiNb1CDh5If4o5rseMdO/pKBRvol+YXPeX4vqXq1V/sxBZZZXSdfjjS1Vga4TJH5xgz98AKSKioLHbPwBGsnpXzOAjeOui/0h6fjUtIW4o4nbc5UuB3OC2ItNKgYPTGCyjBGjwKJ33TyYbT2UzPO5x/3aebUdFzCwJ/ldvYrpFtZDEU+sLdZv8df29aJa71lthkf2uDQM7l2C5Yc7YLqVEz5ymDV999mHUlWxDkZ1AQUZgLJjK2vmoQaMIKp25EPERWTpBKwdQqnFGOdGZZsghWVuS00geLIE83xZ1p8MOgtmF22CnAvC7dmE22X8ZigWzh9v6wdthHRYkLRy5dR4iVAXWP+waRWJX6FLWoCNnPcHqKhs/w3Uz6WA58p6ZmW9zttHzRZocjEMSrxHxV2QrfR4vMz6y4tYZ6/rFnDpeQjTJE3pTPXJsvwmysEs2pXQqGXenEPrTBAeEKesu6E6t/X77u/C17C8Vb0rHV+vnEUFtTDmAR7RZwruJvLXLmm2WfGM7cBgYzlBE+W1jspQPldaXN4k3ryXl9lhTrHfMbztn8ANVDXhMI7g6ATI9we4WmgSSRYfigXnTiwWJri4GQC4vy1lZyrOvc8kmcGVciIsltEVSff3FbeXgj5VraXhOBsdPHXiJSTMuRIzno268KgAkKfn/qYzK/gpbhhLicu9RVEU/yKQ6/FQb7BAqaO0p+55eYjZe0w2wYnBAqsM+dJBuNGkArxX9vAO8xciVDq7RXqt9RJi8jt96l+bqav4KaWBHOQA43s5K5Ow0GtKDE7TDZNZwiJqu5FxXl29rQExxWoqeaC/PiNddaIjrbndB9C91p+xJYGOyd7CqZRfF
 H/IJbfG+
 TGfchNtPEUo10o9PHb9302weSczXIjeLy6avK0BzRkauF7+aPGX3fnh5C0/TDV9N5UACMD5IZP5XUEGK5pTL422QbyE878drwyodzKS5rwzOooI9PXj04MxRvQxTIREgE8NlAYj1ENa2vCc/GGAg2ELHW7wbbv40RY1R3vaCX9vtr1ZMT+fyVdeZ2+ckBB+br+kx+06ggsuhQcSpAIoPKwkMVBFRjqBB6MbR1kbmLG11M/BX8V2p2Qbe1STyT4ui16y9W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 9:33=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
> On Thu, Jan 22, 2026 at 09:44:27PM +0000, Jordan Richards wrote:

> > diff --git a/tools/testing/selftests/liveupdate/.gitignore b/tools/test=
ing/selftests/liveupdate/.gitignore
> > index 661827083ab6..7dc1e8aec44c 100644
> > --- a/tools/testing/selftests/liveupdate/.gitignore
> > +++ b/tools/testing/selftests/liveupdate/.gitignore
> > @@ -6,4 +6,6 @@
> >  !*.sh
> >  !.gitignore
> >  !config
> > +!config.aarch64
> > +!config.x86_64

This could be:

  !config.*

> >  !Makefile
>
> Hmm, I missed it when tools/testing/selftests/liveupdate/ was posted.
> I'm not a huge fun of negative logic in .gitignore.
> Why can't we just exclude the patterns we don't want to track?

I'm pretty sure this came from me. It's the pattern we use for VFIO
and KVM selftests .gitignore.

Positive logic requires updating .gitignore for every new executable
(every new selftest). Negative logic requires updating .gitignore for
every new one-off files that don't match the existing negative logic.
In my experience with selftests, the former happens more frequently
than the latter, so the negative logic is easier to maintain.

