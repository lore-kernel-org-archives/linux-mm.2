Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB7BCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1D76B0095; Thu, 18 Jun 2026 12:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72BD6B0096; Thu, 18 Jun 2026 12:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88E46B0098; Thu, 18 Jun 2026 12:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6DB6B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:35:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F7AA1A0196
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:35:19 +0000 (UTC)
X-FDA: 84893583558.30.401BAD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 553B41C000F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:35:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+hznsO4;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781800517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsJMMWgRXJeP7sRFHXfktToOXcpEZ/f5CxFBiOSnxko=;
	b=Wf5G22ySCeneh234tSH2S3WfCvPn9CgfKb+9bk/ef7gSyx9gb+qyc+MbyXq4Huob7vZibx
	nfKNEURFBdjh/VGcx6M6vyva73XPzX31ij80kfTpunBYlQztPOVMwyQvR+weIc8kpb/HeY
	v79FdkDxlT+x8le09G7QlHjBg+OqLms=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+hznsO4;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781800517;
	b=cbJsO/MkH+QfJ2J0RYhb5C5o9lRE4nM3JAfDh7dj0xdfMvyFSVHG0+4c1NEOEXTT8v6Te4
	8stGzreGHaLVHL8N2B+vQ1N1vAePCy6tva2aqqmVQu8kOtpGELYWAUyvHca6eWMnzh4x1f
	F/ZqCQqjXwGPVA7PKliGrqR7RII0omk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB0C860008;
	Thu, 18 Jun 2026 16:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675591F000E9;
	Thu, 18 Jun 2026 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781800516;
	bh=lsJMMWgRXJeP7sRFHXfktToOXcpEZ/f5CxFBiOSnxko=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=G+hznsO4NdzNl3Gkceu6+dMhQAy0qH9tUu+J2fyBDdk++OZthy7TmqQJaHnAHNACU
	 dl6/15d+E2QM4JRjhWdCmN3vQN+TCIsMoF2D3r2Y0HyinMkShHFJnNgyPjAVzSy5x2
	 Y6YZzLDRHAdWOmp2WdegRGeQjHb0cTBFiLUgH8XSkvG9lae/hepKATS20sjZEn4deM
	 vLTiupNLzUYrQE4/h9r/p3CXODGSEQxW7PIWPhZh+lGTadHTcweH7ZjsvcBq9eB6oV
	 TLy1qSJQQ4seD7ktCKN42S1pEV1l9Y7dIOAIfy/nIBHtGT+G+DI7OGBYs+TnrkEloe
	 rhn83wUnqctXw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: David Matlack <dmatlack@google.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,
  kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-pci@vger.kernel.org,  Adithya Jayachandran
 <ajayachandra@nvidia.com>,  Alexander Graf <graf@amazon.com>,  Alex
 Williamson <alex@shazbot.org>,  Bjorn Helgaas <bhelgaas@google.com>,
  Chris Li <chrisl@kernel.org>,  David Rientjes <rientjes@google.com>,
  Jacob Pan <jacob.pan@linux.microsoft.com>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Jonathan Corbet <corbet@lwn.net>,  Josh Hilke
 <jrhilke@google.com>,  Leon Romanovsky <leonro@nvidia.com>,  Lukas Wunner
 <lukas@wunner.de>,  Parav Pandit <parav@nvidia.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Saeed Mahameed <saeedm@nvidia.com>,  Samiullah
 Khawaja <skhawaja@google.com>,  Shuah Khan <skhan@linuxfoundation.org>,
  Vipin Sharma <vipinsh@google.com>,  William Tu <witu@nvidia.com>,  Yi Liu
 <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the
 PCI core
In-Reply-To: <ajPzC2Xh1NMbfokP@google.com> (Pranjal Shrivastava's message of
	"Thu, 18 Jun 2026 13:30:51 +0000")
References: <20260522202410.3104264-1-dmatlack@google.com>
	<20260522202410.3104264-2-dmatlack@google.com>
	<178124130274.908199.14827357870284807134.b4-review@b4>
	<aiutNINqxhtlm2Dt@kernel.org>
	<178126123047.908199.12042730612990730743.b4-reply@b4>
	<ajB6V6yBHOjgK5ew@google.com> <ajPzC2Xh1NMbfokP@google.com>
Date: Thu, 18 Jun 2026 18:35:10 +0200
Message-ID: <2vxzv7bfolhd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 553B41C000F
X-Rspam-User: 
X-Stat-Signature: ng7fjx6y6693aiybxas45yt1kyso3wuo
X-HE-Tag: 1781800517-359949
X-HE-Meta: U2FsdGVkX18AAnUdl7kdmUJ8zUturjVLRmL7f/uhn9ByxDyNcNtD7XohMphUcrdMf5vlPiEIDbGPEYKCz437cnugDsSvMs0YvjzcrY6SPUShvAZjEl++ZtdOdwtwTI7A7PBTmRYngCse7ty9rZs2WMaLH9BLRRZKm36dnk9o5IS81aYgF7qlbNZPIRo37WlZYzQeMEhgvAu9ALy5HWmyzxU+4WEjbc/8m11IWFTvYbLXKYiCXlFZauuCcSzbweAxwYeE0lTUBIHQnE7cqkSJcPFzqtsXBjJynN0LTd4tkdWTx79Bj+cZRdK+abqJexxxVIKa5Jo/k4WYTtkK9BwvMDSfPnGBOZuC/T4tmAUiZPOmyZstfngV4KaqOk3ZzKjkjkNkZWCWDTQbQ4XBIWkqH4scskyVgmLR1Sp5qVBq4+u+MU8leES06x2H0Lmq9nrtvSeDDXkvvklI6TO7Kg8Et/4gPR4ZIiUaHP8MCEYyldB9k4EMyyZQ15Nit5ZEmcmSr2hj8NeDD8DUpDX6NvOJcUN6WZ5gOG/NgO7QNCmPR/F9nrgu87LuNNMQO81JJOLhwO6vysXTP5w5OYhjjU0fMB3B3efgZuFX5vSXqmRYDtKnZ5T676YKgVw6VDsq5i/CDq0asvvKDJSjqZZLpHisa9Sbdhoqm9nsury9qsEofas3+/JcPMEVIKnMqau+5NIh7qqvaWlI+mLNp10bDG2QcRNQHXpzebxtUXICWgOym4aM1e5zU24RxlCWXCg6HyP2VBH1+kYX7xQyFzqUT52FGx1H/M4eIOkOvEKSaMU/M/57CzX8jaELxOfRTuJFnnSm+plZJSbgNt3/c0WxUU/Mcrg+BQ7tTNFdrw6IN9sSeKYeGIesw13rwmkzUXhTqDrq0LcgHNlQ3YErhgl34SaWg1ICdELLb3vq4OtaeCSsUwkHJMxERc4wl+SQtUzeRDFLYbkrH4OES9vnN8k3hVr
 RiMnnyyA
 pujzv0p2ZcveOAFjV5mWQnkEcKbuSUWoNAPo8bIejzXXkfZVKFGd+Hp2vBXSl1WEjWS+UZxbAeFIysVhZfJgHE0jFEnyou7OU23LrKKqdh7fU2H0MaoYeKebV7aiVxr9zP0uKUJ3km0pPC+PabbzDY3DJymLmGjanadpNWse8UfcG4E0WHKY02SzjLQqP2IjhtsKs88j/EcAezNQpuQhq6Q+IkOG7udObPXluxT8DV/A64nXRvBMigr6cbDW38MHaU2vAA2D4i18qpWE2mbS9ZR0JKl/UAPyFyGpa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18 2026, Pranjal Shrivastava wrote:

> On Mon, Jun 15, 2026 at 10:19:03PM +0000, David Matlack wrote:
>> On 2026-06-12 10:47 AM, Pasha Tatashin wrote:
>> > On 2026-06-12 09:54:44+03:00, Mike Rapoport wrote:
>> > > On Fri, Jun 12, 2026 at 05:15:02AM +0000, Pasha Tatashin wrote:
>> > > 
>> > > > On Fri, 22 May 2026 20:23:59 +0000, David Matlack <dmatlack@google.com> wrote:
>> > > > 
>> > > > Please add Pratyush, Mike, and myself so we are notified directly of 
>> > > > incoming patches, the same as with other areas where the liveupdate/ 
>> > > > tree is specified.
>> > > 
>> > > Or we can add PCI liveupdate files to LIVEUPDATE entry.
>> > 
>> > That will not work, as we cannot serve as maintainers for 
>> > PCI/VFIO/IOMMU/KVM, etc. David Matlack will be the maintainer for the 
>> > PCI components, and we will accept patches once they have been approved 
>> > by him.
>> > 
>> > The simplification we could do is to create an email alias 
>> > for the live-update tree maintainers. This would allow us to use a 
>> > single entry instead of listing all three of us individually.
>> 
>> We could create a Live Update mailing list for all code that can be CCed
>> on all patches that must be merged through the Live Update tree. I would
>> also be interested in subscribing to that list.
>
> +1. I'd like if there's a specific Live Update mailing list for
> submissions & discussion about the Live Update tree.

We treat kexec@lists.infradead.org as the "live update mailing list". We
considered getting a separate one, but I reckon the traffic is low
enough on kexec@ already that we can re-use it for live update.

So perhaps we just Cc kexec@? Is there anything to be gained by creating
an alias?

-- 
Regards,
Pratyush Yadav

