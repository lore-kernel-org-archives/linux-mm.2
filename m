Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65636C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4996B008A; Thu, 10 Sep 2026 22:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C406B008C; Thu, 10 Sep 2026 22:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF186B0092; Thu, 10 Sep 2026 22:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E776F6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:50:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E81E11C293A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:50:09 +0000 (UTC)
X-FDA: 85199952138.15.3D404E8
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B1C5C0007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:50:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NgIS1H+w;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789095008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qoPgN105gt2P4UL8cGJgEPkDgefVho21FsHOdfrr3Q=;
	b=sfuXWYZZFLyq3p8k56aSxQ6namstSFDQaq7tS9EXFTEfPu4/UGkAASUhyOHP5Tjyye/SCz
	W+R5SaBC0gSj3Ix0vBvP1M+8fne/apUYtgFNp19qHj/nX/MBoF2xMPPtBwq/vRGomE4Nm0
	sXymeEnG10ZK66QYx3hjTIPTmpdyQEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789095008;
	b=sTG2NDxjPLU/2VlveyH5Rw0BjMLlUwxWF3lKX3j0kxaNdSS7mK/yxS9NjKSf5u8o61Htx1
	MjLUiQty52Y7p3f4yQ7p2/NI0yHlTGxhVIkKFHrJY6oYRKGS97xeNy6dt50otbwP8utwtA
	hc187V4A3oQRva3oJSeqeXmL+yqAbA4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=NgIS1H+w;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789095003; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/qoPgN105gt2P4UL8cGJgEPkDgefVho21FsHOdfrr3Q=;
	b=NgIS1H+w2RCBGemqlSX2lSbKjdLX1HZkUSDADwWPzolictWEW4nDD5QSL6/LR6QTSbX8QpZ4VTOqeB/eKGzS7uRXCYVU+EBaTLKhLhLAKey4pmreLrSYygiEfwCmLExYJL5IVZLmhiX/6jBFUuq+TLCzLgXBvFPPygfsCCKubX0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XAj1dJ._1789095001;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAj1dJ._1789095001 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Sep 2026 10:50:02 +0800
Message-ID: <708fbbe2-4eba-4641-8267-ed930ade0068@linux.alibaba.com>
Date: Fri, 11 Sep 2026 10:50:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/19] selftests/mm: add folio-order check for address
 ranges
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 rppt@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-9-kirill@shutemov.name>
 <feb76c81-db9d-4a36-9a31-0b2b31e3c3fb@linux.alibaba.com>
 <aqKFXlpSELmCtt-z@thinkstation>
 <65bf1722-c1fd-452a-88c1-c030b042cfbc@linux.alibaba.com>
 <aqKqr62-718Vw35k@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aqKqr62-718Vw35k@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xckr6tzpiyz3r6ma8rfjzzqwhuo5c8au
X-Rspamd-Queue-Id: 9B1C5C0007
X-HE-Tag: 1789095006-663655
X-HE-Meta: U2FsdGVkX180WdoqKX0bWA1odylxz8mjA5xvs0nmOuhweb7kHnngHj+2qbCXtW4X5CcK1H3+KfQjge15pihIQ27W95O+W1Ug278rNZPfS3nuYtsEwX0gotlZAhJpT0f/HkETippeIJb60sBzEcx/BODbE6FaSpJVHIhkxLyTrxQ7kDutqXDqK5b8iyWi5bN4ryPKmyX6mN1ehzO+9x9of3rt4QhA1LTg4VuNSuZzIjKKGiKjPPW29dqnq98eTzbBxSIqE+arD+3G0cQmljTrhgHzGFVp4KtewRiECoRSnCadJ8zSpAL8ExF5COohPfdpHQEk7lUwOCtsx+cWAnEh25ir0CBdNTNCFLrxE/7bY6EbRKQrZIzD71C1C0RDKw4QshCDe2aYtMTAuqDAcJzIvPIMTAnfqzfO89x9RKISaq5xs/w/l2gSDvchS8HTH9XUroDZmvWUcqABgiEDDZqijgJ3KZp2WNEqh4x70YSrxjqLiY94ngXbQrlzmteLtpINRFbFVbI5u3IrwpdUoaY6E0/+PdXBwxE7gLEXZK/1cfWglsYYmyHV1W/Aykcfmbd3mEo++3WKSmVkoh47YWUuT9/uWeXFPVxUEz8c+hxw+vLkbTOdXu+OIP+q99A5pT1l2viFDKKvBHjpGwu1xl29zSmov1lXhAXDXt4hVe8aA5qBQhBPpFJEQ+RZ3ACo6z+4xQH077nQYqLVV/pDfJyKzJS/S/U83mPaMKpaMJKKGISBxPpNMcBQcB7YvP9K99qF96diW8UhGCB/N/woHQE+CGkAlXvLQbinDTi8OwkIUwsxjhBMCQcvsUFhADDACScvSfLBO7tn36+pQlWwD2/LwQBOv+VncALwCZ2nxCrU6ibyx8y4Pwm4See8iz/P2MkENgYDCOSrT3WRaWvMB1GSsl/EuBszI8KaiUsGo5dNTwpFs0kVrU9Lc4s93j5PGmUaXpGco2HPIMomTg9Vg8q
 x6GPNypG
 8zgXRU7xA63nLGvl1c8h5hYGIsqcWnPo8b2gQMsogdSpfsldrp4bm3HcLvo8rwrHO/0l3D2xzwOObAsSY0ZkW4KrT/hzugdl2v4aAw7/lMBgMUDn/IKZjtJKELlFPHz+NDHIKLo7cLU+Naco6q4QR/6qnCIBmR69LFP/yIez0bWyhhyqfLpO9/QmmxNA7A2zBv940XwXpwIDf/VuX0ZW8njxFGaS4h7q7aj2v/vQDzjxg08JaoZl7/i/lrcaETKKvs9hCCMn68aTUanYScsu49Sx+lAOMCYP/NSfcjrCmIxgKLzRn8GehB0t4PBcQy/z7PZZwAI9G18ap/aYwjD2msCw9HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/26 9:04 PM, Kiryl Shutsemau wrote:
> On Thu, Sep 10, 2026 at 07:14:42PM +0800, Baolin Wang wrote:
>>
>>
>> On 9/10/26 6:45 PM, Kiryl Shutsemau wrote:
>>> On Wed, Sep 09, 2026 at 06:01:13PM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
>>>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>>>
>>>>> An mTHP collapse test needs to know that a range is backed by folios of the
>>>>> target order, and that they sit where a collapse would put them.  Nothing
>>>>> answers that today: is_backed_by_folio() classifies the folio behind a
>>>>> single page, and check_huge_anon() reads smaps AnonHugePages, which only
>>>>> accounts PMD mappings.
>>>>
>>>> Have you checked check_large_folios() in vm_util.c? It seems to meet your
>>>> requirements, or am I missing something?
>>>
>>> The changelog is out of date, sorry: since 6dedaf0d46a9 check_huge_anon()
>>> counts mTHP folios through check_large_folios() rather than reading
>>> smaps, and it is what check_huge() already uses for mthp_khugepaged.
>>>
>>> It could do this job too, called once per window.
>>>
>>> What is_range_backed_by_order() adds is alignment check: the folio has
>>> to sit at the window start. And check_large_folios() reopens two fds per
>>> per call which kinda wasteful.
>>
>> OK. But can we extend the check_huge_xxx() functions to meet your
>> requirements, for example by adding a check_aligned_huge_xxx() that wraps
>> the underlying implementation of check_large_folios()?
>>
>> I still find it confusing that khugepaged.c has two separate sets of
>> functions for checking large folios.
> 
> Agreed that two sets is one too many.  Yeoreum's series rewrites
> check_huge_xxx() on top of pagemap and kpageflags, which is what
> is_backed_by_folio() already walks, so once that lands the two can meet:
> the mTHP branch of check_huge() checks each window for a folio of the
> order at its start, and is_range_backed_by_order() goes away or becomes
> its internal.  That also makes the generic mTHP cases stricter for free.

Look forward to seeing this happen:)

> I would rather do that as a follow-up than fold it into either series
> now, since both touch the same functions.

Sure.

