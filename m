Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD24EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEEF66B0088; Tue, 28 Apr 2026 09:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6736B008A; Tue, 28 Apr 2026 09:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCB16B008C; Tue, 28 Apr 2026 09:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8D056B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:41:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8513712016E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:41:36 +0000 (UTC)
X-FDA: 84708076992.27.F5596F9
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf28.hostedemail.com (Postfix) with ESMTP id 249CAC000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:41:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=bqtKGOP5;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777383694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6dtIaTvbG8kHNlcuTrpQlv4YvEPbNRPpSEHmCm4a4E=;
	b=F8gxmGX2Pjwdj4SDvFrWLOD2183cWT4KWkvv63850TgmLUAN9P8LuA0eRHZDcDgxzOrgut
	ppqbT5dU0t0vxhhVNMLVklNXgue16Bj7la/HXzRtkuRDEMpeh7Nh1HNs9e7aJ7E+Weq0Li
	tyou07HB4aLndHPkV5ImKbMItIU+Tgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777383694; a=rsa-sha256;
	cv=none;
	b=jkUahTOFJIAFnANM/FMhn2dIJZlGV6rjSX8I+GpVdR9+EY3Yn2DKnTuI45uaQ43d3UoXtw
	KBsQ4QEK6pBHAprDeqlY8JV2EsqVWG8wGf8ZrXcF4zypavAPEIKaHUOXXjGOkuRarPNXoT
	jFsPH3dbS/dxbSoDXlB/4UJc1c+KQQ0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=bqtKGOP5;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf28.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 31D14C79E0;
	Tue, 28 Apr 2026 13:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777383692;
	bh=V6dtIaTvbG8kHNlcuTrpQlv4YvEPbNRPpSEHmCm4a4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bqtKGOP5PM05ry5CtpcM6JwZwXvsc1Nid+SzBNnvadJGEG1J3oIJQ2e/JH2DvC/X7
	 z35tO8Di/OLbLYTVbK/Q6vHgtk5VnMYdP5kOtsQKGpafJg4OjuckiA35HaJmYRcA81
	 xpvKLdkAWnDp/TfEbtkvN5YZ9TxcHv/KQ3t+00xY=
Date: Tue, 28 Apr 2026 13:41:31 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dan.j.williams@intel.com, Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <afC5C6fylF4AsITV@shell.ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
 <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
 <20260309164516.GE606826@noisy.programming.kicks-ass.net>
 <afCS4d4YccQFtvpi@shell.ilvokhin.com>
 <20260428114721.GV3102624@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428114721.GV3102624@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 249CAC000D
X-Stat-Signature: 3z9meuezbeigj96rrbp6hnyo619ngs5o
X-Rspam-User: 
X-HE-Tag: 1777383693-271130
X-HE-Meta: U2FsdGVkX19AIEMIHsrunjBjxfgOYI2qBnJsrEtjAlqzmtjy79m85Px3w7/xTAI9W4tqDcUgLoIxCG6DYdayqkGF6zA6XO5YYrjtBUVuffdj8juXu8xQ+tbxJVfoiw4nC/DtSuGuJ5kPiyQJ+e/yaSmSgFxhU/quFxzLZa3uo/ckpGCQAvOjAWjTL/IJrG5ZU8PtZ1zlj0d+Z6qR2abQ/l1PkRIhgoWojFdDwQru4V8Aa/QkgoSzAPqrhzA+XAi4BeeoqgrAOxoVc7EvKe5tg7k8FuCbP5aeFXzQgeUzdVfXcAfeVPv40lJlKu7eODbSFvDjT3DfUBSAkvU6Nmi41FTBE+JTpPhJkpb7SpLM2q5xTQQPAgQlxeIMDgbxoqFDJtOcTiJpeznc9pOM5tSAfsQK2EZJDZWX5lDCY1XKZTmcHMSAybKxjXQl1gz97+6veX6jtsaM/iFtJE0JaSHZLwENnjifSvIPpaUglfiz/ZnLXPE2JQpKymIi3lOIY1KM1yimF05Ax1YOIjOf/JoExUZ1FpisYmMn927CmjKtryv9/kpRq9w6UdwXqC9jQ9ne2REdzQ0CrZuaZaaA/7qev8He008to1igt+FWUc2MQ7sMAvk3Yp6XEV5VCeaZAgfS5XkcuTO58BNG7gZlE/PTEpY03TnR/6S5TDedBho+wWO2PXG3slcG9wd/1Ga1bAtEFPactIxF+t6O3Osz7DI2JG7WEXvZMIg08pc1HmXnSxmp7AvqWKhRwwkvO+i+WM8pIGUlM6emImHRtXmhIT/AZxBVGSjUlO3ur7PybUAaJzUicIAdbPnjE08vWLgVjiukHWgqidsHAGIQfKACYWfKTFIQ73f3fY3ek2oESAdO5sc5osQf22bmU2+fvU2XEIAICeIofL/hpQQKtJTEhy/YiA7j00w4cbCZkjVEfgmns+w/AshfH0aNtc81gzj+FXwvyTU+CYvoM7SvKQdrK3J
 8AfSGeV+
 pbUtm8ECmjYpU4Np8OD8PymMVXExNzJriw+iP+bjMXRgsL2Xa39agqcnv0S0Uu707AMk8niwR1qUgLqbpaKMmbkHL6QjIaUNrxK/PBvI5/IljdMv5JSPV1NRaYHl9Ov2vBA0w6uFKtZqhL2Y7xs1zmdaH0cv9OqlUDvQuULClajXtIkFYxNY+7K/IO1I0PA7mEKBssdVIQZOTEn52UtlSMbLOrtM/GBsS0/6cYZj78ReBVP+2k9b3FP2yHVhz6NFMZ2bJ/X9l3BnXjhVpCtBJvbRGRUeaTqlS2+yEYH+T/AOo6Xzixm8g3Nu0jaTErC/8FxsTRQkE6Ou5Wi3bUDgbgq6qT0qgkVQCjjLvsvp2H/DfCEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 01:47:21PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 28, 2026 at 10:58:41AM +0000, Dmitry Ilvokhin wrote:
> 
> > I re-tested my original patchset after rebasing and can still reproduce
> > the regression (though smaller). It appears to depend on compiler
> > inlining decisions: in some cases the compiler is able to deduplicate
> > the cleanup path across multiple return sites, while in others it is
> > not.
> 
> I'm confused, all this has __always_inline on. And the compilers should
> be able to track the assignment of the variable and eliminate the test
> themselves if value-tracking excludes NULL.

I'd expect that too, but seems it is not the case. I was looking at this
patchset rebased on top of the mm-stable build with GCC 16 with
defconfig.

    https://lore.kernel.org/all/cover.1775654118.git.d@ilvokhin.com/


$ ./scripts/bloat-o-meter /tmp/bloat-gcc-16/page_alloc.o.before /tmp/bloat-gcc-16/page_alloc.o.after | grep -v UNIQUE
add/remove: 24/24 grow/shrink: 2/1 up/down: 232/-193 (39)
Function                                     old     new   delta
free_pcppages_bulk                           577     601     +24
free_pages_exact                             153     169     +16
unreserve_highatomic_pageblock               608     607      -1
Total: Before=42366, After=42405, chg +0.09%

I looked at free_pcppages_bulk() generated code diff and got the
following differences (only relevant parts).

[...]

- mov 0x20(%rsp),%r12
- mov 0x28(%rsp),%r15
+ mov 0x20(%rsp),%r13
+ mov 0x28(%rsp),%r12
+ test %r13,%r13                       ; guard NULL branch
+ je 2ba6 <free_pcppages_bulk+0x246>

[...]

  add $0x30,%rsp
- mov %r15,%rsi
- mov %r12,%rdi
+ mov %r12,%rsi
+ mov %r13,%rdi
  pop %rbx
  pop %rbp
  pop %r12
  pop %r13
  pop %r14
  pop %r15
- jmp 2b8b <free_pcppages_bulk+0x22b>
+ jmp 2b90 <free_pcppages_bulk+0x230>
  mov $0x800,%eax
  jmp 2af3 <free_pcppages_bulk+0x193>
  mov 0x1c(%rsp),%edx
  mov %ebp,%r14d
  jmp 29ae <free_pcppages_bulk+0x4e>
- data16 cs nopw 0x0(%rax,%rax,1)
+ add $0x30,%rsp                      ; epilogue is duplicated once again.
+ pop %rbx
+ pop %rbp
+ pop %r12
+ pop %r13
+ pop %r14
+ pop %r15
+ jmp 2bb9 <free_pcppages_bulk+0x259>

So, NULL check is not eliminated and in addition compiler couldn't merge
two almost identical epilogues here. I suspect the function calls
between construction and destruction (e.g., __free_one_page()) prevent
the compiler from proving .lock is non-NULL across the scope, but this
is just speculation, I am not a compiler expert.

> 
> > Given that, I think we can go further than just removing
> > __GUARD_IS_ERR(). It should be possible to eliminate this branch
> > entirely and simplify the cleanup flow.
> > 
> >     https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/
> > 
> > Reposting here to increase visibility, as several people involved in
> > this code have participated in this thread already.
> > 
> > Any feedback would be appreciated.
> 
> This would require very careful audit of all the current users, it's had
> this behaviour from the start.

My thinking process was the following: the constructor doesn't check for
NULL either, so if something is passing NULL to begin with it should
already crash in constructor not even reaching the destructor.

The only case when we'd need the NULL check in the destructor is if
something changes .lock to NULL after construction, but before
destruction.

This can't happen:

- The guard infrastructure provides no API to clear a guard after
  construction (no_free_ptr()/retain_ptr() only work with __free, not
  guards).

- guard() creates an anonymous variable via __UNIQUE_ID, so user code                                                   
  can't reference it to modify .lock directly.

- CLASS_INIT() is the only macro that allows bypassing the constructor,                                                 
  but it is only used for fd_prepare in include/linux/file.h, not for
  any lock guards.

- Conditional (_try) variants have their own destructor via
  EXTEND_CLASS_COND() that checks __GUARD_IS_ERR() and returns early
  before reaching the base destructor. They are not affected by this
  change.

