Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8190C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 00:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50446B0098; Fri,  8 Aug 2025 20:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB20F6B00A0; Fri,  8 Aug 2025 20:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA77B6B00A1; Fri,  8 Aug 2025 20:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A5C386B0098
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:46:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FC5C82335
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 00:46:39 +0000 (UTC)
X-FDA: 83755378518.20.813411F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49D5E180005
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 00:46:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EOWyDjpt;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754700397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VyIdcx8Ad/sHBsusqQERVf5e5jB2k249CAaMOTD0pXo=;
	b=4binpSD3J9cjZxvnYluJBOA7fXsXjzRaVnkDNGS/kumNGwa+gZJxhlCQuxgFWHLKW1jS7p
	ATkTzSjxWaw5gRXhICafSLE+6Zlw5tlpbjK6lhpiOA0h9oa7v3+xLqWyMnoS+e6+5ABX6i
	zqi3YjtIWUlljBZ4Cue7aE0kv99ADGQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754700397; a=rsa-sha256;
	cv=none;
	b=UtlQrNKZKCokOr48Ha8rYnY2WhBZ/en2sm8pwN+kyxJkmt2dm89/spgr7QEUCFXdXbuhfk
	kHG3iZWaJMZRHcwXUd56flNPHnr7Dg83cpjf6YCCoM4HtdJmWApjIU47oNsebbGSvpKOOw
	1jr0q5cHsQVbHcZ6ipQ3PBiJ3po/ny0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EOWyDjpt;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 6A1085C6423;
	Sat,  9 Aug 2025 00:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A02C4CEF4;
	Sat,  9 Aug 2025 00:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754700396;
	bh=/wTFlBhbCrz8/H86cMuZoDjsflrTawHAuy5CIt6OSb8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EOWyDjpt55dfKZmBaABJBoGwUfCNL5NdCri/JOvIzvZayUfGNdoUDLSdm8wh/fB1T
	 /U0TTBlYZd5Yp1FCYPY1CJsWgYAmQ3SXNjKcIPfX7Ixzzl4NNcQZQeXVWm5Ekr5HEe
	 V6dfix6UJix72n+wgL/5szlcCPstgcZvvqlS6vJA=
Date: Fri, 8 Aug 2025 17:46:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, <david@redhat.com>,
 <lorenzo.stoakes@oracle.com>, <dev.jain@arm.com>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
Message-Id: <20250808174635.0a9cd13097373faff629f927@linux-foundation.org>
In-Reply-To: <13D32FD8-FAC8-468A-9C92-23A1B61610C3@nvidia.com>
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
	<0467FDBA-A2CF-4CF0-ACCD-760ECD30BA8A@nvidia.com>
	<207BD61A-5561-4E8C-B867-D1CFCAD37509@nvidia.com>
	<13D32FD8-FAC8-468A-9C92-23A1B61610C3@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49D5E180005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: aghbo93m7rzdqsnfycoyutg7jmaomjwt
X-HE-Tag: 1754700397-693035
X-HE-Meta: U2FsdGVkX1/irOqciPl0bDUe1mYbLOh/TRLn3x+9aiXyeNXEQGvLBRlnnKn6D7JzopngOtnyjXhDXBNRc6/Zoi4gdsDewvOKZcHRieOQBLuSRroojgWMlvw8YnDKq1xM/psfPBI/sW5caFiNV98pSDFDC2XztnUuvXGzn3gAvCx82LEd9+39JteQ+yGRXhpG3TCRbbGhFw9TsKlJcCu6OQFJiAwh82xWQjhLfVQXp5B6Ia2OasBBGlhxMugWmEfbt/x3Ekzp5Rn/YFdZht2vBCZYIOlOEGJi8lcpTUSYGw24FYDPhnKUq8dVHtzIpsOpol5tv0EUq/5j4FXd2cSPvj0HOPz9a4WRJKdKIT1gEklcP/q9Kpp1mWNs+ttb0/Hv/essDLN2RLCAfJnjd7kEwg4OPWghwhDqle3/XrYIARjfHoQQqzwZfeRBKyH/9YJzhPIG3bJKyjKgpSztCb3MM6SCedMhkK/RD+MbjN+x9Vhzde1HiTXzegMW1jEUWdZDnQN8/O3vSt5lkQKB9IRTIr7Acpt5zCtLVuI8eYxjrkcKUsIeBLK8ThWclZT625+z0t7PFhcFVEhdhZfpTOx8knVkw0qlNJXrA6e/Xj1uM6lxuG1UyQArGoAqaP0D51a4AVmnCu19Ck7o6z9lBYizv6EQMPWmWffno2gMseQ3IKfZvqYCsXKCzy228mGCQm4ZXElIaLArncXUdCHdO+Xvo4uHZmVWBKWjJESf+hPQxW4OucNmd+7R1GBfqS+WPhWwe2Rj+oc3HBVergKu+JWuBX7vG7dsg8Jsyc00l41YF24/TN4bZRRse4XidIzNvCDlcqP6i5gpHPAdgN0plDTFKPvTc4iKn1gekQzmVQLc0E9NfOLzA0xguzXlg+D/4sjAJURtE/xOy46BybgegaZL4gHmKj7dSbyQthaxzDGdNJmp0EWF+naWSS9qT+99LlpDc6FzkAZNqeJS4v9oTeQ
 EWr4LsvT
 pRB5uh5MLHavVSn82UODwj4AwEymfjg4YDjCdRyoqCQYVz2tSMbq58/+zDMZGacUiwHI+hsJWDARpKgfNuiylwgxGfUytXSJxAYQPv/TUmQ0JFrzIEVNCgDp2pfd+FhFgQbRn2Z1yvYei8GLsmw5w7iVMHfGg5P2zX4iGbkoWTFI0zQjOZoCtaRuhaV36qjuLIyARU79t0hEjYhxMtFvXp/s3a+LHxnVoyizRgm34efpYuAeNpfEG/VSDn+ls/idKEHXQho/TyooElbj0qg00WBfK7dLHMM2LB9hXdXD5DL7WDY0A9SWuBdYI1ihQicog+BDj8jdHt6ibmEWldQLs0lEDJ9WoxPQSrh1bW2Tn3eExx3JzqTSLEORA5fGtPSRea3JEoTnzfXuZGHfesg13JhR0s4mPdexlEzJlOS6Xsn6Ta8B9ukWEiqmtXtEDeeJhQfibyS0dc6QsVVEhpmWyMXKk9e/NEX9XV0Tv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 08 Aug 2025 12:01:47 -0400 Zi Yan <ziy@nvidia.com> wrote:

> > Wait. It seems that mm-new is different from Linus' tree[1]. I wonder
> > what is going on.
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/mm/split_huge_page_test.c?h=v6.16#n109
> 
> Wei, it seems that you lost the race to Muhammad Usama Anjum's cleanup patch[1].
> You might need to add nr_hpages back.
> 
> [1] https://lore.kernel.org/all/20250731160132.1795351-6-usama.anjum@collabora.com/T/#u
> 

Ah, thanks, I'll drop this version of "selftests/mm: do
check_huge_anon() with a number been passed in".

