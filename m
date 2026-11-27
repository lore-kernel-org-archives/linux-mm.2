Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E5F606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y872TS32
Received: by kanga.kvack.org (Postfix)
	id C32816B05B0; Thu, 26 Nov 2026 20:19:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3466B05B1; Thu, 26 Nov 2026 20:19:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1CF6B05B2; Thu, 26 Nov 2026 20:19:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87D1F6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:19:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C09A801D4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:19:08 +0000 (UTC)
X-FDA: 85479140376.22.66271A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 693E5C0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:19:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y872TS32;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795742346;
	b=WqnKX/y9tbTS3nbGGx+h1e48GzYrPm3194v2FCMrMOvHysWUoGNdzV9KIa1O1wz8sjOcoZ
	6OuI8YfjLvwMy4u65a0g1cGMEfjynohgKtGaQY7Up4/M7aixxncNEQYtsFLQdEKyGiV6Xa
	iu/ecJxhk2zrQReAoTu2kmbpAQpW/JQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795742346;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sf6coGV/EQc8Y6cDSVu9FlA4loywRqx4Cl+i6asqZAI=;
	b=0p4TjOOen8LSWOyBW+hnQp9pVyMUb6qsv3zAxjHVWlodGzMR9wcHzATvrZXmcXnR3R7zI5
	e3KNhsX3STligAn8DZuMx1zsXZe9+/vpJg5z5d5Mv1rc2aB/B59FQaUuKsnwUxhPWbhj6y
	hJsgGzGTiVDEgfMMxFCQd6L2FbWDXTI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y872TS32;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7F4540722;
	Fri, 27 Nov 2026 01:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0F51F00897;
	Fri, 27 Nov 2026 01:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795742344;
	bh=Sf6coGV/EQc8Y6cDSVu9FlA4loywRqx4Cl+i6asqZAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y872TS32KXmQ8w7LsIXd/U22EIG5JZ+QuB/OdNaK8Otv+FP0BeIIp/xQy+qG/zFdE
	 rjgjkMSZWZzyQR6gAOsPa3KouKGOruF0fCeIz+SS/HebWyuwemDzXMwv7oCfwfIwyL
	 Zx0NDD8HfnHo+Ol6h2bWHmP4TNZ7cT3iV+G9lryTHJcihSiK83SKmUtnZaumtHPi6F
	 y5AwF6wJ/iKK75ozE8sXWEKmPa8jZwMA72DMFOhxpd1BcZzGElAgBkNMXMpEAnensj
	 1glH5xJQ0JGCwXpOR9klDxcoHxQwUCSZHGjhML0jPZOBAWnptq1VxXGFD10gHAFxxn
	 4CUSC1Md8lXiQ==
Message-ID: <sashiko-outbox-236393@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] selftests/cachestat: clean up the mmap test scratch
 file
Reply-To: sashiko-reviews@lists.linux.dev
To: tongzhiwei <tongzhiwei@cmss.chinamobile.com>, "Nhat Pham" <nphamcs@gmail.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Shuah Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org
In-Reply-To: <20261126011818.417-1-tongzhiwei@cmss.chinamobile.com>
References: <20261126011818.417-1-tongzhiwei@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 01:19:03 +0000
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 693E5C0003
X-Stat-Signature: 1iwh8atsbxc3etq6tfkn3qjrs3rh7m8d
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795742346-511124
X-HE-Meta: U2FsdGVkX1/9HQ/m7qTEqiQ6x3jdBCtZ52oAvPxRqThCX9RuzZ9R8TpEtGfxuI8BKa+S9qjMTKgy/geaaRrj6LQOBkdN0p37lZVfCbmj+dgVbtYSPTp9fhdvoKuKhIKxUOHMntZY8AH0iEaQaNVntdsMVMXdB+TVWip8nKejCoCPW7MTMJkDIH1NK0w0UoUfCvGi2EeTAy9LREVzIrTTD8N9AKdt2sa9mdcLSPvFcPew0daAEfj9fAASuPPOMlaJ/mwRDmeV1Ab/yE5LW+n8Q/ng6t9XZ6KfEnDhQGPsMr4i5IZG9noU0UB0epGJTivvGxH0znZf3FsqhK3hA5aihoUQx8+7eoqo15X2nC8NmuM1IDRCp7oBf+pG8lYHi23QuOSb+cyehldNXR/4k3s4riS3EDW0TvXedyrVdn7cmEqlYlojPbApQ8RyETUNTjHS61OTGnHhRnJl29Q+f0n21IS015ujO85f7SMHq0WsWeFpZBDcVejxBv/aaSnHv6pZwi8bdryGUubX/EGQ2oK53enMaBSs1LabZxoCUFmFf2+BVi+XR4uc++NUkeGI5q9vtuX0TEpFpTz8Ki4Wwg5YN96EGZSOnZmR28frljR+4TAQ8jZdtMIJB/kbHfhfmRX//IaYspIqb4p7+tEl7hTXkPx4nqJwgEwNW98H9yWk5N1zYsaBqdSzjw1N0zsc3jqN5QZ3alKsWtZCoMjbwLZo5fN/O35KQxfp0/xQdBInXDtdT1ILJFEM/4UT8KAFOFOzu9z9pGkDD79kauvrfARiSRCH3DDvqAN7IJbN4bOP3nk8gVf4Tp3mhaaglsIgsgK6opuJKlrBMrhGInoryrztpkCUmOhnQMC2kbTXnBIU4iLHbez4vR4xDUxXzD14tf2TXtlAvtQBW+fyIZm13riOqNq0EQpbYCdO8jww9+Tl/0FBiPE1VRnR2vbQMguuasFTkzvKZozuDZ3Be2au0ll
 YyDNYR9q
 mnvEtAobXHUZNj7VnHZimBiNo11jPXCTNNCeE0UJU2l5+5WKT7+DrP5fE2EIxzA91CUeeEEpMZS9v+gkTTE2BPM8/dRfLkXs9ULSNE+EScoBCzFU4Ucdxvw1rBGGUSsBRCQKNGq+dSYYiE2ya23oZwBDI3VqsNRCRx38VyNSHFXh1kUYjZwBATALkx/9xfNBQO2ykxdVp+u1819C11f84uasemCbiOaSNuooSpDQPLIO0vxPJXGMPHohenXVJJsvcUelaK8XGz6dDoD0cqH9bpSYgLB46QPd7OB5paN0hqpVxFI5/DswAnktMKdVmatbJwRbtOircdoJ55zy+DAPEOwVnBcjsfFNrVWmj5GfgVC5Oghr1caXH+w+baQ1hQwq/gB+xKWgHzvQlWZf25dY9PYfuhlvUy33eE3URB/PA/ZskMF8TYBgme6nTm8XpBAkx3n215A0UgW3lVlLSWKcL5igKANAbf2ed7LwJm1FwIJx7TqaOwx6/Fi/sL0i5GIF/ue3V54t5uxksjUoO4LRrIfuMh+ojluzrTeuEnrffuNk9jC5mJBCidr3JFYnaN1ho0elmgxouRvnguTqz/Ib3zlHxlutBm0Oll4odEVMsqPYAefaKZjMCtZgRGjdhnJXh+gOlm9VgWNwuIfY6cEa9Z/FgU74DScqeRnrlHdy8c/+qS+juZWVU4iFnMuurMtTXyl+CpPBX5G6nxWyz9Kq+jCWE4szriebFsKmibyILrnLCvXovgKIO++1TfbCXWy4D/F04ieLmSF9+H7cph1FgNXk4m+1EdLamH8IkH3G0plcUTJI2MkrbdKlDAA==
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
- [Low] selftests/cachestat: missing Fixes trailer for commit
  d6a511dea45c
--

commit 6dca73321f87a5ea6aa466ecc90a54514aa6c780
Author: tongzhiwei <tongzhiwei@cmss.chinamobile.com>

> selftests/cachestat: clean up the mmap test scratch file
>
> NOTE: This fix is found and coded by llm, but it has been
> reviewed by human.
>
> run_cachestat_test() creates its FILE_MMAP scratch file with open() but
> cleans it up with shm_unlink(), which only removes a POSIX shared-memory
> object under /dev/shm.  The regular file "tmpshmcstat" is therefore left
> behind in the working directory after every run.
>
> The leftover file was previously worked around by adding its name to
> .gitignore in commit b90cafb43887 ("selftests/cachestat: add
> tmpshmcstat file to .gitignore"); the entry remains as a safety net
> for runs interrupted mid-test, but the test itself should not leave
> the file behind in the first place.
>
> Use remove() for the mmap case and keep shm_unlink() for the FILE_SHMEM
> case only, matching the cleanup the sibling test_cachestat() helper
> already does for its own temp file.
>
> Remove the file unconditionally, by design: the name "tmpshmcstat" is
> test-specific so a real collision is implausible, and gating removal on
> whether this run created the file would preserve stale files left by a
> crashed previous run instead of cleaning them up.
>
> Assisted-by: LLM
> Signed-off-by: tongzhiwei <tongzhiwei@cmss.chinamobile.com>

[Severity: Low]
This fixes the FILE_MMAP cleanup introduced when test_cachestat_shmem()
was refactored into run_cachestat_test().  Should this include:

  Fixes: d6a511dea45c ("selftests: cachestat: add tests for mmap, refactor =
and enhance mmap test for cachestat validation")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126011818.417-=
1-tongzhiwei@cmss.chinamobile.com?part=3D1

