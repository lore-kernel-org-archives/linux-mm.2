Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4F671094469
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 10:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499766B0089; Sat, 21 Mar 2026 06:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4711B6B008C; Sat, 21 Mar 2026 06:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F9C6B0092; Sat, 21 Mar 2026 06:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 272DA6B0089
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 06:27:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4D4DB9ABC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:27:29 +0000 (UTC)
X-FDA: 84569693418.27.8A4791A
Received: from hillsboro-edge.smtp.mymangomail.com (hillsboro-edge.smtp.mymangomail.com [5.78.130.219])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6A0504000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:27:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=p9UBjw60;
	spf=pass (imf12.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774088847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCqNFyyPUUdW9ZMPxDkboCXhDE0SUM9SHSiNMtFzQiE=;
	b=2KZJuk9ZMiqAupSYMvtKCSDq2R6H18qt3P4FUCR2qzEghK5WpPjrb8l5bow5KZRgvE3l/6
	St6rtnEyqsEobGfok5pYSDEkQw6+LXOifkmHuMqYcgEaVj3Tf0Bh2imcgZ2TnulPDqReWu
	sOA6lP5KL+F+MfHTW8aLihkuRoDmzyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774088847; a=rsa-sha256;
	cv=none;
	b=oO5FzJtsL2oHrQqk0RnbCvVmThG18SAZ3f9vTwltr8M4f9//rH++TlxdAKNZalfoSYjUeK
	CkcugZqDiLGWwnDFrGc1DIf0mlTZPi6EN2tDT7srDQehH2SadKzQRv2ASbER0MMvx+qpSe
	WD+KOV1CkhZbEzZcSLWWnlf+iBDSAas=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=p9UBjw60;
	spf=pass (imf12.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
Received: from smtp.mymangomail.com (localhost [127.0.0.1])
	by smtp.mymangomail.com (Mango Mail) with ESMTP id 893AE41963;
	Sat, 21 Mar 2026 06:27:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774088831;
	bh=WGQD1ZsKdugY1KTxZSSSEplvqr53gUI6cKQKc+OHL1Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p9UBjw60JFvX5QGlAhtaEm3GKgshG9pnkCkbfl5muB8nOVBJKhjPnNc7wDB+U4KK2
	 ap5sfw24DYfiealUvfeYrtG8tzZKmb1adON1zrWqNKtKus5UAPFLBm6Xqn+wFBcsXS
	 JAFzVyE/vVXqTxFaz+p7slnZI6R6TMAxcvF+Sl1I=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
 SHA256)
	(No client certificate requested)
	by smtp.mymangomail.com (Mango Mail) with ESMTPSA id 29FB9418D0;
	Sat, 21 Mar 2026 06:26:00 -0400 (EDT)
MIME-Version: 1.0
Date: Sat, 21 Mar 2026 11:25:59 +0100
From: oskar@gerlicz.space
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport
 <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, Pratyush Yadav
 <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/5] liveupdate: block outgoing session updates during
 reboot
In-Reply-To: <20260320182352.ca6c88e409ff12d0368b03ae@linux-foundation.org>
References: <20260320163720.100456-1-oskar@gerlicz.space>
 <20260320182352.ca6c88e409ff12d0368b03ae@linux-foundation.org>
Message-ID: <af15eae6ea9007aa6fd7924512657168@gerlicz.space>
X-Sender: oskar@gerlicz.space
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 88dnf8d4693ot5tdq5okxfx4od8pb4yo
X-Rspamd-Queue-Id: 6A0504000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1774088847-554498
X-HE-Meta: U2FsdGVkX19ZcCpuk0i4MUu+wyqfOw3j5h66WYkNdDNs3jUj3p+TMa1c8IUzoLRru2d6xVo1HVG6eALSlvlP1XqRrdKc4dthyk+4OAkoaFLE8zdDavbRZP8GBovJu1yNrSyQdYhj5QI4bOhJd1QcF7dMW4wAGP0a7grsw4/95oA6FApUkbnJzhpNvFqFzWtXeukhNzcdWY8vm8ftTg/V5Sm1uTgx/e3lfqdgYpsqL2kI20bSW+h2MbLS+4QmqZmK5xqSnWTSVVI6SxOOJCQtzil24vrLXtPAtP1QI4kRoino3i44CrK0E30ZipN/ZeGiNp5j5pdDt1g/aKWRq/KpHSBHCmEv/I+XbDk3blUlNXSEkoLyb+smX2cmXy/88c/MJU1vbyeREmMzCxxFTgWUs8TH3S4MPUyLTYGragSdVLXcQpXmMFFU6rN+KqUDQ5AuwiVKlIbEzf5ViGUYpI/myNO129/gO9hEoe0j+yRR0ut7U4jkO+z8fb7k5d7JQdxcsXhFF/At6KN6NWRlhmou1qug0fPJghSyp8i9GbkVKYScCIu2iHUDmwd6H2mTDMSddKB1v2JBBhpJHfQHVOWyE3HUBOZpL1UzaMru8hzhZBnMhSsoq6fK3CCOenCTOAUFu1t/qn4vwN+Emj9n2PNGPxEr3O7tv8DYdMad5wYQ36tY7nrNpB20JL4HtWBmf/AJhGEEHxigBDuYSQ9B9ZkOx6+e8Ib6XaUxc6wi0sN7LzGBoGtHKS6yQwHxYzyNVO2BEpXmgIVV8SQ5nTOHsj9pU3x2esNa83e6ao1MYMWEk5zA01TtMYiDKs3XUskL2I5f3HrgDkBs7LlkcM+9pWJ4Uzg/kJQ23vgXYwco2qdM/zkcH94WDWjrL+Vt+pgkLZacigRybqrg93QwVuUhLJWNSbQum9rtvnr3x8L/pR0P8y+RFTaTIRjhviwx5BaH7JUC5MGkf3GpKm5xHkGEMZk
 lW7qhSNG
 mB0gVKub5qrsQ2OH5QiAiZ4P7p6lcszY0Nf/BjiUNaOcJK869t5swRXNRMC9Cr75tdEzvYsTwGViODhg3tGxMJY8YNdMcCXRqYhm2/37+kiSU04waAU/RadpTZI8TW4VAG4c2aMSu3Oe8ND2aH/Pe+vqx6MiuOh8P1ICqgqzS2MvcwvPrBTdeSGoAJfi1fe4Q1ZIkXm2d+f+Yt2J7h8+LpVmVJ+cBE9E/sz2IrnboN2fKPFb/XN2dZnBOIAOvYceDLbF6ERMMISO/Wti4Zqomn1qyGmsGiPf3AnAHiItryjl/AOhOxOMxq+2VWA6nY4k6MiEymSXOv9JO1a98WRDSZsC53wxM1kUFXy1EXUqtJjQay7E/gVyZd0mCm68RfUXLnQP0Tq2rt9I7tFVGeo0IFREhuXsnfWBnTBppJk/Q7HX0UtzkS51FaxDgqeOWxFVuAZ0WH202KPy5qmYFYGcPvJyy9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-21 02:23, Andrew Morton wrote:
> On Fri, 20 Mar 2026 17:37:16 +0100 Oskar Gerlicz Kowalczuk <oskar@gerlicz.space> wrote:
> 
>> When kernel_kexec() starts a live update handover, LUO serializes
>> outgoing sessions before the reboot path freezes tasks or shuts
>> devices down. That leaves a window where close() and
>> LIVEUPDATE_SESSION_PRESERVE_FD can still mutate an existing outgoing
>> session after luo_session_serialize() has already captured it.
>> 
>> The race is dangerous because the next kernel may inherit stale file
>> metadata or references to memory that userspace has already
>> unpreserved. That breaks handover consistency and can later trigger
>> restore failures on already torn down state.
>> 
>> Mark the outgoing session set as rebooting while serialization is in
>> progress, reject new mutations with -EBUSY, and make release wait
>> until rebooting finishes before unpreserving files. Reset the flag and
>> wake waiters when serialization rolls back, and use READ_ONCE() and
>> WRITE_ONCE() so the state is visible across CPUs.
> 
> Sashiko AI review has quite a few questions:
> 	https://sashiko.dev/#/patchset/20260320163720.100456-1-oskar@gerlicz.space


Thanks for the careful review.

Patch 1

You are right. The incoming .release path can return before
luo_session_remove() / luo_session_free() and leave the session
stranded. This is pre-existing rather than introduced by this patch,
but it is a real bug. I will fix it in v2 by ensuring the release path
always removes and frees the session, while keeping the warning if
finish fails.

You are right. This wait can be hit from userspace while the
preserve_context path is entering the freezer. I will switch this to
wait_event_freezable(), as this path can be reached from userspace
during the freeze phase.

You are right. Dropping the rwsem before luo_session_remove() leaves
a serialize-vs-close window, so v1 still allows an outgoing session to
be serialized after close has started. In v2 I will keep the outgoing
session exclusion across the entire unpreserve/remove path (i.e. prevent
serialization until the session is fully removed), and I will gate both
PRESERVE_FD and FINISH under the same reboot check.

These issues indicate the outgoing session lifecycle still has race
windows, so I will rework this part more substantially in v2.

Patch 2

You are right. On the preserve_context flow, machine_kexec() can
return to the original kernel with error == 0, so the current
abort-on-error logic is insufficient. I will fix this by explicitly
aborting liveupdate state on the preserve_context return path in
kernel_kexec() after machine_kexec() returns.

Agreed. The abort loop only stays synchronized as long as the outgoing
list cannot change after serialization. The remaining release/remove
race in patch 1 breaks that assumption. I will fix that in v2 by
ensuring outgoing removal is excluded once serialization starts, so
abort can unfreeze the same session set that was serialized.

Patch 3

You are right. luo_file_discard_deserialized() currently drops
file_set->files without freeing the preserved KHO block. I will fix
this by routing the discard path through a common cleanup path which
calls kho_restore_free(file_set->files) before clearing the pointer.

You are right. The direct returns in luo_session_deserialize()
bypass cleanup of sh->header_ser, can leave previously restored
sessions behind, and do not cache the final error value. I will fix
this by routing all deserialize failures through a common cleanup path
which removes any sessions restored so far, frees sh->header_ser,
clears sh->ser, and stores the cached error before returning.

I do not think this specific UAF is reachable, because deserialization
happens before the device becomes visible to userspace and the device
enforces single-open semantics. The cleanup and leak issues are real,
though, and the common unwind path above will address them.

Patch 4

Agreed. The file-set validation failures currently share the same
cleanup hole as patch 3. The common deserialize cleanup in v2 will
free the preserved file_set block via kho_restore_free() before
dropping the pointer.

You are right about the direct returns in luo_session_deserialize().
I will convert those to the same common error path so sh->header_ser
is freed and the cached error is set consistently.

You are right about memfd cleanup. I will route early validation
failures through free_ser:, and I will fix the folio unwind so it also
releases the current folio entry rather than only the tail entries
after it.

Agreed. I will also validate nr_folios against the vmalloc backing
metadata (ser->folios.total_pages), not only against ser->size,
before iterating.

Patch 5

I agree this is a bug. It is pre-existing and not introduced by this
patch, so I will fix it in a follow-up by rechecking the incoming state
under the mutex before returning success from
liveupdate_flb_get_incoming().

Overall, I will rework the outgoing session lifecycle, unify the
serialization exclusion rules, and fix the cleanup paths in v2.

Oskar Gerlicz Kowalczuk

