Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89580D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 16:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5DB76B0027; Mon,  1 Dec 2025 11:48:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E246B002A; Mon,  1 Dec 2025 11:48:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23F66B002D; Mon,  1 Dec 2025 11:48:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0C506B0027
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 11:48:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66D10C02BD
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:48:46 +0000 (UTC)
X-FDA: 84171486252.03.0088A29
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf16.hostedemail.com (Postfix) with ESMTP id E5B8F18001D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:48:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="EAdUvow/";
	spf=pass (imf16.hostedemail.com: domain of "prvs=4230525c4=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=4230525c4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764607724;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUFyYw4pB+c3aOIproKrVQP+K7Byw/zyZ7lr1XDUkCs=;
	b=NRpXzlX5WY7fhUzB7ddcshEotzvGXopoktno3tE5dbz5cPqydH11cYFurgiKGlDAyS2kf8
	4134DplCJSHfJFGK03zpBwcLbjkHTciLw0NAHLDqcCqamHNxfSJYePAKPbZFvBdTtsQXTF
	J36kmzjsw7oI6Uef8gyHRhB5n09za+U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="EAdUvow/";
	spf=pass (imf16.hostedemail.com: domain of "prvs=4230525c4=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=4230525c4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764607724; a=rsa-sha256;
	cv=none;
	b=lXWGEiTTo1ArJP0bwKwpIv60oE/3ventl5SlIMMcU0giQgu9KTTgeAw60jQ9RiREO44Wcq
	VtaKZttQw8raJ+Dr7iN6tz5KOSJewcL21Fm5MbIaKgFMBrS5WkCSzjga8CfsHT/M8G8wjr
	nfLry69UtMPITa9dGaxCIe7U+vFprAI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764607724; x=1796143724;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=GUFyYw4pB+c3aOIproKrVQP+K7Byw/zyZ7lr1XDUkCs=;
  b=EAdUvow/4b+JwzRwihlQ/sZ4oKVqPRZNcimnaFERmfgmUI7J6V9Dw8uP
   MHjg36G6NBdR2SpNPIr/pT4+49AC1u8cb89jSkUOUySTxc/2YxduDAQX9
   JoIZZBonVPQ0IRDdOeJfF0wBK3iuFedqeYpiH2SwBNccodi+uMbYQPnQC
   Wiqm3YwcvUOXK2EeR5Xge8AbiVrhc5o4cDQdhIyFMyLAYpkErYFQTirsW
   1vu6pRfVUCv8exf0UrCM3rJslVVKJXxndzQBFxM6KxhvrelBoArNDDcON
   Cl2KTgmGtbG6BR7F2vuUaSTYTCbEk+Uvt5xHNBMIbk6kkgelfeZh2JgXZ
   Q==;
X-CSE-ConnectionGUID: xidBH/+aRnWMIv82jcbdVQ==
X-CSE-MsgGUID: aicuxPHXSrSVLyblJP5eHw==
X-IronPort-AV: E=Sophos;i="6.20,241,1758585600"; 
   d="scan'208";a="5974415"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 16:48:25 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:18138]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.46.211:2525] with esmtp (Farcaster)
 id ee641cb8-e319-4dd3-9bca-f35a2cee9a66; Mon, 1 Dec 2025 16:48:25 +0000 (UTC)
X-Farcaster-Flow-ID: ee641cb8-e319-4dd3-9bca-f35a2cee9a66
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 1 Dec 2025 16:48:24 +0000
Received: from [192.168.8.132] (10.106.82.12) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Mon, 1 Dec 2025
 16:48:23 +0000
Message-ID: <553c64e8-d224-4764-9057-84289257cac9@amazon.com>
Date: Mon, 1 Dec 2025 16:48:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, <linux-mm@kvack.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
	<vbabka@suse.cz>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.82.12]
X-ClientProxiedBy: EX19D004EUA001.ant.amazon.com (10.252.50.27) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: E5B8F18001D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ajig8ny67jxbck9m46nn1713j5orwu54
X-HE-Tag: 1764607723-357127
X-HE-Meta: U2FsdGVkX19trq9TB8i3Xr/g1mtBtIM9T2fxS50ouOSHnaWAGQAMgckxjKs3utERaVIY7aT2TqdbU0oCDMHVA9t+EzR5/knEm7528ReTUJqGtu64btKBNJlHxkU3GsHIUfNVJrFbXz48xNwbKRLKvgDLE1BoWk9jBUFnoIJA/oE84jSHwTYokR/Dwl8EkNHkDQFdnWN6x7mxVwKRVgJ6kGRDM6GnfW4yqTFR9fo+sZtyCfdSlfO2nrqZdGnid3+T+fT9S532oV2zK0ivWIf3AMURVBa+3YEUZt7mTIAO0D2+wxwLCAWXEH69fkvGTTWqEuS4qW7kAM7Hip1g9puFWwjgOYR7+HR9UdYErxB547OrrMVQjBcGb/tX+40qedg0ZWAo5B7+Kac7x73q4vPyg1Kufx5Fhd4l12D8Gx3oD8BN1RUZPDON7u2GPPaheenjA0LFEkbpL7z/mN8QEOhbhZAm6oHezGd36liDIwsZMZ9hMh6VCuIfrlfa+4ZLvgzJq2IJ628VMGwohs2ewLhjiWvrbd08swHIf8/UqNytO5IOBaccFg1NkYN7S/w+Wca7s01gCtvyP+Vlt00AcbgihFjgPFpFxhO2zvTmJWIg8KEdbhsVvSGp7HbaUp/dxKbmDt81QHXjy4R3GQPQYjoAvXqAHMzqoObVxV5ai5XfKmcaOFOYY/mH7PsKH2GZ0TMpGo8S9o2SuT1iilqaBiAqk7akBL5e5O8tDNAJrwvp/PlZLJXF/Ax/hdEgz1Iz/bvUHeZLAjIojhDu+DjZctCglB7TXDSysbOhoBdHKp5DjjvSUWZU42TZurZZa33qQdQRuEeLxjMXWgc/AAYgIhVQOcTzhtqGyirEo9yp/5C7PvsUoZOZx3EAaUP+BvrceNYpc/uLSbzbF4UxdROK42Iad1OBDGtz1XVprhiOxcIQs0mBRDjflA7jQt5HTxjDXKSuCcy99VrzaS148nk4IPv
 2GXTypWd
 XkT0XqN14hGoRlKBFGNq3oOD2+21EU/HROM9zFrMlsFLlVf1uXYthbo5eg3BrdhoV0rkXaQDtCmE4JLDBBtn6OpS/Zh72wCuxil3oPbEvWxtqGaF1jjVCbB94l9Ens1YNqL4e1eQKeIk3TtE7HJKATNJktMHV4aYebYjrBrKYx/2H+wKCDfCY5+zRPya85tOFifCFNku7zqTkIvgmOak3nbgJc5uZrTJi4EHRRlZcvHus0EsdQlpqNF7hXkNEL2+kHpsTG31tVmCa9TkNI6AzUyPV+sthiyEd9WhWIv4uQtMRu6bYw1osfJfbJ3gk5cgVYtkIlu8O1ko882T1Wf474ujHVzcnwrYrB5Y81k3vAajIo8JtalKm1w2XwI4kF9oJ7LN+mcnrZKOFeVB9PN2xjJ9msnvGLj9MIJpWp8W6hsMuCByGOt90mtt1yWFCd1gV+lPxy9PXYB6TI32LpXIEXzseu2StNSyry4/qQVI5m+0FXm4MjP98t9Oi8qo+yOj+ujy+Po+FKdkXYnrbiFMCuKMefGYjNlHXAyw0pj9BBGKv5/WCAjDMxy/7t4a08MUdc+F1LldOM+gMi6we6I8qX1GoI5ZTV1iQPC4ulpc+VRkkKUUJdc0jW6B0TXhG9eUzKJdRJ6cDbgM0R4Fqu0cuVrtV1rmflH4NpxmTCgeNwCyDr4yJYRuXCA0EF3aT1fEcbeylq07DzTGxN+uC7j2vcJX5KIeLRnm4x7ktLDeYx83qmBZ1jemn9GQ9ugm2oHQ9V8HcdR3nrvrgHIMje2hxtLFHL+47pjzvYXhjPAmH+rFNmo83p2Nbj8TziS0QURnRkNlY2ZI91xR2ynQK+7N3jDycjnyY55+nMqPtwkam3m1ueQRHLwQeaY1nGk1cd8c/Q6wGfrSEylEh3dh2FGuPL/zkzrIeejDO1M1P1Kg9NuO3TqiMSkC/QzBRVgh091dWH/2OSZfYiiOLGQN4vm8s5S7NjIwy
 c+Mw4jqX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/12/2025 15:54, David Hildenbrand (Red Hat) wrote:
> On 12/1/25 14:39, Nikita Kalyazin wrote:
>>
>>
>> On 30/11/2025 11:18, Mike Rapoport wrote:
>>> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>>>
>>> userfaultfd notifications about minor page faults used for live 
>>> migration
>>> and snapshotting of VMs with memory backed by shared hugetlbfs or tmpfs
>>> mappings as described in detail in commit 7677f7fd8be7 ("userfaultfd: 
>>> add
>>> minor fault registration mode").
>>>
>>> To use the same mechanism for VMs that use guest_memfd to map their 
>>> memory,
>>> guest_memfd should support userfaultfd minor mode.
>>>
>>> Extend ->fault() method of guest_memfd with ability to notify core page
>>> fault handler that a page fault requires 
>>> handle_userfault(VM_UFFD_MINOR) to
>>> complete and add implementation of ->get_folio_noalloc() to guest_memfd
>>> vm_ops.
>>>
>>> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>    virt/kvm/guest_memfd.c | 33 ++++++++++++++++++++++++++++++++-
>>>    1 file changed, 32 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index ffadc5ee8e04..dca6e373937b 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -4,6 +4,7 @@
>>>    #include <linux/kvm_host.h>
>>>    #include <linux/pagemap.h>
>>>    #include <linux/anon_inodes.h>
>>> +#include <linux/userfaultfd_k.h>
>>>
>>>    #include "kvm_mm.h"
>>>
>>> @@ -359,7 +360,15 @@ static vm_fault_t 
>>> kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>>           if (!((u64)inode->i_private & GUEST_MEMFD_FLAG_INIT_SHARED))
>>>                   return VM_FAULT_SIGBUS;
>>>
>>> -       folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>>> +       folio = filemap_lock_folio(inode->i_mapping, vmf->pgoff);
>>> +       if (!IS_ERR_OR_NULL(folio) && userfaultfd_minor(vmf->vma)) {
>>> +               ret = VM_FAULT_UFFD_MINOR;
>>> +               goto out_folio;
>>> +       }
>>
>> I realised that I might have been wrong in [1] saying that the noalloc
>> get folio was ok for our use case.  Unfortunately we rely on a minor
>> fault to get generated even when the page is being allocated.  Peter and
>> I discussed it originally in [2].  Since we want to populate guest
>> memory with the content supplied by userspace on demand, we have to be
>> able to intercept the very first access, meaning we either need a minor
>> or major UFFD event for that.  We decided to make use of the minor at
>> the time.  If we have to preserve the shmem semantics, it forces us to
>> implement support for major/UFFDIO_COPY.
> 
> If we want missing semantics then likely we should be adding ... missing
> support? :)

I believe I found the precise point where we convinced ourselves that 
minor support was sufficient: [1].  If at this moment we don't find that 
reasoning valid anymore, then indeed implementing missing is the only 
option.

[1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local

> 
> -- 
> Cheers
> 
> David


