Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF81FCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D996B008A; Mon, 28 Sep 2026 13:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75D46B0093; Mon, 28 Sep 2026 13:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB21C6B00A6; Mon, 28 Sep 2026 13:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B21DA6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:34:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2ACB3C0254
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:34:03 +0000 (UTC)
X-FDA: 85263869166.10.7E39650
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 85EF5A0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:34:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXIu9dO6;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rv/LkB6PetOdVT/pJO5A17DkMHpW1BtDQRc+jBFVZPw=;
	b=dHd//adccrAxhswd30G4pR7xK2zD0x6NnTHc0rFGhOZ/VQbjIGZEG3JEuoaQ/CS6oEw/X+
	T4iNEfPbfTN2IR9IFDwJagGtHoDTBqdkKZWoc/rbbAp9XU+jgAsRno5wAfDPoTGDmWkD5m
	SEkDqkFriNi6F5IfTX5rQemQ45irvLk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXIu9dO6;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616841;
	b=rLzfVKWBOK7SBFXXusj3npPPFJjINebLq/jCpB/xp1MW4nTGfJjyLY3A8n3QDRfjN+4djd
	XNulv0Tx3f6yaOcmmyxFk1yNID3hCLFqXdU0+8+BhbdW7sMqINGSQNJ+DjqpN6BNMTbQer
	5CgknfedwC8hZQB/0iVRnpq0uFIBmo4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05C5843995;
	Mon, 28 Sep 2026 17:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E641F000FF;
	Mon, 28 Sep 2026 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616839;
	bh=Rv/LkB6PetOdVT/pJO5A17DkMHpW1BtDQRc+jBFVZPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EXIu9dO6xq2mXjLluKTuv30Af8CyESirOON3Mf9f2hlYpl04nw+40wD3YbPZG1tfL
	 HmEUK5JSYhOyLVpaITSvM4ELC305cnUmqN9ksJ+i7mccp6EtQ/LsYNrSRewyr85nde
	 fVJV76IlrsFhWqVs/3xmVmIBd5rfId8R3Lh7oVvN7+x6UaAjI/u56vaUwWNH+BzmMd
	 5K4imrySj0RLN+5w4QO4+sSnSj9TmSjJF2l8B8t3RQ3nGTFBARSJ9FwuxizUmBvtrv
	 QDRybDY6Goyif08lGnOWdctOSDJJJnyLsuwJCiGm2H3dSjfMBA31RN52rTusPsKHOf
	 pnr0NyfPsRKJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/12] dm crypt: Allocate key material from the
 secret pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>, "Matthew Brost" <matthew.brost@intel.com>, "Byungchul
 Park" <byungchul@sk.com>, "Harry Yoo" <harry@kernel.org>, "Dave Young" <ruirui.yang@linux.dev>, "Will
 Deacon" <will@kernel.org>, "David Howells" <dhowells@redhat.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mark Rutland" <mark.rutland@arm.com>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Mikulas Patocka" <mpatocka@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Peter Xu" <peterx@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "James
 Morris" <jmorris@namei.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jann Horn" <jannh@google.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Saravana Kannan" <saravanak@kernel.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, "Lance Yang" <lance.yang@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Randy Dunlap" <rdunlap@infradead.org>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Muchun Song" <muchun.song@linux.dev>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Danilo Krummrich" <dakr@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Mike Rapoport" <rppt@kernel.org>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Liam R. Howlett" <liam@infradead.org>, "Rik van
 Riel" <riel@surriel.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Nico
 Pache" <nico.pache@linux.dev>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Mike
 Snitzer" <snitzer@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Pedro
 Falcato" <pfalcato@suse.de>, "Baoquan He" <baoquan.he@linux.dev>, "Suren
 Baghdasaryan" <surenb@google.com>, "Alasdair Kergon" <agk@redhat.com>, "Zi
 Yan" <ziy@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Rob Herring" <robh@kernel.org>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, conor+dt@kernel.org, driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, robh@kernel.org, linux-security-module@vger.kernel.org, kexec@lists.infradead.org, keyrings@vger.kernel.org, linux-arch@vger.kernel.org, devicetree@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-5-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-5-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:33:55 +0000
Message-Id: <20260928173355.B7E641F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 85EF5A0004
X-Stat-Signature: tq9zs447gpgcqi3h5fjkopnxpej6hui4
X-HE-Tag: 1790616841-199690
X-HE-Meta: U2FsdGVkX1+XYqOMfFak5x6LaD0bR7nUYIFJg9rkgaTVfCN57PzgyRsLKI/fBgpRx9ZhhmhlLwcZWyCandQ0kYCSVLkk5IGkhfMJo3niBptu0bvn90cMSE8ZU7uHKYEFpc8nfHSZFtw+Ock7RXOwcLq6IZljXbEl30/eIKS34pCi7fn9etaO9BX4saPsADFwS30xG5aZjkbqQwxYkV2ClgircCVY/hemMsE2OSdh2z/tv995QAXTN5/K9HxlSKgi7xdjcr6K0/ODf6hh2NJl1gdgIh+SEE13ZbXbLIVkKqhoeY8zjQQeHW2RZBCU1DRct88iihKpbC7nrFByl1v+7jqeOFJBWuLxi068SZVgs0oanmwVBjZ4lz7bb4ANZ+06YkdnpAoR6rrIF+1Q1d3I2WTU8zTivDKerVt/mP7XG2ODUFB5ZbGnZf7RPZXNeyA+pqXuWLEieLxbNWZrOcBpwlryX9gKJxWnngF969uJQGyHaD/DHkdvFEaFTN1LPWw0urcZ2Xd0jy7p02y5rfC/ZE9vnyYUB4sRDTVz2Lho1XxnSZqG0W//eU2NpR5LkdyYKYDI4HqC4HJDzCFUjdktKv1f8XvspX8RLOA0McX7DABBT8LzwHqbmdYLmHRl2kC/JztwE1PzhRPKj4VEN/laauztHhzZsFyDw6YtrT9oH7wRCXon6LkpgtiMm/Z0LtKGeeYHCIe9yNCtiOM8CsKPTpq/Ips5c000bkSdreXj+4Z7pqRjaawoEBFJUHNASs+9xK/By8hflExP/7UONtHLV/9VOKDYgK42hJxAqWtCiBOW5XjqnktoxwSncdZzOjb00Wqj6IglIFIwtUo/VrW0iql53k4kuvWXLFOWPCePEkAxkALNSwYk0SCKJv/tnzB3xp9G1afKYC7i8mzkzSWzEkDTlILADwp5/kwXCpkLWxLKF+ofGNEwkqdsXQoq0tjbO8zrJjsT9/CiEz95iwl
 Pmso4gdR
 DRcr4glvEV4IaVQLGYfBEx89gYvIiaizNxJ7gi7RdqF1YSdv77pcu19H796IquWkXpIFAaCVynEZYOu4V2d6iYTszf+bMFS66cP2L/yTvv2jgAuvVmfpQxDeCMC26pGBKOPQ9pP7RO5O7XMtZ1CKjEhByJOLy3X1sJXSox4q/u72u8swAuk7wbmT/xwnyBHRp5xS4gbaYJmbfptI9msYMDdizJu1V3n6chUq+X1oYMKAlgHEzZS1waDilm+rVfTquYigApbRUld8zkh+g1tME9MvDh4jz3JJ1trPTBd5q5v689N/yeCYQGnD/ycY9Kotnp5vw/QMEUuZFP406NkAJOC3jIRlWPddUHjtRdYvj+SG+sB9+eOf8joW4AR1uLGIFDIuqNP648pxMjbBy5G5KI+HtTUKUKa7BAJwmSOVqQOk/Gcp/u3sPfH+dECH9SlbqeQumcjH6biZTevMSJf1hwoSn3lNuuTepJ43h+0OgP4WPAjR/4CUZu2Sm1o2ISwEpwBWidTDg6U+1FJ2t0b9f1/jkj+J/699IaeBofrBYS9+c/fqWKAziS2TYv12AIPo9y/PV9nyzaHFp/3uC3bZpGeb1833Hclfxbz5jdOECjGZgJwdbfbbM6472JYlfVd2Lbyb9VoxiRbxFcUWioJloNGj2VV+JMfDvGGZKV4T6G5BaDVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> dm-crypt keeps the volume key, the IV mode seeds and, when a keyring key
> is used, the key description in memory for as long as the target exists.
> If the system crashes, they are left in memory and will end up in a
> crash dump.
>=20
> Allocate every buffer that holds key material from the new secret pool,
> whose backing pages are marked by crash_memaction for the kdump kernel
> to wipe. The volume key is a flexible array at the end of struct
> crypt_config, so the whole struct moves into the pool with it.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D5


