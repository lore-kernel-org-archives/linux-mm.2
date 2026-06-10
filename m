Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 644A9CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869616B0005; Wed, 10 Jun 2026 09:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840376B0088; Wed, 10 Jun 2026 09:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D216B008A; Wed, 10 Jun 2026 09:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 691946B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:02:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C219140905
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:02:51 +0000 (UTC)
X-FDA: 84864017742.17.934B572
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 86CAF40018
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:02:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcfOUP41;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781096569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAdxrW8m64W6BTzbHMIrHCxXIXBwdiU4izodFeoMApw=;
	b=PUWUJlGc4rRhrAGNvxL0nKrR8m9XDgVXic7yeM9WuKDI4qqj2ims+4M1XJq+cfi1vUDpBq
	rBoiRTW/CrWE4oGxPSNscidtNEd3MYIYmO5gdWxM3pLTUW2J2eHac3sjtgQCAioRL8Cz0F
	shsfcKBvQyLVbL7SXNQKiUnANv0bCrs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781096569;
	b=c7ghvzUa0RcGgcnct9vejeQCgQTJxgmErcW1z82jbVLEVEpoiJOyQ9JrG4EbMbAoPFjkFV
	2kXNMvQjtvxS58suwzW7TpZqOiadjfkDGSgwy44ccSzOvN/V0FMmGZ7e8YtNSo2JBVx4yG
	x+j+0eCPw6QxC7ebMzV1gT2qEpgnJxk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcfOUP41;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1acea238-0495-4e2a-8026-22d5cbdbab21@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781096565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aAdxrW8m64W6BTzbHMIrHCxXIXBwdiU4izodFeoMApw=;
	b=VcfOUP41biEFjXxzdMT1F9tGNLry/xSZ4xsM+opHLILFrYffUdmZCFOw26FPfTijXSDZU4
	iDRbUDmXWpJj29Vps2zupTZH/8EHJFVPuschAR2x66h5FxPfDuFAS0J5YBTP46SMJVD/13
	xT0gyuUmzQadOTAaFzuW56Tkrr8NPAY=
Date: Wed, 10 Jun 2026 21:01:29 +0800
MIME-Version: 1.0
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Usama Arif <usama.arif@linux.dev>
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, ljs@kernel.org, shakeel.butt@linux.dev, alex@ghiti.fr,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 chrisl@kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, kasong@tencent.com, ziy@nvidia.com
References: <20260602142537.198755-1-usama.arif@linux.dev>
 <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
 <52cb5ce7-ece2-4e52-9e4e-5e476c34f8be@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <52cb5ce7-ece2-4e52-9e4e-5e476c34f8be@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 86CAF40018
X-Stat-Signature: 6dskqc986yjepxusujrubhuyrpp5pyxg
X-HE-Tag: 1781096567-605055
X-HE-Meta: U2FsdGVkX1/0q1Wx9XljLLKwk4XduxJqv9mjvS8Dkp51scbDv9sDMPiYddNht+uSyhh2WaU1Fa8VXwHQ+jShPjvEqiomYZTkuGoGvGYy+xngnZ+wnOHGuDzm4pZyI01HnywF+0xnLI8mHj6aRRZXw90u1s8zSNamGOUcLeDJTqPrmM4AY7yLbNla2WB3OyKjdj+6+Y6E/OhMRnM9qyn6Ru6ecQ01ezLnYJ0bNTvWPiWRxBRS7ug4Qm13cMbtTX28pgUkW1BmREmEXMDe414zmmlDHy6EtpRSszxgkhqQIbn3Y+h1BeN0G6OP5ZY3n2Q17mYObF1pVqCdppVjkDARVZOwMZvej7uyWBbx/DvvcSx5NZGgJCa+1DrYQEqpZa1WJUnrU76+KGiazdfi4iVV7U213Ulp1O1DmXMZ62oaiAkABnkUSsHJGBwMvm1ZKfO0UaD2M0XyGenTmBmxANMwmC1vvYpCI7ahHqJSj455/UiaMsXUDPUl0T8RtvV7fydJKUv2T/ysP6kkqXe61mxWoSmMveDqRl9AjuqI9Gfb2HCqr1QoOfTnK3bJKIRQnZbEaS15RaBcNeqaElmFkabXBvdlSFAvZR7Z15wR+mTOsq0xk5gATetV/S4wRJrn4DFCx9Cb5M5nTS7kBjuzYEjcJiWCtcvuSuDiSxowXE601cEOGoi4KD3aNiQyQhhYLh+dXZY/CWC9EhRFPS67v/l2Nz47v0N8z1xdy51UX7SB80VoYKRdas9ghoyx/YtUh+oqp+Pt9QAvm5sVkQpE9K3eTqggp1YJk8aauxTp5KIBWBSRge9jiIJqT9by3cA+QJwg+2Z1EB+IumEHiGivyMbKZ7k98FHbN6JUxCbhu0yxa4J8wIDc5ZIrTToS+fWITakIWrFvdRVHTw5Z77ktipvDhGS7M3pksn4JD+BHrmys4T6VGjyjMLi+rfNqUtS5KhGAvKnQbD9e7SDCpAysihH
 TDgx4r68
 bRVtWMVYl2f1F8OA7FuUtmGYfWjP6JmwEj7l5Tl8P9njgBWskGy1z6Dk51uVH7jw9rYEk7PSvjfCBvCKCnCDAh1T6vGabdEN1VTkSHQT3o8pInbbAE054+d6dWVtzE79lGFL2n+XEivqddH0xNRTHwp9/oRF0s8vJ5mjccF4MhL97xuc9U2Q2FirG314mbMiIAPRluBrngGTbArslJuNZ4Knp4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/10 20:24, David Hildenbrand (Arm) wrote:
> On 6/9/26 16:29, Usama Arif wrote:
>>
>>
>> On 02/06/2026 15:24, Usama Arif wrote:
>>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>>> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
>>> unmap.
>>>
>>> This series introduces a PMD-level swap entry. The huge mapping is
>>> preserved across the swap round-trip, and do_huge_pmd_swap_page()
>>> resolves the entire 2 MB region in a single fault on swap-in,
>>> no khugepaged involvement is needed. swap_map metadata is identical
>>> either way (512 single-slot counts), so the PTE split buys nothing
>>> on the swap side, it is purely a page-table representation change.
>>>
>>
>> Hello!
>>
>> Just following up if there were any reviews/comments on this series!
>>
>> I know its a large series but was just checking if there was any
>> feedback?
> 
> It shall be reviewed. We just finished the mTHP khugepaged review to get it into
> 7.2, so we've all been rather busy.

Right, mTHP khugepaged was a rough one. Glad we got it over the line,
but yeah, there's just been a lot of THP work lately. pretty nonstop ...

> (I mean, just take a look at the THP-related flood of patches we are fighting
> with on a daily basis, it's not funny anymore)
> 
> This is clearly going to be 7.3 material, so there is plenty of time given that
> the merge window is about to open soon.

Usama, I'll try to make this one a priority too. Looks interesting :P

Cheers, Lance


