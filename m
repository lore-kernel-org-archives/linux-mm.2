Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8E36C79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 05:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803396B0088; Sat, 12 Sep 2026 01:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3B56B008C; Sat, 12 Sep 2026 01:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3466B0092; Sat, 12 Sep 2026 01:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC7A6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:57:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43299160425
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 05:57:53 +0000 (UTC)
X-FDA: 85204054026.03.526BF14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8979F100002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 05:57:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W9QWPMBr;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=W9QWPMBr;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789192671;
	b=7n/kNYCAlx5WWOU1lPixbKmQ6PcVij5uLIP384QyvzPTLEswK0hpx70D7K3w3pCRMADETg
	dHYO2FfxVdG2/dpINU66pmXgn0NYsL8uRUZV2fUJdo8JAjnlPgpgUts62O2Beitcv4YTD8
	azHWncj40B3puzy4ymbpBRslsb+VGSk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789192671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0SBV4CnGKvvNIIMNW/AkFFYrokvu33qARejmqNfK7k=;
	b=pCT2XtstXVnxD+p6/pPPvmXtIZnezZHwmP1GjqfO+yL6AbrxUM/eKnw3nTHqzfHrwtWh2N
	H4fCZLLL1v40k5LORvaHQvLULQsUv6IXELy+ZEmdjmA0ZRQe6clVWH/+8mQ1IooUzV+Y2s
	qDQsdQyQTs08RVaq1pZfkJLECVY4pUc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C5E743D32;
	Sat, 12 Sep 2026 05:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBBD1F000FF;
	Sat, 12 Sep 2026 05:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789192670;
	bh=U0SBV4CnGKvvNIIMNW/AkFFYrokvu33qARejmqNfK7k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=W9QWPMBrCBYQPao72IDryRFjPwSSSzrFQQnrmLzru4nkSfY7n6kvfdGou8tEUsaBz
	 YXnJ7trlUURtUmQ5q92Z9tjACJ6M2DwkICOvZNuFJCGLzkDH1br2fjmd7x47mEvCDa
	 ftdLLENxCy+9QbpE3RoB2EsWDrkbkAkX7SPqo58c=
Date: Fri, 11 Sep 2026 22:57:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yury Norov <yury.norov@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett"
 <liam@infradead.org>, Yury Norov <ynorov@nvidia.com>, Chris Li
 <sparse@chrisli.org>, Alice Ryhl <aliceryhl@google.com>, Andrew Ballance
 <andrewjballance@gmail.com>, linux-sparse@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH 1/3] compiler.h: add ASSERT_STATIC_STORAGE()
Message-Id: <20260911225749.8727d23eb76b93141f08e574@linux-foundation.org>
In-Reply-To: <20260911221444.1523311-2-ynorov@nvidia.com>
References: <20260911221444.1523311-1-ynorov@nvidia.com>
	<20260911221444.1523311-2-ynorov@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8979F100002
X-Stat-Signature: 38ioy5pe5mgjmkkhcgm3g5u68wtnwamz
X-Rspamd-Server: rspam01
X-HE-Tag: 1789192671-608195
X-HE-Meta: U2FsdGVkX1+AF3R+lNCiDOnkih+DU6KUV4bPpr/Rw2bpdPIVekOcHGTiidXSkeeQHWqgImU5hn6frDAwwg8h9TvN8zePdzakXUvcIaKiZodbyGBnn9G508OPf8XBdabUAhSO4rxGvvxz6VEcHIDJpFOkumTJWPGDynLJjvk2cV65+kug1nmQTEcN3FSsFTE6KtPekEmnNJOICmvcZLN+m1fEtM8mfrvrhoGipK70nDo3g4mSZnUmZrh9zfs4eWn3MNAwwSHm/Xfe/oa/IQPMXn/m3kgjUpRQtCkhr3CRLzBSLPH5WoxUhBaOnt62GVXy+tLDeNifNKYfkXDcuK4RYYgjW4J7tys8yLva278XDulCd4dO6y0DQ61XCyDfq0p/lzLUr1F7334fFfUpviqAwGLg+xi48WxpJiC4xgVdJ7RZ8Z5/RXTJlPZ1mkZJMKs8sdNTtV5z2WrJDQEYwshLOPip9Jf3IWHQzVIIjpj+hSM2vRa5DCL62G0ukfOtWCYdFSOeXHiqSd612cqmsuqTIowwQjGZ21D6+PYSo/+pFFOkjHKtk645MXJVkFjAqlj42FGjJhaNE3l9hnnjvxpSz+BOQIejJtgpM5bwMXvAfh0N5nGgZ0sL24eV9qv4BjrvQiG29K4Lq1t3+OHOjL55edYhy8evH3wzbabI4uO1aT4PQ1m8ZT77BRYXVI5VcvmLzMMHi2Ji6RMaQUnyBIRZII6doUIPPKLqKQAhfYzI/b/Lndq9/AH2PIalPpKDoU1AOb2R8K2/4UbH8AnNi2axWQBrlJNZq+HIIBK2U8YVY+VPgl2LNSKP4akCiZ4G+ol/NmBrqxpdx4mBnVN2kvh/qornpaOWvrPHl2awyVzfdrOAwVccPlySoKpV131KL1y0nUSTZjBLRkpTXPN8zSfI0J0VegvalpCgWsvlEM6n+SsnqWApzz7ixbOj5t4SHSKsZf+08luKyscObXBMgJR
 DbSCovf3
 rKEJ3LyqdsjYHJBwaOCKSkszyfvJpSjOJ1ALJeKgCs0kHFk4Iv7D9pSDDdgsKQUWI4JiA34ffO7g1M3HUFAMg9YNjPA7KlNysFKksi6lloLhmbDea+FeqLmRg2ByLvysTzlAB/i+AOhHoIyLLf9Uw1fT3StjSrdEeu5BMVDEx63Yxv7M7UsohEuGLuV1KpVkch5oos4s2cU7yV/rQaKVCirlw+P+b1ds8rZvSHPqqWx1adMRnMKCgrHzcmaB5EvAdvaTCXdEYvpW4PFzjIJ5CuaumQXB6E2cTVh2HkP0BieVZD22oF6C/eLOR4SCpsEdLsat0fHnJM2/s4JMWgF+ahO+v7R//OSqiZTvkxqhxJLly9gxMvwL1RPMcqteLnTS1PAPCqcrmjF9p+U5tOFpRdjsSGCRCpFZAV85gtC48iZ5j+OJ8QcTq8K2tWaM9C7jPm7CHg5c0PrWSgLz5fEN+k436C5JinK2vFwPU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 18:14:41 -0400 Yury Norov <yury.norov@gmail.com> wrote:

> Static lock initializers rely on a persistent object address when lockdep
> assigns a lock-class key. Using such an initializer for an automatic local
> object can compile successfully but disable lockdep on the first lock
> acquisition.
> 
> Add ASSERT_STATIC_STORAGE() for declaration macros that require
> static storage duration. It declares an unused static pointer initialized
> with the object's address. An automatic local object's address is not a
> valid static initializer, so the compiler rejects it.
> 
> Mirror the helper in tools/include/linux/compiler.h because the userspace
> radix-tree tests include the kernel IDA and Maple Tree headers with the
> tools compiler definitions.
> 
> For example:
> 
>   void example(void)
>   {
>           int object;
>           ASSERT_STATIC_STORAGE(object);
>   }
> 
> GCC reports:
> 
>   error: initializer element is not constant
>     name##_storage_check = &(name)
>                            ^
>   note: in expansion of macro 'ASSERT_STATIC_STORAGE'
>     ASSERT_STATIC_STORAGE(object);
> 
> File-scope objects and static local objects remain valid. The helper takes
> an object identifier and must be used as a declaration after that object
> has been declared.
> 

Thanks, I'll queue it.

Sashiko wants the same treatment for a few other macros:
	https://sashiko.dev/#/patchset/20260911221444.1523311-1-ynorov@nvidia.com

