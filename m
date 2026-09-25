Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B13BEC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B906F6B0092; Fri, 25 Sep 2026 03:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41B06B0093; Fri, 25 Sep 2026 03:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C646B0095; Fri, 25 Sep 2026 03:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D0DE6B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:41:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 062F01C3274
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:41:34 +0000 (UTC)
X-FDA: 85251489708.25.CF3A71B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3409420004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:41:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mojc1X2e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790322092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSXXHcoKeJGdNHQgFKs26HgxQNSGO9LllOG334GweVs=;
	b=4rr7f/gJpy/ebdzkg+6f8dhzgnsndIfk+RhZlw6cml4rnrjLzLHoSjFdhooJwuuRm8brOz
	jpmle47m65qblYlwpMhp1ZCde00MSvosGimRGc+euCinl0ZYwRRVcgKWk+bLP5UXMppFnm
	dmNSwQgz+8E70dxvetX094258b3NaNc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mojc1X2e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790322092;
	b=o2eiqwrFqdIv+KU4HIVYTztXmdTqu6DZp0zFT12PyI3TqTKG3SHKjv+ON7KmGgEy3QzNTy
	uBJLnb/VQVt9V8+PcLALH/1JQws61YBYW52a+WbWVC8BIkcrq2T2GGSNk78QVZ9Bn7UXXe
	mddxPqylGOLDD/CmDC7HyHNOf4oFqnE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 604214144B;
	Fri, 25 Sep 2026 07:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0BC1F000FF;
	Fri, 25 Sep 2026 07:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322091;
	bh=sSXXHcoKeJGdNHQgFKs26HgxQNSGO9LllOG334GweVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Mojc1X2e2BKYS5x6as8pQ1NzXmlundxvuGcBb5WPkaE7dvY7/dEEGUKy/DPS9i95v
	 UIJesHTcAlIJTjtw/Oyk9SMcyAu9quYuxtqUg2e3bcSRFPkxa27VTOGMKge/ni2P5V
	 jWFk9wmBeHYwcu4pjSffNF+67ayFWIYsEAcg9aL1Vll9RW+5laPjhtGkphDbsYoxWQ
	 HLefio5ZpWeUHpBqFDJanj6jK9AY1G4+Ci4BwjEgiVLquuoFoGn/D9l9dMMXnW8pKk
	 na+ra7w5ODe3CkjBBXKvkCNQm11V8ndON9dKEZzD5YFdhlUDCUsAVgRuUMkgEHyO3Q
	 blAaGAUvPdDng==
Message-ID: <226ec797-ff8c-4465-a682-21c684a25021@kernel.org>
Date: Fri, 25 Sep 2026 09:41:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: add a test for UFFDIO_MOVE of a
 write-protected swap entry
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>, akpm@linux-foundation.org,
 rppt@kernel.org
Cc: peterx@redhat.com, surenb@google.com, aarcange@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, mhocko@suse.com,
 shuah@kernel.org, kirill@shutemov.name, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com>
 <20260925042907.2330519-3-donggeunyoo.kernel@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260925042907.2330519-3-donggeunyoo.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ihet83tuonnqexeswzo3ngmwsqt5zo55
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3409420004
X-HE-Tag: 1790322092-563201
X-HE-Meta: U2FsdGVkX193Zfz1oMYfT8Bx25SnYGs2+i92345F4H201GYg8DWtWoY2Ec4cEY/m6ZJaCMskrVPfVtXPl+96/WJfMjAAXWkoVVOiVTISNJESzeOF+vnDVksudHmiWHdRDzoKsvq9MHPRuaejQEZ1nUFTkTQrNpN2wijkNHP5Gy9+r1fEx5eEyBhpbrRIpP35m27rAMfnCLTjfxrwKrIxePUOjz715fS1A40knem4kEDj2coaaaqjgdnpQpNbySgbyd5z0ecIw+UbQNHpKh2ViwRjM5bo13laxabRX1p72xF8T8V5Kd7nLZVj5yDFTAlowGz44GCsHH1HEXxzfhe/ptDqXh9yTgU58EZix6ROYZ8i8FUQjJMCkkEzmyVoG0602BamguRfywy7brBGNrTAtj/TNhXV0tJ1b3tGTPrvhJgU9eP7n/s8RSWmybSpl/Vgs8M/LFhphPsH19W2wFWDO47Zdps2xeQEH/rFbWHDDK76mHbFE+mg/BG8zCu3lzPlR2VI0qISzyebHnUwOIjPCpy+H7xD4kosNjFTf9Eoy3wOY72lkNEAvxxzHqaw4D37KKYQasS4dWthoxyxB8V+vT8n205FeoQhALqenv988T2d98KRFwOrtAlbVg6QD6z16Yxl+r473+EDLMHpj2oNW5UvoqOEYkMkQbnHL2PHOdzza69Y23oMbwLiWYt7TE/ecT5ksl88wJUPzdI7ZClXfzOOnFEqlgWkUa9Dqfe1cvwbj8l38CDIkZmjOlunG4pEzARBUCPlrKgJByJjbK53lqnxQ0hB/A8DqFrztC3fy3o5r+9WMlmx2Vcfvo43k3RblPOTLBSXpUk9+KN5cmTNuE1QOUMWDOGR+oZ4GB+v+kJQ8BsTYpkGUguxL2/+hDs6vzat7dkGQdjVoytoEdD6Wlq/E6TuF6YGUPoNrxwHQcniAOKtlQbMpq8vITgJsLbVCrYN8+mFF9reICxjUlD
 Z1gOPoRf
 qQQ1uDMn7lNzTdXxVQZs9ZGkQmKOTfvDFw+7YNT3Rkld2b69NtOnhCHZuu0jJ8Z4OYYRpWhMD39XebArggpHptSRerIq2lPEQiuAiw0/E+QlL2CFSABdxSzghLUa6dVhs70oYcKhByluEvVeyYgQKuUJzzM6rlg5k5gccyoUQngQC7AYTCvCY9dOifxRtSt5oq5f0oqJOXC7ti4v0egtjN6dxBvCt+gyGxIcka0cOtatmSuNbFaH2oONx/VMCKY9is4wXWk1/C+xDr4kqyqoq/VULJzetO+BM446nHRY+vxKpP+jcU/lVv30Ajf3xoseswQ9BJh7tReLipAM18tc/oHfnlFDXj5NMhuHUZ0hZN1Hk6cumPz7UOXF2CizpFO7e0YBhR1y/yJiBNPYHOoiLMg8IWbimddmAzB4WLX/WozVw1/3YcWQ2aDDGVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 06:29, Donggeun Yoo wrote:
> Move a swapped-out page out of a write-protected area into a destination
> registered for missing faults only, and read pagemap bit 57 at the
> destination.  The destination was never write-protected, so the bit must
> be clear.
> 
> Assisted-by: LLM
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> ---
>  tools/testing/selftests/mm/uffd-unit-tests.c | 61 ++++++++++++++++++++
>  1 file changed, 61 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> index ef9b3956bdcfd..ae8b718f0a278 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -2037,6 +2037,59 @@ static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_a
>  			      uffd_move_pmd_handle_fault);
>  }
>  
> +/*
> + * Moving a swapped-out page out of a write-protected area must not carry the
> + * uffd-wp bit into a destination that is not write-protect registered: such a
> + * bit is never cleared afterwards, so pagemap keeps reporting the page as
> + * uffd-tracked.
> + *
> + * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
> + */
> +static void uffd_move_swap_wp_test(uffd_global_test_opts_t *gopts,
> +				   uffd_test_args_t *targs)
> +{
> +	unsigned long page_size = gopts->page_size;
> +	struct uffdio_move move = { };
> +	int pagemap_fd, i;
> +
> +	if (uffd_register(gopts->uffd, gopts->area_src, page_size,
> +			  false, true, false))
> +		err("register src failure");
> +	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
> +			  true, false, false))

Side note: this binary encoding of features is horrible.

> +		err("register dst failure");
> +
> +	wp_range(gopts->uffd, (unsigned long)gopts->area_src, page_size, true);
> +
> +	pagemap_fd = pagemap_open();
> +	for (i = 0; i < 100; i++) {
> +		if (madvise(gopts->area_src, page_size, MADV_PAGEOUT))
> +			err("MADV_PAGEOUT");
> +		if (pagemap_is_swapped(pagemap_fd, gopts->area_src))
> +			break;
> +		usleep(10000);
> +	}

Is this loop really required? I thought the page should just be unmapped from
the page table. It might still be in the swapcache and under writeback, but
that's irrelevant.

> +	if (!pagemap_is_swapped(pagemap_fd, gopts->area_src)) {
> +		uffd_test_skip("MADV_PAGEOUT did not swap the page; is swap enabled?");
> +		goto out;
> +	}
> +
> +	move.dst = (unsigned long)gopts->area_dst;
> +	move.src = (unsigned long)gopts->area_src;
> +	move.len = page_size;
> +	if (ioctl(gopts->uffd, UFFDIO_MOVE, &move))
> +		err("UFFDIO_MOVE");
> +
> +	if (pagemap_get_entry(pagemap_fd, gopts->area_dst) & PM_UFFD_WP)
> +		uffd_test_fail("uffd-wp bit moved into an area that is not write-protected");
> +	else
> +		uffd_test_pass();
> +out:
> +	close(pagemap_fd);
> +	uffd_unregister(gopts->uffd, gopts->area_src, page_size);
> +	uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
> +}
> +
>  static bool
>  uffdio_verify_results(const char *name, int ret, int error, long result)
>  {
> @@ -2359,6 +2412,14 @@ uffd_test_case_t uffd_tests[] = {
>  		.uffd_feature_required = UFFD_FEATURE_MOVE,
>  		.test_case_ops = &uffd_move_test_pmd_case_ops,
>  	},
> +	{
> +		.name = "move-swap-wp",
> +		.uffd_fn = uffd_move_swap_wp_test,
> +		.mem_targets = MEM_ANON,
> +		.uffd_feature_required = UFFD_FEATURE_MOVE |
> +		UFFD_FEATURE_PAGEFAULT_FLAG_WP,
> +		.test_case_ops = &uffd_move_test_case_ops,
> +	},
Do we also want to check wrp? I'd assume it suffers from the same problem (did
not check carefully though)

-- 
Cheers,

David

