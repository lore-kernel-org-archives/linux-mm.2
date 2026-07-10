Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3AFBC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D172F6B008C; Fri, 10 Jul 2026 08:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF5B6B0092; Fri, 10 Jul 2026 08:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05386B0093; Fri, 10 Jul 2026 08:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94CA26B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:41:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25822140422
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:41:59 +0000 (UTC)
X-FDA: 84972829158.25.78D198E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6EAD1A0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:41:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fCVFfO9m;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783687317;
	b=PDk1fEA30yBkWC7edv3D9bEIeEY4wrGSYzlwve4bsUuA5KcgdDYEd7J9m/ZA2PDN+mSxzK
	kkNac5hbXfxBvCh6KAF4lIUNCWV/xr2goEGlJeuOGWwdDMv4y3Yn09aNSPcQLS9BgFrha+
	SWq7PaPVxEg8tZcI3bFQGUU1lkCx96I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fCVFfO9m;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783687317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ul3sRLhwjrxQoJQnvumZ0PUhmDQ8XYv0aOjCqcjQNpM=;
	b=oFfy2GVFG8SyILOcUx5cORc5CcavmgMCyt6pgIntt6NKeY7tCFhWI1ajnfqcaH47Eegomu
	NDgvsC54OnFkgGx5dt3dO2kTVYcFnqAgAKU0UFMq+k+kYn2kPwVeN2J+XCfu1z2WweRbMT
	uxlbhMbjqvb1wMmRJI9ZWWIy4D4v5gc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA63F60052;
	Fri, 10 Jul 2026 12:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530D21F000E9;
	Fri, 10 Jul 2026 12:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783687316;
	bh=Ul3sRLhwjrxQoJQnvumZ0PUhmDQ8XYv0aOjCqcjQNpM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fCVFfO9m4IzAP/wLQyhgQloMt80bQ5IwGpNIuTW9LwD9oZ/XvQAcTOdJGAM/c7dJE
	 r9Yk5/nzIgBnh1LNVNhCLeoKT26eV18U8A9jSCt0j0pLm/rdT1CNRPYczRHWWE1cQO
	 XLBswv9UmPxB0abMYjaKn2EyKBUvcG9DL04WZ9jEOqnQG1c+D5vdeBK4X9KBOnhOdE
	 XUfM0AMy1Lh4Xh+hTvqWoh0ICLqxxg9a/jf5K+uizSCB/32YFTH45pnS7L+qZVduIc
	 Y2P7dZTpm7THC3xWck3OwjF7SLg3wluXoKTppqOOvGN2RfOT8qJEa5vxM2ieFTU1fj
	 Y8mvSwMOrzgQQ==
Message-ID: <a160217b-c0aa-4ef8-bbf6-e75a8ff25cea@kernel.org>
Date: Fri, 10 Jul 2026 14:41:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm/huge_memory: skip device-private PMDs in
 madvise_free_huge_pmd
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
 ryan.roberts@arm.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org
Cc: stable@vger.kernel.org
References: <20260710105557.1987433-1-usama.arif@linux.dev>
 <20260710105557.1987433-4-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710105557.1987433-4-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6EAD1A0004
X-Stat-Signature: qx3d3jwowo67j3esnsij1b3mcosmf357
X-HE-Tag: 1783687317-385392
X-HE-Meta: U2FsdGVkX188dUfeaM+mbryAQVx46PSw4rDwzJx1XOjxD0BErDCfwKJDZ2WksLjxtsqMZYf1w+flfdcN2skqCQHnJV4UwPzH11bWNX1enrl46KgvpCJx8oTL4AdYIyrmz4EWUkKqz9ajdrPOg45ANhwJrGu8g27h/k8Mdsd64Q6dJmn7mIIiO5+CDXVnQYY7nLWKuT37TzwnMsHlmn3OZdftuKLCIegnE1NpI0QcYvlSYzALUuttm/DEHnNYdKT9qiLvVJPX7fszWgwzkzf1FE6RrP+L4cMa7WYM0WTe8+YnXGDUdog4vYBcuvZkmQ/3QWK/I8s66chV9H9cFHymiFkwJE3g3TLzPg0jUuu481t54hi+YaFsseOjNNvIpRnn5/gMBVbb3PHmpCn9EArPjIW0ZusWmm3wBbeWHWzTtNLn5QFVW7+jCM1sfs3TpSD1oFDTw/wpOw8uYAX0N0Y0BtquLIvrkpZnl2NFSby1cxgdSX0HvHgjEHi80drkrUqSuP8AQMJg9cHkZ5fvSEYLbC2Z/lMB3sqpjPmHrnnpvQwXhadsakRmyCYc/R8zeWW1qMZAo0qCFtjtKIbADbPlfXm2M+KDFtBC1AoB+uZFwROI9N1g5p93BhhQVbHT2i9OMr+c55PEKOnHFlMVd1xib1PMeCC4xQ185qxZo6ii4Y6vh6Je086uuwFQ4yClpcoTgx9iDRb7ixYoc8OdqlBnDlSEjqGyz2xu0SN0D1YU5J775s796wyOlmWs0Us8EO8xhAePfbeU8lecRUxa0Z68SNC1QnzFc0t1cjoGW5zrQiCrOy+Xf2N4IDRe/Ut3ATziBodJG/oLaRZUp3RwC5y4Rr7IcIIa3NXDImaig5RCJNURuXHYID6DBcQ/R9QV99IAy3u1FRMUVZvnemk0PxVe1ce3i1siF0EkDMW2D9M5cPdujrk5FULLFFqm4wjPJo9bQ44z/sWapynPA7iFfEt
 kJ286F01
 +3y/mj26xKOB99xhnqMRUJkTf5jULpDYs850LrF4cpNEAq+KXsVwRQOoQ8Qj6BZO16OtrrPlMn/j6NLV0Hlbam3Fbhwe3oXb8RE5ycikbuUcIehe7hpm9NW4DZ/O+ZGY74Tx5wV9G+bYgizq8yQGJF63P3HgmEFJkZF8C5GvqesmHitGtOtWs14LTn92613+QWHosws2BuTv9wSeN5RbD+NymMJDXCb9I98uZx4b9hmr7rnLna6Da+DbX4OZS4/X+qH173TwiQlwv0g0erKjLJkFHsZHLZuDEWQ5YoGtcNNWxsuXwVKD4fabnZy4TRbbidJAK9ycos2+t1UCJnxf2ScMOYp6al7rCX6eQeiAvoOJkIFw7F+jr3Npdnma6JOeWxE0PM4OiwJZKy0cSals4CLM7CXAby7YFWckmrXiC2gRkswmJRfgE+HHmZmFHxnzN//FYuOxNtnsV5dQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 12:55, Usama Arif wrote:
> madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
> madvise_free_huge_pmd() takes pmd_trans_huge_lock(). pmd_is_huge()
> returns true for a device-private PMD, so orig_pmd can be device-private
> and enter the !pmd_present() branch.
> 
> Skip device-private PMDs in that non-present branch and continue to out
> before calling pmd_folio(). Downgrade the check to VM_WARN_ON_ONCE() so
> an unexpected PMD softleaf logs a warning rather than panicking. Drop
> the thp_migration_supported() guard: it expands to
> IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
> pmd_is_migration_entry() and pmd_is_device_private_entry() already
> return false when that config is not selected, so the guard suppresses
> only the case where the warning would already be silent.
> 
> Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
> migrate_vma_pages() flips the PMD to a device-private entry between the
> caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().
> 
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

