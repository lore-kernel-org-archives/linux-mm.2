Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08347C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194186B0098; Fri, 11 Sep 2026 10:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11F306B0099; Fri, 11 Sep 2026 10:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D106B009B; Fri, 11 Sep 2026 10:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B992B6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:58:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E1CFC0292
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:58:09 +0000 (UTC)
X-FDA: 85201786698.25.49C432C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F0B71A000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:58:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fqQr8piC;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789138687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kzqbt4ZRRllUtqOm4M2xLyawNqCHTN1qUIQJ4avLvE=;
	b=XhxvrsOUNYwvdGKRmNs/ptNww4F/o15ZiCb92Kjn86ilYL6Qr/S4cgCUQaSZkeha2aqMl1
	JlrI06lygYOdy865GFBkIe9URY+1yzQkErDtyE8eWufLbn6AEmOvqFI7lxSY2MutJyZJTw
	mAYEckI5SCaE2nbXMD6cjLXF6CUCaXM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789138687;
	b=2Qql9eXRn2BnMRgsTfeDHFLpaecvinymQxhwd1pKwquKkZKfftK8snGPIrRqmz4Ng/X9lg
	4DyqBqFyIT+NX/1UEDmrOax/beNwmX+HH4cH59Z8VNgsIOS0yBr8RRdzeGJcp4BsEt1FlO
	OaCgfVmtMvpxPde2h1cNJ4f+VVgijtE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fqQr8piC;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A528543F99;
	Fri, 11 Sep 2026 14:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08671F0089A;
	Fri, 11 Sep 2026 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138685;
	bh=9kzqbt4ZRRllUtqOm4M2xLyawNqCHTN1qUIQJ4avLvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fqQr8piCsl3GNslha/u2I8VaiGLQ4meIaSUM1Bj7ZRrr7BfqPFr5IS+c/2/OX7lwa
	 r3F+IRshot2hAk8el+GtORycJo2NDoBl16m44ZkRIMmVrFTv7PmeY6nKEHsKlRchIQ
	 AgUq6v/nVYfYgqRu34EJLIgJpLYAnMnPTOFaHuXhLmiqJEKE+896y0tNtb2Q7WfEU9
	 TX1EYy+Iz3KrGMrthh7WMZWxQ+h/Scp8g+Sx9H7djIvmTo9/EZwe6KnA59J3Hafylo
	 bZgpI8hyfbhghcKcbWVXw5nMvs7NZ4eahZ+bQKiMU1mK++VS2BG3uUlBOQpO/Wcq7X
	 BPnSG4YzBCv3A==
Message-ID: <88838d36-ea5b-4c76-b785-cf2bb71e34a5@kernel.org>
Date: Fri, 11 Sep 2026 16:57:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] proc/task_mmu: remove unnecessary helpers
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, willy@infradead.org, jannh@google.com,
 paulmck@kernel.org, pfalcato@suse.de, xueyuan.chen21@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Usama Arif <usama.arif@linux.dev>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-2-surenb@google.com>
 <008dcaa3-2068-46e5-9e58-afb590d90584@kernel.org>
 <CAJuCfpF5CBrCxZWm+Luopf2gq_hHxsbw0QptNhfRT=+KjyWbJQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpF5CBrCxZWm+Luopf2gq_hHxsbw0QptNhfRT=+KjyWbJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d98cmz8ghaqiwzupewzziaisujtfkzym
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F0B71A000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789138687-875326
X-HE-Meta: U2FsdGVkX1/YnGedAzLILtauu3YZq0rGWKUEv39bENyFRH9d/FJry0few5fs6YjOkUZ//TGBNZjRI+Gl799l8x3X0rCHKKjZXzDUlICuKDyZPgUKV3ZWmTmO9UsbX4m1bDg0qBj0MR9FHjokPb7Iriv/ombECMe7pkYJdXms2F4Q1MPk7DAK/ngiJm1OjQvGXAVmn12NkoJdgSK2ejWAhRXWud9068y+URmAbZDqLU+LLVRI76KjHlY9WJZg2njztimeQZVOu1NTTYKIiAY1yxV23BBDuVCTLv6uF+pCEFlo5m2ZeP6zrMGHDZYQAfhCuZm2ZqYHv0hL9ZafgLSRUFzgOMTFanl1XfY8yjBbx2JreM9GflMaQupz+MwxO/N2JJGMnVw37V9Di1DzVjT8SHIwHKqlAUfXXqxZin7brL8phepzjZvmKKCq2oBzuDhft2tmUxkV+YbdI59e706pjcUURWbE20YMwMgGkmKnbwdpKIAYqs42jZfEgyTBJkNqtmXKVNaLbEMXCmsTUC+5j+cE6Gb1KDhQL6viDpmClDx7Xh1XuAyR0v8/CPLWhae8JFW0MClwRc/sLN0GXArGIqOqmSEIfODlSEl/SMc7+pYI3uERnD/vy5xS6vhfqymY/TiR2FybFLQB/6SwOew2rz77fAZVk1C3lxjL9bSRhUR84rx0XKktqeDPA31bhI6RX6p6x3tIELs2SUo7Pk3MlnqmUT4W2najLf59GKpOMNMgsmW9orvu22TrdznCMCf2sFVUJF0ZbxybcSWNXnfzzJq/VJGnXI64Mz8L15p5ZHg0RaEYpKJW3m8QygdLs5fz1Qnuae2Ee8ff94WCoOLTykaCfGTqZ0SOQW4Jb0hbQj/YHIdXMTc3uy2FYGw3eaAmBN5qWnmlJ+Oy5KkNnfPY9U9mzR7yEd7T+lxFY5mH6T6pAf+CtWYlgN1YdR+CyD7NEZ6EPFB7RtSpsHYLvhL
 7ejCF/PX
 PGmLx51bjZ5NTrcgPix23rnldZ8ewb0DNfHGIw/lA2swfxH+BPCN6oSmA9ulV52UHKO9AvrX/OdL0zSU55GLlpluHokr2VcS/88llItRkNj71Tca1T19Ac0yD0imQPgr9H31EL0AP5nfDE+VSP67AiJQJRjrww/ui2+krZf6Iahjl4N3hozOykgjE5iJYC1sxgGW+e9hWHN7FgTSRMzHBYGB1ODQFPlvoYHWZAhicT2RgCo9V+gXHYqGMlCg3tt1oPr+71mz41+TsQIMojw4RJjznk5b9E6c8yZfLP/gptZqq5ljIGX2J3ddD5y2olG39BVOSEjHW31Wa3w3yVgaCSBS0Nu1hUqtHPhaNc2PNQ9IAUVRwibdJlJNR6xyLWG69QGPmmPyNX/YWITQarwJzTqBbrTZtX4iNyaLo/Uvse+sF4FRouT6/+Sv73kV8rR5+92U7KYoMiyvYS6ROs1i+kAnDJolRhc4OaWJifJ86d6yEqRrV3luYo+s+stetdg5PMkg0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 16:28, Suren Baghdasaryan wrote:
> On Fri, Sep 11, 2026 at 3:52 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/11/26 01:47, Suren Baghdasaryan wrote:
>>> When per-vma locks were behind a config option, a number of helper
>>> functions were needed to simplify the locking code. Now that these
>>> locks are universally available, we can do a little cleanup.
>>> Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
>>> query_vma_teardown() helpers.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>> Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
>>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>
>> I think you CCed me only on this mail correctly (the other ones went to my old
>> RH address, I thought that one would bounce)
> 
> Oh, man! I used an old list of recipients :/
> Should I resend to avoid bounces? So far I haven't seen any bounces
> even from the previous version which also used the RH address.

Odd, I thought it bounced for a while (maybe it has a new proud owner, who
knows, haha).

I changed Monday my mail filters to not catch to/bc to the RH address when also
CCing a mailing list ... assuming everybody got annoyed of the bounces.

I just reverted that change, so I'll just fish the mails out of the mailing list
folder and should also get replies to the other mails into my inbox.

-- 
Cheers,

David

