Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812C9CED260
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18446B0089; Tue, 18 Nov 2025 04:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEFDB6B008A; Tue, 18 Nov 2025 04:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEA66B00AE; Tue, 18 Nov 2025 04:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B96AC6B0089
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:41:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F37D12ED5C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:41:32 +0000 (UTC)
X-FDA: 84123235224.24.5714655
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id F32FA12000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:41:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=f82OFm7F;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458891;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoHAGF5loUqH0LAFPRC8F4kXyPuIEz0vDtopK5rWb5o=;
	b=uOulkgbyFTASLsmn/IF6pOwC44pctr7YgpYmz7aZMQFegFX8W6hx4NkdX9ahs/s1tep8ou
	DNwMjQ8otlaFEXI7EOl52SI/PaMmwUmNvcxD/3237QxP+SlfejNn4a+Dn80SrBtqEqr7Gw
	VtqRAffISIT4PTKhFO3Vrp+UTT95Tig=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=f82OFm7F;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763458891; a=rsa-sha256;
	cv=none;
	b=ij/x2mK5dcG+QGQLRp+WEnmsWQDJYt4LKaAczVlGEaCv31P/MVPcZYXv48VI/3iaJfX7LX
	H9BcBbQIk2uOkW3pM6wLJGSXfNK0TlWDlgCsA/+PAu0DnNBmNn5Id/PErgoE2/R+rhKFkg
	smVNzhjykbwaKHWgrtALQ2MgsNeYwss=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eoHAGF5loUqH0LAFPRC8F4kXyPuIEz0vDtopK5rWb5o=; b=f82OFm7FvazKYJYDPR56+WvVrq
	Dj+gC8HySiz+YAUbtJL3dko4sirA2yyl3o0FsOZ9C5gPoeBshzb4xWNGR7mx5ndW+pcT0XXW0PTVA
	1TdD3rRO4XfqYu4IR0qNpSgFvWmn69s6hBWs8H1HSLAVur0wqfCUAb/l9kFK9MJQPvsAVZ/QRPuI/
	owlmwWB4SXiXlhgGLf8wVKr1cD1r6MfuwfesIPeZVcu2CllkQ7zErPM1f/l2l/YQojOTgvgL4PbRY
	K6Eo7MWrGR49DBEjSc4+hMfJ2JYiCa+ZoPNrcs4NBhyUR/9rNJc7ltq2YHT8otRnbYDs9xo7mRhmC
	/Whn4W5A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GEST-0Krw;
	Tue, 18 Nov 2025 05:16:08 +0000
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
Subject: [PATCH v4 28/54] binderfs_binder_ctl_create(): kill a bogus check
Date: Tue, 18 Nov 2025 05:15:37 +0000
Message-ID: <20251118051604.3868588-29-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F32FA12000D
X-Stat-Signature: xcxmxooaz9qjsqhdbzmkihagqdrhgubs
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763458890-149783
X-HE-Meta: U2FsdGVkX19RNrMYy/US1MRzdoAIB5F23wdPpbqtuWxIauvUlow810ByJQBFV2XcHkZrxuHJcXpN+5KgwoHKsMOYd2cBA2GiQ0P9fG/u1fNvpLFVs+pdLxrijLMWwDwVl2820bNqVIX2ExGifYURGDWW0ZuR3OWYm2Os44aaSlTQo0wdADrpic7WeZh3lHrPF43cTXtfPIDkv4isXeeRrPsiwqYApjt5wNfihpfpUjdK2LPLLVrIznRC5vQwP4Im49zT+eC8aEDRwWw4dvh42JfcUANCTXVVvnTXcaUSsNWgejnIXvXbCKr/kzCiZINonWH4lT1OJ/Cy22DifYgdsJGeHeX4Ig1oSk69SQpNWT9AwhKaq55hagQUQbcBYi2GGArQ7tWE92ll/AqW1oP9ScY5n1G8KaizGDphFQPKqKoV/CGB5ndBlurqmEUqeEayMXc+XdhbbIBH8+j/Hk3bxmAX+KAZc0a5CgYeuwnL4Br2GJBZ5f9lm6fPPex+CEq3wswm2FbIOI6feOlnWbNVFD1z9QWNtn2hoaF8kOPNZ6/grzEGp7xHLkl2oYTPeqRhP8qvKAcwZDspFemS1QbMWyzmvYmSmNerKYJ2W26JoinY+37cUleGNd94hEHl2mTOnii0m4kNTNcP6oFXPoqpE0uHMVMsSMLYTa43y3OZ9wyh+zdC/18nI2IiTkQNAUX18p3QMG5NKcDtaOnGpxN5rwwLBq15ozX1Xmf017i5wUSgQscyNNVlzXloNpe7U8q4GWgZWaNmOHlv4XT4+w6PrElYLpLmkGmcYxKBryj8rlzUq4R2EqhO92fwrtZ2IPRNiKUGt1wvihji8X5PGHA/cKeJ0rI7ruIFV0XmiYzW39uO0/mTjYNGmjX7ooNb6f5QzRl/igBLhh63t/0AE+bkjdghq9Xy1JNVatU/JBO5Etyw9Orb4MI+yaSbL3L5EwiaUnOqH6SS7AovVbb5/8j
 giBVbSVp
 QM2TEEdYTohcXrDU/cYXbrvY7JQiphOhSPq/BPo60dTutyCFD/CYzPBjrtGbAjTfCk3AQjTgAcBkjPNGlURcysidJx88fBAg/xktbyAX6T70tJTEZjsstyD+qRh5nTbqKHi0q5RF8YPHfOdU79r58eK5Z3l+cn9J0HBNw
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


