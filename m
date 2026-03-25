Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB362109C058
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70DD6B0005; Wed, 25 Mar 2026 14:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48526B0089; Wed, 25 Mar 2026 14:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C852E6B008A; Wed, 25 Mar 2026 14:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7F976B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:36:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E7708C9C2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:36:54 +0000 (UTC)
X-FDA: 84585441948.13.286889B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A91EE40011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:36:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O8FVjyTQ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774463812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41nNK2gQXsUphrcfvyGM3BOJitxQANW59gRbaHOkMZo=;
	b=VXFgftCyb23JZmsYxHLK8euM8CSZbdIqmWIxDORuaLzdGwi2v/Taa2mQpzjwnjq2bI6xqv
	UlpObsa5F/q6Jfjqze6xccuwl4o8OG8ugfXk/s620FqTF2Q90kfRrDRmsKlApQNfz3c5H0
	oYFSsDeJbaCjNEhS/wTWCSH+7bWMmh4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O8FVjyTQ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774463812; a=rsa-sha256;
	cv=none;
	b=clKekxV1rBNyY/KWMzpnz3mJOCCyP1zCXbV7/ojuWs5N5gP+cuh8XWQyioDDQiG94Q8Deh
	q0bDOJGU0hmTydUdAw/kn7bgzzrmE1TQwmTkz/ILN5jefap+Vkiu/1VzBvj/z0Zh4ZIhXM
	RCQSGa5hwN15sVns/tUQI1rJBLTM8NQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0555D60053;
	Wed, 25 Mar 2026 18:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48555C2BCB4;
	Wed, 25 Mar 2026 18:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774463811;
	bh=Jxayhcb//oD4+znitc73BQEL/cUnyQ8hHgrsXT22Mm0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=O8FVjyTQ6c/QqX7Gs2olBJyhvNq0/8M5h5C1H2GVUgbJGDIrefJUeDUg1McWkBeHQ
	 S0s7SpnQYljIx6QAdAGMTaDYs4aNgCRa+WmL7WDSUGwYAxMCzZd79TRcjD6M2NYahM
	 Jn/PaW1P48aP2hKx/zQLWIu1i2aajKLonNCm/ehA=
Date: Wed, 25 Mar 2026 11:36:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Vernon Yang
 <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress
 number
Message-Id: <20260325113650.fc6997e07a0a4ad0e46278d5@linux-foundation.org>
In-Reply-To: <06c83e1b-d7ee-48d5-a5c4-faad39db2f53@lucifer.local>
References: <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
	<hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
	<8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
	<CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
	<22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
	<20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
	<3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
	<8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
	<0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
	<20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
	<06c83e1b-d7ee-48d5-a5c4-faad39db2f53@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A91EE40011
X-Stat-Signature: ex61dibbnbsi9nk98owubxwb1jnnefwe
X-Rspamd-Server: rspam06
X-HE-Tag: 1774463812-688653
X-HE-Meta: U2FsdGVkX1/34ZxRL21kcdI2GLPZ1RSDbHusorOHCSfTDJd6Et23E2q8kQZ+xkM0SNFvsHHs875eYc5J9GcEu5++6unauTI6qWb34cEvXf0bD7/QCPsjyEn/b1C2KSqSIN870HydqVGAyb2qsz4SStiDtNOTaOTWqn3IUeaifV4q+IHUqIz/AaUbTVNxPqgv+JQ9BAMs1PK2JNosS31AF7qJCZquBR4gdnu5zBrEsgDC8sCTImW/xElZBy12JqCMkiWWUi18AvBqEsyQq2tzaNTWxp/E3ew5nJ5KnLnz1YZ88aQMPWzsDy/lUNrJpQ7YzR0Ue0K87+tBLC2tepSWfiiAzkRx2qhX4POopXr8jCuHqWlgI+HR2YYGctp8bSXJDUUPF/YZg/jWijv3AaBlewIb0PblhZGKYBxoms1h1HBAyBlqumHYIAF/D3QAKPFRweufBZPTJNzsMZBT7iBV4nkAgGfgm38EVmL7r2ev8vj3TobzzWTXrpmEu5FoE5d4sX9PECOiwD55uB4k/r5rTrXIDV7+26D7hN0RlBDjvpX8S2G9rvkkbjl1UpT1dTUpiyMq1oFHpke5YsAdAe3cs+cHi6ogXI/Um8rnefvCBlfWsKeWqWXIQeDcBIu2vMqJl8UONkS8RaiSVdUr5TyBJLO8KWnJVQGc9nXnkVVfNolOE7a/T2Tpq0rIjER4XKwriFLMRFd1elX3F8G1mNr+LD74bRNbBi8WT5ozc5k89NxdbKDRtmc9IC4iR2pwlJ1f4iDdySRYlOtK06TwXmpeJFTW8NvTM9uh15hH+aF2hrx7gXB6VfZeQnPqfyg1zRibSo7xv5cc5hlGtR0nHIIpoRZo/KL0/p2BZEGLkfdwsEIQGluKfLStsGWyIIV6tTdpYIqtRakyRVHJKKatS53O5mIJjZarwagJMZpZmBQLEbwf9RRIAwrMIPrpQ7jcTudIdtRaHYC7AaNZYBjK1dE
 QXLbfWAN
 oaTbnihT0cF/xLx131Hby31FbEvmzY6dPzqRf5QbLrLSdFxj8/osSwJbJM/DnJBSX7x2jf6OZN1oWOUmp+boEeDMqmWv0UhUcvdbwv2RUSID3eJC8sxmeOZhoNmqeXqcOYbUTKzkI4jgtSSl7I7lIOwlVFGBvX6yy7z/W2h03ohv0G1GxmlRzlrf7BuXkYv+9XPANLT+XqL0CBIQDKlPM+n4vYxgOKT8Y0k7CQhrVnAwJ0VJK7Vw7xGpzAsaO8cn6XI84iS5LKWzo9PQyv2NN7Errw2vWUu6uK8rp5h1OyekNrqyJDFaiUTwuhmiIlWjfwbGq3hkf4Jl5eKEH/BETRf6/WJ5sGEqhnf9yN7SDx3HIUg+Bc/Zg/dS5QkNxmPEYgNAa3w+xt3W8108lTalmJVqjB3MwOH2szy4LZGieBDG/zlohSQ05tleuCj5CHRQzgVtJ0Tu3OEsM4vtKA5MFs16VMCiZu9qDNP6Q++IByrrY/gPIdoqear70U5+yGpdT46EX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 16:26:12 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> > hm OK, so what to do.  We're OK with teeny -fixes but anything more
> > substantial we ask for a full resend and I do the heres-what-changed
> > reply?
> >
> 
> Yeah that works for me.
> 
> > I presently don't fold the -fixes until the very last moment.  Could do
> > that much earlier if it helps anything?  Possibly useful to people who
> > are looking at the series in the mm.git tree.
> 
> It'd generally be easier imo to have those changes folded, but with something
> added to the commit message to indicate this so I can know whether or not that
> was folded in.

I always add a [footer] when folding -fixes, eg:

[sj@kernel.org: verify found biggest system ram]
  Link: https://lkml.kernel.org/r/20260317144725.88524-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260311052927.93921-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>

So one can simply chase the link.


An unfortunate exception is when the -fix is from myself - I don't take
the patch from a mailing list so I have no Link: to include, eg

[akpm@linux-foundation.org: fix spello, add comment]
Link: https://lkml.kernel.org/r/20260220151500.13585-1-rioo.tsukatsukii@gmail.com
Signed-off-by: Rio <rioo.tsukatsukii@gmail.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

But these things are usually quite minor and the precipitating
discussion can be found by reading the main Link:.

> Maybe just directly squash the commits?

Not understanding this proposal?

