Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3617CCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C828E009B; Wed, 15 Oct 2025 21:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3F28E0008; Wed, 15 Oct 2025 21:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 609698E009B; Wed, 15 Oct 2025 21:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 465778E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:26:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCF6C1DBE19
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:26:08 +0000 (UTC)
X-FDA: 84002236416.22.461B3E6
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id EDA0F2000F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:26:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SWrQZFWW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760577967; a=rsa-sha256;
	cv=none;
	b=0hYOOewQlNRxWdQU2/lKLdDQi6K2vS3JRpxJ45XmxoB3Typv17RxqdavnB88/x6qsIE6FF
	5eK+OLKCB45b1uw6owGXIwp+ofdgj+Ur3Up+nZmwo4t6mzWRq4vQ6OsoTBTcCy/N2jvjUN
	gkQJteVjkWnQCN0xjxVEp8uQt2W1GxM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SWrQZFWW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760577967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5Wai3uDmRu8Qb+kIQ6EkwTWyP/JbSBurTcZ/Owvqzk=;
	b=OmyeYKzFqCR9cIRN4jah8iXFz3bUdn2uwqNK7v7AKT1FEOqpcuagg/XKn+T7aWswISxfQS
	wP4IPgXaRbh6lymDIreNzrIqF6HLRv51KfJC4sPYoAMoV6zHx59pgxpXroNStOx1Ds/TuP
	/3xGWqrNw2oa1BRYlcjy2QFv3x3cEWY=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-330b4739538so186496a91.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760577966; x=1761182766; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5Wai3uDmRu8Qb+kIQ6EkwTWyP/JbSBurTcZ/Owvqzk=;
        b=SWrQZFWWhul9BurWjWULT9/hJ1iemK9JJQcL+9kBNoaFMG6oSrsM1VtcuLW2gt5hx+
         W7ziu4xF8ZPvr84vrVTQOy85Z+4EtIb3CV9NSctEmXEeyjFrFCHJK6zVG6zvsDlkBGB1
         PTlTAE5YaniSN2c9V6YzUNfPKX+PXH2SUedI5iHGMlPjJiWc7ce8/8abGXK0IbiDitdh
         LxNMbJAfzL+J+BAxAuLluC94XT28xxhcASKbaxWBH6fWPJLAoQGPjvdl/mlx9SghHgFK
         9TVXtGrItE9V/MsrXK/vRC5it+H1zPcuk2QSSgP+xQe/UBPKqa/kre5WGpOlpTiJMoxk
         DCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760577966; x=1761182766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5Wai3uDmRu8Qb+kIQ6EkwTWyP/JbSBurTcZ/Owvqzk=;
        b=uLtRcu8rvMwL1Aqji2KzsXTOP/bIE5t2K0k6+woM+mppgkyJO0OIOfWNyc7DN/HbS1
         FSPIgPqGlg2ZdNwuwDFT1u4TIa4su5F1kZyqXFD59jlgT7D4xrnjyhBRTv2UfZfIhH3W
         X2b4N70wP/9wT7YnraEfOri0txjIroastH9cfayWWoBqg//4JBro57vrOlDaode43dbU
         E34BEKiJn9WHbANqThW0XA8M440uICdLwYD8Kr0cMis+g0wMP8RxP8G8V/hnHodhTX7r
         9oPGGR3QshWCZdyg+v71OWq9fp/zj4qKjFpIo/XUbtBNlVKAE/fRG/A3p3H8HoabBy65
         RtmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl+PkOPE+kF2+x6rMzdno4d1vCxf8wTsHR6SDjPRLo4FD2Y/TXlsamuDRoCuSsCP+jR75FPs9Law==@kvack.org
X-Gm-Message-State: AOJu0Yw+RET0DKC7IrAYDUWfPcOzYqGcdUnhqfhHuMFj67PSsCDVVuP2
	jxVq1W87KbvJbNJTT+FA3C2ihm7sLumTvMg0s9zGUyIlIh/648/4ioYAG1xHGSmfdYc=
X-Gm-Gg: ASbGncu65Bv018ap4WtNnAnhurHVXzyhXd5/tKil4pG5e6zphJcKwpz/CJuCchywi7y
	zoIL7zP7uA2lm6Rfsto+evrN7RLAmsEVQBaiWpNfobtqSE+rm3GhvzMA+Z8f7m40jZd3BAuLtgZ
	mW46JomZw5HWgwxt2GmUbE5zm+fenxOG4ZXnL0i+Vi0y5lzo/A11qG9qwfo7GGUrIb75ccig6Y8
	XMF16QnNT8hHMa7cWfGbuP9IY+scDZEKqnPMhS6hKW6YYVYtIKgiC9pEuoXy98yFjGBIoFhcoK3
	PAqSmklq8+SvVOGM9aRPY/pnFcZ2turj1opQ94FtiHB4LGEgs2mLhapK0Yn9HksYyTg9BgSeZIj
	71fs1g3zf9vnb0rpGgENaGbwOs1h/fOIlj20VIjHkJRCM1LX+THR+3TZ3dxmXUzX+Klvsm68D6S
	9A3DMsJYvF2qP0UWx9qd+c7oIhd3BcReIPlmQNqZfYkhvgHzr9RuYKm2tJlTEJ
X-Google-Smtp-Source: AGHT+IEA1pKztPuIntj9W4cy0FVhxFwVkPZFK04BxysTOWAw61kJ6NsyloW680ni7qb75ti6ptk6Pw==
X-Received: by 2002:a17:90b:4d08:b0:330:793a:4240 with SMTP id 98e67ed59e1d1-33b513ced41mr39718540a91.31.1760577965611;
        Wed, 15 Oct 2025 18:26:05 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:1896:1396:ec5e:cc1f:ebb8:de8e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b9e5a0e8esm1426978a91.19.2025.10.15.18.26.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 18:26:05 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify __split_unmapped_folio() logic
Date: Thu, 16 Oct 2025 09:25:47 +0800
Message-ID: <20251016012547.39871-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016004613.514-3-richard.weiyang@gmail.com>
References: <20251016004613.514-3-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u3pda1z3fkp394dosfeqk37f8if9hser
X-Rspamd-Queue-Id: EDA0F2000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760577966-165704
X-HE-Meta: U2FsdGVkX1+KcXRA56WrgkHKJ11CJZp0+A3/qh6SI2erbCWa8cMDnlpdhcQqgf16yLbxKnJJVlLPuknQQaCPrq2dPZS2PUiXMJLU0aO2rTc/dhCSe2AJZbE1FLLlRI9vj4HBRt0mcHw+eR1Gcj3QLesOte1OwTDNNjKG1iMdF8qOQM4AjzmvVsE27eL0+XcsecLSqwzwLukuHGRYDttKFlc3fAjn+ylixgIcFonoTvdQgoDJ3HqlCeGSE9+0snbImutNg4q0NP6tmIPcwwjyWEmhGOtAFXv/3IT6NkYR3fqvkEB6lkV5+WNDSuzhk0u9n94+OQq2CnRz/Gm2QAuQFZgvnqptL8z0jRqt/UwKrI/a232s3NffL8mr6H3rEw0RAnrQQs7onJdYyBFhN0Ywn4cdnHEpx3651DwF1eSOK0Y5KLUCWI794tUeXbKP73eH9+QDuM0Ai7y85PUKTAFt6CQA8miKHvc0SgosvJFAledVNJFzUJmZl0+dGbBeLdEIX1J1PoThcyJUQ6j4wDcRmeg1phBlZQSv4u56ny1K1/wgoz2LRiOvoq6AMD96STDKfAvnFqWJmKFRdahIX2c4Isr6HMtieYEprAptx8BZSxdIkjS1cQvQag93KGPY8zWG5dp4qllUGxbSLidDbCVFxRqKYiFj6wyMvTJ3uVD3pSUZCFCPemuOMX/DdkN9VBth3KA123CIQ38WKaOekp4dTKYpe5fDtaYDZcssLMC8RU3AnEZZgfSEd4cU9ez2TnONPZ7nSvcDRwxwvnbXVwVFxUi5UkHHq0S0MAfnIvZx2tcHcE4CVeTt5fgTgwaqQSciRoq0e1pnP00q0wTuLYxLIYCuch9/JMj8ulKpUzYvbUM1CL0AnImvkMwQ6L8mSItSGmWSpa8eVzTRQ0mtBw7GIeqISaCcaAf8rDOB4g+g6YznQJOxTSX7rFGuVB/DxbC+vi/UqJ15iWgVUprSvQN
 VgiZr2YE
 Z/h7F3OII3+wdpHfFbHxzZKOw09R+geQH+a2O45BKfDpBdsyralfSUb4s0ha3G8zZHVAGfjBQm+xCVhSBDIxY3mKF8WmhMALmI2Rh5PygDmQ71BEwIWktNyAuwgqa3LjTbIfTZGOgxVeqKToS+j6N29z9gy7yMIx5xLUNtzmLNXTPRUjLqzTVLfIgJIxZYeYQYf4jS31jU89VRNjk5q7ZZbndAW/tAH5lherYgEjnDgHvVTP2rL+qD0bUGQTSFgGIyEWx21XaG3qV11bHzYv2/U2dqIXho2DBJ+6vT6K5tZE0yg9nsvuiGfZv7O1rbMBkMmRI2vSWclkW+AGECMR+UyYAMA65jGwf5/9/3X2a3w0/hrTwZR5BUrgsF90wBHTXnw7DsMNcn1WtZHwu7cXej2GvLQ/g+al6SBS55IhQT/LP+Xd+xevLbhfkrkKPzjlCPrwf+aYqXa4TvTckgac8NjrcbKvJIwTzKOvYmnfQaRpHNySjps+hT4H5lFEGw9DdbplMDHz3QDBnd0PjNHJQNounzXbnhleNbgNm301rL9N7hAozk+3v8DWI287Cpd2LmKHCBjbhnL2zOPbrAcF04X7FGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Existing __split_unmapped_folio() code splits the given folio and update
> stats, but it is complicated to understand.

> After simplification, __split_unmapped_folio() directly calculate and
> update the folio statistics upon a successful split:

> * All resulting folios are @split_order.

> * The number of new folios are calculated directly from @old_order
  and @split_order.

> * The folio for the next split is identified as the one containing
  @split_at.

> * An xas_try_split() error is returned directly without worrying
  about stats updates.

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

The simplification looks great and makes the logic much easier to follow.
The new comment you added is also very helpful for understanding the
difference between the two split modes.

LGTM.

Reviewed-by: wang lian <lianux.mm@gmail.com>

> +		 * For uniform split, we have finished the job.
> +		 * For non-uniform split, we assign folio to the one the one
> +		 * containing @split_at and assign @old_order to @split_order.

--
Best Regards,
wang lian

