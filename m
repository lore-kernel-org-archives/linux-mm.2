Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1BC7CFD315
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 03:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1E06B00AF; Sat, 22 Nov 2025 22:04:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499066B00B0; Sat, 22 Nov 2025 22:04:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0356B00B1; Sat, 22 Nov 2025 22:04:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 263D46B00AF
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:04:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EBF0BC9BA
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:04:56 +0000 (UTC)
X-FDA: 84140379792.29.4A46822
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8FC9100002
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:04:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hspwAEjy;
	spf=pass (imf14.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763867094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYRW6azGDUXIo5YayTW1Mj1pqj1rOHvVGag+WenlXHw=;
	b=uP7DLRsrqyFgT06kEMTq+obYRoLUyNuZZ4kEjLi9c+YGffcB98mMp5rE/CZTOTRe28KbUK
	XUOlvwUsd1nlqmj+daohtpC9QYq7syIXVgcPfF0p2yFEANCsRZ6PnguZDCRvZcznaP6k5S
	UDnItoN+4yMRHFdaTCT6KJbmLAysruQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763867094; a=rsa-sha256;
	cv=none;
	b=HVaGQP5vzics88c5NIBxqrbsg0FNpVVQDhGjYaY0qXNnakw+DZ0gI1imZQd7bdcG0t5R1Y
	X6iYlEJZRbUleubFA06ekpl8pede9kzd27Y9yuW0UEhvQcAIb9IrNrR2iS0YOjsx9dPOYl
	qcLUSQX0spUhhYXRSa7ex6SZyQJm3gM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hspwAEjy;
	spf=pass (imf14.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso3513244b3a.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763867093; x=1764471893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYRW6azGDUXIo5YayTW1Mj1pqj1rOHvVGag+WenlXHw=;
        b=hspwAEjy5JjHJS3qYSE5wy/ThgpQzkiBCO62xTzSAChp4WolYHC/ngK61SRjbBvkh9
         fCXHdPaFOazG4s3sK2zh8POoiNFqkM2e+lRecGO/jLY44EBnAH5gxlXXgGRPfhe1tP5Z
         McDR+R8fSi0V5zFXht1xwdtwCL5RSG9Cc1hkKjyJP7q3yQlDKZml45lgigsD6YRXlXtb
         A/KZNrVQB7n4hMX4ZiUNXQRGrSG2IorgfQrbQ9i0hFTdB5DV/KKMH4oavh+jCM59Tm+4
         wmjPWetghKYDvhK6neNzniQuoi3v0vmE1JPkoN/Nl8pKIJNkywIt9GtbDTwUYTg4M7Zz
         9Emw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763867093; x=1764471893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BYRW6azGDUXIo5YayTW1Mj1pqj1rOHvVGag+WenlXHw=;
        b=JcZtaC8kS4ZddFqM7K6nS8fi3OGHB7g3tzVBiVlnYFk4nwd2fCuFe+ZUSOO+2iDSll
         byXJ9YM3oKY8NNsCLvpnqFxetX9BO7cxcZBesL6VhqScpeHcbaNOVnLWd9kLYyaLQ6jv
         MV1kEZ4KD1++5SP261neNEETMcYgvexDemCmGtV234Bo3JQaayUvjX+mLTWFruTo4b3d
         15jKhdwEK+L/RpFnz2AIL5kyyPhZP4oyCgHj1spiQWghZBuKuAWlbCeg01TgajTi9Tt9
         VYnFqwW291WjHAWNOyWJ6ookqJ/fB/yNHcnZp2MC7OreimxqE1klMe9llta2ZRiGwWA4
         ADsA==
X-Forwarded-Encrypted: i=1; AJvYcCUYeJyy6n3WEIkadeZB7UZBWjKlcd9zhKxcKULFdBiyBTBPP3Jfuol6Q2sKG6x8uksuLQUPgraSCw==@kvack.org
X-Gm-Message-State: AOJu0Yx+fzN3H/Fu4pY0zZwze+OuXmib3YueIyF+9HvvVSgdMDvC/QPd
	Gsfv22YbRS30CZsHWu1EJIRUpuwPgcJfUVDuBjQB9a+qYMVFOKROH1pj
X-Gm-Gg: ASbGncuvprZRX3T0/2zean8O6cldydnUbJjdQlXqV76hcIq3TaGZX1gc8Tm49i2tOIe
	yYd2J40nNLrYr/ZCWEyT0+2+R+1QINeH6G8pOnSA7OHLgBeteMiodJ6w+gFF8rFcNKSw1021H/i
	mlmGBcjSRRz5Qvvu8GFSuJWGImhTFyETRJTibrTHFSiZo8KuINgwQbFN9K/KlsBzYKngsF1XGjm
	Q570DlR+5skEBOh8Jbb6+vHHP5OS+ze8k4sy2bID61Gi6KbwMcNooKEWmIHWNMdeFwYyZXDqdn3
	E7aAPiPARLQchZNzy3TBlQyxcOUzzD9ORgwHQNpoBvpr45sfh1rM4aHmzCUEPaEcvEk6JzeeuMr
	NOy3NcuOr3bJ7afqYVEubIIKNrw30exOtyY0iy4xm+o3RNf0xJm+f7rkrf645dlCQ0gvkPC05Bm
	fEm9yjdZVv2c+wYyRSf7uj2HfIsA==
X-Google-Smtp-Source: AGHT+IE3hfifAkpHaJSXvz6DlDk/mLRkqhCxAj7umlvwCUa6+K6oYf7ysiGZkzcmZ2Uu6UQHGGi2tw==
X-Received: by 2002:a05:6a00:a245:b0:7a4:1880:e25e with SMTP id d2e1a72fcca58-7c58e9f97d4mr6680830b3a.30.1763867093517;
        Sat, 22 Nov 2025 19:04:53 -0800 (PST)
Received: from chandna.localdomain ([106.222.235.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f024adcfsm10386095b3a.31.2025.11.22.19.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 19:04:53 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH v2 1/3] mm: pagewalk: simplify hugepage boundary calculation using min()
Date: Sun, 23 Nov 2025 08:34:16 +0530
Message-ID: <f802959f58865371ba1b10081bced98e3784c5e4.1763796152.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1763796152.git.chandna.sahil@gmail.com>
References: <cover.1763796152.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B8FC9100002
X-Stat-Signature: 4s9qymedbi5udgj56ncw5ik9uk4w546a
X-HE-Tag: 1763867094-250160
X-HE-Meta: U2FsdGVkX190VNYDx6IAoGFlDvo+7ExyeX22zA1IKg/1cDZPdYq42OfGwtF0ypapFyySWum911K/Mo3gHjWApfUHTTrLWaGxB9/W06lo2/LcMGqPiNI7QmCfWGnhKAt61dJLk9SFvMMH0nwssUwxNcZagZE0VPOld/bSmwpkyVknHx2jhELKUV0VPOjkmj+hMn0zCmluVgFVZc7eMdYFwdliKdIj95v+D0cu+q02SU6myambLT77N3Hb33zI/wVsBzvhi3hcJp3yGQP7foBctYSzl1rczVI+V3qN/adn5xsTmGE3ncYmnPB0V+Lv9RDG0nubkbqPpt/mBpsFNJKu+xnaNRYL+UWQCRefdOhOuEAlQMURCdQYLlBJA/lDAYtVJG4cKt/pZvCh/bOh1OC5FmCaBvUIP4thAZjkuutpgyx+0zpEb9FsMNEQeju4j3Frc6VXthk/ftOkLxyqF7AwDQkSTMmsHC0Jhd7byNKIPPvWJ6jYOYqI9llbGibMGnGdfUig9JZqz9rED/+OSUPQRAF2WcA2GiadAy73uppcrxdMyvYFm8jji6Nd+RAv8RsqELc3uh4enmpBpAhd6I2abBr03352lBHHJnIjdJqnumICq7rgPFFshebSQ7BPSh5LCnWY5SwWIQBu24g7SCCHp5jQwWo26p8R5tU7iaLoPOsY7XobhsQ3g8N164Xc5XprKp0zS68QU53gHHLWjLJrnCZQIGHAOM4kmIGCw4OyaCmsnJadNwJyrASMqBstXvr7cVcPWa9aax3D7aux4uHkkH3UyuTt/+nRnceVjXX1TTyaoKebHXfOnU44BRCr8IUNGFlTTsIQ81/9yTOd7KIgGzKxCKZo4lYecSjiyxoeyRvZ+efGzFJGRf6YZ3ifMGr1vEs8HPkFkMKH2TFmZWO3QNjCK/tg8rqYslw1mNnmQ9/C53GHAyKzJI8JgobZG5FBIxYh74kQMAbDN4/sO48
 hbRLahhW
 M4GjnlYVt29Vo6FCUt8MfyocUEuBzgoLmDYm4PPKo7dA5mBP+nTWm9oXSaBnbOS+8dfH6g6oBEE6fcyKZxQGIpbZ4Ox+0Rq6wQB/pEk7NHn/JQ/4gbIFm+V1UC++OlhX23ETyiUs/RUBi9/W0Hc8M3xXGHHIHJi3ZcBJiZJw6qSmtu5scSbJuGDg3TP146XZk/1Q5yIcU6Qe4oz6LuGLpSd2ghmiDk8V/vryKHgAcFJp5SMssGjyTbFWZ1697ADc1eLGITOSDhBpGMfsOaxKGAWxZwZxzjMolRmDaeDwK/ExgD+6LSSE9q8BaKWhysyQjIBspahu+pjjK9Lx3ZYsx2xpgs99tPCWUM8dqAg/0aM96fQfKSZNA+27oi44LZuHgnQvTZgrMBouNQHveflV34l8/KIpPWgbS80kWbUroSOgdW6kkXmdijQ7Na4rky42fUdzLjFCgsC/wQCxqonl5D8cHpHI8BxO0rcMkekVdVvjFpLix82cUg5xtTYE/JEQ3gjNuqXiTIAMqEk+7qME52qkMNs1JRlrnhACyNzMmTacuNfD4C16SaWjfYllwQBsz1ARbYSU70mPSWSYcYrHJyXgvE/oDIAlxekC5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the kernel-provided min() macro to compute the minimum value instead
of an explicit ternary expression. This improves readability and matches
common kernel style. Also change the return hugepage boundary expression
by using bitmask for better clarity.

This was flagged by Coccinelle
(misc/minmax.cocci) as an opportunity to use min().

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
changes since v1:
- Updated boundary calculation of huge page range for better clarity.
- No Functional changes intended.
link to v1: https://lore.kernel.org/all/ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com/
---
 mm/pagewalk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 9f91cf85a5be..1d38763a502a 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
 static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
 				       unsigned long end)
 {
-	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+	return min((addr | ~huge_page_mask(h)) + 1, end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
-- 
2.50.1


