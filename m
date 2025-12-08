Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CFFD1CDC6
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 02:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB836B0005; Sun,  7 Dec 2025 21:32:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B516B0007; Sun,  7 Dec 2025 21:32:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989C66B0008; Sun,  7 Dec 2025 21:32:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85A966B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 21:32:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 271548A7E8
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:32:45 +0000 (UTC)
X-FDA: 84194730690.06.4D859F3
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3AD26C000B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 02:32:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B3NDuUwI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765161163; a=rsa-sha256;
	cv=none;
	b=Ifz1FwYFA1eI7+AR38pEPpEESHOcPNIZd/lCgOTmrzHdHPxqzwX2xSqPpXg3CbnmAfshQR
	ybt0ZIkHrGx+pncgM8zIdIvEllQ9QkoP02TBAoCDM7LDWfKQ8qWah1+KceeMzy6EfOrWNL
	X1oFdFktkG5FAsdPlIfNeoqILxgo2Pk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B3NDuUwI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765161163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYtF8RDRQ6VRaXKUfw5cvR+LupuhtEwbZq6O0/1AaHc=;
	b=7MM+sVz7pCK9sy2s1x6R1Qawi4OjjsujefvId1hb9Ook3DQkeDTpTEpNM4FX1Xn8nWmtzA
	19+gORBxJhKoN9qp6vGEHROKGc591AwxgsQrT0s3+lmvhAeG1BMoJYCcFrcrW5cPgoPgcP
	ovFRd8JRXBF9vplRPNBGJOAuhUFfX4o=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b9387df58cso6065069b3a.3
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 18:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765161162; x=1765765962; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYtF8RDRQ6VRaXKUfw5cvR+LupuhtEwbZq6O0/1AaHc=;
        b=B3NDuUwIxza1qQrb0Dc/rpITCdDO6pfd0JaXfT7wo6Ymm2Pqkzmsn9i/tjO8jdtqQV
         YSQ9NSLYZbWc/tAqLoC/rJ2c5hLPGx3SX6bl/JVZ2oGBcZvCiwAIjAo8XK8mpM/XZTpc
         qawoZ7GxP+dM0a8gLBD7eiF+YGo+inql7rAVWd72MUYX9XovGihbgFzmb3jv4O4eDw0n
         P9GSKzHVbdGYDFk5V8j9WVU+P2Gc5YzyBu1hdDAbc3APyFwT7HegLITBPl48gYhg5qoW
         t0thsw3SPoAQcHCuGJzvFcXH8VeOEicyFGk4mWO6W3NVJiuSGoYKrWBWMul1Jw7Ggaxt
         f3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765161162; x=1765765962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OYtF8RDRQ6VRaXKUfw5cvR+LupuhtEwbZq6O0/1AaHc=;
        b=q3s9urZjYd8bVPzZxVGfOIuw+mygIB+PQ348u5Oau8EYNPRJ3pmzgkQQSQ0M5sCF/f
         SPp6bcBVS973NZccvQYWLwYzinrbsyEQEZbK0Woq58dNaDCIsetV4NX12Wuwq9YMT6vD
         h+Tk1Ha7dggmmcfZpNeklya7CiXzoNJbubYRcwu3p4Pxm/fVQWUNUCCHqJLMD2/BYUow
         FjpVwdZ9e4lRRFHlrnTSsyh3SloEs6gfpnQxLnxF2NyMS4e77ClIyC/pmFjbCPEh8U2j
         kxwTV9zkfE++7j9cZRXR0P+N0QYM1WCuy6G1ISiu5sGU0uwCAYvcImGY+4rsVtNXNhQV
         W2oQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLybSiDslv1rUtLieThFlMNM0ypAvTHMlSqUHb3f+GWepa77SQvQCOXRrzp4UPwJMfVXBM5IQmiA==@kvack.org
X-Gm-Message-State: AOJu0Yw8kjAESEa2QpM8wIU99xSq5LJgJD5TW1S2yGjd1882OqxiMZyb
	3qYN6jpVGto+6A+Z0El4un6gF3XhUKawLZwl3Bd9rJRViu79fte171ai
X-Gm-Gg: ASbGnctNuKgvXAuLjKo9d2dVzFFnPT1wsky0U/EOdC6ZAJyj0kXhg0BiOpbGAqfuyfL
	47JuJPUuMgqYfWwBGAQWRv4U7U5TgYESO4i1Vt3NGPRF1CJzb1KZSfB2cpTOc/qKnpKbZf2jQct
	K973Y0wFUawsdpFqDJq5IM9gqI+oBjxBAn4SFd58VPEf98eBP8Tpsqnal4v1ScEeR1Hr/tlOI0j
	PTPD0CQlKhlH9KNu/Ho4O/LgAATIL9cTWouuSEKF5f/Aa2Sjj+VStfECGv0MbdCik24vcCmJ09B
	K37stl0+Uz0gleZcFEdiDAfgiJ6lugKmagXhyQZbenOq0spEar4h8qWL2E4ntCsNL5ioGA7kGcn
	g5f05jZzqALndPE6V7IwzvCQOShYC3INrbcNfG5LcxCQWm3fNISO/2/vqK+BzG6Bz9GVikhU=
X-Google-Smtp-Source: AGHT+IFD9CuAvyh/LldTgp7Zr7VitBVZghYnCn8DknhWR1P71K3h0yhqlnfFLuZIhyuQUfCBStR0eg==
X-Received: by 2002:a05:6a00:1883:b0:7ab:f72e:8f9b with SMTP id d2e1a72fcca58-7e8c3a0ce46mr6066644b3a.25.1765161161990;
        Sun, 07 Dec 2025 18:32:41 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([2403:2c80:6::3075])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7e2af658d84sm11155165b3a.60.2025.12.07.18.32.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 Dec 2025 18:32:41 -0800 (PST)
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
Date: Mon,  8 Dec 2025 10:32:31 +0800
Message-ID: <20251208023231.1257-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251205213558.2980480-2-david@kernel.org>
References: <20251205213558.2980480-2-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AD26C000B
X-Stat-Signature: xbmje7kpeefbymhigrsxi5m7ambdaow3
X-Rspam-User: 
X-HE-Tag: 1765161163-319009
X-HE-Meta: U2FsdGVkX1+n+Q8BpemXyrxZK6uQ5gfijmzm8XPurw2jlUvwgkte8dwx/DtBJB5CL64gOV9mv3lM4Pf/kMPLh4Nm9tlpymsubPIurhaeDRQ7puOnGxDd4M3ECLAg02tOWCX8wksZKmM8wTv6tE8xwhLfI3EULxCc8UulZqwpdKKL1JEW9aUqnSnwxv74diCRjFnEtdi5fBaxVG/VCBBYq++YsOLZ2TqgXacpkc94Pk1wkbbhE/jnMpGsmCVFPyyr3KB05TrVU5V3xyAexSe+So9nuy0cwQ9jtPk0mjfCOw9WjrOwquhUsG3PqZ4rs9ariY9QCmraRnOFVYdcevJpPi2ycB4s9B8gVUIbBfiltqQi50fCi8wnoQufGmexVhrOLAkTA6LO/9is5v+j6a73sAUnRDi16kcPzTs5JFEjX590YfxDibEFBfpwd14ubqGscX6qSQJ8B3N8E4yppKUYbUUytPucWX3TjYW6PQvTzKo2Reg9eqInW198lUc6tksEneUkgRuJl5agUHM73DUXzq0Mgb4wEGnra7pwg9GTRJsUtUSekhYa3GY0dc2zpShwJpOJVtbFdVwd46ZOVqBMc8mNGqSb3OEXMBSVVi4zZWsD0jOnXytKA+1YLgU7CwZLxYjxnXbtSbpT3Zt27vpuQjMdxspmUSQfBXMENX6THq9QYOUDLkGGGhBnufDKysQHja7ju+U3CNYcAGhHz6KrMaXUumTZla+LZ7OUihDmXT+fWi1w6P1M+DBWhQEw/eCurwu7MwsVRIgfI3RuqSE10GIPCz3DPB5q2L01qQWkeeOXaxQjRuEFKNDlVFWEpwjIYFfH1KCAw29iRTqQJ6juAR4VYTSPPsoGU/gOlW7bDQfgjcD6HCyzxt+V0zPg22+T3UJPYKSBfSPZQ67EnSTVkAXDEI9DnANvu4ocBiL63ckgcYUX8xvEPKNnmQXTKptlEFw6Sx2zBLFt7PamlMI
 qGC/RKC8
 ICRSVoiS75KFmPponDb/37aKl+iQWjU4yk109l6YueSOBz9FdD6k26zE5bm74nj1sFRxm9fayacp10SlAmJqavlSnKm28ChTgAyeA/MnY4R1hHbmYQ1Wz++X4oGlYRedNxvTEoz368JBVn6dvn/VJUVf3Cl/E1bG3SET+FbAqF4MuIaKIbUFw+Z1JMtQo2grJfHLkilREgui17nKj4YWy2gr3hJWMbYvSHIebtXsBkochHjR4/8hG6EHiVw1kKunZaigQ7NwgHtNNb/nrSafQ+1hltbfMf/UXEcVlhCK1w1QcBw0oHvhjKdQHrWV3wmVCIt+BMha23QX78bETHFgzQvmNGH5qWusNGh2Oxkh9YZo5iJWtCsuEDdqjmqbbpLcmCwcp4qJHR4adF/UpJxXwYSF9cdG5MxV6csZMft/grRuQXcfbqIiNg/kEgFUExw2+JUOohCEeh/LuYwt39CBxnmgtp2lqSb5wfhaxcNYWKMS8JSvHRvaBjtHNcpbN3yWUtv9m06QTGjFHptJUJmXvge98MP2Qp9JtqmB0Gb/d7KqvXxWc+vUaPv4qjBUIQ0+5Qv4uY2v8D8+cZwosjTruiee1WrrECzya/b1t
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

Tested on x86 with two independent processes sharing a 1GiB hugetlbfs file
(aligned a 1GiB boundary).

Before the fix, even though PMD sharing worked (pt_share_count=1),
hugetlb_pmd_shared() returned false because page_count() was still 1,
causing smaps to report it as "Private" and pagemap to set it
PM_MMAP_EXCLUSIVE incorrectly :(

After the fix, hugetlb_pmd_shared() correctly detects the sharing, smaps
reports it as "Shared", and PM_MMAP_EXCLUSIVE is cleared ;)

Tested-by: Lance Yang <lance.yang@linux.dev>

Cheers!

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

