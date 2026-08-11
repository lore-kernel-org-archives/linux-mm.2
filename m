Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4329C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54CF6B0096; Tue, 11 Aug 2026 07:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B066D6B0099; Tue, 11 Aug 2026 07:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD606B009B; Tue, 11 Aug 2026 07:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE356B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:31:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0AAB0803A7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:31:53 +0000 (UTC)
X-FDA: 85088774106.13.1510AA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7127D1A0003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:31:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=om8xJIfj;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4h7/hkwvCsY0fI00T2PR/Y4OZG0mhUElOQ2zn4pF7HM=;
	b=rTLazvlhZKd2iFrsUYxpZsLx02scCI+/pyPLtm2KLdLvVp+IohhCLy5XC/gMLj9wJMmPZB
	BkXpWoXgbpxv6UZ8hNHx9KT7H1XYZ3ubuY3JY6MEU+5v3qst/8XCcjdYKJzsoehB6JtbJK
	YGaaH6ntjrgdY58RA7X2NKwDWSUcCNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786447911;
	b=Ik9rAdaX41FFcb0nI+depx+8eZOuBWr1CSuT197fFqSt88bvdkiB+4VEVp7CzRNrNtKf4L
	JMGAzROiNABfEEIwdgpa3xuTMwF13M6IAuCbap5Ky42RpGprc5r/4ScUNgUxKFjaaxBBQb
	Mq43y9N+Nr2iAtqAQTdPHppmpLHqdoA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=om8xJIfj;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C38CD600AD;
	Tue, 11 Aug 2026 11:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A141F000E9;
	Tue, 11 Aug 2026 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786447910;
	bh=4h7/hkwvCsY0fI00T2PR/Y4OZG0mhUElOQ2zn4pF7HM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=om8xJIfjsRUCvKibHk4AB92a86v/0sm2xMl+BtSmgoyg7QzhmHmd3v9z3YvwkioCW
	 9u/nZK6wJXKOBRJSadI/b5pqpyXdCXcN7dsJ9BaeaAZz90F1BIBA4twS1gV3wuBHJO
	 mJtZngYdB7FxDju+zrnYNhjNPFjwE8vD9dfqPU/3VUsDjvBzcsgX4U7GyWO21QietQ
	 +uDGaQz1ywUPS27qK7TYb35Ab1PJEijr+OqHQQPgoG/BBG0vdmmBqVwPLY/LGZtoQR
	 7NrPUAPpNv5bhHusvIMbXZwA2gJ2vJg4PJ/zmo8j6qYfhy4KZUMw6mp3S6iqu2krU4
	 1EuINsbUcsIhg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>,  ackerleytng@google.com,
  fuad.tabba@linux.dev,  Andrew Morton <akpm@linux-foundation.org>,
  dmatlack@google.com,  Shuah Khan <skhan@linuxfoundation.org>,  Jonathan
 Corbet <corbet@lwn.net>,  david@redhat.com,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  sagis@google.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike Rapoport
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  linux-kselftest@vger.kernel.org,  andre.przywara@arm.com,
  michael.roth@amd.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  will@kernel.org,  vannapurve@google.com,  maz@kernel.org,
  fvdl@google.com,  kvm@vger.kernel.org,  oliver.upton@linux.dev,
  kvmarm@lists.linux.dev,  alexandru.elisei@arm.com,  skhawaja@google.com,
  aneesh.kumar@kernel.org,  linux-doc@vger.kernel.org,  David Hildenbrand
 <david@kernel.org>,  yan.y.zhao@intel.com,  kexec@lists.infradead.org,
  suzuki.poulose@arm.com
Subject: Re: [PATCH v4 05/11] KVM: LUO: Support VM preservation across live
 updates
In-Reply-To: <anphyjFv3FhF61iB@google.com> (Sean Christopherson's message of
	"Mon, 10 Aug 2026 16:42:02 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-6-tarunsahu@google.com>
	<anphyjFv3FhF61iB@google.com>
Date: Tue, 11 Aug 2026 13:31:43 +0200
Message-ID: <2vxzpkzo51wg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7127D1A0003
X-Stat-Signature: zkszph7g8ayt6w6gxbt5iukigcqn9mjf
X-Rspam-User: 
X-HE-Tag: 1786447911-963128
X-HE-Meta: U2FsdGVkX18Lxr1eT8N+CsWY3eJ30pnSAL4T1MeDfQ6ugCaQRU5R3FKNtzD0ze+RMzYuKm5hvOLTznN9HrXHuWoAxfygzcELpnJcKo8bLM9LEF+OBmkY982+DCD0CF1qc2WDY0xkSVSgJuVbFmJRaufV1jvooGnGEb+fyTBeU0x3dhNeXBVysL24hezzmXB30G1Qi4kCDloQu1L2IUKYFbsCcfPlD9b//OTiAkrwQfZNnB2kjXrVe0y7v/IFw/k/1Tqq7Lo5DajlKSktOpcXURcbev8bBKWK/+NlqtvrPS2/Cz/IiaVWXAOEzYWKorwvXPSjwoOjqv8z19o+cSuxjRfUQ8I1CVnwq9rHlqT3Hq8llP7XQnqJxC7mRBJyZESoevQh2HLA6xq/5YGj9dW4x6HoUd16jshAduCxZ0VfmtFw0bXjO/J4pqAEoWutPxpgvXFNYYP5hIF5jskrHvJ56Pr3WAnCPFRF/YMPiMBnhFAgwR9CuXRg0MHJt55xwEuhOMRwmf4z/TYhVLvHJ2ZiiplpxHGaKuYBaFzKFoGtfkT0EnYwVx/X5xFEfC0jzrE57MsR4+ga3ueKbUba3KIe5pGlv8ED6Cx9eL/BgTS9wuLZ8YGh4Tzn8/fRzXtwMuDlaB2Qp5+2fsYqnXensdb4sQ+XA0UNt2SORDwCYQpJKWS6OqnXjISdNxiGCah7wzDfyrTaoxmE6OvMBmsDdtKYXsJsG9PdH7+NMQoxlQEx1bHuJDJ3s9YNAlwlNOeaFurC+myULr6Y496RgabylOYv0JX4GhFO3xzHFN5+11KYFzrbJK4uMQ2DvDLnhJW3IGgwQPxz6kxsdb1I1y1i8ft5+Gf2iflmV1c6FkkdRgeYwQIV0z1/3rPF+AnNAP8wau458Q+/uFxvLxsBZDuh16cRQiHaAN7BlbOvJYhoOXQ6Uj4Jtu0nCntczdG/xwgXf0AcZJkUyt9dkupdiNqeyMP
 0hXgADVZ
 2Rs/dvUY+8etgqNqKfCUxfIggGRN6ksQrujnKjG4HlRrUIsBuYwk/WydeVu9R0aBWOxGSj/6FPBEEQ1llJybZbzS3u3u6M2f7pEein241sx6AccIhyo/WGIZisr0WD3bluQcKQ4EwJsdH+JAJqMKfCmccIxffpL3R8B3R0MJ/FAZNCxpGe95rkwDOTrDo2fwFVVPzoI5coQ6BJUOwUNMNi9Gkom1AHTdVPY1jJMVVUVobdFU81bbQHQH+QIr32QOZBI3ng4IWPtlngboKQKw91GYFQwFbSJyiawlyBWvb49fPPLYp9hW/qlOfvDvLcP/KrFkagrW0wBtg1jL7fZQt1N4gzDUihvRhMFfS1iMgVFbWt9i82odXlZcEMMSk4MZTaaGARppLcpGWkwefzE0ZD3aSZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10 2026, Sean Christopherson wrote:

> On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> Register a Live Update Orchestrator (LUO) file handler for KVM VM files
>> to serialize and deserialize VM state across kexec live updates.
>> 
>> Currently, Only VM type (e.g. arch.vm_type on x86) is preserved as part
>> of VM preservation.
>
> Why?
>
>> On retrieval, kvm_luo_retrieve() recreates the KVM VM file via
>> kvm_create_vm_file() and use an atomically incremented ID for the internal
>> fdname, as the final fdname assigned by userspace is not yet known during
>> retrieval. As this fdname is only used in debugfs infra, This will not break
>> any UAPI.
>> 
>> This infrastructure establishes the foundation for preserving guest_memfd
>> instances across live updates, and can be expanded in the future to
>> preserve additional VM state.
>
> Uh, why guest_memfd?  As much as I want to push guest_memfd adoption, it seems
> guest_memfd should be the _last_ thing we support, not the first.  As evidenced
> by the last two decades, it's very doable to have KVM VMs without guest_memfd,
> but it's rather hard to have VMs without vCPUs.

You _can_ preserve vCPUs today using KVM_{GET,SET}_REGS, they just won't
run in the background during the reboot. This series can save you from
dumping VM memory to disk if it is backed by guest_memfd.

>
>> Also updates MAINTAINERS to include virt/kvm/kvm_luo.c and
>> include/linux/kho/abi/kvm.h.
>> 
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  MAINTAINERS                 |  11 ++
>>  include/linux/kho/abi/kvm.h |  39 ++++++++
>>  virt/kvm/Makefile.kvm       |   1 +
>>  virt/kvm/kvm_luo.c          | 195 ++++++++++++++++++++++++++++++++++++
>>  virt/kvm/kvm_main.c         |   8 ++
>>  virt/kvm/kvm_mm.h           |   8 ++
>>  6 files changed, 262 insertions(+)
>>  create mode 100644 include/linux/kho/abi/kvm.h
>>  create mode 100644 virt/kvm/kvm_luo.c
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index a3ed337e827d..0283f0fd6ef4 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -14539,6 +14539,17 @@ S:	Maintained
>>  F:	Documentation/devicetree/bindings/leds/backlight/kinetic,ktz8866.yaml
>>  F:	drivers/video/backlight/ktz8866.c
>>  
>> +KVM LIVE UPDATE
>> +M:	Pasha Tatashin <pasha.tatashin@soleen.com>
>> +M:	Mike Rapoport <rppt@kernel.org>
>> +M:	Pratyush Yadav <pratyush@kernel.org>
>> +R:	Tarun Sahu <tarunsahu@google.com>
>> +L:	kexec@lists.infradead.org
>> +L:	kvm@vger.kernel.org
>> +S:	Maintained
>> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>
> NAK on taking changes through a different tree.  This is KVM code, period.
>
> In general, I'm skeptical of the dedicated MAINTAINERS entry.  It's extremely
> difficult to tell since this series is little more than a skeleton (either that
> or liveupdate is way simpler that I was expecting), but I suspect that maintaining

It's a bit of both. This series of course doesn't support everything
that guest_memfd can. At the same time, I also keep being (pleasantly)
surprised at preservation being relatively simple. For example, the code
to preserve a shmem file (via memfd) is roughly 600 lines, a big chunk
of which is comments. The code of course has some limitations, but it is
good enough for use in production.

> liveupdate for KVM (or for any subsystem) will require more subsystem-specific
> knowledge than liveupdate knowledge.
>
> E.g. the LUO APIs seem pretty straightforward; I assume the bulk of the complexity
> is going to be in knowing what to save/restore, and how, which is much more about
> KVM than it is about liveupdate.

I think it is fine if you want to take these changes through the KVM
tree, but I would like live update maintainers to be listed as reviewers
at least.

For one, we care about ABI breakages and versioning. The serialized
state is a part of live update ABI and changes to it should be ACKed by
us. For another, how the file handlers interact with their dependencies
can affect the behaviour that VMMs observe. Those changes should also
pass by some live update eyes.

So I think we should have a separate entry for KVM LIVE UPDATE that
lists the live update maintainers (or perhaps only kexec@) as a
reviewer. The patches can still flow through KVM tree but we'd get a
chance to ACK/NACK them.

Of course this all can evolve later as we see fit but I think this is a
good starting point.

>
>> +F:	virt/kvm/kvm_luo.c
>> +
>>  KVM PARAVIRT (KVM/paravirt)
>>  M:	Paolo Bonzini <pbonzini@redhat.com>
>>  R:	Vitaly Kuznetsov <vkuznets@redhat.com>
[...]

-- 
Regards,
Pratyush Yadav

