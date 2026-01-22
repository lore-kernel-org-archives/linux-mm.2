Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92EF2D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D381D6B02FC; Thu, 22 Jan 2026 13:26:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D09306B02FE; Thu, 22 Jan 2026 13:26:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C796B02FF; Thu, 22 Jan 2026 13:26:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1F7E6B02FC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:26:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53B84C1D9D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:26:12 +0000 (UTC)
X-FDA: 84360429384.04.80AB7C1
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5BBCFC0005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:26:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k+uYvc0O;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769106370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9r8EjZfu+6WBBNKHZIudTdElM7NIcXhyZ7Jt0sf0KQ=;
	b=qck6yEN60Deem2iQgq8oR/UKg+I9IWW265zhMWkufgqoUpRhq8CYpJBpjwWm0DRP9xGvIQ
	P3oK5a5v0c+Ax4iXnq/xFM6eCL7CJgapAgItrvVCS3y9YD+qNgyBr0pIX568CjkpLVvRTA
	WIbN08ScvcyGrr/pE4J27iOKT4H6LMY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k+uYvc0O;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769106370; a=rsa-sha256;
	cv=pass;
	b=C8IbotQ5GKK9Co9JncYrqFathKIJXdVz5UGYWbQqlC3+NJuv+R8apO3el5/z7RFHjeWWrm
	ixwU20qr4ow2gt1QJLmuE4f/a94qjyF++ALrMRTDPKTxHa41KDg9/5EdKHtpQk6VuTbkVA
	ywrw3dZ3le3KeqNidZAz0YjEac590e8=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6582e8831aeso1984831a12.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:26:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769106369; cv=none;
        d=google.com; s=arc-20240605;
        b=jz6BqUEys/25EC10TVEz2FFr3oM1USX4mVPHS40cLh90jCR6LXmd0yu9bIlw5XUs/n
         yeYyvch0bSEo9jeRjQiFMcJWcvin/qKVrm+lLAZNdK7CDtGCrHqURddmb7vuLM8NCNSS
         +qveMm/EF4T2db4a3Dc74ON29E+57QKiqWvELCjNpVOr0rXGiBqYvugoM0ExWk1dEmi/
         SM3ZCyl2k1hVzVJPd/RiI42U+tThayst7jWVA9sqEtMQ1MJwxuYaIjlreRGYbV/rM+u6
         8D87IC1cO1i/yqNK4g4QHXn1Xvrp3zaJmcph2GVioC0dhP9gEFpn6VEtDrvTVkUEeBmn
         iPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w9r8EjZfu+6WBBNKHZIudTdElM7NIcXhyZ7Jt0sf0KQ=;
        fh=I5i8uVlA/k9rcxoFOKARHfbNpqfXYWCmYLdw34HxmKg=;
        b=MLgz7mTOlrO5pamuzcKFgN2DghscSe4mdxhqJbojs9R36pcHTAqkFRRIkI1k8wb6bc
         WPtoUNXHwzbpd5Mc9GDSbgJ1r8j4hZpykGxSSu3GwqpbulcomFvQfG/XBlYhxeTwKNFB
         3JOWFSA8TEtX1uzAb6nq0ZMv1t0/zNdjQ5yICXVWqdL6TGQc6p6hXXNvvzn5on/YC4NQ
         6nKk5JmpraMxvm94fpzctnfHy9Sjlnvyn7KwnTW9p/ydpFnCD72IxSqxWehD7M8uuboa
         16wWvIfu7Ifzqj5oRn3a0A8UOIBkr6IXzEwSS250z1pkikiO7490531TMyDUWhGtZZTy
         kT5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769106369; x=1769711169; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w9r8EjZfu+6WBBNKHZIudTdElM7NIcXhyZ7Jt0sf0KQ=;
        b=k+uYvc0O5a5BwAzMoGtVKPuLFmn3FUdujK995Ctko2zdvw6z/q4WVbwfc+FiUmTsnV
         DXGy4iK4lu2LhydzBHMq/GZuTZUCR7we2FVnrlBh6mGLwXKFQL5CHGuXwNiyy9s9tu81
         QfDj2yiIG1Zp2RgKz0OmcagL6j7Z3sFBK0nQb9ll+tRfP0mGMZthnw4pkjaWPEzBM5+/
         WwZtYn4K4gM+HhKZZzNa294hivQJ2mIX/cHDY8TAGs0p6LeLRlqvlP3lDb4K4rHvFxjI
         3ztgSLl6tuAyqNrTrblBlqyFXBkOjWylqItOCDK9RScWPhMe91YH4Cm62UnAGQBHkeMa
         YKHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769106369; x=1769711169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w9r8EjZfu+6WBBNKHZIudTdElM7NIcXhyZ7Jt0sf0KQ=;
        b=sKcicQpvC2p7W/UMQ9Ne2ReRbCORxL3H5VGE9IHSe5O5EpGQuasVd7zWAOKsF908W8
         zepvVzKn6p5tNa42E2Ab7MbIEfYVqwqyw+bLwwhA6xa6UGuR+7BPvMpw/3PC7+zFEB25
         h7lN7viJZshEc4iZPPdBNFcbW9J1StiTHaHRYhGMzBNov9WA9qksWHx8TIHEWuvKqC+d
         SQeboBfaL84j9vCl2kiLYTBy8VrkSaOptF1wpJCy4C21ZTQs0UR1P+gNcqF2WjgrK11T
         yVKJvBtBsU33IIUCin+BqZcQGG/XXtrjRTyu0D8kvLUyrNcagyX9wUTPZj63V7I1frnX
         Uk/g==
X-Forwarded-Encrypted: i=1; AJvYcCUVKeNpqZF3c0plw29ORP24TUqzwx5QnT1l3v4sL0d4PQveaoM8FSwtuuFA443Dj4n6e45HdZ1NUg==@kvack.org
X-Gm-Message-State: AOJu0YzF8CWEdu9PuTzDJjK1LiXPjTDZS2N445H1QuF+LeQ6WUBHURvG
	mdYYJm6FCcUUp7G0+I5qZ4NMamC7UoYOJWWf98bRszpvUJCyJ45PLqHSJxT3p9qPS3hFOEoIYkY
	b0r2G36OdpDP9jt9e4+d+NvhddxIHsKDtkoQX8kCLgw==
X-Gm-Gg: AZuq6aJPM+tDslbsMb/SyHU9vCHKUhveXJ0JkX89W68pDhbyeTLXpkmUESoZ6+HJ3nT
	OEkOTAXAVBFB/j9aXx2VFMWEDBKEPCP9P9jCu/N9HdogkOxYAftCJ7JryBLSqofRnVXB/AaHsZP
	JVX5ljQ+GEjIeeFI55EB33cYIC4fQh8Mi+nWkXwxDyS5lK9euVFOYNVOzvto668nTFz25mnWIuk
	eAZgG7ll1hSu0/YotL5jRTk+vi/IWQWNf8YzVynD1OI6Dvm/Wht6xYSlh/kRPV5j/qR4Rfz9x8p
	3M9iIJBfw4IhRsgWSWzXa3lBgw==
X-Received: by 2002:a05:6402:2745:b0:658:3c7b:5c3f with SMTP id
 4fb4d7f45d1cf-6584876232bmr343669a12.11.1769106368921; Thu, 22 Jan 2026
 10:26:08 -0800 (PST)
MIME-Version: 1.0
References: <20260105165839.285270-1-rppt@kernel.org> <20260105165839.285270-7-rppt@kernel.org>
In-Reply-To: <20260105165839.285270-7-rppt@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:25:32 -0500
X-Gm-Features: AZwV_QiXDdGmSgod4IzeC1v1Mi9Wmeos0iKetVDkwL8LXL1nrc7MhMPUl8727d0
Message-ID: <CA+CK2bBu=ThSf1nsrMWO6ij1cLB_TNrEK0dCCc8+kC-MtAXstQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] kho/abi: add memblock ABI header
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Jason Miu <jasonmiu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BBCFC0005
X-Stat-Signature: oqwmmu3u4ujj5w18sgc8sdderr4nbef7
X-Rspam-User: 
X-HE-Tag: 1769106370-757851
X-HE-Meta: U2FsdGVkX18/036p4Jr8SPFAI0GQ5EjcUMFIY2erL0wWQJmF4Q6GxwFVOnDBdmK/1AAOyMXd4FMT3Z0mRQJzftnBlyVfWkggh+zLP4qy80IUxHtpQCucNOgMCdQp6zx2KWcj1H9rHbFOhKjGt02mTSxTw2i9GOIfnTN13hRH7dnZPcE/Qz5Fo7q5gxJMhDM1uoH9SBDu/apbVDhO42U3iKIeo4z6H0K7My6I/voVVa3B10cXVrc58hXvBH49ETm5X196zUzBznvxW+AcZlGwH3rZfTYq5K9rrGmSjeTJJaFz02AxJO7xnGPDOasadFqN4faxsW+2TOsJi/bV9haHpunDeQPHAGoTDs/BOboPB0soVd0n29akwRASI+u6L8POvnGH6yTFP3tsgw2BJhQ0E2sC+4IlVStR6D5C0kE5dpCA8Baego1W93uisUAzX8HHQWgyf5Fy5PJgloJlbwHJBrNbrkL8AI53ABIRSQ31DUJHQLpUwel0eTFw3NNPgqkmgSZLTNueq2lpaNV+UUcNFgstDXC6G6FaW856UlXLAbO+OfYScIX502uh2zeoLW5Wg9bcyk65xROO2F3MJYt8nJzO0wQY5ruE4uyXNzTJ/fOmg5lUxGtu3IIdhPHgx+nVimmKxPYuuq9lMplyxqM2cUC0yr/FUNrM43nqZey3dytyLIvrWYFBHv9zdWKr0lm1hh9BTt8vxjjwiYMKt7hn5kupg6jWxaZqSBxcTlEWntblFno+vVU+T52qA7SpcOrRy+embPyXo4Ij1Z47md8QcpAQd+JLkIqOc8E7vEMoDMdBkjCM0u1LU1yKlU4o5AjofvSaZeVP873neM8p3iPWZ1N+VZwBu4zucQcKwpnJF2XQRm2SnXuUJCwU2FNV3vb/DCpmw3szGAsN7ohiPO7RDlNUdlrJ0uO/dYrJHDKSRIxoBS5c7JEEU2EFvp0Cf7FPNebv5aEsBJ5uf9LPjqK
 YasobKPD
 0xSHIwpfohR9DPsp6/BsD39Vyjg+Q3+k7xSeFwUpY8BfWuGPLFFKEuCL6H61ih6Mpm6zE4ax5vFCynwCG+i+PTDqKb4+T0xf+DiiMVbOCCZG1vLn5OLMBxLtqL1uiu6xwB5KVRjpax4blKcoibdWBGuH6Z3MY1Qr9eJLkCvKubol3P7B1U3/7ek8kALhYIXAHM2nc93SrkYOzILPfaZAM6mYPrQmBDQB+LOvXRMnTDineWfluyEWQWNjZn4YBZmF0JWKqMRCqEFb1l0wUL3ocCFnNzjrNVsI0KZvbcKUZzQke4IkcUuNrihs+6YHLvkYqPAmy/jMy/sS1oqch7O5HsVRQMp40fSQVruMperiH8vtlFpyl7jcf7yJ6Acj2f/f3Fuj5y05/dxVPnEqwXgNXQqlbLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 5, 2026 at 11:59=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Introduce KHO ABI header describing preservation ABI for memblock's
> reserve_mem regions and link the relevant documentation to KHO docs.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

