Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BCE9CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 04:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB7080115; Tue, 28 Oct 2025 00:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6839F800E4; Tue, 28 Oct 2025 00:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5993180115; Tue, 28 Oct 2025 00:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBC2800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:51:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAFCA12A295
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:51:41 +0000 (UTC)
X-FDA: 84046300002.15.28A469C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4758240004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:51:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=CSwioWHM;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761627100; a=rsa-sha256;
	cv=none;
	b=WBUQaGl3X9aMHZ9q5OpIoef/yRwyrLVFb1hr5P31Ciw6etJA+35zUf6WAGCimEpV/9cwR8
	OrA1dNQqjuRWaOALJHkms7/gIsLNjSo0Cm0gzlReYbj916+M3b3nvqP3KNA5hs24CW/hKw
	boulzm1JzZMsDqBUsNAV7mwutr9jxBw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=CSwioWHM;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761627100;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5R7qQToxQWR7KjWdFkG8Y/hiI30yNcp9738fQOhLf8=;
	b=VdK0hSWf9klSfhg6RtkbpnnwGtxNZlJ5wtGcroxG8y7yt1MdxG2hwIsXgtrAkMv+dk3jNP
	EGJfPftYR8+pDHcjbfRq3pirdF5KzDfCaeHeVlia/UUs1Rsg8aoR1bsButGmbEvoLnbQDw
	kSSp5IpYNVZoRrRNtEvMe0mQM+mlYrc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k5R7qQToxQWR7KjWdFkG8Y/hiI30yNcp9738fQOhLf8=; b=CSwioWHMkAvW6SGjMY+tOVcC4C
	ErTgqhXrVFIbKQzlGEbgvGLZMqg+6Cc0TRH3RWyH0JLRNn8rnL2cUCDwwFJhl6NI8n9ePA3QtG6es
	0Lhr2WRa3V1d/b+pEoyq3hIqMn0bpRQGFN5gwnlGDHq+HGnnQ5wg9iOFz+RaTnbew65HX1egQ6KvE
	n5hAAclm2q93wnuOsT2uQvfV8kX7Vq3oYzFBMNys9gr6d4tw4QXtfyIS124vaLKNWYoH1kYH5pYhg
	xZEiraZ+NVWnVS0EnRiPjVc0uuS7MkBNwlypjYaWIhrO0eOc3vPZ0yHTbVjaFBexxmcU5XmtdG5/w
	WsjvEL1w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eXx-2U0R;
	Tue, 28 Oct 2025 00:46:16 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v2 18/50] convert pstore
Date: Tue, 28 Oct 2025 00:45:37 +0000
Message-ID: <20251028004614.393374-19-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4atyb5pr48ih1od3tau69eha3zunqkp1
X-Rspamd-Queue-Id: 4758240004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761627100-439
X-HE-Meta: U2FsdGVkX1/ljsghFUwlFQD7h9NWJHLCJb5otviCE1pAcRV4bvN4g6l5BXIFzNiDiuLjFwmu70De0FWwzQ5FfUO5PPgBYT7R5L/hlD8OBfzJ+BFiM4DacvrbHi28wb3STO3LZsxc4t9QHWk6Kus/lENY2ErGJznyKg7wbHDGTtlQdZi1ctTGm0NaXFgJHUo7EUjTFCUxYsnVT6xUn9GteKnZDZ1JyROmGvNW+4fgH99xtgLuKOJFgMJpuHZGADJrLpWMXscnsXSmbSibfAZrr2InYVoB5QM9KlkCgcNp4ZwTG8HPGKQ4p8s/Ryxgpmt3xMYY1QBqZdVbzIBzwtEzYUYBe/R9ewzmbp0rfaDMP88UfXpPQ8K1YeR4TRFcT0cHQ6a2zvU0yUd+pMzjKL2uEDA7R6hH7+eILrY4+cEqZD5krIAjpDpLVFV0cm5ewofnlLZ+Huk2b0J2GCjaPSEGc4j3eMwUq6DlPMuvMcTtAbG1c0hoZ3vr282AmXa/1wkjoeb0KNFpJhA8Rmk3uEvN8/LfMAaKQDuO+Eur0UXF0V4Chq3nHlohgEhweGR8x3hQEhmTI4jL/KDvdX27rFDCtsRnU2uF/03TiTuXmSB5AP/PgpCA/5Mr4Omb2nlGYb7rhmp0nkKwe7ZcG4Iwp5MHwCNxb4vatuisPfbXlu9vvFQJGP70M8O8rWgfhlQswu6h47yyPOdpj/EcuWR4KQedqRSkaZtRcl5KkQeIJTkLKiGPFo20fq4Uu2z5Ah8/kkb4lcE8RGvjcYX94M0Q3x4SBzzf3yp8y/4xg6j/5J3bKmDMyrQrQgwHka+vRZZEcb0Jxg614Iw6+ACKvcwZU1lGExcfZ2+4Y7c68PSCg04Gocgjjgyn9v2d9PIv4iZZRARkxq7sGTRpXnyqtgCFw1AVfYILAXQFspJo3cjAdtr1WF5YFgjjLEG93Hsauy44W2m409FAIbw1kdddZytcKVc
 KHxe0OgJ
 /ksxk6J6PqLWNI2MLCYbgblIX6G1j1EWIHsfoguVu3PNSR3rsuz53Qm4ClWj1tVVehiSDJXawIQ3+r07vDRWXXgsua+yoYsM7pIiVsopYWu2zPGagO34xrBP0AbmKxIpaaEdoZ0lSExNTnsOepdjOQT3hGdJeNGGxjJm2Bp+hbVOrLM2Sden22kP4ijMlo31+aTLrrs/1Vb1RmXaJ2xBDLEEsXKP5qxDJ1P98ty8RmX0UPy68mTh60ypa7OGhxwfRO+kbRFWxJRPAhnETM97eQ2CgDbBHDwF+9TS2yCct6mIPZ2py2f25knA1kqg5TZ+TaKO+luutB/8BAiYPgwZk61c8R3Voo2INfaBf9dWIyTmPdwlQhgwE7l66x7wJ57TLuOEn4O3bLndQbhgR+TvWiwKU5CrBv4M8TzT+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object creation by d_alloc_name()+d_add() in pstore_mkfile(), removal -
via normal VFS codepaths (with ->unlink() using simple_unlink()) or
in pstore_put_backend_records() via locked_recursive_removal()

Replace d_add() with d_make_persistent()+dput() - that's what really
happens there.  The reference that goes into record->dentry is valid
only until the unlink (and explicitly cleared by pstore_unlink()).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/pstore/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index b4e55c90f8dc..71deffcc3356 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -373,7 +373,7 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 	if (!dentry)
 		return -ENOMEM;
 
-	private->dentry = dentry;
+	private->dentry = dentry; // borrowed
 	private->record = record;
 	inode->i_size = private->total_size = size;
 	inode->i_private = private;
@@ -382,7 +382,8 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 		inode_set_mtime_to_ts(inode,
 				      inode_set_ctime_to_ts(inode, record->time));
 
-	d_add(dentry, no_free_ptr(inode));
+	d_make_persistent(dentry, no_free_ptr(inode));
+	dput(dentry);
 
 	list_add(&(no_free_ptr(private))->list, &records_list);
 
@@ -465,7 +466,7 @@ static void pstore_kill_sb(struct super_block *sb)
 	guard(mutex)(&pstore_sb_lock);
 	WARN_ON(pstore_sb && pstore_sb != sb);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	pstore_sb = NULL;
 
 	guard(mutex)(&records_list_lock);
-- 
2.47.3


