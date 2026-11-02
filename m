Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D7AA606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ee/5fqIw
Received: by kanga.kvack.org (Postfix)
	id 91DDC6B00EF; Mon,  2 Nov 2026 06:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4046B05B1; Mon,  2 Nov 2026 06:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BD8B6B05B2; Mon,  2 Nov 2026 06:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 542EF6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:03:04 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E49191A0CBA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:03:03 +0000 (UTC)
X-FDA: 85389891846.16.C7DBBDD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44E4140009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:03:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ee/5fqIw";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793617382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLsuIaO/vO0yxwqR0T4S/sMl30AM8Izc7otFPn1bjhA=;
	b=Liy3LsTPEG3178pkcnGPfL0P3ZKBGzdPgsA/LYeYdPjwojdHxAAErIStOsd0WxKgCx5Y+E
	F6uEhF4pg2eTzRhgnRsTZlnLkDSoqa7jzGQ/r8H/KCJr0Fe5D8gGZqlq1rOCX0IJV4XtC6
	esRp6ETY/n38u6xueYJPPPWO1KbmK/0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793617382;
	b=CO8ZYW2yoO1fawM8UahzgrouLqZrSb3sSFmsrsFNklA+eqclikC3nwLhBJLrbQ7IQfmPGF
	SDw24fbHz+YyPBH8NikdWPNM02zu9Givj8sTKMb2Rf2lNkreivq2cG5WMuM8sgKUhLGpFW
	D6zzy745RGBlLIzFk0AxZd4JilN97/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ee/5fqIw";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7847641928;
	Mon,  2 Nov 2026 11:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDB51F00A16;
	Mon,  2 Nov 2026 11:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793617381;
	bh=sLsuIaO/vO0yxwqR0T4S/sMl30AM8Izc7otFPn1bjhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ee/5fqIwaWuubHUFiZNmrig8kCTutPcyQDaTWVD/MrUbaZ1J3yb85Jm/UfWNjXSMx
	 SUsE8wsymotgyZij57TwGJWvsvFRmeR9JIfeLuuXKcILia2GHbPzd3momuwB1BvydG
	 hEY55Hdnao6q465NMJIOrmJafDujh15HreWRgoX/RyJvaF0+aJbnMqmybcI3JvsuTZ
	 JBUsmKIlZ3IXyGKP8Q4p4F2/hZA4NHFRz1sM2RXQnAxggAUSsPnuXdh7uqFrvKd3b8
	 JV+0SvKa1Rn1NSpF0SY3dgrACZn87+zVgv24lRYu2Ure1xDAKLslAKSK++USdNAuhV
	 pHwERphOPbCxQ==
Date: Mon, 2 Nov 2026 11:02:56 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com, 
	Songsen Yang <yangsongsen@insta360.com>
Subject: Re: [PATCH] mm/vma: read anon_vma carefully in validate_mm()
Message-ID: <auhrcEfT5v5MVcFj@gremlin>
References: <20261102-fix-validate_mm-v1-1-5c309614ef15@kernel.org>
 <auhn01dpDzK47igy@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auhn01dpDzK47igy@thinkstation>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44E4140009
X-Stat-Signature: ywjhxsup8ru3p5yxrsizpcsuruodeisk
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793617382-968193
X-HE-Meta: U2FsdGVkX1+HeDqyDlu02737UuFot4RDoS56c/2yWVV4eaod7uvOL4xVJT1WNf7T3CyTn0fiXYLTU1sVt5xfHxN/9+TUlK8nEaIUMq0JALL1uyNBXsUDH+b2mJXHSxG4RiKAQMwQph7JlPDMJyfiCfw6Uy9g3dtSXvI3kSSYX3MVu72B8Zmsw9JcfUNq2wHCwOzHfvWpaiM65MjSnJ8tiEyGEXPpgrJiSmPgsfCwoVs/FyWB0NpZhqIR+w85CIqMjbSmgAgSp9eSwIqYeCmIcJNEmQ5503FLhhCCw+FxM6b6btfbY4FO7k1zIvIwOeXnUoqcwGODHJL98xnsqJn9MX2G2HCNdXxwo1HGEGs9A0RX8lq7Z/f1zFX0ktiS+P5beiOHDMhovOyPYcANMGGjgPfvR3wfwPJMYsVhOuV0LaCzQC8Of+b/WrXLXkonZRo/WQSp77yyJfhATaHP+zsocSoBobd60bRzFyaXhMeEtrUc+XsdCV0Adm4O98onnxaUm6bs1pbH5lp60cAaH3mGR6Cx35DKjBPAO1ndrGdmTGD89X/mwNt4YWdmdl7R0boPq7vD+sWdrpqPGuEGT+ivwbRSEbIqW1Exd11dtDm5j9TqUYwjWS2web2udmL6Xf9SnqxwXpB1aaRIB8W0hzSDlpcBJftRLWk+ATCttGcb4nEJPKN7gmeWF13cVEfKULfecrjjsnHrUaMUU81HvZGueMuMOQ+G7f+6lLLbig1YmoGAvIzxWOoQmwlG9BMGphyyGanBPC81ZRepICbJmtFhPbaU+5yuQsiY6gRN0Yx05kB4vS4e8cRnoA2ftiribXffUjkQj+dULl3Zgvj+ofXvTyrwBZUd8fdQe0GJ+6zl4YD0rGDQTzpHbG+MTI+dJVyCgDStAvZqJjy/yasALpTDmtfZ5r6Sqi6ROMvuTTEJJy38RP0NUNtU8iN4mQmRhYiQeZoqHAOdL/uWfxnrk64
 aPUhnhUr
 mgCvGNNuKHX5oEBcAODhnyOdnlWOOTTW82YPDN/TXrg3eRp0CI2wnGELTzG5gqwyExN1ON7rGUjgLDKLQYRfNH2KEonSRAvBsbiM324XhGWWsndDz6GdscBKVsvMG5JYEzW62g47wGJ7JYxFZ23ytdmlhp5fFcRk9bGJQqxnM+DHju71dGz6pFHcN2AEm8CfkEu718vUkawFgEXzaJar4vl743i4uLt3sxnPy7BDzWBgOW+Ibn6YwUSQTgJ31jqJfV5imAF3QWjIYkgd+6Eg11mLtXhNpdIBcLzNak29O4bxCFT/kY7asSbGGN/IqPK8AYIGR+3clptqKAdlETgN8Uxq5cjOMjR80hdQiBCAipw5Dkxw4NUo3e/qqRY7KzZMV2ejzWtDbzAQNvfT7fPM30J9ubKJ1C4LeIkeGDdALGqC/I8bWEcZKSnPZ1oPMl5iYI5cXgiHhuWPxOGFiGBRZSIXYSTK4gEOqdP19tjpel8V5AMStSXucoAQmSatdLMD0r8Z0QsGWUT8pGc/+Mx+VsjMWPklSpYBevYD61mVNZL14SYwYaxn1fvTJZLOrtWqxYfYxEt2XfbCl2YCVbfVmHo5vhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 10:48:45AM +0000, Kiryl Shutsemau wrote:
> On Mon, Nov 02, 2026 at 10:25:20AM +0000, Lorenzo Stoakes (ARM) wrote:
> > Commit 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence
> > KCSAN") rather clumsily converted the read of vma->anon_vma into a
> > vma_has_anon_rmap() without accounting for the separation between
> > assignment of anon_vma and later use of it.
> >
> > vma_has_anon_rmap() is intended as an optimistic check, so doesn't need to
> > protect against a torn read in vma->anon_vma. The caller is expected to
> > take care of this themselves if they then in fact access the field.
> >
> > validate_mm() does indeed then reference the field, so resolve the issue
> > via READ_ONCE(), and simplify the code by separating this into a new
> > function validate_mm_anon_rmap().
> >
> > Finally, add a vma_assert_stabilised() to make it clear the required state
> > of the VMA.
> >
> > Fixes: 38564710f443 ("mm: implement and use vma_has_anon_rmap(), silence KCSAN")
> > Reported-by: syzbot+10e72ea5747737bcd2ad@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6ae78418.6552420f.2a0efc.005c.GAE@google.com/
> > Reported-by: Songsen Yang <yangsongsen@insta360.com>
> > Closes: https://lore.kernel.org/all/20261102074414.10902-1-yangsongsen@insta360.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/vma.c | 36 ++++++++++++++++++++++++------------
> >  1 file changed, 24 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index d416ba58eb4c..9f02f19a7845 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -669,6 +669,28 @@ static int dup_anon_vma(struct vm_area_struct *dst,
> >  }
> >
> >  #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
> > +#ifdef CONFIG_DEBUG_VM_RB
> > +static void validate_mm_anon_rmap(struct vm_area_struct *vma)
> > +{
> > +	struct anon_vma *anon_vma = READ_ONCE(vma->anon_vma);
> > +	struct anon_vma_chain *avc;
> > +
> > +	vma_assert_stabilised(vma);
> > +
> > +	if (!anon_vma)
> > +		return;
> > +
> > +	anon_vma_lock_read(anon_vma);
> > +	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> > +		anon_rmap_tree_verify(avc);
> > +	anon_vma_unlock_read(anon_vma);
> > +}
> > +#else
> > +static void validate_mm_anon_rmap(struct vm_area_struct *vma)
> > +{
> > +}
> > +#endif
> > +
> >  void validate_mm(struct mm_struct *mm)
> >  {
> >  	int bug = 0;
>
> This ifdeffery seems unnecessary. What about this:

Yup, even better.

Andrew - could you update it in-place or do you need a v2?

>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 9f167950926a..2e43077dcd51 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4363,9 +4363,7 @@ anon_rmap_tree_iter_first(struct anon_vma *anon_vma,
>  struct anon_vma_chain *
>  anon_rmap_tree_iter_next(struct anon_vma_chain *avc,
>  			 pgoff_t pgoff_start, pgoff_t pgoff_last);
> -#ifdef CONFIG_DEBUG_VM_RB
>  void anon_rmap_tree_verify(struct anon_vma_chain *avc);
> -#endif
>
>  #define anon_rmap_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last)		 \
>  	for (avc = anon_rmap_tree_iter_first(anon_vma, pgoff_start, pgoff_last); \
> diff --git a/mm/vma.c b/mm/vma.c
> index 1be613044b4a..30f31d3b3e26 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -669,6 +669,26 @@ static int dup_anon_vma(struct vm_area_struct *dst,
>  }
>
>  #ifdef CONFIG_DEBUG_VM_MAPLE_TREE
> +static void validate_mm_anon_rmap(struct vm_area_struct *vma)
> +{
> +	struct anon_vma *anon_vma;
> +	struct anon_vma_chain *avc;
> +
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM_RB))
> +		return;
> +
> +	vma_assert_stabilised(vma);
> +
> +	anon_vma = READ_ONCE(vma->anon_vma);
> +	if (!anon_vma)
> +		return;
> +
> +	anon_vma_lock_read(anon_vma);
> +	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> +		anon_rmap_tree_verify(avc);
> +	anon_vma_unlock_read(anon_vma);
> +}
> +
>  void validate_mm(struct mm_struct *mm)
>  {
>  	int bug = 0;
> @@ -678,10 +698,6 @@ void validate_mm(struct mm_struct *mm)
>
>  	mt_validate(&mm->mm_mt);
>  	for_each_vma(vmi, vma) {
> -#ifdef CONFIG_DEBUG_VM_RB
> -		struct anon_vma *anon_vma = vma->anon_vma;
> -		struct anon_vma_chain *avc;
> -#endif
>  		unsigned long vmi_start, vmi_end;
>  		bool warn = 0;
>
> @@ -702,14 +718,8 @@ void validate_mm(struct mm_struct *mm)
>  			vma_iter_dump_tree(&vmi);
>  		}
>
> -#ifdef CONFIG_DEBUG_VM_RB
> -		if (vma_has_anon_rmap(vma)) {
> -			anon_vma_lock_read(anon_vma);
> -			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> -				anon_rmap_tree_verify(avc);
> -			anon_vma_unlock_read(anon_vma);
> -		}
> -#endif
> +		validate_mm_anon_rmap(vma);
> +
>  		/* Check for a infinite loop */
>  		if (++i > mm->map_count + 10) {
>  			i = -1;
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

