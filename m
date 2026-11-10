Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E0B606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eaD/EfjD
Received: by kanga.kvack.org (Postfix)
	id 228E66B05B6; Tue, 10 Nov 2026 16:54:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9976B05B7; Tue, 10 Nov 2026 16:54:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF9C6B05B8; Tue, 10 Nov 2026 16:54:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D900C6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:54:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 658C880116
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:54:18 +0000 (UTC)
X-FDA: 85420563396.09.CFC1E04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C8C0440002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:54:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eaD/EfjD";
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvR+7LpUq2XDou+hL2YOto2Xs7eBH6ZEazzzuluspMo=;
	b=5UOG4Z+wnB7rEbfn+YPw+DbemR4kgC7kJFAT46TKjpPEoJfHimcc6md+WwwZi3wPDKVfjv
	eCiB7FV+rWp9sNzwc89hoW759btt3woLc0lFmseowAKPs+CJM/g6VThpdKdhPHMeiZiPg4
	V8IJaTgpUQdkIu/u3ByoBIJs7w9ewtA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eaD/EfjD";
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347656;
	b=DKJeghX0i28HZldpK+qYXHnw67MKrh1r1on0wC8+xJC0d1iBHYX3fzWdey7J3mk+dgbt3j
	keFuZ9biuf/DgRCzjxO/4TjCYqXdb+X94AHqLY//2zK3dpA21qbkHryih1wFZ0Srf4u6ek
	yrVgvUUVf6Ga/BY0D2hF/fsUkR1V+XU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F30D405A0;
	Tue, 10 Nov 2026 21:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1531F0089F;
	Tue, 10 Nov 2026 21:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347655;
	bh=kvR+7LpUq2XDou+hL2YOto2Xs7eBH6ZEazzzuluspMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eaD/EfjDchFyH1dENQH1aadvOuz1bw9jbkiQnmwV7pFQSv0SPcCuHPSy3cg1AgrZf
	 u3NXwYhS+orvWDPCpPXaZyNSS+GoUOox6PG5uSdjRvqr3AzMoDafKsT4tR++Y52zyq
	 O4s6HPV/ywyAlQatnavFQ0pBIjmeaDW+xUB5+IzysLQjiA6eAAw0QEBP/TtTETgLFl
	 inp8RjcCw8Shmo9xA+CQnGybqXHfRUFl8MavInvwFF2mGgTJTmUjNtLd4cxgdb5YmJ
	 zo9nAVwddgdwCbsFwqFgDPymJKL5pmccIM+9BnPTJunzaUztEcw+2CGbHe8zKjhAGe
	 JD2NE+KXutgNA==
Date: Tue, 10 Nov 2026 22:54:09 +0100
From: Christian Brauner <brauner@kernel.org>
To: Zhihao Cheng <chengzhihao1@huawei.com>, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
Message-ID: <20261110-erfanden-dossier-zahntechnik-efcb7a6439b0@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
 <0d472865-6cbb-cbb5-b361-1f2bf71dd528@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0d472865-6cbb-cbb5-b361-1f2bf71dd528@huawei.com>
X-Stat-Signature: mxbcnr6jpjb1xycg8fcac7wqg57m65j5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C8C0440002
X-HE-Tag: 1794347656-867579
X-HE-Meta: U2FsdGVkX19XOlu3o26m7vIE3r4WPUZJV0zknGYHTJDYFwYr6un355AwAqJalwErfc0TfHLhkaa/cKtXLbrZjvZ7Mu1Si/U0o5QaWFiyQRKExORAOQZt91tz61QELf2eV7wPmrcXOz0wBB3SK8Tp78bOhNQwDliMG87dVa0/LAuhOaMdhFyZ0LFLQPqmaoNL9l0+YF7MjMoWlcZHGqmo+nvz46BaGUJfoZZIhtMDub6vaH3S4tpscL1TI4lo/xdqDec7nkJ+0zVojHSG43y5/oqclSskbVfc+M5QCIP+L0HDmEmAsB+/MZr47H04F8pmJBwAbD6TiHDp4i+DGXpMEOSZtd8sSLFdmlPAMhfenowf1hwpcd55/2eT5wtgHlP0UsguqVTd1iNOXZTJbetsp0aEcKCVQG7oEchzb39ZsovV7USWWkmhfjQ4iNro+qJ0YUht+YcChWqBJlQwjfhYBLgIvlOND+5hy75lKst4WVY6jet7SWRMraJHsaVhFSEKILiB+EM7HNPy8PvrWNf5IOZGGisXvxkdxoUEEg0QhPMogh2NF6EdTgFZlXAh8mu7wuLn6OdFzy6aMkT4GiwrXuw6SgHkVHk2/ipbEEVuTcvVCemMgr6KPDIWa3050PSmcHPQF+XzcaGPY1CRXmt122AXZ0pAx8+q2Dm55+lYCUqYY6V7mhKzjyr1jLERMJCzBEXbihp8UNEHb/eJ+TETo2yIvinw8ev4OFgPRZN0h4hCLWHaOwrLKbLbPRJJZD+F0OcPVB7IsUB6DkdlFtrKLrrucZB8IWGXJg+nQnauf9b4xcF7uo2JlYidFa7b/yyqarXgC+eFZRruvbnr/U44SmfEdUsM5SuGp8uT9O4LChTezjysdwLcB/IRK3bURD84+WU6jOF0hmzAKrPu/b8q8Kd4qKvf3FlfJDsgvLz3s0K2At7dbfKrFT5o0EaYMJwDjG2DUI/vwBwYnLQynW3
 ywV0hXF1
 EhsS5dtt3JXaAPWxXFKqeaRjh4EEVRAqXP0+kqMxanbAi4nbMTWb/9i5krRXAdctLRbwD5a/5Zugz41IDAnXFx1FECuyXcgpV50/CZQvmYzljJYt6ds9PcDuYedwlnQ1gTc4fsIEYExTaYIH/szxJVZUqzhqV+PleSaQgBSvq/GILxE2Yti14Mr27vxjl2dPd6DA0mNQO6m1Jgaxs6rQMppNUXAanXbVZCnVY+1eKfvqhggc/Z6SXpRkvyaKaW8qEyO+W9AMZmbh1jdX7UJyO6HmUlERh6Skmtwecc4Khv4FQGOsr7vW/9C6TWbms0Vl+2bZHRt7gju5275mBKJ2d79su26iZNrgs5BwRQLEBvf4gu3a2AMeLoSBkTDfNwWKgjWIGpe+LnDUv7SA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 11:42:15AM +0800, Zhihao Cheng wrote:
> If we remove the c->ro_error check, ubifs_remount_ro->ubifs_wbuf_sync
> will return EROFS and trigger ubifs_ro_mode() again, I think we can
> retain the pre-check placement to trigger more error printing.

ubifs_ro_mode() doesn't do anything once c->ro_error is set so that
won't print anything again. But there's no point in syncing the
write-buffers and writing the master node after an error.

So I'll skip both in ubifs_remount_ro() when c->ro_error is set like
ubifs_put_super() does and only cancel the write-buffer timers. The
remount to read-only itself has to keep working because the error
doesn't set SB_RDONLY anymore.

> BTW, a remount to read-write after an error is refused too.

Only if c->ro_mount is set. ubifs_ro_mode() sets SB_RDONLY but never
c->ro_mount. So after an error on a read-write mount ubifs_reconfigure()
takes neither branch and reconfigure_super() clears SB_RDONLY again.

> The sb_rdonly won't affect the sync_fs_one_sb() after an error, and
> sb_emergency_ro check in not added into sync_fs_one_sb, should we add
> the c->ro_error check in ubifs_sync_fs() to prevent the failure
> ubifs_wbuf_sync executing?

Yes, I'll return -EROFS from ubifs_sync_fs() when c->ro_error is set.
After the !wait check so sync_filesystem() still gets to sync_inodes_sb().

