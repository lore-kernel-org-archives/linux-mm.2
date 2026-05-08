Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD0EFCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 18:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837426B0254; Fri,  8 May 2026 14:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7B96B0255; Fri,  8 May 2026 14:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FCF76B0256; Fri,  8 May 2026 14:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FAFF6B0254
	for <linux-mm@kvack.org>; Fri,  8 May 2026 14:30:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13C99A0275
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:30:09 +0000 (UTC)
X-FDA: 84745092138.20.C110C7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4995240014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:30:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=faufokin;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778265007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HosLQ/EXDh4vDjbf3/gxKCveodeFssvI5seBJvJ3/M=;
	b=8lGdlwwPtEPL5/os7JZRSVEfU+k47NpJAOPPpC5u3wJNSslLXomWPgKGKKIkmTnyR4f6HC
	gR2ncA1aZzmApEi8sN9B+nT3LyX1Ua+MYjOL/YOxSpgto56rJ+pDQ6MwKx8tHR+6K9fG+A
	e+ZuEUtvgFkW2xpPdWH2k2LBRA3n418=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=faufokin;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778265007; a=rsa-sha256;
	cv=none;
	b=iwhRx36HNkVL+5//P3NveaBFFFeKrL+psIZav3dDhOUgWTRAEVwhIVDMtnSB9E4zAKXfzF
	R6M7YKV/rKwNPCi2Rk9//5j2l8+/9/tvUf7YXdWtTud046+Z3uw8/NeksAvHhhg6pbQAm+
	EgnHqsNdUm/2LB1EMkcIXQbphm49sDI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D262C44215;
	Fri,  8 May 2026 18:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE1DC2BCB0;
	Fri,  8 May 2026 18:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778265005;
	bh=uqZ9GIgU5Ua8CenXc4GBm5HkBR0SyinC/NipnZ/J91A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=faufokinaRBj13HJu1L7q+3vBBKvsp5VRsjqzokcs+iXqgiWuBgoIuw/uPpkFTHt6
	 P1WjgG4IEJdFl/sv6xOKjPl3Y5fpUmrhA+faL6qhn8Cso9tuZXfJHxa7mDU8rvdgvJ
	 kbgEL4kZuXur1wJKAssQQ+v9gaq8qKEGsUZzM54Dly1jcPg5k14Wa9vysYVHJi7Amj
	 OYuxRMiMvYUPTQdsFZ/DoP4U3f9aiwGdGwWI2gAap8JWcPTo5sRzB3ehIUDM/yti/9
	 jx23D9uE2NX8/K0KpwOsd4IgbbkD3+0+7CqrmSCxv7IP6dfMjnmG6wzV+DUFXOeFfE
	 CkQR0K9Sbp7hw==
Date: Fri, 8 May 2026 20:29:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: pratmal@google.com
Cc: akpm@linux-foundation.org, shuah@kernel.org, yosryahmed@google.com,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: use pattern matching in .gitignore
Message-ID: <af4rpHBschXV4QXa@kernel.org>
References: <20260505152228.124065-1-pratmal@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505152228.124065-1-pratmal@google.com>
X-Stat-Signature: 4pkgm53eijgz6ab5qjkxq771ibhfdyb3
X-Rspamd-Queue-Id: 4995240014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778265007-65259
X-HE-Meta: U2FsdGVkX1+/IL/v3/PPvP5KY6ZYCURTKKXzdL1qnGfv1P+nRkqXvae5cfnE3ciulx6RNOhPXZa0DU7/1wopXWD+qoaAwU0rJ0wpsQ6awVVfN8GwoNxmqzeujniVPrW9DLS2sAyfx1h2Dg4FcrYKukx+cnl1Pm89pvgnnlAXJmiqkEwu12BXWPDf1aqUZMHt9ieZ5th8F4v1XJXdbC2TRQ9KGTqcRMv0+PbpOwsg6Oz2mHptBfO36FXjtHRvNZw4aoqbVjElPa3+kABekPF/lSPlFCrG9uf70SlH9FW6861zuPiSLFFM9k98CvR1qhAQuYakBSJRQzXXLvMN6gZLG8/IyNFLZIyKj+8IH/iJQSjKIqB+WNCG8gIBvbXTQ7hLg/D+CewYd2+yaHMCD+x7WiaFvq9hOdjBAAn71wuBXIxLDYBGeTzjx/hAeQsz4XrOJzQLf0pf0CHXOgrk2Z7AUcEkPa73ETDNnimY+9nUwLT1CpriYDBBplhZYcBmltd6soSUz0Nc6G3Xf8oZc3agplEyDdUOHg2HOVBA6VCuRGb+qIHu6I1bPYTdMbljp+OK9jtdoDY0lwu6abEPvVoiBA4Aq1OgT1Ynkpjzrdm/J5iRFHGksbI2fPknOpzvz+hqdBy5m/Ylaj/q8rqhgzjgoMg6BNUwcrWMScqjdtELXbAbvbUS9U0vnkSe0N91SmjAeijb8F+kiu5/Nvun/Ok9+IkA6I4CICkgxjleYUaGAyYymir+vapMwTxeNhl2qBR4AccCj6VhMMZibPIUe7pngUJ4AgVQ8HMXpL0D4ySODODRMMifDLh/94njaua75x6iYbnAHvOkqUfX1+QNIUIMApyeaZAkUAPmt4xAjuFgrgHjVSpHUEOWZp3SmgsVRzJHsGX/WDXTEPkIzoYpdhU6dqulzo6vLSi92k/e1EPz8r4xWthhiaxqn4eslQw+POcekhiJi2fN77bCYpxPpH8
 tqj/jQC4
 HPbngIvp10/6donQiu+hWPoxAxw6f3yp201Y/zltdVNUwxHwCSsw/rkdoOjBcrKUC80kFe5Hx4qq8NhfdTtXIaSmEh9EIeYgZuGeQPSZum2+Jv0Gqd60PDPCfUrhmKhQp1vgYlX5rnrsXfkvQ4KAJO0KfZKO0D8YSTLpZdHlZYHUVkb/3I0toLoD9+Prf/AyVkWwS9mEvO1Qg0lmqPMHndSbNDeRbxKuTftnk7KK2UP4wYnxFGN2NeuA9jmDlz0Mn/AVPRbE+vOFqXvCDSre+lWv58kGMaYUg9uYRvPB44e/Za4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 03:22:28PM +0000, pratmal@google.com wrote:
> From: Pratyush Mallick <pratmal@google.com>
> 
> The current .gitignore hardcodes each generated test binary by name,
> requiring updates every time a new test is added.
> 
> Switch to the patten-matching approach similar to KVM:selftests.
> Ignore everything by default and then allow source extensions (.c, .h, .sh)
> and tracked non-source files.
> 
> To avoid un-ignoring the generated headers, rename local_config.h to
> local_config.h_gen.
> 
> Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
> Reviewed-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Pratyush Mallick <pratmal@google.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Changelog since v1 (RFC):
> - Renamed local_config.h to local_config.h_gen to avoid conflict with !*.h.
> - Updated Makefile, check_config.sh, and affected .c files for the rename.
> - Removed *.mod.c as it was unnecessary.
> 
>  tools/testing/selftests/mm/.gitignore      | 71 +++-------------------
>  tools/testing/selftests/mm/Makefile        |  6 +-
>  tools/testing/selftests/mm/check_config.sh |  2 +-
>  tools/testing/selftests/mm/cow.c           |  2 +-
>  tools/testing/selftests/mm/gup_longterm.c  |  2 +-
>  5 files changed, 15 insertions(+), 68 deletions(-)

-- 
Sincerely yours,
Mike.

