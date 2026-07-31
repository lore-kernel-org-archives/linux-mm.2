Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8EFCC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0C0C6B0098; Fri, 31 Jul 2026 05:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3346B0099; Fri, 31 Jul 2026 05:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF83C6B009B; Fri, 31 Jul 2026 05:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD4556B0098
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:25:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5445CA15A3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:25:50 +0000 (UTC)
X-FDA: 85048539660.08.A64A451
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9868FA000F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:25:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqHpIa19;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785489948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPN/6Z+IhyvCKcPUIzWN0JtwhU4CTKabtbC1HJRcMRE=;
	b=e+ZJcD8KQ7lA6t2O0x9m/LgR8EIXc0x8KGj6/iZOnlwtM19FI+ZZoEjaSCLD4or/kuEj70
	hnLEIKLMMKfvc1B4aybIZyMc+47qxgqT8BGskezepCeRIYkJzzuUECb4dGZRxeKduSLTtB
	dUp+neZ4V4qQK3K5kPAUj4S4PS/jo8g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqHpIa19;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785489948;
	b=DbS+DGVyXxvvc/Qp7n6keTI67+qcCoAnAZFbDq4baRqwLN39roBB3POcfXLMSL7o0YE5OO
	Nt2xu8t/AvMSZDSHn4SeMHCyoa3EBq53YZANa7Y/LjU5XiEOEWB8m1SlRbe0Gn0GC6ehV0
	izdGGVglM1luU6OAVSQppmd5En2lVpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E15260A6D;
	Fri, 31 Jul 2026 09:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357FD1F000E9;
	Fri, 31 Jul 2026 09:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785489947;
	bh=bPN/6Z+IhyvCKcPUIzWN0JtwhU4CTKabtbC1HJRcMRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OqHpIa19f4txiqd8mdCMZEbxX+f0fi/hPi/1vpqzNUZR982hbkZdARnICBkm3mLqJ
	 /1OgIWGQzG9YapvGUcRKSPZG75n/FWF04eF+7pWZnMJ1EJS1V4x10YRGg1xRR+9Wkl
	 wLWvQRGDjoq3Ue7N6J3ZFamgNpwbX0QCz75v8ajQ6Nj0ZtZSkKrsf+HNIjLeiQPNLs
	 jNOxfas431doPMTpIZ9XyRE3Etg21rSqse3GDWZHkey+r452mXyVB2iwmDoDuLXo0q
	 eJqhA9S0cbRt/DwvsPMWv/y5qCPiPqlG/B933xNOP1Qx+vQxaISBwinjlKp6f6Brwo
	 arf0uI0L9iNvg==
Message-ID: <3066dc07-31b5-48ca-b14e-51b284bbb9e1@kernel.org>
Date: Fri, 31 Jul 2026 11:25:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs: ksm: fix typos in sysfs knob names
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
 shr@devkernel.io, linux-mm@kvack.org, linux-doc@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
 <20260731083526.3953421-2-tujinjiang@huawei.com>
 <d9236dc0-3332-4fab-aa26-e74d10ad0cda@kernel.org>
 <f1f5c486-f14c-44ad-8285-a9df437f7974@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <f1f5c486-f14c-44ad-8285-a9df437f7974@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9868FA000F
X-Stat-Signature: 187irkojosbquft3kzqq3j7o94nbcsuz
X-HE-Tag: 1785489948-722932
X-HE-Meta: U2FsdGVkX1+d4py4GW8ae/LqEZF1EgPVL9qjictrj5QT5Sz7dUraVdka7sp51j/tmzS5ximY0sKhNH7cMgdcwqV/2F+HOIG19Zd0H1NISjjobQn3dlBGBqkftv7okwqnlGp/H5LbeaS+9MJdkkNoNTKypY675DGThr4EjK9b/vh7DOGjRs+1r8tooSrpxTGYGEVGJO7SVdOfvKkIL48OuMqrCovAi9wF494RBikxh2oAEdd9Sb694qcCukoPFGrR5HWewqgNLH9N729HH6tx2f7AnTI3KBmvY6YeSjTWFc1uxEPGjke2QBoUdV6Sw9D7Xge/VgMmWoU46yFeOGb7tH6o89gYalYbjN9IP9SL+JKM4VbGaKsSzkzJ2J+ZJFRc+GLPVfOdv5l1v4nEj1ZAxBcvdsF57i7i/C1lF6r07ZoGFOkdVyR9r7Rce82oYeoOo4f7jiKc26ma6okgA++MC0bfbWEBLfw51KV1Sy4habL4w3J8AgtmdvdCeGmVIw/Z7KQNAKg4OGi1XtmqWaAPi5bqTPyfJzLBUWR+AAuZ+aL4O+a2QNAWYemVaeTr9jF1bGJgg5BFaurGoxC76f9aZ5r9jAw3B268IRQ/KyA/U97RcMijuSAAZA6wOYKo6JzNPNoEcbEaxI2zAzdHEKlF8usfdpSbF7RLHkQ87uhWYF4vYkLWUquGSYQv1VV/emtBw9fN7qBckkwxmVOb948tZHhiRxtWPH150HtBlafLavNiDFhX6m9GEZKIt9BV+Qac18ScnIp91WejSQBrptF2xxis6v+diYsC/kl87Fs0zYI/O4LVODixXiYX84Yp3Xx4xTtha7aeTmPh7bcsFSyHP9q4IsiP+jZ7AtO896/ksTIOILc4gSmgITg3YalZyoYc9WpViPcpQRpR8uW69zwyZSnciaGJurAzMyajEl9pYmQD/GBYmo4XMzsGWMYx5vwTgXVvaYKbhsYOTAHpVI8
 zZFnXhZb
 z9KvoBMTFqrcgddlJj4gQ8qzrTSNWvGcFD/bdh+QFPvScQdgZfXSpxqH5iAEsth/Qr/kXGITdG8GK/SoitRqhFaWzJW7lCTivEqclnnImjmMz+9/k8yqdcIActZHRphSCoLiW4iMc8krzZKfHzk4wzy0t6zq/YVkmEPx57Hdw/1kQ2+1SeKja71lXycn5f4SfD4yCC1LfMd8xgsqsvm/BwWCtyaB2f8mNSBIEmq0JJBhwcBe1x0qfhwaV6/phXe07tjlo3gLahC6AYumXbe9mjZzg0sCDwnkVw6hC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 11:22, Jinjiang Tu wrote:
> 
> 在 2026/7/31 17:11, David Hildenbrand (Arm) 写道:
>> On 7/31/26 10:35, Jinjiang Tu wrote:
>>> The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
>>> "advisor_max_pages_to_scan", but the ksm.rst documentation spelled
>>> both as "adivsor_*", fix the two typos.
>>>
>>> Fixes: 0710f38ad26a ("mm/ksm: document ksm advisor and its sysfs knobs")
>> I'm not sure on fixes tags for documentation stuff.
> 
> git log --grep "Fixes" Documentation/
> 
> Many commits in Documentation have fix tag.
> I think both are ok, since documentation changes are needed to backport.

What? When? How? Where?

:)

-- 
Cheers,

David

