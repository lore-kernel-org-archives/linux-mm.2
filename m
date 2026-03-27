Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5109010F284C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75466B0098; Fri, 27 Mar 2026 12:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFEDC6B009B; Fri, 27 Mar 2026 12:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF896B0099; Fri, 27 Mar 2026 12:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 865506B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:08:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35F2D8CC2E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:08:25 +0000 (UTC)
X-FDA: 84592325370.02.B9FEB98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 635CC1C000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:08:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rMAx7SyZ;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774627703; a=rsa-sha256;
	cv=none;
	b=gCFFwynBbazSu9wZ08tC9ZlQWijcxb9xtNkphqLGs3TJUSKJAfZRzlhRh8VBkgHksGv9BH
	chNU7b1mGVbATaYpyRhBQMydLXnbWB3MZuE+Pswh/Tz0kcxmz1pU6PueJMXIf9ITEgLg6o
	tcLFtegkaFM0coF6lA+QXCmkByUMEm4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774627703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnO9fprKBsx/1X4jOQjM+OCTDLNkzZ/OIBa8N2AjjBg=;
	b=xDYTHERFpYsfNdLHffZS0Xhl9PhkkEw99Jbxmc4JdrQIgMVX5aRw33Hhh7rhIJeeFDsZys
	io593vaFKLHhXLLCrsCWIKqWJqLaI7VCKFZl02P3xt+MT7+sEauASAw2Lf2qL4Z4DU3k0G
	fOamTpRzGExLGxLont7xFRRXukF6JVo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rMAx7SyZ;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54CEB437AE;
	Fri, 27 Mar 2026 16:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEB1C19423;
	Fri, 27 Mar 2026 16:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774627702;
	bh=Y5Pd/gbqGEKvddIcFhZ5V8JfJMsZGodNYjSQLfzxngo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rMAx7SyZ59sVnwpX2nQDt9UXL44MMBRBHqTRZlQHbacBLtN/aM6d+nxwUxopCyzFY
	 404+v5iCL/0mcPGV/j6+GVooGUNTIxakPVHRrh+DLrnHKrbbBZYyjuQ1/7DRus6AmA
	 itfAQ94fgY2+OOZPz7PKtC5OAfZd6ZfWqieMqdXzcUSntzhU0bwlU+3JcI/2tlU1+t
	 et899fz5Zrxd+VBYlUQZlh6dZRyn+vSvhslG8H/eM5T5XSyGc5FdqRWympWhbuwfgP
	 3dfBDxyhIvxnDheY858lbGkW3NdQxKkMS+/kzr+HU/Z+1xPiveQoLPQds6mhzfMSim
	 rn3OME/5q3Xtg==
Date: Fri, 27 Mar 2026 16:08:14 +0000
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
Message-ID: <10b04dc8-e155-4a31-84b6-17b302e65c7c@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
 <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
 <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
 <59A91369-9BCB-4545-AEF8-083B52998CC3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59A91369-9BCB-4545-AEF8-083B52998CC3@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 635CC1C000F
X-Stat-Signature: weh3977wfjm3fgnm4f6uu4qkcgasieof
X-HE-Tag: 1774627703-142479
X-HE-Meta: U2FsdGVkX1+Dlj9GOLrY5/at3WXmJKQJkzUyiQPXWkD+71z5j2NwMwqq4hUxsSc8PDGhNUQH6RxqfeYrAjhQo1UUVTdPYY1FalRvtilM0ckWQKc6eWKN56U2lxaGTuoAg3NB4MDlOLr1r34I6LJzaxCOmNBCaWQdQ3frMKSvj6MoAqgqeUvFP9UUexwqg6JbKp3HRZebvOp82Bx97aUj128wODSs8//+spdXc1pWvR0/2+aQI5ebQvVeMk2nZ5Ryacqgj9eKma44wa16Z52eui6wapRSPR8WuCLuOJd7z2iU5k9ruXhEVsC+KR8yMhfZ7ArLbeALeui/4GNdmZBhOUpUZPjJCyPaYarzgPpJVgkyCU3Z1/tEoYYTZsCbwtzi4aKIPPvgrmA30M2woK4xGepOU/UJm3OAK6UQWhqzOXGrmp0rT3EUJodlS9+2TkVZ8Fj8ny33qMNoEgyuOSbcA/YG+7fYaEKGtQ3btPqMYYDiVCX8TrGc3wsH5FkMQL0C6PFoVUnDWDAF1/qMTdjrhOHaICmhVi2bix55dTyXGT7eeOs+E47MkpsQEjWeD/iJrl6EKddIcuR4+9iL7QPALWIzRRnP1ZsSKreIYUrEa1wQGcIHO/NNLJ4Y+r5/obZJVikf7Ij+zawwqkDXisrui1tH8KzAyN+W7fZAzxWENYBpVNxJGw8ngQyhDC8f/EKhCOHiHA2Y7SFmSwHR6D/4BFkLJPkJO/vsmN50KQjhBDTE7EfTMitNdcTPfgI7wMvoxwJeECufXtkURGBJhWNaOOjSfM20U1fRL01c0aYLuglJ7vwymbnGr4oZ0UiNcjLlNjxGyeKfHoQ36tCcTRb6uGuEwOSMZyUCR6NHnVUH3G2+Qci8xWxWbqRIJ+/uZ3n4UYP2kMB/yuH588ju2mXAU3pwyydYdZYKh2D9RnlPFayEXxTH6cKXklvDm95di+77RlLsnPT8iiBO4/lE0q0
 O0pNlAY9
 Sq05Wq0vykE5p8zIC2aaxcT7JOv0Lzg7mpjVX0mcMosf/QX4Jw3j5coo71dQqXAvn5GXTQY6eyAhfBLLXuXcMzauZD+F4HbTj3aw5Na4siXU+vs5NE2Re+jqWRkhJm9LqsNsIMj5S2pLtbFHKr7CNGbq1zYS7iGrgTi7hxrKyA7c5m6C1udT1llFe9jvLgcDNJRV3Ublm/BflEszqEvFFqxTGo4pyfaCnczrhTuC8yzPWgiyQbu/7qjOT5XMBBA4Qy8ylcmqFVvJRWe5SwWJNttpnIuZEUGMHv2Bf0aX7aeWLbtzfBwz67Nk/l06WkvJCslEyRwk85xYJFdZ60ZFYooB6fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 11:43:57AM -0400, Zi Yan wrote:
> On 27 Mar 2026, at 11:29, Lorenzo Stoakes (Oracle) wrote:
>
> > On Fri, Mar 27, 2026 at 11:12:46AM -0400, Zi Yan wrote:
> >> On 27 Mar 2026, at 8:42, Lorenzo Stoakes (Oracle) wrote:
> >>
> >>> On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
> >>>> Replace it with a check on the max folio order of the file's address space
> >>>> mapping, making sure PMD_ORDER is supported.
> >>>>
> >>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >>>> ---
> >>>>  mm/huge_memory.c | 6 +++---
> >>>>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>>> index c7873dbdc470..1da1467328a3 100644
> >>>> --- a/mm/huge_memory.c
> >>>> +++ b/mm/huge_memory.c
> >>>> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>>>  {
> >>>>  	struct inode *inode;
> >>>>
> >>>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> >>>> -		return false;
> >>>> -
> >>>>  	if (!vma->vm_file)
> >>>>  		return false;
> >>>>
> >>>> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>>>  	if (IS_ANON_FILE(inode))
> >>>>  		return false;
> >>>>
> >>>> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> >>>> +		return false;
> >>>> +
> >>>
> >>> At this point I think this should be a separate function quite honestly and
> >>> share it with 2/10's use, and then you can put the comment in here re: anon
> >>> shmem etc.
> >>>
> >>> Though that won't apply here of course as shmem_allowable_huge_orders() would
> >>> have been invoked :)
> >>>
> >>> But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
> >>> unfortunate.
> >>>
> >>> Buuut having said that is this right actually?
> >>>
> >>> Because we have:
> >>>
> >>> 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> >>> 			return orders;
> >>>
> >>> Above it, and now you're enabling huge folio file systems to do non-page fault
> >>> THP and that's err... isn't that quite a big change?
> >>
> >> That is what READ_ONLY_THP_FOR_FS does, creating THPs after page faults, right?
> >> This patchset changes the condition from all FSes to FSes with large folio
> >> support.
> >
> > No, READ_ONLY_THP_FOR_FS operates differently.
> >
> > It explicitly _only_ is allowed for MADV_COLLAPSE and only if the file is
> > mounted read-only.
> >
> > So due to:
> >
> > 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> > 			return orders;
> >
> > 		if (((!in_pf || smaps)) && file_thp_enabled(vma))
> > 			return orders;
> >
> >                       |    PF     | MADV_COLLAPSE | khugepaged |
> > 		      |-----------|---------------|------------|
> > large folio fs        |     ✓     |       x       |      x     |
> > READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |
> >
> > After this change:
> >
> >                       |    PF     | MADV_COLLAPSE | khugepaged |
> > 		      |-----------|---------------|------------|
> > large folio fs        |     ✓     |       ✓       |      ?     |
> >
> > (I hope we're not enabling khugepaged for large folio fs - which shouldn't
> > be necessary anyway as we try to give them folios on page fault and they
> > use thp-friendly get_unused_area etc. :)
> >
> > We shouldn't be doing this.
> >
> > It should remain:
> >
> >                       |    PF     | MADV_COLLAPSE | khugepaged |
> > 		      |-----------|---------------|------------|
> > large folio fs        |     ✓     |       x       |      x     |
> >
> > If we're going to remove it, we should first _just remove it_, not
> > simultaneously increase the scope of what all the MADV_COLLAPSE code is
> > doing without any confidence in any of it working properly.
> >
> > And it makes the whole series misleading - you're actually _enabling_ a
> > feature not (only) _removing_ one.
>
> That is what my RFC patch does, but David and willy told me to do this. :)
> IIUC, with READ_ONLY_THP_FOR_FS, FSes with large folio support will
> get THP via MADV_COLLAPSE or khugepaged. So removing the code like I
> did in RFC would cause regressions.

OK I think we're dealing with a union of the two states here.

READ_ONLY_THP_FOR_FS is separate from large folio support, as checked by
file_thp_enabled():

static inline bool file_thp_enabled(struct vm_area_struct *vma)
{
	struct inode *inode;

	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
		return false;

	if (!vma->vm_file)
		return false;

	inode = file_inode(vma->vm_file);

	if (IS_ANON_FILE(inode))
		return false;

	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
}

So actually:

                       |    PF     | MADV_COLLAPSE | khugepaged |
		       |-----------|---------------|------------|
 large folio fs        |     ✓     |       x       |      x     |
 READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |
 both!                 |     ✓     |       ✓       |      ✓     |

(Where it's impllied it's a read-only mapping obviously for the later two
cases.)

Now without READ_ONLY_THP_FOR_FS you're going to:

                       |    PF     | MADV_COLLAPSE | khugepaged |
		       |-----------|---------------|------------|
 large folio fs        |     ✓     |       x       |      x     |
 large folio + r/o     |     ✓     |       ✓       |      ✓     |

And intentionally leaving behind the 'not large folio fs, r/o' case because
those file systems need to implement large folio support.

I guess we'll regress those users but we don't care?

I do think all this needs to be spelled out in the commit message though as it's
subtle.

Turns out this PitA config option is going to kick and scream a bit first before
it goes...

>
> I guess I need to rename the series to avoid confusion. How about?
>
> Remove read-only THP support for FSes without large folio support.

Yup that'd be better :)

Cheers, Lorenzo

>
> [1] https://lore.kernel.org/all/7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org/
>
> >
> > So let's focus as David suggested on one thing at a time, incrementally.
> >
> > And let's please try and sort some of this confusing mess out in the code
> > if at all possible...
> >
> >>
> >> Will add a helper, mapping_support_pmd_folio(), for
> >> mapping_max_folio_order(inode->i_mapping) < PMD_ORDER.
> >>
> >>>
> >>> So yeah probably no to this patch as is :) we should just drop
> >>> file_thp_enabled()?
> >>
> >>
> >>
> >>>
> >>>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> >>>>  }
> >>>>
> >>>> --
> >>>> 2.43.0
> >>>>
> >>
> >>
> >> Best Regards,
> >> Yan, Zi
> >
> > Cheers, Lorenzo
>
>
> Best Regards,
> Yan, Zi

