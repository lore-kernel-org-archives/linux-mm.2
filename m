Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9629FED3F0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 16:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380886B008A; Fri, 24 Apr 2026 12:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331476B008C; Fri, 24 Apr 2026 12:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2473E6B0092; Fri, 24 Apr 2026 12:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09BDE6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:23:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D9B2120226
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:23:40 +0000 (UTC)
X-FDA: 84693970200.24.6BDB502
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C97F38000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:23:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IRwXu7Od;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777047818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcTbq1JXL+aXDcT9t7qPIZ5/r+BSTh6U1kBQpvZfCmg=;
	b=3h0ODWR7KGJG2LFGB3fH4x3aCgnNPKaMmrcDM+7g4Cv+LIVK1q9qTsNHGOwXWEZJuOcrBz
	rA5iFNAKLzEuA6Cv5NbQE2GW8jDgdPyc29kUWlvavpNqTacGAXuEdEvqfH72o0BeEl5Dda
	FOk9tL08Gy3cjOoO/oMP3LQVyoUsoTY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IRwXu7Od;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777047818; a=rsa-sha256;
	cv=none;
	b=sf+fSshZfn1Uxm8BhtnAKHUDeuSQaqs83gULSJitfUrGzWjtt6BuxyD+36653ys0gzlLZm
	0dCD4GCSe4Zdv8A59sTMSOqw5VpCjR2DCFpS4HFA6Jyk8pIRiBgbC7R++x/iBF02nnIccM
	mbBaA8U37GfXcmxhgHmkU95MOIfcRDg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B8036600AE;
	Fri, 24 Apr 2026 16:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF255C19425;
	Fri, 24 Apr 2026 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777047817;
	bh=XHsSKdWBfJ8xwH2NIQLRNdaVkmG3kAIguJv5IXWgybE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IRwXu7OdxvrX2QIsdEBmnerp/FQxrMkuestO4WSRa4Ol4ytF6NdcGJwxtgk/s4qvq
	 Tvron+PGjWCumBCJappijmqHHP6gQDpbrHChlmRlBjgdgoWvqZ/6gU2YdqlW4j+CjM
	 T9RWxvaz3W6ibHB9jYQOXSags19Ho+fp2RAnGoEs=
Date: Fri, 24 Apr 2026 09:23:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mpenttil@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, David Hildenbrand
 <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky
 <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>, Balbir Singh
 <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v8 0/5] Migrate on fault for device pages
Message-Id: <20260424092336.7f8f5b0c00f4b46f9e0879d9@linux-foundation.org>
In-Reply-To: <20260414041226.1539439-1-mpenttil@redhat.com>
References: <20260414041226.1539439-1-mpenttil@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5mmoowbttjucoyi5qmmzzxnecgj3moc3
X-Rspamd-Queue-Id: C97F38000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777047818-3059
X-HE-Meta: U2FsdGVkX1/Mujvk2HqzSIDSTr6kwsrpEUpA4gVUrGA3NAxN1jnWJrqE6MVl3fWwf6rHvysqba/cbIIjybXLIZYho8Nyk1zv6Z77/MlJ67yBAPSDEfOe0B/C93Zd40jQCMGzz3UM5N7Egs0A76tkm71v8aQFBX0W+NJGGBQj27OcJtGVDOHezyf1cOX/SQxCC6kNFFd8VdQE8vyiW6my7mtm4lXlYCstxpeaZrA1c+ZHm/wqI7Eqx6mS4yNM0ecV7w18c6uPSloP6eUKQAYDNLhDMcGBFVjA+5xym3SelctFTlTfEhLXmFTVG4kU0E1AF/HxvlxpHiiWDNRDJLP121jseMKtI0GL+OTqsfdA1roHqGqSJ7vheERwx6hcm/jjOMFRx8YJwculs0EwQziQVURfKc96MgwvPAggnEEmfMUTOrf3peeKFja58vGiOM1rHXx9ntOHzc68dn+tm5YIoHn1J+PZ0AEgQFd06pQMOXpCdV0MGbXvv37gc0SDcDkf0TuiayHDvOklaMoQYU7WMrUHQUa3G6W+mTTZ4freXC4IhQ/hWmG8nV21vh+5dKuDO2FmObkmMHdFU6dmxzcpr6mIuJPEtvmsUzSkF7NfzURy6zjqrxATWiTfbg65aXYoL3NQ5vVB2UABojgLM+vWqwFGcsTjkquWVCC6q2nq3dHKUBLtxo0UK5ZvR0kkr6NsOeeo49Gm5AxyrQXK3agSxO2U3wVByts9JUpjYMGcVNzCfg1CTQkGgyP+Sdd8BD8B4dv4dmXsYEhwF7mgqwxni+JB22krW62zO6mCplPpYe8wYl8b73fjYX53eQ82ShLVZ1M/k52qKaPGDL7M4v5MxrGtETy5jGbQHzyrn6OrIuLshEJ3bBnENBZXnmxLEy1PaG/dBIkXRFkpfn+g5ODQFjxiPvxIWAlgyfrObf/R7WD9o/GEZPmVpNienord0Hu1ZkK+q834DmePZPIZbWW
 D3Jez3N3
 W6F4dJcKt72ehL78qLbDGx71+dZHw80I1Mc2Q9RJBEBfn/E3s6VbfAGa9G+6Q8CCApzObDq/BGmdWPOyjQDdnqEdDxmnpRVRGIz4LJbqDr2kmloVD7y2EO8wrPMAG6Bn5yDeRgug1XstOuxa9l7om7co2gdkDyujqbJtBvjBW7PdT/z+mE1GVhqQKd4M6XL48GrnFrgz2Ey7hDCTaRxBiOm5vkVLm1wg000jgG0wnJM2+38QOwaGOweCsgj+mgXFVclyxkq8qzieG0O/N64VQ0OUWHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 07:12:21 +0300 mpenttil@redhat.com wrote:

> From: Mika Penttil=E4 <mpenttil@redhat.com>
>=20
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
>=20
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
>=20
> ...
>

Via which tree would it be best to upstream this?

>  include/linux/hmm.h                    |  19 +-
>  include/linux/migrate.h                |  26 +-
>  lib/test_hmm.c                         | 101 ++-
>  lib/test_hmm_uapi.h                    |  19 +-
>  mm/Kconfig                             |   2 +
>  mm/hmm.c                               | 821 +++++++++++++++++++++++--
>  mm/migrate_device.c                    | 589 +++---------------
>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>  8 files changed, 1053 insertions(+), 578 deletions(-)

Looks like mm.git.

It might be more useful to add it to a DRM tree if there's ongoing
development against this.  But please no upstreaming without good
review!

Anyway, this is a bit dated and Sashiko AI review wasn't able to apply
the patches.  Nor was it able to apply v7 or v6.  So please refresh,
retest, resend?

