Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F8ACA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F0C6B00A4; Mon, 28 Sep 2026 13:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 116D76B00A5; Mon, 28 Sep 2026 13:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0541E6B00A6; Mon, 28 Sep 2026 13:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3F096B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:32:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B9DA1602AF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:57 +0000 (UTC)
X-FDA: 85263866394.13.D67A986
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B93A7140013
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bs8gZl21;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616774;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UO0wORJC7A11uXsY7WzcFB5vHpZoMgQKuLqNvmRodkw=;
	b=czJxU/XZYPB14MfCpZFQgBMYFjTUQkKW9dSBEcoBSEqbbk04H6AbjDE9RX+Psq3bt4DnKe
	ICh9US9ixRMni01PNC6VJyaDZO/YLcC+q0ja68KE3n5jd3pTw6W+29QXEeEdHk5UcKYHuY
	NAlAQGe/fgl3ty4JT7BRFW9iHRrLl6Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bs8gZl21;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616774;
	b=DepMN86+kwPb8ZxQxzLdtXEGKb+cwOBbbbls6tEzYjCiG+/bv6i9mR2VHQbr5mz8xJn8qX
	arbJY7Sy33WZDhwPhgPUaNbhVtd4HmpMAquELKzvwtNAt97bSBytKoz+YOrwvyiOmdb1yu
	dvgdk5GYUSC0NGnf4Bzjer+0ddKrI9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7983410A6;
	Mon, 28 Sep 2026 17:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AAB1F000FF;
	Mon, 28 Sep 2026 17:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616773;
	bh=UO0wORJC7A11uXsY7WzcFB5vHpZoMgQKuLqNvmRodkw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bs8gZl21EgXlr1ogxYmUKhEdGQWh/DAKFrR6vbipZPiBabZ1/ok6G279uSZM4DP/4
	 ejCloOlcoyCGBYgFxGf/57WgSkGZLso7QrCbJr8OgGzpc14kNkCT/I5uSVcJCUCBhv
	 Uqc9UpdAtMOGV1gznAP5SEf3kyCXDUuUKPM6oAvpbmATlCiWByYLe0Dmq25P8tRoqj
	 f/KStFDA/LQFsI/ox53s9PlgHfilT07LYzA2mlG2LTeDfTuKB0DJ+LRL/MPOcotAvv
	 mxi56tP/eLXb39m3eXRARWIyCdEJwqSYfVuOwyAMruQjB5h6YnuAetngetfhxwNu5K
	 wt1eBGoHMX10w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/12] crypto: api - Allocate tfms from the secret
 pool
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rafael J. Wysocki" <rafael@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Will Deacon" <will@kernel.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Byungchul
 Park" <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dave Young" <ruirui.yang@linux.dev>, "Mark
 Rutland" <mark.rutland@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Zi Yan" <ziy@nvidia.com>, "Mike Rapoport" <rppt@kernel.org>, "Baoquan
 He" <baoquan.he@linux.dev>, "David Howells" <dhowells@redhat.com>, "Serge
 E. Hallyn" <serge@hallyn.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Pedro Falcato" <pfalcato@suse.de>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Oscar Salvador" <osalvador@suse.de>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Peter Xu" <peterx@redhat.com>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Nico Pache" <nico.pache@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Saravana
 Kannan" <saravanak@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rob
 Herring" <robh@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Mike
 Snitzer" <snitzer@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "Rik
 van Riel" <riel@surriel.com>, "Harry Yoo" <harry@kernel.org>, "Barry Song" <baohua@kernel.org>, "Mimi
 Zohar" <zohar@linux.ibm.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "David S. Miller" <davem@davemloft.net>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Jarkko Sakkinen" <jarkko@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Jann Horn" <jannh@google.com>, "Usama Arif" <usama.arif@linux.dev>, "James
 Morris" <jmorris@namei.org>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "David Hildenbrand" <david@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Dev Jain" <dev.jain@arm.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muchun Song" <muchun.song@linux.dev>, "Alasdair
 Kergon" <agk@redhat.com>
Cc: devicetree@vger.kernel.org, linux-arch@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org, linux-doc@vger.kernel.org, kexec@lists.infradead.org, dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-6-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-6-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:32:49 +0000
Message-Id: <20260928173250.18AAB1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: d4wqsigskqxwb75jwjwf1iu59bqejw84
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B93A7140013
X-HE-Tag: 1790616774-303182
X-HE-Meta: U2FsdGVkX1/Q4xAzHWGZUxxCBwgaQsQlCPfPJK/IdK7CHy9CqBjk9grWemwp7D+jwe+c8w7zGo2FdwRevn6uMgfL3TSMLGBavRfHjQWS/8iyk4fFuLjdkvxx3Jdz+kKhLQfcVf6+HKYQvSEvYalqfM+6SCp4GJ+iqe+iqheCjjRyuN1a8KfOWbgAjWrh5KuyP5C6lHAopOHxpKqyKKf6qp/9CS/I34ZtdaM7lvTQ3VXv2UZs99SF/0qWwx8I6GkJTZjVzto/tF+R76dbrdTvB2cZUPaZt2q+1OeSOdrbmvirc/dnEVgBzXrQCZVfwoChHff34F6koorUSnnv2trJD62mfDXe6lXxyKjO0CDBTI7rQNzJ5EIIeGJomWJg61RLAjnNdOUY1oi7Sd0gQaWY+2sSjnsFjse+7ltCOb2uN7a7V7/sX130mGbw4EC7mzMSOegnJmMnLgo/YxXhIKGP7sbDW1BUZk4qvINDHm46SDnGwUH7zR23uWOd/aV+zFyinBXS3Tu0i0DyCv0ADFQzSQvitd5xNRcTQfHFnBP7jmerhEOpcGPqt1rNr/OrJs8d6mHM6btX+/N8clcRXW7u6mZe3VfjD9IR9/SAjKsMCgTgDVHgAdG/Zu+3mO2s/RxnGIzaHzrjUkYQpryAs6xRexGYOEstQf3A17D3j+NcRg2QPsBFF+re5fM9ldLFlR8Qa0VD0EhdIYObFEKMGzF6WmKKUEHdSE1zqGltxZy1izY0DNUC3zKqoAEOX34ggywrfho1PcNjmLLiGO1D0I4VBpZz91D4ofJpcBVIM8qYn9KibrmdJ1n0vb98QtMAM66EBSc9Ugq4GlDMrThnzWyjNheriDxFarJlnSESTYuMoUeDQIDmN+csll7qryw9WqkAPtTpnzoZWs/XWjzhyAclM3GIRhmVtNB6OgJr43PRkWgaViJ5+tvXHHHLwS08Qylpi91QwJZOdM1uTiqghjN
 Aqwqpeih
 +xEBTjaGI72sS6jvk4guC14xFcztX1x2AV0tdKV9xckZ+kf564/wOnqIGJUAe9LW0K4WKRynCTjvpdSxh7l4IoKwW3ZmLUqZdsLDBMEmXwyAADppP1S6L/Fd2c/kQ++wFjHEb4bLuFpGjN0LKha6OlMP5HDKSlsMuntVBecdJhcnUpF0jXDabe+A9/C/RvglQe66TANUrJmYRRS4Ea1Qj14cOAWoQOGkhqUi8NEdcwil19LO0kX+DUc6KqXKtHvWMwo6lFUuCwQEZoA/0GcQ8gaJNurjLC9gIarzVobEfCZy2ksRgmuPrjYWi3wSto9uI8JlyzmWkeTc6hIV4iBX+myj7zgLqrPQCmaZQ7wFaEvobJ94T26Ekt0heWT3WsKcFCQZYG77SKeygj9l3QUkO7Nk/smPXtazIG0usLg8zShqERY7OXpMLHnFWx/JP/zGm4tcbGpumg0kHReNutUq7sYAL/0x95oQ88hBXmDvJUEwxM1CVyP3GnykgJt1mKSJCsdCfMIRDPC/zXuSNyy69GUdADbMIuTmRBpInBJWvMqffdjQqUz9kuQCLl+8W59gTg7fIcPzX8veE8Cl1J6EivyMz4rcazn9u3L2gBbX/IyJjLEHEozk43StsGMkcg5yP685WqAQkOCPOfhPavL/zTXsShCOti0p9AkSOTLDOo3+HyXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> A tfm's context holds the expanded key schedule, which a crash dump
> would capture.
>=20
> Allocate tfms from the secret pool, so that their backing pages are
> marked by crash_memaction for the kdump kernel to wipe.
> The context is a flexible array at the end of struct crypto_tfm and the
> frontend's private data sits in front of the struct, so the whole
> allocation moves into the pool.
>=20
> Allocation cost increases by a bucket lookup in crash_memaction. Freeing
> is unchanged.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D6


