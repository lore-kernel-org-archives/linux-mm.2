Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D59CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17408E0018; Tue,  2 Sep 2025 04:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEEA18E0015; Tue,  2 Sep 2025 04:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C048E0018; Tue,  2 Sep 2025 04:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFFED8E0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:16:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 512C0140B64
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:16:37 +0000 (UTC)
X-FDA: 83843603634.20.EB8CD50
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 49C7E2000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:16:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ia3yZNW0;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800995; a=rsa-sha256;
	cv=none;
	b=h+cuvzr0eD38r+pof4O1oL5A/Togbbvs6dNlVBeSA+MDZ/YxMXDhfi1NEy+OPmrRzi/qYz
	tBF6npan0XNHQ4qzJ/Ky/1cDaG33GZE33OuTyGo5eN8WXdQAAq9PHG0r0D1zhC2dUsNFmA
	etY45ovz++bbNSuexcxZaJQ+2fDlS0s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ia3yZNW0;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800995;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YlAMMsnZWcbTLtfMrrk541ImHayymBVM5nxJ5ObINw=;
	b=soNQBnZ7adXNIvfsbdezC8LzPcnEYukHPv4psGDcdKsca0osfY+QsMv3IS3QfQ3NzIesWO
	UvPcrhURhAapuOfiBYCxXtKXDuLleYOtdPYf6VSt8AI2TL5UkVYKh0W4fvDLdaO4o0rnqu
	CZSqTFnQvgqu/0+Af6yEdwEfgP4l2ps=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61caf8fc422so8980481a12.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756800994; x=1757405794; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/YlAMMsnZWcbTLtfMrrk541ImHayymBVM5nxJ5ObINw=;
        b=Ia3yZNW07ETFanCPvMaxIGcASZQicQQ08bngIIp2i8wit+LN7Vp0GvJ9XVA7b3FhIy
         4+un8tNn67y7vSq6LOA2mOEGEHU/Vdtftx55C4zqPytCtVYA0kz6bV+BHiSeHiJtFL9m
         M45CkiKbhF5GaNefRPgYwBKqEBCcvppVw0Q+51M/GGtde4ie/BRCGGGVXh/sLRDF4L6o
         pPeCI150YKloy9nbWZG58rQ5NcRK0D9VevW2b2PskIbj/gJ+1b0IO7OpKkjbJuUcNIaE
         WzbaH/46MmdlkQRc0eS1gkXursv77xCXu4B0WOP+t/fHafHTcCKRg97TKGaXf+XFI0Cg
         fTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800994; x=1757405794;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/YlAMMsnZWcbTLtfMrrk541ImHayymBVM5nxJ5ObINw=;
        b=Aw8yX6iaFOT67TRxlA2F6yVpCz2W69+dVentk4oAfqBUROZccq50gUK8WGd88FIAkW
         JJM/M56WM9cWAuRflAdSj8EIK2WXiGksTUVGcb9EOdXRfFMlubnS2x2YvoHK5df9VDCl
         OCWFnMv1JgcVnbtcCfh3+UCunYVDwfe8UZkoc4KHvoOGTuBWDccO7rDdpGNJjVKwGhm3
         tpEUUBFpcHF3ykjZ0enIGNyBYIfKToos5Ld02z66DLQRatTuVO2BxLJjcxIugy7msD2d
         vS25RHNxVwtkqS2fo7Wtzn7qIBD+XzJHhyE6isluV3lelSrAPdxJVEdjxVgs7gK8NTMR
         B+kg==
X-Forwarded-Encrypted: i=1; AJvYcCVQ++wodmc/xhi4Eb1Jm5jp3Qm5se8HeznvcopqD1kD/K3rpthYueSa+VbCVa6xR3o00UKGk2PniA==@kvack.org
X-Gm-Message-State: AOJu0YzMeItJvYHPlksPcivCDT+DCId8y6074SrdYrrDcVoqDqPVhxm2
	dk392TThA8aJw0oKoZeiCckZdhcaKfnnBi4w2OS/OVNSlwwEmDlOzqBS
X-Gm-Gg: ASbGncu4lt4X8QEMKKxmjaTjOv5jQkLf3N/SHwB2yYRjdQ6GAw//AE0VTGDhITaJPBp
	Sf7u79c8n0fDk+OFUBYRubY6LgrDLmfWOqAxd2vp6DmiVS1veASaRgvmFDfBNfozPLxQdCaXBUC
	tZXSHhAKAS0SfGY/g3pRUKb/mhUZ6zMnsWO9fjt3zzBroeMw3qbazPCn5g+oiiosuEZIUI26dtO
	nvfNJVYN7JjBvmegWAATUe9j2XuLY/64qd+gG11tF7hlxAHyKlWgDkEY8KWu2cQznXvzJhLN6xk
	+g6LcS8q/LkJqoE0Mohh1awMF+6pz2uoSG9zGYXwThTh/90cO1RSd+qJ2JANcvdBglEwjhcyK29
	zmNgemCzE3RMtOfjZ4qSNEsDqBCEyBCsiN2/x
X-Google-Smtp-Source: AGHT+IHkJHTyicWy5ZD8fYbhilGQrPCxOJFfdANlc2M9fuhxg9frq+7P0IyS8aiiCPThUcFiGHj8sQ==
X-Received: by 2002:a17:907:d10:b0:afe:cc9a:f58b with SMTP id a640c23a62f3a-b01f20bee98mr1142674166b.58.1756800993126;
        Tue, 02 Sep 2025 01:16:33 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b042b0046ecsm447391966b.71.2025.09.02.01.16.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Sep 2025 01:16:32 -0700 (PDT)
Date: Tue, 2 Sep 2025 08:16:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
Message-ID: <20250902081632.mopnwlt3stpijejj@master>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49C7E2000C
X-Stat-Signature: aqu8texejt45zurm39wcwdn48sjcmc3j
X-Rspam-User: 
X-HE-Tag: 1756800995-90302
X-HE-Meta: U2FsdGVkX18GB6aNTXjeIwsJ3+kM2Pr3TwPzCMrS7ihBj0Zlb5K3g/qDJ+CjthX0e7WX3Q6tY9sGJwg/keuCMi49wO6iaFde7NUcwZ5BvlIrJKhozwjGzo/IwGSs25l9yWgIu9uDLEiZRMQ53wQHuOIhsEmj2lezTjN7eTuy/mIxFRSIAQwGPU6PooG7eDvkJAQXXYAhlTC7H2izdGnk5vgAhDp7kdiInrIkacZAVyR2mxQ38W/kIQa/k5wlEAPW4vSFlMHRVKYYXpvLnV4sv6LPY5oWPorfUbg/tllpBqQe6DDwaxiQd1tikli5peayaGKNuGItt9k7vWYd2CGPwVo6LLjoU9+9kq0tmu8D5O6RsLUSt+Z1uulqqB+Du5xw8E6xfZPE/+/ypBfzZ/W65Oq4bnlmEySIkqTJxJbWJSM2f2MgmermD6UWdkZkfReIHKRfdZhzFFXF4qWkOql4cVXXN78HwTGyJYIKSMqEZeDajZzy8RFuSwLWTh0yHiU8/2xwYrYzxoKpI+Bu6XsQyb3JwFLktoRFgjtYxoZBBIAoOHlKj1FvlRwaORjrqhbBkNWywDwNvBYSeM0zTFoqRb/mrpcJaKwbU2HA9ltBHUCVeMNweKjyjAZ2lmK/iu4VFKdBThi4v2zwO3IS7kC5uzBmfEwrxq4UI/NY3MwANbTtnkGCmJFAD1mqdLnnW4BE7PmZfpkZ/gkNUs0STLkeBzzgwv1/9jB3FCqan9gYwAmOA8by+ro0c7Kk11xUbnF+ZgfeCGZQ45myc01YC79VojzopliYHdpujUrjQCDiKBz/R6/hdcHDX5vbyMQ9R14cc7DjU1cuZCQQcXqpdeArhqsS4AuPyFtL/RQoqmXn8eWInk9wOTpITteTXDCrsCoav6jvQFtnxSYE8n7QtTb6lWiDUQHOrKeOPAgzDx4NjCqfvJni+C+A0LopAYVPhdd/5MI4id8/uQfqyLGTzlS
 RVUEjVtn
 yMYzOb5iS0kkf+pIHCAWUEqO3GypztpPtnIXTII4RSzN8TF2uALOUuNqfP0BZTZT4vNq+/DYU3muhsvx5VeOzTfp+s4aB2yOIMJdc1KAIRQztccc938+3IaAroJMul0sC495Tp88JpzO9AL0/PARjXc7ekkzA5LgXjzT4/gX30wYjLawfdbKRJ/Tcth4UBXtPHM7g1QgilW1bohgWl1I7ox6dHtKzUmYI8iwJ1LDGiOBLptwtlkFuG/AhKH3oVdGrCtSIcb3NXG4pxUdhbgCfTvl3ohxhEnAw3de6GfSg8YCqwgsTY4S6/uHSFVe9tiVPrT9SMcYzY48hmFwYN//qkU7JMSw50fx9tMTts+QP1tDHc0oEtJTyeVo68USEsk65AOp4YHTL7a/85gScYK13zGv1Gwm6p8ILO4ASMq5+MaIcBDVEhyFTTGZCPOXBgt3ArcreqYvqbr3DVj7ULS0CTkEMJh7ska5+8kKx+xv3aEcOxtRdbgA81nm+v7VoiGCmTK6Sa2cIpxXwkgbtDHkb+VK9u89AeA2Xv7R9Uud5UYfzf4WwkZowmYUc28NQKjBprHrwScYo/Qd8dOzUNeiYdstcBOIH7oV5FJB/Vcxy70I0o5KcoypG4wvDe3X+EdXmSt+l8yawd+bLBO0kvVK402MUK3Ai/vzjos/SlRixD4NaVoNmmdk5Bysus4wxY0MFFQ2GG+cFaZXP/6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 09:10:57PM +0200, David Hildenbrand wrote:
[...]
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

Not sure why we skip here?

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

I guess we want to check (page_area + i * pagesize) here?

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

