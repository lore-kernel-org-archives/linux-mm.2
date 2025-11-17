Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B02CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D584A8E0013; Mon, 17 Nov 2025 17:05:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F918E0002; Mon, 17 Nov 2025 17:05:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D858E0013; Mon, 17 Nov 2025 17:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B53168E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:05:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 618471DFEA7
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:05:37 +0000 (UTC)
X-FDA: 84121481514.21.1F0E85D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id A567C40014
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:05:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=nBqNNFGf;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763417135;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdoiPvduAJmban0XZT9fHwC8ngtnF/xlF3wyZoQDdKo=;
	b=CmH41AnAziVEpgjhxHpHrfjKkMDxI9W8PZv07UIkUmuLAx0u5jiuARcRweFCY6lR4fUOLF
	mSRz5DOwfepjSMqX76DsDR0boTgz7hA25+rAB2Dq04aTIxZjIQA1A8e8rMOch1urmf+hO0
	dxsxlCAsRACHklKSZrxhWUSn+xOKdmg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=nBqNNFGf;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763417135; a=rsa-sha256;
	cv=none;
	b=irYQA0nBm6hr3rJSyFHsnlhnQxxegS5FKLeYvbZRNJg2GDwUNXcC2tcSRinPmUfDlLdXst
	8nGCmNxQuqLReYN6+9Ruy0DSsSO7F5WKx0iSeP9yOcpqLriRDMxTrloFJC6/xpbUyi+t/2
	e2a8IdzZ6rqXEo4SnYE5pMJoKXZUIq0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NdoiPvduAJmban0XZT9fHwC8ngtnF/xlF3wyZoQDdKo=; b=nBqNNFGfdqKxxSVEFbkYBH7HCK
	RZfgjjxQt74gHErvaYYpkM2nEVrvPO8Nl+WDX/wqK5bDZXz6a3KmFOoolgEeeFQX8I6N9hEwOstb6
	eKW568HlCJUscl9G3yajgwQxt1BIpLKjeDl4FAnlEgHfYO7xY5nm8CaGpXgaNtawvouTB0dDnq9JP
	Iriyh0hzqdr24etHseBuYN8DJhgCquXEdYC8+yw394UMOgRqpndamrmYqV2cUQZeToveKbWGQ82ht
	jZa05E50eSuXK1dWOd9GvHgd9EgQKMc45jeQKbD3foNOO8qfNDPYv6IxQGLYsKYfSmPxms13r+lI5
	J/l4QRZw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vL7Ll-00000007Lbh-1xvx;
	Mon, 17 Nov 2025 22:05:29 +0000
Date: Mon, 17 Nov 2025 22:05:29 +0000
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
Subject: [PATCH 2/4] functionfs: don't bother with ffs->ref in
 ffs_data_{opened,closed}()
Message-ID: <20251117220529.GB1745314@ZenIV>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A567C40014
X-Stat-Signature: is9hkn436x7c3a7is73wkkwj7knto53x
X-Rspam-User: 
X-HE-Tag: 1763417135-500045
X-HE-Meta: U2FsdGVkX1/69CS9I6/su90u1xnyZ01UxyFNb20tL7Ay/Kzcfrj8rTIeBhYkP3mv794qAcOknDojNLHNZewvrQ6iOaqw+aag9ZduAVjLp+u59qcjRFw9UnzaGW6WJ2je0JSnJXwf3QZqQIakWov1C4YPg3FreHiE1tTPataLWaEBAVhOCtX5k41Fbbio+PevZksRU/dXmvQunSkU3zMU7cV2CvDyxGXOwceEsrFsUKs/Qih0qrmfu2mMx6K/kcwgpwjX1frbnw9dbENznd3sAsCC3O0VwDbDAkH6dN65tq8VuLbI+aYV2xAs4CQExKIWEs73UUWkqA49OH879+LxAdTXjgVrfoe8thz4PS6g5Qj7NRlbtE7yQpZGiyzTOSOnlbsa0cE+fUqGlR8CQDUHBu0Z3g3CxEn7i247AdD7peTzSFR/QSHc4Q8mqdsH2rDNRO1vat17EmVpq9d92uH7MWutiqaJkt4ks0s1KKf9GvH6UfVJ5TPmXXQyJr8Y81tpneWCGGigOr0DMP+S6JqA6CuJpEKIOssKXAEJ0pjwPQuxPRn5uUnlC/idLo9RoZY8VDxRtcI/8LjZV8bw5B/cWC+NXS9XTRjk3ZQRZ6X67V7pWRuqk21GK8D/HB3zG62v/417mgmNCdJWCTRhLLI17uZfAXKJ9S4Lzx2ev5gLVva26diDgLr87/QH0eFkvqwyQ76F9OR939em/3xhwxYRdkHXwI0dp70bKqoj3Qx4/QGTFQ4fPrgZtZkKXsZP/+0uyqZdtl+sX/n+PXZSM0FrT7Jda94voU3XawRMIDAQ4aDVjFYQOXyFtcG1vcKbnhIpZzo+sVUb+aSe/PRYnrK1jYzbUuVZ27AVnshcTi5VOL0pyGT2Pg1ygdHsZFQVq9tbghWuDskogKcO0fO44zn9CJIKY5aFQepAtNG6AYmtnmTwuko6saQWYxSgXUk4JQzd9c7QAe0OdybY/hK8RAW
 4mRh5aE0
 5ZKcaT616UiIrynqHDbJ6Q5oTKO5EU+rRr/Z3YQhyx3GYHg6XUsw6xlERpLZ8wfHxqsektcaKo/x5Yn8lJJxPRUhiGdCKBIfqkAxNZjdXhCJA5dWSnUfheeqV/tX+KrAT56Yb8YwHZialWJmRri5O7qCMMO13BBJFHWJ1i6T4Ocjaof2NoIqWJDaR78w3eIe5rarWwUXUFJqvB78/o/4pjNtIc/Wmm+Hm397ONG25+uxMihAN5kdA1Jo95LePKDYoHgKkDVzEmbXD7WDH01Z7JM02DMZbVOyXGJBLhXWhs1BDp5F6ZQdQn4DVQIqgH2MEWTp1atNKfGUn6AOn3KFJeTaJ1cVMT7/BAW9NPfYmK0cg73rsrkcXdWEXJlvUw7blFMpJaMnt33QIGPADV2tW0LIy99ePXw15X0TQWOfh1H6W0tFgeyE8mlFw1Cs1Ze0onocTiUOPMAdWF1NZtsZu2d3bLvanW1+UAiFppt/vm9bnj+SqwatBNNbYkWZlBuTgPcuvTtH8KIMeL4lUNDBXTsovJTgsenrC4U5/EIYMdRhjR3A0W0qyxl2FbFImfOP6nGNMGjWuPW8WO8+uegy2ZHgonl+vaYagYFP1Ec1bA1F7M6Wwt9oh0RhSrw==
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


