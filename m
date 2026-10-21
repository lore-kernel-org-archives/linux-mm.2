Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B76606A325
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TGfrVpnG
Received: by kanga.kvack.org (Postfix)
	id 661AE6B06A2; Wed, 21 Oct 2026 06:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611476B06A4; Wed, 21 Oct 2026 06:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D876B06A5; Wed, 21 Oct 2026 06:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 330796B06A2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:26:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B24A1604F8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:26:41 +0000 (UTC)
X-FDA: 85346254602.27.5458647
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D55620005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:26:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TGfrVpnG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792578399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XaHS5CUayuZ4u9kYgWWlcU+lZAuboyv4HW7QhXr3ncE=;
	b=axi5edOZKnT2qIugjTij3cKzoZcBnEUXOxZ3qnVFdNDLkW+oVaHvEC1UJlWDaLxAGhNrtI
	T0YE0/N8B/EPjzsUN1zTVbcgVsBdZSLcAAVe+tOsk0GXkL3GmkbBoExaxJC3ClqcqAZyA9
	cQB0HfEcusGifOiuWQUvL1IQJqLWNTM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TGfrVpnG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792578399;
	b=x63bsX5TxN/0xmiVk833gpaitcoqFGFCzHDdIB5NXOastMNS+obAPNgqDh61WOzuwaSLu5
	j0kUHe6QgSUkK9x8kW3aW1aZmmC7AL02KlLbESErb4f+uCWm9ZXd+9ovZ95l1MqgNWhVJe
	um3XOAYQupToyA+hKlT2mSSCghM8AIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED25D601FD;
	Wed, 21 Oct 2026 10:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15FA1F000CC;
	Wed, 21 Oct 2026 10:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792578398;
	bh=XaHS5CUayuZ4u9kYgWWlcU+lZAuboyv4HW7QhXr3ncE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TGfrVpnGhhnz8+qNwr+F5pcYKC43Xf9ZcczIokuC0v1hPtmmCmJFr2xauE0qDt4pb
	 XbK4/KakoluZiI6SwivbuUoXLiUyxZeRMjGm3hzKUHhpGkiK47M8vkn6F2pNst+AJL
	 qRb1pXCujiW4DTLfmVmkaZseqovwIvkrK+iUzSWRMsPGkc8LNypyM7bWXBTTLOBES3
	 Hu67TgcejmpIKFhHjJYnpD3I47/XGJcEob6IFWSUozEvlvlb5cndKjVztaUrTUbSGC
	 2ZQcy7LeEu5ABVn81q7IkcFr0ZvtjkoIUvxfIO6VZQ+Wozc9hIDwbr4+BQ3IbYXdVy
	 o9bpETxFMIQaw==
From: Christian Brauner <brauner@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Nikolaos Karaolidis <nick@karaolidis.com>
Cc: Jan Kara <jack@suse.cz>, Zhihao Cheng <chengzhihao1@huawei.com>, 
 Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261016102515.111285-1-nick@karaolidis.com>
References: <20261016102515.111285-1-nick@karaolidis.com>
Subject: Re: [PATCH] fs: rotate inodes whose page cache could not be
 dropped
Message-Id: <20261021-geburt-heimlaufen-junitag-f8fc6bf55c5d@brauner>
Date: Wed, 21 Oct 2026 12:26:32 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=893; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ENKdDygeOB3ZkTFNXhwRYoQgyxPbVZNMT5pmJM216mA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdmBw1M21TvtRbzs1upidOfpL03edin8js9WqvfemUi
 bfPyez71VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR8DeMDA3TTBJz1WdP/nPG
 3i4riePENdfJDDK77AVzjUyUn6zd0cjI8OjYpV2+LPrcLzY9Pf/sZ8GarxbbjCetkq2OT2epW1o
 swAcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 7D55620005
X-Rspam-User: 
X-Stat-Signature: ywmyc7kpnwajedq4jwwpjoaiqeym1y3w
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792578399-127114
X-HE-Meta: U2FsdGVkX1/AvNQLLvyq//ZrXJ9/VMNQyFiUCt7sNsXLSFLa5YSOT39FIRk3/IIuxN4RiHpA/WIDYJlTsqO//ZGgBl6sClNUp+bgoDTraKmCRsTBBb0tzdCqkDnBEu/VfZlT2J1KOVoDR/rI6rWHHgQe+jDRf7pD2nozxewPaQU6mvt0/gc5UdIEhb0OaG54b6LSOoZpfQeNo2g9/HWx4vwWx4O+S/Cl4BdGkg3+55u/ptHo9SyD82HsEY4NaPBsrlWSShYKj8SEwaGFARdrKbLAlUi/AIIGgETC/H1THjQ455SB4Y2JWdrMs1z81GDAts4bOZaJ1GO1wQsm2bH3cWwcRs6kR3mKv3YqTgT3mBDHSHFsqAJRK3t+C3O69X/Fwh+PoKzHfiJUUiD2bsc27XEqeW5R6LoFlWgxOVMYnCB8fsVT0/fkjoe6ax4l/2kDc03kQ3BRorl8BkAGErpk6fGekUIh14PT6WT6cQmdngS8jQzzQK+uVzufR0axPayik8TXTMI1omCxctGnxJMghYNHbd7/yJjZyxsr0tNDy3EQ9sIGamfeiZzXYOsAbUdyrdzl8e2u+9Zzq+RNjYNHpOvcwpd4lkmkAYf9L3TbVgLaCNZH2Jwy4R5/jk8A64SNYQN0g/XlGq86qfVFTaB5qVIrNrvgkQOiJa0Ijz8jwp/4LLwSqjS3FjfXJkNldIUgTy+r+jfWvk127s/3Ap3EB/XcY3IqYkX3fh1rCQEPTy00w5ZTqJlFq4E7BJRYUPWMfn/EDc9VMMnhA/2jLxnoo6uMxcY+/PEYl43Rj4TIi2BtPtewgrLXmCbjjHHnppp8uh/ZuqhYphxfjxx3WNE5EzeLCdTDmCHKXJz2sIztvItOCEwTIRcCNTQH/7gT++tHYSpv9k5ZY5CcpgCZv8DpppOav7Kwhvs/AyqLyGmNYTh5CTF9jwCViiT6l6XAcBebD1ixUBkdNd6Diat1IDK
 8R2vNzqE
 jMl6w20f82MLPU43nbgVSK0vNyjsq6fbYWkPiqkT1DDH1PAQ+/T5ciN69HfxcGNwhdEOdQrD7DAQwiXTHcOS/A5g6DSj/bS7MDnO7iaMAibx7Qq9ksKLzNr3sLcQbVh4+/Dn2YX7dL0FEp8ycfdLVfa2CTz9LfPPB7T5q8XDMAs5TWUr5KCBIt4Y26evC2r7+GBe5I8L0UH4OVlEfWbnzXlPS5vUJtjo+ITuE7ROuketuGCgZMseennI2l1rZVJhvPB6x80+7mgHnlMbr9N33XRLoXFY/HFdpa2kM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 16 Oct 2026 10:25:15 +0000, Nikolaos Karaolidis wrote:
> fs: rotate inodes whose page cache could not be dropped

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

[1/1] fs: rotate inodes whose page cache could not be dropped
      https://git.kernel.org/vfs/vfs/c/efe3ca110fdb


