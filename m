Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1449CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 13:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E4E6B0092; Tue, 12 May 2026 09:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE956B0093; Tue, 12 May 2026 09:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD1D6B0095; Tue, 12 May 2026 09:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD086B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:36:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1EBCC1DE0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:36:01 +0000 (UTC)
X-FDA: 84758866122.05.C0EAE9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3CD6D4000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:36:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+KzXlHL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778592960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJVRmrWY8ECPCmpNM1N5ylsHwr/Xfj3IfxERkPhTk+o=;
	b=j5TaqBwEMYNVFvUq9hwV9jiXfwY+tzvuWaR1aqJRmJzKH9dfc4tefF32qgtyCuMd0Wqmi7
	AR0rCWbtlF6pe65MkyR0Hy3n4WAfVRasT4zgGYSy7tSGU5DhYzzrs2H+YOOI8Rl+yenrHU
	c+JhkPGXFxSoLztTKGeL3NaqLpnSHd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778592960; a=rsa-sha256;
	cv=none;
	b=IjWtrX9AHnnHC9xM115HhWr4mINP0LUkzHEYOaQhIHYWyKxDEOTj2EzoQQqGTXOika1wXq
	X4tkIDfM5+vm8xeW02r+RcaPY+BzS2qIxpJEnvrnSuUMSRFIIsTR6nS5ZrGXBV9OKntfJH
	iDteRjuIpedcYyKoVUeU/rEMYZ3NdKg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b+KzXlHL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7908361331;
	Tue, 12 May 2026 13:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5ACC2BCF6;
	Tue, 12 May 2026 13:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778592959;
	bh=TBdhmd5n2zQemoktunspBdFKugVGegbYfrM0b0A2MnY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=b+KzXlHLf53WqJdOmBudjpLcba+cmC7dkokv5RZU4iw4vK14QCgJYPWSGvqZJixAF
	 3HRPoxKFnCKJtm0U/SPPt3Hf47p4vPKC8iKpv8rzeFauzaALBJJnpFHwohShlzcNL1
	 0iBDrerqsaYsa1nFwdK1GhgSeqBMw9KsNe2Dwtjk9bgpchejsJxrNsOnFICNMNZvKC
	 FkOKGcNE+318tWtcAv1LE4mxUwY8QxEBKQPiAFbGrM3xDKPbp9Q3EKWsRxB9b13swE
	 xyqxJH6Eup6jK0SVS8P84dQhXYiBgzGcBI8BDcMHaS7cNmcAg+YD2mYfmlFJ/hl6n6
	 7lTaMSBIp7itg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH 1/5] liveupdate: Remove limit on the number of sessions
In-Reply-To: <20260414200237.444170-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 14 Apr 2026 20:02:33 +0000")
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
	<20260414200237.444170-2-pasha.tatashin@soleen.com>
Date: Tue, 12 May 2026 15:35:55 +0200
Message-ID: <2vxz1pfgbvic.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CD6D4000F
X-Rspamd-Server: rspam04
X-Stat-Signature: ibpko6yb3c93r1aakadq5yoa1a4ucbwm
X-HE-Tag: 1778592960-985228
X-HE-Meta: U2FsdGVkX19WdfjeMQ91m2VADpDD18RNCwW67TyN8jrLG6Q8Eio2+p4IlFtTg3Pou+ojNkvMoIn449m1wacqIOiZOMxuvSHAhM8127JhCXFZr4+rk+OrnGHde+x7hfTEIGs039UB50xhnDbwnB7so0AD2mqdu7FI+Nfk0BwJPd5PyqlAqswdCR5fffchFNTj+eJBtonRbeTgIvKQ1prR02L+TV3ExBNsCuaVQ5BCAJPVY0Fkr/FpU7EFlSqviktcm6+aImVj6IPFzQNnmG3cMoC46A74V9IetuRYiP/0AoVfY9kXavwqYxpzkvCCkCKVe/cpGYW444fVyEZSYszefuTzsRIJQe75zqeNDkZ86iwv1YscB689wz8BUPA/ZeymBUUJtM/J0dSV2OH15SKOfsb+lj5Qxdi1x6QKVZHZZYjgUFwwJoYBI7Yq1Y0LpIImlymyX4Fynq5S490PpSRjVW6e3ACxzI5/v1t54FFXmtgjXYwzJP4tsaC6dCXuE9LqBf1oJe1nB3Z2jWnYQjEtUvl0nUfTa+pdiuau+foD5HUY7uOlbAjRol8vYuPXMvn0/kkUYAGVSFCvxWz3QD1NEeumasBgf/9HPFRLYcQB4U99ePcjatlU3BsBKAiRnLVjI0BXu22+WVIAifVxsskhog7EDLJcVVPdrcy2Td7ghtuP9rXTXhc7ZqmlLuq1WoBgGsGbcMV5ZjVprqYIpnB03SYIpHB2cNYd96LO6yXfl2NRVxRqUhU6jx6jG3/aLdLJ4Tu1rOhjmF3WN9k7HIgdQBve5BLDHx2mBU12yVxDh5OyII6a1YCQBOy1h5JlTqXYJgVeBdZbKVF6NXAHDuvSPEDjL6uRPxVD9oFeU84y2AaK/WB3NQezuipp5jHa+K1TWsgJNlJuLuAbexmwuYlKtck0sAmiHD7JGEf9QOYSnGUacgcNPOfNPzvT0R1AIx+FEsHVms9j7LxqIp8voh2
 2MRD4UVM
 OzuKUrMMjt8qCdoBakNAb4Vh+jZGpfYSEz7bJz/S2Z7QrFJKhF6/kxcwhDTfRR6laOnE72y6clH08GzvWbeHXRMC+4Jfy+QWtqLJpsQwBMwA0KBTrzFzvOkYNWk4VSCMQroFq1i9jSM2vjjiewUQndu5IXnAvlaMOgUBLldvI6FGFElnYCFwWypAFSqwLytxepFxJbSk9EsMX1owCN5a1K2dc8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14 2026, Pasha Tatashin wrote:

> Currently, the number of LUO sessions is limited by a fixed number of
> pre-allocated pages for serialization (16 pages, allowing for ~819
> sessions).
>
> This limitation is problematic if LUO is used to support things such as
> systemd file descriptor store, and would be used not just as VM memory
> but to save other states on the machine.
>
> Remove this limit by transitioning to a linked-block approach for
> session metadata serialization. Instead of a single contiguous block,
> session metadata is now stored in a chain of 16-page blocks. Each block
> starts with a header containing the physical address of the next block
> and the number of session entries in the current block.

We now have 3 variants of this linked block data structure: LUO
sessions, LUO files, and KHO vmalloc. Is it time now to unify them into
a reusable data structure? I proposed "KHO Array" some time ago. That
was a collection of pointers, but perhaps we can generalize that to a
collection of elements of arbitrary size?

[0] https://lore.kernel.org/linux-mm/20250909144426.33274-1-pratyush@kernel.org/T/#u

>
> - Bump session ABI version to v3.
> - Update struct luo_session_header_ser to include a 'next' pointer.
> - Implement dynamic block allocation in luo_session_insert().
> - Update setup, serialization, and deserialization logic to traverse
>   the block chain.
> - Remove LUO_SESSION_MAX limit.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho/abi/luo.h      |  19 +--
>  kernel/liveupdate/luo_internal.h |  12 +-
>  kernel/liveupdate/luo_session.c  | 237 +++++++++++++++++++++++--------
>  3 files changed, 197 insertions(+), 71 deletions(-)
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 46750a0ddf88..f5732958545e 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -57,9 +57,10 @@
>   *   - compatible: "luo-session-v1"
>   *     Identifies the session ABI version.
>   *   - luo-session-header: u64
> - *     The physical address of a `struct luo_session_header_ser`. This structure
> - *     is the header for a contiguous block of memory containing an array of
> - *     `struct luo_session_ser`, one for each preserved session.
> + *     The physical address of the first `struct luo_session_header_ser`.
> + *     This structure is the header for a block of memory containing an array
> + *     of `struct luo_session_ser` entries. Multiple blocks are linked via
> + *     the `next` field in the header.
>   *
>   * File-Lifecycle-Bound Node (luo-flb):
>   *   This node describes all preserved global objects whose lifecycle is bound
> @@ -77,9 +78,9 @@
>   *   `__packed` structures. These structures contain the actual preserved state.
>   *
>   *   - struct luo_session_header_ser:
> - *     Header for the session array. Contains the total page count of the
> - *     preserved memory block and the number of `struct luo_session_ser`
> - *     entries that follow.
> + *     Header for the session data block. Contains the physical address of the
> + *     next session data block and the number of `struct luo_session_ser`
> + *     entries that follow this header in the current block.
>   *
>   *   - struct luo_session_ser:
>   *     Metadata for a single session, including its name and a physical pointer
> @@ -153,21 +154,23 @@ struct luo_file_set_ser {
>   *                          luo_session_header_ser
>   */
>  #define LUO_FDT_SESSION_NODE_NAME	"luo-session"
> -#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v2"
> +#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v3"
>  #define LUO_FDT_SESSION_HEADER		"luo-session-header"
>  
>  /**
>   * struct luo_session_header_ser - Header for the serialized session data block.
> + * @next:  Physical address of the next struct luo_session_header_ser.
>   * @count: The number of `struct luo_session_ser` entries that immediately
>   *         follow this header in the memory block.
>   *
> - * This structure is located at the beginning of a contiguous block of
> + * This structure is located at the beginning of a block of
>   * physical memory preserved across the kexec. It provides the necessary
>   * metadata to interpret the array of session entries that follow.
>   *
>   * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must be updated.
>   */
>  struct luo_session_header_ser {
> +	u64 next;
>  	u64 count;
>  } __packed;
>  
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 875844d7a41d..a73f42069301 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -11,6 +11,16 @@
>  #include <linux/liveupdate.h>
>  #include <linux/uaccess.h>
>  
> +/*
> + * Safeguard limit for the number of serialization blocks. This is used to
> + * prevent infinite loops and excessive memory allocation in case of memory
> + * corruption in the preserved state.
> + *
> + * This limit allows for ~8.1 million sessions and ~1.2 million files per
> + * session, which is more than enough for all realistic use cases.
> + */
> +#define LUO_MAX_BLOCKS 10000
> +
>  struct luo_ucmd {
>  	void __user *ubuffer;
>  	u32 user_size;
> @@ -59,7 +69,6 @@ struct luo_file_set {
>   * struct luo_session - Represents an active or incoming Live Update session.
>   * @name:       A unique name for this session, used for identification and
>   *              retrieval.
> - * @ser:        Pointer to the serialized data for this session.
>   * @list:       A list_head member used to link this session into a global list
>   *              of either outgoing (to be preserved) or incoming (restored from
>   *              previous kernel) sessions.
> @@ -70,7 +79,6 @@ struct luo_file_set {
>   */
>  struct luo_session {
>  	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> -	struct luo_session_ser *ser;

I was confused by this removal. Seeing this makes one think this got
moved to some other place. But it seems like this was never used. I
think it would be good to mention that in the commit message.

>  	struct list_head list;
>  	bool retrieved;
>  	struct luo_file_set file_set;
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 92b1af791889..007ca34eba79 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -69,30 +69,39 @@
>  #include <uapi/linux/liveupdate.h>
>  #include "luo_internal.h"
>  
> -/* 16 4K pages, give space for 744 sessions */
> +/* 16 4K pages, give space for 819 sessions per block */

It seems odd to read that we added 8 bytes to the header and the number
of sessions per block grew. But then I did the math and I think the
number was always 819 sessions per block and adding the extra 8 bytes
didn't make a difference.

>  #define LUO_SESSION_PGCNT	16ul
> -#define LUO_SESSION_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
> +#define LUO_SESSION_BLOCK_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
>  		sizeof(struct luo_session_header_ser)) /		\
>  		sizeof(struct luo_session_ser))
>  
> +/**
> + * struct luo_session_block - Internal representation of a session serialization block.
> + * @list: List head for linking blocks in memory.
> + * @ser:  Pointer to the serialized header in preserved memory.
> + */
> +struct luo_session_block {
> +	struct list_head list;
> +	struct luo_session_header_ser *ser;

Nit: luo_session_header_ser reads like it is the header for the entire
list not for each block. Perhaps rename it to luo_block_header_ser?

> +};
> +
>  /**
>   * struct luo_session_header - Header struct for managing LUO sessions.
>   * @count:      The number of sessions currently tracked in the @list.
> + * @nblocks:    The number of allocated serialization blocks.
>   * @list:       The head of the linked list of `struct luo_session` instances.
>   * @rwsem:      A read-write semaphore providing synchronized access to the
>   *              session list and other fields in this structure.
> - * @header_ser: The header data of serialization array.
> - * @ser:        The serialized session data (an array of
> - *              `struct luo_session_ser`).
> + * @blocks:     The list of serialization blocks (struct luo_session_block).
>   * @active:     Set to true when first initialized. If previous kernel did not
>   *              send session data, active stays false for incoming.
>   */
>  struct luo_session_header {
>  	long count;
> +	long nblocks;
>  	struct list_head list;
>  	struct rw_semaphore rwsem;
> -	struct luo_session_header_ser *header_ser;
> -	struct luo_session_ser *ser;
> +	struct list_head blocks;
>  	bool active;
>  };
>  
> @@ -110,10 +119,12 @@ static struct luo_session_global luo_session_global = {
>  	.incoming = {
>  		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
>  		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
> +		.blocks = LIST_HEAD_INIT(luo_session_global.incoming.blocks),
>  	},
>  	.outgoing = {
>  		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
>  		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
> +		.blocks = LIST_HEAD_INIT(luo_session_global.outgoing.blocks),
>  	},
>  };
>  
> @@ -140,6 +151,70 @@ static void luo_session_free(struct luo_session *session)
>  	kfree(session);
>  }
>  
> +static int luo_session_add_block(struct luo_session_header *sh,
> +				 struct luo_session_header_ser *ser)
> +{
> +	struct luo_session_block *block;
> +
> +	if (sh->nblocks >= LUO_MAX_BLOCKS)
> +		return -ENOSPC;
> +
> +	block = kzalloc_obj(*block);
> +	if (!block)
> +		return -ENOMEM;
> +
> +	block->ser = ser;
> +	list_add_tail(&block->list, &sh->blocks);
> +	sh->nblocks++;
> +
> +	return 0;
> +}
> +
> +static int luo_session_create_ser_block(struct luo_session_header *sh)
> +{
> +	struct luo_session_block *last = NULL;
> +	struct luo_session_header_ser *ser;
> +	int err;
> +
> +	ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
> +	if (IS_ERR(ser))
> +		return PTR_ERR(ser);
> +
> +	if (!list_empty(&sh->blocks))
> +		last = list_last_entry(&sh->blocks, struct luo_session_block, list);

Nit: using list_last_entry_or_null() is a tiny bit cleaner.

> +
> +	err = luo_session_add_block(sh, ser);
> +	if (err)
> +		goto err_unpreserve;
> +
> +	if (last)
> +		last->ser->next = virt_to_phys(ser);

Nit: can you please move this to luo_session_add_block(). Logically this
operation is a part of adding a block. You add a block to the list and
then update the serialized state. So would be nice to have it done in
one place.

> +
> +	return 0;
> +
> +err_unpreserve:
> +	kho_unpreserve_free(ser);
> +	return err;
> +}
> +
> +static void luo_session_destroy_ser_blocks(struct luo_session_header *sh,
> +					   bool unpreserve)
> +{
> +	struct luo_session_block *block, *tmp;
> +
> +	list_for_each_entry_safe(block, tmp, &sh->blocks, list) {
> +		if (block->ser) {

Block always has ser. Why this check?

> +			if (unpreserve)
> +				kho_unpreserve_free(block->ser);
> +			else
> +				kho_restore_free(block->ser);

Ugh, this is ugly. But I don't see anything obviously better. Perhaps we
can check for sh == luo_session_global.outgoing but that is probably
worse.

> +		}
> +		list_del(&block->list);
> +		kfree(block);
> +		sh->nblocks--;
> +	}
> +}
> +
>  static int luo_session_insert(struct luo_session_header *sh,
>  			      struct luo_session *session)
>  {
> @@ -147,15 +222,6 @@ static int luo_session_insert(struct luo_session_header *sh,
>  
>  	guard(rwsem_write)(&sh->rwsem);
>  
> -	/*
> -	 * For outgoing we should make sure there is room in serialization array
> -	 * for new session.
> -	 */
> -	if (sh == &luo_session_global.outgoing) {
> -		if (sh->count == LUO_SESSION_MAX)
> -			return -ENOMEM;
> -	}
> -
>  	/*
>  	 * For small number of sessions this loop won't hurt performance
>  	 * but if we ever start using a lot of sessions, this might
> @@ -166,6 +232,20 @@ static int luo_session_insert(struct luo_session_header *sh,
>  		if (!strncmp(it->name, session->name, sizeof(it->name)))
>  			return -EEXIST;
>  	}
> +
> +	/*
> +	 * For outgoing we should make sure there is room in serialization array
> +	 * for new session. If not, allocate a new block.
> +	 */
> +	if (sh == &luo_session_global.outgoing) {
> +		if (sh->count == sh->nblocks * LUO_SESSION_BLOCK_MAX) {
> +			int err = luo_session_create_ser_block(sh);
> +
> +			if (err)
> +				return err;
> +		}
> +	}
> +

Since we just allocate space here and not actually fill it yet, I think
we can do the same check in luo_session_remove() to free blocks once
session count falls below (sh->nblocks - 1) * LUO_SESSION_BLOCK_MAX.
This prevents memory leak if the number of sessions goes too high at
some point and then falls back down.

Not that I think it is something likely to happen, but I don't see why
not.

Perhaps also abstract this out to a helper function for readability?

>  	list_add_tail(&session->list, &sh->list);
>  	sh->count++;
>  
> @@ -444,9 +524,12 @@ int __init luo_session_setup_outgoing(void *fdt_out)
>  	u64 header_ser_pa;
>  	int err;
>  
> -	header_ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
> -	if (IS_ERR(header_ser))
> -		return PTR_ERR(header_ser);
> +	err = luo_session_create_ser_block(&luo_session_global.outgoing);
> +	if (err)
> +		return err;
> +
> +	header_ser = list_first_entry(&luo_session_global.outgoing.blocks,
> +				      struct luo_session_block, list)->ser;

I suppose it would be a tiny bit better to create a placeholder entry
here and then fill it up later in luo_session_serialize(). This would
result in the first block not being a special case and it can be
allocated and freed on demand list the rest of the blocks.

I won't insist on it but would be nice to have IMO if you're willing to
do the refactor.

>  	header_ser_pa = virt_to_phys(header_ser);
>  
>  	err = fdt_begin_node(fdt_out, LUO_FDT_SESSION_NODE_NAME);
> @@ -459,19 +542,18 @@ int __init luo_session_setup_outgoing(void *fdt_out)
>  	if (err)
>  		goto err_unpreserve;
>  
> -	luo_session_global.outgoing.header_ser = header_ser;
> -	luo_session_global.outgoing.ser = (void *)(header_ser + 1);
>  	luo_session_global.outgoing.active = true;
>  
>  	return 0;
>  
>  err_unpreserve:
> -	kho_unpreserve_free(header_ser);
> +	luo_session_destroy_ser_blocks(&luo_session_global.outgoing, true);
>  	return err;
>  }
>  
>  int __init luo_session_setup_incoming(void *fdt_in)
>  {
> +	struct luo_session_header *sh = &luo_session_global.incoming;
>  	struct luo_session_header_ser *header_ser;
>  	int err, header_size, offset;
>  	u64 header_ser_pa;
[...]

-- 
Regards,
Pratyush Yadav

