Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E42CD6E6B
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 07:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8996B0005; Fri,  5 Jun 2026 03:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989A36B0088; Fri,  5 Jun 2026 03:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F726B008A; Fri,  5 Jun 2026 03:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D88A6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 03:44:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E2BD1C28DC
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:44:06 +0000 (UTC)
X-FDA: 84845070492.01.27728DD
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 16BAE80006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:44:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VewviDzU;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780645444;
	b=Niun+c49fgA/IcXwj5w2fc8o/Cf10OOi6zMa/Ya5e4rJ9S8x9SwcaUUk3Y3u54ebNsbwOj
	LOgW7M7jBvcbipsGth+0fR3HpOX/o63W1NKkYwl8IXXTTbnJVa2glYh+woYijnHThN2+DP
	/GnNbrjJasSmjwM06h2arKS59YRKNlY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VewviDzU;
	spf=pass (imf02.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780645444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcvkWMpmE6Q9kfSZCHeUxEPneHRTmz74/VUa7WoySEs=;
	b=5PzVsa2Lj8mS79T6sKNworTzd/9MbPtiYeuMyfTIo17/yCfY7DB+yr0M3UrpIiXyelnUOq
	gfokRolZXjbvuI9uOrtQR1ZNHJYfGCEBmX4Y0e5ctFBZQAGil1bkDb2dhuRtd/ZvuISqwk
	5qniAZWN4vHkPLMkXFcbZaHHthqA1PY=
Message-ID: <d4eff260-1e11-47f4-84cf-80cfa6d45d2b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780645442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LcvkWMpmE6Q9kfSZCHeUxEPneHRTmz74/VUa7WoySEs=;
	b=VewviDzUK829S+czYkrUZ7Gl5kGSvSPmBmYVZ2BOP7CLmh6y1ESmDqejJIOgHhMyDZDVOI
	Cf2ZK1I2MiHMBwQp/jRlQN5mRmdfAh1WOKvqhcQ/6RWgpwz41L8/w3uhbekou/RTUyyYin
	5ToKtZeVG1t6lqiOymDzZT1s5WOZdok=
Date: Fri, 5 Jun 2026 15:43:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] alloc_tag: fix use-after-free in /proc/allocinfo after
 module unload
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260604065938.105991-1-hao.ge@linux.dev>
 <CAJuCfpFBcnS8thEbKnd74xTyuKd6qaOKk8+sogC17yL2XE0THA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpFBcnS8thEbKnd74xTyuKd6qaOKk8+sogC17yL2XE0THA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16BAE80006
X-Rspam-User: 
X-Stat-Signature: z3iu6c9b58hnp786or9earnw4oh6pkdz
X-HE-Tag: 1780645443-546970
X-HE-Meta: U2FsdGVkX19CvN7CpbIDul6PnPgq+1remJTkcecjQwuvUri0rW3VlGiQzBXAsW8con1rJq2iDE9Lu7L7sOx8bEXfL8na/Cgnv8cc93kk6scySuDKg7t7iJYVE2m2xyzIzEtilvScgjX9xEHk1rNiUX2PGxquTN7rbtzYOnsHhyXz4f08MI0YS8Y5TLLxx9jT9v0iS8U6SGP7whD4cSnGZQfJoFqDF86PYKKrjY8ouR7wz/aAlFZ6fRyJjdSKqtwum2RC7weeMN4blMvplDcDz7sca1Au9vZbCmw716hEAA56AuUm06OJJYFxl1osugt99dY78JNIsIOYV+fkp8Kiyn9ZkBFqhRN3Q3/Yo+nV3kuEYQfHbvQsm/pVfbLcdM03hfI4Pfrep/fFDAqhZ3TmcIteIc1oxJ15l2KILn9ugHxoVQ3QI3eSLMPVMd/ZIDdPMs3ztzVjgX4EmbiSFacK1pADmKqSaz8yrjSM26Z/9BrdsgMu+3RQOsCjbFUS28mB6eZw5YbcO1JPUAoMoxfkOyAluXwFatWHwk8wh3ZmE6RG9Prl5BQQ4aqHeTEBN++EKsTGm7UXUsGFM9U6KE26Bdmhz9FYhPWuQREDVvCjqR7mNVWQLErEV2mL1Tm3fqM/0RaWqmZfaBx4r0QTSNHWhn64GdjrxHAlVqtwuUr0p83cGcMhTDKbqi7gqIKAVfGj+mioxkQoGoj+kyKMwEn2/XnkhiBoZ9FKXu16I7+eK6RhZznT5WmzlxMjYmDRRDr677NSIUPgOFnF00SFmwh/ByBV2n1xUdfiPH4O+5lp2p670Kd6hJI8xbiTGQtO7b486XHNP3Mtuf3l2L2NuaUT39NuLzkRDDLoruqhO484rXDllyxd7wlF1yQDm18MysAwbjGfENXJ9pnAKfC0C22zgA4z0kDlLR3ir4h7X7rMy3mT4TtSDbQxF+hwYkp/f/axWPgXbUe3VpfLTdLYaa/
 Kmj6TaYN
 5FsWWFNSfti+G5zF1NGE7AiJkFgnCo9dAKtDuxgcD16EDSVThF8vSRRrJlM+iYoys9HNHR6TzZnTn2bMcXbGcEjb1pwvK7oIKNfbjKGvPuyc8wV3CNHO7nDb3kLHVSDXra7mvln1FFqxNtHx/mWR5hWL+h7pSlikOO+LOsQ8cdBBtGwEPGbe/lFPyH8jrSH5MXDOVPC9RRJtrG/uWEo9XNaNc/e3NwLHHquDLvCL2A8ivsmOaJF3zbWWU87nqKVWiUFNBVyAEMsuvs2r82713Vqd810pZDGXzxnrpcC9T1OBUd4T1DcB/5R4pt9GlnPxCrhbnSKhVvYARh+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2026/6/5 03:24, Suren Baghdasaryan wrote:
> On Thu, Jun 4, 2026 at 12:00 AM Hao Ge <hao.ge@linux.dev> wrote:
>> allocinfo_start() only reinitializes the codetag iterator at position 0.
>> For subsequent reads (position > 0), it reuses cached iterator state from
>> the previous batch.  allocinfo_stop() drops mod_lock between read batches,
>> which allows module unload to complete and free the module memory that the
>> cached iterator still references:
>>
>>    CPU0 (read)                        CPU1 (rmmod)
>>    ----                               ----
>>    allocinfo_start(pos=0)
>>      down_read(mod_lock)
>>      allocinfo_show()
>>      ...
>>    allocinfo_stop()
>>      up_read(mod_lock)
>>                                       codetag_unload_module()
>>                                         kfree(cmod)
>>                                         release_module_tags()
>>                                       ...
>>                                       free_mod_mem()
>>    allocinfo_start(pos=N)
>>      down_read(mod_lock)
>>      // reuses cached iter, skips re-init
>>    allocinfo_show()
>>      ct->filename   <-- UAF
>>
>> After free_mod_mem() frees the module's .rodata, allocinfo_show()
>> dereferences ct->filename, ct->function which point there.
>>
>> Save the iterator state in allocinfo_next() and resume from it in
>> allocinfo_start() with codetag_next_ct(), which detects module removal
>> via idr_find() returning NULL and skips to the next module.
>>
>> Fixes: 9f44df50fee4 ("alloc_tag: keep codetag iterator active between read()")
>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> Acked-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks!
>
>> ---
>> v2:
>> - save the iterator state in allocinfo_next() and resume from it in
>>    allocinfo_start() with codetag_next_ct(), which detects module removal
>>    via idr_find() returning NULL and skips to the next module (Suggested
>>    by Suren).
>>    v1 link: https://lore.kernel.org/all/20260525072117.112779-1-hao.ge@linux.dev/
>> ---
>>   lib/alloc_tag.c | 9 +++++++--
>>   1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>> index f2f574bcf383..551cc14bb1fd 100644
>> --- a/lib/alloc_tag.c
>> +++ b/lib/alloc_tag.c
>> @@ -45,6 +45,7 @@ int alloc_tag_ref_offs;
>>
>>   struct allocinfo_private {
>>          struct codetag_iterator iter;
>> +       struct codetag_iterator reported_iter;
> nit: I would call it maybe prev_iter since it's not yet reported (you
> store it in the allocinfo_next(), not in allocinfo_show()) but that's
> a minor detail.
I see...
>>          bool print_header;
>>   };
>>
>> @@ -58,16 +59,20 @@ static void *allocinfo_start(struct seq_file *m, loff_t *pos)
>>          if (node == 0) {
>>                  priv->print_header = true;
>>                  priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
>> -               codetag_next_ct(&priv->iter);
>> +       } else {
>> +               priv->iter = priv->reported_iter;
>>          }
>> +       codetag_next_ct(&priv->iter);
>>          return priv->iter.ct ? priv : NULL;
>>   }
>>
>>   static void *allocinfo_next(struct seq_file *m, void *arg, loff_t *pos)
>>   {
>>          struct allocinfo_private *priv = (struct allocinfo_private *)arg;
>> -       struct codetag *ct = codetag_next_ct(&priv->iter);
>> +       struct codetag *ct;
>>
>> +       priv->reported_iter = priv->iter;
>> +       ct = codetag_next_ct(&priv->iter);

AFAIK, in the seq_file call flow (start -> show -> next -> show -> next 
-> ...):

start(0): iter = get_ct_iter(); next_ct() -> iter.ct = A

show():   dump entry with iter.ct = A

next():   reported_iter = iter(A); next_ct() -> iter.ct = B

show():   dump entry with iter.ct = B

next():   reported_iter = iter(B); next_ct() -> iter.ct = C

show():   dump entry with iter.ct = C

The same holds for the overflow case in the Fill loop:

next():   reported_iter = iter(C); next_ct() -> iter.ct = D

show():   overflow, output rolled back, break

stop()

on the next read:

start():  iter = reported_iter(C); next_ct() -> iter.ct = D

show():   dump entry with iter.ct = D

So reported_iter always points to the last element that has been

shown to the user.

I'm fine with prev_iter as well,  What do you think?


Thanks

Best Regards

Hao


>>          (*pos)++;
>>          if (!ct)
>>                  return NULL;
>> --
>> 2.25.1
>>

