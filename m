Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336ECCED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4B38E0021; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6732A8E0029; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7A48E0038; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 385CC8E002B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA76012E897
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.22.F706D7C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id E94521A0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="FE7OJf/U";
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IpNAvIvaquRQO1Ji53mf5vyLMZJ4O2UIIE/EO15yw64=;
	b=f2/bqSysS805Z0dc97zZy6MhJ896wOmPDyGJ2v7UHBqMf4GZvxC0i52/4oMprELUq4CNLa
	q6cxmwce0pitFaZN5PDvhziStb0inS7EfKzWmhDKC9t6IeZ/CbOdel1r6Lk2tV3DvL7kqN
	iUGi9yty2qUvurua+zObM8y9OyvDh6s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="FE7OJf/U";
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=afTau+H4elOP+TUz67uBRiIc80gOXFYdEhik+SPPpLD2qn621V9XAZl5Gt2JX0Fq/8tfCb
	WW8OpCOpdftL5UHqLBxK5TM7MNvIHVDku53SPm0foGa1U2z4B504aJOpcPMvBhAu74ysUk
	OpI/HJmBMxk+/X5uqogpXj2NK+0x2Z8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IpNAvIvaquRQO1Ji53mf5vyLMZJ4O2UIIE/EO15yw64=; b=FE7OJf/UU+lFlMVRVRToGhRAzP
	N8qGXHCOjkSsJDHwHKHBs4K6aMWob5Nbszex9l+s6ZK7OfCYvZ+9TG8qyL4a56MGLrMSV9WS+QFaH
	s1N/VE1lLOH2Yk6U5H6G2Poh2PqGUWSQ3NEN0RCixCbVN/RP60yPNMYvhHIPBExVfx/5/OZTzs1EE
	bhLcn7ls1cB8YCrarexnMvFo0q+gbwMu1mw9xNZu/jFbTij+eRpShRImoLn13GuhwUkVAFtVXI+yz
	d1EdjG7xvDxR5x71JxFMIMLgaP4kB7U4RmZn17NAJrLLzst9bGtt1ub4xZUECV8by7OLH3v8P7leP
	M9vSGWsg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GEQo-1hsg;
	Tue, 18 Nov 2025 05:16:06 +0000
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
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 12/54] convert smackfs
Date: Tue, 18 Nov 2025 05:15:21 +0000
Message-ID: <20251118051604.3868588-13-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E94521A0005
X-Stat-Signature: u8ok365kspaipsyxtoh315h9xzynpbzc
X-Rspam-User: 
X-HE-Tag: 1763442973-724525
X-HE-Meta: U2FsdGVkX1/EW95Wiv59Btx0QC+SlsrYrevf2NCS+6Tg53AfBUC12S2kxEDChvkADhwyk/6fplXa8W8ldcXne185Lcl0T/sofJvgWIRG7SL4wWwo4G1WjgUIHKaRLKmlC/W/hXH/JlmRtB/Gwz0er/yNY0w0Szr9E6i160WqniZXRrfBetxperugYcvFu9Et71Qz8OHf1cKpr30aeiP9eKJwW+Kztnkz2aEVd87iJJvQtjMhVqL0I7fZjM+70a7enqIBiBTdiw3GAbfzSF1NJ2/kTPKDvoGoMA5gLexEqNDP1AqtGWLRXDjWYl6gke+oGIY7jCx4uuZoZU+nfIZxM/L1SwhqcbFIAeN2/N8cP2aSts1pjMW+sdiMayvPLvjgGz7+EuzrRZkytUcNuFBlhU+p8Nz++PIPUpQlEDLRDW1k/H/a78GbLQs574TKJnghk3YtL1rLWMjo6TDDr6d12dR64jnD4uMW6CMcyvHgsFYAfAnaZv7CIL190EnO1ye4+r6nrQ1DC9zs1Dw9GPWP3qOk4FrSFmd8agR9IeBkMf10NicAj6Q/sLtp0TYCjFBuPB7LsjwXYSDC1DstpmO0ryacKznDVBK97sdP1eMKdxBwiSBaSEC4otw4HQt5eyHFpyzgagaHpscbO3MESr//lHt+d9a9yqyuoO/aXpzF9sBG36pfbeTNEjKxhrz7lUZRhm9sIyEVxJwfHjG5j7iTxDoPNS6vZU5vF37N2Twh9tcyEGfSPQ9AL/790+NTyAAWiX3btVZpr0ColJQkOqQdXqBtJzPAjO4w7Z1Iiu4O1N/6+uAESOsWHptCLn+1mtRxTTAPMWOvmzFC8hfRlvxuOQkkrVj9AuD9YiTdezzyQqrwJIGltVjJNNazxnMX3JDLYRgidXLk0ch1kTvCG9aFn4aS4E9fYd2skoU1TCchZ0hRr3hxCoB5ZxwtZJGCYVg/gewyGeHI8Dq3S2uXaOg
 GCDz2siv
 j9w1ihGC9bH8oLIcXfERCM252rxnWxtUBAcBm4n9cWYaYfN+tciQwo4LfjDrGmkggCmtI5rVk9UeF8CTf6hSEAKODgGGhY0D0nCOCNN7LFBkfje7jNaV0oicoMwUoKynT4lbRpP/iLCVaacNtoJFWSy8vTnfugtt6O+b4F7XV6pPgrRkABMflqsGS63Xq/S/687xGchxUlwYNQi9kc6HDH3kuI5rgQOIhAceO/xvsDUN99ZBxj5o9Ua2090XEFujHjAZBmIij3i7w+JaNj3xvofjdVhpGNwY+K+/tGTHOoyRl828DJNPWkAZUyUYqjf2CR7dHjItbAlVxR2EosNZ6PFK2AB1VO6gez2FQ9eAsM3hnDDi+sUZRBxDx7mYLJgDCBrDlBy3HsvSALpT/VGdRfp6ELw+MrkUhmqQPCsIpenjE9ebdTuH/UUntdjJFuPUu+ET6WFqFgHFnjmwYPnjRCmwxiCE1q+X1La5HxQkXc7XOzi+g2t3es8JcBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
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


