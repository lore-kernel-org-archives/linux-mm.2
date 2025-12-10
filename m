Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16ED0D3B9B5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 00:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A006B0008; Tue,  9 Dec 2025 19:26:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50ACD6B000A; Tue,  9 Dec 2025 19:26:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420086B000C; Tue,  9 Dec 2025 19:26:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF876B0008
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 19:26:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA68E140284
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:26:43 +0000 (UTC)
X-FDA: 84201670686.17.49DB732
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf09.hostedemail.com (Postfix) with ESMTP id DF3FA14000B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:26:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d65E0VGK;
	spf=pass (imf09.hostedemail.com: domain of haolee.swjtu@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=haolee.swjtu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765326401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I3Ady1WXXJBpaZVaLEwdHfkulwoqkZGdiHtuycholjk=;
	b=yvNR4/Zb9sfO1jnUeph0hcYQ/sATMSXXq2EJ9g1u0tQjrRAbWapLw6HpMDzH15POorGCFA
	i5GK1pNswXiNoY+KYEpmW3Nh821jzizQ1P9jee1skzByQIhmXZ9D28DkVHNKTFfcP3QFc1
	/+085ye2zolJ3O9RaE6mm3ScR529WBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765326401; a=rsa-sha256;
	cv=none;
	b=GxaxN6TJIyZyoUfnRK/QUnDa9Wiiq8xZ9FmB+fXGWOJDYHSsVe9F52kpUZFsHeB5lkqoO3
	8MUFd3RlILfMrIAGF0CZtxaICm5+T3Ezv3l1ZDrkxHKYFbsGj2hYiJ6Frj6TEfDwiVvylE
	tUVkDJBFhM/I4E8f8qwuhw/RmAJOqQY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d65E0VGK;
	spf=pass (imf09.hostedemail.com: domain of haolee.swjtu@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=haolee.swjtu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-7b22ffa2a88so6310814b3a.1
        for <linux-mm@kvack.org>; Tue, 09 Dec 2025 16:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765326401; x=1765931201; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I3Ady1WXXJBpaZVaLEwdHfkulwoqkZGdiHtuycholjk=;
        b=d65E0VGKZ4Ub4y7AdihXiNZcr9L7otBn97rCQBNcFWic8Enm+lwoSzzgK4Q0ezSy99
         eAucMsTPenOtMyJCngBKGFzB3Ju6F14YlqBvhjqwRpbVWqx31taK/uuBskDveJSPpgLy
         fGw1uoqheM3xmqHeSJBHIO+8hNtUsf5iWpbYPF66hQmH11WsAca3Gc3SS0J96Ox3I4FC
         l+iwEy6NVpE4RiDJ1bPL+1dpOYUbs4yDWdAF6moS1OoQc2pfjOotEfsUrMovA1ym/QaE
         dXhPb2eP5+g9WKSoOCs5fszi5P3rnfwmLVahB+icmkvLHun6O4YZs7BbCxldzDYLVOAu
         MsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765326401; x=1765931201;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I3Ady1WXXJBpaZVaLEwdHfkulwoqkZGdiHtuycholjk=;
        b=kPFBQQbVKNBdLXJE29uBVOJ4eDKU57I9+jR1TGUDSl3bZUNYmnO1vXnz/BttmlYC+3
         PKvrpSkbLBI/xo5IXKIRUr0mud81x0OMytXY85n0clg5uJSrevNDAcZN2o6kS7hO8bP4
         Avp/hKle54hFCixtYgze0POPUL0tttPplGLth1fwEcSyP3DQBjqmbg4ygW7qXnYg8Izi
         LNO/wYxHcTXBxou6/2iEf+0+PDe/1ZsR18HftZ1U2731qV7aQVeJ7lJrifftmPaWHOb+
         /ieZCtBwhiNhp7wMvF9MVziq6I2oap62+NU0heiQTu/4T+tXg5o5EWjqZ/ujEJ5Fwk4I
         ljqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQeTqCaPsqr67Gel75tIZGGZVshEezGFJ6i8VvRdUAEvyKu67wuAMHqIzp5ELEEFi3jUUegfLI3A==@kvack.org
X-Gm-Message-State: AOJu0YxqbOi5Dt15PhPcLx/a8pVfb66zaCfJcpDGvRsJK4DLyNdsPhyv
	GkjbE2+HFNGuW/L7u/VOLDKz1iTWNKISo/7nuOU/Ul4d3FcEuf1JpZN3RNniDzIP
X-Gm-Gg: ASbGncumNuLIOaqE8uRYUPQwxsKLCpbKd+YZ1fRBGXbiqIQrAnfwR4IJLDLdg+r4XAQ
	yDSkX+TPb6qb54Ye/msYxdASR08X77vRbMcvlD1XXBV14H17Wbjt4ulL2x5cp6gkMhyjutZFW0k
	QnAsS/oaS5TjiweE2kIslCmkeRGLb9WOz6Yact3B3YG4chl9M7h2qpQOxcxwavF0M75gBij1CNP
	3wROBZKSBSZwXDSHs0KPQY0czY3w4sAF5set/61ejn2cOz+vbiPKNBrlL6DW7aljuC55JmoK/pt
	Y3rY9vNr8Nqg6bch3FpbhAmGOdS3zYAzAcFa/OuWXsjmZFDBrx0ZE/ZLSayqthKE1Qz8Axh9B9h
	aCNAbpy4zqeDGeP56R/jkoKZrBjNzrlOz3nBhiy/Zqxl+F8D5nNJlaNx3rnsfil9iIcdiCA7NSc
	o5ckg8bsajmgdPuJ6fq2W+7YiHGXoelbBFzJbSWQ==
X-Google-Smtp-Source: AGHT+IF7MlPg1IeGwFPzOw/217kUpoJG1hoqSSMUBfyAYD/y2jQk236f8LUR8LHD2kc+WIm9dUchHg==
X-Received: by 2002:a05:7022:2522:b0:119:e569:f276 with SMTP id a92af1059eb24-11f296cc089mr511525c88.31.1765326400595;
        Tue, 09 Dec 2025 16:26:40 -0800 (PST)
Received: from fedora ([2a01:7e03::f03c:91ff:fe02:b162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm70907328c88.5.2025.12.09.16.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 16:26:40 -0800 (PST)
From: Hao Li <haolee.swjtu@gmail.com>
X-Google-Original-From: Hao Li <haoli.tcs@gmail.com>
Date: Wed, 10 Dec 2025 08:26:31 +0800
To: vbabka@suse.cz, akpm@linux-foundation.org, harry.yoo@oracle.com, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, haolee.swjtu@gmail.com
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hao Li <haolee.swjtu@gmail.com>
Subject: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <20251210002629.34448-1-haoli.tcs@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF3FA14000B
X-Stat-Signature: jrrpd8kropqszyip6yef3p8fzd6531ng
X-Rspam-User: 
X-HE-Tag: 1765326401-918793
X-HE-Meta: U2FsdGVkX19lmmCozEQT4OrHYOwUTvA7YMibfRh34VxWDsSCXYqEHRRSX98rktOFVa9go3f7iayR4FgYCc5/sEmZPDIrTGxzsmqt0uWb7GDMEtUTeBk6HkswXHhPSo7y/cAOUuKtkcQFgMiApc7I/ItJiD4X9TI5BvPThLvnYZAs4vI0Vv9zUY3eONvjZa4deu3+pCVJ5fINJl1xr32GvCCemHT0jiDf2rSN32Mj/BXXPXve0y8ePyuVwFJKFn250jlxono3fsi/U+9lY5DFjUCNtDwPi79Svij5zidYwGqXLpBVqtfTRmIMPcPifIa2eaoi69Y4IKU1uuvO4aLtLdM0GV22OdJx0c9ZTrmTHuuntrF9BAepV1NA5m4zC32Q0Vt0I/g9218ZRpeiKLT/Tho/epfVo1oMkinuryUDXLzwO/wfWstupF5BZC/7u5mM4tdbgBS3r10PYv/6dxVolYHm2XT9xS4z7CMR/4tio0EaPMYqClVkK9QxtpV0o8xLW1jms2JvWJz88S5wgl2xTouVKIH62BegP6W3IHWH0XCPwLmnbz6ktVIj7v9gbhXe2DWKOuhmiFfPmh7BVz6buss8b/flhaQ7bFhbWv4Hj1FnQ8hgtEuUj+BUHZCTPXt3wb4NSfK+KGVeYAo/1VWwSiIPUnQNCU1CwXQ4HTeGXQmCBZ78J2b9ua78r/0GPRbjRViA8rki4vRwqQUfPWIbxm00gw06THMGBnXzhfhdnZvdDckEfTlgfkoDcoUBkADXlkdKJWyx1pAjZV+AToQOaIg+USSVZVWZwRkYMy7BdfpV9A8z3HlPIAdGx05xELe7UVhBRDDH9AzZh+wlOv07iErp3spxXBZ0JJblOAU22ejaIv0Uk8x2aH8sidg8J20+xm5vIx58jub5ApYgX3onMISOUWVm1gYrfxiuX9k7tglT9y3DbAWRorowCfXtu0Ie3xhODp2bgqrdb5HmJ5z
 e7fCz0wf
 U6286E6Y68jDtFPnf4nKIkJ+cgvxCLFOLSWJA2lt0B5xqmp1ndSQx8eRWHlD52pS0cZpw2GMtiXE1pXuo6g58DPL8S4bTaN10OLZdgWNlbyO/CgmAUaaupPv7bDrgFBSNLUPf3mnyOWLsz0DcpVopT2Jfkie1RC9BQLKbtalqDW0yf5uB5kokozvdoLwG15uLvnnEYX9U6IJZVPnAeehq9jV2z7og+uNgtlWB9ue2tkrazNHylwXYY7iEGe39obOx6vE+UxfBGEaCyQVgQIRrr9Z2eVEi6NYDk8qTtK3zW9u8kxB8PEC6GAUA0GqKDP6FdCnXyCrOTHvKOs09fJ8E+hzSOGYqZlZCre6U2vpupBOxZ+IHplB1CTbCPUc5AVUaN7jSn/dPC7OCnw5FRvkdXCNkCCzwQML1ii28B+L9MrPHn4Q8DC3MdM6EyTsy0rU7sqY329Ufwpk5FyKz0BRNWFacAnTSq++77Q+DMxotVznHky1txSzuUJjjYQGA66RmRZk9Xg+PZ/hiWtE6GJOCqC9hNv161KNhfry5WYP+F6OPvzFs1mCyxQ+m6mbwJxlgFC8r3yuzbovKe3MP3Tj7zTdJ28GqO0luF7qxu6vCdDlr1mBMPNrWegJCO8v47yThO6cvQE4eUTg+nveYY4FpiHgSW9tC1lp5SDTXUQ1bsPDSbb/zsuXGIx6gdAhhLQE9PWhe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.003028, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Li <haolee.swjtu@gmail.com>

When __pcs_replace_empty_main() fails to obtain a full sheaf directly
from the barn, it may either:

  - Refill an empty sheaf obtained via barn_get_empty_sheaf(), or
  - Allocate a brand new full sheaf via alloc_full_sheaf().

After reacquiring the per-CPU lock, if pcs->main is still empty and
pcs->spare is NULL, the current code donates the empty main sheaf to
the barn via barn_put_empty_sheaf() and installs the full sheaf as
pcs->main, leaving pcs->spare unpopulated.

Instead, keep the existing empty main sheaf locally as the spare:

  pcs->spare = pcs->main;
  pcs->main = full;

This populates pcs->spare earlier, which can reduce future barn traffic.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Hao Li <haolee.swjtu@gmail.com>
---

The Gmail account(haoli.tcs) I used to send v1 of the patch has been
restricted from sending emails for unknown reasons, so I'm sending v2
from this address instead. Thanks.

 mm/slub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index a0b905c2a557..a3e73ebb0cc8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5077,6 +5077,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	 */
 
 	if (pcs->main->size == 0) {
+		if (!pcs->spare) {
+			pcs->spare = pcs->main;
+			pcs->main = full;
+			return pcs;
+		}
 		barn_put_empty_sheaf(barn, pcs->main);
 		pcs->main = full;
 		return pcs;
-- 
2.50.1


