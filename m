Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E07FCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE1F8E007C; Mon, 11 Aug 2025 13:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5628E0060; Mon, 11 Aug 2025 13:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF26F8E007C; Mon, 11 Aug 2025 13:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D10E08E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:21:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 501F957BEF
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:21:29 +0000 (UTC)
X-FDA: 83765143098.12.04CB13B
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86745100004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:21:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bPNz77Ps;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754932887; a=rsa-sha256;
	cv=none;
	b=yw1yul08VWnvm0iXZ3CBLQCjGOmbxHIfsBee5m6FGTtZ1YBtEpUsocBaN4G1sbYjm00FH4
	xlb5S686CI3W6fkfFSZDKKXYGHaUJMyrqa72mNn69VWgkKbcJ1MUJUtQG+k4EoGurRy6pG
	5U6NRGYcxdGz+P8Truds8nMnaB8rs7Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bPNz77Ps;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754932887;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6Gl0kNWJ25/yIfPBpPHLOS57WlvYG3gVMGvmLd/BW+k=;
	b=4FiAirae31Qn/RRJX9bkVdXCtj49tEljt5eBI2wP8rqY0xrOppM2OIJHjNye/hcMVJ6vSJ
	ZQGjpHKT7prQl8yjLPpy1v0U0D7ttZO3GyUo+x3TVAGdA4CXbroN3nGCeimOs2yGXNwlHo
	hZL9p1GAO4JznJuNb7JfJusEXxMiEqo=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-23ffa7b3b30so42837455ad.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754932886; x=1755537686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6Gl0kNWJ25/yIfPBpPHLOS57WlvYG3gVMGvmLd/BW+k=;
        b=bPNz77PsJdXe4uhVILYT/37jnxw9QJc3PtL9vcIE3m5WHzAJWvwPfblKrV2xaxQvA0
         vBxXuIO05PO9pUfTwMguWt6mp/nw5mH+DwHvYD3C+OYgIk5SbAurrT0pB1KTZSh/A7/f
         DLTOEMXEi3T3NtfXZmeUK+618MHQNAjnK0stMR44h/OTChGfjsgbZuE+8HTtK4YrZ7pI
         NacWFx1AGDAvYNuB8NcaE5A7YxVwiB+oNBpCogcQLYyC0BwF+8fGi6bdWzI6xPJXAOjz
         oF9AxINtnpG2u0I/2fDFaQu+XW8+7OH0wfZe2edeAPBzRyuUzHohX+jiYurcao3hVLby
         09Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754932886; x=1755537686;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Gl0kNWJ25/yIfPBpPHLOS57WlvYG3gVMGvmLd/BW+k=;
        b=fCd0P6MKCDaws80OAQdL33We4mFNgukmAn3zpKZ/LHsZ2zPW/abQzlUZ513WlT9j8v
         arLmpSByoDSEYYG8GksFPJqArb9Axfax6izW6xDftsc5gcnP7e9AUwl89SBfh8YVFeIO
         kLGQSZQcFGDfCDGIW29c4YyMiMtYA8i1v8wHvtYwHUi4/or+mKhbC+9ujA3Cd28XI0E9
         pCdr2GRq6pbW1H1IFcedTv2ggzhJ/tRkjXHyX4b3InXeXXaIei6NmNd6HBMybB7mqUMk
         SelvGOfuT252EsX7QhqgHHoaG43SNn+wb+5/yB5/W/SGH/wuOWf3b3+EdSloGmrLHhsO
         vuEg==
X-Gm-Message-State: AOJu0YxyXdMcdDH/OttMSQENhwhl/3wek+ZpvZPAULGPYIAfZV7C/qBJ
	C4N/w300uJ8xusRg2uR1qRVbkBmdVlfjk7Lb5P3B7AibmR07FC350vcVVdnrN0vl7ic=
X-Gm-Gg: ASbGncupqYzPiP9hRSwu3Pt32KV2DFt81ApvSpXsu+Ov++39T4pS6hMAtNKZcOXfGkd
	mMgUd0ZJFFX2NdkDV+zdRvSwC5d5xnVHBSinrpM/vUoXYiqTqZSAG+0czXp3nEAxn3pcmViGkpI
	nFsaJfWo8khPAl4Xuwdfu1mkNFmGqc+rR0bANhN/42ZgDacPB2fkd6VnASXiSVHKaQJ788JnX0v
	KLsQbGWkAXxGxfDIEmS1YByr7uKGvdkZ93/OyL7bNa/xhswRnNp/uzX568Fx1exJvfcGK5aMQhE
	UcXz5AXUuvnhshq3jqhoqF2SDawqodfr9mDeHXT3JrCyQGV2i2sIJ24E96tHgZTUbsP+dZJnV20
	Sqp0l3AckpRzeodkdHjFQGEpqdK8=
X-Google-Smtp-Source: AGHT+IGwu3PkfB4V1Yv2mCO1LLyrkpXffWwmWfFaL+F4PID4txEpeJBXA0pgs8s/xYC7ZB4Ql852qQ==
X-Received: by 2002:a17:903:b88:b0:235:5d1:e366 with SMTP id d9443c01a7336-242c1ffce6cmr161954275ad.10.1754932885688;
        Mon, 11 Aug 2025 10:21:25 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89769fasm276685055ad.107.2025.08.11.10.21.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:21:25 -0700 (PDT)
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
Subject: [PATCH 0/2] mm/mincore: minor clean up for swap cache checking
Date: Tue, 12 Aug 2025 01:20:16 +0800
Message-ID: <20250811172018.48901-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u3jecqqsobxapw69fbymy99pebgcyxq4
X-Rspam-User: 
X-Rspamd-Queue-Id: 86745100004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754932887-185470
X-HE-Meta: U2FsdGVkX18k/3WSUUxm+fCrRS8JNGQMw+rcMaazehZFm0uXcgQCaZUrgK5no8xnBJ+QwzH3SBMCUVygqNwbdMf4QcxklMIjWPHYkt0VEc8qGbCtbo7a8EFL6AbNB0qh1vRbBhzUyvIyGMMgyOisGXwbyadi0u/Pq8RuPtCNB1C6afXZ7XEKniBHnOx9/VL/LGiRIpUlLlNZm3S+L3jQwPLenJkBbZTgi2JK8Z8PJnhlWNK79RoDg60rJMDdfAovFq2oc/xv5fk1cIS6O7h7rdocKwRGEGIeWHF4BoFv5ykaTLm7d+N7szB2nbiuksJVsBJOpsoGJs6fzortMPjYs3S0U2OH+L1sbqWBbYPekMCOurGnVi9sNc08wX0u2dLbgzC625vcpAaKVCn/2XsbuggYraIdb+fVhUTTqgB0TJnq24a4yEsOey3AA1AW9s1HPQQ1xLnRYf6kd3Yq3qVylQwm5D+P9noO3YuvCDEBKeS1b6KPUSig3q38cQihEE7nf4EBjHnmBA+5bf4F+iCihH+PBQC027Iq3A+g7oWL3EhpWV5nGsQyx7kwEK/LS6whXpK/9BOaGHHIeYJMBpxeifwbs1Vcftl/bqRNiM9wsEKD3peC8KUHY5iqy3xYMoFyTsvL+aG6kEbf4sI8/S2yTCzW9V9x6PWSomW5+XbbZMrYj8WY6h4Vcro02GOOqh4vNhbDrdQmPm/vGAZbJ5IulOmH3BJ3drOb3JBkLATNK8Unk60PTvQRKX3D48UzCHXevtkInPVGujP75kCkWPu0Twgx2vnQ9E1T5jkp65luuz9MXzWr7rrwSwOzoGhVpuDREdrav1Eu5jDX1dD/YA/IK+IN5NkCODQKvCGhukOn+U+5fEj9x1nq958oyI4Ka78d5jzmHxkCmEtnzkTJeAIqUf8BsCnralW2pX+VubkCSlb5V8qSYRFgumV8TnPQrLP8JDREvyH8B/2ukm9O5K4
 MQfr5aMF
 WOGwz871uzHqmBr2KFUBwirlJ0BYDMYrrmHg4KloKTruWkP+PlrleYfAkZNrIrPt627aArk0ptUM/+Q32hoCuakQksqqEYS+LaaQ81nIyudXrYO83ELx8Tjm/ME2n1PYhYLq0eD/m/MjnweLIuTM3sXft7SEls0MbwSFg16xTBY+A1ESN2WL3IjGq3nvOP0UTMgPNnWosOzfXTd+9dqNalgYQ4+FiX2vwczq1qw22xNf5TwhjlkgWJoau5UikzXX7ZyPS44b7EBLTpcO4c7j4aZlk5sL9kUTuixfIIcHM1fNXr7qO97BcAnPWr4iXAc8V34kMrIr8KZ3G/YKFUT4TYfvcgN/RymdWCNTpvUsIUD9mp3veJWKd8Uep12RZ5smysIL7pbV6oCoOI/nFA6GLGTfVpgyBQiVxfMHM+g7nQVZZvRcPB8+f2vQvRuQ/904dwAZnVmGH2cM7VKfeOb2MAztOkO2mXzd+SnSRNqSTRL9mX38wBTPEqUgRBkm0UyqgEdsnB+Mlm4hOla0peLSowyooJdsSzn9WDPcpEGIdzrtiXcwEJi9S2xYZQOJ89TIVhFV3tNnhjA51WfnPwzn7bEHBZFDWTsCl+R1ATBC4U9s10aie1HS9VIm55eYcY1l60yFVpWPkb9HvbUV7+qiy7UMqLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

This series cleans up a swap cache helper only used by mincore, move it
back into mincore code. Also separate the swap cache related logics out
of shmem / page cache logics in mincore.

With this series we have less lines of code and better performance.

Before this series:
mincore on a swaped out 16G anon mmap range:
Took 488220 us
mincore on 16G shmem mmap range:
Took 530272 us.

After this series:
mincore on a swaped out 16G anon mmap range:
Took 446763 us
mincore on 16G shmem mmap range:
Took 460496 us.

About ~10% faster.

Kairui Song (2):
  mm/mincore, swap: consolidate swap cache checking for mincore
  mm/mincore: use a helper for checking the swap cache

 mm/mincore.c    | 70 +++++++++++++++++++++++++++++++++++--------------
 mm/swap.h       | 10 -------
 mm/swap_state.c | 38 ---------------------------
 3 files changed, 51 insertions(+), 67 deletions(-)

---

Changelog:
- Remove RFC prefix.
- Don't touch the PTL for now [ Jann Horn, David Hildenbrand ]
- Fix error check for filemap_get_folio [ Nhat Pham ]

RFC: https://lore.kernel.org/linux-mm/20250807152720.62032-1-ryncsn@gmail.com/

-- 
2.50.1


