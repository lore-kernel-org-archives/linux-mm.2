Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C70FD2D9D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2906B0005; Wed, 11 Mar 2026 05:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72E96B008A; Wed, 11 Mar 2026 05:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41926B0092; Wed, 11 Mar 2026 05:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 915DA6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:23:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C2971A06C4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:23:53 +0000 (UTC)
X-FDA: 84533245146.18.ED30B83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C235C40012
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:23:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3IeJ4ey;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773221031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfPraxFdkaqS0kx0duQiyj4taNj98v4HWAG6YtoTNt0=;
	b=31EA0kPLyWT6qpx+LePAU097Wgd8J4rzvDd3d07cUneVcPcSWaDBdEgqPfhG8/xTf9noH3
	goSrqJ99FcuIvPzkvkyJ8HWGK6El56HCzcqxTMVMpnOGXFbayjRSszmQtkT2mGvVjKHRHZ
	6uwJzDSB2K7alEmgNAFWhmRcVqhnr4w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773221031; a=rsa-sha256;
	cv=none;
	b=GH1gaMVHbuCfaI/0WUd6EiAivrSeRgVCZf1UDAQN8lRDKHGC2mmCk8dGPVU4plJt5HPCrJ
	mkp1xlm53R7tCwrKSOUdSz/pUjrhPS4x+J+eKe4Z7dbjeYzd+UYH5IKjI7K7ajH27WZzEP
	Q11U+U6gEsdopvo0Q3j+0Eq2aSo5n3Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3IeJ4ey;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27D1F6012A;
	Wed, 11 Mar 2026 09:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC316C4CEF7;
	Wed, 11 Mar 2026 09:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773221030;
	bh=ByWAeQE9S6a6Rm3GYQayw9ffGdHFnSKIdchpQkSsNYs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U3IeJ4eyjdHK2PYTt+RGDDXR/90l8qWq/k/uWhEW2Mbg6cFmCN7WzPm7UmPlR3cG9
	 w3zIUKVc5tasMjCGlPFTR6fQP+6OAm0SzqdMSD6h5PxqmaXNhN2pKq/xcrvDWqAHsg
	 d0NvSkBozWz30bZJMXWzxLQTLw0F3p4hNFwVg7akWgNjREo+4dm8GkgfLGz14mTUKF
	 knGXjtY0fgdxK5Y/caynXxVMheMNh9wpnNzIDa+rFfMFlhgEc2OiCkTvpwolU7wAlD
	 MFtNGnO2+jGkUk7zHq3quLPkq7FTGMaFcq1xbHOpTkUrV8E8cP9Nhb/0bHMxO32m7b
	 j1yubtjQyVd2Q==
Message-ID: <946b13be-55a4-4d3e-a931-0793bf22e28f@kernel.org>
Date: Wed, 11 Mar 2026 10:23:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: migrate: requeue destination folio on deferred
 split queue
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260310105419.3256755-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260310105419.3256755-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C235C40012
X-Stat-Signature: bdqxwuuqwdb6dt38stfsq1qtf1uxgmes
X-Rspam-User: 
X-HE-Tag: 1773221031-309341
X-HE-Meta: U2FsdGVkX18UHc1eGHrjxeVkOKQ23Nq0xaiQcYnStM9W3gNOX5J1ih1M833/J6JFlXgR8USkJ2/mNW9s3Uiavdn8VyXbAAfVOKj74/cuOLE34WXI1G2RE6PYcE2WBYlycRe3sjVVcgVlycAx2c1kC7bji7hdQvgJu6d+g+Ov9bOFjbfOJHRtoImVdO2b2BkOLN6d+iIGaZtf7jefgWq2cuoSz3PX4JwMLFpqIMRtKBwl6dTx05TY7d4gJbqk6VevKdksbIPjn6m7SZ0HJwI5lKE65Cd2MUBZ2UuWbtvNnbUwbV4cnLSDfaYd+sRkmHYXBxww2C5iCALTc6qgn1A+oGLJsWf0sMJHGUb4QMFGX6iFNB+7Qxt/B5S3ffvQRlv1ir+ok5pctxDZkePS+FToOgdXr4H+8fknJ++xvhWGTItfolk7Gv+2vk9lAPnllbifR6nLy20gOaWLETJA26cRiTK+eYZPlIwOakmtHt1qxT1XWh34WGW97b7+Km0YSbYLxX2G0aav1gq5MC2gpxOPL6hwJGMcump1gsnXTrfPRtq4spQMT79JIleEZV9Aw+crg8EQlaOkznTm17UlyvCBWbC4ax0mtNJmha0qcQcKygbc125addtB6KO7PXbEN1vqBLS3BAu0J6+Vemo5a5oPdzZospEva/ndPtNKt2ZbQCH4W4LKwV7Wsq9Ynj3HgSnaXhdQbnvawIcZcgL1EDo/grzPxMQ+U5HyhF9Lk0ew7C0T9M813PSeUkkCwd3X8WjK0wluy+gdE9XKDkw6QEtKXzxYu0y1JrSHEu0xyzyrCotPIl6pq7sBSWtqiv6pydDIj/Hu7KRqOkFd2BDwNDU84sqfhrSIhGxKkKkKsSXlPB/KH+gyyKvKDzX9ss7ol9VTU2t/n8BHTR9ZclfWHH9SDSYfv4vHl9d/RKKPbZt4DET9kXiNstSUkCnQN5Q7Lp4KtHMcZjdm/Asa1hgO+UH
 uE5lfhLM
 Ly8bG8drJ3dxb3BtZwpt7w/T982ZkE4bYIjYQdxqHkuWpHm3j9QzURrLJFX/5GsmYNff42VFMU5M/Oikp9++DOmuN+vAxPX+jTbJck65E1dIy24AMPNCKdXY/Rt7aJX/V+DaKvvEhTsqDv3GlM6w8g5dhAXvSf8TevUKhqqHP1VerioaeKxyVAj0O5FJXuf6KdcR0RAk3Y0P4uonC0U6W2+B7GzvaqUm7Hxrxyxn9mV3aq0Qe3nvNTc9xP3ta012xTtKOt5xTQuaUOovca8N8848b5qQW7WfCdv77ZwGlWvaNDuT0FBP9FP49XLaMvJjct9Aw6ZN4VI/lFiWdt7CbsoVDMk7ih6LhbnvvF6eMOJZAh4KUTVv2/DZd3Gv7Ffv8S7dgXU6LO1MVGlQpYAcRKZmAo+Ftrytv6b23
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 11:54, Usama Arif wrote:
> During folio migration, __folio_migrate_mapping() removes the source
> folio from the deferred split queue, but the destination folio is never
> re-queued.  This causes underutilized THPs to escape the shrinker after
> NUMA migration, since they silently drop off the deferred split list.
> 
> Fix this by recording whether the source folio was on the deferred split
> queue and its partially mapped state before move_to_new_folio() unqueues
> it, and re-queuing the destination folio after a successful migration if
> it was.
> 
> By the time migrate_folio_move() runs, partially mapped folios without a
> pin have already been split by migrate_pages_batch().  So only two cases
> remain on the deferred list at this point:
>   1. Partially mapped folios with a pin (split failed).
>   2. Fully mapped but potentially underused folios.
> The recorded partially_mapped state is forwarded to deferred_split_folio()
> so that the destination folio is correctly re-queued in both cases.
> 
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> v1 -> v2:
> - record whether source folio was on the deferred split queue before
>   move_to_folio() (David)
> - record partially mapped state and update commit message (Zi)
> ---
>  mm/migrate.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ece77ccb2ec0..61013d258eb4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	int rc;
>  	int old_page_state = 0;
>  	struct anon_vma *anon_vma = NULL;
> +	bool src_deferred_split = false;
> +	bool src_partially_mapped = false;
>  	struct list_head *prev;
>  
>  	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
> @@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  		goto out_unlock_both;
>  	}
>  
> +	if (folio_test_large(src) && folio_test_large_rmappable(src) &&

I don't think the folio_test_large_rmappable() check is required. Other
folios we migrate here would always have _deferred_list initialized but
unused.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

