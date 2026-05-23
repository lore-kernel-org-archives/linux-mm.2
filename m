Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99380CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ECB96B009B; Sat, 23 May 2026 13:55:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D2D6B009D; Sat, 23 May 2026 13:55:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C306B009E; Sat, 23 May 2026 13:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E24646B009B
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:55:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AABC11C0791
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:19 +0000 (UTC)
X-FDA: 84799436358.10.8BEAFA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1717D2000D
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ATnUMplv;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iuTtZ9uTCrL2gUy5rhFYUqVCvakrQG2oy3wSLfhPcVk=;
	b=JRlHbiIOMRG3Ig/qXZaibnP2YG6tw4nplle8VvOuYrmDi3wQUQyBPnmsp679DCaoBDn0FD
	bST74KqCohFMLvj4uSToLanh2UhGy+St1LiWzL6oWLYpMdcvh6WZkSm39f6zDteCtX/IIG
	QG4CP3UgPHpp4Zhiu7AgBqK0bPq4lmQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ATnUMplv;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558918; a=rsa-sha256;
	cv=none;
	b=ScecRF6Iaz+ZYRG1h4rocLsXQqBUdM9bSkzKE3LeV3USO8pzhZ+wqDm7Rz7EEscuMfYRGa
	AW2G9nI44Zdb/UK4ctM2+ofR7lE3ahwYNgigbHR5Xab1KhJxlRbFGBakSzubg0nWAqHjUw
	zutpY6c7oYiO7mm5icZolBZ9cY1IpDo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70FE142A75;
	Sat, 23 May 2026 17:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587A61F00A3A;
	Sat, 23 May 2026 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558917;
	bh=iuTtZ9uTCrL2gUy5rhFYUqVCvakrQG2oy3wSLfhPcVk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ATnUMplvANtFqXnPMMG7NSH8t5x5kTr2rh2BxFK2/mVjIEx0Csre+Yxnx89gvCEvB
	 uHhDVFvMFOGe5KELFWAxCXbgCTVrBKUMFRuF0LRLv78XqrCqluzw3rTHXpk0yXii4K
	 fDJU8jmq2k/g/NjGNa5JSW+CPvvN53gcwu2ld51g061LrLeCS7I3OlrWU8/r17dOxF
	 bJ5qv7tKsbMQ1Om/1fVqqTAJpam8n6zNmdQ1U/w3peqvRTGFGpN7qetPQI+JDlr74U
	 +IrL/dYO28YRNMgTFDRp3h8h0WxOISk9xbTS2rZ8iV2rThE32PwWKlR2cNbCHn6/tO
	 lPASwzWfCy/xA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:17 +0300
Subject: [PATCH 05/17] NFS: replace __get_free_page() with kmalloc() in
 nfs_show_devname()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-5-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1717D2000D
X-Stat-Signature: e3uz6f4r14fth5rwwfxgxpnmr665mom8
X-HE-Tag: 1779558917-791793
X-HE-Meta: U2FsdGVkX1/aQu5ZhGWFxNReKkTHa8rHhfFozUucCbx7UT3zU3oyqoJH0jzJUEerCC+0yIk12HqevBiD1Wrv06wbtBVG2SM3zb1cWmBRdbUwLmWgYf4DB3Qbgq1dOnZQTED04RqqBU0FjC9mDMEpdmkJYZmjJb9cOZIcX0HmTlnSXE6CuuR4W2TFsIYH8Yjks8Ue9lfNkvebSNOwWPkunVm2ovEwnZ9eqCgilBXyW61JO3Kagr9P6TUkFP+0ogrfH+w2T1WQVdko4MWTcGOL0OKLGVPdWT+9h84BRJWmygiPR8eiI138zh1ltDI6A1Ja+YD5Lj29fEu8PBy8Pt9ky7YHoS4tOhUs+6Ou1gQa5XKF7cZy24P8cGdS8fRTyGWEOUlSb73U1lZpmlT3qhTw1J+NR5WFKeMDWnDtMPl4k2eiKaDq3XKckpigeujqIt0E0XjE/7dVYDHmM0Mng23PGWAQTRcw8YOoTE2sLtcFvKL98RsrnAxk22m+J+UocZrWWUTX8JAU8aVfV04nj6CGXp7ddZ79wguGgiEqc4m70LNUOYKrVV9DX0GCMV4VhnbZH1RP5veTqy9LMrkenncufp/jU7OfSXMyrRmv909C3n3Isby/BWTWYHObNL5v/3ttFLoHDTO2bfWdaG6dRNCOxJJ4KSOJTKJPl6mCxHyot1Z2IgGToyF8CNNzDl8GRBbNNXdG4XKK31fB5hHpTub8aV9qGQP+EkejPwnkCLl7MQ/4TUnCFcQbRqQRHp9LHLZWI/UMAWWtWkCG9yj5LdU7n7oxJrTnU+PIwH9LloizH83O/aQMjdRMjKtfG5nvmR7lwVRTo2s7jHqSK0MJ9O4wSuWnWAqqfNASexJPzvF4xPVKz82e4ESYVYB0cR4Fq40npbyXlUoIXxvz6vEVT6fwaL3KbT4EoWd50Qoi58ndx4Az2EBWP/NOjNiVviWUfEQpOlY8MD5E0mwFmup/ZkN
 iSQE17Vc
 /Til49S3h+fm841/YyeuUWTPxiZogjBhe9HXKtUFLgmq1AOBbT4ewMSlmAYFd3QnyOTSBXKXZ1YVG1Mikzw+w+1sMVDSk+clIa/xx0sS2YvS4vLctwbHar9pMRroO14sWtDHlYNzBkCHA5sKINY6PJbPZeLEL4BzGhh+rQXdZUB2orE/XsviWd9AVWi7ZqMSBpZf8ByXxwVoKT2YFbkmcizIt9frioHMw8lM50djQ8iNFTpAJboLC8kPtbj34LO/yk8fO15sZkTzyRW2BZhBSVaXr5UamOxSjpR8lXd0gozv8loVAumUj3s82bHEiRSgfHRJqwDNObasURLxjgROwwHB2e4CyBTuXFP+xuR+kZZhNqUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nfs_show_devname() allocates a tmemporary buffer __get_free_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/nfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 4cd420b14ce3..8f8a03a68d3d 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -623,7 +623,7 @@ static void show_implementation_id(struct seq_file *m, struct nfs_server *nfss)
 
 int nfs_show_devname(struct seq_file *m, struct dentry *root)
 {
-	char *page = (char *) __get_free_page(GFP_KERNEL);
+	char *page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	char *devname, *dummy;
 	int err = 0;
 	if (!page)
@@ -633,7 +633,7 @@ int nfs_show_devname(struct seq_file *m, struct dentry *root)
 		err = PTR_ERR(devname);
 	else
 		seq_escape(m, devname, " \t\n\\");
-	free_page((unsigned long)page);
+	kfree(page);
 	return err;
 }
 EXPORT_SYMBOL_GPL(nfs_show_devname);

-- 
2.53.0


