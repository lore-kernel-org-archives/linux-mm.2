Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 156B8D25B47
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587196B0088; Wed, 28 Jan 2026 06:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5345F6B0089; Wed, 28 Jan 2026 06:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436836B008A; Wed, 28 Jan 2026 06:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 308A16B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:37:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFA1659BEB
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:37:16 +0000 (UTC)
X-FDA: 84381171672.23.64F6B67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0882540008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:37:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMlOBtzn;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769600235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlKQChddLdxZPeqYj8vUb1zR2eafXVPlDxieXVjqwOI=;
	b=j1XkYOweOh5/mZQbJI06g11YaBeMlpaykPxeviaGKXZ/pKlZGI43+dPsWfXfWKzvzhc7sB
	QdNpM0Nj7GRqn17lFGlPFmbAfU1owaZ0rzogTtbD9rLwliETPisc35uykQUYlTW/GeJaaH
	wsYyI8ntstV/lRBdquaaypgF6ez3bj8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMlOBtzn;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769600235; a=rsa-sha256;
	cv=none;
	b=0ywmIxClIqmYyawb9wvnoERKGNfT0vGv3GKYqKDdJNzW3sIbnd1KNdqKlGrSw38i+ATSPo
	mr5RT08uy6giucmIvh4qIhGz+/93rS/M3jo0soshN8PlNZYHKIg+UAtiXNwYs80rICzdn9
	GbrRZRecZXFIiI2zkMMpQfTgzbiDcwo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1164343494;
	Wed, 28 Jan 2026 11:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A26EC4CEF1;
	Wed, 28 Jan 2026 11:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769600233;
	bh=zRZNkTKFTz5IxCRo3AGoh26bLjhm9IdzCS9p+cUNL/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gMlOBtzneEAXPPCTjIDdg/6Y5GogWFlAZ0n6d05y6FtDGapTASUKqdEt4KQhwy7DG
	 weWadp9FyWirxVb9vCJ0Oq+p8eobDPxMSToSvYOiySp9bTziNUMj8WfWXE+u9QRI8c
	 vgVdWqOMYsPZ/fcD7eZOd54/9P+23i2GFvYqQJIvqBFPjiY9wC+xjjlS29pJVAsj/D
	 ItmXB/K6VMjyUEGZd4VuQKY4BTtj/J8/VtZ0sQOn9wiZwPKUjvvy0+2nfE32ew6oKp
	 yD1+Ue6jjs4oCOy5dQ64SSVELJIESavfu+YQq9VMxINdFIUlGAyZUHfL+CtRGQHdXX
	 sSVqxlzetaXLg==
Date: Wed, 28 Jan 2026 13:37:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] liveupdate: luo_file: remember retrieve() status
Message-ID: <aXn05ADvj0X7N5bK@kernel.org>
References: <20260126230302.2936817-1-pratyush@kernel.org>
 <20260126230302.2936817-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126230302.2936817-3-pratyush@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: r3gsm9izh6mxhha6dqh8pyqpbk8raqwi
X-Rspam-User: 
X-Rspamd-Queue-Id: 0882540008
X-HE-Tag: 1769600234-898816
X-HE-Meta: U2FsdGVkX1/0SHtBfuKXrODnfJl5H3ueOiYsO3LIQlXgyHNnHpyrYMqoNpcrw9UEBnkbXpWGBuLPYtEoLKKpoGjevCMgu6ae94d6xcnc6i86GkDauFTroxqBqp6BTtHoq7wwB/tmDRjrUEii/1bp1baLCP7KozmlHi8r9nbYPnQR0zH9nSJkWaxxmMbCzMqGMivMfxwp/zP0BwzzJkPmPAuT5mxy+XcIkzXYY0pn84w7drUWqK5FmxljVFs0MCrnjCC9vsTaW7mqvO/qFkd4j6izUMUY//tIDpgj9XseK6T1bP0WhAuOjNnbfUV3H5OI0D1/Tt/kv2rlvJWEOBorHAarRHceZRksG85RpNZ+64NYz4rHCLMagdahOL9yXbtW2yzinlg+p1VXhetrimMI9kZ2UIiebqnd+QMAuI4BLP79w6LkEHUiB0aCfYTlLp3GF2ymfqrvtR59lLluZESOX1lyhSkZHCaT6+fn78A7sCg1HBwAsok7QeU0Pg5A9i9pD3YiLt8wV+8Ny8ZuNExxseOCuZz/+vRKWhp9bOjiADmJnusFcypfYCIkqc4hX53eOYkJ5yfmmOVoKj4OQYt+gnqGbqHrTDFS/6c9/H6W6fYkK8Fz92wkx8NmALiUrZ+s3VjNmv4DkkEpZoEshqhKQgE5n7gn8wjtYV14+2ymNS/cbIM2z+IsXxyZdsEl7pAL4nuNHKXvCahq9MLKIuyK6bojo2xaH99GKfN2ZyP7MIyxKrpenZNTNqjMgJJ2mxOV1h+EDbjyfxq77//JFFS381w2mYhAP4Dzt7ieAWxdr5GSTbb4wH41KqXFzRZ+KuLSmmuMKe6g1K5QE9UMxOTB0Rdx2CJMdpTsE2gQbvVZFAdt6OTDbjXYXJDnKyPXN/rtNmki02m93a9Z/18T3WMlQh8vF+lg5DEQZ9isThXY7rSMxyW7zqIZGZAJvm9N9NCgTzCKulJQ5WwnbXebBhX
 kBnB4kio
 FQBxWTZsSU5LJPs+yxCs9A3kbh6nL0lC+YcZ1eyv/8cmNybdiXyltB/77KfHIzTMbdw563YAHrjlWE5cYlmBoXWPUW8y/pSYv0to8v1gqfwjhq2FzSJHWHn1goPgrIORTvaJy1KuBNfap5uq7ZkSItdX1N0EN/DCKlRpJbs0vruEcqPC9b6jdXZzqpW2UGb1dD+kRm2vZB4CqSSiNprLJRrMF10yMKI2bAakgVUKX3/50J5gULGDzKLDIlq+zGhkiVqYfbv0gxev8YsqltzTZGrENsvJOOIJTn22YnaeyZvDY+JOoOIfMzdNHWY5xzAEB7rg/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

On Tue, Jan 27, 2026 at 12:02:53AM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> LUO keeps track of successful retrieve attempts on a LUO file. It does
> so to avoid multiple retrievals of the same file. Doing so will cause

						  ^ Multiple  retrievals

> problems because once the file is retrieved, the serialized data
> structures are likely freed and the file is likely in a very different
> state from what the code expects.
> 
> This is kept track of by the retrieved boolean in struct luo_file, and

The 'retrieve' boolean in struct luo_file keeps track of this,

> is passed to the finish callback so it knows what work was already done
> and what it has left to do.
> 
> All this works well when retrieve succeeds. When it fails,
> luo_retrieve_file() returns the error immediately, without ever storing
> anywhere that a retrieve was attempted or what its error code was. This
> results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
> but nothing prevents it from trying this again.
> 
> The retry is problematic for much of the same reasons listed above. The
> file is likely in a very different state than what the retrieve logic
> normally expects, and it might even have freed some serialization data
> structures. Attempting to access them or free them again is going to
> break things.
> 
> For example, if memfd managed to restore 8 of its 10 folios, but fails
> on the 9th, a subsequent retrieve attempt will try to call
> kho_restore_folio() on the first folio again, and that will fail with a
> warning since it is an invalid operation.
> 
> Apart from the retry, finish() also breaks. Since on failure the
> retrieved bool in luo_file is never touched, the finish() call on
> session close will tell the file handler that retrieve was never
> attempted, and it will try to access or free the data structures that
> might not exist, much in the same way as the retry attempt.
> 
> There is no sane way of attempting the retrieve again. Remember the
> error retrieve returned and directly return it on a retry. Also pass
> this status code to finish() so it can make the right decision on the
> work it needs to do.
> 
> This is done by changing the bool to an integer. A value of 0 means
> retrieve was never attempted, a positive value means it succeeded, and a
> negative value means it failed and the error code is the value.
> 
> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/liveupdate.h   |  7 ++++--
>  kernel/liveupdate/luo_file.c | 41 ++++++++++++++++++++++--------------
>  mm/memfd_luo.c               |  7 +++++-
>  3 files changed, 36 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index a7f6ee5b6771..a543a3a8e837 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -21,7 +21,10 @@ struct file;
>   * struct liveupdate_file_op_args - Arguments for file operation callbacks.
>   * @handler:          The file handler being called.
>   * @retrieved:        The retrieve status for the 'can_finish / finish'
> - *                    operation.
> + *                    operation. A value of 0 means the retrieve has not been
> + *                    attempted, a positive value means the retrieve was
> + *                    successful, and a negative value means the retrieve failed,
> + *                    and the value is the error code of the call.
>   * @file:             The file object. For retrieve: [OUT] The callback sets
>   *                    this to the new file. For other ops: [IN] The caller sets
>   *                    this to the file being operated on.
> @@ -37,7 +40,7 @@ struct file;
>   */
>  struct liveupdate_file_op_args {
>  	struct liveupdate_file_handler *handler;
> -	bool retrieved;
> +	bool retrieve_sts;

int retrieve_sts?

and maybe spell out _status rather than _sts?

>  	struct file *file;
>  	u64 serialized_data;
>  	void *private_data;
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 9f7283379ebc..82577b4cca2b 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -133,9 +133,12 @@ static LIST_HEAD(luo_file_handler_list);
>   *                 state that is not preserved. Set by the handler's .preserve()
>   *                 callback, and must be freed in the handler's .unpreserve()
>   *                 callback.
> - * @retrieved:     A flag indicating whether a user/kernel in the new kernel has
> + * @retrieve_sts:  Status code indicating whether a user/kernel in the new kernel has
>   *                 successfully called retrieve() on this file. This prevents
> - *                 multiple retrieval attempts.
> + *                 multiple retrieval attempts. A value of 0 means a retrieve()
> + *                 has not been attempted, a positive value means the retrieve()
> + *                 was successful, and a negative value means the retrieve()
> + *                 failed, and the value is the error code of the call.
>   * @mutex:         A mutex that protects the fields of this specific instance
>   *                 (e.g., @retrieved, @file), ensuring that operations like
>   *                 retrieving or finishing a file are atomic.
> @@ -160,7 +163,7 @@ struct luo_file {
>  	struct file *file;
>  	u64 serialized_data;
>  	void *private_data;
> -	bool retrieved;
> +	int retrieve_sts;
>  	struct mutex mutex;
>  	struct list_head list;
>  	u64 token;
> @@ -293,7 +296,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	luo_file->file = file;
>  	luo_file->fh = fh;
>  	luo_file->token = token;
> -	luo_file->retrieved = false;
> +	luo_file->retrieve_sts = 0;

We kzalloc() luo_file, so this is not strictly required.

>  	mutex_init(&luo_file->mutex);
>  
>  	args.handler = fh;
> @@ -569,7 +572,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>  		return -ENOENT;
>  
>  	guard(mutex)(&luo_file->mutex);
> -	if (luo_file->retrieved) {
> +	if (luo_file->retrieve_sts > 0) {
>  		/*
>  		 * Someone is asking for this file again, so get a reference
>  		 * for them.
> @@ -577,21 +580,27 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>  		get_file(luo_file->file);
>  		*filep = luo_file->file;
>  		return 0;
> +	} else if (luo_file->retrieve_sts < 0) {
> +		/* Retrieve was attempted and it failed. Return the error code. */
> +		return luo_file->retrieve_sts;
>  	}

I'd put it before the check for > 0, i.e

	if (luo_file->retrieve_sts < 0)
		return luo_file->retrieve_sts;

	if (luo_file->retrieve_sts > 0) 
		...

  
>  	args.handler = luo_file->fh;
>  	args.serialized_data = luo_file->serialized_data;
>  	err = luo_file->fh->ops->retrieve(&args);
> -	if (!err) {
> -		luo_file->file = args.file;
> -
> -		/* Get reference so we can keep this file in LUO until finish */
> -		get_file(luo_file->file);
> -		*filep = luo_file->file;
> -		luo_file->retrieved = true;
> +	if (err) {
> +		/* Keep the error code for later use. */
> +		luo_file->retrieve_sts = err;
> +		return err;
>  	}
>  
> -	return err;
> +	luo_file->file = args.file;
> +	/* Get reference so we can keep this file in LUO until finish */
> +	get_file(luo_file->file);
> +	*filep = luo_file->file;
> +	luo_file->retrieve_sts = 1;
> +
> +	return 0;
>  }
>  
>  static int luo_file_can_finish_one(struct luo_file_set *file_set,
> @@ -607,7 +616,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
>  		args.handler = luo_file->fh;
>  		args.file = luo_file->file;
>  		args.serialized_data = luo_file->serialized_data;
> -		args.retrieved = luo_file->retrieved;
> +		args.retrieve_sts = luo_file->retrieve_sts;
>  		can_finish = luo_file->fh->ops->can_finish(&args);
>  	}
>  
> @@ -624,7 +633,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
>  	args.handler = luo_file->fh;
>  	args.file = luo_file->file;
>  	args.serialized_data = luo_file->serialized_data;
> -	args.retrieved = luo_file->retrieved;
> +	args.retrieve_sts = luo_file->retrieve_sts;
>  
>  	luo_file->fh->ops->finish(&args);
>  }
> @@ -779,7 +788,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
>  		luo_file->file = NULL;
>  		luo_file->serialized_data = file_ser[i].data;
>  		luo_file->token = file_ser[i].token;
> -		luo_file->retrieved = false;
> +		luo_file->retrieve_sts = 0;

Here as well, we kzalloc() luo_file, so zeroing out of the fields is not
strictly required.

>  		mutex_init(&luo_file->mutex);
>  		list_add_tail(&luo_file->list, &file_set->files_list);
>  	}
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index a34fccc23b6a..ffc9f879833b 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -326,7 +326,12 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>  	struct memfd_luo_folio_ser *folios_ser;
>  	struct memfd_luo_ser *ser;
>  
> -	if (args->retrieved)
> +	/*
> +	 * If retrieve was successful, nothing to do. If it failed, retrieve()
> +	 * already cleaned up everything it could. So nothing to do there
> +	 * either. Only need to clean up when retrieve was not called.
> +	 */
> +	if (args->retrieve_sts)
>  		return;
>  
>  	ser = phys_to_virt(args->serialized_data);
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

