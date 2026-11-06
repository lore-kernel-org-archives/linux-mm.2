Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F97606A339
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 21:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Giqjo2Ce
Received: by kanga.kvack.org (Postfix)
	id E91FC6B05B0; Fri,  6 Nov 2026 16:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42016B05B2; Fri,  6 Nov 2026 16:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D306B6B05B4; Fri,  6 Nov 2026 16:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0F0C6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:10:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A9DD1201FA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:10:08 +0000 (UTC)
X-FDA: 85405936896.07.71B50A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E982C140007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:10:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Giqjo2Ce;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793999407;
	b=R15pn5AK+E6b8b3cthPcaT1RU2k2EUT8rlZ0ofF1ic5GVidnioN9W2MktBc8Zlmj9I02/X
	+I74PfMRlMiNnT8n2fkuVDnhrv6LmiVmGDr7m/h25S2rhvfrd06cX+pJkg8wssEKAIc2ZS
	rdygM/GkkhIgxnhW99S43XkGJqymd48=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Giqjo2Ce;
	spf=pass (imf26.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793999407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=To0Z/jX4wfVG9baWyVxWTdD5Be58PFm2uiAc3VkWvns=;
	b=TOIvEz/T0ye+eTVMyIEdgWjBZRRpTvmi7zLL33jdkBBFIPM7kJ7RCdClHCZCvjh+KL097a
	Bd+EeTn2cOP9UX5oBuFl4OxctCRM+k34zzjrE1mRgBFpZPHF55lStvSCcgodYHlzo6Qb/s
	rZp75d8PydjyzkXTNvRf3REbsUFylTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30D9860052;
	Fri,  6 Nov 2026 21:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E661F0089F;
	Fri,  6 Nov 2026 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793999405;
	bh=To0Z/jX4wfVG9baWyVxWTdD5Be58PFm2uiAc3VkWvns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Giqjo2Ce+NopmhmRaiY5iJk0dFJnI16mLjdGE5rJh4qXwjO9MstWWzlWAn+tYbOFP
	 1XiIOHUZvkhvQU7ULmkIeK1Zg2CvKlvoAG+bWnJAM4EzDNXuLemkGlY1MJvQlakPvS
	 s7ILKN3SE8s2UK2cExOdMo93LqaZwTZj3KP1fC3O0QlHl9eOgFLkmc7gg4+MuPPoRj
	 GC6KoF34Ah4I4vDr2NWoYNbpwXzqICEDQi/IJMtd+weysgskmTHDWVBwil6AZDEODW
	 qLoJzryDTxS/9Z9VoXzNIJoBe784lmQ9oHUBuEC9XOUmRkgQzu9h1zIhvnaaw6Wly9
	 nCYj2DryzOoZg==
Date: Fri, 6 Nov 2026 21:10:03 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, chenhuacai@kernel.org, ying.huang@linux.alibaba.com, 
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, 
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, qi.zheng@linux.dev, 
	luizcap@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v9 15/32] mm: swap: share swap-cache allocation error
 cleanup
Message-ID: <au5CJBMUUUnDwbhe@google.com>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
 <20261105183940.2236717-16-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105183940.2236717-16-usama.arif@linux.dev>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E982C140007
X-Stat-Signature: hu4eusg6tnrq15kf8jd9d94tcmj7693x
X-Rspam-User: 
X-HE-Tag: 1793999406-681547
X-HE-Meta: U2FsdGVkX1/830VOJop/XrXy8sLh1YFmNuxqN2iQAHthy/p8+83MFh0J9jCZQheO/2r3+Dl/Y1KACgN+IS+Ju5euOT+313eMEZiBIJRXjelMpdFEBKET9iOjvK8+jiDI2yslFxpyLK/IfO3Sx+EBKf4+uSJT92xYLeGKEDzs4idWUuh4IBGxR2NByNTx8/3vvCDGgUzTGztFFNA4az7a0CvOOU/5y8wdbvAmq4Fzv3bKGK45ixn7/2DurID01VCtSoIbiUZ8Fwd4JtxvaNzOuO0jh4qvQy0i9ilIFT/dfYJK+zvX0ndzViXqyujNtgCiDypd9RwTEY6loEOGPYtPl4uztysL/MAZ40sJcP/vMvbWsebUJCAX+Y/0OtWkWN4RheKbzcN8h2/Jo9KJv1MSy5cFTMxOFBR1SC2vxtYZa6b8u30Z6I6r4X6GvO7P8Re2NqvPKNpfdGEHRcmS5CsOeHShI86zqUbu5CRkXUFC2l6a0f8W3RFvI0PNiy7Gkvv8uRDfdOlJTyGV1KIA/fmpeoo1cQw/gi7MXREZYMoNkFTBYKnQr5iZmsDTf0Mon1gjXkGzCb5Iw9Qek4qS3ekZrSz1quGFQI4AX8jguZNFRDIr6K6EmeHPLf16zxnzxZvuoy/CvtnVI8y9lZaWqYFcICr4kumUobC0912qrMrJI0Ay9ZZ4zZcDobQvzLegtXmNUVkcQM1YGjdZiYPmd6qtb86rgUGZFJ5JeQ+0N9CUu5qkeVL54xbiQhdOMa07Zq0m67yPIsaXdo+AtMZT+kEKDUxPcrJynrxoXifuBHcXlx+wBy/fOr/UPaJzYC7vdHpxRjxj6kEDb9jh1v4qET7Ot0feymwFcQgWTe/A9XcDQ2IKNhRnP8Z745iQGkWIo0PttMpxOBP9CyNDKAPyr4Cf6U5T1xbQmalt8CXkPbPvIiljn4g+Wapsfv4fbg9M7nJQF2mSrI/x8v3SSM6hruX
 RIPnZCKR
 TBZKEggmbyFTKmKgQmY3MCv3hhZs3oMmGllvdpwZveqvRsZiJAl0TeRwFbOZpBP0U6X/3EEASZnIykuHCjVRdnvgW7W4/s5YPGzjrutRu7i+3w2rw3P5diYjRkMBBCNR/i9BtO4WWvqKY1GXqOp8cEGv4xQMUkkpFL40ljQKxttiD6oH4ZFgikBuBZT21yCsYRvRfJsB/4a40IGLSAWNgeLmpt5w1F450CipjudK/deKzEyx2L0y12psMwieIHpmnHGBSbpJJYxx0B2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 10:38:59AM -0800, Usama Arif wrote:
> Both post-insertion allocation failures remove the folio from the swap
> cache, restore its shadow and drop the folio references. Factor the common
> cleanup into one error path so additional checks can use it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

