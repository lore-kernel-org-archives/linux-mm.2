Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEBFD606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FBzpQf1l
Received: by kanga.kvack.org (Postfix)
	id 1C4176B05B0; Mon, 16 Nov 2026 10:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175026B05B2; Mon, 16 Nov 2026 10:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064336B05B9; Mon, 16 Nov 2026 10:56:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D11A86B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:56:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0742612018D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:56:39 +0000 (UTC)
X-FDA: 85441434918.10.4029DEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2890714000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:56:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FBzpQf1l;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844597;
	b=5ODdKkKge+7qDTHw4jZvLG0eZosenyxuAycyIqjmIegQEtOcRTjimAEGizjIzYqvUQWQBb
	39PHOV9MbSCYgL77sEzJTAKGgsYN5FzvKdO3UWYvWnW7BMYWgZ6rCfBdvUJItIeqqZCHlb
	LmbviYLmRRUPgZFkVr+WwWcleM511Mg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FBzpQf1l;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgPxeiUJRyViMR/kj5mqSYPm2eyojXcdKm74GFnc+bA=;
	b=4HEaalcjVHmdBkan79dVjJAdv3Tyq4NEPzSVehbqmPs9ffCO8p3h9E+IJNE6xCFij5OQHs
	2vDTU1lT2h4NZCDLYS6ZcfLeulZVUr5muCmFRNOz/Kktlv2aYbJHssm8O6wSNVv3q3yzEc
	/uQc4l4x7qKtsSrHtirp/D0hG+1Jq/U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FB14446CC;
	Mon, 16 Nov 2026 15:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034AB1F000C4;
	Mon, 16 Nov 2026 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794844596;
	bh=FgPxeiUJRyViMR/kj5mqSYPm2eyojXcdKm74GFnc+bA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FBzpQf1l9uSBXsX5Zbe656h3VxdOG66OXA2m/iZqJIJLsyyy68vo4ubhofTWSUqKc
	 K/vRG2VFIe3k6jqjZQTU5R66v5b/FUB24rSnCNio+WT2tGgJzAxVfdt5MHNNr2nbsp
	 lC7nOwqYGfvjCK88mSyi5Dm4vdBlYNgfZJkXIDQzUFzT+TFmBrMZRVIisREusYT/Nt
	 Yk/e/xAdg64zVgZmycHjvyDC1ke6RHPnOcvgucXYiUcJFW5o0o0XGibySurtPB4Xxj
	 ZU0EzntYG3Z2fr6WizXI8C8DbISbL7nUw51MVZLCQvTYCFDBaeexdtsvextvTIl4Ju
	 cxCz6hEhP538A==
Message-ID: <dccf94b3-b901-4311-a233-488c87195dc5@kernel.org>
Date: Mon, 16 Nov 2026 16:56:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jg7fjg5mxksxes3518zfzd4ufzq54ux4
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2890714000D
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794844597-503432
X-HE-Meta: U2FsdGVkX19bAqCQxuNSgyFTDG13oZiribrKmvct4RYBvzA+OKV5iMmIGMrLZzvNkaaKhdwjfjKfKr7vWFpeRzSn3pMWPGBzIWFxOhm5hZBQG+bVp53qgxYLBExfFcMQnE6J7F+w1okFzf8Lh/h+7p1AnNE3rzg2fiyrbm2FXXopgz1g7tPRx2VOncOT7U9nKCgDOZZk3gWUhWJYoh7C5SZl0ycB4Wk1F9spC4BLhtb5WN0eFsyjFqz0Ybcr3P3s7zNnFQDJTJc4TyB/L4MIsRoUo+h6Ygwqk4YISrjg+hu713lDfVbHVzMSwViSVxpfIc2u5q6JLwTBdssvpSCKAGzC6S2/fcBvCNIwn+WHyzRDhzsNRXrcvhT1/qcyZiZZujsuOJlInsAVDalX/YVjUdaKTAV6z7AT2pRpbN5DBX9l958A5QKlrk4+op5GmkMzne4PMLLBTLHWsHgY2x+UUO7BCL+vCdXZSMV34ijPVQXpxXfobW5jnkbDCyFiq83c3iHzyHEXF8/ynALcAxu6wO6jpQmQ/GK0Tfcy6SlEfPEVnQj4R8UjhZ9dnQyo3C7TZ9zfMkMF8z6ObUsxB0V4HEH88hAhusejbdS2Khbk+VCrVzxvUIbPDfceuqBg3S1PFkQ6/59NWLD41KMrJH6jR9IE/YZO3XCH0b+TF859/5L3WwORdAd1qr65Prus6CFIVbIKBv8AoL3hS8TQXifG299oFwCET5gJ3nNmqALySFd5RoCkx0HleWmZkRBy6maHL+aSAoYiCrwTA8O58MbMApMZ0YmEg/5eFOYn8s/zYykvazmPM/2zDX6N8oSELI1CshST1tyVv3Ep+imiPNalOG9INJtxyp6V0mflZIFwXwT0Ut5jw1EzW2opAm33BZMM93NGPcU7ps09JDaBgG1+fS4okWXTnYpWI5HaUv3keGKHx6iUWBZPOyM9cU/ZNqj9P8PYzjI+dd7jKhPp92o
 +ia0sCDT
 ojiSXt2FW3CzDrpBlsi/7Sllv2Q+u9ZRzqdBnsL8e5iLGmAjgDuU3IXgGJua0DRtjN8GzfM9shtkLAPPQuARLNu+R7p8HNfdGjEB29UGlKr85lZnsERkcpfubVVVXFEfHhv3dth2S/j7POh/wV/BNa2t/FR15fFOn7uJMzWOR8ulIw+OOQ1zL62EEWE5Q99NI8XlzU7kd7eojo3s3CJNHkle/u2TBRWbvHNcOFpYXc1Li8SaI0nz8cRnHavBQZ9/+xy4KXLOlcU932nb/8Tjg2ih+Vn1uCggCTXzhMY2DTah7ZkASHdONKsvOdECVCmOFNEIZzfwemvX8L9/2wBWJuLT1jx6ht/aKKgiT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/15/26 21:58, Lorenzo Stoakes (ARM) wrote:
> From: Eliav Farber <farbere@amazon.com>
> 
> walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
> so without holding the PMD lock, so the assertion is only valid if nothing
> can concurrently install a huge PMD entry in the range.
> 
> This is not the case for a VMA whose driver implements both ->fault and
> ->huge_fault and which invokes vmf_insert_pfn() from the former.
> 
> The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
> takes the mmap write lock and faults taken under the VMA lock are
> unaffected by this.
> 
> This can result in two concurrent threads faulting the same thing
> disagreeing as to whether to attempt a huge fault and thus ->fault and
> ->huge_fault running at the same time and triggering this assertion.
> 
> So just remove the assert.
> 
> Target the commit which introduced the first driver able to do this for the
> fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
> them using its own mapping entry lock.
> 
> Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> [ ljs: rewrote commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/memory.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 3a20d64fd276..e03110906aa8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2384,7 +2384,6 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
>  	if (!pmd)
>  		return NULL;
>  
> -	VM_BUG_ON(pmd_trans_huge(*pmd));
>  	return pmd;
>  }
>  
> 

Could this also stumble over a huge PUD somehow? Should we just prepare it for
any leaves and bail out if we find some?

-- 
Cheers,

David

