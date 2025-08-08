Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37302C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 11:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A64F6B007B; Fri,  8 Aug 2025 07:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DFC6B0088; Fri,  8 Aug 2025 07:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893DB6B0089; Fri,  8 Aug 2025 07:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9B06B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:42:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 073E21D700A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:42:36 +0000 (UTC)
X-FDA: 83753402712.29.D84F56E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3994B180006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:42:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=thXbzi8U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754653354; a=rsa-sha256;
	cv=none;
	b=q5SvVNmQqy8caYz1VvLXtdZZgcfM50EVqye5uLonA2XWXk22f9dBAbrPhqOmNMWCcnE65+
	iTWdyCK4LYMSxpr0bjonDU+owU2s09N3bL+70nYL1ouwIbm6HbgXXcc8FG75q8aWiEzdCv
	Kqg1wB2C79En/2h2+pPVQ6TJ31jLv+k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=thXbzi8U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754653354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fnfp8G7t+cNajZ6WDVQTyKMr/f8Q24sQzUgiK9R3Too=;
	b=mJpCInFYzmLLXotyr9EOgu5x4y8MBt+FV9ma+FM5nm1H09qAh5GOZqa1HdN/CwOwDKw6Vm
	3xx0nEWqCqCNNfEIYM5PPn3u/ZAC0A60ltw2JUXxc15IT8X8B013RerBtNZuNIZbxlHshe
	GkJ6/n4eHeRlMit5xKkeNi+WFbX6Tz0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B512944EE9;
	Fri,  8 Aug 2025 11:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F953C4CEED;
	Fri,  8 Aug 2025 11:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754653352;
	bh=+EXwIQbDINd7zs+mcit0rAyRB8QW/lOaVnLZfgR3OU4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=thXbzi8UdXsRGC6Qoy3VJbFEU21MkSCOaDClxHC2JK1GJZt0rBKoB1Jn+AH6aCiwi
	 b0g+JiFxsmHtOPyVLLIP38MuvNDBW1mHFNFAITJGNoRqJtYvVjkmjm6acnUCnynowh
	 g6z3N7QQLflKhYJYtEJiZG04QlZIGfT09dmtF5670e5T2hm26OfS1CsXEtZzvJw83I
	 w4zxtBzNlzwxi8sqj1C4dwf2LcZKCFKEp9F5c+F6rW5KqqUC9HWONnn97gcslfc0VX
	 +QP/gzK0YMadigtYGs3vb06wIiT9fNCYpkbZ5lkp5/VOcN1BNMPTw9E1lQThAMnU6l
	 PgoVhAgaXBGyg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  jasonmiu@google.com,  graf@amazon.com,
  changyuanl@google.com,  rppt@kernel.org,  dmatlack@google.com,
  rientjes@google.com,  corbet@lwn.net,  rdunlap@infradead.org,
  ilpo.jarvinen@linux.intel.com,  kanie@linux.alibaba.com,
  ojeda@kernel.org,  aliceryhl@google.com,  masahiroy@kernel.org,
  akpm@linux-foundation.org,  tj@kernel.org,  yoann.congal@smile.fr,
  mmaurer@google.com,  roman.gushchin@linux.dev,  chenridong@huawei.com,
  axboe@kernel.dk,  mark.rutland@arm.com,  jannh@google.com,
  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com,  lennart@poettering.net,  brauner@kernel.org,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  saeedm@nvidia.com,  ajayachandra@nvidia.com,  jgg@nvidia.com,
  parav@nvidia.com,  leonro@nvidia.com,  witu@nvidia.com
Subject: Re: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
In-Reply-To: <20250807014442.3829950-2-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
	<20250807014442.3829950-2-pasha.tatashin@soleen.com>
Date: Fri, 08 Aug 2025 13:42:22 +0200
Message-ID: <mafs0o6sqavkx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3994B180006
X-Stat-Signature: 9o7nkspq5j35qnedrwif5pdo4m5edhsd
X-Rspam-User: 
X-HE-Tag: 1754653353-169818
X-HE-Meta: U2FsdGVkX1/1UR/jP++WQ4PPaM1uI8IxMTA9EHg3ELNmwfC7BApvw4sjtDpfU6iD7bUTKjgi43UAVOQgC5RiYXZ49Jcy+MFc85r6OenNd/2noHI0whuQr9RAl+Omb9BsiH+LvMHT7ZxilKFH0xbMUv/UuAkjHoJ6eFxHWhDFvw6T11iPhwDB36bqa8oNH0GCNgVGKhGNzCVOGqWRX4R3PSaf9mVJFKKoinyA5HpxGBze3KSZbwTi7d37HxyreZaKY9z8axUbv9/gAjIAUC9B9bXOM2EypVMujzoaPWtucw1qfmU94tj0pdpOXbpeaZtkk+Wj9R/wVkq/1JbH1k0Yg+AYoIS8/TkBTigEWCnkTH/Kja9bazT54h0RKD34j6xvAzzbHiNeszi7dY+kpNy1EEnPyOYYngL+F/EgQOdbcxkEqazFlQxbpr1dayhwT50n7teM+eAO883OMAUmRRvToZaezIZlNbY4P3yZYe0vhSlLetbk9Y8l0/y+FAzM6l4MxOhChEUQ917mTfYhbSiPpzRJ15m5KMQWXh6xZZvOiFJIBsm5PBVmKjimo2i4Ga5XpRdG/cd/JIFbCoDYkXa2VrQlKflszkNskHzV8Vuf0XYjMI0by4wV0FdTJTSB2RfBLhbws9BtaRk7edCLTwz+6zgAPEjLM6rOBB8xnjH3Jb5gfx2TUacDDmpM6qTAPeuk6GYNT678l8dB8SBm8I4stmFbVVygtUZJqXqZ3POJRVyCznhCam/e4aH01AHRqFiZZ4fcEgzbsLBi98y5XvoNlinKhdyOS+8U/dOxG8ZjMPRIBBdwAjSlWaKMBluy8O1LphFAZW9gtd0LBtWL2V4QlNhDhBcWRZ+Tgzf8xXgBcKYNj/m7SPpNw3abCJzFKyY2PinwXIuXOBU+lO6ODEiQrmZmA8QZkmBOhh4iRRuWdV0bkN+PCcwZa9XCZzAIKTZslnhkDkimS1j3KVaeCSO
 9rAlNprB
 OM56B/Rml35MY/oauZEGvIOKArkuEDaLWEyL1WFMzL0HEu2dqee0M1gS6hHRU2wbZDZ3ZtgibvJ+JvVJcY5Gz3/pKt6QEYrD2Fz28KBashL6VRyaE/0OoFD4pCUK+WUV2uNXy5G+V4btMO2ZC1HjaQ3NMCT0J/3YOuoQGapg6q4uzxbPPfCuUx2jyVZXrxYvaCQ3bLcrnmabuN+QyNy/31peCWrnc9R59vLr5cmtO8rOSGejNcs3ySIIsT7q11/SEGIQjCuY6vDD/v5HOmYdjkJGj/UfkNxo+70MB9sKrg8M7FO5mHRiN1mq4sd+UidPVHPMG3godxMgtlLUeKZ82mUQ5EAMwT3JqQos020oz1DZ5WGFqnFsTTNOwCG5FcHESIQfuuRRl6iHK+aF8nQRiv/YmNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Thu, Aug 07 2025, Pasha Tatashin wrote:

> Lockdep shows the following warning:
>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
>
> [<ffffffff810133a6>] dump_stack_lvl+0x66/0xa0
> [<ffffffff8136012c>] assign_lock_key+0x10c/0x120
> [<ffffffff81358bb4>] register_lock_class+0xf4/0x2f0
> [<ffffffff813597ff>] __lock_acquire+0x7f/0x2c40
> [<ffffffff81360cb0>] ? __pfx_hlock_conflict+0x10/0x10
> [<ffffffff811707be>] ? native_flush_tlb_global+0x8e/0xa0
> [<ffffffff8117096e>] ? __flush_tlb_all+0x4e/0xa0
> [<ffffffff81172fc2>] ? __kernel_map_pages+0x112/0x140
> [<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
> [<ffffffff81359556>] lock_acquire+0xe6/0x280
> [<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
> [<ffffffff8100b9e0>] _raw_spin_lock+0x30/0x40
> [<ffffffff813ec327>] ? xa_load_or_alloc+0x67/0xe0
> [<ffffffff813ec327>] xa_load_or_alloc+0x67/0xe0
> [<ffffffff813eb4c0>] kho_preserve_folio+0x90/0x100
> [<ffffffff813ebb7f>] __kho_finalize+0xcf/0x400
> [<ffffffff813ebef4>] kho_finalize+0x34/0x70
>
> This is becase xa has its own lock, that is not initialized in
> xa_load_or_alloc.
>
> Modifiy __kho_preserve_order(), to properly call
> xa_init(&new_physxa->phys_bits);
>
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/kexec_handover.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index e49743ae52c5..6240bc38305b 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -144,14 +144,35 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  				unsigned int order)
>  {
>  	struct kho_mem_phys_bits *bits;
> -	struct kho_mem_phys *physxa;
> +	struct kho_mem_phys *physxa, *new_physxa;
>  	const unsigned long pfn_high = pfn >> order;
>  
>  	might_sleep();
>  
> -	physxa = xa_load_or_alloc(&track->orders, order, sizeof(*physxa));
> -	if (IS_ERR(physxa))
> -		return PTR_ERR(physxa);
> +	physxa = xa_load(&track->orders, order);
> +	if (!physxa) {
> +		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
> +		if (!new_physxa)
> +			return -ENOMEM;
> +
> +		xa_init(&new_physxa->phys_bits);
> +		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
> +				    GFP_KERNEL);
> +		if (xa_is_err(physxa)) {
> +			int err = xa_err(physxa);
> +
> +			xa_destroy(&new_physxa->phys_bits);
> +			kfree(new_physxa);
> +
> +			return err;
> +		}
> +		if (physxa) {
> +			xa_destroy(&new_physxa->phys_bits);
> +			kfree(new_physxa);
> +		} else {
> +			physxa = new_physxa;
> +		}

I suppose this could be simplified a bit to:

	err = xa_err(physxa);
        if (err || physxa) {
        	xa_destroy(&new_physxa->phys_bits);
                kfree(new_physxa);

		if (err)
                	return err;
	} else {
        	physxa = new_physxa;
	}

No strong preference though, so fine either way. Up to you.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

> +	}
>  
>  	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
>  				sizeof(*bits));

-- 
Regards,
Pratyush Yadav

