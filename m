Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611D0606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MeiUkkTx
Received: by kanga.kvack.org (Postfix)
	id 6A68E6B05BB; Wed, 28 Oct 2026 13:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E636B05BC; Wed, 28 Oct 2026 13:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5937B6B05BD; Wed, 28 Oct 2026 13:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0276B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:19:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9B6CA7069
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:08 +0000 (UTC)
X-FDA: 85372695576.09.265F766
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3B29740002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MeiUkkTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=iA59H/LDNhkaV57ivIpVgCN8zVjfYFqLt84NAT8Jikg=;
	b=ERyVMsFMZpL7QBfRlUzgWHB/zfXtmMHexCjlH0Ac5qlQv6+TpfNqT/0rmQP0giabmSvsvD
	naFaIVcV9TgyuDLbOzvvW3HfOeumEY5TKbziXt61sWAd88pneNoWz/eSX5AfaopWUxtiA4
	wGrPQpMzV/nPq1fgSt9NfknkSPJh4Dk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MeiUkkTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793207947;
	b=nNu2xZjGJxGJp49NIa2t7MDTLzITUtQP6Mzo1ZqQAvNm3uYOJHV7ghuQFgajompHj/NwrH
	1WWmRIxl8VzRxITSRFEL+N05sICdDDSdEigYtnopXWWqOuTsZuJ6VX6dVoICGZJlwdYxji
	zhJQYc7q//ZoElohiD4DXzEyZiPT0+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8698842D5E;
	Wed, 28 Oct 2026 17:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCFE1F01825;
	Wed, 28 Oct 2026 17:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793207945;
	bh=iA59H/LDNhkaV57ivIpVgCN8zVjfYFqLt84NAT8Jikg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MeiUkkTxcl/ZYalrXsKfZK5vIOlQrmac2J0jzKLvwfTSVkHW/EqJju3D2t5LraDBO
	 HFBWcUhcKn1N9O9rwcgt7ycPunBlHdJaWWUmKIi5Obw31rPdeq3wBL2J4pJ0nVXidE
	 JqByT/tUR5FPDpjikQrL4ioCo1Wm45zMK8adF6UPkLnSHnXG0Df4ZvmeRfQWJm7JT/
	 v6Cf33DnRjATzw74NYdsy5RY49irRJk+HTAvPxntr1fG3+RRLiOPcAkl/iNMPw1Nh8
	 S+PflWOLZEOebmXde98cg5hbdX57G7CmBYnXk5vhP+A0kOxw6ai7w29GpWVoPhRJFE
	 dOLHhWgZtzAMQ==
Date: Wed, 28 Oct 2026 07:19:04 -1000
Message-ID: <5572f45165fa3ec7d16e1d17eb2c3fb6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
 KP Singh <kpsingh@kernel.org>, Tao Chen <chen.dylane@linux.dev>,
 Mykyta Yatsenko <yatsenko@meta.com>, Leon Hwang <leon.hwang@linux.dev>,
 Anton Protopopov <a.s.protopopov@gmail.com>, Amery Hung <ameryhung@gmail.com>,
 Tobias Klauser <tklauser@distanz.ch>, Eyal Birger <eyal.birger@gmail.com>,
 Rong Tao <rongtao@cestc.cn>, Hao Luo <haoluo@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
 Jeff Xu <jeffxu@chromium.org>, mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
 Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 Brian Gerst <brgerst@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>,
 Willem de Bruijn <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>,
 Paul Chaignon <paul.chaignon@gmail.com>, Lance Yang <lance.yang@linux.dev>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Barry Song <baohua@kernel.org>,
 Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 0/2] memcg_ext: dynamic memory.low and memory.min protection
In-Reply-To: <c652f3e6198b143fcf29f5540a769228f3d8470c@linux.dev>
References: <cover.1793086858.git.zhuhui@kylinos.cn>
 <769e80ffa618327ac03c13c4657e7229@kernel.org>
 <c652f3e6198b143fcf29f5540a769228f3d8470c@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B29740002
X-Stat-Signature: 6uojmemrys64a1f6ym1p1jofecp3oxpu
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793207947-705949
X-HE-Meta: U2FsdGVkX19mJFKR+wHlFy3Y3pgvFFbfrY1taKCstv3AWFiVdGPZqg+io8WZpSGCkuMBo1OqTRZo4VhzgfqH7x1CCJz5L24WU19h07z4dOG9cBfhJ2dfryV05hTzPDvZAnhIkFVMJbJRMM/WLvXYApDb6Asn1DA1t8JmOKyrXUsDPvrl/w3xHrivVPNr8irqvwNUvhOCtzIBK5TPcfCoGFFsDz1pbmIAqq8GKeUVY5XmDraQISd2y4Ty67i4dgtIkJPnFrjym5/TQp16p4yTakij6XbK37UaP06S+XFD61lCUsJYh+M9BTuaEbSG+e3PUx9Vlb1c0YlFCC1DCUbuM30/aCaJTvZxf8szomKZp3N+rZPBGKPy0pMn+HedXbISpmPSVsrX6oH1bpcBkkSaEUlXE8u6/dN5sOvLdI+/bqNHG5uxDxaw3E2BvdKQyFB/ISFHSYonF29XF9oZMooTPHxEDdmtMnWP3So0/MZJW/QRXowlQKUQdXPaTR6hAQfr1uqa8ZpFhP2R3ZnvEmol+FexppeEAHhJmnuJW5I63e0EPZWCgUbQjoqN939GGJp+cpdxBYPit9k+us6XdjuGHPkzewLxNPJ6nT2a4WHoDr/BPWS93KPiK1rVia8fBWGZtwY1QLDRVom5Fvpy2541ylZB63RSzz92Ff4K4Bp7/TtmBbxzETauw6bOPGCZZuwYQb8Bw9ybAlyUb/y5kgDLBtHlqOiCzc9R8oJGUzU2rcL3b1jlipLwbe4bPs0r/zZty4bVkvmSbfok0AeyhJ6Mv96NBMJ04gS+hJrCA4nJSQnCRp9IOP2lIbce/Y+wTEmMb/3l2Oypx+kG3EMa+UJ4JuwBDu0jl8s+COs1YMyY39734v061+JLxY5349BIsEWtbd7Wia4FEfKVQ/jyBYfvEXl2UgOTKdk+mmvUXtN68O/hdP6B82EgW7hKN1IazIMD0R5r4uT/jgnWIdsLCbY
 gsPMKVri
 YI3PMSXu3BXUXpGHexCjDDKoba/SWem8QuKAse8f58moQyF14OBvNH7qbQop2tohDkB/t+W6nGuY5mVogvcy/uPs7n4qBHPQ1y90tRxkUDBWEwrFFmozU2UkktNz3gzOO76TrqJtUj+WAHi6AXlFPDBP4otcmYj7bDaKdxS1XeGYguEyBQxpXMIMuufCPHGntHKAtqK1+0OVUVGnPW/lOQkY04rKhhsj02jRgx/RAtw3lv/YPCrg253Lbs9H9a/mYx7vwRUY7r8CZ6xw9GChdjy2sZOpZYdwZW26sJBtGB5Y97eOPatf27MZvnMk9rFlip50XZ6DtBhu/6IWewfUrry7VKQU05X5w2jdRo/8ANzlMiwpH9lK4BMC7ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hello, Hui.

On Wed, Oct 28, 2026 at 10:27:33AM +0000, Hui Zhu wrote:
> memory.low is a request, and what reclaim honors is elow, which
> page_counter_calculate_protection() derives on each pass from the
> parent's elow, the siblings' requests and the tree's usage.  At the
> first level below the reclaim root that comes out equal to what was
> written, and there the knob is enough.  Deeper down it is capped by the
> parent's budget and shared out between siblings according to what they
> claimed and what they use, so what a cgroup wrote and what it ends up
> with can differ.  As far as I can tell none of that is visible from
> userspace: memory.low reads back the declared value, and I could not
> find anything that exports elow.
...
> So the derived value seems to be usable only where it is derived,
> inside the check, and that is where low_policy() sits: it is evaluated
> per pass and is handed that pass's own inputs - the memcg, the reclaim
> target, the elow just computed, the usage - instead of being state that
> is read at the check.

The visibility of effective values is a problem of wider scope, not an
argument for implementing bpf struct_ops. There were discussions in the
past on whether we could expose some meaningful effective value. They
didn't lead to anything conclusive, and we may yet find a way to expose
something more useful.

Also, the hook doesn't use elow to decide anything. mem_cgroup_below_low()
and below_min() return true as long as elow or emin covers the usage.
They ask the policies only once the usage exceeds it, and the only
answer a policy can give is BELOW, which makes reclaim skip the cgroup.
So, what the hook buys in the nested case isn't access to the per-pass
elow. It lets a cgroup escape the ceiling that its parent's protection
imposes on the subtree.

Some of that may be innate to nested protection semantics. One
shortcoming may be that there's no way for a parent to "passthrough" in
terms of protection, because there's no way for a parent to be neutral.
If its memory.low is too low, that's the ceiling for the whole
subhierarchy. If it's set high, the subtree gets the total protection
one way or another. There may be arguments for a different semantics
which changes the shape of the protection.

However, it doesn't make sense to let a BPF program escape the parent's
policy, and, again, none of this is an argument for adding bpf
struct_ops.

> The other half is what a policy can key on.  memory.low has one
> dimension, bytes.  A policy program is not limited to the ctx it is
> handed; it can also use state that other BPF programs keep, so
> protection can be a function of activity rather than of size - a
> workingset refault rate, for instance.  [1] reads those counters from
> BPF and acts on them; it drives reclaim rather than answering a
> protection hook, but the signal it reads is the one such a policy would
> want.  The limit is on the output rather than the input: the hook
> returns a boolean, so it cannot grant anything memory.low cannot.

These signals are all available to userspace. The workingset refault
counters are in memory.stat, PSI is in memory.pressure, and whatever
state other BPF programs keep sits in BPF maps which userspace can read.
So, the inputs aren't the difference. What's left is how quickly and how
often the protection gets adjusted.

That may be an argument, but nothing so far shows that struct_ops is
needed for it. Can you demonstrate a realistic and useful scenario which
can't be achieved from userspace but can be with struct_ops?

Thanks.

--
tejun

