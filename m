Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A47D2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 21:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3BFF6B0005; Tue, 27 Jan 2026 16:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE98F6B0089; Tue, 27 Jan 2026 16:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBB36B008A; Tue, 27 Jan 2026 16:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A66A6B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:31:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A7DE8B55E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:31:46 +0000 (UTC)
X-FDA: 84379041012.19.DCBC177
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 55612C0011
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:31:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fMX008b9;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769549504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eD5KTG0VypaDqxSh9u6PSFSdFFm6U5UXX8R3Kfi0UuY=;
	b=naf/cthxdaxJ7cphQ1a40GhXDgy8ZoCmnjNmMnWHJ7+gNWVH+9lBH1zHZjBMOxmLmg48Hz
	Lhmj8Ix/x946p5PGc8kZo6RUk9FTqctrNcpLqIS00BZ1kkWF676WRm+0PTvG0y3uJRK6Xn
	A+t5X2IVC67mJorZ9DbMIRbMJU29g8w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fMX008b9;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769549504; a=rsa-sha256;
	cv=none;
	b=R0qMZUQuxRBBNEAThgNjDdu9xsGbrol1g4BdhDuxgx0owXT2rWfyitMJdyHXUrwvJg3reF
	la/GIXThekl5JHXzPlFLD//l8aUoJMiayojcIB8zCOEC/71OCfsks4OXwVndK7702LsrWA
	wrbOm6sun3AieS/GydDq0Q3WLvZMQb8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15F8B40DED;
	Tue, 27 Jan 2026 21:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB09C116C6;
	Tue, 27 Jan 2026 21:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769549502;
	bh=lAGlrUrQZRj2Ye7WvWgIO3rlnqhph8gyR5+gVz8PIAg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fMX008b9lw+lbMqmbQE4akntt0GM/CYCqEfsQlRN5xZOuTFbgIuiPOZ7SpC5nWCII
	 4e6HQxyvFYex00qHzi1FBCgLioZLzus1wJM2kZ7Bxmhz80iHDXUb0USzNGgfcQHLDD
	 BuJ1VJ2BqPH7YpsXYabWuD+/1/XKE6evKQK0+X6Y=
Date: Tue, 27 Jan 2026 13:31:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, david@kernel.org, mst@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 osalvador@suse.de, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 4/5] dax/kmem: add sysfs interface for runtime
 hotplug state control
Message-Id: <20260127133141.5f7aa3cd01f4eee4055f075f@linux-foundation.org>
In-Reply-To: <20260114235022.3437787-5-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
	<20260114235022.3437787-5-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55612C0011
X-Stat-Signature: psabjb9rponib1r9auiawb4n1j8wxprc
X-Rspam-User: 
X-HE-Tag: 1769549504-81300
X-HE-Meta: U2FsdGVkX18sH2kCAgF5IHHwTAZqlN4ydcNAAQQpnNqWA/MOfu/i2PRbYfIwdqT5QWEm9QK/JzPZRXrmT+X7gpAItlIyyNbaqLXF3SdMNLAIkPkVpzKOz92HPlz2gDtFwEvk3PJg5HNTWVe6p/o9ab6UX1xzWSPb8kOx3zK5Vmjeq7zhpi/CxqfSN/v53DgQwS1SzLglfRQ3W2y9+5MWCN/7Os7LrRLyaopzkbvkgvm3xEQAfoP/Bd+5NtnbUJnqm0Y9AhZb2kWnvhxYU8/hJp2AWe189mC8sRJwY1mho/16YKzlxgWr/JxP0j4T7buHH0aIZlRSEs4ACr3XvDFP6c/QfCyZ8cqHyuaUujtsOLhd4rDZ0pw1yBtSXRYJT6n8L4kH1/6ZlhDfQBqFfeY/62CBged07xNfglpUzC+Q5JW1/D15+5AwzWNCtKjDY2100hl7GvcjYJ8/w1lht931xAg772a3tMv4obc8+wxkCha90RQoKfY0F0Tig3nPfymKfESabfo6/RzT1aeuuQ54zcdQs5O9PWKMhQcLXRr+GupMz8Jo3JmjvvAvPy42Fu1R9In4iJizzcxQ2q7b3SalqO1TtWCZkvWCpUI2v96MyoKRnPWFvA32V5PoXcj/HTKpd+AW5TM9NE0hneNRP8kCcKogXpNDbMAjqUInLaocn54sRK6AyqK/hkWLm+UEiRMM2E/gCTlfmR6HFA08XPOxcOqEp9ifTEmre6XqjRMs6O7ERLAwJa3HBIfhNX60h3NTGBAP5jvUC5P18gx75F0K473Hty1G2lDTuvA8y5HJ5jz3MQ7MiOUhP64ZMv8cBoOn7Ff1UinFKFeE62dX5Z8PTUMplUKSjvEzCJtZM8qlXMLi0b3JZhld7Iwdud7+ja4uXOyw09ddW/TSKbHbr4ooemCXlHimC1UO21kANU+PyN2INzIwla5KyEL34MlJAxd6joXEuuP+HHVUMGb7lq6
 Vc91RKMR
 MkoxxPbfHGVYF/im8RPw4yQvgZaBOD/9tasN0p2W64o4gvoqOU8RuWjSULp1z05ZMvjaIrYGT/TbSrTPcIZJhdirT39dvhpe/GTMy7YK8WW8g2XpQELFWX9dAsa/TV0pBKMziuxbjK1ZFWQZzxLNeaKIwl8Go8B28eUy8XbmZVRD3/pCkH4aR6A40vNNH1NeDhrmDRz25ULD+w3qKGZsPABSSYOXJy8J4uOYJkdTX5vBTcIjJGOZ0WHeUuM3/a8/dbqeZ18uiq30GLvq5/Gppx6iRx5cZfVu9n26OYLXAZLJRUvYBgJF2nPbQKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 18:50:20 -0500 Gregory Price <gourry@gourry.net> wrote:

> The dax kmem driver currently onlines memory automatically during
> probe using the system's default online policy but provides no way
> to control or query the entire region state at runtime.
> 
> There is no atomic to offline and remove memory blocks together.
> 
> Add a new 'hotplug' sysfs attribute that allows userspace to control
> and query the entire memory region state.
> 
> The interface supports the following states:
>   - "unplug": memory is offline and blocks are not present
>   - "online": memory is online as normal system RAM
>   - "online_movable": memory is online in ZONE_MOVABLE
> 
> Valid transitions:
>   - unplugged -> online
>   - unplugged -> online_movable
>   - online    -> unplugged
>   - online_movable -> unplugged
> 
> "offline" (memory blocks exist but are offline by default) is not
> supported because it's functionally equivalent to "unplugged" and
> entices races between offlining and unplugging.
> 
> The initial state after probe uses mhp_get_default_online_type() to
> preserve backwards compatibility - existing systems with auto-online
> policies will continue to work as before.
> 
> As with any hot-remove mechanism, the removal can fail and if rollback
> fails the system can be left in an inconsistent state.
> 
> Unbind Note:
>   We used to call remove_memory() during unbind, which would fire a
>   BUG() if any of the memory blocks were online at that time.  We lift
>   this into a WARN in the cleanup routine and don't attempt hotremove
>   if ->state is not DAX_KMEM_UNPLUGGED.
> 
>   The resources are still leaked but this prevents deadlock on unbind
>   if a memory region happens to be impossible to hotremove.
> 
> ...
>
> --- a/Documentation/ABI/testing/sysfs-bus-dax
> +++ b/Documentation/ABI/testing/sysfs-bus-dax
> @@ -151,3 +151,20 @@ Description:
>  		memmap_on_memory parameter for memory_hotplug. This is
>  		typically set on the kernel command line -
>  		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
> +
> +What:		/sys/bus/dax/devices/daxX.Y/hotplug
> +Date:		January, 2026
> +KernelVersion:	v6.21
> +Contact:	nvdimm@lists.linux.dev
> +Description:
> +		(RW) Controls what hotplug state of the memory region.

s/what// ?

Maybe "Controls hotplug state of a dax memory region".

> +		Applies to all memory blocks associated with the device.
> +		Only applies to dax_kmem devices.
> +
> +                States: [unplugged, online, online_movable]
> +                Arguments:
> +		  "unplug": memory is offline and blocks are not present
> +		  "online": memory is online as normal system RAM
> +		  "online_movable": memory is online in ZONE_MOVABLE
> +

This is perhaps a little brief?  Is there more we can tell users about
what this is and how it behaves and why they might want to use it?

