Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CE0CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 03:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352716B00A4; Mon, 28 Sep 2026 23:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329B56B00A5; Mon, 28 Sep 2026 23:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2178F6B00A6; Mon, 28 Sep 2026 23:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2BC36B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:43:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8ACD8160383
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:43:21 +0000 (UTC)
X-FDA: 85265404602.30.285FF2B
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9A89C40005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:43:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=LxQem3Ae;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OyuSYWck;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf11.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.137 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790653399;
	b=XvFIxmosAgXXfaz71nDhj7qVv+gcjiCq+fiK2go/VASalI+2lr3rj5VCh/WljzRM4dNfkZ
	kgxXRbkoDl9oJz6BaCV0jGOFGY1kIfgvQR67EjqMqNp1W0VMdr4F0CLNfgzBzJ5c/Ci2Ea
	jzcTyawLcW9CirsJ61MEK7r8bihBTWo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=LxQem3Ae;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OyuSYWck;
	dmarc=pass (policy=none) header.from=ownmail.net;
	spf=pass (imf11.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.137 as permitted sender) smtp.mailfrom=neilb@ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790653399;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqEhO7Cozx+p7o/41OHsqkMCNNwlRf46rdwfInGgzf4=;
	b=XF8DYbFwL5m1r5lW5E24qkncilVIP9oQbNDFHxz+aVkwdtQqj1XCK+KwOdYJJR8teKIrN/
	exx0XrwIod3wHSGOpp2NejK9tDmhrRtYpnp5VaYSMs5PLxxlwTym6qR7psaDjwAjCRb+AX
	6MbkX/A8pTGFhdDEqbz6d2Uk09qwnIQ=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 5395B1301946;
	Mon, 28 Sep 2026 23:43:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 23:43:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653398;
	 x=1790660598; bh=EqEhO7Cozx+p7o/41OHsqkMCNNwlRf46rdwfInGgzf4=; b=
	LxQem3AeAIdgW2wUGqeNqnqkgRWQaHq9wDkFmB/9zLcZ+iIHT9dt/v7t/iXup9VP
	6WqyTwy+LxqGATI1WezGc9fEy0t37fqldUDR7Qxu5ZoGktwIwCThOQhQicvHKG2u
	y8Y6VjtkHIMYKrMcF2SyZ1aPQIYO6YBfDTJy/qXd4mYs8rj2o9d0Gm4WHs3+gjwP
	JJ/fUspMc585l2jVWewvTZl1cuyuc/rU0KjCRvIkWscG+pMvoSBmkHhI5fz4pg+j
	eCXomriAlE4tH7QNo6Ka4/FOyaYNrduP2jBP/JCmJPJ+kmfw88KtgIH0PhgI5wm4
	rh6ONHizGQvqayX4K/Kq9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653398; x=1790660598; bh=E
	qEhO7Cozx+p7o/41OHsqkMCNNwlRf46rdwfInGgzf4=; b=OyuSYWckGaG5itR4y
	yumxTNLaNORsdFn6ZpTXNr7EzBKq1Fgvk5YIAseZ9B77cCpZ0fHHpMB7SMgqOCyb
	xgq2y2I3ypWTHMlc7TBx94ABArNzK770/ALVIUMygT4d8eDv8r1/D1p81Yed3SO7
	YhL1fQbyfM9i9YeTvjYwImi1x036LhGJIOlpEdSVgJSY5fX0Pq5BE5T6JzTlraXc
	qyUkv4LkWXam6canynD0fWqIf0Pz1wPK4Vncr/hTAtB9YwZtCvznDcB5T5TlUo3c
	Htdd8pjyt0grv7cCU1oVx+NbBn/Vj+Vceubx/K64SUOn5OJIBN3N3yHBR/BOa03B
	Y42Kg==
X-ME-Sender: <xms:1jO7aqMq7p3Zqr9vjkwi-VJLeM1c8_hyJXeIOa67iBIQWM05HaBqoQ>
    <xme:1jO7ar63-_CA0BHZTA5SIKPaHXedcRWSvqSvoDST3uv3nGp4YDWYrWqxqNAjnOJvF
    Z0OMDy_OqWGH25KXKjgTmc7gDJtiNN2N2elho8f3MJcqYwM6qw>
X-ME-Received: <xmr:1jO7apdEMkaiJ8bXRBvFD_mBedPOLWBa2fPqv5q4yNRLABm3K56iFDr_v_DlZLmpZD4BdTx3QmnzNSL1dbWLjpJNLBGjgGA>
X-ME-Proxy-Cause: dmFkZTGTB6wQwJMDK2BlhP9ieoZtexL1tb4zR3ndzWyJLLylmMRFItDY6TtE2FJJnT+n9Q
    EA6CVH8Q6gG2q0z9eQymFQCCGXw2+bPKorNcLTcHtn6fe93ZdKVlCNeXpSVxjpIWPnE0uc
    R4cSRx11BDHvcVwwLSaXZYcSNN4uv+OrH4LpadiDCk6Bcm4w9Hs9AKTMCbQiCTdXMUg6Ak
    Qm5fUt4YyHFWpJ/BrTyArilq7pXWfKlpAWul2kfKNjb82sfwswf0FjscN0S8HtzC9tCLhj
    LmdhZ13ZxXliGQ357j0bxUi4bFw4qlzJKWjuFAMisvE+iZjOO7jJZKzba9DBfSYpFlPNOA
    e7Nud6FLGM7w4sQZ9NqRHWDmmgNYAVTeqgj4feEgxkJuOL85YTQjtF+sEG/hpsGZpQEr0C
    6fNwYiRIdTWwxl6Auq1tq/6V4UGQAgvvvv7bs+DIVng73Pik9D4GP8E2Xrl1pSUY2JlfZG
    9tMmUGoLeAdhujjliX8jHGXWu7ZDXH9JxWG+Ggl5G1RCx1eoucDH8rcJOlHS7CcQxhkcun
    Vl8fFThOqBBea7hViAzR0UEHyokxUj9S+gRoS6w2PEZ03b2rZMqiNeU4h0DdgyZkkNGOP4
    vmYWYEukgUzkG/UMKaNGTuWxomMedSbXOObNTsEz42yCdPoLy0jDcfyrkGOw
X-ME-Proxy: <xmx:1jO7apiCNNccNouf7FQ9ebSiPg-rqpwEvL5bd_nBziRrkuI-veAv2w>
    <xmx:1jO7ahOIox_9WR4YTsctfrwOoHRpnOu_7CacKaBJaZeHvLK2D2IcgQ>
    <xmx:1jO7av4Xk8lAkrSTk0l0Ivny-v5OJ0SQrDf0T6DWriTEywgtmBuhZw>
    <xmx:1jO7ajWI6PpVoWR-e92dkdiE00V_a950P9kUulmr7mCjsXfd9txZ9Q>
    <xmx:1jO7atSd86_VZbzI0WOPyxULG3ZiL725tkxqi4MkA-uVixsDjwIjV-z1>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:43:10 -0400 (EDT)
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
Subject: [PATCH 5/7] hostfs: don't d_drop() before d_splice_alias() in hostfs_mkdir()
Date: Tue, 29 Sep 2026 13:36:05 +1000
Message-ID: <20260929034158.1455429-6-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: upyrugihgty56m9xd9o883nwzbxg4bj9
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A89C40005
X-HE-Tag: 1790653399-598121
X-HE-Meta: U2FsdGVkX1+Q13I2iXfqlF/ROpsuFPswxCLMRXpwBY3Yjt8mjDdaSrCzjunr+lqZ0d22Wry4XyLTr33s8BPzxn+N+0LeC0ZR/VGtzy0Yy3IuLtHwg6fCksbSb0ydU8AFAYKyI4Xs8CAKIspBCH+5l/i8Ke1oSFWbtvZYuFm9j2tQwKE4Z6cDHfT/5Q6dy8RFqaBEZei3fqJPJgQvgAYlw5b23FgT5NedsLsTuhMC+csqOPePFaS1GFTReb225cTrH5WmDpoOHIqk+uAMQeeRwHAhhkCGyqlIYj569ByyitSJ17fYQUzw1LitjIHyJBcFSdDi4mgog02V9M+V5Ok7SBoFh/FXV5LSX6llpok5YhYwEd618KeuV6iHgORYPDscTHHvjWW0e9WoVNXlEb2iMU88zXHyijxkzElPio7rb9VP/CAiPfPJLtXT/vRQgmITQrbKugwawylPbF4/R+MtAwkeuot7qieAQZSEi80TpuFuMy212u29cwaEAh59/gi21ymEEAqQ3P+LYw8tcSGQCHg8Ynz7iwM/GstEASgBG/+w3j3oBphfJi64Wus7f/aTvTcPXKrLnJqlfVmkxas3HqagAJz8ZbKI/OqS6fwZPCHTq21lLALcbFEkT7sszXBL6thf1DZ1juuhb4xGpN2qeC46OJ83Zpzqm1jxVxaboeikYCrgUWMl+xcJszT/BoiqU8FEPo7mG3na+NU/yWjDLwr8TP46qQO23ktsxbpn1zxXGZLQl1uF8RXC7aIuuq8GaRdGjIKOpzuoDfTmOBKv1Nqvm+Shy+JFpwN1fS0PR13h07pGzRTPWZSDZj8LaFVrRoHeGze0boCIICn8G47+pQtknT4QHiRz/Jq1HyYR6J+Uw6gCQdA2N65o46HvFUIlKeMesQwO+cVb0OyGFHEbpq48uxMfMti+grhRRmXgzr1YpT8AHoGDLvgylAqwbOODuihgjrBAOG0tlHsAMRf
 1NmC7K/g
 RqWr1PC81JFYe9k5x2Q10qHlTxhyo3NrpL1HX8Ca9a4OzL/F9M6CHElNlJRtLlS4wffzncX7CbHi1f1ks6XrPo7ME3BgvjOIfFEiIG1FmfwU7CVX5piTuVb7Kr/1qHqZczSdvtDNbST5A3Q1uJ93RNU7n43L+cF+KmtABnZUuGm6LLDK0ZW0Hwi7heCiuzCrLEyKa6BV1peint57n9nB4NXjC9xf55VJWrG55H11QhpdZbaxbRf3UzcGNagx9LKWy7O5vmnens0nDxWp+S8bnCtuyp9HtERnL1JlLNAqSPt1133jpE2wzmF29aDmUQhnJ2+zQUkgHOK/xAY1FaeQDdzKnS2K5EKfFpQduEBFxW6wCvwb8ABtVCeGqgcvNIwRvbJjfvcG/ZemMX+fD9S7HWXhmW832j4pW67jF5ygElkvSnezvBtcn8y2zMmQajnx9Mj95i+ost6AVlYQT2ujIOb9HP1JM3ZbZX+5OBK9QtjitakNKw6KaJuO+JH8IiyNUQPqtFwZa9fZdn9nkYW9dRD2oyWG+fEGZXzqe7m5UvHuOMUiLdmaoRNj+j4esywgkKCnEVasvQPexmfHsO2TNvRK85yBNwjJev05TZkgKC2gqlYeUIPDM61IZwHhJYkiG5eA4tqhbxiUNzQj/wEJXa/CAyqsM/tDhzncBF5/vKIiVsOqADAsSSmfjLN6bOOZFF8Kn1iMRy63cpZqNJlSKUu3jXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

hostfs_mkdir() uses d_drop() and d_splice_alias() to ensure it has the
right dentry after a mkdir.
d_drop() is no longer needed here and will cause problem for future
changes to directory locking.  So remove the d_drop().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/hostfs/hostfs_kern.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 7add056d47d8..f68e75981436 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -700,7 +700,6 @@ static struct dentry *hostfs_mkdir(struct mnt_idmap *idmap, struct inode *ino,
 		dentry = ERR_PTR(err);
 	} else {
 		inode = hostfs_iget(dentry->d_sb, file);
-		d_drop(dentry);
 		dentry = d_splice_alias(inode, dentry);
 	}
 	__putname(file);
-- 
2.50.0.107.gf914562f5916.dirty


