Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 466ACEA8114
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D4A6B008C; Tue, 10 Feb 2026 08:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAA96B0092; Tue, 10 Feb 2026 08:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13E66B0093; Tue, 10 Feb 2026 08:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90FCF6B008C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:30:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 320D11A0550
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:30:51 +0000 (UTC)
X-FDA: 84428632302.19.E775BE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 799EF1A0015
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:30:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q+KMZT6u;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770730249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBwIG2wQSDsiUiYiqArj4u79Eah9t6u78KhgKsVdJu0=;
	b=kFq+2ZbZdCSyXMtki6h8E7nl8FuEwHBqJieBiL1V2oznl3A2C8EzIGIvHXP2ejCQdR4hkg
	pcbzmkd7jfqOaEJ0icymbProDqsw6IlX4C/B5c2bnM/cPFAleVoNceTfdq6xnTUKyKRWq9
	O/zgIZAY4soq0dGFnUjCL64rT7Qjb6E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q+KMZT6u;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770730249; a=rsa-sha256;
	cv=none;
	b=iA3Y4RxcUfInNQ3/oJ6G0g/EgnghVCxgxMJ7uZKdNDkZJ98SjB/FiJMh8oxgB3/IDmflKO
	+R5s/x5pBAc+9cONOp+K/ELTVRik/m15RSDw5yoEQfXDEAzdYx9oKOVkTQoVrwyEwwF2dd
	81NNpKf/7CJDu29QNqFV3a0kHtbdotg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C64CD60097;
	Tue, 10 Feb 2026 13:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE95C116C6;
	Tue, 10 Feb 2026 13:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770730248;
	bh=tFOyTVhR+WU/OkMF4qkv7WslBiNhFBOO/Y7SpuCXXwk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=q+KMZT6uGMPekyGMrCG4ahzu+wWRYsoPqQ7zO4ONkJ78fzq87BqZDvFgxphBGDdVJ
	 ZK1o3eUvKE8YHbFFeY90FmOVnGh2VZLImCjghnJ//SkZMvdvLgCXY8wH8OAruoEYYm
	 1Wdh22uw6fmf3GZubBv/kS5gXg7qT4SfC+uQqo2Pl8YJUoC4t9J6IObqi16XJbI98U
	 0/n4eSKrQoKjuWP5AjAKI2T8dn2MJ+/Z/3DfAuydeUIJOg1B9mazxPtzGDolDAEIq6
	 IlkQaWO20DvSOWdIUgqprUQeSrS1/433CMo2J5/EBkNjiCArWr4wjA0oMaYlAjVfJO
	 owSOBNTwlgCfw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 2/2] liveupdate: luo_file: remember retrieve() status
In-Reply-To: <aXn05ADvj0X7N5bK@kernel.org> (Mike Rapoport's message of "Wed,
	28 Jan 2026 13:37:08 +0200")
References: <20260126230302.2936817-1-pratyush@kernel.org>
	<20260126230302.2936817-3-pratyush@kernel.org>
	<aXn05ADvj0X7N5bK@kernel.org>
Date: Tue, 10 Feb 2026 14:30:45 +0100
Message-ID: <2vxzfr78u3ne.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 79grde5cwa1qeym8srdqmdj4u3bbt7z5
X-Rspamd-Queue-Id: 799EF1A0015
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770730249-631749
X-HE-Meta: U2FsdGVkX1/OQFSTkMrsAw+nkXZls/dXC2acazDI1qTDmcTiPa6a/68Xg+UkwSQ+o4kxujGkYHLUAnCnpHlZ1Q355vBt8hUTYK/d90x1rmVhuX25q5Ge2tNZwsUb1FrdflRb8oqxSJMDt9MJbFbFakBOG7KqhBVp1pDSYts9yy2THa6gcBWzscttHdBxMKMz9WgOwgD2nxAOCfCBqu/ieggZRWzz9X75bAQoL79LhCHhYB5YsXirRWE64/x1WoHo6w34gHm3jjsxFscpw+RUHljefy7pBLjydqm3AGtgwpHvKMjkmiroXKhICPNArFRmGqYYIlu0PnnQECy7CHyh7nSqqL6pwTlFKQD5RzuT9CijdVvhn2xCP8rILDYJ0caCo9ID5NUt/GAQ3I9iHemKq67wxlbZVXsDbxp2+MUHwkMPkC4XQDO5qd1E3pEWm2chuswFEJ2wXuvR/yqzL71FfZzBpmy2x6L/qZX+CNbxcp8mMpEDt4jbEDIPama7LoJLqY0mO9vXJEamSLFD/SFAzg/37ReL7aGCSaRMdtxhfnslTgowhyJB/8EPD1MISviUR82+e9QAbKjSMcFmjlAFH+3wP8hrv1vwUrd5r8C3KTmLpMgTSjKpJuAvzHRmKzV2PrjERC1oG5mnHWahacpNAQ2PIX12R4C4vLCA0lGV1Yis53Evk7T+pfRYJxMy6es9tBjO+IpLDqOZxVaBT1JPilVUfy2w7qVNs5WoTvCkI7KfIB6Bq/T+/WZa0Z23sIwr4Ifxk2EdQNmaINwQ0IYqjE8RfqxwqP1Ncoh/clymC8VaPjOXvzsXi3qnjxwHxVa1K/YFH1wqjiMJQrwCnqybDmnjhhb9TjRIpUgARq3P+TERkpp979Fgx2t1MRb2O+38WLeQ0Fl+GKMENs0piPlqdLb83c4rsRSvz0GZfQrsGtLpVEyQQppri68cjmTU5z7UITbx9+04S1DxAJbLUQU
 UBzH0uEl
 lpnn8CooMZJR8iVXOzJT7BITmxvQAzdPlc/1WABLTB14MX6ZWMrYOY8LyGZyiNRUhWHc3tcpSeYm59ENtHAcJBvV6R/cA1bJgtg7uzEFiHVNGtCcTQvlgth2WM733Ggjs5rE1wn2D2gUwqWWUZrloRREh8VI1f0haBIMIpHRbTOc7y+/aGHorIavGDJ3vkwxkIOLYXX7ENNQbQXOLxYLogy025FlhWP6E5yHb6dRZEehrspA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thanks for the review.

On Wed, Jan 28 2026, Mike Rapoport wrote:

> Hi Pratyush,
>
> On Tue, Jan 27, 2026 at 12:02:53AM +0100, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> LUO keeps track of successful retrieve attempts on a LUO file. It does
>> so to avoid multiple retrievals of the same file. Doing so will cause
>
> 						  ^ Multiple  retrievals

Will fix.

>
>> problems because once the file is retrieved, the serialized data
>> structures are likely freed and the file is likely in a very different
>> state from what the code expects.
>> 
>> This is kept track of by the retrieved boolean in struct luo_file, and
>
> The 'retrieve' boolean in struct luo_file keeps track of this,

ACK.

>
>> is passed to the finish callback so it knows what work was already done
>> and what it has left to do.
>> 
>> All this works well when retrieve succeeds. When it fails,
>> luo_retrieve_file() returns the error immediately, without ever storing
>> anywhere that a retrieve was attempted or what its error code was. This
>> results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
>> but nothing prevents it from trying this again.
>> 
>> The retry is problematic for much of the same reasons listed above. The
>> file is likely in a very different state than what the retrieve logic
>> normally expects, and it might even have freed some serialization data
>> structures. Attempting to access them or free them again is going to
>> break things.
>> 
>> For example, if memfd managed to restore 8 of its 10 folios, but fails
>> on the 9th, a subsequent retrieve attempt will try to call
>> kho_restore_folio() on the first folio again, and that will fail with a
>> warning since it is an invalid operation.
>> 
>> Apart from the retry, finish() also breaks. Since on failure the
>> retrieved bool in luo_file is never touched, the finish() call on
>> session close will tell the file handler that retrieve was never
>> attempted, and it will try to access or free the data structures that
>> might not exist, much in the same way as the retry attempt.
>> 
>> There is no sane way of attempting the retrieve again. Remember the
>> error retrieve returned and directly return it on a retry. Also pass
>> this status code to finish() so it can make the right decision on the
>> work it needs to do.
>> 
>> This is done by changing the bool to an integer. A value of 0 means
>> retrieve was never attempted, a positive value means it succeeded, and a
>> negative value means it failed and the error code is the value.
>> 
>> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  include/linux/liveupdate.h   |  7 ++++--
>>  kernel/liveupdate/luo_file.c | 41 ++++++++++++++++++++++--------------
>>  mm/memfd_luo.c               |  7 +++++-
>>  3 files changed, 36 insertions(+), 19 deletions(-)
>> 
>> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
>> index a7f6ee5b6771..a543a3a8e837 100644
>> --- a/include/linux/liveupdate.h
>> +++ b/include/linux/liveupdate.h
>> @@ -21,7 +21,10 @@ struct file;
>>   * struct liveupdate_file_op_args - Arguments for file operation callbacks.
>>   * @handler:          The file handler being called.
>>   * @retrieved:        The retrieve status for the 'can_finish / finish'
>> - *                    operation.
>> + *                    operation. A value of 0 means the retrieve has not been
>> + *                    attempted, a positive value means the retrieve was
>> + *                    successful, and a negative value means the retrieve failed,
>> + *                    and the value is the error code of the call.
>>   * @file:             The file object. For retrieve: [OUT] The callback sets
>>   *                    this to the new file. For other ops: [IN] The caller sets
>>   *                    this to the file being operated on.
>> @@ -37,7 +40,7 @@ struct file;
>>   */
>>  struct liveupdate_file_op_args {
>>  	struct liveupdate_file_handler *handler;
>> -	bool retrieved;
>> +	bool retrieve_sts;
>
> int retrieve_sts?

Ugh, stupid mistake... Thanks for catching.

>
> and maybe spell out _status rather than _sts?

Will do.

>
>>  	struct file *file;
>>  	u64 serialized_data;
>>  	void *private_data;
>> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>> index 9f7283379ebc..82577b4cca2b 100644
>> --- a/kernel/liveupdate/luo_file.c
>> +++ b/kernel/liveupdate/luo_file.c
>> @@ -133,9 +133,12 @@ static LIST_HEAD(luo_file_handler_list);
>>   *                 state that is not preserved. Set by the handler's .preserve()
>>   *                 callback, and must be freed in the handler's .unpreserve()
>>   *                 callback.
>> - * @retrieved:     A flag indicating whether a user/kernel in the new kernel has
>> + * @retrieve_sts:  Status code indicating whether a user/kernel in the new kernel has
>>   *                 successfully called retrieve() on this file. This prevents
>> - *                 multiple retrieval attempts.
>> + *                 multiple retrieval attempts. A value of 0 means a retrieve()
>> + *                 has not been attempted, a positive value means the retrieve()
>> + *                 was successful, and a negative value means the retrieve()
>> + *                 failed, and the value is the error code of the call.
>>   * @mutex:         A mutex that protects the fields of this specific instance
>>   *                 (e.g., @retrieved, @file), ensuring that operations like
>>   *                 retrieving or finishing a file are atomic.
>> @@ -160,7 +163,7 @@ struct luo_file {
>>  	struct file *file;
>>  	u64 serialized_data;
>>  	void *private_data;
>> -	bool retrieved;
>> +	int retrieve_sts;
>>  	struct mutex mutex;
>>  	struct list_head list;
>>  	u64 token;
>> @@ -293,7 +296,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
>>  	luo_file->file = file;
>>  	luo_file->fh = fh;
>>  	luo_file->token = token;
>> -	luo_file->retrieved = false;
>> +	luo_file->retrieve_sts = 0;
>
> We kzalloc() luo_file, so this is not strictly required.

Okay, will drop.

>
>>  	mutex_init(&luo_file->mutex);
>>  
>>  	args.handler = fh;
>> @@ -569,7 +572,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>>  		return -ENOENT;
>>  
>>  	guard(mutex)(&luo_file->mutex);
>> -	if (luo_file->retrieved) {
>> +	if (luo_file->retrieve_sts > 0) {
>>  		/*
>>  		 * Someone is asking for this file again, so get a reference
>>  		 * for them.
>> @@ -577,21 +580,27 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
>>  		get_file(luo_file->file);
>>  		*filep = luo_file->file;
>>  		return 0;
>> +	} else if (luo_file->retrieve_sts < 0) {
>> +		/* Retrieve was attempted and it failed. Return the error code. */
>> +		return luo_file->retrieve_sts;
>>  	}
>
> I'd put it before the check for > 0, i.e
>
> 	if (luo_file->retrieve_sts < 0)
> 		return luo_file->retrieve_sts;
>
> 	if (luo_file->retrieve_sts > 0) 
> 		...

ACK. Will do.

>
>   
>>  	args.handler = luo_file->fh;
>>  	args.serialized_data = luo_file->serialized_data;
>>  	err = luo_file->fh->ops->retrieve(&args);
>> -	if (!err) {
>> -		luo_file->file = args.file;
>> -
>> -		/* Get reference so we can keep this file in LUO until finish */
>> -		get_file(luo_file->file);
>> -		*filep = luo_file->file;
>> -		luo_file->retrieved = true;
>> +	if (err) {
>> +		/* Keep the error code for later use. */
>> +		luo_file->retrieve_sts = err;
>> +		return err;
>>  	}
>>  
>> -	return err;
>> +	luo_file->file = args.file;
>> +	/* Get reference so we can keep this file in LUO until finish */
>> +	get_file(luo_file->file);
>> +	*filep = luo_file->file;
>> +	luo_file->retrieve_sts = 1;
>> +
>> +	return 0;
>>  }
>>  
>>  static int luo_file_can_finish_one(struct luo_file_set *file_set,
>> @@ -607,7 +616,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
>>  		args.handler = luo_file->fh;
>>  		args.file = luo_file->file;
>>  		args.serialized_data = luo_file->serialized_data;
>> -		args.retrieved = luo_file->retrieved;
>> +		args.retrieve_sts = luo_file->retrieve_sts;
>>  		can_finish = luo_file->fh->ops->can_finish(&args);
>>  	}
>>  
>> @@ -624,7 +633,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
>>  	args.handler = luo_file->fh;
>>  	args.file = luo_file->file;
>>  	args.serialized_data = luo_file->serialized_data;
>> -	args.retrieved = luo_file->retrieved;
>> +	args.retrieve_sts = luo_file->retrieve_sts;
>>  
>>  	luo_file->fh->ops->finish(&args);
>>  }
>> @@ -779,7 +788,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
>>  		luo_file->file = NULL;
>>  		luo_file->serialized_data = file_ser[i].data;
>>  		luo_file->token = file_ser[i].token;
>> -		luo_file->retrieved = false;
>> +		luo_file->retrieve_sts = 0;
>
> Here as well, we kzalloc() luo_file, so zeroing out of the fields is not
> strictly required.

ACK.

>
>>  		mutex_init(&luo_file->mutex);
>>  		list_add_tail(&luo_file->list, &file_set->files_list);
>>  	}
>> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> index a34fccc23b6a..ffc9f879833b 100644
>> --- a/mm/memfd_luo.c
>> +++ b/mm/memfd_luo.c
>> @@ -326,7 +326,12 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>>  	struct memfd_luo_folio_ser *folios_ser;
>>  	struct memfd_luo_ser *ser;
>>  
>> -	if (args->retrieved)
>> +	/*
>> +	 * If retrieve was successful, nothing to do. If it failed, retrieve()
>> +	 * already cleaned up everything it could. So nothing to do there
>> +	 * either. Only need to clean up when retrieve was not called.
>> +	 */
>> +	if (args->retrieve_sts)
>>  		return;
>>  
>>  	ser = phys_to_virt(args->serialized_data);
>> -- 
>> 2.52.0.457.g6b5491de43-goog
>> 

-- 
Regards,
Pratyush Yadav

