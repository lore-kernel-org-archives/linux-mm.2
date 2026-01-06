Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1718CCEFD03
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79FD86B008A; Tue,  6 Jan 2026 15:20:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781596B0092; Tue,  6 Jan 2026 15:20:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ADEB6B0093; Tue,  6 Jan 2026 15:20:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 586C26B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:20:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05A1CBC9D6
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:20:14 +0000 (UTC)
X-FDA: 84302655948.04.E67D088
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id ED29540008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:20:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eqYCS4Hx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767730812; a=rsa-sha256;
	cv=none;
	b=kQ1tEyzBNsz36kug7b8kOwrLLx+5o/VbwRSVz7YztTY9fYcnh48mbk77g4kPWmG4Y9tDwu
	0sH/l1o38m5fTO9vThEp9LlAscGCOYvrzlOHxNnbjgN0RgK4ImnNpfAT4dZC55PFXbEpEl
	adgwVwn5UdJtIpmCvvVZny2Fnp2fjag=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eqYCS4Hx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767730812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1bW4Kxn2aWPyVZIZdur0x49cptxN6M7ZG3iagWVUS7E=;
	b=6JD2y379DoIgmwdeADYEFe3hOmuj8gj47fPJdM4q9Di1J3rlPsdkDWRYCLteNrT1nGbJGS
	WE6pUNYcbudiR+tAuwHYEyngdkoOkxFv+V5vWjFl7xY00BCsz2DDKxAC+KcfSSF2+6zWev
	pykezbTi/c1MJqVYGp/5N7M7KWM64Q4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767730811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1bW4Kxn2aWPyVZIZdur0x49cptxN6M7ZG3iagWVUS7E=;
	b=eqYCS4Hx/S28b+pq8Cuxp8bw7hqGonYAWBmnrfFIOyXrG+bSWCeWLsKFum3S/cLJMY7ZUq
	Kf200bivxeOuuVC+2AbEps2J+iwF4KRVOmmYfpwRGGxn/otkflLoWYni4rCJ3TZz9swm2T
	3faMeUou3eBr1F+ebObdXTE/kC3BhaA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-31-WhCe1Z4OPvytjcy9zbZx6Q-1; Tue,
 06 Jan 2026 15:20:10 -0500
X-MC-Unique: WhCe1Z4OPvytjcy9zbZx6Q-1
X-Mimecast-MFC-AGG-ID: WhCe1Z4OPvytjcy9zbZx6Q_1767730808
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E46EF195DE56;
	Tue,  6 Jan 2026 20:20:07 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B8D419560A7;
	Tue,  6 Jan 2026 20:20:04 +0000 (UTC)
Date: Tue, 6 Jan 2026 21:19:59 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
    Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
In-Reply-To: <j3dy3g5mchtdzxldtnqu5nwaalbr6ec4ceim3nuu6nwcddmqjc@7dgzr4m7pli2>
Message-ID: <6633f8ed-f432-f4c4-3fe2-8c14248cadab@redhat.com>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com> <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7> <e60858c9-12a6-2b04-35ae-9d676f14db2a@redhat.com> <j3dy3g5mchtdzxldtnqu5nwaalbr6ec4ceim3nuu6nwcddmqjc@7dgzr4m7pli2>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vodq4_bi-5T1RDlXH95Tjf8M3_1jg2O8m4EQLB431mY_1767730808
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: ED29540008
X-Rspamd-Server: rspam03
X-Stat-Signature: mhok5shob6hm1c93q71jjug331rzchjz
X-Rspam-User: 
X-HE-Tag: 1767730811-584265
X-HE-Meta: U2FsdGVkX1+lolnwi6BY+Hrl+uBWL33l+5bxW+S5ucHwK9CTF9quA45QS8Q10SY/3dcJIYMrscaZORh24NNK9p40q/l9hEB4gJZfN1dCg9fk68LiuGvo93SFhyaN9eCXiUiwVfIa+d+Oifx+BubuGvCcOvVpa2zsX/ji1YgXeSN8Ehsz9v7yK+zT9nDyeiQzMnFURuSD51b2mig+j//rj/4/reNdO8nfeC/fsuG4R1TxU341DuYtoCCJ27ho7IkSxmoenA9pDXbOQQpUGwXnmilp1vXutDdlER08Pab5apU4Sw3k/4+bYn8WCvgap3Szdd9eMvy0vi7lfylFm4HjDglIaQkxaAm6eeJMQQD65fhfrG4JzGJFxf7eNTguEzSnNnsegTY3c/tqGaMuuMqhCBSFzy9THzsntY5xnZjpfVSCvINBqMmJTgn+D9R/zBTG9PlkYpBsdzgTeRd7nRZHEgurKeoM4Ks6nlaxGtRO0OpLdEYc81bGEu1q9UjVeHey0V6NrXD9Zw/MGbsVrtyMuGYINb0jreP5J4hBa/x073OSfRiyKGH2bGa/IAcNnhz/8yk6O2LZJORfWeOTKKyPQmfBRZMM60KqxKacxS0u9tU9BXC25N+pA93JHA2s98lIr0tyIfI+wtxDJoWkZn7FqXLSADd7kjDihS81olOKFK3FkShJBNFkPTwhB2IIi+IlTRzn4+33IqTkX0Bc1bGoMqQX/X+JvByyQfz59tCFiTwCP3MdhoETrxnwxt6CMHs7V8z/CQJsJ2cWUy+04XqAE+6MrvR6mRnv955cczFb1tzUDKGCTrJmvNtFQ29b5WCEFHTRXQmY4RqSewIeQAq45KrLXS4U2nnTG5ZQpq+/W7LfB5/lmlsz+e6Mwj2QivNBVgj8toqP/EOTtGGxP3pCPDTscLOOxW5Dk/U7ULmsmwGESmBEMLzcMfKxKek/sjDIGuTjeonX2yzfw6OZRYE
 tdq5uWtc
 XPuMFza7z8Sxed5OJ3dj9rcBvkg9Gzt7KQP8OdL/sRfDxkzIBStA9Z+xF5C2vv+1hqhW34ApRV4+EnbYZtL7zf5xEwOar7e0XWERfTwtncHJJz1/BwxaZf+qyhzSVmTHjkgj8cmSB87bEeBp39lXCkM3N8TqVN7m2AOAHeDFr87U2cFnFHdA00LJmyZZiAJV8pfH0cfGTX/28RKmit7G29ckDTTaW04pnuSjYSCDLfiQBuWTHsZma7fG5wqyVn8ySCIoPHwo73JH7fbCniOiq+G0Prc7YPjpIzq1BY6mxPryKHZcM2fk868jchMwkzvBN5ZNQ/zpT+kUBRsSt379fAgKlhY1Gg+ifNhoqFZT2LspxFeA83J489w0WTkIMsMQmJy555/v2HwAM4lM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, 6 Jan 2026, Liam R. Howlett wrote:

> * Mikulas Patocka <mpatocka@redhat.com> [260105 15:08]:
> > 
> > > If you only get the error message sometimes, does that mean there is
> > > another signal check that isn't covered by this change - or another call
> > > path?
> > 
> > This call path is also triggered by -EINTR from mm_take_all_locks: 
> > "init_user_pages -> amdgpu_hmm_register -> mmu_interval_notifier_insert -> 
> > mmu_notifier_register -> __mmu_notifier_register -> mm_take_all_locks -> 
> > return -EINTR". I am not expert in the GPU code, so I don't know how much 
> > serious it is.
> 
> Okay, so the other call paths also end up getting the -EINTR from this
> function?  Can you please add that detail to the commit message?

Yes. I'd like to ask the GPU people to look at it and say how much damage 
this -EINTR could do. I don't know - I just saw the messages "Failed to 
register MMU notifier: -4" in the syslog.

> This means that -EINTR can no longer be returned from open(), right?
> Otherwise you are just reducing a race condition between open() and a
> signal entering from your timer.

EINTR can be returned from open() in cases when it was historically 
behaving this way - such as opening a fifo when there is no matching 
process having it open.

But I think that opening /dev/kfd doesn't fall into this category.

NFS has an "intr" flag that makes the filesystem syscalls interruptible by 
signals. It is off by default, because many programs don't expect EINTR 
when opening, reading or writing plain files on a filesystem.

> Any other -EINTR system call will also cause you problems since you
> continuously send signals to your process, so we'll have to change them
> all for this to work?

I use SA_RESTART for the signals. And I retry all the syscalls on EINTR 
just in case SA_RESTART didn't work. So, I don't experience random 
failures in my code due to the periodic signal.

But there is code that I have no control over - such as the OpenCL shared 
library.

> This is the userspace ignoring what the error code means and just
> aborting on any error.  This is a change in behaviour on the kernel side
> to work around what they are doing.
> 
> It also sounds like it can be avoided by userspace not sending signals
> during the open process, or even to

So far, I worked around this issue by blocking all signals around 
clGetPlatformIDs and clGetDeviceIDs - but this is a hack.

> retry at a higher level if a recoverable error occurs.

If clGetDeviceIDs fails and I call clGetDeviceIDs again, it doesn't even 
attempt to open /dev/kfd again and fails right away. So, I can't work 
around it by retrying it.

> > Even if I disabled the periodic timer, the failure could be triggered by 
> > other signals, for example SIGWINCH when the user resizes the terminal, or 
> > SIGCHLD when a subprocess exits.
> 
> Those are also not random, they are expected signals caused by events.

From the process's point of view, they are random - the process doesn't 
know when the user will drag the corner of the terminal window and resize 
it. If the process spawns a subprocess, it cannot predict when will the 
subprocess exit and SIGCHLD will be delivered.

If we don't change it, we end up with unreliable software stack that can 
fail during rare events, such as dragging the corner of the window.

> I'm trying to say this git commit message is wrong and misleading.

OK, so I'll try to rewrite the commit message and submit version 4 of the 
patch.

Mikulas


