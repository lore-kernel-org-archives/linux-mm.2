Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F549CD8C83
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 13:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78596B008A; Fri,  5 Jun 2026 09:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29EE6B0092; Fri,  5 Jun 2026 09:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E676B0093; Fri,  5 Jun 2026 09:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 872D76B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:53:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F9531A00E8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:31 +0000 (UTC)
X-FDA: 84846001422.05.4D372CA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F45D100014
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:53:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KZ2WP8U7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780667609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
	b=j+k0BEs0lEmJQqhOQSnjlRTj8ijkrdM42JKO2wwGr+qE0riTxp4duNtwslH0BtZOuiKICx
	6eCzE0Xb7cMpTUJz6CaeNX7EiCvJrS4iNLsokIlnXkYiMaUsexSFCM5ZweT5z/wEW5pjcU
	juJ4s0TJpFCZApWbpXZjeKHjFDU8WqM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KZ2WP8U7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780667609;
	b=aWLQ6pT5aM6lo+2a7I4PwtGCLCYnJqzy8Bei0q9J6vtTofEHN+T4VzdqnU364dHNwB+UDe
	DW4OTNjNLBw/nm1i8R/zH0QB24iLzi2Gv1zv9Cj/ycLygdjyJ5GQFal7ZaAIxA41fGm6i6
	EvBuBnl17pMTManPU+kzb67WYVBUrc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780667608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
	b=KZ2WP8U74FXEmLAuC+DQNdGyyGyarH0SfFu3TYTC8eRHY0yjYyamNXvYBXdCUtZjZcsTGy
	VSXriEAzFjOw9KxojlRSnW0N8BFyJmToLa8lxGVMSBoIblwif2yxg1Od6yIO2+oBhzQVMi
	a9GyghS1h7+azAiu+v2uDiZVqCha0to=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-VSzYyiX0P56ZwQxHzapzPw-1; Fri, 05 Jun 2026 09:53:27 -0400
X-MC-Unique: VSzYyiX0P56ZwQxHzapzPw-1
X-Mimecast-MFC-AGG-ID: VSzYyiX0P56ZwQxHzapzPw_1780667606
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso16961305e9.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 06:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780667606; x=1781272406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Zek5lka7I+V+M7YhuZBNsWHTpvMuxGl7NM9kjldurc=;
        b=LwhbbotRIfFRLWyTQFPHDl7gCWHkF3g8Q5Ehdn0G7nCMIzr5FS7Z4AZNC/v4ccWsVw
         s4dCjo4uUi2yPD3pEzYMrDy1NSgoj6swidtYAsRLmQ2dQZbMD/0G9WMw3S6QVx4r3IKS
         SKQViY4VBqU+bBNyDb80FHmA6CSw09BPp3qdZB8r5dd8CXHG/mnuRrHVzGzntMf9biPD
         vHAchY3fmcE1jOFTgxX6VbVIWaIJQ7cYqLSTer4Fqot+TfGfjHLJLeC5FHp+6OGh+aP4
         iNhrkiOCYtN1hTVOGD3SKhWz0gRPE4MlEF1KjkUPXQawFhad9XtvQSORHV+74B0uDwSh
         v6aw==
X-Gm-Message-State: AOJu0YzJwhKY2eszAJ7OZfGSbmr2XCDi1VkGih1EjMyM1KjqIGynbe1e
	LYGB3sWm04RioktchHtCskR/P+rTyNbMraX4HMPP/mH/UB/wNBcHs+gzFOSv02BZM6X926gYNh3
	ThQRMWptzSEp4tKpHeb4YA1o7FNAG9b3dwNpP7y58nLiPKk44usajglsnkk0P
X-Gm-Gg: Acq92OF6MeMA2Mj1Rgt/FVnYqdb47UaNpZJH/876vUkS441vLNyOArnqzz3OS5HF1lH
	0je+J8aqjKuvWl1q4qvnY3/aN5g/6S4km+jHuKfKCUy5onuY6x+gCxHA3ipb6NErOC2Buj5/Lew
	SgE6FI73L3F/fTeMAk9ofmu4GD70Qp48Aylr7x9hf9XJuaU1KshVFcbqAEldHQuMRIKP3U8grBg
	Zk2zsl5Y16Pm2dKwOinB/qjG0r11qSry+PG+vHh2iyHwo0ARBgbxS0jz9r1j3cn+W2J/be/OAWQ
	mM5u9eopgkZNPGrb9myv3VKkSAUghxmTl5U/NC7fYegTd0dR5YfuyVmB9lMrHU19G94nQ21uKNW
	G2gXMKNZPxhixv78sN5suvRqyjfYYdNNKJpWADqmqvVt65yoQC5K9Oo3CKzLZ0sCDMOi4ejzXpX
	omSTclGg==
X-Received: by 2002:a05:600c:314b:b0:490:bfae:55cb with SMTP id 5b1f17b1804b1-490c25f5df4mr55867495e9.21.1780667606095;
        Fri, 05 Jun 2026 06:53:26 -0700 (PDT)
X-Received: by 2002:a05:600c:314b:b0:490:bfae:55cb with SMTP id 5b1f17b1804b1-490c25f5df4mr55867145e9.21.1780667605812;
        Fri, 05 Jun 2026 06:53:25 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (84-236-1-92.pool.digikabel.hu. [84.236.1.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cbfe4sm157999025e9.7.2026.06.05.06.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 06:53:25 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH v4 2/4] tmpfs: simplify constructing "security.foo" xattr names
Date: Fri,  5 Jun 2026 15:53:17 +0200
Message-ID: <20260605135322.2632068-3-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605135322.2632068-1-mszeredi@redhat.com>
References: <20260605135322.2632068-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6HqPH3jy8sRzDNOQtX5KMi5cSZDU6RySTyA99OilB24_1780667606
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0F45D100014
X-Stat-Signature: 8ttemhdzr6xswera4mp5xio8ec7a987h
X-Rspam-User: 
X-HE-Tag: 1780667608-49634
X-HE-Meta: U2FsdGVkX18rgAyvW3hfWwFGbHKrxYgDpDGJMKKDCAuyCeQt0NxVN6s2uhxecH28BB16vhl6xR4pxZYw1PT8r3HI3f+rshDahLTpXq1MJBbfCurvolbUmyPlag+FMOUqMdvbf4IBCoeIDstfVTcMb4yAKLC1CBK7kQAqxO34HtiCzENBxNFM2FoGjZEDoEIj9sGcfI61rGU1vVLBZCttrJe5vxOCacjwAU9shyVfZOax8cc3dBynOUNOLCHhqvq08vbkksmC9VIB9oPN4yrnemHB4j5rJKS2H035bW2GkCNPqr3KbkZx1SzcLSwSaamiwq8L/ZKh088hz/G2zqcR/jYynNhgt/1LHJ5r1c5bGWnQpmPRSCNH9tFRv5qswiEalo8kClJufhSJ5gDs9zAXQpWMdGM1lLhnv0LbEquYgPTcqqhV+XGGl9vD8B9gUCigU9filZvtXT8VwccnEXxgzC0k2hjVYh6jFHED/MdrvAWh4MHLP87mtw6AXnSwPYGbHSqsSfUkrw1fQ/hWK6mWNW4EPgyv2MCqGYAD7X6w3//XwWKs9gxe1BY928r//kiNhJsSyw9Ao09EHsZDHGzKUWMHj1PzoV8aZBjjb2L5G1Y0u/GqtD1XgIY+cHIxBjAPLAJYHLOfMtgE+wLBjQwcyZ3QZRfSia/czDV08i2e6dopjIlGaC+sakgCLbGFDzIqqvjZTNcj/Xm7mMwIPpmmtED/2kINVBWxxADKJWh6wHHEHQuGPxb6x8tWorFzOm1jfTGq4ojX6UoSz0vuzMTkvUQfatjgphnbd25ATdzhCAQUB0QvmYLEWi58uQUK1t9VuKu8I0THV7YYcuLRo0F5HXyB5SYCz1ow7uG1cHnFFY1Pkx2OgZ9+e8Ty0AfeMnmFW5qW2Jldu22A2D/F2NA4fX5nYHDjPb+La2fTpAF5ldyrO938wC6r9F1mMz9NPOXsSJp06Y4MuRyDc1RWM6g
 aXvcksGP
 KCVKFIqxzsr+5eqPdT7UciGfsxOmSAl6tIfPaCaTbCo2kjtm0G2CZQ27p2cluc6Mcyj3OPozPiqZuvZHR/93kL3USJ2+5CyCvaut2Jzh9KuFjd4EtnaafvWS7Y9uVbhiWGXHI5UU2Tdr/NHpZlZRXncyqk1UG4tFt8Pe0/zWux0dYJchUUjF0uEuu1nONpNasL5WCild+psmJUqbfnQge1uNHJf1ihd7qvxtTYrntOgNG3OplcloYoCutlwhirJuSGEMn/QemkzhiZUG8T4zbJkaXNvGKd+dypkuGqG3h2Xvk2ugpXUZgpR7Q8L05BrQlnKDKZ6Xg4Z0IntxNkFbbRSPuzmkJsPamngaZBku06Hd8yzxzouhJevDc/LpPMDs2SqI5XV1vhP9CfRGc9TZrXsaqSTKqHdBsPkq0
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


