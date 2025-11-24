Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4771CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 08:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119896B0022; Mon, 24 Nov 2025 03:18:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1866B0023; Mon, 24 Nov 2025 03:18:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006DD6B0026; Mon, 24 Nov 2025 03:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3B926B0022
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:18:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 224871A0251
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:18:55 +0000 (UTC)
X-FDA: 84144799830.12.623EEA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 869AE40006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:18:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q4nb9B6N;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763972333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lf2u62oVr2kxx1dN5Y5JvPTrOEUR+mutjH93KwVf9Co=;
	b=YHCPFFNFM/LglBMquv7fpLAF1PeVsgNt/KanyWJ6qcMyHJqCSrg91RXZ0RMMYnVVn43EYZ
	mzxFnixLao83zvRaaO5Iw4aZmMefshLuC7qbRrGpzO2eFVy7kxYsdgX7UhAde1C5Zb33EG
	1azsVqC5ay4ohNwR3Y2ggYxSt3sCcAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763972333; a=rsa-sha256;
	cv=none;
	b=ckXqTOayPELIX5Qkd9vd3Mp74reEJtgRlQtiSdXxZNy+33Bd0VoNJpGp+1zdcJJG+S51SL
	Xe2K4HT2PvzKIhDTjrr+lxbd4ePjSZfzXQyLgs4LToC24kcOkJEP1n1pou4k17w2kw6Z8g
	9isfZuJfTljD+ML5Acg23Bks+IJ7iw8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q4nb9B6N;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B57360183;
	Mon, 24 Nov 2025 08:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A781AC4CEF1;
	Mon, 24 Nov 2025 08:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763972332;
	bh=WYWLQ0T4dkN8ERXG3u9J8ksvyh7k5Zp6ptzavMDxTI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q4nb9B6NtVz90XW2XdKcz2w3HBHpJZR/aM1ZNR35r4yvDfhHSypM9mzA3W6YfsD/b
	 CWTbTvQXuj2Ivelvod05bz13F/xMHSMh1eB4TIvqOhmzJgVuCYUbTaBRdIMDu+WsnQ
	 Hv9hSiSlm6h42pfXMm7526csug76VGAcAJ2QBfe7LaRFocbC8f65jRuQcfxoz+Yj6F
	 cDXFj8FL/XpKzmWpGWFT8PIva62JL2DAm1+v1Af9C+1qlUdrYFe5xrV3OBFSKfdEFW
	 kYCoeLF1kbCOnDt1/j3vavEhYmdYkkkz/YxhVQ7NzlE5exG8jkVQg3JaMIns28yd2n
	 VlYneYz7SNm7w==
Date: Mon, 24 Nov 2025 10:18:28 +0200
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
Subject: Re: [PATCH v7 06/22] liveupdate: luo_file: implement file systems
 callbacks
Message-ID: <aSQU1LlPDDsN2rUw@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-7-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-7-pasha.tatashin@soleen.com>
X-Stat-Signature: awc881mh39c4rbym6xbb6qgxyd9ykq8x
X-Rspam-User: 
X-Rspamd-Queue-Id: 869AE40006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763972333-488908
X-HE-Meta: U2FsdGVkX18KW7ELswNS45pSEF3tPJ8LklD0rI1jZ/iwoJbQIsl7CyN7/Gw7NAEfEq8Wb2aMKOHtuAjOKJBzQjD1MDxnrcpe4FEX5Otp42OnMLdjqqV72mv7X/BtIV2lMu712P4dTYH2XYqnN/dsFpRUNvmr5T/r0s7hlpcVxoWNWg0sQW7kxlBT+wm5i9R7qdQ2Y33zISrQnoirakVucI5lUHVvaLvp25doDSgYRGkvUVSFrI+XR90WnVFpf0rz/973g60mvn9NJ103zAHQkzFG5Vs1nn3g7kzytfwpDhvYWU0Y1X5RvRKkbbBvxOCyc6UZMly//T5jjN7KFnHpD9UV8KKHY7n4eAO+KfDA1r7uxWyrWP7oEEnlC0tokSktefRAEE5WLSGx17dE9Av0EW+5/KwZh+hCRcxJA29pOCqbQ6iLNHuFTccg8kp5IlkqqISbl+xVuzO3K5Q9lid45WB+jIJ0aUc40/AwKHGpyJrJD27ARstBBxG5QYxl/4HFYB6dmkUxQZp8od4ADTQo0kIARPd4qzHBzhy9JYjnXpnp2jx3s9B8M+c4zckNGa48wVtnhXyjXzPwty1Y/P72R3Xp6ZAl91Wjj6FNvcakLbR3Fk9sjP4UM/kG4qaSFwmTAF7dTyYBQU+l4d4hA6674+LUcKN0lpzmKOjEbO01FOKf013dd36f8VNRDuiOG9nttrPNvlEDAJhdxX4ah278obFy+/l2SXx1lAXRyedZwdygogLnMA5xuY/p9hbAum+8WIDMFVU1tEmoAKajZBlP04Pb3JxmuwVagM2kLIm43+LVJb6MJnI+x5MlL73rI0NY08CHoMRHtdzz5z8gSzq0WIj5Gw3VpEvKCImPYF7dTz7grrd86WhkUqPWNWUye8+nTcSI3b1Jchzhxh8WzIJSSjej3JnDpUVjGUJ827IOn1YhtNrxtFgLTLUGYpGSlKc3g5p15OztiWvvBX3tDw1
 estodh/1
 imwwwCEvlR6Bsx1jEma5qHdigErRRhVhPaned/PHWImeEfBz0Vl1pVIDEsxfDzmWZuR4TtrN6BcM4r9M7+H+O3rirL9jXz9uXvuqYKCNratEHer7jMJ9sorwxYvAg3o//Unicdp9bvg3DpAGMwtu8OBIxpj8OmzIrBwFcWMArR/e/MhZWRdzylFBrrkoSN0jJHhIeRIzdT7YTsVpqv6VhU06RsoUByKJcaGM/LQmHxLfbxjmnPclzsWNObF1gWwcW1lL16AoZ7RH5Algzps8fO3qtYUrxNIW9lLGKVk1+7ninGHmE4nZ18V1f0WFCw/9un8pN/1SXtLy+cbg6siBwvy6g8nqelon85TkVbHNUBe01ncVl4SyWOaRZErfBS1YglJ7NuWZAbuI85bK2HLxDw8KMcTSITrOh05LAqSTp1rq2G7dYNmukvbdxKqNNE+60qx8n6oPY8mHpNhc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:33PM -0500, Pasha Tatashin wrote:
> This patch implements the core mechanism for managing preserved
> files throughout the live update lifecycle. It provides the logic to
> invoke the file handler callbacks (preserve, unpreserve, freeze,
> unfreeze, retrieve, and finish) at the appropriate stages.
> 
> During the reboot phase, luo_file_freeze() serializes the final
> metadata for each file (handler compatible string, token, and data
> handle) into a memory region preserved by KHO. In the new kernel,
> luo_file_deserialize() reconstructs the in-memory file list from this
> data, preparing the session for retrieval.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

With some comments below
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/kho/abi/luo.h      |  39 +-
>  include/linux/liveupdate.h       |  98 ++++
>  kernel/liveupdate/Makefile       |   1 +
>  kernel/liveupdate/luo_file.c     | 882 +++++++++++++++++++++++++++++++
>  kernel/liveupdate/luo_internal.h |  38 ++
>  5 files changed, 1057 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/liveupdate/luo_file.c
> 

...

> +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> +{
> +	struct liveupdate_file_op_args args = {0};
> +	struct liveupdate_file_handler *fh;
> +	struct luo_file *luo_file;
> +	struct file *file;
> +	int err;
> +
> +	if (luo_token_is_used(file_set, token))
> +		return -EEXIST;
> +
> +	file = fget(fd);
> +	if (!file)
> +		return -EBADF;
> +
> +	err = luo_alloc_files_mem(file_set);
> +	if (err)
> +		goto  err_files_mem;
> +
> +	if (file_set->count == LUO_FILE_MAX) {

This can be checked before getting the file and allocating memory, can't it?

> +		err = -ENOSPC;
> +		goto err_files_mem;

The goto label should say what it does, not what the error was.

> +	}
> +
> +	err = -ENOENT;
> +	luo_list_for_each_private(fh, &luo_file_handler_list, list) {
> +		if (fh->ops->can_preserve(fh, file)) {
> +			err = 0;
> +			break;
> +		}
> +	}
> +
> +	/* err is still -ENOENT if no handler was found */
> +	if (err)
> +		goto err_files_mem;
> +
> +	luo_file = kzalloc(sizeof(*luo_file), GFP_KERNEL);
> +	if (!luo_file) {
> +		err = -ENOMEM;
> +		goto err_files_mem;
> +	}
> +
> +	luo_file->file = file;
> +	luo_file->fh = fh;
> +	luo_file->token = token;
> +	luo_file->retrieved = false;
> +	mutex_init(&luo_file->mutex);
> +
> +	args.handler = fh;
> +	args.file = file;
> +	err = fh->ops->preserve(&args);
> +	if (err)
> +		goto err_kfree;
> +
> +	luo_file->serialized_data = args.serialized_data;
> +	list_add_tail(&luo_file->list, &file_set->files_list);
> +	file_set->count++;
> +
> +	return 0;
> +
> +err_kfree:
> +	mutex_destroy(&luo_file->mutex);

Don't think we need this, luo_file is freed in the next line.

> +	kfree(luo_file);
> +err_files_mem:
> +	fput(file);
> +	luo_free_files_mem(file_set);

I'd have the error path as

err_free_luo_file:
	kfree(luo_file);
err_free_files_mem:
	luo_free_files_mem(file_set);
err_put_file:
	fput(file);

> +
> +	return err;
> +}

...

> +void luo_file_unpreserve_files(struct luo_file_set *file_set)
> +{
> +	struct luo_file *luo_file;
> +
> +	while (!list_empty(&file_set->files_list)) {

list_for_each_entry_safe_reverse()?

> +		struct liveupdate_file_op_args args = {0};
> +
> +		luo_file = list_last_entry(&file_set->files_list,
> +					   struct luo_file, list);
> +
> +		args.handler = luo_file->fh;
> +		args.file = luo_file->file;
> +		args.serialized_data = luo_file->serialized_data;
> +		luo_file->fh->ops->unpreserve(&args);
> +
> +		list_del(&luo_file->list);
> +		file_set->count--;
> +
> +		fput(luo_file->file);
> +		mutex_destroy(&luo_file->mutex);
> +		kfree(luo_file);
> +	}
> +
> +	luo_free_files_mem(file_set);
> +}

...

> +int luo_file_finish(struct luo_file_set *file_set)
> +{
> +	struct list_head *files_list = &file_set->files_list;
> +	struct luo_file *luo_file;
> +	int err;
> +
> +	if (!file_set->count)
> +		return 0;
> +
> +	list_for_each_entry(luo_file, files_list, list) {
> +		err = luo_file_can_finish_one(file_set, luo_file);
> +		if (err)
> +			return err;
> +	}
> +
> +	while (!list_empty(&file_set->files_list)) {

list_for_each_entry_safe_reverse()?

> +		luo_file = list_last_entry(&file_set->files_list,
> +					   struct luo_file, list);
> +
> +		luo_file_finish_one(file_set, luo_file);
> +
> +		if (luo_file->file)
> +			fput(luo_file->file);
> +		list_del(&luo_file->list);
> +		file_set->count--;
> +		mutex_destroy(&luo_file->mutex);
> +		kfree(luo_file);
> +	}
> +

...

> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index 1292ac47eef8..c8973b543d1d 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -40,6 +40,28 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
>   */
>  #define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
>  
> +/* Mimics list_for_each_entry() but for private list head entries */
> +#define luo_list_for_each_private(pos, head, member)				\
> +	for (struct list_head *__iter = (head)->next;				\
> +	     __iter != (head) &&						\
> +	     ({ pos = container_of(__iter, typeof(*(pos)), member); 1; });	\
> +	     __iter = __iter->next)

Ideally something like this should go to include/linux/list.h, but it can
be done later to avoid bikeshedding about the name :)

And you can reuse most of list_for_each_entry, just replace the line that
accesses __private member:

#define luo_list_for_each_private(pos, head, member)			\
	for (pos = list_first_entry(head, typeof(*pos), member);	\
	     &ACCESS_PRIVATE(pos, member) != head;			\
	     pos = list_next_entry(pos, member))

-- 
Sincerely yours,
Mike.

