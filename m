Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5752CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC74F6B0088; Tue, 23 Jun 2026 07:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B502E6B008A; Tue, 23 Jun 2026 07:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A412B6B0093; Tue, 23 Jun 2026 07:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 741E36B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:13:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 085F71C2C33
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:13:01 +0000 (UTC)
X-FDA: 84910915362.28.1547665
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3032AC0009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:12:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NaAbyyV2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3OWo6agkKCFABs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3OWo6agkKCFABs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782213179;
	b=IKIydsNoxzdyyMlBmaj26rqu+NOOlqj2CpNhalTHUnxIfFoy6bPeSE3H58kvyZoi5lIjkp
	o3Krx1TGUuPcVhM7qWklEFPasgo7a8pEv+aLNnFPZFPqRAx75KV1vL9B+9jP0WyRpBOGJ2
	cgmBbZBFB419ypuBO4QouNh9fNIGafM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782213179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlrS6JHBNQ5+edYZVjnAg+a7odL1f1I5wF5DpzXWwZg=;
	b=0ZgiRpGVQdv8PDrKnex4GK6yHoVpiAWp4By2N23/GWib+1fS2lhhdeNFQbd1CI0grybYPa
	epLkserHk+cnAa8KbENqpSjH3kTqTyu+MF1EHjFja3Z36CcFWKn6DsEO3Jx4oOpusLJ2Q5
	tIOob3iaQbLrpuoG9ts7xSthftWJTZs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NaAbyyV2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3OWo6agkKCFABs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3OWo6agkKCFABs9C5AszCy66y3w.u64305CF-442Dsu2.69y@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-695796f97aeso5721027a12.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782213178; x=1782817978; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GlrS6JHBNQ5+edYZVjnAg+a7odL1f1I5wF5DpzXWwZg=;
        b=NaAbyyV29PlS9du9zAp9Is0/45wz21HoVK2Bs073eZsfas8QsOY08B4LFtzhbhgvzk
         jeOjOBi71Xyfqu0vQ9M4Gh+aTWhAWY01bj0oBSm5K+b5kJk/rcK7xamJSsGT7Zcegr0+
         bmJSsvtl7VuPrGM1QBMu4BstNOpVt5ORdS7rBUNylUQM7/pO+p7qAuAuRaL3yznplSiG
         t0NkbCg4FnyqhxTn75A7bAIqcVUsKdT0MkbHuwLiQCN84Ac2XgoRw6PXJs+Yvt/bzkz3
         yLWii5BbaBuXEfWtoaEdNQ9cA/BAa+3qZCZvO+MAzcSxE3cLUv5PCaANqch2bqC/D7S/
         B0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782213178; x=1782817978;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GlrS6JHBNQ5+edYZVjnAg+a7odL1f1I5wF5DpzXWwZg=;
        b=EV0qNZrIFU7+/og28i6C7UFDEIULWu8qiXRm6fT/E/RHYr4z1Rf3lAiz87heEV6C7Z
         OqZoK4HNkF2Za6WVDHSbvaHAcChDsmPGCBWsso25Y2+59jHm/cJ+VSk6zG41ZqFr9f1p
         6VPDgX7XKcSCs6dePLsB6FT112MnNb2GnqO48rCPIY3fDbPqWAmO6fNTptB57ny8blTB
         +QXJeqxSr46PQTIDuavbdPaOIcznfKSwjqcVrUUwq8UDXmneJS8jMD+cDF06rqvEozrv
         xHMShXeoUkOGVBoCqIBY3ZDz0uSb2FYL4JZLcfR1u1gtDM/xoLfjM8miuYpFuc4wwMZM
         /mdg==
X-Forwarded-Encrypted: i=1; AFNElJ9Mkz12/LRkPrWrRK5uB5XjhFMBTH95DYxGjq6sUUKTDDp2Ypws6lUvvlzb0jS35UtGKkIO4G54ug==@kvack.org
X-Gm-Message-State: AOJu0YxodcgXnQYLFyMU6LeZjY2WMLsn+S+gyk0m2c/PaPP1R3JOSAmN
	E3LeOBOjjMN6OD/PfVATvht+pE/pCde9mLgfGBeQCmO/tN4CU/2qns/w8Hz6cpN5q4qWitdbaDY
	Xx+gLfucdfalMPzkvsQ==
X-Received: from edj17.prod.google.com ([2002:a05:6402:3251:b0:697:967b:20e9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:144d:b0:697:4e2c:c8ce with SMTP id 4fb4d7f45d1cf-697dbb3b56amr1244442a12.15.1782213177187;
 Tue, 23 Jun 2026 04:12:57 -0700 (PDT)
Date: Tue, 23 Jun 2026 11:12:56 +0000
In-Reply-To: <20260623105201.3724592-4-tarunsahu@google.com>
Mime-Version: 1.0
References: <20260623105201.3724592-1-tarunsahu@google.com> <20260623105201.3724592-4-tarunsahu@google.com>
Message-ID: <9huz7bnpo6h3.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v5 3/3] luo: Update serialized data to use KHOSER_PTR
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3032AC0009
X-Rspam-User: 
X-Stat-Signature: 19e56nb33m5njiqhdghqmtundkrhxm9x
X-HE-Tag: 1782213178-237127
X-HE-Meta: U2FsdGVkX19SAxxdNQa3QaKLMvgWdswuETg2o2ilOxefZeozLXobJysfddgVybVlO2fElOPk1w9eTxPL6/VJfYNf6PURP6TT1fh73pL2umGpUEslM1ycPN9Rf/XnruviKSVobbm+ataPKWRKhkSM4PozlDF1Pq8zrKjjevzMaqlcZnl0gfgXphKiGmBmZTpqju1yIGzWGPyxDhltNrTOnCUl3PFCyVXRe5MeIRKc0HQW1qRvNC3IxAN5tGs+1D7r2ruaWYPKjuGdLPwT1XInJEGRRWiFAo6AiF9Q5y7GMLHul3U/sE11dzqPTdT/iqAETpzNghsj1rNY9CKUu3T/SunqLMfcwzDSaNMcYfxivyPktP51fCFszY6Y+8xSAqBfQ1aAOBMIR/t4iKATep9a1A8kg+kYnu9d9XIT25ZBwMS3EvdZqPoxkxRF3VIU9EaM7AVN6ogiXz0vXRBO4zbguMvWjiEoTciYhbnmEh3Dq/AARfwoxrgNuLghA5C5hEFZ7bKQrQIUF76pbxU3pp1V+romPQoKhtiRQXbpU5+zx8BOHRlMeUAigWMyYP73aKxa40mvbxTd1zLAqee1VSTCqVsLfchdgvnISAHbK8uRy02IL/DMq3iINtuGjC2p2TSkO5NhNFBm7ZvOEzi/dzYs5HbZiJjOxU9SCAnmV+b76Kw4xR6/D01TSuCVMUl8lCpvuiuNnlTi8GsI8pWZuy0UPzdcdmQQS//wgLwE8Q/SYHw7E31egwiv8+v78aZxtNZkOwIq+Hxh+MWRbFjCqOkG9gldZae9o04/9BYckDqIhs0AWUEMiEF9UmuhIi1UyfiYdeHpREMQncumTQpJ5lDm1flCY+HP4wTx2z2hVko9bXIr0gURXDRxXHzURezEgwWKj4Sp6A52muzK7u10ixny6zouj1hyrI2u0fMEHHbFWEN11VJ0/nFHLa5Q7tg+5jiEjhvfH8y5oNUhaN7+U03
 TAuoXvmG
 ObosNTIyzp/6E7YLum1e8Ui+v0LG+F/ugv84MFjXylPdpejv63QOzXph4XkNutwGK4u8/yfTjiHHBZ/E7YDJzk2f43wE0sh7v2qGZ/R+8oNsNdhQruX5iYeZ8v77IFW1zdWMkowyCk/PuMIz+3yy/HN7lCpFdOv+CrrWZXdIZgzHcQxEijU95eUIizFRjKQWXUJ930mP9Nr3u6Kte6Bi8h5axXoQkyhTyQ+EXL7abKt7XEIQLzQhGkRN9FESX97KjiXrnBnyfWYLONIUbBrnfnNZM9F95H4nDpyRsR865PMuyiL61YBXcy2FC+7pp8Wvi9TCVAJ61IGIHwdvdcEAmUVXFd9YYDDMNhfWKr6JQPNaO2WIYl3x52Q1Xi3Lf7AwjskqM+5Mocz7sJQIXmDcoueldlJ413ganmj8PT88ADTYe/uej1IrWWEYK1wW2fRbOOE9plMJDLoWDZM0L2FI1UFwvzfycCtuEkeTdSHYdAlk+DfqS3gzxWViAoJ8EQhp6Up4bNJZVEtrR+p0NaVGWT6+cz5YqoadP63fMLTNhiUwRSvE6gfdnrIUF6qeqCZskqNQ7iuOvVbrHsbwP4Uh1NM6GXmj+N5gJDwCbpFgnj+v6XEkJh1pN9BTzqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
> This series also takes care of resolving the bug with memfd of using
> phys_to_virt before checking the args->serialized_data value.

This no longer needs the memfd_luo fix information.

~Tarun

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
> -- 
> 2.55.0.rc0.786.g65d90a0328-goog

