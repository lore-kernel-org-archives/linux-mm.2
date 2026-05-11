Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D75ECD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8719D6B00B9; Mon, 11 May 2026 12:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848216B0144; Mon, 11 May 2026 12:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785006B0146; Mon, 11 May 2026 12:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6778E6B00B9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:36:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A43C40204
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:36:01 +0000 (UTC)
X-FDA: 84755690922.12.CF90BC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 593B14000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:35:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=idLeIRL9;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORD3PwyyW2DYfLIqd/NoUkaMynxGygGMiJ0enNnIn6c=;
	b=bgdWAzVc5MhOSYhzzaMLF7m8LKM9RqXpkIWeESxUt7X2BjD7TR2HX+JmYqnt3UTVq0bX7V
	knytiWfGJjf2TIQKu2HCa3cQja4DBi0pxYzxHgYfWkL25/RLVLWZYId+HfDs2IcjJym7Du
	4a/fG/YtufTpWO6SlaKn0LKBCerxw1I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=idLeIRL9;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517359; a=rsa-sha256;
	cv=none;
	b=6AP6By46Cs9BhNO6rwSO2JryWUXI6TWWRkBigQ7LV2DIQr8wBwG6XcdYmyNTxFMj4kUJf5
	oZUQLdPutLy2mIiJ/h/Y7exESKsX6NdxbcBvwD6nyHB38qpKgPx/F3SwBjTKZdFHEDzTWB
	4t9JmnZ3WdFei73CE64Q/M+jtMWBAsA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66BF643493;
	Mon, 11 May 2026 16:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548B1C2BCB0;
	Mon, 11 May 2026 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517358;
	bh=pj/UdlMowZtsAQ7KPce4Qa+NpB32K7TNb0wg1aMyj7Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=idLeIRL9ovET+lCaODzlgj4aiZ5Y6SYo/1Jnar26AsQVrG4KKwahz9CaLUAyB/Rlr
	 MHnjKSvDOXwXp9JHp76z2kksMMcgzPh0ISYvazdM8ZXDkXU6msyXONGDEtgYXzz3tE
	 y3tUPsDp/xRlRSrY0L+nzRH1oE1dlcNKnwrBcTvAxSTQ1DPdG4/FrOODQgW7D2YebA
	 y+6MQsnwGA9GfpNugxx+Mug7afGVBlWjTA8Us6XPYabaweaUbmshm/O9lGAWAITop+
	 r2r6pzJr61FVJOW+Luq+pIa7QXEytJ+1qu2tCFwdipUpjAdnOYxwfOTGkJDAFbhamq
	 YNDSTl3xH862Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] kho: add a struct for radix callbacks
In-Reply-To: <agHB7HB-p_vkLS7R@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 14:47:56 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-4-pratyush@kernel.org>
	<agHB7HB-p_vkLS7R@kernel.org>
Date: Mon, 11 May 2026 18:35:54 +0200
Message-ID: <2vxzzf25c39x.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qu8ccq4gdo5epkf5nkf4pox788meb6o1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 593B14000A
X-Rspam-User: 
X-HE-Tag: 1778517359-170174
X-HE-Meta: U2FsdGVkX18bQ9zv3t86L8aRYWnlyf4RVu/wb7Uoo2ute0xIYl2wUHH8Csz7UuK0ASTxTPEuttUYaPwc7Shf8xGtgVoUUsc23TIQpLuxrN5nFCHSEZx8DKdHEXMLxFoUBYphSALuMkCjapNKy1WhmLLeAjtitxaKeB9iwG7YlCPFgHOCmbeFwjetFNjyw49TgZku8BbEnPhcHFYqaNgGAjue8bOUT8c5PENx1g0nopEovqgsd8zWI8lf536QjuPAuhuMiRThf0cs0cgHJvEi/g4xRWBZqmwEWL1RHeoNs8L8YBVEIvi2iJgb73fglgZYtlW9P6hKY14IIF4Zd35i8wPZwlMkn1Z4+AdFIyyv7XXS3SoRfy1kIIvtmvKGE6cPbi/lFTBHLIu09LTOXls+A/CpNEZAEclPryT0cTlp4ZPZhwnzmD6Jdt2gr4qN0rRe+8XVYmYoiYmNxFOcupO1/eBdHavnnZHv5Ryo9GGTYomTphVF6rMa1YXoxSPihJWibi6ueTziaKvKwk7ulQ3ntBOrasl4uRyVDZP0S+6SBxeviZrv38CTkjse4U4h/aDeD5XOf5824N8UdyRF3ZqKDwLRJZ44i7P7HOjY3mt+W7+S5Z9Gt7zagSGobskSZIAbbZ5PkF3yhaa6sgd4iPxZ88XEvafD5TSLfnmxnBeVb9Y1arTa8rqNLd0Tk2w3A9FSJblgO9nvO6CI5oOPRlQNKLKd0+olms8Dyh9G+Yo8vyP+nwRSp4dOg36c1kcdxdw8kfsU5HXv1jTAy9Ui+I+yvW9BlPhy4VwOLpQP+L0w2u+kRfHz6xm7R2Mg5Vt3A6PNP4yxwQgPn7CuTGSa1UsaYsMbyJUHCCn4IoA7r4CoF3m++ls1+8/oZVJbtlkIh6VY5kHIgUo7MSGfCeisLibuCFx/frx8zVUrQUfvK7Fs3lH4W3HsOryvS5giynSLlXU/ojteMY8uVPpuJkudY2q
 OMPm5imb
 HsrMbO3diF7erNVL9MkDzNSy1s/ev4CXKizdlf5ZsdU8ZLg62ueYTJTXE94ZFE/WXCwKviZ+JfX2+aviDkmEk1+OX4XefEzTceN25fNiOD4NqdBJIxt8hjFCrr3RBsplLnNT9v5yOxZ/OpYLm9VeIS2ePsgmdW9kXEKcJxY+wOxnAbCDRqY5lSmfV+1ANh6AFECJRXMCkNR0Kbww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, Apr 29, 2026 at 03:39:05PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> A future commit will add more callbacks for the KHO radix tree. Add a
>> struct for collecting the callbacks.
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
[...]
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -266,16 +266,18 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
>>  }
>>  EXPORT_SYMBOL_GPL(kho_radix_del_key);
>>  
>> -static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
>> -			       unsigned long key,
>> -			       kho_radix_tree_walk_callback_t cb)
>> +static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
>> +			       const struct kho_radix_walk_cb *cb)
>>  {
>>  	unsigned long *bitmap = (unsigned long *)leaf;
>>  	unsigned int i;
>>  	int err;
>>  
>> +	if (!cb->key)
>> +		return 0;
>> +
>>  	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
>> -		err = cb(key | i);
>> +		err = cb->key(key | i);
>
> key(key) reads weird :)
> Can't say I have a good name, maybe key_action()?

I thought the context of it being under a callback struct would make it
more obvious. I don't like key_action() much better TBH, but I don't
have a strong opinion. Perhaps Pasha can suggest a 3rd option and we
pick on randomly ;-)

>
>>  		if (err)
>>  			return err;
>>  	}

-- 
Regards,
Pratyush Yadav

