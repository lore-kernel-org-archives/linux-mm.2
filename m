Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAEE2F53D81
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 17:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F346B032C; Mon, 16 Mar 2026 13:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00CA76B032E; Mon, 16 Mar 2026 13:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51BE6B032F; Mon, 16 Mar 2026 13:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7C516B032C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:25:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7954EB8046
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:25:43 +0000 (UTC)
X-FDA: 84552603366.23.D5F97A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA69420004
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:25:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Umj/WqyW";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773681941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vzbqWY/q0s3ssbI5xmhJ5ZpKFx714CitYxSh3/54ho=;
	b=m7fsyiN7nnBHz5UXqBzxbiHqm/qKTC0IF8D6skNdkVFnXwDf4havUWuYq23jLrtj56yGUt
	USDMpLiM5ZYySOt8frxEiRHRcIZJEbJRXXBLN2l5+ZJOEUSqtXhfZzkqFp7rstDPGdqObd
	dE+1iAsTwmMZy+vV9JNBQmM5TwhbZW4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Umj/WqyW";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773681941; a=rsa-sha256;
	cv=none;
	b=VUTBOuFLXcZKL6rn1yCgU7JFWH18yOKrufZsfJcWJF2QqxC0H+Z47k+DIMERKVD4z1gieW
	qudduVT9N13/Znp7KS3g2y5QKDn9Hb8pskOOyyLUkfwAZ6NMMT44N8ppmN/FEYcT70ajFf
	mWYMxSrfAlz1rictElwxxnU3B4RId18=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B07BD43F71
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F6CC19421;
	Mon, 16 Mar 2026 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773681940;
	bh=/OYUQzvbizA/HnFcDSxx3chz1+uWDAT16QLEnDDvjhY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Umj/WqyW7820d/fMeiEsgdsRbY/VadfKZl6+bgrA1xdbsU8fNY4yW0TxP7k99k2mG
	 7G5ZIrfMbx2ThX2VzYgqG7sKNqqK/9Pzq8ygwaRpP3jxJ4Mdv9UnXSupmEQfE5y6W6
	 G8TWLdqhDFLeH2pd0tys3pcCxsxQh9cB+dgdhrAo=
Date: Mon, 16 Mar 2026 10:25:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 17 . x" <stable@vger.kernel.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon/stat: monitor all System RAM resources
Message-Id: <20260316102539.2af039f5ca7ce1164da34b47@linux-foundation.org>
In-Reply-To: <20260315162717.80870-1-sj@kernel.org>
References: <20260315162717.80870-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AA69420004
X-Rspamd-Server: rspam08
X-Stat-Signature: da4iexngd1bnrat7q89uqfd6ayh15gzf
X-HE-Tag: 1773681941-424913
X-HE-Meta: U2FsdGVkX18TThYum1iQrxYT0mHUIZxca3rKQS6u6ZVbSKbLm1rVtHV8izKAO5PEpk+P8njkMoAkidnBsakq9KCJ+/KdY8D7c66InvjkAVM1kE0dzQcEq6AfGnvM4rnjrGqpml51mYgmIeboXBSmrzIljGVFsqXrus+DkPxM17P8pUs38Mv9rFDgBU/shjp1G0fgFZK+xvSDKIflyyI9M1qF2gEbzsuZPPrFIHWSmHGDNRw3318pk/g5BDlzfXQW2gwqQc5XCpHbCGyIvd7f2hWdc7fDfTryHf9d3+wO8Eq0DAdFVdwOt+WNwQTlwYeHz9vIw9tVzyaiZ/hmwhDg83UI7BMmdHb01AKUTPD4/qWVv/PoKkvS+bs1IMg0GJu+8b1/3yV58qMW1uhHaiFK296gmhEblNeQJpA29SGyxEVgFYE0Gv+FKYlrD2CAB9G9tw+vWaeGVkBgd5ILx+1OO3XvQNZqZaNK26JnNSAh7hvcvTD+qK7G3prK+YGYIcFVEr3PH1/GrEPdroVP5RfrT/U5A2D37CrWw+AsZ8rM2f6fDrb7D38Foh8bZRxCrvXUbu8kq3/3r/dy0VubPHqwXQ6ZN5QIEcvD5+AskbcyYvT46luCqILtw9r000vz142b++vHWKl4Q3DexOgO2I9EShONnNGdMpUv1YqYWYTWikI08tnxO2zCyHP6RpNuAOgVqnqu6aX9O5NSS8+2sBbLYCdcBo/1r7Ppo9Gh5PlyQJRrfO+XPnxhXYxgbqdrGvi8GZNKrEaykFc/3bhG/G4F4Hpq1YF/TNhexwap8y17UFIUm2xNrdMcrI16XpjK3Vm+cA2+Ac+nuS6/8kNt5HRUzfMP6dLkiXix1jF2bjB/6shqgUdUHsgREK6rmlKAn9PK6/AJHgpOueBkyNhZcbBxKDOn7AfA9FM976yLa0E4nrr1OwReojvv4DCKYnqbzrOH7FMGzlY+p+LRvfWAvG+
 etgaZ+SW
 VuuEPO4I6CIzo0OHEO6T9nF8Bx1xth4Vt/hVVFGcEcfw8cFM80qOgN1X2b/2l02ejYeZ8JG0UM4Ao4vdOHI7bB+KLG/6ggWnpQHvxUFKyEK6tc+VjxeyI93+RfCcGRsK3NbFRagErJrQlAjHwi2L6dwsuG7NHjgLmnT4Day1bRuvXlnOKZVy+1IhOjVTidkOfEFN31rKSvyAgxJr0EJQAYfYv5W+mNRZmRFdN2SNbYCelIXtfJrExXLcGX9EqocpxDTXl7I2ngJU45mTAl0LJTIE8WBA8i3cjc0V6fCBesDs5h83Ug4Fu9Xv5TwndR0lHCFTF76tw6VKICOLwCsR909z5Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 15 Mar 2026 09:27:15 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
> says it monitors the system's entire physical memory.  But, it is
> monitoring only the biggest System RAM resource of the system.  When
> there are multiple System RAM resources, this results in monitoring only
> an unexpectedly small fraction of the physical memory.  For example,
> suppose the system has a 500 GiB System RAM, 10 MiB non-System RAM, and
> 500 GiB System RAM resources in order on the physical address space.
> DAMON_STAT will monitor only the first 500 GiB System RAM.  This
> situation is particularly common on NUMA systems.
> 
> Select a physical address range that covers all System RAM areas of the
> system, to fix this issue and make it work as documented.
> 
> Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
> Cc: <stable@vger.kernel.org> # 6.17.x

This doesn't apply to current mainline?


