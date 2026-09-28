Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5D8CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7596B0098; Mon, 28 Sep 2026 13:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EB06B009B; Mon, 28 Sep 2026 13:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB53A6B00A7; Mon, 28 Sep 2026 13:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF08C6B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:35:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4013D1602BC
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:35:24 +0000 (UTC)
X-FDA: 85263872568.11.BE5523E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8BCFA14000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:35:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVFu0Pkk;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616922;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVeyl5juHc9NJdeD8w2LctoRHYEP7jkGYs5FqZyrwKE=;
	b=aZPuAdTebbKMJjzgFm/mvD11sWgeEZWx/u05Ho+qbOoHMCHxgHJUbMbxIdgEc88tY1dTdU
	zBOs/iZNqamAkPH9D1dS41QqKaPOD5X+v2rCm4/5A73hDTN4FyBd4d14KJtmJiT5WCtJ4U
	4EKFVVzdgp568bn/TjgKrdQ2pxjuAwo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EVFu0Pkk;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616922;
	b=7KldtQmMplOovtIc9OPSTriIUV4liFYoPV7PgugyP8dKrD/WBvq7C55qqt/mjwsGM+PVlc
	GOMMrlfBfC3OIaVlH6akJNLp2eZTx480/wAqEVySFaALcihzu2M1VD2evawwN/038DAlCk
	9tSHiOfKE/T0LztBmgqAHK0qydSlQ9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A3304451C;
	Mon, 28 Sep 2026 17:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC3E1F000FF;
	Mon, 28 Sep 2026 17:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616921;
	bh=QVeyl5juHc9NJdeD8w2LctoRHYEP7jkGYs5FqZyrwKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EVFu0PkkUr8RV9mJRyKpyqQI0KLTl3eJ7cm3rD0eHUOrJFg12gdP4hTIhrBrQLcqx
	 DbGbKJ9Pqs/CzWQkWJdwqFfS+uxZ7QMpVc+1ei7HjNk0Y/WemxWbLjnkULJ4JUT+De
	 CQRCq6zo9B7dF6dK67pIoay6PE4C8hWugtefNItCljakS0O50fVoIIu3Hu/+Drl81P
	 48KDHKDvUXHIVv5sle+bfB9fb2uOvwiWutpb2mamcMMiXF3zon9LfAts50zpG22279
	 eqlSNWYkYSL02mUPtY3yW819sweAPRaC0NtyWCu3rqUbN4JJhqMoUI7sjSowtv712Q
	 g/nBMfMVK1Bpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/12] arm64: Enable the crash memaction registry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peter Xu" <peterx@redhat.com>, "Mark Rutland" <mark.rutland@arm.com>, "Mike
 Snitzer" <snitzer@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Gregory
 Price" <gourry@gourry.net>, "Kiryl Shutsemau" <kas@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Will
 Deacon" <will@kernel.org>, "Usama Arif" <usama.arif@linux.dev>, "Paul Moore" <paul@paul-moore.com>, "Saravana
 Kannan" <saravanak@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Dev Jain" <dev.jain@arm.com>, "David S. Miller" <davem@davemloft.net>, "Rik
 van Riel" <riel@surriel.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Danilo Krummrich" <dakr@kernel.org>, "Jann
 Horn" <jannh@google.com>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Pedro
 Falcato" <pfalcato@suse.de>, "Randy Dunlap" <rdunlap@infradead.org>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Muchun
 Song" <muchun.song@linux.dev>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Byungchul Park" <byungchul@sk.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Jonathan Corbet" <corbet@lwn.net>, "Alasdair
 Kergon" <agk@redhat.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Barry Song" <baohua@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Alistair Popple" <apopple@nvidia.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "David Howells" <dhowells@redhat.com>, "Rob
 Herring" <robh@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "James Morris" <jmorris@namei.org>, "Dave
 Young" <ruirui.yang@linux.dev>, "Mimi Zohar" <zohar@linux.ibm.com>
Cc: driver-core@lists.linux.dev, linux-crypto@vger.kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org, conor+dt@kernel.org, linux-security-module@vger.kernel.org, devicetree@vger.kernel.org, linux-integrity@vger.kernel.org, keyrings@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Eric
 Biggers" <ebiggers@kernel.org>, robh@kernel.org, dm-devel@lists.linux.dev, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-4-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-4-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:35:17 +0000
Message-Id: <20260928173517.CDC3E1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8BCFA14000D
X-Stat-Signature: u94f4hmc36yw95qdnrahyu8ni4nfzox5
X-HE-Tag: 1790616922-661239
X-HE-Meta: U2FsdGVkX19GnJnKRyVf42lo3G3h4p0UYPTEKuzNpT/cE150KkbzYm57JQ4at1EMd1Xq6owEoW4kJ9cUS+eUks5nPcOcZ/5sZVoKUsZ/wnorpbUUVDdFajfOlfwKuImjCleL6kzccin8/RvQLO2GT81qqkxx6YbXXoukMqlVxyZ10/bukwcltvTMBq/1LDjunepDGhn5ezNJauaJ/QjSXrzS+VVPQfVyKkJFy6JvXLYDimhNG9t0nPuC0fhanwAnXTC9waAm9ul8hHlo21XG7p/kDGQJ/P9ydho/H862z6pPtk45YS2j6LJBhg4lls36ZWfCnx8U8II3Ll0Vg33HG8nfHjX8bP/qFeFD/7+hEVFT1iouYu8RL3y57N21rtKRVGCPvT+g8rwcaDkkC1RjCpaDIQ2uypMcn9mV+6NCYsVlHlEIpx9cZrkWuOXbNJ37s/W1zfeIZZHechE2sB8JEAsOWsHPbwtqVzm2HR2wb9h1uA7hQhGIBixT5iArbra8UWoTv5onrmdHtqInARSfJKiRZKNWmfluP0CXmJn0Vds+GWXYUOxnMSgnpfhgCwk1Qf5x66NsmrPOPqK5vwUgjPXBVlcaQPrignqIXhfBnBb+Xdq5hofVoWAs5ziJQCLjGqStMi/3Rbu3RFoleOyB1IWFdzuS68MeYzSAInN3h5ByDREIPwCVAXz+kLc4y+swGLDLnkiz3TEGz038XuhUnrtm9trYViQPSIHMObUxd84LIp4gti3AYOzGxez+nTkyBSLmmKIwsCRfj63hoy2IwqLh0ISEOtAvzEa7fJaYwpuLT1EVRyLY1uC0nCd5TZXuHrGRD9RZHogQJIIASCJrAM8OLaU8xCnm7IU5AOWWnGLJBExFfVI9eKvO07CG0Uh3/HDYYWztpjJy0bI4WuJfAvIf13PKdUzPXBhuXW2BLIDs+OrXi2Lhq1nuHNTkeKCXbW9HyQmFXSR9xuAzJY7
 EJd0BTSu
 uMKcSKSS1cSC3koPiMwlKdAystyX8DxTst97sT4edgy3xQBFEDBrMZQvY6d1ns1kdpLbgECpsqR7YMmQlp7xeP8sa01dXcbY5LKz33ytk0DOOWb6VlZaTv2sGvmEWuUEuRYpRDXwORi2pfFneTbWd83Y02I/9Y7ZBgITyBI70FBPa+c+lpXnTf0tsO7UxotcE+8rv638tLPEHIUi0CJHdDsw1EjbQWeaD061IREltrqTfptb0btQSjUUR4vPHqdspYrBDSoDDXDBk803k1wbjW4L8YEzzdlZ+y6Z+ppGjFYnaIn8XDY3nD3P1jGdzIuoTkbYOeGOgVtDbi0DbNjFKga/ecKGxUEsxSO7YhG2eyXCC0PtJyvcE7YuMSc/XqYnC+ZB4+Vw67XIm9gybUOh4aKVDQqPHed3NDqtvyo5VYkuAL1LKdarmrA3Ynwv0oPIUFu2GpgXd3svAwALd9N1Ki4W7CW2VMCwrmAlHhfphYVBDXDGzgYqLGWTWz+u5lzL0JJw8q/usrGs4i8lTAjTxvBeLdhahRYuING0MgQQzCi7fStdlCBHUQsDMWEqh5vdFlPjoZUD3eEdUhBj/FD77iK3LjOzu3wygEH/UU6KyW22MHsLU3acLO7Vi5s4CaY9QSN7Qw5jXg6Nm0233B+W5sFkBerHlsOSdxgXEPUMffHM/qOUMnVk1KIQJZ99BaN28xyUYs0C5Dq+X0ukLTGhu6OicketKtEdx/d8PmzTLH5GDMCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Select ARCH_SUPPORTS_CRASH_MEMACTION on arm64.
>=20
> Signed-off-by: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D4


