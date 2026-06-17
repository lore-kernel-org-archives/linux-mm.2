Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D81F0CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9AE66B00A0; Wed, 17 Jun 2026 08:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D739A6B00A2; Wed, 17 Jun 2026 08:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C892D6B00A3; Wed, 17 Jun 2026 08:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3C0A6B00A0
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:28:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38288166189
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:28:35 +0000 (UTC)
X-FDA: 84889332990.26.D3F76F3
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5562E1C0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:28:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gs0I1GHH;
	spf=pass (imf21.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MM5qR7HnQsV8ihoP5sIjvhIawDKg/qrSVM0NHkgkEXQ=;
	b=tmxITuArCLrRVwNy0e0Ipc7tHIuPF3aUu6Khz3NqUWwxOcrVjpKW67xscmJixEljk1oWtv
	YL+TDmsIc4ZLllNaOeXG85HUjsN5sy7Bo2jzC//D9aYyDioEygMNzSP2nlFh8PZ8o834Ey
	T6f2ug5XCwrqLxx/ue1vsbCP6+kXGgU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699313;
	b=Pew3yCnVMrJMGdaiHnyHdTKkO+b80XFZNieUasbsIwF22z1J7WlFIikeFx1syURf3H3Org
	ACwWNqol0lUoT8gbiNlN5Q/9fA/EG/gAkln894yFIkdRxmbTnpde/KERPDSzg1OBEpLKd8
	MTwGGdQHvntpAwCEUu5Gt2/wo5u7gDQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gs0I1GHH;
	spf=pass (imf21.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so57508795e9.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699312; x=1782304112; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MM5qR7HnQsV8ihoP5sIjvhIawDKg/qrSVM0NHkgkEXQ=;
        b=gs0I1GHHaeL64lCpl/JPRKeFiIYJnOFufxAbCul2avD5yxpL/rSVkFsnuNE7mDiMc1
         JAqSVDO/MHB8YmuEy5n5YoLhsX/l8/frEIVlVXaLY39uty+PENCtSap0aMY+XXQQwzMQ
         a4BFL25xGTc2lZ8uyBmy7MFS3bvDp37xIccuHVBPPNXOWSkJqouYDPzybdj2ICtYD9w8
         U1EbQYC+Fi5bfIIzryDQZ9T8d5Oi2a7sjLEaXi0ZgoN5M8RaDTYXwz5bL82tqWnP3Njn
         BXABOJ4uscRr8USwIT1DwIDMS0812YW+eKQJIPzg/vjZLPA7tjBn+EhKzZthkcjLW/20
         MY7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699312; x=1782304112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MM5qR7HnQsV8ihoP5sIjvhIawDKg/qrSVM0NHkgkEXQ=;
        b=pfZe0C40nzyFPbgDXBiaNZvCkAdLcEwaYLSrEpCo2HwXghIoDjkDAqd5PoENiBStm3
         WMZyZanqR2esJxPkCuSDnWKfqsUqgNWDicolf71i0pKxTJnptI1EWPRjjzt+de3/RsPD
         BjxN5a0ADY76Ztak+VWjLCERiHxzVrXQalm2oOToMVQpRF8oV7nPEpYsXZ/DuXr/Jjar
         v+afG/pb/QFCTIWjxKyDLGnWi3Jp75I2hkMuhu+mfxkXZLtwZ4euH5rwV+r3l+ltvfk/
         q9F/LUXwug59PEYDO5b/XtRAVoQ7wxQaC5sd2bw5YHNDBB4H0Z9MO3p+miSG5kX/JLHb
         KY6Q==
X-Forwarded-Encrypted: i=1; AFNElJ/RWcmHa2wuUwetH47Ric9HNvQJAcohcG5Z/5t/hrMS3OXcrJgn9geZ0B+97f2l3no40iQt1pmj3g==@kvack.org
X-Gm-Message-State: AOJu0Yz7LsSQNIE0q8NGmmX3azCdOTZUgvoeE+q+oyFhQMgLek9kghCM
	5zde4WDwYwz9BbgFIt5MgP1O6BwS7R1FeR0ZwuSFQXM6cEDPwHkAL10eYaRvAv79Fuk=
X-Gm-Gg: Acq92OE52JAzF/H/UKzHMQv+5l9atVPNMdpkAWotNmgdPy8ugqOE+6sTqyP/3nZvLBm
	qhUtjgPsWXxnrEKVRUDurrCeCUYZOwKh7HpXR6IlBPJeTQUBV3oMhiIh3OnU2eCd5q/xyQXyo1k
	4k27x1ELei+WZEMm09Zglz2gs20aYXQzLAeKwHhDXKSc40mTk5onRWTzz73SjCiVK8v08OevQ5w
	Em7+lz8nrtCKMcUH0NAeJ0jlKuK2yQ5UG3r+YVrZwUUAuGW4UOa+hmtIo2T0sLXv4AYGInuROjm
	eyPkZXf13oSLR+qDd5EsAgzwr9NSB8bZZnORllqCLyjq7n/mrMKniYttlkN/vsnb1lBgvwyHtEx
	IwTDF+/hzHSLiZMEH11IYEd5N8XYQ02LA6rNtKEH+Z3OB36pJUYQpWpq/dTNWVx0pPzpSit0lsS
	PoSz9HYRngJC7zVATDIA==
X-Received: by 2002:a05:600c:4644:b0:490:9d1b:f06a with SMTP id 5b1f17b1804b1-4923410388dmr30618225e9.10.1781699311826;
        Wed, 17 Jun 2026 05:28:31 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa891acsm160948085e9.9.2026.06.17.05.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:28:31 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:28:29 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>, tj@kernel.org
Cc: akpm@linux-foundation.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <ajKSrZ5xBAj8lquy@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4yjtviewjv7h5rrp"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
X-Rspamd-Queue-Id: 5562E1C0005
X-Rspam-User: 
X-Stat-Signature: zo8mmqu443q1yr6qz8sm3asgofq7fwsn
X-Rspamd-Server: rspam08
X-HE-Tag: 1781699313-972036
X-HE-Meta: U2FsdGVkX18/GuVZi4RUxHJI9fImQUBVBb8IiP2q4Hqag0FujTAwAPSDotGcayt0JdgYeGl+ulIwkMbX8BiwigkeRNJt6nroMo8L1tPnZtZwy+nJEnlqsasxSbxnD6/uk3KlhTRrVCPhgNLM0vyFoFpNnVN8lfHRLmn1JJH47CkNd9eq+Gb/yeEvJSiE73Gnw/EkTH7gzZq/eCEbN7hQY9P5TSRGNjeX+RrKhSy7Km5wHSact1mlitCBQUU9JAJQ0YTBgrcGl7vbYeeKGFmaQlN3gUo2deGwvZ39cMJ32Qkr9gX4yW3o4uUEyKopWb+Efd7gdYcfKBWDAKYxXF/0AHGMwUxiLFoRR2hnHCXI4szNmatQQyaKg8IZJSasXijhc4mT/+7mCHE5TgG1jqS7QZD1LjWN2C91BBJDwaX/soufEuNcpHYHvLZd5IF62ahrUYRUwpny67jjmsIXhaRe+ztPoVdykoTMfDSlS5EjSbMBNHDCmpefTHVSdFOP9bUCYGvTrjUIqcgeCIK43Kh2znfruZMvfGP0bNYNV4iSb+OPsbwgPZYqzJTdGRZodlLtKtDQ1xkFbY891mA9gQsuGeJ/I1Km+dphRsur+LCx/VFDQOCwuGi167SGUoGHKynebSHsRTL8gvo8xMM2IoLpE9yrJGaV8hGdDgy9uPVntnrSKpXKqCbbYSNfaxAlAYBJZZbWnCTs5LUmp5GChDvWL+7MfwBgM/tj2Tqrz8ioLQP82DzswVtJplQENvCRj8BJs7ZGmEBNncb5C7yYZxIwUMmkXPCJvIvc9fx6Hh34T68JNNDmJ5WossM5OIyTOfL4/+woUbr1Fn3+3skTtaOV99GhvbjhwTvZ79d8ds7iU+tnbxXUEV7pFuhcgzlDxN/IERWD1xaz3bmN2dQmT5L7HG3VqwaxUAocy/mGMccgmzni0QLaQ8jyx/KxKFsJ4VZjdcG2TaQ88lwdvMHfYnK
 j48Qf1OL
 UqTtZ9ALbkPnF/nU7BOCVfky0KF/iLJfQKmS55UedCLjonNTBBX46HT9NxFzRbsSSm0BFRJzYUrpWp60NYonlgBDmUOYgk5FMHsDmgIH9OQwlF9zcpLffZ97nI86mjr2FmR+rYXttIAOZpVXVwVbV3FMKlAC5adXKKY6ro+qYzEBENkNBOWaot+SYfbmaWYJpspu9vwd2M/mLLb9RIiOAQyxD/D7digHdaQPeCubX0NvBt+gJl5/aKsrRsRzCiyBk4xko109itjtdQ0+re5JmgUlC0AoPlYQ0e6MfISm4jcBLX6dYJfsV6ZdDV0qp6GbwGTQSEwifmucGGejWYPycgvkPJuzTU5PjSOOhRiGeC8Utg4vIsJinwG3qvmQwZrOEX4MJwZwAz7o4PHGsfypVvzJuik/e4ErSwD7o5GE+kBDqSHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--4yjtviewjv7h5rrp
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
MIME-Version: 1.0

On Fri, Apr 24, 2026 at 12:00:51PM +0800, Li Wang <li.wang@linux.dev> wrote:
> This patchset aims to fix various spurious failures and improve the overa=
ll
> robustness of the cgroup zswap selftests.
>=20
> The primary motivation is to make the tests compatible with architectures
> that use non-4K page sizes (such as 64K on ppc64le and arm64). Currently,
> the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
> On 64K page size systems, these hardcoded values lead to sub-page granula=
rity
> accesses, incorrect page count calculations, and insufficient memory pres=
sure
> to trigger zswap writeback, ultimately causing the tests to fail.
>=20
> Additionally, this series addresses OOM kills occurring in test_swapin_no=
zswap
> by dynamically scaling memory limits, and prevents spurious test failures
> when zswap is built into the kernel but globally disabled.
>=20
> Changes in v7:
>   Replace my work email by li.wang@linux.dev address.
>   Add Acked-by: Nhat Pham <nphamcs@gmail.com> to series.
>   Rebase to the latest branch (only one tiny conflict resolved).

I think the patches from the series where I had no special remarks can
be applied already (and base next (smaller) series on that).

Michal

--4yjtviewjv7h5rrp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKS6RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiRWwD7B006DcY0x2F+2Sbw4j8K
IZEESihg3ZPEkA+MdYeum5cA/24UUIQFp9j85Oa50uzT0iUVL6FumNyKNhH7lGIv
0IkF
=0L1g
-----END PGP SIGNATURE-----

--4yjtviewjv7h5rrp--

