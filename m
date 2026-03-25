Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB29109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02D16B0092; Wed, 25 Mar 2026 12:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3206B0093; Wed, 25 Mar 2026 12:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFFF6B0095; Wed, 25 Mar 2026 12:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD6EC6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:17:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E3D71B8A61
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:17:39 +0000 (UTC)
X-FDA: 84585091038.10.3FCB26F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D4F9820015
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:17:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GWn7Nox+;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6oCPE2CLlELiVtRDVOLieS747QZajwPlS797rqAWdw=;
	b=T+stOqZCJiiQGI7K5yK9x9GHdQrcF1Qsns5VuMPhHXBeZmTBUFCVAplEvMlvv0qE2AmQK7
	i08Md3TVxf5J/jrOmHx3epuoKaZwMuXu7W7gQNd8ILKzK6du4jX36gOvkuHHAK/7Tay0O9
	Qy/X5y/XCytQslj8Tul9N8VjI6F/Z5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774455457; a=rsa-sha256;
	cv=none;
	b=LtBEChmn5GsEa1Rzx2BQ9ycB2e86NIoP6tzx0O7mwW72KyOk4YPPjHZlhE6XvPpI+EGVxZ
	QD+HqkMFWEV+THB2LR/Qf1EmoVu/7Gvk4RF4GZZ2lyHpPUwZlLsAkh7KqApynAuxyefzBE
	hUZQwKAplFKoqITg3AFOy4FBA+9xUHg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GWn7Nox+;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BAFE600AC;
	Wed, 25 Mar 2026 16:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669B0C4CEF7;
	Wed, 25 Mar 2026 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774455456;
	bh=xBkaWvNs0j6T79MITUFZj8ha7X2ZKulYCS3mkun9dSk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GWn7Nox+t+S1WqMXwp9Dfh5g69XALX64eXWlh+tmgox+OLOmEZcCbRvguyUb4X2Ga
	 PNMjiwevCNt1iESAw4HlmOK1HYu42nTrdQ6Kst2mlq+LiCPBSLvCVt/PNou71NPzs8
	 vyGPlzw00WbnmwXvW1doNEpe9GR6nu4SSSCBsXq8=
Date: Wed, 25 Mar 2026 09:17:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Vernon Yang
 <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress
 number
Message-Id: <20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
In-Reply-To: <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
References: <20260221093918.1456187-3-vernon2gm@gmail.com>
	<20260224035247.r6mxsfcpiev4wnce@master>
	<zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
	<1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
	<hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
	<8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
	<CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
	<22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
	<20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
	<3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
	<8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
	<0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D4F9820015
X-Stat-Signature: dwmjkork557e6sxqea3tnnahrfsom18m
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774455457-331520
X-HE-Meta: U2FsdGVkX1/OAdTbM7NADtk8jqzKcs5koCGdkbZ7QcUpPZrN1+lqG4UhWEY6n0KIjDKEsNQSjIEdnCCdaRc08057EYCPXhYggXAFZoP71rYcxds7lgQam/TCkoFeMPu7qnfEgQ9w65V1tMKZuLytb95wslN9h1/MSL/dmpAsB3bYfVZDbP81Ohmbi6Y+0yxdp5j1kUVfNIjtTEOBoDUwlZt7541DqstGyIgP/CHjdQriUDG7i0fyL3OnCCMADV1akVUlGTPUVPsv5xaqPySnpCSri2n8cyXTmlOH6OnvtfrzvldBylxquig/Dx0kOPld9H4vjTuYVlP7Vk5CTp0gnfu6nFy7jrbOrldYmNCVCLf/POd9Icqy+oaIEPSw+g34tObjb3jr0MVXHgMnqZLa8ATcvtq9n2rNHIsRKiX0FNVEiKdK6c5wqEojWrlqcm0e4jwsax4o2MWOkXCwg/PJGCRx0BEGLQ2IrNw4vedkgsxSfvMECQsof/yn9vbhlMOw4sFUUAsSYfx7LipFDWtc2DecWohlga3tN6JDrpRZmXASHzSGdKtYJo2hJ/wlH/PSZMtXK/OVb4Rvpdt6zACnInibCUuGfhiucBrB4i0ya2QmbajfPsoxXjWep03+2jrBMYQ6sW8lkajh4rw3/0OYmtLZM/y1EOt/GfZ3INPOOkWBAntRB6tUPC+9avdS1A9yImioW8TCBQsiQGAx1byo9wUchJ1oRIh7mnYFN4uuLaeP+MJK9w9JeWue2/0jVu1BF+OJMx26lcRFk78d7BMtyrWbi5NxxiUl4S4sj9CtI11Gadga+EnYCjKDlrDCRxMxuvHo3oMuOzrIcZ2gfSWaM1XQ4yAnK59s1FbsBOv7nOIQbLWYx8V/soL9suqh6VKxNXlTmipkoPiaRcAZcQESi3juWpJXz/VzzE6G+zQ9R537sOj3m7EApLClc16mUjdiqFlUdRv3LYXOOa6IJBL
 7bVnjBmG
 QiLx3c8uonbimev/AOymwXGCVVml/6vzEmtnxCmcSuwfWA1Ruu92OPv624tDG71SJJYDfeoleenCXAzfcAR+udjmk8bY9wtTmYlRlC5a8a8mqh+/W5iPO1JNWfcyHUzngF2NVd64V7ipM+oti+RbhcXQfhrN0l1vbIyyHaBPXeWv4zif/jWGSHJHBay4zR6W5U8kyRHVmirtT832nVCrgc9mhcf6Cb/1CSRPgzuECjy9ShI9zZtchbDnZo5v++gBGBGAXfhtJujVjv7UJoYr1GgrovYqCtb/uouPJ++NGWKwl6h8v7V4e7yWDNuriZlLiL3+gnM0095n1pYLTZnjIh6Km6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 16:22:55 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > 
> > Really larger stuff should be resent I think, esp. if there's multiple
> > fixes in the series.
> > 
> > A reply with the same-patch-but-with-fix-applied would definitely be
> > useful!
> 
> Right, for completeness, this is what we had in an off-list thread:
> 
> "
> Not sure if that's a problem for others, but I got the feeling that this
> escalated a bit lately.
> 
> I know, that we prefer fixups to sort out smaller stuff. So far so good.
> In the last time there were some series where I was seriously completely
> lost which state of the patches would go upstream, or what I should even
> review, because there were just fixups over fixups.
> 
> Fixups are nice, but for someone reviewing a series, too many fixups
> (either as inline patch or even worse, as independent patches) just
> causes a mess.
> 
> It also gives the impression of "this is mostly done, so don't waste
> your time reviewing it anymore." --- "just the finishing touches" ---
> "don't jump in late and cause trouble".
> "

hm OK, so what to do.  We're OK with teeny -fixes but anything more
substantial we ask for a full resend and I do the heres-what-changed
reply?

I presently don't fold the -fixes until the very last moment.  Could do
that much earlier if it helps anything?  Possibly useful to people who
are looking at the series in the mm.git tree.

