Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E3310A62D7
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93086B0005; Thu, 26 Mar 2026 09:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C816B0092; Thu, 26 Mar 2026 09:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCBD6B0093; Thu, 26 Mar 2026 09:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 943A56B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:47:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 455711B81CA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:47:56 +0000 (UTC)
X-FDA: 84588342552.05.E23DD92
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 50C8E180005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:47:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=alR1htrV;
	spf=pass (imf16.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774532874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3oU1ZaWY15KqHTdXghcWSWByFzglfTk9rdjKl+Mk/PM=;
	b=CU605tw2lZyMpYYh/1KrEcG3RTn7ehJR51p20vNwJWsxUn7Gp0qPT8ZEcMhm/jTeovwteh
	s0TT9eDIqVHz+9pVOmoqR1q8adbrLQH3Oz+BzWphnI9zYhyUK6CGSflBARAeDei1Z0dzHS
	wiDQALB9L9hrIGgMaxYXdrokcbnPKXk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=alR1htrV;
	spf=pass (imf16.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774532874; a=rsa-sha256;
	cv=pass;
	b=J72WVCWXh20P7+6cuJHqnxOJkW14mUSIrt1J0vOYbsOVJbnyLasPNR79shA4B21ySn5MtF
	1oyTAeAPu6pPPG0ryThvAGmnyZM96UGCpeaSqWHBncTjwkFe7NZ2NZCGIKWR/sgQ58OnPZ
	8ztrwHLNrBuG0IHdK52suzOy5zvPJrY=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2c16dc38120so87861eec.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774532873; cv=none;
        d=google.com; s=arc-20240605;
        b=jHcj0q+ObfCxjfpZNw0iRW7BRo85zIsQIwWoto6Qw9X810wQzd6uHi2ypSrAu6Bb9Z
         PWHsw/CvbE6jxUy/hRBVc0CDRmyzR4wPuPsvoLP1qNmH7wXwhcjjS/eTBmbgb9UdOzr8
         O0qx4HSN60SnChE0kOSPqFlxM8YsEIKHUjHjuzTb9UQEHH2OAgmsP4wJ8/JaauAZSZQ9
         o9cl/+pSCoujxjjOZqGpDuXT3DgNYt1nwhhroku1EBAc5latu9R9AYr5bey6kGYrhtlN
         ge35wmCjOl+X/exe9wvhLyMXsHTXnYg9O63XyOCMgPhKsU/fzvYeUc/ukcxA/aLgDcQx
         Z1zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3oU1ZaWY15KqHTdXghcWSWByFzglfTk9rdjKl+Mk/PM=;
        fh=uPClOsts8ijapGZxZ3OodBJp6iHGdF40pUxVqJcNAYc=;
        b=cpmSm4XAryUnWJ3SobQDylOWWJc7PIgvEzQWNfEv7Jzxl+LTeWnuoSMpdU+otW8MPg
         t4CmvK0vRM+ANMP9e6MsdhnuKpiGv9/8b4gbGsOCmemAKOjTsJqi8MDGskp2fIPwYY34
         nVRk74KJLSgIFE1kvASYPVBojiT54tqIPtCLe1ppNFX+O/IBTzPtbX3z8F5HuOSZrMxj
         vN0dL6SSwYXXvUHW0JE8NpLPsdEHdh1jfPKWjOzwfBOSCgKM19CwpTsQSz6sZW4qpE4w
         k+iKpvPv097z6o1sBP8X44KeQw5iyb+HGOt/bErOUV4SWV9rfdKcJgpWthryiqy8fzO3
         F6fg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774532873; x=1775137673; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oU1ZaWY15KqHTdXghcWSWByFzglfTk9rdjKl+Mk/PM=;
        b=alR1htrVsrGv3JsZdiDNX6TLq60RCXM78gvElQrp29QiaIHNlaYDw/RX5l6RWV1RdJ
         U0/UNS832WljNwryy0eixRFhLbsslkwgn8hu201aeHjhgYzqZ1HpQNFuYbt4dh2PcPUh
         LEpr54FhkuckFQd0zhEbIs2vkG8Ir078h4IVtqQSuhhgpQHsIM64mq7xadEun7vu6Cnu
         DUoDwK9wcL25Cpbu9a1MAPXgb2IzyaPVKQgakeOWYFGX20ZccdayLMki/KUOTdRHTFLA
         Z/AExYB4N5xkNA5XmsClgDWF1a6IMBj2lXYF9CtxOcjwAbRM10esxkawrzlG2FfYQgMg
         shcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774532873; x=1775137673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3oU1ZaWY15KqHTdXghcWSWByFzglfTk9rdjKl+Mk/PM=;
        b=BSF8bKMafyAXcJ/SP7yXm3MMBvYg4YAIirVsV1rhAUkN5Z8LsgkFYbC6BkWaoaY7to
         aooh30aS5EMRk4UnLIzesh1ZFDkpA5dUVOrRrssqU6sDLzzpToyN8lhAZ3phx/pKYhI3
         g/AH18OyZqLilvg29QrtTmW1to4pTiyGi6hKGI4afOcpLduc/tOMHxKxjH/5x0D1ZkxX
         fmoPWW+/61m4WG4jY5BtBr+crN7ejoLiYiYp3rhD2zLtDa7GpG1w8os/dNZccm16OVB3
         5EdBDxgN04biobxacXId6TVbCwefBjc2PkxtvmAXfpVvM5bOit9dNHFzseiupdT6+FqR
         G9Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWb4ed+ASozP0xGq+9q3LBeIjKjt9n+ObECGD8D6NJEswrAS4HoNchsXdlsvEomODdyCeUYMFEBag==@kvack.org
X-Gm-Message-State: AOJu0Yy6k3ThXJOXLfpkSHBBPbhRAkZSBlSKPHV+fDaZM6cWp7lYflUb
	KkowL5QfuHQsmTahde9x5zgKE3tTiQRKrZNwA4jKFaCTM5Rql/+tMVHQZioplEI4fDxCY9bKfor
	TzeOPzEM0jgHLI6b5DXjFXB7VbHegwto=
X-Gm-Gg: ATEYQzyFQRzOooX4UHP6bz82eudL7L9rrV342FG7MDF4QJ7QaUpxHUzkYCqmdynzCO0
	RP5wIF/dtcb5R5TE2cCLG23hfuTJPT4iQEo/s3aLp7D3XjDqyCWKyjw3Xqg4dbyuSl61D3gO2EP
	7UO64mkj8AlIe5lkr894l7s8TAkK9kSFpNixQd/mGwZPmRU2+yL1uidFWyRTlc3M9sqmizbFykZ
	yzcIU3csdpURmu9ikp1aJyqL3QlQ9XJ+TLuQL4Aibd4TGtdcpnf6wXRqk1z0aaVtILFbdpegmtG
	HXKEjJSBBywhm/vNeQnCVCVHbi4KBGpWDD0gM+xPz7L2C5/6TKYT1PPRcC8ww+kdOm37YOcdj5K
	MtN0omwbPvRUHi/op6BmXUZo=
X-Received: by 2002:a05:7301:5f8a:b0:2be:140c:bc2b with SMTP id
 5a478bee46e88-2c15d282067mr2176054eec.2.1774532872905; Thu, 26 Mar 2026
 06:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
In-Reply-To: <acUGAsjYvNvTEO92@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Mar 2026 14:47:40 +0100
X-Gm-Features: AQROBzCEnROF6sNSCO8peAhuS8KhaF6UHZKXXIBMm9aT2zIjtnika7P390Hajek
Message-ID: <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Alice Ryhl <aliceryhl@google.com>, Christian Schrefl <chrisi.schrefl@gmail.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Jamie Cunliffe <Jamie.Cunliffe@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>, Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, 
	acourbot@nvidia.com, akpm@linux-foundation.org, 
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net, gary@garyguo.net, 
	johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, llvm@lists.linux.dev, lossin@kernel.org, 
	mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, nathan@kernel.org, 
	nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, nsc@kernel.org, 
	peterz@infradead.org, richard@nod.at, rust-for-linux@vger.kernel.org, 
	tmgross@umich.edu, urezki@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: zqowiz65mz8dm7dsyq61nkxbp6a9s9z4
X-Rspamd-Queue-Id: 50C8E180005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774532874-916376
X-HE-Meta: U2FsdGVkX18gtElB6dLRdPb1f8TB8X9DGeaaWep2TdRGcZLeouoEdEX6dcaezmAS3krtZ+9hIVyMvomkwt02vS+eFHBiBHTx+UyIdef1AHJ4Fic8maqoTI9RWmH84WygfsQ4AHAlxIb3gQnEPOgFKpNfL5i65U2LadXA404XQGuz5sgqLr2ARFv7hIVR/9qJUn8YH017jfKnC8sWlQiEiV1RDX59HCtiAYNPelR4bpHmjw5h6gZzDMpr2xR2//Y9jYcX1wsLCKVItWUPhYQCynxnNKrFWHfTmIcODPVrDNCYgo+8fHiZQNV6PXKokVhlFvq+HG7RfhF/JSIXCYLYqncOerRAXZ7HMEm4VhAq3QO2kyiJF56pcUL8XyiMTTmAE941TLWjuVUL8fqKBSYlDVvZ15XIfIeR5zeCkwpoiOXEqs+btVhCVSciyRauaLIdsaLdT3CgMOmHiqxb2aQN95Rsq+jNFOh6bak6/Cif9KziEe7RKG5Mc8PmR+Me9h/330cyQ2T39Ioxr5BVVpBx9XS8N5iFtAg73oxdaW+RZ53E/X2aFvr2ehaZL3DOb5H0zEwBQdf0LfQ4+QW0OaY6Ucdp8urTkZnxCMqqB31uet5tbOWYIEfdZcOaL9zGMHFjrqOJn2+4QrGP5eCkH5dPNEWLF6+LpZ4DfyobFvADM3+8ZsniSqfbQQ4yMbNvaB2Nduqx5M/0OEIt7eVjSITKx31oPX5bxU9i9BEionpRa/ZCnN5x+iqvCS0UBK8PsvSNy99hBtHedmHFRXKkT/a/guPZ0egSUedK906ZM/3XUTLJZ4cmh8/Y8dmCsfPuA7S7/8IDoqlVMW9uIY7mJSVAb4XdR2zqy2BeX++5YWzwyCw68e5hUP0L3L+wPJK3VGU3Re2L/EOyesSJRgTaeBa6omc3PG2Lhz8elc3t3Do24O+Gi1dUd3HnFA07oQPTS9jISKAP0CvFEsAQL+GBRac
 pe16Un7v
 UE9t93Bn2AKA7D1UbFsnIVYy1S2SwkJZb6wHCSjEUOiel+039B7Z9v8D7f8p8Lz6smynnlIvoNDJcGnY4E/4xQQrNPtX/q8c+NY5fAvOhl11ScvV9a6MBV9Pajjp8ZptP4Qv2uu1g0+9oC0cNfkZTuncEmdP2/D7rSrCjvUrZnsPaRd5VFAKFqR2Lgo6C5AhpXkhTHl2iSS0f/MXnFq9z4vzQB35rGKrj6sj7uKavN/s1iGVSXLBN15fX8o4gh6aryXBvu1TbCz/o4RbEI4cW7OSPxnnygClkNv25FkVW5boS0RwBcyDjDN7TTNsRRTswFkrzwjFkDQy7D85aqjaW/CxETuwURW7IPZuJdJBdm/Rk8B8ne8L8NtFMnr9GEMndbFZxa9jVnv7BSPofxxKlSV+eW69aNtyt5GzYCO9Bp+yRq2ks9M6JxbxQWTM21LwdGKywDoWrUPA7GiRPIsOVh8cMPoeJfRauhKItXmQt9Y5yTZLmTOeva9MNYE8TwS2duisv6HX1pyKp4IbE1Qtlqou+M5RyGgFAtMpbkZ/Y4x36u4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:10=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> I noticed that the Makefile currently uses the arm-unknown-linux-gnueabi
> target. It should probably not be -linux target to avoid this? Probably
> it should just be armv7a-none-eabi, right? We gate HAVE_RUST on
> CPU_32v7, so we should not need to consider the other variants.

I think Christian tried several targets back then and eventually
picked that one.

Christian: what was the reason to pick the `-linux-` one? e.g. was
there something you wanted to rely on that target spec that you
couldn't enable or disable via `rustc` flags or similar?

Cc'ing a few folks.

Thanks!

Cheers,
Miguel

