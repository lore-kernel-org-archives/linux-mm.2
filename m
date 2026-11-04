Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C773C606FAE8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UquQVFdG
Received: by kanga.kvack.org (Postfix)
	id D648D6B05C1; Wed,  4 Nov 2026 14:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15336B05C2; Wed,  4 Nov 2026 14:19:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04BF6B05C3; Wed,  4 Nov 2026 14:19:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 938E96B05C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:19:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FAFF1C4229
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:19:41 +0000 (UTC)
X-FDA: 85398400962.30.0A9E0E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 370141A0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:19:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UquQVFdG;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819979;
	b=08gRw/UbYqLBQ625PHa50VPWZks+J0nXKl2gt2lBQIiaIH9AWjGw4HhXd/mNQM+M1pHZwE
	7wFcwnR/RCXV5TMq7I5Mw2QnrNflFjIKn0cxiAY3xaT8GdONxfm15eI77PBcRLY8DXmdok
	TujGtwt1wE24SCQ47b0X6MIwZ0TO7Dw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UquQVFdG;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZyIQLij17XFBIkY/FnNnjbp2RgAs/rkMBTgRuVD6WA=;
	b=JHf/fScQ1iV09cg4cxpDoLpKhpI7vgRLD0oA7YKqVbh5YoIdZuRdB35yla2TNoZo+TcGnu
	s1CwBcIVY9wyJHMLfnNMQ9zpR12UVxqSQMF3aCPjuGHlq87gvm1h8LooGFn523D4vMWlH3
	CGigHjDXErGIeSvXkkMUd1d7mPv5Gck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 808B941485;
	Wed,  4 Nov 2026 19:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2211F000C1;
	Wed,  4 Nov 2026 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793819978;
	bh=3ZyIQLij17XFBIkY/FnNnjbp2RgAs/rkMBTgRuVD6WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UquQVFdGSzwe7fOqi+LzTOMp+2rigsfWxIAUBskeYKdDPktAPBz0dC1Ky9xVgLPJ6
	 PxjYY4ad50AsLCrFoewzc6rxKhLSxBpDvF0I5ej6BOl/KhPCUg0fxW0LnI/ODrAteZ
	 gjr5s8RQxg56swgMcrzZtkIliG4rHYkP/qWWVil89NvValFsxYuugkdm3C+LD7HEVh
	 JaWz4IeTKnJ3KLOVpGdXpdtkBFXK3vnj1bwsYl7cZuhnH0ZL7cCDtZWYuzFyV19v4t
	 59bUwTSf4dkWbRcTPcvwXUGjo4Xs+7a4ChNX/KHaOiJQMZrRfbBtelWToON7Uage1C
	 8mpDuOEVUITsA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 14/51] proc: sysctl: don't stop readdir at an entry that is being unregistered
Date: Wed,  4 Nov 2026 20:19:24 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-14-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1722; i=brauner@kernel.org; h=from:subject:message-id; bh=6hLGzd3ohIjIvoG2NrLKRAR6DerSlran3UFG44ON0F0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bryzb4l1yo+SbW0v26c6WF3kejzthlPTlKvH65zrf 4ekRggkdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkZRMjw7lnT3e45jJIFvEe lD2X/fbQ8Qfz7ab9fzQ1681BpYwLPlsZfjGre3twV17+P+2PxgzpuirDdx07b2yVkzfcP7Xlxf1 UFxYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: snkug3d6u1mwykrgyw3kcohoh8gmbtb4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 370141A0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793819979-770253
X-HE-Meta: U2FsdGVkX1/FWhBMIxpzADVoLGpTFEcJjSZvP3q2fv3MuAMP8o+79IzTJyq+ajK1JwNHioFXdlY3iTBxCaKU2kZURHF7IK96VMm79RSbYlSS2vbjprkQxj9EV1aElNzmw7XNbKpGG8JYPCMuZLanMcQCgoMey3ZKNsESN2c7CHatdlUkNU5ln4PXXxR88Kot/yBLdFgYWYf8Vdj3RkXHeAO5Uvt0DUEr025AVkEmYwmA9P/P7cmhPoficWWYcdl277noaqy8jteqQEK+jMehm29KYF/tNkpY68oliqAjaJSpM8Emxs29LXk25CJuUB6L71dFRG+XENUGu18aPH7SSkqE0fVKcUZm3G1nxck9TCLFrvGE8aB3G79RfA/j0Cpg+XuamyKmycObf27pZHVFKNdVNRM5lg/4MratncOlHccfrgNdNvMSGgQ9dibaZD9mCgb2JvVqsfhXVFyXO8mtHXuhpFIJ4K87ajZdGLyEBLi5CzfoovZ8iLnEIZhuEFIMKQogMX8TaKjHJOAX28C3siw1Sx+SJUYkYhpZH2qyuYevcyQPQlp9e/mYMDZ5KCXpXelRy1A/fAzlYQexmgiSnEMKDtvZZm8ttQgfXrCzupS4Apts6xIQP2H5jyMyKo6KNnHPg4rOL8Sp7lnH/wo3wgQRyZI01cG7zZPFzcMYs/hHzmeEL6E1EDoxcmt5HjeXwj5MUGNnMTZnCzCP+PIg1kYyCoDj3kVWTjKrv2/yxUz2kF3W+OQApxZrTsJvRaPz+GbirjmhskijHE+byM3AGZevTGZvF92tN9Vk+iUef+VHwz3eZoicTtceoWw7jLyYZxZ2kNB9PWe285Y+iuXl2rwaQWvfmtnhlko5b0yJ2KomchAGeDTbVQwMvcBBREQsTIaKnBMhZgmXctlHYSsFFVq1U0o2DfNbejzu6i/fiTQkuThEm51JPNQRPpOMh6FsChj71zFwWyarlJimK1u
 7xu2NjkZ
 KGKzTTmgpu/F8sRtPbw3d0wk3kvjjnF/PCf8u7QTGezzf27dn8aqGgduAJfp0R842YhtrtwMLpNTV1NhJW3nfWhaCkWn5lCM5YSNdYFE6pPRR0bc5fr2R2fRlEruQ2zNb260NO5Y638AOTJnt0CBxgET9qUT/+7ybTWHYTHYRvxspIPND8/hUN+/WVVafu4aRsfWxxDbCA2Ru1ZOCj1CESB1wwWHfJQq+Lop9Y+ZtDN9mLVZKJN7fGf5fCrQKKxiv/XDTuJr7JVPMU6ZqzC63WlUCy+T8Esr4fFgUaZruniyefrUpjBJEooTjyHOgKVtrZG63VUxyedBRPiuxxWWuYKWpWw1WdwbDQ9hdtaJpF7+eNidgyUoOR5CP1uLu0TM/4dpWYWoG6+iydSJ/+yN91qkccGQSwJQyo4N7O5c1ehDg4RSXuc1axgtW8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_sys_fill_cache() creates the inode of an entry that has no dentry
yet. Since ace0c791e6c3 ("proc/sysctl: Don't grab i_lock under
sysctl_lock.") proc_sys_make_inode() refuses to do that once the table
is being unregistered and fails with -ENOENT. readdir takes every table
it lists into use and unregister_sysctl_table() marks the table as
being unregistered before it waits for readdir to let go of it. So an
entry that is unregistered right then makes proc_sys_fill_cache() fail,
proc_sys_readdir() stops there and returns 0. If that getdents64() call
hadn't emitted anything before that entry userspace sees the end of the
directory and never gets the entries behind it. A listing of
/proc/sys/net/ipv6/conf can end early that way while a device goes
away.

So skip an entry whose table is being unregistered, like readdir
already skips a link it can't follow. Lookup treats such an entry as
gone too since ea5751ccd665 ("proc/sysctl: don't return ENOMEM on
lookup when a table is unregistering").

Fixes: ace0c791e6c3 ("proc/sysctl: Don't grab i_lock under sysctl_lock.")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/proc_sysctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 6c0859c66563..b4a309d49698 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -704,6 +704,9 @@ static bool proc_sys_fill_cache(struct file *file,
 			if (unlikely(res)) {
 				dput(child);
 
+				/* skip an entry whose table is being unregistered */
+				if (res == ERR_PTR(-ENOENT))
+					return true;
 				if (IS_ERR(res))
 					return false;
 

-- 
2.53.0


