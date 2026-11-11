Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5127606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EImt61fl
Received: by kanga.kvack.org (Postfix)
	id 07A4B6B05B4; Wed, 11 Nov 2026 01:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051D86B05B5; Wed, 11 Nov 2026 01:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9626B05B6; Wed, 11 Nov 2026 01:16:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA00C6B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:16:49 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 501621401A3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:16:49 +0000 (UTC)
X-FDA: 85421829738.28.7356208
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B7152180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:16:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EImt61fl;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794377807;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHfiaWxCcZhurl6F9ZemW3Q0LNncHtCBCbMGBWelkuM=;
	b=49p9/nQX4z+BAdSCsI2zcORONsr/JR81Knyq4Pn30XbV3iNeOhKt4yhDLulK9HbiJ8Haev
	uLWuCMReRTcLs0wnJahP2Iqsv4H50YpA3B5M4Y9WHyXjYrnnKAPJVc6aoSKpfzKBsnEMZt
	z8s3hog49C7gCLU2YwPzMjdCeMS8u4A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EImt61fl;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794377807;
	b=NgGMbOqxbYqvUSk76iabJ9Kc0ZbNi64XVJi96Qao4wSNwS1PCw/p6gsvfU7V1JO+rf78eu
	65twOaMKa6s81wwn6N8VVm31uWWRggqSDcwyFNq/ggeJB2q+plI2db4hFvtzG6cOnouJoh
	8zCh8eMEQhAZYlSFayz5s8kQ3zrSNS0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C2A7630B6;
	Wed, 11 Nov 2026 06:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF7C1F00A05;
	Wed, 11 Nov 2026 06:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794377807;
	bh=QHfiaWxCcZhurl6F9ZemW3Q0LNncHtCBCbMGBWelkuM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EImt61flV5cq+7e4hR+ft3m7e7xCstobBu6qSNOHi0GZRaD7AB3LXX/d6RpGrMMHM
	 lwiKJBhIYkVVBiy95ALKfS6qYNOgl5pRLKP8Opd7WFLVXOQSm48YVTbFQ5ctAaUmiv
	 LrNh9151rRHt5atGrFLvwc+vq1Ol/kdiFvqBgWJyi+speMlFnmyJP/b+i/H+aHBIfX
	 SvYO1rGxI/3Tgu2yX1fDFkvTW1qDhgDRUFnvcdw0W6DIgmW1BTuWCTsZl2b7L0SVFU
	 aLqq+V/0C696+ioxmJX5IFJA7ARzQz5QYrbKcogK/13TeXUd6HI65dkA0VCU7pk0L2
	 xWNejiZNeMcOw==
Message-ID: <sashiko-outbox-208414@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/19] liveupdate: Add feature header to struct
 luo_file_set_ser
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, will@kernel.org, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, "Bjorn
 Helgaas" <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com, "Andrew
 Morton" <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, "Pratyush Yadav" <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, skhawaja@google.com, sagis@google.com, linux-mm@kvack.org
In-Reply-To: <20261110050202.529473-12-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-12-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 06:16:45 +0000
X-Stat-Signature: zuzbhb1ag14masi7wpmjnije6ibd7f4r
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B7152180004
X-HE-Tag: 1794377807-808873
X-HE-Meta: U2FsdGVkX1/d7p57tvSN6QuKVTyPyvjsvNVcKGadm6z3fEyT205wnsJ7mbwEXtJiOvk/5HEFXLVTVUKes983Pmb9k7Yz2B99uI7vjZjfGqr1qwgMG1fV9vsTynd5N9403sz0ewk1V28fxLWJGbPpDVI+r1G27I6iJOxiTASRDZEmxiWtf8LF4FG4RtlT4I70AFxwe+F/kh54yIHMDyIJhBhqODUDldO4Dp9QPgdd5WvG5zz0fR7Lb/E9fzXdPgna3dlvQ2m1neopgZi2YLfC4ez03RAepTapjrteUSzuCnThXVkzuTT70n6aAKmSYYSrecpsLafbzXjSpQiqAZcg6MOj3jrGVZDMOlfrahPHAF6KOUi+cWPKcYvybxSL6maWj0jeMZKz2NYcUm9CTbE89BTBRVFsMYbVkdxdKpP8GU6blvK2G0iAQwsRBC2bfIa5NUpyH5Ab1u5Dywcw8lhUWK8ueqfGFKoaXFKVvG5Oyp/D/hBRRvut5qYwcCB+2dBLmtT+vRFtRhc6q+PJ30o/DgDoJvkfeBLe1LKCYwG6U/W4vykWbaIYeclmrgcp6rC1FqoRcszfekZ+Hob6kigvLKnQQmdSssGzIUXk1Np2I3k20kx7jrLTasqcoA8ZqgHmu7kIr+oNEn7eKZVhV/yfjjNGRc9qLUcxUv7XAB5rgz4V9MUe0+CZUrXSjF928LShnOS/6JcUZKbZAriisviyFBEvZcX/M2zWf1QDwf3ONmzmJjei81GsTZoxnl1cQbOw9NfhP/jznhZr7ndSQ2vpDp27gCxqv2XrZjt2MERcSij8zvQjxrM+lamuxQH9QEQr+fJ1pyeLbk3q7/yUJZ1M3W1bbji0JtOymFxBePgOSHAbBh2Z5UOHva4ZTAumK0n+vjOWYQNkxSadx/nwQZLWyacAg6Ud7nTHyGZJvzfBcvAMCW+CjgGv/rZb0MlkfTSsmxncY/uR2ibc0jvthjL
 CHU74k1t
 q41+m9n7UTBKTPtBAKIfipFLKiqqQ6TM6tohF9XgUJ1unEzcxOtyORYzAMD9CTSe6OSST1LZMA0iYLaqL+gK33G6eyFF9Hp26cjxf6viv4KEEOOwZWpuiiD4vrEqQrVMJDqwVHWt2cd+t7g8FWDJZA9loZtOd59fmcobsaErsiKDmmKyJwiE1dnBA6u2LozDjxd2FtvRy8VYDcvEheyB8+0jw6ZmDEB3lfY6fbvWcZHsmkQIt/rQqnzwNk5NiXv9hns1Btd6fVGs1O0O/gOeYoGSgU0nnBA1GGyvVWceshFEeUiRaEKMg37SVjpbnArz/L2lG3Fy/SK4pAaN14fnVOhlARbP3fWti+8GKiMgXA+87iRZH3yOZfHYnAvUMfxWE79FZdSQKsuUMDi1CAfwcgodRWXPHLpsVTGej7/tEEVwtnyaOc9TXnOhRIZuLmla8+PUkjGG5w7M7x0avumkxU+pFGsXBUW12BypZdN1sGgnQ3e0Dx0NwjD1GPUC/5GRSSpqAUyRqvd8LOAdAU+nF3pv2p/akkihy39IaNZIUlu/ihIExb4ZrKPqqL/8MzKTInBdMVXxmr7MC83zkXNaFMH1ckO6g7sXCYmeD0uUM7I8UTX/mBzCLv6i6ahUhDCJAtdWF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] liveupdate: DECLARE_KHO_SER_HDR() mangles kernel-doc in
  luo_file.c
--

commit 56a2b87048122363acff436905ac6fad2da6e4c3
Author: Tarun Sahu <tarunsahu@google.com>

liveupdate: Add feature header to struct luo_file_set_ser

This commit precedes struct luo_file_set_ser with struct kho_ser_hdr via
DECLARE_KHO_SER and updates the file-set freeze, unfreeze, and
deserialization routines to initialize and validate the feature header.

> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a39992da504fb..02d09a80d7852 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
> @@ -440,8 +440,8 @@ static void __luo_file_unfreeze(struct luo_file_set *=
file_set,
> =20
>  /**
>   * luo_file_freeze - Freezes all preserved files and serializes their me=
tadata.
> - * @file_set:     The file_set whose files are to be frozen.
> - * @file_set_ser: Where to put the serialized file_set.
> + * @file_set:      The file_set whose files are to be frozen.
> + * @file_set_fhdr: Where to put the serialized file_set.
>   *
>   * This function is called from the reboot() syscall path, just before t=
he
>   * kernel transitions to the new image via kexec. Its purpose is to perf=
orm the
> @@ -472,12 +472,14 @@ static void __luo_file_unfreeze(struct luo_file_set=
 *file_set,
>   * Return: 0 on success, or a negative errno on failure.
>   */
>  int luo_file_freeze(struct luo_file_set *file_set,
> -		    struct luo_file_set_ser *file_set_ser)
> +		    DECLARE_KHO_SER_HDR(luo_file_set_ser, *file_set_fhdr))

[Severity: Low]
Does using DECLARE_KHO_SER_HDR() in documented function prototypes break
kernel-doc output when building htmldocs?

Documentation/core-api/liveupdate.rst includes kernel/liveupdate/luo_file.c
with :internal:, which processes luo_file_freeze(), luo_file_unfreeze(), and
luo_file_deserialize().  Unlike DECLARE_KHOSER_PTR(), DECLARE_KHO_SER_HDR()
has no CMatch transform in tools/lib/python/kdoc/xforms_lists.py.  When
create_parameter_list() in tools/lib/python/kdoc/kdoc_parser.py splits the
parameter list, it replaces the comma inside the macro with '#' and never
restores it, emitting invalid C syntax in Sphinx:

  .. c:function:: int luo_file_freeze (struct luo_file_set *file_set, DECLA=
RE_KHO_SER_HDR(luo_file_set_ser# *file_set_fhdr))

Adding a CMatch("DECLARE_KHO_SER_HDR") rule in
tools/lib/python/kdoc/xforms_lists.py alongside DECLARE_KHOSER_PTR would
let kernel-doc expand the macro cleanly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110050202.5294=
73-1-tarunsahu@google.com?part=3D11

