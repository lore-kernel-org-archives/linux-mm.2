Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1E3CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 16:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CEF08E007A; Mon, 11 Aug 2025 12:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4D28E0060; Mon, 11 Aug 2025 12:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA4F8E007A; Mon, 11 Aug 2025 12:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66F2F8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:35:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F01D51368E6
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:35:10 +0000 (UTC)
X-FDA: 83765026380.29.C24CD37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4607080013
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 16:35:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qsEskb/x";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754930109; a=rsa-sha256;
	cv=none;
	b=SAPjBxwZpljy9kqHD81tpp7YPcFazOPLPdz1JwtNQvAZWRZ9aPncQS5lCs1+vN+80t8zdF
	6oXGFcssRV9imgsO7bG/VpfuhyohWNlPYEoj4JrE+cV+qkdJSji8Rn2qpA0DqKlZZ7V8V0
	bP26/+H5q15bxyu9KxFCjkUstMQlFz4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qsEskb/x";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754930109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDrXg4lSCK4itLDP74MhSKr+GFauxn/ypS0n58V4Syo=;
	b=ntTkjZQ93bYufcVMCie0mFV76D5+U6OiI9DvTH2qal8fKhB/gqcJAEWvT29ZHMif//jWKw
	49q/F+KPEw3aBDrPdQuHcewgXN7Mkams032dB9E4s2c6AY8dFY78gxol2bGfRfE9BhHkcB
	Bc9qdlU4H3Xe6lYQ4tqXVXTWPJu4suA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF608449A1;
	Mon, 11 Aug 2025 16:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D41AC4CEED;
	Mon, 11 Aug 2025 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754930107;
	bh=U3ajoq2JrlMt/JwLVtLkb6ZXEGfnsVViHIOqNoUf92Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsEskb/xJAz3GxhKxE0sBOWRebcAIO53TMFP/Yn85IgldEGEVADeuMoXhjJiPSAB4
	 ye5JPikwIET8n/WchW2Q8XAS5bdZN9ld4i6Y0Le46v7rWK+6APLIudA9Sv93N5dVWf
	 55SHBcT9dVIRHsY1cx3FeXqF0fW+co2jmNu05J+V15mH3U6Qypk02fS1K894eSmBEq
	 jaswoGPazb0RApM38bHVXjxBnHLr/ZB+2iYyI9eR0o0vEQpgac3OxRMagD2rMzWWqp
	 NFJcaa86W4/7B/UQ7Nsp0VkiDKE0RIvn+4jLQ4nyqs05v9lZNeiVZsa5SjIfzFqP6W
	 yz4kiyxBk+YBA==
From: SeongJae Park <sj@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: SeongJae Park <sj@kernel.org>,
	oe-kbuild@lists.linux.dev,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	lkp@intel.com,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	corbet@lwn.net,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH 2/5] mm/damon/sysfs: Implement a command to only commit scheme dests
Date: Mon, 11 Aug 2025 09:35:05 -0700
Message-Id: <20250811163505.62056-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <202508101330.XRQqvfiN-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4607080013
X-Stat-Signature: 1q9fhe7dy5bfhhopo69mic5zo1whob65
X-HE-Tag: 1754930109-83712
X-HE-Meta: U2FsdGVkX186S6cxcGBD0rk8kC+PH5iAqKgRzwNstgJO/weu0gm0SbB1vitoC/7ItCr0HpKgIlrVISgbRjvKCQXfoF+R4NC4c6DbesqnSOAxDdEcjh9YNkBrAuZGx2wynmexsZzMU4PoEXRw6s820sj29yQrN/r+bftQOuOR2AqHonOGbVLBLnCf8aZc2Mlqz2YVlRPuOMUUmmuHBiupkfRVjbmwSfKBNS2QmI4yNp+X8fwzoITT6sNdhTNENl0U4UFnRsRQ/Wm7OR9nFi4dUeKZPP0nph7ZDTehx+V25MabVFigCS33bWmB0hOQHFg4zj53eawXXpvB+R7Q/0QuUsbTT422uyaXXUBo11p0meWbpHFY+iPtM718LU85yPJXGlLu7ev+B6/c3f1VaYH5UBU/BDsZSEpdDQmlAR0LMn/TYXNhTjYp3YF3A0r+uoTAjQGPkVminScUc9okWU10+WyJTMtHKOSct9mupKArVWhBfhOA3xMk8aYHbk1dWCbO7GVt3l5Ki5RgSwX81IEAV2MlxFRgYdm5xbDg8Jf2rK5ynLc7PFvRby7XBZqo/x8BcLFE+zIHIRwJfUO6tnlbmNq5zzMGxAHoLzL0mGeu955mbSLfP/Sp6kABf4PMvrNYOmROcMadpbmwrdHZ/LPmILTyHA3CRMbSVJ4DD5BMBn3hR+azdRkdwpEXXbk6ZljYU5Yk71NU/VslDBEsGskv+te5gb2VvpIZSbMrGTBs5CSKTEveXzP8QngOIZmqjI3OJRIEbROOrGKcTYx8E2DnfkIQN5w/W9Hr8acWb+gD2l42+GCZn5+uYwLbN6KzPqg8hiRSQ070oc08M8bK91PF+o9TA4xNpSi2geP6Fa7QFN0O/Fq8ES2Ut6nfCVY5ti3lug8MWItSQYmXgVy8PL/crkmAOKosAAPoYykaQh3Gbgcgblc+QVOgh0us53ETkKgn+1CgQxA64UDWzRn1g7W
 43+0CoKA
 pZ5VZBE0hh1w/su2nXIsOpwExhCW2A8Vu8iWEgupoxudWHVqBsPu/pN5lCvPYAsSuqyPqA0FDqjg9sJ5Xs+KvOV/keO0FouG9g0B1TxyyszMTBjBAYsP1I9MBdS7pjGRqnST0Io1QK2k77Een3UXDCwIpsrSFT5aDBudZarsEp6mm/UjMjkBMJFet878J2yXQc8Pnm8HIuy/+hMDpdw0ZKQd/CdtUQdtp+bNlC6toqVSaOhQ/S4UmQ9mZ1PlyXXfGqHB1cgLIdzErrdrH7kcJcoH1fRUG/ky92Bh56NNywZ4dj75P1TMp4L0NqoLGOCiNi3KyUCN+8UwvmvCwrqD199FhfFdX1JcVRJlZRDP/zsWfa47wel43SfLYrAuBxPoTYyHn7nd1sugVLWDsJgfacc1Q4UndgQ4QxuFDXyExRQPFRLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 Aug 2025 10:00:50 +0300 Dan Carpenter <dan.carpenter@linaro.org> wrote:

> Hi Bijan,
> 
> kernel test robot noticed the following build warnings:
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Bijan-Tabatabai/mm-damon-core-Add-damos_destroy_dests/20250806-120845
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20250805162022.4920-3-bijan311%40gmail.com
> patch subject: [PATCH 2/5] mm/damon/sysfs: Implement a command to only commit scheme dests
> config: microblaze-randconfig-r072-20250810 (https://download.01.org/0day-ci/archive/20250810/202508101330.XRQqvfiN-lkp@intel.com/config)
> compiler: microblaze-linux-gcc (GCC) 8.5.0
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202508101330.XRQqvfiN-lkp@intel.com/
> 
> smatch warnings:
> mm/damon/sysfs-schemes.c:2605 damos_sysfs_set_schemes_dests() warn: iterator 'i' not incremented

Thank you for this report.  Nonetheless, this patch has replaced with another
one[1].  Hence, we have no plan to make this patch be merged into the mainline,
and we have no action item for this report.  Please let me know if I'm missing
something.

[1] https://lore.kernel.org/20250806234254.10572-1-bijan311@gmail.com


Thanks,
SJ

[...]

