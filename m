Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C3BC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B896B6B0093; Tue, 15 Sep 2026 06:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B45D26B0095; Tue, 15 Sep 2026 06:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02676B0096; Tue, 15 Sep 2026 06:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77A916B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:22:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9D811C237C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:42 +0000 (UTC)
X-FDA: 85215607764.23.D3C2A96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 04FFB140008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:22:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EODRVZ78;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789467761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izsLFS0tkOxNtjh+qEH/VSp+IfMxwnWHO6ubkr1wAqg=;
	b=fkhoOAcC4Qg67NOMKSYBs+kEY+DESf5IwAYh0v4lUt8QIC0msRrydxxs2hFhAyZIyW3UPA
	bJ4lWYJT5qJCZZ5D1I2o89wKFkARyleE6b/i9NrdB01H9hxSp9pyf8zLIMsCg1M5+Yf+qD
	U3qoN65x4US3bTEUBIkeLHgcFaLqXr0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EODRVZ78;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789467761;
	b=Zwn9YXel1ty3+yNayg16s2IsTIsEQ78HW4dXwDRn7Mmc+GD34RXSs+ZEJDBU0pvbK8UGjB
	UB1usXFIzZmMlZWPnIp3ukxyIvwL4RESTf9rExgFXYSVcPeye2lcdE4Gls0W5gHW6yQtnB
	ZGqAZYR7NTS1wBZu9cjwgJPBSKmL/eQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C89C602CB;
	Tue, 15 Sep 2026 10:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26131F00893;
	Tue, 15 Sep 2026 10:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789467760;
	bh=izsLFS0tkOxNtjh+qEH/VSp+IfMxwnWHO6ubkr1wAqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EODRVZ78i64iioiiJvZn0gwShjD168VDnpcnxJuxCRm4yrd3zyqZoh5bOljoZiwfe
	 +8zd8Q9os+vLh3jCvABHT2sBtW5p8CFSGyuYO1jtt0rejHv95+7wFzRkbqahwfHilN
	 ZZ04SPifZfBlB28YP6Uv9qzNGZ22HGkkNm8Q2sO0Jn7enprwmJCnAeWCDzguxeEIuA
	 2d77aG9wT04OX9CE54PYplS27VGLo0FfZ+z4C3KksZsEgrGxw2YsifwwRHuc3oUi83
	 5Q7pTOpaEN//9knrINWz+Bx1fWSnicpbJvNp88tAK8RXFkTclMq50O5JJWXN7dQMLv
	 4kbA6gcy4Dbig==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 12:22:16 +0200
Subject: [PATCH 1/6] coredump: don't switch a dumper that has no files
 table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-coredump-fixes-v1-1-f354ca41780c@kernel.org>
References: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
In-Reply-To: <20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1162; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wifUit0zCXT+xmFYL1pQ/rbqJKzU2mv5TqNUZ8hoflY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStlMmImc9rOo+RqeuSpEnJZ5WmPjunTsOA5JMMBeUe3
 xbdzDDpKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMjfZYwM5/eJvpWveKOeNl8w
 WXaXnm/jmuZnl6TehTm3Ma7X0PzbzsiwXXdnsMA/5dtLX2TtPJVtuDRaOsevkOFpjELZRM6SF15
 8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04FFB140008
X-Stat-Signature: yycp8xnndts4r5f34y4bemtp78f7ksb5
X-Rspam-User: 
X-HE-Tag: 1789467760-577196
X-HE-Meta: U2FsdGVkX18kkeT1HERji2jDRgmx7yvIc8GgBB5QBHN401lLXRqJAZhQNxHn1T6q3iL0wEx8L+jYFu6PeHkcQJngZGJp8x2gzIfwYk7Zp4K6kBBGIwChRTkknQOCyaJjT6hNYcRNE8rfmHMil/9x7lG0gBs8z2QTjUE1qcbmqBaSOIhornUdUc0Z1wU14GJ64rxLHrmKRpgSVema4D9cZtcrEpqtAAlQrhKo9FFzNA5Rk7bqC4W3EaZMw0GhJa2nLUBhjOTcceFS8Q/S1m09guptHy4D1jHbHejSH1EFXsWCnb6zNY6MoV2UnqUuImT0W29/ekOcAFzYJndt/4YuF0gidAwltVKRhR7Xb7DqUEzuOQygE3+feaO2rPtc7kz7naxnvrTYWOMtNYoUBlpOuVN7JWTrQhguf35/4ArxP7PZngByPNneYvm6BYRbnN4nawPXl8rW5f4QAzJBroB1LouTati6kcjYxn23AfMeseQYjG3s2gGgkQ93OmJ+6IRiYcSECBdBW4A4IyahRjTsqA6rhYqfbeyRAsVf4EggtgIDHSRCr2gGT+JH2C6sBj2rLeE5k49Ii7OxM14CPg+rHsaEZuxNz/LQ4jBZaNUPO6/9Xfv6BpBEcGZ/6Fl0KfSS5X9zAAvfNtzvgpekN6RKykJy2GJx/MlOc/nuIuy4t9tDSo99NYh4iovQfb867NiFcWLEDznuTrWVrvNWFZ6Ur1XUCNYMZN8K8B5h5K/HCCWvMoo572RmoDjiIFga2eiVzgRcSWiGdA3B4lDdpRg8wNqT65sjPpNnCzaKJ4iCFysa7gkSGRp0Wg7wM6Eag3UJ/2NLL1pqAbZlGuvYtPYEZ1+BLEKNA3J0Wp59YKpyRhPID7DAq34aE6ItZBW7YK4V6qidYy833VFTrHI61WFsOG5y7B+7ukzDuXtQNXY51xM40sRZVG0QFWr4hMY+tM3opaLAIIcBezLObTqT1nL
 dH3GckUD
 atpng9ImciZNDkL4CzDlCAATPBHcGSPK0TFI941vpkVOrPO4i+8FJyYFjtGz2WfGItqUw68XKbuI0t8RnqLzqA4Z3NgD2nynNrT33mofplqOn7zk78/ellG+sogKvIGSOn2Kneq/l3pVcwn/cO+hLsUzJtPUREbZlGDhJjEJz8ByFbDFm3GMAY53Dl3sD6mHrsiuRhdcSgTobMwBCGP7sKpZpNTxK0kIKGYvOshYeXHpi0YwPQOVNfxm4Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tasks without an fdtable are skipped in coredump_close_files(). The
coredump client itself doesn't use the same check. Since
put_files_struct() doesn't tolerate NULL it will oops for such tasks
without an fdtable. The prime suspect for this behavior are vhost
workers. Skip the switch for a coredump client without a table.

Fixes: b2b36bcb13ea ("coredump: add COREDUMP_CLOSE_FILES")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 1fba3fed1a07..791a9268ed96 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -579,7 +579,11 @@ static bool coredump_close_files(struct core_state *core_state)
 	/* Use the dumper's real creds not the overridden ones. */
 	scoped_with_creds(current_real_cred()) {
 		io_uring_task_cancel();
-		switch_files_struct(current, files);
+		/* The dumper itself may be a vhost worker without a table. */
+		if (current->files)
+			switch_files_struct(current, files);
+		else
+			put_files_struct(files);
 	}
 
 	coredump_wait_inactive(core_state);

-- 
2.53.0


