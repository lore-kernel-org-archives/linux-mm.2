Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAD8606A331
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bX3pT+J4
Received: by kanga.kvack.org (Postfix)
	id 8108A6B08ED; Thu, 22 Oct 2026 05:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8406B08EE; Thu, 22 Oct 2026 05:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE816B08EF; Thu, 22 Oct 2026 05:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 452BC6B08ED
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:50:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C20E8C07CC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:50:43 +0000 (UTC)
X-FDA: 85349792766.24.2A15D3B
Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4C1DC000A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:50:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bX3pT+J4;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792662642;
	b=1wSSSFuttHiG+FUceLQQ87zeDus5gbg7d0GFlIgeaB1TFhxwlC5HEwJqRsGKWddz3ZGD8E
	uqoCZWj97QIwJoSPzruOr9b9wavUPK5EfLRK/kPPfxNb2sdC1FGCf+8iMuKoPrg2NzeB6t
	u8CBgd3B3SyUUZy4qmAk5xV423lKZK4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bX3pT+J4;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792662642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eDzqy1tULeXNTszCzOcf2+iinDrcG5QqO7OF6d65Da0=;
	b=QSrhrFgExt+d2wYcHHxNcr+Ojtdd76twPrHZ6Zw3jBb3UEsZmd4vnAYTE4g/E7FxYlkTwD
	1y6oMKGj1XPCWHUBrTfdgq+w8I7f5he3sa4FlL1Q2R5t62YYsw83V8bIo6xW9iAQsIxAQO
	DfFxCxjo2S1224MMsGm71lkB/LC0+hM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=annJA6bQ/Ec79yUg6U2mlYFk7SaR9NGFkearD7QU1dE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792662639; v=1; x=1793267439;
 b=bX3pT+J4xDptPEfAvcBGXXCsf2WpNtKBL6TiuLxATCkfvpMHjNz7hDAdNBIhPVKijNTnTfX/
 H/RQPTdOWbdZTbOgCRemBVvmijw9TinqRy2vU49+kXcETQjF6qp3JGm2cNwYGUnbkbwDQ9IA+hm
 Lnh7BcN9r6GonJikfqXKV+0w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 2b8a4a208aa5b25d;
	Thu, 22 Oct 2026 09:50:39 +0000
X-Mizu-Trace-ID: 2b8a4a208aa5b25d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/5] mm: hugetlb: add explicit page size to hugetlb_cma
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <1fd7ad70d80ed0da82b90ad5d86de90499a49a54.1792651104.git.zhengqi.arch@bytedance.com>
Date: Thu, 22 Oct 2026 17:50:19 +0800
Cc: david@kernel.org,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 azpijr@gmail.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <02D8D71D-CFE3-4EA4-BD73-F02191C7F92B@linux.dev>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
 <1fd7ad70d80ed0da82b90ad5d86de90499a49a54.1792651104.git.zhengqi.arch@bytedance.com>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Queue-Id: C4C1DC000A
X-Stat-Signature: otynprxcub9sbgjrp4uq4n8mecrj3mnk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792662641-303272
X-HE-Meta: U2FsdGVkX1/9Ky3i84BAMDV/WxJYMKjQ/g9CwyApH7zL+9XeKnX81P52HXL12ed4gD7+HuRVznJjMINAuZRJYJrk+2ujO9S3NuKGEqZDFhbniLEnFg/+kZ/cqpcjWoLTbL/1FjWGLdqexylyhKjW1a5xKNrJWlDXfiyNK0G00Uc1enQTx1wp3X2qdpUFaW0UxY2wOn9aUoXo6NA8qhwBuJDr1/YvsFmyBuKdvJNEwVmBSoMYpozKUSR22RKl4o/2tV7KICrUHW1Hw83iGBq5t5YMc7HTRpLBxW8FMp4x9AmSrMqH9vzhrjd7cD2Ba+0bd3wTA4XKnh1pRjllbgia2GmpkH8eVCIOPwRPVU5sXHjUTjJFkIMvRamM6pYuo2GVc9WTD5O1u7WtvqilEHOe5I0/m6HF+LmxDDcKlGjUCYN2oqfJ4qYBPA0C7COCzXyWVsYNUmae7A8m4vkajvbwCQebbN6ro+FYNjWJP72Rq1xtJ5K1va3p8AQLKNgMaMyuMV8FSMcMdlVPkDSgeGRvn9Pacg8fZOE6hw8D0ZMjePkRMQYi9vNa/8IwnGYBB5Lo+bWa8vQJ4ImX9RoTxrLcZAiv+GvprOMJk0IWRGRXL/yBDko/zo84rgInpQTQXgLB0n9VM++gHDW90EkftSCJY8C6LAf/YJtsWfk95MZpmfHpzyOPWUw3+zIsTAxOoJU1sE0wlMzdFx1yd99Pg30A+w8Q/47oorq/WKxVFMIsa09kuWqkYvdLB15g7djBvP/4NT2hFcvAfWyy05lRzNmPk2nJ0r8XPiH41ZmJxH02Pd9gJC3Gf61Ki+w1IVH9ZGP0m23iqb400r26OzxepxsdaPSNgLB/dL6kCAaIN9okwylL6GeiOl6X3iLJEHYgSmwR+GA8kOxv41mngx3wctIz/Mogo5UqQViW1Cg429P1rMPMz3oYn5JZlKgTWOnVbVYFiB8NisWJ9nwZvDSlpoS
 zZrRYdTm
 0dfALi6gKlAJnWgpvAZSKcMEC0u0cGCHsxVfoXNHjA9ucOaAsYtODtc1/2XC+SAoLaN6gA3P+5EA4YoL6reJ3emjsOKdbLuVFNDkwPUltspBFWqOdfjcHBiqbbzQbprCSsND9ETQQ2qyxOS5JbEd7OZfkMqyrhG8DsLU4KcCRyOyIgYXxHqtSew3Dlo/NENe9g/e0y1lcRdmqcnuTHHo4e+/DVl3f5LT8HgvqAkYZ/SQqZC0GG6mLG+hnQMIkiJj4glzJvmeqwcAkrHyfiFmOb5rZgEiPLmE9+nVZX1o0gUzT2zASgRfyM5zy0eVB2WtYBLRllUMjUd2XKPjPyCYaL68m98BH6fXZ0En5bWyUYOg/VXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 22, 2026, at 15:31, Qi Zheng <qi.zheng@linux.dev> wrote:
> 
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Accept an optional @<page-size> suffix for hugetlb_cma. Initially accept
> only the architecture's existing CMA page size. Preserve the behavior of
> unsuffixed arguments and the existing hugepagesz/hugepages options.
> 
> Validate the suffix before applying the existing capacity, percentage and
> node-list parser.
> 
> Save the arguments during early parsing and process them at reservation
> time, after architecture-specific page-size information has been
> initialized.
> 
> Assisted-by: LLM
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


