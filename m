Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17992E83041
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 02:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B713F6B0005; Mon,  2 Feb 2026 21:39:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EC66B0088; Mon,  2 Feb 2026 21:39:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2AAF6B0089; Mon,  2 Feb 2026 21:39:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 925E16B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:39:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2449F8B5AA
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:39:22 +0000 (UTC)
X-FDA: 84401588964.17.B685B7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F30C140009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:39:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wIupbiN5;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770086360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjvuVAfKIvaRTnlIDtmXz96gVY7SMTHuAJjjhHoeDUI=;
	b=4ZmFKiZR8PTUjYIV0LMrOGc3IxIlud65LgvSiTmbkAZytvqwvdrhsnchGr+nTvLpx88/Go
	YZTRhAuUNbcvw/tIc9iQes+C+0gJts+sFIu51/05TMbysyFwu8c1CVGBHdFo2PHbIMAkYe
	B+upU8OugZaoWk5sqlaQg9j2+r2FB0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770086360; a=rsa-sha256;
	cv=none;
	b=dduyrk3rJo0QYWjDu3UYxzXPN+2XxUhCtdel9NQO4OnAGvwyk0Fm92LTSwtFa4lkcIE/RS
	/eg9KNjUhbR0Fvnsw4Z9BnxrX9V+klQithd1ygMqftagfVYU3sHVWIWovHpY4mlqPEqwy3
	U5SVwrMAzYvCmrzRaTUc+HSNSkZp628=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wIupbiN5;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F09760010;
	Tue,  3 Feb 2026 02:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9A9C19425;
	Tue,  3 Feb 2026 02:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086359;
	bh=PFouNFmJPcItJkoCjf2nW+gBfA1Uk2K5fhShN0MNegw=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=wIupbiN51G8pvhpGQEtZRLIGcxFA1YurL9mL8e+20w7tnXqaOn2GY8VihVfXh9HQx
	 u0BTBD/1GWs7VkQAjwe9tnM2Mvl2+wkI1HaekzWae1XaYUXoLMq+kR+MzT9sU6OkbP
	 9v4uevy6Zw0lZEmHCbh8/OunQ1Zn22Lu9ekbz6AE=
Date: Mon, 2 Feb 2026 18:39:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, David Hildenbrand
 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Wupeng Ma <mawupeng1@huawei.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] mm/hugetlb: Restore failed global reservations to
 subpool
Message-Id: <20260202183918.057dac34b3a1819328814fc9@linux-foundation.org>
In-Reply-To: <20260121094754.8a30b7f7fcff34f579883e40@linux-foundation.org>
References: <20260116204037.2270096-1-joshua.hahnjy@gmail.com>
	<20260121094754.8a30b7f7fcff34f579883e40@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7F30C140009
X-Stat-Signature: 16obs64kncetpch6conwa1u8pii3isju
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770086360-747982
X-HE-Meta: U2FsdGVkX18Sil/OWwNyqtpdp9PPCFbFMITOWe5mu3swoOESk2wpxFDlxDQ91lKwkvaR3gesLt3ex5rJ7VmJqF8HlO2vrGI5Q+phYVui7onzAgfaelRm4dlob8/szw+p5v3rto6ZHh3c5WZrK6LugyK0z+aVehppnDqT22D+uBocyGT8MHiMkUgCbA9HWvw4g71KJIXpHAdoE5ySyhMLpy1P8JheQwZTvONVWQy6txxWN9lACCwezshaaiY0Fhp4YqNsGIXQHybcm8UoR7AX4YUPE0MV5jE6wIzJIeDktBJv5OMaes5NmwTt8ueLxFXjRfTMVWV3A+6sus4Yiu0/1dbr4Amgcty2NsjFQFSdskRjmn2Z7FMayF39hgMU8TK+z5t4dutEvDuw/fMvaJ6M0hZdAqY/2wryGm81N5bcJkcbTdFA6x/nCGw4fYYRvDVXM+3sWuABzCBgKbWXa4mwJIoIsTaCWzI86jo5KFN0ZJQMTHBohSBDVXTdlEd07jTb1wdOxLSY4iAngngprhyp2lHL13BhP63MUEm7IFxbR0zlpL2oHz9/FNQtjb7eP2+Zc1Gk4mjsu1o9HUotw7mz9TW6HzGgpBgeLajOLhvdx1LLCB4FChjuWPFcoR5ZbxhehLxvTJpiMNhtdo3TR3C+tNLv1M+VfxEcviIBN0prMD1NtPdUYBliZ1Qkr1zILFQSrjxW41zg9IF6zXUORFYSgp5hoLhCSZdi2W2O1KOgVOVpiYwoFR8PlmUNOkgA8nROICCU8gvHzasovBhNvPlHbaAZib2WBHXCXWBNe7+cU2y2K0vI7lFFWG3fgeIJu58EQLeDT9dlz7D8xjWl/Q2Ppg3983gRnOA2JUgvGJndyhk7CTvO5ibLAbASMC0bLXfu5T4tmuWT0dZDZmrYR4x7vrH9EuES+Gjgk44Xa+qBtfoMbh6WNSpt1PznZL59hGoqXfP+HzfewoyBxgxhzoZ
 C63P0043
 JyScrv+Tul/sVgnBMOjRbxq2obEEbYT0Uhe2ova9wGTHEQSMDoSbTFP22TCkU+7xCVrSmb5Htn4Z5Af1fpZ9mTnhyYW6GPTbPUDOvghfi8DAbHgA8/HLu2Gj0GcHK7M4tbkz2IDRNziHt/ZYEkyjNyHDnsr3Ff23r3GJdX4TPa3mA4OUgagZslDix+AwEpWegAcrgPSXBIrP1HzK+SUOYfkOq8Vg6mVWAO/eM9pjxw+NubXRt7o0e8YheaI8qL8+u5RDq5nFLibtM1G0pr7TDyPKCrM5RLjLuBcNwJbm1hVvnYF599S+qL5kSI4Y7S9jmHBlkPoa24bVfvRws8F04HQHAOmY+VGNiEGCZTukc4Gt//u4AKC4q56dt9VHX9BIJ7NAAiy/3ZLZqJj108NEIRGXBrkZmhBhQTFf/Wu3URBsJ9tE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 09:47:54 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 16 Jan 2026 15:40:36 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> > fixed an underflow error for hstate->resv_huge_pages caused by
> > incorrectly attributing globally requested pages to the subpool's
> > reservation.
> > 
> > Unfortunately, this fix also introduced the opposite problem, which would
> > leave spool->used_hpages elevated if the globally requested pages could
> > not be acquired. This is because while a subpool's reserve pages only
> > accounts for what is requested and allocated from the subpool, its
> > "used" counter keeps track of what is consumed in total, both from the
> > subpool and globally. Thus, we need to adjust spool->used_hpages in the
> > other direction, and make sure that globally requested pages are
> > uncharged from the subpool's used counter.
> > 
> > ...
> > 
> > Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > Cc: stable@vger.kernel.org
> 
> This (simple, cc:stable) patch presently has no reviews, if someone
> could please be so kind.

Oh.

Joshua, it's unclear from the changelog - what are the userspace-visible
effects of the bug?

