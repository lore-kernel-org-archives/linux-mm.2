Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48512C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536056B00C4; Tue, 15 Sep 2026 07:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B276B00C5; Tue, 15 Sep 2026 07:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423B26B00C6; Tue, 15 Sep 2026 07:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12B5A6B00C4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:35:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 611D71C22EB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:45 +0000 (UTC)
X-FDA: 85215791850.28.1A1E118
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9C74FC0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HEvP3jmw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MrvtETchtY74VhNhdP5L1TLK5JZUI/4E6S7ET6JvLE=;
	b=GvY4Ka5lYQxVNhC/FwfUJ7d4Vc2/b8qPJ6OCliUD5fZun08sjXwogD+4DDbZQQwKTapFA6
	hjxTFgg1+lWYIhQsO3j3QYFyYcZVzkZI9TRVht6G8VL22k1xxPwK+D4zZfoq1MYvsNDdVV
	XktCyYsBUyjYbb3kTlAJR5kiYOvAXJM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472143;
	b=mf/J70HIdMhwOoiGVS5xD6LVy2XncXcto+6Oqv+HExNfPI7xqR8vP8CqVLyGZeD92oK0Hj
	2akgj5Z2Ba4DspftsiGmpQDkobxyOHhbjCdn2GepNLHw5WX/9mM66q6lqRgpC5y//OEDeB
	iOmacIEr5Kzx0E/tT0zcua21eTlctW4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HEvP3jmw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDB76415D0;
	Tue, 15 Sep 2026 11:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738C21F00893;
	Tue, 15 Sep 2026 11:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472142;
	bh=1MrvtETchtY74VhNhdP5L1TLK5JZUI/4E6S7ET6JvLE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HEvP3jmwChKyeHdJ9Jg3mkRQ3dA8Vigmgn9aN70pEyemzrmDRt+HBflUFt5dg79cy
	 nmMA9QgA22+3lDgeMbCub5jO8UBj8OpN+VauBt7p0dIet/Okhi/+8AxBkWACPQan5v
	 iQ0CGGPOK3xa6Bp++Ti5WKZZzuDFnPibEu6y50nXpqvsbgWZb46/QO9Fp/CohuBmiy
	 4H6uR9SGKU0GNDbp8fufyXpe2tUFSDQhZvLM/dJkrYmbemLCUe0oHuhVmELpbcwMRe
	 lCVZjHzvU3NtKwOBPfXEcCycM3OMg+ZekdadygNaeC/QE91ROYMdhIuR0e/OpAPmhY
	 Sv9/raR2HHHcg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:20 +0200
Subject: [PATCH RFC POC 34/50] sctp: install the peeloff descriptor when
 the syscall returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-34-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3999; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jxeTmf0RLLPrfqfHR6VaW0QlyLJFo9vgcxMApZCym7U=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Km7cNv2coTSh6uv2SKV9J9xe1cli18O2fg9bbWMR
 XmeZEFFRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQuPmT4ZzXhBS9/eF7krI4v
 9nuSVLY1Xi4SeKo2SeDbFrPXBqrPxBj+yrHXSsXOVdm4U/HG2oqX3ly9K7UCc6pmru7Si/L9f7W
 YAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C74FC0005
X-Stat-Signature: qj6tc3c14ndx519tm4cwimpgepd838gz
X-HE-Tag: 1789472143-456179
X-HE-Meta: U2FsdGVkX19FPDmY11tXnInWgeeLWcpzP1RHnt77wjHlknw99JNyX9X19c94pYYMOOK85HPDp/CgMeCWGivSTOS/v2gMpOAlhf4LnCNMbUe5tWr5w2KEOMnGcRYHOWZ0ZizFdoCDbumFXBUeP2c8bASzuB5g7cuA8h/xZc37IHr2YmoSSaj934oFMhLe0+R3WrGSOPkST0brFo6lh51lEGuw2Au5itjn8pllBhNhH8pbHks2AlcI4RN2Z+kc46hAGEpysixQ5jiYlfeHLQHq+8VxRQkM2N3aLhgHdcGB/57cvutS4IeXcOJKqMXYY5bX77t8xbN1ydta4jgfWEl3+O2ZWtSiFlcQEQ4+oTNFNFvUN++C32uoRHUuyf2cVneV62Xuc1cj5cgMFVBSTR3+up1XrSH0hyKa4hzea3YJyNInxPWX+3L3mGIcAVqJBN+TrikRAup8W34g0L+3RQmXTT+tiwsE0PudLTucxPXZjpgv2SyZL24s4amB0l4oQVSQRYZ4L6Q3GoVR849VQKVlwqfb8YUJgEwTZRe0kXQrD0oj29MfHfNEqiUsYvQVVCdRBy0IhVlhBv42a1EMWk7K9QgWf0uamSqsv1awCBQOCWp3qOJSoGcS5x4zAPnS6puBYMQiKDbild8LlaJh79Da+a25TdaD9+W/AdgNV1e6JkuPxWmPozN3X15ZgwmqFhGxFv+eQgcRKP1nInClVYxQo+GzA6mMYEKXkveM7muPg0WVugBWc2CTb9GlF/ncoi60DR8l6sETs+yBtry4JbK7vXCZMReReZdI0qWZDHipuobFELiTi8XzM+K0inQUjAi0vDwlSoqu9caVbAMmpdgGFDJa+rp6xZuPayNwvmXFt+4oKqWxvl/+hyVBc2j8YsNudl31yk0UMt12wSN8+oEjw+PmFGOdgDuEVp4zCVp4ES3B4a3iGyo0z+c+rJuyqR9jciRAgSi60+TIy/wlaRl
 tfwUstVE
 sK2WbC7sN0a/bJ06HN0Zpp+8L/6F5cTG+di8WN3U4lVuUqd0opFQBTHgcl91U4+/zThOG8tdDqzHiow/SQRVl552Nx/sw2dicfn2yoSbPbATD3ZPHBMxt0lr8Os2MVlY/SngIZR6vtl8VSvAdQ2i3z7xxnS0BvZftqLrevXwIOYVAF9nRQZnUbNF/sBBjhIL1e0++SjO3dNRvUcM54RNq4rILytkXJpZ5Q6w7ELb+T37v85ezZA3mSygzsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sctp/socket.c | 78 +++++++++++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 49 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c7b9e325ec1c..b75c50af8c16 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5744,46 +5744,41 @@ static int sctp_do_peeloff(struct sock *sk, sctp_assoc_t id,
 }
 
 static int sctp_getsockopt_peeloff_common(struct sock *sk, sctp_peeloff_arg_t *peeloff,
-					  struct file **newfile, unsigned flags)
+					  unsigned flags)
 {
 	struct socket *newsock;
+	struct file *newfile;
+	const struct fd_slot *fd;
 	int retval;
 
 	retval = sctp_do_peeloff(sk, peeloff->associd, &newsock);
 	if (retval < 0)
-		goto out;
+		return retval;
 
-	/* Map the socket to an unused fd that can be returned to the user.  */
-	retval = get_unused_fd_flags(flags & SOCK_CLOEXEC);
-	if (retval < 0) {
+	/* Map the socket to a reserved fd that can be returned to the user. */
+	fd = fd_prepare(flags & SOCK_CLOEXEC);
+	if (IS_ERR(fd)) {
 		sock_release(newsock);
-		goto out;
-	}
-
-	*newfile = sock_alloc_file(newsock, 0, NULL);
-	if (IS_ERR(*newfile)) {
-		put_unused_fd(retval);
-		retval = PTR_ERR(*newfile);
-		*newfile = NULL;
-		return retval;
+		return PTR_ERR(fd);
 	}
 
-	pr_debug("%s: sk:%p, newsk:%p, sd:%d\n", __func__, sk, newsock->sk,
-		 retval);
-
-	peeloff->sd = retval;
+	newfile = sock_alloc_file(newsock, 0, NULL);
+	if (IS_ERR(newfile))
+		return PTR_ERR(newfile);
 
 	if (flags & SOCK_NONBLOCK)
-		(*newfile)->f_flags |= O_NONBLOCK;
-out:
-	return retval;
+		newfile->f_flags |= O_NONBLOCK;
+
+	peeloff->sd = fd_stage(fd, newfile);
+	pr_debug("%s: sk:%p, newsk:%p, sd:%d\n", __func__, sk, newsock->sk,
+		 peeloff->sd);
+	return peeloff->sd;
 }
 
 static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval, int __user *optlen)
 {
 	sctp_peeloff_arg_t peeloff;
-	struct file *newfile = NULL;
-	int retval = 0;
+	int retval;
 
 	if (len < sizeof(sctp_peeloff_arg_t))
 		return -EINVAL;
@@ -5791,24 +5786,17 @@ static int sctp_getsockopt_peeloff(struct sock *sk, int len, char __user *optval
 	if (copy_from_user(&peeloff, optval, len))
 		return -EFAULT;
 
-	retval = sctp_getsockopt_peeloff_common(sk, &peeloff, &newfile, 0);
+	retval = sctp_getsockopt_peeloff_common(sk, &peeloff, 0);
 	if (retval < 0)
-		goto out;
+		return retval;
 
 	/* Return the fd mapped to the new socket.  */
-	if (put_user(len, optlen)) {
-		fput(newfile);
-		put_unused_fd(retval);
+	if (put_user(len, optlen))
 		return -EFAULT;
-	}
 
-	if (copy_to_user(optval, &peeloff, len)) {
-		fput(newfile);
-		put_unused_fd(retval);
+	if (copy_to_user(optval, &peeloff, len))
 		return -EFAULT;
-	}
-	fd_install(retval, newfile);
-out:
+
 	return retval;
 }
 
@@ -5816,8 +5804,7 @@ static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
 					 char __user *optval, int __user *optlen)
 {
 	sctp_peeloff_flags_arg_t peeloff;
-	struct file *newfile = NULL;
-	int retval = 0;
+	int retval;
 
 	if (len < sizeof(sctp_peeloff_flags_arg_t))
 		return -EINVAL;
@@ -5826,24 +5813,17 @@ static int sctp_getsockopt_peeloff_flags(struct sock *sk, int len,
 		return -EFAULT;
 
 	retval = sctp_getsockopt_peeloff_common(sk, &peeloff.p_arg,
-						&newfile, peeloff.flags);
+						peeloff.flags);
 	if (retval < 0)
-		goto out;
+		return retval;
 
 	/* Return the fd mapped to the new socket.  */
-	if (put_user(len, optlen)) {
-		fput(newfile);
-		put_unused_fd(retval);
+	if (put_user(len, optlen))
 		return -EFAULT;
-	}
 
-	if (copy_to_user(optval, &peeloff, len)) {
-		fput(newfile);
-		put_unused_fd(retval);
+	if (copy_to_user(optval, &peeloff, len))
 		return -EFAULT;
-	}
-	fd_install(retval, newfile);
-out:
+
 	return retval;
 }
 

-- 
2.53.0


