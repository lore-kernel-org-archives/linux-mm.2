Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24BB606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NwSxaQ/o
Received: by kanga.kvack.org (Postfix)
	id A29916B05BF; Wed, 11 Nov 2026 19:31:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01DA6B05C0; Wed, 11 Nov 2026 19:31:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917816B05C1; Wed, 11 Nov 2026 19:31:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 729346B05BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:31:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3D27C021D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:30 +0000 (UTC)
X-FDA: 85424588340.12.5D78099
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5E0CA140004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NwSxaQ/o";
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794443489;
	b=Bgq1/HuqYqvxBDUkrxhZfPcoBUfU++so3l77SF0T8A3OXXUKoyH2BP5CnBvWRT+O0Hv9qx
	4i1J8HcyPgibtWAAo4F3fR5CFAork2bGt1ABVuxoDwZ0ZvoRPj9o6MOLiIEnFxudQjAGMu
	GLavKILhWpLgvR10gvgRA5ogcRUmdWY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NwSxaQ/o";
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443489;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FurFPSzwc0egprFnhFtYfPmavub2m/6Uyid/nz3wO00=;
	b=TLhwVlo4U7OTMRMoYaH5JY6RkAOwEtnkUGTKp082VlFQuqAPQDetevwgXYKF55hgMjWT4n
	psllzFo3gG+7PcEQsaSinDwqMhAHMC2mpjm3oOxm3ldknlOW5zvzms7kNrN15oMR90CBgk
	fcbw9v2a2gZFo6tHNp7IrgELe8lD1xo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B075F41AB0;
	Thu, 12 Nov 2026 00:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9390D1F00A05;
	Thu, 12 Nov 2026 00:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443488;
	bh=FurFPSzwc0egprFnhFtYfPmavub2m/6Uyid/nz3wO00=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NwSxaQ/oJ9DbDzdZV+/IcVPuula2/1J+b2taj5ynnpwvfJsu4dz8WeeOGJLlbLimh
	 Yl7YESJ+FEfYgWxfbBShQvzu6lCGeSTZbu3tbOwnsCZ1baH2f4/FK0nXVdvkFiKkJ4
	 DP4UzXACxa+j7GyOtPtqrmk7DKVKC8CzPmpEaQRxJQdCFIEnzyDPmp9hD1pKyEmkfv
	 7pYrSgAIoARu4C62yYocoFEioUb8Bk+wO0nKFIY16GVyoylcT1cHZqcjmelyMm0dRC
	 OQAnMfIEqKAXzHsmyRkPBqLBR/TgRLKWYU3HGKsqk4wD9OZeomZnSRLE/RSqHmkpc5
	 Txwf4v224PGfg==
Message-ID: <sashiko-outbox-209947@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 15/19] selftests/liveupdate: Add a test for
 retrieving tmpfs files
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261111002358.1842967-16-dmatlack@google.com>
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-16-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:27 +0000
X-Stat-Signature: yi3e67oogno58drwhsoymqkexwmcnb1e
X-Rspamd-Queue-Id: 5E0CA140004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794443489-852057
X-HE-Meta: U2FsdGVkX18GuzuscK/IJKh4IKFFtaxytsv6rBwOvdkKuTBe+FbTnN9lE1GsRPLXQPAaVXwng4CIHrHzLvwf7heMqVCGuWZnR2iaZmDTTLvDoXoW6u+G77TyzeueHuQson0N2BwvbqvSgkg43e19XNAbzDxT+gnO9l/oR3Rq6oYBbzNvvbnUW89t6ZF1U7rrVJfBgKdlqspBDv2lcV1RtUEbwqKk1bX9QMKhWyoA3pbdCrXiITipligocerzNbeTtUk+blApL29AEmH1EVEvO53jN00vALAK5r0nKwSTZwWRUQID6EC3mxVrTmZ6o8Lu6jy30GGaV39JBSlmNDU1Rxws6L//D6PdvJL4iSTbfmkwffFL7ceCKReM4daL9pB0dYoYyPN/duPOLRm1LtVO+BsQmtOZjEK9IMrm5gpVbbmaV/mO97/PuCmtZpl6pNfEVVU5dNE9vMaKejkQMSURZlzTdHtaVRlhklfastJhKC5S05exgmGSDxgfxjqQsSEnSM6SxeGJJ/GDsJARlKMOhvP6PdV7XNHfJUe2CbKLRT8Qmb02CEsjJwyni9rhmTufSC1wBG+T8Rjv/aBv9YqDZ38ao9KurVRj4M+GdkW4F7OCP+bAG362jXPW4G2PLqSPvqI+tKOO/BJy28n49IceoYLj+oEpKB1zYPRsaM/tRXcKUDqSGMmU7FiE063oQ9cwrkNPXtDAB+1uhABO/fdBA2KMZxg/9fJylRs9DDwYCFUSzPn8EcoEWBCELj91wNrNMEk2p3w6F+dcUjMN20TSnLf8HOqQibLmri3WVkKMPYd01xQT5KphzNTOYwZwfiIwk9fU7JOhNvHNWeRAe8MHKmXfrOujMymBtIWjRzZs7jXbRBScALnrMFK7kZr+DQzI58wobQPWG+ieXv2HhLjOo0rxIFnEdIqQg18dbnVEMpI1WkulMXzfZlpiL3a1hBt7eIQnysJT+OZ7ZkE9Nzp
 Sm86RDVK
 9zu1xukLmNBevTuN6lbNn1KFJcXJcSJyfVEOGOJ/G3kv3LubKdzMx04mN0k3AbEDz/RksurWy5KXDb0IYrebi84iET/VnYZftZYJi2/SsxMvuTIIt6amN76LTRgPms2X3zNYwZgEUi81zWaz5X85LXRxVfjYZiNaxyod/4J7jnVE6q7LWwCkHNUGFU3/q105kzNnc5P7hHS5aV6QqIXrcEAeqE7SlSnYcPgcNUoWA5tvx7NSLT0yqYHsx4ZEL2h22NPwHnkFpIEas8iE+fs3vUQq/lQDirPXzKm3iCpI0uQL3AxeO1FM7V0hf6dPo8+bmnXsms34AD2t57bbVWj/j1SuIgnuLiv2kbmYvMbaaZM+KYESXRtBj05VXvo56NFEvzzeawBP27qUoURQ9P/9VeGeonH2J0qvxpwaub+sIW+EdlfE8yWrkGK1GVE7gtwWkiEcF9NYUAG8K4HeSOq9W8jstUKmE3oKqSBx6fhZ/6JibgLi1D4S1XVIaaSdg9s/z0EoIldOTkIEHLSVYPXOmK9Wqk3lBNIrlOxzUCWcXSFdamHHzfcnmHxuq975g/wEPcmkoshNGqpmsPzq3/6V7Rcx0NA==
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
- [Low] selftests/liveupdate: do_fcntl() breaks build on 32-bit generic
  unistd archs
--

commit 0645310fa3a030d5078797e4ea9657a80cb11ec5
Author: David Matlack <dmatlack@google.com>

selftests/liveupdate: Add a test for retrieving tmpfs files

This commit adds luo_tmpfs, a kexec test for preserving tmpfs files and
retrieving them into a file on a tmpfs mount.

> diff --git a/tools/testing/selftests/liveupdate/luo_tmpfs.c b/tools/testi=
ng/selftests/liveupdate/luo_tmpfs.c
> new file mode 100644
> index 0000000000000..4e6e035e84339
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/luo_tmpfs.c
> @@ -0,0 +1,728 @@

[ ... ]

> +/* nolibc doesn't have these, so use syscall() where needed. */
> +static int do_fcntl(int fd, int cmd, long arg)
> +{
> +	return syscall(__NR_fcntl, fd, cmd, arg);
> +}
> +
> +static int do_mount(const char *source, const char *target, const char *=
type,
> +		    unsigned long flags, const char *data)
> +{
> +	return syscall(__NR_mount, source, target, type, flags, data);
> +}
> +
> +static int do_statfs(const char *path, struct statfs *buf)
> +{
> +#ifdef NOLIBC
> +	return syscall(__NR_statfs, path, buf);
> +#else
> +	return statfs(path, buf);
> +#endif
> +}

[Severity: Low]
Does calling syscall(__NR_fcntl, ...) unconditionally in do_fcntl() break
kselftest builds on 32-bit architectures that use
include/uapi/asm-generic/unistd.h (such as 32-bit RISC-V)?

Those architectures only define __NR_fcntl64 and __NR_statfs64, not
__NR_fcntl or __NR_statfs.  Should do_fcntl() guard the raw syscall with
#ifdef NOLIBC and call libc fcntl() otherwise, matching do_statfs() right
below it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111002358.1842=
967-1-dmatlack@google.com?part=3D15

