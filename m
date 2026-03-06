Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D51AEFCB61C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B796B00B5; Fri,  6 Mar 2026 11:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9126B00BD; Fri,  6 Mar 2026 11:19:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBB66B00BE; Fri,  6 Mar 2026 11:19:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F04F56B00B5
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:19:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92F5AC2368
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:19:50 +0000 (UTC)
X-FDA: 84516149340.15.5D1E300
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id A79C4C0009
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:19:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jc6o3lQb;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfl45dSj6u6b1uTEm79PLyjl61gJFmtiEwVDJ745b4E=;
	b=QTnEiSm++ikG7MsJtxCOM+1FPaxTH5Rw48z86iW5HC04E4xl7sx6fE6f7Bi53COPGP2f1j
	v/DFXKLyOubZbzM8TJCGyAkeE61fRwYlVFH8/0Hau+ou0jEXN3J/NaMLFaQC5iZ27pvndZ
	9Go8111NuhC7GVtVy2DpOnUQwAuFW44=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813988; a=rsa-sha256;
	cv=none;
	b=sWKdVocCqbU6gVf5YC7F8eXCFmMfwNnG7xXo8iBlua/acwnu4IpgOFtmHVOObJ0Sb2IVFj
	Br/KnF1j0LAD9Gx9VgSUb/nAI3BDdudDgjoeb2DTyk/xkbMLkPjvZhxrc2cPWZeng5r9lP
	9Vg7zCcxrXii8O88VC+5eKovBQM2Y44=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jc6o3lQb;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <bdeb9147-0fe0-42a5-944c-4c2cfffd85d8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772813987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rfl45dSj6u6b1uTEm79PLyjl61gJFmtiEwVDJ745b4E=;
	b=Jc6o3lQbGwLczRe8uFLm30vRrYb7lxgmz+kSvflDAzVVSm5SwcDalU/rFLxY4tkcDrlnWU
	nXyldCwgaby7uujeFolu9k6GgjyRUtqvYbMC/OXs+1o5C29cXln4EweScov/8VoTmOy8rb
	e9jPyLZth/a0Yhm4YVnvVKZ/RC4IaL4=
Date: Fri, 6 Mar 2026 19:19:38 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] mm: migrate: requeue destination folio on deferred split
 queue
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260306133556.2051251-1-usama.arif@linux.dev>
 <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
 <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
 <aar740E8K7SOy1qJ@casper.infradead.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aar740E8K7SOy1qJ@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A79C4C0009
X-Stat-Signature: whcsiih5sq3ed45e4pf95qux6ujink5y
X-Rspam-User: 
X-HE-Tag: 1772813988-720354
X-HE-Meta: U2FsdGVkX1/R/R+F9q+HnyLHGCscIHRFhARYHMAcuOFfdAPhkrBG8SYyn0INDKh0GHj5+TcDprZsSwrDrbeDy+R0tuF6lAtrAmhqEjvuoVgqiBvUjpi8Af5I98COJmz/Qt0yOJD8o3wggWoFPbXGmfwIRsvAePWWWCS0iywIMJydeD72ipuLgqa8iadlHkTLf+uY/iYtZvhhI82Rh/ljBIP8+JNr3Qt/r8rJdIIqkrUiNipPbzLB3lQxvX1+whQDJgALBEi469+mmEarXRAAMjT91d5nk8zGUWrJA1KIZYnOmzyj3IwoZTnZVuOrOD3rZ7AR3NUAn1h9AElRFk0y8katkoAUMyY9VG4f/J000sIXTH84ZspoAsrF2XLX0KVkCFMVP5uPksPKE09ymK95j0xrbJODj+4j/M838CDwnzUzM6biRH0l/U7EVrO3G7N43r7MQeZ7ELjWAgB1ePy0lV7mSqSETTbTThOualxDzhZ7vpzUiI8G0q4h7Q2ESO9NxZ0p17z0ojdtoVthRPWGLlhmAD18aB6kB3vCHtuU6VVtRQT7pOFb7renLN8XppQW29gLEmlDdAJdthwSI4B/7wInWOfnYbjyo5bA8DUWCz6OV7coXPJy0JfWjvwTDARxHoWeqGWFlEmUqq4GjW3L0eevS7kAJJfkpEk8tZjiBBu418BUwFR9tnmB+qttpKI7fwyXnIK/eUycTxbyFleKeocHEory3T4RFJNcoUF83CDB2+rtuvc1RGgfr68AAL7CxB3t0m0KiaUIrcyJananfecs4ExoB9/hDUUqgWMQ59+4ojlVV6F0IkseQlF/4uiLGGP4II3Tm8s0+ZsaTPJxMPyr2baUIdOJU+LN+LjHJ3yHqF5d43npekFAbSLNt3GdtgXlMVLJS/96+lsjcAFnTOePgv0v0GvENA6aCA7usyk7Ifjm40O38abEQ5ZX10l6EmfqM1wXgGV6x/+e4oG
 43ZZQVfr
 Za8HgwRtAHmF//9id0zmsNbVzXowEcKR7K0CZ4fHKqH8waY1m3RSS2Ub1MdSA3yE8PUtvKjdh9KKxNwmEl9g4b8BKGmOJpmXdPZ6EPTwhm51wj55rqu+pgSP+TVsc/yXWjF9w85yhYcGxZ694gmx+ttIIPnaiGxou5wAKkSUkHbYktGQk/uMNauci/csRMhSwYnQgKH7k5/gxHTUELM1gcOpNJG6hrJe+K59GWl/4tAmTxZO6SzN/nnh39Dq40sodFea+FsadbtmdWpmC/6KEgMDuaN9HTji/Xuw5wiNv8d7m6u8zKRac6RukFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/03/2026 16:08, Matthew Wilcox wrote:
> On Fri, Mar 06, 2026 at 05:12:38PM +0300, Usama Arif wrote:
>> +       /*
>> +        * Record whether the source folio is on the deferred split queue
>> +        * before move_to_new_folio(), which unqueues it via
>> +        * __folio_migrate_mapping().
>> +        */
>> +       if (folio_test_large(src) && folio_test_large_rmappable(src) &&
>> +           !data_race(list_empty(&src->_deferred_list)))
> 
> Why do you need data_race() here?  list_empty() contains a READ_ONCE()
> so shouldn't be necessary?

Ah mainly because we dont acquire split_queue_lock before accessing,
similar to what we do in folio_unqueue_deferred_split().

> 
>> +               old_page_state |= PAGE_WAS_ON_DEFERRED_SPLIT;
> 
> You've done a great job of the naming.  So much so that the comment
> seems entirely unnecessary?
> 
>> +       /*
>> +        * Requeue the destination folio on the deferred split queue if
>> +        * the source was on the queue.  The source is unqueued in
>> +        * __folio_migrate_mapping(), so we record and check the state
>> +        * from before move_to_new_folio().
>> +        */
>> +       if (old_page_state & PAGE_WAS_ON_DEFERRED_SPLIT)
>> +               deferred_split_folio(dst, false);
> 
> Again, I'm not sure the comment says anything that the code doesn't?

Yeah there is a much simpler version in reply to Zi's review in [1].
I found the whole migrate_folio_move() function quite verbose already,
was keeping up with the theme of that function lol. I will see if I can
cut down on the comment in [1] as well. Thanks!

[1] https://lore.kernel.org/all/28e48b47-f215-4e4a-b55a-01dbf293ff35@linux.dev/


