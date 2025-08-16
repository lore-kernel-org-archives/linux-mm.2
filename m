Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005BFCA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775ED8E0226; Fri, 15 Aug 2025 20:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DCD8E020B; Fri, 15 Aug 2025 20:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B8C8E0226; Fri, 15 Aug 2025 20:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52A1B8E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:14:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED05AC030E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:14:21 +0000 (UTC)
X-FDA: 83780698722.17.9F91C1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5589840008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:14:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPovdOdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755303260; a=rsa-sha256;
	cv=none;
	b=dFRGBx7HMSlzoKZSlg5TIXE3GTaZAH1lcvUKDdxTn1DQ8j9F0/fsw9PsfTViVKKbRMzDsT
	FwAqb7L6ra/QRIB2hpofn1SZBTWXGKGnLcUdZmCzZRF2EyQo5OaQZpT3qA1uOcDU5YkeWg
	W39QknBr4ytLlAgewxrbfXyjqzmWdwI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPovdOdI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755303260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ11CVDEYXNXVBYpri64/Pu85QpYNVoc5JIgTcqd5js=;
	b=jfmhzSsFb6flfIn/MzNONEW8ANIYMnx6gKV394bQt2ZABhyH0IO2p9c7pG1hOSARho9m0l
	6CFcGGk3Snu0ZVbLqRWQCi8CApyGHt6vlkum7YHT2dD0V0oRy9SweXQGfEulbaQGS8kmbN
	UiTEXFIW3JwHaEHXBTDd2j8GELMVD7o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4367B6141E;
	Sat, 16 Aug 2025 00:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6042C4CEEB;
	Sat, 16 Aug 2025 00:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755303259;
	bh=9E2a9HWM2TF4Tj0nfz+ge7orBtJMia0qs6lVy6H72Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPovdOdIU5s2hlab5l0iRg9GNOXSYe+UJajnz7CYXVCGaiKTBsmn4ltLuC5FVzWku
	 g/++t835BnUWvSCh2conBRqalW1wxqp+fs2XFwzk7raKTuh+4TEnWnXXnmVnCAbHbF
	 Ki2SeSPxdyYFyZEtT4b+5Wnzo66tzwoRg1Mo7NmPPVcx6FIzHu1ihDvzul0dfbjxzx
	 cJkzum5cQeNpvmyE1YjuSHA+FmhInXbybAjGZG/gWRxerBrHOz+DjCYChEc3TzusPO
	 GeMnS4R72PFkMsxh6VhAOhJwXRFZJhtTuvITLqkpdgC2rZQvg5v44eC1r0bUUJ1tw6
	 rWsgfxYrtJqmQ==
From: SeongJae Park <sj@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Fri, 15 Aug 2025 17:14:15 -0700
Message-Id: <20250816001415.90915-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAKEwX=Mtu3KyNUv_oWFo9vNiWKkmbzMXmG3t=XgpVtG9C_v2mA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5589840008
X-Stat-Signature: 5pkhf81uyp4f1j7zt1umodu65xt63zho
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755303260-865194
X-HE-Meta: U2FsdGVkX19GArejh54QaxFrfSrSTD03s3rmuUz7vSkguhiICGbsjQXXCpNke2N9If/v185BLebU8E2dqt1UfR5DpitVehirkYB9npac56QXOqULNYCe+w4Eg2TJkdfXyc7kH/Y12oXJnhDKDbpfSh7tr4b5uS21lKjbFEedRoYTKtOLIU3BKz8v6/HMhZSrVrp545gfXIEmh/V5J6MOmKdYb1DclUw0zwUS2r5rPNR9a69+XiQ7u/BlQSYNlldvtzAbSIZqF3Il/vGRyd9TodeYvom4Zh/rV8VqDttwcefhCDJUXFcOohaGjZ8Lg5vT3+5aklABNmG81GHhVaQt1MU0cW59fXZxBPKharLnBNirISOyN5942eFvbYeGPYVv6f934EfoLz5Uz/3vAmz/eOHbSh3J0au+Two7UIMxiBXQikA1B45GYCFqiPVTj7QLEiYZiiJswhlKuWWjOpVp8qSFLfZWtd5xYL9jdWNXWG0qJT5eoBFy4RI9ZvwaFkLtifEUmBqkAfEPyzERukCoTN/yJ/jIyVl8J6+oZ6YPmEYcJ8Jlih1N02gijNWQlaBDnnA8t0055IsYXB/wEwvFmr3i+YN1/HUNRNbtAw4T4B8yym12OpEdfi0m1N3odMInuFVBaXGfimRAHwQsmYdVFRg6rFvhT9t2kvOQF3iN7/fOZfVqa3e1KYG2wOTEVc5+joyP2r6wPU4i8W97w+sPPCeGN2i88MMQxNR32jFv9XuOmLv4YdKp/7lsH7hT7pTdgcPx0aLsfLqAnlHUv9Yi9dTJi4W61VVETXOM8E+4wZs7Ohu0KvjK7qICExD0+0X1NYGmZ42xzdHMKjEv0RbsKH/Yx2fxOzUaG9/H54T5uxkkSAB0VMPGXdCd7avv532+Zkqr5K76YPJuE39WHSmiEOy6TpNBK9SU9NY1oq6YbzCcGoxirzlMEMqXEJeayBTEkPZ9If1g3Ao1IFBSfUc
 /Y1fIyB5
 S9UmvRPoUgfKcbYTetiWbkrzZ1ik9TIXSoSA1LSvy8IaFEIjvNnQ31uG1uNxUSh+89xWaE0U1DV9kd6ZQECrSWKFdrTOQHyInYvc+Z/jVJW1KNyV3+Atvv56mWvbmjhKogmlN42nMW69th275fjpYuDJZmMQXBx6X6pFZaxtL6/ejPqsEy1leR04b1f9vBqMjKIrfhA2ffRdQFnrdQjADKz3t/nxG+FPIMeauzJ3L6pMsm55cnswEEaOQSE4xF3NWUDdmqZSuMvERHulcaTh2k7QX+zGmGndaRbKsKZQAnFNCcx2v0j4gdG70+ihpIcovi23yd7nCHv3Lw5LEmQO8b/8jAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 16:08:50 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> On Fri, Aug 15, 2025 at 3:29 PM Chris Li <chrisl@kernel.org> wrote:
> >
> > On Wed, Aug 13, 2025 at 11:20 AM SeongJae Park <sj@kernel.org> wrote:
[...]
> > I slept over it a bit. Now I think we should make this a counter of
> > how many uncompressed pages count stored in zswap. Preperbelly as per
> > memcg counter.
> 
> Actually, yeah I asked about this counter in a review in an earlier
> version as well, then I completely forgot about it :)
> 
> 
> > I saw that you implement it as a counter in your V1. Does the zsmalloc
> > already track this information in the zspool class? Having this per
> 
> Kinda sorta. If we build the kernel with CONFIG_ZSMALLOC_STAT, we can
> get the number of objects in each size_class.
> 
> Each time we read, I believe we have to read every size class though.
> So it's kinda annoying. Whereas here, we can just read an atomic
> counter? :)

Sounds good.  So in the next version (v4), I will drop compress_fail.  Instead,
I will add two new counters, namely compress_engine_fail and the new atomic
counter, say, stored_uncompressed_pages.  Please suggest better names or
correct me if I'm missing some of your points.


Thanks,
SJ

[...]

