Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D6E606A331
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KBKTCy5U
Received: by kanga.kvack.org (Postfix)
	id F1C146B00EF; Sat, 21 Nov 2026 11:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCD66B05B0; Sat, 21 Nov 2026 11:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5A06B05B8; Sat, 21 Nov 2026 11:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC3556B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:09:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C9B1140574
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:09:55 +0000 (UTC)
X-FDA: 85459612350.22.8D52A21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 99091140009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:09:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KBKTCy5U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795277393;
	b=A+LkNe1fjsvqcuui/k5gpOjOCv2J1tUfvPa0Swuteqe/CPRf1k0KxlA59ACeDyl7TcKqXa
	30Q9tSzxG0+4gu5UOPjE3FX+YaxFFCNJkZMjGUBv1yqpuww3aIqbZmGz7rcUXO9uv3GcEp
	CxoPEMzNo6DX29e41CcxNdyZgfM56fk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795277393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4XM20aAeu12Jm5j4NnIE/mMGTDsNHoeQWXmu2VwhZk=;
	b=RiVQa5F+IzBJjH8JRFjhD2PXhcvO1hJ21ubLKDZ8ugkFLc+rQdxYFpKKoNMar0qP3daLPY
	mVsPKi8Yutjl+FUtEHCHjLlcetJGrjYwHxtIP0ooGoyUpitRtB+9TyGyFdBwRvT/1MVC8u
	J3/WSS504oc6G/CPZHRT51bHttW7q0o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KBKTCy5U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 1D6C261181;
	Sat, 21 Nov 2026 16:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 485F21F000C0;
	Sat, 21 Nov 2026 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277392;
	bh=G4XM20aAeu12Jm5j4NnIE/mMGTDsNHoeQWXmu2VwhZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KBKTCy5U9VGPIKUtr5T+pTPJ8YTcpZUJWGcJg5bDAWFLkwHDKYBxkKooOahCWXEb3
	 gAPAKvuh6WV8yNwn/Rx9emu51PZKosn/+Af9RViI3KMIAyxvZl4PkYSo11RmOhQ9Bx
	 dsiIB7UirdIWN0sst0R5U4jgjVVd5W7gWHFEmxpaGjR+3b/wShv+8PlQkaxQCiAk50
	 N321ye8ZC6CPo9kQqcaZ9bnbNwdV+TYarhT3fvEe3HFojGQGBdQsChw2QzjIL6rxLn
	 wyCCvAjkkXW0aRnHm6xCdC4DjY0koyjaFHxTGhSJ7GfGlolJZIyxj03eVMQUqzVJLJ
	 JD1rerrZ9pB2Q==
Date: Sat, 21 Nov 2026 18:09:48 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 02/25] userns: Add userns_set_idmap() system call
Message-ID: <awHCTNAo9uMakhAH@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-3-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-3-jarkko@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 99091140009
X-Stat-Signature: qo7d9wya6iwk46brzbcybd14x11edf4r
X-HE-Tag: 1795277393-6497
X-HE-Meta: U2FsdGVkX1+LYO8ncmyIHdOGljwAoXF1Bd+Z3GqmMDIknPskgsM+9Z20GuimYmZaupajckLqgpW29bpZXpS6km7mztMjaMlx2ZQd7HWfqmBBRkOnKv9ByeUdifdVGCdzTSJRXkK8hPo5tcGBINUSUl24IS5QrSRz5Ij8xFwe/j0eGsJEAZofB6NUBTUQbBg48oAp4Qdp8Fzgbg4W3+DERjDIB/zbTjmJWfk9fPohSL7wx/XFsVg0NKeBedYCHXiBr7CBueWKuwLIYLVT8Ql0OXFa/hcSEV7/va8ARCqdQJchYfCK8/KBWz8OV9F/RErgi5bQuRtEOAEtiIpQM2ph+EbakZml3+2+6+R99AL9xjAUFfD49nDuJgnNQOJsoSyqdzXOYIr+1cCpEZ8nIWAbT1u8TJ9qM0T64nxBu2sWHgvgWl9UkXfOnqxnPkyH/lNMqq+kIJE2+jx2TFNZxZi7LCm8tJ0bwwQMee7z9v6QfW4N0bsZnPj5g6TpmyNhAs+XWVaqxFWuzYU+177FMrDMrfgCgVN2aJNsShirYZS46MthQgn8oXrSaKre1+rV2Ia0KSMyAf0lRlCnoHC9eMXOgk8TGYaYEjpBjGYYwOAXozoygpxnl7gtfBJ3/y+LbWBgJ3/fbc5/vXjhURM3dcR41QJACUoTt/KdmPgWvpfK3xSKFu8X3pmVjfCU4OhXCmRznIWg13HlitGUEAj/s4lQ5ckaUeC/S8ztq1IWGbStkyGbktuTlW1vTFfG7BStdshJdteyPx8KzbkA9jrttGpZarj/eBdh1TIDDMedk9RyvrEy5o6fr4qBzMO15CayMvwQs+8Ff8oWB64flTdGMw9OKaM9zUP0JXaXc7ZdMA0iZXy6bQ3kwlwjzgFOtwxi5x3Eo9cLvlM3kndgeUdJ3aBhu2MoC/fbAER+XxR3eVFHyrdpAz9xTqs7HKjBd6/Iyu/Wqag+16vPjx2Gv0BV8St
 LPUl/z6k
 ACEVfcne8iZa0FuuUr+TWidZ3DeiOZLaRWUmomFzsAFeYLHGpdBOQJdDXC4Tq86tQa9yNB0KliVhODY8z8g362M4fMFy17ZCW2Hz9mRbJi3NKva98gPqf/NSeyBCAGaN/RlJq6hfKlXgHAshvVLwhuBjOvIZ3Nzk4pQC2cfmubHCACQcZrR7nFIxhEHKeX56vsI+k0Ga6R/CD6tF5EqvCMmKjoxTzupj2rrSj5RnuBIpZVhLna2a36/lSOtz71cEx6Ijw0PzKkCnOnUIABjzYRpCMFGAGbdKs1N/ogTrFIbOm3lv1iMOp+5Ko1STn+C5fiR83wAN3pegHimF7osf3Xp1DNydCPlLb0XEtNE+UcaK8kbv8ZnNnRqBFOf2jR68JL3tm85vcgdBC9xC35Fpbgp9ys3F00DGYZwhHGbyDZDhkCtFIAc++HJU4h49SaR3YK+dcKJLsXsLfC4AIxqNzWPOgAmR4kPVeZxxZhw5GtIm+23w8xoAvSQDqWL0abcmF6Puc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:08:21AM +0200, Jarkko Sakkinen wrote:
> Configuring UID, GID, and project ID mappings currently requires writing
> formatted text to /proc/<pid>/{uid_map,gid_map,projid_map,setgroups},
> which depends on a live task in /proc and enforces write(2) file-opener
> CAP_SETUID/CAP_SETGID checks that prevent passing an unprivileged userns
> file descriptor over SCM_RIGHTS to a dedicated CAP_SETUID/CAP_SETGID
> mapping helper.
> 
> Add userns_set_idmap() to atomically configure setgroups policy and UID,
> GID, and project ID extents directly on a CLONE_NEWUSER nsfs file
> descriptor. Require CAP_SYS_ADMIN over the target user namespace in
> either the caller's or the file opener's credentials, and check parent
> ID-range capabilities strictly against the caller's credentials.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

I'll remove the flags. I forgot to remove them from final version.

Br, Jarkko

