Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB51CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0DF56B00AF; Wed,  3 Jun 2026 16:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4E96B00B0; Wed,  3 Jun 2026 16:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921DB6B00B1; Wed,  3 Jun 2026 16:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 849D36B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:21:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3DEAA140537
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:21:29 +0000 (UTC)
X-FDA: 84839721498.03.7AAF3EA
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf17.hostedemail.com (Postfix) with ESMTP id 31D2540004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:21:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=U77kNaiY;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Q EqQpWb";
	spf=pass (imf17.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780518087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wudPYMJbd9nBt6rRuFR7VGGHZ8OrCgWzbJU+a5+FDnY=;
	b=ZI5FEUh0BKzP4wMHef31QtiGtUYpUKK9FADpwvS/su327M1EaiGMQIjpEatng/6xwLB4f4
	0YItmMndbqOCa/rIjCOQdHeeZSQaJFVRK0govuCHr5E8A+qgfVBTg5UtsDEXaSGaWqLieK
	z6dF05cuforfx6vRX67DSkFTzdH0KII=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=U77kNaiY;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Q EqQpWb";
	spf=pass (imf17.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780518087;
	b=LzTSifrPG+rApHfaE9CN5sPuoZwImjlGor7iO1AgBvwzy+GHTZ6g9y+8uM3LMiTwaENP0j
	Rm7F0X1/8kIXGsHu9SaoKqtuWJFLmBcdnNFHrUOULkMyRa1FCfphcz3gjiIVqfLKuRsF/4
	gwYJPMHoOA9+qacGzGLuJ7NEo3e9qGg=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 82BC3EC0166;
	Wed,  3 Jun 2026 16:21:26 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Wed, 03 Jun 2026 16:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1780518086;
	 x=1780604486; bh=wudPYMJbd9nBt6rRuFR7VGGHZ8OrCgWzbJU+a5+FDnY=; b=
	U77kNaiYmbQGPI+nm8WKhb9YhiunrIuvPd+7P0JCjb8vLKlDoYHA7L10GOeRPHsD
	9RW0y9Dq7OOdLQ//R+cDqIrzCVSi09rzZhbGdPVUiwKvzHzym/oJQ2HMrNrwxU2l
	it1QDT3yi8E/n1FLy0GnVaqAZHwDxt02tXMJ2Mniz6ozMBqAGkQ7tlNifirnDznT
	AWIeXBhAcWD8zXLHyPRkXwe5GMY0pEzNj98pFqIo+x2p+cpm0U6NydF6h5+Zuew9
	pxtVNW6oXHHpsvR1K3cyvl+K/rcKmj8iFKhsbKmXOTjwj0b2h91Rndfdf+K+nicQ
	VOanQaYxhzcvUje2habo6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780518086; x=
	1780604486; bh=wudPYMJbd9nBt6rRuFR7VGGHZ8OrCgWzbJU+a5+FDnY=; b=Q
	EqQpWbpFEK1rJaRrZnCZx5BIWE4ivz/XAKzuJDVJt6FIwjng3+k7GqBksN3UNDe/
	h1Mt1zwBP90Z1S7ZnDvoTZMwq9WhlDhQ8wbo/MQcfL4TNfyU3b8joTlIwxFNkRxK
	HbEIsW4dHDZ1pk/f9Eih/zdQiuwp2v/rKVdHk7u64UTgvNariAVqo8IRhwjLF293
	zDowS/QEk7TOwz8mhCX5KAk7l1xQqllo+ZmjnCT2Y/vVor3zBAs4IpbZa3dgNki+
	aMGfgr2lEMBk6JJHU/5qVzMSC7IrZI1dqnpNWeeeB5YE3/YM9Mmc+rus7ymnkYI8
	fqGrWFSwmoJEYCjMTYPzQ==
X-ME-Sender: <xms:xYwgaqQQWEz2eyqXbYT5JyiReKj2foNFw8f3PT6VdWK_q3q0qwnMnw>
    <xme:xYwgaqlBMQtzy8_GsEqZLzcVe1I7nIbJD8ppx3X7XoO5hm6MQMcyX21VzT5meejJe
    NgUtq2ziUge8zFFDDmsxLp4xZUwd3yy-sHWcEZ9yIx4GUIYNIzMrGc>
X-ME-Proxy-Cause: dmFkZTFL6z0FwDH0tnBaPQzrLvCB0HBtzeQMJLRtaNsjlTM3blpdIH09zaegPEmKGxPbz4
    bUkFHahuzpzRIBkslrdk9vR2dVWlan306r18FirdADsote4p6CzKEhkHoANYGOW2fK/MRJ
    AZyhhuiBYrlF/XGpyCiRA/3xO0SI8PIT9+p03jwHzqiRjHnIzwPTadWIIqebi98cmDro6O
    X0S8MeMEZxylGdw9AsHVyyee3lRPBEbLIOZsd0UX9GEov4X4GwH4KPS8QQ4kjcjBAjlIqA
    h/Kn26tJHBoCsVTNvlWGLh8E5Y2jslftjYz86udXPzxM1v0AhDLwVnePmPG5silA2TeDV7
    YHzXjnIUmsirjPWoeNuWEdNXQjtgLnQTWgLrU+ldu0TeIVJ2+KFj4bEVoblAeIBARmsFNX
    UdjdlTNEkSh5+AYU493hhOmLVr2IqsffGxIxllZFxmpl/6nIJBLxZLOBbQRfE+A56LT83D
    cnqEQUN68PDdb0uXj/i3eDS/CKRNHu4IzrRxBdaLmUz3/8glCAlgi1rV9MzwVG3OCozNaS
    IxVsu3db8X86F/vOhyJT5WzejCmmq0vvWpejSa/gNGdS5IQtItJxKPj11x0/MvUwZbjZU6
    OO7y2jxRS/w/mzwQT5EMt/5lo2nmr+B2FPE+eWz1ghddFOs2LbAUX2pTbFgQ
X-ME-Proxy: <xmx:xYwgat8H6_XnkWGWDmGT2EDF85o3xfAnAS6EHUVYST64RBtYLT6E8w>
    <xmx:xYwgarAjpmUO0JYXXlhBntDz8tVMdHADwzhKdHi6Wor8JaFQX9zeDg>
    <xmx:xYwgaiQhg3jRSFQaIDNpABITYgAEa-hFFT1Hl0kSyhkGXOm5sIAojg>
    <xmx:xYwgaiuT-3OxahQ8j2RJHpXyDWgZ5Tjqb6oSVu-mdT_smQoKtruRpA>
    <xmx:xowgarhjwEK_h2DsUBOJU0fo3JWqyGtHBl_2CpnJKvYpfvWgNZ5deLn_>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B9197182007E; Wed,  3 Jun 2026 16:21:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AoYHDdqsMtKV
Date: Wed, 03 Jun 2026 22:21:05 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "kernel test robot" <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Linux Memory Management List" <linux-mm@kvack.org>,
 "Alexander Lobakin" <aleksander.lobakin@intel.com>,
 "Nathan Chancellor" <nathan@kernel.org>
Message-Id: <840bb432-ccae-4efe-93b2-be447834e6ce@app.fastmail.com>
In-Reply-To: <202606040044.XTS61C9j-lkp@intel.com>
References: <202606040044.XTS61C9j-lkp@intel.com>
Subject: Re: [linux-next:master 9857/10263] include/linux/property.h:226:undefined
 reference to `devm_clk_hw_register'
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 31D2540004
X-Stat-Signature: di3nfrn84rwahte85rbxn71tqmzsc3sc
X-Rspam-User: 
X-HE-Tag: 1780518087-298484
X-HE-Meta: U2FsdGVkX18EWkGmCivhBb0EFUVInLa8fWnJGwMJiHd+xyT3QLpUkzF9IAux778QECu3g5c1inhWCRk6XNHWM+rec6YK0Mk2yF7npCXOOjeVZmB+OQ2A/HkwPtVg2usNjj5HmmAvqF6HwOkDn+ei1Pu7P9tcUeVxcf82IsSCaA1gHagxvrrvgYqOxWG+Eq4IrWhv2c6Bz5TygPo0LZRwAjSpge6LOrSMSMxZUuq5R8HmDTPI1+0EFEUe0KCHnUjcXyuuvJ86XDA6YsjtLX8NVUg1qY3OK+7uA0vlfma4/sGOzmcCPTGlAVJYMx33td9PEuUZXR1DTi1THF4ZLN/Atz02I/YwKcqk0v3B9nHswiedxpdvjuGgeXaFcJ1drRiTgWfoDsVzFlpY/q68LAxrjjfAPlicy6yCYJfKxrAlnLAQ6/3ZebSeCt8RdgtpnRPvIwQyw06htMfz+qqlgSMcaKWSS9JTznsUb4n37Ns4HpemMUqSOzdjv9LFnIm9dnNqp2KR72MOCUWO1ySlBdL4OkKNAwGWU0nCVXmHUyf5bjI9tk3cWtKNDQF4UMnBfzobLEB/oAhg8ozlNNTvtkX3J52yGxUnceHewjKsEj6/pkyxZn407iH0yE/laPDAnVbWqzC+WW/By4Sytck/mhTRt8Q8LBsmFwk5+sEhzYcdE7lVH73XfGDgdwQNcebI0SGePDi8qQG3o505HZeFbeHpyTddXT4qHCiAbDYWaWwAlryLtFeM1zV33mK11b6WzzFmGTSxuDCJr6rVeoIohO2+E7bxwiPRhGHkVeFcNQaupzNdAbiB+tMCOgnwEsSqX9Nw6wZKBcaHC2mkMQCn7VdLOEd72cgsHs2CYSZ6l1iDMkTOlb5TZqecaOqdJ+3nKTBs++uz6FLWC0Ymc+ocw4YnN8CRDcAahntVd7X8pAeyZZ+aLXwYwK2YM6IUi8LiR31ThzdYzVAASlZ8ZkX400m
 8zhCRFV5
 tHiVqKzRx9k251+BKNzB0eZIszhBD8sORZZbKuz2ohMqUakJ2mc6TwmIfrhv1BXHhM51STxQWwHmYYqVbWHZvC1p+BrLD0PPBX0D6MSip6rF5DJHAbHH0J9XHDXsCWPheNR1AHUTsKw+IGY9QToeenDXSnIOThHEzoF8Hw6ijSFNaxetS2eXyNrMc8ZTbN3yBJyii3IIbN8Ygo75gFI5bkV8zo3oGnb5XVPI8/GDaTT5/+AjLkn5+moEG1URp0bs6cprrT27JOOOv9Qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026, at 18:58, kernel test robot wrote:
> FYI, the error/warning was bisected to this commit, please ignore it if 
> it's irrelevant.

It's not related to my fix, that one just got the build further
so it ran into the next error.

> commit: 0bf6bc1fe82a9307fa772e64c3adb89e98390f72 [9857/10263] err.h: 
> use __always_inline on all error pointer helpers
> config: sh-randconfig-001-20260603 

I would not expect sh randconfig to work normally

>    sh4-linux-ld: drivers/media/i2c/tc358746.o: in function `fwnode_handle_put':
>>> include/linux/property.h:226:(.text+0x1b04): undefined reference to `devm_clk_hw_register'

I'm pretty sure the oneline change would be the correct fix.
On most architectures, COMMON_CLK is set in (almost) all randconfig
builds, but on sh it is not, which makes it run into errors
that others don't see.

     Arnd

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 8f2ba4121586..1498473d4160 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1370,6 +1370,7 @@ config VIDEO_TC358743_CEC
 config VIDEO_TC358746
        tristate "Toshiba TC358746 parallel-CSI2 bridge"
        depends on VIDEO_DEV && PM && I2C
+       depends on COMMON_CLK
        select VIDEO_V4L2_SUBDEV_API
        select MEDIA_CONTROLLER
        select V4L2_FWNODE

