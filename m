Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78796080669
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XFkCPZLO
Received: by kanga.kvack.org (Postfix)
	id DDC606B060A; Mon, 16 Nov 2026 06:10:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65CB6B060B; Mon, 16 Nov 2026 06:10:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D866B060C; Mon, 16 Nov 2026 06:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE046B060A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:10:13 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E533A0888
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:13 +0000 (UTC)
X-FDA: 85440713106.28.838E64B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7B96C18000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFkCPZLO;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64fy1ZrurHksDYaEdeBVzwJEogDQqSWMHixC8IXM43k=;
	b=mhMTZl7Gmu0q1U+eWWq/XHfQL7xR73aVPUmstcvi8H1VrOewr1z4r/xU1/H1oAt6/n47I+
	E3SN1uI+Lsc2iGP9ZHKIZo7mk/00QgtkZSmRjCf2OcfJRIikurcdQmtq5oqzt4E5BH1KCj
	dZ39t50gqi+ZppUg9tEfgd82dsM4DEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827411;
	b=rtKM7lVOapmsjV/+Ieuav/5boRAKq0cDKqfGj0IHvJtNPSFY3JgO+diM0KWNs/lLT+JrtU
	gRKDRlDAHXLKfNjJSXZajX8ZEDSGyrgNvUjfpXIjNzhJViwzoRv2Z5kUSSuL3+RdGsh8p8
	8k8cD0jNLgzdkBTgmic9yQBgr+LhVl8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XFkCPZLO;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E44A6292B;
	Mon, 16 Nov 2026 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483D51F000C5;
	Mon, 16 Nov 2026 11:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827410;
	bh=64fy1ZrurHksDYaEdeBVzwJEogDQqSWMHixC8IXM43k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XFkCPZLOyT6temTwAkvo4voI/JBsg/Z4henG9tv1l4AP+unIyDGq5gVd+SYbfTNkW
	 J2q+A4W9ncbFM3o2CJeB1KlGFOQOyWo8ySYnVIO/5YximXo+mSB8h+1obwLjCcGEvW
	 A1UXSeiotXqdUuyPaAj9hOORnO/ihLGR8bgH8DCMlnoWpdtPxHllMf91dA7wxs97Eq
	 yjHuVmibG1NowwYf+Q8JcoJLbSPOUKYKONh6M5SqznmTuA/gM7dxnMZNsRN9PfbJft
	 +J4kIRFgBCIHj5EPRzp5FFbIDcQ2AbpmpaJCmFvcccbVtq7fFVdRiQ+kdhPCTlwHV7
	 761XGVhpeq4Nw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:06 +0100
Subject: [PATCH RFC v3 33/44] ovl: refuse data-only layers on pseudo
 filesystems
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1983; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Smh6T1OxDytywEa5/SA4YQOn0qat/3OEFq2S8CKkHFQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etzKv1zn0/fF8VbJ056U/V2j8fZ05/RKp3DlWuv16
 b/0c+MfdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkkz0jw/FI3n9/PH4HhZ1d
 ys8rckDxnqnu2en5RiGRkRGiO5TUohkZnmV/WFDrXXLFbNEWtocf1uvk3Hommj2NYaaXF8OJCE4
 pHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B96C18000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fhhwndzbrhqu9u91roqw3dgfgr6dnw7d
X-Rspam-User: 
X-HE-Tag: 1794827411-827874
X-HE-Meta: U2FsdGVkX19EcF7CFttl91ZDMPAyAdoUfSkLtUX/MKlYzHKd51rFy0uSZVsMFXkqtXZLVk7Yz6o5HtAqfEV3YEZ8MvXOESQoMhuTOorTJMzM8cPohvHYFEmI8zvlo+YGvqO6TuzdJPo41eA3koVkeLae9liBY2nNrygjLv0Wj6hhk+Mh2QSScUNI44tRWX+9ak1mthptU5VLN49LaEOO00T6KtfSz/An4C+G9g59kdIa1fnb7cdn1Ou7sconY86cW69FeJiDeOI1dh8fj1gzea2OD0be8BYTcUmfM+c11eXrYhUlqd4zp+S+YHyZundLlhVaQa362c8W5htbprQ5GK/FX8sz4zrimDaElbASM3+4MaK+QDGxUMinML6qtTBc4di+oOZlK1MJJ/ZVeXyw0WPtx4YP4TUmFe5TwdR7XWRbOFtyFvDYh1s8GkcybXi4RSFAGVERu+oez0m2XHSrKEr3u9Ca9InVe73OAYCcHnfu3v/+npM701OHpdODAPD/ekF6XEAB8rMMY+CturVn4pr4n6nTSeATvx7o+P08es9I7gbKGE1KRb7a6yTx0DZQpJnTYVzkv53gRk7GMTEWm6mMiaH99iACFR1stuEn6uG3Iv3oLF/okECj2fLe8m51zSuLnf/xYMKt3AjokDqlzWFcEmEX62zvMJYbxMPyuo0aRVqW1NAo0orFgYkkFBmYeyhTPNHG96/N9E4Drzw08QF2XqpdZmiNsz8s97CaO5sTQg+tj+mn7dVJz4DL4pAPDGLHUwvjTV285L4I5Q06TaQDBWX1FJMqJ7TTvx42U1bVd+aBE/FcyTixbIBegEe90gvRKPAU31QjkUnYiK2thBi2fX1nGBBx+ZUE8cJpz4jbcUbhKl5LhEM0uq0OzhxKmEwGoFWx4UWhp+4Y/ikADIAY7Cf1jjeBYGdVzhjJHajd3QWgmpklSpUm0sDLzk1l7oGqYIcHV/tLofgTFGL
 qhHnsyQG
 4MEsFhdlHkDqJYLudLBsS6qnKVy1VyStcoGPDrIGokx2e7t5ZMNPEzTkzGvs6BSBoI99/rOki36+sp8KTa7n2zzIqYrXaHT7H1GyuExhPMIVw2s2IC2utD9T3z9cc6OJQjSLF7PxNuCGlCjR9iMlbAGo0w8gtYLu2GGqmAYsrBJHDhDGxY69EEBybULZhAtd6ASyuL56lbUQldhtmFBUpGtz/WDSr02RgWrr5lDnyZu4VCUsNF6Ee0h/9HT3fM7PzZ1YTGqbPfqBSDLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The data of a metacopy file can live in a data-only layer. overlayfs
doesn't look that data up when it looks up the file. It only remembers
the absolute redirect and looks up the data lazily the first time
someone needs it. So until then nothing can tell which filesystem holds
the data of such a file.

But a data-only layer has no business being a pseudo filesystem in the
first place. All it does is hold the data of metacopy files and the
regular files of a pseudo filesystem are kernel interfaces, not storage.
So let's refuse data-only layers on superblocks with SB_I_PSEUDO at
mount time.

Data-only layers can be added via the "::" separator in "lowerdir=" and
via "datadir+" by path or by file descriptor. All of them end up at the
end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
of them.

Note that regular lower layers on pseudo filesystems are left alone.
Stacking overlayfs on top of sysfs keeps working.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/overlayfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 39d4d57dec230..719c2569dfeaf 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1237,6 +1237,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	for (i = 0; i < ctx->nr; i++) {
 		l = &ctx->lower[i];
 
+		/* Pseudo filesystems don't hold data for metacopy files. */
+		if (i >= ctx->nr - ctx->nr_data &&
+		    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
+			pr_err("filesystem on %s not supported as data-only layer\n",
+			       l->name);
+			return ERR_PTR(-EINVAL);
+		}
+
 		err = ovl_lower_dir(l->name, &l->path, ofs, &sb->s_stack_depth);
 		if (err)
 			return ERR_PTR(err);

-- 
2.53.0


