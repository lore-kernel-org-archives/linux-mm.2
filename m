Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6A8DCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028DB6B008C; Wed, 13 May 2026 06:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4256B0092; Wed, 13 May 2026 06:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBE06B0093; Wed, 13 May 2026 06:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C74526B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:05:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DB151C06DD
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:05:57 +0000 (UTC)
X-FDA: 84761965554.07.3AD34D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 966F34000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:05:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egQzb8mj;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778666755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZaL0pGxLdHyPlRRzXNGaqCKIR0mmUZG/SbEWrd0Xlc=;
	b=Z3vdCpCOpxFV9lqTd/u3Ki3D8s10BQjDkmBeiRPIcjDsNSLUdoukphsCiNeRDV8jISoT/3
	+WGyqF/UtfsCVWOGlcko98oStGCa0q3fQHPNw4R5lVhlps54WPsYesMstTyHFfXbd2DhaF
	3bbcs1Yo5P/KIrm8ga20ZLegB0IPEuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778666755; a=rsa-sha256;
	cv=none;
	b=LtG/oK+407XIArtjUAwySMP6aEawyBLvh2qZn+cpPoFEZoYfYcXGX4rer/FVjsvzBtqLhd
	pi6+C636Ak4wyrpNeeYCEIt/UeWN6DPmGLu4aIRs3GvfSXsHpaQT2JpdHM8fbqxl5lB7Y6
	nyKbXn958AKNSbMIAEDQMZTtfpjiwew=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egQzb8mj;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4BDF406F8;
	Wed, 13 May 2026 10:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37EEC2BCB7;
	Wed, 13 May 2026 10:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778666754;
	bh=xmU4wBziLf70Ok0B+UMn+MM2UYmio1xuQY4yM+as3/g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=egQzb8mjFyNnn+lIWZTsTJk4rD/PWO+MJWaS96RqxXXY3WhdlXpL5XJE8DyXkm75C
	 6SGAhgCDmZxl6qVmCpsXrYnYY/z7JQ2CHa2ytHUJ4jP3/xmPY6ntSuAsKfi/EhoNvx
	 /JavDPD/oBAoCq+smnpFtH/vMULVmp4kERvnftM8RI4aX/EE8fu8hs2nVp1Szg9H3T
	 jcTAbdhviP+Qp6Okve8J1TZgEcWLI0rncY/SrPdmFroq/anunCsQAm2bGvlDCfNied
	 yUTGqSW3LHRtF6/LvgPt1kv1hnFRxf8w95DxLZeOgblLj8oJwdkmGNuWlsl25too9a
	 Do2yrfe7UpXoQ==
Message-ID: <9e302879-d218-4257-9e2b-e468564b89ea@kernel.org>
Date: Wed, 13 May 2026 12:05:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: Fix incorrect mmap() error handling with
 NULL instead of MAP_FAILED
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Dev Jain <dev.jain@arm.com>
References: <20260513095609.789935-1-lihongfu@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513095609.789935-1-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 966F34000C
X-Rspam-User: 
X-Stat-Signature: ekgpiawj4rfi1wox93dgbhr3zz4tib4j
X-HE-Tag: 1778666755-749271
X-HE-Meta: U2FsdGVkX1+/LY6SAcUPeZYaYy2GIeqoEkkcvUpCzF4egbBdHGel1b76TlQekFOvg8THyDmq7ASwpHSSzmzfzczQIzdlV6uYAtSp6zUhtrl1qggfdCJovmL2Km5mQHW6zkAW0LMjsIM3qUkV2wWxQw2d8cot9OENEEQYF6Yts8QgbyzmGiY0ExVypVhaeWLdE4e7oDCFXEcfsQ1/fm0GC88nyMS2HezWI1J29MShVjiOuYviHLVR7Ca/VMCmMzV5kDMPmKHXPN+nRiYSXFFOGsyPE86gckupFI8B54yH2zyp+y8+tzvInjEHgTzQbZzhqjMvTvB3dLCvRLdZQBkh3RHMphJTFtOp1756LqfcRdyE+vGpdbL+tH/JhQt5/J/rYC8fLMQtmiKry6FJKc9wsElZME/1O+gSjV5b2KKUjOPVTYYd820ZnSj8wxeu6qwt6IvWgeRFbi6WGovfJ7R0NfjQe/uhx21Gy5BpT0M8Kv3fLJw42Vo84uZSE00dTLdnL/1zAg1iBrDteC6O4i2EZvkWiW3L49x7fZ1jEFDlYwPcnDD6VGgYlevpS8qGwobIF+PQVSedNeTporgi99yDayElVOVihyiBv7ZHu5xmIcEtHhrY1JSjfZ4hKqwdPsP4bVpTdGJWccTXFHQfNmCjfyDiAQVwDEffI2Eg4DmcQIawkZXBr0FcAz58OMW4GHb3suNzvHNKEEvCTKC74Jl39HGpqgh97QK3k51W5fr9CEn7+toCOZXWYoh4p2khYF9yO6Iz34eKDOw1fkY5erAR/fRfij9w99wqtm3NAsQw8Yc/DunWxI7kVkH9buNA8ENFwdPoPhIXhfPtwe7qoC0LUyic7zFWWOkPrukbHYXsAxKwYAvAz+wtNxcP0rAqySZL5Y54DwOBlLE0UnV+IfLF9IEaIBpa+Xlaw+9FRp9rGMYgkB/qzMdr0c0IPI/0FNUwmNkZgwG+9D0PfPjcydt
 alorPT3j
 hQR1dcyyGuWLk5gXQCnSoXDPnvDYu91UwDdGfz9s9+htERB8em3LyDTvvV9AQgilQG/v7NgBAj+lVEWa9FuYrzkxPu/ro9467xrMiYJWWtf4N8/iYyY30f0Ys6CdxmNYSyPkp/sUistC92QwmqhO2Hkhi2qGt9FUbLtwgagpVrKeqR5N1ja/+jLniCyqAARsrUQLgAar8vmkvPxOnWss3r25JHaaOy8Yu6Jqk4yyx77zaRLudnszaQXCFLJWlLiqIvsPw48ig25Au1TxzU1YNwYpbHj3nBLJox7EEL6KQ9aztoxZRhdkW6gUOjbFzf3+s+Zn13BxYh2BvlsQvjKDV6bejyuQUKuydTvN73BH2Uh3yyqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 11:56, Hongfu Li wrote:
> mmap() returns MAP_FAILED, which is defined as (void *)-1, on error,
> not NULL.  Several selftests incorrectly check the return value of
> mmap() using !ptr or ptr == NULL, which would erroneously treat
> MAP_FAILED as a valid pointer since MAP_FAILED is non-zero and
> non-NULL.  This can lead to segfaults when mmap() actually fails
> under memory pressure.

Well, your patch also adds more checks where we previously didn't have any checks?

> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
> v2:
> - Add missing mmap() return value checks in pkey_sighandler_tests.c
>   and protection_keys.c
> ---

[...]

> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index 2085982dba69..580bf1668c71 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -1217,6 +1217,7 @@ static void arch_force_pkey_reg_init(void)
>  	 * doing the XSAVE size enumeration dance.
>  	 */
>  	buf = mmap(NULL, 1*MB, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> +	pkey_assert(buf != (void *)-1);

What's the reason for not using MAP_FAILED?

-- 
Cheers,

David

