Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC58CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973B56B008C; Wed, 27 May 2026 05:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924A36B0092; Wed, 27 May 2026 05:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814906B0093; Wed, 27 May 2026 05:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7142C6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:31:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0F1712053D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:31:35 +0000 (UTC)
X-FDA: 84812682150.08.B318438
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id ECB10A0013
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:31:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fsjTDaB0;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779874294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cuHmtgVXBwRM6gWFejLSgCD1TBA09WsjOdpw2obbiq8=;
	b=ChNqMwTcN03rfNsZEcZNOOeLf0zWKp7Ig51/QzE2Lj+SFzLgInI1vprMENhA/LAIJEfkA5
	Zk+8lXExDC7LyojsFA7xOAgEvCDOVXeyEvB+B8gF+s0a2afQMc5vcND/4PQlOSQkmfBwdl
	HNekvTC69bWOCDNXSKByf3ZFDNr+V/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779874294; a=rsa-sha256;
	cv=none;
	b=RtSOFoslN9YDh/nCEzO73G9+EsSR9gTEtCubvplOc8yx5bJ1gFnAOFhcOv97Dd5wHHwFHV
	npiBHdQKIrVxBCqRroo6I5QPdlxqfeeTFP8H1HtGLGXZt2QVySBW08R3tPE0x5wQwloXcF
	KD0mc4Lt2a7kZDX4yiwT15eBeBkadsc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fsjTDaB0;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779874291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cuHmtgVXBwRM6gWFejLSgCD1TBA09WsjOdpw2obbiq8=;
	b=fsjTDaB0b5qte/WIAecQkAPIKuw6nVsSpbTIf+6BctJmOUjYfsumfoQYf78vDzLMK/tLkg
	sYJMZhqLPfJv6F3AW/vyoB54xZhJCtm5zSdmguKpEea7cU/8I/fEoI2pbaMG2IUuW4Eml/
	Q0UQQ2PfILGhwbSHJD8pIjDYJGnG6cI=
Date: Wed, 27 May 2026 09:31:25 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "teawater" <hui.zhu@linux.dev>
Message-ID: <7f440116b23fba1e20fe70fda502ad66f7dbf158@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH bpf-next v7 00/11] mm: BPF struct_ops for dynamic
 memory protection and async reclaim
To: "Usama Arif" <usama.arif@linux.dev>
Cc: "Usama Arif" <usama.arif@linux.dev>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "John Fastabend" <john.fastabend@gmail.com>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "JP Kobryn" <inwardvessel@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Shuah Khan" <shuah@kernel.org>,
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
In-Reply-To: <20260526134115.816081-1-usama.arif@linux.dev>
References: <20260526134115.816081-1-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: qei7ontphaksq4p6y4ash6pwu81w397m
X-Rspamd-Queue-Id: ECB10A0013
X-Rspam-User: 
X-HE-Tag: 1779874293-587243
X-HE-Meta: U2FsdGVkX1+Kwc60QgIcYrokP4w2eMEoucsiotc6u2yKNgM3dDFmM4Acgf93SAY0jVSPtL82twAVUFZycuS+vPxH62CSFfK6sm/8Imyn747oFJsqRSUjDTC3BCHnh7+lsBPsCn/2/rlpZdh3QithUu23yMCvM2PHK9X4JREesXFe2ce1X/0ItlF3c0IsOitCMpK4IrtRu6G2eSMfBsLBq6uIsLBPJ9zl8iBIuNj0LEsBd7YTH5hms0nUQssgdj5iXshWepIeDsySPkfQXQ3O6tmV5es+jlEH1zKxkn5duLunumU0MDCIUza2Ecr94eaSblZyNhDaQ6m5DN2cCW7eDk9VYZHBIjkHMrx1GUIWh+tXjal/1WEpDk0O9bbg+uj3doIm5/9ZrTYhdOLQodRFGJPUDlpGw86XDpP+4mFqjM0jW2LZjW6WMlM3ds1VTG1oZQTfDJXsztTM2BuNbpEpr0KesE49LFvtiP5GSPxqvZ7jYhkYDIyXxZX3b/MMU9O6YzP9VqG8i/Yee2UVnBKsoqt0Qv1YE5wIyy2TIBj/Y4TgEJkSJKaZF4nqECAwiS636mL9RFO+MQZrBmCZeepPKhuF2z5v2JKmhuJfUR/5iwCYPh9XBBhAiy8uuT2ygtE5oQqwGuDoNjTpnF5Kgsdt7J7OUeL9b1lpX4Zra2gmImZ8xDW7klq+oEAfW063jHa164z/+Tfye/EU4RPiM1bjV/EsEicK5Uxq95jzXT2JaGU+UwKPNGAkfJpiWh2CmQuYQ4NN6Ci3cYNLBKwveNUZlBxRh3aNzfIvkZ2FB+6Z3aeeCZs4BjygYKNMAYXZxXP/gF+n25Fxr4hN6NQR+5FBUfIpiqYKXnC7U7xKuweJBN06XpmoV9lBg+fLkpduXRiavs1DgcFWBmgTP5EalyUZxthPcndRavExiVYH5fJL75e3m/R+jdGUaK8z3cRVwKHeLQntnSCqj8xfVjSm/hc
 JxbRZA6m
 hLmw08Zvf4YzcFEPGArXpwOWZwGOV1560ra9SQPnSLIA3I6a2qLISMU1vA3px2la4P5N0yvv/JLkGUHbz8abRqbT1XNSr+3TUy9rbV3AYBEP/aBTJb4lPb8M/721P40ikSBz6C2hOAqg4gl7Bv+DOXiAOuksgnVc2djKI0GUHp/9eWf8b1ioePBWNYRHMhwSwLsx4b+4r2Xr5FZUEUVHS9X6xDWHN7eCePnDPnln1qzRr0UJSPHeYcL8TtKA8acr1mJAlgauP8ZHXN3AjBCdht/kYYN78fx6USKDi3Z0eXh4hPcqH8BwFJPvX+ZSDnW9fc3hI3fdigIyAtqE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Tue, 26 May 2026 10:20:00 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>=20
>=20>=20
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
...
...
...
>=20>=20=20
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
> >  occur. The selftest for this feature (patch 10/11) validates the
> >  mechanism concretely: a workload that writes and mmaps a 64 MB file =
inside
> >  a 32 MB cgroup reliably triggers memory.events "max" events without =
BPF;
> >  with the async reclaim program attached, the "max" counter does not
> >  increase at all across the same workload.
> >=20
>=20Hi Hui,
>=20
>=20Thanks for the series.
> Would it not be simpler to just have another memcg knob, something like
> memory.high_async.
> When memory usage > memory.high_async, queue a per-memcg work item that=
 calls
> try_to_free_mem_cgroup_pages() until usage drops back below some thresh=
old.
> I am not sure I see what programability aspect from bpf you need here.
>=20
>=20Thanks

Hi Usama,

That's a good question.

By introducing a new BPF kfunc bpf_try_to_free_mem_cgroup_pages,
a BPF program can flexibly control when to start and stop async
reclaim, rather than being constrained to trigger and stop based
solely on memcg usage or one or two fixed events, as with
traditional proactive reclaim interfaces.

For example, async reclaim could be triggered based on PSI, or
on the number of page faults, or even on a combination of
multiple events working together to decide both when to start
and when to stop async reclaim.

That is the motivation behind adding the BPF kfunc
bpf_try_to_free_mem_cgroup_pages in this patch set.

I admit the cover letter did not explain this well enough, and
the example code does not demonstrate this use case either. I
will address both in the next version.

Best,
Hui

>=20
>=20>=20
>=20> 08/11 selftests/bpf: Add tests for memcg_bpf_ops
> >  Adds prog_tests/memcg_ops.c covering three scenarios:
> >  memcg_charged-only throttling, below_low + memcg_charged
> >  interaction, and below_min + memcg_charged interaction. A
> >  tracepoint on memcg:count_memcg_events (PGFAULT) is used to
> >  detect memory pressure and trigger hooks accordingly.
...
...
...
> >  --=20
>=20>  2.43.0
> >
>

