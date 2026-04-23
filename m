Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F961F589D5
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D7C6B008A; Thu, 23 Apr 2026 09:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D7D6B008C; Thu, 23 Apr 2026 09:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53C3A6B0092; Thu, 23 Apr 2026 09:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46C696B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:41:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3319120169
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:40:59 +0000 (UTC)
X-FDA: 84689931438.02.86E624A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2FEBEA0004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:40:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSik5BHf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776951658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpflqOaOGrL8JV00OWy1jqmTkdoY4KmOrH9Ao1Oz3zQ=;
	b=nMDpL0IxLQ2fnWjYmWGO2EThnbpgKNnigyx1GDhx7+JBdXEJePd9ttWwNZ++5I7kIyub2X
	SzaIWS5B3TAKrVj7fHEmFaclraMPAy44JoDuc3BDGUTpHKpVAL7Q5NtVTHiWd09JuxZWyn
	W/XpYBQatIRPkHERgEtmcghg6VBGt+g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qSik5BHf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776951658; a=rsa-sha256;
	cv=none;
	b=S0NcmBlPn02jfqn1weXlV6rfa6mafshDkfo/yU0wMAplq0vGxt88ekIBbCt8dMb/Ft1Cyo
	kx9NPB1lYw6xDrg4FGMbYH1aRN6NIA5Gqc7FcSE772q0FBAQcae8Srhq3ax/8kZk1H5wVq
	pKkfb7gv8EzUrCOOa19nhM10EzgmSVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C1056013B;
	Thu, 23 Apr 2026 13:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B232FC2BCAF;
	Thu, 23 Apr 2026 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776951657;
	bh=kbWYQRsR8eQbjfcpNar2gN24mlB/zcQ4Jq7F4eLQ/Uc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qSik5BHfRphh2+WjtZepWBi4tvNmWs2K9X0HsY158a72I4wEXP/zDzX7OGztTjMID
	 YTBrg6eAyLBVPV0O56eE64aIInKUMiIIvDNoulwi1sNg4SWYfMQeupj5Ru47d1wVhq
	 7B8r6BfCsnNt8k51tLr27tGM6yZfyWSTmsTDzdBGoUP2vx96dwjAWyyzK02mdsMdE+
	 ElTqWsYVt6G+6JLMeL8Bf7pZc0O1Qk0LiEw82/HYfIg84XI3uDJCO9TxFYL9cHOU15
	 Zlkg4uwAUQ8KvPKE7TJlVop0cABYlqfZkWzYotm03+C3gZHyeroevKOf9fqsQPIlRb
	 N4F836PPel5pg==
Message-ID: <f6ca5592-9a5b-46bf-94ab-3d8a0e2ad996@kernel.org>
Date: Thu, 23 Apr 2026 15:40:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] selftests/mm: suppress compiler error in liburing
 check
To: Li Wang <wangli.ahau@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260422080446.26020-1-wangli.ahau@gmail.com>
 <20260422080446.26020-3-wangli.ahau@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260422080446.26020-3-wangli.ahau@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2FEBEA0004
X-Stat-Signature: s38i4xefmsrg7ptcbre7fgbk5y48hn5j
X-Rspam-User: 
X-HE-Tag: 1776951658-523515
X-HE-Meta: U2FsdGVkX19Kzuj2PN2JHofS1TylGybwzyUiLZCEojYfIIyb2Oo2dFHBFh8UPGEFoe4yusi48K0PIp76Dhg8pwtqGhDdJLTeoUzJ7xHBLUif9sr+GDD5e3F2LML26sk8v5nRQ5KFXFaUiQ+TM3dFVBwqK+JLWbPayDLnQ4XoH1o6tz/DWZnixDGR5B0aU5LqKo8/+enwXDknSKF3dyOsmx5Xx+iy0MWnqiLpOi9i5bBZ2df4GUndrfkx43A2BQ0zkBvSJ5bWtcD9UA6F0WChwRTITRcI9bdHReNI1tgMEQ8AkT7CqihMoECjxB1mEkfb3gZF6f2U15twTomAC0wiSoYxwNw2llDgtorhev3Bp4czu2ofterLPvoKgwH4Gnoaz2A3yh3tdjdRnOOCaxaE2RF2BfBtI2E/Yy4c/D/Tl5D2J7kqtiW09gameYPuCfnswdafRnaf+xLbtmVNg/qzkJ3xbfjrnE7+OTiVzXZjH65rk65iFjUCG2s8lzCma+fgvSskY8amu4uOAu4ws/Np9dh1eo3p4vAlG4z2Jkdm6oi6N/UB+EoY+nZZ3KNFmKL+UJGCWnFJMedKs6BOGOyYy2OAr+hsuSc/sRi6yrUHt5TlTXpYegIROBaN+fyBIsUYy43y7642f1pGdvLbfhoq2Jj6KrAzbEOMSpdbP1q7vbS4mz0ddOBWwatqMMgW7A2fSlXypcCrhI0jDepirQoy8IlPqpf601RAcGwD4QSBIsd+WOYQUOlFGQcoYNesCmbMm+4jL6nmAkPFI/IDwuqmMt/8JdGlu5xQoUxQrrOlyjOC+gxe+VClSh5cbxvikk2eiU/eDxc0thPAWBlDdJRM0SCYBS260t0tSBnFqOBMFN0CW9dfDGcjgNjGRdRcxLYM8ptuJ7a4z6u7yRAtDPm4lr9n95p0GWVUraI5jYNNHSQB1mjr3dz0olrfJe6qt43PEx05EbIJfZg3lDcLosL
 S+AUTkP1
 vzo3HHUJWknawM7qMUn8bOBXkrhkOUTNPRyaf/RWSREQjFhjq2zOspervKjGZkDqCyn6odq8RkF+9FxHWxQLBL9ci2PKdYgKyacoTjc3J6M4O69F9AkspNlqSBg7fLlhEvN1fD7lS5QKzTR/mNcf/4XJUDoa1EPqQDOQ1zuZncZTScsPiBBOpWru/SSQLwSNPYfKHIKQ8+N64kQ0fKNQT0u48DPg1grBJO5bOiIdzeJtUKfBf1FkGCiMRPZeEDIJ2u+MCMT+U5TQErZtEBJRDzIpCthqXuYu5xYtLGKu8Nbi3ug1As7W5sfNdRM9THNOE75ytOo4kax9i7U5Cb7lZ+jvke40KW3kNPSmHs0IknATWvPZGygFVsL4vIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 10:04, Li Wang wrote:
> When building the mm selftests on a system without liburing development
> headers, check_config.sh leaks a raw compiler error:
> 
>   /tmp/tmp.kIIOIqwe3n.c:2:10: fatal error: liburing.h: No such file or directory
>       2 | #include <liburing.h>
>         |          ^~~~~~~~~~~~
> 
> Since this is an expected failure during the configuration probe,
> redirect the compiler output to /dev/null to hide it.
> 
> And the build system prints a clear warning when this occurs:
> 
>   Warning: missing liburing support. Some tests will be skipped.
> 
> Because the user is properly notified about the missing dependency, the
> raw compiler error is redundant and only confuse users.
> 
> Additionally, update the Makefile to use $(Q) and $(call msg,...) for
> the check_config.sh execution. This aligns the probe with standard
> kbuild output formatting, providing a clean "CHK" message instead of
> printing the raw command during the build.
> 
> Signed-off-by: Li Wang <wangli.ahau@gmail.com>
> ---

Thanks!

Tested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

