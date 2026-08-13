Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D803C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639556B0553; Thu, 13 Aug 2026 13:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611926B0555; Thu, 13 Aug 2026 13:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5278D6B0556; Thu, 13 Aug 2026 13:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CAC26B0553
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:07:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF164140243
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:07:48 +0000 (UTC)
X-FDA: 85096878216.15.F166EF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2F4CC140005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:07:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l6/55D1p";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786640867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=PKRAeK+XaoOSz8i+k2Leco4J4jAfWktnkTRSqbkuLKM=;
	b=ZMmaYawckIM9pi67wSY5EuWxF3FE8kc14SxZywywKlUXF7cIziVl1q7xeCl5j6MPkzgoTV
	aSxLw0VcDa3p6ItyMDxy2ehtvYTLwjrmOLE2ByaJneQtZmquzEQkJZ31pa2klAHJUa4X45
	LmfCby2qqgMIuBl+j2APxNmTdN+Aug4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l6/55D1p";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786640867;
	b=A4cXmmaJVddNA8+xBGn7OoIFUsO2yzEKlUwJbAMgz55FbsrnMtE3QUbnfmr6a/qXHZ3RK5
	Xh+LfXoBBsH+jCtvhAw5SWXiFMuKFjpk9kIp4Ckx1bgITSZGODBbKS5kqJioHr8BQFbz4e
	h0JS/htLTil3i3ICsZmUnc96LES6JbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55582600AD;
	Thu, 13 Aug 2026 17:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D464A1F000E9;
	Thu, 13 Aug 2026 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786640866;
	bh=PKRAeK+XaoOSz8i+k2Leco4J4jAfWktnkTRSqbkuLKM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=l6/55D1pW/RcwnNP2uahedYxgXA6SfshCx0z2EmsF/OjK7lXLkJYcVuMj32OgAtCk
	 cyfxTg517dDPPDyBv37OY7J0Dg7H+yvt9uBSLsjahX6DCkiy861Q0UWxH3vrTipjOr
	 z0VQcL+BxxHQ4uNYdk+pn+SRzhXykT+Rowb9iXDWol9mVH3MBnAPPT2f4iaP6WDJiY
	 Veb4fyO4f+V0k0RVHbHdI+bEHuStwcwlDAgx/cZMRCWXHbKAVLXv0kzKb9POLlpUNB
	 IpMV/QY2isVa888VI0683WHUztUubnxgHMP4QK3lVsvECdyF6rPzDM5jVY0yujlHZj
	 /tF2Jc9UVdZsg==
Date: Thu, 13 Aug 2026 07:07:45 -1000
Message-ID: <acf9c9a19bbac2dd116869a181bb1dfe@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Hui Zhu <zhuhui@kylinos.cn>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, JP Kobryn <inwardvessel@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, KP Singh <kpsingh@kernel.org>,
 Tao Chen <chen.dylane@linux.dev>, Mykyta Yatsenko <yatsenko@meta.com>,
 Leon Hwang <leon.hwang@linux.dev>,
 Anton Protopopov <a.s.protopopov@gmail.com>,
 Amery Hung <ameryhung@gmail.com>, Tobias Klauser <tklauser@distanz.ch>,
 Eyal Birger <eyal.birger@gmail.com>, Rong Tao <rongtao@cestc.cn>,
 Hao Luo <haoluo@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>,
 mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
 Christian Brauner <brauner@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Willem de Bruijn <willemb@google.com>,
 Jason Xing <kerneljasonxing@gmail.com>,
 Paul Chaignon <paul.chaignon@gmail.com>,
 Lance Yang <lance.yang@linux.dev>, Jiayuan Chen <jiayuan.chen@linux.dev>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Barry Song <baohua@kernel.org>,
 Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/4] bpf: add bpf_thread_wq kthread-backed
 workqueue with cgroup placement
In-Reply-To: <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
 <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F4CC140005
X-Rspamd-Server: rspam07
X-Stat-Signature: epbed4q4ufsmtt4ybohizcp959a5ytpj
X-HE-Tag: 1786640867-437268
X-HE-Meta: U2FsdGVkX193kU9jxdQU3oKuUoU8UqwMiP8tDmWFPniJ6w0VfUGu07H5BFoJYG+p6rCsONGStVduko8TNM1Jfit70EQ+EqjVULPANgu8nXYHIF5SPljC/k70EOfVAE9Eui/a8B0/xLAK1BlsxmOZj7xQhiwHUONJxq4x1VoovkyMEjY3v6FdvQNxJQzqpYRrkALcTEIE42cjv9I7njnAnTBZpYUrL7cLOSMjqIVG2Y0jocJH6C4DdLg5u77yI+QlOtota8aUe7L592ZHlAavuTod4RnMTwP74XS/FPSJWGv4DXViq7fv96sjd+zn6+9kYclGZ2wf9pZ45jwHB4BT1S4lzRmQAg9bousOP88R06xZN48cpYlABE9Ow60nhwyOFlqJyaQoccNf+xLzLOijsvQ1ACKKYpSn1L6ZzMUzCRsa+fvxNmr96qm4WcnOIirNydlxoZqtWY2Ei94HapAOdhrdl5igu9FjVkfUGob/JeDR8/aaL9DICzjXBlUhqbkP+0K+kWP/V5PpATMX1S190e3nWHV9SKdpT8DAgFh0bc8uhaIr6eLHJi/0lkKJ64BnxyrqgRm2m5XuuCWQDiw6pEchYu8LvSLFfp6XRjLJw43Z3eKW0fL0lBaWVGa4IumTIWyhbIYQqfbsCAB08gtnrJjVsiYAdrx5D6Y/yC+nbQ53Jb6fDgNdTwnEfomIiYzFNWyrhDm93JXfvU1s9GWMRlOTOfyJb60Y/PyT/Ha1DRkZlQY4kfd6wW+DHtyohyW/P74T3Vm09/5p2Y9SPS0xOJILSVOE52TJy3qeEAy7pJSJ3IHzTHgNlnrTSuj8fQ+5XQqOn7lgZhRDqrGq30uqifbbI6R5QfqA8nqfJUVBhCbKWbHjh4qe5mXB5QGE0iEwqIFRWOhdxK4I/KtmNm0Gr1j2LeEi1AKKweKZIbxbDRfBfbG9gQn/egOHfC4PjkFUjs3HeWkneWYhdQmvREZ
 kLzDeUVX
 maQdP5n11tTc0G4LxU9kLizT2hgMZqFRmTIOLqHJ9VT23/ZEaH6lRDOTKqpuqRu27/QHOrXcy+iCFEzzIPLrUc0v5D5oxCW8wAQHX9IUixSI/DkZGbXcBmzaRqFw9xUurL/fjT6hZPxP9lHvCYYFEvnFkjSBbtZKIwS3wIJXw22SuXAbTcnQ6dJTm4pXFswD5eTuMTpbWehk/n4czILFxOXXA6+MWbryP4ZYanFkIQTDrD5932XxmQRGYTvreGoFpZHnTsR7wEBPX4BfOOVOAEMb+Idz82XR4gKxdrOFa+8mSb1nDgu0P0EsqAc8gkiA8lCQleAfV+Kbl1vRQXZ5bvgx3fkrkOXV3fQu4B2aT9/m9HGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Hui.

On Fri, Aug 07, 2026 at 03:01:50PM +0800, Hui Zhu wrote:
> Introduce bpf_thread_wq, a new BPF embedded map field similar to
> bpf_wq but backed by a dedicated kthread_worker instead of a system
> workqueue. The worker kthread can be attached to a specific cgroup at
> init time so BPF-deferred callbacks run under the resource limits of
> the target cgroup.

I find the name bpf_thread_wq unnecessarily confusing. The kernel
counterpart is kthread_worker, not workqueue. Maybe name it
bpf_kthread_worker?

Thanks.

-- 
tejun

