Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A11E5CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 16:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CB86B00A5; Sun, 23 Nov 2025 11:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED396B00A6; Sun, 23 Nov 2025 11:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D030F6B00A7; Sun, 23 Nov 2025 11:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BFA156B00A5
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:07:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72A061359C3
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 16:07:48 +0000 (UTC)
X-FDA: 84142352616.10.5A924BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E528120015
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 16:07:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i2mg2s8U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763914066; a=rsa-sha256;
	cv=none;
	b=4oqRx6cf3rN8cgDlzCShKmJ5d5VZsLii8kEVubXudR+U/t9kdc0OEAzya4UJZaqTotjDbi
	R7hxM8sGpNSOz2s9pzLOC5rHhv21KtAhmUdgwkibVzlV4qN/8I9fB419D1hVvqyx0W1pbh
	Zg3S5sK+AzC0z8ko/fvaEXfgfdB1rxk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i2mg2s8U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763914066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eedIbeeju7hMLyBMCUKmWNC+lph/WdiEN+9Xg5vrBqY=;
	b=LgTjy725qy9DfmhLi9yiNpPueCpu45Wl+imGrglBI38EtopPKXCD43WcG1PEeBTFD567+W
	kk/AiNgRyK3COIKtTXlNtKDt/2KkkodiMFR+N5zXOnfpLh1DWC2OHtmILGV/TZ9nuAMXfz
	2tSHb/B4X6Tm0ScSK8zgLl/7U8u1PLc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0F1560125;
	Sun, 23 Nov 2025 16:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0A4C113D0;
	Sun, 23 Nov 2025 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763914065;
	bh=7gBCeai/PYLWlQyJ7zmnTaLwRvHr9b0Er9v8ly4gDBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i2mg2s8U6qfDREC8jiXuiUV+BZWRjfeaUtQywQBP3iD96fEacOZ+FJboHt9MAkrvR
	 djGJ84TvCoRsIAuf6EVYZmNGLurfJ7ecHvZl86uB4kQgXEgdVQyOP89B4TpCJVej8l
	 HBGje5ja6ujFE7hwA7S6dGQdct+B5PSVdfJ8QkY6m7zsv0w9l+SpMgNtchkAZFhRFz
	 UoPg1Gpovm3ehI3zg+eLlyDCqspqUjfSStZe6lK62R+oHfJyDelX/Rye0Ze656xxtz
	 7U4L3G3sC0TPxgM+aaPvMbCO2WFtRzEIX2uvE/Oh7G/GFXvX73gbS4zBFIRx4QyOgS
	 008nHEbqU116w==
Date: Sun, 23 Nov 2025 18:07:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 15/22] docs: add documentation for memfd preservation
 via LUO
Message-ID: <aSMxOTnxKuQ4bce9@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-16-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-16-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: E528120015
X-Rspamd-Server: rspam07
X-Stat-Signature: qb6gha473nsib6354rp57cwtt1k33o6s
X-Rspam-User: 
X-HE-Tag: 1763914066-383496
X-HE-Meta: U2FsdGVkX1/+7J0gpetHorbT5nv803Gb2cMojGhubv3H0GNoK3siryZN/UeiOqVSYA3IDkyI2tk9BdBykK8aeA0gtxerVxb2QYKDBxnJVFp+mXISkFcadqDJq/T9CnVFBI9YdA7gyt6O+pZUiLJQk1k6UZXt1u+PwCTuUxsKzkdkCqpK3vD752r8ZyvPejt+areTNZ2o3EuTDdNo+U29B11osXSTLSTNPO/Rnrl76cJrEIynOH6pEsqq4h/eYS+C1q8LusbTXFFwY3LLei1WikD7QFGfX4DztiSeR0PUCjPOuDNBfXB7r9NjKX2Xu581xQ6FBo4Yx9TzSK57rtCP2NbGX39lw70nh6lZ+2cowoWInTDPp2Sp+tkbZplorHnvpPRM0jzwwY6aET5HwwPevPfq6mLMfoQqAKRTFqMjmnTAkVqvCzTOeZlgHACGFYNER2nGp87gsiFEumjz1PYN6xmL5WzzTNsOfkT6c576Z8aJt6wBRhZ+/QfWZ2OnxPM7/NuXBwPuH0FuOJrATcew/O1yCFN5iYbcn/4YbXg8oebxpR4VlxKqwWKxChx1cdBQhmMCrUEd1OuRIQTmDkKASQ32NpLUH9c6qd1EcgM8UrnOzA/ampI3969/KJ4yKkPBN3HV+3hHAdZKXdptMUYDRxTII72wwmTMwrA7qT5/nS4x5hdF2YG0AVkVdQ+pcYm3BlsU/Ch9k6JxJGw2gZXjj7wMY0o8cHcdj8voYztwRw5ndyehWEv9VLfFmH4J4iOtnVvLDny0C3TVUgPilz0vDNHHBmlUpmWM7OEQc5HjI3E+aesIfSlwiEu9RpsvziLMPn9NloJwacxzUwAurBezYMN6guzqmNh3i17I6f4ZvEXyHFc93hHA9k6TrSKOA1IEyuIraAzbGXMkJOrbsJ72Im3h7b8OFaG2KC15LalPWcYEgQTyAd7XnX3JNugu1OSQIaeHNnUHZFeht1rIcU2
 zqznnwbd
 ZqYD9+S6g8bhu+PYywgix48Osvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:42PM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> Add the documentation under the "Preserving file descriptors" section of
> LUO's documentation.
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/core-api/liveupdate.rst   |  7 +++++++
>  Documentation/mm/index.rst              |  1 +
>  Documentation/mm/memfd_preservation.rst | 23 +++++++++++++++++++++++
>  MAINTAINERS                             |  1 +
>  4 files changed, 32 insertions(+)
>  create mode 100644 Documentation/mm/memfd_preservation.rst

-- 
Sincerely yours,
Mike.

