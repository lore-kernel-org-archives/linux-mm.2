Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E86C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4986B0095; Wed, 23 Jul 2025 04:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC586B0096; Wed, 23 Jul 2025 04:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D21B6B0098; Wed, 23 Jul 2025 04:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 38B2F6B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:38:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB9C81405D6
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:38:07 +0000 (UTC)
X-FDA: 83694877014.27.78D6D03
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 970BCA000B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:38:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Md8vE+41;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mkoutny@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753259885; a=rsa-sha256;
	cv=none;
	b=LLLkoLafzzCJ5ySZ18o0y7LQwx91APIw+LSDqJJVLeAMaMWM9Ud9ef7INIojmx4Y0U8z+7
	kIPcjU0DiDwEFwp/uNLiQM0LI73WVMLxGqfzKSPhWtdSvUiy97pgcb2V3onNizaHN/wj7v
	uTHP6VjgPDX/hJGscH0Iht5DhkRKXGU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Md8vE+41;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mkoutny@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753259885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3P2VApwyqZcQGgH2xsyRWVJMZr2KQKxV6y9K6HQS9w=;
	b=LnypC3IaWRdGdCS/pM+hIRHUXwb9JW7HUdkb0BUaa+/C9jfK/GA/YmejgYqiMgevcOkzFq
	K1OUimFm7+6p12c4G7dzJRrbVhodhWaHyCfXIWWpPU+htu1A1mpD/rpcB46FM8n5nMKQx4
	U7jWrGiAErtJbzLixujoKsNJlqtqJ1k=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-606b58241c9so10459417a12.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 01:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753259884; x=1753864684; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n3P2VApwyqZcQGgH2xsyRWVJMZr2KQKxV6y9K6HQS9w=;
        b=Md8vE+413/gd7RuRR++eQ/HkKgouzXHZ9TVoRttgkebwoboEsk7UNgYXoGUxnjSrhV
         enZ+KJ5xVaQRBb5z7BHC8XkR9AQ8nBjw4sj6QRGYbRGctuoeFPMklwIwsut7xvXTVTAl
         apQsFqSBno6+6VratEB5XAgiI43c1zFf0EAQCQcpg3HU+jW6FXvbnv+q6fk9dv4Bqip6
         nBgBIuITWMsmGhM0L4Gr8mNiBpySqqPtUSDFyZ899lTQApd6o4avKhmx8lmY3E3W0b4s
         386GO3iZfHIh0s9J2ipuoc0fUsmlh+JinNgVVv4bOUl/YHVBN5oSY1hwD7ckYIvPGPzr
         3UOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753259884; x=1753864684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n3P2VApwyqZcQGgH2xsyRWVJMZr2KQKxV6y9K6HQS9w=;
        b=JgS0aXLsvfKhC35kQBO2M4GI28TKVU+2qio64k+mHNfYGPbtt9nOF8IK8gcycOHAD+
         IoYsBqbFiSsbsKAjc6Baz9sNiabJ1gzh5FJRIbk+2bPuLAdPIikZW+DmPjgeMovsO5h3
         jqImutfCG/NPlL0hxEOD3ooxLLF7V26cbAJh7HpzxfkL+rGfi9UEvbvTvlp/VOFyaNUa
         T71bO7Y7rjgrijBvlOKt57C5d8xwX6OOFYga+MAaZ6uS4tG8Vxf/+DpdSExy7A/GvgJB
         8+QAQOhN/s4NnIWHsIWMSLnGmKh60If4zIZg5GnBhWm0gdNtwgkb6JbOQ43UJVZicS/V
         Q2Kw==
X-Forwarded-Encrypted: i=1; AJvYcCXv0Xa55pFHIsJ+p9VVpCEFuAb9UW+Amm1okk3vJnbfe4ULklBarmkRti2CvYDGd4d4wss9JL90Sg==@kvack.org
X-Gm-Message-State: AOJu0YxEV1kgSTDYw3SkHFhWqbMsbSuB6qeeVXCcmOrXvHAKbBomZVTC
	nO4CfxZZpL4yy+yLF7PZzwVKGl2zguLJgTSKiY8sqzp4L8pFPEVqfG51aEMGRb1PSwQ=
X-Gm-Gg: ASbGncsGtAF75xKQ2hucd0MCpYmpnLeNbBXY+sCL8Ixt+ha/lky1rjUA4hu4VPkP3S6
	msN9/7+OuO/aGqgIkfI6mXb9kGcYhMWt3E0pc+gnpCQ4zCBgJqj/RiZX/N+fzd50lSsIzu3kQqS
	SW8n0VrKCGfsS0je316cqe6J71WlLW1l9Wyzm5ghQe1dIr7fhHUKTzO/vvZ7CTckrQEf0muQYC9
	JD1PRX29IACsyt9DecyhFROjEXL2t6fgxFJxiFObRyXtiwttHE2ek6Wd0cNCF8cxSsYX+9TWYD9
	95aE5dBkAbs2IumMYSt+lr+hFKEuG8THqhT+OUQSIr313j4gIiaaQylljbgNnxTSxlug3spHHwf
	TP014Y9lJI97i
X-Google-Smtp-Source: AGHT+IGfKxkKSgjfuBbrA9aMKGgq6w9CMUJszw4YPTrPg/PbU2Z6gWyowOy29hJBo56zgCZxcn3x3g==
X-Received: by 2002:a17:907:3d0f:b0:ae3:696c:60a with SMTP id a640c23a62f3a-af2f66c5e04mr165593266b.8.1753259883713;
        Wed, 23 Jul 2025 01:38:03 -0700 (PDT)
Received: from blackbook2 ([84.19.86.74])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6cab5f53sm1014137866b.136.2025.07.23.01.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 01:38:03 -0700 (PDT)
Date: Wed, 23 Jul 2025 10:38:00 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kuniyuki Iwashima <kuniyu@google.com>, 
	Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
Message-ID: <yruvlyxyy6gsrf2hhtyja5hqnxi2fmdqr63twzxpjrxgffov32@l7gqvdxijs5c>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
 <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="i2zmhp2yhqwmj7st"
Content-Disposition: inline
In-Reply-To: <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
X-Rspamd-Queue-Id: 970BCA000B
X-Stat-Signature: schn41m45oo734bo1xqjtco8oiukuaxu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753259885-678293
X-HE-Meta: U2FsdGVkX1/QNYvAqEA+8vzkQniy1dwTjK7CiR5G+7lDstMWUFIq/mwKFzw3F1+oQQHOvo8osvsqbfAIZcl20TG1m8B8nlJRVtdb9s7AX8NvuNouEEFgR6X6HutBFUIGo0kQijvbrviPLj39mCE74liGIgAJTaitqTJscULfo1v/sva9e3SnwULNN6ldRFcNyjQ8QQHs15QFORNDlatmowe2Y5Okoi1RqizrKxZKXarLrkdH3ltsHqs9sE0DLhEbIUA3Ajna3AlbF7eHLe35K8bLCPM3mlQ260Yx7JFG8bhlcKZDqxJ4w3wlAh2uSORSni6cRAtKSE7SfGjocCykP+dADgGyMUmpHsH9rD3WTlMlrHK2mq6Iy15mnaub8Qr396kWlpJpWJ7h9vVnTs6Fdws/TldAP4OiYiyQPz+q6SMKaLcjc26/VVdpl2BrOYjcj7x/NtehUluMG2R2JWWpn+UH4Xtw3pNCTGhCnORE8cbqxfT0dj4B38wsBkDVa2KMTq3CqGk74RYm40gBbGxZoJ20jqotqmT1DtYDjnyh67W/RkWHLmxILxbWZuSVfMwBT78tPxqek9fhfeRBNr/mIfzdU+wCVvVAUf/6QFz7cz4Ued62lCg7hqfuIsFG3AB/MOZWiKMOUtRVlihpzpzPJUbqZI4t2K32U8cgp0cHpc7WME01ahdewm5olpX/PtGTZEBmvcudQYpCTQQOH9lKq3MJ3d9gl4sq1eNST6ydvWNhpEI7AL+hzQdXk5saQk41HgMtUL3LMKCO5ciWJyC1njffqXHgdAxBWnsTki9+SyOBIHLSnUNjxkrpc+GUW8SiD1HSGCOUXfcNDDEP4cOiduZ4BS5i3DKT19D02hL/Oa+jlmJJMKy9cGx6+rHXRsjFUbwQEaNp0biplDzL+0tBZHdUS1j6LpPT2FoigTNALYM7gLcZjB62IFeKOrc5fouMNdbZf4FCr1nyte1D7ww
 UtL6Ht+a
 mz1utln/lXNC215mniRQjC2tf7LEIPJ0w0/3nMe7Aua0wPSdhS1ysgVlwm+jFkD4EoxYpEWqDYpzi0cAAHEnMMH2ETbI0hzsup8sGdk2QpsfiH+Luw6soitA+BFtwC0knnaLHnrb9u3YhQBS6gCmMI8GZ/tr4MN36ygpMFprO1A6PcYpuyekE2IcK2QNyW4CWZPaX3IcQukwn+vs1aOC3yG370F3UllRnrZ/BQbB8uG67hi+GRId5C/v2RFpC3c/I00g3AQRcBWllI/WCqnnP9Q47ifE+vww730Ei8ykIxbyA4587gWGELkOWXEQj1HY13GjpZETGHWDC0SC0Y4nHBNl9IzGR9mwho66DUsJFsI6nsq1yLK9QyJBmrLaXtiz/mgxXm1bUp009YZFLMnZ04GpgZXJwran317D+kRQ4LRNfkFt45gp3Qmkezg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--i2zmhp2yhqwmj7st
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
MIME-Version: 1.0

On Tue, Jul 22, 2025 at 01:11:05PM -0700, Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> > > 1 second is the current implementation and it can be more if the memcg
> > > remains in memory pressure. Regarding usefullness I think the periodic
> > > stat collectors (like cadvisor or Google's internal borglet+rumbo) wo=
uld
> > > be interested in scraping this interface.
> >=20
> > I think the cumulative counter suggested above is better at least.
>=20
> It is tied to the underlying implementation. If we decide to use, for
> example, PSI in future, what should this interface show?

Actually, if it was exposed as cummulative time under pressure (not
cummulative events), that's quite similar to PSI.

My curiosity is whether this can be useful to some responsive actions
(hence it's worth watching with high frequency or even create
notification events) or rather like post-hoc examination or low
frequency adjustments (reason for cummulative). I.e. what can this
signal to the userspace?

Michal

--i2zmhp2yhqwmj7st
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaICfVQAKCRB+PQLnlNv4
CE5mAQDDOte4EPAzuuoOKqbLKO5Ygkc70z9WHcXnUbPwPcq4swEA8kCX/rxqTORQ
i9MXibIkSfPBUZjxLcl7kwUmqFoxXQw=
=1mgK
-----END PGP SIGNATURE-----

--i2zmhp2yhqwmj7st--

