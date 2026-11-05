Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3BC606A6C0
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=g3aspVQT
Received: by kanga.kvack.org (Postfix)
	id CA3806B05B6; Thu,  5 Nov 2026 14:58:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AC76B05B7; Thu,  5 Nov 2026 14:58:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B7A6B05B8; Thu,  5 Nov 2026 14:58:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 851DD6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:58:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00E2640C56
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:58:57 +0000 (UTC)
X-FDA: 85402128756.04.D8A6D60
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 24DC28000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:58:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=g3aspVQT;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793908736;
	b=dPlGQ2x7ytr9s0cXOQVv04NDyxRSvq1WOV/mLwFT4PBOJGQ1aepuDnM97HYwMXlS1eHwLy
	u7Iu/66nmOfRByiZpgMYTcNNIrndK7z9FrXmO8q6el0PeBJizRLKUQvjUWznBOV8RZlhTo
	+jer05O0KK0y5KyIddwEumiPu+FQK0E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=g3aspVQT;
	spf=pass (imf02.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793908736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=km0LURr6P7Lx8jR5JYqDxaUcl9rwTeeAgZu6u5Eug1Q=;
	b=3YYI7HYpWPvp8ocIZCVwA9GmYoD0hUKis+I6J7a1ztz583/ly8XWOVw9xfMpPqQj7cRSHz
	fkroOrUDf5m7iSsxGVOydBqhaiePoYPsVNGIm63stMeF7laqxVWl2RVkG+stgZflJQRA/5
	0yGurHJR83MfK8/YtUkLCDa1Jciu/ws=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b305d38bafso23676547b3.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 11:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793908735; x=1794513535; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=km0LURr6P7Lx8jR5JYqDxaUcl9rwTeeAgZu6u5Eug1Q=;
        b=g3aspVQTqu3amGzKet0a8+mX0CjegaMW4RydEsWBx/+2ZzPxbeaXBfksIc45ZVEfQV
         jeUhlgKEzzkQREow5Z7xog8Zex2Spf3DLnGZkh+aCW2ImUHyj1+39Nr5h4hbTwjZzSjS
         6i4HgC0ejh6s5vFgqG7LVYN+UZi+yptQbtgqh74fyA+XBTuay2TlQwEkPl9SSEP0fk+h
         fPJW//kkFsnFzZ4QqK7CKmHvpQyDNerJj0oYuUSBtNNgQtAZpx7KMrOBp/94vRUsWtDC
         krrL961l0H6D/+Xdvfvij0pdqf9sHXCB6OnZxXcGdjAsg5PNqXs/7xMb68aMgowZy3ZI
         Z99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793908735; x=1794513535;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=km0LURr6P7Lx8jR5JYqDxaUcl9rwTeeAgZu6u5Eug1Q=;
        b=a8hiQ9mzHVDy+NPb68TWXwANpqkPsVwKIBzPNybIE3071rpL+wdwUDYj8iG2ZK2wf1
         JDxkeGBxYkughqV0cYE86slUkp9dXccvaqBk+3pScDuL+zjGexU1s3YMVZdQKEQDRjW3
         B4dvK4b0cdcnWyo3VYYZMHWleZDSevTFERkdR96gQzySPT9nAJaYhlgUKWzODqcHmJUU
         qk7esmWiOmdPclkIzbMiF/V3ivCgXjQ7NZhqs90fbSWqwYTmeeDbzslC3l6ISxLYKrcQ
         V09MRc5h6sl7JiJVJUYE7NKndfvbS1+Babe5gtxUtAh+y1okSOCP9XT41XwmaYYUMdyB
         HNSA==
X-Forwarded-Encrypted: i=1; AL+hErHsIlS6ynWDN3V4UMi/n48eWTv1A/x36WBDSqvHo0TQHV11kOlx3J7Cr3XolwCv9xN+033SkSJG6Q==@kvack.org
X-Gm-Message-State: APuU4Z/tNHXMNsRNaWkwvEEHesHLE6YmcQ4vXZED31nxxlEL2q1XxPPr
	0amGbR7mfzV0G2bONNIRfnmfVyLHjVsRpERgL58/AkVx1rYAFU1Y0SF0B+USsvVISw==
X-Gm-Gg: AYBFou1n98kJHNdEUQsW7VujcRYiakbZnqJ+6UWwsQZIXrVkW8oQn/Krf8bVDpskSrf
	BvUS5B8qc7AoBxvuS6RkMkTBiZ3WokyrnJWRrjf9nNYF5hUKRSWJMtgn+r0pOG80myIS3zxZO/P
	jiWcY4+pz1d/KId2gJl6AZ+z0USrnynhh3h4oudHKU4817/deLMA+BG+1sU1MmCywQRttdlXDAn
	PNTY6PsDy1cbnDxJ5oQRa4toe8rJB+U0xun4Ggd995cxsOfEwV51OixJjBleMZhY0zMtnXtewFh
	tCgp2cSm4yj+ttQz3jjsE15tOjajbLHyxVSWYvr2Ybs3sPzGq31hYDz+nHhMw6iXZsGGiKYHLyL
	lzchR6ZG/b1kI6GJhbXSSeBFMKfUR0WN4E31Egb6U3xCeriQWlAwCUvcqKkLSUXyYf+YDsIIADe
	Pl5SpldrQoM+yqA790Owz2gU8f+EtAnTKjRxro7Vm0a6GSrPP1j8KAtRM6dYc4zaN/0nGlOWjge
	STbAujWe+he9myVu5FcjHgnYXf4+4sCH+DJIof9lgyt9ZwlB637xTo3YNpJb5MT56lVpu2P5bOR
	zpdB9VUuDV5YaVqnOlh38Q4sUfuFtCN3hd3rxAvG0jNBCsceqME4dVpwD4NsdgbpcWp2mPo2jPD
	thl0744KoWZlEY/HqUuQ=
X-Received: by 2002:a05:690c:e1ce:10b0:8b0:acc6:8e5c with SMTP id 00721157ae682-8b3417dd26fmr509307b3.9.1793908734656;
        Thu, 05 Nov 2026 11:58:54 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f76dba8sm3113237b3.13.2026.11.05.11.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:58:54 -0800 (PST)
Date: Thu, 5 Nov 2026 11:58:41 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Hugh Dickins <hughd@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
    Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
    Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
    Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
    Kiryl Shutsemau <kas@kernel.org>, Zach O'Keefe <zokeefe@google.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate
 in MADV_COLLAPSE
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
Message-ID: <1f69d159-4a59-535a-c24f-a26188698862@google.com>
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: wuahabdi4e9ixyzj85zabcjgqgcdnx9f
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24DC28000B
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793908735-510481
X-HE-Meta: U2FsdGVkX1+8EHjv30R5YD0DVH27UdTeGa3W6hdynvSUBW9tqFB+2Wb3DGIdDDgtIoRpPrnLlrF0Eg5idTlwcenZYJ320Nj9h0Gni1fYwInIafH9UtOwGAI5MXPw5iegMrxDeVkfQEuzPnqg0Sbxg28YdGs7f+32hdygB4nh8fTT8AaS36oqCOoP8OSHW9ZUK0GLalpQ18to8s3L95ne2BCPBTYRpPM2q+Wfu1WYy88UTV7OaJiTs8zP+AkG3DvtsUoribgGN6oO4s5UnYBlEkREjXQqBV1H/ym6SMwDK6nBLsHQKVDQxCa9ZYypbExaYDHzq1AxnOBQyqKDjbcJdJY7VEpM35Sw9ogVV4oq0FkFLK+L7pq4R/mZbLc+gT1u/6iiQkoI+Hh/I6QwPhh+ek1HHRJEMnsKUdKGcbszTBm7m4YmJ6Xy84zdgkubD6w7rZp3n/BAakNliVa+z2N8cUlBLHOSY0PsCieZjWquN3ysPHixunMkfgj1of7PPZx9F39/U07hqggtBHLJorpjAjFHCkSpYVcf+dWopXbGeY2cpVr5Xf5rb4G0NJ4Vfdn+ca31XQss9UbXpYdUvnu8hRJH6ZJmg1oj1NcliAlujQP5PX6SrC3a3tl38UBgY6pjfZOQH0i8kpHstgCHjf+p/XqvDBkQospqVA3HScr+7l4syDMQjniE4HflkHHAuYMKQMiDw5smp0ee7kBNVMvjHVS8a4nZ7ox6CnFIAZT/nWtHj1P1X7/ic+1JKmvE8crkzGKgBFGOp4c7+F7OmghNYl7T9bqsul/hDFewO4RHSvTNJSiHkdMnlPzm2k+yF98hdgDpROGCo4sWDz92PTvrM6n/8ur/09X1qXSQI38xFTQi+NiVpU9+pdLJ7fNXenBKti60SMJVm7PTDMrRVtzy2cEaZjs5BSnuNmw/tEqAh93tltCkS9fA0bnT3s2mqa87FPLksCPoYWRqDRe58Z6
 KWITUAdq
 G1rlgmyjeMjO2YmT3W2mh04/+MbB+Bu1vdbylQzMGobuRHTLIRd1IiIiO/Hl9K69Q6JGD6FDaTSyk+IGYWyPPmczJPbp4Ubdji/rToWN74eVY9aP7egidRdA48mH7kdl/syYrg08rqRYTgtal7Ci6O1ARBRaiKAnzLUzjra7aqVBNipP1GywfKI65iPpMf5gR+1B6eGYsE2/LkqcP645IeEsNfVDa6gY9AUQ4E/8zcATBeOMDVi0Pcu5zlRbiUCaRIZuXsCp1fTvw53Exl94I2xmYeV+s7qbY888tRUQyx5fVwdfnDxKRdzPoOAWEb88mx+uI7g/nfaXnEf5A4pZkmk+5u9eV7irFjOIlMmYg4LjMKiUi8Gty/CKC+605FOcpY+0MINjZlznjEi8HTGSITYF0idtZQmoLqSuHM6mqv8n5JR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 5 Nov 2026, David Hildenbrand (Arm) wrote:

> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> uptodate. For example, shmem fallocate() can put such folios into the
> page cache.
> 
> collapse_file() already refuses to proceed with folios that are not
> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
> such folios, leaving handling to the page faults.
> 
> Note that collapse_file() effectively clears shmem folios through
> shmem_get_folio(); let's keep this fix simple and simply let the page
> fault path deal with that.
> 
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Hugh Dickins <hughd@google.com>

Valuable catch, thanks. I was worried that "try_collapse_pte_mapped_thp"
implies there's already a PTE mapping the non-uptodate folio, which
would already be wrong. But we've been a little too free with the
SCAN_PTE_MAPPED_HUGEPAGE result code, so there's no such implication
(and even if there had been a good PTE, I doubt there's enough locking
to stop racing fallocates putting a non-uptodate folio there meanwhile).

I was going to quibble with the Fixes, thinking the problem was there
earlier: but no, I agree with you, that's when install_pmd came in.

> ---
> Once reviewed, I will pick this up in a timely manner.
> ---
>  mm/khugepaged.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8d9f05a39afb3..db135b3c44ef1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1900,6 +1900,12 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>  		goto drop_folio;
>  	}
>  
> +	/* Leave any uninitialized folios to the page fault path. */
> +	if (!folio_test_uptodate(folio)) {
> +		result = SCAN_FAIL;
> +		goto drop_folio;
> +	}
> +
>  	result = find_pmd_or_thp_or_none(mm, haddr, &pmd);
>  	switch (result) {
>  	case SCAN_SUCCEED:
> 
> ---
> 
> base-commit: f44fd601f72e09e44c667b9234c9cd469856679c
> 
> change-id: 20261105-set_huge_pmd_uptodate-9b9820307f30
> 
> --
> 
> Cheers,
> 
> David

