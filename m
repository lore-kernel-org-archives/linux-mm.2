Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6921CCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 11:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9753F8E000D; Tue,  7 Oct 2025 07:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D008E0005; Tue,  7 Oct 2025 07:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889AA8E000D; Tue,  7 Oct 2025 07:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 773218E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:12:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C7D3160109
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:12:11 +0000 (UTC)
X-FDA: 83971054062.24.19184C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2C3F4160015
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 11:12:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ANmC41sp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759835529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCrkHVN8AfNYb6gPq6xMzJLSS/ueB8r+qRFneBc8W60=;
	b=MPrefGte8Bytof6wVPREtyabomX8J2i8Cgk4YvaeGQNAdzU0Rib+aVjVMk6qFnVEPxgPYT
	VLT6cp+/6/F4N5YIK4+Qkg31gAmY0rFwMbavQ1CKzod+Z0P1fA20r7RND2ks6hlq3M48gM
	GfIS/95zHNZxNX+J1LkNzXHUPagYSn4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759835529; a=rsa-sha256;
	cv=none;
	b=KZ/e7j/7Mv++7cJAmdf45f5/90N9O6IuEhKpc+3RDuRWGHTyni9VVnxxMasPxRHlFXH+RO
	BPYU7IKJFntehh+6T7FVlcsqG9AqfcKjueXuOqvjSWmFSWiWosUIglCSPvOBmngMwmRvnc
	IGk42pJlaQDEWVfcKShZ2MYn20jdrho=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ANmC41sp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2C3643340;
	Tue,  7 Oct 2025 11:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0B6C4CEF1;
	Tue,  7 Oct 2025 11:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759835527;
	bh=y59Hzrx70QzGvjpVw8oWwWW4S1dfEWaSGLjaUnb+Nyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANmC41spX4gmn7wUij7P7tZD8nz7BBusmjGjVsPhQ8aJZLEVU6IBVDcTcDgFVNy8S
	 pOjZcm4W9qNA/xg4s8fJUu6yn8mVeNPdnvEUoA5BSuUSSkNJYsBQ8UUo9+EtToTBlG
	 7Xsytbw+3jMbftALxVs+2oTOqSG0/me62L7pB+ZwVuzaP9bOV6iRL04z0kdiJHfwnO
	 qJ+92aDjvIJ5dxmJIchmixRypEFLW0ECI9K8xUIthRQ4pEomVRmRGiHa54yDJ/8pMH
	 hwtiu4TNGdo9saqnfCoirkyn9MjqA8hQ5ACaVPafYaq8NYfjfdorsXSnx78qCJxsBV
	 0ar/opAtlzdbQ==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: Re: [PATCH v5 0/7] iomap: zero range folio batch support
Date: Tue,  7 Oct 2025 13:12:01 +0200
Message-ID: <20251007-kittel-tiefbau-c3cc06b09439@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003134642.604736-1-bfoster@redhat.com>
References: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=2134; i=brauner@kernel.org; h=from:subject:message-id; bh=y59Hzrx70QzGvjpVw8oWwWW4S1dfEWaSGLjaUnb+Nyo=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ8+do0r+3ezLAz+Qk3JpoH9Kstu7uDVcopNOHMwR77l X9ljjHc6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIhhUjwxGLhLev9fW37E9q Z7mx6/vSBV8+tE/zi7u+ZN4fpYyITCZGhjmHZN1y/hu02Us9Edi9v0/azHgBw4N13+dIKyQuN+e s4gcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 6yq4io6yf8r3rwzyzjedci95tipcq84d
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C3F4160015
X-HE-Tag: 1759835528-133113
X-HE-Meta: U2FsdGVkX1+k9ms+uol9OxNkBlT2JRof62EhrYhi9pgFBVFUrwu3vAdVkDkri7e2vTEtq+i8AK0hDsUBk4JarjX9ciKNwVQ9sv+4q/2vzSO+jtOFjGqxEbm77MSHpKQeEGtqyqHjJuFGv94W8cuoSkB0G6NCJl2xuEYXCAxmlnbvS4057yhjQ51puoLp54CJwG0fnrv4lD40zBL0KLjFaeBQ9U0mN0FcZGnuZYXCHa7bD3Cs6MIrDyKmJgTGv7nUxe5TBoQhmMGIGSI3AFwX51oCAAkzHrgPr9QqylTJHrk2DqsLyCqLrEYl3Tge9XMrjLV0uY8tH0qrX3d2IRUiO0pivbAsVLp7as4CDbUbZnTcEploM7eCP/K/I6g9PqfT8ahvHt8CdTbmA7Tuvp8w8LY2E/1XxwWakPJPn4MM/eOiSdzklyXNP0ijxOet4t+9Me2HJ1MThSqY3jHG5CvQIrzWmvMFSe/BSf42iMFgMbOCkfJtG3LXjf7WE1Jtcc1rW/oAfpvDpXRfcObMIXbMrLSaB8hGQBZiThj7RhA0XYoyZOT2Uv0P+mayM2jR///jmOAPwoIDJ6UAPPNJ8Dyqb1i+YerKvhBbgA1zV0AuhTJDUfsmFc+eZtOhDSxKY8aVIQ9NVhw8QQV6qBT3HGv+zkKNesKT7KQJB3BfbquAQFWpgnqULKOQ85zv3/GvJ+lvKX6nycgdx6kFlQsBwmgKl3aJyPQZKteWR7afGzzKnheOWK+I2IjKSG5D7DqIhCrO9A/q8y/5mfwdx3MvPZPTAMd6e71crFDA547h2q9UU3qZKtgcNft5iLgrrBVQ1I1h6ROsY+InxDh7a1Ij3WAeM3W+b9DuGLLihb/X7atcZKF2oKmk5w0usgMvwjSHKwph0npmmNkvrnO9pY0u4QjHW49CKl8nzCkKEF2j5oxQ6gNv9MGKjDNVCgOno0tG3JmpfpLho0hBAgFMesqsPVg
 pUkgxkQB
 f9NYQBf5nrrJoHZZmkNWoo3cfiL9hC3ZPrnxQ0NAY8kLTIqBD0HTeVto6kUTc625e3LRzpeZJyHV8LxRG1/w+5tmQmvTqlVCjtUjDj+rauzI0ABdG4o3OI1h9tO/EuB71PzDrNyf0lZzL7+5L1LECKpo1T7xMutcHjEnmZz6vuu7MF5JsEZNCt8yWc5t0fKGuBY/rTgmvcJuceFDUXEyioultO3mz0VyRyVvLK4bLK8Wr+yCt/058VHZSjHPd/Eg0MKxvUQrYh4MFgjri631KbJShrdHi+Eh4YPou
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 03 Oct 2025 09:46:34 -0400, Brian Foster wrote:
> Only minor changes in v5 to the XFS errortag patch. I've kept the R-b
> tags because the fundamental logic is the same, but the errortag
> mechanism has been reworked and so that one needed a rebase (which turns
> out much simpler). A second look certainly couldn't hurt, but otherwise
> the associated fstest still works as expected.
> 
> Note that the force zeroing fstests test has since been merged as
> xfs/131. Otherwise I still have some followup patches to this work re:
> the ext4 on iomap work, but it would be nice to move this along before
> getting too far ahead with that.
> 
> [...]

Applied to the vfs-6.19.iomap branch of the vfs/vfs.git tree.
Patches in the vfs-6.19.iomap branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.19.iomap

[1/7] filemap: add helper to look up dirty folios in a range
      https://git.kernel.org/vfs/vfs/c/757f5ca76903
[2/7] iomap: remove pos+len BUG_ON() to after folio lookup
      https://git.kernel.org/vfs/vfs/c/e027b6ecb710
[3/7] iomap: optional zero range dirty folio processing
      https://git.kernel.org/vfs/vfs/c/5a9a21cb7706
[4/7] xfs: always trim mapping to requested range for zero range
      https://git.kernel.org/vfs/vfs/c/50dc360fa097
[5/7] xfs: fill dirty folios on zero range of unwritten mappings
      https://git.kernel.org/vfs/vfs/c/492258e4508a
[6/7] iomap: remove old partial eof zeroing optimization
      https://git.kernel.org/vfs/vfs/c/47520b756355
[7/7] xfs: error tag to force zeroing on debug kernels
      https://git.kernel.org/vfs/vfs/c/87a5ca9f6c56

