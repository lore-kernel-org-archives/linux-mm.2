Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05789CA1009
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 18:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66B98E0002; Mon,  1 Sep 2025 14:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16F48E0001; Mon,  1 Sep 2025 14:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2CC68E0002; Mon,  1 Sep 2025 14:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB6D98E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:16:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FA8513B3C8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:16:48 +0000 (UTC)
X-FDA: 83841487296.14.E382E08
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5CC7D40003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:16:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756750606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f4u0puxoYv9oNFqUVogGF6L6SGUTbyV8oeprXFlfjrM=;
	b=FZQani8DIWfliKpNmaOO3hlDMDWOWrj83EY4WslK4PXoDqvOJbLBHBRKSCsh8UE5bWa73i
	bnv3HJLthGQ6CxZr69XSMSa0UpqQ4Zu+rPrS4kZixp7XgT69qnI92L/JKYgatLGNTjrqdJ
	j7UqWa1robK165kbHfEE3YByo3ZaRH0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=dev@lankhorst.se;
	dmarc=pass (policy=none) header.from=lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756750606; a=rsa-sha256;
	cv=none;
	b=8S1qdLNixGwmh0Uwgj1+Z4zzWSLU0lVFnvBNx02zSLcOJQDNVPeeRoZgYZ3ZEMPQxb/q5u
	x3OX2jUGMzorRqsf/eonRZRvs0l5mfP3qDUVEo3lkpE6F50zdUr/OIkRZwhYdQQLQf2YZl
	huLCKWCQoPuaJKxTl1cAiiAQBmTjs5c=
Message-ID: <9c296c72-768e-4893-a099-a2882027f2b9@lankhorst.se>
Date: Mon, 1 Sep 2025 20:16:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
To: David Hildenbrand <david@redhat.com>,
 Lucas De Marchi <lucas.demarchi@intel.com>,
 =?UTF-8?Q?=27Thomas_Hellstr=C3=B6m=27?= <thomas.hellstrom@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>,
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?=27Michal_Koutn=C3=BD=27?=
 <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250819114932.597600-5-dev@lankhorst.se>
 <dc21e54c-d7ae-4d7e-9acb-6a3fa573b20f@redhat.com>
Content-Language: en-US
From: Maarten Lankhorst <dev@lankhorst.se>
In-Reply-To: <dc21e54c-d7ae-4d7e-9acb-6a3fa573b20f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5CC7D40003
X-Stat-Signature: ktpi8gzqfrcwpku3qdqoo56uu4gnt9jd
X-Rspam-User: 
X-HE-Tag: 1756750606-727570
X-HE-Meta: U2FsdGVkX19r6CGPu79RfA3nQ/tcshxLVLu7tf7L4+oks+tpdgZOkiiU/OWCatPQ/BIOQiqlktZO2LjeH1ZP9d9mLagJLWAnW6pya4l/qpYw6MG0nEXhlF5zs3bM4kh/xhisp8P64PK4WpQ4/FPho78m87RCwzgEOE8tVrfHBVoDIu93w77aXcBw3Isa5tQ4XLoFjrR9u+X3tVs9AgbTHHprqxKSUNmH5Ok2NKRUJVShaEPiCUoCEQem+mluuGLbk4JXG/COzi2ubMxp6+zcIMslYFzyHsLIhN97INOFWOPXNyqhgfwY0yDiUz4BXD1BnMIrle8c9aG9aKuOKRXJXZiMalDHageTscega6objsFLFiZ64JX6hx01vWaqMWvzeUk/G4WjqNY5D8evMe/WMZfPuIp9MkTvWDN9bAXI/RDI8sIhaZq1XE5I716VbvFjfeEZTWu9WSp4Tsl5E588lX4T5+QjAOfSBXEoq4l/LbjstXs9cKQueSOQG/Pi/cBNbiwhUHPvVGPkGZ7STrgXJJZ8BkUvplpb4UcyN036zwyGTvmZ4XI13jbUpBKOXZbwKEijQQ7M1TKA8cZWRKRV/Q96KellvvoNFVX7wPOBrSPbo6QPwUoQZ0+boXaXDYop+gzVJSezz62WZcWJKn9d5w9VclhU/gppcN4phz7t6K8bGYvDZEQXSNN6QjcQNdMiz9ZicM7cq4VFnG6V+vy/eg/sf8ISuvz4fAGG+KmqJSDWduHgai+JICyoImlJFSrxSlGLQK76qNvY1wx0l4OIw7CJ0HiO+ao8I3BgZGFvxnFwKADcWHgLZCqC07jn/CrRuSQkVDNs/gcWgCeVGXfAwMfO4VTOJtavuvvrn6JTT/QkEoDN9/OuKAmOp7YIhZ3tozzQHvgH9kud/NqqYwrKWGcRXdc4/NbiplWvFAXGHw0/sZbZhZ+xQ3sstbo8R/ihVUGQM6BE7p8uHc9/cru
 TDgOlmjr
 ewveqWvnOpOHDOzqYqqrwKdAzQezj/AAXvqx8AL0ExapyMKkzRCesa7lNNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello David,

Den 2025-09-01 kl. 14:25, skrev David Hildenbrand:
> On 19.08.25 13:49, Maarten Lankhorst wrote:
>> When exporting dma-bufs to other devices, even when it is allowed to use
>> move_notify in some drivers, performance will degrade severely when
>> eviction happens.
>>
>> A perticular example where this can happen is in a multi-card setup,
>> where PCI-E peer-to-peer is used to prevent using access to system memory.
>>
>> If the buffer is evicted to system memory, not only the evicting GPU wher
>> the buffer resided is affected, but it will also stall the GPU that is
>> waiting on the buffer.
>>
>> It also makes sense for long running jobs not to be preempted by having
>> its buffers evicted, so it will make sense to have the ability to pin
>> from system memory too.
>>
>> This is dependant on patches by Dave Airlie, so it's not part of this
>> series yet. But I'm planning on extending pinning to the memory cgroup
>> controller in the future to handle this case.
>>
>> Implementation details:
>>
>> For each cgroup up until the root cgroup, the 'min' limit is checked
>> against currently effectively pinned value. If the value will go above
>> 'min', the pinning attempt is rejected.
>>
>> Pinned memory is handled slightly different and affects calculating
>> effective min/low values. Pinned memory is subtracted from both,
>> and needs to be added afterwards when calculating.
> 
> The term "pinning" is overloaded, and frequently we refer to pin_user_pages() and friends.
> 
> So I'm wondering if there is an alternative term to describe what you want to achieve.
> 
> Is it something like "unevictable" ?
It could be required to include a call pin_user_pages(), in case a process wants to pin 
from a user's address space to the gpu.

It's not done yet, but it wouldn't surprise me if we want to include it in the future.
Functionally it's similar to mlock() and related functions.

Perhaps call it mlocked instead?

Kind regards,
~Maarten Lankhorst

