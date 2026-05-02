Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D8ACD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 09:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7D76B0005; Sat,  2 May 2026 05:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF626B008A; Sat,  2 May 2026 05:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBB76B008C; Sat,  2 May 2026 05:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4326B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 05:13:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D3718C075
	for <linux-mm@kvack.org>; Sat,  2 May 2026 08:57:02 +0000 (UTC)
X-FDA: 84721875084.13.5098692
Received: from r3-20.sinamail.sina.com.cn (r3-20.sinamail.sina.com.cn [202.108.3.20])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42CF8140009
	for <linux-mm@kvack.org>; Sat,  2 May 2026 08:56:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=m+98vdha;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf26.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777712220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bg4nKl/A3P/H5ScoR7kQWUqva8N+zh6ipM/9Qf8Rkws=;
	b=udUpnnnpoUKnAy6CCD+Jje9Rl/mx1b1LFLh0nJZQIh99IlgJHeH9eJeFsuv1FzbIbJx47J
	JXoafmGvTPYFGhDqroqBxZeC+sjtKAtb2ZGP1CInZBLXDK5CvgAp4R2C09I866/Prr74KV
	oXKMTKF0zBn2Qhldr7kscBy7Qp9dCt0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777712220; a=rsa-sha256;
	cv=none;
	b=xSmykL9gICUFmg1p/te+BiH8NcpXKgONuVzLgrb9Bmxi0mG3hvrPO7qXqhDgMGFbODArkS
	5nEjJSSgejQqmtj3P3VutTFUQBjoAWH6siiZz10I4zRN7f9MK0cQDGZUFlyMUqI407Aghi
	jqJoxz35ubicsQZxysYdhw5TfD4ifGs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=m+98vdha;
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf26.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1777712219;
	bh=Bg4nKl/A3P/H5ScoR7kQWUqva8N+zh6ipM/9Qf8Rkws=;
	h=From:Subject:Date:Message-ID;
	b=m+98vdhaMz7btrIQX7Iygjo+JGCFVe8t84rTejVRnZkNLNuLQXOCAtsCaNnMm7kNf
	 FnSKsoWbRETIEmwwRAQM1TWWNr203vmghzX92Z7Pq+pGlJVKwayGZ0T8ml77ukmZC5
	 9OqwPSPlDHFjVn8MX8XtwMnpUEYgtA6/8M01W9yM=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 69F5BC53000052B9; Sat, 2 May 2026 16:56:54 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 3225394456816
X-SMAIL-UIID: 2C331D982AC549338A70345D4C4608C4-20260502-165654-1
From: Hillf Danton <hdanton@sina.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kairui Song <ryncsn@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Date: Sat,  2 May 2026 16:56:39 +0800
Message-ID: <20260502085645.262-1-hdanton@sina.com>
In-Reply-To: <aaBsrrmV25FTIkVX@casper.infradead.org>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42CF8140009
X-Stat-Signature: ixmg63rhgxb5yh4nho13mcak9decqqrc
X-Rspam-User: 
X-HE-Tag: 1777712218-314727
X-HE-Meta: U2FsdGVkX19oi3Tl+mSBbMZSnSSg+8QQvp7DjaVmsVzadhECAJ25L0AvXBu1GEj0R2YRMGNwD/tY+xi0MKKiAIwK0svzA1cs7uawBVztWg2blbWlxXsv7Jw6pJFRpXH8fa20dR6xb6ZY7CeEiLM/T6ONbj7A4XOgVkvxV/8fAfDtr8gB6icDMi/GWw44laT0wfcDykkMTWD/NNBYl0B2GE/0dBwAAknP4KGyTPCz6R5OU8HyjrOPVqM7XBEeU9rUdedCYww76PymBsuOAmMfdT42qd0kNuGQU9LHhOspq0UQazxUiA0KOwcIHoTBoqvz8d/MH23D1FOUKx75AGeFdYya3P/O6V2yftSsI5R9x2KoZ80oNmEmX6+BrLu9pXwdyhxEND1BZgiac4VxAgp71qz+UoaJXT+rYo/hlsj/tNAxiawhP/43usP/APKd+/P9rqVrPDsXDURK4kB3Gfh5xh8Yu35ms8fTGcoda/TqtJTLki8PAx+eCU8dezytY6doMCY3h730zm0yWRwLzDil+TXbm+aaAMhoQohOaYslMCNAK+u68X8BhJeMpk1AxFR1x+m3SDcQ4xWAmrT6ury5kC+Bu1bEsqSn/ddTQeY84SKuw4n8M1oGFHduFCXTEf9Bv8F/qHJ+GFzMujNTpP3tbXgyYPeKHUbrZNxtwCpDg76kMHdqTA0oScz1i57P67fK/bWCc5Jw80XP1DDiU02Mc4BHgJeu+f7gx3CcdeRzSC7PAFvwBCqRedFnO8jNw2h8YInbXdrAnLjWJPaejzdUwsKrAtazCpaY0FNH9z3mHXW733dsq5o2NmlyyIWd1a2KC4CLLZvHF9R+y4/NMF4/kkkraVMGPuRQiOgiDMetWpMWPVB1wVo8U3bJuqJYUBmwxWGC3hVMEMuR5oRwAttyBMpxPCYe//CqxL/2dqZT3Gi9GKetv6PEZhK50oFCpzkBbBC8Lx8Mhu+HAx4Yvvf
 BWIoKGnT
 DHwsnTAoaRmuT81HtaxC6sF9ird0jYqzTyQAf1KsD1AJIGlBBvD+zu0wNzixAaO1wyAPmHzziXwTNzuUZipFaEiDgc5odaoLQq3DgTPyvqzs5qeT+poNDDXJO7WKC4pF+LQyTW69jbHA9twkrTg0qJUVnNb+AUNYlgz4eEPwj+Dqmako+zFchylZ84yU3EHaj8cbyzACubeUQpPkzda/JCP8P6Wwpzj+RpSB8tbg7lNEhaTOLwMAbhykzXcf9vwUtBAgGxWx+tK2OA0PMK+ePUpdERcHhL8c6Xh+SvY32n7Hzci4b7EackQe2vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 15:54:22 +0000 Matthew Wilcox wrote:
> On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> > MGLRU has been introduced in the mainline for years, but we still have two LRUs
> > today. There are many reasons MGLRU is still not the only LRU implementation in
> > the kernel.
> 
> To my mind, the biggest problem with MGLRU is that Google dumped it on us
> and ran away.  Commit 44958000bada claimed that it was now maintained and
> added three people as maintainers.  In the six months since that commit,
> none of those three people have any commits in mm/!  This is a shameful
> state of affairs.
> 
> I say rip it out.
> 
I suspect you are kidding again. Go and cut it off then we know how sharp
you are.

