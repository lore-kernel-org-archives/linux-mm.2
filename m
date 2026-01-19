Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF8AD29C28
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 13:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512DE6B019F; Mon, 19 Jan 2026 08:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D41A6B01A0; Mon, 19 Jan 2026 08:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2506B01A1; Mon, 19 Jan 2026 08:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3076B019F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:24:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6E56C017E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:24:11 +0000 (UTC)
X-FDA: 84348781902.22.15079A9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id B8E5C40009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 13:24:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768829050; a=rsa-sha256;
	cv=none;
	b=QCbvD6lgf9AibygBd5QsQzMKVCYRIeBVVFgmjJ+n++V4umP66Z6/0MnvKzctc2Na74dMvo
	lGj/axh7qXwAvdao6tbzbVOpSu49YdjE37pgPb2qm5SnGLHz+oiKAsMtfXb4mOQSxFA5hX
	xAifo4U0vEb1c9aB9DQfvo1zLlBVHmc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768829050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jor/QInlEX+fsL9YlpJ8E8qDgLYYTGfnxOUzoIgOonw=;
	b=EQzoqPpnd5rVMGR1Q4z85Tyc0DmjMak9T9vcPsc1AS7cvQHJD9udRvHpvbaEf3fvZcANuJ
	0oSzwHveADRnX1IRImxLcuKgQxKXZ6j0QcagqxSHO0PvJOVZK8xN7eE2pIrXIn1So3FnRs
	3k5V+Nj1dK/ytqLFA+JZtVeWq8j8Qo8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6C7E497;
	Mon, 19 Jan 2026 05:24:01 -0800 (PST)
Received: from [10.44.160.85] (e126510-lin.lund.arm.com [10.44.160.85])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CD3D3F740;
	Mon, 19 Jan 2026 05:24:06 -0800 (PST)
Message-ID: <4d3361e4-90e8-409f-bde5-b09de53137b1@arm.com>
Date: Mon, 19 Jan 2026 14:24:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] selftests/mm: fix usage of FORCE_READ() in cow
 tests
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-5-kevin.brodsky@arm.com>
 <e2d76567-44f3-4372-9490-5cae91619125@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <e2d76567-44f3-4372-9490-5cae91619125@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B8E5C40009
X-Rspamd-Server: rspam06
X-Stat-Signature: zfdzp83jw39xky3snje8o6ezr6qfdkeq
X-Rspam-User: 
X-HE-Tag: 1768829049-950757
X-HE-Meta: U2FsdGVkX1+twNzZjx3HMAqXvSyuSQMYvN5IQVY7ye/JhvQ/SlNnB+RHEvLfKoTvMsZ/wF3Mhm0fcnGsW/8g/qWAmYpLTc6YUOQp9mIA3mNvf8DK+CkWXZTaDw5QmIhlrCpTpAxb9Z/iFPfQ9t1ZYNqV1TbhcOCa9Kmf/vBUW5ZvGrV0adbCYcjLoIUNPHASeQv817xhdRec2tpHH/PWoFAN9mCveBSnJsVtRVpx47B+OqiPKL9CG3jc6lVDUUry6W/DeWkrfmla1ROVmee7mIJ10HXjMw2dYLjYDa4TAtZs4Ij2wLfa0RSeaTigrJmUBZEfs/K+1k0cXucxVHDNVQM0TgkhdnKCjD557pFzEfN4xol/fV0PInZSOAIcw6uXiSgEDjrLCjOiBBy8nbHzbZ2Up1BCzX2c6/qQ7eHGP6dgcC1pt4Sets3PlFgoMYsv9mhRF/wKY6Fsjj1OpleF4KSmElMe7X5HVnhPlb3g+qtfTBriW8un08dSJ1WGEXj9AXg7p8r11a9EfNIq+5V6L/hwK5KUKt/LKfP2cPcDLTqdR6lVNUiFGcSWsQYaRXj7Plw/kY5yKuvamDpVLF5e8ZhXu8Swk6mo3hbQ1RGcgBsdgcojoZ2VUR63T1R3sEhrlLuEXO8/uuQ2WAmJKNXRfnrzzzqVzxehe+DYsOycg48X8oV/21vJGvsrdKVuu0WtGc+VpPQCqWyy/Ep1EkDn0rKaAwQ5oyeAti6Y9j/eKcNYjSkQRomCp4oTU5Ri54iC+fjlrVYCbT1iUdr//950LobEuwai1OM3x2n8Rp+SWVYcmKGSdIRzvZ2eZ5DhQGJ/xxhvuvUx3jv+83ATbPF5qoZinUB9y0APcjWOj3cDWyahy4Tc3bQ2vst+8b0Z/Z83hTjW4l75b+ybzB5DhuawK+gxwBDhdPSxO0N7OfXT/Cp41zlqEko93eYXPi39Kz0wK3qj4S/u5Nl/L+WyPpR
 HURBjK6H
 Vy4BbHmWDP1egJU9Sp6Zk898YNE76XDd8K4GdMbgPONk5fuj2pUaQ89olG3vU9/eQ7ABaeMZw+57t9Ofd2I0TWGyqSZBp1Do8H3Ns8QnmDRnxJ46BAonpNWBZk7SKAhb5ekbai4if20VC4wKrjdJQ/wqFrYD/TXd0ZqZHC4ngYSl1E0euvv9+JzwUEgzjm+5eOx6h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/01/2026 11:50, David Hildenbrand (Red Hat) wrote:
> On 1/7/26 17:48, Kevin Brodsky wrote:
>> Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input
>> value correctly") modified FORCE_READ() to take a value instead of a
>> pointer. It also changed most of the call sites accordingly, but
>> missed many of them in cow.c. In those cases, we ended up with the
>> pointer itself being read, not the memory it points to.
>>
>> No failure occurred as a result, so it looks like the tests work
>> just fine without faulting in. However, the huge_zeropage tests
>> explicitly check that pages are populated, so those became skipped.
>
> Right, that's nasty! Thanks!
>
> For all cases, we could probably just fail if the memory is not
> populated after FORCE_READ().
>
> Would you have time to prepare a patch for that?

Sure, I guess we could even have a helper that performs a FORCE_READ()
and then returns the result of pagemap_is_populated().

- Kevin

