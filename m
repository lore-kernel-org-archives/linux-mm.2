Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FA1606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 19:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=c/zeaH4E
Received: by kanga.kvack.org (Postfix)
	id AE3A36B05B5; Mon,  9 Nov 2026 14:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95036B05B6; Mon,  9 Nov 2026 14:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983906B05B7; Mon,  9 Nov 2026 14:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9586B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:37:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED4C71C4018
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:37:02 +0000 (UTC)
X-FDA: 85416588684.10.3BAF9CD
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id C1D221C000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:37:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="c/zeaH4E";
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf21.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794253021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHNvfOdzDYvflZZwQyDfJT5woa7wvoLZDtOmJUj4Za0=;
	b=tPVskTmIMrkAbRAkyjYiA30QrTJFqNoRqcO+I5PZitLfhPgBctHwSjXVwDd+WDJAD6fXv2
	J6vx5G6McSt6swQxukiYsO1doQ37DxQ3M5cIVs0VnF91Gt/wNYWSOTFKrWWKy0eOBDQFiw
	z0z5aW6wm4SWDWDgsSlRZ6Yif6z4Y5Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794253021;
	b=63+dap1/RLc7pHfoLmfyTYHm18AGn8qmk6QcUJf/hFloIePC7afnszWQDLiGj0ImHv2rv9
	pSn4NuQAd/NrkL0pnPRNyjM4djZ4MJXyJIkY6RIBLFTBh5OhEc7dyElkl52FTf9Y+VZjKs
	CsNDyZ1C01CHxM2wH3/Ii6n1kS2C4Zc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="c/zeaH4E";
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf21.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Message-ID:Subject:Cc:To
	:From:Date:MIME-Version:From:Reply-To;
	bh=lHNvfOdzDYvflZZwQyDfJT5woa7wvoLZDtOmJUj4Za0=; t=1794253020; x=2109613020; 
	b=c/zeaH4EtQwEaMrpTdAq+RrJ0ufk+i5Y86wFjp95XKpXrtBtDYmJqwoL9GM8DxQjea9oZqqcMOz
	0z7n8K+K4MyT6P0uOy/hHSjX30GtD1ZHIivPqUyZryt1I3NXO6s3s6OMUbhJqJ7LMo/WWKa8Ww6ja
	+zb7ioockvkK9zRgr3vDFs1DyMLPQmR4nfHc2PN26y/YytzABEyxBq7Pe6RVmdnqZJCdEcrB2MeUC
	hGFvHWv3AbU9f8ZjSnX9Ocv6YzCeh0jKCWALPjVtr4vjKCoSDnV15BWgKLMVjaYgozDJyIDAdDfTa
	DMzmNL3Aq7+8HaPPkKqy5ZYBSjuO4LvBQirw==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xQVAe-007cRa-45; Mon, 09 Nov 2026 20:36:48 +0100
Received: from webmail.service.igalia.com ([192.168.21.45])
	by mail.igalia.com with esmtp (Exim)
	id 1xQVAd-00000005Gc5-111S;
	Mon, 09 Nov 2026 20:36:48 +0100
Received: from localhost ([127.0.0.1] helo=webmail.igalia.com)
	by webmail.service.igalia.com with esmtp (Exim 4.98.2)
	(envelope-from <mfo@igalia.com>)
	id 1xQVAd-0000000GRqv-0Nyv;
	Mon, 09 Nov 2026 20:36:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Mon, 09 Nov 2026 16:36:47 -0300
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Hamid Nassiby <hamid.nassiby@nokia.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sasha Levin <sashal@kernel.org>, Ran Xiaokai <ran.xiaokai@zte.com.cn>,
 ranxiaokai627@163.com, Andrew Morton <akpm@linux-foundation.org>, Vlastimil
 Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Oscar Salvador
 <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 6.12.y] Revert "mm/page_owner: fix memory leak in
 page_owner_stack_fops->release()"
In-Reply-To: <20261109141509.2880440-1-hamid.nassiby@nokia.com>
References: <20261109141509.2880440-1-hamid.nassiby@nokia.com>
Message-ID: <3443f5711f170336778377c744ae84a1@igalia.com>
X-Sender: mfo@igalia.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -48
X-Spam-Bar: ----
X-Rspamd-Score: -0.8
X-Rspamd-Action: no action
X-Rspamd-Bar: /
X-Stat-Signature: ec1t69dcpnt3hesypezqis3ma1zhj33j
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1D221C000B
X-HE-Tag: 1794253020-430900
X-HE-Meta: U2FsdGVkX18WaYtfSd0KNsMiMLVgV0ZNJvCoDzltY7ed95Wkc4eeVSd1QHvhftptCPbYSYr4UdN9tHf2wMmyjeVA7i79gTDkg5GlJBrMQqKIConmEJFly8TsvZ+hOjDPWJBxvpdqfR/rBbmMj2M5kI8yN2kvwxss8hwJFlYRSuv8DwmCBFYDdLudciE+B/Yhx4G1f/xqOjV8x2OnNvKfdBtM3v8Z+BAicY8Pa7rEObiF9/l7UeawpBvss+GjELXD5QAcsrSqIMs7MYsUtPwnAjVgKq/IiP/FWR4vUo/52QD6VhbiKQeFaF6wkykepVJufAFT0MX49OXliEQostA5EH0uxRPpN/y7qqcbtIJOC+ijkBbpY381/i0oxxh6FLDkS0RYRoaQvK/UelCVjOw/R4rbZC51sPrUiFZevX2CTjY4UN3YgdZhGfHWQSOG5jIl/F2hd4A03mvVjx+RsPbB3+ZBVGPhjBWLDkIjOseaYIv43dJiEs/wmp2NqWB5T9QbgnXldmWZl6vvwaTccB976Bc1RhTfartDyB8iOZIvQ0q1oOQVKCZ6/TqxZ+9Mf0JduxRzFrim2qNshz09meAmSUHu/q1sIdla326VUzcqvOyyMefVQf57XhTg66Z60UrISeDGf+l/JDs/rhrg6mFiH8Uq/ONeRV2h+WLEuBSpKWU7y+eG1bf4irJrP9bu67sjqeY3Soxn44Etu4lg64O670rHfSufjsDK3Sy7ccHU/tf/Rp8STkFsf6WZZPz4Qi23W2ovhkGFTXzXRPTlNi0o7JPKFOqMvvzeFogNEySWsoh5GfHXsOA7IXt0hPAmvlGkp6wR6WTqmf5xqj4mbBJh/cQhhWyyzQNh4XvG+EDzb7E28l4OU8OzwXudAcoWjWY/pCeCWfFKCoSc6FdsXzJjzu/bFRX2UE3zV/2kvrFz48nHvjIrXgcHGxq0thvXMTMKOJVZP2DO40BtuHb5xGo
 DYV8yYfx
 gzG2iisLORVfuYXn6C4fxnH/T4UP+qfE5wLlKVmshg+HtIkUOJo9obRp6NbDrWQ9uJAybPiQTsGlFZIQO1mfmSNiYuJKaSubcgb1MrGZNhHexVx3QMygMKOHo+XnKQVXojlxtiLZdBvu1nMLvhNvRUW+l53YnckyH4vud2FnyJRCI1WsXnaBVPRVNDJkev3lJBUSk+P1KdQdvPEzBIrrMQ470ADTe2lPv3khO6sl3UzPrNgGe2sCPVAtMNE4KH47QntCXaIDTmy9pT0rByPtcmSAEthPcpfWL3tHD7/bHrqqZzl+LQLssmVM0laZw4GrQfh4edLqVC9WQAnnfyWAvZ9+d5+NmyCg5pwfpt0OhBxYAhZVpEwAXKbZsFYW/ToNgHuG5+Fht9aEuqE/ymSppdJ7ou9IT0Xg31PK4o+C1r/N3jD23Emo+JD93t/NXbVWNUev5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-09 11:15, Hamid Nassiby wrote:
> This reverts commit 7fbea59f737eb3a47368ee5253e708cb342faf8b, which is
> commit a76a5ae2c6c6 upstream.

Thanks for handling this and submitting a fix.

Reviewed-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Tested-by: Mauricio Faria de Oliveira <mfo@igalia.com>

cheers,

> 
> The upstream change is only correct on top of commit 156c0c5d1463
> ("mm/page_owner: introduce struct stack_print_ctx"), which first appeared
> in v6.19. That commit makes page_owner_stack_open() allocate a struct
> stack_print_ctx through seq_open_private() and moves the stack_list
> cursor into it, so ->release() must free it with seq_release_private().
> 6.12 does not have that commit: page_owner_stack_open() passes a size of 0
> to seq_open_private(), so there is nothing to leak, and
> stack_start()/stack_next() store the current struct stack node directly
> in m->private.
> 
> The upstream commit was backported because it is tagged for stable and
> carries a Fixes tag for 765973a09803 ("mm,page_owner: display all stacks
> and their count"), but the leak it fixes only exists since 156c0c5d1463.
> 
> seq_release_private() kfree()s m->private. Closing show_stacks before
> EOF therefore frees a struct stack node that is still linked in
> stack_list, and the next reader of show_stacks walks into freed memory.
> On v6.12.115 (x86_64 QEMU, KASAN, page_owner=on), a single 4 KiB read()
> and close() followed by a full read gives:
> 
>   BUG: KASAN: slab-use-after-free in stack_print+0x165/0x170
>   Read of size 8 at addr ff11000005259d40 by task init/1
>   ...
>   Allocated by task 1:
>    __kasan_kmalloc+0x7f/0x90
>    __set_page_owner+0x45c/0x6c0
>   ...
>   Freed by task 1:
>    kfree+0x1a0/0x390
>    seq_release_private+0x58/0x110
>    full_proxy_release+0xe3/0x290
>    __fput+0x35c/0xac0
>    __x64_sys_close+0x79/0xc0
>   ...
>   The buggy address belongs to the object at ff11000005259d40
>    which belongs to the cache kmalloc-16 of size 16
> 
> Without KASAN, a partial read followed by a full read
> ("head -12 show_stacks; cat show_stacks") panics arm64 hardware running
> a 6.12.108-based kernel:
> 
>   Unable to handle kernel paging request at virtual address 0030206235376d88
>   pc : stack_print+0x20/0xd0
>   lr : seq_read_iter+0x340/0x470
>   Call trace:
>    stack_print+0x20/0xd0
>    seq_read_iter+0x340/0x470
>    seq_read+0xf0/0x140
>    full_proxy_read+0x54/0xa0
>    vfs_read+0xc8/0x348
>    ksys_read+0x6c/0x118
>   Kernel panic - not syncing: Oops: Fatal exception
> 
> With this revert applied, the QEMU reproducer completes 20
> partial-read/full-read cycles without a KASAN report. mm/page_owner.c is
> unchanged between v6.12.115 and v6.12.116.
> 
> Backporting 156c0c5d1463 instead is not proposed: it prepares for the
> new show_handles and show_stacks_handles debugfs files rather than
> fixing anything, so reverting the backport is the minimal change for
> stable.
> 
> Link: https://lore.kernel.org/stable/20260106170507.666343896@linuxfoundation.org/
> Signed-off-by: Hamid Nassiby <hamid.nassiby@nokia.com>
> ---
> 
> Notes:
>     The analysis, the QEMU/KASAN reproducer and this changelog were
>     prepared with AI assistance. The arm64 crash was hit on our own
>     hardware; I reviewed the analysis and confirmed the fix there, with
>     repeated partial and full reads of show_stacks on the reverted kernel.
>     
>     The same backport is in 6.18.y as 05a8edf607be; a separate
>     [PATCH 6.18.y] revert is sent alongside this one.
> 
>  mm/page_owner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 5d1c946c0..d2783b7c0 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -937,7 +937,7 @@ static const struct file_operations page_owner_stack_operations = {
>  	.open		= page_owner_stack_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
> -	.release	= seq_release_private,
> +	.release	= seq_release,
>  };
>  
>  static int page_owner_threshold_get(void *data, u64 *val)
> 
> base-commit: 5c40a1750f44dd6c7292d8c8d0b4ffff1734576e

-- 
Mauricio

