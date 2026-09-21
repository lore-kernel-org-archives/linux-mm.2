Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F50C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 03:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B1E6B00E1; Sun, 20 Sep 2026 23:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F26F6B00E2; Sun, 20 Sep 2026 23:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32FA36B00E3; Sun, 20 Sep 2026 23:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0D86B00E1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 23:44:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85384A053D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:44:05 +0000 (UTC)
X-FDA: 85236376050.24.54AA1A6
Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5687CA0009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:44:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q6i3Cc4v;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789962243;
	b=8d4o1+Wjy4UxzYf6GjJvE8Mvn08rHGta+CLQb4pXbyP+mqvh4Exo0mc7VxJ3fEayGDGm45
	BevH0h8DFy/kfezn8sIPiQen8Gu/NHBXccyhmkxpQgtsp3fcp1azuQDJnZ1m7H6orbhP9J
	wWpklrotjL52BYo4o+BzTZDgF01iJ2s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q6i3Cc4v;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789962243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obiZyFjcOobmTwuln0nMYhDvmRZvXT8/bzvIQjQRQIw=;
	b=fEKVFfD4NR/bA5ZU3xm37EPsS9dQpH5Yue/4Zc8wrcV9R1+8Pvwj7QRytXLFGZU3thIimX
	H28ncdsTRDMCr7C5YDaFYrvue8D1x7deGSmfOVPjr2B4TKX/4LbXAdMVeSM/O+K+weGAA+
	olIks7zvH22eG65pLNxfwihbtkb2Jko=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OGERyTp5CrbGXz3u1lwBm+Mkoof0KEPSvGD6/69fiBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789962241; v=1; x=1790567041;
 b=q6i3Cc4vPqW2HACNC1Kbcz5AWkNrBAYd+5bKQYabHMNoOlMMuY3LgSJDfb1uNhWzk0yXNWQ/
 H6nBlVUvtNQacO2ypx/6s3g+F0Qqoq+o8ycUPanwPWEII6LLiBx6wFzMsVCccjETiUbB0bUqndW
 gxfcR9gm2LW9kj92Cy41XQnA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f06bd7d5875bb714;
	Mon, 21 Sep 2026 03:44:01 +0000
X-Mizu-Trace-ID: f06bd7d5875bb714
X-Migadu-Flow: FLOW_OUT
Message-ID: <95d326cb-ebb4-492c-9062-5d373609e18b@linux.dev>
Date: Mon, 21 Sep 2026 11:43:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-2-songmuchun@bytedance.com>
 <186ee2ba-daf3-4120-a3e3-101cac1ff5a1@linux.dev>
 <4AA6C66B-0FD8-49F3-8447-959A3E438FC2@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <4AA6C66B-0FD8-49F3-8447-959A3E438FC2@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5687CA0009
X-Stat-Signature: iwqt3qq3zn96xdjay9pmdb84dx8fm1nm
X-Rspam-User: 
X-HE-Tag: 1789962243-231733
X-HE-Meta: U2FsdGVkX18RiJDHJ4jTCz2uFYPLMNsRiwMDSLl+9/Wjm+ucTOsAhTYIj5ggwuWGm4vdJd1sGRjicx11h6M6O0nR4HtfPRrOeTPlX/yWbfUEKTwXMRzn721dOlGY3t+wz2wKlU+GReWfXLODXH18RF2OS9mV0/BYr3cz4zJioS9/Y9Fy0Tjf09MDWvcqtFGUqC6aoVEq+H22RY4iEKklxHussDKvOUi3pER041mpOwA3LcoXyfahV2cTp4t+2LErJNxVp9ZIrZOLlD0J21R0el281h6rgTun0BySh+5HuBz8q/vPA5OnosUZhwXdOeey+ezaG0ppgHm5lpS4Z/MtI3Ltt8yPP65R2ao074OXHbw8SRXFEYeSw3dn2M9kEsGkgJX+MvYVlY1jD8/oUlQxk/h4M92OXVsvl1I1tzuKIQcUTTIe7kG1gdb4+xXCrIS8lRu9s2cPSdAcUPrju1d4AGeyr+cGqAqcoPnmduiRAR2i1tPyH/M9pKHd+frJ/hxUKYNZXO7jF/ybzR1PHxJOCaxvED4OCVy2thNWBLD0l95XSxWZ/bulgDxqAnwoAdY3Yi/t49gFRe2/rUvyB8PKN8muWz+D2SQSoAcW5sptey2n01IPKBWlTFi8GVkvjVIwn/TlKtnD5pz5v8BuQO8+uNp2Sc/pX8ssxfyIKAyX6VLbDIY4CH6yZ2TOxW3TtuRYd52/zss1WYj9BISD2QZOxcFL3K2NLxKLfWyTh7hyalI1GUV7tEiRfFlXqycYA716Vw8bJvMfqAozKi/LZrFAcfTHknk2M+D6uwdNmM4U/XmjRMyiigpNxlGXP7LVGZCfyFX1OKCE2t3u1Dek5AthYWohr0LC9Lk7JxRvc/AJVJFfOWySgOOY165EW60v7poy818zSynAKteKqB+TPuWVVcATsDQ7xYl6/WTW2qzeD4bAfsW/iO4km94qvXvmNc0AYd4JoCqzhROEYjzkFt3
 LFWCrXje
 aR5MU2BbAiXo4h2YOkJKwkjpfBxlnlJ/LTbBa6qnG0IOi0EGlTCbOQbZux2mKp52KypzX8o3R1pOrXXgYZvGQ1c3e3Lf4YPOzrEKetsvkE28LoW8TuaoHLEktqfSySmgNNpE34BFac24yWmKLERNTZApizcFCklFdSgdqZaYpT9Hw8b9qtuD4iTCGhNwkzeegLGIXfO1WcTZADkjevGqnjxdEGvPAVgkYUt+T+8eumZGwo4gBBDJqYzxIE6oqseIVidmZSBRX20Rv8csr0coEkWZHSnP55w+5d46pkmumJXHSEW71NMSCTwJUMRwlQeSystD+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/19/26 10:07 PM, Muchun Song wrote:
> 
> 
>> On Sep 19, 2026, at 22:01, Qi Zheng <qi.zheng@linux.dev> wrote:
>> On 9/13/26 4:37 PM, Muchun Song wrote:
>>> VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population in two
>>> places: it keeps allocations on the normal path and takes a reference when
>>> a backing page is supplied for reuse.
>>> After Device DAX switched to the common per-zone shared tail page, both
>>> conditions can be determined locally. DAX supplies ptpfn for every shared
>>> tail mapping and requests an allocation only for compound head mappings,
>>> whose PFNs are not optimizable. Therefore, vmemmap_optimizable_pfn() alone
>>> selects the correct allocation path.
>>> When ptpfn is supplied, the caller is reusing an existing backing page.
>>> Once the slab allocator is available, take a reference for each reused
>>
>> Does the availability of slab mean the buddy allocator is already being
>> used? Could there be a window where the buddy allocator is functional
>> but slab hasn't become available yet?
> 
> Yes, because the slab allocator is based on buddy allocator. But I want to know
> what's your concern here?

The goal here is to check if the buddy allocator is ready, but the code
actually checks for slab.

I'm concerned there could be a gap between these two:

buddy is ready <-- gap --> slab is ready

Thanks,
Qi



