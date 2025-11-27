Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77E9CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0691F6B0062; Thu, 27 Nov 2025 14:10:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B916B0095; Thu, 27 Nov 2025 14:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23F56B0098; Thu, 27 Nov 2025 14:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF5C76B0062
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:10:04 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68ED6B7803
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:10:04 +0000 (UTC)
X-FDA: 84157327128.06.AB2C607
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C5F1A0016
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:10:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QwFnFWJX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764270602; a=rsa-sha256;
	cv=none;
	b=U0hx43QwubA4JLuonUyGamkfDsKE1ptXv1vT8fahUKfUkBN+zVkkzA2bjI9XyQii7wXvss
	DRde1iYXynoT/vZ/GsyvdINh7VQE+nElrZfSn/NuK2vekEj1DosBq919K/2F0j2rLhUwTO
	le58+TRRt3Y2WnFhJZDIg3HS7IHBeWo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QwFnFWJX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764270602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zH+Hhz1A7VeI2NIdsZ78tgdWYWlYUy0wWgAiTIjjG5k=;
	b=qOyDq/huCaB9M6mUVDsLEu/ZDmRZXhbKRsM9EyVJe2AK1rVKpnmhDmqEVd7SXQOaPu1g70
	qL28ZF6LxhNoTW1aE8l+1krOch0NQb6+Ag8V745hOmunskb4T2DSYlODejdLepmqihpZHV
	G+b8nFCvZUnA0tnll7ae+7PVlbiVHpA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E3BC560224
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94222C2BC9E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764270601;
	bh=zH+Hhz1A7VeI2NIdsZ78tgdWYWlYUy0wWgAiTIjjG5k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QwFnFWJXPmKIAGCu1/BYKOgMRUqmvjNw0PNbhIxm6+CoyHZdnK8q4G3XU328GTxRt
	 ii+/s4mK7178MQJJrhfY3++SKtYpycj6OUxaVK76RAYZOkj0ijYgjs06miLuhh4FdT
	 pX8XQoS/urtiGPX7Hk+y0SlyoXGdNLnWePYbORzrDONuBEvwD7gGyXHCgogVe2PPjt
	 HieTLBDJhRJOh/Gsp6SsFXkPaH3+gy6z1Go24y23GmtXfmlljgjhmsdXzYNLwxtJS1
	 HIcRrBE3abHvTATaIZqEfXuLQpZVnbt2dD6/L3emHHq11YqHIbGRVp612aYa+NMM/y
	 KUYVyLm+DtLEA==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7881b67da53so11158467b3.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:10:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXoa37a2X40Rv/a+L271YeUQOM2UTKGzCobacq132X7QQuyUl63U2oxgzeklst+Ub5/IBA81Qrr7A==@kvack.org
X-Gm-Message-State: AOJu0YwTFKuovWXFZUleSuEr9UckD4snfHOaue4KHPLfjvMbzyf6DkAP
	VVmuwStfhPwRhBq3E81S59ENem+vSIII0P9mmsYme+jHcMI76WARHQaGJp0WHggeDGAxGPeslQe
	99ovj2ADMZF94VBCJoitVp2FkPuonugc6xZ7r63kJpA==
X-Google-Smtp-Source: AGHT+IGynKYL2ORAX6XeiwPLgWZgGpkBjAJo4pbs4PUh4G9+7q4Cesnoj1/g73SIHKUV4DUrrnaaBoUFwJ9dgjpavjk=
X-Received: by 2002:a05:690c:6a13:b0:78a:6e1d:cc0f with SMTP id
 00721157ae682-78a8b572c26mr191226137b3.66.1764270600695; Thu, 27 Nov 2025
 11:10:00 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com> <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
In-Reply-To: <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 27 Nov 2025 23:09:49 +0400
X-Gmail-Original-Message-ID: <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
X-Gm-Features: AWmQ_bnLt0P5N1RtVPpK4guMfW2OEE5zxndUXlpYEscxjr7fB83mvzSMqAw97ng
Message-ID: <CACePvbUSHYgit93ofjg6cMfb+CR9x6CZnMGh7Utb+zEzkOG75w@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C5F1A0016
X-Stat-Signature: 5dxqj5o17q7cqnuk9upapdjgfg5a9576
X-Rspam-User: 
X-HE-Tag: 1764270602-142131
X-HE-Meta: U2FsdGVkX1/b7FU6ab4I439iipvrNzngnA9CcviDVPcRprnv5ct5DolFFUrZeNiri/Nf9tKDMcS5Yd2kHCGG6ON2QG40ItDYHp8QHtY78yrf/9q5fiuwR8R2p5fnSXvmlYeb658REO391gLQziK7cVMVJTqWxGQKyIHmrzWELIGCSkgBfJ+3vqKkFjl8ot77H0wlJT5dSxqgo1wpu69vzKRVZjF5jKxgNcOUPugXfcGs4ydpchODePxudPrUtNmy7TlfOyY95J0ASj3xiw8HrHPmVfSpNstN6Mzf6r41Mz2NwD69+23aO1XkaHUDj7TSnj6iR0CWPzrCJXkpjRMjV2nrfrrBtdCJE0vJ2UHBS2I9H55prlhP0pXBmGdf0trpYbaBzX5l3NGygIlDMOtj3n33laKPgxr0sS/euspLbK0JAGB2RMASCXeC5RajBbI3Ex9Lr5rmqC/6Ee8SMEjO6G98SHMJ4ga5sNvPj8MOLAB2nBu1XLAqC9vUW5BMenyB5CWJGg+Tg353qZ/RoS6kyZuGeZPZzmM7eUCqkTZr38ejA/3J4CgWNJgIGNmDwd3+vHm+5lHD0d2UyXWiWcvHJ9oJgE4OuYGJmjWFiEiHPSxJk7tyN2Xdoaihr+FK8lm8Gg80H68E0oPHhDrotxjNsAGalHckMJDbCKK5TxRmB1eWaiCrBQ0MhYSVMwwZiXOgDIcTGGwS2rpQLyPi2iUYQy0wXaEsem09VF1xA4LT0W0urPauXpYhwBH+KwJ1x0lZFXQJOIivVUbRcfhwJMs/fclzGlSiGPt77WFvdMotYBgLAsgpI0+XzC7KP+4bOLb0LOKB4pYizny3cuvjF/Rh8TAtqnsDQNfj3u8uQxjl6T05ZsuuWdXXLIyBGCsa9bvDALA9Fp+j4NGdDQjlGh7F4tWnoGXM6GFiG6Bw0LOMlqhwaNpJv7siiDWbc8eCMUg5zB8vbPwnxT/r7BvliQ3
 SLjr6+xN
 sMlNdWM3Z/lRUFXag7ySijS+dYn2YWjqoR8WOwdjrb1CrL6RsqCRoorVNncrH9YoKeixg88RNr5KbtDXnNHg0FxOYyHVUB6ML19/D9cPWyXmQnWwoPQC37kpXVzOgIzf+wrZSK5bT9ODoVQZ36Qgo0D8BvqZHc9PT5bBLSc2RNHHweCQsVNQbIRUjTRvo6zdWfn1s+kvwZc2cvSnC8SZ8m1cMf61IHevQxWyGNkpDasC4d5o+097G5gCZtT1Rs0ZOd0E9vBWC4RJa0KZC7kDV5HIeddMay1ki9ghVvqEXQGKQY7GumCQivmq7LRXUojI3g0UO0471Q9EzoYlOWaR+5krfFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 6:28=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> Sorry, I am talking about upstream.

So far I have not had a pleasant upstream experience when submitting
this particular patch to upstream.

> I really appreciate anybody participating in Linux
> kernel development. Linux is good because different
> people bring different perspectives to the table.

Of course everybody is welcome. However, NACK without technical
justification is very bad for upstream development. I can't imagine
what a new hacker would think after going through what I have gone
through for this patch. He/she will likely quit contributing upstream.
This is not the kind of welcome we want.

Nhat needs to be able to technically justify his NACK as a maintainer.
Sorry there is no other way to sugar coat it.

Chris

