Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE5B710AB801
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656A96B0088; Thu, 26 Mar 2026 14:38:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6078A6B0089; Thu, 26 Mar 2026 14:38:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D506B008A; Thu, 26 Mar 2026 14:38:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41A896B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:38:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2E83E151F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:38:40 +0000 (UTC)
X-FDA: 84589075200.23.AB5E0F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1FA724000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:38:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=taNmqBfM;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774550319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6gGB7CxcWdnQ+DPWeEBla1sMv2dX576ElrBQ3ycAD0=;
	b=gVhmJm2k1HGKjYAJbUDnRGQntdCwyURRViqwGEW0mXlCdL8IR0IDY0a3+XhjZ5SgltoyR+
	diS+9P4e4+Ploh3ShGedy9ZcHUw9uBF8yYIk8Dcv37++iyX1bFkbuVQi/3j/DQ58Vti/sr
	ffwW6r/EHx8n762Px1MFcKFhaGnPZnw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774550319; a=rsa-sha256;
	cv=none;
	b=fLaLkq3Yx4Rjk2oXSENIc45snTMSJzXI3Z35aSVxSpqWO9d2X9qhk6y5mhrFDsv0vY7xto
	JHvG4Cw5CjM+iIDEldGL2+AbJPmjuyhNIiolJufeMpyWnrmz9sVSc4i25tXRH2cAtHJAmi
	kQTFJWTDqV9OpOIlnJNKue3W+eGTsA4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=taNmqBfM;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63DAB600AC;
	Thu, 26 Mar 2026 18:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A040BC116C6;
	Thu, 26 Mar 2026 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774550318;
	bh=ndiHyXCoO5k7Iqu/6caxL41+ed9KFd/MkCx3xUWmsEc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=taNmqBfM3BLswhWl/RJJAoUFuCiAqubMPHWGGMR3UdxU5KJrs8LMM7qcXQRrWVVpw
	 gJFt3VEicxOzMPC1XI2z5MNJGEAaclq1nCkD/zc1lZ5QXVXtp5hg6xhnKLTJn3wcS9
	 elOgQXcAU4TsAUSpKtEoqf8YzI3FpzELGjqsW4ls=
Date: Thu, 26 Mar 2026 11:38:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Shuah Khan
 <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 09/13] selftests/mm: skip uffd-wp-mremap if UFFD
 write-protect is unsupported
Message-Id: <20260326113837.b2a030330adb7dead8acfeff@linux-foundation.org>
In-Reply-To: <e6f03352-4f09-4238-a47a-6d4e84101a6c@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
	<ed23ff57a80881c9d087d22709862af40addf49b.1773305678.git.sayalip@linux.ibm.com>
	<457dddf1-04ec-4d1e-8640-b04997fac4f1@kernel.org>
	<0e9cea41-7c49-446a-b67b-256584960516@linux.ibm.com>
	<20260324165606.d75200ac0e5458a5ffb83d5d@linux-foundation.org>
	<e6f03352-4f09-4238-a47a-6d4e84101a6c@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 6xw4hcze8gpikugsnti4n667fo7neha9
X-Rspamd-Queue-Id: 1FA724000C
X-Rspam-User: 
X-HE-Tag: 1774550318-769576
X-HE-Meta: U2FsdGVkX19a4095kFw5sjLFESEowFZ6qL1Vy70qkFaBeYmG+AMzOP2XH5BdslBoi7K3c/CwPNGfiKDzSl8s/oADE1OLsu8cMSeIXetFr0Sv8neBCjnpwwAY893uyR+acrekn77Sdft2hEDgArhK4OFOi1V4wPamlwigQ82Eq9gjmsEMQJjto8gmKjMTq4ag6SKUn6Vuf/MsNR1MMb9wV+kgGsruPMOSXmxaxewEoiKA5mltJ4wlN6mfYVzXuur7X/a3mxxqfH6Af1ljSa/QecSuHUnMzGoj+2LM6c4UAXJwF9e9r4FEA2HWNTFnb/OvJMaUbKYntM4xIY3I+ZjWiYIDTbAJ12y8X6TxETZdqp0cBlxyn0+kG8zzDYuNPKKtbjHZ3K7WlGOLJuKYFWPwXmfkL8D4GNNw/2bOcdFuXmuujEhOCHPtkAN+ePHzaIlpVf11oJk2NE2J+VKR5xNF7xBgDfgA3/pC9yKG+KS1V5kmzkCbyxnLTdLMW5VyyIaHEfzMZ0qwkKSVyVcLzwmw4kZae+t7xeKvdK+KrcL58SqajWo60g0Tsv0aoCmCPr3dPqiUmc/Mg2cYxofoFxmL3tSZotpQurlcMkXF8LpC3zT8FW8o5ziNYvW/5/FXsmymlJzbNz62KTq4v+vT3tCrDtr4nmZMaZ43rmH4woBS9HLeo6FnQkjZhiiTlZP7bjT+icb9Da2ny+hFuT6ynlqtzUPFwesKbDlQoJ8lfOM0PKNlJ6RerchhCb+v3ibU+UlcytJ/WtGvgrVSKajoY1DI1X2ARgcnVOPJt4WIe0QqqCKG1UNteSa6HeEC+hN9z3cPLYSZjNcsl6CcqICeQs7hDab+xHC2CeSF9qgdCvMSKRQfaulxJLf2mLrwjulQ813PJfTReTV2u71s7hGAWqgTUme480zGun5bGQ79F/5tC5GBL0cH/gPj3Sj2YAddGfB4vZU6m7490AxH6CB/czm
 5S2ei1b1
 42G6tQGPSRfqVpoWvqv9i7R4etw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 23:31:10 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> >   	pagesize = getpagesize();
> >   	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
> > _
> >
> Hi Andrew,
> I have some updates to [PATCH v2 04/13] selftests/mm: fix cgroup task 
> placement and tolerance in hugetlb_reparenting_test.sh, as Venkat 
> reported failures with the current version.
> 
> Should I send a v3 of the full series, or just a fixup patch for 
> hugetlb_reparenting_test.sh?

A full resend is fine, thanks.  I'll prepare a diff showing all the
changes since v2 for you to double-check and for people who already
reviewed v2.

> Also, if you prefer a v3, should I include 
> above fix for 
> selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported as 
> well?

Yes please, integrate all fixups.  

You may choose to track those fixups the way I do:

[avagin@google.com: fix lock leak in mfill_get_vma()]
  Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
[akpm@linux-foundation.org: update mfill_copy_folio_retry()]
  Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
Link: https://lkml.kernel.org/r/20260306171815.3160826-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrei Vagin <avagin@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
...

Other people also do this sometimes, usually not.

