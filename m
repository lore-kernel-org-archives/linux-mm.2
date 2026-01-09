Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62ED2D1A623
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB786B0089; Fri,  9 Jan 2026 08:57:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3496B008C; Fri,  9 Jan 2026 08:57:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5116B0092; Fri,  9 Jan 2026 08:57:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA156B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:57:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C0BE1407D8
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:57:35 +0000 (UTC)
X-FDA: 84312578070.18.35FF6BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2CE0DC0013
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:57:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NY4oSD/7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767967053; a=rsa-sha256;
	cv=none;
	b=CLTJOLuDkQD7HM28MZn7mYdDSNsyjD+unk+q88dZ3hnO1dPD3MzGCSsvz8LmqKorUR6+2m
	+lKaC4ZmlxsiGI3yQjtEMBKBnEHD3sJvEgOyIlejtpMnpXIZT89hujbMenLsuiBK7Ep8TW
	ukPWvJpBnJ7VQPlTbrObd0l5H/qoNOs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NY4oSD/7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767967053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7sZNYM6RKSjgvTBjVLV0FDLTWScweFWy9yEjOJZ8+s=;
	b=jj9WV7mq4Y0Ok8bYekrnHv3QBYuRXXuNYcZUNtuZYkqAquGRxAzgRwzP8+RpDEZ8/0bbe+
	Sm0jEdx9qD2ohNTs6HuSsGf73Ts1Gyhn/3WFlJlHk7NfkYhMy6Tjxz88zSjhQtGOPlQVuH
	1FN9xuzF40bhFOi3ygR7wz/lA7yxcRM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F515403B3;
	Fri,  9 Jan 2026 13:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0662EC4CEF1;
	Fri,  9 Jan 2026 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767967052;
	bh=yPkaDDuhSCsGnvZdvzyLXWNunlnF2GmByj1Ajgnb2W0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NY4oSD/7F54ScSuMAqx5AItsCDxNZsi5sM0NY2oZFAs1gelVgL8xls0KMrS7jkxZr
	 1acdVa5gIJNNT5CgltB9ejtVMPjewb6ReQ+y3HMWkzOAA2bx1viSuq5iLD7mmP1QmH
	 o9yistm93wbZ0CyxoiK75wWurnKAJUaoL3/R7Q33MSstfgrU5f3GFPL/G4hJSam265
	 tOgBtN0kcnQlwC5W5lnaUbIEfXw8q8C1QFV+AqRSc2823owKSBn/5DjRTOOqAZ+Q5v
	 brL2XEZstJL+RVsnu7cQrC+HeyntX77MYkw07o2IqsjLGQpr5e2gTOi7+9AY+sYQs0
	 aafPQ/3RohmkQ==
Message-ID: <4cfb49a2-f0fc-4796-83a6-91db3a0f2a97@kernel.org>
Date: Fri, 9 Jan 2026 14:57:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 mm-new 00/16] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251201174627.23295-1-npache@redhat.com>
 <e54b6ade-e2a0-4a68-93c4-23af85479567@lucifer.local>
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
In-Reply-To: <e54b6ade-e2a0-4a68-93c4-23af85479567@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2CE0DC0013
X-Rspamd-Server: rspam06
X-Stat-Signature: fgbgwnoo6gb6io6hofdua1kk7rz5subz
X-Rspam-User: 
X-HE-Tag: 1767967052-602404
X-HE-Meta: U2FsdGVkX19jIYmUlN8Id0Ax66MOa76WtYdPj3j8xaao94sbQYrpkC8SO14vnW8fkFOUVNuNU71BGbkTWNCdj7mstvbZ/VPDsPqMbyJVNaVMx6S/uNKoJZjgJf5k71PWJ2BIccB/4QJPVLU8fN45x12E+/XcZY/EfythwcsWK5G4i3ixZT1Zw418JCJBydl2i1fHgLQwzLUsg1yUYwm1yyA6UCBXZE1ooZlV3Is/2dsFN6G4P+4TJsD9rEGWk6zCfOcEW75gO3kpThIqWpsGCviy+3dNx/L/GPBzpYPOJ8nDaEZmv0bkosXpXvalmdUYnZKuN8XM2au5f/6RtcPgXySl7HEkaVpC4NaSqAPijzlYxnfO8zFoQ6Ol772XupkNEaXMmn4/ShzuDXedeMA4gaQnB7jPrxEn6LuaX9P9FL55B+CPPoPye2TY220kkdWsQGE7euCzDePjJX2zDNUf+gFPH1WJSRBADOPzSEU2GzdWuY5HWq8VaIo+V+69idAva23e2vWcXP5lQjpPWoLImwT9dhfdQp6ArN6YKMid6No4+XevhUPQyPTjf1Ujkg1JTtjkz3U2eLJyDliN4vH3QEg01lh3b99MUYHe28wda7IvInCyOIS3+pxoS8mNR4x3vhWVVg8Mq+gfERj5nwu6BiVwppjhKItDWWskukOcwDY8bzL9ocXcjDBkG/NONyiaH6maLx+mogy6v54eTLCwaR13hsI860PqD9QIk/BGV/kTo7/fti44i6BP0oTSw/rnBOlJy/E21N/MP4OnaBNRH2n9mtr+anH1TrGip4yzC/gDR7GpD39ZWQOPkvKV23sriRXbSNFwIgBg7qGYHhaOLwJh0sUaEqmBbreRVdkWBZKnZQ37Gx+KEUAWdpCAOIfa9qSaQJwFJwJupHDd6RdnuQKoSX3XV+IwzHNYaHblbQYrSPW2GOr/Z9LgZBWBJFAYVZoXYk3vBaDG1FXypL9
 tvjSskpn
 qfXLAdBnS0LV/SxfNxzX/hvHmARQ8G5CERw4eY7bPe3PE1Kux7JGN76DJAUbXwdZGBKRzWfHbYd6HSrp7MN+/GK/l7e1+Ufq/Emzaaow/btv7THp9vhos3uBP177nEL4Jd/ZWl+nG9g6Lz2P6zQTFZGqSYLYY0L4pqMydnRX+lEdYHWIiHK/v+2AvoQ5RAoR3aQyoH3CpCXCozcAmKPHlaCTnSJZTh4r/CqW1F/+fG+Nrrix0a7AkH6JszNfmiU0femLQlqRVschEuIza9FH0UAtWJ9/HExpsHg1BtuwuqoWlH3IWW2sB/8rz3v2Fz/MkJoR1uVHHdBFeNExpwFMbE++BWZ3dHPdSP5SU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/8/26 18:19, Lorenzo Stoakes wrote:
> (Sorry for multiple mails replying to same, lei/lore are broken again so my
> setup isn't working properly).
> 
> I tried to fixup the conflicts here to run tests locally but there's too many
> and I messed it up.
> 
> Could you please resend this series rebased on mm-unstable please?


And maybe send out the two cleanups that can be applied earlier separately?

-- 
Cheers

David

