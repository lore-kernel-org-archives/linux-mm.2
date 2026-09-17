Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720FBC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 10:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644A46B008C; Thu, 17 Sep 2026 06:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F5876B0093; Thu, 17 Sep 2026 06:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E55A6B0098; Thu, 17 Sep 2026 06:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23CE06B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:15:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A711CC02AF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:15:52 +0000 (UTC)
X-FDA: 85222848144.09.D1EF994
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf03.hostedemail.com (Postfix) with ESMTP id 999E620002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:15:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=cmmcxxUC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Q 8FPGS+";
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789640150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63zrAy46gSsb3p8yj1mhK5xaAA+erR8iZLYTbk/Bg7g=;
	b=MIpvGjmYtxcBSZetCVaRAe2xxP8yUN4e1+b2O+ut+I7WPWhozcvMWQNwX350DdY3Gy4l/Q
	u5NU8wE+lxbThuNOZvNu2cVbHQGFSAv4+nlZMg3p5dirBqfZRCN/qGaFUID6rOkWI5Ajde
	Jh+riaua5LopcYV0bC0z7/RSx4hxLdc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789640150;
	b=8ojFuLCLHUk0d1311JgloamhKwNeebbk456nnDD1UnCU3lAdYhlAWh6ez+VsgXsUjm52lO
	+G1Z+TgM9Qvzeh/mi6hGfugvn8Lsn1wlDvLxmQ2+WVsCNcdV+SzqkLPCl5+xG7d9L064gY
	ogpfgH6a92KVTcg27SkWnVl6q2bTEZY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=cmmcxxUC;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Q 8FPGS+";
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 75DFAEC016F;
	Thu, 17 Sep 2026 06:15:48 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 17 Sep 2026 06:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789640147;
	 x=1789726547; bh=63zrAy46gSsb3p8yj1mhK5xaAA+erR8iZLYTbk/Bg7g=; b=
	cmmcxxUC4Yi8AtHYQy91rc8pGq6Xpn4y7Yp26rffQNYtBaHR6QAFPWSfLW/Ivfb3
	6LWSteiLaz3xcojERQcbjvCmtQVLAPKBuwJW2VciWjTnACI4gQzZ1/O7W5f2sTda
	K/+abxzeWBdw5WMTd97MC4QfA+CUdSVUWYS4ql6ClDTDBF3xjdcOgY2J02Sdfwqw
	JFcNSeP9KyNPHMy4eMBmu2LLLyRD2BGNanGT5tBWfKTAKhHVsZ1/YluxzBbZDowO
	rrIrJw7XBGU4fN5R7Dpe10KzUBd6ife0h69ksaA5tGxt1n2rmRv9rFDnwSBK9K6S
	PJX0bvP+iVUE0x8cwTGyXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789640147; x=
	1789726547; bh=63zrAy46gSsb3p8yj1mhK5xaAA+erR8iZLYTbk/Bg7g=; b=Q
	8FPGS+HRS1XIEdvfZ0cy9o50f7DsczXNCvv+ICNQX1R02obIkacTU/NuUtA3FAgb
	jJgLTi1+1DGL42eoJA1PTf3MDIn4uiZQtLNJ/eieN3CW3dNuSQsWq+BgU9ZY3TZU
	H/m7tZIiDiVnHrxxF7H3eHfe2xlv2F3L7O1jbnawl0CV9vY9t+KYVwvHGYXePMOX
	PZOPYLy9xYhh/C5RHyTgr6ktBVJPWubyIurApnWt4aHac3OfgnTQB65GoybkHSdm
	HyjsH/AiKxjNubkKOij0hvdpVd/dZoautdrlVd+zZOq8r3ibKb9bbu9BhtWR7pCV
	i+EYyRd0Msg2OAIJ5trhQ==
X-ME-Sender: <xms:zL2rau8fojYY1T7ifVW8MYSwQJGUi5wdVbPFkcvf9kS5aOiirAO7Ew>
    <xme:zL2rapgmm3mHHb5y3DZgcOhualtkMgt2pR4JyldCVLDl3bebCBXStWH0yp1DKzi8N
    -F_w0cCjc04GWLh9-tTRyp0CV6IXnjEzjxqwbjq5MIiwYdeH5WSz2w>
X-ME-Proxy-Cause: dmFkZTGObiLov0ZhD65vCMEDs7FyeO+N6gOc227aZ2EcrWzGLk1cuphQJxG6jEp+lPjKa8
    dTdXUGAKPunOpPiE/cTsQtkTFTW7xc9M+3DHGqvYZkk8VUwTrXJ9n400/RbHDBkmYPUAPS
    hNq0mR03tMRt3tMGmmdAn2WVC6m8+G/vEOzoMK6dwHdpQO/5F1OBLh1sjweUYPmCh2ELL7
    B9F4gGnChXUf0SadPnzjhGR9l8+TJVxJwQwRoeYRsU57cdyC7Sa8p2t1CgG2+E/O7RlThr
    fBboBI98bf2eB4h3KhE+Hhb+D2fTyYa2bhswd2XaFShan9En180bV3glzF9myTMzGgpBmD
    vc31QPMpol3Sm6ZVgUy8nzj/n30k9T7AeTKdQuar5/6BYWyfLWmVbtYTuoBHBgDFSGqzjW
    o3SrbCeDRQ76JQ+kKfALY6W9ggzHGssCBafTz3YLPhAMZwB4S4CX79LR13sSk3702n043Q
    LZWatXQ58f6FFIZIJmso5mpi5qdfMbobFukWp0o/Q7PzOpRDDY0ZFwdDqra4QpyqVcPUo4
    j+Oi6OnqikXwUxQQ/Bge00wrpu4p+HVXs3dQkgH5E3XbOMx9XCaQ8Rx+HcMHqicGrkAi3r
    j39SGU/OhSpfiU076jcDU1SgRaHiSLYKGzR4AMPkYalflphI7KJX5sWIva/w
X-ME-Proxy: <xmx:z72ral1a3RUM5nYAjM03H8uzFlvvRc9InpOucU09R-fKDSkRVXYQog>
    <xmx:z72ramzg0ET3x2TBkBsJjAb4zRQbfXYUIcMw1Uk7KSsazpMzgBG2Vw>
    <xmx:z72rashI4I64YgMFKEShgvbjjop6axEMGsyqMdoeht8Vb1IH_O-D7w>
    <xmx:z72ratxIa3zN7AKNzH4GgwK7DabzDbSXJQlcxN6AsFW1SZpSaapWCQ>
    <xmx:072rasUZzw3xiVye1Gv2_hKwH9obB2pTZJyF01cUIWJ7zoF6_LbwYr5r>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C695632A0084; Thu, 17 Sep 2026 06:15:40 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ACGBcqtoOIMw
Date: Thu, 17 Sep 2026 12:15:00 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Kairui Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "Baoquan He" <baoquan.he@linux.dev>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Ridong Chen" <chenridong@xiaomi.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <d832c2d1-d691-4583-852a-f05d4335e9ce@app.fastmail.com>
In-Reply-To: <20260916230330.f0923cdb679de0b39d1c5d3a@linux-foundation.org>
References: <20260916083456.4136132-1-arnd@kernel.org>
 <20260916162816.39f0f33f6a48d30a71be3575@linux-foundation.org>
 <20260916163044.3daa3811d9b2bf7d958f1f27@linux-foundation.org>
 <75939625-482c-464f-83fb-fa12d3e1d79c@app.fastmail.com>
 <20260916230330.f0923cdb679de0b39d1c5d3a@linux-foundation.org>
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning, again
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uejsenpf9bamuu4e53efy56ekdguuarc
X-Rspam-User: 
X-Rspamd-Queue-Id: 999E620002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789640150-728314
X-HE-Meta: U2FsdGVkX18DEc1a5Uo0QH03cfMkbiNobf45GMc69zGBEIa4YN0kZYzc5fsaSF34JCyBBcc7NbUR/KVwZn9olb68DtO7u8/xvQjyDI/b46MR2Wsz/ZXvF/2UUGnlIGyP/ZuJQRzCGkcSv9WEmjae4o3qGMjLpOw0ZSxC0w8ijkcacWmUPCEM4N0KwwyFPunLza3eisNajHgxxH/rCvHNdhu4+yABf43J+tRwU1JYsRPc/mKtDBLD1wAYQQDAMLpLs6k0vm7ry0CA4++qijCq8E1jzW92/jyFy3ZfBAbonHz8WEJ7/b8d+bTO9a3lh7EdK9cWYXSpb4YFzqNTnmqcGjHiyB0urIMgflQAHyjsTx48i/dfIH713FmhXdW2QL9ltKR7+a+RkZpox5xV40E/GSa8UJfekA+cg7Zr3GLh7xdDq//6/U6T8mpPjApmt1go2bDcAbsKfQLcF4GwYrsnbPnLy90t1JH5iGbFFzoIUpAfGOSGe1Yu86M9+YuQLsxMJe3tHtSkXvwTMBmaO+p26Uw3WERp5u+tmvR3Me5J1HVyw7L7dslVcB9RB5HZJeXhkmfmutBzSiPvbJpe/U27FPc5jyZeM3iLXZF2qWDvTaw+LALGzEfU8s4XOr96WWt9DnCxDGoiCpcgXKT6Wn6BJkKuo8Z0HRq0v9m/5AEFDyNYs81kX3U1seTCOP90iyxGPkPIYzT7jMeHw/d9J3M0QYZJ4YPZDofYDVBO59+k+p43URaFr37qZJPvTq+/wfzV7zT1MZ8MU6/lNmBPGWbhlpVqpqCUSLiYi0Uzs4lzlcPTvGs+PtCP5ekipvhAZvO8JYFrM7a/OBCsEpZysM9Bpxg2/14MEbLNv0KksLUItdP6sn9TJFJmuU81jnvp9gcMjrRgf6Oi92FJ5NAse4uT8aYu5C+yYFOhUFxTJVIq/v98l4/zevmqs8uRHE4uKv9XjlRcvaY5tQB6vppRo9Y
 dKKoMSpa
 611ac552Rqs2M53ps4MRUvv+xYMRoTgJOqX91b4dP/kdxGgZcCjtThEqvuEr+3xcydlsD+0wUBDXPMbGT6CdyDHHpZTOGv58w4e0PbpTN8ehqGB9z+3DWrP06xjZpkBTbEvF2U7nGjQn/DiI2sv51AKRXDEET0PmUjCL8wzcauxlM5Dh4AYaE737fu+w/Y+3DOkHObILEvNLKxyUkIXZPQiissBPtgbkEFBWB/0bvmhnykWpbkfwoq2IYFB+IJzp9bG0nzaua7hxPn3eEeVfoQ7EwQMA1EJhnv34sR1G0ypSXLBC3dM5mzcn10A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026, at 08:03, Andrew Morton wrote:
> On Thu, 17 Sep 2026 07:50:43 +0200 "Arnd Bergmann" <arnd@arndb.de> wrote:
>> On Thu, Sep 17, 2026, at 01:30, Andrew Morton wrote:
>> What I found now is that the __noipa is only needed on top of 
>> "mm/mglru: use explicit tier range in read_ctrl_pos()", which was
>> in next-20260915 but disappeared in next-20260916. This patch
>> also removed the min().
>
> So we don't need cc:stable?

Correct

>> I think the reason why __noipa causes the warning about min() is
>> that it prevents the constant propagation into read_ctrl_pos() and
>> in turn the hack that suppresses warning about mixed types in
>> minmax.h when both sides are constant.
>> 
>> Is the mglru series currently expected to make it into 7.4?
>
> Yes, "mm/mglru: use explicit tier range in read_ctrl_pos()" is in
> mm-unstable at present.
>
>> If not, I would withdraw my __noipa and hope that the next
>> round of changes to read_ctrl_pos() does not run into this
>> problem again.
>
> OK, I'll drop "mm/vmscan.c: fix min() signedness mismatch" and shall
> rely on "mm/mglru: use explicit tier range in read_ctrl_pos()" to fix
> the min() thing.

Ok

> And I'll stage "mm/vmscan: avoid false-positive -Wuninitialized
> warning, again".  ahead of "mm/mglru: use explicit tier range in
> read_ctrl_pos()" to fix the build glitch wihout a bisection hole.
>
> Does that sound sane?

I think the "mm/mglru: use explicit tier range in read_ctrl_pos()"
patch should come first because the -Wuninitialized warning only
happens in some randconfig builds with that, while the  "mm/vmscan:
avoid false-positive -Wuninitialized warning, again" patch on
its own would always warn about the min().

Somehow I fear this is not the last we've heard of this bug, and
I wonder reworking read_ctrl_pos() would be better. I tried that
in my original suggestion before adding the initialization, but
that had other problems:
https://lore.kernel.org/all/20260213123902.3466040-1-arnd@kernel.org/

I have checked the latest gcc-17 snapshot and see that this still
produces the warning.

I also managed to create a reduced test case, see
https://godbolt.org/z/xofecssz4 but this still doesn't make sense
to me. I do see that gcc creates a both an out-of-line version
of read_ctrl_pos() and also inlines it. Marking it either
__always_inline or noinline avoids the warning.

      Arnd

