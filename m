Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4650EC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 12:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96CC900063; Wed, 13 Aug 2025 08:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EC3900044; Wed, 13 Aug 2025 08:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC0A900063; Wed, 13 Aug 2025 08:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB36A900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:03:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4434AC0388
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:03:50 +0000 (UTC)
X-FDA: 83771600220.22.8F3EB8A
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 33723A0013
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 12:03:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ceG7qNzB;
	spf=pass (imf15.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755086628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYV2Res5TppAzTUXHhwCHqIxqoUTRPjCneBHo1BZ53g=;
	b=HmtpNweuOviofSFmRkEmwfff3Gi99raCO8dyl+ksJlPSezxznDBGmz9zNEXELzLWWKKEOM
	evVDNeV8D1WuGTTtQ8QaoULGbVdvaFSHSi0SQ3++fpWaHYOOJe6ZMZJvusP4UuuWraCqKz
	0aUqOpL69+oP4pVDIF4UytvbZU4/nto=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ceG7qNzB;
	spf=pass (imf15.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755086628; a=rsa-sha256;
	cv=none;
	b=O6a8qdr01jsI5nPvHsmtf4CfE/SiVYQ4PsIyRne5rKiN2wvI4hb/vBHqUA4ZJRVEVc7deQ
	vI2IcA00oUcpXIp6s+Z5rA2Ph61PnBqhOF55ZoSz/BNyDXa5mxPkbpS8bZVWrHDN4eFlcc
	qVyWzev4/ysy6N9Swfd4ugCe2GKfMgQ=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3b7886bee77so4641381f8f.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755086626; x=1755691426; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AYV2Res5TppAzTUXHhwCHqIxqoUTRPjCneBHo1BZ53g=;
        b=ceG7qNzBHt1UGHJy3fjaeznduGB/yreFk5fUf7yMmiJsAlt8Co4hE2X4DWw9KqQBOe
         acv2jj1NZV0UcgkJlnqtowXkugFe3tcvDtvU63fABobKc94uiQrJym04oGF0ZV4bETxy
         wx01sebsEcf/Jxa8RMMkDOVoWiHVP/GlKaOX7wFAtCWAyxyUxzNnRN5bPnfyZLL1rCAl
         +4W5wm1oTdvg9tZ+ihY5AW3a8kFO56R2gCnprwau0+0rFIfQN3J33mNUX0EcY+tLQtVC
         R77iJw3MDZefZ15T/uqNmyg4Ym0I+BpXlhI6VGnpXRF3JZllliz1mTWFI73B4rrvaNfu
         0ZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755086626; x=1755691426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYV2Res5TppAzTUXHhwCHqIxqoUTRPjCneBHo1BZ53g=;
        b=lKsLDJppZVYtBxP9z+eQeJE4NecjlcXkc2foH1DMV6hPKKxMOM+vEO9bbYyEplxn4N
         1Slx1eszdlB82aGXp6ni9pzt3ooe54BtC5PztQjK8gOhl63GzYh7zuFrsn590O8fdlWZ
         aAa5naJeOQQ27ql+xlGs+/GX7vTwJoKUMWtJFf7g0CEEnU6EE2GV4NMTx5b5v2OT/LLo
         nlUwWo0rBpSbz3hu9MhCBQWnliFMCbe7wiD1otGyjP9XeC7QK4NQC2L/nlv7WRNKv0Aj
         jgQt+KGfFPkfAs+1OSnMCF7kn+iofYnwolYbF8A73eRmPR08G8GNASEVx5vuGXaLFShU
         jwmw==
X-Forwarded-Encrypted: i=1; AJvYcCXnfIg1T2c0EcIdB61LSpt8nOtLfy8WeoSqxdbebjbWfJZeqZu3stytz1REBvB5cOgKkN6dz/WlVA==@kvack.org
X-Gm-Message-State: AOJu0Yz3avyDCwq3bmdH5vDWuJvYpkwdlvfGtd+N5j7e1Dx/1MYK9A1w
	ge25N6MEWPiVKICXDPfu56YPTgY7mkf7feY1YGszqIAO2EAXuJpVSvmH5VN9SOqknyY=
X-Gm-Gg: ASbGncuW1KX02T3frXwsiyH8B/YyWFdakwcXjFxSkmBaZn/aMz3v+/QH5x2Nzp+kYcj
	iYrJ2IASO4KA926mDisMlt3avtXpXnAwDpVgpmxIBiuzonL4Ha/vHBVoW5LT54BpLaHAcwlbLm0
	8D/bqmwXWmburMKRE5CLn/DGrRf+In3Xqusr0i9pqjN0ZNfU3gUNMaRi4St0GT5Xs7pQfgOvG9w
	7sPSsbA94fuAUWLRryeH/wBxyadtrvRQohGIvV0FjaoQIfsOPX8GPifJRmC8147k3996QmaJIwW
	5OZpGroZN7erkkZotvKmi/LUTZl1huyzgyisKkD+4m2EgW10GT0lQFX/Rtk0+WfwKyux9ujBHPG
	izhIAK6roIsGxh/j9F8+32ZgsZxgphw0KwJJ3gQzJFg==
X-Google-Smtp-Source: AGHT+IER4YtqUb7xB1LDrkZc9vHAKsgWs444jj/zWeJsU/7bJPHATWgzRmAT2FLVQz2bMtHbgNBC8Q==
X-Received: by 2002:a05:6000:26c9:b0:3b8:d6ae:6705 with SMTP id ffacd0b85a97d-3b917ea1577mr1823732f8f.30.1755086626282;
        Wed, 13 Aug 2025 05:03:46 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b426f0883fasm18082064a12.21.2025.08.13.05.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 05:03:45 -0700 (PDT)
Date: Wed, 13 Aug 2025 14:03:28 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Tejun Heo <tj@kernel.org>, Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <gqeq3trayjsylgylrl5wdcrrp7r5yorvfxc6puzuplzfvrqwjg@j4rr5vl5dnak>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <aJeUNqwzRuc8N08y@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ohticu2i4xrkbaoa"
Content-Disposition: inline
In-Reply-To: <aJeUNqwzRuc8N08y@slm.duckdns.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 33723A0013
X-Stat-Signature: s9mymfcwczhypbhfekjkn6njfni65fss
X-Rspam-User: 
X-HE-Tag: 1755086627-117461
X-HE-Meta: U2FsdGVkX18hkTLGqrpp8buqHnbG8Ld9bcNvEGCetV1TiUqsAddeNJj//RZ0fGUELu61XETzCNaCFdiaRAB2zcR6pCI/c+XWWXhq1m7oNoCx9564Z0EVSh/nV1Ll2d8iPHDhFA68TrgrbeKVqmsZP/tgGGCfxVS5K1xi2DQ9osih88r6bWpa+aTaFjRiV+5fYiV03ZO6ToOiYYgIeT7+6aC6BzET4eIkH8BpwphA74evOsb7XijBAiC74jCADnNDyY2wfSekA7S75VEScmcHZOCAnCXsJZ6rt7nRdxDK+mZQzHiGKfSQkgOU0oH9+5GRzdx/fO4KRfYUQbUfihdI8kz8BJg5YMTDWgKUmu9CtcTDYd4A4VGuoHIiSBiE4lTGyqYvT/5W+1Wv4/Y3ybah2D96+KVks2TnHUCOl0zVX4tFIxmzakDhzEGB1jS1UDYPUZM2ZpDU+1VmQmoQ5EL+FNGYrV9xLRLJgHfA8D3g+KIxfYcAkO2gN4BeHSUyq1HYelM21w3e9nTfpfTIJyKvpagJLPiQ4486MzhcbGqNKTKUht/svpklvNWH9ZGYyKWGBqpVTSTRH9A8uZwQ1tr8DCxYeZd5iZsHWnu0RVScLcUK3VXEceZQ+d17b1uAD9HZ5JPw0pBAQTi7HaPhw8BiFy3RQiDEIMa7NSflXOtTXOo4f+CS3LAjQTHb5BbCViZe8OjmqZ3ZWhhN+5xyIBie8PbZ00/O/6zwXKZgCRnJ/+bAPYIU8PuQTM+vHLG9vcxgvox7EExBOhue1xLVpFT+/WbFXcmyIMCrDjlQBwDJCB3pdKVF9IghBRT3wHsOH77cCzDz8Mi18GwW0gCTYcQ4R7Wyo9O/yjb1V1L/Hqkf5jd8GEzwhBK4IAD1ZbV7L0q0FqKOSPKhLqspkYb/ceRLOokQd/TaVJmZ8jrA9Ezk44peSfLymFShF4/2Q6lr+tt+3O+M2mG7HpC5SxoLFYc
 Mb4cM8by
 8S2qdle4yoa4rw3lp7HFRzvf2+Zu1eYG7cwiWj0piyN4wTbtKm359EaMxua58hJQY7T439POTrTvhXZHVxJ08gzMQgsQxFe0QXarugQ4FAkCx6Abex+ss+irFV4Q+h+eEHLStra3AOPsTboqrjziAycMDhX4kG/xR77ph7+qmE4leMOQV5tVmMtW0FdabmHuUsKwmU91LTfl1MXoM8zupF1f7lsDC3+i0C9hIAAckQGdbv1MowYHdse5YY0fOejA34M/t8mGHpTsWclMfUFS/EcbPCg31537pLIgEi79QXV47g1nYarGU0eze8Ipvi3j4MYZKBJyfGP0TqC7b1sc6L+TG2+jEC9eZ3coqYf/+c/mojj2HmI/QVtBap/uIuPmnVoKmlZUl2nxMNANMBCsblrU5S/IWW8wES9zLCDyUelViK4rKXZrucLYS4EjpPqUFMr8nThsd5oL/nCs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ohticu2i4xrkbaoa
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
MIME-Version: 1.0

On Sat, Aug 09, 2025 at 08:32:22AM -1000, Tejun Heo <tj@kernel.org> wrote:
> Also, as Shakeel already pointed out, this would need to be accumulated
> hierarchically. The tricky thing is determining how the accumulation should
> work. Hierarchical summing up is simple and we can use the usual rstat
> propagation; however, that would deviate from how pressure durations are
> propagated for .pressure metrics, where each cgroup tracks all / some
> contention states in its descendants. For simplicity's sake and if the
> number ends up in memory.stat, I think simple summing up should be fine as
> long as it's so noted in the documentation. Note that this semantical
> difference would be another reason to avoid the "pressure" name.

One more point to clarify -- should the value include throttling from
ancestors or not. (I think both are fine but) this semantic should also
be described in the docs. I.e. current proposal is
	value = sum_children + self
and if you're see that C's value is 0, it doesn't mean its sockets
weren't subject of throttling. It just means you need to check also
values in C ancestors. Does that work?

Thanks,
Michal

--ohticu2i4xrkbaoa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaJx/DQAKCRB+PQLnlNv4
CG++AQDP1e1PiMrmOZVCNBib5p8lt5jF1ZYHE5uekhIEeGW/MwD9F23rTUtFtU0H
0id52DQEZKBz5V0PsOU7qzsmcZyROwM=
=yb3d
-----END PGP SIGNATURE-----

--ohticu2i4xrkbaoa--

