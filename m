Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E963CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64FA8E00FF; Tue, 26 Aug 2025 15:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6418E00FB; Tue, 26 Aug 2025 15:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D048F8E00FF; Tue, 26 Aug 2025 15:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BED9E8E00FB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:34:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 827231185F7
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:04 +0000 (UTC)
X-FDA: 83819909208.14.2C36DCC
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B4688000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dIGQotK+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236842; a=rsa-sha256;
	cv=none;
	b=gu3R5FjhYNmKx5bR/pR9wu8AkESdeuX4B7SbOiUBYe8T0BRIiCwR4s1akpKElR6SIbXd+f
	YV/qTY8Payjoa1IJxMeSIayU+W/9FpvYh54jYgZmqIl6IHbQSiG6/2lhvvsmy96+uhIIh/
	lxF87Y9myQ+1vzPCF0k2gFxwpTcLGDY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dIGQotK+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhymPbMl1maujeQhGMIXlLhMPhVkZ1BpuEab9k3C4eo=;
	b=X2QR8Kw+6NFXKhFxSf3vKUrz1eLeUz6duLOq2mFWr108qpdR1ZZ0v8MhkMf+kueN37IGCL
	Yv3dO2fIi9Lus6lOgb6CWq0mjHgaL56u7Y/ErV+Dj2/prpatee7CrFhZLjiOkA6WCulbnL
	860+wZ1J+Y1uCDOXHQki19T8rltqLlo=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-771f90a45easo1148469b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756236841; x=1756841641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhymPbMl1maujeQhGMIXlLhMPhVkZ1BpuEab9k3C4eo=;
        b=dIGQotK+O4rj+ENNqu9H26rq8AeQ2p2IzTvBCs1rld7uS98icdheTnavYFE3XoffFL
         w/0eYAnbm7iqDRE6sW5dDy8JfFJoCVba8LE5HOwbKJ721LIGOw8gQSmUr7Z2c+GNGZva
         VYSVYJHouZTS2VtqVei22qK6Fi3lvnGwKuJuLk9SQyP+FBKOPX78KKhdSbq0wf1Lk4Pw
         aGnRSXuebcCO/gXKhIHIwZ4LVJmoWe5P82fM4rZkR+9QmP1sVJ22h1+sn1DOzFgdpyBA
         HMbxxo+xs6qm0jCC/YWDs6o5bJDfaGnGmYplLf1YCcoCOLFkO7L3QyoJVOkeeCkCfsfS
         h8Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236841; x=1756841641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QhymPbMl1maujeQhGMIXlLhMPhVkZ1BpuEab9k3C4eo=;
        b=TN3fGKu2keclzfTzYsXRrKATrjDx9iuYO4RyB36bxR1JDVyhA90h5g0F06NToRxC5W
         4W9l+tN/mPzfHgeFb/rjLrDDqn+3QX9IB/nLI3tRdBuOg/+Jb3vdl6paxV5f67gUjkhO
         nyDlllSwUnxIDA5wuzPn9/lT2gE2SzgXj6TUajg0i9WueccscLfw7nYLK1u60HsQAZAD
         wwGk5YCG27toq+DLZwKjIQayeKCALGIaXTOtQ1mD8NqrGTCOhUi5SXDNNsvG4otqJv06
         q4iSXbngzMHbybqLiB9y/jop0ihKereDw0aYg+3PwCJCzDw/y0i5gUN6rNKvtlF5lYE+
         CorA==
X-Gm-Message-State: AOJu0YzklWUa6TvnedaSEm32qx26Jf56fMNjapl/X+9o7T0oPvp4PlGV
	DzZVtLC8wK9QAgQvexSCewb+kqZtQGnj52Ch6NizjGbvtzjhZo64hpX2x+sA/w==
X-Gm-Gg: ASbGnctXzKRNOrmwgcJhXK4jAg5qqmt9fTRZvGAYrsy+W15dXPqpE/xb2BcLqvTNGEQ
	i05aANClNksTQsU1eKcv1kj1aKofHupS5Rihuxnd3K293J3wi278X8rrivdJN2G4pDgVbIAGO4C
	8PPd3R8il26EVH/rzdT7rT3//3x9iz4fbnBCCFOgBZY1JvC80/ekhUQJMv4C3vY7FWYipG47DnH
	UmhXqe45BDI7p6x0m8FV6M/q5D/B0/WYQLm2mOO7d3krRuVrWwiJX2uBa0adDzNFMMxNS1M5Bz/
	rb0n/LV/J7xtu2Z9dWxiWdT6CEmWOdbtWB/IK1hbZtolF2FwtWJnenRN/kjB31m4G8B+V5YaqrH
	lmFCg902VWEVK87pXRr8ANYtLM0byrrTKkLM9Lsc1xs7/b3X97UcogA==
X-Google-Smtp-Source: AGHT+IFCoX76El2Mf5sfrILAjK6lmue1KJd0eRu5drBUMEuKmWziund+YR4+bkdXsg+VCXD6lKKhgw==
X-Received: by 2002:a05:6a00:1a89:b0:770:5683:cc56 with SMTP id d2e1a72fcca58-7705683cd6amr10201780b3a.26.1756236841011;
        Tue, 26 Aug 2025 12:34:01 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7705647e03esm8054053b3a.59.2025.08.26.12.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:34:00 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 5/7] powerpc: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 12:32:56 -0700
Message-ID: <20250826193258.902608-6-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826193258.902608-1-vishal.moola@gmail.com>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B4688000D
X-Stat-Signature: 8w71jnuoert4o8tnk1yobeerajm8iqyh
X-HE-Tag: 1756236842-926107
X-HE-Meta: U2FsdGVkX1+T1oO/8+JPRY0A8phZg8vqTAFWVX0Q88fK7zrwebpv3sOtcxcOcqvqIIB2q8HVFcE5DV7/DF1qH+oTV9D8qjLYrNhT1inwxbd5ZvB030ID8FvPqCRdxKSXnc7V7oAJcpr5ePN//PRJNVpKiqUZGIURjs+ObWor/Z7ylv8OMq0ghBRrWHCZIfmkzfSTgFftlyD2YNtTFHpDDw6Ns15amm98SQ1dV0Y5sMBtsLioan+BmZe80QnGB+KDaTzB5QBPoaPRy7TI3w6Brmb+EWDMula6a2ekfm8/oxtnlbGh1OsxpqHsjvTK9eu98EDu0SCIZq15z9nCH6djpZbRMgpxoSrvCB3Px/dtKRAU676nhiKcYMyN1xIFuk7YQRoAeBVVm8UDur+hOAVlMTP0JWe33JPGSYU5wJp4J3X548TFT5w/VCLv5yL06HYA4Y9bBuZMxWYeFFcZU7QH9C4WYSU/ELdPobnxlKbTm/UDzbk+j0Xq1hUWjQH8ubGjBrFMXfZ5ZTbW7Z6gTj1FzUjz05Q0pfR0UIOUW4X8yp3CenkmQsrTwWVJQNS1n/GAORgkAkN8rsTLPePwQeOCpOHKmVnOPGar4YJMwkJtGA16XMsC+Jgw95zwYY6AGm0fNVtzekua3V8K7+D6xXcyO7fdf5rR/k/DHRyLksjGHFJ5EBQpohBY6kAcIaZSqXhrXIkMc4LJ5zPjghX2ePsdvgEV9ttfAmgzixsPoIJO+VcQgOw1IkVcxBNaAywlFu6uvFSTW0l+m/7LHZA1a9vJZ+o0/nDUiiqv807jJk/cxzbn5O/vwRNViViYcL5nBN1T6GWCyxYiZ29QGu0dimEatU2or6DKYR/+wS2geoGRaEbYiXB4KkxT0PjHiFp+R9AyKMQ0wV07qWKGY8k2rCj5UukIbgWZfepPdj9JvxZsXrVc8h/C4LI/B1Hj1FuKvV0Hz8fGgB7fck+VKz2hYUQ
 +HTjy0CG
 9qlRNse2oVpLqsf7cz/uYls44phmeVoOkhLzejhayHoDRQTXJHVlyBuVOrDvGYitp724cgMebwGQl2PqYJwzgu0hbWP9nVzfaPJ5utBQLDbmVvsA0e+Xl4MjwNGdIc/IYXtUC9icVm+uSkkgW3W6FEGgTk6TIsygDZBLbWCWd2/7OT8qXedKA4b3spkaZpRWM7RO+K5oOWbCtpRmnqPsxL7EmD7SiGKvr+ZcTdEhluDEII4R0mMMSQv1O2C9v4+CeNSAQ9DFO2I009iau4ksL7rC6MbyjkhVUIqG/NhQ+0a3LN5q2LIu6dXmjCr2+wretCago/1BrW3LXz0ZkKVy7kSA3oGe6XxpPowDcTftDwAFkI+JLSFCdhMsITCnH5gImJKT4PXpcxBzJ6YrSQRAKomZamLm7felpIcqrL7ERK+j41bXQcBh0aOCJdQBopxBG0XMXX5l2OPcCY/88Dx/n6VSIwHwwz8S7JUjO1b7/KrAt5u0txGkBjQct/Tvk3mgqhGugT+rxMU8906gGG5/0rOIFyN9e2NKoJqWmTe0Csl75lEhQOIfjtH2BPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index be523e5fe9c5..73977dbabcf2 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -780,7 +780,7 @@ static void __meminit free_vmemmap_pages(struct page *page,
 		while (nr_pages--)
 			free_reserved_page(page++);
 	} else
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 }
 
 static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,
-- 
2.51.0


