Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC31CD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 02:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC656B0005; Thu, 14 May 2026 22:49:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D476B0088; Thu, 14 May 2026 22:49:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3356B008A; Thu, 14 May 2026 22:49:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B80EA6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:49:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7AE2C1207F9
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:49:01 +0000 (UTC)
X-FDA: 84768122082.01.D7F4944
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BDA780005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:48:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UceLzAU5;
	spf=pass (imf02.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778813339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDl56P9DXVKuA44aEtTZafXcNPo8mzTvmPJnf+zvCjI=;
	b=tPuJXpFBqekqiGI6AUlkh7itBU2FTJWcIFIgCRe78Yp4+rJpXmoLEZ9BWuhhsQjMX/mINP
	KxG1DmpF+qVk9xf/v770km/CgbpahwEH/NTkzbqFbgQ8pEILlCFLG4ChpjygBIFsZUnqNp
	krWxydDd7+7jt31/EdSt5k9eEw+WBdA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=UceLzAU5;
	spf=pass (imf02.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778813339; a=rsa-sha256;
	cv=none;
	b=s+3t/lVd3kmqW8nDQfk6SVKSNMImuMDW+IyEyUJIYul83vCYiSPCAysjosKKx45ilXmNMm
	WVutI+vWzDHII2FrOrSdTXqpNFBi6V+lhACyMRl47VsOY+Rjbv+MXpYMZosYi05M7U5w58
	D61GuXBExaWVEpIJm0VxeF/DV7ZEPCI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LDl56P9DXVKuA44aEtTZafXcNPo8mzTvmPJnf+zvCjI=;
	b=UceLzAU5LWnH6ecDuxs0dvaKTNCBxHWZJVYhmynLj99oolo66BRueqDrtZvEl5GHHqtqz079y
	p6l+dl5ez/OIOVztmNo1Lb4yqTrnDI7c9E0In0I2Km1Ie2ATtjU2v7IRCIellcwU9+eHDZJYvsL
	aAE/SHAdWnihL1fWkF3AB1Q=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gGrzw194Wz1K9D5;
	Fri, 15 May 2026 10:41:16 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F0B0B40570;
	Fri, 15 May 2026 10:48:52 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 May 2026 10:48:52 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 May 2026 10:48:51 +0800
Subject: Re: [PATCH v7 1/6] mm/memory-failure: drop dead error_states[] entry
 for reserved pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <kernel-team@meta.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
 <20260513-ecc_panic-v7-1-be2e578e61da@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ebbed082-b104-0bb3-94b8-8e96f6f2408b@huawei.com>
Date: Fri, 15 May 2026 10:48:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260513-ecc_panic-v7-1-be2e578e61da@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3BDA780005
X-Stat-Signature: h7sfexii114mdty1qnxjmuhfhtyesr16
X-HE-Tag: 1778813337-402296
X-HE-Meta: U2FsdGVkX1+UdefZP7XTQFG9CwEe6gUCIwiL7eJhiMUbObIFew8PvUJsXxQF+iFj6baTzf0Zs/L9Jai37PiVnONWyNNS7tS+fnZKGuYVJoIUw6CJCILrF8Sp8BIWF+gXJRQKgGHqEteK5DQaLfex+mRnk/R9P1qnPNB8zoQo3IOXBuhqbejLiCRzO/EqEMEIyPTyTmq/MOlgZ9PT8E4gqY1nTALd5ylME6uPmQi1DDhY+mSMRV06myTRobLjKmUAhfOxX5F32FKkP39JCs6hryDX3cVuGHyIvx29wL4E6oCrxZwo9nytbWwSAz33+7oBLPZAxYlR0uAsHkpKVL2sGfb9mwM1retV1Doke6xlD6dz6aNqTK2DpwoTl8IH7GaC8V6SlLcmy1RgrOLuykVOslBwG3E2u0KtZi/uzfWJDdCUOL1GBEAUTVLpyCQWXi3z01Lpj0/iVgmcPF1JqQzSFeb395BpomwtICtW6h8Xff5PWENdnZZwEeg2C9fMyEuS7HJYT0kxQbk92Kk49rcLDirEAITOMKc4l35VO6rtIsO2VgtCTbouJY/EI/rqGzrBXHFAcDvnE+9mj3SgJXBhs/hnKaspVCp8zc8CSUMlmpJ0dH3a2o9odQBCCxHm3pgOVh7aEBMl5xv2QSxlZfhVSFH2cKHPtxvzsT1NG/f7WLUuQG+7raDt+LbHk7U/aJlyQj1PhS8PqCx5ZPmYT1z8NFAD3iAd/+w8G8pR8YzJncN3N8SnO71ENCCkbhPI0Qq1elZvxOBh+o9N7Q0LBOhPDWiff7HA0+e+ABkvtWPuxYt01PvUQ7qPa/rg0/23Gqk/uFoTJPJuiMN5PaKJbPiNCcoXChtXNSDFq1PGVjN8LmQ/UZjprEASriQ15jcryzxfnabQ1yAVoryydU2zsuy25iBhoCxXwdt5xPMdUL8I2BZojG7MI/ZLxFo3iHgVjND6ouZLKsO/5FDa6iJBTfR
 xy1Lr3aK
 zKtRxYfnvIHI+T5navhO+GyZIYQ+nr8bMcIKk5tDIjDkyXs0XLNcxg4gmJ2w6+e5QU4JaN+LDrfHRAf5NVCPHjW4jh6evOBhGWrjm0RsdFmQ90xr2QskETzAGncyZEZWbLAyvMFSLm/4yo0SUGRtFtNprn0EW1qp6wLiVzjTX14nvH81Wx65sWHyHFgCXp3t7i0fnRBusa7y3x64j4YcKprFxbHbAddujRuyqLaN5w7O4MV9sB4f7CPzHqgGiodhCyYSaz1R3SD9xVHQHi6lCCARFAN1XF5jq5RCJwh53iNvu5IxqKLdQsvMIPDkQmLtGcfKVox5RXCjHxI1RrkGNdhdR17Z+L8SUyckeBSRMMY7CeNOVq26+dXOO1WsL41Ca5kKyrSwsqhknO7Sn9G63Bp7zmP/UPiad1EodO12IRMw/GNHOYzPd6P9bZrp1BibwnF/6Jaopm2oM8OohC/M84o1i2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/13 23:39, Breno Leitao wrote:
> The first entry of error_states[],
> 
> 	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
> 
> is unreachable.  identify_page_state() has two callers, and neither
> one can dispatch a PG_reserved page to me_kernel():
> 
>   * memory_failure() reaches identify_page_state() only after
>     get_hwpoison_page() returned 1.  get_any_page() reaches that
>     return only via __get_hwpoison_page(), which gates the refcount
>     on HWPoisonHandlable().  HWPoisonHandlable() rejects PG_reserved
>     pages, so they fail with -EBUSY/-EIO long before
>     identify_page_state() runs.
> 
>   * try_memory_failure_hugetlb() reaches identify_page_state() on
>     the MF_HUGETLB_IN_USED branch, but the page is necessarily a
>     hugetlb folio there.  The first table entry that matches a
>     hugetlb folio is { head, head, MF_MSG_HUGE, me_huge_page }, so
>     they dispatch to me_huge_page() before the (now-removed)
>     reserved entry would have matched, regardless of whether
>     PG_reserved happens to be set on the head page.
> 
> me_kernel() never executes and the entry exists only to be matched
> against by code that cannot see it.
> 
> Drop the entry, the me_kernel() helper, and the now-unused
> "reserved" macro.  Leave the MF_MSG_KERNEL enum value in place: it
> remains part of the tracepoint and pr_err() string tables, and
> follow-on work to classify unrecoverable kernel pages can reuse it
> without churning the user-visible enum.
> 
> No functional change.

As the code evolves, this entry is no longer needed. Thanks for cleanup.

> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

With David's comments addressed, this patch looks good to me:

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


