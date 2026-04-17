Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0298F8E4A1
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 02:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E6A6B0092; Thu, 16 Apr 2026 22:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26446B0093; Thu, 16 Apr 2026 22:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63216B0095; Thu, 16 Apr 2026 22:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8C236B0092
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:57:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DDAE1B8FCD
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:57:58 +0000 (UTC)
X-FDA: 84666538236.30.A33329D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84E0CA0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:57:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HHfZtUF4;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776394676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDjdFmoEOR5iLxYSWMnOV3Ajoc4VfMdgbUO5S4+4dvI=;
	b=iuYYvVnfrKaCfm6teTccDIEGBxWwKFFjJ2b/OGuTQHvsn3C0nVMGTS3CsXQxhenIkiXBUt
	97QR3Dwvm/dOJNSWQuBsJ8guC3EB0Dh6SYXGeQ9L2x+0hEyrzTy8MiO39KuI+eswCHlh5Z
	oMCQ36oTv5y99xf1nwihbYM1PP9s9U8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776394676; a=rsa-sha256;
	cv=none;
	b=djKlG9C5mc9pFoa7PV1qrgrPE1Mp88R3NmcaMs89lbI81VqXtB6eDnmubAadrzuB9rC8H6
	h6ij8dMShCkyQ0jA3HcphQ+2CBmqZCPUHRKJMCs01maj3kpARfCiHcCE+3Wh/6hrFrjhwo
	0fSocaF7IALKpUB0fXi7GvoCvda3/n8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HHfZtUF4;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FEF01D70;
	Thu, 16 Apr 2026 19:57:50 -0700 (PDT)
Received: from [10.163.182.249] (unknown [10.163.182.249])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 970EE3F7B4;
	Thu, 16 Apr 2026 19:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776394675; bh=rU6WmezYl0sFEUtCoWXdlbtECzJmA5nZDI8WaNi1Io8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HHfZtUF4DX1Gnx+ce5LsWGA8rOp8LoMLW80xHORqa1niNvxA9NKtQvEOk0wQbh2WE
	 TwNyACytKPLobSP7VzhreMhv+kY+5+DKN3q7RXUUHUCoRy4k5x4XsJVnhs27XJFu9F
	 bBXylUqT2cJUNk7IVzWYvTLkiMvlkI7IirZvO610=
Message-ID: <c3c27255-d50f-4c82-baa5-1f71375dec99@arm.com>
Date: Fri, 17 Apr 2026 08:27:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
To: Mark Brown <broonie@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 84E0CA0004
X-Rspamd-Server: rspam07
X-Stat-Signature: y1mptwkxxsqwss7kxstbbbuzu9o659su
X-Rspam-User: 
X-HE-Tag: 1776394676-871127
X-HE-Meta: U2FsdGVkX18y0I8RJWOc6mF7BB7dusbLKB2mqR3mkyz2P43lK6CQ4uG9cAwXlynQwStZkkSLR3LuH4s1NW2p+4GOB0/Jj9Y+wZ3Brr3z3ByRszdGu9+wmX3aI0luLsE/bBda+Z/lkTx3EyhhF8XvxfYfVbzTPG9mNkTHYtV8PtOuXJTLGywughpJ4p9vWXwO0hvua45e2/xxByf8Nn17rkF34K9iu3luc0JTu5kQWdQ/hPVyLYimVWXXb+/RVrQP7ya47ggT5n6dbs7pH6Py/rJUeVML2fXAmQATCpKP++jFpEuvoIBSwVHjfDW++XDqiEk/0rz4MPx1h4S4qpLIIolcidLu7TK3e2lDEezhZJZsZzj4pPSbF32rm+1C3FjiWVqZ5TpvYlRuCSq/Z1rUpr2Zq7Iwr7vFdxgLP0cEchXr0/0wPJxrZCCAfRm1oxoKA68EP25aag5mcz1rYm9nr6WE8bWmLlov8ml47QuCoqN6Zg6DlOeEvL+UG15vheApdQAj1R3FeN30rBYU4uBsNVeAGcd5v01vqUS8NPR2VfMq/qEpiQ1arNWt8r6uBYemsdT4Qu/XEFYJvI+GsWE3k8nQXA5v3CjBVo+P3Hn0iy9BvsPjkBUaXzfOIb7FF/ZBjDl5VX1sFB88RuTMW8RCYTR19r3bjlk+o/bS/NSpOien01O5srQ2GI/mCEgIJ8YnrC9ntPZiOzn3JvwlAx1OE+9R+yTqc7wKYD+0tqSJ5kPLT77EHmurhaHB2yeJrgr+SURfMWw9BRJ8SxfK9QoOPashyiYi6YfzNA/jiGL7WxDDS8k20d2zlU52ZWBBrYoBYPZFo7R45o2xmxPQYVu1ryP4b2ywuWroKjscILGA+s7vCTuIv/o+jFPQ0rmCKFGZL2+SLLXkR/7jm+RQ1xqSVPKIyKxHHgOjOG95IDqE4gNmXDqDHVA9ZLybNZS34KQMhI3khlKuM+/GWXmzu4e
 lyr1szJl
 H/xPKkOPyw3usF8Av3ozwexcxfWDvHycqqWv64zdp+tdoDUgHYk+C0N2/vaCxAIq69cwmUAxJ3XP2loPsMIfhT8etDqLaIcf2wqF7Mr0+JtFMtFUgZHqMJa/mVC7xgTdytPockU4xrKpFnc8JRgZeLfIGGJrUcYkaUN6S5kQrrL56lDeHuX/Y7X1TfaNAgtrutDQ23pfB9Xi2c44sDwf3PrkmqZ4mq6KcT/6Ea6tBCcmuKLLBuJWE/MHNZEyBRtasnlrYoN6KxxzMpyMeY81WNcgvIpcfV597N5e10rvlndWsn3ls9BnFBPzCvFv8+SNO3IOmmO3Tq+BwRLJFrrhyPlE/XBAwAyyTpUnELXzKEzl8AnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/04/26 12:10 AM, Mark Brown wrote:
> Several of the mm selftests made use of /proc/pid/mem as part of their
> operation but we do not specify this in the config fragment for them, at
> least mkdirty and ksm_functional_tests have this requirement.
> 
> This has been working fine in practice since PROC_MEM_ALWAYS_FORCE was the
> default setting but commit 599bbba5a36f ("proc: make PROC_MEM_FORCE_PTRACE
> the Kconfig default") that is no longer the case, meaning that tests run
> on kernels built based on defconfigs have started having the new more
> restrictive default and failing. Add PROC_MEM_ALWAYS_FORCE to the config
> fragment for the mm selftests.
> 
> Thanks to Aishwarya TCV for spotting the issue and identifying the commit
> that introduced it.
> 
> Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  tools/testing/selftests/mm/config | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
> index 1dbe2b4558ab..06f78bd232e2 100644
> --- a/tools/testing/selftests/mm/config
> +++ b/tools/testing/selftests/mm/config
> @@ -13,3 +13,4 @@ CONFIG_PROFILING=y
>  CONFIG_UPROBES=y
>  CONFIG_MEMORY_FAILURE=y
>  CONFIG_HWPOISON_INJECT=m
> +CONFIG_PROC_MEM_ALWAYS_FORCE=y
> 
> ---
> base-commit: 599bbba5a36f6de57ab14c373c25881e2b5273f5
> change-id: 20260416-selftests-mm-proc-mem-always-force-5ce1b26022c2
> 
> Best regards,
> --  
> Mark Brown <broonie@kernel.org>
> 
> 


