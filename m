Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA0DCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C35B6B0463; Mon,  1 Jun 2026 12:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628716B0465; Mon,  1 Jun 2026 12:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF306B0466; Mon,  1 Jun 2026 12:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38A716B0463
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:25:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F20201C0CB3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:03 +0000 (UTC)
X-FDA: 84831868086.23.B408C53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9EACF20002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:25:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZQsKLKid;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780331101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
	b=UuVRvTSxZRqzwG1hS3rJGbvYrulSuCbfXuURh95G/4tDyOetlIra/5saXPs6Y+Jc5gdjDv
	x93TWUMtvxrT4W3UPvux5NL4e6goI5KwTO0YKJE/O0n0DXwiji14MRk4xjcpIyp28cFNrE
	mGt8XQqqwE/qOy08EluRxqsy03lXbFE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZQsKLKid;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780331101;
	b=O3wRGzzPGDOq1gkKCSkZjL0WbPvOGYOL4yECDsakSQYrj4YtH4HcwO2wIW+KFjqlmL4zbr
	WQvnqDIYaIkKbxOfffYizZ1qlANFbq4vTWYRR+XglPxpTyUOyO09IIKc5tWpX/QEbmVgVH
	bWJ0RisnT57zrY3eOsUuOYeAPn4dp6Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780331101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
	b=ZQsKLKidX8VJF1+keBrA55sgdxa4sZdeamm+dNhac739UtdOd19ai7RL7Fb1rxdpqbpRdr
	oYfks2W3pUWAjlSs6Ch03wjP4IaGnODFktvvv4NurwMxNxCJleGaPNjLjUtGhM3d3MRLY7
	p4ElwwGvm/ajSajKJnR4xj5sc2ycOUc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-a-4_uTedMlq6v5lVAVk79A-1; Mon, 01 Jun 2026 12:24:59 -0400
X-MC-Unique: a-4_uTedMlq6v5lVAVk79A-1
X-Mimecast-MFC-AGG-ID: a-4_uTedMlq6v5lVAVk79A_1780331098
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45ef93c359fso1734971f8f.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:24:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780331098; x=1780935898;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
        b=RncoCvtlrdbX6TuPI9HnCRHDZT9lFaQbklusNR46bxmH+kSbW9jW5Q9D4XMV1UYHVF
         0fpkSo2pRe2FxKGsGG8mk1ZyHBvkgAT1+xxpSE8EwT0TqtbvrRl5Q0m/TniIlSC/jKli
         Ez/C0x8gtYOh2pA3qW1h+XuyaXd1oOlRWLzfNCEKR6BN6tu9bdD1nusRJ+v3IfWM4t0B
         rq8dVt4+4AT8gKZEhgeNFeKr/iLGHxmgXxGTYg1PJ11MsKyyBzKpr5cTBvwdLKvWj7sz
         q4BPqwOFNnO4rOU/Qklp8VlfcTySZ1SrcfETHgi/s16cESIMZW2ger5BO63LRX4igy7Y
         Z42w==
X-Gm-Message-State: AOJu0Yz68oJVDwT0STorxINtEIEfTNMUCeHZ+lg8twLNdSqVjBZcGjRY
	3IF+kc3UzjULCb4+cQ1gpJ3Dt+i3etc1PFxMHjRY09NLRB9URRxE3fQo7vSxCaph6GjE0sv+b9G
	5FnWoxqwIPzzwJQ5cpUZl9RY46A+/bgnvr/4r6jR8iUnjDtrg0e0O
X-Gm-Gg: Acq92OFuJNRRv1EIZ5EdjWz1TxzoVIlDUNxwBOR2gYFKzJc1ut0zNK6sCXpJjp5mKns
	atsD6BiCDatnFnKVlPoNgazSx7jCKnllP2w5UfJ4wcjJHZf7U0g2D1VrUfz+syFUvsKRUw1/9CS
	VHE/tRMY6Bh7UmcTaXiI1vEA6jwUmgv3uh+v/Xxxcy+lwaibEUr9oI/dtMZkgzLKZrnv7dTYVPV
	nWMDrIKHA3vyRb/ZNMNfQlZCjQX+4HHisi+Qeuz9jigkwJQbHl23tSHXFvYoNWZvKjoRah3cwOs
	yC05a3Vib9C8EXDw29cas4R8LQlSNIxc+tpPxOTdnSVvZ1rXZReF1Z/mx443wFC2OF6sDnZmH/M
	8AaTPpX+9Lz4Og1nyzVjgF3YOvbdWv9VdB88CBIAX6RWZqoxSowOeu8Kf8MZQEXu1RzMrwssSC3
	SvPgXN2fDRZ00=
X-Received: by 2002:adf:f312:0:b0:43d:6fb7:fedb with SMTP id ffacd0b85a97d-4601754b5d0mr878601f8f.36.1780331098127;
        Mon, 01 Jun 2026 09:24:58 -0700 (PDT)
X-Received: by 2002:adf:f312:0:b0:43d:6fb7:fedb with SMTP id ffacd0b85a97d-4601754b5d0mr878562f8f.36.1780331097747;
        Mon, 01 Jun 2026 09:24:57 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (85-67-174-180.pool.digikabel.hu. [85.67.174.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef356b129sm33036213f8f.32.2026.06.01.09.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 09:24:57 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 1/3] tmpfs: simplify constructing "security.foo" xattr names
Date: Mon,  1 Jun 2026 18:24:48 +0200
Message-ID: <20260601162454.2116375-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260601162454.2116375-1-mszeredi@redhat.com>
References: <20260601162454.2116375-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wxC66xlay7UrqXWlrZa14Ilt8wayHH8pDOWJkh2WvW0_1780331098
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: d5ay5q8kmpafcufuarrfyqrjiqsyerdy
X-Rspamd-Queue-Id: 9EACF20002
X-HE-Tag: 1780331101-673326
X-HE-Meta: U2FsdGVkX19DPU4JEkQZq2Woujx6E1xca+i0PBq3mT5GtaXxg/yA61vnHQ0WqAyP6tkFcM88rzmUIlm3zx8keJUYt/P0EUFes119VgZ5AElyy7Fnm639xHt1gEhNHe4RZeqQATOcHqenmAKaDmdktp+g+yWq823E06K4RWELXmyUCCp4+vW8k1xvDXQhEo36UzdCgvfxa29Le0CYUSazyiBs83aRp0xTWFdRWoNYy1/JFDBbFFpooIILx7y+1QTwfaC+YV4FWa359psB7ZnoVE58KW41iM/rbFxfDjROvLtK32DTTjBBFOOgpSU/8mAo9B9DrttcRBUCoKZxr8eZXPt5KOayxv5rt4I10THeX9yEaCsrjsUOMIOWEdRBLghH3dpQGR/vv2EYixEytjGJzU6mYrpi3Q1XsLNUmvJy+KWPrSqeeXnB+rHOsbVA+cxPVY+uHC3NM+oKWJ+im+q0dGyG/HFBqP4pgwnv/WeFWLI8JYvSCJwcw2yIfBCQUHn0CP3qge66IxGBVdf386A78afm1ClsRuJHzVnhvIVzIbkntXwXvtWxPSEJh8XCtBw4Saw0k5hOs0dcHk8M7Fhmzp7jJAPT4uSU/EHSV7xt1u8sltV7ZFUmN6lmT54AmrWR97Z85Lqfg1fwffNRrUBBcatqI0BRrgi53qesSYh69dfLG9NcBrIzRWK4Avf/oyLVv1v9SI71OnxUAo4DksLV0TLQdXKfP9bdJcaGIQoCd6KRIn5mbZSdPnUyPhJvY0jOX6PDTFQ0zDUF0VouSPS1qCdvBAIy2mHLg4LMjieWYxB7ZNg8E82OlbXBHNcjOOP7rKg5befMSLu6DmXzAlcMt65TTYMosfB1SL3fIlZpRdrPw4GMPIHUxI+4t63TAitD4l1Yg25Yt7QGuraQYnS/XoFElakhlGuf3//ocaWRROUNduI3COun2dfWxpcb7TTcwK0TKBx66YfAuiVuwU3
 N3EIEfGM
 x/759ljtFAmXY5dWIpoMDXnpwSlZxninUKNk0eSNrQxFEK6HNrXrVZUJTYPVXDVlZFeavGZV6BqfjfLDSYMH/iIvEOutGDTgAjHGaG8jZuRMkxrRzcVPUP539Rv7YpIv1t/TOu6DcpKHz7jLd7ebPMM4Mb9xV5igOkPchf3jc9bkTZh841TYLUCDJI8F8Xvgf48HLz0Qv6gcOIDRuoY/vtpGD+X5t3MkyUBqQVNqM3f2RiOnmCT4+2f3YRtfYlS9n0hPmVk6ImK6NRRKPUqDTbeLCIxXVlIx3K+HGkmCF5XxvztokuagD7+RSJyJQXesMHbwS
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


