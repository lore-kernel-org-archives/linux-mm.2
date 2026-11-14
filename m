Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405D2606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bfkXAKnv
Received: by kanga.kvack.org (Postfix)
	id 6ACCE6B05B8; Sat, 14 Nov 2026 08:55:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E436B05B9; Sat, 14 Nov 2026 08:55:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B526B05BA; Sat, 14 Nov 2026 08:55:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3653B6B05B8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:55:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD8341C3AD6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:55:03 +0000 (UTC)
X-FDA: 85433870886.10.46C849C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1A1E220006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:55:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfkXAKnv;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794664502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xi+Jp34UVw8n6rWUcn3QcZPlSKYiPMqX7yCNJrzL8oU=;
	b=KXCZ4iHgVQaUoKfS5yCRBDWy9NDV8g7gsofhlmgqRBlLkXHCJLHVCBevlVkV/q/u9Hcr8J
	pKWqnyHd8D6dNOBXFBYdTzYw1t0KgHOJQWpYPTZN36BWtdQPkBSO/qaE8TgydwmxKFG9o7
	MLlm1Pd7bN85JjY668Q4Q/kNLWG7+Pc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794664502;
	b=gnD5RfYJyFzcmtxU5w1CvTNtPtMGtnEvwWMkQFDePrPI+Q1TZ3VrLxOk6hP+TMfNOOsg0F
	bQ2PHMTC+M6EwwQcLInpbiPuiMuCce8K2NUqxc8mmOjwB3rPCdegmm6c037x48UGSOWsp+
	NVkhErP1h5xAihc5Y6oTTdf2tRNZk84=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfkXAKnv;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EE0E448C9;
	Sat, 14 Nov 2026 13:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36F01F000C6;
	Sat, 14 Nov 2026 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794664501;
	bh=Xi+Jp34UVw8n6rWUcn3QcZPlSKYiPMqX7yCNJrzL8oU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=bfkXAKnvyN3NrzfYhrVigeGIKvr/8evEe0tQ8KwSyEafhDf3+AXVoqojleCZ7/Qdh
	 2b013ZilynaxVntPTxgtS9Fyq3b+7yXhPeXkFfQ9ONM2J9MEOM/JQ3B/znTjkCUpqc
	 r0tlhXctgE98kfAt1ITbmi9H0tApXPCL2XTcrVOM5qnz/NrX0rxwji+SmXMUOe8YHy
	 kRbhgqC/kLnhpgS61Qu7Lfu7BuXDWJsHjF+zOY5u5KKN5rR5uvcX/zOV7QTiz8dq9Z
	 GTd5PKapaf6tpFoOvo6qdgngRWS5W1FIZVvnJWAJ8F5DAYQTkJUN/Wbu5kFv6IHajV
	 XPu1vrQEYpCgg==
Content-Type: multipart/mixed; boundary="===============1687560790659556623=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <df03e637354be695652a787563af21ac77b4c61f813ae4491a3397a91df7688e@mail.kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,alex@amutable.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 13:54:57 +0000 (UTC)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A1E220006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ugra7o5hi5jwsgsxgmgajbjeo57xwqmo
X-Rspam-User: 
X-HE-Tag: 1794664501-562192
X-HE-Meta: U2FsdGVkX18tsfd0VRMYQjKXVBLFYJmwjsvnppl8nvYt1uexTbfWPpoDRsGqdx5iZFWzkbagqqp8WK/KPiwEAAOeH/qWVXIkjmrR4qYBWMI4i1fxLlFoNAISfmOMFZCUpsmVm7DqWthgd5xGm/qMVTS16rENEREgMBRKxK8CWkmcwhqMNZZ+29l951r/vtteZimtR93xP6T27fYM2QbLuX+RYmBhQ2k43FmMKxJYxqOzmww9RL2nvbTP6GVUJkNGA8VjfjFSH5s9Bo8dJXhzLDS6Uy2sxHoFKbMKJN7O+WVhd7afdGq0ROWnkVzgOyI4mbjOO0ed8+xn8jrXzdcoKfVXs0m7PEegnlYqzEMOwr0r5MuYgpgCqT51rZNt/tq6pjk26Cp1i2C4Gym3spmmrM+6Rlk1n/Oy5J0a8cSvIEwGRBiX8Tsec4jzv7OZncXtmBsn3x70rLgBeU2ULkAwE72Vu9vQ2E2FUFtGR4YZs2S7uqOKdn7O3DGrWpXlb8HC5TVPWrV0gjZGxpFyFsJ3stKDR1IWhA0nK/Ui/LolWVVeDRYRE2mec1JGG70kYFX+T+GEwlgsA/CD5gJM7O3gaKyucE/fh73W3C1YGzKtRiIsp5O7TMWFquK+aeSJXbAAAUj1iTXdYRcCjN6x50BF6GQEpiTbm0A4rwv/O3rWkt64BJfHNUyyB4AR5nIjwhfHW8k4P8zr6+rjzGTXWex8q22ty9jX7Dkrw/UaUZmoHeQJB26IOSd39mdI3MH7H0TVISrBNI5OC7zmjN2pQT0K9DPu/oQCvSC7F4t6g1BZGSc0hpDRftd6EiunPMc3EH3RHCW2EKJBsZXx15WJ2uBB4rw/lP+h7qVhqJqoZuvgo58wEzEHJCRMGHhSifnBkvl35pSJUFa+ROh9BE9Sb+wW1tZ+yXq/TJJ+nyOoVGSKHpyBh4W9xMJt7vQ3BBY+I/jDCCWlUJAQQ/T+60TppGC
 PfOpknF6
 P+aJmcrBeu73cc8+3bKTjb9e22r/C8BGrU+CfGwfXrFv3/XZWDQhuSfZBhJrPRrFkQ96k+GTS4fL3o309TJ7OcKeIIZwqTMXPF/A+/HCnkQuUj/Eld/1qx+WJXaGi5643TS/vKh4gknds0QmycLnJ/NeAM0pJwEfMRYa9EX9jg8X3i+N/ztAw9hn7vepVOZKA9raAyIpHSWbUMSeSLHOaHGaBdMqkqyvKRehMswNeLdEcWS0wsK5fQA7uqYXkeQ8cRuhLnUG5Z0m/dYQWgA1j4MwWypDHwZvLUedPeEWUHBL+2Fhp/24cYfrFFSFi9Oep9GCUmJAaxokbcbbPgBx2f3puiduuCkF3KG04ROexA0SpmJrQzz5o2AWA0uyAfvr0SOIn17MJO1kcas8vYC7nrYNk1PUD77ljnypj1ihb2mwXil72Cr4PImDODzC7UHoYRsbevnSZQnr/HUW/3WPrXly8wKSG9RokcRDbWlmxUu17fucW72MsVRQ/hQZh0uWwJcJA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============1687560790659556623==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> securityfs: use fc_init_pseudo()

TL;DR: Setting SB_I_NODEV on securityfs may make reopening AppArmor's
inherited .null fd (e.g. open("/dev/stderr")) fail with -EACCES, which used to
work; the commit message may also be inaccurate about device nodes.

> diff --git a/security/inode.c b/security/inode.c
> --- a/security/inode.c
> +++ b/security/inode.c

[ ... ]

> @@ -64,6 +65,7 @@ static const struct fs_context_operations securityfs_context_ops = {
>
>  static int securityfs_init_fs_context(struct fs_context *fc)
>  {
> +	fc_init_pseudo(fc);
>  	fc->ops = &securityfs_context_ops;
>  	return 0;
>  }

The commit message says "AppArmor puts a .null device node into securityfs
but only ever opens it via dentry_open() which doesn't care about
SB_I_NODEV."  Is that the whole picture?

aa_inherit_files() installs that dentry_open()ed file into the task's fd
table:

    devnull = dentry_open(&aa_null, O_RDWR, cred);
    ...
    replace_fd(n - 1, devnull, 0);

The fd is not O_CLOEXEC, and its f_path.mnt is the internal mount from
simple_pin_fs() in aa_mk_null_file(), which never has MNT_NODEV.

Opening /proc/<pid>/fd/N, or /dev/stdout or /dev/stderr, resolves to that
same path and goes through the normal open path:

    do_open() -> may_open()
        case S_IFCHR:
            if (!may_open_dev(path))
                return -EACCES;

may_open_dev() checks path->mnt->mnt_sb->s_iflags & SB_I_NODEV.  That bit
was clear on the securityfs superblock before this patch and is set now.

Can this make open("/dev/stderr") fail with -EACCES for an unconfined task
that inherited the .null fd, for example a helper exec'd through a ux/Ux
transition from a confined task?  That open used to succeed.

Should the commit message say that this reopen path is intended to fail, or
does .null need separate handling?  The statement that "securityfs never
holds ... device nodes" also seems to conflict with the .null node described
in the next paragraph.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43599461726
--===============1687560790659556623==--

