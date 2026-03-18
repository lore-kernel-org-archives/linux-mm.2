Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07DC7FCD0C3
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534896B00F9; Wed, 18 Mar 2026 03:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5C06B00FB; Wed, 18 Mar 2026 03:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4221C6B00FC; Wed, 18 Mar 2026 03:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 317C56B00F9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:20:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A67261D449
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:20:37 +0000 (UTC)
X-FDA: 84558336114.01.9710C6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1D79F16000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:20:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aN5TkoDo;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773818436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3d6pCiRVWvWcopw7mXfRKvkBgP9ZyVvyOWKgA82hlWk=;
	b=xi5+AFQjIdLW03XOUtk5YTnKRhetSMuKtPjwg28/zGC8ca6KjKWksRU+EJelSE3o/IuhAd
	+daCY+Y/jEOJYPusBhmwU51CWTKiNRSq9nF3YYBuoFp+JMZe0nS76770paTkjko6jpv2JZ
	XBxdie5thMNJVtSE0r/4v4j8vcAKTcs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773818436; a=rsa-sha256;
	cv=none;
	b=pzYsmi/16Hiui83ePS7Ur/I8TKq+FxMVEUkstVPxCNbdzNwhUytzRrKn70MsWUWD7QQev7
	aiqcLStXKWgRUoTjDEwxj9zUXFI4VmAt8gjTdj9B3nF1bX0q/QblOr9J66HlRBCo2Vzl71
	+7UNfp5Q3D7mpI+G5NmgxJEImwaZovY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aN5TkoDo;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8075660054;
	Wed, 18 Mar 2026 07:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530BCC19421;
	Wed, 18 Mar 2026 07:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773818435;
	bh=JIho6HSp1HqOc7tsMiogR7jCSI50Btsu1/dHfTLouAA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aN5TkoDofwqmglrTgotGy401/4nXLtyrFjXyIZSQhXpMzZsi7QddTFp75QSQlIc1t
	 4Xu2LeqaMPSzCJ/pJKJmAVitTcf//5duJP39s4bOesAL7rOA8kPxOt/AG8QN3oj+hU
	 RrZpyl0RSz5e/Bi1tUthCCOjKVP2NqSHmlxTMvHxuTwD8P/XMzcbQjSqur2qfaANmu
	 ElIc1YEX+7EeHFCK75cYHJmHd0EhXFOq188M0qtXfRLANjo3TELPtMi4KSOVq9lypb
	 4POn3bMW1ioPCDjx+Shx5oWzllZuejBeUqS+28Vr7yeLWhi1MWbWtyU3rt5YFo2FGh
	 7O9w6TOw+bjWA==
Date: Wed, 18 Mar 2026 09:20:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/6] selftests/liveupdate: add helper functions for memfd
 tests
Message-ID: <abpSPfPmPDPWPL2n@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
 <20260309115441.266805-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309115441.266805-3-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D79F16000E
X-Stat-Signature: u67mwktdhez46ehshzbacjuu33n3c5oy
X-HE-Tag: 1773818435-548112
X-HE-Meta: U2FsdGVkX18yXJUnlF+APNYQkVIMDbzA3ytffzLwRrOjHNOGiQkax7fIGPZDgbpfkOrAKFgeuVkbEMLErwO2qiRQqX3quKanDb8Lnn/j41/EQcT5iVcrsrAu9HpOw5yiH4KJsJjkJ2mOBei9oFFU2kTYh4OFLz8tGOfajjKSnznmlbSh54Q71bFh5v6z3Gwbq0CEH7rCZpvKXulvgF6LgxcdCSpG3SsDUgxZ/lMdHutNZZTuXsSXN0fAjjntUyrPqHmHTQzEw7b6grX6Uo2MbRhB+srjCK00ruk+HFfSUS/i+/55c0RV6v+E7j5PR/Wv2YwYpAwUFfbfRw2YeuaCVjCifsxThQF1+cPf0HIOZ/56auaG7uIl5KEPDYNo6gU9IVR0CKU50v8dO3xP/a2lmnu/SV7GtakdAfYXgIE3NhxG6jiwqUdLQdsi7kMGzay0Vo4T57OL8lXr+B1fmAyEUk8LsfKdeLLVPuoeE02nYfcEWeUvf0Bkw709mSskpxhdoFolCH0u3g02mqG6cLHnp4qhLl5TdZQVv+bYZfEI85WpFcsWd9ePgOPO5CngYmMM4MJpXJA32qZZAfPIexBWseVNKJ3EM2urJVUe5OhsUNQKGjJZ12Q4FkX5557qzIQF6YMKrM9LO0EJbAukKLqHq+z5eVXLSX55596aFvmYAx4x3niaOnnHm3Sxvsnby2rp0e9eRZaqkBMadICOqkK8wugiTNz0gLv51JZqjXF6HbOziXpFUWl51Hcxm6qayOOBTxbohGdwGRccNm4Cui4wwB+9WBGRToQdP6ADx0janI1vU4eWnV5EK+VNtxQHRf4WpC+0sxymdR1hErtrtTPwf/1gaa+Y6eb2z3eNT2XPm7jaihh1P+xCoW6UmqSf3Gq3NXxGBrIW9JGHSMDV8RqooRNS7cXi8gOz/tVH64D/zaWsAOnjxnq4o4RTn6goKF6mk2+U3T5poPJf2WLTWVa
 2LtgVM5d
 ZnqXozXwFIMteBxpcj9MmLHtkfbhLzwetcbuoIDY7F/Os90+L/uyiUBjiV/fw3AB65CJI3CTotD637xLHXkvAfha5PlnK5BFlFL51Beq9aI/Qbz2FLUc+k3FnGT+sQD/A/RA3er5Gh6LDHNAXSGsaTYijJMm1kryD8VjhSM/QFs0vaPvBA6Ys3azBT3kS29JLQbLKM57U74SiOUuniRnEgxLQzi26rqxH9lf4GI6YAoVRdycy+oZxwaTs3udYHvCsCARbvC9UW/h396yRLiRTEqpr2xR//RyReSfJmftxKpSLRJPpHw/enIsBDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:54:35AM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Add some helper functions that will be used by memfd tests. This moves
> some of the complexity out of the test itself, which results in better
> test readability and less code duplication.
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  .../selftests/liveupdate/luo_test_utils.c     | 175 +++++++++++++++++-
>  .../selftests/liveupdate/luo_test_utils.h     |   9 +
>  2 files changed, 183 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
> index 3c8721c505df..45ace3697ee6 100644

...

> +/*
> + * Make sure fd contains expected data up to size. Returns 0 on success, 1 on
> + * data mismatch, -errno on error.
> + */
> +int verify_fd_content(int fd, const char *expected_data, size_t size)

Maybe verify_fd_content_read() to match _mmap()?

WIth this and write_size() and read_size() fixed

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

