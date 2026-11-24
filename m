Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C40606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=PVorD37Z;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=UtwWEvoZ
Received: by kanga.kvack.org (Postfix)
	id EC1806B0729; Tue, 24 Nov 2026 09:20:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98E66B072B; Tue, 24 Nov 2026 09:20:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87C06B072C; Tue, 24 Nov 2026 09:20:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A86106B0729
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:20:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29CEA40BDA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:20:51 +0000 (UTC)
X-FDA: 85470223902.26.5607758
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf16.hostedemail.com (Postfix) with ESMTP id D50D3180012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:20:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=PVorD37Z;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="U twWEvo";
	spf=pass (imf16.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.152 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795530049;
	b=YYjtrOlI23VqlxnRu5LdMkQ40S/t6EYBfPQLnJ6aVS8vIF0znpEQSzI499Ssm9tYaS0VEP
	SVsaEdy8gVVVmXhhRMnPB8qkFK34iZy35bYJupvM456ENrFc/0gYUF8vFdKrEawiDAxReS
	KJ73LUBZLKev93b9TK4pZ7bnU0DxrBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795530049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3j6+1vDkkUdepekjgVOAW7Wo6iXb2x00XUTpjNkTgk=;
	b=6prr1QZ1mv86bE8NTNXajnlKW17rvz5zHZGx2M+w4U4Bns3a4wUKoVClXkq2xYvYc+aP2F
	qJVDoqvAhkpnZAkQS4DQZ1BpbuUKtymSRPRbDp2j4BPbdvw6Df9VClAe+5X/BPncyGLA4K
	MRQOdCGKo92OGZCcMxUkzCpAFNIYKvc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=PVorD37Z;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="U twWEvo";
	spf=pass (imf16.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.152 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1624314002FC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:20:48 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 09:20:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795530047;
	 x=1795616447; bh=u3j6+1vDkkUdepekjgVOAW7Wo6iXb2x00XUTpjNkTgk=; b=
	PVorD37Z9jDNNC1k6/oiHqSM9Vf6vAHLVrm073XtVk2Sqijo6xNw1XCQ74urOwyU
	wp32RSngykH2l0sDAh2UeJQ/0NqUEJ0cSg2UiTmsikF7UxKL0FDGs54oGa/uKUR/
	Y5HCPegh230snV9Oe6SsSD0k/vP77CspXv9Kcj0/1rKXCWu6X8QK+sdN8FDt5B9V
	B4aVxaDPKqXsjV7HtNdaeYBjoNmaJGZw0u04abomRKWieufOV1PL7rXmCmrDB/xW
	9Ltg7R30nDDMXYz7Ay1Ju38Egdi8kFVJFF19IGZkriACuav3qGT/9Iacb8qfOBuo
	pGMp+1s9iCq7Klb9lHrCyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795530047; x=
	1795616447; bh=u3j6+1vDkkUdepekjgVOAW7Wo6iXb2x00XUTpjNkTgk=; b=U
	twWEvoZRg5cdcif8ONh/tL3K+fVsXGM2+q1a2BkmIZ4q2edlu5335tSuhRjETho1
	/jgu+dstWjejJTtO1W/dn0UgmzlVnSFzBMntGGNYZ+4rJS26X/x0PnVSsf8kH9OQ
	Br/okPX4lzQcGusHYKPJVBf54q8QkRDLPKot7zSIU0dQcy2qpHqWtAD56SFZMgXM
	5Qr1iqNyakiw1VwjEOKycG1yxLjBGj7JnzPZkO9WB8dL8MIOeQKJoGlMv7SlbBOT
	FHrDzvFcu6TotkHxHzxbd9TvcjVy0m8dvXI/y52rmlnul1r5g9mgIoRKZDr0tQv7
	qaslpR8HS3W9rRhYb5e7Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795530047; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:NCx25rJAMo+ykk5ah/lFIJLdOcJvBauZgByKZ1psUH9nqG2
	NCYBgIDwGvLYXOC72R7Bvps1yY1k4LpTbV2I/TH5+N9qJICsTjHE4V76LNeMJn72
	vMzrzsutgVfwm8Z4RPQpVi61gFvFMlKfyCQ91xvonP5iy+ycCvYIyM6jSCaDC3Mz
	zjEt6T7/yA3idtJVXuf87qinBuPY4gIUiUClmfhvC8XZT/rf6qB6k/s3Vg6MQ2Wi
	pLhmBGgeQ82M0sG3cBDWkTC1WUGKQ1DsqYdsFXYZgyv+mwP96Ez0lk+7UaG8wJ3J
	UBoU+0/VGkNIzBiGr3j2XIZrAXvHJFcL6PKDtTg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:QWI2uJx9uKHNEkI5ArHbcx6fT0KmIPMlK1h+9jS7NII=:1r9tw/j/3peIDWcTRzPnQcmEJg6r6Mi5hMfjZtJnzRU=;
X-ME-Sender: <xms:O50Fa4H5xcml6H14agoXxF_92vPFDiJwsMdeCK35Mhc8jWjY2vwySg>
    <xme:O50Fa8L174MX3mda9fHYCSd24ThdkkBuj_YqyfUXradE-itBeqF1bAmEvjlEk5jR_
    z8AnK8IKZ0PNsfjPgI_vSaTlCqL7x0bNwFODdxLV5CjbYk2xelLP_E>
X-ME-Proxy-Cause: dmFkZTEzcLHzUbygVSoohLJKupEtfEaADKNynBPP+A79ygbUcaBEdyY3/dAANqKmhrkblO
    Jrae/KV3GLY+RywD9rqxWs2jej9mhDb2TWInKeQNn+yEiA4oO7214aCWGh1pWRuSHLG4lz
    TdoLSFYKLGnO5oj5ojEc5oqP6D1a7M2XWTfL1XsEmO58G94E7SVDAZz/i6TAwTuQMjP1/F
    5TPW0GY754A7e2ys/CGoidT/VBp7upqptqyunqjvfPBeie53CuSfAlSGwR8bN5F1FaHKno
    AL0ThjRjo5RR2bV/aqsZJpIOYawl2HGcD5gns0fAQQl7C8bRBC9pk5vmzfbmO4suSI0JLC
    Lpnyz46cCf9anYpgPOg04vL5NcAu6B+CbaR2p64ylCE9OtchHxU2/sFYPcab5dF9SQic1T
    BtTBN/n3FXbeW+YhdOtF2TiqcVWW+UCyKEwYNr0+0wID7jJERGyGaBXfVxI6mN4AgiYtE2
    JVmX/mSt4BfYY9CVVhhTpiBQDd1fQ4eIcmYyJAqYjSizSp5IOLOxbulU+HP7chDG4+IgQx
    tLfqzihdnyFfP/VLwltW+V7URcNCtlCG7nXuYoJ37Nl2M7LxoSQSNJMUHDFEjvJ6qhcJM4
    aLxrpi/j53kJgPy7MYlmKNBhlU8/wRwzhf4dPLTZksm211Bypt/ItkogSTYw
X-ME-Proxy: <xmx:PJ0Fa7oXw8zeiTB6BEkz_IJr2ffUf9voVAf6yWLsKISNXdWNaYrCYQ>
    <xmx:PJ0Fa3NziNSlPzrCjYnUdLQrWercCpl38axITNNSqTwnWDtmvi-lDQ>
    <xmx:PJ0Fa3cQYYQmZXBYGTHLHk9XzsuScY7a3-S3oPDnnjeV1DXc1ZsURA>
    <xmx:PJ0Fa1W-0RzqLaNULftEzcNXQaRtqI2WYpcneTTueorUeu18kw4qMQ>
    <xmx:P50Fa9OGGACUrFWX6Voa9pbaKsrtI08gEVmULLqFPTSsI5WRDzPWvBMs>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id E4BE132A009E; Tue, 24 Nov 2026 09:20:42 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: A-w96cgpwkaV
Date: Tue, 24 Nov 2026 15:20:22 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: sashiko-reviews@lists.linux.dev, "Kees Cook" <kees@kernel.org>,
 linux-mm@kvack.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>
Message-Id: <5de01709-19e6-4664-b91e-7cf35b843d77@app.fastmail.com>
In-Reply-To: 
 <20261124145907-12f830e3-70ab-4e58-a330-2fa974be1a25@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
 <20261123-at-vector-size-arch-v3-3-d342dae9e843@linutronix.de>
 <sashiko-outbox-230870@kernel.org>
 <20261124145907-12f830e3-70ab-4e58-a330-2fa974be1a25@linutronix.de>
Subject: Re: [PATCH v3 03/15] asm-generic: add an in-kernel auxvec.h header
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D50D3180012
X-Stat-Signature: ihxnabuubb9o7epmisdchse9rr5s9dys
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795530048-498260
X-HE-Meta: U2FsdGVkX1/LteA40P4YxECfM2iS+NIam6wiHP0LqJbVbNOH5p+T6MZLYSng6IAOot7Bz1MCq93AgmFsWQ6nBChW4rLPG0LKB9Cy2M9uanz2/dxONcup8hB3rVxut6WyGHVSldGpOl/OavItGrfnOiyIaBBwuyvWzluDH3E0Vkna3wtLphf7w3zNtl76ERR9UN1FTTF6xJ6FVvigUDMv+qgnu3jXFn9yvzM6hSr5weOETeqSZcIEkTvAcwZf+xeGM5FoOds1dN74KnDsQjJPTuxwDaQCid7ISG9YtLoijvAWWI7snVIZd3bLNmvWfyQjzLleMDkIdS3+dX4Q6AFtx45UdMSWndPIxqfRuE1ATGG2JpFYadiv5t9VVemIFcp8v+Y7tBJEmD4aIlxGkX0oO2MrETbjb9AnrdHiH0T9GlHTliQ3Geb3oWlECGdfGCWo/b1vFNmTfiwLfwwA/2BmMhrZnd8o2PAzldiP+LgqJd/OcQO8RqaGhCq3pAHh0gMdBvr+1z+jmQQq/be4Wz0azyynCaBbgzOBNbtl1v+7oKu3dBpk8LRsKGtKBvLLpC6Bat9jItXdVp+XtybynyzNU0/hf8uL3Ay/oM1rhTAsZXhTmv6OmA6h6nE4ETwThnVGYZxCchPRjMtkO4X5ZWoy/7k3t75mraEQ4qQ0cPp6TvTdIMTXkJjdpbWtDLQhvLqyW6+2mYAQY3OpyuLZJNzTh5woywlvdPUE1ilJKR4BT8PT0oThlmb7cEdOdk4UCrt9Ce1qedRZSaD2XFwIGr9MU8+XGTiZ9su1kjN73HL1qp+RoQyTRsFzEH9CNpGIafgVVYGR/TbD+zjDZOK89hASrgJSKFjbGKfP4UBPPaJpWFGScJAo6OKkPbxVquSle8cX9I+X3cprnGg77tYx9B+ToAnEVSYz8v/30Mia4rHsTI3898ustgdKVVmsNOg6OIHvf6yEsi5EyEXSmqBaxBO
 RGqDyH/1
 zR1SlP+qLwCCjssroxNffQl9rHD5lFbz8jYUlCrt29b9lIKhY9sx3ORuPD0vGXDmhS1MhT3gDSk7RsLBY6STdgYjludiY0zOSbmbexbAz1iKuk1XE+ROZAGmxUnmgpOgn0pLvpV7EhYcAEFgYy3pI4oMfEs8rhRVAeh1+Lcd3ruVFngKz47T9/jq2+riDzy8IXfTrTLUNN+14Ev6+8PgUak2g8Oetv5efVLYOqE/RSOhtgiO+nJWpx6Rm+HXxpACQdc6hqNJ2t4Czp/92ewWLH10biJF41mc3Wm1/HlfHXRygttMelcT+Zl8Q2gEd5gC0CtT/6qd0GZZwsFPCVaXqTKGjCTRRr3MfOjVrMyu6sdhU9MjPDbNk8GbtDjcERY7nZ9g6gjQP8cKt/7uQJJi0ZNOy2C1+ePKzUkyeKSrb26luIgYMqnEjItinVJUgT8i8zVkFZHrxDPafbUiBqrcg7t0w0AD+CpXFRp6fOxJ5xUmMVRmvskcNQTk+bqlJGpnot8YhNVWEOWcWKbYMV1gCX6rWjUSPnhlKJoa/UzREi5INzICqviZiJVpgVdtlru2AlABthjSD0qhLD0BZ4DECbM93Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026, at 15:03, Thomas Wei=C3=9Fschuh wrote:
> On Tue, Nov 24, 2026 at 09:49:24AM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential
>> issue to consider:
>> - [High] asm-generic: auxvec.h unconditionally redefines
>>   AT_VECTOR_SIZE_ARCH to 0
>
> This is indeed an issue. Not sure, how I missed this, especially as I =
thought
> to have sent this through 0day.
>
> @Arnd: Could you drop the patches?
>
> I'll prepare a fixed version, probably for the next cycle.

Ok, done,

     Arnd

