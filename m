Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24355CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918538E0019; Wed,  1 Oct 2025 05:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87DDE8E0006; Wed,  1 Oct 2025 05:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8D98E0019; Wed,  1 Oct 2025 05:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65A5D8E0006
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:19:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 340D3C092A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:19:12 +0000 (UTC)
X-FDA: 83948996544.10.B07D504
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 29AD82000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:19:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RcLvmu3u;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759310350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=mGkBimn7OuWDRET4Bn74izgwXRI0G6KNzeiOuXgvNfg=;
	b=7Y2KwwD+yteVDTN5ZmsahoLxuuWVNaHpicXU8uTC2NLfz9Ykto/O/TK/Nu3ttYHjIXYtaS
	bbjJ82wwQ3VDq+c7uaLUHJN5/r5saIXqyoT+weajnbE6nk604y3w+OvSitWNdA1w6JH1iv
	x6LCRBp1Fw5tCGmPidx9xcwAjZb0chM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759310350; a=rsa-sha256;
	cv=none;
	b=cjIWdUqJN8lKepnnbat9kf5CCRFyzAH7k7S/33aQ5Ot6RkbD7yLUJWBug/lLTsr5coZg/Y
	n0p9K+o0ics4fNdPiM8m50ZGU77RckWJTLKnyDbJU+ng7asX3r159xkhzjvIoxzFrib5JM
	cameE7p6EziEFgZpcPLHqu+xPPoHpZ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RcLvmu3u;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3b27b50090so715939566b.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 02:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759310349; x=1759915149; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mGkBimn7OuWDRET4Bn74izgwXRI0G6KNzeiOuXgvNfg=;
        b=RcLvmu3ucaS8Y8G95Ll4nsA4QQUDGGsJtjEZHw/Yztj7yY1/z43A6argtSkRzI2WPQ
         TEjmLFS1EfX96OZ7qMcGSheBJpCAuxb3bu0hfKmfigT5ksg46ZqUqm6+6EX3P/pzEhDt
         EhdgMVhW+Qo3zrXRLNwk2ebP3ELn2L57T5Tw3XnGhKvnnDQTfH7ISsL8boxS/Ave1okK
         NE0110vK0NICnSF3WRaiRAssfeTgvYUC5XcQKRLAC1kiw17pZeo7I84xYappoSwsF1KL
         /hIL6jdpLXL1vV5bpXmsUqRn9MuZTdG5qnK14J8iAT204mxtK39XpsiF5qG9dF2DdHAa
         zlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759310349; x=1759915149;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mGkBimn7OuWDRET4Bn74izgwXRI0G6KNzeiOuXgvNfg=;
        b=vPruZxg1txMBOz8CBCe4zYuSm3jssxsMbNt+vtTrkkwU4d1ZFANM5FJW/ZsPLge10Y
         6Oa5F+NNZcLTDP+9wfBIjVq9Te27YwglyPghpff6qn46FX8Yynx0u3/NxGKsfkdQFTDT
         gc5X79/pdrrh2pcNlnAjIsFxaNlQBsaA5kkeUV551OoAKiOpgLZpgc6chNigDwy9nxVn
         tDjSFxL7u8Xcw/7YuYKHZOqInWke++v+EilSoTlSbwp4XCb9CjhsFP6VnMIIeZy3x/Tl
         1yGBOcPE1/iFVAxAY7s4sXZMPSNDuB6XkxUuIRIB3R3GC0gVJ2egBwI+Ecw1eS5sxHtk
         ReJQ==
X-Gm-Message-State: AOJu0YxwIYaUlMH9nkJBJhpLG2tBtr3ontjyoaoM8TOqajZYHMyC0G5V
	ICSgn29JjGmJwPIvAWb8mp23myd1eKoriSu6Q5fLBedxTgRclUwcBqK8
X-Gm-Gg: ASbGncu1qLIw6IIe8dZWrdXv/XagvnVy/G7bCukWlh+K+z2nOP1us/Naocu5alxQbkJ
	j3G3dNXoLLHu9tM1jdG+29gciPum3Cow8FoQIJ4upRBT/qj9cwHsKVXI3qFU/mDeuqwLdkL5zDm
	ut5VB30sTXTu6gPEO2iuvj6XJl/bznZDxV3YRTUIXHJ1HP+kZSrIgsgOd/LU1zuDbpiWKQi2yw+
	u4gnCXEQZW+N4t7Ts4IpepvbtO6Ncs1WQXUefk7W7fCbbuz8MXGqzpabCvjoiNRU5EGah2ga6d1
	m7H5UXWJnHCL2FvIiJbMJqxXlbo6R2iaLeoF37ZL/gA39u0tx4P2HH7IkIQOIcEWpk/93DwzJD9
	sPHk68uRkW5Vs2+9vYrhz8+oHofUxI2If2IhEZa8H/9ufzhds5OpF8LEnLk70
X-Google-Smtp-Source: AGHT+IEqXfkva/s2FgHU2SzW+vMdrADU0IVV2u60mPU2vfOMZZ/6Gt+b+BU8EM826y1OLpf0R0g1CA==
X-Received: by 2002:a17:907:26c9:b0:b41:873d:e226 with SMTP id a640c23a62f3a-b46e0daae8cmr341026866b.1.1759310348343;
        Wed, 01 Oct 2025 02:19:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b353efa494esm1327841866b.25.2025.10.01.02.19.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 02:19:08 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	kirill@shutemov.name,
	raghavendra.kt@amd.com,
	Wei Yang <richard.weiyang@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [Patch v2 2/2] mm/khugepaged: use KMEM_CACHE()
Date: Wed,  1 Oct 2025 09:19:00 +0000
Message-Id: <20251001091900.20041-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251001091900.20041-1-richard.weiyang@gmail.com>
References: <20251001091900.20041-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 29AD82000A
X-Stat-Signature: 66hf7y14w18ngi83am33p3x1rp3zgnns
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759310349-825799
X-HE-Meta: U2FsdGVkX19jeGobV27xM/MIEwF7ztKl0ZDW1rr090gOh/J52EewYHNQ191TSp3qkniwG1wnpZ0tnKmfj+svAfYtgW/Io2XAIjyr+PAfvmnwKjGQR8fYOrOE7fy6X34rBm57OLkutqbadTwO23uRdAlIG+RTgMumMXzwD1JFUy5XSRc5ypk3G5dkGBtzbxDqjBDdz3zbz6Zcx7WCMok+2QTmGGSUOlVgIx3gRZWLEEYzM3VTtFnwghYMgHVdPfj3YRiwwvr7Pi8AWt1Us+Zhm7tOdc/Y2XR28t8XvckWgPYwyt40iwpicHPQTtiyQwTtItuyCi9OqaAC/pjUVTqbM4BhfJcxg9RJN+/u/qtPx78wg031BnAMCDRNPSn98gDndXn6loyGWvFTZU71GSvDQr0LZHIzyeyMcOdbJMF+O22T9Iw4oDEOFO5yTAF7xVQHGoBzPKFqiTN5Lh7PWF18k6dWkGPli0YlJfJ4KU33QaLNM+X32BTjUBa+etvOeUy4OdQkGDSb5mAWV8+yywQFDWuozBv7QrbCmWhW/zP8syYXipRG6QaFZCLwfc1fv6lpuY8jJLnskcxtPP489S5XK9lp5fniDkH92ypnTzY86miaZYmidTG4ia4ymW2GqMeBsLInaB4q9hAEjQUyrQJzF+CQEpkJqyG4+yBVgZ9FQqQaE2k/HpTF8a0EvYsvj7G3OHWAsHTWV428knFgP+B1KA4uWC7ZsLdeG51Q1yZxMEuIEJYJ4Z7BNnrP0y+gPRstYe1bPAhqTQhYVt9xhGriQz9uFno2kmJvQzeTmv+2zehcQcx4ukxN0K2dz6Z//v8TwfGEaWSLJKAdo1YFpzrVhFomSIwD2jnciSAD6IKwFAaIXr0pingfneN45spE5L/LUC9PLp0IuPmEN17DotH4H1EkDP33jyijHXruxaV4nl0ZHSh2eW5q+Odc3E3wnqo6XQz6n/yJ462M85bqU5Z
 mHO/FEZu
 swQQ4D3HFUcxrDLontcac8X1qpiugnj7rUIQdCMQaPUy3k8UFeWczax7dY3RrdTr7l3iiETE5K5HVGHbHAev5bvnrxeRI2/rWztcK5NK4KWWyHl4kWCDyUHfUppwv9lsB8QdI5UClthrAHIrynkrf64TgconysQLz3xOMxZklCC2OCRBWFeNftdmOV2n+YhtXQsZxJn4VgBj+h8djnieUEKBg8K848qEjY3GLhjyxakcJw7qamb8FcpYLD6N17CQu8E81+BBDgDrktoSNv914dB1HiDEpnZLIxgpta9UQQNTJ0AQvMMSKXtkXuOOtwj077I9VdMbfvR+qClzra1ND2f7zcYEO26FRaw9LC8U/mz4ux+20Ay4DE7UoQoRL/SHjhLGNEqP0jpAFFse4LvQ43DTost7owFRHQooJcWdClhXrYF0hMgrohENzC1Oy8+vangHbmZfxUHsp1JhWYVO5Qp3v5KMruk41TqNpy0ljGVk92xRPpbqJq6WQGwT4ofROwhuthvQEADiCXjht++YN1odgRsdBT6EmAEAOWmmEPwpPrTEEYBIXdZxMhWUJVd+MBG94fM/uBiZ2YvgLR02VcCfTLqLTytkaw1mnflqhuXsiu68KW6DTPgyZI2fGjzS3edRRhYBNp9Hh325vCnKX23U12LxElBY7ZnxMuTDBJa1idf5XRV6EBN4fG3mNMkcNFIut67jtlVpQHI0uwPurWXoc8a+L0tF6nnfi73xCRRCgOca+SrpdULU/jmNNEM7kzlon9yrhlx4vkVfeX99PuqSr79G2bVR4bAnujWGhnPVaVMPFz/6TBBZ654KTNI/TlNmk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We got some late review commits during review of commit b4c9ffb54b32
("mm/khugepaged: remove definition of struct khugepaged_mm_slot"). No
need to keep the old cache name "khugepaged_mm_slot", let's simply
use KMEM_CACHE().

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: SeongJae Park <sj@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/khugepaged.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7ab2d1a42df3..abe54f0043c7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -376,10 +376,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 
 int __init khugepaged_init(void)
 {
-	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
-					  sizeof(struct mm_slot),
-					  __alignof__(struct mm_slot),
-					  0, NULL);
+	mm_slot_cache = KMEM_CACHE(mm_slot, 0);
 	if (!mm_slot_cache)
 		return -ENOMEM;
 
-- 
2.34.1


