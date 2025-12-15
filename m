Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FCAD5B16D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 02:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01996B0006; Sun, 14 Dec 2025 21:19:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1EE6B0007; Sun, 14 Dec 2025 21:19:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1326B0008; Sun, 14 Dec 2025 21:19:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1F3F6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 21:19:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20290160D1A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:19:47 +0000 (UTC)
X-FDA: 84220099614.08.3F48991
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf20.hostedemail.com (Postfix) with ESMTP id E7E771C0002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:19:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oNjWvDi7;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765765185; a=rsa-sha256;
	cv=none;
	b=R9Uys5kFG6MQbp3eGaxenRadwSVZT3a82bqogJyujFJ3XUQdy3LHdiLGZHaGtbckWgiQs7
	Veq5W0koJmOnaoMT49QS5EvAm5JK1lb7WUP3W720+vCS0gtJbjfv/VyuMVG0f3HkaX0kYv
	nwgbS9FqOWkB9e/1uBbbV4X5y8MdvTA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oNjWvDi7;
	spf=pass (imf20.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765765185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3p3ydA9ph0itBai7k/pnvBUoSbltRyH20iInoGu7d4=;
	b=jnY+E1y580IeTUvLjcTCjbxRbwC9aieAnjl9h2LVdp3JiFyesxff5Pu99XsX/2T/ok37jP
	ASQcxNDT60rOblUGm0LOWabIsF82p2clD+7ojJsJlPBNTK0tSdDRZC8m74ioZx92miIjsr
	CcJS9hmjcNKuNrhfcLlUHlRd9L242JE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=U3p3ydA9ph0itBai7k/pnvBUoSbltRyH20iInoGu7d4=;
	b=oNjWvDi7MIInl1+zCmcRsrpNvSOLknq7bvOGGs8J5vEZEVWaAtybWOzhRlXxCTcxB5NqKEQmp
	YqJ9IA35pPKP9dlV0ohX/OrbEdmqrt83VLjMhLk09XgvKnYt5o7RLBNIA4DRwCJS6/Ze8JJ05Fa
	RQmlm6HIp9WqRj3V/ukRhwY=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dV3cN4FXTzLlTy;
	Mon, 15 Dec 2025 10:17:40 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 82AE7140155;
	Mon, 15 Dec 2025 10:19:39 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Dec 2025 10:19:36 +0800
Content-Type: multipart/alternative;
	boundary="------------2F6610kx8vHhZjv1W20KqvAm"
Message-ID: <89b96a9f-1d03-440a-93cd-2b9876be3122@huawei.com>
Date: Mon, 15 Dec 2025 10:19:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dev.jain@arm.com>, <david@kernel.org>, <shardulsb08@gmail.com>,
	<janak@mpiricsoftware.com>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: E7E771C0002
X-Rspamd-Server: rspam04
X-Stat-Signature: ecigx9omj7xibx7irceh6xi7rbun8np8
X-HE-Tag: 1765765183-131012
X-HE-Meta: U2FsdGVkX18damljFzbDchqUj4+CJ+hmc+Xcbe4zTCpyfQS6yVuVYN1EIk376a+rHih49K6U+/3CQvYi4Uzby8U4EAx4TqqqqETLMLRKHIk0xLpemVAveQd1Lk1R8qHHCZb8htdtcUkpvd2EdMUgjkz9VOGz//X7KjmLfqJiiNqWaTBIHD5YnN9H2vHriFwNbUOPe8uAEMQ3EVDJvXg8+hkVIQ3Og+g99rGmV8QM8rjYz5sA4MwYEr9Ru03FAL5rU+P9OhvnCqdkZPsxqQXtRlDtdg48hDYP/d/VlE6aiy6fcnhLDu12cRfZUXXDtS0q9ExT6ch+L5VlVpLkewiDwMJHmCWup9eMEwKsRKP2dGl5655W4d4BEFGwNRwtSmxPU2e5Jl9EGEc33ZzOsCzHxMvI3phQJh3egMx9lg51oY0qx7lS8ZQVWuM6+ySSMYivkXo3/2KqlU9/eZHj3s+XaVPekPoTB7PEo4d/aCLDE/2zAyOrOZMHy8yLE+VxWTTMvTxGnQlbnx9k/Ty1AU3nHKX8HyspiiwRCkn0vYq0nZ1F+7yu1MaQsZqvhUPpLFlLoZE0XUgt2Ixmb6Yd2GGaOcsg4SUg/A+MrymMCrJQduFwVJj6Cx8i5a2upSBpExfM/C3fo6R1b1bb4+af7Hs7VORFKO7qeuBLyu6kibCsUi93IrUzdNJwS/yPFRNvfqFMQFi3jKvdeI4foJc1GjgCUC85VFBQDZdKrxZt9gYo3ViUh+KsUEITHeJaKy/TpCcI6exmVutmb0XtiAdxGz+se0t2CE8iAtsVj5FYmmJBHXT9oNL/WopsdC6nuZt0nq2HfGNUuBGHTz66JoyTUTU472Dku1S4TvY7lBYJfbmmLSAmc1e9UGhr92NESHUrhwWjhfsxEdceRS398firlVkswYGts1/fQHltbiNMazUws8n3R9pPIbKGUjBtwd6jSM2eGb69IC66UpTkZ8Iv7iI
 akrEFHzO
 +/qq68sb0uHnPArLG+Tu+XgSlSZmRXz1hkFub0S5nn9hdkdIo0ef1zcdykFtfkrIBNlPf1BePyHO31/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------2F6610kx8vHhZjv1W20KqvAm
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/12/4 22:26, Shardul Bankar 写道:
> xas_create_range() is typically called in a retry loop that uses
> xas_nomem() to handle -ENOMEM errors. xas_nomem() may allocate a spare
> xa_node and store it in xas->xa_alloc for use in the retry.
>
> If the lock is dropped after xas_nomem(), another thread can expand the
> xarray tree in the meantime. On the next retry, xas_create_range() can
> then succeed without consuming the spare node stored in xas->xa_alloc.
> If the function returns without freeing this spare node, it leaks.
>
> xas_create_range() calls xas_create() multiple times in a loop for
> different index ranges. A spare node that isn't needed for one range
> iteration might be needed for the next, so we cannot free it after each
> xas_create() call. We can only safely free it after xas_create_range()
> completes.
>
> Fix this by calling xas_destroy() at the end of xas_create_range() to
> free any unused spare node. This makes the API safer by default and
> prevents callers from needing to remember cleanup.
>
> This fixes a memory leak in mm/khugepaged.c and potentially other
> callers that use xas_nomem() with xas_create_range().

I encountered another memory leak issue in xas_create_range().

collapse_file() calls xas_create_range() to pre-create all slots needed.
If collapse_file() finally fails, these pre-created slots are empty nodes.
When the file is deleted, shmem_evict_inode()->shmem_truncate_range()->shmem_undo_range()
calls xas_store(&xas, NULL) for each entries to delete nodes, but leaving those pre-created
empty nodes leaked.

I can reproduce it with following steps.
1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and then mmap the file
2) memset for the first 2MB
3) madvise(MADV_COLLAPSE) for the second 2MB.
4) unlink the file

in 3), collapse_file() calls xas_create_range() to expand xarray depth, and fails to collapse
due to the whole 2M region is empty, leading to the new created empty nodes leaked.

To fix it, maybe we should add a new function xas_delete_range() to revert what xas_create_range()
does when xas_create_range() runs into rollback path?

>
> Link:https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
> Link:https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/ ("v3")
> Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
> Signed-off-by: Shardul Bankar<shardul.b@mpiricsoftware.com>
> ---
>   v4:
>   - Drop redundant `if (xa_alloc)` around xas_destroy(), as xas_destroy()
>     already checks xa_alloc internally.
>   v3:
>   - Move fix from collapse_file() to xas_create_range() as suggested by Matthew Wilcox
>   - Fix in library function makes API safer by default, preventing callers from needing
>     to remember cleanup
>   - Use shared cleanup label that both restore: and success: paths jump to
>   - Clean up unused spare node on both success and error exit paths
>   v2:
>   - Call xas_destroy() on both success and failure
>   - Explained retry semantics and xa_alloc / concurrency risk
>   - Dropped cleanup_empty_nodes from previous proposal
>
>   lib/xarray.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/lib/xarray.c b/lib/xarray.c
> index 9a8b4916540c..f49ccfa5f57d 100644
> --- a/lib/xarray.c
> +++ b/lib/xarray.c
> @@ -744,11 +744,16 @@ void xas_create_range(struct xa_state *xas)
>   	xas->xa_shift = shift;
>   	xas->xa_sibs = sibs;
>   	xas->xa_index = index;
> -	return;
> +	goto cleanup;
> +
>   success:
>   	xas->xa_index = index;
>   	if (xas->xa_node)
>   		xas_set_offset(xas);
> +
> +cleanup:
> +	/* Free any unused spare node from xas_nomem() */
> +	xas_destroy(xas);
>   }
>   EXPORT_SYMBOL_GPL(xas_create_range);
>   
--------------2F6610kx8vHhZjv1W20KqvAm
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/12/4 22:26, Shardul Bankar 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20251204142625.1763372-1-shardul.b@mpiricsoftware.com">
      <pre wrap="" class="moz-quote-pre">xas_create_range() is typically called in a retry loop that uses
xas_nomem() to handle -ENOMEM errors. xas_nomem() may allocate a spare
xa_node and store it in xas-&gt;xa_alloc for use in the retry.

If the lock is dropped after xas_nomem(), another thread can expand the
xarray tree in the meantime. On the next retry, xas_create_range() can
then succeed without consuming the spare node stored in xas-&gt;xa_alloc.
If the function returns without freeing this spare node, it leaks.

xas_create_range() calls xas_create() multiple times in a loop for
different index ranges. A spare node that isn't needed for one range
iteration might be needed for the next, so we cannot free it after each
xas_create() call. We can only safely free it after xas_create_range()
completes.

Fix this by calling xas_destroy() at the end of xas_create_range() to
free any unused spare node. This makes the API safer by default and
prevents callers from needing to remember cleanup.

This fixes a memory leak in mm/khugepaged.c and potentially other
callers that use xas_nomem() with xas_create_range().</pre>
    </blockquote>
    <pre>I encountered another memory leak issue in xas_create_range().

collapse_file() calls xas_create_range() to pre-create all slots needed.
If collapse_file() finally fails, these pre-created slots are empty nodes.
When the file is deleted, shmem_evict_inode()-&gt;shmem_truncate_range()-&gt;shmem_undo_range()
calls xas_store(&amp;xas, NULL) for each entries to delete nodes, but leaving those pre-created
empty nodes leaked.

I can reproduce it with following steps.
1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and then mmap the file
2) memset for the first 2MB
3) madvise(MADV_COLLAPSE) for the second 2MB.
4) unlink the file

in 3), collapse_file() calls xas_create_range() to expand xarray depth, and fails to collapse
due to the whole 2M region is empty, leading to the new created empty nodes leaked.

To fix it, maybe we should add a new function xas_delete_range() to revert what xas_create_range()
does when xas_create_range() runs into rollback path?</pre>
    <blockquote type="cite"
      cite="mid:20251204142625.1763372-1-shardul.b@mpiricsoftware.com">
      <pre wrap="" class="moz-quote-pre">

Link: <a class="moz-txt-link-freetext" href="https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c">https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c</a>
Link: <a class="moz-txt-link-freetext" href="https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/">https://lore.kernel.org/all/20251201074540.3576327-1-shardul.b@mpiricsoftware.com/</a> ("v3")
Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
Signed-off-by: Shardul Bankar <a class="moz-txt-link-rfc2396E" href="mailto:shardul.b@mpiricsoftware.com">&lt;shardul.b@mpiricsoftware.com&gt;</a>
---
 v4:
 - Drop redundant `if (xa_alloc)` around xas_destroy(), as xas_destroy()
   already checks xa_alloc internally.
 v3:
 - Move fix from collapse_file() to xas_create_range() as suggested by Matthew Wilcox
 - Fix in library function makes API safer by default, preventing callers from needing
   to remember cleanup
 - Use shared cleanup label that both restore: and success: paths jump to
 - Clean up unused spare node on both success and error exit paths
 v2:
 - Call xas_destroy() on both success and failure
 - Explained retry semantics and xa_alloc / concurrency risk
 - Dropped cleanup_empty_nodes from previous proposal

 lib/xarray.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540c..f49ccfa5f57d 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -744,11 +744,16 @@ void xas_create_range(struct xa_state *xas)
 	xas-&gt;xa_shift = shift;
 	xas-&gt;xa_sibs = sibs;
 	xas-&gt;xa_index = index;
-	return;
+	goto cleanup;
+
 success:
 	xas-&gt;xa_index = index;
 	if (xas-&gt;xa_node)
 		xas_set_offset(xas);
+
+cleanup:
+	/* Free any unused spare node from xas_nomem() */
+	xas_destroy(xas);
 }
 EXPORT_SYMBOL_GPL(xas_create_range);
 
</pre>
    </blockquote>
  </body>
</html>

--------------2F6610kx8vHhZjv1W20KqvAm--

