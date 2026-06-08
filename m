Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93FC9CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69D56B0005; Mon,  8 Jun 2026 10:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3926B0088; Mon,  8 Jun 2026 10:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93CE6B008A; Mon,  8 Jun 2026 10:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A58836B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:29:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5286E8ABB6
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:29:03 +0000 (UTC)
X-FDA: 84856977366.08.6BC7898
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 608E61C0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:29:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVSUAUIc;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780928941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vD/e5GbGzpUTKj3cfuSRPl67o8yyW37wXtN+83Ecbk=;
	b=ghvpmP3GDWshk3dkhbRjLpjTTjuTKsQ7ZlDx0/sztIke5NyxWstYuJuvJ0BU/rCYA919TW
	33fMtrHeV1eTeXqoFDg990509OhtR5IlbcB4jcpIKaLclOjn1e+H78iIIZyyy/vdKh3vQG
	7LcT4a7oGmnPYpVXv1xTzo9FfBiO3Ow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780928941;
	b=6oQNtomWznDoCbAPqRw9Hz4+i37OibnpYnBz/mu2PUkFLyRB3DtESju6lTNokPru9ut1Uu
	a4KcHxcYh88dunj/ZklvxQQyAxp+dJ73Lr5BH+gyDCvw2cl9ZwNG8httsxc+aVWsZ6Es5F
	1GpguB1sWfntGxANS95BmOZTzJBa3yM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVSUAUIc;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9060543462;
	Mon,  8 Jun 2026 14:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D101F00893;
	Mon,  8 Jun 2026 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780928940;
	bh=8vD/e5GbGzpUTKj3cfuSRPl67o8yyW37wXtN+83Ecbk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iVSUAUIcC/kDGl0YkM/2lS+l2CzzJ5Qk2alnVwUR/PtsQifRku1nj/Ss+SoH/Ss18
	 b37DpAyjbM+pCwUNSWcVgNwg5fGucfa+y2b5KH+6sElmprdsRkihqZPzCRYUOhwav/
	 oAuR9h6EnCZkSWCUdeoqVDOKNpxIrQfyxn2s4HL8otb8YUIEEDSeydmHNg5H07SmHV
	 deIVt3lBfH3LSW4aGmcqJAf2qSPKVHJwQlQNpa+FVLcuZw4wR96paEStvn7Q6ufuAd
	 gH/ScFBwbSbkyKro0Cxrks0pS4hYZY/P+Z/Ao4MFKz7TODBxRKKNecerrs5Cryy7ji
	 26GZadvARpClw==
Message-ID: <497dff41-e831-43a1-a56b-a6ab98bc11a3@kernel.org>
Date: Mon, 8 Jun 2026 16:28:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/37] mm: add put_page_zeroed and folio_put_zeroed
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Hugh Dickins <hughd@google.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org,
 Andrea Arcangeli <aarcange@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
 <fef7ca7bbf591865defef658b0792b58494aaed5.1780906288.git.mst@redhat.com>
 <aiazXE8pUDeCmP7c@lucifer> <8ec82477-b497-466c-902b-82e108ae2b7b@kernel.org>
 <20260608100602-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260608100602-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 608E61C0007
X-Stat-Signature: biyjngt467mtts98xrb3xyb6x9gomkks
X-HE-Tag: 1780928941-909512
X-HE-Meta: U2FsdGVkX19auPE1/NrK9siHOiczUwcdIbsczmEmnFu2MQNo8/rKGMoyI20TjyXT3UAtkHQfJKhhJWHw+e3wBLj0Y8MYsGAYKsDPCzieLnnQ6mgGQGNqh9hoUMyoS6oUXQ50f6CURPvNbKMX482xVDUZj4aoU1tYufLNHV+B1o1KUXVp5h+M0VCFFZsE0Uem9XmzIRHuu/GAVIgxDMoSi1EdWIV88x5bNsp5OpDDI3SabbVlj6wWssUG9c3ewITYjOKSzgOLjTAnaomExEUPp/8DXh6CuVaq2N6OpK0UQos8D/mxMP6qSqU2PcZ4JHS+fCir1Z6DJxUgpLN0xo9soe2dFIDVrsbwAOmVD9rxM64OA2bjISr/Qg0i5KEseC8LL60TKzNq8SVOB76mwY5IDaldRi3yS03EajAWBkptbirsLIHXd2GxVBPpt3nVDjLlJ3YnehEE//3tfjwF/Wb8uzqlYz17W4n1SGjQ7a0Qap0cc3Px03fmSIjJfQqlDdEggAH8O51yQeaNSpgvFqcQNilSK4bFfKn8WgDjbfBqNYQA5H9cQXln1chGA+GoqeVC9u5p6Vt0kExsvrVmLkbF8E7M8jfVkmNmrGUxCibGdqt171ETitRk/hWZjQxAFqVTM1Us0rFZJVQZbrYaq73IS/HhgRGvnRPAWoY+U56Ge5r/S70USjZlU2X2v18Mb+p/X8HVlRoUkQVDQocQMkM+w1ak/jqcFjjj+bDtl5gFW3AMD6nM7xiQ9Ai8o2m34qonWB/6inxdfQd6rYIOYftdDVBbUbdzlt0BkcrzPqiPMPBR8qZ+BeZxnrAyoVBpx+nqCNtv/zOCNyTzxlUUNkhrQcYzfjlTgdASGllXeD6x9CLMpdpNvLmD3oImj6d5Es7eCKMViNjk7Uq2bDLS/2NX2Z8WlsAa3mCOeLD50KFXe63f+LAZQE5CL/dbgVTBrNzw6OTwd9DdlRmW0B2me3s
 jazUeIDa
 ZLwM0QVSzw7iKz8hHSBObUT7yLhBYMGVmS9JZ1T0KAkx6b/vghgRGPN2Rm32cOIsdM1ENYWCBGM3+9nObWv9tNLpdokBbvd/XhlubaVQBEkOTXnSEPsKMzG5GXaDocRhcef4ahST0/vDVLklMYDWLi+IwwFIugRp/vpUF+Cn+mOOKHfBpSov54dZZlr6v6ujVAqxk3iL3kwb6sABQGqXPGc0/YssPf/q97EYYkqXvvXPnpLhTe82wNnOdlKEApDDuUQqUHPgAHE0SzD8JcvVTtaeMJbON7vH0GIwv7NsFP/qD2TY/v1IMutRSwrg5UrPNYT85cOZf10f3IfbBPE4KCAEoIVeWm0h0W5L24dPdhJi3tAEraNg6d+4XkEB+ksX3E7pV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 16:08, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2026 at 02:46:34PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/8/26 14:25, Lorenzo Stoakes wrote:
>>>
>>> Do not put comments about specific expected races like this in the commit
>>> message but not in the code. Subtleties need to be called out.
>>>
>>> The commit message also doesn't at all explain why PG_zeroed doesn't
>>> suffice here.
>>>
>>>
>>> I really don't understand why you have a 'zeroed' folio flag but need to
>>> also have new API calls to detect that?
>>>
>>> They're also HORRIBLY named. Zeroed as in what? Zero page? Huge zero page?
>>> Memory zeroed by kernel? Pages that userland happen to have zeroed? Or host
>>> VM zeroed?
>>>
>>> Each are cases we address individually and relate to folios.
>>>
>>> You absolutely fail to clarify _which one_ you mean, and provide absolutely
>>> no documentation and add an exported mm API with no description.
>>>
>>> This is just I think not something we want to add? Especially on something
>>> so fundamental?
>>
>> I raised previously that providing a folio helper is odd, and that I suggested
>> that we defer this change.
> 
> Sadly it's a dependency actually - without it memcg failures would cause
> repeated re-zeroing where previously it failed without zeroing.

Oh, you mean that we succeeded allocating (+zeroing) but failed to charge?

I don't immediately see that to be a real problem?

-- 
Cheers,

David

