Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D2BC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 23:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488736B0088; Sun, 27 Sep 2026 19:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4394B6B008A; Sun, 27 Sep 2026 19:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329586B008C; Sun, 27 Sep 2026 19:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE4C6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:50:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87AFE40AAC
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:50:57 +0000 (UTC)
X-FDA: 85261190154.08.1A689FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 92FBD80002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:50:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGzlXZHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790553055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QExukZIjY2AejkBgnmymsglzpWFxW7LnbDXCoL9d84g=;
	b=H77A8GwYN9qp5pa7MV/+dksoQbvBlm8t7OKSxlMZAQeQsckor/ocWJKWMGSPqIXbIngXcY
	SORWDASLDoIEiF6JRMEruclfNem18ruyQlupYFoCTwevEHsIZs7zrdN1NwREP6zCMrlSaA
	2JjotE950tVToY43WmZM9L1dXcQofuE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGzlXZHz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790553055;
	b=qA/7x38kaVWiUyuIBYxhLUvJqVyLRV9gMKOw3uMr15h45MpzLz4LjJTKf0KQJ9RogU7PWA
	dF+ydrGjKuf8aewBsezlGk6ksqbaVvPIen2yYrLvAPlY8VA7VeRzsJrffuCX/A1x4XRzya
	jGKAQHrIL4fUPSrcJ/6p8MDBz4aMe2s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E21C3447F2
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C486F1F008A0
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790553053;
	bh=QExukZIjY2AejkBgnmymsglzpWFxW7LnbDXCoL9d84g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IGzlXZHzPr/8ECiAyHaT53ppe9Pa4uTrD1ifyleS430p+CIoNxFgspLA9FOAsgoDC
	 Y1V2LIBTT8FgrqI2FugbvCuJIkj4gsoUXcAtu8rVO7ZOgbj1sQNUPRR3RnLIuMpYhX
	 S9T/NVpEF/tX8lEFHOZdVDoddxYAgHUtn5lwnQ8QDRBmrzAq9iivyjVkw3DBjmOBfW
	 pFvQyFnYj3ndeu4drCcgFX4gCigXcUi4deAJQJcJ+ithjTcdzZIJ81UfavdwngKQiD
	 Tyss9VhZN9MePsdYqjBBMuGI01wvOBZ9B9NkXWGLVyWIFT8aCuACQIWAfnJJLhl4M2
	 IhhraGasAMuPA==
Received: by mail-ed2-f27.google.com with SMTP id 4fb4d7f45d1cf-6aa135d6e97so3834594a12.2
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:50:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy6amp7aZrfw+u3r6qawJpRJKI9uRIiHBFuT/SeDMSJqQnu9FYQ9hR/AqXuqSCATxajfhCYUMxTMA==@kvack.org
X-Gm-Message-State: AFq9FYICXLHEmaLVGvdFCVhUd1KHK2kp4es+E5FTHwFXwEqYpwkx+ghn
	VOThRd3ywxtDeFtzjhaCbfPiC0UXiuHeqahzd7ywPM6/t/9AWW5rEVrQy5U0P0q93Zs5T9tRwQ9
	cPNHSSmaFhCMx6CYP1b+qUEOS3RNUfRqk9vFD19u2yQ==
X-Received: by 2002:a05:6402:3226:b0:6aa:e8d9:7d12 with SMTP id
 4fb4d7f45d1cf-6aae8d98044mr6856124a12.6.1790553052488; Sun, 27 Sep 2026
 16:50:52 -0700 (PDT)
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
 <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com>
 <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
 <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com>
 <b792823cce613ce756227a3b60cc245b0316a800.camel@surriel.com>
 <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com> <1739d52dcdebdc589826990ef2938b58b1055e18.camel@surriel.com>
In-Reply-To: <1739d52dcdebdc589826990ef2938b58b1055e18.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 13:50:41 -1000
X-Gmail-Original-Message-ID: <CACePvbUjr2kW67r0Baz748p-WLk4rPww7V=sS2s87U=R2L7N+w@mail.gmail.com>
X-Gm-Features: AclHuK8wcEl0AbVxEBkinaGVysym0CjC226qO7EjIvxWHxxkRi6EAgi7L-b2h2U
Message-ID: <CACePvbUjr2kW67r0Baz748p-WLk4rPww7V=sS2s87U=R2L7N+w@mail.gmail.com>
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
X-Stat-Signature: riq6wge1muia35a68eor1mrzxsxf589x
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92FBD80002
X-HE-Tag: 1790553055-560181
X-HE-Meta: U2FsdGVkX18G4yke+ZxTDZ4tmXyllppGQ2bmJ1ZHuSosurd+RrKjfiVKcvP7UwMD2rM2WuWNF51Cjk9Z3oPe3NNxeuD0TnWsgAvMtrzInyRPmp05P5SUAOYirbRHjc1Mf27K9Xi/FWrEEJYeqXNLObNjzjZqITS9cX1XxSri+iK2ufTp2XEnKIBvWPhONN9xumSL4MP2CklQEm7O+BVtFQJfosGp7GsW1W6U0iTpuhr7ICRArHE9DVLMAY56Im43bYPJHOsiFovXoi7tTyhgdRFIpQAC8KbhtFZT7Hxq5sq+DGDe8Jr06DoUyCZqGakrv65APoEIBo62h/MujtfZxqFFRDk1gd/TsM36qLPAzGcb0NXKDdbxldJctr2lC43fk4l6X3YLOnEpRlUyXUNBRaVK/fk4YvkPFABG0zGqVuuwhPbp6seCn5raEuQPUX5WFkzONkWAmcMbwvvrn4GXzsF2dU+bIvSNGQO8YkTUaN0eSCQw3qmgE0sL5fRxv8xbzXcakxFGhfMeC1kspn4gRwR+RfrsvvnwBtpYcg4mU+vSXSxSh5e14EHJMVxyC2jYLHpRHWd/x0AHuUWsDgm562eGFBoWY+JJEXIYaMwgkzxxiUR+EAX8NauoW8OIznEnwVwxcZXov8KmmXWvBGsnpCbH/xq33oHS8xD06H5Mau1CYB/3fM3rwS2MyE7hmXSSO0bj4G0Vqzz5dAgIMAsmQd+qJ7wlfx1L/rIR19+m941AOeGkiprcZVq116bAc0yJRc0N2XHCTZ/R9w20/DOkj0x3NKYkHRYBh/m9Lkds1PTFYCRVB8pzBA9BP4k+HcNFE9CE7FumXdoVKiwO1uuDhVFzD6DSXYbzNqnePpbH/bLbpKT23sTSg6/btSon/XyhTp8U4DffiPDi9ygMk7w3P9sAoJtYUysdsq1UwWZp72lSVUzKqG2aCf3RQht9lPe0nsb4Z/muD0cbXNZukWL
 LuHMmcS/
 J6uUrdm4i+o9tKqZ/Qo4/SRvxGV0R6SIkyCl60w9fSIxBQnvDYVCHDlyWIvgwJ80Y+1mU9rheotWk4B1m+3YBTeX37+7nO/kX+WltcESjn9KJ49NLboEEvqtlOfcbgfC8iXuUjwECONRoNKCs3oZKDRBB9Qxn0KGI0FmahvPfKSYRdAnMRRkNmfxJ1gchZye1XWe1+EXNapAWOs05p6EP+EERZAOMnr2jkmy2SePHxKTZawTAvyeqRWpQPGMsEtHjA3D0ZkX1H65dKRu6259XZ27GBlUgzTftGEjvok154SS/XsCPmjn0ZGxwVbQGs+wd6Xk4ylDMSwziYlGxCnLLwDBjq2slkLvq64FU7fT9+kLozm3hmz1e6/PBiiSKo6CcTpNg4/tB2ac0ceO0mvaReM1JId7+4nnIWGwxFUk9Kk5MKKzHlCH0KWZPoc2+viFeoeCj6F8TizJHd2UfEKIGzpgQcUJVmWP8HuAC7SeUWiWxPYlkJbjUfQh7RQDmyUD+3hH5oGZbT9tUEaIpXudkomKKZlRZapNrJR3B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 8:12=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> The only real change we are looking for is
> that once zswap no longer automatically takes
> up real swap space, the zswap use is no longer
> counted under memory.swap.max
>
> Only the data written out from zswap to
> physical swap would count toward memory.swap.max.

Johannes has a nice write up in this email thread that talks about the
two usage cases:
https://lore.kernel.org/all/araWKyJ5MENBwXCL@cmpxchg.org/

I think what you describe is the usage 2)

I think we need to respect both usage cases. 1) is the established
one, which I'm more familar. Currently, zswap charges to memory.swap.
It is the status quo. Breaking this requires figuring out an
alternative and implementing it in phases.

I recall some proposal has been raise, give the usage case 2) a
different set of counters and limits. e.g. memory.pswap.max. I also
recall there were voices against it, arguing it was too complicated
etc. I haven't fully understood all the details. It would be better if
we don't have to break usage case 1) at all.

Chris

>
> That way both of the fixed size resources are
> counted according to their own limits:
> - memory.swap.max limits physical swap use
> - memory.max limits anon + file + slab + zswap
>
> --
> All Rights Reversed.

