Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE17C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70ECB6B0092; Fri, 11 Sep 2026 09:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9F36B0096; Fri, 11 Sep 2026 09:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4976B0098; Fri, 11 Sep 2026 09:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 311586B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:06:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5D45120221
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:06:51 +0000 (UTC)
X-FDA: 85201506222.24.DD1E302
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf18.hostedemail.com (Postfix) with ESMTP id DAA091C0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:06:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MRadHebc;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789132009;
	b=1MfKd/KjUfIeEyzDLPaRz29HcH9L9SXnobG1A+q6n920mFSPMKUZ5heArF0NJ6JDznoZY4
	l7Oi2OxY0+67BHuvEGY+nnTuMc3xpxS5mQOXXxm9g4ZpkKq9blAByorSf0ezs+vPTOZuvV
	po9JGAOlGVkoAVMCeYYBic6+xWIWi3Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MRadHebc;
	spf=pass (imf18.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789132009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sE/EWEXMj/AciV9drbeofrqbIo18iluIPSChM0TdvS4=;
	b=I67J8o/cUvKOT8Caz6NeSWoq75/fdofWyJBdPpmZEE7DtxSpY5gCVaUhW1jeFxkuZfs9OF
	eYMsUpeqkrFOjgWnni9o66Dw5h5GcBMOyLEQ/4hTkPmNObeNsqTVm5IwPeQMfwrbXIKHEn
	kydCO2eN5VGCfYgmq2ch/VeaJYxbpKA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bMQKUDCnWYRVzV2bP3s9Nv8XrLCTHDAUkzNZebbjfT8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789132000; v=1; x=1789736800;
 b=MRadHebcmh3cs6A29n2tnkWSPAMX36pHRZE+eKWGFqLn5+S85uSpf3Sm7W2pWd1pgyiYWjYj
 6IbWu+dq+NllnP70BtrDF9iP/jMZbbirNc6PZihvaD8wBJzoFPH29mxbrF+nTkvkNC5ITbjBp2k
 UTKFEN+iNzg8vVehykncC0gU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 9a318d970a08cc45;
	Fri, 11 Sep 2026 13:06:40 +0000
X-Mizu-Trace-ID: 9a318d970a08cc45
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 21:06:29 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqP81aqNbwAbs2P0@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLZ5TVDAqEbIeMN@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqLZ5TVDAqEbIeMN@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DAA091C0008
X-Stat-Signature: 1kgd4k8ffbfwozpmqzs1ygw73b87z1s3
X-HE-Tag: 1789132006-82457
X-HE-Meta: U2FsdGVkX1+V6z8msl/aGgZ1ogykDH4LzI3ZzS123XLv6vVnZ4dykIPS6uIqLWNSmnk5R/KItLJ/VY3DoytGprHjyJfX1D6jqQUAJYa+nGe5H77BJUrBUOEOP3hU1fp790vCZ4qD9HVIPxCyDYzq4j6FYEomTliylGa2q5QqcL3yh2AqP8/jUuNJYoQV4ARcjzCZy6zPVFmUFFPSqzYT6NQVWbmqCmFY3usMw2rH3w9YuaO/ygZlYm1MTnaHNFyB186QeO08hOxWf1Tt2ne65tS5WYx4TX5KaKt6wMbKekw6yHlw43RO8EOiNuAhvAPQOQ7p5V3rimL27Xbc6LtggttFlnBbzWX3P03INV9CKtvUXy7uTIqCn4tuQcifn2AxOary+9zinCNl6eTStIiXRCsfpsVcGMtItnl8PjwxMZNeIFhEecK0SHH9Mfyod5/TYeGysKlSwwXBeRXnM4nqcDhZCCnva9X+OGcalQDEFJlCvU3COoMIXuNNHil4spLmAbjoqM1j7zZrQsOBp3KnkYI16gFcBd7QfwDDgtWFdNYEFdM7hyqRnIcmy1iZjsGjFQBvpmfzpiFJ8D4qpYU0TfGit1/q87lXtKqeI7b+b8OlZX0isIH+oneppeHWSnZ+rEy9pWDdf9AFK+mnt8qKWobpqjH/wK4kqiR/1CwlxUfa7LXwT6giSLfgO2iNi/khBtoi+3E4g5S/vCzrX1gXs1TyYmV54fbWAfRtvdXeQWTzd6PL0i0SqQXZHdFVjY6tcWhXRg/aI9q93TssCYbCZci/ftdPsEKqgJf1tBEaJGZiSXT7rN/1mpca8uSxmgWm5m9LMON5fz+WRiEopzp6P6d7qL3FO+4j6LlEwkbcw1sWgWR4JpidTOhLCcxjLeZG4Ai/v9vjgijdedI1c+IqbQDR6wGiI4qmgFkZH651lgwPypsdkfjBM+AQHkNJN9VbqnJbXEikAqMxgPO209Y
 Ph05frLz
 io7LIx08o7z4h6hqSr9d79G8ZFcMHij0UtMKZiUmpSL7RZAQdX7YZag2Vo1eb5MnaiomCIZyBuamLwzQDlLsdjMc/msVF92R4TDuFCYEkwMiYHrqsscEFdJWzvWXv3SR/ZbG5CRNP0gjJ+IKbut9qBxCKZepr+H+srKMxt4Oy5FmHKGYYYutN+DgPzkQpA4p4kl9Xc+lyfKwaHJxXENb7JAHKnp0ndW0xAIUae3KYCQfTwFqOB5k6GGG4htkBpJJl2I6aZqCPiOI1sjmrwAkebq0itSum5PAUbRvWT2lU3XlveCDGh2TgyGzLF4VjmJyC7o636BO0ZfcpGlybL5dVZ0F/HTDKlLnixyIXArGLsqHi+3GmKhCiJUX3eeUSKPurT5T0In2+f0kltmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/10/26 at 09:39am, Shakeel Butt wrote:
> On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > Hi Nhat,
> > 
> > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > .....snip...
> 
> [...]
> 
> > With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> > rest of swap already uses:
> > 
> >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > 
> > no branch, no RCU discipline, no tear-down state machine, and no NULL
> > return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> > cluster layer stay as simple as it already is, which is precisely the
> > part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> > on.
> > 
> > I'm not going to claim xswap wins on throughput. I measured it:
> > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> > within ~2-3% of each other, effectively identical. 
> 
> So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
> we are discussing implementation details before deciding the design and
> architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
> need for dynamic growth. Why we want dynamic growth upfront or can it be added
> later? Once we decide that then it will be very easy to pick an implementation
> that would take us there.

Hi Shakeel,

Thank you for joining the discussion and for taking the time to comment.

Agreed on requirement first - but this one was already decided, and not by me. In
the July ghost swapfile thread Nhat rejected exactly the shape of "grow only, can
be added later":

    "Except for my virtual swap design, which does support dynamic growth AND
     shrinking of capacity on demand ;) If it cannot grow (and furthermore, if it
     requires userspace operation to trigger swapfile growth), why do we need this
     at all? Might as well create a new swapfile with swapon?"

To me what it converged on was "dynamic growth and shrink, no writeback yet".
So automatic growth *and* shrink is the requirement, and the simpler alternative
was already on the table.

And I keep mentioning it in the cover-letter of each version of my posting. I
only did the foundtation via lazy vmalloc. And Nhat will do the core
part including writabck, rmap lookup, memcg accounting, zero page fill,
etc.

What is still genuinely open, and I would like us to settle, is how large the
device's address space should be, because the metadata scales with it:

    address space = machine memory (128G)  ->  65536 clusters  ->  ~4MB table
    address space = worst case, like (8PB)->  ~4M clusters    ->  ~256MB table

Once that is fixed, choosing the lazy representation is a normal implementation
question - and it is the same question Johannes is asking from the other side.

As you can see, xswap make swap_cluster_info[] kept as is. Accessing it
is simple and easy, and the xswap code is not intrusive into normal swap
code, and won't add complexity to normal swap. Even though Nhat doesn't
admit it, saying if writeback is done on top of xswap, the code is messy
too. In fact, it's not. I have done a draft writeback part, I will post
for checking, there won't be a lot of struct swap_cluster_info_dynamic , 
swap_is_vswap() flying around.

Thanks
Baoquan

