Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D75CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6958E0010; Tue, 11 Nov 2025 03:41:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE498E0002; Tue, 11 Nov 2025 03:41:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EEA48E0010; Tue, 11 Nov 2025 03:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDE68E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:41:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E259888DA1
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:41:34 +0000 (UTC)
X-FDA: 84097682508.09.07006A5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 46CE91C0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:41:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WXIL7oKW;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762850493; a=rsa-sha256;
	cv=none;
	b=5DXRSU3oHtj9BEdF3GFAFcRLI9nkFBYD85Pb5wDHIp9jTLRoiaUe4z2Ev6C3r/RHxIcbmv
	BnY48jyceEDkOlqDqbqvEtftJJAPuEkOVRHh0EE/SRTpnbnP4BXbmEb5V753bJ4mWDnblV
	ktfqa2V5c7tD0UTyh/ytL/LtW/6dhPw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=WXIL7oKW;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762850493;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IpNAvIvaquRQO1Ji53mf5vyLMZJ4O2UIIE/EO15yw64=;
	b=tPbV2WpQdtt4b0+exK1cN/el+XkAiHsyCwqD//LAqjRkNVD0uY2ucGhZzI98FD8V7caMhD
	rFRDmu+O08Gb46kO3TVDaGXuUK9a+iJWisA6MG8wy31NWk6tBw4Elx5LEn5NuzTteWeU/k
	ZqbdLipQz9mQ4PjU68ic3HTAvRe80MY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IpNAvIvaquRQO1Ji53mf5vyLMZJ4O2UIIE/EO15yw64=; b=WXIL7oKWy9HSEHoMSySZvGsg9C
	HZvXk7ur65/jTDXn6YYUhFwacBQF/Fiuvc10VS9Xsn2QTYNJviwjaUBuekxRtO11Dz6DWxo52FpOW
	xx+ZAWpH5IdaikOJr+SbHm78dNqDE2qZY+DP1N0bGiBMbz3aP11/TIksIad5bfQV5LMa8w658GqFc
	PUj46ECxO6udLrf5JY3DFWh513jOhp89Sb2BW1rFbpnxjAhi2kFDDHVq5N9vbQexaMhN/htdPvnVc
	B0ZK7pnVCrUaDpqBGoNoZ8x2c6t6wD7OjT+9UR9FRgOyeCOzpJ8vK7G4mE4q2vcKe9yJN0K6r6owU
	UJuGjEKg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHj-0000000Bwy6-0yJJ;
	Tue, 11 Nov 2025 06:55:23 +0000
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
Subject: [PATCH v3 12/50] convert smackfs
Date: Tue, 11 Nov 2025 06:54:41 +0000
Message-ID: <20251111065520.2847791-13-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46CE91C0005
X-Stat-Signature: kohjd3op8rcnq7coq3qbtxo3hiccp59y
X-Rspam-User: 
X-HE-Tag: 1762850493-732332
X-HE-Meta: U2FsdGVkX19fOgUXovOgcL1GKBjuTqwnrv5fRJl53axlacwGKOrR7mfgt7gIxkYaTQNVFK+80JCYra0q22h3ygsyRFTD6QGEPl4tBCpCS+qS69FZw4RQ/bZzfEPplWJPErMmziSWAA/Ihs3VHnmX3HDd3wQOfazOJLfWIDn14x2dywF1JNAYdt2T0P2U58gc+dh+80lvBq3kaM6afid0kqx+tsQX6fZ1i6BBBlCggmqRZU/qRIybaxMC+KLUrr6CRZKRygdrF7YEycC1lyTUJDQovxfTNF1SjV2T75YM84EDHl18pojh5G3NaOqSJaA5+2rwR8M2Ywd/2JBKOQz6441Zflq00xDbRfFIBCOlD7I5ZxfKIZTnAEfxBlEfgbIhH1yKnnUt4kZIjbINbHrR5mxs8QcMd4SupnZISJ1qQR7ZlCGFUwDpSl9NRvnzVsrALZB6lUBwTHvL0wiLx78LhZCN5lfPX+UzpjzTNrVhr6NhpuhOiF/55OfC/Nf+VUgP8cWx6dxv4F78tvSFQ3taeX2KlddniQWn5UD+28AKNnRM0E8b/S1UQXnNj2nL6gjkKtYDCN+Do8imEsX6hdNLv3+ho5Nwfs82HpHjADCJWwvHBe5Tw2N5YxYRiKloA3W5P/uhUirXJRG8xDsgHd/MQkbaEGUgoQhtAHOPfWLmRSbDHjhGZzwDX7bQMKJyjR5xqz62MEXb8e08yjsxU766sIZtLBPRfUWuciXxstQzwLv1Qq1DCPfAfTcx/rsV3cNiNq1b4dYW1oNs69w9QH53I3+JSdge/DypihPx+BTKXEgqQUWYurRQR2E/Fc0jUwjM3zDRl4mZxWFrrhAvXiWjvulg2ZgiYVZTvkPVbfsNwEEDhhvrq4F4Jia2S/kidN+kGoFLewOCANwOc1cVeZ5ykyoJQPk0rp3lisui51hlsJ3FreOQME81qpOxMq7uJVEvlEJ3pjsht0/XNeIClgx
 wwXr+cIp
 UcdTv4tPfoZSnr/p9IU4W6UxeLCtTOTFUD+haxwNMuScc5Lrdw0sjP0Y9AINVkiGyHFRZAOcoK6jELseql9yo9P9c1lY861hGjNGTx8RuYZWUuEo6M2k4nzgv+romEBWzs6k4di7WGXJad6Ph+Q0N09+Rj0s77+cEGRHQ43kglUcpQSEsXCKnvdODoC/buLHyrayEtR3UJvTzTLaur5T1k4jcl20h7HvCUC0HRdutYYdFPu7tJA9tMqpac59URJkXzIhSQnHWVuCf2hVs0kb49XSQbnHb+Q7R3lPnAO6RLEPiNVSFOY9o+KFcfk4aUw4mU90WUnpQDHBlXS2aOMsZd4+Ke04DEn0FE8iMJwGD0vIkGJ6wVMW0+YFkxVtIGR1kLxcRauCXspPjtONhrMVsecn4g1cXmIz6sH2XdYjFkM3r82GECxjYcGXUwu+drJ4zajlpc1NrMo+menz75STqHee9Nw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Entirely static tree populated by simple_fill_super().  Can use
kill_anon_super() as-is.

Acked-by: Casey Schaufler <casey@schaufler-ca.com>
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


