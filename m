Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4219BCD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4806B00AE; Wed, 27 May 2026 10:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BC06B00AF; Wed, 27 May 2026 10:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8746B00B0; Wed, 27 May 2026 10:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4716B00AE
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:33:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 412AC906E8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:33:51 +0000 (UTC)
X-FDA: 84813443862.13.CD52FAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 85451180003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:33:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WN2tAxV0;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779892429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8CvBHWQDzBJDTrmMd/gPWBhN89D1x49lyWyrsxqYFA=;
	b=NtfRF/m5mPmb83odON+qMQbgf0M6iAGvR2HzzhXnbpv5lcSMsMeuXctEzAj6zZTC+uHLPx
	QCbiuaDeAG3TRLNYxAdo/i+TMG/Bk5qdozxpQY5NOZLveyW65zLCBTNHAIa30KiXvlDzH+
	cHEX4muKxbKiku0Q136Q8mzQ0m5VkMs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WN2tAxV0;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779892429; a=rsa-sha256;
	cv=none;
	b=D0UXCX7ecb75ihbzDg0utKM19mQCMzAEa3JmFN84rrJbG+NHovARTzBI2ZA7/Rrk5pGJ9R
	1A+/RghlQrQopNadIfZYD+SGX4GNEknDbSUwNchnlBxHQLYudCZAZGcoB2F1kTLSo1rW6D
	8PsV1wGnYCnDu9cCjZ5DyaO/bX4NuFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92C3544296;
	Wed, 27 May 2026 14:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07E01F00A3D;
	Wed, 27 May 2026 14:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779892428;
	bh=C8CvBHWQDzBJDTrmMd/gPWBhN89D1x49lyWyrsxqYFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WN2tAxV0o94rrrv4Q1mxW19tNTWQQ5CWz3ite40yZWPQ26hegLuQMbZHIYXdVf63u
	 DzLAdrjEEbhIwyxrdddU0mu8kKSQqhAQ98zB7/1IckQo4uNiyf2oHOE1kDZ6nDkCnN
	 vd1TU46xOto3ARQVIrNRMxeKq3fSWlcs/X2egEt+sKhWJIZ2bFF+TaPlRO8dKdfFkr
	 nepRtpJFQxml9hoT6uXbJXfh5yWq6VogDgOQjP5azfaz/zqWrpUd3/mlouJ/AjQo6P
	 1JcB1BIMrMd0QdCsYiZG8eMm7IaV6thorAeXgmX2laEB8ZgrDzh/VbTVlnu+shlOAk
	 qH+jKqWkfquIQ==
Date: Wed, 27 May 2026 15:33:31 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: tao <tao.wangtao@honor.com>
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, willy@infradead.org, sj@kernel.org, 
	kees@kernel.org, luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, 
	kas@kernel.org, hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz, 
	riel@surriel.com, harry@kernel.org, jannh@google.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, 
	nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev, ryncsn@gmail.com, 
	21cnbao@gmail.com, jparsana@google.com, dvander@google.com, zhangji1@honor.com, 
	wangzicheng@honor.com
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahcANgFDFwfC0v1q@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85451180003
X-Stat-Signature: 19iqtxuf7bqpq79ja5jfapeqf9ncsiru
X-HE-Tag: 1779892429-119929
X-HE-Meta: U2FsdGVkX19KTMUhD5t1DnpaHUx/8o+B7S9uECzbAr5dWO1r+Mk9+cgBSc8M85GaheAklZ83ZWQNXzgzAc50UXs5jTZoN4DW54/VIdXv1kW7j9jGH6b6/6SrfGtL826RP8TRziVB2TVdvNdkFsWVLucDiCnnd1gagtfkOnfwpU0ODCo8AQyXtrPqcYulcbaCk8uRxa1NULrBXa3Vua4qD0W5RuzCJ5QDpwat+mQ3symBnrIaoOt9zaZZEumClzVH7GPrGYjaeWaY9sklZGhXNwuUsMu812rQJfEYNMwP1KBRjmVx73AmscRe1gJy+j1pu1OovwjpP9had9Z8052xVzLr/2mjWhEGgHSOckr8v48wxZw85ocW/kapquv0cb6Y7Hhw3bUk1NJef6m0OebC7vs6k4mwnimlJhdxZSxeRsCl2YYqNlCRePp4FwZowiYLF3fTvEsJ+pWxkZVCAGnwYUo8/kS0UdDwNtKLya4+hzWjT92y8DfHguLCXFny0JbcbHzVY4dhEfDJBVRbFXnk5fhrqOu7Lt48k1e/dLyH16JtBGOIBVt7ZWXrMD3SdRD6k2lP0tqETmKiewZYac2MbA+VEwJWgM1fQ3nrm9hy4Jm3kkVU6Wwr05uTmR6X+AolqmlKVX0Tg2/oMSE5aPQU+WP/ajbKu27mTaGdo4Fuv/boeP5PPfPk2YmR6KrXhypKZ5NkSiQfTg0b0czmqYbvSxoYISqXydIwPsVPljG4N3HYliQ+rptxIEGk23yzOeGdb+yUp9dYfPWzLmzVFk3glBPDUlTYyckpYuiyyb4km5IecW6PrhnjwNYimQGZltQjx8jmeXAJEmaq8MINwB7Bi6Te9mxY2kuF45IN1TPBUybxIy+y/gyXDCEv7mlNvM22K8pXovLXv7Ob5iXiDFelOVKXGduDS5kQzVU6mghwcso3Vvc0VL7H0RAFKPaMwxEhwdoEtf9T6IS7haZJkDK
 vjrxggOE
 a9jnAH0znMW0m2Nco9uPMLUSzHFms8+YECeRdL4znAK4PtM9ZaS6jA8dCrldS525ALqFFoQW85DrroGCpyoP84DbPcei5hfPUna2H83vLKfisMJ5O/XjBSOuYxQBLrQKzw2Zk62Fy+4dLku6PP5TtajiCnXX41et5LmkT0TGRQpxfPqRC5y1491SodwT8n8OSePf/L9jGqkN5+Nh4PwAAr51dQ4GauaFrnsmmIUfpmF/IRR4Q/nvSJ9CpaYEE4x/xxEQV3+6DieG+FoMREymA77rZSWchNeeCj8ps+0pVSUqJigorH2j7Uczp/9FvbBRcOdrJGF9ztI3otbkNOEFrXgSfCo6ykwQUL0G+bgF+q6lLYOfWljL/COoBeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK I've had a look through more thoroughly now and:

NAK and NAK any approach like this.


Not only is this structurally all wrong, it does some insane stuff (pinning
VMAs - no), the RCU usage is highly dubious and I suspect you've completely
broken the anon rmap for things like migration, or have at least added very
dubious edge cases.

You've added insane complexity, and also have failed to add even
perfunctory tests, which is also totally unacceptable.

The implementation is wrong, and the approach is wrong - we do not want to
extend or build on anon_vma. So this is unmergeable, or any approach like
it.

I also, unfortunately, strongly suspect AI here. The turn of phrase, and
poor commit messages, you doing this out of nowhere with absolutely no rmap
experience before, your total lack of communication before.

Claude puts the probability of heavy AI usage at 85-90%, and I'm pretty
convinced. Either way it's utterly unmergeable but that you (likely) used
AI to generate this much work for us makes me actually pretty annoyed.

As a result, I would strongly suggest you no longer submit patches for the
reverse mapping part of mm, as there is now a real lack of trust.

If you wish to rebuild that, I suggest you _discuss_ concepts and ideas,
e.g. send stuff on-list with a [DISCUSSION] tag, and engage with the
community, and go from there.

It's also important to synchronise - I'm working on an anon rmap
replacement that I'm more than happy to discuss with you or anybody else
which should achieve the same numbers in an architecturally sound way.

You going off and, in a vacuum, generating a bunch of code with an
unacceptable approach is not a civil way of engaging nor is it a good use
of your time, or maintainer time looking at it.

Thanks, Lorenzo

