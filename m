Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB58C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F1B6B016F; Tue, 18 Aug 2026 06:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06D26B0472; Tue, 18 Aug 2026 06:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946BC6B063E; Tue, 18 Aug 2026 06:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 584BA6B016F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:11:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D60ECA3861
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:11:29 +0000 (UTC)
X-FDA: 85113973098.12.5E91AC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4DD03100007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:11:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TG6lUBXE;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787047888;
	b=BgEijVTSZawFRMopgqF68rD0Rk8jKMV19y+0HxeorXsKqr0tR+DFAwge8W+tYVVKSA2ey+
	08DrQN5B60UBqs/KCjRHWk07szDBVRyPF6b/Pt4EzNcSUPojFXCiWEg8S4mZ0A4PLdeXrR
	E8yILMv0wsP3Ye5w5SNpSyCnxMI2Gfc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TG6lUBXE;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787047888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbQXsDHeiEZVSZYhBtiXerG/ChW5kGrPyhOfZsr0oQM=;
	b=kuBOhNrLo+DPYq9aaRCNRow/uVMFOiBatAANEXT3wB4qTXqxNZ0V+zR2CE/gWGmhmWnahs
	8lh9VdfWRFNUUN9BgK8+V6wifCJ1gm/mrtqggsbw4/wXrIti/5KfUlz/T1Xj1Uo0BGeV2s
	uQLEyylqJOumk/Br+t2yrcjFURhN4Jk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3CD0601FB;
	Tue, 18 Aug 2026 10:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D561F000E9;
	Tue, 18 Aug 2026 10:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787047887;
	bh=VbQXsDHeiEZVSZYhBtiXerG/ChW5kGrPyhOfZsr0oQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TG6lUBXEGl96pjFeOwujMG+E90mrmdWMQ1E9eM7NtYcKMqHiSc8SN810u579PLg3/
	 vq76DoI3mluVgsHMjJGMVT9ZMbGnglOHSpQhEtTDeoXFYtMHs5XWz8HjUeETm9a2+y
	 4742/sptD+d11W09R40BLPfO6VJBDYt7qCvxG+lb87LvudG6mvKuXMZiSv6XLES46R
	 ncLRLcRS6iMU064ya5cOu3YI2uZqdhgk+M2gnBU8kkbsid35zkh3hGb700Atc4dpaX
	 6B7JHXOA1J3OzilKoEbmSUnAo4FSoRDzSlrd2M+xKZ+ZQpbm7W32BHQ+Q6G0RFGtnI
	 8ZT1BrxJEZPrw==
Date: Tue, 18 Aug 2026 11:11:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org
Subject: Re: [PATCH v4 05/19] selftests/mm: make the swap cases' swapout
 reliable
Message-ID: <aoQvTjRbcnQNCAuY@lucifer>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-6-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815015901.1236937-6-kirill@shutemov.name>
X-Rspamd-Queue-Id: 4DD03100007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fpj8b38g9txdhr34p63kntzwa1gu5nc5
X-HE-Tag: 1787047888-208885
X-HE-Meta: U2FsdGVkX19ivLQ5CDJSm2hs06nWNDDmZeQ1nQN7XgQ2/+DIS/4Tut0x7dhhebtR9SaFekNEz/cWmdpB2lhABMZmmlxdMa/9cOspWwDnG7agoNYuCACyCiwdLEoPMwqUKf+E4dCyjQaqvpk3fEjcV9YOFzTFx/uaI8yvmjiyxFEnD/dOM6z+SMbM+a85Efix/6zY3VemtyshsGdDzwesFs287hKxvEVEdXloo4xKOVynEeVNWbxqDPxG+uowp8bevZVDB5JFNWsxoZFn5euliCIhejM8ZDj1WtY2rJlulQydCM5twmEIeDU9bSUeC6jIhqr4P2EMji0QYeOLPCgvendQcj51Sp3NrtoB8MAXnmhobyVZ5kLqzPZ4WrvYMmdLoCGAp8rvapGUCEQQa0vMuJKBwhVTtHEg+8mPkTnJ/h2l8GbyFjZg7QZ6XfV2A9C6atiDXNQeqH0hQ9tzVRwCJsD4TtgWQL66eFEl45Yy6rpSQHi7IgknPpr3jNTUQoUlHuMeyAcSbQNcuRdmtVU/racMbDP0PVOmwEgXlF5zuvaYV2AtwND63MYP8I7+kvIokm4NQ/HjAhJmFrPof7alxB+EEXNbkioSiWoZJn/CUI9ma7sXCxjoQdniR/lU7gQQdBZbcMBq4nJnoa81mPPY85Ed+8YQJhapuYapirdrNfHEch7r4EsobAgl9m9+x83bbmam+D07c+1YDMRvzEkGT/PKhYGTHbY2qfcn4hgmqt5AyNzZLo9n9qoFz/VqvTGrWi6+/5xs3oNH1SQXKVAkoy7fA3D7bsAgsLhpONdGFjrmAEBcbNo0hex5ZhitSG5EIgq0pKLiGAkcnkab3dsk/Z3PIe1lXIU4efYL74DM3nv+3vOWLfmkTSkiAgeFkx4uIlpsSz6lRFKegp+G37uWQqn4u4GDxRCYfKExfvziiTyh9lTPVrV9/iRIEJfh7tCPC04bB8pAF/kWE0X0+Ll
 b/xaz+FK
 AXoaYPfriRwZZqmPRHtdquLJ+4zK1gte1h6UQ88F0z7Z+fWcv5NsQGxoFcrpKd2wLwGZQi5113D6itp0HHp6X3Qx+RDMYyYsiNroZt740M/JCmOnfNTRESIoVkitHO7VawZ+uD82ZVLVE3ZDR0fuXQmJcgX7uMbZ4Q4iy8WZK1Nff2zLir/hN+Ca4e0uoq8ExJyoXOjdbMLe6K5cyM8eL0ZCdD/LHRDP0KppVJhpUIkeNs5ciZQctCfFTKfJvY5pxyP6iZQkgdw2cxA7+Qpo1Yp//BfCyQlBdlJUI3OMg7IUDNdIUmKJCPbyCMqYbyG+YQ10zmfYi4zPMym99sJ4Nv2MfVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 02:58:47AM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> collapse_swapin_single_pte() and collapse_max_ptes_swap() swap a range out
> and then require smaps to report exactly the count they asked for.  Two
> things keep that count from arriving.
>
> MADV_PAGEOUT is best effort, so the count often turns up a moment late.
>
> And wait_for_scan() leaves MADV_HUGEPAGE behind, so khugepaged is still
> working on the range.  Collapsing a range with up to max_ptes_swap pages
> swapped out means reading them back in, so the daemon empties the swap as
> fast as the case fills it.  On arm64 with 64K pages max_ptes_swap is 1024
> pages, which is 64M a step, and the case loses:
>
>     # Swapout 1024 of 8192 pages... Fail
>     not ok 10 collapse_max_ptes_swap
>
> Ask again for up to two seconds, with the range held out of the daemon's
> reach while asking.  The collapse each case runs next puts MADV_HUGEPAGE
> back, so only the setup is affected.
>
> If the pages still will not go, skip.  A machine with no swap, or swap too
> small, full, capped by a memcg or busy with writeback, is not the kernel
> under test refusing.  An error from madvise() itself still ends the run.
>
> Assisted-by: Claude-Code:claude-opus-5
> Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 53 +++++++++++++++++++------
>  1 file changed, 41 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index ec5c36a19d92..7eb9db0005a0 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -219,6 +219,41 @@ static bool check_swap(void *addr, unsigned long size)
>  	return swap;
>  }
>
> +/*
> + * Page the range out and wait for the swap count to say so.
> + *
> + * Two things get in the way.  MADV_PAGEOUT is best effort:
> + * shrink_folio_list() leaves a folio alone when it cannot reclaim it right
> + * away, and one still under writeback from an earlier pageout is the common
> + * case, so the count the caller asks for arrives a moment later.  And a range
> + * an earlier collapse left MADV_HUGEPAGE is one khugepaged is still working
> + * on: collapsing a range with up to max_ptes_swap pages swapped out means
> + * reading those pages back in, so the daemon undoes the pageout as fast as it
> + * is asked for.  Keep the range out of its reach; the collapse the caller runs
> + * next puts MADV_HUGEPAGE back.
> + *
> + * Failing to get the pages out is the machine's answer, not the kernel's --
> + * swap too small, swap full, a memcg cap, a folio still under writeback -- so
> + * callers skip rather than fail.  An error from madvise() is different, and
> + * ends the run here.
> + */

This is a schloppy comment again. Please trim.

Walls of text are not wanted anywhere.

> +static bool swapout_range(void *p, unsigned long size)
> +{
> +	int i;
> +
> +	if (madvise(p, size, MADV_NOHUGEPAGE))
> +		ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");
> +
> +	for (i = 0; i < 40; i++) {
> +		if (madvise(p, size, MADV_PAGEOUT))
> +			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
> +		if (check_swap(p, size))
> +			return true;
> +		usleep(50 * 1000);
> +	}
> +	return false;
> +}
> +
>  static void *alloc_mapping(int nr)
>  {
>  	void *p;
> @@ -827,12 +862,10 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
>  	ops->fault(p, 0, hpage_pmd_size);
>
>  	ksft_print_msg("Swapout one page...");
> -	if (madvise(p, page_size, MADV_PAGEOUT))
> -		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
> -	if (check_swap(p, page_size)) {
> +	if (swapout_range(p, page_size)) {
>  		success("OK");
>  	} else {
> -		fail("Fail");
> +		skip("Could not swap out");
>  		goto out;
>  	}
>
> @@ -853,12 +886,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  	ops->fault(p, 0, hpage_pmd_size);
>
>  	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
> -	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
> -		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
> -	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
> +	if (swapout_range(p, (max_ptes_swap + 1) * page_size)) {
>  		success("OK");
>  	} else {
> -		fail("Fail");
> +		skip("Could not swap out");
>  		goto out;
>  	}
>
> @@ -870,12 +901,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
>  		ops->fault(p, 0, hpage_pmd_size);
>  		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
>  		       hpage_pmd_nr);
> -		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
> -			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
> -		if (check_swap(p, max_ptes_swap * page_size)) {
> +		if (swapout_range(p, max_ptes_swap * page_size)) {
>  			success("OK");
>  		} else {
> -			fail("Fail");
> +			skip("Could not swap out");
>  			goto out;
>  		}
>
> --
> 2.54.0
>

--
Cheers, Lorenzo

