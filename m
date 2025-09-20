Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E68DCAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCCD8E0011; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B468E0018; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF4F8E0007; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1968E0011
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4505013BEEC
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
X-FDA: 83908850256.18.71E02B2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id A16CA100009
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gOsZ11R9;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7zac5CXxUxkb7q5ONcJstI1n7DJUlke+AKINjwUKhw=;
	b=SxOtjTalfLzsAfbZAujZ5PN1E78j0kml7aWPTLTS2ihw8VOjk428qWT/Gyi4ySLavj/MbM
	IBpwf3jEIT3QlhOpg4SKr8g8nfV8JHI51L3XyLsv4WGQrb2aUTL0YWIbyTRo0Qzc09gJUX
	JJc7l1aRWOOY+7ebULVmAjnG9I5TX14=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gOsZ11R9;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=AGzBfqqOaKqjHUWIJMtzNf4lYlunhMR4quceDke9m7w6yofttBPOVu9zPkbH5tvfGwoAcR
	4xeO2jojg006XPw/TY6n6neCNggTeIqukGtIdm0eLk94I4PBqea9QX4fPUqle6vi53t6A5
	xPAlHdFA2co2937Km/zMF4v2r996SFk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=h7zac5CXxUxkb7q5ONcJstI1n7DJUlke+AKINjwUKhw=; b=gOsZ11R95Mc6khqYieAvGNI546
	t4Q3F2LQ7usNltEcKyWm/9q4pggxTthiwjrBd5D4D6ge/9g4pAacGuMO+LGMFkuKgNcAetY1uRIjn
	1qm8refseK5xgcF0CtotO59paOWWy2bEc6aCmUneBZZJ2yDM3AirMhLl3Fuz4pwnJS4EJnLbHoDJs
	7ZfBeVXB9yoK+zD+iEbTR75Eao9+iKvcSvcdLCPmoLcgSC1KsAv1kl7D2ExJ2MaIaiLRuPw1Ivapi
	0y0XdSclxK2XOFjXsEvYABaBSFZ/vhA541uq1Fso7uSMCuhN5Du2vVdFUz8AQy/207j12dYYopi5y
	SapVXyqA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK9-0000000ExCp-1Qie;
	Sat, 20 Sep 2025 07:48:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 10/39] convert smackfs
Date: Sat, 20 Sep 2025 08:47:29 +0100
Message-ID: <20250920074759.3564072-10-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9hais8ner68xfqwamnpnxwgru4gj6w6x
X-Rspam-User: 
X-Rspamd-Queue-Id: A16CA100009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758354486-785841
X-HE-Meta: U2FsdGVkX1+E9HIVShMKV+UiKdTnESiXcIHlw8myl5HaGCXZwwe7LiX7RQY/uMjHr1s/pW0sJw4W80My4ODmB7CX7iiut8LlmdyMqrI6oCfOGs0Q1M4fvc5jHZFfA1wP5r60jC+klMWtCpvJ88IsOILiRkvbFabGew67fJDMC+bzdoGOV/Xjj9HnkPORHNHGhJacs4eYG3Uzd7uMTWbDPFa+NMsaF2QtXp0mFtcUVcn+finqWIoPUaXkemCXA47Y3xlYLJ7NsvFFJaMXtsobeO63G+UjxeVTehG57GPNfq0OQ4JpmGqnS0aOGRvysmfdVZUgSgw3j/TJCFocfJPDoJ8iy2yfPg1ARLD4+yvwt38HjcFI4+MLI85g9XB6M9KrPSfb/6ThDKd506/GnLr+oN5N6sOBvKHHH9x+YLPALvNPV/7kgKkpUFpvrBiCV3VMyoPjslBBgAzBa0BlQwc4xJn3DCGi5eAgxQIhFmKHerVRP0lmeXOpnkJggxnBgCr+IAQsR/0AbFvmtwpKYs2hFSzF5UTGSgN8K/VFprkwRDeJ9078dccU7xe2uaspQ8F+pkiGiYPUJ75cjUOe1ApRASmPsBUTER0AzGZ4KdGaFFsUxIWwym8DpMJ5FdLbQIQR+8PJM3AXB4OK/+mO2xVYHaXGODbtc+5W86qgD8chnjsBpW29jGAX1iOMZlQgzuw18+14G6Gneh+uELwXANB31sLx16bpRZ61eimdc2flf58cDY9OPkQCyWPP7smKP9CTjvdNNSUyf6eUtTBaqzMZl2K7drNbxPQro/dnV2nd8kY3BMa82tiYwocySkOydPE0NJ92xt72+5AHXdDYi38JJ4ZEBWgD+cInaEOUnWnwMMZZRhPAPLavtDuo6ARpffQDV/GIAjkHJ9gEtKekX2XDswRDFDkcPfDsIWaupAbmTYubftt8jMJYzEAVfxEsaZLRO2KPgrazZXr5RTyq9f6
 d07kcx5S
 k+ZGLWgWkUrpObEMM19CgeM88ErH+fi6Em+CNmcHpzYoAhKfXpZjcdUJdtp5yHoatks9c7vA0ILHHkNJ0lGs/qbNTctKWuhwuCKmzX6fJTlkfUCAfY7gcJgEEJZqNnPh94lIJuuv8V0zv5Tl+hnqPGzJouFcghajsO2mD/h9H9WDGK0YrzZfgW+9zsTrRkCcexsizwaPKJpXQs6nK6v9ZIPOKisPkzFDBMSE4v5sIWvBR+MNAdYRvcPqRhTrMBzytEoG716vQaXZ34RJuGgk5WHzNZBsQrSRcqRndAlSwb5Lf0oRfpIcqgNRcViFKfpXXeie8YUHAccYK34KIdG3CdDqK81sC8Tg6Fh2VjFTJRp3f0vzbWovhAtk9/E22uxl8Y3hrDHtyDVh9WsSeLw5L+8H1ZvftCqcx8woJLyRnktdiFVFVzK/5P+AKtFk+P1XkvbE4cddqYr35K3bTpCyzB8dMEO3Xzzps0L6m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Entirely static tree populated by simple_fill_super().  Can use
kill_anon_super() as-is.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/smack/smackfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index b1e5e62f5cbd..e989ae3890c7 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2960,7 +2960,7 @@ static int smk_init_fs_context(struct fs_context *fc)
 static struct file_system_type smk_fs_type = {
 	.name		= "smackfs",
 	.init_fs_context = smk_init_fs_context,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 };
 
 static struct vfsmount *smackfs_mount;
-- 
2.47.3


