Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66FB5CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 13:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801496B0088; Fri, 29 May 2026 09:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2B36B008C; Fri, 29 May 2026 09:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1436B0092; Fri, 29 May 2026 09:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5944D6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 09:01:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1FD41C0043
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:01:34 +0000 (UTC)
X-FDA: 84820468908.03.0AA611B
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id BF1C3140013
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:01:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IvHzpoPF;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780059693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TKlBWJ3ijSz9GFQ8lE7XQuNEddJ05fSbljPGAX3zb4M=;
	b=nsQn273ja4m7acVjYMSQHxy2TO9ns2+60Lzt7dXPY9WsR4NZMaEW7xf+XZA0mdxT0s7WR8
	w5tpKJSRNjyXwvVK4P72If7WZLmB8ntyr/nqPBNVB8bcnD3H+gfF/MdFWOaqnHubofJib/
	laQNzGtB37ARXcdAKWPUdccCvfs5318=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IvHzpoPF;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780059693; a=rsa-sha256;
	cv=none;
	b=Qbv7v1ISk/PhWRpgWGXbjsQEfjFxUCx4Glo8P+UFjTfzmFTf/XD4/Az9f8k49P5qborV59
	vOiZwN+6N439oeTaQKa6J6GNwnLvhc70M/n9EwAcQhPyWDZCp/qg762VZBI9fs6ZV7LAHK
	wxYoCtaP+Aj0DrPyAs0sBujPqoLKeOc=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso71228125e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 06:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780059691; x=1780664491; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TKlBWJ3ijSz9GFQ8lE7XQuNEddJ05fSbljPGAX3zb4M=;
        b=IvHzpoPF+T9hmmqMe19m/ZR8uhORbzmfcqOOVW80crxb9AqJLCW7QfQmlcjSm50aFK
         MUshZ7ClJ+TPEk+s7OOU0LoV+C4/M2sXbZaGNCPy+jKSKr3xc7t8D/JBqYo5Syd6nj5U
         PPPXIyzK+ATKjMoqbya2a0T7yLTGXrIATl65axWv4uf8G1ILrj8qJqye7+ebxf0MM0p0
         O3a7rmlTOG94vBUBTm+x3o9cucvCkK8zu2i0D0RpOZPjZNwBgrO18L1pRtEXDHFmwVnH
         to8JMUq23Wxk2Wr5cPRn9i86MjlptXHCW9lt0/q2wNo/6Cd3xHm0HfN04vxITDFsG2Lk
         17Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780059691; x=1780664491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TKlBWJ3ijSz9GFQ8lE7XQuNEddJ05fSbljPGAX3zb4M=;
        b=jw5mtnKSVtjHRD5/tQTJqNB7pTWSVsYlaadXQ5X8TIQz9V1oir1iaFQCNeRvQZcntK
         H/0bGKsNpo0zObrF6OHRa7K30dA05UqhlGP8NqPyKZij1yT406AuUBboDf3O2U0Qk5bA
         nSKEITnx2nUDYgrogAnM47smJ6TsB2+uiPTniiECqzudHPwz+U6AHj1R3nlmtx2udl7g
         nl1ldlh9Wu7lX6Kg1cc2JpN8UCR5tx47vi0VfgmkGWA3yH1+eRZlwnuEGKmC+HKSwUAl
         djHjlVAQkajQA7vqHHA2gCqtknuSI2LicrrTsgPPPxMVwHa1+9x4gxFp444b2PaKHfj6
         Ed8Q==
X-Forwarded-Encrypted: i=1; AFNElJ+kpBD51DdQ/Ijm2otjo6e+F1xirMdAYjz/VyPAgVcXXCi+a753n/uk9UpweYEj5UtvIPlAu4Fbpg==@kvack.org
X-Gm-Message-State: AOJu0YwzsnydGr4YVqe9QHKxkjIGObdyt/vSjmo5KsMkR31mEgiks5qq
	KPeATdVFXHhVN2BKUxkC9Sr7sC3XqtNw0QzYynA2wl0g+kKzdWcFfwTbRbw5Kw07c3A=
X-Gm-Gg: Acq92OGE6N77jSda2p6GrjYuTcUXVa2Hrozp0VABURGhMZDZtvHdZz+AT8j2CT0jCPo
	y12UGrCE8CmvsiXMM3rZQyUoFvnOT0j6kB6ueyxY1kZguo0CogbMCMwCBBOyVLgU8J+A1LDFIDW
	J6d0RCwYt7amtcbSgoxtyoYGpilWWWtpwR+ephNJd7SCt6UepQcBdI7e4zQ+kUM8E2qLMkW7Qye
	DNNFWy0W0t4j1vZA8A60zZN4V3TI4mPb22Gf9hBPO56axtZZu3N4Mhy4pEkPhNDnmNqzTdTomxH
	XIvDY3O6XfkedF6KSsUNk88+3svk/OjHrKUWZ3K3ISrGeujjpepK5ZmH0tErmeoF+Jd4nbopneC
	YJCGWMV9cSDG8lMClNahLgefK3/qztUti/VZs4HxoKLY2DzsGmoMHIs3J6qT326W1bHDXqIATgV
	sh6oNvOiK9Q9+gNgzEhrUu+dFH9itEM2v/tDHZs9CdkEhFCiIG6HLZGogHeC4=
X-Received: by 2002:a05:600c:560d:b0:490:4ee0:82f9 with SMTP id 5b1f17b1804b1-4909c0920c0mr38130535e9.7.1780059690792;
        Fri, 29 May 2026 06:01:30 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909ca6575csm70478955e9.4.2026.05.29.06.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 06:01:30 -0700 (PDT)
Date: Fri, 29 May 2026 15:01:27 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Maarten Lankhorst <dev@lankhorst.se>
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <natalie.vock@gmx.de>, Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-dev@igalia.com
Subject: Re: [PATCH v3] cgroup/dmem: introduce a peak file
Message-ID: <ahmOBo02TA8u8RW2@localhost.localdomain>
References: <20260514-dmem_peak-v3-1-b64ce5d3ac38@igalia.com>
 <ahCISfTlN10gD8e6@localhost.localdomain>
 <89901220-0a43-4668-9d20-aaecc72c58dd@lankhorst.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2z43jkempbrnq7gp"
Content-Disposition: inline
In-Reply-To: <89901220-0a43-4668-9d20-aaecc72c58dd@lankhorst.se>
X-Stat-Signature: 159oxowc9z7hzqffaxmmbknxk8tiz1pq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BF1C3140013
X-HE-Tag: 1780059692-644442
X-HE-Meta: U2FsdGVkX19NVktYeYpJH2yD4aMIP//TSml2FoR/lHVP9T0zBTd2aii+Jp1pnD52bL1J5LB7OBZWGSqNaE0/dq2Dyf2kEAZ6Xo7COJH3l3HS6GhGF2jTOfDXYFmX11QBpuVEbDcnG2sbh8jQZxJ80K3dvpuxAgOhwzq5shN6AaS6hIm4AbNKyLFMy4XYXRrH+BMo0abeZoQpUefgwSSZZalDc31cKcy1g0RwSnrs4UBNUCLrUjWctQLiWlQjPQGPgOeXQCRebporfEye57ERyjJeEqC+cLMSmVCFlcSikWPvIhsAHRE2NAcmd6GbfWh9pIZB/oJojUK6k8PaseqNGUNbIYy5KTbgTbY1k43b9spceTgnv2/fZiCh/HVqWW8KaY3lmW8efnnakO9AXPQsEQbaGNJredHb6yZv9Id+9z21Z2PIRWUB9tSYCL1tdPCT5cq/S63L1qqFhxDf4C/AGs1wvwEh3h2EmXyj26LzpSH0FYV7jmmMV7bss2SLy5daO5oYz06G1d4cbrZqA7PrUBCclLnQQhWBeEsdJ349i6ykbdDemzXVopcFaofLKEynz8+Y017iJmUom9x/0rruQ17I3/krAG8fLeQCOWZabUDLo8jmq5APMktSvWALR+jkRsRvjgzKghD8mimqcLe83l1pP8lcMuFZzRIhOE7TO9lLYHew9In6DoYFyeW0Hip7qQWFNU5pjwMY1wyHH0D+smLufvPxo2ZFs0zzQRfJ9+TUBPdHFjE1mb1RRJdud3ZMu8Aq6qHED5FXqkxncPMY3cX5T7E8Gz6SfwCZHGxuSe17KRwmo4XWjhauCKjStkw9QN3Cj9z32SAjUG0qLgYwFCqCC2JErZYEbuNVvUDlZWvHABJLUnpExY4s3jZ2uC7JQ+w48RT4THWFA87RgbJNm0OCWWjuzbAT/BbbmkbhDm7lL2lTGkYqhE1jifC+9fKKSWXd00+iZM5FwH89blV
 LRa23BRE
 da0kff9+rp2JsoOThsENhvZVSTIfPwgvUHQhwt3YC6Tg14tyt0i+RZnWHRKRiRaHOv4Lbxgu5biipVMTfWh8zaMjswN4GcyLQ4adlvs7W070/E3tqwJRko4WFR2p4iMbw/swqfBt1+uNNnqPPVXIca5235spqsVCRbiAHHBmdIwd9nE2sopxXPfuVbcOoRBB5yKtWzRqgZgj7Tg2TXrYHd4GioPkto7c94W4IZzfmwvWugtLn/ZZPDFuDtqLBL0725c8BMIqRnA/u8EQkr9MbFNdnbG/vgWahjGRzcZE61iqLIzLgrgmLyGPCoR+qM3FoeUWERO+Dt2Tv984x6kXya23D13dfxtM4pIqQTROyRtI5yGzeE8AhGHoAEeXvvi62aDp3lUXXQTBu3WiT3iW8wV7w2UwHAXwBL7qzN04jVE9xU1odCeVnVPd7qMOPfc9TUrj1by8qJnNEE6M1HUW9tyWUoagjW/dJB8VIm7F4q6vCP2clSxfvjJ+oInKjHE/fh5vIQzrwlKScQrw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--2z43jkempbrnq7gp
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3] cgroup/dmem: introduce a peak file
MIME-Version: 1.0

On Fri, May 29, 2026 at 09:34:28AM +0200, Maarten Lankhorst <dev@lankhorst.=
se> wrote:
> > Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>
> Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
>=20
> With your r-b it's ok to push it to the dmemcg tree?

Please go for it.

Michal

--2z43jkempbrnq7gp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCahmOJBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ah7GAEAt/V3wEPGggC+JULstS3y
dmXXZPqpxAaQogu6yCs89g4BAMQxskRRFxPIHcGypjWfGqkYS3FsM2hfhSaRrkTr
5X8P
=a4Ed
-----END PGP SIGNATURE-----

--2z43jkempbrnq7gp--

