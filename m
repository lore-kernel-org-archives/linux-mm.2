Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97EA5606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MI6QgEO7
Received: by kanga.kvack.org (Postfix)
	id 9FB9E6B0521; Tue, 20 Oct 2026 12:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC426B0522; Tue, 20 Oct 2026 12:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9886B0523; Tue, 20 Oct 2026 12:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DA846B0521
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:34:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0829D140201
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:34:34 +0000 (UTC)
X-FDA: 85343552868.04.D2B9142
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6F3C7180004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:34:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MI6QgEO7;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792514072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHqjIUhFvpVsVhV+I45YnU6GX4Mvwsm4gRW3Mvd2/jY=;
	b=s/RZcVlbksrSzUohP201dzC2NV2Ac8Gy1tNidkTTC+9odUzkbxcIJT4dn1gQUs4UqFNx0O
	aivBnIyn+z8aATEro+BPn/FI/2OOEZ4hrCvreiAd5jA/jEKCYgmSXlSitANE3rsZODJGOX
	it6NSGo2kf4KpOuXoWjSrq5uXehdhak=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MI6QgEO7;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792514072;
	b=qJ9splisj/FdsVkgYXGo7GJHAWNxJU4sk4IU8lGElVvUvCAefNBsm9Ct/wVEhQSWMVLNqO
	iSdvL69oFLjYB2+pCaltMjxsbbosl5tCQ5acIR06J3lXuJSyH6mzu35S1O+Eu5wLE+TuMr
	x+dDLcItMnFjBMd02DgqbWR9S3D+Suo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEC916020C;
	Tue, 20 Oct 2026 16:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9C81F000C4;
	Tue, 20 Oct 2026 16:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792514071;
	bh=hHqjIUhFvpVsVhV+I45YnU6GX4Mvwsm4gRW3Mvd2/jY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MI6QgEO7Qy5M5PYZMphw20mRiOi8/KO4htwUkAd/ccDBKZql9WT3W+ZEN7RVwN/Sx
	 U6TSVS2tToYfivZyDXihd5ZL+XatFZDL5/HLDP88POXLNJgXjJJizBl1NqB3vqEnOD
	 qmZRLHOhsHWPVyZ0nWAjEg3opj6MKlQjXcYGhGRFpU4EW3ihbQPM+PS19EQ7RVZTIP
	 XA91ZMgjcXzBRYVgh70zCC/TOt/pqhva0mPqWyeDrM+2Rd1OddxKK75vnnpI1Jrqpk
	 97iBi34fsYO4bSHzVilBadICPvyu+JElT5WSrFgNfNmCnssaUaJeoO+/gKrp+aOxky
	 IKWu4LiprgO0Q==
Date: Tue, 20 Oct 2026 19:34:19 +0300
From: Mike Rapoport <rppt@kernel.org>
To: shaos <shawnq1@163.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: akpm@linux-foundation.org, Peter Xu <peterx@redhat.com>,
	Liam Howlett <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] mm: mremap merge clears RWP state from an untouched
 neighbor
Message-ID: <ateYC2eXPHuy3HK1@kernel.org>
References: <20261020110748.959870-1-shawnq1@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020110748.959870-1-shawnq1@163.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F3C7180004
X-Stat-Signature: eadj3uez8kdm3jpdez5gxd5a8h9a87kj
X-Rspam-User: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792514072-282309
X-HE-Meta: U2FsdGVkX18Pe7r14CVduDdMDpgy95pi23ncM8hp6+QtA7ul+YTRJ3xV1VU55E7BgLNcwAlM4766H6Fp7l4exz288KfJtr6eOPmcSvGA7rvO/aqTmH6+fmX+a2ghP+HBcCbqDjBhzm+9Rd/wl3wHPxTrUkKnmCsPY1aQgJXAryQfgK7OVcc5KkT+sMXS0U+Q0PTAJ6XZsyuVjmQBafUS+lLmMM439GhvB471fr00xDCvitqIeVmnBhBskamgnkIj2a2NXjj3Yw+PJ3R95LSpsOhC+XflbYEwewFYtB4oCcHKAygkaeJbbi9zt5yQGJ004vDrtAx6lUKp5WzDiClpSoLsAVHzM7HGeuS0+jX+k+TAoVHhdZ/o9M4z2kpYKW5ybHrw8d4pq0RHh8aXYkagw/1Viklj3G3vbfZtHyhS0nSElKa0Ig+b6He/Uy+al/dVNMCTYbWKO2DCjkB9haaVpEtuRlTuQfozcwqZAcHgDe7ubbtB+xXPx6uYjVTOg+cv6V2Vm1s/8QQagMzdNnvNcIKINib99RNYeQM2NbKaGY+3fWwN+O6TuoeBDXJLfkRnaqc/hTmY0eMgE2+zs4SGJsOnT1zTsViQGdFStBsEn3X6rQAwQZvR8ixfuWITQLmUUP0Cmd+79IfzK1EJD/K3yKAF8vNJ4HIW673BtAfHBBYBoJwlvP562JTlmUkOj/zvvSPOlSrxwEpdt44r+KG/QmLnoObsBn08ESiS2ohDc1KDvmho6dAX2LGPGyq02ditLQHk/gGHHgb7LZOpp9xyEBg6RIQI3CJW1ZV1faf3OKV2Wze7JDwruFG5SmD9ebE6GaiSLGMILKES51I9n0ibhEZDU2gZaPJ/anT742i8IgXo1dQC5Mx8ENPmehTLkBanWSjDsxoWrq8b/qMODQohr5DBtOJ9sXfh5qFiSJ8qO7IlYYoxhALRpXOMzZzDVlgwA51cgR9Q4UCR/9oMaZG
 TUIZVSgK
 ck/y66sn1hsTc2RgDE1x65ZZnvI9tHrBsHmZSM4IqjFVijFDx+hOh1rjXpKa/HRVnVHj3QQQDjTLICZ3sDL21+lg5VDsuLikmt7ZPRygtYxGxdHKVUPSHMcOk0PfCOKfaMBkHTxyY56SWiIpoRYyReBrK7QxOWPiOmvYnATFb+HK7/TVc10E9otp291u9dszJcnstadB/RS/jIUWRS24E380Z/pW/2T43N1j+P+F9EneRPs3Hf0Mbp7jdmxf1MdXIdKRSQpBUlSIzwuq0l+19wPpnIIUxxxT1lL66+7VQvVcIErgJr0+onqflYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(adding Kiryl)

On Tue, Oct 20, 2026 at 11:07:48AM +0000, shaos wrote:
> Hello,
> 
> An adjacent mremap() can remove userfaultfd RWP handling from a
> neighboring VMA that was not moved. The moved VMA and the existing
> neighbor use the same userfaultfd context, and UFFD_FEATURE_EVENT_REMAP
> is not negotiated. When the destination merges into the neighbor,
> mremap_userfaultfd_prep() resets the context on the expanded VMA,
> including the neighbor.
> 
> The neighbor's PTE remains PAGE_NONE with _PAGE_UFFD, but the VMA loses
> VM_UFFD_RWP. A read that delivered UFFD_PAGEFAULT_FLAG_RWP before the
> move then completes without an event. The same-mm PoC reproduces this on
> two fresh boots. No-move and nonadjacent-move controls retain the RWP
> event.
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
> Build the kernel from the revision above with the attached config. Build
> poc.c statically with pthread support and place it at /init in a minimal
> initramfs. The positive run and controls use:
> 
>     timeout 180 qemu-system-x86_64 -accel tcg,thread=multi -cpu max \
>         -m 1024 -smp 2 -machine q35 -nodefaults \
>         -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
>         -append "console=ttyS0 panic=-1 oops=panic loglevel=7 rwp.mode=positive" \
>         -display none -serial stdio -monitor none -no-reboot
> 
> Use rwp.mode=no_move and rwp.mode=nonadjacent for the controls. The
> positive oracle is PRECHECK fault flags=0x8 followed by POST no_event
> value=0x41 and RESULT=RWP_NEIGHBOR_ESCAPE_CONFIRMED. This is a
> userfaultfd tracking defect; no privilege escalation or cross-process
> access is demonstrated. I checked upstream master f47d223627f8; the
> relevant mremap/userfaultfd logic is unchanged there, but runtime
> validation was on v7.3-rc7.
> 
> Thanks,
> 
> shaos
> 

-- 
Sincerely yours,
Mike.

