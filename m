Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60AECDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44226B008C; Tue, 23 Jun 2026 16:17:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C816B0092; Tue, 23 Jun 2026 16:17:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A726B0093; Tue, 23 Jun 2026 16:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8520F6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:17:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6ADAC8812E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:17:21 +0000 (UTC)
X-FDA: 84912287082.02.334D86A
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id EEDAB40003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:17:11 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782245832;
	b=s78B2qbeeKC6qzh8O5+pj3dN7ihCCw/eDPdOdHm6Uk8kgq7UQNWdVfqnNbkj9J4I6g6RKb
	cYjSpvdUDSpbPDk0R2vOYkXJt9L6E1MktcXLQ2+w3B45UF/E4aei67UTpOBaGjXPv9NLdl
	4J4XQDjuDbyUiyKunml/eDn8KJfF7OE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782245832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAeaAmzPudCQkzDl1bJybobs2yz8/KEyEmeBH2z2/jA=;
	b=vFB0+26a8lKKmEwF6YsiLjWSgxsTrfTJn1DoQ66bRASZz6nty+v+UPhrMiyi0gyl/DZWOJ
	mQtB2LeEhG0abCxOzG+WOkyXrlYISTCdjYq2fVD8tLi7ibKUaadwgg/W7m7HQOigV5rRBE
	q2GidjE3ll2A9Qds0oHFMyWszaZNYf0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OEctNDtM;
	spf=pass (imf27.hostedemail.com: domain of 3xek6agkKCNwR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3xek6agkKCNwR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c0cf538efe1so13225366b.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782245830; x=1782850630; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QAeaAmzPudCQkzDl1bJybobs2yz8/KEyEmeBH2z2/jA=;
        b=OEctNDtMw57whOUcyMcSQMgUCFeFPZtr9hAUgj6dJSNAaQ0bYrN6rYK0Rb8mX2bhoI
         r2J8Yu09dctLwF7km+W0FQlObv0K8K6qqx5EwTDMbmNIOZtydfknP8h6btOfAPaq6QIe
         2XLinPRjWxqFB3zhyDkKHQOtlqcaN0o7UzY6QDaPkkyxUCauTAit96o9d85Z+WEZtKf+
         YjDvkMEMclZbjOCc1hbuQC8XYG+YxIbuEkRiQtI6nydOw+lEFood0aZg6cywwJ9G4zWF
         3xgGcN3j1zhoLWqG34jSM2e/2gY064We7bOWXKACTG7IcsrYZ8HVGnzxxAlWSdR+HQwS
         xcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782245830; x=1782850630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QAeaAmzPudCQkzDl1bJybobs2yz8/KEyEmeBH2z2/jA=;
        b=brR2UdDGbW7iEqKgktkwerE4TrHFDg/eJaf6GeB0QaBqIo+/cXLzAFLGP56Wb7BcZg
         kuLkOWzAYMZe/t6ia6Jccy2envHMcvzPjG1NW+aFOrUfnBPGnpLqSeS833XN0T3vmZ/Q
         VZUN4rHV+58md+IRZXkJcnYlxG+2i9tM6oMmxutEYtqaSP/dB+UtqDwclFmOGx69NyQR
         YcM4D/V57ogpcr1dodrttJRwxP2Av8bSEWZsOPzWZjAARzk8rmpeg31VXiwk+/ldxpl0
         omXZCar1IorzPeuzKotylBngMdEEXOOphMc7LA/O8BfsZJE/KqquLpWhjTl3uA5GAKh7
         xL/Q==
X-Forwarded-Encrypted: i=1; AFNElJ/DYaUG+t0RyLKCtOsMifRC1qEAlSlXtMpD0Jlp5kIgeH2VQDQfqbhKSPmuHTEf6VjzUzA697+hCg==@kvack.org
X-Gm-Message-State: AOJu0YwLulSpAliZgDI+0+Pg9vJZ941pchybxNKnE867tAh9gdz+BZ7I
	XwinluUMRFPNoWW+DMnvphW7ZPtqMQB8eLPhl+f/FvFAudONQ8fpv/JAxuSbSegdQfUFptay8M/
	1A1bZyrQXEIwBV5RWxA==
X-Received: from ejka19.prod.google.com ([2002:a17:906:40d3:b0:c08:1933:6a0c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9301:b0:c0c:d279:e04a with SMTP id a640c23a62f3a-c119e45a12cmr7724466b.34.1782245829983;
 Tue, 23 Jun 2026 13:17:09 -0700 (PDT)
Date: Tue, 23 Jun 2026 20:17:09 +0000
In-Reply-To: <2vxztsqtmn7s.fsf@kernel.org>
Mime-Version: 1.0
References: <20260623105201.3724592-1-tarunsahu@google.com>
 <20260623105201.3724592-4-tarunsahu@google.com> <2vxztsqtmn7s.fsf@kernel.org>
Message-ID: <9huzse6d106y.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v5 3/3] luo: Update serialized data to use KHOSER_PTR
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1782245831-914948
X-HE-Meta: U2FsdGVkX1+fNOH9da7gfzd4wMBbYujW2H9JT0KKxLSZj5OJ/EtrZ6/bisvAcFGq7FtjVI+RA8oaGXTTtYs4SVqe4rXGKnXbklfFLxMLXqyJHp1Ip0N3aNGqbHEjW91N/1BEpOOQUE0nRPKkLE+ln0s5xJOvhL+DFiknDvbNiM+XhtW4PBfv5aoxQh8baZwVOy0Fgt19hhJ/OdTuveoE/V68pmTsI9ouDf3LjDZrizmd2fhK1oFY3h8C7oCQpqpMBAPgC+R/WrNQtFjPcCP60t/DpofBew3o7n+ofe/S9Qva1bhTj8A45lQk8Yr5pB2EJ5Twb/wBtNpAI5AcV+rkuy8wyLiKfXkit0fmYSPdkmSMk4hGF/3XMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Thanks for reviewing!

Pratyush Yadav <pratyush@kernel.org> writes:

> On Tue, Jun 23 2026, Tarun Sahu wrote:
>
>> Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
>> This series also takes care of resolving the bug with memfd of using
>> phys_to_virt before checking the args->serialized_data value.
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>  include/linux/kho/abi/luo.h  |  5 +++--
>>  include/linux/liveupdate.h   |  4 ++--
>>  kernel/liveupdate/luo_file.c | 24 ++++++++++++------------
>>  mm/memfd_luo.c               | 20 +++++++++++---------
>>  4 files changed, 28 insertions(+), 25 deletions(-)
>>
>> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>> index 288076de6d4a..d5b3b1c0fec1 100644
>> --- a/include/linux/kho/abi/luo.h
>> +++ b/include/linux/kho/abi/luo.h
>> @@ -59,6 +59,7 @@
>>  
>>  #include <linux/align.h>
>>  #include <linux/kho/abi/block.h>
>> +#include <linux/kho/abi/kexec_handover.h>
>>  #include <uapi/linux/liveupdate.h>
>>  
>>  /*
>> @@ -89,14 +90,14 @@ struct luo_ser {
>>  /**
>>   * struct luo_file_ser - Represents the serialized preserves files.
>>   * @compatible:  File handler compatible string.
>> - * @data:        Private data
>> + * @serialized_data:  The serialized pointer union for this file
>
> Nit: "serialized pointer union" makes very little sense once you lose
> the context of this patch. The union is an implementation detail. I
> think "serialized KHO pointer" makes more sense from documentation
> perspective.
Ack.

>
>>   * @token:       User provided token for this file
>>   *
>>   * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
>>   */
>>  struct luo_file_ser {
>>  	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
>> -	u64 data;
>> +	DECLARE_KHOSER_PTR(serialized_data, void *);
>>  	u64 token;
>>  } __packed;
>>  
>> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
>> index 88722e5caf02..480d638b7d18 100644
>> --- a/include/linux/liveupdate.h
>> +++ b/include/linux/liveupdate.h
>> @@ -33,7 +33,7 @@ struct file;
>>   * @file:             The file object. For retrieve: [OUT] The callback sets
>>   *                    this to the new file. For other ops: [IN] The caller sets
>>   *                    this to the file being operated on.
>> - * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
>> + * @serialized_data:  The serialized pointer union, preserve/prepare/freeze may update
>
> Nit: Same here.
>
>>   *                    this field.
>>   * @private_data:     Private data for the file used to hold runtime state that
>>   *                    is not preserved. Set by the handler's .preserve()
>> @@ -47,7 +47,7 @@ struct liveupdate_file_op_args {
>>  	struct liveupdate_file_handler *handler;
>>  	int retrieve_status;
>>  	struct file *file;
>> -	u64 serialized_data;
>> +	DECLARE_KHOSER_PTR(serialized_data, void *);
>>  	void *private_data;
>>  };
>>  
>> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>> index c39f96961a85..aecf19033f95 100644
>> --- a/kernel/liveupdate/luo_file.c
>> +++ b/kernel/liveupdate/luo_file.c
>> @@ -125,7 +125,7 @@ static DEFINE_XARRAY(luo_preserved_files);
>>   * @file:          Pointer to the kernel's &struct file that is being preserved.
>>   *                 This is NULL in the new kernel until the file is successfully
>>   *                 retrieved.
>> - * @serialized_data: The opaque u64 handle to the serialized state of the file.
>> + * @serialized_data: The serialized pointer union to the serialized state of the file.
>>   *                 This handle is passed back to the handler's .freeze(),
>>   *                 .retrieve(), and .finish() callbacks, allowing it to track
>>   *                 and update its serialized state across phases.
>> @@ -161,7 +161,7 @@ static DEFINE_XARRAY(luo_preserved_files);
>>  struct luo_file {
>>  	struct liveupdate_file_handler *fh;
>>  	struct file *file;
>> -	u64 serialized_data;
>> +	DECLARE_KHOSER_PTR(serialized_data, void *);
>>  	void *private_data;
>>  	int retrieve_status;
>>  	struct mutex mutex;
>> @@ -289,7 +289,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>>  	if (err)
>>  		goto err_kfree;
>>  
>> -	luo_file->serialized_data = args.serialized_data;
>> +	KHOSER_COPY_PTR(luo_file->serialized_data, args.serialized_data);
>>  	luo_file->private_data = args.private_data;
>>  	list_add_tail(&luo_file->list, &file_set->files_list);
>>  	file_set->count++;
>> @@ -342,7 +342,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
>>  
>>  		args.handler = luo_file->fh;
>>  		args.file = luo_file->file;
>> -		args.serialized_data = luo_file->serialized_data;
>> +		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>>  		args.private_data = luo_file->private_data;
>>  		luo_file->fh->ops->unpreserve(&args);
>>  		luo_flb_file_unpreserve(luo_file->fh);
>> @@ -375,12 +375,12 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
>>  
>>  		args.handler = luo_file->fh;
>>  		args.file = luo_file->file;
>> -		args.serialized_data = luo_file->serialized_data;
>> +		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>>  		args.private_data = luo_file->private_data;
>>  
>>  		err = luo_file->fh->ops->freeze(&args);
>>  		if (!err)
>> -			luo_file->serialized_data = args.serialized_data;
>> +			KHOSER_COPY_PTR(luo_file->serialized_data, args.serialized_data);
>>  	}
>>  
>>  	return err;
>> @@ -396,7 +396,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
>>  
>>  		args.handler = luo_file->fh;
>>  		args.file = luo_file->file;
>> -		args.serialized_data = luo_file->serialized_data;
>> +		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>>  		args.private_data = luo_file->private_data;
>>  
>>  		luo_file->fh->ops->unfreeze(&args);
>> @@ -483,7 +483,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
>>  
>>  		strscpy(file_ser->compatible, luo_file->fh->compatible,
>>  			sizeof(file_ser->compatible));
>> -		file_ser->data = luo_file->serialized_data;
>> +		KHOSER_COPY_PTR(file_ser->serialized_data, luo_file->serialized_data);
>>  		file_ser->token = luo_file->token;
>>  	}
>>  
>> @@ -587,7 +587,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>>  	}
>>  
>>  	args.handler = luo_file->fh;
>> -	args.serialized_data = luo_file->serialized_data;
>> +	KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>>  	err = luo_file->fh->ops->retrieve(&args);
>>  	if (err) {
>>  		/* Keep the error code for later use. */
>> @@ -621,7 +621,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
>>  
>>  		args.handler = luo_file->fh;
>>  		args.file = luo_file->file;
>> -		args.serialized_data = luo_file->serialized_data;
>> +		KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>>  		args.retrieve_status = luo_file->retrieve_status;
>>  		can_finish = luo_file->fh->ops->can_finish(&args);
>>  	}
>> @@ -638,7 +638,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
>>  
>>  	args.handler = luo_file->fh;
>>  	args.file = luo_file->file;
>> -	args.serialized_data = luo_file->serialized_data;
>> +	KHOSER_COPY_PTR(args.serialized_data, luo_file->serialized_data);
>>  	args.retrieve_status = luo_file->retrieve_status;
>>  
>>  	luo_file->fh->ops->finish(&args);
>> @@ -748,7 +748,7 @@ static int luo_file_deserialize_one(struct luo_file_set *file_set,
>>  
>>  	luo_file->fh = fh;
>>  	luo_file->file = NULL;
>> -	luo_file->serialized_data = ser->data;
>> +	KHOSER_COPY_PTR(luo_file->serialized_data, ser->serialized_data);
>>  	luo_file->token = ser->token;
>>  	mutex_init(&luo_file->mutex);
>>  	list_add_tail(&luo_file->list, &file_set->files_list);
>> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> index 10f3983b0060..852b61678229 100644
>> --- a/mm/memfd_luo.c
>> +++ b/mm/memfd_luo.c
>> @@ -257,6 +257,7 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
>>  
>>  static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>>  {
>> +	DECLARE_KHOSER_PTR(sd, struct memfd_luo_ser *);
>>  	struct inode *inode = file_inode(args->file);
>>  	struct memfd_luo_folio_ser *folios_ser;
>>  	struct memfd_luo_ser *ser;
>> @@ -309,7 +310,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>>  	inode_unlock(inode);
>>  
>>  	args->private_data = folios_ser;
>> -	args->serialized_data = virt_to_phys(ser);
>> +	KHOSER_STORE_PTR(sd, ser);
>> +	KHOSER_COPY_PTR(args->serialized_data, sd);
>
> This is awkward. Why do you even need sd? Why not just do
> KHOSER_STORE_PTR(args->serialized_data, ser)? KHOSER_COPY_PTR() doesn't
> give you any type safety for args->serialized_data anyway, so why the
> extra steps?
Right, I will remove that, It was needed when I was using TYPE(UN)SAFE calls.

>
>>  
>>  	return 0;
>>  
>> @@ -325,11 +327,10 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
>>  {
>>  	struct memfd_luo_ser *ser;
>>  
>> -	if (WARN_ON_ONCE(!args->serialized_data))
>> +	ser = KHOSER_LOAD_PTR(args->serialized_data);
>> +	if (WARN_ON_ONCE(!ser))
>>  		return -EINVAL;
>>  
>> -	ser = phys_to_virt(args->serialized_data);
>> -
>>  	/*
>>  	 * The pos might have changed since prepare. Everything else stays the
>>  	 * same.
>> @@ -344,14 +345,13 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
>>  	struct inode *inode = file_inode(args->file);
>>  	struct memfd_luo_ser *ser;
>>  
>> -	if (WARN_ON_ONCE(!args->serialized_data))
>> +	ser = KHOSER_LOAD_PTR(args->serialized_data);
>> +	if (WARN_ON_ONCE(!ser))
>>  		return;
>>  
>>  	inode_lock(inode);
>>  	shmem_freeze(inode, false);
>>  
>> -	ser = phys_to_virt(args->serialized_data);
>> -
>>  	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
>>  				    ser->nr_folios);
>>  
>> @@ -397,7 +397,8 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>>  	if (args->retrieve_status)
>>  		return;
>>  
>> -	if (!args->serialized_data)
>> +	ser = KHOSER_LOAD_PTR(args->serialized_data);
>> +	if (!ser)
>>  		return;
>>  
>>  	ser = phys_to_virt(args->serialized_data);
>
> This doesn't compile :-(
>
> You should always _test_ the changes you make. Compiling them is the
> first step. _Running_ them is the second. Both are important. Please do
> so in the next version. And for every code changes, no matter how
> trivial it seems. You never know if a simple looking change can trigger
> bugs.
>
> You should at least run the LUO selftests and make sure they pass.
>
Right, My bad.

>> @@ -523,7 +524,8 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>>  	struct file *file;
>>  	int err;
>>  
>> -	if (!args->serialized_data)
>> +	ser = KHOSER_LOAD_PTR(args->serialized_data);
>> +	if (!ser)
>>  		return -EINVAL;
>>  
>>  	ser = phys_to_virt(args->serialized_data);
>
> Here too, this doesn't compile.
>
> -- 
> Regards,
> Pratyush Yadav

