Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A1DCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 13:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1AB8E000F; Wed,  5 Nov 2025 08:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8968E0003; Wed,  5 Nov 2025 08:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5E48E000F; Wed,  5 Nov 2025 08:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC7588E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:43:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6408B88579
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:43:46 +0000 (UTC)
X-FDA: 84076671252.22.48494EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 99AA520010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:43:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gpK+52Q3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762350224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbQ1zGlZoO5t6WJhk008TtHvwsuYoe3z8ySO8zHx9/8=;
	b=TiaG4rrndMTiFWCqPHsiXz7VPz8TYhKX/2EwapAZt5SIFr94ZoULBC6hS/OWE1+nht8xzX
	qP6whGtSD3Bot5z1XY/kXL1h6twV2sN/Oxf3qNZQj6gulNYJhjsBsKXauJQ9l9YYkPHIBx
	UcTuJiMlNrxVH9wwUR7woLz7STVTQOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762350224; a=rsa-sha256;
	cv=none;
	b=6VRMKU0P4kUBWqKW9Gk7wvpY3M3mveR0GzT/A8WPmpnW55NoDTBYMY9m/H1O9CBOC4xcyY
	ucKB1Sl7/0AoIxynIMR1jwxcWDhGS+FzO8Nu5sM/PYEQWObR3YUmalt3nrh67t2ZSf0I21
	x/lHJzv5V9hsk+tBAa3WMjD8uSR49QA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gpK+52Q3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1697C43B6F;
	Wed,  5 Nov 2025 13:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06F8C116C6;
	Wed,  5 Nov 2025 13:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762350222;
	bh=Y4z+9e1UwC5T6z0wCgNZeZRbf0AM/5FfB8YJzrR21hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gpK+52Q3omkUnkccjIvVZ+YRsgCuvNHfYI3MIjZdom3SQlkvCxWrDKlJ/warJWlfU
	 E2F8IQSoapfPbPkoeT1aoiEswcoh02gGX8oBXwk3gRHNyBeZUHUeUo+b4cr6I294iw
	 tBcxcaaq3YbSyuRjslKl88dOXL+Cy2viJZ7P25mEP2+E9ZcmFOfYi+ATgSngL6gv9n
	 v2XP08JIGf50Xp2be3XMK7gODkPeWhvGs+zC9MmCzInGZQRHdIk2nCtC0hWYBwb9+G
	 qTgu9snAFyspbiug6v3NCj2Qye16mxq7V5yOexSp8bqBCZO8FEinxKzWUVj4KRIRVG
	 zY/fGjNUXwlZA==
Date: Wed, 5 Nov 2025 14:43:34 +0100
From: Christian Brauner <brauner@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, jack@suse.cz, raven@themaw.net, 
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, borntraeger@linux.ibm.com, 
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251105-vorbild-zutreffen-fe00d1dd98db@brauner>
References: <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV>
 <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
 <20251029193755.GU2441659@ZenIV>
 <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
 <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
 <423f5cc5352c54fc21e0570daeeddc4a58e74974.camel@HansenPartnership.com>
 <20251105-sohlen-fenster-e7c5af1204c4@brauner>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="buvkja4jscyxhqel"
Content-Disposition: inline
In-Reply-To: <20251105-sohlen-fenster-e7c5af1204c4@brauner>
X-Stat-Signature: hhxjkbbgomjmemk7mupiuspzhgocixoq
X-Rspam-User: 
X-Rspamd-Queue-Id: 99AA520010
X-Rspamd-Server: rspam10
X-HE-Tag: 1762350224-809812
X-HE-Meta: U2FsdGVkX18tNYjuwQvSTc8/TjukBZUs/TvQg7TO058uRfx3F+Uln6Bn9258MFn3MpocA5OL8LgkQAswEQfrAdPIBiHDm0l2XME8up/WutdgXVT+kyJpbyB8lyss9dg4Wxdf89SUv4J6hCIPPbfRTiACHNztx9C1/o+RgJ2u6F8V53+Y3Y9FE0fWV43rGQLSxfuPNJTNEjmXRBlOCEG8EaMavdUC5WRUh37W95Kdlk9XKukkVTKF+leZM9g+CksyvS6SKXgkEzbAA2SG0T7fOZwq5+Cousr9DNa3NLOFgA0GhGwGIvU69CnvmZK2ZRytLxwgvkajO/rsdFA2FjUjlx/rQIHpP2MJjiNJlIKI6s7qAUVheNUiTjTuUp02PWht/7tnjccHWaKjf9isyM04xJI+IuLBAJFC96w1Yj9Nstg63yXzaF8I0fM+hvlTizy2kj4K+evmp1UTpFIN85mNRB5t8ikP4UnxrgzVpjJtwEHzfqnCVMN1oY+c2LdJRPDiLxlh1jDxHAK32P5X51g5H1S40nEwGpN8CRur32Xhvu5hU0cYyIPmKR4yLhg2YvLZFavGshMY+6zf9nxK11uOWc/b6vNTRooPvsiAkwHazxkGd9D7EynP+72u4K9Ra80m9A+737x2+6WpZ1j7Elf+AkK7nhJeUcyeELolvleSYUwXH/VemufLBRiJldsxr49eajX1+kbhjxef4SIA3CMMun0bop4yIrpYmnQ6qHmPBdTKKkv8VRBcJLcps+QyI5g1g4+pJklSjOHD/C4qq5Th78GMv2MeptVzyxh93RwBbExif02FhqDP1Ti4459IYWxDOmQxbE1vXqf61P6e+SCoNjjIrIJ/esCkaSSrzB5JWDtF3oGsOhJGsp0kPcStLHmDTyeW/6vyT2ekeI64Fk2thZaLHbGSHYoXAU0nwUzQj10U2j4p9Va6ZaqdiiJ4HQK4tq9h0xDRyioifVrlIl3
 ef6M+oaW
 JK1WtkGTpfQilpMKbUgiAJIHoABaAJHeSA+5zGNGJF4Sv9E/rRqc2u+mqWG5qmZmH0Ne/2MPhX0gHTCVLJHPgWbHhh6GM+zDDk4+cduBbQQLHvgcMyFvLZlV+Go6ZrbN1RSVXk+tnUp3EgvOVJza0W/fh7kkfQBpFJAX4pYzmzN7YN2JuosD765SqWXR1HuEcPJbUM5LIkpeWUEvy/uAes+pb38BZiDWuA7yIYngLg1EqojmC0hJdYb2yICdwnsxzRzzVFigOFVCrdklVffJPLWuV1dWTNvUYItowcJV0MyEBS6yBTkzXt0X+GRr7MrbDJ2RAvjfbO4/mMGwMUb/p2uFRuL85NkozcTWa3H37LXLdhqPoR8hie5gtVc/78ePoKpqDXoyeM00iBdU02d8A600pnSFOhhLyfMSRCsqRdIhtBIpRlPyw4yLzjgMk+RDqAdPybUpbB91B/GI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--buvkja4jscyxhqel
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

> > > And suspend/resume works just fine with freeze/thaw. See commit
> > > eacfbf74196f ("power: freeze filesystems during suspend/resume")
> > > which implements exactly that.
> > > 
> > > The reason this didn't work for you is very likely:
> > > 
> > > cat /sys/power/freeze_filesystems
> > > 0
> > > 
> > > which you must set to 1.
> > 
> > Actually, no, that's not correct.  The efivarfs freeze/thaw logic must
> > run unconditionally regardless of this setting to fix the systemd bug,
> > so all the variable resyncing is done in the thaw call, which isn't
> > conditioned on the above (or at least it shouldn't be).
> 
> It is conditioned on the above currently but we can certainly fix it
> easily to not be.

Something like the appended patch would do it.

--buvkja4jscyxhqel
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-power-always-freeze-efivarfs.patch"

From 1f9dc293cebb10b18d9ec8e01b60c014664c98ab Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 5 Nov 2025 14:39:45 +0100
Subject: [PATCH] power: always freeze efivarfs

The efivarfs filesystems must always be frozen and thawed to resync
variable state. Make it so.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/efivarfs/super.c      |  1 +
 fs/super.c               | 14 +++++++++++---
 include/linux/fs.h       |  3 ++-
 kernel/power/hibernate.c |  9 +++------
 kernel/power/suspend.c   |  3 +--
 5 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 1f4d8ce56667..6f9cd18ce6f0 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -512,6 +512,7 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	sfi->mount_opts.gid = GLOBAL_ROOT_GID;
 
 	fc->s_fs_info = sfi;
+	fc->s_iflags |= SB_I_FREEZE_POWER;
 	fc->ops = &efivarfs_context_ops;
 
 	return 0;
diff --git a/fs/super.c b/fs/super.c
index 5bab94fb7e03..017f0be22c61 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1183,11 +1183,19 @@ static inline bool get_active_super(struct super_block *sb)
 
 static const char *filesystems_freeze_ptr = "filesystems_freeze";
 
-static void filesystems_freeze_callback(struct super_block *sb, void *unused)
+static void filesystems_freeze_callback(struct super_block *sb, void *bool_freeze_all)
 {
+	bool freeze_all = *(bool *)bool_freeze_all;
+
 	if (!sb->s_op->freeze_fs && !sb->s_op->freeze_super)
 		return;
 
+	if (!freeze_all) {
+		if (!(sb->s_iflags & SB_I_FREEZE_POWER))
+			return;
+		pr_info("VFS: Freezing %s filesystems\n", sb->s_type->name);
+	}
+
 	if (!get_active_super(sb))
 		return;
 
@@ -1201,9 +1209,9 @@ static void filesystems_freeze_callback(struct super_block *sb, void *unused)
 	deactivate_super(sb);
 }
 
-void filesystems_freeze(void)
+void filesystems_freeze(bool freeze_all)
 {
-	__iterate_supers(filesystems_freeze_callback, NULL,
+	__iterate_supers(filesystems_freeze_callback, &freeze_all,
 			 SUPER_ITER_UNLOCKED | SUPER_ITER_REVERSE);
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..bde4967fdb68 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1419,6 +1419,7 @@ extern int send_sigurg(struct file *file);
 #define SB_I_NOUMASK	0x00001000	/* VFS does not apply umask */
 #define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on this superblock */
 #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
+#define SB_I_FREEZE_POWER	0x00008000	/* Always freeze on suspend/hibernate */
 
 /* Possible states of 'frozen' field */
 enum {
@@ -3606,7 +3607,7 @@ extern void drop_super_exclusive(struct super_block *sb);
 extern void iterate_supers(void (*f)(struct super_block *, void *), void *arg);
 extern void iterate_supers_type(struct file_system_type *,
 			        void (*)(struct super_block *, void *), void *);
-void filesystems_freeze(void);
+void filesystems_freeze(bool freeze_all);
 void filesystems_thaw(void);
 
 extern int dcache_dir_open(struct inode *, struct file *);
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 14e85ff23551..1f250ce036a0 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -825,8 +825,7 @@ int hibernate(void)
 		goto Restore;
 
 	ksys_sync_helper();
-	if (filesystem_freeze_enabled)
-		filesystems_freeze();
+	filesystems_freeze(filesystem_freeze_enabled);
 
 	error = freeze_processes();
 	if (error)
@@ -932,8 +931,7 @@ int hibernate_quiet_exec(int (*func)(void *data), void *data)
 	if (error)
 		goto restore;
 
-	if (filesystem_freeze_enabled)
-		filesystems_freeze();
+	filesystems_freeze(filesystem_freeze_enabled);
 
 	error = freeze_processes();
 	if (error)
@@ -1083,8 +1081,7 @@ static int software_resume(void)
 	if (error)
 		goto Restore;
 
-	if (filesystem_freeze_enabled)
-		filesystems_freeze();
+	filesystems_freeze(filesystem_freeze_enabled);
 
 	pm_pr_dbg("Preparing processes for hibernation restore.\n");
 	error = freeze_processes();
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4bb4686c1c08..c933a63a9718 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -375,8 +375,7 @@ static int suspend_prepare(suspend_state_t state)
 	if (error)
 		goto Restore;
 
-	if (filesystem_freeze_enabled)
-		filesystems_freeze();
+	filesystems_freeze(filesystem_freeze_enabled);
 	trace_suspend_resume(TPS("freeze_processes"), 0, true);
 	error = suspend_freeze_processes();
 	trace_suspend_resume(TPS("freeze_processes"), 0, false);
-- 
2.47.3


--buvkja4jscyxhqel--

