Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C7A7C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2388D6B008C; Tue, 11 Aug 2026 11:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E95B6B0092; Tue, 11 Aug 2026 11:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF726B0093; Tue, 11 Aug 2026 11:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E73966B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:14:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AF7A140453
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:14:40 +0000 (UTC)
X-FDA: 85089335520.02.75B2BA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B8FDAA0015
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:14:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwVi9cZ5;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786461278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B5c4lkyp/O352kmRxSv99z3xaNt4JvhFYqQVngOI5Wk=;
	b=TSNR4r5wYU1E/8rILPhDXzrMNZeb1KRfQkVQgBVGVRxMSYfdfBPEu5V3QXk3bosPGS/Z2d
	4du6I0/tSGISzJpO7KE8dFKItFqb2DpVl/HIzWB2tC3q1gAJsfvhgrYKOnUxlxvPQw5ttU
	yV/O4BO+pT/WfB+nvUMt5ucRDhnZDUk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786461278;
	b=U6MKN2htJU2D41HoYTcNwU0t2VWzpZ/OXKLCLbKrr9ewtBaWmM4pVXNqBdGrI98rHUQpFn
	bqXYo47/2tpdHamD62nfdLGKscdmBKyxMevZ4r3gc/65QjjcSm9GI7tKi37XTatHwoMSDp
	hW/liSeJHjhlGPMPalsaExZAwcWmzZ4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwVi9cZ5;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 576FB600AD;
	Tue, 11 Aug 2026 15:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4B71F000E9;
	Tue, 11 Aug 2026 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786461278;
	bh=B5c4lkyp/O352kmRxSv99z3xaNt4JvhFYqQVngOI5Wk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kwVi9cZ5mJDbomvempSuT38rEX96yv1TgwsDLUDunVpi1syrOHg7zwScqRdYGd5kl
	 n5hl2gPdjH6upwxFkyly8dJbNzmTb6fyu3Jt52bHGe6mEZy8tceQJWK8QWN5sJQLMq
	 fZ8FVaysZQ/xKq3oCKA63Bik6teeyJ7ZtayoSlt26LNQl1CWtCLIgfqExBEtZ4XptE
	 j1MjzOA9HFzluoW9QpTKQlus+Eu3UFz9ZJT4rlJnv855B2juyNzkmnJ6LGDsrRYYZk
	 1TqC/3v8nKn6nYyaSvmYLtCNqy2JokCVn3qEMdMy6G4ZkM2rKEwyS6Q9lvh8KTOazn
	 nHU7iyeHYKUeg==
Message-ID: <8bb53d9a-8870-410c-9a41-f8b536ef0780@kernel.org>
Date: Tue, 11 Aug 2026 17:14:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/secretmem: zeroize secret pages before kdump
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>,
 =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org
References: <20260731162739.158320-1-linux@jaseg.de>
 <20260731162739.158320-4-linux@jaseg.de>
 <70c578dc-769f-465f-a146-4a4695f747c1@kernel.org>
 <adcafa9f-2365-484b-b31e-19006833efaa@jaseg.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <adcafa9f-2365-484b-b31e-19006833efaa@jaseg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B8FDAA0015
X-Stat-Signature: 5g953iif5c15czxi7zqebw3qcdncdtbc
X-HE-Tag: 1786461278-285132
X-HE-Meta: U2FsdGVkX19/8znMCR0lxaI1cZs+ESkryMD5ElDj2kk84NB0l02/STg5C7AvR9qbfuWjV52mNnHurz3D4jX1/UjTtDr7olOeWKwnEimz1Ht+slqANhJRgHELlFuM/lkDAVh4lqRm5azpW46o7sex42ZGkVa5ST0x3V8mKBt+UCmeNvNNKpqMNlXlzHSWRkp65yayOTpUqy2HksyrLEWkxpAzLSlANxAMfeDTXHi60GHAfWeGEJARtMPFo0VHtsnCiR2LG30sOMNJpzM+iC3HZMtouKctpAfSwsNxCbHfEjmPXbJyH5rIXk5/a0smifJ2wROTTlGg7oCYUznjJN531fawh+1Tv91nmChVydX8PCAYRVLBP8M3jsyVVxon1n89QYc5J32PHcnrlihTIN44dTKiqFyhp8oCBBERqPYybgKAPGIwlO2H2J8lu1RMjSSJH9UMsg93L/HCGahoxoCresnnD4bnbXMhyfg5RW1De5sZaFS60hnQDo7bnuotwGupj96O6bSt2eVWhOTemNI6Tp9eKl96I+w7UF7azgqVWEk+qYgOlKyR4Oo7yZsn/1u5sTFMgwDS9IZbhzAR8c05L9HfoiJ8fopqIXbtC4RNOeZsCokNUaa4wBp/06h+MGOR6VdSfUOt5WwEAjt3sIUQm8h4uK0MSWn2gCofU4KUxP/VRYJpZxpVAdpr4nr9uMor0y/gQK0IwxSkPJNYgI+v+L0O4pT3Zg1CtzPfC6IMKmfxrj+t0qNkmckHfguxdJD0FDl0Rpv06vi4T7/0h1iq+q3pkR+F0+uNZPGMpu0tAx2MlJFL6LkZE4BPhQu18pJmLevLj+l9RAP1dO3V+3zvvfDHiwkxwMoB3jcejH+c8lRTTMkngQdkLflbfGEb2+q5E/OE0OzoaVKSGsUmjKD0hXirWd+wxUdjHvZN2CqMCqAc1NwJJDdseJ8Tbi3v1mWu7y1UiM8xt+Ypma7OZkg
 OkYCLLhS
 chFx2dWPZmrCNuiVnB6OT1tf7GntkF1ATljTaVqw8lx2p8H9MEsjlAhDSVNeooswuBY7XaxXr/WEZy/e3VYgsUpO2LpF43NBSdZyWxEZ4m5RTLv7KYSJ5blU8Qk4yIx3AmzeJip1qZICIepjdgIiZbsw2xVxvEZ8N0wOslRkgStX7pt7wsBFkTZHIo1jbgHe5cyEyJJDxmVASgFf65L+gqRSmJOM968mxrkJPzDowBErCQY3aav6uTznTs1AvaveIfw8jyCFdk/ajjuR0lfzhfODekg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 17:05, Jan Sebastian Götte wrote:
> On 8/11/26 16:53, David Hildenbrand (Arm) wrote:
>> On 7/31/26 18:27, Jan Sebastian Götte wrote:
>>> Register a CRASH_ZEROIZE notifier that wipes secretmem folios. As a
>>> result, when CONFIG_CRASH_ZEROIZE is set, secretmem areas will be
>>> cleared before the kdump kernel is kexec'ed.
>>
>> Are you actually using secretmem in your use case? I heard some rumors that
>> secretmem isn't used all that much in practice :)
> 
> I'm aware nobody is really using secretmem. I decided to build this on top of
> secretmem because it's an existing API that actually kind of fits the use case.
> While I could have added a new API just for this (marking userspace memory as
> wipe-on-crash), making it part of secretmem instead gives some additional
> defense-in-depth protection for both users who only need wiping, and for users
> who only want secretmem's additional protection against kernel memory read
> primitives so I think everyone wins here.

What I was thinking when I looked at patch #3+#4: 50% of the users you add are
irrelevant in practice.

Or are you saying that you are going to start using secretmem for your use case?

-- 
Cheers,

David

