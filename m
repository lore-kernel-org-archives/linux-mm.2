Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE70FAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2656B0005; Wed, 22 Apr 2026 22:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72DA6B008A; Wed, 22 Apr 2026 22:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B610C6B008C; Wed, 22 Apr 2026 22:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A23DD6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:05:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A06B1A03EB
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:05:53 +0000 (UTC)
X-FDA: 84688179786.11.C0EE227
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0B29D1A000C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:05:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Vv/FDFU1";
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776909951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jnsom+L1FSLBtHHuwYUTLSZW44zxnrid8A0mijOuEuE=;
	b=5HE/NO4Bo4uhZQNV5Lt91EZw0zEwHCKjfXT/lWx/V32DU47sqZNKXYaNX3waQBbT44DimB
	ttE4PwQpwnz0Bq9ardvY7/D4XU9qIgccLeaxhjgHv+lDpjmsW8pjO1NS/fuvBK4vG1Ue5k
	fDvi/BWx06N2uPqvtxbeuq6ck+BpCOI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Vv/FDFU1";
	spf=pass (imf19.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776909951; a=rsa-sha256;
	cv=none;
	b=dPlqfq3504vjTJ41JRRF5H6CPPcn3aLUzTyBkZaeMnRBBzd7UUykbOFtU0qatyU4jsUnKZ
	7cszOltXiuKbLRcb0kG+j9sRti/jcaGv+Yx2Hewz/ezvcsV0l8OllW2LMF/VO6bXrsFXuf
	E0kH2xGBH2kRIhfxuPw0BtDHaal6GZ0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Jnsom+L1FSLBtHHuwYUTLSZW44zxnrid8A0mijOuEuE=;
	b=Vv/FDFU1jBbJtskweEPXJ9jFdZNcPdD7wqEUubS4Zt54nkD5PEkJ3la3xRd7OlbPri+x6JKmv
	XbyQGZ85+ZsYteZFIqSCEqlgyBPNGejvN4JlwPnC/jHpwQAmhdw6foil6zf7ShelexpN7HCENnn
	YmJ4/6CAs47XIXHV1bZKglw=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4g1K5d5pD6zpStt;
	Thu, 23 Apr 2026 09:59:17 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id A947640571;
	Thu, 23 Apr 2026 10:05:43 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Apr 2026 10:05:43 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Apr 2026 10:05:42 +0800
Subject: Re: [PATCH v4 3/3] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-3-2d0277f8f601@debian.org>
 <7b4a6659-e2e5-5e63-2952-c7a840ffcdec@huawei.com>
 <aejnmh3xlHsuKfP3@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <4cca0bb0-8b7e-cd87-4f3b-627e6fd3f549@huawei.com>
Date: Thu, 23 Apr 2026 10:05:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aejnmh3xlHsuKfP3@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: pnyafsymafiqwttjpxw8as6h31yotc8y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B29D1A000C
X-HE-Tag: 1776909949-815594
X-HE-Meta: U2FsdGVkX18fU9OAMzKZzZLYaFH3zhSaBGah9lSxwHAy2TDjOohLaZjYVU0ZGjQxW1NAFV58qh6oJD9T3CM6ai+Arh7ztNLao0209yf3tjMuDcduFZ6O1auUHClLi5VFoEXNsdGRadR/6tjwWONtB9NE3hcQjE4HVI0EB5ipvnEuvXwhSxMrE9842qcx3HCMpraDfR+CMeY7LtN2/Gv4cudLTaP+or17zavrr8++NK9viCtZdcdp+qLOrj4UlHUlyOsZiTpW1b9JnDeokj2Lf7xS+bFebMfpkdzJXPlRKlq7NcyFbSJXGSOm9MfVGSRe3T376NzudifBwfTdcSI4C3jLNffbsfyt6bRH0A84Drd0pnJ/vak6NJa8Ge58PD7Xb61P4vXcG9SSo9xU2WJRGZn7l9eQAbugXCt0iHT3F6TfMGlm0dCzEIPbvzWvYYuS00iAhBWUOlRDVfWRJqo5TOuOHY1OAv+vH5BNXlFWdp9R936LyiOyrqhyJ1K5x6gjdwUfJuwl34jWtkWLpaXURIE6fzrAUplB362m6wAOJ4DRk690DdZqz6Z3+iUmPTUHVsqiymG026EfxhqKE+MXa4cY41w8d8/tt4H7zq5bPKbS60OrGzVv4Ra4GXPwjizpMPfGBzzxWapdp9pBKFMB7hsu3PdTmu+id7V5HbkrbaKljZL0vpJvFwiFIrwFAu2ldQth2sS8S7ruikGLqi5Zl2Mq5r902zt+sQ4gdUdzoEhzRhYqVyPmxfBehLwC4QxGcWsNR8xAgJxbunR5BQ8NRpPJgzLdsOy7X5KE9Yo8vDg96mQJG1IJDci9Qs8t+FzSw8jCfkMvl8I2A9h3fJCLnx+/Wq0M2DgztsngFev84ksNL5Kfh6LrJcZdNAHWtiLOzm2rV6znpNPcuwoBUEUM7SU8KIjBac5THVsP8mX/OtK6PuIzJVM3o2j9rHCF2ks4hLKOPXhUrl6ZO5vffk8
 QaXPBCuA
 o2aPrH1LT7CfHeVpKDPSIBMdzEpCTF61Ti0C8d3vUW1Rn1Lhl710LfnucwoLtxJfcymKV6+wmuQVCvO1u3D4++enWS2DYjvIMS71uG1aArAsQUPWPMHnrAHSjXZFyMkZl4JtiVZ/oYKQ0o4HZ0r1E8xT9IEA2qygoDN2PLE3EWuAlSPIiAyzM65qokYIrVuZ35GkfcXND4snHvuXd2HnVYMGa420TMKqiruHjwfcwuMeS+3eu7gSivQlzUBjXjUZa5HBcTSS2IqM39aDftvB4hUTKQ6CUTWygtnvUY60lsTnKUvXd4ny1t847pKuNxRGQEHyMOqUPIa1Wj0HvAu9NSGuje9J3xwOqyv4zxiXD0YANGhwv7mIjQrjSj5LVEKj/TBw/9Yps9Rngh94hUJVTimpt6P93DAxCJ0rHQpqTb+mvL5ZfVFbFzHeyJfjYuCz1Praf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/22 23:23, Breno Leitao wrote:
> On Wed, Apr 22, 2026 at 11:43:16AM +0800, Miaohe Lin wrote:
>> On 2026/4/15 20:55, Breno Leitao wrote:
>>> Add documentation for the new vm.panic_on_unrecoverable_memory_failure
>>> sysctl, describing the three categories of failures that trigger a
>>> panic and noting which kernel page types are not yet covered.
>>>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>>  Documentation/admin-guide/sysctl/vm.rst | 37 +++++++++++++++++++++++++++++++++
>>>  1 file changed, 37 insertions(+)
>>>
>>> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
>>> index 97e12359775c9..592ce9ec38c4b 100644
>>> --- a/Documentation/admin-guide/sysctl/vm.rst
>>> +++ b/Documentation/admin-guide/sysctl/vm.rst
>>> @@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
>>>  - page-cluster
>>>  - page_lock_unfairness
>>>  - panic_on_oom
>>> +- panic_on_unrecoverable_memory_failure
>>>  - percpu_pagelist_high_fraction
>>>  - stat_interval
>>>  - stat_refresh
>>> @@ -925,6 +926,42 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
>>>  why oom happens. You can get snapshot.
>>>  
>>>  
>>> +panic_on_unrecoverable_memory_failure
>>> +======================================
>>> +
>>> +When a hardware memory error (e.g. multi-bit ECC) hits a kernel page
>>> +that cannot be recovered by the memory failure handler, the default
>>> +behaviour is to ignore the error and continue operation.  This is
>>> +dangerous because the corrupted data remains accessible to the kernel,
>>> +risking silent data corruption or a delayed crash when the poisoned
>>> +memory is next accessed.
>>> +
>>> +When enabled, this sysctl triggers a panic on three categories of
>>> +unrecoverable failures: reserved kernel pages, non-buddy kernel pages
>>> +with zero refcount (e.g. tail pages of high-order allocations), and
>>> +pages whose state cannot be classified as recoverable.
>>> +
>>> +Note that some kernel page types — such as slab objects, vmalloc
>>> +allocations, kernel stacks, and page tables — share a failure path
>>> +with transient refcount races and are not currently covered by this
>>> +option. I.e, do not panic when not confident of the page status.
>>> +
>>> +For many environments it is preferable to panic immediately with a clean
>>> +crash dump that captures the original error context, rather than to
>>> +continue and face a random crash later whose cause is difficult to
>>> +diagnose.
>>
>> Should we add some userful cases to show the real-world application scenarios?
> 
> Yes, good idea. What about something like:
> 
> Use cases
> ---------
> 
> This option is most useful in environments where unattributed crashes
> are expensive to debug or where data integrity must take precedence
> over availability:
> 
> * Large fleets, where multi-bit ECC errors on kernel pages are observed
>   regularly and post-mortem analysis of an unrelated downstream crash
>   (often seconds to minutes after the original error) consumes
>   significant engineering effort.
> 
> * Systems configured with kdump, where panicking at the moment of the
>   hardware error produces a vmcore that still contains the faulting
>   address, the affected page state, and the originating MCE/GHES
>   record — context that is typically lost by the time a delayed crash
>   occurs.
> 
> * High-availability clusters that rely on fast, deterministic node
>   failure for failover, and prefer an immediate panic over silent data
>   corruption propagating to replicas or persistent storage.

This would be really helpful. Thanks!


