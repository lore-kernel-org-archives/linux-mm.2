Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD8BAEF5866
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 13:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9BB06B0005; Sun,  8 Mar 2026 09:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49666B0089; Sun,  8 Mar 2026 09:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92AEA6B008A; Sun,  8 Mar 2026 09:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 816F66B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 09:42:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04F041C506
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 13:42:32 +0000 (UTC)
X-FDA: 84523010586.07.6C9BE1E
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 30A621C0008
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 13:42:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gAi00LEs;
	spf=pass (imf21.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772977351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbKp0eloZA1EESwF31tdwEOfegEsBVQl6ISBISTgW7c=;
	b=e9qHKK/O3/oPZX91YjbFqP5/4d3yCg3PG3tjMqFKkbp/GzlvwKaOGZCJsPgSzY82zSBNBc
	PvOq7SR434WbFTGXiLTCdhTjTuDV8QsfIuEuNbO6oOr5RNOYu37fJwyt0MkRV6mlRbXV3m
	KgEUx1VrnHVmVWMu9k+7QWCVxSxQqXo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gAi00LEs;
	spf=pass (imf21.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772977351; a=rsa-sha256;
	cv=none;
	b=fNDCbzu/kAVqM+JUmQRl2HI1GXbHnD32DRDc03/wM19Gm2an2aYzwrRa2rEG+7G633pPLc
	OR0F26LgBsaB8E9c+usBuae7clmUPMZlErY6iQybiP+PKqDk37jE6l9nLAVplhZX0yt2sD
	iU2HBoY/atYZLUdVRYTHGQ2ktDhy18I=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2bdd40d3c61so9137483eec.1
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 06:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772977350; x=1773582150; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbKp0eloZA1EESwF31tdwEOfegEsBVQl6ISBISTgW7c=;
        b=gAi00LEs3QI43TgBKEdQFUWU7b2NIVRImbMpceNa4s2a4d66kQcezdkKpfUYBapTrw
         cID36PRYVzDf0QlQ7Z6O9W2B+FV/Y3UELzJ1wSrF3/eBLjS3c7rsOY3R0I69kwd1uocu
         9Z9AVNcYjJl1b9ruZaEomrR1IUsL++yqxi6jwqc1bhAqukt3j38UeOIFrSMBQ+8F0tmx
         zzsDHuUT6aNPQkYybbc+y0fFI8+Gkpz2uFbGNkUsEbZb08LY+Vl4Id3dASzc/Y8P2/EH
         FUE24oT1ARpzF2fK7vMKa91yae3fOQFay+E+0mXH5jJRY6Zq7dKPRAGV1bWTvpBr4Dk4
         KopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772977350; x=1773582150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HbKp0eloZA1EESwF31tdwEOfegEsBVQl6ISBISTgW7c=;
        b=SLxQlYIU/zSNY0iV3UG8MkqgG/0YMIIzbzC+GU7cqmXtgzk6/Mtxj6qE8sVJV6lJbH
         idj7Np2kxrtAlx/WQ+CK4mwpHk5MjQeERv356bgsR7C7yp4N/TbScMxj8+Qmvg7dIpsQ
         89dx9x+MsOmri23xE8oDgGMOGxUKbzFS6VB3W10vxEKnrjapaaSFSfBz/fIgKIJPLzgi
         a4AJlaZwNPgRTZA+XlcmQP7zh7ltj7vs/mD/zcEDm4RjeWC/HuOTiqi4M8qsT2oDGUzL
         7IxJI2JECdf2/4oC7RNtMRL5p9TeMPSdvqufQA3hbfnaJXqMkUxCSmv1s8616BecCQdL
         wjCw==
X-Forwarded-Encrypted: i=1; AJvYcCWwVOtWv7w7/Kq9AZ+01Kp6AL3R/Fh4cutXnn9CxPv2u7Ss60CN2+KvvFfvZ4R4X5QOvx+NiMCgLg==@kvack.org
X-Gm-Message-State: AOJu0YyXT0FMYREJPyM7KeXxIhbqpnXYgAUt1tX3cJ+2FLolwN4Aq5rt
	gX5Voww2TxI43IGFURzYssGFg7DzN4C9X2owYaNooYvqq5V+WzJgaosl
X-Gm-Gg: ATEYQzx1y0cIZVfIw9SxY7AYPphREGUZg3snGygH5grpyAJEWZNS3Patu96YrWpMzQG
	jN9Zl81m0QDRxxZ8m/qdMKK8oa9yoidYa3kkzBx/KllyCC7hRJYTMngUW5ky6Wv2Y8d598nWhe/
	g0w3XwN2SLTWvHHW9zq9rwp9YZKB2jrorxWHEeJmgg/mFJBTQY8zqgZw1zZqWIZJi3lVhodAlZQ
	XDYj9jIN8MkLHiIyWomaJc07UMag1QPr7+6voXPhu/OlvL65VBaR+QyfDtBdBHtJdDVEyd/+JkO
	Mb5aFp6Vy60xvcxT5AbRsigNny+MrTNDci8x2jmdTbEJjNT6M3Uu5OhWuKN9lE7zAit6LDPKsFH
	6504/8KRyq1TB8cj6IuOyGZFnaLt1J3U3tiq/OKBTwNTmgXZPtCJoywd5sXBAe3fcHTYXfe+Xxg
	9m8OZETLw=
X-Received: by 2002:a05:7301:1018:b0:2ba:9835:112d with SMTP id 5a478bee46e88-2be4de928e2mr2880611eec.3.1772977349688;
        Sun, 08 Mar 2026 06:42:29 -0700 (PDT)
Received: from zjh-MS-7E01.. ([2602:fbf1:b002::1032])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f96f25bsm5636535eec.28.2026.03.08.06.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 06:42:29 -0700 (PDT)
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
To: sj@kernel.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	jianhuizzzzz@gmail.com,
	jonaszhou@zhaoxin.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mike.kravetz@oracle.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	peterx@redhat.com,
	rppt@kernel.org,
	stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Sun,  8 Mar 2026 21:41:51 +0800
Message-ID: <20260308134152.6877-1-jianhuizzzzz@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260307032759.100915-1-sj@kernel.org>
References: <20260307032759.100915-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 30A621C0008
X-Stat-Signature: zofjpwtru5m66snt9cfo8z6cms88se5k
X-Rspam-User: 
X-HE-Tag: 1772977350-413699
X-HE-Meta: U2FsdGVkX18mA/cRKmzdRF1z7LWUqNdBL1e5h1+5JVBy46inVjEzBcSc9gfWfL6p8ROptlgAp42SrUJMoOHKhLp5tFRlbwvTr57q5+rVlVp7hL0pckhVoIv7Lzijf9uMatSRLz1PYAQXr4o7TbKFuR8eYdgi/32A6Csr+xDHUChWP+aoTy3b5GGuBSbr8KJL39pGOjThYNnh1+CwlDL8YG1fkwLe+k4s3Q9lMvD33pahzDtTYicgaQBR1LkZBwpaslT3GfAvdqWSwhSG/UeFUppOD/J/eGxk+EJmN//r7s/fEyuWsNLSURu6KX0S4wbXnRAd/rbu2Q9nEDRGrhqBAG6L1WW8ryDo7/9q1zjD/8jqKFS+KjwlBurf8KlLbk2dA76hmJAvOZvCgFhZsZXzYZ4R/RlQLDFpxwW0fj8F9yLHgNYzJgN4f4BITuolRgEtZgh2F3IdiElXfkaKeL0avIr8UixlR+kpm3TnIlY4VAFO3Sur0V6b9+OCaL476f4HlFLUakyodOQAqZh7ByHm9uHwqF6HlBOOzvGMJiBy97JMG9J4vB8Fm5f3pGHpDF/OAAgBoIRMvV1qkFNv/uW3DUWOm2/5HxuMX0KYLp7C13XMTi8Oa6A4xc7cxGvHfQa4/4hgpfygKJpWbJw0ZxuNi/eYc0AAd/aUcpiEXwbozR4rBBcoh1uay6hIUpDfrAiGLCYsKndvj09yHXInlfNTvrA+IVgTRJsIYL++qH8n2p+k61TCaErw5PVrtcz8HEhhLRDvzKDsE7qs2t+wv7vfBX8nqh5xco7amf1cGMPuuUo2eRZzLK30WYzImQNmdlGawcYQhWGP0tMRl6pf5BMaNZum5d2PQFAFlYwRfhxVjayYEG5Q5zahqZvi/7WGhiggkbxV4VTgQoWwE0LbyCDsbBehlGJK2mzj7zJfQ0fFPfjpTWihQMr2AXtZi+D3/3PVmhu0ZaS4btAUZTy7J5/
 AxgtOw64
 F0SlSiJJjRSOl1umPSdDL0Aqm+GGrF3hau2wvDDePRX0HfgPgPbknW0hE9myqTuiQK+GfklKtBuXJpQq49qwE2B1A+JBDjJr4l/G5SemRbgU6uge0o/WMZ30a6O0FcbzUepIvGmh9HG1Jdrg2Sn7ol0wD3A0VkrXyRPDolNFwTLOA6j985+CF0i8+aLpXfCCagRcDVbTCW/ppFpbXujtRnDlPKro9UzAvY5GAOR/w6+DZdOY1KVzMu/+Elk8xd1IfWuL22RV1I+5CRxt28B0qX63hnFLKU7/I31i7Q1CPzfnQgvS2YgXuUpGXUzRBl3ecnfU/kWaCvRUXS9jWbMztASn/r6lvAFyF8V40I/hYxkRxeymeB05nXVsDB9Q/b0e7Ujc1U+XLFg8zCpvheKgrEmfQ0Sq7jmxBqautvxnR3l7TPy5GiXep163TEVyPeXxN7xBif0f5TDL7xNcDQhdgbldkCJpXt8AE1qBz1lUEIbgyr2mey6+1nobBK5MMjBiUKpei86WirHv7VL5oXrhRPYoZnUtCS4m89ptG7x3/6dR6jyoWWZBI+ks+1cCsNUEHyqmu0HpYrv6DOOSBDfoWTzLR2eQVgnd6vf/63DGQtzS+wZD8/AbERO7SopgQO2uZFNLRPUQSq1AWpzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 07, 2026 at 03:27:00AM +0000, SeongJae Park wrote:
> I just found this patch makes UML build fails as below.
>
>     ../include/linux/hugetlb.h:1214:16: error: implicit declaration of
>     function 'linear_page_index' [-Wimplicit-function-declaration]

Thanks for catching this! As Peter pointed out, the
!CONFIG_HUGETLB_PAGE stub is actually unnecessary since
mfill_atomic_hugetlb() is only compiled when CONFIG_HUGETLB_PAGE is
enabled. I have removed it in v2, which also fixes this build error.

