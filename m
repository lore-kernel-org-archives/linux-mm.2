Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2CC6C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01046B0108; Thu, 16 Jul 2026 10:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDEE6B010A; Thu, 16 Jul 2026 10:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C075C6B010B; Thu, 16 Jul 2026 10:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82B2A6B0108
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:59:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45302A017F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:40:56 +0000 (UTC)
X-FDA: 84994750512.02.7F51BA9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7D14120005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:40:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C1ksQY2w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbCYVb6YiEiOlXJDDZ3OmuPdrZmKseoP1YhaSGPcZ4s=;
	b=thjyE6PYg+SscFpFxygOqucNxTGpjv+EvZY6NOBI6mj3vtx7eACCR9Zsr3m93NzTPNzm7o
	8iWbCa8GxWR7qWvHZ9gvM1DBygZm47hpPjeRqauCJ93g+NlxorUUBYWX+t2vrEf2D2hA4W
	civN3c0mMRdtutF3gS8PAqkcbOH6mw8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C1ksQY2w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209254;
	b=HDMIpMQjH5SXpAvSHiQFwA+AVbg9OKsvleiG04YK+Fsf/B3dQF7sdm0e3pFlbm2cORNmxC
	HXFOTfPnsHNsgfHZ3+v22t6biphSAYaxLc6tdEoUmLOgytJSVkxg6JlfWjjMDL3nzvSBjq
	mdMipqVIUKFx5RlGX9u09VKlez5isC0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784209253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JbCYVb6YiEiOlXJDDZ3OmuPdrZmKseoP1YhaSGPcZ4s=;
	b=C1ksQY2wjJboGVw2Xl7RDqw8etHIR9kOpWV/uCl9y1m+sPOD2qW3ePuZKt2lzO+uYJ04bj
	UB+En3RId3CI6uiy9CPnbNWr1roU0bzgZbZEIrbGh4tmTfydAF1GLdXS48ZkSU9GWUDDyt
	ESK+ILio9EGkhP2S2O7dddsqqMHRdWg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-yOku4U3EPPywnGkR1CWvdw-1; Thu, 16 Jul 2026 09:40:51 -0400
X-MC-Unique: yOku4U3EPPywnGkR1CWvdw-1
X-Mimecast-MFC-AGG-ID: yOku4U3EPPywnGkR1CWvdw_1784209249
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39abd6b0c78so3861291fa.1
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 06:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784209249; x=1784814049;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JbCYVb6YiEiOlXJDDZ3OmuPdrZmKseoP1YhaSGPcZ4s=;
        b=BqRIRr5iQeFH+6pYF1HmnfTQ9wn1eIlTxLHxOVLkcfpZtZPuCM2DQeBRQAx1Bz2n+6
         3Ih8igpHjCeho6Icn7p4QHmWg4+qUHOvM3oAbvtmO1l4qpYRA35FbM2nS/94uODc6adY
         JAyrpSGLslib8nRRdDR/ywFZ4OSuhg/Hh8RKK0bl8pBrIijYEkf32WsTE4+kiWvT1beK
         v9PqUxl0v30v2mcxmzAG9FvmJ03RLS9ESB+wNOIptmqULJjsHgW1sunE1wmVxRUc+vTR
         i5J4zixmKTKy5KRdF4KY0xLo7bYgKwWsjI3ZITIIwmUnFxdJtyZ0mQ+RQX/supfHD+oZ
         SYHA==
X-Forwarded-Encrypted: i=1; AHgh+RpXc3aCCCiK0a5PEwIghLwvIwdq0yMaVloeVMrP6L+0Auze7gc6BTtpoabgqcZsmSGVgeKJj06nsg==@kvack.org
X-Gm-Message-State: AOJu0YwHQC9OtohQ1mk5oU05YsqwmLA7bpr3/BnbUrEtvZju4O7uaoYB
	ZuVmpAYstekLVwm5kX/W2NcpbHf3nYXx6DkOJGcAG8qu+obsUzbHNpoSEF86yztPG3wnbr7GUDN
	mjOm1hvxDHCCNg+4Q3ojPjOMNkIDWmLV1sopjYQUUwxPwH/++xjM=
X-Gm-Gg: AfdE7cmhdRFfGOYEDNpt+7han2yDSTWe/PY8bLuNOZGcqufhR5wat2TY9qA1XGZNkzq
	yB0HbNJ/As1E5Qk/JyUYcfugK9dPCJjTkS/13Rj4ezorqLA4f9veOdzvAsEmeLnmnAErHbRli47
	GWsIoLvrKzUMn2VJ1nNZ2YzCTvqVBmt9UBORVpHy+QrdtWcFfl9AntEWb0M1Nikx1cJS7IkRqtV
	gpwBXmc7aO6r1rqOwVKRTf/zDF47EVxPB38N8KFfFy9e9jVnvnVd1NJoizuoPg7xlM0Gjo/JCOh
	7dc3/pVRGwR3an6zA5dRVRnwkF9WTkPaSrK3dkeiZND75LO8Clf3dKEvBKMxO12O/KYLJW3dgcN
	Aa7VwPH7eIgQOMWoTggMVJoAwPQ==
X-Received: by 2002:a05:651c:b22:b0:39c:9bae:d990 with SMTP id 38308e7fff4ca-39ea015810emr5210021fa.10.1784209249289;
        Thu, 16 Jul 2026 06:40:49 -0700 (PDT)
X-Received: by 2002:a05:651c:b22:b0:39c:9bae:d990 with SMTP id 38308e7fff4ca-39ea015810emr5209811fa.10.1784209248770;
        Thu, 16 Jul 2026 06:40:48 -0700 (PDT)
Received: from [192.168.1.86] (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39c8489aebasm46328461fa.0.2026.07.16.06.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 06:40:47 -0700 (PDT)
Message-ID: <72e2bdfd-c883-47a8-b121-42a1fe160d9d@redhat.com>
Date: Thu, 16 Jul 2026 16:40:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 0/5] Migrate on fault for device pages
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260525084524.139868-1-mpenttil@redhat.com>
 <1612d4cf-b725-4ecf-8618-51a33537f59d@kernel.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <1612d4cf-b725-4ecf-8618-51a33537f59d@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: scw75VadXTsN-ulVyLIy_4jZjwUUkx4_h_ETd05sGEw_1784209249
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B7D14120005
X-Stat-Signature: 63quzojxhkoa6y4dwrom6chijm84rq9y
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784209253-108699
X-HE-Meta: U2FsdGVkX18t2u6nc1DoBsfXHahzVU5koU3TDGNsmOA84Fu9ISo0mTT3KEStCEhBnDXnyX5qtRooWVf6kx7HY683hgwzIW9MPK48vLdGeeMIJid881595uK3TcQfZE3UE+KFoi0VVdDF+IIpE0pnptzxbJEMccifW9ld2bgZ//ur4pnTRsJzcGQ5Daj87MmISK8HBVvfmt1ulSyrE/FZi57nM0XZDHWjsJF9i3kapXr5qWujFa5lO+4aAWoW7+6IBXIqd3nkMlrPzjm8MTR92FMnGitDHNHsG9h8ObQuGUsFhKtcvpaqrO2sLagT7q76PICAdna8Kwqw0XTqLPimGX2i5WpxMZyqOSOHgkXymyO39/md8IPj3FCLqRU75Gh0TrO6HVbL6ANYcVHhIJkJv/V5nTas5grqSBsuPLAN/UsSNc2XsqnFOk2P389E8c6MK2vltwNnMN0nZ3CnKu7MXMj2u84LCxxf6Qc2aR61q1D8WuOR742lcSxeDhZm02SoGPGh9Ee1tP0qc0jGHAlhM7/Y8iCsduMvnR6urOOJ+1JPFqoeGXCNb0f0xAvKVIrsxLYnpp4sZVUZyXzBfqWzRuXyrXYDzghPn73fM589XTSMO8EFkwM2FMBbFQljyoWYlVYjx2NgevkYX2s3h5iUrcFStiE3r5/jUqaM69XiHOr77swVFwn2d6UaB+5TjAlRMrJV9CUOL+Jx8QmI/+ZgVjP2Hu/Ifb8VhlKP6qTIQSsWXXUF6Zn6V+Lg+g5Ohojbj/tbvzDMGneMZokVfBHXdPcWabe+Hh3fr7Zehge/Ith0dRm96OoEPJjZw+fRLKQKjd8lUOf11WBV8keeYVv8LEL85Bq1T1+yDw5UHEzdb0HVhm2giJNgxVudbNhrWOouz/gi/NBSiu3k5j7fIFr+I7CShtMB6iC9ZdFUZPJw8rLcba4/lDP3di17wvPnt6jviGj1e1AUUyjXd/15t5y
 erdg8FJO
 UstZUeTavlLEh3FffsK/9PyIWoPA7KVEGJO1uYVC3tqGu4gxwd8Ix/asgP/mT14QsNGHr6nPpGpOOnGMA0Z7rCAYuxOWhaFgD2RcyY0gwX4rDDOuaHSiQqNJOpT72COZf1Nbk12vrD0wTs07rJmH9uIhUIH6zJUGXPqEE3QGN6pSO6OYKHcgQ/VnNp9Myp012MRm8CKac7qhT7DRhN0EuSH6ZzTZkMwyeANbn/JkLTprKq+ovuHTf1kWqsx8qxFl4fqXDCOA1R9GL3ukXgDfTgJKkCv85H/bbqj/CRWzFl4j+E943UeOnMqAHS8wBdH8yjlxt4+GZkoCIGiqHtih20IMN+Wxfc7q/6LFEHfL/8gyt6U+8B/VV20iHAJP8umetrIfpRqcKJmcmwSNF0pjv7yktCPYCEtX0AbVSkow4dNA4FehSG0z1PktTk1hDSJTYhxTGOZgrH8UsxNksNMhMt9l4yGDqMv3f8pPCRHkgb3I3ssSrQGFWoZ2jYrMWz2ukwfhCkSvMogpltIaT4oWPhwtjKhrYv2/wF+VPzTbA5biUGUGmOcSxrCOj/pSMzS9HPK8YIh0sTzIWtPR63/y20Gohe4sh/+W7RdWc8vjRtIdU2JWX9V9zYom0iyJnuFcTVuy2ktV98wgGISTJq2VnKqcGoVHCMmqsUKOBhdCCti1Aatxnt+XTfO1vZP/s4Tak2EIh4JXmqqt7pyLiTBc6Y6bQ3I2kG1P8RXVPFXzokhHErNbQaDkVi0aQ9ShPxw2T346tGjTSiQSazuvVsBduZ7MHdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 16:15, David Hildenbrand (Arm) wrote:

> On 5/25/26 10:45, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
>
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
>
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
>
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
>
> Or:
>
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
>
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
>
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly. One page table walk
> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
>
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
>
> One extra benefit of migrating with hmm_range_fault() path
> is the migrate_vma.vma gets populated, so no need to
> retrieve that separataly.
>
> Tested in X86-64 VM with HMM test device, passing the selftests.
> For performance, the migrate throughput tests from the selftests
> show similar numbers (within error margin) as unmodified kernel.
> Tested also rebased on the
> "Remove device private pages from physical address space" series:
> https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
> plus a small patch to adjust with no problems.
>
> Changes v11-v12
>   - Fix for issue found by Intel CI in patch 3
>
> Changes v10-v11
>   - Fix nested mmap_read_lock in test suite
>   - Addressed review comments from David
>
> Changes v9-v10
>   - Fix for issue Intel CI found, forgotten pte_unmap() before
>     migration_entry_wait()
>
> Changes v8-v9
>   - rebase on drm-tip
>   - fixed uaf around  migrate_vma_split_folio() usage
>   - added missing pmd unlock
>
> Changes v7-v8
>   - rebase on 7.0
>   - fixed subject in two patches
>   - enhanced commit messages
>   - squashed patch 6 into patch 4 to fix kernel test robot warning
>   - readded dropped Cc block from cover letter
>   - fixed white space
>
> Changes v6-v7
>   - rebase on 7.0.0-rc6
>   - added documentation and comments
>   - denote to be migrated zero page as HMM_PFN_MIGRATE alone
>   - got rid of HMM_PFN_INOUT_FLAGS movement in patch 2
>   - picked up Acked-By from David for patch 1
>   
> Changes v5-v6
>   - rebase on 7.0.0-rc4
>   - use range based TLB flushing while unmapping ptes
>   - gate migration behind HMM_PFN_REQ_MIGRATE for fault and
>     migrate paths
>   - always infer migration flags from migrate->flags only
>
> Changes v4-v5
>   - rebase on 6.19
>   - fixed David's email address
>   - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
>   - refactored into smaller commits
>   - added more comments to code
>
> Changes v3-v4:
>   - rebase on 6.19-rc8
>   - fixed issues found by kernel test robot with random configs
>   - fixed typos
>
> Changes v2-v3:
>   - rebase on 6.19-rc7
>   - fixed issues found by kernel test robot
>   - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
>   - fixes to lock handling (pmd/pte) on errors
>   - added assertions for pmd/pte lock states
>   - other issues discovered by Matthew, thanks!
>
> Changes v1-v2:
>   - rebase on 6.19-rc6
>   - fixed issues found by kernel test robot
>   - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
>     parts if migrating
>   - other issues discovered by Matthew, thanks!
>
> Changes RFC-v1:
>   - rebase on 6.19-rc5
>   - adjust for the device THP
>   - changes from feedback
>
> Revisions:
>   - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
>   - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
>   - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
>   - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
>   - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/
>   - v5: https://lore.kernel.org/linux-mm/20260211081301.2940672-1-mpenttil@redhat.com/
>   - v6: https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/
>   - v7: https://lore.kernel.org/linux-mm/20260330115611.347988-1-mpenttil@redhat.com/
>   - v8: https://lore.kernel.org/linux-mm/20260414041226.1539439-1-mpenttil@redhat.com/
>   - v9: https://lore.kernel.org/linux-mm/20260505051658.2219537-1-mpenttil@redhat.com/
>   - v10: https://lore.kernel.org/linux-mm/20260505184421.2324798-1-mpenttil@redhat.com/
>   - v11: https://lore.kernel.org/linux-mm/20260525050830.100254-1-mpenttil@redhat.com/
>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
>
> Mika Penttilä (5):
>   mm/Kconfig: changes for migrate on fault for device pages
>   mm: Add helper to convert HMM pfn to migrate pfn
>   mm/hmm: do the plumbing for HMM to participate in migration
>   mm: setup device page migration in HMM pagewalk
>   lib/test_hmm: add a new testcase for the migrate on fault
>
>  include/linux/hmm.h                    |  19 +-
>  include/linux/migrate.h                |  26 +-
>  lib/test_hmm.c                         | 118 +++-
>  lib/test_hmm_uapi.h                    |  19 +-
>  mm/Kconfig                             |   2 +
>  mm/hmm.c                               | 843 +++++++++++++++++++++++--
>  mm/migrate_device.c                    | 583 +++--------------
>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>  8 files changed, 1086 insertions(+), 578 deletions(-)
> What's the status of this?
>
> Patch #3+#5 are extremely hard to review, I wonder if there could be a better
> way to split this up better so we get smaller changes that can be more easily
> reviewed.
>
I will send V13 with few fixes/improvements in couple weeks when back from PTO.
I will also address the recent "pmd becomes huge or cleared" affecting mainline migrate_vma_collect()
Not sure about the split though, patch 4 is mostly move over from migrate_device.c and patch 5 testcase.
But I try to see if there's some sensible way.

Thanks,
Mika


