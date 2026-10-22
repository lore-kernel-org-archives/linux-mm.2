Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2532C606A322
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EemzBdJL
Received: by kanga.kvack.org (Postfix)
	id C78966B028C; Wed, 21 Oct 2026 23:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29426B028F; Wed, 21 Oct 2026 23:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FB36B0292; Wed, 21 Oct 2026 23:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90B5C6B028C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:44:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BD58160724
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:44:09 +0000 (UTC)
X-FDA: 85348869018.08.3CEFF9A
Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf12.hostedemail.com (Postfix) with ESMTP id D057640008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:44:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EemzBdJL;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792640647;
	b=NMKPdhYFNqHEbYYHmVDUnZU8J63Ef49ZTx7OdUXDui1C2tncd9zJoRbGh/xj2+Mb/Ny5In
	NbmH5Y5nJHnD9K3+rmUzftKzktcYWAH77WGuv7DSiL7GsVrok3JRu9zQQ/Bt26E5uDuOfM
	3PkMBV/6PoKopnPQss1P8Rjeh9EsFLQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EemzBdJL;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792640647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGL2LF3kJfnJotSm7Ou+7Cd5xevBu/wfRGoJVJcdsiA=;
	b=Ft8gBCIlUrzpc2gWKvFkGG+fTZpOdBGbfkzuiwHmPO/9fvAZFoSTSA/n4HuTRSG9HJ5ZSH
	VfwRtfFBKgm84jFFmsMPdTSKERA3TU1kkH2kTB5bDnvxrynUDBWtSPs9hJ+n4vSZwM/wGa
	0slROe79CX64odKdG2fDFmp75s2E1cM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IGL2LF3kJfnJotSm7Ou+7Cd5xevBu/wfRGoJVJcdsiA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792640645; v=1; x=1793245445;
 b=EemzBdJLgzf4lhA6aMHbAJOCPffQw+e5zVl+lHrgS2T1nZecoxmi8smyCmiKdWunBwVwltxe
 NOBI5nKmzuWGbL5tPS2iywxbAsiabv1KJrIgSRQ5eJqABYN7wtpc63zzCNBW5Duq2D5YooU/aFP
 2GQEogvLzX5FHGJ1umDcUGYU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d29a87ff2bdc911e;
	Thu, 22 Oct 2026 03:44:05 +0000
X-Mizu-Trace-ID: d29a87ff2bdc911e
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization macros
Date: Thu, 22 Oct 2026 11:43:58 +0800
Message-ID: <20261022034358.44302-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115306.813483-2-songmuchun@bytedance.com>
References: <20261020115306.813483-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8j4epxy4yw3owcoq493e3zzura4rmqys
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D057640008
X-Rspam-User: 
X-HE-Tag: 1792640646-864688
X-HE-Meta: U2FsdGVkX1/igwl6NiXVkZ66hS7AeRDRqi/hT9mO4DhOA7UoBP0SVEcqMx5GasgDrrtY676619qNfFnAd9zY9Tb5s8amD9NNmLeP4OfkntKkTgxLvb+d/L/5VbldGLe/GK+mrvLpt4/i3TyILGdFcFpiAya3AzTDKTj95MZ3LzEP4iKwIEr/UWc95EdAwI1GlbgXSDr09WkgPfadc8fJ+XJgvMiu65HPD4NIwvA4weSPgbgAD25HLP1wiM/3Pfxag46UDoEafe2LoEkBqjDnOn+U2pRVZ8gWphXmHZyWtpHeDAHI3JEckGfIv4abTtdfS+Ts+77hBNolKWOyMZB0C68WSdX8WC9mxgxxBZiRdDg4xCxy3yCLfsec9ez5knRw1YX/JKuhLi9NKD3QBukyKEFDQ8sjjRQy3drF/MoJvyzaEOdEtmwpXxug+vnbgw9i+gxgdIjXNL5460CN0vS9HKKq2ixkvKKkfgUEmzu/LO4JjsdU6dLL1INYEdx4r0Pb3zWSu1VzKwkjHYSQjZSKcSk0Z8jOtXFIxJtHjnJ3rQLicIoVYrd6JqabFq1O54NUaT4/OsCeh6oNpX0DgJjn5pNfxtBqa3fPYeAWNGVYBzFOUVAapqXO77H0JnnTrOHjFvDVg2QuVyxQ02MmFVo66Xik/CxchltWWe2tXlO/eBuzs+62asJx3BeTYmYr3JrH2PHjqIPvzYJxQc4gY3M63gCCQ64X7Z17xXGNygtp+SVjsfy26OazsGzPmC3sXsIo+rn80gZlDwvjjXSz86B4YuCAGGTkOIvWRCCnVv2DpY+nZFd19H1Adt7+laAlqaFGpdC5rjZ1SRpwRv0UnYW45MlTP7r5TmhTzoCbw5lOzHrTydj9TuhhLxCl/+HYiQhqSKx6P3awcd1gvrBb4OhNqv7KMIY1Bz8XwhIFmbrJpHSOCGiwIIRi90QnZX/8LUCakHtRs+/c8qFuty9iXJl
 5JLYVPRE
 XgVrNKWYGBUTDAvvZmTCAwxU4k3FjgE8PuunINWu0mZ5cVtDkNAVskG04rX3bqiagn3vr9PZ0UZYWxJK+VqnHTzrlwNYPp0gUJR6UzUAJFWnSFZyzxxW6gJibo4pF692QrJIwn9TuO8VSegCAqUXJuFHneNBWcHNqXS6lIUUBlGNhmHavacMdYRbMFYE44mePgV3XunDmEDFmwdTld6kZw3Zxkm0yWq/M3XFXE/NZQ3RofaLKB23tpb+I/DHX4KqSCyFNH5Tj3RbCihpNPLg60OmmxoZaevQcxXtxfqMmrtPfhQqVVrB9YvjBnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:52:55PM +0800, Muchun Song wrote:
>Vmemmap optimization is no longer HugeTLB-specific, so the remaining
>HugeTLB-local reserve macros are redundant.
>
>Replace them with the generic definitions to remove duplication and keep
>the HugeTLB vmemmap code aligned with the common optimization macros.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

