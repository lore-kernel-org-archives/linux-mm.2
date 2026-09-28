Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FB8CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2D66B00A9; Mon, 28 Sep 2026 13:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479566B00AA; Mon, 28 Sep 2026 13:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368A56B00AB; Mon, 28 Sep 2026 13:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA9CA6B00A9
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:36:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3D5EE140252
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:36:52 +0000 (UTC)
X-FDA: 85263876264.22.17E08B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D4204000E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:36:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eRIVjcZP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617010;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+r35xYWViHAiR7sxYREvQL9rqqd84gi08nBU3k0Auv4=;
	b=7H8SGTfl5xRvMqafkMWxY0BcSYTFYoUBChIe/YfAeS1z/jJSPeAlnQ90JX7G7CNXhJUY6Y
	JNBSGcw+u4ClHOi0uMIbsd9L6DDAJkrG1b7k208lumKFvhgLaE1imEWbEjWOSDTVGZ2vt8
	6saBHKIbt4SvXq38R41XFxxKTX0yu9U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eRIVjcZP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617010;
	b=daA6LI26oy6xOPzY9H7KcM6FTCAztQC7HM55YmKH7GQvTEtBCMY9xwzZ/KO8auYtsZ0UpS
	I18UDbv4UN7rTr1FMdGLHlrhmkNBxgLZWq7KUXLA1mx6tooZzKlzs9gRYGH2DIQ0F6ctw0
	9x8MJ6Etj9YiZRVHbgwRrc+JlLtsCqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A111140A75;
	Mon, 28 Sep 2026 17:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C373E1F000FF;
	Mon, 28 Sep 2026 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617009;
	bh=+r35xYWViHAiR7sxYREvQL9rqqd84gi08nBU3k0Auv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eRIVjcZP6kE3UK//4StpY0kavKE44Mjonn9fR2bQ5ywHPLGZY7CPKGdakw96FJB7v
	 XI+YZlkU9mc3zKkw3tpHXI5R2ZR5F0wgAmT8jGSV8rfq/qjY3Mrlw3/qBbfO5WKuOx
	 s2pwzzkvQ1tgzCydYhj5KU1G9S/RnWjDK1uCICxHYGJtHZRNh2ljgOgjqFSmyVgKre
	 qv2Q2JEvM82S9mXhMPyboIDBYJYhYKAkhVWFWtA31dzU9VPBm+4Fvu0cbZEH7y0hKC
	 /4u5L0HiD/WxZdASK4k3eJOlokcp4muwL/as5ZaRhM3Icgjaz+U5b9iPTTX2OZOJTw
	 8GfrReHg+WMTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/12] kexec: Add a crash memaction registry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Dave Young" <ruirui.yang@linux.dev>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Usama Arif" <usama.arif@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Mark Rutland" <mark.rutland@arm.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Alasdair
 Kergon" <agk@redhat.com>, "Baoquan He" <baoquan.he@linux.dev>, "Matthew
 Brost" <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Jann
 Horn" <jannh@google.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Michal Hocko" <mhocko@suse.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Jarkko Sakkinen" <jarkko@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "David Hildenbrand" <david@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Will Deacon" <will@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Gregory Price" <gourry@gourry.net>, "Harry
 Yoo" <harry@kernel.org>, "James Morris" <jmorris@namei.org>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Oscar Salvador" <osalvador@suse.de>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Muchun
 Song" <muchun.song@linux.dev>, "Rob Herring" <robh@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Rik
 van Riel" <riel@surriel.com>, "Peter Xu" <peterx@redhat.com>, "Arnd
 Bergmann" <arnd@arndb.de>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Byungchul
 Park" <byungchul@sk.com>, "Saravana Kannan" <saravanak@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Zi Yan" <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "David Howells" <dhowells@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Catalin Marinas" <catalin.marinas@arm.com>, "Mike
 Rapoport" <rppt@kernel.org>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Mike Snitzer" <snitzer@kernel.org>, "Alistair
 Popple" <apopple@nvidia.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>
Cc: robh@kernel.org, linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-security-module@vger.kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, devicetree@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, kexec@lists.infradead.org, conor+dt@kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-1-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-1-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:36:45 +0000
Message-Id: <20260928173645.C373E1F000FF@smtp.kernel.org>
X-Stat-Signature: szhwodpkcmi546gd7sswk9jshngn43pg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D4204000E
X-HE-Tag: 1790617010-744743
X-HE-Meta: U2FsdGVkX1+qI6dXbzAFWzIHwidfRgpqggQ58A7tvySrPavLsRJ1O+kq0jhgF+qfwb1rZpuiVTPWknJ8MFPDvcrekXyktyW8PexNP98sH+pBknfx4a8s36rERcWQh1yyMs6zc4p56iTT3LtpTSTlNPePlXvcHWtHBLygNjSvSe4MN9ioTjbVlvrjFSL1jTXirYWJuhLjOWizZDvUWO3j1oUv9qdtSp1ZfJm+vD6jmWoxlRq7gmDoYfFAIszj7Nr03xG8RZHRl3JvLeZzHpws7nEyfZ31GYvgg80cHcThul3Ij9t3I+e+nACCgwJwcBvwDh8HjUJ42Ylw7ONIFv+eL7c4iMeiEHPxu9uvDyeW5NluVufHJvnOksEW3wYYc0N6R1ITdo3chrMUgU6/CBkPcLgAGV3z+fwIVa0XUhQhpiuwD4gr5agtjVe7EwtIf2JI2B2oTXc2xNS71a3De2cDtRkuRLTS132JdALKV+KkogXRZN9CXeLOeABGOsOf8yaofncM/AvAMJmR2nzREOj8Wmqve15j0RwHU2PmIpRN5BdFPf8xvpdZnqtMC6xKK/XTqHClnnzFO93TWZlUrDaSyVALejOYZFFklc186DR2R342ipWnCekSwWnv5TEmWsUCsN+izPFLgdZvjISl9+/VCgWHduXfnNd2HpbqupdtER7M1cLj8KCw99jpNm9WGi8CDZ1WdtRrm1HudgM9n3c3EdJ6f2jTGP7ePKw/dgK523ON6w8paDlND2nLsytDWLDoB1jMywzeVKmtlc/10td2Sf2GgvEV30OtmAgDRYtWIHK9Hdzt/4mIrXwcaMb5MJgoFqrl9Nx/AnrIekaX703Z0+AsOfxDKAk9HLvTlTFI0Ld6zkK7eq9apcDpSZ2i1aqNqbln2to5DinHmUIv/nHlRAq45yGvuzt2IytiTl4DPsqmDTb+Kkn/Mgy2/wPtKzmE5gyQoD95deEhu91bQOd
 ZvIfaR2U
 m5n2F0UIIbIE/JUz+y4YR4kCuch1fzOnmErJkDU3oXSuFlMalL3xdOvBC+qOPMzmfRLgNW0iRuVfNU8azUXsuseTQuqTCLYhiojottPPAECc+iOBLaBRsLL57ut1AzbUs2qYHS6toT6+Yo6k5Xb2wP0U649zPR2OCdt7ziNfr7g3CLfxLxv4QkSpRncTAhUWEG4r6kCWPLUq5nZ0JOoaC//jE//xj8JRZ+IzNiBwreAF2jSPfJegGdVKRFiNBL6AD8nfqIdLMDwD9/VOMH88jB9ofxyIcfQM2XgVrIleAITwaI89VcH0S5iS1IeUnWhO0ZKGl1a0fxi1BREweSH0zE8b9ZhiJNaRdrWp8+9StYPGRylixYcxIOjlT6jnWBXSN0CMG2kXMGB4BdwiEAywWS0oxKxa59JKeWN92oVAFkRAsv3n4PMED+31vdk/vZEtZB5+JlQVt9E3LbGTRnycv83uni3QAcoVOurHN9D0OFafIegh0raO30uHvrvM/eaLt/YFtDzyTwdj1ckOy3hpimwfo1jkl9fQndEanTTUaoVgWQ9beQnJruA8naR6qzHrcOi5u4EicDFsFxQIPeUwU/Q1BYB0okJX6PN6HSs3SstPbwM0QTHe+kzBJ1ebVhK3c3480s1ZU2m4H86rrC2AjZATgj/JqfWstM49zQnTOuGFHs6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add a registry identifying page use to a kdump kernel. Intended uses are
> wiping of crypto keys on crash, or omitting pages holding e.g. crypto
> keys or unimportant caches from crash dumps.
>=20
> The registry is a bitmap with one bit for each physical page. The
> meaning of the bits is set by the crash_memaction=3D cmdline param. When
> not present, no bitmap is allocated. Marking is a lock-free bitmap
> update with no allocation, so it is safe from any context.
>=20
> The bitmap and its metadata is handed over to the kdump kernel through
> elfcorehdr.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D1


