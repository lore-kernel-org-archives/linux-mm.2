Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296BCC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9B86B008A; Wed,  9 Sep 2026 19:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BE66B008C; Wed,  9 Sep 2026 19:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB556B0092; Wed,  9 Sep 2026 19:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB2E56B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:23:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0BCC160397
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:23:11 +0000 (UTC)
X-FDA: 85195801782.07.8596F17
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE34A100006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:23:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BadEUA6T;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788996189;
	b=xE46c/jPyO5+2CZY0oOUNjaS9UJWWYFKf3fR/fGqUfsAYNkr0vmVChyi2afAV2rIC+iGaD
	9458wK3Mcha3GP866pvS3Oqd6MWMCB2kY4gFu55X12lhp9/BHT40kzbQ733L2/IeQrgX3d
	AagM2l6XrWmwyqP92tDF73QP61DPfyM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BadEUA6T;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788996189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=En5tOZVEsf8OKBtyg5CL4cfCdUXCngpBo9ElWnq0faE=;
	b=BPtiV0j2RcZBXgAbG4ARQjGJRPm53wVSv6sJQG1O4oNfYsvmNn/wv94ZDuot6WDi39nMBo
	XVY+hcc/qXCc5QjZnStzrxbdf3njyV/wY+Ta1s/ltFbzOfaEpD+DtslP5bnaxFr2ecfpVz
	sN2hy+kgI4xih6Q40ck32tLacPbKSGY=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910ca5aa7so93709785a.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 16:23:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788996189; cv=none;
        d=google.com; s=arc-20260327;
        b=l3B9G/c4Co9oknP3PM1DbmdggZQ561JLwCH2PUi95ZV2AXplggj+MWG6OBeM+lDFSX
         hX37x2+UZ/mh8hMYVIxC46luRYvLvsSYvYHRaKPfStnNC34Yv1XKTPTuVCevAdzLqW+K
         wKtc+pPUUgTlYKtjavRpIgUfQNl8HXqmrSLRcf1VxDchVy7qQv7o717A3BEb1ESTtGGs
         FRS0HXWq5veRNDVo9T5tmjHUXdOguo5NEswXCkDcKvKfQQ6M14AAah1PqNMYADjxwayx
         Ua90Z8rifNRwU+Lv3LPkMqanFeIYVPrUFnCQ2KedbGhlG05I3A5sqjI/7H0Y2uSjKIbl
         TjZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=En5tOZVEsf8OKBtyg5CL4cfCdUXCngpBo9ElWnq0faE=;
        fh=mBXKjdB16nq+Mp8kkoWyODipc/oR9amTNAMvcY4MG7k=;
        b=rZ7xG5XPfRAr3cIKItXbta50WSgDtEocjgmGGoC1f7A1T0+1o2/8E9Ir4sYWkJouBy
         82Wfgd5bWOm4whvxuJFI8CMi28oHGQZOSG8t+aDldEVpDyQrPWSoxbSn+HS8+IpID0SO
         7VqGcMnOlqKV05fcoM3t1ghusNKYBQc7dAnb4PDbQNeYoS4fD0Btd7I9MfNG+Sf21fKA
         eo2zolkau47H+pVFWoP71/8oCygHAy1NaIhqP3OwjUyujvdZG6naLooFBv3MjGDjsn5p
         qsppFSYK9H7fq0iQjHgN1+6hcBlmpXFhdnRjIF09LXhwSq1QoEjP7DBrmYA8njlJBjjU
         m1kA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788996189; x=1789600989; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=En5tOZVEsf8OKBtyg5CL4cfCdUXCngpBo9ElWnq0faE=;
        b=BadEUA6TIyBCwu0jLm4/NOZQD8j7+doxiVVtuDz417AJ+foX+gwVaP8WyXSc1bfSAl
         Phmu5oaAbFzKYewa2lCHMSZCY+QyRfzymGFOg3p3fmEIC42j7DnvFV2j527iexHUCnRI
         PrWf/sahBXwaLAKDmONKJkIPYHwFq9h6ccLgmfWLsbwf+oKxB9YY26P2ti/H+dtG4ZD3
         L6e871suddUhYFxgmvusXqvmRTWD+feOB2E9hlNMwQzZpOAOj3BqKj42xTlOCVKF/p3m
         SHD6z56F4xx7FrqZTozAmX8MNWKGQZZS2HVp8v1chcxjiqwKXqEeVnyFGJtKS6h2ewO2
         mFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788996189; x=1789600989;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=En5tOZVEsf8OKBtyg5CL4cfCdUXCngpBo9ElWnq0faE=;
        b=dClh40GTgvcVn0aX/xSjFgBJrtqsiWD0EZuf7ITvMTLxUtLq1Cm1i5AzEGVju4k459
         C489pxAGVGsszQzSR+TE6QUB2ATEdSO7byH9HH0ye1P/7vDnzgU5UuaRiTPsnGmt+2Ti
         M27JfIpPhB+debyYuaI1y6I/cfGEK7JgByUAzBcJrfBszAWavLzgOxJ1loOLLUjSGYKK
         h3eZFSGMTOmXOaxscXsV6k9jlMtahxrgwgM2QgFkcO+EoXKSfIEyFQxNAB3++gk3ArLq
         AhuxmmaSJsFkpwfH2lIv5EftfjNVG/YXsJJmYuNib8KnDGuJzg+Y1X9uTS9gaPKm30IO
         EOLg==
X-Gm-Message-State: AFuF++kN3284V/icPR/O/nW2+h/lVmrNi/KVyIvOywKWy9xBU9aBPi9w
	IZE8Wepz1IAh37pMxecYi2x/pbfouWbewTrimkVMZhc+xafZRd4RZ77x5kOiRZcrSoecvzaHUks
	8W/1coQ/aNCUZ0IyDkaXaaDddbxNOFawfwZ+7vke/
X-Gm-Gg: AYBFou1yZt9Vpmuu/xq0UeVJrp6Xme2c3VxM3W6qEV+howc1DzeCY5IX8ZU7366lAGj
	U6s4yLCAtypGuzR5YclzPYe0Z5rL1l/lMGXCd1NKw93mt16LE3NXz9WSMoq+LfZHyuRATfLSwcj
	tCNgcECdfeTI9HvCmEGEtH8CdaSc9C/fs58vQANN5dNB0oHLsMQn3r0r8C/L8y1k4KwvX77j3jn
	reS8aE8FKeL7g/vJZLKfFvzcLYYbrtumGlDHI3l00cl8MQnxg+5g8MkN6+wdC+FPBRQ18B2Fksy
	TCk3+jm1hPB12aZbAJEB7fAw66P9ln5wuCDzws0pFQWMpRtTtSyrDzk8WgRqQSfsAMO3kuPlKD8
	VhNQmdoqvmGIuhBOU3Zff69SSVcnvSa2Vrm8gehsv
X-Received: by 2002:a05:620a:d8e:b0:936:cd76:4d4b with SMTP id
 af79cd13be357-939d4a8e082mr635316885a.42.1788996188016; Wed, 09 Sep 2026
 16:23:08 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 16:23:07 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Sep 2026 16:23:07 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <aqHkVKvons1tBs1O@gourry-fedora-PF4VCD3F>
References: <20260902194657.79075-1-gourry@gourry.net> <CAEvNRgHWyBaBpZ4Bem1Eu86b-cuEA7NkyjxTJ4D3FnpGe1B2Yg@mail.gmail.com>
 <aqHkVKvons1tBs1O@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Date: Wed, 9 Sep 2026 16:23:07 -0700
X-Gm-Features: AcwNN1XfBb1QvPKkl28AJUF1eJlFWixEPhPOQhdktuRR8-1JWKzX4sglljv8C4I
Message-ID: <CAEvNRgGAQj1afTRRO+DpVTaSCTZic3K_x6ZfwvBLUbfara5v=A@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, pbonzini@redhat.com, 
	seanjc@google.com, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE34A100006
X-Stat-Signature: s9iocki33xm5749siy9xidprhd4r7tkk
X-Rspam-User: 
X-HE-Tag: 1788996189-896664
X-HE-Meta: U2FsdGVkX1+u5gN1i0F0q2WGgkDU/qEfXh5YhLRNXpjGPQUsT6QJuctWGsuzsQjyHNhV13UPMeMQvAtDVHPDITlecqCJXHw7zocLGGve0d9OxUvVWw3u5FbkY9lDvnpCMGb/bKR9kmHmomGbFqngXniTNTKtUkj6+c/El7UUv3mofhvXhkO7sPrSw2P6cC80cegtLPV6VHjnQndWPFX+iyr8Bw+/MdJjQUAS8AqLzm6M8WpJG7ThrUUjoMAi9PAY7KQxFmJSdybiT4z6UFvsVTUDtNjU2Y55Vji3S4GuU8r/BC8ck3S4CTLuOeOzPA0CXWoJ1ct5sjLEcjCCl0voItbyZl3SvNC4Dmu3xFVSCL5iWsycwtSjVm5lJoK8AGRWpSDMzedg1JFmukhGN8lLGSCYDqLPNq4lseQ5ITJLtp661A1yBZgbdrNWOgSulXk2Asdr0BMFrhQYF2XHvE0exbJezotB+Wj5lFlT2j7r2VRVXOfSSn8hCcxcVh1uHcxY8ZJlmBHrye+K+Mo+m4lIe6qpk53W/1DFZZB0EoJhCB6GKGzab0aeYqZPzP9gbiTWFQMqMjOgtup+jH9qkexLArQRzmJs/NCzWHT+A8ruqnyzpATW7FSeHYoLQCskUhYuq2po5P/eKilJYl3Ls0qkTFP4ZeSh35BWStmWvsYB9MPYN1UCL3fhrqKODBVS+TrBY2onIIPYEmgNX7D1tO8etiNHqxmGn9TZmgG1mLWwW0YhBSZtSzPUHs3R9qUf7XFPoVzsyi9OEv/Ac5TIPox/kvnuS33jhn83iCHhk2eefFRFPRRx4LnVq6hO8BkP7N4ZAyWcVvkcgplLo1h8KQXzDkrr/GneT2XH94Vp7bwBDtCNLWDi1Lo8L55tUuAZZvsi7oQGcORo3PIm/3mGKzcXuunO/4CsV5AMLjo4Cwq/OvXcimHv/o9+oMC5cxjEdUQdtUaiMcg3WOGlVswaHdo
 zYq0jDF/
 yVhw30apT3ZrsWEhAPP5lHei4aybfw7vN8UW1bxDj5laUaFbiOho6XrjF2B5LiTVOPLSG9HR6vKL1G8VY6GcQeD7ufMIw+VPdBWoS++irKQ1SPRRpD2Z9NO/61SPDv75DI2Ej+vYeBlXMKZfOg98X/SAWJxbZ67JF8Jhh6XRQUh2dO14h1GjXzsuu9yvgM/ZiXkdSs6ArWWU7dewE1DuYJGEpgZJlyXQL7Nu2kuqkNUw6AlJxUozxyvcw4V9R0XuwIpn8qUGEhppXnNWK6iX0Nl9KGzNcQxT/TPetDelAPGkafSOZ8kuoLU3qordRyaA8ndHejVdNc4u6fpPRIziicHwCK0qPYhOSZRwB39ZfvoBPLfBiszSLbJGh3Y+yv0NgcNi/oVLBesPIoCyi1DsX2uXha4At9/KTqfW1jL/lA519cAwmKl40GHAHbKshdhiTZAch4FoDnABXI9ran6boNzWLgKpWhO9C0gFV9D8brYFd9+cRxsdWpZBKJ7EQMC/v1BJCOhUXfb4MHls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> On Wed, Sep 09, 2026 at 03:41:35PM -0700, Ackerley Tng wrote:
>> Gregory Price <gourry@gourry.net> writes:
>>
>> > guest_memfd allocates its folios through a per-inode shared mempolicy.
>> >
>> > Today that policy can only be set after the fact, with mbind() on a host
>> > mmap of the fd. That requires the fd to be mappable, and it cannot reach
>> > folios that are only ever guest-faulted. Neither holds for a
>> > non-mappable (confidential) guest_memfd.
>> >
>> > Add GUEST_MEMFD_FLAG_BIND_NODE and a node field to struct
>> > kvm_create_guest_memfd. When set, KVM builds an MPOL_BIND policy for the
>> > requested node and installs it over the whole inode, so every folio is
>> > allocated there with no userspace mbind().
>> >
>>
>> Instead of a custom API to ensure all guest_memfd allocations come from
>> a single node, how about these options?
>>
>> 1. Using cgroups/cpuset to constrain allocations (could be troublesome
>>    if the guest memory is not preallocated, unless the vCPU threads are
>>    running with the cpuset config)
>>
>> 2. Process-level NUMA policy
>>
>
> for 1 and 2:
>
> the intent is to put the guest memory on the target node, not all system
> memory for a given process.  so the scope here is not the same.
>
> in fact at that granularity, the desired node may not even have eligible
> memory to host the task's memory.
>

We have a similar problem where we wanted only guest memory to be
charged a certain memcg. Currently guest_memfd memory is charge to
mm->owner, which is the thread's parent, so doing the fallocate() in a
thread wasn't good enough. The workaround was to have the fallocate()
done in a separate process (fork) and have the child process's memcg be
set to the desired memcg.

This workaround is kind of awkward, but could it technically work for
NUMA allocations?

>> 3. Why not request the guest_memfd to be mmap-able just to be able to
>>    set a memory policy?
>>
>
> the eventual intent is to enable this for fully confidential,
> host-unmapped guest, isolated to a particular memory device.
>
> Requiring a mapping to get node-placement is quite defeating the point.
>
>> 4. How about something like fbind() that takes an fd and offset range
>>    instead of mbind(), which has a prerequisite on mmap()?
>>
>
> This was a consideration - although it has other limitations and larger
> complexities associated with it.
>
> Where does the policy live for random fd's? (inode? address_space?)
>

Off the top of my head the policy would be saved at gi->policy, where
it's stored for mbind() now. fd+offset is just another way of
referencing the offsets to set the policy.

> How is a reclaimed inode's policy handled? (lost forever?)
>
> figured i'd start by reducing the scope to the narrowest and clearest
> use-case, but I did expect to have the fbind() conversation.
>
> I'm open to it, but it seems like over-engineering.
>
> If you look at tmpfs / shmem, you'll see there is the option for a
> default filesystem-wide mempolicy that can be plumbed, but i'm not sure
> there's a real usecase for per-file mempolicies that isn't literally
> guest_memfd.
>

I see, can't think of other use-cases for per-file mempolicies either.

>> This doesn't exist yet, but I'm hoping to discuss this at LPC 2026:
>>
>> 5. What if you could pass an fd representing a mount to guest_memfd at
>>    creation time, so to make all the allocations come from a single node
>>
>>     Step 1: Create a tmpfs mount, specify mpol for mount to MPOL_BIND
>>     Step 2: Get some fd representing the tmpfs mount, hand that to
>>             guest_memfd at creation time
>>     Step 3: guest_memfd allocations will always come from that tmpfs
>>             mount, and abide by that tmpfs mount's memory policy.
>>
>
> This i think this is more feasible than something like fbind, but devil
> is in the details.
>
> I definitely think it's interesting and would love to chat at LPC!
>

Great! :) Cya!

Along the above lines, for HugeTLBfs we'd do something similar, and the
mount's fd would also indicate the HugeTLB page size.

Relating to memcg above, this doesn't really help though, since tmpfs
doesn't offer a way to configure memcgs.

>> May I know more about the use case behind this new feature?
>>
>
> see above - confidential vm whose memory is quarantined to a particular
> device, without placing that same burden on the host memory.
>

Is lazy allocation a requirement for you? (as opposed to fallocate()-ing
before the guest touches pages)

> ~Gregory

