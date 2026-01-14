Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A944D29FE3
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 10:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9023E6B0005; Wed, 14 Jan 2026 05:30:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0206B0088; Wed, 14 Jan 2026 05:30:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784D96B0089; Wed, 14 Jan 2026 05:30:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6916D6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:30:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CA98160442
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:30:22 +0000 (UTC)
X-FDA: 84330199884.18.E7F31D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 500D040015
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 10:30:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DYfpyomb;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768386620; a=rsa-sha256;
	cv=none;
	b=rrOEbre+6yBtqRNMcqfHZqp3GkJEmJGdQR7061LK8L2PXMI43ImfqimO0sa8dPz9/4l0L7
	8LBGl7u9VS2+/+MHcW7yYcpjII9kcBwbNd1QT3xP1wzKoPoiPsZ0Wq84TliVZmnuAvF8L4
	i8Uamlv2YD25iKz/EHxlWTsCTYFi7+8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DYfpyomb;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768386620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7JaYK1WTxqquiC0gesKwz4QBsEUF+tk5sKU6ZZufi8=;
	b=2tPM4TJxy6Kee8/8Ue+QjLRFHIC8bW1/ptXQw60OhwDKLi3Q8bzw+6TrOczN878VHioYy7
	OjLRh0zusAtJEOhy3UfnmUt3GQR/ODBkTU/0xtcCGPUj8W1xrI1RWbaET6+aOddjiOjPd/
	uBuR6u9ELLZfDOhz7bYmCRLH/+E1NeM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B3F760051;
	Wed, 14 Jan 2026 10:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE35C4CEF7;
	Wed, 14 Jan 2026 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768386619;
	bh=77eN+I93e/xYMMtzRTv9G1YoYjUEH5vEbzp1mfa2DjI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DYfpyomb3EQk2nMVNlKn6qt/87F2u+pToxXfZxzOlMqt1ACFTaOF/IEsA0RV0VY6t
	 ydoOkZBhkOW3zLWlGWxOVPy/IOJTlZoHr7CinQuPrYOnYWMrTBHFOR8S89l/G3zIZ0
	 XY9OkKqDpulpiqClfXz+HqUL6yu2/XzKZ+eE1Sd2KOcC0bhjUrEBkSfdL6T51u4DcO
	 StZZxajFX0AiS0SO5spKL5MrJr2NIh91ihPGoqPTYxYafroL6lpa9FgG3gl1wfBB9B
	 6lxpMS1HMBojP8SJ9OUykFnKqRU3axu9Och9r34zxi+gub1WSbtF4Clv5X3QVMyleb
	 tE5OZ0SRjjB2A==
Message-ID: <4f2c6106-9cc1-4196-8b20-83b297ae7195@kernel.org>
Date: Wed, 14 Jan 2026 11:30:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, kas@kernel.org, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260112202300.43546-1-prsampat@amd.com>
 <20260112202300.43546-2-prsampat@amd.com>
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
In-Reply-To: <20260112202300.43546-2-prsampat@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 500D040015
X-Stat-Signature: dy81ohqhq1n6cmjitxiebo6y9kekypgx
X-Rspam-User: 
X-HE-Tag: 1768386620-355250
X-HE-Meta: U2FsdGVkX1+e2yReiHXhiYN53U0tfkYsSlgqpFA1q7wyezuBKxjk/oMIoJf/YLW+RL23gJ7gUZmwgaVuMYXhKfkxzDUz6kIYFpiCFeV/6xPkno0JHTeSOmdjYYvxGnDz4onFKMZHCsa3tzCLLQw0Mg+Rfb8wL9c3BFl9oGRirrJInLFUx07zJUYy0p100FQsPrJGlTmsJs04UBIl4QKsqB74eFBhkWCT8FVC0Vt3duy+U9q1eEVOlM76zoOSX7HtYO1GCM3OeGNbRKQwJaJXRDUxrjr3U82i5eec3n1sLRq256qNDfI76lAS3jgv4EezRSFn+sglZ1E0sjxhChHqRdGXDfXFWGtd1axme2cZfowvQs+7Q8fek1acuyY5yibKbY6frRc5BonjL9i8sf3QylzoBY9jzkp2hfxDrCBkAOxOuVQ5oycWW0+ApO/PRXynO3XmI66W2aota9LXFHUSKtV4sqx1QUQ5+ByExGfQUvs31s7zUYn4ihlvIJLfqpZpbHO+tVioccvlBjwZzXyLxxRv0qBN3ZJqvDToc9VHrcgaEJJ2pAkRFQN6LHUDbSwkw2xJ/i2AwxS6ozTe6Hdpff74WirYnzxCMHFN9tlQrRGOoWeZ28FDod6+hVne/B+3adF1BMdBV+aJfzFpGDV1LXLCbC/NA9xYVyUCaD0JT6UjS7pxtJnALOXLEBBGeLPNQZqOyf7eKjySo7HPUCiIF4FczWxX3drn42K6Mv53xniig9gt96S/PbNwAvQlOSFUc17s8IEx/hpp0D6OyVdg1PtM/TEjn+OjgyE9Rx+WG5i2+XTv/hsd/DRT4vEKDMaJvfvotlpU2h+dzoeoX8yni7xA9m7sGSK0sHKQEJ/Y/ggS/UVNt2Hxn+Y7sNuEePMnEe7kwpQZEVnGe2r9SalAMzA6DmhGiWBmFTOokZLdvEHNF4fVBu4XPmsj/382o3+4tJXjaEuhHg9a+ZeAFtO
 xfjPg1nO
 w1j2CmRr632L1croLRX30/JnwCMvc2eqijksbq3OclQe9Fp3buj5W/NhrMe/SXmU5FTx4+oofuwOFZUEOyS+6x7QGzL+ALxam/k+/LO/1m2g0oYgiIPcG1CFS6ApVJaEvkub2piB7a3qFPXn0fQlJnXeyDAVNGXsoa1qaHWdjx6I1LygMgGLksstz4qWyNDbj/+hmmwwkpxLbTyNuj8hld/k6nlKgqUDIOjnUky362jOtEX7n31BvVCL3BNNW3mwLDwBDlXjFPURhfZjb76Sf0POoLMwSgcGTh8T6JkWt4mIVEeFuy7/RAryXM8lCKUiQhR25agDfi7+cLmLdmh+TYUkEGd+DSFtKhcjeyhwxb3dKTVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 21:22, Pratik R. Sampat wrote:
> Confidential computing guests require memory to be accepted before use.
> The unaccepted memory bitmap maintained by firmware does not track
> hotplugged memory ranges.
> 
> Call arch_accept_memory() during the hot-add path to explicitly validate
> and transition the newly added memory to a private state, making it
> usable by the guest.
> 
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
> ---
>   mm/memory_hotplug.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a63ec679d861..8cfbf0541430 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -38,6 +38,7 @@
>   #include <linux/node.h>
>   
>   #include <asm/tlbflush.h>
> +#include <asm/unaccepted_memory.h>
>   
>   #include "internal.h"
>   #include "shuffle.h"
> @@ -1567,6 +1568,9 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   	if (!strcmp(res->name, "System RAM"))
>   		firmware_map_add_hotplug(start, start + size, "System RAM");
>   
> +	if (IS_ENABLED(CONFIG_UNACCEPTED_MEMORY))
> +		arch_accept_memory(start, start + size);
> +
>   	/* device_online() will take the lock when calling online_pages() */
>   	mem_hotplug_done();
>   

As discussed, for things like virtio-mem or the HV-balloon this might be 
the wrong thing to do, but I don't expect these mechanisms to be used in 
CoCo environments just yet (and doing so would require enabling work for 
them).

So I'm fine with this for now.

-- 
Cheers

David

