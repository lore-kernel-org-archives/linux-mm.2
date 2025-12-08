Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34AFAD3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4A86B000D; Mon,  8 Dec 2025 13:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC116B0010; Mon,  8 Dec 2025 13:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2916B0011; Mon,  8 Dec 2025 13:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB446B000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:15:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C83313A0A5
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:15:54 +0000 (UTC)
X-FDA: 84197107428.23.D54E120
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1FEC02001E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:15:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Yrb0Bb4l;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765217752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8J43gCwQQgVAiJUJZGTrDPf/rsilcNMXDG/0Q408jc=;
	b=1xpyuqIDrd115vBJd/ZSXTNgf60N60vQXgEopEbWFNO+o2ScacdGysjXYDov7O8txyCltG
	4yZknwTUPCur4F631xqzvcQZt4yMYk7bR0spYWi7glcIkgiJOfpk1sCssBth+vUrMnOWoh
	cVBu6tmtWbREEFefEkaev0DPow+yPUk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Yrb0Bb4l;
	spf=pass (imf03.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765217752; a=rsa-sha256;
	cv=none;
	b=IpUBB36rNESUnljC3bIV8D1yApR975ic1bxzseLpjAVPa06ohTonAw9ELFPcnbPiUxOt36
	Hm0E/S3wvDUm7kFSYPnT+0MJnSKR6/hJIS9erS5L/+4FulOIXGELDHcRnQhU4rW4K0v/E6
	Vh4HsVzKjBGPfuUSQjt099SXwq83Jk8=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477770019e4so50839055e9.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 10:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765217751; x=1765822551; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R8J43gCwQQgVAiJUJZGTrDPf/rsilcNMXDG/0Q408jc=;
        b=Yrb0Bb4lj8DbcsRkKgKSiF/6UCQIM+ZFaL/FnftEdmL7DeftqqSy+SW4Y/8ebii3qk
         4D7jbYsuQg82ct/F/lWnlOyvlgKmg4YvvIJaV+Q7D87w39xrtVsN9ILqbZcHvwFeo7XG
         7oW9xMC0hb3FoVOgcntV9sH6PaTfsl7Tk4j5i0DUuAA8w5jHaWAh2VfLnerxn8IUAhaS
         +POhQpco7a+rTOoRwZdEzK1dZfpdTRSx45/sfQP7gQpmB3aNEvCplFu34chtsHqtufJ8
         GE+Tv2w+0F553we3HK0VwzFfk9mvq0M18+37WR0f+SNmRj4zxF1qHZOzNMz74wUVmr2c
         6kjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765217751; x=1765822551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8J43gCwQQgVAiJUJZGTrDPf/rsilcNMXDG/0Q408jc=;
        b=MBtE9kwZOYBWxenuzfnALm8gwJbIAAvme01uIfNOifYZ/93mmm7472pme288IKhPLV
         KpbpJNKP/iLMuioFrel3RrEfl+6HmI6FSyudvgNXkh0teDWjsuuTaYZpM7hIxaGnqYcb
         TpxRO8lBqJ2G1pG1bjaj3zw+rOcSE++gJO5MkjCBhq8HHka6fRBEZhzRZ26wEOYLFxYJ
         WEXqD+k2oOO3jb9qaEKqW/zTz1dkzKwRqWcXXQqEjysmDPDx4e2DDvvRxBOod45wiXW3
         cnulUFNN4nWjRUQkv1KxjF4bvkiBUGZCGOapUg5FZyPgxoFOGH+PkBMg5HqLAfgoMBfo
         z22Q==
X-Forwarded-Encrypted: i=1; AJvYcCXO5qP0kgFyD73FssfB9wqd9QUE9clnVwZCWASQ3n92DK0wIKT0v1muZO8y6Yr7IPec2GfVOGzXQA==@kvack.org
X-Gm-Message-State: AOJu0YzDmI76exOTMYp0r0OX6zT1vXpvwA1GeabMjJwfOS/iip8RECyX
	KOWZG8zaDBYzB7odJmKSjKcqfDiA4AakGiu33NHu+J4FhHpM9PGj9Zafrx4f6H+9Zyc=
X-Gm-Gg: ASbGncvuSUtrNzv4LRhR6Kc/6n90gRFtEU2ZtK2z6gk2SovrR7tI1s7oS55Ev1Rqsdg
	diyG4PD62oh0kc8ixFTNTLraRM0Ls/5gWqbKg5nRNEvfa/nYptCKIuLuIAN8eR31W7rBOGlfpG8
	goGdc+ZdmHuWPabZRiC0oYh9mO7YTZk865r7okdmFE/+D2Ufe3kSlJ34XeEahykUZMr6gs6dihU
	tczrvTgN+uTVuBry81jFZzrz8U8BamTMwDXrfJOFl1CtTavXVVjN3ZHaJXhTMkhcFjauUU8hQN6
	PRGs63WcZEsn90015scpM9qWbqeFRJTyYYqImmqmB2H2nzjkuyhsCpa1CoK7kAOV3xqSwGYf1qy
	xwtEoGIzjS0cE1QsMN1zKV9+TBnIVCzlhibsEMkmC8gCLMD5BbfOdrxngW5M8T1xFJBe9Q351EN
	4lSPjR2C3YUd7i/H0xtt4PI/Se08o2QLc=
X-Google-Smtp-Source: AGHT+IEt36ETzJErLHmXOiRn3Ib/UQS4igGV7/dPjeHWIxOPurlffSBsz4CtRRk4uiSDBZs1fMFwhg==
X-Received: by 2002:a05:6000:2f83:b0:42b:3ace:63c6 with SMTP id ffacd0b85a97d-42f89f0c50emr8583747f8f.16.1765217750626;
        Mon, 08 Dec 2025 10:15:50 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cc090bdsm26358878f8f.19.2025.12.08.10.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 10:15:49 -0800 (PST)
Date: Mon, 8 Dec 2025 19:15:48 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Paul E . McKenney" <paulmck@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH v2] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
Message-ID: <okpn5az3myvmz4amfkhyixxzb3zemcm23omfqzggbp2vr4jnsl@r2rdp4xmbsfz>
References: <20251205200106.3909330-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qwow556tghczrm2t"
Content-Disposition: inline
In-Reply-To: <20251205200106.3909330-1-shakeel.butt@linux.dev>
X-Stat-Signature: 8ndhnp3pfudy15cco6u4oep9zqh1i6i8
X-Rspamd-Queue-Id: 1FEC02001E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765217751-416182
X-HE-Meta: U2FsdGVkX18k4Ee/czspLxrvWkCJwBYH4uHJFQzLBdTmfVH3AxQ4oUV80U7bMP8vI4PcclLOHhCxE+RgdL9PI60+awd4PndQRsyt7EAzJaTIYfTzO6khd7UhvzHxOCc3pgZevp+G63HuagrOcMpL+9hFo0CVRh7V33iTT9JsaNeXPmUz3daMnNz+2Q+rBcm4xh+P4vWrHTI5ZSK3X3O4yErzFNQI7nQRZ/SYVPpJIksTezjUWkoMWO9bHOTvZ4otGMQ0YxBc68Svsn1vTf71Ra6oBGl8JqcmUUOzbagc1803S0a/syEXc90VYJAPRa9XKBBGVXM+/jJjDC8aCXjGudTmxb+JsyKBBnweHAEsw1d29gJVI3KDWyFh1SoCZC9vJqfMJW94SK4UCjDDOL5VrbpW6A1AWP++gSfxW+C8+7S6DRG0bXSfHai0suyyzEzarSVFQZILv6RIieMM/mKM5RxKiDKOZxgqkdBD77Kmi8yku9Aqf8KH/xKeG7qebeU2aACD7bfvjng0ek7XIfeEE8hSInh6yxzLIxBDGuAnguDBMD+C3hmJCavKWZsuP8eFc5OkJ6GBN4CCVxZDlVixWCDO4CvT0TNf1ixw75/YwmiXG8DJaVKi9qB6QsGlISDqQxd/SV/uHCyf0HbZuZkQOA2+gsqm4eFiSwf/G7QqDmEZv6CteNBnpkIgMr9zphUPUbfFOktgp+c9tPtVaPPJ5zqeqg9M217FC/IOFGSIEcK9AuFi2c3miAl93qYMjFcU/fHk7ct/kob/OWz8sh7SpT0HiKlKU5sK6S0/42vdGMapuo+SaT/zSzgO0KLNWnrY07EcpKsHmoEa6lyqa2kwSYI4kh6IVL2WrKV52HszNlBCQDcKDemzvGW8lpUpjvBl+dzLf7H7CJdmyOE0orFmFZM5Ea95KB/sxAfcXX8PQXJdIXQVbzf8uBPw9My3rw8YIPGHDBMXEf/M5yOPPH8
 SygeXSwB
 lxGri5A3mvse9YvE6NWyrv/o7DGdqHba9jQNB3xq7dHQ7hRG5ONeueiuAj3fyceELX8HwJXwBgrR3QLdlJWBH+zrpdLtLQIbSJ1qP2kRYoWXCRNPC3y80Yb1nUMf3jXkswOmgFFR15VCssNnlQAPPQUMaDE0rlan8Twpqq49+082ok64fPiWmEOAnVDjRQlprJP9xhWtoJL37hsYG0rs05fh+15i+a05mjh1DmWqy1xHZibXaeUBiF2oKcJiBelbBg6n5P5fUZ7SWMclWa6bHgpEW60G6rC1xlk8fmbBKg+GaHiU6SPzUKcNZzJrAhCUNR6NMDdTtmq3O6n3yu4gM9PBm0DvBuUjzLA8rVy2OQzGCHBFfPoScVsogVmBbQjUT749wMmwy77sFA+AQUJI3/pAPhIhC3P46nOv+KpXPumcByzKR+kCBX9eX1O1QM0i1EQR63q8kkfOKJW4+azrfrOAC+BPjrsF1Nc74
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qwow556tghczrm2t
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
MIME-Version: 1.0

On Fri, Dec 05, 2025 at 12:01:06PM -0800, Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> On x86-64, this_cpu_cmpxchg() uses CMPXCHG without LOCK prefix which
> means it is only safe for the local CPU and not for multiple CPUs.
> Recently the commit 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi
> safe") make css_rstat_updated lockless and uses lockless list to allow
> reentrancy. Since css_rstat_updated can invoked from process context,
					be

> IRQ and NMI, it uses this_cpu_cmpxchg() to select the winner which will
> inset the lockless lnode into the global per-cpu lockless list.
   insert

>=20
> However the commit missed one case where lockless node of a cgroup can
> be accessed and modified by another CPU doing the flushing. Basically
> llist_del_first_init() in css_process_update_tree().
>=20
> On a cursory look, it can be questioned how css_process_update_tree()
> can see a lockless node in global lockless list where the updater is at
> this_cpu_cmpxchg() and before llist_add() call in css_rstat_updated().
> This can indeed happen in the presence of IRQs/NMI.
>=20
> Consider this scenario: Updater for cgroup stat C on CPU A in process
> context is after llist_on_list() check and before this_cpu_cmpxchg() in
> css_rstat_updated() where it get interrupted by IRQ/NMI. In the IRQ/NMI
				gets


(sorry for another mail, when I read it I noticed those in a different
buffer that may be applied if you decide for v2+)


--qwow556tghczrm2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaTcV0RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Ag1bAD8DcVIeicwScrrr2qtm+AA
jyCckJM/q3WC/BusHmg8lhcBAP4FV0SLsim3T7JWzj8yc21NS+nT+TMN99yeRx8w
1AoE
=+If1
-----END PGP SIGNATURE-----

--qwow556tghczrm2t--

