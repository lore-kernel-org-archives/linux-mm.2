Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7DBFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D9C6B0005; Fri, 27 Feb 2026 11:25:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4EA6B0088; Fri, 27 Feb 2026 11:25:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1476B0089; Fri, 27 Feb 2026 11:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC566B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:25:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 486C21C9E4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:25:39 +0000 (UTC)
X-FDA: 84490762398.13.A4BCAE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 78DE34000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:25:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KKzzvY48;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772209537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1DqSm3YYfIac9UuDRQEcXSBp1zMOJdumRZY5EgHnoQ=;
	b=w1mldZal4vLsMF1/QsO9fEOgVwqLIk/V1KTtQ8jczw44shogdNGY0bfxZE+DYgQCkZIot5
	BynpAmTZNSgDCDPnOzzjnmMAbWqyZc65sUK0WK3O1/xKWm28yWLROAyMCbOHHfr/anJaH5
	uhHnYOqyV2T26y1CiZgk+MbcFfopYYM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KKzzvY48;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772209537; a=rsa-sha256;
	cv=none;
	b=Kf6tc01wyQkvHbvKDKvsJWGZHHhsExa06mIizc0WxP+KNzihGytohxBUnJwmeU2I6gXqCl
	UbOTHSTFZ8QF5p44klaa7SkdoqkMwjph/aDyi/W1BMSLOsNhOVDxokmJbMe1OoZWHirltX
	r9lO/93srJB5QrHDG8bqc9uwS6e5mrI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D833160054;
	Fri, 27 Feb 2026 16:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1F3C116C6;
	Fri, 27 Feb 2026 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772209536;
	bh=7xEINRTAimo9zk78jI743F6BvgPfrdmSZbFfWT+92dU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KKzzvY48u5koshSFJjWshX08j71sHv+Vp0qJfkQtv5h4cGlYXTjGhtqg1zesBcPS2
	 OBkwaHxVe+49hGHff2PSxCY5Kbx5mkkvVgHMwGxsJIuqmPT+fV5Uaqw90dYTPBteVt
	 BdwhuU26H2QObnp6KVYR1ZQNS6hP+9afhKGinmyE=
Date: Fri, 27 Feb 2026 08:25:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, vbabka@suse.cz, harry.yoo@oracle.com,
 muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock()
 trylock path
Message-Id: <20260227082535.9c83176e7ab9f92f6b80aee6@linux-foundation.org>
In-Reply-To: <twvbu57mdw7ekw26spzzy5e6quq7k7hko3hvxttv6yjlhyuhpb@iolbg2iwsowx>
References: <20260226115145.62903-1-hao.li@linux.dev>
	<aaBM0fN8fqER7Avf@linux.dev>
	<e759dd9b-0857-4155-b570-cd002155f123@suse.com>
	<siuyozcbi5x6vusawdy3be5buho5y4qilc5uls7rgiihagk7uv@cfrr75gh4bty>
	<25f6a18c-0600-4a21-977e-19b8b4b203b2@suse.com>
	<twvbu57mdw7ekw26spzzy5e6quq7k7hko3hvxttv6yjlhyuhpb@iolbg2iwsowx>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 78DE34000F
X-Rspamd-Server: rspam08
X-Stat-Signature: bmkhtxcxbx83sk8duz771sq3tdpew8em
X-HE-Tag: 1772209537-349764
X-HE-Meta: U2FsdGVkX19sc4WqsKzaT4CdWnniSjKDczykMD1U1u/CuvAEErkWc/+jPwsxhLMiMZaweeOM17qP3klMpFm3llV6WbKsBXs7+ZtyfJhPy8aF65QGdwxzOVPhrQfRPlv+iCpuOZ6A01pRR42Re+ysuqBFC9nj0YPfOqxRUnvVXY8ZHZOc/drk16waEaM/cuq5vNRhfUmjw/nNWHZGPDwvqnhxFGqTNGsh4KwSl125u1v0saHvdVRcPm0fQ89QwznvLGemeTmcvzva/98eTt7BzX3goFqi2YaIbNEbIy7lPtok1a4owVSxOaRqSAusLxBTwvrGwiFZNvadHxhNEPsTsJv7IhTcWqxKQdvLhUM26MUj/31ZViFLqdkxZiiBQjt8aFraialu4L5wnsyqwF/Rk5ibzPo4JAwEhtvwO6X68PimiqByY6k2kbA5mhbcubYb/YrElguQmS9xprOMTijoCq3cCR4nuRWLXtxAwmjpH1sFvoj4Ml2/Qxm8HUsXGekSC6uENLS2DcP1q50Kr8UgER+DY08YbTJJa4LiNnDXhmO2Rxw+qRj3nxVuJUK4zY3qEimsQp8xQomzXzUXsFLkxU1aIsId3Q2GAqIvb/PMr9eyf7o5WRHFMWO/GM14uWo/2PTQb0D3HwNda66DEuOJaovGBe5jj+RIlggR6LlJz4hPEov78JXZJqs7Ma8/8PTSSdx0UCV3HndfAqm1nokhk/5oaw15IpmrYf1ChKiye/rIjx+AIaQZvzwQ+emx6sJqxa2wa65/JfdcVeEUIS2x5Xo/6bXg2nl3QzkdtWvoBoy7jKJC4xDnClhmtfwgtxPURx2X43XoUB6ojHACrN0Ghnp7Yxj83wpCv+yMu7W4XwFQ78ky5zy/eCEcCakqMkSgW95x0Cn/3fLvVUIXvYV1JW2RW/44rzJIfZVx2RWmAW0LoB//41LQ9hpqnGjTB/L3x3+luuhipYlTQkVS66b
 fP3DRt8f
 IAels++psKNFMDbvtyNQuOffwb1sp1qCSiZnqgJENSDKmJ+XmeVvD1bdS3Ld16T0+ibmAFYwoYQXgXreJSqp+vPfO1weODvPxTx3dmrhZlHb4zRd+bECwUbLmj51SYcCVdLGXEwzFhSJbs1tUkynPtwEY5AfAphlWRzu67Rj6o88pRQ2Nyj4GsblcJR4QEBRrBRUL3IjdgeDZR+5MiKeX1wUk7AfridEozZlFY3FBkUf6f4gBHsTK8+V+9haE4tP73hXKNhvLsiUYpndFPrb5lyabGzpQmL+rA3DhvJxG/HInJ9JGuFF5bbnMrcwe531jp66r/Lgq5NK23XbZMY1ljD3nZVyKTWWQUrYuRxFgqSWQQOA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 16:37:16 +0800 Hao Li <hao.li@linux.dev> wrote:

> > Thanks, I'm sure Andrew will amend the changelog with those useful details.
> 
> Got it. Thanks.

I made that edit, thanks.

