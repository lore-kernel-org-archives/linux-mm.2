Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3B4606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HqAEKjQc
Received: by kanga.kvack.org (Postfix)
	id 296716B05B7; Wed, 18 Nov 2026 10:33:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220666B05BA; Wed, 18 Nov 2026 10:33:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8426B05C7; Wed, 18 Nov 2026 10:33:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD1016B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:33:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76C441C3BAE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:33:54 +0000 (UTC)
X-FDA: 85448635188.27.8C4AFDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC05540005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:33:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqAEKjQc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4NAL/Ml+6iNHCtzdazoN6cjIew8lYcoEk44FgyAVTw=;
	b=ujP7GAI04g1Qm0BneI3RL0d8WDSBL0MgXkidmW6+LlLGUUPB+KRax1kexlg9wbV3+xYiX6
	QY5+YQ72fQM8osDyr8Mv+P0PySlnR9Ucnczsv8WSBBg+aAUVOb3wvmt2lSmvso31GJvHhg
	3/tM9XdLrNJGSsdgW8AzZ7brBGNHU6s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqAEKjQc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016032;
	b=S2xlNQr232cO2Z73i7CP7wSwaLIgJEZWmrgWwwURzmJMShsGFlgLvLCSSAHqIZHk9ZYn0b
	crfsHv3PMrQlDWvxOPgs4qGlXCTJ9aEBPGvaA5r3VU1yVZtZ5YCjtvR4GnyY8lr91S2AkO
	OVJtSA7IXeGHfzhrfbm76suDonGKSoM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D665A43B82;
	Wed, 18 Nov 2026 15:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E17D1F000C9;
	Wed, 18 Nov 2026 15:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016031;
	bh=d4NAL/Ml+6iNHCtzdazoN6cjIew8lYcoEk44FgyAVTw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HqAEKjQcCiF0I1EdTnOdnKnaOiuGTp44AgaFH0YVU/olYlRRwSPUwYkR6yr921pKc
	 J58Or1xiYCiXdBvuS3nuO227Xcvf4CjJa/+YccmTU/tG4BO4ZMOusrXJSmBWR5l0yH
	 4O+qLiyPy1xgkLebRM4xBsBpfEp/4UabXtmKQfb/08XHbH7EMaxIg8YVOGbgD1N533
	 WOf+SvvxxOwUnOFclW94aaoZlbX5g21C3zA1nbiZT4/Fm8LjtKcrVvCxoHML5p5lKA
	 dzIHoVBCu0Nl+dgeNG7MV/Y4CZgoNjD2ABNCRFB8lrLGhq5Cyt3f5KDi6Ml1sTDq5v
	 kfU2uZvdkjbvA==
Message-ID: <84d548ad-9623-4db9-9637-634f45bdffb3@kernel.org>
Date: Wed, 18 Nov 2026 16:33:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] mm/migrate_device: fix use-after-free of the
 anon rmap
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-9-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-9-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AC05540005
X-Stat-Signature: 9mnikkxm8qfmpfxuuiop49k4s5u99xkp
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795016032-464215
X-HE-Meta: U2FsdGVkX1+1GOC+JrN478NBKlf9xce1qD0z9CyRthnQK2WV2EhcEI3gkLrCwFD3JRdkBya2TcSDCRJwONywMHfkhwihSgt/sxH31J2gP7HPVUMT9ekT7YqfqwKThI4PqC70QqNMzFTIag6rX3850rRIWe621lBedf+HFHqE3RJY5DrX2acuOG5qoGwUZWN1owRN2lfN11mdK3nkrbypbXU4D5PGipLxpVCK5ZjhBEyTEw1hpGJEy8AOrdnazwTv9LSYVosjaaFT+H/V8ucAUlwL4afkEqvxt2MDT1W1ytOkGctjefZNMRtA4Q07BVykLST7bo6hPGjukvZAH+xwyk7h3jYcNsEVCJdDVs7+3olbX0kd6RuvIhG9izcgyxCZCnVhNHN3gvjmEhAV9OEzrSJ4gR6oQ3XjBBMCy2Hrc8HQND/mjYB4Y9cYL7UxtSkNVgag6v+vJH/IKgd5oixIqz/Vc8OwHmGrhNg1Gq5Eey0ajw0AVf0DkU59fkylq+yDbiBZj+u8KGrJ0Uatq7TS5Ecd1+VU+RTq343Rr9Vx/6WazKfn1hahTmmiJJ91/vTPS1xEvr74ShMcerhtQhl2Man1p7z/dSt9zhO/glyqrqa3JmfQ3rOcdxnX1KDt7HEz1oQ0jYtFKO8fu+w683zG2q1ZokFfuq8Wswqpi9ZnlXVf7Y4bzRMW2Ij01pd0JvE3mZ4AN09yNev0xLpeWQFM6d+/IynXZqfUmzKtpuPsybklhNSbgT5ZuU3pumymfVpdVljInjOlJRADj3UuVr0vknumB2m9vx4A9hr8lHMtoBO6vYYu5tp7P5DknJZkvNNBy6u9kdydsIuT4EA+35mHIssUFIoVyrfUx6cogvxAKjLF4Ja/g8+UytaE80BanP5AdD6ApqYU6YtwWymp7XRMy1Orovellr8ULCIagozaK7DWR1A4lpwSizFOtE/pJXuehcQWVUlRbPOdbUqtHK7
 OCrWRVoc
 WnyML7mVRXoDSXWwri6yNPg0n8U2j8Tr5ayA7V4f+saEsyoLekWMv7hyK4I/IdR6fUc0Yt1vCURuqHE6R5d0Z3rR7caVqjHsHMsHOxWVuK2Nw1MLQZgLtp8hgUIkJR5wkn0jM8WfF2tJzfwHeV7byqhFC29uUMVusi9iryBU3l696WG//kt2b5jV7gCE2sA//EWtplOGCaKstCTLGdGtnPhjbn+HQ+8W5BZ87hoOe3Yv1gxvZck6QfBmbUc5DTA4FEuBOA/mTrZyuZrO/X58YzmeA2yL0fKPRGLmM/iKnAZTRbAMvufc7WWJWmJkuDdNgGc13czWeJBqmzkmLoYpND12Pcl0JxNKUapxg9gVPaspnhszSyUrOGDDkpt0y/VEdxzVBf78Nd+K5maj/TEUN7caRjx1RmAikVtfZt1P5KDJ8v5uOqj2+ccRmCnbP08ZcA55XW2jUeRrBL3ddOXwwP3LzKokPCDSOekNWAXivh/vdZiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> A munmap() of anonymous memory can result in a use-after-free of the
> anonymous rmap if a concurrent device memory migration occurs and the
> migration runs without the mmap_lock held.
> 
> This can occur for a long-term pin of device-coherent memory, or a driver
> evicting its device memory by PFN.
> 
> Consider:
> 
>     eviction                        munmap()
>     ========                        ========
>     migrate_device_range()
>       migrate_device_unmap()
>         try_to_migrate()
>                                     zap the migration entry
>                                     unlink_anon_vmas()
>                                       last VMA: free the anon_vma
>     migrate_device_finalize()
>       remove_migration_ptes()
>         /* locks and walks the freed anon_vma */
> 
> If munmap() runs before try_to_migrate() instead, the folio is no longer
> mapped and gets no migration entry. The walk still runs, and follows the
> stale folio->mapping to the freed anon_vma.
> 
> Resolve this by pinning the anon rmap of each folio which possesses one in
> migrate_device_range(), migrate_device_pfns() and
> migrate_device_coherent_folio() before its PTEs are replaced, and
> unpinning it once the walk is done.
> 
> A folio which is no longer mapped cannot be pinned and has no migration
> entries to remove, so skip it rather than migrating it.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Great, I have to wash my eyes now. :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

