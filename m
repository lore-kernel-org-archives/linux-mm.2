Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4F2CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678F48E0011; Mon, 17 Nov 2025 17:05:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650868E0002; Mon, 17 Nov 2025 17:05:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58ED78E0011; Mon, 17 Nov 2025 17:05:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46E848E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:05:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB451B7BE6
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:05:02 +0000 (UTC)
X-FDA: 84121480044.19.58FC18A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D50580012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:05:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=K4pKqDPp;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763417101; a=rsa-sha256;
	cv=none;
	b=xpvbHpLEKiBEdPUDSoB/79Z7hJvreDK+ZsixqaHyRKytzd55rfohYvZXVPfj/cW/Hhp4ti
	+nlLpcFsZvxjE9TYWRrXXz3EnBtq8ibPKbmJnCsc6LTx5wAKmXqb8ywoIsFBd37azIkwGC
	RovFRpBApp2AsUS31v3ZZTqgk+RnVLc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=K4pKqDPp;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763417101;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YbheTvDaLhIgSaMH09DWUPWaNZLIZj4gJqU2BhcofhA=;
	b=2xCaV6994pCBxqoMeQSpEj6u3mL+BtT2CgxjYbBtAVmXo77EXSVkGEzHLtpUANrAECqYsa
	g/yZAuyQvAbT0QNklxBMntDU9Xkh0uhJVHvUEkAkx22IneuNmjjQnvXjqxQ+59Rr6z1Zr+
	UgJ2YXLqTv9ky4utnqCaQ5XAUYxz+t0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YbheTvDaLhIgSaMH09DWUPWaNZLIZj4gJqU2BhcofhA=; b=K4pKqDPpn8ieOd7dgDMMLcn6hP
	YNkd5iTaJ9jsJ6HthOi27ouRU1rNzpQpkIHQ1O6A2/2FiLiaAibHOmWkYp/AOXQgfxTiNakwk4VWN
	NcsWmqf5yGTRpDBy5+7fZnGgnhWR5lt0hFrBwOtoA+FJjR8GJRkDUlO881F4SvvLWjbrq9rxny92x
	mOXpWfdfvEiGES+7atowUfisqBHjBgAmRr9k8GpIHjJKa1c6uv45lHJl1qsk0q4U6ZanrchMFffNj
	5hTR+ZeOd97zj4pyRLctc6xo20wRCLS99xBAz8a0141JHzOjSTJAnPJLI14jnX1Xuq+5uvJGlYyD3
	ubOeBgsg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vL7LD-00000007KkO-3TmK;
	Mon, 17 Nov 2025 22:04:55 +0000
Date: Mon, 17 Nov 2025 22:04:55 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, ihor.solodrai@linux.dev,
	Chris Mason <clm@meta.com>
Subject: [PATCH 1/4] functionfs: don't abuse ffs_data_closed() on fs shutdown
Message-ID: <20251117220455.GA1745314@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
 <20251114074614.GY2441659@ZenIV>
 <2025111555-spoon-backslid-8d1f@gregkh>
 <20251117220415.GB2441659@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117220415.GB2441659@ZenIV>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4D50580012
X-Stat-Signature: howrnanafzrapwhoa89szzkuy4iek3t5
X-HE-Tag: 1763417101-43536
X-HE-Meta: U2FsdGVkX19LnzN3hxD7bnBHwuPBpjWxVm81PNyyHSya9Ng7PQTauD++PJDsFKc7G3WdMpijyYLjTrJ8EcjkVMWuEKYOciyzLaYqj8wayhofOagWQjEESmi66lTfsd9g8zV+E2YIlET9zVk2W68ilalJHf0WNVqtCNqWEI3zUQ7BEKdZVck6MU3L06UO4LW5hodemfPQQSkcaeZ0hqRONUDcdsAbwH8U/hGawdhhLFuYyR/8ynwoqPM7AexoFqKcjIKTYiMiq9Wfd6VMPiQF2stugvqY6T2UmrzflD8G0ZVxFuNLmD4UZyVWZwkBtfHQhYHj+8BdavPAMjirpPxpsl3S9h4eXibvrhfbQ1DzxQJ8nSS/TXWheL1Y2nVRj+56q446DGfntIsukeQttj0WuCji2LhDQOXaXYgVzzgvx8uPM/nWb358TVuYw1BiWMY3mldXnTN3Lvsh5NYBAZvxduG6E/8vrb1qK2aWc7/pveQ2VmIBj2vzff6t0/wh1MFoy/IdzA1qfdeEwhdj1zJ7Q3lsI4vsu6i/pkH32h/gizpgF2Tng1Oxi/qRyETK3wZLc0xjxiy4Fa/kaMd85EIcZzJi5zcHo710pr4T4I8Hu9ZmpZc3H0xOA68gPOSr0GWPaJnakRoDrij7CGkFTkYvn3JJxy8Jw/ud00WM5gGXCnC9mPkfIf94QUIW9VWT6TS2TsxytqX6svhuiYMgblFO+TP3TWlbqzulTdbLh2Tm78EkU8NW7e0t9KQlmhOqrQciEqKAEEFzIQvG8DmTY6vp/odqe6j5FlyWvNWK3/oT0CrsyN2CqxIg8IPVDaOt86O2GSGAewked+gMY0qh4Hg8Du/JFNRf0qPIyfj+AaEXKl/YlyBs8jFTOVtmhRSCOznHjTfa15DvtawacuV57HcM8v7nSezhPV81OeObSbCDTx9iipH+eYEXuR4CYqoH2m+AYUpgtEM8x2Gk/1s6CTh
 42M6IGjA
 wG4+0So2Vn0moPOkng43sJg+Kkmcgu2C86tGthlrri7m3MEMGhg73rLP7RC1InHlIx5Wi+RXmQ8EF/CyRhT0goi41yczfZQajUHx1vyGfYXgfKcPd7rVGEaGeef1ZPZ6RPC6hiwzxL1MezJDyNqgQtZOsvHigbPbFPVuwUb9KqnQT4t9F8DUxPE5QDlDlpbUUKNwq/SXD5oMHtTEv8w6zl69Pu/wqJNlA+vakaeY5c0WiTLxAFA56DJKOmqBaMaT2+PzazHZ55eqpDhS58qWEI7/U5/z5LcI0fSflbTVOmR6d5XEADPODWQnlzWIjtvpqfY1KkLrOA2Fhjkszmw55uzhN6eJ8Kgvti3HbuviEHmnxoKN6pryIWJIAxLfc8Cv5T8q+hoPdl4PeS/KwC5BXWcUIAaH25Dt4WSgyLaPNtr5vYYRqO5OJZYu9nwyho9CMd3rbHumRgo8u+xpVDAAdUbM0UHtpghTTBggbq2yycxCDnDChECXsHytvEnTHuvnaU7OwZIhNFmkQi2J9nswDAYq7PSDbgJUIQhoWRl2FN6FNdo1hhQVHSC2Cn1vmgzgNeNwpkdWR858VkZtgryHnXUDRh6r59TzSgzrkXC9BdmeTeFtMMneUX4A8ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ffs_data_closed() has a seriously confusing logics in it: in addition
to the normal "decrement a counter and do some work if it hits zero"
there's "... and if it has somehow become negative, do that" bit.

It's not a race, despite smelling rather fishy.  What really happens
is that in addition to "call that on close of files there, to match
the increments of counter on opens" there's one call in ->kill_sb().
Counter starts at 0 and never goes negative over the lifetime of
filesystem (or we have much worse problems everywhere - ->release()
call of some file somehow unpaired with successful ->open() of the
same).  At the filesystem shutdown it will be 0 or, again, we have
much worse problems - filesystem instance destroyed with files on it
still open.  In other words, at that call and at that call alone
the decrement would go from 0 to -1, hitting that chunk (and not
hitting the "if it hits 0" part).

So that check is a weirdly spelled "called from ffs_kill_sb()".
Just expand the call in the latter and kill the misplaced chunk
in ffs_data_closed().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 47cfbe41fdff..43926aca8a40 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2071,12 +2071,18 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
+static void ffs_data_reset(struct ffs_data *ffs);
+
 static void
 ffs_fs_kill_sb(struct super_block *sb)
 {
 	kill_litter_super(sb);
-	if (sb->s_fs_info)
-		ffs_data_closed(sb->s_fs_info);
+	if (sb->s_fs_info) {
+		struct ffs_data *ffs = sb->s_fs_info;
+		ffs->state = FFS_CLOSING;
+		ffs_data_reset(ffs);
+		ffs_data_put(ffs);
+	}
 }
 
 static struct file_system_type ffs_fs_type = {
@@ -2114,7 +2120,6 @@ static void functionfs_cleanup(void)
 /* ffs_data and ffs_function construction and destruction code **************/
 
 static void ffs_data_clear(struct ffs_data *ffs);
-static void ffs_data_reset(struct ffs_data *ffs);
 
 static void ffs_data_get(struct ffs_data *ffs)
 {
@@ -2171,11 +2176,6 @@ static void ffs_data_closed(struct ffs_data *ffs)
 			ffs_data_reset(ffs);
 		}
 	}
-	if (atomic_read(&ffs->opened) < 0) {
-		ffs->state = FFS_CLOSING;
-		ffs_data_reset(ffs);
-	}
-
 	ffs_data_put(ffs);
 }
 
-- 
2.47.3


