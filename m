Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD138606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=UmOdeSoV
Received: by kanga.kvack.org (Postfix)
	id C8B006B05C2; Wed, 11 Nov 2026 10:15:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62DC6B05C4; Wed, 11 Nov 2026 10:15:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78B06B05C6; Wed, 11 Nov 2026 10:15:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 898886B05C2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:15:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16E7C1A0337
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:15:42 +0000 (UTC)
X-FDA: 85423187724.09.8AD8306
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 178CA40008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:15:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UmOdeSoV;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794410140;
	b=wyEEo6NwYddHUf+aSj5nlzn4INV8AdVXTDfqJYr0zaoZ1okXCI+SFO6Ca0gVexBEUi4VK3
	L5XpGywKsorRRqU0OUJYUVpkjLRV8rVvxvrRgDPcadEARWf2kilwsRRQkeMHOhogoADzC2
	/PYxEKXrMuSGWcmDzHILXV8UwmnODAM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794410140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MN59RS0FEa8Yt1lpkKUAzp9vOqlc0URHQI/8ivhnpE=;
	b=Vj+spCrigaS7ekhUyaHfXYSkrFutJjOLHdM7ImgCGE3TpuWteQpHHntg5xyOnxAVXUHW3X
	6C/xw0v8Utbpje4ZotKDczruy46NNLuy6VJpJ8KmlHXHMUWT5A22nfrq5gqtvRWbqyRBVx
	rdNOEQbV6mpWvY4yuSvtS+4JOVBX/Sw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UmOdeSoV;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7777fa8f1ccso1149790137.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794410139; x=1795014939; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7MN59RS0FEa8Yt1lpkKUAzp9vOqlc0URHQI/8ivhnpE=;
        b=UmOdeSoVYujN2k00lzybjbY9ll038ynR9kRXozGVR6pL/2o0kARcnEn+nlWG6pXbEc
         mcx8v6mKfs0WnTg2ByeLLfVFKWT4woE0Z5P/5nL/WlcTZO3t03pBLKMkg/KneeVuvmRW
         bpMFft32Ah61YIBAJEhVLPXYA+VQLqSo2O05oKayYV3i2mQsrnxQkGZCFvl8tCXHrZ8g
         mhvzK65ZrdS8oQCVBZbiltolSU2U1NigRK0r2eqYVXDSFRNJAiwUyjyzdm6K0tISLP90
         WuKcHDtAxVHHAtEshB//mJVn1FyHY+DW5pRxaQ/GIesIqMwVBOdBa8TMaz34reyU/laE
         /knQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794410139; x=1795014939;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7MN59RS0FEa8Yt1lpkKUAzp9vOqlc0URHQI/8ivhnpE=;
        b=Avco2m+Ai/FP+qTcWPhPFlp1CCdhLxXvK3YQ+fztTqzLI9B5g0pf9FwLRk08BaEVQN
         +MYHrEhpYquih3QkjXHZXkMtjfJDdwbRZ3cvaCrybdgWHCbyZi+Skrlkl7DDX3tZ1ClK
         17dbH2FAze+AEkZKKaATBQYnIM7zgi7xlsGPHP7dCcD4u5FtXvWfN6oieKy3XJ76HaLo
         /ZC8ykva8NvR/Md8JxxoDQZERGr5sh++BJX8RzdKJICl52vRYTfl9zmMaz5MTAB1mP+U
         hNSE3Vlu46viygVO1GDKBT7O7y7zIxdTfeoHYvlMRs5tObe55yF6rYDPMSkO3R/ezQCs
         Brng==
X-Forwarded-Encrypted: i=1; AL+hErGAuNH75iKLlhzAg7ojKaQIxAmtfcOfiF4Qyc8hWSQlYavbHPM+bzBiW5ZMYsO/8QnXkL9qmSaQ2Q==@kvack.org
X-Gm-Message-State: APuU4Z8DYWgd90aoLCOhug3wQ+1CAdnjsTiFy2/WCm54x9B6BL5IovsB
	aNecKv2a2RVtPJOuym9DWcK2YF7z/aAB6fg1v03BE4NaGq2K51EE/eXPvrfk8tvzDFQ=
X-Gm-Gg: AYBFou2Xf8pBpPIFf50pBTTb9B+I0LgbVyIn+fEayYY9O9UtUAsJoq9kgO+JvVMli5W
	uBrkdaATDx1GDo2Z58Ay7XuSzVscDPCGzBcO4inVmuWGpgJppYiGtIUxQprqaOukrQ/7rUDdaLo
	inL1mxCRgZlZXD8tLi0OpEhPbP6NK5k2ub7v/RpZtEDnwvyGJ3NzhgxXS+eKOuagl1DtHPCJwCx
	thbXftAaTR7vS0EgF0sBJzUc5IcS3CeOIf/S7Tj00KzUu4BGWGgTppKDVMmMVIxm9J7wed+erxK
	BHzCgTJZreY0n1sueopvRTiAmGegb3U4jdbQDxJnYgo60gBBc5W3/I6z/jkb/q1dHKjCAWfcmOC
	+uJ+TkSlh6mF4ornv+nTYYPg1VAfWUXsxgw0+qMOdXsGWEtZL2Jvq5bq8LSMBk0nj/aCzrx00+d
	+o8RCRyKB4cQpvTvSv1OnmZFNKdbsplMvVA6t+QKHYO+UMFo0IktmKD5Dp5efRGeMQTRUndsYFb
	YGrGyYIglWzbxBw91I+J+Ob3eNtZfqufBmmc+4aJqmhNX91OlPXeGnnFCpdbm9BeVLqzS1bf++o
	TY3gSNzNXLg3Ubr7MJpUJzstDcBIgaxK9S8Pqz5hG/p1LJV71B1HVkvOQ0dRHd/OrmLsSEORWR1
	VCsIv8D1C2Jz/9iBTLASJspfmQk/0
X-Received: by 2002:a05:6102:5cc8:b0:7d2:cdd6:6be with SMTP id ada2fe7eead31-7d505fa8765mr836563137.21.1794410138969;
        Wed, 11 Nov 2026 07:15:38 -0800 (PST)
Received: from localhost (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee1dcd3930sm1185914e0c.11.2026.11.11.07.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 07:15:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 10:15:36 -0500
Message-Id: <DMSHB0JBS5V8.1IZD7WPEQGPMA@soleen.com>
Subject: Re: [PATCH v5 2/6] kho: support incremental entry publication in
 kho_block
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Mike Rapoport" <rppt@kernel.org>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>
Cc: <linux-kselftest@vger.kernel.org>, <shuah@kernel.org>,
 <linux-mm@kvack.org>, <skhan@linuxfoundation.org>,
 <linux-doc@vger.kernel.org>, <vipinsh@google.com>,
 <linux-kernel@vger.kernel.org>, <corbet@lwn.net>, <dmatlack@google.com>,
 <kexec@lists.infradead.org>, <pratyush@kernel.org>,
 <rdunlap@infradead.org>, <graf@amazon.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
 <20261105050053.3063001-3-pasha.tatashin@soleen.com>
 <179439592040.425130.12391503339294194908.b4-review@b4>
In-Reply-To: <179439592040.425130.12391503339294194908.b4-review@b4>
X-Rspamd-Queue-Id: 178CA40008
X-Rspamd-Server: rspam12
X-Stat-Signature: q1tf6udn8yhtx48f874axwtcrdbozxao
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794410139-291866
X-HE-Meta: U2FsdGVkX1+st1v1OUDk2RESekUBZ+3ZaG7+Ui4ktPM0fJZWCnJ39KXXNwQnKSmrx3NJLVWJjMNLghYpoxOxJahhQYwKqYx4+KQ3ZeNWJ3DnZrju5pYlfFkU/nzdDbIizikzgnC0Mh8LusVD0IUgk1WDs/WCKmYurI1IFlmYV9vghqknD3rOGhUAJ0yxdvd0Y1EKOQZqjzyLjBWs422mrmFLUjeJDWay2hTrlafVwJyaDveLsGRWw0w874D7HLu8DyR6XcBVaz+ZBSsc128nwh6O3T1OPXh2L+xkihXE7dhuKz6RzBf/UaZV5mRNpTcIrjRSxwy/a4INNcg0q8GFJMlKMI4QHieIyUxNHLusom8lu5+Hcu2bT5IrFmhXlUcAoaIlUAjfrz2TK6YOaB2Tj2bJ1EyUo7CpG+hpqQVExr0VZ+Tj6XGM3D27nOTr/Prozcb/OIPCkroiuhWOExJ7wR9AmnoHAB4xTDiVBtX7hdNdVD/kezIWFeGs1w53sNdW0+APazMhj/woyYNHAKIeI9PAzJEanvl5tAjAme+ZBO43zGSgN+cBNaShg2AOAZ0wmDS1rgMD1rKm7Qj0hFTVTJSuI5b1aTMIbMshrSEIlKloiPgRGU7pUKNvbDef1b2LYLHOrCUd3ASBsSGkJi+gR4k2Ik9vFPG1+C8vMAIrATegnKyXYK7lbOI1rTkSX5WfwPU4nn4Ry8zKsLnoL4OMYKse3/1fPA5bQI4WMpnhyJYBKRn4Mu8Rb8Pzu6QYhSDrLsPm5grQDn6ca7DpBWLqi9p1qcvOZT2/TM0NRVvLG8k7cScBkPiQL0ku/GZircawX/Xn7ciAvNhHeVRDKaBrURetieWZnwT3i3QmjrI9nl7ZgHCHNEG9L8zy49z1GaMxyp9RAYbTzvPvelPSA4a7A46JaKpA5hJeqr1vT/BJ15iKHPRn062lid/siOUefW+hY7zbLDPUBPg+hS6OVCy
 2NfTvyuO
 tNFcJq6/6jt+pxlKcSQ6Z5Z8zTm/5SVd00rKWqe2uIWgpUTQAPVeJrytxcCzET2robzqS2JGm5eXT5HNgfHfHgklrPfr5XIJHFwBFW3H2A8nK6oylzhoxstw5n8zMScsFflNYatCskeLo6CPjoMtuEUjUaSsyRlmwEBr/bfb7x/jzeU/tcUX/G0hNCWHg3xUIc410XxVa0o21WIYfmiisC9CStPukw6M2OehAPF9Zj/34lsSNuIviPvK+VGpcXYhFvH88DcZKoOyPbi7uQdiTbBcUi366eWnKd6JDWm1jBRoDNrnIRlk+zk7/s5cFBCS1mN4Ka1F6WjlyCa7KPW3fhltRkvEjbdRJcGTdhha9Xwns+x+mowD2sOOpK7QBH3vTnCY5ZdztdF9JDpFIhFwLokxnaNrlJk3Gd2xv5OHMh7HXUSCBRB9hoQOlaOKbS1wkr7Ce1bJbLtS9Hwj/W5fgerCUKLushlLHuWYbFL0eGauJgFsO1246fMtL5EXh2ANQHtiKA5yFsa17gG7O+RMQSQPD5SHXppzJwhTfyBC/if2O/UbuGrA+A6zkPQhRZPoTiupvrYmmZp0GpqkcBlQxHo5X/LhUeKt2HtJZBgnAKMOh1lw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 11, 2026 at 6:18 AM EST, Mike Rapoport wrote:
> Hi,
>
>> To allow LUO sessions to be frozen and committed into the outgoing KHO
>> subtree from userspace ahead of reboot, kho_block needs to support
>> publishing entries one by one into a live serialized block chain while
>> new blocks may still be preallocated or shrunk for uncommitted sessions.
>>=20
>> Currently, kho_block assumes outgoing block sets are populated in a
>> single batch during reboot() before the chain is exposed: preallocated
>> blocks are linked onto the chain immediately even while empty
>> (ser->count =3D=3D 0), and reserving a slot increments ser->count before=
 the
>> entry is populated.
>>=20
>> Address this by keeping preallocated outgoing blocks unlinked in
>> kho_block_add(), linking blocks lazily only as entries are written. Add
>> kho_block_set_it_append() to copy each entry into its slot before
>> publishing the updated ser->count and next-block link via
>> smp_store_release(), paired with smp_load_acquire() in
>> kho_block_set_it_read_entry().
>>=20
>> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>> ---
>>  include/linux/kho_block.h     |  1 +
>>  kernel/liveupdate/kho_block.c | 86 +++++++++++++++++++++++++++++++----
>>  2 files changed, 77 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
>> index 93a7cc2be5f51..a9e696ef3e08e 100644
>> --- a/include/linux/kho_block.h
>> +++ b/include/linux/kho_block.h
>> @@ -100,6 +100,7 @@ static inline bool kho_block_set_is_empty(struct kho=
_block_set *bs)
>> =20
>>  void kho_block_set_it_init(struct kho_block_set_it *it, struct kho_bloc=
k_set *bs);
>>  void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it);
>> +void *kho_block_set_it_append(struct kho_block_set_it *it, const void *=
src);
>>  void *kho_block_set_it_read_entry(struct kho_block_set_it *it);
>>  void *kho_block_set_it_prev(struct kho_block_set_it *it);
>> =20
>> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block=
.c
>> index 0d2a342ef4228..2813c6fd593c4 100644
>> --- a/kernel/liveupdate/kho_block.c
>> +++ b/kernel/liveupdate/kho_block.c
>> @@ -16,6 +16,12 @@
>>   * array of serialized entries. Multiple blocks are linked together via=
 a
>>   * physical pointer in the header, forming a linked list that can be ea=
sily
>>   * traversed in both the current and the next kernel.
>> + *
>> + * Outgoing blocks preallocated via kho_block_set_grow() remain unlinke=
d until
>> + * entries are written into them. Callers publishing entries incrementa=
lly into
>> + * a live KHO subtree can use kho_block_set_it_append(), which populate=
s each
>> + * entry before exposing the updated block count or next-block link via
>> + * release-store ordering.
>
>
>>   */
>> =20
>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> @@ -93,9 +99,7 @@ static int kho_block_add(struct kho_block_set *bs,
>>  	list_add_tail(&block->list, &bs->blocks);
>>  	bs->nblocks++;
>> =20
>> -	if (last)
>> -		last->ser->next =3D virt_to_phys(ser);
>> -	else
>> +	if (!last)
>>  		bs->head_pa =3D virt_to_phys(ser);
>
>
>> =20
>>  	return 0;
>> @@ -129,14 +133,15 @@ static void kho_block_set_shrink_one(struct kho_bl=
ock_set *bs)
>>  	last =3D list_last_entry(&bs->blocks, struct kho_block, list);
>>  	list_del(&last->list);
>>  	bs->nblocks--;
>> -	kho_block_free_ser(bs, last->ser);
>> -	kfree(last);
>> =20
>>  	new_last =3D list_last_entry_or_null(&bs->blocks, struct kho_block, li=
st);
>>  	if (new_last)
>> -		new_last->ser->next =3D 0;
>> +		WRITE_ONCE(new_last->ser->next, 0);
>
> Why this is needed? Docs explicitly state that "Synchronization and
> locking are the responsibility of the caller".

This was done as prep for the kho-ro changes: when an uncommitted=20
session closes and shrinks an unused trailing block, new_last may=20
already be published and read concurrently via kho-ro. I will move it=20
into a separate patch in the kho-ro series to clearly explain the=20
intent.

>
>>  	else
>>  		bs->head_pa =3D 0;
>> +
>> +	kho_block_free_ser(bs, last->ser);
>> +	kfree(last);
>
> This change seems unnecessary.

Leftover from the earlier pop support (unlinking last->ser before=20
unpreserving/freeing it). Will drop this change in v6 as well; I have=20
since simplified the logic so adding to KHO is always a one-way trip.

>>  }
>> =20
>>  /**
>> @@ -144,9 +149,9 @@ static void kho_block_set_shrink_one(struct kho_bloc=
k_set *bs)
>>   * @bs:    The block set.
>>   * @count: The target number of valid entries to accommodate.
>>   *
>> - * Dynamically preallocates and links preserved memory blocks if the ta=
rget
>> - * entry count exceeds the current total capacity of the set, ensuring =
they
>> - * are available during serialization/deserialization.
>> + * Dynamically preallocates preserved memory blocks if the target entry=
 count
>> + * exceeds the current total capacity of the set, ensuring they are ava=
ilable
>> + * during serialization/deserialization.
>>   *
>>   * Context: Caller must hold a lock protecting the block set.
>>   * Return: 0 on success, or a negative errno on failure.
>> @@ -318,6 +323,7 @@ void kho_block_set_clear(struct kho_block_set *bs)
>>  	struct kho_block *block;
>> =20
>>  	list_for_each_entry(block, &bs->blocks, list) {
>> +		block->ser->next =3D 0;
>>  		block->ser->count =3D 0;
>>  		memset(block->ser + 1, 0, KHO_BLOCK_SIZE - sizeof(*block->ser));
>>  	}
>> @@ -348,6 +354,7 @@ void kho_block_set_it_init(struct kho_block_set_it *=
it, struct kho_block_set *bs
>>   */
>>  void *kho_block_set_it_reserve_entry(struct kho_block_set_it *it)
>>  {
>> +	struct kho_block *prev =3D NULL;
>>  	void *entry;
>> =20
>>  	if (!it->block)
>> @@ -356,15 +363,73 @@ void *kho_block_set_it_reserve_entry(struct kho_bl=
ock_set_it *it)
>>  	if (it->i =3D=3D it->bs->count_per_block) {
>>  		if (list_is_last(&it->block->list, &it->bs->blocks))
>>  			return NULL;
>> +		prev =3D it->block;
>>  		it->block =3D list_next_entry(it->block, list);
>>  		it->i =3D 0;
>>  	}
>> =20
>> +	if (!it->i)
>> +		it->block->ser->next =3D 0;
>> +
>>  	entry =3D kho_block_entry(it, it->i++);
>>  	it->block->ser->count =3D it->i;
>> +	if (prev)
>> +		prev->ser->next =3D virt_to_phys(it->block->ser);
>
> kernel-doc should mention that this function now links blocks.
>
> And I believe there should be a paragraph about the new flow in the DOC:
> section.

+1, I will update the kernel-doc.

>
>> +
>>  	return entry;
>>  }
>> =20
>> +/**
>> + * kho_block_set_it_append - Write and publish an entry at the next slo=
t.
>> + * @it:  The block iterator.
>> + * @src: Entry data of size @it->bs->entry_size to copy into the slot.
>> + *
>> + * Copies @src into the next available slot before updating the block's=
 entry
>> + * count or linking a newly occupied block to the previous block, so co=
ncurrent
>> + * readers never observe an uninitialized slot or an empty block.
>> + *
>> + * Return: A pointer to the written entry slot, or NULL if the block se=
t's
>> + * capacity is fully exhausted.
>> + */
>> +void *kho_block_set_it_append(struct kho_block_set_it *it, const void *=
src)
>> +{
>> +	struct kho_block *prev =3D NULL;
>> +	void *dst;
>> +
>> +	if (!it->block)
>> +		return NULL;
>> +
>> +	if (it->i =3D=3D it->bs->count_per_block) {
>> +		if (list_is_last(&it->block->list, &it->bs->blocks))
>> +			return NULL;
>> +		prev =3D it->block;
>> +		it->block =3D list_next_entry(it->block, list);
>> +		it->i =3D 0;
>> +	}
>> +
>> +	if (!it->i)
>> +		WRITE_ONCE(it->block->ser->next, 0);
>> +
>> +	dst =3D kho_block_entry(it, it->i++);
>> +	memcpy(dst, src, it->bs->entry_size);
>> +
>> +	/*
>> +	 * Ensure the serialized entry is visible before exposing the
>> +	 * incremented count to concurrent readers.
>> +	 */
>> +	smp_store_release(&it->block->ser->count, it->i);
>> +	if (prev) {
>> +		/*
>> +		 * Ensure the new block's first entry and header are visible
>> +		 * before linking prev->ser->next for concurrent readers.
>> +		 */
>> +		smp_store_release(&prev->ser->next,
>> +				  virt_to_phys(it->block->ser));
>
> Until now the locking model was "the caller is responsible to hold a
> lock".
>
> Using WRITE_ONCE() and smp_store_release() instead of plain assignments
> implies that it is not anymore, or at least not always.
>
> This should be a well documented separate change.

Agreed. I wrote this patch as preparation for both early freeze and=20
kho-ro: mutations to struct kho_block_set itself still require caller=20
locking, while the WRITE_ONCE() and release/acquire ordering allow a=20
concurrent kho-ro reader to walk the live serialized physical block=20
chain while the host continues committing entries under its lock.

In v6, I will remove the kho-ro parts, and submit them together with the=20
next iteration of that series.

--=20
Pasha


