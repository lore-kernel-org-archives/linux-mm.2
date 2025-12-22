Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56A1E674AF
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 13:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FA26B0088; Mon, 22 Dec 2025 08:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7696B0089; Mon, 22 Dec 2025 08:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9D46B008A; Mon, 22 Dec 2025 08:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D13776B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 08:33:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DE3112983
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:33:15 +0000 (UTC)
X-FDA: 84247198350.18.562CFB7
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8DC6F2000E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 13:33:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="N Nh5ZJl";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TcnxBueA;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766410393; a=rsa-sha256;
	cv=none;
	b=F9ESn/b2Tocpvo061iVAqEK8G08M4jHfFXJkK0v43j65rAYCkFfIlwegXzNqNHo31SnF6a
	xZfRylXjY+Dzj9EdoK/NCuEcYoARhse9YxRcKLSXi9Fb8Ox8G3dFPjc6eumyfdpwCzFyU2
	JE4A0kL4ORcDTYNzLl3YBZmB9HY3wkI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="N Nh5ZJl";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TcnxBueA;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766410393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ziJWuRWWKFNBBpXSChUIIUgb7V0QaoRvMak873+voDQ=;
	b=nsoD1z9t3UJF0+DG9QmKBOj6nDhLyVUDeaIc8vGxGJBI7t7azqCmspD6qPMlHV9vX+B44t
	JYiLtgoAGDpMPkNTBq7ARjxsDZ5vWjtMZivMtSti2/cJOJvKAaNrqVZdAptnHyR3NAXpCs
	ywa40tfKPlDPkM7W022hdNsvVHpBZJE=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 67BAE13002D9;
	Mon, 22 Dec 2025 08:33:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 22 Dec 2025 08:33:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1766410391; x=
	1766417591; bh=ziJWuRWWKFNBBpXSChUIIUgb7V0QaoRvMak873+voDQ=; b=N
	Nh5ZJlqg6m6yKqgo1zs9k+JvO/r3h8Q+eA6NEaWiCnW79ZDju2vvS7ToL7Cze7Rd
	zRfY3n8aLaLgBRWlRXrb8pai3Fe1KaSTr9t2WwR0KMEjHkkSo7DlpZsKFlL4uUW2
	0jYrSZ1bjD+fpYe9MhzI6z3ytUquwpwxTfi8/+mED478qmrqFxRMfMi0oR5AkpFz
	ngnzjpRhSAUTwOyOfYTEpsaL2ogQGvl99dmCOdAHh7/k0tMXjNBheREOViiydYM2
	9dNp0svWEmu8PuAkeUifr8MdNnv2gUp8T2cW35NbXHwOqTAbqJwMLLKZHr9iqXFd
	vADWFmNtMaUbJ2L8ahd3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1766410391; x=1766417591; bh=ziJWuRWWKFNBBpXSChUIIUgb7V0QaoRvMak
	873+voDQ=; b=TcnxBueAi0t+PuQH+EO5eSmgNE+vvlG9lQGBIy5XRKYqNpNVou3
	HQPwmE7sfAkGSQPIbwpwZb8Wkk3c14T+esRUldVnG+5RU6wQOSmYAY3KGKyk3c1M
	hKJ0uvxD5D/H76gTh2eXkueyfqGCjtPrAP1LwdpnvO1lGe0pqfdokLRtpY5E3leE
	SEb5cSF4xyYcM+GhKKGBrX7mNjju5nYbBRRDAEcDNfXGu11sgfxhRZdg4IZ+fS6Y
	m4LgHWCiM7pJQSln+HrFytyQqiL1Tkj0tGMhSEJf8YNms+osRB227e1TB7LHmBA1
	0ArbpMRIga8nqYALb/CBnOHmQzi3lp8ssvQ==
X-ME-Sender: <xms:lUhJaYaRvSfEZVE0B-JgvGVB1hzA73VaobUMQerSssr4GMmNKSxKyQ>
    <xme:lUhJaVbhaZfMf6wekE_bwc5gKeWaY_HJTA7QU_3v_plg__hSfLbrsoJvZVg7Vze82
    fBvx3IGA0PwVucDwT9e_XTorQf9TXl6yWl9KrPg_byq9viAdMc_c94>
X-ME-Received: <xmr:lUhJaXTqCpoFXSvfvYUc2ysKC7zymxIwSbtF_nWUgD7yvULeBa7z8CuWaKMFKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehjedtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohephedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehglhgrugihshhhvghvrdhilhihrg
    dusehhqdhprghrthhnvghrshdrtghomhdprhgtphhtthhopehguhhohhgrnhhjuhhnsehh
    uhgrfigvihdrtghomhdprhgtphhtthhopeifrghnghhkvghfvghnghdrfigrnhhgsehhuh
    grfigvihdrtghomhdprhgtphhtthhopeifvghihihonhhgjhhunhdusehhuhgrfigvihdr
    tghomhdprhgtphhtthhopeihuhhsohhnghhpihhngheshhhurgifvghirdgtohhmpdhrtg
    hpthhtoheplhgvihhjihhtrghngheshhhurgifvghirdgtohhmpdhrtghpthhtoheprghr
    thgvmhdrkhhuiihinheshhhurgifvghirdgtohhmpdhrtghpthhtohepshhtvghprghnoh
    hvrdgrnhgrthholhihsehhuhgrfigvihdrtghomhdprhgtphhtthhopegrlhgvgigrnhgu
    vghrrdhgrhhusghnihhkohhvsehhuhgrfigvihdrtghomh
X-ME-Proxy: <xmx:lUhJaa0nHkIMhO0wNqcIqaA2VZqM_n5e3El2yXbsX3s63FThxViDqw>
    <xmx:lUhJadUHmqKJkSDzkhllb6ulx3dd1Clc0eius98GKyWfQkGPWxbP5A>
    <xmx:lUhJabxmKQdlXnVM0ZfChKDOzLiSxrT9AY6kBa8ElJ_CCdbQaT5-zQ>
    <xmx:lUhJafuKqy7vLJ43G9kolbN9svCI3mcoCXWfhQWGWdNmFLnZkJJgkA>
    <xmx:l0hJaQmuk6AW1M3pC74AC2MEW3LSHB6AdszZ3Be4ZVub0UNcf8-lYwiG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Dec 2025 08:33:08 -0500 (EST)
Date: Mon, 22 Dec 2025 13:33:06 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: guohanjun@huawei.com, wangkefeng.wang@huawei.com, 
	weiyongjun1@huawei.com, yusongping@huawei.com, leijitang@huawei.com, 
	artem.kuzin@huawei.com, stepanov.anatoly@huawei.com, alexander.grubnikov@huawei.com, 
	gorbunov.ivan@h-partners.com, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, yuzhao@google.com, baolin.wang@linux.alibaba.com, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mm: implement page refcount locking via
 dedicated bit
Message-ID: <7d4o6mu4jknuellijeotrrcah7e65ffn2l2rxzx4unh3x32mmj@ego3dfnrmdjs>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
 <iv7m5rmuwssltl6yzwuop3ry5s4l653lykyvrmmy6qdbyyuoew@th5xuev3mwus>
 <9822c658-c2f0-4b1c-9eef-9ffa865e44f7@h-partners.com>
 <ans3mrfqd6jv5hfarbx5bzsl2ugtatbfyjw2vlv5ybuhevjc4i@46f45fdds5m7>
 <ed1dcc5d-1e80-44ad-b050-e37460d3dac7@h-partners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed1dcc5d-1e80-44ad-b050-e37460d3dac7@h-partners.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8DC6F2000E
X-Stat-Signature: hcsfnkmdessu1ikjq68dcnrtqm8p7jms
X-Rspam-User: 
X-HE-Tag: 1766410393-144004
X-HE-Meta: U2FsdGVkX191k1ceZnOJAl0Tf18fvOZFg6+rheY9kJtMRt3pfspylthUZkvGaGKjJ5ILH8cfSs9kvP8ax3Pr/b7QanRGIYwcFGNMCqR9oFJ98mT1iwWdng0sZNmxQF15YBZu1Aa/YtqJCU8borD4Q4DAYo2fCJ8mjw91eM6EjAxgY5RaSr/zprK4LVR5f918oyvf4m0MRVkCJj+fcyYCp92GsPqKAxC4Mkh3SI8wsfziMMezKwywk0LW7Hz5Zv/6BGQW/4ftJscCpoH30r5LRKCgBeUtsIOns7WVFBs/ue/TYh6HjgV11FUWPNPG7ha4VBqPlAHqWDHDFKipgqMGI3EwBUvJ6ZZ+pYnfUZcbvHwV6l3s/1iOMGf6zQEMUWi6HAxhpnPKnctiw0NCKx93OJy+8JZ1FV31RyzI2iD3ltRYwvZytmFVjYgOpLRlDb2bUzrhJgqrpq+D2UU23QyqettJdcEkDQlf/W7DfXCT0lS9xceh034T8ocyAvaIlVZJyPXgr4yodWxb7jSPTB1Ef5wUj1dQYmvJIfCAOHLfJnT1OPqa/wCbRFZl+lMPHCobjz0BSajogOOij/bYxgU8gJrwOx3F0EfMv3TRhhJHHVIGfsFZCPHurVmTXqG2xFjQStcsCn6gWLI2F4Su6W4eh3lm+PFYiiB/GfZF9tpupFPs5q/vvm0yLF6nX4t3w7KtdxApjlXzqQbhIQlzRMN2ivqMFGoE8QK0VlUWcNpHtbKEssmHOFt/NDFy54wMs7Sl6kdwzGCYw0lckM2/5O5CvIibGKOYAnqQsxwySKJ9l3JXORMugB6f4ELptgJGPukgOjlM53pRRL3/GxjtBgQ6qo/Kpt/u6Ksd535Jv0wjhHP7yv1vn7rgKLLunceI5xMeycqcvBy1zCOmgFWbcfs+F2gVcqBxD8yhqg60DxsQPiiBS6e6EFn6ZiYi8c2RBoUbnNVuegFWTrqeoSF4Vn7
 j3rB9tvE
 WFVBQwCmID71NFMC6Ls9EYGM/mk5nmBsFj4xs0Phcp4kEhK9k8XNZfZ1RPB8pxb0f33MO/jbpaRQTvgPfD7qxcv/Povj4rzpihUr7OlIsr3ZVq3bXYkWpiKA0iosmTmgBB7BCCNZVudXyZnPVtGLN8Gfm/NBnRRuUAAzZgNe7LeEuv3AFtOIMtfwqfpj/pUyvkXT9l2SWpGMoOKhRtT560eyoeXGMSAP3AwCZRpfBwkqIj5Rt9PtF9NjkZz3ro/eMDYXKzFbVNqgC+OUqVUyfxklweqKXsg3vepP5eWFwKlVlrbSHYy6fs0MjRB/kjPU6gnq84hLZhKdx1l57yzo4/99VVC4gLGw6XFXkIDb/PYWJXlY5CtTM3LMfCgRmyCP+FwhtrDabGVY9hpceDSb3+SjGHSCPxPjptPkpygJQ+wCEqtmhENZYig4R19e1cMU3coI9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:08:54PM +0300, Gladyshev Ilya wrote:
> On 12/19/2025 8:46 PM, Kiryl Shutsemau wrote:
> > On Fri, Dec 19, 2025 at 07:18:53PM +0300, Gladyshev Ilya wrote:
> > > On 12/19/2025 5:50 PM, Kiryl Shutsemau wrote:
> > > > On Fri, Dec 19, 2025 at 12:46:39PM +0000, Gladyshev Ilya wrote:
> > > > > The current atomic-based page refcount implementation treats zero
> > > > > counter as dead and requires a compare-and-swap loop in folio_try_get()
> > > > > to prevent incrementing a dead refcount. This CAS loop acts as a
> > > > > serialization point and can become a significant bottleneck during
> > > > > high-frequency file read operations.
> > > > > 
> > > > > This patch introduces FOLIO_LOCKED_BIT to distinguish between a
> > > > 
> > > > s/FOLIO_LOCKED_BIT/PAGEREF_LOCKED_BIT/
> > > Ack, thanks
> > > 
> > > > > (temporary) zero refcount and a locked (dead/frozen) state. Because now
> > > > > incrementing counter doesn't affect it's locked/unlocked state, it is
> > > > > possible to use an optimistic atomic_fetch_add() in
> > > > > page_ref_add_unless_zero() that operates independently of the locked bit.
> > > > > The locked state is handled after the increment attempt, eliminating the
> > > > > need for the CAS loop.
> > > > 
> > > > I don't think I follow.
> > > > 
> > > > Your trick with the PAGEREF_LOCKED_BIT helps with serialization against
> > > > page_ref_freeze(), but I don't think it does anything to serialize
> > > > against freeing the page under you.
> > > > 
> > > > Like, if the page in the process of freeing, page allocator sets its
> > > > refcount to zero and your version of page_ref_add_unless_zero()
> > > > successfully acquirees reference for the freed page.
> > > > 
> > > > How is it safe?
> > > 
> > > Page is freed only after a successful page_ref_dec_and_test() call, which
> > > will set LOCKED_BIT. This bit will persist until set_page_count(1) is called
> > > somewhere in the allocation path [alloc_pages()], and effectively block any
> > > "use after free" users.
> > 
> > Okay, fair enough.
> > 
> > But what prevent the following scenario?
> > 
> > 		CPU0					CPU1
> > page_ref_dec_and_test()
> >    atomic_dec_and_test() // refcount=0
> > 					page_ref_add_unless_zero()
> > 					  atomic_add_return() // refcount=1, no LOCKED_BIT
> > 					page_ref_dec_and_test()
> > 					  atomic_dec_and_test() // refcount=0
> > 					  atomic_cmpxchg(0, LOCKED_BIT) // succeeds
> >    atomic_cmpxchg(0, LOCKED_BIT) // fails
> >    // return false to caller
> > // Use-after-free: BOOM!
> > 
> But you can't trust that the page is safe to use after
> page_ref_dec_and_test() returns false, if I understood your example
> correctly.

True. My bad.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

