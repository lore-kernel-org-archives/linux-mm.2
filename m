Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39105C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 22:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9915C6B007B; Thu, 23 Jul 2026 18:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9428C6B0088; Thu, 23 Jul 2026 18:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831726B008A; Thu, 23 Jul 2026 18:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9076B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:19:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD1DA1601F1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:19:11 +0000 (UTC)
X-FDA: 85021458102.25.0D239D0
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6545EC0004
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:19:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o1hEm5gq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784845150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0SzsDUN/BFXoWvc6OI68QQ0aGQFC3X7Tv8gtb7Mzg8=;
	b=ST3iIN9x90QY9l0fiCy1z0aH+uhM/BbizltUNuM+jXY7ZPQAo+nhSV399gRKEdw0oIejOK
	W02/SGaSXlJF6j2xtaqapcj0P3iMURjFz7tiJN9i1LYhzq5NvOj5TeeHie70WkobzBTtxs
	MxkuTlAVrrFhG+Yi+zQSqkdt0fjQg6Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o1hEm5gq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784845150;
	b=wtEggQzMc/p4i3bnsyu/nAqfypeUzV2l++tCGM3alFLLJ+SbuabdTflbP7dxbQBdcUSZML
	hz+X2WMneuec3acriBzfdyDuwInSbOQgFX1wpLsd2kPZRKMgwWa2mkmYX0NrMTuKreErSH
	XpFcf90OBIsOwvlhG0POLFUvl1W5Qjo=
Message-ID: <cebd1045-5dd7-4f35-8750-9c39790ceae9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784845145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G0SzsDUN/BFXoWvc6OI68QQ0aGQFC3X7Tv8gtb7Mzg8=;
	b=o1hEm5gqbSFXjNQ4yIfcWqVF8F2VgF7agEYdG4EH8wmp+G1vDgDZuukjZsNrRRZEMTLDn8
	e2RghIzHx5oniMfYsrV4kpaicQc52zsfUQFC/Lj9EgU93DFRi4xAAwgenWevULM+oLxJIs
	Z9M3QnjiLFjyIalbt7oDxrbrLyVCbiY=
Date: Thu, 23 Jul 2026 15:18:55 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v5 00/20] vfio/pci: Base Live Update support for VFIO
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, ajayachandra@nvidia.com, alex@shazbot.org,
 amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com,
 chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net,
 dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com,
 jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com,
 kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com,
 lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com,
 parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com,
 pratyush@kernel.org, rananta@google.com, rientjes@google.com,
 rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com,
 schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com,
 vivek.kasireddy@intel.com, witu@nvidia.com, yi.l.liu@intel.com
References: <20260714151505.3466855-1-vipinsh@google.com>
 <2c03ac97-60a6-4352-a942-27dcebae8d22@linux.dev>
 <8fd94fad-e457-4839-9e41-ae257a138bee@linux.dev>
 <20260720163452.GC1191959.vipinsh@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <20260720163452.GC1191959.vipinsh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6545EC0004
X-Rspam-User: 
X-Stat-Signature: mxeqe9a5ukwwgbp1i8ycp5zm1qhyyz35
X-HE-Tag: 1784845149-210058
X-HE-Meta: U2FsdGVkX1/vPrr+7RazAfR1V/Hxf+Dnsne47ykToGJCRfseUsVTm7WK6v3arGXN5XyZERLfGpuuNX/f4nYSgX74xZmhPFQkwAI+wnga+3dkzTMBNgIoKUknoDP0shMQm3RPoEbhMfurlZeFIfQl4SSx9k/jcXiRwU/KTggTm8LBN3xiDikJPznFgvAEr1otRmDczZBYu1/p9XGo7lpUxkT4S57bz8+iiriha6MsyD27Au9VAqtTuX2K04/cumA+2SBYVFwYK7JLMFq6A/4r49jsAnyJ2vjDoSXSyaIsICkLOr02OnDoWPEEhGGD/uImfNU00j+N3B5VxtsbI2REWTsptBPi7OcKhhwVHkveYOwbkckokUigA4c4e0LXprZSAnF9828uziLnX7XHij4XWNpbKEW4BGMSGxkGQYo/dLYYTkpCcsg6oFLTXAe6CX5hS94Gz3vMlFU9nWXE3Nk/MFqZS0anKSqpVqn1lPcW0yptjEG61W12BBaZQAYSXn5F9wiDhlb0gJRmjxQFkZtFb8GkwhuiUUozkCjQscJx/av82GunWCoiyqilOCtjpgiUq4uPGNCku6SUfgZwY2tqaUyi7dG2tWZ8VHfaN3gUPIezwkTF4DaPrS/X4Z9mMAXwqluhR8P9fABBUNiriFhvkEVgYi5CzU785mG93KudwYUeDDc6fKgc4r60V3e/ZNRZ4PeQ9k62dJY6yr6VuL4yB9cpcxBFIcraSYX8B1LIATpe794VuRi8Dr+866fDQmdmZqqsZwXAKzK4sVAZgVJ1UM002YCPUSs1/91mMbf/z5Kb0voeKi785KlDUw2PLWVjoEjNIDtlibwdS32buCGBmbUS4Xs9VFBDm9q46SoJTv4JC75jr1v1aFWYFBjluXmqKR9lvH2diiciX4D3iHn0qnXRs5XT3EcvCUNWxFlaWeqyoPYsxYVO+//8asx6jAsElJAQVH9MZYcs2GetLBl
 z+O+o+Sy
 4qAf9a3nLJSBKdgnpd6Rb67gMbm13+7KxJ+DuDm0sevEQLRkdsL5LODDkRZyYOCYXAXtrS+58ayf97EWjeZ83HRgQhgJukC8WZyMuVc5oblS7RADMa97OFe14KfH3E3I7GBOAs/l/x88UJUwk38Obr3A3ifJ3SyaQc8AYUxipsvQn/w8KzwNloCVgx1bRkCY3s1WlkIjxXMLLfkabmKAaP8Dym26iXy2qhxpzYelG5JsbhT8P+3jUCSPDfyTFHFQYx7nWas9vcDC1H+LpgZ7R8rs2yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/20/26 10:08 AM, Vipin Sharma wrote:
> On Thu, Jul 16, 2026 at 06:22:07PM -0700, Yanjun.Zhu wrote:
>> On 7/16/26 4:24 PM, Yanjun.Zhu wrote:
>>>
>>> On 7/14/26 8:14 AM, Vipin Sharma wrote:
>>>> Testing
>>>> -------
>>>>
>>>> Tested using VFIO Live Update selftests in both QEMU and bare-metal
>>>> environment (Intel DSA PCIe device).
>>> I want to make tests VFIO Live Update selftests in QEMU. But how to
>>> select a PCIe device?
>>>
>>> what device do the PCI ID 0000:00:04.0 and 0000:6a:01.0 mean in the
>>> following testcase?
> Sorry, this was my copy-paste mistake when combining things from both
> qemu and baremetal. You only need one device not two separate ones.
>
> For testing using QEMU, you can use QEMU PCI test device.
>
>    -device pci-testdev
>
> In VM, use `lspci` command to find the BDF of the PCI device. It will show
> output like:
>
>    00:04.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device
>
> Then prefix the domain (generally, 0000) to the BDF and use the testing
> commands.
>
> `0000:6a:01.0` was the BDF of the Intel DSA device on my host. I
> incorrectly mixed two devices during my copy-paste.
>
> Limitation of qemu pci-testdev is that it does not have the DMA
> capability. I used physical host with Intel DSA to verify that the
> device performing DMA during live update gets reset.
>
>> In my qemu,
>>
>> 00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox Guest
>> Service
>>      Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>      Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
>> <MAbort- >SERR- <PERR- INTx-
>>      Interrupt: pin A routed to IRQ 20
>>      Region 0: I/O ports at d040 [size=32]
>>      Region 1: Memory at f0400000 (32-bit, non-prefetchable) [size=4M]
>>      Region 2: Memory at f0800000 (32-bit, prefetchable) [size=16K]
>>      Kernel driver in use: vboxguest
>>      Kernel modules: vboxguest
>>
>> I am wondering if the above pci device can work well with this patch set or
>> not.
> I think you should be able to test Live Update with any PCI device which
> can be attached vfio-pci driver.
>
> `vfio_pci_liveupdate_kexec_test` will initiate DMA if the VFIO selftest
> framework has the driver for the passed device (Intel DSA) otherwise it
> will just skip over the DMA flow and do the remaining things.

Thanks a lot. I'll run some tests with QEMU's `pci-testdev`.

If I understand correctly, when using `pci-testdev`, only the DMA test 
case is expected not to work, while all the other test cases should work 
correctly.

Yanjun.Zhu

>
> Let me know if you still face some issue in running Live Update, I will
> be happy to provide more details.
>
> Thanks
> Vipin

