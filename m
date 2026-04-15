Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D49F9D0F6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 00:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687846B0089; Tue, 14 Apr 2026 20:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6649D6B0093; Tue, 14 Apr 2026 20:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574696B0095; Tue, 14 Apr 2026 20:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 454276B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:06:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1A2A1A02F3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:06:00 +0000 (UTC)
X-FDA: 84658847280.12.CEB8EAC
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB1BAC0010
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:05:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aq4Ie8hF;
	spf=pass (imf28.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776211559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOd9q1sGqtuwL8YJ3MZCe93Mf1n4dHgmCiYepxx9yoA=;
	b=LxWqZyE9RhkkZOxtwXoVTMcpfxTteULcpAHUFcOiPAzWymLxRyOqMu7+sizWAfVExWWYQO
	LsnEGf/0JYYIXcd7kK9R/tcNQk8FNhg/S6YGNU3WdMJep1yOaXWP7kUumE8zuK5nxyvskL
	zeuqCHZMogO1VFYIFwf7hMwD57dZx/U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Aq4Ie8hF;
	spf=pass (imf28.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776211559; a=rsa-sha256;
	cv=none;
	b=fey8nTwcNLgVFZjbJD42DE0sGS0SihN/hfSmgbqwBdECNca7gP5P7a1bCy92UJ6xHlGpwN
	bahu0WxGhmwrNYEM2/A4mEpI/9EL+uY3rJA+GD4UGqNFxY2dViyblrfPSDRPHcYbIm3bYh
	SN5RWAYQqkAtBi509CLmQM9501bz3sU=
Message-ID: <4bd21077-8711-4ae7-a695-8bc88ce652d1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776211556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IOd9q1sGqtuwL8YJ3MZCe93Mf1n4dHgmCiYepxx9yoA=;
	b=Aq4Ie8hFUmtE4wBZqOm2sIK+PurhEoU3c+sovMYKiPNqs7cYVDhD8agWhBfDQzYXMAxaZT
	qYN53DOkKslqBi1/PSk4ayLs/v/mxvHULIeYUvRVn1ynKOmwTCk1PBgJVPFjqseRr4WQfw
	if9OtyNjyzMTIqAFAzw8VVRYfk9+7f8=
Date: Tue, 14 Apr 2026 17:05:50 -0700
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] liveupdate: Remove limit on the number of sessions
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
 linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org,
 skhawaja@google.com, graf@amazon.com, Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
 <20260414200237.444170-2-pasha.tatashin@soleen.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <20260414200237.444170-2-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: csds4atwuo5tpjmzwufsmutn5bntj6bp
X-Rspamd-Queue-Id: BB1BAC0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1776211558-196037
X-HE-Meta: U2FsdGVkX1/ydYWT1p9xzJRbrld6rlusM8BWzy8ypbucAxAb13wKUH6biHbnk1hpKBsNPQxusaPBlK13KLc4V4JsvSeK2264xAFxDblnNxrG9yk77fu2wptwIb0TKA5Uy2BFyQfd0C/zZ1PKkvY7Hq+Rus7zJaIuSraqhzhm2TfFKO+jbONw8c6+czqNHm9qNFBtq/1AgxtyrUQh03/JzpjUWkluYwgMa8QNwzsiOTy8FOQh3Q+48ak3CNYZOA24UBdXmGm/MsYDj5RyNF8CpqkX65+IXnE26IqRZDaVqJNV1GFJCV4n6/X/v99AYV8o9OO/rZqX8wsJTRS1TvRlbhMCCrddy/ZpNfBGMzTihapu+FGnP1Hq6+m1U6q6HWU/5feNPSAyh9QFJMxEp2rPp4iXCCNeYYpT9PeWWCu1xJXelySJ1+wCFpigUVqBIw2uSU0JM/K9GWnw8bljUpHYKP/rUPMrF0nNzvnSMKBB+wrLXcmeGv0y6vanohjKZf1MSRf1KwiEyJdTXK2vc7+N9M9GGYXAQGyVA3i4KKV8noqoveF23hXlnWS0jYnnU45hITkyo+waMAa/NF2NiHEa8AcaZXbyjLOgucF6L8UZLUvAcXM3ncEkWAZZi6wLyaq2xxfy7m6I71Z9rIm4MlnUmSuFNXfSzxv1dREBWpy7v6fB2qpw0IIONmTWz4DiXmuqCw5DFQ3WKCOWQ8y6WOTvyhctJo+wvp7EWInFqdHwIEYPJ/bVgEZbIjthMX8ecHBJTJQTwibYIQIYk6OOVy7sLUGdk3pQeu6I1nTWh+HZ094XiwBdbQillAKwyE3vAOLyNnayJgDU3yqmk6amOFkW6tBTr7A/xOPa0DIPgc9PuPWHJ6hRMgCKthf1WBn6aRTgIwrFSS0GX/jDUjAMgc531sv1m7eNczbpJLURjLynfriyfikey+fwPQ4e6uMgc2RfgANFHl/pAaHrA215ycB
 U3kJBJyZ
 LwTgWo8t7vMMDf2k0vCgqdUnsKfWmrcyv0nxMYX/+wvUF7m54ZuERJcJKnoyp8O9OsgtI5zHRK8Z7nPjJMrzJ7R6aBuCNP3/9njkD3FUKp7D6c98a1AyOZVyHYHceTvsjXaOWVvMozn+5ARzp9PR1bGIEtKeDiWNUM93+GdTEUDN8dtvZmcua8rocnQnsOU1kbsiHr9DpkQE98+G9HQdYuHNzxM5ERLSkgzmzx6UcBE5yd0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 1:02 PM, Pasha Tatashin wrote:
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
> 
> - Bump session ABI version to v3.
> - Update struct luo_session_header_ser to include a 'next' pointer.
> - Implement dynamic block allocation in luo_session_insert().
> - Update setup, serialization, and deserialization logic to traverse
>    the block chain.
> - Remove LUO_SESSION_MAX limit.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>   include/linux/kho/abi/luo.h      |  19 +--
>   kernel/liveupdate/luo_internal.h |  12 +-
>   kernel/liveupdate/luo_session.c  | 237 +++++++++++++++++++++++--------
>   3 files changed, 197 insertions(+), 71 deletions(-)
> 
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 46750a0ddf88..f5732958545e 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -57,9 +57,10 @@
>    *   - compatible: "luo-session-v1"
>    *     Identifies the session ABI version.
>    *   - luo-session-header: u64
> - *     The physical address of a `struct luo_session_header_ser`. This structure
> - *     is the header for a contiguous block of memory containing an array of
> - *     `struct luo_session_ser`, one for each preserved session.
> + *     The physical address of the first `struct luo_session_header_ser`.
> + *     This structure is the header for a block of memory containing an array
> + *     of `struct luo_session_ser` entries. Multiple blocks are linked via
> + *     the `next` field in the header.
>    *
>    * File-Lifecycle-Bound Node (luo-flb):
>    *   This node describes all preserved global objects whose lifecycle is bound
> @@ -77,9 +78,9 @@
>    *   `__packed` structures. These structures contain the actual preserved state.
>    *
>    *   - struct luo_session_header_ser:
> - *     Header for the session array. Contains the total page count of the
> - *     preserved memory block and the number of `struct luo_session_ser`
> - *     entries that follow.
> + *     Header for the session data block. Contains the physical address of the
> + *     next session data block and the number of `struct luo_session_ser`
> + *     entries that follow this header in the current block.
>    *
>    *   - struct luo_session_ser:
>    *     Metadata for a single session, including its name and a physical pointer
> @@ -153,21 +154,23 @@ struct luo_file_set_ser {
>    *                          luo_session_header_ser
>    */
>   #define LUO_FDT_SESSION_NODE_NAME	"luo-session"
> -#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v2"
> +#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v3"
>   #define LUO_FDT_SESSION_HEADER		"luo-session-header"
>   
>   /**
>    * struct luo_session_header_ser - Header for the serialized session data block.
> + * @next:  Physical address of the next struct luo_session_header_ser.
>    * @count: The number of `struct luo_session_ser` entries that immediately
>    *         follow this header in the memory block.
>    *
> - * This structure is located at the beginning of a contiguous block of
> + * This structure is located at the beginning of a block of
>    * physical memory preserved across the kexec. It provides the necessary
>    * metadata to interpret the array of session entries that follow.
>    *
>    * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must be updated.
>    */
>   struct luo_session_header_ser {
> +	u64 next;
>   	u64 count;
>   } __packed;
>   
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 875844d7a41d..a73f42069301 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -11,6 +11,16 @@
>   #include <linux/liveupdate.h>
>   #include <linux/uaccess.h>
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
>   struct luo_ucmd {
>   	void __user *ubuffer;
>   	u32 user_size;
> @@ -59,7 +69,6 @@ struct luo_file_set {
>    * struct luo_session - Represents an active or incoming Live Update session.
>    * @name:       A unique name for this session, used for identification and
>    *              retrieval.
> - * @ser:        Pointer to the serialized data for this session.
>    * @list:       A list_head member used to link this session into a global list
>    *              of either outgoing (to be preserved) or incoming (restored from
>    *              previous kernel) sessions.
> @@ -70,7 +79,6 @@ struct luo_file_set {
>    */
>   struct luo_session {
>   	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
> -	struct luo_session_ser *ser;
>   	struct list_head list;
>   	bool retrieved;
>   	struct luo_file_set file_set;
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 92b1af791889..007ca34eba79 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -69,30 +69,39 @@
>   #include <uapi/linux/liveupdate.h>
>   #include "luo_internal.h"
>   
> -/* 16 4K pages, give space for 744 sessions */
> +/* 16 4K pages, give space for 819 sessions per block */
>   #define LUO_SESSION_PGCNT	16ul
> -#define LUO_SESSION_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
> +#define LUO_SESSION_BLOCK_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
>   		sizeof(struct luo_session_header_ser)) /		\
>   		sizeof(struct luo_session_ser))
>   
> +/**
> + * struct luo_session_block - Internal representation of a session serialization block.
> + * @list: List head for linking blocks in memory.
> + * @ser:  Pointer to the serialized header in preserved memory.
> + */
> +struct luo_session_block {
> +	struct list_head list;
> +	struct luo_session_header_ser *ser;
> +};
> +
>   /**
>    * struct luo_session_header - Header struct for managing LUO sessions.
>    * @count:      The number of sessions currently tracked in the @list.
> + * @nblocks:    The number of allocated serialization blocks.
>    * @list:       The head of the linked list of `struct luo_session` instances.
>    * @rwsem:      A read-write semaphore providing synchronized access to the
>    *              session list and other fields in this structure.
> - * @header_ser: The header data of serialization array.
> - * @ser:        The serialized session data (an array of
> - *              `struct luo_session_ser`).
> + * @blocks:     The list of serialization blocks (struct luo_session_block).
>    * @active:     Set to true when first initialized. If previous kernel did not
>    *              send session data, active stays false for incoming.
>    */
>   struct luo_session_header {
>   	long count;
> +	long nblocks;
>   	struct list_head list;
>   	struct rw_semaphore rwsem;
> -	struct luo_session_header_ser *header_ser;
> -	struct luo_session_ser *ser;
> +	struct list_head blocks;
>   	bool active;
>   };
>   
> @@ -110,10 +119,12 @@ static struct luo_session_global luo_session_global = {
>   	.incoming = {
>   		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
>   		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
> +		.blocks = LIST_HEAD_INIT(luo_session_global.incoming.blocks),
>   	},
>   	.outgoing = {
>   		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
>   		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
> +		.blocks = LIST_HEAD_INIT(luo_session_global.outgoing.blocks),
>   	},
>   };
>   
> @@ -140,6 +151,70 @@ static void luo_session_free(struct luo_session *session)
>   	kfree(session);
>   }
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
> +
> +	err = luo_session_add_block(sh, ser);
> +	if (err)
> +		goto err_unpreserve;
> +
> +	if (last)
> +		last->ser->next = virt_to_phys(ser);
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
> +			if (unpreserve)
> +				kho_unpreserve_free(block->ser);
> +			else
> +				kho_restore_free(block->ser);
> +		}
> +		list_del(&block->list);
> +		kfree(block);
> +		sh->nblocks--;
> +	}
> +}
> +
>   static int luo_session_insert(struct luo_session_header *sh,
>   			      struct luo_session *session)
>   {
> @@ -147,15 +222,6 @@ static int luo_session_insert(struct luo_session_header *sh,
>   
>   	guard(rwsem_write)(&sh->rwsem);
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
>   	/*
>   	 * For small number of sessions this loop won't hurt performance
>   	 * but if we ever start using a lot of sessions, this might
> @@ -166,6 +232,20 @@ static int luo_session_insert(struct luo_session_header *sh,
>   		if (!strncmp(it->name, session->name, sizeof(it->name)))
>   			return -EEXIST;
>   	}
> +
> +	/*
> +	 * For outgoing we should make sure there is room in serialization array
> +	 * for new session. If not, allocate a new block.
> +	 */
> +	if (sh == &luo_session_global.outgoing) {
> +		if (sh->count == sh->nblocks * LUO_SESSION_BLOCK_MAX) {

I am not sure if "LUO_SESSION_BLOCK_MAX 10000" has special meaning or not.

If not, we can use the following:

#define LUO_SESSION_BLOCK_SHIFT 13
#define LUO_SESSION_BLOCK_MAX   (1UL << LUO_SESSION_BLOCK_SHIFT) // 8192
#define LUO_SESSION_BLOCK_MASK  (LUO_SESSION_BLOCK_MAX - 1)      // 0x1FFF

if (!(sh->count & LUO_SESSION_BLOCK_MASK) && sh->count > 0) {
...
}

Zhu Yanjun

> +			int err = luo_session_create_ser_block(sh);
> +
> +			if (err)
> +				return err;
> +		}
> +	}
> +
>   	list_add_tail(&session->list, &sh->list);
>   	sh->count++;
>   
> @@ -444,9 +524,12 @@ int __init luo_session_setup_outgoing(void *fdt_out)
>   	u64 header_ser_pa;
>   	int err;
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
>   	header_ser_pa = virt_to_phys(header_ser);
>   
>   	err = fdt_begin_node(fdt_out, LUO_FDT_SESSION_NODE_NAME);
> @@ -459,19 +542,18 @@ int __init luo_session_setup_outgoing(void *fdt_out)
>   	if (err)
>   		goto err_unpreserve;
>   
> -	luo_session_global.outgoing.header_ser = header_ser;
> -	luo_session_global.outgoing.ser = (void *)(header_ser + 1);
>   	luo_session_global.outgoing.active = true;
>   
>   	return 0;
>   
>   err_unpreserve:
> -	kho_unpreserve_free(header_ser);
> +	luo_session_destroy_ser_blocks(&luo_session_global.outgoing, true);
>   	return err;
>   }
>   
>   int __init luo_session_setup_incoming(void *fdt_in)
>   {
> +	struct luo_session_header *sh = &luo_session_global.incoming;
>   	struct luo_session_header_ser *header_ser;
>   	int err, header_size, offset;
>   	u64 header_ser_pa;
> @@ -501,11 +583,14 @@ int __init luo_session_setup_incoming(void *fdt_in)
>   	}
>   
>   	header_ser_pa = get_unaligned((u64 *)ptr);
> -	header_ser = phys_to_virt(header_ser_pa);
> -
> -	luo_session_global.incoming.header_ser = header_ser;
> -	luo_session_global.incoming.ser = (void *)(header_ser + 1);
> -	luo_session_global.incoming.active = true;
> +	while (header_ser_pa) {
> +		header_ser = phys_to_virt(header_ser_pa);
> +		err = luo_session_add_block(sh, header_ser);
> +		if (err)
> +			return err;
> +		header_ser_pa = header_ser->next;
> +	}
> +	sh->active = true;
>   
>   	return 0;
>   }
> @@ -513,6 +598,7 @@ int __init luo_session_setup_incoming(void *fdt_in)
>   int luo_session_deserialize(void)
>   {
>   	struct luo_session_header *sh = &luo_session_global.incoming;
> +	struct luo_session_block *block;
>   	static bool is_deserialized;
>   	static int err;
>   
> @@ -539,40 +625,49 @@ int luo_session_deserialize(void)
>   	 * userspace to detect the failure and trigger a reboot, which will
>   	 * reliably reset devices and reclaim memory.
>   	 */
> -	for (int i = 0; i < sh->header_ser->count; i++) {
> -		struct luo_session *session;
> -
> -		session = luo_session_alloc(sh->ser[i].name);
> -		if (IS_ERR(session)) {
> -			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
> -				(int)sizeof(sh->ser[i].name),
> -				sh->ser[i].name, session);
> -			err = PTR_ERR(session);
> -			return err;
> -		}
> +	list_for_each_entry(block, &sh->blocks, list) {
> +		struct luo_session_ser *ser = (void *)(block->ser + 1);
>   
> -		err = luo_session_insert(sh, session);
> -		if (err) {
> -			pr_warn("Failed to insert session [%s] %pe\n",
> -				session->name, ERR_PTR(err));
> -			luo_session_free(session);
> +		if (block->ser->count > LUO_SESSION_BLOCK_MAX) {
> +			pr_warn("Session block contains too many entries: %llu\n",
> +				block->ser->count);
> +			err = -EINVAL;
>   			return err;
>   		}
>   
> -		scoped_guard(mutex, &session->mutex) {
> -			err = luo_file_deserialize(&session->file_set,
> -						   &sh->ser[i].file_set_ser);
> -		}
> -		if (err) {
> -			pr_warn("Failed to deserialize files for session [%s] %pe\n",
> -				session->name, ERR_PTR(err));
> -			return err;
> +		for (int i = 0; i < block->ser->count; i++) {
> +			struct luo_session *session;
> +
> +			session = luo_session_alloc(ser[i].name);
> +			if (IS_ERR(session)) {
> +				pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
> +					(int)sizeof(ser[i].name),
> +					ser[i].name, session);
> +				err = PTR_ERR(session);
> +				return err;
> +			}
> +
> +			err = luo_session_insert(sh, session);
> +			if (err) {
> +				pr_warn("Failed to insert session [%s] %pe\n",
> +					session->name, ERR_PTR(err));
> +				luo_session_free(session);
> +				return err;
> +			}
> +
> +			scoped_guard(mutex, &session->mutex) {
> +				err = luo_file_deserialize(&session->file_set,
> +							   &ser[i].file_set_ser);
> +			}
> +			if (err) {
> +				pr_warn("Failed to deserialize files for session [%s] %pe\n",
> +					session->name, ERR_PTR(err));
> +				return err;
> +			}
>   		}
>   	}
>   
> -	kho_restore_free(sh->header_ser);
> -	sh->header_ser = NULL;
> -	sh->ser = NULL;
> +	luo_session_destroy_ser_blocks(sh, false);
>   
>   	return 0;
>   }
> @@ -580,31 +675,51 @@ int luo_session_deserialize(void)
>   int luo_session_serialize(void)
>   {
>   	struct luo_session_header *sh = &luo_session_global.outgoing;
> +	struct luo_session_block *block;
>   	struct luo_session *session;
> +	struct luo_session_ser *ser;
>   	int i = 0;
>   	int err;
>   
>   	guard(rwsem_write)(&sh->rwsem);
> +
> +	if (list_empty(&sh->blocks))
> +		return 0;
> +
> +	block = list_first_entry(&sh->blocks, struct luo_session_block, list);
> +	ser = (void *)(block->ser + 1);
> +
>   	list_for_each_entry(session, &sh->list, list) {
> -		err = luo_session_freeze_one(session, &sh->ser[i]);
> +		if (i == LUO_SESSION_BLOCK_MAX) {
> +			block->ser->count = i;
> +			block = list_next_entry(block, list);
> +			ser = (void *)(block->ser + 1);
> +			i = 0;
> +		}
> +
> +		err = luo_session_freeze_one(session, &ser[i]);
>   		if (err)
>   			goto err_undo;
>   
> -		strscpy(sh->ser[i].name, session->name,
> -			sizeof(sh->ser[i].name));
> +		strscpy(ser[i].name, session->name,
> +			sizeof(ser[i].name));
>   		i++;
>   	}
> -	sh->header_ser->count = sh->count;
> +	block->ser->count = i;
>   
>   	return 0;
>   
>   err_undo:
>   	list_for_each_entry_continue_reverse(session, &sh->list, list) {
>   		i--;
> -		luo_session_unfreeze_one(session, &sh->ser[i]);
> -		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
> +		if (i < 0) {
> +			block = list_prev_entry(block, list);
> +			ser = (void *)(block->ser + 1);
> +			i = LUO_SESSION_BLOCK_MAX - 1;
> +		}
> +		luo_session_unfreeze_one(session, &ser[i]);
> +		memset(ser[i].name, 0, sizeof(ser[i].name));
>   	}
>   
>   	return err;
>   }
> -


