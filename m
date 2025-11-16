Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CE6CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 17:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6DC8E0018; Sun, 16 Nov 2025 12:06:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7C78E0005; Sun, 16 Nov 2025 12:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4964F8E0018; Sun, 16 Nov 2025 12:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 303508E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 12:06:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8BDB1609F7
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 17:06:25 +0000 (UTC)
X-FDA: 84117098730.06.A90565E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4A891140009
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 17:06:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FULWZXYE;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763312784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJaOho7BWxj6/3WV5yLLAEfgTCy9ERU6mnlnhb9Xf7Y=;
	b=ehn/skY8wYL2Yup07DpzRM+3X9xt/LGEegdMAW1iNg1OZ0fJNhxzpJp/LSO/EVzyQESsDT
	QIl9qQ1NLq6/TEm7l37+TbFJCU4bYoDt8Xn0Dzw/oIPj2lI4mF/6299OGbZB644AiLq5Nr
	WhbRHOV5Xa9AHanMzK4NqCp7F6Y4lWI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763312784; a=rsa-sha256;
	cv=none;
	b=OFzAElXgy1m7hIzbnhC6Ay95Zy1bDSs3tDKjWHQ2gWCtq/a057qdLrnV9oIzfTTjB7qtlE
	+49hDoeI+aOR0GXBFd//liBIuJqZX1sm2f3iEibE0EOGNd87aBdnZg9Aqyw/O/7wnH2XU3
	HZKYpinIxEgGGk31TyCuMUtefNqcUjg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FULWZXYE;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 39275601B8;
	Sun, 16 Nov 2025 17:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8822C4CEFB;
	Sun, 16 Nov 2025 17:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763312783;
	bh=sE5PAkx03kSWVxfn6P/KcKgNoFqgW26StGDSttnoICA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FULWZXYEYNfsWVuphzDEmuHpZCY7ou6y7Z8MsRuLjfoJVtckvvtAsAIwpYVhm6PR4
	 nJGXcMRZ9wnTVfBToQ6bQgbDhSmeahEcv8PJpTfmJ/ajABcYPPJLJjTvzOnPhwakFC
	 2UsHX2XgerJB5RoR3lRx8r2krOXsIbuoOGq4cChptjXfzXbB+Mtc3AF3RtKZnIXFUw
	 +RJKlQbSHDF7u+k47gqrdq50JXRjaE/K54OKknbiCOHrR4MB00n9ur7qCJ/H01t9sv
	 78sKtPik2J136oJlb9SguRGKwaoeB8RpY2vgEd8LgIgtdMn1Ln2y6jOOe6HiC+lo5w
	 jMu29QI/z5xEQ==
Date: Sun, 16 Nov 2025 19:05:58 +0200
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
Subject: Re: [PATCH v6 04/20] liveupdate: luo_session: add sessions support
Message-ID: <aRoEduya5EO8Xc1b@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-5-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A891140009
X-Stat-Signature: ns5nh6h4ja6fyo1jtj6iehwopa5rqrbc
X-Rspam-User: 
X-HE-Tag: 1763312784-755927
X-HE-Meta: U2FsdGVkX19GgNut3k81yLXZa0RnGAo1mgN7fomctqkAJmcGDgcEJ8slkLBqWPQDVkXc8GblVmsYmFxkheN4UXc63bQk3W1rps8i7CU8xECp+eyCAbZA5y85uqeI4O3TFohdVtmKrRj816P4IL7wufsIhIAzGayZHiRNhJZe263al0I8z2+aggs8J9Txk3I1K4bgesnl1tXznvpOCJUYIR//PSQTNhyX1wdcooM3EA7McQGmc11qjjHOn+eWDrqPlm95nPoxkCZpOGcDarTN/iBxuZhm7/NWYVAyjx50pTKog/+P6MqBkdXppYlJUskdepWwAOvZpLeDGJfGyZybNKM7JhJOsdI591IlbsJwxwuw9Vev1hjBrrJb7F0QBx6hpGRF0RcTHBmmhOYVWvW70BQe9l5LG6c3WY1eahVjc5k3RAS9fOsinljL0PcyCBPTnYkRskBsJffnUk8Mq8Ge4AwLoqexJv1p0C3dxYc2daKeCC5pneDTPZ8Yj2ugXMzg9JF4rVzIQA1tDOSPRs1asaW3HqzSQcesjVL5AFL+vt1kbbvM3H3KJzwEqP9ON2CAKU0Mh+9Dq1CTyEIm5e6nlT+/bIyhgn3Ye9qDmOJHE3WthRrveXGGnNoH7TstYO+7goeOGgGr/9qJg6YmvruXvKsh9zI/Wwc8NCWyfbkl+GUNO9Rr9nPLXMXAACjBgGItWoG4MFFiZ0kLrSmB+UQUXMQ3eScHZXNjyuNFnv2SmgrNFs1ZfmBiMvRn8U3M28PmaPCX6/y9Fu5esC1+p5LyzvkXD8AgqOd6Ea4jrj+jgGHCdSyQo9/mS+JCj91S61pTG4+Rtn2XMPTDLuHbFWcfVJehizkzMwgr1AfbwwLk61J1T9TMtM8iHNKDMT1KEYYGebjaZ6IzmvFUHaPklNnSt9/RDY/7TkYVMaju7+0+lWLLnB+eTlRXvKj7v2+vWD2nidj5vBCCsCTXehPCFj0
 wZO6lN/D
 p6vLBpJs0TyZvviqhgwkrXZ15t3YmnE88/av+6WsphxPuA5qkv5wCNhAb5Dkv88jP9noJOjfUzndSjWMvsZjma/0V1wxeqB2dVJZk72ME0ZlBHaJmf6+B2TnvzB7CTI1alR7Bu5TJwFixsCD4SXlPwtceP1aP/ZRXMWxMOYnTbpfkWg82QjLYnlSrKDUgoJzUZMumve4QrKZ6OAwU8M+8OIF/C4NZBQGSXnGnXoCuRH8YH8a08oanBle0I/9MXhD4KTvhuTQR9x2fKTQ08ntr5bA8yt3YyYzwiHk1UiD00mGYnP3wkO7iJwzXifxMX4sCqLFa1IP3AkjUEtz0IT7gg0xf0kg/sYKPPPNTl/1MzXZWy2HNZ7nwu3TqERNv2xjYijXprHnhzK4hoIVrLeGrk9zBktvtDOm7m53Igi72qQ/Js+s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:33:50PM -0500, Pasha Tatashin wrote:
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
>  include/linux/liveupdate/abi/luo.h |  83 +++++-
>  include/uapi/linux/liveupdate.h    |   3 +
>  kernel/liveupdate/Makefile         |   3 +-
>  kernel/liveupdate/luo_core.c       |  10 +
>  kernel/liveupdate/luo_internal.h   |  52 ++++
>  kernel/liveupdate/luo_session.c    | 421 +++++++++++++++++++++++++++++
>  6 files changed, 570 insertions(+), 2 deletions(-)
>  create mode 100644 kernel/liveupdate/luo_internal.h
>  create mode 100644 kernel/liveupdate/luo_session.c

...

> +/**
> + * struct luo_session_ser - Represents the serialized metadata for a LUO session.
> + * @name:    The unique name of the session, copied from the `luo_session`
> + *           structure.

I'd phase it as

		The unique name of the session provided by the userspace at
		the time of session creation.

> + * @files:   The physical address of a contiguous memory block that holds
> + *           the serialized state of files.

Maybe add                                    ^ in this session?

> + * @pgcnt:   The number of pages occupied by the `files` memory block.
> + * @count:   The total number of files that were part of this session during
> + *           serialization. Used for iteration and validation during
> + *           restoration.
> + *
> + * This structure is used to package session-specific metadata for transfer
> + * between kernels via Kexec Handover. An array of these structures (one per
> + * session) is created and passed to the new kernel, allowing it to reconstruct
> + * the session context.
> + *
> + * If this structure is modified, LUO_SESSION_COMPATIBLE must be updated.

This comment applies to the luo_session_header_ser description as well.

> + */
> +struct luo_session_ser {
> +	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> +	u64 files;
> +	u64 pgcnt;
> +	u64 count;
> +} __packed;
> +
>  #endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
> diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
> index df34c1642c4d..d2ef2f7e0dbd 100644
> --- a/include/uapi/linux/liveupdate.h
> +++ b/include/uapi/linux/liveupdate.h
> @@ -43,4 +43,7 @@
>  /* The ioctl type, documented in ioctl-number.rst */
>  #define LIVEUPDATE_IOCTL_TYPE		0xBA
>  
> +/* The maximum length of session name including null termination */
> +#define LIVEUPDATE_SESSION_NAME_LENGTH 56

You decided not to bump it to 64 in the end? ;-)

> +
>  #endif /* _UAPI_LIVEUPDATE_H */
> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> index 413722002b7a..83285e7ad726 100644
> --- a/kernel/liveupdate/Makefile
> +++ b/kernel/liveupdate/Makefile
> @@ -2,7 +2,8 @@
>  
>  luo-y :=								\
>  		luo_core.o						\
> -		luo_ioctl.o
> +		luo_ioctl.o						\
> +		luo_session.o
>  
>  obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
>  obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o

...

> +int luo_session_retrieve(const char *name, struct file **filep)
> +{
> +	struct luo_session_header *sh = &luo_session_global.incoming;
> +	struct luo_session *session = NULL;
> +	struct luo_session *it;
> +	int err;
> +
> +	scoped_guard(rwsem_read, &sh->rwsem) {
> +		list_for_each_entry(it, &sh->list, list) {
> +			if (!strncmp(it->name, name, sizeof(it->name))) {
> +				session = it;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (!session)
> +		return -ENOENT;
> +
> +	scoped_guard(mutex, &session->mutex) {
> +		if (session->retrieved)
> +			return -EINVAL;
> +	}
> +
> +	err = luo_session_getfile(session, filep);
> +	if (!err) {
> +		scoped_guard(mutex, &session->mutex)
> +			session->retrieved = true;

Retaking the mutex here seems a bit odd. 
Do we really have to lock session->mutex in luo_session_getfile()?

> +	}
> +
> +	return err;
> +}

...

> +int __init luo_session_setup_incoming(void *fdt_in)
> +{
> +	struct luo_session_header_ser *header_ser;
> +	int err, header_size, offset;
> +	u64 header_ser_pa;
> +	const void *ptr;
> +
> +	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_SESSION_NODE_NAME);
> +	if (offset < 0) {
> +		pr_err("Unable to get session node: [%s]\n",
> +		       LUO_FDT_SESSION_NODE_NAME);
> +		return -EINVAL;
> +	}
> +
> +	err = fdt_node_check_compatible(fdt_in, offset,
> +					LUO_FDT_SESSION_COMPATIBLE);
> +	if (err) {
> +		pr_err("Session node incompatible [%s]\n",
> +		       LUO_FDT_SESSION_COMPATIBLE);
> +		return -EINVAL;
> +	}
> +
> +	header_size = 0;
> +	ptr = fdt_getprop(fdt_in, offset, LUO_FDT_SESSION_HEADER, &header_size);
> +	if (!ptr || header_size != sizeof(u64)) {
> +		pr_err("Unable to get session header '%s' [%d]\n",
> +		       LUO_FDT_SESSION_HEADER, header_size);
> +		return -EINVAL;
> +	}
> +
> +	header_ser_pa = get_unaligned((u64 *)ptr);
> +	header_ser = phys_to_virt(header_ser_pa);
> +
> +	luo_session_global.incoming.header_ser = header_ser;
> +	luo_session_global.incoming.ser = (void *)(header_ser + 1);
> +	INIT_LIST_HEAD(&luo_session_global.incoming.list);
> +	init_rwsem(&luo_session_global.incoming.rwsem);
> +	luo_session_global.incoming.active = true;
> +
> +	return 0;
> +}
> +
> +bool luo_session_is_deserialized(void)
> +{
> +	return luo_session_global.deserialized;
> +}
> +
> +int luo_session_deserialize(void)
> +{
> +	struct luo_session_header *sh = &luo_session_global.incoming;
> +	int err;
> +
> +	if (luo_session_is_deserialized())
> +		return 0;
> +
> +	luo_session_global.deserialized = true;
> +	if (!sh->active) {
> +		INIT_LIST_HEAD(&sh->list);
> +		init_rwsem(&sh->rwsem);
> +		return 0;

How this can happen? luo_session_deserialize() is supposed to be called
from ioctl and luo_session_global.incoming should be set up way earlier.

And, why don't we initialize ->list and ->rwsem statically?

> +	}
> +
> +	for (int i = 0; i < sh->header_ser->count; i++) {
> +		struct luo_session *session;
> +
> +		session = luo_session_alloc(sh->ser[i].name);
> +		if (IS_ERR(session)) {
> +			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
> +				sh->ser[i].name, session);
> +			return PTR_ERR(session);
> +		}

The allocated sessions still need to be freed if an insert fails ;-)

> +
> +		err = luo_session_insert(sh, session); 
> +		if (err) {
> +			luo_session_free(session);
> +			pr_warn("Failed to insert session [%s] %pe\n",
> +				session->name, ERR_PTR(err));
> +			return err;
> +		}
> +
> +		session->count = sh->ser[i].count;
> +		session->files = sh->ser[i].files ? phys_to_virt(sh->ser[i].files) : 0;
> +		session->pgcnt = sh->ser[i].pgcnt;
> +	}
> +
> +	kho_restore_free(sh->header_ser);
> +	sh->header_ser = NULL;
> +	sh->ser = NULL;
> +
> +	return 0;
> +}

-- 
Sincerely yours,
Mike.

