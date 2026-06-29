Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3ECAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B466B00D3; Mon, 29 Jun 2026 10:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C3D6B00D8; Mon, 29 Jun 2026 10:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B276B00D9; Mon, 29 Jun 2026 10:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 494D36B00D3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:29:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEA96161CDF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:29:42 +0000 (UTC)
X-FDA: 84933183804.15.477AC8C
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id C5567140003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:29:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d7+Mq04+;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782743380;
	b=XQBDclkfIXUBFVzSGMBXPAdH1IpJW3+7kYPl33grWsJ5wIDunz9krbndDxoICXikpfdtjn
	2XQKqPJZw1sYWZfdb75apirHuVlV9bimI6rA7ewrqwVTb2316y6qwoebA5v0k/iMcfWc6c
	UMpnMkSmHcHgddLZ6l/DkNDNQ3sURvY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782743380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jh3ddKrlnsR6/L9Ken2oqdDKFGdYCtJEQCrQvWBmQ+s=;
	b=tQmkgxKgty+jQ6pGMh0jdwpQBt4BUty+99q+gi4dpwDBDzOdL6DpZx7QWZJZMwN+/vdcpb
	EOjrQzdW9xdkLoDJluqGvptJO+FUeef0NfZKqhgDsc3rffATY1nWiGQnuDUtTJEsTlAY2W
	gpo0xmBDprPMc/B6Igjhokmk2OZog4A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d7+Mq04+;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4728c12ba97so1038243f8f.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782743379; x=1783348179; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jh3ddKrlnsR6/L9Ken2oqdDKFGdYCtJEQCrQvWBmQ+s=;
        b=d7+Mq04+hFFXQY6o4YCzKPpceb2senUfptWk84nEEWoTITqjNeBSy8h/2bemI1naBh
         G1ls/Btg8/mofXlw6yn/vCuAp8n92g9m3NLRkDQLSE5XMtGu9omE+COn08KDMHHIMb87
         O2OgARCT64scWBJBWMZ4BRj48jiSJ5Un36nO24gq2DwR5/Lby/SKd0NUvi+GppxasyQN
         okHPTCMKLcSsW4eQRlUVZkXvC/c09DfsN3gMknUlmeNgyBfLRuWZO4ATqFRH+x2zRcR2
         fzWsJHpN2FJGBcj88LjQSgdCmx0UB7R87kivV/o6pBtG+0z1dfy1u4W7kJoytaTqSIlN
         X4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782743379; x=1783348179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jh3ddKrlnsR6/L9Ken2oqdDKFGdYCtJEQCrQvWBmQ+s=;
        b=ftyrEIDleV+ynbARJz0bv/HspZItG1p4LP1WPv+bt+bQos4o5gS5ZiKZYovxHJP3y8
         8P/MI6QX2ENrA77sw4YaE3EvswhIbyToZoiVnl9YS4cKmEuRfs5RE1P1ranv3LpFtOvj
         7I2JbCKb7XBjAHw7GWKCCFoyX1PHPlUninw3C8b5qf2UQ4BVYxPNbN1VVwkTeHD3IiLt
         4ZRWF1/yaPnHvWBvzKuRndvql7Ew1Od3WmefKKx/bZvRwcBUoIjr5S9ygWefA4vd1XVc
         ce0alA0Ht35Jog3nYHh4bHDl38OeKA6i62N8zuLUnbWg5YJUh/dTaXD2NORSAVJtAkjt
         CUVg==
X-Forwarded-Encrypted: i=1; AHgh+RreLRkUaWCCrqdWReFJUNuKn81VgM3gIjRJ7pmkCm2AalGy3kX0dBzhAyx7yIAQ7MPManOiLH/yog==@kvack.org
X-Gm-Message-State: AOJu0Yyzc9XlUy0f36zx5pW4GlEyZrcmC8epCZ66MrinIiJRXv17AMsU
	v1QjNYS4GG9ORPGOojIfDqXvqKTgfBGOCNIBhGNsHrwXW9HAkUXoGWmRiGe+jQOgOVw=
X-Gm-Gg: AfdE7cl+Yj6xJymb2QTyP1as7x2/FADX1AWHFUjnjvC7cfBv3jt4seBhYv9VEhEl5pH
	oJICyK2Uh+O/q2MTrU7P4wtdFG3IM3x9ddVac4wUtW+flKMhcazlq2CWBj6ck8y//Xi8FEP9Hir
	3l3jtDBrkvRXZPZuVOJO6a8425dJ01EYvEtHo1+Bik90DUc/N6XKSzskRib7U05wqj9/ojT5Nnl
	6v8S8/b3DdpMwuoeRDrsFiYUbhGV0mL5s/Jmm8LyTknHrY8gU5Qp6JSL3XXVdB74HxGSlj5wlt2
	XshPoKLfREHiYYXdUJmXBFuh9rxpPiytXr04TlpyKeQePJiWv720jg+9bu5X9HHXjxPn9ZCurKg
	/3YPYhWfocfpU5WAYYPBUXRqgwT4BgAh1b3llMxJFvlBVx0qYvX43gdKLk8eUIfiYGYYdCMZbHi
	FUkVGhqZXtrqm5pchIfw==
X-Received: by 2002:a05:6000:2687:b0:473:1a35:7aa0 with SMTP id ffacd0b85a97d-4731a357b3bmr7628866f8f.5.1782743379221;
        Mon, 29 Jun 2026 07:29:39 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47290ed4377sm16257525f8f.37.2026.06.29.07.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 07:29:38 -0700 (PDT)
Date: Mon, 29 Jun 2026 16:29:37 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
Message-ID: <akJ-It8m_xm1WVLY@localhost.localdomain>
References: <20260629130042.2649505-1-usama.arif@linux.dev>
 <20260629130042.2649505-3-usama.arif@linux.dev>
 <akJzXU52XJ9-F2IB@localhost.localdomain>
 <fb000c9a-add2-4c31-afe1-b6ec416c9058@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3at7itnpamxnmliu"
Content-Disposition: inline
In-Reply-To: <fb000c9a-add2-4c31-afe1-b6ec416c9058@linux.dev>
X-Rspam-User: 
X-Stat-Signature: pk1yuzedw8zffct9y134bwfjunjhg9rs
X-Rspamd-Queue-Id: C5567140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782743380-47883
X-HE-Meta: U2FsdGVkX18SQiNuejLTUw/N11JT6+baZvZv+TQgjDTVF+imEhDKpvJgQJ8dh31xEcSXu3/5rHBUEbp9mc0tXjS5RxbdXqd7Hm+2CZY6lx37T3Uvrj1csFPwZsd/4PbwkJGz4Krxhm6FYGBVZFcvqo8Kd3cb6OyKJJTGJOS1r8876seDr2SCodKyETQYrru4I1kGctU+4vrnGmLB3+ptSZEEUfICKoy1Ot32i5xIyZFn9Y6e+T2mi0z5iHKfEiWX/cGR+o5U9wAxo4TLPRlDIs/HtJWyIOuyhg6YdsMwjRX9SYBNbfUlEZrEwYaoSQp2HWwQzxU7BK+3w4A4uOAO/5eWy1cIcRlpchc7AqcYWhlVexpAX4hGqKLEXN5IsfuW0UKomBHw9Kuf3iFenClPsYmtERxLUDzoG2uwtyPmWbpE13s7Lb89DuxM02WA/JhRuAVY6yUF2YuiCDIIfFBJO428IdOZrzLG8BcV23COL2oKbeHhaBubgPNxowxS98dDC+pEolTjCHd/bcbJVnAIzyNfHP+CYOwENactfQ+aelepjhQ+5JNznPXg633SqGogiYt8ZCDuYxFsdq3j/21qFb/3To6j9utcNkOZzFPKDxOwaaDm5TXO5ZjHpR+pehu9qqWpP0epvn1olvUjpqibN6dfs6SannL3U5K02tIAER/gpB636qJzNda/fqXYZQweibBox5lLQ5mw1w4Zkb+ZEF1U15h4iKv/cPrTWqRi0SEDsmWSTKG0gwwSoZJ8qf58DXDeABlWkc5FGUqKMz8/80OfsDz8+sCA2qlAbw2lpihHkA7+JIgGtI4a3Z5ZxA8+Z1PHur3zIUo2RjPo60iiLPHkbgya9orR8v7bvhInoUSgBZbd/hipg0HMzstj9yqXlmSZheUIwHVYGLY7X7a7Ysq43SoMq642slLPAzkNDfQtwnKRzs7U3HwBDISa18zLv6GMMecLGQrPdca45xR
 a+iNJHUG
 X2aS3hLo9M3xZMUy9IkjQzsl+90ZJPdqNNu94NV8AstO8MX2ORakymK1E7gO4jFYXGUYmYXf2OXF53ia10++J3GV0q4KlPvMzJQhjJ9Gf2Th8b1MYaXW/TXZ2Ni1KnjPrwbMrFU8OBYkO9hjrtThnblKJbfHGgGeRyig79WTTCd1Qz5nLfVLaZuNZjqwKK4x1peMHZI6o7r66PfXHKZVTRL9NptVBw4DeRajR5izM6ATKNlPlAVUKmoVM+BEzJT6pdXxwJegnaak8JqlQQBCl78RFXe/D2Hw8j5Zi1nU4/jKG/uMCbFYVY8RrR1/e5nsHqf4VU2P4OU2vFHUZT9Ulz8jjPhortMPQ9rIj7ar1j5lb8w9aupAjcexnCYLMGmIdt25Ru1MDl+ijO45LEH/LOuBa0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--3at7itnpamxnmliu
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/2] mm/vmpressure: split v1 userspace eventfd code
 into vmpressure-v1.c
MIME-Version: 1.0

On Mon, Jun 29, 2026 at 02:55:57PM +0100, Usama Arif <usama.arif@linux.dev>=
 wrote:
> On 29/06/2026 14:34, Michal Koutn=FD wrote:
> > On Mon, Jun 29, 2026 at 05:59:37AM -0700, Usama Arif <usama.arif@linux.=
dev> wrote:
> >> This split is the first step toward eventually making vmpressure
> >> CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
> >> (tree=3Dfalse) cannot be removed today immediately: PSI is not an
> >> exact replacement for vmpressure, and switching networking socket-buff=
er
> >> back-off to PSI
> >=20
> > (Here I understand PSI is a different and differntly scope metric) but
> > what does it mean when you write that tree=3Dfalse cannot be removed but
> > the other patch bails out from vmpressure() (i.e. nothing is updated
> > anyway)?
> So the first patch bails out for cgroup v2 for tree =3D true only.
> For tree =3D false, it doesn't bail out, and is still used for networking
> socket-buffer back-off. I think that is a whole another scope of work
> switching to PSI. Hope that makes sense?

I've mixed mutliple things together, sorry. I wanted to actually ask
about your response:

| I realized when trying to swap the order that the splitting off v1
| commit will end up doing more that what I think it should do (just
| splitting off v1 specific code), as the tree =3D true code will not get
| compiled in at all for cgroup v2, and it then ends up changing more
| behaviour.

tree=3Dtrue won't get compiled but v2 doesn't care about it, so the effect
of patch 2/2 should still be same (regardless whether it comes 1st or
2nd).
Do you refer to the invocation of vmpressure_v1_account_tree() that is
affected by this?

Thanks,
Michal

--3at7itnpamxnmliu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCakKBRBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjvmwEA4HemtO453cJ3O/cposVq
krP9NyHjDTo6qEo6eD7jB80BAJyadNi2Vw4GfahS0jf6sOLJoNRwifr+4X5GH+L1
JjcD
=aqwx
-----END PGP SIGNATURE-----

--3at7itnpamxnmliu--

