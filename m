Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39023CA1002
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 02:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0878E0007; Mon,  1 Sep 2025 22:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8078E0001; Mon,  1 Sep 2025 22:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE4B8E0007; Mon,  1 Sep 2025 22:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 587638E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 22:51:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17E795C580
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:51:17 +0000 (UTC)
X-FDA: 83842783794.12.F5EADF0
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 07B9640005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:51:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZfoF05Ay;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756781475;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xF0+u3i94vKk1aqXJMSL12WDn4bvFxhGB6UadIJ7Gs=;
	b=Ufvvy2f1dI9MxKMpiH74frZP5CjxsWateCJxTAJW21HhDLj8ozpPpEzf7viUDSJT3nwW/F
	q8cNd7ELhSGKQooCwl9SN9AGJrI5t/IZngDFEnx68FNst4P7OFYetCp7/d/u5vd5nzwhCt
	CXwJxHN1L/zheG/It+G/yWbdrD9PTEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756781475; a=rsa-sha256;
	cv=none;
	b=f944dByRcWPFVEsHD8/RsPAyQVgeoc2y/YcNaaSFOBWmCsJqJ++Q5es8Gxc7iGt9tFUV0v
	yVz2GLtte60Qx1ndfgsfQBo+1JXfKs3eAaJ48nM7N/npktT/FudNaI3ku/DN6j5o24ig09
	kiH+3CNrCoZmW12LCJfGlJsVgowoNUs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZfoF05Ay;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-afedbb49c26so746063766b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 19:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756781473; x=1757386273; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xF0+u3i94vKk1aqXJMSL12WDn4bvFxhGB6UadIJ7Gs=;
        b=ZfoF05AyTwF2k0qESbiSzGMT41BAK+MXG2bPPiZ4OMr6Oq2GMk4mVNNgSRnJ/QIh1K
         jpmjpbTgY+5ttbmhKHVNO2uOtBUXZo9DKQJDB/0IbxF3PgY3YjRcJ4G3Xf/zTfGS04XM
         D7dwbqN2lDTN/XbWosB4LbUbnQYBmoXbpCNTrNMfVKGB2FKYSg8x2IWnEQuBJt/vBGga
         Uyt+hWvKdOMxyQHKYNfPYoJX5SD+5uA1meZ8nTlpLLeMFJgfEmNrOhjoANDLSpX2hst5
         02xmxvCtwIOIhv76Zz3g8br2S02uwWaamY9VJ+oiyPRceYlbzGtk/DxKLf0of/ETS41/
         ltpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756781473; x=1757386273;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4xF0+u3i94vKk1aqXJMSL12WDn4bvFxhGB6UadIJ7Gs=;
        b=u6A1dkY8OekEtnM22cuoyyHxUf7dy9d3WJ10e2nnEV2y0uJMIJZtG1Znzu5XrqiWWZ
         YoGUHw/CAtjCGUtBiBigNm/xeYcDKmlqUL9A741M4ZamPKpxm1EJeC/70E+kKgDForzS
         cxSlg08u5Ticl5nO/BoOfnKjhV6w7GolvDyf0sACvpI8h/Ov+YlPAuKZ5T5SnKLMKH3l
         Qi5lKjX0SuCJOHOR9D+sKaX4EDVPyYhK2mUyKt86DNAAIXYhjalmJfWa/end6dRE5OUN
         ayn7N1x1MI1OMCQju0YzmAEkV744kAPVioQy1y3UrxkSVrRMHw82WGjoD8+tPz6NWkxm
         nKig==
X-Forwarded-Encrypted: i=1; AJvYcCU76NKedSfwL4AnhBp73PMPEW1oPOVcOU0vU8oBqiQGvJwOiMgFOeEqZGw66pwymLYTTidf7OZPTg==@kvack.org
X-Gm-Message-State: AOJu0Yxi47TrxgohPZDd0Q9njV3vxj0/krd48sgMobsnSaXg7Y2sHanQ
	A0EAgXSTNPl3Nx35gEj3NbZ68bs9f5ZOQEbw/teqtqR6IsnL+nduCMsN
X-Gm-Gg: ASbGnctlhIOwuRRzJymcA2U91w63Ve6A6MDdiRIIs522EjiI1XPg9x09speAkdb0ilY
	uXM9NMRJomqhgsbi1G4jqL/mcIBJb7mUnKacCIosRWz4GR19BTPEaZuQaqTM6/mmtkFc45FW12V
	Y3w8yrPU3MCgEdWfcnIr3IAbb6rwV9aRMgBJ9p0krD8wJAn7XokdAvvDsMUlg9RsAKn37aP27Qq
	70e7b1Uy/Bidb0rD/YwaMAJX9CIcBiLimKxdJ7o++mwtJktmVY6royBwXep0C5GLYFMBmkLkwb2
	pKxDnq0OFZua3kcFa8r7jfxVeQdcMSeSkW2d7zcbBG2BNzbrTTNOesbhKiVxN/GNDIpNKmUHfsk
	OWIA53dARezcJJKwoF1Z6zvxXUcdZpoQruLRH
X-Google-Smtp-Source: AGHT+IEAusIojQFmVk/wxq4gx2dnc4kHFdzyWer4P7oKpleMhLaKPh3dc/qYbcIPG4E1duSTDnU2lA==
X-Received: by 2002:a17:907:3c89:b0:b00:aa4d:a394 with SMTP id a640c23a62f3a-b01d8b7f96emr1026323366b.24.1756781473164;
        Mon, 01 Sep 2025 19:51:13 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0419d76921sm526404166b.15.2025.09.01.19.51.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Sep 2025 19:51:12 -0700 (PDT)
Date: Tue, 2 Sep 2025 02:51:12 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
Message-ID: <20250902025112.d2n3o4imeptppctd@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 07B9640005
X-Stat-Signature: ug67zyoufew617uxjm4kn5msnp5h1sr6
X-HE-Tag: 1756781474-710811
X-HE-Meta: U2FsdGVkX190jqoUYOIzCPk2fqzMpsUNH9BIldXX3RnIRtnPzXrlJIIC5LVb7HfQa2o1H3rgC4ZFWwJtptRp+0qtK/4DQRaTf2FtuRjGG8y4LHcUtlE9Cr6CPe/CYJKWNPdxWXXwkf5wE0W5luivlnLeJUCIwVUX6deyLCSDPqTKBaWk7/3CKKdQ/UZR2e3k0yxaGJUXNrWpUkPyTvjsAFI7QcQj03rJ+8ghZGhTlemtG3ZUEpb7FJlROkd0W5CPQ7KSS9ERb/jhU9t1h8zxwfNazMWriBbrtYHEuVvJqwMQKNj6ogq5F0HxiRz9LeFmvlKywmjy4s0wqZ1MN3xOrQswVdufgR++mpDJaDKomj6fjvrQs4ZH3+SMVMU+S6lrEO1AOmHP7RuS5hbZO/fA46YkFUnTlGZqT8Q8wTwm4K7/6bEORCCxViJgt6LA1HCBYDxYNd0u8gzUNu2hHgGUQHHd+k7nH1XGgnUiI48P8XZqspE+hxUHL0YkbOeFepDQf5c1BNM0RWg6tXKJKob2iYe/2S1optPabRnxPp9JVIQCa3W8QmGJ1YA2VtoX/O4QG3zT9xOLUoeXfqB7PGjK1vvKdmEd1/aQIdD7HuOLNRMO9vd7Sxb9zOIUANJjneGrEwSqR2bWNTUAWWmFebyfsCsXVM7iVi1e+86xKXZWyk+yCsBpjZiGciCvKKNzImJSpLSXSMzQXLZmqeF0JhIIww0IiksX7kE4oqBPBDALYzYGZ/Aj/w5kVsyPDmAFDKdIfqECpye1voUwqJ3aP8Z5KYT7elCrRW1TxKL2b91Sz5U0iDBrACpCGj6u0u+kDZsdkqFKdkvlNovWnSiMERoJxIWDTxtLBGp4gG/hamoEcsXHucaJ9dkWgP7m8K67znOB0VPlDCaCOsUenOJQoFH2B1gPipIHp6E6BceSuiUcbkUUUVNwPGOgRibjKi4tpEB7HCTo6q5ztNqMEWbTgrf
 oKL9yykH
 D+gTVmW0fALsCtUXAOAeCd0iKfah8F1CPOn+2ja84GrmDsoKpe5mjkB4BH8ejIyumdOlDvL4pKYLbusK4dt2BknsOoPObqwmCPgfc/dVMozkRNLbxPc06yjckwwSDtlTGbSMlYC521Fqevd5eelKGTJLe7fvYIisBul7foVRjdJKEf10M0CZlQYi0BcxFau0l22Vl6KhXAhp5j+W26/Umfc6OJghiiOXG193M5f46Ol6EDWuWym+ropZaHg0e1phoNPIU5W+eNAFhLXo35MiZtdFGK7j5+eszWt+n/wIh/Kw74I8ZhgzQboZzJaaBifP6ymQfkREF2k3SmgNyc+pjDAGqAoQroL67zgABv2bamHNmLdCcPurn15fn9bY45+3KR/ebr0vjanCZkr5Q6VR029Qvd+EDhq/wWqLh6dZuCA+gG/dEHvqYOL6ls+WxbupgXwtTOg7lbOn1LNQj+0iuIwCrtqR1pHtkL8yhovhP7QkmzAYrWLP3riRdrpccsCUwFGTCQ3AW/meDfMEiF+h/ruiGUqnOe/zunxlq5VvVVo1EsB9CM+AigFcROkVYp+0sdTgrBdK1tyiG2bx/eIhlGfZ1ycPH2abOmIdo7T8rZxIL8JDzLnZJW5jVO45c4okS1F25VfEQMJwUXwXXrRF2W56pTCYg47ycMLGn/cTKd7BpKUePYX5GRj2c/Pk9MQQ906qOe0PwwAje1YA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 09:10:57PM +0200, David Hildenbrand wrote:
>> > > > (a) Will this actually do anything? Also, maybe it does now, but can't the kernel just optimize that out in the future?
>> > > 
>> > > It remaps each subpage of 4 PMD THPs into a contiguous 2MB vaddr range and
>> > > perform split on that range.
>> > 
>> > I'm afraid I am missing the "why".
>> > 
>> > I would have thought that a "split_pte_mapped_thp" test would want to pte-map THPs
>> > to the see if they can be split.
>> > 
>> > Why is the mremap required? IOW, what exactly is the test trying to test that
>> > exceeds "split_pte_mapped_thp" ?
>> 
>> IMHO, it is an interesting test case for splitting a THP when only a subpage
>> is mapped into a vaddr range and in a contiguous vaddr each page comes from
>> different THPs.
>
>Right. Slightly similar to just MAV_DONTNEED'ing the other PTEs and trying to
>split the bigger range.
>
>Of course, if you involve more mremap, the RMAP logic of installing migration
>ptes will get stressed more.
>
>So yes, there are various ways on how to stress the RMAP walk when splitting.
>
>> The mprotect test case you are mentioning would still have all
>> subpages mapped by contiguous vaddrs.
>
>Right, it would not stress RMAP as much.
>
>> 
>> But if you think both are just testing PTE-mapped THPs, feel free to replace the
>> existing one with the mprotect test case. In addition, is_backed_by_folio()
>> can be reverted back to its prior version, since it no longer needs to handle
>> the case where subpages from different THPs can be mapped into a vaddr range.
>
>Oh, the is_backed_by_folio() change is actually really valuable.
>
>
>I think I was confused by the implementation that works on a single virtual address
>range with multiple different variables, questioning why we mremap at all.
>
>I tried cleaning up that test myself and ended up with the following (it
>escalated a bit). If that looks cleaner to you as well, I can submit that as a
>patch.
>
>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>index 10ae65ea032f6..aa0f0502efa06 100644
>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>@@ -390,67 +390,88 @@ static void split_pmd_thp_to_order(int order)
> static void split_pte_mapped_thp(void)
> {
>-	char *one_page, *pte_mapped, *pte_mapped2;
>-	size_t len = 4 * pmd_pagesize;
>-	uint64_t thp_size;
>+	const size_t nr_thps = 4;
>+	const size_t thp_area_size = nr_thps * pmd_pagesize;
>+	const size_t page_area_size = nr_thps * pagesize;
>+	char *thp_area, *page_area = NULL, *tmp;
> 	size_t i;
>-	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
>+	thp_area = mmap((void *)(1UL << 30), thp_area_size, PROT_READ | PROT_WRITE,
> 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>-	if (one_page == MAP_FAILED)
>-		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
>+	if (thp_area == MAP_FAILED) {
>+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>+		goto out;
>+	}
>-	madvise(one_page, len, MADV_HUGEPAGE);
>+	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
>-	for (i = 0; i < len; i++)
>-		one_page[i] = (char)i;
>+	for (i = 0; i < thp_area_size; i++)
>+		thp_area[i] = (char)i;
>-	if (!check_huge_anon(one_page, 4, pmd_pagesize))
>-		ksft_exit_fail_msg("No THP is allocated\n");
>+	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
>+		ksft_test_result_skip("Not all THPs allocated\n");
>+		goto out;
>+	}
>-	/* remap the first pagesize of first THP */
>-	pte_mapped = mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE);
>-
>-	/* remap the Nth pagesize of Nth THP */
>-	for (i = 1; i < 4; i++) {
>-		pte_mapped2 = mremap(one_page + pmd_pagesize * i + pagesize * i,
>-				     pagesize, pagesize,
>-				     MREMAP_MAYMOVE|MREMAP_FIXED,
>-				     pte_mapped + pagesize * i);
>-		if (pte_mapped2 == MAP_FAILED)
>-			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
>-	}
>-
>-	/* smap does not show THPs after mremap, use kpageflags instead */
>-	thp_size = 0;
>-	for (i = 0; i < pagesize * 4; i++)
>-		if (i % pagesize == 0 &&
>-		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
>-			thp_size++;
>-
>-	if (thp_size != 4)
>-		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
>-
>-	/* split all remapped THPs */
>-	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
>-		      (uint64_t)pte_mapped + pagesize * 4, 0);
>-
>-	/* smap does not show THPs after mremap, use kpageflags instead */
>-	thp_size = 0;
>-	for (i = 0; i < pagesize * 4; i++) {
>-		if (pte_mapped[i] != (char)i)
>-			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>+	/*
>+	 * To challenge spitting code, we will mremap page[x] of the
>+	 * thp[x] into a smaller area, and trigger the split from that
>+	 * smaller area. This will end up replacing the PMD mappings in
>+	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
>+	 */
>+	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
>+			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>+	if (page_area == MAP_FAILED) {
>+		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>+		goto out;
>+	}
>-		if (i % pagesize == 0 &&
>-		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
>-			thp_size++;
>+	for (i = 0; i < nr_thps; i++) {
>+		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
>+			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
>+			     page_area + pagesize * i);

Would this create one hole at the beginning of each 2M range and cause
splitting underlining THP?

>+		if (tmp != MAP_FAILED)
>+			continue;
>+		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
>+		goto out;
>+	}
>+
>+	/*
>+	 * Verify that our THPs were not split yet. Note that
>+	 * check_huge_anon() cannot be used as it checks for PMD mappings.
>+	 */
>+	for (i = 0; i < nr_thps; i++) {
>+		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
>+				       pagemap_fd, kpageflags_fd))
>+			continue;
>+		ksft_test_result_fail("THP %zu missing after mremap\n", i);
>+		goto out;
> 	}
>-	if (thp_size)
>-		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
>+	/* Split all THPs through the remapped pages. */
>+	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
>+		      (uint64_t)page_area + page_area_size, 0);
>+
>+	/* Corruption during mremap or split? */
>+	for (i = 0; i < page_area_size; i++) {
>+		if (page_area[i] == (char)i)
>+			continue;
>+		ksft_test_result_fail("%zu byte corrupted\n", i);
>+		goto out;
>+	}
>+
>+	/* Split failed? */
>+	for (i = 0; i < nr_thps; i++) {
>+		if (is_backed_by_folio(&page_area[i], 0, pagemap_fd, kpageflags_fd))
>+			continue;
>+		ksft_test_result_fail("THP %zu not split\n", i);
>+	}
> 	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
>-	munmap(one_page, len);
>+out:
>+	munmap(thp_area, thp_area_size);
>+	if (page_area)
>+		munmap(page_area, page_area_size);
> }
> static void split_file_backed_thp(int order)
>-- 
>2.50.1
>
>
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

