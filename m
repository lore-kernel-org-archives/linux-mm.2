Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C723DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6DC6B013D; Fri,  3 Jul 2026 00:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD146B013F; Fri,  3 Jul 2026 00:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3316B0145; Fri,  3 Jul 2026 00:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A32C6B013D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AA0040401
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:07 +0000 (UTC)
X-FDA: 84946147734.13.8273C80
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id D71ED12000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LtXB2I35;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052045;
	b=CCufsDpPagKb+Y3ropyyOptpplj6wNz3xBl4zWx0bb+2ZFZR88dAd0EsFgPB+7tNDLedDT
	2r8WCtXKek/EU1kShw1noGae5Jav2kCrnGvA3h6IVkxhu6b+SYaZhWQhGw+Y90fnZU1Lkw
	t1vdOAUBmqL3i3IuRO8xzdq90r5Eguo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcDVoZL/NYCcO87EVs1DzwCYLIxfylDfBkgHyvQhJNM=;
	b=MWGyxq1vzECQTIu1DPL0Rlkn2BHqHn7jz9Yi30xVjLea6RrlvZOlR4aRhf1w5eub72xav7
	5fkiPOdYJzM+9HmWkI5YQfxn84wj6BExntJlHKfEKs8MV9ykncqqq/gvkd9eienjhZziNV
	RXxGPQ95DBcWjAh6ZWq1RtOf5kWv6Co=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LtXB2I35;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so126493b3a.1
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052045; x=1783656845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcDVoZL/NYCcO87EVs1DzwCYLIxfylDfBkgHyvQhJNM=;
        b=LtXB2I35aODtGdF/evXW4oMnE1i7qP8cs0JX2SGsLP17G2mjnLKMv0Ud0JGu+SNRuc
         uEr0J20e0DNf1MvYmzWaNMBEjoSp9x2gxedF3aGaTT1MdsatDee8w9EckbtVtD7nk3zo
         6DCLlAAM7bDmPyUi9RQwa8S80bxaphuIgV0zwEZj3/uHoNG/uxOjdIz1t0kLsUn7IjFZ
         IJHcGqhAr7onZ9iRqONwVHjgbjSiWNGEdqk6VFqCKicNqN/ZzbqCSff+Dpf+DfQa+OOI
         ftkrPm1TYhlLkAA/VGhZTE2L9Et9TJEdYs7UYHbJFOHjN873H4l50Sw+Wi9dCoLRFVKB
         8tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052045; x=1783656845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rcDVoZL/NYCcO87EVs1DzwCYLIxfylDfBkgHyvQhJNM=;
        b=c0eIL6c3V9AK/dRf52bzrhPlXLEED32YYDEC42tUC8WWGFSQrWQxS1wiOeFd6b0arS
         aWaDhdIpDH4m4RwXjypWg7NZgh+Am3/gZLU72x08EcXM7kEFjqdI8lYgJ/mYutxlfo/1
         pLrd59ScjmyUJTY1wDp4s195sO1Ebkh56HuNuzJIEAtWHk4sO8ALSl3FtW0Q+ggNgo7L
         DWJihbo3ujBnFLAMMfcPw34ymXS4HjYhdzwUkzNnlw+xK7qX9kMPD3ZhCxDiyaw+x5Pt
         +jUy0RYD7uuoDauSi1vpgfDGnsmPJKMQW6bL+Sh3tmUXM3hbppJSh3MWFDmuOHZZWktP
         nHHw==
X-Gm-Message-State: AOJu0YzC67WLJ27fiExMoGNR6EOMD/1GFQhLmxAEViITwLA3YN3lS2MR
	6e61Mou2eMzco8G0RHzon4OR/JCCTKlrn0UVlftGp0VGUejpMoLMg6k+
X-Gm-Gg: AfdE7claak1/UhUGIldUvHxmlbHiuJuUeWWILZRVsBh0/aO958jtrTs1viutgFP8t0O
	VHV9nUfbTfPDn3e5qZDCNN5cbagunPIYFdKiLP2c0+ZOkrsm8XjQmoeetdZmgmtiN8W174cFeHO
	IGWlboE0sUuulUE3Dmmt0dImk+mEzq6McmHvOK9/7vIQZ2YcRisOzVk2bZQWxxINlX6/pH0jMNx
	FCcrhsuZ/ArmKN0wryR2PeaEGxHcW1TPsbv9SMgEv0PlxzD7T+EZJae2eOT12iDxSFzftYVyT3E
	zqaJe0YVC2vqYH1ZT77XOujF7HqF38TfwwxcJ926WHVYmjeJnTClbYpOzOvFs2qMW1yAYe3EvXq
	1qrPLqPSUxNiiMnZuE3jaKCSQOuJqyjxvWFqDJ8Wi0uxEgPGZcXc6EM0ZQummIO5dTVdla4t+yf
	C+nbR1L48=
X-Received: by 2002:a05:6a00:66d1:b0:845:eb00:ecbd with SMTP id d2e1a72fcca58-847e186ddf4mr2055507b3a.21.1783052044773;
        Thu, 02 Jul 2026 21:14:04 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:14:04 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	"Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2 2/9] ACPI: NUMA: remove redundant numa_nodes_parsed node_set()
Date: Fri,  3 Jul 2026 13:13:22 +0900
Message-ID: <20260703041329.2797584-3-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D71ED12000A
X-Stat-Signature: g13jwyn9o368cq3xqyzjx9ziryxq5385
X-HE-Tag: 1783052045-669345
X-HE-Meta: U2FsdGVkX19kHv7aNI2km2VyYatnG62vwDiEUmsut4bE4GrwGXxAMRDB7JxZOZesuMwCImJ+7Nu9XuOBrELhNRDkNTE7WkaRfitgCp4+KlM/X8cmIM/hcjuahscUDy3jVfhCuigvdl52kjYPqI9o2OeKVRSHya5A0YD2jAw+Qsoyg2WPNTZptXGCtAJXibpphEFJlNKYAEPDAvCvud0e+J3qKwBsdW2EnvUqwvhXQBWRKz7+dk/ezw3o6N/D2k2K2iobPHO/8srgOgeFObXTJR3l5/KGfkuLC8d1Wq4e9cP63gRm0Gu69huLn3E2YrnOpcYLduQ/tPvpC9ASlp23Sk0ehfwVF1Frpu7pWYMxYFSIEdswGXVvxBZhpOSKE1wmRG++L078IteiqPu6pnDgfdIJ0rEYULHzqf56bpKRhUEUq62P27nLj794OAS/45a1v7nzar+jYpskYymHvpIbKoKLg1YZBtZn2Ip0bqzERos0XiUb6517+c1MDmK1JTtK4mbRPWzp1vC3+gnj8LYti58SuyyGQKuBxrl4/vigB4fKBzMvCujdOAlAw5MYPRCABxg/jBbxdPqExpbmWEYdD38solwWFtA3JcmNhMXHpmPjFxaHEnRvh5ON7TqTrKHg9MjIciaN5oOV70sCPNUJEOMBfHNTU/Z4zPnuyRY78qvBIlh8s85Bmw3YWpfyllkXmfuEXsT4VepLe89XZ/N8ioV40EhLItCnvNzk9OXzga02oarQui/y0yVqQ/ErgclSpStU3pbopLiA2I6u9+Ppl5TKARyicl47j4GovM+DxX7ITXvloxmK9znAAOXuFvASQMu62Qa2eji52prnE+Gq/q5v4p99mNqJMPqf0cVB4M2OwFz6yu+vylo1T1lXbUkVJRDbEiNKwH7X9XuiYwBTlORNCvwf5SoZcjSG8XpBWBOO9CicA8/2CR1bAUDTYT/obNNsI2FXpIBAAPtyZNA
 +IQ6HWEF
 is3UQ+r734FxHAPRuwcRymv3Fsbkgz+znbMXhWNNl+o0iO36EsWm1LVHb0Ke2LEIYK9MLdZjlmdR6TTl7xbYkFEawqoBbKzV8taZtNOVN+NZZ4SHtHJedjviQTtqhPAZC24kSOVfJ3qFgpfM4+olUxg6qUb1NWWOBdmsFZV1k4J5AISSNYYaS+Bm6MWQfP3RokBXDBACU/qy5vlswzzcmpMX11KhZctBaXmo+qgqB7wH0BOBJIWrUCZMi+b2ebnGQ5yTnUfgFVlFkv04ayvns5IQxbOAQQBFn2wT5f3i0H3S8Pkt8uT/hhxchEiGi72+6DS635Xa+jkANtQlUCj8N4quiuNCLquif0iygoGRZir6LpH4t7ya7Q3l03iNdi62r4h7jI0Md0hgfypCfbaT+ZEcQ3j9Ob5dIBrVLbQ6BNF9ZlulI5iYsoQifxNZxAJXRHacpajvsQRoPnQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_add_memblk() now sets the node in numa_nodes_parsed itself, so the
caller's own node_set() is redundant.  Remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/acpi/numa/srat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index 62d4a8df0b8c..5c407dc6401e 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -399,8 +399,6 @@ acpi_parse_memory_affinity(union acpi_subtable_headers *header,
 		goto out_err_bad_srat;
 	}
 
-	node_set(node, numa_nodes_parsed);
-
 	pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]%s%s\n",
 		node, pxm,
 		(unsigned long long) start, (unsigned long long) end - 1,
-- 
2.43.0


