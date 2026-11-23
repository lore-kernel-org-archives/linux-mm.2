Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992BC606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=O7AgBIDQ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=b/xkS61/
Received: by kanga.kvack.org (Postfix)
	id BB3C76B05B1; Mon, 23 Nov 2026 04:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84CC6B05B4; Mon, 23 Nov 2026 04:45:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73736B05B9; Mon, 23 Nov 2026 04:45:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86CF16B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:45:13 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 236D91A07FA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:45:13 +0000 (UTC)
X-FDA: 85465900506.18.75C4C97
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf09.hostedemail.com (Postfix) with ESMTP id D95AD140003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:45:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=O7AgBIDQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b /xkS61";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf09.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.151 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795427111;
	b=lM6tLnsA5Mvo/DcNcwVdeGvZeeF7OCufAHomiJbxXHXuQfw5Puz7g3LOm3HUxSYZl25Vww
	Ngf7XMrwP04+PRv0qGvlAvxnlCBOd9MTinEggxpRR+gozVVOGxYrFEa5seF4puxP6/focG
	tWS3jD+w5oR2WZ9GhaadBbGkClLckC4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795427111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jf6Sqoi3Qn0aJKe116rFzx97I+WLp3H4fMEI81ndjOw=;
	b=VtSyQUNQfwxoEnKhhXDXex8fU1MAHXp/tg7px2YkUpDs4jRacMr0+Isvj88WTyPY2eNv/r
	phgftGEHjAhurPbPfi2FUNiSN2KGgTRL2uhdAHwkMI1rYd2LRo0nBz+1cG8w/ftC2HbHKI
	oJBXtUg1AuqOdBf/GZGZqO4mJPpqOOY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=O7AgBIDQ;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b /xkS61";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf09.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.151 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 1B649EC0AC6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:45:10 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Mon, 23 Nov 2026 04:45:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795427107;
	 x=1795513507; bh=Jf6Sqoi3Qn0aJKe116rFzx97I+WLp3H4fMEI81ndjOw=; b=
	O7AgBIDQYiGEwcU13yBP7pD9SSA2LG3Y/2zfedNLAskwZiMNiVx/3YiRQCiif00L
	KR7wbkQkixoe73zVJ1Er/fxNvlv6oup5Qs7tIFLBQvXHlNf2Lls/CBhsRQAvANrx
	vUnwgy8YyeKjiP9KtWB5j4f+P5wk+IKDzKMPufgsh1nSdormzySXKWxUMBRzZLP4
	HbZufdcYy1Pd6Ly1p43LoHR+3Vb0Qwnx8PqLg6abpEKgj7bS8ALsGmKzkbvNFBXa
	MiwlM30/oy4VCzbP2D0Cn/RvckE2/6m1FYYRZEehucfMzUofj1hrRnSQadQl3L8k
	K8KcORqTkWAcvTDrUnGBuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795427107; x=
	1795513507; bh=Jf6Sqoi3Qn0aJKe116rFzx97I+WLp3H4fMEI81ndjOw=; b=b
	/xkS61/kMaSQuNIi8DG0o5vUJAH7d6Q1xIk97skI5kwzb7tPoAEfcUn2XJqOMww4
	uf8Sh9s1OXPn6LqvXUYfgtWz+icscUJeCIALVZo6TozAZu0w7OG8m6ae/YqfUECg
	k4juAs2ogTO8ctEgqAPm3vFT0ppNeEeqIgPHEcEBLM7hm3pLpXsXo5QUVdFEP1/S
	UkZh2vllQKqkeLfF4kPo9CKZj3Qe9PIXsR15BgQHdGjzXIRTIQBO6ZjEDE6EU8MP
	X6IKLwE7y81JcCGVdMF0ste0Er3Nm+tWTxhbFCV4yRSDgl3CK22qv3rqFc404Pic
	SmeAIHQMNgJ5z33uvvV5w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795427107; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:TlEY/U/tiddl+YZ1nEvLS2YSCC7Wr8ImgsrqFlnRoaK8JBr
	psE4f2G24nve6hRZ7ilX/vFN52S0OcVc8OFjWyAgZ4xe9rBS4ayE8xMv4yoi7Yar
	jFCqpcFYzBj8+Tj8VGMz4tzSTv9Dgx+eFmmJM/t+hsPLjiYQzSWFrlgHmwpvD1dT
	V3uLfjOG8H/SXy4hIL/19/WhFM0RvtbCAgpKhgNObDUz7yfy/POPPP3UUsfZgycX
	K8iBtjoVMvmGxoxvv6klyJbp4JOUUZz5BN9q6dtNe8N43lyG20wCMMBLiq5W/6YI
	5RwYWyy2XYFAY4m3jUFUWBSFeRTys/r13lyZJag==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:n6aZHqmDv56bF8XRSZatVJoaf2cIxLxzDgGBelOCUhY=:k9xBw4n1GQ1b94YYLMbzPhZvmLufZirlyqxW+aNOye4=;
X-ME-Sender: <xms:HgsEaxOhIy6VSqHjWAAc5S8_-r6-9swBvBxAZEerTD2O5jLd3ZgG0Q>
    <xme:HgsEa-x69Xr14wICuR1V3aldkqPMHk8AQ7qJe2NS-7QWty46aKqak2PekFIgToWpz
    PoRPYsUtqMhT7VkM1ce2MJx0QvsB3KlJ6zaH6kNqLo-5eQx8qKiXe0H>
X-ME-Proxy-Cause: dmFkZTFpjowEKf6THSkdHWlNfLsqi/vZ5GVMYQLFUxpmwMKx15Gn0GblHHreGqWlNSZRJ3
    6Stix52GCratCpj/7n/ateu49JFA5AjKZNwJ4R9VBgrMnT1kWC9uZL/57j7guCkzp/axZj
    7i8/C5KOfhgQ77XKEjot0lXHcH9w8HKqAMH3Sqehj7oZCfsAqKXpP+uFG+6U2gp4T7mAIb
    lPd5PSTOjznfw247G71MJjn0c6a6ZsMiXUIGFEjVlndXWZ8kMdo/fyAm2Icr8OU41WdOww
    82BaQor6puPLTTo8KDZD6rQ36OvbXVnyqY5z9bIpYMFPhmT2b04eSG2J/h9UtsImG7IdeO
    b9w35fi2So7GFHUgGGCEXxt5oRewJYy8gfT6oAfvi4NLlTPiFtaBawQqb9/9DoasICM2/w
    ffH5NjKuoyrFGXpYfuE+zqEYHhuPIItq0tr7E+LmfnS8/tixEooc1ShXYR6S8j14tfzbXp
    vzLQaphfQaLAl5/NnHlEV6SaEXsvOlJQWNvupyJHK6sIYHYYMIwHwgDnRF/ICBQvKO5/JH
    dPz6PlKvqNhJMc/zq9fkS/kxOD5L+5/9q7vlw+ymavddfSFaFBHsZ+E8RK4GE5ANtYShX5
    t2Q81Q/mVgdYPz2HP2pupFNyQEvOwqpN0/DPYeMPIyxKE8Px19JhQ9r8FMaw
X-ME-Proxy: <xmx:IAsEawGGTpdHb13lBvPvA-EMxmxgd-z86XmyBfAQKnW2yo2D4hi7hg>
    <xmx:IAsEa-PLkdycf7S3rOl8FXT72ZX879GL4GOYQl-HDahX_Sv_GlAI5Q>
    <xmx:IAsEaysK0ulq58o5gOXQVpwfq5yCaWkpgPWJ1er_z6kFjW2uDX6ikg>
    <xmx:IAsEazVFOMlr6GbbnLAYYQyoBUp3w7jHyHBXanRly9aDQskU-2q8Zg>
    <xmx:IwsEayan8b1DSh4GdNFijLjU6RL3T1AZo6Ww15949JvjYP7Bm8s6GjOk>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 32C9A32A0099; Mon, 23 Nov 2026 04:45:02 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AMjdjL9dYp0J
Date: Mon, 23 Nov 2026 10:44:40 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 "Kees Cook" <kees@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linux-Arch <linux-arch@vger.kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org,
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-alpha@vger.kernel.org, "Paul Walmsley" <pjw@kernel.org>,
 "Andy Chiu" <andybnac@gmail.com>, "Magnus Lindholm" <linmag7@gmail.com>
Message-Id: <ec5359c1-c16e-4177-8dfa-2ae5ab8a874f@app.fastmail.com>
In-Reply-To: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
Subject: Re: [PATCH v3 00/15] exec: Remove AT_VECTOR_SIZE_ARCH from UAPI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D95AD140003
X-Stat-Signature: 7pbi4i6j8jbq8xcteai6ewwwahgch71i
X-HE-Tag: 1795427110-676598
X-HE-Meta: U2FsdGVkX18TAts27DGZbydeHmzOEkZhNrbSu5kSnfrJsCD3nVeeb7nEXrPijHVEO2f1QJLXOpAyLLecm90ix8jO1sScvXEZ50ilfnYwzaOXcw3MB1trTQAEhWYwCNa0x3hgbttgseMiaiDYZO+5hzIOs5afYfRBsRxBsN40hiq7wb0TK3l3qyZxsaqRzGMQAe/2gqp8ULvcyc+CPStR4kUH/xCs3Hag+xiNRE3loyfclDmUDI4QNZFF3t/UrEyYZUuKooqh0B99ZVL3xCaOlILZjTSWUEivoV+SDAvLT5heQasoIDkJWK3b2NzSitKPPsTJ1gO9bt3tPYGWWS0ERqTD6chlc8T8Sey+Vr3RSqCgfACIgZl6Q8MRaRBhX2+c4jJztTSdrdaqUAH8KqASOyR8hktmO6vexIDFJWJvs7iQ1lDRKFw9T0Si4nmbz8rrkqCfSQ7eCTDcwODNPcVWD2qTJd3prcQ2TbZtN32Pz6hXNICBJZ+k/JlzHUIqnUdQkIWFSfoBbJIRQODkTnmjjL8SgmSXGatu7otmMg9iZ3jiz3I+dls09aMj63RZzEo02ffFw6QE87sf3xThrC6GzW80I2kMohxOA9nb6TcxIdAKTLHprjjn+QWzds9164M04TjJe17aNHj5EGY5k9VTp4rYm3bNwREYHBRoFFv6O2h5hk5hNDQQtHlNgjHvJ64GBcWSsS8i8XAMXOpfCJkkrir7rnNIV8B2yN4jwuACfF69Xna6hdgWUYkPePbNLz/VnJg4H4YvRdtGdcIkMQrXfTOa2PN0C5l0sq4sNP7wsAsCImBTGtMSlguMW9JAmoMYrabonUSj+srXGtfgG1HqlmUPbRX8v4miu72KZ3Q+waWQnBOzxbO/YmTgDggxilM7lW4nOuEWB9GRv2bnjkUC6BABFYBcaWlqKu8ZODMJbvFcw2muTg2+tQZAazbW1FluBWqNbh3GlWUKMgO+iLq
 YHZpbtjj
 RNYqbPR0y9OVReO21nMdSgBpoYaGo5o8cBcTHy565Xl9KwIuSSKXBqGBjkS2zOCkg4IgZJEMgOSlGiu9WbvcArHNDou/fH663ggtAlA3GonLmIRomwcS1+mU3fNI4tuYF8R6skrdc3JevTuiVI5Km+DupoNnZo5N/L5WWemdMraATWMB/UuGOrz5nlkCISUcqFHv25ByviS7xFznnRKkgA7S+z64aFFn7ZKhg3rYfE510F9Z7ehleQd5IDWCdvDV3+CKm5kohU0Y7DuoyCYRbALT8IgraouCrHz5ha87jlBSckACRvkPfY7SjElfc03hqBIf07eI28gZ8QmD6+NI3M//jwu3p24WdrL/lf+of0ld1rxRfUqHjFsqBhlxHeRBDXIMOUks5jxVM1QaDO4j5RQahdXWnf3KrhFw5HplfU92II0Zh9vyL9KYMe3vTFueFtp9WIBkTJ27wTNXiBvBhfcOFszifyGx00tIRWNk2hWDqJW9NljVXACxKbCSQszo/AnX6UMQxnRFYGSvPZisxdwTftBfay8WMQMFnHEHoqZ6ztyRfdlLIHlNJUlGZ4d6k1NorFRAXpdSIbU1pxPRF00yY2NuCiK3H35yBn76h6OO6rzTkHyMDtRnPcCrvLbzsEvUaYrc2rpNfJcljbC9rMf311w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026, at 10:37, Thomas Wei=C3=9Fschuh wrote:
> There is nothing userspace can do with this value. In the kernel is
> always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
> userspace and also changes from time to time.
>
> Move the symbol to kernel-internal headers.
>
> Meant to be applied through the asm-generic or execve tree.
> The default recipient list was huge. I trimmed it to only the
> architecture lists.
>
> Signed-off-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>

Hi Thomas,

I'm happy to take this through the asm-generic tree. I've already
made sure it all applies and the patches look good to me. I'd
wait a few more days for additional Ack or any other replies,
let me know once you think I should apply this version.

       Arnd

