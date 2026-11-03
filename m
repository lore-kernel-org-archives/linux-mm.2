Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01034606D2C2
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZroKgEVj
Received: by kanga.kvack.org (Postfix)
	id 2208F6B05B8; Tue,  3 Nov 2026 10:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1EF6B05BE; Tue,  3 Nov 2026 10:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C11A6B05BF; Tue,  3 Nov 2026 10:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E24216B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84C0E1A0480
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:17:08 +0000 (UTC)
X-FDA: 85394160936.09.D1BFA0B
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf30.hostedemail.com (Postfix) with ESMTP id 96EFD80015
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:17:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZroKgEVj;
	spf=pass (imf30.hostedemail.com: domain of 38PrpagYKCOsfRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=38PrpagYKCOsfRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZPyGNb7zpjaaj961jv5er4Nb77WoHldzauRxys7WyE=;
	b=3FGg7WHgNKV5Kzq/kGCxcxEosj6qxfmZNtjKlNzkjIiQdu7DuNHVZmFRXlP2SDkAy3jRMY
	Dh1HtVjNmQajZtkbSDUwgWsuwxwKSIIL1+MmdeHjyGGgUK7RV31YtJYtSRvEeoGXCV0Ozy
	l9KcDddhDHZxmi6yGy1/1MuC42O4paA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZroKgEVj;
	spf=pass (imf30.hostedemail.com: domain of 38PrpagYKCOsfRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=38PrpagYKCOsfRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719026;
	b=Y9sxri0/qLXYGxNpn1ow1sPne/hPYbShG1+y/huQCmVvHk86FAbob4O6q8pfyLbgPrTBlf
	z+2kTI+4je+SrfpDB2QDGDaAILfrZQKu3Apk/i/UXr95kGt/43VV4LC40tGrczWbE5VZ6s
	KjyZo7xQ5x5PCdrUqnKMnupthlIPTbk=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e9995cea88so42229195ad.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793719025; x=1794323825; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gZPyGNb7zpjaaj961jv5er4Nb77WoHldzauRxys7WyE=;
        b=ZroKgEVjUULdRxxyGCZkNY7964s7GPVB3l/iEOXMQuGJKp/XZywiwaScwUKI1WGHtR
         T8vFiiQAfsBgiYYRC5E2pQ6ZoK0ZfSHb+Jfkim4acjNRZl1+fWo0MOkmggK2Ff19gy1o
         JHloXJ1kTizmFRxu7flexS8Ll0RdyknKsFA8YO+ZOOH2eRngCNu/g6ru1D1oOwBY6D8T
         0ZeNF95CdMdXgCPdmYD+770/aNH4vTYIQYb7YtaBs3VtWm8z+K0Rpdg1SyLsZvRvD4I/
         1I1lxUTijcksFZIJHxcBmdlHyZcnKBMMX9eWsjHabEMSO8A6USc18yeQjN89h876JbEh
         Kmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719025; x=1794323825;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gZPyGNb7zpjaaj961jv5er4Nb77WoHldzauRxys7WyE=;
        b=2mgB2g847koG0q75wu+I5Gv9nHwewnQ8feac6AoQ74FJxJmJtbWSE5IQ0/LwjyGI5E
         vEBFf8bPBY4sUd7wfl4/2Il6l+K5cjZekUdvLW9W02rWI54PA5zxt+Ra2W0aENddkRW5
         ql/vaHSo5Zd8q7Xs+8olickXWvBVoFaikr6ZRh0aPnf8f5XtofJNsq0Nn+BfBx5AXHkU
         uWwqmXC47IJ+Cy7svivPJ0VYsfp2xfYNc8ZNw9jjlgSyEM+2vS8HS/zqKSnSvKtVlQz1
         Y4h8iz5de+1wzhbn2GE5312mKTShBYmiTU67zqv2d8/dl8DUeDvgw30ZMY8yDC6MW0y6
         a7kg==
X-Forwarded-Encrypted: i=1; AKwUvBwqatwb2VPU2Jv09vWE36F9SSEjtYCGgWIXD5zv34oY9goclNExOEypNyRManGVy8ZQvZvsr/vh8Q==@kvack.org
X-Gm-Message-State: APuU4Z/3d7NoKfvwZ7mANOh67rq0S5sw3gOd8AHIPORNvCDnXEz1kMyW
	IsZXnSM8O1Klde7Y2gevRaT4F8B8/8F+Lc3OHMIMkfr+N0yilap2paaqJfq+hs2+BzTGbwCPmOh
	yRwJX8Q==
X-Received: from plsr11.prod.google.com ([2002:a17:902:be0b:b0:2ea:d63d:f2c5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c3:b0:2e5:334f:f47e
 with SMTP id d9443c01a7336-2eb36489c9bmr122626395ad.21.1793719024883; Tue, 03
 Nov 2026 07:17:04 -0800 (PST)
Date: Tue, 3 Nov 2026 07:17:04 -0800
In-Reply-To: <CABgObfZ9mHj7Fsq7Z2S5vFy8R2Gkh2tHBATGJN2BpH=6Waks9w@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <6adf2939.67317f00.38c4bc.00ae.GAE@google.com> <20261026224305.1254-1-hdanton@sina.com>
 <auCucDdZb8mig7UZ@google.com> <auDvUyfzg6nLtVox@thinkstation>
 <20261027163929.2bb28d5b@gandalf.local.home> <aujLx1FOc12E72rF@google.com> <CABgObfZ9mHj7Fsq7Z2S5vFy8R2Gkh2tHBATGJN2BpH=6Waks9w@mail.gmail.com>
Message-ID: <aun68Iv_z6Xiz9mc@google.com>
Subject: Re: [syzbot] [kvm?] WARNING: locking bug in __refill_objects_node
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Harry Yoo <harry@kernel.org>, 
	Hillf Danton <hdanton@sina.com>, Boqun Feng <boqun@kernel.org>, 
	syzbot <syzbot+f11512d1e5878ba5e60e@syzkaller.appspotmail.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzkaller-bugs@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: we7jixrqoknm77tyjsqgk5qxehsaarh1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 96EFD80015
X-HE-Tag: 1793719026-534564
X-HE-Meta: U2FsdGVkX1+ajEOuH7WTWWrritt0e1JjQ7xq5XPcopYxHIbv4SwmXo9yCDAeukkKJiXQYGzgA00PuEirD5TdY+KP5lrwbFc2Ns3EnfOM5ncZhH8OPQ+a2z1Ody+Zen3qZuLujXGWVdMvelBhxj9srtTJikX1XhhlmvglRPNAGjSR4xIW9sEGj72DC/EuXonOoUy5Z922J4Zbt3i2lCn4G+2v7wFCfwhYB/KvLw99V2icfaUPGF39TLHYTcLY0Xdjs0tDJf32H+qtTmxyzHqauwfKL43LNxNYzt5+CkZRQQ0l4cnDuyUBe+GiLQdCk4dRoq7U9d3M5vezaChJ5R1/K20F2rr9rw2fM8ZH+2w4KBn3oThe+86VRZfyt/r2IYroPpHym6ruSdmUYFCNPD1wtUrDMxY1SSq8L/d+wqm6Dd2zt6jzljrmrskMnZo0sX6OmuZkFJ8ymnDgqE5POfOcd9PH5biKEmYEu0X7CwE7JTs2gE2UHCgyviaEKzfaMmLnfQrknAArgg+1kpcQkrhgXNF16xn3dtC9wivRVi3NkKTeEsGX7WqzaAOW6hy3Twbb3zgYRikOCXX3jpQBSVNMvdG0wcOU0YTEVNlXxVJVbv1taxlrI7HoZPrxIBfUiROIxWRJ7gnRzgiHK2v2c8fBgicD4yTJ++dTHlydcGEKoRyhJfm+0ri47uN50A10TmUi1E2VMFwuuiqnqYKO1LkiCR6WXS3R4NXID8Br+YAf7FA5nurNgIynyw7xydw4btfEEID41pI3UE39SHMsl1/A9s6K2NXoPDvQmYqfpcAQn6kowj/cq/ZFUey9zxTBiZ1rqMB3few2MmmOuOL6RTVNhFcuIhLKnPdH/hPd4/Yu/jsPWDz3BSxGhTkfckpLuCMt9m5osoJdctUDsVNcYCc3ZHryn87vPF8H+scRQiTiXHxG1VTR28zme4oOccAUgnlUU4KGAcLLcvxFpbj0vOO
 tYaTJz0s
 uI/m/2PqMCdY6V5WH6EjfHnvjW1OAyTo62pgsCnQlGSM+APl2W3R11GWw8FS3BAlO6gCYexBWgZXeRaqTEO9ZMzSICNHVX7qxY0ZByNDW97uxPb4r7+h4im9rqkcg0e1UVPiDNO3p+wghe6B3vzF03r5pkSotQV3D4zIlza9BStxodsC7tvQ7+Yhqw4nyPJBUoo5/z5mQ8vvCdup0Bcn0XT0a9h/zg4yExkLEMBnUXUVmMQwJGj4Aux+YRigDkZyIgxUzWbRSC5bKcOaIHI6G38fR/QXsp4Ke/lHM3xWsGmcuXJ97wLzr4wN+f8gUyj5Puu8ZAbCm5B/tkBW4pdpgbs5+YHLuyehhGp85UOYS9aMMq2fOTUqulEc5p+cQI0aR8BSNYcRyD+libvtDzptWmxKFZB7VQghN4VMKPxE+nIIp8BPAfs/oC3JgbpngXGD8lv7+gy8YbNrq+7/aUc2L2Mq5FcnL3w+ypwpV6GRUsUAalSGZta3XjUjGGtcTVHb4kc0ael5yiX99PQJsLliQZeFJjsY0Yt8Oo++SRxKBXq/AZnZiwylA78aNScru2Ua45rGJEXmqK0wv9kB5wuSXC4xKLwGgZfZ6x8g7cTSTu07oul5fEp8CYlHve16KGi1DHSIYV0SJDDXMJ1v/tZG8wytVoB5Fqv1UlOpZkdeAAX6WW3y8bc27ooEJZ9+wItZMjr+NlraG8qfMuXoyxXFLxOFg6AG9dSY4M1s/OkZsNZEMud7bS9a6SC5J+tChtbctSL/PxZFXonxnR9cL9Ko9Cbn7sbFuqIs84zxMZ9wLOX0xt54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026, Paolo Bonzini wrote:
> On Mon, Nov 2, 2026 at 6:43=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > > If so, we need to make that a thread for RT kernels if you want to ca=
ll
> > > kzalloc_obj().
> >
> > Eww.  I can't imagine there's a sane usecase for memory overcommitting =
a real-time
> > guest.
>=20
> While I agree with the feeling, the dummy allocation path should be
> mostly dead, because page fault should never (?) enable interrupts
> before waiting:
>=20
> #PF interrupt gate
>   exc_page_fault()
>     kvm_handle_async_pf()
>       __kvm_handle_async_pf()
>         irqentry_enter()
>         kvm_async_pf_task_wait_schedule()
>           kvm_async_pf_queue_task() <- registers waiter
>           prepare_to_swait_exclusive()
>           local_irq_enable()
>=20
> The dummy allocation path is only reachable if it's an L1 hypervisor
> that is getting an async page fault while L2 is running, because it
> enables irq before the call to kvm_async_pf_task_wait_schedule(). I
> think we can drop the dummy allocation for good, which would be even
> better.

+1, I completely forgot what this code is doing (although that implies I ev=
er
knew in the first place...).

> Whether you would still want to disable APF for RT kernels is up to you.

Nah, on second thought there are use cases for async #PF other than memory
overcommit.  Whether or not they coincide with PREEMPT_RT is debatable, but=
 I
don't think it makes sense to go looking for trouble.

