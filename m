Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0839510F2840
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71BED6B0095; Fri, 27 Mar 2026 11:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CCA46B0096; Fri, 27 Mar 2026 11:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609E86B0098; Fri, 27 Mar 2026 11:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 505F66B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:29:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E18235EA77
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:29:24 +0000 (UTC)
X-FDA: 84592227048.06.4664C2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DFB85A001A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:29:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=phmTDdlX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774625363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EhXspjBHxfeZFqrRhiCAb4i9nbkdFUD51DGckXR/OiM=;
	b=6e9E+KW1ZRigUPnp10Xq1/MJpXk8RVkpTqkTL5itCxYBigudDL06CCmJeh/xe2Yx+yrITU
	zs3VVQ1WQso9cPxp41p9t5s0B4dWqLJDBjq80KFfqq8QHbA/PmBu0eRKI2HUeQUDFvaOnJ
	+Rcr0tKz/QV5AkirSTZtosIx4k+pCqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774625363; a=rsa-sha256;
	cv=none;
	b=dqsUtz1v3iqD6hL68ETqXNxf63/A1qhopoW38baexhMZeaFkTLIupYdXGd5S6k4a6ky6Po
	RS4zvj/Z40Kph9MsgrTzkamRRz+cVHyZnZxsdO/vo0DKMZhHR0zP0W4nchjN1OMePl4UGy
	NzntVntyM2GNNzDVXRp4EQqlvBlqrd0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=phmTDdlX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D1CC40B82;
	Fri, 27 Mar 2026 15:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645C9C19423;
	Fri, 27 Mar 2026 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774625361;
	bh=K17mO2X2gcCCie6mfJBhNmej8KECCk67Y0OzVkKTvEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=phmTDdlXpdADxRipFRSQchkiH/vZUQAIB/E0MmNMCEKJWne/A1mfRLLILkxcuqbio
	 BqayNnAmTA3drvH1TWDrJWiaC1pzSWItgwlrNrULkmEX1jqgZFcJS4KhGgp3UFeilN
	 WeJjfJHMFHHRQRy2mHnFNnraa0NYP2XkOCfUCAZj5qs2akqb9oPqRG5hKR/2LYAmk+
	 MJabkvCwOgaxmzpYOdxlPxRqY3/piSgVTblTdZwn2wKwqz1kDmrrPzPpH+jnhMPY/6
	 ugpY6sBhZUjYH2ZUAlJZT6t5uL5fOA4YjesryvxV87ewLUfvCyXQW5J67qMj3jlBP4
	 wW1uc4nLlvF/A==
Date: Fri, 27 Mar 2026 15:29:13 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
 <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
X-Rspamd-Queue-Id: DFB85A001A
X-Stat-Signature: 4nku5gts3p7c5abw4acr5knoawzqn1ee
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774625362-928195
X-HE-Meta: U2FsdGVkX18po6qnGzvklmLSwdWJKGOX0VpbwnhP60s15wPHGfbHl4kAsdxs1ZVKwgk/l0Y3AhwL4dQMJv5djiKaQH5JsH5Vuc70S/gJ466V+EjW8j3QLJTvlpDaFgJxKMqLw09cwgg5xoCyCU2VCPBZxVtRzAbzrUkwAUlKJ8Fe0vhwua0taflJDDfgYVz3da6Cm3QKKY2eD/JQsHIiBjWaCuzJwFn1jmvVgcoVEDqdpuYIPzmcIlL6brI1qtI3opDtcfZ1gQAoLd1UozXbwkcUy0vwLyBaxn7uDNVuVU3h+pY5srBrAf9WcTw3oAI+lIqEvjeWMnq5IVEdtrFOcZ5IZi2zJfk4OLLnJ623ZKo4X8xkuMr3n5lbd6F99/nUe3uFZcSy4hgy7KRVQSNYBt4HNYkns8AYT8+CjL85kmDVx0PR2xHv0APNDfyiW8ii63xRCILc/xapGEDha4v+RFDdWwXRNgd7Dh22aGlP0crZI7WpdmarNq5hhm9EBTGIfroJOtzCIFPyh4sjwlgSEAv1pVp2zYgkOm5ErZMs69MGxiltB8NE51gbYTaJVTyMoZFv6Rvc7DsNOggZa9XmpGVvmeXkFvF9GWy/kMS7UCwx3/UGRUI73hlI/xNL7pAdNPFwXW7XAiCu8j1CPsfALmSXd16pXw9bwrj8NxA2QEMJbS2qD0caGMRKVEqKgfvpE+Vj3zfAcmHeOBAYGNWNyJ4GC/wmnnev8P2BkKWq5sNnUU7bX6OhWhB/gHpis8uGfqMVYZ3YgFf0TPwDyLKAid+ztthNVpz2vmeNiUZwLCa/p9TXk0qjXcXeDn8ZTBHoUyjClGXqnvHAOSidPjZQEVvpBc9DLO2zSue5lRoAYEVg7SzxxVYpfAVtIaVS6GTs/cpY7CyBUhSKc71ZVzAxWxb//6Ov0Lz7EkwOPgtDBr2WvlczqBpRqqCPu1qPFK2qQ1IERfSG+L5TkR8GgSa
 TJ2uXAeQ
 1ANiQaVQJ0VlRxqISGaqvOfOkYaYw/tV02PAvh8H7bI8VQoniUkKorQPllDgu4ZBDKbqoZFCshn7B4jQnkw9HTM10saI0Jw8G+s/3EgaJ5H/XX9zsDG8J+YYysGZA25TPciIo6SUcf3qQDYlqrWAvIRB366lZzFUxAWhygHQgSbey4glg2PrSjriVFG0nZih1BBQdXfDkGjg1Ob0qruErKrw4UJhSpEaa4ljg5cMgDNriL7E2VEYoR25QB1gnFrMgndRO09vfeVe9tAqpOho91ZivZ+Lz7j/FmvF3YNlSno1rjvBv3/oXvacntA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 11:12:46AM -0400, Zi Yan wrote:
> On 27 Mar 2026, at 8:42, Lorenzo Stoakes (Oracle) wrote:
>
> > On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
> >> Replace it with a check on the max folio order of the file's address space
> >> mapping, making sure PMD_ORDER is supported.
> >>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> ---
> >>  mm/huge_memory.c | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index c7873dbdc470..1da1467328a3 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>  {
> >>  	struct inode *inode;
> >>
> >> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> >> -		return false;
> >> -
> >>  	if (!vma->vm_file)
> >>  		return false;
> >>
> >> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>  	if (IS_ANON_FILE(inode))
> >>  		return false;
> >>
> >> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> >> +		return false;
> >> +
> >
> > At this point I think this should be a separate function quite honestly and
> > share it with 2/10's use, and then you can put the comment in here re: anon
> > shmem etc.
> >
> > Though that won't apply here of course as shmem_allowable_huge_orders() would
> > have been invoked :)
> >
> > But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
> > unfortunate.
> >
> > Buuut having said that is this right actually?
> >
> > Because we have:
> >
> > 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> > 			return orders;
> >
> > Above it, and now you're enabling huge folio file systems to do non-page fault
> > THP and that's err... isn't that quite a big change?
>
> That is what READ_ONLY_THP_FOR_FS does, creating THPs after page faults, right?
> This patchset changes the condition from all FSes to FSes with large folio
> support.

No, READ_ONLY_THP_FOR_FS operates differently.

It explicitly _only_ is allowed for MADV_COLLAPSE and only if the file is
mounted read-only.

So due to:

		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
			return orders;

		if (((!in_pf || smaps)) && file_thp_enabled(vma))
			return orders;

                      |    PF     | MADV_COLLAPSE | khugepaged |
		      |-----------|---------------|------------|
large folio fs        |     ✓     |       x       |      x     |
READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |

After this change:

                      |    PF     | MADV_COLLAPSE | khugepaged |
		      |-----------|---------------|------------|
large folio fs        |     ✓     |       ✓       |      ?     |

(I hope we're not enabling khugepaged for large folio fs - which shouldn't
be necessary anyway as we try to give them folios on page fault and they
use thp-friendly get_unused_area etc. :)

We shouldn't be doing this.

It should remain:

                      |    PF     | MADV_COLLAPSE | khugepaged |
		      |-----------|---------------|------------|
large folio fs        |     ✓     |       x       |      x     |

If we're going to remove it, we should first _just remove it_, not
simultaneously increase the scope of what all the MADV_COLLAPSE code is
doing without any confidence in any of it working properly.

And it makes the whole series misleading - you're actually _enabling_ a
feature not (only) _removing_ one.

So let's focus as David suggested on one thing at a time, incrementally.

And let's please try and sort some of this confusing mess out in the code
if at all possible...

>
> Will add a helper, mapping_support_pmd_folio(), for
> mapping_max_folio_order(inode->i_mapping) < PMD_ORDER.
>
> >
> > So yeah probably no to this patch as is :) we should just drop
> > file_thp_enabled()?
>
>
>
> >
> >>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> >>  }
> >>
> >> --
> >> 2.43.0
> >>
>
>
> Best Regards,
> Yan, Zi

Cheers, Lorenzo

