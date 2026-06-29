Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD99C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7046B00A3; Mon, 29 Jun 2026 17:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088E86B00A7; Mon, 29 Jun 2026 17:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E930E6B00A8; Mon, 29 Jun 2026 17:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 809036B00A3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:22:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE665402AA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:22:26 +0000 (UTC)
X-FDA: 84934223892.13.E717D42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 196D8A0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:22:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NSvLJOCO;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782768145;
	b=kVHmheuzaf0dWsPr9+9GVS8enfsfbfqMUfKQjuDQT1pXmw/dKwDVFbnoVTfyY+uolW+H6x
	mofHkaswfmzNkRJc+KM6qgILALJqPAyPd4NXzmhC9BJ8/0XGqR3Fl9pyjnS5PsYDADXghZ
	cw3YbqN+wkfJl4DAZ0esYrI3OIQESOE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782768145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DsKzLp0iajc3TprnR4iUFTpWIrmgzWYe3O4RXVVhuw=;
	b=jzHVwuwyHGZ44OGaAChr0Ur6q0GAM1j9VuC5h/zrlSLXlnlIRpJzLZT0H05BsvBsIek5W5
	YLoe22wQp08Ve6DPu1iY/U/SAIf7ERCd9tbPaiZTtfM//6vPIL/GQoCoilr0oVlwchz5RT
	qtVxmTGfna8/VQ0zmyFgHwHUkJP/Qs8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NSvLJOCO;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D42FE42E4B;
	Mon, 29 Jun 2026 21:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B191F00A3A;
	Mon, 29 Jun 2026 21:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782768143;
	bh=+DsKzLp0iajc3TprnR4iUFTpWIrmgzWYe3O4RXVVhuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NSvLJOCOaVxozcf/M+fjwaViciEGuC2tYFTCtb/GTVmfjNDN2Bc/SzUdzKJsXuemH
	 L7LN0TlR+SaWVobstkPJlsukKGPdyKy+5LDHqsVIjKz/H4FvSMF3Ye9htgSP1HaFx7
	 XPZDmhY659xd67EjNgf7MCrXFuxM9si0+LNqNOtf2guL0DPqcni9ZjVUzXhKoRbKVA
	 AcgWEB1/N/ti48jENpJYK3iJcds2kKwfTnCntYje0cHRr2cQa0v+1fz28QjTyp85+H
	 S1VnbVGGgakHrnKeB8beWt2OVjRR8ZJxXB+HLpqyU2tEtLw9G1t9x4ZAZgDNBQuWCj
	 tjc+1suGQqBCw==
Message-ID: <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
Date: Mon, 29 Jun 2026 23:22:11 +0200
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
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629092856-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ituis1gdkadpj3qjj8adgq6w88rpi4aw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 196D8A0005
X-HE-Tag: 1782768144-378182
X-HE-Meta: U2FsdGVkX1+WBQPThNWA70Q85bgcGGAf+LkWahHgNF6sqnDc/bnnzX08+C1DivzI63FK7DfEwdSJ5tL561x0eE8XFa/lqNqyszabvEl4mjnKuihe9wogfSbyEBUT8CcJd3Tcc8ZKVzfJZ1Ll/DqdamVqQgnq64mNxywZOTwWYgj8bR5jnorMwNscX93KCFPotYsMvZk/mbRn7KwisoAgbRxQRFOuNDV0IWnB6jA8SocO+i0CKIv7fg40XMGrIqmgswfaiifEpOneIQsZPJsh4oMRdmtHauPsm7ZH2GAUrDIAgiXr/a+woXw+MJPIfzE3F/Bu+qdKAhrFLF7LdBqm2svLMRZj1WBI7z3VfdlblfRa86pMrMjvmfrr1OSoyzJm+qY4KS/dVxUt/1Xe/9gKHprDbZf27E5MJDLJJwuA4d7NwKxWgp8X37ZODgRIdGh7X25kPicyaiaOOSiz/H/MZlm6t2fydD2pahYGOGMgEDUYEZmTdlxCoRjKtUDjuhZZ+60bcsmYVdRKyzBWoNfIUPewP+lktFNGGKwQQKkXqfCbMUv93rsbaxqSCK8rfu2HpwhyIjG/jt1u0L8I3f5/P3LS4exuCzYfmYlJM3SpT5q6N9Md7uW62MFTLnn6JTe/fBOHZ0iAJlygOcpEF7SoxraZ+uScqzGU9LIU3mlOnO6a7NGCnpqi3jlJfrAfC7OYTgBMe4cxxMEmnM8ft3buCKcp9sSrk2+mBGCCHFv907Msb7fhRjQtVlALanTMnLzwMSF4u+wjOEYjiLCOCXEfsBZ93MebUWpuHtIWQRwp/a/ecr3UF5vKKsNLYeKiPGYsTKhsIMjHCX4hK31jP2wHJ5ZaSdBf+eUgOTfG1k0gfiUFBsrJFAjxHXhcXDjdbbeuISbor+Rp7sOEhJ2irgA3nYYL1aHz+2DsOsuRfTLXNmfV6I+GP30apw0DoWIcitoDe+tMZ0wygBADUi5Mj4K
 tRQIJc8m
 +gmZNmTZ5snas13XxYbbKuIDQmPk8OPaSi+bSuZrY0q2Hju2js/382YBckdVREL9LxTelkBHHAbGwmZVu/uRc6ILxNeGDANungA8F5Pe0VDQTGdzvGvBCISkdj4jSiyYk+XMNmtuNrZn2TOPcQ33TKv/21vOrUkXyvjkgPm84VJbWPjB0iu8HELzAcySwIpP7yK7FpuqkpCW6T4h3yQjZCQZFYjX0KV09gUpuGeKiH6Hp9XgZ5HSo0kStGSjMFZeXbecQPB9ZqmwL0wPU08wH7hXo80GpYgFs6r2m45Nj5+fV2tWttDbZnjBi9+LXuStlDBJSyHa/Wq737ifkNPmHlY/GaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> 
> And again, I'm really not sure fixing a theoretical race when memory
> is failing is worth slowing the world by 0.1-1% for.
> 

Fully agreed. I was hoping RCU was cheaper (I mean, we were once told that RCU
read side locking is essentially for free ... well in some configs :) )

The question if we could optimize it reasonably enough ...

> 
> From what I saw in my testing, if we allocate 4k pages
> it's hidden by the overhead. With hp and thp it's measureably
> worse than rcu on !preempt config.

... for example, by doing the rcu read lock + unlock around the

	for (i = 1; i < (1 << order); i++) {

loop on the alloc path. But I suspect it's not going to make that much of a
difference.

I concluded, similar to Andi, that stop_machine() is too big of a hammer.

I wonder if something could be built out of preempt_disable() and sync SMP
calls. hmm :(

-- 
Cheers,

David

