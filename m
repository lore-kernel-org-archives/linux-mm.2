Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0290CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428736B00F0; Wed, 13 May 2026 09:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9146B00F3; Wed, 13 May 2026 09:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C2C6B00F0; Wed, 13 May 2026 09:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24E2B6B00F0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:14:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC9C01C0055
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:14:44 +0000 (UTC)
X-FDA: 84762441288.07.299758E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C467A1C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:14:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VxTEoFp6;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0CL209K6qHv6QEIUe8SYOmbN7aRQxa2bsOITX4Z95A=;
	b=ZlQzxxih1qrZLpOMKv0+Gl9R4KQ8TvnQUouKgDMWRjipEXmkfsMBADqvGFzhWxH8k4nrx5
	RntpfTN/+sTe06AWk58FBL4vJ2NHofZc3t2pgsMBEx/OXnTDVF5t9C+2bzsP50XIqjTmCZ
	fX5AK9N+63SFccmgrim7nA8Lr68BDbw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VxTEoFp6;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678082; a=rsa-sha256;
	cv=none;
	b=G0MOCdG7fnKtcwUJTwI9YBmWKfNBCsg0LmczQSDnigYUVk8vlabrYZcmHNwdjp9s4bAb81
	+2xfLLjtyY9gmfKoZbJKGcW00mMW3fYEgFs86vd974mtnuOUwHiLBsaz3eU99D4rPLY5mD
	/oNaR/8hJUnHoK7unYLgV0R15nh2xEc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD57943850;
	Wed, 13 May 2026 13:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6488CC2BCB7;
	Wed, 13 May 2026 13:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778678081;
	bh=iGtJtZL8kwA0OqD4D90M0XK7ZVj3HKnLRcD3fRO4Sf4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VxTEoFp6hGdR2zjczpWedca/wi1AI/awQxJaRCuuFnrqfxSW9MIxwOdoCxvAtdpTm
	 M2p21KPUvNk/sCRBPG2gb8+iuYcbaBRBWHKmi/eRi+y9yCnHRUDvI+QQMvypsNTsJY
	 xIccEXHbpixdgZFDebuUdzBHrcU94Kez31xPB0sblHcsK9SNpDKXFimE9XcFqz1ag0
	 CpSddT1aQjW8dcmmavo+ncjdqPijLW5WFx2TFZ1wTbdETd7xKJprTs6dvlETrFMwSW
	 ZtbmG3EHMpxa+fNn8LmOY1S4iylYD5yfLWa+jUOWO/luk208RcSGLoXzYy4SvtrPQN
	 mrIv7PPlpnmaA==
Message-ID: <f25f1ef0-5359-4c00-920d-cdfc37cda968@kernel.org>
Date: Wed, 13 May 2026 15:14:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/memory: set mem->altmap after successful
 device registration
To: Georgi Djakov <georgi.djakov@oss.qualcomm.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, djakov@kernel.org
References: <20260513130900.2204499-1-georgi.djakov@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513130900.2204499-1-georgi.djakov@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ij1nux5gzy3wnxrrjruyjbgmedbzkcjm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C467A1C0005
X-Rspam-User: 
X-HE-Tag: 1778678082-47407
X-HE-Meta: U2FsdGVkX1+H1dtVVtnafA0lGAXmZ6JBAlW19zdFn40faSWGwVyMfmOf9JsFkGzSYWr0Ayq+xRcUhk5fvlNFvK755E//Pwi9nBvPxwOz92d7rVAMS7y3LkHDuYnTAyHIsP91Q6L+n5dyF7znFYto8h/eoMf7ATl/hE8GKV2qxYlorjfoRPW1BbMoQ0es2uhq/eNhjnzc+Z2YqZtj/zKTTfDmIpZ2Sx2wdoLO0704dFnzU+JtUenzVkExIr+pcn2NzgV2Q8i7ZcLGkTwaogJfFif4sEw9aEg7HprVqbgAlQOQEfcYopbnUaZHo03oLMOuyxzvgQHlrvZ771+hAiYtImZzLVbe0CIJNJu+JCZEgENCurAM/MPT1V0eCz4GhpM09i3252XgglWOYouLq8hZRdIvBYyPXTU8HpknxHwOZJFk8WfGdQva+HyGUPAXpI8y4WOhM4yUlOxVFlzDT74No6qUOJx6633S/BtVk6FrhAPuCjJdV93rHZ/TX5R+TVuyHXu8rGzqClus20br+Kzt7oPDUJpg4wDvxn/iH7AiZqW48U78mZz0aH38Xaa9L2GsZ7hy6fp/lIp8kYKXvhQqYFQyste2Q861Y4pIJaweUnVbD6O1W6qPKZD0eqOPS3Zh0lwgx0gUCx3CC+5p4BNhYEWEuInrK3iCcZ4OJTYMpy4hlkIPKXRFuyeHjauXxcjl092in6oMreSg1pDMpVCTVttnFeLvLi0LZy4bGog9rLXYUtkuRz6+jL26RwAFJvDnBpcollSpwinq21PdRM5vsqBsfmHxENCfshP+CQ5BUws4wvkwjsvgpwxjc/V1v+scjkhfb9zif9h8DisYhfKsRYqekwNP5nuF4s/djyv4xcD7a/KAERyHomuKjAHwypszDaL9aFxx5Q7riis8gfQXGNLIT1IFOLrPR++HEIkh603fkKwum99qCKhFtduP5H9tQfeyTjMA+rYMDMgr5xT
 /905M/nr
 SJhcM6eijt0xAQxOKJqv1o3EYIidlVtdGXL9KYYk2HJq2aUVUL8meJM5mPuOmECuEW6gdEQGOz1vorostiWmW3m/CXy4aR4dEbsZrLVaxlhcivT09zEw65jBDr2Rr+9nrBlzHK/2onfC/0nurXEeNlLfwWPBXpjIEcqxm/pZDyqY/EuxyHkiQitipwyeLPJbmti/aZZNEHuc7PEPVzQaMQuJP5lMOnG1PKAO1aVVjQfPbMyckMtMtiXM2n+hk3568oxs7pyfPys/k/SPK4wbWod/ESA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 15:09, Georgi Djakov wrote:
> If __add_memory_block() fails at xa_store() (under memory pressure
> for example), device_unregister() is called, which eventually
> triggers memory_block_release() with mem->altmap still set, causing
> a WARN_ON(mem->altmap).
> 
> WARNING: CPU: 1 PID: 76 at drivers/base/memory.c:96 memory_block_release+0x28/0x30
> Call trace:
>  memory_block_release+0x28/0x30 (P)
>  kobject_put+0xc8/0x1bc
>  device_unregister+0x2c/0x68
>  add_memory_block+0x1b4/0x214
>  create_memory_block_devices+0x9c/0xfc
>  create_altmaps_and_memory_blocks+0x130/0x1cc
>  add_memory_resource+0x10c/0x21c
>  add_memory_driver_managed+0xb8/0xe8
>  virtio_mem_add_memory+0xa4/0x194 [virtio_mem]
>  virtio_mem_sbm_plug_and_add_mb+0xc8/0x16c [virtio_mem]
>  virtio_mem_run_wq+0xea8/0x1088 [virtio_mem]
>  process_scheduled_works+0x18c/0x300
>  worker_thread+0x1dc/0x2b8
>  kthread+0x1ac/0x1f4
>  ret_from_fork+0x10/0x20
> 
> Fix this by delaying the assignment of mem->altmap until after
> __add_memory_block() has succeeded.

Something does not add up here. How do you get an altmap with virtio-mem?


-- 
Cheers,

David

