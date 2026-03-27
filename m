Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E9210ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC086B0095; Fri, 27 Mar 2026 09:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2036B0099; Fri, 27 Mar 2026 09:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEC06B009B; Fri, 27 Mar 2026 09:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 902DD6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:06:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 591DA8CD2E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:06:55 +0000 (UTC)
X-FDA: 84591867990.27.88CE843
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A5B69180015
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:06:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESs5wAPQ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774616813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kBrjk8FWVewwSwvbNWEfmMb7agE4VkJFDgApLsE9es=;
	b=Lfrk1uI3jDPLjK+O/qv1vBMLsZKOGwDetYcR5Q0Xc9ORaiksnWrdrCaMew+fcr4k3gwTr1
	gzhUh5PFXZZy2rvOeGjmgjPFDNKz2AB8gsXy4rXcsZa3R6VJ6ElquzCQornY4a6WuwndbD
	c+LbWhXgCJHF5kARvIUGCeAHAXW/Ny4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774616813; a=rsa-sha256;
	cv=none;
	b=kBNkR6FXXlzS1501sCp1NlepAkncrfRbwD2QZSa2dRBuibxpk+ZI3TdrhG+IGc3HY0N25G
	53eUDpV4BpPsnYiks6cxTHT+qCbx71+JGK12+VmvthkYSqYWD8XbsNFz7d0MUUB/q9W8Va
	QqR222jBHNPIqsmIlQLdygJLh5ZxQ5I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESs5wAPQ;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EAF660103;
	Fri, 27 Mar 2026 13:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2916CC19423;
	Fri, 27 Mar 2026 13:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616812;
	bh=T6zhnYK1CSxgWl26f7UE87XgwORwUJZ0zoolakMA3Cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ESs5wAPQcVULuQ7S7HOjKjH8K2FBszktECzFfHQQXJ0+q/smu1H3g3rioWCecJWCC
	 fbRmqDxo8x3gNaTs7qh/dsuYs+wkC+8NzGF8a7lmkDNi8mH/GP057TD/jiDv0EwBZ6
	 gNCncafuwfUhUX6FPMSqCs9odJp+RPrVHoB4sV5hfxuqPmgW8bd5D3C0F719cuYK9G
	 cD/v5R+gEIiL97io5O8wIFlnHDiwTjDEPk3KJ4UAh+KP9G09J8oOqCilEAMDvI5hu+
	 zuWoBsxH1T58iVn4s68sOXe9gCG7612GZRvzjS4o0nmHdqMPYAx07pvA54PE1njAm0
	 A818CiAVQGBiQ==
Date: Fri, 27 Mar 2026 13:06:50 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 10/10] selftests/mm: remove READ_ONLY_THP_FOR_FS from
 comments in guard-regions
Message-ID: <3f59afdd-1f55-43a7-a390-6160beac1a16@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-11-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-11-ziy@nvidia.com>
X-Rspamd-Queue-Id: A5B69180015
X-Stat-Signature: xuxuy3ohp9e3g5ntm8odrccxmsb69hxx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774616813-364197
X-HE-Meta: U2FsdGVkX19+aJ40NjwEAjiI0UtfhRmrPYgf2X6OT+pEZaebgJI2T2sOf9duOeUJo2FsMemKIUSHDqsoe7Wlz9RmtmrVj4En5NG1jecpx3eegQ3o/fn9APvW3x2HRFU+WgLUGRwrdUrA4X5Z4r263rGljm5CQtkF3Wk4W7vyTu0v45x5vkQ+1QbiUg32VIa8kv+RK9rw7V+Ol8edYx+V0AHr1H5Gu2I9NN88bHQ0XVBLF+E3rWI9OvvTNvdIjvNriK53CTOmm+/xoIE/5OFJ5DkITS7FHp+ccXU/nmnQS2lDi1zNaC192bvyxL4MsgsI6aHkhB5vcivvqlxWUoQ3f6i3h/Nzknk4w2GkPFAF7VRpagpUD/wA6kBRe2qmc1zXO3zVTZR6OsXeMTHUukFLPp96Hd6676wCXxDNdBIam4neo3CZfwzxxYbDOhjoLhrGe5Xxq4Li97SmLr3BxEqBU/utXYx2NpCzVzv+hgHidBu1ex5YjTIqypOyZlm2WfNRBxWPD8RoxlwdRbMFKoyuQsiHtBAPPnmnI4PcB9EuiK5cBHH3qvfRPE9GZPUQYVxSbWNAKL8gv5oeAaafkY6Z6J5VGnW0qI21OnUYdGVgW2LnvSi7lIn3v0ns0jaoqeQnGe5Kyp0LhIXCQpgaExknvx6OhsWXkZlcgoNNc78U83CQTEJOsAmcMFJ4ZgPVjKB9aYB1MfL+QUU3OfsYvzpEtajUSmBVWeQecqWefRpgQHdSapIp6rkTKtndQb9LMg/VkEgGJoRsaXls6+L8CJvs5rJ0fM/jlxeWS+cg49oWr5GmYxweczy+N7CW9tT48btCCzfkSbRGOu3JDaI+gs8VMcF+uMgKIwHAEZcDd7Z95zPht+ZeviywZqF0GSGywjW/d7MlUE+gNPMn0zCherGySmRmBO271047vIX4NuKZrZYfHXbSWa0Mwx7rd1X5v9aNVaQ0DvFUsZJNkbwcV4m
 Ycjf5cpB
 1tfzsKOWAIzR22PDXpcbTlQXqhTEGrjObdBJru4oMCa/E/kkG2doDQnyo5SU/HLzBs+NacO0lMtZ+B2uN6P7f3JHHIy6X269H6jekZTKC8/L84SeCQ6fQOdLDHMjaCF0NxOv+GEqDm10fIiOWnjsJLDFwCyPpna5dj/q6p43vFvwdq5TUO8KVY+TjO1bvyaegH9T14ak/Lc+XMctcdDabXXJVhcYe06NazH8NF28T6QIx050yXBMZQSQuvVbjc44u/ajEqcDvf6F6G+v5Gwmu5XbGCwHnUgXInMYxhx3yt6eBFqpJY5iDdQ+kkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 09:42:55PM -0400, Zi Yan wrote:
> Any file system with large folio support and the supported orders include
> PMD_ORDER can be used.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Thanks :) Wondered if you'd fix these up :) So:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Cheers, Lorenzo

> ---
>  tools/testing/selftests/mm/guard-regions.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 48e8b1539be3..13e77e48b6ef 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
>
>  	/*
>  	 * We must close and re-open local-file backed as read-only for
> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
> +	 * MADV_COLLAPSE to work.
>  	 */
>  	if (variant->backing == LOCAL_FILE_BACKED) {
>  		ASSERT_EQ(close(self->fd), 0);
> @@ -2237,9 +2237,10 @@ TEST_F(guard_regions, collapse)
>  	/*
>  	 * Now collapse the entire region. This should fail in all cases.
>  	 *
> -	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
> -	 * not set for the local file case, but we can't differentiate whether
> -	 * this occurred or if the collapse was rightly rejected.
> +	 * The madvise() call will also fail if the file system does not support
> +	 * large folio or the supported orders do not include PMD_ORDER for the
> +	 * local file case, but we can't differentiate whether this occurred or
> +	 * if the collapse was rightly rejected.
>  	 */
>  	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
>
> --
> 2.43.0
>

