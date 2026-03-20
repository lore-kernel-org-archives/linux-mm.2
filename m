Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A20108B8E7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB966B0093; Fri, 20 Mar 2026 06:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4606B0096; Fri, 20 Mar 2026 06:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4086B0095; Fri, 20 Mar 2026 06:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 231726B008C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:04:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D48CCB4D26
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:34 +0000 (UTC)
X-FDA: 84566006868.02.D85043C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 36AE38000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnKdhq7Z;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774001073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkaK0jp8AURaVjtoPDIt3ra4kvTLcpvtqoz14lJCvvA=;
	b=PQUILYZYjqPJFYniQwNdXQIKW8blLVVxxX8U9TcfrlTlUwTlEO1rAOjc0oSz+lNrnfYylR
	wXBmbOMCwKlR7JqXEFlvMwqXLH+LLLw4NPnySw/EoGpQwRF1+U9ua7iKan0N1HkwUf92vn
	jdFNy0ZWMIH/Sq2p7v7vQLoq3Udz42c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnKdhq7Z;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774001073; a=rsa-sha256;
	cv=none;
	b=Na57UIbxNwUc95V1UY555t9BQlhNVrebtUdyrKODABqTJAKMHBfChIvZfEp6PrE0jMNFKN
	X+LJaR/As0sVBzSrIQdjrZNt0jXCFCU5ikTkTWJx1luJjBT7nSo1UWXEZAUR4Jkxw4YHCl
	RUBQb24/DVvonnU0u+sk+rMd59m3EpQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 47B3A43616;
	Fri, 20 Mar 2026 10:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681BBC4CEF7;
	Fri, 20 Mar 2026 10:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774001072;
	bh=LDVybf42Q2KTdg7Be2F4XoTTGe+eeaDsULIItrWRECs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qnKdhq7ZC+G68GWkOy0XtdMNfq+cE1+I4PhfcucyCKNZDbeR4nyhl2iS+k+EuZLxH
	 Tu0BPdwCMZe1DRvY5CvHPb4F80ALcXQJ2hs7xWpNsqDWTVSG5YMnUCz0SSilqQGf/T
	 +E62zCUu83rI6F7u/V9+tRjeiyansR+NEdfraVWXwdHtd4w/KmxKP/Ia2cKaUQIZ/C
	 zn+l0gO/cBBykGd/2iQS51w4USoW3jqJetOhIYxn5XDuEa3nCpNVifiBhe+OH3nLYb
	 hiDfHH0M8JCruDUFwIAwY2VLXBg11ol4LV1f7r6Y1+ZlWZodxeGxr61rVdNsrZx7b8
	 sxQvA/ku8tqOw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com,  rppt@kernel.org,  pratyush@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 2/3] mm/memfd_luo: remove unnecessary memset in
 zero-size memfd path
In-Reply-To: <20260319012845.29570-3-duanchenghao@kylinos.cn> (Chenghao Duan's
	message of "Thu, 19 Mar 2026 09:28:44 +0800")
References: <20260319012845.29570-1-duanchenghao@kylinos.cn>
	<20260319012845.29570-3-duanchenghao@kylinos.cn>
Date: Fri, 20 Mar 2026 10:04:28 +0000
Message-ID: <2vxzeclebyvn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ssifppj3qzz1ho6i381axtzidooekdah
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 36AE38000E
X-HE-Tag: 1774001073-348387
X-HE-Meta: U2FsdGVkX18fDIOFOsWtCkKip9w/e1VEXuTZlMlhXY4DcJ0khtyziEc0DphamKrICPborruY0w9IxctzL4a/3MTON+Re3ui9Bs1KcGfHw2FY1Eoh2DEF9NVqPbMCS0rVN8fV4udQmSuV3SOhw/FzssQt63Uy66AuKWhcrbmAzSBXtKezIzFZan5IcnvmGKsXxBWCMOYouRZAqC6YifYETOwTweST3Bucx7hYl1zwLbFD9VqC+Bho7udt3x/P9FyWE6/bVc4CT7GIsp/6Dl1jzGOEhfTNPlzxtKxMZ4VAkg/kLkEwqWV7umy4crrniknXNS9bo69Oz3tsUlyNiMGVv91Ny8ekejEP6bbbezbaqTMh6xREA+rRow8tRBEq9vUm9NJVwmFQLJhnzb4KbYVFBZpmlVbbuwbgOYi2ih+L3IR4mzOxyA7b3cqBVDRja399ZNy0B49FjWNWaJtU2hRasFeGMlf4710fEAqcSLDNjPhMxMMEy7nb4fmzR+QdAT/pBV9aZfCmLsZ3ARcLhKvKaGEiUACu7OyhhwnQygW6Ie0rd2o4kdWiyOXxH77TG4IybLqMj8mwVGqHsC56+KSzweNOaCyoF8TIjsT8djjs3UMXgHI+1DNAJgl79v6pjmP9rnm7NGH37dXfKRkHSbCxeCcT2r3N7pPAZIIpjHIe0DlOHcTZpTPCHJ8u8NtIeYZ3YBpDl2I9NdT0sZhrK9+XVKeeqFHN+rFWHe5u8fAgRj4ctqEJi5sBY/mLmrnvuvC4NSlVQ4s4CvJ2xX3NKCtCsDmCKth8ecB3TVNgWWG5NrTSdm2zxKcP+LBKr6IVWBhCwufuu61vxsAXsv0VHzg4em4O/700K9EqiKV552dPl4jt8rucH8GDbj/zSb6CAG6De7bOaYOVdTTWeLC06lDIGpTBfxquecxyOndo8lBzYVj8CzE6VSbl626jEGVnQhYgvPoIAfUWA5XA1CxnYzZ
 15pb56Af
 HWa7d/QSFpcEzD2Ot+aDI45TcyUz3sSHa1jZsqaHKhL4As0SdT7jYLpdm00FoIoJFNXQ6ADuqmI6kj/8uJUDdknOEG/oMBJb99j0WFLOSmHK4gi7SFLV7VnKO57aJpdfeaXK6bS2nf0PEVED11BvaEO1dek7gSr8hpvEEfN9B2UU5gzwngBVPwFRPKYK1Ghw77zwxJ2vHVa+lTfZn4xwPq5xRrlVYpKNRlgYJT8KBCyUNKNEbZ5L3+9m1Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19 2026, Chenghao Duan wrote:

> The memset(kho_vmalloc, 0, sizeof(*kho_vmalloc)) call in the zero-size
> file handling path is unnecessary because the allocation of the ser
> structure already uses the __GFP_ZERO flag, ensuring the memory is
> already zero-initialized.
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

