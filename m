Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DBD606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=FtAfBeWP;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=t+geoudq
Received: by kanga.kvack.org (Postfix)
	id 56A976B05B0; Wed, 18 Nov 2026 02:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BDC6B05B1; Wed, 18 Nov 2026 02:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3A26B05B2; Wed, 18 Nov 2026 02:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14C5E6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:33:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 142771A0624
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:33:33 +0000 (UTC)
X-FDA: 85447424706.30.CC29498
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF84A20002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:33:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=FtAfBeWP;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="t +geoud";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.150 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794987211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6roDSWKnYyHAhFGjefNyAWzSzOxePZ09Dwe4DFctx3s=;
	b=uJKjy+FvCVlDo1jubLwj8hRy6r9WCxCUt046y1tQHYWk+Nx5+wz5gVEESMOScn1q2eJD9t
	ayGmPuZN38BgVcs1/tynS/9taKl08LRRArlCgSFOs24eX+K4iD28A2LcrKGIikFPPZzy9b
	44w/8OGcvEBXifHAIrHOGpXmv67MXZY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794987211;
	b=AoE/VOm59ggwNA0P2R4N/pomk4dT55LS2gtWwufxrxVGtJ+LE8zdNZAWSgjL2Qvq1gzRbO
	88FPwG/jKdgly6TnX6sfbpziCMB7x9AP9Lp7xx/Vgl1UtvFsz4huNHVgl3Em7vskXNwfWM
	IzD3ZUvnX5aeylCB0qxvRghHoxzyEWc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=FtAfBeWP;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="t +geoud";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.150 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id BF10CEC060D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:33:29 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 18 Nov 2026 02:33:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794987202;
	 x=1795073602; bh=6roDSWKnYyHAhFGjefNyAWzSzOxePZ09Dwe4DFctx3s=; b=
	FtAfBeWP05mO3mjgSHEhdJkMMO2Dhv1keipU2fRO41MXR3pxhwg0R1N0R/t1wVfO
	Pvd2ztDdtrGRU4bv9C3b3UIO3fwJy1qnwBbedcCKeCeRCEHNaZxzN2cgHLvosCDE
	V6EceGhBhv4pp21kYsbJNtJFXUhXBtrqip1B6qVlUTQcwt7N4s0zSiDpby1ohbP8
	dUqAR2LPUSUjzogTf2MaHVuBguFSfeicrcmV7uix4cxR/FixB5BzAmGGsRI2p8oX
	No04xYOXBCw+3qjq8QItzYM/KlWOdGyfSDfKTDqVaj32tGhhqSRNFUNbojDtMHyg
	77++Apudunpow8t2b3z/jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794987202; x=
	1795073602; bh=6roDSWKnYyHAhFGjefNyAWzSzOxePZ09Dwe4DFctx3s=; b=t
	+geoudqzCZdXI7xRBPxWAxQfDavmdSiCh3UWuA+/LzYOa72IKwEiTHpetRP5sp89
	VkAhQFFNd3lWU1McdWcoeYCsJkw/Bx/Fkjxeb7uGzi1ZFhjvqBkTtsMEBn3DNgN3
	i9vDqrWKSIOTit8wdZhhDjKVV1WE925DCvL6PYuyQByEK7DEJXqDBpSYt9Y+b0VP
	jKpzuDd7761LtlZAQhIwxHIxInhL582dH17d+RPR1kJPv1OL4ArX4BgCOc68USVL
	VI0phge7mW1vCl3d0pRBb9ZMU/XkOlxp5Nc2CBljPDN9qkSi8U8eu2vKgkr3He9s
	VpSCYiUiFhk6KiqFSVRGA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794987202; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:K3CvK8nk4aldE44jYlKOf/vsn8UcMG47sBM6HiszXdyzIHa
	EG7PX0iEwuqzM3HBTXh2gQ8/q6RzAjxTMdM5NL9Xao5127pCr112Bvb5w9JvIUfX
	hCm+aYAEbUvzuto8/SvJ5SVzYxwZ2mBTzMFyJOWQe1vr/EIjVf11JrEMcaMI2FC8
	dEbk23f70xUXIfLmfE5UIzFc6F91reWI4BcE36GmI6iVnIXqszrf0cxEoX8JYddp
	gw4QUXRN8wFNJxCZYoVIZKWhLjTVWB/cBvZiKQh3/+GPUlfY3kd9TY6xCpfwm2L5
	dvCwF0M2SxFPxG5oQJQHTwcn7uVspXGSM+Tuj0w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:5alOQ/kZTW1ADDPVsGb9Gsh1WMyH6IpMfJ+BP/o9nTY=:QhhX445hegpb8c5Ib1paEal38B/c31H5pkzqP+4lcyw=;
X-ME-Sender: <xms:tlT9arGY1N0PjzpgmJbNdzuTyx1uxPrx8g9M_yA-8Q5RAgB7arHQbg>
    <xme:tlT9ajLdbpEBLv_HeTM9N5tV-btNFdlCYpBcoBf8VYYHSZOAv975XJlelr_PFbCSz
    Aj8RDP5VYfDDjd8wAKILkvvm_N78r4CaJ8pkeJyl0FxU6gpWEW7V-gl>
X-ME-Proxy-Cause: dmFkZTGgfH0TteI8sCoU1B+TMlwUpoxX9porz38r8z/m79WUQSZM1xYeyUI1aGcSwrgj+e
    Q1mvrvvl/LusFwPOfMMEaJ9bz16L8Fu+rinuEfLzMNhUVBI6LQgJmT1IijSGA0LW4OFjXw
    +UdfYHyPk6MDpiglwvT64NWn/yfd4pnB9tliApdUNEyScvEM1TlYoWkHI0TN88P/ZFHUo7
    mkXP87EAcf5fuV1lE1TLPyhgXJQgzAtJeG9PijfYLqQCIU5O8VQRyGQ8blYp6JUkMLhpi2
    TUWr3j9E/dwBpXDQqXnQp9cpdmrkS84QGRgcXsp49ZTXEMROXpEevGXLzPo6RJHlBD7Us2
    TLDaRuqhXI4BOXwKHqYdwDkWzv4xhsHwBfeoWhm4KQS9DZdy2MRFfeSqCHXm5gJylB7Bbm
    r72OpWQbF5maiOo6ASd3oSP23jzyEq97cSh2KWFpfm5X/nPK77dE9NB6CcPopnPqoBN5J1
    opBUUTuKtCWyuYjYRB1jfKn5BkXUl4NtGSBz5HXHX9ws4CCjjlYQZONAaBDWkoBpoIT29m
    skjrk+op4paPOTFH3xz8WqlYSDzmcX4Dyp30vnBzo/boHvC+TC5AfWUFNdkmO88cgB05w9
    UHuhVAfNbea/lxB93AmyEPq2Fpwl67Vp0on4UBX9mjTrt2Umx0OHzlCHRlrQ
X-ME-Proxy: <xmx:u1T9an2YHy_2bNISHCZHsPweEgznIuxzOmT1FyTi1OUrqXNjqdG_TQ>
    <xmx:u1T9ajiBir9GWMQ0J9dNfR6i3nXcDh5Yw6gbb8dC6FTkznA2iKI3DQ>
    <xmx:u1T9an0QAswWsfX3evW7nUOYasU9Z84PK3dhhPSY3bv61kfQpiTOfQ>
    <xmx:u1T9aufrMbtRqpFHC2oiBFbQ2RGqWfvdGzG-Eq4uI58rvMaT8K6x6w>
    <xmx:wlT9aovyKSDhghaHhw9Ea8OTVkZr-_koeLJxU-AoMgxcOE6S-TLzfTi2>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id B13D132A0099; Wed, 18 Nov 2026 02:33:10 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: Ackn33LzGE63
Date: Wed, 18 Nov 2026 08:32:50 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: "Andreas Larsson" <andreas@gaisler.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>, "Linus Walleij" <linusw@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Lucas Stach" <l.stach@pengutronix.de>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Michael Ellerman" <mpe@ellerman.id.au>, "Michal Simek" <monstr@monstr.eu>,
 "Mike Rapoport" <rppt@kernel.org>, "Nicholas Piggin" <npiggin@gmail.com>,
 "Nishanth Menon" <nm@ti.com>, "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>,
 "Thomas Gleixner" <tglx@linutronix.de>, x86@kernel.org
Message-Id: <ec881778-0f77-4f4e-be4e-17dc0adf8bf0@app.fastmail.com>
In-Reply-To: <sashiko-outbox-218805@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-11-arnd@kernel.org> <sashiko-outbox-218805@kernel.org>
Subject: Re: [PATCH v3 10/10] mm: print pte in __print_bad_page_map_pgtable()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF84A20002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6jnwtopu6nuc4xxs7pqfapu1grzwgoop
X-Rspam-User: 
X-HE-Tag: 1794987210-341844
X-HE-Meta: U2FsdGVkX1+saReQe+O2bBWTK5T8XB9gOxFiIPA0q+K2j76h+tA4TGHFS5Drxv7s8xmbtoezp+P471dF1vq3ac9xPMDS75pD4pWBqWFC/BMjBxXvctWbf2+juI4qHpBtOB34g8ZPMZrBhQ6vQyPmVHJdY+Jb5ik/N8opUYxtjRGrHl1FepbPWEfeoXDJYPugVju9kaDKx2rn0oie6oyY2I9gJOlf0fZY83zLie1rgrrS41OztOZU3IC3zZq4MKEUb/R/dUPoChXZaUhhW494K7LEC3q+UW4mu+pi2zDdAl4BENmllxzYu1InPaUh3cFNYX4IFRkkfW7YLKCnNxbUw7v1SqoMcu0JaMS5Y5a40gdid5O5AIg3ZV0R/7etCl425uCOKDqtO07JWjL/HjOWVUxM+gw9HXkjIgPOtb0j1Lgutktrl2BOaNGRt7eUu0y7LQmtF3BgPtxPi6kdVFs/RvL49OHpboTV20LiMwCChrFzEOYQ8qrVj4IHBpdoer9u6hxauUq6Hl42bcXPKGixh1NcWqZT50GxYZTm8FkJfPSqCxtGPVUDZFl1eyLBbA8mAGGfLFY/I9s50oVZMSf02ifjEU+KWwCmdaY/kXtgRcGP5n3OcOcKqr3dhq+TjdXRXs2DN9ZzxXHFD/8gfAKIqYSQSyAYQZfiNcOfBxUjsSgQdkgwrHA1qjtCFvioS3X0pyUS27xgnB3MlKS07tth/5QkqIcdS0qHe76csaFS/Ub/0L1aa9JG1de8Y7Wh1zLeWGJJJC2A64kV38FOf5UvW36IpKP8ahsWv/LpTieby00O+DC1+CD7E7aK9qWpaNsalcrghET7Y5qGwi/OfonJRtbmzmN9eVgziUxPjxX2XAG7D1ptWVpjNFMnEpTZIgQuZPr32+zZBkGze2Knmg7lW+dma5HsWpNv0urieSxl0aJSoeqLnvdgvPRbKj5XcQo1AR30HM6aaZKewwTs1Rb
 HenAR04i
 xcq1qHG5/UGtdalZuLmr71i6t3eMNfp4gG5qSa1yZbQIU0D+XsDo7ZjvbHN+057eE3RREi7nVz/fDUL2x2nouukMOm+5g3abHyr5j9qAdityQ0ildjC18VqBjAaufgdKqdg0oZPa4RfML5oaJYbM2caA6hPOkGjihwn3DgqXSdx3iluz8dBilQS8iseM6Elu+AuXKqPvBBxvBXhTa4uqO+Q/7uvRYo1gFQPzpLoOqrNLKZ85dowmdBln8luV5sy+EMzp+6EuUJ+y/7CPPhWQpVlDwmaOIfr6a2E8S9yQ+6g0bzxeCK2ClVINOq9vXYEwTQEZXkK7D27nyzHIumwKK61dX5Ls6bQNVY/hINaYKgJD8DBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026, at 13:50, sashiko-bot@kernel.org wrote:

>   print_bad_pte()
>     ...
>     pmd = pmdp_get(pmdp)
>     if (!pmd_present(pmd) || ...)
>                                       retract_page_tables() / zap_pte_range()
>                                         pmdp_collapse_flush() / pmd_clear()
>                                         pte_free_defer()
>                                         /* RCU grace period elapses */
>     ptep = pte_offset_kernel(pmdp, addr)
>     pte = ptep_get(ptep)  <-- bogus address or use-after-free
>
> If CPU1 clears *pmdp or replaces it with a huge leaf PMD and frees the PTE
> page table via RCU between pmdp_get(pmdp) and ptep_get(ptep), CPU0 will
> re-read the modified *pmdp and dereference a bogus kernel address or freed
> PTE table.  Using pte_offset_map() and pte_unmap() here avoids re-reading
> *pmdp and keeps the PTE page table RCU-protected while reading the entry.

This looks like it should be prevented calling conventions for
print_bad_page_map():

 * This function must be called during a proper page table walk, as it will
 * re-walk the page table to dump information: the caller MUST prevent page
 * table teardown (by holding mmap, vma or rmap lock) and MUST hold the leaf
 * page table lock.

Is that a case of do_swap_page() calling print_bad_pte() incorrectly
that I can ignore here, or should I actually change this? Is the
same race present in the upper page table lookups?

> Also, this isn't a bug, but the early-return pr_alert() above adds an extra
> space in "pmd: %s" compared to "pmd:%s" in the other messages.

Fixed.

     Arnd

