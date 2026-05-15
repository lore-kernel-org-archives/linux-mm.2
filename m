Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE4CFCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3436B0093; Fri, 15 May 2026 05:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972176B0095; Fri, 15 May 2026 05:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C55A6B0096; Fri, 15 May 2026 05:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63E086B0093
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:48:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C4ED140894
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:48:04 +0000 (UTC)
X-FDA: 84769178088.28.9D2A83F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83BF840007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:48:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XHWLYlG7;
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3h62kitl08ea3beBtgH0dYPBq1vKLHYc6O3MIHUEOS8=;
	b=7MHtkigffmc9tOf48kmUu5kYy8GmsDxzR4JltUushBS6FyIL0Gfw1iaTzpsOP9uKgOg3LZ
	I1akfRBe/GO5w4MFbbjt7L9fn7ERY8wM1coesDuPMG6Tuxeyu9wPsl9vjloPMbl9wzPFdS
	713KLKZFi17icTXAH4DxiFdEiGQLheQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838482; a=rsa-sha256;
	cv=none;
	b=ocAeSopPAU/e4iRUWYY4wNoh3i/pd9SIXLHbEobcLoWDEK7gDeRZoQZUxIG6cj+lp7W4s0
	+CxYmDlJxm8fGQUs8noUtm76uAasWQC9uKyuKc3RgJxjI8jydvrb1yFX1s9p3cjMvPLGzN
	b/48bkpyL7Fqxodn4ZV9lQs09uht4dI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XHWLYlG7;
	spf=pass (imf12.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=3h
	62kitl08ea3beBtgH0dYPBq1vKLHYc6O3MIHUEOS8=; b=XHWLYlG7+KqOBkTKp/
	KruqlCrsicnfTiSCXpoZ9ULV2gVGB+JZgrSnGKThIvV89lD5iBAEP5QnFm9MmXFp
	B2MuF57F7gFhmiKBLsXu4Hnp2+WD+H+s1aCWt7g20+p4fvRsJFlxLoQPrWuI7EFb
	I9UIH1Y80mrABb9zwQ35QwkpE=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBnVxek6wZq6RobBg--.38248S2;
	Fri, 15 May 2026 17:47:17 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 0/4] mm/shmem: optimize read performance with folio batching
Date: Fri, 15 May 2026 17:46:58 +0800
Message-ID: <20260515094702.1092355-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnVxek6wZq6RobBg--.38248S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFyfGw47tF18KrW3Wr15Jwb_yoW8XFWrpF
	yDWas3tr92q34xCasxC3yvgrWrX3y8Kr4vqrWft3Z8XF4Yyr1FyFn7Jr48W3yUCr1fJF17
	XFyfAw129w4j93DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07ja89NUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC2wVA3WoG66XMJQAA3I
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 83BF840007
X-Rspam-User: 
X-Stat-Signature: bdnp8x7hfhrckw7ppzcxpsq3gapuugoe
X-HE-Tag: 1778838481-579105
X-HE-Meta: U2FsdGVkX1+zLqKX8R/GPOLqLNinU5KsvSxO4w6/e5oVq0uz1N99InuMhvwW6WwU36oz1VwxLXOKm+ybevyIX3kdT74adnd++4ZWO6v5NvQebkAPf4soXCaSgLF67PCKoNrTCE8ChGvM9UX+AxMsSwR811fhCDPSSihof4hfyRC6y4nG7TscDj7YDCRXyX8ocWfvX19PQxDV2rM9kAxjT+FA3xhrbCpGgNRUMl7HygF+8PrMs5fkpQTpKwwMyh1YrQVKWvd/j15sOHayVv1ndCc90LQzgQW0HPKT/pW5fDoOmfDIzbAIt+FP/uzm78KkTpiwIurztI9ptPlmoPLLHgBD0jIfkoazi44fvas4mD9hG3KzKByV4q7ChabXdF9uvL5OtgnAcmaBbzb2hh3qSO8/PEr2KccFpJ9Z5cOiBFfBHoYeY3TXRGfrMlqxOKb2OraOVNfq33STvpNKeYB6AQf5IIRvJ5CGpnMngoXWTyjGLjr6s3elkohQXqw8+9AFYn6gJua8sngRIQzBKm0F4DBwHCfoUWq1ArkPn1viBI1XfliWF17Gusxdg0Ip8wSKZVnOMhFVpMys41Q1OTqOoe6OH0Lo2sZkvsqxPgkt/CxUtyyqQCOobEaxgFu+kVCjo0ycAx6BzVyj3gaGI306s0GibYRiiGJtvVJH5N8mZ+JclDDgjnQ/G44cWbDgL4m/H7Ivu22AEidTwNvz4oCnWITjNJJLpFQ2mUAGqJVhYoHzNlSCrbcbpiCVaMRSbQsYO9zB1xzu9/eHXi69px4Pw/21wI1mmCVuok1lL7SgkTJjg2b5ii0z5ftiNXcfeAjVtMsxlIM85BEr6KLszs6xlvVAkUb4XPagDUf+HGu4I98Syvw5Hxr6My4IoChVqyI7gCEi4OQVGpipD5hxTyLAmGmxBOeUBGA6yTTq1eOJHZ3PWzjv9r1W1+hr0sZbU1LqS0XNTuL6yw/C8/lXqGj
 pvOKNB/7
 9R60tVMZ1cmg7kKyH7BvPAaJoEXCBR1OFUXDq3aTPtFHEcQ6LEK0+tljjZwdSP1dhaveJwRGyhoSBb7/AmmHiFtIYOhzGRgNg0ee0Zd1CctZVyCwuI8zz1BCzEEnQ55+/laLk1jtwOUp6E5PGJtnk5p/Kc1ESzavPqvCJrv/kPesTV43j5O3k5Is8Tt61U0e5aoQIC1mA5hPO3X84qafuxSUkfWsiRXdWry8iuJ73LfDnXKzVuj950WvU4+QXDDAF813UlghzTi8dPwbeqzwSn5ePZ6f3mquFIEt2+4INXGvnPzEFiqmP0ruVG0Ew7Xe/2Z8LT1V3ce6G8EJmKHTVUFe7MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

This series optimizes shmem read performance by implementing folio
batching in the read path and eliminating unnecessary lock operations.

Performance testing with fio:
(--ioengine=sync --rw=read --size=1G --runtime=120)

shmem (THP disabled):
  bs=1M:   11.4 GiB/s
  bs=64k:  11.1 GiB/s
  bs=4k:   3814 MiB/s

shmem (THP disabled) + fbatch:
  bs=1M:   12.8 GiB/s (+12%)
  bs=64k:  12.3 GiB/s (+11%)
  bs=4k:   3783 MiB/s (-0.8%)

shmem (THP enabled):
  bs=1M:   13.8 GiB/s
  bs=64k:  13.1 GiB/s
  bs=4k:   3851 MiB/s

shmem (THP enabled) + fbatch:
  bs=1M:   14.0 GiB/s (+1%)
  bs=64k:  13.4 GiB/s (+2%)
  bs=4k:   3811 MiB/s (-1%)

shmem preallocated via fallocate (THP disabled):
  bs=1M:   24.0 GiB/s
  bs=64k:  22.5 GiB/s
  bs=4k:   4670 MiB/s

shmem preallocated via fallocate (THP disabled) + fbatch:
  bs=1M:   29.3 GiB/s (+22%)
  bs=64k:  26.7 GiB/s (+19%)
  bs=4k:   4654 MiB/s (-0.3%)

shmem preallocated via fallocate (THP enabled):
  bs=1M:   24.0 GiB/s
  bs=64k:  22.9 GiB/s
  bs=4k:   4698 MiB/s

shmem preallocated via fallocate (THP enabled) + fbatch:
  bs=1M:   34.3 GiB/s (+43%)
  bs=64k:  31.5 GiB/s (+38%)
  bs=4k:   4689 MiB/s (-0.2%)


Chi Zhiling (4):
  mm/shmem: add SGP_GET to get unlocked folio
  mm/shmem: use SGP_GET in read operations
  mm/shmem: optimize file read with folio batching
  mm/shmem: make SGP_NOALLOC succeed on hole like SGP_READ

 include/linux/shmem_fs.h |   5 +-
 mm/khugepaged.c          |   2 +-
 mm/shmem.c               | 132 ++++++++++++++++++++++++++++++++-------
 3 files changed, 112 insertions(+), 27 deletions(-)

-- 
2.43.0


