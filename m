Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9264606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 19:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q9kAMNeE
Received: by kanga.kvack.org (Postfix)
	id A0AA16B05B9; Sat,  7 Nov 2026 14:49:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2D86B05C2; Sat,  7 Nov 2026 14:49:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7F26B05C3; Sat,  7 Nov 2026 14:49:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56E926B05B9
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:49:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 395AA1A03FD
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:49:09 +0000 (UTC)
X-FDA: 85409361618.02.636358C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 84B5E1C0009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:49:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9kAMNeE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794080947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=quEIxWxT5Q+S3gOy3uhM6ka01cjxSecT9mp5i4V7aKA=;
	b=BYDRZeRL3sb2oHJeQTJHCx+mm3qyh59hSu46nsM508DVnJyUT1hzsEsntY1+NrgQwfmRic
	BO94JhFRojOnwuALa3IOw+KEzwbXcBQHkjP5ZZHY8AsKsaMfrfjzoprqPcmIp9JfYMLttf
	axaphZPyVWQvp4UStx0ZCsGiVxUZKJw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794080947;
	b=YE59bhVmy/F7ouDbx6oKTDMgT70mlmN8QeMq5mXqUXbQIFv/tMBnfOPqGfHmlV4fdeVz4P
	bqM5CEDRms+J6euuj+9IjbivpchRJeFvUlCinDORE6Ze2t3B4VxEhkFMuHqMZSAa72H/Lp
	1AkEe8ZQzoeKm9M34nsro6hfiNlDOSk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9kAMNeE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29FBF6117A;
	Sat,  7 Nov 2026 19:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2881F0089F;
	Sat,  7 Nov 2026 19:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794080946;
	bh=quEIxWxT5Q+S3gOy3uhM6ka01cjxSecT9mp5i4V7aKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q9kAMNeEmpMt1H6xQlnIWiQ9o/ScZQHlFtgj0GVZUjX04tr1tZYKe+1144Dh5uuhG
	 5ft+9002eIOnO/abET6se6fs98rqU/wNe04AUe8pNLOIVDVEV8/A7nmuGJRtRJdtg0
	 iliJNmBxybwkEoYfkWfmDtF3pkmu9Mhp4LRuUDFo+zKwrPlTF3B4nzOy+egJrBrRKf
	 Wd6dOEtDraGbLqSZEcE1pYZkmDKWKOA7q+0IxCwWdbCP8X/ndLdoBQ4j85S//fNgOP
	 H8QBXQo1w1M1hOuOeRxxnADbVx1wPMR8P+BEnr1a9xN6oylccFLlHhQY7oGgP3jVM/
	 g7fdvSk/sQEig==
Message-ID: <03e74c29-c6a8-4ace-9388-6a658aff9031@kernel.org>
Date: Sat, 7 Nov 2026 20:48:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] selftests/mm: move waiting for KSM full scans into
 a helper
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-0-16d5ce8b5fd6@gmail.com>
 <20261107-bug-mm-ksm-smart-scan-align-skips-v3-3-16d5ce8b5fd6@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261107-bug-mm-ksm-smart-scan-align-skips-v3-3-16d5ce8b5fd6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1jx3cwknt897qka94tcoxoxfkffoe7ss
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 84B5E1C0009
X-HE-Tag: 1794080947-898556
X-HE-Meta: U2FsdGVkX1+HkbXVfhWEEmS4igC+rRQ4DlPSmpzA5hPjDSQ3ZzSSka6EXaEJDofdj5gyI0wIIv6Qyy33nIsMLXqAVK2Lu8YFrKrsXfOdZGTh6tpcW12Gda4zWdqiNh1yJBKZJx8BlHZvJUTnVeDU0ktwX9R5FUe5ro9k8cSOlZNefRuiQ7FCDBAKL/JgzjJAzKEgrb/sCaa0CifwHRq3dVyCjdWUxu8AAFxK7GROy6vIPrLVcLuTNmGXAHSIzXUnNoS2+okmhhgmpiU/FF9rlskbWgMB+1FFlTIBnH1dXGPLyfIWmAo4NvtvFcu9CG4ux7an5MzTlU1z/bx0e/LcK5m9XR868WLYIZsGv7XRVGEKVWFNAWNt9gk/vZ7sYcC4h7FcM4PxUTV9IlWP6LDz7W8t8P3jOjE7CTiosBe7rIMeRHap3cuZjxVHFbB/+xKHGJz+tql3Jcxat5Iu6kkWZn/74p2XlZCzvXeNTgGU4AdJL7vbLn2LxDWh9zRs3tMZNOi+S33ciR0HALUbW9n70IDTnYErXQ5NnMAM7pUooo3fXYn8/YABDKTOzkFvnHYR3MXFFmPiThLdPM9H72/zo5WhvimfNBw7WkU6t+OMwU1bUPDA2GXVi8ZEOJrijInYwjEvpe/cATy//yoNTA7tOVJM/Dz2Vg4CACfzkZ6nGbP06MQPncSIENU92KM1WPZJlF7UPbWYxF5vVYJWs4oBavyE8Ai5cZnk91A6hD7TQ9cR5Rp1WyO6Sakn+BAfh5b3BMReELbhvHm6sajQ/7lEbz3c1X0Hkj340O1YS6coywFNhf5t9r/vh6nCE3b1rne/KCGF8R/jiHE1HQq91vcCYBy/asNCblTfDeQNunQ+RsAd8noHWo9Mm/k3O3vnTy9CeugggeG4BY/TMPYUowRuiwzw18ttRj1Yhcx19X/QgHxPuFgZ80s0c9EpogZckkGVEiMbsDJ/DJ9I0H6t4qn
 9EBXS+1X
 7HoFkJJhO90hAqcoLoKVjaotBrTEzojU9LBkngSPaXrxLbq5mw7bZX0Q1r1purKZFKoffvjHD2wv9djQhs+NL9uO1ryN4ww7Gk9/Hg6uZ0U1iT7aXamsTkTlDnb6Y/4j1Bk4x/4eyrEB7LSjJuwpwS9f+lx+9IQkpfyty1L3FCh6/+nT4UHEpVKW2QkXg6eyUcoXW5nHNAfiJSwnUpAqrIQwBAezaIEGP/APtF6eB7bT6taQWqgM0mBXXGrp7ex8wtfZOERWg+uxv7Sn0ZbYJZAXBqvU6BEZQgzCkURsD5MwCkI7XayN2rEFZ47U0mUJeYE4hKJwsjEBKIykNQD5Ckh4lxIMvRq72aNdJ4WJQBickVK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 17:57, Qiliang Yuan wrote:
> ksm_start() enables ksmd and then polls full_scans until two more full
> scans have completed, so that any merging that can happen has happened.
> 
> There is no helper to wait for a number of full scans while ksmd is
> already running, so a test that needs one has to copy that loop.
> 
> Move the loop into ksm_wait_full_scans() and make ksm_start() call it
> after enabling ksmd. The count is now read after ksmd starts rather than
> before, which can only make ksm_start() wait longer.

Right, we don't care about that

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

