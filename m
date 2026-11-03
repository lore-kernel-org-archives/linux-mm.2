Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7135C606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCXHJlLx
Received: by kanga.kvack.org (Postfix)
	id 702056B00EF; Tue,  3 Nov 2026 01:49:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D99F6B05B1; Tue,  3 Nov 2026 01:49:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE7C6B05B2; Tue,  3 Nov 2026 01:49:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35D1E6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:49:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0EE71C35D7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:48:45 +0000 (UTC)
X-FDA: 85392879810.29.E8C1D07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB8824000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:48:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PCXHJlLx;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793688523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47gVMNE2szA456na8yleBIvHosW+wgwadu3yBUGMAhw=;
	b=oJSCRd4poluFYJSR0tpsFECQdCP/EP0kxm9x4QHBxHAfAAKNZjTP3NzFx54J+McCmG0mvJ
	kM14dx6yB7r2ZNEpH/yeBvTt+H2vaJrRKMpHIWDXufasoLixyfZskB6zFhRdJYBKds3Rmo
	Y9/uoLHb9nN1FRWXF09sunSjxS941OE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793688523;
	b=YpV2OW37OJdfzIYj5Ut4PwH6WCD3P2myZVUOiTa7Sz049yFrdLVfZNOmJ/ZHJOYDgjDJW0
	YkJOfig51+RSVdSbCTTxgNWdz+sfH5/iL2jOob7hhEYsCoKBLf6HlTmXVJfCUfRP7uZoQc
	ZmtWt6E/vSmcMHiuuUdWuU+pQSXITn4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PCXHJlLx;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1433F43EB9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AD51F00A24
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793688522;
	bh=47gVMNE2szA456na8yleBIvHosW+wgwadu3yBUGMAhw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PCXHJlLx5uT56I3g2/299SMhwphQgkeJYW0rwrP1IMJM6akhAulBEQfoHh3VWV4xt
	 U0ZcdcUBR3fic8CzRDhJOCn42qoqXRkoYBFAPjvFubsywIy1mQJJYPhR+2QMWhX3H/
	 NcT8Kn1k86ZutxegRMnWH1vTBbHmilczKGpffIL282zNGISD/Qe+Uy5f1dEoVD4oky
	 X/kkT2+y3+vWiKRmlMJ3TE3QZ8R5gBDYl2jAh7abWtOFU1ecZkW801ThldTB8Xijze
	 CxdEYu4adfyo+TwF3Vc5QNP4FZF/YppvW+3ZF9+SPuqdS2liHpz41EMnWURyK5t0Un
	 EqqwDUsXvhPrQ==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9440304604aso41040485a.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:48:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzjMvaVM594FcBXG7appdqB1yzAQcnSqV9pXV7MWsOIezFW1dFcnz5iA/5cA+Xz2WuWD6mnrGKJgw==@kvack.org
X-Gm-Message-State: APuU4Z+dLDnap09IYjxKd5fEyWVfdOkM9vEdnRzL3S31TI48S5V2ORpA
	+CROVs3/xmmakqkVeMu3252FHCFWvmEVpCN/JlZSA/88IzhzIV8IVXuakv27px5b/mxzyozp/g6
	cD/hAdvXxr/vObQXzl2XNrH9vlO9PJ/s=
X-Received: by 2002:a05:620a:6013:b0:93e:5de7:fd45 with SMTP id
 af79cd13be357-94413382637mr2049169685a.18.1793688522192; Mon, 02 Nov 2026
 22:48:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103025610.3738894-1-ridong.chen@linux.dev> <20261103025610.3738894-8-ridong.chen@linux.dev>
In-Reply-To: <20261103025610.3738894-8-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 14:48:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
X-Gm-Features: AclHuK9iw40Xx1JKG7xg0GhepEe64uIgtchPvP4-nxYEY5aIoWWOik_yiFOewsU
Message-ID: <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hitxnyw5omrgbz4he6qwbbthmiesee9x
X-Rspamd-Queue-Id: CB8824000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793688523-461514
X-HE-Meta: U2FsdGVkX1+4ZSetOF+t6aso1+tknfkda756TWBC54gVC5Av9QJJVL/knx0IYm+60Gz0gRe2NEhQh3reqrmPY/+9jEbejOkA92/TKjFv7XKGDTTyChjUGDX8FNlpruU8jWvyZgwzrrAtoRYgUfboEL+2ujwBNQLoVy2+PQ2jxduhvXTMXY9aRPZTiJL7iB/kX6yU1H50mp3xgL8bN2oaQgMi3YFhZwQmjXtm/R7Gxhe915+J3TlugdKHLLFFoHuaQiazr9HY4uixAWRVGTbqdJflCmT1yygYQJE69nK97fuCiKFoCPxhft12eqN9tUhdtCxaea8w+OsScP9E3Yto1fJJeqkbH/Hs2/bSa2HhDrXX12fkeQSzpW4BBUw/1iOtj1Qt1ig+7w+FR7AjGWojwILCSftduT1Uhqj8BjXhzu6JpO98PRv5SfrTSCd14MzjtyGIxltQXvnjiJkdFU5s7uhcDkAEheMveor42gd7SLtBUYKcD5Sxiz59t6wkUUGVh6eJHsDexRVfrJjV3gap/oUdeULBtTLJCKLgKWT4D4bZZ6WMOW1zOZ2cpjOzgKAEtl3hvkM6v6Lu0MIRRqyzpwg9x2yIlDNwzFwN/YNaMGnc7QSErZ0tT7j4Y0eID2cUJ63DglZ24D6eWyhYpKXl4lxlODChZ1166e2qiiwARkKCSX4hMDK/cq+1L0mIgvI1DEVW78ibOPtOBCFkTlVxcw0Vtjm15D6WRZYci1V4TfM3YLmzHveoJzYV/wN22sskxKbYSndX+VnAWJT7GthlzW5e2I7a91f7dmOgTkPrHRXTq2sYSwkVeTrV5oXV7ULE+ATyiE6dRbtAED/coSnDhXRRQI5OtCcT4kvttn6vyWsszrw1AEn611MdTo4bdysEJqRuHvDL12aInHGhbtrHPOgtDhADoHnynz4IQqQGadAgJUmwZEAh7T5zffvRaxjrYRh9T1I/MjjbIcVvaQh
 yQaxCqrP
 klbvSCoUtGDK1KRCAaivUvfXVbErSFYLVTg2FfkpM7Hqc2dSepnxhOKoHeU8nIPBWF71wWzZJJqXEtXdCTh6IqvE7gPfBirtUqDxoOjP7eGP4aCpE/PPcSnQk6cbmJHb9Ooaiihpb21uf5iG+zpGz9JFXojzIsLb2xddHlBsS+3COQUTvfr4PuiNPEA850VoXTdmPTS1D7M17xuGgXIZc35V62IEsrPp6fXhX4OKFrGt3Atvl50691SSVEw8bRHMXK0yRtQzOuwfGoNQFl9jU1IS+6B6OXcXqk+B+xaHox3z+olpzXD17tkBpGHNB5GLw88ks5tUkcAWxT02Hjwt9IriPunjHuSIVNy5S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 10:58=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
> youngest generation. There is currently no tracepoint on this path, so
> the moment a new generation is created, and how the min_seq of each type
> trails behind it, cannot be observed as it happens.

We might be more interested in why aging is triggered rather
than the exact moment when max_seq is advanced.

With your patch, we get:

~ # cat /sys/kernel/tracing/trace | grep mglru_inc_max_seq
           a.out-93      [001] d..1.   278.276539:
mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D4 anon_min_seq=3D2
file_min_seq=3D1 nr_anon=3D{0x0,0xf016,0x12,0x0}
nr_file=3D{0x1886,0xb,0x4c,0x0}
         kswapd0-50      [000] d..1.   278.422400:
mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D5 anon_min_seq=3D2
file_min_seq=3D2 nr_anon=3D{0x5,0xccb6,0x3439,0x0}
nr_file=3D{0x4ae,0x4f,0x55,0x0}
         kswapd0-50      [000] d..1.   278.508003:
mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D6 anon_min_seq=3D3
file_min_seq=3D4 nr_anon=3D{0xccb6,0x3d29,0x1,0x0}
nr_file=3D{0x0,0x59,0x7,0x0}
         kswapd0-50      [000] d..1.   280.046056:
mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D7 anon_min_seq=3D4
file_min_seq=3D5 nr_anon=3D{0x3bf3,0xcbbd,0x23e,0x0}
nr_file=3D{0x0,0xb,0x1,0x0}
         kswapd0-50      [000] d..1.   280.124876:
mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D8 anon_min_seq=3D5
file_min_seq=3D6 nr_anon=3D{0xcafd,0x3e31,0x0,0x0}
nr_file=3D{0x0,0x5,0x7,0x0}
           a.out-96      [001] d..1.   290.629014:
mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D9 anon_min_seq=3D7
file_min_seq=3D6 nr_anon=3D{0x0,0x10615,0xb,0x0}
nr_file=3D{0x331,0xb,0x9a,0x0}
         kswapd0-50      [000] d..1.   290.653098:
mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D10 anon_min_seq=3D7
file_min_seq=3D7 nr_anon=3D{0x15,0xef23,0x18c4,0x0}
nr_file=3D{0xb,0xb8,0x55,0x0}
           a.out-96      [001] d..1.   290.684875:
mm_mglru_inc_max_seq: nid=3D0 memcg_id=3D1 max_seq=3D11 anon_min_seq=3D8
file_min_seq=3D9 nr_anon=3D{0xeee3,0x1afb,0x2,0x0}
nr_file=3D{0x0,0x76,0x4,0x0}

You can see that the youngest generation is always zero,
because you're just getting the newly added youngest
generation :-)

This somehow suggests that the information is redundant, as
there is always a zero there.

I suspect we'll need an additional tracepoint to show why
aging is triggered and at what sc->priority it happens.

But do you know why you trace the moment just after aging
is completed, rather than the reason why aging is needed?

Best,
Regards

