Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03ECC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 13:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5D46B0088; Fri, 31 Jul 2026 09:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867336B008A; Fri, 31 Jul 2026 09:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E106B0093; Fri, 31 Jul 2026 09:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 598F86B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:28:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5ED121C09D9
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:28:17 +0000 (UTC)
X-FDA: 85049150634.26.C12A7EE
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9522D40009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:28:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785504495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KuuAkSor1Q1r3ueGHHnlqm/zCLQKZ0M2CuaEJKRudoY=;
	b=njE41OGGNwIZOaq9OUzNH6Weq548B4c9Gk4D1PEsKx3GHfCGUX4xgkKppbin4HQ1Khp/Kd
	znBmmEoU3EyUdiPwLYmu8S4kZPwJk3jTSWZDo4xh8KfmjZBWg3BZpcLDm+b8dWNVGgoWZI
	pnhbFq+SEecm3Nf1qfkbdTArPHXU/6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785504495;
	b=yxmbgVrS6uidMvLZKWcJvQ5Xk6JpK58evSoaCm8iBt4L6j9eFDnFRoGgS5Ogdi19cqT6OM
	qUqfwuCjx1oVp4oXi5ji3YX13rLC50gYc3NGKUsfImkblkeI6Vo/ffT1801ORXL0rMg1YJ
	21hoYJ79edmbnh49X7JviAxRrIpMlqY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	none
Received: from omf12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF5564042A;
	Fri, 31 Jul 2026 13:28:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id E384117;
	Fri, 31 Jul 2026 13:27:45 +0000 (UTC)
Date: Fri, 31 Jul 2026 09:28:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, =?UTF-8?B?SsO8cmdlbiBH?=
 =?UTF-8?B?cm/Dnw==?= <jgross@suse.com>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>,
 Stefano Stabellini <sstabellini@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrey Ryabinin
 <ryabinin.a.a@gmail.com>, David Hildenbrand <david@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>, Kairui
 Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>, Masami
 Hiramatsu <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya
 Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, SJ
 Park <sj@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan
 Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou
 <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter
 <cl@gentwo.org>, Mike Rapoport <rppt@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, ziy@nvidia.com, pfalcato@suse.de,
 agordeev@linux.ibm.com, ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH RFC 01/11] mm: introduce hw_pte_t for PTE table storage
Message-ID: <20260731092825.36992dc9@gandalf.local.home>
In-Reply-To: <9ac33752-b587-4901-b5f2-473e573d7ede@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
	<20260727164715.2866609-2-usama.anjum@arm.com>
	<6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>
	<9ac33752-b587-4901-b5f2-473e573d7ede@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX188VTzKisaRifdK5JzAhtUj+tNTYkibFXo=
X-HE-Meta: U2FsdGVkX1+okbaURBZ2Qkn+l9IgiK40Gqe8ZThpseNdxUoxO6+yJtshZ3puroffdGsnNQX9lyVqqMfMDNqtsaiMVrZRSqd7CxcOf+tlTFcxBWBx10qhJ57MkLj8ndzBOYoA/OODEfAwWEkK0Ynym/vN8RHly0+jRGqqJSDy6cHg7VOGub/UmsJX6TfoBSOwr0+39CvO+c3eZRPTPuO9wuZjY0AitKZFKa26poYwhlLhVPb0FYC1FMbtcEIPwcv0BUAY4FqESIdzLvKNozpw1fVotcfhrX1NJojLWeahTii05xgjJv7utljWLfUJzJrqYVN7s4pCcDgRjK7TriyixEP+/JmhkJIq3qIe3n8mNyiV8HHld6EP1z7IlvkGJKR3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9522D40009
X-Stat-Signature: bk4wphtnyr8oskxq6ok6poi7ogrp6zg4
X-HE-Tag-Orig: 1785504465-704596
X-Rspam-User: 
X-HE-Tag: 1785504495-738723
X-HE-Meta: U2FsdGVkX1/AZx791GgMtf4R0pVj04vXn+ZDSzP5pH0HubICqiCFI+zlYIc5iPRpS26AuW0j098H/Wad5hINAdojP+WBV2Vz7TmHphq1FcNwRt0P2aTxe9rq0Hsw/YgjC19jk+rIp9Csx4VId0FQtXkeRRuYdxq+cAX79js4+/N8NO9ipFQ1kRe97embPjt51/egjt9iSgTJ9KD9n9qHxXY2VD9i1xcPHoy7L7cCu92tmrhVWqx/CLIOrtgeZHzr3shcpHCDVezh4IGz8VKEm8L+CVvkGXTqf+b9KGliXWHIqE+tizXk7wvvZYMSS5HQINMZbfBp0jIW0DzLVxOp5pssmy5m3T0RjV+IR2c5uXWatPqosEhk9bwV6LdiHU05ux1OdYC1kQEcNFgFb4zZrehm66qzuH66tEIFXtqMLgQRi6letsJ3gZ/1SFITuYBMc9SrlcRn5Y5H3tQwo/B9XQELcbBHteSBzG+NFYnVZQyqF1bqEGhlxC2s8q1xroV68U06FjYudilSyNA6jl+8qVp3SMFuQB0kvsZ1ztTcCrgKGNXi59nrY+Wuw13pYe1QO/jWTRc6bt8u89aCsyea1i1APwgcGsq/mwn70mGfkTS8LeumcR/7woFohRkyARm/3NUzxP5+H4M4oSCdHtKY1FiBJF8GpQmg8omJgttcrujD2bWZ2eJj9WUm/APJ396q+/FNSuN1FXA3z42+d2xyq4fMPkJ/rb7wZ0oKzYr6mVPUh96mpGWgIaGLWAB91XI7im/4J7npJOX1k92S8ZWJNh4pL0rqAegymvEdQtYBHYCTZBft1+u4NKLjidfTAHp4D5MTcJ5hSwKgBncPAB9K7sv48dnWroyR9pRoiQ0NOFiGYdOFxWUIjg/FzVdxawm+pb+oEhcAQMWaUReiejTMqrO7tybX4YsgitQwEc0hTpvJCsYfTS4WOseQiAc/T+6WrXk0LtjJPmD5D2tDHSQ
 6REA875c
 /H03DVYgOjb6MJeyfMDb5QdCzBX+/Am5Xeyq8L7u22FXC0NBgFFdqfA6EhSGw+ekq+R/VU75snHN7KZzqBZZihDUzSPQt80DHrSXvIH6QLOJmlwchRTMI8jU4zzc1myLFJgWHUeXxtzqwqeljqX0snE6C+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 11:19:32 +0100
Muhammad Usama Anjum <usama.anjum@arm.com> wrote:

> On 31/07/2026 6:49 am, Anshuman Khandual wrote:
> > On Mon, Jul 27, 2026 at 05:46:52PM +0100, Muhammad Usama Anjum wrote:  
> >> pte_t is used both for logical PTE values and for entries stored in a PTE
> >> table, so pte_t * does not distinguish a pointer to a copied value from a
> >> pointer to table storage.  
> > 
> > Should we rather call them as "Linux PTE" and "HW PTE" instead ?
> > 
> > Some like "Logical PTE" does not really sound very clear on what it represents.  
> Yeah, I should make distinction more visible in the cover letter.

Just as an outside observer, so take this with a grain of salt and feel
free to totally ignore it, the term "Logical" and "Physical" to me would be
that the Logical one is created by software and is not mapped to hardware,
whereas the "Physical" one would be backed by hardware.

Just using the terminology from LVM where there are Logical volumes and
Physical volumes.

But if that doesn't represent what you are trying to accomplish here, then
it is indeed not the appropriate terminology.

Again, feel free to ignore this comment, but I just wanted to give an
outside perspective of the terminology that I see.

Cheers,

-- Steve

