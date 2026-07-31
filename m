Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D2ADC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9116B6B0093; Fri, 31 Jul 2026 05:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8756B0095; Fri, 31 Jul 2026 05:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9FE6B0096; Fri, 31 Jul 2026 05:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5106B0093
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:22:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5469C037D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:22:21 +0000 (UTC)
X-FDA: 85048530882.03.03E801F
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf22.hostedemail.com (Postfix) with ESMTP id EFF84C0002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:22:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RIWeVDZc;
	spf=pass (imf22.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785489740;
	b=y0F1nKVyEtsXfAkve2+6PtTRIFW9DpNwcYt6wAIh5zwFm4h/l1fQJiHE1+4PA8T6gyTZMj
	gKFO0qmIoACcdkBpko1qmchq7nOKU1Q/iouXb5S8Do6AiaRKMrPuX9gz92O+wkncA3BYm2
	gXT2ViRZpKXy3TwlCru20NtIhedc9f0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RIWeVDZc;
	spf=pass (imf22.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785489740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSlvGHWZWW6/evFQX46IFv/qhBgxIsSaU658wg0MkhI=;
	b=041jV487tOq3bkrOcor59insijvJ4DTQrVNNXpQ8+YXt8ugJOBRIXYotA5+ZJxG1dxKm+U
	eF0ZXad2vBfWb/f5ZpGREgfY2kbicNfK9hE0Zn8dCODOfRG5DH4SSwzGx5mwJyVImgATw3
	fg4syGrZ/uVUmNPWVNvPadOhsmtcg4M=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qSlvGHWZWW6/evFQX46IFv/qhBgxIsSaU658wg0MkhI=;
	b=RIWeVDZcfB7QcN/KVhMXS/D58bsGhcwqHHUos29pJKtdQ+2xciBgLqJb3SjJIR9Lo14rrLvZY
	claWtnADQERFYXshOkHkfovEADJyWSbfCKgBa1p14K97Nw1FAhU1UpfalU10KaNcrpgI0XuiTUP
	k2PKsWpP9+CrsNJ4itQuW5Q=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hBL235H6jz12LDV;
	Fri, 31 Jul 2026 17:12:43 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 739274058C;
	Fri, 31 Jul 2026 17:22:12 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Jul
 2026 17:22:11 +0800
Message-ID: <f1f5c486-f14c-44ad-8285-a9df437f7974@huawei.com>
Date: Fri, 31 Jul 2026 17:22:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs: ksm: fix typos in sysfs knob names
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <shr@devkernel.io>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
 <20260731083526.3953421-2-tujinjiang@huawei.com>
 <d9236dc0-3332-4fab-aa26-e74d10ad0cda@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <d9236dc0-3332-4fab-aa26-e74d10ad0cda@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: msmy5srqsf8j1u54tszb5yuuejbts6c7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EFF84C0002
X-Rspam-User: 
X-HE-Tag: 1785489738-832110
X-HE-Meta: U2FsdGVkX19jJtFOiXD8UtFt27epwvoGKYZ9WYl51ohrSIGRvm5g0j3k8iAK8zq6nDCF+PXmSbgX6ZDfQ8uzRnVu4oB0mEBWngJRVGREj0AwpJU5wfqODAkDKs6mEsDlmTLbesk750GD+ITNYCUU4g0Pap6ZUbH7PwGBTtz+njUV94AbcgE6wlohxo7eboe8EQYiMBg1H9/rFwoBZn0/iVBrfZzoCK6efZM6uFixmNv+TDQZ0KF2qWWgxeJdza0WlYuiLFeU9MPIpzFbaKr0OzcAc80COfBE5zE+HJS10oJrYdVqAVDdjsvcKBJV8dsGHQUjuM5dFmX2vdujlFXn4xK4SmOgChuUipD/GYe/yMwmwmcZLsyA+VCllThccO3HPRl0OkWPHVtOhp444nBTdsPvOHA0u2CPBUPEjiCL78hxdMY9JeO534tB9bQco3hLjQ11RohWh0CW612j/7gJWczyQs2kNz/PddLEx5awpadUaNdjbSNT+xDVya9oDvMYRxSauyWipECu/180nqxmEBb63Bx9mCaShyj5+/Ysc/hhv4dt2J3GtXcSZYXNp7eVp9oq7vHnzlHfdxzyBF6egv25IjjtvwIECM00w/ThDZ2+rJMml6zYMmA3xXHZ0f98JNJdh34meIwxmRD0Y0U32YzX+qZ6BQJYplnPVyLyZYA/cEy4tSMRaiUYDbGr/w00Eg3K6Fddi8NTo5k7vbLOAf+BwZeXho0N4jCbpBTGPNOnCXBz4KxTtLORzG6skr6H2x9/TnzxYmcvm4bsicc6vSEmZwouX2SHlsUBtt9tJsxnlg2pz7MwCI2XfHJpkIfkDhWRGQK4SLv/OXuAWsTHJ8rjYklva8VOfjcPFWy910ZJ/jBAEid+MHmGA05vd8TkxGnVER1i8K1lFQXxaCaTtQ9ouMVVoOGoLxunsxKyQiNQu7LyixeohglRFgCG1yFaGHd9OCgP3QZY03QhAAk
 wj4dt4wu
 v2QVizbGlEKuAZihwrVP51RAht4pRMy2aD0j1KMGE/AqmEIfjf+nCkibE09MDHNq8Q2kEuhCGvuPgPmx8oUI6dwDW7s5W3JlO2hBCRM6Job+mN3eA4K6ni+6FD0kj45ccjOg6BnuTfVK9PmuNmonRiN84Yq1puCj0R4CqfjkXv3KmYZL3eJUQbzqUjcB9hwMxjBELQFpX/DouvfKX+GwoAvaQN7VousjJZqumxExDtJQseByMW8PsHepRp79Vgk1V5NPQg03ShPvAhVwEU5+WgFpeFTFmD2zQ/nGfD+6+tKcFLw1+hja02kBL61WbutjOpwAzsTHI6rG9u0fXvE3Yy+dFJmhCuaAu6Mso1SLclHc3N6hTZdBLiwbTTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/31 17:11, David Hildenbrand (Arm) 写道:
> On 7/31/26 10:35, Jinjiang Tu wrote:
>> The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
>> "advisor_max_pages_to_scan", but the ksm.rst documentation spelled
>> both as "adivsor_*", fix the two typos.
>>
>> Fixes: 0710f38ad26a ("mm/ksm: document ksm advisor and its sysfs knobs")
> I'm not sure on fixes tags for documentation stuff.

git log --grep "Fixes" Documentation/

Many commits in Documentation have fix tag.
I think both are ok, since documentation changes are needed to backport.

> Change itself LGTM
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>

