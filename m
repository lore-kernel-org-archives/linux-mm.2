Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BCACCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 19:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BFD8E00C5; Mon,  3 Nov 2025 14:04:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E498E0060; Mon,  3 Nov 2025 14:04:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57198E00C5; Mon,  3 Nov 2025 14:04:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 774458E0060
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:04:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 057B41402C7
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:46 +0000 (UTC)
X-FDA: 84070222614.29.F7590CF
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1485840016
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="U09j5U/z";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762196685; a=rsa-sha256;
	cv=none;
	b=KUbUHA6qEhhHPD/Vp9JyI0DimvRQ2EOliAfTAiMCdxzk35Qfsj4arqmJR8VXiSNAlu1knU
	KzuYBDYl+rESxVq+KM4tR832H79xswb0UCun5pZN/K2bJUyEMbtEEmP0I8DY3tce+3kmtb
	gRUX78kUjZ5VsxOFcOoBi2n8mRlBvh8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="U09j5U/z";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762196685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cMHLkj+gI0nwETQtcp9VFdw3HslxFYJiK9T9Rphw84Y=;
	b=8mbHPmg8ZgevhouWc3HpRe6O0tOJZOFHZ3s3vbG7ANyceQo2pzl26yYNGp/qgVA4R7r6Sp
	4CKXt7ga+QfsOv86T6yj13E4nz+y79SdoZDtUW/2FkNLxqyfY7vJoMa97Zznlbo3c+P8cN
	Mv6L6Nvm2rKHorO65CDqFVXOVr5ol+U=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3f0ae439b56so2477204f8f.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 11:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762196684; x=1762801484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cMHLkj+gI0nwETQtcp9VFdw3HslxFYJiK9T9Rphw84Y=;
        b=U09j5U/z1v0Zm8HTMxSqccmI70BhIK15oWWgv0zkB9QbWbaxV+Z2mmZQSaRT0pf1p0
         hLrB5LveJqc1WPqip88xjmGbHXx+iL+LIV1f0HPXadITxarFhvqkb5xfcr50nZVgefIf
         iBmQVeUnpOxoO0zfo+mvIpe/VLWvCCfqvrPMIB6gd2UuB6DlzCHs+WjK+qoWbKViscfz
         jWQ1HoYmP6G0vS+4FU2/Qb2U04IR8mKiDg7ak29b6KJnzsrqlxR71Ak9rcg+hm0niECZ
         kLVLLKYCRAD9wtKKFRh+3ZPPT67OkChdoK+zOxvuH5AfHGrxEVBSz0n339QDlaJPRvIy
         H1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762196684; x=1762801484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cMHLkj+gI0nwETQtcp9VFdw3HslxFYJiK9T9Rphw84Y=;
        b=fa6MeV5eQ66TPX7NeJUIxruWgG7BJga90uBFP+QrMCsAJ6kj25WIHK89QYdyXxCSxB
         bGLGolcIHFPlhNBwdq6VFintMDlR4+0/24Av8pvg36baBxeYtiXSPAaJd6sTSD/NDT5V
         zA4JLTJ8Zziu/e0UX+yge5rtPmB3i5Ca5JX0QojNNAFsF9liygG4Wcymz5XykqIHO2Pp
         MKzgkaUoy27jJ2fomq+O5p2XwseIE/R5oBp8qWnIybxsj1PTYvuKY1Emd4uJkO/JF6PK
         qGIm8dlh7sFNJIwBRwKa8I/B+bEOomY4HYG1v4YX9BSLytdiFz09h+W18AMKh0luzFMu
         Z19w==
X-Forwarded-Encrypted: i=1; AJvYcCVIXP8o7HAk0A6gjKeAFHO1kG3tZgVRTaPtZJT4XuRWmlRJnMcLNJftmBhyLqz0zZ2Yv/WdbCWoBw==@kvack.org
X-Gm-Message-State: AOJu0Yx/+UORUPJcEgSkx+5AoKJbxUJUrwEkrmJlmtRbu/96Voi9yLg7
	Z/dEqKVeOxiikk9aCCUrSW0G4OHMb4ugIY4SoReJB5VUsILlR+QbTJdV
X-Gm-Gg: ASbGnct+U7505tckCk3dpfGi2uZTtDZ/sTEUdrZ/myLETwSWWGnzYLjc43BiZ6kV7o9
	tBDhqEmkHI3unnIYC5tSZsRackSrQzUTFu4NyFi1wIvBBQgwf3NLi+4NWk+INgnHsb8s1fB5fKM
	Zf5j5WeXgZuzubRazV6GP1dJgBiihIiKIgVtz9Twqvvj5MdgwnXx54xl8q1OKkLJG29f61LHTgU
	cUKiZTI4QrHrojVJgBY6NX/JMUiQHsPaml0DK6qS10h8NE7h4n/XijCDYUv/b6qu5B7S5CpqKvG
	PGWxFcV9nuTMuJhX9d4qxzUMBdB4w2EnxnBcFD6qZeGfeZ9gkyN5FPCH6DQB5uY6PPFIxkqUslw
	2klgZAvRaLTIkbnB1eLEq6I37s0ufbGCICadGv74T/jm+wXfbiDgEwlhe2xm9skjOzq9bE2uOr1
	Lb7WuVKLbcskZQ7DiRC+o0VzjwlWOb/VWbHmP91e1D40u9/qeshHkUZxBjJ1GK4g==
X-Google-Smtp-Source: AGHT+IFz0pIUFvJwFuBYW+x/ZsgwBHHSe03OIKbGEouVkS7xyooy0cXJf8nLP1dMjToJSUJvDFolaQ==
X-Received: by 2002:a05:6000:2088:b0:425:769e:515a with SMTP id ffacd0b85a97d-429bd6a795bmr12203265f8f.42.1762196683544;
        Mon, 03 Nov 2025 11:04:43 -0800 (PST)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429dc192ac4sm327407f8f.17.2025.11.03.11.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 11:04:42 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Mon,  3 Nov 2025 11:04:28 -0800
Message-ID: <20251103190429.104747-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251103190429.104747-1-vishal.moola@gmail.com>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1485840016
X-Stat-Signature: ugqw8ahu7fp1deqe6guw9ch63hu1wm9d
X-Rspam-User: 
X-HE-Tag: 1762196684-647426
X-HE-Meta: U2FsdGVkX193m+tsK2/rDQf0Xq7kNvKZU3UkgwZnXNJZLKuVUTcy0j/J2bF3YHshHaNijtTT/HLOTrNTOgDKEnnvJnHhvH7wMiVos45dcWgu5jhmN+Dad+mRromkylwn0SHqgM3+tQhm3GpvpqVN2dGfzMOSOpeVOBJJaaEQWPJ+V4hTaWEm1LjjdLNnQ1EK7xKgy5AHHBD+wLYf+IAaBSHruQtCZzvNsaLyV/838YEmmldxMIYAzH8E7juQnjud9q+SaOiiJKFM7Ax/GGGXfUpLTouqwcO5p0BeNjP5NZz0ycg8O9eXUITSW+gkrbI5QOrfZP4aon72OMI88zDR7vJyn3YNQ7ePq9t1vsbk8/AzBWauFc+6TCw7oFa8I33F2QPW9132svPNVQ5aph22qjkHJcWnF+rCBMpNFeiU+ulO58q8HTLMxu13p0hMhiTCbtOiy/wio7O/HGBjqs22JUXZXjuHmwzVUgvmasyyw/2WgM1MSEBYysGg2idcA2FUxGLEfWTnBuYywGA3p5z8yAnABvcNAR9ffgRB7isB6CuR6SPRKQhSH68Re9Au4vmVRWiohkNFpdRceCqdy2yRAD1KnLvw98eqQkXbOVuHxSe+ibEzgEfLhgFO9Ens6ES/Hv1qBrYd+f7hH3ntwnX5Bl6ri0JnCdxiatVuYtig9Z+nov2T6QGaA3DwPyGdJ4BNelz/H2mtuEJ6BbVuN80E6MOR1pND+tvTFk+/hhbhKndVaka6sQw/qdrX/cEbEbIFB5thZlUdm2K9UofxWmMeii6XEu5SCG1bJ8+FiqLd9QarA2R/rysnWBhDQxNyVV89TSwv6DyIyiSf3LxrczCylm0Kh8ibcS2kwDveloe5sL64w0+Py9FUK6JuGzB1Fv7tWRklCAi8hEs7aA2nLccgzckBALMX5ghWVqOPdHk9QvlsUHsRTrNL7g3H3xZHNrNXpBxyX2fRvh22+MHTE/z
 t0UxoRRq
 hS58fY4Q5udMX6AxkomBJgfnkUUFgUsJej7AEyguyU28v7REXjayDj+k9bt6Zwom+3ot0uEzgBZNilqIBzCQ+gZHZ6+qQaowHKnmledUO+w0Hdm4+m2D10SZYiM2gSdb0toDQG1Kz61tnhGfCgW8HQ8MoK6j8YHKdJ6NRR2S0YPBvAe5vOO0OtJbM6Btydo/E44uyAAa+7LYosoIZ1X5g4op9KxZy8BnUHSoHhQNdUdDmKZRVzsqW8+Oy/HnUpz4mRLXEq6G0EaDVt+576cijv9sokTvGgqt2pJ+OGqtcR0f0R+t/z8XMc89XaoMw5jpLaTHHVWM5mfz1NK+8n81xtlgHZbRqe1X1FKufIA5k9CyE43h63YguGmYFDXcjUfXK22I7BBz6OHp3H72MD0DLd2si8IJGan1reXQ8HEecSFKNCjTnOTGd+0jSDBWBFX/fZKGnjrEh+hHlA9DRFMxAAFyOOR4QwZkXz1SadC/Po0Jw7s49X4Oox2WkThP43hx7bjRt2Hr86AEpW/d4paP4ylHDEntE+5SDGAFrAr8NyTXka+4hb9gqWRVsDANzenYJm4wDWvJKcDynjw4x9nVPWT/A1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 38d94c0c8153..ced77fc65ce3 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3634,10 +3634,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
-	gfp_t large_gfp = (gfp &
-		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
-		| __GFP_NOWARN;
 	unsigned int large_order = ilog2(nr_remaining);
+	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 
 	large_order = min(max_attempt_order, large_order);
 
-- 
2.51.1


