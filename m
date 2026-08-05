Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C987AC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8946B00AA; Wed,  5 Aug 2026 05:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8876B00AC; Wed,  5 Aug 2026 05:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFEF76B00AD; Wed,  5 Aug 2026 05:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFD026B00AA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:51:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B9564041F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:51:17 +0000 (UTC)
X-FDA: 85066747794.14.28F57C3
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf11.hostedemail.com (Postfix) with ESMTP id F112C40008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:51:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="jH/beg/h";
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785923475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAxC4YTMr3xtaFtujHMyZqm2zshOuBu29sIloAfmWcI=;
	b=lJ0xuU4rlE/fM/weX4gMqFOoVAgXz6ElhacGHxQZuKbs7XFOpnHN3gFdzcSLoLZQdCYT9L
	YEpu85pjqRuoSBR7PsHK+IulsEDULIAcfY0TMNmJuW1J5++/plAHXyhPdhazvQTOojwL35
	kDHh5Ssv5P0ouykkmreO41iB6jFkXLk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785923475;
	b=FBTNzUzpoFOHXVpVAt+hZPJgH8wcDwtcNquEUNcj6UdPdL9acciMPV8bdvKWfwDntQNLgX
	DGdSB6vztuAh21IeVgtXCPyMiCgT9BByRa5BgQQBrMpgb9rAI9kng9pcZ295+se46oF2mK
	PO/TEDYTzzws0CqInZCLlXJyiIDuYgs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="jH/beg/h";
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785923470; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=kAxC4YTMr3xtaFtujHMyZqm2zshOuBu29sIloAfmWcI=;
 b=jH/beg/ha4wPgDRvR+8MrMPV8+6y5zsz6MNSTDJGN1sdn2U6FT6H6+3DQta+MYmDeZzvQ1
 2WaRdAD+dPbO53TKaC38zBGIb98JvC8qFy2OcwJNv7SaFvjy31l7c8HhY9D5eEGLLXIMOy
 B7AW8gwCKl06VZ4PO68na5uVQ3r4yaqCwivkB7Wf3omgg5QAi/rghyAYoZU10rN1cBAHyU
 wlHIS8ffrnpu/9pT8sHmgPdFY8IwgbJsPc6bjKS149Rm4OlOOOgw1+fSkvj19Nm340+Q0k
 vTd9dDprqPCezT7Pb7RU53L9eYHz8I/Az+e5rNcifyNjNhqHQGs707hs/Dg5GA==
Subject: Re: [PATCH v9 4/8] mm: add a template-based fast path for zone-device page init
Content-Transfer-Encoding: 7bit
Message-Id: <93090eff-7961-47f8-9373-787f6a0f8da4@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: "Muchun Song" <muchun.song@linux.dev>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 5 Aug 2026 17:50:47 +0800
References: <20260803070929.86075-1-lizhe.67@bytedance.com> <20260803070929.86075-5-lizhe.67@bytedance.com> <CB22DBB6-0B52-46C2-9A19-4A18A6F6DEC1@linux.dev>
User-Agent: Mozilla Thunderbird
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a73078c+2fb597+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <CB22DBB6-0B52-46C2-9A19-4A18A6F6DEC1@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F112C40008
X-Stat-Signature: 4oe8c4gxk1pozydmho9y9apqdx8a3r6d
X-Rspam-User: 
X-HE-Tag: 1785923474-452496
X-HE-Meta: U2FsdGVkX19NrogtSBj4eW3FrRtTSUmVjDCUh0y28zgUezAt9lkN4SLxiKTHoBa/wc/nBLApULJVLDQY2blPrhnnV040lIwceTl1+OA9uwtsAL+O/r4J0DkkUnoepfMKQ45PnPRdS4TmBrXS06hiH+W0WoKsMBXT1zlYjL/nXnxq3DVbQA2m6eXCWVSfeSk0f9OUqz9g7wDLBMonwqLeFlCKLEnfnkUbQS1/kHAkB+ye+lTdVfRz2gydeZrA1DRitxJ3xPBDqZjmuW5AHVR5C3u3UCLyKZ+pPuSMV5AmJXPgFxr3d+JBAiy0jbAKfOMx+i711zxmi23QsZVwu22YVUEwxTXguHxJMTaH82N0otDj7/WA+noNsg8DXHHkbAjeO9cpmSLpQyxF1+2QGPhTD3GIjyP/XUgY9X/tSXMBLjq3Gl42jQQKZ/bsfZUV53njZiWEAIUGL4ca0z/1V5RXzTjqvfsGwJdQndKAj//Kl6tmeEqa/ngSB7Kzq2YqR+cAO3o/TQULWPNNprLC1R0zH0cBGEuT+hPVqIO1+RJiAss0hPuLBFUTNRie5gpFAIoeSwbLsTc77+xizuIYX8LLtDMZ5dwpxXztNGRsGWq755kq2pKGXrfqdwHwo6Vn+FhtcvyfsQUU5wT8Jzo0WUrgkluiDBsWAXyjFHvzoPBk3VrXAFAKaI36dbEEJBnALDQloVor/MBxbW5UULclSdGFdw+5RoeEuQAfbXRk+xF1Tq0JzM8GJ1VN6Ms4frEfsfw0++z0MsACsuFVRedbtmdimhPLAlCwsEGFwjCTUko3aDZNYyg+gQHgyxK0Ve0KoqNc1SrRXdLu1GQ21eBIh8xFF6Quy2SmQ/cozvhjcCvnBTDifAyDit7P70OP6TVUK55RJhz1sTCLGzoiYBoNq9aeK6pgA3kU0QUjF0MmaDhDYRqLpGirGCmjAIPTpH9cu1QjvVxHk2j0I2LA/Yza+e1
 F6cWLcO8
 B1f5+Ipsl4TIh3TWZZk/liTArinHblVG84B9a5icNCqcCXl2UIgJtw4xN4H5Bb/UfYZfE9WK62IPaypm5MAI9/9KRuPJaYsBXiPbmbfiCt5J1OFhaJ0YmkttzfhzwRSl/DSxDmSwfOftDDPunXUJzkCM2XRbn+sFFaHBx5g/vWdO5eEftPsw9NK1ZCf9roGtjfNJJdzdOfwglPfPTQoykJAErtyAeDdBMYKe8MPYuzZgHQS/5H5brX8ZnCpj5W5Puuc7y40U25VbpXT2lfxtm6nE2jHmQGLU32P1PCfZXoRysNbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 4:39 PM, Muchun Song wrote:
>
>> On Aug 3, 2026, at 15:09, Li Zhe <lizhe.67@bytedance.com> wrote:
>>
>> memmap_init_zone_device() repeats nearly identical head-page
>> initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
>> template through the existing slow path, refresh the PFN-dependent
>> fields in that template before each copy, and memcpy it into each
>> destination page.
>>
>> Use the template path unconditionally, as suggested by Muchun. The
>> page_ref_set tracepoint is primarily a debugging aid, while this code is
>> still initializing struct pages before they are handed out. From the
>> perspective of users of those pages, the initialization-time refcount
>> transitions are not part of the observable page lifetime.
>>
>> This means page_ref_set will no longer observe every initialization-time
>> refcount assignment for copied ZONE_DEVICE head pages. The impact is
>> controlled because the final initialized struct page state is unchanged,
>> and keeping a separate non-template path only for this local tracepoint
>> observability would add complexity to the common path.
>>
>> This patch accelerates head-page initialization. The pfns_per_compound
>> == 1 case gets the full benefit here, compound tails are handled in the
>> next patch.
>>
>> Tested in a VM with a 100 GB fsdax namespace device configured with
>> map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
>> path (pfns_per_compound == 1).
>>
>> Test procedure:
>> Rebind the nd_pmem driver 30 times and collect the memmap initialization
>> time from the pr_debug() output of memmap_init_zone_device().
>>
>> Base(v7.2-rc1):
>>   Average of rebinds for nd_pmem driver: 244.28 ms
>>
>> With this patch and its prerequisites applied:
>>   Average of rebinds for nd_pmem driver: 215.55 ms
>>
>> This reduces the average memmap initialization time measured during rebind
>> from 244.28 ms to 215.55 ms, or about 11%.
>>
>> Suggested-by: Muchun Song <muchun.song@linux.dev>
> I personally feel you might have used the wrong trailer here, because it
> implies that the overall design is based on someone's suggestion. But for me,
> I think what you actually meant is that in a previous version, I made a
> suggestion about simplifying the code, rather than dictating the overall
> direction of this entire patch series. So I feel I shouldn't be credited here.
> This information is already enough just appearing in the change log.
>
> Muchun,
> Thanks.


Thanks.

I will drop it and keep the simplification note only in the changelog.

Thanks,
Zhe


