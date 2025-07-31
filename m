Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C6CDC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 13:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C118E000A; Thu, 31 Jul 2025 09:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15BB8E0001; Thu, 31 Jul 2025 09:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD888E000A; Thu, 31 Jul 2025 09:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9698E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:39:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 305BE1DA0DB
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:39:13 +0000 (UTC)
X-FDA: 83724666186.15.608ADDA
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4092314000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:39:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="T/2HEime";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753969151; a=rsa-sha256;
	cv=none;
	b=EmCY1W/opzEHcyx7RAbTVUKZwKkzyKN2XINZkOIuj1n20XhEMimtKrcZsalxluKsO8Zt+X
	k+dQZNKKHWtPoMb4FX6SmYcj6EggjsG17A9W6o+WpSTPyHHZ7dlLLp/62IOoNNyFpIV9FK
	QPJaMJrqRmaQNIuFYJ0zppmu3ZbgyWs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="T/2HEime";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753969151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTMiwDI5I7ZpdDu7u29+O3OSLlyCf5CWJBCKHAd19vQ=;
	b=7gcptLGW3sT+AI3R758gtpG1noiwI6Wcc6xWag6VJugdMFgLx8p+ljZ0EyQQMUgpUJQk63
	+nS0+TEgL4i+kih22x3MhBKRN/6GfN26S4HKlBSJV6zrxC/h0EM1yVpjfaEP+r9qkrUjZf
	8Xu1fKjeB1mEuFYmr+jxbXKoAKZXmzY=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a54700a46eso589817f8f.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753969150; x=1754573950; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TTMiwDI5I7ZpdDu7u29+O3OSLlyCf5CWJBCKHAd19vQ=;
        b=T/2HEimeNdRHcramFWBAf9Rl3dVvRu7A/w2dXNpv1F4Bavy+O5sETjWme+R1UM6nOk
         jMKt/UvENNryp5+YOJCACsUXhCx7rArs0/LAyL6383qSZmyq2CRO6rRZ1CSUbp5C58i6
         EY2UYt3zdEXYpT0PyLjjCJufPa031oe73oWoPDNCYO7kDBeFJC1S4pOn0KG34WLNnAD5
         EBB5psk6bIQWuI/eDSg0rOQCGcL/s1la4fCD076K869XAvgdSGl7a1sfOA/2+oRS9uuE
         fg2ZKK+2XfmBgWpTstyK58VsyNHb3ryzXdq8bb7/KJWAZSnqOPjfYmSJQzrKfJNHfHIF
         3BZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753969150; x=1754573950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TTMiwDI5I7ZpdDu7u29+O3OSLlyCf5CWJBCKHAd19vQ=;
        b=MqC0G6BJgPncBIWqCERrcNdgKfgVwY8Zi9sDD2gDRBsF8ZV5VNZNSnKM/oWv/gxALE
         FzSKv7MmrT8ycwtix9V6y+Vgpg+C1OwerXZ2fEeI1I2nDaKcp2hRcndw0KJA6O4EWEzZ
         BplVQdM6VlSyxZHxftZ7KhP8TFuJkyV5hCf+x1u1YQAdS81yC8VKIU8QXfrN4tjgxUwN
         l6ESzVRfl0qpTqUYhBqLIeq6Gi7D19K9vUHceB7X9tNQa+jFKQVkR4HWBpCsknJoqF5o
         wVZtOet9xk/wDttNJwb2Ws9Cy294UvTELzmefTyJyN748D5QwrXVOz2Or3I27anxYB5F
         xinw==
X-Forwarded-Encrypted: i=1; AJvYcCVgWaX+YLgV6u4JXVkLoG50B+avmwrBDTykf50j0eUXMsHxe018ZIlE1u8HZ9c0D72KZ0xhw2mMBg==@kvack.org
X-Gm-Message-State: AOJu0YwWaZdDVVYitqrtUbzkC+bx180f1GKOzN1qMfPCWEPDQRT2xvdC
	txTLtHjT2tclO3KJ5P9R9cUsjZYmM4nd2xKumFPM4sIe4WARgMDTiOABTwG5z7ZdPR8=
X-Gm-Gg: ASbGnctPNv4HSQDn9iqczmo/ZXq/tJ9FA7KMIqGy9v5DYcJJtSQJKpdXUGHDqrTfGx9
	2l0H92uIrLi8BF0FNBjb5fuXYsFPJoQ/UeZn9HF79E40oRBN2Q7qL91xgbkb+fKqnFvA8j504HI
	8RvNuCep5F3XQRn+E9xbvCGut4OSBtuZtWBmGpPIEa9Z74KPy4wWfhUMjjcMbAWBsiGsLqqdliL
	WIXZkWdmf+1opPm1RGNYbnLSSIS3otnY5hA7UsPZYOz+O0ctBlj/EJEjaiRkq78JMTU8ijcHkTS
	vY1vrtNoszdQtv/8MkTPzsVdQLtEqWdWmepQFOnzmeyUBYvaghN22Kyr+QvgubA3MAUgLPSUuEc
	VhtO+DDOvoYMta3CX9HncR7wu5aX17s4hModAGP4gqvhEosHjFzED
X-Google-Smtp-Source: AGHT+IHYvsEIX5itHKow1mLcVDqvWDuNXSbVTG7QQc1tvuwHoyl4F7TOUm51Nd1pmo+PXsqydNAs+w==
X-Received: by 2002:a05:6000:40c9:b0:3b7:7c3b:1073 with SMTP id ffacd0b85a97d-3b794fffcd7mr6922320f8f.52.1753969149579;
        Thu, 31 Jul 2025 06:39:09 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4532c4sm2448753f8f.36.2025.07.31.06.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 06:39:08 -0700 (PDT)
Date: Thu, 31 Jul 2025 15:39:06 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 11/13] net-memcg: Add memory.socket_isolated
 knob.
Message-ID: <pvygtpy4b7napeudlk5dtbacgvqf6j4lrr5nhye6obrwv2ss2o@ubxpyqwf56pz>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-12-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wvv7vwafoorhn7v5"
Content-Disposition: inline
In-Reply-To: <20250721203624.3807041-12-kuniyu@google.com>
X-Stat-Signature: ebbfs5u7anu8my5qzb9mwxx6u8g78cxj
X-Rspam-User: 
X-Rspamd-Queue-Id: 4092314000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1753969151-719871
X-HE-Meta: U2FsdGVkX1+n18OJONEMs8H3692LoqssV4FS3uqyS+0Hm7tpEnxyT+ysrdRDbzsMnlpe5INfL3fbkra5BeacPfPul2BsqNF4G4yt+dkZB7LM7cXH3Xagiimb7eFyEaqRTa2g9lpOX9ucGS2QSGFtrOc2aFoTLGUTQ/NZgAGAZLG8HhRyIBwHITjErXD+T3BdKFZ1pktVfxAlyLDXDY6E8QuIMZceWH4nWylVU8AP7XcIIBLDdTL+Z6dIjdn4mRlHB14HzV4b2c/RQHoEYYKEqMxFAeqFLh9y61TyRRJPeg58bEFv3qnliYj6EDJny7WwU80wl5XQ/t7du1ebxS92GGIeTtigNycTvuJCZ5gE6ZJ9QoSqOI9rqFMPTBeQUx39GcvW0i9fWgciOjzL6MCCXxQvTdAZbGXEjQcHl0yQzMeYeGKLdpLf8rQV3MTQMK6ORNi84boq5hsHumdcSAmxmcSXbcGlAZCg2DlBYxkQIovj7jfO5t11EPvUnByYOV8e2eewFXnDjxMyXrQwUMchsPuqTscWynISeTrWdXa1YSGw9Q8k52cq+xnMIluAdouhlwEdO+NaRp+ZeBuHztd+Yi2SIlUmDDW/74ub9lZH4WRIbFrwmYyrcNRC94fIr8n1C1q8pwzoznY5RcFsKoyPdiTTbS3Lh7pVvaJ4Ib4Ul8QPHbD/0/spFjPhA+IkwJjbMuA3jpfYEEDy/1m0di8kAp/cxbWpP1g/1doCnFE0Vjoxpulh7Pb+h/0WeJxTsQiJxlJNTw94GSQJXmmSyQzZRMlK+FSPAmJ8jrOogdyFd0k0uZHUJ7gtWf9jchWG8ZAnaS31yGiszXBRGfXY+Cgn6m5n7xEznkOq4NHxiEpgGLLWk3AyIMAlGiEVrX7JbuFe/gxR38E9dWwVZXs9ozNdvG4kDJSFa2TEombOeouR04z6iGPlWyi6PMqlBXy5s6bdqaNumHWLAEEIN7H5qO/
 RabMlwKl
 mML7ScQ5QrOhgSaq28jN/PytspX3hku48Xcri21eimcpvUQTg1D0aMgQ9KHuR9+KYkxgvh2ihpkjSPK689RK58gBPgBUCZ5F0iMEqpD3zHwwJbbpa0O4Wd0XlgFKSvoAf06IjNn5T3hTAk3Z8QdtcVOzA90rjIojB5dm7TMeXx1I6+Cwb5khBiSBOlDNWOrwNDp6WbtsOLiJLuB0HY8pwv10arKRlJpv+s5J/9E1KfoKeYTPxQDBguIJ91MaM1Fp7K46lBj79S40laEskqqQIzst2v7RSd+KJu8ZuL/9mb/8/gTOl7bafsgpg0cxxrOE2kUt7rNDU8uRIdllJJ8+9AnXzEhCJ0tDWaFJGYjguysuKAIL8bLQvqjBiepByoFO176yGbw5b4glygbBYA3m+QreiSwAZ3jbG81HqnUmiVRHNgILJfuUhvig7Cx1zKvfxaJZlWvmkfPkefr+WpgGDDMC23Q7lqljh/E0ps578ysyZbyS8TRuxtCym+nX99Q8ndnUj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wvv7vwafoorhn7v5
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v1 net-next 11/13] net-memcg: Add memory.socket_isolated
 knob.
MIME-Version: 1.0

Hello  Kuniyuki.

On Mon, Jul 21, 2025 at 08:35:30PM +0000, Kuniyuki Iwashima <kuniyu@google.=
com> wrote:
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1878,6 +1878,22 @@ The following nested keys are defined.
>  	Shows pressure stall information for memory. See
>  	:ref:`Documentation/accounting/psi.rst <psi>` for details.
> =20
> +  memory.socket_isolated
> +	A read-write single value file which exists on non-root cgroups.
> +	The default value is "0".

Such attributes don't fit well into hierarchy.
What are expectations in non-root non-leaf cgroups?

Also the global limit is not so much different from a memcg limit
configured on ancestors. This provision thus looks like handling only
one particular case.

> +
> +	Some networking protocols (e.g., TCP, UDP) implement their own memory
> +	accounting for socket buffers.
> +
> +	This memory is also charged to a non-root cgroup as sock in memory.stat.
> +
> +	Since per-protocol limits such as /proc/sys/net/ipv4/tcp_mem and
> +	/proc/sys/net/ipv4/udp_mem are global, memory allocation for socket
> +	buffers may fail even when the cgroup has available memory.
> +
> +	Sockets created with socket_isolated set to 1 are no longer subject
> +	to these global protocol limits.

What happens when it's changed during lifetime of cgroup?

Thanks,
Michal

--wvv7vwafoorhn7v5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaItx+AAKCRB+PQLnlNv4
CKBoAQCcPd3B8EVlIuJkCxAatf+KBj5iSIWjGLHkL/wZBSIiOAD/Td1vVJkjNLj+
ooVS07G9ZINI6535eRR8nUFbbc4lGwI=
=8P5/
-----END PGP SIGNATURE-----

--wvv7vwafoorhn7v5--

