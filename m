Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A326DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 00:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425E66B00A0; Sun,  5 Jul 2026 20:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6986B00A1; Sun,  5 Jul 2026 20:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5936B00A2; Sun,  5 Jul 2026 20:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F29596B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:52:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58008A023C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:52:12 +0000 (UTC)
X-FDA: 84956525304.06.C68D022
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10F4518000E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:52:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rZWcv79W;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783299130;
	b=mBKoKsq6F6eV8pDsRYEjAFt3/ijSIx7+wRZCDOab57hbrvJinUABYU0COqIOoiB4/LLmDi
	TFVgZ1xKSa3ecBhbnQ0IlyoEMc8LabjYqfL3v7wNHItRKywBI4klaqC0YvesN5RamE1ndz
	bXcbUtXopL6e3QUBFLKjnqYJY9KClyQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rZWcv79W;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783299130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdQ2+UB9YUz4QE1uOCpiZhN+N4NOLTFeGmjHmR8pLiE=;
	b=6gzIrThiv1X9e8pm504RXmvBjLV+K8v4g+ppj2fhJpdvG4JOFdjxBp7aC9o/HgvR8WCXlh
	JkEuUGNrqUgppu5l01VFxaYARv79APT/pvAgpba6KAzMiThHEg1rm1T1zbcu+wGkdO7jMC
	A1J2NDCxNj/wfoDQmUybt08bY3wbIPo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783299126; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xdQ2+UB9YUz4QE1uOCpiZhN+N4NOLTFeGmjHmR8pLiE=;
	b=rZWcv79WpysYiCbzOjWCIHrTl/HEDhmaSAk3AfxOQUI/kCER4zK0O0Lj6laEXYsLsi026k3B4h6+98P4wS7AT7WY4E8a30eUk2FL7N5TRWYjNkxDt7XwMTRfoKAacoKy1NvR981diSK8S5IjngNNknAl9yuUHUxu4zjNddaaDyo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0X6Otcp-_1783299123;
Received: from 30.246.104.96(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6Otcp-_1783299123 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jul 2026 08:52:04 +0800
Message-ID: <5b857bac-bd4d-4672-a30e-f731ec6f5e86@linux.alibaba.com>
Date: Mon, 6 Jul 2026 08:52:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 10F4518000E
X-Stat-Signature: 34mhi7qwkudya3ua1f3fwzh3htc9bh7j
X-HE-Tag: 1783299128-17009
X-HE-Meta: U2FsdGVkX18WysC7dmYlaIkg+TVFahxyDHHYIWW/uhCROIm0PaM0/GpJBg2JgALu2n++ji/fNEDMGgfILhlQ+72IK4dUsgamJ9gA5n438r0JxbOuB49md8Zy+GjCsu5+7lYPecHhoyfPDqGhe6lw6kaLxjuStMlObAOe9NEYvfNWXDOwPWLwofl/sCDmfk1KLwIFYsp6lWE2tjw6Gj6cpDo51XrHMx3dlkr+/oPd82zApy9AnhSjR/ItAwo+UpHpZrMCF1Rf1zCb8Ka6unnD9seVHZKFubVdooOO/EwT+A5tf9BoPBXzK9FfrWJ3L7No5ZHlTGzESZuHQBmabMEcPIFCAzKIsSxVNATOFBCIiW3bsevnPWtib3gXtHTf2nf434XItzuE7hASgPP8CqtwSYSSXUpdq9kInqhSSus1UBzlSHxaGYlKfXPZUKbI4rWAOV2cninP9sJGi5czsCf42bv8XItb4QAvVq7Mqm24ZFJCqwz1Jmxy6vtJa2QYqGIroEnh5zkRIUvbB7SAxgqdI5Wx7AdvESLliNlQ18UxRofdcbTe1QFx0rzMaP43KN3/6mdZPk3cYm3yNkDw46ZnMLF9eveQGfO2O+mtSSvfxQYdQZVP681xi5qBI52OLoWEGJy2g9RA9V5NvF3CEeKSBZr4jpeYIvbMNSTg87mncottT9JfsAfOwjspPD+lo+R5lf3Ga2diTih0iH4kGC54TIa/g4jNRVolJfJxnPhZihkDzTg1acLtFKSvF0IdAlZ0KcuqbvLISFqKh0fkgJi/3y0iOHxwDwB9TlMZUONW+aGNU3CEIw0VuF9qMFKught/JIStC1AFp10k6uxA6il7ksBJCrDkh9SBQc82PFAPJgSj1/u06LQfU1+O8Mdie+zrWC4nB/fVnOMW5THg/qYltmdmjg0CcFYcHAhTtjCeDCBN+l1IR1cuNBb6YThnrKdAXQNpnjonL7l7JN+dYQR
 puAuT/Yh
 uDItH1TQxxf/Q1kc0ZquNDgxgC96oSYVH2x8m9p5ugI+bboXnBRQsXZNPauLnP+p60jv+AGHMfsdLAKhTANYoZDdGNDnXB9rCi600MyixDr7pXTxsii4GGee0ihgdnuzrdvUxfV5+LXE0qXeSJQbvsiCCSKPJtdFT7ranF3qs9Ij6cOjm6x6t2zSK6Sr+hLuDa+yqddqvrWsrryAcZpQJohV5yuSiHMChfOCWuQSLVYSdH9AQSfCUytK5wZkq7eTq3yfIpj5epNVD/4xyzByrGJ/MjrycgBuSOLlVnueVUeHxE+cWrEtgIr6R+qjZYmKeKpo6yIh3veSHcdQsWMShi7lsCjHiHndQyupS3rXSyHSgs/mQUwi3QOvhnyz54w8CzxG2tkFD8evmTS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/3/26 9:47 PM, Zi Yan wrote:
> page->private should not be set in tail pages. Commit 4265d67e405a
> ("mm/migrate_device: add THP splitting during migration") removed it
> without a proper reason[1]. Add it back.
> 
> Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a@nvidia.com/ [1]
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

