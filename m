Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76EAACDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EC6B6B0088; Tue, 23 Jun 2026 08:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CD96B008A; Tue, 23 Jun 2026 08:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F9D6B008C; Tue, 23 Jun 2026 08:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2FBE6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:54:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59C7E1C1ADD
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:54:21 +0000 (UTC)
X-FDA: 84911170722.27.B3DA08F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B361AC0002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:54:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=auscPAgc;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782219259;
	b=C/0e1WNMiijx39cKtjmUAit4x1XjKYHepuJ0rh0AzxOVVKPOS86yP+vOVkDeGUFZe23vmJ
	hwqpJjCTyagMzwnYTJWAF5GOYq9Bb/bBYb/rSK7JLj0YVTVDEaVJqUguYQvE+bZanySSEw
	Q7n3gtZHYYA2irg3uEu8u9Gg6Xz/sF4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782219259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXBdTWEwdhn+XOGPfidzRwDwRildye8jC/CmG5OoRC4=;
	b=d/6lsFrZYAuCJGI3AvIQoGh/cTSP2z6+Ta7Y8iBh1K3pOdTcEUH8BJtjqCv5AhP+sqztbI
	uJ+NVuJzMEZIlL960K51mDFoTCvYDYTyWDzu17wAJ7mJvaW+3ppSSqoeWuR2pwFYh706JP
	JozjbRuZqp+d7ayQfkQMS4ZEYW1Zf6E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=auscPAgc;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 011D960052;
	Tue, 23 Jun 2026 12:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439211F000E9;
	Tue, 23 Jun 2026 12:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782219258;
	bh=DXBdTWEwdhn+XOGPfidzRwDwRildye8jC/CmG5OoRC4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=auscPAgcP/a+TQKaO7yckWkiM0hPzFSYepvdf8kaGBpKfFgU6BZxcXsRxyczANj1b
	 K2O710KVT/ySlT5R2/38DIjHT5rO1FIPxdRCMHqiobjg/9SxhSFi/4oQefDaJLnL2E
	 AqdqzFl0N9QvKcC8DTSgszeKIvSTZxY8t3pPiJ1lkmYPeiFhsqzkZMDidXGeRWg4J/
	 jKSrQRkZORvk4m88ku5OcqjtpiMQHL0G2X7WVUf77XfEdbK2PzaTaoJHgpZg3LZwO5
	 12t9IeK1wXUG4z7YbLsrMgn2R4HA7tm1RlUNOhNR3qLtedXXadOYShsz9nK7DOivaN
	 CC8Qji6pgmnRA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] luo: Update serialized data to use KHOSER_PTR
In-Reply-To: <20260623105201.3724592-4-tarunsahu@google.com> (Tarun Sahu's
	message of "Tue, 23 Jun 2026 10:52:01 +0000")
References: <20260623105201.3724592-1-tarunsahu@google.com>
	<20260623105201.3724592-4-tarunsahu@google.com>
Date: Tue, 23 Jun 2026 14:54:15 +0200
Message-ID: <2vxztsqtmn7s.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: f73purtxne4y3xase36aw8sgmj1uijs7
X-Rspam-User: 
X-Rspamd-Queue-Id: B361AC0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782219259-969749
X-HE-Meta: U2FsdGVkX1+X59amme49OfcgUBs4D1Utd7FnyVGNvKrlJd+fXGu7/33rPMhj/qDBU7/9uMpXgwJxBB/bkVe6PnEci7VZvOiyOGVV5tHphx4Jz8ebqE3SrKOIZpkfdmeNkK7jGyfyACn+kuR0gQkunD87YsHocpWEEJN7qh3ejzQk5PbUfZWxLDU6TjOkbUWmhtVOGszVJgdheCSzQ83/hTrsmwbi9ir74Uc5Y2Z6qb2veOzM/swRCaM3MVj3ZFX/+v5VnYu3nrBTMXsySW5x3fTM2PKI/bgps2C2MP4lCGfyRF2cOuxbGYZXyGnFKJGueAt4U6vALdE3znCpvSdPGOQ14J3tPffvA91rddJ8p78wPUtIoVJtGD2zpGgUwveDi6FVtsAbPywNNIV9S67QE0HDlcXA068JA45QuvW4FQTbuC1O/P8Jm43tMzBx62Lo0OH6GZ0Ta9sOKH/5CNaiR/F5gkNesPFNQ55JAb6tcN1AvQW5xv/75kJ4MxTqrW/K4klD/9v+0DoqPYKFaQPbVjoeGgXogOZchclq0fYW0t9fP2QemZXDik4FK9s7yJsT9+4FI2D/my9LIv7f9+l1nvSS7Sxy+AgXOBh/AKrGqPpj9lQ+pxkkq/xP/Xxde9beTwiz3VjH83ncTeQvbb91yplNvZCxyGSJK4KQ0nQVc8SpjqX2DbAjqIfsp+gxY6yR0/nKzMUpstA5D0sMStXmB4HT8TOPJC58hRv+rOzGVEMuvyr2HEgl3QTRas7tZHPMMgJe/EwgdF0AzOn6dmlivsfIdTfhAUl2c6ne/ku4oCjgHl+D/TgnXR+CZ/gjvMij70DFKypUqIJrnMSBeSHllsfXoM+RjXbbv/+/dk6pPp+uVWufJRRkU1laCcSLsPTM7H3SuxPdw2dY77oZ7UaWu6ECd6grG7RV4P1UIJ+H1yZ1slZbTqKZXDqk4EduT7dJ02JVDZQ05lu75d51/bS
 MXrwrBF1
 N+btrgHPWIFu6KGxZSntxPnbK9FbpgPtb05bZNzQsIHnyL3xMEj0dRL7B6aIYn22z2dRdXe9IK/s46BJHFr18YZGI1BGTfpUkNpUEESER4VnohHpb1WM2x8RNGpLH1yzulgCFNtoN/eCWyDVgjX5GG27LQK8TMvWXK+LYHSlHlinjNUe35eDpE45SMCWaJreKuW+WXrUPgU1olhR4ojXgDmdh4FaZtTl90lytTKmVQx+zPyVZr1avdaIr9i/DI1fLuZStF+Rz0ugH8iIho8hbbyFm57eyoOBvH8gST7Bix/oJBwBKHqEcvFkVfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23 2026, Tarun Sahu wrote:

> Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
> This series also takes care of resolving the bug with memfd of using
> phys_to_virt before checking the args->serialized_data value.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/kho/abi/luo.h  |  5 +++--
>  include/linux/liveupdate.h   |  4 ++--
>  kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
>  mm/memfd_luo.c               | 20 +++++++++++---------
>  4 files changed, 28 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 288076de6d4a..d5b3b1c0fec1 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -59,6 +59,7 @@
>  
>  #include <linux/align.h>
>  #include <linux/kho/abi/block.h>
> +#include <linux/kho/abi/kexec_handover.h>
>  #include <uapi/linux/liveupdate.h>
>  
>  /*
> @@ -89,14 +90,14 @@ struct luo_ser {
>  /**
>   * struct luo_file_ser - Represents the serialized preserves files.
>   * @compatible:  File handler compatible string.
> - * @data:        Private data
> + * @serialized_data:  The serialized pointer union for this file

Nit: "serialized pointer union" makes very little sense once you lose
the context of this patch. The union is an implementation detail. I
think "serialized KHO pointer" makes more sense from documentation
perspective.

>   * @token:       User provided token for this file
>   *
>   * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>   */
>  struct luo_file_ser {
>  	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
> -	u64 data;
> +	DECLARE_KHOSER_PTR(serialized_data, void *);
>  	u64 token;
>  } __packed;
>  
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 88722e5caf02..480d638b7d18 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -33,7 +33,7 @@ struct file;
>   * @file:             The file object. For retrieve: [OUT] The callback sets
>   *                    this to the new file. For other ops: [IN] The caller sets
>   *                    this to the file being operated on.
> - * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
> + * @serialized_data:  The serialized pointer union, preserve/prepare/freeze may update

Nit: Same here.

>   *                    this field.
>   * @private_data:     Private data for the file used to hold runtime state that
>   *                    is not preserved. Set by the handler's .preserve()
> @@ -47,7 +47,7 @@ struct liveupdate_file_op_args {
>  	struct liveupdate_file_handler *handler;
>  	int retrieve_status;
>  	struct file *file;
> -	u64 serialized_data;
> +	DECLARE_KHOSER_PTR(serialized_data, void *);
>  	void *private_data;
>  };
>  
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index c39f96961a85..aecf19033f95 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -125,7 +125,7 @@ static DEFINE_XARRAY(luo_preserved_files);
>   * @file:          Pointer to the kernel's &struct file that is being preserved.
>   *                 This is NULL in the new kernel until the file is successfully
>   *                 retrieved.
> - * @serialized_data: The opaque u64 handle to the serialized state of the file.
> + * @serialized_data: The serialized pointer union to the serialized state of the file.
>   *                 This handle is passed back to the handler's .freeze(),
>   *                 .retrieve(), and .finish() callbacks, allowing it to track
>   *                 and update its serialized state across phases.
> @@ -161,7 +161,7 @@ static DEFINE_XARRAY(luo_preserved_files);
>  struct luo_file {
>  	struct liveupdate_file_handler *fh;
>  	struct file *file;
> -	u64 serialized_data;
> +	DECLARE_KHOSER_PTR(serialized_data, void *);
>  	void *private_data;
>  	int retrieve_status;
>  	struct mutex mutex;
> @@ -289,7 +289,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>  	if (err)
>  		goto err_kfree;
>  
> -	luo_file->serialized_data = args.serialized_data;
> +	KHOSER_COPY_PTR(luo_file->serialized_data, args.serialized_data);
>  	luo_file->private_data = args.private_data;
>  	list_add_tail(&luo_file->list, &file_set->files_list);
>  	file_set->count++;
> @@ -342,7 +342,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
>  
>  		args.handler = luo_file->fh;
>  		args.file = luo_file->file;
> -		args.serialized_data = luo_file->serialized_data;
> +		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>  		args.private_data = luo_file->private_data;
>  		luo_file->fh->ops->unpreserve(&args);
>  		luo_flb_file_unpreserve(luo_file->fh);
> @@ -375,12 +375,12 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
>  
>  		args.handler = luo_file->fh;
>  		args.file = luo_file->file;
> -		args.serialized_data = luo_file->serialized_data;
> +		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>  		args.private_data = luo_file->private_data;
>  
>  		err = luo_file->fh->ops->freeze(&args);
>  		if (!err)
> -			luo_file->serialized_data = args.serialized_data;
> +			KHOSER_COPY_PTR(luo_file->serialized_data, args.serialized_data);
>  	}
>  
>  	return err;
> @@ -396,7 +396,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
>  
>  		args.handler = luo_file->fh;
>  		args.file = luo_file->file;
> -		args.serialized_data = luo_file->serialized_data;
> +		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>  		args.private_data = luo_file->private_data;
>  
>  		luo_file->fh->ops->unfreeze(&args);
> @@ -483,7 +483,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
>  
>  		strscpy(file_ser->compatible, luo_file->fh->compatible,
>  			sizeof(file_ser->compatible));
> -		file_ser->data = luo_file->serialized_data;
> +		KHOSER_COPY_PTR(file_ser->serialized_data, luo_file->serialized_data);
>  		file_ser->token = luo_file->token;
>  	}
>  
> @@ -587,7 +587,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>  	}
>  
>  	args.handler = luo_file->fh;
> -	args.serialized_data = luo_file->serialized_data;
> +	KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>  	err = luo_file->fh->ops->retrieve(&args);
>  	if (err) {
>  		/* Keep the error code for later use. */
> @@ -621,7 +621,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
>  
>  		args.handler = luo_file->fh;
>  		args.file = luo_file->file;
> -		args.serialized_data = luo_file->serialized_data;
> +		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>  		args.retrieve_status = luo_file->retrieve_status;
>  		can_finish = luo_file->fh->ops->can_finish(&args);
>  	}
> @@ -638,7 +638,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
>  
>  	args.handler = luo_file->fh;
>  	args.file = luo_file->file;
> -	args.serialized_data = luo_file->serialized_data;
> +	KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>  	args.retrieve_status = luo_file->retrieve_status;
>  
>  	luo_file->fh->ops->finish(&args);
> @@ -748,7 +748,7 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
>  
>  	luo_file->fh = fh;
>  	luo_file->file = NULL;
> -	luo_file->serialized_data = ser->data;
> +	KHOSER_COPY_PTR(luo_file->serialized_data, ser->serialized_data);
>  	luo_file->token = ser->token;
>  	mutex_init(&luo_file->mutex);
>  	list_add_tail(&luo_file->list, &file_set->files_list);
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 10f3983b0060..852b61678229 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -257,6 +257,7 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
>  
>  static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  {
> +	DECLARE_KHOSER_PTR(sd, struct memfd_luo_ser *);
>  	struct inode *inode = file_inode(args->file);
>  	struct memfd_luo_folio_ser *folios_ser;
>  	struct memfd_luo_ser *ser;
> @@ -309,7 +310,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  	inode_unlock(inode);
>  
>  	args->private_data = folios_ser;
> -	args->serialized_data = virt_to_phys(ser);
> +	KHOSER_STORE_PTR(sd, ser);
> +	KHOSER_COPY_PTR(args->serialized_data, sd);

This is awkward. Why do you even need sd? Why not just do
KHOSER_STORE_PTR(args->serialized_data, ser)? KHOSER_COPY_PTR() doesn't
give you any type safety for args->serialized_data anyway, so why the
extra steps?

>  
>  	return 0;
>  
> @@ -325,11 +327,10 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
>  {
>  	struct memfd_luo_ser *ser;
>  
> -	if (WARN_ON_ONCE(!args->serialized_data))
> +	ser = KHOSER_LOAD_PTR(args->serialized_data);
> +	if (WARN_ON_ONCE(!ser))
>  		return -EINVAL;
>  
> -	ser = phys_to_virt(args->serialized_data);
> -
>  	/*
>  	 * The pos might have changed since prepare. Everything else stays the
>  	 * same.
> @@ -344,14 +345,13 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
>  	struct inode *inode = file_inode(args->file);
>  	struct memfd_luo_ser *ser;
>  
> -	if (WARN_ON_ONCE(!args->serialized_data))
> +	ser = KHOSER_LOAD_PTR(args->serialized_data);
> +	if (WARN_ON_ONCE(!ser))
>  		return;
>  
>  	inode_lock(inode);
>  	shmem_freeze(inode, false);
>  
> -	ser = phys_to_virt(args->serialized_data);
> -
>  	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
>  				    ser->nr_folios);
>  
> @@ -397,7 +397,8 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>  	if (args->retrieve_status)
>  		return;
>  
> -	if (!args->serialized_data)
> +	ser = KHOSER_LOAD_PTR(args->serialized_data);
> +	if (!ser)
>  		return;
>  
>  	ser = phys_to_virt(args->serialized_data);

This doesn't compile :-(

You should always _test_ the changes you make. Compiling them is the
first step. _Running_ them is the second. Both are important. Please do
so in the next version. And for every code changes, no matter how
trivial it seems. You never know if a simple looking change can trigger
bugs.

You should at least run the LUO selftests and make sure they pass.

> @@ -523,7 +524,8 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  	struct file *file;
>  	int err;
>  
> -	if (!args->serialized_data)
> +	ser = KHOSER_LOAD_PTR(args->serialized_data);
> +	if (!ser)
>  		return -EINVAL;
>  
>  	ser = phys_to_virt(args->serialized_data);

Here too, this doesn't compile.

-- 
Regards,
Pratyush Yadav

