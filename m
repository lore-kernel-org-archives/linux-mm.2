Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30FFC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 05:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5426B00DE; Thu, 22 Jan 2026 00:40:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983206B00DF; Thu, 22 Jan 2026 00:40:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFFF6B00E0; Thu, 22 Jan 2026 00:40:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 758926B00DE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:40:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DCD0C05B1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:40:23 +0000 (UTC)
X-FDA: 84358499526.20.9F01EED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 34B941C000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:40:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769060421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yho00Wz8MZw3BXiG/dlKspDJeqqDMQPoA7dZhhkY2YQ=;
	b=ZGZZjqnIsexRiszQFDMvaVppddtCskSlIkRtxxY39U2Ubzc/XFVCvJdVRDKje8xxzHbeWn
	RazsS/dsrRvpff1XsOL5gkCaaHdhKTct2mXqvPCh99dxrIW57zldZ8hezTYhkBJUwbrquX
	9+161XLBGkw8l00qq8uuVzrOtua9Kgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769060421; a=rsa-sha256;
	cv=none;
	b=amdljAa+NL8MRS8sj6epQ0A2pQLdPbEI103qw3quDY0gMsgQzDaRSHq8PUqTseD/VNfDGd
	Ge3gZrNdvk8seeoY+LodO2Iawm8VQd/voddI5t7NTa8xq8roBJ6fv6ifg0q0B22UuK8rjS
	ztoV6aQlwUfisvwO4qbysCqZwOYJ6Pw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 849431476;
	Wed, 21 Jan 2026 21:40:13 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 595943F632;
	Wed, 21 Jan 2026 21:40:17 -0800 (PST)
Message-ID: <be2513e0-0d8b-42bf-a1f2-485041b5d320@arm.com>
Date: Thu, 22 Jan 2026 11:10:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] selftests/mm: fix usage of FORCE_READ() in cow
 tests
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-5-kevin.brodsky@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260107164842.3289559-5-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 34B941C000A
X-Stat-Signature: qjw8uxwtk7nkuqkwinxmx1moihm6zp8t
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769060421-649339
X-HE-Meta: U2FsdGVkX18Ha4a0hGmiY8G/vIs/H6SmyP/m7IVGuym9QxOl6FbTBzh3G/yLqCh1cWx+mPta9F1uM/6KBTfrecSds6DK6BTM46Sk7jtoDnJGX36gmsCu/gwsmUVAP5q013gyQnq+7TjrlU0UPpS8HJ/JRiY3j26DL0Rcfyrh3lFd2RFx+tUWf3khQkSmC9A9m8sxtXgz1gn4BvUlajTUmj7C74SiOqGn02hiuiIsJRI7IniMA0TF+O114sjwkglRk1QxauMFm0GlERLfDKPCc41b3zFKKPMLyPd18XiH5U0DIJBn9kGYejeqeSofsjN+JpsAbWBYYm/Mc38zj4aByiSgrn0Q/+nELEbs2VKQfoXaRV5oGIRFyK9+rCvzyH/hCd1FWtEVYKk+Y/ciRxZQ4Ss1NtgdSIZ25jcR5IVGPmvaSPG5SQhlaCixIa8wVOB+2QDhFz8RS78IQe0pHPZQeQyTHKYJiionZ1deqXmqrEO2sYHvLRGjCbj7ZKpa1s/KxOck/5+vmwejdJA81/7ZTq1+R5UWU8d66DaRKsrJeqYBq0h4WW0LR5xAigTPLPVlpiifz4A/QnaqXnHn7REAqJCCuNQBgy+5UZEwD/sNjW2gukTgG104FdNxDpDZzj+TBQRKqZO4IHxta54P4oNXoj/n+yW55QBqjwSHUxkGpyVE5ACWnL0Z/I2xMiLlLLtkTuIwoqeJIVkdVbofnhOz+qlqKVKsrn6IB45Vc+OBjNXrhCSy7NeYjhkj/sETfGFiFDYOSOclk46bVIeggu9IJe1a8+XcAnKPsVBD//1dzFEOb35ZKLfAhijo1bx+XW1ZTDQkTd0z49qZLQthfO6gGKBDzl52l0Z+cAP/OiuV5t9EYFH6696hd4pfYx/SidfsqKrDpegzFLg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/01/26 10:18 pm, Kevin Brodsky wrote:
> Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input
> value correctly") modified FORCE_READ() to take a value instead of a
> pointer. It also changed most of the call sites accordingly, but
> missed many of them in cow.c. In those cases, we ended up with the
> pointer itself being read, not the memory it points to.
>
> No failure occurred as a result, so it looks like the tests work
> just fine without faulting in. However, the huge_zeropage tests
> explicitly check that pages are populated, so those became skipped.
>
> Convert all the remaining FORCE_READ() to fault in the mapped page,
> as was originally intended. This allows the huge_zeropage tests to
> run again (3 tests in total).
>
> Fixes: 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input value correctly")
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>

Reviewed-by: Dev Jain <dev.jain@arm.com>


