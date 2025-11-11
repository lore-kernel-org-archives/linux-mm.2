Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF4F2CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2A48E000C; Tue, 11 Nov 2025 04:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A9C8E0002; Tue, 11 Nov 2025 04:30:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9828E000C; Tue, 11 Nov 2025 04:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E01668E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:30:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 958E0C0414
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:30:35 +0000 (UTC)
X-FDA: 84097806030.30.0B800FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BDD401C0004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:30:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wel3RcIu;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762853433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3L2gHAiIh87Km6665M3lvvdrhNzA6zB+GULIQFa17Hk=;
	b=T6Txj8LqkQ/+KSnFGk6V6HVXcVT65Tt7njGLuHNJFO0m8HU8x3WkmYI/JgkKzSA1ENLgUK
	GEsDBljtbloQ+7iTnl+HYzwUd5fgaPk1NhtjU2Tg5Au5D7Xkm7BcKrSqiVdxcWL53isylX
	TnHwdFBZ2+Zi0IJrbAaGRGub7huUAic=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762853433; a=rsa-sha256;
	cv=none;
	b=Vpkh3uyxtaBygRu2wQNLzwbe+nf7yXmOyru/q5vFE2GE4Unk/MzCAlxIIabhxOP2cyxYSR
	NjAWPZYlE+VcJF640kVswe/TNVEtXnBvepyfB4R+GHQBpk9KWlHQ593xBgIoRlR3UJD5dK
	D9+fZqETgSHckeGilw18uNe9iywn8cg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wel3RcIu;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B496404C0;
	Tue, 11 Nov 2025 09:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B728C19421;
	Tue, 11 Nov 2025 09:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762853432;
	bh=FABYtlEqY2mS5o9frfhx1zgALjceFTO/BSa/J+igp2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wel3RcIuS5j+o/v6AaFglHplRlVo9sjzdy86FsNvkTS5k7A/kuydEY9YQDtDQNrkU
	 1JCCFOApt8LXWbOxCeqS0vlhGpfcI0c8jf2RAsKomtysjY/RFbLTstpdKXu40yGTYn
	 FLxjdS45rZweVEmhZDxCWOTnPuYWbymg3w5CfiOvkb1Zp/DixWYVSWmBkR6D86LVRS
	 90pZQhDvDQUp5C//Nl5fU0nZLj6njdPQoX9etWjUUWT7zS1p8r3mKbTo7WJJiVw2Eh
	 1ZXIc9VtvUtautgBEOReKPpMqPkOF85M+AtRNgbRjY4ZeYjO80kCfOZdnWtEAjEE0Q
	 TQ0u/1s2TNihQ==
Date: Tue, 11 Nov 2025 10:30:22 +0100
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, borntraeger@linux.ibm.com, 
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, 
	martin.lau@kernel.org, eddyz87@gmail.com, yonghong.song@linux.dev, clm@meta.com, 
	ihor.solodrai@linux.dev
Subject: Re: [PATCH v3 36/50] functionfs: switch to simple_remove_by_name()
Message-ID: <20251111-verelendung-unpolitisch-1bdcd153611e@brauner>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251111092244.GS2441659@ZenIV>
X-Stat-Signature: fibdiqd5dz6oqh1r5zgoob98r4zaba3b
X-Rspam-User: 
X-Rspamd-Queue-Id: BDD401C0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1762853433-911264
X-HE-Meta: U2FsdGVkX1+nRMkOAWg8mEClNfd2njucLWjteNd2dMlWyrXby8BALW5QNuI3yQuLmZFUHNNAyWayfoy0k23AWPt5gTCpoUHwo6VgFUxN4NkUoh62VrijHT5rXicIW4VkPMyAfMrOF2f2RFuGl9RSOzONaSdTy86AIB34wFtywbIihhiCKHw3nxOYq556Gxy7PcX6Sb7uDNbjqWK6zFGJK8RuySLrXgyJVz06suvns4SbJ6cwoNf3UQVZzd8s7E3hl3f0cr26G8rXg0lqgDvN40lT+t1jaBlWsdHGBPJkk9oM8S/pFGgxtEvt3ACht2pZTINC4+7hDnvvgfmoYHJwLpFAgLC6rLFkFZf7aY6GYyKVZL7h6f3j7Fe29rhbWlTsSOqvt5S3dQMd20wuQul+VtOgyOvHJndixFVujraxYwP/z4j7ZBGe9cwlnyycVi3KlZyhJlRax9IXVnjOckYPGtr5ztRoxnxyl/9I0Zcg1q0B+2RS4g547cm2KLJprFjN5PijIstq8jVbG4qkvTdKKy88PeOB59xNfyNTWUAZOutcSNj1kZWOHSeHWbbWCSTsyVMJCWNAuyZiEL1vYSWA8CvLNbsj1WwnWaUA/HHEqF6MvY/iFna9EiDCTle9lpI9qf90LAljI4P7PB8odwB8fQzpW4TtUYTOqTTjoU6nB1+TfRlrTmjE8O5vZtbsEeWaXs1oLxgxCTPEHMdEM6oAkZ9X0tLDEd3jGQjfZ5Pt4h34m9Qo7BepuhU7JMDvM85SAGXoZhSszBLG7H2p49idrUPYENkfBXOcpB5MAUJ2DjFhiCrFcx/9E99p80L3HhsgXx+9u2CLCGLlkafai2qsqgt1Mj8YcRs2Ik/VnPwRYk3Z6f/8Czsg6Q03iLeNAUuNpA4Nw8Fhf9wHK0l1MVLDNk2Epto0fEJ9R5naqHzQ0n0zkufs0jRsLawORiNG1YGdQ2Q94oluBnGCzk9/L70
 YUZ0YBjp
 Ey4kR2ITNma22v8bwQ6DJT7Y2jzqeRt8MV5rhmUeIAvWysu83sNCjyAVN+4zDeSeA1uLaUtJOoWyW7Pr63S5CLAHSWBMsSoNMcsaQcjYSQg91g+CiaHUorcUK03asbh4JQJ21uj8us53zDCrG+Q35h/uT6IOHr3OSoacE5QVx2rEysTqlEcjm1Iw2M7MLdpiLbpaVSudFQPffRWd/Z3G3Mg7ckszv5+IadFGN22nRphovAmfRWzHuinoSPafcqCGLq6IVLvjkGHvi4lXaRcW+NkfH3ubh6G6Vj1Vrn/+95elg8zKmhU4rvPnzRtBeG/AYWW7uUYXaGZYkD0wR2gIr+YHNymS1O5zBETU1mFxv2sfolvo0JVVi496HLSDMiGbU/Mvuxrq/PZiUk7Xemvv+s8FR8luvaG3Y+ocisuztbmg59JJYj7y0+Ae7jLZwM4m4Wp+Yl+ZyJy62/B4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 09:22:44AM +0000, Al Viro wrote:
> On Tue, Nov 11, 2025 at 07:53:16AM +0000, bot+bpf-ci@kernel.org wrote:
> 
> > When ffs_epfiles_create() calls ffs_epfiles_destroy(epfiles, i - 1) after
> > the first ffs_sb_create_file() call fails (when i=1), it passes count=0.
> > The initialization loop starts at i=1, so epfiles[0].ffs is never
> > initialized.
> 
> Incorrect.  The loop in question is

Are you aware that you're replying to a bot-generated email?

> 
> 	epfile = epfiles;
> 	for (i = 1; i <= count; ++i, ++epfile) {
> 		epfile->ffs = ffs;
> 		mutex_init(&epfile->mutex);
> 		mutex_init(&epfile->dmabufs_mutex);
> 		INIT_LIST_HEAD(&epfile->dmabufs);
> 		if (ffs->user_flags & FUNCTIONFS_VIRTUAL_ADDR)
> 			sprintf(epfile->name, "ep%02x", ffs->eps_addrmap[i]);
> 		else   
> 			sprintf(epfile->name, "ep%u", i);
> 		err = ffs_sb_create_file(ffs->sb, epfile->name,
> 					 epfile, &ffs_epfile_operations);
> 		if (err) {
> 			ffs_epfiles_destroy(epfiles, i - 1);
> 			return err;
> 		}
> 	}
> 
> and invariant maintained through the loop is epfile == epfiles + (i - 1).
> We start with i == 1 and epfile == epfiles, modify neither variable in
> the loop body and increment both i and epfile by the same amount in
> the step.
> 
> In other words, on the first pass through the loop we access epfiles[0],
> not epfiles[1].  Granted, the loop could've been more idiomatic, but
> it is actually correct.

