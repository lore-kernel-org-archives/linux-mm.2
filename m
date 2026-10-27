Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7485606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=FfiDc6lQ
Received: by kanga.kvack.org (Postfix)
	id D6CD86B05BD; Tue, 27 Oct 2026 03:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DA56B05E4; Tue, 27 Oct 2026 03:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32E76B05E5; Tue, 27 Oct 2026 03:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B16E6B05BD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:12:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26B0412092F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:12:24 +0000 (UTC)
X-FDA: 85367537808.05.53BA819
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id F051B140006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:12:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FfiDc6lQ;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793085142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtdNnLom4qpn3DvgmzGMm6xPHdf4ojR1KNUGjX1eUNk=;
	b=AnkRFePFv0jO69Uw7Qesi3bkOt6ogezjAwqQl8BlH/gSLeUCqvo56IZ98QAMxfvajvkUCd
	H9FnHBVSwOhNS5bYvT9q9V62OvBNTOBSbbg89LavOu1JsSYchS8MF74MEU1cAX19H7RZ9u
	zBqudBFzUotjjqs4fY8VmouwF79+qUA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FfiDc6lQ;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793085142;
	b=AXIiHABJiulp2v5veAmXzPlocDl2xUWTpQBJu3laFLvFpR2VfdFmr05KwM4SF0c8yLNNM6
	NRNszBCKXUH6Y2Yij7gUJHxkSP9AZZnSM4zNdojjSo/LbWTIjqn8MkNKMn0sYEm4Jpp7Mj
	0YgB/hM7+3B7LuVAl3uyIg3vlTxnyaA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CBAC1655;
	Tue, 27 Oct 2026 00:12:17 -0700 (PDT)
Received: from [10.163.152.160] (unknown [10.163.152.160])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F06B3F673;
	Tue, 27 Oct 2026 00:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793085140; bh=a8GTRJb/qeXzyezkSqk5mOqJzNR0LEKUkQ+3k+5mvZA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FfiDc6lQo1cXuVWAHm7sZJKVPvB1uBSZcBxPlRTRTKZB9P2/HqL0iAsLKLf/ssxMF
	 ewNuKCyCho5VuZn4COMZ36FF9jRRuUEgT7JmcRN66+bZPL6d1ZNnonW1F5rlGHUUuO
	 xoTW+Fk8ljZo+MhZo0XWRWOqXNpvgAySN6D+/GdQ=
Message-ID: <0757f1b0-9af6-417c-a4cb-eff0b05ba277@arm.com>
Date: Tue, 27 Oct 2026 12:42:12 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kernel-team@meta.com
References: <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation> <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
 <4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com>
 <atiCG2iPrHwDznSZ@thinkstation>
 <d2b8edf0-39ab-4a44-bd0d-58230dee2fad@arm.com>
 <ats7oFM-fsYdUS8y@thinkstation> <attOFXch_TchIfEv@thinkstation>
 <atty0n4UzTfI46eN@thinkstation>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <atty0n4UzTfI46eN@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F051B140006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pzy4nj8hzdjnuc8qnd1uqgbsqa7oocae
X-HE-Tag: 1793085141-755941
X-HE-Meta: U2FsdGVkX19rul1b89b4HMBhXVQLpzLIPbOKuoTksc7hMXO17DyOWfnHXTbk5zNAHtCv2aKJ1wcFZBfDmZ9EjQzGe0aP0Z4233sM4l9dmO9nyEpMXhxX4Uzhg/8Kjxf34D26KX0b5ZRNDX7l4Bdsrr/h9rS6mifNwRhC+v7vXL/QeWH0u/nZdiruKxzjaWwgDdjV83yUxSBMUEWVqtEwKSQG2p6+do5qvDV/QUg+s80EcPCAVbfnTWcAAP310waKCYqnAHhJ4Sz87yPIiMn6fSMvwwbb91OYPf5A6bDn+ymJzx1oSr+09sKY3ZAUjcSheQB6U+kbRZ/I+cKGZG5IxKPL+oP7f044Bf9k7Kbo7elnoYIPrYS4BwNJw1kGJ9qMDvkjbvE0rbgYk1Tk9AoSCUtHkrBiWN4NkVWX/GEVbQbQx6aBiiH8+E/SwI5876AMi/ECtJwKn8CaDomgOl9uqV9v4GikFrXCkCU0ip69kKxg05jvGBMuOF+2lVpJYHL5uG2bvgXEIdL3d08qNv1jfw+TWikUAotB2aonTCJk+EZRcxcDijgtpMc65GTm/stfw8JlcIjELx4EWvoIvutRoxBvCP8srMEXuYZ7E8cI3xY6bxV2HWTSPUUJp7vvHVf0xyCMQ+wUfVMYJZPKmluj/z82/zerRMe1/AxHeRvxZOt8Q1Is+TO5L4HgKMB297WZAmhT+9XTzSjuUz3mrU2pkL4x1vBcN5AVLexAWeRta8vsZ1aZbz330XvuCldegybqaPxs6mih4GyTe2iXzkG+2JbHDgOYHlaBQhDpE0FoG8dBCBDajS/plHbqOaM0FBLOuAJ2C8iPzE6UAjb3HLKb0fVJzgSt/gil2hVktObgj1snwRaRZQgjaSDXG/hmxhbxZAfbgiFkNLhcuVOfetxvKwclnqGH2R4yGIBw79vjAAa24Y3tpIup8gj4a6sYNVCrpc8RUVYB+f/LRBSPre4
 BqLfFe6g
 izFy5Qv1Mss/YfbDw0Y/4XHCU9DBZeXvCV7hmX7X9arbV8njFOvSJ1hQ4EKZ0zhpCxnBTSeP3EmHqz5KE1FoDc43zj1es2deIb8ANybD/eiUAw8xpTpRKpJuDagsHXCLZrEMRhT9uyNj3IcIA+qMQJlUBFWLsOIyAOsyYduZv2UiHsaWmtyOgN7g8bl7DZ99Kij2U0ziV5FLUuLUf3MyQlxJug7c7OI3PjsdOpFtfoxDoCzcFSnn9czZXOIPmFGhu/ofB6BNV3xQjBsdXNlk1AxTAQyEoXcwJS3X+lxnk1UmWfrPiIhI2YXsuaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 23/10/26 8:16 pm, Kiryl Shutsemau wrote:
> On Fri, Oct 23, 2026 at 01:12:02PM +0100, Kiryl Shutsemau wrote:
>> The diff below replaces the previous one. It needs cleanup and splitting
>> before it goes upstream.
> 
> Proper patchset:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git page_alloc/nofrag-watermark-v1
> 

Thanks! I applied the 3 commits on top and the results improved a lot. Your patches
make sense to me.

But still, I see more compact_stalls and a worse compaction success:fail ratio. The
limitation must be by definition I believe: we still won't be able to use 64K blocks
from non-movable pageblocks.


