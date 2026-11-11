Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6D7606A336
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fusE+kuT
Received: by kanga.kvack.org (Postfix)
	id 83A9A6B05B0; Wed, 11 Nov 2026 08:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB986B05B1; Wed, 11 Nov 2026 08:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700DE6B05B2; Wed, 11 Nov 2026 08:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3906B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:26:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D79E51A02AD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:26:16 +0000 (UTC)
X-FDA: 85422911952.13.0BAEA0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A07C40005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:26:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fusE+kuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794403575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWibahG2+QM42E0pwbef1XpX0UCKvPhGaW6o9ujTid4=;
	b=QJiTPj0VALx0I/WtP/BJccFgEUqq4Wka+WQ4oUheZnB3+7NKF/+gZS3Orj14ZAh3cAhvCB
	2clWwSF8Q35Q17XAKZPIlG/1UZijjz0uVk1BVCJ5ibmEdWge5fX8JCi3vIY+3nDbet94F2
	dDoK6oObQ3cJznNc2Ay845K+YZV/h0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794403575;
	b=4kaqoOXZRdvD9W/boAx0dsMm/gHhAzglog79+N3gw+Z208c+YjpCh7MbEp9Qrz2ZbgJ71y
	mzFeMEKXLI08kc358glNsmdJMd09ZkrUKEyrU9rpqLYuZGMOWwbSCcB8rQ09cpEB/hZMR8
	0TYzowIbvuaUEHLYjXxtWW6WDlBCsNY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fusE+kuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6368243516;
	Wed, 11 Nov 2026 13:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C051F00A05;
	Wed, 11 Nov 2026 13:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794403574;
	bh=oWibahG2+QM42E0pwbef1XpX0UCKvPhGaW6o9ujTid4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fusE+kuT1Ng0ykR3xMZISIR5SNUWUIbhSXbteiixscNE0XQZ/4QF+lakMcdMxFHHi
	 M1mf2UJ2QPW3x9uw5PvSrA0AiNKey2XpD3ViEAZuZxBMJECyLvyXNBuR3XNQgDseCj
	 Whk45lzZ+x8Mpy4LUpd0w/baDScc9ZMbhNDMRN84OrkG6G9Ugfr7+e1ccIwv9RNxnO
	 /8bt196Es0Cjr24URtzA0XQscyM0tSANiVymhCILjUq9OJs53Wq2zeq2Mg+H7fWrO4
	 mlxPOy3d25I6SxQYUZynbD7a5RayOrPhbilrd1qgBTVjJzpwTgPs0ciRjwaOwRlNDN
	 TalR3lpEjL2pA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon
 <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Daniel Almeida
 <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>,
 Lyude Paul <lyude@redhat.com>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 driver-core@lists.linux.dev
Subject: Re: [PATCH v5 0/4] rust: byte-wise atomic copies between `Page` and
 shared memory
In-Reply-To: <20261111093017.GX2668804@noisy.programming.kicks-ass.net>
References: <20261110-page-volatile-io-v5-0-a91ef252c24b@kernel.org>
 <20261111093017.GX2668804@noisy.programming.kicks-ass.net>
Date: Wed, 11 Nov 2026 14:26:01 +0100
Message-ID: <878q2zwlcm.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 94uxofpedrdbgb3qyc8mbxnet6661za7
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A07C40005
X-HE-Tag: 1794403575-18458
X-HE-Meta: U2FsdGVkX1/jmH3t8XupdRK0tedbJX9qzKpNyecfTlUj76X3d/Kn4Ho5BcMQhYyQLiv03evifbnetFm6KOMbXQ3yG2D819MLGh4UOH2OC7Dt7mTDW1V3QxDIfinOdnrBeJHyDOiP1hRX+pnF/ynqamqMkgJIIpThvAHHEtYgis41QEPcyvo+TARk59g68G0P7i801pd4cp1VYBZqkWjES2xNHVV+/BruzPrUb/Ra9s/LUmuovr0mQRMylDOvqinKbDKWarej9Ybxn1alVjYk8p/5bRurS6mibuFN5oAj2dPydvL4Ma6wq++DgggA82wTzIHQLtfP3ivVPwUpPNep7YyFRuV5iKKQxY9cWNZ8LI0Jww9pRcNHAMDAKLG7lx/pekwRn6RjcqRxyGrWlutGUkTh5zz7nr3HOZgxbip+9bH+jT+RE9A8IR9+NFhii7tB47GKGSKA0THx+RVuek5kfFUWLqVd/U55ct8UYGZHWhpcxh5B9XWaim4rxukCyAClVTy4LWGaeyV6MC3Abn8BoabJXB2SyTYNztY3AlNggInExlN1IF61jdJA3bz9kb0cpzGXgt5QCC2xc16x5AL4iJ0QV/FZe/LteInShQ3JZRhAGoPtDBO8JaTj8KVZMkDL+uE4qxj/ryjZQlo/QTZjoaydKpT/pj4zppJvu/6C8hPgEsxJ9Pl5OOgn36qjM7oum5Uely1Wkc+CXFh3RKPEl9zEKlXv55Z5oC9V/4z32HYQFBho5b6Oex8/sV5ad6qTunAQZMKg49v7xD0Pc8P4h7m6lqm0TEfJ61B76lZavjCHhO4d5thiEPUL522wsP7IZ2A9i3N0Femjbaoaj/2lZncZMkvuzFrG+oxAj3Dh/129cT7+J9H/NBuyiMf+FR1y1PGso3LcZo3t6JGFvN6Y81JTnfqKF5dRfPRzWhDGD0+VMy/fNko86QXEXvuj+m28V8KHAIaO8P0s/fTiGd1
 0oKIAnsT
 HB+jlLCKVpzS9fDIGpcUag8S2y9u39lCmqIWQvvl1oWOuAGQrkTpHjiNhMEjxaoJXEBNZ7PG6DrOIbZpjzfUSd8H2SuNGfuabyf2az0aqZCMcXfBSyVw3VhXP85/F1TRB9hC0KJYfQs999wghzkMRlQ68q7k4JnrFUumFkVj6uI8bDCc2B9bjwjOYFa5cY/sPkEWSOavJr5V3jEM5bmRmsz047t/rKumRsH+DSvI2ikCsaQ4enAjzSi7hfSryNxPgpdICbNI5eAR/7Jw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, Nov 10, 2026 at 03:44:18PM +0100, Andreas Hindborg wrote:
>> This series adds a way to copy data between a `Page` and memory that is
>> shared with actors outside the kernel, such as user space threads or
>> hardware, without introducing a data race.
>> 
>> The copy is built on `SysMem` from `kernel::io`, which already accesses
>> system memory with volatile or byte-wise atomic operations. The series
>> first makes the requirements of `SysMem` explicit by requiring freedom
>> from plain accesses for the lifetime of a view. It then adds
>> `atomic_per_byte_memcpy()`, a wrapper around the kernel's `memcpy()`
>> with explicit safety requirements, and routes the `SysMem` copies
>> through it. Finally, it adds `Page::{read,write}_bytewise_atomic`, which
>> take a `SysMem<'_, [u8]>` view of the shared buffer.
>
> I am still completely confused by this. In what universe is your magical
> atomic_per_byte_memcpy() not memcpy() ?

This Rust function is the C function `memcpy` in all known universes.
The commit message even says so.

There are safety requirements for calling the C `memcpy` from Rust. This
function makes them explicit.

If it helps, we can rename the function so that it is more clear that
this is in fact just `memcpy`. The current name was chosen to encode
some of the semantics of the function in the name.

`atomic_per_byte_memcpy` is different from the "regular" Rust memcpy
function `core::ptr::copy()`. `copre::ptr::copy()` is lowered by llvm
under the assumption of no concurrent accesses to the buffers on either
side of the operation, and so may generate code that is UB in Rust under
concurrent reads or writes. Examples of problems were given in v2.

We need a (Rust) function that can copy data from A to B in the face of
concurrent accesses without producing UB. This patch introduces such a
function, which happens to be just a call to the C `memcpy` function.
Letting every user call `bindings::memcpy` directly would also work, but
then every call site has to discover when that is OK. A Rust function
gives us one place to enumerate the safety requirements

Best regards,
Andreas Hindborg





