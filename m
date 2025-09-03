Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACDB1CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2758E0011; Wed,  3 Sep 2025 12:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCA0A8E0001; Wed,  3 Sep 2025 12:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07298E0011; Wed,  3 Sep 2025 12:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B01DE8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:25:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A0778662C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:25:12 +0000 (UTC)
X-FDA: 83848463664.30.EA34BD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDE15180009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:25:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756916710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S03AA61nXFsZMLYNERt4O+f+sZ+Hfb/npgpP3my8yz4=;
	b=8JE5QNmdRXOO1wwizfe6Q3VQRxcWdvb1wLz+OBKc4pYFjBqlZ6NXdchTT1Zf0oCZvLXfns
	mwsYcp5jdly+XuPOfaJ1bXtaZEyXQl3peRWqMQtYqzKRiAGOA6qGc+uwwB/l0azvfnsBfk
	NvIflie8gj/IU/NADkjLUtVu+6bldHM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756916710; a=rsa-sha256;
	cv=none;
	b=tIyF0VCNNyIr4VsKtCstrRksM8BjGJ7LR8/61JvZxaWK0ihQc/+CpyyEgEbQKPvxGNJoU4
	DHhWSuemFDp4BsQi+3Q1Gkv1VoK4cEWWYS66+Zh7Pq4ca1FuE15Dlg4hCGYJelmvzlgCm/
	l6vHlB7lzFrBBsPBoBDzp9g7GW2GvYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DFAD060248;
	Wed,  3 Sep 2025 16:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23600C4CEE7;
	Wed,  3 Sep 2025 16:25:04 +0000 (UTC)
Date: Wed, 3 Sep 2025 17:25:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: james.morse@arm.com, linux-cxl@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	Will Deacon <will@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Yicong Yang <yangyicong@huawei.com>, linuxarm@huawei.com,
	Yushan Wang <wangyushan12@huawei.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 3/8] lib: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Message-ID: <aLhr3v4z_YIYaq9Z@arm.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
 <20250820102950.175065-4-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820102950.175065-4-Jonathan.Cameron@huawei.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CDE15180009
X-Stat-Signature: qoyjsjtdp16rw6gwuqoetsqgbihwuipi
X-Rspam-User: 
X-HE-Tag: 1756916710-979601
X-HE-Meta: U2FsdGVkX19JspbCqfhZPMkV8biHK1KRH+6xLQ7IUMKIVdQ3zRD8d6Apwx+nrpmotqQ4tnVTNzDWJ9rcLNFJFzO06sYVwlGSz+7C5Wt7sI3tTM1Qm+TUp8fywXxdCS+KIaOKFwosAtPZnAre2mM4epIOniIlgpt7yWB4zzKAeCZ/mDdh7XQExlC/UyPRIoYufiCgZKboxgjHumx+z5WMG8IGMiIL+1X5g8PLI06J3/OjuNJcMN9J1DQ6h9uhdHrFSpg9SedCeOohs/3l4/CBpd+x9w2KSRY+jqY+D08Ojc5gDcqIT48XhZgRQsWTHa8P/JKA9PCEClp4iT4pFK2JjrGz2snNpcNh4BH/WPF7pjHZwzwOSBjuOv5sPIMlTe7OLZjxPrcvpwmuoTeYs5qhSy/P5FHVl3SC71mXB+d1QjTyvg1SbslLpiqlmsEG+JYJ9Lz9IBm8Au2LI5fkssMAv0ub5pBA6riVXFtmIWRqxcrGInZZM2D2HiAg1Wy0NIgwYgP/X/9fSNWMigm9vxCplKJsNNQvs8D9BYqZbmuCd7zVZ8ty+Iv9bwSBdKk/f35mVsgPtbhavZ4QmQHUlXcjTm5+oTpOCW3OMd+ddS782m9MBn2ub1GWhhmu+U7E6MRkvYa+7n44io5DxWFUOKHO/6Bs+8wibGBW2r5VQPPi15F1Y3Ozmwalo7TW7L6AH9AwRA461z6W1RNt8pNub4jBEqlpFFuHZwQ+p7Ehcs2YZR2Q9dHLA7agDtDRx3HJWSQmJwLb5EU6U4NJ4CRW66ZeNfWuh1MyUCg42rcNR6ksQfdh2pcF/ysmO9A2P2rfxSrqRElPSZbY0i1tH80LP/JFNRsBPPEncmg6fEjjXiagbE4t/lk6XJnAEiL7OtNz7elbeaPcNRgutnNHVcXJMF1HN5F/uiMlXmPS/47HWbiLD3OcGzRcDHUZzxQOZb4MePoSdt4Ms16LUJWI+bQ+Ba/
 pkcFzTxr
 gpcvUd1Oh3ulv79tUgzJkxj/ambJwzqLnGzpGamyOMVwaVXTQO4FdA3NkOkBcovuxC5zwl2FmhpLaErKA6rxsSV5CBq88Rz6oludoixrdF9duH3QDN2dLv+UnRBKlD3hcE7iYmFYSWZEr+IxbCAkptI3PJi8KmDse8/q7++k7AVvVAbw53HQoxh9JBPqTqGKFskkXVpt7xo7HDLJ6u6rXpA5NYPYKl45fyo1v8d+CM+APq1hPw8yDRO+xFANtHluta1YhjeYspDMIn8bZzFkuubv6RWbRSjiI+1JBdkgrZJAVlVisJGhwATLr14ng27j77UmFXaRHGRAt9wALZ4ziG/PYE9PSS1NI37nBQd2YXHXrNEli22pFRY2iBN3mObA334RZ1Oq2LCtid6g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 11:29:45AM +0100, Jonathan Cameron wrote:
> diff --git a/lib/Kconfig b/lib/Kconfig
> index c483951b624f..cd8e5844f9bb 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -543,6 +543,9 @@ config MEMREGION
>  config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
>  	bool
>  
> +config GENERIC_CPU_CACHE_MAINTENANCE
> +	bool

Nit: you could select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION here since
the interface is now provided by the generic implementation.

-- 
Catalin

