Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC17C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24FA6B0088; Fri, 25 Sep 2026 00:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FDA46B008A; Fri, 25 Sep 2026 00:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A226B0093; Fri, 25 Sep 2026 00:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F59F6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:47:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5D30404F5
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:47:13 +0000 (UTC)
X-FDA: 85251050346.07.C65A7E5
Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	by imf30.hostedemail.com (Postfix) with ESMTP id AAD1680002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:47:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FCNIHfma;
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790311632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ws9g4s/YoTiDLHMA2x4FV+HBC9j3rDWE6K0TZSjCveA=;
	b=GEeLJA0g7Ap6cJWQrfaOOk4h3RuQZVzd3uZ69WUdNwx8SQXTT7kuH0Q47FRZes/WBrjm8T
	l5BP5lgFFGAq95jMYsOTB+ew8gkQcNd0YsNCbnvvw8K2SVHo+K/hv/og15WV2K8Pfqr2+d
	9NMmP3rcoDKjaQps5BqNnzcIlDULG/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790311632;
	b=vQXeV34WmZ/2aQfe4o54uzLJERpUlDbzWAj5yn+/EzH2InbrGXdRUJ0h8b3siLuENtceXs
	/ofWP0a96S22nbbNbUhmskjOqX0TyGZPF/2HABflcXC1XvPi5oHFRKxVBu8K7VuD+YHNDh
	lYF281/6JEvbhJgQ12vHGo8NlxFGzNs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FCNIHfma;
	spf=pass (imf30.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jh8C5ShYQXr3viaQ/Mi2fvp0GqNzxRBy1mECrQ4hGaU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790311630; v=1; x=1790916430;
 b=FCNIHfma3LS/3JaA2BJJYgDvh1b5rgyweLTodShdjDg10c9sNGQLzo2UvkvnwLTdJtjoIrS7
 mMXE2rZi3p1dVlTJpgMILbaFwI/JbzCqyKkox75GhQxTTxTX2sEMVAnja/huZQTORQDsTLPa2mX
 vlIlxjfm+N/2uTk4OrJ46b9c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f70f5b72ae709b91;
	Fri, 25 Sep 2026 04:47:10 +0000
X-Mizu-Trace-ID: f70f5b72ae709b91
X-Migadu-Flow: FLOW_OUT
Message-ID: <b1a845c3-3720-4ef6-8c97-8a40ee7bd286@linux.dev>
Date: Thu, 24 Sep 2026 21:47:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live
 Update
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <20260918200640.887030-1-dmatlack@google.com>
 <2e88b92a-d3f2-41f7-bdbe-11fd71690606@linux.dev>
 <CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AAD1680002
X-Stat-Signature: wfkd73he93wodxinesqfmuijbkm57e9s
X-Rspam-User: 
X-HE-Tag: 1790311631-16875
X-HE-Meta: U2FsdGVkX19j61hn+l0loVO2Ab+zTqXEcmPvvJUfxn1yPDT7QtT4XjZ3kVKdq8hGaVpbB4Uj3iDxKqwUfYZ8k4ReO1a3wM2uNQCLzQ1cQtH0yGOzMWq3TAzQop78G5WzsYXVN/M0U3uzvVDaJj5DoN+jBncCwfJihM+ujjiXYE7Eqhri+gPFafGW9tYjm9cNVlnWsgVqRNX8pKRFPUTpGAZAkG/1OXDFBDI1+ZcwicefdILGggIULThOmKNQG0K0e38Rp6noRL8lgnvOEGAw8qONMvtGVjDgHbLc9Sgd7yYeAaM4xOk7P805efpEwJGDZXRU8RyZ2Y9CYfKbzfqjRVgLlnA8bZhZ+gjCIQ+0ldlio4mL9uomBRyqDplsqeG3ouDTZMjraLHiRpTIGOsml9t0b4RfK33gbXvq1qTS1Ia+SaE04KJvLT17ZR1ZrjhodFK4Gs3jKQ9dkmUXH5+ZLlh3Y+cav6uiS5WmAeB5NJD4Dh6NnwYLK2HTLb5EnqJwADUksePmTM8095y2MKjGTkJpBO4z1EL0VbwMjg7NvEmkTBomeWuWma9jQ5grtuYI4w8chxdS8Hm4fhEAxhzFBIyvYsnMmflMewVcb022nEVRC1XAkjRVJxyHYx76qmRL9/jlRBJEKBeP0gsveh2+9vtLsx7N/nt6m1VdH5yiynSii3umPNAGoOIOIexG6Cn4XVOUSVXU6C1xcqrBF/0T9wMkOyV/kCFpVtnqx1p2UgYRHM5wkWMpDUMbhufgUokrlmE/uKVnQiFZfXI+cmXLIdvZa0W7uNQRt0TyQj37aeJCNwdlM4GyKVhjbT+KVvufcqZCjsmo/JHAr6QCw42zukKKThDylLbvd0x0KcNYOFWzGSgYNZYQ4z8wVpxOMNHEn80nzuZEzd7BFbh+ouNgvT2Wah66V7mKjx1qydu0k2DenpfWh6VaRWPTbU1s9gU9VY9iTS6JignZt42vjc3
 T9N1x1lE
 9OiSfzFSGzV0X0IaX9tJkwxvDOH4O392nVTy5lzb1Ux1IWQUbYvpqWaP1TntU+mHfwhjeSwmJjzXokZN+6wpElxOAFAli50CQInwPTXjoWWNWO4HuN6BUq8SpAtBnC2nS0zRJSH2AsfwerOUQO2B+G5XDCZujwzF4vY+IB0vinbvpRuJVdEUfeStlT9CKjhKJByjIj95u0xGvu/6JYev7f/3jr2eX5jt9nJOJqFkcs587dS6vpeUJNtIkrOgRproeJkqQqzzzvpiZW8VsyJQjgRWaYgrxZ/2IY1BwWDl4Mb8kgslNV47fgp50JSvr+qfMQt8JGUg0pn5GcXS2wmz3Pq1BDnSr7dG4zr/pcbRECYI00hf3grFUjno01D9sq/xK309oK39jE37Cpg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/22 11:53, David Matlack 写道:
> On Tue, Sep 22, 2026 at 11:36 AM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>> 在 2026/9/18 13:06, David Matlack 写道:
>>> Future Work
>>> -----------
>>>
>>> Following this series, we expect to make further improvements to the PCI
>>> core support for Live Update:
>>>
>>>     - Allow P2P across Live Update by avoiding resizing or moving
>>>       preserved device BARs and preserving all upstream bridge windows.
>>>
>>>     - Support preserving Virtual Functions by preserving SR-IOV
>>>       configuration on PFs and enumerating VFs after Live Update.
>> Preserving the PCIe topology, bus numbers, ACS, and Bus Mastering across
>> kexec is a foundational step for minimizing downtime.
>>
>> As we look toward complete end-to-end support for DMA preservation
>> across Live Update—especially for VFIO device passthrough and dma-buf
>> sharing scenarios—IOMMU table/domain preservation becomes crucial to
>> prevent IOMMU page faults when devices continue performing DMA during kexec.
>>
>> I would like to ask about the current status and roadmap regarding IOMMU
>> Live Update / KHO (Kexec Handover) support:
>>
>> Is there an ongoing effort or RFC series for IOMMU handover / page-table
>> preservation currently in development or under discussion?
>>
>> How is the coordination between the PCI core Live Update mechanisms and
>> the IOMMU subsystem being envisioned for preserving IOVA mappings (e.g.,
>> restoring domains or handing over root tables)?
>>
>> Any pointers to active discussion threads, RFCs, or future plans
>> regarding IOMMU participation in Live Update would be greatly appreciated.
> The first IOMMU series to support Live update, can be found here:
>
>    https://lore.kernel.org/linux-iommu/20260921004834.2601285-1-skhawaja@google.com/

After cloning the source code from samikhawaja/linux, branch 
iommu/phase1-v5, I tested the VFIO live update functionality in my local 
KVM environment and encountered the following issue.

When I run the following commands to verify that VFIO live update works 
correctly, I get the output shown below.

I am currently testing with VFIO v5 and PCI core v9, and I am not sure 
whether this behavior is expected.

Interestingly, when I revert the following commit:

vfio/pci: Preserve the iommufd state of the vfio cdev

the issue disappears.

Could you please let me know whether this is expected behavior, or 
whether it indicates a problem with the current VFIO live update 
implementation?

"

echo "vfio-pci" > /sys/bus/pci/devices/0000:00:04.0/driver_override

echo "0000:00:04.0" > /sys/bus/pci/drivers/vfio-pci/bind
Preserving device in session
vfio_pci_liveupdate_kexec_test.c:122: Assertion Failure

   Expression: ret == 0
   Observed: 0xffffffffffffffea == 0
   [errno: 22 - Invalid argument]
"

Thanks a lot.

Yanjun Zhu

>
> The IOMMU series builds on top of the PCI core support (this series)
> and the VFIO series linked further up in the cover letter.

-- 
Best Regards,
Yanjun.Zhu


