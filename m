Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123E9C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F053D6B0092; Thu, 27 Aug 2026 11:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDDE66B0096; Thu, 27 Aug 2026 11:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCBA16B0098; Thu, 27 Aug 2026 11:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A36DD6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:19:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19AFE1C0F43
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:19:44 +0000 (UTC)
X-FDA: 85147409088.18.841CAA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A5C32000E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:19:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3wTZdzR;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787843982;
	b=S+E94A2siUIKsuUK7UgT3Z0+ov3ZM0kNh4iiUYa66mhGrgiJKQZpYafSQg4zH5ENNk4sKc
	PfWuJpkuXS/qYNZFr0/Cts5oUUfScdnXoCux5PL+XSHRHOq62JyH6umKZvVbjYqj+VKnU9
	cgq5y1tmb162tjmRehUBcw+VyRuodYA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3wTZdzR;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787843982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kpl4B9+OKi4iovuoAuQYAu+N2lhQ/XvjeS+MGmKxktw=;
	b=Sn96goe/CgKPlZcPNXolDBIzpDQ9Ywh7HsyFs3rwFzNBXf5cJfcZJ/A2pdm36Ist4bcWsV
	QZgt1ENQ9P9y3CDlq6l3Nr2avjfwzMpjC2gvrjJ9YGXmFVW5I/SZA9YVKersDHHqQYTai5
	77peGtzagvHBKVYnYjvDnOu+mCIm7NA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3D16600D4;
	Thu, 27 Aug 2026 15:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CB21F00A3A;
	Thu, 27 Aug 2026 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787843981;
	bh=Kpl4B9+OKi4iovuoAuQYAu+N2lhQ/XvjeS+MGmKxktw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C3wTZdzRxmMWOfZFhu4sHFl2KwuIaNTWsnyVFxt8thZ4/jAWUoeQ+2/AwPiUo/oN+
	 2Jt74gZHPumiZDkrGgP9F3hzwL46/ZEv/KrwvhIjKjDNBeCMsuG358CyjEpkGHrsk0
	 u6VnDUHfefScEj8hFBE+n5NW2tvgYoQeu/e4TTWPsVavCY6LAK3ZbTbS3CazGz/4mA
	 JJ06xBycBBYNrTbiWDeW3u3OhcSDtbrYe37fcCNXg9dhdZvkpAmWhOOcNpHH9pc8bv
	 lsBOOQ+PAr8rODj0LRy3Il9DAUP4CNY4HbshIqAsT7BPur1018eC0+UO+x82JgMI3t
	 O0/DjDpPdeopw==
Message-ID: <37f6af95-950e-4457-886e-6548d4719f0d@kernel.org>
Date: Thu, 27 Aug 2026 17:19:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>,
 Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt
 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <ao16VxNvaYzlt2WG@gremlin> <ao_9R3CbjYFipFu7@kernel.org>
 <apAB9GSnHNyNoSc1@gremlin> <apAcweThjiD-iIBF@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <apAcweThjiD-iIBF@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4A5C32000E
X-Stat-Signature: rxrpa5oiipw9e9infk891rtduooewhdk
X-HE-Tag: 1787843982-859197
X-HE-Meta: U2FsdGVkX1+X9PUvzU7k3QoaI4w5C1/md7I+9BKfO7xGRs7/MhUtAJ1tOI9WTANpHpRXrj5FNsLdEs7VHmSBuuzyzniENLL5jrRm0z14p9R42OokrA1sC8IicPqLMNMFMsFHFgddXGi8jgLkNbkS3YERIv6R5QYE3EyajP9d5Oz7kN4MGhQOllIPICXNQlP7obcVqibtF7kmhuyRQ3gdubkPbkZPlsY+afVrGUwmQQT1xqVy/67aUHcO5Vn/Y/JYwgTNar1Ea3E1e9uVe57jiys1sr+g+PrbN0riinkq/SMaGHxJeWhVYY4nR46kmJ9+cBbQOCzqbcsw2b5TSME8gX19UjZl2gzRPwGluVZZddD7V9R31c68TiXR3068EURkxzVaeK5M+vHYr9F8uE0i8UtAFIIjyuUuHxCithUhDyH2Vuz1eqRDIm52JOfL1+WImTvwjGjqKbrhWKxewVZPc2knYtNF2AdMRFgDu547rQ0WlKLxe0VpKP3cl9mlCrV5Xr8x+6IWV20S7UDzChsHLabR6QxagKZ2qVje23oAf8JbAaNic9cN/1hCg9eqOnJAJqwfhaARbVL6e+zBUG9V7tZgoL8wOJvWUfMwJ+VbA45XhydJXgOFUt6AiWB2BD667mtDn5JdFgHp9uRVn4Fdmkzy0sUSeO2egnDfMc1GlLMoH3eNUM9x8N252nSnjk4mgSPjksxrQPjEAuPrZd+2HYuer7o6Le3x9qQLSPSR4qUPSblcCtHeY0M+rsc4YkB9YrAQMz8VJUhGYaRJJsLxuNNdbqTjWlXkrnIBEMaJ2ipAg2xDR1gdDSt5dNDfVCDN5FVr6Acg841vsYLT82DBPiOsXYre38YdawK6vi+EJu0oxHKGboIrHu0xlj0qYfBXU97fEbdr569F6FQ3wDegSMhb7kkC4hYI17CntRZoSZh7tvsaIyTy1myIQBH6YSr2LRgafRXkt+QjiCIg2di
 VuSoTv/2
 yB6HTyQTrsr8UtCh0rM7nKb1KgY6ckPD1JInDW/Z0sFhDtXIqRiUp/oZucondkqaupMZsX12Vtvy9yV/xBBt7VbI+wk5EYvYs7jQZiwDwfem0xC/lOM2EDduR7WMxMURnTV29rKFUS6hZ8hK8rNq/a4o2ijsZ3S0EicP8V/mIJz1djUGWFGnxMQrtlfIjCxPHhZxYrsnVCdzthmCAmoU4FvzjCqmu3bLJAdUhT7+WhYF+EZsdPzjSUFjkM15bVjXIvnGbmq387/eOA2CT7VxOjfeUopvTqL+Gq9CZv1TI6QCOCb6WmdspypfHwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 13:18, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 27, 2026 at 12:16:32PM +0100, Lorenzo Stoakes (ARM) wrote:
>> So actually you're increasing by a cacheline and increasing the VMA size by
>> 64 bytes, i.e. 1/3, which is unacceptable obviously.
>>
>> Maybe there's something that can be done with:
>>
>> 		/* forced alignments: 1 */
>>
>> Perhaps? But that looks potentially ugly.
>>
> 
> I say elsewhere (or think I do) but to highlight - I think probably we could fix
> this by putting the flags in the low bits of vm_uffd_state.ctx?

if that's possible that would be clearly preferable memory-wise.

-- 
Cheers,

David

