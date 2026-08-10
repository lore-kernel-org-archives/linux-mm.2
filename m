Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D9EC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14536B0092; Mon, 10 Aug 2026 07:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4766B0093; Mon, 10 Aug 2026 07:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98C2A6B0095; Mon, 10 Aug 2026 07:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 657EC6B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:20:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5DE6A081F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:20:19 +0000 (UTC)
X-FDA: 85085116158.17.74AD2E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 13FB780012
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:20:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORpkNGg2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786360818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TulNsLyt4vpxh4RnOYY8l7zFcFvhf8Jk6fhq8antiP0=;
	b=aKh5GL/YeKp4PGM3gFE8dYR6KgDGiyxF7ZrSzAmDmZM2GBSanmViPCHpHoWxHDuYzsLAhX
	/qMGxbfabxUJJcSYMmBL891mqN7NEPHkg+PDJK2HHdd0jHFMBjDbYJ9g7o5WAbMnDrcCdT
	HSofifAoCzOVLqRx19QODSYoA48ypEc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ORpkNGg2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786360818;
	b=Ovp7K/95ICL8oQc+k0HT61rhK2biPqug16Z41pMaGPXvKBJG3tf7LjNBn//EWyxg+u/Jft
	Vfpqub/NG8+u5od1vtBgqi32UTO9JmUxRB8uN3ID9bamWmvfMOJ+QJrIKUQUDYBJqMsjrf
	iQAelctp2L0VquMtCC1czKb84UwBhYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C481943CFA;
	Mon, 10 Aug 2026 11:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03C31F000E9;
	Mon, 10 Aug 2026 11:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786360816;
	bh=TulNsLyt4vpxh4RnOYY8l7zFcFvhf8Jk6fhq8antiP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ORpkNGg2BSqzSD3++4ACU0dyFe22rkPiIMoU4R5mPSk3EtaJZnBfm9B7KMXy3Cpn9
	 EBzrW+XdYiOLcXC12dWCfufaWEf7uVo5F5Q6l7B+x/SQi1hrzOx4P+TYRuRH2K86BY
	 EfLvOXfLrutZagBlSPjyDUJkCKXGlFDn/fYq15/QO3Le0ZwBaPaPuveYBVCq+WTVCt
	 s/E5qciIPs+zNCp4IRtoqZMK6oa1m3Sf8hMh6hsAiXBqO/D1CFH8Tu73oGhIbOK+dX
	 wYEgqUXRoWzuwdYwzU5h1IrGCcweUrkLEbvSZcd0YLdh/1LHqiZFAtpgbOXTQGITRC
	 MZDRGV6O/Lpbw==
Message-ID: <b40d4359-3156-4d02-9662-73bfeace607c@kernel.org>
Date: Mon, 10 Aug 2026 13:20:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm: introduce hw_pte_t for PTE table storage
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-2-usama.anjum@arm.com>
 <3db8233c-3785-444e-b2eb-3e5fc5cb2f17-agordeev@linux.ibm.com>
 <eef14e97-20cd-4b08-ae22-7636af049b09@arm.com>
 <4a42c498-58ca-46f4-819f-da14cfba154f-agordeev@linux.ibm.com>
 <52b5066c-64f6-40bb-9bce-365a18f24265@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <52b5066c-64f6-40bb-9bce-365a18f24265@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: xd77xt59izcps6n9k418xhbnxc7n41u1
X-Rspamd-Queue-Id: 13FB780012
X-HE-Tag: 1786360817-906747
X-HE-Meta: U2FsdGVkX18vrgq2b7DMOtuki0463D19qHvuILDSyKhIw53P8zf13RI5jxLDrVob0H6Ci2hJFJm6StkAHOZJQOzVVSRTk4rxK9noZ1avfeogvT87TwPuLtlwgCl9yImSSy0OKBag12bhPkbuDl6gC6f78NUadcMQoJZt49F2HtBBRg5UIg3yZDHHa10FvAK+sOPmSkSrGGojIx08v6yK7jDVRbpCUn+zUbSVgC9pfFL3btgPa6yp5YoOmCw/28cfk+10WWBRAx2VIulXmjSMDecrynry65PvSlk5GH11TeK4mkyI+bjYwOCua4sqwxHoJ+oask+Q1eI6l/wPZ3NQ81wXPgkfRE00fny55HF6faNcv1nUB1NtL/GqkS/F/mKgH/toyYTMLm+iKFw4bnzHizJ9FJWXRvhF0AJyJxv6uN0BPJuXRQFBSmlcRHFMIlKGeHNLjuO3wAgVV1xHSXcCOLuAZ+HsX3rxE0IXufnjaX8WCtbyCg0GMMyAIk2pvk1uYxp8cm5ScXUFGbx0oO1nuUOUv9k6ac11n0DQvgXzEQLYxHmKbHi7/CXq6ojuKWDjaSL4P455Qn0vAaTeuAQtVy/ZaBgT3/xbcMl9zAb65uoCo2L/JF6av5teytIgUUS+uQajBt1v1PO3MqGk4FtFq8GjDxdImlPmS4Yfik0/k5Xp4MLp4KP5ZG3dsdxaBFpG1UpU4RxoDsplHGLKKEDhv4+wkRr0atslOH5h/jAkRVU+wweAW2WEFfZUiIJjXxLokRoyjOTV+lEnZH2cPPw13U8YlXgS4kIwmH3m7iB+an3i0XRLhFz1CWK3YDaaJmk2hJjm84hPDgSOGYlZPogCgFVMbUHtLcZ3GVx9mNheP3eKGCacXY3oWPB+P+M6YjIQi79F6/5j0anDWOUMbCjqdLe7cea/EAas0H2FZ3S0vQ3tWOoPW/nqMFMGmORVr4frCihbj3JE+zN+yQHGtZe
 0+b2/8AF
 MvTKlhJpEd10loZ1owh5H2OLVFGdFK+8SIapc6mLDSRfvqM5CEESXDWt+NAkKyuCtRniwnM9LnRV6yHT4lX38d9G4KexDq2fKd218s9YZwX2kZOHhlbSVrg7nzS6UlTS8ODOa6wBlJsYMC3Xbec8ZHSF2KBq79XN3utK4EBb8NF91X9cvFksKIeKPTPwJuMGBNo4ABcQSYlxNqw0O4LeJnjV5mizD2qjTixzgAX4ReCSJ4zdSJvdO+Ym5cuKfW0AX7ZWph0bp8D4yZG2DYlUE0bZP9ZYzq8ZYA8+y6ftz5ESMWG1q5Ek3Qsz5wZS73+N2F7dIR6CsxU3BbfJrfn2p4aaPpl3Az7t6ShyoPFNZ9bvnD2istKSK2Vce85Xef71UUGAI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 12:09, Muhammad Usama Anjum wrote:
> On 09/08/2026 6:45 pm, Alexander Gordeev wrote:
>> On Fri, Aug 07, 2026 at 04:24:00PM +0100, Muhammad Usama Anjum wrote:
>>> Thank you for testing it out on s390.
>>>
>>> As __hw_pte_t isn't being used yet in this series, would s390 enablement
>>> patches add __hw_pte_t to this definition?
>>
>> I hope there is a better solution. As I noted m68k, powerpc and sparc
>> may also be affected, so I would suggest to look into those as well.
>> I would prefer s390 to use the generic one rather than circumvent a
>> compile error in a custom way.
> I've just checked all of these architectures by doing dirty conversion and
> reached to same conclusion that __hw_pte_t must be defined like:
>  
> typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
> 
> I'lll add __hw_pte_t to this series. (Initially on last email I'd thought
> that the first user would add __hw_pte_t. But it seems sensible to add it
> now)

Yes, do it as part of the introduction. Also a good idea to mention in the patch
description *why* that is required.

-- 
Cheers,

David

