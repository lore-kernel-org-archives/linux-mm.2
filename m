Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2006CD46621
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580856B00F6; Thu, 15 Jan 2026 15:22:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E346B00FB; Thu, 15 Jan 2026 15:22:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405946B00FC; Thu, 15 Jan 2026 15:22:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC226B00F6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:22:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC2351604A0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:22:37 +0000 (UTC)
X-FDA: 84335321154.19.7210F95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0041AC000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:22:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h9qY3ysQ;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768508556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uY3o2y1F1IlyJMhjvXmSOwNumGLbuYhzziYmOwkN1Cw=;
	b=Vl4TBk0hXDzAj/KPZ/eHEviazuFJAZfO0k7SnjOILiMnuGOv6TldhZOX9MVf1UAqp8X+7n
	Z2SaOMfM7LEPxAIJ2/S+G04FQhIaaPVR6Mav3aVMcIupD5D6zhTzQfbrhA/aNy+7nnABvb
	/jKAzPIKhqzaRBIsVZHRSjm7kLwvZM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768508556; a=rsa-sha256;
	cv=none;
	b=5Iq2Gbuaxqzn7BzQ1K/8jRCcMefXe3MeSnrBlDXSXAsIU2Sz59iuGmfL1negZJoB2QX+Xv
	zzCD1Cmf7wHs7EX+R4TVzM9LQoLuf8NY4b6fXWOKv/snrLx9KrFmfAHlPmM3K4nh9mnRKt
	0ICdkoHrv5q4+7IhfaHQAkBAqJ6D+Hs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h9qY3ysQ;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2A1240771;
	Thu, 15 Jan 2026 20:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC72EC19422;
	Thu, 15 Jan 2026 20:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768508554;
	bh=1hddCG3xZm/iiLHpPmyWA0LbsiF/+3oaYQmfb6kzP2k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h9qY3ysQ0ie8RBLLbvg84OXV5EKQQR9D2zZjbIgXTYwqFEOarV5Pom2h6aQDS+joc
	 mtP5ye5rHB5JxqXdC40G6sxfKaV8qD0a+8wdqYWAw36i8e5is9TJGt6ag0MXCm1mt8
	 Lc/eSGDTLBeg4MuxvgYbRUiq5MkFPju6wTx6k0SjS8oqq2eT//EVO5RF/kFWNkaWTe
	 lGz+4ndG6+n+2ZINMdsmbYmEBijbZuetaxu8wB63cFto07iGcOGbr2V02O5DZPEax9
	 nYSYIilIFGx+atyNQV5Lv1TOi5wYX6roUQWGxbYqFpCuiBc3nxGK9O198eofZulYeI
	 oNcfnjQdgCvKQ==
Message-ID: <65cdc2fa-b6ba-4422-9537-feb7d3a33210@kernel.org>
Date: Thu, 15 Jan 2026 21:22:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: dan.j.williams@intel.com, Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, fvdl@google.com, joao.m.martins@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 mjguzik@gmail.com, muchun.song@linux.dev, osalvador@suse.de,
 raghavendra.kt@amd.com, linux-cxl@vger.kernel.org,
 Davidlohr Bueso <dave@stgolabs.net>, Gregory Price <gourry@gourry.net>,
 zhanjie9@hisilicon.com, wangzhou1@hisilicon.com
References: <9daa39e6-9653-45cc-8c00-abf5f3bae974@kernel.org>
 <20260115093641.44404-1-lizhe.67@bytedance.com>
 <83798495-915b-4a5d-9638-f5b3de913b71@kernel.org>
 <20260115115739.00007cf6@huawei.com>
 <23513e86-0769-4f3f-b90b-22273343a03c@kernel.org>
 <69694b06835e_34d2a100b3@dwillia2-mobl4.notmuch>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
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
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz7CwY0EEwEIADcWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaKYhwAIbAwUJJlgIpAILCQQVCgkIAhYCAh4FAheAAAoJEE3eEPcA/4Naa5EP/3a1
 9sgS9m7oiR0uenlj+C6kkIKlpWKRfGH/WvtFaHr/y06TKnWn6cMOZzJQ+8S39GOteyCCGADh
 6ceBx1KPf6/AvMktnGETDTqZ0N9roR4/aEPSMt8kHu/GKR3gtPwzfosX2NgqXNmA7ErU4puf
 zica1DAmTvx44LOYjvBV24JQG99bZ5Bm2gTDjGXV15/X159CpS6Tc2e3KvYfnfRvezD+alhF
 XIym8OvvGMeo97BCHpX88pHVIfBg2g2JogR6f0PAJtHGYz6M/9YMxyUShJfo0Df1SOMAbU1Q
 Op0Ij4PlFCC64rovjH38ly0xfRZH37DZs6kP0jOj4QdExdaXcTILKJFIB3wWXWsqLbtJVgjR
 YhOrPokd6mDA3gAque7481KkpKM4JraOEELg8pF6eRb3KcAwPRekvf/nYVIbOVyT9lXD5mJn
 IZUY0LwZsFN0YhGhQJ8xronZy0A59faGBMuVnVb3oy2S0fO1y/r53IeUDTF1wCYF+fM5zo14
 5L8mE1GsDJ7FNLj5eSDu/qdZIKqzfY0/l0SAUAAt5yYYejKuii4kfTyLDF/j4LyYZD1QzxLC
 MjQl36IEcmDTMznLf0/JvCHlxTYZsF0OjWWj1ATRMk41/Q+PX07XQlRCRcE13a8neEz3F6we
 08oWh2DnC4AXKbP+kuD9ZP6+5+x1H1zEzsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCgh
 Cj/CA/lc/LMthqQ773gauB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseB
 fDXHA6m4B3mUTWo13nid0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts
 6TZ+IrPOwT1hfB4WNC+X2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiu
 Qmt3yqrmN63V9wzaPhC+xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKB
 Tccu2AXJXWAE1Xjh6GOC8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvF
 FFyAS0Nk1q/7EChPcbRbhJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh
 2YmnmLRTro6eZ/qYwWkCu8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRk
 F3TwgucpyPtcpmQtTkWSgDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0L
 LH63+BrrHasfJzxKXzqgrW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4v
 q7oFCPsOgwARAQABwsF8BBgBCAAmAhsMFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmic2qsF
 CSZYCKEACgkQTd4Q9wD/g1oq0xAAsAnw/OmsERdtdwRfAMpC74/++2wh9RvVQ0x8xXvoGJwZ
 rk0Jmck1ABIM//5sWDo7eDHk1uEcc95pbP9XGU6ZgeiQeh06+0vRYILwDk8Q/y06TrTb1n4n
 7FRwyskKU1UWnNW86lvWUJuGPABXjrkfL41RJttSJHF3M1C0u2BnM5VnDuPFQKzhRRktBMK4
 GkWBvXlsHFhn8Ev0xvPE/G99RAg9ufNAxyq2lSzbUIwrY918KHlziBKwNyLoPn9kgHD3hRBa
 Yakz87WKUZd17ZnPMZiXriCWZxwPx7zs6cSAqcfcVucmdPiIlyG1K/HIk2LX63T6oO2Libzz
 7/0i4+oIpvpK2X6zZ2cu0k2uNcEYm2xAb+xGmqwnPnHX/ac8lJEyzH3lh+pt2slI4VcPNnz+
 vzYeBAS1S+VJc1pcJr3l7PRSQ4bv5sObZvezRdqEFB4tUIfSbDdEBCCvvEMBgoisDB8ceYxO
 cFAM8nBWrEmNU2vvIGJzjJ/NVYYIY0TgOc5bS9wh6jKHL2+chrfDW5neLJjY2x3snF8q7U9G
 EIbBfNHDlOV8SyhEjtX0DyKxQKioTYPOHcW9gdV5fhSz5tEv+ipqt4kIgWqBgzK8ePtDTqRM
 qZq457g1/SXSoSQi4jN+gsneqvlTJdzaEu1bJP0iv6ViVf15+qHuY5iojCz8fa0=
In-Reply-To: <69694b06835e_34d2a100b3@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0041AC000C
X-Rspam-User: 
X-Stat-Signature: 8uw6h7som9prf7myfbp4qt3mmzwfd5bs
X-HE-Tag: 1768508555-705014
X-HE-Meta: U2FsdGVkX19VKbdR+bou2RHWB/Fi5Z6c0Q5h7nuMKFwWAVcAwjmJ97cS14tby4vX+1BuQgHzZmWv1/50aWkYIKhOBUH4R4wqW6Talg2sNeAOJTQFyMEbftKVgbh1lSb1u+FG0qgWKlalci4Hu7AIDv7XzKIcjhYL4N7MlNVqTXyR1nG20oz1K5b1ejlC/vG+/CRLNzTys5uBDbDTeRxYYSviaIL2yVe2mXqh2fliTSNZ+ERxIEv9AbaLTQorPESUeRO2xqSTSHKokGQeVOgfk9/6/bwOtjRtBAj6rFYVxITvJZPvcX2L3EmltWaO1uJZOXexl/oN4Kdl4UAKTdrMaKuoJERs7LrC1uNq0uBCrHotmK7vxERyiW02Rc6KgL/PdOv3vq6mUrbXJML4PsV33/FwVgrF0ncXK8Wd592ZhVxz2Cy+++1HrzFfpF25EuNACF5VezbiVS9ubMhPXEUR/bDP6YS4AGr3peXe2nc6KO4NjbJ5xnzWDucaQKK1o9JY2qsdqZ5KYP/lU69RqToP9HVDrJrX43AckONBBbpRUZuZbDJ2Jcp3z7exwvLdyVnGuA9jH1KVO9tFs/jU6iUOFdsR0R1DFedLayuYTug9Y+VSmRYOIvOLfRHSx1YdWCEwNzVRrwuul9mnnbOtYii/S2OohayJxpmeP+IAEodPX7nOw0d7xKjqRlZeT2fYHRNdXRnewlStf1o6q10HwOF7SO4aapBkKVjqRqM3NXRac67Co6y/AGNa0ReHbppxOlbq7akRnAJMycfmc4X1rM4ujLCwYX8Y/2NqtNZGQer9o1jIScWFjz2y9wY+f4TmNaO9V0d4d1XNT8smUn1rsj0MbecODN3d1MTuLWVrWMxfzBaKW1pXE/Tn99y57lE9DeWbdtrHjMkmwtSpP66rlJ7Y4VcSthJ3FMoCbugi486+8E4bEmfmIb6bMfP9EU0LCFzmnozpFsrXN0jRI4dLKeT
 ODp5Vy8C
 DJCc/eX4r98k1RkkUC0Cj4ohhgKswPqxaWxz5tOWg+nlIhbL8TB3kVs/pP2Ju/KtltKx94OVvEQ0Ft61Npvx0dZlwGcE+VGSCmT4fH5wdfdvhsD+OaEEGTgP/7e4Tvb6BAqDPFcSfV0rWaupOou3bKqI/66dWwleT+EOoA17/ncVOqxBirBX/+CF5n882JaJbGvSJPP8vd0DHppJ2pYAIHcK8SaCye9DzXEi5fjQLQyOK3X/tlnT4ABgto9G3gg9sqW8ReOQYN+lDXICwiSxfK0WZOubS4BhLXU+T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 21:16, dan.j.williams@intel.com wrote:
> David Hildenbrand (Red Hat) wrote:
> [..]
>>> Give me a list of 1Gig pages and this stuff becomes much more efficient
>>> than anything the CPU can do.
>>
>> Right, and ideally we'd implement any such mechanisms in a way that more
>> parts of the kernel can benefit, and not just an unloved in-memory
>> file-system that most people just want to get rid of as soon as we can :)
> 
> CPUs have tended to eat the value of simple DMA offload operations like
> copy/zero over time.
> 
> In the case of this patch there is no async-offload benefit because
> userspace is already charged with spawning more threads if it wants more
> parallelism.

In this subthread we're discussing handling that in the kernel like 
init_on_free. So when user space frees a hugetlb folio (or in the 
future, other similarly gigantic folios from another allocator), we'd be 
zeroing it.

If it would be freeing multiple such folios, we could pack them and send 
them to a DMA engine to zero them for us (concurrently? asynchronously? 
I don't know :) )

-- 
Cheers

David

