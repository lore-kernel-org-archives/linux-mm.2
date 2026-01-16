Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36143D47CD5
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F45D6B0089; Fri, 16 Jan 2026 05:52:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9745E6B0096; Fri, 16 Jan 2026 05:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C5B6B0098; Fri, 16 Jan 2026 05:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75B716B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:52:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2110F1AE831
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:52:32 +0000 (UTC)
X-FDA: 84337513344.17.FE4197B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F75D120008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:52:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RTSTCoOu;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTCekCAuKETvEuN9jTbDLB1P7rv4peQ92+oXwOTcp18=;
	b=3D4WPrn1Bw8OzUopIkVScaA9Au01QhhVzzoWiqadymwV3yx8lYNaSF5kQYwyDODWQ5UhIe
	LrJygHHtAF7SyWYwEEO8n9JxabZvAyTCj64liSQ+scPHwLe5QvrZw+yZgebSsFlKpI0WK8
	y71HABygivp1fg37uduOUEM741Oul6I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RTSTCoOu;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560750; a=rsa-sha256;
	cv=none;
	b=KJwo0ISz/RrL7nhra4Nft2QvZVtmcR+Mnr++N1xnrGus/m6faFeX31dtK/Zd28dsodPDcs
	fIJj6/czIVoVAhPsncJ+9W1yxIw1agqieCc5I1XTTLaFYP4V0mKhdFbeuZkReKATefRFT9
	cMngD6uynIxLFl980VjimxDZDz05wxs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 979CF60193;
	Fri, 16 Jan 2026 10:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFBEC116C6;
	Fri, 16 Jan 2026 10:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768560749;
	bh=QTTXskRSykOzdUCUBOI186z2skQFb/mpgixxD4CQn7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RTSTCoOu1dePW9H4OkH93WMmKcmffIRyCILb72Voshdu1/HG1XMdiNqq59tuMyzRQ
	 IlNlaiHsclaJtcSFl/uFfNGQhfgO2MUfsW50Mm42OZLFQB7/4LnEF/IAPnknF0wggf
	 yFEvaP2Ec05ad4spLh6+EKgkqbYaPe+qncz/cJSD4rmOrnp5of/WLm21Ng6muXrRjN
	 yIl27I2S9SQHkI1dFZJ2KxdZP8nmJXZb/pSLq4i2hcDoAI6wvvZVHepRc5BFfOY0bq
	 kB4b2VAGwIU8l002tGAtNcs9eqvr88ckplfOLsVF5pFhjCq/COhEgcFlP6vNn+ASzZ
	 QfkQ1oDtMVv4Q==
Message-ID: <3595c849-6b43-440e-8e15-f51d5de0cad6@kernel.org>
Date: Fri, 16 Jan 2026 11:52:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] support batch checking of references and unmapping
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
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
In-Reply-To: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5F75D120008
X-Stat-Signature: 614geoujrkpipyxm676akbh6xq8d5cxw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768560750-731513
X-HE-Meta: U2FsdGVkX19KX6r+tF6ladMETNHD/K2V5h62nvPwqSzIDxcbSCJ0IyKdxy7PnXO5AgeAd9dgH2HCRRw9bMSaqMas81atE8Mlm3n+e3jgm9RGvH82XTfJKkCKoNx8ZNpxyDpsVAHntthbubBAOdUndnRLGWh4X4pzKIafB+Gt488Zr+8tBuEkTe4Vc9xEJrrrLYGMSB53por90COLiC6m4J3L7whbSEL5K8Vylej0l8kgDoJyfHplYFrwwwKUX4kvGJZCR6TfFupckdEv74TkYEfeUlT5P3Ocvbg3W6+wK78+ZQyv0Mm0RqM5948nD8dLCcOGnU742ZngZuN+1XKE++3T0UcQtBrC4DF7clGq6GPdB9xY8Hj3PD+Uk39y06hyqj3qB8hlKMmN5lu+j9+/ZMC/NWOOE6PYzsA9B53zpgTIwrGNkRvgTqHw/gjC0Wyi/40U2JEYkAWPhXZ/2fudCnjfpN08ddcIa3Vu3GYlUZTUI0HAOjv/gII8v2hbqDXY93qdY3O71Mob4HSpvLz5aVpYFLPwdVbPGrWo7+L4CdgPSt069fonX1fUG9Khxe/8H6E0XEvRsF1VcpgMb6MvLoc79BQtrG22aVkxLUQx9/xuivLuev+Hbhu+p2Bx1PmSUVUqusdpd7w5NkHxxSJ4n80enZ0sc1A64Mqa2slicWkXWI/YQ2Ya6A46txaWISx8vKHvME+FDNC/4GMIln9epintmkOAHFSlfFdKnJPXuk3umQIrEgDVuRw0xnZThlTQqzQlPkVTodF1jf4eVl0GRLSOIu/574Xev4kNG4qWzOdT/VSLkio9/uE5ReNo+0mcyEefwVtCdicKnW7raYv82IIjEvDaywNb4/lcACdSAmZZTHNz+CE8J+Q0lqSI2J9fBBX87ZiE9JcX2IlEwjS1/+mEPUwieAQzX257HVfv16afyqL13ZM4Fn77lbgTKS/CJhLp+5FgAVhaTjFTZBe
 Bv7xGhNN
 NIrFa1E6a2ECJxel3phu5k/O33sMA2H/i1S41qIatNA7ybLmE4bONdZe1OaUVohFstCD7ezv5SLdPvSFtO4N/Ggr7NbhHp7ag1mu/KtKk93trv5JM6jM1B4SPbo4i8KLHebTL8kHYS6h/WXDyAdRb4I8GqaxmAVxDMET870gYIrgr/vyKrqXYoRdZ/MnBMLOfNFJBwKRSuB9vSlKZCalBSsTdDoQUUxjvGCF/otk/SGfEg+q8PoU5DhoywC8IovF4M2hd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/26/25 07:07, Baolin Wang wrote:
> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Similar to folio_referenced_one(), we can also apply batched unmapping for large
> file folios to optimize the performance of file folio reclamation. By supporting
> batched checking of the young flags, flushing TLB entries, and unmapping, I can
> observed a significant performance improvements in my performance tests for file
> folios reclamation. Please check the performance data in the commit message of
> each patch.
> 
> Run stress-ng and mm selftests, no issues were found.


Baolin, I'm intending to review this, but it might still take me a bit 
until I get to it. (PTO/vacation and other fun)

-- 
Cheers

David

