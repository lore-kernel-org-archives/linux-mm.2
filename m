Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889C2CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06251800E8; Mon, 27 Oct 2025 20:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CF7800EE; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F2D800E4; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12DD5800E8
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B63981A0300
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.24.7CFB58D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id E6BBC10000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="ZP/5LJ2L";
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IpNAvIvaquRQO1Ji53mf5vyLMZJ4O2UIIE/EO15yw64=;
	b=MDGU7mXo9uOkzDY8D73WLdv6eAVQ8HOe0n6TLtxTTRF1lgeLegoOVU1o1fMncUSS8ZJ3si
	v8qRP04pLoh8of7/O87K0s61kj4rhpRxjxPu7xiccGbWnXFwVPSkYPaWppnmbU09/abhEB
	IC134TNCD4/k/NkLhb/1rIWmJPw6Fxw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="ZP/5LJ2L";
	spf=none (imf14.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=NperUHbD2Z4r5CNvzG+xj/Wa5VZidNIQKScXdTE7r0hEQm5l0+JIUiUkP+ubW2lLCFfjeS
	/L99mmDJ6Zbtm5BMxpJo2TuQ3hnK8F3lEIINTkxvm/SRpWZ0ycpu38VintgoErViLp8lLS
	FTqRYXeV0Ex9HC58e8x9OEZ+1YZgU7c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IpNAvIvaquRQO1Ji53mf5vyLMZJ4O2UIIE/EO15yw64=; b=ZP/5LJ2LFqkgPJcGiYKyxpw1bl
	eE3CR/YNuYLN0WTyuXwstIsr4MFxI2VWRTUkfj42e3nPv/cUgi0kuvG/bWyRLxSi5NQw7ta1hlYv4
	Xd5dbq/1RgBzh34OYZIx+WEXJGf6km9LeONaBmB9ZMfMIPXlmqSQ+hT7FWjsKbJ9vbGyq/LFSSxKm
	A0vkavXp26fq9SVKdWu5aIE6UDcTLlY77eXEFO/mLAq+Ea1RoI513C5nQ17dKaQ87vH129hNwOX9w
	ckBwjy/VEiET6MWdU6BL+O/WKM5gcsk8pDaiZz5CqjAwGDoqmKOewqwSjwO/29YQIX+8JGowiC0Jp
	MRIn2MRQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eWz-3auK;
	Tue, 28 Oct 2025 00:46:15 +0000
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
Subject: [PATCH v2 12/50] convert smackfs
Date: Tue, 28 Oct 2025 00:45:31 +0000
Message-ID: <20251028004614.393374-13-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E6BBC10000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zp8aene8q7ykjxc6t66f3wemsoaditt4
X-HE-Tag: 1761612383-662999
X-HE-Meta: U2FsdGVkX19Ve98sWCkmYey7vuK3bOBKpflJWT0c6srsczClfB6PWwJpjsZYKITTq6tZzg+fF/Pv5kNmn/5bRADZBMtYV9IEM9+GmBU6RP5k3/9kWrgDvnTOCg7YScdVurc5bckj1uDnTjkicEkNL18DYz5iunSf1DOMGX6SNCK+1UK/AL0N1yUYHaMl3N3/ornrtPHua/fQcBFcSb+jxHtkFOjC17WYuJmd6/6GmmWyfPvrgZ0TP/+Z6Qxq1bXw9dXAqO6Si61SI7hZ/Ti4Yfc4xBrCxlxGsGdyJrHWt+cubZEqBRwQf3nZYfGLoYlFcExXBpF/DuerzTX8gk+IRjMhqORamTykcVz7fnnO1bar5LMoryr6lI1y//m7qBiInSD/fvSXCsfuyBZBSPvq7osNLUzE39cak45UOuG1wWa/eEeiObe+yf+5SAiDOz6h0uFOQBvx58UaHCVktZfOtlNVFHZ1iICMyZ1QFOgHR36xKhb41Gut/OcTPrVPFvn7i2fh5at1m2UKK9WIzly2XboWhCpMm6GPi9vs6aOWQPGhf0T+j5TQgvmtOkjECkhwAFPS+0QJde2/2D2EcSRH7XGybzHR7e+IK/pLzCt10l4oBuV8eRd8g9Z7wvBHR2dT5RplOmMSOrm2jkOmMYCAolhF5WdUp2WUDTudGJIbPTwKdakcwbi8ijcIIKkqbOZbJbOPd1h2sz2yw69zoHgZcgdun17kIHn0ypWNfH5KzRnbsKkL3sLfmUQQMV5T7t+dc6mCC7GM+QDoDdExaYoRCfTzAVKulfVNv+6/Zi4Ulm8BUj4fST/PdCHplG/7FjV/HXtitNaBkX8FidZ+funsSiUVVnc0KAE2ukvIzjyeUAz3qR59ZaS3aP/uQahi9ABYyh5gezSi2rsd8FOLGJVMdUHkhx26ynrMrjthZc2+BDZm4nCAOymjR+XW4AgJxFDj7BSsvGaUWw2/575akjb
 1qYVcB7f
 9mKBbxU1kEbJBLQmukSSPkY/gpLyBmNkbMiJ1g5S04BmSd49CLJhUnjuFgl9TAwAFlKDM+NbwXZyOtczZohrjwHAR+oIOmDW5RmOlkietCKpXeWi40b/HdjNjTbSpB4gsofuMRYNy/bdNWK9WjtBS6hjiSM87Qff8S0Aqp1QCiU42xxxus/1rNLrymA/4kMbqL2dmhBCd235K+inYIKaWIvhqKu8ozTTifr3fD693pK9AWq7VNgxoMoIp/kqMMxuMnlkl0WiLc86AJB7Xvtd74TE0uXEsUW+DHfdoU59bFF4drCTuw+Rrx3Y58hzndRxs2ENIRLWXDJO0OFq/WjCoj7S54NbrAvh3fIeyFnsaXmsc+1TTFu9VBwKBqBTur9RlBle4sr5Yjc3X9tYDsKH5p8QduftSU1HvG587xFoRu3xWTC1Y0ft+gvozlZYqcE9pR1eMMEnsLUkDhU5fjbagXbrxB9zdJS6euyMOLB8y4Rvs0eQZvEE3++TaJnTFGdrmBAR3+tR0J0/bdjfiaQzCAdeFCatx+zyNpVKF
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


