Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52EFCCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91AC56B025E; Mon, 19 Oct 2026 09:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAE76B0260; Mon, 19 Oct 2026 09:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9C66B0261; Mon, 19 Oct 2026 09:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51E576B025E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:38:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D9A72806BE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:38:00 +0000 (UTC)
X-FDA: 85339479120.15.CEC72BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1586B8000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:37:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XMX4/U2U";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792417079;
	b=lmWbW0w7ivrUmAj9AlFlwjLy7c1iR0irXRQWh0N7SBOFIRhwcJri9ne28EnNtkwUBGHVeV
	ist78rLGt+jniJ/Ce/3ra7WQVHegN5NDiyKWzx6NlyGi27wo43Ik+FEwy19D+FddmiKB22
	PuZYoBQRXj/8CG+6PD2Fq6WqRWf839M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XMX4/U2U";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792417079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KltLcIUAb/n+sPGDmQ9VfrMwiJ4IpafpRw0FqjJaXS8=;
	b=VMfRBibdoIGZmdRsFQCC4gmojtkBvdQnAdYIQ7Ciiv+FGgthph0x7CM/tfEKzVbxcKyDdO
	zNUbR+yb14zT4yXIRZAEbFUt0Z2v1o3pv/h/wT6V8VizCe2lVGtPp5BPZVudLCubddAWc4
	WZErPjoOcL7RvKmS7Irtf5e1XOQAdFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FE6243A5D;
	Mon, 19 Oct 2026 13:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8D91F000C6;
	Mon, 19 Oct 2026 13:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792417077;
	bh=KltLcIUAb/n+sPGDmQ9VfrMwiJ4IpafpRw0FqjJaXS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XMX4/U2UBmjjuzUmFjYnVEtJKs/hgbhAQ3E4P2BJ9BSyFgm13GtxuXVyu+m1r+TZ8
	 kGDtePXENyVjG0DzuYjtAdPMXyvyce9UzWDWLXQqBn9nft8MpG7MUp/tKXIBnTdnUS
	 cMqa3M1ZLYKcuTvBUco/4YfHGnnKaNq+CqNdxW40wV2rOxugl/4hRXSls6z5OJPqmh
	 PCTvDYMZ4bHICyb9KOezlMa4HXrUfkmb9FP646d+fRTC91gVFbWMYpL5+jNpB+US2U
	 6Y9/a4Y7vzJ5Wg3q96HIEzGfDSNbUhEPgaekVNS5wPE2cpiQ6yhTbwkjl11EUrhgE3
	 fyIKk8KOFSHXg==
Message-ID: <4a6ddf56-af89-482a-b173-18e181bfc3ae@kernel.org>
Date: Mon, 19 Oct 2026 15:37:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: keep ksm_tests on small pages
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Usama Arif <usamaarif642@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261018-bug-selftests-mm-ksm-tests-nohugepage-v1-1-55ed54bdad35@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261018-bug-selftests-mm-ksm-tests-nohugepage-v1-1-55ed54bdad35@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1586B8000D
X-Stat-Signature: hfwf8ny94cnkignmp8oa4ox1984epfr1
X-Rspam-User: 
X-HE-Tag: 1792417078-140535
X-HE-Meta: U2FsdGVkX1/S+sVqU/xXufPHgLUAebbwSrMuSdUH4/t00PV3ZrSYojXZqgKQT3vm1j6SPSaJRWbrsDA4drKR974fedLWQ18cuXLP1k0jSpDh88AKNbd1dsJLx/4cvnMtuunrJ4kBccGv11pxUbuf4haujEKGt8es5vKLTjFqN1Efd7e4IdJDs4/Z24YsAE9GycXh9puI1Gdc5rVBJq+f+45uH7FV/wYbbAgKK33+ckahyrcDIQoeSRyKplPz5Krew3pu8T+BHCRJ6R8UUTf8yC7fOiEAhwXHkRixYvs313yjTA3LWXERadl++AbIqLHn18GZpFo/DW3l1n9J1sI7WdDIsk9gGRp8aWkXfsXqjCzfWL7Uh8MK8TgFt4oLO7obrp+dWbuCj5Tu5SspfqQHQb4hfEmDi0syyzOXsRBDeZD0jfkCH15E5pJiwu/CK7wV29M+Rpghte1lXUkxqVHYmvbZEIUt3qRdKCWLuHvBwl4EYbsJaJfyEPHewiNNpQBU/816ffpxRqrVWZvGnzVXjF3AwRLQXmlPFyNiztCMDPI8xkJaSTwMQroz1blIQjFqb7E0o8cMATLc1Ae0FfUssnvFw730vgAyK4XlbFxRVlVkwUHlKAmY/bSKIl3our6i+aWgiY3Jx0TzPoYhoJ75QIUJcqcIE7VILCXx9iODtpL/CvdNRpF7YLwniVQ4Wb3/r7bPW2UKSizS0DDoscjZCKYCRu0UX6puBX1l5bqS2PkEqEo8Vl2Gmd6CaXsbuV+BSwNQaDL9i/YWC/6x/czWLyn63k2Zoe0+JUJoxmkIcXvFpskyNa1JZI4Xa55edRq0vLM4dWBZ8igpWqQPYMm+3rdllRPgD3zV4qHixcQ4ucATtZ2R2+HRfw2VdD2P4+PmNCPLW+ctdthJ5SO5R/04CGKnyu+NJTTq+UAAo9PTZAkG49gnTZOWtpeAy4zDmXfDAc0YVd3IiSgwvuaeqrd
 yoWRyZeP
 PELG6lWlohlyBT0/G91tQbrTOFNZwSge76oxESg/kkPvy0R5zJK/ocoZ6xH3GbaFFB/fvwgCVb7vsdjUSKv1MoaxNBiJVe8cKl68CROztkrxRz0VexkpmMqr6VLpP6968wRThMqjmEbfIwpiyftgv8T0E2SOyH5OI8MTM+2A09GLglM40rCR3bBBlnPLYYOM3CCl8SzT3vhC7MRAZQPrDr6hYTQKiwh/5gyPCHXszn2qprAyXhWFr74ZdyOMbgyPoXqz3W7xeFEvZowQCvLnpQbss83qtAfxw2R/mZ76kxZiH67FQVtzwn8h76+1ue6Z8BUqkVHOhc4pb7jDQioRc49OE3AMv8Kz85/WuM+EWz4Q9Gd47gQz562Cm/rwioMGY05PJSmR57fj8jz9lVfDdgr+1zuSc12N7uxGgiVb8xVrGhe2tBITD8RbwwFk1RzIBBouqpRT1A2ulM6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/18/26 06:53, Qiliang Yuan wrote:
> ksm_tests fills regions with identical data and checks KSM's counters
> after merging them. allocate_memory() maps these regions without any
> THP hint.
> 
> With mTHP enabled the regions can be backed by large folios, which KSM
> splits before merging. Splitting an anonymous folio maps its
> zero-filled pages to the shared zeropage, so with use_zero_pages=0
> those pages never become KSM pages and "KSM zero page merging" fails
> its count. "ksm_tests -Z -p 10 -z 0", 20 runs:
> 
>   THP setup                     before    after
>   default                         0/20     0/20
>   every mTHP size "always"       20/20     0/20
> 
> Map the regions with MADV_NOHUGEPAGE, as ksm_functional_tests does.
> ksm_merge_hugepages_time() maps its own THP-backed region and is not
> affected.


That's actually something Nico intends to fix:

https://lore.kernel.org/all/20260609114619.144416-1-npache@redhat.com/

> 
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  tools/testing/selftests/mm/ksm_tests.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
> index 5fd7792a0d479..140ea833353b6 100644
> --- a/tools/testing/selftests/mm/ksm_tests.c
> +++ b/tools/testing/selftests/mm/ksm_tests.c
> @@ -178,6 +178,16 @@ static void  *allocate_memory(void *ptr, int prot, int mapping, char data, size_
>  		ksft_perror("mmap");
>  		return NULL;
>  	}
> +	/*
> +	 * Splitting a large folio before merging maps its zero-filled pages
> +	 * to the shared zeropage, so keep the pages small. Ignore EINVAL on
> +	 * kernels without THP.
> +	 */
> +	if (madvise(map_ptr, map_size, MADV_NOHUGEPAGE) && errno != EINVAL) {
> +		ksft_perror("madvise");
> +		munmap(map_ptr, map_size);
> +		return NULL;
> +	}
>  	memset(map_ptr, data, map_size);
>  	if (mprotect(map_ptr, map_size, prot)) {
>  		ksft_perror("mprotect");
> 
> ---
> base-commit: 90201351a862182bdabfc1ad1c97b1e1b6ed5931
> change-id: 20261016-bug-selftests-mm-ksm-tests-nohugepage-1414868db0ef
> 
> Best regards,


-- 
Cheers,

David

