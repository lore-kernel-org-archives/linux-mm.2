Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC37DC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB116B00B0; Mon,  3 Aug 2026 09:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2E26B00B3; Mon,  3 Aug 2026 09:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2056B00B4; Mon,  3 Aug 2026 09:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87BF66B00B0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:19:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2F4B14066A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:33:16 +0000 (UTC)
X-FDA: 85059293592.30.9912F5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 10797180003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:33:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGdBNCTB;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785745995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+e8KnNIzD8gYxdZrSOuhd8fe4rBpYFoiXBzIPosaVY=;
	b=0r77+GXsQmrlcCvL8jPl+NwDg+BrxfXWMPN6RLioF3Oasb78jYtugyR6+0pqj8UPaQeJny
	4H2vOYBM8Xmlhma8x5YobmDcoJQJizgjvOO55OVbk43OfaE6q6WvE35sZcolwkTYk32meE
	NENXZkpfUOese3adKZ/+uoMyFOCmt8Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGdBNCTB;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785745995;
	b=eNJ1N1sCl8E0Q9l6rSkwPECs+vXfQxCKQcUBStDZtbKEGaseTyI4rwJMN7/SpE+S4tRazK
	q2x20L5o8iadiSMnuwPSWNOO+x3gildmsrBeeD7C48LKUwMwNYoUk45J54kjTA4JfwmRhW
	FikIgSoaiXob/8Jzb+bylYmT3t3oWS8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82915600FF;
	Mon,  3 Aug 2026 08:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487D81F000E9;
	Mon,  3 Aug 2026 08:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785745994;
	bh=m+e8KnNIzD8gYxdZrSOuhd8fe4rBpYFoiXBzIPosaVY=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=NGdBNCTBvXRIxOnTroJ/LTqb0MLDnqhdLBDSAuGkqbrlV66qNdr4IgJdtEUst88OI
	 XY8xslbBhgpzEbeuYhbVA3CcIZ15wgYGE3ksCwdNSQxSVh9Kais/xTWvn7O6HNYjRi
	 wdmpdmfYzeBkLXKDlZmmNhmvZuAOoosu0tUHmdY2193xXqUR4OBf7GSBvoBaPLum4D
	 Dex0VM+ssdS9/3T5du/BEGyeCrXSXeD3FTUE9iIM5JDNMQfLdUwLLReDPpTUL0my5t
	 V2ugzta01MTSak2BogaSbJkXFiT1SmbGFP5zs0vtYfcCNDEBzr+2i9w0H8ca9MMWCt
	 v3T15unawu23A==
Message-ID: <2504da57-a507-4567-aa5f-bbd3ec17d002@kernel.org>
Date: Mon, 3 Aug 2026 10:33:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: TLB free bug in 4c640eb4181c ("mm: move pte table reclaim code to
 memory.c")
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>, zhengqi.arch@bytedance.com,
 "Liam R . Howlett" <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Linux-MM <linux-mm@kvack.org>
References: <CALCETrXbj__SFQMzPZhES5y6-sh4np-ZHY5T_=4QY5+Fn8BM4A@mail.gmail.com>
 <f2eb26f4-62e2-4a16-a56b-706adf230cb6@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f2eb26f4-62e2-4a16-a56b-706adf230cb6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 10797180003
X-Rspam-User: 
X-Stat-Signature: x58mxaajskwukx7sh5n3teiggumujjck
X-Rspamd-Server: rspam04
X-HE-Tag: 1785745994-138796
X-HE-Meta: U2FsdGVkX1+epuQVSr+IXOLAOy23oNdIzsZ33Sa31MrVJHHhk/tvT1lv1a1u340sTZe2HErFP0010EUKgSWC7uoIvxagj1QeIoV7EIb57nVIajibjzuXCo1UlCY86d3knzsUh1copehTV4L6D+ghgjMDFPT+04qmy7cKbShv842s3KR7mnmHa+xfrl0xfQPvBSlKUzDkSlMkyKEQmt/rwPTEMI4nnRaPRXIU9pjvud8J2IkCQPqlbLvcAlZrkOQV5rprd2L4peJI6Dn927oEBtU5Eh4FJIISHsYMA/cPQuo+0C4lUPabUrpbFlGAH7NyZ2hsPSnFYUnrDWu8/L6m/oPVyHWoKKcaYBtc03rBIJfs0XFcTery5blAp3bwkA/oRWje5sR44Kths6TIXaUpbrZGJ4BcxMcrCHL+80XpWRfNqzJ7Hy0C3e9fbNdCFcQ7gX9suI168Z7vjS43+9Bl1IvAbDHLkliG8ofgjpkBObDOSwEYmeOnlAPIUjAzyJJEKGK3TEAtX8weja8w0CR/0LZQPg/dQMdZ5oyKguOXSR4TmwzOyWLePUK2lFiAyuo0CrJuEFt2piwNhpTN9vI7tpGXsPPkmyOX94xEKJblvFCrZT7EtPLb/kMX1eurvYPcOyDjb1+MFtguKKYWwTuxzNxq+adzBhHM2ZPhw2ghgE6VTPMAv85cZLH0KAOXOGvw5w60Pul4smXrd9DqLC40LU3/azcrJTv8UOWeNI1laooPzrgFHle5/nwRRVmLnQxsd5JzNW3Oi80zhHLIeKE9mOmtWLelebQ0zX2oB+BxBkXxvBibOt8gCTVhDVjL4qRFl48J2jwHS8qEVXBNagoIwK2PDbpI6loTyp4wz6JwRthy+EdJHiz9m2Caqns3nxyi3CfrX5l9wALFfR28+adWOeRoc1eJsDKydniKkE7lLPGTJGv8/pW6E4LltqYeB8jpG0uKNLnbTVdrfvdB3Qi
 vM5HgEWM
 POFuwbxYZYAGONK5Dal2+0m448gX4RlNPsh0Vb3bxgMNWYkSQLdw44wqRroLfezv6noZpDcPE7n71kMt3XMfrAjBtl5Ca5G+CLGZM4/LF46qfoQtzy2GlqdXeDZlnGVKEKtS4B2LM+6WKwa5IB3TC3JSRFO2IQu8PYRd/eCUYwGL6NCdfXlwkWY8aRyASPvk+avw9nRDIFNGEQKOedyENo349xfQonLTYzTr6AKzwGsuoZXef3RbVhDt7chET0ypZvtsy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 10:31, David Hildenbrand (Arm) wrote:
> On 8/1/26 16:00, Andy Lutomirski wrote:
>> Hi all-
>>
>> I saw a fun bug report in ripgrep and a studious but pretty bad
>> AI-generated analysis, and I peeked at the actual code.  I'm rather
>> suspicious of this:
>>
>>     if (can_reclaim_pt) {
>>         if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
>>             pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);  <-- what is
>> addr here?
>>             mm_dec_nr_ptes(mm);
>>         }
>>     }
>>
>> It looks to me (and an LLM -- I can *never* remember what all the
>> tlb_xyz functions do, so I asked an LLM for a summary), like addr is
>> not guaranteed to point at the range being zapped, because the do loop
>> above may increment it right past the end.
> 
> It will actually always point at the end, whereby the end is at
> the start of the next page table :/
> 
> pte_table_reclaim_possible() makes sure that we reclaim only when covering a full
> page table.
> 
> Subtracting "PMD_SIZE" from start would ... or just remembering the original start.

Stupid me, we have "start" right there that we can just use.

-- 
Cheers,

David

