Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921E7C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DE36B0089; Fri, 25 Jul 2025 04:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E056B008A; Fri, 25 Jul 2025 04:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F286B008C; Fri, 25 Jul 2025 04:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D073F6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:26:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40AE411394D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:26:43 +0000 (UTC)
X-FDA: 83702105886.27.25C401D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id DEDB418000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:26:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H1eNZ77N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9YHNMFF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H1eNZ77N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9YHNMFF;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753432001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zXZqF93QlM7fvQgmaIDTxVZ7v4AegbzGaTVx0Ma0Afw=;
	b=glUMkKs2PKm0HEvKtbb7/PbkOLDyp0k2KqRGuPKdI10IOwkxiNZ0KtVgj6YXpb+4x/t/YS
	q2/O1eCj+n09mDHWAW1zWbJQzG0mzYBwAU8lN3Vm7LTdTFFulD1kWv5rIZMuBIPTCeEKGJ
	KEWbe5RQQB05QS86nmSPOXTLCtPnYR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753432001; a=rsa-sha256;
	cv=none;
	b=fGajuUH1NWALmtve+/eTWhko+eTWwL8o65NOzgSS7ab5aHS8EJx7uK9Qi9oGfLRF/J2sIc
	3zuwmv22HYveFbQoi6eIiyLSYBcjxd8XCKP7oAq0xJyyIqSabX3oboVbFjRK/gPFoOoXbN
	SOTarThLxUCvQwiZK/+6WxPDc8ytYzc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H1eNZ77N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9YHNMFF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H1eNZ77N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9YHNMFF;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 048921F387;
	Fri, 25 Jul 2025 08:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753431999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXZqF93QlM7fvQgmaIDTxVZ7v4AegbzGaTVx0Ma0Afw=;
	b=H1eNZ77NmMyDq3tiTznajEsmBs2dpgU/LSlXu7FnWi8+2Zgb1FSa9PlODRPteL6+OVTy0Q
	xQIfR8CSo9wjzoxndU8nKC8Clp8Ib3uv50xP6B2U9ulzP1bJFl8dfGx29YhbUqa5T/wrT7
	6+TxsPl5+drGXIjhlSjJbSjVLOIYPiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753431999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXZqF93QlM7fvQgmaIDTxVZ7v4AegbzGaTVx0Ma0Afw=;
	b=b9YHNMFFjfzNuCDmJa0JsbmueKP7D2A4Aq0Blj85pakW7GcJP9FQILumjnX32gBdNYJ1d7
	jqBE4zJZGsNUmKBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753431999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXZqF93QlM7fvQgmaIDTxVZ7v4AegbzGaTVx0Ma0Afw=;
	b=H1eNZ77NmMyDq3tiTznajEsmBs2dpgU/LSlXu7FnWi8+2Zgb1FSa9PlODRPteL6+OVTy0Q
	xQIfR8CSo9wjzoxndU8nKC8Clp8Ib3uv50xP6B2U9ulzP1bJFl8dfGx29YhbUqa5T/wrT7
	6+TxsPl5+drGXIjhlSjJbSjVLOIYPiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753431999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zXZqF93QlM7fvQgmaIDTxVZ7v4AegbzGaTVx0Ma0Afw=;
	b=b9YHNMFFjfzNuCDmJa0JsbmueKP7D2A4Aq0Blj85pakW7GcJP9FQILumjnX32gBdNYJ1d7
	jqBE4zJZGsNUmKBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEB3E1373A;
	Fri, 25 Jul 2025 08:26:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cQYRNr4/g2g3XQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 25 Jul 2025 08:26:38 +0000
Message-ID: <379d3d5c-b730-4a5d-9c71-d34d23472621@suse.cz>
Date: Fri, 25 Jul 2025 10:26:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 0/4] support large align and nid in Rust allocators
Content-Language: en-US
To: Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
 Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org,
 bpf@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
 <20250724135449.2cb6457b90926cce1b903481@linux-foundation.org>
 <CAH5fLgjatYenX_xPvRW11BnRw1wP_G19eY-7AqUctnuZ3rGBYA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAH5fLgjatYenX_xPvRW11BnRw1wP_G19eY-7AqUctnuZ3rGBYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DEDB418000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ntb6y1a7nwrcn1aownzg1swbh5ed8bma
X-HE-Tag: 1753432000-879928
X-HE-Meta: U2FsdGVkX1+8aQpOcLQA26hG1flvSK0uatLs0gv3aespRosomoHjD4bf16kpWUVdMDQ0Xoa04SQAkfZ+0bv4lvdXATTieNU9DPYo/BsobXD35RWvhVtZ3dNxNqHi/56U6UXoF8lmgF7lbutZOlhj7y+rCKQqJBkMnJswUrRsmtxFlibofxOwxVGuVS5Fomyeo9vunSc3FbcsSZCtxM8CzCm2ulIoHA+an3hgc3PAAPDH9BXRy2J1RRfhmBb6Z3xsYwKVzUoqPhHMT6H/A2acAabEt30gMQeGCwYF9DbctnVwE1Pm6iwWPbntlYv5TuFFXkaGtlRe4OSixm6m0jb8nxcnk9EfCE3b0AFkf5hzhBd9wExUFu+/FHf0mj46wj5iY3xkZ+xjuAZ6HHHbkaY90elBYicpmXZI5+7lhC+3p7GvHAO6skMPDTgMpAbqr5nwwv+WgkJZ1W+sOcDI5AaDo+Op53unbcTxhgsXeRd0tk+CzAxxwMDQfV6/7jvxGWuy+lVQ+SXRrE5RmlJGRXvoAWoz58JlxNoyEMa9gqoRY17J3JcjYZv2jG3wZajqcw3wktVDrSqLC/Oglahsn/rg/MB4ir5ouOzoraUmF6Q0kyR8EbefF/Q/OJRRVty7tsRNAk5WLTVbm5KG0Cnr7BilCgDJWmtJl5Yhm63fx10okHNIPFiPjatkvtBS5iIpe7gCNjJqLgB+tN285aOPEjaBtpb9JNHqJjvwrbJ7DEHe/Vk2I4w1/tRDUERoL2IhFdAr8cgxyScvbP/EzRDX1NJHTlZTIASrAZly4wS8FESp5+fEC02YMGEfR1MgpFsXDaCS2sO/MMpt1N918XRFDq+oUg0rGSOt8sKKo2+5kaZ/v1IB5eBSxazfssvMk6bIhdcYTaR0OXkckVUOFY65k6Xu4LmGztcEz+7A9tlRteN+vySxlplCZE/1YzwPrzyirp7301DcK8sesoGnJ8W4tGa
 GUfFf2mc
 X1bEHRfI9GnRATe6VvZ8ErsXxWRDS7uxUgvl5GQzGAhAY99GE3oHeyIm3tXkxtWmdp6qIo3+iGHZsxKFE/5c53euLEb5hbJcbfznCYxjFr8Y7S0cjS/Wvndm7D42n3RdB8g5o5LePQpdk8zwZ2d4o9IE0FNi+K0M2ZsfekDwKM1Jf/amb70WBERAR8JQeHU5Jd8n/6MamfiDZff+Alc29WqM0I4NPuACGbrLE5AeFzvQf3Wj1tlVwC8ZPecelNTvt9qzBw8CmlIMoTwXs3/jb5oW8pnSxpU6/kh9LiVZ6JT5GynMp69t8ZkRSD/2cfwgyVWlZjdgTBVuuDBq2oWh1HFgbuGZQTUIWMcXUj37kHXIXEpi5OAXVm/4G/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/25/25 09:14, Alice Ryhl wrote:
> On Thu, Jul 24, 2025 at 10:54 PM Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>
>> On Tue, 15 Jul 2025 15:56:45 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:
>>
>> > The coming patches provide the ability for Rust allocators to set
>> > NUMA node and large alignment.
>> >
>> > ...
>> >
>> >  fs/bcachefs/darray.c           |    2 -
>> >  fs/bcachefs/util.h             |    2 -
>> >  include/linux/bpfptr.h         |    2 -
>> >  include/linux/slab.h           |   39 ++++++++++++++++++++++---------------
>> >  include/linux/vmalloc.h        |   12 ++++++++---
>> >  lib/rhashtable.c               |    4 +--
>> >  mm/nommu.c                     |    3 +-
>> >  mm/slub.c                      |   64 +++++++++++++++++++++++++++++++++++++++++--------------------
>> >  mm/vmalloc.c                   |   29 ++++++++++++++++++++++-----
>> >  rust/helpers/slab.c            |   10 +++++----
>> >  rust/helpers/vmalloc.c         |    5 ++--
>> >  rust/kernel/alloc.rs           |   54 ++++++++++++++++++++++++++++++++++++++++++++++-----
>> >  rust/kernel/alloc/allocator.rs |   49 +++++++++++++++++++++-------------------------
>> >  rust/kernel/alloc/kbox.rs      |    4 +--
>> >  rust/kernel/alloc/kvec.rs      |   11 ++++++++--
>> >  15 files changed, 200 insertions(+), 90 deletions(-)
>>
>> I assume we're looking for a merge into mm.git?
>>
>> We're at -rc7 so let's target 6.17.  Please resend around the end of
>> the upcoming merge window?
> 
> I think it would make sense for this to land through mm.git, so yes
> that sounds like a good plan.

Ack.

> Alice


