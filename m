Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD26CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B438E007D; Wed, 29 Oct 2025 10:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BC38E0045; Wed, 29 Oct 2025 10:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B128E007D; Wed, 29 Oct 2025 10:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A00D58E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:53:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 732041A05CF
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:53:40 +0000 (UTC)
X-FDA: 84051445800.08.87E220C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id DC5E440016
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:53:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6i+Tpv8;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyCpitqWMdD7yCXV5WYiC8JZkRSQX5VzGoFOnyLmDhI=;
	b=ItHJxn8Dk+nNxdWrVITTOAWfaLxwT8skG6YWgxR/ilU+rqVFNbnaVJnS/wrbhus8Kag1gd
	POt83aqEXI+/Zx0IwFFSMf6ar1/UKPVQrHM0dRiGNhM+h/nwT2eBqzIp5Nu68WGixH9MJR
	tp0J/LuyiiOqLfvthZp4/NzAkYXDVP0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6i+Tpv8;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749618; a=rsa-sha256;
	cv=none;
	b=Nqn14IQ+YYUPDuBudo5hlFJ9FVODJa5QR+B9rTUWjfn/HexNegG3nnDD799portu6GoCsP
	/V+qlWHwLjoxIE3IDQa7x6Zz+Is9NmBwqJi+O+/lMN+1LWfdlJr6Pp0Sg0sWvslx0pVMam
	v2whnZ0ZUmgD3YPP5lFf4vHJ9KFo4Gc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F61660488;
	Wed, 29 Oct 2025 14:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75851C4CEF7;
	Wed, 29 Oct 2025 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761749617;
	bh=4N52YreIUF0OvAY3AgVuCEeEXHoxvfXQKpRpGqGXt0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6i+Tpv81I+RjXv1z/ZhRypcIVRTtXraq5U9iBWHQnvW+KkPDvGl1y2pSEVEa6fIB
	 Ln4x6wF3AkfAIwedEj981+iIN+wR6+btNH1aNeYDoUlV+PjuWWLC2qWuazlwsZDUyc
	 w6JEXBhDvgpuQ5ndnBinokI18XbR2srsXkcfTy4nMLpLT5LYAeO4NgeFX7Rl3DUghg
	 Y+Yu9YxHcIql1AYDpRrZVpwWLKrTXwOqAs1s25OG2ooUXYEvx3zM1w82Fg077igDaB
	 eTslPtXRVVOcLbKtU1sdxtLF6P6BiY2N2GMT83pc272G20lW+5PvUy3M8NbUj0mjMG
	 oZaRyJXLYf5Iw==
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Josef Bacik <josef@toxicpanda.com>,
	Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net,
	ocfs2-devel@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: filemap_* writeback interface cleanups v2
Date: Wed, 29 Oct 2025 15:53:19 +0100
Message-ID: <20251029-fahrdienst-klaglos-834e266b8e42@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251024080431.324236-1-hch@lst.de>
References: <20251024080431.324236-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=2522; i=brauner@kernel.org; h=from:subject:message-id; bh=4N52YreIUF0OvAY3AgVuCEeEXHoxvfXQKpRpGqGXt0Y=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQyaaVPuJ+i9m4br2nk2mOv3Hiqzuq8kEi/LX5pZ5Jpp 1hLQ0l0RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESObmZkePvsGoekGs9rdpbt ZmmmOZrb/hx/6K49NePTtSDdi8HVvIwMl5ZenxV508LqDt+pO5cidkrwHHy3v/970ayNXZffekh 4MAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z476gukf99fz1xoqcn67ai1cijg7trny
X-Rspamd-Queue-Id: DC5E440016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761749618-826782
X-HE-Meta: U2FsdGVkX1/7XWmGkCNy5GIdZOlh465rc81TY6hU2c3FvkUlljaJlkrHWHd/e4njFW/O0KO/ZCxGYZxCVmfYkcWdKZxg5zC6dXiOm6sz2nAGGZP82WqcdVjAUL+gadsfBdg5H10WDIf1mkmkYiESWmEFd1i+Q4Hfw38fJj7DrlvlKfGIug5Mg+i0gfKS7Kw/UEvb1iseC/k58TyHx/Neg4HDBgdw/D3yM/pxE2K6NlOsEgP2Ulz9ZPDuL05Et/PAvYcAS7+y99XjzUC/cLyvaoU09Alh9gOneUDuNcoyH+S8YL6uzaBkXt75Gb/EUDa65p9B/9HoqmdkeVMdPEzIfwNPcXT3rI2QSYp8zOHIsjdoIHsxtaN1W/SDlwqQjTSDvb2IfObaBYIJLduP4jwZCn1OzIpmT06CeQNM0x9B4JpmQ++NyTiLytN8UlysxPDgGnQOtkn+FCWpbwLzzY6kP9qsiuKj82UNu/z8iK39ThGWq+xO/59pdYvgFUeMbeSbuQuiikSUAlkjfoakoVfa0GbgA9RQ2iU28BjfB/VA5VxMGXGv1HAVKo7S41IXliN2LtFGKj060P37pUjaBi8Raii7yIhh7p68tVhxLhQViSxHuJtPo9xIF0GDA7nxqjjFIC10ILxeU7NJxtUiPmXiDMz3mp8IR1OjLmgzqB+VRVTvd9uH/FPVkzzDkgRP9+58FWhsCa/+dqdhplcBOjOR9wB4rDubPfl+ti73vVG97TTTMbfj40xWYXf4/UmjC5i2wXG87cURzBmnJk9OcWqp2cp623bJwLdks4/APXe6NbHkfcu4tLh5Mp1nnypRmfsbxUI1+fVF5S3gQpnFSGfAqu7Lt81SUfNWppz6qY8cFYCAckLbh95fXb1n+4v/9EqWzVxxy/HfeHZ23wm382ZTauED0624zA1A965Vr5jtnMT9eppGGolThYni9lW5W2cwaGWno8Ndnzv3OfvLGwp
 4+P+ru/q
 5u56t3wbOgrxNh9A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025 10:04:11 +0200, Christoph Hellwig wrote:
> while looking at the filemap writeback code, I think adding
> filemap_fdatawrite_wbc ended up being a mistake, as all but the original
> btrfs caller should be using better high level interfaces instead.  This
> series removes all these, switches btrfs to a more specific interfaces
> and also cleans up another too low-level interface.  With this the
> writeback_control that is passed to the writeback code is only
> initialized in three places, although there are a lot more places in
> file system code that never reach the common writeback code.
> 
> [...]

Applied to the vfs-6.19.writeback branch of the vfs/vfs.git tree.
Patches in the vfs-6.19.writeback branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.19.writeback

[01/10] mm: don't opencode filemap_fdatawrite_range in filemap_invalidate_inode
        https://git.kernel.org/vfs/vfs/c/a21134b5d6cb
[02/10] 9p: don't opencode filemap_fdatawrite_range in v9fs_mmap_vm_close
        https://git.kernel.org/vfs/vfs/c/3c2e5cee5eb3
[03/10] ocfs2: don't opencode filemap_fdatawrite_range in ocfs2_journal_submit_inode_data_buffers
        https://git.kernel.org/vfs/vfs/c/890f141da068
[04/10] btrfs: use the local tmp_inode variable in start_delalloc_inodes
        https://git.kernel.org/vfs/vfs/c/41e52c644753
[05/10] btrfs: push struct writeback_control into start_delalloc_inodes
        https://git.kernel.org/vfs/vfs/c/c9501112e3cb
[06/10] mm,btrfs: add a filemap_flush_nr helper
        https://git.kernel.org/vfs/vfs/c/7fabcb7fbabb
[07/10] mm: remove __filemap_fdatawrite
        https://git.kernel.org/vfs/vfs/c/735965144806
[08/10] mm: remove filemap_fdatawrite_wbc
        https://git.kernel.org/vfs/vfs/c/1bcb413d0cd8
[09/10] mm: remove __filemap_fdatawrite_range
        https://git.kernel.org/vfs/vfs/c/45cbce5b8877
[10/10] mm: rename filemap_fdatawrite_range_kick to filemap_flush_range
        https://git.kernel.org/vfs/vfs/c/c28d67b33cbf

