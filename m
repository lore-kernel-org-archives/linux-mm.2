Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD2F606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CZmLfasw
Received: by kanga.kvack.org (Postfix)
	id 2C5EE6B05B0; Sat,  7 Nov 2026 15:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275486B05B1; Sat,  7 Nov 2026 15:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BCB6B05B2; Sat,  7 Nov 2026 15:58:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E79156B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:58:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FD3D160393
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:58:08 +0000 (UTC)
X-FDA: 85409535456.13.FC6FBFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D4C7F1C0007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:58:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZmLfasw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794085087;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNaLIAIiL2IsLQ7leBeTRdMuAYI+LVw10gRNfTdmkDE=;
	b=vviUFzic+r/FotC7AQLkD2qsmDdh4T+HXvrijDo4FfB2MpV2DQENTtzwpy7kcfsrmI+vta
	X8ysOwZwUfgI3XjPfq20fXtm+mB+uCURDwHMQHh3lJLj6ACFJQly5SpyYWJS45m9ycQuIp
	ZGMHsb+RKZWTsOcwHwO6RmeSY19/b5k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZmLfasw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794085087;
	b=KsQjdRE7Qf65fmjZmD93LbgQdVceyKuVIzVSOp2enOgcQlps1YpGZ2f84vKVqBuzKKvBe/
	UXvTslnw4r6eb39CIOYvFQHZpl15Fv2htE+RrOVs41tL8xgcd0q120Cl0GGW1NN7SnmZCQ
	fI5p8rYY4L1taQxeSDkjn1TuBg/wHjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C334142AF2;
	Sat,  7 Nov 2026 20:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFFF1F0089F;
	Sat,  7 Nov 2026 20:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794085085;
	bh=hNaLIAIiL2IsLQ7leBeTRdMuAYI+LVw10gRNfTdmkDE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CZmLfaswRWd05P4qWMaXlEhR7N+spn7PLuPOwrRImBpioqOws788/2WvdKO0hlu9w
	 ECUv3jO0K7SbCHkg/9vntP+u+jd3VSraQa/mnM2DIg7b9LS7WSJ/nTbjoFcq5dmpgY
	 RWgLyhOBYMVWhsQRonHSBL5z155oqoFRkuF8BCPqudYfknGz+tc6v2Z/tzkQzfpRVu
	 fvbviuZwVi9clZ1zvnMXDvUhGNePTkkEMzus5ehr6BscKRFP0GDVN6yDuis1zDJGhV
	 7VMs8oQCjfBBrGRPsJ+pqh1bvDjFdGjZ/JIxbklIYMtH5dVAAi9Hd1hRpep1WJCYw1
	 +2Ug0zPpwkZyw==
Message-ID: <sashiko-outbox-203336@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] binfmt_elf: return the real error when program
 headers cannot be loaded
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Khorenko" <khorenko@virtuozzo.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Kees Cook" <kees@kernel.org>, "Paul
 Burton" <paulburton@kernel.org>, "Shuah Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org
In-Reply-To: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-1-1c8b7b1dae5c@virtuozzo.com>
References: <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-0-1c8b7b1dae5c@virtuozzo.com>
 <20261106-b4-prep-vstor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-1-1c8b7b1dae5c@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 20:58:04 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4C7F1C0007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a9aqgr9rzpbiogj9ugso8qk6pisbbymm
X-HE-Tag: 1794085086-768506
X-HE-Meta: U2FsdGVkX19X1qGjxrX5RAHScX/As3ABjRA98jjutBT6PxsLb4j22KW7lYmf6q1vMRnepwpqt8G7Hpru3ICS+ULMU5OHZIpBWYEdleuhG6X+M4EaHX1HOaB51+2Jz0YFwpDetQ3odbTgMWJIq1VEu1MD8IZ3pqFtbOjb4nSKgwNZ3yfVAr7o94gU/nTNFD12BoaWYS+WAFSCjj9CBgE+3xH/Y+/qEpHyXMhBfl2o31RKs7GAVvV1rNMglZebrSnkIcDf6L7QNLZdLa9p+huEETx4ox7Mh20S3ItHYDSP0lkBK40x6POnP63Zkeep49IXA2FslMMUgvY3o5mKkWcnbdT2PEEk27vCJ5vecZta7rICqlcOLgdouN/vpXUJwyf7rPp3oFLdMYJkHVE/n1axFMFrUfoOdEHNAHxKycTZsbcQauMQof5YYmeS35cUOHcqZTgRhb6plH9yroRotHrZFNiCUEnm5daB3baANaXxL1LhIwmvm1YmUODFT/nGSVEbHjIAkAnJS3ecl4sLWhee/eoD86PSlK/s3D4ZOFBke+/AUWZ4XlO26e2DSXe9YmQJmMAHbfolFFltxRVtdMjzVal1eXDWrct/BF7JNBGMT2ShD2xcpOK97q6nzonpZR2FRf7OAwwVCOwsnC4i377sm5VRwCev4lzRzEKfv2wZbwDzTOCFVmcOcS2tdHK30UAWtascoqDkJqY5oRj7Kn8SoeZ13t2OEmaZt3RU/mdK0NChjxvsIW8j/qHfGU64r40+4jKFDOWRA73r4Cr5z6VRC3LSM9345rgsNmKegC2ua9ZDt2RyWGq/6TdcgLSi5KuQZzvSnbbXJjaQMCzvnh92yrt/bcAuCr9qauC7SV3GaPMu1GI3auLmRxXo6T/QkFko8joFEH9FLfRydjrL0naYKM114qvZGww9iuczX6k1/w7HBMQ0rKBp79ZWHAZoX6ErYD5TQxvpE27fYbRZyPI
 iZfo2kHC
 zWJVXxSK+IqNcDuY4ThR1bpZzbjA4RJBSx6fXkDTc9X4qDoX/zxUP5P1pRVrZsOLcdSpnrkwah/DeTdzJL8CbDqipR8WWrWmYBhO/XtKSANdew92hQmjhhPc6O/ddS6hBo0zp3nK1fShqX5Nvtw0b96AiGZmA0XaKjH6t6WESl3mLgBb7xIOJL0sBh8+5I9yPAWOV90i+T3a1U19mYu5xO+6p9SYiA7xcsD6NiaTI8HxGLdF8oQAJR318q/vSWnxhtPNVqjvBAsvxxyIbMMXtRVR7xAtqthio5IRplZmZHPtqOBo6mCsiYBBvMoF/I4s7G5AODfgMjnJw9anUdnPf9NjiavKwPQZnvRlty3HQzlGbyeoq6ofIV8VCwU4i7Pk+GZ4TrS0L/IvUQZ/EU0M9Tco18+NQ0CBSgZZVIc9pUiv7JFYP+PX5rfFBDSg8+GhNSc5or0mNLOSnINO2Sbpqq3zDFruo3TnsJN2vMjWd+1WDNYrwaBGCnoWwlbqNKKwV0ctH1TQOaIFjHJyvsp6su1niqUPBuDO2/Zr2p6iIlWmXCj6nxlONCVCzhGH5qkhas+ERLuSSqGvWQxCiIKASqMEgTLaA+IjK0i32mmbD49/lh4ZM9tOeb588i+882+dGnswSoN9wzw6yJ3ekzMFpPim2VMxuNqQSpNo2crvqUELKYbGu5OSPaBb7BeT5Erz1S/rU
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
- [Low] binfmt_elf: missing Fixes trailer for load_elf_phdrs() error
  return
--

commit 46b1e6b996d116acfe43305abc30c04627bdcd95
Author: Konstantin Khorenko <khorenko@virtuozzo.com>

> binfmt_elf: return the real error when program headers cannot be loaded
>
> load_elf_phdrs() returns NULL on any failure, and load_elf_binary()
> turns that into -ENOEXEC for the executable and -ELIBBAD for its
> interpreter. So a failed allocation or read of the program headers
> makes glibc's execvp() run the ELF file with /bin/sh, and for the
> interpreter reports a healthy ld.so as a corrupted shared library.
>
> Return an ERR_PTR instead:
>
>   +------------+------------------------------------------------------+
>   | error      | when                                                 |
>   +------------+------------------------------------------------------+
>   | -ENOEXEC   | bad e_phentsize, e_phnum or e_phoff, or a short read |
>   | -ENOMEM    | the allocation fails                                 |
>   | read error | kernel_read() fails                                  |
>   +------------+------------------------------------------------------+
>
> Malformed files and short reads keep getting -ENOEXEC and -ELIBBAD.
> The table is read with kernel_read() directly, as elf_read() turns a
> short read into -EIO. An e_phoff past LLONG_MAX - size is rejected up
> front, so that rw_verify_area() does not turn it into -EINVAL.
>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>

[Severity: Low]
Prior to 6a8d38945cf4 ("binfmt_elf: Hoist ELF program header loading to a
function"), load_elf_binary() propagated -ENOMEM and negative read errors
when loading program headers.  Should this include:

  Fixes: 6a8d38945cf4 ("binfmt_elf: Hoist ELF program header loading to a f=
unction")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-b4-prep-vs=
tor-149847-binfmt_elf-enomem-load-elf-phdrs-v2-0-1c8b7b1dae5c@virtuozzo.com=
?part=3D1

