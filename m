Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DD6CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A406B00B3; Mon, 11 May 2026 07:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB106B00B4; Mon, 11 May 2026 07:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1536B00B5; Mon, 11 May 2026 07:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3CCC6B00B3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:32:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D2F61606FF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:32:20 +0000 (UTC)
X-FDA: 84754925640.24.5D7CAE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E2CB34000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:32:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mUh8viXl;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778499138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2zffpQEMSxbFE0uJA4SQFtegz0TpogLtn+Le+lt3tk=;
	b=T036ZG69OL8dQlKAhpEXbQM2gXMB48XzN1l3KV/D3HXzZOjBGCaDDwmpL1sVICO27XmA9I
	arutPoVz9ZTbE/+oYFS9geRyywOJPX1tp8URfQaqG3rlDv054NpIbaaJVdeGtQNHZFjBUm
	rYuL9fkcxSc3TjtmsjWumkkdidX6I0Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mUh8viXl;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778499138; a=rsa-sha256;
	cv=none;
	b=MswW0Iu1RcwXBY6AzIhNCbpEkhDbyab9ktDExx41GGMX2ohaZLkU7nRn8WXcsuM1kHgXgt
	bs53lBna5V8/cgt+unKkiyyqrPYQGVgpbf3zuFuLVs1KSgDKLofWFL10bmiJRlflKwphS5
	9GUbuOB4j3h1J6jr83gFQWEOJ0GyDxk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61BCA6001A;
	Mon, 11 May 2026 11:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFE1C2BCB0;
	Mon, 11 May 2026 11:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778499138;
	bh=qNNqg0dnTiPNdw7XCSPl1o8PJe8uHezO/mLjClsBB+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mUh8viXlk8oQo393EqkU4YkTeVj3ZpVUXp0PN/Ad7bPd9Ezgc8lq3+2nL/ZRxppyj
	 aEPVqg4XfaJvMtLRm6IZp8dvIui5iGZrZGlejvS6S4Vn6r3o0IdiZH5TCM+UNfE2z/
	 8vAYGoqba9jYzfa2W2u0sHconpFBsvfBSazyCAGr+uCR3kkRvguHqk/ovbgjQ7bpxC
	 9VBtGVVzL7XT3bwGB+vg7UIdqAYT5stR/fsd4Tg9tTTSpVU7bgnLKVGXnR/rGdM1Nn
	 CqK0vF8ya8wli7tvt066pA3NbJBe+MdFm3jHEo9YcPJCFXcPTLi+LFgfszgc0j2KY3
	 xw7LdbQKbr47g==
Date: Mon, 11 May 2026 14:32:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] kho: generalize radix tree APIs
Message-ID: <agG-OuOTAg5YD-CV@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-2-pratyush@kernel.org>
X-Stat-Signature: wmfd9f67asnybymbefoojjr4c1r4a7mx
X-Rspamd-Queue-Id: E2CB34000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778499138-493270
X-HE-Meta: U2FsdGVkX19K8DBxRqPth/dIjcRgQRtM55IcJ4PKnMlYKXN0i67roxqA5dP0WAeoaOhadS5+hi118mOw2kY0UG0shcZkRLtkx8s6xnxF7xALSXpZ6HyCXdraC5jLvP4V5iKCCsz2dF2tMS5DPr7qur59K9xy7nZekSrWgwouMknShUhK51uz84v0n9CnnyQwONyG3VmsU3RT9xOVIkveJEIcZhqomk+0wkmsWyL5W1mk+yf4f854Q3JyG1Av99+S84NVDkhL+Fm3EqeLWcym+oWJJ1cL7yLBEN/Ngc9sESoIuTquZpJzVG/AhNzS+9g/tVR0F95cFT31ofh/nxl7t7UIK7qxzgc1zEliTD6m6zk4BBabA1j67ts0kHx6tLZ9kAfR6+8end6v1a68hweX8Uc/W1bMn9+P4pTnd4aMtrIMMprVLIS8t38RBZ8lre7pl6oEE4z2dQJjSNAWxJUpSe38Qc12xEgGjzNmTNQIqQERqsYjTeIlvKLqUrc2CkZAgfpjYLerGhv5i+bKVbwIxLike+WSR47HWxetLenqNd61/+f54HnsSY9J5kNajZ5MTuHxasKR1Yh2+CAlHti6AClPNRb+BedgLA9iLlOl75eheO9m86ScEl/Ujw7DYffSU3fZu52XlrSRkyteTgjnHbq4/tUFHu94uNc+2DViXh7QIm1V3Ly91j8Px9TsX17945J1OpVZBtxKX+Xojqrq0eXchP9ls4l8H2MWf3fwNrL9ojJa72/adJ9POKK9qeMQzfYmXB2dCvFXvC3NMK8Zwxp1lOU3YsiM89SEMsendnBeqJzRvvZN+vHX5kMDkl8QkYQ1I0MKvXgd+FAyYnCE/pOKGLjWJZ0MfaGFrzVtdAXsQNZNukqEWWItOPAKHTMZsdfjImLgf3AYVqwS7Wn0j42HwcWKRwVHEDNSaOle4RC1VoAu48Udz2m3kpkuIA2Bbi/wZFFQPnfh/Gb3pRo
 ALKLLpAk
 OzWtUEIjYgbesa1BsLlC79A2S1CEthZLELS6cGyXYU3c4U83+tNG4yvBc7munQ08TpixNCENlKkWs7AUvhFYasqm2zLEJURkZ6Pj6kJ1rcNDAl/tY4ON11VWCnIXUtGODgQhJOsFb/Sd9HFw0tuCkfzJ4nCgqawmuUaMjlspOAknaqudrOUVyhDYSbq7ak8sxrdFcGmzfn4xRQ8624xXNQdx6+v6k1DasfxoRrK48MqzwvOOg/pFI6/N+M5At5SOHeeXowxGpGPUgoTEo1EoM5aNIGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:03PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The KHO radix tree is a data structure that can track the presence or
> absence of an arbitrary key, with nothing inherently tied to KHO memory
> preservation tracking. This was one of the design goals of the radix
> tree. This was done to enable it to be re-used by other users of KHO.
> 
> Despite that, the radix tree APIs are very closely tied to KHO memory
> preservation tracking. Adding a key is done by kho_radix_add_page(),
> which encodes it as a page tracking operation and takes in PFN and
> order. kho_radix_del_page() does the same. These functions encode the
> key internally that goes into the radix tree. kho_radix_walk_tree() does
> the same by baking the PFN and order into the callback arguments.
> 
> Generalize the APIs by taking the key directly and doing the encoding at
> the callers. Rename the functions to kho_radix_add_key() and
> kho_radix_del_key(). In practice, this removes a line each from the
> functions and moves the encoding function call to the callers.
> Similarly, update kho_radix_tree_walk_callback_t to take the key
> directly.
> 
> To keep the naming convention clearer, rename
> kho_radix_{encode,decode}_key() to kho_{encode,decode}_radix_key().
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kho_radix_tree.h     | 18 +++----
>  kernel/liveupdate/kexec_handover.c | 76 ++++++++++++++----------------
>  2 files changed, 42 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> index 84e918b96e53..f368f3b9f923 100644
> --- a/include/linux/kho_radix_tree.h
> +++ b/include/linux/kho_radix_tree.h
> @@ -85,7 +85,7 @@ static struct kho_out kho_out = {
>  };
>  
>  /**
> - * kho_radix_encode_key - Encodes a physical address and order into a radix key.
> + * kho_encode_radix_key - Encodes a physical address and order into a radix key.

Let's keep kho_radix_ prefix for namespasing please.
This is the common practice these days.

>   * @phys: The physical address of the page.
>   * @order: The order of the page.
>   *

...

> @@ -144,24 +144,21 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
>  }
>  
>  /**
> - * kho_radix_add_page - Marks a page as preserved in the radix tree.
> + * kho_radix_add_key - Add a key to the radix tree.
>   * @tree: The KHO radix tree.
> - * @pfn: The page frame number of the page to preserve.
> - * @order: The order of the page.
> + * @key: The key to add.
>   *
> - * This function traverses the radix tree based on the key derived from @pfn
> - * and @order. It sets the corresponding bit in the leaf bitmap to mark the
> - * page for preservation. If intermediate nodes do not exist along the path,
> - * they are allocated and added to the tree.
> + * This function traverses the radix tree based on the key provided. It sets the

Nit:                                                     @key here and in
the comments below.

> + * corresponding bit in the leaf bitmap to mark the key as present. If
> + * intermediate nodes do not exist along the path, they are allocated and added
> + * to the tree.
>   *
>   * Return: 0 on success, or a negative error code on failure.
>   */

-- 
Sincerely yours,
Mike.

