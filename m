Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F67C606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 20:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUOaND7i
Received: by kanga.kvack.org (Postfix)
	id 85C1B6B03F1; Fri, 23 Oct 2026 16:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8342A6B03F4; Fri, 23 Oct 2026 16:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7224E6B03F7; Fri, 23 Oct 2026 16:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4316A6B03F1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:26:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D69A2A7581
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:26:00 +0000 (UTC)
X-FDA: 85355022480.22.E144BD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E793380005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:25:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUOaND7i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792787159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBpuKNMULYb65Wu/rSVhgxM/BAFCtGUZFo7lMN0HRYI=;
	b=zQgpBcGbPnx01SfUIP3UOTEToc2g2dUVzn0r6pbZZt0Xx67MW5mtSt8Mdf0UdlnHZLaERh
	B02QCJ7SqR0Z+pONBIlNQQzSfzUvv23jlCrN/uCTiPE8cXjZ7XUZdJLZPvCj6Q2iYdGgjZ
	/MzOsYMOKbs4IlmEjyLCBstay/xjZRE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUOaND7i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792787159;
	b=WLIsyVaqSKyMbjMTq0D6DWlkawA8EyTFX6QJFUnQ2aG5pRqsK/uTiJF6SNHsaSB/SBlmEp
	Y7TydiZOsuNpdvxdKEwOadZMLPKcq9QXoMtlfJo0P8NW5kccUJ8k26BmfYn2WbgDAywMpj
	Lh4EjcuJc/hpFyAAZgqXR3Gj9uMnGWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0650F44011
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E256B1F031E4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787157;
	bh=cBpuKNMULYb65Wu/rSVhgxM/BAFCtGUZFo7lMN0HRYI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kUOaND7i9bo+LfQTlYCeMSIMDINnKcKAqzuMs6mTaPqaxiTdUM7Cuhgwkyc4rUV+L
	 asihWuH/R5+ji5wOTBIsOO3tYn6oPdD3FWHhPFndTOA9kKA6rHw8if0NbUunXJe+0l
	 m1t7feyGN5GBgprlHNBPEdIE0kO6FexlMjMALpVVyqJGMkl9aS0eniBHZKhisVafG0
	 K2f11eEFl4rCCpHNij+cIYKY9caWSDaI1dHvhPNnxcgjMTUCnyGP32QIzcHxoFZkWp
	 11jRgeKbR13eGBAEMoV7uX2iZ/ZwOYW9rYwiivm5PV9BQqJ1Iv0iQQofxpPq9o5BBe
	 BUNdm1MazjOgA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso193696266b.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:25:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxTHo13Wuzs2C0nn/4bCZ+XZ71bX0xbAoFv3ilyaYGT9o/5no6jDdzY+xTAyW4acMl5ZFg1A5Q3bA==@kvack.org
X-Gm-Message-State: AFq9FYL9l9TlA+zQels//A7lO/MKn7sZ5DLhHA4Wfyn7ajBNMiyr7cHV
	X0th5jO7DquxbkcOPqerEfzHlPcZfGQfdbUxsGKHjufJf084h2WeAcraIBM8f26l8wb6JnIqQik
	/hu6/Vw712DlyWskG0DCN8WfM8mC1DMo=
X-Received: by 2002:a17:907:b041:10b0:c46:7ec3:fdfd with SMTP id
 a640c23a62f3a-c46bddb5527mr644266b.14.1792787156537; Fri, 23 Oct 2026
 13:25:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com> <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
In-Reply-To: <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 23 Oct 2026 13:25:44 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com>
X-Gm-Features: AclHuK_uvs0DAK96R1pRTbfdiLY8KlmEoFiUjwQOc3DD1U1FsjbL17wAqwkQa-c
Message-ID: <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E793380005
X-Rspam-User: 
X-Stat-Signature: ohibgo4hmju6zyxsftu6b484sykkqp1s
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792787158-990807
X-HE-Meta: U2FsdGVkX18rIdxUt2cz091mg+sYBxBOrSrrdmJQp6MESoUfWj4TOSVulcOvaZjDc7leOYQ3lTuH0KvsODcX+iS1bVozZajm3yYG9+jbqefAfOBnhAvTEBnemvYuyobbzTmhN3kWiLPRpzJiS5fu6PcQEHxEvblC3bSLGZrlOZkYGCUohXEM2NiAn57s42k8rMvIJr7XN5ZMw84wYi8BbVGVVmCGnOQZGBwPZXJHmyt2tgQTNMqaq2IuiRCDxkli0bbVuPVnOkELqM5tNqQ132tFl9s3QJ1vusmcZqXmy4yTlNL0jZv5jfeY0/LaG3B4uuY3pAkkXBNgoE9eOSTkfkXbjewfCZaROXQqzclGBUKiL21KTEcsa6RzEmRkG6GJR5eFOWSmScXMyaJEdb1yreTtjMEzRbTj5uC8ADdZKlUYDIhdtlan3mn38W7guzFrxU730QzfVAj0s5P+95eJF2k6ix6SZ4kHrAcpYuPtTenudzEWATKHOucX10Oqlf0Qiywt3dhH65NhGgLO/4YsnfL0H6i+j0JikZK+ikOtcya6phWMA36I7Obiauyu/SGHXVeqhYWO9Yj8vK8/l8fk+yUYBnu/s1S0pbPL7HHl5wU/mQSYnHVUOnLVfILkyjjdbs1N/Cad8d9pzTy/lKhcj1e5vFGEiW0enPVH/gC3FjrUL4jBeqPOB6SXaCnN/9doaz+coVN4SmtVa9/+K7y5ShXs2uvMNy8kyz3ztBMjoA8O6Iaz73kOKn2QrDKvavbRrl/nTkx69pc/2zF0tXxRQ21th3CiXUu5oZH/NMwLgcYVY7IqoZj1fbouu8Z6Q134A7GD7NydhqQR+LQq9K52AAHVls+k/nvrFlJqlqtrNFYYTCbgE0N79iztRazg4V2RV6EjBzErIFz2egl8zTHTwYxeF3PfsQbCwxAZqQJZ5i+tkBridBsnIoyqqZJ9WxXo49urW7Y8/U61vCW14MD
 EUxntOcr
 8IRdePTy2bIuE7vMzeEFDDtC4TY+UcXnZe3tpuGL2oo0iuyAwhwfWJYq+8JtXrJNt+rJslZi8gdJiD/2DU3eQ3Sw6gtLRKwGOqfZYIYVKASO3eQR1bGE8ASHoEJcNUndk1qQzmQkQz3ewei/+hMtF50TlSCA78Zk0GfEfTpXTru+hEnImxV74scRHAysMr9bB9Mh865QLwlZ0dRuClXEzoWFtTjPARNWbc9Tw0RMU/Tlr/sx5qWRagoeXlkRWNa4MAzB0ESgwVpVJksmRhMfOXy/FP6prjxsxIt4nvBfrbxxcc+sJzvhSgOcYHezhaOEB7VJpUKgiE/1w4tDxVpgAGWAU1f846M737O32wOFqsedhGB6T1wobu3IluF7OfNdTac/s3FsGGLWgUoTKoCo2bFYV+1KAxYEn8ZEvl31rDi5JAv2KckvHjuhmxgy22kAOLqivGXYswx0JAtIhNFNOZG1VbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 1:03=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> >
> > * Swapoff: this was brought up as a request, but we ran out of time
> > before we could discuss the motivations and use cases behind them.
> > Folks interested, could you explain as a follow-up?
>
> This is one that I really don't understand.
>
> In my mind, we have vswap sitting as kind
> of a swap VFS between the rest of the system
> and the swap devices:
>
> +-------+     +------------+
> | vswap |-----| swap cache |
> +---+---+     +------------+
>     |
>     +----------+-----------+
>     |          |           |
> +---+---+  +---+---+   +---+---+
> | swap  |  | zswap |   | zram  |
> | file  |  |       |   |       |
> +-------+  +-------+   +-------+
>
> When a page is unmapped from userspace by the
> reclaim code, it goes into the swap cache.
>
> The vswap layer then decides where to store it
> at eviction time. This is configurable by userspace.
>
> If the zswap pool is shrunk, the vswap layer knows
> where to put the data next. There is no need to
> change page table entries to indicate that the
> data was moved from zswap to a swap file.
>
> If we decide to disable one of the backing swap
> devices, the vswap layer can just move the data
> into the swap cache, and the page reclaim code
> can evict it into a different backing store, if
> needed.
>
> Using vswap as a swap VFS would also allow us to
> get rid of the page table and tmpfs scanning
> code we have in swapoff today.
>
> In that model, I really do not understand what
> "swapoff vswap" means.
>
> We cannot umount the VFS.
>
> What exactly do people want to accomplish here?

Today if you swapoff a swapfile, every is swapped in into the
swapcache, whether it's in zswap or on disk. With vswap, you have no
way to trigger swapin of compressed memory in zswap.

Wei, is this what you had in mind? Can you please share more details
about the use case?

