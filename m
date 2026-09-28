Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6CCCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2BC6B0093; Mon, 28 Sep 2026 13:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92E66B0096; Mon, 28 Sep 2026 13:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B818F6B00A0; Mon, 28 Sep 2026 13:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8306B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:38:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA3C01A02A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:38:34 +0000 (UTC)
X-FDA: 85263880548.21.86D175C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 407B0C0002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:38:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3XNkJUM;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nU2fH54lTM/XVwJXQyjGLBeD3ZciwzAWp4eXcqDvdbM=;
	b=Y6+oNUjFdJDs2Ta7PIxS20VXLqAQCL88eHMy6NfvhQBa/w4g6qchl71u7Djeno5hRKEU0s
	/KPEx6otgVzEJeqZsbW3C229LvzxFMkdhrAkSAYo6ni6PiVnbwQlSST84ITgFOverKopdj
	gRVMrO0Dz11nB2/TfW84TP/s6m0N/Tk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3XNkJUM;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617113;
	b=S1sKlGhDkVC/NZy8Oj5eTpEV3Asft8A9Eue+SYcVzKAL/hKK9BVSaI45AT44NZNJicfcLU
	n23/MYi07W6tqu/sUU0jXrtswOWTZePw42s6qXDAyXjmkHT25V2BcQjPHW6IP3xwuJxjSW
	NoB8+Lg4fvkGudLVMlXi2K+Qu2X7A1E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52E5B436EE;
	Mon, 28 Sep 2026 17:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9521F00893;
	Mon, 28 Sep 2026 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617112;
	bh=nU2fH54lTM/XVwJXQyjGLBeD3ZciwzAWp4eXcqDvdbM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S3XNkJUMsfb4UVOiI5bqkQdMQxSrtSwJSk+zko+Kb8nyx1/fqNP+w7Q7XMX4d9LFS
	 UpCy7pFlCeLa40OP6BXCxLJAzMBOd9S9sxWq8L8Jtt8orYI0l5uqfdJZROyth2vfib
	 5uQjGgfd2Z1mVJgCwOGmsJxkE0gLFEG3SX22xLC77eFkOJMnQzLdB37T2NqjWpNoyp
	 FTppfoE54PLRaqkGfhCai4quB2BGHu9vVrE9Ttd2f5wdvTQz58p7klVEjZDYk8ILzq
	 0uWbZHan00HjovXjqsXB+ZjTvra2/JJk7Xr6L34CRAqtG/8M4oLEVkPLj0ZgwqrtyI
	 1xxzJXt9dk+iA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/12] kexec: Expose the crash memaction bitmap in
 debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hildenbrand" <david@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Jann Horn" <jannh@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Will
 Deacon" <will@kernel.org>, "David S. Miller" <davem@davemloft.net>, "Harry
 Yoo" <harry@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Peter
 Xu" <peterx@redhat.com>, "Mark Rutland" <mark.rutland@arm.com>, "Usama Arif" <usama.arif@linux.dev>, "Rik
 van Riel" <riel@surriel.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "James
 Morris" <jmorris@namei.org>, "Dev Jain" <dev.jain@arm.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Paul Moore" <paul@paul-moore.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Pedro Falcato" <pfalcato@suse.de>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Alasdair
 Kergon" <agk@redhat.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Rob Herring" <robh@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Barry Song" <baohua@kernel.org>, "James
 Bottomley" <James.Bottomley@HansenPartnership.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Randy Dunlap" <rdunlap@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "David
 Howells" <dhowells@redhat.com>, "Saravana Kannan" <saravanak@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Benjamin Marzinski" <bmarzins@redhat.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Baoquan He" <baoquan.he@linux.dev>, "Dave
 Young" <ruirui.yang@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "Byungchul
 Park" <byungchul@sk.com>, "Alistair Popple" <apopple@nvidia.com>, "Lance
 Yang" <lance.yang@linux.dev>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Matthew
 Brost" <matthew.brost@intel.com>, "Suren Baghdasaryan" <surenb@google.com>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Arnd Bergmann" <arnd@arndb.de>, "Jonathan
 Corbet" <corbet@lwn.net>, "Mimi Zohar" <zohar@linux.ibm.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Gregory Price" <gourry@gourry.net>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Mike Snitzer" <snitzer@kernel.org>,
 =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>
Cc: linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, devicetree@vger.kernel.org, linux-security-module@vger.kernel.org, kexec@lists.infradead.org, driver-core@lists.linux.dev, keyrings@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, conor+dt@kernel.org, linux-crypto@vger.kernel.org, robh@kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:38:29 +0000
Message-Id: <20260928173829.9E9521F00893@smtp.kernel.org>
X-Stat-Signature: ceu7iqznszmq11dytq45q9xxcfedncpq
X-Rspamd-Queue-Id: 407B0C0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790617113-536904
X-HE-Meta: U2FsdGVkX18FYMAZtkorgkd9PNbIWbTYcbFL1fnSDiPrJyS08CqiJAsWYqpskFsZCe7bLFAPaGmcY0PvvsvDbz8SumXariJCBlzDaM5sEfFcwyWv4BPndO8mv+zKtaIgUMEGLu5B8W7w36fLV1iV0F0kB7IC85GhSV7PMfIQVK2Bm8nI3Y/ifO2guSb9LNo60m84XLYlHVdfu+PHySPRdb6exfAZgPw1GrQuadHFEmnC+aQZvkP475xmZ5jL99BoSA2o/6HHTEo0NQsMVgjIcecKxZ4AHBhp0ZpA1x8SAWWAYi2nzwQcIHpfLdsL+OMGlfTT8yEDhZjSCoXZX1h/4v5vmNlkVHP3V4Ptdm1SdYSZrm4tTZvMtRrBPtgtrSkQvtPo6WU2NQx75WuGy9QaefVD4X9K11rBe8+TVTSYBIGHdmY4UaVtpnbi66FZIoI0m5xga7xmNVXjxEkz3BNctEJzEuzTEizQ4zf1BCoYDAS3C2zf/CXIeLUOxGpZOwO4par/aO0YzrvvhzpyboOXz8rhcoxn8xVNRC2qVPz6xmxoSAiGQY42nq7l8F/Zmhm7jPRbe21PYXSrOUotFvSpB8aUaw8aeT3rVrbYyurBDQkutNLQjwKajlHep7gtEz8999JJ2n1E+Hwhvgsj06UjSFhg42SvonMG8k+/mkqbs9z6cpKo008S5jckZ/kc4xHGbmizNatMn4Jsl7FMMCmiWDTHFXAOLe1tmaYXeEx3rdfvG67zGXaKeFPHySXxc9uJDSSpchcp7OjBXvfx7O4IRBPsxr3xy/kAdrZ8VFyymYRpWuw1IvYTyW4u9WmsGZJzlcy6W8x+TojNsDTtS0oA6PPZP3niwtZDyYshh7KKLm6xev0A5Hnv4IiaaJLkuNnJ+Vj86rZOVLFfz2Bi6srdisaYK7tD7kwkqAPXoJ13Uq6wIHdoAvQ9exMqbiccXx8vjRSuVy8XhkTqPmA32y3
 Avh6dKCo
 3JkX7L7MM7kfBvpJeBiwDnAVFqwenhDo3ZVyX1BYgO6mNOqnp6MhGssqpnpEJf9BK4KikP28UNKX/jeiCSTR6NTrHrqhIxjJ10b9WauwSoCQn+mzch/qHnYNEvX8vsCadJEBSVPSeR1qFv5/p7WM18En3TYZB17dipnptCcIkPdy8L+WKr7qYYJXkVbwfffACc92NihIfYQb/wpQJ3oZdyI7XlG2cHsF62Aq+qk+JDCKROaBI7PaPkw/nw09Bstzt2yIy/TDCNGPipLQvTCdi3Bm3Qo98K/pleCVQP2g8MSbu7Gst17FpR4cwmOZP7lgkyp+oHH8W9NkkpEyZtRlS77nYd4gryf4wI5boSdA2O+v+TWmA9jmrLk3xcN8DJXDsViRo9fR1oKcB/n4wNpxpHifHBbP/S5I4YjoAw7SemC6y7N3gWyuyGlWKKJ5xIKcgOkBqDswBBCJWE+RKWEuQnnTrwrDf1fhMK7eHhWheCF4vxBJPn4xwCkcMPgcGXZ9+W/Zh6XaELkuBRxwKSYLZIT1Vm0tAP02Elzu7LJpu+P7Xe9KRa30u7FtS9c1HbCr37GKD9PA8u7VAYOg0rVJLwwvY4rChlMYYkl3MS4WBRagUMroUq+zM7MwaFC3L4uLi3MDST2qa30kY9K6XUvBCx3A4kJTe0X/pw9NlKDRPBlu9hmo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kconfig: syntax error due to insufficient indentation in help text
--

commit d0f9200d03ebaf0ef39b9f78a15ab259102ed7e8
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

kexec: Expose the crash memaction bitmap in debugfs

This commit adds debugfs support to expose the crash memaction bitmap by
creating "regions" and "bitmap" files under /sys/kernel/debug/crash_memacti=
on/.
The feature is guarded by the new CONFIG_CRASH_MEMACTION_DEBUGFS option.

> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 3cdc8d459ac05..b5380e16bfafb 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -204,4 +204,18 @@ config CRASH_MEMACTION

[ ... ]

> +config CRASH_MEMACTION_DEBUGFS
> +	bool "Expose the crash memaction bitmap in debugfs"
> +	depends on CRASH_MEMACTION && DEBUG_FS
> +	help
> +	  Allow reading the live crash_memaction bitmap through
> +      /sys/kernel/debug/crash_memaction/. The bitmap is used when

[Severity: Low]
Does this indentation break the Kconfig help block?

The first line of the help text is indented with 1 tab and 2 spaces (which
is equivalent to 10 spaces in Kconfig), but this line starts with only 6
spaces. The Kconfig lexer terminates a help block when it encounters an
indentation level lower than the block's first line. This could cause the
parser to interpret the rest of the text as an invalid Kconfig directive,
potentially resulting in a syntax error and build failure during make confi=
g.

> +      CRASH_MEMACTION is set and when a crash_memaction cmdline param is=
 present
> +      to tell an eventual kdump kernel about the use of certain memory p=
ages.
> +
> +      Note that this is a debug interface only that gives no guarantees
> +      whatsoever on memory consistency.
> +
> +	  If unsure, say N.
> +
>  endmenu

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D12

