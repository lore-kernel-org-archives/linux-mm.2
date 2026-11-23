Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F82606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=cPLj8Yt9;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=hC6LIkJb
Received: by kanga.kvack.org (Postfix)
	id 53F966B05C2; Mon, 23 Nov 2026 09:17:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516406B05C3; Mon, 23 Nov 2026 09:17:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE2A6B05C4; Mon, 23 Nov 2026 09:17:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 169786B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:17:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 819581408BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:17:17 +0000 (UTC)
X-FDA: 85466586114.22.EB0735C
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf03.hostedemail.com (Postfix) with ESMTP id 46B2A20014
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:17:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=cPLj8Yt9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h C6LIkJ";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.148 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443435;
	b=1EJNbQkPJR5sEiREDx1yz0oEKlx/gvtp+tfqCnMF3WjsH/z2+VVmi7b3SR464F3n99bq58
	LEgZZ3TN4VkssV4UFtuGQUjSIMIXRml8uPYGPm+W7+M7M7Alu2E9mATghjtT0YOBuC9tJ1
	4K+Et5PcWu/L0dOaiWU/m7MFOQYA3yQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHJ91NJtNYQ6/J6+FaRGzznho5yPOY/r3tuo2Sshg1o=;
	b=6vTmFzf0mzo6q0Jcdw2d7ejIa9Kb3id6cZR3Xn0IVNflQ46dXX7iLxSBiL/bbos9wuCbWn
	OwL/eYPhAaq7RZ12nFuttjCne/Fb/MhMUYk50vWmKK2e4MwDbBUaRYAfCWFCiTYWcpqLCw
	xomKNncXHqyBZODOogeZ+cMNqXL1Q3A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=cPLj8Yt9;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h C6LIkJ";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.148 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 672B5EC0B7D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:17:14 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Mon, 23 Nov 2026 09:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795443431;
	 x=1795529831; bh=BHJ91NJtNYQ6/J6+FaRGzznho5yPOY/r3tuo2Sshg1o=; b=
	cPLj8Yt9KDzFT9oOBUn+/GuSsf5mynsPFU3peaGSzzjdcM3xPq2nCeDkNchhwU0y
	agEnTSgyBbGQ/yirLqdAtbec6K/eMPAPx84L678ABrYcb+wpXySl2GHRp4LB9WLN
	CFo2ebu58MUl9iNZ9Ieq9B5w0n8KUsPK5DwUz9m8y9EZ7/GezgGomuFh9mdki4r/
	+BIiXtKtzOGG5D+kuw3mpodMWyr20zPfOAhpC9pxJqrf1XcU6K399GtXsEQMc/8R
	39qj2UCf7kgamdATa+Pl6YH54Dj6cd0VQx4T8GjJ0eSyaIyzVoR7OVUL9GzpK8m7
	+ruoO3v7zMRO6WezXgniMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795443431; x=
	1795529831; bh=BHJ91NJtNYQ6/J6+FaRGzznho5yPOY/r3tuo2Sshg1o=; b=h
	C6LIkJbKj92f5S7k/JXfyeaid1Af9ZzNDUOfhQPFxJP9BRVK8CoFu3txAUBGFSdE
	kDtEOIgPiZzvlCZbCv4YLx/KipUoHlpFtABBaFDzTO/Eo99zurKqUHK11ZRFH3nk
	zrK7lUHYw/5sxSK66fxI2EBGUdhZg116RSbILC1OuB62zbnw2sD4sW3+a4PBWhw+
	vIkMNp+LX1SFD5zMvRTmes4VjgpqWOOFse8Womzu4lb2d/5udJ8V95DWmA0O1EvJ
	RGzmtn81sr/9oZLy7H3BztHTIli/UeDdJz4S0o8+2QlJ2kzB0w3ffJ58MILv/tOp
	VBsPDLa1+OUIFoA4NwwtQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795443431; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:iEqAUWz7qxnbFuMCKcmhRsGvrtI1+pJSb82V2yTWerXMQOD
	4PC6n2vCDdyrHFGIeY+ZUhzMFGAm46qWs7LtNPFVpEI+svguee1XZDhyd+42eHRv
	p7+WnSQlqloSjoZIptoygMH6Em8/skj26OO9Dm1FlwkAfIFqVI4O6QuZWgQnPw6x
	in0HmhvBVCV6ictacurWldUKgPYqp7YflUekiMMnJ4JpNxhATRKkLHTnW+PrNxDc
	H5CBrLEiVNUXeXHcldx05boYP34hl/KVWFd2FuJB48ubrCqfoMgG3+YJ3mwLxLBc
	8iU2E39l9h7UdRjZ1iXh8V4kyKcxfN8+tqDyaYA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Sap56MIkcyZT8r4cYNPG+lEt8q7zj6cm/hR6DX/YHXU=:rDsMBjpfa65jK66igtyHf1M93PmlfJObl6/94lUiVSI=;
X-ME-Sender: <xms:4koEa8b6jWHk9Km-gWsvkjXKBe9FOycLSAoQHdX1x28WgylltvrlXg>
    <xme:4koEayN-2NZ5tuVMTv_F6M4wNcDyjmgtjmjdAzvHywIA7KHMufFQZrYw4q170T5Th
    fPdBGfTNlodLlNUN9knmz7mxDJr9FP9Hc2uPOv3pg8T14AiyewMGhM>
X-ME-Proxy-Cause: dmFkZTGFrwq2MF5SSuOMe3naqs9tbtMAmc3XEG2p+PrgD+xfiVSS77ldCceRFMgHOXXvSL
    Ging+R6VT6K3yz4OUeCdmIETXjNj7XXI0r9Tg2543OHjiuaKhMh+yVJAoB6OkAWbwGP/U3
    JowxnSxhNhDyTsBNjiM7LlqkLGWpphbuTeJ0WjErvJ9KhK0fJtLolaHFC6Kw2talXF2YGF
    JN7yWyVcYnsY66wGn8uoBc1Op9fn/HtafFpC/Ha3Z7ng5ziTGTERGiQYQq5K4ZdS/5JuDE
    HH1gfdWjYiM0bW96wZfgClnWGF2XIAu99qwAHGam6Iwuv/kahBWnYmwWVFrVPNzzZ/ahP5
    U1UkBFU5ZxOctbFZFvYR87OCQ9D85IrFkHXF9AU7aFYWG6vLW8lI9uDg5E561v2/5hKHQA
    sjQFn5A8NcDFUKKIz/Gj2N6XcZVOTlbQkDMhl7pFKmJR0nTwtc/ea8J3ozLffLR/0wUUbB
    iamGkspUsbgem4niF9wBtKb8Aybdc10XaTbLUSATly8dgGeAoj4vWgf2FM9ltEDrHvDjNY
    51emBC5k6bV+SyYpJacMFkokFxMkxKPk9r+T99bzSjJsfdRVRAC/r+2KM3FJJSK6C1f8wW
    I+V82FhA+/RpOowStt3CO/53UAvaoCC1+Mr9HKqAkD73+MJL10fMk/SelFXQ
X-ME-Proxy: <xmx:5UoEa7zTEzd5mDVuAJ0khzXfAhl-NnyAwD2CijXl1cunNEN88JhvqQ>
    <xmx:5UoEa4LmzfnQ4K0KUaYuA7sCKQ4bXebQmmhpsTBdhtm50HSfa0pUZw>
    <xmx:5UoEa9456MjeyYgj744opH-waU6skY_xuQzxaCDvT7bwukaslpL8Pw>
    <xmx:5UoEa2xmieeiTKUZnDvuF-Yhydil8f6ZkK_qEXx5P2wofodg1yRZbQ>
    <xmx:50oEa5l_6AC-8c6ZgGJR10cedMu4FgnH1XmeVBS7jPfPPs2PoWN-CFom>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6EB4832A009C; Mon, 23 Nov 2026 09:17:06 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AMjdjL9dYp0J
Date: Mon, 23 Nov 2026 15:16:41 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: "Kees Cook" <kees@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org,
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-alpha@vger.kernel.org, "Paul Walmsley" <pjw@kernel.org>,
 "Andy Chiu" <andybnac@gmail.com>, "Magnus Lindholm" <linmag7@gmail.com>
Message-Id: <b7b8e8cd-d0ba-4e37-93f3-0fa209207124@app.fastmail.com>
In-Reply-To: 
 <20261123110111-6431e85f-39a4-427e-b545-2e7a590a6c19@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
 <ec5359c1-c16e-4177-8dfa-2ae5ab8a874f@app.fastmail.com>
 <20261123110111-6431e85f-39a4-427e-b545-2e7a590a6c19@linutronix.de>
Subject: Re: [PATCH v3 00/15] exec: Remove AT_VECTOR_SIZE_ARCH from UAPI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46B2A20014
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wiqjenk31zh418n8hjinnwk578dkyg8w
X-Rspam-User:
X-HE-Tag: 1795443435-999659
X-HE-Meta: U2FsdGVkX18Kp+An6j0p1dR3Kkfgsl/39Lq3JfKqSUT3AY98FHn5Rvd8etJbMpXYFbaxPLsZ0CXpcrDKaWXW1WeM0TSxoXwk/dmw6zbY1ArPtPWqEFn/kS31usrsCOxV/+xcVAr+QrYYjmUbE/0T4lp+CtrgNNJ16Qou+dBkqEzfeEuBihbqtiLD3uIfkjRkb/TZIYdpanoW/fmN9viZQrOnhUPvcChc+Z+qYj4LNT9FSShUxj5p3nyVacqC+iz7uGaC8VYahTAUfkYxYJRuX8AMcVhMHHA4/AqdgEx6arXz8nTGxk14pzy+IojPWKFLI1symp0HWHkQksrbYaIT8stBscWYf5ec8C6V/cZWZxVWftqqxQv1/FH6QfjorIv3aRVibj3vfphW3/ERq3Lp8JJ3DDssdr54EAIn3AkK8FnPbin/ewdV1RLQfqtmuXmgeqQnEVygMj5g/GmTiTmt5fm7k9MdfJWIXg8uBDtRrsJGi72LTM2QlBiWYF8NzDJCqjhfmn5Ikz3AX+pxmnuLVN1mpZdZN14YV7j4ACk0ShN6bLisDNTW1JAbJwt5Vk0Mj000Q0CtQ+jM/MZN068xI5DmoyDQBunYDoUFsLWg5+SZGpzIyLHyOtmD2C6DEaxhqw3otxb2Z5/Q3OOT76WQRkO3uCXN+kb3x2rx7nBVc3S17BxIgp8qzcwQM3br15oWv+51CjRo+frV0W4dsKfnbmRGUHIz388HipOINnQFs4+4dpU98ITFl75rktM7zP4Cfh+MK6D//ie4Y6C06D1+LnkTykVS8X2kI4iRslrgv9WjPMy/8E6eD7ijUislwSOy919DA6vKwlp0XdpX8EdVAQJKGkOpZJ4PiCU4LlAzBHgGa9TsAKyqlkowoqX2sNRLKf0NEAuVe1aXl+dC8GeTCy/k3BbMFB3nFLR4SVQJyF/4hqoG7CSPbm7+3BVnMT73WkqDp45ggh8zCru8gOH
 NBXEfwL1
 Lx6CmGCspDe3LxpCN6DGP0SGw/w6q10DMJZ6c5x7f0VDYi3G92gals/fQtTO3Tq8CsPxcENC0xhxqlpQxvexPnXI4zhtSoPe3gGK910o0x7nYvRAIRRkjR9Ne3WxMj1jTywRZt/ijBeqpRHrIB9iK74FgkMrF0sYNzILJNr76T8JFgB7TgZWV8eYkhgUMfnAyu5S326UFrWnK/o/zjYOyJOx1An3ucgfdzEZkklGu+Wb8blu7Elw4Q5vUKAUnYfxD8NWzKl2vtMsggb+ZFEWBD20QLZ3xOdwtKt4Aqz9l3fwjRH2czrJxFskL1JcAp1pTYLyvtHEuEzEV6cpclsgD8AFqmDbUSAe/SYQb4MIQNKalQUBe4MI57OrAWE9rbhJs4gNJfLhi8Lm70ugSY429SzudpxIwkzWE1ctKAKnkB16dLBh+5+F5ykZg9kPhj2P1StCiDF3tAz+j1RYUZLQWTsuphdnmSw7YxnteSs/9zUGb3xqNEA3z7lLv+PRnLjpvQBf48Mc/4Ul3SBJ0jff1HC3b6DweNqC77bKJflD42KmFcRYZfIWl1QTX3Qh2mAr4g05k/wg5cORJ52tBPU+cGc6SHpxy+yhlKpmqssLra9DGoMNDNAmNlDufcUW5yMs96P+KJwk7C+jzOI51PG/EYATuvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026, at 11:03, Thomas Wei=C3=9Fschuh wrote:
> On Mon, Nov 23, 2026 at 10:44:40AM +0100, Arnd Bergmann wrote:
>> On Mon, Nov 23, 2026, at 10:37, Thomas Wei=C3=9Fschuh wrote:
>> > There is nothing userspace can do with this value. In the kernel is
>> > always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
>> > userspace and also changes from time to time.
>> >
>> > Move the symbol to kernel-internal headers.
>> >
>> > Meant to be applied through the asm-generic or execve tree.
>> > The default recipient list was huge. I trimmed it to only the
>> > architecture lists.
>> >
>> > Signed-off-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.=
de>
>>=20
>> Hi Thomas,
>>=20
>> I'm happy to take this through the asm-generic tree. I've already
>> made sure it all applies and the patches look good to me. I'd
>> wait a few more days for additional Ack or any other replies,
>> let me know once you think I should apply this version.
>
> This v3 is functionally identical to v1 and v2 which have been on the
> list of a long time. I am not sure how much more feedback will come.
> IMO it can already be applied to gain more exposure in -next.

Fair enough, pushed out to the asm-generic tree now.

     Arnd

