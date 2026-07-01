Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7FDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 02:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92FA26B00A6; Tue, 30 Jun 2026 22:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1236B00A8; Tue, 30 Jun 2026 22:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CFBE6B00A9; Tue, 30 Jun 2026 22:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEC26B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:32:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF435C08F9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:32:46 +0000 (UTC)
X-FDA: 84938634732.18.4BA4A49
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 452D11C0003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:32:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=hQPC1aQP;
	spf=pass (imf21.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782873165;
	b=JzNr6Q2B/BipLd/36vIA3xEE92mdIG5ejOzCo5HopQhOZW4PcFs9+xqOr/i4gw2/YjSFqe
	+DHfbcoVv2KyePE3rk2nckxt8bwpvzDcUqDtXPGLdBpq091Z6jVfqclyPrjO6v2tMiW57r
	cdwGr1mc4l+aqbkDT7S/4Hj51zMpnh0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782873165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQN1IUhhTEXUFB92w3rc4mmoU0B96GEth86y033SCFo=;
	b=tS31pMM4s6LqmHan8SMiPVlQVOqfVE4s1zdW5pUJKTmH15bO0pA3sUU6pSJ+OpYFXkK46y
	u34FM8fHi3DxRNs56UUTb70PtcRElDJR2fV6arxyYNPiz10fIraW2wLS7bidpKjRhoFGSm
	T+E+zQfx0+pufX6miZpiLxMveUieJfo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=hQPC1aQP;
	spf=pass (imf21.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=mQ
	N1IUhhTEXUFB92w3rc4mmoU0B96GEth86y033SCFo=; b=hQPC1aQP7GXuOIIGgW
	6tB9hTq7bS3wbNyYvHbTWFOcdcCqWTZNGAhzmd35x2rTQhbq5GP0VR+OMt6Jh3Q2
	0XLsLRuuncqYMfAF19cM4uiLqQbb/CaTRfq7dXXLXQ4ZP/xBrQedICUyMXhtIYQV
	bqpoIPoJHmFtqnPMGS6DhDFu4=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCX3EcXfERqS6ElGw--.58356S2;
	Wed, 01 Jul 2026 10:31:52 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: brauner@kernel.org
Cc: akpm@linux-foundation.org,
	alex.aring@gmail.com,
	allen.lkml@gmail.com,
	arnd@arndb.de,
	chuck.lever@oracle.com,
	corbet@lwn.net,
	david@kernel.org,
	ebiederm@xmission.com,
	j.granados@samsung.com,
	jack@suse.cz,
	jackzxcui1989@163.com,
	jlayton@kernel.org,
	juri.lelli@redhat.com,
	keescook@chromium.org,
	kuba@kernel.org,
	liam@infradead.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mcgrof@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	mjguzik@gmail.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rppt@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@kernel.org,
	vincent.guittot@linaro.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v5] coredump: Add bit 9 of coredump_filter for pre-exit files before dumping
Date: Wed,  1 Jul 2026 10:31:51 +0800
Message-Id: <20260701023151.694758-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260630-alzheimer-mahlzeit-mutlos-4641a5947a04@brauner>
References: <20260630-alzheimer-mahlzeit-mutlos-4641a5947a04@brauner>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCX3EcXfERqS6ElGw--.58356S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFWrAFyfAw1ftw4UXFWxtFb_yoWrAw1kpF
	WrKay0kF4kG3yxt34xAw45XF1rCw1ftrs8Zr1Fgwn5A398A34Svr1xtFy5Zas8Crs2yw4j
	qw12va47C34qyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUouWQUUUUU=
X-Originating-IP: [124.77.128.91]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbCvxnQ2mpEfBkuNgAA3-
X-Rspamd-Queue-Id: 452D11C0003
X-Stat-Signature: yf6m5xpk7h583kqcez3kg7tm6ny4u8ej
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782873162-97550
X-HE-Meta: U2FsdGVkX19Z92sxy+PN7A+b8MaCmQkdCUZWT85GOP4agENJKeh12frnoiaOGNGgBpHvD1x4bxlYjh/LQzbW9tEbfHYl6KDqVwfHDKJ30DngNR6gOHSP0QoOvEtFF2dokgqr0k1Cr/YNF+I83ygFojLaupmEyEAmTFziLI801XUp4rZ8IaB4FTbepsBRgJRM8yArG/M6Cpq27MmSvHBgIrtW2NtDJeRrjr4hgSLVuOMMxF0mzw20FgnLiGgxJPvz6s0ppmjXykOMaXBCTzOFWYrkyMtLybxisvZDSYwnphJLq6o+3I+b02zxfp7pJo6xGVQXvcuMnrPfp2XZDTpn2CFy2eqSPtYVvdNkWNjaMMhIEtm8tkG+b9H0o9Nfkm9Mf5aGkCCKVx7OCYZ7wDVM1QyThbsV4Q9jTlYTna/dzDxrEx3qcrkSG1Sd5u8IDHXL84YnY3spoCBeBxI16RTbw/DIczRnyejJIiN5cXZ5EOtZSZxmdEl6HE5uYX5H95CxAK8N4ZxC4TmXtDOH1axLrsA/Qrwc16ma++S1uZSl9YOzws8VEhqz8IvdhNQm7KE3R1PWdCTe4+cMtW0gTY8uiu69ohC0h8KHrpS9myd3ZgHdlHHQFIu3GxmBMQyeJ0ITWspHUlirPk5eN/SurPCo91eyJMQdcKKS1Q1JMZVcLz616wCzp9Wj6bEVVAlUqQLZQQGL683GULAe+dknRrprp0rRpoaYXOG9YB1tabrA8QZ3PGr+xqluS4bry2ZxqtWu9wnsfKhC3iX8c0M5L3datYLvLY6idR63zsAPKv6PMZbIWSoEv55oNPCIGArAEdmVBSivvV/D824NBrqhJNNLQq7JZCZPI1syODDHQbq2BQ2h6xAkUXmOb+EIu/h5FNJs5W4up01chxcP2FegUHjYn2/NI46x/bH+mfnI3Fii8aaBL/gIc4Qxd6ZP56E94ZQs1yyVMmwKPNKaUSWyuKU
 sel33u1x
 CTU0UZApvkvaxrWAq6qehuGsSmD2GBcgp5jTZkx6QhF/Fe9oZpOD/CnE6d/rnBTrStiNDX0t1cpN9qFVyS9cvqXidzTTOwgFj5IIjJJNdGzmVtp69NepW6aeeqF8RUNbd2p8PK0Se0j3OhmibL/fZDcNmWN++jiCOC5lzDWQnIMH8qPXnuOXwXCSBDo8R/2kzAxim5cskGk+LN0wohnee+rdhvTszM3V78vi8TyR1maj4RPDLlwv2CKS5atLhfOibw7eHQUMAaM3ZtTzXGwUMhZRbAmJWeyiF2Wo+5PGnYC8m/1fOmFFC3L7guYpxVITCIaw/oaUd84n6dfLqwrh8FLk8B5ZaSHZBHj0sTRg+eVLKKS0v4l7/gZwYZy1Ou5F5eMCQa20D4gOn49g9IMCUKDZsuj1N4HurJJXH5ztCew6ZrQLTJZimgUOQxJZ7MIefJ2stAPbMuk2HDGsJr0AWtgy08mc1tXa/LFBbNQbvrILQ7bNSkGxnyIhdgA2//c02B9Gi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 13:50:15 +0200 Christian Brauner <brauner@kernel.org> wrote:

> > + * If do not dump fd list, files that are not referenced by any VMA
> > + * can be released before dumping core. Therefore, some file release
> > + * logic, such as exiting flock or releasing references to shared
> > + * buffers is executed much earlier. Note that do_coredump() often
> > + * takes several seconds or even longer to execute.
> > + */
> > +static void coredump_pre_exit(void)
> > +{
> > +	struct task_struct *tsk = current, *t;
> > +
> > +	if (mm_flags_test(MMF_DUMP_FD_LIST, tsk->mm))
> > +		return;
> 
> Why does this hanging off of mm?

Like other bits of coredump_filter, it is actually attached to the mm flags.

> Even if we wanted to do this it is fundamentally the wrong primitive for
> this. I would envision that anything that wanted to "zap" file
> descriptors synchronously would either have to do it synchronously or
> offload it to a delayed coredump list and wait for it to have drained.
> 
> I dislike both options... Without thorough anaylsis I'm not even sure if

Are you saying that the file release operation must be performed in the
context of each task_struct? I'm not quite clear on the necessity of doing
this. The execution of exit_files merely reduces the reference count of
the file_struct for the thread, rather than decreasing the reference count
of each individual file.

> taking out files out of order with other exit-related cleanup will not
> end up causing fun bugs. Meaning:
> 
> [...]
> exit_sem(tsk);
> exit_shm(tsk);
> exit_files(tsk);
> 
> anything before that might implicitly relying on files struct being
> sane or some other subtle interactions. My appetite to dig into this
> just to make this questionable patch mergeable isn't very high...

The essence of file descriptors (fd) is to allow processes to reference
specific files through an index. The fundamental purpose of exit_files()
is that when a process exits, it no longer needs to reference files by
their indices. From this perspective, I don't see it causing any issues,
because even if functions like exit_sem and exit_shm need to use file
instances, they won't use the fd index; instead, they will increase the
reference count of the file as needed in the prior logic. By the time the
core dump begins execution, user-space logic will no longer be running.
Therefore, as long as the contents of the core dump do not require the
mapping relationship between fd and file, the file can be safely put.


> > -	if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> > +	/*
> > +	 * coredump_pre_exit() may release files before dumping core.
> > +	 * Cannot use task_work in the case, needs to release files
> > +	 * earlier."
> 
> And it does that by offloading the closing of files to a kthread that
> runs asynchronously?

yes


> Also, as was pointed out in other parts of the thread: files are shared
> _across_ thread-groups not just within thread-groups. Anything that does
> SCM_RIGHTS or has done some pidfd_getfd() dance - however unlikely -
> might still hold that file alive and you have zero chances of getting it
> out of its hands.
> 
> If this is so critical, just skip the coredump via COREDUMP_REJECT or
> similar means.

> > +	 */
> > +	if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD | PF_DUMPCORE))) {
> 
> This:
> 
> (task->flags & PF_KTHREAD | PF_DUMPCORE)
> 
> will have interesting side-effects for everyone else...

As you mentioned, other processes may potentially reference these files
across processes, so even if a core dump is not triggered, the file
release actions are not entirely executed within task_work. Because after
a process exits, other processes may still hold references to the file,
the work for releasing the file cannot be added to task_work at that
point. In this case, it still uses schedule_delayed_work().

If kernel developers do not correctly implement the file release
operation, such as relying on certain information from the task context to
free related resources, then the issues arising from such unreasonable
release operations will manifest in other scenarios, regardless of my
changes. My modifications only amplify this problem in the context of core
dumps.


Thanks
Xin Zhao


