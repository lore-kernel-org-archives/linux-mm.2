Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2510CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 21:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4EC88E000B; Sun,  2 Nov 2025 16:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E250C8E0002; Sun,  2 Nov 2025 16:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62BC8E000B; Sun,  2 Nov 2025 16:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5DEE8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:36:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64B8413BFF2
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:36:40 +0000 (UTC)
X-FDA: 84066976560.17.66DB7F4
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 64E94180011
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:36:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uWjkOvIW;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762119398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcGx6i/+++ufNscO90BKEs/b8++kUKzaqmiZ//H9ISU=;
	b=XO3nc/NXJTEuqA5u3DoXgJt0bV/+6jh8S7GAKJoQZtqCeC8dlaWBa+8s30tntMRm2D8khq
	o0uvWK6HuA+qUEpg6r1+VVLfKE9pkUay5EzuX6J3T9IFxFskJVpv83QRwlt09J7695nAsA
	xxFfye1z28Yh1xNxy3HOsfUbn6bncxA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uWjkOvIW;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762119398; a=rsa-sha256;
	cv=none;
	b=Vt8rY6gy6u6Wkqbo6OKeQSmmUxrl7k7PR8hi0Z9q6eOfRwomrF0C+/qNvpIGVyhLG5G57g
	LNvzNw5JaI+59yMyRUuJBB9iJfkz6Ha0iIe6neQnkrXqeXGrq4o95IEaeQRsXAgbT+6GNk
	CSrpHPVlJIV1vWWjChtQ1B0EfkLvdek=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762119394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qcGx6i/+++ufNscO90BKEs/b8++kUKzaqmiZ//H9ISU=;
	b=uWjkOvIWS/CmQ5V4hKpdOf06Eo4ZAkvv91DlTySCJ+m53/jNAeeaZdCBfaDTh6/k+AtkyR
	OVFVRg96tGQ0GJMt7tJOycDaK3A5j0R8batwvzteEfJiSGDHZ8F1jonFIuRsADZ6tdXsD3
	F1obi2np1FqjXVQ+3cEKvINCpn4xOk4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrii
 Nakryiko <andrii@kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,  bpf@vger.kernel.org,
  Martin KaFai Lau <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,
  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
In-Reply-To: <aQR7HIiQ82Ye2UfA@tiehlicka> (Michal Hocko's message of "Fri, 31
	Oct 2025 10:02:20 +0100")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-7-roman.gushchin@linux.dev>
	<aQR7HIiQ82Ye2UfA@tiehlicka>
Date: Sun, 02 Nov 2025 13:36:25 -0800
Message-ID: <875xbsglra.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64E94180011
X-Stat-Signature: gbu75sxz7q81dq5wq53mr7i463ab8eun
X-Rspam-User: 
X-HE-Tag: 1762119398-798910
X-HE-Meta: U2FsdGVkX1/uo0/8tYcMYHimeYcFELrftsPwyl8rIUWJBQy2ZAaMIMXPshtQw4v19k90QzBl544sLeVo0V4U1GOoW84dCEQPN9F9GZqqNdfQWzuZykfjDAEu2RmAXnmP21dAqYzxedwBetmmmxzy4V+95IN2cO4gjYJmqlNhNvytCFjZlvQquRL4BJaebjSZfdCIbPV3zPWdR71Lu5yI4AlbVcrapH/uHauWf1SBO6V/r304UIszcA6LjTw4g9MyxZyHdL4mkYNThx53r63uh8zD7ODwkkPvgAL/D74bi0AqqBFE+SCNK1SIhwCiwnDFWtsHqaCpcLt+b573+7npkeY/bcT+3JY01sntFfpVi8bGL30oLqpaOXTxA6tphmrUUXCCvHLZpFkB06Da9UFky1/K2xoCLS8PJGqj+4glI4OxReaTK2b+JNX6prbRP2ToZo175QUdRrPJijT4GW1/H3ZLi8SQeQLxbmDaEHpAIhCfIIORA4ntPOlIfU7ErOJcsWefixGmdqKfmSCEH3Zxk5rvKNFf548lVXlhJYskh/5+eKhEAk+FrTHCkW7gu79wpVYQo5E8XKclVKEU9Bx6sqkK+DDMtMjX6zbgJOM3epXTKvi+nURSVT7+kseJ6DPixN/JiMS90baTZ9pDfvWExIoffRrnFP5BaJhnIggnqfGTk4kkzwM1mJXhLItqLY1KYPD6NzmaWdl+2f06KGuy16/Yk7RzS09OsvUTczAUFVTmdjEbXjGRxghsuGSwS4QqlOh3a7KRZT09wxpr3o7FIY8PrEPHBfETWvS/i5qBSPVssfE7xsWEkewRP1GODBbZ+kxPWQSxUYJLxJnqZwIyq5ZS1wU+3m19eF6X7HtZLUJcuUL3W2v2O9lnC3Jpb/f2V65TjU8aag2lgVbS+Eu/iG8S8mi3mlZsckdGc53pk10zmEJtAMhA7Jpfg7iGHcfGmEhux60f4CM58KDd/Aq
 ZsZQFBld
 KAEekqj//Ra913LFhhb8oWa5B5qgHQzKO/RgyiFYSyiX3dkgdejjgXfnGzzNQSuCidcINcpGiNOZm+MYJXAqp9KZUwe7BTSY6Yibrqu4+b2oKpbX2qrBWm4lHm/lT+hA9EoT8zXJIC5uBURF0EYvVDiHFrY4Vv29VST7Q1nEmr74Ux0EvDqkzCCbQzXhx0W3oOs+uO+wsf+X0MxgIV78WooDBcK1e364yQoIR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 27-10-25 16:17:09, Roman Gushchin wrote:
>> Introduce a bpf struct ops for implementing custom OOM handling
>> policies.
>> 
>> It's possible to load one bpf_oom_ops for the system and one
>> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
>> cgroup tree is traversed from the OOM'ing memcg up to the root and
>> corresponding BPF OOM handlers are executed until some memory is
>> freed. If no memory is freed, the kernel OOM killer is invoked.
>
> Do you have any usecase in mind where parent memcg oom handler decides
> to not kill or cannot kill anything and hand over upwards in the
> hierarchy?

I believe that in most cases bpf handlers will handle ooms themselves,
but because strictly speaking I don't have control over what bpf
programs do or do not, the kernel should provide the fallback mechanism.
This is a common practice with bpf, e.g. sched_ext falls back to
CFS/EEVDF in case something is wrong.

Specifically to OOM case, I believe someone might want to use bpf
programs just for monitoring/collecting some information, without
trying to actually free some memory.

>> The struct ops provides the bpf_handle_out_of_memory() callback,
>> which expected to return 1 if it was able to free some memory and 0
>> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
>> field of the oom_control structure, which is expected to be set by
>> kfuncs suitable for releasing memory. If both are set, OOM is
>> considered handled, otherwise the next OOM handler in the chain
>> (e.g. BPF OOM attached to the parent cgroup or the in-kernel OOM
>> killer) is executed.
>
> Could you explain why do we need both? Why is not bpf_memory_freed
> return value sufficient?

Strictly speaking, bpf_memory_freed should be enough, but because
bpf programs have to return an int and there is no additional cost
to add this option (pass to next or in-kernel oom handler), I thought
it's not a bad idea. If you feel strongly otherwise, I can ignore
the return value on rely on bpf_memory_freed only.

>
>> The bpf_handle_out_of_memory() callback program is sleepable to enable
>> using iterators, e.g. cgroup iterators. The callback receives struct
>> oom_control as an argument, so it can determine the scope of the OOM
>> event: if this is a memcg-wide or system-wide OOM.
>
> This could be tricky because it might introduce a subtle and hard to
> debug lock dependency chain. lock(a); allocation() -> oom -> lock(a).
> Sleepable locks should be only allowed in trylock mode.

Agree, but it's achieved by controlling the context where oom can be
declared (e.g. in bpf_psi case it's done from a work context).

>
>> The callback is executed just before the kernel victim task selection
>> algorithm, so all heuristics and sysctls like panic on oom,
>> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
>> are respected.
>
> I guess you meant to say and sysctl_panic_on_oom.

Yep, fixed.
>
>> BPF OOM struct ops provides the handle_cgroup_offline() callback
>> which is good for releasing struct ops if the corresponding cgroup
>> is gone.
>
> What kind of synchronization is expected between handle_cgroup_offline
> and bpf_handle_out_of_memory?

You mean from a user's perspective? E.g. can these two callbacks run in
parallel? Currently yes, but it's a good question, I haven't thought
about it, maybe it's better to synchronize them.
Internally both rely on srcu to pin bpf_oom_ops in memory.

>  
>> The struct ops also has the name field, which allows to define a
>> custom name for the implemented policy. It's printed in the OOM report
>> in the oom_policy=<policy> format. "default" is printed if bpf is not
>> used or policy name is not specified.
>
> oom_handler seems like a better fit but nothing I would insist on. Also
> I would just print it if there is an actual handler so that existing
> users who do not use bpf oom killers do not need to change their
> parsers.

Sure, works for me too.

>
> Other than that this looks reasonable to me.

Sound great, thank you for taking a look!

