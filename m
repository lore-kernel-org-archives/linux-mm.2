Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A54B7F483E9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BEB6B008C; Mon, 23 Mar 2026 15:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCCA06B0093; Mon, 23 Mar 2026 15:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB636B0095; Mon, 23 Mar 2026 15:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC8F96B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:39:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C18E160D10
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:39:09 +0000 (UTC)
X-FDA: 84578341218.11.49953CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E85CA0002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:39:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJ+d1IE2;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774294747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDKuD2LWN5KTaG1Y5kbzQmhGa9FcWYd9eBa/sp8sI5Q=;
	b=qWyGRSuQFQS7mvY4HeLS1nXDM9L2OS8xd+AQs3tlAx+ca9OOkDeF8vrDaB2rl286CUAZdx
	fnO+c7kh7nKJmnS1JqDlwbTMZnr7ucpO8xeGHwDAHZQvJUlrh9RpCcXjMd3EDgEwjI/53s
	fWq82QiSHTjoA50iugfMLlo6Brd3b78=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJ+d1IE2;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774294747; a=rsa-sha256;
	cv=none;
	b=S/6fR7KvJDQT1aVwDTZTlU7nzC3ZSHWJN7Ue81bM43gyMjSAxe4BGmzZ+JFHG59T5IVdSy
	rHnnIoOHjDPjQgFPqvsqqEN8dKf6+R91sVA2aB2nlGABmN5HCxo3Fu1Yuotj6+K+t3I8Vs
	AOlhbIR5VPBy4drL7+sGJVIEIkbBRH0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43E20434D2;
	Mon, 23 Mar 2026 19:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B858C4CEF7;
	Mon, 23 Mar 2026 19:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774294746;
	bh=Eei5R6PJMtTTG6JSryoc1eT2IJV07EOeVe661ejNU88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oJ+d1IE2lXshEQKbMZhoPSOGCUt44s/Q+1tvZ+pwbF28WdPZV12HTdbsCwwK8IkTW
	 vRS4G7GYytxBH9Ov3Cegw6yJU/cqaWSPjW9vuq/OdoPRWlKp+EIj0RVWPStMhPIJs3
	 7ZD/5ETf152Nmat+zq10RqhYHNHJa9SeQ+F95HM7H/8j9FMmE9WtVk73l1GAf1NHvq
	 ytxpSdDxgYp6500C28PceXubnbYbtSiaD+CLNA8N1myE2OPTM66ZxqqtOQtHieonRI
	 SD3arytyjyI2+q1RMYiEXdxmlDoUdXbgbNI3M2MSOl6QB0R9TQ+/IRnq3Xk7XuvVCs
	 y4n7C5Zd4ankQ==
Message-ID: <2cfa402b-319b-4cea-a2fc-1cefab76c701@kernel.org>
Date: Mon, 23 Mar 2026 20:39:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-8-hannes@cmpxchg.org>
 <61d86249-cd89-4e99-99d8-ab7c72e95f34@kernel.org>
 <absr1vgNP_tM1OEP@cmpxchg.org>
 <e9631520-857f-4f67-8944-6af7a2b47e89@kernel.org>
 <ab1vnhL4XftNdTSu@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ab1vnhL4XftNdTSu@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E85CA0002
X-Stat-Signature: twkbca6si7d1p783yk8ehs5impjmbu16
X-Rspamd-Server: rspam06
X-HE-Tag: 1774294747-222129
X-HE-Meta: U2FsdGVkX1+Upi62Tik4GR5ycET3VuAvTfp/Y/nxVOGze3jEDDEPGBcr2SNuoK9N5h9CdwYPJCTmA301OxYKSfpTTGyRF9K7d1I6FkLtIZmQ9sd1b/WPF0jpMMxGROyukdi4LLlpBOq6MTrynMRPeagAFQHI1ODrCCjDNFeuLnp0D4bc8N8gj2Ge3n3J3X06l6KvZnbTc4gPDHg4QLEhoQaDE7MmeAne2tinXI8wO3Hlf22DruVT0hVQfg8CgRDd/sIhAuOTSPuI4QrSZl0R8Ps2S45T3t8KcZAxUL1KGcNMf/DPur9u7EP0GjaA+Jz16PMe2eVkpbPa4gqaRPyiCUT5Tj8Ng/+4XN8i4iCUw9QT1qUiMA1q3aEovaQAlcNWrEAQ493D00c87Ka/Gmpp50eF5qhKYlpHLoNCEPwJbwDsf3DXvHhoLqK4ZWtsjoPZYcFdvmsyXTDkSvCYAojUV0EbqB9913FRKJtpCmQAZjVMkFw17PPGm5pVuLqM8u5uVgPwLxkFwYLsIcBSB/TpovEvOQ0a+ZKu4xOy5yUduJDMwdvPgT38MKBto8ONGIbRi1SWWEwhkfROS9fsyLmmhFbAShrUDcbEAHB/DtZhNDMfBs0Jc6oNspbjVz1EasyILOQI2d5lYzlyb0fHeBXXQgjs6krInYhyQ+WtnfW6TfzjASkjGF+ua+IWwTZJGiNKUIVgMZH2OMYkxFl8tUDvfcYg/6ZzjWyVv00n808phkDPMcvoKTs+OmdZcrCNopZbIgCmYejFaYYLkAFuDhmk3DsnCmgDZZB2976/K9iyNbYZDXugQCsLCDbwrPGfNvRNvtokb/ksrLHUMSJSuUOTr4qt83Ihv5mBLSnDSSsfg4BMtXpbHgc51yHUQOtTAAJMssPNxKOvJlXkhTfeY/MKkl97sLqSU0bTYVn8HqEFL8ebApWRaEt/eYyFP7PauuDQ9UiZ4Sepyi4WucFsJ5a
 orUGXb1p
 zOfScHVzOudu0koqFji4jF2ta7g/GyUqMCBRLefsafLgPF6yBLFcd+NTalIb5VEt1rog2bLthM3khCvijbRGwnk1v/BEhgBef1UR1wWg/9Rg3cVTtvyyIfBp00VPmoVIvLtj7g1+TI/z4Fdm+ujlngaxn7QDMOAmQDxAGc34MADNuWUU8bXX8cxKz4AALfzpfZL+qUODzz8+wyE2/3qnVfD4cpR5lrbHigIeMI0Jk6a06p1kWwUxqmEszo0GU8Vj7kNM+OPKQVl0F9u8E2wf4ZXffjjLB6sM2/IA+1SaqL2Wd0t9LOQec2hRsvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 17:02, Johannes Weiner wrote:
> On Thu, Mar 19, 2026 at 08:21:21AM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> I remember you raising this in the objcg + reparenting patches. There
>>> are a few more instances of
>>>
>>> 	rcu_read_lock()
>>> 	foo = folio_memcg()
>>> 	...
>>> 	rcu_read_unlock()
>>>
>>> in other parts of the code not touched by these patches here, so the
>>> first pattern is a more universal encapsulation.
>>>
>>> Let me look into this. Would you be okay with a follow-up that covers
>>> the others as well?
>>
>> Of course :) If list_lru lock helpers would be the right thing to do, it
>> might be better placed in this series.
> 
> I'm playing around with the below. But there are a few things that
> seem suboptimal:

I like that as well (and could even be applied on top of the other
proposal later).

> 
> - We need a local @memcg, which makes sites that just pass
>   folio_memcg() somewhere else fatter. More site LOC on average.

The LOC is really mostly just from the helper functions IIUC.

> - Despite being more verbose, it communicates less. rcu_read_lock()
>   is universally understood, folio_memcg_foo() is cryptic.

begin/end is pretty clear IMHO. Not sure about the "cryptic" part. Taste
differs I guess. :)

> - It doesn't cover similar accessors with the same lifetime rules,
>   like folio_lruvec(), folio_memcg_check()


I think it gets inetresting once the RCU would implicitly protect other
stuff as well. And that would be my point: from the code alone it's not
quite clear what the RCU actually protects and what new code should be
using.

But I won't push for that if you/others prefer to spell out the RCU
stuff :) Thanks for playing with the code!


-- 
Cheers,

David

