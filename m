Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F8BCA0EE0
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 02:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2290E9000E6; Wed, 13 Aug 2025 22:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2013D900088; Wed, 13 Aug 2025 22:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E2A9000E6; Wed, 13 Aug 2025 22:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0340B900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:34:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BA9F1404C4
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:34:05 +0000 (UTC)
X-FDA: 83773793250.18.8694589
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf28.hostedemail.com (Postfix) with ESMTP id 15D1CC0008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:34:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755138843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZeHjt8RS0I/izxrY7g0wT9zySfdxzfzHkhhIwCEWh4Y=;
	b=gbZVQ7nxZ6+RXxp9eAbl7Vjl/+Tyf7Ke30Zlkz7PHNRlLyzaefAHtx9lSA3TVnw7l1jjeQ
	/hNu1gFOB4S43TQfqMgYMdA9lEFw3wcelK5JoBRN6mFbShMbiEs++L1YZ9dg4wiIFRB9B4
	kstynTbtft3RnJ3cgQIeh5A0BaTHNgw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=gubowen5@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755138843; a=rsa-sha256;
	cv=none;
	b=n7qS1HUqZGhT7zhHWrOGiBGm2VMaz8C5bvK1kM3rK24v6Z2mq9CksdTZrQR21e78+rnTFo
	w0Oehnc3sMWFqOwCCanucUyFNBiQtZbCEtE37q2JHDrakks0T5nllW+lDwZvok7rx9HU79
	8+ONi7zKWN754Y5sl3Ju3K97QtQdlIw=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c2Thx5mSwz2Cg6M;
	Thu, 14 Aug 2025 10:29:37 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id B49FF1401F4;
	Thu, 14 Aug 2025 10:33:57 +0800 (CST)
Received: from [10.67.111.31] (10.67.111.31) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 14 Aug
 2025 10:33:57 +0800
Message-ID: <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com>
Date: Thu, 14 Aug 2025 10:33:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
To: Andrew Morton <akpm@linux-foundation.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, <stable@vger.kernel.org>,
	<linux-mm@kvack.org>, Waiman Long <llong@redhat.com>, Breno Leitao
	<leitao@debian.org>, John Ogness <john.ogness@linutronix.de>, Lu Jialin
	<lujialin4@huawei.com>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
 <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
Content-Language: en-US
From: Gu Bowen <gubowen5@huawei.com>
In-Reply-To: <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.31]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Queue-Id: 15D1CC0008
X-Rspam-User: 
X-Stat-Signature: mh7rophouehzdtnbrb81eetgiw9gqcmg
X-Rspamd-Server: rspam09
X-HE-Tag: 1755138841-594160
X-HE-Meta: U2FsdGVkX18t4govPh4wGhnxG75AvmbMw+OkWPrejOA2+xQ1vB9Taee+vH0Nk+zE6f1GwcsAALULUolrvPzq7R5X2H8PFR7iNYtmuqKIAhUjonS4pPibJ3+lC4owR+LxWDe1HmSaxceogsZd0lNdPnsmfR2YAgrQ6xjrTXHb5Z/RgibmA1HnthmK2+YkWhiVXdKw516Eah7XzVrzcDTI4LqMajmNhLBwlpPWH2JvZKlt4tEtfQti7zW2wGvqdpNNMRwe2m//pSPruLiagne9rtmjdO1AK5LW63DHKgbNB4YAdOJKmYqNfcBq/ldDEPlqj4iP0Z8tjNMZ05isrxDB7JRE4jxiXaobZXnOPGKSeWZINjao7vP+lwHRECdYG8MvVCz4ogGR6spJaJbBRq0J1OgHUWOJ5QdFPjB/ePpEM+lJnEJObf9sp3HZxlQiUmOm9PqGdsvdqoMQn76JW0uHNT1DfIaXd876eYnNG5rTZszT+OL/WPA+B8q/TUA98UQvG5fLqUxnfpcEjJedfNEvxprPe5NBTUqxTw+9HS5398UjrtsabpPKHBDjO7BLX0/xfa+oyOT91nX0TOjiw/FD72r6DkZVhU+oXNxjE9gVdfAeSkDzZ7X2IlY32wy+F1Ux1TlKutU8+jGldrCVSc/eZ0npTClQas0aF9P2eLE+XU20IzYBqlBn140MappktLSdDLKNSiyZ7zfBak/spajQisguY7N86VhvgGvX9zLAcUEfgjVnZ6baE+KfHtzgELueF9nBElH3VUqvrEHWjuYakBE/9xlg+/b7SEEStlNddwB+vLnjkoWIbAccDIyEornoAWFTYLEYNExDOsjoC6Iwrxc4TzgYdXETBg5ZVfpk79tut5kb9GCFHRHDXm1sXLWCsph+GJGSBWudAtq/fMM0E4GmNF2yTOZ2VqZluW+L192pBlYXio1DnRIUkpHtfqCScPjl4A8rKbqrOvQVbMI
 WtA3CE02
 RpaDuRZdBXShb85VBWJQ44w6z5YFXk4AmLzYW+G7F32HDmr6xy6YHdkEpokoOzqV0YRpOPTUgkOK0h2ZcKpNo8xTnwZ+UV6Z7R3fuixkrqdoSi6BPmKQzVTcewgQWzW5/rP5pwJ2cvr7aNgzvek1GVCWGzFRqAUYmuNwDun/DRVLrFoL1eOlW1eEIqZdltRpyIHGNb70vlrZ8ZDy9TfjKZN9bh9ZCGp1JoQ82t3oXsbS/SevqL1tlGDo99MhAoKSGFrkf9+GTrDsxB43girSGEVD2WEE7zP2z/R8H3whWQvRf2ugdGqSaXX1dhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/2025 6:56 AM, Andrew Morton wrote:
> 
> I'm not sure which kernel version this was against, but kmemleak.c has
> changed quite a lot.
> 
> Could we please see a patch against a latest kernel version?  Linus
> mainline will suit.
> 
> Thanks.
> 

I discovered this issue in kernel version 5.10. Afterwards, I reviewed 
the code of the mainline version and found that this deadlock path no 
longer exists due to the refactoring of console_lock in v6.2-rc1. For 
details on the refactoring, you can refer to this link :
https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/. 
Therefore, theoretically, this issue existed before the refactoring of 
console_lock.

Best Regards，
Guber

