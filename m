Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A407CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B176B00A1; Mon, 28 Sep 2026 13:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422A86B00A2; Mon, 28 Sep 2026 13:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311B46B00A4; Mon, 28 Sep 2026 13:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E11E6B00A1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:32:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 946791202AF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:20 +0000 (UTC)
X-FDA: 85263864840.19.DFA5186
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 08093A000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiOBtobw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8v0HMtdYSmeR7hSMV83Y5zxCj1beVOpYUQy4t0SZILE=;
	b=DZ48b3StPoKHnTD1la8brfXzBedpJQTackkUFpw4N5+q3buzdsRgvaTuSjvKvPJN1flUbB
	ku/GyG3fg9gcSxcTBnI0V+wHxaPLhoSYZHeWgCeIPnxa/iZ/Sk7WSL9elyqfYZzimwK7FV
	ACXT6Yas+movDSv4c4GkhymO6blFako=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CiOBtobw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616739;
	b=noeU1G73Pq/Y+RgdY5n8Q+HBqEKf2v+MdjqE2Yc+DuBbIEtUEqodEGhsZ8R5JNZFzCG4DU
	hxlgY3sh/jYFj5dxD1sN3yNBqmoD6RuVKhZugYOKRqCWB1ltlHgZa8c4ULdJsddagSPMei
	KkWm5LYae3TbQrX29yig1tSm7VDgCiQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A3A4601F0;
	Mon, 28 Sep 2026 17:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604931F000FF;
	Mon, 28 Sep 2026 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616738;
	bh=8v0HMtdYSmeR7hSMV83Y5zxCj1beVOpYUQy4t0SZILE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CiOBtobwfu4y22KpWjQYigG/SpghA3ZMlFopVsdnLt72agD6Na8u4zEaQV1gDfh/R
	 vPhP2hluuNYNnSKQ/oHFemJe2nmSOsG5hEzgjoBbn4FmBi94jSRYmehzmjhl+smP9k
	 Ynk0BgeUjd5wjzXn25xE16bMc897uxA3eya68pnLc2QlFHAtS0MZ1lnaq2WB7u2ZK8
	 fuY4ufUCglEtqbXnKVuv0r1LdgP8eQ7+CKClYlZnICwdD8HHYQyB2LaDjPAn/PX5Tj
	 Bu952lnXnp0ztfZLVtYiYzSRtQ62djuzg99bhr2cV6f05Ooqt3Rn776dbFVVVvDNdJ
	 JhQSWw0Ks2zVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/12] security/keys: Allocate key payloads from the
 secret pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hildenbrand" <david@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Michal Hocko" <mhocko@suse.com>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Kiryl
 Shutsemau" <kas@kernel.org>, "David Howells" <dhowells@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Danilo Krummrich" <dakr@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Baoquan He" <baoquan.he@linux.dev>, "Nico
 Pache" <nico.pache@linux.dev>, "Matthew Brost" <matthew.brost@intel.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Rob Herring" <robh@kernel.org>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "David
 S. Miller" <davem@davemloft.net>, "Alasdair Kergon" <agk@redhat.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Barry Song" <baohua@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Zi
 Yan" <ziy@nvidia.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Peter
 Xu" <peterx@redhat.com>, "Dev Jain" <dev.jain@arm.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Will Deacon" <will@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Saravana
 Kannan" <saravanak@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Pedro Falcato" <pfalcato@suse.de>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Jann Horn" <jannh@google.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Usama Arif" <usama.arif@linux.dev>, "Serge E.
 Hallyn" <serge@hallyn.com>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "James
 Morris" <jmorris@namei.org>, "Rik van Riel" <riel@surriel.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Dave
 Young" <ruirui.yang@linux.dev>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Alistair Popple" <apopple@nvidia.com>
Cc: conor+dt@kernel.org, linux-fsdevel@vger.kernel.org, robh@kernel.org, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, dm-devel@lists.linux.dev, kexec@lists.infradead.org, linux-arch@vger.kernel.org, driver-core@lists.linux.dev, "Eric
 Biggers" <ebiggers@kernel.org>, devicetree@vger.kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-7-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-7-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:32:15 +0000
Message-Id: <20260928173215.604931F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: jat3i4s4mqimsk1rnm4jdcpj99wq6jb9
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08093A000D
X-HE-Tag: 1790616738-224190
X-HE-Meta: U2FsdGVkX1+VIL/x1ES8+Z2qL29plA7ZUXurJFXnlL7zeyoZNMXLzclHgg+rZVXH5cJnYDnWSPpRyyt9QRAcjw1750RHGLM9tYO2rpNWCuwzVOgAJSlAnmOTydESM1/zjbGYCzgqenr6ivHtccspgJLCrpLgE48pny5RGmGZS6AJ6dT3fi4xPvrjQKtUwwoxBNh6sQ7yhoabgtHWwIe2yLjiC8xRP7DhY2rEX7a1PUXmB1Y+/9LhyJKKlidVLJoQaPB/TtcjkxlLKh2a5JHsAwBMlX6ENaBL5N1c1jkRA3S/DfDTZNuHS3uHXZvSuRfW2n+SY8OktcCrEkkseWgbjO+KELfYR0sh1qyUxcxjX8+yksUiUNB78rQKqkQ4MpHxHNbZThagg2PM5hBb9RKLRT2rNNXw01IfgzVTeOrB+oIrmW0djnWAY9pEVFJNhqANmZ7Zfdc4zQ7hA6Eky6z+x0rSP2GCnilLDYhVV8hDlz7ojs981up/44RHx9Toge1Z6JEVDJ1VhnYtggbSn2LEbVGvORaoq8BbICI91dGmVxEk+0KpnFgWIdCAzRfwn/x3U7zcQn5dkrIbfsn1spxaZVqxQddtpsd70R8a144OtAxOnguVzAHL5x+jK+H+oMF6HpX9ubRCjdqxhWBmUK4RKD0PCWZXdZ4Iulc3WBaQDjf9+U0iaWSv9zcsHJDOyhRzEV3JbqRb0XzjJz0aSIQMcMDUqp4Rwbff286cBr/NyrHTXfxOtgshqHlpjHES/RL8SZQWPzCMygkLQqAz0QtpL7w0C4pYrnktd4fPlkaq+9OkZoydKGht7iskgIF4zifh6kHJnkYNuEr7+m/gbTk/idMM2L9y3s2QIS1HdwwLnB8ObJXIsqWr1iUdQJFvv4pQbocmG93LvIga92EKhIDHZLZy4mzV0HPW6McvZwiTqRy0hveSUvnYEJqzeUEPB0/XnQwTqGbph9ZlpF7FQmS
 zDbZ6RQa
 oCyJeJvVjJQxoDErNtOyIudqvun47739YGCu/CtJR1Hy1eMFCzaJJnPopocyw0AWlJ0fsqC4AlwT3CP1aNoNLjwcykYuS+TFzby/OX4/IVoghWUjgJDdRr4zestgjL0bj4Nrlu5geffFvWAqyRPJ+3yEprqrMemTxuQrQpIZtkbdLVjFuxDmFT/M0TXyRRyBjFI7C+kh6e3KX3mDyiGcD6vna7gW4qQ+RpkMh0wXqVAwzhZWVJb4G6vsgxn2/KQVs9rgs9ZiWy5+tBgvuk+CrXIlDh5dxZwIChhv5lUz6uTDoklmry5DQYPS1BMGpnUReq9T3iHqsYaJ5q5uY3KAqTzBZPhf7GrrCGDEgRnkIyBDrgjznBLOj4658Ul248otrjQHzJ/Ki1AGMuw+Nx9ASZk5qSZ92O5IfbXgcVyNX2vV8zq0FS050oz5D3PPbnliIlxkHa7rBUrn7UnzsCIxG9RYDngjXk+liH1uSxwl6Y7Un931jOLwS8W+1qWnvw9ecU4gAoJdWQty3YhWUJHA8sb+v7d/MmU/rjsy6jOEv7361rWyBfcZHwj535Uoo7PXQCzi5Lt3IXKbv8ITpKUFujN8jymGtoWdfrflYN5NtU3CENKcuxxxH7+tnuxxZPEMMtQN0NMBVbF6O9To4MZoaIziep23HSkwgY+GXzosBzFi1Cks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Key payloads sit in memory in plain text for as long as the key exists,
> and a kdump crash dump captures them along with everything else.
>=20
> Allocate the payloads of the user-defined, trusted and encrypted key
> types from the new secret pool, so that their backing pages are marked
> by crash_memaction for the kdump kernel to wipe.
>=20
> This commit covers the key types used by dm-crypt/cryptsetup. Additional
> key types can be added if needed in future commits.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D7


