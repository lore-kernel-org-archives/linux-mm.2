Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA25D4661B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D671E6B00CC; Thu, 15 Jan 2026 14:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E5E6B00CE; Thu, 15 Jan 2026 14:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B5B6B00D0; Thu, 15 Jan 2026 14:47:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B016A6B00CC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:47:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67AC8160483
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:47:24 +0000 (UTC)
X-FDA: 84335232408.30.41F5573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B48ED8000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:47:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VQR/OY/h";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768506442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0GbhM/YNOec8GjuG52zy9RY6IG2YXKinrOg75xeN0w=;
	b=PPGN8X8N43UUNR/5z/14PaOfWYVq7zwJZrODyJxhlzAKRjGoWx+L81IIfOP5TuA09A5pOA
	sDBSUTJwgboU9jvMjEyGU9Mu7ioKcwl3+wF76X6GgiEzBWVsVexm30tZGMKwB7dhu1BuAl
	JKM7THBCU0hGNiLS/Gz+qI/e7c31C4g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="VQR/OY/h";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768506442; a=rsa-sha256;
	cv=none;
	b=1+4Rhh1EJ4Fil/sLlp1EjoSOMrvWQeaW6F3UZXbfmMLvD2w6+tsFdSCb6Gh1Lj4pEj7aRD
	s6ntz+x4lJoBTLPU9RTq0S5ucOhI6igybknnZ4PypsX1HlRPW94NSnrvUTygrq/hRiMG+c
	SoJArP12bIiyiwrpLzOw9NOhUxP/6/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 958AA43A2F;
	Thu, 15 Jan 2026 19:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE08FC116D0;
	Thu, 15 Jan 2026 19:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768506441;
	bh=D+jjqpzEzwsq5h/veNpZGYB8c7XNukTOJhE3rBm203Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VQR/OY/hCNDvRaE+jNTt6iA1m4T71lc8DJ03ytv75m8RJa+E2kIn3bIO+6SltMCXJ
	 GX0nISHvh4p+yN8hYE4UZ/2FPM27BNzPZKmQxyhuQUOYFzxFoPw6VTYYUDErxTU8xX
	 TY0C6tg3XalvaV8GjNKrmEazIRgCvoT5eAxlgyehIs0vq3EbNAGTb/WD4COO5d4xEx
	 VQgTFnuov8EhTFm8wqqniXzcDzUvkw5+8+A0XE06pvdustXvsOTIsQEClLaSyhyUDs
	 sDuIV7aRw7+GWxk0cv5JIZiSDT74X1qfb38/FIt5Q+cebDi/t76E7uPhwN2GX+pNnG
	 Xr4tbwGP8qA/A==
Message-ID: <dd326898-ac9c-494e-8af0-9a1ec382598f@kernel.org>
Date: Thu, 15 Jan 2026 20:47:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/23] mm: balloon infrastructure cleanups
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115104907.96d2aac4de42dce12d6064d9@linux-foundation.org>
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
In-Reply-To: <20260115104907.96d2aac4de42dce12d6064d9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gb3faowubrt3zhkmn6inizfxkfptkhg8
X-Rspamd-Queue-Id: B48ED8000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768506442-290931
X-HE-Meta: U2FsdGVkX1/q0rOtFCI6EYawG0Np1KTuFU9ICQemZASEYMhs56OnVbA/PJv2n1z0T58UYcnLJIqcl3bIp71Na3InL1W/oA2Qq/gPTI0gN+/iG4z3lOXB9B+Ymq4Oao+rD7c597ejfSeK6+Pmd8MFST3Q217/CK5qxkUjs3pbXeI1KTLT0afoY795MADZ6BesRfa6V4Aa1gAYDFKRbyLhrHXh68kl8gLN/eEjaucvwG+hVeLcQUy/XwJVBiHuEuWYFzlx9YA8f7IJImnnF+OaUj+jx6lcux0Nnj3tK0dKib07qyXmALLgqmJgqopzSbagUrirKofD18syn7Ax98WVkMMS3gt/IV4StKcQSwK07ieJfJ6v0IEXBGxwDFW3wcZBLja43laVFwNcKtxAvoAJ8HecYfOJqlAebdZYb9hj/cLqbS08LxptPrHfPu19zc8YWBSETmX2CO2QMTWimlDQQKtC44WjGGzNHHtAE9xAiJwML05+R2T5ARR7SvlnEL9RcfMp6zaZRNWBbp2LCCOPdly1YXus8PxH8iV/uBWlB8udlYZynswEP2dZfc2zLDz87pkOJNalwWPxIhwePwYPoxPG4Aq/nx8E+UTc/mxzPbJ7LQlkWTyNlZZQft3V8KFtIt/dlbYAuGHKHoQJFrqfjRTTdRNEseEhOzH51jyklolTEgGTKHqwqjFT1UA8h/3hI9NP94/DVoD/5t/NiWW3zRYQUSYKF0anqthFihBuUnYvVasigo9EbxvMzqnpiJydBUCms78HO8FntPjWqG/NUuD+kJkdFLCSXJq0Afs7kPym6hzhAn0ELDJCkFtE2sMA7/+v9IPudYCLWwQYN6cgkK6615Maaf6IFOQnvfECylj30Y1ZPxIDCwdAkkRuYJlaBkqJ5a+Zd7Kz6CNcj/0zBsS/9H/ptW0AbqgJXIxfI8APEVnhcnYvQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 19:49, Andrew Morton wrote:
> On Thu, 15 Jan 2026 10:19:50 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
>> I started with wanting to remove the dependency of the balloon
>> infrastructure on the page lock, but ended up performing various other
>> cleanups, some of which I had on my todo list for years.
>>
>> This series heavily cleans up and simplifies our balloon infrastructure,
>> including our balloon page migration functionality.
> 
> Thanks, I'll add this.  Again, I'll suppress the ensuing 528 emails.
> 
> Sigh, I do worry that the ongoing email deluge is training people to
> ignore addition of things to mm.git.  Maybe more emails like this one
> is the way to address this.

It would be sufficient to only send a single mail for the whole 
patchset, maybe?

-- 
Cheers

David

