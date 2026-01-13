Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B4F3D29DF3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE7E6B0089; Tue, 13 Jan 2026 04:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C622E6B008A; Tue, 13 Jan 2026 04:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F8E6B008C; Tue, 13 Jan 2026 04:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAC156B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:42:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69AFCB7014
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:42:44 +0000 (UTC)
X-FDA: 84326451048.14.25FE9CA
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id E109C160004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:42:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=X+tPcfdi;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768297362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXnkmMg2/oAZnCbNIiqow5nAIHLg3mz3Z2alr4+kgjQ=;
	b=iHQNxOXYBiHd+xSKJB2/udnmY6TGeKHFBbWq4fB5oiUBkL5ZaRD0Nv5VGPCGplR2LxXKup
	g2XyHnlJc+PfhtI2h58Jk4VxUNFOoZAlHe9CqqO1dmrjhZkAzXX/ey/Xx16OQhACsP8uAN
	WC33XLDzkVvBCf74d2yhGKYdsqnWfJQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=X+tPcfdi;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768297362; a=rsa-sha256;
	cv=none;
	b=GBA5P3PU1GiVowSU1ntD/aiGAiNcWUWUciFTJxnEuItHMhpZ9XGlO2eiUsHF6kEIgbIS4r
	olKNm0sr3fZZ6C/mYp/Zqm3CN8ITKMjD2uUE0QWlpbRcyg8H4tSgZTwtWp5+ZbvS+E1wnR
	qapfuem2OKzh/2VL02rpQq1Wjiy9R4E=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4492C40E0028;
	Tue, 13 Jan 2026 09:42:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1WBtjryyNfLT; Tue, 13 Jan 2026 09:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768297352; bh=qXnkmMg2/oAZnCbNIiqow5nAIHLg3mz3Z2alr4+kgjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X+tPcfdi8SlgWzUBumbgcHC+XGGU/e/u6BRcvik/G6x+zRHm8kciPgsZ46Q9aBZn+
	 7oI+BJNxA6Fr9vUVFtuho0N1WAQWsuebDB7c4QbdLh9mc9INqXv0zdXZv7LWBPTwZz
	 KcdJKo5l79MO71Q+kktxdJgfmCpQ3+havlLC0/P9c9TP1mwjddKsHN0djndoezW5Q6
	 q5VsNOHVaeIfN0C1sYhMG7XllJwXsN6BSiUTdhj/q0V56VNw+Du33ChbbmppKZBuFV
	 DKKuSKTVPgPi+Yy/YiSXJR6Wpub+Tz0hGTLQriLmrlVcCffclU72MXGQ48x2xQeLWz
	 UTcuZ06rr/dVIMKoWB7lLTJGpnjZMTegPIhhd34SkQ/+q71CshIjnXW2uEx/mIvwB9
	 iOuQyEfpfLqrAX334JyfyzGsHicQ1tgLtKpatzU120rymSQibs5e2653+9FOh40Afa
	 6r0lr0d5Zaf9sPBpHaV04Nmdzfqvs8MegB4D1ghPxCgwUWzADlz3f4q9fhE5zSHFy1
	 gz92Rg9U32PtH5Zf6Kj3gwIwyRNSDRSyatkOURjAq8aTsy8rrgjuLpPpjVQFwKlKuB
	 +UhG6Subb7EVbop17MXvFvtoqXGW+CKT0yCMaamnNmuEKqIhYCYhwIQFdI7SRtfiO+
	 rcD4o1ZgfNE1SLPkP6lncAHs=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 37DF140E0194;
	Tue, 13 Jan 2026 09:41:56 +0000 (UTC)
Date: Tue, 13 Jan 2026 10:41:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: shiju.jose@huawei.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jonathan.cameron@huawei.com, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v14 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <20260113094149.GAaWYTXf6qH4zleOOQ@fat_crate.local>
References: <20251209145742.297-1-shiju.jose@huawei.com>
 <20251209145742.297-2-shiju.jose@huawei.com>
 <20260112150552.GGaWUN0Ex8KgfqEEi5@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260112150552.GGaWUN0Ex8KgfqEEi5@fat_crate.local>
X-Stat-Signature: 8icdtbx5dapc717jzzf4tzbn4xfx98w1
X-Rspamd-Queue-Id: E109C160004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768297361-346016
X-HE-Meta: U2FsdGVkX193vYrVDUZbjInXmXAGxlm/DVXlvlMruFll1BF0Pd02WSYGcyXi4rR+dsX8GfGHRe0XP9yGKsm2BcQsEvRQu8H0Va2iqRYH1pPBW75FzRUjttOr0A4NMrfO8k4yz9Id2ixXCU1GlUUCncj3WbT9ZEDj5iDds26uehckJ3VfHs5WKwYctfghcmqlObGJmoRk2jXTGF6+o/ZDdxYEuhti26J7lYVByHk7AQE3h6mVJ9GPej5hSaaK4QK+IalnvfzBGDV+2pXKWuYWTJsVyG/CJTnKL2+CAJFU8Gr67WU3D2OjuHZtiz+1xjz0xp7LFjTTqmvafWStTaHqQPjFvbhwtQ2DQkL9/n0vyQzQ5S5SP3kW3nsQ8YNqwPl1VDxokcyJ6yn6wPrJhU6gxHHTozXMAJilMYkc8fES082E1vbdN3pAqboxEFb3w+PnMUBkKdKVzDOTFCh9gcEqJW6Fif0oVQJ7O4/jxMTq/z04/TAMj3oK6hUNOTLxrzMSoPCtj8McYiK8wrvbITaJMZ4h8bTzLbDwx/Izh2RgXAXZAWMgiwAdLCz/SppTlenAgUsZ6BDqp8mI5b9f3QJev3EeHjtvbkwmC7KEjqA7cHt6Oqtalr5t3goHn2wN6Fh5D+u9OqKBJUZ51BNGBbFOXzfDDkZhKjFpPAhjlaa29uCbPCnrqwdPCJ7HLIpj7Tj3lCiUtZFJfl5MeUeTdBLdFsV9smjRDe4aaVHTFU/546EH61UHhAeEf9iYsgHEQTO59f4S09V1DNDLaou1Q2ooINiGMcq6aK4NqEi/T/ohXYbaN7O1ek2Z1wlxg0LCyDm4BnfhdwhskQRoI/IoZJW65O4R9lKSCgBEC7jkxb1/II5jIGPqAbgqupMtHCwB+GFgs4HKwoA3wPjBjCeOlsx8SHIzrYXV1s0gpBrcBzjUeLnoCYMEQeHptn35zjUKBL6X3e8PkvFukXxTsn0g2Yy
 m++te/Jj
 8RLw4IU8tZuWvXYHlb28NqsZr4UZ4ESMGou4KprjT8yMTYc1AlF10Yvilskw6nDXZxz1JsOHC3/nfirFYIJYBRYJYZEIkLwDQr7UTXqdkA5llFe5OWPU0ZjY4LsmLTrDdazl5pSW3fEqLqG9HC2A593dGZBxvdAjujnN9jsyuxaNFdCroWKkGSrW+LSC9rn+yoSvK8XNTUFRdn/0ALODzLIjxQFzEJ4FwI7xNEqGQlE1UnZZpHPmHrQTZI+TowOqlEZT7Y8LqNEmAHznd3QSr5nG6UwTkGEsFmaIS4vaLCAmYHAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 04:05:52PM +0100, Borislav Petkov wrote:
> Please go over all my review comments from here:
> 
> https://lore.kernel.org/r/20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local
> 
> and either incorporate them or say why you don't agree.
> 
> Ignoring them is NOT something you should do because this goes both ways.
> 
> Ignoring this submission now.

I take that back - I forgot that there was an in-flight review when you sent
your v14. Sorry.

So please incorporate *all* feedback and send a new version so that I can take
a look.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

