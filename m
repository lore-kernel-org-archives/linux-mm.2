Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5E8FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADED46B008A; Mon, 27 Apr 2026 11:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6B86B008C; Mon, 27 Apr 2026 11:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD436B0093; Mon, 27 Apr 2026 11:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1556B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:40:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4307162253
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:19:57 +0000 (UTC)
X-FDA: 84704696076.23.3BDEDFF
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id A532C40015
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:19:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gSBaR4gN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777303195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=usk1/8Uksof5D4EAUuc0RHuJLqvox7lltXnGGJIBhs8=;
	b=qRCYMjXTK8+fIid2wFQf6NYPZnb+BlcXQTXewra9zJ1FR4l5h8kM+4EGsTfzYfziaXtfUh
	yGjDCfak9M4eK1opB8ToXY/RowehCPksSvjSpp53AQ1cQr+SHgFylKuCzSJ1pc3mHMa/3C
	ye02huqjMloGWQ0nZ62o2yupnVvNLDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777303195; a=rsa-sha256;
	cv=none;
	b=yCE0hxmc0PH76r5UaOFlKvR5Efu/Qs0oIjkjIwPnhM2fB8jQWiMjwjNkKrG8ut2LG/iRtI
	rKDCOhKUt7TbgV79KtcXup/bl1FGd2FRBhqNg4zCSwV3SU8ZlpxUuL+0bT8U6WyaeuH3dW
	m7VoZvHOLeX3P4QRCv9pMIe6hURt9xU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gSBaR4gN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b941cd869cso13065035ad.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777303194; x=1777907994; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usk1/8Uksof5D4EAUuc0RHuJLqvox7lltXnGGJIBhs8=;
        b=gSBaR4gNxEbvqp2pFOT5GpJkJN94J1dwK/C0HbEWKeJqY2APe0qQKZJT0o4QegKtyv
         wbHdj+UsaiQtr4KubfothUKQwDRrQDvO6O0tc6JEPTq2MaRMD9wj/BbfrWlwPxlfoBhA
         /ZFNYaNd+KoqtRAoCtJNzdghPnusdABgchRo/R1wLiMBluh3SR/XbUUNHIxNV4D4bI0e
         fOyeBg1OXFfBzXWHveJnL+KIhGbUTSX5eJYQbg1RniqA+gMPgi7Civ2m16hPlYMK6n2f
         Ls9MaRuu3FrIRDXehYvLCmtLZf+exOB6Umaxr3pNNnaQ0HcAkMeUjo/U+jEorvrQz0tQ
         W8Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777303194; x=1777907994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=usk1/8Uksof5D4EAUuc0RHuJLqvox7lltXnGGJIBhs8=;
        b=bR/TVX6HbRCagAVFxyhO6WU79WDdYBqePw8qGCWQPt0/Na0u+oVd+l811HomF8TZv4
         dgy2w5baY2J+cOv8D0JYhXREkqdEOE5NMZ5xwbYBXVzAiZ0Sg6MKNreF8VqLcxSCvJ/U
         erH58kp7APoan9BUzNqgz8JobNRrqDxUwWkLABmlhNs7ke7Axbio0kNEMbiwN1F0Je0q
         2rM0ie5+7JfJcuIBXRyEuI/HnCc7WIzlAEOrWBNJgZlnZPbsa+qDD/gCRZGnh8buxtRF
         lIL+jlc6ZZNRj48QQGN3+QTXyovrWqNzcxqkWct6hOprhNuexxvYWNEixbKo65a1/lKP
         kFtQ==
X-Forwarded-Encrypted: i=1; AFNElJ+e7yj6IJcEdBg31G3lH5HQzSkbI96w9npFvmBC5Pwtftf7o1B2ltlsyVN1nZpbM7gDqEXXSpjdaw==@kvack.org
X-Gm-Message-State: AOJu0YzdbXM7CJEPgnj2Coxpw+JwdSx1b9D8s7DejGi9n3jwt4aZhlc7
	IIOvO5IHUQTFlG5C6HxiHA771Nk2DOG9+5baw2MB1+45UmO8ZTqGIK/Y
X-Gm-Gg: AeBDieseD0iZm5+zBJmodYToOREtSXRNTLQrzOliMDd8m9eF8Ztq5GUwEZvh7SNXhQe
	i4zwPaLADDU9AiAfLLbGHtGRt+hb2OyN+aBsCAwGrlgIjCgqDrO09yFsNaro+0dDQSg6VFn+eCW
	XzPWyjrQec5xyJotPqG4f7rcnZRxidFl94d1fm6CNTGhGM0r7DdcfEFHF8d/BnxsVXhY+aaI91n
	HsWC/oXNgmz86mP+gfbzDQJZb4bH4XZwZf5EUf9d2zToZ3LR7eDS5pCPWUZy+uJFxSwPBMCt4b0
	OAVBosC9Zge0ldaPQ6zSm9LtIdGSENmyCyp653bmzXVDarYvDbsV0g1PSZPdOZoTkkfErzSPkLA
	j8AWWOeBli9YFcP2KDnqk6TqVoMSUmBNBf+pmkE8e0wiw/rvoAh6+990oby7NMngqfWfiAOZsyk
	zivNVn/X7qWXjY6Tu4F3h3kwtHfULzWIdFpTbeL8+HH5BEnvJA/70W5WPDeaJYNlpeNGlc3SGB4
	jxvy9dAVQ==
X-Received: by 2002:a17:902:db10:b0:2b2:4a9a:b149 with SMTP id d9443c01a7336-2b5f9e79dcfmr472245985ad.9.1777303194199;
        Mon, 27 Apr 2026 08:19:54 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([240e:3bb:2e83:4830:7639:89ff:fe18:ac64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0cd18sm331694815ad.45.2026.04.27.08.19.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Apr 2026 08:19:53 -0700 (PDT)
From: Catherine <enderaoelyther@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Catherine <enderaoelyther@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix subpool accounting after cgroup charge failure
Date: Mon, 27 Apr 2026 23:19:35 +0800
Message-ID: <20260427151934.88683-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260427081213.7935edd49d96622b08e81643@linux-foundation.org>
References: <20260427145247.84157-2-enderaoelyther@gmail.com> <20260427081213.7935edd49d96622b08e81643@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A532C40015
X-Rspamd-Server: rspam04
X-Stat-Signature: pp9kfrx64ky9t1rj13y3endxod8rcwi4
X-HE-Tag: 1777303195-887155
X-HE-Meta: U2FsdGVkX1+C4xYFFWeRnb5NmImBv0dLceMcqDEYgES4/yCmhW8AO4J666tvf6K8CBHMj/DWOzD2uFkHcG7m3DGT+G3yhjWlQLzbWy/AFGTWiNPZRjyQ2/SUK5RV//GILNvJxnz9gpg2HNWzFCYri5K+dGk7hgWHHvCN9KckVSglqOWhJxTcBmWfdheGmn0AAcOb3qNkIsTrVku5b5fjBUwEOMNRATa4n7UZzWzKbpRB94hPFMlojlGy3NYbXuYyNxJVopXsCsyP0Zna4Jw7dr2dSl3Cwu30HX2U0YV0xJxH40wh/2nxwIutYnVMY5YL1szdSHcT5IjmE3MezhrNUA4SCHHsI+L3usov1lJy9JCiLRnvDEUFaTTcfnMo8726NxpEqLi6MftN8JOqhmqQz4AMBm/BPSVgSJMgPMI08GrMgcQgq7KSUcbnXSLd93pqBtWdQvfqeY371h2vtzo4DVaNE7OuaL9MUWh8k4UX3a1xQdfcGya3cfWFPHTD+5m3b1tCu+/JUxbSIAewXaKF6SzbiDoob/dQzACIiOSyeZG+rPYYUmBpyEKJQhmZOKkKGXq5H+F4xR60Fg+f2sgw1rPZw8vKGCjv81LIk4m7dhbh0/9LbMm4UYqf40RqwgIuICo2nXLrxG2D5IgizuaM9mPboT6O/SN3GyM3LvEJWVZ4zzLk+Y9Qc7K8s8ebuY6ElKtb0HoN2glhuMt5HsaUOc3R4MKF0XiEgWSbEa3M1rN/zY6H8C/PdzuOaYaoQypySYmCGzmbGtdfNpZ2RWP/qmI0Mri4jAdSTQZCGpL9ZJAoaGqvSyswPNcqhAPOwIGH3Z3FjJDg7MRLepjiQL48sFkilVlADJ8O626rmuToa6EcTYUtVh8L93HSHQQ3wLbopAXLTVE70QWT4N/tAzqG8uMVpmHD76HZzcRxeW23UXb/KwQxTJdpZMKn33s47gXqLUE1wR4joWUZ85eUMvg
 83xm1f64
 1ZBChf/dMlXn6cFgxtp555GSVQqzdiJHiETipQ/3FHDu+rvNyFJmQQLoO2LUSwWZNYMILB27TNCNC4HjnMlQ/CMwd0rLKr9wgGHSTXKB5Wyb/9AOr2zAlbAn7xVE5ZJpELNKjAerhImuH3GDm8YmR7iwmp8EpixP/Vo+vo297JNod7nmHMFyBPem+jqn7+YZelnj3N9MhkeZDssv0y3IHPxtEdX135F/MUEDMAtiE+P8k4FyVs9eVRmxHlHdbsdIZpsxAmE4ngMzeCySvErtYhgL8CcMFOVqoJTcU3DcVOWZT/fWhKUmjYoRoUFQmKxuCOVRbMqPUJuxp0X+IMNmN/z2k+PptvCPLEIB1VAlM62W9DsKi0u1PEa74BBbpDO9hfgO8/283ttUgWIX1y8LsTt4T7s8vsMqbsteeAc5h83lSI0NMlrq6YWO44ro+WzJ9NlY+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

My real name is Zhao Li. Please use Zhao Li <enderaoelyther@gmail.com>
for authorship and Signed-off-by.

Thanks,
Catherine

