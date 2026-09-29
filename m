Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B04AC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 03:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2664C6B009D; Mon, 28 Sep 2026 23:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DF26B009E; Mon, 28 Sep 2026 23:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1537E6B009F; Mon, 28 Sep 2026 23:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E19C66B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:42:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52415803C9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:42:59 +0000 (UTC)
X-FDA: 85265403678.23.3451B61
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf03.hostedemail.com (Postfix) with ESMTP id 481DF20004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:42:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=IO9CGq0n;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BUefSLyP;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf03.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.137 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790653377;
	b=43o6keixCYb/RGYzXE6jWct0eHYLi+U6zkjFWYfMmoJHI3AcnmIpmrZ5KYW17viY8lHk7S
	Uowkyio0hbsj1hEtKFyrKmDlHyb9T3KUdJFH04dwLcRvt6WyLJCPs4xrhuK4DAHO58B+aa
	IJ/jYd4EOlBa74N8i7m224De81nUAyU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=IO9CGq0n;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BUefSLyP;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf03.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.137 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790653377;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2O/60FCivWhWCVVOfomZmHHuRxTPAq2UvXz2LKlNcDs=;
	b=8J71Q/nnPLkneQs70LZSFtPOylru2wCIwVy69ajVk2qK+BGwrl7Z5X7Er3KpB94TQQ87v0
	8xQQ//Atf0dwQ1BPMWQpcyqXzRf+27LCdfUb6IbHcu6fKlAtTl7a1BeGRiReSmzLtmDjhe
	esjHjbq2a9AdEUEOcVO9cBwCb2vDsRc=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 06FC41301935;
	Mon, 28 Sep 2026 23:42:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 23:42:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653375;
	 x=1790660575; bh=2O/60FCivWhWCVVOfomZmHHuRxTPAq2UvXz2LKlNcDs=; b=
	IO9CGq0nVjFm8570ZyKM27IXYcKPj24uoV5oacziNQ3brhdDmFbxyT0nT2TVWOjV
	9U0LCv7x960dMNNFT2ZwoTfLJEtsb1b7WYfmjuny8+MJX3nhvfNZ5XAZrPPa7bjM
	cEmgOjmTYfjLoSTVWSROU1ABqE0dAu5U+eBwOt25CdVk0JsXX/MEHWa80YYGJydK
	Zlyxd4ROsv7AuTCMTefhDLOvS2kMIb/yw5Zkf0L13qd+X9MNrm5qrwlQZYwo/SED
	FegfyydBZa1ZriG9IpSMVPUehQop+SbMYFjR9q/UMK3bRec4tBNnpzx0VZQ1jtQY
	Z7A+zY5fpKZ6+eCJxaeTDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653375; x=1790660575; bh=2
	O/60FCivWhWCVVOfomZmHHuRxTPAq2UvXz2LKlNcDs=; b=BUefSLyP/rkSO/ut2
	7b2if0LHKCGOmNT2Xrqx1RQrDE0UrwT6mWotfuWdE371Vs6k/5eTJlVORtjUlRl4
	vDen87HLen3IwDO9NWQhNqwuHPiWhKMvaf2Tms+/BFR49++jjfQ+tzdM07JJjfL/
	6oT3tCkzAmtZ6ZWnEHYXPPQEaMsDOlwjC6Ts9pUn1fSUrVTdah5aMI1Wgws/dKKk
	zTG5Fkn4lfcVp02IwhDdvy0x/99xU7QSWd9sgavNtpkQ2A39TP9Lldy6MhZJCfWD
	VG3kl0qc75kSEK8T0gEQiz8KV9SkL8SD3ZHTEeODVFecUaXNMXR0SSdRn52rKyc3
	bqBqw==
X-ME-Sender: <xms:vzO7apxeKOwB8960HYdX2wEZWf8hG0-b0MbfQJ0aurUbwjvyI0HzFA>
    <xme:vzO7asOOAWJcXkwvlKVQXpREg9_qmIKZzWHOIvgEjnwXoG7B1i31JKALzdI4yj5Oo
    1bbCdGocJhKM-AcU6pYzkAKXcLqLliFiCc7zRfmjVJeLeUVrGHD>
X-ME-Received: <xmr:vzO7arhPeTMucOaOkGJaNMh7xWd1QqaIqlSfiSJZLYmqsVNY5ZHy6VIrkdBhPOm0xbLK6cTecsAUGGrmVT4Rvqux0QyHwfI>
X-ME-Proxy-Cause: dmFkZTGoJB+17Zq7ThrEPjmxn4ZGYu519RzWwVi/88aejzKjstMboztaed73ef7D6avpE+
    +4ud1a3y7i3orjwLfnXoctNyz4isc8MlqqkCj9w/LgYTxltRiENCW6GCIqrBIGfd6BoOtn
    3U4T9DnMQq0t334tHmkLT0tBGbfhvTaaBwaOBKtxwtl6WpY46qwankbHLMumQlIvXZxJZX
    MK4M+NdZABlSsm1lFGpu8Zoavf0+po6/QQ3FmqOSdXOPNwreWLw4U6EONlQdAFPuoTNGlS
    rFYPmLdcGE1rV4M0fAMpJKofG+st3+8PfQ+b7I9sMwGW86B3jq8HWH1QNmIbUmtd6GqsIx
    3DVTTK3c2J4I5ksQ7YyAt2ucbNF9r0AlsngiXh1ZkIv7thtpYXLNnTUIfCDQfndn444S46
    l1dh51qZhsKVnaNR6bMarDeu5tNsrUujIGjUBidPSanYSk6e7/kUoJs+bjRxMxsvdwHgj6
    HKnMlgAbD24F8kSuVHwT2UZSNIiB+cS4WDZI9tUzhwFoGRd2lPAtPEJSXm1Pe2LV9JNLFp
    GZDEgrMbCuznyjBU1tR9RO271343XCEitk5ltMl9yuFi2TNY/8BLoMaBLR3qdeiu/TBDeh
    6iPoZ0/BmrQucexrf8RUmMuStwUqtHfY0fumNrXcrDExj9+GXZGQyED/sRAQ
X-ME-Proxy: <xmx:vzO7aqXl35KyDtNVZqU_B_sQXFLoZTfUk79lE_WKdImBnUegDQoaFQ>
    <xmx:vzO7apxilpgaIJQYhGoMG4yYHtVRxYaJH9kAPyhtX_q4bwPNHp2G6g>
    <xmx:vzO7alM6nb3XkoPNmncM9IB5zYXVqe-DMzfNyLu93kgkQQBmjM6Low>
    <xmx:vzO7amaEbVoai8n90Tg8O8x-BOqC1HBtSTvCGT1QDh-AkxtgxloLIg>
    <xmx:vzO7aqpmPFgEKPq0kHh564-Ucrq4-XCv4BztJZdZfouHRpbhNK6oprBI>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:42:47 -0400 (EDT)
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
Subject: [PATCH 3/7] coda: don't d_drop() early.
Date: Tue, 29 Sep 2026 13:36:03 +1000
Message-ID: <20260929034158.1455429-4-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: kf1cm5hwxufp64nrs4cceg4wndxp55fz
X-Rspam-User: 
X-Rspamd-Queue-Id: 481DF20004
X-HE-Tag: 1790653377-371376
X-HE-Meta: U2FsdGVkX19CIjd2KlnlL0NEJ2MwW8E1yVfj/RE5xxCaTqr1NsjYQ5G6/uegPHKi3fsg0lr+jcv/KeKQ+lLf9dn46ZmRJUj0Wpmlve0Ukyz02iXFUUo7zfEOajGGJe37muTNnhv4COfzYdTGUvW/KkOR++X0cpdtPTokPSQYdCbNfOrvP1sP//EO6eCj5VAsX3mFGElg71Iaef22OsMov/Vv6EkakP6wXi97WWrRdx2JIr3D4si9p/S2bTponxgJ9rgqOzLc5LsdmWEF32gt7B2gxJQ8EEvkKAeQxZiwZNdUZEeA/QsBc6uEMqOVJSwgVACVkCKOXI30sq/+BayNrSReW4DBJKi7h/Y+trCTlNshsel9uXCo9l0iG+gdM4orvnE98RSJpXvKxsn6vMMEbDWthUnu+UKyMnXDVaqmDnieYKXMYOQnbiZW7i0ml8DWaFvDrAfiv+SwuEzzu30AMU0VERS6Wk4qwUKK3W0QO1r3dn2NShoKUo2m4LwXAcjdXtgUFfS6KGT9I8mkvb3TpwbihdjavxDu4+ykfcRaT8bfvW3ooMDAHzxSlSvCuGH6+qYnKU+JrQGB6tMNbVz/bAwCQhsuEBitH9RYRS3v7wep9nH/MqxV+jq5SB8v4VgmYSME62F2p6z91dI7KrcfVcgPdh4AbQf3tF31UNXCWy0TvTxcM7J7k2OUD6A2XUnu8QJs7SsydsDHU/uRTsHz1g34ylWmHNE+tnGlgcyTKvGF6P9Qk0lHHThMTZyMcSOdRTeXfgG7Jz0TAnL4Htpyp1IV01o7sSmpCnyu479DGWbDRrn8euieqWrBFvKOthR2QAkIbPCVcw7fk6OuVkqf/7YIuLsOpmM9nfmTQZ7N5qaImBGDx2ZCxmqu5FoIHwquEEqEF4zZHiD5wQAqgTPxD9SeuG/GyCzoVSqi3TXt2V1zaLMDJuIvE0JLKcNS2ro2ZW5HdIhulpnp8iT6l6e
 1Gef64YD
 Qn/inBLIDpmD60sU90V9GMX4wPzWBFfDkgTfU3eRF0hKUFev4BlDOHJiDEZpbHMXKAX2fgO67fN/ird1DNTjquNPR/tVYb/v1Z30bnzklEUNFzWTZQP7A1d98Tx3XhDoR8SoH0mw2Bg/X4tIklXpHtpU35VwCVeveBYxzqCctFqPLitQzPDbQE+8Jfn54LvOsOMVU8RNe5A2n7DAAhpcyn0bnpmO/LUWcXWwlQUddn8YV+sMNrKnzZPNvmXOFu6o53OiN2U46sF1aqVlnCaWePbjXEr6PgV1bSFT2D+T3MIF8blwvqOLe7Iyf/ySEJStl/SWPwKJ83c9IJFuWyd773EJU73kaPBsBYiMn6PjhtSzSbj0KkdQC5q8bfWwaY/iAjfcCTc7qSvDtLzCophNfXzIjBwHDaEjFr65MjOHk3lCsWwcGUeXiqEXybVKnbez62gJrVgmch4mkRJzLfWjwbdIWm39HhJ0XFA7v4iJtSOf7hakhvmxHH+0BK3B+B3Xw5Lt64+m/t5KiJ2W1qY2scgTJHXZoqCu/dT8b8u79eKjDUaA/x485TsP0AGpo+Qx0SvUvYTHCShJgk0ZoiF25UIUnCLqLMuhq22zAY4IV7d/1KkWQklGnilpTwLBybrueYE7SQSFbnK1S4+ikD94dKGMGypSEEapT7pbrf/WT8703t5VeLIO+rvnLn2jui6hNDOJmq1B0DrK211ZsGcdbZ7z+Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

Proposed locking changes will mean that calling d_drop() could
effectively unlock the name allowing a parallel lookup to proceed.
For this reason it could only be called *after* the attempt to create a
symlink (in this case) has completed (whether successfully or not).

So move the d_drop() to after the venus_symlink() call.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/coda/dir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 67148edfadee..bcbc9d058303 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -249,13 +249,13 @@ static int coda_symlink(struct mnt_idmap *idmap,
 	if (symlen > CODA_MAXPATHLEN)
 		return -ENAMETOOLONG;
 
+	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
+			      symname, symlen);
 	/*
-	 * This entry is now negative. Since we do not create
+	 * This entry is still negative. Since we did not create
 	 * an inode for the entry we have to drop it.
 	 */
 	d_drop(de);
-	error = venus_symlink(dir_inode->i_sb, coda_i2f(dir_inode), name, len,
-			      symname, symlen);
 
 	/* mtime is no good anymore */
 	if (!error)
-- 
2.50.0.107.gf914562f5916.dirty


