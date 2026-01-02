Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619FDFA3758
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 20:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7846B0005; Fri,  2 Jan 2026 15:17:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265B76B0089; Fri,  2 Jan 2026 15:17:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171706B008A; Fri,  2 Jan 2026 15:17:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06A826B0005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:17:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B59C13C1DC
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 20:17:38 +0000 (UTC)
X-FDA: 84288134196.30.C518C76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C4918C0005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 20:17:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RyfEeod2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767385056; a=rsa-sha256;
	cv=none;
	b=ul2mwWb6zW5UqetkzFo8SQVbspCk/MvdaLHDbbxUevWhLHrIqSzj/sQJB32zdoBB/s4o0E
	/IGnlTB1DfaTpMNCM9jpqZio/bDGAtj/LE8cPS91U7DrhCXHurzPgQATiPllgcm8yZNR5F
	pnj7WceASBFoi1ixLBUc9p6nWmOeUhI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RyfEeod2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767385056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LynvHTHzFXhbeyMyi2dOf9W44B6h2kWXWJq6csDIFCU=;
	b=DIgl/Ggai6woi5no6b8ihLFXcEpG7v73lg0MmL6rvEX/caFMt7JeZeqBDT2o/A37us0Y9p
	6iemt/DTE0YSkZsFlNkAvutzRrAiux0KyDIyWrEvjV7opkk6UdVrfFCVD4vcApDmhnJK5l
	Ook4MbxC0D1Gr7FeX9ct2YOSS5qk+CA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A08464171F;
	Fri,  2 Jan 2026 20:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BB1C116B1;
	Fri,  2 Jan 2026 20:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767385055;
	bh=y+x3jWafn0ySZoOf7SO1BpFsnu5XwS14IRNA2tA5RQc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=RyfEeod24/yZKCI7D+ni5GF12w0rIvHvu7Zs02atNyZbktGxXgW3DVO3n3l4K5k8+
	 ncwOjqZ6tPJjlJZ4FYteSFrzIcV4VLhljCGBJZUcRi0bmPZpoxldXzI0N7GBO3I8Xw
	 8+SJPE27uWSTXEomzX7o709uNxXWH1aF7mfAQORru7cIv34/gwVsawVxwLHfBeEDSA
	 vf2x0q6d5TfIJU7MATctmxT0fjERG0+PcU79NmvH5cnV9MQi58XyeD95HBz2RzMkOk
	 cS9VvQnArGi2uDfRNahvHvUdgEWgjPh0INnV2au9NzYMDtMQCOsZsEtpPhP6FR8mAm
	 Nb0Ifm8fMT8UQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] kexec: history: track previous kernel version
In-Reply-To: <20260102-kho-v2-1-1747b1a3a1d6@debian.org> (Breno Leitao's
	message of "Fri, 02 Jan 2026 06:53:23 -0800")
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
	<20260102-kho-v2-1-1747b1a3a1d6@debian.org>
Date: Fri, 02 Jan 2026 21:17:27 +0100
Message-ID: <86secn7ors.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C4918C0005
X-Stat-Signature: fzjhrqcu1668g8xh59moz5ipqt3qury9
X-HE-Tag: 1767385056-704440
X-HE-Meta: U2FsdGVkX1+f1sSxdRrGYchFN5bcDvF6vkEJOl7CuM7Gbi3WByeK9CGTkLhTvyMPrIoVrwGgvK/o/BI7FGxOlwaedNasfJnsWnn+V4WEMrpyi0+oBDCUK1Rs/RHUd9nUeCgKzA1GE76uvY9AdftL9rG7epqPpQhNzTcV7ZZ8/5ZeRNG+rfwKWRgLTQpShHhbSx4pmFzfqFLokqSP+g8WtE0mQpGcYRwvfQbURPmqRqwkOSbykjHhP8uUv9CAR1vbV8xQO+Df5fFSC8FynXH2CUZ9svdwEFZ3qCgAoCMVAWt0UMv7mPL8sIOnYvGbaWsrFTcNFFBjA322itHf/yFEfYCOHgm8FVhp6jGaaf82geD5+VHSP+kVzpJor90w9fz0KKu+jZfGzgT5LKYC58zzW8FrBWTjmWoL3LHajcLaXMppz9TOQ+lLeByZmzqWgnRlIwIxW0xXoDYaCRIK7xCNcfeCbA8sZ5Vziucz0WDRb1capKsbYJWa/JdRC484zRIT6Z55OVUz67s8S4JAcDxbTsZOsvsWlCqnSH7BIp/5++NCXrvSF7Ip3kKtKoqXdMg7tSNCP8iEFwHghHkQaborFvyFydLWX/S+FWMF8jpXa/lZaE3WMFJTEh3paHzX36Aup+RybOndqEmr76bRz9RmJYrEUXF65KIND8CuluTg1UPJ09MiP4JJrtAkl93R+xUIj5HHNwtKISNx0P+AON4ZjoTFge5wu97eB4ki4Z10xrtmdwEWoPogmmE8volzt+wxdEUWV3PznbgQ3t7PXxZWzhixuqkIoejgVDng7boa/D8Ni2PFpNLWjDnlcp/IZUY8Chfx1WCBAQHoqe3B1GZ2GWqaMJ/V2xeuBujr3P7SntwVwEqaYcl17N+9naX08bxtK/DpZN/IHB9iDzbhlySrDO3b6lDL0JLAd06dyLr7wn9jU23xApUgKwjhFonZDICF/L9SuihABDlwDJXTkaQ
 Mf6nRq9D
 Bj1K4N0DBoetqZwx7KAeoKOxxEmQX15dBwrNwPuyNm9rce/Vlbm0WjnMgZ51OkJS5eryUfCVXSRXOyQNulv2ajU9VUcMjQUDnT3+FPaveWg9Gx9JenT0TC3nDMi40gM6Kl9pBo0QaFYkORaRMDTx5Vk60v/5ZfTL30eviXW+W0LbjTHiemJfp5t0d7Li32FYLFGGO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Subject: [PATCH v2 1/2] kexec: history: track previous kernel version

Nit: please use the prefix "kho: " for KHO patches.

On Fri, Jan 02 2026, Breno Leitao wrote:

> Add CONFIG_KEXEC_HISTORY to store and display the kernel version from
> the previous kexec boot.
>
> When enabled, the current kernel's release string is saved to the
> "previous-release" property in the KHO device tree before kexec. On
> the next boot, if this property exists, the previous kernel version
> is retrieved and printed during early boot.
>
> This helps diagnose bugs that only manifest when kexecing from
> specific kernel versions, making it easier to correlate crashes with
> the kernel that initiated the kexec.

Why can't you use journalctl to figure out which kernel was running
previously?

For example, you can do:

	$ journalctl --list-boots
	-2 a1d93be939b64ac4b7b26aa003bfdb93 Wed 2025-12-24 21:34:22 CET  Thu 2025-12-25 02:04:07 CET
	-1 dbbedcf8fff54d5990c6f2a6399cfce1 Fri 2025-12-26 11:46:23 CET  Fri 2025-12-26 11:46:54 CET
	 0 d002d51c28e748d9a7c6c8cdd391aa73 Fri 2025-12-26 17:40:52 CET  Fri 2026-01-02 21:12:09 CET
	[...]

	$ journalctl -k -b -1

This will show you the full logs of the previous boot, or the one
before, and so on. And when you're debugging, you'd likely want to view
previous boot logs anyway.

Everything you add to the KHO FDT is ABI. While we do have some
flexibility in changing the ABI, I'd rather not add something that can
easily be queried by existing userspace tools.

>
> Disabled by default to avoid overhead for users who don't need this
> information.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
[...]

-- 
Regards,
Pratyush Yadav

