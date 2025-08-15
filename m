Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFF6CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13096B0367; Fri, 15 Aug 2025 13:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAB66B0368; Fri, 15 Aug 2025 13:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27D46B0369; Fri, 15 Aug 2025 13:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 917D06B0367
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:46:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3059A82821
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:46:18 +0000 (UTC)
X-FDA: 83779720836.13.68B69AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C46B40003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:46:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755279976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJWE0fXapacd+gC8whLCJ/jKuWcD9pMQH4hrEj0P1qc=;
	b=6A21ddmHhIzbJHEHnv7gBUHxWtcX6iuoHuvDw0px6clSocs2gshNXTfRmoYqp7OxC+ftre
	Zo9F+BF0yBsl9Zm3HndgqTTWaFhTuV55e75zG8ZemcMfMJjZ76GuYpqAl58k+RnU6cGL09
	QFvoolQrcF7UDOjxmJzCT11C3kLVJug=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755279976; a=rsa-sha256;
	cv=none;
	b=D/DPRJJSFcoKxM5a/WFK2rFG70Z94xjn648cCDTbNBL9rx1raOeV0REJOyhiIlBtzQ8rQE
	wqgjqo0rjyGYdW53+w+XHkwM4b31L/CIlZmLLAfebfpncgceHNPaZzxKBQiRj2hjTdJwC8
	O3apOMjWeB5XbrSvOXQReor2r+k8zu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E047F613EE;
	Fri, 15 Aug 2025 17:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302C4C4CEEB;
	Fri, 15 Aug 2025 17:46:11 +0000 (UTC)
Date: Fri, 15 Aug 2025 18:46:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] kasan/hw-tags: introduce kasan.store_only option
Message-ID: <aJ9yYZyQtMHyS4n1@arm.com>
References: <20250813175335.3980268-1-yeoreum.yun@arm.com>
 <20250813175335.3980268-2-yeoreum.yun@arm.com>
 <aJ8WTyRJVznC9v4K@arm.com>
 <aJ9IdVsSxppYh2QC@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ9IdVsSxppYh2QC@e129823.arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9C46B40003
X-Stat-Signature: i1sjd53mawqhdrp56jks65byyd9mhskh
X-Rspam-User: 
X-HE-Tag: 1755279976-620349
X-HE-Meta: U2FsdGVkX1/EQ7JsLNwwdDiWKTtPIK6+U21f1FraXC+vhKkzvNpdFv3YGG9Cy46ttx2E8U3IeWgcAZfqByNfGbYe88ruOf5ap5bvemd0V4dlV+HzzMpdirtKzzP8yMtULOscBi10LGKqFP+5nUCpKEvkRk7fDoaWAxJZyW34P9eFFvqw+GiGSydb4zDiGNrFGS5RKQ6t35SZjckeiAG7kZTclNjR7X+RcuPNd5bFbJ17ABWQuV0uwCXn+Or5wR2lqZIQaoJQxsNr6SWJzy8ug3N4pFsXZOq9rcDk+X5fv1xB5MUCDxKME+bmN3IFYxHlwUhKcUG+BGYtQvIMe4cC7KjFcFm84iMkMTSS4P+plRgPRYsfFOE1+fzYiVmSUmPdOFA0bKSrlJlZ8K4vcjqFnWZ8J55tz3HK8o3KJaNFxAZmtOizrWcYza3vmPA4qB1fsf2q6apBijyWZfZ/cmlj4jDaEUUmPek6oRn5SxpIB2lx/cnJ1xNU9b4KfboZTFBv8El1jh2L4qUM9zPSCIHucFmPcPPq+sdgxnZoGinEeF+bm61q+gpY4gKbHzsQBvfjw6JX7P7zKrvpWhCLD+J5pej2N0nAlhVXI7pklAu7yj25JCFq8ipy41QkqMMGM0rwGXSuNKtGeCov3YVT8opzOp0//wG+EFtgGGnB0M7837twgZITuq9VAC/XyNyuFbofA6tMzhRrBCqLHgA110oTuVRNYXCyNeepmYjyEdtMuODV/s2tymCPScRfGhTU+EKFnpgskg4y6V+ap9fcO55gN4Qso/OXVHJlc6hA5mzu+eO6E2NuJ5UBpNoL1nh6rZ0dHXf5zKuQVae0qSamTEvzGuIloDi5/7hzYzGIzMQkQGLT7zjiK60H0xvwqldJh6azE2DyTECmklKDHDb8gOAdF7tRaanVu2x5ngyaJFfMgvPe1B+a0tgwZhLfnoGeLQkLdM2ibpTeKyVMa3QlVSV
 3I0NY1KL
 xGXuRCadUBLVunMslWNwMEnCmicZbkdAxKhfvppq3sOJEs8ar28D6r8L7cKthLc5seXYQQOQmyc88Ln9MQTQ/CACp6+0H/MB7lWVVZfk6eI0V2104dd26wNKL0f8wiHn+obvOO2Nt0NSeEP4eDE4PJl+t/5ns5VbVQrH5IyfC22oy02GqKbnVql98LNTONq1TRUA14NfCgTEqYIqZG9H9fmbX9u36+IpzLNSV16gWfZa3E1TPxZR5uUwbOolIm/cfxVv3wisKr+wxjyTH8VkPo4PO6vt+QTHNSh7+euxLWxmI13VpRRiY83BhkUkj1B3Zkb7r7DBFDvxYAROSut4ykXGQnVHJcFwcHMQduURL1rBsnjcQkvX/aZwjDN6TzxlAlMNugi+0eE+CyHf3sGb5YMBKq7NNQAkJ8JqK5Kz4+n9iSf/Sv6jVSp12BCJfzK+cewCvpFWeGt4NJFAPdRWDPP5Spg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 03:47:17PM +0100, Yeoreum Yun wrote:
> > If we do something like mte_enable_kernel_asymm(), that one doesn't
> > return any error, just fall back to the default mode.
> 
> But, in case of mte_enable_kernel_asymm() need return to
> change kasan_flag_write_only = false when it doesn't support which
> used in KASAN Kunit test.
> 
> If we don't return anything, when user set the write_only but HW doesn't
> support it, KUNIT test get failure since kasan_write_only_enabled()
> return true thou HW doesn't support it.

Ah, ok, if we need this for the kunit test. I haven't checked the last
patch.

-- 
Catalin

