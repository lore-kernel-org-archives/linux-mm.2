Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CBFCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11A126B0022; Thu, 27 Nov 2025 06:48:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CAC66B0023; Thu, 27 Nov 2025 06:48:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007966B0027; Thu, 27 Nov 2025 06:48:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3FB36B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:48:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CEBFBBAB8
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:48:48 +0000 (UTC)
X-FDA: 84156215136.18.0CFEAAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BCF5F140004
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:48:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tIlJwzwL;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764244126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qiydg3BF/jvzej21GSxsm5apfU//yCIu3Vkj1Qi2sL0=;
	b=7UdHA8S6bHaJJwzvJx+d5TNbJVD08HZbB86x8Ib/BxVqhsaXH4bjCE7YmG5JOzTv3w6Y4V
	s0VX20awVZjEkdp/f3yolutoattiN5KQXE3XbAD/I+/8X+xOsQIdJwvAQdd2pwQsGN61GY
	2Rym+sdbe5ZI7XQO3uQHXFtLAw5nec0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764244126; a=rsa-sha256;
	cv=none;
	b=whmRVv9Fyh7Y1A+vHe4htlyYSNjaqBx8NhyNT2Ft790W6vJQxUjZZAzhG4K8QbhcnKpmTN
	9rbpbnz3tG6pHjUUQccvYd0fWbcxozHJmNm1igmaMHLPB6Rn1Qstzdy4IFeeXzuvmf8DY7
	Xq8o/DDcnXAH3IHtpwe2iuAE5j65bXI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tIlJwzwL;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF26943EF5;
	Thu, 27 Nov 2025 11:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E511C4CEF8;
	Thu, 27 Nov 2025 11:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764244125;
	bh=w/afnhuYyNZIpCydtL72AbZ9I5In+EX1JoLUP6VMW2A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tIlJwzwL3cjRTN8mgWo++SdcXe3FjPS+Xlfq613EqGHn+hljGEMsciAyEvGEtxggW
	 U6hS+CA6VqAl3wDTQT0zY0zuYfoPC2mtD+e63GIsHgyPFYYP14UbAH46cEcp214acs
	 9g2pl0ho6ilJP/wlcnosybWKcg/b/CkB3rjhDALYYBFYlCEPPYicCoSRLBdaXoZRlk
	 sEscJ/dCsrWibvkGoY8sLJpFdiH/y6diziI2PGI1ECAtw/CJNC9LMY9b+Y57swmgKH
	 yrq2DUcTxsXGSC6XhQic1mgvMV5cV5jb7CH+UUatK4u13CX+M3ZW5UstuULer6EIya
	 fSwxnSiCgEPpg==
Message-ID: <9f73a5bd-32a0-4d5f-8a3f-7bff8232e408@kernel.org>
Date: Thu, 27 Nov 2025 12:48:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAADnVQK9kp_5zh0gYvXdJ=3MSuXTbmZT+cah5uhZiGk5qYfckw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BCF5F140004
X-Stat-Signature: 79yi4hduauts9ec79phnh8po5bjpa6bu
X-HE-Tag: 1764244126-573237
X-HE-Meta: U2FsdGVkX1/AByfYIXcLmWqi5MVgkK5yIcONrLMW4EfkinG9OmpIHKi6ue35SeQ1cVnsgv2LR1bAiL+ElA4lldAohYeH4WBchTFv/WQ/8XkvrbaNMGaLO3t2dKPBx2urS967VBOvM0y6m5CGeFyBiP8KYxoNeEzEo4OG/akJ7GaJg5LcrDytQtQ/zKml7UXyrN8EFWUhnMvCALUCsfULkRRktKzyfOHHJqZttI5fAyBagBGtyDV5VDowWbmC8kMVinnPQJHWC1D4Wjltkr4xcfHqjQNoulKvi+cTsayND0nisYgj4CfS1VE0c/ofivHbLPzMDHqLJan+H35Io0XsigSqknVmZ/hoyNp6G9IPAt5Ii14+YWr4D6KkHJZ/V45+5BCeLFOfP7X+ccfzsblwtigqFl8u+xs0ZsyWbM36QOKtM27kPekFybyXa07fj5HkCDVGqWg9AopUHXAqm0pzATPANF/nS+SsZy0Wb+vEC0xpXRQLXHPJsApyANcyjdQm2frHo9MhhB/U2XOMPJHWN/wJZ9g+FeoUG/WyY2bf/Sbs9SjpcvLZJ/0FFXAGufKryxkEt+P/EuWG5yNP6wRyupWxk0q0IeeT8gjGnDexi31472Dh1X+rZ5Xy7JhuxsZpV81qinSCVG3OmV/WPfCDM8lzggBf7rjxKQpqYs1Idk9FFyDE7AgEUbLnQd4Kdwp+0qpsUhqGuVLvfDy3h7veybXu4RjqN2DaqB6QQkToAiF5kCgqosMjAy+MjLWQJa9P7DcVpgNycOcg9SGDWwp49GrahpXHrCSpMsWNSTKUgQp6hCAZL0n5cj7mVbUMN+yEuSaP3PuyFnApTKp3rOwW+0agYxiOs5cKzWuT34c2gWqZ9bilb83vjJ7PGeVc1Bfgh5StPNhc6jB7JBwDfg1vrjcLUm4NvYu5a6PYpuYMmZjv2bDrTsBvsNLGtYleioMqXAE6B2ziRJXPGGlMXn1
 Bw3BisU/
 msR7S59KvEydbWNSefjFYmHWduOY7AlxTB5lvEkCX9BqVj3x35l1PbLb4rrJXF1taxmJC+7za5Wbk8CwWAVx0D5m2ACzCeAseG5a/7F892lUUT+4TLBqXTYf3STCGwCNXS7LwCg7alGahdt1/DGp1ln8iNwgHeHtLEF/CueXpqvdV8F5eszyiYYe22rYnz3/SHsvR9QPGxSGG+RmLnTGXZGUSogoUcytqyPXamiKM+iobmG66AjCBPHv+O9AkftLm4O0QiVU0EykArPgJCd+AaFQ4SCugJ+MkbcCewKB8a4KqULkrVvUxvAh2reUkZtko4MdA1wcEXDomDwIS+p2dcuwAuHA/DHBDCmECUpQ6nS/jcB8lyz5MzA09ruej/yMTmkgL0pal5vMU2kzL5QxJamS4B6r7mO3Mix1R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> To move forward, I'm happy to set the global mode aside for now and
>> potentially drop it in the next version. I'd really like to hear your
>> perspective on the per-process mode. Does this implementation meet
>> your needs?

I haven't had the capacity to follow the evolution of this patch set 
unfortunately, just to comment on some points from my perspective.

First, I agree that the global mode is not what we want, not even as a 
fallback.

> 
> Attaching st_ops to task_struct or to mm_struct is a can of worms.
> With cgroup-bpf we went through painful bugs with lifetime
> of cgroup vs bpf, dying cgroups, wq deadlock, etc. All these
> problems are behind us. With st_ops in mm_struct it will be more
> painful. I'd rather not go that route.

That's valuable information, thanks. I would have hoped that per-MM 
policies would be easier.

Are there some pointers to explore regarding the "can of worms" you 
mention when it comes to per-MM policies?

> 
> And revist cgroup instead, since you were way too quick
> to accept the pushback because all you wanted is global mode.
> 
> The main reason for pushback was:
> "
> Cgroup was designed for resource management not for grouping processes and
> tune those processes
> "
> 
> which was true when cgroup-v2 was designed, but that ship sailed
> years ago when we introduced cgroup-bpf.

Also valuable information.

Personally I don't have a preference regarding per-mm or per-cgroup. 
Whatever we can get working reliably. Sounds like cgroup-bpf has sorted 
out most of the mess.

memcg/cgroup maintainers might disagree, but it's probably worth having 
that discussion once again.

> None of the progs are doing resource management and lots of infrastructure,
> container management, and open source projects use cgroup-bpf
> as a grouping of processes. bpf progs attached to cgroup/hook tuple
> only care about processes within that cgroup. No resource management.
> See __cgroup_bpf_check_dev_permission or __cgroup_bpf_run_filter_sysctl
> and others.
> The path is current->cgroup->bpf_progs and progs do exactly
> what cgroup wasn't designed to do. They tune a set of processes.
> 
> You should do the same.
> 
> Also I really don't see a compelling use case for bpf in THP.

There is a lot more potential there to write fine-tuned policies that 
thack VMA information into account.

The tests likely reflect what Yafang seems to focus on: IIUC primarily 
enabling+disabling traditional THPs (e.g., 2M) on a per-process basis.

Some of what Yafang might want to achieve could maybe at this point be 
maybe achieved through the prctl(PR_SET_THP_DISABLE) support, including 
extensions we recently added [1].

Systemd support still seems to be in the works [2] for some of that.


[1] https://lwn.net/Articles/1032014/
[2] https://github.com/systemd/systemd/pull/39085

-- 
Cheers

David

