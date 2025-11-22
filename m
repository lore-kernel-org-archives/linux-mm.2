Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2948CFC539
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 13:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1326B0008; Sat, 22 Nov 2025 08:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E71FE6B000A; Sat, 22 Nov 2025 08:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87956B000C; Sat, 22 Nov 2025 08:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE84E6B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:52:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F3D813BE20
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:52:01 +0000 (UTC)
X-FDA: 84138381642.16.8E50760
Received: from smtpx020.webglobe.com (smtpx020.webglobe.com [62.109.154.244])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A725140002
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:51:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=mazyland.cz header.s=default header.b=PDSvH6BR;
	dmarc=pass (policy=none) header.from=mazyland.cz;
	spf=none (imf09.hostedemail.com: domain of milan@mazyland.cz has no SPF policy when checking 62.109.154.244) smtp.mailfrom=milan@mazyland.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763819519; a=rsa-sha256;
	cv=none;
	b=E1+oJQP5iFu4H6o8Z1VG9/l5ZKa2V9q4nyiOO16z6Aga8AB8wtI1vUdWaQevpHTnWjy6ju
	07eBcfItMWxxL6lixYaXGU0BYaMkOWZs/+D6B3PBrK/n8WYbva+CTx0Y2JQcSXzY5XCOrM
	LVN63OaA9rhYnO3912G+MNOBqNNkdxU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=mazyland.cz header.s=default header.b=PDSvH6BR;
	dmarc=pass (policy=none) header.from=mazyland.cz;
	spf=none (imf09.hostedemail.com: domain of milan@mazyland.cz has no SPF policy when checking 62.109.154.244) smtp.mailfrom=milan@mazyland.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763819519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkpfSprlu8mGib1c1nujr3uybcLVrrvCT0grlaS+iiU=;
	b=nUspuP3bCXA3VAkhCfqap8WSRofqXB/Q6NAuTCwjRIjGpW/RcCuCbEXrMquXUlzT+ypf+t
	fphd02/Z2FYoDDAheWwW4MO2rl8Z9UIY6oEJ8k8gABswl0Wt4wTrhXZOagGgy862ui5nY5
	fUaIf0gpRTXnDbxuYr65Ls40XPEtk+o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mazyland.cz
	; s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bkpfSprlu8mGib1c1nujr3uybcLVrrvCT0grlaS+iiU=; b=PDSvH6BRtX/qkR4mGWWMFMJ7Qr
	RUcdAyXi00bDVuk74RuOjsK9cTjuuZ8+5bn2SxUaSJymq/gBTEgXgWlX3Q5gmMe4aDtygV82SZAfq
	WXglxuheiEIXcoZyhVfDgrBS9eLX6TK9Cw0N1CDDb80mxwTBAHq6sgO1g3ayAJlllGA0=;
Received: from [62.109.151.60] (helo=mailproxy10.webglobe.com)
	by smtpx020.webglobe.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <milan@mazyland.cz>)
	id 1vMo1o-0059ua-25; Sat, 22 Nov 2025 14:51:52 +0100
Received: from 85-70-151-113.rcd.o2.cz ([85.70.151.113] helo=[192.168.2.14])
	by mailproxy10.webglobe.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <milan@mazyland.cz>)
	id 1vMo1o-00CJls-6Z; Sat, 22 Nov 2025 14:51:52 +0100
Message-ID: <aa2ea539-368d-409e-afd6-f1e547497ed2@mazyland.cz>
Date: Sat, 22 Nov 2025 14:51:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
To: Askar Safin <safinaskar@gmail.com>, mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com, agk@redhat.com, brauner@kernel.org,
 dm-devel@lists.linux.dev, ebiggers@kernel.org, kix@kix.es,
 linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-lvm@lists.linux.dev, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-raid@vger.kernel.org,
 lvm-devel@lists.linux.dev, msnitzer@redhat.com, mzxreary@0pointer.de,
 nphamcs@gmail.com, pavel@ucw.cz, rafael@kernel.org, ryncsn@gmail.com,
 torvalds@linux-foundation.org
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
 <20251103155345.1153213-1-safinaskar@gmail.com>
Content-Language: en-US
From: Milan Broz <milan@mazyland.cz>
In-Reply-To: <20251103155345.1153213-1-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Id: milan@mazyland.cz
X-Mailuser-Id: 923906
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1A725140002
X-Stat-Signature: cqj85qhgn74xaanrjp4a3ss1bugmqum7
X-Rspam-User: 
X-HE-Tag: 1763819518-442864
X-HE-Meta: U2FsdGVkX1+OpnEHhk3DNIjichL52zof/0cx8IuzMx2Qw2cZon/LnD9LNsaSoJlRL4vhwwo1q3NNv23dOc7+zoEARShjrNis5UJFRkHbsewAmuwbl9z2yfbLWXigvYgq8cbVl7DOpb6+bnInR+YycAo22rrnGUzF7QwZLnznieOPmp4BX9KQEsPi02MLTrxAMcB3jTilpSyebyGRh6qyD/VaPwD9wt1bKdaK7bAIuAT1p7EXtEn3gQwCneuZmN4bTjpUjvfOR4DBNVw6pDJUBTKmvfpNfAo/viMgH0gEiPGX0Bf7SOo5MCNDc5LeKvdAC2+DGZ7iiBpRAtOtqGLyD8sk+KSh9OoAE+V6FfOoRTpdMuXi4mG0A4IQoL0+X2zK6HF8G5LF/w6IjL5zRyD+X9EDY3hU+lG8INGOIfnvuRe9lVirNcvGXSFKA8Gg2fczWz1pD9woifeESUQ1m/zsBXK4F3fupDFkLDo/z3iTsgm9YFJEZvr+6SfQBHQ6DI7HPGYGAS9PHgt8wdavo6DIw1gjk9ZJFA0kGmIrmgv6EEd4JDcqY61vCxGuMOXmuYorRLf5GX9QFi6evDKjLotY+qBb9Xac/2Tfa2uJUfYp8rtypbiErqD9+f8kT1RqE4Bu9By+1cvhJubRiAUNgO1nqVVKlIi1Kt2zH5U1D3lt9pSwRInauljGscN2BNy/daJEnj4m8TY7PRuvFtP4lhMerofMNgqQHiu5lhVeJwkhn9sVhA487DX0yYiMHpErVIwi2RemAeeVUIEex53M7LiiLirvf4i4ohPflyOxA4p7ZdCAfjowlTGDbGf519v89wRp/pEN31Nt3Nc8yYTu2HE23OE/v4/UMxZitu47rwo/Ak6cN4dv26084wgic/JORyjsQIZc1JN/1lZ24JeLKtWE2MzQe6u/mo96bt8mQzCgZ8eqz2yi5JzGzWJV2BLZhAQq6Y5BiIlt/5pgurxWXW6
 A7g4mDHE
 mrqTsd93wxMjNdkGQOOqbau2dMkinYt9bT/c5ole5Mxdvdr2/K/ct6P066DzNcuBLNChuXFQWpwTzhfcZeulHS70/thXbvyVI7VhnHarhaid8NfoXFVyXlqaBge55bbS+TbGiowFvC7jzIwAIa/quZiIelAgj+obSFcp/WuYVHTICRK00Ey7+BVC8+9IXRBkG4ZlbrUwUnKgb7otaNEZgAhXSqB3nbthtjBUsxSfR1iAOmNGsKVlFRFIBXu+zyjXUG5MRFhsTWUFUXDY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.034030, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/3/25 4:53 PM, Askar Safin wrote:
> Mikulas Patocka <mpatocka@redhat.com>:
>> [PATCH 1/2] pm-hibernate: flush disk cache when suspending
>>
>> There was reported failure that suspend doesn't work with dm-integrity.
>> The reason for the failure is that the suspend code doesn't issue the
>> FLUSH bio - the data still sits in the dm-integrity cache and they are
>> lost when poweroff happens.
> 
> Thank you! I hope I will test this within 2 weeks.

Hello,

Did you manage to test the patches?

This issue should not be forgotten, as dm-integrity corrupts data during suspend.

Thanks,
Milan

