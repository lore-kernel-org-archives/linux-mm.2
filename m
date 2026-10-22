Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB82606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=nOjz2OQr
Received: by kanga.kvack.org (Postfix)
	id D9E736B02D1; Thu, 22 Oct 2026 08:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F266B02D5; Thu, 22 Oct 2026 08:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FD76B02D7; Thu, 22 Oct 2026 08:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF906B02D1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:39:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39450A84DB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:39:10 +0000 (UTC)
X-FDA: 85350217260.10.C8AFCDA
Received: from mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0A5DA2000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:39:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nOjz2OQr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.90 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792672748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEn/o5vicVIiycYibVKL0UsnyzA/YANniegdeifG/s4=;
	b=2dQg5PZJgCemNGbd4bLVtsE14ju45QYJULLvPeXALkNDJiQHcwpQWaGuWppc5HFnb0uS+D
	JrzhPpUnCU8xqYWKJJl85d6CjmB/saXRnkrPPgEsM1fLuBFVJL+w2sbtc77RHCSEH4i2yB
	vy7563DxmFkqD1jxkKgMbEnzm8HzFR4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nOjz2OQr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.90 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792672748;
	b=LAhvdmaa5mhYjg7KKD5Ac4bwFHhRYO86iW+v4QXDEUtMEtqOq63smHDMrnuer6iE7TpP/K
	RJRRVBIzc92+TfxFOurffrLERsBOHRjySD3OI4Uk4O27y8+TLchATFDJUIlyPD3f0ydcds
	oD0tq5+gQVHLTDBslL+1SmLJTm9AwnA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eP1LGnMko9h7Km3zC9LDbu+hXl6U04EeI1vwWmy1Fx8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792672742; v=1; x=1793277542;
 b=nOjz2OQrNk73XSno40Pf6U+nyDPsxvXMg4Tzqu4XgyDh2uEuEgCHK2p2C2bA9C8LDoRDxZK6
 Etz7Wfkpzjiw9Pi2gsbiPjcPJVKoaPWH2xan2mkgzK7BDj7DeCG8IOWrMvCHBKlm2jbGMarSqDn
 Up3bysopPUfk3R73vnQkcyXA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 33f383ea385dc4c6;
	Thu, 22 Oct 2026 12:39:02 +0000
X-Mizu-Trace-ID: 33f383ea385dc4c6
X-Migadu-Flow: FLOW_OUT
Message-ID: <58cfeba3-a3c0-426e-ba97-8f82da5b1e8d@linux.dev>
Date: Thu, 22 Oct 2026 20:38:53 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
 <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
 <877bjowf9i.fsf@DESKTOP-5N7EMDA>
 <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev>
 <bc1b3255-99f7-49c8-bb52-bada6df80f72@kernel.org>
 <23d3756c-1a87-402d-80b4-c838dfc29f4d@linux.dev>
 <9da90d76-031f-4211-b9de-439cbf7bc63d@kernel.org>
 <49966df8-c092-40de-a05a-ff6d69382dd4@linux.dev>
 <e4c3ce3a-c19b-418a-a92e-40e077f1ea63@kernel.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <e4c3ce3a-c19b-418a-a92e-40e077f1ea63@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0A5DA2000C
X-Stat-Signature: uxrmn5wrqjbrhq7z57yxfm58we56m6dp
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792672746-28252
X-HE-Meta: U2FsdGVkX19YO4W7Ce56ktufw5nAkqdYi7g+QdwyY+BAIPUG4Tu6qzpPonDuikPzZKbCevdp6q99iWMXzE+XDM84fuZyzbcjNRhu7UZOEd3/tlDX6UJITwH1l5TDOXkgZmmyEfgFNx6M+p0gtM/DKdXhgvxLk+ihnS6EeYITIwarduDPrOLHOrzX7+Jn0OBA+iswTnTvUUaRRwcTL+UnA2jlmdjnWvSpZZk4XKaA+r6D7eB53nXZvo5IV80F6BXA1Z/6pHK9uY7P/QQEuEUQQANFDmqaxSy0jLuLJ/7QnT2g5gYRdAthuzFK1a8/6kLu7YCAfSpfhZi8FNsCmr8A11B3PRKJAaaLAddHWWrMPJXIs0aP3wjXnzynMpG0OFemkQUOxIetzOnWXxKSc0xbnNzKPCKC3ivs9q+ITpp3mfyLMsfNDgrVosVIuwoX9zyvxVTXB/uM/WRkuTNQwEMipRxZpmccW2ZBaEHkMle0XcKmZ3HbTJp6F5MhcAx0dTIQidD9yQNxzbQNGfXUJQSEQHQNu9kamebYOKR4yW78iR+NFVgoiGamAcSeKUJHbWsLmkaj8q3N2yvAFbllj0e9GrZBKMtpaU3TH0PB0tQihSC02SFAwD6fW3WOw5LnbWIgO6HuarqLjJsuuzEKQBpIr5wnHLsUmSlmpD9qiHOelyLRpiFpWZYm8cDnrrSg/N6N/HCVgFr9uDsvbHE425Yc/9i58l1a2OJ+crzuFEKeBnpreKEmf7/lQfTAyx+H4N9wI5bI90hNgE27c23BycXpIHJJpvaFP17nM0I0nzliwukaLNU/czwU2QHb/kcJzm9nG18VRsuZUWn3Dgit1i7iTqL0KeRUEwi/TQhGH7EStH/wmbfhwnxFqZrwoO0KdcxAVxm0/NNW6g/OqGAeQ020xDaIdiuAaQQpsBC1BnZzmfmHzbrfqI06YCFLImMUCXQdhS2ufn4YUlVkWPL8pUW
 Rd93Ovy/
 9LXIj3z63cgnhNOuY74GdYG0/KBfNdab7OKnlqL1ppLig6SDUZEd2zm6QBnSFLwXlUjsUgdeRULd6Q9m2NcrAHSMO0pn3pOwEeSPOoi8Wlxd8cgpPSoh3GFoabFbmQHX2p2WR+UxqWDK1cdLz0b45QvtlYYOV/SlPmPoAoOL/GwyQqxymaGjQ3WoxMoMLoFws/67K6502Ub4DIaZ1bVqzMIGJ2L7rpLonDT2HAbVNb6NzHIUOTqAAhw6PXqx+nGIJnahYBMTXeMkUA4N8KsuYiB+vzQ/J27yxl0Ou/1ECikyVTFVEmBTOskV/Tru4Bhx2eFsmcJqB9PYDTOIglL7erhIIUjIhxsUV0PVzXsL9w8rgga90fDf0MjOceEVbyWDsreJg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/21 16:27, David Hildenbrand (Arm) 写道:
> On 10/21/26 04:49, Kaitao Cheng wrote:
>>
>>
>> 在 2026/10/20 21:58, David Hildenbrand (Arm) 写道:
>>> On 10/20/26 15:31, Kaitao Cheng wrote:
>>>>
>>>>
>>>> 在 2026/10/20 21:07, David Hildenbrand (Arm) 写道:
>>>>
>>>> It does require architecture support, but that doesn't seem practical, haha.
>>>
>>> Well, but that's required when an arch wants to rule out all races.
>>>
>>>>> Will architectures that are not prepared for copy_mc_user_highpage() not simply
>>>>> crash if they trigger an MCE during an access?

After thinking about it, if the memcpy here is guaranteed to cause a crash,
wouldn't the system inevitably crash at some point anyway, even if we check
folio_contain_hwpoisoned_page() beforehand and return early, since this kind
of memory error is unrecoverable?

If the system won't crash, it seems fine to defer the check as well.

>>>>
>>>> Do we need to check both before and after the copy? This feels a bit
>>>> redundant, and I'm not sure whether such a small race window warrants
>>>> an additional check.
>>>>
>>>
>>> I don't see how checking after the copy makes any sense? :)
>>>
>>> You already crashed if there was a problem, why check? Or what am I missing?
>> In cases such as transient errors, software poison injection, repeated
>> bit flips in memory, or bit flips in the ECC check bits themselves, a
>> page may be faulty while memcpy() still completes normally. If the copied
>> data is correct, only the PG_hwpoison flag is lost during migration. But
>> if the copied data is corrupted and the kernel or a process subsequently
>> treats it as valid, I think the consequences could be more serious than
>> an immediate crash. However, I cannot estimate how likely this is to happen.
> That's the point, me neither. I'm happy to perform checks before access, or
> after, in the default copy implementation, but I want to have properly
> documented how this makes sense and which races exist.
> 
Here are a few subtle corner cases I came up with. They may be extremely
unlikely to occur. 

case A:
CPU 1                                           CPU 2

if (folio_contain_hwpoisoned_page())            The check passes because
        return -EHWPOISON;                      PG_hwpoisoned is not set.

                                                A transient bus error occurs,
                                                or the flag is injected by software.

                                                PG_hwpoisoned is set.

                                                The bus temporarily returns to normal.

memcpy(new, old);                               The copy succeeds and copies
                                                the correct data.

                                                PG_hwpoisoned is not propagated
                                                to the new page, so the flag is lost.


case B:
CPU 1                                           CPU 2

if (folio_contain_hwpoisoned_page())
        return -EHWPOISON;

                                                A memory bit flips, causing
                                                an ECC error.

                                                PG_hwpoisoned is set.

                                                Other bits in the same byte then flip,
                                                or the ECC check bits themselves flip.

                                                ECC check passes.

memcpy(new, old);                               The copy succeeds but copies
                                                corrupted data.

                                                PG_hwpoisoned is lost.

                                                The kernel or user treats
                                                the corrupted data as valid.


-- 
Thanks
Kaitao Cheng


