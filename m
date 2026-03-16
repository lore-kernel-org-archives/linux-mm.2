Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6BFBEFCBB6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597436B013B; Mon, 16 Mar 2026 02:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557BA6B013D; Mon, 16 Mar 2026 02:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E636B013E; Mon, 16 Mar 2026 02:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 38C416B013B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:25:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D06E21A0412
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:25:55 +0000 (UTC)
X-FDA: 84550940670.01.9A6E063
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 36F1C40006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:25:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/MW+09j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YercUxTHh5C4vRNc+OkTxEWP9EoAmI0s00DqukYUuZw=;
	b=TnBAMGqRQ2b7Jyk+4gEBEvRC55IxIeJbvoG6N3BU9qLZOKw1MYhtifourknoKj/NNKY0W+
	hkFta6Oh3TrlpOyk5SiBMRq5jbev1LeBUkJyPWksm0H+wqwH+eUo1PDMAJMPZAKZPHrs+a
	vDP7oHNpvnnCIArJcH3bAYikNoPgTlo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642354; a=rsa-sha256;
	cv=none;
	b=eH93ea02xczwuh4hrv5/u/B3OOqimlb/sqnSX/MccFgtkXAijBj0y8IDSkLJehgddn2SHJ
	zkgTCvGaRe3mZCB/jQnYAWXyk8IbLoZtLGJN4a6SE2Xrfe4AtYfl6iG8ynV4hQOoYVQ2so
	t7nEHfFNNX/G06+nWZWka2cXuAE3yZc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/MW+09j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B133416E5;
	Mon, 16 Mar 2026 06:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3320C19421;
	Mon, 16 Mar 2026 06:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773642353;
	bh=lCqBqiMY5//on77MUeD/QhHuGUd+SE7F0UXKstc9vUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z/MW+09jFA/OhJA/HW2HZKbOEn2DEwsGgatWz5PzNIk6U9inP/ZIvlFxRggiUXuDL
	 pzc9il0gfSF7NlYxy6HSUgBJE3zVW6ryQDAubEH3GtyrwwubmmHeqasMLY8hzaYH+P
	 7/baj1FlJcZc+4YXkJ+HAiE83MKRguFXofKcrQ3pXDcRBEmGSDYJnYz3+NaioPd+mW
	 WJxqBCc7yA6qXUAcdx/B54/0zDn5J0aoicTzPytPQFtjomsgH1cNbaKiadTbKo3xlA
	 TT0DyUD9WiEUZX+pz7YIO8nyqEmTEOVzNe8/BfuIEyZMD1h+s9mcnykRujdVSUh5S6
	 CT5SvRiXcaHsQ==
Date: Mon, 16 Mar 2026 08:25:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev,
	Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v2 2/5] selftests/mm: soft-dirty: skip two tests when thp
 is not available
Message-ID: <abeiZtDFW3YZMebg@kernel.org>
References: <20260316044335.1390608-1-chuhu@redhat.com>
 <20260316044335.1390608-3-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316044335.1390608-3-chuhu@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 36F1C40006
X-Stat-Signature: 6xjyzepu4r59mgc4zkyis4ieonxkkx31
X-Rspam-User: 
X-HE-Tag: 1773642354-36952
X-HE-Meta: U2FsdGVkX1+NgXYWg+OzyYjvUL/2ADt7WmmOx2+DBjjHETSe3DACNWYClW+WJShSOfR9yaM6r7/bkCt39vsQifj/1ZXnyUDtM6LF2ANZ6pabHCqLDWOnoIJ4XPaQNSE+u2+YoQiRs3M2WABJe3o4QCpzbRc8CyFK0k031rU/Y6Wsb4c3rqe3Cr1BSc+YZJyzpG+HYaw6dBtivC0pqg27iaOBOjj0kfbvm3x9VXC3Bahczh9DxRPFCcAvjIxQt1ujGPS/VTOd9d76qw7UZ1bHzebqOqNzW4XFhofkNlb1sVuqvsnhb6gxK2rSeNqnpA+2j0LuprM+XHF/Cx7GS2nOOPu8XBDzPwN9Qc3Kvsokd3TbetPjI/RjGqmv3FXRvUcrywI6Jtk/BLSHH6Hhelev2SLcLDwur3ruOJrqQ4yLSUO9aHkks0vYKkbglojrxFSEJcpKp/bNoaQ5MZzhBqS9/J1OYaVkRQCF7KfSHV0U4Q1tvz7eYWhO+ur1Fm/sTvKLedFLe9Ao+JjpFC/w+cLAFPp04FOvBZBWAXVjLnrDVOnYVEZKbEip4TnheNQOxpnLgPFhxEQxu4I8s6yJ2E6hBeKfGM1RZTGIwgr6TErzN1vYQ2k9kQhRNYD1MuwYzvGAhVcqc3mronwadvLwPuwr+dIdbFO4WnPVeqI1LeciwTpJJnJSUGLkYsB4Rd3ngM76gjIhNQ81V6797uHVSWhCnfLtif2oFkcJh8aEYdOHR/vC8YuYo3XjnVGhgmNkESnAPE/Y54CictLgpTvGfGfsl/Xv9FyIdz81kVV3yd8BlzrdL4HV49O9W08MdNYLzXsteh3bSVPuv/hvpAUJ7WZ1NSyjrct5o9dqR5Cu1J8AamAlQoQsgQE0VNTbIvcINxr/NLH6Kbj7kZbfmFxxv3Q19UkqIqR8Tq33PvU52RjC8OiqtYtroKax50Jlv1a2GRv+Q1vXD7CStLV8veGMIIn
 0TbOFqYw
 8GDYXva/Q2gBrgpmoORIItGtYxHDLlaJLfyL9AgjvQRqQcoHnUg8Ibqfdpy70XybObfWUTt7CVfezCSsCYUSNoeKT1RahKxmu526gtAcSZXBXnMa7wmCls4YNWK7MvBgE2/MGsr8MScgKxXnla9NTuOKJUlZ1CtAi4uLJXpFWNOzWdXldKq7hAYV1c97g5Of0Nk2qmv12DPimSbuHN2sUwFpKRTj4OdofznUGiULKkhMxAgGWtOMFSSUSanQuYAuiv+wBdi8wy9ovAqZYwbYL8lyNGbZxiwmfQwBmsqUTCyixMB05nzL6Yo8hLgGnh319V8dU8L6SuKDwagQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:43:32PM +0800, Chunyu Hu wrote:
> The test_hugepage test contain two sub tests. If just reporting one skip
> when thp not available, there will be error in the log because the test
> count don't match the test plan. Change to skip two tests by running the
> ksft_test_result_skip twice in this case.

...
 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
> Changes in v2:
>   - add reviewed by from Lorenzo and Zi
>   - add acked-by from David
> ---
>  tools/testing/selftests/mm/soft-dirty.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index 59c0dbe99a9b..bcfcac99b436 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -82,7 +82,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
>  	int i, ret;
>  
>  	if (!thp_is_enabled()) {
> -		ksft_test_result_skip("Transparent Hugepages not available\n");
> +		ksft_print_msg("Transparent Hugepages not available\n");
> +		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
> +		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);

There's already similar block when the page is not collapsed, but reworking
the test flow can be done on top as a separate commit.

Feel free to add

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

