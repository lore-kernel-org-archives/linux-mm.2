Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B7FCED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB5F38E002D; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9D38E0025; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1926E8E0030; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE458E001D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D99C4B8B46
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.15.3B7B2D4
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1749580012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PWlONFNy;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcN8NR1+0HBkSxpdczEOcHVMqeHaVs643Azz1G5uvoU=;
	b=SWtu38kPaLjqha0l9lyvbNmVt49D2tq9KUiemI/jLSAIGck3i9+P3KWH3vVHu/xRYSv9IW
	p5SsH7pvFqF5LIN3zP4gNKzX1vjOgWW9W8vi3dcGwE7r1grEkngjN4pYxlwwVSmRjpQIhz
	XK6Ntru2oLh88pTJkgZUPaIarmLU/HI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PWlONFNy;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=vS6uresheIW3NryApcQAbncmN9UWoyfFv6uNl9iNEUHUuGvnhqBs4S9436iINBZXPRyjt+
	U9CiSZXnPAXMCECYvDG/41GXyz0YYS61EfSspKgrRM1kct812YGRHyMs48pKqUsU1AzLBg
	gvuZMPckWFKZffcyKszyMgCFSvpDjiE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wcN8NR1+0HBkSxpdczEOcHVMqeHaVs643Azz1G5uvoU=; b=PWlONFNyoKBcmxnExIHuQJvYp8
	TEMw4UKqXhsSfIVdQw7lDrpMzeDHAJNWkUJxTq2dniWflhvrAve3vDzIR89pzgL+HEKwVlt2nMRaZ
	Aaf2PCjJ9VZGYnbPrtD8oBYxGGmbj/FvYjG+vacHCV2/DLKn1Kaw9YziQhUbDiXgPp4dbWdj0MUPz
	SVUlpKuPvWL08gT6Qsnpquhdois8gnPqPbF+zpT6LDG104DvxlN5f8Vrz1oWdbyqK5BNUl7a6R0Q/
	xDcMD9HwmtejhbrnYEk1Oe/FlRX09ocCwKUQs4o02cFQdyQaWQccDj/m0nMHApj8YEbGyCVK8knGm
	Oz0vkyhw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4X-0000000GETL-0M8a;
	Tue, 18 Nov 2025 05:16:09 +0000
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
Subject: [PATCH v4 37/54] functionfs: don't bother with ffs->ref in ffs_data_{opened,closed}()
Date: Tue, 18 Nov 2025 05:15:46 +0000
Message-ID: <20251118051604.3868588-38-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1749580012
X-Stat-Signature: ne3rc4786nsfe8kcx5sf4fqtm5919d9k
X-Rspam-User: 
X-HE-Tag: 1763442973-263488
X-HE-Meta: U2FsdGVkX19Eyj8jLDa6ZJyO8/Tzr90FLjrMeRO24sQRAHWfCFvxrcyholIc5hJxNXlhQLLTi+v/lV8Plw3cWN5WCWChp3uDHt5ee1ZS0znEsd0GuFcrOhmS6Jj5Hux+tuJsHfkQjosMvP1Td0g0J3ULAzKo0PQy+NftLzVErNn97C+N0TfXty2hydUGvN6rSyM+wCS7CmebcxuFBlgm2/2+1nv561v1p/k5hgOt0WhLaqS9pVqQ9jhpX7T8XHIMY5gY9bVdZkIWQzxgKdfc95mcQvz9yCkAAS05lmxDeAP6VMt0qK2zbP1pVRcvG3TN84cq/b1y/xXMms0szPTlIfrhQsT1a30T1b3xEyfpVQ1XUTu8zitlQitx6SpJ0jcQCa+X6GQ0qFM/SF28Brpj4A5OmMdFd/NQO6OWyTR1z/bIn9CYu8swc8hagwoWnihMc7AeEsR/wYv399LRC6L2wdDN1tNbvpDfOhROQyGn5Oi+ZYuJXV4+McvOyvtJ8ZXmR7UgJFEb9QTy7JrZ5pHc3YEJKULv42aDdQGqAdmD/3NpcYt+09NOdnxQUD+vzTsy+IgxbHEFVhjWSyQ0Tb/NuBuHtPPAbtvQpv3GACeTJ5ADkGiTsqpuL/8BTBVbtmtEvr0q/Zo6dI3NFk0KyLOkE3vfD2s2Gl+07TnaRp6VIANRZWwEZChHWu6D4A4KVQcfLP8UAqDx1epZw1FhSkUCa/AlJa/3l8X5WfYIVTRVWMpNt7DRq8oQeV34/YEHvN2UVNgI9t7AazWja+nRomNFcrTDqFxk2DQD0TWwNrzS6jhjMnxvBibo+4mNY5WkdJVR1eganiy935sbW/tJ0WVT7DaCzoYvC3OTvo18DrdmSgSKQIUEP5IBpU9vGCfu/11PUD62ggoF3bWon+9DwHrp1K8Jzc4uS7WKPHqMydyVMccKdBy5UQy66UWe+67gF0ZR7aAIMjrYORzldefCBqN
 MbZAJURF
 BY0cjUYi1XxmzL0BCdOErxGlz6v4S+0+URRdP9JVaz9A6+KXwqCQ9bH49cihSOMv6spkDSM4erUqaiTlAStdHPqHPmUivTvNbtIj45m5eA3G5vdfDs5RmVaCiBZ8/RIyggyqi2LCgauNqfbFMdA1uftntsMfizXVz2ncRbCGvyKh31cwJGQkqYfVeOFNt7jFgqBjHZx0F8nichMjCkaqqhfLm9JQa20PQH8La2cHl0bmXA+qbapAekrz98XsWK82oSfwFyewBEcMvMhgVHlIyl9RtNPhazf2mZCuLVfAYoi7bKgVyfeRuqmJDHyoR8GqPd5re0CYz6nmfSvalr8qPrmpJIHclPkta9E5GrZjNl2KDuKhF7bgPt7KgniyUGu4UTqs2jAahxGhpY0zycJ98eV+Ctk+3iqbz7eV7AN3KsPcXk3vEV2Y7hEUc9CL09X1SFW0OQANS0g7VT1EkuOuXKu23IqfapcZFSSbe69+adLyeAIyITfXODnZTciuseP+qeLd5RZbgv4bzV4DpEjqm4nv/JA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A reference is held by the superblock (it's dropped in ffs_kill_sb())
and filesystem will not get to ->kill_sb() while there are any opened
files, TYVM...

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 43926aca8a40..0bcff49e1f11 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2128,7 +2128,6 @@ static void ffs_data_get(struct ffs_data *ffs)
 
 static void ffs_data_opened(struct ffs_data *ffs)
 {
-	refcount_inc(&ffs->ref);
 	if (atomic_add_return(1, &ffs->opened) == 1 &&
 			ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
@@ -2153,11 +2152,11 @@ static void ffs_data_put(struct ffs_data *ffs)
 
 static void ffs_data_closed(struct ffs_data *ffs)
 {
-	struct ffs_epfile *epfiles;
-	unsigned long flags;
-
 	if (atomic_dec_and_test(&ffs->opened)) {
 		if (ffs->no_disconnect) {
+			struct ffs_epfile *epfiles;
+			unsigned long flags;
+
 			ffs->state = FFS_DEACTIVATED;
 			spin_lock_irqsave(&ffs->eps_lock, flags);
 			epfiles = ffs->epfiles;
@@ -2176,7 +2175,6 @@ static void ffs_data_closed(struct ffs_data *ffs)
 			ffs_data_reset(ffs);
 		}
 	}
-	ffs_data_put(ffs);
 }
 
 static struct ffs_data *ffs_data_new(const char *dev_name)
-- 
2.47.3


