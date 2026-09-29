Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFA9C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 03:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E436B0098; Mon, 28 Sep 2026 23:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377676B0099; Mon, 28 Sep 2026 23:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BE66B009B; Mon, 28 Sep 2026 23:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 055696B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:42:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10D0C1202CD
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:42:48 +0000 (UTC)
X-FDA: 85265403216.20.A1A7D53
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E207180009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:42:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="LzlYWz/x";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=STfuHBhZ;
	spf=pass (imf06.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.137 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790653366;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWrP5nNb8I3PjLtNlYNMtYoGZpi6j9B8G1WFvVNpccA=;
	b=QdzrrfIBWyRbCg63frWIVkjvYoQq0DZiuRmtMX6rtXnqNWQ0nzDXIg+HTjXB0XYQCVbxfs
	deR/WM5TwoL6s5+b0kQpo2X55UzcY2krfGrJpeB8OATNH11Z/CufZ6TIeSNAieC46qcmpV
	MOBmSUkbje63NhRQZXQYBZ9LMcyjfhY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b="LzlYWz/x";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=STfuHBhZ;
	spf=pass (imf06.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.137 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790653366;
	b=Jaj2iZwAUt9cgfBf+KkjWk8a47lCmxpTrJ2PUjPP4LORMVmDZj9o2b3L7Y/nrPRL3G6j11
	5zevLE/5+lyT9ds2/eiUZv2Ri/dNwAvUXrgF32zfPbvYwaPO2fQ8/9EnytHRWeimbsiZPF
	e0DWPl86HRF5z/UxuhgTECYK1Pbq+SY=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id B185D130192D;
	Mon, 28 Sep 2026 23:42:44 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 23:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653364;
	 x=1790660564; bh=EWrP5nNb8I3PjLtNlYNMtYoGZpi6j9B8G1WFvVNpccA=; b=
	LzlYWz/xaQPHRAjmi2sc4x429GQsZ9jl9kghm5nuoZC3ftOXUrYzqMv6b6xSKENw
	9FpQOKBm7+FdakkdECDpmP50KW9Y8RXVXdZx+wMxaDF3rjlTpBHLCLgP4YJqBFBl
	EoZM+bpg/LJ7+dqED9WxZzFWO7fNrvE0BRhPa+zffFRrr/gRpnTzpTwCW30F6rz+
	ZoWmIiWVF0jH1LIrmZndKBKwha8ma/K7HHXjEkqxFhJtEEiy+NXoxuYV1hgC9syW
	AMCm2z4sq0HsOWqv4vgaVwenf+BbwZl/fj+rY9OEC5cpQKXRLworzhoDFEW9wHTp
	KyyoXOOr2qbUPM6hoiTA9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653364; x=1790660564; bh=E
	WrP5nNb8I3PjLtNlYNMtYoGZpi6j9B8G1WFvVNpccA=; b=STfuHBhZIx2BJm7GO
	ufMkWZnPLmACNhxBlxxxA75f6CKA6nOuzG3LDX/TRS7CPQQdJfvs1zmNw5uZkrzA
	LMdaL94HgrlBOUIZbwhcVGP5fs9UPS0Ezsn83Mwnq4szOpSku3X4ABYPEeyE6UoF
	c/ea070aNr284RJnL0KAQn5YHS8F8AyYJDbEnEPDHVj82F4+iwUNGtKXPvsdF+FJ
	0TUyKXY5gLpTY3wSUSS3gnmKEvyAyG6w+CsUjpVklXQMx0AU90S1LK1otBptk78X
	XsPNxYT2kyfyL1HBdHRwZ5EXiSf7+NCV1TqHGyKTj6zEHrPzQWAVljMwWuwRs7cR
	gQ4hg==
X-ME-Sender: <xms:tDO7asQA2cQWsRp8ZT3D9HQqbqwlrk_XY7f84goV87Wr39FRRXMrLw>
    <xme:tDO7asuJxoMrZMEwS_r9d1WET4JhwZYCrv4IDpeSr3bOYaqr3wr5bz34NW-jdZZjG
    wjjzGmp0OvOhBp21ZciZZ_eSVpRnpddHiFosKnpyGjmBsmjTgZt>
X-ME-Received: <xmr:tDO7aiBiQelNcjPHqEEPc5kynT_ZlqvpqsovlQTa6GCSHuDgATpelJ_vzQeXO_cb2kjeLZIKVBn1irynuYAJyb2ZDuSjW0U>
X-ME-Proxy-Cause: dmFkZTGoJB+17Zq7ThrEPjmxn4ZGYu519RzWwVi/88aejzKjstMboztaed73ef7D6avpE+
    +4ud1a3y7i3orjwLfnXoctNyz4isc8MlqqkCj9w/LgYTxltRiENCW6GCIqrBIGfd6BoOtn
    3U4T9DnMQq0t334tHmkLT0tBGbfhvTaaBwaOBKtxwtl6WpY46qwankbHLMumQlIvXZxJZX
    MK4M+NdZABlSsm1lFGpu8Zoavf0+po6/QQ3FmqOSdXOPNwreWLw4U6EONlQdAFPuoTNGlS
    rFYPmLdcGE1rV4M0fAMpJKofG+st3+8PfQ+b7I9sMwGW86B3jq8HWH1QNmIbUmtd6GqsXK
    DC+GUtJHnyMmRkH4wFwirqcbuesm1+52cfp5olHBjWV3n8bdv8DMYag9MTP6cVmvbNKQsK
    bZmhQ+ixvel2oXc+5Pg3sPF6La15pWjbBX7y1xmjwy7R1ukYFOszkEG5j0Ke11PX5NOrwt
    v4BghLxi6SSbePPiPRav+EFRd3kGsE35BUZjCtg+fwu4e/KQOU5naQYTqVkpNkEi29Dlxh
    uPtQvGYB/mVqCYLfWgTv8ifIuRqPAI33Ue7gbl6QvWbBOj05uJueTVVCmnK0w6ZMeIfMXt
    nBtLmUS80WEftzMFv1h16932uEklpiV9CtNQaXniLVOLg3xA+FQJa1A55yXQ
X-ME-Proxy: <xmx:tDO7au0reeHtz0UH5rjn6MKQbrIpxtwfGYwZaEPqjAgkYwyBYeggpw>
    <xmx:tDO7akT_Xf9FblU-ZqQamsdNdZgAV6Cv2FbkrZrP3-sbpuNEqD_bUg>
    <xmx:tDO7atvdOfJMqooKYF8pI2Cuzq-jEtq5uSGz8PcNF-CY1v3gMA_whA>
    <xmx:tDO7ak5Vay2Se88fmS8TgJRDVPOdsvQKaGWZ1kAXTPiymvJ-_CrUBw>
    <xmx:tDO7asUzuJ8w5gku2jyQjTmAI5iEuEPWiZtoa6GPsX0a1qYBTXS34xVq>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:42:36 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org,
	codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] shmem: use d_duplicate()
Date: Tue, 29 Sep 2026 13:36:02 +1000
Message-ID: <20260929034158.1455429-3-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E207180009
X-Stat-Signature: 7x3kceyormsqromsi6yqsgd16zsiq951
X-HE-Tag: 1790653365-303494
X-HE-Meta: U2FsdGVkX18959ulQqRxSFBbm8pWCVkj9I30dEPvfo1m5GG46hifo5Gdr9RRL6h0XFIup8av83ecpNgzqK3eQUJ7bzECK5tTGs2Ko/znywa6i9E82qFz9GFcZXotqvJXewXJqB3eAapJW20akI2mTufkfpKQwteuDsiBRqzvNOWWEm0adUyHfKc+dZj8E02Q4K/01zHHJ7Begpmu7ferzuXx5/yMxgTR3B4tUw4tMXpQUFhOQCJVKUsySc15JJPoHClk1e86m8RfeWiiE5CjhuZTUvpRobhKX7TGDOgQJaxsLzYFF63fipH34qxQQ7ZeSBEbhOHJnluKXZ1pL9SyOPohxCverhzKUk9uMQTtMNJ/Xsn9Ypm1pygJMp6jpCWEDDUTVz3NPQ6s+4pViXPqYMVSR7vmnT9ePH0j/7LQjFP8v3wMAUzouvkCxe4OGbASIHHQCSDA5LaLh1BVveY4gjtFY4Q4XJRHM+tz5QgRJlwWJE7JmP3rutkR9D1O2fNjf/KHUpVc18Ncs3w8u2DcKBCfjBQOB0V5dqklsqtGvW8BkJTBRshmzOjF4U+MECpOnzIQRyaPJ8fSocTQwPMFZVdGqRp+v3Tfdqt6FmKIkf5+0He5DAZ5IkQcuU8e4pqaHy29lF0ke6MblEVmUCTbJ7DEih+xPsNApVX/ojRNlzZnOZQ7aPc1EBpx+EruzJwbzf1SrqY+T4moLzXmBvgMU6odSwqLwFrBGG5YGF7M3/0GrxZ2I2XCfLwB/C3Q/pyNm8zEOItJ/T8nyl5RkvmvwaspHfzHEF7KcmHhJTDMnawhVSSNs8NAOM5oWncbtdxVYz4TkNmHisoOV3YU0Oomojn+zYRsuGBUwdRSXztWF0VBx9q2HoAIfpUp+csaYsS65pwrUIR2mLRczCGEq2OpOIZokmPREYMan5CVi2pG2KzSaF2St9112lm1R9hvTgm0i0XrreaNLHl5e1jV0lc
 OcZyFY6q
 yBRpcGK0enxJ5ezQiD280IPLTSsnjH3Egn4F0eOwXZju3fWpnQVtJdcv2UbAT+yp22wD5SZG9UTLStZ2cn9CnPMV+TRnef+/Ttbe5ob46UD4N2f9rFMh02ufDVieCTCQ2CWM2gRxMvUeDJRoC2fxJWmM5Yut0dpZ4SdosAyLVIRaS/poVM+DCNAvEpOL3F+BVo3/mr7QG0S84JxMvjI9Ep0gkkNBgf0rWIp/YU3tgdqTzPDmcKEDqypgRON5/mAmIcwoFSCXPEQT7BOGwlVI0Nj4DStWAWU5tRCfjRBVkw97EeWe3vmweMe48e0x+T4wHHFQdL8RdTqrk3mdC+fV9QDRdAxjzRN/+hzv8du8irJzqUnaEzZ3s5VGc8UwN2Rt3eb1k+MfWW0roTc5Fxn+Olr5cTq2f5ESfigQYHUaaa1/Iqaamj2ANG6sTA5zRxjbyNjrwaucj9Icl7e8+qjDYzGQOx5vbopuQ02TLaarFGSXAy3qhptCdKVavq/X7xobuFm75o/5zZirKfTZluFCfIy7GUpzrJKaR/UP/O04SMrKJnzzOLQ//quhsWHwl7ya0JXRRsJRbKplT24GKahzhE8RBVHqPqsC93ELnmOyYatpm9MoLujasal9Ui/985U+OwFAYLil8ex/j/K3SXGxAktDIBnJFGE4OLgFhUbjcB23bl4tbC3fuDNjh351S3mjps0hIKMZgr/ctFJqhP5nIoRQntQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

To prepare for d_alloc_parallel() being permitted without a directory
lock, use d_duplicate() when duplicating a dentry in order to create a
whiteout.

Signed-off-by: NeilBrown <neil@brown.name>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..8fbab956466c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3976,11 +3976,12 @@ static int shmem_whiteout(struct mnt_idmap *idmap,
 	struct dentry *whiteout;
 	int error;
 
-	whiteout = d_alloc(old_dentry->d_parent, &old_dentry->d_name);
+	whiteout = d_duplicate(old_dentry);
 	if (!whiteout)
 		return -ENOMEM;
 	error = shmem_mknod(idmap, old_dir, whiteout,
 			    S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
+	d_lookup_done(whiteout);
 	dput(whiteout);
 	return error;
 }
-- 
2.50.0.107.gf914562f5916.dirty


