Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2465EC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 15:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77DA48E0005; Thu,  7 Aug 2025 11:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755518E0001; Thu,  7 Aug 2025 11:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B608E0005; Thu,  7 Aug 2025 11:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55BD68E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:27:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0127DC0FB7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:40 +0000 (UTC)
X-FDA: 83750341122.17.BD3CA17
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3128E1C0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:27:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NNaQZqFI;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754580459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DwNT7dW2/m7U6b9mOpn50Hlu8qReyNYgvDKR7CG4bYw=;
	b=HVnbM9h3Tifsvm63r2apgQDBUoXFFyIxVB3UjvgUH+KpmEHfzOOUgBrltJYIgKvMCEXYJ3
	FnYhRYx/IaPTMkQXfgr4VLO5r6GNyzhCcY3BOswCaCTE+t5McHnvKMOHrFTQqV9dOO+6cB
	GbA3MLBhZ22yrXEn213BlY5LZqa2hyg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NNaQZqFI;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754580459; a=rsa-sha256;
	cv=none;
	b=x/JSMasb0JDF90JYklhPEgsG61nluqEU8fHnNHbDKPyjG28+baqMrfdvH6KXGcaKvY0oMw
	XlNGpqa7onBvJWWhV87kZ+enjp8iTL66qcuYeEpNbBCV0NZgCkpnq7daofLfJAYJdkakaE
	7wj55ZFj3ZSfBz2M5JkNDnYCCvlE6D4=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76bd202ef81so1625659b3a.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 08:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754580457; x=1755185257; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DwNT7dW2/m7U6b9mOpn50Hlu8qReyNYgvDKR7CG4bYw=;
        b=NNaQZqFIL399kGXfJlPqKv4wj9ygQFWC5fcpxL1CeakJU4tSICXG6rcLunk2qhxwfQ
         1LFnjCuR6EWPKYmHNzMWRLBft+jJdqqL9q8lzVlMaVI3He4vjzGtFNLs2uT2KLylTLz8
         2vfSUOO21VxuTSKVFRViOF0by93LtJTnpMVuZfdKI8uYVA7AYpTWk7Bcs5YB2gTVC3sD
         O0Huc4teSM2uZRf0zTv+esywsNZqZYLiFj6C7cSGg/CS/tNG7SmfaLYjj8MPlRwDD6FI
         mZCrlUrb46MTi1EPG5nhY38nj93g17rGIl331XVt0B6ta9Z5WMPTogqpTHmkj2GxYBs+
         DcFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754580457; x=1755185257;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwNT7dW2/m7U6b9mOpn50Hlu8qReyNYgvDKR7CG4bYw=;
        b=ZH6CxXrT5Hqyo774NWYTjekydSyeL4rldxajajpLjY+5BxnegBNrbMn6FCDJr2OI+Y
         5ckTJtI3bJPdvTpzLQuaqIzoZYe+fSRCmIzRWXsoRbtwklQ64wui2wi/x+opSfn1zd2O
         Elz98GtFWLdJvN/Ep6i1CZ1zp88PKbUnkWaNdUkByvMncAJoC34ZycmDN5MaaQ6e5loQ
         b+8oW330wbVKk0m+ce9o6nVHFnuf+gkM75uKBj+2hNqEoJAT4z7P0l23AthzfvIHrACR
         QLKgu+mRvaMjRcaNS3Vlr03TnUMD7OTfvM5bhym3HNrR2KmJHcmFBilHN1G38U/sqkoP
         AhCw==
X-Gm-Message-State: AOJu0YwcS6DutY8uT38548xaJmOdQ4uyksXNkAxVI/1PJnqRvl5l7GkV
	GjaiteaIVhVzxFFc/y35CkskuBOjvV71kx6OYn+geslWPv2T0XAv4Okf625W2CwoRuk=
X-Gm-Gg: ASbGncsszsqGkiWyrBW7DeQCY5Q/v1ZRSwb/++DpYPB8JnRU+jxyhJVO3VhxzldBQFM
	lC03O1uJXg7nGQbNYJQePj/38Wgw1u+MN1mu9//12sBR1/+RDlMFmSzN9LHquOYfhc2gNKl2cRd
	j0UlkNwIUcV+WMjAAQOE4J5vKIxapbRQT1NyiwqJlJjtUrLFXtjrfK2pFPsCgxY0tQwP5b6QHik
	eUaRRSmcIEl4Z/ehlanBpZAkK1+nUBVrW4lgWJjE/tVgCApdeBsShAO7RRcwWoaDHbOBgDuF8B0
	ZE1GVGlrfy0YDr2Th0mAeg8BVYIebitwSdv5EeBLsykQ+/H1r3zE1a1/+AL8qdXr+q1Oi3ug33v
	fRZ8fTaRTsfQqHTwhXkz3C6gKZhvJpXBLjv79wA==
X-Google-Smtp-Source: AGHT+IHUEMkzIs6sGCBEK7uIhxHW9mD0/IfEBuS7WV3HY9lgjM/Si26KklbYhO8GRSVlZzAmoRamrg==
X-Received: by 2002:a05:6a20:3946:b0:230:8b26:9d47 with SMTP id adf61e73a8af0-24031252281mr11358527637.10.1754580456487;
        Thu, 07 Aug 2025 08:27:36 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce6f319sm18430540b3a.18.2025.08.07.08.27.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 07 Aug 2025 08:27:36 -0700 (PDT)
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
Subject: [RFC PATCH 0/3] mm/mincore: clean up swap cache helper and PTL
Date: Thu,  7 Aug 2025 23:27:17 +0800
Message-ID: <20250807152720.62032-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yd98kuetw9zray8fj395tiiz3dib9rko
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3128E1C0006
X-Rspam-User: 
X-HE-Tag: 1754580459-903575
X-HE-Meta: U2FsdGVkX1/JLZaZwPtnfxW9ksCnCu8xmNI0yGKMJNgFPDgoV8TVtL3Ho1EgES+B0F4YQjTWNZRAHWao/m4Ew+zjREF3MkWkJKeGcvPNnG/LoAQDJqqj8ztxp8eWWxskLfImP6PuH0kGBoPcVTcTlPZlhCd03CXpiHMF/7n5DAfDNUZAF257GFfdd8UxAX5S5eMJDT+wUeM1yPYLRE5bbvRS622AlcZQPfe4H8GU29Eb8dqspr4IeqDq2iJBsEbWrBBUq3WX9N6TGPbhtINxotkkYZ6FOxqN4K/JH3QTKq5GToIipEk+F1YXlUDIg9CRY5wl3O6gQta5AtHDOBp/qL/iEnJq8JZMhUAIaFsD3aXtAkgxQQzAtn/zJS7XCOQAnZosgJ+ea7sxcw8qRXyHJt6jzCnVzfYRfpNsfSXgbtqo7hy3aOE2E/jqU+yt3SieCKbd91PaWvOSL/cHiMF8w/Fpd/VslGC3KmtYmw9ALGaMO2QqncUZJJ53IaTdeeiV7dOzbTHzDEZhFrSkfyNJ18MguKyCn2dURAzeuR8rgazpgQg/Lthl4jTxdweLevk0y08jP92cVllqcX/sRaQJgAGliaIVW32P5qq8SmvDRjtPU4EvfyfAJRcvTTiqMPLIxoaHQQbO2HTYogxkDP0XRbpI9mnzJWXGcccxTvYBUEq8QrsbjlkioPgNbn4/tm5bxGx/SUSXiG/+LxRyBJPqIkAWfcM8LE1rfigIXbcefkvewnrtEQBRhv6TcJcIaXXHQ7O8O/tq1Q28iRCLyxI1YS68C9U26UVN0wCn16ETmB88vA4aQfMbAT1aQxR4PJxhDybtaT18KZwPbPtlLrZ8Wd8FMJke2LqipuGwe7MJt6GslWoLuDSOyNkLgtlypc7/G0+h9O/UTX6Jp8dU7WjG4KMw6Adf0CpeZvSEeO1VaXcKhZIsWqubKSyOFsRPWNw4QHt1F/ACr6XmLjy9P5F
 uubKppAh
 1Cii4iR48SVXnBlMx+EPZ4noR1NS956VC8C/VwiM3S+KoPTK/P2TldiJgJK29hh2QtJ6aptv0h3bvZO4d6dq02gW/Xlj6UBsWmi2lNW++IEggRLWm/2CoNMQ+tlST0C9gT1W5OiWOenFH/hGSaCJ7HTt7kuOdDLYzpOe4NzF6raIkgbd/lIcuuJxXP13GSF8btDLdm4k/MfkvYwqEDLui6yFLMtVkSU/jeg5rsygd7MXbLhEgyJTFXQOSXtisg1/uGwp8FoPLFA2x45S1sjDI5VmXVOmxXcGY+GEDWMtv4lXc5hNBes2udowdprPiYEJoER8b3SvzIsmFuSRmCxdRKvFXNGP10rr1xm8bTpQZ24/fxsh5hGQY4avBD/mb7Vw0y8WhR2p55TUWt7KDq7UR2nWWkHs/4pH3DUgaQAVYV/WjFZk++otRTD0Ecgj6SccW7BJUbGfzdWAfvWx2A/7EqOi/Tr7kmI6hrpzzEFq5lrKbFNB3JE8Bok9So5v/RnXXjqviktTbGXCtf2UesPBVxgEcYcKBnsVnURUwGEnhzwKd5j/VGzMf14k4hEu0CTVREEA1rNSblrQQ/XG3b2BjypG5whk3B3XuB/zd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There is a swap cache helper that is only used by mincore. It was
seperated out from mincore some time ago to be shared with other users,
but now mincore is the only user again. So it can be easily merged back
to simplify the code.

Patch 1 clean this up, but I'm not very sure about Patch 2 and 3:

Realizing that the PTL seems only useful for stablizing the swap
cache space now, by grabbing the swap device before looking up the swap
cache space (patch 2), we can drop the PTL locking (patch 3).

Let me know if I'm missing something. With mmap lock, the mincore result
should be reliable enough without the PTL.

Kairui Song (3):
  mm/mincore, swap: consolidate swap cache checking for mincore
  mm/mincore: use a helper for checking the swap cache
  mm/mincore: avoid touching the PTL

 mm/mincore.c    | 53 ++++++++++++++++++++++++++++++++++++++-----------
 mm/swap.h       | 10 ----------
 mm/swap_state.c | 38 -----------------------------------
 3 files changed, 41 insertions(+), 60 deletions(-)

-- 
2.50.1


