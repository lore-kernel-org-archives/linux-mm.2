Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93169F34C5D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE746B0089; Mon, 13 Apr 2026 10:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F306B008A; Mon, 13 Apr 2026 10:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E556B0092; Mon, 13 Apr 2026 10:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8C976B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:45:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7806C56F4C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:45:27 +0000 (UTC)
X-FDA: 84653805894.13.252B98A
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4DFF420016
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:45:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=VAzPN0Q8;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="q ocQPWN";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776091525; a=rsa-sha256;
	cv=none;
	b=t0YkFXnRt33TMkqy5QhbURIuM3RxqSdyUrhN7gzgHEgx62RI9or6VlRi39d/66RvbIkbKx
	Ba0WrOqpJCnCbXPe4d35OtNURRXREYfFhTd4gxfOVVIM+aPsZGbuZ0vumib46pjGP6xlVD
	Cxy+SVW1/MGRsKRqxhnEccELgP2LCvk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=VAzPN0Q8;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="q ocQPWN";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.137 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776091525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+t/kQciCWPYQ9TuTtwE8ePqtDE4emYgbGk8M0JrxkM=;
	b=lLWCYezMczvCnLDEIoo6UTy+PXQeI0r1tvxI6zcefEzbupr0i7W+f3PDIzywsv4TWOHKUS
	IxRg8C1/iO7JPKpeeWVBG63q6fU1uT4Dgt49m9Ecw4pfPOFEoeXfpUY4Qxk552IP1kxOco
	ziYf5hqAX5gMACEXH1SLp3bS11PzXOI=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 63FD713004A2;
	Mon, 13 Apr 2026 10:45:23 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 13 Apr 2026 10:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776091523;
	 x=1776098723; bh=I+t/kQciCWPYQ9TuTtwE8ePqtDE4emYgbGk8M0JrxkM=; b=
	VAzPN0Q8M06ZrISBiijyTlSN7zZjXii1iyjsU0Nd55Go1hDvnVgLbRCBducupWL/
	I7xPJiEoPevkjLJ80mYbEW/a8BVGP+DZJqRCjUfrjm3tX4hey3YtL6Qx00JZuF8v
	WjI3i2GDGrKOX6lfMDr3NkI8PTwxLuJCiP0sOV4NGpZgf3fzkLLYGy+I5Zeauesx
	Pa7bVz5nZwM+gS/NQ9njvgK3O3s/OSp/mqYNiLR905iGGN0vAev7wD2BsAy/ZN5n
	HSi20BHM/ZKZ23MgIDcWnPLPjukDeFEfSjoTKa2sxYcORDHf2CMGKzIaSruFiqz+
	oZNoQZjdZwrcCPF2MdR51w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776091523; x=
	1776098723; bh=I+t/kQciCWPYQ9TuTtwE8ePqtDE4emYgbGk8M0JrxkM=; b=q
	ocQPWN5vz5eOrV7RW4YLt61EpInPDUzfRCh54wFp6y2Qkmlnv6ZW6xi1Aoq7RlzZ
	r6AxqNsae7V2QoCSPbuAl0ssOCnVNF+Nwe1zzee6gqmSKirEjbwPzN/lznn6IgkI
	jFNhpABUlOOZaUVrUhHeH/vSP+NehNFWpty8kiiS8k4XWDW1V04VNj0ojxWNDsG/
	IfeL1IDdAfa9wVDrNQg30BEe1ROTtYd65N72SkxvxptAHs7jfN3985PGHUPTFvJI
	wKmIau3hzR296XeSLQyJhwIMCCxcc2mnbgbKz8VUFGlqAJo5mE6KGja1OZI6dhmy
	PrqiKmwzjhsEhLvP09Hgg==
X-ME-Sender: <xms:ggHdaTXgJGelzz_lzrVxB1-qyO567-GVmNc01ydITgap5FTeQTDzsg>
    <xme:ggHdaWbojY5ZlN23wxAxRcQ_6Dhj9KvjWf-KNsyKBcK8W8C_Dp62np5kJfJ8b515H
    9E3UwX-YmVDxTygAoDQVAtNvx28yeQKuUCb0K1tX4I6jWCY1o3q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefkeehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeegkedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepthdrshgrihhlvghrsegrlhhumhhnihdrvghthhiirdgthhdprhgtph
    htthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohep
    lhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegurghvvghmse
    gurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrdhi
    ugdrrghupdhrtghpthhtoheprhihrggsihhnihhnrdgrrdgrsehgmhgrihhlrdgtohhmpd
    hrtghpthhtohepuhhrvgiikhhisehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggvlhhl
    vghrsehgmhigrdguvgdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprg
    hnrgdrohhrghdrrghu
X-ME-Proxy: <xmx:ggHdaWvF06daWzpSpjs739v0aJtN6iuik26sDQBaw3w5gAf8SR2C_A>
    <xmx:ggHdaZ9awg7nUXhN5OpyKRMUZCbM9osYFN5RNP6GaSqeakIU3Racag>
    <xmx:ggHdacmWL1YHAZe8ol6oPFOZFwQU0SOjOVhuke7wt-o0cNx1zs0O2w>
    <xmx:ggHdaXZVfqhFVoJvGmfQg_vToEFHdnDFmb_H9i_ab2aUXdlRPO64dg>
    <xmx:gwHdabAQPN9OqlO9_5-GhrI_SeY-FYfEJ9AFMKsVeX_HsRytcY0IapPu>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 88869700065; Mon, 13 Apr 2026 10:45:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: APG-r6FMkt-Z
Date: Mon, 13 Apr 2026 16:45:01 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Thomas Gleixner" <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, "Baolu Lu" <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev, "Michael Grzeschik" <m.grzeschik@pengutronix.de>,
 Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Bernie Thompson" <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "Marco Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>,
 kasan-dev@googlegroups.com, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Thomas Sailer" <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Richard Henderson" <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, "Russell King" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Huacai Chen" <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, "Dinh Nguyen" <dinguyen@kernel.org>,
 "Jonas Bonn" <jonas@southpole.se>,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
 "Helge Deller" <deller@gmx.de>, linux-parisc@vger.kernel.org,
 "Michael Ellerman" <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 "Paul Walmsley" <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Message-Id: <0166c8e1-b19a-44f8-aab6-f8f161c8542b@app.fastmail.com>
In-Reply-To: <20260410120320.163559629@kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120320.163559629@kernel.org>
Subject: Re: [patch 38/38] treewide: Remove asm/timex.h includes from generic code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6zfzbgbko634yaa699xtdwbjaq977cks
X-Rspamd-Queue-Id: 4DFF420016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776091525-350593
X-HE-Meta: U2FsdGVkX1+G+XdT2anv2qT3kXtHn3Lk3ZJ+fFfTWVbqHXpuo/JkBDjKbkcx5+E4GLumrF9L+ryio17BKQ0u09T4P4gyHHgLQQLcHnnVkcR9T5InfNqC11eezLP7Yzs9eKRS/BhROjFltz4YjrL87Wv7JjKmoRKrzoEfCkKoHJlaj7XcXyeutDaYY9azI9xty0bi2sn43Zz+W+zaLdEpUgtSBT1AGghFowZ1/QezueTmApA21D0Ui7tB3XiqbUrdeVDtajIcAn3PnH6h0RABtVt/4Wl193QaD3rLltBzzfRElA/uS53LsJaPgw1sl6bns1aKCqsZf57TuyawRtDWidfw08bSJhIdO7JC68dKzn9QB1SMOFAC7fLUMHYCPXrMe4xLYLoiejbrFaImkOSSTPWgsEE21qJVIdGzGfD8tRTFBoKUukIm+ABx0BXzlGReYdEV1s0nAv3juw49100jz6N0WbLlnMSQj3FnPz3ZT0YKltTtzpbUNJc6p8GLBNxsJ0sunSsVGTI/lYGZGuAd6zj933T4CrGQ3eyF47sC0iP0Oj9ttV3WVf3ab/9XkVjqjM/i5c6n8Eo1po0ww/2/ie0QD12jNi4Bkpe+uQoTzpGXG5UQNsvTA5aTmdaJ86sIY/O/9R2K8E1zM8LpnD0vMkXWOcK/pci/tPINC5onUgIbRiuwE4CK2ENBSol83emvWdkgU/sdu86MfMxTArJPZnah+sCmPiBBzilTvK2NHcwOJKNImKPuA/vgWtPpS01SIQXPZIdkXPWktFNnFDhJRCQTB9Ox/sZWtfVLAp05lR0nyz1+vdzR3EmIQXQpfvz+7QABpuWkZoppj9S4D8EFxVXRMTkBQal1ofp2p5NIPEoRJdYXSPGddgkWZiw9zhg7RM6OiwAqRfGwIt2WJCpfRvZz+58LrGYUOmhrYHaxTzvTQesIjdCc/1OsgY/JJ5/owgkVVvq+t89xvRpiJwB
 NsURSwBL
 dKo9KAErsGV6rm+StZMw87oSjGiKzwOvJZ2BntMPmjTd25wtnVGFclu9qd/Vk+AxmGFWT4Y5xImFCVbUJcysaN6zx4oFTAzTfoPNzYCMYYY4iiRx7iXepQAuBfgVQx2uvW3cbvyWD4rcsfygJFVI1OuBOrB0V9vAEGxEqeJKPSGIHSZFMBMNdLIe2Id+QUJU6t8fJN/cu6tyiEDL5mF7GRYbrK4oD9k2Cpvc9kFaBU9ZNxPg/DS29WfEj8QzVK0ZLZuObQY/Bz3wtYIWD7i64gNMCewJBjTVVZqlWbw75P8oe3c94YE3V+fEXo+YNvlHXD58DBT3bvRbrsl2do6zXkHWmFHoT2a1mhKFZSV5KiDu6kpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026, at 14:21, Thomas Gleixner wrote:
> asm/timex.h does not provide any functionality for non-architecture code
> anymore.
>
> Remove the asm-generic fallback and all references in include and source
> files along with the random_get_entropy() #ifdeffery in timex.h.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> ---
>  include/asm-generic/Kbuild  |    1 -
>  include/asm-generic/timex.h |   15 ---------------
>  include/linux/random.h      |    3 +++
>  include/linux/timex.h       |   26 --------------------------

Acked-by: Arnd Bergmann <arnd@arndb.de>

