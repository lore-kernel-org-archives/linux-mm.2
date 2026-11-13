Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356B7606A897
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JUJiUfci
Received: by kanga.kvack.org (Postfix)
	id 39DC96B05B0; Fri, 13 Nov 2026 16:41:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3768A6B05C7; Fri, 13 Nov 2026 16:41:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FDC6B05C9; Fri, 13 Nov 2026 16:41:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDC716B05B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:41:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 726B98018D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:41:06 +0000 (UTC)
X-FDA: 85431416532.05.5AAF384
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE2FEC0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:41:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUJiUfci;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606065;
	b=y/GXEpPu6e6DW+22/3kjl6IlkkZH8Gbzy1jdGb9BmDSv5z46YKz/GtKzueTezMft7PKhRL
	XtOdY70JTcoRuFmt448SHYoCGrxTc8itWQU34AdcJ62VT9mWUQzp4MNBsXygY0Q1Md7aoE
	UMMwYgdBTdgVK26S+Qw1WRIhQtE2U78=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Azpyo6qZejVSjZbhSbkw8eKwL/GvzZIoGcaHlgWwzCw=;
	b=MCQNNEeDEYtqbwinMcdjHSghnkeUm1pqIa1kSRIqUi0CEx8ylLzENQkdYRKw3FoZOKA5Ym
	Z0rigC/zpl9EYuSIUJw5SA9tgaYiPB3fKWBRQlz3Ec1ED49W7KXGTocbRIbTRgKa1F0F8z
	+mQKewZ+MnkU5NDy4DdvKgobMUGaxqw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JUJiUfci;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72C5D61D0E;
	Fri, 13 Nov 2026 21:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8331F000C4;
	Fri, 13 Nov 2026 21:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606064;
	bh=Azpyo6qZejVSjZbhSbkw8eKwL/GvzZIoGcaHlgWwzCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JUJiUfciR+27rcMr+AH9/thxOkwvAeqQfsQoj+e42JxNdgaK7n9gYhC9QMpqCjV7p
	 c/YVvkJdWHU9uAjGEAmKi/kWG67S/0uHIhKFMXtzw1hFYInLwf55qdedjEqz2tsX99
	 +Mf8XvRfkiT+Z8BLMegvwmHrXcCLCdXsknS4olBohbvk4hcpS/Z1C5ybpiX5ySgqdr
	 byQEA/rBEDCSoeOyZqK0wUu2LuYm/TDUHyCZ0gzidNIjUf9YoFmd4ITHcmI7B8WZSr
	 Gol5aSvcXkd4LzUrJSC+9pOWter0IrQj/gA0Exfg3+rc3GUFO6Qn6yoK+6+R5FJR5z
	 pohy6BedXa/MA==
Date: Fri, 13 Nov 2026 21:40:57 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Tal Zussman <tz2294@columbia.edu>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
Message-ID: <aveD0GCxbs0Zuq_0@gremlin>
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
 <f8b0f20d-90dd-496d-97e9-9a232124e3e0@kernel.org>
 <avd8-uVPf6BSqwEQ@gremlin>
 <a502f84a-b349-487d-94d9-aff7d9b95102@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a502f84a-b349-487d-94d9-aff7d9b95102@kernel.org>
X-Rspamd-Queue-Id: DE2FEC0003
X-Rspamd-Server: rspam12
X-Stat-Signature: ytt4i7piaqwcxxdgi5rx41ebgppgpdhg
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606064-865862
X-HE-Meta: U2FsdGVkX18TwF1y/oMeFJ5acRZN0aBq/OFH5KFLS7cFNBPnpWMgNpspKGpExwxyrW1ax5s+edpMK9j2pZhBmoE7Wo64MLSubXfoX94ZAq5bUmxze0Zz1s7rRx9Up35/YPb3l+YBXB3j+GKjNUCP5H5nG/lxThROojXhPxz2p1l7dhtgPd7ojVziOMcJg3BNew5Tf0x2urNFWDsYvltaijjWpkDN5Zc9Lzvsv1pNJekcWBvncn+G8MQdPfmkTwQHOFBH766k2Ur0aie2lzOSL53vqmqbeCd3Bt9qU4ggXpVKeRNnEMnUdV9KUoxyNQI4fzk+TEf+ZiZKSFsVNXbret4vmZigj53Mxqken8evbplb5jCuJjad7ZgxLGLfmR8Zw4brN3BN4V8BFTyxjeb68B9A8FnSZ3ommn3DbeCHND+davTegf0tf2OcK2OSgi1VWr+s4eSrJ9zuAHEQicxS5sZpRvEOP+JShKm60hXI+VAK9EmQj7DR9VmcFHqHCwlJJG27sGAbeGRDOmmFmJYo3uWfo6bWMIOYMJiKzz1fZKlu+SFaA8lJmkX5VaXp8ATUjsHT+isEJ6lctxnrG23Zvo7FFKOUUS3AOESPJGCSXuzcfMEhL0Qsc7Z6lhK+nFZxKmuAxvLXauOOGjEWvR4p5Aj4jDryI4NufARKRSLCijxp9qYAiEEgmS/7KzbvKyAfEyUxIOOEQrAfE/MYqibPfLJ/2H77PFV3EDnAYgFu2fUbaQlDbIAhjBtqNiF3jzpVvnie5zi4m9CAVdXeODyZjOVgv2pU8QDL4Nizg7LCt9QcNnXbNQizlGNE1Nk0viSD/Fq88guoVZSfBiiu6MZrXmVuKt4JvCMjrELZyALVZIgOUkWNTUVAdLNzXUYzm0fth/gic/8A6oL+cVXEsL/Cz/VHWCxqEvfCAgnxi5GGjCecVFKKnN9SO4TYB7yu4XMEwhkV+TMek3LIsw8/tFd
 /vnNRJBp
 6+iHeL/ihI2AJ7riv9/rpQaQNBrPr0k3RL+BL8+7jtm8tz86/9y3Gy4LDlWNxMl2sLPXUYHZg016FXnwla5SoWuvjn7U3sg68P7xGZUvBWlXuPGqG9Op3ni5yvcga99C6IBw/0I3HNFgXTBrvkv2uuJVoblKWUyEuk04mKUllw2CwkvzQhmH9ZZy/qyF3hMneuZoTFlblgMUXFm8I7UcY8LQdALmF1E2q+ZzwKBXn9Lr8X88RkAOLBEjOYFWPQ2FQy1C+YBlZ4KReqmUdTE2Zjt9AWEblEmGl0hedZMcAQ6KAOebsAjOyBcmxxAQVLLMw6iPHJTnpUGNdDcHlZ0yDC4zEMLDM7B94WYnFrNlKpgShviX4X7NtJZzauEBTcc0BsF6EWw6gNPGJnxoi/dPopjOE13XAHz7Zh8a/jlbHtPM0jqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 10:39:30PM +0100, David Hildenbrand (Arm) wrote:
> >>>  mm/madvise.c | 28 +++++++++++++++++++---------
> >>>  1 file changed, 19 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/mm/madvise.c b/mm/madvise.c
> >>> index 0214efd2a014..4f7728583207 100644
> >>> --- a/mm/madvise.c
> >>> +++ b/mm/madvise.c
> >>> @@ -850,6 +850,19 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
> >>>  	return 0;
> >>>  }
> >>>
> >>> +static void zap_range(struct madvise_behavior *madv_behavior,
> >>> +		      zap_flags_t flags)
> >>
> >> Two ... ;) But maybe it's consistent like that in the file, didn't check.
> >
> > I'm a bit exhausted, can you or Andrew just fix up whitespace like this on
> > application?
> >
> > It'll be easier when I have the VMA tree.
>
> Yeah, absolutely. I'll let Andrew pick this one.

Thanks! :)

> >>>  	/*
> >>> @@ -1845,6 +1854,7 @@ static bool madvise_batch_tlb_flush(int behavior)
> >>>  	case MADV_DONTNEED:
> >>>  	case MADV_DONTNEED_LOCKED:
> >>>  	case MADV_FREE:
> >>> +	case MADV_GUARD_INSTALL:
> >>
> >> Huh why that change? Not spelled out above.
> >
> > It's just the established way madvise interacts with TLB maintenance.
> >
> > Anything that uses madv_behaviour->tlb has to return true here so
> > madvise_init_tlb() and madvise_finish_tlb() do the right thing.
>
> Ohhh, I see now.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

