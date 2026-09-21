Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB680C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 00:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABAE6B00DD; Sun, 20 Sep 2026 20:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C8B6B00DF; Sun, 20 Sep 2026 20:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D086B00E1; Sun, 20 Sep 2026 20:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 334C06B00DD
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:18:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9442F160524
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:18:54 +0000 (UTC)
X-FDA: 85235858988.11.74F3A53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id A6C0520005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:18:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIEj4iaB;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789949932;
	b=yLrFOtxzca1SBdJRY1F+trtsS9J37yW/GNBdD7bFxrgSQSg14gerw2mTtCg5eJeMLsR4hb
	+0x6XYs85oyfsyhb5/hVKBji9A5DTbSFjvyggpbnI6NYrz047Oiw/zNts9ilnmxXDNI7Ul
	We8k/5w8An1RT7en2PRiLLoND58goiI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIEj4iaB;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789949932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQLJwaBM1jNrWhBXChoiLFbCA/v9mJP+hXZ5bDTH3cA=;
	b=T2e/yg4msWIsfAeiAttTG9nXgZ+vlsnMDJXHW1dLkuuxk6dzLnGJKE2CwnkK3berf6Nhpi
	0/Zj9ZPwES9HBmO3YeBu9BfDFEBxD0aZJRVgNYkJ5lfa4squJASVb0hFSwRK//LMJaSyAe
	Cqn9MpRXvz9EZ2E2TG0dVOCkyqYevvE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9FB2449F5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B5C1F00906
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789949931;
	bh=yQLJwaBM1jNrWhBXChoiLFbCA/v9mJP+hXZ5bDTH3cA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aIEj4iaBhshktxUJ9NxtHfVL6ULOcPlzBZ+8JZnTwJNm0vxSPb3Tj+kbQCbxteszO
	 QAnXO6g4HbazET/Ga/0jEGHY9wLEdkEp2XLCw3GjOLtXoEGXsxT86NukCsaUn7g99h
	 DWgqIj8LdB52MhSQlPEBJXOU4SgzIBGzg0YppLv5Gzo9RN9HlDiBuLIi4xSPRJv5xz
	 nf9PHnhgqW1fR7L23E/E9OfCSv6kFY/JokoUj7nuOkoe6YVnyLhe6uYdrJm36h6x81
	 WcH9mHLOp6DpEwMeTAWYCV1RzL0rd7TjVt/se2qLf/3gpxRAaNDat6YlTSk7udgvBX
	 haoUyoBJIR/vw==
Received: by mail-yx2-f16.google.com with SMTP id 956f58d0204a3-66e56a1fe83so2010865d50.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:18:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBylzsMafPT/Rg54Ow+8dYFVzG8M6IfarISLdwZWGtaph0ocVkD0c+X8TxyZM5E/UanCwX3f24Q/Eg==@kvack.org
X-Gm-Message-State: AFuF++kVHw6rPLMjnejpBxonjt+H6ERr7Aa8VfG8wWl19ThCx6SOyeOC
	nJLn0cZHsQKCQ+KOQG6szcjV+acugEJdQ57EAaAFkpIMq49w0GRC4OLcU/BsdKXwfoaXggisROt
	+6XeUg45g+S4JNqyPyRYf+tBvGe9IALcap8zi4BOP+w==
X-Received: by 2002:a05:690e:144e:b0:672:b10e:c5e8 with SMTP id
 956f58d0204a3-672b11e0a0dmr330726d50.28.1789949930653; Sun, 20 Sep 2026
 17:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
 <aqU81l1oqGItb-0C@cmpxchg.org> <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
 <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
In-Reply-To: <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 14:18:37 -1000
X-Gmail-Original-Message-ID: <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com>
X-Gm-Features: AcwNN1V4Qm3_GmZRa8eeaDfHd6BdloTCfV1sTma9X2uAKhaJOLZlQ8rz9IjN_3c
Message-ID: <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6C0520005
X-Stat-Signature: aktk5n194jusoutnkhk3ppcq5mffbp96
X-HE-Tag: 1789949932-473753
X-HE-Meta: U2FsdGVkX19BhCaC88g0Zu3bHdMHrWgT+KiT/oeWloglbWw83BFwVh0ZfGtygflcZGN/ZSnzoA5PMB7qoz7TwGlbQtA+DwsvWYbh2fM0hOxR9BcTPbwxJj8wdQqqk46gqSPLQzfGW/iWNsP9gBRBHo9LR5hnwgtlApVOR65Wix7ckSsUvJetEz4+4R5ldxumcVcljqju4szzqcohu8omb+2iCXcTqdA8BN1Bg4BLLxNTdBiCdIUTEwWXl9OLnLZGwL5VA7k8deTy+xqtfUCZFi4KqsrAZGg1vfxldDtz/Y4e1TtOkgTBDD8m5YIonpPjBw2JM8v3puNtOSqQVUW1cZh6LTi7GEHon7stnU0qqaWyyit55uVaE/95qnjB1ymOS4f6WVmj76oCWXfTYM7GrU1fLJyQKceMt6sUsUbPXGk3iXmrYsfg3MrkzKFBxILDi/aYndK3kFx5lUpnNx+pw3nL8X9QcTUBFqMn2cPr3YZLNnBYHpul9xkVW9MWDnMWksf7SpUPLVYPyOFb2nf2E25jHPdMhcdF6cEu+QVLXFm5EMag+3bMEhJrBOHAPbYo6hajolqhpgL4mmtIfIPK83O3DaEzfbdS0jQujEVKQbtCZ4ouItJeTkDv3Q/4V8mvrgTo6IubFM9MSFrzRDXoyboF8aumusVvzZ0v9j68Zk0sbM0MOPctdlWCRFyBS7HG2DcPDZo6uYyGJKiKssjLiQG1HfVIZqdklz+FrdeXhTYx5qXsLQc7Rw4eBtrACpWTMpUb3gNotOGUKwruM0bmRjvmH0Z0rO08cKVUbtSjPGX7Xfwm5vfSxeKKg16Sv9TuN2C5C68wj6+1b/ODsI6duREtusAoNp54F4cDqSgsFyC7IAPjxNW1nvz+rYjA04Z6InADLUhUgD7B+vM5hshYE3om9ZyulSLbNChnvoT8HvDhgEkcBMzDyLZ0g4wxoQiDvDtRKHbEh6cDR6ffYAS
 +bqj38Tm
 DjFeZZiHwc1M3mCADF22qlDDFyehh+7zABjdBxC22knf9DTHbtCfePQSJDTpa+oC7MtSBZrfw7yT6ZPFImLUq2UT4NkCH8z4d1+bBCpd5S3zHxqP1760d1pEWg8ablIPUTiuixmJw3+O9r3BANBwJcQ8FAsh7PINLNmZZNqHPj8BtEyoHEEdwVhHomQmrFMWY/bfVvRXcIlLHfqFKXBYIPmIkHwyQibfk24Egc8e1iVG+WWpaW6r7x9Fb37dtO+3vSQi94awz2QEbyOhSW7MBEpDH9TZf1IC22wtdialfs4iYWZWdGdgR8uIe32CEMxaL5XoTEA9UBRvdwy3I4W9BeXcMvlNhx08MC2hfptp58GM3oAmk8ZrJsAlzJjtTXpmLcLCGkd5H75rBX8I/z8VDB3Cay2OwtgfS79zLj5+NNOK/UG9BwnQI3emycodtTCOaGxceomySf5KZlfyD8smZIN2MNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 3:07=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> >
> > For our deployment, we only compress about 7-10% of the system memory
> > before performance starts to suffer. The feedback loop will scale it
> > back. I am very curious do you have actual work load to swap out 100%
> > of the RAM.
>
> One common workload is a web browser with idle tabs.
>
> Those often compress pretty well, a ratio of 4:1 is
> not unheard of, which makes it easy to fill up
> 1/3 of memory with 133% of memory's worth of compressed
> memory.

You did not answer my question. You are talking about user-space
processes (browsers). Do you run your browser in the data center, or
is that a laptop workload?

Anyway, what is the total amount of memory swapped out to zswap
(before compression), and what is the ratio to the total memory? I
can't imagine your big server can reach 100% swap out to zswap while
maintaining a reasonable SLO. So educate me.

Chris

