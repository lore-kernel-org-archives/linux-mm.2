Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2B4C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C736B008A; Tue, 11 Aug 2026 10:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D648D6B008C; Tue, 11 Aug 2026 10:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA15E6B0092; Tue, 11 Aug 2026 10:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A12EF6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:58:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32CFDC046D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:58:51 +0000 (UTC)
X-FDA: 85089295662.13.B995AE0
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id 14F79A0013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:58:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=RB8KNNN2;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b zQTPJW";
	spf=pass (imf15.hostedemail.com: domain of contact@jaseg.de designates 202.12.124.141 as permitted sender) smtp.mailfrom=contact@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786460329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jp0fqZFHF7mI1CqwrilSaNxFrVnfx5CxGflz/18MAoI=;
	b=0B+WRpFcj2RLbqJpNOnJd2KxFStL0xPxTNF55Xb7IlRnhtPPGdtkJ2whD+Nm6VBCD+wdRK
	Q61JtNmkWFrsuq2SvJjFk58pf7YCSTtTCgSWszvDe1fEK7YsXkSJiyd3lLECOyRHwUCnab
	eonzbC/MLRkAz0CSgBx13qG//2a29KQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786460329;
	b=211d6s6+IK2fCXN2KpjLi9ThP6H9dPeHyDEeWSzS3K9PIVAGlnmgk8xqqFOQeWrPjxJlIv
	6AJVKNNR3rok9truRlFOJ8KST5uq1UjLYe8gKfo39NCItAZZ3DIgFyLlBnCMG1jzY6nx0C
	I7ljnRZmRK6BXH+P/7o1qmKGqa8Qwxk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=RB8KNNN2;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="b zQTPJW";
	spf=pass (imf15.hostedemail.com: domain of contact@jaseg.de designates 202.12.124.141 as permitted sender) smtp.mailfrom=contact@jaseg.de;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id A40251300303;
	Tue, 11 Aug 2026 10:58:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 11 Aug 2026 10:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786460327;
	 x=1786467527; bh=Jp0fqZFHF7mI1CqwrilSaNxFrVnfx5CxGflz/18MAoI=; b=
	RB8KNNN2uLPqYwPDPFFP1WLG/46050Id03CcYX5EuhJ0Og9/pHhIoU21hAm4eZSD
	qz5TMzt6KCMD4rEZIfjYO7yoLR6qxAgFQkTfNO3l4cJ1JhJEHft36jConhPMLxjh
	oiTzjlngYctfnfkrQ1CTNjhrK2/BbckG0EUv4Ix18/eaqgmfp7MVyH9PWplZlcLd
	WJt6/PxJDGZ0ACOMU/CzcczcrXkEJ5//oq5oigdbA+HjC/AZbEECfNcfmf2ulXc+
	YyeITKbD59t+Z+79sJ0JPBE4oHNkHc9Q7x43Zt69R7B/OTQy5UOnwO0mj/+u58fV
	+RbKX69psMu+YL2564+dWw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786460327; x=
	1786467527; bh=Jp0fqZFHF7mI1CqwrilSaNxFrVnfx5CxGflz/18MAoI=; b=b
	zQTPJWaztfd5VsPiL8k/4fVV2EhfctfLSEykgNH+bCG2zpjDLchcSiFUoxNrIxI/
	DM/SA160y3vhtB44WmDu1ZCks+ttamqcrsuS+JrajTeh2xHn867U7HvnD+m6+V7e
	FsMl8Tdr9kWvgxYFVs3+1nJ5jp2WxMGKRu9LcjoZPvoBzDtZScbDsehdf3ejYVcz
	/xZuuaxYGc+0IwiIv42d83t1EuRjALHZt5kHAOPRd6hhnqyi92qKaesRZ3eewWZt
	SpKOYbfFw3hraVoHXCohXOC71cbhSXOztVmD6u8XkjIJy1/fuT1MuqnoeE+ARHKg
	O3Rrd5pCMiNJPQaSsq4xA==
X-ME-Sender: <xms:pjh7agnW2sbwu5eoERfEMBE-zpmtsQrp1Omlk6l1RhPODd_QgxWQ8w>
    <xme:pjh7ar9mZ77LYHw7W7agqhE2aKbq486ENGy9ba-L2Xj8VYzHU4aoT9B8-WTEOWzX4
    Mp6c4WIpGDqylWYl1f_t27_iqlpRswIUBa1lQNO57YAL4zWK7yd>
X-ME-Received: <xmr:pjh7aqeltHoxApSSZceXQsVS_pN3mPGIB6IGTd0s6mvxafnnGt7ogtO6rrf3HJUypxZ7e48iuQxUNa22MrRemxM>
X-ME-Proxy-Cause: dmFkZTEZzbQm8+MDadCcsfJIzUGhB297v8VJIjT5vjgHKW/Zy5NM7EP2B2afP7kXMI53Pi
    iMI0tkUZvFWWrvqRH/dnVoYK6W24oOJhenYKYhI5KO8Vx0oQHnpX2BCKf9Q6x7r1s+eUda
    qmBRp1DiByHgPICjaGVN0CeKyGl+imPlPIlFbGGt+r63vZTd+ceybvhTgBxHDfYC4j2HO6
    e2a73mnRuf9+fKjrvSWXh5b6K39H9mLcpSDP87bw4E9usEp5rE6R5L4CjPIF4057U/EdCT
    x/hnPYXUYRRJfF5FKi3p3YQQUSjG3LMuOm2yMOEqWH2+kvJyI94puOzYBkqL0qWxY1tsCu
    XuY/A4RbsLJ23UA1GTKWV87gFg1aDRlwH+b5xZpNz6cgw63Fki/lU1EEoWliJMHd8cpjgL
    6F7/iTtLRsz9MxFbw+NtkGT3bogoTABKQ+QM7gAdveEJyq10Ncd4TP2sXyzTFx40bp6GLf
    r2LKMNM1cvvfgU5v1JZzOM2IrTawvNjM3ZoaVtQ2mug9pdaX3O1zJgKgnBAsAWDheayKNE
    omfItp08clFcYViM4HjddhvNILTXLTb0lzDAyudfYzjpsT7o+MW5Z7ENFsJ3BZBY7uEV4w
    AxB2UAexilrYje+mEv186TdsruwEC6BTFXDG9+V4poscOK9owRxMxaqCVC3g
X-ME-Proxy: <xmx:pjh7al4tD6fMWdbRFemuNdQsTrYh2ofZP1k9vtGP06xgSwZc45mHpw>
    <xmx:pjh7au913xd5IzW3OT0m_37nTpXV-1ZHMD-UkjPGwO2FnFCHxp0gXg>
    <xmx:pjh7anzm3EGKn3fjDC041YQSZUs7weSvqHbAAguTeSIF8GLzrN_V7A>
    <xmx:pjh7atHn3Yj2xJCweAynTJuxrtdF0234e-Buy76u0341hVnT2WhiEg>
    <xmx:pzh7aneerQTuAXvQa5r2czyHrRm3rAecw4HwFoxCUCV0vCQYp7mAtUdB>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 10:58:43 -0400 (EDT)
Message-ID: <018e58ef-c20b-4859-9dfa-bec1b4360a37@jaseg.de>
Date: Tue, 11 Aug 2026 16:58:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] security/keys: zeroize key payloads before kdump
To: Jarkko Sakkinen <jarkko@kernel.org>, David Howells <dhowells@redhat.com>
Cc: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 Coiby Xu <coxu@redhat.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org
References: <20260731154608.153258-5-linux@jaseg.de>
 <20260731154608.153258-1-linux@jaseg.de>
 <2259835.1785538211@warthog.procyon.org.uk> <annuus46w5SXmlsA@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>
In-Reply-To: <annuus46w5SXmlsA@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 14F79A0013
X-Stat-Signature: 6zyd3nokqinsedaig5k6mex3oohqetgb
X-HE-Tag: 1786460328-446240
X-HE-Meta: U2FsdGVkX19tSe6yNuP/NhT8oC/EQOJtDxGOAf17y7NGvs2mW1oAUsX0SF5Jb+mH+nR/1+2cH0HcDUn4lFA4WQinE8gUvOiSOo7EZDIlXGYXGOVoUAXbAc0yrYX9ochZ+r5cWE22x1XSxHRTT8ny3ISaZgKDyOtZuw6uLABtI4vfZ/9Tw4s0qYMmgmCuHm1gOnd3SdxG4/UxiohcM0qUBqzoKh3a/cy2Io0mz/O/YdtW0k3GjGuNlRLD70iUyp9ttfKx/Tuucl91Z6W/YI75bK4voLhOw3gBVVgY8UEThROhDpH5AA7Nxtnu5VNlhbkWjLaZkJFNtuoLrPEKiNQZTdfJutaRoV2iSm4T69qJ9BhDkGjBMpjfBPsIT8iY8uwRwrAXKcgBDL1aCe1qW4XPd9dNYPB+LJAAYlCZd3UNQ0fa45sE70SIxmRi7vqDcCS3iQG5Z6J3+C8s1+QT+7+hMLuaNak6Aufa8PEyeyl3OAeuQ6U2Oui9a8vKCvSkxsZAkdYh+igoBdHth7Br9R+Eolmdw3sazfEgXA7oka/7oP4ESzSAD0ZFxG6pugknucEFodEaWM8P/8Px+KamlNJC42WVe1g1q0BbCr2qMjoyTuooiq1BrakbpgAihH8+Wy32x+k857r75qpzIkvUKoBoLiOa0GINfqy8rZN6w415BNFS49LVe/J9wmWMnXYMDN10cfu6urOaGoJK0cApPcipzUp/Vbr0W4ei4jpMpfqjuBs3PJuNsx1OFv4eWQQmbzRS8c4UPQawvQLuQ8MzisUk2TATR5louwYOz3Q5I06WE4+SAKRkcqeoOAK+oXNYTmNckZ99ycf9HSIYJZy9m9lpnTwnuyAKSCas1zdlOuTlabuKx3AzF55FWw7IMIjAiuZcYnIPju1n766voSGdViMSMvpraQrunZAG04YJm5xXMCxi9xsqrbidjh7jRq+RE69RfYitqxq22jbWBEJOJZe
 aPw3vS59
 OcpVBcgC1UJfgiM3FpwJjhCtyEyuBXD9ToeVWaPzuZi1qdj1mbG7XhM0UMZqxADCVwyC+bDDik7pDkatcPNdBWkImjj3iLv8u8LWYv+hlCDTq85ApzAplMVDFIPlpLhbNPAoaiZHqXfsqb/MArFy/wBjPqUvFpZAwJgbTbreYDqJvEsE0uZav2N6yYbQRiKgKRcW/Fa77y6I9HP5ElGmmw9q6fWLPuAmMsBhyp4p9i8x6rSTWJtFTD+EaySgcWy+cKALjput2m2hilcHmM2UTH80QbwO2e2jx0t8xdyW/FhpvFoaINVInjg/EQeSUmSQtVFjaBF2VO+H4ydCSMsMpE1lZ4Qhd6hxF+8bvYZIzq5WaINJ7DYjG0p+R/CM1lC3dAqwv57C8RD2TciyW5hj0psFijgNsrsAtZq8qR+ZIVeKm7KXA5sb0AOdpQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 17:31, Jarkko Sakkinen wrote:
> On Fri, Jul 31, 2026 at 11:50:11PM +0100, David Howells wrote:
>> I've no particular objection to this, though I'd prefer the name 'wipe' to
>> 'zeroize'.
> 
> LOL, I responded exactly same before reading your response :-)
> 
> So yeah, +1 to this.

Thank y'all on the naming feedback. I agree that's clearer and I'll post 
a v2 of this soon, and I'll rename it to CONFIG_CRASH_WIPE_SECRETS. I've 
had my head stuck too deep in government standards where they call this 
"zeroization" :)


