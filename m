Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A5CECCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0116B0005; Fri,  1 May 2026 14:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977E16B008A; Fri,  1 May 2026 14:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4706B008C; Fri,  1 May 2026 14:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5596B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:12:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2621EA020B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:12:15 +0000 (UTC)
X-FDA: 84719645430.09.BF0F1B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 36986140002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:12:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRsU3W1r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777659133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkXXBdt0M3R+uKqttuBovLKHVgEa4IsAzSjxRQeIDuY=;
	b=sYXj2GYu65ngrc6zqcq0RWK8y+9bGRw3ffsT+eZDL2Ow04I0Zao4yBzACLbqvtknp6MBzQ
	6zCewsXJuH+kCcb6qM2N5uBe3CSrBGWgB8uwmmU32WlLEw7IndSwUVe0za+VawGc7QYZCk
	XdahO705SIgaIuQzx0fSC5xc0Lpjtuw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777659133; a=rsa-sha256;
	cv=none;
	b=kXYZXMxep7ge1wWn5oNHXA2DHTcK0+9ERN8AExMX8ARQX/M9tbomERIKbXFozcd8D+7VdJ
	Uq3AotpCe2uCnf9lGLThjjulqsE50LOlKKgndVVO4sMAWZXpmSo3xA/yQDc++zdk1IEbQI
	SdNMu45RRabkHFCwp82r6QkHa1oXR80=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRsU3W1r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EAF660123;
	Fri,  1 May 2026 18:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FDAC2BCB9;
	Fri,  1 May 2026 18:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777659132;
	bh=0C8FSeR6gZaUNglKGkPC6NAEZBKubzybVyNYIzdbSvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IRsU3W1reINnCNPbFO1gyzIMgtOIdIGhvTAXT+JzQm95SQNSFabWudGExaNUq1JyV
	 T05aOl5rUWNay2ux9xoVPgYX0gtJ5sblNXduVp1OzTZbEUJg623d912qsmk1HQeBBQ
	 j5hDzjKUqx2ZZ2oC47yIYzHLJjhJBGqC32KfMsmdy4pORyv9ln+f4vri5yi5W/xcGh
	 UEzDyT+53l5/oteDRlJgGsjNFNUolOvVGatpMMhWuSEcbPiJSwJKw1+9TxPR6uygum
	 vYZqTVhzSfai14WT9p4LNVEeqcfuVsAzMuVxXdnf8bDFvnRXA4pkYG2Gz2ETuH1tnw
	 xfElAbPP2BjUQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id C7DB8F40078;
	Fri,  1 May 2026 14:12:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 01 May 2026 14:12:10 -0400
X-ME-Sender: <xms:-uz0aeN8jG6yqk2YxQCAWDn3fTHkiErPx3gIIFSh9_OqYnju29pRyQ>
    <xme:-uz0aQJ8HGKtBs5FbW7yExT62NljoHw-SkV1v_uYxl4ZAAHyWZN3eW53F9IcQVZqQ
    Cy9zytXNUnqIGMdMDIzhQDY0KoYU2L4trgrAgu9DI2U-Nt7Pejjo9Q>
X-ME-Received: <xmr:-uz0acGuj-SIgRFy9FwdAlcfO34czvlmCg9e0Iro04BvOSyiwC-9eXXe61d1hQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeltdeklecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeffffekgeffjefgkedvjeeggedttdeljeekhffhudeiudfhiefgudeugffhheffuden
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlshhfqdhptgeslhhishhtshdrlhhinhhugidqfhhouhhnuggr
    thhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpd
    hrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    khgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmse
    hlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehtghhlgieslhhi
    nhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomh
    dprhgtphhtthhopegsphesrghlihgvnhekrdguvg
X-ME-Proxy: <xmx:-uz0aTzrq32IU5V72-vLQnot2tYxKjebDu9vRvULigXmd94E4T7ahg>
    <xmx:-uz0aYzAqgqBzD9I_8MYUm3oX0Aythp9VhHVFdpfE-jhj4UGzXvevA>
    <xmx:-uz0aZbZNudituxlBnHcKqS6YHpH2Ka9v7bUyHk70mZ8ZxcCP0gj1Q>
    <xmx:-uz0aaxQkALfnmFnXbUF0s-UJPj96H80S2Dso5y5pHdwajqSRzz8IQ>
    <xmx:-uz0aXhiVuKbh3QJ5R2kjq8BmB1pZkG0BV0oH7Fd1PzjGA695YpQZM9W>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 May 2026 14:12:08 -0400 (EDT)
Date: Fri, 1 May 2026 19:12:03 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <afTstzZz-36KxthJ@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <afTjKnO66Hl-XmfW@thinkstation>
 <01ea8acf-69ee-404e-8785-59fb0a527253@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01ea8acf-69ee-404e-8785-59fb0a527253@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36986140002
X-Stat-Signature: dizw5ujzre6ccmt53uf13gd1armx6ugx
X-Rspam-User: 
X-HE-Tag: 1777659133-442880
X-HE-Meta: U2FsdGVkX1+BKHqbaFeE4zmQkhXB1pvAMPWfOSEiQcrpCBnwFYIUCZoYsVi38Gh/vblQ3JwJ+rO5GLzGnaV9bCiSSclvJbp3rr0CQnSp3pv+z2D9RMEzHGi8TmDuoF9JOx9axoRnSC9+BaA8rArrHJ5tj4Q4Bd9onwQx7HFey8ZcPWkHRwnWpF25h45nIRLK83dPE/A2agkLIqE9Is8dBdAA4/U+UN3ubqsggZS83S6ns/DlZD+kn9I43YCptWshrbgAIompbUKtW3aDuDgFjYBTaMymmHFzyziG8rMSuXfhYuawU/wD+GQwCFwb6CHtvFLt81E/RmxOE5p6NT5ywnBBQLWa/qfX5d1rxCHUxREeu4DqTuuCAGHuN5abegJPTxA/zKpTXHdQaIS8xWjoFeZzfZvJSJlPLEPq7KtoXeZfVOYGQKNaUdRwMeaArHXnHKYR9mA89zLdrVxtuJmbKLaiJLLbROgAQorUGQzJJQ/2aPoRjcpXbLKcNtydIEktq1hytzLbDlMod0FEiejHEzNo0cBVvaMnev/FXJ9EXypKufbnvDu7ZjPrf+xK9LgvI1KZ+NfMZckcPykA/EVvqjfMMAYTc5QMVpDdkIoF3hWGKZe/97f9okYhDOBczvlcsNyo9km+aFDJ3FikO3R1ad5Bta/duXQyQsYAbA6zUBjhoqzktW5eepUdXoSztK0hSYlgmWbzk4yEjbtLgmiaLGN3r9F0YOXtiXVRJETdp3Cvc8k2JYh5hzyQ4D8x1U+LgiQ1p+uH7TBFhW3RNORuvn7OR0cghGCD7jZ9xGlov0HDcWZ1+5mIfPtjLxFoVQ/D/7375OGn5+5GYW2zXgpEX9DPzFRdk2E56m/6NphZBNA8iE9xtVLgawL00pcUlAhjLk3xZD0x++uv2Xu33MEx2HbEIs3yBPJotvumBnefTbi4keZMse6+7FOscm+u+sbZ6Z9SFC0hiNYng0ZRdhY
 4BQX5/1c
 m9w3R9TYUZ3apEreMupjzGb5kaJi3YqI1dJpSEJQwHriC7p2OiSUQqgJC0C9/IFrqfT1tIsW/pnjusSsWgIJMaZp3CDHPVD40Ct4f8JxyvyAw6zuno1GkUWljoOh45cUgY2OEC7enN1S6YFkxXvCHSgHmV5g8bwmQno/FA4iLmQkhUFE5HjhnOMQekC7W2avtDI76kvbZT1NqwcnuEsugNyfudotOO5C6nMA/73mW1PKDtym+EhXF1B7PDRw69EBO0gnllmCqAL31fZpeIKm3JaAERoE65TThf39WLOlCGNJnm5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 08:02:28PM +0200, David Hildenbrand (Arm) wrote:
> On 5/1/26 20:00, Kiryl Shutsemau wrote:
> > On Thu, Feb 19, 2026 at 03:08:58PM +0000, Kiryl Shutsemau wrote:
> >> == Status ==
> >>
> >> I have a POC implementation on top of v6.17:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git pte_size
> > 
> > Just a heads up.
> > 
> > I've updated the tree. It is on top of v7.0 now.
> > 
> > I can boot my VM fully (not only to shell as before) on all three page
> > size 4k, 16k and 64k. And it doesn't crash immediately.
> > 
> > Page fault handler is the most challenging part of the design. I wanted
> > to flash it out to RFC quality before the summit, but it is not there
> > yet. But it started getting a shape.
> > 
> > Volume of the code changes makes it hard to deal with the patchset:
> > 
> >  1530 files changed, 12675 insertions(+), 8669 deletions(-)
> 
> I think you know the answer already :P

:/

Let me present the case at least. Most of this is cocci change and most
of + difference is tests.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

