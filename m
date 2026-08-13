Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F2A8C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733AB6B0412; Thu, 13 Aug 2026 04:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B2A6B0413; Thu, 13 Aug 2026 04:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC2F6B0414; Thu, 13 Aug 2026 04:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26E366B0412
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:48:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CADC120530
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:48:39 +0000 (UTC)
X-FDA: 85095620358.05.0B5EA3B
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	by imf17.hostedemail.com (Postfix) with ESMTP id 114C140004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:48:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gWPrhjFc;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786610917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knfP0sLiSiIgOeAER2lQBprLxXjpRNIx+n8hv3tYL7c=;
	b=uFge6ZeeFdbYbJjrCiiqRSA98LeQruGLnwYYHXqKP1J4slvQv34yMnCPz2oXcBC8Jfol9h
	C15QSRaO2SxJBibfn3G0z6TO4zy6c/FnSvjCytiSnkuSIbm/R3t74q1DfxXPhUgg7UyF4+
	Jb7t7E0huHmUjctPnxtKO4lpry7i07A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gWPrhjFc;
	spf=pass (imf17.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786610917;
	b=EqLMN5cxRF3Y9lYovB6z8+qKw0xvRlZg1/Byd7c62/p7nEs05TyeJpei0ALZ44FS9GrEhp
	hOoDZ6l9rfkkI4BYQ2+1opgBGlCWnOjkOFmXLuong3LQbEyIazBz4qha5bFVqflEzqCdLr
	5oudPED7NcwvD5hBlaw/ukXx6IMsgnA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=p/XR4dg0T6N6IfkAMZsaBbcOqjAF0woNribrNFPWFpw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786610915; v=1; x=1787215715;
 b=gWPrhjFcy/OvwV5S+26LkK6yZVrPhXS7urmZBanQZUcX+IDLdxHymuWt8a0wdrQoM4qxj18H
 xg1vser9KsP6KJmDdwDajOEqXywP2ZKPh2O752Ag9Rnby518qFBi1Bk517cOT/3PoUixyBy3kHr
 v3iktNl4iEg1PlSiIfx+q6jU=
X-Envelope-To: linux-mm@kvack.org
Received: from webmail.migadu.com (2001:41d0:303:fc7a::)
	by mta12.migadu.com with ESMTPS id 1be4d382c922c9e0;
	Thu, 13 Aug 2026 08:48:34 +0000
X-Migadu-Flow: FLOW_OUT
MIME-Version: 1.0
Date: Thu, 13 Aug 2026 08:48:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <93e42fc2cd73bb1dd93fac74670899366ea58947@linux.dev>
TLS-Required: No
Subject: Re: [PATCH bpf-next 2/4] bpf: add bpf_thread_wq kthread-backed
 workqueue with cgroup placement
To: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Alexei Starovoitov"
 <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "John
 Fastabend" <john.fastabend@gmail.com>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Martin  KaFai Lau" <martin.lau@linux.dev>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong
 Song" <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "JP Kobryn" <inwardvessel@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Shuah Khan" <shuah@kernel.org>,
 davem@davemloft.net, "Jakub Kicinski" <kuba@kernel.org>, "Jesper Dangaard
 Brouer" <hawk@kernel.org>, "Stanislav  Fomichev" <sdf@fomichev.me>, "KP
 Singh" <kpsingh@kernel.org>, "Tao Chen" <chen.dylane@linux.dev>, "Mykyta
 Yatsenko" <yatsenko@meta.com>, "Leon  Hwang" <leon.hwang@linux.dev>,
 "Anton Protopopov" <a.s.protopopov@gmail.com>, "Amery Hung"
 <ameryhung@gmail.com>, "Tobias  Klauser" <tklauser@distanz.ch>, "Eyal
 Birger" <eyal.birger@gmail.com>, "Rong Tao" <rongtao@cestc.cn>, "Hao Luo"
 <haoluo@google.com>, "Peter  Zijlstra" <peterz@infradead.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Jeff Xu"
 <jeffxu@chromium.org>, mkoutny@suse.com, "Jan Hendrik Farr"
 <kernel@jfarr.cc>, "Christian  Brauner" <brauner@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Brian Gerst" <brgerst@gmail.com>,
 "Masahiro Yamada" <masahiroy@kernel.org>, "Willem de Bruijn"
 <willemb@google.com>, "Jason  Xing" <kerneljasonxing@gmail.com>, "Paul
 Chaignon" <paul.chaignon@gmail.com>, "Lance Yang" <lance.yang@linux.dev>,
 "Jiayuan  Chen" <jiayuan.chen@linux.dev>, "Emil Tsalapatis"
 <emil@etsalapatis.com>, "Ihor Solodrai" <ihor.solodrai@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <DKNHV09PBQZP.IRQL20BY574I@gmail.com>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
 <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
 <DKNHV09PBQZP.IRQL20BY574I@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 114C140004
X-Stat-Signature: w7nc6r7qpoxi83zxcs7cmed69t3xfjtg
X-Rspam-User: 
X-HE-Tag: 1786610916-19263
X-HE-Meta: U2FsdGVkX1/HBfmtcgCNbw3l+6GxPoGmkun5ELaeAfgQIV3DSsTLCxUnzYLifbl+BdWyd5GPsqABAeo6brqtxhpdYl5NVCFv/gmaHYuKtHvIJYiI/2o/BbuPtpe2eBeabufQKgeCvFj4zdTkayDW/WN3TwLIYlGJbueWWZ1H3O8Bjjzkyr7/psFyIgbYpHIbYBRlagz0MNaZs23N+Ma4MhHiz+IMce5shQgKAQZ4N0l+8raHTFLVsbTy5GuFrSXtu4Z9Tb5j2DL0kR0Hl1TR36LtqJBY/MKu/fQL5Rp9cJBFY60pKjqFXadBiRaI1YyeXnA8cxbzztZVl6WbQ0MiyKplQIu1Ra3EupjKJS3wKVrDAT1fcmkV1OEHN2NcZwRCL+DmDPcLucLhAzfddRgtG2vlSt+m2exC7XEBlOPpMrN+ZMJIYJa1IMtMtMMtCG4qt63TTCx/7+4p4iEoLVkrRZwv4ZCWq3BP7wtt1GC3gAZjIX3atM8wLzVaLG8oTlZ+2EphFDtTMwQydS39UkF6QmhAXYio+vTDw34B6m64CBjaRAJr4mUhhJN8uciPmMmbvvYg9Pt77PZtpBDzS9x4Td9wcHOTC0NEdwN8gDFDEgNCsGCTsD14cOcG7GakP3qBMLPDpMCDFp2AltxBi5QC+6qH7/XnKKoE9axA01Zk8xPpeXWYBQG5yanoNbfgsM6D7tnLHhjdWycCmcJNuSvlXRTJTk2gEeLg5MnNAGfYoo7i5a8qETMsn1xD/15A9KwKPF415wCXaa2iLLV1mmEDxx7CCZBfw94vuMFa06fKn19vBID56y660wVJtWBCCntUiog17jIm4MkL3eT/kBRLnK2bGWfPlldCcCwSPuej7OFuZZylsuFRUm1i+siDtejuNTpnKVqHclDXZgFUPD0XHDOXAlTZ9kgIoji7w9Dj/aEshJWwvvHjE8ZMhF1d/yDyvd5QX4dlXYauCaGKOlV
 OsW62TTI
 BO8jSqdnqvwbZUZ2zt3RLAYuUMY6/51Jt1D4yGun/IQefwYxqVzg2RXUA/mHKCAFWnu9g/lYmhezveIpVF7v56DxQjb+Jjnkz090w3VCJPQ6DF+DonDe8F7SNhy6vq1Ebp/UgBkJRDxTdklhcuZc4JlW93Y6DoISCrFKrJ5NpUbrSCl/oVdSTorokaYw0rqDTKphGJQJGgJTuabdbAy+ckoztpEzgL9Ws5GGEo4kTwP6yZr+hRwcG4Ge03QUINciAd7NodqxQ+tKPljrnGMNSdTQU21LxFLsFIrPjLJCxHWU0T0ur4lgR/AnattcPSQTSlwa7JF4r+wPejp82JSGu/XwzxV2SpCeRB9b5JRlSl8XXuME3wDVT8K4w0Kl4oYDV/3jsfT386wWmOnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Fri Aug 7, 2026 at 9:01 AM CEST, Hui Zhu wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20
>=20>  Introduce bpf_thread_wq, a new BPF embedded map field similar to
> >  bpf_wq but backed by a dedicated kthread_worker instead of a system
> >  workqueue. The worker kthread can be attached to a specific cgroup a=
t
> >  init time so BPF-deferred callbacks run under the resource limits of
> >  the target cgroup.
> >=20
>=20>  Three kfuncs are exposed:
> >  bpf_thread_wq_init(twq, map, cgroup_id, flags) [KF_SLEEPABLE]
> >  bpf_thread_wq_set_callback(twq, cb, flags, aux)
> >  bpf_thread_wq_start(twq, flags)
> >=20
>=20>  bpf_thread_wq_init() is registered only for BPF_PROG_TYPE_SYSCALL
> >  programs. It creates a kthread worker and may attach it to a cgroup;
> >  those paths can sleep and acquire kthread and cgroup locks. Restrict=
ing
> >  init to syscall programs prevents it from running in BPF contexts th=
at
> >  may already hold locks which could deadlock with those paths.
> >=20
>=20>  bpf_thread_wq intentionally avoids the bpf_async infrastructure us=
ed by
> >  bpf_timer and bpf_wq. That infrastructure drives cleanup from irq_wo=
rk
> >  in hardirq context, while bpf_thread_wq cancellation and final teard=
own
> >  may need to sleep through kthread_cancel_work_sync(),
> >  kthread_destroy_worker() and a final cgroup_put().
> >  bpf_thread_wq_cancel_and_free() therefore cancels work synchronously=
 and
> >  drops the context reference; the last put waits for tasks-trace RCU
> >  readers and then schedules process-context work to run bpf_prog_put(=
),
> >  cgroup_put(), kthread_destroy_worker() and kfree().
> >=20
>=20>  Add BTF/map support for bpf_thread_wq fields, map teardown hooks,
> >  verifier handling for the callback kfunc, and cgroup_kthread_attach(=
) to
> >  move the worker into the requested cgroup.
> >=20
>=20>  Supported map types are BPF_MAP_TYPE_HASH, BPF_MAP_TYPE_LRU_HASH, =
and
> >  BPF_MAP_TYPE_ARRAY, consistent with bpf_wq and bpf_task_work.
> >=20
>=20>  Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >  ---
> >=20
>=20Hi Hui,
>=20
>=20Thanks for sharing the patches. I think Sashiko and Mykyta already po=
inted out a
> couple of issues with the current implementation, but I would like to c=
omment on
> the higher-level approach.
>=20
>=20If I understood the past discussions and current set correctly, the r=
eason for
> your choice to move from bpf_wq to bpf_thread_wq was primarily to enabl=
e correct
> CPU accounting of the work done by threads to specific cgroups.
>=20
>=20I think this is a step in the right direction, but looking at the big=
ger
> picture, I feel we need a more flexible solution.
>=20
>=20In practice, users deciding to do async reclaim through such a BPF in=
terface
> would want to scale and compact the number of threads doing reclaim-rel=
ated work
> dynamically, based on available idle resources, but also application-sp=
ecific
> metrics, and I do not think the bpf_thread_wq abstraction provides enou=
gh
> flexibility in managing work scheduling related aspects precisely.
>=20
>=20What we probably should expose is the ability for programs to manage =
their own
> wait queues and subscribe kthreads managed by BPF programs dynamically =
to them.
> User-defined policies can dictate how many threads remain active, wheth=
er they
> busy poll, and when they go to sleep, completely under the program's co=
ntrol.
>=20
>=20Looking beyond this particular example, there are cases where work is=
 stashed in
> queues, and threads draw items from the pool and process them. In such =
cases
> having flexibility in deciding the mapping between threads and queues i=
s also
> important. We want to thus allow management of the work item queues fro=
m the
> program itself, and not hide it behind the API to offer the desired lev=
el of
> control. The order in which items are ranked in individual queues, and =
the
> order in which queues are processed horizontally by threads is also a d=
esirable
> property.
>=20
>=20Correctly associating the BPF-managed kthread to a cgroup should stil=
l be
> possible in a manner similar to what you did in this set. But the amoun=
t of
> control programs can exert over how work is scheduled and the level of
> concurrency will be much higher if we disaggregate and generalize each =
part of
> the picture (wait queues, kthreads, and work item queues, which can be
> implemented in BPF itself).
>=20
>=20I am not aware of ways to back charge time spent to remote cgroups, b=
ut if
> desired we could also explore that option when a single thread does wor=
k on
> behalf of multiple cgroups. It is something to be explored.
>=20
>=20I've been working on related patches, and will post RFC set for bpf_k=
thread and
> bpf_waitq management in due time. Until then I recommend that you conti=
nue
> experimenting with the existing async execution primitives for now.

Hi Kumar,

Agreed, the disaggregated design sounds like the right direction.

I'll keep updating the remaining commits of this series, and wait
for your bpf_kthread/bpf_waitq RFC.

Best,
Hui

>=20
>=20>=20
>=20> [...]
> >
>

