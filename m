Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED53C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A4A6B009D; Fri, 11 Sep 2026 12:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D721B6B009E; Fri, 11 Sep 2026 12:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C884F6B009F; Fri, 11 Sep 2026 12:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC646B009D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:59:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D168C1602DC
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:59:29 +0000 (UTC)
X-FDA: 85202092458.06.5051029
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01BBDA0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:59:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ou4A8YC2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789145968;
	b=r78cY4nMKyRoyY1ZpB4Pas5El3l9IpFgV5BqUB93VlVFAjufEbidrifatF8edlGWSqy/TL
	U8vdGeheXQ6gnO05xG2lcYl9UOQRqdTHq30y936fTyuevfHllctVfVaSFIs91GNAithaZa
	BeYVx9GIP5e4ncBfNbrmyFulOZLo4D0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ou4A8YC2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qM4x/VyJS4MpFkPRmtAp/dwZSEf7BNj/Y7zsnmyHsqg=;
	b=r/eSK5Ye4wy7/kVcc0qsYhqr9lkVEKlAzIrYYw/8SQxMqZBHCS/tYi0Ntx0gQ38KxTudPU
	9OjV/ClkfInlXjWbzq/rLBkGlLYpzUmtnWIEYcI5osXrr1aYwX59MhpQjjcHDCa3quzJW3
	bWkArAeV8vkBTAptvwMdpAA+YafXzqs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27F0C447B3;
	Fri, 11 Sep 2026 16:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379961F00898;
	Fri, 11 Sep 2026 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789145967;
	bh=qM4x/VyJS4MpFkPRmtAp/dwZSEf7BNj/Y7zsnmyHsqg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ou4A8YC2F6O1EQtFW1YZOr6bVr2+s+ihTPkOTXSuzLWS+Cc6eD6PIOzLJeuiKIyvQ
	 JwxsyI6YUXmX45BBAQxB8OYi/wyHeoP2FZWOx4kh82jj8klR9F/LQ8bOCWxW/Oo6Re
	 Eo8mW9QEcAaGuTtykPlAmcPJuXu5gk0wxaGfd2AVAWl/D2lawDmMhQg3iDYUwUuHYw
	 zuWtfU0zvPCWxENsoROZd8H/uu73aHGKmzvV36atSCabSMGxHjg64KkTpB12LVGbzh
	 HWFSQPEDWDvZ5Hi73zQYh3QYUlItPYuBwtcY1gGae8CFr1qGgQfyIGrRgrWzKBkGHM
	 6ZbPiVuTm6ijA==
Message-ID: <d5093fa7-d057-471d-9c50-f53e6fe267df@kernel.org>
Date: Fri, 11 Sep 2026 18:59:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] mm: distinguish PTE table storage from PTE values
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260903103002.1091859-1-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 01BBDA0005
X-Stat-Signature: xofy4qy4nughcfgjh68nwdrn6bufi73i
X-HE-Tag: 1789145967-266386
X-HE-Meta: U2FsdGVkX1+GT2CBkOvhxLuSAj46UXfa3WI1K+uBWErHNBZObO8WwmW/j0gnMETjr3IqyvY9LjsAtuZ+n/jnpqqVBDKttt50UHx9eZQcV4ZmvCWk6wWHmDZLMpuA3FlyEmxn6KyfznmArOySMGtypYMXkcwric9pmfuhyU6icNg/7ZdIBkCHKj4Og1ZE1MICILgVMU0pLKf951WojAUbLgFeyP0JOUgf5YXFGEcsSkXlk5sHatDgDbDUG0d/ZC7j1uew6GS2B4mfPWJhv3pQJ3jOxCMC0blVghNfPImq1guP8lbcELXhaOwXLaSYSzPRGU83ceiCvzdr6NaCb13zCE8X04ZI7WWqpSLBxO5gpVJb6pjllToSj9z2tSWrdYG812meWATVbld4Xr92QQCx9s/FMUeqEymYi99vg7bhc1iwdRZBiNLBhcynzLHCbSJc71hHukK9yXCP5cv7pdQTfdU/QCc5sjkywi/xSiRYppOVRgMwCILUlfjTiKvgPH0TohqYAykPBx4CA1uKnva1I7ImdqB/C5tL9dyBhXKhda046O06Zm3XruC87rVBAbrsfbUMuUjs5oDO50WcTm2IDtG92UnNDUOANYa6q55L7D7hAK9dBpgpnSwkL+sV5xjK5kWUwQ09KFuvS9WGHWdR0/bC48M9DP81cj5ooKgaZzLSokf26NXvqhFxn3Gfe/Co4Ak6nacvt0pxFaY2VO0BgcpMVWioP5M5KoUDPt4i6ihbtjwioXopwxml1Ja4fZyadDYrTBHeJ+PxE0vE7i5aMnn1T2dzp+KvL+6HirIdmMxPOufiOxBLmG+DZe5JO5oSpGBkZQLgyC+DXC+2mpXHdTim3JBXPEcX+MQZMoGkZOJHP13zhKVC/vPHv8mjNddt6h5MZQjalPjSjj0gFfuxeWdFd6+UyfIbW7Wg/EfeWQyoMelVIR7hzjF8Q0sPCeQiWrgwUyx8AVpT86uczy1
 3g3/5kVb
 xr3ajiMl2VDzDZo9VrwH4dquTUibGcRe8w5yFeiZ5SlR2aj9G+XXGCPlkr0kgf+u5RGl87REWzKSbQ0VkBKpsyOp3rKtmLQwLPcmGJvsf9c64yy3bfzWCZPPwEAvp3ZTUjV0zo8sBoJ3tnSmGyjmBw9BzMQqVnQ3eOWaC8Sx/+lVaqIwXSYZ/RDohxNNwdx8eCkv8MXljfTcRaWN6a/fvq1njshinCDoz6iJZrdzv3kV7uFJ0i/ayvOp0xzvEm9NOcG8bBDY/sGel5IkHgVni4ij4ccfTDjDW4ZGlBAFhfiPluqgUN682fiCwcdJ+pTjo/sKXUaRgijQZu8w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 12:29, Muhammad Usama Anjum wrote:
> Hi,

Btw, I was wonder whether the subject would be better as

"mm: distinguish HW PTE pointers from SW PTE value pointers"

or sth. like that.

-- 
Cheers,

David

