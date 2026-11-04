Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A73606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=aj2d1zPw;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=v6mnL4cj
Received: by kanga.kvack.org (Postfix)
	id 753266B05B5; Wed,  4 Nov 2026 11:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B576B05B6; Wed,  4 Nov 2026 11:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641626B05B7; Wed,  4 Nov 2026 11:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B3C66B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:15:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2D21A07BD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:15:54 +0000 (UTC)
X-FDA: 85397937828.16.D38B9BF
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8AE3040002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:15:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=aj2d1zPw;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="v 6mnL4c";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.150 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793808952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8e/mss8HflpUPukSo1l7KMk+icGVWWwgbeYpf+2EZ0M=;
	b=JaLKG1ltPvjCZtLGhwHRbMhwsx9mDP8OWjAO962Z+TrDvf0d7GdSLekSNabtDcHZHwJE8t
	FdqCJPvA2N/HMmWtME8Ht3p/tiNM6Z+qIXFb4pd2XGg+E6YsWulu7UONPNhG41oz262tbP
	F5l3TWwzsqk7fGw5WMysPd7OhaIPOSQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=aj2d1zPw;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="v 6mnL4c";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.150 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793808952;
	b=kqBqWgabKAg3+3rnDj7VxtLxQ3cLVvm2DDyxyvJD2OIHy1oMyIIkb/Rh+ycvtle12WWRr7
	z2kNq+95u55Cd4f2ByPLSn0stJ1kIi0ZD2d0ZQM5H9k6XUHsLJFfzWBZqHJKJbGZgcK5bH
	nF78cZRLmx0N15EHrRSvhbc4IJikRiM=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 7C72A1D00034
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:15:51 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 04 Nov 2026 11:15:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793808947;
	 x=1793895347; bh=8e/mss8HflpUPukSo1l7KMk+icGVWWwgbeYpf+2EZ0M=; b=
	aj2d1zPw50QYcIlxC/Bxzi2+vTfvUHUMqEboPUsUsilu739JezLAKnLkiMvxO2fR
	sTbZEV1Z4/SC4JP7xL1iN/EpU6eWjLzTNNGAX5IlZgpQnbpj3XmJi92J/XeeIKRX
	NWRVqO+OED9hC3e7QD6o6vVbYhhzBUPtd6Qh6UEvmiL4c4RJQXEk+U7CbC4OV/gY
	RkhC3z9t5+jUaItWbz/G24RS7PPz3wHhLVSvfeVli4OlrTIabU0PY5SVaWu0aXa1
	XPNZ1DyCvcPhflONNE/QLHG0+fTCr0vvkPnBlDG7dAc/jAs/fU80K4yF38SOoLds
	QRdJL0T9Guz+R6yvhx3oZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793808947; x=
	1793895347; bh=8e/mss8HflpUPukSo1l7KMk+icGVWWwgbeYpf+2EZ0M=; b=v
	6mnL4cjqtKbQWST2Uyr6CLmgnnJXp0XPmBwOnxGlLSdFhHd247WLSSUCSJQC4d3O
	ylEOErFz8S7enBEEiXnjN28tajihe5SuxSKjIQXzlKMS2PobeKpTKFcx9ZRTI7Dg
	40JlkHF48F28sI8idrRf18tkTHx/AOQSXI/hmdKY8PmtSGzXjbeXpU3Yj/xLJtjN
	Kx3o7Nmoq/9iV+6W9XnESQ3lqysJIhEdIQgYCwcPUpdDmu5DrSs+M12rYHmz40HA
	xH5eWSDaTvYuAAtJsDfq4TEPUhA6a4oKmIODJ/sEH0ApW4y6isS28XoIvgddUPtP
	YW5nlhsFWd7bcJdAuJpnw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793808947; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:iF+vRNwLsQIENYHPTCESp5SibWW4JZLjW3z85Nv0IP0Ir5z
	CwXumeB6dYj2Vp0fNCT+jVGt/vuNFUw6B3se7tjmscCTZ61RF+yJtCgOq6xReZIo
	eQFpBkItj0ZNZp9b8CqqIU7NvPuY1q/fs6rTHxi/npz9Ij6wsxEcYCMIctZ7rD5k
	9RbPrIXTJ5URTxrQlzY2c0N7oeZK1qGPqxTLmRcWu9XHCs4KJWXeZaEnEfQY4v6Q
	+xvgp3Nle2SSA4iOI8ampLrUHyzwdOZyi06+A9zAyIdJoYv9LVwG3HTNq7VsXukn
	7QFUVjKQRD420yRMqK21jL4a0Wpaz5LtYS/8cRg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:4kPFI1pl94svt6FcJI7GTH40I8NrmwpOCYY09r/CUgI=:XtofUmLNSAlOeC+jHYzUkvhsqx26tdVnYTmf0pcPtXo=;
X-ME-Sender: <xms:MFrrap-1uafiamLHhvCFmcoS4CUnt4Bur8aaBT7rExtfg328FFqatw>
    <xme:MFrraogCYm9ARQueCpMSAm5L6Q8RIRSsoE7aCr_GJnTAoGg5JUuggYEjpjpPl75SN
    LYX6z-dG5QOhFYZngw6ymDok9GRsMc-K5FnkkT9lGFjSzDMFOxLNQg>
X-ME-Proxy-Cause: dmFkZTF81vXp6AjtNjpU9fMobsGT/c5iTkulkiDk5XSLgAmxn4T8gi5LrjTCSom++OOSJp
    S2tulKct1nDA+/4XskQ6V0zYzSSj4jJO9hqiWWuJfTvGas4k/fHo47PZRKoymKbR3PQgML
    2dTuv/53dVjIAqnKBA5IkbPhcmZf/oSRTxjvhPJ2gpIxG2dOBOSW4TxQwj5cWS14Knfquj
    K9ScKr/Bg+CXlr64X+IJQ/qM79dWbgPcAoxxCoq6KU+EVOAJ3N4tLM0yQMk9/hNa07GdMy
    59Nhj+ZBwUTZEH10vlXr+FFQrKeV7DXhD+xT3yKq3v5vVzj0mvPVmURRtfEXBOPWMN0trS
    ZF//I2WkPtCi3Qulh/5asCXoNTc8gRzqwkvujCOTyY4xORAFUMw9P7mPEzXCMXnkqK0Z4q
    sMNGUvmi1qFFW2M8afJio7TiobOd5/m2b1aeUZvufIiruyVNPVhqsmgPSHrvO1HJIT46AZ
    w8d1RK6CVYTkmH6sLW6UjCZOeuVxd9/XJpxR9NzVNguu2q8fUuTFZdL9Hm05FpqLTIJ1Y7
    460Kp475z4B+lqotzzthqkfj1zOo5Hy1QzvhJd1iSPwX6GXApUFZB4jxMs7o/iQsxHpDgO
    pXQ/gfnLMc3iEdzdm4nXUOTfdJNfkpc0PCQBJotvn/hoCGUO6nVGhHbTDu0Q
X-ME-Proxy: <xmx:MlrrapJ6W8L3Jsa2QGHNLYu_3Q5gPZkIcv347ZF-LLTQXzh1U0ilIg>
    <xmx:MlrrarLTrGTisFewbQlMo6yPl5XT83csYL-j1jODSVOOa-UmGOLy3Q>
    <xmx:Mlrrash3oDteop0DiCdnKUwlJ5SKHiqdKA8rzfP3tjhWNB6HjrTwrw>
    <xmx:MlrratPAwi1z_dXfsxwU0dawiR3Btr_9Hts7mrM1VN24OcWAyUHYvQ>
    <xmx:M1rrao3geqTf4E020kt9bow0G8d85W2NCqAnl3n-W2SlxB3ti3ygPajU>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5CB9832A0093; Wed,  4 Nov 2026 11:15:44 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AsZFqsyIu97-
Date: Wed, 04 Nov 2026 17:15:00 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Thorsten Blum" <blum@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Pratyush Yadav" <pratyush@kernel.org>, "Alexander Graf" <graf@amazon.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Changyuan Lyu" <changyuanl@google.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <6c67f712-fcdf-4d80-b212-5847ba57283d@app.fastmail.com>
In-Reply-To: <20261104160931.137174-3-blum@kernel.org>
References: <20261104160931.137174-3-blum@kernel.org>
Subject: Re: [PATCH] kho: Remove redundant 0x prefixes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8AE3040002
X-Stat-Signature: gxe4kjy7xekbij8czhtnizjaaunkysxz
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793808952-469554
X-HE-Meta: U2FsdGVkX18y6LMf2SbaWK+Tj4S8cgtKHIt7trUXAFtS41VmsNQbMNLTFcebdwv7TNhhbXZ9eMGdgZBhcINS6pSKurOctDOvCItHKEzMKIX1JYh1O1BEq9c23fRwDkmlvxcjHl2I/nCiW3X5TJ2Qa3JCdpHZ7r/soTCC0umotf/xYUnlD8R+xQv4sBL6NIh98dJGyLxzxWFwu3dAMDZh83pJU0DpmayAi2xLsb2RZjnSUNdPxJH7wpaz7mUfEtQAV4XuV9ViSR3NYqUaxZP2WobtGqomHsZ8jy89K2xb7x+qzesGyjeMQPq92Y7QzzZeJWwoCQoYHFwmgUvFwA5HH0gsQXwVhqIzQjwMUlnAGG8/aQtQTTC9nnilHhQW5eWGYYbwZB0ag2VzSYen2VkfrHHcy/pj5CbgqVygmuh8Zp3OrLN/s1vSQxpvhsB6+aBNguwpYifXYku0FW09p7de/6VQU/8JmQeXk0Q7jw4nKQskWAfQhRtoW4pDm94vf55zMSpK33gfsXb4qG/Wl5wo2saWnTOUwZln9y5dmX9FVBDDiDQpMnMwf6sdzl02MhibnCkM0mz5RyQi2k5weBrEqCqjlye8JNC7g2fKh1/bgun+97KSa76Uo2bhPlaII5Ui+f9RnpGLLlHZ3qrpcCJBFYNbgmL7vq/uVJ/GGvG5lYscObwVwSzASxn5o58f2sOb8TInHAeqltYi4wTLJ1b5n9RnIRyH5ybADF787/C3SZQjZmPCw+RjIo/T1NX9MfS+QvX+zy/FZG/8UtwAFtdzH7+LmqE5wS+mgCqRletsV83FZ1HdsXDdlw2mA36pjZbMDxDx3lXtTGoA4dkIqnm/S+6L/5IcsEi0a1A9JYeeE618oimhBJUxfiW4eegZstPm0mTBP3R8puitZf8StAD253zTkz+zakVWVmCeC/tFqxK3W7wcTIljMzEnhnRRZxF6nq47knEwdTxMygjp9Qe
 Bl3PYqz7
 NAKrqv3Y/ZyOw8bHoR4frTFec/VdX2Z7ahB4HgJ7eJBweKbD/RiSAEtxfC8V+4X0Kdc70J5ImBFrJEr3oajp8dH6h5I6S8HihpSDt/ryLGhiei9i6VW3vyyLyirO6v6Bn7dz/q2irJpmt9dYq83Wdx0DLR+r3xh0YmOeIT0RF/l30qOiPB/iqt/JgIjppoi86wB9bqWEm7vQ+imX7tKNEeJitUyTbEmBlRf0Bz2jiP6Fxcv02heuSfGmrQ+7EE3JP9PyX8wy9tP9J/BiRnRkI6b3O+1OleWALmjpgHN2rJ3Ra7BclMK5Ih4xvSpusa/gwZ+U5xoN1y0NV41YSWt4LyYXRmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026, at 17:09, Thorsten Blum wrote:
> The %pa format specifier already includes the 0x prefix. Remove the
> redundant prefixes to avoid printing 0x0x.
>
> Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
> Signed-off-by: Thorsten Blum <blum@kernel.org>

Hi Thorsten,

The change looks correct, but I see another problem in the same line:

>  		if (err) {
> -			pr_warn("failed to mark the bootmem region 0x%pa+0x%pa: %pe",
> +			pr_warn("failed to mark the bootmem region %pa+%pa: %pe",
>  				&area->addr, &size, ERR_PTR(err));

'size' is a 'u64', not a phys_addr_t, so the pr_warn will print the wrong
on some platforms. Can you change this to use 0x%llx instead, or change
the type of the temporary variable to phys_addr_t instead?

     Arnd

