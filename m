Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5143FC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 15:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83AF8E0008; Thu,  7 Aug 2025 11:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E334E8E0001; Thu,  7 Aug 2025 11:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB158E0008; Thu,  7 Aug 2025 11:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE8C18E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:27:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 479D81A0EBC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:55 +0000 (UTC)
X-FDA: 83750341710.05.40633AC
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 54F1F20010
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=imnGMXF5;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754580473;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y9fWWBXBlNjUcVIevwpnMzei9v9cyPF2woT3bX1UmP0=;
	b=kq3ARnNmYM0TSQsvUjsML72rIQK7TPX1pQXXJa3qXiYYzzGj5IevBPby4x75/gv+usBhR2
	o1sCO0W7mf3AcV//c5OuT8YA2NJusnwpWjh4fSASfQDpf/UCUWLDhHAvQV9PIV/SlEPlmz
	Kwk9TaguSbaQi0b4aLJfUJGHsdu3ztI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=imnGMXF5;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754580473; a=rsa-sha256;
	cv=none;
	b=EJYDYM2C3zriEndxEhbtuXUPhLlo+8JwiOk0ryQlpqtM3GbySqwN3ewPAMbaTdoivDq/x+
	HWLqcrdFnYfxA43fpVvp6gS03BjRrOOqsiTuZpFbLgJcpHwXwDxVehYsZbnAc6QIuo4gC8
	2G/t6zWtcAVmQ5aOzeNov/4rlXWYTtY=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76bc68cc9e4so1306220b3a.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 08:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754580471; x=1755185271; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y9fWWBXBlNjUcVIevwpnMzei9v9cyPF2woT3bX1UmP0=;
        b=imnGMXF5EXTX7lXXQ4ozNAIWaS1cRQ87eO3EfGXnfYqFowfYl5K8ZbPwlEwECa3nmw
         opAlr9wSB34DB+fOKhmSm6j9kkmYM3FqOekoLC4Za+ngvq/8aoiitxphQV12vN4Xs9I/
         U3F31hWiCVL7110OwVKLOeu2LzIcBsjGPKPaFti+GXD1JG2517Lkj2IAwBhRDrdqJ4rE
         jm6pww9wMTDFIaWNaS84Zg+lk3HBCleDvmBfCc8aqlUXFie2z2YbDJ5VHKJa63ZcW5y1
         yyf/Tr6w09vvAAlDc+A6g39MQIKBqhj5GJ8sPt2C8f+ry8GoUlhXdV3a+L9kqKe/swcn
         xRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754580471; x=1755185271;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y9fWWBXBlNjUcVIevwpnMzei9v9cyPF2woT3bX1UmP0=;
        b=UtZqY5WuukCU3A8VG/kujO3NJzKLdiHz58Z5D/8r4L1Srg9PFUshYf78rSx+3PZoub
         sQn3YEtr9RrGkTFuKm5UyvfxTgXGSjv3CKjC0hFe/0L/svDF/B8Wbn11fTEH+CDzStIP
         rBHORgkpX47kFKhy+hRE7IbYlKDJDXOohRjY4pPakMUxe6I11jSqq8uBXjG5b4vQWyH4
         8YFFVg+SsH7fibvlUBGi8vzG6mwk0werwsuRdqriEuRMYAPQorDByDs7pkvJGt0nzod0
         yP9MjGIwt3K+jaHuRcT5eDnHmIC2RYn8vmjVYj2+iL+fQr2OTSkTRd4NzshmJB6s10fr
         i1qQ==
X-Gm-Message-State: AOJu0YwKMTcU0/NZNvqnLQWuea5/i8+YPR4XH7TW6HlspzBTdks5OxoU
	vfODLICU2Zws4grWkJrkINizpbexQZWord1OWHPUGEP+VhfS+roAwXKAhsPa+QQBlwY=
X-Gm-Gg: ASbGnctGa+IrQHLdyE3wLDC89JSFRYzYlk5STTKqGJTfLWBRbKGAxySlA2KZwpwzpaE
	NWrH//9EoiUKpOBujUa2Uew+E89Ju5+fUW6bLdAI/CSyWJ96YnUW7rcpQ+V3LByPvllfa1T68W7
	/PwBsg2Cj0Xm5uCuHk/k4Jf9xH2jOG0PX2dKsA01HnAi1EQAiaaZCj8xbvgOG9TTtVOJuwl7BVg
	2vqUCZGHxRymaSzVd/MJ7D6Dzwu0LbiSpUJeYTFTOSqgYT5G3BWbJNanJudflQAYJxDjg5wyYKK
	nKL7DeQKEkrmhmjwHjh92lrXcoMJ3f6IBVJxZWIgkCh4rKTtBfQJtHoCXVNG/u+npyVCVvwkrrY
	SdefU+5rwumo/zsbO/4RUt3jC5XRiMGy3jb2+Hg==
X-Google-Smtp-Source: AGHT+IFg/IpKtoHQfbVW4m9sQKEKh4HvSlaXW/D9l5o9aVDbN1SGN/f6aejupBVl7miZ3sFekXHHKQ==
X-Received: by 2002:a05:6a20:72a0:b0:23f:f99d:465e with SMTP id adf61e73a8af0-2403144953bmr11066684637.16.1754580471197;
        Thu, 07 Aug 2025 08:27:51 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce6f319sm18430540b3a.18.2025.08.07.08.27.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 07 Aug 2025 08:27:50 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	David Hildenbrand <david@redhat.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [RFC PATCH 3/3] mm/mincore: avoid touching the PTL
Date: Thu,  7 Aug 2025 23:27:20 +0800
Message-ID: <20250807152720.62032-4-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250807152720.62032-1-ryncsn@gmail.com>
References: <20250807152720.62032-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t6m497jt1quqhyy98gxsfdn7bs7jkigj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54F1F20010
X-Rspam-User: 
X-HE-Tag: 1754580473-61339
X-HE-Meta: U2FsdGVkX1/xsafRWgAIvRJKFlKo3Bzy19fzu8/UaFPLDgTS2DAt2iEDESFwGupOwPHhvY7LAXmBbky4s3HPzOEGons+h82+ua3Q54FZwxvgVdrgj13Kf5gnUaj4h0iTovxuO4+rCzbelhAzYH1xsbreqzJDxE3pWUvQjIvXxiHpxcLJfSJPh2ze7Kd9PnkKpSSxIZK3U/INP501T3CP9+5EE+XtV2VEiTqenwkczQX8UfPpJC+LHg6vmoawZavSlKD4m1SqMR/z1P3P4YjaDpFAq7kLsIaa8XB+j5tZ5kP1eKWiCic/0kM48JUaRjq8SiREBLNoBCi24GK4RzJgyfwvjTwq/WGR8/kGUgIbc01NIg4bZiNTwXUxFRimiHujEk2MgtVDYLqc7rx1rGkx3DpzafgplDUAWYDMpbEIeUsVeUp1gQM3nipi/K86ZfQa2xUASF89D8oQ49797kDVj5QRBlxci/swJD4bKsdfd/Hi84cXBJe/Yobi9Rw2FIiv8H8fdbI9EMb3T166E740ag+2lgF61xaxr38yLtN5jokh0wRe7k9cZAc38xwESWIgWh/NhEn3wUe9hbE04E1Xgwr9oSmssxofCBdf1QcERH1qGMfzua4eNVls8Ahbq3s2gdnObXcG6767VOZx2M3p01wq5vbe7bIt/QCptu40vL4pJGhL/YTaZR9bcxdsmOXRHwpxUQjPgjjMgDZYXX+8FkkGeUUxvxDTSLuI3aWtmuNQoMIo9pw3Ry4G+M8AvLXpG2EbCwlboQ2PbPQaGogczoB5Z3dcDGhDwZWI1DuQ152icnWKdgYb9AeXKY521AG+gOhr03sAtHtZ2beVgTiAl70tYrXbtRnRLpxZSD7G975K+Ls/7lZBg5taO61dVmkzMmQ/lurt5fk+S+i19q92nn+oEpTtEUrsT6AbysrBrHO0/VH2n0RE3sM5kCqSSiX1M+NhUi0T69AZQr/UWFV
 Ql8elLQ9
 ZNGCouDSYLW3+in3tFTP/YuLiO3Oz1R3jS96fovyE14gLK2OZR3n5cRWu7BaYg7pguoRnKGxszGli5t0+yiLP3CkwmyA5rruuTACTi1CqO7hdMiZ7bDSRRu5wt5eDhwCgRPz5sIfo/IoJ8oB46fW17YAV0mdlYc7wENBKdRXVsoi+KinHFzIB6zcQvoJ202PH2U5xcRfQ3Db/Od0firdSTv5O6ObIOlkPEuzk98A8CLVEfiNVyZ8amB+DHYz69j8/gC30XPhipNdJXQY8go2FGJpHkzhCwHpys49Jv8/l2DPOG0imcjQ3jIBBXObkrC8SYXQQB8kn3uPdFdKxaBQSx6wbNgxtT0YX0nhstvg3vhfLieGFkAuJcGD5lnZUdMZsErxtuUd9eWeiTr71brZSZ2EhgoYtB532mBUXImOj+X/EMXVyF9a7oQ5tE+udx/6ALYNoMMdKTr7rH990dxhCSUmp1uYPne0tKw61JBwNf64QjHyJxDfX5mcPDm+NaDu/5dTnNRTjsJKvGC3MFhKihBFDBWnl+/J2cEEpniVbryI8JZwoeMIhelNiwd5Xgel9yQ4782hgo85o67O65KqH5PxSA7vh5RZQgODY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

mincore only interested in the existence of a page, which is a
changing state by nature, locking and making it stable is not needed.
And now neither mincore_page or mincore_swap requires PTL, this PTL
locking can be dropped.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/mincore.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 1ac53acac239..cc4460aba1f9 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -153,13 +153,13 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		goto out;
 	}
 
-	ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	ptep = pte_offset_map(pmd, addr);
 	if (!ptep) {
 		walk->action = ACTION_AGAIN;
 		return 0;
 	}
 	for (; addr != end; ptep += step, addr += step * PAGE_SIZE) {
-		pte_t pte = ptep_get(ptep);
+		pte_t pte = ptep_get_lockless(ptep);
 
 		step = 1;
 		/* We need to do cache lookup too for pte markers */
@@ -192,7 +192,7 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		}
 		vec += step;
 	}
-	pte_unmap_unlock(ptep - 1, ptl);
+	pte_unmap(ptep - 1);
 out:
 	walk->private += nr;
 	cond_resched();
-- 
2.50.1


