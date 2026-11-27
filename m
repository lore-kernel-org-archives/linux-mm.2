Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D5A606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dsVYjoXb
Received: by kanga.kvack.org (Postfix)
	id 253F86B05BC; Fri, 27 Nov 2026 04:13:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD8E6B05C9; Fri, 27 Nov 2026 04:13:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5BE6B05D7; Fri, 27 Nov 2026 04:13:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9A106B05BC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:13:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 429F71A0253
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:13:53 +0000 (UTC)
X-FDA: 85480336746.25.A2BDDA3
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79DAE180003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:13:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dsVYjoXb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770831;
	b=DHsaLGWfnmVseuQuKQLzx1X020GVk9d9oa4f812l497jKmOiV1NkZFzo6+kZ3o3T2x2F2D
	EIGP4iVtHgR9LSGq3TxkmatugAD1JWHWKk/LEBzp/D67fc8IAMvbugKRAdPswFfKbzHOX0
	GI2KxRghpTHWKlFx2wb2zkbZRWzPDKs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vD1ugKwXo8nRYXQGOzPiAdALB08fy8jaef2dV+QSIRM=;
	b=SvqJJDtLfEttPBevpZUM/NuCKx0kJtahkFDzdRd0tMAdxVPdlbmT8UAZYQx0k/biOZpbAg
	Ex0qBqaEmmg1Ge8DXVDzM+ZBAuoyZ+Vo9ZQZdXxabRAVFrw+J9ATuPr87C5VCXovxK1GCg
	vR/0VAUHfpo1Mjg5cg2s3rqPsQ8SYiI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dsVYjoXb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so77251765e9.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770830; x=1796375630; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vD1ugKwXo8nRYXQGOzPiAdALB08fy8jaef2dV+QSIRM=;
        b=dsVYjoXbGiDReYyPEpEF/oGD2tkDKmBU1Dv9EjCYdpRcKoh8SlEf0Defqv+ti5T62e
         NfxR9jeJjC439B9IeCumqpuBR8OG6ALWKzu0pmDacRt8iDBVsH9HpIdFavYqAts8nouk
         sG3UKwMbgz1V5IALT6zt5lhpudn6JXNkvR0/wPzGQrF8IUuliGpmoxgZf8pgLEABhy1z
         Cmr50ea02hcqCcry0uQ/oivcSQECKX87iIrXJgcsZg60mVKJGIJRxMBnJMCRSxBzX9H9
         5C9Nz8aETxqHYAid1ICBhRAohong4SwPV9WQmdi1Qe1McDaGNureWmyBLgzM5g9obzZg
         m+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770830; x=1796375630;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vD1ugKwXo8nRYXQGOzPiAdALB08fy8jaef2dV+QSIRM=;
        b=sbGhR6G9pFaLTaNNwliqF0GBtSSy6+eNXoPhbHxETxOY2dobwXOPrxqwotjnr2MVYb
         5DfrmGVb1UvHwzH8SWQHMiMzV8Eo/6jlIXFsxO8aKi8eQHpC/mylfUFDmX7dp7Nsr+Bt
         RkH1FmUfWS1Z9cB2dxYj9YpsJo//kIdnYC+5SQfV1yxSXtO4zRWYf4nQxyHpplLJyc6G
         TR9gm8JwHHWrzx+Kvv7jJ0lw7FU6NNLDqIzA+6GO3EOtOLAeashpcvYSP1woS8MS9MvH
         JIPuGYYo551leuUiejnzaXaSaj3X8Pm9ZqR3sHu0SA8aMqXyhYGde6eypMH4Wonw5tdA
         Z/TA==
X-Forwarded-Encrypted: i=1; AL+hErHzvvkL9PT65GmBzJW9n52cr/4pJU2jC2xGg4WSBAlT8WKxbz3nO0NeL6mrIzURhC9HwocC7Q2Seg==@kvack.org
X-Gm-Message-State: APuU4Z/75ZNGSo5FSVeQL8YYy7Ks+ODAJhdkUV/WCNux6O++ZPK1IcIT
	5b7A3qvXLFPsEB0ZvFN81gT4ih7l44vxM6vh2qQDZ/BSH2pPnaMtTWj4
X-Gm-Gg: AZFdTZcGkgWMAhYgdOfFpomKIADKb/DHe4fIL8s5O/0hxsW0P7c6EGGgYKqsXLnQ9Ap
	lWERtzGUGlI29vZ2C+5BcYya01ZvPlIV8pZYGKPwfD/RFSOvNGgQ1VFflrZrEVYogghYQUqyCXc
	lud69/lsOeJhijZ1rfTZJlqNecq7zLoNY1eCmJ0c7LySdw3YyfqvGOvv0W/rYwZDgJFRB1u1Ypk
	pcVp8ZS8JLAfluPWk+oPlLCQJAGZ52naSIvldJ0Rr24YS58vSsNvGRiHo/aVYO1y+xsKH2yGcCe
	Hhwob41XgK5kwpwtE4KypEZY9ZwbghIBsMp32XOJltpX8IPK+2Ew68rTWVCr/u8vqEhi0GJkDVM
	PjUGprklJlLygURqwbk2JO32OwPMUdxJTQMV8dpuWhTzME7C5qpw5Mj2LNFWQT8DRgFbUrQM/x3
	t+YHLUaccaJ5cOt4gIGrzaNQNp+0RoNQHmpBfClE+zAqKGIZAC5Qz+v8R/V2OAOMaMt6x1+uRGk
	N41FH2zyxmZylWFaUae1GUwrSguuJlmxOK2LXcFbPdrLXr3co1tzUsJOBv8TYylZ01GJnzdbdTJ
	XO+ztlOM8be7Xw==
X-Received: by 2002:a05:600c:4585:b0:4a1:83f0:7c91 with SMTP id 5b1f17b1804b1-4bb8882948dmr487962385e9.18.1795770829350;
        Fri, 27 Nov 2026 01:13:49 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4b1ed8b6a05sm26067087f8f.43.2026.11.27.01.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:13:48 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Hugh Dickins <hughd@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH v2 0/3] mm: don't allocate page tables with the folio locked
Date: Fri, 27 Nov 2026 10:12:13 +0100
Message-ID: <20261127091344.113688-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79DAE180003
X-Rspam-User:
X-Stat-Signature: gbffnpokjckn1tuogpwjs7osszofuxrb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795770831-349066
X-HE-Meta: U2FsdGVkX18q4OMMAS9kc4ENVM+U9fiOCehNgtBI0qizRveh5XGeASg5NrWmCkVK2DK3Ojkmrxfh9bxBwiG2BFnT0t1N4uGVboLfJ+DxE5jvya3hAhmao9K6Y8boIyzfrviSUyL2GJHMsUMVtWse3cZEN+gy0f6LvsriUQxnHLUIsp2u5wmBp2DC3b0CJfVEkwkYzwByq/226dsV6pNw1jsDoxNPLicISy/jvuO/wi3RJXV77fiMimnvlU5P8o3cqiV9Cpw7wV4JOgLBsYHJWtJPOLUzb8jdpp3ZmvxXuPJOUmTWqO7V9edZzR1NuQNSfiqink9K90rBIdO54UBzffcf3hLaoyp2/ibTBlzT1sCb0ynnzTZIlJzz5s7tjziznczDFBGgTUGki2OouVnvM/SxC3+T4mXaH2FisWwmqHtuNOIGNV9rI7/B3C7IBm9+vyLVS7YTy6No4Q1UkKUk11QXMW3tJ38ex3Zawq0FnizWNJ3pVz3ZJ3H1gqwk9A+LbJh1GvctHb6QnNU1stV5FmUxYxJX6RmrtCYK3P6Y4hFi0E/pGJWAtpuHSnQQHGxWmE4LERLrpY9iV6cNP12qK/qI+i9TP1bwEzbSepPCtWl9HCS+zi2IgX+wKS7yre4Iwb0Jk7W2YfZLUowaDNYUCk0JdDd/31XyDLgfT1bbA4o0rErWHa1rvj9sw5/kEuHFZozhB8Mf0OLZgrHELfm2mToRUh49ZH1qZQmSy771GQa2vAzW+KC+u7GtYzlaMFewo5U4ldGydHh7/3xnrQ+ewLKbQeSPOMDmTQ+fd2knwVK8LEXFwODZz1+Q58s9Jwem5tyXuspkCTH/U+GIFJINnaY7p6E+gmNc+lTKqM1kXMOMz9ZHEqE1UDA7lVUSx4PBWaMrcE3AkBheHt2EyGHYxuVypRVxlh1bIPirbtphtZkvVScZcp12iDnhxzb9+WTKBMEQSxOZWa1lL+jx9Ms
 268Gk0Cv
 vCD5c5mWcMcuYRBsw51AAVn7Yrj7foa4SpFW4HmZvbjSWnJXogUjRxY7lAc2Q/9U87sC+5/CUOvO5hF6rNSiysWqrdcpXDIOXVbsU7xGA7qnnDrYf7P+ngO5awapbM9Ch2RD4KAJgHM6dRt+BgncK/f9daA4QCF1x9OzV4V/MEghEY2zM3uuknjDTQPgp79IAKHb21hOrY5Ghuv+QPVoP6SBRGMH/Ep7rmgCZzBFVZez6gNofcEOUUgQyRA50K4vacM+BlkTyUqIckZ5zyH6HHdmR7/VJm5rfTOPPEtMa1U+lvtaCoj0L6cKT2xyLJaajfKiDXINMtD2zQ/JrZ8pUvrTyIdG6elo2KshYtpJVB/6h+t1LnT2JxBxoE1dzRFS9thWL6+MLdQIDzt1XyPWc5SMJHHRxmBQxwzyq6rojRqS1joQLzN/TAr8rvqptVgZ6iB/Qikr3IqwogGj8N8l0HoEKMLxxNaPHpmpX4pGc0Yw8wWz1U0yxaUgzayanmBcoWZ9VHcbiQrDf9LSRCSTm2Id8yfcHAWO4A1+qxfXi+M2XkJvAxDco5x0tRtD9viq1eqJEkYbdc+o7DqQkqafuV/xo+VEar0fdAyH8ztQ/VQP8rub59VmH+I7To7AMQfcFH16bAne8FKAdxOfPtsflRIVOwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

David asked for the remaining places that allocate with __GFP_FS while
holding a folio lock [1]. The fault path and khugepaged still allocate
page tables that way.

Patch 1 allocates the deposit table in do_set_pmd() in a NOFS scope.
Patch 2 does the same for the tables set_huge_pmd() allocates.
Patch 3 makes finish_fault() retry the fault instead of allocating when
the page table went away after __do_fault() checked the PMD.

Tested on x86_64 and on ppc64le with the hash MMU in QEMU.

[1] https://lore.kernel.org/66e5f9e3-17d4-4635-8919-c67ed562f9f0@kernel.org

Changes in v2:
- use NOFS in do_set_pmd() and set_huge_pmd() instead of preallocating
  in khugepaged and dropping the allocation from do_set_pmd() (David)
- finish_fault(): return VM_FAULT_NOPAGE after trying do_set_pmd()
  (David)
- drop patch 4
- rebase on mm/core.git for-next

v1: https://lore.kernel.org/20261125100058.15200-1-azpijr@gmail.com

Jose A. Perez de Azpillaga (3):
  mm/memory: allocate the deposit page table with NOFS in do_set_pmd()
  mm/khugepaged: allocate page tables with NOFS in set_huge_pmd()
  mm/memory: don't allocate in finish_fault() with the folio locked

 mm/khugepaged.c | 16 ++++++++++------
 mm/memory.c     | 20 ++++++++++++++++----
 2 files changed, 26 insertions(+), 10 deletions(-)


base-commit: c6f53520f32302ea64cbcfd7cc25a31081e34548
--
2.56.1


