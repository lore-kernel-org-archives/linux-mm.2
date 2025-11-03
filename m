Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E61CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 19:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7D88E00C6; Mon,  3 Nov 2025 14:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FB08E0060; Mon,  3 Nov 2025 14:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA198E00C6; Mon,  3 Nov 2025 14:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8268E0060
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:04:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FF85B80B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:48 +0000 (UTC)
X-FDA: 84070222656.12.C2E227C
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3496240002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gCNPHZr4;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762196686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBDhTH8Dpf9cuoXB2xWuzVQKuw3fUYOK39L3KZEHT70=;
	b=dS8eMqujwuby7fVEf0ovvAvnV45aNgfxWUU95ZOV2/tenh3aFgvShugmj+xfe/YSiFXJeY
	PUPpjXjf9yOoY2nGUThYcONblnkiYupT7/VYecmC8AyMhd6XIWjzK9vz8aiYicJExbKW+P
	Zqhs0LoTMh0xUhQwmDui9cByocMFSHo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gCNPHZr4;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762196686; a=rsa-sha256;
	cv=none;
	b=sFpD79+lBUknpHBEnbDsWXEJ51JueHEHvs6ffzHbEN6Jpn8q8sdPb7/i4+ZJLt9otqBXk1
	9L624vdP6c5Kh6xnUd8YTUzgX7Kh5VLHTbxDXNmpvW/cI2kpp6ebCsaaqDyApQqf6+te2A
	19bJX9T1bb+VP/o9QZvPTEV7CNt8wHM=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47754e9cc7fso555775e9.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 11:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762196685; x=1762801485; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBDhTH8Dpf9cuoXB2xWuzVQKuw3fUYOK39L3KZEHT70=;
        b=gCNPHZr4jTbDsob7ldZ6NAehMhAOhIeJZTHj3/IBb1q5B8C68aBhOx0E04FnjVWVVR
         Yp035DkN/6tTK06joOtNH4Z0+T9PtKnrPxGlyeRddG0sW+I0cHx+ufWM5gmPntXehGhr
         mCbtg44rollyDtpDKCtPWSnd1DIhKGP5spWLpZdVMxbOrXioNqzGfb+zHVOsI63dpXOb
         eEiZ6MMUJfa9yssN4JYVFYwVfiTBKsMRXoQ8nDBLYk02JGYKXwQWuJ69TAwuWJDfTmZV
         iex7eiOx5duBjMrQys01ZENorXGHtLUAzvXSI82vbp5ses1SWwcc6JiFXc/nMLfQgdsA
         DUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762196685; x=1762801485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DBDhTH8Dpf9cuoXB2xWuzVQKuw3fUYOK39L3KZEHT70=;
        b=YSdilTK9phMYV4UmTc0eJeAxH12N4PsIlKo1iWIhq/Ms6lxIDf+gxIBusABVXiIRfn
         Bwn84RrC/JkgHpGsqG9FHf21Q42tw88I9YGe6QArOCWRL9yGHraWMkoSrYqR6/nU/s1m
         q8eXdD/ojSnc95V6mnB/UtQKSZ9wCXiF001XkdLuohM4fJ8RzlS2gx+hnJELRalL2Yj3
         JoCTOCnmjfOuPRDGCCtbsqjuJAgrsio4qSU+BHW67hc4ZG62kcOtyYL/FhZZgZJlympX
         pEGAAAW352X4UCZQnqdYogjRLvoIKUXkxY1h6kkpP+QvId/OeHqetgMI8H0G61DyYbVA
         Ipsw==
X-Forwarded-Encrypted: i=1; AJvYcCW269X4c5azJkpFOSaqlqWjorykjjFDuJc2/jE0Itl4SFjBNbjkb1HBn6qKh427UwhRaYvH/OR3JQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7wPSce5gvZCy2AO+OP9lcCWrGbTmB7FvfeVtWj/O8WG6Pr0vA
	/YKNhrKf1KAHKtf8JnbQ5OIOayNA4dLnGO+1o89ql1K8+4ejPcRV6mUvMB33s0U1
X-Gm-Gg: ASbGnctj6mDjT8XrSx1XcUVWYKDUL5zrXkS366hLbO04D+XSrnpbRqdbRLC9e6F4OCQ
	R/mS1Vlfd2NZ1wxfZG7hYDd0qBFwnwzK3CUe+EUZAP8h27JSK/aSN+foQXQZAaTNwEMguMPnLz7
	zBVdpyRmHwkQ3bqllWfZTXlppZMED7kg3/swQJqbXvaCGvF2+NVWrp/H8BywCTuYy5L+bck9gIo
	gSlqhrZqN8ijLqXj/g/w/Cr4X4cEsLO75VT2PQ9v4CdvFrP06lXcE2rY066s+JLoxMedsInZRcW
	RkHQbgsqe9qF36EtaAtojxs1GdZfV9djjcgLvCgkZtC/yic5u/wH8gRCH1hlYP9/VbXZot/Eml7
	xmZS0FPRAjqaNd3194lvHLp92Iizu17zPN3k87QxXHw7qff+u6NjUpX2JByxtNnhq8MqTljqx63
	fdEfPlxWpuKiKfgn25fcf/DTsjIX+V8ls56eJvkvmUxvEnNmj3AjE=
X-Google-Smtp-Source: AGHT+IH+LrObL5vnPyR4BBqTxomK7H6lOIKtzmQXyJTsFQUzpJ9S6dbTZH4skwIU/n70FgNhhlhOrA==
X-Received: by 2002:a05:600c:6389:b0:475:de05:6611 with SMTP id 5b1f17b1804b1-47730793c68mr134898565e9.7.1762196684751;
        Mon, 03 Nov 2025 11:04:44 -0800 (PST)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429dc192ac4sm327407f8f.17.2025.11.03.11.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 11:04:44 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Mon,  3 Nov 2025 11:04:29 -0800
Message-ID: <20251103190429.104747-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251103190429.104747-1-vishal.moola@gmail.com>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3496240002
X-Stat-Signature: r1kxomjbmikxq45akffgnyo4iwj4d61y
X-Rspam-User: 
X-HE-Tag: 1762196685-875551
X-HE-Meta: U2FsdGVkX1+KU1+wc+x00EpmoUp1/kDq3NjLlDpJDGqGKPnZePVhdboIFO9oojtozMF0RQXIwxKK49gEPZVFR7D8J3BlNgEuqAa9JNbpd6FIe1BWegf3pPoZxHDQdGelERxFZRrgPbRRvOK6vEPnvrMnKczOWP9JCcSIX0A1uXj5ZWIskg+3L5Uvnzve5ieKOlTvk3XTPRE6y4CboBrtKEJZEZQLdZqNG3CTuGLIQT2JVk9MHQdBhVtBHGcvB+KZT+4SNh9znqjkmCGqI8RSDMFah+VusOmgJevO4k68lB0BLQ9+7WZYZa6Z6QCIcqkPPeQEKg96lHXVi9kwK9eJicGbWtlGTtggcDUmhdbqVNQUS7bJv+24JIM3KXstVJa7bmGcdcBbsYWzSQ4oUfdobs14JkCHrBKK6o1MjOdNkuyMvzpaZHlQENrHrBBrCLtFhM1NaEY8h6VK1th8nfVn8y73HMkHPwHnO6abPm1NenHTg3es+5b5PUCRBxGQXPruwIX8qRkd35yJOwpTpAWrRC1JBXt6OMiryDQ6cqvsQdCess05GpXPVoZMGw8e/YYOOw8cr21AakdXD826IZkO+l2kuWx5XqYCyR7wGb4AUqcrMAe4QDylFFE5MpABALJL238WBIA+t0X2jPod9wWT0YfhNrViSc37ImSoTaS06iPCpmjUYF/wBLyjhAAXBeMFH8eUkGf1MRjLzGNFQ7UdN0ZU2fYDw4ryqnupLpSfIEI2u21VuHZVZ6LDFQiBT/hmVIaPgs9p4GekAVMq43CBfwYaPoYpXsYBUls21dP5JZS6c+trwQXJgbfIVKxQ2qo/MRurLAAfUohIvW+hUOvylbFSVcdnIXI47adpaxemvdK4hlCqhPSsVWMYjPMagfsm0jNRE2O3RhkjoyRD1GF1T8X+ggcZuBlzFnMv9h6DilVR6B8ErdBSf7Nu+DSJNWgV1Xk4tARLVDQc7ob6wGP
 pRXBpWUu
 Ktn3z4Y+4pd6P1yRUaQDCSnMb79eOm034oAsHdqTmVXZZCikWM015C+fMt8iSzDitKzGLYFEoxtKV6GqKRy1wSx6Y0KB2aluVwBPdAjNBvZxK6fEHVKpbamu1phnJc6ru+LI+YNISMGxxfnE3/IHdIlkzsyu3CmQZY/6HvnijnlBO28qOP/XUieYdiv9MHLT7RP/dqdZ8kwWeqNDPTLk20GVFraikZo9gHSBkZMgxlkXRS8ZklyFzvAcRxc/wIdX2gYEBnoTk2nXpqz0nS7fWXmolC5K9XYgeFFgs1kpcCC8adNPV+pBdPBFnkYoez1tOsnARDfMNaFsADDPhFtDFJ4c0usWGQmC1M3ssHRroVHF0KNjVNKgIcqDpZgfVb7g+QLW+yTtno7yDXxCcdpctAah0jEhc6PoJelzm664pGJTnqsCFj+03SpkmrtBGlAXuMTlhPFVJQYUJ6QJZDBXfDYzxwaYHUcs71celDOYAY1hJ24b90RGYA1f4yeRVDV6690ZHd5ai2sJS/UYosE5IUq99Rs9ReFZYo6kDpjcfmgVmY5wnBGGK7s2C8NtX7zf8axe6GZk9vXrrtiIGr9OqWPSMfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block()
which is a subset of GFP_RECLAIM_MASK. Since there's no reason to use
this mask here, remove it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ced77fc65ce3..e6cca6219e48 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 
 	node = numa_node_id();
 
-	vb = kmalloc_node(sizeof(struct vmap_block),
-			gfp_mask & GFP_RECLAIM_MASK, node);
+	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
 	if (unlikely(!vb))
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.1


