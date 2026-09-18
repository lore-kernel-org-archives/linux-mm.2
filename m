Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720B0C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44ADA6B0088; Fri, 18 Sep 2026 16:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4E16B008A; Fri, 18 Sep 2026 16:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C586B008C; Fri, 18 Sep 2026 16:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB27D6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:37:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E6B81407A2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:37:36 +0000 (UTC)
X-FDA: 85228043712.22.55CD925
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C9D1E180006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:37:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TA8QtEdc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789763854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dMJm3ZjQ+ZEzM07+fi70hbZiaOAoeuWuXkc2PtvRng=;
	b=qk+wk8i3PZ93VM9pfI/bUSGamdg367W70Pt38XQUebJ8H7W0ZHFSt/knhLu+8PE7e6LiwQ
	4BCyKryHAdoi+ktlv5ono5/W3W6Sq+b2bPIVkQh2Ex6NRJRDHoA2EBWKjidjvuqAnKrRiz
	tpwDB/wRhbm5r5VcBZpXxgoUCGk/CfQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789763854;
	b=nsH7mBT2xdHijsHkzBdHcd9BJcs09UgGWRMuL4H+uRtkEXwOsrNgyi5IPa1JH2IPaM1xXY
	LV7wKdKaJjoqEMeMnRJxR4K6kAP/f/3Mk/8A/R7NSzUw+dNDubjx5n17ErfzQe9d8S6Oa7
	1ya/YNeMz5SGqL3PsFR+hvsgDq7xBr4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TA8QtEdc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3AD8E6053B;
	Fri, 18 Sep 2026 20:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53321F000FF;
	Fri, 18 Sep 2026 20:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789763853;
	bh=3dMJm3ZjQ+ZEzM07+fi70hbZiaOAoeuWuXkc2PtvRng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TA8QtEdcy2F0tPssdLP6Grp+EXQbWJVgYbobWiS+yfaRhNto37XPC6yydxfJS0ati
	 YN4fk/NnkmXUKF05nS4ureQ7OrBYLmzmgUgdgTt69/E7ZELG1aXjpUGOXfKOm+Q0oF
	 ir70RxL94eq4rHj0GVIOTUZBY07gfXR5p2hoGYUz9y5Sq02iXnae9XyhIWp2dfsiPW
	 nFKd2GW9XpJFGPWvUfTNTkCXp+DAqA5pux1svrvj7hho61/ESPwF/3aNLdtnNp6cNH
	 5EbQZrfTQV0Duu0JB9hLq+eP5bW5bZk64rYsNJNnRiZZb8Z/DQcH89WMZkJjaqPVLb
	 xXK2kKb8zfwrA==
Message-ID: <c0979ad4-9fec-49f1-8442-d90061b79504@kernel.org>
Date: Fri, 18 Sep 2026 22:37:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: disallow raw PMD mappings of the huge
 zero page
To: Lance Yang <lance.yang@linux.dev>, kas@kernel.org
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <aqwPHfWhKGty-Q_4@thinkstation>
 <20260918025214.89109-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260918025214.89109-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C9D1E180006
X-Stat-Signature: nexeif6yh4enuxu3roihhj8dxpqn6uji
X-HE-Tag: 1789763854-252599
X-HE-Meta: U2FsdGVkX195AS0/gCiDyG29EOw1Wk5nUqI6zR8zWJZV5lhuKkZMNzcHmzp0p2XYt4Yn5SCqQUFZw5qm30Twy468OixeUwO9dtuDzakc5RMlqcz211imUQP6+mJQSqK+NyBU9RVDCGUtUYk4E6538I4JAyQFFt0WC2mNFvC1XVyoYnLMbqxHpBkUpL0+oep7pOxxlr3uX96lsG3iW9jF+jP8atZUYKpZ63z5yLAb+4/vAY9wtP4QbXz0HX9MPStVdpXjMm4+iOPsBXqfCvoNQNsYzUE2UKzhvF2jBke1f7Ww2LXU2yXNYNBH1yDxJlKnUcyO7rpK/T77qvYh8s45U+xOkNL7qeWChTs8RL37C/1xdAva4xfZ8Gm54aWa8HOivPkhoO7Z6z9bl0+Va7fbo8c/N7yKCm8X/OUxYaHA4V9BbgdTiYUOJFkRzaUVz+Fbgk4P3Bx/cIH69txCRsx9ZFC2JIcnCIAWwX9SfMrhQDQx2augHm+YyubsmizATzsbFNSuEHh8jxzj2L+ArMzzOfa3dKlYs1UPpkewu+Jw9jBnTDtOb7MxsZcCz+Bme0UxBtjcQtG6kv+F2hWUHGLy5P98WYDB5SHueKFEWjchtMd8BCLdv+ZSZRzkAqOYSMjmli7q/oXepchRTx+sGwClnoLxhn/+daGS2Y+v3PghId0sKpf8zZU4gFiVsR+qrOjhjXFj4xTCA/1Wp/VEWLvm9RpdiV+ZhZd8BzSrkbD3dJdn+9aHm+mBbj91jL3Y/izlOrBmjMUARY45M5TWTYJsEWLZlaSDcKYpYVXAzzZrrsJp25KPzFYiOl7iJzfleRbh1W8cio6KZ9Us/BolDozvKt/3S6aslxgzsbBIJdYQNcOBvqZzcgYTGtTj4wjKR8eu54WsKJdxORCfBMUJvheXeX3HlxaPac+1gdht7elViwcP0D6Fl0K8ZZKjLMIvYfxTBMuO6chan6qBItRKwLA
 CM7W5wpb
 Sk5xzwNunRb3TS91AQv5Cnm5CjAChDB2GXzZJDmhRCXLltMcaNPLgnO9Xze+RxDNUoiA9/8x6bWEyUz5E7eQPbON9T8qrPyz9extcJUWiVNyrh/ZBl4MgYijHTqirGGJNAdF9ClDMThQGrymv+Ao102lBNJI6gdQoOa++ysMGg2NM2H/5uNq7j1Tl7Sp9MhOH6zjUnIE+uf+ui1TkANzDavd1/cb1du9ozPruf0+XyDhR8pOQ+304UumzMhLNG4WJKaqBJ7HUKvj9PHJpnlytg3dcqA5ggADvs3oktWlkPfh/jp9KX2/fqK3d65ci9w3o644TfomP5vlqilQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 04:52, Lance Yang wrote:
> 
> On Thu, Sep 17, 2026 at 05:03:09PM +0100, Kiryl Shutsemau wrote:
>> On Thu, Sep 17, 2026 at 05:29:48PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> Why would the zeropage be a problem in PFNMAP mapping?
>>
>> Nothing enforces that it is read-only.
> 
> No in-tree user inserts the zeropage through vmf_insert_pfn_prot(), so
> rejecting it there should be fine.
> 
> Something like:
> 
> ---8<---
> The huge zeropage is reclaimable, but a raw PFN mapping does not pin it.
> A PMD mapping of huge_zero_pfn can therefore outlive the folio.

Well, just with any other folio that we PFNMAP, the mapping would have to hold a
reference. mm_get_huge_zero_folio() can be used for that, or just grabbing a
folio reference (not so nice, but works; GUP uses that, for example, to keep the
huge zero folio alive).

> 
> No in-tree user needs either mapping, so reject both with VM_FAULT_SIGBUS
> rather than risk making either shared zero page writable.

That is the better reason. You could also just say that handling shared
zeropages correctly is more involved (see vm_mixed_ok()), and as there are no
users, we can just disallow it instead of trying to fix it.

> 
> Link: https://lore.kernel.org/linux-mm/f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org/
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

-- 
Cheers,

David

