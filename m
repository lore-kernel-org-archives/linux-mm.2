Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18C9CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 02:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893188E0046; Wed, 20 Aug 2025 22:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869848E0002; Wed, 20 Aug 2025 22:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A62C8E0046; Wed, 20 Aug 2025 22:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B07E8E0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:22:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B93E57A27
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:22:42 +0000 (UTC)
X-FDA: 83799166164.19.12CD2D7
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9322C1A0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:22:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Suk4niCs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755742960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j74vLZJ/pDTvrOLGmgUzsjwHFqEGtuc7kqWVVBs93lA=;
	b=hBO1FDHLZgQJ0R8/coeUeCBdAs1IJu8J/TasDqmDfAfTxNFzDbiJ/6LACZr8vFPJSLNrmR
	ID3zXtFPD5eCptZVMoSoC8LjCVIiXm8nUGpl9gPf3ShhthGi5g09sYaZM8ipQx6AfbBq3U
	C91dID/MW77YJPIZXGS/FCfMQhD8vNA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Suk4niCs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755742960; a=rsa-sha256;
	cv=none;
	b=5fOJyDU0ErM9ZnO58IZY7HwRbsZ4wBHhpqRJMOLl1Rnr+5PWrCrHnIJ/yWuvbg7v82ztbs
	iPrKLHtoeaAdSs6Mo8YL0WHiN1x8QL+cQM+HtvOv5XQoYnc9wdsEaCzad73Hz205vjqRL1
	7nXq2dkOXxHOR0cWfM5xlHXrTukH0is=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755742958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j74vLZJ/pDTvrOLGmgUzsjwHFqEGtuc7kqWVVBs93lA=;
	b=Suk4niCsZPDfF3AjH92kMN99VOBt3dRVWTsdffSM0hmqybDSR7M+H6BQe0sxIveGb+8V/9
	/sTqh0mdQNBNFIDknWXs8LeU5Y/lKkrNYX65al5YV4UQEcL5OzfCbhfAdc537GMe/n8xXP
	p8s623IbZqPxrfdYYuAifSgkbamO820=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <CAP01T76xFkhsQKCtCynnHR4t6KyciQ4=VW2jhF8mcZEVBjsF1w@mail.gmail.com>
	(Kumar Kartikeya Dwivedi's message of "Thu, 21 Aug 2025 02:36:49
	+0200")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<CAP01T76xFkhsQKCtCynnHR4t6KyciQ4=VW2jhF8mcZEVBjsF1w@mail.gmail.com>
Date: Wed, 20 Aug 2025 19:22:31 -0700
Message-ID: <875xehh0rc.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9322C1A0003
X-Stat-Signature: zuutk47kxw6ait8iyecet81n7ckg1ef3
X-Rspam-User: 
X-HE-Tag: 1755742960-616351
X-HE-Meta: U2FsdGVkX1+R/mwUo9aii39Pjacu82hxF2wG3FcJNCNlPnDz9zmeWuZ+F3bLf4blg+soIeCdUkdpHtGnvz1g3mf3D+q7TCSFM0N8qvpO0Lt/p+YWHYOF3hVD6EWIid49dOuixvq5gfiyPiBwqN1b34zutM7EU5Zfnf7S/wOeqcuxgCfFR9mXdeMN2NUgvwMi2XrXUqcq62GtXiHe/Qj47GkqxPnADVycP/oeLElUZNPaDml2OMcJIgMCxLd4YvSgGDeUR4leObHWjbvK/1V5zcXzEZTXjS8CYYHRSan0MacawHK0ICEbOeXus1GxON1g0gMj0MizU1SkVfFy7CZPr1cA4pVX9T+FlXxbokmveOAJ5JNNmZb3cufeEea1AyhUYQvW343XGY82iukdPZXYJdn70j2a1Dz8cv0b2ALl+T0+NlvpUqv1jKQ0BoxYGQZT1Hd+UyYJZk+8f0lVicqDpeELRJ94xbia6FH8Efsz1RhdBiFYrROXpeIunxw+T+v6lY0L6MBKbcIx73tLM9ja8WgQ5uwSnAGjstwFM5N/EToRWcJ4QS5rOz4X0C/5zfMChfvDy5sXnzzwu6WzIx6TrmNgWbcP1ZX+E1Ev4HoUj8FWZgGIu/1oY++SwKBvU+AsmTbYhO0RFBtVk06Lfl3eThRARZLzqRRIZVj7yq3+MDOmTf3AQvv2sqkjwu/ZX6DGxt8I7stV/VWHW5+J9H1enVfeT+aRUnoyexmzVLp7PIG0LyiXKq5Nv/4Y2Jr4SLwkXSfnuBx4tnxjiiCtnXWqCziA7N4yOXs6abByDkTkRLMwAiWW2eX5r5p4itgT2BkT6qZUWUeqzTYqRIwzfMjTlHaWNsRBR13R+Otk77nnMKw4Ozsxyz7rpxZo0YlM4dvd+/EtXXyb8+hRoIa/fIgpmdM4lPCtM0b6X0AFsFRj3B7utoBBqYuroe27WpvUWpnQmpuxni/k1osI6PFayMC
 ABSXmMlJ
 fIZJLAFK+e7wLxAjgKedoQZE/y/+wWF5cndDKKdLmOkc8bJuZd547Hfxo2ZvLRm4lS9FsvXLcVpy8j3j0XMaUsDIy/wvrm1l7zKwSjPNg+6bx+ll4Ihe5uMVjk+aQfPtWLmYhPZeshaLMuU1JXI0i4Lkr4A6w1/Q9al1BMyOZbwQSif+F4P2k4/dpwa4rLPtUXNmRHd/ihQOYX5CZQ5BnqNngqUio11hCDnpY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Thu, 21 Aug 2025 at 02:25, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>>
>> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>>
>> > On Mon, 18 Aug 2025 at 19:01, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>> >>
>> >> Introduce a bpf struct ops for implementing custom OOM handling policies.
>> >>
>> >> The struct ops provides the bpf_handle_out_of_memory() callback,
>> >> which expected to return 1 if it was able to free some memory and 0
>> >> otherwise.
>> >>
>> >> In the latter case it's guaranteed that the in-kernel OOM killer will
>> >> be invoked. Otherwise the kernel also checks the bpf_memory_freed
>> >> field of the oom_control structure, which is expected to be set by
>> >> kfuncs suitable for releasing memory. It's a safety mechanism which
>> >> prevents a bpf program to claim forward progress without actually
>> >> releasing memory. The callback program is sleepable to enable using
>> >> iterators, e.g. cgroup iterators.
>> >>
>> >> The callback receives struct oom_control as an argument, so it can
>> >> easily filter out OOM's it doesn't want to handle, e.g. global vs
>> >> memcg OOM's.
>> >>
>> >> The callback is executed just before the kernel victim task selection
>> >> algorithm, so all heuristics and sysctls like panic on oom,
>> >> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
>> >> are respected.
>> >>
>> >> The struct ops also has the name field, which allows to define a
>> >> custom name for the implemented policy. It's printed in the OOM report
>> >> in the oom_policy=<policy> format. "default" is printed if bpf is not
>> >> used or policy name is not specified.
>> >>
>> >> [  112.696676] test_progs invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
>> >>                oom_policy=bpf_test_policy
>> >> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted 6.16.0-00015-gf09eb0d6badc #102 PREEMPT(full)
>> >> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
>> >> [  112.698167] Call Trace:
>> >> [  112.698177]  <TASK>
>> >> [  112.698182]  dump_stack_lvl+0x4d/0x70
>> >> [  112.698192]  dump_header+0x59/0x1c6
>> >> [  112.698199]  oom_kill_process.cold+0x8/0xef
>> >> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
>> >> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/0x313
>> >> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
>> >> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
>> >> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
>> >> [  112.698250]  out_of_memory+0xab/0x5c0
>> >> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
>> >> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
>> >> [  112.698288]  charge_memcg+0x2f/0xc0
>> >> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
>> >> [  112.698299]  do_anonymous_page+0x40f/0xa50
>> >> [  112.698311]  __handle_mm_fault+0xbba/0x1140
>> >> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
>> >> [  112.698335]  handle_mm_fault+0xe6/0x370
>> >> [  112.698343]  do_user_addr_fault+0x211/0x6a0
>> >> [  112.698354]  exc_page_fault+0x75/0x1d0
>> >> [  112.698363]  asm_exc_page_fault+0x26/0x30
>> >> [  112.698366] RIP: 0033:0x7fa97236db00
>> >>
>> >> It's possible to load multiple bpf struct programs. In the case of
>> >> oom, they will be executed one by one in the same order they been
>> >> loaded until one of them returns 1 and bpf_memory_freed is set to 1
>> >> - an indication that the memory was freed. This allows to have
>> >> multiple bpf programs to focus on different types of OOM's - e.g.
>> >> one program can only handle memcg OOM's in one memory cgroup.
>> >> But the filtering is done in bpf - so it's fully flexible.
>> >
>> > I think a natural question here is ordering. Is this ability to have
>> > multiple OOM programs critical right now?
>>
>> Good question. Initially I had only supported a single bpf policy.
>> But then I realized that likely people would want to have different
>> policies handling different parts of the cgroup tree.
>> E.g. a global policy and several policies handling OOMs only
>> in some memory cgroups.
>> So having just a single policy is likely a no go.
>
> If the ordering is more to facilitate scoping, would it then be better
> to support attaching the policy to specific memcg/cgroup?

Well, it has some advantages and disadvantages. First, it will require
way more infrastructure on the memcg side. Second, the interface is not
super clear: we don't want to have a struct ops per cgroup, I guess.
And in many case a single policy for all memcgs is just fine, so asking
the user to attach it to all memcgs is just adding a toil and creating
all kinds of races.
So I see your point, but I'm not yet convinced, to be honest.

Thanks!

