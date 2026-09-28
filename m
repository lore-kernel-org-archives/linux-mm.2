Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FE9CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 18:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3EC6B0088; Mon, 28 Sep 2026 14:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54FD6B008A; Mon, 28 Sep 2026 14:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BFB6B008C; Mon, 28 Sep 2026 14:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF2A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 14:17:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03FF11202C1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:17:03 +0000 (UTC)
X-FDA: 85263977568.24.E4DFBFD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id CBF22160007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:17:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jsqBP4rH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Cob2+ThX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DTqAC8Q/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="WQUk4VM/";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790619422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhzBhh+sX2UeU6n8oJoJHyQ8DgBeRZdBkkfTngNCVDs=;
	b=USAcc+5VTS6+R/G6IioEnORcQg1PXuPQ4YyXSuCdeTJ7AJYAfjb6TdLqliRG8mfWzjBufQ
	8EYudj6CjssQeyLdVOe9YoJjEcvbck/7rFd5SnZzuCrBDt6osxEMEwwfp+BdjtOI7uWAtx
	J//O+kVsf8SPMYou4H0+W6cCp7Wu0/Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jsqBP4rH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Cob2+ThX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DTqAC8Q/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="WQUk4VM/";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790619422;
	b=hiVU8iwjInvMxkvaLpYSQPNB2yH6qyTdSdgdFCttKSrR0pUuEeDbhnajxuZLMhmpwFB1kZ
	h81XnWMjrFQZFdQE3CW5UVAl0vCT8aYdifelVeTdi5Vf6J2hxVXtaRsExDg27gu5gzshbp
	AqrrGnfeyGQocSPS6n0ilKXHAFBgC14=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 06BE21F395;
	Mon, 28 Sep 2026 18:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790619416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QhzBhh+sX2UeU6n8oJoJHyQ8DgBeRZdBkkfTngNCVDs=;
	b=jsqBP4rHDOMeIL+ouVMQQ0LO8ZYp8yC6NJGupeIFv4UwiHU/bX11QSinYhG6AH4K1TMCpd
	AJL5likiRIyDJ00bu7yGw6sTjrQDQMfIFC6i2mXIH67SL58h6QWiBU3vT2EXIVWCJ4IfRf
	Wc0ITgoNtn2n6K2wy+vdU2uTkpUrA9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790619416;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QhzBhh+sX2UeU6n8oJoJHyQ8DgBeRZdBkkfTngNCVDs=;
	b=Cob2+ThX0ZnhUeavgoYaEdZ4fkPqAhpnFpLQkaFYZ/WsBXfOtgoYmK5iYukw0JuNpmteBM
	egk9vEOY4s91VFBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790619412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QhzBhh+sX2UeU6n8oJoJHyQ8DgBeRZdBkkfTngNCVDs=;
	b=DTqAC8Q/5I651HSgcOyPutAJHDFqAdHIqNueDifk3hAzlEx8yvJdoV+glaoS0LYqzGSh70
	egqInx7JMF/xpnJn0TZHnKLg2hKdJojbqIKRn0mBIm1TAx4z1cPi3H3vzC7dU7bbkliVsK
	glbkoX5KUj36ocwzx2mzFH3w/5JjgTI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790619412;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QhzBhh+sX2UeU6n8oJoJHyQ8DgBeRZdBkkfTngNCVDs=;
	b=WQUk4VM/WGEL3cU02YT2ORIz6Fe2zjOtlP5kI0ix/2Vw8prsay7hjX54RuJ/sh5GNZvxO2
	3uUjaZnwKRsSEGBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 418F8133F1;
	Mon, 28 Sep 2026 18:16:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IkdFAxKvumoMbAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 28 Sep 2026 18:16:50 +0000
Date: Mon, 28 Sep 2026 19:16:48 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, david@kernel.org, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, ljs@kernel.org, 
	broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v3 1/3] selftests: kselftest: avoid cd - in runner
Message-ID: <arqu1zdvMBXDziRX@pedro-suse.tail5790ac.ts.net>
References: <20260926010819.604346-1-thehajime@gmail.com>
 <20260926010819.604346-2-thehajime@gmail.com>
 <arqi6iwLDDBlk6Tm@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arqi6iwLDDBlk6Tm@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Action: no action
X-Stat-Signature: 1f1sswrkme4q7o3o7uw8skh6yw3pqnxe
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CBF22160007
X-HE-Tag: 1790619421-255997
X-HE-Meta: U2FsdGVkX185zw6dfQTATghKOGiPv84/TnoI8Hftk6ivyjG+4sB79N4IDKX0/2a3SNWO60R2GZm0WkNKUoNIRjAhb5XNCnTcVx10oUymvO5ftP5Vf40G7sTferMpesO+MBFF4iXQ3VvJkl3QypJemA8uNT0t1n+JUdz1XPMlyqthMbpZ512IJr5SVQw6dVzeYWAI7JaQRg8z2B/jqOIEPYTNlUX5zM142LP9tX4Veht7NGZfBEauZSJoBLNrYPBRcGgU4e7ZaihAWFWimhdkh/hMk2NUrPo4nStHyXrh0SNCD604MeqFObudP3S736o5McuYUXpSUH0585CwB5S4ZWinI1ReVjthp+zq7H/TM7ggl70sUx6KByI1tbkqV20bCulSvjAfhqDLTSl3O/+VnKO6O2NVrQjagM5OOYjS6tullltthe3xqAyH5Bu4DnqJaDd2N7MWBuHk/si/YFNXUw8a4FE63rWF0L38QsFGswosZUzW2TtZLMJSV4z5nIlfa8FSiEZXLDOpY6eU5MmJs1xne8msfNowSaj3Fgmee2OXRiAxf3dBaxrpdazRztt2mTfBzlADRdkUzUExMSF8dscRgfrALl+BEGZJxYo238CdZ8tcZ/PL02L2ioP6Rag2sJOCFbxvUVxfO/hqxCR0juywTaG1ttOKmn5hd0Ak06c2xLZFkW6ucr1Rd/WevTb2C9CJdaXxiz7E9iD0OVUF0cccj3a3SuY+sYR8k+t8WbLPuJr1TxWbY/vj/zXc/xMZMxeUNspMO+tTNEcXeYtX8XpTGoWGJHtd6QX/SW9H0BYXpI4sraOCw4YSfTxqhsUJwh+F6sQJj+q2po7g6sVYii5PX2vGe6k55K0x+QGH0l9xVw7pJVFjTqS9Q52v60tFjKx1y3cjdQZnkUPNmYS64CHAx3zRe3evMIFYPLJ906a3LLI2EJ105D/uwhIB1xbjwN+yHn5hnTAVe1qHwNL
 MK99CxuS
 4hiNcUyZa2bcDV1fNLj1cbKmxCqXMXQ07QhVHyqB+ifOHGbCYOVlk9nbgMy7s2EKLZtcKnG8xIr1qU1cahrXTOWkkrA+YkxagQzzCwfMh+Q1qlIrhI29rNg7e0+EcGMmJ1yLXrkmuAxPMuHOrnaMR6st8OWEKS6XAJTDmydoHVLb0R1QVET3XFoCqYmKjxruWoXeLevDvlZ0Plrg8stboJbQaRab3gdeXJzfy8TPFgvWJc2CloAtdgmmEwbtBpkSvqVV1vB47xmBbEEdDoAJNFF5M7hJKUql1GhTwJLkifjDFbUvbiuFlzC8c09XK24ZTT235KMQZtP3ZkkUVR1LznI0muVh9CpLMn7LrPAFHk946k0bkJADrVg3LyiL1or5j7hm1klJyouOIbPCGOkjhR45Pt96EsRAa8nI7kOY1rhbeM+tmJr1Q1helXkC1dHYc4zOxpGLBOeGIJ4BdgMD7JWgHuNyHklReIR8ycQKjq1DQ71sRzAm0t2Tq9fHyyiJaJxM8N00JNpyt899cp+fMtO4iRPaC5Z0VDd9aZjC/km85VmxwNKpu4DhU5up58i1mYuwtTiO4QwkSksH9VZV+i1XX+zzUchLi2sYeoO+naIrWVgm9QrjPjdVDRM5jKpEY2FVC0kXUbLUpPcEU+HN/BVoNpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 06:27:42PM +0100, Pedro Falcato wrote:
> On Sat, Sep 26, 2026 at 10:08:17AM +0900, Hajime Tazaki wrote:
> > The kselftest runner currently uses `cd -` to restore its working
> > directory after running a test.
> > 
> > This is not supported by the minimal BusyBox hush shell used by some
> > NOMMU targets. Store the original directory explicitly and restore it
> > with a quoted path instead.
> > 
> > This also avoids printing the directory change performed by `cd -` and
> > handles paths containing whitespace correctly.
> > 
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: Kees Cook <kees@kernel.org>
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: Will Drewry <wad@chromium.org>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Brendan Jackman <brendan.jackman@linux.dev>
> > Cc: Hangbin Liu <liuhangbin@gmail.com>
> > Cc: "Ricardo B. Marliere" <rbm@suse.com>
> > Cc: linux-kselftest@vger.kernel.org
> > Cc: linux-um@lists.infradead.org
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> 
> NACK.
> 
> https://pubs.opengroup.org/onlinepubs/009695099/utilities/cd.html
> 
> -
> When a hyphen is used as the operand, this shall be equivalent to the command:
> cd "$OLDPWD" && pwd
> 
> which changes to the previous working directory and then writes its name.
> 
> 
> If you're running selftests on !POSIX compliant shells, that's a
> you-issue. Fix the shell, or use something decent.

... I realize I was a bit too aggressive but seriously, lets not support
broken software, please?

-- 
Pedro

