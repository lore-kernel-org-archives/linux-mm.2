Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43630606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Jmwex/kK
Received: by kanga.kvack.org (Postfix)
	id 63AC86B05B0; Wed, 28 Oct 2026 06:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC626B05B1; Wed, 28 Oct 2026 06:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9C76B05B2; Wed, 28 Oct 2026 06:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 208BF6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:27:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE2781C44AF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:27:38 +0000 (UTC)
X-FDA: 85371658596.13.ACE3707
Received: from mta0.migadu.com (out-123.mta0.migadu.com [91.218.175.123])
	by imf28.hostedemail.com (Postfix) with ESMTP id 85D6CC0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:27:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Jmwex/kK";
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.123 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793183257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAsQNlvEQewVVFce1WqlpSDwej6JOKTiJP6Vd2oTTAg=;
	b=ffnQwxpnkhkzTj5ixH0JA3MNExJnhikQ4jsWhVCDZ7zsEg7kkTiQ3rBo/2MEOw7/B78j0m
	TrE8JLib7uE+otzU6A1Mx2cwi2RpjP/Lp5bmSAnGDzr/bRHSRYDUickL/wAffSPfKgqD4s
	fwvt9CjLkvnW8CLne/wM3OOC0xiQ1T8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793183257;
	b=p/4HS3un6ixxVKpGxFjbxBs/pJdwg7Qgf9Cvu3ydsNa3xSck1q/3Qr+t+D4QoJjGeL4/ay
	IEnVuWniUlJahfYNzBNAQITCps4nXYjmhP/fOsk3fBi2hKDYBWLG4BFGLFnt087uJRe77c
	mB2LeBlnZCoPLkfv3wz+FHr0N8ReNlk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Jmwex/kK";
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.123 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OSNgAFP+VgQv9q7o9VlptAb+MUtYzG3jKiN7D8DtKj8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793183254; v=1; x=1793788054;
 b=Jmwex/kK7FpuCV4bqSsS5FCwcMt+EqZgDLePJZ4dvcrpEr4L/YHoyx7QKjmO1CIocO5OCbGr
 tkZmoFbOPWPIzOshnL3/DpTiXzlghHbrudm38WhVc3KkL5yD0mKtIroNlIaYfbth6p94x+Qcx/Q
 vj7/M3C4X89z4qZWGeENzS/M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ee56cd7c32368443;
	Wed, 28 Oct 2026 10:27:33 +0000
X-Mizu-Trace-ID: ee56cd7c32368443
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 28 Oct 2026 10:27:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Hui Zhu" <hui.zhu@linux.dev>
Message-ID: <c652f3e6198b143fcf29f5540a769228f3d8470c@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH 0/2] memcg_ext: dynamic memory.low and memory.min
 protection
To: "Tejun Heo" <tj@kernel.org>
Cc: "Alexei Starovoitov" <ast@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "John Fastabend" <john.fastabend@gmail.com>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "JP Kobryn" <jp.kobryn@linux.dev>, "Andrew
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
 Cook" <kees@kernel.org>, "Jeff Xu" <jeffxu@chromium.org>,
 mkoutny@suse.com, "Jan Hendrik Farr" <kernel@jfarr.cc>, "Christian
 Brauner" <brauner@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Brian Gerst" <brgerst@gmail.com>, "Masahiro Yamada"
 <masahiroy@kernel.org>, "Willem de Bruijn" <willemb@google.com>, "Jason
 Xing" <kerneljasonxing@gmail.com>, "Paul Chaignon"
 <paul.chaignon@gmail.com>, "Lance Yang" <lance.yang@linux.dev>, "Jiayuan
 Chen" <jiayuan.chen@linux.dev>, "Emil Tsalapatis" <emil@etsalapatis.com>,
 "Ihor Solodrai" <ihor.solodrai@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>
In-Reply-To: <769e80ffa618327ac03c13c4657e7229@kernel.org>
References: <cover.1793086858.git.zhuhui@kylinos.cn>
 <769e80ffa618327ac03c13c4657e7229@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 85D6CC0006
X-Stat-Signature: jjkmkgwfijng1u65phogqiskwhya13r4
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793183256-588009
X-HE-Meta: U2FsdGVkX19ivHH5EdJLMWMfQoAagJnpWhNEGaX5+TAZ/vGEgaKfkSt05sjmKzxW+1cpQl+gDEj7oZoebshwbdYr2j0a33yiwcyusgP3ombzsF0lqiSeHpSPKwBBQ/BT/QQeuzr96MKmC9CgQ7GlXSf+s3sRACs7eHd1z3jtvYaY2eOEJwokm+vSQvrD9TbZ7lKusY1iK09b1W24hu4dZq0fMSJ6Ewp2GPUGfpNSdb1kBwCJlnWn14CI7O0qzGz8nlK2HV3OYT1LMXOTZirFSpAbjyQqxFVDxQYwfvrWxOgnGdNX3cHXpZpkKboLSp2DuRhm3406/QK9F48C6YRLqsZrq82DTgUGJTXfcSwSnvZRVFBzmjVlEJ/JGLs1XwanWyxr7exJBoDay5tGhuSyZ/e9q/OEAjzHExkNj3VCKSaqxu1nCcyF9JNQeQUJ+XOOc0o5KGLUds6wVC//SHTCcDmYD3VB5mLWWIaBEWKY2XLiz31U06FptQlB7dBQkmXlyq7WWm4FWtxrmoAGPv/8JaalRoHXY4z+PVGxHadqsYU5Gs2I2XiJURnlxx2ATQT0RIlX9QvJyAksdCzp7p/Ydos2ZgJZm7fYA3m/LNrJ7iLnUgeP2qbEt1dELrD4W4fR8OYaewkTDz0ezWRVN45AILenbfyTszUTHb0ZVJzc9BFFz02pycQRI46HBCo1TH6uOXhHDyLa7TM5CuJYIzovZRmei6hmi/e1MW7oZAN8oDfkIeI/mLHJ0k1EgAynPZFggGOeMkaidzs8Zb2LIq6tw1dMVHbpqD7o7eqayfb1vUnNp58vxVoHTDPxrxElp9P+uZngmqlt6PM1dn88Ck1VkHnZDXExNsOmoNLfPw0/0944JaH44RnHXzP/koRb1UIN/bz+gVDbOvSc5+Bgeos4MBrIK7HH4P+oHV/MxjVx1KvGXeUJwqh9G84e05zV72bBjxFIWPLAfVFH2t/wW8P
 h4aiI8PO
 bXcWBvhZ68vpflcB0h3R/G8LBai1EjF4isT9rgwu8878QLerf8NLFcQqN/rbCIIpSBS92SEZwU5xiSqGaJrEOSI31+AU99r3rOp58gb+4dclLlkYBwEOIHC+las8i4PAuGXSIWBhK5BkVlU5eYQml9d2a0qrOGieCFnJ36PcxPenY110YTJuIK5qVQvIZAhrg5TN4Kw7K3q/Lpf8lPeFwttRJCD3Z90Qnik7XEmPbM8QIAFZjTgPCLm7KYSIF31zGaChEVnray+IS4nUwlttdets1GcSGAg8RscdbrlStutXu6e2i6lZ5gW+rRxRFJXtdSl+89vbYyv2cr4mJLrTK5dEf7sGFn4jgAh1Q3NRF008CKA8f8rmGET6XD0547vbknZsX1Xe9aSl1nUad8MZ1OsHztNAlwrM/knX0fLC2aTkOSefsDAb/3MSdu/Q8/DfnVLZ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Tejun Heo" <tj@kernel.org mailto:tj@kernel.org?to=3D%22Tejun%20Heo%22%20=
%3Ctj%40kernel.org%3E > :


>=20
>=20Hello, Hui.
>=20
>=20On Tue, Oct 27, 2026 at 05:11:58PM +0800, Hui Zhu wrote:
>=20
>=20>=20
>=20> Why it matters: memory.low and memory.min protect a cgroup by a fix=
ed
> >  threshold and have no idea whether it is using the memory. A
> >  high-priority cgroup that holds a large working set and then goes id=
le
> >  keeps suppressing reclaim on its siblings, and that memory is wasted=
.
> >  A policy program sees the real activity - page faults, charges - and
> >  can grant or withdraw protection as it changes.
> >=20
>=20This doesn't justify the changes. Why can't the same be achieved by
> adjusting memory.low and memory.min from userspace? The arguments made
> so far are neither convincing nor proven.
>=20
>=20Thanks.
>=20
>=20--
> tejun
>

Hi Tejun,

Thanks for taking a look.

You are right about that paragraph.  It describes what dynamic
protection does rather than saying why it has to happen in the kernel,
and at the timescale I described a userspace agent writing memory.low
would keep up fine.  I will drop it.

Let me try to say what I was reaching for, from the code rather than
from a benchmark - a comparison between BPF and a userspace agent would
say at least as much about how well I wrote the agent as about the
interface, so I am not sure it would settle much.

memory.low is a request, and what reclaim honors is elow, which
page_counter_calculate_protection() derives on each pass from the
parent's elow, the siblings' requests and the tree's usage.  At the
first level below the reclaim root that comes out equal to what was
written, and there the knob is enough.  Deeper down it is capped by the
parent's budget and shared out between siblings according to what they
claimed and what they use, so what a cgroup wrote and what it ends up
with can differ.  As far as I can tell none of that is visible from
userspace: memory.low reads back the declared value, and I could not
find anything that exports elow.

Exporting elow would not help, because elow is not a property of the
cgroup alone.  It depends on the reclaim root as well, which is why
page_counter_calculate_protection() warns that it is not stateless and
is only valid as part of a top-down tree iteration, and why
mem_cgroup_protection() carries the example of a concurrent global and
targeted reclaim driving a child's elow to zero.  A file would show
whichever value the last reclaim happened to leave there.

So the derived value seems to be usable only where it is derived,
inside the check, and that is where low_policy() sits: it is evaluated
per pass and is handed that pass's own inputs - the memcg, the reclaim
target, the elow just computed, the usage - instead of being state that
is read at the check.

The other half is what a policy can key on.  memory.low has one
dimension, bytes.  A policy program is not limited to the ctx it is
handed; it can also use state that other BPF programs keep, so
protection can be a function of activity rather than of size - a
workingset refault rate, for instance.  [1] reads those counters from
BPF and acts on them; it drives reclaim rather than answering a
protection hook, but the signal it reads is the one such a policy would
want.  The limit is on the output rather than the input: the hook
returns a boolean, so it cannot grant anything memory.low cannot.

I would be interested in how you see this - in particular whether the
nested case is worth supporting at all, and if it is, whether this is
the right shape for it.  I am happy to rework the patches, and to add a
demonstration of one concrete policy if that would make it easier to
judge.

[1] https://github.com/teawater/memcg-async-reclaim/tree/memcg_ext_plus

Thanks,
Hui

