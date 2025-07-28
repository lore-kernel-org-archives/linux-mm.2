Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C29C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 10:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FCD6B009D; Mon, 28 Jul 2025 06:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620BA6B009E; Mon, 28 Jul 2025 06:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F726B009F; Mon, 28 Jul 2025 06:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8426B009D
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:18:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7F5E11162D
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:18:53 +0000 (UTC)
X-FDA: 83713274946.28.8125AE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2A37B4000C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:18:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lY7dVkWs;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753697932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuKQIwxMxtzB1Mfv1YRMqvx0C5POtmNCmQhK4dN32xM=;
	b=EzJpJHURFk+3i+2FL45c6KRdP4xfkgKLrJZTC7knkHTBMZ978N8xG51jkWgwiVnUXhRTX3
	OFDMD43gX9q0SbGP5qeJMyDI12IecXmYBJTF8crGLL+72EuF1wbRyDbuJTRPylH48DjVr9
	s4UqU1qnIWZ1VET/nHyNHAKUcbh5sA4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lY7dVkWs;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753697932; a=rsa-sha256;
	cv=none;
	b=YEnKWacgxyoXtY5DDAkdbs1lSei5T+2k5iSKJ5Nc6NdNzcIzjOlS1uX2q6Ytnp1YnwhCDE
	m/ROgSINaswqKqwl85/dx/P15Sr5D2xLszzwhyOiVdgWKpkdR+Ta//49BMiR9n+y2yedgp
	ln1Bwrih7ESAeUDb2I/0eIAuVtONd48=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DC5D601D0;
	Mon, 28 Jul 2025 10:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE45C4CEE7;
	Mon, 28 Jul 2025 10:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753697931;
	bh=zVzQvvAddDP62V30se1D6wE63TQYVFTDCsf+N1N3pAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lY7dVkWskMdiX3zYFhlvt9M8GbNXRdktQ2KO1GeMS8CxBSPoF3g3EyYYvZVi6rVHn
	 o24oG5gpVcPqmMef98a/MgQ7qfHb9O2lAwY+Det1Cv+jj0aCXwcFUogaoLgG/VxNwl
	 8GacG1Xsi1gGQVxTNHktfwVqRtSsaAP9ZGzDci13IP2NgzNOkFXfRYU+JVOb2YQ76O
	 6ZCvA+4ywB4DSKZT0GpFpjW8KEJFh0fvX8kLV6EnwuLF7kdYUG5TW/r73ln5bZ67Zi
	 4USeNV6riBWSQW1Q2tdOvlC7Rs0tfw2ZI3I4vmpaL904qlqD0mCpTwo/vb98XKR5c/
	 0dtySijehknDQ==
Date: Mon, 28 Jul 2025 13:18:26 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
	leonro@nvidia.com, witu@nvidia.com
Subject: Re: [PATCH v2 04/32] kho: allow to drive kho from within kernel
Message-ID: <aIdOcmTl-zrxXKAB@kernel.org>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723144649.1696299-5-pasha.tatashin@soleen.com>
X-Stat-Signature: db8y3kkwj43o5skgro4ejroeh3j8dyn7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A37B4000C
X-Rspam-User: 
X-HE-Tag: 1753697932-89073
X-HE-Meta: U2FsdGVkX185T9NJrAqzZ6E9VJiBmBzHZYVNegOVxQ3D6FKbkbXl/N8+QFPwb2DK6ZmGp8ObxTkcppMEwoL9vfqnwDAhTuuxmO4KaUGz0zFVmwJEVbHIdbvGOLolxLzWxa+3Vntk1jjnS3vWMYgpg3K0/1w/ok6ZFJhNMDpymxL4V7tS0+FWuaA2b3iCCmRPagFdQtQxw2BvZ77MAYLrUjFU9wAgesKW+I9Te7CznFe63W3RS2bwvjGXZZHkuTg3Sf2Ex+Bo9CacZtIvfdoR/H8TAAvfHGD1MBW2F0S2k9yX1zWqRi72m0Iou/hsue/qXP0mS4yOzpbskSv6DwPBOCCSINbWpN9Tu8vI4rCIIJR2OhhgO9so336d/ZfcQUcHogm2LTGrpzA84hlReS2uBjnjFUxNOtHgnzNRtyV1jRVYOJgepsix2xbKCFXc/D7LFs34seL1fjBiublEb1Cs6KTmztvj24vOrj6dyIahqPd/T0Rg1Giz/QIOb7JrtS0frdYyEjhlhHCjIf+qaxbSTb36nCCGJo/icM9aK3wbx/jyS8aL8CYwkbsNN8t420IkZYTov8IwDOhQrL15up2Rif/Syc7fW1P9F8aS4sHtSo1mFLl3ImtpbUZp9lYZnNkLvAtek89itsfgienmgD+6CF7GZEWhxZ2/s8il18o6gGbNf9yfk3LgP6OsIrwHrcpGL12OacFw88600NjsruSI8/kI4sNcrInprYaJuWy73yttet6LVh7H3XPSlclyC90RXeukGyXL+ookilI+PW3HuPC3pt6FjyazBHfR2wCri8W8b9ILuYv69LEHiB8rBXQYnI2TkKzeEy/jpg9uU2lTrRj5CNxLPszKWBZttinw5uKb2avluSgLXE1oxRZYtm5P/jM4iQqi51bM4+wGbj8mDKToWWEhFPZMmp4GXZPUNPVK/A4obAC/RyECJ+BS4LKzQnuFdWRiCAzfsaqcas+
 bRQ51taN
 AoUO3tQVZ5FzvQlWgDnEr+wXCm7sUrXqH2Avp5AvSX/Xj8tAolnMzsvRCLRwfV4ImV5X/9rYyslq8PG2KwLZwPRt5OAZT7PuRjEk+nOdilp3PawChzF3AwChhG5iT15doY5355UjjSswILnN2HlWn3y+aBWNzMHCo6dbPTmb0zN+EvzkBVGuCA78W3QLlZ9wi0gZhIBY+5gifC8nZ1EioVAcIZmYUa4E42AWGPvCslolSTe9b4PMT2cLCo9WJXQL1RpEQCelglETXJbmDK7Df+6bD7kspBwA1hyhkZkrnI9cFUlJzFeQoORVQjoX4EPzfAcH+VgOChyl5GBnWEv2pSn4AJyKpVBz1JSm1mTtrQTUWNEVnjEQpEXK9VrPXAJUiN8Cc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 02:46:17PM +0000, Pasha Tatashin wrote:
> Allow to do finalize and abort from kernel modules, so LUO could
> drive the KHO sequence via its own state machine.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kexec_handover.h | 15 +++++++++
>  kernel/kexec_handover.c        | 58 ++++++++++++++++++++++++++++++++--
>  2 files changed, 71 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h

...

> -static int kho_finalize(void)
> +int kho_abort(void)
> +{
> +	int ret = 0;
> +
> +	if (!kho_enable)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&kho_out.lock);
> +
> +	if (!kho_out.finalized) {
> +		ret = -ENOENT;
> +		goto unlock;
> +	}
> +
> +	ret = __kho_abort();
> +	if (ret)
> +		goto unlock;
> +
> +	kho_out.finalized = false;
> +	ret = kho_out_update_debugfs_fdt();
> +
> +unlock:
> +	mutex_unlock(&kho_out.lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(kho_abort);

I don't think a module should be able to drive KHO. Please drop
EXPORT_SYMBOL_GPL here and for kho_finalize().

-- 
Sincerely yours,
Mike.

