Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE48CFC515
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 05:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81746B0022; Sat, 22 Nov 2025 00:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DE76B0026; Sat, 22 Nov 2025 00:18:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815036B0023; Sat, 22 Nov 2025 00:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 684F26B0012
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:18:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBA28C0641
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:18:16 +0000 (UTC)
X-FDA: 84137086992.17.77F79A1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 21BFB180009
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 05:18:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SJwdLMeF;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763788695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a21mFOrYW7EF2pPoO72JM91N95zDCsdN4gaOlTsjcgM=;
	b=XFoBgjTdLm3v37l2IbM6UL56fM6/057W+rYmYVHQ0MBZaFQf+l2Vrz0uAuZycIpJQnrYpa
	LkJaI8M4cbeISw7cl+DlC0ysl+5lePZF/jn+YMcqLGzNmagaenGymtDS7u1p0s4tLyNdFx
	QTwbnzsMOu9x0vAiZuD+ZI0mP58DdkE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SJwdLMeF;
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763788695; a=rsa-sha256;
	cv=none;
	b=UzhNuSRFZyfDXMncZdpEEMgxrnMdWP1IlRg41BvvMGOG9CKGitGCqh9mkIGQT4Mlz1/g+j
	Pb2pPqq7gVC5SlZpQg1tyZL3jqF3xl/hOUXjd+UmWt5yg4d7jk/N7q+jqa7OzbVhQRElsM
	ueU6mnQzfNh08iaEguslGk3cpXqX/7k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=a21mFOrYW7EF2pPoO72JM91N95zDCsdN4gaOlTsjcgM=; b=SJwdLMeFBkF2KqNV6jfhdJ/TKL
	k19kD1CgRMJvJ9174C+g2EXK/WbSoyN0Vy1aLXajePZWlWWr7uaNxBRzt8koHeZ3JQkp6wxEEjSKv
	IEXa2504U+Zs2zGOXGzZttOK4QpBQqBX0CR9iT4ZLPe1bF3k2/TEx+U10GNEfmerqsEwheVMSuL8s
	JY0ZAKjiKOlYWhPliWGPChHFBpEgdmRWt8xTRdQGYH0jsqnCc479ZlXe0mh89iLLvgyqBlcTyyXX7
	4ojJYiUEKmA1fqd26Ym5WozMay98Oxus+y5hq7+ih6pabeas3AaYIGGrzIqSYiLzZFsRZhA1aMJ3w
	FDOCIYXA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMg0Y-00000009HED-3nNK;
	Sat, 22 Nov 2025 05:18:02 +0000
Message-ID: <4807417b-a8f7-47a3-b38a-94ea7bdbf775@infradead.org>
Date: Fri, 21 Nov 2025 21:18:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
To: shiju.jose@huawei.com, rafael@kernel.org, bp@alien8.de,
 akpm@linux-foundation.org, rppt@kernel.org, dferguson@amperecomputing.com,
 linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
 leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org
Cc: jonathan.cameron@huawei.com, linuxarm@huawei.com, rientjes@google.com,
 jiaqiyan@google.com, Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
 naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
 somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
 duenwen@google.com, gthelen@google.com, wschwartz@amperecomputing.com,
 wbs@os.amperecomputing.com, nifan.cxl@gmail.com, tanxiaofei@huawei.com,
 prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
 kangkang.shen@futurewei.com, wanghuiqiang@huawei.com
References: <20251121182825.237-1-shiju.jose@huawei.com>
 <20251121182825.237-2-shiju.jose@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251121182825.237-2-shiju.jose@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 21BFB180009
X-Stat-Signature: 6st6x3k59ax8tbdupdkqgp7b8xy5qyua
X-Rspam-User: 
X-HE-Tag: 1763788694-606714
X-HE-Meta: U2FsdGVkX18WjGVnrm8AHwdkEIv9rs6QAQo7MVIzEm/gVE2TdDYQPUw0lY7a5pOacyB09gpi+rPUo2sSH9ujTFdDDMeuIUm48T9VzNbVUaMJSjck5l2b53kv37BmihVUhA0Hl+eaLoDSTYwArAB+KmYRi5qsDfG1zNxri7MBlGYDEaxDQQ30/Wm/IFtrRN/5e+sR/5xJxL28Maj6Z5w+a/UyebHE1Ej/GDdJp0Q1fg7tEGY30lieLLfAsp8zeGEUpF7cJN5tO8xCltF4ufy1kfi8XAsPDxr6pAh1amABb4Z4m2pKSrSTeMn+M7x4eEisASgyBnrSoivCwURue5hTtRqtdNGD1q2YM7FfqEgzb6i0Cr2DHIIDrwG55j4+ZxPhqb+6/QiTT5rxrQu28MFj9n4o0AN40PGVUqnXhiMKD6kbHn+c6k5lSHtWYrkS4uH73ELWNdSvfd1TX9j5rUjLvyzy3IeNYIXh6U2xkNtdDtRlZ3lw2uKCFNsEV/KJw5wdlqUaprDbjkoEaTgDtMrYvLMCS2Owk5zsKTtjr4HGKddEZlH8GzryWaDqaCaZ4J0+6EP9+KPDxcZUTwaMng6DpUQn8ZpDuLP58ObQL51Amp/xKRKRpDFKQuhI6Bnup8cMHFL0xzooQAB8Du+NERctCf+4OpK5eCxu6urm80shFoYZqQK4AzgIs/Kvx+3McGGD+57Jygw9bPjF5fj89/Rjc2by/dMwF0FaOc9NJiWg8GkEuxGUlRwfrtm+I3YwgO+O8+jZAFQCfCi+v6AA0kZc2EWv4h/+Ore91RziDYG8DFA46Kie9NQJEbiNRoRdnnm9REccqqpEjWCuZXvMrojzKmWxpaIBCfMuCHgOwYUvJcP81s4osajyHPYh0iYf+Hmkj/7Fx53VJ0B5jqGyObH18obDqimLi8mfqYs4Vd9lnNN848dVqPVyrlPOZTg4mlDMYXFdcqzqGI8LZ0I0bgr
 AzzzO+wF
 mvlt0u5nLjuQvc7Ny5Cgmx9pEAyXbkLNyu8Dd1OElVfAGVcqdqe1idPvgSjCKmpDix9PsGPJj/sxAqtSyQft6PgkLtauaSW01ru+7GzALOK6Dyav4UT0usCUsgfcYtxJ2xdvYXq7A7uVg9UoacucdepKu3IgsvDxD1Gf0oYcgt7acV1fPNxskek6vIIfux1WjLISMGo2QuKxv6FU47umpFGv/9N30Bbl9ZWLkhhv00CJTa1STthXl8/C5WtVq6oiaMJeoZ+z+XAB7pnTlprKR14xr+9TgI9v3uReHNkuC92fmAS+lTIGHwkpJ5K/9sdhM0SiRS1B/ITWkoxbyNn9aGiJORH9+fwq1k8Gqz2GlB44N+dX6CfgvQSODg1jhXafXKL2vOa18AYWbO0Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/21/25 10:28 AM, shiju.jose@huawei.com wrote:
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index ca00a5dbcf75..bfa9f3f4def5 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -293,6 +293,18 @@ config ACPI_CPPC_LIB
>  	  If your platform does not support CPPC in firmware,
>  	  leave this option disabled.
>  
> +config ACPI_RAS2
> +	bool "ACPI RAS2 driver"
> +	select AUXILIARY_BUS
> +	select MAILBOX
> +	select PCC
> +	depends on NUMA_KEEP_MEMINFO
> +	help
> +	  This driver adds support for RAS2 feature table provides interfaces
> +	  for platform RAS features, for eg. HW-based memory scrubbing.

	                   features, e.g., for HW-based

> +	  If your platform does not support RAS2 in firmware, leave this
> +	  option disabled.

-- 
~Randy


