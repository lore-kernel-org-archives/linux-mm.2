Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69046D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19906B00B7; Thu, 15 Jan 2026 12:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3756B00B8; Thu, 15 Jan 2026 12:49:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3FF6B00B9; Thu, 15 Jan 2026 12:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEAF66B00B7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:57 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71102160416
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:57 +0000 (UTC)
X-FDA: 84334936434.23.4E52AF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B26581C0011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PYvNCKEm;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7alxoteVO3R/zH873ahX2WwdsTpmrn80lHOvMEo+NwY=;
	b=ahXOzEyn4rLcLDpFRmgMcoqtxikR1IT3YysgXVHk26WF28V4u6A3tCER98pDc5mg9Jbs4L
	ZKb612U7rNmQiMisXoZgiLEc3d2eKRq0juDHL6lDGEpyUDk4PicDQ2oDN57c3+xsw9vhOh
	Z57Y0iJpmbrdgwHffK7NTX1fjBuZtK8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PYvNCKEm;
	spf=pass (imf18.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499395; a=rsa-sha256;
	cv=none;
	b=HgQqyIVsDUd5O4MoUINjn7hgRUnB/iaM0vNg9JmckYrxES8NukluK46WcFA05u0HcowdLQ
	VluFV4N59dCDAF7mn3XS9VSbZNKNps8LBJYpi/+DQidLmr2lH26gFlvNld14MdNDHc203g
	YbdaY8QBUCyhLWwvoXjaC4fxwKWUsSo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 30DCB60193;
	Thu, 15 Jan 2026 17:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BD1C2BC86;
	Thu, 15 Jan 2026 17:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499394;
	bh=uje1SB5ZiQFb1nZ8cBWe/zh7xTuwWFv4kYXj9kW+shY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PYvNCKEmybxkHf/xhYZRJA1JR3gi7hwzBl39gO6WcRa3q4IORVrO7YuHny7TQpgiy
	 zl17QOknyAtYmsTiWLBB8kQX5MvY5wrTFagloc02WkBy4em6uCkvDjKoFHPKgA23OP
	 emXGk9XryVRw6nf06RD9Jk//mYkLce7bxq8Ap9KaZVFkkVfi2UtR1Ay7+9pJigW2aV
	 gCp0wp4jlq5kzP/U0dF9wDDaTjGEPnvHrsy5L6bYYDJnpDGVchHD6uaUI+z8KRqcQP
	 iGrph9vhwR67PUaiR/AGoZY8mbdpeRYHcNNaXtUEfUA6tSTZqAxqkmZ6b2KyUgQrbr
	 crJ/YdcNWu9Cg==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:48 -0500
Subject: [PATCH 17/29] orangefs: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-17-8e80160e3c0c@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
 Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Dave Kleikamp <shaggy@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
 linux-f2fs-devel@lists.sourceforge.net, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=uje1SB5ZiQFb1nZ8cBWe/zh7xTuwWFv4kYXj9kW+shY=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShI7iVykyDXfFrTuLTz0reyANBqvVlG7B0Uu
 1Vj+ckj+QSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoSAAKCRAADmhBGVaC
 FVnED/9f0D1oqBjCgp3CIeAScQlnoGQ8qajHoqRzOI6pjd4BeqJxdTpgcQ9spfu5wEwf8/uW168
 AsidtnL65hfLo5B2jfzmYVtN8khTkYlu7o+v30HMwhrc+TdP8MbPt5uENZxqhYc6IzHalGQ+sA6
 lO6ebPCT7OSx0kc8KCnNrauxgw0r2yW790BGEUUOd5rdNkOWFNANuL6cCsZ0iGnWS5HgN/IIaXn
 pSuaXSn5yI8kTwKbcq+UQl26zHz2XAH+8XaabHQwV1/1tqbprihc0VIjA9ATuJ3el552cA4P6t7
 +mUkygIX/9E/GK/b2xR7rQdMtzwrMXfwYMKX3Dm9EIeRBKaUAkYDju/jIZ1r7fC8zReSpsp55KN
 nm9vynzH9R1cpP/fVn/Mi47dNwrypVVxyaeHqDW6OWQQthOCT5LIHs2LyeLStN7qpqPQElynuXd
 LyF0nnucvGghbceqM1JJps5jcNg+YM6f7tLgSJMUW2tieWOWIL3y7du3CI3YXeeHcFJE4AVp9Zf
 v8PN25mGlu9MyKpPWG4vF1MEDrCXJHoFgL9Pwyd/UTE88RjgfrbrP4dd6dGwiq04F6Z+Hyy4wsO
 CBxXCdkbZP3HFIUX0kWTbzYM0yKyBotEBElD6owLCSVU9rv0PLz3JL1vHgYObjL5Ke/6POBKGIq
 72Kjn84TseU7iGA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: ucc3roq7ebuy3dyyyqjdggythwfq1az3
X-Rspamd-Queue-Id: B26581C0011
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768499395-13437
X-HE-Meta: U2FsdGVkX186HbsxupzDtq02ZLEA7IjqtFr5BY8p268xOPSG9aZPMIYLvvRgbhiJ0v9r7fnOlBpNYzSB9MqPTAfmIDUuFgYiqd/N+yR0nBbLCPAeis6jbuZxJI90OPfWJbXem314bB8xnmQmrFEud9wmLZlsXMMQqjrAqKt+5zkwMqH0fLhXgR6+PcvNtTh06sxdZcVSW/8rhOoAF8G8KxBWajGWSsDL25dgbqt03g0GHo4cHMeYR19DYbnCtL7maSxav01qO2XdpNLrzi4Xnpip0xBCokd906QQsb0ZNo8ok1II+dpNA6t3zOXWjWmdvFOKYMUU/xxwXIhlkQ7j9I+8YCTcwPZ/fDVYiq27FnTxZkaqXcQ3BnMvLdd8Pz+4EwriSZyVMYNWw5V7GsL5NoZiItPmP0y1F+HxOlvVyx+NdEAaC6R91SiRd/LHLTo2Lix/i3KG/1AusYJBPWQ+eXCCmYF0iFiEC89ddrzCCVPfLRjSL0NZYm8MGKwLUPcMwEnYtSJRjvZ5kg6X0CpD+NlJnlVlMb5fWDvQQWo8skAS7wHOxczblsSC86/wwYf2lbttCS/jGw64EX5NFMGG5kdqpvBIYGq76cx4OdNagA0IQwU5MMytMSBSLO61AgkOxqoeNGDStGkkMv8SaDjTyj2kT5iz7uNjxk+eu6wlBismcyCV3PASJeUHD/iA6u67Cyk6PmTo10JGhhwYzyIOoczqMOrayGNX6axG/sjb1Q/FuuiSqvqdwow6VD3xnfeuphs75b3zGVLJpStjzmkR/gXi2Bmjy8glRNUqjLFZ7C/rFcW0PshUchdC0TDJzZDAGr/iqkA9N5Nfeh6KtV+/puvXh4hnj3J4/UpnHKZTxDYlRm/Ibt0jGmXQaqdLbxyYZxbqOF/FlEH48aywkkP86QwB4COReGo0d8CypuKB1f84lqpYLn1Lu1byf5egR8iqBn1qMWtcvJjT2mvtCcq
 IqStKLcu
 6WdV3dlSPwsOKSSfAgjI2fkBffrL1S3lh60MpIoM+T/OTEnj2jBp8o6DOeDrT8+GiKu0IQWlSb/WCLV39roOg37Y2VajuVupegnA83YnPTQ2X1Gg676nNrAXOOi9xGmrjnviKb1YULtI0T3ZpqDq2SIs/v/+BckrKlX1I1UwUE3NQL7Ne8x91SFz/h4/gwb3/SjTY+JBcvaBKW4Ca+1i340eqbBFEEAyx0/pQWgkzNWlM5gp4Et+5MzIQjslo7dhUyhAKIZLnSitJcoo6y0t60g7YkbIHfzGzMQ8E9fhNisW8uLX7PjihGGGoZ72/wTs+GQsLnf+8KluPpUc7d9eoMuOjcNTd+tMr/1tKuKqrxj9mbN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to orangefs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/orangefs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/orangefs/super.c b/fs/orangefs/super.c
index b46100a4f5293576549300ae9050430c3f07969b..140f27f750939cf5538eb68501dd60012bd2daec 100644
--- a/fs/orangefs/super.c
+++ b/fs/orangefs/super.c
@@ -377,6 +377,7 @@ static int orangefs_encode_fh(struct inode *inode,
 static const struct export_operations orangefs_export_ops = {
 	.encode_fh = orangefs_encode_fh,
 	.fh_to_dentry = orangefs_fh_to_dentry,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 static int orangefs_unmount(int id, __s32 fs_id, const char *devname)

-- 
2.52.0


