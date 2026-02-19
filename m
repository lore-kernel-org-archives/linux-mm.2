Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E7EE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 04:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0876B0088; Wed, 18 Feb 2026 23:43:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DC46B0089; Wed, 18 Feb 2026 23:43:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9E86B008A; Wed, 18 Feb 2026 23:43:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B48686B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:43:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22A73B858D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:43:21 +0000 (UTC)
X-FDA: 84459962202.24.F9AB850
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 61E761C0008
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:43:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771476199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8GJPEuG0L9g+LUz9AmM8PFrBfZzeNWVlIK+K3ZTNbu8=;
	b=Upwc2W4C4V5HETYEghzfo7+Q7jQIshHfITem9tbakKa9ZpVQD9ULNwoHrPA3dYqQMM0Edi
	x63VVFgYl4Shhm/RU4P905pDBKB7tW9e474K+fTJqhvakkvztOSMJF62fgOrqKUisqhsvQ
	pa8c+lmIKOyF+dYw3RE3dfvxvfZp12Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771476199; a=rsa-sha256;
	cv=none;
	b=79JO+/gymnM/MdN7fywHKpuKzlwp1lvhVPzQ/uuPIU1VCoJONnDCoKs7X85xllS8sIg5VM
	OLWeaYmUbYZZebZH5EfBaP54ym7YpGXG6MTpWxguEZ/gQFOppE0EqGTCNLVsXTOT9onoji
	dcI2gahzohd7wiZiaOJ6S2Brrjl/jEc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D9534339;
	Wed, 18 Feb 2026 20:43:11 -0800 (PST)
Received: from [10.163.171.219] (unknown [10.163.171.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 962943F62B;
	Wed, 18 Feb 2026 20:43:13 -0800 (PST)
Message-ID: <03cb5472-9186-43d5-8222-d6d0746d0320@arm.com>
Date: Thu, 19 Feb 2026 10:13:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: skip migration tests if NUMA is unavailable
To: AnishMulay <anishm7030@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260218163941.13499-1-anishm7030@gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260218163941.13499-1-anishm7030@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: soxkeyhcq4ebj858poj48zou9jof3i1a
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 61E761C0008
X-HE-Tag: 1771476199-752976
X-HE-Meta: U2FsdGVkX19pxbXOvmjI5lpC9fT/KKhp+Q8srAp/xOepMjFlTPetB6YFcSg/aI90dpLThV2Q3QXN4Ot9/rVNsYVbYgCEGK+2hydnyDnv1+FyXENpqabjeJOVhsG/VfG4MXfkxknBFHUfXzvpFCxLy1jvCDoeolT7H2a5Ueu2IsEdDc0RwR3salVKd076KaNz1jTDgQC7UD8X4lONvUKDHiB77wHNenXuXBcxsPWLWRtuZcAD6HPtzRosh7Zdn8JRA8C0xQ+6hAyVisDNNYcJf26rusvH+MZ02zqPEBmAImNFm8Lwu3qd3WWQAr7KwG/Wjk/ke/YTTbo3qcb5IuVn/ufHp1/2+A68Rcwm3dhI8AdNc1khzGE3yE+n1aeCibLR9Ex6HC2qPqR63t+l5vQXhOXU38yc7QgDx7waMocCNjyMLFCzSR46m/Y9XLh2XvGE20rvjON/pIasxKZktxyhlX50PZ83uq37YduRxLXnB0JjRAJW6j65z0bllP45b6x7/mA/8C8QkiXfNrC351Z4AZHDb353KmIJ5Hmv7MUDkYxF0pDsV4jvB4P7FRE7c2RLBAniEtUOgebbbgYaAJJXvF/XsmqOLGhogbC1drA5+gtkaRmvi8HYLJROwZNUwIPYQsnLEBh2SyAsY95ayYqOmrXQMQOAyVApGUqu7m9HqhV2yOw1h+I0ozxc4qACB1FDpElD/+Fl/L/XBTSpBX3Saga9rYJt/h/vs1HVkgZ3pGCutue7N1FW3G1RcQYeMCCVyDdUKZONje4z8tiIFCp/YwxMrTf+jN+sLKcM1FTTYQErrA2SEJBCuL71iDBiQtWnELW8eq+wpwBAlUv3NrzK9RXPRjaPH/VP5oUKzSnEdtDVYTxJqNn5CR8wlvIgs4Jdpqc9FRQhUnIrb9m/6lUPglyjCWPe9JVZlonm78KplRGgHuIXt/3RBACMH6SeOWgFk30HvHe4E5imWoK/jKJ
 rPvrRX7Y
 qkN81aOojrbbBXKOGPExPnMLukF8XdFBV1bMdk1ZkyU2f807Raw22OcEVP+HDd+lKl5gQNJfGD3Mmjyqllx15/FUkxaRf43h8OcDMUC0OAWxcbM7QyyZ6+ZpUweQIJ17I0HW4nZDw4P7TZ8D6Lc1+aqphYkqIX+ObK1Y72mC3YAiq29FjsdPyNPgQ+QHWPTKUsFVIQ76nFxzQWQtuCF14VwxiLdCRxX7hivN8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/02/26 10:09 PM, AnishMulay wrote:
> Currently, the migration test asserts that numa_available() returns 0.
> On systems where NUMA is not available (returning -1), such as certain
> ARM64 configurations or single-node systems, this assertion fails and
> crashes the test.
> 
> Update the test to check the return value of numa_available(). If it
> is less than 0, skip the test gracefully instead of failing.
> 
> This aligns the behavior with other MM selftests (like rmap) that
> skip when NUMA support is missing.
> 
> Signed-off-by: AnishMulay <anishm7030@gmail.com>
> ---
>  tools/testing/selftests/mm/migration.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index ee24b88c2b248..60e78bbfc0e3e 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -36,7 +36,8 @@ FIXTURE_SETUP(migration)
>  {
>  	int n;
>  
> -	ASSERT_EQ(numa_available(), 0);
> +	if (numa_available() < 0)
> +		SKIP(return, "NUMA not available");
>  	self->nthreads = numa_num_task_cpus() - 1;
>  	self->n1 = -1;
>  	self->n2 = -1;

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

