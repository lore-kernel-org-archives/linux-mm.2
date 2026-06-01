Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CDDCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108746B03B2; Mon,  1 Jun 2026 10:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA656B03B3; Mon,  1 Jun 2026 10:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEAD76B03B4; Mon,  1 Jun 2026 10:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA0FB6B03B2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:04:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BA3CA06F0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:04:03 +0000 (UTC)
X-FDA: 84831512766.18.C2880EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A4EBAC0016
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:04:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7v5ZKnV;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780322641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93c3I3ubLRTv9EP1rAjvzUBB3rvXuHxApHqCDxTcN3c=;
	b=T/ML6qEj0HsOU/qub+Er/sa4cXQLX8von7aw2tu+TCZRGmM+93cmp/YoeVgUpRYqN5yPMV
	4cbO2WyJjZTWDuP9cx7PsKkDJAQwjmNLgLr+PF+daZXz3LO4HZB0nv48TkKNApRF7COFZU
	aVXvfDgKb+wheKoaCUBS8HTQgAyF7nE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7v5ZKnV;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780322641; a=rsa-sha256;
	cv=none;
	b=N5+8D1dLTw40RmBIM50da2BOjWyZn6pRvUTTl4U1Z1QhduMWowLHO64kH6174y94bKhH28
	uYkjMkI5bT4TgnzocO8rJ8c9nhQrqEbIuBKNz7mgwNKp0n3XMiVGqdfsk2aOebmiI8xCJl
	/JRzmo9EE3MvxiWuci4Q3qIJNQxFQOo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8253F436E8;
	Mon,  1 Jun 2026 14:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93471F00893;
	Mon,  1 Jun 2026 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780322640;
	bh=93c3I3ubLRTv9EP1rAjvzUBB3rvXuHxApHqCDxTcN3c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=I7v5ZKnV/Qbs3YwWgfExlqOMIyS8FMffwjzB1hpdLnTlaMxN/pAY6yQGT1Qeg3Swj
	 l1JqSAzZi2cEjyAfvIubam+9HECaY7nhbTtT7aUa9gN5Fz2Bb8RhWpJGgt3iRrJ+KF
	 zhFWGxW7/4VmYSiUrMoM6Aka9E1Wra1rL79BXxSAV7Cvy9m837RfLymf7HpdOngHKg
	 Ot6iMsSm5j+qSMLfo1vsB2ff6CGjQY7Eei5vYWNrCv2QDvVKxLicp0AqToTDXwbeco
	 0loSOjiW7KETp8OetSdLGG2P7a9c5iTY3cv/9OwXlqPyin8cp3S2XAXWvZkZMtuWmV
	 IYAtVtIohPqEg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v4 09/13] liveupdate: Remove limit on the number of
 sessions
In-Reply-To: <20260530221938.115978-10-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 30 May 2026 22:19:34 +0000")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-10-pasha.tatashin@soleen.com>
Date: Mon, 01 Jun 2026 16:03:56 +0200
Message-ID: <2vxzfr36fjcj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qxmfctrwjegebft7wrehm4o43tmqtdnp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4EBAC0016
X-HE-Tag: 1780322641-312493
X-HE-Meta: U2FsdGVkX1/LndtHaAhdEFwJT4wt8GfmF5XZHB3WAiUVZH/AvSA4WaWqQ79HrcfUTyx8nJt6LrGcEP4MqE/km8KonZ1oXD7s2Nzdv4bapiYTZTaRQfigLp9ZK0W3+yVumTGIbvF0AgyzZT209BOQJQCOe1XayFK/W3mcED5IOxWQsOD/oF074QgS9Sa7lXD65zdE/Q3/s0QMYxlescORrAq9kKdiicLXmWICTaaqLQxbXPjMfco/A51BS3Ew4Bb9D+9aVHH4lm0Gw58tMZO/O921EJVZ+pzcSTMgH0a36mH/4Gwo6G8bX7pRjKnKwkGnnokNadqtxW267zkJKiZxSBjXIcAY/A4gzg096N2MGaNGkjLNs2yXPZzAQqMhqhANWXNR86qJc/gLK5jSJaJUPOtgN36s5MzltsPIyM56ICWDK1bWwERSAE5mzz8GcQ0tc0hSClGyPixnhM/aY9R2l9G6jrxaYJwoBLyPXw5NGAogq+aDAhlxoCqsKNwVLnwZSZjNzMP5E7b0PJyNaD7xQaGvfhVxm7gxrqTafL0kVu0LHQgDMgCZj+AoWU/aLYqKzFuRPf7A+rKBW7xxPzOIa8+YZOAN6auv939+prS23W4lcWUR5V2HVGvwzXO2TDNl1y6waplqanNqcukVtQW/x4sMQTuL/7Tt1awNqKma8PxAt2AlEZggwLnPo4yfHaUk8DBOv3MDpdCSRC7LbYayFGip6vk63vgQ9EP59jt+hiIgJbjeI4tTwtIzOpRIxyx7X76U0qEiW4pvipfOCC3WYG+crLGIZbByzA8Lbuo8qaAZrJz665H6dD94gSMTSsgCqHPaJka0Z8MR6cSH6mKW4fCEoN43ddP5LmgdR3y1ZUj3G0+WQknmPUCtFoW4MRLNaZhaa+F8yLWJgDz+oMugfUG5zcau8qbe1dHR/P5fr/vVM2mt4X0DWLphvzQAWkq6VY210uiGwPjuL+n2eD5
 f2lExVuY
 yzGkoscmGxpdhVNkPHUCwMQpOSpMHTjxmehLobt6lNM/CdSuFMWrv8dpT5Dz1/SzDGpAW3bf29+WekHQstiabYeSE3iT9htV8prwonJnhSWamJCIjEs5uIn4ShfmJsK21wd3DxirrHyZDYIKzh4IBiY8Q3TYXtEMNxRpXFRv47/X7aSIrLrFgcRohxyFo8HBTCzdwRjqcZaYcLlHPVJkqIk3lryQsrvqXUuYhc3Xmqm8hocN4brmvzxu21bAOURqG5Ke6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30 2026, Pasha Tatashin wrote:

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
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
[...]
> @@ -63,13 +58,15 @@
>  #define _LINUX_KHO_ABI_LUO_H
>  
>  #include <linux/align.h>
> +#include <linux/kho/abi/block.h>
>  #include <uapi/linux/liveupdate.h>
>  
>  /*
>   * The LUO state is registered under this KHO entry name.
>   */
>  #define LUO_KHO_ENTRY_NAME	"LUO"
> -#define LUO_ABI_COMPATIBLE	"luo-v3"
> +#define LUO_COMPAT_BASE		"luo-v3"
> +#define LUO_ABI_COMPATIBLE	LUO_COMPAT_BASE "-" KHO_BLOCK_ABI_COMPATIBLE

That's clever :-)

[...]
>  int luo_session_serialize(void)
>  {
>  	struct luo_session_header *sh = &luo_session_global.outgoing;
>  	struct luo_session *session;
> -	int i = 0;
> +	struct kho_block_it it;
>  	int err;
>  
>  	down_write(&luo_session_serialize_rwsem);
>  	down_write(&sh->rwsem);
>  	*sh->sessions_pa = 0;
>  
> +	kho_block_it_init(&it, &sh->block_set);
> +
>  	list_for_each_entry(session, &sh->list, list) {
> -		err = luo_session_freeze_one(session, &sh->ser[i]);
> -		if (err)
> +		struct luo_session_ser *ser = kho_block_it_next(&it);
> +
> +		if (!ser) {
> +			err = -ENOSPC;
>  			goto err_undo;
> +		}
>  
> -		strscpy(sh->ser[i].name, session->name,
> -			sizeof(sh->ser[i].name));
> -		i++;
> -	}
> +		err = luo_session_freeze_one(session, ser);
> +		if (err) {
> +			kho_block_it_prev(&it);
> +			goto err_undo;
> +		}
>  
> -	if (sh->header_ser && sh->count > 0) {
> -		sh->header_ser->count = sh->count;
> -		*sh->sessions_pa = virt_to_phys(sh->header_ser);
> +		strscpy(ser->name, session->name, sizeof(ser->name));
>  	}
> +
> +	kho_block_it_finalize(&it);
> +
> +	if (sh->sessions_pa && sh->count > 0)

Nit: Why check for sh->sessions_pa? It can never be NULL.

Other than this, 

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

> +		*sh->sessions_pa = sh->block_set.head_pa;
>  	up_write(&sh->rwsem);
>  
>  	return 0;
>  
>  err_undo:
>  	list_for_each_entry_continue_reverse(session, &sh->list, list) {
> -		i--;
> -		luo_session_unfreeze_one(session, &sh->ser[i]);
> -		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
> +		struct luo_session_ser *ser = kho_block_it_prev(&it);
> +
> +		luo_session_unfreeze_one(session, ser);
> +		memset(ser->name, 0, sizeof(ser->name));
>  	}
>  	up_write(&sh->rwsem);
>  	up_write(&luo_session_serialize_rwsem);

-- 
Regards,
Pratyush Yadav

