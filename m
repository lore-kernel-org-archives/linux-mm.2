Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD73ECFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 14:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BAF6B0023; Sun, 23 Nov 2025 09:16:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC756B0029; Sun, 23 Nov 2025 09:16:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02696B00A7; Sun, 23 Nov 2025 09:16:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC8876B0023
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 09:16:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3BB9E160C23
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:16:47 +0000 (UTC)
X-FDA: 84142072854.25.04CE084
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 920B4C0015
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:16:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnrpq6fX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763907405; a=rsa-sha256;
	cv=none;
	b=LQJgNIBTw56Cwn0nfqazJBypNshQ+5JH+NMvzy/CCTiAVGSfyUj5DDG8whx8BX8UZOfDlS
	aZXVxxTh4vMR4b/iW8AJrfhqxITl5wIBjM/7Bx3tYh8O3Y6AdDBLlHH5CziPlpwiqlu3o9
	DOQ1g8DzrWDFiErDSqhDzF4sEvXqut8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fnrpq6fX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763907405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViZWWcqvEhNBG0YfrZfq2524AMLeFOl0aaRed1DU+/8=;
	b=CxYOawg0YEooDjzFNZcy8v1o3ciiSlQ+/SZ35z0YMwHmC4kZ1Jo9N8e1t8uxZElKBI8Jir
	7RopI4dgoXg5raswuFAihGDseZz/VLUuEZRhJrU7b/qz5ZUyrf8JMxh+vMYLuG7BoVK3Lx
	47BFDp3GwdCxVKnUg3dWv5YaGiQLiXQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78FC160192;
	Sun, 23 Nov 2025 14:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4957EC113D0;
	Sun, 23 Nov 2025 14:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763907403;
	bh=4Xz3KOznAYb3M8bxg5UGBUpO8Ca5J6a4kiLtZ6+lz2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fnrpq6fXUrx9QXPgz+DBX+Qxzr/8ycksAoTg+LwWybP0PSZk4FDpF6DgEmo2LweQ+
	 9WRQNo+wYjPVEW84HwBUh6/j2fQvPZS1eYLtOuhesU/AlAoH9rCpA5u8O7ZN723wzg
	 17RfltwDDU/LSt1+oAQljK15ipIKPcAWW9sSBlmt9LqlYSFx1yvFd5rHpqU6m+GBo0
	 kRAAr9s8jITykV8Yvg2yjJze7/OSoExQCYaiTXAvO2qlXly5L1oNXj6uM0TmXpX4y/
	 z4M0z8J9H5dkjewW9/VPnD4ib9jTFsbBfXNvgGsHvJ+Lk95kBH6wLcxwB4k4R6OfAq
	 dV5bTMLRSo6Gg==
Date: Sun, 23 Nov 2025 16:16:19 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 04/22] liveupdate: luo_session: add sessions support
Message-ID: <aSMXM8ayzV2kx6Ws@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-5-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 920B4C0015
X-Stat-Signature: awdkoyswcuw7fedkcgifjukb37oq9epi
X-HE-Tag: 1763907405-479129
X-HE-Meta: U2FsdGVkX19hm+4qyL9fgmWn82zBjFQTOLCEfkX6Ep2UU0iFMfVz0sargSc40fmmp6Kp6IcxG2mFwK6jylRHdX/en600KhBOh45wse0xzMrNxHPLlx3Xgfhq0iNtSNpNxHu0IpnlBwJxgHgFnVUajvilqQ0gvT9LRZMSqyKOhZvxA5h5qTJclNiWB3c/2ysePRElsRsL17/GG7T1u/Lovnbpyet78RMPRVQFTNx1KU1iYKqnQx0Kkm75YuWsXz2wAsVdBo9xo+eWV2DRmW1rl8nDes1iW9Yo7H+Qw83ZL5jw6eHSCMEBhSFv/EGMrxrMgGT/GWxsIFPI1xZx28lhKmBO1E3DEqcN1k/ocdoBDMQTaQeTkZyiJDFb5eTxIrhfXg7fryiresfFGS20G8UIBTTo/GbzlvgkafshyX/6yfkB1GoPs9/oHK0/xeUuWi1DdPJMwhs/qSyOTXQjjUeDuAlDt7px+QNtOTSwHdGKiLqHONImKFnqr4hwm+bVJdXzGbGs5i6aGyFGeUFWCBSv7uSVOR4TQia6DViab6G52q7rXoHK2HphMBJsmVcPpQ8dZkLGHHSrDsjWB3xon24yX0J2HpExTJrhppuQeOKQv3clyMeIiBbPmmCcUHnG0R37YKVo9Dmof+lWZ4ikqWeNVEA5+Wp+TxNWjWEwcHbgkrOlf7zS0ghfdHhWYPwAyNSD1U0yjO6zJWjVeB9yG0wqRsU8g9UowOp2FpdqiIjoOypdDmLN4V3q3XuFziyfITOgklv10uZ9qj8nvdoM6p4OhS2MvmjGaBSrervXFdJxm7GfRAAFHS/juBifTvD2S2b+3UhHG18peW6rdY/JCNqsLoigWfjXtMYN1bB9HFOMzaDJx4fLdyYAoqwZqpOVhOUOyoAPRFnxtp0vfaBxkhXuOB6Y0JtUSXwaWkERhUY8SaMIKzGX4fa7LUAYfeLrcw2lgWuPLzDlW4RcMiO4Sjf
 tl0k6YuV
 O5lLmE/FuyUrDp9yVuxHmxb0SlPjuVb+Xp5w8TwlQ1H81md0S2qDre/mkw27HDIXbFFYq8DJ8oGeNpVeqGMUgwfGAcfoJYqE5OWRKg/Vd61BAzIXkiQj3kdgTXpyUA7r8cNQsEmy8wDAxYBsoKtptPh50x4Oy2C/zzAZoQfMBCT2eka89kjzC+R1Ts2snHkIBkBkvdOBPgE9f7fvb2+eVDibFNWwpKLPz05BjBx8J8k+uDE8sf8YRv4PFJQ8szBDBJg1U11DwM35Nh1HtHgMbVuAbXGlKbtc+mpXs7ORNJBCJ3LF84P4EDiYVaCL+hq59HvmIrd5+qjsPzCABJbrFMCkQ/2y0HnNDUjt1RxLNOsFpV+k1AYfQ/6Jii5fuRo9kB7af9jjDiP4DDdCPspqn+kOJYztdRUQBe/zNpEJeb+1JojybnMCirB3sRs8WOqX2SG0QrbjFpku1YNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:31PM -0500, Pasha Tatashin wrote:
> Introduce concept of "Live Update Sessions" within the LUO framework.
> LUO sessions provide a mechanism to group and manage `struct file *`
> instances (representing file descriptors) that need to be preserved
> across a kexec-based live update.
> 
> Each session is identified by a unique name and acts as a container
> for file objects whose state is critical to a userspace workload, such
> as a virtual machine or a high-performance database, aiming to maintain
> their functionality across a kernel transition.
> 
> This groundwork establishes the framework for preserving file-backed
> state across kernel updates, with the actual file data preservation
> mechanisms to be implemented in subsequent patches.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho/abi/luo.h      |  71 +++++
>  include/uapi/linux/liveupdate.h  |   3 +
>  kernel/liveupdate/Makefile       |   3 +-
>  kernel/liveupdate/luo_core.c     |   9 +
>  kernel/liveupdate/luo_internal.h |  29 ++
>  kernel/liveupdate/luo_session.c  | 462 +++++++++++++++++++++++++++++++
>  6 files changed, 576 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/liveupdate/luo_session.c
> 

...

> +int __init luo_session_setup_outgoing(void *fdt_out)
> +{
> +	struct luo_session_header_ser *header_ser;
> +	void *outgoing_buffer;
> +	u64 header_ser_pa;
> +	int err;
> +
> +	outgoing_buffer = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
> +	if (IS_ERR(outgoing_buffer))
> +		return PTR_ERR(header_ser);

Should be 
		return PTR_ERR(outgoing_buffer);

Or, preferably, just drop outgoing_buffer and use header_ser everywhere.

> +	header_ser = outgoing_buffer;
> +	header_ser_pa = virt_to_phys(header_ser);
> +
> +	err = fdt_begin_node(fdt_out, LUO_FDT_SESSION_NODE_NAME);
> +	err |= fdt_property_string(fdt_out, "compatible",
> +				   LUO_FDT_SESSION_COMPATIBLE);
> +	err |= fdt_property(fdt_out, LUO_FDT_SESSION_HEADER, &header_ser_pa,
> +			    sizeof(header_ser_pa));
> +	err |= fdt_end_node(fdt_out);
> +
> +	if (err)
> +		goto err_unpreserve;
> +
> +	luo_session_global.outgoing.header_ser = header_ser;
> +	luo_session_global.outgoing.ser = (void *)(header_ser + 1);
> +	luo_session_global.outgoing.active = true;
> +
> +	return 0;
> +
> +err_unpreserve:
> +	kho_unpreserve_free(header_ser);
> +	return err;
> +}

...

> +int luo_session_deserialize(void)
> +{
> +	struct luo_session_header *sh = &luo_session_global.incoming;
> +	static bool is_deserialized;
> +	static int err;
> +
> +	/* If has been deserialized, always return the same error code */
> +	if (is_deserialized)
> +		return err;

is_deserialized and err are uninitialized here.

> +
> +	is_deserialized = true;
> +	if (!sh->active)
> +		return 0;
> +

...

> +/**
> + * luo_session_quiesce - Ensure no active sessions exist and lock session lists.
> + *
> + * Acquires exclusive write locks on both incoming and outgoing session lists.
> + * It then validates no sessions exist in either list.
> + *
> + * This mechanism is used during file handler un/registration to ensure that no
> + * sessions are currently using the handler, and no new sessions can be created
> + * while un/registration is in progress.

It makes sense to add something like this comment from luo_file.c here as well:

	 * This prevents registering new handlers while sessions are active or
	 * while deserialization is in progress.

> + *
> + * Return:
> + * true  - System is quiescent (0 sessions) and locked.
> + * false - Active sessions exist. The locks are released internally.
> + */

With those addressed:

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>


-- 
Sincerely yours,
Mike.

