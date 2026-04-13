Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA39DEBFD38
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC1B6B0092; Mon, 13 Apr 2026 07:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D436B0093; Mon, 13 Apr 2026 07:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8C006B0096; Mon, 13 Apr 2026 07:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA9556B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:15:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7499C14014B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:15:33 +0000 (UTC)
X-FDA: 84653276946.03.681A8B6
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C77212000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:15:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=BetPAMrh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Y OXcQKc";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.155 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776078931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTmL49YPBteRUcWblilZINYX2pjzGZzY0ltnNRpdVYU=;
	b=tkGcuFZJhdEVlDDvn965pdoaKBKlKSv3ysTVdYs0dnrwsVbeGdwnDWR9r2SXtgYF+Ns2JF
	vSSqC41209DEZxgKJyGgLw8gsKtPxOdvM5olXFi3Y8otLZf75OMHusWk7yUMq0WV2zR4Uf
	r3HvTaH6jBEZEvqtpRmo4NmGqrixywI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776078931; a=rsa-sha256;
	cv=none;
	b=CrfS2RkBEZx5HCdNtpTPeg/XqSqiwdFMqVfxh52aRn4j1T9xDK64Hd/sjjnL5D9RxWjJw4
	kntrtbwCxI2xuLVDu6A8e8vLw4xcgg2HmHcQ6qVc+sy63VIXc4ztfSDG0VPqcyu5OhqWp3
	3MMSoatziKuK8qtz/UCCYy7oxQSIYWI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=BetPAMrh;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Y OXcQKc";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.155 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id ABC14140017B;
	Mon, 13 Apr 2026 07:15:30 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 13 Apr 2026 07:15:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776078930;
	 x=1776165330; bh=eTmL49YPBteRUcWblilZINYX2pjzGZzY0ltnNRpdVYU=; b=
	BetPAMrh3TokbMEGjLXdAbvoda+xYNVb7jptloq6qf3qRxz85vzdHcORtEe8TXuP
	dOV1MuYz9F4OX1S+K2yf80a9wZuLzFf7+e5jUjjNBoB33TIZmS/VyTipvbHlPQSz
	5tVPVNwxOR7A52NoSBqrhSxqWSV05bpZC0NGdqEpInk63dWvXViCn06/JOQP36p7
	4x7IHw7PQwleI52ytJcWug2sXxrp8h9qalAWX3JQ5GxNlGanUzjEBFfuseuJEVn7
	OjW/9WWlfUdYC2iRFumbKaYZkfjjnrS34dNf9/R9AoAKJ6kcIx+7j/aERfxMqz2F
	kx8bcLPnV0Dks0mv0amp3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776078930; x=
	1776165330; bh=eTmL49YPBteRUcWblilZINYX2pjzGZzY0ltnNRpdVYU=; b=Y
	OXcQKcEX5tEk/wZEX8dbk21JFtetmgNCSyO5WlxHSRND3TtCzAkJ4ZsSonf2/HcA
	KfGMWqi1kJWsWR+4Z5yQL52U3+kpbgOrfjiD/Vtk2kFccDPY+j5BCEHXxSnc9FAR
	JZ2nqhKSREwSFyHvBcjfk7nfqzulatPjJp/lAACgl2ryiGrYoo544XKnYipG4uAE
	mpXz9ZDevpUZnhOzveJSqEa3YzpkAiTZTdIpfBN1M9bdyRYTtvVpX/rkU2gGJAd7
	99zQtiPydzQMu5APaYTAoWom4vXuhDo9pbsCIGREtmQAQfsdW9KfIdBRHDpfxfd5
	GA7dV1rSy11emnqRAZSZg==
X-ME-Sender: <xms:UtDcaYZ9Lj7eUioEjYGAs_F4D-XDMonTm9KEwN29pS75MLp2k0fztw>
    <xme:UtDcaeOpqAWqWH5l9iimHatP93rKoI6x2GWYVl3svuNrZebzA5kBemlq7fKZKa029
    P5PhPdtxFAJ4QqpFg04wSEk6pJIC-veFe5QSJSMQh4Qw_-4ZiZJLf0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefkedtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugi
    dqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepuggrlhhirghssehlihgstgdrohhr
    ghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpd
    hrtghpthhtohepghhlrghusghithiisehphhihshhikhdrfhhuqdgsvghrlhhinhdruggv
    pdhrtghpthhtohephihsrghtohesuhhsvghrshdrshhouhhrtggvfhhorhhgvgdrjhhppd
    hrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqshhhsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:UtDcaTVhNnohniEpWSmvnWRVT09fC4MbQYw3OKQQKbx5Gkbst2Xo4A>
    <xmx:UtDcaQi35YRxdd-eBug821sMGAnmxA88IjiZgna8jp7APSUWbAL0iw>
    <xmx:UtDcaTpOICXGGe_7nFcnIuqavX2tXVzmrsTHz_qaGl9462ioCB6FHA>
    <xmx:UtDcaeEgI1CA0ozWy8pYv6A3rwt8FqUQLFIqW94AzMx98eegKhAoOw>
    <xmx:UtDcaV160YJtqTh9toAPDrp88_47LlPOCEB-oJpt0rD1QzX6hJHfAxMf>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9C449700069; Mon, 13 Apr 2026 07:15:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: Ax9AE_gslVNw
Date: Mon, 13 Apr 2026 13:14:49 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Mike Rapoport" <rppt@kernel.org>, linux-sh@vger.kernel.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>,
 "Rich Felker" <dalias@libc.org>,
 "Yoshinori Sato" <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Message-Id: <42a4c6c1-762f-449f-9d14-3eb0fa02b94f@app.fastmail.com>
In-Reply-To: <20260413104649.852228-1-rppt@kernel.org>
References: <20260413104649.852228-1-rppt@kernel.org>
Subject: Re: [PATCH 00/10] sh: remove NUMA and SPARSEMEM support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5C77212000D
X-Stat-Signature: m7fdnnk3bb6yer9kc3hxrhydu8ugumfm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776078931-653036
X-HE-Meta: U2FsdGVkX1+vC1Gp83JC9CvfUrN5r8AilF9OLnnEYt5bmHPW/TuMs+Ft57ICCeAdFjpvcu1ib/fB9VSYa6mYPLTUpixUp+aUco2LxJb5oZ64XBzKM+L+pdyASgs1VeqS8A1A6pSR5/CmytmvPW5TWrLfakNth4sT5Sr25wc8Hj1+uplXavkXl+BaZAUEzxix3n65LUtC/TbFfnU12fGuPMsWXRftbYnM6ZizidJaN3Sq6yjXYKAT2LLq7n3I/LEoy6fzFw1R+R6Ki/MsaB4OT/A6VxDwNzkhjz5mPP4w8wVo5B7GPLPqavPWlgWxHSIyjzipnarxFFrhV5aNJnhD5FLKKzcX2RHnvY89d7fsm2E3m2q46V4Mof5x83OxQA7eudMeSr5sm9yHnz3QYXl7YT5HXkz/k+uXPvGAAN9uYaUM6WfOZdI4OrIbdU/09XXozS4SYyOnFbd4Uq29Ocl5FarwJ9kEgCE3HclqmRvu2ksaFmDx0jmHWNf0qNAmo9HAekSsL+uSiWyRD0oiUeoST+u+M9H5UXpGUgjEYMOeAcqWxnjrpNozoRNw1Jea0FeierQED1hWZsHXwMUQV3zU5KLLqd40LkAuLimwiPT1SK/UsVJa7crnYhYlb2+3IzGnnopzSWngZ6CaSnPhL/oIUE2BGrie4gZl4haolQ+rbIA0W+sj/bKh+s8aztkt0IJ5Rhz8JFk+giDcyIChpOkAlaSJ0lAKZmy92VNW5V378aN4W1mqKnP6V8FQd4ookuVrNWmxjzxQGmAuWZ18w5NsdVETMcdt94lwg7Qwc5L8B2N6gsZyesoN8XOAojvBQ0CZZl0Qmhk6HUDsEOuhFweTeISJNA18c81tbJLyDRkCYd9xFApGJ6MRT6Y/R4C9nhRhfzeyqEwun4ynTx0BQIH0UNISWnSoykFyMHHRGITNLdI+vWTxfO89yjkfCdSnr5J87Xr2I3CMjTcUV6M6ks8
 gORVEKMh
 X2LU80DUJFLWE/bHhOrM0nvUO5kJwoZ4uLYNTad2Q2v7iVstUqjp0A//TVvp26OxeYkH0/3BrTuY/tuUw9SqFT2JlNI55ohAHDw2pHG0MRXsIFnVstJs6umrDV0IaBFb6b8j13aJR9qoGmBIvJcvJB4394QR31c22ymUceno/QMRFqB9TLEt0aJ3WgpmILLu/FwvTZaeLoy0sn6X3oDEs9XtEtfEFXtzV0vY4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026, at 12:46, Mike Rapoport wrote:
>
> NUMA support for SuperH was introduced a long time ago by commit
> b241cb0c885e ("sh: Support for multiple nodes.")
>
> 	"... for boards with many different memory blocks that are
> 	 otherwise unused (SH7722/SH7785 URAM and so forth)"
>
> In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
> shx3 at the expense of all the NUMA related code in the kernel.
>
> For build of v7.0-rc7 with defconfig and the same configuration with
> CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k. Disabling
> CONFIG_SPARSMEM on top increases the difference to ~94k. And that's only
> overhead in code and static data that does not take into the account data
> structures allocated at run time.
>
> And all this overhead has been there for nothing for almost 8 years
> because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM")
> those additional "nodes" could not be used by the core MM because the
> maximal pfn for ZONE_NORMAL was cut out at the end of the normal memory.

I had looked at it when you asked me about it last year, and I can
confirm that agree with all your findings and the resulting patches.

Whole series

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Two very minor points:

* It looks like you left the 'config SYS_SUPPORTS_NUMA' symbol
  in Kconfig, which no longer does anything, so this should probably
  be removed in patch 9 along with the lines that select it.

* It appears that after your series, RISC-V is the only remaining
  architecture that supports NUMA in 32-bit mode, which I think
  we should not allow as a configuration, given that this would
  run into untested code and no hardware exists for it.
  Apparently commit 4f0e8eef772e ("riscv: Add numa support for
  riscv64 platform") intended this to only be for 64-bit targets
  but did not add a Kconfig dependency for CONFIG_64BIT (or
  CONFIG_SMP, which was added later).

        Arnd

