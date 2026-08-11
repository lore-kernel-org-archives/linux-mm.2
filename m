Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B1A9C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 08:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502646B007B; Tue, 11 Aug 2026 04:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C466B008A; Tue, 11 Aug 2026 04:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F566B008C; Tue, 11 Aug 2026 04:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 057C56B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:51:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EDEB1C0F64
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:51:22 +0000 (UTC)
X-FDA: 85088369604.30.477F517
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C406F1C0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:51:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcZcRvus;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786438280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGix9+ChbUADTuxGGhQgnktQZ1ZRs7VSctwhrFpgqIk=;
	b=C674RnOV8Ep7A1B5vAO+oqhP12XsCc0uHXUNKrgxxX9NXTXhhxsnUuaAMNsqdsu8KfCwnj
	jKmWFV678IbXCKFbZGk/64bLbPJG115JkK4wyo1bf3trTpJF7GOIujr/BZdGDEg17bBupi
	4JjzJfeBkOK+1dLza5FrKRvrIn4hGqU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcZcRvus;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786438280;
	b=CeTvuU+1m5UQrAbkEkJzEvREtM9jbpYvlQCsy2H63um2p6maVHnJxI3NDByJXPUggKMq++
	PJa1e9tEegqY/j0o39wHDv23ZoiFrfp+dCZffD0Y/LYvqu/Mwjv4O86TauRNIWOJofY6lP
	GGh62lR2Rkpn9MTaiG2I3mCjUQHK3ew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A56F0416B7;
	Tue, 11 Aug 2026 08:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B661F000E9;
	Tue, 11 Aug 2026 08:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786438279;
	bh=WGix9+ChbUADTuxGGhQgnktQZ1ZRs7VSctwhrFpgqIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kcZcRvusAGp8SBxsLE/wDLrFd85OxjKoeJNy86QvtKCyBGD1cgyhzx3Mo+zhq7u84
	 yEZmU2BsoRT9wyCf19rypfWAmeEwPEbShEDqCyvC26uGPgHvv6/p3RvACw1zTXDx3L
	 c+ps32DuOjovUkUEdLYgRaOvrkTWrPf8bqSxarzJBEwurpOSXymS9dQzEtEm1utNZg
	 QSOee1kNV3l8wZ1yDB39yiHJCKQA/2K7P5nWoOct+7U7PMFg+Rn/PnIJeE+DrHvueG
	 93eq7u40jvWGmJgujAMuyQTVFshixMJ3r2xalBwT3uRAjxP8uqnmmS2/PHdrnZ4gLl
	 ixBVO13PGfhxw==
Date: Tue, 11 Aug 2026 10:51:13 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, 
	David Hildenbrand <david@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Omar Sandoval <osandov@osandov.com>, 
	Jacob Lalonde <jalalonde@fb.com>
Subject: Re: [PATCH] coredump: add filesz truncation and filter
Message-ID: <20260811-achtfach-backpulver-mundart-70a7e5a20ac6@brauner>
References: <20260731171336.2255844-1-jalalonde@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731171336.2255844-1-jalalonde@meta.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C406F1C0007
X-Stat-Signature: 6w76gz4k4pjhs9ey78gbmm65n5e3cj79
X-HE-Tag: 1786438280-32695
X-HE-Meta: U2FsdGVkX18F9G2+OQk9Lv1rlm4l+/G6U9OOL8LruQFlx3Zw8JBZpVE2Kt7HF+Q47wcUOjZA9yNMC/5cmQBYEXJlFHCabpWR5I1kxoFRNayJpMwCa4BYnb/LW7Zkm285X84J48yojXWHj87akiIv+hQXtirjgmOIT/HuTHJhG6aU0NYQpE/bn7bhzQagX3qW9EpokWqpRzIoQgJN5JWfdS2YD5e2ANj0Kt5uz6i5h9kpYYpfaHUEnx66mY0uBgCYL3TJQcEyHOhF+uqFZi2Mg/0EngA07CBOA0y++pdtNotQPgrvNzeHsHbDMdot+HOuOJIQQFnuPNiF9LAz5MFtOXYNb583TzuSgJUYYLkG5U2yVPsN9yBXURbDZ2Ba4au54vTm9mOQfN5t/J3aCjEcdEN9N40h9Kh26WgrthdouqYphNRSFJxSzKB5TYMuEpM8+gTQRO1KgCjqay7MrO3F1Bq0DL99vv8RO57Jw6rpmzpmZXeg/BCzPPYeLBglM6eV1WhYsEHPP7UtJ7hb5m87H4LYZLm5zwXasZdCYskei8oP0at7ANVL9XYezv8Zbdyo4A/DJQgsVbVX9xOpa1yKPqNatiVvXABMhPesM8rqHBUAwY403fIZGY1tlKt1JrXP8zZ5dXhnpxS5fkN1PCD29kvZeqQ0GOxdb7hSGcX5eOzoG+joyYjOtEMn915lN2LWm0wMZHQkbX5N/ezbePwZvMjPhGeWpmCVP17wXjafxIY1ixXw+t2dAhluXiQaIu6dLUjMxY79Lj5wnmgxJP4zAUyYrUNANaaXwUd8FSvkmbaPhWjKc9ajBRUB2tvtBxNpzmkykFCvCBVV6OfOCJ2YPtbRUS3fGdTnY+otG3DWFDkA/bTrkQHuO5d44UYKv0r8YsVvKIF5XcM8S7VY5IrL1Nw9263fXeMOeN9YQ0Vtvfyltq7BZsjX7b+qPSokpoPjtqK24T8/rbNHrEMoQoL
 vwqjaYcD
 RIpdF3NNvFYlzutm/og34/wgTLm8Hf+cVa5LDLuHFOjiqtLcg0OtLqVx/BxXLsIOBrbta/G3QjT0hFEnRzzhzYPjMLpyII7DdvYB2S93rLtIBgtHgIbIEuKeo+Kg7DWygFuicJlwGSB/q08EqwWVWxRfHROwGSZySyePJipT4QhuvuabJipw25JJpFxkWQJPLY6C+uyBvWnv2M2P9uI4X5VuUKkNOo7I7gMIzmV8JTUyvV3paKtcnROF62XACYthIhoiJYHjNZE1RZZP37Tg5Ng9zfXndVfWE4tBRgl+0/0amGwp0LqIA1Ir+xwSOUsk7f9vL7IvxV+O5Hhk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 10:13:36AM -0700, Jacob Lalonde wrote:
> From: Jacob Lalonde <jalalonde@fb.com>
> 
> This adds opt-in truncation of Coredump segments to
> `/proc/pid/coredump_filter`. The primary motivation here is to reduce the
> number of zero pages written via pipe to a user space coredump process. In
> my testing this reduces coredump size, and thus IO by ~40% at Meta. With
> some outliers such as PyTorch's TBE weights being loaded in right before a
> crash being closer to 99%.
> 
> We achieve this by having the Kernel not emit the trailing zeros of any
> VMA, resulting in a PT_LOAD with filesz < memsz. I verified that both GDB
> from v16 onward and trunk LLDB support loading cores with truncated
> sections, however LLDB won't report zeros for the truncated region

Hey!

So I remember having talked to Josef (Bacik) about this a few months
ago. He had a similar goal. I don't think this is the right place to fix
this, though.

coredump_filter allows exclusion/inclusion per-memory-type. So it says
which mappings will end up in the dump. And such filters are inherited
across fork.

The new bit isn't a memory type at all though. All it does is to change
the encoding of the data that's sent.

So the receiver has to understand the new bit and not the crashing
process. This scheme will only work with a subset of debuggers. That's
kinda annoying. Basically the tail of a mapping can show up as
unavailable memory rather than zeroes. And it's inherited across fork
and exec so some unsuspecting crashing process does start generating
such coredumps purely because its parent did opt in.

Some time ago I added the coredump socket. There's a simple protocol
built on top of it. See coredump_req and coredump_ack in
include/uapi/linux/coredump.h. The kernel advertises the features it
supports in coredump_req->mask. Userspace picks the ones it wants in
coredump_ack->mask. It's explicitly extensible. And it's per-coredump.

What you want to do can actually be achieved by just using the coredump
socket today:

Set coredump_filter to 0. The kernel now streams a complete skeleton:
ELF header, the full PT_LOAD table and every note. The dumping process
then blocks in coredump_sock_wait(). And now the coredump server in
userspace can fill in the memory from /proc/<pid>/mem driven by
PAGEMAP_SCAN and then writes the sparse file itself (also works with
threads as they're also parked and you can always trace threads within
your thread-group).

That obviously means you have to assemble the ELF in userspace. But you
get full control over what memory is collected and how.

I find that quite appealing but if you wanted kernel-based zero
filtering I have a proposal as well.

Right now the mask only carries COREDUMP_{KERNEL,USERSPACE,REJECT,WAIT}.
Adding memory options is simple enough. Extend the enum and raise the
bit in coredump_sock_request(). Add a new bit COREDUMP_SPARSE to the
protocol.

The coredump socket stops streaming raw core data and becomes a sequence
of records. The coredump server can reassemble the data as
needed/wanted.

So every__dump_emit() gets a data record and every __dump_skip() becomes
a zero record with no payload. That can live entirely fs/coredump.c
below binfmt. So it applies to every binfmt and needs no elf knowledge
at all.

