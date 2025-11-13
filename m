Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83462CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 09:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B748E0006; Thu, 13 Nov 2025 04:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C1C8E0003; Thu, 13 Nov 2025 04:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 961F28E0006; Thu, 13 Nov 2025 04:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2248E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:26:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 330A71394B7
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:26:49 +0000 (UTC)
X-FDA: 84105054138.02.A0769F8
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 460A740015
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:26:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=BZWkX6ff;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763026007;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDUxCZ9a1FBEg+ndXr53elrDsetDAHrRuckIwq+rkq0=;
	b=PEThW8B2GVcTlbuqkqXYHKyo8x+8BOmpfNMpBelnGm9+KoNT1THVDULvJA5h79DptOmnE9
	AdCLb8Sv62KVZxrQlHdmzH8KJXzndC0rWal23P4hsfYBTDH9/RIePdszqlwC8k9Jg1Mlys
	x2FHVnoIByIh1y/stSa+uLCi8kT1/T8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=BZWkX6ff;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763026007; a=rsa-sha256;
	cv=none;
	b=oLk591Yn51n0rMF0mJ23Mp9O9X/0l0Tfduxm56q4pkHEkihabRGJbaiJ0PRDJBiABPzNlj
	3XtYGP0Rs8dUbBahDoOLwmM8yA+lD8DUkFKWZFhZ9LQuHcg/gvAP/20oXWhO4DmxG9XxdN
	kwKiKCfkp+Yjr0Raw1TaS42NKynrN/Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LDUxCZ9a1FBEg+ndXr53elrDsetDAHrRuckIwq+rkq0=; b=BZWkX6ff3GA3RTeDfa4driAPz2
	WEG9gIlnyiYFdtMOWlbZu9v/maRJmMXsW7OV71VZxaFQzrkQ+QdzfOvUBvZ8qNmBTAaQ0c64+1a4e
	e2Ntp0fd4Nz2PbSh3xvepolayFe8B+2k6YRJKodfIL7Czycd5Xq28Trj5RrH9AvJL7ifIGizzoNUd
	S85OBW6rXLf1OGeorqTcGvgW3AVCokPuyfp1wjY7Y3yAbmhvYTcVBNIroydt68NMMAAiPyRPwfcyz
	nXp2xc7r/dlTreE2iy/5WTgr8kPTqpleSNRGiMCmePXOZMGXGvpta32ZoNyWi03E8Avg9wVxF2qVG
	6GSVcCPw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJTbA-0000000HMAd-16pF;
	Thu, 13 Nov 2025 09:26:36 +0000
Date: Thu, 13 Nov 2025 09:26:36 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com, selinux@vger.kernel.org,
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, ast@kernel.org,
	andrii@kernel.org, daniel@iogearbox.net, martin.lau@kernel.org,
	eddyz87@gmail.com, yonghong.song@linux.dev, ihor.solodrai@linux.dev,
	Chris Mason <clm@meta.com>
Subject: [functionfs] mainline UAF (was Re: [PATCH v3 36/50] functionfs:
 switch to simple_remove_by_name())
Message-ID: <20251113092636.GX2441659@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 460A740015
X-Stat-Signature: 5gfxd95c8wwzhxh3pyef7q7bdnywe4xw
X-Rspam-User: 
X-HE-Tag: 1763026007-686723
X-HE-Meta: U2FsdGVkX1+Yo+u8OLwCbiIMhQzG88WwKvG5EWVz/C6xBleBtoztn8ZyvqPDqGHRwlvJAi203AKj+dbvoGhHRTl8ZHZs9O5/tYwFsj0vAaxx4gXAauFDp+AkGlG7RukLhgfN9Y5BuUWWjpS7g36KRpk/oeCr+amu8nx9NQahg1kgzXbASiWhQ5jKH4t5WMnb4ElCJaMG/ExcqyA7scphlW0+Eo1Y+hRNt5nyjTvvvvL2QohasInWwtNL4vqgVX5q3Cw0aPhJpyo0kcX8X1svy8cj2hKf3lEM5OI3lyWryXh/27MSjzqf4w3fICVRlrWgm1Aq/uwIgrNqAiX06EF0/u47VpGcpj70xf3gbcjEsvGDGTiT8mlDPQvnSOfmiGA66DrR68wxGEkcln56nN8LNmtjcps+LQ0JAYEC4caF9SyM91rwqfThx7CzH3TFcayKT66NiFIrrJ6EjAJSBN33zaC0mq92U3Dj4BeNtq5U9gJhGYYvWONWJpvu6TUMF/unwkK0NeyBECFMcHPQJKKoaAzwyg//hdxPd1PbJfVwYecVRJAHT/XJpzI3FG0dU9sleyI1q1SmhyZ0b1IUc3nlTM1eNyZ9j+K2R7DUDZHdKndeueW5q4/n6+Gv7p+XatBtiwnJ69rE0zTpmnsh3af2P7P5R30Y1xO6GXjRQlWereqr5lteaSRz3e7W/Vpsfnt7TvXv2/asLcl13RjgzNVjmpRCilse/L4IjbX993P4DFBno5zJAR5SlpngnH4irIUu/e2fteXHO/EVHTbVSSY4Ormbyojv1dr/k6XuRdmsSsTTCS2uSQTQp77JFFBq77hbZJHUDZklSOFB8W9ZEihEZnHqHb/l83ejTN00U3Fx2iCuqth/F49PIiFng2VE1HyuM8WODuTs8WxKpJnG1r0+kLZvb4g+7vx1kfiAfGPGwLfWc9OhNGAL0cpnMP8LyqZ3IAlZMzk4zdbTxu9FCl4
 d9BQQ0dE
 QkKS7ejZtt2uoeVHOYqhaBmxSxVU0WHPv9L6bD5CI1jEHvHmAnimSoomGWxaIPrTburrKErNESm0cfGQSVEh9P8npo3onzO+4epLQ6BX+mLBfZ1vKUf2orheCZLwo8OP8jAeja4g99EA6H7ILhMOWMn/zKrWkx7X6/mawiICIK73w5X4bDoqPlHUDPT1c9B/E3my3XPQF5w1rLThrhntNd2an4DB+LGDMBDj33FXZDJXkf6+D9+nhvyoJUJd/MxFac/Z1OlmylxiB+Xricp/QLhLLcBrPg6J58PqfXmEWnfPbYuViYC4rwq+gzMm9A6E9G3VOLR6zLYpMtXgbBCJbGQhl1vLD4+yx3uyQieAN/oXXndm0SwS1NrKCsOxdgYSqFxFNHESuPg3w3v4J0Te38o6JTsU5yHRQHdk08A0edDnLZOdpgFnDkHFRg41C/FFs4z/QuCohzYNR6Q9AVWhrzhX0MIgmM2GkxHTDZW0mRPKUxAJw631X8wJ0wgHeVBaYjYUH/ollCkvdqgc6+O7ZNcC8WA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 10:44:26PM -0500, Chris Mason wrote:

> We're wandering into fuzzing territory here, and I honestly have no idea
> if this is a valid use of any of this code, but AI managed to make a
> repro that crashes only after your patch.  So, I'll let you decide.
> 
> The new review:
> 
> Can this dereference ZERO_SIZE_PTR when eps_count is 0?
> 
> When ffs->eps_count is 0, ffs_epfiles_create() calls kcalloc(0, ...) which
> returns ZERO_SIZE_PTR (0x10). The loop never executes so epfiles[0].ffs is
> never initialized. Later, cleanup paths (ffs_data_closed and ffs_data_clear)
> check if (epfiles) which is true for ZERO_SIZE_PTR, and call
> ffs_epfiles_destroy(epfiles, 0).
> 
> In the old code, the for loop condition prevented any dereferences when
> count=0. In the new code, "root = epfile->ffs->sb->s_root" dereferences
> epfile before checking count, which would fault on ZERO_SIZE_PTR.

Lovely.  OK, this is a bug.  It is trivial to work around (all callers
have ffs avaible, so just passing it as an explicit argument solves
the problem), but there is a real UAF in functionfs since all the way
back to original merge.  Take a look at

static int
ffs_epfile_open(struct inode *inode, struct file *file)
{
	struct ffs_epfile *epfile = inode->i_private;

	if (WARN_ON(epfile->ffs->state != FFS_ACTIVE))
		return -ENODEV;

	file->private_data = epfile;
	ffs_data_opened(epfile->ffs);

	return stream_open(inode, file);
}

and think what happens if that (->open() of dynamic files in there)
races with file removal.  Specifically, if we get called with ffs->opened
equal to 1 due to opened ep0 and get preempted away just before the
call ffs_data_opened().  Another thread closes ep0, hitting
ffs_data_closed(), dropping ffs->opened to 0 and getting
			ffs->state = FFS_CLOSING;
			ffs_data_reset(ffs);
which calls ffs_data_clear(), where we hit
		ffs_epfiles_destroy(epfiles, ffs->eps_count);
All files except ep0 are removed and epfiles gets freed, leaving the
first thread (in ffs_epfile_open()) with file->private_data pointing
into a freed array.

open() succeeds, with any subsequent IO on the resulting file leading
to calls of
static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
{
	struct ffs_epfile *epfile = file->private_data;

and a bunch of accesses to *epfile later in that function, all of them
UAF.

As far as I can tell, the damn thing intends to prevent removals between
ffs_data_opened() and ffs_data_closed(), so other methods would be safe
if ->open() had been done right.  I'm not happy with the way that FSM
is done (the real state is a mix of ffs->state, ffs->opened and ffs->mutex,
and rules bloody awful; I'm still not entirely convinced that ffs itself
can't be freed with ffs->reset_work scheduled for execution), but that's
a separate story.  

Another variant of that scenario is with ffs->no_disconnect set;
in a sense, it's even nastier.  In that case ffs_data_closed() won't
remove anything - it will set ffs->state to FFS_DEACTIVATED, leaving
the removals for ffs_data_open().  If we have *two* threads in open(),
the first one to call ffs_data_open() will do removal; on another CPU
the second will just get past its increment of ->opened (from 1 to 2)
and move on, without waiting for anything.

IMO we should just take ffs->mutex in there, getting to ffs via
inode->i_sb->s_fs_info.  And yes, compare ffs->state with FFS_ACTIVE -
under ->mutex, without WARN_ON() and after having bumped ->opened
so that racing ffs_data_closed() would do nothing.  Not FFS_ACTIVE -
call ffs_data_closed() ourselves on failure exit.

As in

static int
ffs_epfile_open(struct inode *inode, struct file *file)
{
	strict ffs_data *ffs = inode->i_sb->s_fs_info;
	int ret;

        /* Acquire mutex */
	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
	if (ret < 0)
		return ret;

	ffs_data_opened(ffs);
	/*
	 * not FFS_ACTIVE - there might be a pending removal;
	 * FFS_ACITVE alone is not enough, though - we might have
	 * been through FFS_CLOSING and back to FFS_ACTIVE,
	 * with our file already removed.
	 */
	if (unlikely(ffs->state != FFS_ACTIVE ||
		     !simple_positive(file->f_path.dentry))) {
		ffs_data_closed(ffs);
		mutex_unlock(&ffs->mutex);
		return -ENODEV;
	}
	mutex_unlock(&ffs->mutex);

	file->private_data = inode->i_private;
	return stream_open(inode, file);
}

and

static int ffs_ep0_open(struct inode *inode, struct file *file)
{
        struct ffs_data *ffs = inode->i_private;
	int ret;

        /* Acquire mutex */
	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
	if (ret < 0)
		return ret;

	ffs_data_opened(ffs);
	if (ffs->state == FFS_CLOSING) {
		ffs_data_closed(ffs);
		mutex_unlock(&ffs->mutex);
		return -EBUSY;
	}
	mutex_unlock(&ffs->mutex);

	file->private_data = ffs;
	return stream_open(inode, file);
}

Said that, I'm _NOT_ familiar with that code; this is just from a couple
of days digging through the driver, so I would like to hear comments from
the maintainer...  Greg?

