Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AA2F606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lC1rRmz7
Received: by kanga.kvack.org (Postfix)
	id 303966B05BB; Sat, 14 Nov 2026 08:55:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DAAB6B05BC; Sat, 14 Nov 2026 08:55:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9C66B05BD; Sat, 14 Nov 2026 08:55:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBFEE6B05BB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:55:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78B111403DE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:55:08 +0000 (UTC)
X-FDA: 85433871096.02.829F687
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3CFB1A0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:55:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lC1rRmz7;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794664507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZCOg3PYW5/XzYktPPO7fZbRJ9jC/nh9/3WC5LHdP9k=;
	b=de6hMLrx2Z9gDJKrla6n5mT6Zs6YnrpZKoGL7yqfd1SNBH6httLFo4/Xtea9MTHVBI24lr
	98v6HWgFVHBq5e7qkCGmlE4Nj887f4P5RBzRxlPxd4HTh9wXFQSLP0TfVTzrmofRh2TDTm
	2L1B4RXm6pz/i55/B0MIe77Qr7d0uZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794664507;
	b=kAwLp9ylVmvPp08B+DnyotOuWONNzyg9F5d9P9ZHRBgB5gaqupi2u/wZUux6RaD/0BifEY
	6DD0OXTqva37nXGSmMno0i052KMH6/SIXrzIKY85ADk7oW4IAqtTBNmgElyct8rD3n2oPd
	MGRLC3Z0ChOg8gU5p64VgcTBx5vBUP0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lC1rRmz7;
	spf=pass (imf19.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B2EF45800;
	Sat, 14 Nov 2026 13:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73891F000C5;
	Sat, 14 Nov 2026 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794664506;
	bh=gZCOg3PYW5/XzYktPPO7fZbRJ9jC/nh9/3WC5LHdP9k=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=lC1rRmz7ahj/srEYA2ijCYwgAqxvBpBEiZzJTz1BT/wrTEWhRCAJRjIQUg90ualPp
	 8fNiGIog6yGBq7jcPWwPg3KTZ4hhP7wzOgQinag8fVT+8JrN/YD10tUBIHBk4t50YO
	 lVbRqj+kObH/VFAULApyIEa7KJo13ikHhn4sjSYyAVLzN15VB21GTINJSJZ5zSjoJ2
	 SqbEpuE67Y8c73FjyTC9QAtGI69lnMt18W/xx4/7c8YFqB+lo9IQTij1vjYC2G1yJC
	 gbXcz8wGq7FFvOpMP/hQpyy359bbb1860T3yz8/mr3WEBUyRt+SVvwAJEu6hB8hDoE
	 Jru9mkTF+Jtaw==
Content-Type: multipart/mixed; boundary="===============0802335019258284520=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <91e245da9f3df6d6e61808e72a4ad0213a9a6b838f594d0be74dd70ab228422f@mail.kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 13:55:02 +0000 (UTC)
X-Rspamd-Server: rspam06
X-Stat-Signature: xtzp6k6irjxyxmqw3c4hryzn1ckt4aa9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E3CFB1A0002
X-Rspam-User: 
X-HE-Tag: 1794664506-347011
X-HE-Meta: U2FsdGVkX1+VOFZfamPKvoDYrCCkSINp1tXY9RYq75IU5PpzgIz1n6jLRyr6Azw5J0obvy6dkolo9TUqIk+YgPzXEhKAEwPsG5vy++AZ0yXFMEJi69x6mg64LbZwQe9EGHhiYnc5bwb145mELbjT7XVHXUjuW0nqzCF8dG+xwy8aZ75i+mFsSHSKugHVZ3kGfRdbGUGd7e/M3DYmpS1HPJ8TX9KwIqJXNlpfZoHzFB80iK0sZsyTFT+gOHsVQ8vUNUU8PF4ZSouRLVQ+xqmJYulYGMuhMG3y4xwxyDOyFHso5SfUauVr13sxrpwzpeTFzudZk726Ic7O+vMFgU7cyOM+BkRsRmg/ubF7G/PuyGujiJm2JxTLLZYu7xkX/kgdKJU8yVjyfUfkpBIdrd+2tMZ0yoyi62iPlofl3w/ZYb/PxG23vhUhJs/QteUW8hSNpvfyPvMNUIU80oeJxllLxN2fGWeT8TGZskpS806q4nHlX7rTC1/VsyF3H/qNAlRa4cAi7lDOWWKk5yG8vHtWIgQkmueQkpqDEA3+YJXHv2aQXuIh4RykJAkCb28g9AdniBKuSfYVtfAl7cs5jauinaQl74uldPqycVukhqYprVt8/e06jjYN8LVSnrsqv6fs3QX/mne1SVkNLWj73DW/QTuoMMQHRVTi90cRa1+VePuwlFRQ9+kd+O8wsnu4BUhxYUB+SkvYWdBi5pkzQYMYYcdpasrbtw/uOy6rABo0UV9sQD+1+NpgGCQjFwz8ZbnU5fzdC1iCvxo/dgEWBZt7fNMPGtieS8DYQ8NdGBHwI2rX0s0/lxiwfZBVsXcZ1XJAc+fK2cCJJCEEzUf9L7v/6T0qS98A+2YN94lmsU2HzCrFF7i/XxIpHpEl5o0QcfJuIzpEE+TTurYRHtStf210CbfFGjQR5LwFCeSeMwDGbpHZM/biyBC6N2u3OFutB+rdj4UcA32MzUgKmpRjsfq
 HHHtgTfY
 X5CLwTQtbi+XgkT7e938FiPe03povjpMQZbNJxPOfLOuk18VIQXeSS5YOXNYroTOYFT0n55P3hFpuzusuy7BDX3SVIBm0rLFdFWuJpvsQ8Zz5TJf91WeIT/9ScuJ9pm+B8M/7GRZ3z34terHWoij0TV6qloj216CRDchBUhSIMX2srLEM/bGkz5dpyKlMXCojibM4f5fggdQzx+Riix1iuKV2ghUGqZbXqt5Svt/UklT7F/HPjzGWwx1OWU8+GPclxkxZEA19bjEG9BfwcGOh2QFBZ7go29qpVFB5YLJYjnChXmAWGqTRcdsE78nlk+UxDefYWg+rozvYRwveF0T6XNDcdb8+oXZfm1pRjh0KiZt025uIFxrtrDNwWoVjDrYMXGlsHQIq1h+cCjTUPT94LminrGgVPom7fvDM8q1E4BGPJkOr3GZMygOWeCrxSA1TeLFnioYaum5gakFMadBRgNvf0urvqh4hj6kqjdzP7xoG9IO+nk5eAaLFNxFjdmyuiKZK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============0802335019258284520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fs: add file_check_backing()

TL;DR: file_check_backing() may call d_real_inode() on O_PATH overlayfs files,
which could hit WARN in ovl_d_real() (panic with panic_on_warn) and let the
pseudo-fs check pass wrongly; reachable via fuse backing open, needs
CAP_SYS_ADMIN.

> diff --git a/fs/read_write.c b/fs/read_write.c
> --- a/fs/read_write.c
> +++ b/fs/read_write.c

[ ... ]

> +int file_check_backing(const struct file *file, fmode_t mode, umode_t type)
> +{

[ ... ]

> +	/* Look through stacking filesystems at the inode with the data. */
> +	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
> +		return -EINVAL;

With FMODE_PATH accepted, can d_real_inode() be reached for an O_PATH file
here?  No ->open() has run on such a file.

For an overlayfs metacopy file whose data is in a data-only lower layer,
the lowerdata redirect is only resolved lazily, by ovl_open() via
ovl_verify_lowerdata() or by ovl_d_real().  For an O_PATH file this means
d_real_inode() goes into ovl_d_real(), which does the lookup and verity
check itself:

    err = ovl_verify_lowerdata(dentry);
    if (err)
        goto bug;
    ...
bug:
    WARN(1, "%s(%pd4, %d): real dentry not found\n", __func__, dentry, type);
    return dentry;

ovl_maybe_lookup_lowerdata() treats a failed lookup as a normal runtime
event (pr_warn_ratelimited("lazy lowerdata lookup failed ...")).  It can
also return -EINTR from ovl_inode_lock_interruptible(), and
ovl_maybe_validate_verity() returns -EIO for a missing or wrong digest with
verity=require.  Each of these would hit WARN(1) when reached through this
helper, which panics with panic_on_warn.

In that case ovl_d_real() returns the overlayfs dentry, so the SB_I_PSEUDO
test looks at the overlayfs superblock and passes.  Does the check fail
open there?

Nothing calls the helper in this commit, but later in the series
f79b9e79484f ("fuse: refuse files on pseudo filesystems as passthrough
backing files") adds file_check_backing(file, FMODE_PATH, 0) to
fuse_backing_open_file().  That gets its fd via CLASS(fd_raw), which
accepts O_PATH:

FUSE_DEV_IOC_BACKING_OPEN
  fuse_backing_new()
    fuse_backing_open_file()
      file_check_backing()
        d_real_inode()
          ovl_d_real()
            ovl_verify_lowerdata() fails -> WARN

This needs CAP_SYS_ADMIN and an overlayfs with data-only layers where the
data file is missing, the digest check fails, or the inode lock is
contended while a signal is pending.  No fix for this was found later in
the series.

Could the pseudo filesystem check avoid forcing the lazy lowerdata lookup
on O_PATH files, or should ovl_d_real() stop warning on lookup failures now
that it has callers besides trace_uprobe?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43599461726
--===============0802335019258284520==--

