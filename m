Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF580C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86A506B009B; Wed, 29 Jul 2026 22:23:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F46A6B009D; Wed, 29 Jul 2026 22:23:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC256B009E; Wed, 29 Jul 2026 22:23:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8E46B009B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:23:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0190A080B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:23:08 +0000 (UTC)
X-FDA: 85043845656.01.72DEE57
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE7A980002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:23:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aqUhF1r8;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785378187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OzJvIZWBkrlBUTwSYt4KpI5s4IiGKcT+hyE09Mh85Q=;
	b=j3DEhYgkZXSDA+Bw++T/FJqJ6Op8HJCTqHY9hXpiUcJiIojTrFDqb4CsUZXH1M9q2eHdIf
	VPrisD5zjCTWIo604fZDGL7+GFhlcExgqoKJ7gETDPsOuGY5hwvc4fsd/Nb3FCkvj7XMJO
	Z8GN9PxGs5P+z2whZGpbXw8yCI+hTv0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aqUhF1r8;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785378187;
	b=bbA6IqYwI72yEOlJOqV8MvzujHVKeScSqR/x/y3xEwxzbRAg8mTRKN4qqG/Kub7GG7ZmO6
	MI0vE5oyuFL+Y+sjl3Gb4HdhombPfEuvE9YX7msc2wlhWiITZU1hePDTuK7uOCN5pCc9gv
	6NhzfFrY5NWyfksRaB99Gg//AG8jRwg=
Message-ID: <729c578c-e5a3-4351-b07b-469f79c26b0d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785378182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OzJvIZWBkrlBUTwSYt4KpI5s4IiGKcT+hyE09Mh85Q=;
	b=aqUhF1r8sA+y1aEGzL5mQ/o0SlE42ZUyiYPmyX4DvA2xKhPbDojKhJ7qCHB3LPxZ0AGR+b
	hfVUsumPeyusmh6hxUHvoZZkj7WQqUFGaJXDJ1r6tRggQ6/fvvc0g/Xt84Tncsxne+3rJ2
	O4kxF1JHqFvaVVkwFcAx47k4br5ZBlI=
Date: Thu, 30 Jul 2026 10:22:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] alloc_tag: expose profiling and compression states in
 /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <2614a3a2f5cb11b63e3cacdcc8ab20a0fe7ae972.1785365110.git.abhishekbapat@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <2614a3a2f5cb11b63e3cacdcc8ab20a0fe7ae972.1785365110.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EE7A980002
X-Stat-Signature: x7zgco9hqhmw3s7dk6o7en4mzj9n3m6m
X-HE-Tag: 1785378184-395624
X-HE-Meta: U2FsdGVkX19APvabixY0ZgBBR7WCtsPtspjurDR4njtnCnKnv+4obaDfTduXj5xkNQ6mzUwFmeqPj3GTj/1JOt1QsNOnMVdceLU8UElWIRRn4uHeEXcn1691fHJ7ot0O2WNmTZ+6t1RnLsIw9iQ5RVEg4Jk+TOsYFQCg1g2r800NTDDWaNIrcE3cDrmcgQlQkbhtT3BXHHuR//55jjFAa9PNjjPHh6ULZ66ZaFud5UaCwTyg93m7POhXiNABJR8SxHbB9tderz0T/KH2e4Qatszq+twBbZ3gQxIBYC8hjdn+3MJcdKEvnFDx7dGOjpTaBRmkcQLvOHxYGXBP15QCLJhTvNUwp3Oghwv/gehiOOYQumVuxE5YbsxE8f/Jg6l/UDFWW+id1YDEAAijU5o8MQatUERgYnNIOvg0gwVzk63p9uklqJVJ1idNoZRbgMOIlP8Y+ETUbmpJ/U3buGvo9Igw8YmJYRgNjcvGmELc5EFKMihzs5qKUL2VujZU397O26kNSYGXvm+TK4NgSqFBBR0jTOuYXez7Hqz6ZjSP51kUnHXmvF/rz28kfCHXYSHjXirV3Mn7c9d+G1tDbcQaOAV90txdQWCSZ9XyNUFx58k6yRMS86ZhCqGlNlwyKO1vmumxqDogMYgvw2CPudquMtSFLW/6ctWmPXBJXA00htN5rAzbsmZ9hiROGG/92vNv5nbwFTYJwWp2RM2f1oOZ90/su3joScSQKD31cQlGnq4F4SDK8f9taKpLG2u2ZTHCbvrTR1Hdn2IVs75l4c3gcBqsqbiflqb8WN+a6xcosNCgecPCM2Td75lGzGnc1MYczvfCGXhAJRmq303LQ8JzqEzCn239LGvnAEMK1dyo2TEAApgLN09eXa9vUN+rLclhLCBKorzG+UucuUdB8DFYreVeAr5V3FbZSvEtSCwc6QDEHNEn6Ewe+WnfGt3x+ehPGikKPaQB+1J3ijZzPXc
 2gewB8sy
 Iy0yllYXWNRK44WdTUqFKCVYk7SjloVq3bxOJXR0vf78T7rO2sTy4NhMg3FxNIK+d6QtO/Vs4RdPEZ0lFw2a+5RWU4mI8SkFLoBOkO7vrxwl3U0iy8RbHlpZNSb73T8OpN/xHUhUKMfwiAmcMAJ9k9dXo83vNphKcThxhpYb/u8G4/JmiQEptWGpnkfeJzyoHTfLeAc0Ah1Cugnis59apC/x/GH8xNTHevZkMi4boUP0LxqYY16DRe/wDO0egAJTFgth3w0Z4P7mVQHw12amflV/qsx3GT5t6nr5u8V3REzpwJOi855gN4mRFhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


Thanks for your patch.


On 2026/7/30 06:49, Abhishek Bapat wrote:
> Currently, userspace has limited visibility into the exact active
> runtime state of memory allocation profiling and its page extension
> compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').
>
> While reading the sysctl provides basic on/off status, it is currently
> impossible for userspace to natively determine whether page-tag
> compression was successfully enabled without scraping dmesg boot logs.
> Furthermore, since /proc/allocinfo remains in the procfs filesystem even
> after profiling is dynamically disabled at runtime, simply checking for
> the file's presence does not reliably indicate if the allocation
> tracking hooks are actively running.
>
> Resolve this ambiguity by appending the active state directly into the
> header of /proc/allocinfo.


It's not obvious to me why userspace would need this state.


Suppose userspace reads mem_alloc_profiling_enabled as disabled, then 
the profiling

gets enabled later. All allocations generated during that intermediate 
window are lost.

When users later cat /proc/allocinfo and see the enabled state, will 
they mistakenly take

the output as a complete, accurate record?


I'm also unclear what userspace would do with the compression state;

this is just an internal implementation detail of memory profiling.

Put another way, personally I'd prefer /proc/allocinfo to stay lean and

avoid exposing too many internal implementation details to userspace.

Unless users intend to dig deep into how memory profiling works, these 
extra details

will likely only confuse them — most don't care about internals at all.

It's similar to how we use APIs: we only care about what an API achieves,

not its underlying implementation.


Could you share the concrete use cases for exposing these states to 
userspace?


Thanks

Best Regards

Hao


> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>   mm/alloc_tag.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..89ec2c6ce57a 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -108,7 +108,11 @@ static void allocinfo_stop(struct seq_file *m, void *arg)
>   static void print_allocinfo_header(struct seq_buf *buf)
>   {
>   	/* Output format version, so we can change it. */
> -	seq_buf_printf(buf, "allocinfo - version: 2.0\n");
> +	seq_buf_printf(buf, "allocinfo - version: 2.1\n");
> +	seq_buf_printf(buf, "# Profiling: %s\n",
> +		       mem_alloc_profiling_enabled() ? "Enabled" : "Disabled");
> +	seq_buf_printf(buf, "# Compression: %s\n",
> +		       static_key_enabled(&mem_profiling_compressed) ? "Enabled" : "Disabled");
>   	seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
>   }
>   
>
> base-commit: c73b725a57f276a3702ca213bde78fca029bc619

