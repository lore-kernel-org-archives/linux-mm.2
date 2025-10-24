Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEEBCCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 10:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A6E8E0073; Fri, 24 Oct 2025 06:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21B78E0042; Fri, 24 Oct 2025 06:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E1F8E0073; Fri, 24 Oct 2025 06:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A30DC8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:13:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60CCC1A0DFE
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:13:34 +0000 (UTC)
X-FDA: 84032595948.28.B1D831A
Received: from out199-16.us.a.mail.aliyun.com (out199-16.us.a.mail.aliyun.com [47.90.199.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id 826F710000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:13:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="TtWTR0/g";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 47.90.199.16 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761300812; a=rsa-sha256;
	cv=none;
	b=AesnQdFcDYhCNOH8TA6w+oQL8r/n0QUJeEhgW4sfX/yu/DuYBjN+eFXggxRSBNKza3gEWU
	WZy5n9VXq7fd8+D2QQRaa6nvt4OTPLfYSUWAf0Z7RDv/7tCzzzpywpoJASNsviRo0DnBv+
	3SXBlpJQ5dVI/5p3g3DmITmHPywD1eU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="TtWTR0/g";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 47.90.199.16 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761300812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+A2uFbKQefkDojLPPcK70ocgcvIwvNmJfoecA4EhpE=;
	b=YQQgFzUnr4bz8uFJhtaDnIyveTbHuTUe3gL4HNmRfe1xtOjLHE6haKl8KkfQSkslDVf9tq
	7/oySwZU0gAa56tYU7cB4xNQV9QjCfwp+84dbIw9OzQo+qBtXSebhhiwnyT6RkfRJD1UiM
	WGbXIs66bb2JIPcQcqM+jDz+wRblcWs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761300206; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=n+A2uFbKQefkDojLPPcK70ocgcvIwvNmJfoecA4EhpE=;
	b=TtWTR0/gomv86HpWrvXd6AXug+ACswu6NxbFi6pQB+ssw6+lfOd+NrANz7uB5pcA62aGDT8U3/kIG9/tan2S1W9+qoLDlBucbfVq72jvuirGumypVVj9O7LIFCTck7KIg89IlJJ5rIgDIimMSxUbO8WNHLo7z+N/rBbD7RaeWKQ=
Received: from 30.246.161.241(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Wqu2Tm1_1761300202 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Oct 2025 18:03:24 +0800
Message-ID: <134e43f7-583c-48c1-8ccc-dddc18700d3b@linux.alibaba.com>
Date: Fri, 24 Oct 2025 18:03:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct
 pfn
To: Ira Weiny <ira.weiny@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
 "ankita@nvidia.com" <ankita@nvidia.com>,
 "aniketa@nvidia.com" <aniketa@nvidia.com>, "Sethi, Vikram"
 <vsethi@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "mochs@nvidia.com" <mochs@nvidia.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@redhat.com" <david@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>,
 "mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
 <lenb@kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
 "alex@shazbot.org" <alex@shazbot.org>
Cc: "cjia@nvidia.com" <cjia@nvidia.com>,
 "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
 "targupta@nvidia.com" <targupta@nvidia.com>,
 "zhiw@nvidia.com" <zhiw@nvidia.com>, "dnigam@nvidia.com"
 <dnigam@nvidia.com>, "kjaju@nvidia.com" <kjaju@nvidia.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "Smita.KoralahalliChannabasappa@amd.com"
 <Smita.KoralahalliChannabasappa@amd.com>,
 "u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
 <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <81b1f1c6-4308-41bb-9f65-f158d30f27bd@linux.alibaba.com>
 <68f8f254b53dc_17217e10069@iweiny-mobl.notmuch>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <68f8f254b53dc_17217e10069@iweiny-mobl.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 826F710000A
X-Stat-Signature: fomkhdfm1uqihdfduun8dbncksdbkohq
X-HE-Tag: 1761300811-215184
X-HE-Meta: U2FsdGVkX18za1LEIcBZ90T+OneOMli9U1iyjWu1s3MFKhcophB8s0qZoNO/TTem7+ZTimaonBeI+K0c3SovboPozU7RbpzY/Cmi0y1m6f3UDpu6vTk7wFN1IgJDDUK7UlouXWPqIkOQ90n3CmIo1PeIjdI3UqRbidWaiapboUQpBMP9cz7PXuE81B2p00f9g6Z5eH9TlzkoWlk9yGQLhXzZAsIoSho+29q2WLCmDk/5upGQ+fkTdo+tuq/GQlS4RLhzMTa575RlIM74AaaUD8o3CIK1wH3eo418DufuCiZGA3YYJZTlMD7rL4z2PPxE8gQvfI5GZ5Ndnf+w2Izm55DG/3Yhs2rzhOoUVoWh8+VKI2ZBpkYBm7Zlg8/ZlgMx0uY0sMJW1gt4Ai0X8vQsMm8dSEwrjP960AehS8qeubVJF/3pBMiccSQcVb8MoN511k7ie58jf8sZ5VSteq6D2Ut51+R8aR5mcDIU35/KV+vab6Iv6GWUIe9bO7gdaVSa9C/wg2iA+Y+s9Qnzn4wz9UXSv4yYb3r2Rn8sfiSP16w3EPat8BI/6eaeBtQ90qcz2VvQSJFQlGweptlUQC8H79fLdM9eHRFSGufKf9lbUsqbwNrdyRJ6GmwC5Rlrbhml7iWMyeRC2mWg6lwlvyc31lnj03TzzIZhDZYmqISt8zEje46DWIxBR1w/Tsap4dHbxN5/oNmWqWyBphuhh0CBEZdyNBea3013iWggPT1Mi+LGY/zNpAFuxY+J2Vpj0Klo1jPVAFNaCaGQbdWjMdmUSmugKSESK0nLhkS4iKh+yStxOBaoXq+4COpcXNANl/mN0vLYv7YSTCmcfPGhfI5MDjmTJ15NiY7PB0CnxiNQJ9qwbV39FJRYH5N/7LsUMB6yxyVdY82wCptmFq3pIK1TqOEFpDkWM4gDZEM6rHtg04TLWMue/9DDFHnZ37ZUxbwVHD0+OW7+2v2DUgkGIrB
 2gFXPi7T
 FCiF9pnscbOCZNv323rJN6E2bNretmV1j9rquwOcGnx0DAgDarnvoAPaYly1LWsFgoBxjqKEZCJRWGeKPfK/cPS2vmRWLwYwBC6Oydtz6Lk5USfz15FnNVxNyZB+UqD9vLbaaLmTGdOWHQYA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/22 23:03, Ira Weiny 写道:
> Shuai Xue wrote:
>>
>>
>> 在 2025/10/22 01:19, Luck, Tony 写道:
>>>>>       pfn = PHYS_PFN(physical_addr);
>>>>> -   if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
>>>>
>>>> Tony,
>>>>
>>>> I'm not an SGX expert but does this break SGX by removing
>>>> arch_is_platform_page()?
>>>>
>>>> See:
>>>>
>>>> 40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
>>>> Cc: Tony Luck <tony.luck@intel.com>
>>>>
>>> Ira,
>>>
>>> I think this deletion makes the GHES code always call memory_failure()
>>> instead of bailing out here on "bad" page frame numbers.
>>>
>>> That centralizes the checks for different types of memory into
>>> memory_failure().
>>>
>>> -Tony
>>
>> Hi, Tony, Ankit and Ira,
>>
>> Finally, we're seeing other use cases that need to handle errors for
>> non-struct page PFNs :)
>>
>> IMHO, non-struct page PFNs are common in production environments.
>> Besides NVIDIA Grace GPU device memory, we also use reserved DRAM memory
>> managed by a separate VMEM allocator.
> 
> Can you elaborate on this more?

We reserve a significant portion of DRAM memory at boot time using
kernel command line parameters. This reserved memory is then managed by
our internal VMEM allocator, which handles memory allocation and
deallocation for virtual machines.

To minimize memory overhead, we intentionally avoid creating struct
pages for this reserved memory region. Instead, we've implemented the
following approach:

- Our VMEM allocator directly manages the physical memory without the
   overhead of struct page metadata.
- Error Handling: We register custom RAS operations (ras_ops) with the
   memory failure infrastructure. When poisoned memory is accessed within
   this region, our registered handler: Tags the affected memory area as
   poisoned Isolates the memory to prevent further access Terminates any
   tasks that were using the poisoned memory

This approach allows us to handle memory errors effectively while
maintaining minimal memory overhead for large reserved regions. It's
similar in concept to how device memory (like NVIDIA Grace GPU memory
mentioned earlier) needs error handling without struct page backing.

Thanks.
Shuai

