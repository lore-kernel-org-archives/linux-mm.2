Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BCE3606A321
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WvsXAARo
Received: by kanga.kvack.org (Postfix)
	id 4CE216B04CD; Tue, 20 Oct 2026 09:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E4A6B04CE; Tue, 20 Oct 2026 09:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394726B04CF; Tue, 20 Oct 2026 09:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 180FB6B04CD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:29:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68E5FC01C5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:29:50 +0000 (UTC)
X-FDA: 85343087340.14.2C1E6B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id CED16A000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:29:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvsXAARo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792502988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GoAdG5LD4++Mz1Oi9XOmg93QHvpINRKEHA4v8WqeZzA=;
	b=NW95DveBABnSKmnclXeGAmutMIFSfYXZeUXomJcCQE0g2/2sUF79M61sWkeUBe89nLuToY
	CFDs9tFQFRc6UNXOUssMud3sLui50V5tYKxaSXt0da95FrgLG/nzS4CXPRFU5dMnnIloT0
	iuUGzxTYQibaWr3yPeBQZ20yP3/9UEM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvsXAARo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792502988;
	b=02X2az9UQzniZ6Ypuhr7KOmmyVaSmwwq+hw1H0iJv4tAscK4/88inEWoUCKwVNBcjH1xyd
	EE5OxaxLUVqC5AZ+4yqqY21NXp6EuXLPrD7WsvaCZRqkTgmwwzUcec1Gsh/0XmB076NQGZ
	uwmzbfbGEROKlhfT3LJ0NviCrQa5ABU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51C5E60DA8;
	Tue, 20 Oct 2026 13:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F501F000D4;
	Tue, 20 Oct 2026 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792502988;
	bh=GoAdG5LD4++Mz1Oi9XOmg93QHvpINRKEHA4v8WqeZzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WvsXAARoBuC+DMbCRqrac83u0ve2zarkH15LXC7N/TqHSa3LSYRNZlihSsSt1hcgG
	 uipgJRKObyV7k+8aTWqEhOFdOerb/dOPqIjmmKERnCoXHZCvxxoYkfXUJ3gLZQvpfG
	 kASe5phrJFhWXz3k1ztIsC1evqFrLg8yYhQbPvZo00mSOPqy5Twd/6mJHgyWVnbLh+
	 q6MTLrfF3xLB+uY15M1V3PKv0ahkpAV6HMJuOegiMRfX4y4oLBeQf9e++jtyc9FcCU
	 Tk4ElFPF00g/717xa2I/0ZDVRhaiz0HSzl0vFvYJFjuRGtnbdD8ed75GqsehQHykZ5
	 WND8mNPJv+qNg==
Date: Tue, 20 Oct 2026 14:29:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shaos <shawnq1@163.com>
Cc: akpm@linux-foundation.org, Mike Rapoport <rppt@kernel.org>, 
	Peter Xu <peterx@redhat.com>, Liam Howlett <liam@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm: mremap merge clears RWP state from an untouched
 neighbor
Message-ID: <atdqy4ngmOFW4nIB@gremlin>
References: <20261020110748.959870-1-shawnq1@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020110748.959870-1-shawnq1@163.com>
X-Rspamd-Queue-Id: CED16A000B
X-Rspam-User: 
X-Stat-Signature: 5j54jbydtrbbc7ykz9ok348p9rwmdwz9
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792502988-276735
X-HE-Meta: U2FsdGVkX1/S0PaG7qfaNYRHcgAVgjvuW9CH3qGb5kblyMSzy0o+RQnH32QhgRZm0f78x7SP0j+FGTi7HHq1ns0QI65m2v5iCuDQer8RYi+9fXwaq/USPjOfVmAOnv9S2EmddUNZo3DbkMbZb1Z1JGMc8nN0dWw6N5tGSomajIHT5pj4VgSUZrYoFE+LMTz6wl4EtFkWBlmcpB/xm1PjlCmWPNarh2cVuvXR7BeyjGJlJxcx4P4q5JTMlWw0lS6KI3jiCDjm7oEc0tVDgKIxQ3w1zjcmt8VR4oRjW13sa7NJ+//RSUVaF136kxPu+750FFP0HrIYaykmAQgKTxoStu2S78mXS/XJqvHT57mqY+VV0r81gs+AacYfhplEkLGdhxRpnoRRB3Tq4j5RbzFte6EjXizxc5JUtzIWVWj5Hbavo+cBmPEiN+a+SL0Pq5Jb2kzH2TQ8BBE+yuzEjjbP2w3h4wlvqXX+bib9W9WGskziSrzpLbcHqIEDnQlhKAcRmvqhKECxiMK/vuOWQxrA+pGzgd4fusJjQ6+g5aQFd7c+I2t+SEI9Pu6IvT7NBLIxirQGx89Jf4nq9yotcGM/LkkmQ6PNgPqwPrGFHNH5ekbBbOW2kF2PC4q2Al+LlKPdEHb1VHzAjPzEvYQpqNm4b+00ShTVMmEqfK4Q9DdAwMiUupnimJ7N6HV1bWfmfOsCrkWcvc1iM2/3BDnT6KFJiLG1J1kFQHVSXwuivG0kdOE0U4eWmcyqRU/ytwt+HFKwDi6yjKa4CCqMXs86IME2fgoMfZ284U0bYBkRqMKV8jj614wWAKozW8FNqSzApK2EwRHlSaBDZcVuBqQho3Xe8j2/phooaFlV3RQ12Mpy3NIncOvNVW6q5mRT55wzUbCgKuqwn29t+kJ3AnHtaABIhZ95vBN+GJbCUGYPNZoxQN5GBgGVIYKPqpUIF8u3OE4GvRt5wSWz1RpU6+497zD
 QziSifo6
 rK1SvwEOH54Ugc7Rp20dIOUYpRDMBzuQ4kN7aRC3rzCgmKK2qOK3VU8zzVwTVReqFw7eE82F2EVhu0QFi6OxhG4pgZydZhM+iiLHFIpq+OKUs8P7OA8JlOJMvROBnutHzK/w1FC+4Nfy2KpyENTyAkrvyGJvFkumyL1pEB9PTJ+p//7xLO0M1Hh8yV7nG4W3DLXb21ybzCjEFxZvWjXRbMDog4fBWl/Sb+UiU+zQNmQJI5pitJ94phhJlnR9qJ4GQ3Ql0TI5dBOEkvLgF/1Vtuvoim04gvmT+mpAfAlyXCu0e9d5mzTCnr5nM2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 11:07:48AM +0000, shaos wrote:
> Hello,
>
> An adjacent mremap() can remove userfaultfd RWP handling from a neighboring VMA that was not moved. The moved VMA and the existing neighbor use the same userfaultfd context, and UFFD_FEATURE_EVENT_REMAP is not negotiated. When the destination merges into the neighbor, mremap_userfaultfd_prep() resets the context on the expanded VMA, including the neighbor.
>
> The neighbor's PTE remains PAGE_NONE with _PAGE_UFFD, but the VMA loses VM_UFFD_RWP. A read that delivered UFFD_PAGEFAULT_FLAG_RWP before the move then completes without an event. The same-mm PoC reproduces this on two fresh boots. No-move and nonadjacent-move controls retain the RWP event.
>
> HEAD commit:    24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> source version: Linux 7.3.0-rc7
> architecture:   x86-64
> compiler:       gcc 11.4.0, GNU ld 2.38
> QEMU:           6.2.0
>
> console output: https://gist.githubusercontent.com/shaos26/3b44971d9385a0cd18cfbf2e9bd730c6/raw/368568c2dd47417b54a957c8d9cc09f77f28b236/console-output.txt
> kernel config: https://gist.githubusercontent.com/shaos26/3b44971d9385a0cd18cfbf2e9bd730c6/raw/4989bc843fa61b5eaaaa53422238ec39e4356b70/kernel-config.txt
> reproducer: https://gist.githubusercontent.com/shaos26/3b44971d9385a0cd18cfbf2e9bd730c6/raw/109dc86c28debcaca07aedb2d450ed1e95ae5edf/poc.c
>
> Build the kernel from the revision above with the attached config. Build poc.c statically with pthread support and place it at /init in a minimal initramfs. The positive run and controls use:
>
>     timeout 180 qemu-system-x86_64 -accel tcg,thread=multi -cpu max \
>         -m 1024 -smp 2 -machine q35 -nodefaults \
>         -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
>         -append "console=ttyS0 panic=-1 oops=panic loglevel=7 rwp.mode=positive" \
>         -display none -serial stdio -monitor none -no-reboot
>
> Use rwp.mode=no_move and rwp.mode=nonadjacent for the controls. The positive oracle is PRECHECK fault flags=0x8 followed by POST no_event value=0x41 and RESULT=RWP_NEIGHBOR_ESCAPE_CONFIRMED. This is a userfaultfd tracking defect; no privilege escalation or cross-process access is demonstrated. I checked upstream master f47d223627f8; the relevant mremap/userfaultfd logic is unchanged there, but runtime validation was on v7.3-rc7.

Thanks for the report. I think restricting merges for UFFD seems a sensible
solution, will put something together.

It doesn't _seem_ to be addressed by anything we have recently, either.

(Small nit on email, please try to line-wrap to 75 chars, makes it harder to
read mail on the antiquated systems we use :P)

--
Cheers, Lorenzo

