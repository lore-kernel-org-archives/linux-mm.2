Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F2B5CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C356B0088; Mon, 28 Sep 2026 13:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D186B0096; Mon, 28 Sep 2026 13:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C936B0098; Mon, 28 Sep 2026 13:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DCFC6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:50:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE199C02A3
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:50:11 +0000 (UTC)
X-FDA: 85263909822.15.2214A5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3C7FF2000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:50:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KjJm0noY;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJBj7jrhd8l/3+1i/MYD1Oe07SV8AbeGkY/QzpcIlXk=;
	b=qoqu15XplReucWC5xnZawZY/QG+4988f9FG+wLSJPXQm6h/qeVwiiF5u4gqcaapFNYM8I5
	uJG31uZ+pZxxz2bg96Zxkvsctxs6OrPTKIuRxni9yzu9SGlKjBH9v39C80BK9M1cpIWDu7
	A++FuTdXgq5S7DlCPNI7D8m5HxGpexM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617810;
	b=erjA0mE76lnb4vlMq69b+SnxPlRKWh6mniH6NzHKmcF8W/VgZM94iE7kozO0bzBWL4ZOzx
	KtshS3jrryIzFbsogIu2dJ+YYa/vDKevXWZK7KgqxKhumKl6DGZUelvaPTtunf9XwltEnE
	v7uAfvs4bjiBoAHudjsanV3ed9VsXQY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KjJm0noY;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5674960120;
	Mon, 28 Sep 2026 17:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F290B1F000FF;
	Mon, 28 Sep 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617809;
	bh=dJBj7jrhd8l/3+1i/MYD1Oe07SV8AbeGkY/QzpcIlXk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KjJm0noY+sn5WykpEMYX/0cqYF5OZAonPsiiMo8gsrJp3dbtWXzQ+MUuPiGJZJA0x
	 6jLqI4XrjH/ECSiSdsjKSDEcOX8VHNjxTUmFetbOQTlOnUn092Xi9vWRpAgkcyI7cV
	 VEdR4+s8FUt72QAhYPACB1DPHc7Kdjz2uCMGh47V7dCsVAU9tDI9stHRuVWg4VowUL
	 wsubuRL7tSu1HVvPbp8bYrkCi5Pwl78yS8X19cLVqL1XZl7poDdf3RukkTBc6rpsfh
	 AjjBKhJEyZefMZQzGawiz22PfrG9g5f1MlSZXvtXI+fxD2E2qzuSdugjHmvJG38tDb
	 U9iSc28s9bD3A==
Date: Mon, 28 Sep 2026 18:49:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jan Sebastian =?utf-8?B?R8O2dHRl?= <linux@jaseg.de>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Mimi Zohar <zohar@linux.ibm.com>, 
	David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, kexec@lists.infradead.org, driver-core@lists.linux.dev, 
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
	linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/12] CRASH_MEMACTION: describe pages to a kdump
 kernel (was: CRASH_WIPE_SECRETS)
Message-ID: <arqli0H0v5qPG22z@gremlin>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3C7FF2000C
X-Stat-Signature: 8dzy4idajn95owdrtijkdge5xmzujwhq
X-HE-Tag: 1790617810-223180
X-HE-Meta: U2FsdGVkX1/lg2UJ5GhVgEPCz6tf4p4fDYr0W78mcCDRcyWalVQ+sc5F0jdbA4gGr2jOvwWWPVqYTIdu+j5enVJ+Qkot1kveGB7SVftOAaK3mhx8m2kQRcr9RSOu4L69WLsb9ndIUD5+a/58eeiVJBPRReNDB9z1Jb4eedYo6AdpHP7Be/jFz/TJhqR4YSJa5LkhHIaWML1wOhxKV603A0N98pfsTChk1i/XVQ66RLidwRI3AA+UlUK7+TqByUOGinWTMzPvf9S73ePpDqTeeMiuWNKWhzmgHbNztovhduRaL3b1PrKiR9qDP+S2pyRhXkikijAP5HYsIPMqxXcNawrE2OyWytYsuJuUiJdOcWmsGqibcYGLOp1DFTuyA6OVfdFOu8tbeTjDgvGL5R/MzNEMZPQHBLQHbs4DmXuT3GalRMGV0VccHXmJKHPM0MoTAreeiq42jrkCCzp8+KuGMBU3oDuzRkgMB6D054HEYi0oPYh7giD6GG5uadJ81CcwPrceZpRJ5ciT9vYcZ4XHChql5gi/DLJLI66nAnMp6z8CGjUQwbTCvpcP0s3DZzZn5xT/XQKc+KgexjzQwg6R0vSoakL0aFqzAr4JIZqBYWpXslJSMdnZypsdEAXtgU3fJdayqruAwPX1Rff5M3ohqou1BwEKXp9sOsps1Ajw8LDxQQQZ7YAmugJ3zCbdmVPMx8I07YqOFOJOy1frvw0dN9RcxgvVHC0657JuWRiVO1M96IH3410Oc4gE1wG3ebOHp1J+Xs4RPEX4EhnvzfZI9srVamvFtL3SSHq/b3+R6ptrsGmhupbj+FgH+3hY1JD2wPGnRC2i/mjKaAYeBvRO+AiqEd7i6xlI+3he+kKFR0+4nZ4KxCpJMKwjrxSli3dVsfzsYtAxnrKmSE7Iu6Pr5tySYKapaXvTzBH06AOvlzLFNRWripbCrS/j3qugsvtBf3UmDJA2i4nLz8djwCX
 hDN5Viqm
 JH7PVwwngRpyx3tmLUa+ZGa8pTQT1U/t12/PpVUnsNgKrRlfda+XZgCxB3PJyDcjhccoeNbjXpmd9AHac2HgzsB645HIEaXWQb9by5FTXF1E7IfqVW3HD49FHJ+HVmsuc9wzrsp9EP/vTysUW3Zy2SEudgHtF5VgHtYZnDIL90MAbPYc8Ebl24cAr5PtRhhOwHl0cyeiZz0M3o05wiuZEWI+U8m4UlN9uBxazG1N1/lf1x4yZVQ6unXwOCaO7x/PVA1/3JCD/O3YpYnSo98eCVPdEo5Ca4NI6V+2paMQk5V9tHD+fnZqF4QjqYZdfjIkjV+VjnAPHWzuH0x7lPUnwjdyyzIT5GP4MUqsxBE/o1Cd202n0jLd1Brzx1K3OcHQcaOhhQRvE4fhL1ODFLW31bx34Kl0gViiaC78ka+MH12/e9r6RfYIMsGsVvpvDJUSw+IXr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 07:17:48PM +0200, Jan Sebastian Götte wrote:
> I'm using linux on an embedded target in a Hardware Security Module-like
> application. One requirement is that I want the system to be able to
> quickly erase its memory when it detects physical tampering. I'm
> approaching that by using kdump to load into a small payload that
> instead of dumping RAM, erases RAM frmo start to end. However, writing
> all of RAM, especially on an embedded target, is rather slow. For this
> reason, I propose a new crash_memaction mechanism that lets the old
> kernel indicate marked memory areas to the kdump kernel at page
> granularity.

Sorry this all seems really invasive for what seems to be a very specific
use case.

In general, with big changes like this, you should send the series as an
RFC.

Please send any future revisions of this as an RFC.

The bar for a new VMA flag, a new madvise() flag, etc. is really quite
high, and I've already noticed what looks like quite buggy code glancing
through.

And again, I really don't think your case sounds all that compelling for
general users, given how invasive the changes are, so I strongly suggest
you rethink your approach.

In any case, as a newcomer to mm, we really ask that people start with
smaller changes and build up gradually, a change like this really should
only be done by somebody with an established reputation in the kernel.

In general re: AI-generated code see
https://docs.kernel.org/process/generated-content.html

	If tools permit you to generate a contribution automatically, expect
	additional scrutiny in proportion to how much of it was generated.

	As with the output of any tooling, the result may be incorrect or
	inappropriate. You are expected to understand and to be able to defend
	everything you submit. If you are unable to do so, then do not submit the
	resulting changes.

	If you do so anyway, maintainers are entitled to reject your series without
	detailed review.

Thanks!

--
Cheers, Lorenzo

