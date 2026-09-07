Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE06AC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 01:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74A96B008C; Sun,  6 Sep 2026 21:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD816B0092; Sun,  6 Sep 2026 21:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0F16B0093; Sun,  6 Sep 2026 21:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6929A6B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:13:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01B201405C9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:13:23 +0000 (UTC)
X-FDA: 85185193128.13.4CE5BED
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A1E71C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 01:13:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qXSDWIRe;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788743602;
	b=H3l8neKD1zCxltHgAlLq0WOvR7iiaWciq4ySZ25Ip3h8dmARh3Sh0nQUrVSICpThLIdFCe
	Uc+u7e9aiJcFxbJcaJSjQQa1N27f/HLUbAveoD4sGQ+Otj18Nggx5sErOKFWNTsFU9Ns1j
	2UC3TEVT0bFTCkqHOqwBCN3CL4q0IkE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qXSDWIRe;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788743602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BFujhiSfi1VZiiWblY8FsVOoevMDyPEUnh4R3GphTY=;
	b=mj4XvN9QcHp4XOBjB1FyJwlAow2veJFe6C2NFAEngmMS+Apa9XHjntJwNYWd3zOu1mesNk
	1MJKmiup5NmdobpeFzZD9HczQHHPRM2hsL8WTh1/Hbvhe73Uqmnfo4GFoxosF+yAtp3WLz
	n87q1Qfwi1cGTrf/k7muN5NyVYJtYHs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1BFujhiSfi1VZiiWblY8FsVOoevMDyPEUnh4R3GphTY=;
	b=qXSDWIReaiMuZ7TvMKzNNHHzxGAvVrTTLIGenrPeiP9rl9KvY5ayD3DhFw8XFZ7FYAkG4+x0V
	bx8nqos0VGOYdXhiN4uqAOzN9mhjgszpfsOnhnkFPzvYg6/Y6b5k3BHcllprY20hrTFGB+kkbAS
	cwIf6fp2yVah+YxdLpp83qE=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hdTLl620wzLlX5;
	Mon,  7 Sep 2026 09:02:23 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B3F1340572;
	Mon,  7 Sep 2026 09:13:16 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 09:13:15 +0800
Message-ID: <c44f462b-f807-4112-8ec3-77c78db38a60@huawei.com>
Date: Mon, 7 Sep 2026 09:13:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: Rik van Riel <riel@surriel.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <harry@kernel.org>, <jannh@google.com>,
	<lance.yang@linux.dev>, <minchan.kim@gmail.com>, <lwoodman@redhat.com>,
	<kamezawa.hiroyu@jp.fujitsu.com>, <mel@csn.ul.ie>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
 <5cb70d43baa959b4c0d1552d67ac5d4b4a17cd37.camel@surriel.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <5cb70d43baa959b4c0d1552d67ac5d4b4a17cd37.camel@surriel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1A1E71C0002
X-Stat-Signature: ufio84m3uoycharhmwn6c9sxipz7ts1n
X-Rspam-User: 
X-HE-Tag: 1788743600-616577
X-HE-Meta: U2FsdGVkX1+rUTAv2/+UV3Bl4daRiQsBEiHPQrjlxMDluEXCNt018xlM/MfKu1zxobcVBDBTXMLV7BUY9jDyt15NF6AIUB7geqUqeDGcXvzKf+cBarstzSvMJD20UhLcWzBaXWuXiijK+itzyRDmXlxVbFj5GXLSwCvyrHtQGWQVq0JilWDgtxBzPwfHQjKEq0JFoAweuIhi6ggDg1wp13Qiuc/YKe4kSoIbqmnJojBB4MynixyDiHEp1bcYI7AKW1JSrdw1RwW/8eC2xlr0BNF0Lb0/I353KoMggJZUZ5R60GgxxWodaUAKTZwrldvVdGRzvzqomHLwsQ2LWNjvMhoXLhxzl0HBpGh6eC58Hv/RGEWgLI9pOsf8ablf+WAtEUc9rvFJfq54Nv/nTtlNOfRpW3L5NHtcJ1k3iF8zN5M7yisBOrhzih9j6+gBnpnCoNJ9D2/ZBqiHB+qfe7E8oCWDo+PjwajRGGRFCMEgiSRB5kN2s5N1NHXvs0y1uSt+HWvYozpheh6XE1aMFmKIJlreH1GNcB9MuOphbD2L7zEbfS46wxzdkm8chyMk42vGWUAMVxztPBvgnwW0qpE7NdzzZnB4Z5ahy+w8QI6n7ssaVkCfueD3KZ4shVHX3dttbwi0DYee/ARdDWFlLbmdVcAj0cpEXxSzwa2bBf8XD8nUsQpc/VCqFeiNPZTIkdLjalbnQZaCzLHqY6ef69dMxm51u4L0HwWjaiGpEOGmdjD/wdswc1PMMPRrjt+RCRG8QWHr8CNtPC26Eqr93I+rJLUJbmu48GZcXGuDu4pe9QIIZV1tpexYyH6DILzEp88WLS7DHwpG/V3ii/9EWEjaseWND4l32FVSqRgruCfEok360oOo3QVCSk6tnOYh9a27XDaOD/bbBlNYrZqDLhhMPgoEKwHAGTESmR5kvYoXYQjOtFTk0ziOG5zyEsNs9t9lDcmakMaxx/0V99/jXob
 VKAjlVyV
 eULupkuBX8CWtjHP7C7XCqT87fIbhFOpg95yHqvt3s//Jn8LICbKclGQ7D1jFTRdzaErkE9p43uuOb7iqSRMQdO5YZOLcWDJPppNvRYFQBqqJ7fRuhl14uUIGa+ic/1DtT/dnbq/ZIODHyvTcwzCmmCVUtGar/4vlD2IE1eByMaBh/dTzdGpw3yFcRS9q3NwBGjP7EhsdNSZM40jqzMvZkLcxIDe+O1Lch13l95CAPlpOXz3ft57d0htXCsJlZjqNoukZA9rFwIynB0nVL77RHPxgLE+l9WtGMEFKXlAlUHQqQKDN4vm1qnGJtTdubNqMiqru9IcDP3oPsmC1m3N74gWmNMXaKl8k3RGqh9KAEv1ljP6Q0l9xPp2HpgbZoQMrU2YgeWLP+2SUa1rpmZty6fICJAgN2CTSyZbYOTY4X4FCdpK1chtgjqHn/d7jLGA3JZ1RlmHJldNuaqOLk2es9GHLYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/5 21:22, Rik van Riel 写道:
> On Sat, 2026-09-05 at 14:18 +0800, Jinjiang Tu wrote:
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index d1819fd69938..a868e835eadb 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -209,7 +209,11 @@ int __anon_vma_prepare(struct vm_area_struct
>> *vma)
>>   	/* page_table_lock to protect against threads */
>>   	spin_lock(&mm->page_table_lock);
>>   	if (likely(!vma->anon_vma)) {
>> -		vma->anon_vma = anon_vma;
>> +		/*
>> +		 * The fields of anon_vma must be visible before
>> anon_vma
>> +		 * is published to vma->anon_vma.
>> +		 */
>> +		smp_store_release(&vma->anon_vma, anon_vma);
>>   		anon_vma_chain_assign(vma, avc, anon_vma);
>>   		anon_rmap_tree_insert(avc, anon_vma);
>>   		anon_vma->num_active_vmas++;
> Nice catch on this bug!
>
> This is perhaps a dumb question, but does this
> write side barrier need to pair with a read
> side barrier, to ensure the reads are also
> correctly ordered?

Hi, I have described it in the changelog:

We don't need a read barrier at read side for thread B. The load of
anon_vma and anon_vma->root have address-dependency. According to
Documentation/memory-barriers.txt and some investigations, only Alpha
needs address-dependency barriers and it has been handled by READ_ONCE().


