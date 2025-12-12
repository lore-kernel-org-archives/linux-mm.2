Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78E8D4921E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 18:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435476B0006; Fri, 12 Dec 2025 13:47:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E63D6B0007; Fri, 12 Dec 2025 13:47:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5016B0008; Fri, 12 Dec 2025 13:47:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 19B2D6B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:47:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F49C88BD6
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:47:57 +0000 (UTC)
X-FDA: 84211703394.25.B7C1E15
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id BABCDC0008
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:47:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UTpNDY3h;
	spf=pass (imf28.hostedemail.com: domain of smostafa@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765565275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyaZ/i78MwYb3FB370zdecXw44g8nQdErJMSZHrGqA8=;
	b=aouPB2BBhqhXJ7SHoVTNgnrPCQ6gEZFZo+1+D3Mfz2BQhAZ18/9ddBVwYQt7d4hY2DozOK
	Fqdw82aL7ABOTphu4ml7GZdvRup8Yj6JxpWiSpD4FEwy8CpZheDrcmRdvwja1d8UvGKfPU
	MAbXHUbckb7nBG0/UEQbt+L0XMduQ/8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UTpNDY3h;
	spf=pass (imf28.hostedemail.com: domain of smostafa@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765565275; a=rsa-sha256;
	cv=none;
	b=jsm5PlQdBzOp1+J9U9BrUpFV0l8hPsYcsBl7onJMGX5vbA4E83XufpKsAnkAZDZrQuz3Ru
	TI6M50pM0QMB/MoB4R3uNURkmHZH38V4yJD9NfnKuDd0oEYMoEMeMF9Lg3IiEGGQ/z+ei1
	uwr/EJOPCiIAy+GqvCnAiucA+1tWO58=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47a815c43baso145605e9.1
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 10:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765565274; x=1766170074; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kyaZ/i78MwYb3FB370zdecXw44g8nQdErJMSZHrGqA8=;
        b=UTpNDY3h4e27PBr/+kNQycz3aePiDfkRgUDNoBiSC+Mgj+nMEU51nNbMdaCQ5hTVN/
         trP/XKtH1j66URsLgxccwTNQJ/Gc+8jBzT3DfJl5LsZJp46AzfFKA+BWJ2ErfTxNQtZM
         ZcsceX8VqdfwLdOgf3bXENVyXJala4P1epgHdUUrDRfvVGOhyVBWS/HhBuI5/YtVuxvN
         hv3EnfAJDJ1mtGLUhheO2fUd33aOY+JjXhqQ4y/a0uOMWPPd9cKqWTpjxaBgTiT1BSMx
         BRueKjQYBw8aO6TEt8dYHvwuMl1pMvzwXCREL5jm9ENoTRN+6AktJP0YZdGNZIKPY+RP
         cRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765565274; x=1766170074;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kyaZ/i78MwYb3FB370zdecXw44g8nQdErJMSZHrGqA8=;
        b=X1UvdiVrq/pNeltjThsGYi3QLGq7JHzTyp6jwOzdw0FHKbvQ2sdBFajZgizyK24Xdb
         Jjbxk63J9/VFQAoN/lXvsmbICwWfJIrp8jqLM3WRDPgycBRBJ4++1ZngbKati5Mi/10L
         7dsfNptIwca6+HBC4Aoml3JMoCrwMQlaEWMNIN0YIbbhnvrueJp4aCKmiuVWLdBdSKva
         LYeVPCeaDB1xYhl7DlovvWOkmo3UM2vwNSrBjpDSTGTzEPjo9kaWBUE/1tBPyPawUPHV
         gORg9WbWbpn1IWtUMe13z2WqkuE1M3LWlGDw/1pEAlBC6YVs3dp+T2T37k8xQ2Id9GBg
         vWkw==
X-Gm-Message-State: AOJu0YxkmP8aiGQXX/EIN8QE7u4PjgkC99H18sIqKo1eKUmFGchG46cQ
	T83xOZuJ/SSf4UpqmzO8uXoD/z3m3OAMbW9fu5RmDQHig+baI7jCFYqGjMKhkE/nvQ==
X-Gm-Gg: AY/fxX4ln6pVn3OqjXBM2m0TkcV+RYwAf2eXZDdjBhjI6iaXZcf7u+kxoFM684ZtU0K
	UOReVp6IppdLLjOPxUqKvNUfK3rqt/dnAf9F8LLQVkZ9ocniWQE0QHmxvp2fn3XuKUjW3pOJut9
	Bl3ys1t4UQXZZskzTvj2l5/6FGnm28Y7CCryNt52cWQ41h+BNH2dJm/tUwrJe9dDo411G+DQ6kj
	4wzC40a07lWgoTbjYab3kbCC9tcvym0kpR+d3Xnjo5LMJMxdO+9Jg+xumpbN1wYteSunpksLvLo
	cnjzsIhrpfI6CaqtICV0VgXWAsEPRlRH0ExX/9QmRR48tPn4PCmpHwc8uDF2rYr65BuKl6HVlUo
	ua4AC979Mvuc/YpY4/W/b0Op+9yp6QSV+AnfbMibrPg8Dka1qybxsRMXbbmoOTeu8lUv68H2wHF
	CCSN6yrDCkq+X5xb8asp0fmt8380V4cYp/MvmE+jG8Xy0GFpkTNQ==
X-Google-Smtp-Source: AGHT+IEVZG3wHfe72Ly1OF3yuy/6xrNrPiEA8hzzhu0i82Q2n2GZB/t5f/ePhNdeE0eyqp1ZEcC0Bg==
X-Received: by 2002:a05:600d:106:b0:477:73f4:26b with SMTP id 5b1f17b1804b1-47a948c78e9mr17525e9.3.1765565274191;
        Fri, 12 Dec 2025 10:47:54 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm43341825e9.3.2025.12.12.10.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 10:47:53 -0800 (PST)
Date: Fri, 12 Dec 2025 18:47:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	rdunlap@infradead.org
Subject: Re: [PATCH v4 4/4] iommu: debug-pagealloc: Check mapped/unmapped
 kernel memory
Message-ID: <aTxjVhQxJAX9TdLm@google.com>
References: <20251211125928.3258905-1-smostafa@google.com>
 <20251211125928.3258905-5-smostafa@google.com>
 <aa14d149-dfde-44e9-8fb3-72cb9b0e6920@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa14d149-dfde-44e9-8fb3-72cb9b0e6920@linux.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BABCDC0008
X-Stat-Signature: 691ka7zczhqp175x6uemgj97mwufz3wr
X-HE-Tag: 1765565275-286633
X-HE-Meta: U2FsdGVkX1/xIUwTAOZafm/YRWP3hCtwT+ClwHWVpvAH6J3Gsv43tUc2k3Fpx5wbhQI7AZqAift4ASvEftYVGz1CHiuldZziPXDeM6C8tOdeDCAGNCaHyVOBUpomvdIm6x5lkQrIBXMprr0hqPZaHs6YzW7u37wKU8OE4HfIUfPHA8CHoFlqWr8BGIwKU5asTU6+0zdHwnaI48JW6qDkb49M4I38lQFSgi1ShFzu4ec0L9DOuCnJOaSrmeztOvXJWKEJG6k3cHqqfj4Ddg8ELp+nssGD3ysZczry2QOSmwhxYI8a/dJOsw481JyW7kJv+wCcqChvLtDXMXoMUY+AABc77vrBTSU65T9tE1WjtRzT4t91tyzFLKHWFaju1zkXYRAINN7wGHNS/d9ky5lcQRjL4W+m/cM+u1pvVdzib/XZbicIKj0crVUTiSvoS2lEXUY136anfpSxP5KMhcwBHUYWlFadl1LptpKyeejx0nrbZ25YBgE43VS1lIOWtsGth8oXA9mPwWU8sCKl7tHAP/SSs++vJ+kzF6LSBRJqploL3uJkzFN2lGyPVdxdF1g4CsOaKRL1hUDJHQ2Ec9NDjmCSiK15/82MYRDYxkZN+J54mFfYPM6pzwsLDZ1aBqI+gV9ib8tuG+1V1q6b+8myVrG5vXH+sob5c5WlOJZR+vUY1ZT6CJVM+nrJ9pNqUscC5X2rImqwbhHdCXkHjFCxqHlMzqR1/fc5RGadDRaFKlJyI80CQ6KYQjL32AqpE2/tqoum4panKuDf+neGmclP/LuEYE/q+YgGO6KcZk1iPNyudixLWgms/54aH+rN4gOjiWlWw1COT8GklbZMQwlyPCTSp7/ZyfmtfDn9Lwgcyn+eLQEsmmPu8hfw8qhFO+QI533/hHwJ2k9qm+l1nDk20PFhxDP5YhEqQdP0zkP6rGloDMzkXMZPR8F0Qsa13kYD0rFZN8aTmo+AxFmwkCM
 FZbxeo5e
 TAUsy0yh/FmRzou03f1bKpzpaEXfdKbX9CM94ZCqtRPeVGcBmbC5BeC7ourgKZjHjnLxZqwo2dGHnGUEQgApnPAolYyLC+uxxd/2e3HhXT2l82uxO4Dr/lkhVlwnkMAfVH2U6Pw/gexlQnfmGOSYGSYJkx4OeZtHeY6YjPwmbVDlnkIKRJAC4FKEI4ZTd2KTWnCk3jVhz4SndP+CaTsJggelQzRASD/0bO3E9AjR2J8YnrGSQ83nfeKrnXmHGmzmEjxFWh8sf+nRcOg0r8viDhJvwqMwvlU7sQ4VrmCptuCqla3VRFotD7Lpox1ziZ6SY24+7I5mM//x6hgF7unQ1RGg66TiGq7Cn1Dj1cURdeGSYOxfnufU+p12t79NL+CkLYKkR/9eIH0prrIvMNiBikbqYvJ8QyR7w8xto4ACXWeLA5Qwf6kSesQ0Thg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 10:51:24AM +0800, Baolu Lu wrote:
> On 12/11/25 20:59, Mostafa Saleh wrote:
> > Now, as the page_ext holds count of IOMMU mappings, we can use it to
> > assert that any page allocated/freed is indeed not in the IOMMU.
> > 
> > The sanitizer doesn’t protect against mapping/unmapping during this
> > period. However, that’s less harmful as the page is not used by the
> > kernel.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >   drivers/iommu/iommu-debug-pagealloc.c | 23 +++++++++++++++++++++++
> >   include/linux/iommu-debug-pagealloc.h | 14 ++++++++++++++
> >   include/linux/mm.h                    |  5 +++++
> >   3 files changed, 42 insertions(+)
> 
> [...]
> 
> > diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> > index a439d6815ca1..46c3c1f70150 100644
> > --- a/include/linux/iommu-debug-pagealloc.h
> > +++ b/include/linux/iommu-debug-pagealloc.h
> > @@ -13,6 +13,20 @@ DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
> >   extern struct page_ext_operations page_iommu_debug_ops;
> > +void __iommu_debug_check_unmapped(const struct page *page, int numpages);
> > +
> > +static inline void iommu_debug_check_unmapped(const struct page *page, int numpages)
> > +{
> > +	if (static_branch_unlikely(&iommu_debug_initialized))
> > +		__iommu_debug_check_unmapped(page, numpages);
> > +}
> 
> Same here, possible to make iommu_debug_initialized static?

This also is similar to the iommu ones to reduce overhead, the main
feature have the same pattern with "_debug_pagealloc_enabled" static
key.

Thanks,
Mostafa

> 
> > +#else
> > +static inline void iommu_debug_check_unmapped(const struct page *page,
> > +					      int numpages)
> > +{
> > +}
> > +
> >   #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
> >   #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 7a1819c20643..3763b71a7d3e 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -36,6 +36,7 @@
> >   #include <linux/rcuwait.h>
> >   #include <linux/bitmap.h>
> >   #include <linux/bitops.h>
> > +#include <linux/iommu-debug-pagealloc.h>
> >   struct mempolicy;
> >   struct anon_vma;
> > @@ -4133,12 +4134,16 @@ extern void __kernel_map_pages(struct page *page, int numpages, int enable);
> >   #ifdef CONFIG_DEBUG_PAGEALLOC
> >   static inline void debug_pagealloc_map_pages(struct page *page, int numpages)
> >   {
> > +	iommu_debug_check_unmapped(page, numpages);
> > +
> >   	if (debug_pagealloc_enabled_static())
> >   		__kernel_map_pages(page, numpages, 1);
> >   }
> >   static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages)
> >   {
> > +	iommu_debug_check_unmapped(page, numpages);
> > +
> >   	if (debug_pagealloc_enabled_static())
> >   		__kernel_map_pages(page, numpages, 0);
> >   }
> 
> Other changes look good to me,
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

