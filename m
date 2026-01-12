Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC48CF45C8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600306B0005; Mon, 12 Jan 2026 14:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EAF86B0088; Mon, 12 Jan 2026 14:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501046B0089; Mon, 12 Jan 2026 14:52:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2A36B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:52:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5923BDE6B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:52:20 +0000 (UTC)
X-FDA: 84324358440.16.0A0E96B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E7DD640002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:52:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h3T7yleD;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768247539; a=rsa-sha256;
	cv=none;
	b=KSfdUBjLyz29KKIpHO6cRwnd+tWmhNabQz+Wbdve3Gyqph3iVWRih/J8Fu235IWyaL4Htj
	I2vpif/AxgND7e71t9k0nKbBHXQuM6ytIRFw/SbIq/6HwAj+tKQ902wGvkJpafdGcMhfh6
	jSkJXMJteRq2HuhvZsVl8MMcWbdgPx4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h3T7yleD;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768247539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hueCQrIJ2BPfFh2VZjBLO+V9xiuIzAYcQJbxCDBVEYY=;
	b=gId/Um0tTerEQ/UdkfehlwRI0r2uHFx5TruVVTENXuC1sVf2WBZaylxnb7nrudVHY4R9Im
	XxZf4KyzAoX54FwUZaWUGpa/e/3KIl04ZUUrN6IMiHvL74/TgWXo0X2xoULnBUPg8Ihgin
	JFjKQZPSykK0rDZ6FUz1rFiNB1bv6eg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8732444284;
	Mon, 12 Jan 2026 19:52:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC53C19422;
	Mon, 12 Jan 2026 19:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768247537;
	bh=fgj6BnpZP0mq/BZzAj9yNQ2clZzsLqxwm5wCzASP7xA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h3T7yleDxgR8/TRdeqFNkgakqO+XXW3YOWE+bpGhvbAP3f+JTyn02RlAyO6PPWzWA
	 AG0kZJ1cpe1IafbJTADNLxNR7AvHOP5EDY6dwhygnZ0tLp1Ag/f9wAoP1ozGf3NXi/
	 XJgJ9qY+rib9SNX8dyBgBCbhVaQTzIGVE4EwueaASyKOEOcTqR3nH77EbwHMqBJ0ND
	 DjHMGC1m4hdGQ8PaoCGctiGJB+vOXTgUPFspycKSp/ax5ux7mjR9HNu55xF/qZJB6y
	 u2qggj5lH3nvrTFl8fsOrCz84UDRzpujzETNJyG5peWBRTYkeZXRg1PvLQeUIGwXgh
	 2HxfDYjhrugrg==
Message-ID: <ee0bbcde-612b-4a53-aa2a-bc3f60302408@kernel.org>
Date: Mon, 12 Jan 2026 20:52:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: Li Zhe <lizhe.67@bytedance.com>, muchun.song@linux.dev
Cc: akpm@linux-foundation.org, fvdl@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, osalvador@suse.de, mjguzik@gmail.com, mhocko@suse.com,
 joao.m.martins@oracle.com, ankur.a.arora@oracle.com, raghavendra.kt@amd.com
References: <1981A332-0585-49AB-9ADE-99FA2FB32DD4@linux.dev>
 <20260112112728.94590-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260112112728.94590-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o8maiw7ibxpizbz1zgr7b85pncir5869
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E7DD640002
X-Rspam-User: 
X-HE-Tag: 1768247538-688486
X-HE-Meta: U2FsdGVkX18vhzZ8SNpMLIn6bKnpbivTKxkd9Xn4qubNoFXQeDKivRbiBrxYt9j1Flx2GhLy0PH/LGsrHLPztv3ou12jqUrfVbJb0acs6mRDucNgqfJbY8H7cw8F7e008Pr5KiP6jscXE7VLPhvgE304M2FRlypyyX3CcZaF5gEl1X+sSQiSGOgq2lUYcq+aFUfv1FcXiHnlowW8DB2MS6FU9MelJVMrL+0Fqrq9PirG8muy0BIvlAh4aI1o3PTH2/yyxVB5iUgefrdeU5CSeEcP9L1ZogriUNsyZZOb9l6Eij5W15kNCvopReVRaawWNmQpTJVYY+a6d61E3FI1VBlYua2Eiw0ntu1tgkJA8i2WZL4gXUX9iUQoptWAlTvLa7pAOmQiupkoJNAtyYpJ6YjkQsO7Zi/bY04W+jg7/WjeTPz+CSscbb9jEkcYY3CiPSJCHZVNoKzj1Aur0737lExrnoY0xpXhBUYR/hYUzqTOkRz6DRzEZdN2Csgh4HdxnqHKFNx4YdB1RII8cy9H5r5tGsgYjwdqd9aGnjaWOq76elEzGmZTk4DVdioJ87voi/RoIhx7M0JdSBqwegc9hiQiazj6SJz+T6FcPwAZAbnKlrhlJwEbr1VPI92jpuw/JQh98muXFWpZRFIJsWKeDya8VZt9bBRAs2cjOXFEwqy79cptXR+EZhlMxpoJV8hAR3gXjm9kzEc9F4KLnz1VHQlIvXbBA9V5qz4SvARQRGLhOCvEASD1RNg+8CTnnfoocDVufSVkjVOUCtwXrIz1vcUj08xnE2KUgh8ZqOgaKXWBDuuLVu5pCEG+dGHa4XN+Gxu0iO1eWlXFcVQmDHesNikKdJ+A813LU+S+alMP4vBEspq9iQrBF2wl2k9CaeP7yHw4ebzyl7qn+i/mw90JpHv3+H7bVzg9YfwdM2KSvopkwL8PjxgsABEJIuHX5trjcO2uq0fUmxUHZ/EqCFq
 rkRhHJFp
 RUanUX02CyJK48815D34m+ClKspABOHkUEQMC+xUYwtRosokAcABfbfr0Mb+Vi5MZsgw+dC4AHTrQcV1eL0nW1YEavkEm8jRoWSNdIgEHV+qOAPuscuETktfSYxjD31E1GUOybs3f6HtrafHEXxmMHVzccXCZIDNDEJWERPPqw9nwL88k8wz9jWTGlOVjiyuVzjsL1p9ilMu6wYCXhwTQhB3q6Pu1rsw0ZMbLIg2575Puuf4IIpJ1Bj38Ost9AFyqA6k92zz+AL4zif6M+WgxVO2qcV60Yil5O9Pb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> As for concern (4), I believe it is orthogonal to this patchset, and
> the cover letter already contains a performance comparison that
> demonstrates the additional benefit.
> 
>> I did see some comments in [1] about QEMU supporting user-mode
>> parallel zero-page operations; I’m just not sure what the current
>> state of that support looks like, or what the corresponding benchmark
>> numbers are.
> 
> As noted above, QEMU already employs a parallel page-touch mechanism,
> yet the elapsed time remains noticeable. I am not deeply familiar with
> QEMU; please correct me if I am mistaken.

I implemented some part of the parallel preallocation support in QEMU.

With QEMU, you can specify the number of threads and even specify the 
NUMA-placement of these threads. So you can pretty much fine-tune that 
for an environment.

You still pre-zero all hugetlb pages at VM startup time, just in 
parallel though. So you pay some price at APP startup time.

If you know that you will run such a VM (or something else) later, you 
could pre-zero the memory from user space by using a hugetlb-backed file 
and supplying that to QEMU as memory backend for the VM. Then, you can 
start your VM without any pre-zeroing.

I guess that approach should work universally. Of course, there are 
limitations, as you would have to know how much memory an app needs, and 
have a way to supply that memory in form of a file to that app.

-- 
Cheers

David

