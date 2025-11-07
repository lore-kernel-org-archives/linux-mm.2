Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E3CCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 15:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843678E000B; Fri,  7 Nov 2025 10:29:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AB28E0002; Fri,  7 Nov 2025 10:29:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731FE8E000B; Fri,  7 Nov 2025 10:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7678E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:29:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10AED160280
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:29:41 +0000 (UTC)
X-FDA: 84084195762.23.A3BD460
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id 328BE140019
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 15:29:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wW5ZWXXp;
	spf=pass (imf09.hostedemail.com: domain of 3YRAOaQsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3YRAOaQsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762529379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NCtP8IGmv+Pw2m+0QbiCX0FT/X+Jg+0AV+Nk5shH04=;
	b=xBjlG+K5CaMj6M/teVcwLCeaHVlkb0O8MuRCKQpR00nk0n/6mmBgtvch8k+Tz+UjaH7ybX
	kOFeWBKXoq06SFAaQ6WdzYnN/K7RM6gsFVOD9nU1YAPl2U/UqnM+kTSc03SnUo4db8tIwR
	jb6fbMZ69OTEUnl5xman0c7FC+OvGt0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wW5ZWXXp;
	spf=pass (imf09.hostedemail.com: domain of 3YRAOaQsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3YRAOaQsKCAokmuo1vo83xqqyyqvo.mywvsx47-wwu5kmu.y1q@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762529379; a=rsa-sha256;
	cv=none;
	b=p6TK6PrMGWzCurb6RbhLCasuk5xgqPrkn98giBOcLPSh+4hobsxWU8JyEBNKZlP92O6iAG
	kGiP55bE/XFCYmOxaOk32LQsZTC4zk5Cbghaw3+DmwjOWFgjf/wLPwuP8NheyOte7q5yln
	QVuFftY12Bdwq+Ofli00V6XKKbEudF8=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7aac981b333so911447b3a.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 07:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762529378; x=1763134178; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1NCtP8IGmv+Pw2m+0QbiCX0FT/X+Jg+0AV+Nk5shH04=;
        b=wW5ZWXXpt0jd0TkNfd3h20nyVfDPT1fDg5UBGo42qaT+FnbwfDdRA2B6SD/+B86M/l
         GvmL7ZpARM7arzIvFd3TcrteYiL9URsy3vLGBkA6ip0slfNfahCcNZ4RhI/dr2Zph0Cf
         HCYqGbjrnQFbG7LAzqILhzali145mxwwokzpgORbc7TSrRM325o8st4mGTvnK0oBKwE2
         aBus2bZfw58vrybb/BDYE12oLmB2WJho+oRzNld9WJVMO8J6W4j4vk3o0ypvjsxp5rjA
         3Xdp2o8grjn0EvZMIIKu7XM8DnKBWFMgoOVwl6D02pqnLSOutG/FAZ8Ss+N6csGqqqey
         NEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762529378; x=1763134178;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1NCtP8IGmv+Pw2m+0QbiCX0FT/X+Jg+0AV+Nk5shH04=;
        b=B4S6ogjeXYekXHbWrWd9iS/eKaa12ZMHaKLGwG+Zh+lxwtssUVo/n2yuoH7Ozb3+9b
         MrezGdHgKwaEYSdcgSbMd/aMntbBC/MsyxO9wxu5INWiOHL13D7/tr3MenxmYoAZNT5z
         U8ZR6bvhag5uq4yO9GZWQJyh2GB1ORrNiJvf4Tohyg5aVSwgxRGMbvCi+RACX7RH2kQT
         mEX41y3vtOvuwPBv+2bNqxrWfRQEOu/4YxkToCYGso7X/lfBqvbr4/tBRlQVmGULhk6Q
         9I3MIWq9YSWoqQibTo9T6nOb7347a6g3vMdfNUUm/G4/UdFVOC4WOClQaTCgCkzjClnk
         /Swg==
X-Forwarded-Encrypted: i=1; AJvYcCUF9JqjLk5atwLJOlZBmmLAcRoBhg7YXrrJ2ajDJa7oY4rJiqJ1g1OcOg4n3GHghx4O2nSfDKZPGg==@kvack.org
X-Gm-Message-State: AOJu0Yz7P46KilTOePFRLKmmD9lK8xBn7y/1Y6KwQNe0vsaCbi4dzizw
	KgpCKe1JEoA5ZRLURIAgqYV1QoE2a2TrduS2FqV7aBYBlHlS0+60Ac+U1ugng52WWqCpr6hM/1Y
	TZjuMbpMHqV01oN/LgmNZcK1fTA==
X-Google-Smtp-Source: AGHT+IFdBm9PWDkj6mr4favewOwyFDia/jMLQ8Mc88gwVWiHhbOXmm65FevtICCyCLCB04h8IaDFB/VQj/QABmFYNg==
X-Received: from pfoo25.prod.google.com ([2002:a05:6a00:1a19:b0:7b0:c46:4c56])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3cd1:b0:7ab:6fdb:1d1f with SMTP id d2e1a72fcca58-7b0bdf66564mr4826942b3a.29.1762529377589;
 Fri, 07 Nov 2025 07:29:37 -0800 (PST)
Date: Fri, 07 Nov 2025 07:29:35 -0800
In-Reply-To: <d25340e3-2017-4614-a472-c5c7244c7ce4@linux.dev>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-3-roypat@amazon.co.uk>
 <e25867b6-ffc0-4c7c-9635-9b3f47b186ca@intel.com> <c1875a54-0c87-450f-9370-29e7ec4fea3d@redhat.com>
 <82bff1c4-987f-46cb-833c-bd99eaa46e7a@intel.com> <c79173d8-6f18-40fa-9621-e691990501e4@redhat.com>
 <c88514c3-e15f-4853-8acf-15e7b4b979f4@linux.dev> <aNZwmPFAxm_HRYpC@willie-the-truck>
 <5d11b5f7-3208-4ea8-bbff-f535cf62d576@redhat.com> <be89abc6-97ca-47d8-b8e7-95f58ab9cc67@linux.dev>
 <f13e06f3-3c7b-4993-b33a-a6921c14231b@redhat.com> <d25340e3-2017-4614-a472-c5c7244c7ce4@linux.dev>
Message-ID: <diqzqzu9dfog.fsf@google.com>
Subject: Re: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling
 TLB flushing
From: Ackerley Tng <ackerleytng@google.com>
To: Patrick Roy <patrick.roy@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Will Deacon <will@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, "Roy, Patrick" <roypat@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"song@kernel.org" <song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 328BE140019
X-Stat-Signature: o8a7nhhu4kfacajn548xunjm9m8sqjsz
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762529378-223707
X-HE-Meta: U2FsdGVkX18VVCzcAEgrzLyjZSfpnlkphbcZsuIaKUovJMLdi+YvmKqIT8I0xPDATCQ5OGe2ZAeWCRbfi243+IVZ3l2/sG6rkdA+/lmYWbwm1b+s5C1eXrMf6jdEQrmq4+K2hAm8LKd0lXwUB3d56Cai9Vi63cPC4mE/BdItShVAHzhhPcMIO2Tk9VGcWZznWteMMIwbS+7qpPmllUilPToTNq381FFsnRjSLsvGsON0nUXBXwUcaGkPbKKsaqhXW436sSC7lJhMvZg6g1o/XHpJzg4N2B3WJj/pw4WAnVaWUp/id+eN/ZTFjCkiEcHCNpzlqr5HJqubkV0N/HWzGaSWHSOaH/8UhaGEln5b4xPLWUOFY8wH8hhzkB4Uq7Ohwg1GW/2H2YaIzVxccY5RHugaKUyMTUwwYv5Nfy0EpWjYni8v71r8lNpv9wyYfJDEvq2FoRNVpOXz3n6M9PTV6mHP4P6mEicORAHrMLzXGyKCJS/twArcVh4YLqQ596vP7C1No38U8tOW1eySuD4ULQZKxAQw5Qnc7OHEIh3SQ/QJksWuVow31CsNdR54W4TN5l8wJ7WnXqm7BKfJzSEu6qV5c2k9r6v3tWs7tXcfKwaohvAENhG31oxEO+a4fvfFwEDsgte+fIXo7zJX5hipP8g3uDWgMYDLrU+JIYkV8DWarAbZJNpS0D8ySpcmFrwK9DL5zh+nY4Jp2xv9gFJtivDOFYXBP+htzxWfFwPdAyI1OLxlh4puVcjuwA2z94i2WR7M4rcxXczVcuWRQnYw+HlipYND46sqKHm9H/lvQf1M+F0s3WWCzKv5EF88nYQa9fHsvn75gQqS90Fclt76Fcmh9HSUAtlZYtGmecFLvRGCKEwJOmYHCjCNquAYTJRb3ByH0gVsj6tSYNAEn7A8R3/GeZ/kvduOkans7LgK3DdECusM8bPgEeBvlZ4l0qmUZedBZ7G6+jQ/5NuuZ93
 qsQVtLlE
 sHOvedoE82wqclqbJL+wnhbYmZHNtwaiAe9mRo0zi0LmVMDts/b/LEAkG5pgkCtMMrVPaVvLnlYNJ2ovEHmwfpaovgukgfDtyxCmCctixyLrkFKsuMdW7Vgu2UKW8Og86Axgd99j9zHB3pzrePGyQRHf0DR8Zd2A3E/1YDCLcLB6MQSGFmUKytBny7Vh1dnph0kPsdc2VT9q0JXigE2Jij91CpXOOVmYRA8gTq5c6/jmo2NbesS8QZrqNFZEi49Ga+2QR7q0p9hvWoqrymCrg+0KJt+N8jd4fkvUAEQOoPcqcYjCVGxbTAxpU1mgZx51mdwbxSacEELTNWUhc4XWGa01QXG+ozaVwPfcQCkZCPwxft2Z6X7xtIvH+O86kQl3CPzInx+NAUWok9EUZZKeQblhhJUADrsViPdtLhOKjDOFrBCZPncd1DevE8knXxqpY4LGrRDbTOv+524aYNGhVc1ZMknl7F0lGZHY7H5wu08YQ8ihR/eA/vDuTGc7yTqc7byicMVwUr+3ahe8YNLqX5uz4jR6oYfj1Fy4r45a04iikFe/S/SJIHxijIXwMCFNUTenPepy2Tq2n1vi4Q1SS85pCkX38/Q2nty8gU7kVS61LQXQT7cqvZUf+V6RLKjZ2HZNBIaPSFxKe1Ta3MiSjfjaamuUz/lh+vAIftWe2Nv73PkEGCxJZiNrFxIpJ2klD4ivnR26RWH7LbasprfPDR7YawTxryv37WQcObWLjaZxd8ColSHL3et0AtMSi4hm5yy1iXDtYTtngIoRX5g017g949jzOvro4M6wS1M/MrHeIOxj3cYQQGTENxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patrick Roy <patrick.roy@linux.dev> writes:

> Hey all,
>
> sorry it took me a while to get back to this, turns out moving
> internationally is move time consuming than I expected.
>
> On Mon, 2025-09-29 at 12:20 +0200, David Hildenbrand wrote:
>> On 27.09.25 09:38, Patrick Roy wrote:
>>> On Fri, 2025-09-26 at 21:09 +0100, David Hildenbrand wrote:
>>>> On 26.09.25 12:53, Will Deacon wrote:
>>>>> On Fri, Sep 26, 2025 at 10:46:15AM +0100, Patrick Roy wrote:
>>>>>> On Thu, 2025-09-25 at 21:13 +0100, David Hildenbrand wrote:
>>>>>>> On 25.09.25 21:59, Dave Hansen wrote:
>>>>>>>> On 9/25/25 12:20, David Hildenbrand wrote:
>>>>>>>>> On 25.09.25 20:27, Dave Hansen wrote:
>>>>>>>>>> On 9/24/25 08:22, Roy, Patrick wrote:
>>>>>>>>>>> Add an option to not perform TLB flushes after direct map manip=
ulations.
>>>>>>>>>>
>>>>>>>>>> I'd really prefer this be left out for now. It's a massive can o=
f worms.
>>>>>>>>>> Let's agree on something that works and has well-defined behavio=
r before
>>>>>>>>>> we go breaking it on purpose.
>>>>>>>>>
>>>>>>>>> May I ask what the big concern here is?
>>>>>>>>
>>>>>>>> It's not a _big_ concern.
>>>>>>>
>>>>>>> Oh, I read "can of worms" and thought there is something seriously =
problematic :)
>>>>>>>
>>>>>>>> I just think we want to start on something
>>>>>>>> like this as simple, secure, and deterministic as possible.
>>>>>>>
>>>>>>> Yes, I agree. And it should be the default. Less secure would have =
to be opt-in and documented thoroughly.
>>>>>>
>>>>>> Yes, I am definitely happy to have the 100% secure behavior be the
>>>>>> default, and the skipping of TLB flushes be an opt-in, with thorough
>>>>>> documentation!
>>>>>>
>>>>>> But I would like to include the "skip tlb flushes" option as part of
>>>>>> this patch series straight away, because as I was alluding to in the
>>>>>> commit message, with TLB flushes this is not usable for Firecracker =
for
>>>>>> performance reasons :(
>>>>>
>>>>> I really don't want that option for arm64. If we're going to bother
>>>>> unmapping from the linear map, we should invalidate the TLB.
>>>>
>>>> Reading "TLB flushes result in a up to 40x elongation of page faults i=
n
>>>> guest_memfd (scaling with the number of CPU cores), or a 5x elongation
>>>> of memory population,", I can understand why one would want that optim=
ization :)
>>>>
>>>> @Patrick, couldn't we use fallocate() to preallocate memory and batch =
the TLB flush within such an operation?
>>>>
>>>> That is, we wouldn't flush after each individual direct-map modificati=
on but after multiple ones part of a single operation like fallocate of a l=
arger range.
>>>>
>>>> Likely wouldn't make all use cases happy.
>>>>
>>>
>>> For Firecracker, we rely a lot on not preallocating _all_ VM memory, an=
d
>>> trying to ensure only the actual "working set" of a VM is faulted in (w=
e
>>> pack a lot more VMs onto a physical host than there is actual physical
>>> memory available). For VMs that are restored from a snapshot, we know
>>> pretty well what memory needs to be faulted in (that's where @Nikita's
>>> write syscall comes in), so there we could try such an optimization. Bu=
t
>>> for everything else we very much rely on the on-demand nature of guest
>>> memory allocation (and hence direct map removal). And even right now,
>>> the long pole performance-wise are these on-demand faults, so really, w=
e
>>> don't want them to become even slower :(
>>=20
>> Makes sense. I guess even without support for large folios one could imp=
lement a kind of "fault" around: for example, on access to one addr, alloca=
te+prepare all pages in the same 2 M chunk, flushing the tlb only once afte=
r adjusting all the direct map entries.
>>=20
>>>
>>> Also, can we really batch multiple TLB flushes as you suggest? Even if
>>> pages are at consecutive indices in guest_memfd, they're not guaranteed
>>> to be continguous physically, e.g. we couldn't just coalesce multiple
>>> TLB flushes into a single TLB flush of a larger range.
>>=20
>> Well, you there is the option on just flushing the complete tlb of cours=
e :) When trying to flush a range you would indeed run into the problem of =
flushing an ever growing range.
>
> In the last guest_memfd upstream call (over a week ago now), we've
> discussed the option of batching and deferring TLB flushes, while
> providing a sort of "deadline" at which a TLB flush will
> deterministically be done.  E.g. guest_memfd would keep a counter of how
> many pages got direct map zapped, and do a flush of a range that
> contains all zapped pages every 512 allocated pages (and to ensure the
> flushes even happen in a timely manner if no allocations happen for a
> long time, also every, say, 5 seconds or something like that). Would
> that work for everyone? I briefly tested the performance of
> batch-flushes with secretmem in QEMU, and its within of 30% of the "no
> TLB flushes at all" solution in a simple benchmark that just memsets
> 2GiB of memory.
>
> I think something like this, together with the batch-flushing at the end
> of fallocate() / write() as David suggested above should work for
> Firecracker.
>
>>> There's probably other things we can try. Backing guest_memfd with
>>> hugepages would reduce the number TLB flushes by 512x (although not all
>>> users of Firecracker at Amazon [can] use hugepages).
>>=20
>> Right.
>>=20
>>>
>>> And I do still wonder if it's possible to have "async TLB flushes" wher=
e
>>> we simply don't wait for the IPI (x86 terminology, not sure what the
>>> mechanism on arm64 is). Looking at
>>> smp_call_function_many_cond()/invlpgb_kernel_range_flush() on x86, it
>>> seems so? Although seems like on ARM it's actually just handled by a
>>> single instruction (TLBI) and not some interprocess communication
>>> thingy. Maybe there's a variant that's faster / better for this usecase=
?
>>=20
>> Right, some architectures (and IIRC also x86 with some extension) are ab=
le to flush remote TLBs without IPIs.
>>=20
>> Doing a quick search, there seems to be some research on async TLB flush=
ing, e.g., [1].
>>=20
>> In the context here, I wonder whether an async TLB flush would be
>> significantly better than not doing an explicit TLB flush: in both
>> cases, it's not really deterministic when the relevant TLB entries
>> will vanish: with the async variant it might happen faster on average
>> I guess.
>
> I actually did end up playing around with this a while ago, and it made
> things slightly better performance wise, but it was still too bad to be
> useful :(
>

Does it help if we add a guest_memfd ioctl that allows userspace to zap
from the direct map to batch TLB flushes?

Could usage be something like:

0. Create guest_memfd with GUEST_MEMFD_FLAG_NO_DIRECT_MAP.
1. write() entire VM memory to guest_memfd.
2. ioctl(guest_memfd, KVM_GUEST_MEMFD_ZAP_DIRECT_MAP, { offset, len })
3. vcpu_run()

This way, we could flush the tlb once for the entire range of { offset,
len } instead of zapping once per fault.

For not-yet-allocated folios, those will get zapped once per fault
though.

Maybe this won't help much if the intention is to allow on-demand
loading of memory, since the demands will come to guest_memfd on a
per-folio basis.

>>=20
>> [1] https://cs.yale.edu/homes/abhishek/kumar-taco20.pdf
>>
>
> Best,=20
> Patrick

