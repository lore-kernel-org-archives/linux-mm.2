Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A3BCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50616B0005; Thu, 28 May 2026 04:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C005B6B0088; Thu, 28 May 2026 04:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B167D6B008A; Thu, 28 May 2026 04:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A02386B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:27:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42CD140786
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:27:27 +0000 (UTC)
X-FDA: 84816149334.12.DEFC79B
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5703C1C000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:27:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ErYCF8Mx;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779956845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cE5vkgdKA1jGW+pTW446oAunyXUpwHm3Ex1DLaNXHJQ=;
	b=JN3beQXU6ewobnYl1tUkIkwnApKz7BWUKG/O862bcbTNPffntXZB1BXJXwMVtcBf7kMF1E
	pUR3ikJp93bww+ocK3fiakoPZ+8aWiWJNRQGlfE0XfNaa31eCPGNz+LMOrrIIpG9F4IdV4
	XE6lOLiFebt9zSMA87K6fX5ZRjKki8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779956845; a=rsa-sha256;
	cv=none;
	b=PrfXOHqgkUdOCGklC3BO9gIgS7KIfLnG41EppkLBsgK6+iT0Gxpw0EcYHtsoBpPED2hjGm
	VTdfGmseEESlsHv3zmpQGdOasuUpliI2JwQTG+SsoLa2LTQ+0ucmcfskMS0LgbLUc9PPx/
	HEDdxugFR3eQxN57eE8wO/WnraXcZvk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ErYCF8Mx;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779956842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cE5vkgdKA1jGW+pTW446oAunyXUpwHm3Ex1DLaNXHJQ=;
	b=ErYCF8MxdKKJgJ2bsChhRvd83CNLBlJQsWHOx+SWyZogRkcY9bH5Ny8445eDaQIhL/oUFl
	8W8sKYUdESXAeK/TMvkxvlL5bS/4Tp66yE/RxcSSx2K35RuksXZ33YwXhFflH1sVFt+0sx
	ngQJtc4bbMoa1pHEVEYyyAFAFjqk5YU=
Date: Thu, 28 May 2026 08:27:16 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "teawater" <hui.zhu@linux.dev>
Message-ID: <1b58d56976202f26818d31dbd0da2ecb2e2460f5@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH bpf-next v7 00/11] mm: BPF struct_ops for dynamic
 memory protection and async reclaim
To: "Michal Hocko" <mhocko@suse.com>
Cc: "Alexei Starovoitov" <ast@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "John Fastabend" <john.fastabend@gmail.com>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "JP
 Kobryn" <inwardvessel@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Shuah Khan" <shuah@kernel.org>,
 davem@davemloft.net, "Jakub Kicinski" <kuba@kernel.org>, "Jesper Dangaard
 Brouer" <hawk@kernel.org>, "Stanislav Fomichev" <sdf@fomichev.me>, "KP
 Singh" <kpsingh@kernel.org>, "Tao Chen" <chen.dylane@linux.dev>, "Mykyta
 Yatsenko" <yatsenko@meta.com>, "Leon Hwang" <leon.hwang@linux.dev>,
 "Anton Protopopov" <a.s.protopopov@gmail.com>, "Amery Hung"
 <ameryhung@gmail.com>, "Tobias Klauser" <tklauser@distanz.ch>, "Eyal
 Birger" <eyal.birger@gmail.com>, "Rong Tao" <rongtao@cestc.cn>, "Hao Luo"
 <haoluo@google.com>, "Peter Zijlstra" <peterz@infradead.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Tejun Heo" <tj@kernel.org>, "Jeff Xu"
 <jeffxu@chromium.org>, mkoutny@suse.com, "Jan Hendrik Farr"
 <kernel@jfarr.cc>, "Christian Brauner" <brauner@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Brian Gerst" <brgerst@gmail.com>,
 "Masahiro Yamada" <masahiroy@kernel.org>, "Willem de Bruijn"
 <willemb@google.com>, "Jason Xing" <kerneljasonxing@gmail.com>, "Paul
 Chaignon" <paul.chaignon@gmail.com>, "Chen Ridong"
 <chenridong@huaweicloud.com>, "Lance Yang" <lance.yang@linux.dev>,
 "Jiayuan Chen" <jiayuan.chen@linux.dev>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 geliang@kernel.org, baohua@kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <ahavmbcdXDX5gNup@tiehlicka>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
 <ahavmbcdXDX5gNup@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: z46uue6sot55ha64xqtneze7zr641eof
X-Rspamd-Queue-Id: 5703C1C000B
X-Rspam-User: 
X-HE-Tag: 1779956845-199492
X-HE-Meta: U2FsdGVkX19ix92Mem1T0GKu00BgevLk/Xf1Ny/KRhkRHkinpKWdHKCAsNqKJ5jS6rYMibUSxooBZXsxkxTFfU2/viZpUuzH4oSIlLEnV3KWS5zx1gfbJjNxko4xCELelbe4OnIBoPhsrkMEinE1tZzAYgnD74S13cJA5CI2WO5PPBifArZWfcsE5OCsarQ1yk5VqI8b7jEKSFFBuRF1SbohlfU5qDBydNZAeRmnC37a0bcTqhxgHwCL+6b1SldIUetgMC6a+Jzk8EKe799xugXASm/d+TlM40jJggybPz0gV5d15Rw7qK+FkEpHw7M4GVkvQaRtFHpiTWAM3J/UV4kyHqlqejf4ckrgKv7DudFJ+5yoVJrH91lHLyf6gR2AAn/TcEueozDaXIN20cNDiXDg4Jvn5KI2jPfZzP5Oyp59gmDU51D44WwHwJoJ4GF6qURRH9B35abLjMa6uRV9kshdom6Ys732LH5hiZjjK2hfjolMzW51hjUYNS3cnixVFq0AZR5ABPbRY0+HgC7E9tAfpl0cdNRze8NvVOf6+lk2mZUD3KN8ctcrkBHU/p8sWo0lNapZDzTCyFshUKmXp9wiV3uMKPgBWMPFW2RySmBKOPWfhug3WPkUC+Z7ZPNOsWAGIMTxtbj47oX4L2Mo48neB6+wny3sjKSFKmO3RWAQz8LT2bAmZvYI7Vnsq225c9FgAQ8Ks5uwwjJsjUiGTdlesGDTpdeaQvhSO8h89rR3E0kpq8qlpcKn1j8xKj6eU+CRFzFefbsDCiQcIW+fRqpMBLUW4M94BA/xtYs+GHyZtrLjoSJCqKH07ub0LHhPcsKpj8oKPUX6zeX9PEmrmS/nRpCd3qnOYq/CfVrL+NXE2UC8TWyffb16xHxa5oMVHe1JncYPW02HxpIFNXLqFRjAK6KdK4Z7HLS35YWdCd1oHJdwamJFLx/Ni/Db2cYB12oETpZcDg8jRV9NM2j
 ckzzhBt+
 W/6pEM7vblhBAN3EGlHxm8rubaDdvSkxtHsFnuP2dSSbMprrkf8ImXhKMwaQ488yzcu6jRoD5dNHytlIaz07xvWzgGu+GIUMQVAeY7nyrKB4x0vjX+XaIe3bfAZRMwXriuKjjNY/QJ3I9aOWulx2JTGAcelnnPJYGjI5M7IRWAioQnDWSzP1e6Y8VVs6TACBLGJPMy/aPx7IJ2kxf3Yz7l4IHF+2tE5P+iMKbSTwMRFgXgQvUuo2Ri+TuqbZMexka21veHBFklB9ARgjzWuCe9Mz7P1pxeX38Khhv4+OC+jZnHgg2TmVI0JxtLGbXNjPhP68mtAw8dFsvE5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Tue 26-05-26 10:20:00, Hui Zhu wrote:
>=20

Hi=20Michal,

> >=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20=20
>=20>  Overview:
> >  This series introduces BPF struct_ops support for the memory control=
ler,
> >  enabling userspace BPF programs to implement custom, dynamic memory
> >  management policies per cgroup. The feature allows BPF programs to h=
ook
> >  into the core reclaim and charge paths without requiring kernel
> >  modifications, providing a flexible alternative to static knobs such=
 as
> >  memory.low and memory.min.
> >=20=20
>=20>  The series enables two complementary use cases.
> >=20=20
>=20>  Dynamic memory protection: static memory protection thresholds
> >  (memory.low, memory.min) are poor fits for workloads whose actual me=
mory
> >  activity varies over time. A high-priority cgroup holding a large wo=
rking
> >  set but temporarily idle will still suppress reclaim on its siblings=
,
> >  wasting available memory. A BPF-driven approach can observe real wor=
kload
> >  activity -- page faults, charge/uncharge events -- and activate or
> >  withdraw protection dynamically.
> >=20
>=20Why the same cannot be achieved by dynamically changing protection?

Dynamically adjusting memory.low or memory.min is indeed an
option, but it has a practical drawback: in many production
environments these values are managed and pushed down by a
cluster-level orchestrator (e.g. a container runtime or resource
manager). Modifying them from a separate BPF-based agent risks
conflicts with the orchestrator's own control loop and makes the
system harder to reason about.

Beyond that, the intended use case requires rapid, short-lived
adjustments -- reacting to bursts of page faults or PSI spikes
and reverting just as quickly once the pressure subsides. Mutating
the static knobs for that purpose feels like the wrong abstraction:
the knobs express policy intent, while what we need is a transient
override that sits on top of that policy.

The hooks are therefore not meant to replace the existing limits,
but to complement them: the orchestrator continues to own
memory.low / memory.min, while a BPF program makes small, brief
corrections in response to observed runtime behavior.

>=20
>=20>=20
>=20> The test results at the end of this
> >  letter quantify the difference: in a scenario where the high-priorit=
y
> >  cgroup is idle, the BPF-controlled low-priority cgroup achieves roug=
hly
> >  37x higher throughput than with static memory.low.
> >=20=20
>=20>  Asynchronous proactive reclaim: the memcg_charged and memcg_unchar=
ged
> >  hooks, combined with the BPF workqueue mechanism and the new
> >  bpf_try_to_free_mem_cgroup_pages() kfunc, enable BPF programs to per=
form
> >  proactive background reclaim without blocking the charge path. The
> >  pattern works as follows: the memcg_charged callback tracks accumula=
ted
> >  memory usage; when usage crosses a configurable threshold, it enqueu=
es an
> >  asynchronous work item via bpf_wq_start() and returns immediately wi=
thout
> >  throttling the charging task. The workqueue callback then invokes
> >  bpf_try_to_free_mem_cgroup_pages() to reclaim pages from the target
> >  cgroup; if usage remains elevated after reclaim, the callback re-enq=
ueues
> >  itself to continue. This allows a BPF program to keep a cgroup's
> >  footprint below its hard limit (memory.max) entirely in the backgrou=
nd,
> >  avoiding the OOM killer or direct-reclaim stalls that would otherwis=
e
> >  occur.
> >=20
>=20How do you account the overall work done to the specific memcg as the
> large part of the reclaim is done from WQ context?

One approach to attribute the reclaim work accurately to the target
memcg would be to expose a kfunc that creates a kthread_worker and
attaches it to a specific cgroup. Reclaim work enqueued to that
worker would then run in a context already associated with the
target memcg, so the accounting would naturally fall to the right
cgroup without any extra bookkeeping.

The tradeoff is additional complexity: creating a per-cgroup worker
introduces resource overhead and lifecycle management concerns
(e.g. when should the worker be torn down). Whether that cost is
justified depends on how strictly the caller needs the reclaim to
be attributed.

That said, I am not certain this is the right direction yet and
would welcome your thoughts on whether this is worth pursuing, or
whether there is a simpler mechanism I am overlooking.


> Also when introducing a BPF hook please focus on describing why existin=
g
> interfaces fail to achieve what you need. For the async reclaim why it
> is not practical or feasible to use userspace driven memory reclaim.


Noted, and thank you for both points. In the next revision I will
add a dedicated section to each hook's description covering:

Why existing interfaces are insufficient. For the async reclaim
case specifically, I will explain why userspace-driven reclaim
(e.g. memory.reclaim, cgroup-aware madvise, or a dedicated
reclaim daemon) is not practical: userspace cannot react at the
granularity or latency required, and the round-trip through a
syscall or procfs write introduces overhead that defeats the
purpose of proactive reclaim.
What gap the new hook fills that cannot be closed by tuning
existing knobs.

Best,
Hui


> --=20
>=20Michal Hocko
> SUSE Labs
>

