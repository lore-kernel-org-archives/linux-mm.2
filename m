Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2595C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C076B00A3; Tue,  7 Jul 2026 08:01:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815666B00A4; Tue,  7 Jul 2026 08:01:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704106B00A6; Tue,  7 Jul 2026 08:01:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3057A6B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:01:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1CB3168D56
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:01:39 +0000 (UTC)
X-FDA: 84961841118.25.3CD2734
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id C17774000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:01:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eheJY6Jw;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783425697;
	b=Rp83WZIXRpYGqzlf+E6q6Wx8nXV9044Xnz8u93OpUwf9TUHZNPR741xKze6FOeNuqXTySH
	A0ywmRzMItLP5AN397FrcPgHm7Fj1cYF6oFaSY5jJz25kJTwiJ3hu4BFpLubmBt9taeI/1
	9qMfL6N5KtyDsAVAb1xjDiOcQ99iNow=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eheJY6Jw;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783425697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2foD8/m5jsx3KDxdM1AXAhJaa/uPNeOmtxQBIkqM8nk=;
	b=r2L7IFM64pvicpki2Xthxjo3q2gfjdrSzCWN6dDEqwUqfDlmpTwKGCPrCn0cylNu9Ookm5
	6WmyxtOF0RiabGYXOLdwo5WPjjtn8pDRO6ddS4heRS0sQxEG4RGmJ410stYDTK1AN6Ep8u
	8obS4STZg80zap9YM+dn/VU4WNSd2KA=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493c55d5c7aso38986665e9.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 05:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783425696; x=1784030496; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2foD8/m5jsx3KDxdM1AXAhJaa/uPNeOmtxQBIkqM8nk=;
        b=eheJY6JwgLuZFkdvTA5Xbo3llW05EC9R4nKcVUnvqWOUD3K1MXXVX/bhZLV4PprSrD
         i2PiZ0UyiOUMEs+zyNga2vZZC27ONXlYjUw11jEkNgd+49EnWGJUuvX2FmCqne9uomdy
         Zl+gHAbDSWZo9sodH++Hit+Htm4s+qGARz7G10TUQcQrwrTkrFpCr6vtyBPFO+K56kfF
         nMj/pBOwV/b1PWV6SSSziQVKDNT3xhDwoeKN1HpztrVuICdzR+AEbXXHmIbi1BGlESiV
         NEqVV0ihWfl2ybRLK3J910Gwi7UAS/ncNhzGH3BB52wV1YzoNaQ0ABMYozMwm51Eyzru
         46jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783425696; x=1784030496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2foD8/m5jsx3KDxdM1AXAhJaa/uPNeOmtxQBIkqM8nk=;
        b=NDZwS1+qsktQUbLkRQcIEywHcXxBKbEY65MNwKRbzaVOTFSoD2lE3bAj4XxpIwDrMG
         bHf+fHHgcJgFG6iezy094kiVMdx84Ufc007Q6TDxDmlPhed3GlO5uEy+f+Y1kWAlIX84
         QVVwimk2CxYSftlBApeN4w4TX8ltclaRIZMy8BaLdx0RxBz0vl5sBfYemAe5RXyEYtu7
         mwIQ9YwNAdotqnDx/IZ97cxe++LbJGL2I2Jc7wBsNwjMyPsxaqko9E4+Tke9gDYPri7C
         Rx5IRivBkP5N9Xa6fS13Ww8HmdxMoy/rBpo9d9ct7W7Po6RR6dL7kfBE2zg0cDRdwlFg
         7L9Q==
X-Gm-Message-State: AOJu0YzQXsrMoSlQZEvqq6/vbgyVnfmGJ+CjYRG/H2LH5qoYqNvcklyN
	iHJwiUwy4VuW+7jMlkywqVuv8TK+kr+aX0joiwjgo2JpHvVkw58WR2mkd7Wn0ADS/As=
X-Gm-Gg: AfdE7cnQPqdQRYvf98yYhgKnHJviZ5+BSvDn3J9/azWTPy+NV6PrpsrmlSdtKJCzhoo
	QxqJM9rjH8SqF1b0lpmaYwOFjvBn+qiCNfzBo4XN+aau7JDjvQvu/BLhC26AoZiWd7g/7oMvQtx
	K9Y488cng5VDohSyPzbHjCCn9gCycXyEO/MQ258YL4kFsZEcavDz9mHcyRtMehl3oNbDnlCfIaS
	USpmHF8XYGGoFPVaibbJ7dm0QH755Zwkfhte/iPmo5QcYaEnBwsi2F0HOSUPicuTghI8AchbhHN
	o+J63tayDZl3/dzfll4irL/gQZJyiACSTZMwm+xb5BOFylybfZ1QdQKDStV5YHzAqST5q3mF1rV
	M5ksIzViolkqbTCSmyzk7Va4/nQBLfQQ4ri+It66ePV1v29U11xc6LhG1nGWnAxXMFQiNM25h5D
	VVY1EwaDh8UhIzJDGgIeS7O7U1K0Ad4P3f+KLU8g==
X-Received: by 2002:a05:600c:3b01:b0:493:b91c:6bf with SMTP id 5b1f17b1804b1-493df0a74c1mr48992425e9.18.1783425696112;
        Tue, 07 Jul 2026 05:01:36 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039ae44sm32347941f8f.23.2026.07.07.05.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 05:01:35 -0700 (PDT)
Date: Tue, 7 Jul 2026 14:01:33 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, 
	yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, tj@kernel.org, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Li Wang <li.wang@linux.dev>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
Message-ID: <akzpi93tZry0cCCe@localhost.localdomain>
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="n32fxil2i3lu57lp"
Content-Disposition: inline
In-Reply-To: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C17774000A
X-Stat-Signature: e99nozax96cxwbttit9eidd85beo3k7h
X-HE-Tag: 1783425697-81597
X-HE-Meta: U2FsdGVkX1/ud2PG6kxx2J5ibvEZC51u3UlUqdzV7I6+HDS/3q63gbEFnUZRVgAYMJGjyPOjZKBIWZVUoSTk9XhKjZORcYsuCqN+0/Yia5hi1y2o8wsjU2LGtInQeXrFruVIQyHG0PGMtwbAoPAuN6yx3kZyTdIkYDrVWBONNUWxQlIS1ybAUkIxvjhVTZq5/SksgL01cS1uOl120uODLMUdemkwX/EvddbJ3mnvxLOjv143HAw19oWlyqXEC6NOThKkv6oei3EU4d7ykeEDVvuD5bBuYVRLcBt5JBwKPPoov0UWUfKWfUXzTEHca1VgXA3TYyPvtsFoY41t4LIo7Pc3nMI7agjM/i5kaUarp2prv+Quk5FtFqY+JscD2l9LvBYV/utrcdZiFyHK5IyXfAcQKLmFB55x+by1X14d/+5qWZrY+bKT2j3spweY2JmUu9I3bUxPPxduL4NLtqtN3Pc6ACxIWE0LsKKf4830vLdl/M8RdNIzDQDxOf0aW56O1LUFq3bagHVb/Bgy7tttlUXNyX26HdYiCa4Rmsd1btJhOstoJoSu2EdKGs/D944bl6tc4aZMRaH1CWtMhmcsHDZ4v9Ya+YN/50FeG/yt1AXNxp0zD4TsIMOvEKQgor5awU/SqEnfzXo5vgcDqn1ffO8VPkdTWcB63uw0ycfG/wjHfyQM9c9Oi5i2byFcDms0s4NaiQttPXNHZ98lEA5DEDALuCsPDrJYC699VwGC/y+hAdDCpe7Bg84fKB4lke+r4veVRdTwjj2iq4WTq+U/pyz6/fX4iHHiyeonoJwcjYVLDX79WrwIqjmhWDr+GPsIrjwJljBzHlrT1gWoR2Q0mGYueAci3RdRoNyZjQy6gxbG1BPIa3jlUldbBSRqUY2G+0aJ1uatkGrfoez1HOE/+4aywZVY+7hgWEd26cN1vb4ebbDDklS5MB5AVwp2ePAgZGuIGCkU4huRvMztd8I
 t7KXPJVd
 47AuPlTXdlukJU2I1RTOm1zSDG2AgYWpMxEKjGACrWBEYhzAmHqPKN7cZuj2w3XpcWD+qzoppdmchxGHHKyL2K0foAq1U20VbCPKRHRUQPI5Sn0dUCxtajdGhfgSPgicUc3U1NBdO3/2NP2h9bwjfIjRLNz1ZkHdcqdDlix0i/Wq8tZUCwRoZSyyCzvQaFzkgwPTWsZjvtKX7kdZtHsduJcvJV5syV5dOmmUs/kkllbGYKh3XoJqafKQxEszYOF5Qk+Xf6fHatZ05qwd0Ym2b3TrOd7ZSCiDjWHZd2DcgokfHcELx9QQHWqf9YR55d6ud8WEC7eVfSrFIHn5DD6o5WQhUXkT6VHwmmiq7lgA0t19SBImuZp6o37AO8Rbh7J0gx8sotF3fj+llZxe6Y6dHQbu3v/RnE1qsfJViiysv+8C69nWLidUeAoXyf2V1p8lD7VORpPhMNbGcvwohxcipuve79A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--n32fxil2i3lu57lp
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
MIME-Version: 1.0

Hello Zenghui.

On Tue, Jul 07, 2026 at 05:38:13PM +0800, Zenghui Yu <zenghui.yu@linux.dev>=
 wrote:
> Hi,
>=20
> Running cgroup/test_zswap on my arm64 box failed immediately with:
>=20
>   [root@localhost cgroup]# ./test_zswap=20
>   TAP version 13
>   1..8
>   # zswpout does not increase after test program
>   not ok 1 test_zswap_usage
>   [...]

What version of the tests do you run?
Namely, does it have the recent patches from Li [1]?

Thanks,
Michal

[1] 83476cc97bc63 ("Merge tag 'cgroup-for-7.2' of git://git.kernel.org/pub/=
scm/linux/kernel/git/tj/cgroup") v7.2-rc1~136

--n32fxil2i3lu57lp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCakzqcRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjPxQD/TSp3AgFunXblm/wv+t06
iUtOKzzPQFXPcFo4roUGy6UBAPI9Y58AN6NvZtotdqoeb85Dry7/rdwq9AfzhNfP
8pEH
=dE8U
-----END PGP SIGNATURE-----

--n32fxil2i3lu57lp--

