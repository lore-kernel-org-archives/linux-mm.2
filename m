Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96EBCCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E152180106; Mon, 27 Oct 2025 23:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC57E800E4; Mon, 27 Oct 2025 23:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D6280106; Mon, 27 Oct 2025 23:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2DE3800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:31:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F2ED12A62F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:31:35 +0000 (UTC)
X-FDA: 84046098150.30.107F11B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id AF1F840005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:31:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=cWKXwiJR;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761622293; a=rsa-sha256;
	cv=none;
	b=Cze4RXhYeKLxpUFoi8YiDGbpqh58/04dasNPwWjnusrCm01DEqYzxNbPmoIuQ4WxnCm6wx
	XmqLem02hD59AoluqyU251FVlTrSRG4DOC3YWGTRHT5/ZqkqtXNCT+m4rQBw3gyGvPmH74
	xl8wJRebZRpx9RWNmbqWzAPAPaX9G6Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=cWKXwiJR;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf01.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761622293;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoHAGF5loUqH0LAFPRC8F4kXyPuIEz0vDtopK5rWb5o=;
	b=la8P/gH3VMBqf0UuOJcsv1+j9VpKIlXT6xF6cR/252jtTVpiH/dWUJ7gcvHD5KYMlKG9Is
	Af4eF/8OyZSUUQVlmAhkIOfGJpCC5VrUdLqaUQFwWwhjJWxRj8F7KWPWjLCO+jWzNTF6u3
	N188rgmf1HsZ/ckxHZQq2fQg5pdDFz8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eoHAGF5loUqH0LAFPRC8F4kXyPuIEz0vDtopK5rWb5o=; b=cWKXwiJRgmyUaWc4btZ5WzGz3e
	P1d4pU2PnDGwHyXYYC3Sgwm/WPpNg6KTwV5sROPVde7FceyNHhhUc0N4X81SxgJMRZaYvSs5qCoF/
	0usQSfZLUxv2nUlR2Jfp5JWmBh+5fu1PIOG0mXjNiaHsbpZuvnuCBQsXL9AKNKoUcXX02D2qMvWqk
	qnAOvMK+sofvaE+oth2FQB23/OCTjk4qP5LStexB4zj8DV7NnUUQGzcMZAJfRFTfyrPeKSt6B6Q3u
	q06p5RvGSDJEqongOiLQqYlkX46ecZiHjCeRWGwudoHTsnkOUbcR71MM5KOW07SuplgdFJG4EF3Ct
	Kh0HmJcQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eZ5-2N4G;
	Tue, 28 Oct 2025 00:46:17 +0000
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
Subject: [PATCH v2 28/50] binderfs_binder_ctl_create(): kill a bogus check
Date: Tue, 28 Oct 2025 00:45:47 +0000
Message-ID: <20251028004614.393374-29-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF1F840005
X-Stat-Signature: 6nbxihi5gwy6jgcrkybu4654y9cgm7b6
X-HE-Tag: 1761622293-908687
X-HE-Meta: U2FsdGVkX1/9cyvqURQoWOKoZPzJ5NJcc4aEANpNPAQ8SM+k9pUPGR4ysqoRs+UbdBtApM3QVP66ss9mcZCg6kz3y7eJVTfSVhikKU6Hxv1K7+ZsAtVLbicff/J8Nk85VONWRB5ILHwGr9BZiEgV0e5n9LzWIdoWs1G7W0fs1tVOEU2pyRWbUlBWGd2aot5ybGfKO9DPy+ixpR5KXsyeKQfqWI43TD9ZVTjipCtmAiCLfNlCDW3SQ0vHrPkHFB20mMo8/ZPwiNlAj2all0vaWvLPRSGZ1RtvIHqNV2z3HM/kvD/1Yf+k2XjOXdmfl2twBOuzZIEw9zQQ0jLMSykN00CaEQVDzYHam8aRAmp/KTZawPTBA9oTphkOeW3/X1FpgKerdspltwd+HlCdNUWKB4GGJsEil8q3/CG2soAUPx5lmpAUdbZA5MGKUfziRxNeTgOVot+6XPxlEocghDUH1L4Xu8SuDZGjs/uLRZoFFEPDKG0vcYxHqozJmoYbm+xCxEd4DGhOaTZ10QqFNGqlP7OOzBS3ITaKJKJ+KZKVFLfmNm+ERuFO5Z+yViHPZJrqaC37VbuzTqIIlFxRrEJ3ARu5hWoC/m2NbBqR/Lv5pK6DimIiQxdJ/Ii07r7S4NZtuHo7H16Yjjym8QJ82q0RNWwk2DGgioUC4NkvCboYMSWRpms1J8ylzei5faY/048EqOgOJmqWk10mhlV+Fo2D4E1zLmsJ5aGph6EsTu/la2qEs7+qmvz+bI5WQugspA/SO1TZV2D9XHSe2yiD9kVAFQBtwJcE0WxrdXedcGMCksJQdmd+Ib+ltAl6rGlYGouPVr3x0qjswajzX+DCWychDnBWaNv/7ptCOwEh7Mry2bFdl+TCCZkg15GA+JzvsjuDEcwPAxKs75mByGLmc95qRp2pszmO8Ir0mn9fgTvGTBNAXXlFGQgN1Dbm+HfaOxCnh+hYf83hYeozyp3Jd06
 AZA3Bsr1
 r5o86XzxIDEt0JbIcGcKVZG/WaVj00OKrMOkiU2NCOojlRhI7rx1eXISFZObnzmm53lq5cvuSryEMWa8dCLYpacdI2OEtxfDGzQjsDvB0WyaOmxVqmJlh54hrzzBQFetOlgps632MHJiTJ9MU2NvVNh4pYaJVRXeSpVUI3kJfsBy/gMkWaIixl6+LfsPxQZD6e/UhUcAUkrHC5dOOlVh4sJtIfB1CIR3qHG4aqnMD5Nj7lvzRt8dfNPax0of0OXpNTIbzHEaF19U8xKSuIUvtspJHcuV6vjozj1G7CDEX0WVqP8wC5F/ALhreN+NeEno+pYOSBdZn9qAn747Pia6hpdwLcxtPZvRuXRCXw51s8ohzdTjrMZAS2AriKWLITWvV9u5BOLZsGh62431TwIsVu4ZXlQzboVlYc3KDN5MthjvGlZ4b685T2uY7Rn0O9+NtwnZH/ayKsZfvgVVza92jmF2JeizfW0u7Hhvtpof0MBIhCS0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's called once, during binderfs mount, right after allocating
root dentry.  Checking that it hadn't been already called is
only obfuscating things.

Looks like that bogosity had been copied from devpts...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/android/binderfs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index a7b0a773d47f..8253e517ab6c 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -397,12 +397,6 @@ static int binderfs_binder_ctl_create(struct super_block *sb)
 	if (!device)
 		return -ENOMEM;
 
-	/* If we have already created a binder-control node, return. */
-	if (info->control_dentry) {
-		ret = 0;
-		goto out;
-	}
-
 	ret = -ENOMEM;
 	inode = new_inode(sb);
 	if (!inode)
-- 
2.47.3


