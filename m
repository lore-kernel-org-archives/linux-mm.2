Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2983CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 00:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027316B0005; Thu, 11 Jun 2026 20:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AE36B0088; Thu, 11 Jun 2026 20:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30B76B008C; Thu, 11 Jun 2026 20:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D63916B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:34:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AD7290A1C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:34:03 +0000 (UTC)
X-FDA: 84869388366.04.072B44F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D78AC180005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:34:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YgAqQB3D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781224441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0OzEYWLN58a9bndRvEdLc+805st1EVDrM4p5AuuZ6I=;
	b=osrcJ0l9wQytG5Tr+6d6TRxCHRijI4Lft5rP7e8K1WcvL0hLm0KQB9XAMvG9nmWVDnzdGq
	GWMOd7BZWcuVKb2xSO/dReEjm1J2hY4ZlZGtbTF+PKJ5Wc9HC8fKqEz7tGZ3DpmVbd8vse
	BkSJbgqL+Qu8SD5GhReLQNK/yT2msDY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YgAqQB3D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781224441;
	b=8c95rRip1VvxUrHsx5MRGrl+6RO1/cWea2FR2NBP0k7EMwGxjmBxw8Mahm605r/cHDZwQ5
	sjnrgZrvdxGDFGOIiM/7NEDJ2SU9lD3hGDCHWJstY6FO52sPunLIRoXkxxuMqxvk7mvNtF
	nMoq7QciqcATkt5dvGkFR3G0VwDpJqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D89384168A;
	Fri, 12 Jun 2026 00:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621521F000E9;
	Fri, 12 Jun 2026 00:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781224440;
	bh=G0OzEYWLN58a9bndRvEdLc+805st1EVDrM4p5AuuZ6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YgAqQB3DA0EyByGP9YVgrex91Vv1pBOVq3yBv9kf3ihj2R+QuJ+S/03tW9msb9yE0
	 3nkVeSDGWYtIXhHBEg/u/weDuLMIxR9JlcHTH9aI5sosh5x10YRm1yJZMj55s07rhj
	 6ZYtCJlJqKdWuMmj9jEGaA4IUh891kXui40NKlQQiTwIW1LkpfWw9OjV8yqDoN/iNR
	 5253k7i+VRhpWInKW0cB3RKwC+RLeaQk2jMBCC7weV4ZqHkptxvkIWkKo5I5Iexp2f
	 6QflkbWXGR6fqIVweSOCse6RHML6ywmfF0SmYAMslL2boJOz292WWSRz6TXzjcDx+L
	 YakSmss3qRzqw==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 4/4] Documentation/admin-guide/mm/damon: add DAMON-based Hugepage Management
Date: Thu, 11 Jun 2026 17:33:55 -0700
Message-ID: <20260612003356.83586-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260611150244.3454699-5-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D78AC180005
X-Stat-Signature: 8kt3fpkeey85ic9c5ywiuok1r59buuwh
X-Rspam-User: 
X-HE-Tag: 1781224441-921891
X-HE-Meta: U2FsdGVkX1/mWnLYA5vKWyPbjLJoO/iUHV56MkSBxF2uxcoR01gXqVYusgr17+7HpYKbLXEtRnAHSydE9bz5vMoYSv7Ynj30EHrp9UD72PsNJUQ5/R1qg167/XNYlUeDb5ig4ENQ2TTyWLISCLRyJno6mr7k+Y8vFgrA6+XBK6xcTCCJVb29VHfaupomfmyqRGdVVxSmypsQxYS/hKupxSl29zmFK5FERj9JFK6UEkx5oJeGq4Qn5bXDikF2cvgguzpS8qKDGu94RMFlqpcQLN6USbYWZLg3zZi6QMLrlJT7pQBLKAD4Z8ZY/TglTYE65c/SNIG6/YKuGmNPe2UQLdPSbLfzqvNYiD1lVDUQP3xAiZLqw1xZ+iFI4EK/GzWy1+SZ7BZvCt13KAq+kCMHVEY/BGfy9KRvwLhri0FxjxBwb/uTSsYYK6e0Huevgf4zdYOWeHMnex27u1+q8E0WNtGQRC81Y5iT53aOY37HyjiL7on+wmPOx6Yzpb+B0rsVRzEQtYFgXgpHutbwpH/1z++pDtO4bVbSiTxP0ebWKge43oSmTa3O/21vP1l/zVPbPuhfIFBegOmI47AvmSDGRMbv3BWV/kNMGyli4Yiuyg1fL4noI1JroqOpT26+iF54FfhKnIELp6i+3ICQTh0xQ+Lvd9FnPk3J0yN8oJZUX62NXr2GJUAXXaA8IQRVgxvXOGoqcuooPaFvMcrUE6zJveBeZ4yBHBL61KUeIezbKoRbpaF1wcDngXijae93er+yoobS/B4xN+/LNeZ+q1T3Ed0nCW8M4aNjU2HB9mSXOjxaRcw7lnSQlSU99Kp9Jm9qmYAwFn+zkIjGNF1Ex7WlUsjDy2nZ3Ew3LRx92cMVudVGi5Spcyer3pRATXleGsGN21WAmCd8TQ3LWkTlwGNqaxPysfqTBmtvcnnr9jeQrTDjd7+cBfV663OrUf58c54XZV8KXcteyOtRON8+PlS
 xyDiNbok
 GPg5EjHWEUatDnTPOIltu6usRLDpbP9imP4LrE9pCEPqbhcdVdAmIHB3rDs0PTScLlSp1+5KWTLbQk07pg/mXkjBgPiKi7Vjo0h/VaahSvEN3pwpTilyKOPBHGfHB/RazBh/Sr30o27o7MpYvOU74no7KaouFkvgf5HxJcGsOX2xE8Y7ovvK/5PL8n8tO3KtgilF39Gh6TMmfd2BibJldPJeWNDWhB7+39NjG4AHRpsNkk7MEpbVUd8075vnx9FGOH7jd1JHOuErl5cO+ddkkrPd49ZdmvA/L+hbu2JIUYwwa2GXDajtlunXfHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 15:02:44 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Add documentation for the DAMON-based Hugepage Management
> (SAMPLE_DAMON_HUGEPAGE) feature, which automatically manages
> huge pages by identifying hot memory regions and collapsing
> them back to regular pages. The documentation covers the
> module's features, operation, and all available module
> parameters.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  .../admin-guide/mm/damon/hugepage.rst (new)   | 113 ++++++++++++++++++
>  Documentation/admin-guide/mm/damon/index.rst  |   1 +
>  2 files changed, 114 insertions(+)

This again feels like following the non-sample DAMON module's patterns.  I
don't think a dedicated documentation is needed for sample modules.  Could we
drop this?


Thanks,
SJ

[...]

