Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993D7606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M2u0A3+O
Received: by kanga.kvack.org (Postfix)
	id C14EB6B05C1; Wed, 18 Nov 2026 09:36:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECFC6B05C2; Wed, 18 Nov 2026 09:36:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02166B05C3; Wed, 18 Nov 2026 09:36:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB476B05C1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:36:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F73940775
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:24 +0000 (UTC)
X-FDA: 85448490288.09.C7AC67A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78EB2180006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2u0A3+O;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012582;
	b=LjOej0FSBaG223VHnj/52Z+D9maMCb3Dq95OdNcfLkm408yNt6vcSwLg8mt6szeiCPZF8m
	XUl5hkggtWOHCPtxLvd9ySE2rmxkRX4dqnsmcWws+VypwhtS+CgYU0pj2a9tV4dyNNJtvC
	02jULdfVfqfcEiLpq1d3xTg0se1HbjA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2u0A3+O;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8UvEUdPEpQSyC1Lt+i4VJDuesDW8Qmi23ISsGkjBeA=;
	b=P/V3NkzpPakT3BftGvaB27/dUMtNjC3C/7DDIfZdLqd86XIfw1VphpgBbE36HlqfEhhIBV
	JuSLrFgEcviyWjm2+SU7GIuOc+Gq9DaNdaW2Zyn4B1n5ne+RGI5hseQgCIOdoSfwvcQb+9
	/bA03yCdg/owvbachJxn8omMqfSQrgk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBABC6226D;
	Wed, 18 Nov 2026 14:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3670F1F000C5;
	Wed, 18 Nov 2026 14:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012581;
	bh=e8UvEUdPEpQSyC1Lt+i4VJDuesDW8Qmi23ISsGkjBeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M2u0A3+OGPPITpKUDe303YKDFeGSqQXhJqzLBj8QzweAoMR5Kmk3SBVnEOIe0zRcO
	 1GHtv2j+Mh/vnVGz+wAwz+40erRTwTCExEBZkIlYvgr2E/kynfoA893QsSTYqKsscR
	 5XxSrXE2FTxAw17jFnoDxMbyp4WxNkNApjeEbr5Ym8K2j030bfVnLInTeWF50CZy9Z
	 3tPn98VL7D0hmdW3hhL1xcHPtnftzdt0OuiaUmFYMUOnZz0gixhhvxqsZmIG2asGq/
	 4JBbbgRnKNZ/WkqC9DW6hs2FDCu1yxwaLDnNZX7hQBX/KEblYsp6nKg1njZX29ZbV+
	 xIFwRV50G17ew==
Date: Wed, 18 Nov 2026 16:36:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Breno Leitao <leitao@debian.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/9] fs/proc/task_mmu: downgrade writable migration
 entries in PAGEMAP_SCAN write-protect
Message-ID: <av231_prsp4eDeBF@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-3-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-state-fixes-v3-3-b617009d1a4a@columbia.edu>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 78EB2180006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: idtxok6iipgkpgp7uc3zqwnuf3ogdk4f
X-Rspam-User: 
X-HE-Tag: 1795012582-620239
X-HE-Meta: U2FsdGVkX1+lZsu8K/qHB6Un8NhMxO9PTdUVbiI4At5yn+HsIBhHYoBPuwEt4Cv8T0tkisgJeccF8QYM1O1TSYf2EkP/WP9oAVcJwW31x1Rfn5pmXpByMPbijBPaJ6UVYFVIXdO1ZSPPAkk/NHd6Ics9dEZOC70SraYfW15ICrvi3h0M9FmAGrdx+5qOyMwgRNzlX2TYFnsdXgUf+QQNc3nlyFk8KHRZuKnmlSgZqIpEmgt6qYnFpX4I4rAGX9OA3VnwOwKE5kOfYFe0PrI0eO/z+146tvyZrPQqb4mmh1uhLqN1hbrLS/yEcQj/M7HlTVrm2CWoY8qPsGhM7NxgwOQslWKfUlTJzkGK+rp3DR5/KjCYuL1rBro9ckhb5T295Tmolfqoybhnvf8fa1t1eykM2eM3RJhOtxQMv2EangArJIBDR/JGVhQb8uIcYxFS0lZ9bDSXN8whu+J2KxSjmVZvJx8tQ96SD7/od+8Hx1iHJqwGpDZUvzCCh8h82EH5T0NL23TNIlPksfqpI+LnJPVeGAksD1QFSuDv9rkYrWI136HZ0wOfwdperyb0zoOmsn/yqJ1KHSqRkM14q3UuJcUuCO7x99XvpeAC/X9JgHmZRluePTY7BmUbX6vjgi44Y3nXaibWlwM1Qi0Gl8drSKhcBLtjgRf4aC0xut0cQuXUCHBXHG1Xn5sr85XD7BCN1v3Y4hxh1g4fOiEDO1VTWZK524GCyW5JkegyokqhXjB/S15jJK0qutNOT7uD93ky7nHh1FE2/2nU6F5jmtMFG0l+vCMa1/CUpMG/dTOWVsPxJo2t/Pp3zG9ZPBUSzMeChFElazaIn06GziZaSTB0KtAe437RJE3tqByYmoFBuGGoYvhyFnnQaGXH5cWCS9nCKaiFFWlpaPz2461J2g9BWRPvEmBh4oyCiN6VXUYcCkFdBeyXo6YdGRk+TSVHV8hUWRHrFeDkFQVOGErlOWE
 gHBK9z2l
 MPYoxRW/zFCpazcp3oNnNBHAiRvknvfaLUM8bLP7DgfJ4VrgZNuGV0nvYuvwKKOOtHALIsn577uZlY6Vk4rncubQGSrFG9YLbE77QDhd5xhsa2zVTUiVtmNn6hI5x+yuPa/DCx5Gfwh4nXXMmZ+zkqFkqkvAjl08mB6+90Yrnd8pd7e726flTxz5+JGginBdBhXucK8VNJHxZpEZkoWccnra+l2pHUilH0pmSSXmZNdTI7d84Rzji+0WcIlG/fzalSrQ8ZDlAiXNz0GLj0UfvcQOKX0CP3FNUFJXeO7svs6lj5Vd8H01HhSl+o6zd07isJOUrdWTw4hUtosUcEyQWEGKB9gIuB9EIH5oNkTyaCDxyU073aHZbLh7MA9848q9yFnOEBT43thIqqdpC19mAuZtQiXEaLVcK3+WXIgDT+wayDqlXbQ/lI/g7MFZL9hXiiN9HFNUyIW+XMVwzt49paqscub7Gt90kyR9kjLONcYitXmsk7n+WlAgeSvF2rU/dEtCW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:43PM -0500, Tal Zussman wrote:
> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects pages in a VMA
> registered for async uffd-wp, and sets the uffd bit on non-present
> entries as they are. An entry with the uffd bit set must not be
> writable, so that the page is write-protected once it is mapped again.
> change_protection() therefore downgrades writable migration and
> device-private entries to readable ones first, but PAGEMAP_SCAN does
> not.
> 
> For a writable migration entry at the PTE level,
> remove_migration_pte() restores a writable PTE without the uffd bit. So
> if a page is under migration while PAGEMAP_SCAN write-protects it, the
> write protection is lost. A user tracking writes with async uffd-wp
> sees the page reported as written on the next scan although nothing
> wrote to it.
> 
> With CONFIG_PAGE_TABLE_CHECK, setting the uffd bit on a writable
> non-present PTE or PMD also triggers a warning.
> 
> To fix it, downgrade writable migration and device-private entries
> before setting the uffd bit, as change_protection() does, at the PTE,
> PMD, and hugetlb levels.
> 
> Add softleaf_is_writable() and softleaf_mkreadable() to leafops.h for
> the downgrade. The open-coded copies in change_protection() can be
> converted to them separately.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Reported-by: Breno Leitao <leitao@debian.org>
> Closes: https://lore.kernel.org/all/avNEgmvYdoukt6MS@gmail.com/
> Cc: stable@vger.kernel.org
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  fs/proc/task_mmu.c      | 40 +++++++++++++++++++++++++++++++++++---
>  include/linux/leafops.h | 51 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+), 3 deletions(-)

-- 
Sincerely yours,
Mike.

