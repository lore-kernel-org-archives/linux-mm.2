Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 186E2CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6924D6B02F1; Tue, 26 Aug 2025 16:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBF86B02F3; Tue, 26 Aug 2025 16:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 509106B02F4; Tue, 26 Aug 2025 16:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 355106B02F1
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD9C6586F5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:35 +0000 (UTC)
X-FDA: 83820117150.28.F9E822C
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 183FC1C0002
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SOLtwP0q;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756241794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
	b=3dmGxLXnFeZ4vAqxBVvgEeFZD3zh5Qb6Fl2Oebe9c5Dku+lZhxtlg8gFsC9716D0vwCs0C
	YwuUk+jvZ1WZUxjScfTgH85b53e+UMXKCNzfapTJ9kAQ1rWz80uPew4XnkB8MM3jxfPz+4
	Je1DHzpoUSPtRoLvcxw1smumkUy28yg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SOLtwP0q;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756241794; a=rsa-sha256;
	cv=none;
	b=DppBh/IL6FFO1+Jkw1++SbqULHTbGDmXiEkl/kVeJN2xUfbZbvsfz0Mks9SRuCh7Qa5YHu
	LcXbH2dUoNvKsV5O+r55vUYOY+RDWcNndGtW2MdoLm6reMYhXQZpUpRsUip4wpEZbC31tB
	YeLHF1qsFI61+ZHJ6LNhWQcjS63AOhA=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-771ed4a8124so2247449b3a.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756241792; x=1756846592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
        b=SOLtwP0qyBKheYrwz+oBQMLMDui2Jk+E7U8gA3KW3pEF64KS+xgLXZNqmCGjNggYCH
         LKZC+Z+DuxbUOLUXS07PGbm8PtieCSJvLdDBcCWwiB/W+pCADu4i1wYV7VSUN+ES9NKd
         2xHdwbG4NK4Fr1rUUzlYYQu9kOlFhXmkf7NOr+aW3FBYsECT9/jOZZjs7wLdjGCegGTH
         2SSd9xRatN4T5eJNYtnKUgbYtO+decdGgqKbsVef//uW05+FrZ9YuepwCSacq/ecu3QV
         tfFZY5ULtZ1TJJ2SmfLSH3+vgdOuE8AGqddxaNoiQZmwbY/Pz4wAKMXemvnrPxaLuM66
         jntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241792; x=1756846592;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
        b=f+Q4GV203rtio6CbBFmXLK0NsdSKcJA7Ks6f0Vx3hE03OY/IOjQlpYYu082J/2Mmgt
         DcKrM7dSNhAvCBPmr9yljK/XkNmXAmcwzpvBooVQh+vXTt7xJRWlU5VTPeLQ+HRWcOOE
         3C77unS9GspxRcC7fuYKAH3/EgViFgww53ajJ0mmfT+br5jrDWlRlyZTqeaJubXSd5dd
         0x4EFlHq+eHvQ19haXmrwKtyzqLE5tNgwSIhyhC3s8rXlSoDhfe68Wu2wjtf51rSUw/V
         OKii88JBUVBbgBS/GPEhsOhCW7kDKV9enxDr//Sk5gVPk8JKqXCDUBNBKaVsEqhaDxmH
         JwSQ==
X-Gm-Message-State: AOJu0YwC3HpIGzp2heLFZbjDh6RrvVRFCIG+RDuMhq9+WkbOtDCYqU5t
	HzKdz2EcjKE+EGLo//2hFhvNG2a/57jSGhseiyywE6hArFSN4lxVnUKTfeyVDw==
X-Gm-Gg: ASbGncvXXloLODlapRklg5UDm7KvDfKTd/9KxxENwAW2oyciDJEORpEaNxhP0MZXdmC
	tq8w28tH/Zu9qA6Sj8hP2Nw+W7ybvYFA1IJTLr80zJVIzcN2PTAbNdzvcPbX0+qK8BQC4hqNeEK
	lBrEomrpdbDS4+3ZfgvKANsJi6UI3VDurLIx6CvILVJn0EU8dkYebBUowq6cN99+r4yU2VVGv87
	Q4rxMvhJAKw/tLlZmFwLv4Lib8foy3PrFonL34bbWQGJYE2w+WC/1GpA9htnHc7E5liPhrM49Vs
	QgRXC/BMFph+YqJ3GFf/eC6Mge5Y3FBaZvbVeXuWZ2TFVsn+2m85HJg0qw1DpS9dRlbJ7PY7Omn
	DM+1UrOZPxg+B2/lRQ+7wD+206GCRwj223S8vYOqxqtvXCHUVTYjR6g==
X-Google-Smtp-Source: AGHT+IE/cTRK/9DLrD6W7x7VSwKVtmRq+MEUMw7J+ZbQGu720fz9Ao2X05nVX2flS6X87Ne4tC/Vag==
X-Received: by 2002:a05:6a00:10d2:b0:76e:386d:94c5 with SMTP id d2e1a72fcca58-7702f9df076mr17387498b3a.5.1756241792456;
        Tue, 26 Aug 2025 13:56:32 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-771e814cbccsm5817935b3a.35.2025.08.26.13.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:56:32 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v2 4/7] riscv: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 13:56:14 -0700
Message-ID: <20250826205617.1032945-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826205617.1032945-1-vishal.moola@gmail.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rp7ki595cr6kewp93szgns7qb4jhpnin
X-Rspam-User: 
X-Rspamd-Queue-Id: 183FC1C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756241793-788406
X-HE-Meta: U2FsdGVkX19X5dYsHTzXZD9DK3l5PCBQ2potf1Di5C6GAs2nraMT5VqLO4FEFablM1acB6zyOaYCtlBVhPIbBVn+jBnNtzbDe0G66VBbTVinDvldOq7V050mPQ+AZsV0Yq66evZihfBZRsl+9OUCospynHpe0vVrSORvMGatdE/oybw2Vyff2FDG+daixEUaBFiPTDuQtWtmbcEmG1IPLQvXgSvJYxKwfHrWzjpc238gZ8kI6iKLkbcT1QFgiTvyXT27urQlU6StfnIKzU9o0lwQ2NVX01dsDPbb7UCQQqmMZ1PsAqmeTeBbvID5LA9287mKdOOXMbpfbFO3W4Smcu74IQm0cjyACrnlX1RDj+Q079+hxD3aob7lYBfnEtUOh24qAxJ7Wi01YZdDMAxBS4zRvqzotDoqokF8dgJgb2J9M/SjBC0XCC2JqvBeiyt+SP8jUsAaUiwNHf8ukaA2gUUzWBK97/s0ZxXdLbln5vn4DMEGeZdu4nwPxUSIPXHomKCEOwsRsa1etDLfbmzWzBTmAkBaSDjAEOoSmf/+Lg27ZYswK8aqikXgj5GbfddjMyVAg/vPUJFCEt8jMEX54s98AFE8oIrzirDBZUf3+Y5hXD3nFuqwz8/1hgRUQqiq8JxN9/+gNJoMlP1WUdqj6S7QzcQMrc/zGOsg6piXg6smXbmBnd9zJTMs1uOLxZ0Couj6zefZLmGywNG8R2/vvmw3CasSVQGQpnyHzjk/bzCRGAF1ys5b/oyjG82cwMTOJS6J9X0lM/mPanHZJI6XHCZ98v23Qp7pc7l0Txjc8hdG/mWyX4WU1rIALgdglRRjQyRFfb7EIZo1liH1YwYpOS1iXV45A3rN9wC97EQYmAaJ8LT5OXlavHoz+PCNLHuG1jlQonVUAJQg5cbriY9p9mLiDj0VZWfRDhULijCPEYx7pDr/hBrXhiVj+HwRR5wG+IsxcVrCrJcmq72kTuE
 XvnroAG2
 6QNETOxP8GuuQbEqNMTfHpSMsVPc+yrYN8ICC5rYyv8fsMckAXzq8YUG49PGp5Q/JnWhBey/kbYGU+aK542WZkm7mDaQBEt+rlnizxcxgpRAKA6PB+DGJCm21xPfHwXeyb3t0IW608kYgVXyyLC0Nj2F5LASsPjH/vf6k9K7YHjohpPzk5+73cuBlv6I9ArMVBKzcD03eeUMZw1M8yC5AWECsV7rcYv3xQdcvxq76QUqfVd63CA7ByMxxpR/AevCixEAHW9HCvhs1gU/rc0sDnRmH6yegAzVZ5rfOpu56ROAoXJvozYzrBmnYge/fZhwuJt+ziLP5o/9HA4Dqo8S//kNT5OxLjTKUyc+x8CamfvZoNorIGBOVlfUTKavnkhYuQuUXRX4TG/4aoL9Ov75Ug4Ru8MO3qjvrxx+4O1BMg6Q7pzeQ3xJRWciPO2VRw+GiSXzlF5r1YaHjhsPNlNrrn9NB0xDxxbl4FZ+0EPdBmTy+ayxN1ZI7Q6Et/OQU6h3van7cVwis7aVFZN/mJsjLmgP4LuEjGSl/phMCXlX79hewIeoAkPsSIYQRRw==
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
 arch/riscv/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 15683ae13fa5..1056c11d3251 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1624,7 +1624,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 	if (PageReserved(page))
 		free_reserved_page(page);
 	else
-		free_pages((unsigned long)page_address(page), 0);
+		__free_pages(page, 0);
 	p4d_clear(p4d);
 }
 
@@ -1646,7 +1646,7 @@ static void __meminit free_vmemmap_storage(struct page *page, size_t size,
 		return;
 	}
 
-	free_pages((unsigned long)page_address(page), order);
+	__free_pages(page, order);
 }
 
 static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, unsigned long end,
-- 
2.51.0


