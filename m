Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C783FC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A137D6B00AB; Mon, 21 Sep 2026 02:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EAC46B00D7; Mon, 21 Sep 2026 02:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA1D6B00DD; Mon, 21 Sep 2026 02:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3CD6B00AB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:56:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0039E1C2E27
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:56:23 +0000 (UTC)
X-FDA: 85236860646.14.8DB40D9
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2F9B0C0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:56:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bL3fAsM9;
	spf=pass (imf10.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789973782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkucCOPz8GZoCCEzERPCc1P/c5lfa7EDa7Hlgmx02AA=;
	b=urtGm7j+O4zfOZndGD9RC2lAsR6GjIENJmvKC0ZXzIlHT/dRFdNG5EZXWviRcEj3xtjhcr
	xWiVhkxSMVxNd/y/RzYFhJMY8f2Vih5MJWGP3MOqNLQ+3YYEJeqwQ/6Y4357F8Bg9gyZhb
	Cj6zdAO2d04NU0fFgL+9IkkyiHIhH+o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789973782;
	b=I4w5ZcPzH/LetGhOLZtLSsTm6s8NxS0rfbFEwU/sUdOFEA+LEvCy0TKcyYRAkryceVdl80
	3qP1XP7pV60Ea5Zyy2Gh67UbPWxm6+FSWHvyxlHL4HRNIxjEYzM1eT2CUJzHF+57YDeMzP
	scwWbMFL0iS9AXCCxINkl4iwmcin0GU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bL3fAsM9;
	spf=pass (imf10.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-49b963f51f6so11795025e9.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 23:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789973781; x=1790578581; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EkucCOPz8GZoCCEzERPCc1P/c5lfa7EDa7Hlgmx02AA=;
        b=bL3fAsM9QsbeMVGHrgvSoOjEI0aLWU0XaPNMvs2vlRvjog0rrH03zfONCQIiY0+PuM
         i578oMtTOkrFuDeAoyr6kZTxvhvzqyM4Gan4MAhmKleBDY3DTFGlw2ENHoaniuxS9R5U
         BGVY5Wzjy2wfPls/ofhmThbXzpDNtsM4XEbguaDoROH5xhz8NpxDQfAixMxHDurYWACI
         Ya/tkqWUBlZkXEiXttyTqpnaBVHfNcYl+6kvVgo2PhcPYhAybBZCwij0M8ckgVZO3JWr
         x+FiynfNbAU5ZGCMH6DP9tQa43ao5nJDiq1IngsslKCrU6IDq9NZvUUidH3rHLlwRzLo
         7K2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789973781; x=1790578581;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EkucCOPz8GZoCCEzERPCc1P/c5lfa7EDa7Hlgmx02AA=;
        b=UWnpacBMBfxrqRJf9dVAAqQDu1KsC34xmLjNmiACjLV/ugnd4KZwJsZVvapk6MJphn
         rtxvykc5K8VheJXJa0WpL66HyqeOY75bGqwqTh4ixMI2Zi6iqZVy9mwk0XiQ2GLqttg4
         LRMiew3hrQFcUOy+BEUT61idUvl+SfHXQheDiO/mGoXD/0M+J5nSU/5tC9Et4+BrkZkn
         9X1s7eHX5hxUj9gxr/2u2/UN5rp/VzIZcoDbabYoEozK6LSQglccBv1z3ZPzzYFUYOOQ
         SzSVG47he9u0SHfr3brz2raK/VPwg6F7Hfxfjj6MohjGGevX0EFwozHbZcwFWeOwHGH7
         575w==
X-Forwarded-Encrypted: i=1; AKwUvBzub6IvvLaHxsHjd9t9gPPh3MGgjSdsfZuhynbwW8aXSBh/RA7Fqv5hjVkXn3iRzrqnpePBRWyncA==@kvack.org
X-Gm-Message-State: AFuF++kyMxjfttLr9u4DJPVLeTpbsXw7s2FURq8p0vslfX98NeDEJkf4
	XpRpdoW/eVH+q2bsIDgclvgRJ4NFMYQ/MNqPlJ3slLghhEwVj2NwZh7w
X-Gm-Gg: AYBFou3Csj51A3Cie3tbNmtvT931n3Cg0Z7RVnybPQtL2S2ICtMM1v+OhRY7pCHtQzq
	xUAVcmJh2SLuZl1p7RHC8VOl1/t+NS0I/n1iVIP8QDjP/xs+k5xCs30+fCz6tF6/tjw/hL04nWB
	sCibV+9hI/IhQPEb2/QUdvucfDm5ER/1LQdZ8mZNmGKusK24Eq9LkMymienvkBnOGHl3nSlYv+G
	TT3GuAVPrixzpoT/VhvtZOS4oW1ceTx/HFPHlUypf9BWQOb43UJ2S10Ni0tcOHsEMgM4u4R4zdX
	j7kQwUxRRGHEu4p60O0MzS3tz5Z5l7KxIMtgqyCD9A42ha9vUBnrVi8m//5inKWkFQZzg0F/IPg
	fiQWf0r+AFEa5iOU4l3ZeMvHrvclSS+7kqBy4dwgEJ8yP3xD8GlboO1LIIXNMu7dNHJD2vEzEyM
	Ba38F9hDHQgbOJPaCNSUJQTjVVRcmztHN3Dq+k9YulfQ5xuhtdH9NicJperzBXh16nBU7jU9cz1
	jhx8sYQYlPaQqNe1bvpPVBwWVA6jXqMmUVmWVbLTkRKa/Hn2LqebuGnnli/X0Y7pbwA1ENfVY//
	dTgBwPHEU8impblrCwy55UCWLWr+kQZh3d14zoPraInLkuH3
X-Received: by 2002:a05:600c:83cd:b0:49c:c0d4:53d9 with SMTP id 5b1f17b1804b1-49fc56f7a11mr113732135e9.14.1789973780380;
        Sun, 20 Sep 2026 23:56:20 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd068124sm201507435e9.3.2026.09.20.23.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2026 23:56:19 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2026 08:56:18 +0200
Message-Id: <DLKSQY1PP3WS.2ARYV8F47YY55@gmail.com>
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Hui Zhu" <hui.zhu@linux.dev>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "JP Kobryn" <inwardvessel@gmail.com>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Ihor Solodrai" <ihor.solodrai@linux.dev>,
 "Alexei Starovoitov" <ast@kernel.org>, "Daniel Borkmann"
 <daniel@iogearbox.net>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Song
 Liu" <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>, "Jiri
 Olsa" <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Shuah
 Khan" <shuah@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Barry
 Song" <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Cc: "Hui Zhu" <zhuhui@kylinos.cn>, "JP Kobryn" <jp.kobryn@linux.dev>
Subject: Re: [PATCH v13] mm/bpf: Add bpf_proactive_reclaim kfunc
X-Mailer: aerc 0.21.0
References: <20260921030854.17858-1-hui.zhu@linux.dev>
In-Reply-To: <20260921030854.17858-1-hui.zhu@linux.dev>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bk78kyheunq53r38ndy9shtrhjshbu8z
X-Rspamd-Queue-Id: 2F9B0C0006
X-HE-Tag: 1789973782-27644
X-HE-Meta: U2FsdGVkX1+xlOmP+Gy3LsB96wst8Y5dVnXI2pIb9XMF8ghqpo4P6nYpHcFVRhi0kRs0uLdhNtCok69OAfVdrVmwoZ4JbMLj+U9N4kA7tmwzOU7MfyBsyFWttvGPP6D/yzxXkQtf0Py8DG0T20HISUk2Nd1WWNxuCzO+imJ2A+icRThQrlG/m9/TTpquaYqb9BUferRk9esyUu0q0Lpu8e6wZwN6rLyVT74ClYeXWvLaRgcV0zW/F8vHRD0Eox4M8Ykt7GXrW/nncUZUYFJYkUA7Ezd/6DKkFJeZnzSEGfL6CZLMkChPmosOntDmldRJHpNvUF+LdDJKifIkzKBbXoIg54UUWG2lSQaXUEihFwfiVz3umezLc8wuVScqoCTm/kgdd19YEWVA57kXw3zmGUOUVeO4RJXjDx4A45XjmReT62S/vkwmtZfi27GvDwTbFSex+AT1TBLkaR3ySd3knBpF/chl6Oz/vnDGG9zfCxbifsbE18b9DYbyUTdQgJ5yH+pBycOroayxs3joaCePyPQ3XVwo/Ab22vAewrDm/6pbNtIjDWZCOJ5xW5zXpWHS7TsF5m7aUDWR8f1S9kEkMTCdKhk4ugwwQHhlRQpzFA5vJilCWRXavZn7U8C//Jb9XIo5FIpQR6vq4loAnLCVKvdNdD6UYAsaaIe9JAZrEqnK6Hme4T6guA9DheSFQRRCh5RbGJQE56NbXFY1kTboxEhAc7wm+HKBPoLEcQW7OfoFz1cd9wzxAhQbKVo8qCmtTnOUJP40ngfgv+xAZMxnrUnY2dUvX0PI/z0Zhsl7UkXgcXVTIgWh05AbQr2OXwqcCg0QiohZSRxYvkGqBawewx/I92eOBGNQi1XP1eUcqBgbvD+cGiq18nPhVi111EJTHypViazEt5hAgEJCEh9o7navCT5+3KO//a5f8SWV2y6+TdiwNkdZlinvdaWKH3HN4cX0sb2hAcUoNYlpmso
 ALhI2mhl
 kFwwTK/2n6jJoRoA9vEzObGspc6o5xTxNbjVAuY09COe/85U7PlzBZ7x8SiD7t9CATphdkMxe30VW5wNFpW2GzLI9Ky5mgKDq0ZoniRuI+NJTtjsAGi3a7dB0oF5uTy4IrCkoQ5w3Iffnw2v7X3Vre1KvdQtRTsHPbPXutsNd1WbET1u9GieW+WbsHrQPWQFTjULjib2mRuYQa0gVbEAemT2a7qDKuQd/iOgK7kf+jPco7O3RuflNCUADm/hyxcfyt5XLLnsRq/tVvQDInbkD0brsYhhBr+fI2HYoDIWrWcFvkCB44D40D4cJiJTheCP5J89iXRamfDWE5wUgT8YsS61oTCmnfE2XPNEdRsZ8N6eOXTqpugY59z46YopBcZLU27TCmOW0hKAbkDX28CU6g0yzf7cV/VPWh9bZ3cszSXjNXM7pUqYNn+PYHa31xRGcJozBPTz2aZx48Iic3cxtmKSA4BBxnuZ2Y61tg8XoQW8x9Q4ewLWni03FS/PrH/v+RsG+ZhNZYTJk1eU99XvVbidIwjgXriG/1Y8SbURuZNzJx6W7cxEQp2KUQmAwUG/o6rwx4k7wpXeHN3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 21, 2026 at 5:08 AM CEST, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> BPF programs can observe memory pressure on a cgroup, e.g. refault
> stats via bpf_mem_cgroup_page_state(), but cannot act on it:
> triggering reclaim requires writing to memory.reclaim, which BPF
> cannot do.
>
> Add bpf_proactive_reclaim(), a sleepable kfunc performing one
> proactive reclaim pass on a memcg, like a write to memory.reclaim
> but without retrying until the target is reached, so that when and
> how hard to reclaim is BPF policy rather than hard-coded thresholds.
> The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
> as high_work_func() does for memory.high; reclaiming more is left to
> the program, which can call the kfunc once per bpf_wq callback and
> stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
> other sleepable programs may run with filesystem locks held, on
> which the reclaim path could deadlock via filesystem shrinkers.
>
> Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
> macros to an enum so that they are emitted into BTF and usable from
> BPF programs via vmlinux.h.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: JP Kobryn <jp.kobryn@linux.dev>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---

Applied.

> [...]

