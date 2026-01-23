Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88234D7234A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7A16B0442; Fri, 23 Jan 2026 03:23:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61E76B0444; Fri, 23 Jan 2026 03:23:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66FA6B0445; Fri, 23 Jan 2026 03:23:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C3E106B0442
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:23:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90A86B6F6B
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:16 +0000 (UTC)
X-FDA: 84362538792.19.E7EF8BF
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id BAD561C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:23:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HvviYcYi;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1s3RUysc9inCnOBypifiKMBUtySmMfCZj5RN3VGE8+E=;
	b=4kxGhB1H2PrP12KHcjvVx2va9fgI5J0Led43yIZ5S7aQ3IwBoK+xNugqoH2BKDtO5zzZS1
	6tsplLyjdEgUASqIcrso3Q0auZsssmKhl+i2wvIaBmHKcPcDOP93mhn4hE0eoxkaJU9cwO
	NBn4nhrLc2n/0Whm+egX23W1oJUx4B4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HvviYcYi;
	spf=pass (imf21.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156594; a=rsa-sha256;
	cv=none;
	b=p1so/c/Ra0G+GN5Q80CeyhTGnE/srgAnyU2vQRj/sNh7yBBF1qh32aY5m8YpL1+ZjgZwF+
	AyTPfGfxsa/0TqoT51BNkhHXZzeekchLGQONe02Ut4DYQbL9wkR98c+osuVcR2fvySdCAo
	nmR803m8orJOrR1SG0KwgJWCOqVUyxA=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so972110b3a.2
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769156593; x=1769761393; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1s3RUysc9inCnOBypifiKMBUtySmMfCZj5RN3VGE8+E=;
        b=HvviYcYida9PRdfg0Nk7tQu+sVnhqtRrnLp2deXznbfYRr6S9XRgAbvaeH8d0f9Nt8
         rEaTtTldNXFXq/lPNcl76xJYmZviYVEMTT1xok5VQw+uJGtDTXziaWHpNgBeRdbR325p
         zd+zRTZ+iIs+MzZ2QIuq/ZCjYxpFQN9ajVSmi3dOEZbPWbcHS/PzG2nwQB9qcLz2wgcz
         UGUjGHNQJEml7P5/Bhkcv7D0ZHCobnCWBfnaK0oFCERFtYtcPQ9+Fo9YptocHuQEyeaU
         N9L0Ns7RhU+ISWcc4iJEQVXbUiIlpee1TLQ9dPrEj9XihnbO6IE4q7pbrKLT1V0ZKrao
         JCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769156593; x=1769761393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1s3RUysc9inCnOBypifiKMBUtySmMfCZj5RN3VGE8+E=;
        b=TXntyLYlTqtpHbDHP9eDg482xk2pdyat8D4W9gXhnaA5n1udZ/xS97eChqDqJupRGG
         tF4Eh6Bd5Wy/mq0LDJkRlDagFcGOPGoQ3LiKKBougMsrtGPN0UKZw9qe2X8k3O3gNsx6
         6LRrWQ+/oK9mK0zpIMnq0oVea9+hxbqZCw9rbYd8DOlAMPHxs+MwZI2FdSb9kbWaASDd
         GRV1rXsSbJ1CZUaMJo8AeQEEQt29K9pT6cBzkrpYDkYELrDSmtobRXYm4es8Q/721wUK
         ApRmvR4VtIuuaSgiECErTAhtwVGQ+4RYfqlZGJ5Pwkit60SDRPq3OuTImkJvHF++muKH
         uzRA==
X-Forwarded-Encrypted: i=1; AJvYcCXbBbDsc/+emaSdd/BofGuR8SDwDAqalvgM7Gu8K1fmgSarWfHkguiRRHx7mteHFI8cjCEkBRldUA==@kvack.org
X-Gm-Message-State: AOJu0YzTrbv/fa5RAxqSQz+PTIgz6w7UQadC1DvYt5YGGg3AlotGp62F
	0TyOtG0dw/d4IsQpOP+f8LQhHcJxDnRUoPN6wjhgpHMexN+jlAkRkOya
X-Gm-Gg: AZuq6aLGEAA+xH5dtGXfOWygLkJpO7prpzcWfxqanTjHWpimMioVn95vkz7mzIRga2F
	4H7lkf+jBgEdsdhhJfiPXbByuJr+h0eC1uGQRUu5i3rUlvdC+3NeA7Z7BnY6PDhNYTlPD4UxKOT
	74MwjmGiPSWiTfLRknze+gA7rP+pePhJrQ0anPlZlZUOXopy1cpPEgNCKJxEqR3RR6mRM0pQ0au
	81e+dU54rfx65KYIkW6xpZtd1cZBTCSsT+LSHM21ebfkanggebqdggk+rH25dux7dqK+En9haKr
	dqQBlrxHM7fpqsFAcolbLx7e4pwF+6ziABEB64lpUFIedn8W+wsEKmCE01Vt4FV3D+dhKCoXWXl
	rKLWDFD1y98WD7zE0TdEuqo345zd4cou/sE+ku1ntiVovqrByh6WNuk8KQBsfNZr1+Fyh4JXNYR
	3htJU8QIxV96wuxFAYC23SHhes
X-Received: by 2002:a05:6a20:2585:b0:350:55e0:5522 with SMTP id adf61e73a8af0-38e6f7ce9f1mr2253928637.37.1769156593579;
        Fri, 23 Jan 2026 00:23:13 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a43f11csm1348363a12.35.2026.01.23.00.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 00:23:13 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v5 5/5] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
Date: Fri, 23 Jan 2026 16:22:32 +0800
Message-ID: <20260123082232.16413-6-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260123082232.16413-1-vernon2gm@gmail.com>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: czndy36xdkobup1bxfpnaaagrghkn9w3
X-Rspamd-Queue-Id: BAD561C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769156594-893931
X-HE-Meta: U2FsdGVkX1/MmEfumHX5lMrbZ4SIPnS7a0rt4v8NC3+sHIZurgenoIpPnISRQtJNRophc0ezzS0XD03zLvKGSXlhFhcQsSPw9pnOa0umZKXcTD76cxRY0NbOZ2ly0Q1SOkoQ1Ezlkrdgq9Q+jtlhiEDLx1qmoM513mglBJOn9Qo9DS3/I7X0T3HZuqAIVSEPYVVGW4NvNn9N/gSQ/lQCEx4UZo3VscfzO+nmjXenb+VoYVaSxu6HF1Iiiufz5BcQycs6I56ly+XxKwM8JF6Ezqr47jK8c7wSwlqKP+EZ8AtDcG5JiZDUTKY7CU+4zHWSJef2N/S2FnWdUa9SWZ5jlpYNLtZMJN17OFZOtSfdjdkDouClWAYEp3re27/CJ9bZoVAsCFBo4kOIQaqlrAriQeFL3Mwq8kLrfhh5bwVWPAk1VZebJ0jWwCAi6K06WcU7qB+xFdPahp7keP/zk27B+mHiAHWEe28Dlij4LvfXRFtF/nQiTjE2COylDCqvMByiG8YXr65iCti3U3tjRK6d5vTiEWfA1uADr3qJ1IKxDr6IoW36fkls89ClAKKfqz0P0gxbUtxJn9NIfQcBYNvJMhfwD4GfXX+KNL1/ioa7mJ2F5wqwB+fZAR3ZDfi4Tqt5YE6JfUhKZydVrBkU1AGMzYE+nmHL840jFIOxt1rup5uLTvmSwrDInS/F96I2pfA94yFHeuSGKT8w1X1luIbX3aBBwn59IG8n7h/kbOhQSIeq+doPlQ8f6BCn7SJ+mwhVJTEtIxRuvgra4opI95979AUUSZWqovQyXNc2BNnDvqRUWp5fEJjMCS+dRX5kdFCIOrtDN5hpp+j0XOpIGXEXwXrIu8GvSOOPAyRuBATK4ja/rojLLwcHSfD9OjkcBcNSyVShAt2eCUgU9c/7gExivB94RWnXLTNELXk5cR06RF7y+luw3siux8ZTQfR2YQ7ayIRmrJldg9o/0TsCQvt
 dVDEiAiq
 Cbda2GQgwVq7r/9eHn9mjvN6rDkm22zzJLQtXfuVyPipxBWVBa4RstzYc3AjvNJscKaZf+G9VM9ZJSPO6CPFket/rh5Vsf3m+hf1clw26dStGng9VabMTJGOqd6voNKucAqGuKqv6u0UHf6rZKLWGSpbfqByHKFc+Xakru7Ji3K9q/02k+hz48kZzV1vn6tR6uEabfK+b+qLgF6kaYR/w8GtMjvX3pLCLoPzUjYVgndf+uH9i3zH7/Gk3t2WBMleBMytT7NOU5rAZtyCDdlHOa5+VV6izWLDe3zy63ZRjc0w/CCsmK/d9OyiBkRcMoBoKfzHDJSdOO8a2UbSrj5cRZ9VHwQ3OtMRbsRmI4ZEiKFCXgOLPC+oRDDqcsiq1iBnIBVpRM36ZLonxnXLRFPEk9bKyxCd5JdQmkEMo9jBZuWj92BQqmgt3wt0K7mF/DRz2fU/BF6E+CGxAdRjKJCrzUrGJGU1VAv5s+CyjrRIFb826l1k8SnB2DrNuwT+m6xEAQ854P/LyP6pNz/3gHnObX7JIFr6vzyEHOolN2LedYYvEqzo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
reduce redundant operation.

Without this patch, entering khugepaged_scan_mm_slot() next time, we
will set khugepaged_scan.mm_slot to the next mm_slot.

With this patch, we will directly set khugepaged_scan.mm_slot to the
next mm_slot.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index be1c09842ea2..1dc19c1b1f97 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2558,7 +2558,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm.
 	 */
-	if (hpage_collapse_test_exit(mm) || !vma) {
+	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
-- 
2.51.0


