Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C85C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093F96B008C; Tue, 25 Aug 2026 22:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D6A6B0092; Tue, 25 Aug 2026 22:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E7A6B0095; Tue, 25 Aug 2026 22:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3D336B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:58:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47BA98022C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:58:35 +0000 (UTC)
X-FDA: 85141912590.30.9EE5716
Received: from mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 681A4160002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:58:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AB8vY8u2;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.49 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787713113;
	b=Lfu4QO3lwLW4c+jR5p/ogCjuylHL+FD8FdlD03e+cNWzGdihJPz/oeZuNEkUQqY74UhB8i
	HUC9WHC4EvFwof19zTA20kmmCaF1l8nFRCPzwlqq56oK27lzPo1NRQpixMPcb9nvx/k9O3
	CVbc5cw/zFyoDv0eF/+xge7/RS+3X9Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787713113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+M0NsYDBAb2fahCpyUMqDlmNvDUwUa4h1MgLRijo3Rs=;
	b=lRVXagzuRPgmPpSxFgKFXZ7sQ1x/N9bkpFi7Qv43tlvbD2vU95UVyVYtpcw24ov14CXJDt
	Fs/MZ7TXE4pTCN7KocXm2AIqVedebwt5KE3E1f/ImWBqbRduty1boYUe8QcXE9THTKP9UF
	Xnur0zgkIY3ucRc/jPCMykqM3RsNRGQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AB8vY8u2;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.49 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fF9gyDjEs6+vYJh1yDRz0c7p09qLbkugpjcJbmk8Xxo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787713111; v=1; x=1788317911;
 b=AB8vY8u2Y1krS3d4WbUP0O2AxFkvf6xT0K55C17dENL5YVys3Dn3HMG/S787ABbjwImrXpNI
 ZHxZioRbBMl/0cauQCL4d5mH70IzF0dWczB2F5eOSa3w9RcVCAOfQCD4qgXOoOmPQuYY3PbE7ZB
 oMbGHs4OtQlwrDDaWPov7xw8=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 61c7a6b2cb34e485;
	Wed, 26 Aug 2026 02:58:31 +0000
X-Mizu-Trace-ID: 61c7a6b2cb34e485
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 10:58:26 +0800
From: Hao Li <hao.li@linux.dev>
To: Longlong Xia <xialonglong2025@163.com>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH v2 1/1] mm/slab_common: reject zero object_size before
 calculate_alignment
Message-ID: <ao5V_CkGfLiBz05R@fedora>
References: <20260826015506.3178758-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826015506.3178758-1-xialonglong2025@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 681A4160002
X-Stat-Signature: p5zxc4jhmefsgwb3eio5wc6b48zf3nes
X-HE-Tag: 1787713113-571924
X-HE-Meta: U2FsdGVkX194oNqIj4+HABNO1E83DP5PDrLv1b75D5WotbUmvcad8B1zyI/jk7vNekxFjLj/t24VpeaiyTh+7FHDFLvUiMU4SHKq48ahmMYAsrxR3YwdxXH6KvyTsF6tdiTIWlME8npNwWwtmWXjnR/IysWDGVZnhKFYGPtCeFdkIEm8BQSlz4qYT50GeqmdwcbrsfeAcAULrrG7jKaTw5+FILpglCzG0RrStK6Oy0bm4p/960nBTvkBMfXiRvcUXE0xZiKp7cBwxn2I96H1RDpFqUei/cLo56AOBYip9T58oJntuY3S1PO9EL0x3LQVA+vomRV4UbgATPiqTEhhv3DSirk3rNqIY6nzBl5wiLfXcqE4B6pUjgJeVuTKDL5z+jvWPgVbciAA8XTcIbrOsdEwsJscMiFJJ1gGMJAVTmIaNB+Zk4Z98aeDasu47l6x77LIKKVHEixSwH/OHD3KuEZckcPjFrqR1vfSsl24fyu9RMKFOlZGnTUVS/yY9RrHMvqPMPvhg8NZFcTtAVlO9J9iIRruZQfd8oDrgAO3QcT82ZkWv+kkOJuIO0O9GJ/OtrOTYvaEdtBIKgsJYoO5agxqjNnkkvafAH/bS9nZpSkIr4lYIMtycVEw+JrGYeFpqmZC4mIIn5ko9mV6Vcw1GoUypXiemsaDaXFbiPi77CV+oOR2g0C6NcdPocaH12XunRT1L/Cas1MBXBDcPuYF7PiwbRRiSsq+GrY36KBll3QLer5bgETMjTs4SjAnEqL1EJWoA3qMTJ5TYLLH2L4i3Vqap1gQFk5h9XJjhpCVmbuX6U4ll4PypI1Cy+NPr8/6RAEsjtBR6C1fjg18eBvff2GBZpTT8YPCrqLRv6gUhxlKOwLi5iXCIhvz0ZN7+/HH1qn2OzUxmP0n9d8nEOWJDUCRxULXzU/+/6u4/s/+mNH+kVju5QroiVNZ0SUayN94a2S5UowsupLd+m2EQoo
 2fDnlC1Q
 qkdJOwZc7mbFOqD7bXDIXVJIzQbD40vAZdSITj/qkNPvTrlM8tv4rVdBiQnlN9VThXctqLeG3DjzByYvygNYrGiRCoa6mBcWhDg60NBL2WoCCUjlnPGyM0XICRpe7lTRJXQIt4IPnoRhWb4cRHvXQbTKKw2QFV0uuGAR//DJnX9awQN6ziDXOGf4qwwVCTI06aDmObgKJ1kosEvM0tptoVXIm0aTRkN0ADq/lkVl8RY7/OWHQVZAH+Pt3IeuI6SYV5Y1s8lXxYJXF5anldLbFBM87RPGBkKtr/mSoFXYHc/9j+LMm0eLZRg9PlhwSd5BdzsUcFtJqLMZj+5iQenuHTepd7YbRT5ER3zQ5vedoGrBG+7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 09:55:06AM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> calculate_alignment() with SLAB_HWCACHE_ALIGN halves ralign in a
> while (size <= ralign / 2) loop. When size is 0, ralign eventually
> reaches 0 and the condition stays true indefinitely, hanging the
> kernel.
> 
> kmem_cache_sanity_check() rejected size > KMALLOC_MAX_SIZE but not
> size == 0. Add !size to the check so a 0-size kmem_cache_create() is
> caught on CONFIG_DEBUG_VM builds, where it can be diagnosed when it
> surfaces.
> 
> Suggested-by: Hao Li <hao.li@linux.dev>
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
> Changes in v2:
> - Drop the !object_size check in __kmem_cache_create_args() that v1
>   added to the always-compiled path, and keep the guard only in the
>   debug-only kmem_cache_sanity_check(), as suggested by Hao Li.
> 
> Link: https://lore.kernel.org/all/20260824092454.1693745-1-xialonglong2025@163.com/
> ---
>  mm/slab_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 95ddbab290d4..e205a99d85cf 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -102,7 +102,7 @@ static bool kmem_cache_is_duplicate_name(const char *name)
>  
>  static int kmem_cache_sanity_check(const char *name, unsigned int size)
>  {
> -	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
> +	if (!name || in_interrupt() || !size || size > KMALLOC_MAX_SIZE) {

Looks good to me. thanks.
Reviewed-by: Hao Li <hao.li@linux.dev>

>  		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
>  		return -EINVAL;
>  	}
> -- 
> 2.43.0
> 

