Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B0ECA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599418E0006; Wed, 27 Aug 2025 18:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5491E8E0001; Wed, 27 Aug 2025 18:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F9D8E0006; Wed, 27 Aug 2025 18:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32F858E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:56:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCD3BBBEC3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:56:18 +0000 (UTC)
X-FDA: 83824047636.22.C50FAD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30FD340008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:56:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GEd+fyH5;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756335377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Qgh5Sx6/wOjFZXOF4nKsVpiMj1sr8gi/yxY212fi8Y=;
	b=afuM7By0iNf3F4KwkkrBTUC4uM1L0l8ZD4pZA8dK2Bda9vE5Ujgw4y/vzU3nBw08t/z4HL
	27xyLsaXMquzaHXl8GFGFGmhtcSi4kHg+QLJE5cYQdnAyksoRAXRgTsWF+OQUh+AgoO9fm
	3Pb5WX1ygI3Jf/JsUHPSDfO5yJ5SPCk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GEd+fyH5;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756335377; a=rsa-sha256;
	cv=none;
	b=MqR8K12tXBNPcfMcVg6/EyMZdPA7oyi3FrkBb5pgy+01MFHOrZ2pISEEKRWJ4AyB/gQfci
	sSq+TfhA83iJ1AO6RKCKRiOfRxbv/YRrO97kBlsvfquP6h5J9BzYRyEz10jDqAQSGhnCoi
	i3Kj6V4mqCQTg8d53cHqvqdeGrSeFaY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5744B60204;
	Wed, 27 Aug 2025 22:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FBDC4CEEB;
	Wed, 27 Aug 2025 22:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756335376;
	bh=/B1SgrrSnevWQV+pRhc+dhHUQzjFT6VYqbFyFZ1N5h0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GEd+fyH5w0msgOlZWZRibXLjDWfZ0ZYTK/NT/kU2wYtVfsnCceTM2RAIKY6n0oLsj
	 egh1/x/q+VlvGdpvQF2arxmtPry6aRneHjRuaAcy1YClkPgUC1Oke49AfQL1PdO0um
	 qdQnuZ7ukbcD25QY0ILI/T23Kiw1Z11Uo63vaVq4=
Date: Wed, 27 Aug 2025 15:56:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: shuah@kernel.org, mic@digikod.net, gnoack@google.com, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 ming.lei@redhat.com, skhan@linuxfoundation.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] selftests: Centralize kselftest headers to avoid
 relative includes
Message-Id: <20250827155614.9e441c45c0612730bcdedcaf@linux-foundation.org>
In-Reply-To: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
References: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 30FD340008
X-Stat-Signature: shyd6kciwnsu8bzc3btkacb5wot4exqs
X-Rspam-User: 
X-HE-Tag: 1756335377-626589
X-HE-Meta: U2FsdGVkX19phYSJbKK6d/pgURSnxPRWd2kqllr+oiuwdZPWGDS/sU+g+p+evmUsbAqaDGX/PgiSkpGf+TQNcKmC9cNY+u2mFnut3kirf+1jCt6fzjBHOAxPkVAK9OVxAXR6lgXMX800DazFETuqfq8TQ0ojGmbgSi+/WWNO0zuSJVuGOiZV8FCxyoPLDB7ZNrHeEHZmcKeTjDfyXeTcPXMPv0p8JMA8dlVacUFH9lCrrabiX5uaE9doLc/pK8kMC/7elF3P4Dr8c/lgkwpiZtLZ9RjsX9134cgr7CtKSHsMCE4RE21ZTHv322x3MiqxkGht6FOgW48ANM9ScxCmGbAMaWWIU1/RpP9I9QfCWLbPdkNsOkxi7BVdx+ows8E4Z+8LyrM58Ho/o229J28IzjaSmSNTiCKFU+QDS4vx21oLOLzCzBsY1wxf2bGiyF2N6FwHhNW7+E76ihHbLOIg0pM90Fsi2TWcoJOZAqYzPbIkMFbn7JzGG2o13bZYdhrgq4kQW9sVGJxTihy4Dw4PBdrBopyXgeVfGCZPOIXOqL7D6YOapp45Scyfjw1bbHUhBy5fIkfC0QOc4fHQ4/2Zr8YWibyMdokcxNsD/MQSzOrgMwh3WwP4e1JEFRoX4yRVI0ygUhf4nY+6P2hjS0BuTt3lkSwF5X6r5tWn9nyHvW++Giw9hQQDuABmi7YaeNcOZPcqctkcxgA4vAN4ki3AfAIWHuOecsJnvhN4cqjd+nQ3LAYWIoGaKCWhB4S3hn6wZ0q41eV3pHQmVxh8K+nppEryOuX6bakhpjWK1/cb2pZa1HvN+aWK3pActPQGxDeNL6E5FqGSTpDqE4PyPvECoyJuT3TyO4PSZ50rn4VsKZYtvQWZBk0L1hmRk+0HPIc/FipVk/bcuhUJiSboUHV49sHnKH/SYhL8XIZBrjGDa0wdvcojt1xD497+Y8Nyb2ewzDhf7pTJhFb8sMXVy1N
 kilVn3wt
 pfuWgu6vPMgTYofQh8egqunsC0CMW2LmgErqnkx9z6Kuq9JgOWE305Hxulj6iGwQm3ucIQ2p6m9jGBxXNIFQKrQZXqCpi1kV/uctXvC5R3T/AFtWRmzndQ6wDM4/ml8s9k2I5vYZ8PBn+jt29UBYG4bZ0h5Bb0n9StmCulFKxH3I7ahjJSncZJwX1pj+OexWjvxtl496gzYAEu25pssQyJ+QcZHjPG8zTBkOWJdHT68NbLcH/gZLXPbL4I7+NLKykSb80JEc1pf8WLVhXteL6jc3j1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 20:17:31 +0530 Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com> wrote:

> This series centralize the handling of kselftest.h and
> kselftest_harness.h includes in selftests, replacing relative
> paths with a non-relative approach using shared -I path.
> 
> Patch-1 updates the build files (Makefile and lib.mk) and 
> include CFLAGS in sync/Makefile to resolve not found error
> Patch-2 applies bulk source change
> (Patch 2 is large but it is replaced automatically)

Cool, thanks.  I think this is nicer.

>  280 files changed, 286 insertions(+), 280 deletions(-)

lol, it's lucky that I so enjoy fixing rejects.

