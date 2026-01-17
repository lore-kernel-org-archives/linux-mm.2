Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1800D4A5F5
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 04:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B606B0005; Fri, 16 Jan 2026 23:18:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318F96B0088; Fri, 16 Jan 2026 23:18:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FABF6B0089; Fri, 16 Jan 2026 23:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7D56B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 23:18:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 597A31AE67D
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:18:34 +0000 (UTC)
X-FDA: 84340149348.09.D940628
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 75C71C0006
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:18:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TdZ3fVop;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768623512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=spZbKEGrLatLMnJLutG6rSbx/Go0OaQdrFre976vG4c=;
	b=7GvBFlm9aZbW8OY0dET0A/yr9FOxZ9L8OJl+CRkmIsi+wiXUI04x56+OmooYqlPQMhOMMX
	hQPoi08e8eRmstqJ5+T1+HDF2yVv+EAEP0euie22QLGdIduUih3vaeSNB+o7ieB3YxkpEO
	djCOQJ/anfL9D5fXXnERgVWdsF0RoU8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TdZ3fVop;
	spf=pass (imf10.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768623512; a=rsa-sha256;
	cv=none;
	b=DrVlUWYzQsEOJzSVI+pwqbZx8xWDs5g+1BFWGhmyNTC0SJH4h0BneUo30r+NifzA4QSkDV
	Ua6KWp3ZcFFVVyPF1kgYZaDqBTX4fSRlC3Dme/StVLjn1IiaHXjxihFM0SRF/CKrF1Amdm
	KGZSkfFoE0Y7I3Pf3qRliGHct6GBvGA=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81e821c3d4eso2254648b3a.3
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768623511; x=1769228311; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=spZbKEGrLatLMnJLutG6rSbx/Go0OaQdrFre976vG4c=;
        b=TdZ3fVopliM9i3I/+GlYpfhgx/nOpzncg9tNd0e7ZUr3x1lfCVLiQ2Inc/9s9IGmXz
         UkcqJY1PvIhYe9phOSq+NJdQokuJ6GZBrVjOM9GIFDKAt7U2H5u2cvHQc+S6I60SE5JU
         JYPRdc+Fi0AWRQ820BUKVmTA200HlkR02qF15S2NuV2j/eKBFYbmXhwXo5XXozSpum5r
         JPsLOIU9nvGYTtG1E3oOENBhP+fHGEgJx2ZDRx5Yg6gpgEE52D6l8uyggzc0XlkqzHrf
         psXQCP49cAwcjRHUDqlDyBaSN42ZZxJw/1G1M5BneoXQ5iLGbJCEIxsNCzwNHf+fWd2B
         QKAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768623511; x=1769228311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=spZbKEGrLatLMnJLutG6rSbx/Go0OaQdrFre976vG4c=;
        b=bwndrE3lCxuc3SWP1y4i/KxmMwtFECqv5bjtWgML9j2QIRGMSSqKrOfwWCffzostAM
         wKATKngih0H8j428d5GNMyHJ1TPu7GM8AtuX4Zvr6hsIjNJeWI/fWmJ3T+T3PQJeXBML
         dL90XLlAkiTUdVhRwFpJN1j1n4YeDGG1py5QHX/I5ZIAWxbmn/rxyefbjnlySWDYMpsZ
         FPAYL7IsP4ghciTTH3DFVp5coR8EzHrVbyfi+/pIXgy+v41mFsPwMDWPmo/kI8Y4GHuK
         HZ3XBOEMYl03DgVtbDXdKu4n4HaUn0VjMW1Kq/Q0Vbgn9YSzju+Kvus0JVrHNsUKpVDa
         EIXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV958hrHSPwnrhFKIV572iYcQb0wp0vlzMTjbaMlEa++9mH6cZgo5N6aOpLrgaWzdFoezDUjQdFMg==@kvack.org
X-Gm-Message-State: AOJu0YxPHgfSmcQ1lkC2LKT+T5GggTXvp/Jbo8/eOE5b2q1TnIDY5y12
	Oq6dj+Gs8ZlIYv29XWxJU+JNVrG4dupIewSyZSaY+hAbKqMyxkWqU1iX
X-Gm-Gg: AY/fxX7digasWmVeADViduJiEzlgzu2vilKklwoEuu257mZ24JXlCMS6ivgbtvXGkzS
	TD3Rzxlt7Kqos1bQAdKvsPs1TD2JlzjfX+l6zkuTraMQxMb1I3RGdZr67vgSc4shfsuWCpkZDej
	0Qw69eK4ijCBq0xfQUUMWJs2DLnbi8u4y+V3b7uJJ6pyMkOq5wn/ekHFDcTWK3Z/OrYJJUZqTCP
	gG3dmOk/g11UBbOxokXZpBWw8qucGjr+JribaHpkGlE403IX0kddvPBWF+W+6W/EoB8RrrvgFp+
	Os4WKyZ1guqwPFAusQ0LsKg2hNw0537z3kaP7S4/Sck2ja3Q2gQ92m9EjrzxFcxKuJDalCBxkHL
	SfGv8KQz6gzjmFqa1iQsqPE7dkciqq4/1PNaEmK2sxAUWHIq1EMEfP77Y8xG1zE87dAQD16JFwl
	vE/TFKcc3iwtL38OXq3KHApG9s
X-Received: by 2002:a05:6a00:6d55:10b0:81f:b3fa:7e90 with SMTP id d2e1a72fcca58-81fb3fa84cemr1003675b3a.58.1768623511241;
        Fri, 16 Jan 2026 20:18:31 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa12b49e0sm3204897b3a.67.2026.01.16.20.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 20:18:30 -0800 (PST)
Date: Sat, 17 Jan 2026 12:18:20 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v4 2/6] mm: khugepaged: refine scan progress number
Message-ID: <jbqygu4u22fd65pe5m4ilm6pz2cabgim7bi4vaasjp2jrqqepw@ozylhwth3atv>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-3-yanglincheng@kylinos.cn>
 <da715a5d-e187-436d-b5ff-153b1f7c8106@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da715a5d-e187-436d-b5ff-153b1f7c8106@kernel.org>
X-Rspamd-Queue-Id: 75C71C0006
X-Stat-Signature: 394cpgu71zekzudu1y5w13htskorrwmc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768623512-300973
X-HE-Meta: U2FsdGVkX1+y9B7kh7HeIllRVgnLuoT8zXi1cNSx33xrlMJaqH9qI9x63HJPSG5TW1ItENOka4Z9tpFw3YlTVlULOjT2VOzZO2fqo8FURTz3roFvcJ7Gw4dLOp5mlIGLsjQhiNU/2lLEdISq0crNT28qjAub7iaqf9RfzpybfM7f9XaWsHx4sZoApuqMH5f0a8ZDnP9w2ASlrc2tLBLKfWKtcWLrvQNkpQ1VhCdh+LluqzLwI6PM6XBFdxDF7uB8QN7V7sc6SN0iv0d6Y1uFyAcax57KmD1OyO1lJa8u6Ctdj1f44k6oeELIYDsUMH0ZD28TnNTRNjvkgIhDj3NEdk7z6GAD5Og4JBS+dCCmzYbhaOYgvCg3zHQBxaltSvXApP9+76uzLYHCM/06r02AZHR9ONghQG3wfdHiscbMmSxaxUN6k8H5svPJLzl+Z0wcsBNByj51PpuHuGFki145a1U/nQD/qDBCr3MOemiVh43Hf8BPKqfvIqZK+ocZurvgB1ns7b4Fp7dm5ZeaKRT7JJ4rssGJp78X8ZGYITh6x+b6Mf0vaBb/v0FAZcO9CHsg7/SeZvZtNbPNrX6tlF4KQXdzQhcET1ZuJFD0v80SLo8hWOA1e4VX2x0Kx2GffBpIpmtfuRUsYV83CcUXJ9SDi4Xl/nlk8eQGh8ZmuyLiwf6WR7RS39TQHE1ZCCiyRLMwkbdx0O2+PBLnrLuHxbEkWWtwpbWpOwB+feaTWCuUVL5At8QdeFkMUOIvpAXbyQ7CQgxZqBVRSknf3mnNd5jOMVhYkc9ylOVytjynBRqjZaHtL33MF6HKgIB+PBRdCmi+qk8AxEQ+eN0J/2xocoOsIOo6/RRb7bcDYWL7l9ZeHC8dgiiW2XcMuTRvUcs676ej7dhavCyaF0ZEbE2kqueXy8jZZ8DiChEFoN7sSQUk5Wb/g0GBn9O87pww/DvrQBRV9cC1kAqRpvDsGigxE+1
 U5rBo2tc
 L9ZhmxheWWVTflGCpFVKSKXopj8POxGTJNMiEiPCn2fIxVSYHhdv/dZVN98LfwpwoxyVaI8tPdYNLw7YGWg8OJGu+JU5kF3FJkQF3jh1Aemr4nja3OQ8bXGzxRoqF+slChv+aMcBZ8x8XZdDYmhgidek8nNbnBMTyQ6B8KVaRl+QGRZzV1DjLHXLaUIaDc6ed0f5uP2f6hnnKm+oN5+FhLZNGcjR9hlB8af2HcFFqmmRDV4ne1TbXtVR2udi+BZ5eS3UWgFxQd0cyaKK5VyCK2N3wQVOk5KQOIO60T9kfoRuuuFW/D0nXdB/K4efO6JJ2BmlQ+fTcfJFhw993tjtmHAetqCJ2zaGdTLH17+xdSIYqfZwl5vuXm5oChg2c4yI8jJh+YrvHxa8ESow/VkkwvRkjMD0e0EzmSIX0aqa6Vt4eCAkyYRG0TxRs1ClkE504SeDqsmd+LE5EowKfUrUoDgSJAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 12:38:46PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/11/26 13:19, Vernon Yang wrote:
> > Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> > even if only scanning a single pte.
> >
> > This patch does not change the original semantics of "progress", it
> > simply uses the exact number of PTEs counted to replace HPAGE_PMD_NR.
> >
> > Let me provide a detailed example:
> >
> > static int hpage_collapse_scan_pmd()
> > {
> > 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > 	     _pte++, addr += PAGE_SIZE) {
> > 		pte_t pteval = ptep_get(_pte);
> > 		...
> > 		if (pte_uffd_wp(pteval)) { <-- first scan hit
> > 			result = SCAN_PTE_UFFD_WP;
> > 			goto out_unmap;
> > 		}
> > 	}
> > }
> >
> > During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> > directly. In practice, only one PTE is scanned before termination.
> > Here, "progress += 1" reflects the actual number of PTEs scanned, but
> > previously "progress += HPAGE_PMD_NR" always.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   mm/khugepaged.c | 28 ++++++++++++++++++++++------
> >   1 file changed, 22 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 2e570f83778c..5c6015ac7b5e 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1249,6 +1249,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> >   static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >   						struct vm_area_struct *vma,
> >   						unsigned long start_addr, bool *mmap_locked,
> > +						int *cur_progress,
> >   						struct collapse_control *cc)
> >   {
> >   	pmd_t *pmd;
> > @@ -1264,19 +1265,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >   	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >   	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> > -	if (result != SCAN_SUCCEED)
> > +	if (result != SCAN_SUCCEED) {
> > +		if (cur_progress)
> > +			*cur_progress = HPAGE_PMD_NR;
> >   		goto out;
> > +	}
> >   	memset(cc->node_load, 0, sizeof(cc->node_load));
> >   	nodes_clear(cc->alloc_nmask);
> >   	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >   	if (!pte) {
> > +		if (cur_progress)
> > +			*cur_progress = HPAGE_PMD_NR;
> >   		result = SCAN_NO_PTE_TABLE;
> >   		goto out;
> >   	}
> >   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> >   	     _pte++, addr += PAGE_SIZE) {
> > +		if (cur_progress)
> > +			*cur_progress += 1;
> > +
> >   		pte_t pteval = ptep_get(_pte);
> >   		if (pte_none_or_zero(pteval)) {
> >   			++none_or_zero;
> > @@ -2297,6 +2306,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >   static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> >   						 struct file *file, pgoff_t start,
> > +						 int *cur_progress,
> >   						 struct collapse_control *cc)
> >   {
> >   	struct folio *folio = NULL;
> > @@ -2337,6 +2347,9 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
> >   			continue;
> >   		}
> > +		if (cur_progress)
> > +			*cur_progress += folio_nr_pages(folio);
> > +
>
> Okay, I had another look and I think the file path is confusing. We're
> scanning xarray entries. But then, we only count some entries and not
> others.

Thank you for the review.

Move PATCH #3 comments here

	> Assume we found a single 4k folio in the xarray, but then collapse a 2M THP.
	> Is the progress really "1" ?

	This example is indeed a issue, I will use "xas->xa_index" to fix
	these issues.

	> What about shmem swap entries (xa_is_value)?

	Sorry, I missed it. I will add "1 << xas_get_order(&xas)" to
	"cur_progreess".

> Can we just keep that alone in this patch? That is, always indicate a
> progress of HPAGE_PMD_NR right at the start of the function?

Studying the implementation source code of xarray, I discovered that
these issues can be fixed by utilizing "xas->xa_index".

I send the code as follow (patch #2 and #3 are squashed). Let's see if
it works? If not, please let me know, Thanks!

--
Thanks,
Vernon


diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..f77d97d7b957 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
 	xas->xa_node = XAS_RESTART;
 }

+/**
+ * xas_get_index() - Get XArray operation state for a different index.
+ * @xas: XArray operation state.
+ */
+static inline unsigned long xas_get_index(struct xa_state *xas)
+{
+	return xas->xa_index;
+}
+
 /**
  * xas_advance() - Skip over sibling entries.
  * @xas: XArray operation state.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2e570f83778c..7d42035ece5b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -68,7 +68,10 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);

-/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
+/*
+ * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
+ * every 10 second.
+ */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
@@ -1249,6 +1252,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 						struct vm_area_struct *vma,
 						unsigned long start_addr, bool *mmap_locked,
+						unsigned int *cur_progress,
 						struct collapse_control *cc)
 {
 	pmd_t *pmd;
@@ -1263,6 +1267,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,

 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);

+	if (cur_progress)
+		*cur_progress += 1;
+
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
 	if (result != SCAN_SUCCEED)
 		goto out;
@@ -1403,6 +1410,8 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	} else {
 		result = SCAN_SUCCEED;
 	}
+	if (cur_progress)
+		*cur_progress += _pte - pte;
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
@@ -2297,6 +2306,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,

 static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
 						 struct file *file, pgoff_t start,
+						 unsigned int *cur_progress,
 						 struct collapse_control *cc)
 {
 	struct folio *folio = NULL;
@@ -2386,6 +2396,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			cond_resched_rcu();
 		}
 	}
+	if (cur_progress) {
+		unsigned long idx = xas_get_index(&xas) - start;
+
+		if (folio == NULL)
+			*cur_progress += HPAGE_PMD_NR;
+		else if (xa_is_value(folio))
+			*cur_progress += idx + (1 << xas_get_order(&xas));
+		else if (folio_order(folio) == HPAGE_PMD_ORDER)
+			*cur_progress += idx + 1;
+		else
+			*cur_progress += idx + folio_nr_pages(folio);
+	}
 	rcu_read_unlock();

 	if (result == SCAN_SUCCEED) {
@@ -2466,6 +2488,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result

 		while (khugepaged_scan.address < hend) {
 			bool mmap_locked = true;
+			unsigned int cur_progress = 0;

 			cond_resched();
 			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
@@ -2482,7 +2505,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				mmap_read_unlock(mm);
 				mmap_locked = false;
 				*result = hpage_collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
+					khugepaged_scan.address, file, pgoff,
+					&cur_progress, cc);
 				fput(file);
 				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
 					mmap_read_lock(mm);
@@ -2496,7 +2520,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				}
 			} else {
 				*result = hpage_collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
+					khugepaged_scan.address, &mmap_locked,
+					&cur_progress, cc);
 			}

 			if (*result == SCAN_SUCCEED)
@@ -2504,7 +2529,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result

 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
+			progress += cur_progress;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2826,11 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 			mmap_read_unlock(mm);
 			mmap_locked = false;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
-							  cc);
+							  NULL, cc);
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
-							 &mmap_locked, cc);
+							 &mmap_locked, NULL, cc);
 		}
 		if (!mmap_locked)
 			*lock_dropped = true;

