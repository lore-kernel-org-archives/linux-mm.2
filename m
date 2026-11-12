Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C86606A888
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=P3crDTR2;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=fSUUtdbR
Received: by kanga.kvack.org (Postfix)
	id ED1D36B05CB; Thu, 12 Nov 2026 07:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9D26B05CC; Thu, 12 Nov 2026 07:23:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98126B05CD; Thu, 12 Nov 2026 07:23:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2EBD6B05CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:23:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFC87A812E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:23:14 +0000 (UTC)
X-FDA: 85426381908.15.57FCFEC
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6EBDE14000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:23:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=P3crDTR2;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="f SUUtdb";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQQOtAWIajuSIjlpRm2vXAuyWpPNUiVztPgT4AugiJU=;
	b=b6zqMUZ8kNM/qp45pnvvfYGF6bi0dE/YwPAKf6JcaCIPEOswkaIWwi+PrADXfLqIek8Hk7
	PsCt8NmkapbmcivusNKEHuucJs7natd5XuEdVzSBehCBEv9Wa/TGEHeZ5GbbAuaWbyiJhX
	EwXrvqQT+dtkt9QuUzLmsHJL1aw5Aw8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=P3crDTR2;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="f SUUtdb";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486192;
	b=uNznWuSjJv4Q4PdoZLdQ15zyAD3S9ti2vfH5rQjjZWZi2aOv9/KnpnqWCDpyZmq7hex8e3
	1Xtmd7aC2yZXoR6K0zBDXo707TjILLlT0AdZK7/dZwB5rMBu27shmFXSsjlOHSdgpsnYoe
	66eLTOMmBTrCw0h5kJDqrnoLimcpDkM=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 72E3D7A00CC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:23:11 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 12 Nov 2026 07:23:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794486184;
	 x=1794572584; bh=pQQOtAWIajuSIjlpRm2vXAuyWpPNUiVztPgT4AugiJU=; b=
	P3crDTR2QrE3mDKXA0pzvG/J0bybuc/GE0R2+MUdZp264RpkSMcQVZUcYrDDpZgb
	IF+xz7OFlA2tZ1mPVXTCRlHno9SutFrCMpp0k51JBZDEbv0keJE4XFc7UCBBsbu1
	z5onelRGFLzhRVe4TDGTEy+caDsXmV/0vQkR9L3QcLqzqVWjjRtJV/GZsPcOQArg
	TFVocEfVeZn3ldcZG9Zw+36qsWWQweFRqkf561gT/9CziFep7xz+6ynjjfATsBE0
	dDxnnAdPXLtTWCfAR5HvCihTN1MenKC3qxdhalWsDf9cehT8iPjbkvssqTUmP8Ca
	rixYuPIXf6Edl8S85rwsgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794486184; x=
	1794572584; bh=pQQOtAWIajuSIjlpRm2vXAuyWpPNUiVztPgT4AugiJU=; b=f
	SUUtdbR4HBO45/mk5eu0YAqBeAKShi7GKHdQyo/BWkb825A8Zi9EIqwWRVSs1pcN
	2shVokvXjHddAXp7isok9lwDLIHuHWfHz6MNmkmQtn9hidGG8xcTZrxrxLs4ERmj
	nnVUzsilTXAPPOFMD/tFoVHWYowqJS6SM+jBC74dDQt6d6doMt0uaYne/4RzxYm/
	89EbxzKiZzolJ3h7lYx/Ky2Cl1+SZPPNnWFwJxKLaG7R284peEknvZBcSlslGRzw
	5132kjSPejun9DRxwYozg+HXZkI0d5PX085EOoASVy5d7xZ1sJCrtlCPdoVwB7q1
	IGZa0lXrdLbZFFX1aXggQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794486184; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:Jsvg07tMhFe9YfBd65F67jyTNtaRK1zhdSmP63gSSaWuNso
	WXGm7EmkqWH6WV60Irw/i1aBmWEEMLdOzIgNk/vLm3SjMnUf7TCFZiUD9+dUGPov
	hB9Y04FKtdynrRfsk5a4sG7kxNeMY1nZwzUaQKnlnYIT5vZFrZnGO3Iqb6LH3299
	W7XRXUYVFAqtCWWR84Kii2S/wSvK15FFRbl3IewJFOID+TKKiRDpx02eYRgc1+QP
	thSKgZWSrs9cQPdZnhImEl0Vyrh5gBzk/gGcd/Oz07qCEyINgvEhXw2emx8ygi5P
	reEgcwz5k+YhEAJ1GlQwmDxjbhHvTit6aXJgHig==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:70yQGtggowVYDRHL6YKfPxDiilpVHlWmnUJX12t/gPs=:O91qDgHCDp/h71v8TAj9HM3/MV9+IU2QNkfmjp6XH8o=;
X-ME-Sender: <xms:n6_1al4q7t8sPbNHk9ZcDabDfZWI--PS3yobCtKgM18RJUCK6pIt8Q>
    <xme:n6_1attRr8BlRCZWHT1U2n7s_V_y0dEuMhbW4yU00VZPFcT55_MhPxgRjZRP0LOYJ
    6l7M0RT8hyR_0q_RtCQItOEBMp-FqCFbVSgk_l-UUC_MGSuMH9MnC0X>
X-ME-Proxy-Cause: dmFkZTENDWCLZ1AsP1BwOxKngdvuCCtkQqE4MZA6iiupg9JFXObYdnXpxnrsIceDQ9snZR
    PmdDa3QNSvwQc2VnXG8kK3uQ1fnh26r6EfLM4tXSRfWOEQqnKY9QII707R7oHHunYlR01g
    GM8ofyASf4KacOR/q5T8wLVy3McGB/LL6qJQykGIUi+PLyL3GEZNkdC7swMBvRvdaUSHOa
    M6JzuiMhYCBPCJMgSaZEwSMVRz1tUEnOxeRtP65pSti3rsT7bpdM3lDN4Cj8hM9B2GWc3F
    gYdQn21QY9Vm2bWRWZGFAt8nRliVdU80mdPzxWLE6QfIrmj+LKKjwBinE059J3TaxrezFd
    z+ptb/+kggG/4zwdHsIjICNOsvzsn93x8woktqYPxE5S138aWckanjQhcqqD3Xz5I3QGwZ
    HyaIy4NSEFB3rZpP65nB+MFiBId3H/KnEp59m+ePZJsd888ZbLhkbYQZBeCeRGpIjbN/rN
    xFntOBhfjEJQcdR2QVwqMwq3LV//Yn2vUarjPKtXnJF8ZmzxZS26D454NlUS8+eCVnL8WG
    j1LYpBLCtx3CXLg73JmvkDA+JkFH5xFnfEXNtSuMu37pKYM8585zicLTLL57nFdGvPMTk0
    Dqe4DgJjMPnlK4WgoG4UoRPv8KB5d+hbDv2o2t79uWli2h6kBR+54AW77UpA
X-ME-Proxy: <xmx:oq_1apRThMMkkNGJOzyUpycDUFHQQE4INZFdKrFWfr2OWu8HTU-TLQ>
    <xmx:oq_1anplsAN-TbH3FxxNXMyiawEjF_2FUQ0eKkV3FpIIPUs0FEFGpw>
    <xmx:oq_1anYZC5n6m5Iqm1LV-oAHoxmb1zzdOln3kyIuaSt5-UeCt-vtNA>
    <xmx:oq_1aiQqZcsE9b5m0AGqWLb_c4i5j2hdZ504PsPdpJkby3ByOXXBsw>
    <xmx:qK_1alc9eIARixlfcZspNkIdgxoj4uKJOu89rmelOEnZi-d-kZjREk4z>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 79EFA32A0099; Thu, 12 Nov 2026 07:22:55 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AfXj_ROFnIdR
Date: Thu, 12 Nov 2026 13:22:35 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Mike Rapoport" <rppt@kernel.org>, "Arnd Bergmann" <arnd@kernel.org>
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Jason Gunthorpe" <jgg@nvidia.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Message-Id: <219f5451-1cb7-4a2a-8423-3a071f8ad42e@app.fastmail.com>
In-Reply-To: <avWnS7MLyPaJLaLR@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-4-arnd@kernel.org> <avWnS7MLyPaJLaLR@kernel.org>
Subject: Re: [PATCH v2 3/6] ARM: drop CONFIG_HIGHPTE support
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c769xd44rdzstu8te3wa7yzxhtt6tdgt
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6EBDE14000C
X-HE-Tag: 1794486192-435266
X-HE-Meta: U2FsdGVkX1/BVrPE9YqiTOm20AOV+DvJk8zw2YqmV0hilOp4HJ6+qGfvMVqAqemeGlLEioptZgdjJyh3xmh3f/9i8iNudmCcYJkJnRm21ZYdnR3m2dO+rSQcc6Yk8axMYPQYa6JZB9We8H5yaZsn6F0p6RhwWNQpQNqyYKldILbL1ur9jOmPhsLVRqREf7oqLxdz51+uVrE8BFN+64/v4Lc7clI1YuURISDvQSkxQHbJWTvhQtDQJRExHW66CA/tH1SzoH5gGGRcuQiIVa6mNw7D9rwYpj0W/wWfZgzWC5SyjZlIpvCJqhsusbgExqjdeTt68kDVhXIbngCawpJpIe3ruMXOQ0uL1/6t26PVPdfgZoMEXd7sU+JulPhQaaXXFOEEkQNRJHYW7gt80pLr4oEPINPi1HBWX6VOGZTjYWK8ldW9O87p2SS0Ae8WQ3oLdVKj7TXP+QmPiyk2Oa1Oj2HEYjeBxFtgz6mu7nDwsD5rfMKxg45cEzevpwTl0CYUcLH4aUOBWfPcL7sZBRai1MLzgBGFoo3o2aG/iHLbgY4uMm4yYIFPOmnmxpqzJp5Y9DoJ0cdlQxp+yIlluFJYlgm+Ii++kIklJrCQ50mlmtxUErmEZJrmAzcKNdcsKeViwE+XOaccssasmT/xZXVQT5UoHN/n581mRf453p/B79ALX/g9LtvG8kK2zYHytzCivErD6bsvuRzO+J71+SXp7Jbjh3Ibq6+UExjCopso4GrWJhtrFZIYf1v8kD4jcHhUX1Xl6FTKMQsZnta6HzFrFxNFb2X9mCgkyC56a6/JHkQfCfyuP1eyD8Anda795IQbkngHkYBI2bCduyJxe9E6PQzV5+A+nfYBu9utZ/7mxkfMC61WwasEhHRwTsIl36JOVlDud20NjtBqqVo/1xO0XSWJGi2aS8a7qlRakN5qLrr1D4GdHoggiQxTE/T5kBNruxmKbM+druq/GMb/Knu
 kbeOzXmK
 MF9Pxr4VPmZrDjh401X82w2z347eYuo36G1+qc8Bf8xFmaZQRKMIQBL+x9+mfTL56w5/TQ60H+s5S9vXyDqfIFG7OyZuaMjk8xEaQzgwx30vc52zHk65zlsDVQ25PoU+9rW455GjdTAEUqK691iK5BGpWz1s8jmUa1iGc4Wz+AaGr1BNa2SSzSAbaD/WRNj4y9XXWrgEo2qMKsypuIfCQMWnP8hiMlAymXVemENbupeVX4BkPVwLgH5NF8/HiMKEqJ16kpr6aHSsQwmXq2EuiXNh7BhtM3aiypAhhASfSD5iv4qUH9XhepM+hTF7cDLFytSlNbX/3WYXLiIbp34JQnnPfpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026, at 12:47, Mike Rapoport wrote:
> On Thu, Nov 12, 2026 at 12:25:25PM +0100, Arnd Bergmann wrote:

>>  	if (!pte)
>>  		return NULL;
>>  	if (!PageHighMem(pte))
>
> With HIGHPTE out this can be 
>
> 	if (pte)
> 		clean_pte_table(pte);
>
> 	return pte;
>

Makes sense, changed now.

     Arnd

