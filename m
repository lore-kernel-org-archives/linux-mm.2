Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C534FD8FC3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF5C6B00D0; Thu, 26 Feb 2026 10:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7256B00D1; Thu, 26 Feb 2026 10:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04D96B00D2; Thu, 26 Feb 2026 10:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4EC6B00D0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:54:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B608160109
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:54:28 +0000 (UTC)
X-FDA: 84487055016.04.88FB2EB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id A7393140006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:54:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iT3lYSOq;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772121266; a=rsa-sha256;
	cv=none;
	b=A0Jsppdoys4YwND0ASOVQ44tzaOEbAx8vmTtyxFEEBhu5nhHYTYy19V4VOuAI/ws4byEZ+
	G4VJDOBfgfLmYBcpqku9DGUQ4iWKDV+OIVLG87HSJHHI6ur30IWFHiO7Hxqo4OU0W2WWoX
	YDTZMnkJPurI1ujo6tR947R2L6dnnx8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iT3lYSOq;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772121266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSkf0BRt7zsEK1TftnTtei0h+FVjB7BWoy2SIbW7wD0=;
	b=L3o0d88smt7faEtuDuZTpX+m7RKoBdhQa9InhlzxQHoI2MEMS5E4eGMRlwww2/IDtQmaOB
	sTMWYxNjj529J6zri93HuVevnW+vWOggOOrjc+CKGF5v+IUWDjxOlLhkCFsaBUTmHB/iz9
	mEKgaoadXJySAP5Jx2kI6mc0srtSP0k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HSkf0BRt7zsEK1TftnTtei0h+FVjB7BWoy2SIbW7wD0=; b=iT3lYSOqfSwmSi9NPm4/LnoNaH
	mkh1mN7tRV2wX1mS6wiohO/PkJb4JVJhCzWWRW68tbMvOa7jVKKqFPDkrz9HcIjpukW5L0ZMVE09l
	pEY1xcQjIhVoeEs+NLkYdKes0ywlRrF37O+D3rU57defMG6ZpcImjlQXH2lx+J2cknpNkUiqPvEfE
	R3N6Qvudh9Vjkb2pslrckL4sLfCCjP2CLJvX4dGslOJuzq69sKR66brkQp6trWpXoP2mjARmYh7br
	udsnkYigvcMSMApONlgH5sooWaPrkbCleToyDekQV8akzRfJFEy3yftaIfrw3M7iGBG24jmnxOa1d
	K1yPqfaA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvdh0-000000033OH-1C9m;
	Thu, 26 Feb 2026 15:54:22 +0000
Date: Thu, 26 Feb 2026 15:54:22 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Message-ID: <aaBsrrmV25FTIkVX@casper.infradead.org>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
X-Rspamd-Queue-Id: A7393140006
X-Stat-Signature: j5wgntnugtwhgsqk5pocmy8mpbri7rba
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772121265-169957
X-HE-Meta: U2FsdGVkX18cz6yzU+Waq0QqpM86UNnQZkix+Di9gwFGzswu6anNqYgIlsdCwMXRsYRkDIZ7Gm6U9PLIWRQOed2Wuolzi1zmUZBJqHVZjg4ui/pi52JDK0Ykb/GIzd2yGMkcYRGZZUYZf3RtBEAxen8R//RNKeJ+uMO1psamFfPa1ZP51deWGCScGIK5b2TpowGizJOG+Otw6B97333qXrrCxeFWF3PFwFGOYKOtMONs4M0MHK59j2OM+ynTjtk8Jf/j+voZ4pwfDG4g9G2ihvwmhYJF+pjSpY1cFwXTplu8D6I7cexnGId4RgkraSUK19sJFMsSFtQuUiivjjT+2HWZZ8Molsy7VsrTwbHkskdxpa0j8pQQ1uiEsy/kmuReoq9c4gmteHrcXkahPvmzwBOTWIda7FeakXbhn4MXhbQe5v3YhLC4FFl0Cq5A8vUHzNXsmTRO5TgjFG9Z17G/KIu9rOlCKFD/nBRgQ4srjRYd+BQrDMH5BXuIyXq/7eGnHeK2bbDduKZx3iUcsbPYxU1al5tqmmGybcdrhpFeeDPY2B4kED0TkPPd05/H9ha0T1HAN9DFIOsTkuMI+rvMAMyvlCtICtsXe6IhIRZdRcosNCl7R1EDsXh6djn2mz7e4FqH4vGLb6mRGyD5Lxn2WSsiAu+aATyDFChWOMuj3wMTehuVtgAgIev9VwgwpUDmO9Bn+jEPkW/iuVTbLl1dKYC1uG8rqvzBUCgknIbNHW4EZlZXosMMBzW36OiTgUWn3WZ1BhJYhOrhBr7v/rEthPZtr/silAYep8/h2uk1Q7beN5TY7ebQOGcLGJP8uaUkbR+BWGZDf1HxcTAkDEzwmUe7nBo0Bsu6w+DhPlN+0e1m7qROYTn79rY/a+F08jBnFb8dI7P3wlXbXxKIMpYgOlDfaFgMiXWtqOtoct7ooRDMro3OtJgt90MdSxAmSdLy+okJs2iQFZa05msqZAV
 JeYfSH3o
 KYw99cl7Rt/fZywqpzaM5xaixZD99JXOKXAEbTWyD6xpehkAXjwTl6gNLfoy9fvrQfwoKTimcjEa0pOrrtfZg92RgKRghXt8LBMX2sfUoN0GyfO8+pv0PbfZSv/0Ot9saturkZ4s6dWNwa8HE+aIzldROiSmaoJsSJ7iJ3c5hjJCIQ86l/1x5uXiKTMNAidTej9OaeQs3mxPxTG02a+GvCB1MMv3dau1YAqFFoQ3CgRG/4xAGSvTJkymtMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> MGLRU has been introduced in the mainline for years, but we still have two LRUs
> today. There are many reasons MGLRU is still not the only LRU implementation in
> the kernel.

To my mind, the biggest problem with MGLRU is that Google dumped it on us
and ran away.  Commit 44958000bada claimed that it was now maintained and
added three people as maintainers.  In the six months since that commit,
none of those three people have any commits in mm/!  This is a shameful
state of affairs.

I say rip it out.

