Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0514BCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 11:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23FFE6B0005; Wed, 10 Jun 2026 07:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2179B6B0088; Wed, 10 Jun 2026 07:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154586B008A; Wed, 10 Jun 2026 07:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04E266B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:34:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 891191A0969
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:34:05 +0000 (UTC)
X-FDA: 84863794050.01.E626F8F
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5DE1C140011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:34:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nMgRuPUs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781091244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkPIYc6BxTC1Yyureze7Jc2IGyRH65P2wbDPNEliW2Q=;
	b=qjcFydgt3cu8oI7Zu4yHjYWZFrGgU4hA7MBgRbBXl5oLvEIJ2zosKQV32crwUfKrIt89iu
	+yxAH54bKquZxn4gIGsd+x3Q3mHlLV3Eq2DjiYyQeDuFiAUB+0VxLGRO21EOLcwkqXprIB
	MPbRfpGwOUKWXSDS3eCaNK7ZJ0q7hDs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nMgRuPUs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781091244;
	b=C8eTRgcBvVkQjSCsgTdH96Rk9G8HArij3aHK3Q2P6H8vdkZ5C/7+udtXTO7piWRGttPFf0
	pjO2RPnqpmq0wruNLL7mzwsziaSEYQLvQCAHdgJGo2f+BTMY+cetLaqsmm51ewba2vRaS6
	sUmJyXNfGiRYIrXf9vTEER/m2igAETE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781091241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XkPIYc6BxTC1Yyureze7Jc2IGyRH65P2wbDPNEliW2Q=;
	b=nMgRuPUsEF8gQiESTcWPWxWWBTGfXbuGadgVqAI4pbIRJufF1wFEEr2lZqs/7Nyb2C0vL+
	A9avhuVNiCQ1fylOgqDEFHvbXwWvJoZD5BykXWoB21ypEEzJ1tcQT7AW/yw6ZfIZ4mC2fW
	/hr0stp5on41u8nUGq09svg8KurEuaE=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 06/11] mm: khugepaged: allow khugepaged to check all shmem mTHP-sized orders
Date: Wed, 10 Jun 2026 19:33:52 +0800
Message-Id: <20260610113352.25352-1-lance.yang@linux.dev>
In-Reply-To: <b4d0c1a5a49284b1f0afb0810e056f6d88b17d30.1781083630.git.baolin.wang@linux.alibaba.com>
References: <b4d0c1a5a49284b1f0afb0810e056f6d88b17d30.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 58qqnn3s8f1x8q6q5skj9xsdufg78rq7
X-Rspamd-Queue-Id: 5DE1C140011
X-HE-Tag: 1781091243-685500
X-HE-Meta: U2FsdGVkX1923O6+c5sTtc1CHNMY6l5kehLRC2v9CvF6k6kY83uQh7ovdqyB2J/sSa94ykHIntRqMWoQGmZ4v97VwvWJbxgF1WUSgn76ULk3XAuYMcsLGRxYOV8lm3YWLoX5dPx36LEwyK5tOLtSmgSGHlSTEazT0C5xk16etOk17unYpwhU6/AWFaqi0c3LTng3G0MM8b34hKRnuqU7H0ilritAcobd48WFwvpX9UwTDhap55TiYd9Pf9+DkiXP51PBaMWuJwD9SEq1yQ1fN78wLuCcYBIHzDXrEcClTfSepWTFoFhZSKfQUNDdDXqiKmsX6CapNvy720SuIFLrDnKJZi0oeT7QKx9lTA+ZJGkpnyxsc7ZNHQdt+AJypf+IxAjDfm/f5SzYmh2K71zHJ24W/pPj8sb5E1zJgT6cA45NUTmkIe4MeI2zbfaBiB5srdDXTCh0yI5qNxa14YFAjyWUvSXtjP1CfeRGeKCIMVew5SiqJ0DbQBIs6YMncf0H0yYxs89kV5mC5zss4/531C+l/yFFQ2+mAgZMrg6nskfsKyVTQzgLnayc4R9sc5He65sQKUOKrjkKI+r1jrlhleyuvKkdSQJxKAbXDbuFbH0Wi8Mfuga4fc+mIyxD8UdDDyUZAkj90CtllNyZgVioCNqceU76D0oPa7zCofnidcSIEwuPoB+2C6MEGmsuaqsGOucHNXSkzm6wBScCvLtj7gbKyFQvzGMqW3sxyQiXst0aEqPW2ceE2lXeYpSHglSITTZfI8EZoeEH1QOca3c7VUxAebbTQzPH7a5P3Mjlz8OxtWQU/ZpbLO3HuwXOvHSYSTQC8HeWeynw1eAxgHJ2RXQNnYM6sAi4VXIi2BEputZQ5Pge3VYwX/hglcDMqWu/NOVSwYjmOVKTQpR3UtTR3sycPF1ZPyRiypo5GTAZWPh2C+fbDmU2s7gzGrsSEADrxXjOPZrhuZ0ICEbZN7q
 IpfNowXq
 2lQfy0nQc+/Z/N1hA4Aa0JT8lDJcvmO6O1J6rN9B0Yndz2l9/ynOBwLgjs6VI0TeXocXmKRoOYqqzKkDYngYJ/jjBwV3V+72JqL9YmZgWkT/tbwHsWJ09tE66WkJom4pUTg1KjPcsHksHJ3fLvjvCzhTsjQOoyupC8EE2rw5b4oIP3BmJdSdDRSIE1IDSbWa0zzrHrBeu/HGwPO0GHGQPf1IVtIA70y5u+R7Hj82WQT4HaD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 10, 2026 at 06:29:14PM +0800, Baolin Wang wrote:
>We are now ready to enable shmem mTHP collapse, allowing
>thp_vma_allowable_orders() to check all permissible shmem large orders.
>
>Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---
> mm/khugepaged.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 75b18ec4a6c3..a87918b7e18c 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -578,9 +578,14 @@ static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
> {
> 	unsigned long orders;
> 
>-	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
>+	/*
>+	 * If khugepaged is scanning an anonymous or shmem vma,
>+	 * allow mTHP collapse.
>+	 */
> 	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
> 		orders = THP_ORDERS_ALL_ANON;
>+	else if ((tva_flags == TVA_KHUGEPAGED) && vma_is_shmem(vma))
>+		orders = THP_ORDERS_ALL_FILE_DEFAULT;

Hmm... for shmem, is the lower bound in mthp_collapse() expected?

#define KHUGEPAGED_MIN_MTHP_ORDER	2

#define THP_ORDERS_ALL_FILE_DEFAULT	\
	((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))

KHUGEPAGED_MIN_MTHP_ORDER is 2, which was introduced for anon collapse.
For shmem, though, we're feeding mthp_collapse() orders from
THP_ORDERS_ALL_FILE_DEFAULT, and that only filter out order-0 ...

		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
			(enabled_orders & GENMASK(order - 1, 0))) {
			order--;
			continue;
		}

So order-1 never gets a chance. The walker stops at order-2 and never
tries it, right?

> 	else
> 		orders = BIT(HPAGE_PMD_ORDER);
> 
>-- 
>2.47.3
>
>

