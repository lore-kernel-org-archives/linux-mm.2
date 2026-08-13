Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE703C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0EAF6B0472; Thu, 13 Aug 2026 06:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE56E6B0473; Thu, 13 Aug 2026 06:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACCA6B0474; Thu, 13 Aug 2026 06:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 941A06B0472
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:03:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F05DA2C5B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:19 +0000 (UTC)
X-FDA: 85095808518.30.B8771F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 26CFCA0014
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SwhDCkGF;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786615397;
	b=S6OsvR1dWuEHuS3q5iUlTNKbZ1b1wXW/Z8gQ1OW33uFjUS3Na23dPquyfINHNIXs85c+dL
	cYaTG1vV+V6ErwLMmYF0Ny0XSGdMW6k6F4ayQU2zG3iQtqxpv5OqPJvdY2lwXTdvOvrUgp
	vRw5gEMqNh08VccgIo7/YavfM+pujRM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SwhDCkGF;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786615397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82KZrS7ujoal5yjqBJaa0XymEVl+P6knR3/hbb1bBPQ=;
	b=g3ZtWNTpQxG8gX6N/e8uJIRR0ovsj8N6nF92egGtHaNdikafV2IsKQJN5ZiMYC9C8J2mci
	jgtYhQOBx//HylHadKxJyl0rLZ8c+/M1UIADYUGxuXunZfQwzlX2X5pdRGVL+X1n4HfDLZ
	Dpx/NpUq0438ZcyvWl8c+XgsWC6dDbs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A646A600AD;
	Thu, 13 Aug 2026 10:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C7B1F000E9;
	Thu, 13 Aug 2026 10:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786615396;
	bh=82KZrS7ujoal5yjqBJaa0XymEVl+P6knR3/hbb1bBPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SwhDCkGF/4OObov9oToTRSnK9CdT+QHzoXHGzJ3H65D1t+fk7zRxTeAh1eDVDjkqy
	 zxYZJ10oHgJHDXQ+cCyRIrYkTqW8m+zmplqvCrJ7NFbcTxhXNyxsDlOJI4e5JUjJoz
	 xPSYPNP4RkCjr9o1gPuH0Me0CzZtmikeaCg6M9BavlDqQ92hx27RaUpIM0OKVK5b/0
	 xbqLefhXXTdX4JSeBn3v6SdNO1VEt1J6P5uirY6SYdM8Yzd6HKOeLZktM153r9dVXw
	 +Z51kxm7bEk2pjwx0O2Ou9GcQqmTGVHmS+fhyqjJt2BCZI4m3NvCQGyzw+ZiwUcaYs
	 5UbP759NP44yw==
Message-ID: <8a391a81-73bd-40b3-bb00-6f6912070378@kernel.org>
Date: Thu, 13 Aug 2026 12:03:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
 <20260701043024-mutt-send-email-mst@kernel.org>
 <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
 <20260707155658-mutt-send-email-mst@kernel.org>
 <6ec8f683-77c7-4ddd-830c-030a3d984715@kernel.org>
 <20260708090739-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708090739-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 26CFCA0014
X-Rspam-User: 
X-Stat-Signature: bc1htxwmfcp5m4eqhsf9h8ijr99bwnwh
X-Rspamd-Server: rspam06
X-HE-Tag: 1786615397-550386
X-HE-Meta: U2FsdGVkX1/S4vQgD1qLPjvgylkTqUOyus99g2nMDj48YSNZHPB6lHr5DPa58DDM/FXhcoKJjuFGtEmM5dgTZTfD9MpeymTADwXPVR39TTQ6d3lz1QvJbPqw9J7kGmKlASoFSLkk3ZMGtSG14BklzN0zeUVr9I1jtNo8Ui38l8p4LgFhP5kkseD/VEDM1tzb9m3EiWVz5wP3vLEDT8GUJEG1XwPm/ZATeDSY2ftqMI61OqfhJL8I8lgQdTARFPIMPDgFN61VkBWsv1SJsEOR74LmZjrvjddt0KhQ3MdvIxEto4wmPg6cwSNo6sI5vfWBP7ZPfY2RNnC6NeyUGo0KiaTjpbAwW9ldt549fXXD5/l0PO1qZRl9QZdZkRmbc/lIcuDptaB/HffqR2A2VfEq+KhwcPzFR9RDLhaXBqBZsl+m3Fxvi2q2XcpeVdFuMSTg2t+WOvmXvQ/fsfrUyCn6h6u/CeaanmCTg+1FKn5waXSm1ZrWr6bRhyuQ/qZqMhmyQSMkDeriyT50Xh9DnSLEsOCxdr36YzHdhhe7Rqoubk5Dd+f+Ad56OG6olWA2VzaUxbEbsGFvA/0rnZg6dkOFGcElG6KiFUVefieM5Iy4huvz02QuDIRJ2Ybrji2vwy4egt0tI9OgH91/9ifEHtl90vsyF+M6k4i9K5cM6tWQp5CZTgQSK41sHZebLAHEA2UwLHn8nSXnxg6c7J2ORL8ErNLzjtpym1jArjSe5K2l/gbCmOqsQcKqCwG+vqWj0yE9+5KLcNTSgDmNaRHTV0eLCLSv4bxYwpD//QpdltUXrA29FuVNYFm4tZHE4joUOacskjhSMIZv/fToAzM/JDaj/9uODu6c8QhaLYWH5zDewD8W6ovMLk5JzJMS611yocAlefgnvihvr/R4kmi5b5uRu85LgDwCCVVoCRh9lHr50VTyWSWr5/I8YFDUUuAkmoJXolRIYine+5t8DuuL4R/
 6S3DObbN
 jO+aM3Al0FrlL5T9NDHXzy6NFcFsnXNjKeV0BcvmPRxf2EsDrlTLAV6EMOOHwIYEjCierQvmhvmOzTob2+wkoIXDgXXSTBC1Raqjd6kXuV+kNIg74KPILTqY+MEFH1BI+wH07a4BIXqOP/hQb72x3V91f+XNhEhnw+BwaRGCZPhbmjRqEcaZx+79xvsYR0S1hd/x8HtUpTFRkm8fyvr6fFIt7gZzuNs8xDMRx+AGJP/orokudPLtim1sn2pOB6KK/LP0zJmg6yXY6pIwRxTw0FtrMygltKZU+SSG/ZDs+eklxbu+Gi4aHItldBCvhgVkewu5L/8RVlAncyT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 15:08, Michael S. Tsirkin wrote:
> On Wed, Jul 08, 2026 at 02:03:21PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/7/26 22:27, Michael S. Tsirkin wrote:
>>>
>>> I spent a bit poking at it, and it's hairy.
>>
>> What I thought ...
>>
>>> The issue is that we have calls to both set and clear bits.
>>> When we record them in a side side structure so they can be retried,
>>> we have to carefully record both sets and clears and their order and make sure
>>> they do not bypass each other. So if there's set already in the
>>> structure, we need to take it out of structure and only then add a clear.
>>>
>>> It gets very hairy because we want to set from NMI.  So now we can have
>>> clear in the data structure and set from NMI bypasses that. Now what?
>>> And set from NMI can't be 100% safe anyway as we discussed ...  Kinda
>>> reduced my motivation to try and make this reliable at all.
>>
>> Maybe we should just really keep it as broken as it currently is. It's not
>> really worth our time fixing basic design flaws ... given that we didn't have
>> any report about these races so far :/
>>
>> I mean, sure, if it's easy, ... but it sounds like getting more and more complex.
>>
>> -- 
>> Cheers,
>>
>> David
> 
> Right. Either we do the RCU thing or let it be. But then I'm uninclined
> to even bother with fixing other weird behaviour I see there.

Yes, let's keep it as broken as it is for now, just not breaking it even more.
We discovered other hwpoison oddities lately, and decided that there needs to be
a high level discussion on a better design of hwpoion handling in general. It's
really just slapped on.

The page->flag handling is only a temporary concern, in some memdesc future the
problem will look differently, and likely easier to sort out..

-- 
Cheers,

David

