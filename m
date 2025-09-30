Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B16B2CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 04:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171828E000B; Tue, 30 Sep 2025 00:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148B48E0002; Tue, 30 Sep 2025 00:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085EA8E000B; Tue, 30 Sep 2025 00:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6FC48E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:53:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78F2287892
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:53:09 +0000 (UTC)
X-FDA: 83944697298.29.463EBC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id E9D7814000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:53:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759207988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7GNINWoNIiEPH+LertEsjmpIkSM7MHjs8ktY94qaHPs=;
	b=M0W+a1JqSCgYxAhR4W+0TxDku0vUFbW/BKrn/Bj3d39EiRZp9eRCKXzP5dzivfXzLekYTK
	YQPKS6WGYaITkEr1mHvBuAzPyqYguqexU6+etEOn/j7UXyHr80EOVHIev6NXPa6vz1m4ZZ
	uyzYP7lHBj/xbG9Zh0rDT5zdlo7paBs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759207988; a=rsa-sha256;
	cv=none;
	b=QtjqosGFbqY4Ag9SvMo2cKle+iTTPlZimdkCYvJDWq4PB6NR+yFHyRABUfyJ0Me0J+CqKH
	on9ZlK4JM/3PiKlXIXYLUJCoeO/IE4vGwKxr6WBTL3dDTGWl6m/1INiEIRSfGzAVXHyt/U
	lyPItnOKMPMzbI81S+NndyWSRH0z9lI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B90182F;
	Mon, 29 Sep 2025 21:52:58 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBB2C3F5A1;
	Mon, 29 Sep 2025 21:53:02 -0700 (PDT)
Message-ID: <486e0d6b-799e-4fec-9e6d-3ddfdd64418c@arm.com>
Date: Tue, 30 Sep 2025 10:22:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] selftests: cachestat: Fix warning on declaration under
 label
To: Sidharth Seela <sidharthseela@gmail.com>, nphamcs@gmail.com,
 hannes@cmpxchg.org, nathan@kernel.org, shuah@kernel.org, morbo@google.com,
 justinstitt@google.com, nick.desaulniers+lkml@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 david.hunter.linux@gmail.com
References: <20250929115405.25695-2-sidharthseela@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250929115405.25695-2-sidharthseela@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E9D7814000B
X-Stat-Signature: ejhtz4o5t14w415hc3afgo84bf7wuezd
X-HE-Tag: 1759207987-129953
X-HE-Meta: U2FsdGVkX19ihQCQPnINI/u2VWMWLPF8qic8H2dDTYes4JvMRqPo+KUqvfhojTtOSiC8uyqcZfyYW/3/1ttsHkhJiG7/aAncO2jXVzR38RnTx/rqKuq8i8XdffX0NKBsg47wKvJiOJPma60CFInA3pMCdsiJkAE1URHjwp2DQFaKQTDR4KTNzYMnYyfZAo6ZPSiu+8eCHxqjDH2QGU891sVHKtzYW5we7bPF5zNhJnoPmDMdeR4F/683y4i0rfeWCQ+NvNAEdKQmNZyak1PIYC/pWAQBPXEquLjVKJslBNmQ2bUAwiBc00jajPSxvdKm2HALR4xZYV1zxtVI4HDZ9+HC1o6mNcNmy4qcefhok5cZh534seJhwEWLl0f68UWpeadI6I5FtFBp/+Uk2IzNONHwqaqVSNB1e1P5y/K9g+ALR6urctPR4+lkWU0XisBNOjIPc5C27Q+DOa7a2chjy2nWMQZugVfe/epDsoIiIZf1UcnP3GOyEp+pCJO8E1iEGwezrHHbu6oyIYFPaXjriV4QfGUvq3Y2n2q3R71THz90t5FdXxjIB1xjQhzfMh7jBw/SzrYtSLZ9OdJ/m/IdBNV6cadmfxzGV4lSxGAwxAjLA33TSpLMbXlCFl77e9kOWoiQePiz0wPASI7qGVvBXsSdpvToNppuUF4Ncp7AmXwguuIxKetI4oYoslLAsbm/JdiVAm5EzGP7IEjTgPjQi4VGYZNqnDhlirsHTfpgr35pyTKhB8prEsZpaiJ6Zb80onZ8DkjkFio60jRnTQYl8Rmfhgr9HS1DoeyHxRVAQ0EdAdlgsLqZ9rNMwNOf5s792l14iFLJpFI0CmR51pVWeqJb50fpdnjQwPg9snZhhKyL/FcqQrPvDcWpYscBFAhcJm3Somn4AtcESwAyhj8IRkUaJeqGPs8io/JqlfxQ/GM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/09/25 5:24 pm, Sidharth Seela wrote:
> Fix warning caused from declaration under a case label. The proper way
> is to declare variable at the beginning of the function. The warning
> came from running clang using LLVM=1; and is as follows:
> --
> -test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
>    260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
>        |
>
> Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
> ---
>

Reviewed-by: Dev Jain <dev.jain@arm.com>


