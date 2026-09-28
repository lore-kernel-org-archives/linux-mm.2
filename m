Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE08CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9070E6B009D; Mon, 28 Sep 2026 13:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCB56B009F; Mon, 28 Sep 2026 13:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8194E6B00A1; Mon, 28 Sep 2026 13:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6485E6B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:31:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 017BF1C23C7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:31:51 +0000 (UTC)
X-FDA: 85263863664.21.F474EE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F3EC2000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:31:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaaRP7xu;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616710;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUNsQKbdoNdkmOn7hVMkhLGJNjStR4GPA47+J2XShC8=;
	b=IquPvcVnhIFhd55BgrSStWSh35QzmlAbxVNofwaIBfiUmjAbwLJ8lisdBztdpc8CPWdYBG
	Ij/34wl65P7ZD/WynPJKQ8MgtfOqp8aiEQL3si9sPi4RFYQWtf/IVgBZn/AUOi3lKcaXfM
	YGy7g8Ef12tT8EPm0a2MYfGxJGAvJWM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aaaRP7xu;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616710;
	b=pXOh7abtnouTlJLfaJgbiKx7SPYCJvTpjMx2+QnIKMI6qBxUbCPh5jX7pPTL5FdO88+Hh0
	TsWV9PEQeTX/WbA7RymVuKrz1LGliqmdK44trTyT2cpE2btE73ToRJaxeypmCUWQ6QEVzn
	svuPhZmlBgupzUv51IPT4ZoWrp7OL3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C98F6600D1;
	Mon, 28 Sep 2026 17:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E5F1F000FF;
	Mon, 28 Sep 2026 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616709;
	bh=YUNsQKbdoNdkmOn7hVMkhLGJNjStR4GPA47+J2XShC8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aaaRP7xu4vYzsbzzIB1ARh5jRF/4XJXKwPf+eveA2AT8Jqgpt1Dnjgyzvhb6dw3MN
	 s5SsekoSkivHHuRMmjC8WK+SNNa6oKFRebBMX+pN+jDJMgAGxCCLmBp3y5icFGCyhq
	 koLG98wagBmCJ91hpHOfudtH6lk7UG6sxDevYDhmrwIL+e6sTydtzOC05AhgMH5nAw
	 VhsKAc6sD+RdhsMIBV2DVLUmCWQ+TBtLqTSr+vRei2d6ksq1uQcIEXUBbTV1E41N5c
	 FPQgqNF2AvWgUTJmSpxqa1beS5wNqni9CREmTJ+4t9aZH1Me00wySFaMVs7FJ3kIdV
	 Gx2ByASjD6MFg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/12] Documentation/mm: Document the crash memaction
 registry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mikulas Patocka" <mpatocka@redhat.com>, "David Hildenbrand" <david@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Michal Hocko" <mhocko@suse.com>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rafael@kernel.org>, "Peter
 Xu" <peterx@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Jann
 Horn" <jannh@google.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Saravana
 Kannan" <saravanak@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Gregory
 Price" <gourry@gourry.net>, "Catalin Marinas" <catalin.marinas@arm.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Harry
 Yoo" <harry@kernel.org>, "Mimi Zohar" <zohar@linux.ibm.com>, "Matthew Brost" <matthew.brost@intel.com>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Paul Moore" <paul@paul-moore.com>, "Rob
 Herring" <robh@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Nico
 Pache" <nico.pache@linux.dev>, "Baoquan He" <baoquan.he@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Muchun Song" <muchun.song@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "Arnd Bergmann" <arnd@arndb.de>, "David
 S. Miller" <davem@davemloft.net>, "Suren Baghdasaryan" <surenb@google.com>, "Serge
 E. Hallyn" <serge@hallyn.com>, "Will Deacon" <will@kernel.org>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Mike Rapoport" <rppt@kernel.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Jarkko Sakkinen" <jarkko@kernel.org>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Byungchul
 Park" <byungchul@sk.com>, "Lance Yang" <lance.yang@linux.dev>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Dave
 Young" <ruirui.yang@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Barry
 Song" <baohua@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Pedro Falcato" <pfalcato@suse.de>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Vlastimil Babka" <vbabka@kernel.org>, "James
 Morris" <jmorris@namei.org>, "Oscar Salvador" <osalvador@suse.de>, "Rik van
 Riel" <riel@surriel.com>, "Usama Arif" <usama.arif@linux.dev>, "Alasdair
 Kergon" <agk@redhat.com>
Cc: robh@kernel.org, devicetree@vger.kernel.org, "Eric Biggers" <ebiggers@kernel.org>, linux-security-module@vger.kernel.org, conor+dt@kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kexec@lists.infradead.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, keyrings@vger.kernel.org, driver-core@lists.linux.dev, linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-11-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-11-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:31:44 +0000
Message-Id: <20260928173144.96E5F1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F3EC2000B
X-Stat-Signature: pu3fkpanf8qyrkgjh8pekj4fz1q8umgq
X-Rspam-User: 
X-HE-Tag: 1790616710-559861
X-HE-Meta: U2FsdGVkX1/MtrG8a6rhsBaLaySgwV0KUw8YGpsXIvuLqJ2pQ9QHyT4ifSEyhBE4x1JHfPOrUOZHuph1Hwmkn7+e79+7Ff4kHdPgmmoWusIctsTH0ZM9v5Md3j6DOuj+WKxn6hvpfWV/UMiHD6SuGxTirzwU1T2qMxNz2xCMadnPyuwc27tll9/6txHwTFcEupcPeoO2TN0UAA+EFuF0WjRPWRTIok5itJBaaHJnY/zCTFoQqb2J4mbAyMYnGwemoK18CeRL/PlX5J4v81DHGAVq68pou05KEmdv2QKkhMAZ1k2/nHCd9tgBNRvsvcofCEyLc+LYPKaIxuYAmMRCBu5RD89BLCkvGnOipg6N7R42c5T9VtFGUkIk0Ho5j2+y87c52gIz049mjTQElSA9SqkGs/sEDvfXPkQyfsXDt9+9e2Xxb3tzo9jA8/i65NwxZXI2m/GoL7/szG4y7DkcRc8GoMO26sixlJOjd9Rg8zoTuAId5GFYzz61IL1PLF+FFS0cT677W/izye5Y91sYLs2Ex5okuYuholuPoRrIYwl9AO+ttaCS0XH+7WSINb9NRwH+EIVwCEfBf/1NjzIkJBs/YI4BlNyRc6FjXyBxfIFwIqrzpe099rdMD30jyIqsO6OM9x74mj/rZHI1f07B2uYDnmmWYWGUgYfDeitYsaIBiOUuUm7S6IT68Wob4zVlXd+LTeaKlVdc+/wXFt/2UqzPgvsfaXs1ppEUevPiauU64wALCmlQp83QYoVZBOrQ/ty/ztRAzW1N7nPmucf/X7V5gUtKBlQSW1ZGn/L774x6nWdbaYdkRHURO2n2c0zK5LTa3ec05CykHNMzaA25YiYVzqGTmT6Uv/QvxlbpctD4KYzSHpYdGyZH3s6qKglAJvZYIMfCiDFv3OpzGFjQiy/exPrPiuTO+XRxjSAXBXUqzbWAIC4KCmYaBi5lgoq1HOSPa0qo81n9vqVhXQb
 vv7rNY9o
 RiGbdVN8CVi6LZYlqS6/KlXPyk+GOqN4nCD7T4XdnlYCuIMQJn5h7cmKO7WfO0qFX99lL1rj2TlFqNN7+d+1/oq/K/DXdoS4l8JGsb8QcXP3DfCLXmgErClDBHmY4p+lzQoRejq60sr/7h0+LC1ioqiaB/2L0PQFO6FgbkOodCs90mDTSjEEAEuPal9zteqpuKtmhzRFDPTlEoC42tl9aBULhmfiZwcTnT41U2HiEi1350Cwxy8qMex5loHRIukJ39oVfZOBumiC5jZ+ZS1SrWTLgssK1GmUZwUnitGuDm1h/mJaQTr8NaCO7fNGKg4oXCzXCxYZNMFj87TbkUTRtYYBS/za+a7zhrItadZvQQzGkAC3WSVq+KEuTOKrGXlIHUewlpU8MF77joqBLjU+lcaDKv7fyHzlizTRxqJRl9SDF1Kf72PmMoxf4C6rQNI3jA61gIpjThlNTGUBOVsfp8MUXMXLzaCL6Qi0R6Y/y0/In9azct7Ky9ORIGU0PS+oJHy6RxZ45ZQVHneQY4j1/mwVW9dum2icD4Kgic+Rag0xqg7zfg+UmOJHfv25Xeldg8QzisK0ZZmqfC33XC4qePT573pLN7I1NlgdWgctRu++kL6Lg3wzFkE7B4RlMBwwGeVZIRhhpzIDCvcLGf2uPN3bV+HOwRlJWS0o/iKoFMMIhnM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Describe the crash memaction registry, including its kernel and userspace
> interfaces, allocation lifetime rules, and current limitations.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D11


