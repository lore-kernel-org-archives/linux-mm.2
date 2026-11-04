Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4F15606D819
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b4o9VZqj
Received: by kanga.kvack.org (Postfix)
	id 0873F6B00EF; Wed,  4 Nov 2026 04:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05F746B05B1; Wed,  4 Nov 2026 04:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE676B05BC; Wed,  4 Nov 2026 04:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFDCF6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:22:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DBFF1C3F21
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:22:29 +0000 (UTC)
X-FDA: 85396896018.21.FFF12F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D182740005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:22:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b4o9VZqj;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793784147;
	b=2oXoP2h4+OsQW67vQbwrzH6P9OkNtBHGkfapgzWlH/m1mvzPuuSAmSADVkf1XnNHoKAKW0
	1W39KOyONwkUloYcuXIb1S3tm9uX2K6+yUTSmJizvpU2H3N/dthoyxQERcRFNml6fYprOg
	02IceSlx90jnWW2Xz+rDH5ifCDierq4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b4o9VZqj;
	spf=pass (imf17.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793784147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tcrS+VGA8c5XSNIBjqAwoxO5qavlmD3HQXt9Orq3uo=;
	b=dRjIYqHl8zdkdF65kEIvOpzSDmU2cpSbz8aTUyvRNQgELc8d3Gjl6roHrf49Khg13T+5d/
	b4/eeonclpwbcYucuLvYrF3OKNWu44HFjD5bxnZFo5CF0I/icA45wSWvJfoOcrGP0JiGjl
	JWrEeEZYYACMnFsk1lEwSHDyuQA7+mY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6493B60611;
	Wed,  4 Nov 2026 09:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6C81F000C1;
	Wed,  4 Nov 2026 09:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793784147;
	bh=3tcrS+VGA8c5XSNIBjqAwoxO5qavlmD3HQXt9Orq3uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b4o9VZqjwMqS7Z+uD2u5cG7IO8989ROX9lcwZgswwac+NecRR4mPBPIph8TmJzlN8
	 iLrAN7NiwUqGUHYOKBDhWMh5tp9xQJOCM9kqL4NPQC3LOK2yjr8tiubN4XAG2i9naE
	 l7A89CXxWI4lXXWK+ZNUV1WsiBjiDvsCj4RrhvqxiolL+VbaUaNc/wo/MPsqKuYtQ+
	 y3dCxlxephQdRJRwb8Iw75WmkEANRoQbAR5qXgWouVp0whKw047FaqjlNnqt2aGb+e
	 rNptH+PuZkZsU9ep8MPEl+ow5MtqHyRbLw2cHBvio/zizp6FcDTUYTKT1uiPd/bcn9
	 95dAxKvjuH5JQ==
Date: Wed, 4 Nov 2026 10:22:20 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 02/12] mm: hugetlb_vmemmap: unify
 VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
Message-ID: <aur5TPnkeRmZe5eB@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-3-songmuchun@bytedance.com>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D182740005
X-Stat-Signature: y5f76pik773b8zzejpxcd69cz3hksj8t
X-Rspam-User: 
X-HE-Tag: 1793784147-927454
X-HE-Meta: U2FsdGVkX1+l57Mz1iM9Mv+wnTfuk0ddOzeuvtWQPdVS8i5SzGnRLXsQVbRFVUkPGkVUu/eE2eoOk1yKg6w/aABWB3illlEd2e6ZAojOE7h49qxB2l3nGOcbMpeMV1s4jfxyYjt1PjQPy3jEVf0J45PVWUOn0g7fgMU4YB+yB8CVBkcwYoDMF4upiNab1bicJwPoPEgxOqcBvBFJ6W2qEzaynjTuPOA1qQgQTHdpam7JksrDLKf4f0k+iK2LguDlBR/fiieePc7HQXtS2gcQR7fruugQ/oxz04I29XcCqPXxUbMcoxq3bm27PwjIytKU9QBuDYOSqIAxy3ztJK34YZFpR6+hJSVyEuH6kzJAW1DFZureUgp4Pgm3vKpU4EM+wV8DzhWnkoUfBy64NBC5PTjYhdKsSXaZ21IilU8G9lX1IBALg3ZweQ17+RTWkWuY2T0J6/yntJ/3HSgtVRnm8pq/U6s3KAThRP92WWXqgupZMMshyMUJG6eCbYrN1ma7+5DvgjDSO86U3aR09Gwm/KfT70MjMwGIv7OujfOOowREIYwo/DavHEtZAMPjfXU7LV5DN3LU0JRtvmqHHkMkoUnuYgkGOJS2pxDtHhs2orMd9Wv7oBXB71QY6XFL4IHimfxZ/FWnlQy3SUVy8S+GiW/ryIwtBS/hrrCimpL/8/X4f90UrMCjquqAF2kjK73ryxV8MIo4vRLqBRSDgmS6sjqJbRA2soWDzC8UFWT9BhkdkVOKT65Zl9aGY6NmeElT5yDPMOXhwOP6CduG9qHgkpJa9fOH13nH3OtdxXEYbXIQn00H3j/cWrHEEDYXvPNoefC4/5to7a/AOSYRvAcxwvtZnWOHNnSmpLwftgo9CrhWZ8Qpzgk0JT/gCJ02MpW6oUvogSFNT/nscbtO004AJCjRM5xTUPqbkyYI9NY6Fv9j8PwnWkoAzhj3oNPDS1yn/bieWdc4xSpIl/uRMSo
 xjU9IoYC
 fshgG8qk9IxCGS4sx0V5R2tbC/78gEDI7X4I1qMhL66NHYdNxkdkJRc7AXi+xjbwPerOTt8vJhgkSyHOeha/5BEOFQW9/Gb3aTkbGfyEclzaQqR/uH90RYyXC9vpMxUChMqtdIJnH8Jj0Kz8FNeiWOg7Y0xCcPQew9ApY0ofEZA9bt5604SYc6p+nmF/JcG1/HjtJN5g0o3eNwcgT+kbVH7UNeftD30Kr/2m5LS9pxC3QqBxS3O7wSqYy9zTaNY0aXv2FEOeGRH9lOyA3KZF1xR70xK3YyHo4zBniZi6nGlwbUlRQRJFAmaxVtsXqebOiPTQB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:00AM +0800, Muchun Song wrote:
> VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
> describe fully independent choices. A split-only walk can defer the
> PMD-split flush to a later global flush, and a remap-only walk can
> defer the final remap flush. However, when a PMD split is followed
> by PTE remapping, the split flush must happen before the PTEs are
> changed, because stale large-page translations must not overlap with
> new small-page translations that map different physical pages.
> 
> Replace the two flags with a single VMEMMAP_DEFER_TLB_FLUSH flag. The
> new name reflects that only safely batchable flushes are deferred. Keep
> split-only walks able to defer the flush, but force the split flush
> whenever a remap_pte callback is present. Callers that batch HVO work
> can still defer the final remap flush and issue their own global flush.
> 
> Current callers keep the same flushing behavior.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

