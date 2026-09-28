Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA2E5CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2D16B0092; Mon, 28 Sep 2026 08:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AC26B0093; Mon, 28 Sep 2026 08:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2796B0095; Mon, 28 Sep 2026 08:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE4676B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:39:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62E3B401CD
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:39:07 +0000 (UTC)
X-FDA: 85263125934.07.95589FB
Received: from mail-wr2-f27.google.com (mail-wr2-f27.google.com [74.125.225.91])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E2E940011
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:39:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BT8Kpwyg;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.91 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790599145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DR3g9bGNtZFpf0xFNaanuycRzVRv1O6/PdQwaVpb92k=;
	b=PGd8i5CE6LP2kxM1lWvYSpEdPu3GHhW7uXRLrhju6JMIVnSrEAX7K/YxqO/JW4HRpWbp+Y
	PXRS4ejQwgrn20uCQgVAlRkxBUvAtNJOEVjtINSu/0okMu/utIuWdyj00VYoPmoYOT2mca
	1xcNbBNg8ek6TbnSe1zniIXEuwZ5d0s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790599145;
	b=600vb1BQe/XkSiA7Bkw/ZhBSV8Zp0UsFx+1ikGPN7wjMhVhaufSd3dkhyRqk9BtN5gbs/S
	mlruL6ftLfDFgzi8UhIOzlH4LoxkTIaiflaWJJDa9lna2lCHVFgx8e0w1SSn2mQExSClzX
	vuXYT8ovPlZIJRaj4lg41Cm1QfychR4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BT8Kpwyg;
	spf=pass (imf17.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.91 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr2-f27.google.com with SMTP id ffacd0b85a97d-4843796e373so1689370f8f.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:39:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790599144; cv=none;
        d=google.com; s=arc-20260327;
        b=aOHIN3P+HzMrwNRV2HDz94RDh5T3SF8n6Z8RLPspZHJQo1FM+nxdQX8+CHSkYSPvGU
         RoLIQvzceRN75xq/m5IXgrXfZlHXjg9kPizDyVez8mcDjz9ZMQzdfpy+3X1jpnrHoPVl
         v3tH4nbsCZCin5H30gA434okCz6A7lwZH6JnPc/J2oXsSc93kdC0KqtjE9EPxCU+ET1B
         jO3a/Uewrj3CBryLVyNVx1wBbwuAXm4QCtO0QGbTRZLT4xAfqkUl1s0qvtjcWb2fKls5
         fkyDONloNaJUWoHa+hliYd6iF923pPeHvC+JVbODy0hNJIG+FICLflfN0V5aRUQh2iuu
         kpew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DR3g9bGNtZFpf0xFNaanuycRzVRv1O6/PdQwaVpb92k=;
        fh=qtS00S4fs9RVs3QI6nbi0u6gsfGEKjRrirfxUmxrHx4=;
        b=AM9s+vFyv0y+dIT2lmRkDkgbuEhD1wu3cv2UnixEAaFF/lUuGs/TlB4azBpKjht/yx
         y5uDL7753MFiflbaRU6znxJwUYhG+XjccBrQsXi6Fg+DmVLg8DRch6Ch7CjAMlhCLLtE
         XQdAdTKgwW7CyEXXGMJEri/SqDrVgoy5OWXMmbOd0qqIeHtkdxmhUjN1r6IgiXOv5g4r
         BLT7SAtRCeZNvTqjGEvJ+browCS3Jz067vSx4FSIhqhMnstooyu+qQA6RPJU56gy8xeA
         64UJNLu1dgd9h1mLxUmdSZKwX1gJEFi3nmzM2E24CY8MlDNBn+tor6sv+M9pEP3wEU2M
         /O8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790599144; x=1791203944; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DR3g9bGNtZFpf0xFNaanuycRzVRv1O6/PdQwaVpb92k=;
        b=BT8KpwygnrDS8/A2PSotv6CuQAStoyyCW8sOBsFXIHl/L/nnBvX++87vE5qtF2M3Rt
         nVChALYehy5EfdtkpvmsQ9vBrPsVVR/T+prMvcd7dWBrhqom3Y1p05POoqT9kG4/JNAg
         AmGsIIAZ2piXBvtGnh70rbfuOwEWN7ZQ5eP0Hp6kUUsEaZA8+1QWLo3HHgCxOPxmiySF
         T3NPiUTRP1rz2drRqESBwkT0Ow0SJHYBMQmMnpsR3PWXv/kyz8BgM5ftTxf28NJVHQKV
         yD5cv7Kh8rwRLDVlfDsmBSLMwLgbwiFRn8NWxnt9n7+sS1MbvAnJ41oDtd4WuWAjRrWD
         Z6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790599144; x=1791203944;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DR3g9bGNtZFpf0xFNaanuycRzVRv1O6/PdQwaVpb92k=;
        b=ZzmuDOstWFu4sHes774ogx5Rp2C21fjQyuNGKYNIRIkkRu3HUbuioPC/Wh910vovpG
         tgLUdlUP5+dBdt4OrX7gDeRMmdBqc6tIh70Tmlj2P9W76adQj7STtqi6ntUYkoAYa83H
         7ZAacBgbA/neP0LaePiWcxJlK2LhRZVyMVbxCYNWzAVCAI4ggyYs8f0H9nGfEoq6H92N
         96EgM3eNsmKhA9I97PuDun2J2jnHCbdWwyF8eKDajAcQ3Vp9/UZQeMEDcABu2g906RRW
         AGTu19v7ZYWaEjmPb8CVpDiMN3Q5tU/Xrz8jLgZx7Y6TSUNCCm7nwXXyk1L7hhg4tojZ
         e2OQ==
X-Forwarded-Encrypted: i=1; AKwUvBwKS6xyUqnjETXpVGj/dS5FQQ1UDoYquQj9yHEkBGhdbTgF1CaiqBWIKmqebo87hszg955amdUTkQ==@kvack.org
X-Gm-Message-State: AFq9FYJ5VAzr5EuOVW0beHzqj+UD+pCepw57y/YIEAsNRIGvZtGQcft7
	Ikkcv0Qp0C8IZjP/sgpSmUxgwgmuHLsCal2B7w34KY1lLuuPLYnfw4rcxfzTdEQAXZqndD8Lhdt
	bNmGZLbGtYaxyM6huQljjFfl0KH/t4zI=
X-Gm-Gg: AYBFou3nd75xAvIr9r2AL0GIjiHTUaxrRK9GdBrtELoOFXMi1DqdLAK79Y1YCShG+Sy
	oDNBflExvHgNLJjej8VlvNmZ8eo41ziNszd0hboUz5EgqRxlotfhGUxHRujzhuUiwzKNoz2esz1
	L1O1JgSQCtBTrjiZkUtqOPdpcf2OtIsRk3obVyfxyCZ3pPLdEtpyT8rOv19RETfTRMVex1JcJXx
	wOwRz/apv2gv/oJ/P7QRsr3lDZrqtFxmPT5aGwFyOHXPMRu5e/pHcc2B62Mu8+q98u/L1gDryu6
	1gdMMhishphF/k/TIOLXc1LbVzl9BeSROp3v1xo+B+UVSBA2FeRmH0yZO04MoPO9xc1+7sq4W/u
	GtZg1TgP+fV4rCY3OPZ9gGaD4UFw=
X-Received: by 2002:a5d:5850:0:b0:488:8132:1425 with SMTP id
 ffacd0b85a97d-48881321709mr15591817f8f.17.1790599143518; Mon, 28 Sep 2026
 05:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <aqjpYHbZ14A8xRtK@fedora> <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4> <CAKEwX=PXRB35bUL1=O4Bgx9A7aD4izZZ3dcEcCuMBBhBrMv7fg@mail.gmail.com>
 <arbTTKE6nYWlNCLd@KASONG-MC4>
In-Reply-To: <arbTTKE6nYWlNCLd@KASONG-MC4>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 28 Sep 2026 13:38:49 +0100
X-Gm-Features: AclHuK-lq27s41PviCE5Zcm-NPp3FDhb-jdltfQx3nihLbWFQzzSVs0yJpd5MbI
Message-ID: <CAKEwX=MPrgkJdzAc-xjuz57nC2Rd7MrVkFzvorBpn1kV600iXQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E2E940011
X-Stat-Signature: r4s66hppoggefi34hgj9qcfxqxa79joh
X-HE-Tag: 1790599145-330718
X-HE-Meta: U2FsdGVkX18KSC7/Nuo4aVaPPBBJJaZl2oO3p0Rbl36goWhMyBTJ1s+4X4fDhlRiT/L45P77v/WIr/vZzjT7G5fP2nz12IlN1HikxK2czl18HeiH3utys/Wi5wP6l0+6XqUNFuS1+mSsiGEhkt6YP/N5BCJ/JzOeW96VV6dd46WMxh1wECbuaLrhEEvHWcyYNS2+zCkLpYOjxDbXalJgHpkTXdYIx+oqe13k78tTxPelLexVwaOzwMTeOqbmaMqyW4aV6uo37gT4iGjdzqPDbejj4dW07wfLur4EEL4wBw8/8i07o9QtShRuvYa8ea3RIbKsyCBmkzbW1yKChoDHR0DYYcNCbGil+k1fmf07t8gTOo94eBs+Te9u/l4b6BdQrXTnvH9hdlbdrkdAK+UPSyguktWip8uQcgzyFnLjpm8a7/zKabv7xG+x7CtRqq7HGpC8Yo8FpXQb35fLfJo6X3K2wJTXvyQe0jEEiYuHfSHHOttv63lIl32F5NZ7XZ9/LPrZ4ajaT+38Aug8iFNpG1TNOA07INg3bI8Laesw1/0WKaUfPDe3eKc2ivrP/F0K6w9Khqbc+hY5zat9xW4l1Zyv3zxdXhnefduCNhcA/e/d7Q3heBPyTXNs+rZO3tjKmjiCCvVZ1OEdlsZOIZCVHsz61PmfWhHDjcWcMPOLWHndYtYTMuM/NcqJjBHW6jPkZ3vyBB+2S9X83RyggWw5jNglv6hBhut4uCXhHwD8ZcspuRqVIXU2ZkrFMy9w3JHJEBeFBv9nTCUHU//OMnDCy4s+Cbb2QXF9f3HhPJF99kKH9+N8FxFAyyabBrt/lfPBWe2b9K649JiU5+360gDVfEzeDDaNaOMYs8NTK4fB0dYtMRSJFw2Av9f1Y29yJpHpqoVGE0N3cJxQVfH8+d3Vg++qiA3HSTFvNpdeQLiDmrWhhkol09lVwLsUvNDe5HIS2CpeUWXccdtkl4F6ke/
 7pM17W3G
 MNk476V8JDqAypyJvrShc6t6wrZ8bWrrMIiSGIlpuqba7T0B3vR8TRk69D+k6PiNtdb+dNNpl0q6dKIUG6eMnGAqPK9FVM0Fz7coye6N+RF9VfvDRG3KUsF6Os1Ms2dM2qxkZ3szxzFiRx8mc0Ht98CiHmLW41ZAaAm2x4D7hpteWIAXA6HY+0Agx8x4c/am6HJBsIYmN+cA+IoWkW2Q9FVlOwL2N7xxlKxRzUTj704KkllITIEoUgig93hPzDJf6+u7AjYZTFpBqfDDL4xNx5sPIsku5/x9HmMZxkThzf2W8HPlVLF4OIOkVbIVu3tko/AMVLrgiOzh6CfOG4B/rSC/NvnUca7q080PLPJkA+6aL9nq+bf3Im5A9Wkx/SSmT4xRA4Cc+qbtZsXxjrSrQhFthQ895mCm/vYocfawEodUUopXiOOnIfboDLTWt6AbJTG7Ug62Lx2pIQygiQJPsdLF+08bdvP/02hPgcGfyRxmTyF/OZoWQhTDjBxWpRQHFULsD/zr2QpT9VtcFV+8ra5slRKqrCjMEM3bz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 9:26=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Sep 25, 2026 at 09:54:25AM +0800, Nhat Pham wrote:
> > On Fri, Sep 25, 2026 at 6:15=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Tue, Sep 22, 2026 at 09:44:37PM +0100, Chris Li wrote:
> > > > It seems you are talking about a different topic: the vswap chargin=
g issue.
> > > > There is a golden rule that we should follow: don't break existing
> > > > users. At least with the same persistence, this rule should apply
> > > > universally.
> > > > In the swap tiers discussion, the UAPI was such a big deal that we
> > > > couldn't implement new UAPI. On the other hand here we argue for
> > > > liberally changing user-space visible behavior.
> > > >
> > > > BTW, I already shared that changing swap counter charging will brea=
k
> > > > our and others' existing deployments.
> > >
> > > Hi all
> >
> > Hi Kairui,
> >
> > Thank you for your thoughtful response! Lots of food for thought for me=
 :)
>
> Hi Nhat, thanks for the reply!
>
> > >
> > > Just for reference. Maybe a seperate counter, tiering, is a better id=
ea
> > > than changing the swap counter?
> >
> > I think memory.swap.* is never meant to be used as the "offloaded
> > footprint". It is incidentally correct, because of architectural
> > limitations: zswap/swap cache/zero page usage leads to real
> > consumption of real resources (physical swapfile).
>
> It's not that "incidentally" I think? TGhe defination from the function
> level seems pretty clear, folio_alloc_swap -> charge. A logical
> limitation.
>

I don't think so. It's just that until now, architecturally, physical
swap is always required, regardless of the state a swapped out page is
in (whether it's in swap cache, in zswap, or already wrriten out to
disk). So folio_alloc_swap() gets you a physical swap slot, which you
need to charge. That changes when a "swap slot" can now be virtual.

memcg folks can explain better than I can, but cgroupv2 is meant to
isolate concrete physical resources, because physical resources are
often limited/static, and can therefore be contended. As Johannes
commented, that's sort of why memsw was not ported to cgroupv2 - it's
not an actual "physical" resource, but rather just a logical quantity
(that's useful to reason about). You can also find this quote in the
documentation that explicitly spells out that cgroupv2 is meant for
physical resources:

"For trusted jobs, on the other hand, a combined counter is not an
intuitive userspace interface, and it flies in the face of the idea
that cgroup controllers should account and limit specific physical
resources. Swap space is a resource like all others in the system, and
that=E2=80=99s why unified hierarchy allows distributing it separately."

So I don't think memory.swap is meant to represent "offloaded
footprint". I mean even in the current state, that conceptualization
is already shaky - a page in swap cache is resident in memory. If you
mincore() that page, it's reported as resident. It's not offloaded.
But it's counted towards memory.swap because memory.swap tracks
physical swap usage, and swap cache page, despite being resident,
still occupies physical swap (until vswap is in the picture).

A really good analogy would be virtual vs physical memory. Correct me
if I'm wrong, but I believe we do not charge/limit virtual memory
usage at the cgroup level (at least in v2)?

I think it is fair to expose useful counters that users can monitor and act
upon. We have a bunch of such counters (anon/file usage, thp usage,
etc). But virtual swap usage is not a resource that can create
contention or isolation issue independently of the backend it take. I
don't think it should be handled/charged similar to (or together with)
physical swap!

