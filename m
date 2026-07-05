Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4ED7C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8426B00A0; Sun,  5 Jul 2026 04:16:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968F46B00A1; Sun,  5 Jul 2026 04:16:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F466B00A2; Sun,  5 Jul 2026 04:16:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9C46B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:16:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA6DE406CA
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:16:38 +0000 (UTC)
X-FDA: 84954016476.29.4094994
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 253E5100006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:16:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RygF87UJ;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783239397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zizsnsWJL3/EpRjgM4/piAB0Nix3kO/XS+7rXU99wzM=;
	b=EXQE7cCrupBfZEfzftOKAyNK9euvZE5EEyHgEbwD+WfuB2n+p2J8874bj3J79K3gW5rQrQ
	xIVd/L4mo9c8DHVqnEbMtu7NJsmUTdRG959P78sB12qLXyucW+yUgSzSbGfmBax6g87jwq
	fgn4qRMXI1UEnE68RmpBgpsjJBeZjLk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RygF87UJ;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783239397;
	b=n1l2YZP355jWh0I+ke4/Oq656/uIhGtObeJQKpp1wYnJy/8x7V4LytqAk2WkLvmgMNs3MF
	flzwA3OZwWB7UBI03l7mIjWiVHmoc93sG/3pr1gOUQ7h//2Zyghjs2C9CUZB/NDkS30ZhO
	BQeol61imvpITQhzRICqRd+9tfMxBmY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 91CF760052;
	Sun,  5 Jul 2026 08:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC43D1F000E9;
	Sun,  5 Jul 2026 08:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783239396;
	bh=zizsnsWJL3/EpRjgM4/piAB0Nix3kO/XS+7rXU99wzM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RygF87UJr7ykgVkWEn2BGjPORrY/BmHa64iKdVNhgnFrqKQLqvUci1BlM/Bsnlvbg
	 DbVapVBxkSjp1Br4euzoZBdHMEY2XyRia5BIASYsSh7R8mocbuMti2OChwfPR3kX2R
	 ts0yuLTfSWIa9TyxZPsHMwv1iJ5BQj3qjMNX0zFM=
Date: Sun, 5 Jul 2026 01:16:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)"
 <david@kernel.org>, Gregory Price <gourry@gourry.net>, Zi Yan
 <ziy@nvidia.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexander
 Duyck <alexander.h.duyck@linux.intel.com>, virtualization@lists.linux.dev,
 linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: page_reporting: allow driver to set batch
 capacity
Message-Id: <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
In-Reply-To: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 253E5100006
X-Stat-Signature: c15xtnjwfz4qishsps68w7c6c4j53rcw
X-HE-Tag: 1783239397-67738
X-HE-Meta: U2FsdGVkX19sHhk5l8V/EJV7UDxNjNsCTXtLrkUSsypI2abWH4tWyHLqkeqeqkDMghxMdAuh7/IjK+jMscehUc/WTCIBU0mTb2sXIud3AFZ0njqEOHqKe0CRdph4po7O9kKNA9yLNguyworFDAHeL/t7BDCXyEY+GCqR3/Mmam0X6/NPXO5U2ERJrdiQ0vHeM+V2JbrLHZwWRzDN9hJWn7LKcA6G3TjC4M1AniQDXWDjWSGmpo0o6Lkne0INMpRINIZPGaItrW5bdmk3Kv5ANYaXNDvnwxJ7IpO/U5zrycsUAFrl9YIgooOeTCfjqzguCUJp/Jh09y43dLuAPqFnujpk+u39NAswiUVpGsO2NPOVPfe4Wcid9mkVm6jhsm2WQkV7pPAzbHuzaJUQg13IJvzu/2cZAaRsGf6TdD4etpBeG5BwCzhjMt/S3d/QIGSB+iR01FqWbSSPPx6rdOdZkgExyKwrK/+kWkPdR6Z7AIpH2GeSTYyajh1/TwPW7quOXkejdw/Za76RSdcX1etwng558GmKfGeBBLIr7MOQsOG0eCADtn0/ssN4w1J7TBuc8RYGHiDuCJJNu+uVNCvjUSKOuXYGTFT496SNFjZEmRp5JfVpQcXi/slFL6Gv2rM+j+s1ieZJEi214X9zevw5lSU/nIZFSljfjMLzQxh3wT7t8diGp0m3SZnt2IQSxGnsnLPoe5TBsmIcM9CuMs3oEPCdjZTKTU4z3Oi6SLwSGOht5r33gCL/896VeE58Wayjy4thGkWA/nLU9/LAwb1gUr9pkQmEyALN/q/Cc5gvjGxYohEGN/W+C2WnwwhGGpZ+P7kGTDH3L52mxXDCSLZXcQU7u7HR4I3aa+HTO0tRMpw2fvSyJ4BCWoLkr+sF46o+JHLjXb5Vj8K1ps5CbBlS9Zy4mW1F5Slh2aG2S8isWditH0+FAWKpu5d3KQagiP9VkPxWURz12zpnKHt3QVj
 S6sytCLH
 H10/RyaylS2FQPCePIvfV9GmQxxjyihpqkCHqT8yM+KVRChpKG1xKQXvIEuleBztiX3p7oKhQeDQpFhno/75o9egKDx7rGWv/v5uYvtOiOdkr6fM7gUNEdKiWJZo4Lz7Bqx3kzLxLfRFjAeON0x0ZKgGkICr4lYItOoGHZS7xCQOunjkaifJ/Cc9BC1bFhLvVt44OIqxTwO5k22mCPJ8vgbhSmpQ9iX0ucDUgBToC41y1MSmAk8PxLqsbs+j62Ho8XKqHRjstUmVv4lsplo+fSyJLTve/ECMPsp9n723dU0LCbfg6Kgt7Eq4myBAT3OciAQ09Ukc2uno3DoTNzexgOtO97hk7f9zUl55UlF1KZ7zxWuVAUBHY27SEc+WUufAQicgA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 5 Jul 2026 02:25:13 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> At the moment, if a virtio balloon device has a page reporting vq but
> its size is < PAGE_REPORTING_CAPACITY (32), the balloon driver fails
> probe.
> 
> But, there's no way for host to know this value, so it can easily
> create a smaller vq and suddenly adding the reporting capability
> to the device makes all of the driver fail. Not pretty.
> 
> Add a capacity field to page_reporting_dev_info so drivers can
> control the maximum number of pages per report batch.
> 
> In virtio-balloon, set the capacity to the reporting virtqueue size,
> letting page_reporting adapt to whatever the device provides.
> 
> Capacity need not be a power of two.  Code previously called out
> division by PAGE_REPORTING_CAPACITY as cheap since it was a power
> of 2, but no performance difference was observed with non-power-of-2
> values.
> 
> If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> page_reporting_register(), before the reporting work is scheduled,
> so we never get division by 0.

Thanks.  What's the priority here?  Should we fix 7.2?  Earlier?

It seems that Sashiko has found a pre-existing issue, a hard-to-hit
error path thing:

	https://sashiko.dev/#/patchset/444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com



