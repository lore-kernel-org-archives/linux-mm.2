Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F632CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 03:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67FD98E000A; Wed,  1 Oct 2025 23:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635308E0002; Wed,  1 Oct 2025 23:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F74F8E000A; Wed,  1 Oct 2025 23:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7428E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:31:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1147587F7
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:31:48 +0000 (UTC)
X-FDA: 83951749896.12.139F044
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0641C14000E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:31:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jw6Tp7bu;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759375907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=DZ/+FPBp5ewZOZmlyRlAIqfnrEXjmJAbbb4NEVZDb7s=;
	b=0jlG0U40B3VPZHq5RMrec122biUhV7UnLfCEZzlLOsEeaf12mt/Pcin9zojHg2i64f5xtJ
	1I1ABD+Yit1dltZY/HWPSCUcyaOMJ72w7pM++pyirI23T0NQfu/1q7hF8KA4hW+k3dhq1y
	htSyde/ZAbeHR1+vwJxDGj63qb/l54Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jw6Tp7bu;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759375907; a=rsa-sha256;
	cv=none;
	b=3TYc2ja4/aHDXu4gGNpXJlHmv09jXyBWI59JRAz2DjY8kZ5iHZb5evmlb0fbv2Omdd5kIi
	q8HQ+Ardk4OXOJ3O9P2XwG080WWSKctBZJn+nPelpVk8CvF86BtjlgpvzzdGirCvBo0wX9
	BbOStrOXoMV0HDEaRhJDVn3xHaL2dtU=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b4736e043f9so111077766b.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 20:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759375905; x=1759980705; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZ/+FPBp5ewZOZmlyRlAIqfnrEXjmJAbbb4NEVZDb7s=;
        b=Jw6Tp7buNkJEqnitL0b9gO3P6Boi+USbU2NeLGPr1oApKaiSGs3M0MT8FNa+y3XlJL
         Ap2CvB/k1ei2r2DtSq9vKcY3skuEPaUM1g2N/d7B+TxpLrnHOjpXAP86Ug//7d6HEJ9m
         VXkc39wt3uw+3QZP3UFre5cvDJqPiOtfkKjrKleWXkC0WRbQMVWsUR667Cg8nUmuI9iE
         2yYowAQ1z3wkeL5U+ZB4uV7obKSZ4a+ZiMJdevjKxNjfXyX1Kf9Pb3vt0SNl/ZdO9Ai5
         wLS+2QKcrMm3cYS3W9Zh2R0ye6LIiSJp3HZf2wXIHc5nqtfoQ8OF47NLpaZZ+n5WU2iE
         idwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759375905; x=1759980705;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZ/+FPBp5ewZOZmlyRlAIqfnrEXjmJAbbb4NEVZDb7s=;
        b=rb/D9g3p7F8noZjnOb2oYY0bKVrrh1ET+4oMIlWNJha4zJCpQ6DQlI22Oksf87qJ5p
         K3Uvxs8KtBo3//5Mu9nos/jR/5mPOxiAlXNAxPe/l/pySRW1dl8exolJNShK/kGcweW3
         vh4oeCzkTYmC5LQDdy9DwWsAgASw+9johXMqPKgfIC5Tg7uXKc8JpB38TbsGnWKE7h4L
         sQBI/rWYE7HHetLW+I3dFOLJUxTa/4yR0eqj2m2YI2evndBClUTWFLWFKmtYXi7E1t+Y
         0EL/KdwcrnKCtORg8uWQzcGJWCxwNsV3vnmutzo83/UyxDHhxiAhO+nMgYfVp02/t5RF
         Onvg==
X-Gm-Message-State: AOJu0Yyr/75ziFSwKfB0iv1nT7KpzNfyDP4TRVEGPDXigrLnD0vBRWiU
	6E7LYe9XYkHLi3nYmOe1Kk6mE/KCTOAoa1+KfUEVk9QLCKj/7x5c+/Y6
X-Gm-Gg: ASbGncsspwDSUg503ekE/B6M90XTQfJBHQQMHtwvkhCf6YppShfydwODX2qkgWCSKQa
	kEzl/AtKwb2loPr1tkkHias5L0VQRDpb9NdyD+S878FBKijAUEYRbVKaHxg+NEsAnH1pGL1Ebc9
	j3qfqDP52rHPdorSLgsBsxf6Klwte8DaTvwbkSFbH+3Zbwu7xiEirzMMrJF4WdniDJ64+h5OQdd
	taWKL0oo8NpDJnkxglGUQHqzcS4IggtQVwz4PaRIOUs1znpICzE59UuzeaC6tMFsm5UcU6RH/M4
	f9Bgj7MmpLGehLYTu8wt1IUtDxlCEZl5FHVNwb38bLhp6UuP5eTS9x9N/KuOLqtj8KeUebefdD+
	vEJEuqppg2g9oEo27xcw4xl89l9xzSFktIK8dh4ZRKFaGx+X/Ow==
X-Google-Smtp-Source: AGHT+IFwMRGXn6UW+v/BVc8BN/QhfwbKV51dO5Zz5XJE5yvTO+gwfVKQpPk2PKg5mHlrE1q1b+PrDA==
X-Received: by 2002:a17:906:6a10:b0:afe:b92b:28e9 with SMTP id a640c23a62f3a-b46e8f7dd00mr678339366b.49.1759375905206;
        Wed, 01 Oct 2025 20:31:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b2desm102887266b.48.2025.10.01.20.31.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 20:31:44 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	iamjoonsoo.kim@lge.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 0/2] mm/compaction: some fix for the range passed to pageblock_pfn_to_page()
Date: Thu,  2 Oct 2025 03:31:38 +0000
Message-Id: <20251002033140.24462-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0641C14000E
X-Stat-Signature: ufmxeu7ygd3zaiwqe378o8f7d6pbrxgq
X-HE-Tag: 1759375906-161113
X-HE-Meta: U2FsdGVkX1/qUNKHzxxkfI4pjHARvxPwC5bgzmTwxyQ6+FvWswlQ33vBIES0+WtrAvIkkmFDhSI/qGQ9VgJgQmi60nvdVNJt0GoX7/8Yjj9q2MWi1WA2GJt3e+QHbPSXDOzCrRkfrc0xAPW3MuwRev1ERJXe3YJd+186v9aYdrUCRE7julMI4OaUzhCOsuEw/II9KN9jrMZ6veot0Fo7TbCF1H+D8yZRjI+E3Y1Z4ZcEwnW+zxH66YNq/P91emrPThy4RdAA0Kdsc4ygYv97WoWNCSVPSaBhM6IO2StP/ErdLfwfOd5duOx6nS74zGhrNSXznbmeU2uXuW9CuEJob4SJ+Npavvwv9IjU75x0uFK9qGN0bbEe6mPZ8G/Q6qgL6R3HXt+aIKNNYthebUbLZ3R7hoQAULz/mOLDe+Nzgu+rNfXpltZDob3N/OW1W+OVGASSWEo2xteEXKGCyCYc6wAjPGqQLavrfdoeBaToAgy8EhvAJlEjiOGgf/7TCKBbCbItTZqYhuCOrMOCrRctUJmYjnXHxPDFpTYqL8JaI0IvLf5K7RWAOWgMBvXt2CbGAGeO2m66wVl+OVc0GRosspNYY7168EAtOlHCAw8y3DeSz8xR2M5ewciu5xg07Ck4ubgEVriGeLE33N4n7ZTF6S8rORSRXLdvhPGW1pNzgJX8hiu20AQiH5WFbWlY87HrrDERwLZq5NF9DKm8/OTNCP5OcrFL0pbD6iY64lRptsr1Faq33aGdN1osxz4oDpHuaG4j45saW0Kcyeo0vopdZaIx8FWAwd+4/DfQpPJNhSLApBR3sLhFsBsKZK8qpZfbidI7F8B4bNvvO9KkSpJpg057143MWY36pttZ5Tz1EpBNuwJJ14MkYriLAWVzTzBy7NA4unfmyrIgAbfNorF1osIMq/rSDw9Nt3gjUHH3V+3FQmixqs0tJIUHn6B23WIXKVEqsVMPsh5xfDDqtWj
 J6B9pmO8
 FLnxvsGbiD7sys8M36wAlPWjgJjoq0epPPTUEflce+8siFdn2mefFz5fBdLQjKzFHQmDqwxRHPDzJDY899L+L941fKkLSLNrM2hJbm06t+hVifVdI9rnzkEYBqW72dxPkATnv01JwFZ02Q6zxZDpiDzIEzjfPdyQ9zPSo94IGqZjbPvcvUuOJguKiIb3a2ziW6gvNONDRdPSodi55gsCLcQKxEV8R4zvW2b2EpeYzQYq5NxuNF84aLYYWMFROJN2mlalFp5/RoPhzRbdCTukFAfI95Rb7b093jQrrC2vDvoxpU5aWUdkxHZCFGCWqRjHcRbDpS5NO+zqaFVeWuKcxuWMRSO5XqaZv06/Uk6jD+QRzs5Mlfeex/rtuZ7G3GLPv4Dnrn0UA44IRl39RILrpJjwNu6fxELuj6ftKqeS2vBZOlasoeD+raejpEil7yk/hq0EpxWBLtf/t1k0mbSWumm+7yoOJNHXTSuaGBF/l82BQATzWAMNTPdHUk/U0pnPSLozkUoc+7eNBe7DKQdvxfTM3zUMvBA4a47rV7SnRpYOJrvRw+cCSXoPuPA4Wt8g4oeX1hazztVvbHnA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During the code reading of isolate_migratepages_range(), first spot the range
passed to pageblock_pfn_to_page() is different from that to
isolate_migratepages_block().

This implies there is a chance that pageblock_pfn_to_page() thinks the range
is in the same zone, but isolate_migratepages_block() will isolate range in
two different zones. This is not what we expect.

Then I found pageblock_pfn_to_page() has an optimization if zone->contiguous,
this means even the range is across two different zones, it will think the
range is within the same zone.

So introduce two patches to fix it:

Patch 1: check the range belongs to the zone first
Patch 2: pass the correct range to pageblock_pfn_to_page()

Wei Yang (2):
  mm/compaction: check the range to pageblock_pfn_to_page() is within
    the zone first
  mm/compaction: fix the range to pageblock_pfn_to_page()

 mm/compaction.c | 37 ++++++++++++++-----------------------
 mm/internal.h   |  3 +++
 2 files changed, 17 insertions(+), 23 deletions(-)

-- 
2.34.1


