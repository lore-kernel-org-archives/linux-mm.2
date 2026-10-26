Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEE63606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i5V4VCQr
Received: by kanga.kvack.org (Postfix)
	id B16DB6B05BA; Mon, 26 Oct 2026 09:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE4C6B05BB; Mon, 26 Oct 2026 09:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A072A6B05C2; Mon, 26 Oct 2026 09:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF786B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:39:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F14D9160769
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:39:46 +0000 (UTC)
X-FDA: 85364885172.10.0A180AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5EF37180005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:39:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5V4VCQr;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021985;
	b=Pj7HRhrbb4Kzt5c1P9iKuqNI+hHhixfIgF8PEXmRJkS05BzGXtnC49Rj7uyfEBo8vaLk3t
	vrDqw+QL+jLOk+Hc1pzmMxSnfz4oWcxJnPt9O8qPqVCnhMHxqKQaa2js4TFbAMBNSYDYBo
	y2FG+K+HGwX4yRFDikWMcfqiojZbBhM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i5V4VCQr;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+29/JeDTgI2q6Zdd2oPF6MhnTmquWtxwp3oevCRZyMI=;
	b=Hc3CeCONf/wuv3P+KTTlOJo2MefApvIm0e+Wo5A5/FKDBoMscEGyH4ROFRgI9wRd265Djd
	xUasUKFi6YPIp4X1mLrZ6KY6nGvnljOCXVMiXQwTtglI7T/nKlcC3VNwjeYfKZf5bZVjwJ
	T5zVlb8aGXhDSQE5JXeQuMupd+fVUIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCC9D601F9;
	Mon, 26 Oct 2026 13:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DFA1F01825;
	Mon, 26 Oct 2026 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793021984;
	bh=+29/JeDTgI2q6Zdd2oPF6MhnTmquWtxwp3oevCRZyMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i5V4VCQrdHU+uG2pJYqRPhqkSzGsM4xSLU1XJ0z+Tn+sGBvGl6PS5AjTKVdmcv7K9
	 UfzYyrhEX+CTogKDpTIY8lSfX1ObveUxmAkok+oz+mpAYPvI8fHZHyt0umP7bvrRHs
	 BeNRToBTnOZoQW8aS/ryia3YZ/4UTSkJso5hJLv3xJLZ2C51/dd1tulN+/RHimZul7
	 DiXbkdNPUq/Nv5Ktmq35EoqixXG6MoyeZZg4wNF0PxRH4sBVkkbdL3yOv4vcKZi4tz
	 BpWuka+s9hoS3MQ0yrRcYrO7hYd8o7kThsrGemf08Ua37ljn+RT6XbUviQ0AeCcBh0
	 YvlSe4qWWm1Sw==
Date: Mon, 26 Oct 2026 13:39:39 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Ngoc Quy <ngocquy0700@gmail.com>, liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
Message-ID: <at9YDZXEccL0a1Pn@gremlin>
References: <20261014095540.3261469-1-ngocquy0700@gmail.com>
 <20261019174659.42c3529d5e35563cc6e5244c@linux-foundation.org>
 <9aa49812-1132-458e-9bf5-6dba8b476b26@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aa49812-1132-458e-9bf5-6dba8b476b26@kernel.org>
X-Stat-Signature: 9fr7wspjupkhqonqhppre3ekmngxedbx
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5EF37180005
X-Rspam-User: 
X-HE-Tag: 1793021985-73578
X-HE-Meta: U2FsdGVkX1/aRyshykUPKZ4VL07ZAN0UH457ON7QhwwPy8PC9YjKMogOEyvAKLp03IKwn8FPVwm+oYv0fgfv0IuMlwcVFgsqyWtWRiyyBbD0BPkp9tVvYCOm8ly6CgzOlZyuzg/TbZMZqrzDu3zgQ1T5mWoHAyPA/c5KgLSs8YoiN/fmecm7np2aBxpYVqKFmA2wP9/6BqHCK3MoRXS91kP2k39Ep69dazJnpbWLo8M1UVsqC6ybcoW7S5Onzc9yPBh1FpolysjBWFarc0FCcFmbuOetrQCI2x9+Grjf0j2m4K4VM/WQ4V/v+wPzmJUz3/W1W/qBV4ssxDf4BUUgaB3e2A9ihjbr1Q7L8/4CfZYNNdNIZG4gy7pSZxswC1UpaqccL3oVTXUv75YRwVJD4QpPLLo7sEkNDeMvUJgSTNxHAVWvldWtJccJpKs05sM9BRfiMBbdpF+He/YcwR0odq7EDK5iHKXiW/z2YJp3H4MirNnE2FvFUObNFZb9noG6oR7wGdEOpCp9ZkO8aCpA3m531PDf4q06mjRVklR3geVy2NsX/QrqZk+BIVbP2kaQ/0YAs9WShHzoJb2zIuRDhtQF8eeEnpSdSqsSUMC2JQZ2RUccx6ydf+ka7/4/kN10/uwR5OfU5kAKWjHCQ74kbhWH3HuD7VSPgHhIEXhInERufjqNr3npxoJIplaCOaVaHvifBWNXB9XXjJmdLc7QpWFpneWSRrUQoMPVYIWko+Keg+1KpC1mL93QYvBxN3dVFp5EfBhdk2ig6zSFwX8H3iFj74a8m77dwIfR4Gr2HnAoXDKvJEsjrHbYsnBRVmNbyBJpawyHCu/hZMx4t5DqrhU2P446xaPBpkTqfDLkVAcVsq5YGSVbq6zONSzAWsBlhpkMghqBoqRQeVWj26VXaF7dMM9ga9dERZsQjA/rZdLbvSba9k1V95lYIkVz3ySC8m6sGiRmyGaBGxl4sO/
 f/hk3ntf
 6d4AHj0DlY9utiuOUCwk7LMKhlPgO7LWnwoX4MKK990pDXBnwkJL9CuWunlFbRYFX3nOB/bItR2ZIO5kNRvLHxV1xCvh9+U0Y5pToqXZ1g+T8TnC2E0MlLDdwxj+u6wKHsUVGh4Lh7XKCdXfOgEF2prqVRFsuUb9Ul8+iYCaGb749rU/GaFyaw+uFQXvMZ7QjGen1X9HKGMadpBM3evXeN7UGNBt3csSXBcbps2FOtl2E5qkSTRn6DU2gi4ql5B/5O6RvG117Cg3O0TXAF1XQQUdIeEFzqEvfuz05Fg14SbvT7bQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 25, 2026 at 11:55:59AM +0100, David Hildenbrand (Arm) wrote:
> On 10/20/26 02:46, Andrew Morton wrote:
> > All looks good and checks out for me, thanks.
> >
> > Except...
> >
> >> --- a/fs/proc/task_mmu.c
> >> +++ b/fs/proc/task_mmu.c
> >> @@ -3231,15 +3231,18 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
> >>  	size_t n_ranges_out = 0;
> >>  	int ret;
> >>
> >> +	if (!mm || !mmget_not_zero(mm))
> >> +		return -ESRCH;
> >
> > Why the new test for !mm?  The current call chain guarantees this is a
> > cant-happen and the current do_pagemap_scan will cheerfully oops if
> > mm==NULL.
>
> I'd just keep it for consistency with all the other checks in this file?

Agreed.

--
Cheers, Lorenzo

