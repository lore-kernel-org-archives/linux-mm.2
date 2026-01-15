Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94511D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088186B0088; Thu, 15 Jan 2026 12:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032236B008A; Thu, 15 Jan 2026 12:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA49D6B008C; Thu, 15 Jan 2026 12:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB7136B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:46:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D4081AE4F0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:46:59 +0000 (UTC)
X-FDA: 84334928958.28.49B2519
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C9E14C0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:46:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KFP1W6x/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499217; a=rsa-sha256;
	cv=none;
	b=Md/vo8jY6kbBCeOKIiSdyfRyCfwBxQ7a6H+kIbFsFPsSUJXJ4pI+hQoqUN75cOX6iUWqQI
	4EcSPpNsKmwhfbGiGYLi0PzEbKqQkTLoex1VgxWIVNHQGSFnabK/zILgyXuHq0i6THvXg+
	T0w6cPTebDkyuTd3r7Z/hH7ZaEe7Z/Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KFP1W6x/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KR+pT/w1oX/d/81qz9tRA3q3F31egcf27njq4eoxy9Q=;
	b=yHpW+4T8CaKJ3eWT3CpwGf/4oFyInIKlSTOvrnL7CvHq1fGrcBbB2To2Dc6ZRUdPdE8bzK
	s/PgSqHRRB/40AZDP51kFAsd1GkYaa1zlC9rgAHqvsa5x6nc5003ZyodY6vrcDTa+Bath0
	zYTRKl5MF2kHrGVdl19P+NYxOMW/6/Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5A0D60167;
	Thu, 15 Jan 2026 17:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E7DC19422;
	Thu, 15 Jan 2026 17:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499216;
	bh=1jCsql1xPHh3+qu35hlAhhhfPTnN6RZGCJEvT2TxyM4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KFP1W6x/Pz3GfQ7syb6LWx01LhNQFu7ZunbJ85ZxOyaZjBUduvM7RCWvy4LTQGegz
	 O8Oma9KSnm785HJoUpbeHBFJeNzZCPLriM43cPmWAPAxTYA2Y3UpPACogejUfAgTO2
	 D2JTivRHZJ7aac7xUGG2udcTzxcFKpDVs7GpY537HdJES86/qV9wF+Gf6PbyNyi343
	 7Ovh20HYPAd7Eeu1HxthMVtKbomE3KivtlKMrG+Tj1LY0srLIg+joNxkjE0lBv/ILn
	 Jlxx3sIfJI3gAaA0oBQqM7XiOGxA/wY7ZdDyXhDn3HXr+ENe5JWj3tFrwD3zznzvBX
	 XpgJmsyo45Vyg==
Message-ID: <df04f6e2-39ee-46f0-984d-54dcba16a011@kernel.org>
Date: Thu, 15 Jan 2026 18:46:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] add runtime hotplug state control
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114235022.3437787-1-gourry@gourry.net>
 <eb3e6ae9-d296-465f-a5a9-963da4d8ce6a@kernel.org>
 <aWkm8zVc9zy1w3eM@gourry-fedora-PF4VCD3F>
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
In-Reply-To: <aWkm8zVc9zy1w3eM@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: usfew1jodf8zpejcfo77z3mcbt3ethgu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9E14C0008
X-HE-Tag: 1768499217-912279
X-HE-Meta: U2FsdGVkX1/rFTUqv1vEpeR2f9XShjDfBtxVZ+x5TONDX/K0uxE+HWLnQcHewJTle+ElzF20fKlrcOXYCpV/sMKMXZTURCNUeupOSZalJAybucUs2JURmqUn+JjwmXk1n7HZH1NSl00XUWlQ5QgSqt2C6nQwapiIT7VkSR6uzKIUgeSdAV04mW3AvXaCQ8N/Jt7k6uhira3C2ffc15n+AnuVjlE1J6icbPXSoD1q2HqEbHkjcSGaPSf9Uj/+aqV8MMUK9O1/on/mxBG0R+3xNFqDm9g0eKQ7/8jHJiB+gxRjs7GVz+FKVGH6VwAPMrXTZ8IIP2yagJqhXHVv274b+uxExRCRMbQeDJuZ7esZtxV7gmcbRkBbVshLPdpQ28i455gXTrr1dv5H7nmSHg2lxb5tXO5xQw1PyGPy30OROulpC9NbxFoGUhNQ3YAzwe6MrAzMWK+7OKYVkRnWcyu/q2EiMT4xArVYP3EZBmVc5CR5XzeO7XaD5LzMTJeA/u61jop8/FfG7hx5MbARt4FxLIMUu+Mfik/w2vyLN5VF6/bWv6LQELwzuzDdcl0m83oLgeXrNMq5sGIjPWFF+6bPN4EPsoJ/vDTjRwbjbog2g+ODKNTITqL7BEJt7dejJvwlPZ+gliFokY3P+le1esMI+VjiwqVxG9p72gkUWSIQpj963QwoTwjyce3nbSA5wWLnlwLgKpoQ7SxWTwpVHzb/XPW3706qIF7m+jAi2gm0YWM1W/CAwEXatq1ODlgIOC/EaAxH1GSjJqkJkr4sac187oLfKLxPmvDOztlxtviAPWxxPScFurW1L5bIaT56irZIZE6QunySwxiOKhAvneUYObC9EYDzO8drMlPbLbvy1Ke4pHpYNhs+58Ftvtsj+iVgJWB2/586/hQ1LcaDhWO/QxXYGN+FFTwbKj2vDuegTU7Yfk0HxRety++KpHrqYK/kCcAWbydDdfphxDzqoqn
 cz/PppOg
 ndLV4QiyPtb6Ml1VxPexHsBhGbLblkYCgU7rVsxAlIFnFEfr041P9QKJxgHWoSJZhg7uvasUIstAkrpq4Op0t7ZDaC5wy/0RWZR56XI1YKRCMGVO6u6v5wxIEQIP9ws3XVfC8beN4vCbCUEU3t3AtJepglzSNzSufnExLmyorgSzg5Gj8MeWbwbZECu8TjGQDppiKjSx4m8Utcitptu19nRgsUyK8XqX28lwl0Ks38oIarrADfP1fwVhi7b0XF2K+zC/x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 18:42, Gregory Price wrote:
> On Thu, Jan 15, 2026 at 06:26:21PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/15/26 00:50, Gregory Price wrote:
>>> The dax kmem driver currently onlines memory automatically during
>>> probe using the system's default online policy but provides no way
>>> to control or query the entire region state at runtime.
>>>
>>> This series adds a sysfs interface to control DAX kmem memory
>>> hotplug state, and refactors the memory_hotplug paths to make it
>>> possible for drivers to request an online type at hotplug time.
>>
>> Gregory, slow down a bit please. I haven't even had the chance to go through
>> your replies on v1.
>>
> 
> Sorry, i realized your feedback on v1 showed there was just too much
> complexity.  I would ignore v1 entirely at this point, this version is
> significantly simpler.

Fair enough, I can see that the complexity here is likely reduced (less 
patches! ).

> 
>> I'm currently on PTO and don't have the full day to review stuff :) And boy
>> oh boy, do I have a lot of stuff in my inbox.
>>
>> Maybe given this is the second time the patch subject is suboptimal is
>> another sign to slow down a bit? :P
>>
> 
> Apologies, and I will let this one sit.

Yes, at least wait until I had the chance to reply :)

-- 
Cheers

David

