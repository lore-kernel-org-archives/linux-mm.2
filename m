Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AC2CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1EE6B0005; Fri,  5 Jun 2026 05:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C4D6B0088; Fri,  5 Jun 2026 05:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC226B008A; Fri,  5 Jun 2026 05:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0A46B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:32:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F1581A054E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:32:01 +0000 (UTC)
X-FDA: 84845342442.11.0F664E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76EEB14000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:31:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DNgiJnLA;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780651919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GdduqExShaT7dff5IoDbAyZHmANXhd+uGbGSM1erRXA=;
	b=5OUci10ODh/05RddS/01GZtZKdOlOxUcLJZJB9CPZYAk17vplZPkrdZws2jOar+PxnFRa8
	EVY4jxMQNv2Es4KVp6ps5BVDRtVxCOQBJGwA7S/YHn9KABuwyy1h8clgwfvZyPNrHqlfhq
	2vjc7Q+yxie3ub8CsSdBXjAKfrzHFlI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780651919;
	b=k9yMdRHPi3FKLX/WdZcMlbSMoepM/iwvhtvh8jO45XkKbK3FmLhblO5bZRCrcAAeeB9SY1
	qNneLBiJk9beYtiTCzLXcA0nTH5idebPL3vJV9p0BMWj+hgNrbQauRKgM3M0Vj8+7ngwxa
	1BFMck35eLYJrIYHJJFv+D4qHTWSWeA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DNgiJnLA;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4624601DD;
	Fri,  5 Jun 2026 09:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7E41F00893;
	Fri,  5 Jun 2026 09:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780651918;
	bh=GdduqExShaT7dff5IoDbAyZHmANXhd+uGbGSM1erRXA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DNgiJnLAEJPr5JwKuY2/1gEfv9isFZJXBijEgs0PK0x9Umv2xGyhas/e1EZBgF2Ef
	 vAEAQIT/GjcX0zYHMiR4puctAxje3RBaaeiVWH46LiA+av7Ii1+EU0DFX1VImMG0ZY
	 r/3FVsnxAvCSoqGlJlI1NOAy1xWSF1FeITRrSRUoZM21wLGSsohNkF+DNrHstXghur
	 SRo1KGUaZcP+9bDaXCtz5oMelFciV34HGwENGnXKQu4DySyuL20KvoQSxpvE1LO/KT
	 rcbas1BoKwa/FzVUFWIhiTYA+NG5qrcHgZ5qkY4/UO/f+cZbJttw4cbd+6xsFE3Aoz
	 OD/d2TvBSulEQ==
Message-ID: <6f5265f1-d7c5-43b9-bd93-5066313704b4@kernel.org>
Date: Fri, 5 Jun 2026 11:31:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] mm/process_vm_access: pidfd and nowait support for
 process_vm_readv/writev
To: Christian Brauner <brauner@kernel.org>
Cc: Alban Crequy <alban.crequy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>,
 Willy Tarreau <w@1wt.eu>, linux-kselftest@vger.kernel.org, shuah@kernel.org,
 Usama Arif <usama.arif@linux.dev>,
 David Laight <david.laight.linux@gmail.com>
References: <20260602100917.3641359-1-alban.crequy@gmail.com>
 <20260602100917.3641359-2-alban.crequy@gmail.com>
 <20260603082707.3831525-1-alban.crequy@gmail.com>
 <8e738cc8-dce8-4043-9b93-2bb867c43028@kernel.org>
 <20260604-ornament-sparen-biegung-e9930ee7444e@brauner>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260604-ornament-sparen-biegung-e9930ee7444e@brauner>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 76EEB14000B
X-Rspam-User: 
X-Stat-Signature: wj69kbkkdcnnigd7pf3591e8f9t6zwo4
X-Rspamd-Server: rspam08
X-HE-Tag: 1780651919-501182
X-HE-Meta: U2FsdGVkX18S13Jw01kQS7Ur4h84bAWxMjWG/dpUwo9BhBsSnkF0oQuzndgMhUx/D6xA3cAyl7lM+H5dLgDDPl/BNPDGwFBumUMFFW+AKNCRDpKfhto2xxR52c1zmO+3mw4SaO0fzvnTMf0pLH7kBwFKUeU/RL3TqNvK1qsuJcFcbcePy4KC388s2AheQKPLgD32HU2cgevDSWB+Fshpxf9G3FmQ7bS1KsEbeGjFypa9UINW8ctoIJjz2ZgL3echLz9tuPTSgoMMgWcOtSjXlq7iEfSXdQsPrkyrpCjAvQO0nr6uT/QLtnCUXbtT6u3wx+KBJt7wxtu9a6H1naHty+kTf+ELNszFU4n9sbojvaPtUcVGqftvsOlQjqaWIYTO58MVH1wHzcRja/DwcPCZ3n1Y0S0suuYMxYErPPBSux27qaSU7H3GbWyEiVoBRgS23fVjvLQSzR23pPFsLn7HHF4NV8f8eadtXIvLnghLaNKWhHWrnGN9gpx+kElS7lbZNFmijKtNRqEh9ImPMEVGxVrxnUs32AZcPqHbAU0oD5lEQPQCO0deaXAU0ZL9rlMKrRYka/bc6Sx7I1cUmI6E0aBZpMLWxCbYb8KWHbE20TSxOxftEOS1KhsocdIVORjrjrxGr5ofiFRIATw4y6x3cTfPQHIhcUU8gG+KEEngFyLbtvUjZO3fBbxmB6E0IdDvkMoYmFQwWzc49LUgwG4RR+TDVtB/aPU5RRZucgSzRALmdgB60AT6/YDvqTqh/MGS7pvsHS3hGwllGL13O0Cd/5BF8Acw4SalhlHlRyQr263Nv4aBhXVVHFDrpzR4VIl2+jm3pi3oaKsYBVVVlNMC6SmkBI/zyElVgE5o6woA+l8RwhYso6uPOQMak2Unce3CLYmjRe35WjMU6M4wCPCWfBLINzmayryx5ha/jW5xDqyd79w7G/8+VqBdLE33rIkjAjwAQN3dclYJK40w5cA
 yNjGYDsb
 BhHq9rpjRITY0haigJIHaNtELo+7x2LdET2MTOtOBXASWIrTAkXrFQUCPKgkyFvmZ0A8FYoPrQ+NH2brE52auw8EJL33hOLXKvBRy4cchSYTDyutMuwNk9ROCpB8ySe1cPxH+13dochLOGCVCnfBtlh+/KLSBoUL12/l2rzcQqHthEHL/Z1TdoSM3MhhnIRnx/iWTcyfK44wwIR1+j/l/GReAr5DXthvY6GfZCQgv7Fzji2IW/OlpDOf1hNeltRRoSB39pKQRqgJEbGRaOJcUwxxIHoQTcR7vJwd6iZHTQvmFuXUac2h+m4dHxP9uUhOA2VYimXE+DYuaJ1bpgmn96Qup+uBA6hrQHvLD+RC3GtmQKc5sU/5DbTSlEW3nT/G3Xldp3mi+2XIEjqivDRWvUyqJWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 14:49, Christian Brauner wrote:
> On 2026-06-03 15:54 +0200, David Hildenbrand (Arm) wrote:
>>> However, the exited-leader case is a real limitation for profilers.
>>> OpenTelemetry eBPF Profiler wants to profile a process where the main thread
>>> has exited but secondary threads are still running [2].
>>> [2] https://github.com/open-telemetry/opentelemetry-ebpf-profiler/pull/376
>>>
>>> Using plain TIDs (flags=0) would work, but it means users cannot use
>>> PROCESS_VM_PIDFD in this scenario.
>>>
>>> What do you think this patch should do? I see two options:
>>>  - Address this limitation in a separate future patch that fixes
>>>    pidfd_get_task() to use PIDTYPE_PID when PIDFD_THREAD is detected in
>>>    f_flags, benefiting all callers (process_vm_readv, process_madvise,
>>>    and any future users).
>>
>> Extending it consistently for that scenario seems like the right thing to do?
>> @Christian?
> 
> Yes, but I cannot vouch whether the mm operations deal correctively with
> subthreads.
> 

I'd think so, but I could give it a detailed look when reviewing a patch :)

-- 
Cheers,

David

