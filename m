Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD68F606A680
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LGPLwRl5
Received: by kanga.kvack.org (Postfix)
	id 707DD6B05B1; Thu, 26 Nov 2026 06:45:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8C96B05B2; Thu, 26 Nov 2026 06:45:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CEFC6B05B3; Thu, 26 Nov 2026 06:45:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEFE66B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:45:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FF411C4270
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:45:16 +0000 (UTC)
X-FDA: 85477089432.26.20846B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DBB1F1C0004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:45:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LGPLwRl5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795693515;
	b=5z9d6SLR4eUk0PrOmS6O71N4erB9/3ZEggGv3zi4sbv4fihIlZuj0Z+MVvjbz3SVR+e9EW
	XEZzasE9ob40Is7+JiOgE3jNSDLr35Rm372pWcijGOjE+CxZC30kyKvFsO6q5epV4aj2my
	vwwevPs5ABP17N/bnW9FJYuQ6HKJ6vE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795693515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZduP2sQE9gkeUneqSWpAXjGsaRT+wkgF+eZBdvryg4=;
	b=MQc6t5Fd5iFhM2jkIbzK77P1qbUMaZmqnp8dFTan6yAEeaqUTrlV3PGPOuSbWoj5Rf/2xL
	C1jo6FGnUEXFVgfaMrOGfawHzCv907L7/iGArqkcRiH2LsdgUhtEenhslFaxRgIApl+V7+
	y3hNbY/+V7wJxXACJzsiOe3tgIAV1sc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LGPLwRl5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C5E14096F;
	Thu, 26 Nov 2026 11:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408FF1F00AD3;
	Thu, 26 Nov 2026 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795693513;
	bh=hZduP2sQE9gkeUneqSWpAXjGsaRT+wkgF+eZBdvryg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGPLwRl5itV+aeR1X/ZTZEjZE9n7QTLS5WeN9wxiW5eJ+G3sNzUwTPUhdM6f95cI3
	 aEYQD/hdunuQJwqmxqetz9p3RsnaENUjUysATniX8cgDzy6/Apr/7YiWo4XXltcpFY
	 texh2cyxoIfGpf/OSY8vfmoW5wBEwBkctQeKz8cubK2CTWZ7kXJGQp5heASixPFUN5
	 P5jO2b6AAEhzGMVLOPSi1bcr8jZgsPz8XSIZy14ZvCw0ANQuUD9R0ZJysBe43/BKOH
	 pbVGrivRY2h/2vaKGSZoHxfAHfYq+R3LlaLNYMqvmXoYp/E+39CgDHSYmNdvHy4lMV
	 tQQCFWro6PQvQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	"Srivatsa S. Bhat (Microsoft)" <srivatsa@csail.mit.edu>
Cc: Mike Rapoport <rppt@kernel.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] MAINTAINERS: Add missing files to KEXEC, KHO and KDUMP subsystems
Date: Thu, 26 Nov 2026 13:44:54 +0200
Message-ID: <179569348035.4110350.13594456540362973475.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
References: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wkyjz9b9mkk3x9epnt4bnf9uct4s48n5
X-Rspamd-Queue-Id: DBB1F1C0004
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795693514-58326
X-HE-Meta: U2FsdGVkX1/JB81w5bfXQSaEENWua/XugmAax1cvlG/TTXxNLJwyCJKrIzpYG9nBGvDBwDaWxRr/wOB11NPbL1lHKx884ZPf5++nwBqksI3Lvy9ZE9G6yrRr590DOfEv87fVskR1Hb8Z5u691LTe3SuhL9UcXnXUTpGoB5/XzWJcgTWtmxnOOOmm+n/ruAbHKF9eDSdVVIWYWtFrs8k3RaqrWbhG2NQ9kxkokyDKYPbFNd3nPVSY3U2nmOiDdGutMfPH+8rr0gqRMs47QPxmx4Zxc4QRTR5FiI0eCd6nF18G7s/E/M7v7AOpMyTMCkL/xN6vjDIvZ+VmdgSoLq4fh2LjMySqMjtZxe9nA3XIOPQv2/Ubdb9EUIo9OKo4WhvlKJpfcCoWWs+fteetV+dcMsaNXFKuGPaTD4VFn1XKGGQcuXQaTmTI1Ij9T28t6QpLgdxfgbHreoiYg1t83XpZIQDyWkE/CyOCwwpFeyP0QLMuetZdUvy16hn9Q822hemPfAjmQDXK799ORYQcqBxvnZuyqEELNEt4dYFtXNR9N0M1i7bkZS/eQBV8VIGzwqOZiH4DberrRhvnov8Oo1Jc6iBw9AroFwVFw3hqPGKA/Oqet/JqeL/5p3U3qhtGjDy2UF1rs58ux+mfkWcBq5Ougf00EbZ41YxSHe5JGPs5xGGwlJYz2YSHv7URTrYxjmIXwx84nbU7EkFL6K4e5jMufI8/CFIw+VbkjO7P77J2C3bNhVHfKWDAtscHJkAfr7AYC/ZSk+NJl0JSj511XnfuuflLMPZban81XRIXttWtdF3+TIJzzZ51Z71CfHt3rRz63uhF44geLQ5200hdv+Tf7XRvIDNdfTZHtsEVpCScIsJj6YPM7qCGEOErzqIwehYGnfAjN4/PJQ34Iv1SLRtBREM82Iff6aQcEeyqSBOIREW/cpuAOEOLG3D60ld74OnuY3gbbL92Sx3k0X0pEzy
 fFnEC1Sn
 BPUkLZNCNhUOOLBYD14dq+qgMBgnwnlh5zBvYa4NT+aDCTKwfmWhqE6cW8Rj12fPOhZJTCrKf6IQ1/tRt+1j4VUacwF9xADrkgtxPpM8cjO9uMWgtjHc/rcnMi3iW66srl6Wo6Ty+Y4engks0k4KleIpAEkVRsiFZb6vy4HNKk+z5vI9jjjIfwL7EX2ctm8l95nQ9+3DSTsIzvALBhTE6bZQrvq2w74fUq/03Zvwr1iWZP8DD9lK11eNlYJ/fB9rnocXEXyLe+oCwIVr6BZ8fy1UL9Gx6cBKcfElOJnHGGO4jN27uBEhFA+8XsLndYsPtHAcdUo6F6pcwgYlPrbnfS4W41yMnPm1lhI4jtkGwwRCO8wOdDhH7erVt7mGbI8ST+sYeIxu90FT+Rb7L459hnNnyMzA04JyrTwShbKCCG91Bd8J48xezwtT9IWCleop+QqESvtclGvF2kdleDTrU3GCDqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Tue, 24 Nov 2026 01:37:52 +0530, Srivatsa S. Bhat (Microsoft) wrote:
> Several files relevant to the KEXEC, KHO and KDUMP subsystems are
> currently not listed against them in the MAINTAINERS file, which would
> cause scripts/get_maintainers.pl to miss recommending these subsystem
> maintainers or mailing lists for changes to those files. This series
> addresses those gaps.
> 
> These patches apply on on top of Mike Rapoport's series:
> "arch, kexec: declare kexec and crash capabilities in Kconfig.kexec"
> 
> [...]

Applied to kexec-7.5 branch of liveupdate/linux.git tree, thanks!

[1/2] MAINTAINERS: Add missing files to KEXEC and KHO subsystems
      commit: 77059f4e9b56d78e22b8fa55f294bb2b9ecef85b
[2/2] MAINTAINERS: Add missing files to KDUMP subsystem
      commit: fedac4c07bef7d3ad84110f51a8051e3655818f8

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: kexec-7.5

--
Sincerely yours,
Mike.


