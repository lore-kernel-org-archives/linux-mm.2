Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121E6C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 18:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8366B0088; Fri, 25 Sep 2026 14:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61836B008A; Fri, 25 Sep 2026 14:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D298F6B008C; Fri, 25 Sep 2026 14:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98C246B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:59:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E0EDA06C3
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:59:18 +0000 (UTC)
X-FDA: 85253197596.27.E3B386B
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 45C2780002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:59:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qTX8jpSQ;
	spf=pass (imf30.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790362756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryWXjYMx77NDaQsPP9QlmEYj6eVxrasAG766hpzWjdA=;
	b=Zmp2R0pMaiGpm5EzQVCw/B2NrdllJwUjmJO5JsrFqvwsN8OGPebYaHt+XiCKx5jLoRZ4g5
	nbuyWsmf8ix+g3mImC/zJq3+UJCH3QZkcn+0AcSIt+A0O2I+E0vxLOveGjJQxZpCfnIuhM
	AJ3IdBRu16PFhTqUVAhq1bMQuVdIkaI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qTX8jpSQ;
	spf=pass (imf30.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790362756;
	b=xSTZ6BxhIB7S6rt4f+27a7+H4Ca3LkBh1Ea7Uw3vLzhcKusefkxjPmsXPGZ5raWgsc6niW
	41XocBVDff9DtLu4XoiaXIWgc8c8aJidAWGExxbqnzROzV5j5DJBZ0M6p+tgjxTLVNIXYZ
	WY+sMC47KClYv7YZJ9yOmK6zRoDC9Do=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so335ad.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790362755; x=1790967555; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ryWXjYMx77NDaQsPP9QlmEYj6eVxrasAG766hpzWjdA=;
        b=qTX8jpSQkowAodRAl1GG0ZZxA98LPsKHRwRxmYdV6XDzaBWhedOOq9S1oSsPXnoYuz
         faQyHNK0rr1iDLz8rk6heHgju0ESwrLMo3Oa/ynkKfYMAnZumtQlWrT3nSviXddpQ6Hv
         wsdWGa12BiyLmOgHcbl2A9R+7ujpzMjh42KGVfAp10soLWtyAaIv2u4X+YFtd1gf3kGT
         W4LrE8pw+jucr8VL/uujJhWngfrmIONuNh4XDOztxbLrM6PpOP+7RDLHjlkWQ/ALnUha
         sImUTGi+tOHxumkGo139wz34BuJVWYzUzziqYCDGYH+dl3FE4072B4GYeibk/qF1DA0v
         caJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790362755; x=1790967555;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ryWXjYMx77NDaQsPP9QlmEYj6eVxrasAG766hpzWjdA=;
        b=XJU7o5n8MBJovwrGuediXufPl9PZVd2RyHxtxMrG6lmKbPURgRK+oZfBMudSLph7KO
         ECF4YGigtVR9a++7x69K9DCTzwzoKzHC3zh7NQmtQsXsEovzlOJXt9OhnSMfPXnJ7Cea
         cuZQBvyVwE/VQjo9ZSuDowp4GmhfqErr8CSoLC5T26WVx45FMEgUMapbqj1VVkP8yXZl
         nR5cQBWt0OydzJtz3SuX756srmR9a52jqaokPD+llyN61XGstXyRELA2cJ549otBr5Ld
         /29w5oVjVyJPjumyDkpxXKztcMTzl8Pm0o7sLGK00PSqFrPoA4MZlZ4E0rfeeScQHoCW
         BakQ==
X-Forwarded-Encrypted: i=1; AKwUvByUhv9uiPId80RUS0AuFKWGtjOwGI+Y/QQ1w8xAIiZBIjvnOc2L70hew6p+yzDbBZZG3qkGgXnS0Q==@kvack.org
X-Gm-Message-State: AFuF++k4Rn92SBQJXNMd+4jvDmFfOzyZ33AUknz2KOPGG/8z3/nrevXK
	ZS7nhd46/PduJjDK+Ty4wCiaOYirTDoggnFmjsWjt7SPfOsAI/JzlOIVCWHLrmH59Q==
X-Gm-Gg: AYBFou3tIvT5rW3J7N2fQ7onP6ov3Ri6YhwcBRPcaPvRqwLgW1R3W3fvUtkn6/ZRn6v
	3o896Sa7Dv2NFrct8txR9Uuprv2FUhgUnOkaMYW0a6VIMOySjXYCzARtfyjEsGogtxh/cPsd1WI
	WLxQVlaOFjzegQePbHQbf/SfRi1fVzuNrWivXtnpnDzIcHHtnpVx+NK838dJvwam8G3JqRVP0uD
	3GyZ8e45TP5atGF3st2sa/+y32uEZ0dW2Ct5D5xh5WlYDxgHrXqM4p2wj8Z7oXUJNKwf8BUJvBo
	ppOpQfDXCBVDy0k9Ur5K4tUCDaRz/VYqa1vQxMXprbiCKDKd5mz4iUEsU426z8E0Yn7JmhhZZ+1
	53fxC4B3GiLws1AmFWlz5iucJPYfM5ak/sxFCkO7JgdskYo40CtUGXsWJ61au1PsyQ58W5IDobB
	ux/m3TGSD1KYgHgtBUgvSvIWPw2Po5F6GStOvshtJHRQsx+sUObIBs3SqA1JRzkE78JXFXLmbp3
	tq017sOPqvaaXb4/n+LBnU7idNu4EDuaEbjpdT1ZglwSiYvFd3pmTYbZetNmsi7ONhpopcbgUA1
	+Ffl
X-Received: by 2002:a17:902:868a:b0:2ca:4bb4:4bd with SMTP id d9443c01a7336-2dfa649041dmr428155ad.5.1790362754409;
        Fri, 25 Sep 2026 11:59:14 -0700 (PDT)
Received: from google.com (210.87.127.34.bc.googleusercontent.com. [34.127.87.210])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87fea18ebb7sm1635695b3a.18.2026.09.25.11.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 11:59:13 -0700 (PDT)
Date: Fri, 25 Sep 2026 18:59:07 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <aratPy2p33MObulT@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <2e88b92a-d3f2-41f7-bdbe-11fd71690606@linux.dev>
 <CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com>
 <b1a845c3-3720-4ef6-8c97-8a40ee7bd286@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b1a845c3-3720-4ef6-8c97-8a40ee7bd286@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 45C2780002
X-Stat-Signature: 3jnxgbfoq6rwx1ijw5u5i34dbe1dbhbr
X-HE-Tag: 1790362756-800074
X-HE-Meta: U2FsdGVkX19EdQ4pX7NmDq4XY84opUHT3tQF2foIILBdQ904Y9R/dH5vXZd+UtnW7v6FsTXlNGAt8OUxDv5MTA/Kj3skoxZBLeRcjqUcA2Gh9FITXt5eQ0hG5ZRm6rCjO+M4fCRQds7BDdQrWQ6AKzRVVV6/vhShHNS33zpwQgR0lXOJIxrrvcDePFv/gi0SWGE60JcXcy+k/VSA+O+iQuBaysRs3F5VGBhUfGi4uRWQATRiYkGIkYEyQLrNiX/1v4j+Rbr6UJp69QiM1b1tISCmdfU3M38OQRyUVCq3/2QE43Nru7q/VnWOBdenUowz/o5ccoyaCaBFYfcVymxLdVPcW9qZukhbq2meawILdYbd+1o7tXQBzMgFuj54XWGvMlH/4PfJWVh5DjHlR7WKDjakpgd25jbJZRGgBOliHLxwPylWTU/zPkRxxOSshOK/WwpyGnN5Jfu9TW+ojs4jFMukCtiaqty+BZNe5XXk8Oo3zGjaaT979ZxSsbiRlJVS5Idpy+ZsnBa/sIcooRpnqJCifK97mc7aKJhNy5DC9eYSqJZFp4OVSjrZ8V+DX4Vdwv5kC442TjgKN7r1j01k9axz9x4vbQ7Z/7vnvXkhi8d3DtP1f4Ef9jJi+mYD0rSnxjUOxKsLZ1WN7F1L1o+lDRj0rmNXJ43kgSSzNH6N8lkNDQz7LWDr72iRk9ipM9zGouVKAEi5poRp5zMTp+vEcU1z6ttWeiERCmQuz0+qbqDiglficRdRj1FjD9IGuZ2I37oABy2OWhLVZUj/VquVAXUe8HUqFn+gbHRJBy4mR59eRoVLKP2HRPzh5q520VD/nxrbk6TQDaNpM/vwFgDlwr8RMfvLHF4RrD0jiaGMXixS46TMCVFPd73FnkoJnRv32KwQc0ATSU6orpgk8zOZS9JvoIPXo+kJSe0VC0tcCrqosgL14fXak6ML7MQNJBqX1ZKxm0ttXGLbLtPGr3R
 srj3dz/j
 NLIEuqeJ1nRNnTfUo9t1mM0zeJdFg3O7kwt6H0YUek+1stoHHhhRpV2SIOB8TBVYpnKBb0zan1uA5l0i+Own2tU/+D/nDc0xKQfpuscGXLrGhSUjxZAUSPE1Rck2+qe0SAIkG9+x2rPHZmzFNh8UVxRgR1KvIafAQ6Smbl1n/ukPlWjgNiZRhOV0t5eYFPINxs/NC06iddJfYlz9m2rpblI5eylrt9qUL57u6zdnkwtySrim3V2gMoV1RRS40PwS2dUBr5EjlpKsf6NnY6bBug/GXjX9OO+lvQox46UoBWw8YQuQTAr/Z8VilB2L6SdjwgIF1mA8/r7DMnNPWsAP8zWvKOYa6eOpngjRGj0VZWo/o4keWHUnTgEre6e5bp1Y3X66QRrwjT9x+buhhRs4TkY/WE+zBMOqa5/JQLzdtuNE1/ApswfkwSYre0rHab6+OA0kh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:47:03PM -0700, Zhu Yanjun wrote:
>
>在 2026/9/22 11:53, David Matlack 写道:
>>On Tue, Sep 22, 2026 at 11:36 AM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>>>在 2026/9/18 13:06, David Matlack 写道:
>>>>Future Work
>>>>-----------
>>>>
>>>>Following this series, we expect to make further improvements to the PCI
>>>>core support for Live Update:
>>>>
>>>>    - Allow P2P across Live Update by avoiding resizing or moving
>>>>      preserved device BARs and preserving all upstream bridge windows.
>>>>
>>>>    - Support preserving Virtual Functions by preserving SR-IOV
>>>>      configuration on PFs and enumerating VFs after Live Update.
>>>Preserving the PCIe topology, bus numbers, ACS, and Bus Mastering across
>>>kexec is a foundational step for minimizing downtime.
>>>
>>>As we look toward complete end-to-end support for DMA preservation
>>>across Live Update—especially for VFIO device passthrough and dma-buf
>>>sharing scenarios—IOMMU table/domain preservation becomes crucial to
>>>prevent IOMMU page faults when devices continue performing DMA during kexec.
>>>
>>>I would like to ask about the current status and roadmap regarding IOMMU
>>>Live Update / KHO (Kexec Handover) support:
>>>
>>>Is there an ongoing effort or RFC series for IOMMU handover / page-table
>>>preservation currently in development or under discussion?
>>>
>>>How is the coordination between the PCI core Live Update mechanisms and
>>>the IOMMU subsystem being envisioned for preserving IOVA mappings (e.g.,
>>>restoring domains or handing over root tables)?
>>>
>>>Any pointers to active discussion threads, RFCs, or future plans
>>>regarding IOMMU participation in Live Update would be greatly appreciated.
>>The first IOMMU series to support Live update, can be found here:
>>
>>   https://lore.kernel.org/linux-iommu/20260921004834.2601285-1-skhawaja@google.com/
>
>After cloning the source code from samikhawaja/linux, branch 
>iommu/phase1-v5, I tested the VFIO live update functionality in my 
>local KVM environment and encountered the following issue.
>
>When I run the following commands to verify that VFIO live update 
>works correctly, I get the output shown below.
>
>I am currently testing with VFIO v5 and PCI core v9, and I am not sure 
>whether this behavior is expected.
>
>Interestingly, when I revert the following commit:
>
>vfio/pci: Preserve the iommufd state of the vfio cdev
>
>the issue disappears.
>
>Could you please let me know whether this is expected behavior, or 
>whether it indicates a problem with the current VFIO live update 
>implementation?
>
>"
>
>echo "vfio-pci" > /sys/bus/pci/devices/0000:00:04.0/driver_override
>
>echo "0000:00:04.0" > /sys/bus/pci/drivers/vfio-pci/bind
>Preserving device in session
>vfio_pci_liveupdate_kexec_test.c:122: Assertion Failure
>
>  Expression: ret == 0
>  Observed: 0xffffffffffffffea == 0
>  [errno: 22 - Invalid argument]
>"

Hi Yanjun,

Thanks for testing this.

This is expected. With "vfio/pci: Preserve the iommufd state of the vfio
cdev", preserving a vfio cdev depends on the preservation of its
associated iommufd. Since the vfio_pci_liveupdate_kexec_test does not
preserve the associated iommufd, it fails with -EINVAL.

Note that the IOMMU persistence series does not update the
vfio_pci_liveupdate_kexec_test, with those extra bits, as it would
regress after_kexec() part of the test because the retrieval of iommufd
is not supported in phase1.

Please use tools/testing/selftests/iommu/iommufd_liveupdate_kexec_test
added in the last patch of the series, it sets up the iommufd and HWPT
preservation before preserving the vfio cdev.

The wip phase2 can be found here if you are interested.
https://github.com/samikhawaja/linux/tree/iommu/phase2-v1-wip

Thanks,
Sami

>
>Thanks a lot.
>
>Yanjun Zhu
>
>>
>>The IOMMU series builds on top of the PCI core support (this series)
>>and the VFIO series linked further up in the cover letter.
>
>-- 
>Best Regards,
>Yanjun.Zhu
>

