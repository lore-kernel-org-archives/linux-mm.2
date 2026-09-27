Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4428AC98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 06:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22E06B0088; Sun, 27 Sep 2026 02:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED34C6B008A; Sun, 27 Sep 2026 02:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE88B6B008C; Sun, 27 Sep 2026 02:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9ABC6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:23:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F7E3C09D5
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 06:23:29 +0000 (UTC)
X-FDA: 85258550538.17.4C7A1DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A38040005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 06:23:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgjDRlH+;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790490207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abQ20sTrkthDKubL8xH9f1qWTFEmLog2Xb7FTeV5HhQ=;
	b=4o7G/GWrzGvFvSfZ6QHZX5MywkmjiNzVYYp9MV/2soYrYq5+TwQ+mQcBXPCFueBRGSlx3x
	PPdT6GkZ/8bcSohS2ul508iJI0DpnakMPIDYOYVElb78v+t8Kfg4SL9t5n1pOVkfoBxhMM
	tDda4CjqSzS5QzP5a2STJ223x5nbAsg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgjDRlH+;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790490207;
	b=M/RMyweI+kHDKLeKSTris+StxzgW/mmWT0plQAuUvdfiH/HQfaTKEY+IuQjxvN6QzEd+S0
	PHj3dxa8lU0j9XHePftRpEj7/FTJpiqVujbWgGwVAuqtgbuIhK4LiVJYk3gCIlcbj5r825
	jSmRRT/B+XesX6Y1CsG3gBJSGuEhc/k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C02043E9E
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 06:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDAB1F0089A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 06:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790490206;
	bh=abQ20sTrkthDKubL8xH9f1qWTFEmLog2Xb7FTeV5HhQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MgjDRlH+sYmzPaCjMSbcE3B7aimF1q17Fn2czcyRyuRVJvOzNSF8TW+yv5wT+RqVw
	 +as3k2Liyt0WODzu2xA+ywYIuPUStXP1ftIHnpEO1ihWgyMUvRrTaDEy83uwIWflSE
	 yazikBOTHeYgknkYOEjPgxXexwFhLUtOFJiSQRg1QmO6RDSWDco07eJ6BtSvuapDfP
	 ZTSKUxftQ5D/UMB4DkBvI0EEoXYn0mvU2SQpYmZgggkdd+IQcjPDDHKhwkVKv2RgNY
	 PLcnJUUbx+/g9aIvUufLV3c0kyfnzvA/9tirNo/F0zZ1+IdGDBo/f9wnneb7cwi0Pu
	 ErqEqM5pQjFlg==
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af7721e4aso217991666b.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 23:23:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxb73yXRSaV57tRvA1MyDde6P88yrLvmU0JfJ/tycw7Im+DIoFTygz2pJEWy9fNdKYId9vWynnkDg==@kvack.org
X-Gm-Message-State: AFuF++kikhriry65UWU+CeFHk+6jHYV9dscwHwZGEmFbMHNqllLRqcNn
	4N8fRzQ3F7QINTIeBH24re8ubnR5YjMnqBZmLrKHw3+OGEF0uKWcJFTuwTA36FGkC7IxNWQdMxp
	d8gMBbgxlLktGvXMN69Io4mOluK5mX3tiVOF0XPlQww==
X-Received: by 2002:a17:907:d408:b0:c29:3821:ae6c with SMTP id
 a640c23a62f3a-c2ac2606943mr866958866b.37.1790490204956; Sat, 26 Sep 2026
 23:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4> <araWKyJ5MENBwXCL@cmpxchg.org>
 <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com> <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
In-Reply-To: <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 20:23:13 -1000
X-Gmail-Original-Message-ID: <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com>
X-Gm-Features: AclHuK9XVPbdEdRuFYnT3RhuHd6CxK6iuGG39DZDVhwy7Jj_A42gkqdamTqXRIk
Message-ID: <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A38040005
X-Stat-Signature: nxuwctpga36em6csqcbzhe6ody75gygq
X-Rspam-User: 
X-HE-Tag: 1790490206-352640
X-HE-Meta: U2FsdGVkX18hIyFpJLQ2suUPI+p6JD5jKIkPym1v6EM+5lUufXrs79TPS6U+A22iJ4K6uENhANFMe7+gwOuv94r/soS8Mb9mZ5RoPVpYqaLnNxilX+ZIL7fd1jd3Ead60+NBUCFU3ugAu3eUj5RuebrRCpXiPknWzQiNNtzLgJehtZf0oo2PjUxbCGE/eMPDy7FBiVxlIwlA0e4ZKk6VS5J+VafOln3Al+PhgE3228kPgd32n8sycus1gGVCe5TEO0Vo7szPxOuNQOtFn2C2nR1BrfMVQ10hQBEYU7PKJNb3cc1QLcQeHOjgieJGGsSS/XrWcXWcQMk1EQxNuiqURFy9bn8l8f/ZfrE02w75VF/fWEEWqyyxuavsbVdBYYee0lZbVosSOd/IL1Upk8sysW/+hp1VCj8d465LKORG6nHvGcsA2nzxc5nPpa32byYwUrA/oFfHesMI9MFi7ci1qD9npI041t7fxCDQQO8y3O+pIG5jS7X/f9ZC+TAcWWySzFL7G2BHiSi+modk3IwXJL2VBuCet3rUc4mf1gKzS9Gb7hgxxkv7F/yKBdEjzR22yvGQ5VnlL5Mrx/RdySpZgNqqk05IYN8kTBDcB7CF+hJmN4xDjnd9Pe1BoiaWPnAv1Wc57bUd5/1oI08dgDY1l283ib+ylbLZSheRasN/NNzrFs+iFCjMc7dil2Q75Z0Z2X6hT7yJjbzV6py2Vv/sZZ40FsnS+ngPmLzcSz0PXaDWv4qnVtf5WvpW9CUnz9T1tiicxdKxeobZE9UuvL/ibnstRIFq2BlMUf35e8p1v99UvAeDDxkvwY+/W/U1ZsZobFQMCA+qBHq6p+hk3I6j1F9PIxdKW+kx3lgKtQZT7bSr/8evetc9Y4v7JPv378ub64hGmnZubzP1QFSSPLjl9EBSo6tQONWVj7E/UndLwKyg+c6ir0SXhME4fFtx0BkO+kk6YALp0peYhk7YmKO
 0CzH5dwR
 Ql3sZKRjSAr3ZKuPqPOoxEm1N1Z/p0PPwB0EGa3D0ogWjDEoYatI785nUzDFBJed2uHF4IYnbHilK42ioDqApQNJmCDjRBZUnQj27R3jmDI0kZqdmRn9w1q9G8unv4daeCe/hScZB2DL2lxoiqWkix1kILDIzX4qMeYxFu3i8Jqqih+UPMBpkKWTkbtMzYLX4ikxJuMq8o7lajy6e6OZJmPX1wJG422eIQ7D1DEvC+nDQ50371KgyEq8huEBmbK8RU4f85iwFlBgImJqIbvj/79W1XJ+2zM2rTLvg6PI39vatmd/VRBUqjRoeDtViPw0KAxyQgv9nA00NmeogLtJTPi/hgui7nXW0aLABNRdp3E4by+yayzxrgNCfAy72cuR6LeR1X+bn+vD46yGuNK4x6eR/UVey0ydpwbNj7kD4xjVcpIUUm2Z5xKCca+A2IOgwgQrx6RLEzoGeLNlPsA8NOvqVargrrXSko/mZUVOsCXmaxjWSKENBfYiSb2jjzt2BUsd87hkdEbL2KvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 2:59=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sat, 2026-09-26 at 11:27 -1000, Chris Li wrote:
> > On Fri, Sep 25, 2026 at 5:41=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org>
> > wrote:
> >
> > >
> > > (2) The use case we have. Use memory.swap.max to divide a finite
> > > space
> > > in storage. We only have so much space on disk, and we need to
> > > manage
> > > fair access. Note that this isn't about speed. We have a mix of
> > > containers where some use writeback and others do not. The ones who
> > > write back to the swapfile need to be able to get their fair share
> > > -
> > > not more, not less. Including something that doesn't actually
> > > consume
> >
> > Just want to make sure I understand correctly. Do you mean the fair
> > share of compressed memory used in the zswap case?
> >
> Compressed zswap memory is already accounted for
> under cgroup.memory.max.

Ack.

>
> Compressed zswap memory sits under memory.max
> together with anonymous, file, and slab cache
> memory.

I understand that.


> We do not need or want another limit there,
> though I understand other people do.

Ack.

> The fair resource use from memory.swap.max
> is to control how much of the fixed swap file
> (or swap partition) space each cgroup gets.

That is the part I am not sure I understand correctly. Fair in what
sense? Using the swap file proportional to the memory limit of the
cgroup? Do you have an example of perfectly fair swap file usage for a
cgroup with an 8G memory limit versus one with a 1G limit?

Sorry I am a bit slow grasping what exactly the fair behavior is.

Chris

