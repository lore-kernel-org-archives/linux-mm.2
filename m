Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B39C606A336
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 12:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T5ZFw6v8
Received: by kanga.kvack.org (Postfix)
	id 6587F6B069D; Tue, 24 Nov 2026 07:18:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630E86B069F; Tue, 24 Nov 2026 07:18:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D5E6B06A0; Tue, 24 Nov 2026 07:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 306786B069D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:18:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C9AA80B3F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:18:26 +0000 (UTC)
X-FDA: 85469915412.12.E18B820
Received: from mta1.migadu.com (out-123.mta1.migadu.com [95.215.58.123])
	by imf24.hostedemail.com (Postfix) with ESMTP id CF2B9180005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:18:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T5ZFw6v8;
	spf=pass (imf24.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.123 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795522704;
	b=p4DWqGa2IBYUvDiPZZUhXCbnNnGcFvzeCazYdRPLD8kS2i7zVMRnMh0p6Wty0VQl9BT3Tm
	3z0kfkbuj1Bob+Aaz7o355LVSoRYXp8OT4so94uk7ejgeo5IBts68NXi0MPYIW1QkMAsSW
	3agQ2ucd76VBacEePMKswm8g60czRKQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795522704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUGXnl29oqUu50SqEIurEsM4e0cyju2OZ81JkZSaKRk=;
	b=KazV0Eb/j6sw8VFLfkYeosR1zYcfNMcqf9Kg0qbhy0IJGIBoT/QzfOOgY1sf5npc2nM2z3
	D3Tt9EhBgUmZKuy8R1duYBePio+pe04eDMH3xbZiXR3eMCxKjrmPHwn8vsYQzORVJXVqjB
	Zced5Ds/elpUYKNH5JgOlR5tL5Cg9Yc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T5ZFw6v8;
	spf=pass (imf24.hostedemail.com: domain of enze.li@linux.dev designates 95.215.58.123 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ehJyS5om/OyXbT78ohfS4FBoNaPuj5iCwpL3QhfmKIo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795522702; v=1; x=1796127502;
 b=T5ZFw6v8wsEa7QywSdH65t93/gWh9DH9CgfPtP+4oziIND3nQ3zrdrr4MNNbBQoPlJs1p1s4
 Ud+ohf5cCk6WfCdKVIuTSAoslrEqUayzgZCQhNX28juHtUip6jzijvY7GcluP3vhggBj2CbSAQL
 NtwlcFSkEMhL4I9DJxWe85Yo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c9fbbaba589b1890;
	Tue, 24 Nov 2026 12:18:21 +0000
X-Mizu-Trace-ID: c9fbbaba589b1890
X-Migadu-Flow: FLOW_OUT
Message-ID: <1739306a-9fa7-403c-a2da-b44f623b9445@linux.dev>
Date: Tue, 24 Nov 2026 20:18:19 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Enze Li <enze.li@linux.dev>
Subject: Re: [PATCH] mm/damon/sysfs: skip registration if DAMON core init
 fails
To: Aveline Noir <jm5905938@gmail.com>, SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lian Wang <lianux.mm@gmail.com>, Dawei Li <set_pte_at@outlook.com>,
 damon@lists.linux.dev, linux-mm@kvack.org
References: <20261123-damon-sysfs-init-guard-v1-1-a2a6ca65693a@gmail.com>
Content-Language: en-US
In-Reply-To: <20261123-damon-sysfs-init-guard-v1-1-a2a6ca65693a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CF2B9180005
X-Stat-Signature: rfgy5brrhn7cbrh787g1ns7ed6whx5xh
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795522703-636977
X-HE-Meta: U2FsdGVkX19z8knZyBfgjQ8OQgo51laQ3TYeGSJsW00p79EaN6Gq67+ki/uApuX8oRDtE5esUPsmZzp8mxEdc6Bkh6zF0hOXMVgEPZy5ugR2ghmP64axAvB8uH5MJ88vQZCqc55O+0+y1pcq02rn3VEpD4Fru4MyYY8HZUSKsdeWzLf9AwAX0eLzwRaXIYrfpTh/cq2jbb5upq8HQ3i/p+NGEhEGfGt4dTN3Ozqu/DfMk4nz0bLexAuIIukKcyY1QU4NCck3OmgVG4qYMMKq3cVlTy475jZgSH7v7y1NDedqBzoUWUp/dG7t6HHDZyCFv5imR3iTWovfayCcGrbDNjQ1oMW4rNc15sjN5qAq8rkXzIeYZHOAwyVEiyHcYjwoCbme0a5hWSGa1XDa4i/sTZgqpEwqQBFpvGfwf8Cpu3RxMKsj/OFEsz1gk4PSlggGA4dmrkaYlXH7Wt97lapjYhnbrguauratEIdtqBlCz4UUZDVM+qgMJc2EIm+tkp9v6XrqGkam+W7y+Zl3mdJHV6hWnDPmUWqIz1K/TijKRSVdt9VHqsL+aWukhdK3fIDfhaQHFlaVe5Bb2wPbVaikDPXy9wXxTu0kVx+TZqWC4urAWzh20Agit2Oq18MoCyrx7HEgExiuJ3z8aOyn8f17b8lfAszoT1xzJoovqW/htEG3BSREivNJIdjeDGt+PMSr2geyFc3W05TPRapMUm/7iPGaGfWVm+kZZMBg1JgAvCq1+kw0t867xZjwYN1z8A660nc8mCetPf2Qohe+YW3PtQC9U9UCn9VGB9d38E4501gRgPaWHjsT75kSCZ8O7j0ckd1BDaKJUiCIY8dJBVImSLKHcEuybsOQGwc0tDWLHc0VP9vrHL5bySEfppb+dW/yGSNVktv7CswYV2mcab3DBnBwCPbh8aSF5dGWroKSy/R8BuS3UdzZm1h9IqfmRT5cr3xt8LA2wgUfRhlv3OH
 BpSUbxX2
 hVbkeDRFggE0YfNoWcRQRgRNU/CB/ZjA1/7algnjzYPOvfcgt6y/+oplLUB+fvTF4Jj9M0U2lpxGNeIXf3pop8XsphsIlYZbuOkLczc+kFvSdWPGwjDBz98Fuq9UxJDbWFGr/tFCw61Ytq0EMs1ISoXdE6NreljP1A0cjh84BnFsn2g6BUIm2afvgRDUHwZpg83X5YCJDtduVGFuQ67rUBnghajkn1roCMkMoIufvmOjdQBjFIVHY/L5Wmhg+OjJi73lX/bEgYZ8n1tCDjjTsDBojnl6cqZhsiRBwiXM0spJaADPrhbGPeuF3+L7dn6F93VblEczkruWU5Xuy8ZqutpaI2HAWuvP9sw2mmx338xH59SkWJVczkP6bCv50Np49rAGinC9nUtYeaWXukq5144GyPEVkO4+L9x6bXvBVtv98+6sFkNVlBWAEwtWJFRcXY/KcgHCP0oC4ALqxjiWfzaq6+p4czqd6YNqEHvMB5z6Ypd/p11hpOkiKbkJgWXwepgZy6SGOybfLxp/3U5yd84xxf3krOLkdKdCN/+dL4ocpbg4xmvqWnYbdXpdRZnkog2jn1TKb+MhlahxKvPtPManOx3GWZhi/sbtH6c9mQSMcBFaGLiMSWFqFRfvKmPqOzVq5wEelsxmkDZk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aveline,

On 11/23/26 15:51, Aveline Noir wrote:
> Hi SJ,
> 
> Here's the sysfs fix I mentioned in the report queue review.
> 
> -- >8 --
> 
> While reviewing the DAMON report queue series, I noticed that DAMON
> sysfs still registers its interface if DAMON core initialization fails.
> If damon_init() fails to allocate damon_region_cache, starting a
> kdamond with an initial region can pass a NULL cache to
> kmem_cache_alloc() via damon_new_region().
> 
> Check damon_initialized() before creating the DAMON sysfs directory and
> return -ENOMEM if the core is unavailable.
> 
> Fixes: a18709442869 ("mm/damon: improve damon_new_region strategy")
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
> Tests passed in x86-64 QEMU TCG guests on 9f004372ebeb.

I gave this patch a try and it works.

I forced damon_init() to fail with the following modification on an 
x86_64 VM,

8<------------------------------------------------------
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 986404b547eb..194b30731572 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -4313,6 +4313,10 @@ bool damon_initialized(void)
  static int __init damon_init(void)
  {
         damon_region_cache = KMEM_CACHE(damon_region, 0);
+       if (damon_region_cache) {
+               kmem_cache_destroy(damon_region_cache);
+               damon_region_cache = NULL;
+       }
         if (unlikely(!damon_region_cache)) {
                 pr_err("creating damon_region_cache fails\n");
                 return -ENOMEM;
------------------------------------------------------>8

then ran `damo start paddr --regions 0-10000`.  On the unpatched kernel 
that immediately Oops,

8<------------------------------------------------------
[  461.012857] BUG: kernel NULL pointer dereference, address: 
000000000000001c
[  461.012881] #PF: supervisor read access in kernel mode
[  461.012891] #PF: error_code(0x0000) - not-present page
[  461.012901] PGD 139e4f067 P4D 139e4f067 PUD 124048067 PMD 0
[  461.012913] Oops: Oops: 0000 [#1] SMP NOPTI
[  461.012924] CPU: 3 UID: 0 PID: 1610 Comm: python3 Tainted: G   E 
  7.4.0-rc3-new+ #2 PREEMPT(lazy)
[  461.012938] Tainted: [E]=UNSIGNED_MODULE
[  461.012945] Hardware name: Red Hat KVM, BIOS 
rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[  461.012956] RIP: 0010:kmem_cache_alloc_noprof+0x16/0x400
[  461.013083] Call Trace:
[  461.013088]  <TASK>
[  461.013094]  damon_new_region+0x22/0x60
[  461.013104]  damon_set_regions+0x38a/0x4e0
[  461.013112]  ? damon_sysfs_build_ctx+0x32c/0x400
[  461.013123]  damon_sysfs_build_ctx+0x391/0x400
[  461.013133]  state_store+0x30e/0x3f0
[  461.013141]  ? __kmalloc_noprof+0x292/0x590
[  461.013151]  kernfs_fop_write_iter+0x14a/0x200
[  461.013160]  vfs_write+0x25d/0x440
[  461.013170]  ksys_write+0x6b/0xe0
[  461.013178]  do_syscall_64+0xc4/0x570
[  461.013188]  ? __x64_sys_close+0x3d/0x80
[  461.013196]  ? do_syscall_64+0x101/0x570
[  461.013205]  ? do_syscall_64+0x101/0x570
[  461.013213]  ? do_syscall_64+0x35/0x570
[  461.013221]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  461.013230] RIP: 0033:0x7fbdeba26a02
------------------------------------------------------>8

With your patch, /sys/kernel/mm/damon/ simply doesn't show up when core 
init fails, and the same damo command just errors out.  No Oops, no NULL
deref in dmesg.  That's exactly the behaviour we want.

Feel free to add:

Tested-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

