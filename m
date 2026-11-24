Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50388606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 12:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EmujiN00
Received: by kanga.kvack.org (Postfix)
	id 4A2F26B06A3; Tue, 24 Nov 2026 07:31:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453D16B06A5; Tue, 24 Nov 2026 07:31:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A3A6B06A6; Tue, 24 Nov 2026 07:31:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC6F6B06A3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:31:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 160BC1C39F1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:31:53 +0000 (UTC)
X-FDA: 85469949306.17.E727F29
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id B7AAEC000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:31:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EmujiN00;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795523511;
	b=uQLEE2Fmk9OmFseujsTh6ttdj/br6f1OWcRNJFKicXscnlRwqnR7pB6cZXAmQh8lzgDe3k
	Tmbthz+zU+0UUQk5RlrQbmfklUscB2HHtQUzAhIiqhlP0U4e8EqBnJyKj//8dcx5UT0QXu
	1mm2VVEL2sA/ByPpQH1Ldc8NQLJqSEM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795523511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzeVhfSZ86GczgIIPjVQ8nQzZ5ybTIQyIIVFuNTUIeQ=;
	b=aLgDNVaFf1Lh6omyEFFiuGydqsqOy5Rrj0vPiewa4/cQ4xlHq/lzP4OK1SD/Y8r3rzsnMF
	mxKNVRdpg05I8yrj+xlZwuuoegShzJeyGw2FGnP0Vxhz/tvsbWCJpoQaY9agz5uomJjxqn
	wdcmFcBgPL3y9TTQZfJiWQtqa40aOSA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EmujiN00;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=60Mk88KLHnZn4rnhSt3irzUfk0fS6Z9KyiAAA3YzneQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795523509; v=1; x=1796128309;
 b=EmujiN00LhmmxxngTNMT6nXcJcWyoIPK4QPvBrjpAkO3f5DKy7llqtDCrYXvTruEBy1sWLpu
 tkkFFbYfCgeCxtV43C7D/IE+LumSi41exLOXVFBrHdJEFEFTTD1dK5nFQtVxaibCIivo1XEuOsd
 cT1Ye0nfIuLrCYiKFohn7bJA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9dcfa32912031417;
	Tue, 24 Nov 2026 12:31:48 +0000
X-Mizu-Trace-ID: 9dcfa32912031417
X-Migadu-Flow: FLOW_OUT
Message-ID: <835e8def-f4cf-4422-849f-08ad42f47c8b@linux.dev>
Date: Tue, 24 Nov 2026 20:31:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/sysfs: skip registration if DAMON core init
 fails
To: SJ Park <sj@kernel.org>, Aveline Noir <jm5905938@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lian Wang
 <lianux.mm@gmail.com>, Dawei Li <set_pte_at@outlook.com>,
 damon@lists.linux.dev, linux-mm@kvack.org
References: <20261123153601.85440-1-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261123153601.85440-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B7AAEC000A
X-Stat-Signature: 7ef1q6kod6p7e5rmic1yxnnbmprtywhp
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795523510-925615
X-HE-Meta: U2FsdGVkX19gmsXOvk2W0OgMEvv7jhK3+QakJvhaNiyhkFIXrhag8H85V5NVNtGu7ERrq482sbgqbTVzBD0pSAnYU0h4wph8mWMlQvvk4cRfG+yfUdr4kTHNiuRU0gMSgCYhwAoOOzOOFcWFBFdkenTeyLaKwvG6tSzsBs4nFJiGSGfNilKmyNC+LXoILa5C2aO4ACkk3YO4P9VPQjMyQ+wH286Ux9Iq8WFWdLCUbJmP7URsM0raooVs53mvdTfvNDrBovq9ldeMQm7E+kX7IYpYOUqhAWb+PjCTW6Dx03QLonXQ0pJ821oaO8xU0tNeA7l+eRmW1GVxUtmaLjl/yWS5ml/86yfMq0oLP1U3haavLwad1Oh9LnMfX5TJN6oujgOADNp3lY2EXX5AeKm8cRHemFBZgnMNHsUmg6eFEDXPpI1C1D5CMSjWsYcRMN5Gnv8WOVNgANcx2hoXMmzjBdXL8zHy1vmxWRfZifL46E/TCzHXY+NPQunD/yix7Q5Dy/tiXrWzlozDtbi5C3oh0FVZLNc1lYIIkCD3Gqd1HYegaPdRKdfn4c8zQREmRd7bdkdjV+ifDLYxPnFp/eSDivpkz+4iAp4g3UtUcrSvUu5rCxNjveJ5N4XbT8arnPXMveXb0BmmS9Fhh8WimN/J6KR4mf7Li9cRDrd7rlN7UWD/sphNjuzSsNu5oZ9S79cXEp2mKdT+n05IRg7MNZrJWv8Bu/sE4Ge/hubjFckDhM8MFUS3woEuOT9WX9uXVYWJCMZp45P+3EqEza9s+w8P6Me49ig3qIeeTJekzIpktoQKtZOiz/Ti5AQc2LNHkYxjdv2u2L4SMiWZly7IusCl1mI2RS2eSbj+qfvnmN2Cu94EmBW2vRHEFGlwHPGocauWx2Qx3oYXcR1K4NRy3+77LPmmcM2v+ghDW2xhhYWkYVsPv6auoy9H8htIbo5SzYdqVd/xzjmPO79Oo6GP399
 c8PD4s/e
 8UgVsmRhjWuZ/RP8m9JzgT0/y68ZdeeXq80nICZWE8wNBQvVwCjEO4gskldPMbMBmVzcN4cM3629Gdioufg+XqOqffkyIusesZQ6txDeErJ+V+nzKEJohuV0+8lYUg4aEFKvLRG0Lbbeh/C0t/TRAMDAvFImWfbK6ca3M7kXWyEN9l4YxF10CZay5sxpM+USN5uoUGZV/1gEULa/+m5vlWURZom82buvse/87pyYaimxg+NL6HuwYyQTFMX8Qz6bFDA+6srhzAXYB/Usc5ZmHM8X2f63uZ3/YbH92VgaovMBIgRSMqve5ngkysPO0EMQqgbFZukV8e3j6gyYfjLtK9mnMOc5EKkdMBd/kFZNnNbTLF2K6VbhecBCMmqdaF5B1dCfqgcMhqNzc82NgFlD/YlWb65rKYLiKkAeC+DLCw0VPVvmXk5vZuqkD6oYnn/IQcTlrOpAhXRGSeljylCqb4nlYK9osTChoUvFPlSGVd8ngX/MVP+rjYxGVZrTzKhjDTKQ8efZ9if32k21oDL1iNi+wMJDmqlIp7HfCtjBA0c83SQpsVIJRth11RjK/YAPBJE8cP2p+8LKm5B8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

One tiny thing in the commit message you proposed, pls see below,

On 11/23/26 23:36, SJ Park wrote:
> On Mon, 23 Nov 2026 18:51:45 +1100 Aveline Noir <jm5905938@gmail.com> wrote:
> 
> '''
> DAMON sysfs registers ints interface even if DAMON core initialization fails.

It seems to me that "ints" should be "its".  Other than that, everything 
else in the message reads good to me.
Best regards,
Enze

