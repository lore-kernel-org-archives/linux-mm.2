Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DEDCE9A03B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B0C6B0088; Tue, 17 Feb 2026 16:14:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E616B0089; Tue, 17 Feb 2026 16:14:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A926B008A; Tue, 17 Feb 2026 16:14:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60BEB6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:14:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED3B3C1893
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:14:40 +0000 (UTC)
X-FDA: 84455202720.01.255C08B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 52B6140006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:14:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qME5lVPC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771362879; a=rsa-sha256;
	cv=none;
	b=xnbW3TGex1DjrEJ7OWSsjabxcakF4JTzC51s3kp1Du3V/RyK6eaoeR6Bc+KSmleRuvlMFg
	8CTZ42+gzfgPY0dbxrbXZ0Y0bGDlPtdzTli6wNiFAkbrU1wcDN0toumzbD/ae5YGLxoJef
	9zy775Hd/pWrF8ZZE/FOXTF7YB+m5QE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qME5lVPC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771362879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QAFZrzsR3b01tUvyixH463bVn8gaQeXSmMleluN4G8=;
	b=zaN6CrY13L66qASh/xA3t9qJC+kbFpQLvdDDn11+DQie9JAzVSYXW8SW68lm1rPluPVZvP
	wM1+9Pj9gwWPHOQAiCjo9HYneRxK+j1PPMtMARFSaAzJlqha6axumB2QRhROVJmNV6YQ4T
	dgsgL0DvI4yS0lfpSfadA0DE1kXdbs8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CA3D60128;
	Tue, 17 Feb 2026 21:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05413C19421;
	Tue, 17 Feb 2026 21:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771362878;
	bh=SWr3Pg6zIeu2S3Z6UDsk8BzZU6tf527GPJ41POMlghM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qME5lVPCgbs75GtVkYDVSedStUuy5Pu7iKCY4IKu3xqN3EcQE+Oh5yA77hoZy7VyU
	 +0wZZYMpZQVXM9oVuFBmRCNz9ULENuT2B5em0ouDg88Yb0OXaPujVB/GBPkgNNMpHr
	 EhgPO+uLpu1WI515RTCnoSYcSuoUoWHPdRcl280BUTS4HjHiimnSyoFiD+9+NmEu7s
	 4m0WVXB/a1C6i48qotqtPrvf49sFdMixg5MNCldkNycO7JhTW+IJtnP0WEfZw+8dYi
	 1uYBY6iDz7huxRyc2w6LATusfRgMkVW0RAKYcp9Uufer3E7jADONKO2Apo8cM0wFiU
	 pB1OIFY+N5Jzg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B1123806667;
	Tue, 17 Feb 2026 21:14:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH 00/24] vfs: require filesystems to explicitly
 opt-in to lease support
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <177136286957.643511.1991968143318289235.git-patchwork-notify@kernel.org>
Date: Tue, 17 Feb 2026 21:14:29 +0000
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: luisbg@kernel.org, salah.triki@gmail.com, nico@fluxnic.net,
 hch@infradead.org, jack@suse.cz, al@alarsen.net, viro@zeniv.linux.org.uk,
 brauner@kernel.org, dsterba@suse.com, clm@fb.com, xiang@kernel.org,
 chao@kernel.org, zbestahu@gmail.com, jefflexu@linux.alibaba.com,
 dhavale@google.com, lihongbo22@huawei.com, guochunhai@vivo.com,
 jack@suse.com, tytso@mit.edu, adilger.kernel@dilger.ca, jaegeuk@kernel.org,
 hirofumi@mail.parknet.co.jp, dwmw2@infradead.org, richard@nod.at,
 shaggy@kernel.org, konishi.ryusuke@gmail.com, slava@dubeyko.com,
 almaz.alexandrovich@paragon-software.com, mark@fasheh.com,
 jlbec@evilplan.org, joseph.qi@linux.alibaba.com, hubcap@omnibond.com,
 martin@omnibond.com, miklos@szeredi.hu, amir73il@gmail.com,
 phillip@squashfs.org.uk, cem@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com,
 chuck.lever@oracle.com, alex.aring@gmail.com, agruenba@redhat.com,
 corbet@lwn.net, willy@infradead.org, ericvh@kernel.org, lucho@ionkov.net,
 asmadeus@codewreck.org, linux_oss@crudebyte.com, xiubli@redhat.com,
 idryomov@gmail.com, trondmy@kernel.org, anna@kernel.org, sfrench@samba.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, hansg@kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, gfs2@lists.linux.dev, linux-mm@kvack.org,
 linux-mtd@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-nilfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev,
 ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, v9fs@lists.linux.dev,
 samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org
X-Stat-Signature: x7btmbs8dwi4mssois8ankwo33jk8rfg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52B6140006
X-HE-Tag: 1771362879-620103
X-HE-Meta: U2FsdGVkX1+nBfSMUMW1zZH3wmGwzJBnLk5F2M3kKaFqFYgqkPELJ3wzRySNHYuUcvMPmiggguZR/Te2YvAUD5HOpmJktNrx20YvUOWwhPVe89Qc5EjwPDYOAei8zQ/3w1AqD5lTEb1sl6vZftVaWD1bb2OOHqeWiVjC/RmPwNQsLRR/Hs5ELJYKN3XuP2HjzCDtGMIOX9saIioTRXtEfwtSFv9TvuAbdTmbxmRhZL5rNFQKRbw0DxIHxeGcpPbR7UWBh3jxUA+3zK0KD/+8pXmor9NZYxTeN+spbMH2meeU9rzJtqDpxMFKWTYoVgCg33vjkS9EC9JN7Oyvrw/v9lks1Iu4GSzukM+o5onlTJ1M06sVFHwxaztFL+XEPCQS76YYTtcv8wbKWTezjbqQg1Z+P0d62bcpnFwTebo97GqMZVVKoO27rLh1vc8YZeMm+bOyHgENis+/Zv8aFqaNDbJLkuiqek128XtMMp0objKgJ5IaRBFdWxyNLPxnNibl62DWZs8yvDVJcGy6xR8h8j1RfFvZh+AiTbZcfcKdm6S+8SZr6F63CKP0SKGf4h+GwD5JHQvHRWeCABgw8ogyODQrkYnrkwwvMg+tbUr4erlfmXJBnxLbizXzrySutr8s1/EvcvUzcGMtdIQtuWg+EadUQ6EuRejJb88vzxk8jsu3Ps0zTNx5UKqBRo66xfV+UgaWXsAnxMJfT6oTuTfqUBMYPYDJ4I/Jck4mpmgPoNR+v5Ebt0TxP8Gjjkrl1JPJ5G/C+9beAFs1IxTj7x0jPwJ3QvBOhEk34qCFedErWim0MOgd+rBSN5jy/RNPz8zC/XQJpxdGe2qRgk7p0EzWIHraHb+myEE9+H3fXhGdZMHffRPh22ih1gEeV9fSD9L0Vxf80mm5LbLT1VnNFydy6vggnf3ONUC3n3g/SNgDdIq0sonhk+sEO7FWXoCR2Q5IhAaTjf/G+I3bLi3zyP1
 MS8vHMeI
 ooQII3dbayAe9fIKi3wroBFbw3Up2jflWjS/+NJsw3O1Y+Xr0v/dZULnlPaRGbOgzQABYm5SFU09jWOMLHEKbFsZIhF1tMfKA2+6/LEVRT6hTcNvKalGi3LQ40rY71HEfKOXOWpgKDuXpuGzEjGuRcl2i7pnD6jC8uD14RKZ0rltaD/rb3J5n6aSamzFvjKxQssnXSITGX9dZEz6fQoYScREcwwQduiJwHyDpANLKnAPfN79UBpPjEAOK/fxa2ugbNJWNMS6cgBkaX/eD4aPxAXRS8RRITfnwLo2xxxhl8pEtwb+JyVDMSUTNB5qe1KF0cWCOrA12t4QK1/X1s9qm8CTVCK7j1XOQX+ZZztPvRn7O9OHoObXcca2iOPAnG8l2IiNDTDGXVPhuqlPg9gSvpDOXjgkzzOybiQPlruG9Py5wijSYSk5n75eP2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Christian Brauner <brauner@kernel.org>:

On Thu, 08 Jan 2026 12:12:55 -0500 you wrote:
> Yesterday, I sent patches to fix how directory delegation support is
> handled on filesystems where the should be disabled [1]. That set is
> appropriate for v6.19. For v7.0, I want to make lease support be more
> opt-in, rather than opt-out:
> 
> For historical reasons, when ->setlease() file_operation is set to NULL,
> the default is to use the kernel-internal lease implementation. This
> means that if you want to disable them, you need to explicitly set the
> ->setlease() file_operation to simple_nosetlease() or the equivalent.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,01/24] fs: add setlease to generic_ro_fops and read-only filesystem directory operations
    https://git.kernel.org/jaegeuk/f2fs/c/ca4388bf1d9e
  - [f2fs-dev,02/24] affs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/663cdef61a27
  - [f2fs-dev,03/24] btrfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f9688474e413
  - [f2fs-dev,04/24] erofs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f8902d3df893
  - [f2fs-dev,05/24] ext2: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/ccdc2e0569f5
  - [f2fs-dev,06/24] ext4: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/20747a2a29c6
  - [f2fs-dev,07/24] exfat: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/b8ca02667552
  - [f2fs-dev,08/24] f2fs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/9e2ac6ddb397
  - [f2fs-dev,09/24] fat: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/a9acc8422ffb
  - [f2fs-dev,10/24] gfs2: add a setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/3b514c333390
  - [f2fs-dev,11/24] jffs2: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/c275e6e7c085
  - [f2fs-dev,12/24] jfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/7dd596bb35e5
  - [f2fs-dev,13/24] nilfs2: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f46bb13dc5d9
  - [f2fs-dev,14/24] ntfs3: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/6aaa1d6337b5
  - [f2fs-dev,15/24] ocfs2: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f15d3150279d
  - [f2fs-dev,16/24] orangefs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/136b43aa4b16
  - [f2fs-dev,17/24] overlayfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/94a3f60af5dc
  - [f2fs-dev,18/24] squashfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/dfd8676efe43
  - [f2fs-dev,19/24] tmpfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/f5a3446be277
  - [f2fs-dev,20/24] udf: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/dbe8d57d1483
  - [f2fs-dev,21/24] ufs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/545b4144d804
  - [f2fs-dev,22/24] xfs: add setlease file operation
    https://git.kernel.org/jaegeuk/f2fs/c/6163b5da2f5e
  - [f2fs-dev,23/24] filelock: default to returning -EINVAL when ->setlease operation is NULL
    https://git.kernel.org/jaegeuk/f2fs/c/2b10994be716
  - [f2fs-dev,24/24] fs: remove simple_nosetlease()
    https://git.kernel.org/jaegeuk/f2fs/c/51e49111c00b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



