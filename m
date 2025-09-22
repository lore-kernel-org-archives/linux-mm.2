Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC566CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 06:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4508E0005; Mon, 22 Sep 2025 02:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBCC8E0001; Mon, 22 Sep 2025 02:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1278E0005; Mon, 22 Sep 2025 02:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDE2C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:37:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C8DC13B362
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:37:55 +0000 (UTC)
X-FDA: 83915930910.06.9C4F38C
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf06.hostedemail.com (Postfix) with ESMTP id 57551180003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:37:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="ube5lV/e";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="H WkKCQA";
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758523073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRTsv9FG3U4ybrglnAgKP4GtX39SQERoznL6ypXbkIM=;
	b=FZvvbyPF0wWSq5fkJsG5/wK6LuhYLY7lp2tHJHlDOPGEke4P/PrSUvzV56XqzUMMXUpQ7R
	JWmiseINbR+qu+XusWJjkGO64eOKDeKwZAVfJRAiS+MaWT5Hke/OtcUCAmvLNuXsyBrGkP
	AOpvu3av02NNO0zbAff/pab4Xvl7XZA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="ube5lV/e";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="H WkKCQA";
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.143 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758523073; a=rsa-sha256;
	cv=none;
	b=BURQujlmnLyHHOI8fXi0GDpGxbBf/Qr49J3/1ZPmIVv+3cFBR7++2ufE/oUJT/tKYapYNH
	p82Yd2ZoB8htgCcvWfonFprpM0LOZ5VEDNi3d9+sf4nIxxtKak2qpJ0VBx8jMOCLclbulk
	Vgwl2LhjNjy2jz7Lgryk8CwWc5n9nEQ=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id CCFAA1300076;
	Mon, 22 Sep 2025 02:37:51 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 22 Sep 2025 02:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1758523071;
	 x=1758530271; bh=oRTsv9FG3U4ybrglnAgKP4GtX39SQERoznL6ypXbkIM=; b=
	ube5lV/e9Fiat19JzRP/DHcXurPxbkdd8gTPAEUq6Ffs1FJXVENctoAeO7N2TPFH
	a7vzVB4q3bJuTW5bXvD3vEpXjY0wn88R2Vj+8DMppvdSoK0H31eVa7+EV7Bq7NlN
	voXhivc8lqXXbTJlAi7PNyEb9Gj++SNGdJrP4uQegscFH1ww+cmvFLG97VP5/7S7
	lhCm8rbmXrqiVaF/dK+M+75/8lQiJpfAX3S2YJPedCtSmfsS4yXz9DknVRtriD5b
	4hLC7UkdD8neLAAwwA+N61yoloBXch39dSs6RXBFlVU53H2wDbhp9+u/+uwCIFp6
	D6/Nkbkz1gzAfNKS6mEaCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758523071; x=
	1758530271; bh=oRTsv9FG3U4ybrglnAgKP4GtX39SQERoznL6ypXbkIM=; b=H
	WkKCQABcikKJJwPFToeLddMVwzFfr5YjTeBWD0KOhkBpbdDLCYa26hETGIpVWeU9
	lTrJ52EBR71niW7a5TVY8xGLAP2purRmJQn/EWMJsxVW2zUlU8VcwSQNUefunoAH
	4/Q3NWQ8Bkwu42fsqjwkEg28a+lkOuWoYQn2Wk1/xxz9bEKDgOgc9V7gbJxetKsf
	lBTDFWaeGXry604w7kZdsAJ2sR6ZoHjAIfROQ4e12WawP6guIvhbN1JsepvQr7jo
	XOBtE3jLR8yXWmifeLSK39NHzMAZZihunXeRKqpW1VWYz8pbtTKT8YodIzuewwXw
	IWxqaNgEJsJ3D6LuKC8jQ==
X-ME-Sender: <xms:ve7QaLXgBdFM6Y1TtCJBlITrjLFVzeXnRS4obxmx0q8GChHn_YLLxQ>
    <xme:ve7QaDlnNax_QJ4BhqfKLe8ENI29gzRizviDFzOgEj0JOW0BeK5cIRgBsBn-ygKsQ
    YtoUajvAv7ZkMUJ2BM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehjeduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopedviedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheplhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtth
    hopehrmhhkodhkvghrnhgvlhesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthho
    pehnrghordhhohhrihhguhgthhhisehgmhgrihhlrdgtohhmpdhrtghpthhtoheprhhosh
    htvgguthesghhoohgumhhishdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtoheplhhirghohhhurgegsehhuhgrfigvihdrtghomhdprh
    gtphhtthhopehlihhlihhnjhhivgeksehhuhgrfigvihdrtghomhdprhgtphhtthhopehl
    ihhnmhhirghohhgvsehhuhgrfigvihdrtghomhdprhgtphhtthhopeigihgvhihurghnsg
    hinhdusehhuhgrfigvihdrtghomh
X-ME-Proxy: <xmx:ve7QaJu1tJyg9opP58GfgasJD9sSXHsTqnju42GwxkMOIF_P6AK17w>
    <xmx:ve7QaKRQTwey9OWjnR3DcYzNr2pVQCP5-vQiomV_czkcIwLTgEJOUg>
    <xmx:ve7QaIJGrVhMtb1fhwJg9TgSuBwX5gcW-2hgQ-2vtyXaur0VR8yrtA>
    <xmx:ve7QaKApvFUTjcYv8LxTffxsGW0ep-tayNt8fr6F6TNe1rZdcBaXjQ>
    <xmx:v-7QaGQodd7zGczHNjLut5G5XMvTRVF9QOaKyyfnP7xgZ6JApudok0O7>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CD408700069; Mon, 22 Sep 2025 02:37:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AFFCV0QGVXfF
Date: Mon, 22 Sep 2025 08:37:29 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Xie Yuanbin" <xieyuanbin1@huawei.com>,
 "Russell King" <linux@armlinux.org.uk>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand" <david@redhat.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 "Russell King" <rmk+kernel@armlinux.org.uk>,
 "Ard Biesheuvel" <ardb@kernel.org>, "Nathan Chancellor" <nathan@kernel.org>,
 "Eric Biggers" <ebiggers@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Kees Cook" <kees@kernel.org>, "Dave Vasilevsky" <dave@vasilevsky.ca>,
 "Peter Zijlstra" <peterz@infradead.org>
Cc: "Will Deacon" <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
Message-Id: <727caa4f-5be5-4b59-a10e-8dc9bbc384bf@app.fastmail.com>
In-Reply-To: <20250922021453.3939-1-xieyuanbin1@huawei.com>
References: <20250922021453.3939-1-xieyuanbin1@huawei.com>
Subject: Re: [RFC PATCH 1/2] ARM: mm: support memory-failure
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 57551180003
X-Stat-Signature: apuykibt7fmoc4gncswdwapaqustfmm4
X-HE-Tag: 1758523073-551794
X-HE-Meta: U2FsdGVkX1+ETdPHxa3iK4ugyG6KBpp4BF9ocpAoI7lg3Xew0aRii0qmPQdHBLPYZBWu001BqzeFmxy6pGzRpdWUV8sNggweS9vs/DLb20Dc7ORGZX8EOzTWSDyWnNSe1NzBdwiTyGVZxbvb0O922h42kvzf+U5udai3i7/NShS3UOWtY2KkKi8ReuvZ+9Qp/pkGr6ojpZDKEoOEty5n01Kx8e4UkyX9myBAE8gcC96iIwsyzT4fRs0Ass5Ai7Lm5ECLvYdasShbrRKgwxvxXPT5mpjvmsG8aVLMjgaCxJBfUBtSja1YzuGjpmKLosppDnoP+GNcZhCypi8lPW5rmHTT8uaaaXCrpwUwU/d45jcX4kqd+Oy7quQmqxzcQs4pCABpzjcxweTedAuQ0PPMp2eeD11ldGJbKHoIKZEpo7EJKhdgB/WLnWUZ3Ls6hqIrZTzowriEGNYUymMPwFulIFseLid373Ji8kWkcQINWnwmfMNV3lf29qX3DJHCwBVhrP+9ovJnjwBgZ7ZVq7etcdEbfo54jfDADE7YXoQnqy4OHBnvthAufna8W7YWH1rfv118mYiYKsItZDqB6XO7VxMHLXzl1uV6noY0ZC5NimqfGUyDzuIkAjZNQWlOSkTmq923lqpaGo3/fn4ZvQSZSQwkkEm7LSecwIsYVEOWffjV08FSMXY1NNIN0a9dfn38lu/zKd84CSzpu7TGjBGqLSfvCD/ZUwWMxqgGMCsD6OcU5j2fRV1rzACBeWLJ1q4rbKq9ZYhb3k/7frpV9s3dc5kHKkSCDyyrhUJd3OI3XlxtqFBPx/3n64gcQiuavar+Ka2DkYa1hM80jTENXcPiFlSCVZBooP8TuiW56auJSRSlbSL9HyowHrJB/UyBQohGfp85a9eBV0jbgk+GIfR0TigCG9o9sB3axhHxTvAae79V2JfNHq2FWzjiM+x21xFTKHLpSa5sTmHP+8pPdvW
 b4wliZl/
 K3Ojwjjw9mAdWy2WhsTHkj7P9MBCmitxrqi7fVoNfVIysNg48qKGWgCHHbYuyFBzqD2VKJ++agCTL74i2suTNviUrbHGmaKlAI9b7wC6/5slHyIMHP+U0CKAwPK49rJuHBUEpW3k18g+lvwgl3MPvjVjIB5cvY+ypH7s880N132393JDED65f0ZMHzkQkuZI4mnBZPitTdcl8UDaYNkWQ+C7N2P+MYhG61lMMT/hg+4ymfmNQTOsAHef62dUHj9grPPTAjvIZoggY0Y6WC6epOZC/6sNOeGYIytuc5p+Ni22gyVTs7JhD+LO9mQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025, at 04:14, Xie Yuanbin wrote:
> Memory failure provides the ability of soft offline pages,
> which is very useful to handle the memory errors such as CE in ECC.
>
> Although ARM does not have a user interface like
> `/sys/devices/system/memory/soft_offline_page`, memory-failure still
> provides some exported func that can be used by some module ko driver.

It would be helpful to be more specific about what you
want to do with this.

Are you working on a driver that would actually make use of
the exported interface? I see only a very small number of
drivers that call memory_failure(), and none of them are
usable on Arm.

     Arnd

