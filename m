Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BD0CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A0C8E0014; Mon, 17 Nov 2025 17:06:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31128E0002; Mon, 17 Nov 2025 17:06:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E588E0014; Mon, 17 Nov 2025 17:06:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B7AB98E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:06:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 503192DAA
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:06:15 +0000 (UTC)
X-FDA: 84121483110.02.C08A2F9
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2B09140015
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:06:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pqNWxOKL;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763417173; a=rsa-sha256;
	cv=none;
	b=ck1AlOZlnGy13t2AyBFSVcuck2qMVGu1dhuFHMLQk1jdcMouAQMzFmhm9MMtyKUhalCfjb
	Dd33KxZ3Mi7Ru4LasYM/IxXtf6nuotfyNCN6F0/2/ItyBUFEQPAqbVEN6Bity+HxxeVHzX
	PCSJvtaSDheRz3OsD4o5vPgWH6TzVwQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pqNWxOKL;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763417173;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWu60E9A6eXyK8hzFZrjRSDEhFiIM1wWoXt1TAJWCcw=;
	b=pSQHHloCNsHRnsGT5q2xTy/zJxu9p1rTZzHPR3Z0+ARJpF4eBYC+9jWDl/WqJOxxZcp1As
	QMht6qLkfitR80aQumiw8wmJOFeLuPwvtQ35Zn+OLYRDBPGTrz02eMIkIlgqokv/eW1FZS
	YXbGgwi2TW+sSk0jy7e9aiwwydknnIE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cWu60E9A6eXyK8hzFZrjRSDEhFiIM1wWoXt1TAJWCcw=; b=pqNWxOKL+lbKRWfwobdUpl+/CV
	FcB+NN4AnY+inY4vDZGGcMrdUGyeqhRm7MfkvQuub3rnJfDwBilzKnvLWSwotdOFmy7j9ZACrxOah
	bI+DiB2vEhxdAsNCrUqPAcG+4DnBsP4tTJsXlbNqbm4xhcmuZDcb4Xv2P9y/KmD/wK1zeAYOZCAnc
	M+7iRmhBwl+iF9VqgMjyYbEp48RREHAm09kCiAeBo5irXFHK83o47/cHAXqVvTI1NvdDqD4DdbzgO
	Mme0uqmBRdU1Piy6uk54hLooqG0LNlg6hm0MiXcK+rUE3cQx0+SOKw0v2SRLNhld45JqeQ6WL3lJb
	Sp9BIcFw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vL7MP-00000007MQ0-1yLf;
	Mon, 17 Nov 2025 22:06:09 +0000
Date: Mon, 17 Nov 2025 22:06:09 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, ihor.solodrai@linux.dev,
	Chris Mason <clm@meta.com>
Subject: [PATCH 3/4] functionfs: need to cancel ->reset_work in ->kill_sb()
Message-ID: <20251117220609.GC1745314@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <e6b90909-fdd7-4c4d-b96e-df27ea9f39c4@meta.com>
 <20251113092636.GX2441659@ZenIV>
 <2025111316-cornfield-sphinx-ba89@gregkh>
 <20251114074614.GY2441659@ZenIV>
 <2025111555-spoon-backslid-8d1f@gregkh>
 <20251117220415.GB2441659@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117220415.GB2441659@ZenIV>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A2B09140015
X-Stat-Signature: b344q9de6yf9xr593b8hrm71zpy6iwsn
X-Rspam-User: 
X-HE-Tag: 1763417173-195762
X-HE-Meta: U2FsdGVkX18hwJUCkKX7trhaGufrcvjuiXL8GLvGvUlgN0jBjgvQaE50De2BYbQdQgg1f7CMDyI0OAdBfYROtf3NdfZ8rQkyPc/uciqsvOGfB4IXXpik+K9FAXXrXkpR9GSdHKsbhg8R8KCFlTrX4eB//ed3OdgyZO7pv7NP4mBNFYDTKaXGTooQVYAY/GqesAKuzF3Br5MTTMDyRdIh2ad5oyOff3PdA3ORbLz2f6qgcL8K2D9XTmob9VSXP3YtWb3+bG+OVf2y8ShJei/+GlA6R/a2JWK1qDLntgBg2x3F9eVoVaedLZDQFr6BDboKhZt7eDyFlJbBq7DZo3XQIAeHnFDvR+OSfhKQRxqzNa/BMJ0RpIfOOIgP3UprJFvzerqMExS8sudIwZgxDVC2wIukyvlCIg1uf01Yo2vSgb87UJ4AL/0tMzm4tN5H4v/yEj3zDELqOAq29i0116HEKGadZIlVzgU1LY5U8cLEw6PuoJ/JEdntJy7PBI1LwYw2z1/3bXuOiM/SpjoHF8/YNcIVbkzgMFrMNJf4kwzCQnXcAOeh5UhFUR6oTnsRnLlAO8ek+k4gxua7YdxEozxxz4WmMwr+KoRlYOBIXFvWh7ICgyNcME3OdwR3rzHeat6xAbq59Y69ODAwxcS2nG8im2OUDbys8F6JpY+ac3lC9U5f4vlCoLMimo5I+m1GoXYnX3AR6/+QjaEJR+mL5mslVOo46VYyq2kLEvIwIZfmjKnY8+cVmxkEkw5Acs+7Fe+98LT6BpycYd91MS2cSrA9VMdJ2Ovmwsh9qXFObolKgnZaWR1aE3tBe6mv4IY/utaZ83EKwq2emm9UsKZ0LMZt9m7qlGU7dJK/WPLwqeOgqBJ1VjDSmuKisI/G0UJqlwM/+nxqN+i57nRUNOVclTyKrDnJrovV9bdJWrzntx+9FFjCO06XlUH+B6twwyaLKTUgXlSvB4w8kgKDM6OPMTv
 FVhq6bI1
 7Hcz0AHIVWHjcWwAtiACJdNwO6ZAofHLrqGk/oOUdLBUzbG2D9tAPVuusFi74+uwlNWCJd7dIa8ItT3PEjN34raidSgIXYrd5NM2I9Mu0ahkLJpOKKEqflA6d+AwZLR8r+Tb+mGIC3TfFCYeB9jNSDzfINj/vokv8DlACABwKoFz3v0ATQ3a37PygTnPHwZb6G+Y2PxZ3fCo1mp5SNLTdulBXiUa5J6vZv9nu4exSkh7mbEhM1r24rxT2wKU+4PSs+XrWYsEI5Rkw559jhuUBoSvCZtWChEeCQWMHnov1mIEVL6C4KOdce/HIMcgwJ9X0vJUugros9IMORSSn8j4vmQGEXCaI2EJLNsnvgVwVbBFtt+sNiNiK+o2ztpofIZdQvIvcuwn6Qq8MeypP4iJ1x88VLA1jfUlFcYZMNcorEjSJY/4M68i6k6lMfq2gyW5M62PML2RgkyRT6ZOvOwzVcTTPcdf27+vcFzbl3vPJrYV8zOe7HoWaFTdMl/oEQ2u08Ll1Zysb7oafzpq+PDPk2BQNG0wOGpjzLSYMqvmpF387marD9I+ok5ID6+OXVT5iwTpt0yvkQ6mP9bKXe8bqU4IjcJd7H1lVvohSwgZGUT/NtDFE6SdLRLBF0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... otherwise we just might free ffs with ffs->reset_work
still on queue.  That needs to be done after ffs_data_reset() -
that's the cutoff point for configfs accesses (serialized
on gadget_info->lock), which is where the schedule_work()
would come from.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 0bcff49e1f11..27860fc0fd7d 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2081,6 +2081,9 @@ ffs_fs_kill_sb(struct super_block *sb)
 		struct ffs_data *ffs = sb->s_fs_info;
 		ffs->state = FFS_CLOSING;
 		ffs_data_reset(ffs);
+		// no configfs accesses from that point on,
+		// so no further schedule_work() is possible
+		cancel_work_sync(&ffs->reset_work);
 		ffs_data_put(ffs);
 	}
 }
-- 
2.47.3


