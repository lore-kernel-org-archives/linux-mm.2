Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 549C0EF8FFC
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDE136B0088; Wed,  4 Mar 2026 11:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAEEA6B0089; Wed,  4 Mar 2026 11:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8C26B008C; Wed,  4 Mar 2026 11:40:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A17AD6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:40:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5091513B499
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:40:47 +0000 (UTC)
X-FDA: 84508944534.30.BE03C3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C6B7A0019
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:40:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EHEo7K6c;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772642445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mYNq52qdV127ABFcmtU4dKpc65a6jHhxN1pKwz/F4QE=;
	b=ks6jl38ilOZQGc+1nmK5rW0fGfRML4uOClqkbqAddvbIAofZwQ9whJ4dXYu2J64bm+NFAF
	CZh9eP+bmV20xWHoYsgGgsdgXuRftuc5+TkEcbwC/JBIyB1foP3/ywG/3ApWp5YzOvnCq+
	BqkXek7ibff8TSWW5hqgOfPgZWFYP1E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EHEo7K6c;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772642445; a=rsa-sha256;
	cv=none;
	b=QNZLCnBhQ/JzlmN+q2RvsVEGrnnIXCec/RAPk1LartbAHSMJsnGDcMYbt4k2xonpl6zqkq
	raIEA4XwiZg+2VnXY9j06NFFrObsnFaekGqtttwq8G/kUSaoc9IuWCqWdm2MOU2iU6XBPw
	+PZXoGH4Ty3EPm4bTcwzb0F1hD0v1l4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30148401B7;
	Wed,  4 Mar 2026 16:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A283BC4CEF7;
	Wed,  4 Mar 2026 16:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772642444;
	bh=P1IDgs/s6jD+31cFkJaTA/iXOYo3o/gE91e1H9zxHEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EHEo7K6c2nr6S7q0oUoUjWljrGh/fhJ/zwA/Tbsl5bn5hdstoynPVAmx1taAW3FVU
	 5m660JYp3OU+MbtpKzo3g35U96ZZOreQKWTHEch+5UygLJ82ZJhjgUjZ4xcOdDVvgP
	 vkeO+/M4oSQ+ajYO3CSngfzTrUv7yjWzsgsrboOQyXDCkM7eKXTASJVTTRVGiQQWQE
	 Uw3eCYpQRwWwpKlI4eoes0heUeQ6/Tqgy2ISCuADEE5xhgmtnT0CBntWIXstB4KwK+
	 c9af3yF/paaEtyCrgDVlAx6bvApWrVqIgzNBomvcuRSKG6nV5lG6b/g3kz5gLQ4n8U
	 9xdI5+shor/+Q==
Date: Wed, 4 Mar 2026 16:40:40 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm: thp: avoid calling start_stop_khugepaged() in
 enabled_store()
Message-ID: <a5d7853f-03c4-4948-aad0-6d54914b6e61@lucifer.local>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <20260304-thp_logs-v1-2-59038218a253@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-thp_logs-v1-2-59038218a253@debian.org>
X-Rspamd-Queue-Id: 6C6B7A0019
X-Rspamd-Server: rspam07
X-Stat-Signature: hzd93pcr8eumbdxxuxn7u8f389yundj6
X-Rspam-User: 
X-HE-Tag: 1772642445-201563
X-HE-Meta: U2FsdGVkX1834JhZyBTWgnnmi/gkaM8xXYpRlo8Il6c2dxbK/0WgCeZKu4sKGiqxQoKiAwJoY+URE3evrCrTOxmW77Qy/rasm2UvbHx7QyvZOPFWTLSVFrz5y2KXYrN0Vb5UrLTpPEHCESBeP/BGrMWoOTqqzndXSRXeVf8S0ixki740FSLlCBT8+gV0PJ6wd39+k+A7GHc/V0N7F5CQaE9CPDQYitrbcz5R0XNC2scXBOJvTjoDkpvUWpjLZL6NDI3gq1YJKTvfmWrpXxEdQg3gD6J8crOR7qWejQhE6VfVjaLi7jOpKn2CirlB50lYNlxYe356LaXMBjiqi5y35LK0LqjIelqgvd3bS6+JqopNllqjvEo0/Sf87friT1cye4tWM/sizoSNEXkFE69qOqnmo5B8dTwpoOmJnh/ZXAaFyIsHjObwvTXjTJrhi59YM6AFGTwtjqWJW5uoucXXG5MvkjFdoWAsuwLHrywmv//g5sOHV/tp5i4BO6JpERc4T5fgIIYUWm0cdyaNFDOmzFCFCFhPvJwF3KLVP9/FQUNCmKsRDSV6rTKkIFRhckMH8MdVcpy2rP7tQJte4QI5ppI7hmUGlEtbvx38mbzJ2v3SwwyGwzgFcR+es5t9nsnoo6eJjoVmfZR9j0ls7SGHOTjXmgA4xxFbjlJhVhXXI534jCBi2YnlYNfrjmbC0S33WFIMyoLHmx8FaT1406sB+of7F9QNYveHD2Y7o6R8r++tiysAGX6n6K+OCh0Z9Nl2bc0oI8jHCPzRfiDW/caVwdllRqrNEJwUFJIddFxwNFeWBJsfdPPPSjS+z4GtpwzMJHDeHmOVlhSaf2gi8smjunnLb8c2P4nWHOjogSHBbnBTLRtx1p9K1a3IyTRbJm6XaeQ3Amvl30ykljIww/U/yXIMTMUSgqz7AGdNHdd8PZSSyg4eCmopUEB5VmtUQ2hDvd1dnWgUN54uevzuhdS
 clTFJTw+
 iP7Mw+oamrTE+mugTxxdr9hs+ki51/U4OLb5Cj0Uybxrct+kP0lKV/+gW3qdO8vi+Fwml2wahIFG9tMGmf6lvmUWvXq5OsZVDmIyECayVrIlmqPahJzyB+R0gGpn/QFFMNRjGpRr9CWwPe4v+AIZFgLwJUko0GIobtY+cvrZSFSY+yvJ/rybeXGCTF+YBeakDIFB4o2NGer2T1BybQ9afOvq+i5dV8k233joWRMMpqgvpHzHRf9bKxgwWWuMiOJMG6/C6Rfl4XUbuqGU48FRLUU6H0ytmW5PnWfCd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 02:22:34AM -0800, Breno Leitao wrote:
> Avoid calling start_stop_khugepaged() at the top-level enabled_store()
> for /sys/kernel/mm/transparent_hugepage/enabled. Use test_and_set_bit()
> and test_and_clear_bit() to detect whether the configuration
> actually changed before calling start_stop_khugepaged().
>
> This avoid calling start_stop_khugepaged() unnecessary.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Similar comments to 1/2 ofc.

> ---
>  mm/huge_memory.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9abfb115e9329..b6ed44b6e8c02 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -320,21 +320,28 @@ static ssize_t enabled_store(struct kobject *kobj,
>  			     struct kobj_attribute *attr,
>  			     const char *buf, size_t count)
>  {
> +	bool changed = false;
>  	ssize_t ret = count;
>
>  	if (sysfs_streq(buf, "always")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> +		changed = test_and_clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> +					     &transparent_hugepage_flags);
> +		changed |= !test_and_set_bit(TRANSPARENT_HUGEPAGE_FLAG,
> +					     &transparent_hugepage_flags);
>  	} else if (sysfs_streq(buf, "madvise")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> +		changed = test_and_clear_bit(TRANSPARENT_HUGEPAGE_FLAG,
> +					     &transparent_hugepage_flags);
> +		changed |= !test_and_set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> +					     &transparent_hugepage_flags);
>  	} else if (sysfs_streq(buf, "never")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> +		changed = test_and_clear_bit(TRANSPARENT_HUGEPAGE_FLAG,
> +					     &transparent_hugepage_flags);
> +		changed |= test_and_clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> +					     &transparent_hugepage_flags);
>  	} else
>  		ret = -EINVAL;
>
> -	if (ret > 0) {
> +	if (ret > 0 && changed) {
>  		int err = start_stop_khugepaged();
>  		if (err)
>  			ret = err;
>
> --
> 2.47.3
>

