Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA20CC6B2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 23:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4346B0092; Wed, 14 Oct 2026 19:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5752E6B0095; Wed, 14 Oct 2026 19:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463356B0096; Wed, 14 Oct 2026 19:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 246316B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:58:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87EE0160817
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:58:02 +0000 (UTC)
X-FDA: 85322897604.11.422638D
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6AE1A80005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:58:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b="SLuEqzU/";
	spf=pass (imf30.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792022280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDt0V3zgEeFnZ/hUkaSJcIFWjQFpdbBhUCXQ2dd4iBU=;
	b=zMRN+HVK9nlsoqZhlb36MR9m8dbZ143aFXSDMaqCsjLEEqDZRGHjrVryPvih/mx2pyY8y2
	7PwLngsiNvMO/FIk7RvYXKCjN14OZRQdbUxfNCGKdckPn08IteD4VVZ8KVzJ1rVRhB6Zpb
	imktLa80t/vC6xhUOVV4lJbs3qhTHEE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b="SLuEqzU/";
	spf=pass (imf30.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792022280;
	b=JCyjRAZx6zP+Q1c7g8cE3tcl7DOFlO22tmiiJ5KSTBl9erYGEhSFQdJq1BaVpghai8eWMt
	H6FQqWTxkTmM6Wsw60yl4HaUi6icl3R0vNgh2258FpJuWKZ2+OTLwque3RGUw4XgsGHIM2
	64Mr6T1ExeHzqwxxgKsb4qIUbcG1ooE=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 03FEF40E02B0;
	Wed, 14 Oct 2026 23:57:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0WrJzv70E26G; Wed, 14 Oct 2026 23:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792022275; bh=ausymQBLxGPkz8L1V9or1eZuZEhcZPEXJFf6c9MvyEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SLuEqzU/U7CpOevlxTdf4JMdWrEsdhl4Ly3hNkV+YnXQjso24OezAoI5jPxXX7RVU
	 nVbadgbhoHWEikDWOqZE5ybpd9MV5+RodTQOP4Mq71rRT7OH7j8NI/LtQS3uIh2H1S
	 /L9aI0eDAU3E6i1wPAz5ACacNQ2raJ0e9RJ5NHur6MG5PvW0XiJ8amlgT+O68qCDF+
	 eXCEUIIkCoyDj7rAgZxCE125qfs7h5tw486uJBbpnl8Qe0kluNZ5+NGa/TKlmJwZ99
	 ekNEMY+LRqcupfNQ/M0LFaVi4q6SBsDYJ6z2VMcoKA98iwXBVtSu8p564t3HZuYOIY
	 kZiueIKOgSnHilcy+ezVADb2+5iYtAhRTm+6KoYNjbASicIJN1viEm7VnKONPcx/lr
	 aDkObPk8I/1ptf34U3PYq8/AWOiezYuxA5PneVZpOF2yXM9KM+wOTaAUyQRxA87an4
	 imyyh/Z1Bxr1cVndhTaVzhPBU6Uf/MEZ5fYU0rSNK5LGvyR30glxoyesLe82wXo2Ei
	 4/MStRWkTbyD9GrRgQWzQajbO4Ci1KE/fMfuiXdHgfg49F993VDvDN8Z4/mSi4nmD7
	 eToLqyvRBFslgqGRBsw8awFCuT44ItN8ygYv2scANmyq9WxQLBx2tbe69ybNvT2kbU
	 2Xj3TQ39uk4OWmbEEyOxhD0c=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2BD9240E02B3;
	Wed, 14 Oct 2026 23:57:39 +0000 (UTC)
Date: Wed, 14 Oct 2026 16:57:36 -0700
From: Borislav Petkov <bp@alien8.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: David Laight <david.laight.linux@gmail.com>,
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	david@kernel.org, Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>,
	Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
References: <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6AE1A80005
X-Rspam-User: 
X-Stat-Signature: 3ktdjdiypmzmdaxrapq6emm1u95hn8o7
X-HE-Tag: 1792022280-660042
X-HE-Meta: U2FsdGVkX1/Kq86cxf70nDF9kvml2NQZhZKVK7646qNXMUkVKYkoiLYceEf4jzaZ3VThjDw2xYUZiQkchP24v+oKN4QlLaXAvoY1nO4k91PkELkNHg64CFX14/dL/GpDV3OieCkZiMiJVHkVrzsAk1wYuuWunz/EVUI58vVX528jPdznHkgoinxv7EOlY7fpQAAYkIEy+a6SnKSak39+EebaMOF6HKY62Ni18U/TYn80gn9m4k0M7uMqwBKcqc0SSvrHgoiKBOdc8BCQK+vEE/X4Olp+H2PSxnszxhm+LGKxiws4qpgbGhQja7lL4/83+/nQl1N0gyLiFr1814DT48VHQ6Ab0a6BTNZdkE+kFWSPbKfmIqLAc2Sz9oFsPR7+K+HA/5ndK/5q2OouMuWYNq0Drak1+HfuRRpI0UP3EAWD5s6xfrfKvvnVvuLtkm+wIW2xfauoxM62i855rFp8kPnSqFoFEPZw6XmdkNgtafip/vzm8yGRkY2BP6IuJ08LiqQGheFukYzoO2OZcBvXd+NhZ0f/BgsILJ7dKj9lVHkzq2XlJW5pBDGVaOj5hM/5uDGCHRJiZmtK/TqwHeu9+zRlMkqPvS67k5vNTck5RyKEg/yZwjvLqSrcz8RzL6x+MjGEcmWtbmVuuzj2Ow1OCIJdVEYkf0IgB3L0zh9w/A7EMBO5PX5EFRtJLjwoY2Q/VveROBn+FUFRXlo/LEOYLE6r430ItKAaePgH6pE0ggfPguUVhVx1+OTauQsJZrIkoFANSQjeM/UXVkNaePzQgSQlQKccS4viqtckZH/9/uDsJg8pm1CDJFoyNoWCwX90S2MpoLmPghlOS20bo8yQ6cD0uHNFSonzz4ujHpUtGIj4+QQqSv7pVIu6qVRjPTzGm0MsI53kiB6MtEjKsDnekXQK6Sg5UcsCnrWUQa82Phoq3SrQFi11XfaohR7dyKS6Xwh0bLtn1G6RBeJtkSO
 mkr+Jp4E
 /bFXUOvD1csO8MLpfHvNj4MZniJAufvHeUsXbrqBTQrVw/3DivOHH2oXnUx370RPxRSaMc5+zFmZIVzXrVBoO7STUedto/pqDKq+YeiI7Cpw1J+B4moZtqRhAAF2uoc7YSLBAQ9kSvQ8LnwVtBeV+UgvudvmCbTZSw9hjQj9eISj2QJYvrKLe+SMYKvXb1SDJ5OAGZvyd7QbSWpigHbwnOYTOZSHBiPn9it8b2KQcaJk+DGAYMD4YRbaeMW24DemNMoRYQQsax3qMbAAMtsZzaOCwXZtg0iJ5Hnsar3ouwd9K7kSPnqmZWmUTePCbKr/vSz10BcVXUujB4NO+rpPXLy5SD9AcmJifAnCNAFT9akqwv4TgJBxv67c2466SSwcPixYDOD0OLl6cjsxnOBYV7FyZAZeVQWr1AERKB6QPesm2bM6LKVNHbqegYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 01:43:30PM +0200, Nikola Ciprich wrote:
> Since I didn=E2=80=99t have anything else to try, and we started having
> crashes on our own cluster nodes, where I can be a bit bolder,
> I built 7.3-rc6, deployed it on two problematic AMD nodes, and
> started a migration torture loop.
>=20
> Over the weekend, there were ~70 migrations of ~160 VMs between
> those two nodes without a single issue.

Did it reproduce usually with this?

If not, keep hammering on it with the latest kernel. We might've fixed
whatever that was, along the way. :-(

And if so, that would be a damn nasty bisection to figure out what fixed =
it...

So pls hammer on it as long as possible to see if it is really fixed or i=
t is
simply harder to repro.

Thx.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

