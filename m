Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E6BBCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754856B0451; Mon,  1 Jun 2026 12:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704666B0453; Mon,  1 Jun 2026 12:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641916B0454; Mon,  1 Jun 2026 12:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 530766B0451
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:16:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE7241C0FF0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:16:07 +0000 (UTC)
X-FDA: 84831845574.05.D9B4AEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 59DCAA0011
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:16:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jtIF99yu;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klLNQk57exDbXR49S/i0hMmexp2/+GhTI8W+FFTNTQk=;
	b=S/mHBU0ngEHr9KAwHO9JCd0ZTt6FDypYc/XXXYM5SReRTHv4O0DqXBbtzKjlrfvjRoYMmG
	1IBF+rV4eHJ/vwgycKAzi/4/gavmoXWfkgLsT3e4fhh/xCTYHfcc5+4JKhRU59jnHEU3lA
	pWRPzIBIqGULvcsLbT/aBT6Hj1FwQCw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jtIF99yu;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780330566;
	b=LO0u+WuwOWk+gfaYXrTG7VXb2Djh5WzGBpMxEhj/RvsA9Dr4lxLx4mihLNfKihxhxt59ty
	5ZZzaBmlnquF87gHNJ6ZhnQA9Lx9zNByHZnIlIBifOv9RzW38CLt38l/ExnwqECJk46Mx8
	yPuanrA1gveIC4ZtZIPNiL6bbNcm354=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C06DC601E7;
	Mon,  1 Jun 2026 16:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DF91F00893;
	Mon,  1 Jun 2026 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780330565;
	bh=klLNQk57exDbXR49S/i0hMmexp2/+GhTI8W+FFTNTQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jtIF99yuAJp2t3Jul9D91kdBj5BR1YsqbTfn9826AwKdxeMfpoqRpg/+j058mg8h2
	 0ql9Ou18UJ9ZNGtptikM6OFNRBJipEAf3YW1cYtoaE0kQ00JxsEJmXjYaR2bXBzwPL
	 LkIBmeNjMpv99bMO6xzfpVr8CyNQmmSEM+OwF6mkXMWSAyNgzMqOKLuDMw5uP4FUSk
	 ocuWTc8eXOfe4r20egDLOwPRya0KLCXUaYBCJ5x+iDmbgXa4TZuXUPVdMoSoLow0xM
	 vS/GbpOI0jTXZcI8QYAfaYRayEUWt0RkjVTSISgNJruqBuLp2k5yxAXN91/Ac634SL
	 q17mwRRyX2vbA==
Date: Mon, 1 Jun 2026 17:16:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah2uDhs3a0bFcRNG@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <bd622950-62cf-4b57-b3ac-89635f28fa4f@kernel.org>
 <CAA1CXcD373fFfo9YPWRj8mJ_rsnzyCrpn1uk3=k7kU=QuaLOgg@mail.gmail.com>
 <a9f43ab4-e47d-4907-9620-32287e3e9b84@kernel.org>
 <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
 <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 59DCAA0011
X-Stat-Signature: uaauxps1nomb33ecxndj7ptii5gyoqo8
X-Rspam-User: 
X-HE-Tag: 1780330566-103473
X-HE-Meta: U2FsdGVkX19UZo2TD05ZACv/9voUeWojyLMAaHIaOvQnWwlx0TwS/Rusepv22NkaIrB7ShvKl2DRBfLL5Wt5S67n9uTyupKl8IMpG0fGKY2sGrCgQv8AgNSEO9Qm/wjW0K9cYO2bCdOZqsgh7RfTbfcOVqURp076gM1k0qNapKmN/r5rtW0gNHE+1ZMKw6qAjmBnGmZVNNV/MJeeITiKXffLRThaZ1T0PDhBfGfHoZULoLLAHd7arfpz5JaX3SlRdMzV9W8rz2/Fa96ZdxUEYeFyipGv5qvZ1qzN0OiVU2+W7cuDJ/9fK4IwcN0/piTj8Z537xwj5jmcF01VrOr1VWI5D1pEPmptibbCLzG3t+pVzPXyRVAtPZlwYtd/8eSg5OmxuuqMT+f1N2Hvjpz5eM/U45aJRg2BIovd4GtX9w59mb0FjvVYIqdJTuu6SCvmzTyKcAgU2qiLtN/aQS9hVblNdC3kWOM1SfCe4kjjx7Bu5vIPKTO6ZWFRb+mXo61DBE/bYhoXqlFwQsBbqqkF93NyB1po3TOkUo/fEL6rpVQGNqi8e6nARBEbGVgBtJzcs3OHM/mmlRRnbBfj2LBkIzawoxiknbBe39FEnyp0JLFKkSEL8fG7l6kFFOJGio2HbhXTzGSYdj0DalRIr0beOZoo0pUH1Qa5cMY6643jHiThMUJTai7JDBVF5HdJguUjDuprq4Si7cUnFbjUUx0s7B2DqS1W2i126WGzj7qp2D6vLPYttwL1vIzIg/BYMknJW/ykSz5z27reNOpJFD4edq0AS96WCyJ23l1P3eeODeRSvakRDBTB02sty+tJpo6aYi3HcWM4zN7Aqm72Zfc5o4xvPmYa5oVy+y7klg7+gd2lt4w7PgnNBTu0LVHj9YNfidxdXQYgw0NNCVfRynPGfIVbh+mxmM6wiSJ7nKCcFIDik0DAZ6aG3QMnCbdiS+elD2hLBokJFT6thVNYuRC
 RKAEf+ah
 x+GrTm7+0a9pPhm/keApckY/gk1WLRyzu1MPKrUoIO1d1LesFTJluSg8Vv2RHCK2knzEsFkJafJhwP/iT+NZyW+VD7TrfRVHC8XIaKm+a3wDKbjvmfACtQUixrvs51EkSgdVUlbWlT3wFTaVFiTgE3ruA22hrsAqSUWFqqyMCyIbb1lEWGbhDdhAX4mkfrz4MUaHirxxrLQqmTbl5T+E1cz9YAfvBz+ipxnsqYMfw7APFokllm+K4oNatE1tFbpo/dV5B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 05:45:30PM +0200, David Hildenbrand (Arm) wrote:
> On 6/1/26 17:41, Lorenzo Stoakes wrote:
> > On Sun, May 31, 2026 at 09:49:02PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>>
> >>> This I'm not so sure how it would work. Assuming we have submaintainers with
> >>> their trees and branches, the final "stable branch" is merged from those.
> >>> But it's not a good base for work targeting the same merge window, as that
> >>> work would likely go to one of those submaintainer trees. But then it can't
> >>> be based on the result of merge of all submaintainer trees. That could only
> >>> work for patches targetting the next cycle (after the stable branch becomes
> >>> part of rc1).
> >>>
> >>> So either patches can be based on rc1 and applied as topic branches in a
> >>> submaintainer tree and then merged, or if they really depend on something
> >>> already in a submaintainer tree, then based on the respective topic branch
> >>> that's part of it.
> >>
> >> Right, most patches can be sent against the "stable branch", but cherry-picked
> >> on a submaintainers branch / topic tree.
> >
> > I think life will be easier with submaintainer separate trees for this honestly
> > :) or it could become a horrible mess in one tree I think.
>
> Requiring contributors to submit stuff targeted at some random trees is madness :)

Err what? The 'random' tree is the MAINTAINERS entry you are targeting, it's
based on the mm-next stable branch and only diverges in the work that's been
done specific to the subtree, what's crazy exactly?

I mean, is there any meaning to separate 'trees' at all if we just have one tree
with topic branches in?

Or are we going to have several parallel stable branches in one tree, and a
bunch of maintainers with write access stepping on each other's toes?

That sounds a lot more crazy to me, and I just don't think it's workable.
>
> >
> > I think the simplest is what I suggested in reply to Vlasta, where each
> > submaintainer tree has their own set of changes against mm-next/mm-stable and
> > then we merge each week.
>
> Throw in hotfixes and it already starts being crazy.

Again I really don't understand this?

Hotfixes are a completely separate topic for one, I'm talking about ordinary
development, but surely they're simpler aren't they?

Everything's based on Linus's tree (so no confusion as to which tree), there
shouldn't (hopefully) be a huge amount of them, and submaintainers can just
potentially find a way to send them direct to mm-next anyway?

>
> >
> > But am open to learning about what other subsystems in the kernel do...
>
> The TIP tree has a pretty elaborate model of dealing with topic branches, and
> don't require things to be sent against specific topic branches.
>
> I'll try to understand that model.

OK well, interested to hear about that.

But also we should adapt what others do (which I think is very important to
learn from obviously) against how mm works in practice.

High review load with many overlapping changes might favour a different approach
to a subsystem that looks different from that.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

