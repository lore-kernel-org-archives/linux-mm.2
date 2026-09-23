Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A0DC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2DC76B0088; Wed, 23 Sep 2026 08:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04976B008A; Wed, 23 Sep 2026 08:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6646B008C; Wed, 23 Sep 2026 08:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA0A96B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:40:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AC4814078B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:40:25 +0000 (UTC)
X-FDA: 85244985210.27.C55CF38
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf08.hostedemail.com (Postfix) with ESMTP id ECE7C160006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:40:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="AQ/ALIeq";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mkoutny@suse.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790167223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdBLUyvMtWr6klMUk5a/hwwvszeiGBeUfZaFfQvLAEA=;
	b=UPcEo9IrTZCLPR/MMUH0wpGJGvJcxslHzee1DJNSTqwUEDKPZ3cv5m0yhFSla22lIDldm8
	qBodsa0I1lEx8Ymq+xtSaof1RHaiGAqJlFs2rLV5KIQCVmmChzgkyqFiN58P/wcbkKkO9z
	XA8/KhFHsURyaxckXTcLrXn8zpkyCkE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="AQ/ALIeq";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mkoutny@suse.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790167223;
	b=lZZPWNLoyxtI9IN8ut/1NhLhdPSrSbkYuw96+g4dUkFkYkDbOUtT6YjX+XAQ4sKgXTVUjo
	1TvO47CqwNVYyNXCc8NfQd7kn5imkcmWmXzDU7Wxh7rdmwcLyjUMj/WpTVcJ6ouTAjaG5G
	qmfVRDMLS35dOCq8s1mkZjsKCsTjWj4=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b6so4763415e9.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790167221; x=1790772021; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TdBLUyvMtWr6klMUk5a/hwwvszeiGBeUfZaFfQvLAEA=;
        b=AQ/ALIeq0RCJi2Kr3AgYs3ma+7hVcyVwh6VbS9X8aEW2nXbM0agtQxLbURiQV4yumU
         WmWoetFJtPZ274aiqk8V3b1moFwB+xvcHq5PVAxByCFodqqvNkp8gTo4c7MpIt2WUjCc
         6S7dWBZEyF50uDvUgxSVszF6+p2m6d102bF8QTAWslIrk8gAdxR4rz4ZYW/e3mptP4Fm
         tJ2LwrOuxDXRJDFDIpAvzTUJbob+eKwyHpn4XoSJJLxs1RUEZD580z9fLW6GgTk7xUoq
         hvtoJgdM0s2uuY7xz94xtxx7Vk1uQ+DtxeyWmC0AHRkkF7qOuC+JVsNS0uVLdEd/bTME
         5/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790167221; x=1790772021;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TdBLUyvMtWr6klMUk5a/hwwvszeiGBeUfZaFfQvLAEA=;
        b=ayjIX4vxrYr2/vB7Hiao3xDoruvqIh4L2BPocLPU2YOhxiTjdzsAIdV0eGoEqVlM2X
         MAH3peQ9WOpQi5+x4/kdCrO3ucAieXSsts6vnxhq5hUI1inxoN0RSkg2A0F1Rhn3YoRN
         GX8ffzxFLIgpNs9SExojAxPfsEJBpHJnrJyCeapDn/HqqpnjWw1dBBNpTCrlX7rkTmEd
         wd6snNoRfYNReA+T1Fmq6Gg+43vvYx73KQnwSY26UJ+Bsix+rM96BCXwCwJ3pecoEP5U
         0CPjO460ZRW+jYRJ0KTRWb8fDauvRMpV0XBnaMOBiUURB8gqqQdw7mcz3RzqakH0BrbU
         +LJg==
X-Forwarded-Encrypted: i=1; AKwUvByakuXpcaPRgkUyPTemBo3orOiwwkmoUVV8mVcwjgP/M4G4BMuXmsyznjvbsO4D2qfUDXP9v4gQkQ==@kvack.org
X-Gm-Message-State: AFuF++lJFICLrAckGqRRQ7mU3Wm9n/bi/R12XBBRoRj6oLlgD5yxS2dn
	ek74QlhAjdFrXiAL9EnSIk/AgkwdF6eRS1qOYBYTJmOaisseiPkD+P0+uT83C1FQ7Zk=
X-Gm-Gg: AYBFou3iRoS3vNRYz7/Zg+y2Ct/yMYKeGkcVJJBFpR6Cf6A4kCZOrXBCbz3TE4EKL77
	aW07xCeEp2xFR3SCJgYD0hubSohefkG2tDeyWDBexygFfJtnfru6Fzqv++f7/SpP9BTOGhIt5IZ
	X64suGCmQSQ8pxX/WZXn3CV6ID298u9PqnwYEKbiKASl92/Dedp5PUKw5zjOs02DylCYLP3OPwh
	b+hk3oiQSC2x5Lg6x7/2fBwqaipp2DeWXeOVgOIEJ1DZaDfGEcgvXIVZcjwhRUGfIdBDljXIGNl
	FpEG6NQ5Kgxyh756LNqYhK6WH2wP8DXHywqyQ6yikluuEcFKopY8WXtNWHj7ecswYVwiwWD3YhP
	YCmi6sOm+6HCchCbiYUV9f18xfjWyBhNR2DvkDJ6R0MmOiWuPKBG3K2eHw1nJNJe36KDX/JPaGf
	Bx+5zbXzCF13JTuxqi8Zu+Ee8ILduBJwpm3iy1ZrQC1jYLzWa3E36oFiJgBhxY0FjnFFcioVEuX
	g==
X-Received: by 2002:a05:600d:8643:20b0:49f:bc0d:2e9 with SMTP id 5b1f17b1804b1-49fdfd90205mr23203125e9.0.1790167221389;
        Wed, 23 Sep 2026 05:40:21 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886876c119sm7240332f8f.15.2026.09.23.05.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:40:20 -0700 (PDT)
Date: Wed, 23 Sep 2026 14:40:18 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qinyun Tan <qinyuntan@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Usama Arif <usama.arif@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Xunlei Pang <xlpang@linux.alibaba.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-ID: <arPGEda3po0-Mbh6@localhost.localdomain>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
 <20260922183547.788d21b89868bf820e94cc62@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jduqwrsbz2lze7tg"
Content-Disposition: inline
In-Reply-To: <20260922183547.788d21b89868bf820e94cc62@linux-foundation.org>
X-Rspamd-Queue-Id: ECE7C160006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4zai94a9qnwcfn3eesstd5n5zdhy9gqx
X-HE-Tag: 1790167222-417286
X-HE-Meta: U2FsdGVkX1+hFwkC2Ra6aOKKIh88pV63Z+5GeNQCQ6DuLnCuYw1dhFQzpvWjgUuZmuuf3rCnPhF2oTHtlSub9IuFotwXS/0BRmKvPbUXKyMXv9iGUKC3uc1k96xoYiJfy7CL1NF3kHAeglS8ch3tNJab5p31D/9F0dVA8W8U0QNznfST/TdHz8Ki3u6xFrUsmxnwapeco3iGaEjpIklNNqUddBdsoilhqDMwtgwH9YoR0XFVIZArLNTR668afJFYyNGToMGoMs+VoUYGAoank15Gu/2gfIU/3RJoomOQSim2+E2NCvgIWLYx/RG3N5VjsAwXSQLv7Vhyjrhxqje5rsRFftpO9RdDK5ca7phGsZnAJXwl7mYRMkJafNiXEjgUT6bGqTmgdEBm2Vw8a9bxIHFrTyhKXORqbtfZ3jCUYSalQjejtcYLoRcBTnuU9E1jHZdoW22ik4NTSbHjyaQGycu7/5oZv89B1YLgy7T01ykV+ou3nMiMMK4PVhGr0XD5flEu86BNLWpOqHH0mpodfn6fY//rvLA/Ngtq1Oc2SOGSwucemnMd1KrxajDLGCxsMvM9W3Lsa+CCyUIay4kRH+v7NyzwJHCMvJ3DKcvc0wsZYqkj0g3MgRaYF148aMEc87k1460t/E5PAgzc7vwmAB5JpOWqc1mZrg6Hq+Hd0wgcO62Pcfq2GC9GI5Xdav8RyeBtz06/mMSjGa8WckMw7bza1D/b9x/0Whk0WnOnvFnDlWscMwgcEclprNkzjKPCul85q7mwqiD7Qc1JzuA+D1s/e6CA7YUUdJVkKXZk73GrsB1JmrOP3aA1aUqvtJKAHPzRMWlZlOzyZsDonzymR+DpWqDKzQXbDynxG/pZIM1p54tQNNP7IysnwKzb+dfdkDbRbsXQTEOJpjQMcvLC+pJzVG5u0d8JtYtlWjci7Je+WuTPHHXPvjjBW47ILgkT9s764sNPw3kmQINoPml
 ahnnX4QF
 7paBuISSt/8lX1Ks43q6eVhu8rp9vQkQmdTMJqm1sq8aEfAHoqwzOjl0PNBMN6DXyfNAykIl5+iStXot3nSKm2yzL5B1wXdxk9fyg8zZHdj4ysYuwbHSOiEQDvHudV2RlVHSlOLl77Qapm2Bo4HFAC+ryRMSC7z2WkarnTfO6pg7T7zAJR6tZMALmnqBRC2zyRc0hIy2srkIZAI+5+RgNsSI6t+1qOm9wp7vEp38l9wEvuqjgTMpPSthqKD4IfPWh23BCdqjS2t8WU+jZ/+EsYxUhqiKK7fHEc1PqJUvbs80LruiGwtS1qKOWO+UEpB3aOZR2VSsRQfRGpPBDiuIGgyrnyr376sPkdUTl9RUP/w2JXgDuD37BOIsJrVfbuD01+8gJJeMCgi1TFTNrTMVjyx7vYFwDMnsdhnomNbtL6qC0fKWpY8RtAgzF1Dg/SeY+D/OXb3EYcW8OkjZJe9zntJ4CFhB1ZbUUIxiMnXnHIzRk9nUoIo0uZ6u0TC9ZYEy9+3+wzHCrGnjXHQ3TfcymIE6nt4YurMoV+N9y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--jduqwrsbz2lze7tg
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
MIME-Version: 1.0

On Tue, Sep 22, 2026 at 06:35:47PM -0700, Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> On Thu, 10 Sep 2026 16:07:18 +0800 Qinyun Tan <qinyuntan@linux.alibaba.co=
m> wrote:
>=20
> > With cgroup.memory=3Dnokmem, the THP deferred split shrinker and the
> > zswap shrinker are degraded in two ways.
>=20
> Obvious question which may have recently been addressed:
>=20
> Why are we keeping nokmem around?  How useful are its memory savings
> and is anyone actually using it?

Besides (not so significant) memory savings, there are also runtime
savings (not spending time with accounting of each kernel allocation)
and environmnents where shared (not)accounting of kernel objects is
preferred (as other resources than memory are shared anyways).

The above are IMO justifiable reasons and I know such users.

HTH,
Michal

--jduqwrsbz2lze7tg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCarPImhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhuYwEAq+e3Y6FWb+6/NZTcNcD/
OwbFXuc9bSQF8eyv2blq63IA/3OX78kjmj6FDtiaJ3JiP6ozQ4i+Uppjk/m6YUto
JN8K
=dA2e
-----END PGP SIGNATURE-----

--jduqwrsbz2lze7tg--

