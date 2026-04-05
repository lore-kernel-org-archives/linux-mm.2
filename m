Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6457E64012
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 04:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0EA36B0089; Sun,  5 Apr 2026 00:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98896B008A; Sun,  5 Apr 2026 00:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87936B008C; Sun,  5 Apr 2026 00:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A2E1D6B0089
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 00:47:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 268575BC3F
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 04:47:58 +0000 (UTC)
X-FDA: 84623269836.16.2F65E67
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 462F3A0012
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 04:47:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IuP2PMuS;
	spf=pass (imf25.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775364476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDt9N5g6D4SCWCX4TwS2U1BYH8gHEqTdtRgHFVI32PM=;
	b=fnvtOiArvRJquC7Bseulx4fomCI21NxuCE3nLb86ii1u/dzl7srV8SKvK0A9OYGa6NirzW
	9Ge6lqteH1yc+nSkIGYnRCv0M2p2zWxv4WAHanH9KcQGQoiLij9cAuXsR2frY+gt2ekXNW
	HQZsTuTSkTYSL7azBIYQ+W3uJ6tWwRE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775364476; a=rsa-sha256;
	cv=none;
	b=TLlprOkUTEPXzZM8EcJFH+xE4S0CCPPEDSsEHOHrFk227akvIfIhFqdm9mZ4dO74nfpcXT
	B/8nd9bdHkEO2OHVB0vtKNuys6avsqUO1bHJFgjAwU8Fmv0OHEQlIMzU3yPkB6Vm85Yr09
	DOacgYncsOdlFoIMxGQMLs0M4RkzkkI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IuP2PMuS;
	spf=pass (imf25.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <c7282d70-f7cd-42ec-9f79-3ce074f01970@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775364474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kDt9N5g6D4SCWCX4TwS2U1BYH8gHEqTdtRgHFVI32PM=;
	b=IuP2PMuS2U8srTZc94C4wdOggHU278UEqT5k+APawMKeUWxCzz2giMReCPaG2P9yAkqLAF
	7qUidZ8lco7cqgjBUqW5qiDv8Am2qwaiRz8hU2sUxsDTR6UPlfUXfKxFM7b8GyCANrgfj1
	oM0IGccgRwKuOi1M3oySQYJ6xEF7Lgg=
Date: Sun, 5 Apr 2026 12:47:40 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] lib: test_hmm: evict device pages on file close to
 avoid use-after-free
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 david@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 dri-devel@lists.freedesktop.org, balbirs@nvidia.com
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331063445.3551404-2-apopple@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260331063445.3551404-2-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: qhg5mx3ie59roww3ynaupqtj8rbcfxhb
X-Rspamd-Queue-Id: 462F3A0012
X-Rspam-User: 
X-HE-Tag: 1775364476-623085
X-HE-Meta: U2FsdGVkX19rQTqdRYH/RmMo9nASVguNUZHTI/Xp7de9kpI1IpDlwKj0Ca4IKMH2B1VDT96Z6GD3I3LEewes6EGY1yCA4wccM9pEL2ihHz+3wUCQq+yDlOL58mkyEKxCvXd2jniKCLQoPR+7NhDnoQcO7Abtp5IF+H2O7kU0c11vIxlZsQmdIO2IQrhl4mfuFfpvbAFlGVbg/gQPNKb/r44Iozlo8lxYDnU+8xy97jRLZqQR1oyHPGs6Rlw0kbd5CafEf6z1EkM1MVHxUWMgmP2rEeWv97BhrXs9R/mh3ST3S6eZR7+jYzfqI9QZoU6fKFNw/Z90C6XC4Q7EJRuOGdekpJnVqAUx2le27S+HfvVCcfOKueBmkLffxMSnIdlBjrkySeA4sXY1SrKGFvmM+t3YF8TTJzZluhYbf4kxz8oMRvrG+5CUTRvRh5cFO1yEK8eJQdHYdyE6O+d1mRGlzRkSLtz5oVquqVbkpTxZAB4tSvbNmTQR/ut9Od5tKHRUQJCUSLEW/Shs3R8GStwgNQu+rssYCq0ILdJfsfeB3o5aP3GTtAJvfFNvf9GymPT0xVBt9gLXPICi37wigzDPY5GSN6jDCl4framD1WPBbdvTAbXwnSc+WbP0xHO5+b7fHab/ozcRtCmPCI+bu7qYSBgDbEU16ZidMlzlWL6AzXWV3PTi+ivEdGcYVxicT6gemgAoB/Aih1QDfC9pDl1goFMciRClE3EJZlXpgY2KyOA4VBf+/5dq8Lj34cHYFQwY39E1UyA7pFp1D44I1NdmqIwQfZeUaa3o/iElehvLkCDF5rAf9YL8XAVzTtjf5PZHP+3lo+nQq9Aukif+6KshF/81dcuLmyxKZa9VBCyy/HvU8b3LLfJRu0B9qwTfc98eQkEimrkIPNrtu7amRck+veM5xTGCJ2jDBpYxhq+P5I7K4qmG74kmggDrRLy2GtmivVTb6GR9d2ZAL6ijsDa
 +quEQkKD
 buveZoTWEhC/Vi4+RSVxV+w+dVA0fB+I8QJ17sI10jCIzNmveiXCpduhJyKRlZVzysHwIWAOrycoSVL3GkKVN3vYF302ObHW2AtHTM4NnJajLLXA/47/pRFnsyfaqCGIU4icfnJX06QdDq3altFD68oPLDijsFwb23l16nCZYKF2Bzv7/+pq1vBDUNwribl9zM4iNSkLY37a0vyJTIscA8vsMgUZH8k+hVr1/SDzWRwACkp+LLe5wY9/oHzkfQ8pPh9qzYPSFceYCxsOmteb9PAKepcvvdtiKR26Cia2y9VX0Epo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 2:34 PM, Alistair Popple wrote:
> When dmirror_fops_release() is called it frees the dmirror struct but
> doesn't migrate device private pages back to system memory first. This
> leaves those pages with a dangling zone_device_data pointer to the freed
> dmirror.
> 
> If a subsequent fault occurs on those pages (eg. during coredump) the
> dmirror_devmem_fault() callback dereferences the stale pointer causing a
> kernel panic. This was reported [1] when running mm/ksft_hmm.sh on
> arm64, where a test failure triggered SIGABRT and the resulting coredump
> walked the VMAs faulting in the stale device private pages.
> 
> Fix this by calling dmirror_device_evict_chunk() for each devmem chunk
> in dmirror_fops_release() to migrate all device private pages back to
> system memory before freeing the dmirror struct. The function is moved
> earlier in the file to avoid a forward declaration.
> 
> Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks,
Zenghui

