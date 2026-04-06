Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D8BF46C69
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 18:09:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A047F6B0126; Mon,  6 Apr 2026 14:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5B36B0127; Mon,  6 Apr 2026 14:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CBC26B0128; Mon,  6 Apr 2026 14:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6C46B0126
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:09:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3A8F140571
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 18:09:55 +0000 (UTC)
X-FDA: 84628919592.02.7F23A72
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id F16F912000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 18:09:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HrKy4i01;
	spf=pass (imf29.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775498994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85/sv/Jd+nnLebgu7yOJ82/6JMUXxVcSgRKO3WW/KJM=;
	b=TsZQXjYTkc4gIIE1O52E74B7Law1nj+j5q3PcMu+WFPHhjaxk0+ycQhmPa0klNmuWaEDmJ
	/IignZ0Vrj4fjS34gmyhhAZtK7IyFqjmnH5WLY13GjSUDlVkn9sSqNGxGjVewbdcTR12H1
	d4bso3yhe/5Cos1hrx9wrfvGKZ9Sof0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775498994; a=rsa-sha256;
	cv=none;
	b=bXeoIuN1jGXYrrMvUd0dJwA9sRvuancLPQ1DJjVsuU6xYcyqIqqELNLXPI5Z3pNGYQeEMv
	Z6S1mT1NTNoYwJ/Tnq7V3GtiBVpqkmit5TonbPRfZA2mCthdvSdkV1RyKfQ7ERSyn64qDL
	YKEQCvoLBg2oKwivKQGThtoDPVsUhlM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HrKy4i01;
	spf=pass (imf29.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <1c5fd907-f610-48e4-89cc-4040aaef2674@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775498991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=85/sv/Jd+nnLebgu7yOJ82/6JMUXxVcSgRKO3WW/KJM=;
	b=HrKy4i01v27KUFcXt/1w2kf+yZsl5MXCFBmMdpuBla2c4B2kFG8UdHSH93UsEojRTPjWIJ
	RVbUZS7qtBOUTvf1Fe92L2hJ6/CpkB4KYvevqVhozqjWCBottlm/LzMr5DomESqDJznrrj
	NsvzlhYZFx9aBwmc2y/0M9aHDJw9o8k=
Date: Mon, 6 Apr 2026 11:09:37 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved
 across Live Update
To: David Matlack <dmatlack@google.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal
 <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
 Askar Safin <safinaskar@gmail.com>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 David Rientjes <rientjes@google.com>, Feng Tang
 <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
 Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>,
 =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
 Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-3-dmatlack@google.com>
 <e3fe7085-1297-47b8-bb17-a48196e8f37f@linux.dev>
 <CALzav=eyf4XRTi8MfE_GBNSm+tjmfX7=d0M8Aj5Hh0vJn7huew@mail.gmail.com>
 <c4138f66-edf2-4689-b5fe-16dc4839e9c3@linux.dev>
 <CALzav=ei_xSfM0MTdPFhGDjNwe3EQ0vHPiEk=vszFX-Xi_KjQw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CALzav=ei_xSfM0MTdPFhGDjNwe3EQ0vHPiEk=vszFX-Xi_KjQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: uw1zxjhigjo3m48pxyn4ur9tuap8yghd
X-Rspamd-Queue-Id: F16F912000B
X-Rspam-User: 
X-HE-Tag: 1775498993-327893
X-HE-Meta: U2FsdGVkX1/GBXr/hpN2ZC6rdFE64PmuNjc/M1FHgVWpfIypILlUhVcK4Bwuu5cznm48i+qFijhjtok2HhZ41Nv4x4LBuq/3cbVgyh1E2j0Vp1MBaNy59Lb3BQHjlcuJ6Ofi3lvp/ejcTkJNwYzlZQgu+kvwlT54JSUOibHR9MZTTsKmXaPZOY9t5V6heh0s6sBFBN0u9L3ldo4l0JepD4nKbjfMdmty4sJeEpIXldXFty46R0dpgxTDpwRHWS4lSX3010ShoZKX0kkTlEcnmBqH9jOh4shLXaS2IyX08RfguGYiLqUTAn3UQbezuc7cyhRuY0GxjU2llj9kf4dp95OEDOmkTWXSmpcynS3CIDsaD7lRn8UWUJG+laDYqJufPJ/QaS+7FDceWekbbiPvr5L28fa7Y5sZyBWz3rJzuebUwJwrqhocvY83Jz37NlH6M5vZGEeqgm9c8Li5CB6AslBdEmawrB5oXp5XTwcMynB3W1ky7W2bSM56FohhIT9cgTQW7Clc1LuRsG3iJS0bISjHla0awnoWbLRvLQMYRgv6wTCVIArrBWN06yJm3EdampGsTnB3QXsO0k41jj1NUOsZekpBSRf1tH6KTzKlefOwTBCx45X4rMFyoLX+9Ajux4csviBDXToSYuhWxuj6AJZ86WBxYTGzVTuMeD5/aGZqjiTulICmlJPDvi6lRZ+imIez+lCyG7QdWC7nHQT4A+SjY8u7Voh5r9qwe8S5v2Q4i5RMXRZ5DVnOkvMsMV8d5l30ddx4z2bnEZaeDAAFSzhrZ93zX6DRbo0+/drf9INuNa+7rOH4YodUtjmbxkXiRa/m1yECtRGabfZXN1mEIhiaChtD1tv01o7hU5wENYhBuhkBVci5MD2w/wncb/CWx5JosJDyUavaz2Kvk3OtdUdgsO+/lwYw3+JWHOKUzp/9+LBxgB8kM277FUPyRNkXkPr38FvtNX1pgP4dXl2
 G/DSvvUc
 VUXDswv0vkOsbwKTM27D3MqEGppiUbPC5eTqE5/TUV7cRGZ+gbzd4oCIiDkTMOdKGt8f0RxM+6VIq6Zw8LeT+PThwncacVUeHvHlkc0RKCBR0geoaS+9QXT209HdpEMr93q0yMlzdCnnNXfjPXuEQGIPYCbcPesH6ZCmWXLNYIyU9RtlXlYCXV4w1rMbrMzNE2ImqRAyXtxhuGT/kWvX1YrlXvHZdQAU32BF1IxJogWRAUa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/6/26 9:06 AM, David Matlack wrote:
> On Sun, Apr 5, 2026 at 9:56 AM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>> 在 2026/4/3 14:58, David Matlack 写道:
>>> On Thu, Apr 2, 2026 at 2:29 PM Yanjun.Zhu <yanjun.zhu@linux.dev> wrote:
>>>> On 3/23/26 4:57 PM, David Matlack wrote:
>>>>> +config PCI_LIVEUPDATE
>>>>> +     bool "PCI Live Update Support (EXPERIMENTAL)"
>>>>> +     depends on PCI && LIVEUPDATE
>>>>> +     help
>>>>> +       Support for preserving PCI devices across a Live Update. This option
>>>>> +       should only be enabled by developers working on implementing this
>>>>> +       support. Once enough support as landed in the kernel, this option
>>>>> +       will no longer be marked EXPERIMENTAL.
>>>>> +
>>>>> +       If unsure, say N.
>>>> Currently, it only supports 'n' or 'y'. Is it possible to add 'm'
>>>> (modular support)?
>>>>
>>>> This would allow the feature to be built as a kernel module. For
>>>> development
>>>>
>>>> purposes, modularization means we only need to recompile a single module
>>>>
>>>> for testing, rather than rebuilding the entire kernel. Compiling a
>>>> module should
>>>>
>>>> be significantly faster than a full kernel build.
>>> I don't think it is possible for CONFIG_PCI_LIVEUPDATE to support 'm'.
>>> pci_setup_device() (which is under CONFIG_PCI) needs to call
>>> pci_liveupdate_setup_device(), and CONFIG_PCI cannot be built as a
>>> module. This call is necessary so the PCI core knows whether a device
>>> being enumerated was preserved across a previous Live Update.
>> After the following changes, the liveupdate.ko can be generated
>> successfully.
> Sure but you've broken the feature. Now devices can be probed before
> liveupdate.ko is loaded and the PCI core will have an incorrect view

 From this perspective, I think it makes sense.

Zhu Yanjun

> of which devices were preserved by the previous kernel.

