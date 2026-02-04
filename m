Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C027E8B385
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843126B0088; Tue,  3 Feb 2026 19:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816C86B0089; Tue,  3 Feb 2026 19:10:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718BE6B008A; Tue,  3 Feb 2026 19:10:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFD66B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:10:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07C6AC1891
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:10:19 +0000 (UTC)
X-FDA: 84404842158.07.0A8E8AC
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 094BA8000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:10:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ApRMKyWe;
	spf=pass (imf02.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770163817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zPnG+2FnaGlQfzxXfIjWuGajlOFPpBxdoaiBCLVKvoU=;
	b=g6XrLaPKbEW1Oag04cnLVy7y4deqj8v0gqxYj+XgXwy+/ZAeMwakNYraU5ygITfudtehxf
	s9ZzEpnHXo+2QsbmGOcUH7rnC1X/fmDr51kiwJEd8GleOIYaY9RfmXTUfXP6oR2WOliK1S
	oLl+EPiesS91AL3Lefgke91A3o3/6YY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ApRMKyWe;
	spf=pass (imf02.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770163817; a=rsa-sha256;
	cv=none;
	b=UJgjP0GmGKD+sfDLpR3y7yEMj6jHYVmrYkf1BAFVpXJgKu8YrFl+XyN2YAoOGSoJK8u7Bp
	M+F5EnLbZ3KOrfEqQ6pI50GoKntI0n2bhfzc7FA7FV1JjA2QqJYQwha8cbV3nqMgrjNFr8
	CzcFxEDPi4Zw+fC06oGZsVptI61CHaA=
Message-ID: <7e49472c-4bbc-49fe-92c6-621e4675d882@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770163814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zPnG+2FnaGlQfzxXfIjWuGajlOFPpBxdoaiBCLVKvoU=;
	b=ApRMKyWeexGTzglygbcOHhU7Wfd4rnLeiMI+Jogeatu2nhRqIkK0lA//+bUOV3vFAbHCoJ
	mS0BsrYP93R9bxyxRU1fhniBcUvx2p4NhTCXzAkUT0zL/EyR+YUdOmdiWZC6zP6HhDzLGT
	UyQfu6GTd6zJWiBQ6KJq5hvzWsaEowg=
Date: Tue, 3 Feb 2026 16:10:04 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Alistair Popple <apopple@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal
 <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
 Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
 =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-3-dmatlack@google.com>
 <44484594-5b5d-4237-993c-ac1e173ad62e@linux.dev>
 <CALzav=d1ZrHrWd-HhZJ8aY6aqxkBcLoet_5+-LL1mOakVTj6Ww@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CALzav=d1ZrHrWd-HhZJ8aY6aqxkBcLoet_5+-LL1mOakVTj6Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: juk1e5zkhujuptpauzy85utwduedinge
X-Rspamd-Queue-Id: 094BA8000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770163816-357744
X-HE-Meta: U2FsdGVkX19iqysyq/fPzor6PZ2rL7xecqGd+E574+o4Pkc7/2Jg6mZSNnWg9II2wbrToieKxR/nKHaoj/6bzgKUe2EgLfOLdTnQ3gi+jyCLLUekzqDsx3YttvjYAjQt+3Z8PniSUFviqcc6cG35dPvm6qvAzJWZqScvY/ez+rCBrXgOpia5FNLMY5cCs9XiJ0P4s9vzDkUKbRVAWWPtgo6WFdYUSduz9eniVxPrMN576yk3Q3x4NkP2j/8IDUW3K+nrNWIh20v7GAeJGczWSDJMNYFUTxY8rRNxQKpQcXRCFzlQp58hXWrDERO4TPYIpdLq00DBT/rwR7JGi6wh392xXphkxDgAvU5Pish4zp5zR0lBLP1kiMQv/JoElY9ej26/AzbizB2M99YAc2RRxnE/pQlIh+s37NA1frj+MW/gJkFuoFtLIdHiHd3pXmCQ+2ZRDCSGmIddg8spGEbhhBjCGp4zDuUFj+s+jtv6U9n6TTbAqcE87dZq27FkXFuuWtr3/BB6M2n5oRPHnWcr7rnU2Xl2YaDy48yuMJN/WV6eNpYh9A3MX9KQQJj5iMjsxbbl0hZ8dhOsNDo7kAVhVKc3HKOnnqBi3d7rp2/rXFvUkkQCix3pIQZLpGJy8PJDqWQO4nEMQv8rlf2WYPekFzP27ojG+3DP9iGffH3AhrztEPmmW6c1sHphNPYJ/2IKrIxyBxFWsNQ0AyM0OenZrtAZBYD4fsoVgeQGxgCtvcnfdqoGkvfPCytuS7G3+awVgX3tq+qWdDl0u7BI1/lzc6ISsts1glUdA7XeB6P0q1ujCG9EpOFuKNlFBpZdLg+JoPAso4uKaNSJ+MXD8oyIoMhX5tdL2iUjMoQAZXGLMnggFxZwNwsvtP667wu7mZKN171oajKEoO8TvRRWhUXNvSpc+p46+Uzjkacf31Aj5CSq9zViOY6igVa+DP3/sne5GVwkOwOUF52McLZLkuS
 lHElzYH7
 A5MfXjMR+vgvuExJbLKefYahs0OgifdSt2X1RpYSMu2qkuH729CKaI0OfiMbKDFLFxQzBpvhAUvlyrMmWlD//OpNXSKEwQanX2knDpqFBEho/dzs+//QrJiJxEO3/F+to4ZQGjJ3jqQOOx52X1miq14oKt9CDK3dNhqCSsOkt3q3wZCa32ls11UpDxRgr7hD7gxBDUL4HD8177OJ4NBL8RN0JkTKDPyLMdYRXpc/GNssauIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/2/26 10:14 AM, David Matlack wrote:
> On Sat, Jan 31, 2026 at 10:38 PM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>> 在 2026/1/29 13:24, David Matlack 写道:
>>> Add an API to enable the PCI subsystem to track all devices that are
>>> preserved across a Live Update, including both incoming devices (passed
>>> from the previous kernel) and outgoing devices (passed to the next
>>> kernel).
>>>
>>> Use PCI segment number and BDF to keep track of devices across Live
>>> Update. This means the kernel must keep both identifiers constant across
>>> a Live Update for any preserved device. VFs are not supported for now,
>>> since that requires preserving SR-IOV state on the device to ensure the
>>> same number of VFs appear after kexec and with the same BDFs.
>>>
>>> Drivers that preserve devices across Live Update can now register their
>>> struct liveupdate_file_handler with the PCI subsystem so that the PCI
>>> subsystem can allocate and manage File-Lifecycle-Bound (FLB) global data
>>> to track the list of incoming and outgoing preserved devices.
>>>
>>>     pci_liveupdate_register_fh(driver_fh)
>>>     pci_liveupdate_unregister_fh(driver_fh)
>> Can the above 2 functions support the virtual devices? For example,
>> bonding, veth, iSWAP and RXE.
>>
>> These virtual devices do not have BDF. As such, I am not sure if your
>> patches take these virtual devices in to account.
> No this patch series only supports PCI devices, since those are the
> only devices so far we've needed to support.
>
> I am not familiar with any of the devices that you mentioned. If they
> are virtual then does that mean it's all just software? In that case I
> would be curious to know what problem is solved by preserving them in
> the kernel, vs. tearing them down and rebuilding them across a Live
> Udpate.

Bonding, veth, rxe, and siw can be used in KVM environments.

Although these are software-only virtual devices with no associated 
hardware,

they may maintain state that is observable by userspace.

As a result, Live Update should preserve their state across the update.

Zhu Yanjun


