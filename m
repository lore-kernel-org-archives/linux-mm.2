Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04AF606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=KIfB01Wb;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=gz9YzrZN
Received: by kanga.kvack.org (Postfix)
	id 3DAC66B07B7; Tue, 24 Nov 2026 11:30:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364CD6B07B9; Tue, 24 Nov 2026 11:30:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252C46B07BA; Tue, 24 Nov 2026 11:30:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E63086B07B7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:30:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 704DC80C23
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:31 +0000 (UTC)
X-FDA: 85470550662.15.0147673
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DDBC100014
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=KIfB01Wb;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g z9YzrZ";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.155 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795537829;
	b=nuAiNdiVj/RM8JmMxZJfT+9VztAqfEGHrz9XYZDkKHyatyYDa/JKWwK7sZDxzJnFHzsi0v
	B/NnN57+un+jHMjVsvoEAbeBGJcfjonLhDpWWtJ3/HhQozKFI9O21HlwXi0obYfiNqfdet
	LMuFXs35FZy+qqQ9yzFGW9qmeF+FHbw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795537829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTbz0+BpeE85Uf+P9q0EUbXcqUPW14MouI7LDRHs9Gc=;
	b=Jy3OfiM5uCvd+LQ4BQtfnMOqooTbJpq39SjAM/SYgcbg6JMOJwlWVMH0wsldPYgb6klBkR
	FpfLXjWkLnMeVl9f8d6xQFwugQOqLknJ5JJ8GuDHon9Ej90TVd7NUBZDVCIyxftOlfPLJJ
	CW8rrNe/R1CAkfs/+XmVvTrKBE50mb0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=KIfB01Wb;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g z9YzrZ";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.155 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5199C14002ED
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:30:28 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 11:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795537822;
	 x=1795624222; bh=CTbz0+BpeE85Uf+P9q0EUbXcqUPW14MouI7LDRHs9Gc=; b=
	KIfB01WbbT60QouGgqoyFMo0Dm0qwHukr3dP4zcXigfjqZgWbd1DKTJKgRuYAlUb
	FDwJmQIXcEjJYHCjCFAufhUYCkzz7R/rQEeQf1qAKyHUYTHAsPPFTIzcbkEnJ7Eo
	Fxed4Gq2a9TL+ZGD8HIbQIag3u6sM2YmaLN+Pt0XvLlJexhOh3ALXqiqgSpCRiiL
	qGXt6Vvja2zUGf3Qsy7zqJei6WMA/G7V6Vpav27dI42Jl1E4tuxs5VHr5tIQrtWy
	T2Gu0+c+GDw22RzdTHVwDfgPCJL1eR/nFuF8vVQI5YJRssVIOs43MtymzpksgB5M
	xJEcqU9CCnrkMjFyHurNkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795537822; x=
	1795624222; bh=CTbz0+BpeE85Uf+P9q0EUbXcqUPW14MouI7LDRHs9Gc=; b=g
	z9YzrZNNVpmUMo/p2AHRytByCoSNgNktBxJxVzSNCDLwFhR1QczCELoRbMvcQnZp
	+/cPxVwXmFf17ip6K9oYyc176gZ2bjKgYbnyzcLgNTpnvXxiW6umKS2K75/toKGg
	N5jt/LGmAMnB9tHIiZAptvis3blCGrLbhtBAqKVfJF9rFme1hV5VaCq6RaXeV4E2
	MllBvYqxZLoAWioRdV9imMZyHOmGMEkhkqtAg2zCD4YDPdD1ZB0/BAfNcpWyFdcE
	F8tQHF3bFeK/vZs+ogcyvNHxCjaeQPTO+Bjtz/+1h1Zcgl3XsEt0h9EckTiO1mRo
	k8u+Rvbmilmwao9EmgSKw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795537822; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:mfLmPKGquFjf8+da46vqcUxrfsA5hLoMRUCdz61YyaPh4dt
	f0r8YaxXIFcG9dHchIWQgl8JRhhyXOT4lenDE/f0vDVmuGXBMpPmcNNRW4EKuwHL
	mtiZWVYf+JWTlgojQr2REdu8NPcybzD/Th7iuIl7rDw3hamlLVVEVMIqcgEQsnr3
	XE5HKUyLp7sINAuSVy5as0HQUEqFICp0GY0lk7OhnCcvLn1xc+KgopmC9sRwa81h
	tBRenbeQZH70LMkD1ZIfyMttQsjqGlNZGS1fjAawd20IlMlcNwcWyALwPLTPddwa
	OxDLoKye/La4vm6yiu80e1UYGmhT/v+yWtqjvEg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:980aYwIJKINX/gz4l3IUqsZXhOnrDZYIdrLIPyVIuzU=:rSduc7uGIjYvoyk/9XoJLPSt+QxsoryMmuCdSICNC+8=;
X-ME-Sender: <xms:mLsFa0OZcgz8AQcROZxAwwF05_XyiwK3zgbMLTOaUHwSW3LN8NAMVw>
    <xme:mLsFa1xH0IFO2d1nIyeMXxlpxOsZOLv6L9Z59doZwdIqqVTYKhWUvgPwoxQ9vAAra
    Q2FssVPyr2IUzhSRtzDjokU2Brb2cRQMHngaXOZ84fFdV_z9QnZvdk>
X-ME-Proxy-Cause: dmFkZTFfM29LN9oi+uls4uA7bJ82R2voNMmneloS9Yl8C82woxnJ9InPeuZsT75rjx2f/c
    2S2JVkvyRmwb5Uqq+KHHSX28pU/OSqqhUU2HZPLL9FJxrEffux4ZOs4sbjeS0Gutr6dgSe
    9u91JVLr9ePCvPxHnG2Vx/y42SYkBfF0FRgHgzaDRgv0Hp5C9UgVUY3PEDzsq0RJd73yzl
    Fe9dojY9h/SLyOfS19e18yixMp4zKHwYHkc74bA9F7mD6D3D7YQasxuKXHnUiiKIe8otv7
    qq6Tp+f/OwC8NFGFQO2Uw5MAYlnkSZPdo7VcOnYh/JYMF9F8UXSmFcs318U95styRaVpWf
    2g9aVDRlXsY2lpadbqWJpAz95It6i/7IVu9SMgPfkHY1Geu9IjfXMOTptCgQZXXEL+f2cP
    nkzAfTc+8XfQnftNWBA8Wb+BRRpzWigPnbCkKxOfHJ9MTHIM3chUTU4L49QjqICWBh6a5j
    ngD/St/DVG5TP23SfwImEHI+5pDYsUmwZYPF3sxyNlg66ZcyYQGCLNftBS6FI3FlgcaAK5
    wy9e9Ig/1u3Kp55vZ0LPwPJbNVPanVj7huTxI1BetZ6M3LCsNh6mN/VD7Sqjd/4cnQFNAF
    u7mvZ+y4n1Hv/paIpEFyEItxD1oktJiEZiLqADw3BK/Cc+DxD8lLH6x3XAyg
X-ME-Proxy: <xmx:m7sFa8aFDhAs5k9zrApnb1of7AOg3oVh7WG6YTjexPO0GwFJ8RBHgA>
    <xmx:m7sFazWYKzK2u0jN4XLUbc6Ed8i-PV4g72xM5vZC48uZ8uDtcKiqMA>
    <xmx:m7sFa9EIDZHiNxMfx5-dzWOX7PCfpsJVeq2rxasJ6a8TILjXSGme4g>
    <xmx:m7sFa9BfyvlW6v2H8o8fb-Bx_u8eaZ4Z10q4cZq6NdK1V14gclr_0Q>
    <xmx:nrsFawCeCB3BEnLU8xQ4H3_Z1Dzvu3HuPYdvUauWcGwGdlhSrLMsaArt>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 885AC32A0099; Tue, 24 Nov 2026 11:30:16 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: Aq77c9iO0VUs
Date: Tue, 24 Nov 2026 17:29:56 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nikolay Borisov" <nik.borisov@suse.com>, x86@kernel.org
Cc: "Michal Hocko" <mhocko@suse.com>, "Kirill A. Shutemov" <kas@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Dan Williams" <dan.j.williams@intel.com>,
 "Kees Cook" <kees@kernel.org>, "Ingo Molnar" <mingo@kernel.org>,
 "Vishal Annapurve" <vannapurve@google.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Naveen N Rao" <naveen@kernel.org>
Message-Id: <c6ad8f8e-9dc8-4fdb-968e-107795e2e15f@app.fastmail.com>
In-Reply-To: <20261124160025.738362-2-nik.borisov@suse.com>
References: <20261124160025.738362-2-nik.borisov@suse.com>
Subject: Re: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential guests
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: smc3qg6fqi948zg8g3pp87skdzt8n813
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1DDBC100014
X-Rspamd-Server: rspam03
X-HE-Tag: 1795537828-138059
X-HE-Meta: U2FsdGVkX1/tWkS1vzAFT3JGkkcUUoTMMWQZik+DzhTZBi+zlsWruxigRtlEC7koCf2EEa/sfQWhQygE471OK+SsvuWnmpRQ/xggl5zmhLUf7/0jqmvgq3ge+U1ddAYoqeq4uU6yfVyQeVZsF8OGnraJaAhFiQAVOCMQCMjNVYgtwznR5PWNUzmkq1dtsdboCosmiVy+FeVZzpWFMkMpaYucPNgugYeUBpJYpxcrNDa2N7LGHNwE+t43WM3Yg5riXEFhJ1qodKBgyeG49aqEYQMZCz52wc81koBTTIgvpdV7mkU0ZxkDLvYtRtXqJt8ESk9p6Jjr+zzHjsZPYXadyO1P65xoKPbHT/qY/7VYAbKXo0pVJKBg1JmyXmMqILqXt82ncryUdSN1VWcgMLKGrZaoxvtccCuU4t1Gqa8mWpkmPqGLsUPWybrEcY0BH5hksCfP5oaqMsdqnJsG2ytFUCl/CngmfcosfGtuEgWOr6H++fHAIUgYhFYJpOcSiPt9omqJiOlk+wnw/moPDOvE6z3aeAggzDsPMaTQlNlakOTv2QzSlAV3R4ouXPvjnDUocmY/pNlNxNdk+rY1wZSo9C33i1nYXUcbxNGBVncs3jmKODq7vWm5Et+9bGGNdyNN16AIs1/N5rUKuSHKPM3JCmsNRLgnjxW6paghOyGiLWlVNCOdvl+TCMoXXberYUS0mqn1KYQRFmy/afVFt21Cwr4yvskAK7Ko6k2zhgT2Q27gwrIjElHHbtON/sH4lgiNhh3GZ7byxc6hXrKi1jqxQ1GR2b+gLzrKZ/eM54ktXshaaJf3K64lPAghxpw9dFkap+tIJNDR5wti6cAbnG7keGihnEtcDL5GAXc+YIiomltFRTBxQJfYi4CeM2OVWu9zwbASjuyKnRc3emA1562kl8t4v6zkI/IkyP62ziHL0UsXOjxur2FwctwGbUAToZSX8f328+Sy4oPpNcBZGnY
 WaOSmh2J
 jMwOxECmiAvoxG0yJqfTUsJ1h/ysnx8oDR82s0Z4nG1A4zaWovk54UtRmXU8f1EFcWo0NeU0z57aUWzM2zufG1pLEr0MhrBIlBhNvj9GkHRR5ex7O5LK9ZyTLhUxzOQLRcr4bTT0mFeX6uDkDUtHUQ2AqeUss6SLWZ+3OChE10ZAlqTCYHhIzMLj4O6t7EERXah+PfPQ6INlAHqLCU7tP+iM40uJbs/OHLBcUBZDFUDZgkXw4KOhywkuJLcUcBhUOpXjjvmjxO48T9pbmpG3TfH9ngtgNeZCo3lgoXbYZ1BymW90cg8HzWEStmIpJANBjEpimy6IHUVxr4xNbbCYuwNbjExonnS3Rlx7aoO9p0Tpnt8LNz2VZKV1rZ5eTWu9yvmNyksdol1JC420/6wrhblMi+8uX9/+p6SWBCphD5OJoYMH3jR7k2QtnbUDkVFZzs156d5NItsRDz8OueZytMpUBS+Ny9j/SvbBHGq+zLWZT+e6J0vgn8o5jYkOTpiE5k9ilbDFLXAqKLlmO+aGbbe75XkDK/2kaxh0x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026, at 17:00, Nikolay Borisov wrote:
> From: Dan Williams <dan.j.williams@intel.com>
>
> Resending this with the hope of either getting it accepted or arriving 
> at a consensus
> what exactly is missing so that I can take it from there and eventually 
> get something
> merged. As previously mentioned this results in real problems for 
> confidential
> guests both on TDX as well as SEV-SNP.

I do think we should go further than this, but the patch solves
a real problem and it doesn't stop us from doing more later, so

Acked-by: Arnd Bergmann <arnd@arndb.de>

