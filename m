Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0913ECFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 11:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E14086B0032; Tue,  2 Dec 2025 06:51:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5586B0062; Tue,  2 Dec 2025 06:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3796B007B; Tue,  2 Dec 2025 06:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B64936B0032
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 06:51:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1197132BBE
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:51:05 +0000 (UTC)
X-FDA: 84174364890.10.05B8D6D
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf15.hostedemail.com (Postfix) with ESMTP id 82AF2A0006
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:51:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nhdlQaBp;
	spf=pass (imf15.hostedemail.com: domain of "prvs=4244c82db=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=4244c82db=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764676263;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFJG4v1V23XNGxr101Iy6bR88wmMiiVy8jZ4JavjKdg=;
	b=VjlCrH6O+ulR8dl3SnC9iu4e5vxECjJGCazsEevqhcH8NsXwPnc+PuVHjtfzcerdG+5KM7
	ulXauqqQwSg8K8tTkgS3QN2xtUO2q6YE+3un3ElO3nNZV/yrjQXhoWZVYkr1sj6EKmjH0n
	XtMny99hMiRK/2voUp5fin8t4XHVZqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764676263; a=rsa-sha256;
	cv=none;
	b=HJofDAmIWLuVCeaBO5CBz3AV1T0eNERxyvTGsre/Jygp0KkpzP5E6iWT7c6GU2lszK2LGO
	bS3EPSwusP1+5wfjIczWcd84t+tVqmDIQ6Yfr4yPKWg44UuiEIQY1dNIm9y+Mj1s+rzQim
	msEKhBpnLEx78gMFBM36hpyuQRnw9KU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nhdlQaBp;
	spf=pass (imf15.hostedemail.com: domain of "prvs=4244c82db=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=4244c82db=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764676263; x=1796212263;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=KFJG4v1V23XNGxr101Iy6bR88wmMiiVy8jZ4JavjKdg=;
  b=nhdlQaBpT2dFYGJG2WMteDhY4Cbn4XV8qtLcg6767klaSyiB5cPzQOQ/
   bc9WyGJ4bM/jHi6KxfgbkyZIcVO0cPdI9Q7TsvbaDBpH565A8XlDVxpXY
   C9TB4kD08eORLbhd0na0QSY2a/LqXtKMTZlu3s6r6+Dn+T9OPaOJUE9/y
   lRHdp9BvvHgpXn2Xs40CUXbiU3D6G0q5zwbuSSzfLTFp6holaMPrw2Qpp
   BOH9ZK/GUcgqySkAQsbNoNUAeaMlJW0ppB6PfmSpFkFOQIE/T8p1QDS56
   ARBr2HYRUN2AIfINNXXEC1QA+031ZTRvEJ1vpkYpGyaEvqubxh4/MK8uz
   Q==;
X-CSE-ConnectionGUID: ZfUcYgzQQUuMfJ3SHdBYRg==
X-CSE-MsgGUID: vFh6YIAsTW6Teg9ZRJZHPA==
X-IronPort-AV: E=Sophos;i="6.20,242,1758585600"; 
   d="scan'208";a="6004691"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 11:50:45 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:1507]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.168:2525] with esmtp (Farcaster)
 id 8ae9055c-a10c-49bd-84a1-a1fa87042f96; Tue, 2 Dec 2025 11:50:45 +0000 (UTC)
X-Farcaster-Flow-ID: 8ae9055c-a10c-49bd-84a1-a1fa87042f96
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 2 Dec 2025 11:50:37 +0000
Received: from [192.168.12.25] (10.106.83.17) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Tue, 2 Dec 2025
 11:50:36 +0000
Message-ID: <415a5956-1dec-4f10-be36-85f6d4d8f4b4@amazon.com>
Date: Tue, 2 Dec 2025 11:50:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v3 4/5] guest_memfd: add support for userfaultfd minor
 mode
To: Peter Xu <peterx@redhat.com>
CC: "David Hildenbrand (Red Hat)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, "James
 Houghton" <jthoughton@google.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20251130111812.699259-1-rppt@kernel.org>
 <20251130111812.699259-5-rppt@kernel.org>
 <652578cc-eeff-4996-8c80-e26682a57e6d@amazon.com>
 <2d98c597-0789-4251-843d-bfe36de25bd2@kernel.org>
 <553c64e8-d224-4764-9057-84289257cac9@amazon.com> <aS3f_PlxWLb-6NmR@x1.local>
 <76e3d5bf-df73-4293-84f6-0d6ddabd0fd7@amazon.com> <aS4BVC42JiUT51rS@x1.local>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <aS4BVC42JiUT51rS@x1.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.17]
X-ClientProxiedBy: EX19D015EUA002.ant.amazon.com (10.252.50.219) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 82AF2A0006
X-Stat-Signature: mb5yaa4h6uk3ydy6y6g986qkppryh633
X-Rspam-User: 
X-HE-Tag: 1764676263-829897
X-HE-Meta: U2FsdGVkX19ErlJm2SpynQSngTdexFTbU26aoGgYCPh+wu78bMKeT4y1eFOAWnBwhhWMf2+aFfUpP9DGI2WHLllAKz52LmfW/kIkMY/ISRpEQgjFiyd8efD+nWtncv1DZReP6DJ7ZOXc6P6496gmyc+Uw9HLBkDKy3SbtLQycIZqw8+glKtOQZqFbWfczZwv406djhZwXo/whuOEIsRQn+BATg5zs5PmCepnXVqErHZsyxK2nbbvdtBYtFUbHgNdiVvp94eG0bCHM3bvSwGSdh0LCwySFki9p+ZUN+RWReyk0kh4eEWTOR5lw5D4y/LAZ+piEDdDr+eFCX2QiUjFw718TZejC0SQnGgo6koB6ArV2jPYvaifVAC1yK5hfzsTP2bk/z5rqe4N1Xw3NWTUG8A7BViKx9DbHDvPXc8S9vsX7yJATUBFJse2ZHd3ixpkpPaOE9Ro/d9ZMvgxrMV9hpeEhBgpdnViCYK1G1JYsyWA7L24w6o56hIAXHZqZ9DKcOq+fF5lOkmuOVrlzAI1L4wFpzO1PL823KMgA6hfPz8C82gzTqvkhyXcoyiixTX418oaS8GOk0Ula2QIBCLqyJoEO0SkWakhCVAGHxj+Cw/YRsz/fn5+vBkHs4SSXJtiBmHN3PKAvRjNByxPkAVsY6m4S1/CXzK1cBKsN7I2qjCAVTP/HrJIoXt/R340g8bQF6MJ5HBQDhrAADm/IvZjfNpczNnp1D97rQeaWUMrC3NGqk7j9JH6fWfede5KdKRUO6cd4Fpi6Z6fmYtMup8bjQOBzmIIZlmqf6s0IpnRSy7ihvLzL3yTJSqsp8Rg70PU7PtzkSemXLI2fGdbRKslhEypIonrVGScEEpTU0YOfbYgbr2zkll/UvbnI2Rpq9UbqFh4+7oY1Jt6Nr2+IEIAFgev2x6xDKQ/voHY9J0Ymp4Moa2xto123Z1RqMVHlP8BEH1DSI6wY/MLYHzmiHC
 lL2kEHFU
 iWte2qb4lZgAKU4UUC/qoYIL+R6lcbIgWbiWiqrCE+TNWiKyi0Xix6I6cuWrGVZFdRbpsUi3Z8IiX2NXw6Qm7B5/lbUsH11EixcDZlJ8pkBD0O3nsTAYcLihky5Gju3aa9zIayQinJLORK+nnOuSkp+37XBBT2wLsAJUia+wh9+zwFaTPAZasNaFUnZbR901CWsilsrEfgwVxQTS/93crEVIeGSxVU9YoX6mrNrhFNiz0OtySGz6vxTSclr66tPiSC6BGJnaQSnN9xaxkTDc9OFwkJNocEzYMKChIf0U4azSxEOEjiC+GmRqHEqiB1/r5nhPUERLycuWotq4qWse4fDM1LBnrlz8UgFAWCM8/vsFq11H2+An39sd3mGPP+ckBunBPx4yWIK4l7/mHWXpmTAMjd7xxbrsO7dXniMHoZEZUaySTvQtRsmKCgpvUSgCP1Fjbv7KBINcddkCshOdji14La5m4pZQNnhbxiLAWGNjfVItI6SwLUFMd5MYP6pVKCSDx8fMh4K6eTy28Z80LDmoa4KJV0BOjF9qManUtEGZtZtN0q0g2qe3/UOOpXC9aRDGIUSWWywk4nxOLY5Z3LSYrsCLeyRf3bmwMhZ2NhIQ/gG9g4tdQW0H2wSkVuHz876GjiFBHYjH7NeHlgKXuWHmt2uwmk7tA2ReRcd2idY2/Ci2N70AV4YNj2kHh4PcElt0mQZI+gU5OfNXRniSzxZrgzNZLcHVBl8IVwrXmIfqlSbMCASRSgbUEWejf4H6VxQK3gb9E3t1Eg68Hk/DHG+47fX1IZ6IzjGdPpVqcFpigRZsEYBx4s1BbEi6uMwKvgHNiiJF2OzCR4+xmbkiibpHXeXiEe63T3kru57ImajYC7Zp1U5e8nGtJXNBlUnq7ZQagqkeS8neBWzoFPUEKtWo/SQr8Lc6AVH7eYYobAbY2oIgLJzkQkJDizyZZ1BuDO7+X0KGwLhfhv6uOl4zxQURYvjSZ
 usWCKer2
 ol9HXjzgBsK/MFSNMJ8oHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/12/2025 20:57, Peter Xu wrote:
> On Mon, Dec 01, 2025 at 08:12:38PM +0000, Nikita Kalyazin wrote:
>>
>>
>> On 01/12/2025 18:35, Peter Xu wrote:
>>> On Mon, Dec 01, 2025 at 04:48:22PM +0000, Nikita Kalyazin wrote:
>>>> I believe I found the precise point where we convinced ourselves that minor
>>>> support was sufficient: [1].  If at this moment we don't find that reasoning
>>>> valid anymore, then indeed implementing missing is the only option.
>>>>
>>>> [1] https://lore.kernel.org/kvm/Z9GsIDVYWoV8d8-C@x1.local
>>>
>>> Now after I re-read the discussion, I may have made a wrong statement
>>> there, sorry.  I could have got slightly confused on when the write()
>>> syscall can be involved.
>>>
>>> I agree if you want to get an event when cache missed with the current uffd
>>> definitions and when pre-population is forbidden, then MISSING trap is
>>> required.  That is, with/without the need of UFFDIO_COPY being available.
>>>
>>> Do I understand it right that UFFDIO_COPY is not allowed in your case, but
>>> only write()?
>>
>> No, UFFDIO_COPY would work perfectly fine.  We will still use write()
>> whenever we resolve stage-2 faults as they aren't visible to UFFD.  When a
>> userfault occurs at an offset that already has a page in the cache, we will
>> have to keep using UFFDIO_CONTINUE so it looks like both will be required:
>>
>>   - user mapping major fault -> UFFDIO_COPY (fills the cache and sets up
>> userspace PT)
>>   - user mapping minor fault -> UFFDIO_CONTINUE (only sets up userspace PT)
>>   - stage-2 fault -> write() (only fills the cache)
> 
> Is stage-2 fault about KVM_MEMORY_EXIT_FLAG_USERFAULT, per James's series?

Yes, that's the one ([1]).

[1] 
https://lore.kernel.org/kvm/20250618042424.330664-1-jthoughton@google.com

> 
> It looks fine indeed, but it looks slightly weird then, as you'll have two
> ways to populate the page cache.  Logically here atomicity is indeed not
> needed when you trap both MISSING + MINOR.

I reran the test based on the UFFDIO_COPY prototype I had using your 
series [2], and UFFDIO_COPY is slower than write() to populate 512 MiB: 
237 vs 202 ms (+17%).  Even though UFFDIO_COPY alone is functionally 
sufficient, I would prefer to have an option to use write() where 
possible and only falling back to UFFDIO_COPY for userspace faults to 
have better performance.

[2] 
https://lore.kernel.org/all/7666ee96-6f09-4dc1-8cb2-002a2d2a29cf@amazon.com

> 
>>
>>>
>>> One way that might work this around, is introducing a new UFFD_FEATURE bit
>>> allowing the MINOR registration to trap all pgtable faults, which will
>>> change the MINOR fault semantics.
>>
>> This would equally work for us.  I suppose this MINOR+MAJOR semantics would
>> be more intrusive from the API point of view though.
> 
> Yes it is, it's just that I don't know whether it'll be harder when you
> want to completely support UFFDIO_COPY here, per previous discussions.
> 
> After a 2nd thought, such UFFD_FEATURE is probably not a good design,
> because it essentially means that feature bit will functionally overlap
> with what MISSING trap was trying to do, however duplicating that concept
> in a VMA that was registered as MINOR only.
> 
> Maybe it's possible instead if we allow a module to support MISSING trap,
> but without supporting UFFDIO_COPY ioctl.
> 
> That is, the MISSING events will be properly generated if MISSING traps are
> supported, however the module needs to provide its own way to resolve it if
> UFFDIO_COPY ioctl isn't available.  Gmem is fine in this case as long as
> it'll always be registered with both MISSING+MINOR traps, then resolving
> using write()s would work.

Yes, this would also work for me.  This is almost how it was 
(accidentally) working until this version of the patches.  If this is a 
lighter undertaking compared to implementing UFFDIO_COPY, I'd be happy 
with it too.

> 
> Such would be possible when with something like my v3 previously:
> 
> https://lore.kernel.org/all/20250926211650.525109-1-peterx@redhat.com/#t
> 
> Then gmem needs to declare VM_UFFD_MISSING + VM_UFFD_MINOR in
> uffd_features, but _UFFDIO_CONTINUE only (without _UFFDIO_COPY) in
> uffd_ioctls.
> 
> Since Mike already took this series over, I'll leave that to you all to
> decide.

Thanks for you input, Peter.

> 
> --
> Peter Xu
> 


