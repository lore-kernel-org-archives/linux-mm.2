Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39832606A888
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B+Sj1rnL
Received: by kanga.kvack.org (Postfix)
	id 1BE296B063F; Fri, 13 Nov 2026 03:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147DC6B0641; Fri, 13 Nov 2026 03:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010196B0642; Fri, 13 Nov 2026 03:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE9DB6B063F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:59:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F774A0105
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:59:02 +0000 (UTC)
X-FDA: 85429496124.11.C287F39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7424A140003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:59:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+Sj1rnL;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794560340;
	b=3NQE94YnHCGa0mhq3RsP3HnWKIct3IuYZ0+qm2Uu3eOrCIBBz4P8yzKeqv1s10HTy/SEnW
	EXsgEQXxocgWcOUaHeMy3NQLc5vNrGuKrxwmqt6DPwbMm8FH1Kxq2jCySGlG0hGsDS6UM1
	/7Xl4v+CKxcL9qACgM0VX5kcW4srB7Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+Sj1rnL;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794560340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YF7NHY1fVlGveMHNsJnnjtGJ3+1XgRTTULcBOP2fUbI=;
	b=FcC6aFeDbFYK0EO0RKeIlC4jYb/EbDyK3rdePCACtUU7O9yeK3nav4556LJU4tnAEcvoFR
	YeJG+Uo2gKWczyRaufahmYv7NMboCL+VF4ZLrimLc3QtB4t3vhoN452z/mEl3v/FI3rAYp
	TNS7dCi0eNGlmajYX0dxIbE0IiW5btk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA6D7408F9;
	Fri, 13 Nov 2026 08:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA721F000C4;
	Fri, 13 Nov 2026 08:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794560339;
	bh=YF7NHY1fVlGveMHNsJnnjtGJ3+1XgRTTULcBOP2fUbI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B+Sj1rnLIABT2rcMAHDb8ZnEfd0jTex4c1qrfj0CSRk0gqZnxgNlbeKj4GqmwtC9I
	 o8Xe/mfzfwZupSsAirIa5j4T99BWCeooiaGkcPxrha+PA2hMxNFQo1B5qgiclciRvJ
	 H/0QS47NbbvNelQKUZaLYxLikkesF1eucTGQ3XHglrVcE3sGxrTRW1h3QpwV9v3R4O
	 YauwalFMafdrHEV4zgip1oDQUDuo7PK7wcQaXMuie0pD5uDbIAM5svIaPto7fRy0mo
	 a6tlA/n7GVSd3t8dEWO4ZLrpdgPAAEY7SBncyX5yBNeewHKMKVczi4UYxnM0JXkXp/
	 ptXy6a57Iw/5w==
Message-ID: <01b19c1e-b87d-4996-acaa-cd5103f30edb@kernel.org>
Date: Fri, 13 Nov 2026 09:58:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jann Horn <jannh@google.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>,
 stable@vger.kernel.org
References: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7q1tfhdmmfc9cu8eiwmdnpwcecncqtio
X-Rspamd-Queue-Id: 7424A140003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794560340-861836
X-HE-Meta: U2FsdGVkX19HC/UvGNWDMHqJE7aHAw1qqIv4KJXeSgu5mzCbKcvVuhy3rm215ZGAc07jTfEjZ7rJROhWDhnc/ePyortn4AcQohws3B8LiGWaqLrzFD/pWA06dKnzzG8iJfEnyvRk56LCtLBvDvgA9UfFobAt1J36ZKBYunQs0SM3Grxl2RAfpYQGGscXUaCq/Uz4bHOd8m0fpRCLWRehh6w21VdiiWWQAryvEsm2jbUg1yTFXph2QcE9zc5FKjn6E4EfFVw0UNp+GRFck1iJ9kXGRyfy8MM9QbT+HD7fUAF+gThFU4jpm2z9Lm3ruXPKUbxYct6Bns1k+SNm4YwZlslto8bUojCM5laxgSsME267aOK5MekU711vDmX5EDjVvNECJ4GyHKG67sfv94vafbnoAFim2MdL6STcCP0k+ik6dOQQBrUplRkeYY2NhcC6EwEMvyEQ8dm1MAhy+tUS1huUntKnTfGRqwcXYG8gex8RHPSLO1bJidru8+RSCRjVpLgYI8ztm9mAfnJomn87/lVyFldmi6uop325BvmsM+GUCOJPhy94CRnfh6U+yAUVYRrKnvzUVSe7+h2wuG3jrd/zIePvGTo4RBM3RTF4vZOkhjjoxbpJqUiQfuIAsa58o8Xr+nkvKHNS1v3YDdMp4Bi8afwLpuO2PtbKA14RWE4TF10liFzuAl/83+ccPlUfKymPZQLHHxmc+SgOsZ76TkkcWBMKdOGpZQyntWKanITUKHVT/4QePv3t2JuPPYRBpFIwnJvuSyGFOMSav8sAiGkZqkvQTGGEWKEOskpAlzlAXW7yyYmYtS1uMU42xWfN8JzqTe6Bq3tpt1dwX2aTk0rUD/yyX6VEpglLlt5uYshE/YOE8cVxsADHUkB7SLlW/GpaAMdaETUTgkqurpwYbt64ilLOwo95MJ2q+o3+sEzth3Ce1xLdkNubKXiDyf8bfcnA/2XmVTacv+fzV+/
 cXLfDGIg
 6LK8IKeGgo3muBoNih785KVM/wl5nL4QXUl0alyXBzHfxBQjtdd/saLK102yPQ1vdGhrXfOGU2HIJSYSIX+NXBH01YdJ9tdMPelSMOU662Y3Wz0hHBJvYE5KEZjxLw2InJFtZToSjNFs6IpOKI4I7Ttnw1s3UVwrmXPw8Lb5MywkdBNFW/udolZGLUteag+D2SSCR6voMHCibglHNUPdhvaaFkGOYt42Io/d5jKSP+a/O841H9amT60k10OPpjPkfNhYQdwTaXildEZwKyPuW1yMGs0E1amZ6zUe3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 18:38, Lorenzo Stoakes (ARM) wrote:
> In order to establish guard regions, guard markers are installed in the
> page tables of a mapped VMA.
> 
> However, problems arise when one tries to combine this with registering a
> VMA for userfaultfd, as such operations may themselves need to install page
> table markers such as uffd-wp.
> 
> When this installation is attempted the guard marker prevents these markers
> being applied, which can lead to unexpected results (especially if the
> guard regions are later removed.)
> 
> This is especially problematic because guard region installation causes the
> regions to be zapped first, meaning that the removal of userfaultfd-tracked
> ranges will not be logged in this case.
> 
> Therefore, disallow this.
> 
> This makes sense as conceptually, guard regions mark a part of a VMA as
> effectively unmapped at the page table level, and removing the markers is
> like mapping the VMA again, over which operation uffd markers would in any
> case be lost.
> 
> Only check for this on installation, as a VMA can be registered for
> userfaultfd after guard regions are established.
> 
> In this case, the guard regions cannot have new markers installed, and no
> faults can occur in the guard regions, until they are removed, at which
> point everything should function normally.

So IIUC this means the other order of operations (first guard regions, then
uffd) already prevents the two co-existing. Makes sense to prevent the same
in the order of uffd and then guard regions then.

> A survey of open source users indicates nobody is relying on installing
> guard regions in uffd-armed VMAs. Software including glibc, android,
> tcmalloc and CRIU were checked.
> 
> Fix the selftest to reflect the change.
> 
> Fixes: 662df3e5c376 ("mm: madvise: implement lightweight guard page mechanism")
> Reported-by: Tal Zussman <tz2294@columbia.edu>
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu/
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu/
> Closes: https://lore.kernel.org/all/20261111-uffd-state-fixes-v1-11-00713d368976@columbia.edu/
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/madvise.c                               |  4 ++++
>  tools/testing/selftests/mm/guard-regions.c | 12 ++++++++----
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014..268731e90f12 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1156,6 +1156,10 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
>  	if (!is_valid_guard_vma(vma, /* allow_locked = */false))
>  		return -EINVAL;
>  
> +	/* Guard markers are incompatible with UFFD markers. */
> +	if (userfaultfd_armed(vma))
> +		return -EINVAL;
> +
>  	/*
>  	 * Set atomically under read lock. All pertinent readers will need to
>  	 * acquire an mmap/VMA write lock to read it. All remaining readers may
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 02f69244f9a4..97da54dcf3a4 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -1476,7 +1476,7 @@ TEST_F(guard_regions, cold_pageout)
>  	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
>  }
>  
> -/* Ensure that guard pages do not break userfaultd. */
> +/* Ensure that guard regions cannot be installed in uffd-armed VMAs. */
>  TEST_F(guard_regions, uffd)
>  {
>  	const unsigned long page_size = self->page_size;
> @@ -1526,10 +1526,15 @@ TEST_F(guard_regions, uffd)
>  	reg.mode = UFFDIO_REGISTER_MODE_MISSING;
>  	ASSERT_EQ(ioctl(uffd, UFFDIO_REGISTER, &reg), 0);
>  
> -	/* Guard the range. This should not trigger the uffd. */
> +	/* Now try to guard, should fail with EINVAL. */
> +	ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_INSTALL), -1);
> +	ASSERT_EQ(errno, EINVAL);
> +
> +	/* Once unregistered, we should be able to guard the range. */
> +	ASSERT_EQ(ioctl(uffd, UFFDIO_UNREGISTER, &range), 0);
>  	ASSERT_EQ(madvise(ptr, 10 * page_size, MADV_GUARD_INSTALL), 0);
>  
> -	/* The guarding should behave as usual with no uffd intervention. */
> +	/* The guarding should behave as usual. */
>  	for (i = 0; i < 10; i++) {
>  		char *curr = &ptr[i * page_size];
>  
> @@ -1537,7 +1542,6 @@ TEST_F(guard_regions, uffd)
>  	}
>  
>  	/* Cleanup. */
> -	ASSERT_EQ(ioctl(uffd, UFFDIO_UNREGISTER, &range), 0);
>  	close(uffd);
>  	ASSERT_EQ(munmap(ptr, 10 * page_size), 0);
>  }
> 
> ---
> base-commit: 4318887a3efa4c53d6f083ccfd7105b809a3ac65
> change-id: 20261112-disallow-uffd-guard-install-a5294129ad7b
> 
> Cheers,


