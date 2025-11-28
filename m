Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 294FED116F5
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 08:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7550C6B0088; Fri, 28 Nov 2025 03:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE706B0089; Fri, 28 Nov 2025 03:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6696B008A; Fri, 28 Nov 2025 03:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46A176B0088
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:39:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10547131807
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:39:23 +0000 (UTC)
X-FDA: 84159366606.09.9774A33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3BC39A000E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:39:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UUD92oud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764319161; a=rsa-sha256;
	cv=none;
	b=e1brZFlXKePTDzwuXtvujgy5jb0jK2CD+EgduQZZcT4DeHPXrT5BQ4R4TSjLLMv6fX6mXb
	AFSc52NHjDPZ+WodrP8PTJv3rU0uzMNy6A9UJJyrCYLfFzUB4KW0QmzAJX/ySIs83WVrj+
	smB+ZwaDcaaZEf+rjnZyUFaWeZl+mfc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UUD92oud;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764319161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ty56mJ8iWbd5vaJQZjPD6LXVpPBy9Lri6H9srl+fL6M=;
	b=nytsXE6z0A/+D7XW0dRV7S+JbCnlkAvpz0bGCfktgSOUXe1phqem/y6SLYO2x5d/OJ6rYh
	yZm1xcASuZAIfYPQOxoebLjOt9r9XJnHGGLMI/z50RMsqgf9n/VJLsyGXDDoNXrTPfYDQr
	XSDoL/FHG2wogrH2Q3fy+CsaQk7ZseQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E181241920;
	Fri, 28 Nov 2025 08:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA901C4CEF1;
	Fri, 28 Nov 2025 08:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764319159;
	bh=emweKubAm92oT2D1EO70r45t37gZ6Qzd9aHduwcG1jk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UUD92oudvVRiptW+fkQhAqZxu8ZE/Bh1gFsXnoqwYdARGRc2ccvI3eXNieYFyVuEp
	 uvvcXfX0Xrpvyp3fc8Wzv3tCUPwryr/fZHwX/JLPS4bT5FVnF+xejTfXCJgyXKrYlZ
	 sEs7G8/jgAH0yz80dxHWKP/rwdIAIg33mcwOIOB/gMSQBVFYQwh4rB9SOK5Px/5Yey
	 9CfFgdbviGUy6nS/xiaSUXdTR6zt6r5H1RUafvKtTcDRY/HIprBax6fR7/6l8R5TeZ
	 ER5Ja6qPPgrEdu/rUyfdMbZAhl1PaxL6KNKV5ydtcxuhhACPEbhwYSr9izr9iheig1
	 MS2X/VGvfZ/jg==
Message-ID: <e52bf30d-e63b-44ed-9808-ee3e612e0ba1@kernel.org>
Date: Fri, 28 Nov 2025 09:39:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, Johannes Weiner
 <hannes@cmpxchg.org>, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>,
 Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>,
 lance.yang@linux.dev, Randy Dunlap <rdunlap@infradead.org>,
 Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
 <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
 <CALOAHbD+9gxukoZ3OQvH2fNH2Ff+an+Dx-fzx_+mhb=8fZZ+sw@mail.gmail.com>
 <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
 <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org>
 <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CALOAHbCR3Y=GCpX8S9CctONO=Emh4RvYAibHU=ZQyLP1s0MOVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3BC39A000E
X-Stat-Signature: o3araf6ztc3z3qns9kkajscgq18y7b5o
X-Rspam-User: 
X-HE-Tag: 1764319160-35257
X-HE-Meta: U2FsdGVkX1/zcgfgbfnm+EXVoeQtEeyxQ+kgvEjzVNI/Iswz7kCO+sM99GETqURO467fB9rWIh5L3NovV733/uDhmfr2Tg2kP7ld5+wXJ+X2GOK9hvZ9kiA3PD3xm9JekkQxAyOr1fmBWY4d9SDUJJZKcriLETbBklj3GcVs1bEG0QQty4aZcvdXfJoGFezmGcnx6tk3GBs69JhpwCr4DbYnrwEGWOXdcDoPjJ5NVAVtzhrEXed3MNnxz7x+Y/d5rCrLIAiAJxfkRcjoT9s2iINB+DXa7rFVMyCDxrMxjJ6BqN+b3san0ZUKZnS6hSrB1SKeaysfAaDUTkel33Vn/QpT4GtKdwgx+l5Fr/N979eIWI+1BJ1jYCeNi/Z/OCGcjUO/WjN0QVcetJz2ZE7D3wtFyROfr4Ts/1fEENBABW2O0oESbw5Z1WVX2Z/1cCiRVJTxCZZOqAjzypGZFikkfPiwBjzufEvV3qBotjghS0yNuQEoXVayPCN6mDX7TYYQQ653IYoyBoVpcxJuwITlTDXMuKTX72LasZYeCxNMpsUeGuQHD/DjK9g5kVK9gLjUzXLe0H9+7kBVo3lLg6fUnS03eEDLZJuRSbWCZRrLWGpCLNqA39sMlFgBpbToYHyFY5eBhpLYWxCgCb2z0HZpNDadsDq4jwobkcPKc2JfhbKlmlP4q3mFef5aACJFSZpxiXW/r8jamHAi7UHGiUl7uKlRVRCHKQn6dH6D4I13eh1He2EVOUqezdxgvlauxvqJAfB8T7ClD57xusb22KN+O25NvN35UxVg1dcLiL/YgyJTS/Z/y7Y+75RuCbasFzvuwknMyDe0gr0yqXl30r7T9W7YUoBLet95N+iRTa5mlmSGWCAvzBy7eOgrmyURaPDZk3/ce3R7xemZ9gvZ1wgz2ldxivzkp977NQACcc7NA42vMS5lerFJV+w2yzIDWNTeNJeUSPLU4wWLIIeQeFQ
 lbZy235J
 oIbsyifK2HiPuB7nsW2x3/2mIkGOdu+vwySiFaZbCfBOalbyK77eecMm+sFcWKkyiNhO4+cMXBcOMkLCOD+F/xL4EHPbBtVO0CPR1iq2RGHdDasSIwPpZyKGELza05mqrRUB+Xf8Mv3OONofRodVdmkD+/YleQnH/zdl84e5snI1D+7DfRBFTw3zXzbLbwesgGjXZKmdEgK+F68lXyIcWJn00VN4SajgN8pNiHHIyQjzpAt8A2QE4Q3IzwgnehmCjSG/KWX4lwdV8EfUB0aw5VaW6ISIboyJFHLvzdqKyQyu21NZeZxB5EDwO1kCo4IrCgNhFO1ImbjIHyQMn0dmACfoS9s/GYeNOPxPZ2PcFCNiRhoR3Egbm5Hx3FChnjiWd1Vt6Cf2O0xXCvy/m4zdXHdFiun35SkGiH+jHhuxOqosyyDa5Ro5SX//gQMw4anFf+zbZfPnpm6PUkkY9YsJSx51oXW/D6COlAZXD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 03:53, Yafang Shao wrote:
> On Thu, Nov 27, 2025 at 7:48 PM David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:

Lorenzo commented on the upstream topic, let me mostly comment on the 
other parts:
>>> Attaching st_ops to task_struct or to mm_struct is a can of worms.
>>> With cgroup-bpf we went through painful bugs with lifetime
>>> of cgroup vs bpf, dying cgroups, wq deadlock, etc. All these
>>> problems are behind us. With st_ops in mm_struct it will be more
>>> painful. I'd rather not go that route.
>>
>> That's valuable information, thanks. I would have hoped that per-MM
>> policies would be easier.
> 
> The per-MM approach has a performance advantage over per-MEMCG
> policies. This is because it accesses the policy hook directly via
> 
>    vma->vm_mm->bpf_mm->policy_hook()
> 
> whereas the per-MEMCG method requires a more expensive lookup:
> 
>    memcg = get_mem_cgroup_from_mm(vma->vm_mm);
>    memcg->bpf_memcg->policy_hook();
> > This lookup could be a concern in a critical path. However, this
> performance issue in the per-MEMCG mode can be mitigated. For
> instance, when a task is added to a new memcg, we can cache the hook
> pointer:
> 
>    task->mm->bpf_mm->policy_hook = memcg->bpf_memcg->policy_hook
> 
> Ultimately, we might still introduce a mm_struct:bpf_mm field to
> provide an efficient interface.

Right, caching is what I would have proposed. I would expect some 
headakes with lifetime, but probably nothing unsolvable.


>> Sounds like cgroup-bpf has sorted
>> out most of the mess.
> 
> No, the attach-based cgroup-bpf has proven to be ... a "can of worms"
> in practice ...
>   (I welcome corrections from the BPF maintainers if my assessment is
> inaccurate.)

I don't know what's right or wrong here, as Alexei said the "mm_struct" 
based one would be a can of worms and that the the cgroup-based one 
apparently solved these issues ("All these problems are behind us."), 
that's why I asked for some clarifications. :)

[...]

>>
>> Some of what Yafang might want to achieve could maybe at this point be
>> maybe achieved through the prctl(PR_SET_THP_DISABLE) support, including
>> extensions we recently added [1].
>>
>> Systemd support still seems to be in the works [2] for some of that.
>>
>>
>> [1] https://lwn.net/Articles/1032014/
>> [2] https://github.com/systemd/systemd/pull/39085
> 
> Thank you for sharing this.
> However, BPF-THP is already deployed across our server fleet and both
> our users and my boss are satisfied with it. As such, we are not
> considering a switch. The current solution also offers us a valuable
> opportunity to experiment with additional policies in production.

Just to emphasize: we usually don't add two mechanisms to achieve the 
very same end goal. There really must be something delivering more value 
for us to accept something more complex. Focusing on solving a solved 
problem is not good.

If some company went with a downstream-only approach they might be stuck 
having to maintain that forever.

That's why other companies prefer upstream-first :)


Having that said, the original reason why I agreed that having bpf for 
THP can be valuable is that I see a lot more value for rapid prototyping 
and policies once you can actually control on a per-VMA basis (using vma 
size, flags, anon-vma names etc) where specific folio orders could be 
valuable, and where not. But also, possibly where we would want to waste 
memory and where not.

As we are speaking I have a customer running into issues [1] with 
virtio-balloon discarding pages in a VM and khugepaged undoing part of 
that work in the hypervisor. The workaround of telling khugepaged to not 
waste memory in all of the system really feels suboptimal when we know 
that it's only the VM memory of such VMs (with balloon deflation 
enabled) where we would not want to waste memory but still use THPs.

[1] https://issues.redhat.com/browse/RHEL-121177

-- 
Cheers

David

