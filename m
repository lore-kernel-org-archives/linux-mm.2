Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B777CCF2C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 20:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF856B0088; Fri, 16 Oct 2026 16:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0C76B008A; Fri, 16 Oct 2026 16:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D5A6B008C; Fri, 16 Oct 2026 16:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8093C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:42:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01595A7E09
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:42:17 +0000 (UTC)
X-FDA: 85329661956.03.3411093
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4B3CF40002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:42:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhygUXGE;
	spf=pass (imf11.hostedemail.com: domain of jic23@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jic23@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792183336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9ItKggHrdTjoEiMSmWZ6gKU2fiPh6BVkzTuELhbA2k=;
	b=thmpL3XLGE6ELhQDhMBuFSQg6UEcdfxrUqmSbO5uw0hmHH5V91JbUU12gceEkFmwctMjEa
	zAdI0mqDpb74DxQl+QnZQRwwTlQSgFEHPG3Q7n2eWww7SC5DhmilbusRN77cczC7JTesXx
	7LrgLZivv0VyUNf/RBs20QydSfrxYRw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792183336;
	b=FsxPmqO5BJH/QoPt7VBX4hxo3hwF4vKpojDFVXG4xsklSIl3jIs3KsRSXyLxt1twRQAUd8
	o/rBZsMAQ6FQf4s6w5yQiaIIu35Oan2pfKsho9rx0cUv3juO6Ldhpn8Sct2disVMn2x7DH
	w1+lG4mXUpkp5UKpUlD8J5xZRwLDOBw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhygUXGE;
	spf=pass (imf11.hostedemail.com: domain of jic23@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jic23@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E71FE60230;
	Fri, 16 Oct 2026 20:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C1C1F000C4;
	Fri, 16 Oct 2026 20:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792183334;
	bh=b9ItKggHrdTjoEiMSmWZ6gKU2fiPh6BVkzTuELhbA2k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RhygUXGED6Rk+K4BdFKEzl2HSC8ahJGwA3Z4GIeY8VIio3eIyCs78m0pU1NDz5JwD
	 mLYiB1LesmLHU8oVr7ha6GLlaR4QPl9uJfgAal5eGbOMQXdEVEM3lIQbIrwjYPtr0W
	 7pKm/kGmrFXRA4seypLN27hUY5wRloD1L+cJzJWgyfPuKUwQfl3GK9ByxJ+aU83DOu
	 t5srCWUNEBh+NMFVz4Q/EVGWG9xOop7XpIjEVvcE7QQuB4gkzhQv+cFMcUCoxpM6pT
	 lANl1U//TGjv8C8Mcjpv8NoK428tT7d2mHvP762ve1ONp0gAnuTyfBzsn5m46bj7Ni
	 len/bpDRahSuA==
Date: Fri, 16 Oct 2026 21:42:06 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>, Miaohe Lin
 <linmiaohe@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Breno Leitao <leitao@debian.org>, Ira
 Weiny <iweiny@kernel.org>, Li Ming <ming.li@zohomail.com>, Richard Cheng
 <icheng@nvidia.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Hildenbrand
 <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Kiryl Shutsemau
 <kas@kernel.org>, Harry Yoo <harry@kernel.org>
Subject: Re: [RFC PATCH 0/5] cxl, mm: Keep device-reported poison out of the
 page allocator
Message-ID: <20261016214206.1dc8484a@jic23-hlaptop>
In-Reply-To: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B3CF40002
X-Rspamd-Server: rspam08
X-Stat-Signature: m4ysbdzqofrhbbxowzuc6ykj6j6y91jt
X-HE-Tag: 1792183336-667318
X-HE-Meta: U2FsdGVkX1+XHL8TFKSeQ8Sx9WMJW+WpST6ECyE70sxnmj8tvDtCjxwAgZbjs5fs/t8aStVcHcJjQVmc84PwY8ML1tvHA+qKU9uEW+UZsi5vJBv+ArxePld6wXixi00xCjkb+YpSrqbNAtqzVaG4fn9sup7AiXo3ej5emecbGgBJEsPMv0PZBoNJp7MH5WHlJmczhmawgHXIOpPqVKiO5NEV4cAEoYnxEzkpSZ4qgMqAyRa3soTuYzbnCmTOeIdDhnLYTOXe5vG8WTmigJ+SDUeFqMkcn9U6cP0xUhMFgD5nYFk7XRc6pC3pf/TiHenakj5iE52HjLf0nmo4jn+wSyGGpPEcJnrHQl33dxneFcMVeMiAeSnaf9ZV5peX9RaXIqbB7JQ9VPOrJ/zDE1zUAzdFhdi9bCpCI3AN9DK3MGY4/yCOeKRu1a3wacV8FkYLnKJzm2yuCozsPEMOlq4APsiNDZtbzDYXazzTM7xWGTivAERbhSuUQqO1kxt1i5KmPuQotrQPWduJv2saw+chOAaPddGMLHRrK6ug5x+gdzT6HyjMMDb6kXI9q5Eaij8irWweBBeEoiG0bRzMsooMSyIki2MvvJsI+ZZ/ZLMyCdNIQwSaZX1HHKGPw3R6r3HmEPgLRc5vQtF18Yg819mSLzlEq3NKiA21nbr35n1dGC07IjlGpSEr8pgaR1HtysHhB92fwp1+gwyh9ACJbS9mn/svXKasHiFVYCu9pIuX/4vAsug1msFXZ/dRkceAmefmIwg9OugwdARXhcaNdGn2iCzWI3j/EwIVphdqf/RBAnLhMQALGWoQ8q5ttCo1QvzHqsUeIxm7iiMtOHflIfh91NdSlrcFdN4W+b7dDuQqzwUNLpy3UiBXrqxcUQ4zTxvNGuRuNNc9O+TzuFqpgkgfXAtxvJ9ZZgosGknRh9VYIh97AWL2WVcZw42eVJw9ale5XkNvk5Ip6jBrt9MAVlh
 CmpZgl4b
 LeEmaHYkS6giicoNXn6wMS+OTX5jamqOEXxSKguEiPOdBvVV0yVut/ZlOfEpXH+s7JTUjpjAG3Lw7V8dsKyaQk0Hxhv9r4ggHiGcWrEXrbpy8eMV8j9ddhngKzA6HKhbvsfSbY6nI1tEautlrjVWzeh3D2/S+3o6TkngJWGO4TugVPXqtjidtsnSxxHhOvBD7/8966xEMqO20K0lT+/NV47ucGAoKigzOkSQ2ThX/6HtvXXaygb0iCVVmzj9UhtTlsMFhVehfYqkbZVzbR88ysRU7oRrvgfgigIClhdozxIIBxovhqhPKkZeV1IyCJTq1bTel
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 21:50:08 +0530
Shaikh Kamaluddin <shaikhkamal2012@gmail.com> wrote:

> A CXL memory device keeps its own poison list: the DPAs it knows to be
> bad. The list lives on the device, so it survives a host reboot, a power
> cycle, and moving the device to another host.

That is a bit too general + needs backing with specific spec references.
I'm not sure for instance if there are any guarantees around poison
lists for volatile as some errors detected by local ECC will be intermittent
anyway.

I may have forgotten it but I don't recall the CXL spec talking at all
about any long term tracking of errors in volatile memory across power
cycles.  There are interfaces to test memory to detect stuck bits but
I don't think there is any requirement to run them at device boot (and
we haven't enabled them in linux yet as on demand things).


> 
> Linux reads that list only when user space writes trigger_poison_list.
> Nothing reads it when a region is assembled, so with a device that
> already has poison:
> 
>   1. the RAM region is assembled and dax/kmem onlines it;
>   2. every frame enters the buddy allocator, including the ones the
>      device would have named had anyone asked;
>   3. a task is handed one and reads it: machine check, memory_failure(),
>      SIGBUS.
> 
> This series reads the poison list at region probe, before the range is
> onlined, and keeps the frames it covers out of the allocator. Nothing is
> unmapped or signalled, and no runtime path changes: the frames never
> enter the allocator, so this is not forwarding latent poison to
> memory_failure().
> 
> Dependency
> ==========
> 
> This is built on Breno Leitao's hwpoison series [1], which keeps frames
> poisoned before a kexec out of the next kernel's allocator. The approach
> here, withholding frames as they are onlined rather than taking them
> back out later, follows [1]. [1] hooks __free_pages_core(), splits a
> block around its bad frames, and marks them with hwpoison_boot_page().
> Patch 4 adds a second source to that hook.
> 
> The two cover different cases. [1] records frames in a bitmap spanning
> the RAM the EFI memory map describes. Memory hot-added after boot sits
> outside it, and CXL region memory is hot-added after boot. [1] also
> carries its record across kexec only, while the device's list survives
> reboot and migration.

The CXL region - may be hot added after boot.  Whilst I like that model,
on many existing systems the CXL subsystem is just identifying what
was already there.

> 
> Applies on next-20260908 plus [1] v5. The num_poisoned_pages_inc()
> change agreed for v6 [2] does not touch these patches. Patches 1, 2 and
> 5 touch only drivers/cxl; patches 3 and 4 touch mm.
> 
> Design
> ======
> 
> Which records are withheld. A corrected error never reaches the poison
> list, so every record is uncorrectable. Only records with source
> Internal, a failure of the device's own media, are withheld. External
> poison was written by the host into healthy media and a rewrite recovers
> it; Injected poison comes from the Inject Poison test command. Withholding
> either would make a recoverable state permanent.

At best a detection of an ECC error in local media is a hint that it
might not be cleared by a suitable full cache line write.

> 
> No host-side storage. The device is the source of truth and is re-read
> on every probe. When a location is repaired (sPPR, sparing, hPPR) the

It might well be repaired just fine by a host write assuming the CPU
arch supports clearing poison that way. Ideally we'd poke it some to 
find out whether it is recoverable.

> device drops it from the list, and the next probe onlines the frame
> again. A record persisted by the host could not learn about the repair.
> 
> Volatile ranges. CXL r3.2 8.2.9.8.4.1:
> 
>   If the device does not support poison list for volatile ranges and any
>   location in the requested list maps to volatile, the device shall
>   return Invalid Physical Address.
> 
> A device that returns it, or that has no Get Poison List at all, is
> onlined as today with nothing withheld. This is also the reason for the
> RAM -EFAULT tolerance poison_by_decoder() has carried, without a comment,
> since f0832a586396 ("cxl/region: Provide region info to the cxl_poison
> trace event").
> 
> Incomplete lists. If the device reports overflow, the host stops at
> max_errors with more records pending, or a media scan is in progress,
> region probe fails rather than onlining on a partial list.

This bit needs shout more about as you just stopped region probe
on regions that previously probed (but would potentially return poison
on some memory).  I'd put a Note: Will stop regions probing if poison list
has overflowed. right at the top of this cover letter. 

I'm not necessarily against this. I need to think a bit more on the impacts.

Certainly an interesting patch set.

> prerequisite-patch-id: a23fe88ab4529b6a6669a991e15cf1631311391c
> prerequisite-patch-id: 111c69880ed0e148cdda285896c006e8d1fc98a8


