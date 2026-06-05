Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1606CD6E79
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A626B008A; Fri,  5 Jun 2026 08:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E93896B008C; Fri,  5 Jun 2026 08:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5D46B0092; Fri,  5 Jun 2026 08:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCADC6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:33:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70C69C34F4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:33:41 +0000 (UTC)
X-FDA: 84845800242.12.280FC88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3525F1C0006
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:33:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B1DPtG4y;
	spf=pass (imf21.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780662819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
	b=jTP3e0fBahEewOYBSmRuCqrNBZbHDClXUumSUvqBQv7GS0Ghop8fWIShzQLLi8BrUfHeWH
	epyFmArxuURwUUWPE5jT1Y3We8K1QsZgME21WvckN3IK+tpvwHTuFWUUENgr/9qPOoe8sa
	RhVecwHIiQp7utS2WbcCQaVmY7FvP+w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B1DPtG4y;
	spf=pass (imf21.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780662819;
	b=7R4zFlj9KJxnSKJe5Hnvl9652MsYZ7YSUyxTdxdkiHtZctZupTEQv2JHfo9Ksqpf4QwyPm
	i2FJeF/JEJ3qkd/EwYOUIwKJ7xmUuiEAgFOxdUZNOSwFSVWb/A9wU8lZZVGMrNboGiR0G1
	nAAJm4dJPmzQDKqkUh1Pum/mN/Z6aYs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780662818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
	b=B1DPtG4yQ71+L1H4w5/Zukp3tU6NfZbGg4F++cBpd9h8xd4nSg3jCQ24fWHJCQIxkT1n+o
	OaBFpd46D7FBgeieROp2wBXSAegboqfxqnV9h9EZxm+/PPXk9NY5LUYCv88NTcdcIuufQC
	P94u/NvQbvVgCR6nG9B9WJqzxaHDn/0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-nzUNsamkPWOQlxRsoQgsvw-1; Fri, 05 Jun 2026 08:33:37 -0400
X-MC-Unique: nzUNsamkPWOQlxRsoQgsvw-1
X-Mimecast-MFC-AGG-ID: nzUNsamkPWOQlxRsoQgsvw_1780662816
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490ae4d89e2so20142435e9.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 05:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780662816; x=1781267616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
        b=K8IcAV7C3hTHPAJILL8E/sc3s5j2xUmS8TW+8+0Mkrt265917DHdDsKUbMvQB8167b
         F9H1DRb1DWhvYR1tz3ZxPScRttFdI/pZJZWJt+zQBOcUH15FisgtAtcM66Q7dWclh5jN
         wRN0K2Wofx7EpAfU1MeLgRwgFCuadMH7ExdpzdXGHBDa+xEw/yK6Pwgc8H33BwQkYGW+
         ssWv6IQECloHAEe+lTNgwnQ8aeh2VE/q30SVaTYly87D7t8byR7wlDAQDHQnRAKVyeCr
         E7qyXEVQ4neYBpaO9P2VuDgNKyHHSgPmY0+v+tUNWP1IlxPiriA4+jlTNHc573SCyVim
         dviw==
X-Gm-Message-State: AOJu0YxE9sIlZswIYl4sq0QZz/kirbFojmk9balXIJgujBvT3RZiXpzh
	UnwFva6U9hik4T1UoDmUsk+4vQjFXwgNG7IKeUX15lnvP6wPZbvm2sqX0w/9hfe3ODRMxFUTPJG
	+waxK1b/IIeTzjXY9OQB0G2X2L6cuAHRWv2rSEisQWITntt9qDMkT
X-Gm-Gg: Acq92OGmamxnZ0mHQRIxkR5mGbbjFI8kcLdET1yLdmVTh1zmqoNYTnid87qelaw2o2L
	FPS+fPbV5oOsFAbZPkEfWA7sL1c4Wfyq6INPFB8xVOrW5bQB5NDVEZxm6XoTeGUq4prkrjNvZNM
	nu5J9mv1a73hOW6QaQTvQsDofJshAflPG+9xmz9vd0PO3o3y9nMDQL9MmqKDFLCaHXwKn4A5Kdq
	8voTN7rZ+XkV+Z1vQ6YbziLVraEGgla1SkcCbJFkneTXuPLTsxwnDOClJd/NTzmxk4kbelERzx1
	HaYk87mTOjs07OuStYdgVIa+yEI4oWhudPmISdBF2eS+NUx9oZkDzmjKQvkIwcXohFdR8uympNa
	Flf1bcw1N+GMi47s3weauiXccgfMtFS+oGfKjMePigtqALqWdWFCr6mcYEs9w3+rEWEZqBzgEkE
	bUuRnmuQ==
X-Received: by 2002:a05:600c:1c1e:b0:490:bccf:2bd6 with SMTP id 5b1f17b1804b1-490c25f1143mr58625675e9.15.1780662816304;
        Fri, 05 Jun 2026 05:33:36 -0700 (PDT)
X-Received: by 2002:a05:600c:1c1e:b0:490:bccf:2bd6 with SMTP id 5b1f17b1804b1-490c25f1143mr58625105e9.15.1780662815924;
        Fri, 05 Jun 2026 05:33:35 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-1-92.pool.digikabel.hu. [84.236.1.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4602cda3651sm12702780f8f.32.2026.06.05.05.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 05:33:34 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v3 2/4] tmpfs: simplify constructing "security.foo" xattr names
Date: Fri,  5 Jun 2026 14:33:27 +0200
Message-ID: <20260605123331.2621677-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605123331.2621677-1-mszeredi@redhat.com>
References: <20260605123331.2621677-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UXT4fwF3fI5HKWYFSu-vfzJVU7EqbygitH1XM8gWmCQ_1780662816
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3525F1C0006
X-Stat-Signature: 9ppbyubj34ngz5ubqi1rxsfjg1ku3cfy
X-Rspam-User: 
X-HE-Tag: 1780662819-65523
X-HE-Meta: U2FsdGVkX19h4Y1q7QtMd1RYGV3DqabjRXZFsXW+FuXYHcPs2nGIGfroOSOMlqbs99fedmZ9TXeWgosQNcYtOsWDQRHmykyJSyDEWbKRXMr+ZvCBrIS9AYUPpyCnRbWujQ5OYaokVAg2HThUCipK5u0CoK9dS3AQBBm6eow3oUNRzDxUaVmoa9twfFRjsoAdsYUWHKvNYON10N1+3nQywa2v/JyvERZVUEU+Os9fPqeMl1w3aGebGR/iGgbuUU0IM1T0GHWeL7TB7xN+BgNM4vQ40AJN6b2OBhq/4IeCE2lABflswSD7SukSZ6m1TnwhshtyN8ZSjrC7MGk/kX519XBUyCbtbpmEg00tdLreZbzD/GemIllrHhr18nbxwSFtq/+mLadR9ccJziFui9hmrgsznIy/OhbNvgqrROZoeb9PCeUEtFKe1/z79aY9dhh4bhfJXFAqyYE/FoUwztwUKh/mrlCUHIZfHL2KbXeL6xM5KqUo/G5MKNX/FcksQtmsxjG+O/Y+8EkVbaMLTveES/BZ6zX37x7eqC/3VeQt2UO3uIiW19qdFQA3EUh/DLEtS/gR1RpGbSXge50pV03n9B25lAsNL6ZLOa4XB1atYLDlR2n+QNKxxpySNCcUMfD2ZC4jSi3zXXMkWdg9sFtzYZ+5ACFRUN1huho5QpxS75UL4gN1sV5hcisLNKa1IbY9SNhVjLLqGHh7NrlD73gnzbI6u35t6hAF+gCH6OAIgNMdd1AzV5jAn5VY9KrzCwo3vdpv8YKUWNCoA9tGnOn/xJ4WTRzcHqAsUSO1PA+UiwxBgiGN33BNBafF4NWsW07cZxx0kcau9IQxPXJw4xfLxZh7FR4PRTt5Qf0+dH4F+AXtB3CSij2GAGcLYRu2oSzPKVbqjiR0ZDr6kr83jq8CX7aJ65OKohDkwbG6J1Wg4bJVxwnQ9HOyW0raZAm08LYVaXt35YWW1rKPMmsrwrb
 eQSXoJyy
 nURH1mWcbyw3TRfMqgZP1NSSvsH4RljRJuyCccVSYjETn1ZUpM70lR/y7MGBxJt9D7WKnRMrdLZGvpvr69yfJyczmnQ3AzDejcfKKc7bmT+Yhuh6PHGdb38dAa8o0BI3LFu3SJgeniLctzerEwZ3+BBYRGaEAhcHbG8zoVUNtnmQcjdqzcf7+qcWgAM7m3jgSwg/TwLhjEoAls3bbzVdFmvqs2C5iiJRppHOLsd4dg7BKGG8Qu2DPB0w2gChmabHDt3vP3LtmgBz1OmGCBbBrOvjh5W4XS/36yi0u02BLKBQ9Z80aD8GxTMXzjVwQWPMwU2YD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use kasprintf() instead of doing it with kmalloc() + 2 x memcpy().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 mm/shmem.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..c7897570fc9f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4232,7 +4232,6 @@ static int shmem_initxattrs(struct inode *inode,
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	const struct xattr *xattr;
 	size_t ispace = 0;
-	size_t len;
 
 	CLASS(simple_xattrs, xattrs)();
 	if (IS_ERR(xattrs))
@@ -4260,17 +4259,11 @@ static int shmem_initxattrs(struct inode *inode,
 		if (IS_ERR(new_xattr))
 			break;
 
-		len = strlen(xattr->name) + 1;
-		new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
-					  GFP_KERNEL_ACCOUNT);
+		new_xattr->name = kasprintf(GFP_KERNEL_ACCOUNT,
+					XATTR_SECURITY_PREFIX "%s", xattr->name);
 		if (!new_xattr->name)
 			break;
 
-		memcpy(new_xattr->name, XATTR_SECURITY_PREFIX,
-		       XATTR_SECURITY_PREFIX_LEN);
-		memcpy(new_xattr->name + XATTR_SECURITY_PREFIX_LEN,
-		       xattr->name, len);
-
 		if (simple_xattr_add(xattrs, new_xattr))
 			break;
 		retain_and_null_ptr(new_xattr);
-- 
2.54.0


