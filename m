Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4988FF8A14D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4408E6B0096; Thu, 16 Apr 2026 05:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1BD6B0099; Thu, 16 Apr 2026 05:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3074B6B009B; Thu, 16 Apr 2026 05:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB1C6B0096
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:35:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACB61E47AD
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:35:20 +0000 (UTC)
X-FDA: 84663910800.13.70B7015
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 12E87120009
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:35:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V2OY/WXd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776332119; a=rsa-sha256;
	cv=none;
	b=xX8bjCru+J02Sue3tiVhHyxD80S2Nyw8uagrs2wV5YKl3Hw9qp6KQbZP6U7rS/NQvqgzjl
	PBLoF35tXF7EkJwgWMcofHrXZ1AbXet21wm7eF4/CB1RLH6lAYa0Tn2StEDCmKuWyLKnwS
	2dF06jS08fAQePnSzW+ySO+GjAK4vUk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V2OY/WXd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776332119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOHyF5Cx8M6AJuZCzjekkJ/vI/N2yGPVGXahIMu48OE=;
	b=Jfwu0KKThVdJvWMDU7vQpUH0mFF7u8G2b3mntVlyNBbFyKHj3uqr5P2JXTDRrZfe2UtQ81
	6VfyPAS5OR42obur2SSyb++hkHgTsAF1sNnl/WiiyLlwBJFFFC9hNSjyUPnh1Swlxmwbhr
	HF8ZgNeNfulKNfdPDm1rDHZ97DL1RjQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15BE9443C0;
	Thu, 16 Apr 2026 09:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FA3C2BCAF;
	Thu, 16 Apr 2026 09:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776332118;
	bh=qzx86yIYEM/GemLvFCh/lwiEzuYxSCpGtYSGjiBaBAY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=V2OY/WXd/jcvmTN+lN0/LtgwDqPt1EqOT/yVI1PrNnh/fI7foPgvgxdGx54kwKGKN
	 E/2Ggvpn6n2OZ7eyYF3SzeoST/lwZ8wYWbdjUB0YidY5dw+8qU+W0VoGe/tIZGXyvK
	 W1AIYLxoYYnU1LFW965p0UTthgAyMyiObDfnDoG/NpMwVwRxd3j5G0cRxPApZEW5y9
	 Y5NluBS9bpV12u/Vj4npXYp36Jb7M1zF50aFMy/lPFg8eYGFSlO9cCFffS3jdo0ZrQ
	 bEgwNIdp2af7qzaBYnor+rcBtHDPBYCEOTxmQzmxr4AaoPeH4ebZ69LysVK79NtLWu
	 3YYlqzcFxQBAg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: Pratyush Yadav <pratyush@kernel.org>,  pasha.tatashin@soleen.com,
  rppt@kernel.org,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 2/7] mm/memfd_luo: optimize shmem_recalc_inode calls
 in retrieve path
In-Reply-To: <20260410014537.GA28528@chenghao-pc> (Chenghao Duan's message of
	"Fri, 10 Apr 2026 09:45:37 +0800")
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
	<20260326084727.118437-3-duanchenghao@kylinos.cn>
	<2vxz8qb5hbgz.fsf@kernel.org> <20260410014537.GA28528@chenghao-pc>
Date: Thu, 16 Apr 2026 09:35:14 +0000
Message-ID: <2vxzse8v6yel.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 12E87120009
X-Rspamd-Server: rspam12
X-Stat-Signature: xixof7nku98dzbwcx5e1dg53bcxtjm87
X-Rspam-User: 
X-HE-Tag: 1776332118-160340
X-HE-Meta: U2FsdGVkX1/8MMuw/gK6thSLGK72vpMa7l3pY3nC0EMqquxkEuxECCHr7FxwK3i3koIomoW8QRXmxaD42ZRJKk6tNZa6yrHbjB5LCAjsgW3Cc/k7Zi+IzCsDbyU5XEkBsBJC7z0sa+wp76Myg2YlsQMqRE7vXLnvHYHHecnGksZZLdtzH9beQsEh63+YXMTZ5nP9vL3WTB/BKwRD1oRz+R/JOMtCap1Wm1GOM60CX+qzOVJyhqHeGNHsRcD1Q7dQLwzlMjkmk4TcUFtfHdbIYV959HrWte20L+b1nXBbfb/t6txRXsH+QyaIUKA6kcZBGCXDt/aKPg0aPRQdXIUye6X6E5QJWYvP7KPIXYxpn+kB45TXklYiYAGn2Zm5BblVKPgWpni8/CZI0+kql7WNje32FxG8op7ClKreLM6WW4wxl4a48NoX+dNDT0Fxke6V9Mwoq0g706kPTehzlYURcZnF2QviswawS3XTOOcOJp043hNzzgB3EG7c/zTnHBy7bczaCzl0nQ8W/HuGQt6B+pCjzFKDsKBs3miv5K6Rg5e6l9dTG7G2nnA/hgkXVUX2cLx2G2HKwYwLSWpUFmAo0LyaOlK4+cLqvwuT/CFb7O01uqUnurGfmIYtHCJkl9CdOfx3XHF/ifnTb5Cmaicyy+a0gF94wgLrCEMauD0Z/i97JPNQEYPZkEnAO8tzE9n1kscesHUT5OjOEcdILNwaxgnWGPDSUueCEx9s1hXPsC9Xr1TOU7CTI4/FLC/Dz+y9n7sOxSHS65zvo66yD73Uq0Uc0/Q7fKZHrPrIqaYsFPfcJycYhN1fvTXp3qyiAMCNXLcKLNLTCdhBhjXNq2mrmd7KKxFpDqHZAMkoFOS1LTI1/1DtVsyeQk9Ctq91uZB2+HeJpyn+aB/O4Dc4gA9zZVoqr2KqBkTYckkWHB5n8Jg7uHqYwnia0v7fLMknf3JOt9KRFDV7B0JrpeKobct
 d8dKrGZl
 iEnV3y113Zj6EN/RygizHKd0vtkWG90VD/WDSNQec9H/anG4Kd1dArbOqwLwZIAeN9HVg3RkTwLeQd9gAfEL1S17OjZzatF1li2vWoWWST1LzR2muX0Gc/iKSTfUNMJT2Ufm0cdAHQkTPWg8RsbUnts05TWnOPRZN/adlEE4cYeojobf5feR5QtR5mf7gntICvtb+Wc7QlK5VJ57KQOCMkvsqn935DUw+7TkvjU88q0G//UKQhjdlYoyp9fFul807w++1tEo+1/V2wgOharHijqjkH6pbjyUBRoH4ouCcmmMB1d0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10 2026, Chenghao Duan wrote:

> On Thu, Apr 02, 2026 at 11:02:04AM +0000, Pratyush Yadav wrote:
>> On Thu, Mar 26 2026, Chenghao Duan wrote:
>> 
>> > Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
>> > to improve performance when restoring large memfds.
>> >
>> > Currently, shmem_recalc_inode() is called for each folio during restore,
>> > which is O(n) expensive operations. This patch collects the number of
>> > successfully added folios and calls shmem_recalc_inode() once after the
>> > loop completes, reducing complexity to O(1).
>> >
>> > Additionally, fix the error path to also call shmem_recalc_inode() for
>> > the folios that were successfully added before the error occurred.
>> >
>> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> > Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
>> 
>> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>> 
>> BTW, can we also do the same for shmem_inode_acct_blocks() it the call
>> to it can also be aggregated in the same way? You don't have to do it in
>> this series, but possibly as a follow up.
>> 
> Thanks for pointing that out.
>
> We can move shmem_recalc_inode() outside the loop for aggregation, as it
> performs a single inode state update for the folios.
>
> In contrast, shmem_inode_acct_blocks() is a validation step for resource
> reservation, quota, and block accounting. Since it can fail on its own,
> aggregating it outside the loop would complicate the error handling and
> rollback paths, especially when only a subset of folios have been restored.

Okay, fair enough. Thanks for looking into it.

-- 
Regards,
Pratyush Yadav

