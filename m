Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D81CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381196B00A5; Fri, 12 Sep 2025 11:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331D88E0002; Fri, 12 Sep 2025 11:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220686B00B6; Fri, 12 Sep 2025 11:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6186B00A5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:25:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C1D1B9BDA
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:25:39 +0000 (UTC)
X-FDA: 83880972798.14.79555B6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6AB214000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:25:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757690737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YaVFVuWtyKgp7Y3tlzPDyRgfcQER5D3c+vZ1/BrwHVY=;
	b=8owJWGltz5lKmI/FTMtLPjPpfHjwWSXpa9+0XmWu2xzm6uei2F1vLxuMyJnrd3XvISC2EA
	MxjRWAl1SepmsZoaW8cErIH/Hu28yXPwL7wuddNossj/0oI+R0jTrLsWzF/nzX9kuKlHxS
	KhI6VNAuJU+jn2U1O7GKjiBOLQdnCI0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757690737; a=rsa-sha256;
	cv=none;
	b=E70LNy9wgx+WNQkpbUdrjZmrEtO8jbeFtmKD35C8gZoCsBrwfrMJbKtHcEhrBSuTcgTUGN
	D/yDUc6pKf2Ln7nzSNoA/o0I6sVC2TE/3ilY6+UVrpyM2lFYva0vpxAL/aV0xZjp/0IaX2
	QOZD8YjM67C5OOYe5G8Vd3JVYUYu+r0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E94328AC;
	Fri, 12 Sep 2025 08:25:28 -0700 (PDT)
Received: from [10.57.66.147] (unknown [10.57.66.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 301DA3F694;
	Fri, 12 Sep 2025 08:25:29 -0700 (PDT)
Message-ID: <338ef811-1dab-4c4e-bc5f-8ebd8cb68435@arm.com>
Date: Fri, 12 Sep 2025 17:25:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: Re: [PATCH v2 0/7] Nesting support for lazy MMU mode
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908191602.61160a7990b9ea418de758c7@linux-foundation.org>
 <d1b4ff2a-052f-4556-91ae-273962edbed0@redhat.com>
Content-Language: en-GB
In-Reply-To: <d1b4ff2a-052f-4556-91ae-273962edbed0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 71gc7k4ou75e5bp9roqp5dmsqna4g18w
X-Rspam-User: 
X-Rspamd-Queue-Id: A6AB214000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757690737-212226
X-HE-Meta: U2FsdGVkX1+uWF32/TMPwLDcfP+JaVy2zxn2L4t8evtWL3wD118nVw05W/mLDrtkO21iOJiOeArPf3xLF3GKRb24r+Em3KWnjKJfkHpSo+HXrKd23MEA5I9xJOFHUnpcyTPGy+esExrLXen2e9Fn0JF5VBMi2OZwBYHKZrCSKZK+Guq1P1rBWO1PITzfuHEqTVpWdCDfcNvtTA+uaRaamv9ZF0AwEwVw5Y9+Us4OAscxvh8Hd0hh9Ap67+MEXPXHpg0dahJFAKc6Uc7PfdDj2zdwoWQ0CllqPi/zvBxeAkzdCph2VI8k0ycUxHDeF+pfeqbqujaSbisK5CYjwTmxntdfoNuTGmBpH7gOhpTXYy4qEL/KNRYhoUO+02LUfGwiEXtetnaysCbugt4sYkHHIney7YcuKC+t04pfQQhiP5tkN79wgQbI+kVms++PK3aFlzlR5yzAlgFcN0V92uFC+DA7FKmVDEp4MV8lrbdDRn414p7OLPYgeNy4lCMnG5JyjRnCuN0x1h2/qxflLfQ8EKIGZ6uB3uwcs6Il4MWglxe7BJKyDIVnF7khtzYA3i6hkvyP2p88lXuwZbYRSkYmxXddZbLiHeoTn1/OhRnoHp0PaIRfZLnNkv7Mdt3/bu024P1z3Q7BGaGzNDGd3QuN6H9Gc71PfNVRCPxmZnJWsBQnt4VwtbOI4sj98B58D1hKeIl3xuhdhoF+AmuwJxHfVfY7bUdts2rViqg0fdbberl/bipIzyVtlXUuMvnP87U78/wMnt3HZRIUywHoLwZeWh4zDfoE864T/GUFytBZi0rwEHraAifxpBihOGYdViECW6Ti8llGKafEX8mJB3RtZU28iT1ZVNDRjUQlMmcbdnIbq7Cx59FJK1OTUzk6/WGgLyHGQrI0wcFba+KDfO31lgVgL2q0/U6hjhN799gld01EYdKs8iF+NVIlmdJt9qxckjj60ox71mprr+8HYrF
 MgdL54xE
 TPX0viFbmcuCuSpcOYVzE+6fKFEzKDZ6rbMjVTc4kY9qTErvEGcbN5zyEkgdZGdTpXAznqUiky+ieF1gyhLXV7/tJg9ETloWroKJ2zhC752c4dskWBlZ0dzu0YCzftNQu8VBAhHtYlwt0Lztm4mDPbyso+JnfuDX1zun/vdSzVwQaSyWoJO3+lmyo6VqV/H5Eo4K5tqSPvjYuzesqiLEIQEgc38k3OA7bHO8VgHwwagDAqUhPNA/s6cLsDFcUXgcditVZM4QQEl8vOXQr870W0Ju6pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2025 11:21, David Hildenbrand wrote:
> On 09.09.25 04:16, Andrew Morton wrote:
>> On Mon,  8 Sep 2025 08:39:24 +0100 Kevin Brodsky
>> <kevin.brodsky@arm.com> wrote:
>>
>>> The main change enabling nesting is patch 2, following the approach
>>> suggested by Catalin Marinas [4]: have enter() return some state and
>>> the matching leave() take that state.
>>
>> This is so totally the correct way.  Thanks.
>
> Staring at this, I wonder if we could alternatively handle it like
> pagefault_disable()/pagefault_enable(), having something like
> current->lazy_mmu_enabled.
>
> We wouldn't have to worry about preemption in that case I guess
> (unless the arch has special requirements).
>
> Not sure if that was already discussed, just a thought. 

Based on the outcome of the discussion with David on patch 2 [1p], there
is indeed an alternative approach that we should seriously consider. In
summary:

* Keep the API stateless, handle nesting with a counter in task_struct
* Introduce new functions to temporarily disable lazy_mmu without
impacting nesting, track that with a bool in task_struct (addresses the
situation in mm/kasan/shadow.c and possibly some x86 cases too)
* Move as much handling from arch_* to generic functions

What the new generic infrastructure would look like:

struct task_struct {
    ...
#ifdef CONFIG_ARCH_LAZY_MMU
    struct {
        uint8_t count;
        bool enabled; /* or paused, see below */
    } lazy_mmu_state;
#endif
}

* lazy_mmu_mode_enable():
    if (!lazy_mmu_state.count) {
        arch_enter_lazy_mmu_mode();
        lazy_mmu_state.enabled = true;
    }
    lazy_mmu_state.count++;

* lazy_mmu_mode_disable():
    lazy_mmu_count--;
    if (!lazy_mmu_state.count) {
        lazy_mmu_state.enabled = false;
        arch_leave_lazy_mmu_mode();
    } else {
        arch_flush_lazy_mmu_mode();
    }

* lazy_mmu_mode_pause():
    lazy_mmu_state.enabled = false;
    arch_leave_lazy_mmu_mode();

* lazy_mmu_mode_resume();
    arch_enter_lazy_mmu_mode();
    lazy_mmu_state.enabled = true;

The generic enable()/disable() helpers are able to handle most of the
logic, leaving only truly arch-specific code to the arch callbacks:
* Updating lazy_mmu_state
* Sanity checks on lazy_mmu_state (e.g. count underflow/overflow,
pause()/resume() only called when count > 0, etc.)
* Bailing out if in_interrupt() (not done consistently across arch's at
the moment)

A further improvement is to make arch code check lazy_mmu_state.enabled
to determine whether lazy_mmu is enabled at any given point. At the
moment every arch uses a different mechanism, and this is an occasion to
make them converge.

The arch callback interface remains unchanged, and we are resurrecting
arch_flush_lazy_mmu_mode() to handle the nested disable() case (flushing
must happen when exiting a section regardless of nesting):

enable() -> arch_enter()
    enable() -> [nothing]
    disable() -> arch_flush()
disable() -> arch_leave()

Note: lazy_mmu_state.enabled (set whenever lazy_mmu is actually enabled)
could be replaced with lazy_mmu_state.paused (set inside a
pause()/resume() section). I believe this is equivalent but the former
is slightly more convenient for arch code - to be confirmed in practice.

Any thoughts on this? Unless there are concerns, I will move towards
that approach in v3.

- Kevin

[1p]
https://lore.kernel.org/all/4aa28016-5678-4c66-8104-8dcc3fa2f5ce@redhat.com/t/#u


