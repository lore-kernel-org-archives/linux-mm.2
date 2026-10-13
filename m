Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4600ACC6B0E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE6D6B0088; Tue, 13 Oct 2026 12:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0880F6B008A; Tue, 13 Oct 2026 12:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B506B008C; Tue, 13 Oct 2026 12:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A34376B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:59:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E64B140D03
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:59:39 +0000 (UTC)
X-FDA: 85318214478.08.D13DEF9
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 406B0140009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:59:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DjkkkwIR;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791910777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Irc52p7IpU94MjhUuTv/4weSSBLioQxa3X0dPTYCCpw=;
	b=d8nGuvwU2NRLJmq98gBFip6dpCI6IOkgfYGNNTXXm+Bv8AsjyXWOwHolyoAFGOecsaqeFS
	b84diiSNl3FI9U+a1AWJv3LC3kxJHoq4ffu6bG2vmEu/pSklP8SnJ0Qo1Ghm3n7ZkZJvZ9
	yw9XrXMxRWR1qUtTDbM9vdeyetE/ZoI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791910777;
	b=c1++O7S5YcCaTzhLFUjoQuCQL7IA9XVB2diQ0e+oYwlsYKtMdfQeC6GBPqTwdnm4roq6+y
	KpWx3XWukqQhxW6jvAFWuiuHY9d1Q/2OyY9kDMF9Xv6ioGIAI77WjfymRYlkyZJEHZnHEV
	W2EZQYtWV/F5siAWHEzTo+Q36MP0Ukk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DjkkkwIR;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2afa22e1dcso455041466b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:59:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791910776; cv=none;
        d=google.com; s=arc-20260327;
        b=k8gU5Au7d4mTTFVOfk0sdu9Ehooi0+ZglzK6YlpEqZABBdrN82iVap0gnqhK+LpwIl
         i833b8JZm+COojBEDwlsNvWkxzqr9pQjZ3S09L2SUUUntLYqg23Poc5QNWeRhu4YtPrc
         rsRb1fpvB/RNghgdPMOuMMb3khahgW7pRgZY4AYEufiSlqurAVsd5822lC4NOeofr10i
         chtQWw6uSNmE2Gu1R+M6EKmB6bhxWhdRiSOz4toZkWhKW7rnKh9UppUSBK9MUpTSZQsF
         7Mp08j5lJIgm8ROy2H46KQLbHlkJkF/1HQwhy5xYTduCnWvC1LnHcV58ZdZO3kwbvopS
         qfNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Irc52p7IpU94MjhUuTv/4weSSBLioQxa3X0dPTYCCpw=;
        fh=pvjxbr9jyGES7e6rJXjVWk4iYC7w9QnOpmzaWbBn66c=;
        b=Kk7gR4rQyNhprqG4LuHJ8HCqHi1PpSk9qzKd/v7k3bJDftQESJHDdwhe61Vwpoqf1L
         Teea6ldwLjeKmT0JjEdr82pMlbNE8XbbfOXLTtdgPKW8B4Sk5l9S6gT9P9GxsgMmFaYI
         XSF1fKbzCLgfISpIOtCdffRdhieQD/KSZCtJLuTCft19oZRDYZ5vgGKw5wxlCj4aNht1
         MrUOkZDphGureAxABQrKWMnpakwc3v4/17GQndkZ/3hqsE3/ULV43EeQabowTYZ3jiZS
         QUnknsMNdqQdXtFedOIXNziXxZ1RL+2xUPP0Y9jSnKtkX/3MJhnE+a1d9siwcy8GEEce
         acnw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791910776; x=1792515576; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Irc52p7IpU94MjhUuTv/4weSSBLioQxa3X0dPTYCCpw=;
        b=DjkkkwIRReEKCClJF8EnpVYYFBfCaT8txGLsWK72zt9uYO+7V4RBSwNlyerI9AxmyO
         w0OtXQd41Hbd2qTmUFW00q132Bz1Dl85vzntym6WiJs3XqLp88uMKoTnXZIiQzIQWo/D
         4taGLdCsW3hM/m9IZ9lJ/5/e6BX0zjQO9fvIvgPGEpCNeBj7tmY4eVgz2zPKjpdKL4NN
         xnKAAPyJmDZoBAXby3sAKwUbWZARk/xM3i3js8iAkTd29ah/nGJu3kh+UG+PEI21+i25
         d4vQLYgGc2P16QPwDCJgylX+BP+ZfAnJlGSdRaJABhE+6Gxl1Oa/ARca43YdS0C2CHDe
         jIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791910776; x=1792515576;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Irc52p7IpU94MjhUuTv/4weSSBLioQxa3X0dPTYCCpw=;
        b=MkiGEqQ4JqowcAU55p1GFPoKHCTguQCxCQV+l3rp8IrF60zkSXiPO3Ww/x5tKZWrEY
         CCEllkncTcZec3CnXf8rD1HxLp5JgZ6fA5UFTbVY15/k8Qm3rJiRWfIrS+IgKGnnY6Tq
         GJ5PG2Doq1BnWqTOW7i6AoUd9VtopTBjZXl47iet+rVsmnxUMrTymL9q3RSJXPT2d8iw
         +m1UvxVlun3xDIRSmTrrd6uPbQexdMz2drc2cCIxDy4yoxLZ/xkfoqmqvuyefUg0V4kS
         hQgWMq2CZIkJM/vuJ2Xau2RZIUbWtqodKwNlhuUaT2I/YAbagu1RoNZNlywmUeUhWBSV
         wI1Q==
X-Forwarded-Encrypted: i=1; AKwUvBwyuRn3Bjfew3S6qSB20FzgbF9+DiYLg7B4bHZcwV9Pn8y8R7zdOQC4f2fLUrf1SVvY/vMcHjpEMA==@kvack.org
X-Gm-Message-State: AFq9FYKvr0lyj8Oba/eGOVWGBl8OSJpuvmEd1f1yX8MtuINNMf/FToy0
	Q3+RRgFLvm3dMPaMgBwze+3oF8ajPaFxN6oLWUhVY67UU4hNO5U6dczHe9jmg9Ux6L9juUOxyHm
	opfvoFBxOlpfDVcVcNwygLC3D0khk4ms=
X-Gm-Gg: AYBFou3E7R+A2xAthLZcSoUOW6bPqRuZkBT05k54KanKpNXJfNzIRjVT/M5DbM0c75H
	8g9EBQuQ9c6rHpxb3Qr8F2uFs9mdqTwzTHZBavpcq1tdqZ8GH0SrwLjnr+yOhF4f/ORll8T1g/J
	zZg7hJ36hUmU+Pvw0Vz0OS4K4SRDfIr9HLslSgs+uAUw7q4ATHEIdb2irAS9iO/bnJWezSwXk8/
	9N7WXY99KTwBOliaaT5ZIt23/3xPdyVlTjiHOirDp5u8kF0CUDMW6rOweTGad+uLg7gc7iNuqNn
	gFh9Dq7WzWXnzg/25uDLLqq725RZJggRMR0EvFdVjH16ipxayEzYhg+//+VllrdafIM8HFzrN+e
	l6rZk584tphgs
X-Received: by 2002:a17:907:3d0b:b0:c31:7495:e5b with SMTP id
 a640c23a62f3a-c31a9feb26amr1246342766b.10.1791910775410; Tue, 13 Oct 2026
 09:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com> <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
In-Reply-To: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 14 Oct 2026 00:58:59 +0800
X-Gm-Features: AclHuK-dRyf9eKLDd-E-CAUCwm0MgTdU0FQN2EyVlbP88Wn126rzBlk5l-Sic0w
Message-ID: <CAMgjq7CT2O2VHpwZazugQRopi4grF+T4oOxZznoAGvy93Yjh-A@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 406B0140009
X-Stat-Signature: 6xobwohzu6ebzm3kf63kwhb8zrouo3gd
X-HE-Tag: 1791910777-604313
X-HE-Meta: U2FsdGVkX18S6ojh7tC4Yw/OIO1mg7pHZ/tXIFRphSyaiT/oSfyQq4M3ffDbtosPyGzOqV6Umh+UhmAKBVTs+6Rp2t/kNMWG6M0jjd5W6RfLKPkBwfi/MZ0eeVJ+dyrUKEo1GAGabJKWP/q9oLwPeGb+N4qehREU5sYIyr4KoA5K0jqj+v58vsBZgWWhdH8Lgzx3zHOcXhcem9h7/Z7zmHMar5dblFT/tkxnlh2nl0d0FhF1uxSE6/Yp/pd1ewvhG/wzhupfvIUuquzpst6MF0mOZckvSfVMtKYo4wrmJb+cVSAP0R//+5QiO4ZOsboZRbRJFry68YOO2eJihXOzDhkbbvA9PO+vsEnilLe72LZVIYgfwewCmVjSUQpgtUAU0Cbb2JUY9r1K2gM4kyhkOxtFhQvcp636/8jxePyPzzorpbEYn++bmWOFtFue1UTvMS/RT2xqZuo4o7uCAfkwni1RYfeEhvY/18WszXNe8woVvtyDY9DfxXcj4/WJSMDWmnb+tIhxI95Gs1JQUNuExpMnvmeOagf6uw6UDDCn7HwuZgueIxgrwgpOoOPY9Xey4eM4aXc35fKd2vQE1tnYx0Ax5y2msaRvtrHz4dFLNNOkK/wvggCEvzralD1hOrokDYmEKGRf7qr6TEfnMpDQDnKm7O5h67GqEoC15NJNpseldFzjGHFn1s9wUfdecPLp1afF4Hnq2XyvVrm7DaVst1HqIHFB8JIyz15HVVnU8ZKTm2v2pW/V6qTBoCAB2cOOfbzkHveMHGnn3i1kinIyutx+XPhxSxgGM642UoT7xTeR0AD05JWNzqo3UBMKJNWYo/9flaMTPJr/0xHSH/X2cYMBrEvtleMykCsTOzi7DFL4Ng5MWuXPo/wGrHQCEVpxha/YhI20pF5OvpCJmJpEBVex3wymxzli83EkEkhn/RfPIbEikn/Ne75ousC5qZzKXYRalvOS+/64pH0Rpnd
 bmmSJZ67
 19JbXVwN/EmbvTsYjP8qBQT8Ge8D38Q8rG9JQYNn7A0T8C+5ipg+n0XKI3qMF0EPgFUcfmpRpGFbrCzb3olQU1GFTA7d+4j9oZF60hsvn8IrhUQEykGzRByIbfMJapbxQmQP7Vw9RB3+E+O0mDiTn+zTpdTwYUwm87A8nsUBob5G6E/gyUZB0nXqcOdIFqMzqTeHuMjYrQXXsVsyoO3yO4yj5ln6Z7UiA0zcmzIw5SC8Ka/a5QPOBQLGWKQgO4qJxvT/kfV6OrZG/mkK1MytZ3R3OWsfTbq5OHRapbqJl+lRj8nvV5A07cRe+aVsvFiJtDOeZAxiwxC/QUoOiyijWOonEr84cPF9VLp3OOfJ6zwTTC0wcQtVOFvw8+tiIJ812Zsne4jansoIsOinaf+H5jk0+n3nQvjVuL0W6CCDZmJ15RRCPxuzxvl7AX5zM+EzwnaVlZ82B9IxKV2bOI3VMcbCBDKjLn6YwbMg/ONX6kJGu6tLXXneZeBcyBb3g3BMnBlz79ekRYwnGOwqaAxJczYtvt6TgxdQfDiMsAFvOtqaD5xwsAPmiJsf7Oyq3n7u3UUi+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 8:19=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 9/22/26 15:38, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> >>
> >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> =
wrote:
> >>> No that time slot is too late for Asia developers. I don't think we
> >>> should use that time slot for swap alignment.
> >>>
> >>> We should find a time slot more friendly to Asia.
> >>
> >> Any time slot would have that kind of problem. We're spread out across
> >> the globe.
> >>
> >> Let's just use a standardized time slot we have for MM alignment sessi=
ons.
> >
> > There are more swap maintainers in Asia than in the US + Europe, at
> > least based on the maintainer file. Please be more inclusive. If the
> > alignment is done without key stakeholders, it miss the point.
> >
> > Sigh, we can't even align on a time slot.
> >
> > In that case, let's keep discussing on the mailing list. At least it
> > is accessible to every one.
>
> Looking at the mailing list, that approach doesn't seem to work.
>
> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
>
> 1 AM is certainly unpleasant.
>
> US vs. Asia is also tricky, but doable.
>
> China 8AM vs. US West Coast 5PM?
>
> China 9AM vs. US West Coast 6PM?

Hi David,

Thanks so much for suggesting this. Sorry for the late response; last
week's travel resulted in a lot of piled-up work for me.

Both slots look fine to me.

