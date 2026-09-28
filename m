Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA23EC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 06:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9366B0088; Mon, 28 Sep 2026 02:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A216B008A; Mon, 28 Sep 2026 02:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58F16B008C; Mon, 28 Sep 2026 02:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86EB46B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:51:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EF5E40B30
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:51:12 +0000 (UTC)
X-FDA: 85262249184.22.3AFDCB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 17081C0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:51:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRahg4cA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790578270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5UI4Wy+eGiErrBzR7b2VedGpOFJDsN75qbhAxc0yzs=;
	b=EPQ+ceUwqeGuVpbYj8RhndadpwcoNgQ/4RkveCxeUcGeUMqKRBO5k1SkGahcQrs2iC0nUR
	ms54O5lKKwBzAVqey/fw19ZVwW6yxHGRwGAsSFYKKYdObGY8mYw2r5kzJexd4MbFaoqeeM
	GeeWVlogpZdUclgvUhzU1xNcWiVmxos=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jRahg4cA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790578270;
	b=WGnLNdCul6jlaAaZZAtsmm1WXUXjFKpvKY37cM1TUpXA5OVF3lLtB0j5kYZQEeVBtWZD01
	klsDn91IIOI8uLZiHmiJf/nOc3QYo6U0NbbcO/6mSI41aQcRlv5Z5iknWwUJEmkLoUAAyj
	OFTuG6Hw4IzSeXjUaNutit9m3UVZmpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96A32447BE
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793A01F008A1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790578268;
	bh=s5UI4Wy+eGiErrBzR7b2VedGpOFJDsN75qbhAxc0yzs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jRahg4cAxN6Tle2r15oJe/vmxLHt/LqsTmTxt34l9F+NJ+DReohvk6pR5vCHz2B3O
	 pcJWUAQ6QH4Lp0CuwBlUfYDuo8LRITlBQkrUs+FWRkmUazrwaGqVihIh4IqyqQnhho
	 SzyMTgwzEgMUZNVh1F/Zj0azGL+N+c5Ip34weRdyBiQruy5eAGdfDQpOqcJy0xC9If
	 XninYxyuXj034C3GWnRU/6CjCPxeYVDzZ7UFgT6+ITXDEVEQGj43lpS/oBRFluKgN6
	 GcObbZtLOxjCr5AeIQf/biJ0/q1/t08Vi+9JBBBQYwnZtkEnOC4gB+89RwY77H8Rzi
	 ckorlts8LfjXQ==
Received: by mail-qk2-f39.google.com with SMTP id af79cd13be357-93c65d5e6f8so59937185a.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:51:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy+2hs4ybLjfr/bZ4jDq/fer4FA9PVZDiyy4sd5jEBGKao5BRRiABl0cZvkEjFPrzd8ajgRVbbI6w==@kvack.org
X-Gm-Message-State: AFuF++ko02fn8+rNq/SDzUOxSLiZkkXDC9mBLrvhZz9sjTi1c37MCz9c
	HwgUA6Mey8E0aIjuRKeRAuHfLa/S42/1exZRiSGk3A16IfLINDjulVTAqANlMDllYL8BdNsztj6
	7MUsD/yIkzBDv+mELgjCuJVRdW69KTZU=
X-Received: by 2002:a05:620a:6486:b0:93c:6925:dfeb with SMTP id
 af79cd13be357-93c6925e8a2mr834739185a.56.1790578267654; Sun, 27 Sep 2026
 23:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260928063724.24008-1-hui.zhu@linux.dev>
In-Reply-To: <20260928063724.24008-1-hui.zhu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 28 Sep 2026 14:50:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wrWdw+4B10K3J+sDCSjVoBs2=LtObb6MKehuYsx9pXMg@mail.gmail.com>
X-Gm-Features: AclHuK-c7GpN5AyOOlaUnzGeJcdZoBH-1EyfOLTse_68UQXS73MXqF_7DQKjthA
Message-ID: <CAGsJ_4wrWdw+4B10K3J+sDCSjVoBs2=LtObb6MKehuYsx9pXMg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Add bpf_proactive_reclaim test
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a8jxkd6spe7geoxc48r9bhxxqqfj13s8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17081C0007
X-HE-Tag: 1790578269-756056
X-HE-Meta: U2FsdGVkX19+xqOSm4m1Nfta/UzBPZnhhhB++eof4kxP7n8Glfhtx1QITciGDywcAFan3dgzeqfMZJMj7EixjxEIgTwaPcmD+bnu0q7Nn5LHVN9j/xhG7KoDzfJqfleNK1xNxQEQ7V8UWQz2/7rAF3clZxFt6lW1Dev+EDrYugo8JSSuXgqAVo9Iw85QT945E54ackWjNSClC9pJl7PMm4vR3PJlZ7gtJ9fr2HLRqy7vvsMk9W5raMFwgaAQyDd5lpzJHUiDayFmyY1Tj37D1NdFoDKQDLP1OIz3kDMoMPLNE1UgA3L8vueqtoGkBuiR2BTVkzv7DcubMn1X9faN5rnxYKEJoOoaWoGoXE7rRLjfdWI+IlpArySwpkj8QvXcKjPFmU8pbAZSyxX9u/WWq1FBf7igjlhCdzwUdrtve/brZ/mn4M2YV3tvZZwrn0+k3hGaFQUaL1ILTUDWtBQBfY3prAaRO8bQVXlsflkk/A7SsiUzw6wAVc/WRd6wKk1vx9P2mzvWEpUQ8r77HVepJBcgq3zD81d4MrpXZcRAfpDNdcHZlE8EEivXdVauo4VLV/DmsKzn5MtDtjoBtBFHnmcsADW/vGxtbX7rMOK49nDX7Z5LwPK0GJpi+ZZZ5bK5luXU+zjtXhtRe8W8v6XUXCRyUZzp9OdALqcSkLLhOLebqPOMnSH4yLY0jteG1qy4Rel4mdJQrj7rIsfrbqgJKspTcHBxdmlVY+cN6+QPbcquAi0foTo7YYqakhxxDE+lIw1dF4HyQ8/tAT/t85v+w9EMCHLg7wfP6Ju7S0Nkx8aIA80pkWC07VeICsG/pxIIHTTcMtQNmLrgxt/Hcgu0jRUuZb/kqvRX0JxFK9+qmGn+dgOdkzCvVycWpS9gpDiFFeVoEUEGPImG/q73eCmrS6/YT4hBFGH6CvQFUEh3YogHFRMuXFuO8CtCZr1yNQPtaHovzItveOG0K/RDJTG
 at1LGSzb
 yGlsOJ2+7pTuvDzaTdsBeiHIGzZssmVz6ryur8nmTx2t8KinVJRDjH1WuMUuCDHMyFvxVim4pcI2K5C7ZmI1KjewADo+XIpm41RTcc9rsXDDeYKH5Ls1YMCht1tQ3I7EpEx6eP0ebCcYBPAaXq8sTt4C7Syxs19zYFWV59gCnIQ6PvnHCqLmwo5SlMjqNnorQMox4ckvBZIPipAh8CJ5/9rpdMTOZTWsd7uiqifN/otBASrFgqAu0ovxvU0X+Kg7a4YYlpmFDOEFSsOTzl5qG9moEivkkntwK7HbEF6YosL1o73Ts3brEQtU0JzRYPLEFA2kcCstT37XmA+0KI+lmp2BbgLWW5Kl31jE9B8zTtUP02cYTJIWhdByGnarHuj2dbhYbrziTDE22WzxVElgpwQ13w49sqmT2r0oAltGa97YjhK12BawjLc/kmB8BNts/Xtzn5ELQ0K29b9+9hYv1J5wt0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 2:37=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> bpf_proactive_reclaim() performs one bounded reclaim pass per call and,
> unlike a write to memory.reclaim, does not retry until the goal is
> reached.
>
> Charge 32 MiB of page cache to a cgroup, ask for all of it in one call,
> and check that the result is positive but well below the request: one
> pass is capped at MEMCG_CHARGE_BATCH pages, far short of 32 MiB on both
> 4K and 64K page kernels.
>
> The test deliberately covers only the kfunc itself. A full example of
> the intended asynchronous use, where a BPF program watches one cgroup's
> workingset refaults and reclaims another one from bpf_wq callbacks, is
> maintained out of tree at [1], released under GPLv2.
>
> Add CONFIG_MEMCG to the config fragment, without which mm/bpf_memcontrol.=
c
> is not built at all.
>
> [1] https://github.com/teawater/memcg-async-reclaim
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
[...]
> +
> +       /*
> +        * Charge FILE_SIZE of page cache to the cgroup. Reading rather t=
han
> +        * writing keeps the pages clean, so reclaim does not have to sta=
rt
> +        * writeback before it can evict them.
> +        */
> +       if (!ASSERT_OK(ftruncate(data_fd, FILE_SIZE), "ftruncate"))
> +               goto out;
> +       for (off =3D 0; off < (off_t)FILE_SIZE; off +=3D sizeof(buf))
> +               if (!ASSERT_GT(read(data_fd, buf, sizeof(buf)), 0, "read"=
))
> +                       goto out;
> +

In case we might map file holes to the zero PFN someday (not sure when),
this wouldn't necessarily give us page cache. So maybe write + fsync is
more future-proof? In that case, you could also drop the two lines of
comments.

Best Regards
Barry

