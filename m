Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87526EBFD20
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8A9C6B0089; Mon, 13 Apr 2026 05:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B006B008A; Mon, 13 Apr 2026 05:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B779C6B0092; Mon, 13 Apr 2026 05:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6F306B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:41:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20607B08DE
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:41:10 +0000 (UTC)
X-FDA: 84653039100.20.3267BF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8B727100009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:41:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qWKsep3y;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776073268; a=rsa-sha256;
	cv=none;
	b=zHmrtW+zM/uDla6chh+wnmrJYOkwhbMWE8ykpH9W+sqcCHa+BfHM0oH3XyJJrAOSxTysGS
	TjUciCWwaMlW59N50mVVmrjacy84TP6PTLk0O8IOpjt3jqHmV8lPKdBIwHG7DpJM6gcPVE
	YLeadQ3b8hBSEhr9quPCsmzkreMG8o4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776073268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcO6/QfKAu0DTmfugiYQtRwzqYA++77qyzPrn2G+5T8=;
	b=IanetJlTOMIkLZhZOImmEFD3JBKH+KGCw5l1y7TGP62TuyKzx5LihQn99+BJ1ndXJgK8hc
	E8xUDhtLi/Y1uDp7mIaKEqCHK2qWizsi5ZC8ghd2tV82XtpCYH8iINwXgc3zZ8vkStQIGv
	thvI2tBV5twH3y0vE3EzdajNtSxz2mI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qWKsep3y;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DBCA860172;
	Mon, 13 Apr 2026 09:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33759C116C6;
	Mon, 13 Apr 2026 09:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776073267;
	bh=15mXvkUYQgJAvkQm0f6FRT2CeMc/vq5I5XkJLJOtNHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qWKsep3yhyC5OZY4c+RkYC2c5tuujLQjp+iqv9tAR1BDW2etraJf4G/6+SD0kF6+/
	 wF4e/Z853fweqHX5i56rpeYAybM5oiNC4WLkKDyReRbLOh/3QVb6o4pYvE9/n4kNFk
	 ELmY8lYuK2RhnRYx6ehVcKIeIaCaGstHQks5waLkEdoS5iN1v125zdK+hWIJKPtnU9
	 pJbObV7BirRct5NzbkJay22gMBz7Yl3UnTCVXkVihr3OlGMf/S6jdXtMZw48ofMphH
	 SsKPoysQZ+NhyjZR2uPr9mhKCsC8pyJ2WVepL8YSW7hZgZryYWr/HDwjIy19pO2VQU
	 W87h6zbr84q7w==
Date: Mon, 13 Apr 2026 12:40:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/49] mm/mm_init: use pageblock_migratetype_init_range()
 in deferred_free_pages()
Message-ID: <ady6Ktxok_I73nun@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-8-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-8-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B727100009
X-Stat-Signature: 7ht4gd4pk9kqgabbn7zcerwxmbbygaga
X-HE-Tag: 1776073268-572065
X-HE-Meta: U2FsdGVkX19ipJtUkHwa9bL+9ANQlYWOGdCgjvwAwPyz018fWxg50w9GoRVNQsjcptRh5DXkteCHOMxxCppOm4W5LugNqPYFcPRjM7axOM4Kv1oW6UMljddqY/G0snnHeU5qDQ62roCNT2vFjaPKzN8TQ+Mx/F0wPScz/eWoU+zzR/yABJI0XlSv+ob9YxuUUuE82krN11vsVyV0Sh6w9i7Z9NA10E/wG2xMpMKiKiY8Zr09APQ8T1rPSf1r5rpgQ/i8iYL9ChSXX/N9z1J6XT+A8sjU+wu6W7s8h4pkwNx1+YS4lRX2v3hU0PbAlag93eOwjJQszwoE4ei2PtqsUTYmawuQagCOiQhLT5hXhqjLFn1qEvAbD4O2ZMFkeXcXoJfPtpSL/3PCxrVTdV2VOWijHIBBroMgTETf1FVbUCGIBBAYo7DlgT14+AlcIYXuQiXSS+dCvb6wxeThVuiCOv2IUg1J+XtMDgWIWHmgpoW5jRFhQ4mECuLvZpTBGp/rEVTxvyp72jOlEYkPbtwk9TmOJVeRdIRqPDqC0T7DUi5C6whAxrHHk9RHPwNVoJztcv7Zr/D2/hNRz4ht7k8NlVh0tBt9iCdDoAtNpKxmAjhn/WHPU7Pem4cBXNBmDFaEE3k3+Z3x4LHaWExFRJNqvQkw482rE0XenwtEao7mNhTvmFB3QwUMWTFym0gt0TEue/ZDbHrYpzBGUrYj8wzNr0VFa4QoO5ZJelGQFByI74kUFvxt5S+oQlaKtRiN2YoFo2TpJzT+rLJoFAQK43+rxUNhTHngaO0zwiM2+rKzTGMv+W4ZETVpVrz17voxml83H9N5WeAkgq+5yXaw7+cNLKhTmew2ELbwnr8TI1JMMT5nC42kJ7nWL7Yjj9nZbPKgOWcPnBjRd2KSIEKiZs/YKQRNxiKcUuK4KVTEaYDU+40ZAp3Ct62V4eHYZ5h1bySNM0GJg1kGYgGq1X4hqQ7
 UFQeKntW
 1BXZ0d1MQ2O8bIW9YpmHEm09D4l+9siehYOOgRVgt3m/GukKkronGyKkcBFv5fXeDVBWKOAjS3KS6NasBpPwLdSG51AlL5fUO8qAfHHYv6oj/Em9oVd/s6r03K/rAlMjzVTVq2VYyw1wPtxWyoxKnRrWJX1YQL9vRBhHR38fkBLtOxLWoHrb+BhnWozUfrxItWITLZ7DBhf++G3IkN5U51Sg3rPVGH3blhtpQzBNvPJti5qVzrz/uXag7azzdwM7AV+JWyaelUB3GAaB04L8UZt5kTM1wG2TkvJ2tT3YFvvjqiltTnRXTT2gAc/PDFr2KNhb6I3Ppc4t8Y6W0o8qkqnFbjWbfGShFcysH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:51:58PM +0800, Muchun Song wrote:
> Simplify deferred_free_pages by replacing the duplicate loops for
> initializing pageblock migratetype with a call to
> pageblock_migratetype_init_range to simplify the code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/mm_init.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
 
-- 
Sincerely yours,
Mike.

