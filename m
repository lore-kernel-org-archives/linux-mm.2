Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B14C9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0F26B0088; Mon, 12 Jan 2026 10:06:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABC06B008A; Mon, 12 Jan 2026 10:06:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2456B0092; Mon, 12 Jan 2026 10:06:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9ECF6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:06:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FA3D1A041F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:06:47 +0000 (UTC)
X-FDA: 84323638854.09.71B9E7C
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id E739B1C0004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:06:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=NedIBfr5;
	spf=pass (imf20.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230405; a=rsa-sha256;
	cv=none;
	b=nG8IqkmmcMWjXdN97N4/VPRNlCMrnPwMpiT8mVS2xAyHStCm/hbJNYJoQvVSMUie5Iz/iJ
	rX2DA0JF1Wbj6DsSRbGOFIbyy71fkRmgvhE14gRmS45xtFKRGXBgj7AZBddqOH1tp6m0nd
	cUzeFBWzStYXqOJ0ef56njs2SUfhNK0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=NedIBfr5;
	spf=pass (imf20.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaxxTxdQgjkNPEauwlTyuzVixI2qIhO1JHV0bjc5j1Y=;
	b=i2gpgEtjjKD4EfBqM511nYYb4vTaANOzfVLEEK+sxUbKBoNCd82OL8HKtI02vdHk1QGBPR
	/KvJlxm/3J0HTitDgjy7CEfTH5VZzIOa04rwXfl8vW7o0dCulDQfwx8sX/2OaizGD98pEL
	DLOPNr+pnDZm/PI8MycSIAjC1Y/jztc=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4357840E01BB;
	Mon, 12 Jan 2026 15:06:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id yTa45AN18amQ; Mon, 12 Jan 2026 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768230395; bh=YaxxTxdQgjkNPEauwlTyuzVixI2qIhO1JHV0bjc5j1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NedIBfr5xF/e/gTC09SP7G4e+R/fuASPskksbdhVSkWH9heL3VoDABQGgFyLfp19F
	 wuCmqy2pL8yzxhKATai16K/86vJ1+LwmWz7FDyDZ3bW9B/w27BMmNvmbMj0D6Vm7cD
	 ppKQLwTAX5aNROUqSxce9hwQPvlxbd8u+Z+IxkPOU4G3Xxg0pByMBR0j8eInXYl+aA
	 pkNs97VwDtV65e+V1dgXpP96oxGgy5fZXDr+MemLkg0vRaPPXKGmUu2JpR1DENCxsc
	 dSSoEenJuTqHVhJ608iZYsNqy24PxP2lpX1J55Z4AJOiN7SlLssPxYPVci36W8DscK
	 9dEgevp8r8cXA51vgWNs/x2gETRmiL0SSNZUXt9LtLpvt382doyWGD+dcR3QL8Tgtk
	 YVBBROcEyBWE+FkJH7rvz24B2MoQF6FcenuUClpwWLrAZ4GZnb94yUn5GGRMfH5CMr
	 MYOr7DKnsQbsHBEEhn1YbH1a/Q/TNVbYWzC9KLcAbYGoCsfUbCuJjIvwbJkKMos5Ct
	 xVighy+lOCy13YSoRERVOUBegzr7VXEQ3GEBcB3UKfjaz+dl7Qvr9Yaj/WkpO/xm8w
	 8w5D0qdBsGwlRGesnnamyrp3RFV8pWcA/KM0coj4yKaGxMlXgkxmuKT/og/AKVUhaC
	 bLERDi05T9nRIuVUc7zx7LEQ=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 16ED240E00DE;
	Mon, 12 Jan 2026 15:05:59 +0000 (UTC)
Date: Mon, 12 Jan 2026 16:05:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: shiju.jose@huawei.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jonathan.cameron@huawei.com, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v14 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <20260112150552.GGaWUN0Ex8KgfqEEi5@fat_crate.local>
References: <20251209145742.297-1-shiju.jose@huawei.com>
 <20251209145742.297-2-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251209145742.297-2-shiju.jose@huawei.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E739B1C0004
X-Stat-Signature: fka97pim8decjpq1e8bmwj3mjg6skne9
X-Rspam-User: 
X-HE-Tag: 1768230404-248692
X-HE-Meta: U2FsdGVkX1+nAXyv5YdX3USC96ZWYatX49coyMp/wTV1PTaZ6iHTmNw2Ggu4pY0lrwunVSt77TdKazFNQy+Lnv0Z411t0JEdajRND7FvOfbNNIbnoMdVn5SirJn2Fa64fe9ftdolFGNKo2te9yfixK3/IVdBuOm1vDJPSI2oX7lTuK953CEtj+FBUR2c/WxK0TfMyVW0yfi6NOQEHM2EI+sFdgwDYk7Wt2g9slEvJkvJyKjJXsL2oZS9HCUHg4TLG7KVwYembUC8q8XuHqErdKLBJ4p/nBPYRrqHudYZh62wDLt0uiUkpKm5AbdFe0a7FFaSOCbR7F6zdvwBwuNAVh7etAhBQVDyCirTmj42IBX9XEI2UcWFA/9Ten9LqkKHpNSe57NSpgRGWIPb5z+1rqm3qx7ZFBva19zvv2rnhzTZRRSxc0P3tvzZIos6rM8HFQdXFCcvTfVqGxyBDm7Q3YALQXJPegMS6F3j4O0V0kodiCJ9/pxLMiNOB0OmfQFNJvXCoTPDhithd/oq/C+CtP0rxWXHGNOnAZaOMiV7UA7mRa1gcYKPjmwNgk2MzaYlBvY7RHyCXnbPChMrP/ZCQEZUI/Un/sW3+Brx6pdyaNrES5WLojI5cJ9qaf88RGWLTqRbEVkBqkSqKmFnVStXHtWpDbm7bz4Bi5//f7iL6BQORUfRFP+tte6yqyreAUUXLmWSXx5cYVfFhfeaAEmagPhaZWuyK+zFY51bgV9PDJ1xcyJvnHYCihjxAuzhLOZzyKFwAtb+dnRQhTi/Qqu+RMPL9O2BKfycW8rP906nQazSvxhMmiq8qbRfYkUC978JwiayBACo9315P6/j/S9AObbcbsN1XVZpLcI26pdhf6wrLh12mNS+pzzq5H5X3bbzGnm5DmPCDKoQQXYd1JquJ8kauMnFmL/SDxePYMQ21ExaTg/utNZMEPz25GyUibFR/s8ii+sezPCMC3r12/i
 gvY8XTaf
 cNtoXT8uHrmWMF6jYo7SdwcpqFgrRM4zx1hroX+f+4cRh7I42xJo9VeclzsViehSt7TiKmZtF98rK6hSpFR02FV3Xlx5ai2mTCFo5KN6+uE+MBgza5wDSxlSdixmixWXs/H5BWa1lRrvuDxjMoujJQJThUc7cj+zvo6XkObIVc0EaeRxE/7w7a7seIJ5kNBMRjqfNZ6ZGKs6BeeNTdapl2TYCKiYArR457f/yv83DWV5Zc7IiSjSR6OKhqBLSXcXJDMZu0k7mMuSxcdiOIb9MEtZ2ECUn2GaSNLB2o/RW6fkh97U9UX53A/hPIFkHjxn4uRLQV0xhvc/s2B9kdFAkRIczCKBdIStZsqoHmAwLJcUuyf0Av0MeWhAnOgFOn2HWmitHzO91pgH4S4ZHaVCsAjhpOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 09, 2025 at 02:57:40PM +0000, shiju.jose@huawei.com wrote:
> From: Shiju Jose <shiju.jose@huawei.com>
> 
> ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS2).
> Driver adds support for RAS2 feature table, which provides interfaces for
> platform RAS features, e.g., for HW-based memory scrubbing, and logical to
> PA translation service. RAS2 uses PCC channel subspace for communicating
> with the ACPI compliant HW platform.
> 
> Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
> Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
> Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
> Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
> ---
>  drivers/acpi/Kconfig  |  10 ++
>  drivers/acpi/Makefile |   1 +
>  drivers/acpi/bus.c    |   3 +
>  drivers/acpi/ras2.c   | 409 ++++++++++++++++++++++++++++++++++++++++++
>  include/acpi/ras2.h   |  57 ++++++
>  5 files changed, 480 insertions(+)
>  create mode 100644 drivers/acpi/ras2.c
>  create mode 100644 include/acpi/ras2.h

Please go over all my review comments from here:

https://lore.kernel.org/r/20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local

and either incorporate them or say why you don't agree.

Ignoring them is NOT something you should do because this goes both ways.

Ignoring this submission now.

Thx.

-- 
Regards/Gruss,
    Boris.


https://people.kernel.org/tglx/notes-about-netiquette

