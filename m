Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0553606A886
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 19:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nKtVxroy
Received: by kanga.kvack.org (Postfix)
	id A99C66B00EF; Sun, 15 Nov 2026 14:38:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A498E6B05B0; Sun, 15 Nov 2026 14:38:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9631F6B05B1; Sun, 15 Nov 2026 14:38:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6812D6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:38:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D826C80826
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:38:54 +0000 (UTC)
X-FDA: 85438366188.09.AB4E536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0A7491C0007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:38:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nKtVxroy;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794771533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W36Zk6V6pAaUlJITDCE9REdXESHzooXLlN9B7+Qdiw4=;
	b=yq3KI5aVGjHJ6ma3bNkCOYvRN4kTSCEUQLfJ14Gr2ycDvDOx7mlK3yR+zibTDVig6bFlRj
	NUZqKXD6EFDhIdK4C3EGJyQg3a8v/lfsxgEVPlhdJMtoFRZvVK91rJ3iQ1P8inj1TBdPhh
	Bv3qkc5jjGH35f1B3xaRO8M03IQiEV0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nKtVxroy;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794771533;
	b=lJKjRKUFXI8lcFgPQfoAWv1pVVOxL57leZix+/3YyPsdSeFLEMN1G9avqgHhnm4kQExVfB
	mcW0ze5bc5S49z4WL/SsyKVMeKxwzNh40HElgxzsBmk8o9m1FAgkhERvhT9C5/+VTv8oO7
	dHzbxY7vSBtj3NPGb+6x7bTAXNBXapg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C84E042B65;
	Sun, 15 Nov 2026 19:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E43C1F000C4;
	Sun, 15 Nov 2026 19:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794771531;
	bh=W36Zk6V6pAaUlJITDCE9REdXESHzooXLlN9B7+Qdiw4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nKtVxroyvw83RNvEeLmQesgxPMXIfX/mzS63tWQ6G9DaHyV51t4WHnqpbLARg835O
	 0ttalNP2e3QS1NMnBR3cvW+SSOaSUyXV8hbMclRlMZMP3g0R5am5n/UGlbzUFOOZA+
	 +B0JDcOCXtGjJTp3iwO5QUe3nYSgXWAkyX2IgIsg=
Date: Sun, 15 Nov 2026 11:38:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: mt4022@columbia.edu
Cc: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, tz2294@columbia.edu
Subject: Re: [PATCH] mm: annotate lockless accesses to vm_committed_as_batch
Message-Id: <20261115113851.f809d47b8356755c229278c2@linux-foundation.org>
In-Reply-To: <20261027-kcsan-mm-v1-1-66757485b917@columbia.edu>
References: <20261027-kcsan-mm-v1-1-66757485b917@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pebsuizraxag1qz9x748qa9t3a8tu7ia
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0A7491C0007
X-HE-Tag: 1794771532-625717
X-HE-Meta: U2FsdGVkX1+2vjyEb5R74b83oZQtJ4TtQFMhRAt3H9O4KCujCw9lgVBC6AMCbtwAyPrCBICngGzWcBxpPSGa4H22Pk4fGw6gTYwdnb10UrepUb/mn3vAQ65ZYUF3Uw8evzARg9rKKRjtPgR4tI58GSbxdZydDpglHsj5fvXVO/L+B5ti2+ZG/QWqZUDJMcx8lGvuwOaexGZ5DDuHPiQPAp7Kj1b/C5xVWsK2/zylzYEJjGRUSivmS3nKU5fr1/8Iy4xKuWWKiPUdB/JW1A8mC51m6MTPUiXYnEpU9q++rxAs74QKlRsok92pQy2SrvPV1bGEv0ZwVdDGYbMy5Y0HMvv/MjF6OUe54gUkJKjGCdfISvBuXSljdxE/Qbb75rAESd2cIMlhW0/2HUqWhpR2LQXsEJ455KXaNPwBnIawqM30PoJ7iTIW1nUQU4dgodmEiJsfyQfu16ChyOPB9d4JWLrKYSCD/k2tec3IaOo5J2phsvOIVNhN6dXa8ylZkAfFQo7gxtvIIM9eIWySRB72ydXH+zuyPwPC2HiSWVMjSKT5YJuJGPUbbM20/DAWVvZpjvMsbu2rpx2vUM+FKYa9ApPQuSJBKxZbOdshfwfbrs4OWaU6OaoVwsEhSEXac8cYa9Tarrxi8Gfbw+mNxxUXphxi4tDwOZS6FWKpaPoRtakXVdUZhaymBdMWApy219fUTtdDXv0HoKpGAl11U4I1F1Th+YJZnQWy+fU8X4A10oW5wpenfVz6eoOJg1R6Ix3dvApnmaVv80c03heA19VtiLWsAFqCFXhgtCx3j1tKq2/GYXdPDA7FK5UpgJC4JndWvk0Oz6W381TJGFMFOCgUTSCNDn62D9Cc/JeMoro8O1wyO841btq/WsC4217a3A9LovQjr65RafkKv98tU55/qxZxIBn0Pi6S3rEtzbCmEbqMWQX07TML6+oAFG9aCXtNei2y5O26W4Fl3Kq1R43
 COs5it9g
 gpuJApXwO6bfZU/ISWuX3n2E1hW+SCPzOPrp13JOCdY2B9aoynPSu5qGV72+1PY+tN+JR5m+foTegxzpwJyJIsNH7aOig7L38yOOENyLURAvOGi0+XvC9H2pjmjaPdiPHVAKf9nL3hCVEjBw7qkwd9BZHz5wnve7RrI0OUGyjv3M4nhux0iwG5dU0UVgBJbP95CcaRTsOvThg4f52y+RNixpg/aZSAssZUA3uGJ1YNj48OiamMQj31srqA7BiQtg3+dUlhW1rSBOaOTFvu0b110VrWDjO1YCZlEN6IT2PM33CldxxAniHeV5F1P+sTMnvHX85FRzR/ZLeB9xqpGzoYO0011E0w3Yoi8abGM+atavDmhkB97Qt4NlM370BFG9oDTKZEzuJGtJ1mtYHcRKAbE4rZhBue6VpcU15F06ETz54y6/WNI1Q5QoL6B6yCAQUcGwS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 16:09:01 -0400 Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org> wrote:

> From: Mani Tofigh <mt4022@columbia.edu>
> 
> vm_committed_as_batch is read without a lock, and it's only a hint for
> how often the per-CPU counts get folded, so racing with an update is
> harmless.  Annotate the accesses.
> 
>   [    0.953509] BUG: KCSAN: data-race in __vm_enough_memory / mm_compute_batch
> 
>   [    0.953645] write to 0xffffffff825165d8 of 4 bytes by task 1 on cpu 0:
>   [    0.953692]  mm_compute_batch+0xc2/0x120
>   [    0.953781]  mm_compute_batch_init+0x1c/0x20
>   ...
> 
>   [    0.954325] read to 0xffffffff825165d8 of 4 bytes by task 41 on cpu 1:
>   [    0.954373]  __vm_enough_memory+0x24/0x2b0
>   [    0.954444]  shmem_inode_acct_blocks+0x1b3/0x230
>   ...
> 
>   [    0.955288] value changed: 0x00000020 -> 0x00005003
> 
> Found with KCSAN while fuzzing under a deterministic hypervisor that's
> currently under development.
>
> ...
>
> --- a/include/linux/mman.h
> +++ b/include/linux/mman.h
> @@ -75,7 +75,8 @@ unsigned long vm_memory_committed(void);
>  
>  static inline void vm_acct_memory(long pages)
>  {
> -	percpu_counter_add_batch(&vm_committed_as, pages, vm_committed_as_batch);
> +	percpu_counter_add_batch(&vm_committed_as, pages,
> +				 data_race(vm_committed_as_batch));
>  }

ok, that'll squish the KCSAN report.  A reasonable change as long as
we're sure this is not-a-bug.

> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -211,7 +211,7 @@ void mm_compute_batch(int overcommit_policy)
>  	else
>  		memsized_batch = min_t(u64, ram_pages/nr/4, INT_MAX);
>  
> -	vm_committed_as_batch = max_t(s32, memsized_batch, batch);
> +	WRITE_ONCE(vm_committed_as_batch, max_t(s32, memsized_batch, batch));
>  }

But why this change?

