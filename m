Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1635D606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QogTgp/f
Received: by kanga.kvack.org (Postfix)
	id 3F98F6B05B2; Wed, 28 Oct 2026 11:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9A56B05B3; Wed, 28 Oct 2026 11:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1436B05B4; Wed, 28 Oct 2026 11:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16506B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:23:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 931D7A654E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:23:56 +0000 (UTC)
X-FDA: 85372405272.20.5EFA90C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A5D440003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:23:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QogTgp/f";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793201035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoAi1anA30nDGqKRjbCzfsCZ7EvAt6aSj8TnMwEh3bM=;
	b=ixqWvPMoS/Iv/6/l1gaQls4wLzM06KOv42nGBhj3TV941Xp0wFs8bxRxA6Yw/qVe0e/qlz
	wMV84ZM/6Qw5R96jWKxaUjoa25Fus8Ck8Rby4alWgRCM+BZv6L0lAq5bxAiYQP4GiWN2R9
	ZojEd1XW9IipV06Z22afceev1HZjbnk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QogTgp/f";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793201035;
	b=3obZIxh7/6OpU2FRDvDl6suzp/RNiA7+hlUdKCU5wxoXnnQ5HLZWL3cr+X96g0udSH0PYv
	DYVnuZiSFwG47EDEFl5EA2sfm/uR5jGdfdEh1eZwHB42B8PmcMUIOXYFTnKuhLREI7kkAR
	DHXhbuImg8dNgacyVzyl6/50xRNXcZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 801B1602BE;
	Wed, 28 Oct 2026 15:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1811F031E2;
	Wed, 28 Oct 2026 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793201034;
	bh=QoAi1anA30nDGqKRjbCzfsCZ7EvAt6aSj8TnMwEh3bM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QogTgp/fyqrvv5e9CqlhTtGIq+W8x6/uxNE2xmzsUGwM/UVDak56B0zQhzPTw/XIx
	 2vW39ozxc2ZgxP3Xo/kYwlWCg95EeMGtonvOtzWrQ2DQMsRq1Wbd8osUOqjAjodSSk
	 bBv5sIEW+uMTV7S2TnA49X+RBu+dCjJAd8MuIdsk39QNfZU6PKF9zcUMqky3UxfM9a
	 tJtnlXxiNNLZI5LO0QR8saDVGrIcbvm2EPXkdTqPU525Z6mKKUPnZzmeZz1NwAmejb
	 51VSD7zVbK4RDOWqC+ermR6/GuWVtwEHvLSfYDS4oDkpMwvM4M0F8or7hIZE6ORgCY
	 UpIpC2upTbHwg==
Date: Wed, 28 Oct 2026 15:23:52 +0000
From: Harry Yoo <harry@kernel.org>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: vbabka@kernel.org, urezki@gmail.com, paulmck@kernel.org, 
	qiang.zhang@linux.dev, akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH 1/2] mm/slab: restore the rcutree. prefix of the
 kvfree_rcu parameters
Message-ID: <auIRU802S4Z4yAmo@thinkstation>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
X-Rspamd-Queue-Id: 0A5D440003
X-Rspam-User: 
X-Stat-Signature: ntfkg714nmsa986so36pzpx8pawxd318
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793201034-340339
X-HE-Meta: U2FsdGVkX19JDC/F55Y+fnkWNJ53NfIQH/B/ybxojba3rrgbRU9TFjZI2vzoXPajAOnDpembS2lyhBSskC6DHRfXcCZAxLhn0MAjkmQMBlcgXLbC8WN51yO0Nn0Hxdh1/Z2/ziyqta4O6bdZlUUrHH0cedUUC3MkgwC9Kdok2/TCee/likML0fnUfu85BplTFmO+piXmYXqWyBHFqbyOgYQqkYowDJW3cX74iXlpRmrC+g7qklu74kw2kno0U2QpCLQa/SmK+QwZcJ0Qi6IyNRpCRziZu9DnXiKIWGpNQ3g7OxZCnPPU6FmMMcsrmGRtfT8THyJjtWUexKL3IQkd5C1EBBC1Jk0heVwL5HJi9A2QgAh5qubvEVkyZvGyk7RRnypJ7e3+FM6aM087Fofu+8Czo73t97C6N7jjMH/nG8ap3l4K2wxreG/X0e281Bc5/NTsWxMtQ1ebxH8b6BcZVETGXr3Wz5gYG9j/c6IKKUWWhgFQAOvldRl+VffkvNsrClDyMSeHmZAPjQVO4dfmjIawhXlkWD4y4AwExcmWPxf/D9/zdaglolBwLGCSrGf9GPVTj2Sx3ZVHUE38EH576bk8E07xOkmBiRDQzgWZKFg1hHboqW4AMIPWxIEmXYEjGOaQgeKBz71CPHRZ5ufm10UoG6yJYJqTVhHNPDjvGOPaL9Ef/btiLi167ILBdjYd7MXfqYPQbXvxceOCMlNHPt+7lVGx00KeFP3/BTod1Y8KaJ0PwknBuP6WnmOB/a66f6YqHOK/6nFdP6bgb40WWZqZ+/yhD1Ja9O4zJS6PbjsOSp5Ujph0SdvWRQU7b7BycU72iHMrQebWi8LB/WPCJrvKxzlv+MZxjcDQfF0zOIPIeMi2eU6tiRfw6nHJ6j69g4TtYMBbSMohHlvKdCdgjDnJzBOAvEKIj7J3TF+erGLqvM4TF1P0X1CPeEx3vJTgVnOKDl3uFTHIqODSVaf
 eQ1O0eHb
 4ejKjV6FcN8bLxLD6uaBX87w/ldXl5KQMfFYuPfmzVdupFYMM/SFfQhyO1hKhHIGmIdGQ6FTt3Y3HyssumWulAvKv/8JJ6pSosXkK8jPF12CV9b0EtGuBIZ2JGkjS3I9MxbM5tHLstsfoaN/V3HdVaA5gErSQ7OohyzwcZDppdljMUzHPYIB5FnD9Z2Q0wiDXiwmG7MyfVaD0f6H5koqNKsKjriugnP9vJju3axsMOT1gfdEPqWBfIijXfwzkaMZ3Am1HvyCXKE+hNzy/mfZMGzXviubJlutyfNV0bTLiGp5BttIfjP/kfkFVijecuSEERdyaUgtHeWpk2tJTfbQlFr1H8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 09:46:46PM +0800, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> The move of kvfree_rcu() to mm/slab_common.c dropped the "rcutree."
> MODULE_PARAM_PREFIX, so rcu_min_cached_objs and
> rcu_delay_page_cache_fill_msec became slab_common.* and the documented
> rcutree.* names are silently ignored.  Restore the prefix; the
> slab_common.* names, never documented, stop working.
> 
> Fixes: bbe658d65802 ("mm/slab: Move kvfree_rcu() into SLAB")

We should add:

Cc: stable@vger.kernel.org

This is a functional regression and in MM we don't automatically
backport fixes to -stable unless without this tag.

> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> ---
>  mm/slab_common.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 01c64ef661e7..3729aa7a6156 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1373,6 +1373,10 @@ void __init kvfree_rcu_init(void)
>   * per-CPU. Object size is equal to one page. This value
>   * can be changed at boot time.
>   */
> +/* These used to be rcutree parameters; keep their documented names. */
> +#undef MODULE_PARAM_PREFIX
> +#define MODULE_PARAM_PREFIX "rcutree."

This should be moved to before "This rcu parameter is
runtime-read-only ..." part?

And perhaps let's rephrase the comment, something like:

/* Keep the prefix inherited from RCU */

With that adjusted, otherwise looks good to me, so:
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

