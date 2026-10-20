Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D42606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 03:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=qteqodOj;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6EitxnqZ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=qteqodOj;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=6EitxnqZ
Received: by kanga.kvack.org (Postfix)
	id 841546B03FF; Mon, 19 Oct 2026 23:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818FD6B0400; Mon, 19 Oct 2026 23:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755DD6B0401; Mon, 19 Oct 2026 23:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 503D96B03FF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:59:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF8E114081F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:59:28 +0000 (UTC)
X-FDA: 85341650016.17.240F348
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id D56C520002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:59:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qteqodOj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6EitxnqZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qteqodOj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6EitxnqZ;
	spf=pass (imf03.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792468767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0ObW9Yx+qWLsXjEDMVy3psMDuJaghQZedLXpxrcvDdE=;
	b=Mx+GcYHMZ7SVPrh6rlKCw2vGQlDfYT3FHe2aKrEgUXMTFn6BCEgLuVrNbF7COGK2sWqoH9
	PzklaVplVF94M2wuKwcRaJ/8kE1AMoONDX8RbjvyVgj6n8oAYV7fp7gJSHErbA3YS8rdHN
	lYQ2ODHCwjIYG92VGQdCAHU9iB1kHIw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792468767;
	b=chTYEcO6F2ULn+ux3ecArBGra82f5Gfuwkx//03cuZ4Tj+rIuHryO1haJtYDsTADoXHG3P
	GnC5Bagui0AxmQfR013phLicJD4WM6S8PNctJmODBspiuOywV1FN6674lVZlCqE3r5v/YB
	8j8XBY0Mb8yNAB0IR6Vx6hgJwHpjIO4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qteqodOj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6EitxnqZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qteqodOj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6EitxnqZ;
	spf=pass (imf03.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5625421CEF;
	Tue, 20 Oct 2026 03:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792468765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0ObW9Yx+qWLsXjEDMVy3psMDuJaghQZedLXpxrcvDdE=;
	b=qteqodOjmb4uBfz4wVBRgYiDnr/AP+iniiuwx+ZjfyH2QX0zVWGiJ8u1e+NT5G5WMLyEef
	hb1OblVOp/XSJWk3/3UtjMnIN3JsQpo/koFZ2j0C9PJxw0VUkKqtoWbObdlDh0JmnC3men
	zZs9ef3w1kPDpiiBncwEPSrDM5Lj4jU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792468765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0ObW9Yx+qWLsXjEDMVy3psMDuJaghQZedLXpxrcvDdE=;
	b=6EitxnqZGz5hkjMnCcByZDT01Gju6mCWQ/gPspXiAenH6Bk2bGJ2sEnLaLpuz4ydid24aC
	70wQxGFQpOcXpnCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792468765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0ObW9Yx+qWLsXjEDMVy3psMDuJaghQZedLXpxrcvDdE=;
	b=qteqodOjmb4uBfz4wVBRgYiDnr/AP+iniiuwx+ZjfyH2QX0zVWGiJ8u1e+NT5G5WMLyEef
	hb1OblVOp/XSJWk3/3UtjMnIN3JsQpo/koFZ2j0C9PJxw0VUkKqtoWbObdlDh0JmnC3men
	zZs9ef3w1kPDpiiBncwEPSrDM5Lj4jU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792468765;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0ObW9Yx+qWLsXjEDMVy3psMDuJaghQZedLXpxrcvDdE=;
	b=6EitxnqZGz5hkjMnCcByZDT01Gju6mCWQ/gPspXiAenH6Bk2bGJ2sEnLaLpuz4ydid24aC
	70wQxGFQpOcXpnCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEA04136C6;
	Tue, 20 Oct 2026 03:59:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4gBjKBzn1moHKQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 20 Oct 2026 03:59:24 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>
Subject: [PATCH] shmem: Report casefold setting in mount options
Date: Mon, 19 Oct 2026 23:59:17 -0400
Message-ID: <20261020035917.693478-1-krisman@suse.de>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.30
X-Spam-Level: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D56C520002
X-Stat-Signature: 3oncq39niqk8z4phhe7zd4bs6jns41bx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792468766-815947
X-HE-Meta: U2FsdGVkX19C048IKlv0aJfrGoauLuqM88/e4yAcYcFDR3Z1AC7Vxnug2M+jBZgY0bzcE3emEhWDgKmlV23StHWZtMElgtMahRNRTMjSWK7QT/xk6UHLGnqgULUbsVQbhSVajkk0FjSGts5Tm4wqmhbnTuisoIyjjUbJ8DnQeKVuz+WOpYsf0LZ9MAo8O0nhISEERmxjzdUtvhu9h+LXHTgXGWiQ5OCy+R5jbc6U5SJx2m9qH6NuSQJb6W84sggTD8XNpGAZw7+p5TI4nmJMK5VA2IRkKEASuuGTz6j95Z22K9FElDzJsPi95ddwqepwbXIFwaV9LXRssmRE+mhplhWYPp32TU1iZ21ONHwYUjBAbiNDsbOd5P1xMLNK7lKpX3/aWlFmTKo98s/UCpPt1BcxklbBV3rcyh+jDLzT3liUtIg8i2JQxv923UiaA+U+g/ATgOPo1kFNOcpDQsdPnDgyzXSmRYBMSDhUYs86BALTTUFurfS21bELn+L6n27LIG3hDwvMCPLqZ/2jX/6ViTfvWR2i2iJ09ShrrqATJzIgoJV8YFx8bhK+CFFeKBsR+zWjOJq/3EdqD82P7hzhjgGezR4iXdIxwQQPgh/z6pr7nPcAYzQ6WdbyB29Eyss4dyKoVNGajRGFFU7y/q+J/mqnDphyySGIO+xzYf/WTGmgvNhhNsrVBgw2/ID/LAw9k+rHNheag0sXndcZE8ufHeEB8UDrjWBsblNFGi0nIUqecCWQTIcfsKg1zsxhqVJDJNRhaAbrPcKV6LqmuDAPCVpbj4YgQsL2uSMduNoNvOl86XolAsWVel6Wz7G/oqGM/koSR2uey7w69sV5ooouaKcWokivcm+fTdGpiaRcCN0AzN74LTDdgGwGYysLGzaVk/uYK8OsIMvGdXoKwZN2+NDVy2LFrtAsgHNqNnZnfSJIi9qdlj/e1fjLnNUfNg+wCPrxDfg+/MHK5aGAYho
 gqvOtDKg
 Bu5vVku+pEHz2sNsq1xQc83ajsg5H2II9Su11RbnbknjJvXkdl8F938ngFNBe2HIzhVc/8NjNl6vJmDkPHqmHl0br0qMHvqyS4XXNUMy9qabhzRkXUVcprwsKIyoXEtiy488hczbOEdQGkuvh9VJqdGsFHjA2w2avI/Sk7AcJoNrxwrSbD5//Z98eCgW8RJ4z0yLllAGhwfJNJhr0Ezw1+5FiEjwuX0IATmGd2nujewDff9epHVIJ3cXX5/GCKJB3lLa1mp+agx+A3h9GiEfC6/No8pQfSON62nJcWAQ8S55Xm/mF+wSdCpSPPM2B87K8rtU4ue+TUOpisrvuDP8hdsMjwbv8avellq0oXf/LcRqG+bXKyA3iL/DOo7bcOtLjV/b7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

For shmem, casefolding is a mount option.  Report the current encoding
and casefolding flags in /proc/mounts, so userspace can easily check if
casefolding is supported withour relying on parsing dmesg or trying to
set +F.

Reported-by: Daniel Tang <danielzgtg.opensource@gmail.com>
Link: https://lore.kernel.org/linux-fsdevel/5193732.31r3eYUQgx@daniel-desktop3/#R
Tested-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 mm/shmem.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 848316eaa7f4..bf3b19ed2e44 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4919,6 +4919,17 @@ static int shmem_show_options(struct seq_file *seq, struct dentry *root)
 	if (sbinfo->qlimits.grpquota_ihardlimit)
 		seq_printf(seq, ",grpquota_inode_hardlimit=%lld",
 			   sbinfo->qlimits.grpquota_ihardlimit);
+#endif
+#if IS_ENABLED(CONFIG_UNICODE)
+	if (root->d_sb->s_encoding) {
+		unsigned int version = root->d_sb->s_encoding->version;
+
+		seq_printf(seq, ",casefold=utf8-%u.%u.%u",
+			   unicode_major(version), unicode_minor(version),
+			   unicode_rev(version));
+		if (sb_has_strict_encoding(root->d_sb))
+			seq_puts(seq, ",strict_encoding");
+	}
 #endif
 	return 0;
 }
-- 
2.56.0


