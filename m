Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F28B2CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9F38E002B; Tue, 30 Sep 2025 02:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590EF8E0002; Tue, 30 Sep 2025 02:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7838E002B; Tue, 30 Sep 2025 02:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39EFE8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:00:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0849F87910
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:44 +0000 (UTC)
X-FDA: 83944867608.03.44413C7
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 144BC1A0007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:00:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lBKOZ3Oe;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759212042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHmEXjchUo7p5MNeEkw3mVcK0Ae4ArUpPhVglZardsE=;
	b=QnR6vXo1bTzcxVr7MHcbFejOHcfA3SFNQvkk0gwb0tZlct1dyRjaAR/RC9OlqMkZ57LVnN
	9qnWRw0GEAFW+L78q+SFsJMijZ9xTY5jthg4RAH0z1zt50AixPQ0AQcbhYWh4VHFlqQIce
	L4JdzIT8woNBRpd/N8IMWmpZ/meKL74=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lBKOZ3Oe;
	spf=pass (imf19.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759212042; a=rsa-sha256;
	cv=none;
	b=WJojTqPaAZy0f7MxD7B7deSAa8NA6F2BA7MeNj+VnAYnOs8ss+9ZgJZV5lUhjqrhrx7ytk
	6vB2FPAk9+2VMaZTNYLXzaZZ6h/H+Bh9c/FzGWtrP2lioaNc/31tVi/kxU1fm/bHDTOB3+
	lhOpWaiPO/N0fsipwmTlSV/urmdRN4A=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27ee41e0798so68617485ad.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759212041; x=1759816841; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHmEXjchUo7p5MNeEkw3mVcK0Ae4ArUpPhVglZardsE=;
        b=lBKOZ3OeQzzbYU5ppBemc74r+zfAttLF4XghMZaJGaBht8q0i1QYPj6DzTumXnRZBn
         LASQ7tUTIQvMciVz7WyQ8BDcO/dkJQApe6nUE0UK6SFhD5uxb9vNDDuupo+bw30DsJ1f
         kdQwuQhEKHxX/GxjdP/0GDUpPKfxmvkQCRJX7IPnFMSqy8FibD/i6A839kooAG6GqBAZ
         khQ5kE+dWk+tdpWG6KvjEUgBW7kdjdv3JvdUAK156l0NRUfeiIU7W366LDE6qooV8Ep1
         PDk2nYFYFplHHQf7S3HS2fKNim9nB9C0tjziTOQ4R6XXJFSonPDdgEDmkYIOeSBBRAH5
         zscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759212041; x=1759816841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHmEXjchUo7p5MNeEkw3mVcK0Ae4ArUpPhVglZardsE=;
        b=lYbRYr5aIepyw1cmt1EzNXDvjuMZRx5qkvUrQUFWN0UU7ECgNQZacajG7/plt63jlr
         Yi8NVJ+JPdQ2jjWHqvnxSlKpKQHrKjcqVVXHaCnnGMMjsbAqssXqk2p2/fZE33/kOakt
         HLAuk3oSEmHQJe95UEpj8iL30OabJ1s43aQYQgEBGoRIBzAZU363tNTFFviBYtGqNemZ
         Whhx5Qs3z58vecszX4fPe0EVTxXZg87lGM8DB0SZjc7r0F9UU6k1ahW5zD5Go3yuMXFe
         KsyqkLcHsxzVui1F82NLcZ8UJ9QQC9VxenJxaiinpAeLqI0ClV27viFWy0Z8Fr2RGMw0
         Krxg==
X-Forwarded-Encrypted: i=1; AJvYcCUzvri35G7JKBGphdLhQdeRhnWvWidQ1htQ5t2G518qsCVzMROc2QEJzbAkBBqFQiqn5bBcE5orTg==@kvack.org
X-Gm-Message-State: AOJu0YyXVaLONJxw6zTk7w4P5Nrzdy7CgXYuCcALQpWIPh/7fUICe/My
	b1/3CBPlY8UjGzQmy3OZTXqXIoDqJgbMOhVHbtBm8L9/1zY9uORZ0pqx
X-Gm-Gg: ASbGnctv9d6S9YZOOh2UrRMUyKEuZhJVxJsfcQrFAZqv2rLiWhLrR3/zJjL8z/ryJfC
	m3jMSHeBxXuIWztGW+DO9CFIQghHwy+RI2HH6Q3KJn831ByOx8oJ6aHuz5V4TParpjE0+CxnQWI
	qlxlKTrSd2RFkIk8QCCtWh2YVTnSnZTiuO4EHWZOD5FYrHOCqmm9yjIJUKWsSE/c7AI6+5h9ymo
	VAEH0FhsnGSyRasjALgjmoHLpRrwSOYpmfO66C6oUb3VGTOPBjkLx/j8szlIHqN/imnoVhrQXSM
	xsYMTkVPOv6otTD9zUhPAoK36IDb88qIs32MtoQqgjkb3SrzQd/6ksNn8vYVgkOcWPlErtfQ2RK
	uQl2C3rAjjPKNxc/YY+/xsXkWgoW0RepJIMzHpoFtiHNT6aPKANfpE+VZTaECUhwfRFgPFNuwrJ
	xNyt2STne1xvAHVgK4VHxGuOU82XZIGkD+X5Yc7g==
X-Google-Smtp-Source: AGHT+IESjK5uuXD6SNUTqXGKn8jpixgQvb75Jnts3CNC+W4F2sDEPtoAZ7lXfxrqlZpJ+kSZvlFegw==
X-Received: by 2002:a17:903:2407:b0:24c:ca55:6d90 with SMTP id d9443c01a7336-27ed4a7448emr222073545ad.61.1759212040904;
        Mon, 29 Sep 2025 23:00:40 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.23.00.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 23:00:40 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v9 mm-new 11/11] Documentation: add BPF-based THP policy management
Date: Tue, 30 Sep 2025 13:58:26 +0800
Message-Id: <20250930055826.9810-12-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 144BC1A0007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: f9to3rrp8tzc8oqtoc7njh5ken1tqt37
X-HE-Tag: 1759212041-282118
X-HE-Meta: U2FsdGVkX18ug1ZYQIAWJPyUkEVVHqJ8DkpBgMiJhrp9cjHU7rVNE7uOwhFsrGcd23D2up5mbea092rtREF2eoRkepeEN8TL0MfhpDfdBMi/UqvpD2Wo69t2y+jP5TlQlk7zArxeo8gxxnV2Tjnu5oqOvMunTnclf+D5bIp9PXinJzi2J3+S+e6vk0v1BVgN5lkQJMSM/wvrZqh3LaPN2z+hzm+IYD3k3lBqtlG+1QMS6SOo6/eDQzDZ/9EL+JdyfC7XISNZ17Z3RRqOnWsUR0O3o9rPGiTxf3xGDN0sjEHz4crTFNKo6KVr6FKuAJ2x3XA8aFkXzWPzmH5jk9Z9c6wR347+pV7ec57tpSgGyD8c468PunZvTOcuuGWr2ZkIZMV4xBUPcI8oRDTr6mQvQp/6sKBWguPh31VRg7RMYcpdnEnbI1Qo5NkNvKfusHnAaZinX4g5OFSJABlBLqvb0U6Muwl+3+7oJqRLxTpR0ri1gKbc02vVmZf9S8QfhKD6WAlRHIQl7Je+i263sfUoc6RYvgeRyVdtisnMVWwt1UBDXqmscnm4kcBtV7Voi/aqPdqqa8xqWYpVAgUl3NhcBJcikWXUZisCtHN9rK65DHBdkDBFc4L9Nml2hMDFOoAnzxWc3xN0yrXdwqis+j8Ck9N1Y20YMUSGyVKcWmeL6VYXMiCNQfLKmv57V2lRVCFG3E6Ro5599f2QYK0uMUqDHJr9iDW4SaPsR1OE2/QQYLUpSV3IX1RtO20VOy/gnL7P1Ab+TefItlrixPXHwLnwNBPVEtP5P5JSKfYb2wuyfPJBOU4/r5Be9V2PUQNfPp9QLGCMD3ZrEHGftZR9iFDYSu/+tF4imrpHdF3daO5Wv6rmipSB3O8klw2trfUxXCvHF1hwgLWBD59ckG/9SV12OMT5w5H5MbNqtGjWEfo5L4yJCR7AfMUh10mCpcmE4LakGic2FkLVu1oaK7jEdRQ
 NemmSyc6
 PgFq3xCRPXHeLYv/CVbljiVjM69os3ilUxhbT5uNMy/pSHzZ6NJ9LwKkmuwhUu5tQUoQwlYcx21CdnGBfuAMJ6a+Cr7xxJosBB1c5ADH7IUG8Dx4UJoaLJVUbfZtbd9i74nLfs0SumghcLsrLzciL3R9DxvJCGowerukcWs4Q26dPOR2pec/pcarof662f241SI8W+r6WUEZ8i5q1iORd5aI8tDymEc486iLppz4POq7UuD06dMMzbJ+m2gLTfVSW3Ynop27ONgbVxPn9Rqa8fkUw/WhqCWwqNQMiwzGJmJJbKC7u/DZ5ubg3SERCtNm2HWKza7cItGeq6CDmjSYPoWFLII1kLEFp4FKJmPY+KPaNMw6rD+1ZNVzAOd0gHe5wCuYN0PRa1SESMCmtrM52OFLEvq7rKxs3l2nSY9oDLmmKRMHgxMkODsMD+kzRsSrDNMF3UkcubJpBCQmB/Cs54JWmA8eopCrfHS2QUcsdcbau6JYDA1rYCd147nnykvqTO+PPxHyp+LSOYAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 1654211cc6cf..f6991c674329 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -738,3 +738,42 @@ support enabled just fine as always. No difference can be noted in
 hugetlbfs other than there will be less overall fragmentation. All
 usual features belonging to hugetlbfs are preserved and
 unaffected. libhugetlbfs will also work fine as usual.
+
+BPF THP
+=======
+
+Overview
+--------
+
+When the system is configured with "always" or "madvise" THP mode, a BPF program
+can be used to adjust THP allocation policies dynamically. This enables
+fine-grained control over THP decisions based on various factors including
+workload identity, allocation context, and system memory pressure.
+
+Program Interface
+-----------------
+
+This feature implements a struct_ops BPF program with the following interface::
+
+  int thp_get_order(struct vm_area_struct *vma,
+                    enum tva_type type,
+                    unsigned long orders);
+
+Parameters::
+
+  @vma: vm_area_struct associated with the THP allocation
+  @type: TVA type for current @vma
+  @orders: Bitmask of available THP orders for this allocation
+
+Return value::
+
+  The suggested THP order for allocation from the BPF program. Must be
+  a valid, available order.
+
+Implementation Notes
+--------------------
+
+This is currently an experimental feature. CONFIG_BPF_THP (EXPERIMENTAL) must be
+enabled to use it. Only one BPF program can be attached at a time, but the
+program can be updated dynamically to adjust policies without requiring affected
+tasks to be restarted.
-- 
2.47.3


