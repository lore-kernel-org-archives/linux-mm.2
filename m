Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CB9606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KIPHI3MT
Received: by kanga.kvack.org (Postfix)
	id E32076B00EF; Sun, 22 Nov 2026 19:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3CE6B05B0; Sun, 22 Nov 2026 19:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1316B05B1; Sun, 22 Nov 2026 19:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7DD76B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:01:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A3831A075C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:01:53 +0000 (UTC)
X-FDA: 85464430506.29.8AB22AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6EF6140010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:01:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIPHI3MT;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795392111;
	b=gcFheqHSZZHGT7pjRyaqrhmULi94EhzLE59SQ95kmIu08HTIf/PsGXvSTlzr8pOwWq1vws
	zkTDrIVrS64AKXhBOcZIopvz10R1KfXs4il2UfKtbXMXn8rdUPyAxkgbfJpL/l5hawRz9L
	bzy/K35hg0fbEsuG86oWvDVwokktHV4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795392111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RWrU38gXUbEfMF9OTe2TxNpR3JhGadiWn2X6uNIggk=;
	b=1grr7dRIUfJBMFbFtPTr8LzKdomgSjEDWCsygNnpOKAlACgugD8slbBmVS9mvMPBnMjnRK
	i9IjNj5LbifZWampFJj2xegA3ua4KjbCGbVnCwUThqFao5rynLHPAae3BxvSCJHvFHo7bv
	bEmwt67Hx98yujKjc5n75EVDUa33Ba0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIPHI3MT;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AED3A601E1;
	Mon, 23 Nov 2026 00:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D211F000D3;
	Mon, 23 Nov 2026 00:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795392110;
	bh=/RWrU38gXUbEfMF9OTe2TxNpR3JhGadiWn2X6uNIggk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIPHI3MTKVVUFFy/Vr1VTGC9+hivxKCXKVDk/fyU/9wrQHUitb4QpscpXqhJ5L8tE
	 dvDiuV089DTx5o1X6eidWBL76n78U6toeFz3WJK0mGoDlXFkRgFHSdaMO/PiHOY/jz
	 Lw/UASQTTMTVP6jTFvvEL3aCiRSKnosuN1Crryu5p10Nb4Y/3nvIQ28zx3jISwmVIa
	 pBRDb3Cmois9pxwkf68RM/6q/XvaxQTzluuvEtb/5AzeRtwZmxTPCICeB/DBH+LSU7
	 RhcvdMdmoFA4sTUXYMTK8ph1v8/wg+MVxiiGryMgnkXYygS0Z44BSTZAtOrC0Vpde0
	 Tr51OESksZZEQ==
From: SJ Park <sj@kernel.org>
To: Yifan Feng <evanfengff@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: do not overwrite wmarks.activated in damos_commit()
Date: Sun, 22 Nov 2026 16:01:41 -0800
Message-ID: <20261123000143.86987-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122002930.98401-1-evanfengff@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 6EF6140010
X-Stat-Signature: pkd49ykjwopmucya9hwwp5ekpszfsh5u
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795392111-449981
X-HE-Meta: U2FsdGVkX1+3A/oOVVOjtIPxXyAmEUBXMXuO7NLLyhC3UDT3aNzeTC9SM81O8hLr6b1PhE5uOpgdmFrccDBbVgsS9th2RP3/Yv3g0GRs+UNGpqzj//zk5QacVpf7zJL6dBS4PIdBU0bAqm+YgcjxSAHMNw6x548/gZb6OFJ1kdwa3PI05YO/K/JT19XQRYXsvhewxRFc1dMXayhK3G41V3ef1i7OI42TyUyWWH9ns55wpPdQ247gvAl/POLzf20yVmsi0OqLqW5dHFzQcZt3Lhj7m87+TQiI0L93w1cS1feKNbHRHkftAFtHmnKN83ZmtZCgzLSDSxpP6HbiK0wyr95BufhGBYdA0kYYmswZsAdOaNXpoy+rVjzypR7XCnT+c/XnFXyHW1gCV0/a2SHVlK623AdGa7Ct7Gs54K7a2NUCXSKh57fON2MJZUcVVapxt8Yn7zpOquKe+IP+aoaPYJdjcOIQiXxb7QKFR26qEJ9xfls9VLVw6ty06scHePW1zjjoCk/VAaPaTcGvXUZFFdv3k5ZeUlK3DHTUw1jee+InAULwUC9UJUzG6GyanwwM92OKdzK9lZ/Y4Im1I5WjK6bb2Ay9I8PhJGux7e+Lg69uOhT7nrB5FJgrLxBH2VKfR4Ym20JmCzrOv0gFTBCDaIGFytBEXtjHDAR5Pjj1HgS8HEPkS86FsKlTDn1gOjquArXJpldA58tBwpkLvtHZ3M42daoAYt7PCL7+KTVCiLS2Lf7rq2/dyYKNa0q4oQ2h6fu+6fQUXNYcxdJmjIivKPp7YT1UHyGYRipmb0pYBg7GgEjVH0s29ZhMU3DFEFGaeTiLLC4sq6MhtpGEW5TMEYSBPAoPeGfXWwdQK9DxaAmVp55veHo+YmafgPfg8/YU1yPWIkRKEYLav/NubN+9zUeuY1zxqr+5V6+cDYqfydd9YmKE3yXruB6QAEdNcBT3Wi/8/Rv3Y3YXugD/kSM
 fMUx4lQ4
 jtqDNDsix+jJ4ylA5O/PzXbmzIYSCp7Uk3l68MvPqlj7mZZRMNeS5KZVjxdAYYpp/cCio8L1vx/H0i4S++SncMbpdW7leqE3xQjMFDDFRd1jnIinhMHatEEhsV45SP0L37Y7dhfuRgkMSrFtYB2JBokS6+cjGW06Fn9Ytb7VcuiwC3Hu0o2urY9YCYe5PymJQkW2LHT7Csu5+BrMNG0IFezjbG7PZOSAH7JeCe+IH7otr26RTMebaURleYJ5BOzluRLeLcHnfutY2fghf2S+K97KKqhCu+gjd/y80dVwPN3YbpUyxnO8iTufm/M5WbJjve/pdsfqIf3U0dpLVy9hJ4w2IPd9HYbuZiLxL3NoQRARgUvlknmBY3E/2sJOrlT7ICoTUpLCJ/M3lMtGB1AGvfPQT/aAm3AsKcWlJJPHZubs8ztNU0QUjYrAd4L1f3Txg9J5bWoUqZ3vR0TmbTAcIm2ftCYpX/wAb5NbAzHgEGRQDrMoHQ6/fwvBGt2F/7N2awp34OZBE2iah9hUSfdVwp+QUSALT2jqQS9Y1/8pQEzriJss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 16:29:30 -0800 Yifan Feng <evanfengff@gmail.com> wrote:

> damos_commit() copies the whole wmarks struct from the source scheme,
> including the private 'activated' field.  The source scheme is a new
> one, so the field is always true there.
> 
> As a result, a commit turns on a scheme that the watermarks turned off.
> If the metric is between mid and high at that time, the scheme keeps
> running, though it should stay off until the metric goes below mid.
> DAMON_RECLAIM and DAMON_LRU_SORT use the same path for commit_inputs.
> 
> Save 'activated' before the copy and restore it after.  Do not restore
> it for DAMOS_WMARK_NONE, because nothing sets it again in that case and
> the scheme would stay off.
> 
> Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
> Cc: <stable@vger.kernel.org> # 6.11.x
> Signed-off-by: Yifan Feng <evanfengff@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

