Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2EBCD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094786B0092; Mon, 18 May 2026 05:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06BF46B0093; Mon, 18 May 2026 05:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEAAB6B0095; Mon, 18 May 2026 05:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDDA96B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:49:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69B241A0895
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:49:57 +0000 (UTC)
X-FDA: 84780069234.25.CC84E28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9D2D312000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:49:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b8gXKnxt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16aBVxhO3kRrMQW3df1T8KGl2kBBEMNi1fzePq0RoVM=;
	b=PeqdnnPuV79HOupZRtm/OQk3Ltv6Ke6nQkf4T8fCdtUsBhSAMSHVZx4WOfmXaLS4RaId+B
	/7mRiscx819HMpu7JG+tDTuxU/UDuR0+nSbxbguYVsu5C4eZbIMZXMKPswvpMReZpn8vKQ
	10FxLwdeYzxrideCUWipq/fDtoPYank=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097795; a=rsa-sha256;
	cv=none;
	b=asN+l5zaG8qL8Tx0i7gBWnx2TdiiTLavvicHQaG/cQBSQnOkqNaGENsZospUCbG93l8xMF
	BYKq9UPOU7uG1o+uCA9I9BlYA1hhKpMgXlceKjvWRJTGSj7yRnxzdJFOrQr+tqhGWzZpu7
	Y+X5olSojEyQq3XWMk9CUXfIp2gtedo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b8gXKnxt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8D7743CF0;
	Mon, 18 May 2026 09:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72607C2BCB7;
	Mon, 18 May 2026 09:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779097794;
	bh=UNp7ecYVxpOGAW2Bt0FyxpEAXPsYSA4QEoORERoNuV0=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=b8gXKnxtilovGoQt/RW1o8BSCQzuOk6OOsKogEbG5+X+5fsPrd13d3yWs33JrzPxE
	 Gj3vFj9z4/d79ItKHtTUfqkuOboknn/zrESvDETRZ9IKQ39gjg6LiWiylIqboU4qr3
	 weDU521lqSitaLkIecXl8igajFQiCgnH1yRMF7tlzjPTnWZPctELpDNrtqCcNTSMOq
	 2sYmLkzCslwP4Igx+HoDgkx391ulyU86BS1jEeY89KhFrRS7uk4s7QkyQ74xHfHeF7
	 6JUFEGMJLgtx12YfkXqcSYs0zqTkfkmC8ZB25HykE4fv9eGJ8JF0fNniD2rFB81jg1
	 JuWIaD2XAXffw==
Message-ID: <1fd5fc85-c918-4eb0-8b57-ed09479a9770@kernel.org>
Date: Mon, 18 May 2026 18:49:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: Re: [PATCH] Revert "mm: introduce a new page type for page pool in
 page type"
To: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org
Cc: kernel_team@skhynix.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, kas@kernel.org, willy@infradead.org,
 baolin.wang@linux.alibaba.com, asml.silence@gmail.com, toke@redhat.com,
 netdev@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260515034701.17027-1-byungchul@sk.com>
Content-Language: en-US
In-Reply-To: <20260515034701.17027-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D2D312000B
X-Rspamd-Server: rspam04
X-Stat-Signature: tqbwgf5nyezen91jdnz93gqnobtxwfon
X-HE-Tag: 1779097795-797273
X-HE-Meta: U2FsdGVkX18jTAYUCEbOfNd+KgGvBtgvOe3sgScU9SZ4CWEmHIK0VGZ3che5jP5ElKzBdiHv1bFrg/Lu8MPwzypsKB8JTmusS4+vILhUyI+G+R2X6DmvEPPI5MBe53bK/orIaToAskRHbdMJbB4ZL/VfhBNuUh1bouhxZthGIx0oTCgrD9hfapbcc4g69Q0437i7ZCNtXsApu/TOLc7H6KzvuCE4Ui7/LZ+n3EjzCzQg0Fs+/s+kz8Zy6zNneNGeA5QQjo2cRhWHmJrnHKPGJWO8Syt91JJCGIWRe1aVZ6xAUZtI+rXX74RbqRbcm0MJsP+uJcfYEpsO4yB5wwxK8yv7knhqTjVcD6JyPuHs+QJIQjYIi2VqM+1BobtcsimFOrbDZY+le4smhaQqIQXqqoNd3050fxUkzyFVWk8hZt7TJVnHlYdwFyKMeFjbHowmKUEbZM8/+vdZ1ThKZRfEgiOzdJqTnhqGmx/HmJiQp/4pvbP4mXF7jl+hQmRbgn2YfCINX4KYq2FthBOQjR6tyEFNKz86Zt075Whb24J2YqNu8uPBl+nTJBiXh4d6aLZ9irdgQI32wwu6K23XCZbb/LcxDEYEL1wOyk6e330ffT+3GCBiY2jkT8zkO4M98ppb16fl89vHGDc3Ap5VW30SUAH2+Nor19lr0M4wYkUhXbizv+2IBol3Uf2glsqt4GarZZ8msFtdCcz1Vx9m1RqsqdXtgYVZywmslpNC98dRFaT0G/nwceEGHiroRYdY9byHSYDOw8wCo6MFqxexBDQs3BoJqpQHappNhbjvgd2NuoNdUT1dAlXEeonUUdeCHnOj5sVdKh3RigWQvqEUlod14wzqmNDP5JpZ0hqrxW/ajzS4QTA7Tyb+vI6XEy79LRTkX97ZjFcoUxzZ+iB3ZYfrkeC7sirHVDwtyIPA9QqoIa0W++/KnMReoQWfRR9RsL9ONIva11CltHt9vl3/FjM
 SLIGcr9y
 AhtYjyiNpBrR0adfb8PY8fpynKpwbVBTTH8+9/PB9xDlIUwgS0DQEiNJWdjxmfDR9sWJGOJmIIxaKA3kNNR22tfZdBTgXdulHfE+xT5TWVji3o85D5L2jAkYPGxtdTeq7cgVVRDM7kU/1Ov4OgBYenD5doKVu5isgcgQPjsjEjRFutWaDNt74vTAXBQNAeYKT65zDVFia8A5qHYIW8OQYuHTHpGRnY90x3pmYG72nh8QY3KPPdAeY3SHHPK46t0xdsqSA5jtM02BXvK9ZzWUIP1r4kxUSMFBg03wvsX3BDiVhd2/JjTwmFpNpKvg/Nn7If8eAV3LAR464P0ZzDD3Fuzvp+fg2HazCm4e6WQ4Xg9THRf78NVetUE/SDdBoJqW1tGpd6fEM3l9t3SGytNIm0zhOolDgtY6b29w5RWdBHgB+sRYlvArE6bEZ+G6+lW/YZ9wQ6mBjkxtQB1uGY3FVvjkIx71JnEtdavON
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/15/26 12:47 PM, Byungchul Park wrote:
> This reverts commit db359fccf212e7fa3136e6edbed6228475646fd7.
> 
> Netpp page_type'ed pages might be used in mapping so as to use
> @_mapcount.  However, since @page_type and @_mapcount are union'ed in
> struct page, these two can't be used at the same time.  Revert the
> commit introducing page_type for Netpp for now.

Uh, didn't realize that those pages can be mapped to userspace...

> The patch will be retried once @page_type and @_mapcount get allowed to
> be used at the same time.
> 
> The revert also includes removal of @page_type initialization part
> introduced by commit 735a309b4bfb9e ("net: add net_iov_init() and use it
> to initialize ->page_type"), which will be restored on the retry.
> 
> Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
> Closes: https://lore.kernel.org/all/982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---

Looks good to me, so:

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

