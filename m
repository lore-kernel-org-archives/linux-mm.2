Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4756F606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gm28Ha6j
Received: by kanga.kvack.org (Postfix)
	id 6AC566B05B7; Sat, 14 Nov 2026 08:54:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65D386B05B8; Sat, 14 Nov 2026 08:54:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5741C6B05B9; Sat, 14 Nov 2026 08:54:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33F256B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:54:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B52F41603C3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:54:58 +0000 (UTC)
X-FDA: 85433870676.16.32DC1B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E1CD180007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:54:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gm28Ha6j;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794664497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6J+1H3vQpLdJ7UVpJ/tC85ye3HYuCATNIJGMbrXQJM=;
	b=w3X5mGwuiFTvnrUVI/YDF4QEI819nZ8DNQF2eu3esdoI5Q7OTal6Q/8YfzzB7rUJb6wwOi
	w71ikIuoIxep7hWMa5wVQUa4rhLLIJOxYd0zHGRR918p13h0VnPejqdlfmYTxbQjnudw7x
	GsRVvU5X+OSnUe/qtjlxTNPT/7aucV8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794664497;
	b=NKMFoD6AepKZVeh0ATLXeHjIdh0u8ChxB0vCuS+hhWShm0ecEkLU5SjtLqRCb3/wVtrOLo
	SvJXnso5BR+cizPlyAx6mxSwbr+SY69PAPcv56kLsuuWRUQAUqNd4c7xqXh/eyJx9sQVb4
	8Y+/NhAMlBrQ9ozxmXkTRLPxN7/mHsk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gm28Ha6j;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FB086020C;
	Sat, 14 Nov 2026 13:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8EC1F000C4;
	Sat, 14 Nov 2026 13:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794664496;
	bh=I6J+1H3vQpLdJ7UVpJ/tC85ye3HYuCATNIJGMbrXQJM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=gm28Ha6jFbZAVZELeCoAiv8yQmKhg2t27IzqaM5E6DHf1m/iHwaa05oOee2NvjSBl
	 kc6ZaW7X7pNIXQAoh9xnp9MBMni3b8MRxZdEx/eTPDoUQsu/YruOICy0eelWOEyqgn
	 3P8g8niOi/8NoL9V5UYuZAEp6DyvrAtH4YeuzU3fc3guDfP87KZmI3TI0lTfqozu4+
	 ZpGn4biS09ByqImLH4ZYYUNpv6w1MO+E82dAPetup0Rc/sR/ssg0FbIV+aiwW6MIcv
	 EBQr5L1AgJXIgzU68vHxaHLJx8/fkvXF+Z3xx/GTGkbG1HInFcXsLmVQOWzwu1EgJY
	 hMWqsgyXoIXvw==
Content-Type: multipart/mixed; boundary="===============4078380530865713043=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <bf4a6d1a8af90f3fac8754638a5f9b02fb40c0a066237181d456a25ac7f2c606@mail.kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-4-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-4-98639a2286fb@kernel.org>
Subject: Re: [PATCH RFC v2 04/42] fs: add SB_I_PSEUDO
From: bot+bpf-ci@kernel.org
To: brauner@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jannh@google.com,mason@kernel.org,josef@toxicpanda.com,hch@lst.de,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,linux-nvme@lists.infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,linux-scsi@vger.kernel.org,target-devel@vger.kernel.org,driver-core@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,apparmor@lists.ubuntu.com,linux-nfs@vger.kernel.org,netdev@vger.kernel.org,fuse-devel@lists.linux.dev,linux-efi@vger.kernel.org,xen-devel@lists.xenproject.org,ocfs2-devel@lists.linux.dev,linux-s390@vger.kernel.org,linuxppc-dev@lists.ozlabs.org,linux-usb@vger.kernel.org,amir73il@gmail.com,linux-erofs@lists.ozlabs.org,linux-kselftest@vger.kernel.org,brauner@kernel.org,alex@amutable.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat, 14 Nov 2026 13:54:52 +0000 (UTC)
X-Rspamd-Server: rspam06
X-Stat-Signature: 7p9h545c5grcdsjhjmd7a99zgo98zdpk
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1E1CD180007
X-Rspam-User: 
X-HE-Tag: 1794664496-453383
X-HE-Meta: U2FsdGVkX18mLr4IrNdjq8BwtmItQlmpK7GbQNeu4lsIN+NRH6XxE4Ls5vIQKmyMpyoclK/ffeXNXJ8RSUZl0VPgqp2x+qdatvzi6Zm8BPIZ3pxWC3jzAwcpqxghW/ULcUsWev5puNwTy7wTxBv1mwdvHc9+9/gP52NzNq6e1QJeSLx4au2HbDDkys5e/ziVjpvb+BJcNcZ5FFIeDlXWZvr1DjmU9brTCY0IJt3k60PMxOjrv6u7nqnj7tzsyDCLSrSAxRDSkETcDhyE236ykkqmAamIz1RqBcIgcTGSlMc0KIysHaoWuFuTth/0hBAnvzTFTMNASzrUGDDaFRyLpwITtVEQtFiSlFNCskPpcbQsahnAbdMF6UZKg0jmGR3U9QNbvtZrXev7KzY2kXP8h1U6GxS5CQQY5JWQotKPhizfxpbmeJ08JXQ438RwsavTKpuwy7mvAN66Kz1vUxGOHwnJuFerAg3m+0KHLINUU1jYYV2Z50N2pnSuNW1j3VRFvdhCecSU+jC2mqOo51VCEcNYkUTqsJ0TVj+PdiA7rjrSODe/GCyHnCSsuvYdB3JZ+sG+8D13lSptquB1lcbyhD0B25HfSvraQC6rcg7TnnN8kSonILa9xuVSO1zoostrSG5WAQR4kpuFNhHY5nF9y0P7h/IE4ADziZ9v0fs7dcbTLapsCtnD2jKt44Fvxa2VmyYWEur1A3Ly/esG5/jNWroPnEA7zX56t0VIjBZU2kPLuZ/rywjI7HJrxLNy1YXYxrCg2TNWQ3G0LbX7W8w9sVCMFx0JZieiOw5sh7paTzjhztsjKziI/Tzkp4cD90CfnUZSKWGsG1LHJ8fq09Jjxn+cWZY8mXFbPb67wJ9qhv33N8sKUjvZHJDWCJr5+Hgf0jUv3AevXUgysailnTXGUoFsU4SnQva2pklBHnZJwQ1L4WsPWQAopw+Eo/+bj2vMlhk0caZDCjDu7nE40O/
 E8ysZSa0
 PuazH68b89NKyr5stvPablC6BuZ7E6hQLhOo/Ge1CLHXvZNnv5D+5yQYNemULB62MgYIvLs9LXPtD5wfyCJErA4kuVLnc0caz8FXzdSEQ0c1NGoWo0+KlAh7Lh/FxmQO8cVEXuBOSFjRTKzy2J9Pwahmh9KkRm25NYExIaAE5EJCT/YBZiChxjOYneVjBxloH1kcRz3KKZ+d9e/VAsXOpTstjCBXpWcQC5H/oa/19KOYs8lbjT2jEXKA15vLt34uGX//ipfZGT1GRPLymPZ+tXeGFvcYKFZvmhdqVS1y9XAa9cIthvW7znGFxLIiuWynepWKPxoGnq1VzE6OC5QWfcNdPh+7BTl1CLwudlC+Lbyyz+a3QHreQh5QlZWV6nJTQ9oQm9aWDRIHTGWVI12m7kONMqMqAnEn5iif/0dZWiygdx1q5uMdsOQONdEd/327+q5ApNv2ZPwKmP1iJD4228mP0RuRXFJxykk0CBURUNvujs3cwq/MdfTPClQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============4078380530865713043==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fs: add SB_I_PSEUDO

TL;DR: Nit only: the fc_init_pseudo() comment and commit message claim pseudo
filesystems never hold device nodes, but devpts and binderfs do and must clear
SB_I_NODEV; the wording could mislead.

> diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
> --- a/include/linux/pseudo_fs.h
> +++ b/include/linux/pseudo_fs.h

[ ... ]

> +/*
> + * Common initialization for all pseudo filesystems, mountable or not. Their
> + * regular files are kernel interfaces. They don't store data and pseudo
> + * filesystems never hold executables or device nodes.
> + */
> +static inline void fc_init_pseudo(struct fs_context *fc)
> +{
> +	fc->s_iflags |= SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
> +}

This isn't a bug, but is it accurate that pseudo filesystems "never hold
executables or device nodes"?  The same wording is in the commit message.

devpts creates character device inodes in devpts_pty_new():

    init_special_inode(inode, S_IFCHR|opts->mode,
                       MKDEV(UNIX98_PTY_SLAVE_MAJOR, index));

and binderfs does the same with init_special_inode(inode, S_IFCHR | 0600,
...).  Both filesystems are converted to fc_init_pseudo() later in the
series, and both have to undo the flag in their fill_super callbacks:

    s->s_iflags &= ~SB_I_NODEV;

This works because sget_fc() ORs fc->s_iflags into sb->s_iflags before
fill_super runs.  A filesystem that has device nodes and relies on this
comment would not know it needs to clear SB_I_NODEV, and its device nodes
would fail to open with -EACCES from may_open_dev().

Could the comment say that SB_I_NODEV is the default and that pseudo
filesystems with device nodes must clear it in fill_super, or could "never
... device nodes" be dropped?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/43599461726
--===============4078380530865713043==--

