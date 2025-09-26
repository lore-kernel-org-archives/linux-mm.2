Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C073CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 14:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0AC48E0007; Fri, 26 Sep 2025 10:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1AB8E0001; Fri, 26 Sep 2025 10:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF268E0007; Fri, 26 Sep 2025 10:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC9A08E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:37:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B5F38792B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:37:54 +0000 (UTC)
X-FDA: 83931655668.11.F7D5E56
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0740E100012
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:37:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y6TG9Eoy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OzFQXXJU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y6TG9Eoy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OzFQXXJU;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758897472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGIQLrXDPKGC8xmzMADzKuCcFHSQrQzy7Q8kZsslKZA=;
	b=2p/BXrY06D7joNRcgZTrTz2gn7e8LNsRBsYFMu0ZR57h0v73qswbH8HBJyPIO7F9fq+tj6
	puQYg9RG6acvGCJULUEkzDZp60+BaR9TNN15SHWyhGKlGAfHEYUhSXFqNeBx31sVsJUtoe
	Ax1T7fnBXo15fZobUV75+Tx5gFcMGYg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y6TG9Eoy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OzFQXXJU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y6TG9Eoy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OzFQXXJU;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758897472; a=rsa-sha256;
	cv=none;
	b=LrWmnwnP5QyFjaMD701W9fL0EZ3sbxBOJbw1c3VC4rQv+X9fLQ7XB9sNL18Z7QISqy9hkj
	Hoyo/4n/TyPSUvwjYR3SsVJJ94rLTzT461r5Zlkw+AJyw5IJMlRgnz6z80ww/lKOY5ho3A
	weG49aWQlL+5j4vNzzfw1E9NaoFoEyk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3C7942431A;
	Fri, 26 Sep 2025 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758897470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GGIQLrXDPKGC8xmzMADzKuCcFHSQrQzy7Q8kZsslKZA=;
	b=y6TG9EoymoauKo3CTy1bnoBESDn8UU+RJpTRGuD9Ou+tJPtnilXQgeclLzaTm8io3mC5le
	F49Vnn+9L9KrYvYOr/5y6V75+WO0AV9FHNSyVsKQbTdwUjE0RnrofLIP5gyzWaAbqgmcEc
	No9xma1IvGHpyjifTnZDvo9hIBuLcO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758897470;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GGIQLrXDPKGC8xmzMADzKuCcFHSQrQzy7Q8kZsslKZA=;
	b=OzFQXXJUeHH8fQQIC4qoi9541ycr+X1t37cWHrKCyawkwJRMiVNllAi5hshhlt8jY3aex0
	tz3re3292+azLUBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758897470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GGIQLrXDPKGC8xmzMADzKuCcFHSQrQzy7Q8kZsslKZA=;
	b=y6TG9EoymoauKo3CTy1bnoBESDn8UU+RJpTRGuD9Ou+tJPtnilXQgeclLzaTm8io3mC5le
	F49Vnn+9L9KrYvYOr/5y6V75+WO0AV9FHNSyVsKQbTdwUjE0RnrofLIP5gyzWaAbqgmcEc
	No9xma1IvGHpyjifTnZDvo9hIBuLcO4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758897470;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GGIQLrXDPKGC8xmzMADzKuCcFHSQrQzy7Q8kZsslKZA=;
	b=OzFQXXJUeHH8fQQIC4qoi9541ycr+X1t37cWHrKCyawkwJRMiVNllAi5hshhlt8jY3aex0
	tz3re3292+azLUBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 236131386E;
	Fri, 26 Sep 2025 14:37:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yEFSCD6l1mhRbwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 14:37:50 +0000
Message-ID: <522d9c39-b0a2-4630-947b-802b0f96eaf8@suse.cz>
Date: Fri, 26 Sep 2025 16:37:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] KCSAN: data-race in try_to_compact_pages /
 try_to_compact_pages
Content-Language: en-US
To: syzbot <syzbot+20dd68d4ba19e8242c26@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 surenb@google.com, syzkaller-bugs@googlegroups.com, ziy@nvidia.com
References: <68d63689.050a0220.25d7ab.00d9.GAE@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <68d63689.050a0220.25d7ab.00d9.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0740E100012
X-Stat-Signature: hcijkejcw9grk81er5di313hkkba1owd
X-HE-Tag: 1758897471-393392
X-HE-Meta: U2FsdGVkX1/kqWD4/QUceirTgnQagdx4OYfXRbSt4mZPjU/PNBqihkMRwchI/GMxbHx8PVQJk6S8R/NP8ppIjM0caqFi5idRG4xdIQnaZtOTUh1yurRby/l9Qj/moa9EUkxmHFtM6viYXVnzPNwwqV2HHG1q2R4dNyuiYSvowvx009o8Tujp0JV1xXhkdYmdMnZs9+Qow7vOxzZJ5V7idPzyI6dOTZhb8AodULF5eE4PWGR7rJ/R5C2Un5Y6CVtv9VouySkVxnhdJZdCU9u6r0ElKCBeEvCwGNab/Tek/IHIj7DbSNAQcyra1DfkIUMASnZ7IBGY/rvk46VG/A27T3Z/JcYmHFsz3N87dFAzWGhye88vGg97nf7l+WoCcVxfpo9edydA+em8UNgnu0WMrbvALDt+A52RMbe8HihE/ZnDaN6UF4h6Z8UheD9igQhnb+D6WddWMbrKPVR/iA0/hkmC6BJV5gxw15z+bupSFlmys21euZl7igdrLfyq8sU1YZ8dVdr0w8ddMufZhEVcsVvtjuD+yNHe/c1nRqX1Gxsm0/jyp1YdonzJWDR+BR0G64/O0/a6fTNS8aGsMrVQcsruDgMjmxVGducf9IjWsLN08NjSnNZuHez5ZWuLBtBONAo1dVS+2L/BAJoZw02JPdGT49bKz67YgS/X4/opqWw5xAIReJ+p+kF4o94G8pXj96my5cx6gH92Esf5hxPmcTVjQz/Hhfls3ODzIGbMKpqEP1goM1C0Ru/Vf10UpXjDi8fGI0/ayeanI63bqSMR1DW5M8FZvjv9LHgRhhYLl74Bq7o7NOtRgIOnY/WBcnl3CDxX0lN9iStnpCLuw33rSYsqLhScoQs4W10U/lNLTnO8Q/vzDXSLWMmUU+DX6OtVkUBEVFPNKVzBJLn1KtSaDSbKHwdwj7tP/TuK8+ibReGsPSXoa71Ks3cL/BiwnPfq0KXfUpmLRPJLonnf16R
 XUrWgjEY
 t/5TZFRsLxY3k0bH0aKwrHck7cZ999gHLjOfkY7jdlkECf3s6CZVrD0cN2x/PwNfoN/rY3bHDxe0f2DvWzPJbnnALW/EA3hNmNW9vWWB/fzj5s11gXqf1ZUzeol2CToLBy06/rlW2pII3uDln2GDhL98CL8J3eU7YeVxSG8YJxSMQM95Q5wSHhQ6zn4cxLStiLuFGow/vrsVfQzHrBpIOMJbGoJUIWBlofF2sNv5bzYVtnBut+LQtZtSB9I+3Glu5pUjtzvs4BohxWTYIJGAtIbKaRNXtC/k2OFvQWIim5b/jdRk3u2ET8Z+nqy2hngIddBfXwB/VkHA2e9OEQ4Djt7sKA2v4nvklbpYsMaM21z3cRYXFzFlPSBIq1eL4vM/fDfiNjdxp4EFitwPV1ev/ew7thHWUWoNJzZGNaytux1/VTcP4DE1O36JuePXRe9xZAKd/UWMsyAV/xQ8fqB//WBClss45LJcL4R1wDMsrviv0uchxaEZLhFfVcqtIANnzkk1P/aS6YG0PTJ2SBCeq4Zjrk1gM3ZHMiDnDOGvVNpoDRK57QK85n/pxILvO2c32e1d7JnDOjyf3DZRNwUpHIdFvVNMs6s+ZsnioF/x3UHb3XyRHDpxkgHn3JGAxhn0SG/M0hBrodssk6yEMDdI//hXffeXaTQI3oXqFVp29Oa1njMs8za4wGrkweiwiqRvU1wV1zC1xRQtcDMGKxYF4tdU3rewvYbHeKAzIN/PbFtqIPg5urfmBNKX9tg3y85GLRcqC1yucP9PrE4kMMZywo1pSy03otSO4UGoff8OvBr/gK5iA+0u5kUs6I3Wzjm7fS9l/I8JBJe4wJw8zV8hPSimA8ZJTXmXm94Ogu+3Ek9RQfl8n95OEDn8zwE+LY3/vTJMiIhNCzlyng38hp+XTZ9EpfqPUVLeWPWGB8dr2ic4X8cHFUHsNkdUMsaFj+Dnqps/qrMmWxLZaMEXmDAB8+ZLdjUYb
 K4hkvd55
 9Il4KlyldTe0cBytp+TWbYWU0lEiHdzXSztI0T5oKtU+cNVcgUEN3d8FUVWvSgwgVoGd2HhI1m1TjebrFqRkKBxajZUV/7WvphBzuAe+7+Y23vYy10lO1ihBTJNC+2YsjXDiN9ck8ponMpHwPbnN9sFTsYkFD44QAmpoeCjpZd8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/25 08:45, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    cec1e6e5d1ab Merge tag 'sched_ext-for-6.17-rc7-fixes' of g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12448f12580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6e0c213d0735f5dd
> dashboard link: https://syzkaller.appspot.com/bug?extid=20dd68d4ba19e8242c26
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/10b7c8fdfdec/disk-cec1e6e5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cbecc36962db/vmlinux-cec1e6e5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/214f107d0a3e/bzImage-cec1e6e5.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+20dd68d4ba19e8242c26@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KCSAN: data-race in try_to_compact_pages / try_to_compact_pages
> 
> read-write to 0xffff88823fffacf0 of 4 bytes by task 6757 on cpu 1:
>  compaction_deferred mm/compaction.c:149 [inline]

Yeah data races for zone->compact_considered and zone->compact_order_failed
can happen but are not a problem. Somebody motivated enough might annotate them.

>  try_to_compact_pages+0x1be/0x940 mm/compaction.c:2838
>  __alloc_pages_direct_compact+0x65/0x1d0 mm/page_alloc.c:4066
>  __alloc_pages_slowpath+0x360/0x5f0 mm/page_alloc.c:4787
>  __alloc_frozen_pages_noprof+0x270/0x360 mm/page_alloc.c:5161
>  alloc_pages_mpol+0xb3/0x250 mm/mempolicy.c:2416
>  alloc_frozen_pages_noprof+0x90/0x110 mm/mempolicy.c:2487
>  ___kmalloc_large_node+0x52/0x100 mm/slub.c:4317
>  __kmalloc_large_node_noprof+0x16/0xa0 mm/slub.c:4348
>  __do_kmalloc_node mm/slub.c:4364 [inline]
>  __kmalloc_noprof+0x2ab/0x3e0 mm/slub.c:4388
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kmalloc_array_noprof include/linux/slab.h:948 [inline]
>  io_vec_realloc io_uring/rsrc.c:1327 [inline]
>  io_import_reg_vec+0x645/0xe80 io_uring/rsrc.c:1520
>  io_sendmsg_zc+0x91/0x550 io_uring/net.c:1545
>  __io_issue_sqe+0xfb/0x2e0 io_uring/io_uring.c:1771
>  io_issue_sqe+0x53/0x970 io_uring/io_uring.c:1794
>  io_queue_sqe io_uring/io_uring.c:2023 [inline]
>  io_submit_sqe io_uring/io_uring.c:2283 [inline]
>  io_submit_sqes+0x675/0x1060 io_uring/io_uring.c:2396
>  __do_sys_io_uring_enter io_uring/io_uring.c:3463 [inline]
>  __se_sys_io_uring_enter+0x1c1/0x1b70 io_uring/io_uring.c:3397
>  __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3397
>  x64_sys_call+0x2de1/0x2ff0 arch/x86/include/generated/asm/syscalls_64.h:427
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> write to 0xffff88823fffacf0 of 4 bytes by task 6696 on cpu 0:
>  compaction_deferred mm/compaction.c:150 [inline]
>  try_to_compact_pages+0x207/0x940 mm/compaction.c:2838
>  __alloc_pages_direct_compact+0x65/0x1d0 mm/page_alloc.c:4066
>  __alloc_pages_slowpath+0x360/0x5f0 mm/page_alloc.c:4787
>  __alloc_frozen_pages_noprof+0x270/0x360 mm/page_alloc.c:5161
>  alloc_pages_mpol+0xb3/0x250 mm/mempolicy.c:2416
>  alloc_frozen_pages_noprof+0x90/0x110 mm/mempolicy.c:2487
>  ___kmalloc_large_node+0x52/0x100 mm/slub.c:4317
>  __kmalloc_large_node_noprof+0x16/0xa0 mm/slub.c:4348
>  __do_kmalloc_node mm/slub.c:4364 [inline]
>  __kmalloc_noprof+0x2ab/0x3e0 mm/slub.c:4388
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kmalloc_array_noprof include/linux/slab.h:948 [inline]
>  io_vec_realloc io_uring/rsrc.c:1327 [inline]
>  io_import_reg_vec+0x645/0xe80 io_uring/rsrc.c:1520
>  io_sendmsg_zc+0x91/0x550 io_uring/net.c:1545
>  __io_issue_sqe+0xfb/0x2e0 io_uring/io_uring.c:1771
>  io_issue_sqe+0x53/0x970 io_uring/io_uring.c:1794
>  io_queue_sqe io_uring/io_uring.c:2023 [inline]
>  io_submit_sqe io_uring/io_uring.c:2283 [inline]
>  io_submit_sqes+0x675/0x1060 io_uring/io_uring.c:2396
>  __do_sys_io_uring_enter io_uring/io_uring.c:3463 [inline]
>  __se_sys_io_uring_enter+0x1c1/0x1b70 io_uring/io_uring.c:3397
>  __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3397
>  x64_sys_call+0x2de1/0x2ff0 arch/x86/include/generated/asm/syscalls_64.h:427
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xd2/0x200 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> value changed: 0x00000005 -> 0x00000004
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 UID: 0 PID: 6696 Comm: syz.2.1234 Not tainted syzkaller #0 PREEMPT(voluntary) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup


