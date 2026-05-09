Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5383CD37AC
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 00:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326096B02CD; Fri,  8 May 2026 20:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0936B02CF; Fri,  8 May 2026 20:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19ED96B02D0; Fri,  8 May 2026 20:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 088026B02CD
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:29:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A77D0120414
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:29:13 +0000 (UTC)
X-FDA: 84745996986.28.72B2444
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 04841A0008
	for <linux-mm@kvack.org>; Sat,  9 May 2026 00:29:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fPJbXbpY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778286552; a=rsa-sha256;
	cv=none;
	b=BzhpNKWUVUOWl6b+2jn24fHdCJS87ZDRvr6GIt0Z50ABRFkoC+rxjjbZ4TjYl88QLQn7jr
	bXC7P2M2b8NPiBx2R/eMZ5z9hyZjwz9T/4pYshRRKQhaVSOVEdWFqaGNfnhpyTb4RpQvY7
	bGEU5OfDFLbFFjN4t/8250rARaM+/1Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fPJbXbpY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778286552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJaS5fpO/sSOj71324lTxhdbcTRyu5EwGeDP4FwtEeU=;
	b=nJ7SuElhKngrNuvVDS5OmkzcKqpsN10Xt5xsorfoLG1hl/JiEl5s/midSQYMbR0Uap2hO4
	0G9GaTU2uZ0fVMM5PoDBHY97kEfTyGzFoBlvbPYtLcwY2h+Jy7WcCCsobrlBbaxvFG3HR7
	/aPrHaGdUMdYevCk3IpBMopukfj8Z4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60E9D6024D;
	Sat,  9 May 2026 00:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA065C2BCB0;
	Sat,  9 May 2026 00:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778286551;
	bh=zkGXVGKhc/OnhZzxUCS0Kh9AEbI5Bonc05pyUjUtSpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPJbXbpYAQYSCAwmqqgmXLxZlU6TDzdhxRZOEgK/ypHcmb/jfRuwBZWIq5t4Gokz7
	 b8gzGWla2B/ptCjddFSETIb77LWDOD4/oXEBDyhHN6ecbw0IfvRCGtwIfnriwBWDxh
	 JoXKH770DkJSwE5DEyP3KMSBTizK+866lgrzWwdi+gT3HFz3RKGgajeH6HsAiN7341
	 F5C1bBaCIV3SZx0RjgnZUfqxmW8K4ZjMEPon8zUb6uVeq3cYHCJfUad6nhqXY8Zp88
	 ESU6RLSMkAWzwYlUIfLcjis0B0g+63qYq8cmazpzqNC9N3Z+DxFgrLqnvTnriX/5OG
	 k/nSvpQWTdLag==
From: SeongJae Park <sj@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] mm/page_owner: add print_mode filter
Date: Fri,  8 May 2026 17:29:01 -0700
Message-ID: <20260509002902.83937-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260507064643.179187-2-zhen.ni@easystack.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uuwqiie9dxgw5watejr7xopt13z19m5i
X-Rspam-User: 
X-Rspamd-Queue-Id: 04841A0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778286551-906287
X-HE-Meta: U2FsdGVkX19/fxUPgNf0pSbaK7X2nPerrBI1ZnMQ7p4Hrf0E0B9Tw84ye4bXMcAs0IIrrjPHSJXwlnj5jXSaY2kTCttYWjc+CEvx0x0UXfTNybsECw/KP8R1OmpiuDEuwAiN0UtesEfG4guemxCdTDwyJHf0J31Br2LwWVRbtSXjkBq7ql7uKs9HjoSmtXp5+3iYpKYkng6RHQOeQGP4LhLKVPdeq9UpLi3htN3uUuG8p93BoD96AauWOdyJOukGI0JI2FXSPNs2p9yfKJnFqP9D9h/azOtQbGc7e18HWwF24NeFvtbnJiW0LGRnqxWkdHWz/3/XNPrP+RyCyQlI5LHDXQ3ghuoreo3c7+B23z8psYFYr4kUV+sj2uCj47o+4Wgzr0JMmarw/xoh8Vbt5KEGD6NW6kdHyPiW3bHfo515jXghwJNDry3hWruHM7Uyh7EMFTbZwRadVTn4u+6AChet1At7hMuUBwxwKK4rs1S1iE/p3dHsqxPXtiCi3q2W1yO3jxewyyiexN+daUP2JxHMSeWlIDETCROWqHGAIlxl830AR7OCkIW07jdyJRs5KnQK6pBQb6JlLVlvrSq5K7nt88IuR6Eo2S5ygaA0S88hApjjwN4eiVO76vdcbyepnkelauozpNzEm8tQrOqZYdd0aCyoQa8+tZ1K9/ROjSzH76A2LhcAmtWvrcn2OsYHVjxI2/8bniQBtTocOK5My15tv9GaxqgRmVgCliCye1b+9bIagedfanz6eAp0gGkYXrVHgBHvYnCahx1S+GbHTXCjO47pjpONGf2tKIlVg0WyrAZNgAYXRyilsZjgYT79aOn5SiRWhwI6L1r4vrzNfsnD+1lphaTR7WcQhPxXin5BeUZrOYrPuMacgbSxHf0770Qgy8gnEJpQzjF3kZ8LYfheAAwptWME7gBK/b8l/ABJ+kg4XN07IqsDoIis5li/K91qaN0HaxgF73ONbJf
 K5PirAug
 iGrzXQrJq2/lrqWvz5k08Jqu3woktWBJDN66WgG7HOhyO75Ol9i7FBJ4XX8nGPuppbkZKtNfLSSFij9mThufECAHwAVII0AKjV+op2yCr1BOaAlcbCdxAHUDmwwrJpsbmkHkpXuByWf88lh3jr0dqIRSeGeZYgGyva/ZVhiSva5zdiR39KWCrbOLo7RVeBcWK2Dxu2UhEzvuCqXbt/H/FeABtGCIBGrP2sUMdogG7uiZfiTkqKvASg2c9DZqSupwzNURsSUiZzeIEudmORIggux+dgCtqwD8vm+t5ISTj2umNe/Wvcksy2eRjIghPVYfuOSPGbsmtW2FLUbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  7 May 2026 14:46:41 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add a print_mode filter to page_owner that allows users to choose between
> printing full stack traces or only stack handles, significantly reducing
> output size for debugging and analysis.
> 
> The filter provides a string-based interface under
> /sys/kernel/debug/page_owner_filter/:
> - Reading shows the current mode with [] brackets around active option
> - Writing accepts "full_stack" or "stack_handle" strings
> 
> The default full_stack mode maintains backward compatibility with existing
> usage, displaying complete stack traces for each page allocation.
> 
> The stack_handle mode dramatically reduces log size by showing only
> the handle number instead of the full stack trace. The mapping from
> handles to actual stack traces can be obtained via the
> show_stacks_handles interface.
> 
> Example usage:
>   # echo stack_handle > /sys/kernel/debug/page_owner_filter/print_mode
>   # cat /sys/kernel/debug/page_owner_filter/print_mode
>   full_stack [stack_handle]
>   # cat /sys/kernel/debug/page_owner
>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>   pid 1, tgid 1 (systemd), ts 123456789 ns
>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>   Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>   handle: 17432583
>   ...
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

I added a few trivial comments below, but overall looks good to me.

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> 
> Changes in v5:
> - No code changes
> 
> Changes in v4:
> - Change from numeric (0/1) to string-based interface ("full_stack"/"stack_handle")
> - Merge infrastructure patch into this patch
> 
> Changes in v3:
> - No code changes
> 
> Changes in v2:
> - Renamed from 'compact mode' to 'print_mode' for better clarity
> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
> - Update debugfs filename from 'compact' to 'print_mode'

Adding links to previous revisions would be helpful.

> ---
>  mm/page_owner.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 91 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 8178e0be557f..28766c854d02 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
[...]
> @@ -575,7 +594,11 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  			migratetype_names[pageblock_mt],
>  			&page->flags);
>  
> -	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
> +	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
> +		ret += scnprintf(kbuf + ret, count - ret,
> +				"handle: %d\n", handle);
> +	} else
> +		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);

Braces are unnecessary [2] because both branches have only one statement.

[...]
> +static ssize_t print_mode_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	int mode;
> +	int ret = count;
> +
> +	/*
> +	 * Limit input size. Maximum valid input is "stack_handle" (12 chars)
> +	 * plus newline and null terminator. Use 32 bytes as a reasonable limit.
> +	 */
> +	if (count > 32)
> +		return -EINVAL;
> +
> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;

Would it make sense to use kmalloc_objs(), or simply using a local array as
Andrew suggested?

[...]

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://docs.kernel.org/process/coding-style.html#placing-braces-and-spaces


Thanks,
SJ

