Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB4DE606A339
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EiwkCE7R
Received: by kanga.kvack.org (Postfix)
	id 078CA6B05B5; Mon,  2 Nov 2026 08:14:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051526B05B6; Mon,  2 Nov 2026 08:14:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0646B05B7; Mon,  2 Nov 2026 08:14:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5E326B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:14:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 597EC1C44B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:14:20 +0000 (UTC)
X-FDA: 85390222680.10.545D5F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A97DFA0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:14:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EiwkCE7R;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793625258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Pfk/Q2Uv6acPQS+IeiOKb9434MtyECcCVkBJIJJVKk=;
	b=hRBMH6XB+DC/OaDtpb73j1cDvSIvuqAPLUb0g993m9yfX2vn6gHimYQe/W4VDoAtJIVPlf
	zMyjE7P8U59dlVqkmZLnl1abZaO6RiWUQk/osNP8xRXUh/Uf2e3ZaOLDKWuobxebLYDi8q
	cpVwRNS0NX4nCeGIfevNHvfWnJTjd5s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793625258;
	b=mKtINxLdixDLQYSaHcX5f+euJQKI5kiTA0LXcn5StGK7Aei6BvgVmfiJo9TcPHcPshMmDN
	oRRcJFIsoqOiuK3IMrSrm4OLFtOFO6SuwnYw9DdOm3YM9w/4mALtqIEJcSB1GwbmktKZBE
	C7t2osWgTmWe0LUMpUvQrofNZCpwOQg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EiwkCE7R;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04A0F40391;
	Mon,  2 Nov 2026 13:14:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6731F00A16;
	Mon,  2 Nov 2026 13:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793625257;
	bh=4Pfk/Q2Uv6acPQS+IeiOKb9434MtyECcCVkBJIJJVKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EiwkCE7R/+2xPaA5RmPCUc6HDP5HSE+dlKRlXkpDhrCQR4d2Cpv1dUv8vU5JaH7Sk
	 zjEeN/b1UnBx/Pk5xVcxncnffRzrjmwmOTnSzDi6fqiHs6TOxhV+qFYhjMOEk3bw0T
	 h2a+beVgBETr4IdsY+QM5X4oPldeojTIZfjZp5+umwXyfve3f4/OPJHJJFKZT6AWYC
	 U58lTf+RZdVng7mQdVEBq1GSiRNlBvaakdF2SlAW+6CU/ZwHxDb3gX9J+a33K1OuJq
	 Ez2ggvPfSd95NJVkO+U6XTVEgS+u9tLDveBBc2JbgltmKtbRafzSJ4IVKTO3tiRhfv
	 8pP7VQSMymWkw==
Date: Mon, 2 Nov 2026 13:14:12 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 2/6] selftests/mm: test a partial mremap() of hugetlb
 memory
Message-ID: <auiMju345AXIBVGa@gremlin>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
 <20261030-b4-mremap-pre-split-v1-2-c1829811aed0@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-b4-mremap-pre-split-v1-2-c1829811aed0@toxicpanda.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A97DFA0008
X-Stat-Signature: maf7c1ttrz59m3a5wp7wg18q7i5y9yf7
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793625258-786914
X-HE-Meta: U2FsdGVkX1+a67I1MqvhdytObeJIQtyvEOt+48/01eYpnUE8X/GGc87WtWbNSF3AFeHwG+ESbmXorKJb0Yul6vCGXnrg14EYdvd949lrgPY4vckjH9auaG2fbL71rYtA6JXOSNMNtDUVxTkujC3s164XQw/Qq6PN02yUZrk//QZM6m/A5PO1eQI/gLFQ63/BdnaETWI4ok1rNdUCsMGimnvLH7gat6zq1mL4wyiTi+cYfhbJiijNIIwtIOOUd0jgTK9F3fq44uvwrbwrFQJJumc8DBuniTOtGwmWv9k4Ppy5jAwW+R5g7nbipukOQ7HxRt7Jr2bIzil38GnzKOj55wVhlLpTYxklonWTNlXto82NBgubKWYLZUX4cXgqfPCo50tQ4u13z0bYsG2R+RBjdbn4GeE68po6D30OtOP5T0TjUMelgwW11Tn/vXMbeN+NEQlWv2OErq9BwzcD1IRgxdaXNjG5qtHxMUPqECmF10BSvjkCnDUpKYSi/C3tJwFz4f8BPT8MpoXshROUyKnwgbFqR9etsI2flziUl9FIaAi/AUt4JnxJ6YjoypgIyW5qSAOR24MAagBm0T+cgP6YqGi0GCAcr7kb+gE/v42gdog61z/8hXD52BuqNfa9sR3RKB02O0YJv3MWz0xTHb7Tb4lh+oTjJeeBZ3NIT7KqIaEoDSLpd4oEmxxJpBFrxf5Wo5du4iCc3MnVbYUJbahrvUPUEWqkO4mNIv1nWY/SBGywY8+32sx4bTR6UJB8FvMlp02cotDBYmAnYbOWulMuigIqlbqpIq2GTYkFpgEw7S5eFByQjX12B3kxEyBZPsgKVfg3Dgc4wCgatG17XjEu7yz3z0dPzy8LRxOVgJIlVjGPb7x4mmgN32p1wzFdQl3KWUQM3SqEeUH7u/3OWwJeMCaW2uRUsYmq9cnBjscDrm/2bqixTu/hnwmGZKDu6Z89ornvgGYwlfV7Cc3MdGk
 Z7M3V4+C
 0gR1A+NkpRTFFS85I+0ZE2lDcM/vVWCZGG1FUK+RwQlBDi5OvAfXQsnAgy0JnwpzyoPUbeKrTRPfTSdu8h/SXX4fRrbrXX/P+7vF3Yur9uFEaR914VYYNfkT2FhoAMGbvxNZeRwy4+pKEShIXxoz+kJrbv3sm32qaaxglUUgpkRrXDBx06PmnbmUA9A5UE8tAY0b5NE7GNv8CS0wJp6PamkfnxhaIJhxg5sjLpNLEyb7Tmn7iOD8yKepBCVF0hsCSKpRbrKI3qDedsdukTfGBvB2W1vOy4NOl3C+cAbKYflfFzMZrKtReyeAgWeavmPPs7vqconBONylT/LcZYLMwi4M+iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:42:47PM +0000, Josef Bacik wrote:
> hugetlb-mremap only moves whole mappings, so it did not catch the
> reservation leak of a partial move.
>
> Map four private huge pages without touching them, move the second one,
> unmap everything, and check that the number of reserved huge pages is back
> where it was.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Looks sensible so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/hugetlb-mremap.c | 52 +++++++++++++++++++++++++++--
>  1 file changed, 50 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
> index 9b724af66e93..9f9d6905cd6d 100644
> --- a/tools/testing/selftests/mm/hugetlb-mremap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mremap.c
> @@ -95,6 +95,51 @@ static void register_region_with_uffd(char *addr, size_t len)
>  	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
>  }
>
> +/*
> + * Move one page out of the middle of a private mapping that has not been
> + * touched, so that every page of it still holds its reservation.  Once all of
> + * it is unmapped, all of the reservations have to be back in the pool.
> + */
> +static void test_partial_move(unsigned long hugepage_size)
> +{
> +	const int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
> +	const int prot = PROT_READ | PROT_WRITE;
> +	const unsigned long nr = 4;
> +	unsigned long resv = hugetlb_nr_resv_pages(hugepage_size);
> +	unsigned long resv_after;
> +	char *src, *dst, *addr;
> +
> +	/* The pages of the test before this one can still be in use. */
> +	if (!hugetlb_setup_default(resv + nr + 1)) {
> +		ksft_test_result_skip("Partial move: not enough free huge pages\n");
> +		return;
> +	}
> +
> +	src = mmap(NULL, nr * hugepage_size, prot, flags, -1, 0);
> +	if (src == MAP_FAILED)
> +		ksft_exit_fail_msg("mmap src: %s\n", strerror(errno));
> +
> +	/* The destination has to be hugetlb-backed, mremap() replaces it. */
> +	dst = mmap(NULL, hugepage_size, prot, flags, -1, 0);
> +	if (dst == MAP_FAILED)
> +		ksft_exit_fail_msg("mmap dst: %s\n", strerror(errno));
> +
> +	addr = mremap(src + hugepage_size, hugepage_size, hugepage_size,
> +		      MREMAP_MAYMOVE | MREMAP_FIXED, dst);
> +	if (addr == MAP_FAILED)
> +		ksft_exit_fail_msg("partial mremap: %s\n", strerror(errno));
> +
> +	munmap(addr, hugepage_size);
> +	munmap(src, nr * hugepage_size);
> +
> +	resv_after = hugetlb_nr_resv_pages(hugepage_size);
> +	if (resv_after != resv)
> +		ksft_print_msg("Reserved huge pages: %lu before, %lu after\n",
> +			       resv, resv_after);
> +	ksft_test_result(resv_after == resv,
> +			 "Partial move returns all reservations\n");
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	unsigned long hugepage_size;
> @@ -102,7 +147,7 @@ int main(int argc, char *argv[])
>  	size_t length = 0;
>
>  	ksft_print_header();
> -	ksft_set_plan(1);
> +	ksft_set_plan(2);
>
>  	if (argc >= 2 && !strcmp(argv[1], "-h"))
>  		ksft_exit_fail_msg("Usage: %s [length_in_MB]\n", argv[0]);
> @@ -170,5 +215,8 @@ int main(int argc, char *argv[])
>  	close(fd);
>
>  	ksft_test_result(!ret, "Read same data\n");
> -	ksft_exit(!ret);
> +
> +	test_partial_move(hugepage_size);
> +
> +	ksft_finished();
>  }
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

