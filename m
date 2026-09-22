Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A4AC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046806B00A0; Tue, 22 Sep 2026 05:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01DBB6B00A1; Tue, 22 Sep 2026 05:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75A56B00A4; Tue, 22 Sep 2026 05:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C76236B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:29:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56FF9C03F7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:29:28 +0000 (UTC)
X-FDA: 85240875216.16.DF551B1
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf28.hostedemail.com (Postfix) with ESMTP id 045D1C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:29:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=stpcFFVU;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790069366;
	b=5uTb55nIxkECCzhJtq2fFUPTk3fHf43p6Mym0Tb86BPqrh0losnEcIP1DbYOf+4pJFrutI
	bz9XQOkl2H2QOuj4HhWLG4tGjJaaJrrtZThCBwTmGWIXn72aO+atxFaCeQmznyKt4de6of
	9YG8xNA91tTZpwz1xzXOemiSp906fnc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=stpcFFVU;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790069366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGkT9Ui8IWBvThLwNwtH5JiFUDnabT7ULMWL9InJHFU=;
	b=DDdh0qDWP4XdA0Fi6190o+em+A03VQY1EplpRPpNQgg8hP1nT7vb14KDwxs+JQBucZ+K/F
	5fNOSyEhHCNjdCnrz/guTB5DvS76aZuNdbpmWYE5CI+Tysckd7Vcc/y5f6oPmSbjNFXXkd
	etsHgs8rmOW+izTIay/tsvHdQRYfZec=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HGkT9Ui8IWBvThLwNwtH5JiFUDnabT7ULMWL9InJHFU=;
	b=stpcFFVUA5sWEn3kkPHrfPiLr8qBRiZbNZDh7aVd9XnAuytPymZceOrcl8vSrbJBulCPVDCTw
	olYFpOv609kH+6MaWDjwTkqVpeODVsVsPvdBngDQ3tJ8srYzmm23k97FGyQxixbsn8Vuj4RMKxU
	zUe4jbOpnHoBTAbKsk4aHxI=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hpvd5362fz1T4JM;
	Tue, 22 Sep 2026 17:17:29 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 69CFE202E6;
	Tue, 22 Sep 2026 17:29:19 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 17:29:15 +0800
Subject: Re: [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages
 out of the next kexec
To: Breno Leitao <leitao@debian.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <rmikey@meta.com>, <riel@surriel.com>,
	<harry@kernel.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <kernel-team@meta.com>, Ard Biesheuvel
	<ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, <kas@kernel.org>, <kexec@lists.infradead.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador
	<osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
	<hannes@cmpxchg.or>, <shakeel.butt@linux.dev>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
 <arJBkNOgbR8NrgFP@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <16baab50-692c-308b-d60d-1b0a328df1e3@huawei.com>
Date: Tue, 22 Sep 2026 17:29:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <arJBkNOgbR8NrgFP@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 045D1C0002
X-Rspam-User: 
X-Stat-Signature: uc35sdj57yherjxeje47okbg4kpicspx
X-HE-Tag: 1790069364-356119
X-HE-Meta: U2FsdGVkX18E7Ib80O/xkcw6hAT/EuEDFfW3p2b1GHkRgc8zRUBTJODDHgQ+hI+ldNLBcY30kWrqAX+UIPERZulIAN87J6AdjKgi/oW8gnBawvqMXND8PLfx2E8Yj+QwCAwxnYbUV5UVaNa3Ykd3Z+LVuJtVNBvYVwqcICPrDRAZx67pDHO7D6rkXM4Q7KgD/xy5QGbB6ITbwvlbLhFEqcPioTLJbvGQG4mS7iV5s9WodZ2WoJW4Ox0BNfV3Y/PQDPen492jeE6MfN7Wq0n8hdsxknr1LgCqAD7Y+07MpTWnTipe0cIuYXy6RLMluMLdhg5nkIkxKOr+rk8MCEU+QJrlUggzEfSgMkspd9n6qxwwOF+Zw3Mbs6BZrfbeH+E+MV6YER09mHKMXX7/paJ8UwlU2+NrPxy2PA5FshLcMWd83Cexe8XZizpXOtuE+OszKnBCsNiHaMtFkVBMGw3gaXdMFEOb+TVz8xH2RLl0+15n2su3KTuo5Fq7MH5Ea5M8aZ087LOoWA/M7QYp/XOfRzeGFvvRwNxhzEp/7cxFGM6IxJol2PeODpuG1ghIgwKW1KUKdEGDsPBFBjmj3MLJzoEI8WimWZehp+7UodtrIfYNByNRMTwlHyBUTzxls43e/ULnmFeIG9YFfFFqMg5fTDzrsobhnFjPjGRuITs5A3ntLPKPCHWUDPj4h4JI2QhIA9QyliHsroR1vjEzcv0lvM281nGLIB55VHR38YQkxT0mKR/GpR7AZ3EI6fp/MYM+XP7ZDpvBhFJ7MAsb9vP2pS+HWYRCi6upwOYNBSlb2S+14kYVN2mihqD2CIPAVoQXsML467y5P/jFxrVti+O/upqCUq0qp03HSbHLPpok6I+6sv6gJpNxmf/9OqXb0Lh2SSJio41XvVvtejjHlR0vsNbFo4Elfrp4MRgpGT99jGKeQM9H3CXcgCLZ4uS5yHWzEShfraX51gI3y4zpnFu
 m4rFCqah
 +RaNnEJTxi/Un4js63B/U5+oR0V3jevkQNXKlWkg5IHNgpSSuxXU2gOwHdk8z+xF8enAdSTi17kL0jdQKKZLzwBMntxgKTWB0cqGonkn0wXjLHzhyr20tE8he4thu4kKfTsL490KxfJdjNYF9St71qAGHOeOtt4JftrncaPm5LUdMvLJWZjacX80ER8A2lp7+blqyPi9EIkRnURR1uZk7zKbkUfhQEXzBLxQmGh4E90veQJE3K6tiYJw4J+7zcx6m+Y1ga3LjwESknHybtImdcfqWikLGe/OONPvg8vmwcfYCCabx4Otv2SVz801liQs5BloRnTeHKRFlBLXRYMkZ7hnRXto0x4yQ6VV1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/9/22 17:14, Breno Leitao wrote:
> Hello Miaohe,
> 
> On Tue, Sep 22, 2026 at 02:27:59PM +0800, Miaohe Lin wrote:
>>> A bit is never cleared, which is a known limitation: it stands for a
>>> whole unit, so an unpoison of one frame cannot tell whether the unit as a
>>> whole is good again.
>>
>> Thanks for your patches. I have a question about unpoison: If a bit is never
>> cleared, after we do some memory-failure+unpoison tests, kexec will lose the
>> tested memory without reboot?
> 
> Correct, A bit stands for a 2M unit, so every tested page that falls in
> a distinct unit costs 2M in each kernel after the kexec.
> 
> Worth being precise about the state today: the unpoison itself works.
> The frame goes back to the allocator and num_poisoned_pages drops. Only
> the bit stays, so the next kernel poisons the frame again. Test loop
> in, memory out, and nothing gives it back.
> 
> Important to say that nothing block us from unpoison the bitmap, and in
> fact my initial patchset had it. I also _think_ we should unpoison the
> bitmap once we unpoison the page. 
> 
> I have just kept it out of this patch in order to simplify the patchset and
> get the basis correct, and then evolve on top of it.
> 

Makes sense to me. Thanks for your work.

> That said, If you think this is a must have in first patchset, I am more
> than happy to do it now, but just keep it in mind that it will grow the
> patchset by about 2 extra functions.
> 
> Thanks the review,
> --breno
> .
> 


