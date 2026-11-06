Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3635606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TC+CnXRP
Received: by kanga.kvack.org (Postfix)
	id EF93E6B05B0; Thu,  5 Nov 2026 22:42:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED06E6B05B1; Thu,  5 Nov 2026 22:42:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11106B05B3; Thu,  5 Nov 2026 22:42:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9B046B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:42:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD8C614024A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:42:21 +0000 (UTC)
X-FDA: 85403296482.30.E3EE719
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf17.hostedemail.com (Postfix) with ESMTP id C17C040004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:42:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TC+CnXRP;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793936540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3bbcV4jOv7yHyE1B1LNNqja0PzYKDvjOLb3BlCeaAM=;
	b=AjaG8IbDv7Pc+oCQ3wwrOy02WDAaXYejdrf/PoeBb6OUfYggGEBWU/nQsmcM4wvw+BF4a7
	AXlUUhb4W782LFMAV69C6yMdyjarMgcMNxlsONHOzHyeaMKCFpNhw5y5plLP7F0U0Izdpt
	opSIkUq5jL3ckQuv6TVw7OLWOsM1AYg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TC+CnXRP;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793936540;
	b=yrsiFSO7Sm/0n5p+e8gbXM9lMK2fQIumOiknNN+ns31eYPIG0CTDzY+4w1ojDeYEcMRPJ+
	tR+U+2PX9sGHalsWSPDkNUiC8G6g3UYFjmi1V7aqFnZ+gEWmO4IGRtKHGqVEQecQlt+sHr
	nNkNf3J4nM9dOo3yk6EW5ebR0oKFwVY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793936536; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=C3bbcV4jOv7yHyE1B1LNNqja0PzYKDvjOLb3BlCeaAM=;
	b=TC+CnXRPGCtS8jx6esP5Ogbm1K+gBcnD/K54itEsLgXIhnnnPxI6efUxs5sF5wabteu+1sLrmoaG7NH2Mp1Yj1Xm2fRAzyFEfg38PTn6LCji8ldDGQ1Up562XW4u0iUevm55wLpKSG3RnQG/8sPxPyZdhVyOIGQhs6S3HovE2Ss=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEAEe5H_1793936513;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XEAEe5H_1793936513 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 11:42:15 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: rppt@kernel.org
Cc: alex@ghiti.fr,
	graf@amazon.com,
	guoren@kernel.org,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pasha.tatashin@soleen.com,
	pjw@kernel.org,
	pratyush@kernel.org,
	shuah@kernel.org
Subject: Re: [PATCH v2 1/5] kho: Do not translate the handover FDT address in is_kho_boot()
Date: Fri,  6 Nov 2026 11:41:40 +0800
Message-ID: <20261106034153.1462-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aux_dPnvXk3LYDxs@kernel.org>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com> <20261103080926.2079-2-cp0613@linux.alibaba.com> <aux_dPnvXk3LYDxs@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C17C040004
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: k5uq3yhp4tsebb9i6ttiofr7smxx8y6a
X-HE-Tag: 1793936538-367817
X-HE-Meta: U2FsdGVkX1/7iR9eWje6EkPYJlFiEIHXhInKlqVjyfZSilkPTPFYVCdRIsnp9mMviq1+bwradNhXTt1qTMOMDPLlqYbUGuxG+ax1PCY3tHMQMTfNB/BHaBYXhgryxcoWGaD1XJKwUVqDzJYmBp78AUik3VuZ0y1NghZjej10Md3Paa4ZCX5S9/IWKvoydKIP8VBbyPBGhbr7/yWk+5aWhyZx01cGkxp+zyNiXGrQThA1r114/VdVYlPaF5Jcrj+j7XZa0Y9aKhhp5ItQkEtjeTRDBCQ44s3pysDXcskmuGeWB6Ctb/4MFk3Yr5CgYi/TQz3htFAvQMNnPsSne7k15dGVjZmhYdixIkdslp4FYB2e2urlCFMZCSf2J3mcrXQrqTynrxEzIkcrpycuudoOg/TGYggsthWdO3rxrloxf4fqodV3xdBOaI2DPVBh/k1PYcSjl+yrpO+YNM+u5iaGWbr+1c8NJyFbj+OgpT6Vqq0oPf81eTWCoFw3aAhyEnSIqJyE2tEtIRwbp9j6oMawUiP76cupbRdP8UF+KhzocSiaaj5SJiuD5MyOD4qctCohsRAcI5FZWHiVJ1wHj9Bo3JqT3Pd5ZBoAhuaHzEV4RFgPJcL6QDw8TgmrfMm1Q5sNk4vdPgCB5WLlDW1lv70RtyHlL8eOlSLsJn67dvtVOkGoraeCeJU/G9DEC1KNidqMeBInc0Z0VfSXx34qqkZEi1Kc58wgwEvtScp+Z15DEbsmq/DxQNH0DmY5SNVFJfBFr7yD3p6Ft2u8V4y45FDihWoiYWZ1UijBC5Tjqr1SXmzIF9voeUNgK+T/PAN0pTmtRKtdJP+t5n5Mb1U0PclHjDOFYIwfkgnvnH9LrSxagifLN1iypBqzSkF4Ey7nwrLgGuqH/LgyNyZDLJcBiB73FVs3xP5hOSm9Vxs9Lyek+UVYpeUgEgDBfG5whUqG8URHyRfXce+7qTGyU8nZSDb
 wRS6j25N
 ElUqvJR4BpiU8DyfL4YThvgKTttJZq7cnz6RsIwxkn7Frw24p1Xy3Gm2lHm+h8jzazxnbyu2/Jo0cNle6rwm26cI29oqhCdspMozlRDwN4+pL2e+CgecMaCcEzUOW9AdGl1b9lJ23jJgmGLjYW3KLDj18Q6wKHqB7ONCcSaeJs3uwnNFCfG4TAdyQ4+JdG9ytD7H9BH30cgc2WSSX67s0mWjneGVy2sAZCRJOA9FJB3r/Z0vMSRceNRln5PxMKu8throiQn1sYPShXb9qUAE+hkQYfSjF2vnJC6YR7rPUNu6Xqd8zou6r0vT6NKKRkoiscH18aJe+hN8+xYY3sWLbA/Je53L9SXLhFUCtifb6JG6poscvvaNQ9pIyOfprm3NzQCU4hwyzcc3HkEg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> There was very similar patch:
> https://lore.kernel.org/all/20261023054518.3258350-1-gthelen@google.com
> and while both Greg's and your patch are correct they both have that wall
> of text with too many details commit messages that I don't like.

Hi Mike,

Thanks for the pointer. Greg's change is the same one，and his post
predates the fix in my series and already has Pratyush's review tag
on it. I will drop patch 1 in the next revision.

On the commit messages: they do restate what the diff already shows.
That comes out, and I will trim the other patches in the series the
same way.

Best regards,
Chen

