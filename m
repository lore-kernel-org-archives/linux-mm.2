Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24A2CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD3F8E0018; Mon, 17 Nov 2025 05:16:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38DA38E0002; Mon, 17 Nov 2025 05:16:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C7A8E0018; Mon, 17 Nov 2025 05:16:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF478E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:16:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB6F5C0C36
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:16:22 +0000 (UTC)
X-FDA: 84119694204.12.B4248A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EA16B12000B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:16:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVxQd+jd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763374581; a=rsa-sha256;
	cv=none;
	b=B9n0X3TeW8wIyfugwLICYmlH/lCOB2uiE6XxvVw5FfUPulqJ67zthXflfpSP3bPQoG+Bgm
	qmHA+b3aEb/xoUuduA/BbE0DEAMP1gXWUsIphYOpLBJTDKTCTnwq4u0k8EpMJchBTzQkqR
	lfKqbp50mwlzu/Kr4QxY3/D3DoMIMjc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dVxQd+jd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763374581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWp7zgGwLW6QgF18L6nJjicAsAEpKHmwQ08SmZaA2TE=;
	b=2gyZRiomCaWMNoKFnTY183h7CEDTjefZJlYXhhkpJIGQH0o6bNPY+ydRYTtOe3vWrqRxIj
	Ly8JztKSCqIFHfVF0i5doBJ+C6kCa7LzHuEMZrzFDKKzz/dK//Op5FTSeAcfBCWChrIwI6
	5CWW8mtK8JCqDNS0LeBZyQY288a0rug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F337A416BD;
	Mon, 17 Nov 2025 10:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA8CC19422;
	Mon, 17 Nov 2025 10:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763374579;
	bh=3pqt/emoxDXMJPc9sIUv8mSiIo4NlUAIW0OPRzW2AvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dVxQd+jd5trmwBgh/3zu4hTlLkx/9p5IL33qFYnWaBIb3WLOyiuAgzqHpcoyY8DvC
	 ZKiyBaH9cpng8Pso5NAbKGCW1AMqksvLeji0z7vLUtQynPZB7dfXmSo5pGdXpGyo+1
	 9y1zMypZS9pqu5U01wxSxH6kHOxp1xOme4U3op9CTwfVOcLKDGW9HLxzfcokqvHM1X
	 N5dXERXMh6/b5uyPBs0Z2qK1b8rH9LyONeVyW6Q8jsrspPSPTwlC3Vk/hn6kNAKrIF
	 IkGYpSBwyj2A2bCkDZfCTKCKnmMjwvr+Fr8ufs+Q1LYALnWpYdlaUoyTJeOPu56txT
	 eO8bZlmOwn+hA==
Date: Mon, 17 Nov 2025 12:15:57 +0200
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
Subject: Re: [PATCH v6 14/20] liveupdate: luo_file: add private argument to
 store runtime state
Message-ID: <aRr13Q1xk9eunilo@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-15-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-15-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: EA16B12000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 9hnat7ef1kixpbejesfatzna4hryksgf
X-Rspam-User: 
X-HE-Tag: 1763374580-910014
X-HE-Meta: U2FsdGVkX19wd+54WQLQfEGgk07Bk/CjNSHzXCB0X2og5LPVspEChMU3io71g0MCyiNq80nv0wubb0Qrz82v2n5eVg+hLYSBI3Cr5PfFjfsxvKpdITcQ6LJW3GPk3a7JMg1EDYfD3HCF2PGs//z01JpEEnWX04IhwXsMNjI6/JiiE0FxlkEPuWWTh8VmKa9YRQO776zxIrZ9V5ZhFZaeVockpcNDVTTmj0iAtU4NOSunFwcuGzmgjvE+cztkVvhF8CUrn5HP0tslPCzMjCxTDBwsx+H3gv4m1HF6S3bvLXsIdRdydulhLX/5Z6WB67l1nsOR26iGGSAegedwIocnfajjDCZlrX4EZ9qRTZ3crHaeuYMmwjCWqiEDeb4ZK2r4DPA3eVbrtbFOb/UzGX33BfQLDhjmS1Gx5qtXo2a6ANywRtVcaereCeNZ+tB7ZwoptkFAZ8U3JeQELESPgG07BifOF34Z6t8wcgsAySd8vHNEgtcMTbt2kh7V20xUthm+m58pdQ30BD7REe+NLFj8Wssc+5NtTWJdfEfjf33jJkV80R9GpRL/LSqkucu6mzAn79auOlYXvDqiuR1k779eiO62C6VCBF6w5tRiddSfpFPfemcyljYGIF6AkTI/PI0fDkYSNtrm+HIgJ6wTI2qbUoqi34462Mc23JEG8aoNeYASYlbRh8EX7CbsRr9MT2B3Y4CFfoIVfY/3POh+8u10GqXNll88YlwSfFCA9p8m79apQUQJInSDbeoRrOxZDbpzkebWloE71RrxMvNahpzkBrKtufuf7AXxem6kTNYQroEAo92FToXdcCXu3Y9sO63yJIHXc2CzQSh7ssE+fX2ZZKBtgELR95ez86+libbe/vQw8Edt/I3VcqywJVrsxO9lodA2sLLUrAxqKxNGeNVn7hduRhTEYGnWJsNjK91rXCWWWOvv9TzmvcjaNUPMq65SSyoVNsREo95BeQCuayI
 Ak8fjzqs
 EriDFlwAbHa5kKIU/5kdaCNKJhwMGAelAB71PsEgGVop5g46avd/AFPmb2gZ4hEgtfjEdDA0dkA/jYp1PjPywMJhNxmw4jefYzGWQXpZJqHUdTvadeYxd+hH462YKSyrsXQtOygiD3K0MTtrnpoGI99eofA0sZeeAko2J7WYbtKXLib8YP/BJf8P5tnc3lbJa61IAhcF9unnTySjCJzNLvDgFswxQZcAOM8LdZbjMhDaqdtCPD00ez6/YsROyKnDk1+Tp6GIGL02iaF9FMVgkb7ORHvR9hTbpTjwwcZ3DP6qyuLDNNRDRXpGs8pkkNFJlw9yKlFATfBZS9HZPGy/fJ07lyjKTZIOzSd4PQlFgs2e5IVv/T5gw31TXyafp1C9bmI1+OQ4gmuGUQq8YkwJS230L2CFfnAzYAfnttcvDLogSuW2JXdruiosiF+2ennSraUwVgBkEksanXBg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:34:00PM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <pratyush@kernel.org>
> 
> Currently file handlers only get the serialized_data field to store
> their state. This field has a pointer to the serialized state of the
> file, and it becomes a part of LUO file's serialized state.
> 
> File handlers can also need some runtime state to track information that
> shouldn't make it in the serialized data.
> 
> One such example is a vmalloc pointer. While kho_preserve_vmalloc()
> preserves the memory backing a vmalloc allocation, it does not store the
> original vmap pointer, since that has no use being passed to the next
> kernel. The pointer is needed to free the memory in case the file is
> unpreserved.
> 
> Provide a private field in struct luo_file and pass it to all the
> callbacks. The field's can be set by preserve, and must be freed by
> unpreserve.
> 
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/liveupdate.h   | 5 +++++
>  kernel/liveupdate/luo_file.c | 9 +++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 36a831ae3ead..defc69a1985d 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -29,6 +29,10 @@ struct file;
>   *                    this to the file being operated on.
>   * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
>   *                    this field.
> + * @private_data:     Private data for the file used to hold runtime state that
> + *                    is not preserved. Set by the handler's .preserve()
> + *                    callback, and must be freed in the handler's
> + *                    .unpreserve() callback.
>   *
>   * This structure bundles all parameters for the file operation callbacks.
>   * The 'data' and 'file' fields are used for both input and output.
> @@ -39,6 +43,7 @@ struct liveupdate_file_op_args {
>  	bool retrieved;
>  	struct file *file;
>  	u64 serialized_data;
> +	void *private_data;
>  };
>  
>  /**
> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index 3d3bd84cb281..df337c9c4f21 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -126,6 +126,10 @@ static LIST_HEAD(luo_file_handler_list);
>   *                 This handle is passed back to the handler's .freeze(),
>   *                 .retrieve(), and .finish() callbacks, allowing it to track
>   *                 and update its serialized state across phases.
> + * @private_data:  Pointer to the private data for the file used to hold runtime
> + *                 state that is not preserved. Set by the handler's .preserve()
> + *                 callback, and must be freed in the handler's .unpreserve()
> + *                 callback.
>   * @retrieved:     A flag indicating whether a user/kernel in the new kernel has
>   *                 successfully called retrieve() on this file. This prevents
>   *                 multiple retrieval attempts.
> @@ -152,6 +156,7 @@ struct luo_file {
>  	struct liveupdate_file_handler *fh;
>  	struct file *file;
>  	u64 serialized_data;
> +	void *private_data;
>  	bool retrieved;
>  	struct mutex mutex;
>  	struct list_head list;
> @@ -309,6 +314,7 @@ int luo_preserve_file(struct luo_session *session, u64 token, int fd)
>  		goto exit_err;
>  	} else {
>  		luo_file->serialized_data = args.serialized_data;
> +		luo_file->private_data = args.private_data;
>  		list_add_tail(&luo_file->list, &session->files_list);
>  		session->count++;
>  	}
> @@ -356,6 +362,7 @@ void luo_file_unpreserve_files(struct luo_session *session)
>  		args.session = (struct liveupdate_session *)session;
>  		args.file = luo_file->file;
>  		args.serialized_data = luo_file->serialized_data;
> +		args.private_data = luo_file->private_data;
>  		luo_file->fh->ops->unpreserve(&args);
>  		luo_flb_file_unpreserve(luo_file->fh);
>  
> @@ -384,6 +391,7 @@ static int luo_file_freeze_one(struct luo_session *session,
>  		args.session = (struct liveupdate_session *)session;
>  		args.file = luo_file->file;
>  		args.serialized_data = luo_file->serialized_data;
> +		args.private_data = luo_file->private_data;
>  
>  		err = luo_file->fh->ops->freeze(&args);
>  		if (!err)
> @@ -405,6 +413,7 @@ static void luo_file_unfreeze_one(struct luo_session *session,
>  		args.session = (struct liveupdate_session *)session;
>  		args.file = luo_file->file;
>  		args.serialized_data = luo_file->serialized_data;
> +		args.private_data = luo_file->private_data;
>  
>  		luo_file->fh->ops->unfreeze(&args);
>  	}
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

-- 
Sincerely yours,
Mike.

