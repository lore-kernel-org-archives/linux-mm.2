Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EAFC83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 08:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE22F6B00A3; Tue, 22 Jul 2025 04:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9766B00A4; Tue, 22 Jul 2025 04:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEE26B00A5; Tue, 22 Jul 2025 04:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC22D6B00A3
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:57:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B6BBC02D5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:57:37 +0000 (UTC)
X-FDA: 83691297354.29.E2D274A
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60029C0004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:57:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="ODx9ehz/";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753174655; a=rsa-sha256;
	cv=none;
	b=WlBz+dPxsK6ceSX20G4KvAJHSlRgn9gnL6ckT7gAuBYmGTd64P1lEkBtomJHq/wu2OaKo8
	j575FlRNJOrhou6FZcL0ZzWMaJPbnx8TJV0GS/xUIEUA72DAyYXNY68FwtghImAhouv19q
	RJYxcyBshh7IVNJ1vpEAzoEQxEHEAbQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="ODx9ehz/";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mkoutny@suse.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753174655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNMnV47ZUbDg8R0JvYfcMgUdadfoUEmj1nySGscgXA0=;
	b=ZyY2H/sreJkWG9e1e+A1tpk+PyKtvquixHp5vJAFhL6a4/5LtN+RD0N+Cqpu2zdDv6NTEK
	hn3lbkP9sNWbmAvnH1mkuM1n2p8nzLSrWbl7ENcfyjKcvqpp9yzcXmwaIdVreMdpuGGarJ
	AmmEZqzVMIGVXpEKixQUMq7FuPtTTpg=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-612a8e6f675so7714121a12.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753174654; x=1753779454; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lNMnV47ZUbDg8R0JvYfcMgUdadfoUEmj1nySGscgXA0=;
        b=ODx9ehz/9hbjTfCOnbf499KqAhsJ8w6pkDRojA8t2VzmakngHcu7vin2QghMGFjexI
         XLwkevb2G8DhFKIGhVgmXY/VKfYnnOAhpEYRoHOyl2qxE1mL+hb6UKLQ7pVk1dXZRyai
         +6pc7vLq7OkQnZ6j9i5VnXqo4En2zcm2kDym0p/dhGEGPe5rg5Csb/I+5vYb3wMQCLNq
         f3ZEwFhRqscTZ4ULN/FoDUu8Ladm8D/aqVGqeXdVMnBGFNBlUlU0meQgAMi83DajRuyj
         DkDtm5iAhUyL+cj2h8ufsmuXFrKoQJTRbhawTIK2QYtqkfhISYZTAE7p1Yt5ibkQDnUN
         IMoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753174654; x=1753779454;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNMnV47ZUbDg8R0JvYfcMgUdadfoUEmj1nySGscgXA0=;
        b=EiZZHvMPDoyHohB1S39XZCtdyaJhugybad6lO7RGRmnIFq1GK1CAW8EMbTEm2TRzUP
         Qv5AJjSQXMcxtDTf7iMjQV0Jen40aJCG21CR+8ikmOlf1Wd7hXT3INxImLrAoJHQ7WHL
         OP9Z+wG7++oIu5PrBmozonhluK7StyShLYl3x+vq7VhW8kjYDRwavhrjKZ0z9JX2458N
         39PBWjOJbf2ABwmpyeKSF+QadaPVPRElU9YKqioXwA6/I1lpWSsqE6Qa1dHZoejxBJOS
         iRydsFAnkwLpwIu6/UouUK+cGXKoXV/tBUw2/EJlglArcYTirYyCmNLm0lMddXVHXem0
         oKXw==
X-Forwarded-Encrypted: i=1; AJvYcCVqm7EXyhwzrxj0l6VYUrdATjlzBBXOhHN7IQAOKI+vl8GeIXKJUyu2oZwobRkNgHJEEzfnl5RZNg==@kvack.org
X-Gm-Message-State: AOJu0YxH8KpiSBGzmprFvG0Af2dIfOsZqmOrver4MaaXu/dfD0tLrheG
	jVa8Saqp43hs+ByKZBKqhwd+Gj4JWdiuAK6R5F3JqAmTG1SMof4z7Op4Tmb1j6RZGQg=
X-Gm-Gg: ASbGnctkANLa6507YYkvrG5dvafFn/MyVBvB6sw3LnSiZ8ecfVKZpRF719Fkny9rLan
	WO/jtfiVmeoBLKY7jh/Wpl2qKATtjb5PXMLGkL169gGB22PNk9YT1YnKQKbSmFWongsoGVDiuC9
	Um2V/q4RAHr7UpP967jBL8FAu3QcQHAnq08EDr/acif2p9+NYL5EMy3JbeUFk7LuBYwO5SF5Emh
	JZegtj0IkLSal7DSueJCBBJFVNCrsTOsyZzTiSGhtqL9IMMuhDPPh+GA8YioOQ4te0QSebEGDSp
	JR3dTd8IYlDF9TO8kRDRqBuGTkRxHwpaFdT1NxwSESK8L5ZHAvjv//F3pNQfcP/ZQqtHOX/gV39
	2u5ZmDB3I6H7QOkCWyIeQxzdqG35jaXFeSixOukLpEg==
X-Google-Smtp-Source: AGHT+IHriI4KhT13mpTW0P5YyPB+MWO8TtjIccFRhtOyc8niEg4j4aeLhKzGzFFWbvcFzm+T+91jfQ==
X-Received: by 2002:a17:907:1b15:b0:ad8:8621:924f with SMTP id a640c23a62f3a-ae9ce1ad71cmr2274955166b.56.1753174653724;
        Tue, 22 Jul 2025 01:57:33 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6ca7d2dasm831496766b.127.2025.07.22.01.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 01:57:33 -0700 (PDT)
Date: Tue, 22 Jul 2025 10:57:31 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
Message-ID: <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5nf5kf3mjwyhcfjs"
Content-Disposition: inline
In-Reply-To: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
X-Rspamd-Queue-Id: 60029C0004
X-Stat-Signature: 5bsbiip3g53hc3fxxe6uf1x7yffsbxwj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753174655-618816
X-HE-Meta: U2FsdGVkX197E2gHH9L+uxrmEw7kC4nyKa11c5SxlHlCF6CfOw5reoYnXtcfCFcTl6wrosuwtIxPkcbS3sVSbhDwoNBDoqnC7mLa6wWuY2dDhVuZ6LJfdtjqtlj1WhGq8DMMHT+XFbelXWEq/kX4zwJQur7q/YKNPR8JY98Xjeav4lGr4oWFQTG56NOMLqFy4NNd8u2pdS19aKJBagFeRiFhJtSricRsGfnkbHqd9MFG8rrKggHcIaRHqJIRlSn/Tf5Pk4xJG0tX/I5peLDSYViteu0C6AikvFeQn86EamgECKtqK8OPJ3RHRTv6txddI392AM/5omzWFhL7TwayQZCKXyvf/2r0/Qye0pqbQVnNlTwTyGINVR57JaZyV3lRDMzieTnPKN56FWV+YYSCVi5yKZkBe2Yhllnv0LiSrJI5/uLckWoPG1aouk+AQ59x3CAVNwI/2f+ChzLKuGpxuUV6HKlart8OEykDiia0Id6P3YatZqwe+IykYqVfMmFFcvbY0npKD6olqMgaj0999eONQribtjqyDVpxPKCDrJ78zuiWQcmgGgRBU0cOvGwOsUY0fN9pXaT8kaOf0hDDJ9D/e7l7uoZrsGQruBWx2epcnvOH7cyCqAzh7HHx8tCDSU6MP4qZ0YsClm9ooXQKdIOmiVK4wm6zmjaM9SU2rw/h917umc3YfLRnUAoBByUe+mPv4GCAe5sG2WYARyuTD7q3MNSfy0MPPIppc0HmNpQsNwpJAVk+utzR4PYAo+VVcrJGMphI7PPTs4NIqzegQGQpzp7Gfgv207SiBSSca1FJfNOhXI/jYJdZ8E+spMzTU0aeBX6wzR7SljCgvvaCzOsk3N/lBPHE13y0iHTy3aMg2qwgaD/38OofxIykfxWCSsnJVn7vu9LNrZ2lcijiKxXal19dFtzVvgsCltORhDy5HI5l3mh3PmQ0D847oI4/IADYosrA7oaYgDHYsD4
 xm7Kq0Zp
 xQjcuC8L7hiZu0ZyNdHjvipFZ+raXPuM/JXOaILefS3DUI9eCunEIvUK83DnTPxFClV0ao51zL3oxRwNtKlDBq5QcxQTJiMlYd97RTsBMqPvIH+C15zq6hlD/CI31/s0ucR+Q/7VX8MYixm8uIU9HGky7Z0y7MdNNgy+8otg/fw/+khAdN/mZ42N5goHoBLTSuKB7fw63IzZhigaOZoeIM4QgSLSXOksJiEa9p3xm/0PD+zFvH14Vje5Eas53m2c8yJbotUxs4A98yCc05/YJBcQqtgmssTIMuASLZpQlBcnehp4i5gWLiEFw51yFLS1LeNTyh0JuZfRakHLqSGH4Bd+/CeuOIcEukSXyQibeipAYFjNDh/QV+K6XTioO0C8U88mcl8euOO6xch9x1mZpLqY2Nvbms3bwKjO/3xoIP3m19TRJFrcZHqpiKWYwChDRlhqnLZrY1v1yVEzANtL4PVyh8cIQwHar8ZM1VXIu4CKJhkstL7TrVPOXLjeyLG/j0KO3ZI4nGMv5wB/D83+LgRVs6gbAQDvYHgr83yEnqEdR6F0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--5nf5kf3mjwyhcfjs
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
MIME-Version: 1.0

Hello Daniel.

On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sedlak@cdn7=
7.com> wrote:
>   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
>=20
> The output value is an integer matching the internal semantics of the
> struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
> representing the end of the said socket memory pressure, and once the
> clock is re-armed it is set to jiffies + HZ.

I don't find it ideal to expose this value in its raw form that is
rather an implementation detail.

IIUC, the information is possibly valid only during one jiffy interval.
How would be the userspace consuming this?

I'd consider exposing this as a cummulative counter in memory.stat for
simplicity (or possibly cummulative time spent in the pressure
condition).

Shakeel, how useful is this vmpressure per-cgroup tracking nowadays? I
thought it's kind of legacy.

Thanks,
Michal

--5nf5kf3mjwyhcfjs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaH9SeQAKCRB+PQLnlNv4
CIQKAQCO5i3J7Cs42HJq/hTN0DwAicGGLfouEXIwhUAZ+gV3kQEAsDc74zW917vT
W+w/EI/QrRkPMIo/vDxFkEuhPHrLcg8=
=NGpc
-----END PGP SIGNATURE-----

--5nf5kf3mjwyhcfjs--

