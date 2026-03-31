Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3955AFF60FA
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A0F6B0095; Tue, 31 Mar 2026 05:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3876B0096; Tue, 31 Mar 2026 05:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892D46B0098; Tue, 31 Mar 2026 05:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 77C786B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:35:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3080D5B9F1
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:35:40 +0000 (UTC)
X-FDA: 84605850840.20.7686881
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id EFD01C0009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:35:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LetgPKrW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sHDoojrS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LetgPKrW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sHDoojrS;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8RLMUhAjTtNtaUC2s2ScncUXf/vyBdpF+viQUvF/H1I=;
	b=CBSQJZjkiBpO4/506cPqf0S+dnMC0fe3BcGmHhQSOkoSXsWP92JlQLGSedc8rNJK65uQPW
	3ifskhsdUrkIA1XYHtHnx166GCNnqCZ53yuJ20VN6dGpldwe9okSZqOs/V4DNHnxTcetII
	yW+ifnvc6D4yFxa2T6hphtPCvEH8gWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949738; a=rsa-sha256;
	cv=none;
	b=EriUWfzhUXICy3b22+XbcKz3Lqiq85juWKptHFE0PJv39kqq1fnRBmJCDRcjc9959CD1ea
	+4QGcGmakjouWVmVNyiU5pLgZRSTnHKJLrQlaSqueTZEeUnOFw4W2H8Srv5RusUiKFeQ6K
	/xdMXZwbVun9XmgM0RndAjzKR6Qhp7I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LetgPKrW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sHDoojrS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LetgPKrW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sHDoojrS;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6C0055BEB6;
	Tue, 31 Mar 2026 09:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774949736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8RLMUhAjTtNtaUC2s2ScncUXf/vyBdpF+viQUvF/H1I=;
	b=LetgPKrWBjb6gcmwm17nwHwvSbdMlgC5PkRp0uh8mnZ9huntuqH2aPwrEDEdrHsANaB721
	WUFjTjaKmBBdXheZSDu3sgfwuW6/p/XxXg98wEkBv/OKiwjkbh84Icjt02l3RIBksKMAe8
	BGCPMdkKaLFE0hc1CmW+rzYaOdPTiCU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774949736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8RLMUhAjTtNtaUC2s2ScncUXf/vyBdpF+viQUvF/H1I=;
	b=sHDoojrSG75TQ9qCOpcuv6UY3hhRLD06bynyEgWH96ZnnuO6N3LoOip6Xy+GMSQtAI8E0v
	Mfr4NFJcxNb6fOAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774949736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8RLMUhAjTtNtaUC2s2ScncUXf/vyBdpF+viQUvF/H1I=;
	b=LetgPKrWBjb6gcmwm17nwHwvSbdMlgC5PkRp0uh8mnZ9huntuqH2aPwrEDEdrHsANaB721
	WUFjTjaKmBBdXheZSDu3sgfwuW6/p/XxXg98wEkBv/OKiwjkbh84Icjt02l3RIBksKMAe8
	BGCPMdkKaLFE0hc1CmW+rzYaOdPTiCU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774949736;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8RLMUhAjTtNtaUC2s2ScncUXf/vyBdpF+viQUvF/H1I=;
	b=sHDoojrSG75TQ9qCOpcuv6UY3hhRLD06bynyEgWH96ZnnuO6N3LoOip6Xy+GMSQtAI8E0v
	Mfr4NFJcxNb6fOAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7FD94A0A2;
	Tue, 31 Mar 2026 09:35:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ARChJWeVy2lfYAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 31 Mar 2026 09:35:35 +0000
Date: Tue, 31 Mar 2026 10:35:33 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/selftests: add merge test for partial
 msealed range
Message-ID: <ne3bppkwlk2srskam72k56jq5q63dhnvk67vzztciw2uxxcyr6@gki5bfznhqxa>
References: <20260331073627.50010-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331073627.50010-1-ljs@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: hz888sisowr5x1hadixhrkq5wpa9yu8t
X-Rspamd-Queue-Id: EFD01C0009
X-Rspam-User: 
X-HE-Tag: 1774949737-826425
X-HE-Meta: U2FsdGVkX18107h34ng4pYi5xnQghJ32alWlndSPCHsIoUeiys1bYsdJhj6txd1g+kFQ1UvVwAQNMk3G0karMcrDv37dPw9z3BVxaiEInro1Amm0T4BMYrBh+RC6tRasa1px+c1mj+rbB1CcuPAHStnlJJOUCyb/EQeFs7PBSm96ZrNaKiDbLtHzJxF9w10s/3EfepFRQh+BFpqzao19p93Evg6XPLVKqzz3NweUWtoAlh5DkdvxcMmEEoJqZNibkN1AMPCvsZMaykwqxAzlMdDC9oIRJvat3n0cLvTncZbQm5xgunX0kMgiwRPGc1JLMqRijVMir05jKLONuF20KFDX3+FNMNJfzah7HixoickXyXRCqKt+5ohkG7zFta5pKhdWeYoITcRP51meNbvSQ8TnBEvaJVmkqpRaDOievoDDamhu7UJaR3NMkjNb+UqKrsTf4oxRuwcCND4Wy3s8QxREZ7PNOeMhS47Dm7Xfu/dWtFgUpMGsaz9/p6x0BprB8fIN4Qq+pFUQTwYpfaklBFjEZRIEVgAPvRNQvCVd6p1jatE8pOtMJE6liwNYUDr2t9xsmixnyLNkuxVSqgKay/HJBTKDtpfUCMGi6AayhDGAz1DeB6zS5qnvIpJbCX6tmr1gMhh7elWLzwO2Z61++j3L0gG7FU+ASWMAWif6lieKRCBs01D+tc04UVr9d6WsPOQG+34Z4D783td+1uIQLJwRb/abtY1UWBjWoyyq+acMFLejSC0tJ1+uHrIf1cv1xGuOON4wE6N4CPj0kKWB/G9J0vwBOPhvK9N/4LA6RQ2P+j+alazM0ka+IGnJY+/9CB6f9AOp4S1+hGTwBnJcvmpmU0n2Q4FOyFyJF2tVscoGP7daNgQfKL1JZcscOb1jeJQKqJ2Zw+D2D0cLlLhunWRi21uu62+dsLJ0sRHreyAJm1KOO4V+nTj43TfRcVgYzlxa4U5/3AF5vWLhxCn
 zlGYrnHg
 q7vS9SrUit2ltWKsmv8CdZSAHXFGiVHlLAds8sA8HzodlTMde8XSsfW6zQMxqsW/OxcZPJ+GP+UygLrXJEqTj+EoU4v9hyXdTB5Ft+XWbgss1ENMAQO14JUnrBo06UWnCD/DOGrCWbXBTe0uw+cogDEMeBkq0qIUsiE/JB4JAqDtJ/i5cK0y0VvFht9bmz+LzcLKu7lVkjMqvF98H9jQQYXIzqcvQ5zIt7MSE/ycNGQgyq5P0X0kx3ZqYy6bcajng5SqaBPVHA88lELt400HVNNfAWsw5vjraNm0V9AutvNz/XQ40hgVIDw4vgPBROwsFlJA70Oy0BtHdQ003w0lYlR2K5Hsgik/B6lENPmZTPhtPcUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 08:36:27AM +0100, Lorenzo Stoakes (Oracle) wrote:
> Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
> an issue in the loop which iterates through VMAs applying mseal, which was
> triggered by mseal()'ing a range of VMAs where the second was mseal()'d and
> the first mergeable with it, once mseal()'d.
> 
> Add a regression test to assert that this behaviour is correct. We place it
> in the merge selftests as this is strictly an issue with merging (via a
> vma_modify() invocation).
> 
> It also assert that mseal()'d ranges are correctly merged as you'd expect.
> 
> The test is implemented such that it is skipped if mseal() is not
> available on the system.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
> v2:
> * Added tools/ based header so __NR_mseal should always be available.
> * However, for completeness, also check to see if defined, and assume ENOSYS if
>   not.
> * Thanks to Mike for reporting issues in his build on this test!
> 
> v1:
> https://lore.kernel.org/all/20260330135011.107036-1-ljs@kernel.org/
> 
>  tools/testing/selftests/mm/merge.c | 89 ++++++++++++++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
> index 10b686102b79..f73803b3679a 100644
> --- a/tools/testing/selftests/mm/merge.c
> +++ b/tools/testing/selftests/mm/merge.c
> @@ -2,6 +2,7 @@
> 
>  #define _GNU_SOURCE
>  #include "kselftest_harness.h"
> +#include <asm-generic/unistd.h>
>  #include <linux/prctl.h>
>  #include <fcntl.h>
>  #include <stdio.h>
> @@ -48,6 +49,19 @@ static pid_t do_fork(struct procmap_fd *procmap)
>  	return 0;
>  }
> 
> +#ifdef __NR_mseal
> +static int sys_mseal(void *ptr, size_t len, unsigned long flags)
> +{
> +	return syscall(__NR_mseal, (unsigned long)ptr, len, flags);
> +}
> +#else
> +static int sys_mseal(void *ptr, size_t len, unsigned long flags)
> +{
> +	errno = ENOSYS;
> +	return -1;
> +}
> +#endif
> +
>  FIXTURE_SETUP(merge)
>  {
>  	self->page_size = psize();
> @@ -1217,6 +1231,81 @@ TEST_F(merge, mremap_correct_placed_faulted)
>  	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
>  }
> 
> +TEST_F(merge, merge_vmas_with_mseal)
> +{
> +	unsigned int page_size = self->page_size;
> +	struct procmap_fd *procmap = &self->procmap;
> +	char *ptr, *ptr2, *ptr3;
> +	/* We need our own as cannot munmap() once sealed. */
> +	char *carveout;
> +
> +	/* Invalid mseal() call to see if implemented. */
> +	ASSERT_EQ(sys_mseal(NULL, 0, ~0UL), -1);
> +	if (errno == ENOSYS)
> +		SKIP(return, "mseal not supported, skipping.");
> +
> +	/* Map carveout. */
> +	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
> +			MAP_PRIVATE | MAP_ANON, -1, 0);

I think it would be simpler if we did 5 pages (1 for each VMA, plus the two guard VMAs around it).

> +	ASSERT_NE(carveout, MAP_FAILED);
> +
> +	/*
> +	 * Map 3 separate VMAs:
> +	 *
> +	 * |-----------|-----------|-----------|
> +	 * |    RW     |    RWE    |    RO     |
> +	 * |-----------|-----------|-----------|
> +	 *      ptr         ptr2        ptr3
> +	 */

And now carveout += page_size; would leave us with

mmap(&carveout[0 * page_size])
mmap(&carveout[1 * page_size])
mmap(&carveout[2 * page_size])

and we don't need to deal with the arbitrary 5 pages below, which looks a good bit nicer.

> +	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	ASSERT_NE(ptr, MAP_FAILED);
> +	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
> +		    PROT_READ | PROT_WRITE | PROT_EXEC,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	ASSERT_NE(ptr2, MAP_FAILED);
> +	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	ASSERT_NE(ptr3, MAP_FAILED);
> +
> +	/*
> +	 * mseal the second VMA:
> +	 *
> +	 * |-----------|-----------|-----------|
> +	 * |    RW     |    RWES   |    RO     |
> +	 * |-----------|-----------|-----------|
> +	 *      ptr         ptr2        ptr3
> +	 */
> +	ASSERT_EQ(sys_mseal(ptr2, 5 * page_size, 0), 0);
> +
> +	/* Make first VMA mergeable upon mseal. */
> +	ASSERT_EQ(mprotect(ptr, 5 * page_size,
> +			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
> +	/*
> +	 * At this point we have:
> +	 *
> +	 * |-----------|-----------|-----------|
> +	 * |    RWE    |    RWES   |    RO     |
> +	 * |-----------|-----------|-----------|
> +	 *      ptr         ptr2        ptr3
> +	 *
> +	 * Now mseal all of the VMAs.
> +	 */
> +	ASSERT_EQ(sys_mseal(ptr, 15 * page_size, 0), 0);
> +
> +	/*
> +	 * We should end up with:
> +	 *
> +	 * |-----------------------|-----------|
> +	 * |          RWES         |    ROS    |
> +	 * |-----------------------|-----------|
> +	 *            ptr               ptr3
> +	 */
> +	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
> +	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
> +	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
> +}

Apart from these nits, the test LGTM

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

