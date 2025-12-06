Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE016D374BD
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 05:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763176B0356; Sat,  6 Dec 2025 00:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7140D6B0357; Sat,  6 Dec 2025 00:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603AA6B0358; Sat,  6 Dec 2025 00:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3276B0356
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:56:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4C8AB8CBE
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:56:09 +0000 (UTC)
X-FDA: 84187985658.07.265348F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id CCDB640004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:56:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lb56otAV;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765000567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrbaEeZyFtbngXF37obLkCJVhms+uI4jT2nngSTJ7L0=;
	b=jAAsko55bIFSLwKZsOSii/p07vItmgYKUMDUIuJ7BH2Z73HXjbzrzwJD10v+Ee3v4glV8Y
	DMzm+uXj/sa8pkkkj65n2Z8MehXXQeRkxy4V4YNrptfJgKnTLos6VHU47WsR84Q49lHXUg
	fXkpb5R1t65SAGT+hty82kSzu0C1oX4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lb56otAV;
	spf=pass (imf17.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765000567; a=rsa-sha256;
	cv=none;
	b=hatvtVPFfVo5E0UVgXm/hRMN2th1v77HtrnyjAjDIcHXochHEj18SM2qa9dRz5J9bgy+Ny
	GJJ5onJHzswNoAD5ETQwkW9O0VHvatDIGswcTTlpdfd9P5ZQiu7MF6cUWz3Z3qULPQp/JO
	Jl60PVIQSC0RCw9rmFusRnJ1aUsVvLw=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29555415c5fso33587425ad.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 21:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765000566; x=1765605366; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrbaEeZyFtbngXF37obLkCJVhms+uI4jT2nngSTJ7L0=;
        b=Lb56otAVKpv/s6KfUqcSruCSCVV6bZ0rvn+MHsEShmcmaLNT1X4VvMzUN/GsRUoIwm
         1ghhsmN2MtaIrlSxs59XWwuiEwz2XAYrXYV4107UsLWUP5sMWj3zC1Y4NHxDdDTJUaEU
         +Q9TTZD7kZ1CGMYfr/RzksfAQBiLLL/311aKrixid/aT+zd7KydRhryrElDyOi/SpwrF
         JX6/FtPM5ayQDqvmNJ9CuKDCDujme3ghPhTtf8MQVQK+1fPFhRHmY7s7G+drU7ohHcfV
         NQvm2wKp+mKwEN0FD9xaRfD4TTdv99yyCayCMBUS3IXUSXdJAEVqu0oFdeATUnbUDPFM
         KObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765000567; x=1765605367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YrbaEeZyFtbngXF37obLkCJVhms+uI4jT2nngSTJ7L0=;
        b=O1xWJJ+6twqD8SGwuZaHeqzig/TywZXv2t36arff/4MZXZGKk+0/uSvnU7YSB7IbQX
         IJ+FodbTrEhXXMVkCERj6+MCu4cShx6PbD21JbIb0tAqh7PSqVbbNtwqhClvd3AV1mPr
         3prUB1cEPEfrVHbufmo4U2VXhL0FHfZno2d4R/czUOb0r8MvvIormYsfBOGovd7zFHkb
         11yLYE+TXRkUl8IF/DSTI9N3xPWY4p6ClbvJSxe2nbxhKggnijxTKCPBtdsN12ncdX+U
         lzRGQwuxx5NvZnDY51sWFBDz2mtBBMZy2EEi5cSutZjC4cJDpKw6cmtAENyvYYrSwCVZ
         UH/g==
X-Forwarded-Encrypted: i=1; AJvYcCUhIy4QoNLv80Zp5lrptL5fPt+am6/9FjeNSVtU+v6/nbKY2E0As3aJFkA85yOKFeMBIv0KoiOyxw==@kvack.org
X-Gm-Message-State: AOJu0YwXbRxZNNxmOMhTKNccHqIIukvdUi2Xfh7F3y+V7z4HffX3z1iG
	jFcAgwsCpguWYN4g48uWAhwBesBh9isUFRH5BLf8pBnXsK9aIN1/JshP
X-Gm-Gg: ASbGnct5zh3JXvWi1HHRKfGyWmV/E3HXnKvMx5r/3X//ynCLpsJOP1cOlW2QqhRW5UH
	YF4anEnckmThcmAueYc0fLca0pkkBe2vnlh5lXPNv9CwVA9nv3j56+eSF4RYjfjUH55gTxqlhtc
	EY8HCSKCfiy66QX9r7xtZvSHLELzH5d+xkwrlMIj4vPp/LSkICmEjE+pw1cybl2f9BD7JBH8se3
	xi6mn56c532chXtqwN7g1K8jX8b3FxVSXTyhf+eFkARI2oJQFWlxdaJSHOLMgB9aCNTEbyHVJ6x
	C4p6a5qcul7lCnniv9hhnBUbv0j2HgKIA8wKGfa7cuMF8ItG+nz2139ZvcyIh6uzSsDpc/rAs9k
	+mahLi7rKZMzg9IdQB48MX+639iy8lvuAmIHV/a5r0l0mMuRNmX1Im3Dmz1ykgOOS4MZTocynaw
	==
X-Google-Smtp-Source: AGHT+IEClIJqnfu4ac1OktA9MDlfbK7+ctU0dMbbXWjgWORZv1YG8Z3vrYDot57qQm9pxIBtqkyn+Q==
X-Received: by 2002:a17:903:1a68:b0:299:f838:a279 with SMTP id d9443c01a7336-29df547233bmr13933795ad.2.1765000566526;
        Fri, 05 Dec 2025 21:56:06 -0800 (PST)
Received: from localhost.localdomain ([2403:2c80:6::3077])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeaab9c0sm65407775ad.68.2025.12.05.21.56.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Dec 2025 21:56:06 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: david@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	arnd@arndb.de,
	harry.yoo@oracle.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liushixin2@huawei.com,
	loberman@redhat.com,
	lorenzo.stoakes@oracle.com,
	muchun.song@linux.dev,
	nadav.amit@gmail.com,
	npiggin@gmail.com,
	osalvador@suse.de,
	peterz@infradead.org,
	pfalcato@suse.de,
	prakash.sangappa@oracle.com,
	riel@surriel.com,
	stable@vger.kernel.org,
	vbabka@suse.cz,
	will@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v1 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
Date: Sat,  6 Dec 2025 13:55:53 +0800
Message-ID: <20251206055553.21759-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251205213558.2980480-2-david@kernel.org>
References: <20251205213558.2980480-2-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z19fzm8y3igqmnmquyit4odbo8y4bozz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCDB640004
X-HE-Tag: 1765000567-811301
X-HE-Meta: U2FsdGVkX1/dr9IQrsML22+ic4nm/x2iGrOkHc6trmkIDM3iHfY/19okjSwWfSqdlWAMm+WZQC77vvK5t5AzE3hQnGLnRngCMYok+U5jecp3V9I+K2DWz1TYl66GEITxJnW85Qw8xbufAlMAbSs2AVvUdsomeUkYXi7Y0uzmEPqkAKyeJffoDOdo5gOyg3KOMQFbxLyk+9mHRuxUr/u8bJPOO6Y9l2nJ1MXTAbzvXUkFZ+l83ZiwbxxTzNL1wsdZrW/Xrro1WiWSH/FSE2Jf5i6zGrlnPhH5tvr4cM9PtNkUfw3YVVMUzbWY/JfBuw+aQsavetSgkmwuda/eTeRjQDGElzmPMGG6DEL1BRvwM34vmJgiKLg5B2T9HjpUcpGPsMq82I5NXBvElNRoP6E2RgcBl5sThV/Tl6JRTU1qojqLUfb/DiQgcxiXeUu50JmKXNdAWV/e5D93BX+YlPkQEQH22FTfU5QtqLLOLcAEi6y7VwsP20OLT/XmEiBEsV1LmT/PC2SyWrUtPpIm9IaGos9AcV5GE4JMhLYXl+POqcozLEe88t4Tu0TwrQld1vlvxUK9atwSzR18e1I4pe+X8Og3PixiWwtJITYChrQEzwGdyLkvgZoyskN2EkfbTnvTtCAceE8NeXJhl78QCxR4n4M2BEfkqceAaFVGkWYa6N7tjv8y4xHFyFdVYY+jXNBi3MVehAX10ECwoAWG+MXX4EjYHijYUMUrGDH5m5EkgrqKLzycGjCepVvE1ACCYRutS+vD3HZQ6krAR3tPm6qqKbI0k6y0ffrh2BCMgf+GVA5UCAB0y0fCoOcCzgqGHBuoqoBsTsmt0fJskibAa81QRyu0tgO1xOXCbq8MtEw81ruFEAqfyF6A7hHQC8UVxl4JypMIAr7ig/WXqQMoCautYckB5GRujzngQEhFKV8vAWhf3GfgcelEJJaYWl0KAYBUblpbvaDAPRlOU7LvY7G
 1e45LDbo
 lAPiR872HMW+0dClyJKbOaxWjDav1EJ/2X8VbInZ6qRZVeKzAK/WkYYISwCkqImkItS/DvHSDRZB3ITp8hB6G4VoeL2M65YPdVUK+J3u4mkecX1soVvB2nbKo3BuGGGFa1+Bd8BP2G+0k5mvZ/mtheH6j6YVIPxK2ylJQT+zeHzUUMLbOILKiKRZJKos9lDb6+fH7sbZCvaqRDHNBhV9UX7Ej5MX0gjfKjosvw+8dvs/gOY3iI7SG1j35CetqTxBl20VCsCIj8f8rxPckyFzYZkVSQjOB8d5UYcBuL48M/T6ldcu2AqQkQUQbUkYUZ15UFrreZBROpvA/FVDDMuRx7HuYorSr7NkDkMk598wiqeqTX7bB6GlXuMmKpe4pywk6j9A52cHG137x2ZJQlqXc35PjmnWPkFVqZr9QY3V6qS1+fvQ2YV84TXxHTXQcdnkXlNp2KWxVf+rtDg2bU4P10RDvm0wEXteyeOGUKEua/4F4Hlb9r6O4t/wlyr0APXOebduhTpfy8/s/9dCWYlaXaRO5v6EJsabEz6u0wLieW3zTMY37M3Tifp72dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Fri,  5 Dec 2025 22:35:55 +0100, David Hildenbrand (Red Hat) wrote:
> We switched from (wrongly) using the page count to an independent
> shared count. Now, shared page tables have a refcount of 1 (excluding
> speculative references) and instead use ptdesc->pt_share_count to
> identify sharing.
> 
> We didn't convert hugetlb_pmd_shared(), so right now, we would never
> detect a shared PMD table as such, because sharing/unsharing no longer
> touches the refcount of a PMD table.
> 
> Page migration, like mbind() or migrate_pages() would allow for migrating
> folios mapped into such shared PMD tables, even though the folios are
> not exclusive. In smaps we would account them as "private" although they
> are "shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
> pagemap interface.
> 
> Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().
> 
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
> Cc: <stable@vger.kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---

Good catch! Feel free to add:

Reviewed-by: Lance yang <lance.yang@linux.dev>

>  include/linux/hugetlb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 019a1c5281e4e..03c8725efa289 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1326,7 +1326,7 @@ static inline __init void hugetlb_cma_reserve(int order)
>  #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>  static inline bool hugetlb_pmd_shared(pte_t *pte)
>  {
> -	return page_count(virt_to_page(pte)) > 1;
> +	return ptdesc_pmd_is_shared(virt_to_ptdesc(pte));
>  }
>  #else
>  static inline bool hugetlb_pmd_shared(pte_t *pte)

