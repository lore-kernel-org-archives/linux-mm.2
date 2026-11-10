Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4383E606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 19:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I/0Wr5Mk
Received: by kanga.kvack.org (Postfix)
	id 517426B05B3; Tue, 10 Nov 2026 14:10:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EECD6B05B4; Tue, 10 Nov 2026 14:10:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4056D6B05B5; Tue, 10 Nov 2026 14:10:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 197B56B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:10:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4841140249
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:10:01 +0000 (UTC)
X-FDA: 85420149402.14.35CA1E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0989DC0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/0Wr5Mk";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794337800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooMQgbr/cid9Np9AOt8EZOiHcozOHCgOuAlmJBwsLqU=;
	b=rtKkuWZtSLVD87rPcXGIcoeHQpLsdMiJLFnfTdtZvV1QT7vs2JmxxOYFO5xiJjWkadbF3G
	7PvT51cCBbqooZO9ciMYYxjFxbM2+dw8uIi9YaPa6eeEGMxfu8Xs+QgLMzkvaldeChYsT6
	Rj9/8YZ+U164d4ApLV2AeUXRnhHWD5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794337800;
	b=ncXq5bx7iOORtXHYzr0x/xRfC8UqxdxML+q8la5CP0VzvLbVMp9nvOrXB/bN3PE4Q4+Uhm
	z2wPgHOPHUuOHqPmOpHUm6fD8rW2+OS0u1guUgpN3g7DNBuf3FuteTI8C7P67wl+Py/0fy
	TVEdPNmuuBVnGAbUzsHwKnBv6LxQumA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I/0Wr5Mk";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 500CF44E77;
	Tue, 10 Nov 2026 19:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9081F0089F;
	Tue, 10 Nov 2026 19:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337799;
	bh=ooMQgbr/cid9Np9AOt8EZOiHcozOHCgOuAlmJBwsLqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I/0Wr5MksLL9W7rJemxkrGsIAq81CuFPulq6SqedrfIz9l47Cc9XOwBlQIhg3Kb0A
	 PanfpKM+qUA0tY7wda92a3K9gBLMN8frc2Yj9KwAXZ3mV007x22UXPytU6cvAjgB2s
	 QdzrVXWzl1a7Y/FxKS7k2oWad1x7yS4uT0q7k7lj5H/m2ThxoSsaPfh3qctJEmz1MB
	 NozXDZLc5qMGXbsBvOl9RY9yPheiTt7uZY7GKBODVvXnnC5AdLQtmcSdIxNqUFLtLa
	 RAC+nhZrayuc/h+zHwYZnbYSirnKDmTFonJ7CU7fkjMqiylGxDvquL5MTSdje9Bkn3
	 7tDT+hVGL8BYg==
Date: Tue, 10 Nov 2026 19:09:53 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
Message-ID: <avNrPKIoZ3JHiAjh@gremlin>
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
 <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0989DC0004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ow7ms6867wewp5uz61qiedjzmx6wfur3
X-Rspam-User: 
X-HE-Tag: 1794337799-271919
X-HE-Meta: U2FsdGVkX1+eYJQHn73JEatYpNX2tDyH0iiAgCF1mzo58jJarRLbnAHhEJCbLgyKyBRwCC03ENfpn7FeRf8gVswS6QPh5L+CSCSNOVTUxk+3dXu2eRsShkaWJbm5qZdYzriIIPWgvDMnG18MJ5SoztEDPWPJ2gIZUuLeN84ikhy95oOEIliKsasdkXc4zMboOZQUPYMCRYGoSWJZH1O23Sinphx19qhNDKMeInpaK+wnOqkX68XYDbmAHjlZxjM0OtRTqb5AOMrl9xjytFG5XzrrotyR9ai6jLwZBtI7PlJshNRL/cxMzp2AxA/JMBYbXvy4RSrNHAHoVHtbUq8TpOYCpXzL8YvGctMSlX7Mb1ud5ikp74HH4RedYUejbc8HQ7Oty5v+B6KY64/JKskHq9lkLaNy/fXELv0mVk1zTnqfdKlhJAAEIah0W+AaszphWrWcO8r826sZU+3ewUQWhqS3NGMuhWm/F88XDgCUaVdZ9dpiyFxRLZe54iedNzGjN+F/Q7alZiMgztR/QuBzzdmlmmqimAVWMX0HiG/DW/4eITbKCAzZG+Ui5F56HICOFTRG3uGHT8ecgAME5DYbLcFbcUuq0oCdygpUXaeUeUTQkmF4B6Vd3ez3eRl4AAd5mcSZ3L9GZ/VGsr3jEbQppSA3DWR1h0iP9uj24ugbdDQ//A3ozhQNd3azjrZiUGrfRf7o5VYSl8mflGqsTAkZn6bfsTF/m8I/8j2z4ulABP8VE3GVCNq4CN60lrT+15J5ATSMY8VG6OSViTbwnafW/De5vMqNEpWCI6G7ZkXZk09k0vi0eeKG6D5ry3f8O5nxb0DfiMufV7lSw5+/hjAzFLwHof41HvNa6qqxDcp2OEzJnJldX9Unrgkj8LHCFH511kdT8JB4FIHPB44S1jA6qMSMtZ7Cgm3w273nwOjDh9I0ZTVqScG3DJ25pgWMh6B/vLYyUrdbSzX5h6hngyX
 UMc+T/ia
 W/HTVV6UBa8OFpLGCjOKPgsniyGophxHHp1vtOJhwImHGREA9nV6Hw/pxtQhfV1MyoICNj4sMgEqU1rT6w/7qZcZaj86zVh9MYTv/Ra/XtFChwQkBuRafSasjRRhuIXfGWLQLMadfLPNHozIpgme0Oq7pCl/CiMQdZyQu1VjwYSMa2PzIsv0TZe0yQraARETj27bGtLQzWwejproJ1nAuhCDoR64kH4ml8UWvBe+7AIoyRZsccCdhrztcI6XOF6UHI3To
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 05:19:13PM +0000, Lorenzo Stoakes (ARM) wrote:
> khugepaged walks an mm's VMAs under the mmap read lock in
> collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
> them if encountered.
>
> It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
> when these are encountered, however only checking this budget once an
> eligible PMD-spanning VMA is encountered.
>
> It can therefore hold the mmap read lock for a long time if there are a
> large number of ineligible VMAs present in an mm, over which time no mmap
> write locks (and thus no VMA write locks) can be acquired.
>
> Address this by checking whether the mmap lock is contended after 1-10
> ms (depending on CONFIG_HZ), i.e. the granularity of jiffies. This is a
> long time for a lock to be held, so is a reasonable compromise for
> determining when best to do this.

Oops I left this in from the previous approach :)

Replace with:

	Address this by checking whether the mmap lock is contended after 1024
	VMAs scanned. This was measured to take around ~100 us on a fast
	machine, and given VMA eligibility checking is a light operation, it is
	likely this will remain at the same order of magnitude for slower
	machines.

	This therefore establishes a reasonable upper bound on how long a
	contended mmap lock is held.

Thanks! :)

--
Cheers, Lorenzo

