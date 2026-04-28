Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BDADFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3636B008A; Tue, 28 Apr 2026 10:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54466B008C; Tue, 28 Apr 2026 10:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42E56B0092; Tue, 28 Apr 2026 10:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF6596B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:32:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C99AA1601FA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:32:48 +0000 (UTC)
X-FDA: 84708206016.22.5AB2B1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CDCD22000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:32:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i/xQuy7G";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777386767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DezCzpycfnrwx6GVgPPvwbfy3E5UgulSA3keo2V1zLI=;
	b=hLfxPu0MZZf2mHoA6waOVpt46maJsi1I7H938O24R39XEOPu3kfOUCes1oYgxLH2cRTwmF
	3cUPfb55ZQR08r4RVdZHCEMfbODUFXBbBLE69ZnfVl0RMGKTgOmK2uEofr3llrGLU5EZ/o
	STuayIk+03BQPH+SgRGxmk4rYSspz+E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="i/xQuy7G";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777386767; a=rsa-sha256;
	cv=none;
	b=zorYVvhqpc+S/YY0wjgp0Ecd4pM7TPodDX9UxjwbAf14JmbmvUx8Y8esmzE+EBBHxK9NHS
	RTXhmkiVAAkY20jj3xW9zfTlND3/qGTf+R9il0412OyMiQTAKov9eF73SCAl3vWniUib9o
	iEhzDWtgKYsWaq7I2mwPpF92Sdtr42Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2AB042B04;
	Tue, 28 Apr 2026 14:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1879C2BCB5;
	Tue, 28 Apr 2026 14:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777386765;
	bh=OHEK/kEtPQzApv+jcGVsp7S0wEC3laGy8Z9NSXLdV/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i/xQuy7G/IWRp/2joV3S5/rhJ/oAsWEdR3rS4YRVDvEtO/bg/E3UBd8Atd4UeB+k9
	 hn8mCMDzdTAzRvykGy8lNJOvOFv4HzuLiDBcPasKcZ3mD2Ex6SZW0ibGC1sgN/vXfO
	 w5lArH4FNU/RdwVjbE6QWtGFkIWF5stBfQZyUF44++vO9LCryxIlBx+4va/DtWBObL
	 OEZp5BloPLPxdekNzjoAzWW0cXC8sM53KOiOBCA3CXfOHPHtA1Bjlczh/hrSBuwdJL
	 djw5HhPa+TzYPoAmYhs4rIWoA4+JHgzAwDg1fwgR4ddXkGe6IAMW48ZBDPyoWfGJVq
	 HsaAYOsXy2dUQ==
Date: Tue, 28 Apr 2026 16:32:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 13/53] selftests/mm: khugepaged: use ksefltest
 framework
Message-ID: <afDFBB8CqNx2mWAL@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-14-rppt@kernel.org>
 <231d0f73-ed99-4c7c-879d-3a2223945b21@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <231d0f73-ed99-4c7c-879d-3a2223945b21@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDCD22000E
X-Stat-Signature: w4giodgzeta8gsg367s4rtjq5bzrynai
X-HE-Tag: 1777386766-68980
X-HE-Meta: U2FsdGVkX18aW88MvZ29/MtD6QJ+uxGccruhnwaHoeNkGo7O0uI3ewf4ukBW8USsyIIhDIIsHZapTHXRMK8PtoDMTrEvgYq4ySisRqny2G3cq4/z7566i2s9IxOIlGwZyDODGx4Ps0w+wSLAY7DC9vvLmljrRCvkbHpCT7DLiHHpWU+AnMgGtvZMm+XeP3fpr2f1WD27dlk8nkawDF6untJOh872ouF+PcjRHYk/vIYuvwfecZvJRLcuAQXDdgKKmdQ20s1CgNpj/FprjdyYYKdvDD03EDBlcVl02mhGNhwEYdTudjuwAIr63+mmBAGpIS6T3UpyUX3iJGQVc3em6alPPSarmLl4jrVVTJrz2y9NfsNtM0YQb4KnB/xYvNo7mco91QuRvxoSQJSIX1OakKM6DgVdy2jtwgl7/t29V6eLWrNkv3tBz51saR4epgCCaZnrLlFfFEAYfVT3CLxXRXl/wgYumWOKm+0NOwvmpUBLV1vtVLFhrw/TyKC5cSMpipEeTL7Fzxuy9DpoZEqsp9lW2NRbLQ6s76CwKgFCevXelup/cHrcBKqGGLIU6CFAFDOq1E8GINKkSJZpS90TIeUe3MXdaYH/h/q4Rey3ASyW8o30eGYqUQQAhbegJyY2g1SVbnbSzVQ/71G7uYKFfX112T8sXC7n3kD8QNQRrC2r8ZMTm9u4OM9rDy5wirhKxg78bN52DpIEmMdGzk3AtaAeRFC7lObf9evnfvgDVfSUcPqkpbMe/1JcmrrHJuFfYRtXXB43er8H/wbvnoxoYVsVrevXqmIm/DkLgZfj1xFmrXwOBnXJ/lp24xYR7KbCGtBAEreh7e5Z7cmlYzuHLTg9f8Zwn+R8mrPtAd3hES4uUeer0hIz4XmhcW6xmNRkXzpJyiJb9neQZuVS95AFRvafs99mtawIwVDLJb840ZMbz+sUId9TTmUmVvFOaQDc0BK5hgWJS7w5/OkW2zj
 FZHmPSmo
 hvLbhdWv4aiCoh9lQtux/thlr2eFb49gFr288Sa46GnIWbUaLEcHHzPJZPB/j8Y1I3j1XlImcXLfAa4yr7QVggnF9reLdbIV8zx4eJkb+jVzMkPHH3ZLtIQuF9xs5RxRHMZ/8gzVLLEaoZZFxiqhqgKAxTMEgUqPxAm6FiYaHHF4tJ7yU6RrrcCnfj0HHns0FlLkhLGUI7szGrZzRYYKZBIKenUPzQ4S0tReE+J1PADpqlxShn8IKsFglReVc6KkJrkqTeotLXoE8xNn6qf1NzSQS8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

(please trim your responses next time)

On Tue, Apr 28, 2026 at 06:35:51PM +0530, Sarthak Sharma wrote:
> On 4/18/26 4:24 PM, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Convert khugepaged tests to use kselftest framework for reporting and
> > tracking successful and failing runs.

...

> > @@ -830,16 +783,12 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
> >  	int i;
> >  
> >  	p = ops->setup_area(1);
> > +	ksft_print_msg("Construct PTE page table full of different PTE-mapped compound pagesd\n");
> 
> A small typo here, "pagesd" should be "pages".

Thanks.
 
> >  	for (i = 0; i < hpage_pmd_nr; i++) {
> > -		printf("\rConstruct PTE page table full of different PTE-mapped compound pages %3d/%d...",
> > -				i + 1, hpage_pmd_nr);
> > -
> >  		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
> >  		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
> > -		if (!ops->check_huge(BASE_ADDR, 1)) {
> > -			printf("Failed to allocate huge page\n");
> > -			exit(EXIT_FAILURE);
> > -		}
> > +		if (!ops->check_huge(BASE_ADDR, 1))
> > +			ksft_exit_fail_msg("Failed to allocate huge page\n");
> 
> In case we are not able to allocate a hugepage at fault, should this be
> reported as a per-test failure instead of bailing out the whole binary
> with ksft_exit_fail_msg()? In alloc_at_fault(), a failure to allocate a
> hugepage is reported as a normal test result via
> ksft_test_result_report(), so should this case behave similarly or is it
> intentionally treated as fatal? I realize it was being treated as fatal
> before this patch as well, but just wanted to check whether that is
> necessary.

I don't think it's necessary, but let's address it separately. Here I only
mechanically convert the code to use kselftest helpers.
 
> Also, when ksft_exit_fail_msg() is called, totals are printed twice:
> once from ksft_exit_fail_msg() itself, and then again when exit() runs
> the restore_settings_atexit handler.

This is temporal, restore_settings_atexit() is removed from khugepaged in
later patches. If anybody feels strongly about it I can fix, but IMO it's
not really important.
 
> > @@ -1242,8 +1186,6 @@ int main(int argc, char **argv)
> >  	save_settings();
> >  	thp_push_settings(&default_settings);
> 
> Also, can save_settings() and thp_push_settings() be moved below
> ksft_set_plan(), preserving their order?

Yes, you are welcome to send a patch ;-)
There a lot of possible improvements all over the place and I wanted to
keep changes here to minimum. Let's keep it for the next round.

> Since save_settings() is printing a debug line of its own, it would look
> better if ksft plan is printed just below the TAP version line.

The message from save_settings() is printed after the TAP header:

# TAP version 13
# # Save THP and khugepaged settings... OK
# 1..26

-- 
Sincerely yours,
Mike.

