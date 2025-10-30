Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6FBCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 19:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382738E01D9; Thu, 30 Oct 2025 15:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359DE8E0084; Thu, 30 Oct 2025 15:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270238E01D9; Thu, 30 Oct 2025 15:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 110728E0084
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:07:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CABC81A025D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:07:27 +0000 (UTC)
X-FDA: 84055714134.23.48BFBDD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7C270120004
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 19:07:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HnD6wWTB;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761851245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Y7S1Zgr4iVGtRsh64LfgvKoH0XA8jwp4qVFPtKmeeA=;
	b=xLWEfhIpK05KWy0E8151HY6QqXjIeugkOo5xg//cvLVqx64uhNObkAUntMLfKKRuYC2yXF
	JdgAn2U51qCRLUAVorFujzHj+dlT3IGcIoqJCvQU1YDPUaISpo8eN7atQnemci6BGbfFip
	TLjFv9MlaN2QUEeMrhGqUAeRr6BiQVE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HnD6wWTB;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761851245; a=rsa-sha256;
	cv=none;
	b=4Y7W5/qCEqSx+CLnzH9oBpTzCVKEN6rpnpvrs2ciA5mlmS3qVEQZztnkj9pPvTrzN7k/Zs
	UtHzy4twrGExGaXg49vBOJhQryMovVkOiecPkGbawF6fdM53tR8/8qH0lRGmvf/dnDw67n
	MWoDG+601WnuNMr6yVKtzSWspDSzHzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761851244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9Y7S1Zgr4iVGtRsh64LfgvKoH0XA8jwp4qVFPtKmeeA=;
	b=HnD6wWTBuKVuB+CvbcKv97XxfK8wwM12EaFBwBM2BzqomM+GlPBRuMzpU1FMCMyOslx6jc
	n34dyYu5M6CAebJi1z/4cDiPRXyFnIY8HrxHnJbXD3j7BPBG8GvSlqh7Dvf64ZdN5HAzS/
	rWmHbouFwE8dDaSlvNC7tCQGYj/6zQA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-pHSRsqieMp6E3RE7EI6DFg-1; Thu, 30 Oct 2025 15:07:23 -0400
X-MC-Unique: pHSRsqieMp6E3RE7EI6DFg-1
X-Mimecast-MFC-AGG-ID: pHSRsqieMp6E3RE7EI6DFg_1761851243
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-880047f8636so40991996d6.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:07:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761851243; x=1762456043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Y7S1Zgr4iVGtRsh64LfgvKoH0XA8jwp4qVFPtKmeeA=;
        b=QQ+xdpmAhQAl+YzUSZViKQuxwPEw4Az7ulT8PVujJZ9Q08MFjQ4EY562rT73u00mdh
         HK8eJ3O930P8kbtat2Wp20Ol1/mlXjqC7Dhc+uL0LUIlWeE18LxcW5ika9uLo6YPo2Dl
         jQMb6T7BaRnncw2BgWw9rBXgTwVjFvZO6G+HG0SiGElhETvv8/WGnQo+1HfzankOdoZV
         LJ+oV8PHC3GhoDCdmQ2559HMR67DGd+n+/Igf/7EZPg0peTKbfwPFpl3GxPBB9EYOWl7
         UbViaNuizBo0vu9YYKLeUzmSSveTWzU/3iwUG/KZNZYTTX23pXocHjhqPVdah4ByxgeU
         QS8A==
X-Forwarded-Encrypted: i=1; AJvYcCXYWjVDecaNIy4con2XH77M4NjT4MhzH0LFx6ES0Ibli/eMbx3eBofeb7Q/SF/LzzTZ7xPW0+Jw/A==@kvack.org
X-Gm-Message-State: AOJu0Ywh7yqWkKJWbPTfV7x6v06XTLHVnxfhCmp1W4JCjo55ZvfIq5SQ
	yg2V2zetUPMKm1PLpjGgR7iYNvnx6lu/elZAZ4Rg3yjJMYQckVkLDw47XzjW/zaXq8uuEJAo+77
	JQ3ObdV4IC3jietBzUDv28mAWPIsxNaA8214LH16H2eA8csSIzAXq
X-Gm-Gg: ASbGncuh2LQL6Pn70lJKCyA97T6EhDqrt2XNWTQxHj5UR3lUahsCqVTijnciP7uon6/
	ICSbhsVwtUdnUUu0peCls+DOOgQesN9ZM/XJP5yZODizebjCbUev64AKPTtnu24QpYn0ew6L1a6
	Uaev16BIETkBLIaZavm1hmXgpfyQba8PF1RcBZLz+V9WElVNOGSz7E2GRzaJnDAEeq4lQC7qVy3
	hObEy/N5GFzVKwdnDK69Gw6WsPEFzw8FxvCrBXdct682P8k2hizgfTYktiLbFKIHELAPIyK+P1h
	oQpicBIzxE4E3OfrmE4Z67Vc8wNQ/VPreImCZj2GW9ZceYXs6RxKNtQgIY6qJfAM/GA=
X-Received: by 2002:a05:620a:4410:b0:884:bea2:f01f with SMTP id af79cd13be357-8ab9afd1550mr60941085a.58.1761851242581;
        Thu, 30 Oct 2025 12:07:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHagFIkBv4J+3JA0af8KFwdWyaUAnlJH88LcP/SWIKEfGEGCPpq1Uvsvq9Iaf4DVL5Sxox3rA==
X-Received: by 2002:a05:620a:4410:b0:884:bea2:f01f with SMTP id af79cd13be357-8ab9afd1550mr60932985a.58.1761851241805;
        Thu, 30 Oct 2025 12:07:21 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba3863cc2sm113652571cf.32.2025.10.30.12.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 12:07:21 -0700 (PDT)
Date: Thu, 30 Oct 2025 15:07:18 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aQO3Zko6Qrk7O96u@x1.local>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
MIME-Version: 1.0
In-Reply-To: <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2ty7h8RP1om0eGdGTsGNzs-SwzdBZPT5NPzyf0YkBIk_1761851243
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 7C270120004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: acjhajpukbnze3uroghwoh7k3jmsax9s
X-HE-Tag: 1761851245-95659
X-HE-Meta: U2FsdGVkX19uX2rnpYdX8yFN7XX55Mh3I8XLqrMJZfjj6Z6MPwnW3HysF2bvtZKK3SjONsJ8fshVG6wIsBMv1lvji33ZvZRcxkjNeebzmSfShF4vC+9FpWwBUG9PU+mLKSqQJ0s/7Oon9QkeBpKrksQq7ItDAJLUXkiCLeUbuDi/BeMlQaOU1y36irue0LhiV6UlZaRcTBv8BK2RwewAcJG/loKCKFpm9/q5mKmwlNj1Mk10oCj9VbA/hK3wymmZuBZ1WTPGmR1aKjWpRjuhdBBm3I9eJEilBQvyeqe9Q95kCK5msWtYVSPFZYRnCmPCa1ufodOEj4+Hs5mUiNzr+tbl+gXKuzsVeTZbtuVSp19Q3vb3i84VZFRrmudj9iTbliAAK8HrOmlQn5CAXwjVAe6tXWW/JyEELrCDYO6gbVd6g8HBw9Cp09UIw0FlHisduUzs9Pdk+2HMZ+CpfnMI+8aJa8v8ukU5aBggYwNeTMaAbtZ29s8q7L6MwddehZTxKAKpPILHWayEu5gL80tf55eypGIt2ci9u8Oi9o3yQrJSwU+qWxE3+ItrQNItW7ohPGgoYBxtrwVy7RzBB9okAgk+as0TKCA2jFXyv0E8oRjdKwJ8RLH+2TAz+98Xa3EPPzXg83vLKhCXAOGsDGGnrOm+2R8PqXKHNALYeH08iDpW3RyVpmZue04v2+pvVvvzQh3SO4q//ePfaTMo1vmBGEN7vtePWb4CvRIfW/zu52FrHmc6RBZEPwKMf3I8ZBNESjmUrJKRD0ccWQ4l5v5+r9R5/ayE8MXL8Hx1Ew63Ht1DBlBdQUKhrMYJtixfaDW8ExRtemU1DCWfxDvbSunUzy2hBd4R/5A/QODp/e5l5fwe6hQljIF2kLWuwougYCTa/8TNReSpiwfwGhpQE+mZaP3BmSzp6Ol8D5PKoCCPRxRlaEIUh8v7Gx8qpl3QwEH+WtVMd4KERBBgNFGIFTv
 pRYzNl3z
 eXQ4NLmkEbuoke3cbSsIgpkaOUoN+nT9TdBmulYnqN9G+9N/3HMKuDulUsk4Cp0XhGkfTb0oNjG+ktOt24fyRvZUqXyO5SuSGP+pEdfiy717c3RIHldF3TqtW8rVK4NYBQ0gP8/jrzJgAbZsLCOUae4DhSgWp70fePy5X9xgFAiU0PbKXiz7+TmFHjt6AwiAGvJtPrXCcnDnThrLY4WF9+o/iK+cCF2+GXYaNSldVJW2+w/x8ZhxeQRueeb+CV48fg7jdOLxRHyVmvYYgxyt8hhArGThlVDf/E7ULZRIO/JnG7N/78LcXhrJJeI9QHm3dByh46L4PWLDKHmkRKS9gV776eybp09lSmWowSvgqORGpTrm4u7XgHxy/NpejLzHU8Ci5XCPAS5wqDUc7q2WgBCoE58wrCiwec30z9PDDpS82Ud9RiRiJEEbbKtJK9biqExzmniM7VTQO62b9mbMWxbxu/tLO7YGuzPRX+X4qtvK2VI0LECOZ21ByUlaYlBLHcgO11JNB/60Tfz6vYDxl8naXei4M9VIhmt5mEe0uB1MjwOLxJwiQXyio4Geqtv1hrJppdhqTBSpQ/9Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 01:13:24PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251021 12:28]:
> 
> ...
> 
> > Can you send some patches and show us the code, help everyone to support
> > guest-memfd minor fault, please?
> 
> Patches are here:
> 
> https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem

Great!  Finally we have something solid to discuss on top.

Yes, I'm extremely happy to see whatever code there is, I'm happy to review
it.  I'm happy to see it rolling.  If it is better, we can adopt it.

> 
> This is actually modularized memory types.  That means there is no
> hugetlb.h or shmem.h included in mm/userfaultfd.c code.
> 
> uffd_flag_t has been removed.  This was turning into a middleware and
> it is not necessary.  Neither is supported_ioctls.
> 
> hugetlb now uses the same functions as every other memory type,
> including anon memory.
> 
> Any memory type can change functionality without adding instructions or
> flags or anything to some other code.
> 
> This code passes uffd-unit-test and uffd-wp-mremap (skipped the swap
> tests).
> 
> guest-memfd can implement whatever it needs to (or use others
> implementations), like shmem_uffd_ops here:

I didn't look at the patches in details, however I already commented
previously on a similar comment you left.  Since you have solid code this
time, let me ask one by one clearly this time inline:

> 
> static const struct vm_uffd_ops shmem_uffd_ops = {
>         .copy                   =       shmem_mfill_atomic_pte_copy,

This is optional, if you did the convertion it's perfect (though it's buggy
right now, more below).  Yes, UFFDIO_COPY might be a good fit for a global
API like this, however that's the least useful, as I mentioned, I do not
expect a new user..

It means, what you did on this may not grow any user.  The whole change may
not be useful to anyone..

Then I see what you introduced as the API:

struct vm_uffd_ops {
	int (*copy)(struct uffd_info *info);
	int (*zeropage)(struct uffd_info *info);
	int (*cont)(struct uffd_info *info);
	int (*poison)(struct uffd_info *info);
	int (*writeprotect)(struct uffd_info *info);
	/* Required features below */
	ssize_t (*is_dst_valid)(struct vm_area_struct *dst_vma,
				unsigned long dst_start, unsigned long len);
	unsigned long (*increment)(struct vm_area_struct *vma);
	ssize_t (*failed_do_unlock)(struct uffd_info *info);
	unsigned int (*page_shift)(struct vm_area_struct *src_vma);
	void (*complete_register)(struct vm_area_struct *vma);
};

The copy() interface (and most of the rest) takes something called
uffd_info*.  Then it looks like this:

struct uffd_info {
	unsigned long dst_addr;			/* Target address */
	unsigned long src_addr;			/* Source address */
	unsigned long len;			/* Total length to copy */
	unsigned long src_last;			/* starting src_addr + len */
	unsigned long dst_last;			/* starting dst_addr + len */
	struct folio *foliop;			/* folio pointer for retry */
	struct userfaultfd_ctx *ctx;		/* The userfaultfd context */

	struct vm_area_struct *dst_vma;		/* Target vma */
	unsigned long increment;		/* Size of each operation */
	bool wp;				/* Operation is requesting write protection */
	const struct vm_uffd_ops *uffd_ops;	/* The vma uffd_ops pointer */
	int (*op)(struct uffd_info *info);	/* The operation to perform on the dst */
	long copied;
};

You went almost mad when I introduced uffd_copy() in v1.  It might be
because there used to have pmd* and something around pgtables.  However
I'll still need to question whether this is a better and easier to adopt
interface if a mem type wants to opt-in any uffd features.

So are you happy yourself now with above complicated struct that memtype
needs to implement and support?

>         .zeropage               =       shmem_mfill_atomic_pte_zeropage,

Why a memory type needs to provide a separate hook to inject a zeropage?
It should almost always be the same of UFFDIO_COPY except copying.

>         .cont                   =       shmem_mfill_atomic_pte_continue,

It's OK to have it.  However said that, what we really need is "fetching a
cache folio".  I'll need to check how you exposed the userfaultfd helpers
so that it will support mem types to opt-in this.  To me, this is really an
overkill.

Shmem impl:

static int shmem_mfill_atomic_pte_continue(struct uffd_info *info)
{
	struct vm_area_struct *dst_vma = info->dst_vma;
	struct inode *inode = file_inode(dst_vma->vm_file);
	pgoff_t pgoff = linear_page_index(dst_vma, info->dst_addr);
	pmd_t *dst_pmd;
	struct folio *folio;
	struct page *page;
	int ret;

	ret = uffd_get_dst_pmd(dst_vma, info->dst_addr, &dst_pmd);
	if (ret)
		return ret;

	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
	/* Our caller expects us to return -EFAULT if we failed to find folio */
	if (ret == -ENOENT)
		ret = -EFAULT;
	if (ret)
		goto out;
	if (!folio) {
		ret = -EFAULT;
		goto out;
	}

	page = folio_file_page(folio, pgoff);
	if (PageHWPoison(page)) {
		ret = -EIO;
		goto out_release;
	}

	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, info->dst_addr,
				       page, false, info->wp);
	if (ret)
		goto out_release;

	folio_unlock(folio);
	ret = 0;
out:
	return ret;
out_release:
	folio_unlock(folio);
	folio_put(folio);
	goto out;
}

So are you sure this is better than the oneliner?

In your new API, the driver also needs to operate on pmd*.  Is it a concern
to you?  Maybe you don't think it's a concern now, even if you used to
think uffd_copy() has concerns exposing pmd* pointers?

The current series I proposed is not only simpler, but only expose folio*.
That's at least safer at least from your theory, is that right?

>         .poison                 =       mfill_atomic_pte_poison,

Why this is needed if UFFDIO_POISON should exactly do the same thing for
each memory type?

>         .writeprotect           =       uffd_writeprotect,

Same question.  Wr-protect over a pagecache folio should really behave the
same.  Why do you need to introduce it?

After all, even in your branch you reused change_protection(), where the
hugetlb special operations reside.  I don't see much point on why it's
needed.

>         .is_dst_valid           =       shmem_is_dst_valid,

It's definitely not obvious what this is for.

Looks like it's trying to verify vma validity.  However then I see shmem
impl has this:

static ssize_t shmem_is_dst_valid(struct vm_area_struct *dst_vma,
		unsigned long dst_start, unsigned long len)
{
	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
	    return -EINVAL;

	return 0;
}

Why shmem allows anon vma?

>         .increment              =       mfill_size,

This is almost only useful for hugetlbfs, same to page_shift and
complete_register.

It's ok if you want to clean hugetlbfs.  But if we want to fetch the
granule of the folios inside a vma, IMHO we should make it a vma attribute,
not something special to userfaultfd.

>         .failed_do_unlock       =       uffd_failed_do_unlock,

You'd better at least change the name of it.  It so far unlocks some
misterious locks then try to copy the folio without mmap/vma lock.

inline ssize_t
uffd_failed_do_unlock(struct uffd_info *info)
{
	ssize_t err;
	void *kaddr;

	up_read(&info->ctx->map_changing_lock);
	uffd_mfill_unlock(info->dst_vma);
	VM_WARN_ON_ONCE(!info->foliop);

	kaddr = kmap_local_folio(info->foliop, 0);
	err = copy_from_user(kaddr, (const void __user *) info->src_addr,
			     PAGE_SIZE);
	kunmap_local(kaddr);
	if (unlikely(err))
		return -EFAULT;

	flush_dcache_folio(info->foliop);
	return 0;
}

How do the mem type know what locks to unlock if they do not lock it first
themselves?

>         .page_shift             =       uffd_page_shift,
>         .complete_register      =       uffd_complete_register,

Hugetlbfs specific hooks.  It's OK if you prefer rewritting code for
hugetlbfs.  I don't have objections.

> };   
> 
> Where guest-memfd needs to write the one function:
> guest_memfd_pte_continue(), from what I understand.

You did mention what is required in your new API:

	/* Required features below */
	ssize_t (*is_dst_valid)(struct vm_area_struct *dst_vma,
				unsigned long dst_start, unsigned long len);
	unsigned long (*increment)(struct vm_area_struct *vma);
	ssize_t (*failed_do_unlock)(struct uffd_info *info);
	unsigned int (*page_shift)(struct vm_area_struct *src_vma);
	void (*complete_register)(struct vm_area_struct *vma);

So guest-memfd needs to implement these 6 APIs to support minor fault.

> 
> Obviously some of the shmem_ functions would need to be added to a
> header, or such.
> 
> And most of that can come from shmem_mfill_atomic_pte_continue(), from
> what I understand.  This is about 40 lines of code, but may require
> exposing some shmem functions to keep the code that compact.
> 
> So we don't need to expose getting a folio to a module, or decode any
> special flags or whatever.  We just call the function that needs to be

I didn't reply before, but I don't think supported_ioctls is special flags
or magic values.  They're simply flags showing what the mem type supports
on the ioctls.  One can set it wrong, but I don't think what you proposed
with above 6 APIs would be easier to get right.  Any module can also make
things wrong in any of above.

UFFDIO_CONTINUE itself is definitely getting much more complicated, it used
to only set a flag in supported_ioctls, provide a oneliner to fetch a
cache.  Now it needs all above 6 APIs, one of them taking uffd_info* which
further contains 10+ fields to process.

> called on the vma that is found.
> 
> If anyone has tests I can use for guest-memfd and instructions on
> guest-memfd setup, I'll just write it instead of expanding the
> userfaultfd middleware.

Personally, this whole thing is an overkill to me:

$ git diff --stat 63f84ba525ea04ef376eac851efce2f82dd05f21..HEAD
 fs/userfaultfd.c              |  14 +--
 include/linux/hugetlb.h       |  21 ----
 include/linux/mm.h            |  11 ++
 include/linux/shmem_fs.h      |  14 ---
 include/linux/userfaultfd_k.h | 108 ++++++++++------
 mm/hugetlb.c                  | 359 +++++++++++++++++++++++++++++++++++++++++++++--------
 mm/shmem.c                    | 245 ++++++++++++++++++++++++------------
 mm/userfaultfd.c              | 869 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------------------------
 8 files changed, 962 insertions(+), 679 deletions(-)

I can wait for some second opinions, but if you are confident this will be
welcomed by others, I suggest you prepare a minimum changeset preparing
support for guest-memfd minor fault, then post it formally upstream.

Thanks,

-- 
Peter Xu


