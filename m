Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5550ACCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 11:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42AD8E000C; Wed,  5 Nov 2025 06:13:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4A98E0003; Wed,  5 Nov 2025 06:13:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847E48E000C; Wed,  5 Nov 2025 06:13:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 749928E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:13:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3118D5832F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:13:12 +0000 (UTC)
X-FDA: 84076291824.18.C175860
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7A2B740011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:13:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2ZCZW2a;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762341190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+AA7ZpHM+4GAFuFoc4UweFeCb0wRAqQjZLm0NDMGJ80=;
	b=57LfDzFuTQz5Ru34cf69O9RtRDc/EOgjdnvTgcC01XePReqBoydd2/DfM5hJtsZ+vxNTbn
	rRReG9ytEJssycph7eecyUEF7SALcTGBOJEjJF1ivuMpBlDyOzSzWV6w46qpZezuPwh3aR
	DAyeUxGBMcU04LaeXtc6HWWSqY16Vds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762341190; a=rsa-sha256;
	cv=none;
	b=ersCaEczyJZTFn4cEBYMr1k80SCkIBzlxxE5gXalGGYnvxEnWo7YYqJaPhjL0SaAl8f6R5
	a4O84nK4MJZH8Va5Ob58zVtJ+9C4d4Gy88DTpu4huxdnT7T3zCv/ppc+RaIakiDbfCfldM
	ePPUWNEY5gsEXF1UdK1NR8T+oPIfMOc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2ZCZW2a;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B08B360203;
	Wed,  5 Nov 2025 11:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A383C4CEF8;
	Wed,  5 Nov 2025 11:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762341189;
	bh=5SRIi5stLzkcdcYgZc1z4fAx+Z2JyFKQR3FvjHjXFVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2ZCZW2aZUwTmoa8nkSKTRxmK//+yjCM1ni6ddcN6a2AYWWlP5SJSR2XHIhrosRhW
	 FkeXgKxkwalJCUXVL8ZRXwgQeXt/nkskp6283MjlC7lTTeCuKO0Zkw5rnVB3x1YRyj
	 IkGK3GVWDlaFeAKTHY2TEjLIKEY99//uecF4P0nnE+tIuUkMXWSwYWhzQql1Ie+lp8
	 9ckfH2KMKURDpq5BwetPWNUdAICq3iLfszaq3L/zO8lfcUgUw1gtrydLEZ7qvHClaA
	 JNdNSh8riDJiNFEj6Da9MO+mUDJRlVUmuqNFaRAMP1KIlqLGhZV6b56epn4ksLHO18
	 yhbfDM0b0kGmQ==
From: Christian Brauner <brauner@kernel.org>
To: Zilin Guan <zilin@seu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>,
	jack@suse.cz,
	kees@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Wed,  5 Nov 2025 12:12:46 +0100
Message-ID: <20251105-gebucht-kaktus-f394c88493d5@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251105022923.1813587-1-zilin@seu.edu.cn>
References: <20251105022923.1813587-1-zilin@seu.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1299; i=brauner@kernel.org; h=from:subject:message-id; bh=5SRIi5stLzkcdcYgZc1z4fAx+Z2JyFKQR3FvjHjXFVU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRyGzpEqfTLxG8oWDwtuyDHk//Hodv72q+1JTE+rNLUP S2XwKDXUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJHIzwy/2USCQ6Uvv2ao9L8c P/HVjsyJzqGC0yd7/tFbfbhk50ORm4wMl+a8PfrdePHd3vzCqUfPcFe6h3vY+M7acmZhwS7tn6s CGQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e3dpg1uryzd188aifddu9fnyi4d9ko3d
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A2B740011
X-Rspamd-Server: rspam01
X-HE-Tag: 1762341190-305540
X-HE-Meta: U2FsdGVkX1+jHxdKr+vuWn9nuJKODGe5+odGWVw48sa1TpelN57vlfysgVLg2wW2GILnxcHwa1MKE4emjQviLaps7QLw3I2SMYAQsTNdrjhgCrx/Axb0X3N15BkATkbYqsmAW7SFhHs/Q5NKYtPRhmwp058TEaFsBotcPfkOsowtZhcZ6f9A4lA7FoQ+1zJ0mW0DUH6zadVtlPHEIE/6me+mW9OebIzOg6HZanw9q0pqyjfFTpfjngkTOLVRdFNAPJEo6/WLV3vy6XvFC4HtJaSn6D8tCFwpHDGWcqvEHP+6u6OJ6+nA0XAid5YJ1ZeGOH4TTvcH8RCMVIu2pjk10cebAq2c0WsqND9yUORQ+noxeG6WLRbL+B2j6ex2t4MGilcUT4owgCS1A4NcCymJbBIFXUigyzuzJEAkKey3LJ12+Y6ktmx7fJ8TEC7m3/I0UXqIneoith83X7XMH1q9HOZsDFRxbThbgIhZ58/3F6S5LedC4x3tHXPDf2PqzASa8u7BTAWejpiSjyU6VEH91W9PlxepNOuw2uE9W81HsQHUVfY+vwc01QR8cz+17yNPT7mh262jHRGwhI/xxUpIXJ8IVdbPfDWqaLUq4PYidu9W3RViZvK+6bhptc2/MAM2OtHn9Ri6O8CDHgSbGKoE+jyP+3bmaxQ4F5A6To/5l846roG8wPqu/qeDDS5Qb2Db3bE78/5iv7GShLBn59pwVSXwOmKTmwnNIiLU9cpnkYwLXCZn4KQ1Ba9VuHcdFPhuO8jRPpYuN0rBgZEfFyowVWa0Ycsfd75VES4yczJlLqV61NLUVve4n7h7ol+HIcPI4V4t+17V59aWti3eR9ru9RZk40KI/J2sSwBivbQ4/KL0+0El1yVpqD3+qHfJj+PRQCXexLvs3/kRtMKLfwPGajQ4zcNL9PbcHP5CqT6Fdx3GBrPPyySMjLSyyQAGuOYzNz5H3JIWu1T0i6mFVUm
 ztQfNhlg
 adyW2rBUDo/5KcMoeeoInsHTutntg8Zy8tHq7nnGuBdcQ4HV925P3btuQhfQxVU1YKKox8yvhOyio6/qlEPXSNduxNiz51jtKL1+KVf5lD6tb+b5JLOVN9qbLbcyP3cZ84tFimmlPk/Z3kHC1QXkV+qPRrD6jDN/nHHsZSs9QekWvmLWcrsCKMFNxUwZ2te9h60jIY+jyIS6NTvHmJ7Y9bT0U+7oQOnYVzJL+S1upiWeFfFe015f8KbPYOCs6vFbxrAQkBNGCjrR+YVdXdiTderAPFBBsASJxa+Xo37GMtbdhvrfMNOJhcPBrANSF2TGdHhhppr9Isfqd6bE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 05 Nov 2025 02:29:23 +0000, Zilin Guan wrote:
> bm_register_write() opens an executable file using open_exec(), which
> internally calls do_open_execat() and denies write access on the file to
> avoid modification while it is being executed.
> 
> However, when an error occurs, bm_register_write() closes the file using
> filp_close() directly. This does not restore the write permission, which
> may cause subsequent write operations on the same file to fail.
> 
> [...]

Thanks!

---

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] binfmt_misc: restore write access before closing files opened by open_exec()
      https://git.kernel.org/vfs/vfs/c/0e0c1b03d6d4

