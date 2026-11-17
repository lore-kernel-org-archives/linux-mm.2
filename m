Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1C9606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cZhOFAFV
Received: by kanga.kvack.org (Postfix)
	id 7BE6C6B05B1; Tue, 17 Nov 2026 05:00:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F106B05B2; Tue, 17 Nov 2026 05:00:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637C26B05B3; Tue, 17 Nov 2026 05:00:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4022D6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:00:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C71F61203A9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:00:48 +0000 (UTC)
X-FDA: 85444166976.23.B0CB758
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 01B9740010
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:00:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZhOFAFV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794909647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLU0m+i51pat3GsVZS9FC+8o0VmdU4AL5cy98JWS7c8=;
	b=GpNna7CDUw4ExSpdIWrI/aWtwpRSAR0PgMVkTNueVjVA2vNkl76rL01VXZy1/KriaZSB3n
	6nLBZKdmYdNzrRar4SZ23x1F1Y2eR2kXwHW7cRyPK1gR/u6OWE8CSuC9r0jhUgNH7SiNGf
	jsmN1AMLuiAuwpd2lDSFhK7BgHA2hyk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cZhOFAFV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794909647;
	b=qtlVz1VSfAmi1PtgxDZTsWy3OAhKwdicJg/ft+kbseeXP21e6bIcEkpmj+NBH1oyuhpYzh
	6WAoQo4WrELTYCWbpfAL+fUSALDFbi2weKrr5VJNmVdN4zhAIXNbdmVcS5mh4AnxVVOnlU
	eOQMjKmkvqkkm2A6qo/3eh4za7jYLAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 350DD40DD5;
	Tue, 17 Nov 2026 10:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27711F000C5;
	Tue, 17 Nov 2026 10:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909646;
	bh=rLU0m+i51pat3GsVZS9FC+8o0VmdU4AL5cy98JWS7c8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cZhOFAFVxSdeDuTxSxEhs9gPpiWywSH6yCyruwfni1yeF1qmJqvrfwBErLufmMBan
	 v8UrVqfIqcZD02hwj7QfnjggRxzVAIPAzV6h7WvTLUFkFh7D2+CSj+OERAslUxr89j
	 omooWQzphPlqBa2fgYx+szJ0w8baRW/psZ54GaJB7oo3UFLRvYki0+sCUNzY2O0kp+
	 Gaz6TaLKYtW0GpnwpkWR2/v2+QJOCDScSxfgLKpoW1oCGohoIcax3kHF+PALoekhO/
	 9EjcscmKQFbaQfGkyn656zX4mCbhyUX8AZv6LmHZdfpj3XzeyfT4SFElCLWSvQPN25
	 YOtFYgWJ1FtHA==
Message-ID: <8c0ce90d-74d8-4578-bfc9-9218fcae8165@kernel.org>
Date: Tue, 17 Nov 2026 11:00:36 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: Nico Pache <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
 <175e7fae-2254-4e13-a4ba-0d39fb82018a@kernel.org>
 <22894af6-fd2f-4c26-b74b-d950f55a4e1b@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <22894af6-fd2f-4c26-b74b-d950f55a4e1b@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e1a8rtxmk9qz37gz44kjtfj9wgo8by58
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 01B9740010
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794909646-91411
X-HE-Meta: U2FsdGVkX1+i7yVuXqKHbM3Un0Ox5V4IP/as1TpEzOEaCIfEVEpDBDqoMXhorSD38UL8J4zRX0j4Dw6BphN9PfdTnbSU9ria3zgTylgHQnz6w9XBPt5uylmC5Nw5okV7rxnN2QULSJtTy2CKZUvmHOjsfUUp+81G5hIRcu0cHyXG479JpnLLFR09fT0A8bt9PVm4Y+QPi+Y5vq4btgmOtf7xItb5QP8nbgA5WQE4VzOgNehz7D1zZLGohbooV4k1UoZq1q6icpLayc2EsaNej7xmZXh21skcXsx63k5MIucd00m+gl9DNQW+QfUCaF9vepuQVcp6wcAwlzdgU/E9obTruSR9jXQI4OUSX5lueRMfWvLBGW2gzbxzuyJW1b0A7SfLuv+TmjsLxWxOu8ksrfnwnnBe8sLERTRAGFgfFnMDpD+T1zwnp+3tSVIDU0ifSBfZgPkreQ3p12I3nhWczf4YQXhGWsJH7EI/r0q5aKE05hP6hYFyLduOwdWeUQbpJzK5goSqU2DpaxV3EtTPPMcHgrKdigCBGN7h/hQxBde0zvwU8+P8qg4P51E8q5YWynURdow9ToUUedeWYZPvp+zooXVmkwuVz9yL3WICYI7SG6aKtGRGKOqJ7Q2fa60hZ2DOf3nxOS1gyks9bqTNQdWUbYg62kTIIxpZDQMSq2zU0k49TQpVvX1J9Bm+nvtVXLlr2gjZicHya6LbL5a4JrTql6t18UubkzX63SurZ5qYD2Nz8KK/KQjSZ+6oH8Tw+eps6O/u16kzR50ty2mWvkl/XOXYHtxdO4/1fU51UugOxMRWcXke2Ko6eUQMyasW3YRkC0x1d/EDCLLnvhKoShtfyZKimkG7E6p/n1JB3GyXMt0uXTo2uYqwOJCiJ70URZs/H5U1hOa+1uSvBKqDXBAQDl5CnbJGJqegrYdCxXtLo+yuedwi8JgnUmIUlJc5YPnTA7ifRkPXQ0xmygF
 3tSmZ+We
 cjaebIvfiFf7qxOHdaIf4sukt4L8gxb1rozZ0jTjNmjmc9iI4124G4YnyzSzHxAqcWwddtk+iwiPcmcgpc8WAzAbfPNsjnec4nc/D/vvPkQ+bKcErE3vh9WjLxttTXxYrQNIgMLxnaLmxi7outA5WzphRV1e3UR9XHcBFLtS28iIEbCOCcbzeitIBWjOhgfEi+cn53b97Us4LlqnFFQRp7Ul8T1M+5FkghKY4WLHy4blJq3Dr6EKV/xppJyVyagVsQzd1NGBqLLUZNUZ2w1gefJzHyPetlQR3mEOuBUjRsJV/1O2h7TvPNKWEUdUr8J6/ESXfDAb/Cl1Wo2+oIb2awjSQiMZSWJbszcqmX96WfXeAP6gRDkOCiQB7CxdaGzdjJyt3qb+9SULdIZrqqikMMGISWrM2AD2ajpIdfG3ZdAAnjtCc22UQr7nZ9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 00:08, Nico Pache wrote:
> 
> 
> On 11/16/26 3:30 PM, David Hildenbrand (Arm) wrote:
>> On 10/25/26 18:39, Nico Pache (Red Hat) wrote:
>>> The zero-page remapping in __folio_split() was added to support the
>>> underused THP shrinker. When the shrinker is disabled via
>>> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
>>> to avoid scanning subpages for zero content unnecessarily.
>>>
>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when
>>> splitting isolated thp")
>>> Signed-off-by: Nico Pache <nico.pache@linux.dev>
>>> ---
>>>   mm/huge_memory.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index bd44d58e8684..2d56d1bff0ea 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -4104,7 +4104,8 @@ static int __folio_freeze_split_anon(struct folio *folio,
>>>   out_no_split:
>>>       local_irq_enable();
>>>       if (anon_vma) {
>>> -        if (!ret && !folio_is_device_private(folio))
>>> +        if (!ret && !folio_is_device_private(folio) &&
>>> +            split_underused_thp)
>>>               ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>>>           remap_anon_folio(folio, 1 << old_order, ttu_flags);
>>>       }
>>>
>>
>> I guess the change is not that relevant in practice, because I suspect most
>> people always run with split_underused_thp=true
> 
> Yeah these two patches are only tangentially related. Technically with this
> patch (1), disabling the underutilized shrinker would indeed fix it, as we no
> longer are doing zero-page remapping. But the root cause is the split initiated
> from KSM.
> 
> Most people always run with split_underused_thp=true, but they also run with 511
> max_pte_nones.
>>
>> Th question is whether "split_underused_thp" only determines "that we trigger a
>> split if underused", or also "what to do when splitting a folio".
>>
>> Yes, it was added for the deferred shrinker, but the semantics of the toggle are
>> not quite clear. I don't think there is any documentation for it ...
> 
> Yeah Im not really sure if the intentions were to make all the splits do this
> zero-page remapping. And im not fully aware either of the potential impact to
> the system (whether positive or negative) this could have system wide. You could
> argue it keeps better system utilization, but you could also argue the cmp is
> expensive.
> 
>>
>> Disabling the "split to zeropage" entirely with the toggle off (behavior before
>> the toggle was introduced) makes sense to me.
>>
>> But the behavior now already like that in the kernel for a while.
>>
>>
>> I know that I suggested this, but I wonder, is this patch relevant for your use
>> case and patch #2?
> 
> Technically patch #2 solves the issue im actually trying to tackle. But during
> this case we also found this functional change which we werent sure if it was
> intended or not. As you say its poorly defined.
> 
> Im ok with or without this patch. Perhaps we can take patch #2 (bar'ing review),
> and I can try to do some perf testing regarding the effect of this zeropage
> remapping system wide, and base our judgement off that.

Okay, then let's focus on patch #3. The semantics of this toggle here are rather
akward (and I'd suspect we might just get rid of it at some point).

-- 
Cheers,

David

