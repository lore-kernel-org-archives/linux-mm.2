Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB5C2CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268AD8E0045; Fri, 14 Nov 2025 12:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240C68E0010; Fri, 14 Nov 2025 12:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156888E0045; Fri, 14 Nov 2025 12:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 001C28E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:30:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7E4BB99CC
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:30:40 +0000 (UTC)
X-FDA: 84109902240.15.6A98DCF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D43CA4001E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:30:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M+xmio9Z;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763141438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/ZAkhA8QTisGRypHsicpVYj5kCwYkYd2pPBJbAZpVM=;
	b=u++8ntU1utxzljo4FRct+3+vjMmrKlFihh4ZT+wzVTld5Q46cZTbzOjHuMKuGTSTsYgawG
	QTlnOYJk80NnOUM6xfSgqddrXbjCPPmTD/NXFfsJU0FQIZCErW/fffgorG69Jtq5zgRnhN
	SA3tug6dYTZpcpeHcpcwsLX1CAzkkWY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M+xmio9Z;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763141438; a=rsa-sha256;
	cv=none;
	b=ZM9A778z5pXGheEV9IbvZS+FwstRmKvuWy22kPCjaBdJRO767ZuvKSdvydxGesRPbXopFw
	6Ir8O2hTznLtNF8kimMeYWtWCMEM7OibDUM2Wy0zOOJkGNi+1QN/K5Httcm5jP/KXa5b70
	g93NpGRf/a1n12lRITr914o7mrvlSQI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BFEC60188;
	Fri, 14 Nov 2025 17:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7BFC4CEF5;
	Fri, 14 Nov 2025 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763141437;
	bh=9zJM61pEY/RyS31C8d8lddjHkoR9XcjIF+H2kqS6aoM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=M+xmio9ZvLQQd4tOIMuM4bh1qihQHHKp/4ETopDOztabprihCxZChC5JczUq9nZ0B
	 23AFwn+qdcRhKQoXL3AWMaov3UlhBZxA1dX/ebuVXm1GPp6tyZye54Ipa/PPO57vqO
	 PCU4ziQPWSL3HRcXdMSoGku5ChEqCo5PQWfGEJCBbZdyZkd8tEKy1MK8CMayC3IS7b
	 neffwZhHhYqjnU8m16l2qfyuzmI7m1DY1px4/WxeYUd3MTKdYPussKaSgptgnzd733
	 1R9IjHosNiWp2eYcV/lJsKN/gzvxg5Y4KJOdPE+aXmX7aomi2u0Pbf9qeD9VRyNGzC
	 PT3BN+diQgj+w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 10/13] kho: Allow kexec load before KHO finalization
In-Reply-To: <20251114155358.2884014-11-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:55 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-11-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 18:30:34 +0100
Message-ID: <mafs04iqw7c91.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D43CA4001E
X-Stat-Signature: 3xdd8hsbte53gs17knjhrq49ene9qctg
X-Rspam-User: 
X-HE-Tag: 1763141438-904933
X-HE-Meta: U2FsdGVkX1/uqN/4rBEohXzRwK/Ry0sAYkYmFGlzz7yMiBDvHuefjddvRJx7dFge6y/KUG3jc/uCEQCa5reljB5ZKtWr/4lE7oWBMxOthuscrVo2Z4FGeCCuFrJkKNlrgrp/1zCoU40KQk5lAdADvOdidWdoXfgRCg0xm3k6Ck/yxa8W1PgGE36uqSnW6tv6+TnBOcb6lWO0Rk02pF3lEa0315Tv31CrcQ2Ebxr1WbBDteeH6D/GGcha53G2MhPf/jsIm1GaVeIDeBDr0JRyHM3AontX7ATQJIFPeUxI7fzvQoFoqjVOFOdYpTbIu8n4R1BL1Vd2Nf9W1nOGKmBMdu+CjEevPM04NFa4+5k1iSn5pGF5Yv7BlIKvNAcpsDM42h6iSKQ6cQVNHUW9KHzJPp6TquBRusRf+FK7S2o7qnTiEHTSCFISZbugm356HiE2XKfhiQrI4XG1s3QWNw271KXWL31ighFlNrgT5bhEOcbL64/PGIFOSXig5d6jZS9GWPc6SA9/R+F250BGV4eDlYB8Oh4GSJxwNa2GtvKKeH8mzxbt7mA4e8nc83GOJieHtDdaFDsQcP0OUXyeWMthXSKQfy25Be94KE3ljPQyR38TgvRWHq5WETI2+2wen7ZU5hdxP2fFGsZnMPwNOgy7WZGZ/W2Yi5BA0zGvmvx2JlT2eAeCGl6eMVGZel1zzNW0ESqk1zqhDhRLyaMnsFuMUA9CcFlNLZQzePgMrscvXFPKKKL9DUQWe462gvMI/0GL9qhPWmIRKxq5GSXHLBQw/WaqCsXX6wyaYjsfmf3V862mCtUMREpejRwjb2E99N9XK659zML5y5aqH3wXR3OggHJ/yuXhDAMEmN6qXaiHsY6E9mKsEcN9JXJinhzfYovLkCiZpOQIa9vQAnbe9oZcqS7OOp5DPU6UjTxpMLIDpNf9VmhmqEF2zfTdIYvuvv4SY+e1atKcjeq8TN2pkMC
 YKdvPcu1
 GPGNTo8NM5hjaNcZn34HnYtIMLmJy7KDejg4LDhjaJcoFW2uvT1rzxyILbBuXfKiai0qrUrFRQ/vAefaBncJuBTWiASnKB8XDk0wCbMWl2/MYn2dJwh96PfQ1TPCXjA6Ba3+TWOx/KllAsIPS705RQvn8JWyrMWuwhbb1hULsBQ1ZgEjauskATdmFH/yE395G9FjOM8iFpLEEyWT900GG4YrECg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, kho_fill_kimage() checks kho_out.finalized and returns
> early if KHO is not yet finalized. This enforces a strict ordering where
> userspace must finalize KHO *before* loading the kexec image.
>
> This is restrictive, as standard workflows often involve loading the
> target kernel early in the lifecycle and finalizing the state (FDT)
> only immediately before the reboot.
>
> Since the KHO FDT resides at a physical address allocated during boot
> (kho_init), its location is stable. We can attach this stable address
> to the kimage regardless of whether the content has been finalized yet.
>
> Relax the check to only require kho_enable, allowing kexec_file_load
> to proceed at any time.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

