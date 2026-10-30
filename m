Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9FA606A331
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=P3EUpEDX
Received: by kanga.kvack.org (Postfix)
	id 4A1C06B05B1; Thu, 29 Oct 2026 23:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479566B05B6; Thu, 29 Oct 2026 23:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE396B05B7; Thu, 29 Oct 2026 23:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8C06B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:02:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AACED120564
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:02:06 +0000 (UTC)
X-FDA: 85377793452.22.8FDEE1F
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf16.hostedemail.com (Postfix) with ESMTP id E169E180002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:02:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=P3EUpEDX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHLQ7b2LcR7am1RKbZkh1e8kwZYbJ2OrwqImdsIBbbw=;
	b=F2Hz8CXwoJTpKb08fLdS+EHybKKSX1+GpHrKb5E/FJ9bfpWbWJ/cYt2oYvAqTO/5lP6aUa
	2EJcMvfHANc3tiBvK0r0gJS25BeCLcV0nQb8pMGB4nduCZys/tQqExVkFDhaaxyUGYrGMg
	P8+1Qc18VmmiybsHWu7se5i4ehA+UXU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=P3EUpEDX;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329325;
	b=yUlW3gEh4CgqbjqbAeP9YuFpkTDlQbL0sBkeKx8cUb7Rsy++CTf4ZwxZsNJRGfOZcdojp9
	F4xeZoKisAGrCBe4c9wxVtyr+sMF0uFFenLePq1D27KxxGt9b4aMMVa/ZsH0erRiaZUL7m
	loYkzsNfv5tA7rWUbI5y2MZffBXE2hk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793329320; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CHLQ7b2LcR7am1RKbZkh1e8kwZYbJ2OrwqImdsIBbbw=;
	b=P3EUpEDXjFYc7t9vYYRCz1pheQWh2OCsVgQHajoLYY7mar314/KyFODZ1m/Bx3732YPlUX/9mgkhkxHtZvlKaP/r8tG5iUFYR6RjeVEzRHEvZlb44qO001lYjE8WqGw+itEsYWrea5uNPR7AtSB9r2wsmY6F8l5pa5OuFFW0k30=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDkxfAa_1793329318;
Received: from 30.221.129.214(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XDkxfAa_1793329318 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 30 Oct 2026 11:01:59 +0800
Message-ID: <736cc238-0af8-417b-bf3f-5e8b002badaf@linux.alibaba.com>
Date: Fri, 30 Oct 2026 11:01:58 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/34] ocfs2: don't set SB_RDONLY after filesystem
 errors
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org,
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-20-2f44f64f0b66@kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-20-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E169E180002
X-Stat-Signature: i4cb7poqhzuo3kftdyo533mmwf1i7ut4
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793329323-890128
X-HE-Meta: U2FsdGVkX194NjwejrewrXdXYkVU5urAmTiToTG0jpXJo2C3DN+izL4g+cBpefTWiE9Qba+NPZfCaIafpWRn/FcLP+VA6FMOuvI96ifYZGfSam1W31NTwraDzjcs+PACtRVHPg+bKzCMczwglaUTygRO9LZ6sjJMhFSbRo7BzMYAUZEa5Pxt8cRtpP60Z6jk2X3TCgjK5tMPceA412e80ZCfHPPEYkgpXlyHTHgcTqzqEYhgorPK1u4htXAqXawZglP1Sgb3FVuJj9ytb6DBpdOi+fq7UDMnP8NOR+zcoA/kSoTJeQlH+OkDMx8gyLI5ZUneH7Gz3M9PeUEbTufxNrW9rmYGX9Fp2MEbY+rbi7EuYpVb+KMpVOMUkadDWCwwfXQ+URvRJpJ3AvqNXE4h/J2ucixo6tMCcQvadIwJLT1ds0uxpfo9h/rBNRufKYJ6jMPNxi0/gm/1SNfB083duHTpSpa5nhG3c9SN6N0xTsHf7uOggewfhkcsSh8+oeNummwx/bgxKShv4e/ii1psEYohH4HP/XER0ntI9UCFLVcWY48HHO5cCox2tffEMP+BRVGqyDeJ+GkgzoQ1xwIeGGr4fJPgiQKGjwdzv80HgCagKt2fTcqA6ZYwi4gp7KoNF7K6kktgjn0kW+QkUHtOcwnHZZBWwF7YV+Ckq84U2CP5v15X3SsviMUNrZMHul24c7sVsk2zt2YqHCrgG93R4m4tLsQZl1hKzwCKqFKxhAGnTJWd+1YUKFuTGVu9puIYxJx5v+8lGyoubrFx0WwQgUN4pwmQ9hlSYF7xk7XkWbFKRogjIBm56UmwDNXMjDz54nX5bYRddKbu57LrApbZaemHqX9OixXRmQmiVrJGCfkqZPegKUKcn+HWvMfPJLxUmZftQQRouGZ6ZgYjQ8a8rduvMS5jIkcwzjqtSTsvL/RYwDIlYyjnuXPFiodI+qrk/DxkN4XrBBWU5z+wnJm
 iFLumaNN
 6OmmqkcB5J//+a6BPE7mUE/y/rrNZvyI54q59FKIWODoOd0Py3k0of+2r49x2KIULJSBdW6hD9c6AniNS1HjKPvJtcNTqE5Sx/i7PBiXcZKc16Ezpa5gUzFEQZ84R/faV0GDaLfw/plFuD+mAtLo1frMaP0+7C/FWVg7BEVGcut+eCMjbcUA0kJJvOqyr4M92Cv0BHDA+XFxlnV8g7fNxrzZfu8Sj5YVuF/+3/RXq1g0Bw4NWxtDS+5ZkOg0OMOrMfH2AtcukvjeBpMxt2DAqf6uAOfID8CwjaJ0ssLU8ZWDNMCbEVNwkaBomhJ+qotIQygmIJPh1sEkR8u0XXlmLcadrr/Grpjy2ih8e7k3ZXTkWcxF3TVXXRn0oq36+sY3dHKK/uUrnyau2pBFmPqoOIiFrERkkE9AhVd7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/30/26 12:07 AM, Christian Brauner wrote:
> With errors=remount-ro, the default, ocfs2_handle_error() sets SB_RDONLY
> without holding s_umount. If that happens while the filesystem is frozen
> through bdev_freeze() thaw_super() leaves the s_writers rwsems locked.
> Writers hang and so does umount because ocfs2_shutdown_local_alloc()
> needs sb_start_intwrite().
> 
> The soft read-only state doesn't stop modifications on its own. Every
> read-only mount sets it and those still need transactions for recovery,
> the local alloc and the truncate log. Everything else was stopped by the
> VFS because of SB_RDONLY. So call sb_set_emergency_ro() instead which
> keeps it that way, and keep setting SOFT_RO for the existing
> ocfs2_emergency_state() checks.
> 
> The xattr and ACL setters get a check of their own because ecryptfs
> calls them without write access on the lower mount. It sits in the xattr
> handlers and not in ocfs2_xattr_set() because chmod and setfacl store
> the ACL through it after the new mode was already committed.
> 
> Quotas aren't enabled at mount in the error state because that writes
> the quota files. ocfs2_sync_fs() doesn't flush anything anymore and a
> remount to read-only doesn't suspend quotas. Q_GETQUOTA, Q_GETNEXTQUOTA
> and Q_SYNC can still start transactions. I've left that alone.
> 
> Writes through file descriptors opened before the error fail with EROFS
> and umount completes instead of hanging.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

