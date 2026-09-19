Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1CFC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 05:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD12E6B0088; Sat, 19 Sep 2026 01:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8C86B008A; Sat, 19 Sep 2026 01:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99546B0092; Sat, 19 Sep 2026 01:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88E0A6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:23:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D1981C178A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:23:51 +0000 (UTC)
X-FDA: 85229369862.15.E5026EB
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9181C140003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 05:23:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m8QyLR64;
	spf=pass (imf23.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789795429;
	b=c/P2SXX46SlXsBjMvyEaJ2bcrxBrnFRnehZ2FnJDjFalsTW9jjdrC2SIrnW3hztey0SAZ+
	2BH69lu/rawiXaAo0GPOZAjz5nb7gAAMfTaZObNMv1TEAtvrvx7zT5yCbXP2Ckth0wSUxA
	+nhFCk5QbmmdTqp08qD8m8/GEePawzI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m8QyLR64;
	spf=pass (imf23.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789795429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FitaPU7xxm51lVtdh8ABlftRiy+/s0hAsRKVPTqrv4=;
	b=dxwm6qvCEsj5hhqo66tRfreJCO2YuDiOPeRPO6a/rezDLyP6gLIbPiGMkwbRnHqUq8F4Y8
	J/PLK9zSjUAj6CAdRoT6i7U6+BIZpNGxxUnb2Imb+4uH8LIJLKXU9xdB8oyIbUrRRb3tvi
	M2iFKlOBm6HWikC+YUIG3ZsQ04RAjTw=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso9905175e9.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 22:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789795428; x=1790400228; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+FitaPU7xxm51lVtdh8ABlftRiy+/s0hAsRKVPTqrv4=;
        b=m8QyLR643frndHsV5ZgIqth1M9UoXNtjt1H9tVb6WwJuuSp6ZsEaC23vv7usJYErYU
         2aFdjsc13UK7bmVMtbBVsPII74UL5Am6Pnyw8NVk0EfcZgQQUkgS70zonpXBJ0XWYu2f
         HrSVBLSItDjQNXNR8uixRdzIsBiUmGoM4ymx97tYMcBZlJHi74NNk2VIxvutui5u9ub8
         5XC6ube47BM7K9Y8cUmgZOAOD/nTj+whf/Um+3K3JsqOGxLtpYVQjMCHeaR5awEGaLzq
         JMh565lbNAKyibDY9ElkdYgXQ+88YBSj/VR0res4FpwuqTGgL3sF79c2x84Qp9ziqnBu
         QvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789795428; x=1790400228;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+FitaPU7xxm51lVtdh8ABlftRiy+/s0hAsRKVPTqrv4=;
        b=1EnVeKJJAYSOdVEzEFujZn5qKUBRXTKAOzhkBNhH/iA/bkaNSFltDAGJZw1XyWbvLU
         nVs0TYijUQ6jbYqDIzCT2CoGvQ4BWq2gMm9vfBIyI3C8TjAx5eTpH6O+/K++ov7Y5zgY
         eBX1w7dsSmwKfGiAjqqmsXoQt+uxMi5RWPz4SG/hAXBIH+rH4M9dSOdqEDfaIaV3xzav
         yjQejNpjsHyfzkz7iSG9cHNnTojE+6SWtLzJ3HPX2oR8kLmMVAzQwJO1nqv2KrzLWWa+
         eurK1++cXPAzRQwfPDe8EBZ0H6zb+nPma3mZ4FTuFsHSjuOF9Gvy0Q79Mw8KFKz3ZdLv
         aNGg==
X-Forwarded-Encrypted: i=1; AKwUvBwGFsJ21u+EA8BqWZRGV+bJbIuCDK6GHDbwKH6rhj+ezBwLv4fw5IoAfYZ+se/EA3AOzeyFTqvbEw==@kvack.org
X-Gm-Message-State: AFuF++lEwxbxoyxC1YAAP60ZFDCekqnXW9o71nu+WKUrcNKZKY6wT8SG
	BIVtFp/3WFuZuh3OCvnujVOIolKlUq/5kjixTRgZiwQ+k1a4P0zIxZWS
X-Gm-Gg: AYBFou0YZlrFT4KlQZEmGSRF9w412L1+sPGYlqa0nArYjLvdeKZUJLZyAQHJnGzMfns
	bz/FgYHOJR1E8Wc3LxWCDybfAvKR9qnazeF1/0IWY0a63qNFDQDyyjpdsRzSnrMD70gJPXxJeSz
	069gkGc8c1fqX8PDJ2LSYjvbWYFEdns90HIEmRbjC5nNNXPeCFT2JHvlO65iaGiV5AKRfTERTKx
	y9MnomPV+oJ5PtXb9FWtiGx/5UsXfkDAQZH6Rt+bArL/AAel71yU88A2ir6HG8kEgTMKXXWiMlO
	yFkdX/Fnaylr63TlgJZGGX0Tj70xdongn+Oh8YQhjX6xx6qIH76xHhudaZlV/OpeixQpBjNFlfo
	xdaiI2sUBla79hMXr3dppw/pl2RkP4eX4tUN4+jdYz89AAmVpgTc7J0wctkIL7OAHyd5kjtXKS8
	mJwp2nY5f2CS5dBd/y7AlMyEp+Is5AyyhvPMkzvzQu/3FTll0AsLFLHJFp39niYkFDB/2ishTT+
	pYyvfpu/ZlLLLCD4Zla+xqvNIHuKgCSe1Mjl0qbwr0tApG4tbmMwUeY9tbG2py4cjQ7iJBsItrH
	ioXehO2a/BZl9uREEfUvYjILsbi3eUVUtbTOXooTrR1BBt8rKo9szHkADezUXIVB0AdxPiHAAde
	H4HGj7LuZ8kzQoRU=
X-Received: by 2002:a05:600c:8b61:b0:49e:69ff:c6b1 with SMTP id 5b1f17b1804b1-49fc5749edemr69948685e9.31.1789795427940;
        Fri, 18 Sep 2026 22:23:47 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-a017-2b01-05fe-203b-7cd2-a640.310.pool.telefonica.de. [2a02:3100:a017:2b01:5fe:203b:7cd2:a640])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc6ca43edsm109505565e9.0.2026.09.18.22.23.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 18 Sep 2026 22:23:47 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Russell King <linux@armlinux.org.uk>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steve Capper <steve.capper@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ARM: mm: LPAE: Change THP helpers to comply with generic MM semantics
Date: Sat, 19 Sep 2026 07:23:44 +0200
Message-Id: <20260919052344.23653-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260824055938.27594-1-kmehltretter@gmail.com>
References: <20260824055938.27594-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9181C140003
X-Stat-Signature: jgjnmkwobsasdpd3upqa9xjhneuf8mjq
X-HE-Tag: 1789795429-355664
X-HE-Meta: U2FsdGVkX18cPhNl3nbHvbOeOyj68VknCACCOXsKS7nSBb2Hv6U78RlcT/BSqWK0gqMxH+qaPNRcSl4AMVZq5bQPwIFKcsMase10sU92csbt8dNgtjOWIpATTpunm0xLzdGy5E5Q3V0f8tSzKfsKlPltr2+ezQzcmQu7lh8EOK3HUQ4k7SBxM7Qp1Z/j9xCEXDn61G2S8NhBfnj9dzufjYssARC6zLKcwVqPK3pQmiisJSmQaoWOxazgVWSHnuU7AAwfZrHicdrbu/zpBdvlnoLuHDe64yPHCPQNGFKD6Mf5TpcXqAPnfNSm3elxPYG0KNjVt7LH2n7zWVN3LyjjLc3zBBT91p8iy+3Hif3NGkuoQtc42+ejxE9aTWDzWZuaCx10ev3zDEUIWj1uI7hi5kvjglcW+e6H8PZGJlChbnWyx2TwcMZr+g3ZY203yZTYT5IeMTUcPsWKPgZcyxAohKzCX5JARl3r8lAnyFcjZ/KhclktP2gvnf6W/AGDs4vH7J/ytkMntWpkfMBqy5UDPgc6zZbZDBq+MRjMfSx6ontyybvYvt3dffvZvOdbN/4nqXgrfOvXrcOQ4CrrVV2fIH3hMvvjq5TpWh+b7oopB/1/MF9mULheRD/KL9bvjbkORK3E+wofirUF/mGqZlFxO3fLm+Bw1EfxsnBzGxibPXq1GrmP2shgw9hYIqs8mr+rKtWcz4CipEhqJAmoAtJ2L2XDiK5Un/ZMoJybrMDQfkf1ojfN0N6ckJ+v/+q1/Ruxl4vCTdYxlT+4QmRqwLYT/cxC+55HWDKtP9pLjsqpTxozDR4UWRYYntrcyQIFVYzaaaXqkEKrWpSq9BbrgYknDxqOQitkqBrBb4cXweZPUgDzgIMQJLoN4RlUI41FLmoY0xlj46zn8nnT1SZeTl92WUQCOFN2Ib5KjVHqxPwND0TxXcJcU4zVUfF8MoBluqIb6FCRKDmvtfS/jKCVsha
 TLvXI+UC
 u4/nkOrnHXvK2V9m9vOfoJf9gZtS6rqscjJTnmchFZkVNc1XdKpmLQiKQDrnaZXuo+D2+RMvCXrKVrzm2pHk1ZY+xfCgtGDVXaWUiYGLtsNVTdxV3wT0awm17aCHcDTzk/qMB1nOxH6Zxoo64oInmAZsxYQKV/6659jNDa92p+K4H0B/A2F53sfEcN1KSFYFd396sF8wf40deJBlHmvoc7dqGeQ+owyvG93sx9xrZr1OEvWB8WAemhE5prGt4m7NLyqcjMDqK1DmUuu04a0ImZhKhX3Q0CH68NVvD2i5aPoudP8lUzSSQvs7Lz1jRji4hJfCFZYIeB6e5qmpLh9KHkcyw9APwRsWrjMcD9eIuFeKUmnd0OH3eCMkyyvrUoIZwPnaAperpG6/qSvlOhbO2imIn/+sqxuSPu/YnjcEUG2N/AwXPB3gZ7YiG81/xyAzW9cNN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 07:59:38 +0200, I wrote:
> pmd_mkinvalid() clears L_PMD_SECT_VALID from a huge PMD. A PROT_NONE
> huge mapping also lacks that bit. On LPAE, pmd_present() therefore
> reports both entries as non-present even though they still describe a
> huge page.

Friendly ping on this patch.

Adding Anshuman Khandual, David Hildenbrand, Ryan Roberts and Andrew Morton
to Cc for review of the THP helper semantics.

Thanks,
Karl

