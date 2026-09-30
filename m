Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A75DCA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 09:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7306B0088; Wed, 30 Sep 2026 05:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078486B0092; Wed, 30 Sep 2026 05:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF186B0093; Wed, 30 Sep 2026 05:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDE406B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:17:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C679C1A0738
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:17:57 +0000 (UTC)
X-FDA: 85269876594.21.83A54CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A28C140004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:17:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UauxHsxm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790759876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1A+WlULujwTkG6nahgS6pUXERQ7Qa2I13iMuWs4TUk=;
	b=JjA33hipP5jT2APvpQjTwwDY/lHhgYJOLzHcK8s6LHLg9+45p0zjKb7sjmgr8AOftGmamu
	gC5dDnXMDvKFaNZGluZSUztr9r5ufWTAAK9wMkVKHgv/mryrJiGwPO9nVgmKBC8pkpXQ0X
	Ff+jo78gXRKDfF7cgYIzI9XGd89H6QY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UauxHsxm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790759876;
	b=lOLDZHPgxzHekgrojgxrT1oYUd04zdue79KydAay+7vTg0sdDa1ymtbKCA2IiAXCGEVG0D
	SJIYM2Wfj3ksWJps7slbtzzXriZzDL2DJjrf3lWmxPatl1nkxleVyUvn/wxksUukGCsl8f
	k6MfMzDvZy93TFIblyD04DqZz6UBijo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 724EE43653;
	Wed, 30 Sep 2026 09:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B151F000FF;
	Wed, 30 Sep 2026 09:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790759875;
	bh=Q1A+WlULujwTkG6nahgS6pUXERQ7Qa2I13iMuWs4TUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UauxHsxmJYoEhmXuIJJ/UPFeXejYxaiQKZPO7NyNDw8gm9kLo127Hkg6o/OuzYpak
	 neThc3i4svWHBeRIH+8LFrKnMz6R8dnr/d2qT3JvphBBimg4og/E96u78huJKXROKA
	 r7RLUXzeC5+a53CwSpr1klK6yaS9QJn0ib0rWiordGcQSAzioHQSCpVrqdA6yOr++L
	 RTeL41++Yywva4yIrj09NdzHIhH4TVag8EYtKFjD+ti37gHNU7RQIBm9Aq0/0s4gkp
	 qyE5TiqZaToB/wSCoy0IQ7RPqS7Hi3DFEnCIOrBBO3R7y+79tn66UGmQ60a1IZgQd3
	 4iKrX3a57sFnw==
Date: Wed, 30 Sep 2026 10:17:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, david@kernel.org, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
Message-ID: <arzTBqww5_1MH0B7@gremlin>
References: <20260929235711.2287931-1-thehajime@gmail.com>
 <20260929235711.2287931-2-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929235711.2287931-2-thehajime@gmail.com>
X-Stat-Signature: ne685zn81rsm5cx93k6h5p574t3pfoe1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A28C140004
X-HE-Tag: 1790759876-337209
X-HE-Meta: U2FsdGVkX19UnV0gZHU4gYltTKqCiu7NkdBADGkb9OIxE5+U4tjCnG/sPwwHo3wLLJrhr3QV1M/NLVpIq5XF1WSesKULa4VI/CqmY0Czhkwb0gmDlGU0E+TUsFlJLJA3/M15QqNI28hPwL3oH20l90oMRx8mgr+1mvrAZGV5S/G2gReW42rMip7BHRXV7dO2zRK8konSNuUwZ0ow5/ayw9WollB619KwZ6t9u0ZdUY4pWmm1XpJq/mrD7eBdcN+k5Fsqf6IRgBel+XUaBU5ON5ShoUU7mVu4GkNru4OIwbmxSHyefTxF12szSQ40cyLaxacntr5178Ko3mZP2MhveSshMBFB9zmWbcoHgyhLQn3rVvp29t1dTGvyovCofnrw7+odlfr+PxC2Qo42LdvX5Gd6lszvtPYCQi8XupqOIUt73bDyM4icAyl+BRBZI4LuapcAfEcxVqR7sZhUOwFTFcq7JYuiLixryojJfYteghiJBC9Q7heK2FB/ec7D/FZRRohe2z6AE536uiXemUKpWYIwMQ75JOyxWaOuJ7uw4w7OExeBEw6+u9uofcD8o/dosMHSkftrNxcbLeilx6UCpbTqvX2m2LgXDay93a+Jw5MUz02TsPQVEvIUaaPdrYBP7e+X0B55L12lMo1amGUzg16uz3sr/5yZFIIJFFpH5DNv8thIOSrqv2tOgA3QqH1dpDO3fAY4/ry66c+pGBe/rK85kmyMNOKIF58xQOCPFAglc99xJMW4ROYxB5WxekXWu1a9m8f3RGoU5bl4fsGNntiZ2PcQZ0Zp06ph6v50DDkYaXtJvOPCYVd3y3fABZAVp5zwBBgMOopHqpQcTtQn3r5WYJc4CLY4ifVvFXGjSRT0/Y8kMWYas6ccQ0mlX8m41PEzYHlzKVa41RDqFu6lRd8NAEEssP4xqrUIbbbY8WNDm0kPjBe+JWA6GPFZ+56RIWao8+vQCvbmuVkA25i
 X89xpBxy
 4YtrF9Q1lGElE2hszDFVKnHVTxmWVQDmp4ElIZZ3xq+1kRqqvsxYXr/C98R06A7g4BjKUVR10TpTeDrBGm7FjtWh4zoCsy8v1qqhpvkPhSrEKEqa7TyveZPK0r+WZx9ecJvKYjUyxkm3pGvh3vrPaexb5tenwZrdcJWi8iqJaReCJDme5yrqpwytZIyE/2jBjWnWrs7WRWRGqnHpLTommvC3yFT2NJfZbXn3ET4vJt430a8myQ/A4X43/mdTBwOyY7M2MNvOwkyVFfHDd9fQHI9O+MIQwlYoSRaz7Bap5A7O3n4eQcmF2mgIX47eczZZnIsBuA8GueWV/wDC99YOw3FDAYrVHDUVNvs6ukkfr7VvCJ02jkB5L/ra0D6mZirxrzmXWzAE9CjNX0i4HNGWCQc3Yqtd9yZPVepPTbURhsSr6+yPgIoxY23pFC11IlptHwGWURb2LjFLc0DUxxO3bHH99BDLd9hU3ilzumbIfEzLiWwaWokmwuYin3yGyvy2NDR/ndfbK4ya2+1zoNVlk60AjN0MMArDasganxNI855J3roCU/ydpKCnLVBisr2+2CftUKWA5NFc7dBG2cKPzOujGEUBVsaWcD+2TY1+UmVPtEYlAD2oj5W6EqQ94f98kKdt79OL6aqspdQi18aGlvMGGo30qkU9O8aJbpwRW7fBOwVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 08:57:10AM +0900, Hajime Tazaki wrote:
> Architectures lacking MMU don't support fork(2) syscall and only
> vfork(2) is available with limitations.  Thus, we cannot run kselftest
> on nommu architecture as is.
>
> This commit addresses this issue with the following changes:
>
> - on test run stage, avoid calling timeout command when NOMMU=1 variable
>   added to environmental variable, since timeout command uses fork
>   syscall which nommu platform doesn't support.
> - describe the difference of nommu tests in the document.
>
> So command line to build/execute tests for nommu should be like below:
>
>  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu
>  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
>  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
>    -c nommu
>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: "Ricardo B. Marliere" <rbm@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-mm@kvack.org
> Cc: linux-doc@vger.kernel.org

Not sure we need all the Cc's explicitly :) Andrew adds them in (I'm actually
not sure in general if they're really all that useful, some of my series sent to
hoards of people due to touching multiple bits scroll off the screen :P)

> Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

